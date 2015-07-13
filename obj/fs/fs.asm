
obj/fs/fs:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 37 1d 00 00       	call   801d68 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
		return -1;
	return 0;
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 14             	sub    $0x14,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800075:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	b2 f7                	mov    $0xf7,%dl
  800082:	eb 0b                	jmp    80008f <ide_probe_disk1+0x30>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  800084:	83 c1 01             	add    $0x1,%ecx

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  800087:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  80008d:	74 05                	je     800094 <ide_probe_disk1+0x35>
  80008f:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800090:	a8 a1                	test   $0xa1,%al
  800092:	75 f0                	jne    800084 <ide_probe_disk1+0x25>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800094:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800099:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009e:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  80009f:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a5:	0f 9e c3             	setle  %bl
  8000a8:	0f b6 c3             	movzbl %bl,%eax
  8000ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000af:	c7 04 24 a0 44 80 00 	movl   $0x8044a0,(%esp)
  8000b6:	e8 07 1e 00 00       	call   801ec2 <cprintf>
	return (x < 1000);
}
  8000bb:	89 d8                	mov    %ebx,%eax
  8000bd:	83 c4 14             	add    $0x14,%esp
  8000c0:	5b                   	pop    %ebx
  8000c1:	5d                   	pop    %ebp
  8000c2:	c3                   	ret    

008000c3 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	83 ec 18             	sub    $0x18,%esp
  8000c9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000cc:	83 f8 01             	cmp    $0x1,%eax
  8000cf:	76 1c                	jbe    8000ed <ide_set_disk+0x2a>
		panic("bad disk number");
  8000d1:	c7 44 24 08 b7 44 80 	movl   $0x8044b7,0x8(%esp)
  8000d8:	00 
  8000d9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8000e0:	00 
  8000e1:	c7 04 24 c7 44 80 00 	movl   $0x8044c7,(%esp)
  8000e8:	e8 dc 1c 00 00       	call   801dc9 <_panic>
	diskno = d;
  8000ed:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	57                   	push   %edi
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	83 ec 1c             	sub    $0x1c,%esp
  8000fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800100:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800103:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800106:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  80010c:	76 24                	jbe    800132 <ide_read+0x3e>
  80010e:	c7 44 24 0c d0 44 80 	movl   $0x8044d0,0xc(%esp)
  800115:	00 
  800116:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  80011d:	00 
  80011e:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 c7 44 80 00 	movl   $0x8044c7,(%esp)
  80012d:	e8 97 1c 00 00       	call   801dc9 <_panic>

	ide_wait_ready(0);
  800132:	b8 00 00 00 00       	mov    $0x0,%eax
  800137:	e8 f7 fe ff ff       	call   800033 <ide_wait_ready>
  80013c:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800141:	89 f0                	mov    %esi,%eax
  800143:	ee                   	out    %al,(%dx)
  800144:	b2 f3                	mov    $0xf3,%dl
  800146:	89 f8                	mov    %edi,%eax
  800148:	ee                   	out    %al,(%dx)
  800149:	89 f8                	mov    %edi,%eax
  80014b:	0f b6 c4             	movzbl %ah,%eax
  80014e:	b2 f4                	mov    $0xf4,%dl
  800150:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
  800151:	89 f8                	mov    %edi,%eax
  800153:	c1 e8 10             	shr    $0x10,%eax
  800156:	b2 f5                	mov    $0xf5,%dl
  800158:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800159:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800160:	83 e0 01             	and    $0x1,%eax
  800163:	c1 e0 04             	shl    $0x4,%eax
  800166:	83 c8 e0             	or     $0xffffffe0,%eax
  800169:	c1 ef 18             	shr    $0x18,%edi
  80016c:	83 e7 0f             	and    $0xf,%edi
  80016f:	09 f8                	or     %edi,%eax
  800171:	b2 f6                	mov    $0xf6,%dl
  800173:	ee                   	out    %al,(%dx)
  800174:	b2 f7                	mov    $0xf7,%dl
  800176:	b8 20 00 00 00       	mov    $0x20,%eax
  80017b:	ee                   	out    %al,(%dx)
  80017c:	c1 e6 09             	shl    $0x9,%esi
  80017f:	01 de                	add    %ebx,%esi
  800181:	eb 23                	jmp    8001a6 <ide_read+0xb2>
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
		if ((r = ide_wait_ready(1)) < 0)
  800183:	b8 01 00 00 00       	mov    $0x1,%eax
  800188:	e8 a6 fe ff ff       	call   800033 <ide_wait_ready>
  80018d:	85 c0                	test   %eax,%eax
  80018f:	78 1e                	js     8001af <ide_read+0xbb>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  800191:	89 df                	mov    %ebx,%edi
  800193:	b9 80 00 00 00       	mov    $0x80,%ecx
  800198:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80019d:	fc                   	cld    
  80019e:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001a0:	81 c3 00 02 00 00    	add    $0x200,%ebx
  8001a6:	39 f3                	cmp    %esi,%ebx
  8001a8:	75 d9                	jne    800183 <ide_read+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001af:	83 c4 1c             	add    $0x1c,%esp
  8001b2:	5b                   	pop    %ebx
  8001b3:	5e                   	pop    %esi
  8001b4:	5f                   	pop    %edi
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	57                   	push   %edi
  8001bb:	56                   	push   %esi
  8001bc:	53                   	push   %ebx
  8001bd:	83 ec 1c             	sub    $0x1c,%esp
  8001c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c9:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001cf:	76 24                	jbe    8001f5 <ide_write+0x3e>
  8001d1:	c7 44 24 0c d0 44 80 	movl   $0x8044d0,0xc(%esp)
  8001d8:	00 
  8001d9:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  8001e0:	00 
  8001e1:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8001e8:	00 
  8001e9:	c7 04 24 c7 44 80 00 	movl   $0x8044c7,(%esp)
  8001f0:	e8 d4 1b 00 00       	call   801dc9 <_panic>

	ide_wait_ready(0);
  8001f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fa:	e8 34 fe ff ff       	call   800033 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001ff:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800204:	89 f8                	mov    %edi,%eax
  800206:	ee                   	out    %al,(%dx)
  800207:	b2 f3                	mov    $0xf3,%dl
  800209:	89 f0                	mov    %esi,%eax
  80020b:	ee                   	out    %al,(%dx)
  80020c:	89 f0                	mov    %esi,%eax
  80020e:	0f b6 c4             	movzbl %ah,%eax
  800211:	b2 f4                	mov    $0xf4,%dl
  800213:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
  800214:	89 f0                	mov    %esi,%eax
  800216:	c1 e8 10             	shr    $0x10,%eax
  800219:	b2 f5                	mov    $0xf5,%dl
  80021b:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80021c:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800223:	83 e0 01             	and    $0x1,%eax
  800226:	c1 e0 04             	shl    $0x4,%eax
  800229:	83 c8 e0             	or     $0xffffffe0,%eax
  80022c:	c1 ee 18             	shr    $0x18,%esi
  80022f:	83 e6 0f             	and    $0xf,%esi
  800232:	09 f0                	or     %esi,%eax
  800234:	b2 f6                	mov    $0xf6,%dl
  800236:	ee                   	out    %al,(%dx)
  800237:	b2 f7                	mov    $0xf7,%dl
  800239:	b8 30 00 00 00       	mov    $0x30,%eax
  80023e:	ee                   	out    %al,(%dx)
  80023f:	c1 e7 09             	shl    $0x9,%edi
  800242:	01 df                	add    %ebx,%edi
  800244:	eb 23                	jmp    800269 <ide_write+0xb2>
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
		if ((r = ide_wait_ready(1)) < 0)
  800246:	b8 01 00 00 00       	mov    $0x1,%eax
  80024b:	e8 e3 fd ff ff       	call   800033 <ide_wait_ready>
  800250:	85 c0                	test   %eax,%eax
  800252:	78 1e                	js     800272 <ide_write+0xbb>
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  800254:	89 de                	mov    %ebx,%esi
  800256:	b9 80 00 00 00       	mov    $0x80,%ecx
  80025b:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800260:	fc                   	cld    
  800261:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800263:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800269:	39 fb                	cmp    %edi,%ebx
  80026b:	75 d9                	jne    800246 <ide_write+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	83 c4 1c             	add    $0x1c,%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	57                   	push   %edi
  80027e:	56                   	push   %esi
  80027f:	53                   	push   %ebx
  800280:	83 ec 2c             	sub    $0x2c,%esp
	void *addr = (void *) utf->utf_fault_va;
  800283:	8b 45 08             	mov    0x8(%ebp),%eax
  800286:	8b 18                	mov    (%eax),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800288:	8d bb 00 00 00 f0    	lea    -0x10000000(%ebx),%edi
  80028e:	89 fe                	mov    %edi,%esi
  800290:	c1 ee 0c             	shr    $0xc,%esi
	int r;
	envid_t envid = sys_getenvid();
  800293:	e8 cf 26 00 00       	call   802967 <sys_getenvid>

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800298:	81 ff ff ff ff bf    	cmp    $0xbfffffff,%edi
  80029e:	76 34                	jbe    8002d4 <bc_pgfault+0x5a>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  8002a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a3:	8b 40 04             	mov    0x4(%eax),%eax
  8002a6:	89 44 24 14          	mov    %eax,0x14(%esp)
  8002aa:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	8b 40 28             	mov    0x28(%eax),%eax
  8002b4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b8:	c7 44 24 08 f4 44 80 	movl   $0x8044f4,0x8(%esp)
  8002bf:	00 
  8002c0:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  8002c7:	00 
  8002c8:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  8002cf:	e8 f5 1a 00 00       	call   801dc9 <_panic>
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8002d4:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8002da:	85 d2                	test   %edx,%edx
  8002dc:	74 25                	je     800303 <bc_pgfault+0x89>
  8002de:	3b 72 04             	cmp    0x4(%edx),%esi
  8002e1:	72 20                	jb     800303 <bc_pgfault+0x89>
		panic("reading non-existent block %08x\n", blockno);
  8002e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002e7:	c7 44 24 08 24 45 80 	movl   $0x804524,0x8(%esp)
  8002ee:	00 
  8002ef:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002f6:	00 
  8002f7:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  8002fe:	e8 c6 1a 00 00       	call   801dc9 <_panic>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	if ((r = sys_page_alloc(envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  800303:	89 df                	mov    %ebx,%edi
  800305:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80030b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800312:	00 
  800313:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800317:	89 04 24             	mov    %eax,(%esp)
  80031a:	e8 86 26 00 00       	call   8029a5 <sys_page_alloc>
  80031f:	85 c0                	test   %eax,%eax
  800321:	79 20                	jns    800343 <bc_pgfault+0xc9>
		panic("sys_page_alloc: %e", r);
  800323:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800327:	c7 44 24 08 b8 45 80 	movl   $0x8045b8,0x8(%esp)
  80032e:	00 
  80032f:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  800336:	00 
  800337:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  80033e:	e8 86 1a 00 00       	call   801dc9 <_panic>

	if ((r = ide_read(8 * blockno, (void *)PTE_ADDR(addr), 8)) < 0)
  800343:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  80034a:	00 
  80034b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80034f:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  800356:	89 04 24             	mov    %eax,(%esp)
  800359:	e8 96 fd ff ff       	call   8000f4 <ide_read>
  80035e:	85 c0                	test   %eax,%eax
  800360:	79 20                	jns    800382 <bc_pgfault+0x108>
		panic("ide read error: %e", r);
  800362:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800366:	c7 44 24 08 cb 45 80 	movl   $0x8045cb,0x8(%esp)
  80036d:	00 
  80036e:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  800375:	00 
  800376:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  80037d:	e8 47 1a 00 00       	call   801dc9 <_panic>

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800382:	89 d8                	mov    %ebx,%eax
  800384:	c1 e8 0c             	shr    $0xc,%eax
  800387:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80038e:	25 07 0e 00 00       	and    $0xe07,%eax
  800393:	89 44 24 10          	mov    %eax,0x10(%esp)
  800397:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80039b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8003a2:	00 
  8003a3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003ae:	e8 46 26 00 00       	call   8029f9 <sys_page_map>
  8003b3:	85 c0                	test   %eax,%eax
  8003b5:	79 20                	jns    8003d7 <bc_pgfault+0x15d>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8003b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003bb:	c7 44 24 08 48 45 80 	movl   $0x804548,0x8(%esp)
  8003c2:	00 
  8003c3:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  8003ca:	00 
  8003cb:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  8003d2:	e8 f2 19 00 00       	call   801dc9 <_panic>

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  8003d7:	83 3d 08 a0 80 00 00 	cmpl   $0x0,0x80a008
  8003de:	74 2c                	je     80040c <bc_pgfault+0x192>
  8003e0:	89 34 24             	mov    %esi,(%esp)
  8003e3:	e8 0a 04 00 00       	call   8007f2 <block_is_free>
  8003e8:	84 c0                	test   %al,%al
  8003ea:	74 20                	je     80040c <bc_pgfault+0x192>
		panic("reading free block %08x\n", blockno);
  8003ec:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003f0:	c7 44 24 08 de 45 80 	movl   $0x8045de,0x8(%esp)
  8003f7:	00 
  8003f8:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  8003ff:	00 
  800400:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  800407:	e8 bd 19 00 00       	call   801dc9 <_panic>
}
  80040c:	83 c4 2c             	add    $0x2c,%esp
  80040f:	5b                   	pop    %ebx
  800410:	5e                   	pop    %esi
  800411:	5f                   	pop    %edi
  800412:	5d                   	pop    %ebp
  800413:	c3                   	ret    

00800414 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
  800417:	83 ec 18             	sub    $0x18,%esp
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  80041d:	85 c0                	test   %eax,%eax
  80041f:	74 0f                	je     800430 <diskaddr+0x1c>
  800421:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  800427:	85 d2                	test   %edx,%edx
  800429:	74 25                	je     800450 <diskaddr+0x3c>
  80042b:	3b 42 04             	cmp    0x4(%edx),%eax
  80042e:	72 20                	jb     800450 <diskaddr+0x3c>
		panic("bad block number %08x in diskaddr", blockno);
  800430:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800434:	c7 44 24 08 68 45 80 	movl   $0x804568,0x8(%esp)
  80043b:	00 
  80043c:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800443:	00 
  800444:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  80044b:	e8 79 19 00 00       	call   801dc9 <_panic>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800450:	05 00 00 01 00       	add    $0x10000,%eax
  800455:	c1 e0 0c             	shl    $0xc,%eax
}
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  800460:	89 d0                	mov    %edx,%eax
  800462:	c1 e8 16             	shr    $0x16,%eax
  800465:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  80046c:	b8 00 00 00 00       	mov    $0x0,%eax
  800471:	f6 c1 01             	test   $0x1,%cl
  800474:	74 0d                	je     800483 <va_is_mapped+0x29>
  800476:	c1 ea 0c             	shr    $0xc,%edx
  800479:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800480:	83 e0 01             	and    $0x1,%eax
  800483:	83 e0 01             	and    $0x1,%eax
}
  800486:	5d                   	pop    %ebp
  800487:	c3                   	ret    

00800488 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  800488:	55                   	push   %ebp
  800489:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	c1 e8 0c             	shr    $0xc,%eax
  800491:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800498:	c1 e8 06             	shr    $0x6,%eax
  80049b:	83 e0 01             	and    $0x1,%eax
}
  80049e:	5d                   	pop    %ebp
  80049f:	c3                   	ret    

008004a0 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	56                   	push   %esi
  8004a4:	53                   	push   %ebx
  8004a5:	83 ec 20             	sub    $0x20,%esp
  8004a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  8004ab:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  8004b1:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  8004b6:	76 20                	jbe    8004d8 <flush_block+0x38>
		panic("flush_block of bad va %08x", addr);
  8004b8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004bc:	c7 44 24 08 f7 45 80 	movl   $0x8045f7,0x8(%esp)
  8004c3:	00 
  8004c4:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  8004cb:	00 
  8004cc:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  8004d3:	e8 f1 18 00 00       	call   801dc9 <_panic>

	// LAB 5: Your code here.
	//panic("flush_block not implemented");
	if(va_is_mapped(addr))
  8004d8:	89 1c 24             	mov    %ebx,(%esp)
  8004db:	e8 7a ff ff ff       	call   80045a <va_is_mapped>
  8004e0:	84 c0                	test   %al,%al
  8004e2:	0f 84 af 00 00 00    	je     800597 <flush_block+0xf7>
	{
		if(va_is_dirty(addr))
  8004e8:	89 1c 24             	mov    %ebx,(%esp)
  8004eb:	e8 98 ff ff ff       	call   800488 <va_is_dirty>
  8004f0:	84 c0                	test   %al,%al
  8004f2:	0f 84 9f 00 00 00    	je     800597 <flush_block+0xf7>
		{
			if ((r = ide_write(8 * blockno, (void *)PTE_ADDR(addr), 8)) < 0)
  8004f8:	89 de                	mov    %ebx,%esi
  8004fa:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  800500:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  800507:	00 
  800508:	89 74 24 04          	mov    %esi,0x4(%esp)
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
	int r;
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  80050c:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  800512:	c1 e8 0c             	shr    $0xc,%eax
	//panic("flush_block not implemented");
	if(va_is_mapped(addr))
	{
		if(va_is_dirty(addr))
		{
			if ((r = ide_write(8 * blockno, (void *)PTE_ADDR(addr), 8)) < 0)
  800515:	c1 e0 03             	shl    $0x3,%eax
  800518:	89 04 24             	mov    %eax,(%esp)
  80051b:	e8 97 fc ff ff       	call   8001b7 <ide_write>
  800520:	85 c0                	test   %eax,%eax
  800522:	79 20                	jns    800544 <flush_block+0xa4>
				panic("ide write error: %e", r);
  800524:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800528:	c7 44 24 08 12 46 80 	movl   $0x804612,0x8(%esp)
  80052f:	00 
  800530:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  800537:	00 
  800538:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  80053f:	e8 85 18 00 00       	call   801dc9 <_panic>
			if ((r = sys_page_map(0, (void *)PTE_ADDR(addr), 0, (void *)PTE_ADDR(addr), uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800544:	c1 eb 0c             	shr    $0xc,%ebx
  800547:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80054e:	25 07 0e 00 00       	and    $0xe07,%eax
  800553:	89 44 24 10          	mov    %eax,0x10(%esp)
  800557:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80055b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800562:	00 
  800563:	89 74 24 04          	mov    %esi,0x4(%esp)
  800567:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80056e:	e8 86 24 00 00       	call   8029f9 <sys_page_map>
  800573:	85 c0                	test   %eax,%eax
  800575:	79 20                	jns    800597 <flush_block+0xf7>
				panic("in bc_pgfault, sys_page_map: %e", r);
  800577:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80057b:	c7 44 24 08 48 45 80 	movl   $0x804548,0x8(%esp)
  800582:	00 
  800583:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80058a:	00 
  80058b:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  800592:	e8 32 18 00 00       	call   801dc9 <_panic>
		}
	}
}
  800597:	83 c4 20             	add    $0x20,%esp
  80059a:	5b                   	pop    %ebx
  80059b:	5e                   	pop    %esi
  80059c:	5d                   	pop    %ebp
  80059d:	c3                   	ret    

0080059e <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	81 ec 28 02 00 00    	sub    $0x228,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  8005a7:	c7 04 24 7a 02 80 00 	movl   $0x80027a,(%esp)
  8005ae:	e8 fb 26 00 00       	call   802cae <set_pgfault_handler>
check_bc(void)
{
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8005b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005ba:	e8 55 fe ff ff       	call   800414 <diskaddr>
  8005bf:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  8005c6:	00 
  8005c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005cb:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8005d1:	89 04 24             	mov    %eax,(%esp)
  8005d4:	e8 fb 20 00 00       	call   8026d4 <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  8005d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005e0:	e8 2f fe ff ff       	call   800414 <diskaddr>
  8005e5:	c7 44 24 04 26 46 80 	movl   $0x804626,0x4(%esp)
  8005ec:	00 
  8005ed:	89 04 24             	mov    %eax,(%esp)
  8005f0:	e8 42 1f 00 00       	call   802537 <strcpy>
	flush_block(diskaddr(1));
  8005f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005fc:	e8 13 fe ff ff       	call   800414 <diskaddr>
  800601:	89 04 24             	mov    %eax,(%esp)
  800604:	e8 97 fe ff ff       	call   8004a0 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800609:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800610:	e8 ff fd ff ff       	call   800414 <diskaddr>
  800615:	89 04 24             	mov    %eax,(%esp)
  800618:	e8 3d fe ff ff       	call   80045a <va_is_mapped>
  80061d:	84 c0                	test   %al,%al
  80061f:	75 24                	jne    800645 <bc_init+0xa7>
  800621:	c7 44 24 0c 48 46 80 	movl   $0x804648,0xc(%esp)
  800628:	00 
  800629:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  800630:	00 
  800631:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  800638:	00 
  800639:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  800640:	e8 84 17 00 00       	call   801dc9 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  800645:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80064c:	e8 c3 fd ff ff       	call   800414 <diskaddr>
  800651:	89 04 24             	mov    %eax,(%esp)
  800654:	e8 2f fe ff ff       	call   800488 <va_is_dirty>
  800659:	84 c0                	test   %al,%al
  80065b:	74 24                	je     800681 <bc_init+0xe3>
  80065d:	c7 44 24 0c 2d 46 80 	movl   $0x80462d,0xc(%esp)
  800664:	00 
  800665:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  80066c:	00 
  80066d:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
  800674:	00 
  800675:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  80067c:	e8 48 17 00 00       	call   801dc9 <_panic>

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800681:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800688:	e8 87 fd ff ff       	call   800414 <diskaddr>
  80068d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800691:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800698:	e8 af 23 00 00       	call   802a4c <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  80069d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006a4:	e8 6b fd ff ff       	call   800414 <diskaddr>
  8006a9:	89 04 24             	mov    %eax,(%esp)
  8006ac:	e8 a9 fd ff ff       	call   80045a <va_is_mapped>
  8006b1:	84 c0                	test   %al,%al
  8006b3:	74 24                	je     8006d9 <bc_init+0x13b>
  8006b5:	c7 44 24 0c 47 46 80 	movl   $0x804647,0xc(%esp)
  8006bc:	00 
  8006bd:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  8006c4:	00 
  8006c5:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
  8006cc:	00 
  8006cd:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  8006d4:	e8 f0 16 00 00       	call   801dc9 <_panic>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006e0:	e8 2f fd ff ff       	call   800414 <diskaddr>
  8006e5:	c7 44 24 04 26 46 80 	movl   $0x804626,0x4(%esp)
  8006ec:	00 
  8006ed:	89 04 24             	mov    %eax,(%esp)
  8006f0:	e8 f7 1e 00 00       	call   8025ec <strcmp>
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	74 24                	je     80071d <bc_init+0x17f>
  8006f9:	c7 44 24 0c 8c 45 80 	movl   $0x80458c,0xc(%esp)
  800700:	00 
  800701:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  800708:	00 
  800709:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  800710:	00 
  800711:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  800718:	e8 ac 16 00 00       	call   801dc9 <_panic>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  80071d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800724:	e8 eb fc ff ff       	call   800414 <diskaddr>
  800729:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800730:	00 
  800731:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  800737:	89 54 24 04          	mov    %edx,0x4(%esp)
  80073b:	89 04 24             	mov    %eax,(%esp)
  80073e:	e8 91 1f 00 00       	call   8026d4 <memmove>
	flush_block(diskaddr(1));
  800743:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80074a:	e8 c5 fc ff ff       	call   800414 <diskaddr>
  80074f:	89 04 24             	mov    %eax,(%esp)
  800752:	e8 49 fd ff ff       	call   8004a0 <flush_block>

	cprintf("block cache is good\n");
  800757:	c7 04 24 62 46 80 00 	movl   $0x804662,(%esp)
  80075e:	e8 5f 17 00 00       	call   801ec2 <cprintf>
	struct Super super;
	set_pgfault_handler(bc_pgfault);
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800763:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80076a:	e8 a5 fc ff ff       	call   800414 <diskaddr>
  80076f:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800776:	00 
  800777:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800781:	89 04 24             	mov    %eax,(%esp)
  800784:	e8 4b 1f 00 00       	call   8026d4 <memmove>
}
  800789:	c9                   	leave  
  80078a:	c3                   	ret    
  80078b:	66 90                	xchg   %ax,%ax
  80078d:	66 90                	xchg   %ax,%ax
  80078f:	90                   	nop

00800790 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 18             	sub    $0x18,%esp
	if (super->s_magic != FS_MAGIC)
  800796:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80079b:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8007a1:	74 1c                	je     8007bf <check_super+0x2f>
		panic("bad file system magic number");
  8007a3:	c7 44 24 08 77 46 80 	movl   $0x804677,0x8(%esp)
  8007aa:	00 
  8007ab:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8007b2:	00 
  8007b3:	c7 04 24 94 46 80 00 	movl   $0x804694,(%esp)
  8007ba:	e8 0a 16 00 00       	call   801dc9 <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8007bf:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8007c6:	76 1c                	jbe    8007e4 <check_super+0x54>
		panic("file system is too large");
  8007c8:	c7 44 24 08 9c 46 80 	movl   $0x80469c,0x8(%esp)
  8007cf:	00 
  8007d0:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8007d7:	00 
  8007d8:	c7 04 24 94 46 80 00 	movl   $0x804694,(%esp)
  8007df:	e8 e5 15 00 00       	call   801dc9 <_panic>

	cprintf("superblock is good\n");
  8007e4:	c7 04 24 b5 46 80 00 	movl   $0x8046b5,(%esp)
  8007eb:	e8 d2 16 00 00       	call   801ec2 <cprintf>
}
  8007f0:	c9                   	leave  
  8007f1:	c3                   	ret    

008007f2 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  8007f8:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8007fe:	85 d2                	test   %edx,%edx
  800800:	74 22                	je     800824 <block_is_free+0x32>
		return 0;
  800802:	b8 00 00 00 00       	mov    $0x0,%eax
// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
  800807:	39 4a 04             	cmp    %ecx,0x4(%edx)
  80080a:	76 1d                	jbe    800829 <block_is_free+0x37>
		return 0;
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  80080c:	b8 01 00 00 00       	mov    $0x1,%eax
  800811:	d3 e0                	shl    %cl,%eax
  800813:	c1 e9 05             	shr    $0x5,%ecx
  800816:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  80081c:	85 04 8a             	test   %eax,(%edx,%ecx,4)
		return 1;
  80081f:	0f 95 c0             	setne  %al
  800822:	eb 05                	jmp    800829 <block_is_free+0x37>
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
		return 0;
  800824:	b8 00 00 00 00       	mov    $0x0,%eax
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
		return 1;
	return 0;
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	53                   	push   %ebx
  80082f:	83 ec 14             	sub    $0x14,%esp
  800832:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800835:	85 c9                	test   %ecx,%ecx
  800837:	75 1c                	jne    800855 <free_block+0x2a>
		panic("attempt to free zero block");
  800839:	c7 44 24 08 c9 46 80 	movl   $0x8046c9,0x8(%esp)
  800840:	00 
  800841:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800848:	00 
  800849:	c7 04 24 94 46 80 00 	movl   $0x804694,(%esp)
  800850:	e8 74 15 00 00       	call   801dc9 <_panic>
	bitmap[blockno/32] |= 1<<(blockno%32);
  800855:	89 ca                	mov    %ecx,%edx
  800857:	c1 ea 05             	shr    $0x5,%edx
  80085a:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80085f:	bb 01 00 00 00       	mov    $0x1,%ebx
  800864:	d3 e3                	shl    %cl,%ebx
  800866:	09 1c 90             	or     %ebx,(%eax,%edx,4)
}
  800869:	83 c4 14             	add    $0x14,%esp
  80086c:	5b                   	pop    %ebx
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	56                   	push   %esi
  800873:	53                   	push   %ebx
  800874:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800877:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80087c:	8b 70 04             	mov    0x4(%eax),%esi
  80087f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800884:	eb 36                	jmp    8008bc <check_bitmap+0x4d>
  800886:	8d 43 02             	lea    0x2(%ebx),%eax
		assert(!block_is_free(2+i));
  800889:	89 04 24             	mov    %eax,(%esp)
  80088c:	e8 61 ff ff ff       	call   8007f2 <block_is_free>
  800891:	84 c0                	test   %al,%al
  800893:	74 24                	je     8008b9 <check_bitmap+0x4a>
  800895:	c7 44 24 0c e4 46 80 	movl   $0x8046e4,0xc(%esp)
  80089c:	00 
  80089d:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  8008a4:	00 
  8008a5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8008ac:	00 
  8008ad:	c7 04 24 94 46 80 00 	movl   $0x804694,(%esp)
  8008b4:	e8 10 15 00 00       	call   801dc9 <_panic>
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8008b9:	83 c3 01             	add    $0x1,%ebx
  8008bc:	89 d8                	mov    %ebx,%eax
  8008be:	c1 e0 0f             	shl    $0xf,%eax
  8008c1:	39 c6                	cmp    %eax,%esi
  8008c3:	77 c1                	ja     800886 <check_bitmap+0x17>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  8008c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008cc:	e8 21 ff ff ff       	call   8007f2 <block_is_free>
  8008d1:	84 c0                	test   %al,%al
  8008d3:	74 24                	je     8008f9 <check_bitmap+0x8a>
  8008d5:	c7 44 24 0c f8 46 80 	movl   $0x8046f8,0xc(%esp)
  8008dc:	00 
  8008dd:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  8008e4:	00 
  8008e5:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8008ec:	00 
  8008ed:	c7 04 24 94 46 80 00 	movl   $0x804694,(%esp)
  8008f4:	e8 d0 14 00 00       	call   801dc9 <_panic>
	assert(!block_is_free(1));
  8008f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800900:	e8 ed fe ff ff       	call   8007f2 <block_is_free>
  800905:	84 c0                	test   %al,%al
  800907:	74 24                	je     80092d <check_bitmap+0xbe>
  800909:	c7 44 24 0c 0a 47 80 	movl   $0x80470a,0xc(%esp)
  800910:	00 
  800911:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  800918:	00 
  800919:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  800920:	00 
  800921:	c7 04 24 94 46 80 00 	movl   $0x804694,(%esp)
  800928:	e8 9c 14 00 00       	call   801dc9 <_panic>

	cprintf("bitmap is good\n");
  80092d:	c7 04 24 1c 47 80 00 	movl   $0x80471c,(%esp)
  800934:	e8 89 15 00 00       	call   801ec2 <cprintf>
}
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	5b                   	pop    %ebx
  80093d:	5e                   	pop    %esi
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);

       // Find a JOS disk.  Use the second IDE disk (number 1) if availabl
       if (ide_probe_disk1())
  800946:	e8 14 f7 ff ff       	call   80005f <ide_probe_disk1>
  80094b:	84 c0                	test   %al,%al
  80094d:	74 0e                	je     80095d <fs_init+0x1d>
               ide_set_disk(1);
  80094f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800956:	e8 68 f7 ff ff       	call   8000c3 <ide_set_disk>
  80095b:	eb 0c                	jmp    800969 <fs_init+0x29>
       else
               ide_set_disk(0);
  80095d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800964:	e8 5a f7 ff ff       	call   8000c3 <ide_set_disk>
	bc_init();
  800969:	e8 30 fc ff ff       	call   80059e <bc_init>

	// Set "super" to point to the super block.
	super = diskaddr(1);
  80096e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800975:	e8 9a fa ff ff       	call   800414 <diskaddr>
  80097a:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	check_super();
  80097f:	e8 0c fe ff ff       	call   800790 <check_super>

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  800984:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80098b:	e8 84 fa ff ff       	call   800414 <diskaddr>
  800990:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_bitmap();
  800995:	e8 d5 fe ff ff       	call   80086f <check_bitmap>
	
}
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	53                   	push   %ebx
  8009a0:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8009a3:	bb 01 00 00 00       	mov    $0x1,%ebx
  8009a8:	eb 13                	jmp    8009bd <fs_sync+0x21>
		flush_block(diskaddr(i));
  8009aa:	89 1c 24             	mov    %ebx,(%esp)
  8009ad:	e8 62 fa ff ff       	call   800414 <diskaddr>
  8009b2:	89 04 24             	mov    %eax,(%esp)
  8009b5:	e8 e6 fa ff ff       	call   8004a0 <flush_block>
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8009ba:	83 c3 01             	add    $0x1,%ebx
  8009bd:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8009c2:	3b 58 04             	cmp    0x4(%eax),%ebx
  8009c5:	72 e3                	jb     8009aa <fs_sync+0xe>
		flush_block(diskaddr(i));
}
  8009c7:	83 c4 14             	add    $0x14,%esp
  8009ca:	5b                   	pop    %ebx
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    

