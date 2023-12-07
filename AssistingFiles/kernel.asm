
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 33 10 80       	mov    $0x801033c0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 a0 7d 10 80       	push   $0x80107da0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 01 49 00 00       	call   80104960 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 7d 10 80       	push   $0x80107da7
80100097:	50                   	push   %eax
80100098:	e8 83 47 00 00       	call   80104820 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 f3 49 00 00       	call   80104ae0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 39 4a 00 00       	call   80104ba0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 46 00 00       	call   80104860 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 6f 24 00 00       	call   80102600 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ae 7d 10 80       	push   $0x80107dae
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 39 47 00 00       	call   80104900 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 23 24 00 00       	jmp    80102600 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 bf 7d 10 80       	push   $0x80107dbf
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 f8 46 00 00       	call   80104900 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 a8 46 00 00       	call   801048c0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 bc 48 00 00       	call   80104ae0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 2b 49 00 00       	jmp    80104ba0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 7d 10 80       	push   $0x80107dc6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 2a 48 00 00       	call   80104ae0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 16 40 00 00       	call   80104300 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 21 3a 00 00       	call   80103d20 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 8d 48 00 00       	call   80104ba0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 36 48 00 00       	call   80104ba0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 6e 28 00 00       	call   80102c20 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 7d 10 80       	push   $0x80107dcd
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 ef 89 10 80 	movl   $0x801089ef,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 9f 45 00 00       	call   80104980 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 7d 10 80       	push   $0x80107de1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 41 5f 00 00       	call   80106370 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 56 5e 00 00       	call   80106370 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 4a 5e 00 00       	call   80106370 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 3e 5e 00 00       	call   80106370 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 2a 47 00 00       	call   80104c90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 75 46 00 00       	call   80104bf0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 e5 7d 10 80       	push   $0x80107de5
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 10 7e 10 80 	movzbl -0x7fef81f0(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 7c 44 00 00       	call   80104ae0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 04 45 00 00       	call   80104ba0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb f8 7d 10 80       	mov    $0x80107df8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 1e 43 00 00       	call   80104ae0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 73 43 00 00       	call   80104ba0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 ff 7d 10 80       	push   $0x80107dff
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 64 42 00 00       	call   80104ae0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 cc 41 00 00       	call   80104ba0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 1c 3c 00 00       	jmp    80104620 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 9b 3a 00 00       	call   801044c0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 08 7e 10 80       	push   $0x80107e08
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 17 3f 00 00       	call   80104960 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 3e 1d 00 00       	call   801027b0 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 8b 32 00 00       	call   80103d20 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 10 26 00 00       	call   801030b0 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 38 26 00 00       	call   80103120 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 cf 6d 00 00       	call   801078e0 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 48 69 00 00       	call   801074c0 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 22 66 00 00       	call   801071d0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 70 6c 00 00       	call   80107860 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 fa 24 00 00       	call   80103120 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 89 68 00 00       	call   801074c0 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 28 6d 00 00       	call   80107980 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 48 41 00 00       	call   80104df0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 35 41 00 00       	call   80104df0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 b4 6e 00 00       	call   80107b80 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 7a 6b 00 00       	call   80107860 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 48 6e 00 00       	call   80107b80 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 3a 40 00 00       	call   80104db0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 9e 62 00 00       	call   80107040 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 b6 6a 00 00       	call   80107860 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 67 23 00 00       	call   80103120 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 21 7e 10 80       	push   $0x80107e21
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 2d 7e 10 80       	push   $0x80107e2d
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 67 3b 00 00       	call   80104960 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 0f 11 80       	push   $0x80110fc0
80100e15:	e8 c6 3c 00 00       	call   80104ae0 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 5a 3d 00 00       	call   80104ba0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 0f 11 80       	push   $0x80110fc0
80100e5a:	e8 41 3d 00 00       	call   80104ba0 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e83:	e8 58 3c 00 00       	call   80104ae0 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100ea0:	e8 fb 3c 00 00       	call   80104ba0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 34 7e 10 80       	push   $0x80107e34
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed5:	e8 06 3c 00 00       	call   80104ae0 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 8b 3c 00 00       	call   80104ba0 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 5d 3c 00 00       	jmp    80104ba0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 63 21 00 00       	call   801030b0 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 b9 21 00 00       	jmp    80103120 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 02 29 00 00       	call   80103880 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 3c 7e 10 80       	push   $0x80107e3c
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 b6 29 00 00       	jmp    80103a20 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 46 7e 10 80       	push   $0x80107e46
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 2a 20 00 00       	call   80103120 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 91 1f 00 00       	call   801030b0 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 ca 1f 00 00       	call   80103120 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 4f 7e 10 80       	push   $0x80107e4f
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 8a 27 00 00       	jmp    80103920 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 55 7e 10 80       	push   $0x80107e55
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 8e 20 00 00       	call   80103290 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 5f 7e 10 80       	push   $0x80107e5f
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 72 7e 10 80       	push   $0x80107e72
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 9e 1f 00 00       	call   80103290 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 d6 38 00 00       	call   80104bf0 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 6e 1f 00 00       	call   80103290 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 e0 19 11 80       	push   $0x801119e0
8010135a:	e8 81 37 00 00       	call   80104ae0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 e0 19 11 80       	push   $0x801119e0
801013c7:	e8 d4 37 00 00       	call   80104ba0 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 a6 37 00 00       	call   80104ba0 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 88 7e 10 80       	push   $0x80107e88
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 e6 1d 00 00       	call   80103290 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 98 7e 10 80       	push   $0x80107e98
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 66 37 00 00       	call   80104c90 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 ab 7e 10 80       	push   $0x80107eab
80101555:	68 e0 19 11 80       	push   $0x801119e0
8010155a:	e8 01 34 00 00       	call   80104960 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 b2 7e 10 80       	push   $0x80107eb2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 a4 32 00 00       	call   80104820 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 19 11 80       	push   $0x801119c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 19 11 80    	pushl  0x801119d8
8010159d:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015a3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015a9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015af:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015b5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015bb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015c1:	68 5c 7f 10 80       	push   $0x80107f5c
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 8d 35 00 00       	call   80104bf0 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 1b 1c 00 00       	call   80103290 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 b8 7e 10 80       	push   $0x80107eb8
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 86 35 00 00       	call   80104c90 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 7e 1b 00 00       	call   80103290 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 e0 19 11 80       	push   $0x801119e0
80101743:	e8 98 33 00 00       	call   80104ae0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101753:	e8 48 34 00 00       	call   80104ba0 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 d5 30 00 00       	call   80104860 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 93 34 00 00       	call   80104c90 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 d0 7e 10 80       	push   $0x80107ed0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 ca 7e 10 80       	push   $0x80107eca
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 a4 30 00 00       	call   80104900 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 48 30 00 00       	jmp    801048c0 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 df 7e 10 80       	push   $0x80107edf
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 b7 2f 00 00       	call   80104860 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 fd 2f 00 00       	call   801048c0 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018ca:	e8 11 32 00 00       	call   80104ae0 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 b7 32 00 00       	jmp    80104ba0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 19 11 80       	push   $0x801119e0
801018f8:	e8 e3 31 00 00       	call   80104ae0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101907:	e8 94 32 00 00       	call   80104ba0 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 84 31 00 00       	call   80104c90 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 88 30 00 00       	call   80104c90 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 80 16 00 00       	call   80103290 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 59 30 00 00       	call   80104d00 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 f6 2f 00 00       	call   80104d00 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 f9 7e 10 80       	push   $0x80107ef9
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 e7 7e 10 80       	push   $0x80107ee7
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 91 1f 00 00       	call   80103d20 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 19 11 80       	push   $0x801119e0
80101d9c:	e8 3f 2d 00 00       	call   80104ae0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dac:	e8 ef 2d 00 00       	call   80104ba0 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 74 2e 00 00       	call   80104c90 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 e8 2d 00 00       	call   80104c90 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 76 2d 00 00       	call   80104d50 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 08 7f 10 80       	push   $0x80107f08
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 2d 86 10 80       	push   $0x8010862d
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010206f:	90                   	nop

80102070 <itoa>:
// NEW FOR PAGING

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102075:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
8010207a:	89 e5                	mov    %esp,%ebp
8010207c:	57                   	push   %edi
8010207d:	56                   	push   %esi
8010207e:	53                   	push   %ebx
8010207f:	83 ec 10             	sub    $0x10,%esp
80102082:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102085:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102088:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
8010208f:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80102096:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
8010209a:	89 fb                	mov    %edi,%ebx
8010209c:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    char* p = b;
    if(i<0){
801020a0:	85 c9                	test   %ecx,%ecx
801020a2:	79 08                	jns    801020ac <itoa+0x3c>
        *p++ = '-';
801020a4:	c6 07 2d             	movb   $0x2d,(%edi)
801020a7:	8d 5f 01             	lea    0x1(%edi),%ebx
        i *= -1;
801020aa:	f7 d9                	neg    %ecx
    }
    int shifter = i;
801020ac:	89 ca                	mov    %ecx,%edx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
801020ae:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801020b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020b7:	90                   	nop
801020b8:	89 d0                	mov    %edx,%eax
        ++p;
801020ba:	83 c3 01             	add    $0x1,%ebx
        shifter = shifter/10;
801020bd:	f7 e6                	mul    %esi
    }while(shifter);
801020bf:	c1 ea 03             	shr    $0x3,%edx
801020c2:	75 f4                	jne    801020b8 <itoa+0x48>
    *p = '\0';
801020c4:	c6 03 00             	movb   $0x0,(%ebx)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
801020c7:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020d0:	89 c8                	mov    %ecx,%eax
801020d2:	83 eb 01             	sub    $0x1,%ebx
801020d5:	f7 e6                	mul    %esi
801020d7:	c1 ea 03             	shr    $0x3,%edx
801020da:	8d 04 92             	lea    (%edx,%edx,4),%eax
801020dd:	01 c0                	add    %eax,%eax
801020df:	29 c1                	sub    %eax,%ecx
801020e1:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
801020e6:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
801020e8:	88 03                	mov    %al,(%ebx)
    }while(i);
801020ea:	85 d2                	test   %edx,%edx
801020ec:	75 e2                	jne    801020d0 <itoa+0x60>
    return b;
}
801020ee:	83 c4 10             	add    $0x10,%esp
801020f1:	89 f8                	mov    %edi,%eax
801020f3:	5b                   	pop    %ebx
801020f4:	5e                   	pop    %esi
801020f5:	5f                   	pop    %edi
801020f6:	5d                   	pop    %ebp
801020f7:	c3                   	ret    
801020f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ff:	90                   	nop

80102100 <removeSwapFile>:

//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102100:	f3 0f 1e fb          	endbr32 
80102104:	55                   	push   %ebp
80102105:	89 e5                	mov    %esp,%ebp
80102107:	57                   	push   %edi
80102108:	56                   	push   %esi
	//path of proccess
	char path[DIGITS];
	memmove(path,"/.swap", 6);
80102109:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
8010210c:	53                   	push   %ebx
8010210d:	83 ec 40             	sub    $0x40,%esp
80102110:	8b 5d 08             	mov    0x8(%ebp),%ebx
	memmove(path,"/.swap", 6);
80102113:	6a 06                	push   $0x6
80102115:	68 15 7f 10 80       	push   $0x80107f15
8010211a:	56                   	push   %esi
8010211b:	e8 70 2b 00 00       	call   80104c90 <memmove>
	itoa(p->pid, path+ 6);
80102120:	58                   	pop    %eax
80102121:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102124:	5a                   	pop    %edx
80102125:	50                   	push   %eax
80102126:	ff 73 10             	pushl  0x10(%ebx)
80102129:	e8 42 ff ff ff       	call   80102070 <itoa>
	struct inode *ip, *dp;
	struct dirent de;
	char name[DIRSIZ];
	uint off;

	if(0 == p->swapFile)
8010212e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102131:	83 c4 10             	add    $0x10,%esp
80102134:	85 c0                	test   %eax,%eax
80102136:	0f 84 7a 01 00 00    	je     801022b6 <removeSwapFile+0x1b6>
	{
		return -1;
	}
	fileclose(p->swapFile);
8010213c:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010213f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
	fileclose(p->swapFile);
80102142:	50                   	push   %eax
80102143:	e8 78 ed ff ff       	call   80100ec0 <fileclose>

	begin_op();
80102148:	e8 63 0f 00 00       	call   801030b0 <begin_op>
  return namex(path, 1, name);
8010214d:	89 f0                	mov    %esi,%eax
8010214f:	89 d9                	mov    %ebx,%ecx
80102151:	ba 01 00 00 00       	mov    $0x1,%edx
80102156:	e8 15 fc ff ff       	call   80101d70 <namex>
	if((dp = nameiparent(path, name)) == 0)
8010215b:	83 c4 10             	add    $0x10,%esp
  return namex(path, 1, name);
8010215e:	89 c6                	mov    %eax,%esi
	if((dp = nameiparent(path, name)) == 0)
80102160:	85 c0                	test   %eax,%eax
80102162:	0f 84 55 01 00 00    	je     801022bd <removeSwapFile+0x1bd>
	{
		end_op();
		return -1;
	}

	ilock(dp);
80102168:	83 ec 0c             	sub    $0xc,%esp
8010216b:	50                   	push   %eax
8010216c:	e8 ef f5 ff ff       	call   80101760 <ilock>
  return strncmp(s, t, DIRSIZ);
80102171:	83 c4 0c             	add    $0xc,%esp
80102174:	6a 0e                	push   $0xe
80102176:	68 1d 7f 10 80       	push   $0x80107f1d
8010217b:	53                   	push   %ebx
8010217c:	e8 7f 2b 00 00       	call   80104d00 <strncmp>

	  // Cannot unlink "." or "..".
	if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102181:	83 c4 10             	add    $0x10,%esp
80102184:	85 c0                	test   %eax,%eax
80102186:	0f 84 f4 00 00 00    	je     80102280 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
8010218c:	83 ec 04             	sub    $0x4,%esp
8010218f:	6a 0e                	push   $0xe
80102191:	68 1c 7f 10 80       	push   $0x80107f1c
80102196:	53                   	push   %ebx
80102197:	e8 64 2b 00 00       	call   80104d00 <strncmp>
	if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010219c:	83 c4 10             	add    $0x10,%esp
8010219f:	85 c0                	test   %eax,%eax
801021a1:	0f 84 d9 00 00 00    	je     80102280 <removeSwapFile+0x180>
	   goto bad;

	if((ip = dirlookup(dp, name, &off)) == 0)
801021a7:	83 ec 04             	sub    $0x4,%esp
801021aa:	8d 45 b8             	lea    -0x48(%ebp),%eax
801021ad:	50                   	push   %eax
801021ae:	53                   	push   %ebx
801021af:	56                   	push   %esi
801021b0:	e8 fb fa ff ff       	call   80101cb0 <dirlookup>
801021b5:	83 c4 10             	add    $0x10,%esp
801021b8:	89 c3                	mov    %eax,%ebx
801021ba:	85 c0                	test   %eax,%eax
801021bc:	0f 84 be 00 00 00    	je     80102280 <removeSwapFile+0x180>
		goto bad;
	ilock(ip);
801021c2:	83 ec 0c             	sub    $0xc,%esp
801021c5:	50                   	push   %eax
801021c6:	e8 95 f5 ff ff       	call   80101760 <ilock>

	if(ip->nlink < 1)
801021cb:	83 c4 10             	add    $0x10,%esp
801021ce:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801021d3:	0f 8e 00 01 00 00    	jle    801022d9 <removeSwapFile+0x1d9>
		panic("unlink: nlink < 1");
	if(ip->type == T_DIR && !isdirempty(ip)){
801021d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021de:	74 78                	je     80102258 <removeSwapFile+0x158>
		iunlockput(ip);
		goto bad;
	}

	memset(&de, 0, sizeof(de));
801021e0:	83 ec 04             	sub    $0x4,%esp
801021e3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801021e6:	6a 10                	push   $0x10
801021e8:	6a 00                	push   $0x0
801021ea:	57                   	push   %edi
801021eb:	e8 00 2a 00 00       	call   80104bf0 <memset>
	if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f0:	6a 10                	push   $0x10
801021f2:	ff 75 b8             	pushl  -0x48(%ebp)
801021f5:	57                   	push   %edi
801021f6:	56                   	push   %esi
801021f7:	e8 64 f9 ff ff       	call   80101b60 <writei>
801021fc:	83 c4 20             	add    $0x20,%esp
801021ff:	83 f8 10             	cmp    $0x10,%eax
80102202:	0f 85 c4 00 00 00    	jne    801022cc <removeSwapFile+0x1cc>
		panic("unlink: writei");
	if(ip->type == T_DIR){
80102208:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010220d:	0f 84 8d 00 00 00    	je     801022a0 <removeSwapFile+0x1a0>
  iunlock(ip);
80102213:	83 ec 0c             	sub    $0xc,%esp
80102216:	56                   	push   %esi
80102217:	e8 24 f6 ff ff       	call   80101840 <iunlock>
  iput(ip);
8010221c:	89 34 24             	mov    %esi,(%esp)
8010221f:	e8 6c f6 ff ff       	call   80101890 <iput>
		dp->nlink--;
		iupdate(dp);
	}
	iunlockput(dp);

	ip->nlink--;
80102224:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
80102229:	89 1c 24             	mov    %ebx,(%esp)
8010222c:	e8 6f f4 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80102231:	89 1c 24             	mov    %ebx,(%esp)
80102234:	e8 07 f6 ff ff       	call   80101840 <iunlock>
  iput(ip);
80102239:	89 1c 24             	mov    %ebx,(%esp)
8010223c:	e8 4f f6 ff ff       	call   80101890 <iput>
	iunlockput(ip);

	end_op();
80102241:	e8 da 0e 00 00       	call   80103120 <end_op>

	return 0;
80102246:	83 c4 10             	add    $0x10,%esp
80102249:	31 c0                	xor    %eax,%eax
	bad:
		iunlockput(dp);
		end_op();
		return -1;

}
8010224b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010224e:	5b                   	pop    %ebx
8010224f:	5e                   	pop    %esi
80102250:	5f                   	pop    %edi
80102251:	5d                   	pop    %ebp
80102252:	c3                   	ret    
80102253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102257:	90                   	nop
	if(ip->type == T_DIR && !isdirempty(ip)){
80102258:	83 ec 0c             	sub    $0xc,%esp
8010225b:	53                   	push   %ebx
8010225c:	e8 5f 31 00 00       	call   801053c0 <isdirempty>
80102261:	83 c4 10             	add    $0x10,%esp
80102264:	85 c0                	test   %eax,%eax
80102266:	0f 85 74 ff ff ff    	jne    801021e0 <removeSwapFile+0xe0>
  iunlock(ip);
8010226c:	83 ec 0c             	sub    $0xc,%esp
8010226f:	53                   	push   %ebx
80102270:	e8 cb f5 ff ff       	call   80101840 <iunlock>
  iput(ip);
80102275:	89 1c 24             	mov    %ebx,(%esp)
80102278:	e8 13 f6 ff ff       	call   80101890 <iput>
		goto bad;
8010227d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80102280:	83 ec 0c             	sub    $0xc,%esp
80102283:	56                   	push   %esi
80102284:	e8 b7 f5 ff ff       	call   80101840 <iunlock>
  iput(ip);
80102289:	89 34 24             	mov    %esi,(%esp)
8010228c:	e8 ff f5 ff ff       	call   80101890 <iput>
		end_op();
80102291:	e8 8a 0e 00 00       	call   80103120 <end_op>
		return -1;
80102296:	83 c4 10             	add    $0x10,%esp
80102299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010229e:	eb ab                	jmp    8010224b <removeSwapFile+0x14b>
		iupdate(dp);
801022a0:	83 ec 0c             	sub    $0xc,%esp
		dp->nlink--;
801022a3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
		iupdate(dp);
801022a8:	56                   	push   %esi
801022a9:	e8 f2 f3 ff ff       	call   801016a0 <iupdate>
801022ae:	83 c4 10             	add    $0x10,%esp
801022b1:	e9 5d ff ff ff       	jmp    80102213 <removeSwapFile+0x113>
		return -1;
801022b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022bb:	eb 8e                	jmp    8010224b <removeSwapFile+0x14b>
		end_op();
801022bd:	e8 5e 0e 00 00       	call   80103120 <end_op>
		return -1;
801022c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022c7:	e9 7f ff ff ff       	jmp    8010224b <removeSwapFile+0x14b>
		panic("unlink: writei");
801022cc:	83 ec 0c             	sub    $0xc,%esp
801022cf:	68 31 7f 10 80       	push   $0x80107f31
801022d4:	e8 b7 e0 ff ff       	call   80100390 <panic>
		panic("unlink: nlink < 1");
801022d9:	83 ec 0c             	sub    $0xc,%esp
801022dc:	68 1f 7f 10 80       	push   $0x80107f1f
801022e1:	e8 aa e0 ff ff       	call   80100390 <panic>
801022e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ed:	8d 76 00             	lea    0x0(%esi),%esi

801022f0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801022f0:	f3 0f 1e fb          	endbr32 
801022f4:	55                   	push   %ebp
801022f5:	89 e5                	mov    %esp,%ebp
801022f7:	56                   	push   %esi
801022f8:	53                   	push   %ebx

	char path[DIGITS];
	memmove(path,"/.swap", 6);
801022f9:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801022fc:	83 ec 14             	sub    $0x14,%esp
801022ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	memmove(path,"/.swap", 6);
80102302:	6a 06                	push   $0x6
80102304:	68 15 7f 10 80       	push   $0x80107f15
80102309:	56                   	push   %esi
8010230a:	e8 81 29 00 00       	call   80104c90 <memmove>
	itoa(p->pid, path+ 6);
8010230f:	58                   	pop    %eax
80102310:	8d 45 f0             	lea    -0x10(%ebp),%eax
80102313:	5a                   	pop    %edx
80102314:	50                   	push   %eax
80102315:	ff 73 10             	pushl  0x10(%ebx)
80102318:	e8 53 fd ff ff       	call   80102070 <itoa>

    begin_op();
8010231d:	e8 8e 0d 00 00       	call   801030b0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
80102322:	6a 00                	push   $0x0
80102324:	6a 00                	push   $0x0
80102326:	6a 02                	push   $0x2
80102328:	56                   	push   %esi
80102329:	e8 b2 32 00 00       	call   801055e0 <create>
	iunlock(in);
8010232e:	83 c4 14             	add    $0x14,%esp
80102331:	50                   	push   %eax
    struct inode * in = create(path, T_FILE, 0, 0);
80102332:	89 c6                	mov    %eax,%esi
	iunlock(in);
80102334:	e8 07 f5 ff ff       	call   80101840 <iunlock>

	p->swapFile = filealloc();
80102339:	e8 c2 ea ff ff       	call   80100e00 <filealloc>
	if (p->swapFile == 0)
8010233e:	83 c4 10             	add    $0x10,%esp
	p->swapFile = filealloc();
80102341:	89 43 7c             	mov    %eax,0x7c(%ebx)
	if (p->swapFile == 0)
80102344:	85 c0                	test   %eax,%eax
80102346:	74 32                	je     8010237a <createSwapFile+0x8a>
		panic("no slot for files on /store");

	p->swapFile->ip = in;
80102348:	89 70 10             	mov    %esi,0x10(%eax)
	p->swapFile->type = FD_INODE;
8010234b:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010234e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
	p->swapFile->off = 0;
80102354:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102357:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	p->swapFile->readable = O_WRONLY;
8010235e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102361:	c6 40 08 01          	movb   $0x1,0x8(%eax)
	p->swapFile->writable = O_RDWR;
80102365:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102368:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
8010236c:	e8 af 0d 00 00       	call   80103120 <end_op>

    return 0;
}
80102371:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102374:	31 c0                	xor    %eax,%eax
80102376:	5b                   	pop    %ebx
80102377:	5e                   	pop    %esi
80102378:	5d                   	pop    %ebp
80102379:	c3                   	ret    
		panic("no slot for files on /store");
8010237a:	83 ec 0c             	sub    $0xc,%esp
8010237d:	68 40 7f 10 80       	push   $0x80107f40
80102382:	e8 09 e0 ff ff       	call   80100390 <panic>
80102387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238e:	66 90                	xchg   %ax,%ax

80102390 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
80102395:	89 e5                	mov    %esp,%ebp
80102397:	8b 45 08             	mov    0x8(%ebp),%eax
	p->swapFile->off = placeOnFile;
8010239a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010239d:	8b 50 7c             	mov    0x7c(%eax),%edx
801023a0:	89 4a 14             	mov    %ecx,0x14(%edx)
	return filewrite(p->swapFile, buffer, size);
801023a3:	8b 55 14             	mov    0x14(%ebp),%edx
801023a6:	89 55 10             	mov    %edx,0x10(%ebp)
801023a9:	8b 40 7c             	mov    0x7c(%eax),%eax
801023ac:	89 45 08             	mov    %eax,0x8(%ebp)

}
801023af:	5d                   	pop    %ebp
	return filewrite(p->swapFile, buffer, size);
801023b0:	e9 db ec ff ff       	jmp    80101090 <filewrite>
801023b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023c0 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801023c0:	f3 0f 1e fb          	endbr32 
801023c4:	55                   	push   %ebp
801023c5:	89 e5                	mov    %esp,%ebp
801023c7:	8b 45 08             	mov    0x8(%ebp),%eax
	p->swapFile->off = placeOnFile;
801023ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
801023cd:	8b 50 7c             	mov    0x7c(%eax),%edx
801023d0:	89 4a 14             	mov    %ecx,0x14(%edx)

	return fileread(p->swapFile, buffer,  size);
801023d3:	8b 55 14             	mov    0x14(%ebp),%edx
801023d6:	89 55 10             	mov    %edx,0x10(%ebp)
801023d9:	8b 40 7c             	mov    0x7c(%eax),%eax
801023dc:	89 45 08             	mov    %eax,0x8(%ebp)
}
801023df:	5d                   	pop    %ebp
	return fileread(p->swapFile, buffer,  size);
801023e0:	e9 0b ec ff ff       	jmp    80100ff0 <fileread>
801023e5:	66 90                	xchg   %ax,%ax
801023e7:	66 90                	xchg   %ax,%ax
801023e9:	66 90                	xchg   %ax,%ax
801023eb:	66 90                	xchg   %ax,%ax
801023ed:	66 90                	xchg   %ax,%ax
801023ef:	90                   	nop

801023f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	57                   	push   %edi
801023f4:	56                   	push   %esi
801023f5:	53                   	push   %ebx
801023f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801023f9:	85 c0                	test   %eax,%eax
801023fb:	0f 84 b4 00 00 00    	je     801024b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102401:	8b 70 08             	mov    0x8(%eax),%esi
80102404:	89 c3                	mov    %eax,%ebx
80102406:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010240c:	0f 87 96 00 00 00    	ja     801024a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102412:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241e:	66 90                	xchg   %ax,%ax
80102420:	89 ca                	mov    %ecx,%edx
80102422:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102423:	83 e0 c0             	and    $0xffffffc0,%eax
80102426:	3c 40                	cmp    $0x40,%al
80102428:	75 f6                	jne    80102420 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010242a:	31 ff                	xor    %edi,%edi
8010242c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102431:	89 f8                	mov    %edi,%eax
80102433:	ee                   	out    %al,(%dx)
80102434:	b8 01 00 00 00       	mov    $0x1,%eax
80102439:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010243e:	ee                   	out    %al,(%dx)
8010243f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102444:	89 f0                	mov    %esi,%eax
80102446:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102447:	89 f0                	mov    %esi,%eax
80102449:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010244e:	c1 f8 08             	sar    $0x8,%eax
80102451:	ee                   	out    %al,(%dx)
80102452:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102457:	89 f8                	mov    %edi,%eax
80102459:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010245a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010245e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102463:	c1 e0 04             	shl    $0x4,%eax
80102466:	83 e0 10             	and    $0x10,%eax
80102469:	83 c8 e0             	or     $0xffffffe0,%eax
8010246c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010246d:	f6 03 04             	testb  $0x4,(%ebx)
80102470:	75 16                	jne    80102488 <idestart+0x98>
80102472:	b8 20 00 00 00       	mov    $0x20,%eax
80102477:	89 ca                	mov    %ecx,%edx
80102479:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010247a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010247d:	5b                   	pop    %ebx
8010247e:	5e                   	pop    %esi
8010247f:	5f                   	pop    %edi
80102480:	5d                   	pop    %ebp
80102481:	c3                   	ret    
80102482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102488:	b8 30 00 00 00       	mov    $0x30,%eax
8010248d:	89 ca                	mov    %ecx,%edx
8010248f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102490:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102495:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102498:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010249d:	fc                   	cld    
8010249e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801024a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024a3:	5b                   	pop    %ebx
801024a4:	5e                   	pop    %esi
801024a5:	5f                   	pop    %edi
801024a6:	5d                   	pop    %ebp
801024a7:	c3                   	ret    
    panic("incorrect blockno");
801024a8:	83 ec 0c             	sub    $0xc,%esp
801024ab:	68 b8 7f 10 80       	push   $0x80107fb8
801024b0:	e8 db de ff ff       	call   80100390 <panic>
    panic("idestart");
801024b5:	83 ec 0c             	sub    $0xc,%esp
801024b8:	68 af 7f 10 80       	push   $0x80107faf
801024bd:	e8 ce de ff ff       	call   80100390 <panic>
801024c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801024d0 <ideinit>:
{
801024d0:	f3 0f 1e fb          	endbr32 
801024d4:	55                   	push   %ebp
801024d5:	89 e5                	mov    %esp,%ebp
801024d7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801024da:	68 ca 7f 10 80       	push   $0x80107fca
801024df:	68 80 b5 10 80       	push   $0x8010b580
801024e4:	e8 77 24 00 00       	call   80104960 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801024e9:	58                   	pop    %eax
801024ea:	a1 00 3d 11 80       	mov    0x80113d00,%eax
801024ef:	5a                   	pop    %edx
801024f0:	83 e8 01             	sub    $0x1,%eax
801024f3:	50                   	push   %eax
801024f4:	6a 0e                	push   $0xe
801024f6:	e8 b5 02 00 00       	call   801027b0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024fb:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024fe:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102507:	90                   	nop
80102508:	ec                   	in     (%dx),%al
80102509:	83 e0 c0             	and    $0xffffffc0,%eax
8010250c:	3c 40                	cmp    $0x40,%al
8010250e:	75 f8                	jne    80102508 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102510:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102515:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010251a:	ee                   	out    %al,(%dx)
8010251b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102520:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102525:	eb 0e                	jmp    80102535 <ideinit+0x65>
80102527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010252e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102530:	83 e9 01             	sub    $0x1,%ecx
80102533:	74 0f                	je     80102544 <ideinit+0x74>
80102535:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102536:	84 c0                	test   %al,%al
80102538:	74 f6                	je     80102530 <ideinit+0x60>
      havedisk1 = 1;
8010253a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102541:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102544:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102549:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010254e:	ee                   	out    %al,(%dx)
}
8010254f:	c9                   	leave  
80102550:	c3                   	ret    
80102551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255f:	90                   	nop

80102560 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	57                   	push   %edi
80102568:	56                   	push   %esi
80102569:	53                   	push   %ebx
8010256a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010256d:	68 80 b5 10 80       	push   $0x8010b580
80102572:	e8 69 25 00 00       	call   80104ae0 <acquire>

  if((b = idequeue) == 0){
80102577:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	85 db                	test   %ebx,%ebx
80102582:	74 5f                	je     801025e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102584:	8b 43 58             	mov    0x58(%ebx),%eax
80102587:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010258c:	8b 33                	mov    (%ebx),%esi
8010258e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102594:	75 2b                	jne    801025c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102596:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010259b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010259f:	90                   	nop
801025a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025a1:	89 c1                	mov    %eax,%ecx
801025a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801025a6:	80 f9 40             	cmp    $0x40,%cl
801025a9:	75 f5                	jne    801025a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025ab:	a8 21                	test   $0x21,%al
801025ad:	75 12                	jne    801025c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801025af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801025b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801025b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025bc:	fc                   	cld    
801025bd:	f3 6d                	rep insl (%dx),%es:(%edi)
801025bf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801025c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801025c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801025c7:	83 ce 02             	or     $0x2,%esi
801025ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801025cc:	53                   	push   %ebx
801025cd:	e8 ee 1e 00 00       	call   801044c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801025d2:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801025d7:	83 c4 10             	add    $0x10,%esp
801025da:	85 c0                	test   %eax,%eax
801025dc:	74 05                	je     801025e3 <ideintr+0x83>
    idestart(idequeue);
801025de:	e8 0d fe ff ff       	call   801023f0 <idestart>
    release(&idelock);
801025e3:	83 ec 0c             	sub    $0xc,%esp
801025e6:	68 80 b5 10 80       	push   $0x8010b580
801025eb:	e8 b0 25 00 00       	call   80104ba0 <release>

  release(&idelock);
}
801025f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025f3:	5b                   	pop    %ebx
801025f4:	5e                   	pop    %esi
801025f5:	5f                   	pop    %edi
801025f6:	5d                   	pop    %ebp
801025f7:	c3                   	ret    
801025f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ff:	90                   	nop

80102600 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102600:	f3 0f 1e fb          	endbr32 
80102604:	55                   	push   %ebp
80102605:	89 e5                	mov    %esp,%ebp
80102607:	53                   	push   %ebx
80102608:	83 ec 10             	sub    $0x10,%esp
8010260b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010260e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102611:	50                   	push   %eax
80102612:	e8 e9 22 00 00       	call   80104900 <holdingsleep>
80102617:	83 c4 10             	add    $0x10,%esp
8010261a:	85 c0                	test   %eax,%eax
8010261c:	0f 84 cf 00 00 00    	je     801026f1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102622:	8b 03                	mov    (%ebx),%eax
80102624:	83 e0 06             	and    $0x6,%eax
80102627:	83 f8 02             	cmp    $0x2,%eax
8010262a:	0f 84 b4 00 00 00    	je     801026e4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102630:	8b 53 04             	mov    0x4(%ebx),%edx
80102633:	85 d2                	test   %edx,%edx
80102635:	74 0d                	je     80102644 <iderw+0x44>
80102637:	a1 60 b5 10 80       	mov    0x8010b560,%eax
8010263c:	85 c0                	test   %eax,%eax
8010263e:	0f 84 93 00 00 00    	je     801026d7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102644:	83 ec 0c             	sub    $0xc,%esp
80102647:	68 80 b5 10 80       	push   $0x8010b580
8010264c:	e8 8f 24 00 00       	call   80104ae0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102651:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102656:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010265d:	83 c4 10             	add    $0x10,%esp
80102660:	85 c0                	test   %eax,%eax
80102662:	74 6c                	je     801026d0 <iderw+0xd0>
80102664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102668:	89 c2                	mov    %eax,%edx
8010266a:	8b 40 58             	mov    0x58(%eax),%eax
8010266d:	85 c0                	test   %eax,%eax
8010266f:	75 f7                	jne    80102668 <iderw+0x68>
80102671:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102674:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102676:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010267c:	74 42                	je     801026c0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010267e:	8b 03                	mov    (%ebx),%eax
80102680:	83 e0 06             	and    $0x6,%eax
80102683:	83 f8 02             	cmp    $0x2,%eax
80102686:	74 23                	je     801026ab <iderw+0xab>
80102688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268f:	90                   	nop
    sleep(b, &idelock);
80102690:	83 ec 08             	sub    $0x8,%esp
80102693:	68 80 b5 10 80       	push   $0x8010b580
80102698:	53                   	push   %ebx
80102699:	e8 62 1c 00 00       	call   80104300 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010269e:	8b 03                	mov    (%ebx),%eax
801026a0:	83 c4 10             	add    $0x10,%esp
801026a3:	83 e0 06             	and    $0x6,%eax
801026a6:	83 f8 02             	cmp    $0x2,%eax
801026a9:	75 e5                	jne    80102690 <iderw+0x90>
  }


  release(&idelock);
801026ab:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801026b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026b5:	c9                   	leave  
  release(&idelock);
801026b6:	e9 e5 24 00 00       	jmp    80104ba0 <release>
801026bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026bf:	90                   	nop
    idestart(b);
801026c0:	89 d8                	mov    %ebx,%eax
801026c2:	e8 29 fd ff ff       	call   801023f0 <idestart>
801026c7:	eb b5                	jmp    8010267e <iderw+0x7e>
801026c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026d0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801026d5:	eb 9d                	jmp    80102674 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801026d7:	83 ec 0c             	sub    $0xc,%esp
801026da:	68 f9 7f 10 80       	push   $0x80107ff9
801026df:	e8 ac dc ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801026e4:	83 ec 0c             	sub    $0xc,%esp
801026e7:	68 e4 7f 10 80       	push   $0x80107fe4
801026ec:	e8 9f dc ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801026f1:	83 ec 0c             	sub    $0xc,%esp
801026f4:	68 ce 7f 10 80       	push   $0x80107fce
801026f9:	e8 92 dc ff ff       	call   80100390 <panic>
801026fe:	66 90                	xchg   %ax,%ax

80102700 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102700:	f3 0f 1e fb          	endbr32 
80102704:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102705:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010270c:	00 c0 fe 
{
8010270f:	89 e5                	mov    %esp,%ebp
80102711:	56                   	push   %esi
80102712:	53                   	push   %ebx
  ioapic->reg = reg;
80102713:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010271a:	00 00 00 
  return ioapic->data;
8010271d:	8b 15 34 36 11 80    	mov    0x80113634,%edx
80102723:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102726:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010272c:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102732:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102739:	c1 ee 10             	shr    $0x10,%esi
8010273c:	89 f0                	mov    %esi,%eax
8010273e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102741:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102744:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102747:	39 c2                	cmp    %eax,%edx
80102749:	74 16                	je     80102761 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010274b:	83 ec 0c             	sub    $0xc,%esp
8010274e:	68 18 80 10 80       	push   $0x80108018
80102753:	e8 58 df ff ff       	call   801006b0 <cprintf>
80102758:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010275e:	83 c4 10             	add    $0x10,%esp
80102761:	83 c6 21             	add    $0x21,%esi
{
80102764:	ba 10 00 00 00       	mov    $0x10,%edx
80102769:	b8 20 00 00 00       	mov    $0x20,%eax
8010276e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102770:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102772:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102774:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010277a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010277d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102783:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102786:	8d 5a 01             	lea    0x1(%edx),%ebx
80102789:	83 c2 02             	add    $0x2,%edx
8010278c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010278e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102794:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010279b:	39 f0                	cmp    %esi,%eax
8010279d:	75 d1                	jne    80102770 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010279f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027a2:	5b                   	pop    %ebx
801027a3:	5e                   	pop    %esi
801027a4:	5d                   	pop    %ebp
801027a5:	c3                   	ret    
801027a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ad:	8d 76 00             	lea    0x0(%esi),%esi

801027b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801027b0:	f3 0f 1e fb          	endbr32 
801027b4:	55                   	push   %ebp
  ioapic->reg = reg;
801027b5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
801027bb:	89 e5                	mov    %esp,%ebp
801027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801027c0:	8d 50 20             	lea    0x20(%eax),%edx
801027c3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801027c7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027c9:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027cf:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801027d2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801027d8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027da:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027df:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801027e2:	89 50 10             	mov    %edx,0x10(%eax)
}
801027e5:	5d                   	pop    %ebp
801027e6:	c3                   	ret    
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801027f0:	f3 0f 1e fb          	endbr32 
801027f4:	55                   	push   %ebp
801027f5:	89 e5                	mov    %esp,%ebp
801027f7:	53                   	push   %ebx
801027f8:	83 ec 04             	sub    $0x4,%esp
801027fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801027fe:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102804:	75 7a                	jne    80102880 <kfree+0x90>
80102806:	81 fb a8 3b 12 80    	cmp    $0x80123ba8,%ebx
8010280c:	72 72                	jb     80102880 <kfree+0x90>
8010280e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102814:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102819:	77 65                	ja     80102880 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010281b:	83 ec 04             	sub    $0x4,%esp
8010281e:	68 00 10 00 00       	push   $0x1000
80102823:	6a 01                	push   $0x1
80102825:	53                   	push   %ebx
80102826:	e8 c5 23 00 00       	call   80104bf0 <memset>

  if(kmem.use_lock)
8010282b:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102831:	83 c4 10             	add    $0x10,%esp
80102834:	85 d2                	test   %edx,%edx
80102836:	75 20                	jne    80102858 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102838:	a1 78 36 11 80       	mov    0x80113678,%eax
8010283d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010283f:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102844:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
8010284a:	85 c0                	test   %eax,%eax
8010284c:	75 22                	jne    80102870 <kfree+0x80>
    release(&kmem.lock);
}
8010284e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102851:	c9                   	leave  
80102852:	c3                   	ret    
80102853:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102857:	90                   	nop
    acquire(&kmem.lock);
80102858:	83 ec 0c             	sub    $0xc,%esp
8010285b:	68 40 36 11 80       	push   $0x80113640
80102860:	e8 7b 22 00 00       	call   80104ae0 <acquire>
80102865:	83 c4 10             	add    $0x10,%esp
80102868:	eb ce                	jmp    80102838 <kfree+0x48>
8010286a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102870:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102877:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010287a:	c9                   	leave  
    release(&kmem.lock);
8010287b:	e9 20 23 00 00       	jmp    80104ba0 <release>
    panic("kfree");
80102880:	83 ec 0c             	sub    $0xc,%esp
80102883:	68 4a 80 10 80       	push   $0x8010804a
80102888:	e8 03 db ff ff       	call   80100390 <panic>
8010288d:	8d 76 00             	lea    0x0(%esi),%esi

80102890 <freerange>:
{
80102890:	f3 0f 1e fb          	endbr32 
80102894:	55                   	push   %ebp
80102895:	89 e5                	mov    %esp,%ebp
80102897:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102898:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010289b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010289e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010289f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028a5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028b1:	39 de                	cmp    %ebx,%esi
801028b3:	72 1f                	jb     801028d4 <freerange+0x44>
801028b5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801028b8:	83 ec 0c             	sub    $0xc,%esp
801028bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028c7:	50                   	push   %eax
801028c8:	e8 23 ff ff ff       	call   801027f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028cd:	83 c4 10             	add    $0x10,%esp
801028d0:	39 f3                	cmp    %esi,%ebx
801028d2:	76 e4                	jbe    801028b8 <freerange+0x28>
}
801028d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028d7:	5b                   	pop    %ebx
801028d8:	5e                   	pop    %esi
801028d9:	5d                   	pop    %ebp
801028da:	c3                   	ret    
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <kinit1>:
{
801028e0:	f3 0f 1e fb          	endbr32 
801028e4:	55                   	push   %ebp
801028e5:	89 e5                	mov    %esp,%ebp
801028e7:	56                   	push   %esi
801028e8:	53                   	push   %ebx
801028e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801028ec:	83 ec 08             	sub    $0x8,%esp
801028ef:	68 50 80 10 80       	push   $0x80108050
801028f4:	68 40 36 11 80       	push   $0x80113640
801028f9:	e8 62 20 00 00       	call   80104960 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102901:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102904:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
8010290b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010290e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102914:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010291a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102920:	39 de                	cmp    %ebx,%esi
80102922:	72 20                	jb     80102944 <kinit1+0x64>
80102924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102928:	83 ec 0c             	sub    $0xc,%esp
8010292b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102931:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102937:	50                   	push   %eax
80102938:	e8 b3 fe ff ff       	call   801027f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010293d:	83 c4 10             	add    $0x10,%esp
80102940:	39 de                	cmp    %ebx,%esi
80102942:	73 e4                	jae    80102928 <kinit1+0x48>
}
80102944:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102947:	5b                   	pop    %ebx
80102948:	5e                   	pop    %esi
80102949:	5d                   	pop    %ebp
8010294a:	c3                   	ret    
8010294b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop

80102950 <kinit2>:
{
80102950:	f3 0f 1e fb          	endbr32 
80102954:	55                   	push   %ebp
80102955:	89 e5                	mov    %esp,%ebp
80102957:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102958:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010295b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010295e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010295f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102965:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010296b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102971:	39 de                	cmp    %ebx,%esi
80102973:	72 1f                	jb     80102994 <kinit2+0x44>
80102975:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102978:	83 ec 0c             	sub    $0xc,%esp
8010297b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102981:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102987:	50                   	push   %eax
80102988:	e8 63 fe ff ff       	call   801027f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010298d:	83 c4 10             	add    $0x10,%esp
80102990:	39 de                	cmp    %ebx,%esi
80102992:	73 e4                	jae    80102978 <kinit2+0x28>
  kmem.use_lock = 1;
80102994:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010299b:	00 00 00 
}
8010299e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029a1:	5b                   	pop    %ebx
801029a2:	5e                   	pop    %esi
801029a3:	5d                   	pop    %ebp
801029a4:	c3                   	ret    
801029a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801029b0:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
801029b4:	a1 74 36 11 80       	mov    0x80113674,%eax
801029b9:	85 c0                	test   %eax,%eax
801029bb:	75 1b                	jne    801029d8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801029bd:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801029c2:	85 c0                	test   %eax,%eax
801029c4:	74 0a                	je     801029d0 <kalloc+0x20>
    kmem.freelist = r->next;
801029c6:	8b 10                	mov    (%eax),%edx
801029c8:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
801029ce:	c3                   	ret    
801029cf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801029d0:	c3                   	ret    
801029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801029d8:	55                   	push   %ebp
801029d9:	89 e5                	mov    %esp,%ebp
801029db:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801029de:	68 40 36 11 80       	push   $0x80113640
801029e3:	e8 f8 20 00 00       	call   80104ae0 <acquire>
  r = kmem.freelist;
801029e8:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801029ed:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801029f3:	83 c4 10             	add    $0x10,%esp
801029f6:	85 c0                	test   %eax,%eax
801029f8:	74 08                	je     80102a02 <kalloc+0x52>
    kmem.freelist = r->next;
801029fa:	8b 08                	mov    (%eax),%ecx
801029fc:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102a02:	85 d2                	test   %edx,%edx
80102a04:	74 16                	je     80102a1c <kalloc+0x6c>
    release(&kmem.lock);
80102a06:	83 ec 0c             	sub    $0xc,%esp
80102a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a0c:	68 40 36 11 80       	push   $0x80113640
80102a11:	e8 8a 21 00 00       	call   80104ba0 <release>
  return (char*)r;
80102a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102a19:	83 c4 10             	add    $0x10,%esp
}
80102a1c:	c9                   	leave  
80102a1d:	c3                   	ret    
80102a1e:	66 90                	xchg   %ax,%ax

80102a20 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102a20:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a24:	ba 64 00 00 00       	mov    $0x64,%edx
80102a29:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a2a:	a8 01                	test   $0x1,%al
80102a2c:	0f 84 be 00 00 00    	je     80102af0 <kbdgetc+0xd0>
{
80102a32:	55                   	push   %ebp
80102a33:	ba 60 00 00 00       	mov    $0x60,%edx
80102a38:	89 e5                	mov    %esp,%ebp
80102a3a:	53                   	push   %ebx
80102a3b:	ec                   	in     (%dx),%al
  return data;
80102a3c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102a42:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102a45:	3c e0                	cmp    $0xe0,%al
80102a47:	74 57                	je     80102aa0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102a49:	89 d9                	mov    %ebx,%ecx
80102a4b:	83 e1 40             	and    $0x40,%ecx
80102a4e:	84 c0                	test   %al,%al
80102a50:	78 5e                	js     80102ab0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a52:	85 c9                	test   %ecx,%ecx
80102a54:	74 09                	je     80102a5f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a56:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a59:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102a5c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102a5f:	0f b6 8a 80 81 10 80 	movzbl -0x7fef7e80(%edx),%ecx
  shift ^= togglecode[data];
80102a66:	0f b6 82 80 80 10 80 	movzbl -0x7fef7f80(%edx),%eax
  shift |= shiftcode[data];
80102a6d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102a6f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a71:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102a73:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102a79:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a7c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a7f:	8b 04 85 60 80 10 80 	mov    -0x7fef7fa0(,%eax,4),%eax
80102a86:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102a8a:	74 0b                	je     80102a97 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102a8c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a8f:	83 fa 19             	cmp    $0x19,%edx
80102a92:	77 44                	ja     80102ad8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a94:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a97:	5b                   	pop    %ebx
80102a98:	5d                   	pop    %ebp
80102a99:	c3                   	ret    
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102aa0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102aa3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102aa5:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
80102aab:	5b                   	pop    %ebx
80102aac:	5d                   	pop    %ebp
80102aad:	c3                   	ret    
80102aae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102ab0:	83 e0 7f             	and    $0x7f,%eax
80102ab3:	85 c9                	test   %ecx,%ecx
80102ab5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102ab8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102aba:	0f b6 8a 80 81 10 80 	movzbl -0x7fef7e80(%edx),%ecx
80102ac1:	83 c9 40             	or     $0x40,%ecx
80102ac4:	0f b6 c9             	movzbl %cl,%ecx
80102ac7:	f7 d1                	not    %ecx
80102ac9:	21 d9                	and    %ebx,%ecx
}
80102acb:	5b                   	pop    %ebx
80102acc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102acd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102ad3:	c3                   	ret    
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102ad8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102adb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102ade:	5b                   	pop    %ebx
80102adf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102ae0:	83 f9 1a             	cmp    $0x1a,%ecx
80102ae3:	0f 42 c2             	cmovb  %edx,%eax
}
80102ae6:	c3                   	ret    
80102ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aee:	66 90                	xchg   %ax,%ax
    return -1;
80102af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102af5:	c3                   	ret    
80102af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102afd:	8d 76 00             	lea    0x0(%esi),%esi

80102b00 <kbdintr>:

void
kbdintr(void)
{
80102b00:	f3 0f 1e fb          	endbr32 
80102b04:	55                   	push   %ebp
80102b05:	89 e5                	mov    %esp,%ebp
80102b07:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b0a:	68 20 2a 10 80       	push   $0x80102a20
80102b0f:	e8 4c dd ff ff       	call   80100860 <consoleintr>
}
80102b14:	83 c4 10             	add    $0x10,%esp
80102b17:	c9                   	leave  
80102b18:	c3                   	ret    
80102b19:	66 90                	xchg   %ax,%ax
80102b1b:	66 90                	xchg   %ax,%ax
80102b1d:	66 90                	xchg   %ax,%ax
80102b1f:	90                   	nop

80102b20 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102b20:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102b24:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102b29:	85 c0                	test   %eax,%eax
80102b2b:	0f 84 c7 00 00 00    	je     80102bf8 <lapicinit+0xd8>
  lapic[index] = value;
80102b31:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b38:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b3e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b45:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b48:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b4b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b52:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b55:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b58:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b5f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b62:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b65:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b6c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b6f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b72:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b79:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b7f:	8b 50 30             	mov    0x30(%eax),%edx
80102b82:	c1 ea 10             	shr    $0x10,%edx
80102b85:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102b8b:	75 73                	jne    80102c00 <lapicinit+0xe0>
  lapic[index] = value;
80102b8d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b94:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b97:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b9a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ba1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102bae:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bb4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102bbb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bbe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bc1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102bc8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bcb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bce:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102bd5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd8:	8b 50 20             	mov    0x20(%eax),%edx
80102bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bdf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102be0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102be6:	80 e6 10             	and    $0x10,%dh
80102be9:	75 f5                	jne    80102be0 <lapicinit+0xc0>
  lapic[index] = value;
80102beb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102bf2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bf5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102bf8:	c3                   	ret    
80102bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102c00:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c07:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c0a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102c0d:	e9 7b ff ff ff       	jmp    80102b8d <lapicinit+0x6d>
80102c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c20 <lapicid>:

int
lapicid(void)
{
80102c20:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102c24:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102c29:	85 c0                	test   %eax,%eax
80102c2b:	74 0b                	je     80102c38 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102c2d:	8b 40 20             	mov    0x20(%eax),%eax
80102c30:	c1 e8 18             	shr    $0x18,%eax
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102c38:	31 c0                	xor    %eax,%eax
}
80102c3a:	c3                   	ret    
80102c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c3f:	90                   	nop

80102c40 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102c40:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102c44:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102c49:	85 c0                	test   %eax,%eax
80102c4b:	74 0d                	je     80102c5a <lapiceoi+0x1a>
  lapic[index] = value;
80102c4d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c57:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c5a:	c3                   	ret    
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop

80102c60 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102c60:	f3 0f 1e fb          	endbr32 
}
80102c64:	c3                   	ret    
80102c65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c70 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c70:	f3 0f 1e fb          	endbr32 
80102c74:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c75:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c7a:	ba 70 00 00 00       	mov    $0x70,%edx
80102c7f:	89 e5                	mov    %esp,%ebp
80102c81:	53                   	push   %ebx
80102c82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c85:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c88:	ee                   	out    %al,(%dx)
80102c89:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c8e:	ba 71 00 00 00       	mov    $0x71,%edx
80102c93:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c94:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c96:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c99:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c9f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ca1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102ca4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102ca6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ca9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102cac:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102cb2:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102cb7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cbd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cc0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102cc7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cca:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ccd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102cd4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cda:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ce0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ce3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ce9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cec:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cf2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102cfb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102cfc:	8b 40 20             	mov    0x20(%eax),%eax
}
80102cff:	5d                   	pop    %ebp
80102d00:	c3                   	ret    
80102d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d0f:	90                   	nop

80102d10 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102d10:	f3 0f 1e fb          	endbr32 
80102d14:	55                   	push   %ebp
80102d15:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d1a:	ba 70 00 00 00       	mov    $0x70,%edx
80102d1f:	89 e5                	mov    %esp,%ebp
80102d21:	57                   	push   %edi
80102d22:	56                   	push   %esi
80102d23:	53                   	push   %ebx
80102d24:	83 ec 4c             	sub    $0x4c,%esp
80102d27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d28:	ba 71 00 00 00       	mov    $0x71,%edx
80102d2d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102d2e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d31:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d36:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d40:	31 c0                	xor    %eax,%eax
80102d42:	89 da                	mov    %ebx,%edx
80102d44:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d45:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d4a:	89 ca                	mov    %ecx,%edx
80102d4c:	ec                   	in     (%dx),%al
80102d4d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d50:	89 da                	mov    %ebx,%edx
80102d52:	b8 02 00 00 00       	mov    $0x2,%eax
80102d57:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d58:	89 ca                	mov    %ecx,%edx
80102d5a:	ec                   	in     (%dx),%al
80102d5b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d5e:	89 da                	mov    %ebx,%edx
80102d60:	b8 04 00 00 00       	mov    $0x4,%eax
80102d65:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d66:	89 ca                	mov    %ecx,%edx
80102d68:	ec                   	in     (%dx),%al
80102d69:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d6c:	89 da                	mov    %ebx,%edx
80102d6e:	b8 07 00 00 00       	mov    $0x7,%eax
80102d73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d74:	89 ca                	mov    %ecx,%edx
80102d76:	ec                   	in     (%dx),%al
80102d77:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d7a:	89 da                	mov    %ebx,%edx
80102d7c:	b8 08 00 00 00       	mov    $0x8,%eax
80102d81:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d82:	89 ca                	mov    %ecx,%edx
80102d84:	ec                   	in     (%dx),%al
80102d85:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d87:	89 da                	mov    %ebx,%edx
80102d89:	b8 09 00 00 00       	mov    $0x9,%eax
80102d8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8f:	89 ca                	mov    %ecx,%edx
80102d91:	ec                   	in     (%dx),%al
80102d92:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d94:	89 da                	mov    %ebx,%edx
80102d96:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d9c:	89 ca                	mov    %ecx,%edx
80102d9e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d9f:	84 c0                	test   %al,%al
80102da1:	78 9d                	js     80102d40 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102da3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102da7:	89 fa                	mov    %edi,%edx
80102da9:	0f b6 fa             	movzbl %dl,%edi
80102dac:	89 f2                	mov    %esi,%edx
80102dae:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102db1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102db5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db8:	89 da                	mov    %ebx,%edx
80102dba:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102dbd:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102dc0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102dc4:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102dc7:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102dca:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102dce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102dd1:	31 c0                	xor    %eax,%eax
80102dd3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd4:	89 ca                	mov    %ecx,%edx
80102dd6:	ec                   	in     (%dx),%al
80102dd7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dda:	89 da                	mov    %ebx,%edx
80102ddc:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ddf:	b8 02 00 00 00       	mov    $0x2,%eax
80102de4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de5:	89 ca                	mov    %ecx,%edx
80102de7:	ec                   	in     (%dx),%al
80102de8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102deb:	89 da                	mov    %ebx,%edx
80102ded:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102df0:	b8 04 00 00 00       	mov    $0x4,%eax
80102df5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102df6:	89 ca                	mov    %ecx,%edx
80102df8:	ec                   	in     (%dx),%al
80102df9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dfc:	89 da                	mov    %ebx,%edx
80102dfe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102e01:	b8 07 00 00 00       	mov    $0x7,%eax
80102e06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e07:	89 ca                	mov    %ecx,%edx
80102e09:	ec                   	in     (%dx),%al
80102e0a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e0d:	89 da                	mov    %ebx,%edx
80102e0f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e12:	b8 08 00 00 00       	mov    $0x8,%eax
80102e17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e18:	89 ca                	mov    %ecx,%edx
80102e1a:	ec                   	in     (%dx),%al
80102e1b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e1e:	89 da                	mov    %ebx,%edx
80102e20:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e23:	b8 09 00 00 00       	mov    $0x9,%eax
80102e28:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e29:	89 ca                	mov    %ecx,%edx
80102e2b:	ec                   	in     (%dx),%al
80102e2c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e2f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e35:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e38:	6a 18                	push   $0x18
80102e3a:	50                   	push   %eax
80102e3b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e3e:	50                   	push   %eax
80102e3f:	e8 fc 1d 00 00       	call   80104c40 <memcmp>
80102e44:	83 c4 10             	add    $0x10,%esp
80102e47:	85 c0                	test   %eax,%eax
80102e49:	0f 85 f1 fe ff ff    	jne    80102d40 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102e4f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e53:	75 78                	jne    80102ecd <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e55:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e58:	89 c2                	mov    %eax,%edx
80102e5a:	83 e0 0f             	and    $0xf,%eax
80102e5d:	c1 ea 04             	shr    $0x4,%edx
80102e60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e66:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e69:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e6c:	89 c2                	mov    %eax,%edx
80102e6e:	83 e0 0f             	and    $0xf,%eax
80102e71:	c1 ea 04             	shr    $0x4,%edx
80102e74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e7a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e7d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e80:	89 c2                	mov    %eax,%edx
80102e82:	83 e0 0f             	and    $0xf,%eax
80102e85:	c1 ea 04             	shr    $0x4,%edx
80102e88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e8e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e91:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e94:	89 c2                	mov    %eax,%edx
80102e96:	83 e0 0f             	and    $0xf,%eax
80102e99:	c1 ea 04             	shr    $0x4,%edx
80102e9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ea2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ea5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ea8:	89 c2                	mov    %eax,%edx
80102eaa:	83 e0 0f             	and    $0xf,%eax
80102ead:	c1 ea 04             	shr    $0x4,%edx
80102eb0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102eb3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eb6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102eb9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ebc:	89 c2                	mov    %eax,%edx
80102ebe:	83 e0 0f             	and    $0xf,%eax
80102ec1:	c1 ea 04             	shr    $0x4,%edx
80102ec4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ec7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eca:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ecd:	8b 75 08             	mov    0x8(%ebp),%esi
80102ed0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ed3:	89 06                	mov    %eax,(%esi)
80102ed5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ed8:	89 46 04             	mov    %eax,0x4(%esi)
80102edb:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ede:	89 46 08             	mov    %eax,0x8(%esi)
80102ee1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ee4:	89 46 0c             	mov    %eax,0xc(%esi)
80102ee7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102eea:	89 46 10             	mov    %eax,0x10(%esi)
80102eed:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ef0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102ef3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102efd:	5b                   	pop    %ebx
80102efe:	5e                   	pop    %esi
80102eff:	5f                   	pop    %edi
80102f00:	5d                   	pop    %ebp
80102f01:	c3                   	ret    
80102f02:	66 90                	xchg   %ax,%ax
80102f04:	66 90                	xchg   %ax,%ax
80102f06:	66 90                	xchg   %ax,%ax
80102f08:	66 90                	xchg   %ax,%ax
80102f0a:	66 90                	xchg   %ax,%ax
80102f0c:	66 90                	xchg   %ax,%ax
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f10:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102f16:	85 c9                	test   %ecx,%ecx
80102f18:	0f 8e 8a 00 00 00    	jle    80102fa8 <install_trans+0x98>
{
80102f1e:	55                   	push   %ebp
80102f1f:	89 e5                	mov    %esp,%ebp
80102f21:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102f22:	31 ff                	xor    %edi,%edi
{
80102f24:	56                   	push   %esi
80102f25:	53                   	push   %ebx
80102f26:	83 ec 0c             	sub    $0xc,%esp
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f30:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102f35:	83 ec 08             	sub    $0x8,%esp
80102f38:	01 f8                	add    %edi,%eax
80102f3a:	83 c0 01             	add    $0x1,%eax
80102f3d:	50                   	push   %eax
80102f3e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102f44:	e8 87 d1 ff ff       	call   801000d0 <bread>
80102f49:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f4b:	58                   	pop    %eax
80102f4c:	5a                   	pop    %edx
80102f4d:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102f54:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f5a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f5d:	e8 6e d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f62:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f65:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f67:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f6a:	68 00 02 00 00       	push   $0x200
80102f6f:	50                   	push   %eax
80102f70:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102f73:	50                   	push   %eax
80102f74:	e8 17 1d 00 00       	call   80104c90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f79:	89 1c 24             	mov    %ebx,(%esp)
80102f7c:	e8 2f d2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102f81:	89 34 24             	mov    %esi,(%esp)
80102f84:	e8 67 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102f89:	89 1c 24             	mov    %ebx,(%esp)
80102f8c:	e8 5f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102f9a:	7f 94                	jg     80102f30 <install_trans+0x20>
  }
}
80102f9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f9f:	5b                   	pop    %ebx
80102fa0:	5e                   	pop    %esi
80102fa1:	5f                   	pop    %edi
80102fa2:	5d                   	pop    %ebp
80102fa3:	c3                   	ret    
80102fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fa8:	c3                   	ret    
80102fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fb0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fb7:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102fbd:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102fc3:	e8 08 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102fc8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fcb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102fcd:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102fd2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102fd5:	85 c0                	test   %eax,%eax
80102fd7:	7e 19                	jle    80102ff2 <write_head+0x42>
80102fd9:	31 d2                	xor    %edx,%edx
80102fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fdf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102fe0:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102fe7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102feb:	83 c2 01             	add    $0x1,%edx
80102fee:	39 d0                	cmp    %edx,%eax
80102ff0:	75 ee                	jne    80102fe0 <write_head+0x30>
  }
  bwrite(buf);
80102ff2:	83 ec 0c             	sub    $0xc,%esp
80102ff5:	53                   	push   %ebx
80102ff6:	e8 b5 d1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ffb:	89 1c 24             	mov    %ebx,(%esp)
80102ffe:	e8 ed d1 ff ff       	call   801001f0 <brelse>
}
80103003:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103006:	83 c4 10             	add    $0x10,%esp
80103009:	c9                   	leave  
8010300a:	c3                   	ret    
8010300b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010300f:	90                   	nop

80103010 <initlog>:
{
80103010:	f3 0f 1e fb          	endbr32 
80103014:	55                   	push   %ebp
80103015:	89 e5                	mov    %esp,%ebp
80103017:	53                   	push   %ebx
80103018:	83 ec 2c             	sub    $0x2c,%esp
8010301b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010301e:	68 80 82 10 80       	push   $0x80108280
80103023:	68 80 36 11 80       	push   $0x80113680
80103028:	e8 33 19 00 00       	call   80104960 <initlock>
  readsb(dev, &sb);
8010302d:	58                   	pop    %eax
8010302e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103031:	5a                   	pop    %edx
80103032:	50                   	push   %eax
80103033:	53                   	push   %ebx
80103034:	e8 c7 e4 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80103039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010303c:	59                   	pop    %ecx
  log.dev = dev;
8010303d:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80103043:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103046:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
8010304b:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80103051:	5a                   	pop    %edx
80103052:	50                   	push   %eax
80103053:	53                   	push   %ebx
80103054:	e8 77 d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103059:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010305c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010305f:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80103065:	85 c9                	test   %ecx,%ecx
80103067:	7e 19                	jle    80103082 <initlog+0x72>
80103069:	31 d2                	xor    %edx,%edx
8010306b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010306f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103070:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103074:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010307b:	83 c2 01             	add    $0x1,%edx
8010307e:	39 d1                	cmp    %edx,%ecx
80103080:	75 ee                	jne    80103070 <initlog+0x60>
  brelse(buf);
80103082:	83 ec 0c             	sub    $0xc,%esp
80103085:	50                   	push   %eax
80103086:	e8 65 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010308b:	e8 80 fe ff ff       	call   80102f10 <install_trans>
  log.lh.n = 0;
80103090:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80103097:	00 00 00 
  write_head(); // clear the log
8010309a:	e8 11 ff ff ff       	call   80102fb0 <write_head>
}
8010309f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030a2:	83 c4 10             	add    $0x10,%esp
801030a5:	c9                   	leave  
801030a6:	c3                   	ret    
801030a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ae:	66 90                	xchg   %ax,%ax

801030b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801030b0:	f3 0f 1e fb          	endbr32 
801030b4:	55                   	push   %ebp
801030b5:	89 e5                	mov    %esp,%ebp
801030b7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801030ba:	68 80 36 11 80       	push   $0x80113680
801030bf:	e8 1c 1a 00 00       	call   80104ae0 <acquire>
801030c4:	83 c4 10             	add    $0x10,%esp
801030c7:	eb 1c                	jmp    801030e5 <begin_op+0x35>
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801030d0:	83 ec 08             	sub    $0x8,%esp
801030d3:	68 80 36 11 80       	push   $0x80113680
801030d8:	68 80 36 11 80       	push   $0x80113680
801030dd:	e8 1e 12 00 00       	call   80104300 <sleep>
801030e2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801030e5:	a1 c0 36 11 80       	mov    0x801136c0,%eax
801030ea:	85 c0                	test   %eax,%eax
801030ec:	75 e2                	jne    801030d0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801030ee:	a1 bc 36 11 80       	mov    0x801136bc,%eax
801030f3:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
801030f9:	83 c0 01             	add    $0x1,%eax
801030fc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030ff:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103102:	83 fa 1e             	cmp    $0x1e,%edx
80103105:	7f c9                	jg     801030d0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103107:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010310a:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
8010310f:	68 80 36 11 80       	push   $0x80113680
80103114:	e8 87 1a 00 00       	call   80104ba0 <release>
      break;
    }
  }
}
80103119:	83 c4 10             	add    $0x10,%esp
8010311c:	c9                   	leave  
8010311d:	c3                   	ret    
8010311e:	66 90                	xchg   %ax,%ax

80103120 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103120:	f3 0f 1e fb          	endbr32 
80103124:	55                   	push   %ebp
80103125:	89 e5                	mov    %esp,%ebp
80103127:	57                   	push   %edi
80103128:	56                   	push   %esi
80103129:	53                   	push   %ebx
8010312a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010312d:	68 80 36 11 80       	push   $0x80113680
80103132:	e8 a9 19 00 00       	call   80104ae0 <acquire>
  log.outstanding -= 1;
80103137:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
8010313c:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80103142:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103145:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103148:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
8010314e:	85 f6                	test   %esi,%esi
80103150:	0f 85 1e 01 00 00    	jne    80103274 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103156:	85 db                	test   %ebx,%ebx
80103158:	0f 85 f2 00 00 00    	jne    80103250 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010315e:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80103165:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103168:	83 ec 0c             	sub    $0xc,%esp
8010316b:	68 80 36 11 80       	push   $0x80113680
80103170:	e8 2b 1a 00 00       	call   80104ba0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103175:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
8010317b:	83 c4 10             	add    $0x10,%esp
8010317e:	85 c9                	test   %ecx,%ecx
80103180:	7f 3e                	jg     801031c0 <end_op+0xa0>
    acquire(&log.lock);
80103182:	83 ec 0c             	sub    $0xc,%esp
80103185:	68 80 36 11 80       	push   $0x80113680
8010318a:	e8 51 19 00 00       	call   80104ae0 <acquire>
    wakeup(&log);
8010318f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80103196:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
8010319d:	00 00 00 
    wakeup(&log);
801031a0:	e8 1b 13 00 00       	call   801044c0 <wakeup>
    release(&log.lock);
801031a5:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801031ac:	e8 ef 19 00 00       	call   80104ba0 <release>
801031b1:	83 c4 10             	add    $0x10,%esp
}
801031b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031b7:	5b                   	pop    %ebx
801031b8:	5e                   	pop    %esi
801031b9:	5f                   	pop    %edi
801031ba:	5d                   	pop    %ebp
801031bb:	c3                   	ret    
801031bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801031c0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801031c5:	83 ec 08             	sub    $0x8,%esp
801031c8:	01 d8                	add    %ebx,%eax
801031ca:	83 c0 01             	add    $0x1,%eax
801031cd:	50                   	push   %eax
801031ce:	ff 35 c4 36 11 80    	pushl  0x801136c4
801031d4:	e8 f7 ce ff ff       	call   801000d0 <bread>
801031d9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031db:	58                   	pop    %eax
801031dc:	5a                   	pop    %edx
801031dd:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
801031e4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
801031ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031ed:	e8 de ce ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801031f2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031f5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801031f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801031fa:	68 00 02 00 00       	push   $0x200
801031ff:	50                   	push   %eax
80103200:	8d 46 5c             	lea    0x5c(%esi),%eax
80103203:	50                   	push   %eax
80103204:	e8 87 1a 00 00       	call   80104c90 <memmove>
    bwrite(to);  // write the log
80103209:	89 34 24             	mov    %esi,(%esp)
8010320c:	e8 9f cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103211:	89 3c 24             	mov    %edi,(%esp)
80103214:	e8 d7 cf ff ff       	call   801001f0 <brelse>
    brelse(to);
80103219:	89 34 24             	mov    %esi,(%esp)
8010321c:	e8 cf cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103221:	83 c4 10             	add    $0x10,%esp
80103224:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
8010322a:	7c 94                	jl     801031c0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010322c:	e8 7f fd ff ff       	call   80102fb0 <write_head>
    install_trans(); // Now install writes to home locations
80103231:	e8 da fc ff ff       	call   80102f10 <install_trans>
    log.lh.n = 0;
80103236:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
8010323d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103240:	e8 6b fd ff ff       	call   80102fb0 <write_head>
80103245:	e9 38 ff ff ff       	jmp    80103182 <end_op+0x62>
8010324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103250:	83 ec 0c             	sub    $0xc,%esp
80103253:	68 80 36 11 80       	push   $0x80113680
80103258:	e8 63 12 00 00       	call   801044c0 <wakeup>
  release(&log.lock);
8010325d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103264:	e8 37 19 00 00       	call   80104ba0 <release>
80103269:	83 c4 10             	add    $0x10,%esp
}
8010326c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010326f:	5b                   	pop    %ebx
80103270:	5e                   	pop    %esi
80103271:	5f                   	pop    %edi
80103272:	5d                   	pop    %ebp
80103273:	c3                   	ret    
    panic("log.committing");
80103274:	83 ec 0c             	sub    $0xc,%esp
80103277:	68 84 82 10 80       	push   $0x80108284
8010327c:	e8 0f d1 ff ff       	call   80100390 <panic>
80103281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010328f:	90                   	nop

80103290 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103290:	f3 0f 1e fb          	endbr32 
80103294:	55                   	push   %ebp
80103295:	89 e5                	mov    %esp,%ebp
80103297:	53                   	push   %ebx
80103298:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010329b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
801032a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032a4:	83 fa 1d             	cmp    $0x1d,%edx
801032a7:	0f 8f 91 00 00 00    	jg     8010333e <log_write+0xae>
801032ad:	a1 b8 36 11 80       	mov    0x801136b8,%eax
801032b2:	83 e8 01             	sub    $0x1,%eax
801032b5:	39 c2                	cmp    %eax,%edx
801032b7:	0f 8d 81 00 00 00    	jge    8010333e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801032bd:	a1 bc 36 11 80       	mov    0x801136bc,%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	0f 8e 81 00 00 00    	jle    8010334b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801032ca:	83 ec 0c             	sub    $0xc,%esp
801032cd:	68 80 36 11 80       	push   $0x80113680
801032d2:	e8 09 18 00 00       	call   80104ae0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801032d7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
801032dd:	83 c4 10             	add    $0x10,%esp
801032e0:	85 d2                	test   %edx,%edx
801032e2:	7e 4e                	jle    80103332 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032e4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801032e7:	31 c0                	xor    %eax,%eax
801032e9:	eb 0c                	jmp    801032f7 <log_write+0x67>
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
801032f0:	83 c0 01             	add    $0x1,%eax
801032f3:	39 c2                	cmp    %eax,%edx
801032f5:	74 29                	je     80103320 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032f7:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
801032fe:	75 f0                	jne    801032f0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103300:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103307:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010330a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010330d:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80103314:	c9                   	leave  
  release(&log.lock);
80103315:	e9 86 18 00 00       	jmp    80104ba0 <release>
8010331a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103320:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
80103327:	83 c2 01             	add    $0x1,%edx
8010332a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80103330:	eb d5                	jmp    80103307 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103332:	8b 43 08             	mov    0x8(%ebx),%eax
80103335:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
8010333a:	75 cb                	jne    80103307 <log_write+0x77>
8010333c:	eb e9                	jmp    80103327 <log_write+0x97>
    panic("too big a transaction");
8010333e:	83 ec 0c             	sub    $0xc,%esp
80103341:	68 93 82 10 80       	push   $0x80108293
80103346:	e8 45 d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010334b:	83 ec 0c             	sub    $0xc,%esp
8010334e:	68 a9 82 10 80       	push   $0x801082a9
80103353:	e8 38 d0 ff ff       	call   80100390 <panic>
80103358:	66 90                	xchg   %ax,%ax
8010335a:	66 90                	xchg   %ax,%ax
8010335c:	66 90                	xchg   %ax,%ax
8010335e:	66 90                	xchg   %ax,%ax

80103360 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	53                   	push   %ebx
80103364:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103367:	e8 94 09 00 00       	call   80103d00 <cpuid>
8010336c:	89 c3                	mov    %eax,%ebx
8010336e:	e8 8d 09 00 00       	call   80103d00 <cpuid>
80103373:	83 ec 04             	sub    $0x4,%esp
80103376:	53                   	push   %ebx
80103377:	50                   	push   %eax
80103378:	68 c4 82 10 80       	push   $0x801082c4
8010337d:	e8 2e d3 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103382:	e8 39 2b 00 00       	call   80105ec0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103387:	e8 04 09 00 00       	call   80103c90 <mycpu>
8010338c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010338e:	b8 01 00 00 00       	mov    $0x1,%eax
80103393:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010339a:	e8 71 0c 00 00       	call   80104010 <scheduler>
8010339f:	90                   	nop

801033a0 <mpenter>:
{
801033a0:	f3 0f 1e fb          	endbr32 
801033a4:	55                   	push   %ebp
801033a5:	89 e5                	mov    %esp,%ebp
801033a7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801033aa:	e8 71 3c 00 00       	call   80107020 <switchkvm>
  seginit();
801033af:	e8 8c 3b 00 00       	call   80106f40 <seginit>
  lapicinit();
801033b4:	e8 67 f7 ff ff       	call   80102b20 <lapicinit>
  mpmain();
801033b9:	e8 a2 ff ff ff       	call   80103360 <mpmain>
801033be:	66 90                	xchg   %ax,%ax

801033c0 <main>:
{
801033c0:	f3 0f 1e fb          	endbr32 
801033c4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801033c8:	83 e4 f0             	and    $0xfffffff0,%esp
801033cb:	ff 71 fc             	pushl  -0x4(%ecx)
801033ce:	55                   	push   %ebp
801033cf:	89 e5                	mov    %esp,%ebp
801033d1:	53                   	push   %ebx
801033d2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033d3:	83 ec 08             	sub    $0x8,%esp
801033d6:	68 00 00 40 80       	push   $0x80400000
801033db:	68 a8 3b 12 80       	push   $0x80123ba8
801033e0:	e8 fb f4 ff ff       	call   801028e0 <kinit1>
  kvmalloc();      // kernel page table
801033e5:	e8 76 45 00 00       	call   80107960 <kvmalloc>
  mpinit();        // detect other processors
801033ea:	e8 81 01 00 00       	call   80103570 <mpinit>
  lapicinit();     // interrupt controller
801033ef:	e8 2c f7 ff ff       	call   80102b20 <lapicinit>
  seginit();       // segment descriptors
801033f4:	e8 47 3b 00 00       	call   80106f40 <seginit>
  picinit();       // disable pic
801033f9:	e8 52 03 00 00       	call   80103750 <picinit>
  ioapicinit();    // another interrupt controller
801033fe:	e8 fd f2 ff ff       	call   80102700 <ioapicinit>
  consoleinit();   // console hardware
80103403:	e8 28 d6 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103408:	e8 a3 2e 00 00       	call   801062b0 <uartinit>
  pinit();         // process table
8010340d:	e8 5e 08 00 00       	call   80103c70 <pinit>
  tvinit();        // trap vectors
80103412:	e8 29 2a 00 00       	call   80105e40 <tvinit>
  binit();         // buffer cache
80103417:	e8 24 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010341c:	e8 bf d9 ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80103421:	e8 aa f0 ff ff       	call   801024d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103426:	83 c4 0c             	add    $0xc,%esp
80103429:	68 8a 00 00 00       	push   $0x8a
8010342e:	68 8c b4 10 80       	push   $0x8010b48c
80103433:	68 00 70 00 80       	push   $0x80007000
80103438:	e8 53 18 00 00       	call   80104c90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010343d:	83 c4 10             	add    $0x10,%esp
80103440:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103447:	00 00 00 
8010344a:	05 80 37 11 80       	add    $0x80113780,%eax
8010344f:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80103454:	76 7a                	jbe    801034d0 <main+0x110>
80103456:	bb 80 37 11 80       	mov    $0x80113780,%ebx
8010345b:	eb 1c                	jmp    80103479 <main+0xb9>
8010345d:	8d 76 00             	lea    0x0(%esi),%esi
80103460:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103467:	00 00 00 
8010346a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103470:	05 80 37 11 80       	add    $0x80113780,%eax
80103475:	39 c3                	cmp    %eax,%ebx
80103477:	73 57                	jae    801034d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103479:	e8 12 08 00 00       	call   80103c90 <mycpu>
8010347e:	39 c3                	cmp    %eax,%ebx
80103480:	74 de                	je     80103460 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103482:	e8 29 f5 ff ff       	call   801029b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103487:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010348a:	c7 05 f8 6f 00 80 a0 	movl   $0x801033a0,0x80006ff8
80103491:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103494:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010349b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010349e:	05 00 10 00 00       	add    $0x1000,%eax
801034a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801034a8:	0f b6 03             	movzbl (%ebx),%eax
801034ab:	68 00 70 00 00       	push   $0x7000
801034b0:	50                   	push   %eax
801034b1:	e8 ba f7 ff ff       	call   80102c70 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801034b6:	83 c4 10             	add    $0x10,%esp
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801034c6:	85 c0                	test   %eax,%eax
801034c8:	74 f6                	je     801034c0 <main+0x100>
801034ca:	eb 94                	jmp    80103460 <main+0xa0>
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034d0:	83 ec 08             	sub    $0x8,%esp
801034d3:	68 00 00 00 8e       	push   $0x8e000000
801034d8:	68 00 00 40 80       	push   $0x80400000
801034dd:	e8 6e f4 ff ff       	call   80102950 <kinit2>
  userinit();      // first user process
801034e2:	e8 69 08 00 00       	call   80103d50 <userinit>
  mpmain();        // finish this processor's setup
801034e7:	e8 74 fe ff ff       	call   80103360 <mpmain>
801034ec:	66 90                	xchg   %ax,%ax
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801034f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801034fb:	53                   	push   %ebx
  e = addr+len;
801034fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801034ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103502:	39 de                	cmp    %ebx,%esi
80103504:	72 10                	jb     80103516 <mpsearch1+0x26>
80103506:	eb 50                	jmp    80103558 <mpsearch1+0x68>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop
80103510:	89 fe                	mov    %edi,%esi
80103512:	39 fb                	cmp    %edi,%ebx
80103514:	76 42                	jbe    80103558 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103516:	83 ec 04             	sub    $0x4,%esp
80103519:	8d 7e 10             	lea    0x10(%esi),%edi
8010351c:	6a 04                	push   $0x4
8010351e:	68 d8 82 10 80       	push   $0x801082d8
80103523:	56                   	push   %esi
80103524:	e8 17 17 00 00       	call   80104c40 <memcmp>
80103529:	83 c4 10             	add    $0x10,%esp
8010352c:	85 c0                	test   %eax,%eax
8010352e:	75 e0                	jne    80103510 <mpsearch1+0x20>
80103530:	89 f2                	mov    %esi,%edx
80103532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103538:	0f b6 0a             	movzbl (%edx),%ecx
8010353b:	83 c2 01             	add    $0x1,%edx
8010353e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103540:	39 fa                	cmp    %edi,%edx
80103542:	75 f4                	jne    80103538 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103544:	84 c0                	test   %al,%al
80103546:	75 c8                	jne    80103510 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103548:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010354b:	89 f0                	mov    %esi,%eax
8010354d:	5b                   	pop    %ebx
8010354e:	5e                   	pop    %esi
8010354f:	5f                   	pop    %edi
80103550:	5d                   	pop    %ebp
80103551:	c3                   	ret    
80103552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103558:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010355b:	31 f6                	xor    %esi,%esi
}
8010355d:	5b                   	pop    %ebx
8010355e:	89 f0                	mov    %esi,%eax
80103560:	5e                   	pop    %esi
80103561:	5f                   	pop    %edi
80103562:	5d                   	pop    %ebp
80103563:	c3                   	ret    
80103564:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010356b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010356f:	90                   	nop

80103570 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103570:	f3 0f 1e fb          	endbr32 
80103574:	55                   	push   %ebp
80103575:	89 e5                	mov    %esp,%ebp
80103577:	57                   	push   %edi
80103578:	56                   	push   %esi
80103579:	53                   	push   %ebx
8010357a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010357d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103584:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010358b:	c1 e0 08             	shl    $0x8,%eax
8010358e:	09 d0                	or     %edx,%eax
80103590:	c1 e0 04             	shl    $0x4,%eax
80103593:	75 1b                	jne    801035b0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103595:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010359c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801035a3:	c1 e0 08             	shl    $0x8,%eax
801035a6:	09 d0                	or     %edx,%eax
801035a8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801035ab:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801035b0:	ba 00 04 00 00       	mov    $0x400,%edx
801035b5:	e8 36 ff ff ff       	call   801034f0 <mpsearch1>
801035ba:	89 c6                	mov    %eax,%esi
801035bc:	85 c0                	test   %eax,%eax
801035be:	0f 84 4c 01 00 00    	je     80103710 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035c4:	8b 5e 04             	mov    0x4(%esi),%ebx
801035c7:	85 db                	test   %ebx,%ebx
801035c9:	0f 84 61 01 00 00    	je     80103730 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801035cf:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035d2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801035d8:	6a 04                	push   $0x4
801035da:	68 dd 82 10 80       	push   $0x801082dd
801035df:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801035e3:	e8 58 16 00 00       	call   80104c40 <memcmp>
801035e8:	83 c4 10             	add    $0x10,%esp
801035eb:	85 c0                	test   %eax,%eax
801035ed:	0f 85 3d 01 00 00    	jne    80103730 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801035f3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801035fa:	3c 01                	cmp    $0x1,%al
801035fc:	74 08                	je     80103606 <mpinit+0x96>
801035fe:	3c 04                	cmp    $0x4,%al
80103600:	0f 85 2a 01 00 00    	jne    80103730 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103606:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010360d:	66 85 d2             	test   %dx,%dx
80103610:	74 26                	je     80103638 <mpinit+0xc8>
80103612:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103615:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103617:	31 d2                	xor    %edx,%edx
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103620:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103627:	83 c0 01             	add    $0x1,%eax
8010362a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010362c:	39 f8                	cmp    %edi,%eax
8010362e:	75 f0                	jne    80103620 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103630:	84 d2                	test   %dl,%dl
80103632:	0f 85 f8 00 00 00    	jne    80103730 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103638:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010363e:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103643:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103649:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103650:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103655:	03 55 e4             	add    -0x1c(%ebp),%edx
80103658:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010365b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010365f:	90                   	nop
80103660:	39 c2                	cmp    %eax,%edx
80103662:	76 15                	jbe    80103679 <mpinit+0x109>
    switch(*p){
80103664:	0f b6 08             	movzbl (%eax),%ecx
80103667:	80 f9 02             	cmp    $0x2,%cl
8010366a:	74 5c                	je     801036c8 <mpinit+0x158>
8010366c:	77 42                	ja     801036b0 <mpinit+0x140>
8010366e:	84 c9                	test   %cl,%cl
80103670:	74 6e                	je     801036e0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103672:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103675:	39 c2                	cmp    %eax,%edx
80103677:	77 eb                	ja     80103664 <mpinit+0xf4>
80103679:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010367c:	85 db                	test   %ebx,%ebx
8010367e:	0f 84 b9 00 00 00    	je     8010373d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103684:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103688:	74 15                	je     8010369f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010368a:	b8 70 00 00 00       	mov    $0x70,%eax
8010368f:	ba 22 00 00 00       	mov    $0x22,%edx
80103694:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103695:	ba 23 00 00 00       	mov    $0x23,%edx
8010369a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010369b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010369e:	ee                   	out    %al,(%dx)
  }
}
8010369f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036a2:	5b                   	pop    %ebx
801036a3:	5e                   	pop    %esi
801036a4:	5f                   	pop    %edi
801036a5:	5d                   	pop    %ebp
801036a6:	c3                   	ret    
801036a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ae:	66 90                	xchg   %ax,%ax
    switch(*p){
801036b0:	83 e9 03             	sub    $0x3,%ecx
801036b3:	80 f9 01             	cmp    $0x1,%cl
801036b6:	76 ba                	jbe    80103672 <mpinit+0x102>
801036b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801036bf:	eb 9f                	jmp    80103660 <mpinit+0xf0>
801036c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801036c8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801036cc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801036cf:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
801036d5:	eb 89                	jmp    80103660 <mpinit+0xf0>
801036d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036de:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801036e0:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801036e6:	83 f9 07             	cmp    $0x7,%ecx
801036e9:	7f 19                	jg     80103704 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036eb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801036f1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801036f5:	83 c1 01             	add    $0x1,%ecx
801036f8:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036fe:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
80103704:	83 c0 14             	add    $0x14,%eax
      continue;
80103707:	e9 54 ff ff ff       	jmp    80103660 <mpinit+0xf0>
8010370c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103710:	ba 00 00 01 00       	mov    $0x10000,%edx
80103715:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010371a:	e8 d1 fd ff ff       	call   801034f0 <mpsearch1>
8010371f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103721:	85 c0                	test   %eax,%eax
80103723:	0f 85 9b fe ff ff    	jne    801035c4 <mpinit+0x54>
80103729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	68 e2 82 10 80       	push   $0x801082e2
80103738:	e8 53 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010373d:	83 ec 0c             	sub    $0xc,%esp
80103740:	68 fc 82 10 80       	push   $0x801082fc
80103745:	e8 46 cc ff ff       	call   80100390 <panic>
8010374a:	66 90                	xchg   %ax,%ax
8010374c:	66 90                	xchg   %ax,%ax
8010374e:	66 90                	xchg   %ax,%ax

80103750 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103750:	f3 0f 1e fb          	endbr32 
80103754:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103759:	ba 21 00 00 00       	mov    $0x21,%edx
8010375e:	ee                   	out    %al,(%dx)
8010375f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103764:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103765:	c3                   	ret    
80103766:	66 90                	xchg   %ax,%ax
80103768:	66 90                	xchg   %ax,%ax
8010376a:	66 90                	xchg   %ax,%ax
8010376c:	66 90                	xchg   %ax,%ax
8010376e:	66 90                	xchg   %ax,%ax

80103770 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103770:	f3 0f 1e fb          	endbr32 
80103774:	55                   	push   %ebp
80103775:	89 e5                	mov    %esp,%ebp
80103777:	57                   	push   %edi
80103778:	56                   	push   %esi
80103779:	53                   	push   %ebx
8010377a:	83 ec 0c             	sub    $0xc,%esp
8010377d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103780:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103783:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103789:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010378f:	e8 6c d6 ff ff       	call   80100e00 <filealloc>
80103794:	89 03                	mov    %eax,(%ebx)
80103796:	85 c0                	test   %eax,%eax
80103798:	0f 84 ac 00 00 00    	je     8010384a <pipealloc+0xda>
8010379e:	e8 5d d6 ff ff       	call   80100e00 <filealloc>
801037a3:	89 06                	mov    %eax,(%esi)
801037a5:	85 c0                	test   %eax,%eax
801037a7:	0f 84 8b 00 00 00    	je     80103838 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801037ad:	e8 fe f1 ff ff       	call   801029b0 <kalloc>
801037b2:	89 c7                	mov    %eax,%edi
801037b4:	85 c0                	test   %eax,%eax
801037b6:	0f 84 b4 00 00 00    	je     80103870 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
801037bc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801037c3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801037c6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801037c9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037d0:	00 00 00 
  p->nwrite = 0;
801037d3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037da:	00 00 00 
  p->nread = 0;
801037dd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037e4:	00 00 00 
  initlock(&p->lock, "pipe");
801037e7:	68 1b 83 10 80       	push   $0x8010831b
801037ec:	50                   	push   %eax
801037ed:	e8 6e 11 00 00       	call   80104960 <initlock>
  (*f0)->type = FD_PIPE;
801037f2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801037f4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037fd:	8b 03                	mov    (%ebx),%eax
801037ff:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103803:	8b 03                	mov    (%ebx),%eax
80103805:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103809:	8b 03                	mov    (%ebx),%eax
8010380b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010380e:	8b 06                	mov    (%esi),%eax
80103810:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103816:	8b 06                	mov    (%esi),%eax
80103818:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010381c:	8b 06                	mov    (%esi),%eax
8010381e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103822:	8b 06                	mov    (%esi),%eax
80103824:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103827:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010382a:	31 c0                	xor    %eax,%eax
}
8010382c:	5b                   	pop    %ebx
8010382d:	5e                   	pop    %esi
8010382e:	5f                   	pop    %edi
8010382f:	5d                   	pop    %ebp
80103830:	c3                   	ret    
80103831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103838:	8b 03                	mov    (%ebx),%eax
8010383a:	85 c0                	test   %eax,%eax
8010383c:	74 1e                	je     8010385c <pipealloc+0xec>
    fileclose(*f0);
8010383e:	83 ec 0c             	sub    $0xc,%esp
80103841:	50                   	push   %eax
80103842:	e8 79 d6 ff ff       	call   80100ec0 <fileclose>
80103847:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010384a:	8b 06                	mov    (%esi),%eax
8010384c:	85 c0                	test   %eax,%eax
8010384e:	74 0c                	je     8010385c <pipealloc+0xec>
    fileclose(*f1);
80103850:	83 ec 0c             	sub    $0xc,%esp
80103853:	50                   	push   %eax
80103854:	e8 67 d6 ff ff       	call   80100ec0 <fileclose>
80103859:	83 c4 10             	add    $0x10,%esp
}
8010385c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010385f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103864:	5b                   	pop    %ebx
80103865:	5e                   	pop    %esi
80103866:	5f                   	pop    %edi
80103867:	5d                   	pop    %ebp
80103868:	c3                   	ret    
80103869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103870:	8b 03                	mov    (%ebx),%eax
80103872:	85 c0                	test   %eax,%eax
80103874:	75 c8                	jne    8010383e <pipealloc+0xce>
80103876:	eb d2                	jmp    8010384a <pipealloc+0xda>
80103878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop

80103880 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	56                   	push   %esi
80103888:	53                   	push   %ebx
80103889:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010388c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010388f:	83 ec 0c             	sub    $0xc,%esp
80103892:	53                   	push   %ebx
80103893:	e8 48 12 00 00       	call   80104ae0 <acquire>
  if(writable){
80103898:	83 c4 10             	add    $0x10,%esp
8010389b:	85 f6                	test   %esi,%esi
8010389d:	74 41                	je     801038e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010389f:	83 ec 0c             	sub    $0xc,%esp
801038a2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801038a8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801038af:	00 00 00 
    wakeup(&p->nread);
801038b2:	50                   	push   %eax
801038b3:	e8 08 0c 00 00       	call   801044c0 <wakeup>
801038b8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801038bb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801038c1:	85 d2                	test   %edx,%edx
801038c3:	75 0a                	jne    801038cf <pipeclose+0x4f>
801038c5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801038cb:	85 c0                	test   %eax,%eax
801038cd:	74 31                	je     80103900 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801038cf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801038d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038d5:	5b                   	pop    %ebx
801038d6:	5e                   	pop    %esi
801038d7:	5d                   	pop    %ebp
    release(&p->lock);
801038d8:	e9 c3 12 00 00       	jmp    80104ba0 <release>
801038dd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801038e0:	83 ec 0c             	sub    $0xc,%esp
801038e3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801038e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801038f0:	00 00 00 
    wakeup(&p->nwrite);
801038f3:	50                   	push   %eax
801038f4:	e8 c7 0b 00 00       	call   801044c0 <wakeup>
801038f9:	83 c4 10             	add    $0x10,%esp
801038fc:	eb bd                	jmp    801038bb <pipeclose+0x3b>
801038fe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103900:	83 ec 0c             	sub    $0xc,%esp
80103903:	53                   	push   %ebx
80103904:	e8 97 12 00 00       	call   80104ba0 <release>
    kfree((char*)p);
80103909:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010390c:	83 c4 10             	add    $0x10,%esp
}
8010390f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103912:	5b                   	pop    %ebx
80103913:	5e                   	pop    %esi
80103914:	5d                   	pop    %ebp
    kfree((char*)p);
80103915:	e9 d6 ee ff ff       	jmp    801027f0 <kfree>
8010391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103920 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103920:	f3 0f 1e fb          	endbr32 
80103924:	55                   	push   %ebp
80103925:	89 e5                	mov    %esp,%ebp
80103927:	57                   	push   %edi
80103928:	56                   	push   %esi
80103929:	53                   	push   %ebx
8010392a:	83 ec 28             	sub    $0x28,%esp
8010392d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103930:	53                   	push   %ebx
80103931:	e8 aa 11 00 00       	call   80104ae0 <acquire>
  for(i = 0; i < n; i++){
80103936:	8b 45 10             	mov    0x10(%ebp),%eax
80103939:	83 c4 10             	add    $0x10,%esp
8010393c:	85 c0                	test   %eax,%eax
8010393e:	0f 8e bc 00 00 00    	jle    80103a00 <pipewrite+0xe0>
80103944:	8b 45 0c             	mov    0xc(%ebp),%eax
80103947:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010394d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103953:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103956:	03 45 10             	add    0x10(%ebp),%eax
80103959:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010395c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103962:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103968:	89 ca                	mov    %ecx,%edx
8010396a:	05 00 02 00 00       	add    $0x200,%eax
8010396f:	39 c1                	cmp    %eax,%ecx
80103971:	74 3b                	je     801039ae <pipewrite+0x8e>
80103973:	eb 63                	jmp    801039d8 <pipewrite+0xb8>
80103975:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103978:	e8 a3 03 00 00       	call   80103d20 <myproc>
8010397d:	8b 48 24             	mov    0x24(%eax),%ecx
80103980:	85 c9                	test   %ecx,%ecx
80103982:	75 34                	jne    801039b8 <pipewrite+0x98>
      wakeup(&p->nread);
80103984:	83 ec 0c             	sub    $0xc,%esp
80103987:	57                   	push   %edi
80103988:	e8 33 0b 00 00       	call   801044c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010398d:	58                   	pop    %eax
8010398e:	5a                   	pop    %edx
8010398f:	53                   	push   %ebx
80103990:	56                   	push   %esi
80103991:	e8 6a 09 00 00       	call   80104300 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103996:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010399c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801039a2:	83 c4 10             	add    $0x10,%esp
801039a5:	05 00 02 00 00       	add    $0x200,%eax
801039aa:	39 c2                	cmp    %eax,%edx
801039ac:	75 2a                	jne    801039d8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801039ae:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801039b4:	85 c0                	test   %eax,%eax
801039b6:	75 c0                	jne    80103978 <pipewrite+0x58>
        release(&p->lock);
801039b8:	83 ec 0c             	sub    $0xc,%esp
801039bb:	53                   	push   %ebx
801039bc:	e8 df 11 00 00       	call   80104ba0 <release>
        return -1;
801039c1:	83 c4 10             	add    $0x10,%esp
801039c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801039c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039cc:	5b                   	pop    %ebx
801039cd:	5e                   	pop    %esi
801039ce:	5f                   	pop    %edi
801039cf:	5d                   	pop    %ebp
801039d0:	c3                   	ret    
801039d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039d8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801039db:	8d 4a 01             	lea    0x1(%edx),%ecx
801039de:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801039e4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801039ea:	0f b6 06             	movzbl (%esi),%eax
801039ed:	83 c6 01             	add    $0x1,%esi
801039f0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801039f3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801039f7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801039fa:	0f 85 5c ff ff ff    	jne    8010395c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103a00:	83 ec 0c             	sub    $0xc,%esp
80103a03:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103a09:	50                   	push   %eax
80103a0a:	e8 b1 0a 00 00       	call   801044c0 <wakeup>
  release(&p->lock);
80103a0f:	89 1c 24             	mov    %ebx,(%esp)
80103a12:	e8 89 11 00 00       	call   80104ba0 <release>
  return n;
80103a17:	8b 45 10             	mov    0x10(%ebp),%eax
80103a1a:	83 c4 10             	add    $0x10,%esp
80103a1d:	eb aa                	jmp    801039c9 <pipewrite+0xa9>
80103a1f:	90                   	nop

80103a20 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a20:	f3 0f 1e fb          	endbr32 
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	57                   	push   %edi
80103a28:	56                   	push   %esi
80103a29:	53                   	push   %ebx
80103a2a:	83 ec 18             	sub    $0x18,%esp
80103a2d:	8b 75 08             	mov    0x8(%ebp),%esi
80103a30:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a33:	56                   	push   %esi
80103a34:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a3a:	e8 a1 10 00 00       	call   80104ae0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a3f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103a4e:	74 33                	je     80103a83 <piperead+0x63>
80103a50:	eb 3b                	jmp    80103a8d <piperead+0x6d>
80103a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103a58:	e8 c3 02 00 00       	call   80103d20 <myproc>
80103a5d:	8b 48 24             	mov    0x24(%eax),%ecx
80103a60:	85 c9                	test   %ecx,%ecx
80103a62:	0f 85 88 00 00 00    	jne    80103af0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a68:	83 ec 08             	sub    $0x8,%esp
80103a6b:	56                   	push   %esi
80103a6c:	53                   	push   %ebx
80103a6d:	e8 8e 08 00 00       	call   80104300 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a72:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103a78:	83 c4 10             	add    $0x10,%esp
80103a7b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103a81:	75 0a                	jne    80103a8d <piperead+0x6d>
80103a83:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103a89:	85 c0                	test   %eax,%eax
80103a8b:	75 cb                	jne    80103a58 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a8d:	8b 55 10             	mov    0x10(%ebp),%edx
80103a90:	31 db                	xor    %ebx,%ebx
80103a92:	85 d2                	test   %edx,%edx
80103a94:	7f 28                	jg     80103abe <piperead+0x9e>
80103a96:	eb 34                	jmp    80103acc <piperead+0xac>
80103a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a9f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103aa0:	8d 48 01             	lea    0x1(%eax),%ecx
80103aa3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103aa8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103aae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103ab3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ab6:	83 c3 01             	add    $0x1,%ebx
80103ab9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103abc:	74 0e                	je     80103acc <piperead+0xac>
    if(p->nread == p->nwrite)
80103abe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ac4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103aca:	75 d4                	jne    80103aa0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103acc:	83 ec 0c             	sub    $0xc,%esp
80103acf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103ad5:	50                   	push   %eax
80103ad6:	e8 e5 09 00 00       	call   801044c0 <wakeup>
  release(&p->lock);
80103adb:	89 34 24             	mov    %esi,(%esp)
80103ade:	e8 bd 10 00 00       	call   80104ba0 <release>
  return i;
80103ae3:	83 c4 10             	add    $0x10,%esp
}
80103ae6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ae9:	89 d8                	mov    %ebx,%eax
80103aeb:	5b                   	pop    %ebx
80103aec:	5e                   	pop    %esi
80103aed:	5f                   	pop    %edi
80103aee:	5d                   	pop    %ebp
80103aef:	c3                   	ret    
      release(&p->lock);
80103af0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103af3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103af8:	56                   	push   %esi
80103af9:	e8 a2 10 00 00       	call   80104ba0 <release>
      return -1;
80103afe:	83 c4 10             	add    $0x10,%esp
}
80103b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b04:	89 d8                	mov    %ebx,%eax
80103b06:	5b                   	pop    %ebx
80103b07:	5e                   	pop    %esi
80103b08:	5f                   	pop    %edi
80103b09:	5d                   	pop    %ebp
80103b0a:	c3                   	ret    
80103b0b:	66 90                	xchg   %ax,%ax
80103b0d:	66 90                	xchg   %ax,%ax
80103b0f:	90                   	nop

80103b10 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	53                   	push   %ebx
  
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b14:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
80103b19:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103b1c:	68 20 3d 11 80       	push   $0x80113d20
80103b21:	e8 ba 0f 00 00       	call   80104ae0 <acquire>
80103b26:	83 c4 10             	add    $0x10,%esp
80103b29:	eb 17                	jmp    80103b42 <allocproc+0x32>
80103b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b30:	81 c3 d8 03 00 00    	add    $0x3d8,%ebx
80103b36:	81 fb 54 33 12 80    	cmp    $0x80123354,%ebx
80103b3c:	0f 84 ae 00 00 00    	je     80103bf0 <allocproc+0xe0>
    if(p->state == UNUSED)
80103b42:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b45:	85 c0                	test   %eax,%eax
80103b47:	75 e7                	jne    80103b30 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b49:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103b4e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b51:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103b58:	89 43 10             	mov    %eax,0x10(%ebx)
80103b5b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103b5e:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
80103b63:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103b69:	e8 32 10 00 00       	call   80104ba0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b6e:	e8 3d ee ff ff       	call   801029b0 <kalloc>
80103b73:	83 c4 10             	add    $0x10,%esp
80103b76:	89 43 08             	mov    %eax,0x8(%ebx)
80103b79:	85 c0                	test   %eax,%eax
80103b7b:	0f 84 88 00 00 00    	je     80103c09 <allocproc+0xf9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b81:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b87:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b8a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b8f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103b92:	c7 40 14 26 5e 10 80 	movl   $0x80105e26,0x14(%eax)
  p->context = (struct context*)sp;
80103b99:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b9c:	6a 14                	push   $0x14
80103b9e:	6a 00                	push   $0x0
80103ba0:	50                   	push   %eax
80103ba1:	e8 4a 10 00 00       	call   80104bf0 <memset>
  p->context->eip = (uint)forkret;
80103ba6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103ba9:	8d 93 fc 00 00 00    	lea    0xfc(%ebx),%edx
80103baf:	83 c4 10             	add    $0x10,%esp
80103bb2:	c7 40 10 20 3c 10 80 	movl   $0x80103c20,0x10(%eax)
  p->page_number = 0;//changed 
80103bb9:	8d 83 84 00 00 00    	lea    0x84(%ebx),%eax
80103bbf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103bc6:	00 00 00 
  for(int i = 0; i < MAX_TOTAL_PAGES; i++) {
80103bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      p->list_arr[i]=0;
80103bd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i = 0; i < MAX_TOTAL_PAGES; i++) {
80103bd6:	83 c0 04             	add    $0x4,%eax
80103bd9:	39 c2                	cmp    %eax,%edx
80103bdb:	75 f3                	jne    80103bd0 <allocproc+0xc0>
  }
  p->offset_swapfile=0;
80103bdd:	c7 83 e4 02 00 00 00 	movl   $0x0,0x2e4(%ebx)
80103be4:	00 00 00 

  return p;
}
80103be7:	89 d8                	mov    %ebx,%eax
80103be9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bec:	c9                   	leave  
80103bed:	c3                   	ret    
80103bee:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103bf0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103bf3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103bf5:	68 20 3d 11 80       	push   $0x80113d20
80103bfa:	e8 a1 0f 00 00       	call   80104ba0 <release>
}
80103bff:	89 d8                	mov    %ebx,%eax
  return 0;
80103c01:	83 c4 10             	add    $0x10,%esp
}
80103c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c07:	c9                   	leave  
80103c08:	c3                   	ret    
    p->state = UNUSED;
80103c09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103c10:	31 db                	xor    %ebx,%ebx
}
80103c12:	89 d8                	mov    %ebx,%eax
80103c14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c17:	c9                   	leave  
80103c18:	c3                   	ret    
80103c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103c20:	f3 0f 1e fb          	endbr32 
80103c24:	55                   	push   %ebp
80103c25:	89 e5                	mov    %esp,%ebp
80103c27:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103c2a:	68 20 3d 11 80       	push   $0x80113d20
80103c2f:	e8 6c 0f 00 00       	call   80104ba0 <release>

  if (first) {
80103c34:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103c39:	83 c4 10             	add    $0x10,%esp
80103c3c:	85 c0                	test   %eax,%eax
80103c3e:	75 08                	jne    80103c48 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103c40:	c9                   	leave  
80103c41:	c3                   	ret    
80103c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103c48:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103c4f:	00 00 00 
    iinit(ROOTDEV);
80103c52:	83 ec 0c             	sub    $0xc,%esp
80103c55:	6a 01                	push   $0x1
80103c57:	e8 e4 d8 ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
80103c5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c63:	e8 a8 f3 ff ff       	call   80103010 <initlog>
}
80103c68:	83 c4 10             	add    $0x10,%esp
80103c6b:	c9                   	leave  
80103c6c:	c3                   	ret    
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi

80103c70 <pinit>:
{
80103c70:	f3 0f 1e fb          	endbr32 
80103c74:	55                   	push   %ebp
80103c75:	89 e5                	mov    %esp,%ebp
80103c77:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c7a:	68 20 83 10 80       	push   $0x80108320
80103c7f:	68 20 3d 11 80       	push   $0x80113d20
80103c84:	e8 d7 0c 00 00       	call   80104960 <initlock>
}
80103c89:	83 c4 10             	add    $0x10,%esp
80103c8c:	c9                   	leave  
80103c8d:	c3                   	ret    
80103c8e:	66 90                	xchg   %ax,%ax

80103c90 <mycpu>:
{
80103c90:	f3 0f 1e fb          	endbr32 
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	56                   	push   %esi
80103c98:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c99:	9c                   	pushf  
80103c9a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c9b:	f6 c4 02             	test   $0x2,%ah
80103c9e:	75 4a                	jne    80103cea <mycpu+0x5a>
  apicid = lapicid();
80103ca0:	e8 7b ef ff ff       	call   80102c20 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ca5:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
80103cab:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103cad:	85 f6                	test   %esi,%esi
80103caf:	7e 2c                	jle    80103cdd <mycpu+0x4d>
80103cb1:	31 d2                	xor    %edx,%edx
80103cb3:	eb 0a                	jmp    80103cbf <mycpu+0x2f>
80103cb5:	8d 76 00             	lea    0x0(%esi),%esi
80103cb8:	83 c2 01             	add    $0x1,%edx
80103cbb:	39 f2                	cmp    %esi,%edx
80103cbd:	74 1e                	je     80103cdd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103cbf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103cc5:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
80103ccc:	39 d8                	cmp    %ebx,%eax
80103cce:	75 e8                	jne    80103cb8 <mycpu+0x28>
}
80103cd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103cd3:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
80103cd9:	5b                   	pop    %ebx
80103cda:	5e                   	pop    %esi
80103cdb:	5d                   	pop    %ebp
80103cdc:	c3                   	ret    
  panic("unknown apicid\n");
80103cdd:	83 ec 0c             	sub    $0xc,%esp
80103ce0:	68 27 83 10 80       	push   $0x80108327
80103ce5:	e8 a6 c6 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103cea:	83 ec 0c             	sub    $0xc,%esp
80103ced:	68 68 84 10 80       	push   $0x80108468
80103cf2:	e8 99 c6 ff ff       	call   80100390 <panic>
80103cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cfe:	66 90                	xchg   %ax,%ax

80103d00 <cpuid>:
cpuid() {
80103d00:	f3 0f 1e fb          	endbr32 
80103d04:	55                   	push   %ebp
80103d05:	89 e5                	mov    %esp,%ebp
80103d07:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103d0a:	e8 81 ff ff ff       	call   80103c90 <mycpu>
}
80103d0f:	c9                   	leave  
  return mycpu()-cpus;
80103d10:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103d15:	c1 f8 04             	sar    $0x4,%eax
80103d18:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103d1e:	c3                   	ret    
80103d1f:	90                   	nop

80103d20 <myproc>:
myproc(void) {
80103d20:	f3 0f 1e fb          	endbr32 
80103d24:	55                   	push   %ebp
80103d25:	89 e5                	mov    %esp,%ebp
80103d27:	53                   	push   %ebx
80103d28:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103d2b:	e8 b0 0c 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80103d30:	e8 5b ff ff ff       	call   80103c90 <mycpu>
  p = c->proc;
80103d35:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d3b:	e8 f0 0c 00 00       	call   80104a30 <popcli>
}
80103d40:	83 c4 04             	add    $0x4,%esp
80103d43:	89 d8                	mov    %ebx,%eax
80103d45:	5b                   	pop    %ebx
80103d46:	5d                   	pop    %ebp
80103d47:	c3                   	ret    
80103d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4f:	90                   	nop

80103d50 <userinit>:
{
80103d50:	f3 0f 1e fb          	endbr32 
80103d54:	55                   	push   %ebp
80103d55:	89 e5                	mov    %esp,%ebp
80103d57:	53                   	push   %ebx
80103d58:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103d5b:	e8 b0 fd ff ff       	call   80103b10 <allocproc>
80103d60:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103d62:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103d67:	e8 74 3b 00 00       	call   801078e0 <setupkvm>
80103d6c:	89 43 04             	mov    %eax,0x4(%ebx)
80103d6f:	85 c0                	test   %eax,%eax
80103d71:	0f 84 bd 00 00 00    	je     80103e34 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d77:	83 ec 04             	sub    $0x4,%esp
80103d7a:	68 2c 00 00 00       	push   $0x2c
80103d7f:	68 60 b4 10 80       	push   $0x8010b460
80103d84:	50                   	push   %eax
80103d85:	e8 c6 33 00 00       	call   80107150 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d8a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d8d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d93:	6a 4c                	push   $0x4c
80103d95:	6a 00                	push   $0x0
80103d97:	ff 73 18             	pushl  0x18(%ebx)
80103d9a:	e8 51 0e 00 00       	call   80104bf0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d9f:	8b 43 18             	mov    0x18(%ebx),%eax
80103da2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103da7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103daa:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103daf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103db3:	8b 43 18             	mov    0x18(%ebx),%eax
80103db6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103dba:	8b 43 18             	mov    0x18(%ebx),%eax
80103dbd:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dc1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103dc5:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dcc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103dd0:	8b 43 18             	mov    0x18(%ebx),%eax
80103dd3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103dda:	8b 43 18             	mov    0x18(%ebx),%eax
80103ddd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103de4:	8b 43 18             	mov    0x18(%ebx),%eax
80103de7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103dee:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103df1:	6a 10                	push   $0x10
80103df3:	68 50 83 10 80       	push   $0x80108350
80103df8:	50                   	push   %eax
80103df9:	e8 b2 0f 00 00       	call   80104db0 <safestrcpy>
  p->cwd = namei("/");
80103dfe:	c7 04 24 59 83 10 80 	movl   $0x80108359,(%esp)
80103e05:	e8 26 e2 ff ff       	call   80102030 <namei>
80103e0a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103e0d:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e14:	e8 c7 0c 00 00       	call   80104ae0 <acquire>
  p->state = RUNNABLE;
80103e19:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103e20:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e27:	e8 74 0d 00 00       	call   80104ba0 <release>
}
80103e2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e2f:	83 c4 10             	add    $0x10,%esp
80103e32:	c9                   	leave  
80103e33:	c3                   	ret    
    panic("userinit: out of memory?");
80103e34:	83 ec 0c             	sub    $0xc,%esp
80103e37:	68 37 83 10 80       	push   $0x80108337
80103e3c:	e8 4f c5 ff ff       	call   80100390 <panic>
80103e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4f:	90                   	nop

80103e50 <growproc>:
{
80103e50:	f3 0f 1e fb          	endbr32 
80103e54:	55                   	push   %ebp
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	56                   	push   %esi
80103e58:	53                   	push   %ebx
80103e59:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e5c:	e8 7f 0b 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80103e61:	e8 2a fe ff ff       	call   80103c90 <mycpu>
  p = c->proc;
80103e66:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e6c:	e8 bf 0b 00 00       	call   80104a30 <popcli>
  sz = curproc->sz;
80103e71:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103e73:	85 f6                	test   %esi,%esi
80103e75:	7f 19                	jg     80103e90 <growproc+0x40>
  } else if(n < 0){
80103e77:	75 37                	jne    80103eb0 <growproc+0x60>
  switchuvm(curproc);
80103e79:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103e7c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103e7e:	53                   	push   %ebx
80103e7f:	e8 bc 31 00 00       	call   80107040 <switchuvm>
  return 0;
80103e84:	83 c4 10             	add    $0x10,%esp
80103e87:	31 c0                	xor    %eax,%eax
}
80103e89:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e8c:	5b                   	pop    %ebx
80103e8d:	5e                   	pop    %esi
80103e8e:	5d                   	pop    %ebp
80103e8f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e90:	83 ec 04             	sub    $0x4,%esp
80103e93:	01 c6                	add    %eax,%esi
80103e95:	56                   	push   %esi
80103e96:	50                   	push   %eax
80103e97:	ff 73 04             	pushl  0x4(%ebx)
80103e9a:	e8 21 36 00 00       	call   801074c0 <allocuvm>
80103e9f:	83 c4 10             	add    $0x10,%esp
80103ea2:	85 c0                	test   %eax,%eax
80103ea4:	75 d3                	jne    80103e79 <growproc+0x29>
      return -1;
80103ea6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103eab:	eb dc                	jmp    80103e89 <growproc+0x39>
80103ead:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103eb0:	83 ec 04             	sub    $0x4,%esp
80103eb3:	01 c6                	add    %eax,%esi
80103eb5:	56                   	push   %esi
80103eb6:	50                   	push   %eax
80103eb7:	ff 73 04             	pushl  0x4(%ebx)
80103eba:	e8 f1 34 00 00       	call   801073b0 <deallocuvm>
80103ebf:	83 c4 10             	add    $0x10,%esp
80103ec2:	85 c0                	test   %eax,%eax
80103ec4:	75 b3                	jne    80103e79 <growproc+0x29>
80103ec6:	eb de                	jmp    80103ea6 <growproc+0x56>
80103ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ecf:	90                   	nop

80103ed0 <fork>:
{
80103ed0:	f3 0f 1e fb          	endbr32 
80103ed4:	55                   	push   %ebp
80103ed5:	89 e5                	mov    %esp,%ebp
80103ed7:	57                   	push   %edi
80103ed8:	56                   	push   %esi
80103ed9:	53                   	push   %ebx
80103eda:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103edd:	e8 fe 0a 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80103ee2:	e8 a9 fd ff ff       	call   80103c90 <mycpu>
  p = c->proc;
80103ee7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103eed:	e8 3e 0b 00 00       	call   80104a30 <popcli>
  if((np = allocproc()) == 0){
80103ef2:	e8 19 fc ff ff       	call   80103b10 <allocproc>
80103ef7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103efa:	85 c0                	test   %eax,%eax
80103efc:	0f 84 dc 00 00 00    	je     80103fde <fork+0x10e>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103f02:	83 ec 08             	sub    $0x8,%esp
80103f05:	ff 33                	pushl  (%ebx)
80103f07:	89 c7                	mov    %eax,%edi
80103f09:	ff 73 04             	pushl  0x4(%ebx)
80103f0c:	e8 ff 3a 00 00       	call   80107a10 <copyuvm>
80103f11:	83 c4 10             	add    $0x10,%esp
80103f14:	89 47 04             	mov    %eax,0x4(%edi)
80103f17:	85 c0                	test   %eax,%eax
80103f19:	0f 84 c6 00 00 00    	je     80103fe5 <fork+0x115>
  np->sz = curproc->sz;
80103f1f:	8b 03                	mov    (%ebx),%eax
80103f21:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f24:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103f26:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103f29:	89 c8                	mov    %ecx,%eax
80103f2b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103f2e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103f33:	8b 73 18             	mov    0x18(%ebx),%esi
80103f36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103f38:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103f3a:	8b 40 18             	mov    0x18(%eax),%eax
80103f3d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103f48:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f4c:	85 c0                	test   %eax,%eax
80103f4e:	74 13                	je     80103f63 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f50:	83 ec 0c             	sub    $0xc,%esp
80103f53:	50                   	push   %eax
80103f54:	e8 17 cf ff ff       	call   80100e70 <filedup>
80103f59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f5c:	83 c4 10             	add    $0x10,%esp
80103f5f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103f63:	83 c6 01             	add    $0x1,%esi
80103f66:	83 fe 10             	cmp    $0x10,%esi
80103f69:	75 dd                	jne    80103f48 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103f6b:	83 ec 0c             	sub    $0xc,%esp
80103f6e:	ff 73 68             	pushl  0x68(%ebx)
80103f71:	e8 ba d7 ff ff       	call   80101730 <idup>
80103f76:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  if(np->pid){
80103f79:	83 c4 10             	add    $0x10,%esp
  np->cwd = idup(curproc->cwd);
80103f7c:	89 41 68             	mov    %eax,0x68(%ecx)
  if(np->pid){
80103f7f:	8b 41 10             	mov    0x10(%ecx),%eax
80103f82:	85 c0                	test   %eax,%eax
80103f84:	75 4a                	jne    80103fd0 <fork+0x100>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f86:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103f89:	83 ec 04             	sub    $0x4,%esp
80103f8c:	83 c3 6c             	add    $0x6c,%ebx
80103f8f:	6a 10                	push   $0x10
80103f91:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f94:	53                   	push   %ebx
80103f95:	50                   	push   %eax
80103f96:	e8 15 0e 00 00       	call   80104db0 <safestrcpy>
  pid = np->pid;
80103f9b:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f9e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103fa5:	e8 36 0b 00 00       	call   80104ae0 <acquire>
  np->state = RUNNABLE;
80103faa:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103fb1:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103fb8:	e8 e3 0b 00 00       	call   80104ba0 <release>
  return pid;
80103fbd:	83 c4 10             	add    $0x10,%esp
}
80103fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fc3:	89 d8                	mov    %ebx,%eax
80103fc5:	5b                   	pop    %ebx
80103fc6:	5e                   	pop    %esi
80103fc7:	5f                   	pop    %edi
80103fc8:	5d                   	pop    %ebp
80103fc9:	c3                   	ret    
80103fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      createSwapFile(np);
80103fd0:	83 ec 0c             	sub    $0xc,%esp
80103fd3:	51                   	push   %ecx
80103fd4:	e8 17 e3 ff ff       	call   801022f0 <createSwapFile>
80103fd9:	83 c4 10             	add    $0x10,%esp
80103fdc:	eb a8                	jmp    80103f86 <fork+0xb6>
    return -1;
80103fde:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fe3:	eb db                	jmp    80103fc0 <fork+0xf0>
    kfree(np->kstack);
80103fe5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103fe8:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103feb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103ff0:	ff 77 08             	pushl  0x8(%edi)
80103ff3:	e8 f8 e7 ff ff       	call   801027f0 <kfree>
    np->kstack = 0;
80103ff8:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -1;
80103fff:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104002:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80104009:	eb b5                	jmp    80103fc0 <fork+0xf0>
8010400b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010400f:	90                   	nop

80104010 <scheduler>:
{
80104010:	f3 0f 1e fb          	endbr32 
80104014:	55                   	push   %ebp
80104015:	89 e5                	mov    %esp,%ebp
80104017:	57                   	push   %edi
80104018:	56                   	push   %esi
80104019:	53                   	push   %ebx
8010401a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010401d:	e8 6e fc ff ff       	call   80103c90 <mycpu>
  c->proc = 0;
80104022:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104029:	00 00 00 
  struct cpu *c = mycpu();
8010402c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010402e:	8d 78 04             	lea    0x4(%eax),%edi
80104031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104038:	fb                   	sti    
    acquire(&ptable.lock);
80104039:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010403c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    acquire(&ptable.lock);
80104041:	68 20 3d 11 80       	push   $0x80113d20
80104046:	e8 95 0a 00 00       	call   80104ae0 <acquire>
8010404b:	83 c4 10             	add    $0x10,%esp
8010404e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104050:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104054:	75 33                	jne    80104089 <scheduler+0x79>
      switchuvm(p);
80104056:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104059:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010405f:	53                   	push   %ebx
80104060:	e8 db 2f 00 00       	call   80107040 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104065:	58                   	pop    %eax
80104066:	5a                   	pop    %edx
80104067:	ff 73 1c             	pushl  0x1c(%ebx)
8010406a:	57                   	push   %edi
      p->state = RUNNING;
8010406b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104072:	e8 9c 0d 00 00       	call   80104e13 <swtch>
      switchkvm();
80104077:	e8 a4 2f 00 00       	call   80107020 <switchkvm>
      c->proc = 0;
8010407c:	83 c4 10             	add    $0x10,%esp
8010407f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104086:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104089:	81 c3 d8 03 00 00    	add    $0x3d8,%ebx
8010408f:	81 fb 54 33 12 80    	cmp    $0x80123354,%ebx
80104095:	75 b9                	jne    80104050 <scheduler+0x40>
    release(&ptable.lock);
80104097:	83 ec 0c             	sub    $0xc,%esp
8010409a:	68 20 3d 11 80       	push   $0x80113d20
8010409f:	e8 fc 0a 00 00       	call   80104ba0 <release>
    sti();
801040a4:	83 c4 10             	add    $0x10,%esp
801040a7:	eb 8f                	jmp    80104038 <scheduler+0x28>
801040a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040b0 <sched>:
{
801040b0:	f3 0f 1e fb          	endbr32 
801040b4:	55                   	push   %ebp
801040b5:	89 e5                	mov    %esp,%ebp
801040b7:	56                   	push   %esi
801040b8:	53                   	push   %ebx
  pushcli();
801040b9:	e8 22 09 00 00       	call   801049e0 <pushcli>
  c = mycpu();
801040be:	e8 cd fb ff ff       	call   80103c90 <mycpu>
  p = c->proc;
801040c3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040c9:	e8 62 09 00 00       	call   80104a30 <popcli>
  if(!holding(&ptable.lock))
801040ce:	83 ec 0c             	sub    $0xc,%esp
801040d1:	68 20 3d 11 80       	push   $0x80113d20
801040d6:	e8 b5 09 00 00       	call   80104a90 <holding>
801040db:	83 c4 10             	add    $0x10,%esp
801040de:	85 c0                	test   %eax,%eax
801040e0:	74 4f                	je     80104131 <sched+0x81>
  if(mycpu()->ncli != 1)
801040e2:	e8 a9 fb ff ff       	call   80103c90 <mycpu>
801040e7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801040ee:	75 68                	jne    80104158 <sched+0xa8>
  if(p->state == RUNNING)
801040f0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801040f4:	74 55                	je     8010414b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040f6:	9c                   	pushf  
801040f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040f8:	f6 c4 02             	test   $0x2,%ah
801040fb:	75 41                	jne    8010413e <sched+0x8e>
  intena = mycpu()->intena;
801040fd:	e8 8e fb ff ff       	call   80103c90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104102:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104105:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010410b:	e8 80 fb ff ff       	call   80103c90 <mycpu>
80104110:	83 ec 08             	sub    $0x8,%esp
80104113:	ff 70 04             	pushl  0x4(%eax)
80104116:	53                   	push   %ebx
80104117:	e8 f7 0c 00 00       	call   80104e13 <swtch>
  mycpu()->intena = intena;
8010411c:	e8 6f fb ff ff       	call   80103c90 <mycpu>
}
80104121:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104124:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010412a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010412d:	5b                   	pop    %ebx
8010412e:	5e                   	pop    %esi
8010412f:	5d                   	pop    %ebp
80104130:	c3                   	ret    
    panic("sched ptable.lock");
80104131:	83 ec 0c             	sub    $0xc,%esp
80104134:	68 5b 83 10 80       	push   $0x8010835b
80104139:	e8 52 c2 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010413e:	83 ec 0c             	sub    $0xc,%esp
80104141:	68 87 83 10 80       	push   $0x80108387
80104146:	e8 45 c2 ff ff       	call   80100390 <panic>
    panic("sched running");
8010414b:	83 ec 0c             	sub    $0xc,%esp
8010414e:	68 79 83 10 80       	push   $0x80108379
80104153:	e8 38 c2 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104158:	83 ec 0c             	sub    $0xc,%esp
8010415b:	68 6d 83 10 80       	push   $0x8010836d
80104160:	e8 2b c2 ff ff       	call   80100390 <panic>
80104165:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104170 <exit>:
{
80104170:	f3 0f 1e fb          	endbr32 
80104174:	55                   	push   %ebp
80104175:	89 e5                	mov    %esp,%ebp
80104177:	57                   	push   %edi
80104178:	56                   	push   %esi
80104179:	53                   	push   %ebx
8010417a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010417d:	e8 5e 08 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80104182:	e8 09 fb ff ff       	call   80103c90 <mycpu>
  p = c->proc;
80104187:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010418d:	e8 9e 08 00 00       	call   80104a30 <popcli>
  if(curproc == initproc)
80104192:	8d 5e 28             	lea    0x28(%esi),%ebx
80104195:	8d 7e 68             	lea    0x68(%esi),%edi
80104198:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010419e:	0f 84 fd 00 00 00    	je     801042a1 <exit+0x131>
801041a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801041a8:	8b 03                	mov    (%ebx),%eax
801041aa:	85 c0                	test   %eax,%eax
801041ac:	74 12                	je     801041c0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801041ae:	83 ec 0c             	sub    $0xc,%esp
801041b1:	50                   	push   %eax
801041b2:	e8 09 cd ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
801041b7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801041bd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801041c0:	83 c3 04             	add    $0x4,%ebx
801041c3:	39 df                	cmp    %ebx,%edi
801041c5:	75 e1                	jne    801041a8 <exit+0x38>
  begin_op();
801041c7:	e8 e4 ee ff ff       	call   801030b0 <begin_op>
  iput(curproc->cwd);
801041cc:	83 ec 0c             	sub    $0xc,%esp
801041cf:	ff 76 68             	pushl  0x68(%esi)
801041d2:	e8 b9 d6 ff ff       	call   80101890 <iput>
  end_op();
801041d7:	e8 44 ef ff ff       	call   80103120 <end_op>
  curproc->cwd = 0;
801041dc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801041e3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801041ea:	e8 f1 08 00 00       	call   80104ae0 <acquire>
  wakeup1(curproc->parent);
801041ef:	8b 56 14             	mov    0x14(%esi),%edx
801041f2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041f5:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801041fa:	eb 10                	jmp    8010420c <exit+0x9c>
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104200:	05 d8 03 00 00       	add    $0x3d8,%eax
80104205:	3d 54 33 12 80       	cmp    $0x80123354,%eax
8010420a:	74 1e                	je     8010422a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010420c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104210:	75 ee                	jne    80104200 <exit+0x90>
80104212:	3b 50 20             	cmp    0x20(%eax),%edx
80104215:	75 e9                	jne    80104200 <exit+0x90>
      p->state = RUNNABLE;
80104217:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010421e:	05 d8 03 00 00       	add    $0x3d8,%eax
80104223:	3d 54 33 12 80       	cmp    $0x80123354,%eax
80104228:	75 e2                	jne    8010420c <exit+0x9c>
      p->parent = initproc;
8010422a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104230:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80104235:	eb 17                	jmp    8010424e <exit+0xde>
80104237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010423e:	66 90                	xchg   %ax,%ax
80104240:	81 c2 d8 03 00 00    	add    $0x3d8,%edx
80104246:	81 fa 54 33 12 80    	cmp    $0x80123354,%edx
8010424c:	74 3a                	je     80104288 <exit+0x118>
    if(p->parent == curproc){
8010424e:	39 72 14             	cmp    %esi,0x14(%edx)
80104251:	75 ed                	jne    80104240 <exit+0xd0>
      if(p->state == ZOMBIE)
80104253:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104257:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010425a:	75 e4                	jne    80104240 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010425c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104261:	eb 11                	jmp    80104274 <exit+0x104>
80104263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104267:	90                   	nop
80104268:	05 d8 03 00 00       	add    $0x3d8,%eax
8010426d:	3d 54 33 12 80       	cmp    $0x80123354,%eax
80104272:	74 cc                	je     80104240 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104274:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104278:	75 ee                	jne    80104268 <exit+0xf8>
8010427a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010427d:	75 e9                	jne    80104268 <exit+0xf8>
      p->state = RUNNABLE;
8010427f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104286:	eb e0                	jmp    80104268 <exit+0xf8>
  curproc->state = ZOMBIE;
80104288:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010428f:	e8 1c fe ff ff       	call   801040b0 <sched>
  panic("zombie exit");
80104294:	83 ec 0c             	sub    $0xc,%esp
80104297:	68 a8 83 10 80       	push   $0x801083a8
8010429c:	e8 ef c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
801042a1:	83 ec 0c             	sub    $0xc,%esp
801042a4:	68 9b 83 10 80       	push   $0x8010839b
801042a9:	e8 e2 c0 ff ff       	call   80100390 <panic>
801042ae:	66 90                	xchg   %ax,%ax

801042b0 <yield>:
{
801042b0:	f3 0f 1e fb          	endbr32 
801042b4:	55                   	push   %ebp
801042b5:	89 e5                	mov    %esp,%ebp
801042b7:	53                   	push   %ebx
801042b8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042bb:	68 20 3d 11 80       	push   $0x80113d20
801042c0:	e8 1b 08 00 00       	call   80104ae0 <acquire>
  pushcli();
801042c5:	e8 16 07 00 00       	call   801049e0 <pushcli>
  c = mycpu();
801042ca:	e8 c1 f9 ff ff       	call   80103c90 <mycpu>
  p = c->proc;
801042cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d5:	e8 56 07 00 00       	call   80104a30 <popcli>
  myproc()->state = RUNNABLE;
801042da:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801042e1:	e8 ca fd ff ff       	call   801040b0 <sched>
  release(&ptable.lock);
801042e6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801042ed:	e8 ae 08 00 00       	call   80104ba0 <release>
}
801042f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f5:	83 c4 10             	add    $0x10,%esp
801042f8:	c9                   	leave  
801042f9:	c3                   	ret    
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104300 <sleep>:
{
80104300:	f3 0f 1e fb          	endbr32 
80104304:	55                   	push   %ebp
80104305:	89 e5                	mov    %esp,%ebp
80104307:	57                   	push   %edi
80104308:	56                   	push   %esi
80104309:	53                   	push   %ebx
8010430a:	83 ec 0c             	sub    $0xc,%esp
8010430d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104310:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104313:	e8 c8 06 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80104318:	e8 73 f9 ff ff       	call   80103c90 <mycpu>
  p = c->proc;
8010431d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104323:	e8 08 07 00 00       	call   80104a30 <popcli>
  if(p == 0)
80104328:	85 db                	test   %ebx,%ebx
8010432a:	0f 84 83 00 00 00    	je     801043b3 <sleep+0xb3>
  if(lk == 0)
80104330:	85 f6                	test   %esi,%esi
80104332:	74 72                	je     801043a6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104334:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
8010433a:	74 4c                	je     80104388 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010433c:	83 ec 0c             	sub    $0xc,%esp
8010433f:	68 20 3d 11 80       	push   $0x80113d20
80104344:	e8 97 07 00 00       	call   80104ae0 <acquire>
    release(lk);
80104349:	89 34 24             	mov    %esi,(%esp)
8010434c:	e8 4f 08 00 00       	call   80104ba0 <release>
  p->chan = chan;
80104351:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104354:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010435b:	e8 50 fd ff ff       	call   801040b0 <sched>
  p->chan = 0;
80104360:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104367:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010436e:	e8 2d 08 00 00       	call   80104ba0 <release>
    acquire(lk);
80104373:	89 75 08             	mov    %esi,0x8(%ebp)
80104376:	83 c4 10             	add    $0x10,%esp
}
80104379:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010437c:	5b                   	pop    %ebx
8010437d:	5e                   	pop    %esi
8010437e:	5f                   	pop    %edi
8010437f:	5d                   	pop    %ebp
    acquire(lk);
80104380:	e9 5b 07 00 00       	jmp    80104ae0 <acquire>
80104385:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104388:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010438b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104392:	e8 19 fd ff ff       	call   801040b0 <sched>
  p->chan = 0;
80104397:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010439e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043a1:	5b                   	pop    %ebx
801043a2:	5e                   	pop    %esi
801043a3:	5f                   	pop    %edi
801043a4:	5d                   	pop    %ebp
801043a5:	c3                   	ret    
    panic("sleep without lk");
801043a6:	83 ec 0c             	sub    $0xc,%esp
801043a9:	68 ba 83 10 80       	push   $0x801083ba
801043ae:	e8 dd bf ff ff       	call   80100390 <panic>
    panic("sleep");
801043b3:	83 ec 0c             	sub    $0xc,%esp
801043b6:	68 b4 83 10 80       	push   $0x801083b4
801043bb:	e8 d0 bf ff ff       	call   80100390 <panic>

801043c0 <wait>:
{
801043c0:	f3 0f 1e fb          	endbr32 
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	56                   	push   %esi
801043c8:	53                   	push   %ebx
  pushcli();
801043c9:	e8 12 06 00 00       	call   801049e0 <pushcli>
  c = mycpu();
801043ce:	e8 bd f8 ff ff       	call   80103c90 <mycpu>
  p = c->proc;
801043d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801043d9:	e8 52 06 00 00       	call   80104a30 <popcli>
  acquire(&ptable.lock);
801043de:	83 ec 0c             	sub    $0xc,%esp
801043e1:	68 20 3d 11 80       	push   $0x80113d20
801043e6:	e8 f5 06 00 00       	call   80104ae0 <acquire>
801043eb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801043ee:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043f0:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801043f5:	eb 17                	jmp    8010440e <wait+0x4e>
801043f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043fe:	66 90                	xchg   %ax,%ax
80104400:	81 c3 d8 03 00 00    	add    $0x3d8,%ebx
80104406:	81 fb 54 33 12 80    	cmp    $0x80123354,%ebx
8010440c:	74 1e                	je     8010442c <wait+0x6c>
      if(p->parent != curproc)
8010440e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104411:	75 ed                	jne    80104400 <wait+0x40>
      if(p->state == ZOMBIE){
80104413:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104417:	74 37                	je     80104450 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104419:	81 c3 d8 03 00 00    	add    $0x3d8,%ebx
      havekids = 1;
8010441f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104424:	81 fb 54 33 12 80    	cmp    $0x80123354,%ebx
8010442a:	75 e2                	jne    8010440e <wait+0x4e>
    if(!havekids || curproc->killed){
8010442c:	85 c0                	test   %eax,%eax
8010442e:	74 76                	je     801044a6 <wait+0xe6>
80104430:	8b 46 24             	mov    0x24(%esi),%eax
80104433:	85 c0                	test   %eax,%eax
80104435:	75 6f                	jne    801044a6 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104437:	83 ec 08             	sub    $0x8,%esp
8010443a:	68 20 3d 11 80       	push   $0x80113d20
8010443f:	56                   	push   %esi
80104440:	e8 bb fe ff ff       	call   80104300 <sleep>
    havekids = 0;
80104445:	83 c4 10             	add    $0x10,%esp
80104448:	eb a4                	jmp    801043ee <wait+0x2e>
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104456:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104459:	e8 92 e3 ff ff       	call   801027f0 <kfree>
        freevm(p->pgdir);
8010445e:	5a                   	pop    %edx
8010445f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104462:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104469:	e8 f2 33 00 00       	call   80107860 <freevm>
        release(&ptable.lock);
8010446e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
80104475:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010447c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104483:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104487:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010448e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104495:	e8 06 07 00 00       	call   80104ba0 <release>
        return pid;
8010449a:	83 c4 10             	add    $0x10,%esp
}
8010449d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a0:	89 f0                	mov    %esi,%eax
801044a2:	5b                   	pop    %ebx
801044a3:	5e                   	pop    %esi
801044a4:	5d                   	pop    %ebp
801044a5:	c3                   	ret    
      release(&ptable.lock);
801044a6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801044a9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801044ae:	68 20 3d 11 80       	push   $0x80113d20
801044b3:	e8 e8 06 00 00       	call   80104ba0 <release>
      return -1;
801044b8:	83 c4 10             	add    $0x10,%esp
801044bb:	eb e0                	jmp    8010449d <wait+0xdd>
801044bd:	8d 76 00             	lea    0x0(%esi),%esi

801044c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801044c0:	f3 0f 1e fb          	endbr32 
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	53                   	push   %ebx
801044c8:	83 ec 10             	sub    $0x10,%esp
801044cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044ce:	68 20 3d 11 80       	push   $0x80113d20
801044d3:	e8 08 06 00 00       	call   80104ae0 <acquire>
801044d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044db:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801044e0:	eb 12                	jmp    801044f4 <wakeup+0x34>
801044e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044e8:	05 d8 03 00 00       	add    $0x3d8,%eax
801044ed:	3d 54 33 12 80       	cmp    $0x80123354,%eax
801044f2:	74 1e                	je     80104512 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
801044f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044f8:	75 ee                	jne    801044e8 <wakeup+0x28>
801044fa:	3b 58 20             	cmp    0x20(%eax),%ebx
801044fd:	75 e9                	jne    801044e8 <wakeup+0x28>
      p->state = RUNNABLE;
801044ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104506:	05 d8 03 00 00       	add    $0x3d8,%eax
8010450b:	3d 54 33 12 80       	cmp    $0x80123354,%eax
80104510:	75 e2                	jne    801044f4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104512:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104519:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010451c:	c9                   	leave  
  release(&ptable.lock);
8010451d:	e9 7e 06 00 00       	jmp    80104ba0 <release>
80104522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104530 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	53                   	push   %ebx
80104538:	83 ec 10             	sub    $0x10,%esp
8010453b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010453e:	68 20 3d 11 80       	push   $0x80113d20
80104543:	e8 98 05 00 00       	call   80104ae0 <acquire>
80104548:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010454b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104550:	eb 12                	jmp    80104564 <kill+0x34>
80104552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104558:	05 d8 03 00 00       	add    $0x3d8,%eax
8010455d:	3d 54 33 12 80       	cmp    $0x80123354,%eax
80104562:	74 34                	je     80104598 <kill+0x68>
    if(p->pid == pid){
80104564:	39 58 10             	cmp    %ebx,0x10(%eax)
80104567:	75 ef                	jne    80104558 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104569:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010456d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104574:	75 07                	jne    8010457d <kill+0x4d>
        p->state = RUNNABLE;
80104576:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010457d:	83 ec 0c             	sub    $0xc,%esp
80104580:	68 20 3d 11 80       	push   $0x80113d20
80104585:	e8 16 06 00 00       	call   80104ba0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010458a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010458d:	83 c4 10             	add    $0x10,%esp
80104590:	31 c0                	xor    %eax,%eax
}
80104592:	c9                   	leave  
80104593:	c3                   	ret    
80104594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104598:	83 ec 0c             	sub    $0xc,%esp
8010459b:	68 20 3d 11 80       	push   $0x80113d20
801045a0:	e8 fb 05 00 00       	call   80104ba0 <release>
}
801045a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801045a8:	83 c4 10             	add    $0x10,%esp
801045ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045b0:	c9                   	leave  
801045b1:	c3                   	ret    
801045b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045c0 <Counter_Set_korar_jonno>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
Counter_Set_korar_jonno(void){
801045c0:	f3 0f 1e fb          	endbr32 
801045c4:	55                   	push   %ebp
801045c5:	89 e5                	mov    %esp,%ebp
801045c7:	56                   	push   %esi
801045c8:	be 30 40 11 80       	mov    $0x80114030,%esi
801045cd:	53                   	push   %ebx
801045ce:	eb 0e                	jmp    801045de <Counter_Set_korar_jonno+0x1e>
  
  pte_t *pte=0;
  int i;
  struct proc* p;

  for(p=ptable.proc; p < &ptable.proc[NPROC]; p++){
801045d0:	81 c6 d8 03 00 00    	add    $0x3d8,%esi
801045d6:	81 fe 30 36 12 80    	cmp    $0x80123630,%esi
801045dc:	74 39                	je     80104617 <Counter_Set_korar_jonno+0x57>
      if(p->state == UNUSED){
801045de:	8b 86 30 fd ff ff    	mov    -0x2d0(%esi),%eax
801045e4:	85 c0                	test   %eax,%eax
801045e6:	74 e8                	je     801045d0 <Counter_Set_korar_jonno+0x10>
801045e8:	8d 9e 20 fe ff ff    	lea    -0x1e0(%esi),%ebx
801045ee:	66 90                	xchg   %ax,%ax
        continue;
      }
      for(i=0;i<30;i++){
        pte_er_jonno(p->list_arrays[i].pGDIR,pte,p->list_arrays[i].v_address,0);
801045f0:	6a 00                	push   $0x0
801045f2:	83 c3 10             	add    $0x10,%ebx
801045f5:	ff 73 f0             	pushl  -0x10(%ebx)
801045f8:	6a 00                	push   $0x0
801045fa:	ff 73 f8             	pushl  -0x8(%ebx)
801045fd:	e8 ce 29 00 00       	call   80106fd0 <pte_er_jonno>
      for(i=0;i<30;i++){
80104602:	83 c4 10             	add    $0x10,%esp
80104605:	39 f3                	cmp    %esi,%ebx
80104607:	75 e7                	jne    801045f0 <Counter_Set_korar_jonno+0x30>
  for(p=ptable.proc; p < &ptable.proc[NPROC]; p++){
80104609:	81 c6 d8 03 00 00    	add    $0x3d8,%esi
8010460f:	81 fe 30 36 12 80    	cmp    $0x80123630,%esi
80104615:	75 c7                	jne    801045de <Counter_Set_korar_jonno+0x1e>
        }

      }
  }

}
80104617:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010461a:	5b                   	pop    %ebx
8010461b:	5e                   	pop    %esi
8010461c:	5d                   	pop    %ebp
8010461d:	c3                   	ret    
8010461e:	66 90                	xchg   %ax,%ax

80104620 <procdump>:

void
procdump(void)
{
80104620:	f3 0f 1e fb          	endbr32 
80104624:	55                   	push   %ebp
80104625:	89 e5                	mov    %esp,%ebp
80104627:	57                   	push   %edi
80104628:	56                   	push   %esi
80104629:	53                   	push   %ebx
8010462a:	83 ec 4c             	sub    $0x4c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010462d:	c7 45 ac 54 3d 11 80 	movl   $0x80113d54,-0x54(%ebp)
80104634:	eb 15                	jmp    8010464b <procdump+0x2b>
80104636:	81 45 ac d8 03 00 00 	addl   $0x3d8,-0x54(%ebp)
8010463d:	8b 45 ac             	mov    -0x54(%ebp),%eax
80104640:	3d 54 33 12 80       	cmp    $0x80123354,%eax
80104645:	0f 84 c7 01 00 00    	je     80104812 <procdump+0x1f2>
    if(p->state == UNUSED)
8010464b:	8b 45 ac             	mov    -0x54(%ebp),%eax
8010464e:	8b 50 0c             	mov    0xc(%eax),%edx
80104651:	85 d2                	test   %edx,%edx
80104653:	74 e1                	je     80104636 <procdump+0x16>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80104655:	b8 cb 83 10 80       	mov    $0x801083cb,%eax
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010465a:	83 fa 05             	cmp    $0x5,%edx
8010465d:	77 11                	ja     80104670 <procdump+0x50>
8010465f:	8b 04 95 20 85 10 80 	mov    -0x7fef7ae0(,%edx,4),%eax
      state = "???";
80104666:	ba cb 83 10 80       	mov    $0x801083cb,%edx
8010466b:	85 c0                	test   %eax,%eax
8010466d:	0f 44 c2             	cmove  %edx,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80104670:	8b 75 ac             	mov    -0x54(%ebp),%esi
80104673:	8d 56 6c             	lea    0x6c(%esi),%edx
80104676:	52                   	push   %edx
80104677:	50                   	push   %eax
80104678:	ff 76 10             	pushl  0x10(%esi)
8010467b:	68 cf 83 10 80       	push   $0x801083cf
80104680:	e8 2b c0 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104685:	83 c4 10             	add    $0x10,%esp
80104688:	83 7e 0c 02          	cmpl   $0x2,0xc(%esi)
8010468c:	0f 84 37 01 00 00    	je     801047c9 <procdump+0x1a9>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104692:	83 ec 0c             	sub    $0xc,%esp
80104695:	68 ef 89 10 80       	push   $0x801089ef
8010469a:	e8 11 c0 ff ff       	call   801006b0 <cprintf>
    pte_t *pgtab3;
    uint  pgtab4;
    uint  pgtab5=0;
    uint  i;
    uint  j;
    cprintf("Page table:\n");
8010469f:	c7 04 24 d8 83 10 80 	movl   $0x801083d8,(%esp)
801046a6:	e8 05 c0 ff ff       	call   801006b0 <cprintf>
    cprintf("           memory location of page directory %d\n",p->pgdir[0]);
801046ab:	8b 45 ac             	mov    -0x54(%ebp),%eax
801046ae:	59                   	pop    %ecx
801046af:	5b                   	pop    %ebx
801046b0:	8b 40 04             	mov    0x4(%eax),%eax
801046b3:	ff 30                	pushl  (%eax)
801046b5:	68 90 84 10 80       	push   $0x80108490
801046ba:	e8 f1 bf ff ff       	call   801006b0 <cprintf>
    for(i=0;i<512;i++)
801046bf:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
    cprintf("           memory location of page directory %d\n",p->pgdir[0]);
801046c6:	83 c4 10             	add    $0x10,%esp
801046c9:	eb 17                	jmp    801046e2 <procdump+0xc2>
801046cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046cf:	90                   	nop
    for(i=0;i<512;i++)
801046d0:	83 45 b0 01          	addl   $0x1,-0x50(%ebp)
801046d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
801046d7:	3d 00 02 00 00       	cmp    $0x200,%eax
801046dc:	0f 84 54 ff ff ff    	je     80104636 <procdump+0x16>
    {
        pde = &(p->pgdir[i]);
801046e2:	8b 45 ac             	mov    -0x54(%ebp),%eax
801046e5:	8b 4d b0             	mov    -0x50(%ebp),%ecx
801046e8:	8b 40 04             	mov    0x4(%eax),%eax
801046eb:	8d 1c 88             	lea    (%eax,%ecx,4),%ebx
        if(*pde & (PTE_P|PTE_U))
801046ee:	f6 03 05             	testb  $0x5,(%ebx)
801046f1:	74 dd                	je     801046d0 <procdump+0xb0>
        {
          cprintf("           pdir PDE ");
801046f3:	83 ec 0c             	sub    $0xc,%esp
801046f6:	68 e5 83 10 80       	push   $0x801083e5
801046fb:	e8 b0 bf ff ff       	call   801006b0 <cprintf>
          cprintf(" %d ,",i);
80104700:	59                   	pop    %ecx
80104701:	5e                   	pop    %esi
80104702:	8b 75 b0             	mov    -0x50(%ebp),%esi
80104705:	56                   	push   %esi
80104706:	c1 e6 0a             	shl    $0xa,%esi
80104709:	68 fa 83 10 80       	push   $0x801083fa
8010470e:	e8 9d bf ff ff       	call   801006b0 <cprintf>
          pgtab1 =(*pde)>>12;
80104713:	8b 13                	mov    (%ebx),%edx
          pgtab2 =(pte_t*)P2V(PTE_ADDR(*pde));
80104715:	89 d0                	mov    %edx,%eax
          pgtab1 =(*pde)>>12;
80104717:	c1 ea 0c             	shr    $0xc,%edx
          pgtab2 =(pte_t*)P2V(PTE_ADDR(*pde));
8010471a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010471f:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
          cprintf("%d\n",pgtab1);
80104725:	58                   	pop    %eax
80104726:	59                   	pop    %ecx
80104727:	52                   	push   %edx
80104728:	68 90 89 10 80       	push   $0x80108990
8010472d:	e8 7e bf ff ff       	call   801006b0 <cprintf>
          cprintf("                    memory location of page table %d \n",PTE_ADDR(*pde));
80104732:	58                   	pop    %eax
80104733:	5a                   	pop    %edx
80104734:	8b 13                	mov    (%ebx),%edx
          for(j=0;j<1024;j++){
80104736:	31 db                	xor    %ebx,%ebx
          cprintf("                    memory location of page table %d \n",PTE_ADDR(*pde));
80104738:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010473e:	52                   	push   %edx
8010473f:	68 c4 84 10 80       	push   $0x801084c4
80104744:	e8 67 bf ff ff       	call   801006b0 <cprintf>
          for(j=0;j<1024;j++){
80104749:	89 75 b4             	mov    %esi,-0x4c(%ebp)
8010474c:	83 c4 10             	add    $0x10,%esp
8010474f:	eb 19                	jmp    8010476a <procdump+0x14a>
80104751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104758:	83 c3 01             	add    $0x1,%ebx
8010475b:	83 c7 04             	add    $0x4,%edi
8010475e:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80104764:	0f 84 66 ff ff ff    	je     801046d0 <procdump+0xb0>
              pgtab3= &(pgtab2[j]);
              if(*pgtab3 & (PTE_P|PTE_U))
8010476a:	f6 07 05             	testb  $0x5,(%edi)
8010476d:	74 e9                	je     80104758 <procdump+0x138>
                {
                    cprintf("                    ptlb PTE ");
8010476f:	83 ec 0c             	sub    $0xc,%esp
80104772:	68 00 84 10 80       	push   $0x80108400
80104777:	e8 34 bf ff ff       	call   801006b0 <cprintf>
                    cprintf(" %d ,",j);
8010477c:	58                   	pop    %eax
8010477d:	5a                   	pop    %edx
8010477e:	53                   	push   %ebx
8010477f:	68 fa 83 10 80       	push   $0x801083fa
80104784:	e8 27 bf ff ff       	call   801006b0 <cprintf>
                    pgtab4 = PTE_ADDR(*pgtab3);
80104789:	8b 07                	mov    (%edi),%eax
                    pgtab5 = (*pgtab3) >> 12;
                    cprintf("%d %d\n",pgtab5,pgtab4);
8010478b:	83 c4 0c             	add    $0xc,%esp
                    pgtab5 = (*pgtab3) >> 12;
8010478e:	89 c6                	mov    %eax,%esi
                    pgtab4 = PTE_ADDR(*pgtab3);
80104790:	25 00 f0 ff ff       	and    $0xfffff000,%eax
                    pgtab5 = (*pgtab3) >> 12;
80104795:	c1 ee 0c             	shr    $0xc,%esi
                    cprintf("%d %d\n",pgtab5,pgtab4);
80104798:	50                   	push   %eax
80104799:	56                   	push   %esi
8010479a:	68 52 89 10 80       	push   $0x80108952
8010479f:	e8 0c bf ff ff       	call   801006b0 <cprintf>
                    cprintf("                    Page mappings:\n");
801047a4:	c7 04 24 fc 84 10 80 	movl   $0x801084fc,(%esp)
801047ab:	e8 00 bf ff ff       	call   801006b0 <cprintf>
                    cprintf("                    %d -> %d\n",(i*1024+j),pgtab5);
801047b0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801047b3:	83 c4 0c             	add    $0xc,%esp
801047b6:	56                   	push   %esi
801047b7:	01 d8                	add    %ebx,%eax
801047b9:	50                   	push   %eax
801047ba:	68 1e 84 10 80       	push   $0x8010841e
801047bf:	e8 ec be ff ff       	call   801006b0 <cprintf>
801047c4:	83 c4 10             	add    $0x10,%esp
801047c7:	eb 8f                	jmp    80104758 <procdump+0x138>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801047c9:	83 ec 08             	sub    $0x8,%esp
801047cc:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047cf:	8d 5d c0             	lea    -0x40(%ebp),%ebx
801047d2:	50                   	push   %eax
801047d3:	8b 45 ac             	mov    -0x54(%ebp),%eax
801047d6:	8b 40 1c             	mov    0x1c(%eax),%eax
801047d9:	8b 40 0c             	mov    0xc(%eax),%eax
801047dc:	83 c0 08             	add    $0x8,%eax
801047df:	50                   	push   %eax
801047e0:	e8 9b 01 00 00       	call   80104980 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801047e5:	83 c4 10             	add    $0x10,%esp
801047e8:	8b 03                	mov    (%ebx),%eax
801047ea:	85 c0                	test   %eax,%eax
801047ec:	0f 84 a0 fe ff ff    	je     80104692 <procdump+0x72>
        cprintf(" %p", pc[i]);
801047f2:	83 ec 08             	sub    $0x8,%esp
801047f5:	83 c3 04             	add    $0x4,%ebx
801047f8:	50                   	push   %eax
801047f9:	68 e1 7d 10 80       	push   $0x80107de1
801047fe:	e8 ad be ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104803:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104806:	83 c4 10             	add    $0x10,%esp
80104809:	39 d8                	cmp    %ebx,%eax
8010480b:	75 db                	jne    801047e8 <procdump+0x1c8>
8010480d:	e9 80 fe ff ff       	jmp    80104692 <procdump+0x72>
              }
             
          }
       }
   }
}
80104812:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104815:	5b                   	pop    %ebx
80104816:	5e                   	pop    %esi
80104817:	5f                   	pop    %edi
80104818:	5d                   	pop    %ebp
80104819:	c3                   	ret    
8010481a:	66 90                	xchg   %ax,%ax
8010481c:	66 90                	xchg   %ax,%ax
8010481e:	66 90                	xchg   %ax,%ax

80104820 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	53                   	push   %ebx
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010482e:	68 38 85 10 80       	push   $0x80108538
80104833:	8d 43 04             	lea    0x4(%ebx),%eax
80104836:	50                   	push   %eax
80104837:	e8 24 01 00 00       	call   80104960 <initlock>
  lk->name = name;
8010483c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010483f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104845:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104848:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010484f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104855:	c9                   	leave  
80104856:	c3                   	ret    
80104857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485e:	66 90                	xchg   %ax,%ax

80104860 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	56                   	push   %esi
80104868:	53                   	push   %ebx
80104869:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010486c:	8d 73 04             	lea    0x4(%ebx),%esi
8010486f:	83 ec 0c             	sub    $0xc,%esp
80104872:	56                   	push   %esi
80104873:	e8 68 02 00 00       	call   80104ae0 <acquire>
  while (lk->locked) {
80104878:	8b 13                	mov    (%ebx),%edx
8010487a:	83 c4 10             	add    $0x10,%esp
8010487d:	85 d2                	test   %edx,%edx
8010487f:	74 1a                	je     8010489b <acquiresleep+0x3b>
80104881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104888:	83 ec 08             	sub    $0x8,%esp
8010488b:	56                   	push   %esi
8010488c:	53                   	push   %ebx
8010488d:	e8 6e fa ff ff       	call   80104300 <sleep>
  while (lk->locked) {
80104892:	8b 03                	mov    (%ebx),%eax
80104894:	83 c4 10             	add    $0x10,%esp
80104897:	85 c0                	test   %eax,%eax
80104899:	75 ed                	jne    80104888 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010489b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801048a1:	e8 7a f4 ff ff       	call   80103d20 <myproc>
801048a6:	8b 40 10             	mov    0x10(%eax),%eax
801048a9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801048ac:	89 75 08             	mov    %esi,0x8(%ebp)
}
801048af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b2:	5b                   	pop    %ebx
801048b3:	5e                   	pop    %esi
801048b4:	5d                   	pop    %ebp
  release(&lk->lk);
801048b5:	e9 e6 02 00 00       	jmp    80104ba0 <release>
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
801048c5:	89 e5                	mov    %esp,%ebp
801048c7:	56                   	push   %esi
801048c8:	53                   	push   %ebx
801048c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048cc:	8d 73 04             	lea    0x4(%ebx),%esi
801048cf:	83 ec 0c             	sub    $0xc,%esp
801048d2:	56                   	push   %esi
801048d3:	e8 08 02 00 00       	call   80104ae0 <acquire>
  lk->locked = 0;
801048d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801048de:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801048e5:	89 1c 24             	mov    %ebx,(%esp)
801048e8:	e8 d3 fb ff ff       	call   801044c0 <wakeup>
  release(&lk->lk);
801048ed:	89 75 08             	mov    %esi,0x8(%ebp)
801048f0:	83 c4 10             	add    $0x10,%esp
}
801048f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048f6:	5b                   	pop    %ebx
801048f7:	5e                   	pop    %esi
801048f8:	5d                   	pop    %ebp
  release(&lk->lk);
801048f9:	e9 a2 02 00 00       	jmp    80104ba0 <release>
801048fe:	66 90                	xchg   %ax,%ax

80104900 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104900:	f3 0f 1e fb          	endbr32 
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	57                   	push   %edi
80104908:	31 ff                	xor    %edi,%edi
8010490a:	56                   	push   %esi
8010490b:	53                   	push   %ebx
8010490c:	83 ec 18             	sub    $0x18,%esp
8010490f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104912:	8d 73 04             	lea    0x4(%ebx),%esi
80104915:	56                   	push   %esi
80104916:	e8 c5 01 00 00       	call   80104ae0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010491b:	8b 03                	mov    (%ebx),%eax
8010491d:	83 c4 10             	add    $0x10,%esp
80104920:	85 c0                	test   %eax,%eax
80104922:	75 1c                	jne    80104940 <holdingsleep+0x40>
  release(&lk->lk);
80104924:	83 ec 0c             	sub    $0xc,%esp
80104927:	56                   	push   %esi
80104928:	e8 73 02 00 00       	call   80104ba0 <release>
  return r;
}
8010492d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104930:	89 f8                	mov    %edi,%eax
80104932:	5b                   	pop    %ebx
80104933:	5e                   	pop    %esi
80104934:	5f                   	pop    %edi
80104935:	5d                   	pop    %ebp
80104936:	c3                   	ret    
80104937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104940:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104943:	e8 d8 f3 ff ff       	call   80103d20 <myproc>
80104948:	39 58 10             	cmp    %ebx,0x10(%eax)
8010494b:	0f 94 c0             	sete   %al
8010494e:	0f b6 c0             	movzbl %al,%eax
80104951:	89 c7                	mov    %eax,%edi
80104953:	eb cf                	jmp    80104924 <holdingsleep+0x24>
80104955:	66 90                	xchg   %ax,%ax
80104957:	66 90                	xchg   %ax,%ax
80104959:	66 90                	xchg   %ax,%ax
8010495b:	66 90                	xchg   %ax,%ax
8010495d:	66 90                	xchg   %ax,%ax
8010495f:	90                   	nop

80104960 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104960:	f3 0f 1e fb          	endbr32 
80104964:	55                   	push   %ebp
80104965:	89 e5                	mov    %esp,%ebp
80104967:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010496a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010496d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104973:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104976:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010497d:	5d                   	pop    %ebp
8010497e:	c3                   	ret    
8010497f:	90                   	nop

80104980 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104980:	f3 0f 1e fb          	endbr32 
80104984:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104985:	31 d2                	xor    %edx,%edx
{
80104987:	89 e5                	mov    %esp,%ebp
80104989:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010498a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010498d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104990:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104993:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104997:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104998:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010499e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049a4:	77 1a                	ja     801049c0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801049a6:	8b 58 04             	mov    0x4(%eax),%ebx
801049a9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801049ac:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801049af:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801049b1:	83 fa 0a             	cmp    $0xa,%edx
801049b4:	75 e2                	jne    80104998 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801049b6:	5b                   	pop    %ebx
801049b7:	5d                   	pop    %ebp
801049b8:	c3                   	ret    
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801049c0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801049c3:	8d 51 28             	lea    0x28(%ecx),%edx
801049c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801049d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049d6:	83 c0 04             	add    $0x4,%eax
801049d9:	39 d0                	cmp    %edx,%eax
801049db:	75 f3                	jne    801049d0 <getcallerpcs+0x50>
}
801049dd:	5b                   	pop    %ebx
801049de:	5d                   	pop    %ebp
801049df:	c3                   	ret    

801049e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801049e0:	f3 0f 1e fb          	endbr32 
801049e4:	55                   	push   %ebp
801049e5:	89 e5                	mov    %esp,%ebp
801049e7:	53                   	push   %ebx
801049e8:	83 ec 04             	sub    $0x4,%esp
801049eb:	9c                   	pushf  
801049ec:	5b                   	pop    %ebx
  asm volatile("cli");
801049ed:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801049ee:	e8 9d f2 ff ff       	call   80103c90 <mycpu>
801049f3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049f9:	85 c0                	test   %eax,%eax
801049fb:	74 13                	je     80104a10 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801049fd:	e8 8e f2 ff ff       	call   80103c90 <mycpu>
80104a02:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a09:	83 c4 04             	add    $0x4,%esp
80104a0c:	5b                   	pop    %ebx
80104a0d:	5d                   	pop    %ebp
80104a0e:	c3                   	ret    
80104a0f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104a10:	e8 7b f2 ff ff       	call   80103c90 <mycpu>
80104a15:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a1b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104a21:	eb da                	jmp    801049fd <pushcli+0x1d>
80104a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a30 <popcli>:

void
popcli(void)
{
80104a30:	f3 0f 1e fb          	endbr32 
80104a34:	55                   	push   %ebp
80104a35:	89 e5                	mov    %esp,%ebp
80104a37:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a3a:	9c                   	pushf  
80104a3b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a3c:	f6 c4 02             	test   $0x2,%ah
80104a3f:	75 31                	jne    80104a72 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a41:	e8 4a f2 ff ff       	call   80103c90 <mycpu>
80104a46:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a4d:	78 30                	js     80104a7f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a4f:	e8 3c f2 ff ff       	call   80103c90 <mycpu>
80104a54:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a5a:	85 d2                	test   %edx,%edx
80104a5c:	74 02                	je     80104a60 <popcli+0x30>
    sti();
}
80104a5e:	c9                   	leave  
80104a5f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a60:	e8 2b f2 ff ff       	call   80103c90 <mycpu>
80104a65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a6b:	85 c0                	test   %eax,%eax
80104a6d:	74 ef                	je     80104a5e <popcli+0x2e>
  asm volatile("sti");
80104a6f:	fb                   	sti    
}
80104a70:	c9                   	leave  
80104a71:	c3                   	ret    
    panic("popcli - interruptible");
80104a72:	83 ec 0c             	sub    $0xc,%esp
80104a75:	68 43 85 10 80       	push   $0x80108543
80104a7a:	e8 11 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
80104a7f:	83 ec 0c             	sub    $0xc,%esp
80104a82:	68 5a 85 10 80       	push   $0x8010855a
80104a87:	e8 04 b9 ff ff       	call   80100390 <panic>
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <holding>:
{
80104a90:	f3 0f 1e fb          	endbr32 
80104a94:	55                   	push   %ebp
80104a95:	89 e5                	mov    %esp,%ebp
80104a97:	56                   	push   %esi
80104a98:	53                   	push   %ebx
80104a99:	8b 75 08             	mov    0x8(%ebp),%esi
80104a9c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a9e:	e8 3d ff ff ff       	call   801049e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104aa3:	8b 06                	mov    (%esi),%eax
80104aa5:	85 c0                	test   %eax,%eax
80104aa7:	75 0f                	jne    80104ab8 <holding+0x28>
  popcli();
80104aa9:	e8 82 ff ff ff       	call   80104a30 <popcli>
}
80104aae:	89 d8                	mov    %ebx,%eax
80104ab0:	5b                   	pop    %ebx
80104ab1:	5e                   	pop    %esi
80104ab2:	5d                   	pop    %ebp
80104ab3:	c3                   	ret    
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ab8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104abb:	e8 d0 f1 ff ff       	call   80103c90 <mycpu>
80104ac0:	39 c3                	cmp    %eax,%ebx
80104ac2:	0f 94 c3             	sete   %bl
  popcli();
80104ac5:	e8 66 ff ff ff       	call   80104a30 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104aca:	0f b6 db             	movzbl %bl,%ebx
}
80104acd:	89 d8                	mov    %ebx,%eax
80104acf:	5b                   	pop    %ebx
80104ad0:	5e                   	pop    %esi
80104ad1:	5d                   	pop    %ebp
80104ad2:	c3                   	ret    
80104ad3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ae0 <acquire>:
{
80104ae0:	f3 0f 1e fb          	endbr32 
80104ae4:	55                   	push   %ebp
80104ae5:	89 e5                	mov    %esp,%ebp
80104ae7:	56                   	push   %esi
80104ae8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104ae9:	e8 f2 fe ff ff       	call   801049e0 <pushcli>
  if(holding(lk))
80104aee:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104af1:	83 ec 0c             	sub    $0xc,%esp
80104af4:	53                   	push   %ebx
80104af5:	e8 96 ff ff ff       	call   80104a90 <holding>
80104afa:	83 c4 10             	add    $0x10,%esp
80104afd:	85 c0                	test   %eax,%eax
80104aff:	0f 85 7f 00 00 00    	jne    80104b84 <acquire+0xa4>
80104b05:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104b07:	ba 01 00 00 00       	mov    $0x1,%edx
80104b0c:	eb 05                	jmp    80104b13 <acquire+0x33>
80104b0e:	66 90                	xchg   %ax,%ax
80104b10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b13:	89 d0                	mov    %edx,%eax
80104b15:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104b18:	85 c0                	test   %eax,%eax
80104b1a:	75 f4                	jne    80104b10 <acquire+0x30>
  __sync_synchronize();
80104b1c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b24:	e8 67 f1 ff ff       	call   80103c90 <mycpu>
80104b29:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104b2c:	89 e8                	mov    %ebp,%eax
80104b2e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b30:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104b36:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104b3c:	77 22                	ja     80104b60 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104b3e:	8b 50 04             	mov    0x4(%eax),%edx
80104b41:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104b45:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104b48:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b4a:	83 fe 0a             	cmp    $0xa,%esi
80104b4d:	75 e1                	jne    80104b30 <acquire+0x50>
}
80104b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b52:	5b                   	pop    %ebx
80104b53:	5e                   	pop    %esi
80104b54:	5d                   	pop    %ebp
80104b55:	c3                   	ret    
80104b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104b60:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104b64:	83 c3 34             	add    $0x34,%ebx
80104b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104b70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b76:	83 c0 04             	add    $0x4,%eax
80104b79:	39 d8                	cmp    %ebx,%eax
80104b7b:	75 f3                	jne    80104b70 <acquire+0x90>
}
80104b7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b80:	5b                   	pop    %ebx
80104b81:	5e                   	pop    %esi
80104b82:	5d                   	pop    %ebp
80104b83:	c3                   	ret    
    panic("acquire");
80104b84:	83 ec 0c             	sub    $0xc,%esp
80104b87:	68 61 85 10 80       	push   $0x80108561
80104b8c:	e8 ff b7 ff ff       	call   80100390 <panic>
80104b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9f:	90                   	nop

80104ba0 <release>:
{
80104ba0:	f3 0f 1e fb          	endbr32 
80104ba4:	55                   	push   %ebp
80104ba5:	89 e5                	mov    %esp,%ebp
80104ba7:	53                   	push   %ebx
80104ba8:	83 ec 10             	sub    $0x10,%esp
80104bab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104bae:	53                   	push   %ebx
80104baf:	e8 dc fe ff ff       	call   80104a90 <holding>
80104bb4:	83 c4 10             	add    $0x10,%esp
80104bb7:	85 c0                	test   %eax,%eax
80104bb9:	74 22                	je     80104bdd <release+0x3d>
  lk->pcs[0] = 0;
80104bbb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104bc2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104bc9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104bce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104bd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd7:	c9                   	leave  
  popcli();
80104bd8:	e9 53 fe ff ff       	jmp    80104a30 <popcli>
    panic("release");
80104bdd:	83 ec 0c             	sub    $0xc,%esp
80104be0:	68 69 85 10 80       	push   $0x80108569
80104be5:	e8 a6 b7 ff ff       	call   80100390 <panic>
80104bea:	66 90                	xchg   %ax,%ax
80104bec:	66 90                	xchg   %ax,%ax
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104bf0:	f3 0f 1e fb          	endbr32 
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	57                   	push   %edi
80104bf8:	8b 55 08             	mov    0x8(%ebp),%edx
80104bfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bfe:	53                   	push   %ebx
80104bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104c02:	89 d7                	mov    %edx,%edi
80104c04:	09 cf                	or     %ecx,%edi
80104c06:	83 e7 03             	and    $0x3,%edi
80104c09:	75 25                	jne    80104c30 <memset+0x40>
    c &= 0xFF;
80104c0b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c0e:	c1 e0 18             	shl    $0x18,%eax
80104c11:	89 fb                	mov    %edi,%ebx
80104c13:	c1 e9 02             	shr    $0x2,%ecx
80104c16:	c1 e3 10             	shl    $0x10,%ebx
80104c19:	09 d8                	or     %ebx,%eax
80104c1b:	09 f8                	or     %edi,%eax
80104c1d:	c1 e7 08             	shl    $0x8,%edi
80104c20:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104c22:	89 d7                	mov    %edx,%edi
80104c24:	fc                   	cld    
80104c25:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104c27:	5b                   	pop    %ebx
80104c28:	89 d0                	mov    %edx,%eax
80104c2a:	5f                   	pop    %edi
80104c2b:	5d                   	pop    %ebp
80104c2c:	c3                   	ret    
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104c30:	89 d7                	mov    %edx,%edi
80104c32:	fc                   	cld    
80104c33:	f3 aa                	rep stos %al,%es:(%edi)
80104c35:	5b                   	pop    %ebx
80104c36:	89 d0                	mov    %edx,%eax
80104c38:	5f                   	pop    %edi
80104c39:	5d                   	pop    %ebp
80104c3a:	c3                   	ret    
80104c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop

80104c40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	56                   	push   %esi
80104c48:	8b 75 10             	mov    0x10(%ebp),%esi
80104c4b:	8b 55 08             	mov    0x8(%ebp),%edx
80104c4e:	53                   	push   %ebx
80104c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c52:	85 f6                	test   %esi,%esi
80104c54:	74 2a                	je     80104c80 <memcmp+0x40>
80104c56:	01 c6                	add    %eax,%esi
80104c58:	eb 10                	jmp    80104c6a <memcmp+0x2a>
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104c60:	83 c0 01             	add    $0x1,%eax
80104c63:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104c66:	39 f0                	cmp    %esi,%eax
80104c68:	74 16                	je     80104c80 <memcmp+0x40>
    if(*s1 != *s2)
80104c6a:	0f b6 0a             	movzbl (%edx),%ecx
80104c6d:	0f b6 18             	movzbl (%eax),%ebx
80104c70:	38 d9                	cmp    %bl,%cl
80104c72:	74 ec                	je     80104c60 <memcmp+0x20>
      return *s1 - *s2;
80104c74:	0f b6 c1             	movzbl %cl,%eax
80104c77:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104c79:	5b                   	pop    %ebx
80104c7a:	5e                   	pop    %esi
80104c7b:	5d                   	pop    %ebp
80104c7c:	c3                   	ret    
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
80104c80:	5b                   	pop    %ebx
  return 0;
80104c81:	31 c0                	xor    %eax,%eax
}
80104c83:	5e                   	pop    %esi
80104c84:	5d                   	pop    %ebp
80104c85:	c3                   	ret    
80104c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi

80104c90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	57                   	push   %edi
80104c98:	8b 55 08             	mov    0x8(%ebp),%edx
80104c9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c9e:	56                   	push   %esi
80104c9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ca2:	39 d6                	cmp    %edx,%esi
80104ca4:	73 2a                	jae    80104cd0 <memmove+0x40>
80104ca6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104ca9:	39 fa                	cmp    %edi,%edx
80104cab:	73 23                	jae    80104cd0 <memmove+0x40>
80104cad:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104cb0:	85 c9                	test   %ecx,%ecx
80104cb2:	74 13                	je     80104cc7 <memmove+0x37>
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104cb8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104cbc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104cbf:	83 e8 01             	sub    $0x1,%eax
80104cc2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104cc5:	75 f1                	jne    80104cb8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104cc7:	5e                   	pop    %esi
80104cc8:	89 d0                	mov    %edx,%eax
80104cca:	5f                   	pop    %edi
80104ccb:	5d                   	pop    %ebp
80104ccc:	c3                   	ret    
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104cd0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104cd3:	89 d7                	mov    %edx,%edi
80104cd5:	85 c9                	test   %ecx,%ecx
80104cd7:	74 ee                	je     80104cc7 <memmove+0x37>
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104ce0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104ce1:	39 f0                	cmp    %esi,%eax
80104ce3:	75 fb                	jne    80104ce0 <memmove+0x50>
}
80104ce5:	5e                   	pop    %esi
80104ce6:	89 d0                	mov    %edx,%eax
80104ce8:	5f                   	pop    %edi
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    
80104ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cef:	90                   	nop

80104cf0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104cf0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104cf4:	eb 9a                	jmp    80104c90 <memmove>
80104cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi

80104d00 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104d00:	f3 0f 1e fb          	endbr32 
80104d04:	55                   	push   %ebp
80104d05:	89 e5                	mov    %esp,%ebp
80104d07:	56                   	push   %esi
80104d08:	8b 75 10             	mov    0x10(%ebp),%esi
80104d0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d0e:	53                   	push   %ebx
80104d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104d12:	85 f6                	test   %esi,%esi
80104d14:	74 32                	je     80104d48 <strncmp+0x48>
80104d16:	01 c6                	add    %eax,%esi
80104d18:	eb 14                	jmp    80104d2e <strncmp+0x2e>
80104d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d20:	38 da                	cmp    %bl,%dl
80104d22:	75 14                	jne    80104d38 <strncmp+0x38>
    n--, p++, q++;
80104d24:	83 c0 01             	add    $0x1,%eax
80104d27:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104d2a:	39 f0                	cmp    %esi,%eax
80104d2c:	74 1a                	je     80104d48 <strncmp+0x48>
80104d2e:	0f b6 11             	movzbl (%ecx),%edx
80104d31:	0f b6 18             	movzbl (%eax),%ebx
80104d34:	84 d2                	test   %dl,%dl
80104d36:	75 e8                	jne    80104d20 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104d38:	0f b6 c2             	movzbl %dl,%eax
80104d3b:	29 d8                	sub    %ebx,%eax
}
80104d3d:	5b                   	pop    %ebx
80104d3e:	5e                   	pop    %esi
80104d3f:	5d                   	pop    %ebp
80104d40:	c3                   	ret    
80104d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d48:	5b                   	pop    %ebx
    return 0;
80104d49:	31 c0                	xor    %eax,%eax
}
80104d4b:	5e                   	pop    %esi
80104d4c:	5d                   	pop    %ebp
80104d4d:	c3                   	ret    
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	57                   	push   %edi
80104d58:	56                   	push   %esi
80104d59:	8b 75 08             	mov    0x8(%ebp),%esi
80104d5c:	53                   	push   %ebx
80104d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d60:	89 f2                	mov    %esi,%edx
80104d62:	eb 1b                	jmp    80104d7f <strncpy+0x2f>
80104d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d68:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104d6f:	83 c2 01             	add    $0x1,%edx
80104d72:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104d76:	89 f9                	mov    %edi,%ecx
80104d78:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d7b:	84 c9                	test   %cl,%cl
80104d7d:	74 09                	je     80104d88 <strncpy+0x38>
80104d7f:	89 c3                	mov    %eax,%ebx
80104d81:	83 e8 01             	sub    $0x1,%eax
80104d84:	85 db                	test   %ebx,%ebx
80104d86:	7f e0                	jg     80104d68 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d88:	89 d1                	mov    %edx,%ecx
80104d8a:	85 c0                	test   %eax,%eax
80104d8c:	7e 15                	jle    80104da3 <strncpy+0x53>
80104d8e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104d90:	83 c1 01             	add    $0x1,%ecx
80104d93:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104d97:	89 c8                	mov    %ecx,%eax
80104d99:	f7 d0                	not    %eax
80104d9b:	01 d0                	add    %edx,%eax
80104d9d:	01 d8                	add    %ebx,%eax
80104d9f:	85 c0                	test   %eax,%eax
80104da1:	7f ed                	jg     80104d90 <strncpy+0x40>
  return os;
}
80104da3:	5b                   	pop    %ebx
80104da4:	89 f0                	mov    %esi,%eax
80104da6:	5e                   	pop    %esi
80104da7:	5f                   	pop    %edi
80104da8:	5d                   	pop    %ebp
80104da9:	c3                   	ret    
80104daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104db0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104db0:	f3 0f 1e fb          	endbr32 
80104db4:	55                   	push   %ebp
80104db5:	89 e5                	mov    %esp,%ebp
80104db7:	56                   	push   %esi
80104db8:	8b 55 10             	mov    0x10(%ebp),%edx
80104dbb:	8b 75 08             	mov    0x8(%ebp),%esi
80104dbe:	53                   	push   %ebx
80104dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104dc2:	85 d2                	test   %edx,%edx
80104dc4:	7e 21                	jle    80104de7 <safestrcpy+0x37>
80104dc6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104dca:	89 f2                	mov    %esi,%edx
80104dcc:	eb 12                	jmp    80104de0 <safestrcpy+0x30>
80104dce:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104dd0:	0f b6 08             	movzbl (%eax),%ecx
80104dd3:	83 c0 01             	add    $0x1,%eax
80104dd6:	83 c2 01             	add    $0x1,%edx
80104dd9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ddc:	84 c9                	test   %cl,%cl
80104dde:	74 04                	je     80104de4 <safestrcpy+0x34>
80104de0:	39 d8                	cmp    %ebx,%eax
80104de2:	75 ec                	jne    80104dd0 <safestrcpy+0x20>
    ;
  *s = 0;
80104de4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104de7:	89 f0                	mov    %esi,%eax
80104de9:	5b                   	pop    %ebx
80104dea:	5e                   	pop    %esi
80104deb:	5d                   	pop    %ebp
80104dec:	c3                   	ret    
80104ded:	8d 76 00             	lea    0x0(%esi),%esi

80104df0 <strlen>:

int
strlen(const char *s)
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104df5:	31 c0                	xor    %eax,%eax
{
80104df7:	89 e5                	mov    %esp,%ebp
80104df9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104dfc:	80 3a 00             	cmpb   $0x0,(%edx)
80104dff:	74 10                	je     80104e11 <strlen+0x21>
80104e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e08:	83 c0 01             	add    $0x1,%eax
80104e0b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e0f:	75 f7                	jne    80104e08 <strlen+0x18>
    ;
  return n;
}
80104e11:	5d                   	pop    %ebp
80104e12:	c3                   	ret    

80104e13 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e13:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e17:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104e1b:	55                   	push   %ebp
  pushl %ebx
80104e1c:	53                   	push   %ebx
  pushl %esi
80104e1d:	56                   	push   %esi
  pushl %edi
80104e1e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e1f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e21:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104e23:	5f                   	pop    %edi
  popl %esi
80104e24:	5e                   	pop    %esi
  popl %ebx
80104e25:	5b                   	pop    %ebx
  popl %ebp
80104e26:	5d                   	pop    %ebp
  ret
80104e27:	c3                   	ret    
80104e28:	66 90                	xchg   %ax,%ax
80104e2a:	66 90                	xchg   %ax,%ax
80104e2c:	66 90                	xchg   %ax,%ax
80104e2e:	66 90                	xchg   %ax,%ax

80104e30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	53                   	push   %ebx
80104e38:	83 ec 04             	sub    $0x4,%esp
80104e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e3e:	e8 dd ee ff ff       	call   80103d20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e43:	8b 00                	mov    (%eax),%eax
80104e45:	39 d8                	cmp    %ebx,%eax
80104e47:	76 17                	jbe    80104e60 <fetchint+0x30>
80104e49:	8d 53 04             	lea    0x4(%ebx),%edx
80104e4c:	39 d0                	cmp    %edx,%eax
80104e4e:	72 10                	jb     80104e60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e50:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e53:	8b 13                	mov    (%ebx),%edx
80104e55:	89 10                	mov    %edx,(%eax)
  return 0;
80104e57:	31 c0                	xor    %eax,%eax
}
80104e59:	83 c4 04             	add    $0x4,%esp
80104e5c:	5b                   	pop    %ebx
80104e5d:	5d                   	pop    %ebp
80104e5e:	c3                   	ret    
80104e5f:	90                   	nop
    return -1;
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e65:	eb f2                	jmp    80104e59 <fetchint+0x29>
80104e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6e:	66 90                	xchg   %ax,%ax

80104e70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e70:	f3 0f 1e fb          	endbr32 
80104e74:	55                   	push   %ebp
80104e75:	89 e5                	mov    %esp,%ebp
80104e77:	53                   	push   %ebx
80104e78:	83 ec 04             	sub    $0x4,%esp
80104e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104e7e:	e8 9d ee ff ff       	call   80103d20 <myproc>

  if(addr >= curproc->sz)
80104e83:	39 18                	cmp    %ebx,(%eax)
80104e85:	76 31                	jbe    80104eb8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104e87:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e8a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104e8c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104e8e:	39 d3                	cmp    %edx,%ebx
80104e90:	73 26                	jae    80104eb8 <fetchstr+0x48>
80104e92:	89 d8                	mov    %ebx,%eax
80104e94:	eb 11                	jmp    80104ea7 <fetchstr+0x37>
80104e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ea0:	83 c0 01             	add    $0x1,%eax
80104ea3:	39 c2                	cmp    %eax,%edx
80104ea5:	76 11                	jbe    80104eb8 <fetchstr+0x48>
    if(*s == 0)
80104ea7:	80 38 00             	cmpb   $0x0,(%eax)
80104eaa:	75 f4                	jne    80104ea0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104eac:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104eaf:	29 d8                	sub    %ebx,%eax
}
80104eb1:	5b                   	pop    %ebx
80104eb2:	5d                   	pop    %ebp
80104eb3:	c3                   	ret    
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eb8:	83 c4 04             	add    $0x4,%esp
    return -1;
80104ebb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ec0:	5b                   	pop    %ebx
80104ec1:	5d                   	pop    %ebp
80104ec2:	c3                   	ret    
80104ec3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ed0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
80104ed5:	89 e5                	mov    %esp,%ebp
80104ed7:	56                   	push   %esi
80104ed8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ed9:	e8 42 ee ff ff       	call   80103d20 <myproc>
80104ede:	8b 55 08             	mov    0x8(%ebp),%edx
80104ee1:	8b 40 18             	mov    0x18(%eax),%eax
80104ee4:	8b 40 44             	mov    0x44(%eax),%eax
80104ee7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104eea:	e8 31 ee ff ff       	call   80103d20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104eef:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ef2:	8b 00                	mov    (%eax),%eax
80104ef4:	39 c6                	cmp    %eax,%esi
80104ef6:	73 18                	jae    80104f10 <argint+0x40>
80104ef8:	8d 53 08             	lea    0x8(%ebx),%edx
80104efb:	39 d0                	cmp    %edx,%eax
80104efd:	72 11                	jb     80104f10 <argint+0x40>
  *ip = *(int*)(addr);
80104eff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f02:	8b 53 04             	mov    0x4(%ebx),%edx
80104f05:	89 10                	mov    %edx,(%eax)
  return 0;
80104f07:	31 c0                	xor    %eax,%eax
}
80104f09:	5b                   	pop    %ebx
80104f0a:	5e                   	pop    %esi
80104f0b:	5d                   	pop    %ebp
80104f0c:	c3                   	ret    
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f15:	eb f2                	jmp    80104f09 <argint+0x39>
80104f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1e:	66 90                	xchg   %ax,%ax

80104f20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f20:	f3 0f 1e fb          	endbr32 
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	56                   	push   %esi
80104f28:	53                   	push   %ebx
80104f29:	83 ec 10             	sub    $0x10,%esp
80104f2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104f2f:	e8 ec ed ff ff       	call   80103d20 <myproc>
 
  if(argint(n, &i) < 0)
80104f34:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104f37:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104f39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f3c:	50                   	push   %eax
80104f3d:	ff 75 08             	pushl  0x8(%ebp)
80104f40:	e8 8b ff ff ff       	call   80104ed0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f45:	83 c4 10             	add    $0x10,%esp
80104f48:	85 c0                	test   %eax,%eax
80104f4a:	78 24                	js     80104f70 <argptr+0x50>
80104f4c:	85 db                	test   %ebx,%ebx
80104f4e:	78 20                	js     80104f70 <argptr+0x50>
80104f50:	8b 16                	mov    (%esi),%edx
80104f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f55:	39 c2                	cmp    %eax,%edx
80104f57:	76 17                	jbe    80104f70 <argptr+0x50>
80104f59:	01 c3                	add    %eax,%ebx
80104f5b:	39 da                	cmp    %ebx,%edx
80104f5d:	72 11                	jb     80104f70 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f62:	89 02                	mov    %eax,(%edx)
  return 0;
80104f64:	31 c0                	xor    %eax,%eax
}
80104f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f69:	5b                   	pop    %ebx
80104f6a:	5e                   	pop    %esi
80104f6b:	5d                   	pop    %ebp
80104f6c:	c3                   	ret    
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f75:	eb ef                	jmp    80104f66 <argptr+0x46>
80104f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
80104f85:	89 e5                	mov    %esp,%ebp
80104f87:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f8d:	50                   	push   %eax
80104f8e:	ff 75 08             	pushl  0x8(%ebp)
80104f91:	e8 3a ff ff ff       	call   80104ed0 <argint>
80104f96:	83 c4 10             	add    $0x10,%esp
80104f99:	85 c0                	test   %eax,%eax
80104f9b:	78 13                	js     80104fb0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f9d:	83 ec 08             	sub    $0x8,%esp
80104fa0:	ff 75 0c             	pushl  0xc(%ebp)
80104fa3:	ff 75 f4             	pushl  -0xc(%ebp)
80104fa6:	e8 c5 fe ff ff       	call   80104e70 <fetchstr>
80104fab:	83 c4 10             	add    $0x10,%esp
}
80104fae:	c9                   	leave  
80104faf:	c3                   	ret    
80104fb0:	c9                   	leave  
    return -1;
80104fb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fb6:	c3                   	ret    
80104fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbe:	66 90                	xchg   %ax,%ax

80104fc0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104fc0:	f3 0f 1e fb          	endbr32 
80104fc4:	55                   	push   %ebp
80104fc5:	89 e5                	mov    %esp,%ebp
80104fc7:	53                   	push   %ebx
80104fc8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104fcb:	e8 50 ed ff ff       	call   80103d20 <myproc>
80104fd0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104fd2:	8b 40 18             	mov    0x18(%eax),%eax
80104fd5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104fd8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104fdb:	83 fa 14             	cmp    $0x14,%edx
80104fde:	77 20                	ja     80105000 <syscall+0x40>
80104fe0:	8b 14 85 a0 85 10 80 	mov    -0x7fef7a60(,%eax,4),%edx
80104fe7:	85 d2                	test   %edx,%edx
80104fe9:	74 15                	je     80105000 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104feb:	ff d2                	call   *%edx
80104fed:	89 c2                	mov    %eax,%edx
80104fef:	8b 43 18             	mov    0x18(%ebx),%eax
80104ff2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ff8:	c9                   	leave  
80104ff9:	c3                   	ret    
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105000:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105001:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105004:	50                   	push   %eax
80105005:	ff 73 10             	pushl  0x10(%ebx)
80105008:	68 71 85 10 80       	push   $0x80108571
8010500d:	e8 9e b6 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105012:	8b 43 18             	mov    0x18(%ebx),%eax
80105015:	83 c4 10             	add    $0x10,%esp
80105018:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010501f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105022:	c9                   	leave  
80105023:	c3                   	ret    
80105024:	66 90                	xchg   %ax,%ax
80105026:	66 90                	xchg   %ax,%ax
80105028:	66 90                	xchg   %ax,%ax
8010502a:	66 90                	xchg   %ax,%ax
8010502c:	66 90                	xchg   %ax,%ax
8010502e:	66 90                	xchg   %ax,%ax

80105030 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	89 d6                	mov    %edx,%esi
80105036:	53                   	push   %ebx
80105037:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105039:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010503c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010503f:	50                   	push   %eax
80105040:	6a 00                	push   $0x0
80105042:	e8 89 fe ff ff       	call   80104ed0 <argint>
80105047:	83 c4 10             	add    $0x10,%esp
8010504a:	85 c0                	test   %eax,%eax
8010504c:	78 2a                	js     80105078 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010504e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105052:	77 24                	ja     80105078 <argfd.constprop.0+0x48>
80105054:	e8 c7 ec ff ff       	call   80103d20 <myproc>
80105059:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010505c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105060:	85 c0                	test   %eax,%eax
80105062:	74 14                	je     80105078 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105064:	85 db                	test   %ebx,%ebx
80105066:	74 02                	je     8010506a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105068:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010506a:	89 06                	mov    %eax,(%esi)
  return 0;
8010506c:	31 c0                	xor    %eax,%eax
}
8010506e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105071:	5b                   	pop    %ebx
80105072:	5e                   	pop    %esi
80105073:	5d                   	pop    %ebp
80105074:	c3                   	ret    
80105075:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507d:	eb ef                	jmp    8010506e <argfd.constprop.0+0x3e>
8010507f:	90                   	nop

80105080 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105085:	31 c0                	xor    %eax,%eax
{
80105087:	89 e5                	mov    %esp,%ebp
80105089:	56                   	push   %esi
8010508a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010508b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010508e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105091:	e8 9a ff ff ff       	call   80105030 <argfd.constprop.0>
80105096:	85 c0                	test   %eax,%eax
80105098:	78 1e                	js     801050b8 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
8010509a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010509d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010509f:	e8 7c ec ff ff       	call   80103d20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801050a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801050a8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050ac:	85 d2                	test   %edx,%edx
801050ae:	74 20                	je     801050d0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801050b0:	83 c3 01             	add    $0x1,%ebx
801050b3:	83 fb 10             	cmp    $0x10,%ebx
801050b6:	75 f0                	jne    801050a8 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
801050b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801050bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801050c0:	89 d8                	mov    %ebx,%eax
801050c2:	5b                   	pop    %ebx
801050c3:	5e                   	pop    %esi
801050c4:	5d                   	pop    %ebp
801050c5:	c3                   	ret    
801050c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801050d0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801050d4:	83 ec 0c             	sub    $0xc,%esp
801050d7:	ff 75 f4             	pushl  -0xc(%ebp)
801050da:	e8 91 bd ff ff       	call   80100e70 <filedup>
  return fd;
801050df:	83 c4 10             	add    $0x10,%esp
}
801050e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050e5:	89 d8                	mov    %ebx,%eax
801050e7:	5b                   	pop    %ebx
801050e8:	5e                   	pop    %esi
801050e9:	5d                   	pop    %ebp
801050ea:	c3                   	ret    
801050eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050ef:	90                   	nop

801050f0 <sys_read>:

int
sys_read(void)
{
801050f0:	f3 0f 1e fb          	endbr32 
801050f4:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050f5:	31 c0                	xor    %eax,%eax
{
801050f7:	89 e5                	mov    %esp,%ebp
801050f9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050fc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050ff:	e8 2c ff ff ff       	call   80105030 <argfd.constprop.0>
80105104:	85 c0                	test   %eax,%eax
80105106:	78 48                	js     80105150 <sys_read+0x60>
80105108:	83 ec 08             	sub    $0x8,%esp
8010510b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010510e:	50                   	push   %eax
8010510f:	6a 02                	push   $0x2
80105111:	e8 ba fd ff ff       	call   80104ed0 <argint>
80105116:	83 c4 10             	add    $0x10,%esp
80105119:	85 c0                	test   %eax,%eax
8010511b:	78 33                	js     80105150 <sys_read+0x60>
8010511d:	83 ec 04             	sub    $0x4,%esp
80105120:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105123:	ff 75 f0             	pushl  -0x10(%ebp)
80105126:	50                   	push   %eax
80105127:	6a 01                	push   $0x1
80105129:	e8 f2 fd ff ff       	call   80104f20 <argptr>
8010512e:	83 c4 10             	add    $0x10,%esp
80105131:	85 c0                	test   %eax,%eax
80105133:	78 1b                	js     80105150 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105135:	83 ec 04             	sub    $0x4,%esp
80105138:	ff 75 f0             	pushl  -0x10(%ebp)
8010513b:	ff 75 f4             	pushl  -0xc(%ebp)
8010513e:	ff 75 ec             	pushl  -0x14(%ebp)
80105141:	e8 aa be ff ff       	call   80100ff0 <fileread>
80105146:	83 c4 10             	add    $0x10,%esp
}
80105149:	c9                   	leave  
8010514a:	c3                   	ret    
8010514b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010514f:	90                   	nop
80105150:	c9                   	leave  
    return -1;
80105151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105156:	c3                   	ret    
80105157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515e:	66 90                	xchg   %ax,%ax

80105160 <sys_write>:

int
sys_write(void)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105165:	31 c0                	xor    %eax,%eax
{
80105167:	89 e5                	mov    %esp,%ebp
80105169:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010516c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010516f:	e8 bc fe ff ff       	call   80105030 <argfd.constprop.0>
80105174:	85 c0                	test   %eax,%eax
80105176:	78 48                	js     801051c0 <sys_write+0x60>
80105178:	83 ec 08             	sub    $0x8,%esp
8010517b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010517e:	50                   	push   %eax
8010517f:	6a 02                	push   $0x2
80105181:	e8 4a fd ff ff       	call   80104ed0 <argint>
80105186:	83 c4 10             	add    $0x10,%esp
80105189:	85 c0                	test   %eax,%eax
8010518b:	78 33                	js     801051c0 <sys_write+0x60>
8010518d:	83 ec 04             	sub    $0x4,%esp
80105190:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105193:	ff 75 f0             	pushl  -0x10(%ebp)
80105196:	50                   	push   %eax
80105197:	6a 01                	push   $0x1
80105199:	e8 82 fd ff ff       	call   80104f20 <argptr>
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	85 c0                	test   %eax,%eax
801051a3:	78 1b                	js     801051c0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801051a5:	83 ec 04             	sub    $0x4,%esp
801051a8:	ff 75 f0             	pushl  -0x10(%ebp)
801051ab:	ff 75 f4             	pushl  -0xc(%ebp)
801051ae:	ff 75 ec             	pushl  -0x14(%ebp)
801051b1:	e8 da be ff ff       	call   80101090 <filewrite>
801051b6:	83 c4 10             	add    $0x10,%esp
}
801051b9:	c9                   	leave  
801051ba:	c3                   	ret    
801051bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051bf:	90                   	nop
801051c0:	c9                   	leave  
    return -1;
801051c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c6:	c3                   	ret    
801051c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <sys_close>:

int
sys_close(void)
{
801051d0:	f3 0f 1e fb          	endbr32 
801051d4:	55                   	push   %ebp
801051d5:	89 e5                	mov    %esp,%ebp
801051d7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801051da:	8d 55 f4             	lea    -0xc(%ebp),%edx
801051dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e0:	e8 4b fe ff ff       	call   80105030 <argfd.constprop.0>
801051e5:	85 c0                	test   %eax,%eax
801051e7:	78 27                	js     80105210 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801051e9:	e8 32 eb ff ff       	call   80103d20 <myproc>
801051ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801051f1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051f4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801051fb:	00 
  fileclose(f);
801051fc:	ff 75 f4             	pushl  -0xc(%ebp)
801051ff:	e8 bc bc ff ff       	call   80100ec0 <fileclose>
  return 0;
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	31 c0                	xor    %eax,%eax
}
80105209:	c9                   	leave  
8010520a:	c3                   	ret    
8010520b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010520f:	90                   	nop
80105210:	c9                   	leave  
    return -1;
80105211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105216:	c3                   	ret    
80105217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521e:	66 90                	xchg   %ax,%ax

80105220 <sys_fstat>:

int
sys_fstat(void)
{
80105220:	f3 0f 1e fb          	endbr32 
80105224:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105225:	31 c0                	xor    %eax,%eax
{
80105227:	89 e5                	mov    %esp,%ebp
80105229:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010522c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010522f:	e8 fc fd ff ff       	call   80105030 <argfd.constprop.0>
80105234:	85 c0                	test   %eax,%eax
80105236:	78 30                	js     80105268 <sys_fstat+0x48>
80105238:	83 ec 04             	sub    $0x4,%esp
8010523b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010523e:	6a 14                	push   $0x14
80105240:	50                   	push   %eax
80105241:	6a 01                	push   $0x1
80105243:	e8 d8 fc ff ff       	call   80104f20 <argptr>
80105248:	83 c4 10             	add    $0x10,%esp
8010524b:	85 c0                	test   %eax,%eax
8010524d:	78 19                	js     80105268 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
8010524f:	83 ec 08             	sub    $0x8,%esp
80105252:	ff 75 f4             	pushl  -0xc(%ebp)
80105255:	ff 75 f0             	pushl  -0x10(%ebp)
80105258:	e8 43 bd ff ff       	call   80100fa0 <filestat>
8010525d:	83 c4 10             	add    $0x10,%esp
}
80105260:	c9                   	leave  
80105261:	c3                   	ret    
80105262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105268:	c9                   	leave  
    return -1;
80105269:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010526e:	c3                   	ret    
8010526f:	90                   	nop

80105270 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105270:	f3 0f 1e fb          	endbr32 
80105274:	55                   	push   %ebp
80105275:	89 e5                	mov    %esp,%ebp
80105277:	57                   	push   %edi
80105278:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105279:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010527c:	53                   	push   %ebx
8010527d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105280:	50                   	push   %eax
80105281:	6a 00                	push   $0x0
80105283:	e8 f8 fc ff ff       	call   80104f80 <argstr>
80105288:	83 c4 10             	add    $0x10,%esp
8010528b:	85 c0                	test   %eax,%eax
8010528d:	0f 88 ff 00 00 00    	js     80105392 <sys_link+0x122>
80105293:	83 ec 08             	sub    $0x8,%esp
80105296:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105299:	50                   	push   %eax
8010529a:	6a 01                	push   $0x1
8010529c:	e8 df fc ff ff       	call   80104f80 <argstr>
801052a1:	83 c4 10             	add    $0x10,%esp
801052a4:	85 c0                	test   %eax,%eax
801052a6:	0f 88 e6 00 00 00    	js     80105392 <sys_link+0x122>
    return -1;

  begin_op();
801052ac:	e8 ff dd ff ff       	call   801030b0 <begin_op>
  if((ip = namei(old)) == 0){
801052b1:	83 ec 0c             	sub    $0xc,%esp
801052b4:	ff 75 d4             	pushl  -0x2c(%ebp)
801052b7:	e8 74 cd ff ff       	call   80102030 <namei>
801052bc:	83 c4 10             	add    $0x10,%esp
801052bf:	89 c3                	mov    %eax,%ebx
801052c1:	85 c0                	test   %eax,%eax
801052c3:	0f 84 e8 00 00 00    	je     801053b1 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
801052c9:	83 ec 0c             	sub    $0xc,%esp
801052cc:	50                   	push   %eax
801052cd:	e8 8e c4 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052da:	0f 84 b9 00 00 00    	je     80105399 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801052e0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801052e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801052e8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801052eb:	53                   	push   %ebx
801052ec:	e8 af c3 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801052f1:	89 1c 24             	mov    %ebx,(%esp)
801052f4:	e8 47 c5 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801052f9:	58                   	pop    %eax
801052fa:	5a                   	pop    %edx
801052fb:	57                   	push   %edi
801052fc:	ff 75 d0             	pushl  -0x30(%ebp)
801052ff:	e8 4c cd ff ff       	call   80102050 <nameiparent>
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	89 c6                	mov    %eax,%esi
80105309:	85 c0                	test   %eax,%eax
8010530b:	74 5f                	je     8010536c <sys_link+0xfc>
    goto bad;
  ilock(dp);
8010530d:	83 ec 0c             	sub    $0xc,%esp
80105310:	50                   	push   %eax
80105311:	e8 4a c4 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105316:	8b 03                	mov    (%ebx),%eax
80105318:	83 c4 10             	add    $0x10,%esp
8010531b:	39 06                	cmp    %eax,(%esi)
8010531d:	75 41                	jne    80105360 <sys_link+0xf0>
8010531f:	83 ec 04             	sub    $0x4,%esp
80105322:	ff 73 04             	pushl  0x4(%ebx)
80105325:	57                   	push   %edi
80105326:	56                   	push   %esi
80105327:	e8 44 cc ff ff       	call   80101f70 <dirlink>
8010532c:	83 c4 10             	add    $0x10,%esp
8010532f:	85 c0                	test   %eax,%eax
80105331:	78 2d                	js     80105360 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105333:	83 ec 0c             	sub    $0xc,%esp
80105336:	56                   	push   %esi
80105337:	e8 c4 c6 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010533c:	89 1c 24             	mov    %ebx,(%esp)
8010533f:	e8 4c c5 ff ff       	call   80101890 <iput>

  end_op();
80105344:	e8 d7 dd ff ff       	call   80103120 <end_op>

  return 0;
80105349:	83 c4 10             	add    $0x10,%esp
8010534c:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010534e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105351:	5b                   	pop    %ebx
80105352:	5e                   	pop    %esi
80105353:	5f                   	pop    %edi
80105354:	5d                   	pop    %ebp
80105355:	c3                   	ret    
80105356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	56                   	push   %esi
80105364:	e8 97 c6 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105369:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	53                   	push   %ebx
80105370:	e8 eb c3 ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105375:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010537a:	89 1c 24             	mov    %ebx,(%esp)
8010537d:	e8 1e c3 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105382:	89 1c 24             	mov    %ebx,(%esp)
80105385:	e8 76 c6 ff ff       	call   80101a00 <iunlockput>
  end_op();
8010538a:	e8 91 dd ff ff       	call   80103120 <end_op>
  return -1;
8010538f:	83 c4 10             	add    $0x10,%esp
80105392:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105397:	eb b5                	jmp    8010534e <sys_link+0xde>
    iunlockput(ip);
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	53                   	push   %ebx
8010539d:	e8 5e c6 ff ff       	call   80101a00 <iunlockput>
    end_op();
801053a2:	e8 79 dd ff ff       	call   80103120 <end_op>
    return -1;
801053a7:	83 c4 10             	add    $0x10,%esp
801053aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053af:	eb 9d                	jmp    8010534e <sys_link+0xde>
    end_op();
801053b1:	e8 6a dd ff ff       	call   80103120 <end_op>
    return -1;
801053b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053bb:	eb 91                	jmp    8010534e <sys_link+0xde>
801053bd:	8d 76 00             	lea    0x0(%esi),%esi

801053c0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801053c0:	f3 0f 1e fb          	endbr32 
801053c4:	55                   	push   %ebp
801053c5:	89 e5                	mov    %esp,%ebp
801053c7:	57                   	push   %edi
801053c8:	56                   	push   %esi
801053c9:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053cc:	53                   	push   %ebx
801053cd:	bb 20 00 00 00       	mov    $0x20,%ebx
801053d2:	83 ec 1c             	sub    $0x1c,%esp
801053d5:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053d8:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801053dc:	77 0a                	ja     801053e8 <isdirempty+0x28>
801053de:	eb 30                	jmp    80105410 <isdirempty+0x50>
801053e0:	83 c3 10             	add    $0x10,%ebx
801053e3:	39 5e 58             	cmp    %ebx,0x58(%esi)
801053e6:	76 28                	jbe    80105410 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053e8:	6a 10                	push   $0x10
801053ea:	53                   	push   %ebx
801053eb:	57                   	push   %edi
801053ec:	56                   	push   %esi
801053ed:	e8 6e c6 ff ff       	call   80101a60 <readi>
801053f2:	83 c4 10             	add    $0x10,%esp
801053f5:	83 f8 10             	cmp    $0x10,%eax
801053f8:	75 23                	jne    8010541d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801053fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053ff:	74 df                	je     801053e0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105401:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105404:	31 c0                	xor    %eax,%eax
}
80105406:	5b                   	pop    %ebx
80105407:	5e                   	pop    %esi
80105408:	5f                   	pop    %edi
80105409:	5d                   	pop    %ebp
8010540a:	c3                   	ret    
8010540b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010540f:	90                   	nop
80105410:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105413:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105418:	5b                   	pop    %ebx
80105419:	5e                   	pop    %esi
8010541a:	5f                   	pop    %edi
8010541b:	5d                   	pop    %ebp
8010541c:	c3                   	ret    
      panic("isdirempty: readi");
8010541d:	83 ec 0c             	sub    $0xc,%esp
80105420:	68 f8 85 10 80       	push   $0x801085f8
80105425:	e8 66 af ff ff       	call   80100390 <panic>
8010542a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105430 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105430:	f3 0f 1e fb          	endbr32 
80105434:	55                   	push   %ebp
80105435:	89 e5                	mov    %esp,%ebp
80105437:	57                   	push   %edi
80105438:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105439:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010543c:	53                   	push   %ebx
8010543d:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105440:	50                   	push   %eax
80105441:	6a 00                	push   $0x0
80105443:	e8 38 fb ff ff       	call   80104f80 <argstr>
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	85 c0                	test   %eax,%eax
8010544d:	0f 88 5d 01 00 00    	js     801055b0 <sys_unlink+0x180>
    return -1;

  begin_op();
80105453:	e8 58 dc ff ff       	call   801030b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105458:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010545b:	83 ec 08             	sub    $0x8,%esp
8010545e:	53                   	push   %ebx
8010545f:	ff 75 c0             	pushl  -0x40(%ebp)
80105462:	e8 e9 cb ff ff       	call   80102050 <nameiparent>
80105467:	83 c4 10             	add    $0x10,%esp
8010546a:	89 c6                	mov    %eax,%esi
8010546c:	85 c0                	test   %eax,%eax
8010546e:	0f 84 43 01 00 00    	je     801055b7 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
80105474:	83 ec 0c             	sub    $0xc,%esp
80105477:	50                   	push   %eax
80105478:	e8 e3 c2 ff ff       	call   80101760 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010547d:	58                   	pop    %eax
8010547e:	5a                   	pop    %edx
8010547f:	68 1d 7f 10 80       	push   $0x80107f1d
80105484:	53                   	push   %ebx
80105485:	e8 06 c8 ff ff       	call   80101c90 <namecmp>
8010548a:	83 c4 10             	add    $0x10,%esp
8010548d:	85 c0                	test   %eax,%eax
8010548f:	0f 84 db 00 00 00    	je     80105570 <sys_unlink+0x140>
80105495:	83 ec 08             	sub    $0x8,%esp
80105498:	68 1c 7f 10 80       	push   $0x80107f1c
8010549d:	53                   	push   %ebx
8010549e:	e8 ed c7 ff ff       	call   80101c90 <namecmp>
801054a3:	83 c4 10             	add    $0x10,%esp
801054a6:	85 c0                	test   %eax,%eax
801054a8:	0f 84 c2 00 00 00    	je     80105570 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801054ae:	83 ec 04             	sub    $0x4,%esp
801054b1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801054b4:	50                   	push   %eax
801054b5:	53                   	push   %ebx
801054b6:	56                   	push   %esi
801054b7:	e8 f4 c7 ff ff       	call   80101cb0 <dirlookup>
801054bc:	83 c4 10             	add    $0x10,%esp
801054bf:	89 c3                	mov    %eax,%ebx
801054c1:	85 c0                	test   %eax,%eax
801054c3:	0f 84 a7 00 00 00    	je     80105570 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
801054c9:	83 ec 0c             	sub    $0xc,%esp
801054cc:	50                   	push   %eax
801054cd:	e8 8e c2 ff ff       	call   80101760 <ilock>

  if(ip->nlink < 1)
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801054da:	0f 8e f3 00 00 00    	jle    801055d3 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801054e0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054e5:	74 69                	je     80105550 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801054e7:	83 ec 04             	sub    $0x4,%esp
801054ea:	8d 7d d8             	lea    -0x28(%ebp),%edi
801054ed:	6a 10                	push   $0x10
801054ef:	6a 00                	push   $0x0
801054f1:	57                   	push   %edi
801054f2:	e8 f9 f6 ff ff       	call   80104bf0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054f7:	6a 10                	push   $0x10
801054f9:	ff 75 c4             	pushl  -0x3c(%ebp)
801054fc:	57                   	push   %edi
801054fd:	56                   	push   %esi
801054fe:	e8 5d c6 ff ff       	call   80101b60 <writei>
80105503:	83 c4 20             	add    $0x20,%esp
80105506:	83 f8 10             	cmp    $0x10,%eax
80105509:	0f 85 b7 00 00 00    	jne    801055c6 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010550f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105514:	74 7a                	je     80105590 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105516:	83 ec 0c             	sub    $0xc,%esp
80105519:	56                   	push   %esi
8010551a:	e8 e1 c4 ff ff       	call   80101a00 <iunlockput>

  ip->nlink--;
8010551f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105524:	89 1c 24             	mov    %ebx,(%esp)
80105527:	e8 74 c1 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
8010552c:	89 1c 24             	mov    %ebx,(%esp)
8010552f:	e8 cc c4 ff ff       	call   80101a00 <iunlockput>

  end_op();
80105534:	e8 e7 db ff ff       	call   80103120 <end_op>

  return 0;
80105539:	83 c4 10             	add    $0x10,%esp
8010553c:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010553e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105541:	5b                   	pop    %ebx
80105542:	5e                   	pop    %esi
80105543:	5f                   	pop    %edi
80105544:	5d                   	pop    %ebp
80105545:	c3                   	ret    
80105546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	53                   	push   %ebx
80105554:	e8 67 fe ff ff       	call   801053c0 <isdirempty>
80105559:	83 c4 10             	add    $0x10,%esp
8010555c:	85 c0                	test   %eax,%eax
8010555e:	75 87                	jne    801054e7 <sys_unlink+0xb7>
    iunlockput(ip);
80105560:	83 ec 0c             	sub    $0xc,%esp
80105563:	53                   	push   %ebx
80105564:	e8 97 c4 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105569:	83 c4 10             	add    $0x10,%esp
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	56                   	push   %esi
80105574:	e8 87 c4 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105579:	e8 a2 db ff ff       	call   80103120 <end_op>
  return -1;
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105586:	eb b6                	jmp    8010553e <sys_unlink+0x10e>
80105588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558f:	90                   	nop
    iupdate(dp);
80105590:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105593:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105598:	56                   	push   %esi
80105599:	e8 02 c1 ff ff       	call   801016a0 <iupdate>
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	e9 70 ff ff ff       	jmp    80105516 <sys_unlink+0xe6>
801055a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b5:	eb 87                	jmp    8010553e <sys_unlink+0x10e>
    end_op();
801055b7:	e8 64 db ff ff       	call   80103120 <end_op>
    return -1;
801055bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055c1:	e9 78 ff ff ff       	jmp    8010553e <sys_unlink+0x10e>
    panic("unlink: writei");
801055c6:	83 ec 0c             	sub    $0xc,%esp
801055c9:	68 31 7f 10 80       	push   $0x80107f31
801055ce:	e8 bd ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801055d3:	83 ec 0c             	sub    $0xc,%esp
801055d6:	68 1f 7f 10 80       	push   $0x80107f1f
801055db:	e8 b0 ad ff ff       	call   80100390 <panic>

801055e0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801055e0:	f3 0f 1e fb          	endbr32 
801055e4:	55                   	push   %ebp
801055e5:	89 e5                	mov    %esp,%ebp
801055e7:	57                   	push   %edi
801055e8:	56                   	push   %esi
801055e9:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801055ea:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
801055ed:	83 ec 34             	sub    $0x34,%esp
801055f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801055f3:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
801055f6:	53                   	push   %ebx
{
801055f7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801055fa:	ff 75 08             	pushl  0x8(%ebp)
{
801055fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105600:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105603:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105606:	e8 45 ca ff ff       	call   80102050 <nameiparent>
8010560b:	83 c4 10             	add    $0x10,%esp
8010560e:	85 c0                	test   %eax,%eax
80105610:	0f 84 3a 01 00 00    	je     80105750 <create+0x170>
    return 0;
  ilock(dp);
80105616:	83 ec 0c             	sub    $0xc,%esp
80105619:	89 c6                	mov    %eax,%esi
8010561b:	50                   	push   %eax
8010561c:	e8 3f c1 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105621:	83 c4 0c             	add    $0xc,%esp
80105624:	6a 00                	push   $0x0
80105626:	53                   	push   %ebx
80105627:	56                   	push   %esi
80105628:	e8 83 c6 ff ff       	call   80101cb0 <dirlookup>
8010562d:	83 c4 10             	add    $0x10,%esp
80105630:	89 c7                	mov    %eax,%edi
80105632:	85 c0                	test   %eax,%eax
80105634:	74 4a                	je     80105680 <create+0xa0>
    iunlockput(dp);
80105636:	83 ec 0c             	sub    $0xc,%esp
80105639:	56                   	push   %esi
8010563a:	e8 c1 c3 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
8010563f:	89 3c 24             	mov    %edi,(%esp)
80105642:	e8 19 c1 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105647:	83 c4 10             	add    $0x10,%esp
8010564a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010564f:	75 17                	jne    80105668 <create+0x88>
80105651:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105656:	75 10                	jne    80105668 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105658:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010565b:	89 f8                	mov    %edi,%eax
8010565d:	5b                   	pop    %ebx
8010565e:	5e                   	pop    %esi
8010565f:	5f                   	pop    %edi
80105660:	5d                   	pop    %ebp
80105661:	c3                   	ret    
80105662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105668:	83 ec 0c             	sub    $0xc,%esp
8010566b:	57                   	push   %edi
    return 0;
8010566c:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
8010566e:	e8 8d c3 ff ff       	call   80101a00 <iunlockput>
    return 0;
80105673:	83 c4 10             	add    $0x10,%esp
}
80105676:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105679:	89 f8                	mov    %edi,%eax
8010567b:	5b                   	pop    %ebx
8010567c:	5e                   	pop    %esi
8010567d:	5f                   	pop    %edi
8010567e:	5d                   	pop    %ebp
8010567f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105680:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105684:	83 ec 08             	sub    $0x8,%esp
80105687:	50                   	push   %eax
80105688:	ff 36                	pushl  (%esi)
8010568a:	e8 51 bf ff ff       	call   801015e0 <ialloc>
8010568f:	83 c4 10             	add    $0x10,%esp
80105692:	89 c7                	mov    %eax,%edi
80105694:	85 c0                	test   %eax,%eax
80105696:	0f 84 cd 00 00 00    	je     80105769 <create+0x189>
  ilock(ip);
8010569c:	83 ec 0c             	sub    $0xc,%esp
8010569f:	50                   	push   %eax
801056a0:	e8 bb c0 ff ff       	call   80101760 <ilock>
  ip->major = major;
801056a5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801056a9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801056ad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801056b1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801056b5:	b8 01 00 00 00       	mov    $0x1,%eax
801056ba:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801056be:	89 3c 24             	mov    %edi,(%esp)
801056c1:	e8 da bf ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801056c6:	83 c4 10             	add    $0x10,%esp
801056c9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801056ce:	74 30                	je     80105700 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801056d0:	83 ec 04             	sub    $0x4,%esp
801056d3:	ff 77 04             	pushl  0x4(%edi)
801056d6:	53                   	push   %ebx
801056d7:	56                   	push   %esi
801056d8:	e8 93 c8 ff ff       	call   80101f70 <dirlink>
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	85 c0                	test   %eax,%eax
801056e2:	78 78                	js     8010575c <create+0x17c>
  iunlockput(dp);
801056e4:	83 ec 0c             	sub    $0xc,%esp
801056e7:	56                   	push   %esi
801056e8:	e8 13 c3 ff ff       	call   80101a00 <iunlockput>
  return ip;
801056ed:	83 c4 10             	add    $0x10,%esp
}
801056f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056f3:	89 f8                	mov    %edi,%eax
801056f5:	5b                   	pop    %ebx
801056f6:	5e                   	pop    %esi
801056f7:	5f                   	pop    %edi
801056f8:	5d                   	pop    %ebp
801056f9:	c3                   	ret    
801056fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105700:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105703:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105708:	56                   	push   %esi
80105709:	e8 92 bf ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010570e:	83 c4 0c             	add    $0xc,%esp
80105711:	ff 77 04             	pushl  0x4(%edi)
80105714:	68 1d 7f 10 80       	push   $0x80107f1d
80105719:	57                   	push   %edi
8010571a:	e8 51 c8 ff ff       	call   80101f70 <dirlink>
8010571f:	83 c4 10             	add    $0x10,%esp
80105722:	85 c0                	test   %eax,%eax
80105724:	78 18                	js     8010573e <create+0x15e>
80105726:	83 ec 04             	sub    $0x4,%esp
80105729:	ff 76 04             	pushl  0x4(%esi)
8010572c:	68 1c 7f 10 80       	push   $0x80107f1c
80105731:	57                   	push   %edi
80105732:	e8 39 c8 ff ff       	call   80101f70 <dirlink>
80105737:	83 c4 10             	add    $0x10,%esp
8010573a:	85 c0                	test   %eax,%eax
8010573c:	79 92                	jns    801056d0 <create+0xf0>
      panic("create dots");
8010573e:	83 ec 0c             	sub    $0xc,%esp
80105741:	68 19 86 10 80       	push   $0x80108619
80105746:	e8 45 ac ff ff       	call   80100390 <panic>
8010574b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010574f:	90                   	nop
}
80105750:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105753:	31 ff                	xor    %edi,%edi
}
80105755:	5b                   	pop    %ebx
80105756:	89 f8                	mov    %edi,%eax
80105758:	5e                   	pop    %esi
80105759:	5f                   	pop    %edi
8010575a:	5d                   	pop    %ebp
8010575b:	c3                   	ret    
    panic("create: dirlink");
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	68 25 86 10 80       	push   $0x80108625
80105764:	e8 27 ac ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105769:	83 ec 0c             	sub    $0xc,%esp
8010576c:	68 0a 86 10 80       	push   $0x8010860a
80105771:	e8 1a ac ff ff       	call   80100390 <panic>
80105776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577d:	8d 76 00             	lea    0x0(%esi),%esi

80105780 <sys_open>:

int
sys_open(void)
{
80105780:	f3 0f 1e fb          	endbr32 
80105784:	55                   	push   %ebp
80105785:	89 e5                	mov    %esp,%ebp
80105787:	57                   	push   %edi
80105788:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105789:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010578c:	53                   	push   %ebx
8010578d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105790:	50                   	push   %eax
80105791:	6a 00                	push   $0x0
80105793:	e8 e8 f7 ff ff       	call   80104f80 <argstr>
80105798:	83 c4 10             	add    $0x10,%esp
8010579b:	85 c0                	test   %eax,%eax
8010579d:	0f 88 8a 00 00 00    	js     8010582d <sys_open+0xad>
801057a3:	83 ec 08             	sub    $0x8,%esp
801057a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057a9:	50                   	push   %eax
801057aa:	6a 01                	push   $0x1
801057ac:	e8 1f f7 ff ff       	call   80104ed0 <argint>
801057b1:	83 c4 10             	add    $0x10,%esp
801057b4:	85 c0                	test   %eax,%eax
801057b6:	78 75                	js     8010582d <sys_open+0xad>
    return -1;

  begin_op();
801057b8:	e8 f3 d8 ff ff       	call   801030b0 <begin_op>

  if(omode & O_CREATE){
801057bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801057c1:	75 75                	jne    80105838 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801057c3:	83 ec 0c             	sub    $0xc,%esp
801057c6:	ff 75 e0             	pushl  -0x20(%ebp)
801057c9:	e8 62 c8 ff ff       	call   80102030 <namei>
801057ce:	83 c4 10             	add    $0x10,%esp
801057d1:	89 c6                	mov    %eax,%esi
801057d3:	85 c0                	test   %eax,%eax
801057d5:	74 78                	je     8010584f <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
801057d7:	83 ec 0c             	sub    $0xc,%esp
801057da:	50                   	push   %eax
801057db:	e8 80 bf ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057e0:	83 c4 10             	add    $0x10,%esp
801057e3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057e8:	0f 84 ba 00 00 00    	je     801058a8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801057ee:	e8 0d b6 ff ff       	call   80100e00 <filealloc>
801057f3:	89 c7                	mov    %eax,%edi
801057f5:	85 c0                	test   %eax,%eax
801057f7:	74 23                	je     8010581c <sys_open+0x9c>
  struct proc *curproc = myproc();
801057f9:	e8 22 e5 ff ff       	call   80103d20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057fe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105800:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105804:	85 d2                	test   %edx,%edx
80105806:	74 58                	je     80105860 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105808:	83 c3 01             	add    $0x1,%ebx
8010580b:	83 fb 10             	cmp    $0x10,%ebx
8010580e:	75 f0                	jne    80105800 <sys_open+0x80>
    if(f)
      fileclose(f);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	57                   	push   %edi
80105814:	e8 a7 b6 ff ff       	call   80100ec0 <fileclose>
80105819:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010581c:	83 ec 0c             	sub    $0xc,%esp
8010581f:	56                   	push   %esi
80105820:	e8 db c1 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105825:	e8 f6 d8 ff ff       	call   80103120 <end_op>
    return -1;
8010582a:	83 c4 10             	add    $0x10,%esp
8010582d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105832:	eb 65                	jmp    80105899 <sys_open+0x119>
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105838:	6a 00                	push   $0x0
8010583a:	6a 00                	push   $0x0
8010583c:	6a 02                	push   $0x2
8010583e:	ff 75 e0             	pushl  -0x20(%ebp)
80105841:	e8 9a fd ff ff       	call   801055e0 <create>
    if(ip == 0){
80105846:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105849:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010584b:	85 c0                	test   %eax,%eax
8010584d:	75 9f                	jne    801057ee <sys_open+0x6e>
      end_op();
8010584f:	e8 cc d8 ff ff       	call   80103120 <end_op>
      return -1;
80105854:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105859:	eb 3e                	jmp    80105899 <sys_open+0x119>
8010585b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010585f:	90                   	nop
  }
  iunlock(ip);
80105860:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105863:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105867:	56                   	push   %esi
80105868:	e8 d3 bf ff ff       	call   80101840 <iunlock>
  end_op();
8010586d:	e8 ae d8 ff ff       	call   80103120 <end_op>

  f->type = FD_INODE;
80105872:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105878:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010587b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010587e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105881:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105883:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010588a:	f7 d0                	not    %eax
8010588c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010588f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105892:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105895:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105899:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010589c:	89 d8                	mov    %ebx,%eax
8010589e:	5b                   	pop    %ebx
8010589f:	5e                   	pop    %esi
801058a0:	5f                   	pop    %edi
801058a1:	5d                   	pop    %ebp
801058a2:	c3                   	ret    
801058a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058a7:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801058a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801058ab:	85 c9                	test   %ecx,%ecx
801058ad:	0f 84 3b ff ff ff    	je     801057ee <sys_open+0x6e>
801058b3:	e9 64 ff ff ff       	jmp    8010581c <sys_open+0x9c>
801058b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058bf:	90                   	nop

801058c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801058c0:	f3 0f 1e fb          	endbr32 
801058c4:	55                   	push   %ebp
801058c5:	89 e5                	mov    %esp,%ebp
801058c7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801058ca:	e8 e1 d7 ff ff       	call   801030b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801058cf:	83 ec 08             	sub    $0x8,%esp
801058d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d5:	50                   	push   %eax
801058d6:	6a 00                	push   $0x0
801058d8:	e8 a3 f6 ff ff       	call   80104f80 <argstr>
801058dd:	83 c4 10             	add    $0x10,%esp
801058e0:	85 c0                	test   %eax,%eax
801058e2:	78 2c                	js     80105910 <sys_mkdir+0x50>
801058e4:	6a 00                	push   $0x0
801058e6:	6a 00                	push   $0x0
801058e8:	6a 01                	push   $0x1
801058ea:	ff 75 f4             	pushl  -0xc(%ebp)
801058ed:	e8 ee fc ff ff       	call   801055e0 <create>
801058f2:	83 c4 10             	add    $0x10,%esp
801058f5:	85 c0                	test   %eax,%eax
801058f7:	74 17                	je     80105910 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058f9:	83 ec 0c             	sub    $0xc,%esp
801058fc:	50                   	push   %eax
801058fd:	e8 fe c0 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105902:	e8 19 d8 ff ff       	call   80103120 <end_op>
  return 0;
80105907:	83 c4 10             	add    $0x10,%esp
8010590a:	31 c0                	xor    %eax,%eax
}
8010590c:	c9                   	leave  
8010590d:	c3                   	ret    
8010590e:	66 90                	xchg   %ax,%ax
    end_op();
80105910:	e8 0b d8 ff ff       	call   80103120 <end_op>
    return -1;
80105915:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010591a:	c9                   	leave  
8010591b:	c3                   	ret    
8010591c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105920 <sys_mknod>:

int
sys_mknod(void)
{
80105920:	f3 0f 1e fb          	endbr32 
80105924:	55                   	push   %ebp
80105925:	89 e5                	mov    %esp,%ebp
80105927:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010592a:	e8 81 d7 ff ff       	call   801030b0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010592f:	83 ec 08             	sub    $0x8,%esp
80105932:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105935:	50                   	push   %eax
80105936:	6a 00                	push   $0x0
80105938:	e8 43 f6 ff ff       	call   80104f80 <argstr>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	78 5c                	js     801059a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105944:	83 ec 08             	sub    $0x8,%esp
80105947:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010594a:	50                   	push   %eax
8010594b:	6a 01                	push   $0x1
8010594d:	e8 7e f5 ff ff       	call   80104ed0 <argint>
  if((argstr(0, &path)) < 0 ||
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	78 47                	js     801059a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105959:	83 ec 08             	sub    $0x8,%esp
8010595c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010595f:	50                   	push   %eax
80105960:	6a 02                	push   $0x2
80105962:	e8 69 f5 ff ff       	call   80104ed0 <argint>
     argint(1, &major) < 0 ||
80105967:	83 c4 10             	add    $0x10,%esp
8010596a:	85 c0                	test   %eax,%eax
8010596c:	78 32                	js     801059a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010596e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105972:	50                   	push   %eax
80105973:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105977:	50                   	push   %eax
80105978:	6a 03                	push   $0x3
8010597a:	ff 75 ec             	pushl  -0x14(%ebp)
8010597d:	e8 5e fc ff ff       	call   801055e0 <create>
     argint(2, &minor) < 0 ||
80105982:	83 c4 10             	add    $0x10,%esp
80105985:	85 c0                	test   %eax,%eax
80105987:	74 17                	je     801059a0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105989:	83 ec 0c             	sub    $0xc,%esp
8010598c:	50                   	push   %eax
8010598d:	e8 6e c0 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105992:	e8 89 d7 ff ff       	call   80103120 <end_op>
  return 0;
80105997:	83 c4 10             	add    $0x10,%esp
8010599a:	31 c0                	xor    %eax,%eax
}
8010599c:	c9                   	leave  
8010599d:	c3                   	ret    
8010599e:	66 90                	xchg   %ax,%ax
    end_op();
801059a0:	e8 7b d7 ff ff       	call   80103120 <end_op>
    return -1;
801059a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059aa:	c9                   	leave  
801059ab:	c3                   	ret    
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_chdir>:

int
sys_chdir(void)
{
801059b0:	f3 0f 1e fb          	endbr32 
801059b4:	55                   	push   %ebp
801059b5:	89 e5                	mov    %esp,%ebp
801059b7:	56                   	push   %esi
801059b8:	53                   	push   %ebx
801059b9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801059bc:	e8 5f e3 ff ff       	call   80103d20 <myproc>
801059c1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801059c3:	e8 e8 d6 ff ff       	call   801030b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801059c8:	83 ec 08             	sub    $0x8,%esp
801059cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ce:	50                   	push   %eax
801059cf:	6a 00                	push   $0x0
801059d1:	e8 aa f5 ff ff       	call   80104f80 <argstr>
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	85 c0                	test   %eax,%eax
801059db:	78 73                	js     80105a50 <sys_chdir+0xa0>
801059dd:	83 ec 0c             	sub    $0xc,%esp
801059e0:	ff 75 f4             	pushl  -0xc(%ebp)
801059e3:	e8 48 c6 ff ff       	call   80102030 <namei>
801059e8:	83 c4 10             	add    $0x10,%esp
801059eb:	89 c3                	mov    %eax,%ebx
801059ed:	85 c0                	test   %eax,%eax
801059ef:	74 5f                	je     80105a50 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801059f1:	83 ec 0c             	sub    $0xc,%esp
801059f4:	50                   	push   %eax
801059f5:	e8 66 bd ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
801059fa:	83 c4 10             	add    $0x10,%esp
801059fd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a02:	75 2c                	jne    80105a30 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a04:	83 ec 0c             	sub    $0xc,%esp
80105a07:	53                   	push   %ebx
80105a08:	e8 33 be ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105a0d:	58                   	pop    %eax
80105a0e:	ff 76 68             	pushl  0x68(%esi)
80105a11:	e8 7a be ff ff       	call   80101890 <iput>
  end_op();
80105a16:	e8 05 d7 ff ff       	call   80103120 <end_op>
  curproc->cwd = ip;
80105a1b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	31 c0                	xor    %eax,%eax
}
80105a23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a26:	5b                   	pop    %ebx
80105a27:	5e                   	pop    %esi
80105a28:	5d                   	pop    %ebp
80105a29:	c3                   	ret    
80105a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	53                   	push   %ebx
80105a34:	e8 c7 bf ff ff       	call   80101a00 <iunlockput>
    end_op();
80105a39:	e8 e2 d6 ff ff       	call   80103120 <end_op>
    return -1;
80105a3e:	83 c4 10             	add    $0x10,%esp
80105a41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a46:	eb db                	jmp    80105a23 <sys_chdir+0x73>
80105a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4f:	90                   	nop
    end_op();
80105a50:	e8 cb d6 ff ff       	call   80103120 <end_op>
    return -1;
80105a55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a5a:	eb c7                	jmp    80105a23 <sys_chdir+0x73>
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_exec>:

int
sys_exec(void)
{
80105a60:	f3 0f 1e fb          	endbr32 
80105a64:	55                   	push   %ebp
80105a65:	89 e5                	mov    %esp,%ebp
80105a67:	57                   	push   %edi
80105a68:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a69:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a6f:	53                   	push   %ebx
80105a70:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a76:	50                   	push   %eax
80105a77:	6a 00                	push   $0x0
80105a79:	e8 02 f5 ff ff       	call   80104f80 <argstr>
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
80105a83:	0f 88 8b 00 00 00    	js     80105b14 <sys_exec+0xb4>
80105a89:	83 ec 08             	sub    $0x8,%esp
80105a8c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a92:	50                   	push   %eax
80105a93:	6a 01                	push   $0x1
80105a95:	e8 36 f4 ff ff       	call   80104ed0 <argint>
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	85 c0                	test   %eax,%eax
80105a9f:	78 73                	js     80105b14 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105aa1:	83 ec 04             	sub    $0x4,%esp
80105aa4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105aaa:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105aac:	68 80 00 00 00       	push   $0x80
80105ab1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105ab7:	6a 00                	push   $0x0
80105ab9:	50                   	push   %eax
80105aba:	e8 31 f1 ff ff       	call   80104bf0 <memset>
80105abf:	83 c4 10             	add    $0x10,%esp
80105ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105ac8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105ace:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105ad5:	83 ec 08             	sub    $0x8,%esp
80105ad8:	57                   	push   %edi
80105ad9:	01 f0                	add    %esi,%eax
80105adb:	50                   	push   %eax
80105adc:	e8 4f f3 ff ff       	call   80104e30 <fetchint>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	78 2c                	js     80105b14 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105ae8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105aee:	85 c0                	test   %eax,%eax
80105af0:	74 36                	je     80105b28 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105af2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105af8:	83 ec 08             	sub    $0x8,%esp
80105afb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105afe:	52                   	push   %edx
80105aff:	50                   	push   %eax
80105b00:	e8 6b f3 ff ff       	call   80104e70 <fetchstr>
80105b05:	83 c4 10             	add    $0x10,%esp
80105b08:	85 c0                	test   %eax,%eax
80105b0a:	78 08                	js     80105b14 <sys_exec+0xb4>
  for(i=0;; i++){
80105b0c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105b0f:	83 fb 20             	cmp    $0x20,%ebx
80105b12:	75 b4                	jne    80105ac8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105b14:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b1c:	5b                   	pop    %ebx
80105b1d:	5e                   	pop    %esi
80105b1e:	5f                   	pop    %edi
80105b1f:	5d                   	pop    %ebp
80105b20:	c3                   	ret    
80105b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105b28:	83 ec 08             	sub    $0x8,%esp
80105b2b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105b31:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b38:	00 00 00 00 
  return exec(path, argv);
80105b3c:	50                   	push   %eax
80105b3d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105b43:	e8 38 af ff ff       	call   80100a80 <exec>
80105b48:	83 c4 10             	add    $0x10,%esp
}
80105b4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b4e:	5b                   	pop    %ebx
80105b4f:	5e                   	pop    %esi
80105b50:	5f                   	pop    %edi
80105b51:	5d                   	pop    %ebp
80105b52:	c3                   	ret    
80105b53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b60 <sys_pipe>:

int
sys_pipe(void)
{
80105b60:	f3 0f 1e fb          	endbr32 
80105b64:	55                   	push   %ebp
80105b65:	89 e5                	mov    %esp,%ebp
80105b67:	57                   	push   %edi
80105b68:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b69:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b6c:	53                   	push   %ebx
80105b6d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b70:	6a 08                	push   $0x8
80105b72:	50                   	push   %eax
80105b73:	6a 00                	push   $0x0
80105b75:	e8 a6 f3 ff ff       	call   80104f20 <argptr>
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	78 4e                	js     80105bcf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b81:	83 ec 08             	sub    $0x8,%esp
80105b84:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b87:	50                   	push   %eax
80105b88:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b8b:	50                   	push   %eax
80105b8c:	e8 df db ff ff       	call   80103770 <pipealloc>
80105b91:	83 c4 10             	add    $0x10,%esp
80105b94:	85 c0                	test   %eax,%eax
80105b96:	78 37                	js     80105bcf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b98:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b9b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b9d:	e8 7e e1 ff ff       	call   80103d20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105ba8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105bac:	85 f6                	test   %esi,%esi
80105bae:	74 30                	je     80105be0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105bb0:	83 c3 01             	add    $0x1,%ebx
80105bb3:	83 fb 10             	cmp    $0x10,%ebx
80105bb6:	75 f0                	jne    80105ba8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105bb8:	83 ec 0c             	sub    $0xc,%esp
80105bbb:	ff 75 e0             	pushl  -0x20(%ebp)
80105bbe:	e8 fd b2 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105bc3:	58                   	pop    %eax
80105bc4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105bc7:	e8 f4 b2 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105bcc:	83 c4 10             	add    $0x10,%esp
80105bcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd4:	eb 5b                	jmp    80105c31 <sys_pipe+0xd1>
80105bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105be0:	8d 73 08             	lea    0x8(%ebx),%esi
80105be3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105be7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105bea:	e8 31 e1 ff ff       	call   80103d20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105bef:	31 d2                	xor    %edx,%edx
80105bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105bf8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105bfc:	85 c9                	test   %ecx,%ecx
80105bfe:	74 20                	je     80105c20 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105c00:	83 c2 01             	add    $0x1,%edx
80105c03:	83 fa 10             	cmp    $0x10,%edx
80105c06:	75 f0                	jne    80105bf8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105c08:	e8 13 e1 ff ff       	call   80103d20 <myproc>
80105c0d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c14:	00 
80105c15:	eb a1                	jmp    80105bb8 <sys_pipe+0x58>
80105c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105c20:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105c24:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c27:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c2c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c2f:	31 c0                	xor    %eax,%eax
}
80105c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c34:	5b                   	pop    %ebx
80105c35:	5e                   	pop    %esi
80105c36:	5f                   	pop    %edi
80105c37:	5d                   	pop    %ebp
80105c38:	c3                   	ret    
80105c39:	66 90                	xchg   %ax,%ax
80105c3b:	66 90                	xchg   %ax,%ax
80105c3d:	66 90                	xchg   %ax,%ax
80105c3f:	90                   	nop

80105c40 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105c40:	f3 0f 1e fb          	endbr32 
  return fork();
80105c44:	e9 87 e2 ff ff       	jmp    80103ed0 <fork>
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c50 <sys_exit>:
}

int
sys_exit(void)
{
80105c50:	f3 0f 1e fb          	endbr32 
80105c54:	55                   	push   %ebp
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c5a:	e8 11 e5 ff ff       	call   80104170 <exit>
  return 0;  // not reached
}
80105c5f:	31 c0                	xor    %eax,%eax
80105c61:	c9                   	leave  
80105c62:	c3                   	ret    
80105c63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c70 <sys_wait>:

int
sys_wait(void)
{
80105c70:	f3 0f 1e fb          	endbr32 
  return wait();
80105c74:	e9 47 e7 ff ff       	jmp    801043c0 <wait>
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_kill>:
}

int
sys_kill(void)
{
80105c80:	f3 0f 1e fb          	endbr32 
80105c84:	55                   	push   %ebp
80105c85:	89 e5                	mov    %esp,%ebp
80105c87:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c8d:	50                   	push   %eax
80105c8e:	6a 00                	push   $0x0
80105c90:	e8 3b f2 ff ff       	call   80104ed0 <argint>
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	78 14                	js     80105cb0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c9c:	83 ec 0c             	sub    $0xc,%esp
80105c9f:	ff 75 f4             	pushl  -0xc(%ebp)
80105ca2:	e8 89 e8 ff ff       	call   80104530 <kill>
80105ca7:	83 c4 10             	add    $0x10,%esp
}
80105caa:	c9                   	leave  
80105cab:	c3                   	ret    
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cb0:	c9                   	leave  
    return -1;
80105cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cb6:	c3                   	ret    
80105cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <sys_getpid>:

int
sys_getpid(void)
{
80105cc0:	f3 0f 1e fb          	endbr32 
80105cc4:	55                   	push   %ebp
80105cc5:	89 e5                	mov    %esp,%ebp
80105cc7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105cca:	e8 51 e0 ff ff       	call   80103d20 <myproc>
80105ccf:	8b 40 10             	mov    0x10(%eax),%eax
}
80105cd2:	c9                   	leave  
80105cd3:	c3                   	ret    
80105cd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cdf:	90                   	nop

80105ce0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ce0:	f3 0f 1e fb          	endbr32 
80105ce4:	55                   	push   %ebp
80105ce5:	89 e5                	mov    %esp,%ebp
80105ce7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ce8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ceb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cee:	50                   	push   %eax
80105cef:	6a 00                	push   $0x0
80105cf1:	e8 da f1 ff ff       	call   80104ed0 <argint>
80105cf6:	83 c4 10             	add    $0x10,%esp
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	78 23                	js     80105d20 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105cfd:	e8 1e e0 ff ff       	call   80103d20 <myproc>
  if(growproc(n) < 0)
80105d02:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105d05:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d07:	ff 75 f4             	pushl  -0xc(%ebp)
80105d0a:	e8 41 e1 ff ff       	call   80103e50 <growproc>
80105d0f:	83 c4 10             	add    $0x10,%esp
80105d12:	85 c0                	test   %eax,%eax
80105d14:	78 0a                	js     80105d20 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105d16:	89 d8                	mov    %ebx,%eax
80105d18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d1b:	c9                   	leave  
80105d1c:	c3                   	ret    
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d25:	eb ef                	jmp    80105d16 <sys_sbrk+0x36>
80105d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <sys_sleep>:

int
sys_sleep(void)
{
80105d30:	f3 0f 1e fb          	endbr32 
80105d34:	55                   	push   %ebp
80105d35:	89 e5                	mov    %esp,%ebp
80105d37:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d3b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d3e:	50                   	push   %eax
80105d3f:	6a 00                	push   $0x0
80105d41:	e8 8a f1 ff ff       	call   80104ed0 <argint>
80105d46:	83 c4 10             	add    $0x10,%esp
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	0f 88 86 00 00 00    	js     80105dd7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105d51:	83 ec 0c             	sub    $0xc,%esp
80105d54:	68 60 33 12 80       	push   $0x80123360
80105d59:	e8 82 ed ff ff       	call   80104ae0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105d61:	8b 1d a0 3b 12 80    	mov    0x80123ba0,%ebx
  while(ticks - ticks0 < n){
80105d67:	83 c4 10             	add    $0x10,%esp
80105d6a:	85 d2                	test   %edx,%edx
80105d6c:	75 23                	jne    80105d91 <sys_sleep+0x61>
80105d6e:	eb 50                	jmp    80105dc0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d70:	83 ec 08             	sub    $0x8,%esp
80105d73:	68 60 33 12 80       	push   $0x80123360
80105d78:	68 a0 3b 12 80       	push   $0x80123ba0
80105d7d:	e8 7e e5 ff ff       	call   80104300 <sleep>
  while(ticks - ticks0 < n){
80105d82:	a1 a0 3b 12 80       	mov    0x80123ba0,%eax
80105d87:	83 c4 10             	add    $0x10,%esp
80105d8a:	29 d8                	sub    %ebx,%eax
80105d8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d8f:	73 2f                	jae    80105dc0 <sys_sleep+0x90>
    if(myproc()->killed){
80105d91:	e8 8a df ff ff       	call   80103d20 <myproc>
80105d96:	8b 40 24             	mov    0x24(%eax),%eax
80105d99:	85 c0                	test   %eax,%eax
80105d9b:	74 d3                	je     80105d70 <sys_sleep+0x40>
      release(&tickslock);
80105d9d:	83 ec 0c             	sub    $0xc,%esp
80105da0:	68 60 33 12 80       	push   $0x80123360
80105da5:	e8 f6 ed ff ff       	call   80104ba0 <release>
  }
  release(&tickslock);
  return 0;
}
80105daa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105dad:	83 c4 10             	add    $0x10,%esp
80105db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105db5:	c9                   	leave  
80105db6:	c3                   	ret    
80105db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	68 60 33 12 80       	push   $0x80123360
80105dc8:	e8 d3 ed ff ff       	call   80104ba0 <release>
  return 0;
80105dcd:	83 c4 10             	add    $0x10,%esp
80105dd0:	31 c0                	xor    %eax,%eax
}
80105dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dd5:	c9                   	leave  
80105dd6:	c3                   	ret    
    return -1;
80105dd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ddc:	eb f4                	jmp    80105dd2 <sys_sleep+0xa2>
80105dde:	66 90                	xchg   %ax,%ax

80105de0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105de0:	f3 0f 1e fb          	endbr32 
80105de4:	55                   	push   %ebp
80105de5:	89 e5                	mov    %esp,%ebp
80105de7:	53                   	push   %ebx
80105de8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105deb:	68 60 33 12 80       	push   $0x80123360
80105df0:	e8 eb ec ff ff       	call   80104ae0 <acquire>
  xticks = ticks;
80105df5:	8b 1d a0 3b 12 80    	mov    0x80123ba0,%ebx
  release(&tickslock);
80105dfb:	c7 04 24 60 33 12 80 	movl   $0x80123360,(%esp)
80105e02:	e8 99 ed ff ff       	call   80104ba0 <release>
  return xticks;
}
80105e07:	89 d8                	mov    %ebx,%eax
80105e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e0c:	c9                   	leave  
80105e0d:	c3                   	ret    

80105e0e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e0e:	1e                   	push   %ds
  pushl %es
80105e0f:	06                   	push   %es
  pushl %fs
80105e10:	0f a0                	push   %fs
  pushl %gs
80105e12:	0f a8                	push   %gs
  pushal
80105e14:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e15:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e19:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e1b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e1d:	54                   	push   %esp
  call trap
80105e1e:	e8 cd 00 00 00       	call   80105ef0 <trap>
  addl $4, %esp
80105e23:	83 c4 04             	add    $0x4,%esp

80105e26 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105e26:	61                   	popa   
  popl %gs
80105e27:	0f a9                	pop    %gs
  popl %fs
80105e29:	0f a1                	pop    %fs
  popl %es
80105e2b:	07                   	pop    %es
  popl %ds
80105e2c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105e2d:	83 c4 08             	add    $0x8,%esp
  iret
80105e30:	cf                   	iret   
80105e31:	66 90                	xchg   %ax,%ax
80105e33:	66 90                	xchg   %ax,%ax
80105e35:	66 90                	xchg   %ax,%ax
80105e37:	66 90                	xchg   %ax,%ax
80105e39:	66 90                	xchg   %ax,%ax
80105e3b:	66 90                	xchg   %ax,%ax
80105e3d:	66 90                	xchg   %ax,%ax
80105e3f:	90                   	nop

80105e40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e40:	f3 0f 1e fb          	endbr32 
80105e44:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105e45:	31 c0                	xor    %eax,%eax
{
80105e47:	89 e5                	mov    %esp,%ebp
80105e49:	83 ec 08             	sub    $0x8,%esp
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105e50:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105e57:	c7 04 c5 a2 33 12 80 	movl   $0x8e000008,-0x7fedcc5e(,%eax,8)
80105e5e:	08 00 00 8e 
80105e62:	66 89 14 c5 a0 33 12 	mov    %dx,-0x7fedcc60(,%eax,8)
80105e69:	80 
80105e6a:	c1 ea 10             	shr    $0x10,%edx
80105e6d:	66 89 14 c5 a6 33 12 	mov    %dx,-0x7fedcc5a(,%eax,8)
80105e74:	80 
  for(i = 0; i < 256; i++)
80105e75:	83 c0 01             	add    $0x1,%eax
80105e78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e7d:	75 d1                	jne    80105e50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105e7f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e82:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105e87:	c7 05 a2 35 12 80 08 	movl   $0xef000008,0x801235a2
80105e8e:	00 00 ef 
  initlock(&tickslock, "time");
80105e91:	68 35 86 10 80       	push   $0x80108635
80105e96:	68 60 33 12 80       	push   $0x80123360
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e9b:	66 a3 a0 35 12 80    	mov    %ax,0x801235a0
80105ea1:	c1 e8 10             	shr    $0x10,%eax
80105ea4:	66 a3 a6 35 12 80    	mov    %ax,0x801235a6
  initlock(&tickslock, "time");
80105eaa:	e8 b1 ea ff ff       	call   80104960 <initlock>
}
80105eaf:	83 c4 10             	add    $0x10,%esp
80105eb2:	c9                   	leave  
80105eb3:	c3                   	ret    
80105eb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ebf:	90                   	nop

80105ec0 <idtinit>:

void
idtinit(void)
{
80105ec0:	f3 0f 1e fb          	endbr32 
80105ec4:	55                   	push   %ebp
  pd[0] = size-1;
80105ec5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105eca:	89 e5                	mov    %esp,%ebp
80105ecc:	83 ec 10             	sub    $0x10,%esp
80105ecf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105ed3:	b8 a0 33 12 80       	mov    $0x801233a0,%eax
80105ed8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105edc:	c1 e8 10             	shr    $0x10,%eax
80105edf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105ee3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ee6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ee9:	c9                   	leave  
80105eea:	c3                   	ret    
80105eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105eef:	90                   	nop

80105ef0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ef0:	f3 0f 1e fb          	endbr32 
80105ef4:	55                   	push   %ebp
80105ef5:	89 e5                	mov    %esp,%ebp
80105ef7:	57                   	push   %edi
80105ef8:	56                   	push   %esi
80105ef9:	53                   	push   %ebx
80105efa:	83 ec 1c             	sub    $0x1c,%esp
80105efd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105f00:	8b 43 30             	mov    0x30(%ebx),%eax
80105f03:	83 f8 40             	cmp    $0x40,%eax
80105f06:	0f 84 6c 02 00 00    	je     80106178 <trap+0x288>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f0c:	83 e8 0e             	sub    $0xe,%eax
80105f0f:	83 f8 31             	cmp    $0x31,%eax
80105f12:	77 08                	ja     80105f1c <trap+0x2c>
80105f14:	3e ff 24 85 e0 87 10 	notrack jmp *-0x7fef7820(,%eax,4)
80105f1b:	80 
      }
    }

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f1c:	e8 ff dd ff ff       	call   80103d20 <myproc>
80105f21:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f24:	85 c0                	test   %eax,%eax
80105f26:	0f 84 d8 02 00 00    	je     80106204 <trap+0x314>
80105f2c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105f30:	0f 84 ce 02 00 00    	je     80106204 <trap+0x314>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f36:	0f 20 d1             	mov    %cr2,%ecx
80105f39:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f3c:	e8 bf dd ff ff       	call   80103d00 <cpuid>
80105f41:	8b 73 30             	mov    0x30(%ebx),%esi
80105f44:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f47:	8b 43 34             	mov    0x34(%ebx),%eax
80105f4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f4d:	e8 ce dd ff ff       	call   80103d20 <myproc>
80105f52:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f55:	e8 c6 dd ff ff       	call   80103d20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f5a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f60:	51                   	push   %ecx
80105f61:	57                   	push   %edi
80105f62:	52                   	push   %edx
80105f63:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f66:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105f67:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105f6a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f6d:	56                   	push   %esi
80105f6e:	ff 70 10             	pushl  0x10(%eax)
80105f71:	68 9c 87 10 80       	push   $0x8010879c
80105f76:	e8 35 a7 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105f7b:	83 c4 20             	add    $0x20,%esp
80105f7e:	e8 9d dd ff ff       	call   80103d20 <myproc>
80105f83:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f8a:	e8 91 dd ff ff       	call   80103d20 <myproc>
80105f8f:	85 c0                	test   %eax,%eax
80105f91:	74 1d                	je     80105fb0 <trap+0xc0>
80105f93:	e8 88 dd ff ff       	call   80103d20 <myproc>
80105f98:	8b 50 24             	mov    0x24(%eax),%edx
80105f9b:	85 d2                	test   %edx,%edx
80105f9d:	74 11                	je     80105fb0 <trap+0xc0>
80105f9f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105fa3:	83 e0 03             	and    $0x3,%eax
80105fa6:	66 83 f8 03          	cmp    $0x3,%ax
80105faa:	0f 84 00 02 00 00    	je     801061b0 <trap+0x2c0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105fb0:	e8 6b dd ff ff       	call   80103d20 <myproc>
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	74 0f                	je     80105fc8 <trap+0xd8>
80105fb9:	e8 62 dd ff ff       	call   80103d20 <myproc>
80105fbe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105fc2:	0f 84 90 01 00 00    	je     80106158 <trap+0x268>
      
     
   

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fc8:	e8 53 dd ff ff       	call   80103d20 <myproc>
80105fcd:	85 c0                	test   %eax,%eax
80105fcf:	74 1d                	je     80105fee <trap+0xfe>
80105fd1:	e8 4a dd ff ff       	call   80103d20 <myproc>
80105fd6:	8b 40 24             	mov    0x24(%eax),%eax
80105fd9:	85 c0                	test   %eax,%eax
80105fdb:	74 11                	je     80105fee <trap+0xfe>
80105fdd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105fe1:	83 e0 03             	and    $0x3,%eax
80105fe4:	66 83 f8 03          	cmp    $0x3,%ax
80105fe8:	0f 84 b3 01 00 00    	je     801061a1 <trap+0x2b1>
    exit();
}
80105fee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff1:	5b                   	pop    %ebx
80105ff2:	5e                   	pop    %esi
80105ff3:	5f                   	pop    %edi
80105ff4:	5d                   	pop    %ebp
80105ff5:	c3                   	ret    
      struct proc *p=myproc();
80105ff6:	e8 25 dd ff ff       	call   80103d20 <myproc>
80105ffb:	89 c6                	mov    %eax,%esi
80105ffd:	0f 20 d7             	mov    %cr2,%edi
      pi=walk(p->pgdir,r_addr,0);
80106000:	83 ec 04             	sub    $0x4,%esp
      r_addr=PTE_ADDR(rcr2());
80106003:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      pi=walk(p->pgdir,r_addr,0);
80106009:	6a 00                	push   $0x0
8010600b:	57                   	push   %edi
8010600c:	ff 70 04             	pushl  0x4(%eax)
8010600f:	e8 dc 0f 00 00       	call   80106ff0 <walk>
      if(pi==1){
80106014:	83 c4 10             	add    $0x10,%esp
80106017:	83 f8 01             	cmp    $0x1,%eax
8010601a:	0f 85 6a ff ff ff    	jne    80105f8a <trap+0x9a>
        cprintf("trap.c(T_PGFLT):page fault khacche.(virtual address from rcr2) %d\n",r_addr);
80106020:	83 ec 08             	sub    $0x8,%esp
80106023:	57                   	push   %edi
80106024:	68 64 86 10 80       	push   $0x80108664
80106029:	e8 82 a6 ff ff       	call   801006b0 <cprintf>
        virtual_address=p->f_page_tra[name-1].virtual_addr;
8010602e:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
        if(r_addr==virtual_address){
80106034:	83 c4 10             	add    $0x10,%esp
80106037:	3b bc c6 e0 02 00 00 	cmp    0x2e0(%esi,%eax,8),%edi
8010603e:	0f 85 d8 fe ff ff    	jne    80105f1c <trap+0x2c>
          uint va=p->matha->v_address;
80106044:	8b 86 dc 02 00 00    	mov    0x2dc(%esi),%eax
          cprintf("trap.c(T_PGFLT):FIFO ->item write from the first element %d\n",va);
8010604a:	83 ec 08             	sub    $0x8,%esp
          uint va=p->matha->v_address;
8010604d:	8b 00                	mov    (%eax),%eax
          cprintf("trap.c(T_PGFLT):FIFO ->item write from the first element %d\n",va);
8010604f:	50                   	push   %eax
80106050:	68 a8 86 10 80       	push   $0x801086a8
80106055:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106058:	e8 53 a6 ff ff       	call   801006b0 <cprintf>
          cprintf("trap.c(T_PGFLT):FIFO write er offset :%d\n",p->offset_swapfile);
8010605d:	59                   	pop    %ecx
8010605e:	58                   	pop    %eax
8010605f:	ff b6 e4 02 00 00    	pushl  0x2e4(%esi)
80106065:	68 e8 86 10 80       	push   $0x801086e8
8010606a:	e8 41 a6 ff ff       	call   801006b0 <cprintf>
          writeToSwapFile(p,(char*)PTE_ADDR(va),p->offset_swapfile,PGSIZE);
8010606f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106072:	68 00 10 00 00       	push   $0x1000
80106077:	ff b6 e4 02 00 00    	pushl  0x2e4(%esi)
8010607d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106082:	50                   	push   %eax
80106083:	56                   	push   %esi
80106084:	e8 07 c3 ff ff       	call   80102390 <writeToSwapFile>
          cprintf("trap.c(T_PGFLT):FIFO writeToSwapFile a likhar pore trap theke function a jacche.\n");
80106089:	83 c4 14             	add    $0x14,%esp
8010608c:	68 14 87 10 80       	push   $0x80108714
80106091:	e8 1a a6 ff ff       	call   801006b0 <cprintf>
          p->matha=p->matha->nxt;
80106096:	8b 86 dc 02 00 00    	mov    0x2dc(%esi),%eax
8010609c:	8b 40 04             	mov    0x4(%eax),%eax
8010609f:	89 86 dc 02 00 00    	mov    %eax,0x2dc(%esi)
          trap_theke(p->pgdir, r_addr);
801060a5:	58                   	pop    %eax
801060a6:	5a                   	pop    %edx
801060a7:	57                   	push   %edi
801060a8:	ff 76 04             	pushl  0x4(%esi)
801060ab:	e8 60 1b 00 00       	call   80107c10 <trap_theke>
          break;
801060b0:	83 c4 10             	add    $0x10,%esp
801060b3:	e9 d2 fe ff ff       	jmp    80105f8a <trap+0x9a>
    if(cpuid() == 0){
801060b8:	e8 43 dc ff ff       	call   80103d00 <cpuid>
801060bd:	85 c0                	test   %eax,%eax
801060bf:	0f 84 0b 01 00 00    	je     801061d0 <trap+0x2e0>
    lapiceoi();
801060c5:	e8 76 cb ff ff       	call   80102c40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060ca:	e8 51 dc ff ff       	call   80103d20 <myproc>
801060cf:	85 c0                	test   %eax,%eax
801060d1:	0f 85 bc fe ff ff    	jne    80105f93 <trap+0xa3>
801060d7:	e9 d4 fe ff ff       	jmp    80105fb0 <trap+0xc0>
    kbdintr();
801060dc:	e8 1f ca ff ff       	call   80102b00 <kbdintr>
    lapiceoi();
801060e1:	e8 5a cb ff ff       	call   80102c40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060e6:	e8 35 dc ff ff       	call   80103d20 <myproc>
801060eb:	85 c0                	test   %eax,%eax
801060ed:	0f 85 a0 fe ff ff    	jne    80105f93 <trap+0xa3>
801060f3:	e9 b8 fe ff ff       	jmp    80105fb0 <trap+0xc0>
    uartintr();
801060f8:	e8 a3 02 00 00       	call   801063a0 <uartintr>
    lapiceoi();
801060fd:	e8 3e cb ff ff       	call   80102c40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106102:	e8 19 dc ff ff       	call   80103d20 <myproc>
80106107:	85 c0                	test   %eax,%eax
80106109:	0f 85 84 fe ff ff    	jne    80105f93 <trap+0xa3>
8010610f:	e9 9c fe ff ff       	jmp    80105fb0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106114:	8b 7b 38             	mov    0x38(%ebx),%edi
80106117:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010611b:	e8 e0 db ff ff       	call   80103d00 <cpuid>
80106120:	57                   	push   %edi
80106121:	56                   	push   %esi
80106122:	50                   	push   %eax
80106123:	68 40 86 10 80       	push   $0x80108640
80106128:	e8 83 a5 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
8010612d:	e8 0e cb ff ff       	call   80102c40 <lapiceoi>
    break;
80106132:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106135:	e8 e6 db ff ff       	call   80103d20 <myproc>
8010613a:	85 c0                	test   %eax,%eax
8010613c:	0f 85 51 fe ff ff    	jne    80105f93 <trap+0xa3>
80106142:	e9 69 fe ff ff       	jmp    80105fb0 <trap+0xc0>
    ideintr();
80106147:	e8 14 c4 ff ff       	call   80102560 <ideintr>
8010614c:	e9 74 ff ff ff       	jmp    801060c5 <trap+0x1d5>
80106151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106158:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010615c:	0f 85 66 fe ff ff    	jne    80105fc8 <trap+0xd8>
    Counter_Set_korar_jonno();
80106162:	e8 59 e4 ff ff       	call   801045c0 <Counter_Set_korar_jonno>
      yield();
80106167:	e8 44 e1 ff ff       	call   801042b0 <yield>
8010616c:	e9 57 fe ff ff       	jmp    80105fc8 <trap+0xd8>
80106171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106178:	e8 a3 db ff ff       	call   80103d20 <myproc>
8010617d:	8b 70 24             	mov    0x24(%eax),%esi
80106180:	85 f6                	test   %esi,%esi
80106182:	75 3c                	jne    801061c0 <trap+0x2d0>
    myproc()->tf = tf;
80106184:	e8 97 db ff ff       	call   80103d20 <myproc>
80106189:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010618c:	e8 2f ee ff ff       	call   80104fc0 <syscall>
    if(myproc()->killed)
80106191:	e8 8a db ff ff       	call   80103d20 <myproc>
80106196:	8b 48 24             	mov    0x24(%eax),%ecx
80106199:	85 c9                	test   %ecx,%ecx
8010619b:	0f 84 4d fe ff ff    	je     80105fee <trap+0xfe>
}
801061a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061a4:	5b                   	pop    %ebx
801061a5:	5e                   	pop    %esi
801061a6:	5f                   	pop    %edi
801061a7:	5d                   	pop    %ebp
      exit();
801061a8:	e9 c3 df ff ff       	jmp    80104170 <exit>
801061ad:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801061b0:	e8 bb df ff ff       	call   80104170 <exit>
801061b5:	e9 f6 fd ff ff       	jmp    80105fb0 <trap+0xc0>
801061ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801061c0:	e8 ab df ff ff       	call   80104170 <exit>
801061c5:	eb bd                	jmp    80106184 <trap+0x294>
801061c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ce:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
801061d0:	83 ec 0c             	sub    $0xc,%esp
801061d3:	68 60 33 12 80       	push   $0x80123360
801061d8:	e8 03 e9 ff ff       	call   80104ae0 <acquire>
      wakeup(&ticks);
801061dd:	c7 04 24 a0 3b 12 80 	movl   $0x80123ba0,(%esp)
      ticks++;
801061e4:	83 05 a0 3b 12 80 01 	addl   $0x1,0x80123ba0
      wakeup(&ticks);
801061eb:	e8 d0 e2 ff ff       	call   801044c0 <wakeup>
      release(&tickslock);
801061f0:	c7 04 24 60 33 12 80 	movl   $0x80123360,(%esp)
801061f7:	e8 a4 e9 ff ff       	call   80104ba0 <release>
801061fc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801061ff:	e9 c1 fe ff ff       	jmp    801060c5 <trap+0x1d5>
80106204:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106207:	e8 f4 da ff ff       	call   80103d00 <cpuid>
8010620c:	83 ec 0c             	sub    $0xc,%esp
8010620f:	56                   	push   %esi
80106210:	57                   	push   %edi
80106211:	50                   	push   %eax
80106212:	ff 73 30             	pushl  0x30(%ebx)
80106215:	68 68 87 10 80       	push   $0x80108768
8010621a:	e8 91 a4 ff ff       	call   801006b0 <cprintf>
      panic("trap");
8010621f:	83 c4 14             	add    $0x14,%esp
80106222:	68 3a 86 10 80       	push   $0x8010863a
80106227:	e8 64 a1 ff ff       	call   80100390 <panic>
8010622c:	66 90                	xchg   %ax,%ax
8010622e:	66 90                	xchg   %ax,%ax

80106230 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106230:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106234:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106239:	85 c0                	test   %eax,%eax
8010623b:	74 1b                	je     80106258 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010623d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106242:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106243:	a8 01                	test   $0x1,%al
80106245:	74 11                	je     80106258 <uartgetc+0x28>
80106247:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010624c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010624d:	0f b6 c0             	movzbl %al,%eax
80106250:	c3                   	ret    
80106251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010625d:	c3                   	ret    
8010625e:	66 90                	xchg   %ax,%ax

80106260 <uartputc.part.0>:
uartputc(int c)
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	57                   	push   %edi
80106264:	89 c7                	mov    %eax,%edi
80106266:	56                   	push   %esi
80106267:	be fd 03 00 00       	mov    $0x3fd,%esi
8010626c:	53                   	push   %ebx
8010626d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106272:	83 ec 0c             	sub    $0xc,%esp
80106275:	eb 1b                	jmp    80106292 <uartputc.part.0+0x32>
80106277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010627e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106280:	83 ec 0c             	sub    $0xc,%esp
80106283:	6a 0a                	push   $0xa
80106285:	e8 d6 c9 ff ff       	call   80102c60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010628a:	83 c4 10             	add    $0x10,%esp
8010628d:	83 eb 01             	sub    $0x1,%ebx
80106290:	74 07                	je     80106299 <uartputc.part.0+0x39>
80106292:	89 f2                	mov    %esi,%edx
80106294:	ec                   	in     (%dx),%al
80106295:	a8 20                	test   $0x20,%al
80106297:	74 e7                	je     80106280 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106299:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010629e:	89 f8                	mov    %edi,%eax
801062a0:	ee                   	out    %al,(%dx)
}
801062a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062a4:	5b                   	pop    %ebx
801062a5:	5e                   	pop    %esi
801062a6:	5f                   	pop    %edi
801062a7:	5d                   	pop    %ebp
801062a8:	c3                   	ret    
801062a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062b0 <uartinit>:
{
801062b0:	f3 0f 1e fb          	endbr32 
801062b4:	55                   	push   %ebp
801062b5:	31 c9                	xor    %ecx,%ecx
801062b7:	89 c8                	mov    %ecx,%eax
801062b9:	89 e5                	mov    %esp,%ebp
801062bb:	57                   	push   %edi
801062bc:	56                   	push   %esi
801062bd:	53                   	push   %ebx
801062be:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801062c3:	89 da                	mov    %ebx,%edx
801062c5:	83 ec 0c             	sub    $0xc,%esp
801062c8:	ee                   	out    %al,(%dx)
801062c9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801062ce:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062d3:	89 fa                	mov    %edi,%edx
801062d5:	ee                   	out    %al,(%dx)
801062d6:	b8 0c 00 00 00       	mov    $0xc,%eax
801062db:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062e0:	ee                   	out    %al,(%dx)
801062e1:	be f9 03 00 00       	mov    $0x3f9,%esi
801062e6:	89 c8                	mov    %ecx,%eax
801062e8:	89 f2                	mov    %esi,%edx
801062ea:	ee                   	out    %al,(%dx)
801062eb:	b8 03 00 00 00       	mov    $0x3,%eax
801062f0:	89 fa                	mov    %edi,%edx
801062f2:	ee                   	out    %al,(%dx)
801062f3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801062f8:	89 c8                	mov    %ecx,%eax
801062fa:	ee                   	out    %al,(%dx)
801062fb:	b8 01 00 00 00       	mov    $0x1,%eax
80106300:	89 f2                	mov    %esi,%edx
80106302:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106303:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106308:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106309:	3c ff                	cmp    $0xff,%al
8010630b:	74 52                	je     8010635f <uartinit+0xaf>
  uart = 1;
8010630d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106314:	00 00 00 
80106317:	89 da                	mov    %ebx,%edx
80106319:	ec                   	in     (%dx),%al
8010631a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010631f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106320:	83 ec 08             	sub    $0x8,%esp
80106323:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106328:	bb a8 88 10 80       	mov    $0x801088a8,%ebx
  ioapicenable(IRQ_COM1, 0);
8010632d:	6a 00                	push   $0x0
8010632f:	6a 04                	push   $0x4
80106331:	e8 7a c4 ff ff       	call   801027b0 <ioapicenable>
80106336:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106339:	b8 78 00 00 00       	mov    $0x78,%eax
8010633e:	eb 04                	jmp    80106344 <uartinit+0x94>
80106340:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106344:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010634a:	85 d2                	test   %edx,%edx
8010634c:	74 08                	je     80106356 <uartinit+0xa6>
    uartputc(*p);
8010634e:	0f be c0             	movsbl %al,%eax
80106351:	e8 0a ff ff ff       	call   80106260 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106356:	89 f0                	mov    %esi,%eax
80106358:	83 c3 01             	add    $0x1,%ebx
8010635b:	84 c0                	test   %al,%al
8010635d:	75 e1                	jne    80106340 <uartinit+0x90>
}
8010635f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106362:	5b                   	pop    %ebx
80106363:	5e                   	pop    %esi
80106364:	5f                   	pop    %edi
80106365:	5d                   	pop    %ebp
80106366:	c3                   	ret    
80106367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010636e:	66 90                	xchg   %ax,%ax

80106370 <uartputc>:
{
80106370:	f3 0f 1e fb          	endbr32 
80106374:	55                   	push   %ebp
  if(!uart)
80106375:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010637b:	89 e5                	mov    %esp,%ebp
8010637d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106380:	85 d2                	test   %edx,%edx
80106382:	74 0c                	je     80106390 <uartputc+0x20>
}
80106384:	5d                   	pop    %ebp
80106385:	e9 d6 fe ff ff       	jmp    80106260 <uartputc.part.0>
8010638a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106390:	5d                   	pop    %ebp
80106391:	c3                   	ret    
80106392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063a0 <uartintr>:

void
uartintr(void)
{
801063a0:	f3 0f 1e fb          	endbr32 
801063a4:	55                   	push   %ebp
801063a5:	89 e5                	mov    %esp,%ebp
801063a7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801063aa:	68 30 62 10 80       	push   $0x80106230
801063af:	e8 ac a4 ff ff       	call   80100860 <consoleintr>
}
801063b4:	83 c4 10             	add    $0x10,%esp
801063b7:	c9                   	leave  
801063b8:	c3                   	ret    

801063b9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $0
801063bb:	6a 00                	push   $0x0
  jmp alltraps
801063bd:	e9 4c fa ff ff       	jmp    80105e0e <alltraps>

801063c2 <vector1>:
.globl vector1
vector1:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $1
801063c4:	6a 01                	push   $0x1
  jmp alltraps
801063c6:	e9 43 fa ff ff       	jmp    80105e0e <alltraps>

801063cb <vector2>:
.globl vector2
vector2:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $2
801063cd:	6a 02                	push   $0x2
  jmp alltraps
801063cf:	e9 3a fa ff ff       	jmp    80105e0e <alltraps>

801063d4 <vector3>:
.globl vector3
vector3:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $3
801063d6:	6a 03                	push   $0x3
  jmp alltraps
801063d8:	e9 31 fa ff ff       	jmp    80105e0e <alltraps>

801063dd <vector4>:
.globl vector4
vector4:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $4
801063df:	6a 04                	push   $0x4
  jmp alltraps
801063e1:	e9 28 fa ff ff       	jmp    80105e0e <alltraps>

801063e6 <vector5>:
.globl vector5
vector5:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $5
801063e8:	6a 05                	push   $0x5
  jmp alltraps
801063ea:	e9 1f fa ff ff       	jmp    80105e0e <alltraps>

801063ef <vector6>:
.globl vector6
vector6:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $6
801063f1:	6a 06                	push   $0x6
  jmp alltraps
801063f3:	e9 16 fa ff ff       	jmp    80105e0e <alltraps>

801063f8 <vector7>:
.globl vector7
vector7:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $7
801063fa:	6a 07                	push   $0x7
  jmp alltraps
801063fc:	e9 0d fa ff ff       	jmp    80105e0e <alltraps>

80106401 <vector8>:
.globl vector8
vector8:
  pushl $8
80106401:	6a 08                	push   $0x8
  jmp alltraps
80106403:	e9 06 fa ff ff       	jmp    80105e0e <alltraps>

80106408 <vector9>:
.globl vector9
vector9:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $9
8010640a:	6a 09                	push   $0x9
  jmp alltraps
8010640c:	e9 fd f9 ff ff       	jmp    80105e0e <alltraps>

80106411 <vector10>:
.globl vector10
vector10:
  pushl $10
80106411:	6a 0a                	push   $0xa
  jmp alltraps
80106413:	e9 f6 f9 ff ff       	jmp    80105e0e <alltraps>

80106418 <vector11>:
.globl vector11
vector11:
  pushl $11
80106418:	6a 0b                	push   $0xb
  jmp alltraps
8010641a:	e9 ef f9 ff ff       	jmp    80105e0e <alltraps>

8010641f <vector12>:
.globl vector12
vector12:
  pushl $12
8010641f:	6a 0c                	push   $0xc
  jmp alltraps
80106421:	e9 e8 f9 ff ff       	jmp    80105e0e <alltraps>

80106426 <vector13>:
.globl vector13
vector13:
  pushl $13
80106426:	6a 0d                	push   $0xd
  jmp alltraps
80106428:	e9 e1 f9 ff ff       	jmp    80105e0e <alltraps>

8010642d <vector14>:
.globl vector14
vector14:
  pushl $14
8010642d:	6a 0e                	push   $0xe
  jmp alltraps
8010642f:	e9 da f9 ff ff       	jmp    80105e0e <alltraps>

80106434 <vector15>:
.globl vector15
vector15:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $15
80106436:	6a 0f                	push   $0xf
  jmp alltraps
80106438:	e9 d1 f9 ff ff       	jmp    80105e0e <alltraps>

8010643d <vector16>:
.globl vector16
vector16:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $16
8010643f:	6a 10                	push   $0x10
  jmp alltraps
80106441:	e9 c8 f9 ff ff       	jmp    80105e0e <alltraps>

80106446 <vector17>:
.globl vector17
vector17:
  pushl $17
80106446:	6a 11                	push   $0x11
  jmp alltraps
80106448:	e9 c1 f9 ff ff       	jmp    80105e0e <alltraps>

8010644d <vector18>:
.globl vector18
vector18:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $18
8010644f:	6a 12                	push   $0x12
  jmp alltraps
80106451:	e9 b8 f9 ff ff       	jmp    80105e0e <alltraps>

80106456 <vector19>:
.globl vector19
vector19:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $19
80106458:	6a 13                	push   $0x13
  jmp alltraps
8010645a:	e9 af f9 ff ff       	jmp    80105e0e <alltraps>

8010645f <vector20>:
.globl vector20
vector20:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $20
80106461:	6a 14                	push   $0x14
  jmp alltraps
80106463:	e9 a6 f9 ff ff       	jmp    80105e0e <alltraps>

80106468 <vector21>:
.globl vector21
vector21:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $21
8010646a:	6a 15                	push   $0x15
  jmp alltraps
8010646c:	e9 9d f9 ff ff       	jmp    80105e0e <alltraps>

80106471 <vector22>:
.globl vector22
vector22:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $22
80106473:	6a 16                	push   $0x16
  jmp alltraps
80106475:	e9 94 f9 ff ff       	jmp    80105e0e <alltraps>

8010647a <vector23>:
.globl vector23
vector23:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $23
8010647c:	6a 17                	push   $0x17
  jmp alltraps
8010647e:	e9 8b f9 ff ff       	jmp    80105e0e <alltraps>

80106483 <vector24>:
.globl vector24
vector24:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $24
80106485:	6a 18                	push   $0x18
  jmp alltraps
80106487:	e9 82 f9 ff ff       	jmp    80105e0e <alltraps>

8010648c <vector25>:
.globl vector25
vector25:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $25
8010648e:	6a 19                	push   $0x19
  jmp alltraps
80106490:	e9 79 f9 ff ff       	jmp    80105e0e <alltraps>

80106495 <vector26>:
.globl vector26
vector26:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $26
80106497:	6a 1a                	push   $0x1a
  jmp alltraps
80106499:	e9 70 f9 ff ff       	jmp    80105e0e <alltraps>

8010649e <vector27>:
.globl vector27
vector27:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $27
801064a0:	6a 1b                	push   $0x1b
  jmp alltraps
801064a2:	e9 67 f9 ff ff       	jmp    80105e0e <alltraps>

801064a7 <vector28>:
.globl vector28
vector28:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $28
801064a9:	6a 1c                	push   $0x1c
  jmp alltraps
801064ab:	e9 5e f9 ff ff       	jmp    80105e0e <alltraps>

801064b0 <vector29>:
.globl vector29
vector29:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $29
801064b2:	6a 1d                	push   $0x1d
  jmp alltraps
801064b4:	e9 55 f9 ff ff       	jmp    80105e0e <alltraps>

801064b9 <vector30>:
.globl vector30
vector30:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $30
801064bb:	6a 1e                	push   $0x1e
  jmp alltraps
801064bd:	e9 4c f9 ff ff       	jmp    80105e0e <alltraps>

801064c2 <vector31>:
.globl vector31
vector31:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $31
801064c4:	6a 1f                	push   $0x1f
  jmp alltraps
801064c6:	e9 43 f9 ff ff       	jmp    80105e0e <alltraps>

801064cb <vector32>:
.globl vector32
vector32:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $32
801064cd:	6a 20                	push   $0x20
  jmp alltraps
801064cf:	e9 3a f9 ff ff       	jmp    80105e0e <alltraps>

801064d4 <vector33>:
.globl vector33
vector33:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $33
801064d6:	6a 21                	push   $0x21
  jmp alltraps
801064d8:	e9 31 f9 ff ff       	jmp    80105e0e <alltraps>

801064dd <vector34>:
.globl vector34
vector34:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $34
801064df:	6a 22                	push   $0x22
  jmp alltraps
801064e1:	e9 28 f9 ff ff       	jmp    80105e0e <alltraps>

801064e6 <vector35>:
.globl vector35
vector35:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $35
801064e8:	6a 23                	push   $0x23
  jmp alltraps
801064ea:	e9 1f f9 ff ff       	jmp    80105e0e <alltraps>

801064ef <vector36>:
.globl vector36
vector36:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $36
801064f1:	6a 24                	push   $0x24
  jmp alltraps
801064f3:	e9 16 f9 ff ff       	jmp    80105e0e <alltraps>

801064f8 <vector37>:
.globl vector37
vector37:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $37
801064fa:	6a 25                	push   $0x25
  jmp alltraps
801064fc:	e9 0d f9 ff ff       	jmp    80105e0e <alltraps>

80106501 <vector38>:
.globl vector38
vector38:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $38
80106503:	6a 26                	push   $0x26
  jmp alltraps
80106505:	e9 04 f9 ff ff       	jmp    80105e0e <alltraps>

8010650a <vector39>:
.globl vector39
vector39:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $39
8010650c:	6a 27                	push   $0x27
  jmp alltraps
8010650e:	e9 fb f8 ff ff       	jmp    80105e0e <alltraps>

80106513 <vector40>:
.globl vector40
vector40:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $40
80106515:	6a 28                	push   $0x28
  jmp alltraps
80106517:	e9 f2 f8 ff ff       	jmp    80105e0e <alltraps>

8010651c <vector41>:
.globl vector41
vector41:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $41
8010651e:	6a 29                	push   $0x29
  jmp alltraps
80106520:	e9 e9 f8 ff ff       	jmp    80105e0e <alltraps>

80106525 <vector42>:
.globl vector42
vector42:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $42
80106527:	6a 2a                	push   $0x2a
  jmp alltraps
80106529:	e9 e0 f8 ff ff       	jmp    80105e0e <alltraps>

8010652e <vector43>:
.globl vector43
vector43:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $43
80106530:	6a 2b                	push   $0x2b
  jmp alltraps
80106532:	e9 d7 f8 ff ff       	jmp    80105e0e <alltraps>

80106537 <vector44>:
.globl vector44
vector44:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $44
80106539:	6a 2c                	push   $0x2c
  jmp alltraps
8010653b:	e9 ce f8 ff ff       	jmp    80105e0e <alltraps>

80106540 <vector45>:
.globl vector45
vector45:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $45
80106542:	6a 2d                	push   $0x2d
  jmp alltraps
80106544:	e9 c5 f8 ff ff       	jmp    80105e0e <alltraps>

80106549 <vector46>:
.globl vector46
vector46:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $46
8010654b:	6a 2e                	push   $0x2e
  jmp alltraps
8010654d:	e9 bc f8 ff ff       	jmp    80105e0e <alltraps>

80106552 <vector47>:
.globl vector47
vector47:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $47
80106554:	6a 2f                	push   $0x2f
  jmp alltraps
80106556:	e9 b3 f8 ff ff       	jmp    80105e0e <alltraps>

8010655b <vector48>:
.globl vector48
vector48:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $48
8010655d:	6a 30                	push   $0x30
  jmp alltraps
8010655f:	e9 aa f8 ff ff       	jmp    80105e0e <alltraps>

80106564 <vector49>:
.globl vector49
vector49:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $49
80106566:	6a 31                	push   $0x31
  jmp alltraps
80106568:	e9 a1 f8 ff ff       	jmp    80105e0e <alltraps>

8010656d <vector50>:
.globl vector50
vector50:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $50
8010656f:	6a 32                	push   $0x32
  jmp alltraps
80106571:	e9 98 f8 ff ff       	jmp    80105e0e <alltraps>

80106576 <vector51>:
.globl vector51
vector51:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $51
80106578:	6a 33                	push   $0x33
  jmp alltraps
8010657a:	e9 8f f8 ff ff       	jmp    80105e0e <alltraps>

8010657f <vector52>:
.globl vector52
vector52:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $52
80106581:	6a 34                	push   $0x34
  jmp alltraps
80106583:	e9 86 f8 ff ff       	jmp    80105e0e <alltraps>

80106588 <vector53>:
.globl vector53
vector53:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $53
8010658a:	6a 35                	push   $0x35
  jmp alltraps
8010658c:	e9 7d f8 ff ff       	jmp    80105e0e <alltraps>

80106591 <vector54>:
.globl vector54
vector54:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $54
80106593:	6a 36                	push   $0x36
  jmp alltraps
80106595:	e9 74 f8 ff ff       	jmp    80105e0e <alltraps>

8010659a <vector55>:
.globl vector55
vector55:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $55
8010659c:	6a 37                	push   $0x37
  jmp alltraps
8010659e:	e9 6b f8 ff ff       	jmp    80105e0e <alltraps>

801065a3 <vector56>:
.globl vector56
vector56:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $56
801065a5:	6a 38                	push   $0x38
  jmp alltraps
801065a7:	e9 62 f8 ff ff       	jmp    80105e0e <alltraps>

801065ac <vector57>:
.globl vector57
vector57:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $57
801065ae:	6a 39                	push   $0x39
  jmp alltraps
801065b0:	e9 59 f8 ff ff       	jmp    80105e0e <alltraps>

801065b5 <vector58>:
.globl vector58
vector58:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $58
801065b7:	6a 3a                	push   $0x3a
  jmp alltraps
801065b9:	e9 50 f8 ff ff       	jmp    80105e0e <alltraps>

801065be <vector59>:
.globl vector59
vector59:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $59
801065c0:	6a 3b                	push   $0x3b
  jmp alltraps
801065c2:	e9 47 f8 ff ff       	jmp    80105e0e <alltraps>

801065c7 <vector60>:
.globl vector60
vector60:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $60
801065c9:	6a 3c                	push   $0x3c
  jmp alltraps
801065cb:	e9 3e f8 ff ff       	jmp    80105e0e <alltraps>

801065d0 <vector61>:
.globl vector61
vector61:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $61
801065d2:	6a 3d                	push   $0x3d
  jmp alltraps
801065d4:	e9 35 f8 ff ff       	jmp    80105e0e <alltraps>

801065d9 <vector62>:
.globl vector62
vector62:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $62
801065db:	6a 3e                	push   $0x3e
  jmp alltraps
801065dd:	e9 2c f8 ff ff       	jmp    80105e0e <alltraps>

801065e2 <vector63>:
.globl vector63
vector63:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $63
801065e4:	6a 3f                	push   $0x3f
  jmp alltraps
801065e6:	e9 23 f8 ff ff       	jmp    80105e0e <alltraps>

801065eb <vector64>:
.globl vector64
vector64:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $64
801065ed:	6a 40                	push   $0x40
  jmp alltraps
801065ef:	e9 1a f8 ff ff       	jmp    80105e0e <alltraps>

801065f4 <vector65>:
.globl vector65
vector65:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $65
801065f6:	6a 41                	push   $0x41
  jmp alltraps
801065f8:	e9 11 f8 ff ff       	jmp    80105e0e <alltraps>

801065fd <vector66>:
.globl vector66
vector66:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $66
801065ff:	6a 42                	push   $0x42
  jmp alltraps
80106601:	e9 08 f8 ff ff       	jmp    80105e0e <alltraps>

80106606 <vector67>:
.globl vector67
vector67:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $67
80106608:	6a 43                	push   $0x43
  jmp alltraps
8010660a:	e9 ff f7 ff ff       	jmp    80105e0e <alltraps>

8010660f <vector68>:
.globl vector68
vector68:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $68
80106611:	6a 44                	push   $0x44
  jmp alltraps
80106613:	e9 f6 f7 ff ff       	jmp    80105e0e <alltraps>

80106618 <vector69>:
.globl vector69
vector69:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $69
8010661a:	6a 45                	push   $0x45
  jmp alltraps
8010661c:	e9 ed f7 ff ff       	jmp    80105e0e <alltraps>

80106621 <vector70>:
.globl vector70
vector70:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $70
80106623:	6a 46                	push   $0x46
  jmp alltraps
80106625:	e9 e4 f7 ff ff       	jmp    80105e0e <alltraps>

8010662a <vector71>:
.globl vector71
vector71:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $71
8010662c:	6a 47                	push   $0x47
  jmp alltraps
8010662e:	e9 db f7 ff ff       	jmp    80105e0e <alltraps>

80106633 <vector72>:
.globl vector72
vector72:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $72
80106635:	6a 48                	push   $0x48
  jmp alltraps
80106637:	e9 d2 f7 ff ff       	jmp    80105e0e <alltraps>

8010663c <vector73>:
.globl vector73
vector73:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $73
8010663e:	6a 49                	push   $0x49
  jmp alltraps
80106640:	e9 c9 f7 ff ff       	jmp    80105e0e <alltraps>

80106645 <vector74>:
.globl vector74
vector74:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $74
80106647:	6a 4a                	push   $0x4a
  jmp alltraps
80106649:	e9 c0 f7 ff ff       	jmp    80105e0e <alltraps>

8010664e <vector75>:
.globl vector75
vector75:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $75
80106650:	6a 4b                	push   $0x4b
  jmp alltraps
80106652:	e9 b7 f7 ff ff       	jmp    80105e0e <alltraps>

80106657 <vector76>:
.globl vector76
vector76:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $76
80106659:	6a 4c                	push   $0x4c
  jmp alltraps
8010665b:	e9 ae f7 ff ff       	jmp    80105e0e <alltraps>

80106660 <vector77>:
.globl vector77
vector77:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $77
80106662:	6a 4d                	push   $0x4d
  jmp alltraps
80106664:	e9 a5 f7 ff ff       	jmp    80105e0e <alltraps>

80106669 <vector78>:
.globl vector78
vector78:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $78
8010666b:	6a 4e                	push   $0x4e
  jmp alltraps
8010666d:	e9 9c f7 ff ff       	jmp    80105e0e <alltraps>

80106672 <vector79>:
.globl vector79
vector79:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $79
80106674:	6a 4f                	push   $0x4f
  jmp alltraps
80106676:	e9 93 f7 ff ff       	jmp    80105e0e <alltraps>

8010667b <vector80>:
.globl vector80
vector80:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $80
8010667d:	6a 50                	push   $0x50
  jmp alltraps
8010667f:	e9 8a f7 ff ff       	jmp    80105e0e <alltraps>

80106684 <vector81>:
.globl vector81
vector81:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $81
80106686:	6a 51                	push   $0x51
  jmp alltraps
80106688:	e9 81 f7 ff ff       	jmp    80105e0e <alltraps>

8010668d <vector82>:
.globl vector82
vector82:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $82
8010668f:	6a 52                	push   $0x52
  jmp alltraps
80106691:	e9 78 f7 ff ff       	jmp    80105e0e <alltraps>

80106696 <vector83>:
.globl vector83
vector83:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $83
80106698:	6a 53                	push   $0x53
  jmp alltraps
8010669a:	e9 6f f7 ff ff       	jmp    80105e0e <alltraps>

8010669f <vector84>:
.globl vector84
vector84:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $84
801066a1:	6a 54                	push   $0x54
  jmp alltraps
801066a3:	e9 66 f7 ff ff       	jmp    80105e0e <alltraps>

801066a8 <vector85>:
.globl vector85
vector85:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $85
801066aa:	6a 55                	push   $0x55
  jmp alltraps
801066ac:	e9 5d f7 ff ff       	jmp    80105e0e <alltraps>

801066b1 <vector86>:
.globl vector86
vector86:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $86
801066b3:	6a 56                	push   $0x56
  jmp alltraps
801066b5:	e9 54 f7 ff ff       	jmp    80105e0e <alltraps>

801066ba <vector87>:
.globl vector87
vector87:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $87
801066bc:	6a 57                	push   $0x57
  jmp alltraps
801066be:	e9 4b f7 ff ff       	jmp    80105e0e <alltraps>

801066c3 <vector88>:
.globl vector88
vector88:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $88
801066c5:	6a 58                	push   $0x58
  jmp alltraps
801066c7:	e9 42 f7 ff ff       	jmp    80105e0e <alltraps>

801066cc <vector89>:
.globl vector89
vector89:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $89
801066ce:	6a 59                	push   $0x59
  jmp alltraps
801066d0:	e9 39 f7 ff ff       	jmp    80105e0e <alltraps>

801066d5 <vector90>:
.globl vector90
vector90:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $90
801066d7:	6a 5a                	push   $0x5a
  jmp alltraps
801066d9:	e9 30 f7 ff ff       	jmp    80105e0e <alltraps>

801066de <vector91>:
.globl vector91
vector91:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $91
801066e0:	6a 5b                	push   $0x5b
  jmp alltraps
801066e2:	e9 27 f7 ff ff       	jmp    80105e0e <alltraps>

801066e7 <vector92>:
.globl vector92
vector92:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $92
801066e9:	6a 5c                	push   $0x5c
  jmp alltraps
801066eb:	e9 1e f7 ff ff       	jmp    80105e0e <alltraps>

801066f0 <vector93>:
.globl vector93
vector93:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $93
801066f2:	6a 5d                	push   $0x5d
  jmp alltraps
801066f4:	e9 15 f7 ff ff       	jmp    80105e0e <alltraps>

801066f9 <vector94>:
.globl vector94
vector94:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $94
801066fb:	6a 5e                	push   $0x5e
  jmp alltraps
801066fd:	e9 0c f7 ff ff       	jmp    80105e0e <alltraps>

80106702 <vector95>:
.globl vector95
vector95:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $95
80106704:	6a 5f                	push   $0x5f
  jmp alltraps
80106706:	e9 03 f7 ff ff       	jmp    80105e0e <alltraps>

8010670b <vector96>:
.globl vector96
vector96:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $96
8010670d:	6a 60                	push   $0x60
  jmp alltraps
8010670f:	e9 fa f6 ff ff       	jmp    80105e0e <alltraps>

80106714 <vector97>:
.globl vector97
vector97:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $97
80106716:	6a 61                	push   $0x61
  jmp alltraps
80106718:	e9 f1 f6 ff ff       	jmp    80105e0e <alltraps>

8010671d <vector98>:
.globl vector98
vector98:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $98
8010671f:	6a 62                	push   $0x62
  jmp alltraps
80106721:	e9 e8 f6 ff ff       	jmp    80105e0e <alltraps>

80106726 <vector99>:
.globl vector99
vector99:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $99
80106728:	6a 63                	push   $0x63
  jmp alltraps
8010672a:	e9 df f6 ff ff       	jmp    80105e0e <alltraps>

8010672f <vector100>:
.globl vector100
vector100:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $100
80106731:	6a 64                	push   $0x64
  jmp alltraps
80106733:	e9 d6 f6 ff ff       	jmp    80105e0e <alltraps>

80106738 <vector101>:
.globl vector101
vector101:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $101
8010673a:	6a 65                	push   $0x65
  jmp alltraps
8010673c:	e9 cd f6 ff ff       	jmp    80105e0e <alltraps>

80106741 <vector102>:
.globl vector102
vector102:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $102
80106743:	6a 66                	push   $0x66
  jmp alltraps
80106745:	e9 c4 f6 ff ff       	jmp    80105e0e <alltraps>

8010674a <vector103>:
.globl vector103
vector103:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $103
8010674c:	6a 67                	push   $0x67
  jmp alltraps
8010674e:	e9 bb f6 ff ff       	jmp    80105e0e <alltraps>

80106753 <vector104>:
.globl vector104
vector104:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $104
80106755:	6a 68                	push   $0x68
  jmp alltraps
80106757:	e9 b2 f6 ff ff       	jmp    80105e0e <alltraps>

8010675c <vector105>:
.globl vector105
vector105:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $105
8010675e:	6a 69                	push   $0x69
  jmp alltraps
80106760:	e9 a9 f6 ff ff       	jmp    80105e0e <alltraps>

80106765 <vector106>:
.globl vector106
vector106:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $106
80106767:	6a 6a                	push   $0x6a
  jmp alltraps
80106769:	e9 a0 f6 ff ff       	jmp    80105e0e <alltraps>

8010676e <vector107>:
.globl vector107
vector107:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $107
80106770:	6a 6b                	push   $0x6b
  jmp alltraps
80106772:	e9 97 f6 ff ff       	jmp    80105e0e <alltraps>

80106777 <vector108>:
.globl vector108
vector108:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $108
80106779:	6a 6c                	push   $0x6c
  jmp alltraps
8010677b:	e9 8e f6 ff ff       	jmp    80105e0e <alltraps>

80106780 <vector109>:
.globl vector109
vector109:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $109
80106782:	6a 6d                	push   $0x6d
  jmp alltraps
80106784:	e9 85 f6 ff ff       	jmp    80105e0e <alltraps>

80106789 <vector110>:
.globl vector110
vector110:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $110
8010678b:	6a 6e                	push   $0x6e
  jmp alltraps
8010678d:	e9 7c f6 ff ff       	jmp    80105e0e <alltraps>

80106792 <vector111>:
.globl vector111
vector111:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $111
80106794:	6a 6f                	push   $0x6f
  jmp alltraps
80106796:	e9 73 f6 ff ff       	jmp    80105e0e <alltraps>

8010679b <vector112>:
.globl vector112
vector112:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $112
8010679d:	6a 70                	push   $0x70
  jmp alltraps
8010679f:	e9 6a f6 ff ff       	jmp    80105e0e <alltraps>

801067a4 <vector113>:
.globl vector113
vector113:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $113
801067a6:	6a 71                	push   $0x71
  jmp alltraps
801067a8:	e9 61 f6 ff ff       	jmp    80105e0e <alltraps>

801067ad <vector114>:
.globl vector114
vector114:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $114
801067af:	6a 72                	push   $0x72
  jmp alltraps
801067b1:	e9 58 f6 ff ff       	jmp    80105e0e <alltraps>

801067b6 <vector115>:
.globl vector115
vector115:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $115
801067b8:	6a 73                	push   $0x73
  jmp alltraps
801067ba:	e9 4f f6 ff ff       	jmp    80105e0e <alltraps>

801067bf <vector116>:
.globl vector116
vector116:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $116
801067c1:	6a 74                	push   $0x74
  jmp alltraps
801067c3:	e9 46 f6 ff ff       	jmp    80105e0e <alltraps>

801067c8 <vector117>:
.globl vector117
vector117:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $117
801067ca:	6a 75                	push   $0x75
  jmp alltraps
801067cc:	e9 3d f6 ff ff       	jmp    80105e0e <alltraps>

801067d1 <vector118>:
.globl vector118
vector118:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $118
801067d3:	6a 76                	push   $0x76
  jmp alltraps
801067d5:	e9 34 f6 ff ff       	jmp    80105e0e <alltraps>

801067da <vector119>:
.globl vector119
vector119:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $119
801067dc:	6a 77                	push   $0x77
  jmp alltraps
801067de:	e9 2b f6 ff ff       	jmp    80105e0e <alltraps>

801067e3 <vector120>:
.globl vector120
vector120:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $120
801067e5:	6a 78                	push   $0x78
  jmp alltraps
801067e7:	e9 22 f6 ff ff       	jmp    80105e0e <alltraps>

801067ec <vector121>:
.globl vector121
vector121:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $121
801067ee:	6a 79                	push   $0x79
  jmp alltraps
801067f0:	e9 19 f6 ff ff       	jmp    80105e0e <alltraps>

801067f5 <vector122>:
.globl vector122
vector122:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $122
801067f7:	6a 7a                	push   $0x7a
  jmp alltraps
801067f9:	e9 10 f6 ff ff       	jmp    80105e0e <alltraps>

801067fe <vector123>:
.globl vector123
vector123:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $123
80106800:	6a 7b                	push   $0x7b
  jmp alltraps
80106802:	e9 07 f6 ff ff       	jmp    80105e0e <alltraps>

80106807 <vector124>:
.globl vector124
vector124:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $124
80106809:	6a 7c                	push   $0x7c
  jmp alltraps
8010680b:	e9 fe f5 ff ff       	jmp    80105e0e <alltraps>

80106810 <vector125>:
.globl vector125
vector125:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $125
80106812:	6a 7d                	push   $0x7d
  jmp alltraps
80106814:	e9 f5 f5 ff ff       	jmp    80105e0e <alltraps>

80106819 <vector126>:
.globl vector126
vector126:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $126
8010681b:	6a 7e                	push   $0x7e
  jmp alltraps
8010681d:	e9 ec f5 ff ff       	jmp    80105e0e <alltraps>

80106822 <vector127>:
.globl vector127
vector127:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $127
80106824:	6a 7f                	push   $0x7f
  jmp alltraps
80106826:	e9 e3 f5 ff ff       	jmp    80105e0e <alltraps>

8010682b <vector128>:
.globl vector128
vector128:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $128
8010682d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106832:	e9 d7 f5 ff ff       	jmp    80105e0e <alltraps>

80106837 <vector129>:
.globl vector129
vector129:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $129
80106839:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010683e:	e9 cb f5 ff ff       	jmp    80105e0e <alltraps>

80106843 <vector130>:
.globl vector130
vector130:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $130
80106845:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010684a:	e9 bf f5 ff ff       	jmp    80105e0e <alltraps>

8010684f <vector131>:
.globl vector131
vector131:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $131
80106851:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106856:	e9 b3 f5 ff ff       	jmp    80105e0e <alltraps>

8010685b <vector132>:
.globl vector132
vector132:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $132
8010685d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106862:	e9 a7 f5 ff ff       	jmp    80105e0e <alltraps>

80106867 <vector133>:
.globl vector133
vector133:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $133
80106869:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010686e:	e9 9b f5 ff ff       	jmp    80105e0e <alltraps>

80106873 <vector134>:
.globl vector134
vector134:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $134
80106875:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010687a:	e9 8f f5 ff ff       	jmp    80105e0e <alltraps>

8010687f <vector135>:
.globl vector135
vector135:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $135
80106881:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106886:	e9 83 f5 ff ff       	jmp    80105e0e <alltraps>

8010688b <vector136>:
.globl vector136
vector136:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $136
8010688d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106892:	e9 77 f5 ff ff       	jmp    80105e0e <alltraps>

80106897 <vector137>:
.globl vector137
vector137:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $137
80106899:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010689e:	e9 6b f5 ff ff       	jmp    80105e0e <alltraps>

801068a3 <vector138>:
.globl vector138
vector138:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $138
801068a5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801068aa:	e9 5f f5 ff ff       	jmp    80105e0e <alltraps>

801068af <vector139>:
.globl vector139
vector139:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $139
801068b1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801068b6:	e9 53 f5 ff ff       	jmp    80105e0e <alltraps>

801068bb <vector140>:
.globl vector140
vector140:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $140
801068bd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801068c2:	e9 47 f5 ff ff       	jmp    80105e0e <alltraps>

801068c7 <vector141>:
.globl vector141
vector141:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $141
801068c9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801068ce:	e9 3b f5 ff ff       	jmp    80105e0e <alltraps>

801068d3 <vector142>:
.globl vector142
vector142:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $142
801068d5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801068da:	e9 2f f5 ff ff       	jmp    80105e0e <alltraps>

801068df <vector143>:
.globl vector143
vector143:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $143
801068e1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801068e6:	e9 23 f5 ff ff       	jmp    80105e0e <alltraps>

801068eb <vector144>:
.globl vector144
vector144:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $144
801068ed:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801068f2:	e9 17 f5 ff ff       	jmp    80105e0e <alltraps>

801068f7 <vector145>:
.globl vector145
vector145:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $145
801068f9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801068fe:	e9 0b f5 ff ff       	jmp    80105e0e <alltraps>

80106903 <vector146>:
.globl vector146
vector146:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $146
80106905:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010690a:	e9 ff f4 ff ff       	jmp    80105e0e <alltraps>

8010690f <vector147>:
.globl vector147
vector147:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $147
80106911:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106916:	e9 f3 f4 ff ff       	jmp    80105e0e <alltraps>

8010691b <vector148>:
.globl vector148
vector148:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $148
8010691d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106922:	e9 e7 f4 ff ff       	jmp    80105e0e <alltraps>

80106927 <vector149>:
.globl vector149
vector149:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $149
80106929:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010692e:	e9 db f4 ff ff       	jmp    80105e0e <alltraps>

80106933 <vector150>:
.globl vector150
vector150:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $150
80106935:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010693a:	e9 cf f4 ff ff       	jmp    80105e0e <alltraps>

8010693f <vector151>:
.globl vector151
vector151:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $151
80106941:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106946:	e9 c3 f4 ff ff       	jmp    80105e0e <alltraps>

8010694b <vector152>:
.globl vector152
vector152:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $152
8010694d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106952:	e9 b7 f4 ff ff       	jmp    80105e0e <alltraps>

80106957 <vector153>:
.globl vector153
vector153:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $153
80106959:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010695e:	e9 ab f4 ff ff       	jmp    80105e0e <alltraps>

80106963 <vector154>:
.globl vector154
vector154:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $154
80106965:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010696a:	e9 9f f4 ff ff       	jmp    80105e0e <alltraps>

8010696f <vector155>:
.globl vector155
vector155:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $155
80106971:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106976:	e9 93 f4 ff ff       	jmp    80105e0e <alltraps>

8010697b <vector156>:
.globl vector156
vector156:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $156
8010697d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106982:	e9 87 f4 ff ff       	jmp    80105e0e <alltraps>

80106987 <vector157>:
.globl vector157
vector157:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $157
80106989:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010698e:	e9 7b f4 ff ff       	jmp    80105e0e <alltraps>

80106993 <vector158>:
.globl vector158
vector158:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $158
80106995:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010699a:	e9 6f f4 ff ff       	jmp    80105e0e <alltraps>

8010699f <vector159>:
.globl vector159
vector159:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $159
801069a1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801069a6:	e9 63 f4 ff ff       	jmp    80105e0e <alltraps>

801069ab <vector160>:
.globl vector160
vector160:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $160
801069ad:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801069b2:	e9 57 f4 ff ff       	jmp    80105e0e <alltraps>

801069b7 <vector161>:
.globl vector161
vector161:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $161
801069b9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801069be:	e9 4b f4 ff ff       	jmp    80105e0e <alltraps>

801069c3 <vector162>:
.globl vector162
vector162:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $162
801069c5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801069ca:	e9 3f f4 ff ff       	jmp    80105e0e <alltraps>

801069cf <vector163>:
.globl vector163
vector163:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $163
801069d1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801069d6:	e9 33 f4 ff ff       	jmp    80105e0e <alltraps>

801069db <vector164>:
.globl vector164
vector164:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $164
801069dd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801069e2:	e9 27 f4 ff ff       	jmp    80105e0e <alltraps>

801069e7 <vector165>:
.globl vector165
vector165:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $165
801069e9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801069ee:	e9 1b f4 ff ff       	jmp    80105e0e <alltraps>

801069f3 <vector166>:
.globl vector166
vector166:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $166
801069f5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801069fa:	e9 0f f4 ff ff       	jmp    80105e0e <alltraps>

801069ff <vector167>:
.globl vector167
vector167:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $167
80106a01:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a06:	e9 03 f4 ff ff       	jmp    80105e0e <alltraps>

80106a0b <vector168>:
.globl vector168
vector168:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $168
80106a0d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a12:	e9 f7 f3 ff ff       	jmp    80105e0e <alltraps>

80106a17 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $169
80106a19:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a1e:	e9 eb f3 ff ff       	jmp    80105e0e <alltraps>

80106a23 <vector170>:
.globl vector170
vector170:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $170
80106a25:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a2a:	e9 df f3 ff ff       	jmp    80105e0e <alltraps>

80106a2f <vector171>:
.globl vector171
vector171:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $171
80106a31:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a36:	e9 d3 f3 ff ff       	jmp    80105e0e <alltraps>

80106a3b <vector172>:
.globl vector172
vector172:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $172
80106a3d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a42:	e9 c7 f3 ff ff       	jmp    80105e0e <alltraps>

80106a47 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $173
80106a49:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a4e:	e9 bb f3 ff ff       	jmp    80105e0e <alltraps>

80106a53 <vector174>:
.globl vector174
vector174:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $174
80106a55:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a5a:	e9 af f3 ff ff       	jmp    80105e0e <alltraps>

80106a5f <vector175>:
.globl vector175
vector175:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $175
80106a61:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a66:	e9 a3 f3 ff ff       	jmp    80105e0e <alltraps>

80106a6b <vector176>:
.globl vector176
vector176:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $176
80106a6d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a72:	e9 97 f3 ff ff       	jmp    80105e0e <alltraps>

80106a77 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $177
80106a79:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a7e:	e9 8b f3 ff ff       	jmp    80105e0e <alltraps>

80106a83 <vector178>:
.globl vector178
vector178:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $178
80106a85:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a8a:	e9 7f f3 ff ff       	jmp    80105e0e <alltraps>

80106a8f <vector179>:
.globl vector179
vector179:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $179
80106a91:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106a96:	e9 73 f3 ff ff       	jmp    80105e0e <alltraps>

80106a9b <vector180>:
.globl vector180
vector180:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $180
80106a9d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106aa2:	e9 67 f3 ff ff       	jmp    80105e0e <alltraps>

80106aa7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $181
80106aa9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106aae:	e9 5b f3 ff ff       	jmp    80105e0e <alltraps>

80106ab3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $182
80106ab5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106aba:	e9 4f f3 ff ff       	jmp    80105e0e <alltraps>

80106abf <vector183>:
.globl vector183
vector183:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $183
80106ac1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ac6:	e9 43 f3 ff ff       	jmp    80105e0e <alltraps>

80106acb <vector184>:
.globl vector184
vector184:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $184
80106acd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ad2:	e9 37 f3 ff ff       	jmp    80105e0e <alltraps>

80106ad7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $185
80106ad9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106ade:	e9 2b f3 ff ff       	jmp    80105e0e <alltraps>

80106ae3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $186
80106ae5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106aea:	e9 1f f3 ff ff       	jmp    80105e0e <alltraps>

80106aef <vector187>:
.globl vector187
vector187:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $187
80106af1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106af6:	e9 13 f3 ff ff       	jmp    80105e0e <alltraps>

80106afb <vector188>:
.globl vector188
vector188:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $188
80106afd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b02:	e9 07 f3 ff ff       	jmp    80105e0e <alltraps>

80106b07 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $189
80106b09:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b0e:	e9 fb f2 ff ff       	jmp    80105e0e <alltraps>

80106b13 <vector190>:
.globl vector190
vector190:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $190
80106b15:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b1a:	e9 ef f2 ff ff       	jmp    80105e0e <alltraps>

80106b1f <vector191>:
.globl vector191
vector191:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $191
80106b21:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b26:	e9 e3 f2 ff ff       	jmp    80105e0e <alltraps>

80106b2b <vector192>:
.globl vector192
vector192:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $192
80106b2d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b32:	e9 d7 f2 ff ff       	jmp    80105e0e <alltraps>

80106b37 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $193
80106b39:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b3e:	e9 cb f2 ff ff       	jmp    80105e0e <alltraps>

80106b43 <vector194>:
.globl vector194
vector194:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $194
80106b45:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b4a:	e9 bf f2 ff ff       	jmp    80105e0e <alltraps>

80106b4f <vector195>:
.globl vector195
vector195:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $195
80106b51:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b56:	e9 b3 f2 ff ff       	jmp    80105e0e <alltraps>

80106b5b <vector196>:
.globl vector196
vector196:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $196
80106b5d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b62:	e9 a7 f2 ff ff       	jmp    80105e0e <alltraps>

80106b67 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $197
80106b69:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b6e:	e9 9b f2 ff ff       	jmp    80105e0e <alltraps>

80106b73 <vector198>:
.globl vector198
vector198:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $198
80106b75:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b7a:	e9 8f f2 ff ff       	jmp    80105e0e <alltraps>

80106b7f <vector199>:
.globl vector199
vector199:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $199
80106b81:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b86:	e9 83 f2 ff ff       	jmp    80105e0e <alltraps>

80106b8b <vector200>:
.globl vector200
vector200:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $200
80106b8d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b92:	e9 77 f2 ff ff       	jmp    80105e0e <alltraps>

80106b97 <vector201>:
.globl vector201
vector201:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $201
80106b99:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106b9e:	e9 6b f2 ff ff       	jmp    80105e0e <alltraps>

80106ba3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $202
80106ba5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106baa:	e9 5f f2 ff ff       	jmp    80105e0e <alltraps>

80106baf <vector203>:
.globl vector203
vector203:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $203
80106bb1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106bb6:	e9 53 f2 ff ff       	jmp    80105e0e <alltraps>

80106bbb <vector204>:
.globl vector204
vector204:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $204
80106bbd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106bc2:	e9 47 f2 ff ff       	jmp    80105e0e <alltraps>

80106bc7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $205
80106bc9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106bce:	e9 3b f2 ff ff       	jmp    80105e0e <alltraps>

80106bd3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $206
80106bd5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106bda:	e9 2f f2 ff ff       	jmp    80105e0e <alltraps>

80106bdf <vector207>:
.globl vector207
vector207:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $207
80106be1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106be6:	e9 23 f2 ff ff       	jmp    80105e0e <alltraps>

80106beb <vector208>:
.globl vector208
vector208:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $208
80106bed:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106bf2:	e9 17 f2 ff ff       	jmp    80105e0e <alltraps>

80106bf7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $209
80106bf9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106bfe:	e9 0b f2 ff ff       	jmp    80105e0e <alltraps>

80106c03 <vector210>:
.globl vector210
vector210:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $210
80106c05:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c0a:	e9 ff f1 ff ff       	jmp    80105e0e <alltraps>

80106c0f <vector211>:
.globl vector211
vector211:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $211
80106c11:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c16:	e9 f3 f1 ff ff       	jmp    80105e0e <alltraps>

80106c1b <vector212>:
.globl vector212
vector212:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $212
80106c1d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c22:	e9 e7 f1 ff ff       	jmp    80105e0e <alltraps>

80106c27 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $213
80106c29:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c2e:	e9 db f1 ff ff       	jmp    80105e0e <alltraps>

80106c33 <vector214>:
.globl vector214
vector214:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $214
80106c35:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c3a:	e9 cf f1 ff ff       	jmp    80105e0e <alltraps>

80106c3f <vector215>:
.globl vector215
vector215:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $215
80106c41:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c46:	e9 c3 f1 ff ff       	jmp    80105e0e <alltraps>

80106c4b <vector216>:
.globl vector216
vector216:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $216
80106c4d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c52:	e9 b7 f1 ff ff       	jmp    80105e0e <alltraps>

80106c57 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $217
80106c59:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c5e:	e9 ab f1 ff ff       	jmp    80105e0e <alltraps>

80106c63 <vector218>:
.globl vector218
vector218:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $218
80106c65:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c6a:	e9 9f f1 ff ff       	jmp    80105e0e <alltraps>

80106c6f <vector219>:
.globl vector219
vector219:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $219
80106c71:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c76:	e9 93 f1 ff ff       	jmp    80105e0e <alltraps>

80106c7b <vector220>:
.globl vector220
vector220:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $220
80106c7d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c82:	e9 87 f1 ff ff       	jmp    80105e0e <alltraps>

80106c87 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $221
80106c89:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c8e:	e9 7b f1 ff ff       	jmp    80105e0e <alltraps>

80106c93 <vector222>:
.globl vector222
vector222:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $222
80106c95:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106c9a:	e9 6f f1 ff ff       	jmp    80105e0e <alltraps>

80106c9f <vector223>:
.globl vector223
vector223:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $223
80106ca1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ca6:	e9 63 f1 ff ff       	jmp    80105e0e <alltraps>

80106cab <vector224>:
.globl vector224
vector224:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $224
80106cad:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106cb2:	e9 57 f1 ff ff       	jmp    80105e0e <alltraps>

80106cb7 <vector225>:
.globl vector225
vector225:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $225
80106cb9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106cbe:	e9 4b f1 ff ff       	jmp    80105e0e <alltraps>

80106cc3 <vector226>:
.globl vector226
vector226:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $226
80106cc5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106cca:	e9 3f f1 ff ff       	jmp    80105e0e <alltraps>

80106ccf <vector227>:
.globl vector227
vector227:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $227
80106cd1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106cd6:	e9 33 f1 ff ff       	jmp    80105e0e <alltraps>

80106cdb <vector228>:
.globl vector228
vector228:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $228
80106cdd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106ce2:	e9 27 f1 ff ff       	jmp    80105e0e <alltraps>

80106ce7 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $229
80106ce9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106cee:	e9 1b f1 ff ff       	jmp    80105e0e <alltraps>

80106cf3 <vector230>:
.globl vector230
vector230:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $230
80106cf5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106cfa:	e9 0f f1 ff ff       	jmp    80105e0e <alltraps>

80106cff <vector231>:
.globl vector231
vector231:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $231
80106d01:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d06:	e9 03 f1 ff ff       	jmp    80105e0e <alltraps>

80106d0b <vector232>:
.globl vector232
vector232:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $232
80106d0d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d12:	e9 f7 f0 ff ff       	jmp    80105e0e <alltraps>

80106d17 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $233
80106d19:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d1e:	e9 eb f0 ff ff       	jmp    80105e0e <alltraps>

80106d23 <vector234>:
.globl vector234
vector234:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $234
80106d25:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d2a:	e9 df f0 ff ff       	jmp    80105e0e <alltraps>

80106d2f <vector235>:
.globl vector235
vector235:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $235
80106d31:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d36:	e9 d3 f0 ff ff       	jmp    80105e0e <alltraps>

80106d3b <vector236>:
.globl vector236
vector236:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $236
80106d3d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d42:	e9 c7 f0 ff ff       	jmp    80105e0e <alltraps>

80106d47 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $237
80106d49:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d4e:	e9 bb f0 ff ff       	jmp    80105e0e <alltraps>

80106d53 <vector238>:
.globl vector238
vector238:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $238
80106d55:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d5a:	e9 af f0 ff ff       	jmp    80105e0e <alltraps>

80106d5f <vector239>:
.globl vector239
vector239:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $239
80106d61:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d66:	e9 a3 f0 ff ff       	jmp    80105e0e <alltraps>

80106d6b <vector240>:
.globl vector240
vector240:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $240
80106d6d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d72:	e9 97 f0 ff ff       	jmp    80105e0e <alltraps>

80106d77 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $241
80106d79:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d7e:	e9 8b f0 ff ff       	jmp    80105e0e <alltraps>

80106d83 <vector242>:
.globl vector242
vector242:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $242
80106d85:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d8a:	e9 7f f0 ff ff       	jmp    80105e0e <alltraps>

80106d8f <vector243>:
.globl vector243
vector243:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $243
80106d91:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106d96:	e9 73 f0 ff ff       	jmp    80105e0e <alltraps>

80106d9b <vector244>:
.globl vector244
vector244:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $244
80106d9d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106da2:	e9 67 f0 ff ff       	jmp    80105e0e <alltraps>

80106da7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $245
80106da9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106dae:	e9 5b f0 ff ff       	jmp    80105e0e <alltraps>

80106db3 <vector246>:
.globl vector246
vector246:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $246
80106db5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106dba:	e9 4f f0 ff ff       	jmp    80105e0e <alltraps>

80106dbf <vector247>:
.globl vector247
vector247:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $247
80106dc1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106dc6:	e9 43 f0 ff ff       	jmp    80105e0e <alltraps>

80106dcb <vector248>:
.globl vector248
vector248:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $248
80106dcd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106dd2:	e9 37 f0 ff ff       	jmp    80105e0e <alltraps>

80106dd7 <vector249>:
.globl vector249
vector249:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $249
80106dd9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106dde:	e9 2b f0 ff ff       	jmp    80105e0e <alltraps>

80106de3 <vector250>:
.globl vector250
vector250:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $250
80106de5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106dea:	e9 1f f0 ff ff       	jmp    80105e0e <alltraps>

80106def <vector251>:
.globl vector251
vector251:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $251
80106df1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106df6:	e9 13 f0 ff ff       	jmp    80105e0e <alltraps>

80106dfb <vector252>:
.globl vector252
vector252:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $252
80106dfd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e02:	e9 07 f0 ff ff       	jmp    80105e0e <alltraps>

80106e07 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $253
80106e09:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e0e:	e9 fb ef ff ff       	jmp    80105e0e <alltraps>

80106e13 <vector254>:
.globl vector254
vector254:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $254
80106e15:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e1a:	e9 ef ef ff ff       	jmp    80105e0e <alltraps>

80106e1f <vector255>:
.globl vector255
vector255:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $255
80106e21:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e26:	e9 e3 ef ff ff       	jmp    80105e0e <alltraps>
80106e2b:	66 90                	xchg   %ax,%ax
80106e2d:	66 90                	xchg   %ax,%ax
80106e2f:	90                   	nop

80106e30 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106e37:	c1 ea 16             	shr    $0x16,%edx
{
80106e3a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106e3b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106e3e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e41:	8b 1f                	mov    (%edi),%ebx
80106e43:	f6 c3 01             	test   $0x1,%bl
80106e46:	74 28                	je     80106e70 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106e4e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106e54:	89 f0                	mov    %esi,%eax
}
80106e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e59:	c1 e8 0a             	shr    $0xa,%eax
80106e5c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e61:	01 d8                	add    %ebx,%eax
}
80106e63:	5b                   	pop    %ebx
80106e64:	5e                   	pop    %esi
80106e65:	5f                   	pop    %edi
80106e66:	5d                   	pop    %ebp
80106e67:	c3                   	ret    
80106e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e6f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e70:	85 c9                	test   %ecx,%ecx
80106e72:	74 2c                	je     80106ea0 <walkpgdir+0x70>
80106e74:	e8 37 bb ff ff       	call   801029b0 <kalloc>
80106e79:	89 c3                	mov    %eax,%ebx
80106e7b:	85 c0                	test   %eax,%eax
80106e7d:	74 21                	je     80106ea0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106e7f:	83 ec 04             	sub    $0x4,%esp
80106e82:	68 00 10 00 00       	push   $0x1000
80106e87:	6a 00                	push   $0x0
80106e89:	50                   	push   %eax
80106e8a:	e8 61 dd ff ff       	call   80104bf0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e8f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e95:	83 c4 10             	add    $0x10,%esp
80106e98:	83 c8 07             	or     $0x7,%eax
80106e9b:	89 07                	mov    %eax,(%edi)
80106e9d:	eb b5                	jmp    80106e54 <walkpgdir+0x24>
80106e9f:	90                   	nop
}
80106ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ea3:	31 c0                	xor    %eax,%eax
}
80106ea5:	5b                   	pop    %ebx
80106ea6:	5e                   	pop    %esi
80106ea7:	5f                   	pop    %edi
80106ea8:	5d                   	pop    %ebp
80106ea9:	c3                   	ret    
80106eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106eb0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	57                   	push   %edi
80106eb4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106eb6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106eba:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ebb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106ec0:	89 d6                	mov    %edx,%esi
{
80106ec2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ec3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106ec9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ecc:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80106ed2:	29 f0                	sub    %esi,%eax
80106ed4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ed7:	eb 1f                	jmp    80106ef8 <mappages+0x48>
80106ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106ee0:	f6 00 01             	testb  $0x1,(%eax)
80106ee3:	75 45                	jne    80106f2a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ee5:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106ee8:	83 cb 01             	or     $0x1,%ebx
80106eeb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106eed:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106ef0:	74 2e                	je     80106f20 <mappages+0x70>
      break;
    a += PGSIZE;
80106ef2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106efb:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f00:	89 f2                	mov    %esi,%edx
80106f02:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106f05:	89 f8                	mov    %edi,%eax
80106f07:	e8 24 ff ff ff       	call   80106e30 <walkpgdir>
80106f0c:	85 c0                	test   %eax,%eax
80106f0e:	75 d0                	jne    80106ee0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f18:	5b                   	pop    %ebx
80106f19:	5e                   	pop    %esi
80106f1a:	5f                   	pop    %edi
80106f1b:	5d                   	pop    %ebp
80106f1c:	c3                   	ret    
80106f1d:	8d 76 00             	lea    0x0(%esi),%esi
80106f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f23:	31 c0                	xor    %eax,%eax
}
80106f25:	5b                   	pop    %ebx
80106f26:	5e                   	pop    %esi
80106f27:	5f                   	pop    %edi
80106f28:	5d                   	pop    %ebp
80106f29:	c3                   	ret    
      panic("remap");
80106f2a:	83 ec 0c             	sub    $0xc,%esp
80106f2d:	68 b0 88 10 80       	push   $0x801088b0
80106f32:	e8 59 94 ff ff       	call   80100390 <panic>
80106f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3e:	66 90                	xchg   %ax,%ax

80106f40 <seginit>:
{
80106f40:	f3 0f 1e fb          	endbr32 
80106f44:	55                   	push   %ebp
80106f45:	89 e5                	mov    %esp,%ebp
80106f47:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f4a:	e8 b1 cd ff ff       	call   80103d00 <cpuid>
  pd[0] = size-1;
80106f4f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f54:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106f5a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f5e:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106f65:	ff 00 00 
80106f68:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106f6f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f72:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106f79:	ff 00 00 
80106f7c:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106f83:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f86:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106f8d:	ff 00 00 
80106f90:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106f97:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f9a:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106fa1:	ff 00 00 
80106fa4:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106fab:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106fae:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80106fb3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106fb7:	c1 e8 10             	shr    $0x10,%eax
80106fba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106fbe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106fc1:	0f 01 10             	lgdtl  (%eax)
}
80106fc4:	c9                   	leave  
80106fc5:	c3                   	ret    
80106fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fcd:	8d 76 00             	lea    0x0(%esi),%esi

80106fd0 <pte_er_jonno>:
pte_er_jonno(pde_t *pgdir,pte_t *pte,uint v_a, int alloc){
80106fd0:	f3 0f 1e fb          	endbr32 
80106fd4:	55                   	push   %ebp
  pte=walkpgdir(pgdir,a,0);
80106fd5:	31 c9                	xor    %ecx,%ecx
pte_er_jonno(pde_t *pgdir,pte_t *pte,uint v_a, int alloc){
80106fd7:	89 e5                	mov    %esp,%ebp
  pte=walkpgdir(pgdir,a,0);
80106fd9:	8b 55 10             	mov    0x10(%ebp),%edx
80106fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  }
80106fdf:	5d                   	pop    %ebp
  pte=walkpgdir(pgdir,a,0);
80106fe0:	e9 4b fe ff ff       	jmp    80106e30 <walkpgdir>
80106fe5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <walk>:
walk(pde_t *pgdir, uint v_a, int alloc){
80106ff0:	f3 0f 1e fb          	endbr32 
80106ff4:	55                   	push   %ebp
  pte=walkpgdir(pgdir,a,0);
80106ff5:	31 c9                	xor    %ecx,%ecx
walk(pde_t *pgdir, uint v_a, int alloc){
80106ff7:	89 e5                	mov    %esp,%ebp
80106ff9:	83 ec 08             	sub    $0x8,%esp
  pte=walkpgdir(pgdir,a,0);
80106ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fff:	8b 45 08             	mov    0x8(%ebp),%eax
80107002:	e8 29 fe ff ff       	call   80106e30 <walkpgdir>
  if(*pte & PTE_PG){
80107007:	8b 00                	mov    (%eax),%eax
}
80107009:	c9                   	leave  
  if(*pte & PTE_PG){
8010700a:	c1 e8 09             	shr    $0x9,%eax
8010700d:	83 e0 01             	and    $0x1,%eax
}
80107010:	c3                   	ret    
80107011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701f:	90                   	nop

80107020 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107020:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107024:	a1 a4 3b 12 80       	mov    0x80123ba4,%eax
80107029:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010702e:	0f 22 d8             	mov    %eax,%cr3
}
80107031:	c3                   	ret    
80107032:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107040 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107040:	f3 0f 1e fb          	endbr32 
80107044:	55                   	push   %ebp
80107045:	89 e5                	mov    %esp,%ebp
80107047:	57                   	push   %edi
80107048:	56                   	push   %esi
80107049:	53                   	push   %ebx
8010704a:	83 ec 1c             	sub    $0x1c,%esp
8010704d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107050:	85 f6                	test   %esi,%esi
80107052:	0f 84 cb 00 00 00    	je     80107123 <switchuvm+0xe3>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107058:	8b 46 08             	mov    0x8(%esi),%eax
8010705b:	85 c0                	test   %eax,%eax
8010705d:	0f 84 da 00 00 00    	je     8010713d <switchuvm+0xfd>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80107063:	8b 46 04             	mov    0x4(%esi),%eax
80107066:	85 c0                	test   %eax,%eax
80107068:	0f 84 c2 00 00 00    	je     80107130 <switchuvm+0xf0>
    panic("switchuvm: no pgdir");

  pushcli();
8010706e:	e8 6d d9 ff ff       	call   801049e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107073:	e8 18 cc ff ff       	call   80103c90 <mycpu>
80107078:	89 c3                	mov    %eax,%ebx
8010707a:	e8 11 cc ff ff       	call   80103c90 <mycpu>
8010707f:	89 c7                	mov    %eax,%edi
80107081:	e8 0a cc ff ff       	call   80103c90 <mycpu>
80107086:	83 c7 08             	add    $0x8,%edi
80107089:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010708c:	e8 ff cb ff ff       	call   80103c90 <mycpu>
80107091:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107094:	ba 67 00 00 00       	mov    $0x67,%edx
80107099:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801070a0:	83 c0 08             	add    $0x8,%eax
801070a3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070aa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801070af:	83 c1 08             	add    $0x8,%ecx
801070b2:	c1 e8 18             	shr    $0x18,%eax
801070b5:	c1 e9 10             	shr    $0x10,%ecx
801070b8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801070be:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801070c4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801070c9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070d0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801070d5:	e8 b6 cb ff ff       	call   80103c90 <mycpu>
801070da:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070e1:	e8 aa cb ff ff       	call   80103c90 <mycpu>
801070e6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801070ea:	8b 5e 08             	mov    0x8(%esi),%ebx
801070ed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070f3:	e8 98 cb ff ff       	call   80103c90 <mycpu>
801070f8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070fb:	e8 90 cb ff ff       	call   80103c90 <mycpu>
80107100:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107104:	b8 28 00 00 00       	mov    $0x28,%eax
80107109:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010710c:	8b 46 04             	mov    0x4(%esi),%eax
8010710f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107114:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107117:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010711a:	5b                   	pop    %ebx
8010711b:	5e                   	pop    %esi
8010711c:	5f                   	pop    %edi
8010711d:	5d                   	pop    %ebp
  popcli();
8010711e:	e9 0d d9 ff ff       	jmp    80104a30 <popcli>
    panic("switchuvm: no process");
80107123:	83 ec 0c             	sub    $0xc,%esp
80107126:	68 b6 88 10 80       	push   $0x801088b6
8010712b:	e8 60 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107130:	83 ec 0c             	sub    $0xc,%esp
80107133:	68 e1 88 10 80       	push   $0x801088e1
80107138:	e8 53 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010713d:	83 ec 0c             	sub    $0xc,%esp
80107140:	68 cc 88 10 80       	push   $0x801088cc
80107145:	e8 46 92 ff ff       	call   80100390 <panic>
8010714a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107150 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107150:	f3 0f 1e fb          	endbr32 
80107154:	55                   	push   %ebp
80107155:	89 e5                	mov    %esp,%ebp
80107157:	57                   	push   %edi
80107158:	56                   	push   %esi
80107159:	53                   	push   %ebx
8010715a:	83 ec 1c             	sub    $0x1c,%esp
8010715d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107160:	8b 75 10             	mov    0x10(%ebp),%esi
80107163:	8b 7d 08             	mov    0x8(%ebp),%edi
80107166:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80107169:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010716f:	77 4b                	ja     801071bc <inituvm+0x6c>
    panic("inituvm: more than a page");
  mem = kalloc();
80107171:	e8 3a b8 ff ff       	call   801029b0 <kalloc>
  memset(mem, 0, PGSIZE);
80107176:	83 ec 04             	sub    $0x4,%esp
80107179:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010717e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107180:	6a 00                	push   $0x0
80107182:	50                   	push   %eax
80107183:	e8 68 da ff ff       	call   80104bf0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107188:	58                   	pop    %eax
80107189:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010718f:	5a                   	pop    %edx
80107190:	6a 06                	push   $0x6
80107192:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107197:	31 d2                	xor    %edx,%edx
80107199:	50                   	push   %eax
8010719a:	89 f8                	mov    %edi,%eax
8010719c:	e8 0f fd ff ff       	call   80106eb0 <mappages>
  memmove(mem, init, sz);
801071a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071a4:	89 75 10             	mov    %esi,0x10(%ebp)
801071a7:	83 c4 10             	add    $0x10,%esp
801071aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801071ad:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801071b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b3:	5b                   	pop    %ebx
801071b4:	5e                   	pop    %esi
801071b5:	5f                   	pop    %edi
801071b6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801071b7:	e9 d4 da ff ff       	jmp    80104c90 <memmove>
    panic("inituvm: more than a page");
801071bc:	83 ec 0c             	sub    $0xc,%esp
801071bf:	68 f5 88 10 80       	push   $0x801088f5
801071c4:	e8 c7 91 ff ff       	call   80100390 <panic>
801071c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071d0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801071d0:	f3 0f 1e fb          	endbr32 
801071d4:	55                   	push   %ebp
801071d5:	89 e5                	mov    %esp,%ebp
801071d7:	57                   	push   %edi
801071d8:	56                   	push   %esi
801071d9:	53                   	push   %ebx
801071da:	83 ec 1c             	sub    $0x1c,%esp
801071dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801071e0:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801071e3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801071e8:	0f 85 99 00 00 00    	jne    80107287 <loaduvm+0xb7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801071ee:	01 f0                	add    %esi,%eax
801071f0:	89 f3                	mov    %esi,%ebx
801071f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071f5:	8b 45 14             	mov    0x14(%ebp),%eax
801071f8:	01 f0                	add    %esi,%eax
801071fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801071fd:	85 f6                	test   %esi,%esi
801071ff:	75 15                	jne    80107216 <loaduvm+0x46>
80107201:	eb 6d                	jmp    80107270 <loaduvm+0xa0>
80107203:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107207:	90                   	nop
80107208:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010720e:	89 f0                	mov    %esi,%eax
80107210:	29 d8                	sub    %ebx,%eax
80107212:	39 c6                	cmp    %eax,%esi
80107214:	76 5a                	jbe    80107270 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107216:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107219:	8b 45 08             	mov    0x8(%ebp),%eax
8010721c:	31 c9                	xor    %ecx,%ecx
8010721e:	29 da                	sub    %ebx,%edx
80107220:	e8 0b fc ff ff       	call   80106e30 <walkpgdir>
80107225:	85 c0                	test   %eax,%eax
80107227:	74 51                	je     8010727a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107229:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010722b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010722e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107233:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107238:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010723e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107241:	29 d9                	sub    %ebx,%ecx
80107243:	05 00 00 00 80       	add    $0x80000000,%eax
80107248:	57                   	push   %edi
80107249:	51                   	push   %ecx
8010724a:	50                   	push   %eax
8010724b:	ff 75 10             	pushl  0x10(%ebp)
8010724e:	e8 0d a8 ff ff       	call   80101a60 <readi>
80107253:	83 c4 10             	add    $0x10,%esp
80107256:	39 f8                	cmp    %edi,%eax
80107258:	74 ae                	je     80107208 <loaduvm+0x38>
      return -1;
  }
  return 0;
}
8010725a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010725d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107262:	5b                   	pop    %ebx
80107263:	5e                   	pop    %esi
80107264:	5f                   	pop    %edi
80107265:	5d                   	pop    %ebp
80107266:	c3                   	ret    
80107267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726e:	66 90                	xchg   %ax,%ax
80107270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107273:	31 c0                	xor    %eax,%eax
}
80107275:	5b                   	pop    %ebx
80107276:	5e                   	pop    %esi
80107277:	5f                   	pop    %edi
80107278:	5d                   	pop    %ebp
80107279:	c3                   	ret    
      panic("loaduvm: address should exist");
8010727a:	83 ec 0c             	sub    $0xc,%esp
8010727d:	68 0f 89 10 80       	push   $0x8010890f
80107282:	e8 09 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107287:	83 ec 0c             	sub    $0xc,%esp
8010728a:	68 90 8a 10 80       	push   $0x80108a90
8010728f:	e8 fc 90 ff ff       	call   80100390 <panic>
80107294:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010729f:	90                   	nop

801072a0 <deletePageFromRAM>:
    cprintf("%d --> %d\n",p->f_page_tra[kp].virtual_addr,p->f_page_tra[kp].offset);
    }  
  }
  return newsz;
}
void deletePageFromRAM(struct proc *p, int i,uint va,int reform){
801072a0:	f3 0f 1e fb          	endbr32 
801072a4:	55                   	push   %ebp
801072a5:	89 e5                	mov    %esp,%ebp
801072a7:	57                   	push   %edi
801072a8:	56                   	push   %esi
801072a9:	53                   	push   %ebx
801072aa:	83 ec 18             	sub    $0x18,%esp
801072ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
801072b0:	8b 75 10             	mov    0x10(%ebp),%esi

  //struct Node* temp;
  cprintf("deleting the page\n");
801072b3:	68 2d 89 10 80       	push   $0x8010892d
801072b8:	e8 f3 93 ff ff       	call   801006b0 <cprintf>
  cprintf("process id , va : %d %d\n",p->pid,p->list_arrays[i].v_address);
801072bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
801072c0:	83 c4 0c             	add    $0xc,%esp
801072c3:	c1 e7 04             	shl    $0x4,%edi
801072c6:	01 df                	add    %ebx,%edi
801072c8:	ff b7 fc 00 00 00    	pushl  0xfc(%edi)
801072ce:	ff 73 10             	pushl  0x10(%ebx)
801072d1:	68 40 89 10 80       	push   $0x80108940
801072d6:	e8 d5 93 ff ff       	call   801006b0 <cprintf>
  p->page_number--;
  if(reform) {
801072db:	8b 45 14             	mov    0x14(%ebp),%eax
  p->page_number--;
801072de:	83 ab 80 00 00 00 01 	subl   $0x1,0x80(%ebx)
  if(reform) {
801072e5:	83 c4 10             	add    $0x10,%esp
801072e8:	85 c0                	test   %eax,%eax
801072ea:	74 1e                	je     8010730a <deletePageFromRAM+0x6a>

    p->list_arrays[i].v_address=0;
801072ec:	c7 87 fc 00 00 00 00 	movl   $0x0,0xfc(%edi)
801072f3:	00 00 00 
    p->list_arrays[i].counter=0;
801072f6:	c7 87 08 01 00 00 00 	movl   $0x0,0x108(%edi)
801072fd:	00 00 00 
    p->list_arrays[i].pGDIR=0;
80107300:	c7 87 04 01 00 00 00 	movl   $0x0,0x104(%edi)
80107307:	00 00 00 
8010730a:	8d 83 84 00 00 00    	lea    0x84(%ebx),%eax
80107310:	8d 93 fc 00 00 00    	lea    0xfc(%ebx),%edx
80107316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010731d:	8d 76 00             	lea    0x0(%esi),%esi
    //p->matha=p->matha->nxt;
  }
  int it;
  //temp=p->matha;
     for(it=0;it<30;it++){
       if(p->list_arr[it]==va){
80107320:	39 30                	cmp    %esi,(%eax)
80107322:	75 06                	jne    8010732a <deletePageFromRAM+0x8a>
         p->list_arr[it]=0;
80107324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     for(it=0;it<30;it++){
8010732a:	83 c0 04             	add    $0x4,%eax
8010732d:	39 d0                	cmp    %edx,%eax
8010732f:	75 ef                	jne    80107320 <deletePageFromRAM+0x80>
  //   }
  //     cprintf("After deallocation of pages(virtual addresses): %d\n",temp->v_address);
  //     temp=temp->nxt;  
  // }
    
}
80107331:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107334:	5b                   	pop    %ebx
80107335:	5e                   	pop    %esi
80107336:	5f                   	pop    %edi
80107337:	5d                   	pop    %ebp
80107338:	c3                   	ret    
80107339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107340 <removingPagesFromMemory.part.0>:
void removingPagesFromMemory(struct proc *p, uint va, const pde_t *pgdir){
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	56                   	push   %esi

  if (p == 0)
    return;

  int i;
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107344:	31 f6                	xor    %esi,%esi
void removingPagesFromMemory(struct proc *p, uint va, const pde_t *pgdir){
80107346:	53                   	push   %ebx
80107347:	8d 98 fc 00 00 00    	lea    0xfc(%eax),%ebx
8010734d:	eb 0c                	jmp    8010735b <removingPagesFromMemory.part.0+0x1b>
8010734f:	90                   	nop
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
80107350:	83 c6 01             	add    $0x1,%esi
80107353:	83 c3 10             	add    $0x10,%ebx
80107356:	83 fe 06             	cmp    $0x6,%esi
80107359:	74 16                	je     80107371 <removingPagesFromMemory.part.0+0x31>
    if ((p->list_arrays[i].v_address == va)
8010735b:	39 13                	cmp    %edx,(%ebx)
8010735d:	75 f1                	jne    80107350 <removingPagesFromMemory.part.0+0x10>
        && (p->list_arrays[i].pGDIR == pgdir)){
8010735f:	39 4b 08             	cmp    %ecx,0x8(%ebx)
80107362:	75 ec                	jne    80107350 <removingPagesFromMemory.part.0+0x10>

      deletePageFromRAM(p, i,va,1);
80107364:	6a 01                	push   $0x1
80107366:	52                   	push   %edx
80107367:	56                   	push   %esi
80107368:	50                   	push   %eax
80107369:	e8 32 ff ff ff       	call   801072a0 <deletePageFromRAM>

      return;
8010736e:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80107371:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107374:	5b                   	pop    %ebx
80107375:	5e                   	pop    %esi
80107376:	5d                   	pop    %ebp
80107377:	c3                   	ret    
80107378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737f:	90                   	nop

80107380 <removingPagesFromMemory>:
void removingPagesFromMemory(struct proc *p, uint va, const pde_t *pgdir){
80107380:	f3 0f 1e fb          	endbr32 
80107384:	55                   	push   %ebp
80107385:	89 e5                	mov    %esp,%ebp
80107387:	8b 45 08             	mov    0x8(%ebp),%eax
8010738a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010738d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if (p == 0)
80107390:	85 c0                	test   %eax,%eax
80107392:	74 0c                	je     801073a0 <removingPagesFromMemory+0x20>
}
80107394:	5d                   	pop    %ebp
80107395:	eb a9                	jmp    80107340 <removingPagesFromMemory.part.0>
80107397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739e:	66 90                	xchg   %ax,%ax
801073a0:	5d                   	pop    %ebp
801073a1:	c3                   	ret    
801073a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073b0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{ 
801073b0:	f3 0f 1e fb          	endbr32 
801073b4:	55                   	push   %ebp
801073b5:	89 e5                	mov    %esp,%ebp
801073b7:	57                   	push   %edi
801073b8:	56                   	push   %esi
801073b9:	53                   	push   %ebx
801073ba:	83 ec 1c             	sub    $0x1c,%esp
801073bd:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc* p = myproc();
801073c0:	e8 5b c9 ff ff       	call   80103d20 <myproc>
801073c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(p==0){
801073c8:	85 c0                	test   %eax,%eax
801073ca:	0f 84 d0 00 00 00    	je     801074a0 <deallocuvm+0xf0>
    return oldsz;
  }
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801073d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801073d3:	39 45 10             	cmp    %eax,0x10(%ebp)
801073d6:	0f 83 c4 00 00 00    	jae    801074a0 <deallocuvm+0xf0>
    return oldsz;

  a = PGROUNDUP(newsz);
801073dc:	8b 45 10             	mov    0x10(%ebp),%eax
801073df:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801073e5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801073eb:	89 d7                	mov    %edx,%edi
801073ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(; a  < oldsz; a += PGSIZE){
801073f0:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801073f3:	76 22                	jbe    80107417 <deallocuvm+0x67>
    pte = walkpgdir(pgdir, (char*)a, 0);
801073f5:	31 c9                	xor    %ecx,%ecx
801073f7:	89 fa                	mov    %edi,%edx
801073f9:	89 f0                	mov    %esi,%eax
801073fb:	e8 30 fa ff ff       	call   80106e30 <walkpgdir>
80107400:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107402:	85 c0                	test   %eax,%eax
80107404:	74 5a                	je     80107460 <deallocuvm+0xb0>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107406:	8b 00                	mov    (%eax),%eax
80107408:	a8 01                	test   $0x1,%al
8010740a:	75 1c                	jne    80107428 <deallocuvm+0x78>
8010740c:	81 c7 00 10 00 00    	add    $0x1000,%edi
  for(; a  < oldsz; a += PGSIZE){
80107412:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107415:	77 de                	ja     801073f5 <deallocuvm+0x45>
      //kfree protibar call hoy page free korar jonno process end a

     
    }
  
  return newsz;
80107417:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010741a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010741d:	5b                   	pop    %ebx
8010741e:	5e                   	pop    %esi
8010741f:	5f                   	pop    %edi
80107420:	5d                   	pop    %ebp
80107421:	c3                   	ret    
80107422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(pa == 0)
80107428:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010742d:	74 7c                	je     801074ab <deallocuvm+0xfb>
      kfree(v);
8010742f:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107432:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107437:	50                   	push   %eax
80107438:	e8 b3 b3 ff ff       	call   801027f0 <kfree>
      if((p->pid)>2){
8010743d:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
80107443:	83 c4 10             	add    $0x10,%esp
80107446:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107449:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010744c:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107450:	7f 1e                	jg     80107470 <deallocuvm+0xc0>
80107452:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  for(; a  < oldsz; a += PGSIZE){
80107455:	eb 99                	jmp    801073f0 <deallocuvm+0x40>
80107457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010745e:	66 90                	xchg   %ax,%ax
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107460:	89 fa                	mov    %edi,%edx
80107462:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107468:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010746e:	eb 80                	jmp    801073f0 <deallocuvm+0x40>
        cprintf("deallocuvm: matched virtual addresses %d\n",a);
80107470:	83 ec 08             	sub    $0x8,%esp
80107473:	57                   	push   %edi
80107474:	68 b4 8a 10 80       	push   $0x80108ab4
80107479:	e8 32 92 ff ff       	call   801006b0 <cprintf>
  if (p == 0)
8010747e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107481:	89 fa                	mov    %edi,%edx
80107483:	89 f1                	mov    %esi,%ecx
80107485:	e8 b6 fe ff ff       	call   80107340 <removingPagesFromMemory.part.0>
        *pte = 0;
8010748a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107490:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107493:	83 c4 10             	add    $0x10,%esp
80107496:	e9 55 ff ff ff       	jmp    801073f0 <deallocuvm+0x40>
8010749b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010749f:	90                   	nop
    return oldsz;
801074a0:	8b 45 0c             	mov    0xc(%ebp),%eax
}
801074a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074a6:	5b                   	pop    %ebx
801074a7:	5e                   	pop    %esi
801074a8:	5f                   	pop    %edi
801074a9:	5d                   	pop    %ebp
801074aa:	c3                   	ret    
        panic("kfree");
801074ab:	83 ec 0c             	sub    $0xc,%esp
801074ae:	68 4a 80 10 80       	push   $0x8010804a
801074b3:	e8 d8 8e ff ff       	call   80100390 <panic>
801074b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bf:	90                   	nop

801074c0 <allocuvm>:
{
801074c0:	f3 0f 1e fb          	endbr32 
801074c4:	55                   	push   %ebp
801074c5:	89 e5                	mov    %esp,%ebp
801074c7:	57                   	push   %edi
801074c8:	56                   	push   %esi
801074c9:	53                   	push   %ebx
801074ca:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p=myproc();
801074cd:	e8 4e c8 ff ff       	call   80103d20 <myproc>
801074d2:	89 c3                	mov    %eax,%ebx
  if(newsz >= KERNBASE)
801074d4:	8b 45 10             	mov    0x10(%ebp),%eax
801074d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074da:	85 c0                	test   %eax,%eax
801074dc:	0f 88 6e 01 00 00    	js     80107650 <allocuvm+0x190>
  if(newsz < oldsz)
801074e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801074e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801074e8:	0f 82 f2 00 00 00    	jb     801075e0 <allocuvm+0x120>
  a = PGROUNDUP(oldsz);
801074ee:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
            p->matha=&p->list_arrays[p->page_number];
801074f4:	8d 83 fc 00 00 00    	lea    0xfc(%ebx),%eax
801074fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074fd:	8d 83 9c 00 00 00    	lea    0x9c(%ebx),%eax
  a = PGROUNDUP(oldsz);
80107503:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107509:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010750c:	39 75 10             	cmp    %esi,0x10(%ebp)
8010750f:	77 5a                	ja     8010756b <allocuvm+0xab>
80107511:	e9 3a 02 00 00       	jmp    80107750 <allocuvm+0x290>
80107516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751d:	8d 76 00             	lea    0x0(%esi),%esi
        memset(mem, 0, PGSIZE);
80107520:	83 ec 04             	sub    $0x4,%esp
80107523:	68 00 10 00 00       	push   $0x1000
80107528:	6a 00                	push   $0x0
8010752a:	57                   	push   %edi
8010752b:	e8 c0 d6 ff ff       	call   80104bf0 <memset>
        if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107530:	58                   	pop    %eax
80107531:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107537:	5a                   	pop    %edx
80107538:	6a 06                	push   $0x6
8010753a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010753f:	89 f2                	mov    %esi,%edx
80107541:	50                   	push   %eax
80107542:	8b 45 08             	mov    0x8(%ebp),%eax
80107545:	e8 66 f9 ff ff       	call   80106eb0 <mappages>
8010754a:	83 c4 10             	add    $0x10,%esp
8010754d:	85 c0                	test   %eax,%eax
8010754f:	0f 88 cb 02 00 00    	js     80107820 <allocuvm+0x360>
     p->page_number++;
80107555:	83 83 80 00 00 00 01 	addl   $0x1,0x80(%ebx)
  for(; a < newsz; a += PGSIZE){
8010755c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107562:	39 75 10             	cmp    %esi,0x10(%ebp)
80107565:	0f 86 e5 01 00 00    	jbe    80107750 <allocuvm+0x290>
    mem = kalloc();
8010756b:	e8 40 b4 ff ff       	call   801029b0 <kalloc>
80107570:	89 c7                	mov    %eax,%edi
    if(mem == 0){
80107572:	85 c0                	test   %eax,%eax
80107574:	0f 84 6e 02 00 00    	je     801077e8 <allocuvm+0x328>
      if(p->pid>2){
8010757a:	8b 43 10             	mov    0x10(%ebx),%eax
8010757d:	83 f8 02             	cmp    $0x2,%eax
80107580:	7e 9e                	jle    80107520 <allocuvm+0x60>
        cprintf("pid,page_number:%d,%d,%d\n",p->pid,p->page_number,a);
80107582:	56                   	push   %esi
80107583:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80107589:	50                   	push   %eax
8010758a:	68 71 89 10 80       	push   $0x80108971
8010758f:	e8 1c 91 ff ff       	call   801006b0 <cprintf>
      if((p->page_number)>MAX_PSYC_PAGES){
80107594:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010759a:	83 c4 10             	add    $0x10,%esp
8010759d:	83 f8 06             	cmp    $0x6,%eax
801075a0:	0f 87 c2 00 00 00    	ja     80107668 <allocuvm+0x1a8>
      if(p->page_number==0){
801075a6:	85 c0                	test   %eax,%eax
801075a8:	75 46                	jne    801075f0 <allocuvm+0x130>
            p->list_arrays[p->page_number].pGDIR=pgdir;
801075aa:	8b 45 08             	mov    0x8(%ebp),%eax
            p->list_arrays[p->page_number].v_address=a;
801075ad:	89 b3 fc 00 00 00    	mov    %esi,0xfc(%ebx)
            p->list_arrays[p->page_number].nxt=0;
801075b3:	c7 83 00 01 00 00 00 	movl   $0x0,0x100(%ebx)
801075ba:	00 00 00 
            p->list_arrays[p->page_number].pGDIR=pgdir;
801075bd:	89 83 04 01 00 00    	mov    %eax,0x104(%ebx)
            p->matha=&p->list_arrays[p->page_number];
801075c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
            p->list_arr[p->page_number]=a;
801075c6:	89 b3 84 00 00 00    	mov    %esi,0x84(%ebx)
            p->matha=&p->list_arrays[p->page_number];
801075cc:	89 83 dc 02 00 00    	mov    %eax,0x2dc(%ebx)
            p->temp=p->matha;
801075d2:	89 83 e0 02 00 00    	mov    %eax,0x2e0(%ebx)
            p->list_arr[p->page_number]=a;
801075d8:	e9 43 ff ff ff       	jmp    80107520 <allocuvm+0x60>
801075dd:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
801075e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801075e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075e9:	5b                   	pop    %ebx
801075ea:	5e                   	pop    %esi
801075eb:	5f                   	pop    %edi
801075ec:	5d                   	pop    %ebp
801075ed:	c3                   	ret    
801075ee:	66 90                	xchg   %ax,%ax
        p->list_arrays[p->page_number].v_address=a;
801075f0:	89 c2                	mov    %eax,%edx
        p->temp->nxt=&p->list_arrays[p->page_number];
801075f2:	c1 e0 04             	shl    $0x4,%eax
        p->list_arrays[p->page_number].pGDIR=pgdir;
801075f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
801075f8:	c1 e2 04             	shl    $0x4,%edx
        p->temp->nxt=&p->list_arrays[p->page_number];
801075fb:	8d 84 03 fc 00 00 00 	lea    0xfc(%ebx,%eax,1),%eax
80107602:	01 da                	add    %ebx,%edx
        p->list_arrays[p->page_number].v_address=a;
80107604:	89 b2 fc 00 00 00    	mov    %esi,0xfc(%edx)
        p->list_arrays[p->page_number].nxt=0;
8010760a:	c7 82 00 01 00 00 00 	movl   $0x0,0x100(%edx)
80107611:	00 00 00 
        p->temp->nxt=&p->list_arrays[p->page_number];
80107614:	8b 93 e0 02 00 00    	mov    0x2e0(%ebx),%edx
8010761a:	89 42 04             	mov    %eax,0x4(%edx)
        p->list_arrays[p->page_number].pGDIR=pgdir;
8010761d:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80107623:	89 c2                	mov    %eax,%edx
80107625:	c1 e2 04             	shl    $0x4,%edx
80107628:	89 8c 1a 04 01 00 00 	mov    %ecx,0x104(%edx,%ebx,1)
        p->list_arr[p->page_number]=a;
8010762f:	89 b4 83 84 00 00 00 	mov    %esi,0x84(%ebx,%eax,4)
        p->temp=p->temp->nxt;
80107636:	8b 83 e0 02 00 00    	mov    0x2e0(%ebx),%eax
8010763c:	8b 40 04             	mov    0x4(%eax),%eax
8010763f:	89 83 e0 02 00 00    	mov    %eax,0x2e0(%ebx)
80107645:	e9 d6 fe ff ff       	jmp    80107520 <allocuvm+0x60>
8010764a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return 0;
80107650:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010765a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010765d:	5b                   	pop    %ebx
8010765e:	5e                   	pop    %esi
8010765f:	5f                   	pop    %edi
80107660:	5d                   	pop    %ebp
80107661:	c3                   	ret    
80107662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cprintf("allocuvm: MAX_PSYC_PAGES er cheye beshi hocche page.\n");
80107668:	83 ec 0c             	sub    $0xc,%esp
8010766b:	68 e0 8a 10 80       	push   $0x80108ae0
80107670:	e8 3b 90 ff ff       	call   801006b0 <cprintf>
          uint va=p->matha->v_address;
80107675:	8b 83 dc 02 00 00    	mov    0x2dc(%ebx),%eax
          cprintf(" va  %d\n",va);
8010767b:	59                   	pop    %ecx
8010767c:	5a                   	pop    %edx
          uint va=p->matha->v_address;
8010767d:	8b 00                	mov    (%eax),%eax
          cprintf(" va  %d\n",va);
8010767f:	50                   	push   %eax
80107680:	68 8b 89 10 80       	push   $0x8010898b
80107685:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107688:	e8 23 90 ff ff       	call   801006b0 <cprintf>
          cprintf("write er ager offset :%d\n",p->offset_swapfile);
8010768d:	59                   	pop    %ecx
8010768e:	58                   	pop    %eax
8010768f:	ff b3 e4 02 00 00    	pushl  0x2e4(%ebx)
80107695:	68 94 89 10 80       	push   $0x80108994
8010769a:	e8 11 90 ff ff       	call   801006b0 <cprintf>
          writeToSwapFile(p,(char*)PTE_ADDR(va),p->offset_swapfile,PGSIZE);
8010769f:	8b 45 dc             	mov    -0x24(%ebp),%eax
801076a2:	68 00 10 00 00       	push   $0x1000
801076a7:	ff b3 e4 02 00 00    	pushl  0x2e4(%ebx)
801076ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076b2:	50                   	push   %eax
801076b3:	53                   	push   %ebx
801076b4:	e8 d7 ac ff ff       	call   80102390 <writeToSwapFile>
          pte=walkpgdir(pgdir,(char*)va,0);
801076b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801076bc:	8b 45 08             	mov    0x8(%ebp),%eax
801076bf:	31 c9                	xor    %ecx,%ecx
801076c1:	83 c4 20             	add    $0x20,%esp
801076c4:	e8 67 f7 ff ff       	call   80106e30 <walkpgdir>
          *pte&=(~PTE_P);
801076c9:	8b 10                	mov    (%eax),%edx
801076cb:	83 e2 fe             	and    $0xfffffffe,%edx
801076ce:	80 ce 02             	or     $0x2,%dh
801076d1:	89 10                	mov    %edx,(%eax)
          p->f_page_tra[p->page_number].offset=p->offset_swapfile;
801076d3:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801076d9:	8b 8b e4 02 00 00    	mov    0x2e4(%ebx),%ecx
801076df:	8d 14 c3             	lea    (%ebx,%eax,8),%edx
801076e2:	89 8a ec 02 00 00    	mov    %ecx,0x2ec(%edx)
801076e8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
          p->f_page_tra[p->page_number].virtual_addr=va;
801076eb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801076ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
801076f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801076f4:	89 8a e8 02 00 00    	mov    %ecx,0x2e8(%edx)
          p->matha=p->matha->nxt;
801076fa:	8b 93 dc 02 00 00    	mov    0x2dc(%ebx),%edx
80107700:	8b 52 04             	mov    0x4(%edx),%edx
          p->list_arr[0]=0;
80107703:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010770a:	00 00 00 
          p->matha=p->matha->nxt;
8010770d:	89 93 dc 02 00 00    	mov    %edx,0x2dc(%ebx)
          for(int j=0;j<MAX_PSYC_PAGES;j++){
80107713:	8d 93 84 00 00 00    	lea    0x84(%ebx),%edx
80107719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            p->list_arr[j]=p->list_arr[j+1];
80107720:	8b 4a 04             	mov    0x4(%edx),%ecx
80107723:	83 c2 04             	add    $0x4,%edx
80107726:	89 4a fc             	mov    %ecx,-0x4(%edx)
          for(int j=0;j<MAX_PSYC_PAGES;j++){
80107729:	39 c2                	cmp    %eax,%edx
8010772b:	75 f3                	jne    80107720 <allocuvm+0x260>
          p->offset_swapfile=p->offset_swapfile+PGSIZE;
8010772d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80107730:	8b 45 dc             	mov    -0x24(%ebp),%eax
          p->list_arr[MAX_PSYC_PAGES]=a;
80107733:	89 b3 9c 00 00 00    	mov    %esi,0x9c(%ebx)
          p->offset_swapfile=p->offset_swapfile+PGSIZE;
80107739:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010773f:	89 8b e4 02 00 00    	mov    %ecx,0x2e4(%ebx)
80107745:	e9 5c fe ff ff       	jmp    801075a6 <allocuvm+0xe6>
8010774a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(p->pid>2){
80107750:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80107754:	0f 8e 89 fe ff ff    	jle    801075e3 <allocuvm+0x123>
  cprintf(" Allocuvm: array jegula main memory te ache \n");
8010775a:	83 ec 0c             	sub    $0xc,%esp
  for(int kp=0;kp<MAX_PSYC_PAGES+1;kp++){
8010775d:	31 f6                	xor    %esi,%esi
  cprintf(" Allocuvm: array jegula main memory te ache \n");
8010775f:	68 18 8b 10 80       	push   $0x80108b18
80107764:	e8 47 8f ff ff       	call   801006b0 <cprintf>
80107769:	83 c4 10             	add    $0x10,%esp
8010776c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d--> %d\n",kp,p->list_arr[kp]);
80107770:	83 ec 04             	sub    $0x4,%esp
80107773:	ff b4 b3 84 00 00 00 	pushl  0x84(%ebx,%esi,4)
8010777a:	56                   	push   %esi
  for(int kp=0;kp<MAX_PSYC_PAGES+1;kp++){
8010777b:	83 c6 01             	add    $0x1,%esi
    cprintf("%d--> %d\n",kp,p->list_arr[kp]);
8010777e:	68 ca 89 10 80       	push   $0x801089ca
80107783:	e8 28 8f ff ff       	call   801006b0 <cprintf>
  for(int kp=0;kp<MAX_PSYC_PAGES+1;kp++){
80107788:	83 c4 10             	add    $0x10,%esp
8010778b:	83 fe 07             	cmp    $0x7,%esi
8010778e:	75 e0                	jne    80107770 <allocuvm+0x2b0>
  cprintf(" array jegula swapfile a thakar kotha \n");
80107790:	83 ec 0c             	sub    $0xc,%esp
80107793:	8d b3 e8 02 00 00    	lea    0x2e8(%ebx),%esi
80107799:	81 c3 40 03 00 00    	add    $0x340,%ebx
8010779f:	68 48 8b 10 80       	push   $0x80108b48
801077a4:	e8 07 8f ff ff       	call   801006b0 <cprintf>
  cprintf("virtual address --> offset \n");
801077a9:	c7 04 24 d4 89 10 80 	movl   $0x801089d4,(%esp)
801077b0:	e8 fb 8e ff ff       	call   801006b0 <cprintf>
    for(int kp=0;kp<11;kp++){
801077b5:	83 c4 10             	add    $0x10,%esp
801077b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077bf:	90                   	nop
    cprintf("%d --> %d\n",p->f_page_tra[kp].virtual_addr,p->f_page_tra[kp].offset);
801077c0:	83 ec 04             	sub    $0x4,%esp
801077c3:	ff 76 04             	pushl  0x4(%esi)
801077c6:	83 c6 08             	add    $0x8,%esi
801077c9:	ff 76 f8             	pushl  -0x8(%esi)
801077cc:	68 f1 89 10 80       	push   $0x801089f1
801077d1:	e8 da 8e ff ff       	call   801006b0 <cprintf>
    for(int kp=0;kp<11;kp++){
801077d6:	83 c4 10             	add    $0x10,%esp
801077d9:	39 f3                	cmp    %esi,%ebx
801077db:	75 e3                	jne    801077c0 <allocuvm+0x300>
801077dd:	e9 01 fe ff ff       	jmp    801075e3 <allocuvm+0x123>
801077e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
801077e8:	83 ec 0c             	sub    $0xc,%esp
801077eb:	68 59 89 10 80       	push   $0x80108959
801077f0:	e8 bb 8e ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801077f5:	83 c4 0c             	add    $0xc,%esp
801077f8:	ff 75 0c             	pushl  0xc(%ebp)
801077fb:	ff 75 10             	pushl  0x10(%ebp)
801077fe:	ff 75 08             	pushl  0x8(%ebp)
80107801:	e8 aa fb ff ff       	call   801073b0 <deallocuvm>
      return 0;
80107806:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010780d:	83 c4 10             	add    $0x10,%esp
}
80107810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107813:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107816:	5b                   	pop    %ebx
80107817:	5e                   	pop    %esi
80107818:	5f                   	pop    %edi
80107819:	5d                   	pop    %ebp
8010781a:	c3                   	ret    
8010781b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010781f:	90                   	nop
        cprintf("allocuvm out of memory (2)\n");
80107820:	83 ec 0c             	sub    $0xc,%esp
80107823:	68 ae 89 10 80       	push   $0x801089ae
80107828:	e8 83 8e ff ff       	call   801006b0 <cprintf>
        deallocuvm(pgdir, newsz, oldsz);
8010782d:	83 c4 0c             	add    $0xc,%esp
80107830:	ff 75 0c             	pushl  0xc(%ebp)
80107833:	ff 75 10             	pushl  0x10(%ebp)
80107836:	ff 75 08             	pushl  0x8(%ebp)
80107839:	e8 72 fb ff ff       	call   801073b0 <deallocuvm>
        kfree(mem);
8010783e:	89 3c 24             	mov    %edi,(%esp)
80107841:	e8 aa af ff ff       	call   801027f0 <kfree>
        return 0;
80107846:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010784d:	83 c4 10             	add    $0x10,%esp
}
80107850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107853:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107856:	5b                   	pop    %ebx
80107857:	5e                   	pop    %esi
80107858:	5f                   	pop    %edi
80107859:	5d                   	pop    %ebp
8010785a:	c3                   	ret    
8010785b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010785f:	90                   	nop

80107860 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107860:	f3 0f 1e fb          	endbr32 
80107864:	55                   	push   %ebp
80107865:	89 e5                	mov    %esp,%ebp
80107867:	57                   	push   %edi
80107868:	56                   	push   %esi
80107869:	53                   	push   %ebx
8010786a:	83 ec 0c             	sub    $0xc,%esp
8010786d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107870:	85 f6                	test   %esi,%esi
80107872:	74 5d                	je     801078d1 <freevm+0x71>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107874:	83 ec 04             	sub    $0x4,%esp
80107877:	89 f3                	mov    %esi,%ebx
80107879:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010787f:	6a 00                	push   $0x0
80107881:	68 00 00 00 80       	push   $0x80000000
80107886:	56                   	push   %esi
80107887:	e8 24 fb ff ff       	call   801073b0 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010788c:	83 c4 10             	add    $0x10,%esp
8010788f:	eb 0e                	jmp    8010789f <freevm+0x3f>
80107891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107898:	83 c3 04             	add    $0x4,%ebx
8010789b:	39 df                	cmp    %ebx,%edi
8010789d:	74 23                	je     801078c2 <freevm+0x62>
    if(pgdir[i] & PTE_P){
8010789f:	8b 03                	mov    (%ebx),%eax
801078a1:	a8 01                	test   $0x1,%al
801078a3:	74 f3                	je     80107898 <freevm+0x38>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801078aa:	83 ec 0c             	sub    $0xc,%esp
801078ad:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078b0:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801078b5:	50                   	push   %eax
801078b6:	e8 35 af ff ff       	call   801027f0 <kfree>
801078bb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801078be:	39 df                	cmp    %ebx,%edi
801078c0:	75 dd                	jne    8010789f <freevm+0x3f>
    }
  }
  kfree((char*)pgdir);
801078c2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801078c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078c8:	5b                   	pop    %ebx
801078c9:	5e                   	pop    %esi
801078ca:	5f                   	pop    %edi
801078cb:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801078cc:	e9 1f af ff ff       	jmp    801027f0 <kfree>
    panic("freevm: no pgdir");
801078d1:	83 ec 0c             	sub    $0xc,%esp
801078d4:	68 fc 89 10 80       	push   $0x801089fc
801078d9:	e8 b2 8a ff ff       	call   80100390 <panic>
801078de:	66 90                	xchg   %ax,%ax

801078e0 <setupkvm>:
{
801078e0:	f3 0f 1e fb          	endbr32 
801078e4:	55                   	push   %ebp
801078e5:	89 e5                	mov    %esp,%ebp
801078e7:	56                   	push   %esi
801078e8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801078e9:	e8 c2 b0 ff ff       	call   801029b0 <kalloc>
801078ee:	89 c6                	mov    %eax,%esi
801078f0:	85 c0                	test   %eax,%eax
801078f2:	74 42                	je     80107936 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801078f4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078f7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801078fc:	68 00 10 00 00       	push   $0x1000
80107901:	6a 00                	push   $0x0
80107903:	50                   	push   %eax
80107904:	e8 e7 d2 ff ff       	call   80104bf0 <memset>
80107909:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010790c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010790f:	83 ec 08             	sub    $0x8,%esp
80107912:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107915:	ff 73 0c             	pushl  0xc(%ebx)
80107918:	8b 13                	mov    (%ebx),%edx
8010791a:	50                   	push   %eax
8010791b:	29 c1                	sub    %eax,%ecx
8010791d:	89 f0                	mov    %esi,%eax
8010791f:	e8 8c f5 ff ff       	call   80106eb0 <mappages>
80107924:	83 c4 10             	add    $0x10,%esp
80107927:	85 c0                	test   %eax,%eax
80107929:	78 15                	js     80107940 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010792b:	83 c3 10             	add    $0x10,%ebx
8010792e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107934:	75 d6                	jne    8010790c <setupkvm+0x2c>
}
80107936:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107939:	89 f0                	mov    %esi,%eax
8010793b:	5b                   	pop    %ebx
8010793c:	5e                   	pop    %esi
8010793d:	5d                   	pop    %ebp
8010793e:	c3                   	ret    
8010793f:	90                   	nop
      freevm(pgdir);
80107940:	83 ec 0c             	sub    $0xc,%esp
80107943:	56                   	push   %esi
      return 0;
80107944:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107946:	e8 15 ff ff ff       	call   80107860 <freevm>
      return 0;
8010794b:	83 c4 10             	add    $0x10,%esp
}
8010794e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107951:	89 f0                	mov    %esi,%eax
80107953:	5b                   	pop    %ebx
80107954:	5e                   	pop    %esi
80107955:	5d                   	pop    %ebp
80107956:	c3                   	ret    
80107957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010795e:	66 90                	xchg   %ax,%ax

80107960 <kvmalloc>:
{
80107960:	f3 0f 1e fb          	endbr32 
80107964:	55                   	push   %ebp
80107965:	89 e5                	mov    %esp,%ebp
80107967:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010796a:	e8 71 ff ff ff       	call   801078e0 <setupkvm>
8010796f:	a3 a4 3b 12 80       	mov    %eax,0x80123ba4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107974:	05 00 00 00 80       	add    $0x80000000,%eax
80107979:	0f 22 d8             	mov    %eax,%cr3
}
8010797c:	c9                   	leave  
8010797d:	c3                   	ret    
8010797e:	66 90                	xchg   %ax,%ax

80107980 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107980:	f3 0f 1e fb          	endbr32 
80107984:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107985:	31 c9                	xor    %ecx,%ecx
{
80107987:	89 e5                	mov    %esp,%ebp
80107989:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010798c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010798f:	8b 45 08             	mov    0x8(%ebp),%eax
80107992:	e8 99 f4 ff ff       	call   80106e30 <walkpgdir>
  if(pte == 0)
80107997:	85 c0                	test   %eax,%eax
80107999:	74 05                	je     801079a0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010799b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010799e:	c9                   	leave  
8010799f:	c3                   	ret    
    panic("clearpteu");
801079a0:	83 ec 0c             	sub    $0xc,%esp
801079a3:	68 0d 8a 10 80       	push   $0x80108a0d
801079a8:	e8 e3 89 ff ff       	call   80100390 <panic>
801079ad:	8d 76 00             	lea    0x0(%esi),%esi

801079b0 <pte_flags_Update_hoy>:


void pte_flags_Update_hoy(struct proc* curproc, int vAddr, pde_t * pgdir){
801079b0:	f3 0f 1e fb          	endbr32 
801079b4:	55                   	push   %ebp

  pte_t *pte = walkpgdir(pgdir, (int*)vAddr, 0);
801079b5:	31 c9                	xor    %ecx,%ecx
void pte_flags_Update_hoy(struct proc* curproc, int vAddr, pde_t * pgdir){
801079b7:	89 e5                	mov    %esp,%ebp
801079b9:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte = walkpgdir(pgdir, (int*)vAddr, 0);
801079bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801079bf:	8b 45 10             	mov    0x10(%ebp),%eax
801079c2:	e8 69 f4 ff ff       	call   80106e30 <walkpgdir>
  if (!pte)
801079c7:	85 c0                	test   %eax,%eax
801079c9:	74 2d                	je     801079f8 <pte_flags_Update_hoy+0x48>
    panic("pte_flags_Update_hoy: pte does NOT exist in page directory");

  *pte |= PTE_PG;           // Paged-out to secondary storage
  *pte &= ~PTE_P;           // the page is NOT present in physical memory
  *pte &= PTE_FLAGS(*pte);
801079cb:	8b 10                	mov    (%eax),%edx
  cprintf("pte flages gula update hocche copyuvm\n");
801079cd:	83 ec 0c             	sub    $0xc,%esp
  *pte &= PTE_FLAGS(*pte);
801079d0:	81 e2 fe 0f 00 00    	and    $0xffe,%edx
801079d6:	80 ce 02             	or     $0x2,%dh
801079d9:	89 10                	mov    %edx,(%eax)
  cprintf("pte flages gula update hocche copyuvm\n");
801079db:	68 ac 8b 10 80       	push   $0x80108bac
801079e0:	e8 cb 8c ff ff       	call   801006b0 <cprintf>
  lcr3(V2P(curproc->pgdir));      // Refresh CR3 register (TLB (cache))
801079e5:	8b 45 08             	mov    0x8(%ebp),%eax
801079e8:	8b 40 04             	mov    0x4(%eax),%eax
801079eb:	05 00 00 00 80       	add    $0x80000000,%eax
801079f0:	0f 22 d8             	mov    %eax,%cr3
}
801079f3:	83 c4 10             	add    $0x10,%esp
801079f6:	c9                   	leave  
801079f7:	c3                   	ret    
    panic("pte_flags_Update_hoy: pte does NOT exist in page directory");
801079f8:	83 ec 0c             	sub    $0xc,%esp
801079fb:	68 70 8b 10 80       	push   $0x80108b70
80107a00:	e8 8b 89 ff ff       	call   80100390 <panic>
80107a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107a10 <copyuvm>:
// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107a10:	f3 0f 1e fb          	endbr32 
80107a14:	55                   	push   %ebp
80107a15:	89 e5                	mov    %esp,%ebp
80107a17:	57                   	push   %edi
80107a18:	56                   	push   %esi
80107a19:	53                   	push   %ebx
80107a1a:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc=myproc();
80107a1d:	e8 fe c2 ff ff       	call   80103d20 <myproc>
80107a22:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(curproc == 0){
80107a25:	85 c0                	test   %eax,%eax
80107a27:	0f 84 e1 00 00 00    	je     80107b0e <copyuvm+0xfe>
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107a2d:	e8 ae fe ff ff       	call   801078e0 <setupkvm>
80107a32:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a35:	85 c0                	test   %eax,%eax
80107a37:	0f 84 d1 00 00 00    	je     80107b0e <copyuvm+0xfe>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a40:	85 c9                	test   %ecx,%ecx
80107a42:	0f 84 aa 00 00 00    	je     80107af2 <copyuvm+0xe2>
80107a48:	31 f6                	xor    %esi,%esi
80107a4a:	eb 6e                	jmp    80107aba <copyuvm+0xaa>
80107a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(*pte & PTE_PG){
      pte_flags_Update_hoy(curproc, i, d);
      continue;
    }

    if(!(*pte & PTE_P))
80107a50:	f6 c3 01             	test   $0x1,%bl
80107a53:	0f 84 d4 00 00 00    	je     80107b2d <copyuvm+0x11d>
      panic("copyuvm: page not present");

    pa = PTE_ADDR(*pte);
80107a59:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80107a5b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107a61:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107a67:	e8 44 af ff ff       	call   801029b0 <kalloc>
80107a6c:	85 c0                	test   %eax,%eax
80107a6e:	0f 84 8c 00 00 00    	je     80107b00 <copyuvm+0xf0>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a74:	83 ec 04             	sub    $0x4,%esp
80107a77:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a80:	68 00 10 00 00       	push   $0x1000
80107a85:	57                   	push   %edi
80107a86:	50                   	push   %eax
80107a87:	e8 04 d2 ff ff       	call   80104c90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a8c:	58                   	pop    %eax
80107a8d:	5a                   	pop    %edx
80107a8e:	53                   	push   %ebx
80107a8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a92:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a95:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a9a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107aa0:	52                   	push   %edx
80107aa1:	89 f2                	mov    %esi,%edx
80107aa3:	e8 08 f4 ff ff       	call   80106eb0 <mappages>
80107aa8:	83 c4 10             	add    $0x10,%esp
80107aab:	85 c0                	test   %eax,%eax
80107aad:	78 51                	js     80107b00 <copyuvm+0xf0>
  for(i = 0; i < sz; i += PGSIZE){
80107aaf:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107ab5:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107ab8:	76 38                	jbe    80107af2 <copyuvm+0xe2>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0){
80107aba:	8b 45 08             	mov    0x8(%ebp),%eax
80107abd:	31 c9                	xor    %ecx,%ecx
80107abf:	89 f2                	mov    %esi,%edx
80107ac1:	e8 6a f3 ff ff       	call   80106e30 <walkpgdir>
80107ac6:	85 c0                	test   %eax,%eax
80107ac8:	74 56                	je     80107b20 <copyuvm+0x110>
      if(*pte & PTE_PG){
80107aca:	8b 18                	mov    (%eax),%ebx
80107acc:	f6 c7 02             	test   $0x2,%bh
80107acf:	0f 84 7b ff ff ff    	je     80107a50 <copyuvm+0x40>
      pte_flags_Update_hoy(curproc, i, d);
80107ad5:	83 ec 04             	sub    $0x4,%esp
80107ad8:	ff 75 e0             	pushl  -0x20(%ebp)
80107adb:	56                   	push   %esi
  for(i = 0; i < sz; i += PGSIZE){
80107adc:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte_flags_Update_hoy(curproc, i, d);
80107ae2:	ff 75 dc             	pushl  -0x24(%ebp)
80107ae5:	e8 c6 fe ff ff       	call   801079b0 <pte_flags_Update_hoy>
      continue;
80107aea:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE){
80107aed:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107af0:	77 c8                	ja     80107aba <copyuvm+0xaa>
  return d;

bad:
  freevm(d);
  return 0;
}
80107af2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107af5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107af8:	5b                   	pop    %ebx
80107af9:	5e                   	pop    %esi
80107afa:	5f                   	pop    %edi
80107afb:	5d                   	pop    %ebp
80107afc:	c3                   	ret    
80107afd:	8d 76 00             	lea    0x0(%esi),%esi
  freevm(d);
80107b00:	83 ec 0c             	sub    $0xc,%esp
80107b03:	ff 75 e0             	pushl  -0x20(%ebp)
80107b06:	e8 55 fd ff ff       	call   80107860 <freevm>
  return 0;
80107b0b:	83 c4 10             	add    $0x10,%esp
80107b0e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107b15:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b1b:	5b                   	pop    %ebx
80107b1c:	5e                   	pop    %esi
80107b1d:	5f                   	pop    %edi
80107b1e:	5d                   	pop    %ebp
80107b1f:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107b20:	83 ec 0c             	sub    $0xc,%esp
80107b23:	68 17 8a 10 80       	push   $0x80108a17
80107b28:	e8 63 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107b2d:	83 ec 0c             	sub    $0xc,%esp
80107b30:	68 31 8a 10 80       	push   $0x80108a31
80107b35:	e8 56 88 ff ff       	call   80100390 <panic>
80107b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b40 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b40:	f3 0f 1e fb          	endbr32 
80107b44:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b45:	31 c9                	xor    %ecx,%ecx
{
80107b47:	89 e5                	mov    %esp,%ebp
80107b49:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80107b52:	e8 d9 f2 ff ff       	call   80106e30 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107b57:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107b59:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107b5a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107b61:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b64:	05 00 00 00 80       	add    $0x80000000,%eax
80107b69:	83 fa 05             	cmp    $0x5,%edx
80107b6c:	ba 00 00 00 00       	mov    $0x0,%edx
80107b71:	0f 45 c2             	cmovne %edx,%eax
}
80107b74:	c3                   	ret    
80107b75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107b80 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b80:	f3 0f 1e fb          	endbr32 
80107b84:	55                   	push   %ebp
80107b85:	89 e5                	mov    %esp,%ebp
80107b87:	57                   	push   %edi
80107b88:	56                   	push   %esi
80107b89:	53                   	push   %ebx
80107b8a:	83 ec 0c             	sub    $0xc,%esp
80107b8d:	8b 75 14             	mov    0x14(%ebp),%esi
80107b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b93:	85 f6                	test   %esi,%esi
80107b95:	75 3c                	jne    80107bd3 <copyout+0x53>
80107b97:	eb 67                	jmp    80107c00 <copyout+0x80>
80107b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ba3:	89 fb                	mov    %edi,%ebx
80107ba5:	29 d3                	sub    %edx,%ebx
80107ba7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107bad:	39 f3                	cmp    %esi,%ebx
80107baf:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107bb2:	29 fa                	sub    %edi,%edx
80107bb4:	83 ec 04             	sub    $0x4,%esp
80107bb7:	01 c2                	add    %eax,%edx
80107bb9:	53                   	push   %ebx
80107bba:	ff 75 10             	pushl  0x10(%ebp)
80107bbd:	52                   	push   %edx
80107bbe:	e8 cd d0 ff ff       	call   80104c90 <memmove>
    len -= n;
    buf += n;
80107bc3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107bc6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107bcc:	83 c4 10             	add    $0x10,%esp
80107bcf:	29 de                	sub    %ebx,%esi
80107bd1:	74 2d                	je     80107c00 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107bd3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107bd5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107bd8:	89 55 0c             	mov    %edx,0xc(%ebp)
80107bdb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107be1:	57                   	push   %edi
80107be2:	ff 75 08             	pushl  0x8(%ebp)
80107be5:	e8 56 ff ff ff       	call   80107b40 <uva2ka>
    if(pa0 == 0)
80107bea:	83 c4 10             	add    $0x10,%esp
80107bed:	85 c0                	test   %eax,%eax
80107bef:	75 af                	jne    80107ba0 <copyout+0x20>
  }
  return 0;
}
80107bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bf9:	5b                   	pop    %ebx
80107bfa:	5e                   	pop    %esi
80107bfb:	5f                   	pop    %edi
80107bfc:	5d                   	pop    %ebp
80107bfd:	c3                   	ret    
80107bfe:	66 90                	xchg   %ax,%ax
80107c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c03:	31 c0                	xor    %eax,%eax
}
80107c05:	5b                   	pop    %ebx
80107c06:	5e                   	pop    %esi
80107c07:	5f                   	pop    %edi
80107c08:	5d                   	pop    %ebp
80107c09:	c3                   	ret    
80107c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107c10 <trap_theke>:
void
trap_theke(pde_t *pgdir, uint pt)
{ 
80107c10:	f3 0f 1e fb          	endbr32 
80107c14:	55                   	push   %ebp
80107c15:	89 e5                	mov    %esp,%ebp
80107c17:	57                   	push   %edi
80107c18:	56                   	push   %esi


  mem = kalloc();
  memset(mem, 0, PGSIZE);
  
  char buffer[PGSIZE/2]= "";
80107c19:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
{ 
80107c1f:	53                   	push   %ebx
80107c20:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  struct proc *p=myproc();
80107c26:	e8 f5 c0 ff ff       	call   80103d20 <myproc>
  pte=walkpgdir(p->pgdir,(char*)pt,0);
80107c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c2e:	31 c9                	xor    %ecx,%ecx
  struct proc *p=myproc();
80107c30:	89 c3                	mov    %eax,%ebx
  pte=walkpgdir(p->pgdir,(char*)pt,0);
80107c32:	8b 40 04             	mov    0x4(%eax),%eax
80107c35:	e8 f6 f1 ff ff       	call   80106e30 <walkpgdir>
  cprintf("pte %d\n",*pte); 
80107c3a:	83 ec 08             	sub    $0x8,%esp
80107c3d:	ff 30                	pushl  (%eax)
  pte=walkpgdir(p->pgdir,(char*)pt,0);
80107c3f:	89 c6                	mov    %eax,%esi
  cprintf("pte %d\n",*pte); 
80107c41:	68 4b 8a 10 80       	push   $0x80108a4b
80107c46:	e8 65 8a ff ff       	call   801006b0 <cprintf>
  uint off_set=p->f_page_tra[name-1].offset;
80107c4b:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80107c51:	8b 84 c3 e4 02 00 00 	mov    0x2e4(%ebx,%eax,8),%eax
80107c58:	89 85 e4 f7 ff ff    	mov    %eax,-0x81c(%ebp)
  *pte&=(~PTE_P);
80107c5e:	8b 06                	mov    (%esi),%eax
80107c60:	83 e0 fe             	and    $0xfffffffe,%eax
80107c63:	80 cc 02             	or     $0x2,%ah
80107c66:	89 06                	mov    %eax,(%esi)
  mem = kalloc();
80107c68:	e8 43 ad ff ff       	call   801029b0 <kalloc>
  memset(mem, 0, PGSIZE);
80107c6d:	83 c4 0c             	add    $0xc,%esp
80107c70:	68 00 10 00 00       	push   $0x1000
80107c75:	6a 00                	push   $0x0
80107c77:	50                   	push   %eax
  mem = kalloc();
80107c78:	89 85 e0 f7 ff ff    	mov    %eax,-0x820(%ebp)
  memset(mem, 0, PGSIZE);
80107c7e:	e8 6d cf ff ff       	call   80104bf0 <memset>
  char buffer[PGSIZE/2]= "";
80107c83:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80107c88:	31 c0                	xor    %eax,%eax
  //readFromSwapFile(p,buffer,off_set,PGSIZE/2);
  
  if(*pte & PTE_P){
80107c8a:	83 c4 10             	add    $0x10,%esp
  char buffer[PGSIZE/2]= "";
80107c8d:	f3 ab                	rep stos %eax,%es:(%edi)
80107c8f:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
80107c96:	00 00 00 
  if(*pte & PTE_P){
80107c99:	f6 06 01             	testb  $0x1,(%esi)
80107c9c:	74 22                	je     80107cc0 <trap_theke+0xb0>

    cprintf("Memory already has the page.\n");
80107c9e:	83 ec 0c             	sub    $0xc,%esp
80107ca1:	68 53 8a 10 80       	push   $0x80108a53
80107ca6:	e8 05 8a ff ff       	call   801006b0 <cprintf>
80107cab:	83 c4 10             	add    $0x10,%esp

    }
  
    }
  }
}
80107cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cb1:	5b                   	pop    %ebx
80107cb2:	5e                   	pop    %esi
80107cb3:	5f                   	pop    %edi
80107cb4:	5d                   	pop    %ebp
80107cb5:	c3                   	ret    
80107cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cbd:	8d 76 00             	lea    0x0(%esi),%esi
  int map_number=mappages(pgdir, (char*)pt, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107cc0:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
80107cc6:	83 ec 08             	sub    $0x8,%esp
80107cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ccc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107cd1:	6a 06                	push   $0x6
    if(readFromSwapFile(p,buffer,off_set+it*(PGSIZE/2),PGSIZE/2)!=0){
80107cd3:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
  int map_number=mappages(pgdir, (char*)pt, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107cd9:	05 00 00 00 80       	add    $0x80000000,%eax
80107cde:	50                   	push   %eax
80107cdf:	8b 45 08             	mov    0x8(%ebp),%eax
80107ce2:	e8 c9 f1 ff ff       	call   80106eb0 <mappages>
  cprintf("map number (0 means successful) : %d\n",map_number);
80107ce7:	5a                   	pop    %edx
80107ce8:	59                   	pop    %ecx
80107ce9:	50                   	push   %eax
80107cea:	68 d4 8b 10 80       	push   $0x80108bd4
80107cef:	e8 bc 89 ff ff       	call   801006b0 <cprintf>
    if(readFromSwapFile(p,buffer,off_set+it*(PGSIZE/2),PGSIZE/2)!=0){
80107cf4:	68 00 08 00 00       	push   $0x800
80107cf9:	ff b5 e4 f7 ff ff    	pushl  -0x81c(%ebp)
80107cff:	56                   	push   %esi
80107d00:	53                   	push   %ebx
80107d01:	e8 ba a6 ff ff       	call   801023c0 <readFromSwapFile>
80107d06:	83 c4 20             	add    $0x20,%esp
80107d09:	85 c0                	test   %eax,%eax
80107d0b:	75 53                	jne    80107d60 <trap_theke+0x150>
80107d0d:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
80107d13:	68 00 08 00 00       	push   $0x800
80107d18:	05 00 08 00 00       	add    $0x800,%eax
80107d1d:	50                   	push   %eax
80107d1e:	56                   	push   %esi
80107d1f:	53                   	push   %ebx
80107d20:	e8 9b a6 ff ff       	call   801023c0 <readFromSwapFile>
80107d25:	83 c4 10             	add    $0x10,%esp
80107d28:	85 c0                	test   %eax,%eax
80107d2a:	74 82                	je     80107cae <trap_theke+0x9e>
      memmove(mem+it*(PGSIZE/2), buffer, PGSIZE/2);
80107d2c:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
80107d32:	83 ec 04             	sub    $0x4,%esp
80107d35:	68 00 08 00 00       	push   $0x800
80107d3a:	05 00 08 00 00       	add    $0x800,%eax
80107d3f:	56                   	push   %esi
80107d40:	50                   	push   %eax
80107d41:	e8 4a cf ff ff       	call   80104c90 <memmove>
      cprintf("AFTER READING AND ALLOCATING\n");
80107d46:	c7 04 24 71 8a 10 80 	movl   $0x80108a71,(%esp)
80107d4d:	e8 5e 89 ff ff       	call   801006b0 <cprintf>
80107d52:	83 c4 10             	add    $0x10,%esp
}
80107d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d58:	5b                   	pop    %ebx
80107d59:	5e                   	pop    %esi
80107d5a:	5f                   	pop    %edi
80107d5b:	5d                   	pop    %ebp
80107d5c:	c3                   	ret    
80107d5d:	8d 76 00             	lea    0x0(%esi),%esi
      memmove(mem+it*(PGSIZE/2), buffer, PGSIZE/2);
80107d60:	83 ec 04             	sub    $0x4,%esp
80107d63:	68 00 08 00 00       	push   $0x800
80107d68:	56                   	push   %esi
80107d69:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
80107d6f:	e8 1c cf ff ff       	call   80104c90 <memmove>
      cprintf("AFTER READING AND ALLOCATING\n");
80107d74:	c7 04 24 71 8a 10 80 	movl   $0x80108a71,(%esp)
80107d7b:	e8 30 89 ff ff       	call   801006b0 <cprintf>
80107d80:	83 c4 10             	add    $0x10,%esp
80107d83:	eb 88                	jmp    80107d0d <trap_theke+0xfd>
