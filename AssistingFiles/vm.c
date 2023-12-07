#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"
extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

void
pte_er_jonno(pde_t *pgdir,pte_t *pte,uint v_a, int alloc){
  
  char *a=(char*)v_a;
  pte=walkpgdir(pgdir,a,0);
  
  //present =&pgtab[PTX(va)];
  }

int
walk(pde_t *pgdir, uint v_a, int alloc){
  pte_t *pte;
  char *a=(char*)v_a;
  pte=walkpgdir(pgdir,a,0);
  //present =&pgtab[PTX(va)];
  if(*pte & PTE_PG){
    return 1;
  }
  else{
    return 0;
  }
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint a;
  struct proc *p=myproc();
  pte_t *pte;
 
  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;
  //int i=0;
  
  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }

        
      //p->page_number++;
      if(p->pid>2){
        cprintf("pid,page_number:%d,%d,%d\n",p->pid,p->page_number,a);
      //cprintf("%d\n", p->list_arr[i]);

      if((p->page_number)>MAX_PSYC_PAGES){
        cprintf("allocuvm: MAX_PSYC_PAGES er cheye beshi hocche page.\n");
          uint va=p->matha->v_address;
          cprintf(" va  %d\n",va);
          cprintf("write er ager offset :%d\n",p->offset_swapfile);
          writeToSwapFile(p,(char*)PTE_ADDR(va),p->offset_swapfile,PGSIZE);
         
          pte=walkpgdir(pgdir,(char*)va,0);
          *pte|=PTE_PG;
          *pte&=(~PTE_P);
          
          p->f_page_tra[p->page_number].offset=p->offset_swapfile;
          p->f_page_tra[p->page_number].virtual_addr=va;
          
          p->matha=p->matha->nxt;
          //p->matha->nxt=p->temp;
          //p->temp=p->temp->nxt;//changed
          
          p->list_arr[0]=0;
          
          for(int j=0;j<MAX_PSYC_PAGES;j++){
            p->list_arr[j]=p->list_arr[j+1];
          }
          p->list_arr[MAX_PSYC_PAGES]=a;
          //cprintf("pte..... %d\n",*pte);
          
          p->offset_swapfile=p->offset_swapfile+PGSIZE;
      }
      
      if(p->page_number==0){
            
            p->list_arrays[p->page_number].v_address=a;
            p->list_arrays[p->page_number].nxt=0;
            p->list_arrays[p->page_number].pGDIR=pgdir;
            p->matha=&p->list_arrays[p->page_number];
            //p->temp=&p->list_arrays[1];
            p->temp=p->matha;
            p->list_arr[p->page_number]=a;
            //cprintf("p->matha %d \n",p->matha);
            //cprintf(" virtual address mathar%d\n",p->list_arrays[p->page_number].v_address);
        } 
        else{
        p->list_arrays[p->page_number].v_address=a;
        p->list_arrays[p->page_number].nxt=0;
        p->temp->nxt=&p->list_arrays[p->page_number];
        p->list_arrays[p->page_number].pGDIR=pgdir;
        p->list_arr[p->page_number]=a;
        //cprintf("p->temp %d \n",p->temp->v_address);
        //cprintf(" virtual address temp gular %d\n",p->list_arrays[p->page_number].v_address);
        p->temp=p->temp->nxt;
      }
      }
        memset(mem, 0, PGSIZE);
        if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
        cprintf("allocuvm out of memory (2)\n");
        deallocuvm(pgdir, newsz, oldsz);
        kfree(mem);
        return 0;
        }
     //i++;
     p->page_number++;
    
  }  
  if(p->pid>2){
  cprintf(" Allocuvm: array jegula main memory te ache \n");
  for(int kp=0;kp<MAX_PSYC_PAGES+1;kp++){
    cprintf("%d--> %d\n",kp,p->list_arr[kp]);
  }  
  cprintf(" array jegula swapfile a thakar kotha \n");
  cprintf("virtual address --> offset \n");
    for(int kp=0;kp<11;kp++){
    cprintf("%d --> %d\n",p->f_page_tra[kp].virtual_addr,p->f_page_tra[kp].offset);
    }  
  }
  return newsz;
}
void deletePageFromRAM(struct proc *p, int i,uint va,int reform){

  //struct Node* temp;
  cprintf("deleting the page\n");
  cprintf("process id , va : %d %d\n",p->pid,p->list_arrays[i].v_address);
  p->page_number--;
  if(reform) {

    p->list_arrays[i].v_address=0;
    p->list_arrays[i].counter=0;
    p->list_arrays[i].pGDIR=0;
    
    //p->matha=p->matha->nxt;
  }
  int it;
  //temp=p->matha;
     for(it=0;it<30;it++){
       if(p->list_arr[it]==va){
         p->list_arr[it]=0;
       }
     }
    // cprintf("After deallocation of pages(virtual addresses): \n");
    //  int ip;
    //  for(ip=0;ip<30;ip++){
    //      cprintf("%d\n",p->list_arr[ip]);
       
    //  }

  // for(it=0;it<MAX_PSYC_PAGES;it++){
  //   if(temp->v_address==-81915917){
  //     break;
  //   }
  //     cprintf("After deallocation of pages(virtual addresses): %d\n",temp->v_address);
  //     temp=temp->nxt;  
  // }
    
}
void removingPagesFromMemory(struct proc *p, uint va, const pde_t *pgdir){

  if (p == 0)
    return;

  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
    if ((p->list_arrays[i].v_address == va)
        && (p->list_arrays[i].pGDIR == pgdir)){

      deletePageFromRAM(p, i,va,1);

      return;
    }
  }
}
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{ 
  struct proc* p = myproc();
  if(p==0){
    return oldsz;
  }
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      //cprintf("kfree er jonno eikhane ashe");
      if(pa == 0)
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
      
      if((p->pid)>2){


        cprintf("deallocuvm: matched virtual addresses %d\n",a);

       removingPagesFromMemory(p, a, pgdir);
        *pte = 0;

  }
    }

      //shell and init bade onno jegula add hoiche memory te 
      //segulo ke eikhane deallocate kore dicchi
      //kfree protibar call hoy page free korar jonno process end a

     
    }
  
  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}