008009cd <fs_evict>:

int fs_evict(void)
{
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	57                   	push   %edi
  8009d1:	56                   	push   %esi
  8009d2:	53                   	push   %ebx
  8009d3:	83 ec 2c             	sub    $0x2c,%esp
	void *addr;
	int busy_block = -E_NO_DISK;
	for(busy_block=2;busy_block< super->s_nblocks;busy_block++)
  8009d6:	bb 02 00 00 00       	mov    $0x2,%ebx
  8009db:	e9 e3 00 00 00       	jmp    800ac3 <fs_evict+0xf6>
	{
		if(!block_is_free(busy_block))
  8009e0:	89 1c 24             	mov    %ebx,(%esp)
  8009e3:	e8 0a fe ff ff       	call   8007f2 <block_is_free>
  8009e8:	84 c0                	test   %al,%al
  8009ea:	0f 85 d0 00 00 00    	jne    800ac0 <fs_evict+0xf3>
		{
			addr = diskaddr(busy_block);
  8009f0:	89 34 24             	mov    %esi,(%esp)
  8009f3:	e8 1c fa ff ff       	call   800414 <diskaddr>
  8009f8:	89 c7                	mov    %eax,%edi
			if(va_is_mapped(addr))
  8009fa:	89 04 24             	mov    %eax,(%esp)
  8009fd:	e8 58 fa ff ff       	call   80045a <va_is_mapped>
  800a02:	84 c0                	test   %al,%al
  800a04:	0f 84 b6 00 00 00    	je     800ac0 <fs_evict+0xf3>
			{
				if((uvpt[PGNUM(addr)] & PTE_A))
  800a0a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800a0d:	89 f8                	mov    %edi,%eax
  800a0f:	c1 e8 0c             	shr    $0xc,%eax
  800a12:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a19:	a8 20                	test   $0x20,%al
  800a1b:	0f 84 9f 00 00 00    	je     800ac0 <fs_evict+0xf3>
				{
					assert(!block_is_free(busy_block));
  800a21:	89 34 24             	mov    %esi,(%esp)
  800a24:	e8 c9 fd ff ff       	call   8007f2 <block_is_free>
  800a29:	84 c0                	test   %al,%al
  800a2b:	74 24                	je     800a51 <fs_evict+0x84>
  800a2d:	c7 44 24 0c 2c 47 80 	movl   $0x80472c,0xc(%esp)
  800a34:	00 
  800a35:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  800a3c:	00 
  800a3d:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  800a44:	00 
  800a45:	c7 04 24 94 46 80 00 	movl   $0x804694,(%esp)
  800a4c:	e8 78 13 00 00       	call   801dc9 <_panic>
					if(va_is_dirty(addr))
  800a51:	89 3c 24             	mov    %edi,(%esp)
  800a54:	e8 2f fa ff ff       	call   800488 <va_is_dirty>
  800a59:	84 c0                	test   %al,%al
  800a5b:	74 08                	je     800a65 <fs_evict+0x98>
						flush_block(addr);
  800a5d:	89 3c 24             	mov    %edi,(%esp)
  800a60:	e8 3b fa ff ff       	call   8004a0 <flush_block>
					sys_page_unmap(0, addr);
  800a65:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a70:	e8 d7 1f 00 00       	call   802a4c <sys_page_unmap>
					free_block(busy_block);
  800a75:	89 34 24             	mov    %esi,(%esp)
  800a78:	e8 ae fd ff ff       	call   80082b <free_block>
					cprintf("\nsuccessfully removed disk block at address:%p\n",(uintptr_t)addr);
  800a7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a84:	c7 04 24 84 47 80 00 	movl   $0x804784,(%esp)
  800a8b:	e8 32 14 00 00       	call   801ec2 <cprintf>
					assert(block_is_free(busy_block));
  800a90:	89 34 24             	mov    %esi,(%esp)
  800a93:	e8 5a fd ff ff       	call   8007f2 <block_is_free>
  800a98:	84 c0                	test   %al,%al
  800a9a:	75 37                	jne    800ad3 <fs_evict+0x106>
  800a9c:	c7 44 24 0c 2d 47 80 	movl   $0x80472d,0xc(%esp)
  800aa3:	00 
  800aa4:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  800aab:	00 
  800aac:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  800ab3:	00 
  800ab4:	c7 04 24 94 46 80 00 	movl   $0x804694,(%esp)
  800abb:	e8 09 13 00 00       	call   801dc9 <_panic>

int fs_evict(void)
{
	void *addr;
	int busy_block = -E_NO_DISK;
	for(busy_block=2;busy_block< super->s_nblocks;busy_block++)
  800ac0:	83 c3 01             	add    $0x1,%ebx
  800ac3:	89 de                	mov    %ebx,%esi
  800ac5:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800aca:	3b 58 04             	cmp    0x4(%eax),%ebx
  800acd:	0f 82 0d ff ff ff    	jb     8009e0 <fs_evict+0x13>
				}
			}
		}
	}
	return busy_block;	
}
  800ad3:	89 d8                	mov    %ebx,%eax
  800ad5:	83 c4 2c             	add    $0x2c,%esp
  800ad8:	5b                   	pop    %ebx
  800ad9:	5e                   	pop    %esi
  800ada:	5f                   	pop    %edi
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    

00800add <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	56                   	push   %esi
  800ae1:	53                   	push   %ebx
  800ae2:	83 ec 10             	sub    $0x10,%esp
	//panic("alloc_block not implemented");
	char *mapEntry;
	uint32_t free_block;
	uint32_t set_block_busy=0;
	uint32_t bitmap_block=0;
	for(free_block=2;free_block< super->s_nblocks;free_block++)
  800ae5:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800aea:	8b 70 04             	mov    0x4(%eax),%esi
  800aed:	bb 02 00 00 00       	mov    $0x2,%ebx
  800af2:	eb 0f                	jmp    800b03 <alloc_block+0x26>
	{
		if(block_is_free(free_block))
  800af4:	89 1c 24             	mov    %ebx,(%esp)
  800af7:	e8 f6 fc ff ff       	call   8007f2 <block_is_free>
  800afc:	84 c0                	test   %al,%al
  800afe:	75 0b                	jne    800b0b <alloc_block+0x2e>
	//panic("alloc_block not implemented");
	char *mapEntry;
	uint32_t free_block;
	uint32_t set_block_busy=0;
	uint32_t bitmap_block=0;
	for(free_block=2;free_block< super->s_nblocks;free_block++)
  800b00:	83 c3 01             	add    $0x1,%ebx
  800b03:	39 f3                	cmp    %esi,%ebx
  800b05:	72 ed                	jb     800af4 <alloc_block+0x17>
  800b07:	89 d8                	mov    %ebx,%eax
  800b09:	eb 02                	jmp    800b0d <alloc_block+0x30>
  800b0b:	89 d8                	mov    %ebx,%eax
	{
		if(block_is_free(free_block))
			break;
	}
	if(free_block == super->s_nblocks){
  800b0d:	39 c6                	cmp    %eax,%esi
  800b0f:	75 0c                	jne    800b1d <alloc_block+0x40>
		//call evict block policy
		free_block = fs_evict();
  800b11:	e8 b7 fe ff ff       	call   8009cd <fs_evict>
  800b16:	89 c3                	mov    %eax,%ebx
		if(free_block == E_NO_DISK)
  800b18:	83 f8 09             	cmp    $0x9,%eax
  800b1b:	74 34                	je     800b51 <alloc_block+0x74>
			return -E_NO_DISK;
	}
	set_block_busy = ~(1<<(free_block%32));
	bitmap[free_block/32] &= set_block_busy; 
  800b1d:	89 da                	mov    %ebx,%edx
  800b1f:	c1 ea 05             	shr    $0x5,%edx
  800b22:	a1 08 a0 80 00       	mov    0x80a008,%eax
		//call evict block policy
		free_block = fs_evict();
		if(free_block == E_NO_DISK)
			return -E_NO_DISK;
	}
	set_block_busy = ~(1<<(free_block%32));
  800b27:	be 01 00 00 00       	mov    $0x1,%esi
  800b2c:	89 d9                	mov    %ebx,%ecx
  800b2e:	d3 e6                	shl    %cl,%esi
  800b30:	f7 d6                	not    %esi
	bitmap[free_block/32] &= set_block_busy; 
  800b32:	21 34 90             	and    %esi,(%eax,%edx,4)
	flush_block(diskaddr(2+(free_block/BLKBITSIZE)));
  800b35:	89 d8                	mov    %ebx,%eax
  800b37:	c1 e8 0f             	shr    $0xf,%eax
  800b3a:	83 c0 02             	add    $0x2,%eax
  800b3d:	89 04 24             	mov    %eax,(%esp)
  800b40:	e8 cf f8 ff ff       	call   800414 <diskaddr>
  800b45:	89 04 24             	mov    %eax,(%esp)
  800b48:	e8 53 f9 ff ff       	call   8004a0 <flush_block>

	return free_block;
  800b4d:	89 d8                	mov    %ebx,%eax
  800b4f:	eb 05                	jmp    800b56 <alloc_block+0x79>
	}
	if(free_block == super->s_nblocks){
		//call evict block policy
		free_block = fs_evict();
		if(free_block == E_NO_DISK)
			return -E_NO_DISK;
  800b51:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
	set_block_busy = ~(1<<(free_block%32));
	bitmap[free_block/32] &= set_block_busy; 
	flush_block(diskaddr(2+(free_block/BLKBITSIZE)));

	return free_block;
}
  800b56:	83 c4 10             	add    $0x10,%esp
  800b59:	5b                   	pop    %ebx
  800b5a:	5e                   	pop    %esi
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	57                   	push   %edi
  800b61:	56                   	push   %esi
  800b62:	53                   	push   %ebx
  800b63:	83 ec 1c             	sub    $0x1c,%esp
  800b66:	89 c6                	mov    %eax,%esi
  800b68:	89 d3                	mov    %edx,%ebx
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
       // LAB 5: Your code here.
       //panic("file_block_walk not implemented");
	uint32_t new_blockno = -E_NOT_FOUND;
	uint32_t *addr = NULL;
	int i=0;
	if(filebno >= (NDIRECT + NINDIRECT))
  800b6d:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  800b73:	0f 87 91 00 00 00    	ja     800c0a <file_block_walk+0xad>
  800b79:	89 cf                	mov    %ecx,%edi
		return -E_INVAL;
	//check filebno-1 or filebno=0
	//cprintf("\nfilebno:%d\n",filebno);
	//for(i=0;i<=9;i++)
	//	cprintf("\nf->direct[%d]:%d\n",i,f->f_direct[i]);
	if(filebno < NDIRECT){
  800b7b:	83 fa 09             	cmp    $0x9,%edx
  800b7e:	77 13                	ja     800b93 <file_block_walk+0x36>
		*ppdiskbno = &(f->f_direct[filebno]);
  800b80:	8d 84 96 88 00 00 00 	lea    0x88(%esi,%edx,4),%eax
  800b87:	89 01                	mov    %eax,(%ecx)
		return 0;
  800b89:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8e:	e9 83 00 00 00       	jmp    800c16 <file_block_walk+0xb9>
	}
	else
	{
		if(f->f_indirect)
  800b93:	8b 96 b0 00 00 00    	mov    0xb0(%esi),%edx
  800b99:	85 d2                	test   %edx,%edx
  800b9b:	74 15                	je     800bb2 <file_block_walk+0x55>
		{
			addr = diskaddr(f->f_indirect);
  800b9d:	89 14 24             	mov    %edx,(%esp)
  800ba0:	e8 6f f8 ff ff       	call   800414 <diskaddr>
			addr = addr + (filebno-NDIRECT);
  800ba5:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  800ba9:	89 07                	mov    %eax,(%edi)
			*ppdiskbno = addr;
			return 0;
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb0:	eb 64                	jmp    800c16 <file_block_walk+0xb9>
		}
	}

	if(alloc)
  800bb2:	84 c0                	test   %al,%al
  800bb4:	74 5b                	je     800c11 <file_block_walk+0xb4>
	{
		if(!(f->f_indirect))
		{
			new_blockno = alloc_block();
  800bb6:	e8 22 ff ff ff       	call   800add <alloc_block>
			if(new_blockno<0)
				return new_blockno;
			memset(diskaddr(new_blockno), 0, BLKSIZE);
  800bbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bbe:	89 04 24             	mov    %eax,(%esp)
  800bc1:	e8 4e f8 ff ff       	call   800414 <diskaddr>
  800bc6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800bcd:	00 
  800bce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800bd5:	00 
  800bd6:	89 04 24             	mov    %eax,(%esp)
  800bd9:	e8 a9 1a 00 00       	call   802687 <memset>
			f->f_indirect = new_blockno;
  800bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800be1:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
			flush_block(f);
  800be7:	89 34 24             	mov    %esi,(%esp)
  800bea:	e8 b1 f8 ff ff       	call   8004a0 <flush_block>
		}
		addr = diskaddr(f->f_indirect);
  800bef:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800bf5:	89 04 24             	mov    %eax,(%esp)
  800bf8:	e8 17 f8 ff ff       	call   800414 <diskaddr>
		addr = addr + (filebno-NDIRECT);
  800bfd:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  800c01:	89 07                	mov    %eax,(%edi)
		*ppdiskbno = addr;
		return 0;
  800c03:	b8 00 00 00 00       	mov    $0x0,%eax
  800c08:	eb 0c                	jmp    800c16 <file_block_walk+0xb9>
       //panic("file_block_walk not implemented");
	uint32_t new_blockno = -E_NOT_FOUND;
	uint32_t *addr = NULL;
	int i=0;
	if(filebno >= (NDIRECT + NINDIRECT))
		return -E_INVAL;
  800c0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c0f:	eb 05                	jmp    800c16 <file_block_walk+0xb9>
		addr = addr + (filebno-NDIRECT);
		*ppdiskbno = addr;
		return 0;
	}
		
	return -E_NOT_FOUND;
  800c11:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800c16:	83 c4 1c             	add    $0x1c,%esp
  800c19:	5b                   	pop    %ebx
  800c1a:	5e                   	pop    %esi
  800c1b:	5f                   	pop    %edi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 2c             	sub    $0x2c,%esp
  800c27:	8b 75 08             	mov    0x8(%ebp),%esi
	if (f->f_size > newsize)
  800c2a:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800c30:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c33:	0f 8e 9a 00 00 00    	jle    800cd3 <file_set_size+0xb5>
file_truncate_blocks(struct File *f, off_t newsize)
{
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800c39:	8d b8 fe 1f 00 00    	lea    0x1ffe(%eax),%edi
  800c3f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800c44:	0f 49 f8             	cmovns %eax,%edi
  800c47:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4d:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800c53:	05 ff 0f 00 00       	add    $0xfff,%eax
  800c58:	0f 48 c2             	cmovs  %edx,%eax
  800c5b:	c1 f8 0c             	sar    $0xc,%eax
  800c5e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800c61:	89 c3                	mov    %eax,%ebx
  800c63:	eb 34                	jmp    800c99 <file_set_size+0x7b>
file_free_block(struct File *f, uint32_t filebno)
{
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800c65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c6c:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800c6f:	89 da                	mov    %ebx,%edx
  800c71:	89 f0                	mov    %esi,%eax
  800c73:	e8 e5 fe ff ff       	call   800b5d <file_block_walk>
  800c78:	85 c0                	test   %eax,%eax
  800c7a:	78 45                	js     800cc1 <file_set_size+0xa3>
		return r;
	if (*ptr) {
  800c7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c7f:	8b 00                	mov    (%eax),%eax
  800c81:	85 c0                	test   %eax,%eax
  800c83:	74 11                	je     800c96 <file_set_size+0x78>
		free_block(*ptr);
  800c85:	89 04 24             	mov    %eax,(%esp)
  800c88:	e8 9e fb ff ff       	call   80082b <free_block>
		*ptr = 0;
  800c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800c96:	83 c3 01             	add    $0x1,%ebx
  800c99:	39 df                	cmp    %ebx,%edi
  800c9b:	77 c8                	ja     800c65 <file_set_size+0x47>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800c9d:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  800ca1:	77 30                	ja     800cd3 <file_set_size+0xb5>
  800ca3:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	74 26                	je     800cd3 <file_set_size+0xb5>
		free_block(f->f_indirect);
  800cad:	89 04 24             	mov    %eax,(%esp)
  800cb0:	e8 76 fb ff ff       	call   80082b <free_block>
		f->f_indirect = 0;
  800cb5:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800cbc:	00 00 00 
  800cbf:	eb 12                	jmp    800cd3 <file_set_size+0xb5>

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);
  800cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc5:	c7 04 24 47 47 80 00 	movl   $0x804747,(%esp)
  800ccc:	e8 f1 11 00 00       	call   801ec2 <cprintf>
  800cd1:	eb c3                	jmp    800c96 <file_set_size+0x78>
int
file_set_size(struct File *f, off_t newsize)
{
	if (f->f_size > newsize)
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd6:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	flush_block(f);
  800cdc:	89 34 24             	mov    %esi,(%esp)
  800cdf:	e8 bc f7 ff ff       	call   8004a0 <flush_block>
	return 0;
}
  800ce4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce9:	83 c4 2c             	add    $0x2c,%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
  800cf6:	83 ec 20             	sub    $0x20,%esp
  800cf9:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800cfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d01:	eb 37                	jmp    800d3a <file_flush+0x49>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800d03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d0a:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800d0d:	89 da                	mov    %ebx,%edx
  800d0f:	89 f0                	mov    %esi,%eax
  800d11:	e8 47 fe ff ff       	call   800b5d <file_block_walk>
  800d16:	85 c0                	test   %eax,%eax
  800d18:	78 1d                	js     800d37 <file_flush+0x46>
		    pdiskbno == NULL || *pdiskbno == 0)
  800d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	74 16                	je     800d37 <file_flush+0x46>
		    pdiskbno == NULL || *pdiskbno == 0)
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	85 c0                	test   %eax,%eax
  800d25:	74 10                	je     800d37 <file_flush+0x46>
			continue;
		flush_block(diskaddr(*pdiskbno));
  800d27:	89 04 24             	mov    %eax,(%esp)
  800d2a:	e8 e5 f6 ff ff       	call   800414 <diskaddr>
  800d2f:	89 04 24             	mov    %eax,(%esp)
  800d32:	e8 69 f7 ff ff       	call   8004a0 <flush_block>
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800d37:	83 c3 01             	add    $0x1,%ebx
  800d3a:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  800d40:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  800d46:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  800d4c:	85 c9                	test   %ecx,%ecx
  800d4e:	0f 49 c1             	cmovns %ecx,%eax
  800d51:	c1 f8 0c             	sar    $0xc,%eax
  800d54:	39 c3                	cmp    %eax,%ebx
  800d56:	7c ab                	jl     800d03 <file_flush+0x12>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  800d58:	89 34 24             	mov    %esi,(%esp)
  800d5b:	e8 40 f7 ff ff       	call   8004a0 <flush_block>
	if (f->f_indirect)
  800d60:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800d66:	85 c0                	test   %eax,%eax
  800d68:	74 10                	je     800d7a <file_flush+0x89>
		flush_block(diskaddr(f->f_indirect));
  800d6a:	89 04 24             	mov    %eax,(%esp)
  800d6d:	e8 a2 f6 ff ff       	call   800414 <diskaddr>
  800d72:	89 04 24             	mov    %eax,(%esp)
  800d75:	e8 26 f7 ff ff       	call   8004a0 <flush_block>
}
  800d7a:	83 c4 20             	add    $0x20,%esp
  800d7d:	5b                   	pop    %ebx
  800d7e:	5e                   	pop    %esi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	53                   	push   %ebx
  800d85:	83 ec 24             	sub    $0x24,%esp
       //panic("file_get_block not implemented");
	uint32_t *block_holder;
	uint32_t blockno=0;
	int r=-1;
	//cprintf("\nfilebno:%d\n", filebno);
	if((r=file_block_walk(f, filebno, &block_holder, 1)) < 0)
  800d88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800d8f:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800d92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	e8 c0 fd ff ff       	call   800b5d <file_block_walk>
  800d9d:	85 c0                	test   %eax,%eax
  800d9f:	78 47                	js     800de8 <file_get_block+0x67>
		return r;
	blockno = *block_holder;
  800da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da4:	8b 18                	mov    (%eax),%ebx
	//cprintf("\nblkno:%d\n", blockno);
	if(!blockno)
  800da6:	85 db                	test   %ebx,%ebx
  800da8:	75 2c                	jne    800dd6 <file_get_block+0x55>
	{
		blockno = alloc_block();
  800daa:	e8 2e fd ff ff       	call   800add <alloc_block>
  800daf:	89 c3                	mov    %eax,%ebx
		//cprintf("\nnew block assigned:%d\n",blockno);
		if(blockno<0)
			return blockno;
		memset(diskaddr(blockno), 0, BLKSIZE);
  800db1:	89 04 24             	mov    %eax,(%esp)
  800db4:	e8 5b f6 ff ff       	call   800414 <diskaddr>
  800db9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800dc0:	00 
  800dc1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800dc8:	00 
  800dc9:	89 04 24             	mov    %eax,(%esp)
  800dcc:	e8 b6 18 00 00       	call   802687 <memset>
		*block_holder = blockno;
  800dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd4:	89 18                	mov    %ebx,(%eax)
		//flush_block(f);
	}
	*blk = diskaddr(blockno);
  800dd6:	89 1c 24             	mov    %ebx,(%esp)
  800dd9:	e8 36 f6 ff ff       	call   800414 <diskaddr>
  800dde:	8b 55 10             	mov    0x10(%ebp),%edx
  800de1:	89 02                	mov    %eax,(%edx)
	return 0;
  800de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de8:	83 c4 24             	add    $0x24,%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	57                   	push   %edi
  800df2:	56                   	push   %esi
  800df3:	53                   	push   %ebx
  800df4:	81 ec cc 00 00 00    	sub    $0xcc,%esp
  800dfa:	89 95 44 ff ff ff    	mov    %edx,-0xbc(%ebp)
  800e00:	89 8d 40 ff ff ff    	mov    %ecx,-0xc0(%ebp)
  800e06:	eb 03                	jmp    800e0b <walk_path+0x1d>
// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
		p++;
  800e08:	83 c0 01             	add    $0x1,%eax

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  800e0b:	80 38 2f             	cmpb   $0x2f,(%eax)
  800e0e:	74 f8                	je     800e08 <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800e10:	8b 0d 0c a0 80 00    	mov    0x80a00c,%ecx
  800e16:	83 c1 08             	add    $0x8,%ecx
  800e19:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
	dir = 0;
	name[0] = 0;
  800e1f:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800e26:	8b 8d 44 ff ff ff    	mov    -0xbc(%ebp),%ecx
  800e2c:	85 c9                	test   %ecx,%ecx
  800e2e:	74 06                	je     800e36 <walk_path+0x48>
		*pdir = 0;
  800e30:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800e36:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800e3c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
	dir = 0;
  800e42:	ba 00 00 00 00       	mov    $0x0,%edx
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  800e47:	e9 71 01 00 00       	jmp    800fbd <walk_path+0x1cf>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800e4c:	83 c7 01             	add    $0x1,%edi
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800e4f:	0f b6 17             	movzbl (%edi),%edx
  800e52:	84 d2                	test   %dl,%dl
  800e54:	74 05                	je     800e5b <walk_path+0x6d>
  800e56:	80 fa 2f             	cmp    $0x2f,%dl
  800e59:	75 f1                	jne    800e4c <walk_path+0x5e>
			path++;
		if (path - p >= MAXNAMELEN)
  800e5b:	89 fb                	mov    %edi,%ebx
  800e5d:	29 c3                	sub    %eax,%ebx
  800e5f:	83 fb 7f             	cmp    $0x7f,%ebx
  800e62:	0f 8f 82 01 00 00    	jg     800fea <walk_path+0x1fc>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800e68:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e70:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800e76:	89 04 24             	mov    %eax,(%esp)
  800e79:	e8 56 18 00 00       	call   8026d4 <memmove>
		name[path - p] = '\0';
  800e7e:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800e85:	00 
  800e86:	eb 03                	jmp    800e8b <walk_path+0x9d>
// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
		p++;
  800e88:	83 c7 01             	add    $0x1,%edi

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  800e8b:	80 3f 2f             	cmpb   $0x2f,(%edi)
  800e8e:	74 f8                	je     800e88 <walk_path+0x9a>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800e90:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800e96:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800e9d:	0f 85 4e 01 00 00    	jne    800ff1 <walk_path+0x203>
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  800ea3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800ea9:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800eae:	74 24                	je     800ed4 <walk_path+0xe6>
  800eb0:	c7 44 24 0c 64 47 80 	movl   $0x804764,0xc(%esp)
  800eb7:	00 
  800eb8:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  800ebf:	00 
  800ec0:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  800ec7:	00 
  800ec8:	c7 04 24 94 46 80 00 	movl   $0x804694,(%esp)
  800ecf:	e8 f5 0e 00 00       	call   801dc9 <_panic>
	nblock = dir->f_size / BLKSIZE;
  800ed4:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800eda:	85 c0                	test   %eax,%eax
  800edc:	0f 48 c2             	cmovs  %edx,%eax
  800edf:	c1 f8 0c             	sar    $0xc,%eax
  800ee2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
	for (i = 0; i < nblock; i++) {
  800ee8:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
  800eef:	00 00 00 
  800ef2:	89 bd 48 ff ff ff    	mov    %edi,-0xb8(%ebp)
  800ef8:	eb 61                	jmp    800f5b <walk_path+0x16d>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800efa:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800f00:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f04:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f0e:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800f14:	89 04 24             	mov    %eax,(%esp)
  800f17:	e8 65 fe ff ff       	call   800d81 <file_get_block>
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	0f 88 ea 00 00 00    	js     80100e <walk_path+0x220>
  800f24:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
			return r;
		f = (struct File*) blk;
  800f2a:	be 10 00 00 00       	mov    $0x10,%esi
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800f2f:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800f35:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f39:	89 1c 24             	mov    %ebx,(%esp)
  800f3c:	e8 ab 16 00 00       	call   8025ec <strcmp>
  800f41:	85 c0                	test   %eax,%eax
  800f43:	0f 84 af 00 00 00    	je     800ff8 <walk_path+0x20a>
  800f49:	81 c3 00 01 00 00    	add    $0x100,%ebx
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  800f4f:	83 ee 01             	sub    $0x1,%esi
  800f52:	75 db                	jne    800f2f <walk_path+0x141>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  800f54:	83 85 54 ff ff ff 01 	addl   $0x1,-0xac(%ebp)
  800f5b:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800f61:	39 85 4c ff ff ff    	cmp    %eax,-0xb4(%ebp)
  800f67:	75 91                	jne    800efa <walk_path+0x10c>
  800f69:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800f6f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800f74:	80 3f 00             	cmpb   $0x0,(%edi)
  800f77:	0f 85 a0 00 00 00    	jne    80101d <walk_path+0x22f>
				if (pdir)
  800f7d:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800f83:	85 c0                	test   %eax,%eax
  800f85:	74 08                	je     800f8f <walk_path+0x1a1>
					*pdir = dir;
  800f87:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800f8d:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800f8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f93:	74 15                	je     800faa <walk_path+0x1bc>
					strcpy(lastelem, name);
  800f95:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800f9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	89 04 24             	mov    %eax,(%esp)
  800fa5:	e8 8d 15 00 00       	call   802537 <strcpy>
				*pf = 0;
  800faa:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800fb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			}
			return r;
  800fb6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800fbb:	eb 60                	jmp    80101d <walk_path+0x22f>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  800fbd:	80 38 00             	cmpb   $0x0,(%eax)
  800fc0:	74 07                	je     800fc9 <walk_path+0x1db>
  800fc2:	89 c7                	mov    %eax,%edi
  800fc4:	e9 86 fe ff ff       	jmp    800e4f <walk_path+0x61>
			}
			return r;
		}
	}

	if (pdir)
  800fc9:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	74 02                	je     800fd5 <walk_path+0x1e7>
		*pdir = dir;
  800fd3:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800fd5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800fdb:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800fe1:	89 08                	mov    %ecx,(%eax)
	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe8:	eb 33                	jmp    80101d <walk_path+0x22f>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
		if (path - p >= MAXNAMELEN)
			return -E_BAD_PATH;
  800fea:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800fef:	eb 2c                	jmp    80101d <walk_path+0x22f>
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;
  800ff1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800ff6:	eb 25                	jmp    80101d <walk_path+0x22f>
  800ff8:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
  800ffe:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  801004:	89 9d 50 ff ff ff    	mov    %ebx,-0xb0(%ebp)
  80100a:	89 f8                	mov    %edi,%eax
  80100c:	eb af                	jmp    800fbd <walk_path+0x1cf>
  80100e:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  801014:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801017:	0f 84 52 ff ff ff    	je     800f6f <walk_path+0x181>

	if (pdir)
		*pdir = dir;
	*pf = f;
	return 0;
}
  80101d:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  801023:	5b                   	pop    %ebx
  801024:	5e                   	pop    %esi
  801025:	5f                   	pop    %edi
  801026:	5d                   	pop    %ebp
  801027:	c3                   	ret    

