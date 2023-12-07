#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;


    case T_PGFLT:{
      struct proc *p=myproc();
      int pi;
      //int it;
      int k=0;
      uint r_addr;
      uint virtual_address;
      r_addr=PTE_ADDR(rcr2());
      pi=walk(p->pgdir,r_addr,0);
      //cprintf("ashche trap a %d",pi);
      if(pi==1){
        cprintf("trap.c(T_PGFLT):page fault khacche.(virtual address from rcr2) %d\n",r_addr);
        int name=p->page_number;
        virtual_address=p->f_page_tra[name-1].virtual_addr;
        if(r_addr==virtual_address){
          if(k==0){
          uint va=p->matha->v_address;
          cprintf("trap.c(T_PGFLT):FIFO ->item write from the first element %d\n",va);
          cprintf("trap.c(T_PGFLT):FIFO write er offset :%d\n",p->offset_swapfile);
          writeToSwapFile(p,(char*)PTE_ADDR(va),p->offset_swapfile,PGSIZE);
          cprintf("trap.c(T_PGFLT):FIFO writeToSwapFile a likhar pore trap theke function a jacche.\n");
          p->matha=p->matha->nxt;
          trap_theke(p->pgdir, r_addr);
          
          break;
        }
        if(k==1){
          uint vadd=p->list_arrays[0].v_address;
          int i;
          int max=-1;
          for(i=0;i<30;i++){
            if(p->list_arrays[i].counter>max){
                max=p->list_arrays[i].counter;
                vadd=p->list_arrays[i].v_address;
            }
            
          }
          

          //cprintf("trap.c(T_PGFLT):AGING ->item write from the highest counter %d\n",vaad);
          cprintf("trap.c(T_PGFLT):AGING write er offset :%d\n",p->offset_swapfile);
          writeToSwapFile(p,(char*)PTE_ADDR(vadd),p->offset_swapfile,PGSIZE);
          cprintf("trap.c(T_PGFLT):AGING writeToSwapFile a likhar pore trap theke function a jacche.\n");
          
          trap_theke(p->pgdir, r_addr);
          
          break;
           }
        }
        
      }
      else{
        break;
      }
    }

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER){


    Counter_Set_korar_jonno();
      yield();
      }
      
     
   

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