void pte_flags_Update_hoy(struct proc* curproc, int vAddr, pde_t * pgdir){

  pte_t *pte = walkpgdir(pgdir, (int*)vAddr, 0);
  if (!pte)
    panic("pte_flags_Update_hoy: pte does NOT exist in page directory");

  *pte |= PTE_PG;           // Paged-out to secondary storage
  *pte &= ~PTE_P;           // the page is NOT present in physical memory
  *pte &= PTE_FLAGS(*pte);
  cprintf("pte flages gula update hocche copyuvm\n");
  lcr3(V2P(curproc->pgdir));      // Refresh CR3 register (TLB (cache))
}
// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  struct proc* curproc=myproc();
  if(curproc == 0){
    return 0;
  }
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0){
      panic("copyuvm: pte should exist");
    }
      if(*pte & PTE_PG){
      pte_flags_Update_hoy(curproc, i, d);
      continue;
    }

    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");

    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      //kfree(mem);//eikhane kfree nai
      goto bad;
    }
  }
  return d;

bad:
  freevm(d);
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
void
trap_theke(pde_t *pgdir, uint pt)
{ 
  char *mem;
  pte_t *pte;
  struct proc *p=myproc();
  int it;
  pte=walkpgdir(p->pgdir,(char*)pt,0);
  cprintf("pte %d\n",*pte); 

  int name=p->page_number;
  uint off_set=p->f_page_tra[name-1].offset;
  *pte|=PTE_PG;
  *pte&=(~PTE_P);


  mem = kalloc();
  memset(mem, 0, PGSIZE);
  
  char buffer[PGSIZE/2]= "";
  //readFromSwapFile(p,buffer,off_set,PGSIZE/2);
  
  if(*pte & PTE_P){

    cprintf("Memory already has the page.\n");
    
  }
  else{
  int map_number=mappages(pgdir, (char*)pt, PGSIZE, V2P(mem), PTE_W|PTE_U);
  cprintf("map number (0 means successful) : %d\n",map_number);
  for(it=0;it<2;it++){
    if(readFromSwapFile(p,buffer,off_set+it*(PGSIZE/2),PGSIZE/2)!=0){
      memmove(mem+it*(PGSIZE/2), buffer, PGSIZE/2);
      cprintf("AFTER READING AND ALLOCATING\n");

    }
  
    }
  }
}


//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.