00801028 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 18             	sub    $0x18,%esp
	return walk_path(path, 0, pf, 0);
  80102e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801035:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801038:	ba 00 00 00 00       	mov    $0x0,%edx
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	e8 a9 fd ff ff       	call   800dee <walk_path>
}
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	57                   	push   %edi
  80104b:	56                   	push   %esi
  80104c:	53                   	push   %ebx
  80104d:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801053:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801059:	89 04 24             	mov    %eax,(%esp)
  80105c:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  801062:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	e8 7e fd ff ff       	call   800dee <walk_path>
  801070:	89 c2                	mov    %eax,%edx
  801072:	85 c0                	test   %eax,%eax
  801074:	0f 84 e0 00 00 00    	je     80115a <file_create+0x113>
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
  80107a:	83 fa f5             	cmp    $0xfffffff5,%edx
  80107d:	0f 85 1b 01 00 00    	jne    80119e <file_create+0x157>
  801083:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  801089:	85 f6                	test   %esi,%esi
  80108b:	0f 84 d0 00 00 00    	je     801161 <file_create+0x11a>
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  801091:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  801097:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80109c:	74 24                	je     8010c2 <file_create+0x7b>
  80109e:	c7 44 24 0c 64 47 80 	movl   $0x804764,0xc(%esp)
  8010a5:	00 
  8010a6:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  8010ad:	00 
  8010ae:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  8010b5:	00 
  8010b6:	c7 04 24 94 46 80 00 	movl   $0x804694,(%esp)
  8010bd:	e8 07 0d 00 00       	call   801dc9 <_panic>
	nblock = dir->f_size / BLKSIZE;
  8010c2:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	0f 48 c2             	cmovs  %edx,%eax
  8010cd:	c1 f8 0c             	sar    $0xc,%eax
  8010d0:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
  8010d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010db:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8010e1:	eb 3d                	jmp    801120 <file_create+0xd9>
  8010e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8010e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010eb:	89 34 24             	mov    %esi,(%esp)
  8010ee:	e8 8e fc ff ff       	call   800d81 <file_get_block>
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	0f 88 a3 00 00 00    	js     80119e <file_create+0x157>
  8010fb:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
			return r;
		f = (struct File*) blk;
  801101:	ba 10 00 00 00       	mov    $0x10,%edx
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0') {
  801106:	80 38 00             	cmpb   $0x0,(%eax)
  801109:	75 08                	jne    801113 <file_create+0xcc>
				*file = &f[j];
  80110b:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  801111:	eb 55                	jmp    801168 <file_create+0x121>
  801113:	05 00 01 00 00       	add    $0x100,%eax
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  801118:	83 ea 01             	sub    $0x1,%edx
  80111b:	75 e9                	jne    801106 <file_create+0xbf>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  80111d:	83 c3 01             	add    $0x1,%ebx
  801120:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  801126:	75 bb                	jne    8010e3 <file_create+0x9c>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  801128:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  80112f:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801132:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  801138:	89 44 24 08          	mov    %eax,0x8(%esp)
  80113c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801140:	89 34 24             	mov    %esi,(%esp)
  801143:	e8 39 fc ff ff       	call   800d81 <file_get_block>
  801148:	85 c0                	test   %eax,%eax
  80114a:	78 52                	js     80119e <file_create+0x157>
		return r;
	f = (struct File*) blk;
	*file = &f[0];
  80114c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801152:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  801158:	eb 0e                	jmp    801168 <file_create+0x121>
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
		return -E_FILE_EXISTS;
  80115a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80115f:	eb 3d                	jmp    80119e <file_create+0x157>
	if (r != -E_NOT_FOUND || dir == 0)
		return r;
  801161:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  801166:	eb 36                	jmp    80119e <file_create+0x157>
	if ((r = dir_alloc_file(dir, &f)) < 0)
		return r;

	strcpy(f->f_name, name);
  801168:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  80116e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801172:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801178:	89 04 24             	mov    %eax,(%esp)
  80117b:	e8 b7 13 00 00       	call   802537 <strcpy>
	*pf = f;
  801180:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  80118b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801191:	89 04 24             	mov    %eax,(%esp)
  801194:	e8 58 fb ff ff       	call   800cf1 <file_flush>
	return 0;
  801199:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119e:	81 c4 bc 00 00 00    	add    $0xbc,%esp
  8011a4:	5b                   	pop    %ebx
  8011a5:	5e                   	pop    %esi
  8011a6:	5f                   	pop    %edi
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	57                   	push   %edi
  8011ad:	56                   	push   %esi
  8011ae:	53                   	push   %ebx
  8011af:	83 ec 3c             	sub    $0x3c,%esp
  8011b2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8011b5:	8b 55 14             	mov    0x14(%ebp),%edx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
		return 0;
  8011c1:	b8 00 00 00 00       	mov    $0x0,%eax
{
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8011c6:	39 d1                	cmp    %edx,%ecx
  8011c8:	0f 8e 83 00 00 00    	jle    801251 <file_read+0xa8>
		return 0;

	count = MIN(count, f->f_size - offset);
  8011ce:	29 d1                	sub    %edx,%ecx
  8011d0:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8011d3:	0f 47 4d 10          	cmova  0x10(%ebp),%ecx
  8011d7:	89 4d d0             	mov    %ecx,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  8011da:	89 d3                	mov    %edx,%ebx
  8011dc:	01 ca                	add    %ecx,%edx
  8011de:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8011e1:	eb 64                	jmp    801247 <file_read+0x9e>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  8011e3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011ea:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  8011f0:	85 db                	test   %ebx,%ebx
  8011f2:	0f 49 c3             	cmovns %ebx,%eax
  8011f5:	c1 f8 0c             	sar    $0xc,%eax
  8011f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	89 04 24             	mov    %eax,(%esp)
  801202:	e8 7a fb ff ff       	call   800d81 <file_get_block>
  801207:	85 c0                	test   %eax,%eax
  801209:	78 46                	js     801251 <file_read+0xa8>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  80120b:	89 da                	mov    %ebx,%edx
  80120d:	c1 fa 1f             	sar    $0x1f,%edx
  801210:	c1 ea 14             	shr    $0x14,%edx
  801213:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  801216:	25 ff 0f 00 00       	and    $0xfff,%eax
  80121b:	29 d0                	sub    %edx,%eax
  80121d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801222:	29 c1                	sub    %eax,%ecx
  801224:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801227:	29 f2                	sub    %esi,%edx
  801229:	39 d1                	cmp    %edx,%ecx
  80122b:	89 d6                	mov    %edx,%esi
  80122d:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  801230:	89 74 24 08          	mov    %esi,0x8(%esp)
  801234:	03 45 e4             	add    -0x1c(%ebp),%eax
  801237:	89 44 24 04          	mov    %eax,0x4(%esp)
  80123b:	89 3c 24             	mov    %edi,(%esp)
  80123e:	e8 91 14 00 00       	call   8026d4 <memmove>
		pos += bn;
  801243:	01 f3                	add    %esi,%ebx
		buf += bn;
  801245:	01 f7                	add    %esi,%edi
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  801247:	89 de                	mov    %ebx,%esi
  801249:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
  80124c:	72 95                	jb     8011e3 <file_read+0x3a>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  80124e:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  801251:	83 c4 3c             	add    $0x3c,%esp
  801254:	5b                   	pop    %ebx
  801255:	5e                   	pop    %esi
  801256:	5f                   	pop    %edi
  801257:	5d                   	pop    %ebp
  801258:	c3                   	ret    

00801259 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	57                   	push   %edi
  80125d:	56                   	push   %esi
  80125e:	53                   	push   %ebx
  80125f:	83 ec 2c             	sub    $0x2c,%esp
  801262:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801265:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801268:	89 d8                	mov    %ebx,%eax
  80126a:	03 45 10             	add    0x10(%ebp),%eax
  80126d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801270:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801273:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  801279:	76 7c                	jbe    8012f7 <file_write+0x9e>
		if ((r = file_set_size(f, offset + count)) < 0)
  80127b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80127e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	89 04 24             	mov    %eax,(%esp)
  801288:	e8 91 f9 ff ff       	call   800c1e <file_set_size>
  80128d:	85 c0                	test   %eax,%eax
  80128f:	79 66                	jns    8012f7 <file_write+0x9e>
  801291:	eb 6e                	jmp    801301 <file_write+0xa8>
			return r;

	for (pos = offset; pos < offset + count; ) {
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801293:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801296:	89 44 24 08          	mov    %eax,0x8(%esp)
  80129a:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  8012a0:	85 db                	test   %ebx,%ebx
  8012a2:	0f 49 c3             	cmovns %ebx,%eax
  8012a5:	c1 f8 0c             	sar    $0xc,%eax
  8012a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 04 24             	mov    %eax,(%esp)
  8012b2:	e8 ca fa ff ff       	call   800d81 <file_get_block>
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	78 46                	js     801301 <file_write+0xa8>
			return r;

		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  8012bb:	89 da                	mov    %ebx,%edx
  8012bd:	c1 fa 1f             	sar    $0x1f,%edx
  8012c0:	c1 ea 14             	shr    $0x14,%edx
  8012c3:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  8012c6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8012cb:	29 d0                	sub    %edx,%eax
  8012cd:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8012d2:	29 c1                	sub    %eax,%ecx
  8012d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8012d7:	29 f2                	sub    %esi,%edx
  8012d9:	39 d1                	cmp    %edx,%ecx
  8012db:	89 d6                	mov    %edx,%esi
  8012dd:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  8012e0:	89 74 24 08          	mov    %esi,0x8(%esp)
  8012e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012e8:	03 45 e4             	add    -0x1c(%ebp),%eax
  8012eb:	89 04 24             	mov    %eax,(%esp)
  8012ee:	e8 e1 13 00 00       	call   8026d4 <memmove>
		pos += bn;
  8012f3:	01 f3                	add    %esi,%ebx
		buf += bn;
  8012f5:	01 f7                	add    %esi,%edi
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  8012f7:	89 de                	mov    %ebx,%esi
  8012f9:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  8012fc:	77 95                	ja     801293 <file_write+0x3a>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}
	return count;
  8012fe:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801301:	83 c4 2c             	add    $0x2c,%esp
  801304:	5b                   	pop    %ebx
  801305:	5e                   	pop    %esi
  801306:	5f                   	pop    %edi
  801307:	5d                   	pop    %ebp
  801308:	c3                   	ret    
  801309:	66 90                	xchg   %ax,%ax
  80130b:	66 90                	xchg   %ax,%ax
  80130d:	66 90                	xchg   %ax,%ax
  80130f:	90                   	nop

00801310 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  801316:	e8 81 f6 ff ff       	call   80099c <fs_sync>
	return 0;
}
  80131b:	b8 00 00 00 00       	mov    $0x0,%eax
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <serve_evict>:

int
serve_evict(envid_t envid, union Fsipc *req)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	83 ec 08             	sub    $0x8,%esp

	return fs_evict();
  801328:	e8 a0 f6 ff ff       	call   8009cd <fs_evict>
}
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	ba 60 50 80 00       	mov    $0x805060,%edx
	int i;
	uintptr_t va = FILEVA;
  801337:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  80133c:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801341:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  801343:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  801346:	81 c1 00 10 00 00    	add    $0x1000,%ecx
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  80134c:	83 c0 01             	add    $0x1,%eax
  80134f:	83 c2 10             	add    $0x10,%edx
  801352:	3d 00 04 00 00       	cmp    $0x400,%eax
  801357:	75 e8                	jne    801341 <serve_init+0x12>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	56                   	push   %esi
  80135f:	53                   	push   %ebx
  801360:	83 ec 10             	sub    $0x10,%esp
  801363:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801366:	bb 00 00 00 00       	mov    $0x0,%ebx
  80136b:	89 d8                	mov    %ebx,%eax
  80136d:	c1 e0 04             	shl    $0x4,%eax
		switch (pageref(opentab[i].o_fd)) {
  801370:	8b 80 6c 50 80 00    	mov    0x80506c(%eax),%eax
  801376:	89 04 24             	mov    %eax,(%esp)
  801379:	e8 14 24 00 00       	call   803792 <pageref>
  80137e:	85 c0                	test   %eax,%eax
  801380:	74 07                	je     801389 <openfile_alloc+0x2e>
  801382:	83 f8 01             	cmp    $0x1,%eax
  801385:	74 2b                	je     8013b2 <openfile_alloc+0x57>
  801387:	eb 62                	jmp    8013eb <openfile_alloc+0x90>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801389:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801390:	00 
  801391:	89 d8                	mov    %ebx,%eax
  801393:	c1 e0 04             	shl    $0x4,%eax
  801396:	8b 80 6c 50 80 00    	mov    0x80506c(%eax),%eax
  80139c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a7:	e8 f9 15 00 00       	call   8029a5 <sys_page_alloc>
  8013ac:	89 c2                	mov    %eax,%edx
  8013ae:	85 d2                	test   %edx,%edx
  8013b0:	78 4d                	js     8013ff <openfile_alloc+0xa4>
				return r;
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  8013b2:	c1 e3 04             	shl    $0x4,%ebx
  8013b5:	8d 83 60 50 80 00    	lea    0x805060(%ebx),%eax
  8013bb:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  8013c2:	04 00 00 
			*o = &opentab[i];
  8013c5:	89 06                	mov    %eax,(%esi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8013c7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8013ce:	00 
  8013cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8013d6:	00 
  8013d7:	8b 83 6c 50 80 00    	mov    0x80506c(%ebx),%eax
  8013dd:	89 04 24             	mov    %eax,(%esp)
  8013e0:	e8 a2 12 00 00       	call   802687 <memset>
			return (*o)->o_fileid;
  8013e5:	8b 06                	mov    (%esi),%eax
  8013e7:	8b 00                	mov    (%eax),%eax
  8013e9:	eb 14                	jmp    8013ff <openfile_alloc+0xa4>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8013eb:	83 c3 01             	add    $0x1,%ebx
  8013ee:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8013f4:	0f 85 71 ff ff ff    	jne    80136b <openfile_alloc+0x10>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  8013fa:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013ff:	83 c4 10             	add    $0x10,%esp
  801402:	5b                   	pop    %ebx
  801403:	5e                   	pop    %esi
  801404:	5d                   	pop    %ebp
  801405:	c3                   	ret    

00801406 <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	57                   	push   %edi
  80140a:	56                   	push   %esi
  80140b:	53                   	push   %ebx
  80140c:	83 ec 1c             	sub    $0x1c,%esp
  80140f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  801412:	89 de                	mov    %ebx,%esi
  801414:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80141a:	c1 e6 04             	shl    $0x4,%esi
  80141d:	8d be 60 50 80 00    	lea    0x805060(%esi),%edi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  801423:	8b 86 6c 50 80 00    	mov    0x80506c(%esi),%eax
  801429:	89 04 24             	mov    %eax,(%esp)
  80142c:	e8 61 23 00 00       	call   803792 <pageref>
  801431:	83 f8 01             	cmp    $0x1,%eax
  801434:	7e 14                	jle    80144a <openfile_lookup+0x44>
  801436:	39 9e 60 50 80 00    	cmp    %ebx,0x805060(%esi)
  80143c:	75 13                	jne    801451 <openfile_lookup+0x4b>
		return -E_INVAL;
	*po = o;
  80143e:	8b 45 10             	mov    0x10(%ebp),%eax
  801441:	89 38                	mov    %edi,(%eax)
	return 0;
  801443:	b8 00 00 00 00       	mov    $0x0,%eax
  801448:	eb 0c                	jmp    801456 <openfile_lookup+0x50>
{
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
		return -E_INVAL;
  80144a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144f:	eb 05                	jmp    801456 <openfile_lookup+0x50>
  801451:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	*po = o;
	return 0;
}
  801456:	83 c4 1c             	add    $0x1c,%esp
  801459:	5b                   	pop    %ebx
  80145a:	5e                   	pop    %esi
  80145b:	5f                   	pop    %edi
  80145c:	5d                   	pop    %ebp
  80145d:	c3                   	ret    

0080145e <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	53                   	push   %ebx
  801462:	83 ec 24             	sub    $0x24,%esp
  801465:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801468:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80146f:	8b 03                	mov    (%ebx),%eax
  801471:	89 44 24 04          	mov    %eax,0x4(%esp)
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	89 04 24             	mov    %eax,(%esp)
  80147b:	e8 86 ff ff ff       	call   801406 <openfile_lookup>
  801480:	89 c2                	mov    %eax,%edx
  801482:	85 d2                	test   %edx,%edx
  801484:	78 15                	js     80149b <serve_set_size+0x3d>
		return r;

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  801486:	8b 43 04             	mov    0x4(%ebx),%eax
  801489:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801490:	8b 40 04             	mov    0x4(%eax),%eax
  801493:	89 04 24             	mov    %eax,(%esp)
  801496:	e8 83 f7 ff ff       	call   800c1e <file_set_size>
}
  80149b:	83 c4 24             	add    $0x24,%esp
  80149e:	5b                   	pop    %ebx
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	53                   	push   %ebx
  8014a5:	83 ec 24             	sub    $0x24,%esp
  8014a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	if (debug)
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// Lab 5: Your code here:
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8014ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014b2:	8b 03                	mov    (%ebx),%eax
  8014b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	89 04 24             	mov    %eax,(%esp)
  8014be:	e8 43 ff ff ff       	call   801406 <openfile_lookup>
  8014c3:	89 c2                	mov    %eax,%edx
  8014c5:	85 d2                	test   %edx,%edx
  8014c7:	78 3b                	js     801504 <serve_read+0x63>
		return r;
	count = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset);
  8014c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8014cf:	8b 52 04             	mov    0x4(%edx),%edx
  8014d2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014d6:	8b 53 04             	mov    0x4(%ebx),%edx
  8014d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014dd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014e1:	8b 40 04             	mov    0x4(%eax),%eax
  8014e4:	89 04 24             	mov    %eax,(%esp)
  8014e7:	e8 bd fc ff ff       	call   8011a9 <file_read>
  8014ec:	89 c3                	mov    %eax,%ebx
	o->o_fd->fd_offset += count; 
  8014ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8014f4:	01 5a 04             	add    %ebx,0x4(%edx)
	file_flush(o->o_file);
  8014f7:	8b 40 04             	mov    0x4(%eax),%eax
  8014fa:	89 04 24             	mov    %eax,(%esp)
  8014fd:	e8 ef f7 ff ff       	call   800cf1 <file_flush>
	return count;
  801502:	89 d8                	mov    %ebx,%eax
}
  801504:	83 c4 24             	add    $0x24,%esp
  801507:	5b                   	pop    %ebx
  801508:	5d                   	pop    %ebp
  801509:	c3                   	ret    

0080150a <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	53                   	push   %ebx
  80150e:	83 ec 24             	sub    $0x24,%esp
  801511:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	//panic("serve_write not implemented");
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801514:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801517:	89 44 24 08          	mov    %eax,0x8(%esp)
  80151b:	8b 03                	mov    (%ebx),%eax
  80151d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	89 04 24             	mov    %eax,(%esp)
  801527:	e8 da fe ff ff       	call   801406 <openfile_lookup>
  80152c:	89 c2                	mov    %eax,%edx
  80152e:	85 d2                	test   %edx,%edx
  801530:	78 3e                	js     801570 <serve_write+0x66>
		return r;
	//cprintf("\ncopying data\n");
	count = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset);
  801532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801535:	8b 50 0c             	mov    0xc(%eax),%edx
  801538:	8b 52 04             	mov    0x4(%edx),%edx
  80153b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80153f:	8b 53 04             	mov    0x4(%ebx),%edx
  801542:	89 54 24 08          	mov    %edx,0x8(%esp)
  801546:	83 c3 08             	add    $0x8,%ebx
  801549:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80154d:	8b 40 04             	mov    0x4(%eax),%eax
  801550:	89 04 24             	mov    %eax,(%esp)
  801553:	e8 01 fd ff ff       	call   801259 <file_write>
  801558:	89 c3                	mov    %eax,%ebx
	o->o_fd->fd_offset += count; 
  80155a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155d:	8b 50 0c             	mov    0xc(%eax),%edx
  801560:	01 5a 04             	add    %ebx,0x4(%edx)
	file_flush(o->o_file);
  801563:	8b 40 04             	mov    0x4(%eax),%eax
  801566:	89 04 24             	mov    %eax,(%esp)
  801569:	e8 83 f7 ff ff       	call   800cf1 <file_flush>
	return count;
  80156e:	89 d8                	mov    %ebx,%eax
}
  801570:	83 c4 24             	add    $0x24,%esp
  801573:	5b                   	pop    %ebx
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    

00801576 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	53                   	push   %ebx
  80157a:	83 ec 24             	sub    $0x24,%esp
  80157d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801580:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801583:	89 44 24 08          	mov    %eax,0x8(%esp)
  801587:	8b 03                	mov    (%ebx),%eax
  801589:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	89 04 24             	mov    %eax,(%esp)
  801593:	e8 6e fe ff ff       	call   801406 <openfile_lookup>
  801598:	89 c2                	mov    %eax,%edx
  80159a:	85 d2                	test   %edx,%edx
  80159c:	78 3f                	js     8015dd <serve_stat+0x67>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  80159e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a1:	8b 40 04             	mov    0x4(%eax),%eax
  8015a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a8:	89 1c 24             	mov    %ebx,(%esp)
  8015ab:	e8 87 0f 00 00       	call   802537 <strcpy>
	ret->ret_size = o->o_file->f_size;
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	8b 50 04             	mov    0x4(%eax),%edx
  8015b6:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  8015bc:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8015c2:	8b 40 04             	mov    0x4(%eax),%eax
  8015c5:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  8015cc:	0f 94 c0             	sete   %al
  8015cf:	0f b6 c0             	movzbl %al,%eax
  8015d2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015dd:	83 c4 24             	add    $0x24,%esp
  8015e0:	5b                   	pop    %ebx
  8015e1:	5d                   	pop    %ebp
  8015e2:	c3                   	ret    

008015e3 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 28             	sub    $0x28,%esp
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8015e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f3:	8b 00                	mov    (%eax),%eax
  8015f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	89 04 24             	mov    %eax,(%esp)
  8015ff:	e8 02 fe ff ff       	call   801406 <openfile_lookup>
  801604:	89 c2                	mov    %eax,%edx
  801606:	85 d2                	test   %edx,%edx
  801608:	78 13                	js     80161d <serve_flush+0x3a>
		return r;
	file_flush(o->o_file);
  80160a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160d:	8b 40 04             	mov    0x4(%eax),%eax
  801610:	89 04 24             	mov    %eax,(%esp)
  801613:	e8 d9 f6 ff ff       	call   800cf1 <file_flush>
	return 0;
  801618:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	53                   	push   %ebx
  801623:	81 ec 24 04 00 00    	sub    $0x424,%esp
  801629:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  80162c:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  801633:	00 
  801634:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801638:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80163e:	89 04 24             	mov    %eax,(%esp)
  801641:	e8 8e 10 00 00       	call   8026d4 <memmove>
	path[MAXPATHLEN-1] = 0;
  801646:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  80164a:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801650:	89 04 24             	mov    %eax,(%esp)
  801653:	e8 03 fd ff ff       	call   80135b <openfile_alloc>
  801658:	85 c0                	test   %eax,%eax
  80165a:	0f 88 f2 00 00 00    	js     801752 <serve_open+0x133>
		return r;
	}
	fileid = r;

	// Open the file
	if (req->req_omode & O_CREAT) {
  801660:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  801667:	74 34                	je     80169d <serve_open+0x7e>
		if ((r = file_create(path, &f)) < 0) {
  801669:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80166f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801673:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801679:	89 04 24             	mov    %eax,(%esp)
  80167c:	e8 c6 f9 ff ff       	call   801047 <file_create>
  801681:	89 c2                	mov    %eax,%edx
  801683:	85 c0                	test   %eax,%eax
  801685:	79 36                	jns    8016bd <serve_open+0x9e>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  801687:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  80168e:	0f 85 be 00 00 00    	jne    801752 <serve_open+0x133>
  801694:	83 fa f3             	cmp    $0xfffffff3,%edx
  801697:	0f 85 b5 00 00 00    	jne    801752 <serve_open+0x133>
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  80169d:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8016a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a7:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8016ad:	89 04 24             	mov    %eax,(%esp)
  8016b0:	e8 73 f9 ff ff       	call   801028 <file_open>
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	0f 88 95 00 00 00    	js     801752 <serve_open+0x133>
			return r;
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  8016bd:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  8016c4:	74 1a                	je     8016e0 <serve_open+0xc1>
		if ((r = file_set_size(f, 0)) < 0) {
  8016c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016cd:	00 
  8016ce:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  8016d4:	89 04 24             	mov    %eax,(%esp)
  8016d7:	e8 42 f5 ff ff       	call   800c1e <file_set_size>
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 72                	js     801752 <serve_open+0x133>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
		}
	}
	if ((r = file_open(path, &f)) < 0) {
  8016e0:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8016e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ea:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8016f0:	89 04 24             	mov    %eax,(%esp)
  8016f3:	e8 30 f9 ff ff       	call   801028 <file_open>
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	78 56                	js     801752 <serve_open+0x133>
			cprintf("file_open failed: %e", r);
		return r;
	}

	// Save the file pointer
	o->o_file = f;
  8016fc:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801702:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  801708:	89 50 04             	mov    %edx,0x4(%eax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  80170b:	8b 50 0c             	mov    0xc(%eax),%edx
  80170e:	8b 08                	mov    (%eax),%ecx
  801710:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801713:	8b 50 0c             	mov    0xc(%eax),%edx
  801716:	8b 8b 00 04 00 00    	mov    0x400(%ebx),%ecx
  80171c:	83 e1 03             	and    $0x3,%ecx
  80171f:	89 4a 08             	mov    %ecx,0x8(%edx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801722:	8b 40 0c             	mov    0xc(%eax),%eax
  801725:	8b 15 64 90 80 00    	mov    0x809064,%edx
  80172b:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  80172d:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801733:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801739:	89 50 08             	mov    %edx,0x8(%eax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  80173c:	8b 50 0c             	mov    0xc(%eax),%edx
  80173f:	8b 45 10             	mov    0x10(%ebp),%eax
  801742:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  801744:	8b 45 14             	mov    0x14(%ebp),%eax
  801747:	c7 00 07 04 00 00    	movl   $0x407,(%eax)

	return 0;
  80174d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801752:	81 c4 24 04 00 00    	add    $0x424,%esp
  801758:	5b                   	pop    %ebx
  801759:	5d                   	pop    %ebp
  80175a:	c3                   	ret    

0080175b <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	56                   	push   %esi
  80175f:	53                   	push   %ebx
  801760:	83 ec 20             	sub    $0x20,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801763:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  801766:	8d 75 f4             	lea    -0xc(%ebp),%esi
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  801769:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801770:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801774:	a1 48 50 80 00       	mov    0x805048,%eax
  801779:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177d:	89 34 24             	mov    %esi,(%esp)
  801780:	e8 eb 15 00 00       	call   802d70 <ipc_recv>
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  801785:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  801789:	75 15                	jne    8017a0 <serve+0x45>
			cprintf("Invalid request from %08x: no argument page\n",
  80178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801792:	c7 04 24 b4 47 80 00 	movl   $0x8047b4,(%esp)
  801799:	e8 24 07 00 00       	call   801ec2 <cprintf>
				whom);
			continue; // just leave it hanging...
  80179e:	eb c9                	jmp    801769 <serve+0xe>
		}

		pg = NULL;
  8017a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  8017a7:	83 f8 01             	cmp    $0x1,%eax
  8017aa:	75 21                	jne    8017cd <serve+0x72>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8017ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8017b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017b7:	a1 48 50 80 00       	mov    0x805048,%eax
  8017bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c3:	89 04 24             	mov    %eax,(%esp)
  8017c6:	e8 54 fe ff ff       	call   80161f <serve_open>
  8017cb:	eb 3f                	jmp    80180c <serve+0xb1>
		} else if (req < NHANDLERS && handlers[req]) {
  8017cd:	83 f8 09             	cmp    $0x9,%eax
  8017d0:	77 1e                	ja     8017f0 <serve+0x95>
  8017d2:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  8017d9:	85 d2                	test   %edx,%edx
  8017db:	74 13                	je     8017f0 <serve+0x95>
			r = handlers[req](whom, fsreq);
  8017dd:	a1 48 50 80 00       	mov    0x805048,%eax
  8017e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e9:	89 04 24             	mov    %eax,(%esp)
  8017ec:	ff d2                	call   *%edx
  8017ee:	eb 1c                	jmp    80180c <serve+0xb1>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8017f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8017f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fb:	c7 04 24 e4 47 80 00 	movl   $0x8047e4,(%esp)
  801802:	e8 bb 06 00 00       	call   801ec2 <cprintf>
			r = -E_INVAL;
  801807:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  80180c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80180f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801813:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801816:	89 54 24 08          	mov    %edx,0x8(%esp)
  80181a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801821:	89 04 24             	mov    %eax,(%esp)
  801824:	e8 af 15 00 00       	call   802dd8 <ipc_send>
		sys_page_unmap(0, fsreq);
  801829:	a1 48 50 80 00       	mov    0x805048,%eax
  80182e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801832:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801839:	e8 0e 12 00 00       	call   802a4c <sys_page_unmap>
  80183e:	e9 26 ff ff ff       	jmp    801769 <serve+0xe>

00801843 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801849:	c7 05 60 90 80 00 07 	movl   $0x804807,0x809060
  801850:	48 80 00 
	cprintf("FS is running\n");
  801853:	c7 04 24 0a 48 80 00 	movl   $0x80480a,(%esp)
  80185a:	e8 63 06 00 00       	call   801ec2 <cprintf>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80185f:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801864:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  801869:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  80186b:	c7 04 24 19 48 80 00 	movl   $0x804819,(%esp)
  801872:	e8 4b 06 00 00       	call   801ec2 <cprintf>

	serve_init();
  801877:	e8 b3 fa ff ff       	call   80132f <serve_init>
	fs_init();
  80187c:	e8 bf f0 ff ff       	call   800940 <fs_init>
    fs_test();
  801881:	e8 05 00 00 00       	call   80188b <fs_test>
	serve();
  801886:	e8 d0 fe ff ff       	call   80175b <serve>

0080188b <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	53                   	push   %ebx
  80188f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801892:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801899:	00 
  80189a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  8018a1:	00 
  8018a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a9:	e8 f7 10 00 00       	call   8029a5 <sys_page_alloc>
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	79 20                	jns    8018d2 <fs_test+0x47>
		panic("sys_page_alloc: %e", r);
  8018b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018b6:	c7 44 24 08 b8 45 80 	movl   $0x8045b8,0x8(%esp)
  8018bd:	00 
  8018be:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8018c5:	00 
  8018c6:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  8018cd:	e8 f7 04 00 00       	call   801dc9 <_panic>
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8018d2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8018d9:	00 
  8018da:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8018df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e3:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  8018ea:	e8 e5 0d 00 00       	call   8026d4 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8018ef:	e8 e9 f1 ff ff       	call   800add <alloc_block>
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	79 20                	jns    801918 <fs_test+0x8d>
		panic("alloc_block: %e", r);
  8018f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018fc:	c7 44 24 08 32 48 80 	movl   $0x804832,0x8(%esp)
  801903:	00 
  801904:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  80190b:	00 
  80190c:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801913:	e8 b1 04 00 00       	call   801dc9 <_panic>
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801918:	8d 58 1f             	lea    0x1f(%eax),%ebx
  80191b:	85 c0                	test   %eax,%eax
  80191d:	0f 49 d8             	cmovns %eax,%ebx
  801920:	c1 fb 05             	sar    $0x5,%ebx
  801923:	99                   	cltd   
  801924:	c1 ea 1b             	shr    $0x1b,%edx
  801927:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  80192a:	83 e1 1f             	and    $0x1f,%ecx
  80192d:	29 d1                	sub    %edx,%ecx
  80192f:	ba 01 00 00 00       	mov    $0x1,%edx
  801934:	d3 e2                	shl    %cl,%edx
  801936:	85 14 9d 00 10 00 00 	test   %edx,0x1000(,%ebx,4)
  80193d:	75 24                	jne    801963 <fs_test+0xd8>
  80193f:	c7 44 24 0c 42 48 80 	movl   $0x804842,0xc(%esp)
  801946:	00 
  801947:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  80194e:	00 
  80194f:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  801956:	00 
  801957:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  80195e:	e8 66 04 00 00       	call   801dc9 <_panic>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801963:	a1 08 a0 80 00       	mov    0x80a008,%eax
  801968:	85 14 98             	test   %edx,(%eax,%ebx,4)
  80196b:	74 24                	je     801991 <fs_test+0x106>
  80196d:	c7 44 24 0c bc 49 80 	movl   $0x8049bc,0xc(%esp)
  801974:	00 
  801975:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  80197c:	00 
  80197d:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  801984:	00 
  801985:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  80198c:	e8 38 04 00 00       	call   801dc9 <_panic>
	cprintf("alloc_block is good\n");
  801991:	c7 04 24 5d 48 80 00 	movl   $0x80485d,(%esp)
  801998:	e8 25 05 00 00       	call   801ec2 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  80199d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a4:	c7 04 24 72 48 80 00 	movl   $0x804872,(%esp)
  8019ab:	e8 78 f6 ff ff       	call   801028 <file_open>
  8019b0:	85 c0                	test   %eax,%eax
  8019b2:	79 25                	jns    8019d9 <fs_test+0x14e>
  8019b4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8019b7:	74 40                	je     8019f9 <fs_test+0x16e>
		panic("file_open /not-found: %e", r);
  8019b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019bd:	c7 44 24 08 7d 48 80 	movl   $0x80487d,0x8(%esp)
  8019c4:	00 
  8019c5:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8019cc:	00 
  8019cd:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  8019d4:	e8 f0 03 00 00       	call   801dc9 <_panic>
	else if (r == 0)
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	75 1c                	jne    8019f9 <fs_test+0x16e>
		panic("file_open /not-found succeeded!");
  8019dd:	c7 44 24 08 dc 49 80 	movl   $0x8049dc,0x8(%esp)
  8019e4:	00 
  8019e5:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8019ec:	00 
  8019ed:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  8019f4:	e8 d0 03 00 00       	call   801dc9 <_panic>
	if ((r = file_open("/newmotd", &f)) < 0)
  8019f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a00:	c7 04 24 96 48 80 00 	movl   $0x804896,(%esp)
  801a07:	e8 1c f6 ff ff       	call   801028 <file_open>
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	79 20                	jns    801a30 <fs_test+0x1a5>
		panic("file_open /newmotd: %e", r);
  801a10:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a14:	c7 44 24 08 9f 48 80 	movl   $0x80489f,0x8(%esp)
  801a1b:	00 
  801a1c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a23:	00 
  801a24:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801a2b:	e8 99 03 00 00       	call   801dc9 <_panic>
	cprintf("file_open is good\n");
  801a30:	c7 04 24 b6 48 80 00 	movl   $0x8048b6,(%esp)
  801a37:	e8 86 04 00 00       	call   801ec2 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  801a3c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a43:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a4a:	00 
  801a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4e:	89 04 24             	mov    %eax,(%esp)
  801a51:	e8 2b f3 ff ff       	call   800d81 <file_get_block>
  801a56:	85 c0                	test   %eax,%eax
  801a58:	79 20                	jns    801a7a <fs_test+0x1ef>
		panic("file_get_block: %e", r);
  801a5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a5e:	c7 44 24 08 c9 48 80 	movl   $0x8048c9,0x8(%esp)
  801a65:	00 
  801a66:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801a6d:	00 
  801a6e:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801a75:	e8 4f 03 00 00       	call   801dc9 <_panic>
	if (strcmp(blk, msg) != 0)
  801a7a:	c7 44 24 04 fc 49 80 	movl   $0x8049fc,0x4(%esp)
  801a81:	00 
  801a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a85:	89 04 24             	mov    %eax,(%esp)
  801a88:	e8 5f 0b 00 00       	call   8025ec <strcmp>
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	74 1c                	je     801aad <fs_test+0x222>
		panic("file_get_block returned wrong data");
  801a91:	c7 44 24 08 24 4a 80 	movl   $0x804a24,0x8(%esp)
  801a98:	00 
  801a99:	c7 44 24 04 29 00 00 	movl   $0x29,0x4(%esp)
  801aa0:	00 
  801aa1:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801aa8:	e8 1c 03 00 00       	call   801dc9 <_panic>
	cprintf("file_get_block is good\n");
  801aad:	c7 04 24 dc 48 80 00 	movl   $0x8048dc,(%esp)
  801ab4:	e8 09 04 00 00       	call   801ec2 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abc:	0f b6 10             	movzbl (%eax),%edx
  801abf:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac4:	c1 e8 0c             	shr    $0xc,%eax
  801ac7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ace:	a8 40                	test   $0x40,%al
  801ad0:	75 24                	jne    801af6 <fs_test+0x26b>
  801ad2:	c7 44 24 0c f5 48 80 	movl   $0x8048f5,0xc(%esp)
  801ad9:	00 
  801ada:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  801ae1:	00 
  801ae2:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801ae9:	00 
  801aea:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801af1:	e8 d3 02 00 00       	call   801dc9 <_panic>
	file_flush(f);
  801af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af9:	89 04 24             	mov    %eax,(%esp)
  801afc:	e8 f0 f1 ff ff       	call   800cf1 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b04:	c1 e8 0c             	shr    $0xc,%eax
  801b07:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b0e:	a8 40                	test   $0x40,%al
  801b10:	74 24                	je     801b36 <fs_test+0x2ab>
  801b12:	c7 44 24 0c f4 48 80 	movl   $0x8048f4,0xc(%esp)
  801b19:	00 
  801b1a:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  801b21:	00 
  801b22:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801b29:	00 
  801b2a:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801b31:	e8 93 02 00 00       	call   801dc9 <_panic>
	cprintf("file_flush is good\n");
  801b36:	c7 04 24 10 49 80 00 	movl   $0x804910,(%esp)
  801b3d:	e8 80 03 00 00       	call   801ec2 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801b42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b49:	00 
  801b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4d:	89 04 24             	mov    %eax,(%esp)
  801b50:	e8 c9 f0 ff ff       	call   800c1e <file_set_size>
  801b55:	85 c0                	test   %eax,%eax
  801b57:	79 20                	jns    801b79 <fs_test+0x2ee>
		panic("file_set_size: %e", r);
  801b59:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b5d:	c7 44 24 08 24 49 80 	movl   $0x804924,0x8(%esp)
  801b64:	00 
  801b65:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801b6c:	00 
  801b6d:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801b74:	e8 50 02 00 00       	call   801dc9 <_panic>
	assert(f->f_direct[0] == 0);
  801b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7c:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801b83:	74 24                	je     801ba9 <fs_test+0x31e>
  801b85:	c7 44 24 0c 36 49 80 	movl   $0x804936,0xc(%esp)
  801b8c:	00 
  801b8d:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  801b94:	00 
  801b95:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801b9c:	00 
  801b9d:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801ba4:	e8 20 02 00 00       	call   801dc9 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801ba9:	c1 e8 0c             	shr    $0xc,%eax
  801bac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bb3:	a8 40                	test   $0x40,%al
  801bb5:	74 24                	je     801bdb <fs_test+0x350>
  801bb7:	c7 44 24 0c 4a 49 80 	movl   $0x80494a,0xc(%esp)
  801bbe:	00 
  801bbf:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  801bc6:	00 
  801bc7:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801bce:	00 
  801bcf:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801bd6:	e8 ee 01 00 00       	call   801dc9 <_panic>
	cprintf("file_truncate is good\n");
  801bdb:	c7 04 24 64 49 80 00 	movl   $0x804964,(%esp)
  801be2:	e8 db 02 00 00       	call   801ec2 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801be7:	c7 04 24 fc 49 80 00 	movl   $0x8049fc,(%esp)
  801bee:	e8 0d 09 00 00       	call   802500 <strlen>
  801bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfa:	89 04 24             	mov    %eax,(%esp)
  801bfd:	e8 1c f0 ff ff       	call   800c1e <file_set_size>
  801c02:	85 c0                	test   %eax,%eax
  801c04:	79 20                	jns    801c26 <fs_test+0x39b>
		panic("file_set_size 2: %e", r);
  801c06:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c0a:	c7 44 24 08 7b 49 80 	movl   $0x80497b,0x8(%esp)
  801c11:	00 
  801c12:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801c19:	00 
  801c1a:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801c21:	e8 a3 01 00 00       	call   801dc9 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c29:	89 c2                	mov    %eax,%edx
  801c2b:	c1 ea 0c             	shr    $0xc,%edx
  801c2e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c35:	f6 c2 40             	test   $0x40,%dl
  801c38:	74 24                	je     801c5e <fs_test+0x3d3>
  801c3a:	c7 44 24 0c 4a 49 80 	movl   $0x80494a,0xc(%esp)
  801c41:	00 
  801c42:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  801c49:	00 
  801c4a:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801c51:	00 
  801c52:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801c59:	e8 6b 01 00 00       	call   801dc9 <_panic>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801c5e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801c61:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c65:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c6c:	00 
  801c6d:	89 04 24             	mov    %eax,(%esp)
  801c70:	e8 0c f1 ff ff       	call   800d81 <file_get_block>
  801c75:	85 c0                	test   %eax,%eax
  801c77:	79 20                	jns    801c99 <fs_test+0x40e>
		panic("file_get_block 2: %e", r);
  801c79:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c7d:	c7 44 24 08 8f 49 80 	movl   $0x80498f,0x8(%esp)
  801c84:	00 
  801c85:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  801c8c:	00 
  801c8d:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801c94:	e8 30 01 00 00       	call   801dc9 <_panic>
	strcpy(blk, msg);
  801c99:	c7 44 24 04 fc 49 80 	movl   $0x8049fc,0x4(%esp)
  801ca0:	00 
  801ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca4:	89 04 24             	mov    %eax,(%esp)
  801ca7:	e8 8b 08 00 00       	call   802537 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801caf:	c1 e8 0c             	shr    $0xc,%eax
  801cb2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801cb9:	a8 40                	test   $0x40,%al
  801cbb:	75 24                	jne    801ce1 <fs_test+0x456>
  801cbd:	c7 44 24 0c f5 48 80 	movl   $0x8048f5,0xc(%esp)
  801cc4:	00 
  801cc5:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  801ccc:	00 
  801ccd:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  801cd4:	00 
  801cd5:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801cdc:	e8 e8 00 00 00       	call   801dc9 <_panic>
	file_flush(f);
  801ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce4:	89 04 24             	mov    %eax,(%esp)
  801ce7:	e8 05 f0 ff ff       	call   800cf1 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cef:	c1 e8 0c             	shr    $0xc,%eax
  801cf2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801cf9:	a8 40                	test   $0x40,%al
  801cfb:	74 24                	je     801d21 <fs_test+0x496>
  801cfd:	c7 44 24 0c f4 48 80 	movl   $0x8048f4,0xc(%esp)
  801d04:	00 
  801d05:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  801d0c:	00 
  801d0d:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  801d14:	00 
  801d15:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801d1c:	e8 a8 00 00 00       	call   801dc9 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d24:	c1 e8 0c             	shr    $0xc,%eax
  801d27:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d2e:	a8 40                	test   $0x40,%al
  801d30:	74 24                	je     801d56 <fs_test+0x4cb>
  801d32:	c7 44 24 0c 4a 49 80 	movl   $0x80494a,0xc(%esp)
  801d39:	00 
  801d3a:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  801d41:	00 
  801d42:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
  801d49:	00 
  801d4a:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  801d51:	e8 73 00 00 00       	call   801dc9 <_panic>
	cprintf("file rewrite is good\n");
  801d56:	c7 04 24 a4 49 80 00 	movl   $0x8049a4,(%esp)
  801d5d:	e8 60 01 00 00       	call   801ec2 <cprintf>
}
  801d62:	83 c4 24             	add    $0x24,%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5d                   	pop    %ebp
  801d67:	c3                   	ret    

00801d68 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	56                   	push   %esi
  801d6c:	53                   	push   %ebx
  801d6d:	83 ec 10             	sub    $0x10,%esp
  801d70:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d73:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  801d76:	e8 ec 0b 00 00       	call   802967 <sys_getenvid>
  801d7b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d80:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801d83:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d88:	a3 10 a0 80 00       	mov    %eax,0x80a010

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801d8d:	85 db                	test   %ebx,%ebx
  801d8f:	7e 07                	jle    801d98 <libmain+0x30>
		binaryname = argv[0];
  801d91:	8b 06                	mov    (%esi),%eax
  801d93:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801d98:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d9c:	89 1c 24             	mov    %ebx,(%esp)
  801d9f:	e8 9f fa ff ff       	call   801843 <umain>

	// exit gracefully
	exit();
  801da4:	e8 07 00 00 00       	call   801db0 <exit>
}
  801da9:	83 c4 10             	add    $0x10,%esp
  801dac:	5b                   	pop    %ebx
  801dad:	5e                   	pop    %esi
  801dae:	5d                   	pop    %ebp
  801daf:	c3                   	ret    

00801db0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  801db6:	e8 9f 12 00 00       	call   80305a <close_all>
	sys_env_destroy(0);
  801dbb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dc2:	e8 fc 0a 00 00       	call   8028c3 <sys_env_destroy>
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	56                   	push   %esi
  801dcd:	53                   	push   %ebx
  801dce:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801dd1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801dd4:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801dda:	e8 88 0b 00 00       	call   802967 <sys_getenvid>
  801ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de2:	89 54 24 10          	mov    %edx,0x10(%esp)
  801de6:	8b 55 08             	mov    0x8(%ebp),%edx
  801de9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ded:	89 74 24 08          	mov    %esi,0x8(%esp)
  801df1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df5:	c7 04 24 54 4a 80 00 	movl   $0x804a54,(%esp)
  801dfc:	e8 c1 00 00 00       	call   801ec2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e01:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e05:	8b 45 10             	mov    0x10(%ebp),%eax
  801e08:	89 04 24             	mov    %eax,(%esp)
  801e0b:	e8 51 00 00 00       	call   801e61 <vcprintf>
	cprintf("\n");
  801e10:	c7 04 24 2b 46 80 00 	movl   $0x80462b,(%esp)
  801e17:	e8 a6 00 00 00       	call   801ec2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e1c:	cc                   	int3   
  801e1d:	eb fd                	jmp    801e1c <_panic+0x53>

00801e1f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	53                   	push   %ebx
  801e23:	83 ec 14             	sub    $0x14,%esp
  801e26:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801e29:	8b 13                	mov    (%ebx),%edx
  801e2b:	8d 42 01             	lea    0x1(%edx),%eax
  801e2e:	89 03                	mov    %eax,(%ebx)
  801e30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e33:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801e37:	3d ff 00 00 00       	cmp    $0xff,%eax
  801e3c:	75 19                	jne    801e57 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801e3e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801e45:	00 
  801e46:	8d 43 08             	lea    0x8(%ebx),%eax
  801e49:	89 04 24             	mov    %eax,(%esp)
  801e4c:	e8 35 0a 00 00       	call   802886 <sys_cputs>
		b->idx = 0;
  801e51:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801e57:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801e5b:	83 c4 14             	add    $0x14,%esp
  801e5e:	5b                   	pop    %ebx
  801e5f:	5d                   	pop    %ebp
  801e60:	c3                   	ret    

00801e61 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801e6a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801e71:	00 00 00 
	b.cnt = 0;
  801e74:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801e7b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e81:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e8c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801e92:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e96:	c7 04 24 1f 1e 80 00 	movl   $0x801e1f,(%esp)
  801e9d:	e8 72 01 00 00       	call   802014 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801ea2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eac:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801eb2:	89 04 24             	mov    %eax,(%esp)
  801eb5:	e8 cc 09 00 00       	call   802886 <sys_cputs>

	return b.cnt;
}
  801eba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ec8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801ecb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	89 04 24             	mov    %eax,(%esp)
  801ed5:	e8 87 ff ff ff       	call   801e61 <vcprintf>
	va_end(ap);

	return cnt;
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    
  801edc:	66 90                	xchg   %ax,%ax
  801ede:	66 90                	xchg   %ax,%ax

00801ee0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	57                   	push   %edi
  801ee4:	56                   	push   %esi
  801ee5:	53                   	push   %ebx
  801ee6:	83 ec 3c             	sub    $0x3c,%esp
  801ee9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eec:	89 d7                	mov    %edx,%edi
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef7:	89 c3                	mov    %eax,%ebx
  801ef9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801efc:	8b 45 10             	mov    0x10(%ebp),%eax
  801eff:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801f02:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f0a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801f0d:	39 d9                	cmp    %ebx,%ecx
  801f0f:	72 05                	jb     801f16 <printnum+0x36>
  801f11:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801f14:	77 69                	ja     801f7f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801f16:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801f19:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801f1d:	83 ee 01             	sub    $0x1,%esi
  801f20:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f24:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f28:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f2c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801f30:	89 c3                	mov    %eax,%ebx
  801f32:	89 d6                	mov    %edx,%esi
  801f34:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f37:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801f3a:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f3e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f45:	89 04 24             	mov    %eax,(%esp)
  801f48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f4f:	e8 bc 22 00 00       	call   804210 <__udivdi3>
  801f54:	89 d9                	mov    %ebx,%ecx
  801f56:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f5a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f5e:	89 04 24             	mov    %eax,(%esp)
  801f61:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f65:	89 fa                	mov    %edi,%edx
  801f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f6a:	e8 71 ff ff ff       	call   801ee0 <printnum>
  801f6f:	eb 1b                	jmp    801f8c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801f71:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f75:	8b 45 18             	mov    0x18(%ebp),%eax
  801f78:	89 04 24             	mov    %eax,(%esp)
  801f7b:	ff d3                	call   *%ebx
  801f7d:	eb 03                	jmp    801f82 <printnum+0xa2>
  801f7f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801f82:	83 ee 01             	sub    $0x1,%esi
  801f85:	85 f6                	test   %esi,%esi
  801f87:	7f e8                	jg     801f71 <printnum+0x91>
  801f89:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801f8c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f90:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f97:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801f9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f9e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fa5:	89 04 24             	mov    %eax,(%esp)
  801fa8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801faf:	e8 8c 23 00 00       	call   804340 <__umoddi3>
  801fb4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801fb8:	0f be 80 77 4a 80 00 	movsbl 0x804a77(%eax),%eax
  801fbf:	89 04 24             	mov    %eax,(%esp)
  801fc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc5:	ff d0                	call   *%eax
}
  801fc7:	83 c4 3c             	add    $0x3c,%esp
  801fca:	5b                   	pop    %ebx
  801fcb:	5e                   	pop    %esi
  801fcc:	5f                   	pop    %edi
  801fcd:	5d                   	pop    %ebp
  801fce:	c3                   	ret    

00801fcf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801fd5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801fd9:	8b 10                	mov    (%eax),%edx
  801fdb:	3b 50 04             	cmp    0x4(%eax),%edx
  801fde:	73 0a                	jae    801fea <sprintputch+0x1b>
		*b->buf++ = ch;
  801fe0:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fe3:	89 08                	mov    %ecx,(%eax)
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	88 02                	mov    %al,(%edx)
}
  801fea:	5d                   	pop    %ebp
  801feb:	c3                   	ret    

00801fec <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801ff2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801ff5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802000:	8b 45 0c             	mov    0xc(%ebp),%eax
  802003:	89 44 24 04          	mov    %eax,0x4(%esp)
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	89 04 24             	mov    %eax,(%esp)
  80200d:	e8 02 00 00 00       	call   802014 <vprintfmt>
	va_end(ap);
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	57                   	push   %edi
  802018:	56                   	push   %esi
  802019:	53                   	push   %ebx
  80201a:	83 ec 3c             	sub    $0x3c,%esp
  80201d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802020:	eb 17                	jmp    802039 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  802022:	85 c0                	test   %eax,%eax
  802024:	0f 84 4b 04 00 00    	je     802475 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80202a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80202d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802031:	89 04 24             	mov    %eax,(%esp)
  802034:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  802037:	89 fb                	mov    %edi,%ebx
  802039:	8d 7b 01             	lea    0x1(%ebx),%edi
  80203c:	0f b6 03             	movzbl (%ebx),%eax
  80203f:	83 f8 25             	cmp    $0x25,%eax
  802042:	75 de                	jne    802022 <vprintfmt+0xe>
  802044:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  802048:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80204f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  802054:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80205b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802060:	eb 18                	jmp    80207a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802062:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  802064:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  802068:	eb 10                	jmp    80207a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80206a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80206c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  802070:	eb 08                	jmp    80207a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  802072:	89 75 e0             	mov    %esi,-0x20(%ebp)
  802075:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80207a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80207d:	0f b6 17             	movzbl (%edi),%edx
  802080:	0f b6 c2             	movzbl %dl,%eax
  802083:	83 ea 23             	sub    $0x23,%edx
  802086:	80 fa 55             	cmp    $0x55,%dl
  802089:	0f 87 c2 03 00 00    	ja     802451 <vprintfmt+0x43d>
  80208f:	0f b6 d2             	movzbl %dl,%edx
  802092:	ff 24 95 c0 4b 80 00 	jmp    *0x804bc0(,%edx,4)
  802099:	89 df                	mov    %ebx,%edi
  80209b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8020a0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8020a3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8020a7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  8020aa:	8d 50 d0             	lea    -0x30(%eax),%edx
  8020ad:	83 fa 09             	cmp    $0x9,%edx
  8020b0:	77 33                	ja     8020e5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8020b2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8020b5:	eb e9                	jmp    8020a0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8020b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ba:	8b 30                	mov    (%eax),%esi
  8020bc:	8d 40 04             	lea    0x4(%eax),%eax
  8020bf:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8020c2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8020c4:	eb 1f                	jmp    8020e5 <vprintfmt+0xd1>
  8020c6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8020c9:	85 ff                	test   %edi,%edi
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d0:	0f 49 c7             	cmovns %edi,%eax
  8020d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8020d6:	89 df                	mov    %ebx,%edi
  8020d8:	eb a0                	jmp    80207a <vprintfmt+0x66>
  8020da:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8020dc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8020e3:	eb 95                	jmp    80207a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8020e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020e9:	79 8f                	jns    80207a <vprintfmt+0x66>
  8020eb:	eb 85                	jmp    802072 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8020ed:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8020f0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8020f2:	eb 86                	jmp    80207a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8020f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020f7:	8d 70 04             	lea    0x4(%eax),%esi
  8020fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802101:	8b 45 14             	mov    0x14(%ebp),%eax
  802104:	8b 00                	mov    (%eax),%eax
  802106:	89 04 24             	mov    %eax,(%esp)
  802109:	ff 55 08             	call   *0x8(%ebp)
  80210c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80210f:	e9 25 ff ff ff       	jmp    802039 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  802114:	8b 45 14             	mov    0x14(%ebp),%eax
  802117:	8d 70 04             	lea    0x4(%eax),%esi
  80211a:	8b 00                	mov    (%eax),%eax
  80211c:	99                   	cltd   
  80211d:	31 d0                	xor    %edx,%eax
  80211f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802121:	83 f8 15             	cmp    $0x15,%eax
  802124:	7f 0b                	jg     802131 <vprintfmt+0x11d>
  802126:	8b 14 85 20 4d 80 00 	mov    0x804d20(,%eax,4),%edx
  80212d:	85 d2                	test   %edx,%edx
  80212f:	75 26                	jne    802157 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  802131:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802135:	c7 44 24 08 8f 4a 80 	movl   $0x804a8f,0x8(%esp)
  80213c:	00 
  80213d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802140:	89 44 24 04          	mov    %eax,0x4(%esp)
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	89 04 24             	mov    %eax,(%esp)
  80214a:	e8 9d fe ff ff       	call   801fec <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80214f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  802152:	e9 e2 fe ff ff       	jmp    802039 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  802157:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80215b:	c7 44 24 08 ef 44 80 	movl   $0x8044ef,0x8(%esp)
  802162:	00 
  802163:	8b 45 0c             	mov    0xc(%ebp),%eax
  802166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	89 04 24             	mov    %eax,(%esp)
  802170:	e8 77 fe ff ff       	call   801fec <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  802175:	89 75 14             	mov    %esi,0x14(%ebp)
  802178:	e9 bc fe ff ff       	jmp    802039 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80217d:	8b 45 14             	mov    0x14(%ebp),%eax
  802180:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  802183:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  802186:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80218a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80218c:	85 ff                	test   %edi,%edi
  80218e:	b8 88 4a 80 00       	mov    $0x804a88,%eax
  802193:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  802196:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80219a:	0f 84 94 00 00 00    	je     802234 <vprintfmt+0x220>
  8021a0:	85 c9                	test   %ecx,%ecx
  8021a2:	0f 8e 94 00 00 00    	jle    80223c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  8021a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021ac:	89 3c 24             	mov    %edi,(%esp)
  8021af:	e8 64 03 00 00       	call   802518 <strnlen>
  8021b4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8021b7:	29 c1                	sub    %eax,%ecx
  8021b9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  8021bc:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  8021c0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8021c3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8021c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8021c9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8021cc:	89 cb                	mov    %ecx,%ebx
  8021ce:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8021d0:	eb 0f                	jmp    8021e1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  8021d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d9:	89 3c 24             	mov    %edi,(%esp)
  8021dc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8021de:	83 eb 01             	sub    $0x1,%ebx
  8021e1:	85 db                	test   %ebx,%ebx
  8021e3:	7f ed                	jg     8021d2 <vprintfmt+0x1be>
  8021e5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8021e8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8021eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8021ee:	85 c9                	test   %ecx,%ecx
  8021f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f5:	0f 49 c1             	cmovns %ecx,%eax
  8021f8:	29 c1                	sub    %eax,%ecx
  8021fa:	89 cb                	mov    %ecx,%ebx
  8021fc:	eb 44                	jmp    802242 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8021fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802202:	74 1e                	je     802222 <vprintfmt+0x20e>
  802204:	0f be d2             	movsbl %dl,%edx
  802207:	83 ea 20             	sub    $0x20,%edx
  80220a:	83 fa 5e             	cmp    $0x5e,%edx
  80220d:	76 13                	jbe    802222 <vprintfmt+0x20e>
					putch('?', putdat);
  80220f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802212:	89 44 24 04          	mov    %eax,0x4(%esp)
  802216:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80221d:	ff 55 08             	call   *0x8(%ebp)
  802220:	eb 0d                	jmp    80222f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  802222:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802225:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802229:	89 04 24             	mov    %eax,(%esp)
  80222c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80222f:	83 eb 01             	sub    $0x1,%ebx
  802232:	eb 0e                	jmp    802242 <vprintfmt+0x22e>
  802234:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802237:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80223a:	eb 06                	jmp    802242 <vprintfmt+0x22e>
  80223c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80223f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  802242:	83 c7 01             	add    $0x1,%edi
  802245:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  802249:	0f be c2             	movsbl %dl,%eax
  80224c:	85 c0                	test   %eax,%eax
  80224e:	74 27                	je     802277 <vprintfmt+0x263>
  802250:	85 f6                	test   %esi,%esi
  802252:	78 aa                	js     8021fe <vprintfmt+0x1ea>
  802254:	83 ee 01             	sub    $0x1,%esi
  802257:	79 a5                	jns    8021fe <vprintfmt+0x1ea>
  802259:	89 d8                	mov    %ebx,%eax
  80225b:	8b 75 08             	mov    0x8(%ebp),%esi
  80225e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802261:	89 c3                	mov    %eax,%ebx
  802263:	eb 18                	jmp    80227d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  802265:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802269:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  802270:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802272:	83 eb 01             	sub    $0x1,%ebx
  802275:	eb 06                	jmp    80227d <vprintfmt+0x269>
  802277:	8b 75 08             	mov    0x8(%ebp),%esi
  80227a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80227d:	85 db                	test   %ebx,%ebx
  80227f:	7f e4                	jg     802265 <vprintfmt+0x251>
  802281:	89 75 08             	mov    %esi,0x8(%ebp)
  802284:	89 7d 0c             	mov    %edi,0xc(%ebp)
  802287:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80228a:	e9 aa fd ff ff       	jmp    802039 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80228f:	83 f9 01             	cmp    $0x1,%ecx
  802292:	7e 10                	jle    8022a4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  802294:	8b 45 14             	mov    0x14(%ebp),%eax
  802297:	8b 30                	mov    (%eax),%esi
  802299:	8b 78 04             	mov    0x4(%eax),%edi
  80229c:	8d 40 08             	lea    0x8(%eax),%eax
  80229f:	89 45 14             	mov    %eax,0x14(%ebp)
  8022a2:	eb 26                	jmp    8022ca <vprintfmt+0x2b6>
	else if (lflag)
  8022a4:	85 c9                	test   %ecx,%ecx
  8022a6:	74 12                	je     8022ba <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  8022a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ab:	8b 30                	mov    (%eax),%esi
  8022ad:	89 f7                	mov    %esi,%edi
  8022af:	c1 ff 1f             	sar    $0x1f,%edi
  8022b2:	8d 40 04             	lea    0x4(%eax),%eax
  8022b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8022b8:	eb 10                	jmp    8022ca <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  8022ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8022bd:	8b 30                	mov    (%eax),%esi
  8022bf:	89 f7                	mov    %esi,%edi
  8022c1:	c1 ff 1f             	sar    $0x1f,%edi
  8022c4:	8d 40 04             	lea    0x4(%eax),%eax
  8022c7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8022ca:	89 f0                	mov    %esi,%eax
  8022cc:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8022ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8022d3:	85 ff                	test   %edi,%edi
  8022d5:	0f 89 3a 01 00 00    	jns    802415 <vprintfmt+0x401>
				putch('-', putdat);
  8022db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8022e9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8022ec:	89 f0                	mov    %esi,%eax
  8022ee:	89 fa                	mov    %edi,%edx
  8022f0:	f7 d8                	neg    %eax
  8022f2:	83 d2 00             	adc    $0x0,%edx
  8022f5:	f7 da                	neg    %edx
			}
			base = 10;
  8022f7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8022fc:	e9 14 01 00 00       	jmp    802415 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  802301:	83 f9 01             	cmp    $0x1,%ecx
  802304:	7e 13                	jle    802319 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  802306:	8b 45 14             	mov    0x14(%ebp),%eax
  802309:	8b 50 04             	mov    0x4(%eax),%edx
  80230c:	8b 00                	mov    (%eax),%eax
  80230e:	8b 75 14             	mov    0x14(%ebp),%esi
  802311:	8d 4e 08             	lea    0x8(%esi),%ecx
  802314:	89 4d 14             	mov    %ecx,0x14(%ebp)
  802317:	eb 2c                	jmp    802345 <vprintfmt+0x331>
	else if (lflag)
  802319:	85 c9                	test   %ecx,%ecx
  80231b:	74 15                	je     802332 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80231d:	8b 45 14             	mov    0x14(%ebp),%eax
  802320:	8b 00                	mov    (%eax),%eax
  802322:	ba 00 00 00 00       	mov    $0x0,%edx
  802327:	8b 75 14             	mov    0x14(%ebp),%esi
  80232a:	8d 76 04             	lea    0x4(%esi),%esi
  80232d:	89 75 14             	mov    %esi,0x14(%ebp)
  802330:	eb 13                	jmp    802345 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  802332:	8b 45 14             	mov    0x14(%ebp),%eax
  802335:	8b 00                	mov    (%eax),%eax
  802337:	ba 00 00 00 00       	mov    $0x0,%edx
  80233c:	8b 75 14             	mov    0x14(%ebp),%esi
  80233f:	8d 76 04             	lea    0x4(%esi),%esi
  802342:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  802345:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80234a:	e9 c6 00 00 00       	jmp    802415 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80234f:	83 f9 01             	cmp    $0x1,%ecx
  802352:	7e 13                	jle    802367 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  802354:	8b 45 14             	mov    0x14(%ebp),%eax
  802357:	8b 50 04             	mov    0x4(%eax),%edx
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	8b 75 14             	mov    0x14(%ebp),%esi
  80235f:	8d 4e 08             	lea    0x8(%esi),%ecx
  802362:	89 4d 14             	mov    %ecx,0x14(%ebp)
  802365:	eb 24                	jmp    80238b <vprintfmt+0x377>
	else if (lflag)
  802367:	85 c9                	test   %ecx,%ecx
  802369:	74 11                	je     80237c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80236b:	8b 45 14             	mov    0x14(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	99                   	cltd   
  802371:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802374:	8d 71 04             	lea    0x4(%ecx),%esi
  802377:	89 75 14             	mov    %esi,0x14(%ebp)
  80237a:	eb 0f                	jmp    80238b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80237c:	8b 45 14             	mov    0x14(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	99                   	cltd   
  802382:	8b 75 14             	mov    0x14(%ebp),%esi
  802385:	8d 76 04             	lea    0x4(%esi),%esi
  802388:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80238b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  802390:	e9 80 00 00 00       	jmp    802415 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802395:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  802398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8023a6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8023a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8023b7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8023ba:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8023be:	8b 06                	mov    (%esi),%eax
  8023c0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8023c5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8023ca:	eb 49                	jmp    802415 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8023cc:	83 f9 01             	cmp    $0x1,%ecx
  8023cf:	7e 13                	jle    8023e4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  8023d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8023d4:	8b 50 04             	mov    0x4(%eax),%edx
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	8b 75 14             	mov    0x14(%ebp),%esi
  8023dc:	8d 4e 08             	lea    0x8(%esi),%ecx
  8023df:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8023e2:	eb 2c                	jmp    802410 <vprintfmt+0x3fc>
	else if (lflag)
  8023e4:	85 c9                	test   %ecx,%ecx
  8023e6:	74 15                	je     8023fd <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  8023e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8023eb:	8b 00                	mov    (%eax),%eax
  8023ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023f5:	8d 71 04             	lea    0x4(%ecx),%esi
  8023f8:	89 75 14             	mov    %esi,0x14(%ebp)
  8023fb:	eb 13                	jmp    802410 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8023fd:	8b 45 14             	mov    0x14(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	ba 00 00 00 00       	mov    $0x0,%edx
  802407:	8b 75 14             	mov    0x14(%ebp),%esi
  80240a:	8d 76 04             	lea    0x4(%esi),%esi
  80240d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  802410:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  802415:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  802419:	89 74 24 10          	mov    %esi,0x10(%esp)
  80241d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  802420:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802424:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802428:	89 04 24             	mov    %eax,(%esp)
  80242b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80242f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	e8 a6 fa ff ff       	call   801ee0 <printnum>
			break;
  80243a:	e9 fa fb ff ff       	jmp    802039 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80243f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802442:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802446:	89 04 24             	mov    %eax,(%esp)
  802449:	ff 55 08             	call   *0x8(%ebp)
			break;
  80244c:	e9 e8 fb ff ff       	jmp    802039 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802451:	8b 45 0c             	mov    0xc(%ebp),%eax
  802454:	89 44 24 04          	mov    %eax,0x4(%esp)
  802458:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80245f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  802462:	89 fb                	mov    %edi,%ebx
  802464:	eb 03                	jmp    802469 <vprintfmt+0x455>
  802466:	83 eb 01             	sub    $0x1,%ebx
  802469:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80246d:	75 f7                	jne    802466 <vprintfmt+0x452>
  80246f:	90                   	nop
  802470:	e9 c4 fb ff ff       	jmp    802039 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  802475:	83 c4 3c             	add    $0x3c,%esp
  802478:	5b                   	pop    %ebx
  802479:	5e                   	pop    %esi
  80247a:	5f                   	pop    %edi
  80247b:	5d                   	pop    %ebp
  80247c:	c3                   	ret    

0080247d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
  802480:	83 ec 28             	sub    $0x28,%esp
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802489:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80248c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802490:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802493:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80249a:	85 c0                	test   %eax,%eax
  80249c:	74 30                	je     8024ce <vsnprintf+0x51>
  80249e:	85 d2                	test   %edx,%edx
  8024a0:	7e 2c                	jle    8024ce <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8024a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8024a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8024b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b7:	c7 04 24 cf 1f 80 00 	movl   $0x801fcf,(%esp)
  8024be:	e8 51 fb ff ff       	call   802014 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8024c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	eb 05                	jmp    8024d3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8024ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8024db:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8024de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f3:	89 04 24             	mov    %eax,(%esp)
  8024f6:	e8 82 ff ff ff       	call   80247d <vsnprintf>
	va_end(ap);

	return rc;
}
  8024fb:	c9                   	leave  
  8024fc:	c3                   	ret    
  8024fd:	66 90                	xchg   %ax,%ax
  8024ff:	90                   	nop

00802500 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802506:	b8 00 00 00 00       	mov    $0x0,%eax
  80250b:	eb 03                	jmp    802510 <strlen+0x10>
		n++;
  80250d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802510:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802514:	75 f7                	jne    80250d <strlen+0xd>
		n++;
	return n;
}
  802516:	5d                   	pop    %ebp
  802517:	c3                   	ret    

00802518 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80251e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802521:	b8 00 00 00 00       	mov    $0x0,%eax
  802526:	eb 03                	jmp    80252b <strnlen+0x13>
		n++;
  802528:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80252b:	39 d0                	cmp    %edx,%eax
  80252d:	74 06                	je     802535 <strnlen+0x1d>
  80252f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  802533:	75 f3                	jne    802528 <strnlen+0x10>
		n++;
	return n;
}
  802535:	5d                   	pop    %ebp
  802536:	c3                   	ret    

00802537 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
  80253a:	53                   	push   %ebx
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802541:	89 c2                	mov    %eax,%edx
  802543:	83 c2 01             	add    $0x1,%edx
  802546:	83 c1 01             	add    $0x1,%ecx
  802549:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80254d:	88 5a ff             	mov    %bl,-0x1(%edx)
  802550:	84 db                	test   %bl,%bl
  802552:	75 ef                	jne    802543 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  802554:	5b                   	pop    %ebx
  802555:	5d                   	pop    %ebp
  802556:	c3                   	ret    

00802557 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
  80255a:	53                   	push   %ebx
  80255b:	83 ec 08             	sub    $0x8,%esp
  80255e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802561:	89 1c 24             	mov    %ebx,(%esp)
  802564:	e8 97 ff ff ff       	call   802500 <strlen>
	strcpy(dst + len, src);
  802569:	8b 55 0c             	mov    0xc(%ebp),%edx
  80256c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802570:	01 d8                	add    %ebx,%eax
  802572:	89 04 24             	mov    %eax,(%esp)
  802575:	e8 bd ff ff ff       	call   802537 <strcpy>
	return dst;
}
  80257a:	89 d8                	mov    %ebx,%eax
  80257c:	83 c4 08             	add    $0x8,%esp
  80257f:	5b                   	pop    %ebx
  802580:	5d                   	pop    %ebp
  802581:	c3                   	ret    

00802582 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802582:	55                   	push   %ebp
  802583:	89 e5                	mov    %esp,%ebp
  802585:	56                   	push   %esi
  802586:	53                   	push   %ebx
  802587:	8b 75 08             	mov    0x8(%ebp),%esi
  80258a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80258d:	89 f3                	mov    %esi,%ebx
  80258f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802592:	89 f2                	mov    %esi,%edx
  802594:	eb 0f                	jmp    8025a5 <strncpy+0x23>
		*dst++ = *src;
  802596:	83 c2 01             	add    $0x1,%edx
  802599:	0f b6 01             	movzbl (%ecx),%eax
  80259c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80259f:	80 39 01             	cmpb   $0x1,(%ecx)
  8025a2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8025a5:	39 da                	cmp    %ebx,%edx
  8025a7:	75 ed                	jne    802596 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8025a9:	89 f0                	mov    %esi,%eax
  8025ab:	5b                   	pop    %ebx
  8025ac:	5e                   	pop    %esi
  8025ad:	5d                   	pop    %ebp
  8025ae:	c3                   	ret    

008025af <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	56                   	push   %esi
  8025b3:	53                   	push   %ebx
  8025b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8025b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025bd:	89 f0                	mov    %esi,%eax
  8025bf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8025c3:	85 c9                	test   %ecx,%ecx
  8025c5:	75 0b                	jne    8025d2 <strlcpy+0x23>
  8025c7:	eb 1d                	jmp    8025e6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8025c9:	83 c0 01             	add    $0x1,%eax
  8025cc:	83 c2 01             	add    $0x1,%edx
  8025cf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8025d2:	39 d8                	cmp    %ebx,%eax
  8025d4:	74 0b                	je     8025e1 <strlcpy+0x32>
  8025d6:	0f b6 0a             	movzbl (%edx),%ecx
  8025d9:	84 c9                	test   %cl,%cl
  8025db:	75 ec                	jne    8025c9 <strlcpy+0x1a>
  8025dd:	89 c2                	mov    %eax,%edx
  8025df:	eb 02                	jmp    8025e3 <strlcpy+0x34>
  8025e1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8025e3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8025e6:	29 f0                	sub    %esi,%eax
}
  8025e8:	5b                   	pop    %ebx
  8025e9:	5e                   	pop    %esi
  8025ea:	5d                   	pop    %ebp
  8025eb:	c3                   	ret    

008025ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8025f5:	eb 06                	jmp    8025fd <strcmp+0x11>
		p++, q++;
  8025f7:	83 c1 01             	add    $0x1,%ecx
  8025fa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8025fd:	0f b6 01             	movzbl (%ecx),%eax
  802600:	84 c0                	test   %al,%al
  802602:	74 04                	je     802608 <strcmp+0x1c>
  802604:	3a 02                	cmp    (%edx),%al
  802606:	74 ef                	je     8025f7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802608:	0f b6 c0             	movzbl %al,%eax
  80260b:	0f b6 12             	movzbl (%edx),%edx
  80260e:	29 d0                	sub    %edx,%eax
}
  802610:	5d                   	pop    %ebp
  802611:	c3                   	ret    

00802612 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
  802615:	53                   	push   %ebx
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261c:	89 c3                	mov    %eax,%ebx
  80261e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802621:	eb 06                	jmp    802629 <strncmp+0x17>
		n--, p++, q++;
  802623:	83 c0 01             	add    $0x1,%eax
  802626:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802629:	39 d8                	cmp    %ebx,%eax
  80262b:	74 15                	je     802642 <strncmp+0x30>
  80262d:	0f b6 08             	movzbl (%eax),%ecx
  802630:	84 c9                	test   %cl,%cl
  802632:	74 04                	je     802638 <strncmp+0x26>
  802634:	3a 0a                	cmp    (%edx),%cl
  802636:	74 eb                	je     802623 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802638:	0f b6 00             	movzbl (%eax),%eax
  80263b:	0f b6 12             	movzbl (%edx),%edx
  80263e:	29 d0                	sub    %edx,%eax
  802640:	eb 05                	jmp    802647 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  802642:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802647:	5b                   	pop    %ebx
  802648:	5d                   	pop    %ebp
  802649:	c3                   	ret    

0080264a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	8b 45 08             	mov    0x8(%ebp),%eax
  802650:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802654:	eb 07                	jmp    80265d <strchr+0x13>
		if (*s == c)
  802656:	38 ca                	cmp    %cl,%dl
  802658:	74 0f                	je     802669 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80265a:	83 c0 01             	add    $0x1,%eax
  80265d:	0f b6 10             	movzbl (%eax),%edx
  802660:	84 d2                	test   %dl,%dl
  802662:	75 f2                	jne    802656 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  802664:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802669:	5d                   	pop    %ebp
  80266a:	c3                   	ret    

0080266b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802675:	eb 07                	jmp    80267e <strfind+0x13>
		if (*s == c)
  802677:	38 ca                	cmp    %cl,%dl
  802679:	74 0a                	je     802685 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80267b:	83 c0 01             	add    $0x1,%eax
  80267e:	0f b6 10             	movzbl (%eax),%edx
  802681:	84 d2                	test   %dl,%dl
  802683:	75 f2                	jne    802677 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  802685:	5d                   	pop    %ebp
  802686:	c3                   	ret    

00802687 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	57                   	push   %edi
  80268b:	56                   	push   %esi
  80268c:	53                   	push   %ebx
  80268d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802690:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802693:	85 c9                	test   %ecx,%ecx
  802695:	74 36                	je     8026cd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802697:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80269d:	75 28                	jne    8026c7 <memset+0x40>
  80269f:	f6 c1 03             	test   $0x3,%cl
  8026a2:	75 23                	jne    8026c7 <memset+0x40>
		c &= 0xFF;
  8026a4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8026a8:	89 d3                	mov    %edx,%ebx
  8026aa:	c1 e3 08             	shl    $0x8,%ebx
  8026ad:	89 d6                	mov    %edx,%esi
  8026af:	c1 e6 18             	shl    $0x18,%esi
  8026b2:	89 d0                	mov    %edx,%eax
  8026b4:	c1 e0 10             	shl    $0x10,%eax
  8026b7:	09 f0                	or     %esi,%eax
  8026b9:	09 c2                	or     %eax,%edx
  8026bb:	89 d0                	mov    %edx,%eax
  8026bd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8026bf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8026c2:	fc                   	cld    
  8026c3:	f3 ab                	rep stos %eax,%es:(%edi)
  8026c5:	eb 06                	jmp    8026cd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8026c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ca:	fc                   	cld    
  8026cb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8026cd:	89 f8                	mov    %edi,%eax
  8026cf:	5b                   	pop    %ebx
  8026d0:	5e                   	pop    %esi
  8026d1:	5f                   	pop    %edi
  8026d2:	5d                   	pop    %ebp
  8026d3:	c3                   	ret    

008026d4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	57                   	push   %edi
  8026d8:	56                   	push   %esi
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026df:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8026e2:	39 c6                	cmp    %eax,%esi
  8026e4:	73 35                	jae    80271b <memmove+0x47>
  8026e6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8026e9:	39 d0                	cmp    %edx,%eax
  8026eb:	73 2e                	jae    80271b <memmove+0x47>
		s += n;
		d += n;
  8026ed:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8026f0:	89 d6                	mov    %edx,%esi
  8026f2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8026f4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8026fa:	75 13                	jne    80270f <memmove+0x3b>
  8026fc:	f6 c1 03             	test   $0x3,%cl
  8026ff:	75 0e                	jne    80270f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802701:	83 ef 04             	sub    $0x4,%edi
  802704:	8d 72 fc             	lea    -0x4(%edx),%esi
  802707:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80270a:	fd                   	std    
  80270b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80270d:	eb 09                	jmp    802718 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80270f:	83 ef 01             	sub    $0x1,%edi
  802712:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802715:	fd                   	std    
  802716:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802718:	fc                   	cld    
  802719:	eb 1d                	jmp    802738 <memmove+0x64>
  80271b:	89 f2                	mov    %esi,%edx
  80271d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80271f:	f6 c2 03             	test   $0x3,%dl
  802722:	75 0f                	jne    802733 <memmove+0x5f>
  802724:	f6 c1 03             	test   $0x3,%cl
  802727:	75 0a                	jne    802733 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802729:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80272c:	89 c7                	mov    %eax,%edi
  80272e:	fc                   	cld    
  80272f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802731:	eb 05                	jmp    802738 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802733:	89 c7                	mov    %eax,%edi
  802735:	fc                   	cld    
  802736:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802738:	5e                   	pop    %esi
  802739:	5f                   	pop    %edi
  80273a:	5d                   	pop    %ebp
  80273b:	c3                   	ret    

0080273c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
  80273f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802742:	8b 45 10             	mov    0x10(%ebp),%eax
  802745:	89 44 24 08          	mov    %eax,0x8(%esp)
  802749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	89 04 24             	mov    %eax,(%esp)
  802756:	e8 79 ff ff ff       	call   8026d4 <memmove>
}
  80275b:	c9                   	leave  
  80275c:	c3                   	ret    

0080275d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
  802760:	56                   	push   %esi
  802761:	53                   	push   %ebx
  802762:	8b 55 08             	mov    0x8(%ebp),%edx
  802765:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802768:	89 d6                	mov    %edx,%esi
  80276a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80276d:	eb 1a                	jmp    802789 <memcmp+0x2c>
		if (*s1 != *s2)
  80276f:	0f b6 02             	movzbl (%edx),%eax
  802772:	0f b6 19             	movzbl (%ecx),%ebx
  802775:	38 d8                	cmp    %bl,%al
  802777:	74 0a                	je     802783 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  802779:	0f b6 c0             	movzbl %al,%eax
  80277c:	0f b6 db             	movzbl %bl,%ebx
  80277f:	29 d8                	sub    %ebx,%eax
  802781:	eb 0f                	jmp    802792 <memcmp+0x35>
		s1++, s2++;
  802783:	83 c2 01             	add    $0x1,%edx
  802786:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802789:	39 f2                	cmp    %esi,%edx
  80278b:	75 e2                	jne    80276f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80278d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802792:	5b                   	pop    %ebx
  802793:	5e                   	pop    %esi
  802794:	5d                   	pop    %ebp
  802795:	c3                   	ret    

00802796 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80279f:	89 c2                	mov    %eax,%edx
  8027a1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8027a4:	eb 07                	jmp    8027ad <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8027a6:	38 08                	cmp    %cl,(%eax)
  8027a8:	74 07                	je     8027b1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8027aa:	83 c0 01             	add    $0x1,%eax
  8027ad:	39 d0                	cmp    %edx,%eax
  8027af:	72 f5                	jb     8027a6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8027b1:	5d                   	pop    %ebp
  8027b2:	c3                   	ret    

008027b3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
  8027b6:	57                   	push   %edi
  8027b7:	56                   	push   %esi
  8027b8:	53                   	push   %ebx
  8027b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027bc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027bf:	eb 03                	jmp    8027c4 <strtol+0x11>
		s++;
  8027c1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027c4:	0f b6 0a             	movzbl (%edx),%ecx
  8027c7:	80 f9 09             	cmp    $0x9,%cl
  8027ca:	74 f5                	je     8027c1 <strtol+0xe>
  8027cc:	80 f9 20             	cmp    $0x20,%cl
  8027cf:	74 f0                	je     8027c1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8027d1:	80 f9 2b             	cmp    $0x2b,%cl
  8027d4:	75 0a                	jne    8027e0 <strtol+0x2d>
		s++;
  8027d6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8027d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8027de:	eb 11                	jmp    8027f1 <strtol+0x3e>
  8027e0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8027e5:	80 f9 2d             	cmp    $0x2d,%cl
  8027e8:	75 07                	jne    8027f1 <strtol+0x3e>
		s++, neg = 1;
  8027ea:	8d 52 01             	lea    0x1(%edx),%edx
  8027ed:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8027f1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8027f6:	75 15                	jne    80280d <strtol+0x5a>
  8027f8:	80 3a 30             	cmpb   $0x30,(%edx)
  8027fb:	75 10                	jne    80280d <strtol+0x5a>
  8027fd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802801:	75 0a                	jne    80280d <strtol+0x5a>
		s += 2, base = 16;
  802803:	83 c2 02             	add    $0x2,%edx
  802806:	b8 10 00 00 00       	mov    $0x10,%eax
  80280b:	eb 10                	jmp    80281d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80280d:	85 c0                	test   %eax,%eax
  80280f:	75 0c                	jne    80281d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802811:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802813:	80 3a 30             	cmpb   $0x30,(%edx)
  802816:	75 05                	jne    80281d <strtol+0x6a>
		s++, base = 8;
  802818:	83 c2 01             	add    $0x1,%edx
  80281b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80281d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802822:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802825:	0f b6 0a             	movzbl (%edx),%ecx
  802828:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80282b:	89 f0                	mov    %esi,%eax
  80282d:	3c 09                	cmp    $0x9,%al
  80282f:	77 08                	ja     802839 <strtol+0x86>
			dig = *s - '0';
  802831:	0f be c9             	movsbl %cl,%ecx
  802834:	83 e9 30             	sub    $0x30,%ecx
  802837:	eb 20                	jmp    802859 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  802839:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80283c:	89 f0                	mov    %esi,%eax
  80283e:	3c 19                	cmp    $0x19,%al
  802840:	77 08                	ja     80284a <strtol+0x97>
			dig = *s - 'a' + 10;
  802842:	0f be c9             	movsbl %cl,%ecx
  802845:	83 e9 57             	sub    $0x57,%ecx
  802848:	eb 0f                	jmp    802859 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80284a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80284d:	89 f0                	mov    %esi,%eax
  80284f:	3c 19                	cmp    $0x19,%al
  802851:	77 16                	ja     802869 <strtol+0xb6>
			dig = *s - 'A' + 10;
  802853:	0f be c9             	movsbl %cl,%ecx
  802856:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  802859:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80285c:	7d 0f                	jge    80286d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80285e:	83 c2 01             	add    $0x1,%edx
  802861:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  802865:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  802867:	eb bc                	jmp    802825 <strtol+0x72>
  802869:	89 d8                	mov    %ebx,%eax
  80286b:	eb 02                	jmp    80286f <strtol+0xbc>
  80286d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80286f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802873:	74 05                	je     80287a <strtol+0xc7>
		*endptr = (char *) s;
  802875:	8b 75 0c             	mov    0xc(%ebp),%esi
  802878:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80287a:	f7 d8                	neg    %eax
  80287c:	85 ff                	test   %edi,%edi
  80287e:	0f 44 c3             	cmove  %ebx,%eax
}
  802881:	5b                   	pop    %ebx
  802882:	5e                   	pop    %esi
  802883:	5f                   	pop    %edi
  802884:	5d                   	pop    %ebp
  802885:	c3                   	ret    

00802886 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
  802889:	57                   	push   %edi
  80288a:	56                   	push   %esi
  80288b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax
  802891:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802894:	8b 55 08             	mov    0x8(%ebp),%edx
  802897:	89 c3                	mov    %eax,%ebx
  802899:	89 c7                	mov    %eax,%edi
  80289b:	89 c6                	mov    %eax,%esi
  80289d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80289f:	5b                   	pop    %ebx
  8028a0:	5e                   	pop    %esi
  8028a1:	5f                   	pop    %edi
  8028a2:	5d                   	pop    %ebp
  8028a3:	c3                   	ret    

008028a4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8028a4:	55                   	push   %ebp
  8028a5:	89 e5                	mov    %esp,%ebp
  8028a7:	57                   	push   %edi
  8028a8:	56                   	push   %esi
  8028a9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8028af:	b8 01 00 00 00       	mov    $0x1,%eax
  8028b4:	89 d1                	mov    %edx,%ecx
  8028b6:	89 d3                	mov    %edx,%ebx
  8028b8:	89 d7                	mov    %edx,%edi
  8028ba:	89 d6                	mov    %edx,%esi
  8028bc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8028be:	5b                   	pop    %ebx
  8028bf:	5e                   	pop    %esi
  8028c0:	5f                   	pop    %edi
  8028c1:	5d                   	pop    %ebp
  8028c2:	c3                   	ret    

008028c3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8028c3:	55                   	push   %ebp
  8028c4:	89 e5                	mov    %esp,%ebp
  8028c6:	57                   	push   %edi
  8028c7:	56                   	push   %esi
  8028c8:	53                   	push   %ebx
  8028c9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8028d1:	b8 03 00 00 00       	mov    $0x3,%eax
  8028d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d9:	89 cb                	mov    %ecx,%ebx
  8028db:	89 cf                	mov    %ecx,%edi
  8028dd:	89 ce                	mov    %ecx,%esi
  8028df:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	7e 28                	jle    80290d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8028e5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8028e9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8028f0:	00 
  8028f1:	c7 44 24 08 97 4d 80 	movl   $0x804d97,0x8(%esp)
  8028f8:	00 
  8028f9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802900:	00 
  802901:	c7 04 24 b4 4d 80 00 	movl   $0x804db4,(%esp)
  802908:	e8 bc f4 ff ff       	call   801dc9 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80290d:	83 c4 2c             	add    $0x2c,%esp
  802910:	5b                   	pop    %ebx
  802911:	5e                   	pop    %esi
  802912:	5f                   	pop    %edi
  802913:	5d                   	pop    %ebp
  802914:	c3                   	ret    

00802915 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
  802918:	57                   	push   %edi
  802919:	56                   	push   %esi
  80291a:	53                   	push   %ebx
  80291b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80291e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802923:	b8 04 00 00 00       	mov    $0x4,%eax
  802928:	8b 55 08             	mov    0x8(%ebp),%edx
  80292b:	89 cb                	mov    %ecx,%ebx
  80292d:	89 cf                	mov    %ecx,%edi
  80292f:	89 ce                	mov    %ecx,%esi
  802931:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802933:	85 c0                	test   %eax,%eax
  802935:	7e 28                	jle    80295f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  802937:	89 44 24 10          	mov    %eax,0x10(%esp)
  80293b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  802942:	00 
  802943:	c7 44 24 08 97 4d 80 	movl   $0x804d97,0x8(%esp)
  80294a:	00 
  80294b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802952:	00 
  802953:	c7 04 24 b4 4d 80 00 	movl   $0x804db4,(%esp)
  80295a:	e8 6a f4 ff ff       	call   801dc9 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  80295f:	83 c4 2c             	add    $0x2c,%esp
  802962:	5b                   	pop    %ebx
  802963:	5e                   	pop    %esi
  802964:	5f                   	pop    %edi
  802965:	5d                   	pop    %ebp
  802966:	c3                   	ret    

00802967 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  802967:	55                   	push   %ebp
  802968:	89 e5                	mov    %esp,%ebp
  80296a:	57                   	push   %edi
  80296b:	56                   	push   %esi
  80296c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80296d:	ba 00 00 00 00       	mov    $0x0,%edx
  802972:	b8 02 00 00 00       	mov    $0x2,%eax
  802977:	89 d1                	mov    %edx,%ecx
  802979:	89 d3                	mov    %edx,%ebx
  80297b:	89 d7                	mov    %edx,%edi
  80297d:	89 d6                	mov    %edx,%esi
  80297f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  802981:	5b                   	pop    %ebx
  802982:	5e                   	pop    %esi
  802983:	5f                   	pop    %edi
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    

00802986 <sys_yield>:

void
sys_yield(void)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
  802989:	57                   	push   %edi
  80298a:	56                   	push   %esi
  80298b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80298c:	ba 00 00 00 00       	mov    $0x0,%edx
  802991:	b8 0c 00 00 00       	mov    $0xc,%eax
  802996:	89 d1                	mov    %edx,%ecx
  802998:	89 d3                	mov    %edx,%ebx
  80299a:	89 d7                	mov    %edx,%edi
  80299c:	89 d6                	mov    %edx,%esi
  80299e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8029a0:	5b                   	pop    %ebx
  8029a1:	5e                   	pop    %esi
  8029a2:	5f                   	pop    %edi
  8029a3:	5d                   	pop    %ebp
  8029a4:	c3                   	ret    

008029a5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8029a5:	55                   	push   %ebp
  8029a6:	89 e5                	mov    %esp,%ebp
  8029a8:	57                   	push   %edi
  8029a9:	56                   	push   %esi
  8029aa:	53                   	push   %ebx
  8029ab:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029ae:	be 00 00 00 00       	mov    $0x0,%esi
  8029b3:	b8 05 00 00 00       	mov    $0x5,%eax
  8029b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8029c1:	89 f7                	mov    %esi,%edi
  8029c3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	7e 28                	jle    8029f1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8029c9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8029cd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8029d4:	00 
  8029d5:	c7 44 24 08 97 4d 80 	movl   $0x804d97,0x8(%esp)
  8029dc:	00 
  8029dd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8029e4:	00 
  8029e5:	c7 04 24 b4 4d 80 00 	movl   $0x804db4,(%esp)
  8029ec:	e8 d8 f3 ff ff       	call   801dc9 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8029f1:	83 c4 2c             	add    $0x2c,%esp
  8029f4:	5b                   	pop    %ebx
  8029f5:	5e                   	pop    %esi
  8029f6:	5f                   	pop    %edi
  8029f7:	5d                   	pop    %ebp
  8029f8:	c3                   	ret    

008029f9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8029f9:	55                   	push   %ebp
  8029fa:	89 e5                	mov    %esp,%ebp
  8029fc:	57                   	push   %edi
  8029fd:	56                   	push   %esi
  8029fe:	53                   	push   %ebx
  8029ff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a02:	b8 06 00 00 00       	mov    $0x6,%eax
  802a07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a10:	8b 7d 14             	mov    0x14(%ebp),%edi
  802a13:	8b 75 18             	mov    0x18(%ebp),%esi
  802a16:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802a18:	85 c0                	test   %eax,%eax
  802a1a:	7e 28                	jle    802a44 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a1c:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a20:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  802a27:	00 
  802a28:	c7 44 24 08 97 4d 80 	movl   $0x804d97,0x8(%esp)
  802a2f:	00 
  802a30:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802a37:	00 
  802a38:	c7 04 24 b4 4d 80 00 	movl   $0x804db4,(%esp)
  802a3f:	e8 85 f3 ff ff       	call   801dc9 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802a44:	83 c4 2c             	add    $0x2c,%esp
  802a47:	5b                   	pop    %ebx
  802a48:	5e                   	pop    %esi
  802a49:	5f                   	pop    %edi
  802a4a:	5d                   	pop    %ebp
  802a4b:	c3                   	ret    

00802a4c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802a4c:	55                   	push   %ebp
  802a4d:	89 e5                	mov    %esp,%ebp
  802a4f:	57                   	push   %edi
  802a50:	56                   	push   %esi
  802a51:	53                   	push   %ebx
  802a52:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a55:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a5a:	b8 07 00 00 00       	mov    $0x7,%eax
  802a5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a62:	8b 55 08             	mov    0x8(%ebp),%edx
  802a65:	89 df                	mov    %ebx,%edi
  802a67:	89 de                	mov    %ebx,%esi
  802a69:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	7e 28                	jle    802a97 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a6f:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a73:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802a7a:	00 
  802a7b:	c7 44 24 08 97 4d 80 	movl   $0x804d97,0x8(%esp)
  802a82:	00 
  802a83:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802a8a:	00 
  802a8b:	c7 04 24 b4 4d 80 00 	movl   $0x804db4,(%esp)
  802a92:	e8 32 f3 ff ff       	call   801dc9 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802a97:	83 c4 2c             	add    $0x2c,%esp
  802a9a:	5b                   	pop    %ebx
  802a9b:	5e                   	pop    %esi
  802a9c:	5f                   	pop    %edi
  802a9d:	5d                   	pop    %ebp
  802a9e:	c3                   	ret    

00802a9f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  802a9f:	55                   	push   %ebp
  802aa0:	89 e5                	mov    %esp,%ebp
  802aa2:	57                   	push   %edi
  802aa3:	56                   	push   %esi
  802aa4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802aa5:	b9 00 00 00 00       	mov    $0x0,%ecx
  802aaa:	b8 10 00 00 00       	mov    $0x10,%eax
  802aaf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab2:	89 cb                	mov    %ecx,%ebx
  802ab4:	89 cf                	mov    %ecx,%edi
  802ab6:	89 ce                	mov    %ecx,%esi
  802ab8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  802aba:	5b                   	pop    %ebx
  802abb:	5e                   	pop    %esi
  802abc:	5f                   	pop    %edi
  802abd:	5d                   	pop    %ebp
  802abe:	c3                   	ret    

00802abf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802abf:	55                   	push   %ebp
  802ac0:	89 e5                	mov    %esp,%ebp
  802ac2:	57                   	push   %edi
  802ac3:	56                   	push   %esi
  802ac4:	53                   	push   %ebx
  802ac5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ac8:	bb 00 00 00 00       	mov    $0x0,%ebx
  802acd:	b8 09 00 00 00       	mov    $0x9,%eax
  802ad2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ad5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad8:	89 df                	mov    %ebx,%edi
  802ada:	89 de                	mov    %ebx,%esi
  802adc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	7e 28                	jle    802b0a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802ae2:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ae6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  802aed:	00 
  802aee:	c7 44 24 08 97 4d 80 	movl   $0x804d97,0x8(%esp)
  802af5:	00 
  802af6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802afd:	00 
  802afe:	c7 04 24 b4 4d 80 00 	movl   $0x804db4,(%esp)
  802b05:	e8 bf f2 ff ff       	call   801dc9 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802b0a:	83 c4 2c             	add    $0x2c,%esp
  802b0d:	5b                   	pop    %ebx
  802b0e:	5e                   	pop    %esi
  802b0f:	5f                   	pop    %edi
  802b10:	5d                   	pop    %ebp
  802b11:	c3                   	ret    

00802b12 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802b12:	55                   	push   %ebp
  802b13:	89 e5                	mov    %esp,%ebp
  802b15:	57                   	push   %edi
  802b16:	56                   	push   %esi
  802b17:	53                   	push   %ebx
  802b18:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b20:	b8 0a 00 00 00       	mov    $0xa,%eax
  802b25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b28:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2b:	89 df                	mov    %ebx,%edi
  802b2d:	89 de                	mov    %ebx,%esi
  802b2f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802b31:	85 c0                	test   %eax,%eax
  802b33:	7e 28                	jle    802b5d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802b35:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b39:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  802b40:	00 
  802b41:	c7 44 24 08 97 4d 80 	movl   $0x804d97,0x8(%esp)
  802b48:	00 
  802b49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802b50:	00 
  802b51:	c7 04 24 b4 4d 80 00 	movl   $0x804db4,(%esp)
  802b58:	e8 6c f2 ff ff       	call   801dc9 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802b5d:	83 c4 2c             	add    $0x2c,%esp
  802b60:	5b                   	pop    %ebx
  802b61:	5e                   	pop    %esi
  802b62:	5f                   	pop    %edi
  802b63:	5d                   	pop    %ebp
  802b64:	c3                   	ret    

00802b65 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802b65:	55                   	push   %ebp
  802b66:	89 e5                	mov    %esp,%ebp
  802b68:	57                   	push   %edi
  802b69:	56                   	push   %esi
  802b6a:	53                   	push   %ebx
  802b6b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b73:	b8 0b 00 00 00       	mov    $0xb,%eax
  802b78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7e:	89 df                	mov    %ebx,%edi
  802b80:	89 de                	mov    %ebx,%esi
  802b82:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802b84:	85 c0                	test   %eax,%eax
  802b86:	7e 28                	jle    802bb0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802b88:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b8c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  802b93:	00 
  802b94:	c7 44 24 08 97 4d 80 	movl   $0x804d97,0x8(%esp)
  802b9b:	00 
  802b9c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802ba3:	00 
  802ba4:	c7 04 24 b4 4d 80 00 	movl   $0x804db4,(%esp)
  802bab:	e8 19 f2 ff ff       	call   801dc9 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802bb0:	83 c4 2c             	add    $0x2c,%esp
  802bb3:	5b                   	pop    %ebx
  802bb4:	5e                   	pop    %esi
  802bb5:	5f                   	pop    %edi
  802bb6:	5d                   	pop    %ebp
  802bb7:	c3                   	ret    

00802bb8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802bb8:	55                   	push   %ebp
  802bb9:	89 e5                	mov    %esp,%ebp
  802bbb:	57                   	push   %edi
  802bbc:	56                   	push   %esi
  802bbd:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802bbe:	be 00 00 00 00       	mov    $0x0,%esi
  802bc3:	b8 0d 00 00 00       	mov    $0xd,%eax
  802bc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802bcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802bd1:	8b 7d 14             	mov    0x14(%ebp),%edi
  802bd4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802bd6:	5b                   	pop    %ebx
  802bd7:	5e                   	pop    %esi
  802bd8:	5f                   	pop    %edi
  802bd9:	5d                   	pop    %ebp
  802bda:	c3                   	ret    

00802bdb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802bdb:	55                   	push   %ebp
  802bdc:	89 e5                	mov    %esp,%ebp
  802bde:	57                   	push   %edi
  802bdf:	56                   	push   %esi
  802be0:	53                   	push   %ebx
  802be1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802be4:	b9 00 00 00 00       	mov    $0x0,%ecx
  802be9:	b8 0e 00 00 00       	mov    $0xe,%eax
  802bee:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf1:	89 cb                	mov    %ecx,%ebx
  802bf3:	89 cf                	mov    %ecx,%edi
  802bf5:	89 ce                	mov    %ecx,%esi
  802bf7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	7e 28                	jle    802c25 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  802bfd:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c01:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  802c08:	00 
  802c09:	c7 44 24 08 97 4d 80 	movl   $0x804d97,0x8(%esp)
  802c10:	00 
  802c11:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802c18:	00 
  802c19:	c7 04 24 b4 4d 80 00 	movl   $0x804db4,(%esp)
  802c20:	e8 a4 f1 ff ff       	call   801dc9 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802c25:	83 c4 2c             	add    $0x2c,%esp
  802c28:	5b                   	pop    %ebx
  802c29:	5e                   	pop    %esi
  802c2a:	5f                   	pop    %edi
  802c2b:	5d                   	pop    %ebp
  802c2c:	c3                   	ret    

00802c2d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802c2d:	55                   	push   %ebp
  802c2e:	89 e5                	mov    %esp,%ebp
  802c30:	57                   	push   %edi
  802c31:	56                   	push   %esi
  802c32:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c33:	ba 00 00 00 00       	mov    $0x0,%edx
  802c38:	b8 0f 00 00 00       	mov    $0xf,%eax
  802c3d:	89 d1                	mov    %edx,%ecx
  802c3f:	89 d3                	mov    %edx,%ebx
  802c41:	89 d7                	mov    %edx,%edi
  802c43:	89 d6                	mov    %edx,%esi
  802c45:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802c47:	5b                   	pop    %ebx
  802c48:	5e                   	pop    %esi
  802c49:	5f                   	pop    %edi
  802c4a:	5d                   	pop    %ebp
  802c4b:	c3                   	ret    

00802c4c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  802c4c:	55                   	push   %ebp
  802c4d:	89 e5                	mov    %esp,%ebp
  802c4f:	57                   	push   %edi
  802c50:	56                   	push   %esi
  802c51:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c52:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c57:	b8 11 00 00 00       	mov    $0x11,%eax
  802c5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c62:	89 df                	mov    %ebx,%edi
  802c64:	89 de                	mov    %ebx,%esi
  802c66:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  802c68:	5b                   	pop    %ebx
  802c69:	5e                   	pop    %esi
  802c6a:	5f                   	pop    %edi
  802c6b:	5d                   	pop    %ebp
  802c6c:	c3                   	ret    

00802c6d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  802c6d:	55                   	push   %ebp
  802c6e:	89 e5                	mov    %esp,%ebp
  802c70:	57                   	push   %edi
  802c71:	56                   	push   %esi
  802c72:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c73:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c78:	b8 12 00 00 00       	mov    $0x12,%eax
  802c7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c80:	8b 55 08             	mov    0x8(%ebp),%edx
  802c83:	89 df                	mov    %ebx,%edi
  802c85:	89 de                	mov    %ebx,%esi
  802c87:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  802c89:	5b                   	pop    %ebx
  802c8a:	5e                   	pop    %esi
  802c8b:	5f                   	pop    %edi
  802c8c:	5d                   	pop    %ebp
  802c8d:	c3                   	ret    

00802c8e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  802c8e:	55                   	push   %ebp
  802c8f:	89 e5                	mov    %esp,%ebp
  802c91:	57                   	push   %edi
  802c92:	56                   	push   %esi
  802c93:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c94:	b9 00 00 00 00       	mov    $0x0,%ecx
  802c99:	b8 13 00 00 00       	mov    $0x13,%eax
  802c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca1:	89 cb                	mov    %ecx,%ebx
  802ca3:	89 cf                	mov    %ecx,%edi
  802ca5:	89 ce                	mov    %ecx,%esi
  802ca7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  802ca9:	5b                   	pop    %ebx
  802caa:	5e                   	pop    %esi
  802cab:	5f                   	pop    %edi
  802cac:	5d                   	pop    %ebp
  802cad:	c3                   	ret    

00802cae <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802cae:	55                   	push   %ebp
  802caf:	89 e5                	mov    %esp,%ebp
  802cb1:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802cb4:	83 3d 14 a0 80 00 00 	cmpl   $0x0,0x80a014
  802cbb:	75 7a                	jne    802d37 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802cbd:	e8 a5 fc ff ff       	call   802967 <sys_getenvid>
  802cc2:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802cc9:	00 
  802cca:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802cd1:	ee 
  802cd2:	89 04 24             	mov    %eax,(%esp)
  802cd5:	e8 cb fc ff ff       	call   8029a5 <sys_page_alloc>
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	79 20                	jns    802cfe <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802cde:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ce2:	c7 44 24 08 b8 45 80 	movl   $0x8045b8,0x8(%esp)
  802ce9:	00 
  802cea:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802cf1:	00 
  802cf2:	c7 04 24 c2 4d 80 00 	movl   $0x804dc2,(%esp)
  802cf9:	e8 cb f0 ff ff       	call   801dc9 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802cfe:	e8 64 fc ff ff       	call   802967 <sys_getenvid>
  802d03:	c7 44 24 04 41 2d 80 	movl   $0x802d41,0x4(%esp)
  802d0a:	00 
  802d0b:	89 04 24             	mov    %eax,(%esp)
  802d0e:	e8 52 fe ff ff       	call   802b65 <sys_env_set_pgfault_upcall>
  802d13:	85 c0                	test   %eax,%eax
  802d15:	79 20                	jns    802d37 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802d17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d1b:	c7 44 24 08 d0 4d 80 	movl   $0x804dd0,0x8(%esp)
  802d22:	00 
  802d23:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802d2a:	00 
  802d2b:	c7 04 24 c2 4d 80 00 	movl   $0x804dc2,(%esp)
  802d32:	e8 92 f0 ff ff       	call   801dc9 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	a3 14 a0 80 00       	mov    %eax,0x80a014
}
  802d3f:	c9                   	leave  
  802d40:	c3                   	ret    

00802d41 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802d41:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802d42:	a1 14 a0 80 00       	mov    0x80a014,%eax
	call *%eax
  802d47:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802d49:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802d4c:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802d50:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802d54:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802d57:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802d5b:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802d5d:	83 c4 08             	add    $0x8,%esp
	popal
  802d60:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802d61:	83 c4 04             	add    $0x4,%esp
	popfl
  802d64:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802d65:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802d66:	c3                   	ret    
  802d67:	66 90                	xchg   %ax,%ax
  802d69:	66 90                	xchg   %ax,%ax
  802d6b:	66 90                	xchg   %ax,%ax
  802d6d:	66 90                	xchg   %ax,%ax
  802d6f:	90                   	nop

00802d70 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d70:	55                   	push   %ebp
  802d71:	89 e5                	mov    %esp,%ebp
  802d73:	56                   	push   %esi
  802d74:	53                   	push   %ebx
  802d75:	83 ec 10             	sub    $0x10,%esp
  802d78:	8b 75 08             	mov    0x8(%ebp),%esi
  802d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802d81:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802d83:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802d88:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802d8b:	89 04 24             	mov    %eax,(%esp)
  802d8e:	e8 48 fe ff ff       	call   802bdb <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802d93:	85 c0                	test   %eax,%eax
  802d95:	75 26                	jne    802dbd <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802d97:	85 f6                	test   %esi,%esi
  802d99:	74 0a                	je     802da5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802d9b:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802da0:	8b 40 74             	mov    0x74(%eax),%eax
  802da3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802da5:	85 db                	test   %ebx,%ebx
  802da7:	74 0a                	je     802db3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802da9:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802dae:	8b 40 78             	mov    0x78(%eax),%eax
  802db1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802db3:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802db8:	8b 40 70             	mov    0x70(%eax),%eax
  802dbb:	eb 14                	jmp    802dd1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  802dbd:	85 f6                	test   %esi,%esi
  802dbf:	74 06                	je     802dc7 <ipc_recv+0x57>
			*from_env_store = 0;
  802dc1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802dc7:	85 db                	test   %ebx,%ebx
  802dc9:	74 06                	je     802dd1 <ipc_recv+0x61>
			*perm_store = 0;
  802dcb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802dd1:	83 c4 10             	add    $0x10,%esp
  802dd4:	5b                   	pop    %ebx
  802dd5:	5e                   	pop    %esi
  802dd6:	5d                   	pop    %ebp
  802dd7:	c3                   	ret    

00802dd8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802dd8:	55                   	push   %ebp
  802dd9:	89 e5                	mov    %esp,%ebp
  802ddb:	57                   	push   %edi
  802ddc:	56                   	push   %esi
  802ddd:	53                   	push   %ebx
  802dde:	83 ec 1c             	sub    $0x1c,%esp
  802de1:	8b 7d 08             	mov    0x8(%ebp),%edi
  802de4:	8b 75 0c             	mov    0xc(%ebp),%esi
  802de7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  802dea:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  802dec:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802df1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802df4:	8b 45 14             	mov    0x14(%ebp),%eax
  802df7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802dfb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802dff:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e03:	89 3c 24             	mov    %edi,(%esp)
  802e06:	e8 ad fd ff ff       	call   802bb8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802e0b:	85 c0                	test   %eax,%eax
  802e0d:	74 28                	je     802e37 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802e0f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802e12:	74 1c                	je     802e30 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802e14:	c7 44 24 08 f4 4d 80 	movl   $0x804df4,0x8(%esp)
  802e1b:	00 
  802e1c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802e23:	00 
  802e24:	c7 04 24 15 4e 80 00 	movl   $0x804e15,(%esp)
  802e2b:	e8 99 ef ff ff       	call   801dc9 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802e30:	e8 51 fb ff ff       	call   802986 <sys_yield>
	}
  802e35:	eb bd                	jmp    802df4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802e37:	83 c4 1c             	add    $0x1c,%esp
  802e3a:	5b                   	pop    %ebx
  802e3b:	5e                   	pop    %esi
  802e3c:	5f                   	pop    %edi
  802e3d:	5d                   	pop    %ebp
  802e3e:	c3                   	ret    

00802e3f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802e3f:	55                   	push   %ebp
  802e40:	89 e5                	mov    %esp,%ebp
  802e42:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802e45:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802e4a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802e4d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802e53:	8b 52 50             	mov    0x50(%edx),%edx
  802e56:	39 ca                	cmp    %ecx,%edx
  802e58:	75 0d                	jne    802e67 <ipc_find_env+0x28>
			return envs[i].env_id;
  802e5a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802e5d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802e62:	8b 40 40             	mov    0x40(%eax),%eax
  802e65:	eb 0e                	jmp    802e75 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802e67:	83 c0 01             	add    $0x1,%eax
  802e6a:	3d 00 04 00 00       	cmp    $0x400,%eax
  802e6f:	75 d9                	jne    802e4a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802e71:	66 b8 00 00          	mov    $0x0,%ax
}
  802e75:	5d                   	pop    %ebp
  802e76:	c3                   	ret    
  802e77:	66 90                	xchg   %ax,%ax
  802e79:	66 90                	xchg   %ax,%ax
  802e7b:	66 90                	xchg   %ax,%ax
  802e7d:	66 90                	xchg   %ax,%ax
  802e7f:	90                   	nop

00802e80 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802e80:	55                   	push   %ebp
  802e81:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	05 00 00 00 30       	add    $0x30000000,%eax
  802e8b:	c1 e8 0c             	shr    $0xc,%eax
}
  802e8e:	5d                   	pop    %ebp
  802e8f:	c3                   	ret    

00802e90 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802e90:	55                   	push   %ebp
  802e91:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  802e9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802ea0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802ea5:	5d                   	pop    %ebp
  802ea6:	c3                   	ret    

00802ea7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802ea7:	55                   	push   %ebp
  802ea8:	89 e5                	mov    %esp,%ebp
  802eaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ead:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802eb2:	89 c2                	mov    %eax,%edx
  802eb4:	c1 ea 16             	shr    $0x16,%edx
  802eb7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802ebe:	f6 c2 01             	test   $0x1,%dl
  802ec1:	74 11                	je     802ed4 <fd_alloc+0x2d>
  802ec3:	89 c2                	mov    %eax,%edx
  802ec5:	c1 ea 0c             	shr    $0xc,%edx
  802ec8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802ecf:	f6 c2 01             	test   $0x1,%dl
  802ed2:	75 09                	jne    802edd <fd_alloc+0x36>
			*fd_store = fd;
  802ed4:	89 01                	mov    %eax,(%ecx)
			return 0;
  802ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  802edb:	eb 17                	jmp    802ef4 <fd_alloc+0x4d>
  802edd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802ee2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802ee7:	75 c9                	jne    802eb2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802ee9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  802eef:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  802ef4:	5d                   	pop    %ebp
  802ef5:	c3                   	ret    

00802ef6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802ef6:	55                   	push   %ebp
  802ef7:	89 e5                	mov    %esp,%ebp
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802efc:	83 f8 1f             	cmp    $0x1f,%eax
  802eff:	77 36                	ja     802f37 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802f01:	c1 e0 0c             	shl    $0xc,%eax
  802f04:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802f09:	89 c2                	mov    %eax,%edx
  802f0b:	c1 ea 16             	shr    $0x16,%edx
  802f0e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802f15:	f6 c2 01             	test   $0x1,%dl
  802f18:	74 24                	je     802f3e <fd_lookup+0x48>
  802f1a:	89 c2                	mov    %eax,%edx
  802f1c:	c1 ea 0c             	shr    $0xc,%edx
  802f1f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802f26:	f6 c2 01             	test   $0x1,%dl
  802f29:	74 1a                	je     802f45 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f2e:	89 02                	mov    %eax,(%edx)
	return 0;
  802f30:	b8 00 00 00 00       	mov    $0x0,%eax
  802f35:	eb 13                	jmp    802f4a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802f37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f3c:	eb 0c                	jmp    802f4a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802f3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f43:	eb 05                	jmp    802f4a <fd_lookup+0x54>
  802f45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  802f4a:	5d                   	pop    %ebp
  802f4b:	c3                   	ret    

00802f4c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802f4c:	55                   	push   %ebp
  802f4d:	89 e5                	mov    %esp,%ebp
  802f4f:	83 ec 18             	sub    $0x18,%esp
  802f52:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802f55:	ba 00 00 00 00       	mov    $0x0,%edx
  802f5a:	eb 13                	jmp    802f6f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  802f5c:	39 08                	cmp    %ecx,(%eax)
  802f5e:	75 0c                	jne    802f6c <dev_lookup+0x20>
			*dev = devtab[i];
  802f60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f63:	89 01                	mov    %eax,(%ecx)
			return 0;
  802f65:	b8 00 00 00 00       	mov    $0x0,%eax
  802f6a:	eb 38                	jmp    802fa4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802f6c:	83 c2 01             	add    $0x1,%edx
  802f6f:	8b 04 95 a0 4e 80 00 	mov    0x804ea0(,%edx,4),%eax
  802f76:	85 c0                	test   %eax,%eax
  802f78:	75 e2                	jne    802f5c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802f7a:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802f7f:	8b 40 48             	mov    0x48(%eax),%eax
  802f82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f86:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f8a:	c7 04 24 20 4e 80 00 	movl   $0x804e20,(%esp)
  802f91:	e8 2c ef ff ff       	call   801ec2 <cprintf>
	*dev = 0;
  802f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802f9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802fa4:	c9                   	leave  
  802fa5:	c3                   	ret    

00802fa6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802fa6:	55                   	push   %ebp
  802fa7:	89 e5                	mov    %esp,%ebp
  802fa9:	56                   	push   %esi
  802faa:	53                   	push   %ebx
  802fab:	83 ec 20             	sub    $0x20,%esp
  802fae:	8b 75 08             	mov    0x8(%ebp),%esi
  802fb1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802fbb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802fc1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802fc4:	89 04 24             	mov    %eax,(%esp)
  802fc7:	e8 2a ff ff ff       	call   802ef6 <fd_lookup>
  802fcc:	85 c0                	test   %eax,%eax
  802fce:	78 05                	js     802fd5 <fd_close+0x2f>
	    || fd != fd2)
  802fd0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  802fd3:	74 0c                	je     802fe1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  802fd5:	84 db                	test   %bl,%bl
  802fd7:	ba 00 00 00 00       	mov    $0x0,%edx
  802fdc:	0f 44 c2             	cmove  %edx,%eax
  802fdf:	eb 3f                	jmp    803020 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802fe1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fe8:	8b 06                	mov    (%esi),%eax
  802fea:	89 04 24             	mov    %eax,(%esp)
  802fed:	e8 5a ff ff ff       	call   802f4c <dev_lookup>
  802ff2:	89 c3                	mov    %eax,%ebx
  802ff4:	85 c0                	test   %eax,%eax
  802ff6:	78 16                	js     80300e <fd_close+0x68>
		if (dev->dev_close)
  802ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  802ffe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  803003:	85 c0                	test   %eax,%eax
  803005:	74 07                	je     80300e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  803007:	89 34 24             	mov    %esi,(%esp)
  80300a:	ff d0                	call   *%eax
  80300c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80300e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803012:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803019:	e8 2e fa ff ff       	call   802a4c <sys_page_unmap>
	return r;
  80301e:	89 d8                	mov    %ebx,%eax
}
  803020:	83 c4 20             	add    $0x20,%esp
  803023:	5b                   	pop    %ebx
  803024:	5e                   	pop    %esi
  803025:	5d                   	pop    %ebp
  803026:	c3                   	ret    

00803027 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  803027:	55                   	push   %ebp
  803028:	89 e5                	mov    %esp,%ebp
  80302a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80302d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803030:	89 44 24 04          	mov    %eax,0x4(%esp)
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	89 04 24             	mov    %eax,(%esp)
  80303a:	e8 b7 fe ff ff       	call   802ef6 <fd_lookup>
  80303f:	89 c2                	mov    %eax,%edx
  803041:	85 d2                	test   %edx,%edx
  803043:	78 13                	js     803058 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  803045:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80304c:	00 
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	89 04 24             	mov    %eax,(%esp)
  803053:	e8 4e ff ff ff       	call   802fa6 <fd_close>
}
  803058:	c9                   	leave  
  803059:	c3                   	ret    

0080305a <close_all>:

void
close_all(void)
{
  80305a:	55                   	push   %ebp
  80305b:	89 e5                	mov    %esp,%ebp
  80305d:	53                   	push   %ebx
  80305e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  803061:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  803066:	89 1c 24             	mov    %ebx,(%esp)
  803069:	e8 b9 ff ff ff       	call   803027 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80306e:	83 c3 01             	add    $0x1,%ebx
  803071:	83 fb 20             	cmp    $0x20,%ebx
  803074:	75 f0                	jne    803066 <close_all+0xc>
		close(i);
}
  803076:	83 c4 14             	add    $0x14,%esp
  803079:	5b                   	pop    %ebx
  80307a:	5d                   	pop    %ebp
  80307b:	c3                   	ret    

0080307c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80307c:	55                   	push   %ebp
  80307d:	89 e5                	mov    %esp,%ebp
  80307f:	57                   	push   %edi
  803080:	56                   	push   %esi
  803081:	53                   	push   %ebx
  803082:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803085:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	89 04 24             	mov    %eax,(%esp)
  803092:	e8 5f fe ff ff       	call   802ef6 <fd_lookup>
  803097:	89 c2                	mov    %eax,%edx
  803099:	85 d2                	test   %edx,%edx
  80309b:	0f 88 e1 00 00 00    	js     803182 <dup+0x106>
		return r;
	close(newfdnum);
  8030a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a4:	89 04 24             	mov    %eax,(%esp)
  8030a7:	e8 7b ff ff ff       	call   803027 <close>

	newfd = INDEX2FD(newfdnum);
  8030ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8030af:	c1 e3 0c             	shl    $0xc,%ebx
  8030b2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8030b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030bb:	89 04 24             	mov    %eax,(%esp)
  8030be:	e8 cd fd ff ff       	call   802e90 <fd2data>
  8030c3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8030c5:	89 1c 24             	mov    %ebx,(%esp)
  8030c8:	e8 c3 fd ff ff       	call   802e90 <fd2data>
  8030cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8030cf:	89 f0                	mov    %esi,%eax
  8030d1:	c1 e8 16             	shr    $0x16,%eax
  8030d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8030db:	a8 01                	test   $0x1,%al
  8030dd:	74 43                	je     803122 <dup+0xa6>
  8030df:	89 f0                	mov    %esi,%eax
  8030e1:	c1 e8 0c             	shr    $0xc,%eax
  8030e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8030eb:	f6 c2 01             	test   $0x1,%dl
  8030ee:	74 32                	je     803122 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8030f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8030f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8030fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  803100:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803104:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80310b:	00 
  80310c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803117:	e8 dd f8 ff ff       	call   8029f9 <sys_page_map>
  80311c:	89 c6                	mov    %eax,%esi
  80311e:	85 c0                	test   %eax,%eax
  803120:	78 3e                	js     803160 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803122:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803125:	89 c2                	mov    %eax,%edx
  803127:	c1 ea 0c             	shr    $0xc,%edx
  80312a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  803131:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  803137:	89 54 24 10          	mov    %edx,0x10(%esp)
  80313b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80313f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803146:	00 
  803147:	89 44 24 04          	mov    %eax,0x4(%esp)
  80314b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803152:	e8 a2 f8 ff ff       	call   8029f9 <sys_page_map>
  803157:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  803159:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80315c:	85 f6                	test   %esi,%esi
  80315e:	79 22                	jns    803182 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803160:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803164:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80316b:	e8 dc f8 ff ff       	call   802a4c <sys_page_unmap>
	sys_page_unmap(0, nva);
  803170:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803174:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80317b:	e8 cc f8 ff ff       	call   802a4c <sys_page_unmap>
	return r;
  803180:	89 f0                	mov    %esi,%eax
}
  803182:	83 c4 3c             	add    $0x3c,%esp
  803185:	5b                   	pop    %ebx
  803186:	5e                   	pop    %esi
  803187:	5f                   	pop    %edi
  803188:	5d                   	pop    %ebp
  803189:	c3                   	ret    

0080318a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80318a:	55                   	push   %ebp
  80318b:	89 e5                	mov    %esp,%ebp
  80318d:	53                   	push   %ebx
  80318e:	83 ec 24             	sub    $0x24,%esp
  803191:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803194:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803197:	89 44 24 04          	mov    %eax,0x4(%esp)
  80319b:	89 1c 24             	mov    %ebx,(%esp)
  80319e:	e8 53 fd ff ff       	call   802ef6 <fd_lookup>
  8031a3:	89 c2                	mov    %eax,%edx
  8031a5:	85 d2                	test   %edx,%edx
  8031a7:	78 6d                	js     803216 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b3:	8b 00                	mov    (%eax),%eax
  8031b5:	89 04 24             	mov    %eax,(%esp)
  8031b8:	e8 8f fd ff ff       	call   802f4c <dev_lookup>
  8031bd:	85 c0                	test   %eax,%eax
  8031bf:	78 55                	js     803216 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8031c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c4:	8b 50 08             	mov    0x8(%eax),%edx
  8031c7:	83 e2 03             	and    $0x3,%edx
  8031ca:	83 fa 01             	cmp    $0x1,%edx
  8031cd:	75 23                	jne    8031f2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8031cf:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8031d4:	8b 40 48             	mov    0x48(%eax),%eax
  8031d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031df:	c7 04 24 64 4e 80 00 	movl   $0x804e64,(%esp)
  8031e6:	e8 d7 ec ff ff       	call   801ec2 <cprintf>
		return -E_INVAL;
  8031eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031f0:	eb 24                	jmp    803216 <read+0x8c>
	}
	if (!dev->dev_read)
  8031f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f5:	8b 52 08             	mov    0x8(%edx),%edx
  8031f8:	85 d2                	test   %edx,%edx
  8031fa:	74 15                	je     803211 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8031fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803203:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803206:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80320a:	89 04 24             	mov    %eax,(%esp)
  80320d:	ff d2                	call   *%edx
  80320f:	eb 05                	jmp    803216 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  803211:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  803216:	83 c4 24             	add    $0x24,%esp
  803219:	5b                   	pop    %ebx
  80321a:	5d                   	pop    %ebp
  80321b:	c3                   	ret    

0080321c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80321c:	55                   	push   %ebp
  80321d:	89 e5                	mov    %esp,%ebp
  80321f:	57                   	push   %edi
  803220:	56                   	push   %esi
  803221:	53                   	push   %ebx
  803222:	83 ec 1c             	sub    $0x1c,%esp
  803225:	8b 7d 08             	mov    0x8(%ebp),%edi
  803228:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80322b:	bb 00 00 00 00       	mov    $0x0,%ebx
  803230:	eb 23                	jmp    803255 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803232:	89 f0                	mov    %esi,%eax
  803234:	29 d8                	sub    %ebx,%eax
  803236:	89 44 24 08          	mov    %eax,0x8(%esp)
  80323a:	89 d8                	mov    %ebx,%eax
  80323c:	03 45 0c             	add    0xc(%ebp),%eax
  80323f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803243:	89 3c 24             	mov    %edi,(%esp)
  803246:	e8 3f ff ff ff       	call   80318a <read>
		if (m < 0)
  80324b:	85 c0                	test   %eax,%eax
  80324d:	78 10                	js     80325f <readn+0x43>
			return m;
		if (m == 0)
  80324f:	85 c0                	test   %eax,%eax
  803251:	74 0a                	je     80325d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803253:	01 c3                	add    %eax,%ebx
  803255:	39 f3                	cmp    %esi,%ebx
  803257:	72 d9                	jb     803232 <readn+0x16>
  803259:	89 d8                	mov    %ebx,%eax
  80325b:	eb 02                	jmp    80325f <readn+0x43>
  80325d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80325f:	83 c4 1c             	add    $0x1c,%esp
  803262:	5b                   	pop    %ebx
  803263:	5e                   	pop    %esi
  803264:	5f                   	pop    %edi
  803265:	5d                   	pop    %ebp
  803266:	c3                   	ret    

00803267 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803267:	55                   	push   %ebp
  803268:	89 e5                	mov    %esp,%ebp
  80326a:	53                   	push   %ebx
  80326b:	83 ec 24             	sub    $0x24,%esp
  80326e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803271:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803274:	89 44 24 04          	mov    %eax,0x4(%esp)
  803278:	89 1c 24             	mov    %ebx,(%esp)
  80327b:	e8 76 fc ff ff       	call   802ef6 <fd_lookup>
  803280:	89 c2                	mov    %eax,%edx
  803282:	85 d2                	test   %edx,%edx
  803284:	78 68                	js     8032ee <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803286:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803289:	89 44 24 04          	mov    %eax,0x4(%esp)
  80328d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803290:	8b 00                	mov    (%eax),%eax
  803292:	89 04 24             	mov    %eax,(%esp)
  803295:	e8 b2 fc ff ff       	call   802f4c <dev_lookup>
  80329a:	85 c0                	test   %eax,%eax
  80329c:	78 50                	js     8032ee <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80329e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8032a5:	75 23                	jne    8032ca <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8032a7:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8032ac:	8b 40 48             	mov    0x48(%eax),%eax
  8032af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032b7:	c7 04 24 80 4e 80 00 	movl   $0x804e80,(%esp)
  8032be:	e8 ff eb ff ff       	call   801ec2 <cprintf>
		return -E_INVAL;
  8032c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8032c8:	eb 24                	jmp    8032ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8032ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8032d0:	85 d2                	test   %edx,%edx
  8032d2:	74 15                	je     8032e9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8032d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8032de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032e2:	89 04 24             	mov    %eax,(%esp)
  8032e5:	ff d2                	call   *%edx
  8032e7:	eb 05                	jmp    8032ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8032e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8032ee:	83 c4 24             	add    $0x24,%esp
  8032f1:	5b                   	pop    %ebx
  8032f2:	5d                   	pop    %ebp
  8032f3:	c3                   	ret    

008032f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8032f4:	55                   	push   %ebp
  8032f5:	89 e5                	mov    %esp,%ebp
  8032f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8032fa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8032fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803301:	8b 45 08             	mov    0x8(%ebp),%eax
  803304:	89 04 24             	mov    %eax,(%esp)
  803307:	e8 ea fb ff ff       	call   802ef6 <fd_lookup>
  80330c:	85 c0                	test   %eax,%eax
  80330e:	78 0e                	js     80331e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  803310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803313:	8b 55 0c             	mov    0xc(%ebp),%edx
  803316:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  803319:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80331e:	c9                   	leave  
  80331f:	c3                   	ret    

00803320 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803320:	55                   	push   %ebp
  803321:	89 e5                	mov    %esp,%ebp
  803323:	53                   	push   %ebx
  803324:	83 ec 24             	sub    $0x24,%esp
  803327:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80332a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80332d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803331:	89 1c 24             	mov    %ebx,(%esp)
  803334:	e8 bd fb ff ff       	call   802ef6 <fd_lookup>
  803339:	89 c2                	mov    %eax,%edx
  80333b:	85 d2                	test   %edx,%edx
  80333d:	78 61                	js     8033a0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80333f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803342:	89 44 24 04          	mov    %eax,0x4(%esp)
  803346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	89 04 24             	mov    %eax,(%esp)
  80334e:	e8 f9 fb ff ff       	call   802f4c <dev_lookup>
  803353:	85 c0                	test   %eax,%eax
  803355:	78 49                	js     8033a0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80335e:	75 23                	jne    803383 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803360:	a1 10 a0 80 00       	mov    0x80a010,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803365:	8b 40 48             	mov    0x48(%eax),%eax
  803368:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80336c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803370:	c7 04 24 40 4e 80 00 	movl   $0x804e40,(%esp)
  803377:	e8 46 eb ff ff       	call   801ec2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80337c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803381:	eb 1d                	jmp    8033a0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  803383:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803386:	8b 52 18             	mov    0x18(%edx),%edx
  803389:	85 d2                	test   %edx,%edx
  80338b:	74 0e                	je     80339b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80338d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803390:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803394:	89 04 24             	mov    %eax,(%esp)
  803397:	ff d2                	call   *%edx
  803399:	eb 05                	jmp    8033a0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80339b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8033a0:	83 c4 24             	add    $0x24,%esp
  8033a3:	5b                   	pop    %ebx
  8033a4:	5d                   	pop    %ebp
  8033a5:	c3                   	ret    

008033a6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8033a6:	55                   	push   %ebp
  8033a7:	89 e5                	mov    %esp,%ebp
  8033a9:	53                   	push   %ebx
  8033aa:	83 ec 24             	sub    $0x24,%esp
  8033ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8033b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8033b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	89 04 24             	mov    %eax,(%esp)
  8033bd:	e8 34 fb ff ff       	call   802ef6 <fd_lookup>
  8033c2:	89 c2                	mov    %eax,%edx
  8033c4:	85 d2                	test   %edx,%edx
  8033c6:	78 52                	js     80341a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8033c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8033cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	89 04 24             	mov    %eax,(%esp)
  8033d7:	e8 70 fb ff ff       	call   802f4c <dev_lookup>
  8033dc:	85 c0                	test   %eax,%eax
  8033de:	78 3a                	js     80341a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8033e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8033e7:	74 2c                	je     803415 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8033e9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8033ec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8033f3:	00 00 00 
	stat->st_isdir = 0;
  8033f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8033fd:	00 00 00 
	stat->st_dev = dev;
  803400:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  803406:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80340a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340d:	89 14 24             	mov    %edx,(%esp)
  803410:	ff 50 14             	call   *0x14(%eax)
  803413:	eb 05                	jmp    80341a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  803415:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80341a:	83 c4 24             	add    $0x24,%esp
  80341d:	5b                   	pop    %ebx
  80341e:	5d                   	pop    %ebp
  80341f:	c3                   	ret    

00803420 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803420:	55                   	push   %ebp
  803421:	89 e5                	mov    %esp,%ebp
  803423:	56                   	push   %esi
  803424:	53                   	push   %ebx
  803425:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803428:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80342f:	00 
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	89 04 24             	mov    %eax,(%esp)
  803436:	e8 99 02 00 00       	call   8036d4 <open>
  80343b:	89 c3                	mov    %eax,%ebx
  80343d:	85 db                	test   %ebx,%ebx
  80343f:	78 1b                	js     80345c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  803441:	8b 45 0c             	mov    0xc(%ebp),%eax
  803444:	89 44 24 04          	mov    %eax,0x4(%esp)
  803448:	89 1c 24             	mov    %ebx,(%esp)
  80344b:	e8 56 ff ff ff       	call   8033a6 <fstat>
  803450:	89 c6                	mov    %eax,%esi
	close(fd);
  803452:	89 1c 24             	mov    %ebx,(%esp)
  803455:	e8 cd fb ff ff       	call   803027 <close>
	return r;
  80345a:	89 f0                	mov    %esi,%eax
}
  80345c:	83 c4 10             	add    $0x10,%esp
  80345f:	5b                   	pop    %ebx
  803460:	5e                   	pop    %esi
  803461:	5d                   	pop    %ebp
  803462:	c3                   	ret    

00803463 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803463:	55                   	push   %ebp
  803464:	89 e5                	mov    %esp,%ebp
  803466:	56                   	push   %esi
  803467:	53                   	push   %ebx
  803468:	83 ec 10             	sub    $0x10,%esp
  80346b:	89 c6                	mov    %eax,%esi
  80346d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80346f:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  803476:	75 11                	jne    803489 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803478:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80347f:	e8 bb f9 ff ff       	call   802e3f <ipc_find_env>
  803484:	a3 00 a0 80 00       	mov    %eax,0x80a000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803489:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803490:	00 
  803491:	c7 44 24 08 00 b0 80 	movl   $0x80b000,0x8(%esp)
  803498:	00 
  803499:	89 74 24 04          	mov    %esi,0x4(%esp)
  80349d:	a1 00 a0 80 00       	mov    0x80a000,%eax
  8034a2:	89 04 24             	mov    %eax,(%esp)
  8034a5:	e8 2e f9 ff ff       	call   802dd8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8034aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8034b1:	00 
  8034b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8034b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8034bd:	e8 ae f8 ff ff       	call   802d70 <ipc_recv>
}
  8034c2:	83 c4 10             	add    $0x10,%esp
  8034c5:	5b                   	pop    %ebx
  8034c6:	5e                   	pop    %esi
  8034c7:	5d                   	pop    %ebp
  8034c8:	c3                   	ret    

008034c9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8034c9:	55                   	push   %ebp
  8034ca:	89 e5                	mov    %esp,%ebp
  8034cc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d5:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  8034da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034dd:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8034e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e7:	b8 02 00 00 00       	mov    $0x2,%eax
  8034ec:	e8 72 ff ff ff       	call   803463 <fsipc>
}
  8034f1:	c9                   	leave  
  8034f2:	c3                   	ret    

008034f3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8034f3:	55                   	push   %ebp
  8034f4:	89 e5                	mov    %esp,%ebp
  8034f6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ff:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  803504:	ba 00 00 00 00       	mov    $0x0,%edx
  803509:	b8 06 00 00 00       	mov    $0x6,%eax
  80350e:	e8 50 ff ff ff       	call   803463 <fsipc>
}
  803513:	c9                   	leave  
  803514:	c3                   	ret    

00803515 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803515:	55                   	push   %ebp
  803516:	89 e5                	mov    %esp,%ebp
  803518:	53                   	push   %ebx
  803519:	83 ec 14             	sub    $0x14,%esp
  80351c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	8b 40 0c             	mov    0xc(%eax),%eax
  803525:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80352a:	ba 00 00 00 00       	mov    $0x0,%edx
  80352f:	b8 05 00 00 00       	mov    $0x5,%eax
  803534:	e8 2a ff ff ff       	call   803463 <fsipc>
  803539:	89 c2                	mov    %eax,%edx
  80353b:	85 d2                	test   %edx,%edx
  80353d:	78 2b                	js     80356a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80353f:	c7 44 24 04 00 b0 80 	movl   $0x80b000,0x4(%esp)
  803546:	00 
  803547:	89 1c 24             	mov    %ebx,(%esp)
  80354a:	e8 e8 ef ff ff       	call   802537 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80354f:	a1 80 b0 80 00       	mov    0x80b080,%eax
  803554:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80355a:	a1 84 b0 80 00       	mov    0x80b084,%eax
  80355f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  803565:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80356a:	83 c4 14             	add    $0x14,%esp
  80356d:	5b                   	pop    %ebx
  80356e:	5d                   	pop    %ebp
  80356f:	c3                   	ret    

00803570 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803570:	55                   	push   %ebp
  803571:	89 e5                	mov    %esp,%ebp
  803573:	53                   	push   %ebx
  803574:	83 ec 14             	sub    $0x14,%esp
  803577:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80357a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  803580:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  803585:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803588:	8b 55 08             	mov    0x8(%ebp),%edx
  80358b:	8b 52 0c             	mov    0xc(%edx),%edx
  80358e:	89 15 00 b0 80 00    	mov    %edx,0x80b000
	fsipcbuf.write.req_n = count;
  803594:	a3 04 b0 80 00       	mov    %eax,0x80b004
	memmove(fsipcbuf.write.req_buf, buf, count);
  803599:	89 44 24 08          	mov    %eax,0x8(%esp)
  80359d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035a4:	c7 04 24 08 b0 80 00 	movl   $0x80b008,(%esp)
  8035ab:	e8 24 f1 ff ff       	call   8026d4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  8035b0:	c7 44 24 04 08 b0 80 	movl   $0x80b008,0x4(%esp)
  8035b7:	00 
  8035b8:	c7 04 24 b4 4e 80 00 	movl   $0x804eb4,(%esp)
  8035bf:	e8 fe e8 ff ff       	call   801ec2 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8035c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8035c9:	b8 04 00 00 00       	mov    $0x4,%eax
  8035ce:	e8 90 fe ff ff       	call   803463 <fsipc>
  8035d3:	85 c0                	test   %eax,%eax
  8035d5:	78 53                	js     80362a <devfile_write+0xba>
		return r;
	assert(r <= n);
  8035d7:	39 c3                	cmp    %eax,%ebx
  8035d9:	73 24                	jae    8035ff <devfile_write+0x8f>
  8035db:	c7 44 24 0c b9 4e 80 	movl   $0x804eb9,0xc(%esp)
  8035e2:	00 
  8035e3:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  8035ea:	00 
  8035eb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8035f2:	00 
  8035f3:	c7 04 24 c0 4e 80 00 	movl   $0x804ec0,(%esp)
  8035fa:	e8 ca e7 ff ff       	call   801dc9 <_panic>
	assert(r <= PGSIZE);
  8035ff:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803604:	7e 24                	jle    80362a <devfile_write+0xba>
  803606:	c7 44 24 0c cb 4e 80 	movl   $0x804ecb,0xc(%esp)
  80360d:	00 
  80360e:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  803615:	00 
  803616:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  80361d:	00 
  80361e:	c7 04 24 c0 4e 80 00 	movl   $0x804ec0,(%esp)
  803625:	e8 9f e7 ff ff       	call   801dc9 <_panic>
	return r;
}
  80362a:	83 c4 14             	add    $0x14,%esp
  80362d:	5b                   	pop    %ebx
  80362e:	5d                   	pop    %ebp
  80362f:	c3                   	ret    

00803630 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803630:	55                   	push   %ebp
  803631:	89 e5                	mov    %esp,%ebp
  803633:	56                   	push   %esi
  803634:	53                   	push   %ebx
  803635:	83 ec 10             	sub    $0x10,%esp
  803638:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80363b:	8b 45 08             	mov    0x8(%ebp),%eax
  80363e:	8b 40 0c             	mov    0xc(%eax),%eax
  803641:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  803646:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80364c:	ba 00 00 00 00       	mov    $0x0,%edx
  803651:	b8 03 00 00 00       	mov    $0x3,%eax
  803656:	e8 08 fe ff ff       	call   803463 <fsipc>
  80365b:	89 c3                	mov    %eax,%ebx
  80365d:	85 c0                	test   %eax,%eax
  80365f:	78 6a                	js     8036cb <devfile_read+0x9b>
		return r;
	assert(r <= n);
  803661:	39 c6                	cmp    %eax,%esi
  803663:	73 24                	jae    803689 <devfile_read+0x59>
  803665:	c7 44 24 0c b9 4e 80 	movl   $0x804eb9,0xc(%esp)
  80366c:	00 
  80366d:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  803674:	00 
  803675:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80367c:	00 
  80367d:	c7 04 24 c0 4e 80 00 	movl   $0x804ec0,(%esp)
  803684:	e8 40 e7 ff ff       	call   801dc9 <_panic>
	assert(r <= PGSIZE);
  803689:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80368e:	7e 24                	jle    8036b4 <devfile_read+0x84>
  803690:	c7 44 24 0c cb 4e 80 	movl   $0x804ecb,0xc(%esp)
  803697:	00 
  803698:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  80369f:	00 
  8036a0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8036a7:	00 
  8036a8:	c7 04 24 c0 4e 80 00 	movl   $0x804ec0,(%esp)
  8036af:	e8 15 e7 ff ff       	call   801dc9 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8036b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8036b8:	c7 44 24 04 00 b0 80 	movl   $0x80b000,0x4(%esp)
  8036bf:	00 
  8036c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c3:	89 04 24             	mov    %eax,(%esp)
  8036c6:	e8 09 f0 ff ff       	call   8026d4 <memmove>
	return r;
}
  8036cb:	89 d8                	mov    %ebx,%eax
  8036cd:	83 c4 10             	add    $0x10,%esp
  8036d0:	5b                   	pop    %ebx
  8036d1:	5e                   	pop    %esi
  8036d2:	5d                   	pop    %ebp
  8036d3:	c3                   	ret    

008036d4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8036d4:	55                   	push   %ebp
  8036d5:	89 e5                	mov    %esp,%ebp
  8036d7:	53                   	push   %ebx
  8036d8:	83 ec 24             	sub    $0x24,%esp
  8036db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8036de:	89 1c 24             	mov    %ebx,(%esp)
  8036e1:	e8 1a ee ff ff       	call   802500 <strlen>
  8036e6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8036eb:	7f 60                	jg     80374d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8036ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036f0:	89 04 24             	mov    %eax,(%esp)
  8036f3:	e8 af f7 ff ff       	call   802ea7 <fd_alloc>
  8036f8:	89 c2                	mov    %eax,%edx
  8036fa:	85 d2                	test   %edx,%edx
  8036fc:	78 54                	js     803752 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8036fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803702:	c7 04 24 00 b0 80 00 	movl   $0x80b000,(%esp)
  803709:	e8 29 ee ff ff       	call   802537 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80370e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803711:	a3 00 b4 80 00       	mov    %eax,0x80b400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803716:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803719:	b8 01 00 00 00       	mov    $0x1,%eax
  80371e:	e8 40 fd ff ff       	call   803463 <fsipc>
  803723:	89 c3                	mov    %eax,%ebx
  803725:	85 c0                	test   %eax,%eax
  803727:	79 17                	jns    803740 <open+0x6c>
		fd_close(fd, 0);
  803729:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803730:	00 
  803731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803734:	89 04 24             	mov    %eax,(%esp)
  803737:	e8 6a f8 ff ff       	call   802fa6 <fd_close>
		return r;
  80373c:	89 d8                	mov    %ebx,%eax
  80373e:	eb 12                	jmp    803752 <open+0x7e>
	}

	return fd2num(fd);
  803740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803743:	89 04 24             	mov    %eax,(%esp)
  803746:	e8 35 f7 ff ff       	call   802e80 <fd2num>
  80374b:	eb 05                	jmp    803752 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80374d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  803752:	83 c4 24             	add    $0x24,%esp
  803755:	5b                   	pop    %ebx
  803756:	5d                   	pop    %ebp
  803757:	c3                   	ret    

00803758 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  803758:	55                   	push   %ebp
  803759:	89 e5                	mov    %esp,%ebp
  80375b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80375e:	ba 00 00 00 00       	mov    $0x0,%edx
  803763:	b8 08 00 00 00       	mov    $0x8,%eax
  803768:	e8 f6 fc ff ff       	call   803463 <fsipc>
}
  80376d:	c9                   	leave  
  80376e:	c3                   	ret    

0080376f <evict>:

int evict(void)
{
  80376f:	55                   	push   %ebp
  803770:	89 e5                	mov    %esp,%ebp
  803772:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  803775:	c7 04 24 d7 4e 80 00 	movl   $0x804ed7,(%esp)
  80377c:	e8 41 e7 ff ff       	call   801ec2 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  803781:	ba 00 00 00 00       	mov    $0x0,%edx
  803786:	b8 09 00 00 00       	mov    $0x9,%eax
  80378b:	e8 d3 fc ff ff       	call   803463 <fsipc>
}
  803790:	c9                   	leave  
  803791:	c3                   	ret    

00803792 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803792:	55                   	push   %ebp
  803793:	89 e5                	mov    %esp,%ebp
  803795:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803798:	89 d0                	mov    %edx,%eax
  80379a:	c1 e8 16             	shr    $0x16,%eax
  80379d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8037a4:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8037a9:	f6 c1 01             	test   $0x1,%cl
  8037ac:	74 1d                	je     8037cb <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8037ae:	c1 ea 0c             	shr    $0xc,%edx
  8037b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8037b8:	f6 c2 01             	test   $0x1,%dl
  8037bb:	74 0e                	je     8037cb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8037bd:	c1 ea 0c             	shr    $0xc,%edx
  8037c0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8037c7:	ef 
  8037c8:	0f b7 c0             	movzwl %ax,%eax
}
  8037cb:	5d                   	pop    %ebp
  8037cc:	c3                   	ret    
  8037cd:	66 90                	xchg   %ax,%ax
  8037cf:	90                   	nop

008037d0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8037d0:	55                   	push   %ebp
  8037d1:	89 e5                	mov    %esp,%ebp
  8037d3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8037d6:	c7 44 24 04 f0 4e 80 	movl   $0x804ef0,0x4(%esp)
  8037dd:	00 
  8037de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e1:	89 04 24             	mov    %eax,(%esp)
  8037e4:	e8 4e ed ff ff       	call   802537 <strcpy>
	return 0;
}
  8037e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ee:	c9                   	leave  
  8037ef:	c3                   	ret    

008037f0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8037f0:	55                   	push   %ebp
  8037f1:	89 e5                	mov    %esp,%ebp
  8037f3:	53                   	push   %ebx
  8037f4:	83 ec 14             	sub    $0x14,%esp
  8037f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8037fa:	89 1c 24             	mov    %ebx,(%esp)
  8037fd:	e8 90 ff ff ff       	call   803792 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803802:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803807:	83 f8 01             	cmp    $0x1,%eax
  80380a:	75 0d                	jne    803819 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80380c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80380f:	89 04 24             	mov    %eax,(%esp)
  803812:	e8 29 03 00 00       	call   803b40 <nsipc_close>
  803817:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  803819:	89 d0                	mov    %edx,%eax
  80381b:	83 c4 14             	add    $0x14,%esp
  80381e:	5b                   	pop    %ebx
  80381f:	5d                   	pop    %ebp
  803820:	c3                   	ret    

00803821 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803821:	55                   	push   %ebp
  803822:	89 e5                	mov    %esp,%ebp
  803824:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803827:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80382e:	00 
  80382f:	8b 45 10             	mov    0x10(%ebp),%eax
  803832:	89 44 24 08          	mov    %eax,0x8(%esp)
  803836:	8b 45 0c             	mov    0xc(%ebp),%eax
  803839:	89 44 24 04          	mov    %eax,0x4(%esp)
  80383d:	8b 45 08             	mov    0x8(%ebp),%eax
  803840:	8b 40 0c             	mov    0xc(%eax),%eax
  803843:	89 04 24             	mov    %eax,(%esp)
  803846:	e8 f0 03 00 00       	call   803c3b <nsipc_send>
}
  80384b:	c9                   	leave  
  80384c:	c3                   	ret    

0080384d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80384d:	55                   	push   %ebp
  80384e:	89 e5                	mov    %esp,%ebp
  803850:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803853:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80385a:	00 
  80385b:	8b 45 10             	mov    0x10(%ebp),%eax
  80385e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803862:	8b 45 0c             	mov    0xc(%ebp),%eax
  803865:	89 44 24 04          	mov    %eax,0x4(%esp)
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	8b 40 0c             	mov    0xc(%eax),%eax
  80386f:	89 04 24             	mov    %eax,(%esp)
  803872:	e8 44 03 00 00       	call   803bbb <nsipc_recv>
}
  803877:	c9                   	leave  
  803878:	c3                   	ret    

00803879 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803879:	55                   	push   %ebp
  80387a:	89 e5                	mov    %esp,%ebp
  80387c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80387f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803882:	89 54 24 04          	mov    %edx,0x4(%esp)
  803886:	89 04 24             	mov    %eax,(%esp)
  803889:	e8 68 f6 ff ff       	call   802ef6 <fd_lookup>
  80388e:	85 c0                	test   %eax,%eax
  803890:	78 17                	js     8038a9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803895:	8b 0d 80 90 80 00    	mov    0x809080,%ecx
  80389b:	39 08                	cmp    %ecx,(%eax)
  80389d:	75 05                	jne    8038a4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80389f:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a2:	eb 05                	jmp    8038a9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8038a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8038a9:	c9                   	leave  
  8038aa:	c3                   	ret    

008038ab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8038ab:	55                   	push   %ebp
  8038ac:	89 e5                	mov    %esp,%ebp
  8038ae:	56                   	push   %esi
  8038af:	53                   	push   %ebx
  8038b0:	83 ec 20             	sub    $0x20,%esp
  8038b3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8038b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8038b8:	89 04 24             	mov    %eax,(%esp)
  8038bb:	e8 e7 f5 ff ff       	call   802ea7 <fd_alloc>
  8038c0:	89 c3                	mov    %eax,%ebx
  8038c2:	85 c0                	test   %eax,%eax
  8038c4:	78 21                	js     8038e7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8038c6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8038cd:	00 
  8038ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038dc:	e8 c4 f0 ff ff       	call   8029a5 <sys_page_alloc>
  8038e1:	89 c3                	mov    %eax,%ebx
  8038e3:	85 c0                	test   %eax,%eax
  8038e5:	79 0c                	jns    8038f3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8038e7:	89 34 24             	mov    %esi,(%esp)
  8038ea:	e8 51 02 00 00       	call   803b40 <nsipc_close>
		return r;
  8038ef:	89 d8                	mov    %ebx,%eax
  8038f1:	eb 20                	jmp    803913 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8038f3:	8b 15 80 90 80 00    	mov    0x809080,%edx
  8038f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8038fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803901:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  803908:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80390b:	89 14 24             	mov    %edx,(%esp)
  80390e:	e8 6d f5 ff ff       	call   802e80 <fd2num>
}
  803913:	83 c4 20             	add    $0x20,%esp
  803916:	5b                   	pop    %ebx
  803917:	5e                   	pop    %esi
  803918:	5d                   	pop    %ebp
  803919:	c3                   	ret    

0080391a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80391a:	55                   	push   %ebp
  80391b:	89 e5                	mov    %esp,%ebp
  80391d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803920:	8b 45 08             	mov    0x8(%ebp),%eax
  803923:	e8 51 ff ff ff       	call   803879 <fd2sockid>
		return r;
  803928:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80392a:	85 c0                	test   %eax,%eax
  80392c:	78 23                	js     803951 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80392e:	8b 55 10             	mov    0x10(%ebp),%edx
  803931:	89 54 24 08          	mov    %edx,0x8(%esp)
  803935:	8b 55 0c             	mov    0xc(%ebp),%edx
  803938:	89 54 24 04          	mov    %edx,0x4(%esp)
  80393c:	89 04 24             	mov    %eax,(%esp)
  80393f:	e8 45 01 00 00       	call   803a89 <nsipc_accept>
		return r;
  803944:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803946:	85 c0                	test   %eax,%eax
  803948:	78 07                	js     803951 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80394a:	e8 5c ff ff ff       	call   8038ab <alloc_sockfd>
  80394f:	89 c1                	mov    %eax,%ecx
}
  803951:	89 c8                	mov    %ecx,%eax
  803953:	c9                   	leave  
  803954:	c3                   	ret    

00803955 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803955:	55                   	push   %ebp
  803956:	89 e5                	mov    %esp,%ebp
  803958:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80395b:	8b 45 08             	mov    0x8(%ebp),%eax
  80395e:	e8 16 ff ff ff       	call   803879 <fd2sockid>
  803963:	89 c2                	mov    %eax,%edx
  803965:	85 d2                	test   %edx,%edx
  803967:	78 16                	js     80397f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  803969:	8b 45 10             	mov    0x10(%ebp),%eax
  80396c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803970:	8b 45 0c             	mov    0xc(%ebp),%eax
  803973:	89 44 24 04          	mov    %eax,0x4(%esp)
  803977:	89 14 24             	mov    %edx,(%esp)
  80397a:	e8 60 01 00 00       	call   803adf <nsipc_bind>
}
  80397f:	c9                   	leave  
  803980:	c3                   	ret    

00803981 <shutdown>:

int
shutdown(int s, int how)
{
  803981:	55                   	push   %ebp
  803982:	89 e5                	mov    %esp,%ebp
  803984:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803987:	8b 45 08             	mov    0x8(%ebp),%eax
  80398a:	e8 ea fe ff ff       	call   803879 <fd2sockid>
  80398f:	89 c2                	mov    %eax,%edx
  803991:	85 d2                	test   %edx,%edx
  803993:	78 0f                	js     8039a4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  803995:	8b 45 0c             	mov    0xc(%ebp),%eax
  803998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80399c:	89 14 24             	mov    %edx,(%esp)
  80399f:	e8 7a 01 00 00       	call   803b1e <nsipc_shutdown>
}
  8039a4:	c9                   	leave  
  8039a5:	c3                   	ret    

008039a6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8039a6:	55                   	push   %ebp
  8039a7:	89 e5                	mov    %esp,%ebp
  8039a9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8039af:	e8 c5 fe ff ff       	call   803879 <fd2sockid>
  8039b4:	89 c2                	mov    %eax,%edx
  8039b6:	85 d2                	test   %edx,%edx
  8039b8:	78 16                	js     8039d0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8039ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8039bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8039c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039c8:	89 14 24             	mov    %edx,(%esp)
  8039cb:	e8 8a 01 00 00       	call   803b5a <nsipc_connect>
}
  8039d0:	c9                   	leave  
  8039d1:	c3                   	ret    

008039d2 <listen>:

int
listen(int s, int backlog)
{
  8039d2:	55                   	push   %ebp
  8039d3:	89 e5                	mov    %esp,%ebp
  8039d5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039db:	e8 99 fe ff ff       	call   803879 <fd2sockid>
  8039e0:	89 c2                	mov    %eax,%edx
  8039e2:	85 d2                	test   %edx,%edx
  8039e4:	78 0f                	js     8039f5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8039e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039ed:	89 14 24             	mov    %edx,(%esp)
  8039f0:	e8 a4 01 00 00       	call   803b99 <nsipc_listen>
}
  8039f5:	c9                   	leave  
  8039f6:	c3                   	ret    

008039f7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8039f7:	55                   	push   %ebp
  8039f8:	89 e5                	mov    %esp,%ebp
  8039fa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8039fd:	8b 45 10             	mov    0x10(%ebp),%eax
  803a00:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0e:	89 04 24             	mov    %eax,(%esp)
  803a11:	e8 98 02 00 00       	call   803cae <nsipc_socket>
  803a16:	89 c2                	mov    %eax,%edx
  803a18:	85 d2                	test   %edx,%edx
  803a1a:	78 05                	js     803a21 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  803a1c:	e8 8a fe ff ff       	call   8038ab <alloc_sockfd>
}
  803a21:	c9                   	leave  
  803a22:	c3                   	ret    

00803a23 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a23:	55                   	push   %ebp
  803a24:	89 e5                	mov    %esp,%ebp
  803a26:	53                   	push   %ebx
  803a27:	83 ec 14             	sub    $0x14,%esp
  803a2a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  803a2c:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  803a33:	75 11                	jne    803a46 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803a35:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  803a3c:	e8 fe f3 ff ff       	call   802e3f <ipc_find_env>
  803a41:	a3 04 a0 80 00       	mov    %eax,0x80a004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a46:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803a4d:	00 
  803a4e:	c7 44 24 08 00 c0 80 	movl   $0x80c000,0x8(%esp)
  803a55:	00 
  803a56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803a5a:	a1 04 a0 80 00       	mov    0x80a004,%eax
  803a5f:	89 04 24             	mov    %eax,(%esp)
  803a62:	e8 71 f3 ff ff       	call   802dd8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803a67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803a6e:	00 
  803a6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803a76:	00 
  803a77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a7e:	e8 ed f2 ff ff       	call   802d70 <ipc_recv>
}
  803a83:	83 c4 14             	add    $0x14,%esp
  803a86:	5b                   	pop    %ebx
  803a87:	5d                   	pop    %ebp
  803a88:	c3                   	ret    

00803a89 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a89:	55                   	push   %ebp
  803a8a:	89 e5                	mov    %esp,%ebp
  803a8c:	56                   	push   %esi
  803a8d:	53                   	push   %ebx
  803a8e:	83 ec 10             	sub    $0x10,%esp
  803a91:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803a94:	8b 45 08             	mov    0x8(%ebp),%eax
  803a97:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  803a9c:	8b 06                	mov    (%esi),%eax
  803a9e:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803aa3:	b8 01 00 00 00       	mov    $0x1,%eax
  803aa8:	e8 76 ff ff ff       	call   803a23 <nsipc>
  803aad:	89 c3                	mov    %eax,%ebx
  803aaf:	85 c0                	test   %eax,%eax
  803ab1:	78 23                	js     803ad6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803ab3:	a1 10 c0 80 00       	mov    0x80c010,%eax
  803ab8:	89 44 24 08          	mov    %eax,0x8(%esp)
  803abc:	c7 44 24 04 00 c0 80 	movl   $0x80c000,0x4(%esp)
  803ac3:	00 
  803ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ac7:	89 04 24             	mov    %eax,(%esp)
  803aca:	e8 05 ec ff ff       	call   8026d4 <memmove>
		*addrlen = ret->ret_addrlen;
  803acf:	a1 10 c0 80 00       	mov    0x80c010,%eax
  803ad4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  803ad6:	89 d8                	mov    %ebx,%eax
  803ad8:	83 c4 10             	add    $0x10,%esp
  803adb:	5b                   	pop    %ebx
  803adc:	5e                   	pop    %esi
  803add:	5d                   	pop    %ebp
  803ade:	c3                   	ret    

00803adf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803adf:	55                   	push   %ebp
  803ae0:	89 e5                	mov    %esp,%ebp
  803ae2:	53                   	push   %ebx
  803ae3:	83 ec 14             	sub    $0x14,%esp
  803ae6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aec:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803af1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803afc:	c7 04 24 04 c0 80 00 	movl   $0x80c004,(%esp)
  803b03:	e8 cc eb ff ff       	call   8026d4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803b08:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  803b0e:	b8 02 00 00 00       	mov    $0x2,%eax
  803b13:	e8 0b ff ff ff       	call   803a23 <nsipc>
}
  803b18:	83 c4 14             	add    $0x14,%esp
  803b1b:	5b                   	pop    %ebx
  803b1c:	5d                   	pop    %ebp
  803b1d:	c3                   	ret    

00803b1e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803b1e:	55                   	push   %ebp
  803b1f:	89 e5                	mov    %esp,%ebp
  803b21:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803b24:	8b 45 08             	mov    0x8(%ebp),%eax
  803b27:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  803b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b2f:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  803b34:	b8 03 00 00 00       	mov    $0x3,%eax
  803b39:	e8 e5 fe ff ff       	call   803a23 <nsipc>
}
  803b3e:	c9                   	leave  
  803b3f:	c3                   	ret    

00803b40 <nsipc_close>:

int
nsipc_close(int s)
{
  803b40:	55                   	push   %ebp
  803b41:	89 e5                	mov    %esp,%ebp
  803b43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803b46:	8b 45 08             	mov    0x8(%ebp),%eax
  803b49:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  803b4e:	b8 04 00 00 00       	mov    $0x4,%eax
  803b53:	e8 cb fe ff ff       	call   803a23 <nsipc>
}
  803b58:	c9                   	leave  
  803b59:	c3                   	ret    

00803b5a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b5a:	55                   	push   %ebp
  803b5b:	89 e5                	mov    %esp,%ebp
  803b5d:	53                   	push   %ebx
  803b5e:	83 ec 14             	sub    $0x14,%esp
  803b61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803b64:	8b 45 08             	mov    0x8(%ebp),%eax
  803b67:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803b6c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b73:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b77:	c7 04 24 04 c0 80 00 	movl   $0x80c004,(%esp)
  803b7e:	e8 51 eb ff ff       	call   8026d4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803b83:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  803b89:	b8 05 00 00 00       	mov    $0x5,%eax
  803b8e:	e8 90 fe ff ff       	call   803a23 <nsipc>
}
  803b93:	83 c4 14             	add    $0x14,%esp
  803b96:	5b                   	pop    %ebx
  803b97:	5d                   	pop    %ebp
  803b98:	c3                   	ret    

00803b99 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803b99:	55                   	push   %ebp
  803b9a:	89 e5                	mov    %esp,%ebp
  803b9c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba2:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  803ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803baa:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  803baf:	b8 06 00 00 00       	mov    $0x6,%eax
  803bb4:	e8 6a fe ff ff       	call   803a23 <nsipc>
}
  803bb9:	c9                   	leave  
  803bba:	c3                   	ret    

00803bbb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803bbb:	55                   	push   %ebp
  803bbc:	89 e5                	mov    %esp,%ebp
  803bbe:	56                   	push   %esi
  803bbf:	53                   	push   %ebx
  803bc0:	83 ec 10             	sub    $0x10,%esp
  803bc3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc9:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  803bce:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  803bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  803bd7:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803bdc:	b8 07 00 00 00       	mov    $0x7,%eax
  803be1:	e8 3d fe ff ff       	call   803a23 <nsipc>
  803be6:	89 c3                	mov    %eax,%ebx
  803be8:	85 c0                	test   %eax,%eax
  803bea:	78 46                	js     803c32 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  803bec:	39 f0                	cmp    %esi,%eax
  803bee:	7f 07                	jg     803bf7 <nsipc_recv+0x3c>
  803bf0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803bf5:	7e 24                	jle    803c1b <nsipc_recv+0x60>
  803bf7:	c7 44 24 0c fc 4e 80 	movl   $0x804efc,0xc(%esp)
  803bfe:	00 
  803bff:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  803c06:	00 
  803c07:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  803c0e:	00 
  803c0f:	c7 04 24 11 4f 80 00 	movl   $0x804f11,(%esp)
  803c16:	e8 ae e1 ff ff       	call   801dc9 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803c1b:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c1f:	c7 44 24 04 00 c0 80 	movl   $0x80c000,0x4(%esp)
  803c26:	00 
  803c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c2a:	89 04 24             	mov    %eax,(%esp)
  803c2d:	e8 a2 ea ff ff       	call   8026d4 <memmove>
	}

	return r;
}
  803c32:	89 d8                	mov    %ebx,%eax
  803c34:	83 c4 10             	add    $0x10,%esp
  803c37:	5b                   	pop    %ebx
  803c38:	5e                   	pop    %esi
  803c39:	5d                   	pop    %ebp
  803c3a:	c3                   	ret    

00803c3b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803c3b:	55                   	push   %ebp
  803c3c:	89 e5                	mov    %esp,%ebp
  803c3e:	53                   	push   %ebx
  803c3f:	83 ec 14             	sub    $0x14,%esp
  803c42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803c45:	8b 45 08             	mov    0x8(%ebp),%eax
  803c48:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  803c4d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803c53:	7e 24                	jle    803c79 <nsipc_send+0x3e>
  803c55:	c7 44 24 0c 1d 4f 80 	movl   $0x804f1d,0xc(%esp)
  803c5c:	00 
  803c5d:	c7 44 24 08 dd 44 80 	movl   $0x8044dd,0x8(%esp)
  803c64:	00 
  803c65:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  803c6c:	00 
  803c6d:	c7 04 24 11 4f 80 00 	movl   $0x804f11,(%esp)
  803c74:	e8 50 e1 ff ff       	call   801dc9 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c79:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c80:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c84:	c7 04 24 0c c0 80 00 	movl   $0x80c00c,(%esp)
  803c8b:	e8 44 ea ff ff       	call   8026d4 <memmove>
	nsipcbuf.send.req_size = size;
  803c90:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  803c96:	8b 45 14             	mov    0x14(%ebp),%eax
  803c99:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  803c9e:	b8 08 00 00 00       	mov    $0x8,%eax
  803ca3:	e8 7b fd ff ff       	call   803a23 <nsipc>
}
  803ca8:	83 c4 14             	add    $0x14,%esp
  803cab:	5b                   	pop    %ebx
  803cac:	5d                   	pop    %ebp
  803cad:	c3                   	ret    

00803cae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803cae:	55                   	push   %ebp
  803caf:	89 e5                	mov    %esp,%ebp
  803cb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb7:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  803cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cbf:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  803cc4:	8b 45 10             	mov    0x10(%ebp),%eax
  803cc7:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  803ccc:	b8 09 00 00 00       	mov    $0x9,%eax
  803cd1:	e8 4d fd ff ff       	call   803a23 <nsipc>
}
  803cd6:	c9                   	leave  
  803cd7:	c3                   	ret    

00803cd8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803cd8:	55                   	push   %ebp
  803cd9:	89 e5                	mov    %esp,%ebp
  803cdb:	56                   	push   %esi
  803cdc:	53                   	push   %ebx
  803cdd:	83 ec 10             	sub    $0x10,%esp
  803ce0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce6:	89 04 24             	mov    %eax,(%esp)
  803ce9:	e8 a2 f1 ff ff       	call   802e90 <fd2data>
  803cee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803cf0:	c7 44 24 04 29 4f 80 	movl   $0x804f29,0x4(%esp)
  803cf7:	00 
  803cf8:	89 1c 24             	mov    %ebx,(%esp)
  803cfb:	e8 37 e8 ff ff       	call   802537 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803d00:	8b 46 04             	mov    0x4(%esi),%eax
  803d03:	2b 06                	sub    (%esi),%eax
  803d05:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803d0b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803d12:	00 00 00 
	stat->st_dev = &devpipe;
  803d15:	c7 83 88 00 00 00 9c 	movl   $0x80909c,0x88(%ebx)
  803d1c:	90 80 00 
	return 0;
}
  803d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d24:	83 c4 10             	add    $0x10,%esp
  803d27:	5b                   	pop    %ebx
  803d28:	5e                   	pop    %esi
  803d29:	5d                   	pop    %ebp
  803d2a:	c3                   	ret    

00803d2b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d2b:	55                   	push   %ebp
  803d2c:	89 e5                	mov    %esp,%ebp
  803d2e:	53                   	push   %ebx
  803d2f:	83 ec 14             	sub    $0x14,%esp
  803d32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803d35:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803d39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d40:	e8 07 ed ff ff       	call   802a4c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803d45:	89 1c 24             	mov    %ebx,(%esp)
  803d48:	e8 43 f1 ff ff       	call   802e90 <fd2data>
  803d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d58:	e8 ef ec ff ff       	call   802a4c <sys_page_unmap>
}
  803d5d:	83 c4 14             	add    $0x14,%esp
  803d60:	5b                   	pop    %ebx
  803d61:	5d                   	pop    %ebp
  803d62:	c3                   	ret    

00803d63 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803d63:	55                   	push   %ebp
  803d64:	89 e5                	mov    %esp,%ebp
  803d66:	57                   	push   %edi
  803d67:	56                   	push   %esi
  803d68:	53                   	push   %ebx
  803d69:	83 ec 2c             	sub    $0x2c,%esp
  803d6c:	89 c6                	mov    %eax,%esi
  803d6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803d71:	a1 10 a0 80 00       	mov    0x80a010,%eax
  803d76:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803d79:	89 34 24             	mov    %esi,(%esp)
  803d7c:	e8 11 fa ff ff       	call   803792 <pageref>
  803d81:	89 c7                	mov    %eax,%edi
  803d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d86:	89 04 24             	mov    %eax,(%esp)
  803d89:	e8 04 fa ff ff       	call   803792 <pageref>
  803d8e:	39 c7                	cmp    %eax,%edi
  803d90:	0f 94 c2             	sete   %dl
  803d93:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  803d96:	8b 0d 10 a0 80 00    	mov    0x80a010,%ecx
  803d9c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  803d9f:	39 fb                	cmp    %edi,%ebx
  803da1:	74 21                	je     803dc4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  803da3:	84 d2                	test   %dl,%dl
  803da5:	74 ca                	je     803d71 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803da7:	8b 51 58             	mov    0x58(%ecx),%edx
  803daa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dae:	89 54 24 08          	mov    %edx,0x8(%esp)
  803db2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803db6:	c7 04 24 30 4f 80 00 	movl   $0x804f30,(%esp)
  803dbd:	e8 00 e1 ff ff       	call   801ec2 <cprintf>
  803dc2:	eb ad                	jmp    803d71 <_pipeisclosed+0xe>
	}
}
  803dc4:	83 c4 2c             	add    $0x2c,%esp
  803dc7:	5b                   	pop    %ebx
  803dc8:	5e                   	pop    %esi
  803dc9:	5f                   	pop    %edi
  803dca:	5d                   	pop    %ebp
  803dcb:	c3                   	ret    

00803dcc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803dcc:	55                   	push   %ebp
  803dcd:	89 e5                	mov    %esp,%ebp
  803dcf:	57                   	push   %edi
  803dd0:	56                   	push   %esi
  803dd1:	53                   	push   %ebx
  803dd2:	83 ec 1c             	sub    $0x1c,%esp
  803dd5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803dd8:	89 34 24             	mov    %esi,(%esp)
  803ddb:	e8 b0 f0 ff ff       	call   802e90 <fd2data>
  803de0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803de2:	bf 00 00 00 00       	mov    $0x0,%edi
  803de7:	eb 45                	jmp    803e2e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803de9:	89 da                	mov    %ebx,%edx
  803deb:	89 f0                	mov    %esi,%eax
  803ded:	e8 71 ff ff ff       	call   803d63 <_pipeisclosed>
  803df2:	85 c0                	test   %eax,%eax
  803df4:	75 41                	jne    803e37 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803df6:	e8 8b eb ff ff       	call   802986 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803dfb:	8b 43 04             	mov    0x4(%ebx),%eax
  803dfe:	8b 0b                	mov    (%ebx),%ecx
  803e00:	8d 51 20             	lea    0x20(%ecx),%edx
  803e03:	39 d0                	cmp    %edx,%eax
  803e05:	73 e2                	jae    803de9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803e0a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803e0e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803e11:	99                   	cltd   
  803e12:	c1 ea 1b             	shr    $0x1b,%edx
  803e15:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  803e18:	83 e1 1f             	and    $0x1f,%ecx
  803e1b:	29 d1                	sub    %edx,%ecx
  803e1d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  803e21:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  803e25:	83 c0 01             	add    $0x1,%eax
  803e28:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e2b:	83 c7 01             	add    $0x1,%edi
  803e2e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803e31:	75 c8                	jne    803dfb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803e33:	89 f8                	mov    %edi,%eax
  803e35:	eb 05                	jmp    803e3c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803e37:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  803e3c:	83 c4 1c             	add    $0x1c,%esp
  803e3f:	5b                   	pop    %ebx
  803e40:	5e                   	pop    %esi
  803e41:	5f                   	pop    %edi
  803e42:	5d                   	pop    %ebp
  803e43:	c3                   	ret    

00803e44 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e44:	55                   	push   %ebp
  803e45:	89 e5                	mov    %esp,%ebp
  803e47:	57                   	push   %edi
  803e48:	56                   	push   %esi
  803e49:	53                   	push   %ebx
  803e4a:	83 ec 1c             	sub    $0x1c,%esp
  803e4d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803e50:	89 3c 24             	mov    %edi,(%esp)
  803e53:	e8 38 f0 ff ff       	call   802e90 <fd2data>
  803e58:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e5a:	be 00 00 00 00       	mov    $0x0,%esi
  803e5f:	eb 3d                	jmp    803e9e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803e61:	85 f6                	test   %esi,%esi
  803e63:	74 04                	je     803e69 <devpipe_read+0x25>
				return i;
  803e65:	89 f0                	mov    %esi,%eax
  803e67:	eb 43                	jmp    803eac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803e69:	89 da                	mov    %ebx,%edx
  803e6b:	89 f8                	mov    %edi,%eax
  803e6d:	e8 f1 fe ff ff       	call   803d63 <_pipeisclosed>
  803e72:	85 c0                	test   %eax,%eax
  803e74:	75 31                	jne    803ea7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803e76:	e8 0b eb ff ff       	call   802986 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803e7b:	8b 03                	mov    (%ebx),%eax
  803e7d:	3b 43 04             	cmp    0x4(%ebx),%eax
  803e80:	74 df                	je     803e61 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e82:	99                   	cltd   
  803e83:	c1 ea 1b             	shr    $0x1b,%edx
  803e86:	01 d0                	add    %edx,%eax
  803e88:	83 e0 1f             	and    $0x1f,%eax
  803e8b:	29 d0                	sub    %edx,%eax
  803e8d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803e92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803e95:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803e98:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e9b:	83 c6 01             	add    $0x1,%esi
  803e9e:	3b 75 10             	cmp    0x10(%ebp),%esi
  803ea1:	75 d8                	jne    803e7b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803ea3:	89 f0                	mov    %esi,%eax
  803ea5:	eb 05                	jmp    803eac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803ea7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  803eac:	83 c4 1c             	add    $0x1c,%esp
  803eaf:	5b                   	pop    %ebx
  803eb0:	5e                   	pop    %esi
  803eb1:	5f                   	pop    %edi
  803eb2:	5d                   	pop    %ebp
  803eb3:	c3                   	ret    

00803eb4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803eb4:	55                   	push   %ebp
  803eb5:	89 e5                	mov    %esp,%ebp
  803eb7:	56                   	push   %esi
  803eb8:	53                   	push   %ebx
  803eb9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803ebc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ebf:	89 04 24             	mov    %eax,(%esp)
  803ec2:	e8 e0 ef ff ff       	call   802ea7 <fd_alloc>
  803ec7:	89 c2                	mov    %eax,%edx
  803ec9:	85 d2                	test   %edx,%edx
  803ecb:	0f 88 4d 01 00 00    	js     80401e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ed1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803ed8:	00 
  803ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803edc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ee0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ee7:	e8 b9 ea ff ff       	call   8029a5 <sys_page_alloc>
  803eec:	89 c2                	mov    %eax,%edx
  803eee:	85 d2                	test   %edx,%edx
  803ef0:	0f 88 28 01 00 00    	js     80401e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803ef6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803ef9:	89 04 24             	mov    %eax,(%esp)
  803efc:	e8 a6 ef ff ff       	call   802ea7 <fd_alloc>
  803f01:	89 c3                	mov    %eax,%ebx
  803f03:	85 c0                	test   %eax,%eax
  803f05:	0f 88 fe 00 00 00    	js     804009 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f0b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803f12:	00 
  803f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f16:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f21:	e8 7f ea ff ff       	call   8029a5 <sys_page_alloc>
  803f26:	89 c3                	mov    %eax,%ebx
  803f28:	85 c0                	test   %eax,%eax
  803f2a:	0f 88 d9 00 00 00    	js     804009 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f33:	89 04 24             	mov    %eax,(%esp)
  803f36:	e8 55 ef ff ff       	call   802e90 <fd2data>
  803f3b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f3d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803f44:	00 
  803f45:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f50:	e8 50 ea ff ff       	call   8029a5 <sys_page_alloc>
  803f55:	89 c3                	mov    %eax,%ebx
  803f57:	85 c0                	test   %eax,%eax
  803f59:	0f 88 97 00 00 00    	js     803ff6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f62:	89 04 24             	mov    %eax,(%esp)
  803f65:	e8 26 ef ff ff       	call   802e90 <fd2data>
  803f6a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803f71:	00 
  803f72:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f76:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803f7d:	00 
  803f7e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803f82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f89:	e8 6b ea ff ff       	call   8029f9 <sys_page_map>
  803f8e:	89 c3                	mov    %eax,%ebx
  803f90:	85 c0                	test   %eax,%eax
  803f92:	78 52                	js     803fe6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f94:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803fa9:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc1:	89 04 24             	mov    %eax,(%esp)
  803fc4:	e8 b7 ee ff ff       	call   802e80 <fd2num>
  803fc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803fcc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fd1:	89 04 24             	mov    %eax,(%esp)
  803fd4:	e8 a7 ee ff ff       	call   802e80 <fd2num>
  803fd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803fdc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe4:	eb 38                	jmp    80401e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  803fe6:	89 74 24 04          	mov    %esi,0x4(%esp)
  803fea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ff1:	e8 56 ea ff ff       	call   802a4c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ffd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804004:	e8 43 ea ff ff       	call   802a4c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  804009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80400c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804010:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804017:	e8 30 ea ff ff       	call   802a4c <sys_page_unmap>
  80401c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80401e:	83 c4 30             	add    $0x30,%esp
  804021:	5b                   	pop    %ebx
  804022:	5e                   	pop    %esi
  804023:	5d                   	pop    %ebp
  804024:	c3                   	ret    

00804025 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  804025:	55                   	push   %ebp
  804026:	89 e5                	mov    %esp,%ebp
  804028:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80402b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80402e:	89 44 24 04          	mov    %eax,0x4(%esp)
  804032:	8b 45 08             	mov    0x8(%ebp),%eax
  804035:	89 04 24             	mov    %eax,(%esp)
  804038:	e8 b9 ee ff ff       	call   802ef6 <fd_lookup>
  80403d:	89 c2                	mov    %eax,%edx
  80403f:	85 d2                	test   %edx,%edx
  804041:	78 15                	js     804058 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  804043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804046:	89 04 24             	mov    %eax,(%esp)
  804049:	e8 42 ee ff ff       	call   802e90 <fd2data>
	return _pipeisclosed(fd, p);
  80404e:	89 c2                	mov    %eax,%edx
  804050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804053:	e8 0b fd ff ff       	call   803d63 <_pipeisclosed>
}
  804058:	c9                   	leave  
  804059:	c3                   	ret    
  80405a:	66 90                	xchg   %ax,%ax
  80405c:	66 90                	xchg   %ax,%ax
  80405e:	66 90                	xchg   %ax,%ax

00804060 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  804060:	55                   	push   %ebp
  804061:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  804063:	b8 00 00 00 00       	mov    $0x0,%eax
  804068:	5d                   	pop    %ebp
  804069:	c3                   	ret    

0080406a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80406a:	55                   	push   %ebp
  80406b:	89 e5                	mov    %esp,%ebp
  80406d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  804070:	c7 44 24 04 48 4f 80 	movl   $0x804f48,0x4(%esp)
  804077:	00 
  804078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80407b:	89 04 24             	mov    %eax,(%esp)
  80407e:	e8 b4 e4 ff ff       	call   802537 <strcpy>
	return 0;
}
  804083:	b8 00 00 00 00       	mov    $0x0,%eax
  804088:	c9                   	leave  
  804089:	c3                   	ret    

0080408a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80408a:	55                   	push   %ebp
  80408b:	89 e5                	mov    %esp,%ebp
  80408d:	57                   	push   %edi
  80408e:	56                   	push   %esi
  80408f:	53                   	push   %ebx
  804090:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804096:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80409b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040a1:	eb 31                	jmp    8040d4 <devcons_write+0x4a>
		m = n - tot;
  8040a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8040a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8040a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8040ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8040b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8040b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8040b7:	03 45 0c             	add    0xc(%ebp),%eax
  8040ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040be:	89 3c 24             	mov    %edi,(%esp)
  8040c1:	e8 0e e6 ff ff       	call   8026d4 <memmove>
		sys_cputs(buf, m);
  8040c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8040ca:	89 3c 24             	mov    %edi,(%esp)
  8040cd:	e8 b4 e7 ff ff       	call   802886 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040d2:	01 f3                	add    %esi,%ebx
  8040d4:	89 d8                	mov    %ebx,%eax
  8040d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8040d9:	72 c8                	jb     8040a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8040db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8040e1:	5b                   	pop    %ebx
  8040e2:	5e                   	pop    %esi
  8040e3:	5f                   	pop    %edi
  8040e4:	5d                   	pop    %ebp
  8040e5:	c3                   	ret    

008040e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040e6:	55                   	push   %ebp
  8040e7:	89 e5                	mov    %esp,%ebp
  8040e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8040ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8040f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8040f5:	75 07                	jne    8040fe <devcons_read+0x18>
  8040f7:	eb 2a                	jmp    804123 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8040f9:	e8 88 e8 ff ff       	call   802986 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8040fe:	66 90                	xchg   %ax,%ax
  804100:	e8 9f e7 ff ff       	call   8028a4 <sys_cgetc>
  804105:	85 c0                	test   %eax,%eax
  804107:	74 f0                	je     8040f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  804109:	85 c0                	test   %eax,%eax
  80410b:	78 16                	js     804123 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80410d:	83 f8 04             	cmp    $0x4,%eax
  804110:	74 0c                	je     80411e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  804112:	8b 55 0c             	mov    0xc(%ebp),%edx
  804115:	88 02                	mov    %al,(%edx)
	return 1;
  804117:	b8 01 00 00 00       	mov    $0x1,%eax
  80411c:	eb 05                	jmp    804123 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80411e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  804123:	c9                   	leave  
  804124:	c3                   	ret    

00804125 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804125:	55                   	push   %ebp
  804126:	89 e5                	mov    %esp,%ebp
  804128:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80412b:	8b 45 08             	mov    0x8(%ebp),%eax
  80412e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804131:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  804138:	00 
  804139:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80413c:	89 04 24             	mov    %eax,(%esp)
  80413f:	e8 42 e7 ff ff       	call   802886 <sys_cputs>
}
  804144:	c9                   	leave  
  804145:	c3                   	ret    

00804146 <getchar>:

int
getchar(void)
{
  804146:	55                   	push   %ebp
  804147:	89 e5                	mov    %esp,%ebp
  804149:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80414c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804153:	00 
  804154:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804157:	89 44 24 04          	mov    %eax,0x4(%esp)
  80415b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804162:	e8 23 f0 ff ff       	call   80318a <read>
	if (r < 0)
  804167:	85 c0                	test   %eax,%eax
  804169:	78 0f                	js     80417a <getchar+0x34>
		return r;
	if (r < 1)
  80416b:	85 c0                	test   %eax,%eax
  80416d:	7e 06                	jle    804175 <getchar+0x2f>
		return -E_EOF;
	return c;
  80416f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  804173:	eb 05                	jmp    80417a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  804175:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80417a:	c9                   	leave  
  80417b:	c3                   	ret    

0080417c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80417c:	55                   	push   %ebp
  80417d:	89 e5                	mov    %esp,%ebp
  80417f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804182:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804185:	89 44 24 04          	mov    %eax,0x4(%esp)
  804189:	8b 45 08             	mov    0x8(%ebp),%eax
  80418c:	89 04 24             	mov    %eax,(%esp)
  80418f:	e8 62 ed ff ff       	call   802ef6 <fd_lookup>
  804194:	85 c0                	test   %eax,%eax
  804196:	78 11                	js     8041a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  804198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80419b:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  8041a1:	39 10                	cmp    %edx,(%eax)
  8041a3:	0f 94 c0             	sete   %al
  8041a6:	0f b6 c0             	movzbl %al,%eax
}
  8041a9:	c9                   	leave  
  8041aa:	c3                   	ret    

008041ab <opencons>:

int
opencons(void)
{
  8041ab:	55                   	push   %ebp
  8041ac:	89 e5                	mov    %esp,%ebp
  8041ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8041b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8041b4:	89 04 24             	mov    %eax,(%esp)
  8041b7:	e8 eb ec ff ff       	call   802ea7 <fd_alloc>
		return r;
  8041bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8041be:	85 c0                	test   %eax,%eax
  8041c0:	78 40                	js     804202 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8041c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8041c9:	00 
  8041ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8041d8:	e8 c8 e7 ff ff       	call   8029a5 <sys_page_alloc>
		return r;
  8041dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8041df:	85 c0                	test   %eax,%eax
  8041e1:	78 1f                	js     804202 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8041e3:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  8041e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8041ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8041f8:	89 04 24             	mov    %eax,(%esp)
  8041fb:	e8 80 ec ff ff       	call   802e80 <fd2num>
  804200:	89 c2                	mov    %eax,%edx
}
  804202:	89 d0                	mov    %edx,%eax
  804204:	c9                   	leave  
  804205:	c3                   	ret    
  804206:	66 90                	xchg   %ax,%ax
  804208:	66 90                	xchg   %ax,%ax
  80420a:	66 90                	xchg   %ax,%ax
  80420c:	66 90                	xchg   %ax,%ax
  80420e:	66 90                	xchg   %ax,%ax

00804210 <__udivdi3>:
  804210:	55                   	push   %ebp
  804211:	57                   	push   %edi
  804212:	56                   	push   %esi
  804213:	83 ec 0c             	sub    $0xc,%esp
  804216:	8b 44 24 28          	mov    0x28(%esp),%eax
  80421a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80421e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  804222:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  804226:	85 c0                	test   %eax,%eax
  804228:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80422c:	89 ea                	mov    %ebp,%edx
  80422e:	89 0c 24             	mov    %ecx,(%esp)
  804231:	75 2d                	jne    804260 <__udivdi3+0x50>
  804233:	39 e9                	cmp    %ebp,%ecx
  804235:	77 61                	ja     804298 <__udivdi3+0x88>
  804237:	85 c9                	test   %ecx,%ecx
  804239:	89 ce                	mov    %ecx,%esi
  80423b:	75 0b                	jne    804248 <__udivdi3+0x38>
  80423d:	b8 01 00 00 00       	mov    $0x1,%eax
  804242:	31 d2                	xor    %edx,%edx
  804244:	f7 f1                	div    %ecx
  804246:	89 c6                	mov    %eax,%esi
  804248:	31 d2                	xor    %edx,%edx
  80424a:	89 e8                	mov    %ebp,%eax
  80424c:	f7 f6                	div    %esi
  80424e:	89 c5                	mov    %eax,%ebp
  804250:	89 f8                	mov    %edi,%eax
  804252:	f7 f6                	div    %esi
  804254:	89 ea                	mov    %ebp,%edx
  804256:	83 c4 0c             	add    $0xc,%esp
  804259:	5e                   	pop    %esi
  80425a:	5f                   	pop    %edi
  80425b:	5d                   	pop    %ebp
  80425c:	c3                   	ret    
  80425d:	8d 76 00             	lea    0x0(%esi),%esi
  804260:	39 e8                	cmp    %ebp,%eax
  804262:	77 24                	ja     804288 <__udivdi3+0x78>
  804264:	0f bd e8             	bsr    %eax,%ebp
  804267:	83 f5 1f             	xor    $0x1f,%ebp
  80426a:	75 3c                	jne    8042a8 <__udivdi3+0x98>
  80426c:	8b 74 24 04          	mov    0x4(%esp),%esi
  804270:	39 34 24             	cmp    %esi,(%esp)
  804273:	0f 86 9f 00 00 00    	jbe    804318 <__udivdi3+0x108>
  804279:	39 d0                	cmp    %edx,%eax
  80427b:	0f 82 97 00 00 00    	jb     804318 <__udivdi3+0x108>
  804281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804288:	31 d2                	xor    %edx,%edx
  80428a:	31 c0                	xor    %eax,%eax
  80428c:	83 c4 0c             	add    $0xc,%esp
  80428f:	5e                   	pop    %esi
  804290:	5f                   	pop    %edi
  804291:	5d                   	pop    %ebp
  804292:	c3                   	ret    
  804293:	90                   	nop
  804294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804298:	89 f8                	mov    %edi,%eax
  80429a:	f7 f1                	div    %ecx
  80429c:	31 d2                	xor    %edx,%edx
  80429e:	83 c4 0c             	add    $0xc,%esp
  8042a1:	5e                   	pop    %esi
  8042a2:	5f                   	pop    %edi
  8042a3:	5d                   	pop    %ebp
  8042a4:	c3                   	ret    
  8042a5:	8d 76 00             	lea    0x0(%esi),%esi
  8042a8:	89 e9                	mov    %ebp,%ecx
  8042aa:	8b 3c 24             	mov    (%esp),%edi
  8042ad:	d3 e0                	shl    %cl,%eax
  8042af:	89 c6                	mov    %eax,%esi
  8042b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8042b6:	29 e8                	sub    %ebp,%eax
  8042b8:	89 c1                	mov    %eax,%ecx
  8042ba:	d3 ef                	shr    %cl,%edi
  8042bc:	89 e9                	mov    %ebp,%ecx
  8042be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8042c2:	8b 3c 24             	mov    (%esp),%edi
  8042c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8042c9:	89 d6                	mov    %edx,%esi
  8042cb:	d3 e7                	shl    %cl,%edi
  8042cd:	89 c1                	mov    %eax,%ecx
  8042cf:	89 3c 24             	mov    %edi,(%esp)
  8042d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8042d6:	d3 ee                	shr    %cl,%esi
  8042d8:	89 e9                	mov    %ebp,%ecx
  8042da:	d3 e2                	shl    %cl,%edx
  8042dc:	89 c1                	mov    %eax,%ecx
  8042de:	d3 ef                	shr    %cl,%edi
  8042e0:	09 d7                	or     %edx,%edi
  8042e2:	89 f2                	mov    %esi,%edx
  8042e4:	89 f8                	mov    %edi,%eax
  8042e6:	f7 74 24 08          	divl   0x8(%esp)
  8042ea:	89 d6                	mov    %edx,%esi
  8042ec:	89 c7                	mov    %eax,%edi
  8042ee:	f7 24 24             	mull   (%esp)
  8042f1:	39 d6                	cmp    %edx,%esi
  8042f3:	89 14 24             	mov    %edx,(%esp)
  8042f6:	72 30                	jb     804328 <__udivdi3+0x118>
  8042f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8042fc:	89 e9                	mov    %ebp,%ecx
  8042fe:	d3 e2                	shl    %cl,%edx
  804300:	39 c2                	cmp    %eax,%edx
  804302:	73 05                	jae    804309 <__udivdi3+0xf9>
  804304:	3b 34 24             	cmp    (%esp),%esi
  804307:	74 1f                	je     804328 <__udivdi3+0x118>
  804309:	89 f8                	mov    %edi,%eax
  80430b:	31 d2                	xor    %edx,%edx
  80430d:	e9 7a ff ff ff       	jmp    80428c <__udivdi3+0x7c>
  804312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804318:	31 d2                	xor    %edx,%edx
  80431a:	b8 01 00 00 00       	mov    $0x1,%eax
  80431f:	e9 68 ff ff ff       	jmp    80428c <__udivdi3+0x7c>
  804324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804328:	8d 47 ff             	lea    -0x1(%edi),%eax
  80432b:	31 d2                	xor    %edx,%edx
  80432d:	83 c4 0c             	add    $0xc,%esp
  804330:	5e                   	pop    %esi
  804331:	5f                   	pop    %edi
  804332:	5d                   	pop    %ebp
  804333:	c3                   	ret    
  804334:	66 90                	xchg   %ax,%ax
  804336:	66 90                	xchg   %ax,%ax
  804338:	66 90                	xchg   %ax,%ax
  80433a:	66 90                	xchg   %ax,%ax
  80433c:	66 90                	xchg   %ax,%ax
  80433e:	66 90                	xchg   %ax,%ax

00804340 <__umoddi3>:
  804340:	55                   	push   %ebp
  804341:	57                   	push   %edi
  804342:	56                   	push   %esi
  804343:	83 ec 14             	sub    $0x14,%esp
  804346:	8b 44 24 28          	mov    0x28(%esp),%eax
  80434a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80434e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  804352:	89 c7                	mov    %eax,%edi
  804354:	89 44 24 04          	mov    %eax,0x4(%esp)
  804358:	8b 44 24 30          	mov    0x30(%esp),%eax
  80435c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  804360:	89 34 24             	mov    %esi,(%esp)
  804363:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804367:	85 c0                	test   %eax,%eax
  804369:	89 c2                	mov    %eax,%edx
  80436b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80436f:	75 17                	jne    804388 <__umoddi3+0x48>
  804371:	39 fe                	cmp    %edi,%esi
  804373:	76 4b                	jbe    8043c0 <__umoddi3+0x80>
  804375:	89 c8                	mov    %ecx,%eax
  804377:	89 fa                	mov    %edi,%edx
  804379:	f7 f6                	div    %esi
  80437b:	89 d0                	mov    %edx,%eax
  80437d:	31 d2                	xor    %edx,%edx
  80437f:	83 c4 14             	add    $0x14,%esp
  804382:	5e                   	pop    %esi
  804383:	5f                   	pop    %edi
  804384:	5d                   	pop    %ebp
  804385:	c3                   	ret    
  804386:	66 90                	xchg   %ax,%ax
  804388:	39 f8                	cmp    %edi,%eax
  80438a:	77 54                	ja     8043e0 <__umoddi3+0xa0>
  80438c:	0f bd e8             	bsr    %eax,%ebp
  80438f:	83 f5 1f             	xor    $0x1f,%ebp
  804392:	75 5c                	jne    8043f0 <__umoddi3+0xb0>
  804394:	8b 7c 24 08          	mov    0x8(%esp),%edi
  804398:	39 3c 24             	cmp    %edi,(%esp)
  80439b:	0f 87 e7 00 00 00    	ja     804488 <__umoddi3+0x148>
  8043a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8043a5:	29 f1                	sub    %esi,%ecx
  8043a7:	19 c7                	sbb    %eax,%edi
  8043a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8043ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8043b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043b5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8043b9:	83 c4 14             	add    $0x14,%esp
  8043bc:	5e                   	pop    %esi
  8043bd:	5f                   	pop    %edi
  8043be:	5d                   	pop    %ebp
  8043bf:	c3                   	ret    
  8043c0:	85 f6                	test   %esi,%esi
  8043c2:	89 f5                	mov    %esi,%ebp
  8043c4:	75 0b                	jne    8043d1 <__umoddi3+0x91>
  8043c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8043cb:	31 d2                	xor    %edx,%edx
  8043cd:	f7 f6                	div    %esi
  8043cf:	89 c5                	mov    %eax,%ebp
  8043d1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8043d5:	31 d2                	xor    %edx,%edx
  8043d7:	f7 f5                	div    %ebp
  8043d9:	89 c8                	mov    %ecx,%eax
  8043db:	f7 f5                	div    %ebp
  8043dd:	eb 9c                	jmp    80437b <__umoddi3+0x3b>
  8043df:	90                   	nop
  8043e0:	89 c8                	mov    %ecx,%eax
  8043e2:	89 fa                	mov    %edi,%edx
  8043e4:	83 c4 14             	add    $0x14,%esp
  8043e7:	5e                   	pop    %esi
  8043e8:	5f                   	pop    %edi
  8043e9:	5d                   	pop    %ebp
  8043ea:	c3                   	ret    
  8043eb:	90                   	nop
  8043ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8043f0:	8b 04 24             	mov    (%esp),%eax
  8043f3:	be 20 00 00 00       	mov    $0x20,%esi
  8043f8:	89 e9                	mov    %ebp,%ecx
  8043fa:	29 ee                	sub    %ebp,%esi
  8043fc:	d3 e2                	shl    %cl,%edx
  8043fe:	89 f1                	mov    %esi,%ecx
  804400:	d3 e8                	shr    %cl,%eax
  804402:	89 e9                	mov    %ebp,%ecx
  804404:	89 44 24 04          	mov    %eax,0x4(%esp)
  804408:	8b 04 24             	mov    (%esp),%eax
  80440b:	09 54 24 04          	or     %edx,0x4(%esp)
  80440f:	89 fa                	mov    %edi,%edx
  804411:	d3 e0                	shl    %cl,%eax
  804413:	89 f1                	mov    %esi,%ecx
  804415:	89 44 24 08          	mov    %eax,0x8(%esp)
  804419:	8b 44 24 10          	mov    0x10(%esp),%eax
  80441d:	d3 ea                	shr    %cl,%edx
  80441f:	89 e9                	mov    %ebp,%ecx
  804421:	d3 e7                	shl    %cl,%edi
  804423:	89 f1                	mov    %esi,%ecx
  804425:	d3 e8                	shr    %cl,%eax
  804427:	89 e9                	mov    %ebp,%ecx
  804429:	09 f8                	or     %edi,%eax
  80442b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80442f:	f7 74 24 04          	divl   0x4(%esp)
  804433:	d3 e7                	shl    %cl,%edi
  804435:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804439:	89 d7                	mov    %edx,%edi
  80443b:	f7 64 24 08          	mull   0x8(%esp)
  80443f:	39 d7                	cmp    %edx,%edi
  804441:	89 c1                	mov    %eax,%ecx
  804443:	89 14 24             	mov    %edx,(%esp)
  804446:	72 2c                	jb     804474 <__umoddi3+0x134>
  804448:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80444c:	72 22                	jb     804470 <__umoddi3+0x130>
  80444e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  804452:	29 c8                	sub    %ecx,%eax
  804454:	19 d7                	sbb    %edx,%edi
  804456:	89 e9                	mov    %ebp,%ecx
  804458:	89 fa                	mov    %edi,%edx
  80445a:	d3 e8                	shr    %cl,%eax
  80445c:	89 f1                	mov    %esi,%ecx
  80445e:	d3 e2                	shl    %cl,%edx
  804460:	89 e9                	mov    %ebp,%ecx
  804462:	d3 ef                	shr    %cl,%edi
  804464:	09 d0                	or     %edx,%eax
  804466:	89 fa                	mov    %edi,%edx
  804468:	83 c4 14             	add    $0x14,%esp
  80446b:	5e                   	pop    %esi
  80446c:	5f                   	pop    %edi
  80446d:	5d                   	pop    %ebp
  80446e:	c3                   	ret    
  80446f:	90                   	nop
  804470:	39 d7                	cmp    %edx,%edi
  804472:	75 da                	jne    80444e <__umoddi3+0x10e>
  804474:	8b 14 24             	mov    (%esp),%edx
  804477:	89 c1                	mov    %eax,%ecx
  804479:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80447d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  804481:	eb cb                	jmp    80444e <__umoddi3+0x10e>
  804483:	90                   	nop
  804484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804488:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80448c:	0f 82 0f ff ff ff    	jb     8043a1 <__umoddi3+0x61>
  804492:	e9 1a ff ff ff       	jmp    8043b1 <__umoddi3+0x71>
