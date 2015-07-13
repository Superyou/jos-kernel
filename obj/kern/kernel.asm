
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4 66                	in     $0x66,%al

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 50 12 00       	mov    $0x125000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Running at low EIP is still okay because in entry_pgdir we have
	#entry_pgdir[0] having the address PA of page table which is mapped to
	# PA from [0,4MB]
	
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 50 12 f0       	mov    $0xf0125000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 df 00 00 00       	call   f010011d <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <test_backtrace>:


// Test the stack backtrace function (lab 1 only)
void
test_backtrace(int x)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 14             	sub    $0x14,%esp
f0100047:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("entering test_backtrace %d\n", x);
f010004a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010004e:	c7 04 24 20 86 10 f0 	movl   $0xf0108620,(%esp)
f0100055:	e8 cd 47 00 00       	call   f0104827 <cprintf>
	if (x > 0)
f010005a:	85 db                	test   %ebx,%ebx
f010005c:	7e 0d                	jle    f010006b <test_backtrace+0x2b>
		test_backtrace(x-1);
f010005e:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100061:	89 04 24             	mov    %eax,(%esp)
f0100064:	e8 d7 ff ff ff       	call   f0100040 <test_backtrace>
f0100069:	eb 1c                	jmp    f0100087 <test_backtrace+0x47>
	else
		mon_backtrace(0, 0, 0);
f010006b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100072:	00 
f0100073:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010007a:	00 
f010007b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100082:	e8 e2 0a 00 00       	call   f0100b69 <mon_backtrace>
	cprintf("leaving test_backtrace %d\n", x);
f0100087:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010008b:	c7 04 24 3c 86 10 f0 	movl   $0xf010863c,(%esp)
f0100092:	e8 90 47 00 00       	call   f0104827 <cprintf>
}
f0100097:	83 c4 14             	add    $0x14,%esp
f010009a:	5b                   	pop    %ebx
f010009b:	5d                   	pop    %ebp
f010009c:	c3                   	ret    

f010009d <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f010009d:	55                   	push   %ebp
f010009e:	89 e5                	mov    %esp,%ebp
f01000a0:	57                   	push   %edi
f01000a1:	56                   	push   %esi
f01000a2:	53                   	push   %ebx
f01000a3:	83 ec 1c             	sub    $0x1c,%esp
f01000a6:	8b 7d 08             	mov    0x8(%ebp),%edi
f01000a9:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f01000ac:	83 3d 94 3e 2c f0 00 	cmpl   $0x0,0xf02c3e94
f01000b3:	75 5a                	jne    f010010f <_panic+0x72>
		goto dead;
	panicstr = fmt;
f01000b5:	89 35 94 3e 2c f0    	mov    %esi,0xf02c3e94

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f01000bb:	fa                   	cli    
f01000bc:	fc                   	cld    

	va_start(ap, fmt);
f01000bd:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f01000c0:	e8 34 73 00 00       	call   f01073f9 <cpunum>
f01000c5:	8b 55 0c             	mov    0xc(%ebp),%edx
f01000c8:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01000cc:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01000d0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01000d4:	c7 04 24 e4 86 10 f0 	movl   $0xf01086e4,(%esp)
f01000db:	e8 47 47 00 00       	call   f0104827 <cprintf>

	cprintf("kernel panic at %s:%d: ", file, line);
f01000e0:	8b 45 0c             	mov    0xc(%ebp),%eax
f01000e3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01000e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01000eb:	c7 04 24 57 86 10 f0 	movl   $0xf0108657,(%esp)
f01000f2:	e8 30 47 00 00       	call   f0104827 <cprintf>
	vcprintf(fmt, ap);
f01000f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000fb:	89 34 24             	mov    %esi,(%esp)
f01000fe:	e8 f1 46 00 00       	call   f01047f4 <vcprintf>
	cprintf("\n");
f0100103:	c7 04 24 16 8a 10 f0 	movl   $0xf0108a16,(%esp)
f010010a:	e8 18 47 00 00       	call   f0104827 <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010010f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100116:	e8 63 0b 00 00       	call   f0100c7e <monitor>
f010011b:	eb f2                	jmp    f010010f <_panic+0x72>

f010011d <i386_init>:
	cprintf("leaving test_backtrace %d\n", x);
}

void
i386_init(void)
{
f010011d:	55                   	push   %ebp
f010011e:	89 e5                	mov    %esp,%ebp
f0100120:	53                   	push   %ebx
f0100121:	83 ec 14             	sub    $0x14,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f0100124:	b8 20 57 37 f0       	mov    $0xf0375720,%eax
f0100129:	2d b4 2a 2c f0       	sub    $0xf02c2ab4,%eax
f010012e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100132:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100139:	00 
f010013a:	c7 04 24 b4 2a 2c f0 	movl   $0xf02c2ab4,(%esp)
f0100141:	e8 61 6c 00 00       	call   f0106da7 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f0100146:	e8 ff 05 00 00       	call   f010074a <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f010014b:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f0100152:	00 
f0100153:	c7 04 24 6f 86 10 f0 	movl   $0xf010866f,(%esp)
f010015a:	e8 c8 46 00 00       	call   f0104827 <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f010015f:	e8 12 19 00 00       	call   f0101a76 <mem_init>

	// Lab 3 user environment initialization functions
	env_init();
f0100164:	e8 c2 3c 00 00       	call   f0103e2b <env_init>
	trap_init();
f0100169:	e8 da 47 00 00       	call   f0104948 <trap_init>

	// Lab 4 multiprocessor initialization functions
	mp_init();
f010016e:	66 90                	xchg   %ax,%ax
f0100170:	e8 75 6f 00 00       	call   f01070ea <mp_init>
	lapic_init();
f0100175:	e8 9a 72 00 00       	call   f0107414 <lapic_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f010017a:	e8 c5 45 00 00       	call   f0104744 <pic_init>

	// Lab 6 hardware initialization functions
	time_init();
f010017f:	90                   	nop
f0100180:	e8 a7 81 00 00       	call   f010832c <time_init>
	pci_init();
f0100185:	e8 74 81 00 00       	call   f01082fe <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f010018a:	c7 04 24 c0 73 12 f0 	movl   $0xf01273c0,(%esp)
f0100191:	e8 f6 74 00 00       	call   f010768c <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100196:	83 3d 9c 3e 2c f0 07 	cmpl   $0x7,0xf02c3e9c
f010019d:	77 24                	ja     f01001c3 <i386_init+0xa6>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010019f:	c7 44 24 0c 00 70 00 	movl   $0x7000,0xc(%esp)
f01001a6:	00 
f01001a7:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f01001ae:	f0 
f01001af:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
f01001b6:	00 
f01001b7:	c7 04 24 8a 86 10 f0 	movl   $0xf010868a,(%esp)
f01001be:	e8 da fe ff ff       	call   f010009d <_panic>
	void *code;
	struct CpuInfo *c;

	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01001c3:	b8 22 70 10 f0       	mov    $0xf0107022,%eax
f01001c8:	2d a8 6f 10 f0       	sub    $0xf0106fa8,%eax
f01001cd:	89 44 24 08          	mov    %eax,0x8(%esp)
f01001d1:	c7 44 24 04 a8 6f 10 	movl   $0xf0106fa8,0x4(%esp)
f01001d8:	f0 
f01001d9:	c7 04 24 00 70 00 f0 	movl   $0xf0007000,(%esp)
f01001e0:	e8 0f 6c 00 00       	call   f0106df4 <memmove>

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f01001e5:	bb 20 40 2c f0       	mov    $0xf02c4020,%ebx
f01001ea:	eb 4d                	jmp    f0100239 <i386_init+0x11c>
		if (c == cpus + cpunum())  // We've started already.
f01001ec:	e8 08 72 00 00       	call   f01073f9 <cpunum>
f01001f1:	6b c0 74             	imul   $0x74,%eax,%eax
f01001f4:	05 20 40 2c f0       	add    $0xf02c4020,%eax
f01001f9:	39 c3                	cmp    %eax,%ebx
f01001fb:	74 39                	je     f0100236 <i386_init+0x119>
f01001fd:	89 d8                	mov    %ebx,%eax
f01001ff:	2d 20 40 2c f0       	sub    $0xf02c4020,%eax
			continue;

		// Tell mpentry.S what stack to use 
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100204:	c1 f8 02             	sar    $0x2,%eax
f0100207:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f010020d:	c1 e0 0f             	shl    $0xf,%eax
f0100210:	8d 80 00 d0 2c f0    	lea    -0xfd33000(%eax),%eax
f0100216:	a3 98 3e 2c f0       	mov    %eax,0xf02c3e98
		// Start the CPU at mpentry_start
		lapic_startap(c->cpu_id, PADDR(code));
f010021b:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
f0100222:	00 
f0100223:	0f b6 03             	movzbl (%ebx),%eax
f0100226:	89 04 24             	mov    %eax,(%esp)
f0100229:	e8 4b 73 00 00       	call   f0107579 <lapic_startap>
		// Wait for the CPU to finish some basic setup in mp_main()
		while(c->cpu_status != CPU_STARTED)
f010022e:	8b 43 04             	mov    0x4(%ebx),%eax
f0100231:	83 f8 01             	cmp    $0x1,%eax
f0100234:	75 f8                	jne    f010022e <i386_init+0x111>
	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f0100236:	83 c3 74             	add    $0x74,%ebx
f0100239:	6b 05 c4 43 2c f0 74 	imul   $0x74,0xf02c43c4,%eax
f0100240:	05 20 40 2c f0       	add    $0xf02c4020,%eax
f0100245:	39 c3                	cmp    %eax,%ebx
f0100247:	72 a3                	jb     f01001ec <i386_init+0xcf>
	lock_kernel();
	// Starting non-boot CPUs
	boot_aps();

	// Start fs.
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f0100249:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0100250:	00 
f0100251:	c7 04 24 bd 6c 1e f0 	movl   $0xf01e6cbd,(%esp)
f0100258:	e8 39 3e 00 00       	call   f0104096 <env_create>

#if !defined(TEST_NO_NS)
	// Start ns.
	cprintf("\ncreating ns\n");
f010025d:	c7 04 24 96 86 10 f0 	movl   $0xf0108696,(%esp)
f0100264:	e8 be 45 00 00       	call   f0104827 <cprintf>
	ENV_CREATE(net_ns, ENV_TYPE_NS);
f0100269:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f0100270:	00 
f0100271:	c7 04 24 2d 4c 24 f0 	movl   $0xf0244c2d,(%esp)
f0100278:	e8 19 3e 00 00       	call   f0104096 <env_create>
	cprintf("\ncreated ns\n");
f010027d:	c7 04 24 a4 86 10 f0 	movl   $0xf01086a4,(%esp)
f0100284:	e8 9e 45 00 00       	call   f0104827 <cprintf>
#endif


#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
f0100289:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100290:	00 
f0100291:	c7 04 24 fb 87 20 f0 	movl   $0xf02087fb,(%esp)
f0100298:	e8 f9 3d 00 00       	call   f0104096 <env_create>
	// Touch all you want.
	ENV_CREATE(user_httpd, ENV_TYPE_USER);
#endif // TEST*

	// Should not be necessary - drains keyboard because interrupt has given up.
	kbd_intr();
f010029d:	e8 4c 04 00 00       	call   f01006ee <kbd_intr>

	// Schedule and run the first user environment!
	sched_yield();
f01002a2:	e8 27 55 00 00       	call   f01057ce <sched_yield>

f01002a7 <mp_main>:
}

// Setup code for APs
void
mp_main(void)
{
f01002a7:	55                   	push   %ebp
f01002a8:	89 e5                	mov    %esp,%ebp
f01002aa:	83 ec 18             	sub    $0x18,%esp
	// We are in high EIP now, safe to switch to kern_pgdir 
	lcr3(PADDR(kern_pgdir));
f01002ad:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01002b2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01002b7:	77 20                	ja     f01002d9 <mp_main+0x32>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01002b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01002bd:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f01002c4:	f0 
f01002c5:	c7 44 24 04 8b 00 00 	movl   $0x8b,0x4(%esp)
f01002cc:	00 
f01002cd:	c7 04 24 8a 86 10 f0 	movl   $0xf010868a,(%esp)
f01002d4:	e8 c4 fd ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f01002d9:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f01002de:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01002e1:	e8 13 71 00 00       	call   f01073f9 <cpunum>
f01002e6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01002ea:	c7 04 24 b1 86 10 f0 	movl   $0xf01086b1,(%esp)
f01002f1:	e8 31 45 00 00       	call   f0104827 <cprintf>

	lapic_init();
f01002f6:	e8 19 71 00 00       	call   f0107414 <lapic_init>
	env_init_percpu();
f01002fb:	e8 01 3b 00 00       	call   f0103e01 <env_init_percpu>
	trap_init_percpu();
f0100300:	e8 4b 45 00 00       	call   f0104850 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100305:	e8 ef 70 00 00       	call   f01073f9 <cpunum>
f010030a:	6b d0 74             	imul   $0x74,%eax,%edx
f010030d:	81 c2 20 40 2c f0    	add    $0xf02c4020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0100313:	b8 01 00 00 00       	mov    $0x1,%eax
f0100318:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
f010031c:	c7 04 24 c0 73 12 f0 	movl   $0xf01273c0,(%esp)
f0100323:	e8 64 73 00 00       	call   f010768c <spin_lock>

	// Remove this after you finish Exercise 4

	//for (;;);
	lock_kernel();
	sched_yield();
f0100328:	e8 a1 54 00 00       	call   f01057ce <sched_yield>

f010032d <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010032d:	55                   	push   %ebp
f010032e:	89 e5                	mov    %esp,%ebp
f0100330:	53                   	push   %ebx
f0100331:	83 ec 14             	sub    $0x14,%esp
	va_list ap;

	va_start(ap, fmt);
f0100334:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100337:	8b 45 0c             	mov    0xc(%ebp),%eax
f010033a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010033e:	8b 45 08             	mov    0x8(%ebp),%eax
f0100341:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100345:	c7 04 24 c7 86 10 f0 	movl   $0xf01086c7,(%esp)
f010034c:	e8 d6 44 00 00       	call   f0104827 <cprintf>
	vcprintf(fmt, ap);
f0100351:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100355:	8b 45 10             	mov    0x10(%ebp),%eax
f0100358:	89 04 24             	mov    %eax,(%esp)
f010035b:	e8 94 44 00 00       	call   f01047f4 <vcprintf>
	cprintf("\n");
f0100360:	c7 04 24 16 8a 10 f0 	movl   $0xf0108a16,(%esp)
f0100367:	e8 bb 44 00 00       	call   f0104827 <cprintf>
	va_end(ap);
}
f010036c:	83 c4 14             	add    $0x14,%esp
f010036f:	5b                   	pop    %ebx
f0100370:	5d                   	pop    %ebp
f0100371:	c3                   	ret    
f0100372:	66 90                	xchg   %ax,%ax
f0100374:	66 90                	xchg   %ax,%ax
f0100376:	66 90                	xchg   %ax,%ax
f0100378:	66 90                	xchg   %ax,%ax
f010037a:	66 90                	xchg   %ax,%ax
f010037c:	66 90                	xchg   %ax,%ax
f010037e:	66 90                	xchg   %ax,%ax

f0100380 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100380:	55                   	push   %ebp
f0100381:	89 e5                	mov    %esp,%ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100383:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100388:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100389:	a8 01                	test   $0x1,%al
f010038b:	74 08                	je     f0100395 <serial_proc_data+0x15>
f010038d:	b2 f8                	mov    $0xf8,%dl
f010038f:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100390:	0f b6 c0             	movzbl %al,%eax
f0100393:	eb 05                	jmp    f010039a <serial_proc_data+0x1a>

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
f0100395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return inb(COM1+COM_RX);
}
f010039a:	5d                   	pop    %ebp
f010039b:	c3                   	ret    

f010039c <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010039c:	55                   	push   %ebp
f010039d:	89 e5                	mov    %esp,%ebp
f010039f:	53                   	push   %ebx
f01003a0:	83 ec 04             	sub    $0x4,%esp
f01003a3:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01003a5:	eb 2a                	jmp    f01003d1 <cons_intr+0x35>
		if (c == 0)
f01003a7:	85 d2                	test   %edx,%edx
f01003a9:	74 26                	je     f01003d1 <cons_intr+0x35>
			continue;
		cons.buf[cons.wpos++] = c;
f01003ab:	a1 24 32 2c f0       	mov    0xf02c3224,%eax
f01003b0:	8d 48 01             	lea    0x1(%eax),%ecx
f01003b3:	89 0d 24 32 2c f0    	mov    %ecx,0xf02c3224
f01003b9:	88 90 20 30 2c f0    	mov    %dl,-0xfd3cfe0(%eax)
		if (cons.wpos == CONSBUFSIZE)
f01003bf:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f01003c5:	75 0a                	jne    f01003d1 <cons_intr+0x35>
			cons.wpos = 0;
f01003c7:	c7 05 24 32 2c f0 00 	movl   $0x0,0xf02c3224
f01003ce:	00 00 00 
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f01003d1:	ff d3                	call   *%ebx
f01003d3:	89 c2                	mov    %eax,%edx
f01003d5:	83 f8 ff             	cmp    $0xffffffff,%eax
f01003d8:	75 cd                	jne    f01003a7 <cons_intr+0xb>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f01003da:	83 c4 04             	add    $0x4,%esp
f01003dd:	5b                   	pop    %ebx
f01003de:	5d                   	pop    %ebp
f01003df:	c3                   	ret    

f01003e0 <kbd_proc_data>:
f01003e0:	ba 64 00 00 00       	mov    $0x64,%edx
f01003e5:	ec                   	in     (%dx),%al
{
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
f01003e6:	a8 01                	test   $0x1,%al
f01003e8:	0f 84 ef 00 00 00    	je     f01004dd <kbd_proc_data+0xfd>
f01003ee:	b2 60                	mov    $0x60,%dl
f01003f0:	ec                   	in     (%dx),%al
f01003f1:	89 c2                	mov    %eax,%edx
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
f01003f3:	3c e0                	cmp    $0xe0,%al
f01003f5:	75 0d                	jne    f0100404 <kbd_proc_data+0x24>
		// E0 escape character
		shift |= E0ESC;
f01003f7:	83 0d 00 30 2c f0 40 	orl    $0x40,0xf02c3000
		return 0;
f01003fe:	b8 00 00 00 00       	mov    $0x0,%eax
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f0100403:	c3                   	ret    
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f0100404:	55                   	push   %ebp
f0100405:	89 e5                	mov    %esp,%ebp
f0100407:	53                   	push   %ebx
f0100408:	83 ec 14             	sub    $0x14,%esp

	if (data == 0xE0) {
		// E0 escape character
		shift |= E0ESC;
		return 0;
	} else if (data & 0x80) {
f010040b:	84 c0                	test   %al,%al
f010040d:	79 37                	jns    f0100446 <kbd_proc_data+0x66>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f010040f:	8b 0d 00 30 2c f0    	mov    0xf02c3000,%ecx
f0100415:	89 cb                	mov    %ecx,%ebx
f0100417:	83 e3 40             	and    $0x40,%ebx
f010041a:	83 e0 7f             	and    $0x7f,%eax
f010041d:	85 db                	test   %ebx,%ebx
f010041f:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100422:	0f b6 d2             	movzbl %dl,%edx
f0100425:	0f b6 82 a0 88 10 f0 	movzbl -0xfef7760(%edx),%eax
f010042c:	83 c8 40             	or     $0x40,%eax
f010042f:	0f b6 c0             	movzbl %al,%eax
f0100432:	f7 d0                	not    %eax
f0100434:	21 c1                	and    %eax,%ecx
f0100436:	89 0d 00 30 2c f0    	mov    %ecx,0xf02c3000
		return 0;
f010043c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100441:	e9 9d 00 00 00       	jmp    f01004e3 <kbd_proc_data+0x103>
	} else if (shift & E0ESC) {
f0100446:	8b 0d 00 30 2c f0    	mov    0xf02c3000,%ecx
f010044c:	f6 c1 40             	test   $0x40,%cl
f010044f:	74 0e                	je     f010045f <kbd_proc_data+0x7f>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f0100451:	83 c8 80             	or     $0xffffff80,%eax
f0100454:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100456:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100459:	89 0d 00 30 2c f0    	mov    %ecx,0xf02c3000
	}

	shift |= shiftcode[data];
f010045f:	0f b6 d2             	movzbl %dl,%edx
f0100462:	0f b6 82 a0 88 10 f0 	movzbl -0xfef7760(%edx),%eax
f0100469:	0b 05 00 30 2c f0    	or     0xf02c3000,%eax
	shift ^= togglecode[data];
f010046f:	0f b6 8a a0 87 10 f0 	movzbl -0xfef7860(%edx),%ecx
f0100476:	31 c8                	xor    %ecx,%eax
f0100478:	a3 00 30 2c f0       	mov    %eax,0xf02c3000

	c = charcode[shift & (CTL | SHIFT)][data];
f010047d:	89 c1                	mov    %eax,%ecx
f010047f:	83 e1 03             	and    $0x3,%ecx
f0100482:	8b 0c 8d 80 87 10 f0 	mov    -0xfef7880(,%ecx,4),%ecx
f0100489:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f010048d:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100490:	a8 08                	test   $0x8,%al
f0100492:	74 1b                	je     f01004af <kbd_proc_data+0xcf>
		if ('a' <= c && c <= 'z')
f0100494:	89 da                	mov    %ebx,%edx
f0100496:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100499:	83 f9 19             	cmp    $0x19,%ecx
f010049c:	77 05                	ja     f01004a3 <kbd_proc_data+0xc3>
			c += 'A' - 'a';
f010049e:	83 eb 20             	sub    $0x20,%ebx
f01004a1:	eb 0c                	jmp    f01004af <kbd_proc_data+0xcf>
		else if ('A' <= c && c <= 'Z')
f01004a3:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01004a6:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01004a9:	83 fa 19             	cmp    $0x19,%edx
f01004ac:	0f 46 d9             	cmovbe %ecx,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01004af:	f7 d0                	not    %eax
f01004b1:	89 c2                	mov    %eax,%edx
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f01004b3:	89 d8                	mov    %ebx,%eax
			c += 'a' - 'A';
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01004b5:	f6 c2 06             	test   $0x6,%dl
f01004b8:	75 29                	jne    f01004e3 <kbd_proc_data+0x103>
f01004ba:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01004c0:	75 21                	jne    f01004e3 <kbd_proc_data+0x103>
		cprintf("Rebooting!\n");
f01004c2:	c7 04 24 50 87 10 f0 	movl   $0xf0108750,(%esp)
f01004c9:	e8 59 43 00 00       	call   f0104827 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004ce:	ba 92 00 00 00       	mov    $0x92,%edx
f01004d3:	b8 03 00 00 00       	mov    $0x3,%eax
f01004d8:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f01004d9:	89 d8                	mov    %ebx,%eax
f01004db:	eb 06                	jmp    f01004e3 <kbd_proc_data+0x103>
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
f01004dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01004e2:	c3                   	ret    
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f01004e3:	83 c4 14             	add    $0x14,%esp
f01004e6:	5b                   	pop    %ebx
f01004e7:	5d                   	pop    %ebp
f01004e8:	c3                   	ret    

f01004e9 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01004e9:	55                   	push   %ebp
f01004ea:	89 e5                	mov    %esp,%ebp
f01004ec:	57                   	push   %edi
f01004ed:	56                   	push   %esi
f01004ee:	53                   	push   %ebx
f01004ef:	83 ec 1c             	sub    $0x1c,%esp
f01004f2:	89 c7                	mov    %eax,%edi
f01004f4:	bb 01 32 00 00       	mov    $0x3201,%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004f9:	be fd 03 00 00       	mov    $0x3fd,%esi
f01004fe:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100503:	eb 0c                	jmp    f0100511 <cons_putc+0x28>
f0100505:	89 ca                	mov    %ecx,%edx
f0100507:	ec                   	in     (%dx),%al
f0100508:	89 ca                	mov    %ecx,%edx
f010050a:	ec                   	in     (%dx),%al
f010050b:	89 ca                	mov    %ecx,%edx
f010050d:	ec                   	in     (%dx),%al
f010050e:	89 ca                	mov    %ecx,%edx
f0100510:	ec                   	in     (%dx),%al
f0100511:	89 f2                	mov    %esi,%edx
f0100513:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
f0100514:	a8 20                	test   $0x20,%al
f0100516:	75 05                	jne    f010051d <cons_putc+0x34>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100518:	83 eb 01             	sub    $0x1,%ebx
f010051b:	75 e8                	jne    f0100505 <cons_putc+0x1c>
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
f010051d:	89 f8                	mov    %edi,%eax
f010051f:	0f b6 c0             	movzbl %al,%eax
f0100522:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100525:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010052a:	ee                   	out    %al,(%dx)
f010052b:	bb 01 32 00 00       	mov    $0x3201,%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100530:	be 79 03 00 00       	mov    $0x379,%esi
f0100535:	b9 84 00 00 00       	mov    $0x84,%ecx
f010053a:	eb 0c                	jmp    f0100548 <cons_putc+0x5f>
f010053c:	89 ca                	mov    %ecx,%edx
f010053e:	ec                   	in     (%dx),%al
f010053f:	89 ca                	mov    %ecx,%edx
f0100541:	ec                   	in     (%dx),%al
f0100542:	89 ca                	mov    %ecx,%edx
f0100544:	ec                   	in     (%dx),%al
f0100545:	89 ca                	mov    %ecx,%edx
f0100547:	ec                   	in     (%dx),%al
f0100548:	89 f2                	mov    %esi,%edx
f010054a:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010054b:	84 c0                	test   %al,%al
f010054d:	78 05                	js     f0100554 <cons_putc+0x6b>
f010054f:	83 eb 01             	sub    $0x1,%ebx
f0100552:	75 e8                	jne    f010053c <cons_putc+0x53>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100554:	ba 78 03 00 00       	mov    $0x378,%edx
f0100559:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
f010055d:	ee                   	out    %al,(%dx)
f010055e:	b2 7a                	mov    $0x7a,%dl
f0100560:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100565:	ee                   	out    %al,(%dx)
f0100566:	b8 08 00 00 00       	mov    $0x8,%eax
f010056b:	ee                   	out    %al,(%dx)

static void
cga_putc(int c)
{
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f010056c:	89 fa                	mov    %edi,%edx
f010056e:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= text_color;
f0100574:	89 f8                	mov    %edi,%eax
f0100576:	80 cc 07             	or     $0x7,%ah
f0100579:	85 d2                	test   %edx,%edx
f010057b:	0f 44 f8             	cmove  %eax,%edi

	switch (c & 0xff) {
f010057e:	89 f8                	mov    %edi,%eax
f0100580:	0f b6 c0             	movzbl %al,%eax
f0100583:	83 f8 09             	cmp    $0x9,%eax
f0100586:	74 75                	je     f01005fd <cons_putc+0x114>
f0100588:	83 f8 09             	cmp    $0x9,%eax
f010058b:	7f 0a                	jg     f0100597 <cons_putc+0xae>
f010058d:	83 f8 08             	cmp    $0x8,%eax
f0100590:	74 15                	je     f01005a7 <cons_putc+0xbe>
f0100592:	e9 9a 00 00 00       	jmp    f0100631 <cons_putc+0x148>
f0100597:	83 f8 0a             	cmp    $0xa,%eax
f010059a:	74 3b                	je     f01005d7 <cons_putc+0xee>
f010059c:	83 f8 0d             	cmp    $0xd,%eax
f010059f:	90                   	nop
f01005a0:	74 3d                	je     f01005df <cons_putc+0xf6>
f01005a2:	e9 8a 00 00 00       	jmp    f0100631 <cons_putc+0x148>
	case '\b':
		if (crt_pos > 0) {
f01005a7:	0f b7 05 28 32 2c f0 	movzwl 0xf02c3228,%eax
f01005ae:	66 85 c0             	test   %ax,%ax
f01005b1:	0f 84 e5 00 00 00    	je     f010069c <cons_putc+0x1b3>
			crt_pos--;
f01005b7:	83 e8 01             	sub    $0x1,%eax
f01005ba:	66 a3 28 32 2c f0    	mov    %ax,0xf02c3228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01005c0:	0f b7 c0             	movzwl %ax,%eax
f01005c3:	66 81 e7 00 ff       	and    $0xff00,%di
f01005c8:	83 cf 20             	or     $0x20,%edi
f01005cb:	8b 15 2c 32 2c f0    	mov    0xf02c322c,%edx
f01005d1:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f01005d5:	eb 78                	jmp    f010064f <cons_putc+0x166>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f01005d7:	66 83 05 28 32 2c f0 	addw   $0x50,0xf02c3228
f01005de:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f01005df:	0f b7 05 28 32 2c f0 	movzwl 0xf02c3228,%eax
f01005e6:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01005ec:	c1 e8 16             	shr    $0x16,%eax
f01005ef:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01005f2:	c1 e0 04             	shl    $0x4,%eax
f01005f5:	66 a3 28 32 2c f0    	mov    %ax,0xf02c3228
f01005fb:	eb 52                	jmp    f010064f <cons_putc+0x166>
		break;
	case '\t':
		cons_putc(' ');
f01005fd:	b8 20 00 00 00       	mov    $0x20,%eax
f0100602:	e8 e2 fe ff ff       	call   f01004e9 <cons_putc>
		cons_putc(' ');
f0100607:	b8 20 00 00 00       	mov    $0x20,%eax
f010060c:	e8 d8 fe ff ff       	call   f01004e9 <cons_putc>
		cons_putc(' ');
f0100611:	b8 20 00 00 00       	mov    $0x20,%eax
f0100616:	e8 ce fe ff ff       	call   f01004e9 <cons_putc>
		cons_putc(' ');
f010061b:	b8 20 00 00 00       	mov    $0x20,%eax
f0100620:	e8 c4 fe ff ff       	call   f01004e9 <cons_putc>
		cons_putc(' ');
f0100625:	b8 20 00 00 00       	mov    $0x20,%eax
f010062a:	e8 ba fe ff ff       	call   f01004e9 <cons_putc>
f010062f:	eb 1e                	jmp    f010064f <cons_putc+0x166>
		break;
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f0100631:	0f b7 05 28 32 2c f0 	movzwl 0xf02c3228,%eax
f0100638:	8d 50 01             	lea    0x1(%eax),%edx
f010063b:	66 89 15 28 32 2c f0 	mov    %dx,0xf02c3228
f0100642:	0f b7 c0             	movzwl %ax,%eax
f0100645:	8b 15 2c 32 2c f0    	mov    0xf02c322c,%edx
f010064b:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f010064f:	66 81 3d 28 32 2c f0 	cmpw   $0x7cf,0xf02c3228
f0100656:	cf 07 
f0100658:	76 42                	jbe    f010069c <cons_putc+0x1b3>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f010065a:	a1 2c 32 2c f0       	mov    0xf02c322c,%eax
f010065f:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f0100666:	00 
f0100667:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f010066d:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100671:	89 04 24             	mov    %eax,(%esp)
f0100674:	e8 7b 67 00 00       	call   f0106df4 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f0100679:	8b 15 2c 32 2c f0    	mov    0xf02c322c,%edx
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f010067f:	b8 80 07 00 00       	mov    $0x780,%eax
			crt_buf[i] = 0x0700 | ' ';
f0100684:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f010068a:	83 c0 01             	add    $0x1,%eax
f010068d:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f0100692:	75 f0                	jne    f0100684 <cons_putc+0x19b>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f0100694:	66 83 2d 28 32 2c f0 	subw   $0x50,0xf02c3228
f010069b:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f010069c:	8b 0d 30 32 2c f0    	mov    0xf02c3230,%ecx
f01006a2:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006a7:	89 ca                	mov    %ecx,%edx
f01006a9:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01006aa:	0f b7 1d 28 32 2c f0 	movzwl 0xf02c3228,%ebx
f01006b1:	8d 71 01             	lea    0x1(%ecx),%esi
f01006b4:	89 d8                	mov    %ebx,%eax
f01006b6:	66 c1 e8 08          	shr    $0x8,%ax
f01006ba:	89 f2                	mov    %esi,%edx
f01006bc:	ee                   	out    %al,(%dx)
f01006bd:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006c2:	89 ca                	mov    %ecx,%edx
f01006c4:	ee                   	out    %al,(%dx)
f01006c5:	89 d8                	mov    %ebx,%eax
f01006c7:	89 f2                	mov    %esi,%edx
f01006c9:	ee                   	out    %al,(%dx)
cons_putc(int c)
{
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f01006ca:	83 c4 1c             	add    $0x1c,%esp
f01006cd:	5b                   	pop    %ebx
f01006ce:	5e                   	pop    %esi
f01006cf:	5f                   	pop    %edi
f01006d0:	5d                   	pop    %ebp
f01006d1:	c3                   	ret    

f01006d2 <serial_intr>:
}

void
serial_intr(void)
{
	if (serial_exists)
f01006d2:	80 3d 34 32 2c f0 00 	cmpb   $0x0,0xf02c3234
f01006d9:	74 11                	je     f01006ec <serial_intr+0x1a>
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f01006db:	55                   	push   %ebp
f01006dc:	89 e5                	mov    %esp,%ebp
f01006de:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
		cons_intr(serial_proc_data);
f01006e1:	b8 80 03 10 f0       	mov    $0xf0100380,%eax
f01006e6:	e8 b1 fc ff ff       	call   f010039c <cons_intr>
}
f01006eb:	c9                   	leave  
f01006ec:	f3 c3                	repz ret 

f01006ee <kbd_intr>:
	return c;
}

void
kbd_intr(void)
{
f01006ee:	55                   	push   %ebp
f01006ef:	89 e5                	mov    %esp,%ebp
f01006f1:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01006f4:	b8 e0 03 10 f0       	mov    $0xf01003e0,%eax
f01006f9:	e8 9e fc ff ff       	call   f010039c <cons_intr>
}
f01006fe:	c9                   	leave  
f01006ff:	c3                   	ret    

f0100700 <cons_getc>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f0100700:	55                   	push   %ebp
f0100701:	89 e5                	mov    %esp,%ebp
f0100703:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f0100706:	e8 c7 ff ff ff       	call   f01006d2 <serial_intr>
	kbd_intr();
f010070b:	e8 de ff ff ff       	call   f01006ee <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f0100710:	a1 20 32 2c f0       	mov    0xf02c3220,%eax
f0100715:	3b 05 24 32 2c f0    	cmp    0xf02c3224,%eax
f010071b:	74 26                	je     f0100743 <cons_getc+0x43>
		c = cons.buf[cons.rpos++];
f010071d:	8d 50 01             	lea    0x1(%eax),%edx
f0100720:	89 15 20 32 2c f0    	mov    %edx,0xf02c3220
f0100726:	0f b6 88 20 30 2c f0 	movzbl -0xfd3cfe0(%eax),%ecx
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
f010072d:	89 c8                	mov    %ecx,%eax
	kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
f010072f:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f0100735:	75 11                	jne    f0100748 <cons_getc+0x48>
			cons.rpos = 0;
f0100737:	c7 05 20 32 2c f0 00 	movl   $0x0,0xf02c3220
f010073e:	00 00 00 
f0100741:	eb 05                	jmp    f0100748 <cons_getc+0x48>
		return c;
	}
	return 0;
f0100743:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100748:	c9                   	leave  
f0100749:	c3                   	ret    

f010074a <cons_init>:
}

// initialize the console devices
void
cons_init(void)
{
f010074a:	55                   	push   %ebp
f010074b:	89 e5                	mov    %esp,%ebp
f010074d:	57                   	push   %edi
f010074e:	56                   	push   %esi
f010074f:	53                   	push   %ebx
f0100750:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f0100753:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010075a:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100761:	5a a5 
	if (*cp != 0xA55A) {
f0100763:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010076a:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010076e:	74 11                	je     f0100781 <cons_init+0x37>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f0100770:	c7 05 30 32 2c f0 b4 	movl   $0x3b4,0xf02c3230
f0100777:	03 00 00 

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
	*cp = (uint16_t) 0xA55A;
	if (*cp != 0xA55A) {
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010077a:	bf 00 00 0b f0       	mov    $0xf00b0000,%edi
f010077f:	eb 16                	jmp    f0100797 <cons_init+0x4d>
		addr_6845 = MONO_BASE;
	} else {
		*cp = was;
f0100781:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100788:	c7 05 30 32 2c f0 d4 	movl   $0x3d4,0xf02c3230
f010078f:	03 00 00 
{
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100792:	bf 00 80 0b f0       	mov    $0xf00b8000,%edi
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f0100797:	8b 0d 30 32 2c f0    	mov    0xf02c3230,%ecx
f010079d:	b8 0e 00 00 00       	mov    $0xe,%eax
f01007a2:	89 ca                	mov    %ecx,%edx
f01007a4:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01007a5:	8d 59 01             	lea    0x1(%ecx),%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01007a8:	89 da                	mov    %ebx,%edx
f01007aa:	ec                   	in     (%dx),%al
f01007ab:	0f b6 f0             	movzbl %al,%esi
f01007ae:	c1 e6 08             	shl    $0x8,%esi
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01007b1:	b8 0f 00 00 00       	mov    $0xf,%eax
f01007b6:	89 ca                	mov    %ecx,%edx
f01007b8:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01007b9:	89 da                	mov    %ebx,%edx
f01007bb:	ec                   	in     (%dx),%al
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f01007bc:	89 3d 2c 32 2c f0    	mov    %edi,0xf02c322c

	/* Extract cursor location */
	outb(addr_6845, 14);
	pos = inb(addr_6845 + 1) << 8;
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);
f01007c2:	0f b6 d8             	movzbl %al,%ebx
f01007c5:	09 de                	or     %ebx,%esi

	crt_buf = (uint16_t*) cp;
	crt_pos = pos;
f01007c7:	66 89 35 28 32 2c f0 	mov    %si,0xf02c3228

static void
kbd_init(void)
{
	// Drain the kbd buffer so that QEMU generates interrupts.
	kbd_intr();
f01007ce:	e8 1b ff ff ff       	call   f01006ee <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f01007d3:	0f b7 05 a8 73 12 f0 	movzwl 0xf01273a8,%eax
f01007da:	25 fd ff 00 00       	and    $0xfffd,%eax
f01007df:	89 04 24             	mov    %eax,(%esp)
f01007e2:	e8 ee 3e 00 00       	call   f01046d5 <irq_setmask_8259A>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01007e7:	ba fa 03 00 00       	mov    $0x3fa,%edx
f01007ec:	b8 00 00 00 00       	mov    $0x0,%eax
f01007f1:	ee                   	out    %al,(%dx)
f01007f2:	b2 fb                	mov    $0xfb,%dl
f01007f4:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f01007f9:	ee                   	out    %al,(%dx)
f01007fa:	b2 f8                	mov    $0xf8,%dl
f01007fc:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100801:	ee                   	out    %al,(%dx)
f0100802:	b2 f9                	mov    $0xf9,%dl
f0100804:	b8 00 00 00 00       	mov    $0x0,%eax
f0100809:	ee                   	out    %al,(%dx)
f010080a:	b2 fb                	mov    $0xfb,%dl
f010080c:	b8 03 00 00 00       	mov    $0x3,%eax
f0100811:	ee                   	out    %al,(%dx)
f0100812:	b2 fc                	mov    $0xfc,%dl
f0100814:	b8 00 00 00 00       	mov    $0x0,%eax
f0100819:	ee                   	out    %al,(%dx)
f010081a:	b2 f9                	mov    $0xf9,%dl
f010081c:	b8 01 00 00 00       	mov    $0x1,%eax
f0100821:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100822:	b2 fd                	mov    $0xfd,%dl
f0100824:	ec                   	in     (%dx),%al
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100825:	3c ff                	cmp    $0xff,%al
f0100827:	0f 95 c1             	setne  %cl
f010082a:	88 0d 34 32 2c f0    	mov    %cl,0xf02c3234
f0100830:	b2 fa                	mov    $0xfa,%dl
f0100832:	ec                   	in     (%dx),%al
f0100833:	b2 f8                	mov    $0xf8,%dl
f0100835:	ec                   	in     (%dx),%al
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

	// Enable serial interrupts
	if (serial_exists)
f0100836:	84 c9                	test   %cl,%cl
f0100838:	74 1d                	je     f0100857 <cons_init+0x10d>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<4));
f010083a:	0f b7 05 a8 73 12 f0 	movzwl 0xf01273a8,%eax
f0100841:	25 ef ff 00 00       	and    $0xffef,%eax
f0100846:	89 04 24             	mov    %eax,(%esp)
f0100849:	e8 87 3e 00 00       	call   f01046d5 <irq_setmask_8259A>
{
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f010084e:	80 3d 34 32 2c f0 00 	cmpb   $0x0,0xf02c3234
f0100855:	75 0c                	jne    f0100863 <cons_init+0x119>
		cprintf("Serial port does not exist!\n");
f0100857:	c7 04 24 5c 87 10 f0 	movl   $0xf010875c,(%esp)
f010085e:	e8 c4 3f 00 00       	call   f0104827 <cprintf>
}
f0100863:	83 c4 1c             	add    $0x1c,%esp
f0100866:	5b                   	pop    %ebx
f0100867:	5e                   	pop    %esi
f0100868:	5f                   	pop    %edi
f0100869:	5d                   	pop    %ebp
f010086a:	c3                   	ret    

f010086b <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f010086b:	55                   	push   %ebp
f010086c:	89 e5                	mov    %esp,%ebp
f010086e:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100871:	8b 45 08             	mov    0x8(%ebp),%eax
f0100874:	e8 70 fc ff ff       	call   f01004e9 <cons_putc>
}
f0100879:	c9                   	leave  
f010087a:	c3                   	ret    

f010087b <getchar>:

int
getchar(void)
{
f010087b:	55                   	push   %ebp
f010087c:	89 e5                	mov    %esp,%ebp
f010087e:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100881:	e8 7a fe ff ff       	call   f0100700 <cons_getc>
f0100886:	85 c0                	test   %eax,%eax
f0100888:	74 f7                	je     f0100881 <getchar+0x6>
		/* do nothing */;
	return c;
}
f010088a:	c9                   	leave  
f010088b:	c3                   	ret    

f010088c <iscons>:

int
iscons(int fdnum)
{
f010088c:	55                   	push   %ebp
f010088d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f010088f:	b8 01 00 00 00       	mov    $0x1,%eax
f0100894:	5d                   	pop    %ebp
f0100895:	c3                   	ret    
f0100896:	66 90                	xchg   %ax,%ax
f0100898:	66 90                	xchg   %ax,%ax
f010089a:	66 90                	xchg   %ax,%ax
f010089c:	66 90                	xchg   %ax,%ax
f010089e:	66 90                	xchg   %ax,%ax

f01008a0 <mon_break>:
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

int mon_break(int argc, char **argv, struct Trapframe *tf)
{
f01008a0:	55                   	push   %ebp
f01008a1:	89 e5                	mov    %esp,%ebp
f01008a3:	8b 45 10             	mov    0x10(%ebp),%eax
	tf->tf_eflags = tf->tf_eflags | SET_TF;
f01008a6:	81 48 38 00 01 00 00 	orl    $0x100,0x38(%eax)
	return 0;
}
f01008ad:	b8 00 00 00 00       	mov    $0x0,%eax
f01008b2:	5d                   	pop    %ebp
f01008b3:	c3                   	ret    

f01008b4 <mon_step>:

int mon_step(int argc, char **argv, struct Trapframe *tf)
{
f01008b4:	55                   	push   %ebp
f01008b5:	89 e5                	mov    %esp,%ebp
	//tf->tf_eflags = tf->tf_eflags | SET_TF;
	return -1;
}
f01008b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01008bc:	5d                   	pop    %ebp
f01008bd:	c3                   	ret    

f01008be <mon_continue>:

int mon_continue(int argc, char **argv, struct Trapframe *tf)
{
f01008be:	55                   	push   %ebp
f01008bf:	89 e5                	mov    %esp,%ebp
	tf->tf_eflags = tf->tf_eflags & !(SET_TF);
f01008c1:	8b 45 10             	mov    0x10(%ebp),%eax
f01008c4:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	return -1;
}
f01008cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01008d0:	5d                   	pop    %ebp
f01008d1:	c3                   	ret    

f01008d2 <mon_help>:

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01008d2:	55                   	push   %ebp
f01008d3:	89 e5                	mov    %esp,%ebp
f01008d5:	56                   	push   %esi
f01008d6:	53                   	push   %ebx
f01008d7:	83 ec 10             	sub    $0x10,%esp
f01008da:	bb 64 8d 10 f0       	mov    $0xf0108d64,%ebx
f01008df:	be d0 8d 10 f0       	mov    $0xf0108dd0,%esi
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01008e4:	8b 03                	mov    (%ebx),%eax
f01008e6:	89 44 24 08          	mov    %eax,0x8(%esp)
f01008ea:	8b 43 fc             	mov    -0x4(%ebx),%eax
f01008ed:	89 44 24 04          	mov    %eax,0x4(%esp)
f01008f1:	c7 04 24 a0 89 10 f0 	movl   $0xf01089a0,(%esp)
f01008f8:	e8 2a 3f 00 00       	call   f0104827 <cprintf>
f01008fd:	83 c3 0c             	add    $0xc,%ebx
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
f0100900:	39 f3                	cmp    %esi,%ebx
f0100902:	75 e0                	jne    f01008e4 <mon_help+0x12>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}
f0100904:	b8 00 00 00 00       	mov    $0x0,%eax
f0100909:	83 c4 10             	add    $0x10,%esp
f010090c:	5b                   	pop    %ebx
f010090d:	5e                   	pop    %esi
f010090e:	5d                   	pop    %ebp
f010090f:	c3                   	ret    

f0100910 <mon_kerninfo>:
}


int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100910:	55                   	push   %ebp
f0100911:	89 e5                	mov    %esp,%ebp
f0100913:	83 ec 18             	sub    $0x18,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100916:	c7 04 24 a9 89 10 f0 	movl   $0xf01089a9,(%esp)
f010091d:	e8 05 3f 00 00       	call   f0104827 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100922:	c7 44 24 04 0c 00 10 	movl   $0x10000c,0x4(%esp)
f0100929:	00 
f010092a:	c7 04 24 20 8b 10 f0 	movl   $0xf0108b20,(%esp)
f0100931:	e8 f1 3e 00 00       	call   f0104827 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100936:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f010093d:	00 
f010093e:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f0100945:	f0 
f0100946:	c7 04 24 48 8b 10 f0 	movl   $0xf0108b48,(%esp)
f010094d:	e8 d5 3e 00 00       	call   f0104827 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100952:	c7 44 24 08 17 86 10 	movl   $0x108617,0x8(%esp)
f0100959:	00 
f010095a:	c7 44 24 04 17 86 10 	movl   $0xf0108617,0x4(%esp)
f0100961:	f0 
f0100962:	c7 04 24 6c 8b 10 f0 	movl   $0xf0108b6c,(%esp)
f0100969:	e8 b9 3e 00 00       	call   f0104827 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010096e:	c7 44 24 08 b4 2a 2c 	movl   $0x2c2ab4,0x8(%esp)
f0100975:	00 
f0100976:	c7 44 24 04 b4 2a 2c 	movl   $0xf02c2ab4,0x4(%esp)
f010097d:	f0 
f010097e:	c7 04 24 90 8b 10 f0 	movl   $0xf0108b90,(%esp)
f0100985:	e8 9d 3e 00 00       	call   f0104827 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010098a:	c7 44 24 08 20 57 37 	movl   $0x375720,0x8(%esp)
f0100991:	00 
f0100992:	c7 44 24 04 20 57 37 	movl   $0xf0375720,0x4(%esp)
f0100999:	f0 
f010099a:	c7 04 24 b4 8b 10 f0 	movl   $0xf0108bb4,(%esp)
f01009a1:	e8 81 3e 00 00       	call   f0104827 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
f01009a6:	b8 1f 5b 37 f0       	mov    $0xf0375b1f,%eax
f01009ab:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f01009b0:	25 00 fc ff ff       	and    $0xfffffc00,%eax
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
f01009b5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
f01009bb:	85 c0                	test   %eax,%eax
f01009bd:	0f 48 c2             	cmovs  %edx,%eax
f01009c0:	c1 f8 0a             	sar    $0xa,%eax
f01009c3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009c7:	c7 04 24 d8 8b 10 f0 	movl   $0xf0108bd8,(%esp)
f01009ce:	e8 54 3e 00 00       	call   f0104827 <cprintf>
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}
f01009d3:	b8 00 00 00 00       	mov    $0x0,%eax
f01009d8:	c9                   	leave  
f01009d9:	c3                   	ret    

f01009da <mon_chperm>:
	return 0;
}

int
mon_chperm(int argc, char **argv, struct Trapframe *tf)
{
f01009da:	55                   	push   %ebp
f01009db:	89 e5                	mov    %esp,%ebp
f01009dd:	56                   	push   %esi
f01009de:	53                   	push   %ebx
f01009df:	83 ec 10             	sub    $0x10,%esp
f01009e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *vaddr;
	int perm, len;
	if(argc!=3){
f01009e5:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f01009e9:	74 0e                	je     f01009f9 <mon_chperm+0x1f>
		cprintf("\nformat expected: chperm [vaddr] [perm]\n");
f01009eb:	c7 04 24 04 8c 10 f0 	movl   $0xf0108c04,(%esp)
f01009f2:	e8 30 3e 00 00       	call   f0104827 <cprintf>
		return 0;
f01009f7:	eb 5a                	jmp    f0100a53 <mon_chperm+0x79>
	}
	len = strlen(argv[1]);
f01009f9:	8b 43 04             	mov    0x4(%ebx),%eax
f01009fc:	89 04 24             	mov    %eax,(%esp)
f01009ff:	e8 1c 62 00 00       	call   f0106c20 <strlen>
	vaddr = (const void *)strtol(argv[1], ((argv+1)+len), 16);
f0100a04:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0100a0b:	00 
f0100a0c:	8d 44 83 04          	lea    0x4(%ebx,%eax,4),%eax
f0100a10:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a14:	8b 43 04             	mov    0x4(%ebx),%eax
f0100a17:	89 04 24             	mov    %eax,(%esp)
f0100a1a:	e8 b4 64 00 00       	call   f0106ed3 <strtol>
f0100a1f:	89 c6                	mov    %eax,%esi
	len = strlen(argv[2]);
f0100a21:	8b 43 08             	mov    0x8(%ebx),%eax
f0100a24:	89 04 24             	mov    %eax,(%esp)
f0100a27:	e8 f4 61 00 00       	call   f0106c20 <strlen>
	perm = strtol(argv[2], ((argv+2)+len), 0);
f0100a2c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100a33:	00 
f0100a34:	8d 44 83 08          	lea    0x8(%ebx,%eax,4),%eax
f0100a38:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a3c:	8b 43 08             	mov    0x8(%ebx),%eax
f0100a3f:	89 04 24             	mov    %eax,(%esp)
f0100a42:	e8 8c 64 00 00       	call   f0106ed3 <strtol>
	change_perm(vaddr, perm);
f0100a47:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a4b:	89 34 24             	mov    %esi,(%esp)
f0100a4e:	e8 8e 0c 00 00       	call   f01016e1 <change_perm>
	return 0;
}
f0100a53:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a58:	83 c4 10             	add    $0x10,%esp
f0100a5b:	5b                   	pop    %ebx
f0100a5c:	5e                   	pop    %esi
f0100a5d:	5d                   	pop    %ebp
f0100a5e:	c3                   	ret    

f0100a5f <mon_dump>:

int
mon_dump(int argc, char **argv, struct Trapframe *tf)
{
f0100a5f:	55                   	push   %ebp
f0100a60:	89 e5                	mov    %esp,%ebp
f0100a62:	56                   	push   %esi
f0100a63:	53                   	push   %ebx
f0100a64:	83 ec 10             	sub    $0x10,%esp
f0100a67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int len=0;
	const void *vaStart;
	const void *vaEnd;
	if(argc!=3){
f0100a6a:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100a6e:	74 0e                	je     f0100a7e <mon_dump+0x1f>
		cprintf("\nshowmappings only accepts single address range\n");
f0100a70:	c7 04 24 30 8c 10 f0 	movl   $0xf0108c30,(%esp)
f0100a77:	e8 ab 3d 00 00       	call   f0104827 <cprintf>
		return 0;
f0100a7c:	eb 5a                	jmp    f0100ad8 <mon_dump+0x79>
	}
	
	//cprintf("strol:%lu\n",strtol(argv[1], ((argv+1)+len), 16));
	//cprintf("strol:%lu\n",strtol(argv[2], ((argv+2)+len), 16));
	len = strlen(argv[1]);
f0100a7e:	8b 43 04             	mov    0x4(%ebx),%eax
f0100a81:	89 04 24             	mov    %eax,(%esp)
f0100a84:	e8 97 61 00 00       	call   f0106c20 <strlen>
	vaStart = (const void *)strtol(argv[1], ((argv+1)+len), 16);
f0100a89:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0100a90:	00 
f0100a91:	8d 44 83 04          	lea    0x4(%ebx,%eax,4),%eax
f0100a95:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a99:	8b 43 04             	mov    0x4(%ebx),%eax
f0100a9c:	89 04 24             	mov    %eax,(%esp)
f0100a9f:	e8 2f 64 00 00       	call   f0106ed3 <strtol>
f0100aa4:	89 c6                	mov    %eax,%esi
	len = strlen(argv[2]);
f0100aa6:	8b 43 08             	mov    0x8(%ebx),%eax
f0100aa9:	89 04 24             	mov    %eax,(%esp)
f0100aac:	e8 6f 61 00 00       	call   f0106c20 <strlen>
	vaEnd = (const void *)strtol(argv[2], ((argv+2)+len), 16);
f0100ab1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0100ab8:	00 
f0100ab9:	8d 44 83 08          	lea    0x8(%ebx,%eax,4),%eax
f0100abd:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ac1:	8b 43 08             	mov    0x8(%ebx),%eax
f0100ac4:	89 04 24             	mov    %eax,(%esp)
f0100ac7:	e8 07 64 00 00       	call   f0106ed3 <strtol>
	print_memval(vaStart, vaEnd);
f0100acc:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ad0:	89 34 24             	mov    %esi,(%esp)
f0100ad3:	e8 73 0b 00 00       	call   f010164b <print_memval>
	return 0;
}
f0100ad8:	b8 00 00 00 00       	mov    $0x0,%eax
f0100add:	83 c4 10             	add    $0x10,%esp
f0100ae0:	5b                   	pop    %ebx
f0100ae1:	5e                   	pop    %esi
f0100ae2:	5d                   	pop    %ebp
f0100ae3:	c3                   	ret    

f0100ae4 <mon_showmap>:
	return 0;
}

int
mon_showmap(int argc, char **argv, struct Trapframe *tf)
{
f0100ae4:	55                   	push   %ebp
f0100ae5:	89 e5                	mov    %esp,%ebp
f0100ae7:	56                   	push   %esi
f0100ae8:	53                   	push   %ebx
f0100ae9:	83 ec 10             	sub    $0x10,%esp
f0100aec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int len=0;
	const void *vaStart;
	const void *vaEnd;
	if(argc!=3){
f0100aef:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100af3:	74 0e                	je     f0100b03 <mon_showmap+0x1f>
		cprintf("\nshowmappings only accepts single address range\n");
f0100af5:	c7 04 24 30 8c 10 f0 	movl   $0xf0108c30,(%esp)
f0100afc:	e8 26 3d 00 00       	call   f0104827 <cprintf>
		return 0;
f0100b01:	eb 5a                	jmp    f0100b5d <mon_showmap+0x79>
	}
	
	//cprintf("strol:%lu\n",strtol(argv[1], ((argv+1)+len), 16));
	//cprintf("strol:%lu\n",strtol(argv[2], ((argv+2)+len), 16));
	len = strlen(argv[1]);
f0100b03:	8b 43 04             	mov    0x4(%ebx),%eax
f0100b06:	89 04 24             	mov    %eax,(%esp)
f0100b09:	e8 12 61 00 00       	call   f0106c20 <strlen>
	vaStart = (const void *)strtol(argv[1], ((argv+1)+len), 16);
f0100b0e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0100b15:	00 
f0100b16:	8d 44 83 04          	lea    0x4(%ebx,%eax,4),%eax
f0100b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b1e:	8b 43 04             	mov    0x4(%ebx),%eax
f0100b21:	89 04 24             	mov    %eax,(%esp)
f0100b24:	e8 aa 63 00 00       	call   f0106ed3 <strtol>
f0100b29:	89 c6                	mov    %eax,%esi
	len = strlen(argv[2]);
f0100b2b:	8b 43 08             	mov    0x8(%ebx),%eax
f0100b2e:	89 04 24             	mov    %eax,(%esp)
f0100b31:	e8 ea 60 00 00       	call   f0106c20 <strlen>
	vaEnd = (const void *)strtol(argv[2], ((argv+2)+len), 16);
f0100b36:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0100b3d:	00 
f0100b3e:	8d 44 83 08          	lea    0x8(%ebx,%eax,4),%eax
f0100b42:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b46:	8b 43 08             	mov    0x8(%ebx),%eax
f0100b49:	89 04 24             	mov    %eax,(%esp)
f0100b4c:	e8 82 63 00 00       	call   f0106ed3 <strtol>
	print_mapping(vaStart, vaEnd);
f0100b51:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b55:	89 34 24             	mov    %esi,(%esp)
f0100b58:	e8 24 0c 00 00       	call   f0101781 <print_mapping>

	return 0;
}
f0100b5d:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b62:	83 c4 10             	add    $0x10,%esp
f0100b65:	5b                   	pop    %ebx
f0100b66:	5e                   	pop    %esi
f0100b67:	5d                   	pop    %ebp
f0100b68:	c3                   	ret    

f0100b69 <mon_backtrace>:
	return (void *)*((uint32_t *)ebp+1);
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100b69:	55                   	push   %ebp
f0100b6a:	89 e5                	mov    %esp,%ebp
f0100b6c:	57                   	push   %edi
f0100b6d:	56                   	push   %esi
f0100b6e:	53                   	push   %ebx
f0100b6f:	83 ec 3c             	sub    $0x3c,%esp
	
	struct Eipdebuginfo info;
	void *ebp = (void *)read_ebp();
f0100b72:	89 ee                	mov    %ebp,%esi
	int i=0;
	int j=0;
	int inc=0;
	const char *p = NULL;
	cprintf("Stack backtrace:\n");
f0100b74:	c7 04 24 c2 89 10 f0 	movl   $0xf01089c2,(%esp)
f0100b7b:	e8 a7 3c 00 00       	call   f0104827 <cprintf>
	while(ebp!=NULL)
f0100b80:	e9 b6 00 00 00       	jmp    f0100c3b <mon_backtrace+0xd2>
	{
		debuginfo_eip(*((uint32_t *)ebp+1), &info);
f0100b85:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100b88:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b8c:	8b 46 04             	mov    0x4(%esi),%eax
f0100b8f:	89 04 24             	mov    %eax,(%esp)
f0100b92:	e8 7c 56 00 00       	call   f0106213 <debuginfo_eip>
		cprintf("\n");
f0100b97:	c7 04 24 16 8a 10 f0 	movl   $0xf0108a16,(%esp)
f0100b9e:	e8 84 3c 00 00       	call   f0104827 <cprintf>
		cprintf("ebp %x eip %x ",(uint32_t)ebp, (uint32_t)*((uint32_t *)ebp+1));
f0100ba3:	8b 46 04             	mov    0x4(%esi),%eax
f0100ba6:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100baa:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100bae:	c7 04 24 d4 89 10 f0 	movl   $0xf01089d4,(%esp)
f0100bb5:	e8 6d 3c 00 00       	call   f0104827 <cprintf>
		cprintf("args");
f0100bba:	c7 04 24 e3 89 10 f0 	movl   $0xf01089e3,(%esp)
f0100bc1:	e8 61 3c 00 00       	call   f0104827 <cprintf>
		//(info.eip_fn_narg+1-j))
		for(j=1;j<=5;j++)
f0100bc6:	bb 01 00 00 00       	mov    $0x1,%ebx
		{
			inc = (j+1);
f0100bcb:	83 c3 01             	add    $0x1,%ebx
			cprintf(" %08x",*((uint32_t *)ebp+inc));
f0100bce:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
f0100bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bd5:	c7 04 24 e8 89 10 f0 	movl   $0xf01089e8,(%esp)
f0100bdc:	e8 46 3c 00 00       	call   f0104827 <cprintf>
		debuginfo_eip(*((uint32_t *)ebp+1), &info);
		cprintf("\n");
		cprintf("ebp %x eip %x ",(uint32_t)ebp, (uint32_t)*((uint32_t *)ebp+1));
		cprintf("args");
		//(info.eip_fn_narg+1-j))
		for(j=1;j<=5;j++)
f0100be1:	83 fb 06             	cmp    $0x6,%ebx
f0100be4:	75 e5                	jne    f0100bcb <mon_backtrace+0x62>
		{
			inc = (j+1);
			cprintf(" %08x",*((uint32_t *)ebp+inc));
		}
		cprintf("\n         %s:%d:  ",info.eip_file, info.eip_line);
f0100be6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100be9:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100bed:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bf4:	c7 04 24 ee 89 10 f0 	movl   $0xf01089ee,(%esp)
f0100bfb:	e8 27 3c 00 00       	call   f0104827 <cprintf>
		p = info.eip_fn_name;
f0100c00:	8b 7d d8             	mov    -0x28(%ebp),%edi
		for(i=0;i<info.eip_fn_namelen;i++,p++)
f0100c03:	b3 00                	mov    $0x0,%bl
f0100c05:	eb 17                	jmp    f0100c1e <mon_backtrace+0xb5>
			cprintf("%c",*p);
f0100c07:	0f be 04 1f          	movsbl (%edi,%ebx,1),%eax
f0100c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100c0f:	c7 04 24 01 8a 10 f0 	movl   $0xf0108a01,(%esp)
f0100c16:	e8 0c 3c 00 00       	call   f0104827 <cprintf>
			inc = (j+1);
			cprintf(" %08x",*((uint32_t *)ebp+inc));
		}
		cprintf("\n         %s:%d:  ",info.eip_file, info.eip_line);
		p = info.eip_fn_name;
		for(i=0;i<info.eip_fn_namelen;i++,p++)
f0100c1b:	83 c3 01             	add    $0x1,%ebx
f0100c1e:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
f0100c21:	7c e4                	jl     f0100c07 <mon_backtrace+0x9e>
			cprintf("%c",*p);
		cprintf("+%d", (uint32_t)*((uint32_t *)ebp+1)-info.eip_fn_addr);
f0100c23:	8b 46 04             	mov    0x4(%esi),%eax
f0100c26:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100c29:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100c2d:	c7 04 24 04 8a 10 f0 	movl   $0xf0108a04,(%esp)
f0100c34:	e8 ee 3b 00 00       	call   f0104827 <cprintf>
		ebp = (void *)*(uint32_t *)ebp;
f0100c39:	8b 36                	mov    (%esi),%esi
	int i=0;
	int j=0;
	int inc=0;
	const char *p = NULL;
	cprintf("Stack backtrace:\n");
	while(ebp!=NULL)
f0100c3b:	85 f6                	test   %esi,%esi
f0100c3d:	0f 85 42 ff ff ff    	jne    f0100b85 <mon_backtrace+0x1c>
		for(i=0;i<info.eip_fn_namelen;i++,p++)
			cprintf("%c",*p);
		cprintf("+%d", (uint32_t)*((uint32_t *)ebp+1)-info.eip_fn_addr);
		ebp = (void *)*(uint32_t *)ebp;
	}
	cprintf("\n");
f0100c43:	c7 04 24 16 8a 10 f0 	movl   $0xf0108a16,(%esp)
f0100c4a:	e8 d8 3b 00 00       	call   f0104827 <cprintf>
	return 0;
}
f0100c4f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c54:	83 c4 3c             	add    $0x3c,%esp
f0100c57:	5b                   	pop    %ebx
f0100c58:	5e                   	pop    %esi
f0100c59:	5f                   	pop    %edi
f0100c5a:	5d                   	pop    %ebp
f0100c5b:	c3                   	ret    

f0100c5c <geteip>:

	return 0;
}

void *geteip(void)
{
f0100c5c:	55                   	push   %ebp
f0100c5d:	89 e5                	mov    %esp,%ebp
f0100c5f:	53                   	push   %ebx
f0100c60:	83 ec 14             	sub    $0x14,%esp

static __inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	__asm __volatile("movl %%ebp,%0" : "=r" (ebp));
f0100c63:	89 eb                	mov    %ebp,%ebx
	void *ebp = (void *)read_ebp();
	cprintf("geteip:ebp:%x\n\n",(uint32_t)ebp);
f0100c65:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100c69:	c7 04 24 08 8a 10 f0 	movl   $0xf0108a08,(%esp)
f0100c70:	e8 b2 3b 00 00       	call   f0104827 <cprintf>
	return (void *)*((uint32_t *)ebp+1);
f0100c75:	8b 43 04             	mov    0x4(%ebx),%eax
}
f0100c78:	83 c4 14             	add    $0x14,%esp
f0100c7b:	5b                   	pop    %ebx
f0100c7c:	5d                   	pop    %ebp
f0100c7d:	c3                   	ret    

f0100c7e <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100c7e:	55                   	push   %ebp
f0100c7f:	89 e5                	mov    %esp,%ebp
f0100c81:	57                   	push   %edi
f0100c82:	56                   	push   %esi
f0100c83:	53                   	push   %ebx
f0100c84:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100c87:	c7 04 24 64 8c 10 f0 	movl   $0xf0108c64,(%esp)
f0100c8e:	e8 94 3b 00 00       	call   f0104827 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100c93:	c7 04 24 88 8c 10 f0 	movl   $0xf0108c88,(%esp)
f0100c9a:	e8 88 3b 00 00       	call   f0104827 <cprintf>

	if (tf != NULL)
f0100c9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100ca3:	74 0b                	je     f0100cb0 <monitor+0x32>
		print_trapframe(tf);
f0100ca5:	8b 45 08             	mov    0x8(%ebp),%eax
f0100ca8:	89 04 24             	mov    %eax,(%esp)
f0100cab:	e8 2d 43 00 00       	call   f0104fdd <print_trapframe>

	while (1) {
		buf = readline("K> ");
f0100cb0:	c7 04 24 18 8a 10 f0 	movl   $0xf0108a18,(%esp)
f0100cb7:	e8 84 5e 00 00       	call   f0106b40 <readline>
f0100cbc:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100cbe:	85 c0                	test   %eax,%eax
f0100cc0:	74 ee                	je     f0100cb0 <monitor+0x32>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100cc2:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f0100cc9:	be 00 00 00 00       	mov    $0x0,%esi
f0100cce:	eb 0a                	jmp    f0100cda <monitor+0x5c>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0100cd0:	c6 03 00             	movb   $0x0,(%ebx)
f0100cd3:	89 f7                	mov    %esi,%edi
f0100cd5:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100cd8:	89 fe                	mov    %edi,%esi
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100cda:	0f b6 03             	movzbl (%ebx),%eax
f0100cdd:	84 c0                	test   %al,%al
f0100cdf:	74 63                	je     f0100d44 <monitor+0xc6>
f0100ce1:	0f be c0             	movsbl %al,%eax
f0100ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ce8:	c7 04 24 1c 8a 10 f0 	movl   $0xf0108a1c,(%esp)
f0100cef:	e8 76 60 00 00       	call   f0106d6a <strchr>
f0100cf4:	85 c0                	test   %eax,%eax
f0100cf6:	75 d8                	jne    f0100cd0 <monitor+0x52>
			*buf++ = 0;
		if (*buf == 0)
f0100cf8:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100cfb:	74 47                	je     f0100d44 <monitor+0xc6>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100cfd:	83 fe 0f             	cmp    $0xf,%esi
f0100d00:	75 16                	jne    f0100d18 <monitor+0x9a>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100d02:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100d09:	00 
f0100d0a:	c7 04 24 21 8a 10 f0 	movl   $0xf0108a21,(%esp)
f0100d11:	e8 11 3b 00 00       	call   f0104827 <cprintf>
f0100d16:	eb 98                	jmp    f0100cb0 <monitor+0x32>
			return 0;
		}
		argv[argc++] = buf;
f0100d18:	8d 7e 01             	lea    0x1(%esi),%edi
f0100d1b:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100d1f:	eb 03                	jmp    f0100d24 <monitor+0xa6>
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
f0100d21:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f0100d24:	0f b6 03             	movzbl (%ebx),%eax
f0100d27:	84 c0                	test   %al,%al
f0100d29:	74 ad                	je     f0100cd8 <monitor+0x5a>
f0100d2b:	0f be c0             	movsbl %al,%eax
f0100d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100d32:	c7 04 24 1c 8a 10 f0 	movl   $0xf0108a1c,(%esp)
f0100d39:	e8 2c 60 00 00       	call   f0106d6a <strchr>
f0100d3e:	85 c0                	test   %eax,%eax
f0100d40:	74 df                	je     f0100d21 <monitor+0xa3>
f0100d42:	eb 94                	jmp    f0100cd8 <monitor+0x5a>
			buf++;
	}
	argv[argc] = 0;
f0100d44:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100d4b:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100d4c:	85 f6                	test   %esi,%esi
f0100d4e:	0f 84 5c ff ff ff    	je     f0100cb0 <monitor+0x32>
f0100d54:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100d59:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100d5c:	8b 04 85 60 8d 10 f0 	mov    -0xfef72a0(,%eax,4),%eax
f0100d63:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100d67:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100d6a:	89 04 24             	mov    %eax,(%esp)
f0100d6d:	e8 9a 5f 00 00       	call   f0106d0c <strcmp>
f0100d72:	85 c0                	test   %eax,%eax
f0100d74:	75 24                	jne    f0100d9a <monitor+0x11c>
			return commands[i].func(argc, argv, tf);
f0100d76:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100d79:	8b 55 08             	mov    0x8(%ebp),%edx
f0100d7c:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100d80:	8d 4d a8             	lea    -0x58(%ebp),%ecx
f0100d83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100d87:	89 34 24             	mov    %esi,(%esp)
f0100d8a:	ff 14 85 68 8d 10 f0 	call   *-0xfef7298(,%eax,4)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f0100d91:	85 c0                	test   %eax,%eax
f0100d93:	78 25                	js     f0100dba <monitor+0x13c>
f0100d95:	e9 16 ff ff ff       	jmp    f0100cb0 <monitor+0x32>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
f0100d9a:	83 c3 01             	add    $0x1,%ebx
f0100d9d:	83 fb 09             	cmp    $0x9,%ebx
f0100da0:	75 b7                	jne    f0100d59 <monitor+0xdb>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100da2:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100da5:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100da9:	c7 04 24 3e 8a 10 f0 	movl   $0xf0108a3e,(%esp)
f0100db0:	e8 72 3a 00 00       	call   f0104827 <cprintf>
f0100db5:	e9 f6 fe ff ff       	jmp    f0100cb0 <monitor+0x32>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100dba:	83 c4 5c             	add    $0x5c,%esp
f0100dbd:	5b                   	pop    %ebx
f0100dbe:	5e                   	pop    %esi
f0100dbf:	5f                   	pop    %edi
f0100dc0:	5d                   	pop    %ebp
f0100dc1:	c3                   	ret    
f0100dc2:	66 90                	xchg   %ax,%ax
f0100dc4:	66 90                	xchg   %ax,%ax
f0100dc6:	66 90                	xchg   %ax,%ax
f0100dc8:	66 90                	xchg   %ax,%ax
f0100dca:	66 90                	xchg   %ax,%ax
f0100dcc:	66 90                	xchg   %ax,%ax
f0100dce:	66 90                	xchg   %ax,%ax

f0100dd0 <boot_alloc>:
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100dd0:	8b 15 38 32 2c f0    	mov    0xf02c3238,%edx
f0100dd6:	85 d2                	test   %edx,%edx
f0100dd8:	75 37                	jne    f0100e11 <boot_alloc+0x41>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100dda:	ba 1f 67 37 f0       	mov    $0xf037671f,%edx
f0100ddf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100de5:	89 15 38 32 2c f0    	mov    %edx,0xf02c3238
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.


	if(nextfree==(char *)0x100000000)
f0100deb:	85 d2                	test   %edx,%edx
f0100ded:	75 22                	jne    f0100e11 <boot_alloc+0x41>
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100def:	55                   	push   %ebp
f0100df0:	89 e5                	mov    %esp,%ebp
f0100df2:	83 ec 18             	sub    $0x18,%esp
	//
	// LAB 2: Your code here.


	if(nextfree==(char *)0x100000000)
		panic("boot alloc out of memory!!!");
f0100df5:	c7 44 24 08 cc 8d 10 	movl   $0xf0108dcc,0x8(%esp)
f0100dfc:	f0 
f0100dfd:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
f0100e04:	00 
f0100e05:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0100e0c:	e8 8c f2 ff ff       	call   f010009d <_panic>
	if(n==0)
f0100e11:	85 c0                	test   %eax,%eax
f0100e13:	74 11                	je     f0100e26 <boot_alloc+0x56>
		result = nextfree;
	else if(n>0)
	{
		result = nextfree;
		n_pages = (n/PGSIZE) + 1;
f0100e15:	25 00 f0 ff ff       	and    $0xfffff000,%eax
		nextfree = nextfree + (PGSIZE*n_pages);
f0100e1a:	8d 84 02 00 10 00 00 	lea    0x1000(%edx,%eax,1),%eax
f0100e21:	a3 38 32 2c f0       	mov    %eax,0xf02c3238
	}

	return result;
}
f0100e26:	89 d0                	mov    %edx,%eax
f0100e28:	c3                   	ret    

f0100e29 <page2kva>:
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100e29:	2b 05 a4 3e 2c f0    	sub    0xf02c3ea4,%eax
f0100e2f:	c1 f8 03             	sar    $0x3,%eax
f0100e32:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100e35:	89 c2                	mov    %eax,%edx
f0100e37:	c1 ea 0c             	shr    $0xc,%edx
f0100e3a:	3b 15 9c 3e 2c f0    	cmp    0xf02c3e9c,%edx
f0100e40:	72 26                	jb     f0100e68 <page2kva+0x3f>
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
f0100e42:	55                   	push   %ebp
f0100e43:	89 e5                	mov    %esp,%ebp
f0100e45:	83 ec 18             	sub    $0x18,%esp

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100e48:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100e4c:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0100e53:	f0 
f0100e54:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
f0100e5b:	00 
f0100e5c:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0100e63:	e8 35 f2 ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0100e68:	2d 00 00 00 10       	sub    $0x10000000,%eax

static inline void*
page2kva(struct PageInfo *pp)
{
	return KADDR(page2pa(pp));
}
f0100e6d:	c3                   	ret    

f0100e6e <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100e6e:	89 d1                	mov    %edx,%ecx
f0100e70:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100e73:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100e76:	a8 01                	test   $0x1,%al
f0100e78:	74 5d                	je     f0100ed7 <check_va2pa+0x69>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100e7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100e7f:	89 c1                	mov    %eax,%ecx
f0100e81:	c1 e9 0c             	shr    $0xc,%ecx
f0100e84:	3b 0d 9c 3e 2c f0    	cmp    0xf02c3e9c,%ecx
f0100e8a:	72 26                	jb     f0100eb2 <check_va2pa+0x44>
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100e8c:	55                   	push   %ebp
f0100e8d:	89 e5                	mov    %esp,%ebp
f0100e8f:	83 ec 18             	sub    $0x18,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100e92:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100e96:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0100e9d:	f0 
f0100e9e:	c7 44 24 04 b5 04 00 	movl   $0x4b5,0x4(%esp)
f0100ea5:	00 
f0100ea6:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0100ead:	e8 eb f1 ff ff       	call   f010009d <_panic>

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
f0100eb2:	c1 ea 0c             	shr    $0xc,%edx
f0100eb5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100ebb:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100ec2:	89 c2                	mov    %eax,%edx
f0100ec4:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100ec7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ecc:	85 d2                	test   %edx,%edx
f0100ece:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100ed3:	0f 44 c2             	cmove  %edx,%eax
f0100ed6:	c3                   	ret    
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
f0100ed7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
}
f0100edc:	c3                   	ret    

f0100edd <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f0100edd:	55                   	push   %ebp
f0100ede:	89 e5                	mov    %esp,%ebp
f0100ee0:	57                   	push   %edi
f0100ee1:	56                   	push   %esi
f0100ee2:	53                   	push   %ebx
f0100ee3:	83 ec 4c             	sub    $0x4c,%esp
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ee6:	84 c0                	test   %al,%al
f0100ee8:	0f 85 31 03 00 00    	jne    f010121f <check_page_free_list+0x342>
f0100eee:	e9 3e 03 00 00       	jmp    f0101231 <check_page_free_list+0x354>
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
		panic("'page_free_list' is a null pointer!");
f0100ef3:	c7 44 24 08 28 91 10 	movl   $0xf0109128,0x8(%esp)
f0100efa:	f0 
f0100efb:	c7 44 24 04 e5 03 00 	movl   $0x3e5,0x4(%esp)
f0100f02:	00 
f0100f03:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0100f0a:	e8 8e f1 ff ff       	call   f010009d <_panic>

	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100f0f:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100f12:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100f15:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100f18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100f1b:	89 c2                	mov    %eax,%edx
f0100f1d:	2b 15 a4 3e 2c f0    	sub    0xf02c3ea4,%edx
		for (pp = page_free_list; pp; pp = pp->pp_link) {
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100f23:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100f29:	0f 95 c2             	setne  %dl
f0100f2c:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100f2f:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100f33:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100f35:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f39:	8b 00                	mov    (%eax),%eax
f0100f3b:	85 c0                	test   %eax,%eax
f0100f3d:	75 dc                	jne    f0100f1b <check_page_free_list+0x3e>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
f0100f3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100f42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100f4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100f4e:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100f50:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100f53:	a3 40 32 2c f0       	mov    %eax,0xf02c3240
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100f58:	be 01 00 00 00       	mov    $0x1,%esi
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100f5d:	8b 1d 40 32 2c f0    	mov    0xf02c3240,%ebx
f0100f63:	eb 63                	jmp    f0100fc8 <check_page_free_list+0xeb>
f0100f65:	89 d8                	mov    %ebx,%eax
f0100f67:	2b 05 a4 3e 2c f0    	sub    0xf02c3ea4,%eax
f0100f6d:	c1 f8 03             	sar    $0x3,%eax
f0100f70:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100f73:	89 c2                	mov    %eax,%edx
f0100f75:	c1 ea 16             	shr    $0x16,%edx
f0100f78:	39 f2                	cmp    %esi,%edx
f0100f7a:	73 4a                	jae    f0100fc6 <check_page_free_list+0xe9>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100f7c:	89 c2                	mov    %eax,%edx
f0100f7e:	c1 ea 0c             	shr    $0xc,%edx
f0100f81:	3b 15 9c 3e 2c f0    	cmp    0xf02c3e9c,%edx
f0100f87:	72 20                	jb     f0100fa9 <check_page_free_list+0xcc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f89:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100f8d:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0100f94:	f0 
f0100f95:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
f0100f9c:	00 
f0100f9d:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0100fa4:	e8 f4 f0 ff ff       	call   f010009d <_panic>
			memset(page2kva(pp), 0x97, 128);
f0100fa9:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
f0100fb0:	00 
f0100fb1:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f0100fb8:	00 
	return (void *)(pa + KERNBASE);
f0100fb9:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100fbe:	89 04 24             	mov    %eax,(%esp)
f0100fc1:	e8 e1 5d 00 00       	call   f0106da7 <memset>
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100fc6:	8b 1b                	mov    (%ebx),%ebx
f0100fc8:	85 db                	test   %ebx,%ebx
f0100fca:	75 99                	jne    f0100f65 <check_page_free_list+0x88>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f0100fcc:	b8 00 00 00 00       	mov    $0x0,%eax
f0100fd1:	e8 fa fd ff ff       	call   f0100dd0 <boot_alloc>
f0100fd6:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100fd9:	8b 15 40 32 2c f0    	mov    0xf02c3240,%edx
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0100fdf:	8b 0d a4 3e 2c f0    	mov    0xf02c3ea4,%ecx
		assert(pp < pages + npages);
f0100fe5:	a1 9c 3e 2c f0       	mov    0xf02c3e9c,%eax
f0100fea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0100fed:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
f0100ff0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100ff3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f0100ff6:	bf 00 00 00 00       	mov    $0x0,%edi
f0100ffb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100ffe:	e9 c4 01 00 00       	jmp    f01011c7 <check_page_free_list+0x2ea>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0101003:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
f0101006:	73 24                	jae    f010102c <check_page_free_list+0x14f>
f0101008:	c7 44 24 0c 02 8e 10 	movl   $0xf0108e02,0xc(%esp)
f010100f:	f0 
f0101010:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101017:	f0 
f0101018:	c7 44 24 04 ff 03 00 	movl   $0x3ff,0x4(%esp)
f010101f:	00 
f0101020:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101027:	e8 71 f0 ff ff       	call   f010009d <_panic>
		assert(pp < pages + npages);
f010102c:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f010102f:	72 24                	jb     f0101055 <check_page_free_list+0x178>
f0101031:	c7 44 24 0c 23 8e 10 	movl   $0xf0108e23,0xc(%esp)
f0101038:	f0 
f0101039:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101040:	f0 
f0101041:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
f0101048:	00 
f0101049:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101050:	e8 48 f0 ff ff       	call   f010009d <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101055:	89 d0                	mov    %edx,%eax
f0101057:	2b 45 cc             	sub    -0x34(%ebp),%eax
f010105a:	a8 07                	test   $0x7,%al
f010105c:	74 24                	je     f0101082 <check_page_free_list+0x1a5>
f010105e:	c7 44 24 0c 4c 91 10 	movl   $0xf010914c,0xc(%esp)
f0101065:	f0 
f0101066:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010106d:	f0 
f010106e:	c7 44 24 04 01 04 00 	movl   $0x401,0x4(%esp)
f0101075:	00 
f0101076:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010107d:	e8 1b f0 ff ff       	call   f010009d <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101082:	c1 f8 03             	sar    $0x3,%eax
f0101085:	c1 e0 0c             	shl    $0xc,%eax

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f0101088:	85 c0                	test   %eax,%eax
f010108a:	75 24                	jne    f01010b0 <check_page_free_list+0x1d3>
f010108c:	c7 44 24 0c 37 8e 10 	movl   $0xf0108e37,0xc(%esp)
f0101093:	f0 
f0101094:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010109b:	f0 
f010109c:	c7 44 24 04 04 04 00 	movl   $0x404,0x4(%esp)
f01010a3:	00 
f01010a4:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01010ab:	e8 ed ef ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f01010b0:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f01010b5:	75 24                	jne    f01010db <check_page_free_list+0x1fe>
f01010b7:	c7 44 24 0c 48 8e 10 	movl   $0xf0108e48,0xc(%esp)
f01010be:	f0 
f01010bf:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01010c6:	f0 
f01010c7:	c7 44 24 04 05 04 00 	movl   $0x405,0x4(%esp)
f01010ce:	00 
f01010cf:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01010d6:	e8 c2 ef ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f01010db:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f01010e0:	75 24                	jne    f0101106 <check_page_free_list+0x229>
f01010e2:	c7 44 24 0c 80 91 10 	movl   $0xf0109180,0xc(%esp)
f01010e9:	f0 
f01010ea:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01010f1:	f0 
f01010f2:	c7 44 24 04 06 04 00 	movl   $0x406,0x4(%esp)
f01010f9:	00 
f01010fa:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101101:	e8 97 ef ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101106:	3d 00 00 10 00       	cmp    $0x100000,%eax
f010110b:	75 24                	jne    f0101131 <check_page_free_list+0x254>
f010110d:	c7 44 24 0c 61 8e 10 	movl   $0xf0108e61,0xc(%esp)
f0101114:	f0 
f0101115:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010111c:	f0 
f010111d:	c7 44 24 04 07 04 00 	movl   $0x407,0x4(%esp)
f0101124:	00 
f0101125:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010112c:	e8 6c ef ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101131:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0101136:	0f 86 1c 01 00 00    	jbe    f0101258 <check_page_free_list+0x37b>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010113c:	89 c1                	mov    %eax,%ecx
f010113e:	c1 e9 0c             	shr    $0xc,%ecx
f0101141:	39 4d c4             	cmp    %ecx,-0x3c(%ebp)
f0101144:	77 20                	ja     f0101166 <check_page_free_list+0x289>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101146:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010114a:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0101151:	f0 
f0101152:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
f0101159:	00 
f010115a:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0101161:	e8 37 ef ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0101166:	8d 88 00 00 00 f0    	lea    -0x10000000(%eax),%ecx
f010116c:	39 4d c8             	cmp    %ecx,-0x38(%ebp)
f010116f:	0f 86 d3 00 00 00    	jbe    f0101248 <check_page_free_list+0x36b>
f0101175:	c7 44 24 0c a4 91 10 	movl   $0xf01091a4,0xc(%esp)
f010117c:	f0 
f010117d:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101184:	f0 
f0101185:	c7 44 24 04 08 04 00 	movl   $0x408,0x4(%esp)
f010118c:	00 
f010118d:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101194:	e8 04 ef ff ff       	call   f010009d <_panic>
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f0101199:	c7 44 24 0c 7b 8e 10 	movl   $0xf0108e7b,0xc(%esp)
f01011a0:	f0 
f01011a1:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01011a8:	f0 
f01011a9:	c7 44 24 04 0a 04 00 	movl   $0x40a,0x4(%esp)
f01011b0:	00 
f01011b1:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01011b8:	e8 e0 ee ff ff       	call   f010009d <_panic>

		if (page2pa(pp) < EXTPHYSMEM)
			++nfree_basemem;
f01011bd:	83 c3 01             	add    $0x1,%ebx
f01011c0:	eb 03                	jmp    f01011c5 <check_page_free_list+0x2e8>
		else
			++nfree_extmem;
f01011c2:	83 c7 01             	add    $0x1,%edi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01011c5:	8b 12                	mov    (%edx),%edx
f01011c7:	85 d2                	test   %edx,%edx
f01011c9:	0f 85 34 fe ff ff    	jne    f0101003 <check_page_free_list+0x126>
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
f01011cf:	85 db                	test   %ebx,%ebx
f01011d1:	7f 24                	jg     f01011f7 <check_page_free_list+0x31a>
f01011d3:	c7 44 24 0c 98 8e 10 	movl   $0xf0108e98,0xc(%esp)
f01011da:	f0 
f01011db:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01011e2:	f0 
f01011e3:	c7 44 24 04 12 04 00 	movl   $0x412,0x4(%esp)
f01011ea:	00 
f01011eb:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01011f2:	e8 a6 ee ff ff       	call   f010009d <_panic>
	assert(nfree_extmem > 0);
f01011f7:	85 ff                	test   %edi,%edi
f01011f9:	7f 6d                	jg     f0101268 <check_page_free_list+0x38b>
f01011fb:	c7 44 24 0c aa 8e 10 	movl   $0xf0108eaa,0xc(%esp)
f0101202:	f0 
f0101203:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010120a:	f0 
f010120b:	c7 44 24 04 13 04 00 	movl   $0x413,0x4(%esp)
f0101212:	00 
f0101213:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010121a:	e8 7e ee ff ff       	call   f010009d <_panic>
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f010121f:	a1 40 32 2c f0       	mov    0xf02c3240,%eax
f0101224:	85 c0                	test   %eax,%eax
f0101226:	0f 85 e3 fc ff ff    	jne    f0100f0f <check_page_free_list+0x32>
f010122c:	e9 c2 fc ff ff       	jmp    f0100ef3 <check_page_free_list+0x16>
f0101231:	83 3d 40 32 2c f0 00 	cmpl   $0x0,0xf02c3240
f0101238:	0f 84 b5 fc ff ff    	je     f0100ef3 <check_page_free_list+0x16>
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f010123e:	be 00 04 00 00       	mov    $0x400,%esi
f0101243:	e9 15 fd ff ff       	jmp    f0100f5d <check_page_free_list+0x80>
		assert(page2pa(pp) != IOPHYSMEM);
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
		assert(page2pa(pp) != EXTPHYSMEM);
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f0101248:	3d 00 70 00 00       	cmp    $0x7000,%eax
f010124d:	0f 85 6f ff ff ff    	jne    f01011c2 <check_page_free_list+0x2e5>
f0101253:	e9 41 ff ff ff       	jmp    f0101199 <check_page_free_list+0x2bc>
f0101258:	3d 00 70 00 00       	cmp    $0x7000,%eax
f010125d:	0f 85 5a ff ff ff    	jne    f01011bd <check_page_free_list+0x2e0>
f0101263:	e9 31 ff ff ff       	jmp    f0101199 <check_page_free_list+0x2bc>
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
	assert(nfree_extmem > 0);
}
f0101268:	83 c4 4c             	add    $0x4c,%esp
f010126b:	5b                   	pop    %ebx
f010126c:	5e                   	pop    %esi
f010126d:	5f                   	pop    %edi
f010126e:	5d                   	pop    %ebp
f010126f:	c3                   	ret    

f0101270 <print_kerndir>:
	//print_mapping((void *)KSTACKTOP-KSTKSIZE, (void *)KSTACKTOP);
	//print_mapping((void *)0xf0000000, (void *)0xf0007000);
}

void print_kerndir(pde_t *pgdir)
{
f0101270:	55                   	push   %ebp
f0101271:	89 e5                	mov    %esp,%ebp
f0101273:	56                   	push   %esi
f0101274:	53                   	push   %ebx
f0101275:	83 ec 10             	sub    $0x10,%esp
f0101278:	8b 45 08             	mov    0x8(%ebp),%eax
f010127b:	8d b0 10 0e 00 00    	lea    0xe10(%eax),%esi
	int i=0;
	for(i=900;i<1023;i++)
f0101281:	bb 84 03 00 00       	mov    $0x384,%ebx
		cprintf("\nentry:%d address: %p value: %p",i, (pgdir+i),*(pgdir+i));
f0101286:	8b 06                	mov    (%esi),%eax
f0101288:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010128c:	89 74 24 08          	mov    %esi,0x8(%esp)
f0101290:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101294:	c7 04 24 ec 91 10 f0 	movl   $0xf01091ec,(%esp)
f010129b:	e8 87 35 00 00       	call   f0104827 <cprintf>
}

void print_kerndir(pde_t *pgdir)
{
	int i=0;
	for(i=900;i<1023;i++)
f01012a0:	83 c3 01             	add    $0x1,%ebx
f01012a3:	83 c6 04             	add    $0x4,%esi
f01012a6:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
f01012ac:	75 d8                	jne    f0101286 <print_kerndir+0x16>
		cprintf("\nentry:%d address: %p value: %p",i, (pgdir+i),*(pgdir+i));
}
f01012ae:	83 c4 10             	add    $0x10,%esp
f01012b1:	5b                   	pop    %ebx
f01012b2:	5e                   	pop    %esi
f01012b3:	5d                   	pop    %ebp
f01012b4:	c3                   	ret    

f01012b5 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f01012b5:	55                   	push   %ebp
f01012b6:	89 e5                	mov    %esp,%ebp
f01012b8:	56                   	push   %esi
f01012b9:	53                   	push   %ebx
f01012ba:	83 ec 10             	sub    $0x10,%esp
	// LAB 4:
	// Change your code to mark the physical page at MPENTRY_PADDR
	// as in use

	struct PageInfo *temp,*temp1,*temp2,*temp3, *mpentry;
	page_free_list = pages;
f01012bd:	a1 a4 3e 2c f0       	mov    0xf02c3ea4,%eax
f01012c2:	a3 40 32 2c f0       	mov    %eax,0xf02c3240
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!

	size_t i, range;
	for (i = 0; i < npages-1; i++) {
f01012c7:	b8 00 00 00 00       	mov    $0x0,%eax
f01012cc:	eb 1e                	jmp    f01012ec <page_init+0x37>
		pages[i].pp_ref = 0;
f01012ce:	8b 0d a4 3e 2c f0    	mov    0xf02c3ea4,%ecx
f01012d4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f01012db:	66 c7 44 11 04 00 00 	movw   $0x0,0x4(%ecx,%edx,1)
		pages[i].pp_link = &pages[i+1];
f01012e2:	83 c0 01             	add    $0x1,%eax
f01012e5:	8d 5c 11 08          	lea    0x8(%ecx,%edx,1),%ebx
f01012e9:	89 1c 11             	mov    %ebx,(%ecx,%edx,1)
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!

	size_t i, range;
	for (i = 0; i < npages-1; i++) {
f01012ec:	8b 15 9c 3e 2c f0    	mov    0xf02c3e9c,%edx
f01012f2:	8d 4a ff             	lea    -0x1(%edx),%ecx
f01012f5:	39 c8                	cmp    %ecx,%eax
f01012f7:	72 d5                	jb     f01012ce <page_init+0x19>
		pages[i].pp_ref = 0;
		pages[i].pp_link = &pages[i+1];
	}
	pages[npages-1].pp_ref = 0;
f01012f9:	a1 a4 3e 2c f0       	mov    0xf02c3ea4,%eax
f01012fe:	8d 44 d0 f8          	lea    -0x8(%eax,%edx,8),%eax
f0101302:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	pages[npages-1].pp_link = NULL;
f0101308:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	page_free_list = pages;
f010130e:	a1 a4 3e 2c f0       	mov    0xf02c3ea4,%eax
	
	// marking page 0 as busy. case 1
	page_free_list->pp_ref = 1;
f0101313:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	temp = page_free_list;
	page_free_list = temp->pp_link;
f0101319:	8b 10                	mov    (%eax),%edx
f010131b:	89 15 40 32 2c f0    	mov    %edx,0xf02c3240
	temp->pp_link=NULL;
f0101321:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101327:	83 3d 9c 3e 2c f0 07 	cmpl   $0x7,0xf02c3e9c
f010132e:	77 1c                	ja     f010134c <page_init+0x97>
		panic("pa2page called with invalid pa");
f0101330:	c7 44 24 08 0c 92 10 	movl   $0xf010920c,0x8(%esp)
f0101337:	f0 
f0101338:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
f010133f:	00 
f0101340:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0101347:	e8 51 ed ff ff       	call   f010009d <_panic>
	return &pages[PGNUM(pa)];
f010134c:	a1 a4 3e 2c f0       	mov    0xf02c3ea4,%eax

	//marking MPENTRY_PADDR as busy page. This page is present in basemem pages

	mpentry = pa2page(MPENTRY_PADDR);
	(mpentry-1)->pp_link = mpentry->pp_link;
f0101351:	8b 48 38             	mov    0x38(%eax),%ecx
f0101354:	89 48 30             	mov    %ecx,0x30(%eax)
	mpentry->pp_link = NULL;
f0101357:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	mpentry->pp_ref = 1;
f010135e:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)

	//case 2

	temp = page_free_list + npages_basemem-2;
f0101364:	a1 44 32 2c f0       	mov    0xf02c3244,%eax
f0101369:	8d 5c c2 f0          	lea    -0x10(%edx,%eax,8),%ebx
	//temp is last free block in base memory
	temp1 = temp->pp_link;
f010136d:	8b 03                	mov    (%ebx),%eax
f010136f:	ba 5f 00 00 00       	mov    $0x5f,%edx

	//case 3
	range = (EXTPHYSMEM - IOPHYSMEM) / (PGSIZE);
	for(i=0;i<range-1;i++)
	{
		temp2=temp1->pp_link;
f0101374:	8b 08                	mov    (%eax),%ecx
		temp1->pp_link = NULL;
f0101376:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		temp1->pp_ref = 1;
f010137c:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	temp1 = temp->pp_link;


	//case 3
	range = (EXTPHYSMEM - IOPHYSMEM) / (PGSIZE);
	for(i=0;i<range-1;i++)
f0101382:	83 ea 01             	sub    $0x1,%edx
f0101385:	74 04                	je     f010138b <page_init+0xd6>
	{
		temp2=temp1->pp_link;
f0101387:	89 c8                	mov    %ecx,%eax
f0101389:	eb e9                	jmp    f0101374 <page_init+0xbf>
		temp1->pp_link = NULL;
		temp1->pp_ref = 1;
		temp1 = temp2;
	}
	temp2 = temp1->pp_link;
f010138b:	8b 31                	mov    (%ecx),%esi
	temp1->pp_link = NULL;
f010138d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	temp1->pp_ref = 1;
f0101393:	66 c7 41 04 01 00    	movw   $0x1,0x4(%ecx)
	temp1 = temp2;
	
	//case 4
	range = ((uint32_t) boot_alloc(0) - (uint32_t)KADDR(EXTPHYSMEM))/ (PGSIZE);
f0101399:	b8 00 00 00 00       	mov    $0x0,%eax
f010139e:	e8 2d fa ff ff       	call   f0100dd0 <boot_alloc>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01013a3:	81 3d 9c 3e 2c f0 00 	cmpl   $0x100,0xf02c3e9c
f01013aa:	01 00 00 
f01013ad:	77 24                	ja     f01013d3 <page_init+0x11e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01013af:	c7 44 24 0c 00 00 10 	movl   $0x100000,0xc(%esp)
f01013b6:	00 
f01013b7:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f01013be:	f0 
f01013bf:	c7 44 24 04 a3 01 00 	movl   $0x1a3,0x4(%esp)
f01013c6:	00 
f01013c7:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01013ce:	e8 ca ec ff ff       	call   f010009d <_panic>
f01013d3:	8d 88 00 00 f0 0f    	lea    0xff00000(%eax),%ecx
f01013d9:	c1 e9 0c             	shr    $0xc,%ecx
f01013dc:	83 e9 01             	sub    $0x1,%ecx
	for(i=0;i<range-1;i++)
f01013df:	b8 00 00 00 00       	mov    $0x0,%eax
f01013e4:	eb 13                	jmp    f01013f9 <page_init+0x144>
	{
		temp2=temp1->pp_link;
f01013e6:	8b 16                	mov    (%esi),%edx
		temp1->pp_link = NULL;
f01013e8:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		temp1->pp_ref = 1;
f01013ee:	66 c7 46 04 01 00    	movw   $0x1,0x4(%esi)
	temp1->pp_ref = 1;
	temp1 = temp2;
	
	//case 4
	range = ((uint32_t) boot_alloc(0) - (uint32_t)KADDR(EXTPHYSMEM))/ (PGSIZE);
	for(i=0;i<range-1;i++)
f01013f4:	83 c0 01             	add    $0x1,%eax
	{
		temp2=temp1->pp_link;
		temp1->pp_link = NULL;
		temp1->pp_ref = 1;
		temp1 = temp2;
f01013f7:	89 d6                	mov    %edx,%esi
	temp1->pp_ref = 1;
	temp1 = temp2;
	
	//case 4
	range = ((uint32_t) boot_alloc(0) - (uint32_t)KADDR(EXTPHYSMEM))/ (PGSIZE);
	for(i=0;i<range-1;i++)
f01013f9:	39 c8                	cmp    %ecx,%eax
f01013fb:	75 e9                	jne    f01013e6 <page_init+0x131>
		temp2=temp1->pp_link;
		temp1->pp_link = NULL;
		temp1->pp_ref = 1;
		temp1 = temp2;
	}
	temp2 = temp1->pp_link;
f01013fd:	8b 06                	mov    (%esi),%eax
	temp1->pp_link = NULL;
f01013ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	temp1->pp_ref = 1;
f0101405:	66 c7 46 04 01 00    	movw   $0x1,0x4(%esi)
	temp1 = temp2;
	temp->pp_link = temp1;
f010140b:	89 03                	mov    %eax,(%ebx)

}
f010140d:	83 c4 10             	add    $0x10,%esp
f0101410:	5b                   	pop    %ebx
f0101411:	5e                   	pop    %esi
f0101412:	5d                   	pop    %ebp
f0101413:	c3                   	ret    

f0101414 <check_free_blocks>:

void check_free_blocks()
{
	struct PageInfo *temp3 = page_free_list;
f0101414:	a1 40 32 2c f0       	mov    0xf02c3240,%eax
	int i=0;
f0101419:	ba 00 00 00 00       	mov    $0x0,%edx
	while(temp3!=NULL){
f010141e:	eb 05                	jmp    f0101425 <check_free_blocks+0x11>
		i++;
f0101420:	83 c2 01             	add    $0x1,%edx
		temp3 = temp3->pp_link;
f0101423:	8b 00                	mov    (%eax),%eax

void check_free_blocks()
{
	struct PageInfo *temp3 = page_free_list;
	int i=0;
	while(temp3!=NULL){
f0101425:	85 c0                	test   %eax,%eax
f0101427:	75 f7                	jne    f0101420 <check_free_blocks+0xc>
	temp->pp_link = temp1;

}

void check_free_blocks()
{
f0101429:	55                   	push   %ebp
f010142a:	89 e5                	mov    %esp,%ebp
f010142c:	83 ec 18             	sub    $0x18,%esp
	int i=0;
	while(temp3!=NULL){
		i++;
		temp3 = temp3->pp_link;
	}
	cprintf("\n number of free blocks:%d",i);
f010142f:	89 54 24 04          	mov    %edx,0x4(%esp)
f0101433:	c7 04 24 bb 8e 10 f0 	movl   $0xf0108ebb,(%esp)
f010143a:	e8 e8 33 00 00       	call   f0104827 <cprintf>
}
f010143f:	c9                   	leave  
f0101440:	c3                   	ret    

f0101441 <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f0101441:	55                   	push   %ebp
f0101442:	89 e5                	mov    %esp,%ebp
f0101444:	53                   	push   %ebx
f0101445:	83 ec 14             	sub    $0x14,%esp
	struct PageInfo *req_page = NULL;
	void *addr, *kaddr;
	if(!page_free_list)
f0101448:	8b 1d 40 32 2c f0    	mov    0xf02c3240,%ebx
f010144e:	85 db                	test   %ebx,%ebx
f0101450:	74 6f                	je     f01014c1 <page_alloc+0x80>
		return NULL;
	else
	{
		req_page = page_free_list;
		page_free_list = page_free_list->pp_link;
f0101452:	8b 03                	mov    (%ebx),%eax
f0101454:	a3 40 32 2c f0       	mov    %eax,0xf02c3240
		req_page->pp_link = NULL;
f0101459:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		{
			addr = page2kva(req_page);
			memset(addr, '\0', PGSIZE);
		}
	}
	return req_page;
f010145f:	89 d8                	mov    %ebx,%eax
	else
	{
		req_page = page_free_list;
		page_free_list = page_free_list->pp_link;
		req_page->pp_link = NULL;
		if(alloc_flags & ALLOC_ZERO)
f0101461:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0101465:	74 5f                	je     f01014c6 <page_alloc+0x85>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101467:	2b 05 a4 3e 2c f0    	sub    0xf02c3ea4,%eax
f010146d:	c1 f8 03             	sar    $0x3,%eax
f0101470:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101473:	89 c2                	mov    %eax,%edx
f0101475:	c1 ea 0c             	shr    $0xc,%edx
f0101478:	3b 15 9c 3e 2c f0    	cmp    0xf02c3e9c,%edx
f010147e:	72 20                	jb     f01014a0 <page_alloc+0x5f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101480:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101484:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f010148b:	f0 
f010148c:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
f0101493:	00 
f0101494:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f010149b:	e8 fd eb ff ff       	call   f010009d <_panic>
		{
			addr = page2kva(req_page);
			memset(addr, '\0', PGSIZE);
f01014a0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01014a7:	00 
f01014a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01014af:	00 
	return (void *)(pa + KERNBASE);
f01014b0:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01014b5:	89 04 24             	mov    %eax,(%esp)
f01014b8:	e8 ea 58 00 00       	call   f0106da7 <memset>
		}
	}
	return req_page;
f01014bd:	89 d8                	mov    %ebx,%eax
f01014bf:	eb 05                	jmp    f01014c6 <page_alloc+0x85>
page_alloc(int alloc_flags)
{
	struct PageInfo *req_page = NULL;
	void *addr, *kaddr;
	if(!page_free_list)
		return NULL;
f01014c1:	b8 00 00 00 00       	mov    $0x0,%eax
			addr = page2kva(req_page);
			memset(addr, '\0', PGSIZE);
		}
	}
	return req_page;
}
f01014c6:	83 c4 14             	add    $0x14,%esp
f01014c9:	5b                   	pop    %ebx
f01014ca:	5d                   	pop    %ebp
f01014cb:	c3                   	ret    

f01014cc <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f01014cc:	55                   	push   %ebp
f01014cd:	89 e5                	mov    %esp,%ebp
f01014cf:	8b 45 08             	mov    0x8(%ebp),%eax
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
	if((pp->pp_ref)<=0)
f01014d2:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01014d7:	75 0d                	jne    f01014e6 <page_free+0x1a>
	{
		pp->pp_link = page_free_list;
f01014d9:	8b 15 40 32 2c f0    	mov    0xf02c3240,%edx
f01014df:	89 10                	mov    %edx,(%eax)
		page_free_list = pp;
f01014e1:	a3 40 32 2c f0       	mov    %eax,0xf02c3240
	}
}
f01014e6:	5d                   	pop    %ebp
f01014e7:	c3                   	ret    

f01014e8 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f01014e8:	55                   	push   %ebp
f01014e9:	89 e5                	mov    %esp,%ebp
f01014eb:	83 ec 04             	sub    $0x4,%esp
f01014ee:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f01014f1:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
f01014f5:	8d 51 ff             	lea    -0x1(%ecx),%edx
f01014f8:	66 89 50 04          	mov    %dx,0x4(%eax)
f01014fc:	66 85 d2             	test   %dx,%dx
f01014ff:	75 08                	jne    f0101509 <page_decref+0x21>
		page_free(pp);
f0101501:	89 04 24             	mov    %eax,(%esp)
f0101504:	e8 c3 ff ff ff       	call   f01014cc <page_free>
}
f0101509:	c9                   	leave  
f010150a:	c3                   	ret    

f010150b <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f010150b:	55                   	push   %ebp
f010150c:	89 e5                	mov    %esp,%ebp
f010150e:	56                   	push   %esi
f010150f:	53                   	push   %ebx
f0101510:	83 ec 10             	sub    $0x10,%esp
f0101513:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	uintptr_t pd_index=0, pt_index=0;
	physaddr_t pa_ptba, pa_pte, pde_perm, pte_perm;
	pte_t *va_ptba=NULL, *va_pte=NULL;
	struct PageInfo *req_page;

	pd_index = PDX(va);
f0101516:	89 de                	mov    %ebx,%esi
f0101518:	c1 ee 16             	shr    $0x16,%esi
	//check address va_ptba+pt_index if it is correct pointer arithmatic or not.	
	// permissions given for directory table entry are PTE_P and PTE_W
	//*(pgdir+pd_index) = *(pgdir+pd_index) | PTE_P | PTE_W ;
	pa_ptba = *(pgdir+pd_index);
f010151b:	c1 e6 02             	shl    $0x2,%esi
f010151e:	03 75 08             	add    0x8(%ebp),%esi
f0101521:	8b 06                	mov    (%esi),%eax
	if(!(pa_ptba & PTE_P))
f0101523:	a8 01                	test   $0x1,%al
f0101525:	75 2c                	jne    f0101553 <pgdir_walk+0x48>
	{
		// setting up page table for requested virtual address.
		if(create)
f0101527:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010152b:	74 6a                	je     f0101597 <pgdir_walk+0x8c>
		{
			req_page = page_alloc(ALLOC_ZERO);
f010152d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101534:	e8 08 ff ff ff       	call   f0101441 <page_alloc>
			if(req_page==NULL)
f0101539:	85 c0                	test   %eax,%eax
f010153b:	74 61                	je     f010159e <pgdir_walk+0x93>
				return NULL;
			req_page->pp_ref++;
f010153d:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101542:	2b 05 a4 3e 2c f0    	sub    0xf02c3ea4,%eax
f0101548:	c1 f8 03             	sar    $0x3,%eax
f010154b:	c1 e0 0c             	shl    $0xc,%eax
			pa_ptba = page2pa(req_page) | PTE_P | PTE_U | PTE_W;
f010154e:	83 c8 07             	or     $0x7,%eax
			*(pgdir+pd_index) = pa_ptba;
f0101551:	89 06                	mov    %eax,(%esi)
		else
			return NULL;
	}

	pde_perm = PGOFF(pa_ptba);
	pa_ptba = PTE_ADDR(pa_ptba);
f0101553:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101558:	89 c2                	mov    %eax,%edx
f010155a:	c1 ea 0c             	shr    $0xc,%edx
f010155d:	3b 15 9c 3e 2c f0    	cmp    0xf02c3e9c,%edx
f0101563:	72 20                	jb     f0101585 <pgdir_walk+0x7a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101565:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101569:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0101570:	f0 
f0101571:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
f0101578:	00 
f0101579:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101580:	e8 18 eb ff ff       	call   f010009d <_panic>
	va_ptba = KADDR(pa_ptba);

	pt_index = PTX(va);
f0101585:	c1 eb 0a             	shr    $0xa,%ebx
	va_pte = va_ptba + pt_index;
f0101588:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
	return va_pte;
f010158e:	8d 84 18 00 00 00 f0 	lea    -0x10000000(%eax,%ebx,1),%eax
f0101595:	eb 0c                	jmp    f01015a3 <pgdir_walk+0x98>
			req_page->pp_ref++;
			pa_ptba = page2pa(req_page) | PTE_P | PTE_U | PTE_W;
			*(pgdir+pd_index) = pa_ptba;
		}
		else
			return NULL;
f0101597:	b8 00 00 00 00       	mov    $0x0,%eax
f010159c:	eb 05                	jmp    f01015a3 <pgdir_walk+0x98>
		// setting up page table for requested virtual address.
		if(create)
		{
			req_page = page_alloc(ALLOC_ZERO);
			if(req_page==NULL)
				return NULL;
f010159e:	b8 00 00 00 00       	mov    $0x0,%eax
	va_ptba = KADDR(pa_ptba);

	pt_index = PTX(va);
	va_pte = va_ptba + pt_index;
	return va_pte;
}
f01015a3:	83 c4 10             	add    $0x10,%esp
f01015a6:	5b                   	pop    %ebx
f01015a7:	5e                   	pop    %esi
f01015a8:	5d                   	pop    %ebp
f01015a9:	c3                   	ret    

f01015aa <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
f01015aa:	55                   	push   %ebp
f01015ab:	89 e5                	mov    %esp,%ebp
f01015ad:	57                   	push   %edi
f01015ae:	56                   	push   %esi
f01015af:	53                   	push   %ebx
f01015b0:	83 ec 2c             	sub    $0x2c,%esp
f01015b3:	89 c7                	mov    %eax,%edi

static __inline uint32_t
rcr4(void)
{
	uint32_t cr4;
	__asm __volatile("movl %%cr4,%0" : "=r" (cr4));
f01015b5:	0f 20 e0             	mov    %cr4,%eax
	physaddr_t pa_ptba;
	count  = size / (PGSIZE);
	pte_t *entry=NULL;
	int cr4_pse_enabled = rcr4() & CR4_PSE;
	//check for va
	if(!(perm & PTE_PS))
f01015b8:	f6 45 0c 80          	testb  $0x80,0xc(%ebp)
f01015bc:	75 52                	jne    f0101610 <boot_map_region+0x66>
{
	// Fill this function in
	int count,i;
	uintptr_t pd_index=0;
	physaddr_t pa_ptba;
	count  = size / (PGSIZE);
f01015be:	c1 e9 0c             	shr    $0xc,%ecx
f01015c1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f01015c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01015c7:	be 00 00 00 00       	mov    $0x0,%esi
f01015cc:	29 da                	sub    %ebx,%edx
f01015ce:	89 55 e0             	mov    %edx,-0x20(%ebp)
	{
		for(i=0;i<count;i++)
		{
			entry = pgdir_walk(pgdir, (void *)((char *)va + (i*PGSIZE)), 1);
			if(entry!=NULL)
				*entry = (physaddr_t)((char *)pa + (i*PGSIZE)) | perm | PTE_P;
f01015d1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01015d4:	83 c8 01             	or     $0x1,%eax
f01015d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01015da:	eb 2d                	jmp    f0101609 <boot_map_region+0x5f>
	//check for va
	if(!(perm & PTE_PS))
	{
		for(i=0;i<count;i++)
		{
			entry = pgdir_walk(pgdir, (void *)((char *)va + (i*PGSIZE)), 1);
f01015dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01015e3:	00 
f01015e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01015e7:	01 d8                	add    %ebx,%eax
f01015e9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01015ed:	89 3c 24             	mov    %edi,(%esp)
f01015f0:	e8 16 ff ff ff       	call   f010150b <pgdir_walk>
			if(entry!=NULL)
f01015f5:	85 c0                	test   %eax,%eax
f01015f7:	74 4a                	je     f0101643 <boot_map_region+0x99>
				*entry = (physaddr_t)((char *)pa + (i*PGSIZE)) | perm | PTE_P;
f01015f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01015fc:	09 da                	or     %ebx,%edx
f01015fe:	89 10                	mov    %edx,(%eax)
	pte_t *entry=NULL;
	int cr4_pse_enabled = rcr4() & CR4_PSE;
	//check for va
	if(!(perm & PTE_PS))
	{
		for(i=0;i<count;i++)
f0101600:	83 c6 01             	add    $0x1,%esi
f0101603:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101609:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
f010160c:	7c ce                	jl     f01015dc <boot_map_region+0x32>
f010160e:	eb 33                	jmp    f0101643 <boot_map_region+0x99>
				*entry = (physaddr_t)((char *)pa + (i*PGSIZE)) | perm | PTE_P;
			else
				break;
		}
	}
	else if((perm & PTE_PS) && cr4_pse_enabled)
f0101610:	a8 10                	test   $0x10,%al
f0101612:	74 2f                	je     f0101643 <boot_map_region+0x99>
	{
		//we need to setup 4MB pages in physical memory
		count = size / (NPTENTRIES*PGSIZE);
f0101614:	c1 e9 16             	shr    $0x16,%ecx
f0101617:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		for(i=0;i<count;i++)
f010161a:	89 d0                	mov    %edx,%eax
f010161c:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101621:	8b 75 08             	mov    0x8(%ebp),%esi
f0101624:	29 d6                	sub    %edx,%esi
f0101626:	eb 13                	jmp    f010163b <boot_map_region+0x91>
		{
			pd_index = PDX(va);
f0101628:	89 c3                	mov    %eax,%ebx
f010162a:	c1 eb 16             	shr    $0x16,%ebx
			pa_ptba = *(pgdir+pd_index);
			*(pgdir + pd_index) = pa | perm;
f010162d:	0b 55 0c             	or     0xc(%ebp),%edx
f0101630:	89 14 9f             	mov    %edx,(%edi,%ebx,4)
			va = va + (1024 * 1024);
f0101633:	05 00 00 10 00       	add    $0x100000,%eax
	}
	else if((perm & PTE_PS) && cr4_pse_enabled)
	{
		//we need to setup 4MB pages in physical memory
		count = size / (NPTENTRIES*PGSIZE);
		for(i=0;i<count;i++)
f0101638:	83 c1 01             	add    $0x1,%ecx
f010163b:	8d 14 06             	lea    (%esi,%eax,1),%edx
f010163e:	3b 4d e4             	cmp    -0x1c(%ebp),%ecx
f0101641:	7c e5                	jl     f0101628 <boot_map_region+0x7e>
			pa = pa + (1024 * 1024); 

		} 
	}

}
f0101643:	83 c4 2c             	add    $0x2c,%esp
f0101646:	5b                   	pop    %ebx
f0101647:	5e                   	pop    %esi
f0101648:	5f                   	pop    %edi
f0101649:	5d                   	pop    %ebp
f010164a:	c3                   	ret    

f010164b <print_memval>:
	va_pte = va_ptba + pt_index;
	return va_pte;
}

void print_memval(const void *vaStart, const void *vaEnd)
{
f010164b:	55                   	push   %ebp
f010164c:	89 e5                	mov    %esp,%ebp
f010164e:	57                   	push   %edi
f010164f:	56                   	push   %esi
f0101650:	53                   	push   %ebx
f0101651:	83 ec 1c             	sub    $0x1c,%esp
f0101654:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101657:	8b 7d 0c             	mov    0xc(%ebp),%edi
	const void *vaddr = vaStart;
	int i=0;
	while((char *)vaddr <= (char *)vaEnd)
f010165a:	eb 79                	jmp    f01016d5 <print_memval+0x8a>
	{
		if((char *)((uint32_t *)vaddr +4)<(char *)vaEnd)
f010165c:	8d 73 10             	lea    0x10(%ebx),%esi
f010165f:	39 f7                	cmp    %esi,%edi
f0101661:	76 32                	jbe    f0101695 <print_memval+0x4a>
		{
			cprintf("\n %p - %p: ",(uint32_t *)vaddr,(uint32_t *)vaddr+3);
f0101663:	8d 43 0c             	lea    0xc(%ebx),%eax
f0101666:	89 44 24 08          	mov    %eax,0x8(%esp)
f010166a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010166e:	c7 04 24 d6 8e 10 f0 	movl   $0xf0108ed6,(%esp)
f0101675:	e8 ad 31 00 00       	call   f0104827 <cprintf>
			i=0;
			while(i<4)
			{
				cprintf("%x ", *(uint32_t *)vaddr);
f010167a:	8b 03                	mov    (%ebx),%eax
f010167c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101680:	c7 04 24 df 89 10 f0 	movl   $0xf01089df,(%esp)
f0101687:	e8 9b 31 00 00       	call   f0104827 <cprintf>
				i++;
				vaddr = (uint32_t *)vaddr +1;
f010168c:	83 c3 04             	add    $0x4,%ebx
	{
		if((char *)((uint32_t *)vaddr +4)<(char *)vaEnd)
		{
			cprintf("\n %p - %p: ",(uint32_t *)vaddr,(uint32_t *)vaddr+3);
			i=0;
			while(i<4)
f010168f:	39 de                	cmp    %ebx,%esi
f0101691:	75 e7                	jne    f010167a <print_memval+0x2f>
f0101693:	eb 3a                	jmp    f01016cf <print_memval+0x84>
				vaddr = (uint32_t *)vaddr +1;
			}
		}
		else
		{
			cprintf("\n %p - %p: ",(uint32_t *)vaddr,(char *)vaEnd);
f0101695:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0101699:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010169d:	c7 04 24 d6 8e 10 f0 	movl   $0xf0108ed6,(%esp)
f01016a4:	e8 7e 31 00 00       	call   f0104827 <cprintf>
f01016a9:	89 f8                	mov    %edi,%eax
f01016ab:	29 d8                	sub    %ebx,%eax
f01016ad:	c1 e8 02             	shr    $0x2,%eax
f01016b0:	8d 74 83 04          	lea    0x4(%ebx,%eax,4),%esi
			while((char *)vaddr <=(char *)vaEnd)
			{
				cprintf("%x ", *(uint32_t *)vaddr);
f01016b4:	8b 03                	mov    (%ebx),%eax
f01016b6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016ba:	c7 04 24 df 89 10 f0 	movl   $0xf01089df,(%esp)
f01016c1:	e8 61 31 00 00       	call   f0104827 <cprintf>
				vaddr = (uint32_t *)vaddr +1;
f01016c6:	83 c3 04             	add    $0x4,%ebx
			}
		}
		else
		{
			cprintf("\n %p - %p: ",(uint32_t *)vaddr,(char *)vaEnd);
			while((char *)vaddr <=(char *)vaEnd)
f01016c9:	39 f3                	cmp    %esi,%ebx
f01016cb:	75 e7                	jne    f01016b4 <print_memval+0x69>
f01016cd:	eb 04                	jmp    f01016d3 <print_memval+0x88>
			i=0;
			while(i<4)
			{
				cprintf("%x ", *(uint32_t *)vaddr);
				i++;
				vaddr = (uint32_t *)vaddr +1;
f01016cf:	89 f3                	mov    %esi,%ebx
f01016d1:	eb 02                	jmp    f01016d5 <print_memval+0x8a>
		{
			cprintf("\n %p - %p: ",(uint32_t *)vaddr,(char *)vaEnd);
			while((char *)vaddr <=(char *)vaEnd)
			{
				cprintf("%x ", *(uint32_t *)vaddr);
				vaddr = (uint32_t *)vaddr +1;
f01016d3:	89 f3                	mov    %esi,%ebx

void print_memval(const void *vaStart, const void *vaEnd)
{
	const void *vaddr = vaStart;
	int i=0;
	while((char *)vaddr <= (char *)vaEnd)
f01016d5:	39 fb                	cmp    %edi,%ebx
f01016d7:	76 83                	jbe    f010165c <print_memval+0x11>
			}
				
		}
		
	}
}
f01016d9:	83 c4 1c             	add    $0x1c,%esp
f01016dc:	5b                   	pop    %ebx
f01016dd:	5e                   	pop    %esi
f01016de:	5f                   	pop    %edi
f01016df:	5d                   	pop    %ebp
f01016e0:	c3                   	ret    

f01016e1 <change_perm>:
	}
	cprintf("\n");
}

void change_perm(const void *vaddr, int perm)
{
f01016e1:	55                   	push   %ebp
f01016e2:	89 e5                	mov    %esp,%ebp
f01016e4:	53                   	push   %ebx
f01016e5:	83 ec 14             	sub    $0x14,%esp
f01016e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	pte_t *va_pte;
	physaddr_t pte_perm, pte;
	va_pte = pgdir_walk( kern_pgdir, vaddr, 0);
f01016eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01016f2:	00 
f01016f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01016f7:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f01016fc:	89 04 24             	mov    %eax,(%esp)
f01016ff:	e8 07 fe ff ff       	call   f010150b <pgdir_walk>
	if(va_pte!=NULL)
f0101704:	85 c0                	test   %eax,%eax
f0101706:	74 0f                	je     f0101717 <change_perm+0x36>
		*va_pte = ((*va_pte) & ~0xFFF) | perm;
f0101708:	8b 10                	mov    (%eax),%edx
f010170a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101710:	0b 55 0c             	or     0xc(%ebp),%edx
f0101713:	89 10                	mov    %edx,(%eax)
f0101715:	eb 10                	jmp    f0101727 <change_perm+0x46>
	else
		cprintf("No mapping present at virtual address:%p", vaddr);
f0101717:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010171b:	c7 04 24 2c 92 10 f0 	movl   $0xf010922c,(%esp)
f0101722:	e8 00 31 00 00       	call   f0104827 <cprintf>


}
f0101727:	83 c4 14             	add    $0x14,%esp
f010172a:	5b                   	pop    %ebx
f010172b:	5d                   	pop    %ebp
f010172c:	c3                   	ret    

f010172d <print_perm>:

void print_perm(uint32_t perm)
{
f010172d:	55                   	push   %ebp
f010172e:	89 e5                	mov    %esp,%ebp
f0101730:	53                   	push   %ebx
f0101731:	83 ec 14             	sub    $0x14,%esp
f0101734:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if(perm & PTE_P)
f0101737:	f6 c3 01             	test   $0x1,%bl
f010173a:	74 0c                	je     f0101748 <print_perm+0x1b>
		cprintf(" PTE_P");
f010173c:	c7 04 24 02 91 10 f0 	movl   $0xf0109102,(%esp)
f0101743:	e8 df 30 00 00       	call   f0104827 <cprintf>
	if(perm & PTE_W)
f0101748:	f6 c3 02             	test   $0x2,%bl
f010174b:	74 0c                	je     f0101759 <print_perm+0x2c>
		cprintf(" PTE_W");
f010174d:	c7 04 24 13 91 10 f0 	movl   $0xf0109113,(%esp)
f0101754:	e8 ce 30 00 00       	call   f0104827 <cprintf>
	if(perm & PTE_U)
f0101759:	f6 c3 04             	test   $0x4,%bl
f010175c:	74 0c                	je     f010176a <print_perm+0x3d>
		cprintf(" PTE_U");
f010175e:	c7 04 24 43 90 10 f0 	movl   $0xf0109043,(%esp)
f0101765:	e8 bd 30 00 00       	call   f0104827 <cprintf>
	if(perm & PTE_A)
f010176a:	f6 c3 20             	test   $0x20,%bl
f010176d:	74 0c                	je     f010177b <print_perm+0x4e>
		cprintf(" PTE_A");
f010176f:	c7 04 24 e2 8e 10 f0 	movl   $0xf0108ee2,(%esp)
f0101776:	e8 ac 30 00 00       	call   f0104827 <cprintf>
}
f010177b:	83 c4 14             	add    $0x14,%esp
f010177e:	5b                   	pop    %ebx
f010177f:	5d                   	pop    %ebp
f0101780:	c3                   	ret    

f0101781 <print_mapping>:
		
	}
}

void print_mapping(const void *vaStart, const void *vaEnd)
{
f0101781:	55                   	push   %ebp
f0101782:	89 e5                	mov    %esp,%ebp
f0101784:	57                   	push   %edi
f0101785:	56                   	push   %esi
f0101786:	53                   	push   %ebx
f0101787:	83 ec 1c             	sub    $0x1c,%esp
f010178a:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010178d:	8b 75 0c             	mov    0xc(%ebp),%esi
	pte_t *va_pte;
	physaddr_t pte_perm, pte;
	const void *vaddr = vaStart;
	while((char *)vaddr <= (char *)vaEnd)
f0101790:	eb 76                	jmp    f0101808 <print_mapping+0x87>
	{
		va_pte = pgdir_walk( kern_pgdir, vaddr, 0);
f0101792:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101799:	00 
f010179a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010179e:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f01017a3:	89 04 24             	mov    %eax,(%esp)
f01017a6:	e8 60 fd ff ff       	call   f010150b <pgdir_walk>
		if(va_pte==NULL)
f01017ab:	85 c0                	test   %eax,%eax
f01017ad:	75 1e                	jne    f01017cd <print_mapping+0x4c>
		{
			cprintf("\nNo Mapping for virtual address:%p",vaddr);
f01017af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01017b3:	c7 04 24 58 92 10 f0 	movl   $0xf0109258,(%esp)
f01017ba:	e8 68 30 00 00       	call   f0104827 <cprintf>
			vaddr = ((char *)PTE_ADDR(vaddr) + PGSIZE);
f01017bf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01017c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
			continue;
f01017cb:	eb 3b                	jmp    f0101808 <print_mapping+0x87>
		}
		pte = *va_pte;
f01017cd:	8b 00                	mov    (%eax),%eax
		pte_perm = PGOFF(pte);
f01017cf:	89 c7                	mov    %eax,%edi
f01017d1:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
		pte = PTE_ADDR(pte);
		cprintf("\nvirtual address: %p Physical Page Address: %p Page Permission:%d ->",vaddr, pte, pte_perm);
f01017d7:	89 7c 24 0c          	mov    %edi,0xc(%esp)
			vaddr = ((char *)PTE_ADDR(vaddr) + PGSIZE);
			continue;
		}
		pte = *va_pte;
		pte_perm = PGOFF(pte);
		pte = PTE_ADDR(pte);
f01017db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
		cprintf("\nvirtual address: %p Physical Page Address: %p Page Permission:%d ->",vaddr, pte, pte_perm);
f01017e0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01017e4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01017e8:	c7 04 24 7c 92 10 f0 	movl   $0xf010927c,(%esp)
f01017ef:	e8 33 30 00 00       	call   f0104827 <cprintf>
		print_perm(pte_perm);
f01017f4:	89 3c 24             	mov    %edi,(%esp)
f01017f7:	e8 31 ff ff ff       	call   f010172d <print_perm>
		vaddr = ((char *)PTE_ADDR(vaddr) + PGSIZE);	
f01017fc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0101802:	81 c3 00 10 00 00    	add    $0x1000,%ebx
void print_mapping(const void *vaStart, const void *vaEnd)
{
	pte_t *va_pte;
	physaddr_t pte_perm, pte;
	const void *vaddr = vaStart;
	while((char *)vaddr <= (char *)vaEnd)
f0101808:	39 f3                	cmp    %esi,%ebx
f010180a:	76 86                	jbe    f0101792 <print_mapping+0x11>
		pte = PTE_ADDR(pte);
		cprintf("\nvirtual address: %p Physical Page Address: %p Page Permission:%d ->",vaddr, pte, pte_perm);
		print_perm(pte_perm);
		vaddr = ((char *)PTE_ADDR(vaddr) + PGSIZE);	
	}
	cprintf("\n");
f010180c:	c7 04 24 16 8a 10 f0 	movl   $0xf0108a16,(%esp)
f0101813:	e8 0f 30 00 00       	call   f0104827 <cprintf>
}
f0101818:	83 c4 1c             	add    $0x1c,%esp
f010181b:	5b                   	pop    %ebx
f010181c:	5e                   	pop    %esi
f010181d:	5f                   	pop    %edi
f010181e:	5d                   	pop    %ebp
f010181f:	c3                   	ret    

f0101820 <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f0101820:	55                   	push   %ebp
f0101821:	89 e5                	mov    %esp,%ebp
f0101823:	53                   	push   %ebx
f0101824:	83 ec 14             	sub    $0x14,%esp
f0101827:	8b 5d 10             	mov    0x10(%ebp),%ebx

	pte_t *entry=NULL;
	struct PageInfo *page=NULL;
	physaddr_t page_paddr;
	entry = pgdir_walk(pgdir, va, 0);
f010182a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101831:	00 
f0101832:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101835:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101839:	8b 45 08             	mov    0x8(%ebp),%eax
f010183c:	89 04 24             	mov    %eax,(%esp)
f010183f:	e8 c7 fc ff ff       	call   f010150b <pgdir_walk>

	//just confirm what should be stored in pte_store because &entry will give va only!!! checkout
	if(entry!=NULL)
f0101844:	85 c0                	test   %eax,%eax
f0101846:	74 3e                	je     f0101886 <page_lookup+0x66>
	{
		if(pte_store!=NULL)
f0101848:	85 db                	test   %ebx,%ebx
f010184a:	74 02                	je     f010184e <page_lookup+0x2e>
			*pte_store = entry;
f010184c:	89 03                	mov    %eax,(%ebx)
		page_paddr = (physaddr_t)*entry;
f010184e:	8b 00                	mov    (%eax),%eax
		if(page_paddr & PTE_P)
f0101850:	a8 01                	test   $0x1,%al
f0101852:	74 39                	je     f010188d <page_lookup+0x6d>
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101854:	c1 e8 0c             	shr    $0xc,%eax
f0101857:	3b 05 9c 3e 2c f0    	cmp    0xf02c3e9c,%eax
f010185d:	72 1c                	jb     f010187b <page_lookup+0x5b>
		panic("pa2page called with invalid pa");
f010185f:	c7 44 24 08 0c 92 10 	movl   $0xf010920c,0x8(%esp)
f0101866:	f0 
f0101867:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
f010186e:	00 
f010186f:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0101876:	e8 22 e8 ff ff       	call   f010009d <_panic>
	return &pages[PGNUM(pa)];
f010187b:	8b 15 a4 3e 2c f0    	mov    0xf02c3ea4,%edx
f0101881:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0101884:	eb 0c                	jmp    f0101892 <page_lookup+0x72>
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{

	pte_t *entry=NULL;
	struct PageInfo *page=NULL;
f0101886:	b8 00 00 00 00       	mov    $0x0,%eax
f010188b:	eb 05                	jmp    f0101892 <page_lookup+0x72>
		if(page_paddr & PTE_P)
		{
			page = pa2page(page_paddr);
		}
		else
			return NULL;
f010188d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	return page;
}
f0101892:	83 c4 14             	add    $0x14,%esp
f0101895:	5b                   	pop    %ebx
f0101896:	5d                   	pop    %ebp
f0101897:	c3                   	ret    

f0101898 <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0101898:	55                   	push   %ebp
f0101899:	89 e5                	mov    %esp,%ebp
f010189b:	83 ec 08             	sub    $0x8,%esp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f010189e:	e8 56 5b 00 00       	call   f01073f9 <cpunum>
f01018a3:	6b c0 74             	imul   $0x74,%eax,%eax
f01018a6:	83 b8 28 40 2c f0 00 	cmpl   $0x0,-0xfd3bfd8(%eax)
f01018ad:	74 16                	je     f01018c5 <tlb_invalidate+0x2d>
f01018af:	e8 45 5b 00 00       	call   f01073f9 <cpunum>
f01018b4:	6b c0 74             	imul   $0x74,%eax,%eax
f01018b7:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01018bd:	8b 55 08             	mov    0x8(%ebp),%edx
f01018c0:	39 50 60             	cmp    %edx,0x60(%eax)
f01018c3:	75 06                	jne    f01018cb <tlb_invalidate+0x33>
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01018c8:	0f 01 38             	invlpg (%eax)
		invlpg(va);
}
f01018cb:	c9                   	leave  
f01018cc:	c3                   	ret    

f01018cd <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f01018cd:	55                   	push   %ebp
f01018ce:	89 e5                	mov    %esp,%ebp
f01018d0:	56                   	push   %esi
f01018d1:	53                   	push   %ebx
f01018d2:	83 ec 10             	sub    $0x10,%esp
f01018d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01018d8:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *page=NULL;
	pte_t *kaddr;
	page = page_lookup(pgdir, va, NULL);
f01018db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01018e2:	00 
f01018e3:	89 74 24 04          	mov    %esi,0x4(%esp)
f01018e7:	89 1c 24             	mov    %ebx,(%esp)
f01018ea:	e8 31 ff ff ff       	call   f0101820 <page_lookup>
	if(page!=NULL)
f01018ef:	85 c0                	test   %eax,%eax
f01018f1:	74 2e                	je     f0101921 <page_remove+0x54>
	{
		page_decref(page);
f01018f3:	89 04 24             	mov    %eax,(%esp)
f01018f6:	e8 ed fb ff ff       	call   f01014e8 <page_decref>
		mapped at different virtual address which is not alligned to PA of page i.e not straight conversion
		So we need to to do pgdir_walk to get the VA of PTE*/

		/* We just know the mapping of page corresponding to physical memory. 
		But not the mapping between virtual mem and phys mem*/
		kaddr = pgdir_walk(pgdir, va, 0);
f01018fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101902:	00 
f0101903:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101907:	89 1c 24             	mov    %ebx,(%esp)
f010190a:	e8 fc fb ff ff       	call   f010150b <pgdir_walk>
		*kaddr = 0;
f010190f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, va);
f0101915:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101919:	89 1c 24             	mov    %ebx,(%esp)
f010191c:	e8 77 ff ff ff       	call   f0101898 <tlb_invalidate>
	}

}
f0101921:	83 c4 10             	add    $0x10,%esp
f0101924:	5b                   	pop    %ebx
f0101925:	5e                   	pop    %esi
f0101926:	5d                   	pop    %ebp
f0101927:	c3                   	ret    

f0101928 <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f0101928:	55                   	push   %ebp
f0101929:	89 e5                	mov    %esp,%ebp
f010192b:	57                   	push   %edi
f010192c:	56                   	push   %esi
f010192d:	53                   	push   %ebx
f010192e:	83 ec 1c             	sub    $0x1c,%esp
f0101931:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101934:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Fill this function in
	pte_t *entry=NULL;
	struct PageInfo *page=NULL;
	physaddr_t page_paddr;
	entry = pgdir_walk(pgdir, va, 1);
f0101937:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010193e:	00 
f010193f:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101943:	8b 45 08             	mov    0x8(%ebp),%eax
f0101946:	89 04 24             	mov    %eax,(%esp)
f0101949:	e8 bd fb ff ff       	call   f010150b <pgdir_walk>
f010194e:	89 c6                	mov    %eax,%esi
	if(entry)
f0101950:	85 c0                	test   %eax,%eax
f0101952:	0f 84 8a 00 00 00    	je     f01019e2 <page_insert+0xba>
	{
		page_paddr = (physaddr_t)*entry;
f0101958:	8b 00                	mov    (%eax),%eax
		if(page_paddr & PTE_P)
f010195a:	a8 01                	test   $0x1,%al
f010195c:	74 60                	je     f01019be <page_insert+0x96>
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010195e:	c1 e8 0c             	shr    $0xc,%eax
f0101961:	3b 05 9c 3e 2c f0    	cmp    0xf02c3e9c,%eax
f0101967:	72 1c                	jb     f0101985 <page_insert+0x5d>
		panic("pa2page called with invalid pa");
f0101969:	c7 44 24 08 0c 92 10 	movl   $0xf010920c,0x8(%esp)
f0101970:	f0 
f0101971:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
f0101978:	00 
f0101979:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0101980:	e8 18 e7 ff ff       	call   f010009d <_panic>
	return &pages[PGNUM(pa)];
f0101985:	8b 15 a4 3e 2c f0    	mov    0xf02c3ea4,%edx
f010198b:	8d 04 c2             	lea    (%edx,%eax,8),%eax
		{
			page = pa2page(page_paddr);	
			if(page!=pp)
f010198e:	39 c3                	cmp    %eax,%ebx
f0101990:	74 11                	je     f01019a3 <page_insert+0x7b>
				page_remove(pgdir, va);	
f0101992:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101996:	8b 45 08             	mov    0x8(%ebp),%eax
f0101999:	89 04 24             	mov    %eax,(%esp)
f010199c:	e8 2c ff ff ff       	call   f01018cd <page_remove>
f01019a1:	eb 1b                	jmp    f01019be <page_insert+0x96>
			else
			{
				*entry = page2pa(pp) | perm | PTE_P;
f01019a3:	8b 4d 14             	mov    0x14(%ebp),%ecx
f01019a6:	83 c9 01             	or     $0x1,%ecx
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01019a9:	29 d3                	sub    %edx,%ebx
f01019ab:	c1 fb 03             	sar    $0x3,%ebx
f01019ae:	89 d8                	mov    %ebx,%eax
f01019b0:	c1 e0 0c             	shl    $0xc,%eax
f01019b3:	09 c8                	or     %ecx,%eax
f01019b5:	89 06                	mov    %eax,(%esi)
				// cprintf("\npage_insert: perm:%d addr:%p",*entry);
				return 0;
f01019b7:	b8 00 00 00 00       	mov    $0x0,%eax
f01019bc:	eb 29                	jmp    f01019e7 <page_insert+0xbf>
			}
		}
		*entry = page2pa(pp) | perm | PTE_P;	
f01019be:	8b 55 14             	mov    0x14(%ebp),%edx
f01019c1:	83 ca 01             	or     $0x1,%edx
f01019c4:	89 d8                	mov    %ebx,%eax
f01019c6:	2b 05 a4 3e 2c f0    	sub    0xf02c3ea4,%eax
f01019cc:	c1 f8 03             	sar    $0x3,%eax
f01019cf:	c1 e0 0c             	shl    $0xc,%eax
f01019d2:	09 d0                	or     %edx,%eax
f01019d4:	89 06                	mov    %eax,(%esi)
		pp->pp_ref++;
f01019d6:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
		return 0;
f01019db:	b8 00 00 00 00       	mov    $0x0,%eax
f01019e0:	eb 05                	jmp    f01019e7 <page_insert+0xbf>
	}
	return -E_NO_MEM;
f01019e2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
f01019e7:	83 c4 1c             	add    $0x1c,%esp
f01019ea:	5b                   	pop    %ebx
f01019eb:	5e                   	pop    %esi
f01019ec:	5f                   	pop    %edi
f01019ed:	5d                   	pop    %ebp
f01019ee:	c3                   	ret    

f01019ef <mmio_map_region>:
// location.  Return the base of the reserved region.  size does *not*
// have to be multiple of PGSIZE.
//
void *
mmio_map_region(physaddr_t pa, size_t size)
{
f01019ef:	55                   	push   %ebp
f01019f0:	89 e5                	mov    %esp,%ebp
f01019f2:	56                   	push   %esi
f01019f3:	53                   	push   %ebx
f01019f4:	83 ec 10             	sub    $0x10,%esp
f01019f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	// Where to start the next region.  Initially, this is the
	// beginning of the MMIO region.  Because this is static, its
	// value will be preserved between calls to mmio_map_region
	// (just like nextfree in boot_alloc).
	static uintptr_t base = MMIOBASE;
	uintptr_t ret_base = base;
f01019fa:	8b 1d 04 73 12 f0    	mov    0xf0127304,%ebx
	//
	// Hint: The staff solution uses boot_map_region.
	//
	// Your code here:

	if(((char *)base + size) > (char *)MMIOLIM)
f0101a00:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
f0101a03:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101a08:	76 1c                	jbe    f0101a26 <mmio_map_region+0x37>
		panic("MMIOLIMIT reached cannot map memorry for the new device");
f0101a0a:	c7 44 24 08 c4 92 10 	movl   $0xf01092c4,0x8(%esp)
f0101a11:	f0 
f0101a12:	c7 44 24 04 69 03 00 	movl   $0x369,0x4(%esp)
f0101a19:	00 
f0101a1a:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101a21:	e8 77 e6 ff ff       	call   f010009d <_panic>
	boot_map_region(kern_pgdir, base, ROUNDUP(size, PGSIZE) , pa , PTE_P | PTE_W | PTE_PCD | PTE_PWT);
f0101a26:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
f0101a2c:	89 ce                	mov    %ecx,%esi
f0101a2e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f0101a34:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0101a3b:	00 
f0101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
f0101a3f:	89 04 24             	mov    %eax,(%esp)
f0101a42:	89 f1                	mov    %esi,%ecx
f0101a44:	89 da                	mov    %ebx,%edx
f0101a46:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0101a4b:	e8 5a fb ff ff       	call   f01015aa <boot_map_region>
	base = (uintptr_t)((char *)base + ROUNDUP(size, PGSIZE));
f0101a50:	03 35 04 73 12 f0    	add    0xf0127304,%esi
f0101a56:	89 35 04 73 12 f0    	mov    %esi,0xf0127304
	// Fo now, there is only one address space, so always invalidate.
	tlb_invalidate(kern_pgdir, (void *)base);
f0101a5c:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101a60:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0101a65:	89 04 24             	mov    %eax,(%esp)
f0101a68:	e8 2b fe ff ff       	call   f0101898 <tlb_invalidate>
	return (void *)ret_base;
}
f0101a6d:	89 d8                	mov    %ebx,%eax
f0101a6f:	83 c4 10             	add    $0x10,%esp
f0101a72:	5b                   	pop    %ebx
f0101a73:	5e                   	pop    %esi
f0101a74:	5d                   	pop    %ebp
f0101a75:	c3                   	ret    

f0101a76 <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0101a76:	55                   	push   %ebp
f0101a77:	89 e5                	mov    %esp,%ebp
f0101a79:	57                   	push   %edi
f0101a7a:	56                   	push   %esi
f0101a7b:	53                   	push   %ebx
f0101a7c:	83 ec 4c             	sub    $0x4c,%esp
// --------------------------------------------------------------

static int
nvram_read(int r)
{
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0101a7f:	c7 04 24 15 00 00 00 	movl   $0x15,(%esp)
f0101a86:	e8 20 2c 00 00       	call   f01046ab <mc146818_read>
f0101a8b:	89 c3                	mov    %eax,%ebx
f0101a8d:	c7 04 24 16 00 00 00 	movl   $0x16,(%esp)
f0101a94:	e8 12 2c 00 00       	call   f01046ab <mc146818_read>
f0101a99:	c1 e0 08             	shl    $0x8,%eax
f0101a9c:	09 c3                	or     %eax,%ebx
{
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f0101a9e:	89 d8                	mov    %ebx,%eax
f0101aa0:	c1 e0 0a             	shl    $0xa,%eax
f0101aa3:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0101aa9:	85 c0                	test   %eax,%eax
f0101aab:	0f 48 c2             	cmovs  %edx,%eax
f0101aae:	c1 f8 0c             	sar    $0xc,%eax
f0101ab1:	a3 44 32 2c f0       	mov    %eax,0xf02c3244
// --------------------------------------------------------------

static int
nvram_read(int r)
{
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0101ab6:	c7 04 24 17 00 00 00 	movl   $0x17,(%esp)
f0101abd:	e8 e9 2b 00 00       	call   f01046ab <mc146818_read>
f0101ac2:	89 c3                	mov    %eax,%ebx
f0101ac4:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
f0101acb:	e8 db 2b 00 00       	call   f01046ab <mc146818_read>
f0101ad0:	c1 e0 08             	shl    $0x8,%eax
f0101ad3:	09 c3                	or     %eax,%ebx
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
	npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;
f0101ad5:	89 d8                	mov    %ebx,%eax
f0101ad7:	c1 e0 0a             	shl    $0xa,%eax
f0101ada:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0101ae0:	85 c0                	test   %eax,%eax
f0101ae2:	0f 48 c2             	cmovs  %edx,%eax
f0101ae5:	c1 f8 0c             	sar    $0xc,%eax

	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (npages_extmem)
f0101ae8:	85 c0                	test   %eax,%eax
f0101aea:	74 0e                	je     f0101afa <mem_init+0x84>
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
f0101aec:	8d 90 00 01 00 00    	lea    0x100(%eax),%edx
f0101af2:	89 15 9c 3e 2c f0    	mov    %edx,0xf02c3e9c
f0101af8:	eb 0c                	jmp    f0101b06 <mem_init+0x90>
	else
		npages = npages_basemem;
f0101afa:	8b 15 44 32 2c f0    	mov    0xf02c3244,%edx
f0101b00:	89 15 9c 3e 2c f0    	mov    %edx,0xf02c3e9c

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
		npages_extmem * PGSIZE / 1024);
f0101b06:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101b09:	c1 e8 0a             	shr    $0xa,%eax
f0101b0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
f0101b10:	a1 44 32 2c f0       	mov    0xf02c3244,%eax
f0101b15:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101b18:	c1 e8 0a             	shr    $0xa,%eax
f0101b1b:	89 44 24 08          	mov    %eax,0x8(%esp)
		npages * PGSIZE / 1024,
f0101b1f:	a1 9c 3e 2c f0       	mov    0xf02c3e9c,%eax
f0101b24:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101b27:	c1 e8 0a             	shr    $0xa,%eax
f0101b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101b2e:	c7 04 24 fc 92 10 f0 	movl   $0xf01092fc,(%esp)
f0101b35:	e8 ed 2c 00 00       	call   f0104827 <cprintf>
	// Remove this line when you're ready to test this function.


	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101b3a:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101b3f:	e8 8c f2 ff ff       	call   f0100dd0 <boot_alloc>
f0101b44:	a3 a0 3e 2c f0       	mov    %eax,0xf02c3ea0
	memset(kern_pgdir, 0, PGSIZE);
f0101b49:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101b50:	00 
f0101b51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101b58:	00 
f0101b59:	89 04 24             	mov    %eax,(%esp)
f0101b5c:	e8 46 52 00 00       	call   f0106da7 <memset>
	// a virtual page table at virtual address UVPT.
	// (For now, you don't have understand the greater purpose of the
	// following line.)

	// Permissions: kernel R, user R
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101b61:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0101b66:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101b6b:	77 20                	ja     f0101b8d <mem_init+0x117>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101b6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101b71:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0101b78:	f0 
f0101b79:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
f0101b80:	00 
f0101b81:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101b88:	e8 10 e5 ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f0101b8d:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101b93:	83 ca 05             	or     $0x5,%edx
f0101b96:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:


	pages = (struct PageInfo *)boot_alloc(npages * sizeof(struct PageInfo));
f0101b9c:	a1 9c 3e 2c f0       	mov    0xf02c3e9c,%eax
f0101ba1:	c1 e0 03             	shl    $0x3,%eax
f0101ba4:	e8 27 f2 ff ff       	call   f0100dd0 <boot_alloc>
f0101ba9:	a3 a4 3e 2c f0       	mov    %eax,0xf02c3ea4
	memset(pages, 0, npages * sizeof(struct PageInfo));
f0101bae:	8b 0d 9c 3e 2c f0    	mov    0xf02c3e9c,%ecx
f0101bb4:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f0101bbb:	89 54 24 08          	mov    %edx,0x8(%esp)
f0101bbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101bc6:	00 
f0101bc7:	89 04 24             	mov    %eax,(%esp)
f0101bca:	e8 d8 51 00 00       	call   f0106da7 <memset>
	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.

	//check pages address------>
	envs = (struct Env *)boot_alloc(NENV *sizeof(struct Env));
f0101bcf:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0101bd4:	e8 f7 f1 ff ff       	call   f0100dd0 <boot_alloc>
f0101bd9:	a3 48 32 2c f0       	mov    %eax,0xf02c3248
	memset(envs, 0, NENV *sizeof(struct Env));
f0101bde:	c7 44 24 08 00 f0 01 	movl   $0x1f000,0x8(%esp)
f0101be5:	00 
f0101be6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101bed:	00 
f0101bee:	89 04 24             	mov    %eax,(%esp)
f0101bf1:	e8 b1 51 00 00       	call   f0106da7 <memset>
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
	page_init();
f0101bf6:	e8 ba f6 ff ff       	call   f01012b5 <page_init>

	check_page_free_list(1);
f0101bfb:	b8 01 00 00 00       	mov    $0x1,%eax
f0101c00:	e8 d8 f2 ff ff       	call   f0100edd <check_page_free_list>
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f0101c05:	83 3d a4 3e 2c f0 00 	cmpl   $0x0,0xf02c3ea4
f0101c0c:	75 1c                	jne    f0101c2a <mem_init+0x1b4>
		panic("'pages' is a null pointer!");
f0101c0e:	c7 44 24 08 e9 8e 10 	movl   $0xf0108ee9,0x8(%esp)
f0101c15:	f0 
f0101c16:	c7 44 24 04 24 04 00 	movl   $0x424,0x4(%esp)
f0101c1d:	00 
f0101c1e:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101c25:	e8 73 e4 ff ff       	call   f010009d <_panic>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101c2a:	a1 40 32 2c f0       	mov    0xf02c3240,%eax
f0101c2f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101c34:	eb 05                	jmp    f0101c3b <mem_init+0x1c5>
		++nfree;
f0101c36:	83 c3 01             	add    $0x1,%ebx

	if (!pages)
		panic("'pages' is a null pointer!");

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101c39:	8b 00                	mov    (%eax),%eax
f0101c3b:	85 c0                	test   %eax,%eax
f0101c3d:	75 f7                	jne    f0101c36 <mem_init+0x1c0>
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101c3f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101c46:	e8 f6 f7 ff ff       	call   f0101441 <page_alloc>
f0101c4b:	89 c7                	mov    %eax,%edi
f0101c4d:	85 c0                	test   %eax,%eax
f0101c4f:	75 24                	jne    f0101c75 <mem_init+0x1ff>
f0101c51:	c7 44 24 0c 04 8f 10 	movl   $0xf0108f04,0xc(%esp)
f0101c58:	f0 
f0101c59:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101c60:	f0 
f0101c61:	c7 44 24 04 2c 04 00 	movl   $0x42c,0x4(%esp)
f0101c68:	00 
f0101c69:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101c70:	e8 28 e4 ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f0101c75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101c7c:	e8 c0 f7 ff ff       	call   f0101441 <page_alloc>
f0101c81:	89 c6                	mov    %eax,%esi
f0101c83:	85 c0                	test   %eax,%eax
f0101c85:	75 24                	jne    f0101cab <mem_init+0x235>
f0101c87:	c7 44 24 0c 1a 8f 10 	movl   $0xf0108f1a,0xc(%esp)
f0101c8e:	f0 
f0101c8f:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101c96:	f0 
f0101c97:	c7 44 24 04 2d 04 00 	movl   $0x42d,0x4(%esp)
f0101c9e:	00 
f0101c9f:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101ca6:	e8 f2 e3 ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f0101cab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101cb2:	e8 8a f7 ff ff       	call   f0101441 <page_alloc>
f0101cb7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101cba:	85 c0                	test   %eax,%eax
f0101cbc:	75 24                	jne    f0101ce2 <mem_init+0x26c>
f0101cbe:	c7 44 24 0c 30 8f 10 	movl   $0xf0108f30,0xc(%esp)
f0101cc5:	f0 
f0101cc6:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101ccd:	f0 
f0101cce:	c7 44 24 04 2e 04 00 	movl   $0x42e,0x4(%esp)
f0101cd5:	00 
f0101cd6:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101cdd:	e8 bb e3 ff ff       	call   f010009d <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101ce2:	39 f7                	cmp    %esi,%edi
f0101ce4:	75 24                	jne    f0101d0a <mem_init+0x294>
f0101ce6:	c7 44 24 0c 46 8f 10 	movl   $0xf0108f46,0xc(%esp)
f0101ced:	f0 
f0101cee:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101cf5:	f0 
f0101cf6:	c7 44 24 04 31 04 00 	movl   $0x431,0x4(%esp)
f0101cfd:	00 
f0101cfe:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101d05:	e8 93 e3 ff ff       	call   f010009d <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d0d:	39 c6                	cmp    %eax,%esi
f0101d0f:	74 04                	je     f0101d15 <mem_init+0x29f>
f0101d11:	39 c7                	cmp    %eax,%edi
f0101d13:	75 24                	jne    f0101d39 <mem_init+0x2c3>
f0101d15:	c7 44 24 0c 38 93 10 	movl   $0xf0109338,0xc(%esp)
f0101d1c:	f0 
f0101d1d:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101d24:	f0 
f0101d25:	c7 44 24 04 32 04 00 	movl   $0x432,0x4(%esp)
f0101d2c:	00 
f0101d2d:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101d34:	e8 64 e3 ff ff       	call   f010009d <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101d39:	8b 15 a4 3e 2c f0    	mov    0xf02c3ea4,%edx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101d3f:	a1 9c 3e 2c f0       	mov    0xf02c3e9c,%eax
f0101d44:	c1 e0 0c             	shl    $0xc,%eax
f0101d47:	89 f9                	mov    %edi,%ecx
f0101d49:	29 d1                	sub    %edx,%ecx
f0101d4b:	c1 f9 03             	sar    $0x3,%ecx
f0101d4e:	c1 e1 0c             	shl    $0xc,%ecx
f0101d51:	39 c1                	cmp    %eax,%ecx
f0101d53:	72 24                	jb     f0101d79 <mem_init+0x303>
f0101d55:	c7 44 24 0c 58 8f 10 	movl   $0xf0108f58,0xc(%esp)
f0101d5c:	f0 
f0101d5d:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101d64:	f0 
f0101d65:	c7 44 24 04 33 04 00 	movl   $0x433,0x4(%esp)
f0101d6c:	00 
f0101d6d:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101d74:	e8 24 e3 ff ff       	call   f010009d <_panic>
f0101d79:	89 f1                	mov    %esi,%ecx
f0101d7b:	29 d1                	sub    %edx,%ecx
f0101d7d:	c1 f9 03             	sar    $0x3,%ecx
f0101d80:	c1 e1 0c             	shl    $0xc,%ecx
	assert(page2pa(pp1) < npages*PGSIZE);
f0101d83:	39 c8                	cmp    %ecx,%eax
f0101d85:	77 24                	ja     f0101dab <mem_init+0x335>
f0101d87:	c7 44 24 0c 75 8f 10 	movl   $0xf0108f75,0xc(%esp)
f0101d8e:	f0 
f0101d8f:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101d96:	f0 
f0101d97:	c7 44 24 04 34 04 00 	movl   $0x434,0x4(%esp)
f0101d9e:	00 
f0101d9f:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101da6:	e8 f2 e2 ff ff       	call   f010009d <_panic>
f0101dab:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101dae:	29 d1                	sub    %edx,%ecx
f0101db0:	89 ca                	mov    %ecx,%edx
f0101db2:	c1 fa 03             	sar    $0x3,%edx
f0101db5:	c1 e2 0c             	shl    $0xc,%edx
	assert(page2pa(pp2) < npages*PGSIZE);
f0101db8:	39 d0                	cmp    %edx,%eax
f0101dba:	77 24                	ja     f0101de0 <mem_init+0x36a>
f0101dbc:	c7 44 24 0c 92 8f 10 	movl   $0xf0108f92,0xc(%esp)
f0101dc3:	f0 
f0101dc4:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101dcb:	f0 
f0101dcc:	c7 44 24 04 35 04 00 	movl   $0x435,0x4(%esp)
f0101dd3:	00 
f0101dd4:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101ddb:	e8 bd e2 ff ff       	call   f010009d <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101de0:	a1 40 32 2c f0       	mov    0xf02c3240,%eax
f0101de5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101de8:	c7 05 40 32 2c f0 00 	movl   $0x0,0xf02c3240
f0101def:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101df2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101df9:	e8 43 f6 ff ff       	call   f0101441 <page_alloc>
f0101dfe:	85 c0                	test   %eax,%eax
f0101e00:	74 24                	je     f0101e26 <mem_init+0x3b0>
f0101e02:	c7 44 24 0c af 8f 10 	movl   $0xf0108faf,0xc(%esp)
f0101e09:	f0 
f0101e0a:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101e11:	f0 
f0101e12:	c7 44 24 04 3c 04 00 	movl   $0x43c,0x4(%esp)
f0101e19:	00 
f0101e1a:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101e21:	e8 77 e2 ff ff       	call   f010009d <_panic>

	// free and re-allocate?
	page_free(pp0);
f0101e26:	89 3c 24             	mov    %edi,(%esp)
f0101e29:	e8 9e f6 ff ff       	call   f01014cc <page_free>
	page_free(pp1);
f0101e2e:	89 34 24             	mov    %esi,(%esp)
f0101e31:	e8 96 f6 ff ff       	call   f01014cc <page_free>
	page_free(pp2);
f0101e36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e39:	89 04 24             	mov    %eax,(%esp)
f0101e3c:	e8 8b f6 ff ff       	call   f01014cc <page_free>
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101e41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101e48:	e8 f4 f5 ff ff       	call   f0101441 <page_alloc>
f0101e4d:	89 c6                	mov    %eax,%esi
f0101e4f:	85 c0                	test   %eax,%eax
f0101e51:	75 24                	jne    f0101e77 <mem_init+0x401>
f0101e53:	c7 44 24 0c 04 8f 10 	movl   $0xf0108f04,0xc(%esp)
f0101e5a:	f0 
f0101e5b:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101e62:	f0 
f0101e63:	c7 44 24 04 43 04 00 	movl   $0x443,0x4(%esp)
f0101e6a:	00 
f0101e6b:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101e72:	e8 26 e2 ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f0101e77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101e7e:	e8 be f5 ff ff       	call   f0101441 <page_alloc>
f0101e83:	89 c7                	mov    %eax,%edi
f0101e85:	85 c0                	test   %eax,%eax
f0101e87:	75 24                	jne    f0101ead <mem_init+0x437>
f0101e89:	c7 44 24 0c 1a 8f 10 	movl   $0xf0108f1a,0xc(%esp)
f0101e90:	f0 
f0101e91:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101e98:	f0 
f0101e99:	c7 44 24 04 44 04 00 	movl   $0x444,0x4(%esp)
f0101ea0:	00 
f0101ea1:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101ea8:	e8 f0 e1 ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f0101ead:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101eb4:	e8 88 f5 ff ff       	call   f0101441 <page_alloc>
f0101eb9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101ebc:	85 c0                	test   %eax,%eax
f0101ebe:	75 24                	jne    f0101ee4 <mem_init+0x46e>
f0101ec0:	c7 44 24 0c 30 8f 10 	movl   $0xf0108f30,0xc(%esp)
f0101ec7:	f0 
f0101ec8:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101ecf:	f0 
f0101ed0:	c7 44 24 04 45 04 00 	movl   $0x445,0x4(%esp)
f0101ed7:	00 
f0101ed8:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101edf:	e8 b9 e1 ff ff       	call   f010009d <_panic>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101ee4:	39 fe                	cmp    %edi,%esi
f0101ee6:	75 24                	jne    f0101f0c <mem_init+0x496>
f0101ee8:	c7 44 24 0c 46 8f 10 	movl   $0xf0108f46,0xc(%esp)
f0101eef:	f0 
f0101ef0:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101ef7:	f0 
f0101ef8:	c7 44 24 04 47 04 00 	movl   $0x447,0x4(%esp)
f0101eff:	00 
f0101f00:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101f07:	e8 91 e1 ff ff       	call   f010009d <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101f0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f0f:	39 c7                	cmp    %eax,%edi
f0101f11:	74 04                	je     f0101f17 <mem_init+0x4a1>
f0101f13:	39 c6                	cmp    %eax,%esi
f0101f15:	75 24                	jne    f0101f3b <mem_init+0x4c5>
f0101f17:	c7 44 24 0c 38 93 10 	movl   $0xf0109338,0xc(%esp)
f0101f1e:	f0 
f0101f1f:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101f26:	f0 
f0101f27:	c7 44 24 04 48 04 00 	movl   $0x448,0x4(%esp)
f0101f2e:	00 
f0101f2f:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101f36:	e8 62 e1 ff ff       	call   f010009d <_panic>
	assert(!page_alloc(0));
f0101f3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101f42:	e8 fa f4 ff ff       	call   f0101441 <page_alloc>
f0101f47:	85 c0                	test   %eax,%eax
f0101f49:	74 24                	je     f0101f6f <mem_init+0x4f9>
f0101f4b:	c7 44 24 0c af 8f 10 	movl   $0xf0108faf,0xc(%esp)
f0101f52:	f0 
f0101f53:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101f5a:	f0 
f0101f5b:	c7 44 24 04 49 04 00 	movl   $0x449,0x4(%esp)
f0101f62:	00 
f0101f63:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101f6a:	e8 2e e1 ff ff       	call   f010009d <_panic>
f0101f6f:	89 f0                	mov    %esi,%eax
f0101f71:	2b 05 a4 3e 2c f0    	sub    0xf02c3ea4,%eax
f0101f77:	c1 f8 03             	sar    $0x3,%eax
f0101f7a:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101f7d:	89 c2                	mov    %eax,%edx
f0101f7f:	c1 ea 0c             	shr    $0xc,%edx
f0101f82:	3b 15 9c 3e 2c f0    	cmp    0xf02c3e9c,%edx
f0101f88:	72 20                	jb     f0101faa <mem_init+0x534>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101f8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101f8e:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0101f95:	f0 
f0101f96:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
f0101f9d:	00 
f0101f9e:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0101fa5:	e8 f3 e0 ff ff       	call   f010009d <_panic>

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f0101faa:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101fb1:	00 
f0101fb2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0101fb9:	00 
	return (void *)(pa + KERNBASE);
f0101fba:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101fbf:	89 04 24             	mov    %eax,(%esp)
f0101fc2:	e8 e0 4d 00 00       	call   f0106da7 <memset>
	page_free(pp0);
f0101fc7:	89 34 24             	mov    %esi,(%esp)
f0101fca:	e8 fd f4 ff ff       	call   f01014cc <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101fcf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101fd6:	e8 66 f4 ff ff       	call   f0101441 <page_alloc>
f0101fdb:	85 c0                	test   %eax,%eax
f0101fdd:	75 24                	jne    f0102003 <mem_init+0x58d>
f0101fdf:	c7 44 24 0c be 8f 10 	movl   $0xf0108fbe,0xc(%esp)
f0101fe6:	f0 
f0101fe7:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0101fee:	f0 
f0101fef:	c7 44 24 04 4e 04 00 	movl   $0x44e,0x4(%esp)
f0101ff6:	00 
f0101ff7:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0101ffe:	e8 9a e0 ff ff       	call   f010009d <_panic>
	assert(pp && pp0 == pp);
f0102003:	39 c6                	cmp    %eax,%esi
f0102005:	74 24                	je     f010202b <mem_init+0x5b5>
f0102007:	c7 44 24 0c dc 8f 10 	movl   $0xf0108fdc,0xc(%esp)
f010200e:	f0 
f010200f:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102016:	f0 
f0102017:	c7 44 24 04 4f 04 00 	movl   $0x44f,0x4(%esp)
f010201e:	00 
f010201f:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102026:	e8 72 e0 ff ff       	call   f010009d <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010202b:	89 f0                	mov    %esi,%eax
f010202d:	2b 05 a4 3e 2c f0    	sub    0xf02c3ea4,%eax
f0102033:	c1 f8 03             	sar    $0x3,%eax
f0102036:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102039:	89 c2                	mov    %eax,%edx
f010203b:	c1 ea 0c             	shr    $0xc,%edx
f010203e:	3b 15 9c 3e 2c f0    	cmp    0xf02c3e9c,%edx
f0102044:	72 20                	jb     f0102066 <mem_init+0x5f0>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102046:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010204a:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0102051:	f0 
f0102052:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
f0102059:	00 
f010205a:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0102061:	e8 37 e0 ff ff       	call   f010009d <_panic>
f0102066:	8d 90 00 10 00 f0    	lea    -0xffff000(%eax),%edx
	return (void *)(pa + KERNBASE);
f010206c:	8d 80 00 00 00 f0    	lea    -0x10000000(%eax),%eax
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);
f0102072:	80 38 00             	cmpb   $0x0,(%eax)
f0102075:	74 24                	je     f010209b <mem_init+0x625>
f0102077:	c7 44 24 0c ec 8f 10 	movl   $0xf0108fec,0xc(%esp)
f010207e:	f0 
f010207f:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102086:	f0 
f0102087:	c7 44 24 04 52 04 00 	movl   $0x452,0x4(%esp)
f010208e:	00 
f010208f:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102096:	e8 02 e0 ff ff       	call   f010009d <_panic>
f010209b:	83 c0 01             	add    $0x1,%eax
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
f010209e:	39 d0                	cmp    %edx,%eax
f01020a0:	75 d0                	jne    f0102072 <mem_init+0x5fc>
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
f01020a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01020a5:	a3 40 32 2c f0       	mov    %eax,0xf02c3240

	// free the pages we took
	page_free(pp0);
f01020aa:	89 34 24             	mov    %esi,(%esp)
f01020ad:	e8 1a f4 ff ff       	call   f01014cc <page_free>
	page_free(pp1);
f01020b2:	89 3c 24             	mov    %edi,(%esp)
f01020b5:	e8 12 f4 ff ff       	call   f01014cc <page_free>
	page_free(pp2);
f01020ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01020bd:	89 04 24             	mov    %eax,(%esp)
f01020c0:	e8 07 f4 ff ff       	call   f01014cc <page_free>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01020c5:	a1 40 32 2c f0       	mov    0xf02c3240,%eax
f01020ca:	eb 05                	jmp    f01020d1 <mem_init+0x65b>
		--nfree;
f01020cc:	83 eb 01             	sub    $0x1,%ebx
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01020cf:	8b 00                	mov    (%eax),%eax
f01020d1:	85 c0                	test   %eax,%eax
f01020d3:	75 f7                	jne    f01020cc <mem_init+0x656>
		--nfree;
	assert(nfree == 0);
f01020d5:	85 db                	test   %ebx,%ebx
f01020d7:	74 24                	je     f01020fd <mem_init+0x687>
f01020d9:	c7 44 24 0c f6 8f 10 	movl   $0xf0108ff6,0xc(%esp)
f01020e0:	f0 
f01020e1:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01020e8:	f0 
f01020e9:	c7 44 24 04 5f 04 00 	movl   $0x45f,0x4(%esp)
f01020f0:	00 
f01020f1:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01020f8:	e8 a0 df ff ff       	call   f010009d <_panic>

	cprintf("check_page_alloc() succeeded!\n");
f01020fd:	c7 04 24 58 93 10 f0 	movl   $0xf0109358,(%esp)
f0102104:	e8 1e 27 00 00       	call   f0104827 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102109:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102110:	e8 2c f3 ff ff       	call   f0101441 <page_alloc>
f0102115:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102118:	85 c0                	test   %eax,%eax
f010211a:	75 24                	jne    f0102140 <mem_init+0x6ca>
f010211c:	c7 44 24 0c 04 8f 10 	movl   $0xf0108f04,0xc(%esp)
f0102123:	f0 
f0102124:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010212b:	f0 
f010212c:	c7 44 24 04 ca 04 00 	movl   $0x4ca,0x4(%esp)
f0102133:	00 
f0102134:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010213b:	e8 5d df ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f0102140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102147:	e8 f5 f2 ff ff       	call   f0101441 <page_alloc>
f010214c:	89 c3                	mov    %eax,%ebx
f010214e:	85 c0                	test   %eax,%eax
f0102150:	75 24                	jne    f0102176 <mem_init+0x700>
f0102152:	c7 44 24 0c 1a 8f 10 	movl   $0xf0108f1a,0xc(%esp)
f0102159:	f0 
f010215a:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102161:	f0 
f0102162:	c7 44 24 04 cb 04 00 	movl   $0x4cb,0x4(%esp)
f0102169:	00 
f010216a:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102171:	e8 27 df ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f0102176:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010217d:	e8 bf f2 ff ff       	call   f0101441 <page_alloc>
f0102182:	89 c6                	mov    %eax,%esi
f0102184:	85 c0                	test   %eax,%eax
f0102186:	75 24                	jne    f01021ac <mem_init+0x736>
f0102188:	c7 44 24 0c 30 8f 10 	movl   $0xf0108f30,0xc(%esp)
f010218f:	f0 
f0102190:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102197:	f0 
f0102198:	c7 44 24 04 cc 04 00 	movl   $0x4cc,0x4(%esp)
f010219f:	00 
f01021a0:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01021a7:	e8 f1 de ff ff       	call   f010009d <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f01021ac:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f01021af:	75 24                	jne    f01021d5 <mem_init+0x75f>
f01021b1:	c7 44 24 0c 46 8f 10 	movl   $0xf0108f46,0xc(%esp)
f01021b8:	f0 
f01021b9:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01021c0:	f0 
f01021c1:	c7 44 24 04 cf 04 00 	movl   $0x4cf,0x4(%esp)
f01021c8:	00 
f01021c9:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01021d0:	e8 c8 de ff ff       	call   f010009d <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01021d5:	39 c3                	cmp    %eax,%ebx
f01021d7:	74 05                	je     f01021de <mem_init+0x768>
f01021d9:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f01021dc:	75 24                	jne    f0102202 <mem_init+0x78c>
f01021de:	c7 44 24 0c 38 93 10 	movl   $0xf0109338,0xc(%esp)
f01021e5:	f0 
f01021e6:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01021ed:	f0 
f01021ee:	c7 44 24 04 d0 04 00 	movl   $0x4d0,0x4(%esp)
f01021f5:	00 
f01021f6:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01021fd:	e8 9b de ff ff       	call   f010009d <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102202:	a1 40 32 2c f0       	mov    0xf02c3240,%eax
f0102207:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f010220a:	c7 05 40 32 2c f0 00 	movl   $0x0,0xf02c3240
f0102211:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0102214:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010221b:	e8 21 f2 ff ff       	call   f0101441 <page_alloc>
f0102220:	85 c0                	test   %eax,%eax
f0102222:	74 24                	je     f0102248 <mem_init+0x7d2>
f0102224:	c7 44 24 0c af 8f 10 	movl   $0xf0108faf,0xc(%esp)
f010222b:	f0 
f010222c:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102233:	f0 
f0102234:	c7 44 24 04 d7 04 00 	movl   $0x4d7,0x4(%esp)
f010223b:	00 
f010223c:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102243:	e8 55 de ff ff       	call   f010009d <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102248:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010224b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010224f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102256:	00 
f0102257:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f010225c:	89 04 24             	mov    %eax,(%esp)
f010225f:	e8 bc f5 ff ff       	call   f0101820 <page_lookup>
f0102264:	85 c0                	test   %eax,%eax
f0102266:	74 24                	je     f010228c <mem_init+0x816>
f0102268:	c7 44 24 0c 78 93 10 	movl   $0xf0109378,0xc(%esp)
f010226f:	f0 
f0102270:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102277:	f0 
f0102278:	c7 44 24 04 da 04 00 	movl   $0x4da,0x4(%esp)
f010227f:	00 
f0102280:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102287:	e8 11 de ff ff       	call   f010009d <_panic>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f010228c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102293:	00 
f0102294:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010229b:	00 
f010229c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01022a0:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f01022a5:	89 04 24             	mov    %eax,(%esp)
f01022a8:	e8 7b f6 ff ff       	call   f0101928 <page_insert>
f01022ad:	85 c0                	test   %eax,%eax
f01022af:	78 24                	js     f01022d5 <mem_init+0x85f>
f01022b1:	c7 44 24 0c b0 93 10 	movl   $0xf01093b0,0xc(%esp)
f01022b8:	f0 
f01022b9:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01022c0:	f0 
f01022c1:	c7 44 24 04 dd 04 00 	movl   $0x4dd,0x4(%esp)
f01022c8:	00 
f01022c9:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01022d0:	e8 c8 dd ff ff       	call   f010009d <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f01022d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01022d8:	89 04 24             	mov    %eax,(%esp)
f01022db:	e8 ec f1 ff ff       	call   f01014cc <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01022e0:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01022e7:	00 
f01022e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01022ef:	00 
f01022f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01022f4:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f01022f9:	89 04 24             	mov    %eax,(%esp)
f01022fc:	e8 27 f6 ff ff       	call   f0101928 <page_insert>
f0102301:	85 c0                	test   %eax,%eax
f0102303:	74 24                	je     f0102329 <mem_init+0x8b3>
f0102305:	c7 44 24 0c e0 93 10 	movl   $0xf01093e0,0xc(%esp)
f010230c:	f0 
f010230d:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102314:	f0 
f0102315:	c7 44 24 04 e1 04 00 	movl   $0x4e1,0x4(%esp)
f010231c:	00 
f010231d:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102324:	e8 74 dd ff ff       	call   f010009d <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102329:	8b 3d a0 3e 2c f0    	mov    0xf02c3ea0,%edi
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010232f:	a1 a4 3e 2c f0       	mov    0xf02c3ea4,%eax
f0102334:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102337:	8b 17                	mov    (%edi),%edx
f0102339:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010233f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102342:	29 c1                	sub    %eax,%ecx
f0102344:	89 c8                	mov    %ecx,%eax
f0102346:	c1 f8 03             	sar    $0x3,%eax
f0102349:	c1 e0 0c             	shl    $0xc,%eax
f010234c:	39 c2                	cmp    %eax,%edx
f010234e:	74 24                	je     f0102374 <mem_init+0x8fe>
f0102350:	c7 44 24 0c 10 94 10 	movl   $0xf0109410,0xc(%esp)
f0102357:	f0 
f0102358:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010235f:	f0 
f0102360:	c7 44 24 04 e2 04 00 	movl   $0x4e2,0x4(%esp)
f0102367:	00 
f0102368:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010236f:	e8 29 dd ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102374:	ba 00 00 00 00       	mov    $0x0,%edx
f0102379:	89 f8                	mov    %edi,%eax
f010237b:	e8 ee ea ff ff       	call   f0100e6e <check_va2pa>
f0102380:	89 da                	mov    %ebx,%edx
f0102382:	2b 55 cc             	sub    -0x34(%ebp),%edx
f0102385:	c1 fa 03             	sar    $0x3,%edx
f0102388:	c1 e2 0c             	shl    $0xc,%edx
f010238b:	39 d0                	cmp    %edx,%eax
f010238d:	74 24                	je     f01023b3 <mem_init+0x93d>
f010238f:	c7 44 24 0c 38 94 10 	movl   $0xf0109438,0xc(%esp)
f0102396:	f0 
f0102397:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010239e:	f0 
f010239f:	c7 44 24 04 e3 04 00 	movl   $0x4e3,0x4(%esp)
f01023a6:	00 
f01023a7:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01023ae:	e8 ea dc ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 1);
f01023b3:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01023b8:	74 24                	je     f01023de <mem_init+0x968>
f01023ba:	c7 44 24 0c 01 90 10 	movl   $0xf0109001,0xc(%esp)
f01023c1:	f0 
f01023c2:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01023c9:	f0 
f01023ca:	c7 44 24 04 e4 04 00 	movl   $0x4e4,0x4(%esp)
f01023d1:	00 
f01023d2:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01023d9:	e8 bf dc ff ff       	call   f010009d <_panic>
	assert(pp0->pp_ref == 1);
f01023de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01023e1:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f01023e6:	74 24                	je     f010240c <mem_init+0x996>
f01023e8:	c7 44 24 0c 12 90 10 	movl   $0xf0109012,0xc(%esp)
f01023ef:	f0 
f01023f0:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01023f7:	f0 
f01023f8:	c7 44 24 04 e5 04 00 	movl   $0x4e5,0x4(%esp)
f01023ff:	00 
f0102400:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102407:	e8 91 dc ff ff       	call   f010009d <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010240c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102413:	00 
f0102414:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010241b:	00 
f010241c:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102420:	89 3c 24             	mov    %edi,(%esp)
f0102423:	e8 00 f5 ff ff       	call   f0101928 <page_insert>
f0102428:	85 c0                	test   %eax,%eax
f010242a:	74 24                	je     f0102450 <mem_init+0x9da>
f010242c:	c7 44 24 0c 68 94 10 	movl   $0xf0109468,0xc(%esp)
f0102433:	f0 
f0102434:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010243b:	f0 
f010243c:	c7 44 24 04 e8 04 00 	movl   $0x4e8,0x4(%esp)
f0102443:	00 
f0102444:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010244b:	e8 4d dc ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102450:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102455:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f010245a:	e8 0f ea ff ff       	call   f0100e6e <check_va2pa>
f010245f:	89 f2                	mov    %esi,%edx
f0102461:	2b 15 a4 3e 2c f0    	sub    0xf02c3ea4,%edx
f0102467:	c1 fa 03             	sar    $0x3,%edx
f010246a:	c1 e2 0c             	shl    $0xc,%edx
f010246d:	39 d0                	cmp    %edx,%eax
f010246f:	74 24                	je     f0102495 <mem_init+0xa1f>
f0102471:	c7 44 24 0c a4 94 10 	movl   $0xf01094a4,0xc(%esp)
f0102478:	f0 
f0102479:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102480:	f0 
f0102481:	c7 44 24 04 e9 04 00 	movl   $0x4e9,0x4(%esp)
f0102488:	00 
f0102489:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102490:	e8 08 dc ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f0102495:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010249a:	74 24                	je     f01024c0 <mem_init+0xa4a>
f010249c:	c7 44 24 0c 23 90 10 	movl   $0xf0109023,0xc(%esp)
f01024a3:	f0 
f01024a4:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01024ab:	f0 
f01024ac:	c7 44 24 04 ea 04 00 	movl   $0x4ea,0x4(%esp)
f01024b3:	00 
f01024b4:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01024bb:	e8 dd db ff ff       	call   f010009d <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f01024c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01024c7:	e8 75 ef ff ff       	call   f0101441 <page_alloc>
f01024cc:	85 c0                	test   %eax,%eax
f01024ce:	74 24                	je     f01024f4 <mem_init+0xa7e>
f01024d0:	c7 44 24 0c af 8f 10 	movl   $0xf0108faf,0xc(%esp)
f01024d7:	f0 
f01024d8:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01024df:	f0 
f01024e0:	c7 44 24 04 ed 04 00 	movl   $0x4ed,0x4(%esp)
f01024e7:	00 
f01024e8:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01024ef:	e8 a9 db ff ff       	call   f010009d <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01024f4:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01024fb:	00 
f01024fc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102503:	00 
f0102504:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102508:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f010250d:	89 04 24             	mov    %eax,(%esp)
f0102510:	e8 13 f4 ff ff       	call   f0101928 <page_insert>
f0102515:	85 c0                	test   %eax,%eax
f0102517:	74 24                	je     f010253d <mem_init+0xac7>
f0102519:	c7 44 24 0c 68 94 10 	movl   $0xf0109468,0xc(%esp)
f0102520:	f0 
f0102521:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102528:	f0 
f0102529:	c7 44 24 04 f0 04 00 	movl   $0x4f0,0x4(%esp)
f0102530:	00 
f0102531:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102538:	e8 60 db ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010253d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102542:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0102547:	e8 22 e9 ff ff       	call   f0100e6e <check_va2pa>
f010254c:	89 f2                	mov    %esi,%edx
f010254e:	2b 15 a4 3e 2c f0    	sub    0xf02c3ea4,%edx
f0102554:	c1 fa 03             	sar    $0x3,%edx
f0102557:	c1 e2 0c             	shl    $0xc,%edx
f010255a:	39 d0                	cmp    %edx,%eax
f010255c:	74 24                	je     f0102582 <mem_init+0xb0c>
f010255e:	c7 44 24 0c a4 94 10 	movl   $0xf01094a4,0xc(%esp)
f0102565:	f0 
f0102566:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010256d:	f0 
f010256e:	c7 44 24 04 f1 04 00 	movl   $0x4f1,0x4(%esp)
f0102575:	00 
f0102576:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010257d:	e8 1b db ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f0102582:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102587:	74 24                	je     f01025ad <mem_init+0xb37>
f0102589:	c7 44 24 0c 23 90 10 	movl   $0xf0109023,0xc(%esp)
f0102590:	f0 
f0102591:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102598:	f0 
f0102599:	c7 44 24 04 f2 04 00 	movl   $0x4f2,0x4(%esp)
f01025a0:	00 
f01025a1:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01025a8:	e8 f0 da ff ff       	call   f010009d <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f01025ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01025b4:	e8 88 ee ff ff       	call   f0101441 <page_alloc>
f01025b9:	85 c0                	test   %eax,%eax
f01025bb:	74 24                	je     f01025e1 <mem_init+0xb6b>
f01025bd:	c7 44 24 0c af 8f 10 	movl   $0xf0108faf,0xc(%esp)
f01025c4:	f0 
f01025c5:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01025cc:	f0 
f01025cd:	c7 44 24 04 f6 04 00 	movl   $0x4f6,0x4(%esp)
f01025d4:	00 
f01025d5:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01025dc:	e8 bc da ff ff       	call   f010009d <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f01025e1:	8b 15 a0 3e 2c f0    	mov    0xf02c3ea0,%edx
f01025e7:	8b 02                	mov    (%edx),%eax
f01025e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01025ee:	89 c1                	mov    %eax,%ecx
f01025f0:	c1 e9 0c             	shr    $0xc,%ecx
f01025f3:	3b 0d 9c 3e 2c f0    	cmp    0xf02c3e9c,%ecx
f01025f9:	72 20                	jb     f010261b <mem_init+0xba5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01025fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01025ff:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0102606:	f0 
f0102607:	c7 44 24 04 f9 04 00 	movl   $0x4f9,0x4(%esp)
f010260e:	00 
f010260f:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102616:	e8 82 da ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f010261b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102623:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010262a:	00 
f010262b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102632:	00 
f0102633:	89 14 24             	mov    %edx,(%esp)
f0102636:	e8 d0 ee ff ff       	call   f010150b <pgdir_walk>
f010263b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010263e:	8d 51 04             	lea    0x4(%ecx),%edx
f0102641:	39 d0                	cmp    %edx,%eax
f0102643:	74 24                	je     f0102669 <mem_init+0xbf3>
f0102645:	c7 44 24 0c d4 94 10 	movl   $0xf01094d4,0xc(%esp)
f010264c:	f0 
f010264d:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102654:	f0 
f0102655:	c7 44 24 04 fa 04 00 	movl   $0x4fa,0x4(%esp)
f010265c:	00 
f010265d:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102664:	e8 34 da ff ff       	call   f010009d <_panic>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102669:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f0102670:	00 
f0102671:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102678:	00 
f0102679:	89 74 24 04          	mov    %esi,0x4(%esp)
f010267d:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0102682:	89 04 24             	mov    %eax,(%esp)
f0102685:	e8 9e f2 ff ff       	call   f0101928 <page_insert>
f010268a:	85 c0                	test   %eax,%eax
f010268c:	74 24                	je     f01026b2 <mem_init+0xc3c>
f010268e:	c7 44 24 0c 14 95 10 	movl   $0xf0109514,0xc(%esp)
f0102695:	f0 
f0102696:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010269d:	f0 
f010269e:	c7 44 24 04 fd 04 00 	movl   $0x4fd,0x4(%esp)
f01026a5:	00 
f01026a6:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01026ad:	e8 eb d9 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01026b2:	8b 3d a0 3e 2c f0    	mov    0xf02c3ea0,%edi
f01026b8:	ba 00 10 00 00       	mov    $0x1000,%edx
f01026bd:	89 f8                	mov    %edi,%eax
f01026bf:	e8 aa e7 ff ff       	call   f0100e6e <check_va2pa>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01026c4:	89 f2                	mov    %esi,%edx
f01026c6:	2b 15 a4 3e 2c f0    	sub    0xf02c3ea4,%edx
f01026cc:	c1 fa 03             	sar    $0x3,%edx
f01026cf:	c1 e2 0c             	shl    $0xc,%edx
f01026d2:	39 d0                	cmp    %edx,%eax
f01026d4:	74 24                	je     f01026fa <mem_init+0xc84>
f01026d6:	c7 44 24 0c a4 94 10 	movl   $0xf01094a4,0xc(%esp)
f01026dd:	f0 
f01026de:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01026e5:	f0 
f01026e6:	c7 44 24 04 fe 04 00 	movl   $0x4fe,0x4(%esp)
f01026ed:	00 
f01026ee:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01026f5:	e8 a3 d9 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f01026fa:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01026ff:	74 24                	je     f0102725 <mem_init+0xcaf>
f0102701:	c7 44 24 0c 23 90 10 	movl   $0xf0109023,0xc(%esp)
f0102708:	f0 
f0102709:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102710:	f0 
f0102711:	c7 44 24 04 ff 04 00 	movl   $0x4ff,0x4(%esp)
f0102718:	00 
f0102719:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102720:	e8 78 d9 ff ff       	call   f010009d <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102725:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010272c:	00 
f010272d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102734:	00 
f0102735:	89 3c 24             	mov    %edi,(%esp)
f0102738:	e8 ce ed ff ff       	call   f010150b <pgdir_walk>
f010273d:	f6 00 04             	testb  $0x4,(%eax)
f0102740:	75 24                	jne    f0102766 <mem_init+0xcf0>
f0102742:	c7 44 24 0c 54 95 10 	movl   $0xf0109554,0xc(%esp)
f0102749:	f0 
f010274a:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102751:	f0 
f0102752:	c7 44 24 04 00 05 00 	movl   $0x500,0x4(%esp)
f0102759:	00 
f010275a:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102761:	e8 37 d9 ff ff       	call   f010009d <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102766:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f010276b:	f6 00 04             	testb  $0x4,(%eax)
f010276e:	75 24                	jne    f0102794 <mem_init+0xd1e>
f0102770:	c7 44 24 0c 34 90 10 	movl   $0xf0109034,0xc(%esp)
f0102777:	f0 
f0102778:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010277f:	f0 
f0102780:	c7 44 24 04 01 05 00 	movl   $0x501,0x4(%esp)
f0102787:	00 
f0102788:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010278f:	e8 09 d9 ff ff       	call   f010009d <_panic>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102794:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010279b:	00 
f010279c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01027a3:	00 
f01027a4:	89 74 24 04          	mov    %esi,0x4(%esp)
f01027a8:	89 04 24             	mov    %eax,(%esp)
f01027ab:	e8 78 f1 ff ff       	call   f0101928 <page_insert>
f01027b0:	85 c0                	test   %eax,%eax
f01027b2:	74 24                	je     f01027d8 <mem_init+0xd62>
f01027b4:	c7 44 24 0c 68 94 10 	movl   $0xf0109468,0xc(%esp)
f01027bb:	f0 
f01027bc:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01027c3:	f0 
f01027c4:	c7 44 24 04 04 05 00 	movl   $0x504,0x4(%esp)
f01027cb:	00 
f01027cc:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01027d3:	e8 c5 d8 ff ff       	call   f010009d <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01027d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01027df:	00 
f01027e0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01027e7:	00 
f01027e8:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f01027ed:	89 04 24             	mov    %eax,(%esp)
f01027f0:	e8 16 ed ff ff       	call   f010150b <pgdir_walk>
f01027f5:	f6 00 02             	testb  $0x2,(%eax)
f01027f8:	75 24                	jne    f010281e <mem_init+0xda8>
f01027fa:	c7 44 24 0c 88 95 10 	movl   $0xf0109588,0xc(%esp)
f0102801:	f0 
f0102802:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102809:	f0 
f010280a:	c7 44 24 04 05 05 00 	movl   $0x505,0x4(%esp)
f0102811:	00 
f0102812:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102819:	e8 7f d8 ff ff       	call   f010009d <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010281e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102825:	00 
f0102826:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010282d:	00 
f010282e:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0102833:	89 04 24             	mov    %eax,(%esp)
f0102836:	e8 d0 ec ff ff       	call   f010150b <pgdir_walk>
f010283b:	f6 00 04             	testb  $0x4,(%eax)
f010283e:	74 24                	je     f0102864 <mem_init+0xdee>
f0102840:	c7 44 24 0c bc 95 10 	movl   $0xf01095bc,0xc(%esp)
f0102847:	f0 
f0102848:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010284f:	f0 
f0102850:	c7 44 24 04 06 05 00 	movl   $0x506,0x4(%esp)
f0102857:	00 
f0102858:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010285f:	e8 39 d8 ff ff       	call   f010009d <_panic>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102864:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010286b:	00 
f010286c:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
f0102873:	00 
f0102874:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102877:	89 44 24 04          	mov    %eax,0x4(%esp)
f010287b:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0102880:	89 04 24             	mov    %eax,(%esp)
f0102883:	e8 a0 f0 ff ff       	call   f0101928 <page_insert>
f0102888:	85 c0                	test   %eax,%eax
f010288a:	78 24                	js     f01028b0 <mem_init+0xe3a>
f010288c:	c7 44 24 0c f4 95 10 	movl   $0xf01095f4,0xc(%esp)
f0102893:	f0 
f0102894:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010289b:	f0 
f010289c:	c7 44 24 04 09 05 00 	movl   $0x509,0x4(%esp)
f01028a3:	00 
f01028a4:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01028ab:	e8 ed d7 ff ff       	call   f010009d <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01028b0:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01028b7:	00 
f01028b8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01028bf:	00 
f01028c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01028c4:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f01028c9:	89 04 24             	mov    %eax,(%esp)
f01028cc:	e8 57 f0 ff ff       	call   f0101928 <page_insert>
f01028d1:	85 c0                	test   %eax,%eax
f01028d3:	74 24                	je     f01028f9 <mem_init+0xe83>
f01028d5:	c7 44 24 0c 2c 96 10 	movl   $0xf010962c,0xc(%esp)
f01028dc:	f0 
f01028dd:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01028e4:	f0 
f01028e5:	c7 44 24 04 0c 05 00 	movl   $0x50c,0x4(%esp)
f01028ec:	00 
f01028ed:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01028f4:	e8 a4 d7 ff ff       	call   f010009d <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01028f9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102900:	00 
f0102901:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102908:	00 
f0102909:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f010290e:	89 04 24             	mov    %eax,(%esp)
f0102911:	e8 f5 eb ff ff       	call   f010150b <pgdir_walk>
f0102916:	f6 00 04             	testb  $0x4,(%eax)
f0102919:	74 24                	je     f010293f <mem_init+0xec9>
f010291b:	c7 44 24 0c bc 95 10 	movl   $0xf01095bc,0xc(%esp)
f0102922:	f0 
f0102923:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010292a:	f0 
f010292b:	c7 44 24 04 0d 05 00 	movl   $0x50d,0x4(%esp)
f0102932:	00 
f0102933:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010293a:	e8 5e d7 ff ff       	call   f010009d <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010293f:	8b 3d a0 3e 2c f0    	mov    0xf02c3ea0,%edi
f0102945:	ba 00 00 00 00       	mov    $0x0,%edx
f010294a:	89 f8                	mov    %edi,%eax
f010294c:	e8 1d e5 ff ff       	call   f0100e6e <check_va2pa>
f0102951:	89 c1                	mov    %eax,%ecx
f0102953:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102956:	89 d8                	mov    %ebx,%eax
f0102958:	2b 05 a4 3e 2c f0    	sub    0xf02c3ea4,%eax
f010295e:	c1 f8 03             	sar    $0x3,%eax
f0102961:	c1 e0 0c             	shl    $0xc,%eax
f0102964:	39 c1                	cmp    %eax,%ecx
f0102966:	74 24                	je     f010298c <mem_init+0xf16>
f0102968:	c7 44 24 0c 68 96 10 	movl   $0xf0109668,0xc(%esp)
f010296f:	f0 
f0102970:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102977:	f0 
f0102978:	c7 44 24 04 10 05 00 	movl   $0x510,0x4(%esp)
f010297f:	00 
f0102980:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102987:	e8 11 d7 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010298c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102991:	89 f8                	mov    %edi,%eax
f0102993:	e8 d6 e4 ff ff       	call   f0100e6e <check_va2pa>
f0102998:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f010299b:	74 24                	je     f01029c1 <mem_init+0xf4b>
f010299d:	c7 44 24 0c 94 96 10 	movl   $0xf0109694,0xc(%esp)
f01029a4:	f0 
f01029a5:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01029ac:	f0 
f01029ad:	c7 44 24 04 11 05 00 	movl   $0x511,0x4(%esp)
f01029b4:	00 
f01029b5:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01029bc:	e8 dc d6 ff ff       	call   f010009d <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f01029c1:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f01029c6:	74 24                	je     f01029ec <mem_init+0xf76>
f01029c8:	c7 44 24 0c 4a 90 10 	movl   $0xf010904a,0xc(%esp)
f01029cf:	f0 
f01029d0:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01029d7:	f0 
f01029d8:	c7 44 24 04 13 05 00 	movl   $0x513,0x4(%esp)
f01029df:	00 
f01029e0:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01029e7:	e8 b1 d6 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 0);
f01029ec:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01029f1:	74 24                	je     f0102a17 <mem_init+0xfa1>
f01029f3:	c7 44 24 0c 5b 90 10 	movl   $0xf010905b,0xc(%esp)
f01029fa:	f0 
f01029fb:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102a02:	f0 
f0102a03:	c7 44 24 04 14 05 00 	movl   $0x514,0x4(%esp)
f0102a0a:	00 
f0102a0b:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102a12:	e8 86 d6 ff ff       	call   f010009d <_panic>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0102a17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102a1e:	e8 1e ea ff ff       	call   f0101441 <page_alloc>
f0102a23:	85 c0                	test   %eax,%eax
f0102a25:	74 04                	je     f0102a2b <mem_init+0xfb5>
f0102a27:	39 c6                	cmp    %eax,%esi
f0102a29:	74 24                	je     f0102a4f <mem_init+0xfd9>
f0102a2b:	c7 44 24 0c c4 96 10 	movl   $0xf01096c4,0xc(%esp)
f0102a32:	f0 
f0102a33:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102a3a:	f0 
f0102a3b:	c7 44 24 04 17 05 00 	movl   $0x517,0x4(%esp)
f0102a42:	00 
f0102a43:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102a4a:	e8 4e d6 ff ff       	call   f010009d <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0102a4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102a56:	00 
f0102a57:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0102a5c:	89 04 24             	mov    %eax,(%esp)
f0102a5f:	e8 69 ee ff ff       	call   f01018cd <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102a64:	8b 3d a0 3e 2c f0    	mov    0xf02c3ea0,%edi
f0102a6a:	ba 00 00 00 00       	mov    $0x0,%edx
f0102a6f:	89 f8                	mov    %edi,%eax
f0102a71:	e8 f8 e3 ff ff       	call   f0100e6e <check_va2pa>
f0102a76:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a79:	74 24                	je     f0102a9f <mem_init+0x1029>
f0102a7b:	c7 44 24 0c e8 96 10 	movl   $0xf01096e8,0xc(%esp)
f0102a82:	f0 
f0102a83:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102a8a:	f0 
f0102a8b:	c7 44 24 04 1b 05 00 	movl   $0x51b,0x4(%esp)
f0102a92:	00 
f0102a93:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102a9a:	e8 fe d5 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102a9f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102aa4:	89 f8                	mov    %edi,%eax
f0102aa6:	e8 c3 e3 ff ff       	call   f0100e6e <check_va2pa>
f0102aab:	89 da                	mov    %ebx,%edx
f0102aad:	2b 15 a4 3e 2c f0    	sub    0xf02c3ea4,%edx
f0102ab3:	c1 fa 03             	sar    $0x3,%edx
f0102ab6:	c1 e2 0c             	shl    $0xc,%edx
f0102ab9:	39 d0                	cmp    %edx,%eax
f0102abb:	74 24                	je     f0102ae1 <mem_init+0x106b>
f0102abd:	c7 44 24 0c 94 96 10 	movl   $0xf0109694,0xc(%esp)
f0102ac4:	f0 
f0102ac5:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102acc:	f0 
f0102acd:	c7 44 24 04 1c 05 00 	movl   $0x51c,0x4(%esp)
f0102ad4:	00 
f0102ad5:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102adc:	e8 bc d5 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 1);
f0102ae1:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102ae6:	74 24                	je     f0102b0c <mem_init+0x1096>
f0102ae8:	c7 44 24 0c 01 90 10 	movl   $0xf0109001,0xc(%esp)
f0102aef:	f0 
f0102af0:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102af7:	f0 
f0102af8:	c7 44 24 04 1d 05 00 	movl   $0x51d,0x4(%esp)
f0102aff:	00 
f0102b00:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102b07:	e8 91 d5 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 0);
f0102b0c:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102b11:	74 24                	je     f0102b37 <mem_init+0x10c1>
f0102b13:	c7 44 24 0c 5b 90 10 	movl   $0xf010905b,0xc(%esp)
f0102b1a:	f0 
f0102b1b:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102b22:	f0 
f0102b23:	c7 44 24 04 1e 05 00 	movl   $0x51e,0x4(%esp)
f0102b2a:	00 
f0102b2b:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102b32:	e8 66 d5 ff ff       	call   f010009d <_panic>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102b37:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0102b3e:	00 
f0102b3f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102b46:	00 
f0102b47:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102b4b:	89 3c 24             	mov    %edi,(%esp)
f0102b4e:	e8 d5 ed ff ff       	call   f0101928 <page_insert>
f0102b53:	85 c0                	test   %eax,%eax
f0102b55:	74 24                	je     f0102b7b <mem_init+0x1105>
f0102b57:	c7 44 24 0c 0c 97 10 	movl   $0xf010970c,0xc(%esp)
f0102b5e:	f0 
f0102b5f:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102b66:	f0 
f0102b67:	c7 44 24 04 21 05 00 	movl   $0x521,0x4(%esp)
f0102b6e:	00 
f0102b6f:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102b76:	e8 22 d5 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref);
f0102b7b:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102b80:	75 24                	jne    f0102ba6 <mem_init+0x1130>
f0102b82:	c7 44 24 0c 6c 90 10 	movl   $0xf010906c,0xc(%esp)
f0102b89:	f0 
f0102b8a:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102b91:	f0 
f0102b92:	c7 44 24 04 22 05 00 	movl   $0x522,0x4(%esp)
f0102b99:	00 
f0102b9a:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102ba1:	e8 f7 d4 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_link == NULL);
f0102ba6:	83 3b 00             	cmpl   $0x0,(%ebx)
f0102ba9:	74 24                	je     f0102bcf <mem_init+0x1159>
f0102bab:	c7 44 24 0c 78 90 10 	movl   $0xf0109078,0xc(%esp)
f0102bb2:	f0 
f0102bb3:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102bba:	f0 
f0102bbb:	c7 44 24 04 23 05 00 	movl   $0x523,0x4(%esp)
f0102bc2:	00 
f0102bc3:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102bca:	e8 ce d4 ff ff       	call   f010009d <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102bcf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102bd6:	00 
f0102bd7:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0102bdc:	89 04 24             	mov    %eax,(%esp)
f0102bdf:	e8 e9 ec ff ff       	call   f01018cd <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102be4:	8b 3d a0 3e 2c f0    	mov    0xf02c3ea0,%edi
f0102bea:	ba 00 00 00 00       	mov    $0x0,%edx
f0102bef:	89 f8                	mov    %edi,%eax
f0102bf1:	e8 78 e2 ff ff       	call   f0100e6e <check_va2pa>
f0102bf6:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102bf9:	74 24                	je     f0102c1f <mem_init+0x11a9>
f0102bfb:	c7 44 24 0c e8 96 10 	movl   $0xf01096e8,0xc(%esp)
f0102c02:	f0 
f0102c03:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102c0a:	f0 
f0102c0b:	c7 44 24 04 27 05 00 	movl   $0x527,0x4(%esp)
f0102c12:	00 
f0102c13:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102c1a:	e8 7e d4 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102c1f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102c24:	89 f8                	mov    %edi,%eax
f0102c26:	e8 43 e2 ff ff       	call   f0100e6e <check_va2pa>
f0102c2b:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102c2e:	74 24                	je     f0102c54 <mem_init+0x11de>
f0102c30:	c7 44 24 0c 44 97 10 	movl   $0xf0109744,0xc(%esp)
f0102c37:	f0 
f0102c38:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102c3f:	f0 
f0102c40:	c7 44 24 04 28 05 00 	movl   $0x528,0x4(%esp)
f0102c47:	00 
f0102c48:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102c4f:	e8 49 d4 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 0);
f0102c54:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102c59:	74 24                	je     f0102c7f <mem_init+0x1209>
f0102c5b:	c7 44 24 0c 8d 90 10 	movl   $0xf010908d,0xc(%esp)
f0102c62:	f0 
f0102c63:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102c6a:	f0 
f0102c6b:	c7 44 24 04 29 05 00 	movl   $0x529,0x4(%esp)
f0102c72:	00 
f0102c73:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102c7a:	e8 1e d4 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 0);
f0102c7f:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102c84:	74 24                	je     f0102caa <mem_init+0x1234>
f0102c86:	c7 44 24 0c 5b 90 10 	movl   $0xf010905b,0xc(%esp)
f0102c8d:	f0 
f0102c8e:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102c95:	f0 
f0102c96:	c7 44 24 04 2a 05 00 	movl   $0x52a,0x4(%esp)
f0102c9d:	00 
f0102c9e:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102ca5:	e8 f3 d3 ff ff       	call   f010009d <_panic>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0102caa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102cb1:	e8 8b e7 ff ff       	call   f0101441 <page_alloc>
f0102cb6:	85 c0                	test   %eax,%eax
f0102cb8:	74 04                	je     f0102cbe <mem_init+0x1248>
f0102cba:	39 c3                	cmp    %eax,%ebx
f0102cbc:	74 24                	je     f0102ce2 <mem_init+0x126c>
f0102cbe:	c7 44 24 0c 6c 97 10 	movl   $0xf010976c,0xc(%esp)
f0102cc5:	f0 
f0102cc6:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102ccd:	f0 
f0102cce:	c7 44 24 04 2d 05 00 	movl   $0x52d,0x4(%esp)
f0102cd5:	00 
f0102cd6:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102cdd:	e8 bb d3 ff ff       	call   f010009d <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f0102ce2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102ce9:	e8 53 e7 ff ff       	call   f0101441 <page_alloc>
f0102cee:	85 c0                	test   %eax,%eax
f0102cf0:	74 24                	je     f0102d16 <mem_init+0x12a0>
f0102cf2:	c7 44 24 0c af 8f 10 	movl   $0xf0108faf,0xc(%esp)
f0102cf9:	f0 
f0102cfa:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102d01:	f0 
f0102d02:	c7 44 24 04 30 05 00 	movl   $0x530,0x4(%esp)
f0102d09:	00 
f0102d0a:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102d11:	e8 87 d3 ff ff       	call   f010009d <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102d16:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0102d1b:	8b 08                	mov    (%eax),%ecx
f0102d1d:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102d23:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0102d26:	2b 15 a4 3e 2c f0    	sub    0xf02c3ea4,%edx
f0102d2c:	c1 fa 03             	sar    $0x3,%edx
f0102d2f:	c1 e2 0c             	shl    $0xc,%edx
f0102d32:	39 d1                	cmp    %edx,%ecx
f0102d34:	74 24                	je     f0102d5a <mem_init+0x12e4>
f0102d36:	c7 44 24 0c 10 94 10 	movl   $0xf0109410,0xc(%esp)
f0102d3d:	f0 
f0102d3e:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102d45:	f0 
f0102d46:	c7 44 24 04 33 05 00 	movl   $0x533,0x4(%esp)
f0102d4d:	00 
f0102d4e:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102d55:	e8 43 d3 ff ff       	call   f010009d <_panic>
	kern_pgdir[0] = 0;
f0102d5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0102d60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d63:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102d68:	74 24                	je     f0102d8e <mem_init+0x1318>
f0102d6a:	c7 44 24 0c 12 90 10 	movl   $0xf0109012,0xc(%esp)
f0102d71:	f0 
f0102d72:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102d79:	f0 
f0102d7a:	c7 44 24 04 35 05 00 	movl   $0x535,0x4(%esp)
f0102d81:	00 
f0102d82:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102d89:	e8 0f d3 ff ff       	call   f010009d <_panic>
	pp0->pp_ref = 0;
f0102d8e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d91:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102d97:	89 04 24             	mov    %eax,(%esp)
f0102d9a:	e8 2d e7 ff ff       	call   f01014cc <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102d9f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102da6:	00 
f0102da7:	c7 44 24 04 00 10 40 	movl   $0x401000,0x4(%esp)
f0102dae:	00 
f0102daf:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0102db4:	89 04 24             	mov    %eax,(%esp)
f0102db7:	e8 4f e7 ff ff       	call   f010150b <pgdir_walk>
f0102dbc:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102dbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102dc2:	8b 15 a0 3e 2c f0    	mov    0xf02c3ea0,%edx
f0102dc8:	8b 7a 04             	mov    0x4(%edx),%edi
f0102dcb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102dd1:	8b 0d 9c 3e 2c f0    	mov    0xf02c3e9c,%ecx
f0102dd7:	89 f8                	mov    %edi,%eax
f0102dd9:	c1 e8 0c             	shr    $0xc,%eax
f0102ddc:	39 c8                	cmp    %ecx,%eax
f0102dde:	72 20                	jb     f0102e00 <mem_init+0x138a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102de0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0102de4:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0102deb:	f0 
f0102dec:	c7 44 24 04 3c 05 00 	movl   $0x53c,0x4(%esp)
f0102df3:	00 
f0102df4:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102dfb:	e8 9d d2 ff ff       	call   f010009d <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102e00:	81 ef fc ff ff 0f    	sub    $0xffffffc,%edi
f0102e06:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0102e09:	74 24                	je     f0102e2f <mem_init+0x13b9>
f0102e0b:	c7 44 24 0c 9e 90 10 	movl   $0xf010909e,0xc(%esp)
f0102e12:	f0 
f0102e13:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102e1a:	f0 
f0102e1b:	c7 44 24 04 3d 05 00 	movl   $0x53d,0x4(%esp)
f0102e22:	00 
f0102e23:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102e2a:	e8 6e d2 ff ff       	call   f010009d <_panic>
	kern_pgdir[PDX(va)] = 0;
f0102e2f:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
	pp0->pp_ref = 0;
f0102e36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102e39:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102e3f:	2b 05 a4 3e 2c f0    	sub    0xf02c3ea4,%eax
f0102e45:	c1 f8 03             	sar    $0x3,%eax
f0102e48:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102e4b:	89 c2                	mov    %eax,%edx
f0102e4d:	c1 ea 0c             	shr    $0xc,%edx
f0102e50:	39 d1                	cmp    %edx,%ecx
f0102e52:	77 20                	ja     f0102e74 <mem_init+0x13fe>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102e54:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102e58:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0102e5f:	f0 
f0102e60:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
f0102e67:	00 
f0102e68:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0102e6f:	e8 29 d2 ff ff       	call   f010009d <_panic>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102e74:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102e7b:	00 
f0102e7c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f0102e83:	00 
	return (void *)(pa + KERNBASE);
f0102e84:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102e89:	89 04 24             	mov    %eax,(%esp)
f0102e8c:	e8 16 3f 00 00       	call   f0106da7 <memset>
	page_free(pp0);
f0102e91:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0102e94:	89 3c 24             	mov    %edi,(%esp)
f0102e97:	e8 30 e6 ff ff       	call   f01014cc <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0102e9c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102ea3:	00 
f0102ea4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102eab:	00 
f0102eac:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0102eb1:	89 04 24             	mov    %eax,(%esp)
f0102eb4:	e8 52 e6 ff ff       	call   f010150b <pgdir_walk>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102eb9:	89 fa                	mov    %edi,%edx
f0102ebb:	2b 15 a4 3e 2c f0    	sub    0xf02c3ea4,%edx
f0102ec1:	c1 fa 03             	sar    $0x3,%edx
f0102ec4:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102ec7:	89 d0                	mov    %edx,%eax
f0102ec9:	c1 e8 0c             	shr    $0xc,%eax
f0102ecc:	3b 05 9c 3e 2c f0    	cmp    0xf02c3e9c,%eax
f0102ed2:	72 20                	jb     f0102ef4 <mem_init+0x147e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102ed4:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0102ed8:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0102edf:	f0 
f0102ee0:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
f0102ee7:	00 
f0102ee8:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0102eef:	e8 a9 d1 ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0102ef4:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0102efa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102efd:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102f03:	f6 00 01             	testb  $0x1,(%eax)
f0102f06:	74 24                	je     f0102f2c <mem_init+0x14b6>
f0102f08:	c7 44 24 0c b6 90 10 	movl   $0xf01090b6,0xc(%esp)
f0102f0f:	f0 
f0102f10:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102f17:	f0 
f0102f18:	c7 44 24 04 47 05 00 	movl   $0x547,0x4(%esp)
f0102f1f:	00 
f0102f20:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102f27:	e8 71 d1 ff ff       	call   f010009d <_panic>
f0102f2c:	83 c0 04             	add    $0x4,%eax
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f0102f2f:	39 d0                	cmp    %edx,%eax
f0102f31:	75 d0                	jne    f0102f03 <mem_init+0x148d>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f0102f33:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0102f38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102f3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102f41:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102f47:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0102f4a:	89 0d 40 32 2c f0    	mov    %ecx,0xf02c3240

	// free the pages we took
	page_free(pp0);
f0102f50:	89 04 24             	mov    %eax,(%esp)
f0102f53:	e8 74 e5 ff ff       	call   f01014cc <page_free>
	page_free(pp1);
f0102f58:	89 1c 24             	mov    %ebx,(%esp)
f0102f5b:	e8 6c e5 ff ff       	call   f01014cc <page_free>
	page_free(pp2);
f0102f60:	89 34 24             	mov    %esi,(%esp)
f0102f63:	e8 64 e5 ff ff       	call   f01014cc <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102f68:	c7 44 24 04 01 10 00 	movl   $0x1001,0x4(%esp)
f0102f6f:	00 
f0102f70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102f77:	e8 73 ea ff ff       	call   f01019ef <mmio_map_region>
f0102f7c:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102f7e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102f85:	00 
f0102f86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102f8d:	e8 5d ea ff ff       	call   f01019ef <mmio_map_region>
f0102f92:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f0102f94:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f0102f9a:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102f9f:	77 08                	ja     f0102fa9 <mem_init+0x1533>
f0102fa1:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102fa7:	77 24                	ja     f0102fcd <mem_init+0x1557>
f0102fa9:	c7 44 24 0c 90 97 10 	movl   $0xf0109790,0xc(%esp)
f0102fb0:	f0 
f0102fb1:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102fb8:	f0 
f0102fb9:	c7 44 24 04 57 05 00 	movl   $0x557,0x4(%esp)
f0102fc0:	00 
f0102fc1:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0102fc8:	e8 d0 d0 ff ff       	call   f010009d <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f0102fcd:	8d 96 a0 1f 00 00    	lea    0x1fa0(%esi),%edx
f0102fd3:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102fd9:	77 08                	ja     f0102fe3 <mem_init+0x156d>
f0102fdb:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102fe1:	77 24                	ja     f0103007 <mem_init+0x1591>
f0102fe3:	c7 44 24 0c b8 97 10 	movl   $0xf01097b8,0xc(%esp)
f0102fea:	f0 
f0102feb:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0102ff2:	f0 
f0102ff3:	c7 44 24 04 58 05 00 	movl   $0x558,0x4(%esp)
f0102ffa:	00 
f0102ffb:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103002:	e8 96 d0 ff ff       	call   f010009d <_panic>
f0103007:	89 da                	mov    %ebx,%edx
f0103009:	09 f2                	or     %esi,%edx
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f010300b:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0103011:	74 24                	je     f0103037 <mem_init+0x15c1>
f0103013:	c7 44 24 0c e0 97 10 	movl   $0xf01097e0,0xc(%esp)
f010301a:	f0 
f010301b:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103022:	f0 
f0103023:	c7 44 24 04 5a 05 00 	movl   $0x55a,0x4(%esp)
f010302a:	00 
f010302b:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103032:	e8 66 d0 ff ff       	call   f010009d <_panic>
	// check that they don't overlap
	assert(mm1 + 8096 <= mm2);
f0103037:	39 c6                	cmp    %eax,%esi
f0103039:	73 24                	jae    f010305f <mem_init+0x15e9>
f010303b:	c7 44 24 0c cd 90 10 	movl   $0xf01090cd,0xc(%esp)
f0103042:	f0 
f0103043:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010304a:	f0 
f010304b:	c7 44 24 04 5c 05 00 	movl   $0x55c,0x4(%esp)
f0103052:	00 
f0103053:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010305a:	e8 3e d0 ff ff       	call   f010009d <_panic>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f010305f:	8b 3d a0 3e 2c f0    	mov    0xf02c3ea0,%edi
f0103065:	89 da                	mov    %ebx,%edx
f0103067:	89 f8                	mov    %edi,%eax
f0103069:	e8 00 de ff ff       	call   f0100e6e <check_va2pa>
f010306e:	85 c0                	test   %eax,%eax
f0103070:	74 24                	je     f0103096 <mem_init+0x1620>
f0103072:	c7 44 24 0c 08 98 10 	movl   $0xf0109808,0xc(%esp)
f0103079:	f0 
f010307a:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103081:	f0 
f0103082:	c7 44 24 04 5e 05 00 	movl   $0x55e,0x4(%esp)
f0103089:	00 
f010308a:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103091:	e8 07 d0 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0103096:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f010309c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010309f:	89 c2                	mov    %eax,%edx
f01030a1:	89 f8                	mov    %edi,%eax
f01030a3:	e8 c6 dd ff ff       	call   f0100e6e <check_va2pa>
f01030a8:	3d 00 10 00 00       	cmp    $0x1000,%eax
f01030ad:	74 24                	je     f01030d3 <mem_init+0x165d>
f01030af:	c7 44 24 0c 2c 98 10 	movl   $0xf010982c,0xc(%esp)
f01030b6:	f0 
f01030b7:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01030be:	f0 
f01030bf:	c7 44 24 04 5f 05 00 	movl   $0x55f,0x4(%esp)
f01030c6:	00 
f01030c7:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01030ce:	e8 ca cf ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f01030d3:	89 f2                	mov    %esi,%edx
f01030d5:	89 f8                	mov    %edi,%eax
f01030d7:	e8 92 dd ff ff       	call   f0100e6e <check_va2pa>
f01030dc:	85 c0                	test   %eax,%eax
f01030de:	74 24                	je     f0103104 <mem_init+0x168e>
f01030e0:	c7 44 24 0c 5c 98 10 	movl   $0xf010985c,0xc(%esp)
f01030e7:	f0 
f01030e8:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01030ef:	f0 
f01030f0:	c7 44 24 04 60 05 00 	movl   $0x560,0x4(%esp)
f01030f7:	00 
f01030f8:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01030ff:	e8 99 cf ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0103104:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f010310a:	89 f8                	mov    %edi,%eax
f010310c:	e8 5d dd ff ff       	call   f0100e6e <check_va2pa>
f0103111:	83 f8 ff             	cmp    $0xffffffff,%eax
f0103114:	74 24                	je     f010313a <mem_init+0x16c4>
f0103116:	c7 44 24 0c 80 98 10 	movl   $0xf0109880,0xc(%esp)
f010311d:	f0 
f010311e:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103125:	f0 
f0103126:	c7 44 24 04 61 05 00 	movl   $0x561,0x4(%esp)
f010312d:	00 
f010312e:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103135:	e8 63 cf ff ff       	call   f010009d <_panic>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f010313a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0103141:	00 
f0103142:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103146:	89 3c 24             	mov    %edi,(%esp)
f0103149:	e8 bd e3 ff ff       	call   f010150b <pgdir_walk>
f010314e:	f6 00 1a             	testb  $0x1a,(%eax)
f0103151:	75 24                	jne    f0103177 <mem_init+0x1701>
f0103153:	c7 44 24 0c ac 98 10 	movl   $0xf01098ac,0xc(%esp)
f010315a:	f0 
f010315b:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103162:	f0 
f0103163:	c7 44 24 04 63 05 00 	movl   $0x563,0x4(%esp)
f010316a:	00 
f010316b:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103172:	e8 26 cf ff ff       	call   f010009d <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0103177:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010317e:	00 
f010317f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103183:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0103188:	89 04 24             	mov    %eax,(%esp)
f010318b:	e8 7b e3 ff ff       	call   f010150b <pgdir_walk>
f0103190:	f6 00 04             	testb  $0x4,(%eax)
f0103193:	74 24                	je     f01031b9 <mem_init+0x1743>
f0103195:	c7 44 24 0c f0 98 10 	movl   $0xf01098f0,0xc(%esp)
f010319c:	f0 
f010319d:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01031a4:	f0 
f01031a5:	c7 44 24 04 64 05 00 	movl   $0x564,0x4(%esp)
f01031ac:	00 
f01031ad:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01031b4:	e8 e4 ce ff ff       	call   f010009d <_panic>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f01031b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01031c0:	00 
f01031c1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01031c5:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f01031ca:	89 04 24             	mov    %eax,(%esp)
f01031cd:	e8 39 e3 ff ff       	call   f010150b <pgdir_walk>
f01031d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f01031d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01031df:	00 
f01031e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01031e3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01031e7:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f01031ec:	89 04 24             	mov    %eax,(%esp)
f01031ef:	e8 17 e3 ff ff       	call   f010150b <pgdir_walk>
f01031f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f01031fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0103201:	00 
f0103202:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103206:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f010320b:	89 04 24             	mov    %eax,(%esp)
f010320e:	e8 f8 e2 ff ff       	call   f010150b <pgdir_walk>
f0103213:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0103219:	c7 04 24 df 90 10 f0 	movl   $0xf01090df,(%esp)
f0103220:	e8 02 16 00 00       	call   f0104827 <cprintf>
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:

	boot_map_region(kern_pgdir, UPAGES, ROUNDUP(sizeof(struct PageInfo)*npages, PGSIZE) , PADDR(pages) , PTE_P | PTE_U);
f0103225:	a1 a4 3e 2c f0       	mov    0xf02c3ea4,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010322a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010322f:	77 20                	ja     f0103251 <mem_init+0x17db>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103231:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103235:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f010323c:	f0 
f010323d:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
f0103244:	00 
f0103245:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010324c:	e8 4c ce ff ff       	call   f010009d <_panic>
f0103251:	8b 15 9c 3e 2c f0    	mov    0xf02c3e9c,%edx
f0103257:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f010325e:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0103264:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f010326b:	00 
	return (physaddr_t)kva - KERNBASE;
f010326c:	05 00 00 00 10       	add    $0x10000000,%eax
f0103271:	89 04 24             	mov    %eax,(%esp)
f0103274:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0103279:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f010327e:	e8 27 e3 ff ff       	call   f01015aa <boot_map_region>
	// (ie. perm = PTE_U | PTE_P).
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
	boot_map_region(kern_pgdir, UENVS, ROUNDUP(sizeof(struct Env)*NENV, PGSIZE) , PADDR(envs) , PTE_P | PTE_U);
f0103283:	a1 48 32 2c f0       	mov    0xf02c3248,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103288:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010328d:	77 20                	ja     f01032af <mem_init+0x1839>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010328f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103293:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f010329a:	f0 
f010329b:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
f01032a2:	00 
f01032a3:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01032aa:	e8 ee cd ff ff       	call   f010009d <_panic>
f01032af:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f01032b6:	00 
	return (physaddr_t)kva - KERNBASE;
f01032b7:	05 00 00 00 10       	add    $0x10000000,%eax
f01032bc:	89 04 24             	mov    %eax,(%esp)
f01032bf:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f01032c4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01032c9:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f01032ce:	e8 d7 e2 ff ff       	call   f01015aa <boot_map_region>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01032d3:	b8 00 d0 11 f0       	mov    $0xf011d000,%eax
f01032d8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01032dd:	77 20                	ja     f01032ff <mem_init+0x1889>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01032df:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01032e3:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f01032ea:	f0 
f01032eb:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
f01032f2:	00 
f01032f3:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01032fa:	e8 9e cd ff ff       	call   f010009d <_panic>
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:

	boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE , PADDR(bootstack) , PTE_P | PTE_W);
f01032ff:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0103306:	00 
f0103307:	c7 04 24 00 d0 11 00 	movl   $0x11d000,(%esp)
f010330e:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0103313:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0103318:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f010331d:	e8 88 e2 ff ff       	call   f01015aa <boot_map_region>
f0103322:	bf 00 50 30 f0       	mov    $0xf0305000,%edi
f0103327:	bb 00 50 2c f0       	mov    $0xf02c5000,%ebx
f010332c:	be 00 80 ff ef       	mov    $0xefff8000,%esi
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103331:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0103337:	77 20                	ja     f0103359 <mem_init+0x18e3>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103339:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010333d:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0103344:	f0 
f0103345:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
f010334c:	00 
f010334d:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103354:	e8 44 cd ff ff       	call   f010009d <_panic>
	uintptr_t kstacktop_i = KSTACKTOP;
	for(i=0;i<NCPU;i++)
	{
		//try printing address of kstacktop for checking pointer arithmatic
		kstacktop_i = (uintptr_t)((char *)kstacktop_i - KSTKSIZE);
		boot_map_region(kern_pgdir, kstacktop_i, KSTKSIZE , PADDR(percpu_kstacks[i]) , PTE_P | PTE_W);
f0103359:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0103360:	00 
f0103361:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0103367:	89 04 24             	mov    %eax,(%esp)
f010336a:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010336f:	89 f2                	mov    %esi,%edx
f0103371:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0103376:	e8 2f e2 ff ff       	call   f01015aa <boot_map_region>
f010337b:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f0103381:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	//
	// LAB 4: Your code here:

	int i=0;
	uintptr_t kstacktop_i = KSTACKTOP;
	for(i=0;i<NCPU;i++)
f0103387:	39 fb                	cmp    %edi,%ebx
f0103389:	75 a6                	jne    f0103331 <mem_init+0x18bb>
	// Your code goes here:

	// Initialize the SMP-related parts of the memory map
	mem_init_mp();

	boot_map_region(kern_pgdir, KERNBASE, ~0x0 - KERNBASE, 0, PTE_P | PTE_W );
f010338b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0103392:	00 
f0103393:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010339a:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f010339f:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01033a4:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f01033a9:	e8 fc e1 ff ff       	call   f01015aa <boot_map_region>
check_kern_pgdir(void)
{
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f01033ae:	8b 3d a0 3e 2c f0    	mov    0xf02c3ea0,%edi

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01033b4:	a1 9c 3e 2c f0       	mov    0xf02c3e9c,%eax
f01033b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01033bc:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01033c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01033c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01033cb:	8b 35 a4 3e 2c f0    	mov    0xf02c3ea4,%esi
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01033d1:	89 75 cc             	mov    %esi,-0x34(%ebp)
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
	return (physaddr_t)kva - KERNBASE;
f01033d4:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01033da:	89 45 c8             	mov    %eax,-0x38(%ebp)

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f01033dd:	bb 00 00 00 00       	mov    $0x0,%ebx
f01033e2:	eb 6a                	jmp    f010344e <mem_init+0x19d8>
f01033e4:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01033ea:	89 f8                	mov    %edi,%eax
f01033ec:	e8 7d da ff ff       	call   f0100e6e <check_va2pa>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01033f1:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f01033f8:	77 20                	ja     f010341a <mem_init+0x19a4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
f01033fe:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0103405:	f0 
f0103406:	c7 44 24 04 77 04 00 	movl   $0x477,0x4(%esp)
f010340d:	00 
f010340e:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103415:	e8 83 cc ff ff       	call   f010009d <_panic>
f010341a:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010341d:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f0103420:	39 d0                	cmp    %edx,%eax
f0103422:	74 24                	je     f0103448 <mem_init+0x19d2>
f0103424:	c7 44 24 0c 24 99 10 	movl   $0xf0109924,0xc(%esp)
f010342b:	f0 
f010342c:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103433:	f0 
f0103434:	c7 44 24 04 77 04 00 	movl   $0x477,0x4(%esp)
f010343b:	00 
f010343c:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103443:	e8 55 cc ff ff       	call   f010009d <_panic>

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0103448:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010344e:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0103451:	77 91                	ja     f01033e4 <mem_init+0x196e>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0103453:	8b 1d 48 32 2c f0    	mov    0xf02c3248,%ebx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103459:	89 de                	mov    %ebx,%esi
f010345b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0103460:	89 f8                	mov    %edi,%eax
f0103462:	e8 07 da ff ff       	call   f0100e6e <check_va2pa>
f0103467:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f010346d:	77 20                	ja     f010348f <mem_init+0x1a19>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010346f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0103473:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f010347a:	f0 
f010347b:	c7 44 24 04 7c 04 00 	movl   $0x47c,0x4(%esp)
f0103482:	00 
f0103483:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010348a:	e8 0e cc ff ff       	call   f010009d <_panic>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010348f:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0103494:	81 c6 00 00 40 21    	add    $0x21400000,%esi
f010349a:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f010349d:	39 d0                	cmp    %edx,%eax
f010349f:	74 24                	je     f01034c5 <mem_init+0x1a4f>
f01034a1:	c7 44 24 0c 58 99 10 	movl   $0xf0109958,0xc(%esp)
f01034a8:	f0 
f01034a9:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01034b0:	f0 
f01034b1:	c7 44 24 04 7c 04 00 	movl   $0x47c,0x4(%esp)
f01034b8:	00 
f01034b9:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01034c0:	e8 d8 cb ff ff       	call   f010009d <_panic>
f01034c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f01034cb:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f01034d1:	0f 85 de 05 00 00    	jne    f0103ab5 <mem_init+0x203f>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01034d7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01034da:	c1 e6 0c             	shl    $0xc,%esi
f01034dd:	bb 00 00 00 00       	mov    $0x0,%ebx
f01034e2:	eb 3b                	jmp    f010351f <mem_init+0x1aa9>
f01034e4:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f01034ea:	89 f8                	mov    %edi,%eax
f01034ec:	e8 7d d9 ff ff       	call   f0100e6e <check_va2pa>
f01034f1:	39 c3                	cmp    %eax,%ebx
f01034f3:	74 24                	je     f0103519 <mem_init+0x1aa3>
f01034f5:	c7 44 24 0c 8c 99 10 	movl   $0xf010998c,0xc(%esp)
f01034fc:	f0 
f01034fd:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103504:	f0 
f0103505:	c7 44 24 04 80 04 00 	movl   $0x480,0x4(%esp)
f010350c:	00 
f010350d:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103514:	e8 84 cb ff ff       	call   f010009d <_panic>
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0103519:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010351f:	39 f3                	cmp    %esi,%ebx
f0103521:	72 c1                	jb     f01034e4 <mem_init+0x1a6e>
f0103523:	c7 45 d0 00 50 2c f0 	movl   $0xf02c5000,-0x30(%ebp)
f010352a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0103531:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0103536:	b8 00 50 2c f0       	mov    $0xf02c5000,%eax
f010353b:	05 00 80 00 20       	add    $0x20008000,%eax
f0103540:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0103543:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0103549:	89 45 cc             	mov    %eax,-0x34(%ebp)
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f010354c:	89 f2                	mov    %esi,%edx
f010354e:	89 f8                	mov    %edi,%eax
f0103550:	e8 19 d9 ff ff       	call   f0100e6e <check_va2pa>
f0103555:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0103558:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f010355e:	77 20                	ja     f0103580 <mem_init+0x1b0a>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103560:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0103564:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f010356b:	f0 
f010356c:	c7 44 24 04 88 04 00 	movl   $0x488,0x4(%esp)
f0103573:	00 
f0103574:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010357b:	e8 1d cb ff ff       	call   f010009d <_panic>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103580:	89 f3                	mov    %esi,%ebx
f0103582:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0103585:	03 4d d4             	add    -0x2c(%ebp),%ecx
f0103588:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f010358b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010358e:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f0103591:	39 c2                	cmp    %eax,%edx
f0103593:	74 24                	je     f01035b9 <mem_init+0x1b43>
f0103595:	c7 44 24 0c b4 99 10 	movl   $0xf01099b4,0xc(%esp)
f010359c:	f0 
f010359d:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01035a4:	f0 
f01035a5:	c7 44 24 04 88 04 00 	movl   $0x488,0x4(%esp)
f01035ac:	00 
f01035ad:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01035b4:	e8 e4 ca ff ff       	call   f010009d <_panic>
f01035b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f01035bf:	3b 5d cc             	cmp    -0x34(%ebp),%ebx
f01035c2:	0f 85 de 04 00 00    	jne    f0103aa6 <mem_init+0x2030>
f01035c8:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
f01035ce:	89 da                	mov    %ebx,%edx
f01035d0:	89 f8                	mov    %edi,%eax
f01035d2:	e8 97 d8 ff ff       	call   f0100e6e <check_va2pa>
f01035d7:	83 f8 ff             	cmp    $0xffffffff,%eax
f01035da:	74 24                	je     f0103600 <mem_init+0x1b8a>
f01035dc:	c7 44 24 0c fc 99 10 	movl   $0xf01099fc,0xc(%esp)
f01035e3:	f0 
f01035e4:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01035eb:	f0 
f01035ec:	c7 44 24 04 8a 04 00 	movl   $0x48a,0x4(%esp)
f01035f3:	00 
f01035f4:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01035fb:	e8 9d ca ff ff       	call   f010009d <_panic>
f0103600:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0103606:	39 de                	cmp    %ebx,%esi
f0103608:	75 c4                	jne    f01035ce <mem_init+0x1b58>
f010360a:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0103610:	81 45 d4 00 80 01 00 	addl   $0x18000,-0x2c(%ebp)
f0103617:	81 45 d0 00 80 00 00 	addl   $0x8000,-0x30(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
f010361e:	81 fe 00 80 f7 ef    	cmp    $0xeff78000,%esi
f0103624:	0f 85 19 ff ff ff    	jne    f0103543 <mem_init+0x1acd>
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

/*	for (i = 0; i < KSTKSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);*/
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f010362a:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f010362f:	89 f8                	mov    %edi,%eax
f0103631:	e8 38 d8 ff ff       	call   f0100e6e <check_va2pa>
f0103636:	83 f8 ff             	cmp    $0xffffffff,%eax
f0103639:	75 0a                	jne    f0103645 <mem_init+0x1bcf>
f010363b:	b8 00 00 00 00       	mov    $0x0,%eax
f0103640:	e9 e6 00 00 00       	jmp    f010372b <mem_init+0x1cb5>
f0103645:	c7 44 24 0c 20 9a 10 	movl   $0xf0109a20,0xc(%esp)
f010364c:	f0 
f010364d:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103654:	f0 
f0103655:	c7 44 24 04 8f 04 00 	movl   $0x48f,0x4(%esp)
f010365c:	00 
f010365d:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103664:	e8 34 ca ff ff       	call   f010009d <_panic>


	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f0103669:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f010366f:	83 fa 04             	cmp    $0x4,%edx
f0103672:	77 2e                	ja     f01036a2 <mem_init+0x1c2c>
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
		case PDX(MMIOBASE):
			assert(pgdir[i] & PTE_P);
f0103674:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0103678:	0f 85 aa 00 00 00    	jne    f0103728 <mem_init+0x1cb2>
f010367e:	c7 44 24 0c f8 90 10 	movl   $0xf01090f8,0xc(%esp)
f0103685:	f0 
f0103686:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010368d:	f0 
f010368e:	c7 44 24 04 9a 04 00 	movl   $0x49a,0x4(%esp)
f0103695:	00 
f0103696:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010369d:	e8 fb c9 ff ff       	call   f010009d <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f01036a2:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f01036a7:	76 55                	jbe    f01036fe <mem_init+0x1c88>
				assert(pgdir[i] & PTE_P);
f01036a9:	8b 14 87             	mov    (%edi,%eax,4),%edx
f01036ac:	f6 c2 01             	test   $0x1,%dl
f01036af:	75 24                	jne    f01036d5 <mem_init+0x1c5f>
f01036b1:	c7 44 24 0c f8 90 10 	movl   $0xf01090f8,0xc(%esp)
f01036b8:	f0 
f01036b9:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01036c0:	f0 
f01036c1:	c7 44 24 04 9e 04 00 	movl   $0x49e,0x4(%esp)
f01036c8:	00 
f01036c9:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01036d0:	e8 c8 c9 ff ff       	call   f010009d <_panic>
				assert(pgdir[i] & PTE_W);
f01036d5:	f6 c2 02             	test   $0x2,%dl
f01036d8:	75 4e                	jne    f0103728 <mem_init+0x1cb2>
f01036da:	c7 44 24 0c 09 91 10 	movl   $0xf0109109,0xc(%esp)
f01036e1:	f0 
f01036e2:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01036e9:	f0 
f01036ea:	c7 44 24 04 9f 04 00 	movl   $0x49f,0x4(%esp)
f01036f1:	00 
f01036f2:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01036f9:	e8 9f c9 ff ff       	call   f010009d <_panic>
			} else
				assert(pgdir[i] == 0);
f01036fe:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0103702:	74 24                	je     f0103728 <mem_init+0x1cb2>
f0103704:	c7 44 24 0c 1a 91 10 	movl   $0xf010911a,0xc(%esp)
f010370b:	f0 
f010370c:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103713:	f0 
f0103714:	c7 44 24 04 a1 04 00 	movl   $0x4a1,0x4(%esp)
f010371b:	00 
f010371c:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103723:	e8 75 c9 ff ff       	call   f010009d <_panic>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);*/
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);


	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f0103728:	83 c0 01             	add    $0x1,%eax
f010372b:	3d 00 04 00 00       	cmp    $0x400,%eax
f0103730:	0f 85 33 ff ff ff    	jne    f0103669 <mem_init+0x1bf3>
			} else
				assert(pgdir[i] == 0);
			break;
		}
	}
	cprintf("check_kern_pgdir() succeeded!\n");
f0103736:	c7 04 24 50 9a 10 f0 	movl   $0xf0109a50,(%esp)
f010373d:	e8 e5 10 00 00       	call   f0104827 <cprintf>
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	//cprintf("\nnow kernel virtual address\n");
	//print_kerndir(kern_pgdir);
	lcr3(PADDR(kern_pgdir));
f0103742:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0103747:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010374c:	77 20                	ja     f010376e <mem_init+0x1cf8>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010374e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103752:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0103759:	f0 
f010375a:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
f0103761:	00 
f0103762:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103769:	e8 2f c9 ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f010376e:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103773:	0f 22 d8             	mov    %eax,%cr3
	//print_kerndir((pde_t *)UVPT);
	check_page_free_list(0);
f0103776:	b8 00 00 00 00       	mov    $0x0,%eax
f010377b:	e8 5d d7 ff ff       	call   f0100edd <check_page_free_list>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f0103780:	0f 20 c0             	mov    %cr0,%eax

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
	cr0 &= ~(CR0_TS|CR0_EM);
f0103783:	83 e0 f3             	and    $0xfffffff3,%eax
f0103786:	0d 23 00 05 80       	or     $0x80050023,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f010378b:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f010378e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103795:	e8 a7 dc ff ff       	call   f0101441 <page_alloc>
f010379a:	89 c3                	mov    %eax,%ebx
f010379c:	85 c0                	test   %eax,%eax
f010379e:	75 24                	jne    f01037c4 <mem_init+0x1d4e>
f01037a0:	c7 44 24 0c 04 8f 10 	movl   $0xf0108f04,0xc(%esp)
f01037a7:	f0 
f01037a8:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01037af:	f0 
f01037b0:	c7 44 24 04 79 05 00 	movl   $0x579,0x4(%esp)
f01037b7:	00 
f01037b8:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01037bf:	e8 d9 c8 ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f01037c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01037cb:	e8 71 dc ff ff       	call   f0101441 <page_alloc>
f01037d0:	89 c7                	mov    %eax,%edi
f01037d2:	85 c0                	test   %eax,%eax
f01037d4:	75 24                	jne    f01037fa <mem_init+0x1d84>
f01037d6:	c7 44 24 0c 1a 8f 10 	movl   $0xf0108f1a,0xc(%esp)
f01037dd:	f0 
f01037de:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01037e5:	f0 
f01037e6:	c7 44 24 04 7a 05 00 	movl   $0x57a,0x4(%esp)
f01037ed:	00 
f01037ee:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01037f5:	e8 a3 c8 ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f01037fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103801:	e8 3b dc ff ff       	call   f0101441 <page_alloc>
f0103806:	89 c6                	mov    %eax,%esi
f0103808:	85 c0                	test   %eax,%eax
f010380a:	75 24                	jne    f0103830 <mem_init+0x1dba>
f010380c:	c7 44 24 0c 30 8f 10 	movl   $0xf0108f30,0xc(%esp)
f0103813:	f0 
f0103814:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010381b:	f0 
f010381c:	c7 44 24 04 7b 05 00 	movl   $0x57b,0x4(%esp)
f0103823:	00 
f0103824:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010382b:	e8 6d c8 ff ff       	call   f010009d <_panic>
	page_free(pp0);
f0103830:	89 1c 24             	mov    %ebx,(%esp)
f0103833:	e8 94 dc ff ff       	call   f01014cc <page_free>
	memset(page2kva(pp1), 1, PGSIZE);
f0103838:	89 f8                	mov    %edi,%eax
f010383a:	e8 ea d5 ff ff       	call   f0100e29 <page2kva>
f010383f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103846:	00 
f0103847:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f010384e:	00 
f010384f:	89 04 24             	mov    %eax,(%esp)
f0103852:	e8 50 35 00 00       	call   f0106da7 <memset>
	memset(page2kva(pp2), 2, PGSIZE);
f0103857:	89 f0                	mov    %esi,%eax
f0103859:	e8 cb d5 ff ff       	call   f0100e29 <page2kva>
f010385e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103865:	00 
f0103866:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f010386d:	00 
f010386e:	89 04 24             	mov    %eax,(%esp)
f0103871:	e8 31 35 00 00       	call   f0106da7 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0103876:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010387d:	00 
f010387e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103885:	00 
f0103886:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010388a:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f010388f:	89 04 24             	mov    %eax,(%esp)
f0103892:	e8 91 e0 ff ff       	call   f0101928 <page_insert>
	assert(pp1->pp_ref == 1);
f0103897:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f010389c:	74 24                	je     f01038c2 <mem_init+0x1e4c>
f010389e:	c7 44 24 0c 01 90 10 	movl   $0xf0109001,0xc(%esp)
f01038a5:	f0 
f01038a6:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01038ad:	f0 
f01038ae:	c7 44 24 04 80 05 00 	movl   $0x580,0x4(%esp)
f01038b5:	00 
f01038b6:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01038bd:	e8 db c7 ff ff       	call   f010009d <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01038c2:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f01038c9:	01 01 01 
f01038cc:	74 24                	je     f01038f2 <mem_init+0x1e7c>
f01038ce:	c7 44 24 0c 70 9a 10 	movl   $0xf0109a70,0xc(%esp)
f01038d5:	f0 
f01038d6:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01038dd:	f0 
f01038de:	c7 44 24 04 81 05 00 	movl   $0x581,0x4(%esp)
f01038e5:	00 
f01038e6:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01038ed:	e8 ab c7 ff ff       	call   f010009d <_panic>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f01038f2:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01038f9:	00 
f01038fa:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103901:	00 
f0103902:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103906:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f010390b:	89 04 24             	mov    %eax,(%esp)
f010390e:	e8 15 e0 ff ff       	call   f0101928 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103913:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f010391a:	02 02 02 
f010391d:	74 24                	je     f0103943 <mem_init+0x1ecd>
f010391f:	c7 44 24 0c 94 9a 10 	movl   $0xf0109a94,0xc(%esp)
f0103926:	f0 
f0103927:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f010392e:	f0 
f010392f:	c7 44 24 04 83 05 00 	movl   $0x583,0x4(%esp)
f0103936:	00 
f0103937:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f010393e:	e8 5a c7 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f0103943:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0103948:	74 24                	je     f010396e <mem_init+0x1ef8>
f010394a:	c7 44 24 0c 23 90 10 	movl   $0xf0109023,0xc(%esp)
f0103951:	f0 
f0103952:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103959:	f0 
f010395a:	c7 44 24 04 84 05 00 	movl   $0x584,0x4(%esp)
f0103961:	00 
f0103962:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103969:	e8 2f c7 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 0);
f010396e:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103973:	74 24                	je     f0103999 <mem_init+0x1f23>
f0103975:	c7 44 24 0c 8d 90 10 	movl   $0xf010908d,0xc(%esp)
f010397c:	f0 
f010397d:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103984:	f0 
f0103985:	c7 44 24 04 85 05 00 	movl   $0x585,0x4(%esp)
f010398c:	00 
f010398d:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103994:	e8 04 c7 ff ff       	call   f010009d <_panic>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0103999:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f01039a0:	03 03 03 
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01039a3:	89 f0                	mov    %esi,%eax
f01039a5:	e8 7f d4 ff ff       	call   f0100e29 <page2kva>
f01039aa:	81 38 03 03 03 03    	cmpl   $0x3030303,(%eax)
f01039b0:	74 24                	je     f01039d6 <mem_init+0x1f60>
f01039b2:	c7 44 24 0c b8 9a 10 	movl   $0xf0109ab8,0xc(%esp)
f01039b9:	f0 
f01039ba:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01039c1:	f0 
f01039c2:	c7 44 24 04 87 05 00 	movl   $0x587,0x4(%esp)
f01039c9:	00 
f01039ca:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f01039d1:	e8 c7 c6 ff ff       	call   f010009d <_panic>
	page_remove(kern_pgdir, (void*) PGSIZE);
f01039d6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01039dd:	00 
f01039de:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f01039e3:	89 04 24             	mov    %eax,(%esp)
f01039e6:	e8 e2 de ff ff       	call   f01018cd <page_remove>
	assert(pp2->pp_ref == 0);
f01039eb:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01039f0:	74 24                	je     f0103a16 <mem_init+0x1fa0>
f01039f2:	c7 44 24 0c 5b 90 10 	movl   $0xf010905b,0xc(%esp)
f01039f9:	f0 
f01039fa:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103a01:	f0 
f0103a02:	c7 44 24 04 89 05 00 	movl   $0x589,0x4(%esp)
f0103a09:	00 
f0103a0a:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103a11:	e8 87 c6 ff ff       	call   f010009d <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103a16:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0103a1b:	8b 08                	mov    (%eax),%ecx
f0103a1d:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103a23:	89 da                	mov    %ebx,%edx
f0103a25:	2b 15 a4 3e 2c f0    	sub    0xf02c3ea4,%edx
f0103a2b:	c1 fa 03             	sar    $0x3,%edx
f0103a2e:	c1 e2 0c             	shl    $0xc,%edx
f0103a31:	39 d1                	cmp    %edx,%ecx
f0103a33:	74 24                	je     f0103a59 <mem_init+0x1fe3>
f0103a35:	c7 44 24 0c 10 94 10 	movl   $0xf0109410,0xc(%esp)
f0103a3c:	f0 
f0103a3d:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103a44:	f0 
f0103a45:	c7 44 24 04 8c 05 00 	movl   $0x58c,0x4(%esp)
f0103a4c:	00 
f0103a4d:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103a54:	e8 44 c6 ff ff       	call   f010009d <_panic>
	kern_pgdir[0] = 0;
f0103a59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0103a5f:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103a64:	74 24                	je     f0103a8a <mem_init+0x2014>
f0103a66:	c7 44 24 0c 12 90 10 	movl   $0xf0109012,0xc(%esp)
f0103a6d:	f0 
f0103a6e:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0103a75:	f0 
f0103a76:	c7 44 24 04 8e 05 00 	movl   $0x58e,0x4(%esp)
f0103a7d:	00 
f0103a7e:	c7 04 24 e8 8d 10 f0 	movl   $0xf0108de8,(%esp)
f0103a85:	e8 13 c6 ff ff       	call   f010009d <_panic>
	pp0->pp_ref = 0;
f0103a8a:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// free the pages we took
	page_free(pp0);
f0103a90:	89 1c 24             	mov    %ebx,(%esp)
f0103a93:	e8 34 da ff ff       	call   f01014cc <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0103a98:	c7 04 24 e4 9a 10 f0 	movl   $0xf0109ae4,(%esp)
f0103a9f:	e8 83 0d 00 00       	call   f0104827 <cprintf>
f0103aa4:	eb 1f                	jmp    f0103ac5 <mem_init+0x204f>
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0103aa6:	89 da                	mov    %ebx,%edx
f0103aa8:	89 f8                	mov    %edi,%eax
f0103aaa:	e8 bf d3 ff ff       	call   f0100e6e <check_va2pa>
f0103aaf:	90                   	nop
f0103ab0:	e9 d6 fa ff ff       	jmp    f010358b <mem_init+0x1b15>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0103ab5:	89 da                	mov    %ebx,%edx
f0103ab7:	89 f8                	mov    %edi,%eax
f0103ab9:	e8 b0 d3 ff ff       	call   f0100e6e <check_va2pa>
f0103abe:	66 90                	xchg   %ax,%ax
f0103ac0:	e9 d5 f9 ff ff       	jmp    f010349a <mem_init+0x1a24>
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
}
f0103ac5:	83 c4 4c             	add    $0x4c,%esp
f0103ac8:	5b                   	pop    %ebx
f0103ac9:	5e                   	pop    %esi
f0103aca:	5f                   	pop    %edi
f0103acb:	5d                   	pop    %ebp
f0103acc:	c3                   	ret    

f0103acd <nw_mmio_map_region>:
	return (void *)ret_base;
}

void *
nw_mmio_map_region(physaddr_t pa, size_t size)
{
f0103acd:	55                   	push   %ebp
f0103ace:	89 e5                	mov    %esp,%ebp
f0103ad0:	56                   	push   %esi
f0103ad1:	53                   	push   %ebx
f0103ad2:	83 ec 10             	sub    $0x10,%esp
	static uintptr_t base = NW_MMIOBASE;
	uintptr_t ret_base = base;
f0103ad5:	8b 1d 00 73 12 f0    	mov    0xf0127300,%ebx

	boot_map_region(kern_pgdir, base, ROUNDUP(size, PGSIZE) , pa , PTE_P | PTE_W | PTE_PCD | PTE_PWT);
f0103adb:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103ade:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
f0103ae4:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f0103aea:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0103af1:	00 
f0103af2:	8b 45 08             	mov    0x8(%ebp),%eax
f0103af5:	89 04 24             	mov    %eax,(%esp)
f0103af8:	89 f1                	mov    %esi,%ecx
f0103afa:	89 da                	mov    %ebx,%edx
f0103afc:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0103b01:	e8 a4 da ff ff       	call   f01015aa <boot_map_region>
	base = (uintptr_t)((char *)base + ROUNDUP(size, PGSIZE));
f0103b06:	03 35 00 73 12 f0    	add    0xf0127300,%esi
f0103b0c:	89 35 00 73 12 f0    	mov    %esi,0xf0127300
	// Fo now, there is only one address space, so always invalidate.
	tlb_invalidate(kern_pgdir, (void *)base);
f0103b12:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103b16:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
f0103b1b:	89 04 24             	mov    %eax,(%esp)
f0103b1e:	e8 75 dd ff ff       	call   f0101898 <tlb_invalidate>
	return (void *)ret_base;
}
f0103b23:	89 d8                	mov    %ebx,%eax
f0103b25:	83 c4 10             	add    $0x10,%esp
f0103b28:	5b                   	pop    %ebx
f0103b29:	5e                   	pop    %esi
f0103b2a:	5d                   	pop    %ebp
f0103b2b:	c3                   	ret    

f0103b2c <user_mem_check>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f0103b2c:	55                   	push   %ebp
f0103b2d:	89 e5                	mov    %esp,%ebp
f0103b2f:	57                   	push   %edi
f0103b30:	56                   	push   %esi
f0103b31:	53                   	push   %ebx
f0103b32:	83 ec 2c             	sub    $0x2c,%esp
f0103b35:	8b 7d 08             	mov    0x8(%ebp),%edi

	int range=0,i=0;
	pte_t *entry=NULL;
	// LAB 3: Your code here.
	if(!((uintptr_t)va > ULIM))
f0103b38:	81 7d 0c 00 00 80 ef 	cmpl   $0xef800000,0xc(%ebp)
f0103b3f:	0f 87 fe 00 00 00    	ja     f0103c43 <user_mem_check+0x117>
	{
		// when can this condition occur 'len/PGSIZE + 2' pages
		range = (ROUNDUP(((char *)va+len), PGSIZE) - ROUNDDOWN((char *)va, PGSIZE))/ PGSIZE;
f0103b45:	8b 45 10             	mov    0x10(%ebp),%eax
f0103b48:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103b4b:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
f0103b52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103b57:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0103b5d:	29 d0                	sub    %edx,%eax
f0103b5f:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0103b65:	85 c0                	test   %eax,%eax
f0103b67:	0f 48 c2             	cmovs  %edx,%eax
f0103b6a:	c1 f8 0c             	sar    $0xc,%eax
f0103b6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(i=0;i<range;i++)
f0103b70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103b73:	be 00 00 00 00       	mov    $0x0,%esi
											((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE)));
				if((uintptr_t)va > user_mem_check_addr)
					user_mem_check_addr = (uintptr_t)va;
				return -E_FAULT;
			}
			if((((*entry) & (0xFFF)) & (perm | PTE_P)) != (perm | PTE_P))
f0103b78:	8b 45 14             	mov    0x14(%ebp),%eax
f0103b7b:	83 c8 01             	or     $0x1,%eax
f0103b7e:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103b81:	25 ff 0f 00 00       	and    $0xfff,%eax
f0103b86:	89 45 d8             	mov    %eax,-0x28(%ebp)
	// LAB 3: Your code here.
	if(!((uintptr_t)va > ULIM))
	{
		// when can this condition occur 'len/PGSIZE + 2' pages
		range = (ROUNDUP(((char *)va+len), PGSIZE) - ROUNDDOWN((char *)va, PGSIZE))/ PGSIZE;
		for(i=0;i<range;i++)
f0103b89:	e9 a5 00 00 00       	jmp    f0103c33 <user_mem_check+0x107>
		{
			entry = pgdir_walk(env->env_pgdir, (char *)va +(i*PGSIZE), 0);
f0103b8e:	89 5d e0             	mov    %ebx,-0x20(%ebp)
f0103b91:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0103b98:	00 
f0103b99:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103b9d:	8b 47 60             	mov    0x60(%edi),%eax
f0103ba0:	89 04 24             	mov    %eax,(%esp)
f0103ba3:	e8 63 d9 ff ff       	call   f010150b <pgdir_walk>
			if(entry==NULL){
f0103ba8:	85 c0                	test   %eax,%eax
f0103baa:	75 3d                	jne    f0103be9 <user_mem_check+0xbd>
				//cprintf("\nentry==NULL");
				user_mem_check_addr = (i==0) ? ((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE) + 1)): 
f0103bac:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103baf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103bb4:	85 f6                	test   %esi,%esi
f0103bb6:	75 0b                	jne    f0103bc3 <user_mem_check+0x97>
f0103bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103bbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103bc0:	83 c0 01             	add    $0x1,%eax
											((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE)));
				if((uintptr_t)va > user_mem_check_addr)
f0103bc3:	3b 45 0c             	cmp    0xc(%ebp),%eax
f0103bc6:	72 0f                	jb     f0103bd7 <user_mem_check+0xab>
		for(i=0;i<range;i++)
		{
			entry = pgdir_walk(env->env_pgdir, (char *)va +(i*PGSIZE), 0);
			if(entry==NULL){
				//cprintf("\nentry==NULL");
				user_mem_check_addr = (i==0) ? ((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE) + 1)): 
f0103bc8:	a3 3c 32 2c f0       	mov    %eax,0xf02c323c
											((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE)));
				if((uintptr_t)va > user_mem_check_addr)
					user_mem_check_addr = (uintptr_t)va;
				return -E_FAULT;
f0103bcd:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103bd2:	e9 95 00 00 00       	jmp    f0103c6c <user_mem_check+0x140>
			if(entry==NULL){
				//cprintf("\nentry==NULL");
				user_mem_check_addr = (i==0) ? ((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE) + 1)): 
											((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE)));
				if((uintptr_t)va > user_mem_check_addr)
					user_mem_check_addr = (uintptr_t)va;
f0103bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103bda:	a3 3c 32 2c f0       	mov    %eax,0xf02c323c
				return -E_FAULT;
f0103bdf:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103be4:	e9 83 00 00 00       	jmp    f0103c6c <user_mem_check+0x140>
f0103be9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
			}
			if((((*entry) & (0xFFF)) & (perm | PTE_P)) != (perm | PTE_P))
f0103bef:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0103bf2:	23 08                	and    (%eax),%ecx
f0103bf4:	39 4d dc             	cmp    %ecx,-0x24(%ebp)
f0103bf7:	74 37                	je     f0103c30 <user_mem_check+0x104>
			{
				//cprintf("\nrequired permissions:%d entry:%x", (perm | PTE_P), *entry);
				//cprintf("\npermission errors");
				user_mem_check_addr = (i==0) ? ((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE) + 1)): 
f0103bf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103bfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103c01:	85 f6                	test   %esi,%esi
f0103c03:	75 0b                	jne    f0103c10 <user_mem_check+0xe4>
f0103c05:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103c08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103c0d:	83 c0 01             	add    $0x1,%eax
											((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE)));
				
				if((uintptr_t)va > user_mem_check_addr)
f0103c10:	3b 45 0c             	cmp    0xc(%ebp),%eax
f0103c13:	72 0c                	jb     f0103c21 <user_mem_check+0xf5>
			}
			if((((*entry) & (0xFFF)) & (perm | PTE_P)) != (perm | PTE_P))
			{
				//cprintf("\nrequired permissions:%d entry:%x", (perm | PTE_P), *entry);
				//cprintf("\npermission errors");
				user_mem_check_addr = (i==0) ? ((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE) + 1)): 
f0103c15:	a3 3c 32 2c f0       	mov    %eax,0xf02c323c
											((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE)));
				
				if((uintptr_t)va > user_mem_check_addr)
					user_mem_check_addr = (uintptr_t)va;
				return -E_FAULT;
f0103c1a:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103c1f:	eb 4b                	jmp    f0103c6c <user_mem_check+0x140>
				//cprintf("\npermission errors");
				user_mem_check_addr = (i==0) ? ((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE) + 1)): 
											((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE)));
				
				if((uintptr_t)va > user_mem_check_addr)
					user_mem_check_addr = (uintptr_t)va;
f0103c21:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103c24:	a3 3c 32 2c f0       	mov    %eax,0xf02c323c
				return -E_FAULT;
f0103c29:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103c2e:	eb 3c                	jmp    f0103c6c <user_mem_check+0x140>
	// LAB 3: Your code here.
	if(!((uintptr_t)va > ULIM))
	{
		// when can this condition occur 'len/PGSIZE + 2' pages
		range = (ROUNDUP(((char *)va+len), PGSIZE) - ROUNDDOWN((char *)va, PGSIZE))/ PGSIZE;
		for(i=0;i<range;i++)
f0103c30:	83 c6 01             	add    $0x1,%esi
f0103c33:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
f0103c36:	0f 8c 52 ff ff ff    	jl     f0103b8e <user_mem_check+0x62>
		if((uintptr_t)va > user_mem_check_addr)
					user_mem_check_addr = (uintptr_t)va;

		return -E_FAULT;
	}
	return 0;
f0103c3c:	b8 00 00 00 00       	mov    $0x0,%eax
f0103c41:	eb 29                	jmp    f0103c6c <user_mem_check+0x140>
		}
	}
	else
	{
		//cprintf("va>ulim");
		user_mem_check_addr = (i==0) ? ((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE) + 1)): 
f0103c43:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103c46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103c4b:	83 c0 01             	add    $0x1,%eax
											((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE)));
		
		if((uintptr_t)va > user_mem_check_addr)
f0103c4e:	39 45 0c             	cmp    %eax,0xc(%ebp)
f0103c51:	77 0c                	ja     f0103c5f <user_mem_check+0x133>
		}
	}
	else
	{
		//cprintf("va>ulim");
		user_mem_check_addr = (i==0) ? ((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE) + 1)): 
f0103c53:	a3 3c 32 2c f0       	mov    %eax,0xf02c323c
											((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE)));
		
		if((uintptr_t)va > user_mem_check_addr)
					user_mem_check_addr = (uintptr_t)va;

		return -E_FAULT;
f0103c58:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103c5d:	eb 0d                	jmp    f0103c6c <user_mem_check+0x140>
		//cprintf("va>ulim");
		user_mem_check_addr = (i==0) ? ((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE) + 1)): 
											((uintptr_t)((char *)ROUNDDOWN((char *)va +(i*PGSIZE), PGSIZE)));
		
		if((uintptr_t)va > user_mem_check_addr)
					user_mem_check_addr = (uintptr_t)va;
f0103c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103c62:	a3 3c 32 2c f0       	mov    %eax,0xf02c323c

		return -E_FAULT;
f0103c67:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
	}
	return 0;
}
f0103c6c:	83 c4 2c             	add    $0x2c,%esp
f0103c6f:	5b                   	pop    %ebx
f0103c70:	5e                   	pop    %esi
f0103c71:	5f                   	pop    %edi
f0103c72:	5d                   	pop    %ebp
f0103c73:	c3                   	ret    

f0103c74 <user_mem_assert>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f0103c74:	55                   	push   %ebp
f0103c75:	89 e5                	mov    %esp,%ebp
f0103c77:	53                   	push   %ebx
f0103c78:	83 ec 14             	sub    $0x14,%esp
f0103c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103c7e:	8b 45 14             	mov    0x14(%ebp),%eax
f0103c81:	83 c8 04             	or     $0x4,%eax
f0103c84:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103c88:	8b 45 10             	mov    0x10(%ebp),%eax
f0103c8b:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103c92:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103c96:	89 1c 24             	mov    %ebx,(%esp)
f0103c99:	e8 8e fe ff ff       	call   f0103b2c <user_mem_check>
f0103c9e:	85 c0                	test   %eax,%eax
f0103ca0:	79 24                	jns    f0103cc6 <user_mem_assert+0x52>
		cprintf("[%08x] user_mem_check assertion failure for "
f0103ca2:	a1 3c 32 2c f0       	mov    0xf02c323c,%eax
f0103ca7:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103cab:	8b 43 48             	mov    0x48(%ebx),%eax
f0103cae:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103cb2:	c7 04 24 10 9b 10 f0 	movl   $0xf0109b10,(%esp)
f0103cb9:	e8 69 0b 00 00       	call   f0104827 <cprintf>
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f0103cbe:	89 1c 24             	mov    %ebx,(%esp)
f0103cc1:	e8 9f 08 00 00       	call   f0104565 <env_destroy>
	}
}
f0103cc6:	83 c4 14             	add    $0x14,%esp
f0103cc9:	5b                   	pop    %ebx
f0103cca:	5d                   	pop    %ebp
f0103ccb:	c3                   	ret    

f0103ccc <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0103ccc:	55                   	push   %ebp
f0103ccd:	89 e5                	mov    %esp,%ebp
f0103ccf:	57                   	push   %edi
f0103cd0:	56                   	push   %esi
f0103cd1:	53                   	push   %ebx
f0103cd2:	83 ec 2c             	sub    $0x2c,%esp
f0103cd5:	89 c7                	mov    %eax,%edi
		range = PGNUM(len);
	else
		range = PGNUM(len) + 1;*/
	//cprintf("\nva:%d rounddown:%d", (char *)va, ROUNDDOWN((char *)va, PGSIZE));
	//cprintf("\nlen:%d va+len:%d roundup:%d",len, (char *)va+len, ROUNDUP(((char *)va+len),PGSIZE));
	range = (ROUNDUP(((char *)va+len), PGSIZE) - ROUNDDOWN((char *)va, PGSIZE))/ PGSIZE;
f0103cd7:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f0103cde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103ce3:	89 d1                	mov    %edx,%ecx
f0103ce5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0103ceb:	29 c8                	sub    %ecx,%eax
f0103ced:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
f0103cf3:	85 c0                	test   %eax,%eax
f0103cf5:	0f 48 c1             	cmovs  %ecx,%eax
f0103cf8:	c1 f8 0c             	sar    $0xc,%eax
f0103cfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	pde_t *entry;
	for(i=0;i<range;i++)
f0103cfe:	89 d6                	mov    %edx,%esi
f0103d00:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103d05:	eb 50                	jmp    f0103d57 <region_alloc+0x8b>
	{
		/* Allocates a new PageInfo structure which corrresponds to physical page in main memory*/
		pp = page_alloc(!ALLOC_ZERO);
f0103d07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103d0e:	e8 2e d7 ff ff       	call   f0101441 <page_alloc>

		/**/
		result = page_insert(e->env_pgdir, pp,((char *)va +(i*PGSIZE)), PTE_P | PTE_W | PTE_U);	//chk this line if further errors
f0103d13:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f0103d1a:	00 
f0103d1b:	89 74 24 08          	mov    %esi,0x8(%esp)
f0103d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103d23:	8b 47 60             	mov    0x60(%edi),%eax
f0103d26:	89 04 24             	mov    %eax,(%esp)
f0103d29:	e8 fa db ff ff       	call   f0101928 <page_insert>
f0103d2e:	81 c6 00 10 00 00    	add    $0x1000,%esi
		if(result)
f0103d34:	85 c0                	test   %eax,%eax
f0103d36:	74 1c                	je     f0103d54 <region_alloc+0x88>
			panic("cannot allocate a page table for corresponding virtual address");
f0103d38:	c7 44 24 08 48 9b 10 	movl   $0xf0109b48,0x8(%esp)
f0103d3f:	f0 
f0103d40:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
f0103d47:	00 
f0103d48:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f0103d4f:	e8 49 c3 ff ff       	call   f010009d <_panic>
		range = PGNUM(len) + 1;*/
	//cprintf("\nva:%d rounddown:%d", (char *)va, ROUNDDOWN((char *)va, PGSIZE));
	//cprintf("\nlen:%d va+len:%d roundup:%d",len, (char *)va+len, ROUNDUP(((char *)va+len),PGSIZE));
	range = (ROUNDUP(((char *)va+len), PGSIZE) - ROUNDDOWN((char *)va, PGSIZE))/ PGSIZE;
	pde_t *entry;
	for(i=0;i<range;i++)
f0103d54:	83 c3 01             	add    $0x1,%ebx
f0103d57:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0103d5a:	7c ab                	jl     f0103d07 <region_alloc+0x3b>
		result = page_insert(e->env_pgdir, pp,((char *)va +(i*PGSIZE)), PTE_P | PTE_W | PTE_U);	//chk this line if further errors
		if(result)
			panic("cannot allocate a page table for corresponding virtual address");
	}
	
}
f0103d5c:	83 c4 2c             	add    $0x2c,%esp
f0103d5f:	5b                   	pop    %ebx
f0103d60:	5e                   	pop    %esi
f0103d61:	5f                   	pop    %edi
f0103d62:	5d                   	pop    %ebp
f0103d63:	c3                   	ret    

f0103d64 <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f0103d64:	55                   	push   %ebp
f0103d65:	89 e5                	mov    %esp,%ebp
f0103d67:	56                   	push   %esi
f0103d68:	53                   	push   %ebx
f0103d69:	8b 45 08             	mov    0x8(%ebp),%eax
f0103d6c:	8b 55 10             	mov    0x10(%ebp),%edx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0103d6f:	85 c0                	test   %eax,%eax
f0103d71:	75 1a                	jne    f0103d8d <envid2env+0x29>
		*env_store = curenv;
f0103d73:	e8 81 36 00 00       	call   f01073f9 <cpunum>
f0103d78:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d7b:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0103d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103d84:	89 01                	mov    %eax,(%ecx)
		return 0;
f0103d86:	b8 00 00 00 00       	mov    $0x0,%eax
f0103d8b:	eb 70                	jmp    f0103dfd <envid2env+0x99>
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).

	//cprintf("envx-envid:%d",ENVX(envid));
	e = &envs[ENVX(envid)];
f0103d8d:	89 c3                	mov    %eax,%ebx
f0103d8f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103d95:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103d98:	03 1d 48 32 2c f0    	add    0xf02c3248,%ebx
	if (e->env_status == ENV_FREE){
		cprintf("\nenv is free\n");
	}
	else if(e->env_id != envid)
		cprintf("\n envid dont match:%d\n", e->env_id);*/
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103d9e:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103da2:	74 05                	je     f0103da9 <envid2env+0x45>
f0103da4:	39 43 48             	cmp    %eax,0x48(%ebx)
f0103da7:	74 10                	je     f0103db9 <envid2env+0x55>
		/*cprintf("\n loop1\n");
		if(e->env_id != envid)
			cprintf("\n e->env_id != envid\n");*/
		*env_store = 0;
f0103da9:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103dac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103db2:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103db7:	eb 44                	jmp    f0103dfd <envid2env+0x99>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103db9:	84 d2                	test   %dl,%dl
f0103dbb:	74 36                	je     f0103df3 <envid2env+0x8f>
f0103dbd:	e8 37 36 00 00       	call   f01073f9 <cpunum>
f0103dc2:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dc5:	39 98 28 40 2c f0    	cmp    %ebx,-0xfd3bfd8(%eax)
f0103dcb:	74 26                	je     f0103df3 <envid2env+0x8f>
f0103dcd:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103dd0:	e8 24 36 00 00       	call   f01073f9 <cpunum>
f0103dd5:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dd8:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0103dde:	3b 70 48             	cmp    0x48(%eax),%esi
f0103de1:	74 10                	je     f0103df3 <envid2env+0x8f>
		*env_store = 0;
f0103de3:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103de6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103dec:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103df1:	eb 0a                	jmp    f0103dfd <envid2env+0x99>
	}

	*env_store = e;
f0103df3:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103df6:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103dfd:	5b                   	pop    %ebx
f0103dfe:	5e                   	pop    %esi
f0103dff:	5d                   	pop    %ebp
f0103e00:	c3                   	ret    

f0103e01 <env_init_percpu>:
}

// Load GDT and segment descriptors.
void
env_init_percpu(void)
{
f0103e01:	55                   	push   %ebp
f0103e02:	89 e5                	mov    %esp,%ebp
}

static __inline void
lgdt(void *p)
{
	__asm __volatile("lgdt (%0)" : : "r" (p));
f0103e04:	b8 20 73 12 f0       	mov    $0xf0127320,%eax
f0103e09:	0f 01 10             	lgdtl  (%eax)
	lgdt(&gdt_pd);
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
f0103e0c:	b8 23 00 00 00       	mov    $0x23,%eax
f0103e11:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f0103e13:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f0103e15:	b0 10                	mov    $0x10,%al
f0103e17:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f0103e19:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f0103e1b:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));
f0103e1d:	ea 24 3e 10 f0 08 00 	ljmp   $0x8,$0xf0103e24
}

static __inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
f0103e24:	b0 00                	mov    $0x0,%al
f0103e26:	0f 00 d0             	lldt   %ax
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}
f0103e29:	5d                   	pop    %ebp
f0103e2a:	c3                   	ret    

f0103e2b <env_init>:
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
{
f0103e2b:	a1 48 32 2c f0       	mov    0xf02c3248,%eax
f0103e30:	83 c0 7c             	add    $0x7c,%eax
	// LAB 3: Your code here.

	int i;
	for(i=0;i<NENV-1;i++)
	{
		envs[i].env_id = 0;
f0103e33:	ba ff 03 00 00       	mov    $0x3ff,%edx
f0103e38:	c7 40 cc 00 00 00 00 	movl   $0x0,-0x34(%eax)
		envs[i].env_status = ENV_FREE;
f0103e3f:	c7 40 d8 00 00 00 00 	movl   $0x0,-0x28(%eax)
		envs[i].env_runs = 0;
f0103e46:	c7 40 dc 00 00 00 00 	movl   $0x0,-0x24(%eax)
		envs[i].env_link = &envs[i+1];
f0103e4d:	89 40 c8             	mov    %eax,-0x38(%eax)
f0103e50:	83 c0 7c             	add    $0x7c,%eax
{
	// Set up envs array
	// LAB 3: Your code here.

	int i;
	for(i=0;i<NENV-1;i++)
f0103e53:	83 ea 01             	sub    $0x1,%edx
f0103e56:	75 e0                	jne    f0103e38 <env_init+0xd>
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
{
f0103e58:	55                   	push   %ebp
f0103e59:	89 e5                	mov    %esp,%ebp
		envs[i].env_id = 0;
		envs[i].env_status = ENV_FREE;
		envs[i].env_runs = 0;
		envs[i].env_link = &envs[i+1];
	}
	env_free_list = envs;
f0103e5b:	a1 48 32 2c f0       	mov    0xf02c3248,%eax
f0103e60:	a3 4c 32 2c f0       	mov    %eax,0xf02c324c
	envs[NENV-1].env_link = 0;
f0103e65:	c7 80 c8 ef 01 00 00 	movl   $0x0,0x1efc8(%eax)
f0103e6c:	00 00 00 
	envs[NENV-1].env_id = 0;
f0103e6f:	c7 80 cc ef 01 00 00 	movl   $0x0,0x1efcc(%eax)
f0103e76:	00 00 00 

	// Per-CPU part of the initialization
	env_init_percpu();
f0103e79:	e8 83 ff ff ff       	call   f0103e01 <env_init_percpu>
}
f0103e7e:	5d                   	pop    %ebp
f0103e7f:	c3                   	ret    

f0103e80 <env_init_trapframe>:

	return 0;
}

int env_init_trapframe(struct Env *e)
{
f0103e80:	55                   	push   %ebp
f0103e81:	89 e5                	mov    %esp,%ebp
f0103e83:	53                   	push   %ebx
f0103e84:	83 ec 14             	sub    $0x14,%esp
f0103e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103e8a:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0103e91:	00 
f0103e92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103e99:	00 
f0103e9a:	89 1c 24             	mov    %ebx,(%esp)
f0103e9d:	e8 05 2f 00 00       	call   f0106da7 <memset>
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f0103ea2:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103ea8:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103eae:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103eb4:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103ebb:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.

	e->env_tf.tf_eflags |= FL_IF;
f0103ec1:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	return 0;
}
f0103ec8:	b8 00 00 00 00       	mov    $0x0,%eax
f0103ecd:	83 c4 14             	add    $0x14,%esp
f0103ed0:	5b                   	pop    %ebx
f0103ed1:	5d                   	pop    %ebp
f0103ed2:	c3                   	ret    

f0103ed3 <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0103ed3:	55                   	push   %ebp
f0103ed4:	89 e5                	mov    %esp,%ebp
f0103ed6:	53                   	push   %ebx
f0103ed7:	83 ec 14             	sub    $0x14,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
f0103eda:	8b 1d 4c 32 2c f0    	mov    0xf02c324c,%ebx
f0103ee0:	85 db                	test   %ebx,%ebx
f0103ee2:	0f 84 9c 01 00 00    	je     f0104084 <env_alloc+0x1b1>
{
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103ee8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0103eef:	e8 4d d5 ff ff       	call   f0101441 <page_alloc>
f0103ef4:	85 c0                	test   %eax,%eax
f0103ef6:	0f 84 8f 01 00 00    	je     f010408b <env_alloc+0x1b8>
f0103efc:	2b 05 a4 3e 2c f0    	sub    0xf02c3ea4,%eax
f0103f02:	c1 f8 03             	sar    $0x3,%eax
f0103f05:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103f08:	89 c2                	mov    %eax,%edx
f0103f0a:	c1 ea 0c             	shr    $0xc,%edx
f0103f0d:	3b 15 9c 3e 2c f0    	cmp    0xf02c3e9c,%edx
f0103f13:	72 20                	jb     f0103f35 <env_alloc+0x62>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103f15:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103f19:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0103f20:	f0 
f0103f21:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
f0103f28:	00 
f0103f29:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0103f30:	e8 68 c1 ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0103f35:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.
	//page_insert(kern_pgdir, p, page2kva(p), PTE_P | PTE_W);
	e->env_pgdir = (pde_t *)page2kva(p);
f0103f3b:	89 53 60             	mov    %edx,0x60(%ebx)
	//check boundary with UTOP
	memcpy(e->env_pgdir + PDX(UTOP), kern_pgdir+PDX(UTOP), (sizeof(pde_t) * (NPDENTRIES - PDX(UTOP) -1)));
f0103f3e:	c7 44 24 08 10 01 00 	movl   $0x110,0x8(%esp)
f0103f45:	00 
f0103f46:	8b 0d a0 3e 2c f0    	mov    0xf02c3ea0,%ecx
f0103f4c:	8d 91 ec 0e 00 00    	lea    0xeec(%ecx),%edx
f0103f52:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103f56:	2d 14 f1 ff 0f       	sub    $0xffff114,%eax
f0103f5b:	89 04 24             	mov    %eax,(%esp)
f0103f5e:	e8 f9 2e 00 00       	call   f0106e5c <memcpy>
	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	//this means that when we need physical address of any environement 
	//we will just query its at *UVPT(address) i.e UVPT is virtual address for 
	//that environments physical page dir address.
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103f63:	8b 43 60             	mov    0x60(%ebx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103f66:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103f6b:	77 20                	ja     f0103f8d <env_alloc+0xba>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103f6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103f71:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0103f78:	f0 
f0103f79:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
f0103f80:	00 
f0103f81:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f0103f88:	e8 10 c1 ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103f8d:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103f93:	83 ca 05             	or     $0x5,%edx
f0103f96:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103f9c:	8b 43 48             	mov    0x48(%ebx),%eax
f0103f9f:	05 00 10 00 00       	add    $0x1000,%eax

	if (generation <= 0)	// Don't create a negative env_id.
f0103fa4:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103fa9:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103fae:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103fb1:	89 da                	mov    %ebx,%edx
f0103fb3:	2b 15 48 32 2c f0    	sub    0xf02c3248,%edx
f0103fb9:	c1 fa 02             	sar    $0x2,%edx
f0103fbc:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f0103fc2:	09 d0                	or     %edx,%eax
f0103fc4:	89 43 48             	mov    %eax,0x48(%ebx)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0103fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103fca:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103fcd:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103fd4:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103fdb:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103fe2:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0103fe9:	00 
f0103fea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103ff1:	00 
f0103ff2:	89 1c 24             	mov    %ebx,(%esp)
f0103ff5:	e8 ad 2d 00 00       	call   f0106da7 <memset>
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f0103ffa:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0104000:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0104006:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f010400c:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0104013:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.

	e->env_tf.tf_eflags |= FL_IF;
f0104019:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)

	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f0104020:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0104027:	c6 43 68 00          	movb   $0x0,0x68(%ebx)

	// commit the allocation
	env_free_list = e->env_link;
f010402b:	8b 43 44             	mov    0x44(%ebx),%eax
f010402e:	a3 4c 32 2c f0       	mov    %eax,0xf02c324c

	e->env_link = NULL;
f0104033:	c7 43 44 00 00 00 00 	movl   $0x0,0x44(%ebx)
	*newenv_store = e;
f010403a:	8b 45 08             	mov    0x8(%ebp),%eax
f010403d:	89 18                	mov    %ebx,(%eax)

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010403f:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0104042:	e8 b2 33 00 00       	call   f01073f9 <cpunum>
f0104047:	6b c0 74             	imul   $0x74,%eax,%eax
f010404a:	ba 00 00 00 00       	mov    $0x0,%edx
f010404f:	83 b8 28 40 2c f0 00 	cmpl   $0x0,-0xfd3bfd8(%eax)
f0104056:	74 11                	je     f0104069 <env_alloc+0x196>
f0104058:	e8 9c 33 00 00       	call   f01073f9 <cpunum>
f010405d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104060:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0104066:	8b 50 48             	mov    0x48(%eax),%edx
f0104069:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f010406d:	89 54 24 04          	mov    %edx,0x4(%esp)
f0104071:	c7 04 24 bb 9b 10 f0 	movl   $0xf0109bbb,(%esp)
f0104078:	e8 aa 07 00 00       	call   f0104827 <cprintf>
	return 0;
f010407d:	b8 00 00 00 00       	mov    $0x0,%eax
f0104082:	eb 0c                	jmp    f0104090 <env_alloc+0x1bd>
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
		return -E_NO_FREE_ENV;
f0104084:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0104089:	eb 05                	jmp    f0104090 <env_alloc+0x1bd>
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
		return -E_NO_MEM;
f010408b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	e->env_link = NULL;
	*newenv_store = e;

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
}
f0104090:	83 c4 14             	add    $0x14,%esp
f0104093:	5b                   	pop    %ebx
f0104094:	5d                   	pop    %ebp
f0104095:	c3                   	ret    

f0104096 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0104096:	55                   	push   %ebp
f0104097:	89 e5                	mov    %esp,%ebp
f0104099:	57                   	push   %edi
f010409a:	56                   	push   %esi
f010409b:	53                   	push   %ebx
f010409c:	83 ec 3c             	sub    $0x3c,%esp
f010409f:	8b 7d 08             	mov    0x8(%ebp),%edi
	// LAB 3: Your code here.

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.

	struct Env *newEnv = NULL;
f01040a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	// LAB 3: Your code here.
	if(env_alloc(&newEnv, 0))
f01040a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01040b0:	00 
f01040b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01040b4:	89 04 24             	mov    %eax,(%esp)
f01040b7:	e8 17 fe ff ff       	call   f0103ed3 <env_alloc>
f01040bc:	85 c0                	test   %eax,%eax
f01040be:	74 1c                	je     f01040dc <env_create+0x46>
		panic("\nNo memory to allocate new environment\n");
f01040c0:	c7 44 24 08 88 9b 10 	movl   $0xf0109b88,0x8(%esp)
f01040c7:	f0 
f01040c8:	c7 44 24 04 d5 01 00 	movl   $0x1d5,0x4(%esp)
f01040cf:	00 
f01040d0:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f01040d7:	e8 c1 bf ff ff       	call   f010009d <_panic>
	load_icode(newEnv, binary);
f01040dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01040df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	// LAB 3: Your code here.

	struct Elf *newElf;
	struct Proghdr *ph, *eph;
	newElf = (struct Elf *)binary;
	ph = (struct Proghdr *) ((uint8_t *) newElf + newElf->e_phoff);
f01040e2:	89 fb                	mov    %edi,%ebx
f01040e4:	03 5f 1c             	add    0x1c(%edi),%ebx
	eph = ph + newElf->e_phnum;
f01040e7:	0f b7 77 2c          	movzwl 0x2c(%edi),%esi
f01040eb:	c1 e6 05             	shl    $0x5,%esi
f01040ee:	01 de                	add    %ebx,%esi
	lcr3(PADDR(e->env_pgdir));
f01040f0:	8b 40 60             	mov    0x60(%eax),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01040f3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01040f8:	77 20                	ja     f010411a <env_create+0x84>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01040fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01040fe:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0104105:	f0 
f0104106:	c7 44 24 04 ac 01 00 	movl   $0x1ac,0x4(%esp)
f010410d:	00 
f010410e:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f0104115:	e8 83 bf ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f010411a:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f010411f:	0f 22 d8             	mov    %eax,%cr3
f0104122:	eb 4b                	jmp    f010416f <env_create+0xd9>
	for (; ph < eph; ph++)
	{
		if(ph->p_type != ELF_PROG_LOAD)
f0104124:	83 3b 01             	cmpl   $0x1,(%ebx)
f0104127:	75 43                	jne    f010416c <env_create+0xd6>
			continue;
		region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f0104129:	8b 4b 14             	mov    0x14(%ebx),%ecx
f010412c:	8b 53 08             	mov    0x8(%ebx),%edx
f010412f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104132:	e8 95 fb ff ff       	call   f0103ccc <region_alloc>
		memset((void *)ph->p_va, 0, ph->p_memsz);
f0104137:	8b 43 14             	mov    0x14(%ebx),%eax
f010413a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010413e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0104145:	00 
f0104146:	8b 43 08             	mov    0x8(%ebx),%eax
f0104149:	89 04 24             	mov    %eax,(%esp)
f010414c:	e8 56 2c 00 00       	call   f0106da7 <memset>
		memcpy((void *)ph->p_va, (void *)(binary+ph->p_offset), ph->p_filesz);
f0104151:	8b 43 10             	mov    0x10(%ebx),%eax
f0104154:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104158:	89 f8                	mov    %edi,%eax
f010415a:	03 43 04             	add    0x4(%ebx),%eax
f010415d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104161:	8b 43 08             	mov    0x8(%ebx),%eax
f0104164:	89 04 24             	mov    %eax,(%esp)
f0104167:	e8 f0 2c 00 00       	call   f0106e5c <memcpy>
	struct Proghdr *ph, *eph;
	newElf = (struct Elf *)binary;
	ph = (struct Proghdr *) ((uint8_t *) newElf + newElf->e_phoff);
	eph = ph + newElf->e_phnum;
	lcr3(PADDR(e->env_pgdir));
	for (; ph < eph; ph++)
f010416c:	83 c3 20             	add    $0x20,%ebx
f010416f:	39 de                	cmp    %ebx,%esi
f0104171:	77 b1                	ja     f0104124 <env_create+0x8e>
		memset((void *)ph->p_va, 0, ph->p_memsz);
		memcpy((void *)ph->p_va, (void *)(binary+ph->p_offset), ph->p_filesz);
	}

	/*not asure about this*/
	e->env_tf.tf_eip = newElf->e_entry;
f0104173:	8b 47 18             	mov    0x18(%edi),%eax
f0104176:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0104179:	89 47 30             	mov    %eax,0x30(%edi)

	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.

	// LAB 3: Your code here.
	region_alloc(e, (void *)USTACKTOP - PGSIZE, PGSIZE);
f010417c:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0104181:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0104186:	89 f8                	mov    %edi,%eax
f0104188:	e8 3f fb ff ff       	call   f0103ccc <region_alloc>
	lcr3(PADDR(kern_pgdir));
f010418d:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0104192:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104197:	77 20                	ja     f01041b9 <env_create+0x123>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104199:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010419d:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f01041a4:	f0 
f01041a5:	c7 44 24 04 bf 01 00 	movl   $0x1bf,0x4(%esp)
f01041ac:	00 
f01041ad:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f01041b4:	e8 e4 be ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f01041b9:	05 00 00 00 10       	add    $0x10000000,%eax
f01041be:	0f 22 d8             	mov    %eax,%cr3
	struct Env *newEnv = NULL;
	// LAB 3: Your code here.
	if(env_alloc(&newEnv, 0))
		panic("\nNo memory to allocate new environment\n");
	load_icode(newEnv, binary);
	newEnv->env_type = type;
f01041c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01041c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01041c7:	89 48 50             	mov    %ecx,0x50(%eax)
	if(type == ENV_TYPE_FS)
f01041ca:	83 f9 01             	cmp    $0x1,%ecx
f01041cd:	75 07                	jne    f01041d6 <env_create+0x140>
		newEnv->env_tf.tf_eflags |= FL_IOPL_MASK;
f01041cf:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
}
f01041d6:	83 c4 3c             	add    $0x3c,%esp
f01041d9:	5b                   	pop    %ebx
f01041da:	5e                   	pop    %esi
f01041db:	5f                   	pop    %edi
f01041dc:	5d                   	pop    %ebp
f01041dd:	c3                   	ret    

f01041de <env_cleanup>:


void env_cleanup(struct Env *e)
{
f01041de:	55                   	push   %ebp
f01041df:	89 e5                	mov    %esp,%ebp
f01041e1:	57                   	push   %edi
f01041e2:	56                   	push   %esi
f01041e3:	53                   	push   %ebx
f01041e4:	83 ec 2c             	sub    $0x2c,%esp
f01041e7:	8b 75 08             	mov    0x8(%ebp),%esi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f01041ea:	e8 0a 32 00 00       	call   f01073f9 <cpunum>
f01041ef:	6b c0 74             	imul   $0x74,%eax,%eax
f01041f2:	39 b0 28 40 2c f0    	cmp    %esi,-0xfd3bfd8(%eax)
f01041f8:	75 34                	jne    f010422e <env_cleanup+0x50>
		lcr3(PADDR(kern_pgdir));
f01041fa:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01041ff:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104204:	77 20                	ja     f0104226 <env_cleanup+0x48>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104206:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010420a:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0104211:	f0 
f0104212:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
f0104219:	00 
f010421a:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f0104221:	e8 77 be ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f0104226:	05 00 00 00 10       	add    $0x10000000,%eax
f010422b:	0f 22 d8             	mov    %eax,%cr3

	// Note the environment's demise.

	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010422e:	8b 5e 48             	mov    0x48(%esi),%ebx
f0104231:	e8 c3 31 00 00       	call   f01073f9 <cpunum>
f0104236:	6b d0 74             	imul   $0x74,%eax,%edx
f0104239:	b8 00 00 00 00       	mov    $0x0,%eax
f010423e:	83 ba 28 40 2c f0 00 	cmpl   $0x0,-0xfd3bfd8(%edx)
f0104245:	74 11                	je     f0104258 <env_cleanup+0x7a>
f0104247:	e8 ad 31 00 00       	call   f01073f9 <cpunum>
f010424c:	6b c0 74             	imul   $0x74,%eax,%eax
f010424f:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0104255:	8b 40 48             	mov    0x48(%eax),%eax
f0104258:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f010425c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104260:	c7 04 24 d0 9b 10 f0 	movl   $0xf0109bd0,(%esp)
f0104267:	e8 bb 05 00 00       	call   f0104827 <cprintf>

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f010426c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0104273:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0104276:	89 c8                	mov    %ecx,%eax
f0104278:	c1 e0 02             	shl    $0x2,%eax
f010427b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f010427e:	8b 46 60             	mov    0x60(%esi),%eax
f0104281:	8b 3c 88             	mov    (%eax,%ecx,4),%edi
f0104284:	f7 c7 01 00 00 00    	test   $0x1,%edi
f010428a:	0f 84 b7 00 00 00    	je     f0104347 <env_cleanup+0x169>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0104290:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0104296:	89 f8                	mov    %edi,%eax
f0104298:	c1 e8 0c             	shr    $0xc,%eax
f010429b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010429e:	3b 05 9c 3e 2c f0    	cmp    0xf02c3e9c,%eax
f01042a4:	72 20                	jb     f01042c6 <env_cleanup+0xe8>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01042a6:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01042aa:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f01042b1:	f0 
f01042b2:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
f01042b9:	00 
f01042ba:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f01042c1:	e8 d7 bd ff ff       	call   f010009d <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01042c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01042c9:	c1 e0 16             	shl    $0x16,%eax
f01042cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01042cf:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (pt[pteno] & PTE_P)
f01042d4:	f6 84 9f 00 00 00 f0 	testb  $0x1,-0x10000000(%edi,%ebx,4)
f01042db:	01 
f01042dc:	74 17                	je     f01042f5 <env_cleanup+0x117>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01042de:	89 d8                	mov    %ebx,%eax
f01042e0:	c1 e0 0c             	shl    $0xc,%eax
f01042e3:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01042e6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01042ea:	8b 46 60             	mov    0x60(%esi),%eax
f01042ed:	89 04 24             	mov    %eax,(%esp)
f01042f0:	e8 d8 d5 ff ff       	call   f01018cd <page_remove>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01042f5:	83 c3 01             	add    $0x1,%ebx
f01042f8:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f01042fe:	75 d4                	jne    f01042d4 <env_cleanup+0xf6>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0104300:	8b 46 60             	mov    0x60(%esi),%eax
f0104303:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104306:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010430d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0104310:	3b 05 9c 3e 2c f0    	cmp    0xf02c3e9c,%eax
f0104316:	72 1c                	jb     f0104334 <env_cleanup+0x156>
		panic("pa2page called with invalid pa");
f0104318:	c7 44 24 08 0c 92 10 	movl   $0xf010920c,0x8(%esp)
f010431f:	f0 
f0104320:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
f0104327:	00 
f0104328:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f010432f:	e8 69 bd ff ff       	call   f010009d <_panic>
	return &pages[PGNUM(pa)];
f0104334:	a1 a4 3e 2c f0       	mov    0xf02c3ea4,%eax
f0104339:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010433c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
		page_decref(pa2page(pa));
f010433f:	89 04 24             	mov    %eax,(%esp)
f0104342:	e8 a1 d1 ff ff       	call   f01014e8 <page_decref>

	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0104347:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f010434b:	81 7d e0 bb 03 00 00 	cmpl   $0x3bb,-0x20(%ebp)
f0104352:	0f 85 1b ff ff ff    	jne    f0104273 <env_cleanup+0x95>
		// free the page table itself
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

}
f0104358:	83 c4 2c             	add    $0x2c,%esp
f010435b:	5b                   	pop    %ebx
f010435c:	5e                   	pop    %esi
f010435d:	5f                   	pop    %edi
f010435e:	5d                   	pop    %ebp
f010435f:	c3                   	ret    

f0104360 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0104360:	55                   	push   %ebp
f0104361:	89 e5                	mov    %esp,%ebp
f0104363:	57                   	push   %edi
f0104364:	56                   	push   %esi
f0104365:	53                   	push   %ebx
f0104366:	83 ec 2c             	sub    $0x2c,%esp
f0104369:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f010436c:	e8 88 30 00 00       	call   f01073f9 <cpunum>
f0104371:	6b c0 74             	imul   $0x74,%eax,%eax
f0104374:	39 b8 28 40 2c f0    	cmp    %edi,-0xfd3bfd8(%eax)
f010437a:	75 34                	jne    f01043b0 <env_free+0x50>
		lcr3(PADDR(kern_pgdir));
f010437c:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0104381:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104386:	77 20                	ja     f01043a8 <env_free+0x48>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104388:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010438c:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0104393:	f0 
f0104394:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
f010439b:	00 
f010439c:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f01043a3:	e8 f5 bc ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f01043a8:	05 00 00 00 10       	add    $0x10000000,%eax
f01043ad:	0f 22 d8             	mov    %eax,%cr3

	// Note the environment's demise.

	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01043b0:	8b 5f 48             	mov    0x48(%edi),%ebx
f01043b3:	e8 41 30 00 00       	call   f01073f9 <cpunum>
f01043b8:	6b d0 74             	imul   $0x74,%eax,%edx
f01043bb:	b8 00 00 00 00       	mov    $0x0,%eax
f01043c0:	83 ba 28 40 2c f0 00 	cmpl   $0x0,-0xfd3bfd8(%edx)
f01043c7:	74 11                	je     f01043da <env_free+0x7a>
f01043c9:	e8 2b 30 00 00       	call   f01073f9 <cpunum>
f01043ce:	6b c0 74             	imul   $0x74,%eax,%eax
f01043d1:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01043d7:	8b 40 48             	mov    0x48(%eax),%eax
f01043da:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f01043de:	89 44 24 04          	mov    %eax,0x4(%esp)
f01043e2:	c7 04 24 d0 9b 10 f0 	movl   $0xf0109bd0,(%esp)
f01043e9:	e8 39 04 00 00       	call   f0104827 <cprintf>

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f01043ee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01043f5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01043f8:	89 c8                	mov    %ecx,%eax
f01043fa:	c1 e0 02             	shl    $0x2,%eax
f01043fd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0104400:	8b 47 60             	mov    0x60(%edi),%eax
f0104403:	8b 34 88             	mov    (%eax,%ecx,4),%esi
f0104406:	f7 c6 01 00 00 00    	test   $0x1,%esi
f010440c:	0f 84 b7 00 00 00    	je     f01044c9 <env_free+0x169>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0104412:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0104418:	89 f0                	mov    %esi,%eax
f010441a:	c1 e8 0c             	shr    $0xc,%eax
f010441d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104420:	3b 05 9c 3e 2c f0    	cmp    0xf02c3e9c,%eax
f0104426:	72 20                	jb     f0104448 <env_free+0xe8>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0104428:	89 74 24 0c          	mov    %esi,0xc(%esp)
f010442c:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0104433:	f0 
f0104434:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
f010443b:	00 
f010443c:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f0104443:	e8 55 bc ff ff       	call   f010009d <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0104448:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010444b:	c1 e0 16             	shl    $0x16,%eax
f010444e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0104451:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (pt[pteno] & PTE_P)
f0104456:	f6 84 9e 00 00 00 f0 	testb  $0x1,-0x10000000(%esi,%ebx,4)
f010445d:	01 
f010445e:	74 17                	je     f0104477 <env_free+0x117>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0104460:	89 d8                	mov    %ebx,%eax
f0104462:	c1 e0 0c             	shl    $0xc,%eax
f0104465:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0104468:	89 44 24 04          	mov    %eax,0x4(%esp)
f010446c:	8b 47 60             	mov    0x60(%edi),%eax
f010446f:	89 04 24             	mov    %eax,(%esp)
f0104472:	e8 56 d4 ff ff       	call   f01018cd <page_remove>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0104477:	83 c3 01             	add    $0x1,%ebx
f010447a:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0104480:	75 d4                	jne    f0104456 <env_free+0xf6>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0104482:	8b 47 60             	mov    0x60(%edi),%eax
f0104485:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104488:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010448f:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0104492:	3b 05 9c 3e 2c f0    	cmp    0xf02c3e9c,%eax
f0104498:	72 1c                	jb     f01044b6 <env_free+0x156>
		panic("pa2page called with invalid pa");
f010449a:	c7 44 24 08 0c 92 10 	movl   $0xf010920c,0x8(%esp)
f01044a1:	f0 
f01044a2:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
f01044a9:	00 
f01044aa:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f01044b1:	e8 e7 bb ff ff       	call   f010009d <_panic>
	return &pages[PGNUM(pa)];
f01044b6:	a1 a4 3e 2c f0       	mov    0xf02c3ea4,%eax
f01044bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01044be:	8d 04 d0             	lea    (%eax,%edx,8),%eax
		page_decref(pa2page(pa));
f01044c1:	89 04 24             	mov    %eax,(%esp)
f01044c4:	e8 1f d0 ff ff       	call   f01014e8 <page_decref>

	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f01044c9:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f01044cd:	81 7d e0 bb 03 00 00 	cmpl   $0x3bb,-0x20(%ebp)
f01044d4:	0f 85 1b ff ff ff    	jne    f01043f5 <env_free+0x95>
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01044da:	8b 47 60             	mov    0x60(%edi),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01044dd:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01044e2:	77 20                	ja     f0104504 <env_free+0x1a4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01044e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01044e8:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f01044ef:	f0 
f01044f0:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
f01044f7:	00 
f01044f8:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f01044ff:	e8 99 bb ff ff       	call   f010009d <_panic>
	e->env_pgdir = 0;
f0104504:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f010450b:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0104510:	c1 e8 0c             	shr    $0xc,%eax
f0104513:	3b 05 9c 3e 2c f0    	cmp    0xf02c3e9c,%eax
f0104519:	72 1c                	jb     f0104537 <env_free+0x1d7>
		panic("pa2page called with invalid pa");
f010451b:	c7 44 24 08 0c 92 10 	movl   $0xf010920c,0x8(%esp)
f0104522:	f0 
f0104523:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
f010452a:	00 
f010452b:	c7 04 24 f4 8d 10 f0 	movl   $0xf0108df4,(%esp)
f0104532:	e8 66 bb ff ff       	call   f010009d <_panic>
	return &pages[PGNUM(pa)];
f0104537:	8b 15 a4 3e 2c f0    	mov    0xf02c3ea4,%edx
f010453d:	8d 04 c2             	lea    (%edx,%eax,8),%eax
	page_decref(pa2page(pa));
f0104540:	89 04 24             	mov    %eax,(%esp)
f0104543:	e8 a0 cf ff ff       	call   f01014e8 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0104548:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f010454f:	a1 4c 32 2c f0       	mov    0xf02c324c,%eax
f0104554:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0104557:	89 3d 4c 32 2c f0    	mov    %edi,0xf02c324c
}
f010455d:	83 c4 2c             	add    $0x2c,%esp
f0104560:	5b                   	pop    %ebx
f0104561:	5e                   	pop    %esi
f0104562:	5f                   	pop    %edi
f0104563:	5d                   	pop    %ebp
f0104564:	c3                   	ret    

f0104565 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0104565:	55                   	push   %ebp
f0104566:	89 e5                	mov    %esp,%ebp
f0104568:	53                   	push   %ebx
f0104569:	83 ec 14             	sub    $0x14,%esp
f010456c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010456f:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0104573:	75 19                	jne    f010458e <env_destroy+0x29>
f0104575:	e8 7f 2e 00 00       	call   f01073f9 <cpunum>
f010457a:	6b c0 74             	imul   $0x74,%eax,%eax
f010457d:	39 98 28 40 2c f0    	cmp    %ebx,-0xfd3bfd8(%eax)
f0104583:	74 09                	je     f010458e <env_destroy+0x29>
		e->env_status = ENV_DYING;
f0104585:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f010458c:	eb 2f                	jmp    f01045bd <env_destroy+0x58>
	}

	env_free(e);
f010458e:	89 1c 24             	mov    %ebx,(%esp)
f0104591:	e8 ca fd ff ff       	call   f0104360 <env_free>

	if (curenv == e) {
f0104596:	e8 5e 2e 00 00       	call   f01073f9 <cpunum>
f010459b:	6b c0 74             	imul   $0x74,%eax,%eax
f010459e:	39 98 28 40 2c f0    	cmp    %ebx,-0xfd3bfd8(%eax)
f01045a4:	75 17                	jne    f01045bd <env_destroy+0x58>
		curenv = NULL;
f01045a6:	e8 4e 2e 00 00       	call   f01073f9 <cpunum>
f01045ab:	6b c0 74             	imul   $0x74,%eax,%eax
f01045ae:	c7 80 28 40 2c f0 00 	movl   $0x0,-0xfd3bfd8(%eax)
f01045b5:	00 00 00 
		sched_yield();
f01045b8:	e8 11 12 00 00       	call   f01057ce <sched_yield>
	}
}
f01045bd:	83 c4 14             	add    $0x14,%esp
f01045c0:	5b                   	pop    %ebx
f01045c1:	5d                   	pop    %ebp
f01045c2:	c3                   	ret    

f01045c3 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f01045c3:	55                   	push   %ebp
f01045c4:	89 e5                	mov    %esp,%ebp
f01045c6:	53                   	push   %ebx
f01045c7:	83 ec 14             	sub    $0x14,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f01045ca:	e8 2a 2e 00 00       	call   f01073f9 <cpunum>
f01045cf:	6b c0 74             	imul   $0x74,%eax,%eax
f01045d2:	8b 98 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%ebx
f01045d8:	e8 1c 2e 00 00       	call   f01073f9 <cpunum>
f01045dd:	89 43 5c             	mov    %eax,0x5c(%ebx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f01045e0:	c7 04 24 c0 73 12 f0 	movl   $0xf01273c0,(%esp)
f01045e7:	e8 4c 31 00 00       	call   f0107738 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f01045ec:	f3 90                	pause  

	//cprintf("\npoping trapframe:eflags:%x",tf->tf_eflags);
	unlock_kernel();
	__asm __volatile("movl %0,%%esp\n"
f01045ee:	8b 65 08             	mov    0x8(%ebp),%esp
f01045f1:	61                   	popa   
f01045f2:	07                   	pop    %es
f01045f3:	1f                   	pop    %ds
f01045f4:	83 c4 08             	add    $0x8,%esp
f01045f7:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f01045f8:	c7 44 24 08 e6 9b 10 	movl   $0xf0109be6,0x8(%esp)
f01045ff:	f0 
f0104600:	c7 44 24 04 6a 02 00 	movl   $0x26a,0x4(%esp)
f0104607:	00 
f0104608:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f010460f:	e8 89 ba ff ff       	call   f010009d <_panic>

f0104614 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0104614:	55                   	push   %ebp
f0104615:	89 e5                	mov    %esp,%ebp
f0104617:	53                   	push   %ebx
f0104618:	83 ec 14             	sub    $0x14,%esp
f010461b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// LAB 3: Your code here.

	// env_init();
	//panic("env_run not yet implemented");
	//cprintf("\nfound new env\n");
	if(curenv)
f010461e:	e8 d6 2d 00 00       	call   f01073f9 <cpunum>
f0104623:	6b c0 74             	imul   $0x74,%eax,%eax
f0104626:	83 b8 28 40 2c f0 00 	cmpl   $0x0,-0xfd3bfd8(%eax)
f010462d:	74 29                	je     f0104658 <env_run+0x44>
	{
		if(curenv->env_status == ENV_RUNNING)
f010462f:	e8 c5 2d 00 00       	call   f01073f9 <cpunum>
f0104634:	6b c0 74             	imul   $0x74,%eax,%eax
f0104637:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f010463d:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104641:	75 15                	jne    f0104658 <env_run+0x44>
		{
			//cprintf("\n env-%x giving control to env-%x\n", curenv->env_id, e->env_id);
			curenv->env_status = ENV_RUNNABLE;
f0104643:	e8 b1 2d 00 00       	call   f01073f9 <cpunum>
f0104648:	6b c0 74             	imul   $0x74,%eax,%eax
f010464b:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0104651:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
		}
	}
	curenv = e;
f0104658:	e8 9c 2d 00 00       	call   f01073f9 <cpunum>
f010465d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104660:	89 98 28 40 2c f0    	mov    %ebx,-0xfd3bfd8(%eax)
	e->env_status = ENV_RUNNING;
f0104666:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
	e->env_runs++;
f010466d:	83 43 58 01          	addl   $0x1,0x58(%ebx)
	//e->env_tf.tf_eflags |= FL_IF;
	//cprintf("\nenv-run id:%x eip:%x esp:%x\n",e->env_id, e->env_tf.tf_eip, e->env_tf.tf_esp);
	lcr3(PADDR(e->env_pgdir));
f0104671:	8b 43 60             	mov    0x60(%ebx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0104674:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104679:	77 20                	ja     f010469b <env_run+0x87>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010467b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010467f:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0104686:	f0 
f0104687:	c7 44 24 04 99 02 00 	movl   $0x299,0x4(%esp)
f010468e:	00 
f010468f:	c7 04 24 b0 9b 10 f0 	movl   $0xf0109bb0,(%esp)
f0104696:	e8 02 ba ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f010469b:	05 00 00 00 10       	add    $0x10000000,%eax
f01046a0:	0f 22 d8             	mov    %eax,%cr3
	env_pop_tf(&e->env_tf);
f01046a3:	89 1c 24             	mov    %ebx,(%esp)
f01046a6:	e8 18 ff ff ff       	call   f01045c3 <env_pop_tf>

f01046ab <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f01046ab:	55                   	push   %ebp
f01046ac:	89 e5                	mov    %esp,%ebp
f01046ae:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01046b2:	ba 70 00 00 00       	mov    $0x70,%edx
f01046b7:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01046b8:	b2 71                	mov    $0x71,%dl
f01046ba:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01046bb:	0f b6 c0             	movzbl %al,%eax
}
f01046be:	5d                   	pop    %ebp
f01046bf:	c3                   	ret    

f01046c0 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01046c0:	55                   	push   %ebp
f01046c1:	89 e5                	mov    %esp,%ebp
f01046c3:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01046c7:	ba 70 00 00 00       	mov    $0x70,%edx
f01046cc:	ee                   	out    %al,(%dx)
f01046cd:	b2 71                	mov    $0x71,%dl
f01046cf:	8b 45 0c             	mov    0xc(%ebp),%eax
f01046d2:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01046d3:	5d                   	pop    %ebp
f01046d4:	c3                   	ret    

f01046d5 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01046d5:	55                   	push   %ebp
f01046d6:	89 e5                	mov    %esp,%ebp
f01046d8:	56                   	push   %esi
f01046d9:	53                   	push   %ebx
f01046da:	83 ec 10             	sub    $0x10,%esp
f01046dd:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f01046e0:	66 a3 a8 73 12 f0    	mov    %ax,0xf01273a8
	if (!didinit)
f01046e6:	80 3d 50 32 2c f0 00 	cmpb   $0x0,0xf02c3250
f01046ed:	74 4e                	je     f010473d <irq_setmask_8259A+0x68>
f01046ef:	89 c6                	mov    %eax,%esi
f01046f1:	ba 21 00 00 00       	mov    $0x21,%edx
f01046f6:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
f01046f7:	66 c1 e8 08          	shr    $0x8,%ax
f01046fb:	b2 a1                	mov    $0xa1,%dl
f01046fd:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01046fe:	c7 04 24 f2 9b 10 f0 	movl   $0xf0109bf2,(%esp)
f0104705:	e8 1d 01 00 00       	call   f0104827 <cprintf>
	for (i = 0; i < 16; i++)
f010470a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f010470f:	0f b7 f6             	movzwl %si,%esi
f0104712:	f7 d6                	not    %esi
f0104714:	0f a3 de             	bt     %ebx,%esi
f0104717:	73 10                	jae    f0104729 <irq_setmask_8259A+0x54>
			cprintf(" %d", i);
f0104719:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010471d:	c7 04 24 da a1 10 f0 	movl   $0xf010a1da,(%esp)
f0104724:	e8 fe 00 00 00       	call   f0104827 <cprintf>
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f0104729:	83 c3 01             	add    $0x1,%ebx
f010472c:	83 fb 10             	cmp    $0x10,%ebx
f010472f:	75 e3                	jne    f0104714 <irq_setmask_8259A+0x3f>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f0104731:	c7 04 24 16 8a 10 f0 	movl   $0xf0108a16,(%esp)
f0104738:	e8 ea 00 00 00       	call   f0104827 <cprintf>
}
f010473d:	83 c4 10             	add    $0x10,%esp
f0104740:	5b                   	pop    %ebx
f0104741:	5e                   	pop    %esi
f0104742:	5d                   	pop    %ebp
f0104743:	c3                   	ret    

f0104744 <pic_init>:

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	didinit = 1;
f0104744:	c6 05 50 32 2c f0 01 	movb   $0x1,0xf02c3250
f010474b:	ba 21 00 00 00       	mov    $0x21,%edx
f0104750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104755:	ee                   	out    %al,(%dx)
f0104756:	b2 a1                	mov    $0xa1,%dl
f0104758:	ee                   	out    %al,(%dx)
f0104759:	b2 20                	mov    $0x20,%dl
f010475b:	b8 11 00 00 00       	mov    $0x11,%eax
f0104760:	ee                   	out    %al,(%dx)
f0104761:	b2 21                	mov    $0x21,%dl
f0104763:	b8 20 00 00 00       	mov    $0x20,%eax
f0104768:	ee                   	out    %al,(%dx)
f0104769:	b8 04 00 00 00       	mov    $0x4,%eax
f010476e:	ee                   	out    %al,(%dx)
f010476f:	b8 03 00 00 00       	mov    $0x3,%eax
f0104774:	ee                   	out    %al,(%dx)
f0104775:	b2 a0                	mov    $0xa0,%dl
f0104777:	b8 11 00 00 00       	mov    $0x11,%eax
f010477c:	ee                   	out    %al,(%dx)
f010477d:	b2 a1                	mov    $0xa1,%dl
f010477f:	b8 28 00 00 00       	mov    $0x28,%eax
f0104784:	ee                   	out    %al,(%dx)
f0104785:	b8 02 00 00 00       	mov    $0x2,%eax
f010478a:	ee                   	out    %al,(%dx)
f010478b:	b8 01 00 00 00       	mov    $0x1,%eax
f0104790:	ee                   	out    %al,(%dx)
f0104791:	b2 20                	mov    $0x20,%dl
f0104793:	b8 68 00 00 00       	mov    $0x68,%eax
f0104798:	ee                   	out    %al,(%dx)
f0104799:	b8 0a 00 00 00       	mov    $0xa,%eax
f010479e:	ee                   	out    %al,(%dx)
f010479f:	b2 a0                	mov    $0xa0,%dl
f01047a1:	b8 68 00 00 00       	mov    $0x68,%eax
f01047a6:	ee                   	out    %al,(%dx)
f01047a7:	b8 0a 00 00 00       	mov    $0xa,%eax
f01047ac:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f01047ad:	0f b7 05 a8 73 12 f0 	movzwl 0xf01273a8,%eax
f01047b4:	66 83 f8 ff          	cmp    $0xffff,%ax
f01047b8:	74 12                	je     f01047cc <pic_init+0x88>
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f01047ba:	55                   	push   %ebp
f01047bb:	89 e5                	mov    %esp,%ebp
f01047bd:	83 ec 18             	sub    $0x18,%esp

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
		irq_setmask_8259A(irq_mask_8259A);
f01047c0:	0f b7 c0             	movzwl %ax,%eax
f01047c3:	89 04 24             	mov    %eax,(%esp)
f01047c6:	e8 0a ff ff ff       	call   f01046d5 <irq_setmask_8259A>
}
f01047cb:	c9                   	leave  
f01047cc:	f3 c3                	repz ret 

f01047ce <irq_eoi>:
	cprintf("\n");
}

void
irq_eoi(void)
{
f01047ce:	55                   	push   %ebp
f01047cf:	89 e5                	mov    %esp,%ebp
f01047d1:	ba 20 00 00 00       	mov    $0x20,%edx
f01047d6:	b8 20 00 00 00       	mov    $0x20,%eax
f01047db:	ee                   	out    %al,(%dx)
f01047dc:	b2 a0                	mov    $0xa0,%dl
f01047de:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f01047df:	5d                   	pop    %ebp
f01047e0:	c3                   	ret    

f01047e1 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01047e1:	55                   	push   %ebp
f01047e2:	89 e5                	mov    %esp,%ebp
f01047e4:	83 ec 18             	sub    $0x18,%esp
	cputchar(ch);
f01047e7:	8b 45 08             	mov    0x8(%ebp),%eax
f01047ea:	89 04 24             	mov    %eax,(%esp)
f01047ed:	e8 79 c0 ff ff       	call   f010086b <cputchar>
	*cnt++;
}
f01047f2:	c9                   	leave  
f01047f3:	c3                   	ret    

f01047f4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01047f4:	55                   	push   %ebp
f01047f5:	89 e5                	mov    %esp,%ebp
f01047f7:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f01047fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0104801:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104804:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104808:	8b 45 08             	mov    0x8(%ebp),%eax
f010480b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010480f:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104812:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104816:	c7 04 24 e1 47 10 f0 	movl   $0xf01047e1,(%esp)
f010481d:	e8 32 1e 00 00       	call   f0106654 <vprintfmt>
	return cnt;
}
f0104822:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104825:	c9                   	leave  
f0104826:	c3                   	ret    

f0104827 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0104827:	55                   	push   %ebp
f0104828:	89 e5                	mov    %esp,%ebp
f010482a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f010482d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0104830:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104834:	8b 45 08             	mov    0x8(%ebp),%eax
f0104837:	89 04 24             	mov    %eax,(%esp)
f010483a:	e8 b5 ff ff ff       	call   f01047f4 <vcprintf>
	va_end(ap);

	return cnt;
}
f010483f:	c9                   	leave  
f0104840:	c3                   	ret    
f0104841:	66 90                	xchg   %ax,%ax
f0104843:	66 90                	xchg   %ax,%ax
f0104845:	66 90                	xchg   %ax,%ax
f0104847:	66 90                	xchg   %ax,%ax
f0104849:	66 90                	xchg   %ax,%ax
f010484b:	66 90                	xchg   %ax,%ax
f010484d:	66 90                	xchg   %ax,%ax
f010484f:	90                   	nop

f0104850 <trap_init_percpu>:
	trap_init_percpu();
}
// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0104850:	55                   	push   %ebp
f0104851:	89 e5                	mov    %esp,%ebp
f0104853:	57                   	push   %edi
f0104854:	56                   	push   %esi
f0104855:	53                   	push   %ebx
f0104856:	83 ec 0c             	sub    $0xc,%esp


	//cprintf("\n in trapinit per cpu\n");
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - ((thiscpu->cpu_id)*(KSTKSIZE + KSTKGAP));
f0104859:	e8 9b 2b 00 00       	call   f01073f9 <cpunum>
f010485e:	89 c3                	mov    %eax,%ebx
f0104860:	e8 94 2b 00 00       	call   f01073f9 <cpunum>
f0104865:	6b db 74             	imul   $0x74,%ebx,%ebx
f0104868:	6b c0 74             	imul   $0x74,%eax,%eax
f010486b:	0f b6 80 20 40 2c f0 	movzbl -0xfd3bfe0(%eax),%eax
f0104872:	f7 d8                	neg    %eax
f0104874:	c1 e0 10             	shl    $0x10,%eax
f0104877:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010487c:	89 83 30 40 2c f0    	mov    %eax,-0xfd3bfd0(%ebx)
	//doubtful
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0104882:	e8 72 2b 00 00       	call   f01073f9 <cpunum>
f0104887:	6b c0 74             	imul   $0x74,%eax,%eax
f010488a:	66 c7 80 34 40 2c f0 	movw   $0x10,-0xfd3bfcc(%eax)
f0104891:	10 00 

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0104893:	e8 61 2b 00 00       	call   f01073f9 <cpunum>
f0104898:	6b c0 74             	imul   $0x74,%eax,%eax
f010489b:	0f b6 98 20 40 2c f0 	movzbl -0xfd3bfe0(%eax),%ebx
f01048a2:	83 c3 05             	add    $0x5,%ebx
f01048a5:	e8 4f 2b 00 00       	call   f01073f9 <cpunum>
f01048aa:	89 c7                	mov    %eax,%edi
f01048ac:	e8 48 2b 00 00       	call   f01073f9 <cpunum>
f01048b1:	89 c6                	mov    %eax,%esi
f01048b3:	e8 41 2b 00 00       	call   f01073f9 <cpunum>
f01048b8:	66 c7 04 dd 40 73 12 	movw   $0x67,-0xfed8cc0(,%ebx,8)
f01048bf:	f0 67 00 
f01048c2:	6b ff 74             	imul   $0x74,%edi,%edi
f01048c5:	81 c7 2c 40 2c f0    	add    $0xf02c402c,%edi
f01048cb:	66 89 3c dd 42 73 12 	mov    %di,-0xfed8cbe(,%ebx,8)
f01048d2:	f0 
f01048d3:	6b d6 74             	imul   $0x74,%esi,%edx
f01048d6:	81 c2 2c 40 2c f0    	add    $0xf02c402c,%edx
f01048dc:	c1 ea 10             	shr    $0x10,%edx
f01048df:	88 14 dd 44 73 12 f0 	mov    %dl,-0xfed8cbc(,%ebx,8)
f01048e6:	c6 04 dd 45 73 12 f0 	movb   $0x99,-0xfed8cbb(,%ebx,8)
f01048ed:	99 
f01048ee:	c6 04 dd 46 73 12 f0 	movb   $0x40,-0xfed8cba(,%ebx,8)
f01048f5:	40 
f01048f6:	6b c0 74             	imul   $0x74,%eax,%eax
f01048f9:	05 2c 40 2c f0       	add    $0xf02c402c,%eax
f01048fe:	c1 e8 18             	shr    $0x18,%eax
f0104901:	88 04 dd 47 73 12 f0 	mov    %al,-0xfed8cb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id].sd_s = 0;
f0104908:	e8 ec 2a 00 00       	call   f01073f9 <cpunum>
f010490d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104910:	0f b6 80 20 40 2c f0 	movzbl -0xfd3bfe0(%eax),%eax
f0104917:	80 24 c5 6d 73 12 f0 	andb   $0xef,-0xfed8c93(,%eax,8)
f010491e:	ef 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr((GD_TSS0) + ((thiscpu->cpu_id)<<3) );
f010491f:	e8 d5 2a 00 00       	call   f01073f9 <cpunum>
f0104924:	6b c0 74             	imul   $0x74,%eax,%eax
f0104927:	0f b6 80 20 40 2c f0 	movzbl -0xfd3bfe0(%eax),%eax
f010492e:	8d 04 c5 28 00 00 00 	lea    0x28(,%eax,8),%eax
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f0104935:	0f 00 d8             	ltr    %ax
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
f0104938:	b8 aa 73 12 f0       	mov    $0xf01273aa,%eax
f010493d:	0f 01 18             	lidtl  (%eax)
	
	// Load the IDT
	lidt(&idt_pd);
}
f0104940:	83 c4 0c             	add    $0xc,%esp
f0104943:	5b                   	pop    %ebx
f0104944:	5e                   	pop    %esi
f0104945:	5f                   	pop    %edi
f0104946:	5d                   	pop    %ebp
f0104947:	c3                   	ret    

f0104948 <trap_init>:
}


void
trap_init(void)
{
f0104948:	55                   	push   %ebp
f0104949:	89 e5                	mov    %esp,%ebp
f010494b:	83 ec 08             	sub    $0x8,%esp
	pop this trapframe when the environement is again given control after handling interrupt 
	by calling env_run.
	*/
	// Per-CPU setup 
	//cprintf("\nin trapinit\n");
	SETGATE(idt[T_DIVIDE], 0, GD_KT, divide_handler, 0)
f010494e:	b8 ee 55 10 f0       	mov    $0xf01055ee,%eax
f0104953:	66 a3 60 32 2c f0    	mov    %ax,0xf02c3260
f0104959:	66 c7 05 62 32 2c f0 	movw   $0x8,0xf02c3262
f0104960:	08 00 
f0104962:	c6 05 64 32 2c f0 00 	movb   $0x0,0xf02c3264
f0104969:	c6 05 65 32 2c f0 8e 	movb   $0x8e,0xf02c3265
f0104970:	c1 e8 10             	shr    $0x10,%eax
f0104973:	66 a3 66 32 2c f0    	mov    %ax,0xf02c3266
	SETGATE(idt[T_DEBUG], 0, GD_KT, debug_handler, 0)
f0104979:	b8 f8 55 10 f0       	mov    $0xf01055f8,%eax
f010497e:	66 a3 68 32 2c f0    	mov    %ax,0xf02c3268
f0104984:	66 c7 05 6a 32 2c f0 	movw   $0x8,0xf02c326a
f010498b:	08 00 
f010498d:	c6 05 6c 32 2c f0 00 	movb   $0x0,0xf02c326c
f0104994:	c6 05 6d 32 2c f0 8e 	movb   $0x8e,0xf02c326d
f010499b:	c1 e8 10             	shr    $0x10,%eax
f010499e:	66 a3 6e 32 2c f0    	mov    %ax,0xf02c326e
	SETGATE(idt[T_NMI], 0, GD_KT, nmi_handler, 0)
f01049a4:	b8 02 56 10 f0       	mov    $0xf0105602,%eax
f01049a9:	66 a3 70 32 2c f0    	mov    %ax,0xf02c3270
f01049af:	66 c7 05 72 32 2c f0 	movw   $0x8,0xf02c3272
f01049b6:	08 00 
f01049b8:	c6 05 74 32 2c f0 00 	movb   $0x0,0xf02c3274
f01049bf:	c6 05 75 32 2c f0 8e 	movb   $0x8e,0xf02c3275
f01049c6:	c1 e8 10             	shr    $0x10,%eax
f01049c9:	66 a3 76 32 2c f0    	mov    %ax,0xf02c3276
	SETGATE(idt[T_BRKPT], 0, GD_KT, bkpt_handler, 3)
f01049cf:	b8 0c 56 10 f0       	mov    $0xf010560c,%eax
f01049d4:	66 a3 78 32 2c f0    	mov    %ax,0xf02c3278
f01049da:	66 c7 05 7a 32 2c f0 	movw   $0x8,0xf02c327a
f01049e1:	08 00 
f01049e3:	c6 05 7c 32 2c f0 00 	movb   $0x0,0xf02c327c
f01049ea:	c6 05 7d 32 2c f0 ee 	movb   $0xee,0xf02c327d
f01049f1:	c1 e8 10             	shr    $0x10,%eax
f01049f4:	66 a3 7e 32 2c f0    	mov    %ax,0xf02c327e
	SETGATE(idt[T_OFLOW], 0, GD_KT, oflow_handler, 0)
f01049fa:	b8 16 56 10 f0       	mov    $0xf0105616,%eax
f01049ff:	66 a3 80 32 2c f0    	mov    %ax,0xf02c3280
f0104a05:	66 c7 05 82 32 2c f0 	movw   $0x8,0xf02c3282
f0104a0c:	08 00 
f0104a0e:	c6 05 84 32 2c f0 00 	movb   $0x0,0xf02c3284
f0104a15:	c6 05 85 32 2c f0 8e 	movb   $0x8e,0xf02c3285
f0104a1c:	c1 e8 10             	shr    $0x10,%eax
f0104a1f:	66 a3 86 32 2c f0    	mov    %ax,0xf02c3286
	SETGATE(idt[T_BOUND], 0, GD_KT, bound_handler, 0)
f0104a25:	b8 20 56 10 f0       	mov    $0xf0105620,%eax
f0104a2a:	66 a3 88 32 2c f0    	mov    %ax,0xf02c3288
f0104a30:	66 c7 05 8a 32 2c f0 	movw   $0x8,0xf02c328a
f0104a37:	08 00 
f0104a39:	c6 05 8c 32 2c f0 00 	movb   $0x0,0xf02c328c
f0104a40:	c6 05 8d 32 2c f0 8e 	movb   $0x8e,0xf02c328d
f0104a47:	c1 e8 10             	shr    $0x10,%eax
f0104a4a:	66 a3 8e 32 2c f0    	mov    %ax,0xf02c328e
	SETGATE(idt[T_ILLOP], 0, GD_KT, illop_handler, 0)
f0104a50:	b8 2a 56 10 f0       	mov    $0xf010562a,%eax
f0104a55:	66 a3 90 32 2c f0    	mov    %ax,0xf02c3290
f0104a5b:	66 c7 05 92 32 2c f0 	movw   $0x8,0xf02c3292
f0104a62:	08 00 
f0104a64:	c6 05 94 32 2c f0 00 	movb   $0x0,0xf02c3294
f0104a6b:	c6 05 95 32 2c f0 8e 	movb   $0x8e,0xf02c3295
f0104a72:	c1 e8 10             	shr    $0x10,%eax
f0104a75:	66 a3 96 32 2c f0    	mov    %ax,0xf02c3296
	SETGATE(idt[T_DEVICE], 0, GD_KT, device_handler, 0)
f0104a7b:	b8 34 56 10 f0       	mov    $0xf0105634,%eax
f0104a80:	66 a3 98 32 2c f0    	mov    %ax,0xf02c3298
f0104a86:	66 c7 05 9a 32 2c f0 	movw   $0x8,0xf02c329a
f0104a8d:	08 00 
f0104a8f:	c6 05 9c 32 2c f0 00 	movb   $0x0,0xf02c329c
f0104a96:	c6 05 9d 32 2c f0 8e 	movb   $0x8e,0xf02c329d
f0104a9d:	c1 e8 10             	shr    $0x10,%eax
f0104aa0:	66 a3 9e 32 2c f0    	mov    %ax,0xf02c329e
	SETGATE(idt[T_DBLFLT], 0, GD_KT, dblflt_handler, 0)
f0104aa6:	b8 3e 56 10 f0       	mov    $0xf010563e,%eax
f0104aab:	66 a3 a0 32 2c f0    	mov    %ax,0xf02c32a0
f0104ab1:	66 c7 05 a2 32 2c f0 	movw   $0x8,0xf02c32a2
f0104ab8:	08 00 
f0104aba:	c6 05 a4 32 2c f0 00 	movb   $0x0,0xf02c32a4
f0104ac1:	c6 05 a5 32 2c f0 8e 	movb   $0x8e,0xf02c32a5
f0104ac8:	c1 e8 10             	shr    $0x10,%eax
f0104acb:	66 a3 a6 32 2c f0    	mov    %ax,0xf02c32a6
	SETGATE(idt[T_TSS], 0, GD_KT, tss_handler, 0)
f0104ad1:	b8 46 56 10 f0       	mov    $0xf0105646,%eax
f0104ad6:	66 a3 b0 32 2c f0    	mov    %ax,0xf02c32b0
f0104adc:	66 c7 05 b2 32 2c f0 	movw   $0x8,0xf02c32b2
f0104ae3:	08 00 
f0104ae5:	c6 05 b4 32 2c f0 00 	movb   $0x0,0xf02c32b4
f0104aec:	c6 05 b5 32 2c f0 8e 	movb   $0x8e,0xf02c32b5
f0104af3:	c1 e8 10             	shr    $0x10,%eax
f0104af6:	66 a3 b6 32 2c f0    	mov    %ax,0xf02c32b6
	SETGATE(idt[T_SEGNP], 0, GD_KT, segnp_handler, 0)
f0104afc:	b8 4e 56 10 f0       	mov    $0xf010564e,%eax
f0104b01:	66 a3 b8 32 2c f0    	mov    %ax,0xf02c32b8
f0104b07:	66 c7 05 ba 32 2c f0 	movw   $0x8,0xf02c32ba
f0104b0e:	08 00 
f0104b10:	c6 05 bc 32 2c f0 00 	movb   $0x0,0xf02c32bc
f0104b17:	c6 05 bd 32 2c f0 8e 	movb   $0x8e,0xf02c32bd
f0104b1e:	c1 e8 10             	shr    $0x10,%eax
f0104b21:	66 a3 be 32 2c f0    	mov    %ax,0xf02c32be
	SETGATE(idt[T_STACK], 0, GD_KT, stack_handler, 0)
f0104b27:	b8 56 56 10 f0       	mov    $0xf0105656,%eax
f0104b2c:	66 a3 c0 32 2c f0    	mov    %ax,0xf02c32c0
f0104b32:	66 c7 05 c2 32 2c f0 	movw   $0x8,0xf02c32c2
f0104b39:	08 00 
f0104b3b:	c6 05 c4 32 2c f0 00 	movb   $0x0,0xf02c32c4
f0104b42:	c6 05 c5 32 2c f0 8e 	movb   $0x8e,0xf02c32c5
f0104b49:	c1 e8 10             	shr    $0x10,%eax
f0104b4c:	66 a3 c6 32 2c f0    	mov    %ax,0xf02c32c6
	SETGATE(idt[T_GPFLT], 0, GD_KT, gpflt_handler, 0)
f0104b52:	b8 5e 56 10 f0       	mov    $0xf010565e,%eax
f0104b57:	66 a3 c8 32 2c f0    	mov    %ax,0xf02c32c8
f0104b5d:	66 c7 05 ca 32 2c f0 	movw   $0x8,0xf02c32ca
f0104b64:	08 00 
f0104b66:	c6 05 cc 32 2c f0 00 	movb   $0x0,0xf02c32cc
f0104b6d:	c6 05 cd 32 2c f0 8e 	movb   $0x8e,0xf02c32cd
f0104b74:	c1 e8 10             	shr    $0x10,%eax
f0104b77:	66 a3 ce 32 2c f0    	mov    %ax,0xf02c32ce
	SETGATE(idt[T_PGFLT], 0, GD_KT, pgflt_handler, 0)
f0104b7d:	b8 66 56 10 f0       	mov    $0xf0105666,%eax
f0104b82:	66 a3 d0 32 2c f0    	mov    %ax,0xf02c32d0
f0104b88:	66 c7 05 d2 32 2c f0 	movw   $0x8,0xf02c32d2
f0104b8f:	08 00 
f0104b91:	c6 05 d4 32 2c f0 00 	movb   $0x0,0xf02c32d4
f0104b98:	c6 05 d5 32 2c f0 8e 	movb   $0x8e,0xf02c32d5
f0104b9f:	c1 e8 10             	shr    $0x10,%eax
f0104ba2:	66 a3 d6 32 2c f0    	mov    %ax,0xf02c32d6
	SETGATE(idt[T_FPERR], 0, GD_KT, fperr_handler, 0)
f0104ba8:	b8 6a 56 10 f0       	mov    $0xf010566a,%eax
f0104bad:	66 a3 e0 32 2c f0    	mov    %ax,0xf02c32e0
f0104bb3:	66 c7 05 e2 32 2c f0 	movw   $0x8,0xf02c32e2
f0104bba:	08 00 
f0104bbc:	c6 05 e4 32 2c f0 00 	movb   $0x0,0xf02c32e4
f0104bc3:	c6 05 e5 32 2c f0 8e 	movb   $0x8e,0xf02c32e5
f0104bca:	c1 e8 10             	shr    $0x10,%eax
f0104bcd:	66 a3 e6 32 2c f0    	mov    %ax,0xf02c32e6
	SETGATE(idt[T_ALIGN], 0, GD_KT, align_handler, 0)
f0104bd3:	b8 70 56 10 f0       	mov    $0xf0105670,%eax
f0104bd8:	66 a3 e8 32 2c f0    	mov    %ax,0xf02c32e8
f0104bde:	66 c7 05 ea 32 2c f0 	movw   $0x8,0xf02c32ea
f0104be5:	08 00 
f0104be7:	c6 05 ec 32 2c f0 00 	movb   $0x0,0xf02c32ec
f0104bee:	c6 05 ed 32 2c f0 8e 	movb   $0x8e,0xf02c32ed
f0104bf5:	c1 e8 10             	shr    $0x10,%eax
f0104bf8:	66 a3 ee 32 2c f0    	mov    %ax,0xf02c32ee
	SETGATE(idt[T_MCHK], 0, GD_KT, mchk_handler, 0)
f0104bfe:	b8 74 56 10 f0       	mov    $0xf0105674,%eax
f0104c03:	66 a3 f0 32 2c f0    	mov    %ax,0xf02c32f0
f0104c09:	66 c7 05 f2 32 2c f0 	movw   $0x8,0xf02c32f2
f0104c10:	08 00 
f0104c12:	c6 05 f4 32 2c f0 00 	movb   $0x0,0xf02c32f4
f0104c19:	c6 05 f5 32 2c f0 8e 	movb   $0x8e,0xf02c32f5
f0104c20:	c1 e8 10             	shr    $0x10,%eax
f0104c23:	66 a3 f6 32 2c f0    	mov    %ax,0xf02c32f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, simderr_handler, 3)
f0104c29:	b8 7a 56 10 f0       	mov    $0xf010567a,%eax
f0104c2e:	66 a3 f8 32 2c f0    	mov    %ax,0xf02c32f8
f0104c34:	66 c7 05 fa 32 2c f0 	movw   $0x8,0xf02c32fa
f0104c3b:	08 00 
f0104c3d:	c6 05 fc 32 2c f0 00 	movb   $0x0,0xf02c32fc
f0104c44:	c6 05 fd 32 2c f0 ee 	movb   $0xee,0xf02c32fd
f0104c4b:	c1 e8 10             	shr    $0x10,%eax
f0104c4e:	66 a3 fe 32 2c f0    	mov    %ax,0xf02c32fe
	
	SETGATE(idt[IRQ_OFFSET], 0, GD_KT, irq0_handler, 0)
f0104c54:	b8 80 56 10 f0       	mov    $0xf0105680,%eax
f0104c59:	66 a3 60 33 2c f0    	mov    %ax,0xf02c3360
f0104c5f:	66 c7 05 62 33 2c f0 	movw   $0x8,0xf02c3362
f0104c66:	08 00 
f0104c68:	c6 05 64 33 2c f0 00 	movb   $0x0,0xf02c3364
f0104c6f:	c6 05 65 33 2c f0 8e 	movb   $0x8e,0xf02c3365
f0104c76:	c1 e8 10             	shr    $0x10,%eax
f0104c79:	66 a3 66 33 2c f0    	mov    %ax,0xf02c3366
	SETGATE(idt[IRQ_OFFSET+1], 0, GD_KT, irq1_handler, 0)
f0104c7f:	b8 86 56 10 f0       	mov    $0xf0105686,%eax
f0104c84:	66 a3 68 33 2c f0    	mov    %ax,0xf02c3368
f0104c8a:	66 c7 05 6a 33 2c f0 	movw   $0x8,0xf02c336a
f0104c91:	08 00 
f0104c93:	c6 05 6c 33 2c f0 00 	movb   $0x0,0xf02c336c
f0104c9a:	c6 05 6d 33 2c f0 8e 	movb   $0x8e,0xf02c336d
f0104ca1:	c1 e8 10             	shr    $0x10,%eax
f0104ca4:	66 a3 6e 33 2c f0    	mov    %ax,0xf02c336e
	SETGATE(idt[IRQ_OFFSET+2], 0, GD_KT, irq2_handler, 0)
f0104caa:	b8 8c 56 10 f0       	mov    $0xf010568c,%eax
f0104caf:	66 a3 70 33 2c f0    	mov    %ax,0xf02c3370
f0104cb5:	66 c7 05 72 33 2c f0 	movw   $0x8,0xf02c3372
f0104cbc:	08 00 
f0104cbe:	c6 05 74 33 2c f0 00 	movb   $0x0,0xf02c3374
f0104cc5:	c6 05 75 33 2c f0 8e 	movb   $0x8e,0xf02c3375
f0104ccc:	c1 e8 10             	shr    $0x10,%eax
f0104ccf:	66 a3 76 33 2c f0    	mov    %ax,0xf02c3376
	SETGATE(idt[IRQ_OFFSET+3], 0, GD_KT, irq3_handler, 0)
f0104cd5:	b8 92 56 10 f0       	mov    $0xf0105692,%eax
f0104cda:	66 a3 78 33 2c f0    	mov    %ax,0xf02c3378
f0104ce0:	66 c7 05 7a 33 2c f0 	movw   $0x8,0xf02c337a
f0104ce7:	08 00 
f0104ce9:	c6 05 7c 33 2c f0 00 	movb   $0x0,0xf02c337c
f0104cf0:	c6 05 7d 33 2c f0 8e 	movb   $0x8e,0xf02c337d
f0104cf7:	c1 e8 10             	shr    $0x10,%eax
f0104cfa:	66 a3 7e 33 2c f0    	mov    %ax,0xf02c337e
	SETGATE(idt[IRQ_OFFSET+4], 0, GD_KT, irq4_handler, 0)
f0104d00:	b8 98 56 10 f0       	mov    $0xf0105698,%eax
f0104d05:	66 a3 80 33 2c f0    	mov    %ax,0xf02c3380
f0104d0b:	66 c7 05 82 33 2c f0 	movw   $0x8,0xf02c3382
f0104d12:	08 00 
f0104d14:	c6 05 84 33 2c f0 00 	movb   $0x0,0xf02c3384
f0104d1b:	c6 05 85 33 2c f0 8e 	movb   $0x8e,0xf02c3385
f0104d22:	c1 e8 10             	shr    $0x10,%eax
f0104d25:	66 a3 86 33 2c f0    	mov    %ax,0xf02c3386
	SETGATE(idt[IRQ_OFFSET+5], 0, GD_KT, irq5_handler, 0)
f0104d2b:	b8 9e 56 10 f0       	mov    $0xf010569e,%eax
f0104d30:	66 a3 88 33 2c f0    	mov    %ax,0xf02c3388
f0104d36:	66 c7 05 8a 33 2c f0 	movw   $0x8,0xf02c338a
f0104d3d:	08 00 
f0104d3f:	c6 05 8c 33 2c f0 00 	movb   $0x0,0xf02c338c
f0104d46:	c6 05 8d 33 2c f0 8e 	movb   $0x8e,0xf02c338d
f0104d4d:	c1 e8 10             	shr    $0x10,%eax
f0104d50:	66 a3 8e 33 2c f0    	mov    %ax,0xf02c338e
	SETGATE(idt[IRQ_OFFSET+6], 0, GD_KT, irq6_handler, 0)
f0104d56:	b8 a4 56 10 f0       	mov    $0xf01056a4,%eax
f0104d5b:	66 a3 90 33 2c f0    	mov    %ax,0xf02c3390
f0104d61:	66 c7 05 92 33 2c f0 	movw   $0x8,0xf02c3392
f0104d68:	08 00 
f0104d6a:	c6 05 94 33 2c f0 00 	movb   $0x0,0xf02c3394
f0104d71:	c6 05 95 33 2c f0 8e 	movb   $0x8e,0xf02c3395
f0104d78:	c1 e8 10             	shr    $0x10,%eax
f0104d7b:	66 a3 96 33 2c f0    	mov    %ax,0xf02c3396
	SETGATE(idt[IRQ_OFFSET+7], 0, GD_KT, irq7_handler, 0)
f0104d81:	b8 aa 56 10 f0       	mov    $0xf01056aa,%eax
f0104d86:	66 a3 98 33 2c f0    	mov    %ax,0xf02c3398
f0104d8c:	66 c7 05 9a 33 2c f0 	movw   $0x8,0xf02c339a
f0104d93:	08 00 
f0104d95:	c6 05 9c 33 2c f0 00 	movb   $0x0,0xf02c339c
f0104d9c:	c6 05 9d 33 2c f0 8e 	movb   $0x8e,0xf02c339d
f0104da3:	c1 e8 10             	shr    $0x10,%eax
f0104da6:	66 a3 9e 33 2c f0    	mov    %ax,0xf02c339e
	SETGATE(idt[IRQ_OFFSET+8], 0, GD_KT, irq8_handler, 0)
f0104dac:	b8 b0 56 10 f0       	mov    $0xf01056b0,%eax
f0104db1:	66 a3 a0 33 2c f0    	mov    %ax,0xf02c33a0
f0104db7:	66 c7 05 a2 33 2c f0 	movw   $0x8,0xf02c33a2
f0104dbe:	08 00 
f0104dc0:	c6 05 a4 33 2c f0 00 	movb   $0x0,0xf02c33a4
f0104dc7:	c6 05 a5 33 2c f0 8e 	movb   $0x8e,0xf02c33a5
f0104dce:	c1 e8 10             	shr    $0x10,%eax
f0104dd1:	66 a3 a6 33 2c f0    	mov    %ax,0xf02c33a6
	SETGATE(idt[IRQ_OFFSET+9], 0, GD_KT, irq9_handler, 0)
f0104dd7:	b8 b6 56 10 f0       	mov    $0xf01056b6,%eax
f0104ddc:	66 a3 a8 33 2c f0    	mov    %ax,0xf02c33a8
f0104de2:	66 c7 05 aa 33 2c f0 	movw   $0x8,0xf02c33aa
f0104de9:	08 00 
f0104deb:	c6 05 ac 33 2c f0 00 	movb   $0x0,0xf02c33ac
f0104df2:	c6 05 ad 33 2c f0 8e 	movb   $0x8e,0xf02c33ad
f0104df9:	c1 e8 10             	shr    $0x10,%eax
f0104dfc:	66 a3 ae 33 2c f0    	mov    %ax,0xf02c33ae
	SETGATE(idt[IRQ_OFFSET+10], 0, GD_KT, irq10_handler, 0)
f0104e02:	b8 bc 56 10 f0       	mov    $0xf01056bc,%eax
f0104e07:	66 a3 b0 33 2c f0    	mov    %ax,0xf02c33b0
f0104e0d:	66 c7 05 b2 33 2c f0 	movw   $0x8,0xf02c33b2
f0104e14:	08 00 
f0104e16:	c6 05 b4 33 2c f0 00 	movb   $0x0,0xf02c33b4
f0104e1d:	c6 05 b5 33 2c f0 8e 	movb   $0x8e,0xf02c33b5
f0104e24:	c1 e8 10             	shr    $0x10,%eax
f0104e27:	66 a3 b6 33 2c f0    	mov    %ax,0xf02c33b6
	SETGATE(idt[IRQ_OFFSET+11], 0, GD_KT, irq11_handler, 0)
f0104e2d:	b8 c2 56 10 f0       	mov    $0xf01056c2,%eax
f0104e32:	66 a3 b8 33 2c f0    	mov    %ax,0xf02c33b8
f0104e38:	66 c7 05 ba 33 2c f0 	movw   $0x8,0xf02c33ba
f0104e3f:	08 00 
f0104e41:	c6 05 bc 33 2c f0 00 	movb   $0x0,0xf02c33bc
f0104e48:	c6 05 bd 33 2c f0 8e 	movb   $0x8e,0xf02c33bd
f0104e4f:	c1 e8 10             	shr    $0x10,%eax
f0104e52:	66 a3 be 33 2c f0    	mov    %ax,0xf02c33be
	SETGATE(idt[IRQ_OFFSET+12], 0, GD_KT, irq12_handler, 0)
f0104e58:	b8 c8 56 10 f0       	mov    $0xf01056c8,%eax
f0104e5d:	66 a3 c0 33 2c f0    	mov    %ax,0xf02c33c0
f0104e63:	66 c7 05 c2 33 2c f0 	movw   $0x8,0xf02c33c2
f0104e6a:	08 00 
f0104e6c:	c6 05 c4 33 2c f0 00 	movb   $0x0,0xf02c33c4
f0104e73:	c6 05 c5 33 2c f0 8e 	movb   $0x8e,0xf02c33c5
f0104e7a:	c1 e8 10             	shr    $0x10,%eax
f0104e7d:	66 a3 c6 33 2c f0    	mov    %ax,0xf02c33c6
	SETGATE(idt[IRQ_OFFSET+13], 0, GD_KT, irq13_handler, 0)
f0104e83:	b8 ce 56 10 f0       	mov    $0xf01056ce,%eax
f0104e88:	66 a3 c8 33 2c f0    	mov    %ax,0xf02c33c8
f0104e8e:	66 c7 05 ca 33 2c f0 	movw   $0x8,0xf02c33ca
f0104e95:	08 00 
f0104e97:	c6 05 cc 33 2c f0 00 	movb   $0x0,0xf02c33cc
f0104e9e:	c6 05 cd 33 2c f0 8e 	movb   $0x8e,0xf02c33cd
f0104ea5:	c1 e8 10             	shr    $0x10,%eax
f0104ea8:	66 a3 ce 33 2c f0    	mov    %ax,0xf02c33ce
	SETGATE(idt[IRQ_OFFSET+14], 0, GD_KT, irq14_handler, 0)
f0104eae:	b8 d4 56 10 f0       	mov    $0xf01056d4,%eax
f0104eb3:	66 a3 d0 33 2c f0    	mov    %ax,0xf02c33d0
f0104eb9:	66 c7 05 d2 33 2c f0 	movw   $0x8,0xf02c33d2
f0104ec0:	08 00 
f0104ec2:	c6 05 d4 33 2c f0 00 	movb   $0x0,0xf02c33d4
f0104ec9:	c6 05 d5 33 2c f0 8e 	movb   $0x8e,0xf02c33d5
f0104ed0:	c1 e8 10             	shr    $0x10,%eax
f0104ed3:	66 a3 d6 33 2c f0    	mov    %ax,0xf02c33d6
	SETGATE(idt[IRQ_OFFSET+15], 0, GD_KT, irq15_handler, 0)
f0104ed9:	b8 da 56 10 f0       	mov    $0xf01056da,%eax
f0104ede:	66 a3 d8 33 2c f0    	mov    %ax,0xf02c33d8
f0104ee4:	66 c7 05 da 33 2c f0 	movw   $0x8,0xf02c33da
f0104eeb:	08 00 
f0104eed:	c6 05 dc 33 2c f0 00 	movb   $0x0,0xf02c33dc
f0104ef4:	c6 05 dd 33 2c f0 8e 	movb   $0x8e,0xf02c33dd
f0104efb:	c1 e8 10             	shr    $0x10,%eax
f0104efe:	66 a3 de 33 2c f0    	mov    %ax,0xf02c33de
	

	SETGATE(idt[T_SYSCALL], 0, GD_KT, syscall_handler, 3)
f0104f04:	b8 e0 56 10 f0       	mov    $0xf01056e0,%eax
f0104f09:	66 a3 e0 33 2c f0    	mov    %ax,0xf02c33e0
f0104f0f:	66 c7 05 e2 33 2c f0 	movw   $0x8,0xf02c33e2
f0104f16:	08 00 
f0104f18:	c6 05 e4 33 2c f0 00 	movb   $0x0,0xf02c33e4
f0104f1f:	c6 05 e5 33 2c f0 ee 	movb   $0xee,0xf02c33e5
f0104f26:	c1 e8 10             	shr    $0x10,%eax
f0104f29:	66 a3 e6 33 2c f0    	mov    %ax,0xf02c33e6
	
	trap_init_percpu();
f0104f2f:	e8 1c f9 ff ff       	call   f0104850 <trap_init_percpu>
}
f0104f34:	c9                   	leave  
f0104f35:	c3                   	ret    

f0104f36 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0104f36:	55                   	push   %ebp
f0104f37:	89 e5                	mov    %esp,%ebp
f0104f39:	53                   	push   %ebx
f0104f3a:	83 ec 14             	sub    $0x14,%esp
f0104f3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104f40:	8b 03                	mov    (%ebx),%eax
f0104f42:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104f46:	c7 04 24 06 9c 10 f0 	movl   $0xf0109c06,(%esp)
f0104f4d:	e8 d5 f8 ff ff       	call   f0104827 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104f52:	8b 43 04             	mov    0x4(%ebx),%eax
f0104f55:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104f59:	c7 04 24 15 9c 10 f0 	movl   $0xf0109c15,(%esp)
f0104f60:	e8 c2 f8 ff ff       	call   f0104827 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0104f65:	8b 43 08             	mov    0x8(%ebx),%eax
f0104f68:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104f6c:	c7 04 24 24 9c 10 f0 	movl   $0xf0109c24,(%esp)
f0104f73:	e8 af f8 ff ff       	call   f0104827 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0104f78:	8b 43 0c             	mov    0xc(%ebx),%eax
f0104f7b:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104f7f:	c7 04 24 33 9c 10 f0 	movl   $0xf0109c33,(%esp)
f0104f86:	e8 9c f8 ff ff       	call   f0104827 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104f8b:	8b 43 10             	mov    0x10(%ebx),%eax
f0104f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104f92:	c7 04 24 42 9c 10 f0 	movl   $0xf0109c42,(%esp)
f0104f99:	e8 89 f8 ff ff       	call   f0104827 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104f9e:	8b 43 14             	mov    0x14(%ebx),%eax
f0104fa1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104fa5:	c7 04 24 51 9c 10 f0 	movl   $0xf0109c51,(%esp)
f0104fac:	e8 76 f8 ff ff       	call   f0104827 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0104fb1:	8b 43 18             	mov    0x18(%ebx),%eax
f0104fb4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104fb8:	c7 04 24 60 9c 10 f0 	movl   $0xf0109c60,(%esp)
f0104fbf:	e8 63 f8 ff ff       	call   f0104827 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0104fc4:	8b 43 1c             	mov    0x1c(%ebx),%eax
f0104fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104fcb:	c7 04 24 6f 9c 10 f0 	movl   $0xf0109c6f,(%esp)
f0104fd2:	e8 50 f8 ff ff       	call   f0104827 <cprintf>
}
f0104fd7:	83 c4 14             	add    $0x14,%esp
f0104fda:	5b                   	pop    %ebx
f0104fdb:	5d                   	pop    %ebp
f0104fdc:	c3                   	ret    

f0104fdd <print_trapframe>:
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
f0104fdd:	55                   	push   %ebp
f0104fde:	89 e5                	mov    %esp,%ebp
f0104fe0:	56                   	push   %esi
f0104fe1:	53                   	push   %ebx
f0104fe2:	83 ec 10             	sub    $0x10,%esp
f0104fe5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104fe8:	e8 0c 24 00 00       	call   f01073f9 <cpunum>
f0104fed:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104ff1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104ff5:	c7 04 24 d3 9c 10 f0 	movl   $0xf0109cd3,(%esp)
f0104ffc:	e8 26 f8 ff ff       	call   f0104827 <cprintf>
	print_regs(&tf->tf_regs);
f0105001:	89 1c 24             	mov    %ebx,(%esp)
f0105004:	e8 2d ff ff ff       	call   f0104f36 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0105009:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f010500d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105011:	c7 04 24 f1 9c 10 f0 	movl   $0xf0109cf1,(%esp)
f0105018:	e8 0a f8 ff ff       	call   f0104827 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f010501d:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0105021:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105025:	c7 04 24 04 9d 10 f0 	movl   $0xf0109d04,(%esp)
f010502c:	e8 f6 f7 ff ff       	call   f0104827 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0105031:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f0105034:	83 f8 13             	cmp    $0x13,%eax
f0105037:	77 09                	ja     f0105042 <print_trapframe+0x65>
		return excnames[trapno];
f0105039:	8b 14 85 e0 9f 10 f0 	mov    -0xfef6020(,%eax,4),%edx
f0105040:	eb 1f                	jmp    f0105061 <print_trapframe+0x84>
	if (trapno == T_SYSCALL)
f0105042:	83 f8 30             	cmp    $0x30,%eax
f0105045:	74 15                	je     f010505c <print_trapframe+0x7f>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0105047:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f010504a:	83 fa 0f             	cmp    $0xf,%edx
f010504d:	ba 8a 9c 10 f0       	mov    $0xf0109c8a,%edx
f0105052:	b9 9d 9c 10 f0       	mov    $0xf0109c9d,%ecx
f0105057:	0f 47 d1             	cmova  %ecx,%edx
f010505a:	eb 05                	jmp    f0105061 <print_trapframe+0x84>
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
f010505c:	ba 7e 9c 10 f0       	mov    $0xf0109c7e,%edx
{
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0105061:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105065:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105069:	c7 04 24 17 9d 10 f0 	movl   $0xf0109d17,(%esp)
f0105070:	e8 b2 f7 ff ff       	call   f0104827 <cprintf>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0105075:	3b 1d 60 3a 2c f0    	cmp    0xf02c3a60,%ebx
f010507b:	75 19                	jne    f0105096 <print_trapframe+0xb9>
f010507d:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0105081:	75 13                	jne    f0105096 <print_trapframe+0xb9>

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f0105083:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0105086:	89 44 24 04          	mov    %eax,0x4(%esp)
f010508a:	c7 04 24 29 9d 10 f0 	movl   $0xf0109d29,(%esp)
f0105091:	e8 91 f7 ff ff       	call   f0104827 <cprintf>
	cprintf("  err  0x%08x", tf->tf_err);
f0105096:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0105099:	89 44 24 04          	mov    %eax,0x4(%esp)
f010509d:	c7 04 24 38 9d 10 f0 	movl   $0xf0109d38,(%esp)
f01050a4:	e8 7e f7 ff ff       	call   f0104827 <cprintf>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f01050a9:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01050ad:	75 51                	jne    f0105100 <print_trapframe+0x123>
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
f01050af:	8b 43 2c             	mov    0x2c(%ebx),%eax
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
f01050b2:	89 c2                	mov    %eax,%edx
f01050b4:	83 e2 01             	and    $0x1,%edx
f01050b7:	ba ac 9c 10 f0       	mov    $0xf0109cac,%edx
f01050bc:	b9 b7 9c 10 f0       	mov    $0xf0109cb7,%ecx
f01050c1:	0f 45 ca             	cmovne %edx,%ecx
f01050c4:	89 c2                	mov    %eax,%edx
f01050c6:	83 e2 02             	and    $0x2,%edx
f01050c9:	ba c3 9c 10 f0       	mov    $0xf0109cc3,%edx
f01050ce:	be c9 9c 10 f0       	mov    $0xf0109cc9,%esi
f01050d3:	0f 44 d6             	cmove  %esi,%edx
f01050d6:	83 e0 04             	and    $0x4,%eax
f01050d9:	b8 ce 9c 10 f0       	mov    $0xf0109cce,%eax
f01050de:	be 03 9e 10 f0       	mov    $0xf0109e03,%esi
f01050e3:	0f 44 c6             	cmove  %esi,%eax
f01050e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f01050ea:	89 54 24 08          	mov    %edx,0x8(%esp)
f01050ee:	89 44 24 04          	mov    %eax,0x4(%esp)
f01050f2:	c7 04 24 46 9d 10 f0 	movl   $0xf0109d46,(%esp)
f01050f9:	e8 29 f7 ff ff       	call   f0104827 <cprintf>
f01050fe:	eb 0c                	jmp    f010510c <print_trapframe+0x12f>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
f0105100:	c7 04 24 16 8a 10 f0 	movl   $0xf0108a16,(%esp)
f0105107:	e8 1b f7 ff ff       	call   f0104827 <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f010510c:	8b 43 30             	mov    0x30(%ebx),%eax
f010510f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105113:	c7 04 24 55 9d 10 f0 	movl   $0xf0109d55,(%esp)
f010511a:	e8 08 f7 ff ff       	call   f0104827 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f010511f:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0105123:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105127:	c7 04 24 64 9d 10 f0 	movl   $0xf0109d64,(%esp)
f010512e:	e8 f4 f6 ff ff       	call   f0104827 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0105133:	8b 43 38             	mov    0x38(%ebx),%eax
f0105136:	89 44 24 04          	mov    %eax,0x4(%esp)
f010513a:	c7 04 24 77 9d 10 f0 	movl   $0xf0109d77,(%esp)
f0105141:	e8 e1 f6 ff ff       	call   f0104827 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0105146:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010514a:	74 27                	je     f0105173 <print_trapframe+0x196>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f010514c:	8b 43 3c             	mov    0x3c(%ebx),%eax
f010514f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105153:	c7 04 24 86 9d 10 f0 	movl   $0xf0109d86,(%esp)
f010515a:	e8 c8 f6 ff ff       	call   f0104827 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f010515f:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0105163:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105167:	c7 04 24 95 9d 10 f0 	movl   $0xf0109d95,(%esp)
f010516e:	e8 b4 f6 ff ff       	call   f0104827 <cprintf>
	}
}
f0105173:	83 c4 10             	add    $0x10,%esp
f0105176:	5b                   	pop    %ebx
f0105177:	5e                   	pop    %esi
f0105178:	5d                   	pop    %ebp
f0105179:	c3                   	ret    

f010517a <page_fault_handler>:
	
}


void page_fault_handler(struct Trapframe *tf)
{
f010517a:	55                   	push   %ebp
f010517b:	89 e5                	mov    %esp,%ebp
f010517d:	57                   	push   %edi
f010517e:	56                   	push   %esi
f010517f:	53                   	push   %ebx
f0105180:	83 ec 5c             	sub    $0x5c,%esp
f0105183:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0105186:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	/*if(fault_va > ULIM)
		panic("Page fault occurred in kernel!!Exiting!!");*/
	if(tf->tf_cs == (GD_KT >> 3))
f0105189:	66 83 7b 34 01       	cmpw   $0x1,0x34(%ebx)
f010518e:	75 1c                	jne    f01051ac <page_fault_handler+0x32>
		panic("Page fault occurred in kernel!!Exiting!!");
f0105190:	c7 44 24 08 50 9f 10 	movl   $0xf0109f50,0x8(%esp)
f0105197:	f0 
f0105198:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
f010519f:	00 
f01051a0:	c7 04 24 a8 9d 10 f0 	movl   $0xf0109da8,(%esp)
f01051a7:	e8 f1 ae ff ff       	call   f010009d <_panic>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.

	if(curenv->env_pgfault_upcall == (void *)0)
f01051ac:	e8 48 22 00 00       	call   f01073f9 <cpunum>
f01051b1:	6b c0 74             	imul   $0x74,%eax,%eax
f01051b4:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01051ba:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f01051be:	75 4f                	jne    f010520f <page_fault_handler+0x95>
	{

	// Destroy the environment that caused the fault.
		cprintf("[%08x] user fault va %08x ip %08x\n",
f01051c0:	8b 7b 30             	mov    0x30(%ebx),%edi
			curenv->env_id, fault_va, tf->tf_eip);
f01051c3:	e8 31 22 00 00       	call   f01073f9 <cpunum>

	if(curenv->env_pgfault_upcall == (void *)0)
	{

	// Destroy the environment that caused the fault.
		cprintf("[%08x] user fault va %08x ip %08x\n",
f01051c8:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01051cc:	89 74 24 08          	mov    %esi,0x8(%esp)
			curenv->env_id, fault_va, tf->tf_eip);
f01051d0:	6b c0 74             	imul   $0x74,%eax,%eax

	if(curenv->env_pgfault_upcall == (void *)0)
	{

	// Destroy the environment that caused the fault.
		cprintf("[%08x] user fault va %08x ip %08x\n",
f01051d3:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01051d9:	8b 40 48             	mov    0x48(%eax),%eax
f01051dc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051e0:	c7 04 24 7c 9f 10 f0 	movl   $0xf0109f7c,(%esp)
f01051e7:	e8 3b f6 ff ff       	call   f0104827 <cprintf>
			curenv->env_id, fault_va, tf->tf_eip);
		print_trapframe(tf);
f01051ec:	89 1c 24             	mov    %ebx,(%esp)
f01051ef:	e8 e9 fd ff ff       	call   f0104fdd <print_trapframe>
		env_destroy(curenv);
f01051f4:	e8 00 22 00 00       	call   f01073f9 <cpunum>
f01051f9:	6b c0 74             	imul   $0x74,%eax,%eax
f01051fc:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105202:	89 04 24             	mov    %eax,(%esp)
f0105205:	e8 5b f3 ff ff       	call   f0104565 <env_destroy>
f010520a:	e9 68 01 00 00       	jmp    f0105377 <page_fault_handler+0x1fd>
			//print_regs(&tf->tf_regs);
			//cprintf("\nutf-regs\n");
			//print_regs(&utf.utf_regs);
			//copy utrapframe on uxstacktop-sizeof(struct Utrapframe *)
		//cprintf("\ntrap in to pagefault by child---envid:%x\n",curenv->env_id);
		user_mem_assert(curenv, (void *)(UXSTACKTOP-1), 1, PTE_P|PTE_U|PTE_W);
f010520f:	e8 e5 21 00 00       	call   f01073f9 <cpunum>
f0105214:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f010521b:	00 
f010521c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105223:	00 
f0105224:	c7 44 24 04 ff ff bf 	movl   $0xeebfffff,0x4(%esp)
f010522b:	ee 
f010522c:	6b c0 74             	imul   $0x74,%eax,%eax
f010522f:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105235:	89 04 24             	mov    %eax,(%esp)
f0105238:	e8 37 ea ff ff       	call   f0103c74 <user_mem_assert>
		utf.utf_fault_va = fault_va;
f010523d:	89 75 b4             	mov    %esi,-0x4c(%ebp)
		utf.utf_err = tf->tf_err;
f0105240:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0105243:	89 45 b8             	mov    %eax,-0x48(%ebp)
		utf.utf_regs = tf->tf_regs;
f0105246:	8b 03                	mov    (%ebx),%eax
f0105248:	89 45 bc             	mov    %eax,-0x44(%ebp)
f010524b:	8b 43 04             	mov    0x4(%ebx),%eax
f010524e:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0105251:	8b 43 08             	mov    0x8(%ebx),%eax
f0105254:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0105257:	8b 43 0c             	mov    0xc(%ebx),%eax
f010525a:	89 45 c8             	mov    %eax,-0x38(%ebp)
f010525d:	8b 43 10             	mov    0x10(%ebx),%eax
f0105260:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0105263:	8b 43 14             	mov    0x14(%ebx),%eax
f0105266:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105269:	8b 43 18             	mov    0x18(%ebx),%eax
f010526c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010526f:	8b 43 1c             	mov    0x1c(%ebx),%eax
f0105272:	89 45 d8             	mov    %eax,-0x28(%ebp)
		utf.utf_eip = tf->tf_eip;
f0105275:	8b 43 30             	mov    0x30(%ebx),%eax
f0105278:	89 45 dc             	mov    %eax,-0x24(%ebp)
		utf.utf_eflags = tf->tf_eflags;
f010527b:	8b 43 38             	mov    0x38(%ebx),%eax
f010527e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		utf.utf_esp = tf->tf_esp;
f0105281:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0105284:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		//need to check esp of trapframe to see whether its already uxstacktop or ustacktop
		if(tf->tf_esp > USTACKTOP)
f0105287:	3d 00 e0 bf ee       	cmp    $0xeebfe000,%eax
f010528c:	0f 86 af 00 00 00    	jbe    f0105341 <page_fault_handler+0x1c7>
		{
			//cprintf("\npagefault occurred in exception stack i.e pagefault handler addr:%x\n",tf->tf_esp);
			if(tf->tf_esp > (UXSTACKTOP-PGSIZE) && tf->tf_esp<=(UXSTACKTOP-1))
f0105292:	8d 90 ff 0f 40 11    	lea    0x11400fff(%eax),%edx
f0105298:	81 fa fe 0f 00 00    	cmp    $0xffe,%edx
f010529e:	77 3a                	ja     f01052da <page_fault_handler+0x160>
			{
				//check if new frame overflows uxstacktop-pgsize
				//if so then allocate a new page at va  uxstacktop-pgsize
				//right now I am not checking that.
				if((tf->tf_esp - sizeof(utf)) < (UXSTACKTOP-PGSIZE))
f01052a0:	83 e8 34             	sub    $0x34,%eax
f01052a3:	3d ff ef bf ee       	cmp    $0xeebfefff,%eax
f01052a8:	77 56                	ja     f0105300 <page_fault_handler+0x186>
				{
					//uxstack is overflowing
					//should I need to allocate new reserved page
					user_mem_assert(curenv, (void *)(UXSTACKTOP - (PGSIZE)-1), 1, PTE_P|PTE_U|PTE_W);
f01052aa:	e8 4a 21 00 00       	call   f01073f9 <cpunum>
f01052af:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f01052b6:	00 
f01052b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01052be:	00 
f01052bf:	c7 44 24 04 ff ef bf 	movl   $0xeebfefff,0x4(%esp)
f01052c6:	ee 
f01052c7:	6b c0 74             	imul   $0x74,%eax,%eax
f01052ca:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01052d0:	89 04 24             	mov    %eax,(%esp)
f01052d3:	e8 9c e9 ff ff       	call   f0103c74 <user_mem_assert>
f01052d8:	eb 26                	jmp    f0105300 <page_fault_handler+0x186>
					//panic("\nUXSTACK is overflowing\n");
				} 	
			}
			//already allocated the reserved page for exception user stack
			else if((tf->tf_esp - sizeof(utf)) < (UXSTACKTOP-2*PGSIZE))
f01052da:	83 e8 34             	sub    $0x34,%eax
f01052dd:	3d ff df bf ee       	cmp    $0xeebfdfff,%eax
f01052e2:	77 1c                	ja     f0105300 <page_fault_handler+0x186>
			{
					//uxstack is overflowing
					//should I need to allocate new reserved page
					panic("\nUXSTACK is overflown. Limit reached. No extra pages\n");
f01052e4:	c7 44 24 08 a0 9f 10 	movl   $0xf0109fa0,0x8(%esp)
f01052eb:	f0 
f01052ec:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
f01052f3:	00 
f01052f4:	c7 04 24 a8 9d 10 f0 	movl   $0xf0109da8,(%esp)
f01052fb:	e8 9d ad ff ff       	call   f010009d <_panic>
			}
			//1. copying empty word to uxstacktop
			memset((void *)(tf->tf_esp - sizeof(uint32_t)), 0, sizeof(uint32_t));
f0105300:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0105307:	00 
f0105308:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010530f:	00 
f0105310:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0105313:	83 e8 04             	sub    $0x4,%eax
f0105316:	89 04 24             	mov    %eax,(%esp)
f0105319:	e8 89 1a 00 00       	call   f0106da7 <memset>
			//2. Now push Utrapframe to uxstacktop's esp
			memcpy((void *)(tf->tf_esp - sizeof(utf) - sizeof(uint32_t)), &utf, sizeof(utf));
f010531e:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
f0105325:	00 
f0105326:	8d 45 b4             	lea    -0x4c(%ebp),%eax
f0105329:	89 44 24 04          	mov    %eax,0x4(%esp)
f010532d:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0105330:	83 e8 38             	sub    $0x38,%eax
f0105333:	89 04 24             	mov    %eax,(%esp)
f0105336:	e8 21 1b 00 00       	call   f0106e5c <memcpy>
			//point esp correctly before tf_pop
			tf->tf_esp = (tf->tf_esp - sizeof(utf) - sizeof(uint32_t));
f010533b:	83 6b 3c 38          	subl   $0x38,0x3c(%ebx)
f010533f:	eb 22                	jmp    f0105363 <page_fault_handler+0x1e9>
		}
		else
		{
			//cprintf("\nfault occured in normal user stack---addr:%x\n", tf->tf_esp);
			//copy Utrapframe and push to uxstacktop
			memcpy((void *)(UXSTACKTOP-sizeof(utf)), &utf, sizeof(utf));
f0105341:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
f0105348:	00 
f0105349:	8d 45 b4             	lea    -0x4c(%ebp),%eax
f010534c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105350:	c7 04 24 cc ff bf ee 	movl   $0xeebfffcc,(%esp)
f0105357:	e8 00 1b 00 00       	call   f0106e5c <memcpy>
			tf->tf_esp = (UXSTACKTOP-sizeof(utf));
f010535c:	c7 43 3c cc ff bf ee 	movl   $0xeebfffcc,0x3c(%ebx)

		}
		//what all changes are needed to jump to user page fault handler
		//1. change eip to pagefault handler
		//2. change the esp to top of uxstack after push utrapframe. (only when pgfault occured from other than pgfault handler)
		tf->tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0105363:	e8 91 20 00 00       	call   f01073f9 <cpunum>
f0105368:	6b c0 74             	imul   $0x74,%eax,%eax
f010536b:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105371:	8b 40 64             	mov    0x64(%eax),%eax
f0105374:	89 43 30             	mov    %eax,0x30(%ebx)

	}
}
f0105377:	83 c4 5c             	add    $0x5c,%esp
f010537a:	5b                   	pop    %ebx
f010537b:	5e                   	pop    %esi
f010537c:	5f                   	pop    %edi
f010537d:	5d                   	pop    %ebp
f010537e:	c3                   	ret    

f010537f <trap>:
	}
}

void
trap(struct Trapframe *tf)
{
f010537f:	55                   	push   %ebp
f0105380:	89 e5                	mov    %esp,%ebp
f0105382:	57                   	push   %edi
f0105383:	56                   	push   %esi
f0105384:	83 ec 20             	sub    $0x20,%esp
f0105387:	8b 75 08             	mov    0x8(%ebp),%esi
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");
f010538a:	fc                   	cld    

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
f010538b:	83 3d 94 3e 2c f0 00 	cmpl   $0x0,0xf02c3e94
f0105392:	74 01                	je     f0105395 <trap+0x16>
		asm volatile("hlt");
f0105394:	f4                   	hlt    

	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0105395:	e8 5f 20 00 00       	call   f01073f9 <cpunum>
f010539a:	6b d0 74             	imul   $0x74,%eax,%edx
f010539d:	81 c2 20 40 2c f0    	add    $0xf02c4020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f01053a3:	b8 01 00 00 00       	mov    $0x1,%eax
f01053a8:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
f01053ac:	83 f8 02             	cmp    $0x2,%eax
f01053af:	75 0c                	jne    f01053bd <trap+0x3e>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01053b1:	c7 04 24 c0 73 12 f0 	movl   $0xf01273c0,(%esp)
f01053b8:	e8 cf 22 00 00       	call   f010768c <spin_lock>

static __inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	__asm __volatile("pushfl; popl %0" : "=r" (eflags));
f01053bd:	9c                   	pushf  
f01053be:	58                   	pop    %eax
		lock_kernel();
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.

	assert(!(read_eflags() & FL_IF));
f01053bf:	f6 c4 02             	test   $0x2,%ah
f01053c2:	74 24                	je     f01053e8 <trap+0x69>
f01053c4:	c7 44 24 0c b4 9d 10 	movl   $0xf0109db4,0xc(%esp)
f01053cb:	f0 
f01053cc:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f01053d3:	f0 
f01053d4:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
f01053db:	00 
f01053dc:	c7 04 24 a8 9d 10 f0 	movl   $0xf0109da8,(%esp)
f01053e3:	e8 b5 ac ff ff       	call   f010009d <_panic>

	if ((tf->tf_cs & 3) == 3) {
f01053e8:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f01053ec:	83 e0 03             	and    $0x3,%eax
f01053ef:	66 83 f8 03          	cmp    $0x3,%ax
f01053f3:	0f 85 a7 00 00 00    	jne    f01054a0 <trap+0x121>
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.
		assert(curenv);
f01053f9:	e8 fb 1f 00 00       	call   f01073f9 <cpunum>
f01053fe:	6b c0 74             	imul   $0x74,%eax,%eax
f0105401:	83 b8 28 40 2c f0 00 	cmpl   $0x0,-0xfd3bfd8(%eax)
f0105408:	75 24                	jne    f010542e <trap+0xaf>
f010540a:	c7 44 24 0c cd 9d 10 	movl   $0xf0109dcd,0xc(%esp)
f0105411:	f0 
f0105412:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0105419:	f0 
f010541a:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
f0105421:	00 
f0105422:	c7 04 24 a8 9d 10 f0 	movl   $0xf0109da8,(%esp)
f0105429:	e8 6f ac ff ff       	call   f010009d <_panic>
f010542e:	c7 04 24 c0 73 12 f0 	movl   $0xf01273c0,(%esp)
f0105435:	e8 52 22 00 00       	call   f010768c <spin_lock>

		lock_kernel();

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
f010543a:	e8 ba 1f 00 00       	call   f01073f9 <cpunum>
f010543f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105442:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105448:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f010544c:	75 2d                	jne    f010547b <trap+0xfc>
			env_free(curenv);
f010544e:	e8 a6 1f 00 00       	call   f01073f9 <cpunum>
f0105453:	6b c0 74             	imul   $0x74,%eax,%eax
f0105456:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f010545c:	89 04 24             	mov    %eax,(%esp)
f010545f:	e8 fc ee ff ff       	call   f0104360 <env_free>
			curenv = NULL;
f0105464:	e8 90 1f 00 00       	call   f01073f9 <cpunum>
f0105469:	6b c0 74             	imul   $0x74,%eax,%eax
f010546c:	c7 80 28 40 2c f0 00 	movl   $0x0,-0xfd3bfd8(%eax)
f0105473:	00 00 00 
			sched_yield();
f0105476:	e8 53 03 00 00       	call   f01057ce <sched_yield>
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
f010547b:	e8 79 1f 00 00       	call   f01073f9 <cpunum>
f0105480:	6b c0 74             	imul   $0x74,%eax,%eax
f0105483:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105489:	b9 11 00 00 00       	mov    $0x11,%ecx
f010548e:	89 c7                	mov    %eax,%edi
f0105490:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0105492:	e8 62 1f 00 00       	call   f01073f9 <cpunum>
f0105497:	6b c0 74             	imul   $0x74,%eax,%eax
f010549a:	8b b0 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%esi
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f01054a0:	89 35 60 3a 2c f0    	mov    %esi,0xf02c3a60
	int32_t sysRet=0;
	int sysno=0;
	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f01054a6:	8b 46 28             	mov    0x28(%esi),%eax
f01054a9:	83 f8 27             	cmp    $0x27,%eax
f01054ac:	75 19                	jne    f01054c7 <trap+0x148>
		cprintf("Spurious interrupt on irq 7\n");
f01054ae:	c7 04 24 d4 9d 10 f0 	movl   $0xf0109dd4,(%esp)
f01054b5:	e8 6d f3 ff ff       	call   f0104827 <cprintf>
		print_trapframe(tf);
f01054ba:	89 34 24             	mov    %esi,(%esp)
f01054bd:	e8 1b fb ff ff       	call   f0104fdd <print_trapframe>
f01054c2:	e9 e6 00 00 00       	jmp    f01055ad <trap+0x22e>


	// Handle keyboard and serial interrupts.
	// LAB 5: Your code here.
	
	if(tf->tf_trapno == T_PGFLT){
f01054c7:	83 f8 0e             	cmp    $0xe,%eax
f01054ca:	75 0e                	jne    f01054da <trap+0x15b>
		//cprintf("\npgfault\n");
		page_fault_handler(tf);
f01054cc:	89 34 24             	mov    %esi,(%esp)
f01054cf:	90                   	nop
f01054d0:	e8 a5 fc ff ff       	call   f010517a <page_fault_handler>
f01054d5:	e9 d3 00 00 00       	jmp    f01055ad <trap+0x22e>
		//cprintf("\npgfault returning\n");
		return;
	}

	if(tf->tf_trapno == (IRQ_OFFSET+IRQ_TIMER))
f01054da:	83 f8 20             	cmp    $0x20,%eax
f01054dd:	75 10                	jne    f01054ef <trap+0x170>
	{
		//cprintf("\ntimer interrupt occurred\n");
		//Need to acknowledge interrupt
		time_tick();
f01054df:	90                   	nop
f01054e0:	e8 56 2e 00 00       	call   f010833b <time_tick>
		lapic_eoi();
f01054e5:	e8 71 20 00 00       	call   f010755b <lapic_eoi>
		//cprintf("\nNow time interrupt yielding\n");
		sched_yield();
f01054ea:	e8 df 02 00 00       	call   f01057ce <sched_yield>
		//return;
	}
	if(tf->tf_trapno == (IRQ_OFFSET+IRQ_KBD))
f01054ef:	83 f8 21             	cmp    $0x21,%eax
f01054f2:	75 0a                	jne    f01054fe <trap+0x17f>
	{
		//cprintf("\n keyboard interrupt occurred\n");
		//lapic_eoi();
		kbd_intr();
f01054f4:	e8 f5 b1 ff ff       	call   f01006ee <kbd_intr>
		sched_yield();
f01054f9:	e8 d0 02 00 00       	call   f01057ce <sched_yield>
	}
	
	if(tf->tf_trapno == (IRQ_OFFSET+IRQ_SERIAL))
f01054fe:	83 f8 24             	cmp    $0x24,%eax
f0105501:	75 0a                	jne    f010550d <trap+0x18e>
	{
		//cprintf("\n serial interrupt occurred\n");
		//lapic_eoi();
		serial_intr();
f0105503:	e8 ca b1 ff ff       	call   f01006d2 <serial_intr>
		sched_yield();
f0105508:	e8 c1 02 00 00       	call   f01057ce <sched_yield>
	}
	
	if(tf->tf_trapno == T_DEBUG){
f010550d:	83 f8 01             	cmp    $0x1,%eax
f0105510:	75 0d                	jne    f010551f <trap+0x1a0>
		monitor(tf);
f0105512:	89 34 24             	mov    %esi,(%esp)
f0105515:	e8 64 b7 ff ff       	call   f0100c7e <monitor>
f010551a:	e9 8e 00 00 00       	jmp    f01055ad <trap+0x22e>
		return;
	}
	if(tf->tf_trapno == T_BRKPT){
f010551f:	83 f8 03             	cmp    $0x3,%eax
f0105522:	75 11                	jne    f0105535 <trap+0x1b6>
		tf->tf_eflags = tf->tf_eflags | SET_TF;
f0105524:	81 4e 38 00 01 00 00 	orl    $0x100,0x38(%esi)
		monitor(tf);
f010552b:	89 34 24             	mov    %esi,(%esp)
f010552e:	e8 4b b7 ff ff       	call   f0100c7e <monitor>
f0105533:	eb 78                	jmp    f01055ad <trap+0x22e>
		return;
	}
	if(tf->tf_trapno == T_SYSCALL){
f0105535:	83 f8 30             	cmp    $0x30,%eax
f0105538:	75 32                	jne    f010556c <trap+0x1ed>
		sysno = tf->tf_regs.reg_eax;
		//cprintf("\nsystem call received-sid:%d\n",sysno);
		tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx, tf->tf_regs.reg_ebx, tf->tf_regs.reg_edi, tf->tf_regs.reg_esi);
f010553a:	8b 46 04             	mov    0x4(%esi),%eax
f010553d:	89 44 24 14          	mov    %eax,0x14(%esp)
f0105541:	8b 06                	mov    (%esi),%eax
f0105543:	89 44 24 10          	mov    %eax,0x10(%esp)
f0105547:	8b 46 10             	mov    0x10(%esi),%eax
f010554a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010554e:	8b 46 18             	mov    0x18(%esi),%eax
f0105551:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105555:	8b 46 14             	mov    0x14(%esi),%eax
f0105558:	89 44 24 04          	mov    %eax,0x4(%esp)
f010555c:	8b 46 1c             	mov    0x1c(%esi),%eax
f010555f:	89 04 24             	mov    %eax,(%esp)
f0105562:	e8 69 03 00 00       	call   f01058d0 <syscall>
f0105567:	89 46 1c             	mov    %eax,0x1c(%esi)
f010556a:	eb 41                	jmp    f01055ad <trap+0x22e>
		
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f010556c:	89 34 24             	mov    %esi,(%esp)
f010556f:	e8 69 fa ff ff       	call   f0104fdd <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0105574:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0105579:	75 1c                	jne    f0105597 <trap+0x218>
		panic("unhandled trap in kernel");
f010557b:	c7 44 24 08 f1 9d 10 	movl   $0xf0109df1,0x8(%esp)
f0105582:	f0 
f0105583:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
f010558a:	00 
f010558b:	c7 04 24 a8 9d 10 f0 	movl   $0xf0109da8,(%esp)
f0105592:	e8 06 ab ff ff       	call   f010009d <_panic>
	else {
		env_destroy(curenv);
f0105597:	e8 5d 1e 00 00       	call   f01073f9 <cpunum>
f010559c:	6b c0 74             	imul   $0x74,%eax,%eax
f010559f:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01055a5:	89 04 24             	mov    %eax,(%esp)
f01055a8:	e8 b8 ef ff ff       	call   f0104565 <env_destroy>
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
f01055ad:	e8 47 1e 00 00       	call   f01073f9 <cpunum>
f01055b2:	6b c0 74             	imul   $0x74,%eax,%eax
f01055b5:	83 b8 28 40 2c f0 00 	cmpl   $0x0,-0xfd3bfd8(%eax)
f01055bc:	74 2a                	je     f01055e8 <trap+0x269>
f01055be:	e8 36 1e 00 00       	call   f01073f9 <cpunum>
f01055c3:	6b c0 74             	imul   $0x74,%eax,%eax
f01055c6:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01055cc:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01055d0:	75 16                	jne    f01055e8 <trap+0x269>
		env_run(curenv);
f01055d2:	e8 22 1e 00 00       	call   f01073f9 <cpunum>
f01055d7:	6b c0 74             	imul   $0x74,%eax,%eax
f01055da:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01055e0:	89 04 24             	mov    %eax,(%esp)
f01055e3:	e8 2c f0 ff ff       	call   f0104614 <env_run>
	else
		sched_yield();
f01055e8:	e8 e1 01 00 00       	call   f01057ce <sched_yield>
f01055ed:	90                   	nop

f01055ee <divide_handler>:
 * Lab 3: Your code here for generating entry points for the different traps.
 */


/*PAGEFAULT_HANDLER(push_frame, esp, eflags, eip, eax, ecx, edx, ebx, oesp, ebp, esi, edi, error, fa)*/
TRAPHANDLER_NOEC(divide_handler, T_DIVIDE)
f01055ee:	6a 00                	push   $0x0
f01055f0:	6a 00                	push   $0x0
f01055f2:	e9 ef 00 00 00       	jmp    f01056e6 <_alltraps>
f01055f7:	90                   	nop

f01055f8 <debug_handler>:
TRAPHANDLER_NOEC(debug_handler, T_DEBUG)
f01055f8:	6a 00                	push   $0x0
f01055fa:	6a 01                	push   $0x1
f01055fc:	e9 e5 00 00 00       	jmp    f01056e6 <_alltraps>
f0105601:	90                   	nop

f0105602 <nmi_handler>:
TRAPHANDLER_NOEC(nmi_handler, T_NMI)
f0105602:	6a 00                	push   $0x0
f0105604:	6a 02                	push   $0x2
f0105606:	e9 db 00 00 00       	jmp    f01056e6 <_alltraps>
f010560b:	90                   	nop

f010560c <bkpt_handler>:
TRAPHANDLER_NOEC(bkpt_handler, T_BRKPT)
f010560c:	6a 00                	push   $0x0
f010560e:	6a 03                	push   $0x3
f0105610:	e9 d1 00 00 00       	jmp    f01056e6 <_alltraps>
f0105615:	90                   	nop

f0105616 <oflow_handler>:
TRAPHANDLER_NOEC(oflow_handler, T_OFLOW)
f0105616:	6a 00                	push   $0x0
f0105618:	6a 04                	push   $0x4
f010561a:	e9 c7 00 00 00       	jmp    f01056e6 <_alltraps>
f010561f:	90                   	nop

f0105620 <bound_handler>:
TRAPHANDLER_NOEC(bound_handler, T_BOUND)
f0105620:	6a 00                	push   $0x0
f0105622:	6a 05                	push   $0x5
f0105624:	e9 bd 00 00 00       	jmp    f01056e6 <_alltraps>
f0105629:	90                   	nop

f010562a <illop_handler>:
TRAPHANDLER_NOEC(illop_handler, T_ILLOP)
f010562a:	6a 00                	push   $0x0
f010562c:	6a 06                	push   $0x6
f010562e:	e9 b3 00 00 00       	jmp    f01056e6 <_alltraps>
f0105633:	90                   	nop

f0105634 <device_handler>:
TRAPHANDLER_NOEC(device_handler, T_DEVICE)
f0105634:	6a 00                	push   $0x0
f0105636:	6a 07                	push   $0x7
f0105638:	e9 a9 00 00 00       	jmp    f01056e6 <_alltraps>
f010563d:	90                   	nop

f010563e <dblflt_handler>:
TRAPHANDLER(dblflt_handler, T_DBLFLT) #8
f010563e:	6a 08                	push   $0x8
f0105640:	e9 a1 00 00 00       	jmp    f01056e6 <_alltraps>
f0105645:	90                   	nop

f0105646 <tss_handler>:
TRAPHANDLER(tss_handler, T_TSS) #10
f0105646:	6a 0a                	push   $0xa
f0105648:	e9 99 00 00 00       	jmp    f01056e6 <_alltraps>
f010564d:	90                   	nop

f010564e <segnp_handler>:
TRAPHANDLER(segnp_handler, T_SEGNP) #11
f010564e:	6a 0b                	push   $0xb
f0105650:	e9 91 00 00 00       	jmp    f01056e6 <_alltraps>
f0105655:	90                   	nop

f0105656 <stack_handler>:
TRAPHANDLER(stack_handler, T_STACK) #12
f0105656:	6a 0c                	push   $0xc
f0105658:	e9 89 00 00 00       	jmp    f01056e6 <_alltraps>
f010565d:	90                   	nop

f010565e <gpflt_handler>:
TRAPHANDLER(gpflt_handler, T_GPFLT) #13
f010565e:	6a 0d                	push   $0xd
f0105660:	e9 81 00 00 00       	jmp    f01056e6 <_alltraps>
f0105665:	90                   	nop

f0105666 <pgflt_handler>:
TRAPHANDLER(pgflt_handler, T_PGFLT) #14
f0105666:	6a 0e                	push   $0xe
f0105668:	eb 7c                	jmp    f01056e6 <_alltraps>

f010566a <fperr_handler>:
TRAPHANDLER_NOEC(fperr_handler, T_FPERR) #16
f010566a:	6a 00                	push   $0x0
f010566c:	6a 10                	push   $0x10
f010566e:	eb 76                	jmp    f01056e6 <_alltraps>

f0105670 <align_handler>:
TRAPHANDLER(align_handler, T_ALIGN) #17
f0105670:	6a 11                	push   $0x11
f0105672:	eb 72                	jmp    f01056e6 <_alltraps>

f0105674 <mchk_handler>:
TRAPHANDLER_NOEC(mchk_handler, T_MCHK) #18
f0105674:	6a 00                	push   $0x0
f0105676:	6a 12                	push   $0x12
f0105678:	eb 6c                	jmp    f01056e6 <_alltraps>

f010567a <simderr_handler>:
TRAPHANDLER_NOEC(simderr_handler, T_SIMDERR) #19
f010567a:	6a 00                	push   $0x0
f010567c:	6a 13                	push   $0x13
f010567e:	eb 66                	jmp    f01056e6 <_alltraps>

f0105680 <irq0_handler>:

TRAPHANDLER_NOEC(irq0_handler, IRQ_OFFSET)
f0105680:	6a 00                	push   $0x0
f0105682:	6a 20                	push   $0x20
f0105684:	eb 60                	jmp    f01056e6 <_alltraps>

f0105686 <irq1_handler>:
TRAPHANDLER_NOEC(irq1_handler, IRQ_OFFSET+1)
f0105686:	6a 00                	push   $0x0
f0105688:	6a 21                	push   $0x21
f010568a:	eb 5a                	jmp    f01056e6 <_alltraps>

f010568c <irq2_handler>:
TRAPHANDLER_NOEC(irq2_handler, IRQ_OFFSET+2)
f010568c:	6a 00                	push   $0x0
f010568e:	6a 22                	push   $0x22
f0105690:	eb 54                	jmp    f01056e6 <_alltraps>

f0105692 <irq3_handler>:
TRAPHANDLER_NOEC(irq3_handler, IRQ_OFFSET+3)
f0105692:	6a 00                	push   $0x0
f0105694:	6a 23                	push   $0x23
f0105696:	eb 4e                	jmp    f01056e6 <_alltraps>

f0105698 <irq4_handler>:
TRAPHANDLER_NOEC(irq4_handler, IRQ_OFFSET+4)
f0105698:	6a 00                	push   $0x0
f010569a:	6a 24                	push   $0x24
f010569c:	eb 48                	jmp    f01056e6 <_alltraps>

f010569e <irq5_handler>:
TRAPHANDLER_NOEC(irq5_handler, IRQ_OFFSET+5)
f010569e:	6a 00                	push   $0x0
f01056a0:	6a 25                	push   $0x25
f01056a2:	eb 42                	jmp    f01056e6 <_alltraps>

f01056a4 <irq6_handler>:
TRAPHANDLER_NOEC(irq6_handler, IRQ_OFFSET+6)
f01056a4:	6a 00                	push   $0x0
f01056a6:	6a 26                	push   $0x26
f01056a8:	eb 3c                	jmp    f01056e6 <_alltraps>

f01056aa <irq7_handler>:
TRAPHANDLER_NOEC(irq7_handler, IRQ_OFFSET+7)
f01056aa:	6a 00                	push   $0x0
f01056ac:	6a 27                	push   $0x27
f01056ae:	eb 36                	jmp    f01056e6 <_alltraps>

f01056b0 <irq8_handler>:
TRAPHANDLER_NOEC(irq8_handler, IRQ_OFFSET+8)
f01056b0:	6a 00                	push   $0x0
f01056b2:	6a 28                	push   $0x28
f01056b4:	eb 30                	jmp    f01056e6 <_alltraps>

f01056b6 <irq9_handler>:
TRAPHANDLER_NOEC(irq9_handler, IRQ_OFFSET+9)
f01056b6:	6a 00                	push   $0x0
f01056b8:	6a 29                	push   $0x29
f01056ba:	eb 2a                	jmp    f01056e6 <_alltraps>

f01056bc <irq10_handler>:
TRAPHANDLER_NOEC(irq10_handler, IRQ_OFFSET+10)
f01056bc:	6a 00                	push   $0x0
f01056be:	6a 2a                	push   $0x2a
f01056c0:	eb 24                	jmp    f01056e6 <_alltraps>

f01056c2 <irq11_handler>:
TRAPHANDLER_NOEC(irq11_handler, IRQ_OFFSET+11)
f01056c2:	6a 00                	push   $0x0
f01056c4:	6a 2b                	push   $0x2b
f01056c6:	eb 1e                	jmp    f01056e6 <_alltraps>

f01056c8 <irq12_handler>:
TRAPHANDLER_NOEC(irq12_handler, IRQ_OFFSET+12)
f01056c8:	6a 00                	push   $0x0
f01056ca:	6a 2c                	push   $0x2c
f01056cc:	eb 18                	jmp    f01056e6 <_alltraps>

f01056ce <irq13_handler>:
TRAPHANDLER_NOEC(irq13_handler, IRQ_OFFSET+13)
f01056ce:	6a 00                	push   $0x0
f01056d0:	6a 2d                	push   $0x2d
f01056d2:	eb 12                	jmp    f01056e6 <_alltraps>

f01056d4 <irq14_handler>:
TRAPHANDLER_NOEC(irq14_handler, IRQ_OFFSET+14)
f01056d4:	6a 00                	push   $0x0
f01056d6:	6a 2e                	push   $0x2e
f01056d8:	eb 0c                	jmp    f01056e6 <_alltraps>

f01056da <irq15_handler>:
TRAPHANDLER_NOEC(irq15_handler, IRQ_OFFSET+15)
f01056da:	6a 00                	push   $0x0
f01056dc:	6a 2f                	push   $0x2f
f01056de:	eb 06                	jmp    f01056e6 <_alltraps>

f01056e0 <syscall_handler>:


TRAPHANDLER_NOEC(syscall_handler, T_SYSCALL)
f01056e0:	6a 00                	push   $0x0
f01056e2:	6a 30                	push   $0x30
f01056e4:	eb 00                	jmp    f01056e6 <_alltraps>

f01056e6 <_alltraps>:
/*
 * Lab 3: Your code here for _alltraps
 */

 _alltraps:
 	push %ds
f01056e6:	1e                   	push   %ds
 	push %es
f01056e7:	06                   	push   %es
 	pushal   #reference to struct PushRegs in trap.h
f01056e8:	60                   	pusha  
 	mov $GD_KD, %eax
f01056e9:	b8 10 00 00 00       	mov    $0x10,%eax
 	mov %eax, %ds
f01056ee:	8e d8                	mov    %eax,%ds
 	mov %eax, %es
f01056f0:	8e c0                	mov    %eax,%es
 	pushl %esp
f01056f2:	54                   	push   %esp
 	call trap
f01056f3:	e8 87 fc ff ff       	call   f010537f <trap>

f01056f8 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f01056f8:	55                   	push   %ebp
f01056f9:	89 e5                	mov    %esp,%ebp
f01056fb:	83 ec 18             	sub    $0x18,%esp
f01056fe:	8b 15 48 32 2c f0    	mov    0xf02c3248,%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0105704:	b8 00 00 00 00       	mov    $0x0,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f0105709:	8b 4a 54             	mov    0x54(%edx),%ecx
f010570c:	83 e9 01             	sub    $0x1,%ecx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f010570f:	83 f9 02             	cmp    $0x2,%ecx
f0105712:	76 0f                	jbe    f0105723 <sched_halt+0x2b>
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0105714:	83 c0 01             	add    $0x1,%eax
f0105717:	83 c2 7c             	add    $0x7c,%edx
f010571a:	3d 00 04 00 00       	cmp    $0x400,%eax
f010571f:	75 e8                	jne    f0105709 <sched_halt+0x11>
f0105721:	eb 07                	jmp    f010572a <sched_halt+0x32>
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
f0105723:	3d 00 04 00 00       	cmp    $0x400,%eax
f0105728:	75 1a                	jne    f0105744 <sched_halt+0x4c>
		cprintf("No runnable environments in the system!\n");
f010572a:	c7 04 24 30 a0 10 f0 	movl   $0xf010a030,(%esp)
f0105731:	e8 f1 f0 ff ff       	call   f0104827 <cprintf>
		while (1)
			monitor(NULL);
f0105736:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010573d:	e8 3c b5 ff ff       	call   f0100c7e <monitor>
f0105742:	eb f2                	jmp    f0105736 <sched_halt+0x3e>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0105744:	e8 b0 1c 00 00       	call   f01073f9 <cpunum>
f0105749:	6b c0 74             	imul   $0x74,%eax,%eax
f010574c:	c7 80 28 40 2c f0 00 	movl   $0x0,-0xfd3bfd8(%eax)
f0105753:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0105756:	a1 a0 3e 2c f0       	mov    0xf02c3ea0,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010575b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0105760:	77 20                	ja     f0105782 <sched_halt+0x8a>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0105762:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105766:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f010576d:	f0 
f010576e:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
f0105775:	00 
f0105776:	c7 04 24 59 a0 10 f0 	movl   $0xf010a059,(%esp)
f010577d:	e8 1b a9 ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f0105782:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0105787:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f010578a:	e8 6a 1c 00 00       	call   f01073f9 <cpunum>
f010578f:	6b d0 74             	imul   $0x74,%eax,%edx
f0105792:	81 c2 20 40 2c f0    	add    $0xf02c4020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0105798:	b8 02 00 00 00       	mov    $0x2,%eax
f010579d:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f01057a1:	c7 04 24 c0 73 12 f0 	movl   $0xf01273c0,(%esp)
f01057a8:	e8 8b 1f 00 00       	call   f0107738 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f01057ad:	f3 90                	pause  
		"pushl $0\n"
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f01057af:	e8 45 1c 00 00       	call   f01073f9 <cpunum>
f01057b4:	6b c0 74             	imul   $0x74,%eax,%eax

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile (
f01057b7:	8b 80 30 40 2c f0    	mov    -0xfd3bfd0(%eax),%eax
f01057bd:	bd 00 00 00 00       	mov    $0x0,%ebp
f01057c2:	89 c4                	mov    %eax,%esp
f01057c4:	6a 00                	push   $0x0
f01057c6:	6a 00                	push   $0x0
f01057c8:	fb                   	sti    
f01057c9:	f4                   	hlt    
f01057ca:	eb fd                	jmp    f01057c9 <sched_halt+0xd1>
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
}
f01057cc:	c9                   	leave  
f01057cd:	c3                   	ret    

f01057ce <sched_yield>:
void sched_halt(void);

// Choose a user environment to run and run it.
void
sched_yield(void)
{
f01057ce:	55                   	push   %ebp
f01057cf:	89 e5                	mov    %esp,%ebp
f01057d1:	53                   	push   %ebx
f01057d2:	83 ec 14             	sub    $0x14,%esp
	//cprintf("addr of env running on this cpu:%x",thiscpu->cpu_env);
	
	//if previously running any environments then still that env(here idle) will be in running state
	//previously running state env is set to runnable in env_run() when cpu finds new env
	//cprintf("\nentered sched_yield: curenv\n");
	idle = thiscpu->cpu_env;
f01057d5:	e8 1f 1c 00 00       	call   f01073f9 <cpunum>
f01057da:	6b c0 74             	imul   $0x74,%eax,%eax
	if(idle==NULL)
f01057dd:	83 b8 28 40 2c f0 00 	cmpl   $0x0,-0xfd3bfd8(%eax)
f01057e4:	75 2b                	jne    f0105811 <sched_yield+0x43>
f01057e6:	a1 48 32 2c f0       	mov    0xf02c3248,%eax
	{
		//cprintf("\nidle\n");
		for(i=0;i<NENV;i++)
		{
			if(envs[i].env_status == ENV_RUNNABLE)
f01057eb:	ba 00 00 00 00       	mov    $0x0,%edx
f01057f0:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01057f4:	75 08                	jne    f01057fe <sched_yield+0x30>
			{
				env_run(&envs[i]);
f01057f6:	89 04 24             	mov    %eax,(%esp)
f01057f9:	e8 16 ee ff ff       	call   f0104614 <env_run>
	//cprintf("\nentered sched_yield: curenv\n");
	idle = thiscpu->cpu_env;
	if(idle==NULL)
	{
		//cprintf("\nidle\n");
		for(i=0;i<NENV;i++)
f01057fe:	83 c2 01             	add    $0x1,%edx
f0105801:	83 c0 7c             	add    $0x7c,%eax
f0105804:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f010580a:	75 e4                	jne    f01057f0 <sched_yield+0x22>
f010580c:	e9 ab 00 00 00       	jmp    f01058bc <sched_yield+0xee>
		}
	}
	else
	{
		//cprintf("\nnot idle");
		i = (curenv - envs) + 1;
f0105811:	e8 e3 1b 00 00       	call   f01073f9 <cpunum>
f0105816:	6b c0 74             	imul   $0x74,%eax,%eax
f0105819:	8b 98 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%ebx
f010581f:	2b 1d 48 32 2c f0    	sub    0xf02c3248,%ebx
f0105825:	c1 fb 02             	sar    $0x2,%ebx
f0105828:	69 db df 7b ef bd    	imul   $0xbdef7bdf,%ebx,%ebx
f010582e:	83 c3 01             	add    $0x1,%ebx
		stop = (curenv - envs);
f0105831:	e8 c3 1b 00 00       	call   f01073f9 <cpunum>
f0105836:	8b 0d 48 32 2c f0    	mov    0xf02c3248,%ecx
f010583c:	6b c0 74             	imul   $0x74,%eax,%eax
f010583f:	8b 90 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%edx
f0105845:	29 ca                	sub    %ecx,%edx
f0105847:	c1 fa 02             	sar    $0x2,%edx
f010584a:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
		//cprintf("\ncurenv:%p stop:%d\n",curenv, stop);
		while(i!=stop)
f0105850:	eb 28                	jmp    f010587a <sched_yield+0xac>
		{
			
			if(envs[i].env_status == ENV_RUNNABLE)
f0105852:	6b c3 7c             	imul   $0x7c,%ebx,%eax
f0105855:	01 c8                	add    %ecx,%eax
f0105857:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f010585b:	75 08                	jne    f0105865 <sched_yield+0x97>
			{
				//cprintf("\nnew curenv:%p id:%x",&envs[i], (&envs[i])->env_id);
				env_run(&envs[i]);
f010585d:	89 04 24             	mov    %eax,(%esp)
f0105860:	e8 af ed ff ff       	call   f0104614 <env_run>
				//env_run sets curenv i.e thiscpu->cpu_env 
			}
			i++;
f0105865:	83 c3 01             	add    $0x1,%ebx
			i = i % NENV;
f0105868:	89 d8                	mov    %ebx,%eax
f010586a:	c1 f8 1f             	sar    $0x1f,%eax
f010586d:	c1 e8 16             	shr    $0x16,%eax
f0105870:	01 c3                	add    %eax,%ebx
f0105872:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0105878:	29 c3                	sub    %eax,%ebx
	{
		//cprintf("\nnot idle");
		i = (curenv - envs) + 1;
		stop = (curenv - envs);
		//cprintf("\ncurenv:%p stop:%d\n",curenv, stop);
		while(i!=stop)
f010587a:	39 d3                	cmp    %edx,%ebx
f010587c:	75 d4                	jne    f0105852 <sched_yield+0x84>
			i = i % NENV;
			//cprintf("\nblocked in loop:%d",i);
		}
		//if control reaches here that means curenv is the only running environment
		//cprintf("running current env");
		if(curenv->env_status == ENV_RUNNABLE || curenv->env_status == ENV_RUNNING)
f010587e:	e8 76 1b 00 00       	call   f01073f9 <cpunum>
f0105883:	6b c0 74             	imul   $0x74,%eax,%eax
f0105886:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f010588c:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f0105890:	74 14                	je     f01058a6 <sched_yield+0xd8>
f0105892:	e8 62 1b 00 00       	call   f01073f9 <cpunum>
f0105897:	6b c0 74             	imul   $0x74,%eax,%eax
f010589a:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01058a0:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01058a4:	75 16                	jne    f01058bc <sched_yield+0xee>
			env_run(curenv);
f01058a6:	e8 4e 1b 00 00       	call   f01073f9 <cpunum>
f01058ab:	6b c0 74             	imul   $0x74,%eax,%eax
f01058ae:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01058b4:	89 04 24             	mov    %eax,(%esp)
f01058b7:	e8 58 ed ff ff       	call   f0104614 <env_run>
	}
	// sched_halt never returns
	sched_halt();
f01058bc:	e8 37 fe ff ff       	call   f01056f8 <sched_halt>
}
f01058c1:	83 c4 14             	add    $0x14,%esp
f01058c4:	5b                   	pop    %ebx
f01058c5:	5d                   	pop    %ebp
f01058c6:	c3                   	ret    
f01058c7:	66 90                	xchg   %ax,%ax
f01058c9:	66 90                	xchg   %ax,%ax
f01058cb:	66 90                	xchg   %ax,%ax
f01058cd:	66 90                	xchg   %ax,%ax
f01058cf:	90                   	nop

f01058d0 <syscall>:


// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01058d0:	55                   	push   %ebp
f01058d1:	89 e5                	mov    %esp,%ebp
f01058d3:	57                   	push   %edi
f01058d4:	56                   	push   %esi
f01058d5:	53                   	push   %ebx
f01058d6:	83 ec 2c             	sub    $0x2c,%esp
f01058d9:	8b 45 08             	mov    0x8(%ebp),%eax

	//panic("syscall not implemented");
	//cprintf("\nsyscall no:%d",syscallno);
	int ret = -1;

	switch (syscallno) {
f01058dc:	83 f8 14             	cmp    $0x14,%eax
f01058df:	0f 87 3d 08 00 00    	ja     f0106122 <syscall+0x852>
f01058e5:	ff 24 85 44 a1 10 f0 	jmp    *-0xfef5ebc(,%eax,4)
		case SYS_env_destroy:
			return sys_env_destroy(a1);
		case SYS_env_cleanup:
			return sys_env_cleanup(a1);
		case NSYSCALLS:
			return 0;
f01058ec:	b8 00 00 00 00       	mov    $0x0,%eax
f01058f1:	e9 38 08 00 00       	jmp    f010612e <syscall+0x85e>
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.

	user_mem_assert(curenv, s, len, PTE_P|PTE_U);
f01058f6:	e8 fe 1a 00 00       	call   f01073f9 <cpunum>
f01058fb:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f0105902:	00 
f0105903:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105906:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010590a:	8b 7d 0c             	mov    0xc(%ebp),%edi
f010590d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105911:	6b c0 74             	imul   $0x74,%eax,%eax
f0105914:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f010591a:	89 04 24             	mov    %eax,(%esp)
f010591d:	e8 52 e3 ff ff       	call   f0103c74 <user_mem_assert>

	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f0105922:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105925:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105929:	8b 45 10             	mov    0x10(%ebp),%eax
f010592c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105930:	c7 04 24 66 a0 10 f0 	movl   $0xf010a066,(%esp)
f0105937:	e8 eb ee ff ff       	call   f0104827 <cprintf>
	int ret = -1;

	switch (syscallno) {
		case SYS_cputs:
			sys_cputs((char *)a1, a2);
			return 0;
f010593c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105941:	e9 e8 07 00 00       	jmp    f010612e <syscall+0x85e>
// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
f0105946:	e8 b5 ad ff ff       	call   f0100700 <cons_getc>
	switch (syscallno) {
		case SYS_cputs:
			sys_cputs((char *)a1, a2);
			return 0;
		case SYS_cgetc:
			return sys_cgetc();
f010594b:	e9 de 07 00 00       	jmp    f010612e <syscall+0x85e>

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
f0105950:	e8 a4 1a 00 00       	call   f01073f9 <cpunum>
f0105955:	e8 9f 1a 00 00       	call   f01073f9 <cpunum>
f010595a:	6b c0 74             	imul   $0x74,%eax,%eax
f010595d:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105963:	8b 40 48             	mov    0x48(%eax),%eax
		case SYS_cgetc:
			return sys_cgetc();
		case SYS_getenvid:
			a5 = sys_getenvid();
			//cprintf("envid=%d",a5);
			return sys_getenvid();
f0105966:	e9 c3 07 00 00       	jmp    f010612e <syscall+0x85e>
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f010596b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105972:	00 
f0105973:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105976:	89 44 24 04          	mov    %eax,0x4(%esp)
f010597a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010597d:	89 04 24             	mov    %eax,(%esp)
f0105980:	e8 df e3 ff ff       	call   f0103d64 <envid2env>
		return r;
f0105985:	89 c2                	mov    %eax,%edx
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0105987:	85 c0                	test   %eax,%eax
f0105989:	78 6e                	js     f01059f9 <syscall+0x129>
		return r;
	if (e == curenv)
f010598b:	e8 69 1a 00 00       	call   f01073f9 <cpunum>
f0105990:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105993:	6b c0 74             	imul   $0x74,%eax,%eax
f0105996:	39 90 28 40 2c f0    	cmp    %edx,-0xfd3bfd8(%eax)
f010599c:	75 23                	jne    f01059c1 <syscall+0xf1>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f010599e:	e8 56 1a 00 00       	call   f01073f9 <cpunum>
f01059a3:	6b c0 74             	imul   $0x74,%eax,%eax
f01059a6:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01059ac:	8b 40 48             	mov    0x48(%eax),%eax
f01059af:	89 44 24 04          	mov    %eax,0x4(%esp)
f01059b3:	c7 04 24 6b a0 10 f0 	movl   $0xf010a06b,(%esp)
f01059ba:	e8 68 ee ff ff       	call   f0104827 <cprintf>
f01059bf:	eb 28                	jmp    f01059e9 <syscall+0x119>
	else
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01059c1:	8b 5a 48             	mov    0x48(%edx),%ebx
f01059c4:	e8 30 1a 00 00       	call   f01073f9 <cpunum>
f01059c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f01059cd:	6b c0 74             	imul   $0x74,%eax,%eax
f01059d0:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01059d6:	8b 40 48             	mov    0x48(%eax),%eax
f01059d9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01059dd:	c7 04 24 86 a0 10 f0 	movl   $0xf010a086,(%esp)
f01059e4:	e8 3e ee ff ff       	call   f0104827 <cprintf>
	env_destroy(e);
f01059e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01059ec:	89 04 24             	mov    %eax,(%esp)
f01059ef:	e8 71 eb ff ff       	call   f0104565 <env_destroy>
	return 0;
f01059f4:	ba 00 00 00 00       	mov    $0x0,%edx
		case SYS_getenvid:
			a5 = sys_getenvid();
			//cprintf("envid=%d",a5);
			return sys_getenvid();
		case SYS_env_destroy:
			return sys_env_destroy(a1);
f01059f9:	89 d0                	mov    %edx,%eax
f01059fb:	e9 2e 07 00 00       	jmp    f010612e <syscall+0x85e>
sys_env_cleanup(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0105a00:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105a07:	00 
f0105a08:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105a12:	89 04 24             	mov    %eax,(%esp)
f0105a15:	e8 4a e3 ff ff       	call   f0103d64 <envid2env>
f0105a1a:	85 c0                	test   %eax,%eax
f0105a1c:	0f 88 0c 07 00 00    	js     f010612e <syscall+0x85e>
		return r;
	assert(curenv==e);
f0105a22:	e8 d2 19 00 00       	call   f01073f9 <cpunum>
f0105a27:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a2a:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105a30:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f0105a33:	74 24                	je     f0105a59 <syscall+0x189>
f0105a35:	c7 44 24 0c 9e a0 10 	movl   $0xf010a09e,0xc(%esp)
f0105a3c:	f0 
f0105a3d:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0105a44:	f0 
f0105a45:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
f0105a4c:	00 
f0105a4d:	c7 04 24 a8 a0 10 f0 	movl   $0xf010a0a8,(%esp)
f0105a54:	e8 44 a6 ff ff       	call   f010009d <_panic>
	
	cprintf("[%08x] cleaning %08x\n", curenv->env_id, e->env_id);
f0105a59:	8b 58 48             	mov    0x48(%eax),%ebx
f0105a5c:	e8 98 19 00 00       	call   f01073f9 <cpunum>
f0105a61:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0105a65:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a68:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105a6e:	8b 40 48             	mov    0x48(%eax),%eax
f0105a71:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105a75:	c7 04 24 b7 a0 10 f0 	movl   $0xf010a0b7,(%esp)
f0105a7c:	e8 a6 ed ff ff       	call   f0104827 <cprintf>
	env_cleanup(e);
f0105a81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a84:	89 04 24             	mov    %eax,(%esp)
f0105a87:	e8 52 e7 ff ff       	call   f01041de <env_cleanup>
	env_init_trapframe(e);
f0105a8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a8f:	89 04 24             	mov    %eax,(%esp)
f0105a92:	e8 e9 e3 ff ff       	call   f0103e80 <env_init_trapframe>
	return 0;
f0105a97:	b8 00 00 00 00       	mov    $0x0,%eax
f0105a9c:	e9 8d 06 00 00       	jmp    f010612e <syscall+0x85e>

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f0105aa1:	e8 28 fd ff ff       	call   f01057ce <sched_yield>
	// will appear to return 0.

	// LAB 4: Your code here.

	//panic("sys_exofork not implemented");
	struct Env *newEnv = NULL;
f0105aa6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	//cprintf("\nsysexofork\n");
	int status = env_alloc(&newEnv, curenv->env_id);
f0105aad:	e8 47 19 00 00       	call   f01073f9 <cpunum>
f0105ab2:	6b c0 74             	imul   $0x74,%eax,%eax
f0105ab5:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105abb:	8b 40 48             	mov    0x48(%eax),%eax
f0105abe:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105ac2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105ac5:	89 04 24             	mov    %eax,(%esp)
f0105ac8:	e8 06 e4 ff ff       	call   f0103ed3 <env_alloc>
	if(status<0)
f0105acd:	85 c0                	test   %eax,%eax
f0105acf:	0f 88 59 06 00 00    	js     f010612e <syscall+0x85e>
	{
		//error occurred while allocating new environment
		return status;
	}
	else if(newEnv && (status>=0))
f0105ad5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0105ad8:	85 db                	test   %ebx,%ebx
f0105ada:	74 28                	je     f0105b04 <syscall+0x234>
	{
		//successfully allocated newEnvironment
		newEnv->env_status = ENV_NOT_RUNNABLE;
f0105adc:	c7 43 54 04 00 00 00 	movl   $0x4,0x54(%ebx)
		newEnv->env_tf = curenv->env_tf;
f0105ae3:	e8 11 19 00 00       	call   f01073f9 <cpunum>
f0105ae8:	6b c0 74             	imul   $0x74,%eax,%eax
f0105aeb:	8b b0 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%esi
f0105af1:	b9 11 00 00 00       	mov    $0x11,%ecx
f0105af6:	89 df                	mov    %ebx,%edi
f0105af8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		newEnv->env_tf.tf_regs.reg_eax = 0;
f0105afa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105afd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	}
	//what do tweak mean as so sys_exofork will appear to return 0
	//return address of syscall is stored in env->env_tf.eax. So set newEnv->env_tf.eax=0 for 
	return newEnv->env_id;
f0105b04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b07:	8b 40 48             	mov    0x48(%eax),%eax
f0105b0a:	e9 1f 06 00 00       	jmp    f010612e <syscall+0x85e>
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	//panic("sys_env_set_status not implemented");
	struct Env *newEnv = NULL;
f0105b0f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int error=0;
	if(status==ENV_NOT_RUNNABLE || status==ENV_RUNNABLE)
f0105b16:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f0105b1a:	74 06                	je     f0105b22 <syscall+0x252>
f0105b1c:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f0105b20:	75 34                	jne    f0105b56 <syscall+0x286>
	{
		error = envid2env(envid, &newEnv, 1);
f0105b22:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105b29:	00 
f0105b2a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105b31:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105b34:	89 04 24             	mov    %eax,(%esp)
f0105b37:	e8 28 e2 ff ff       	call   f0103d64 <envid2env>
		if((!error) && newEnv)
		{
			newEnv->env_status = status;
			return 0;
		}
		return error;
f0105b3c:	89 c2                	mov    %eax,%edx
	struct Env *newEnv = NULL;
	int error=0;
	if(status==ENV_NOT_RUNNABLE || status==ENV_RUNNABLE)
	{
		error = envid2env(envid, &newEnv, 1);
		if((!error) && newEnv)
f0105b3e:	85 c0                	test   %eax,%eax
f0105b40:	75 20                	jne    f0105b62 <syscall+0x292>
f0105b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b45:	85 c0                	test   %eax,%eax
f0105b47:	74 14                	je     f0105b5d <syscall+0x28d>
		{
			newEnv->env_status = status;
f0105b49:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105b4c:	89 48 54             	mov    %ecx,0x54(%eax)
			return 0;
f0105b4f:	ba 00 00 00 00       	mov    $0x0,%edx
f0105b54:	eb 0c                	jmp    f0105b62 <syscall+0x292>
		}
		return error;

	}
	return -E_INVAL;
f0105b56:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0105b5b:	eb 05                	jmp    f0105b62 <syscall+0x292>
		if((!error) && newEnv)
		{
			newEnv->env_status = status;
			return 0;
		}
		return error;
f0105b5d:	ba 00 00 00 00       	mov    $0x0,%edx
			sys_yield(); 
			return 0;
		case SYS_exofork:
			return sys_exofork();
		case SYS_env_set_status:
			return sys_env_set_status(a1, a2);
f0105b62:	89 d0                	mov    %edx,%eax
f0105b64:	e9 c5 05 00 00       	jmp    f010612e <syscall+0x85e>
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
	//panic("sys_env_set_pgfault_upcall not implemented");
	struct Env *newEnv = NULL;
f0105b69:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int error=-1;
	error = envid2env(envid, &newEnv, 1);
f0105b70:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105b77:	00 
f0105b78:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105b82:	89 04 24             	mov    %eax,(%esp)
f0105b85:	e8 da e1 ff ff       	call   f0103d64 <envid2env>
	{
		newEnv->env_pgfault_upcall = func;
		return 0;
	}
		
	return error;
f0105b8a:	89 c2                	mov    %eax,%edx
	// LAB 4: Your code here.
	//panic("sys_env_set_pgfault_upcall not implemented");
	struct Env *newEnv = NULL;
	int error=-1;
	error = envid2env(envid, &newEnv, 1);
	if((!error) && newEnv)
f0105b8c:	85 c0                	test   %eax,%eax
f0105b8e:	75 19                	jne    f0105ba9 <syscall+0x2d9>
f0105b90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b93:	85 c0                	test   %eax,%eax
f0105b95:	74 0d                	je     f0105ba4 <syscall+0x2d4>
	{
		newEnv->env_pgfault_upcall = func;
f0105b97:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105b9a:	89 78 64             	mov    %edi,0x64(%eax)
		return 0;
f0105b9d:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ba2:	eb 05                	jmp    f0105ba9 <syscall+0x2d9>
	}
		
	return error;
f0105ba4:	ba 00 00 00 00       	mov    $0x0,%edx
		case SYS_exofork:
			return sys_exofork();
		case SYS_env_set_status:
			return sys_env_set_status(a1, a2);
		case SYS_env_set_pgfault_upcall:
			return sys_env_set_pgfault_upcall(a1, (void *)a2);
f0105ba9:	89 d0                	mov    %edx,%eax
f0105bab:	e9 7e 05 00 00       	jmp    f010612e <syscall+0x85e>
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	// LAB 4: Your code here.
	//panic("sys_page_alloc not implemented");
	struct Env *newEnv = NULL;
f0105bb0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	struct PageInfo *newPage = NULL;
	int allowed_perm = PTE_U | PTE_P | PTE_AVAIL | PTE_W;
	int status=0, error=0;
	//cprintf("\npage alloc permissions:%d", perm);
	//cprintf("\nPA:va:%p",(char *)va);
	if(((~allowed_perm) & perm)!=0)
f0105bb7:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105bba:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0105bc0:	75 78                	jne    f0105c3a <syscall+0x36a>
		return -E_INVAL;
	if(((uint32_t)va >= UTOP) || ((uint32_t)va % PGSIZE))
f0105bc2:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105bc9:	77 76                	ja     f0105c41 <syscall+0x371>
f0105bcb:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105bd2:	75 74                	jne    f0105c48 <syscall+0x378>
		return -E_INVAL;
	error = envid2env(envid, &newEnv, 1);
f0105bd4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105bdb:	00 
f0105bdc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105be3:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105be6:	89 04 24             	mov    %eax,(%esp)
f0105be9:	e8 76 e1 ff ff       	call   f0103d64 <envid2env>
	if((!error) && newEnv)
f0105bee:	85 c0                	test   %eax,%eax
f0105bf0:	75 5d                	jne    f0105c4f <syscall+0x37f>
f0105bf2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105bf6:	74 60                	je     f0105c58 <syscall+0x388>
	{
		newPage = page_alloc(ALLOC_ZERO);
f0105bf8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0105bff:	e8 3d b8 ff ff       	call   f0101441 <page_alloc>
f0105c04:	89 c6                	mov    %eax,%esi
		//cprintf("\nnewPage in page alloc:%p",newPage);
		if(!newPage)
f0105c06:	85 c0                	test   %eax,%eax
f0105c08:	74 49                	je     f0105c53 <syscall+0x383>
			return -E_NO_MEM;
		//no need to increment reference of the newPage as insert increments it for us.
		error = page_insert(newEnv->env_pgdir, newPage, va, perm);
f0105c0a:	8b 45 14             	mov    0x14(%ebp),%eax
f0105c0d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105c11:	8b 45 10             	mov    0x10(%ebp),%eax
f0105c14:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105c18:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105c1f:	8b 40 60             	mov    0x60(%eax),%eax
f0105c22:	89 04 24             	mov    %eax,(%esp)
f0105c25:	e8 fe bc ff ff       	call   f0101928 <page_insert>
		if(error)
		{
			page_free(newPage);
			return error;
		}
		return 0;
f0105c2a:	89 c3                	mov    %eax,%ebx
		//cprintf("\nnewPage in page alloc:%p",newPage);
		if(!newPage)
			return -E_NO_MEM;
		//no need to increment reference of the newPage as insert increments it for us.
		error = page_insert(newEnv->env_pgdir, newPage, va, perm);
		if(error)
f0105c2c:	85 c0                	test   %eax,%eax
f0105c2e:	74 28                	je     f0105c58 <syscall+0x388>
		{
			page_free(newPage);
f0105c30:	89 34 24             	mov    %esi,(%esp)
f0105c33:	e8 94 b8 ff ff       	call   f01014cc <page_free>
f0105c38:	eb 1e                	jmp    f0105c58 <syscall+0x388>
	int allowed_perm = PTE_U | PTE_P | PTE_AVAIL | PTE_W;
	int status=0, error=0;
	//cprintf("\npage alloc permissions:%d", perm);
	//cprintf("\nPA:va:%p",(char *)va);
	if(((~allowed_perm) & perm)!=0)
		return -E_INVAL;
f0105c3a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105c3f:	eb 17                	jmp    f0105c58 <syscall+0x388>
	if(((uint32_t)va >= UTOP) || ((uint32_t)va % PGSIZE))
		return -E_INVAL;
f0105c41:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105c46:	eb 10                	jmp    f0105c58 <syscall+0x388>
f0105c48:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105c4d:	eb 09                	jmp    f0105c58 <syscall+0x388>
			page_free(newPage);
			return error;
		}
		return 0;
	}
	return error;
f0105c4f:	89 c3                	mov    %eax,%ebx
f0105c51:	eb 05                	jmp    f0105c58 <syscall+0x388>
	if((!error) && newEnv)
	{
		newPage = page_alloc(ALLOC_ZERO);
		//cprintf("\nnewPage in page alloc:%p",newPage);
		if(!newPage)
			return -E_NO_MEM;
f0105c53:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
		case SYS_env_set_status:
			return sys_env_set_status(a1, a2);
		case SYS_env_set_pgfault_upcall:
			return sys_env_set_pgfault_upcall(a1, (void *)a2);
		case SYS_page_alloc:
			return sys_page_alloc(a1, (void *)a2, a3);
f0105c58:	89 d8                	mov    %ebx,%eax
f0105c5a:	e9 cf 04 00 00       	jmp    f010612e <syscall+0x85e>
	//panic("sys_page_map not implemented");
	//PTE_SYSCALL
	int allowed_perm = PTE_U | PTE_P | PTE_AVAIL | PTE_W;
	int status=0, srcErr=0, dstErr=0, error=0;
	struct PageInfo *reqPage = NULL;
	struct Env *srcEnv = NULL;
f0105c5f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	struct Env *dstEnv = NULL;
f0105c66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	pte_t *entry;
	int isWritable = 0;
	if(((~allowed_perm) & perm)!=0){
f0105c6d:	f7 45 1c f8 f1 ff ff 	testl  $0xfffff1f8,0x1c(%ebp)
f0105c74:	74 16                	je     f0105c8c <syscall+0x3bc>
		cprintf("\npermission mismatch\n");
f0105c76:	c7 04 24 cd a0 10 f0 	movl   $0xf010a0cd,(%esp)
f0105c7d:	e8 a5 eb ff ff       	call   f0104827 <cprintf>
		return -E_INVAL;
f0105c82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105c87:	e9 a2 04 00 00       	jmp    f010612e <syscall+0x85e>
	}
	if(((uint32_t)srcva >= UTOP) || ((uint32_t)srcva % PGSIZE)){
f0105c8c:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105c93:	77 09                	ja     f0105c9e <syscall+0x3ce>
f0105c95:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105c9c:	74 16                	je     f0105cb4 <syscall+0x3e4>
		cprintf("\nsrcva voilated\n");
f0105c9e:	c7 04 24 e3 a0 10 f0 	movl   $0xf010a0e3,(%esp)
f0105ca5:	e8 7d eb ff ff       	call   f0104827 <cprintf>
		return -E_INVAL;
f0105caa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105caf:	e9 7a 04 00 00       	jmp    f010612e <syscall+0x85e>
	}
	if(((uint32_t)dstva >= UTOP) || ((uint32_t)dstva % PGSIZE)){
f0105cb4:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0105cbb:	77 09                	ja     f0105cc6 <syscall+0x3f6>
f0105cbd:	f7 45 18 ff 0f 00 00 	testl  $0xfff,0x18(%ebp)
f0105cc4:	74 16                	je     f0105cdc <syscall+0x40c>
		cprintf("\ndstva violated\n");
f0105cc6:	c7 04 24 f4 a0 10 f0 	movl   $0xf010a0f4,(%esp)
f0105ccd:	e8 55 eb ff ff       	call   f0104827 <cprintf>
		return -E_INVAL;
f0105cd2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105cd7:	e9 52 04 00 00       	jmp    f010612e <syscall+0x85e>
	}
	//cprintf("\nSysmap problem: source ENV:%d\n",srcenvid);
	srcErr = envid2env(srcenvid, &srcEnv, 1);
f0105cdc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105ce3:	00 
f0105ce4:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0105ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105cee:	89 04 24             	mov    %eax,(%esp)
f0105cf1:	e8 6e e0 ff ff       	call   f0103d64 <envid2env>
f0105cf6:	89 c3                	mov    %eax,%ebx
	//Doubt - Can nly parent or sibling is allowed to touch dst env dir
	// or all are allowed? I am assuming that src and dst should have common ancester
	//cprintf("\nSysmap problem: destination ENV:%d\n",dstenvid);
	dstErr = envid2env(dstenvid, &dstEnv, 1);
f0105cf8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105cff:	00 
f0105d00:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105d03:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105d07:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d0a:	89 04 24             	mov    %eax,(%esp)
f0105d0d:	e8 52 e0 ff ff       	call   f0103d64 <envid2env>
	//cprintf("\nsrcerror:%d dsterror:%d srcEnv:%p dstEnv:%p\n",srcErr, dstErr, srcEnv, dstEnv);
	if(((!srcErr) && srcEnv) && ((!dstErr) && dstEnv))
f0105d12:	85 db                	test   %ebx,%ebx
f0105d14:	75 62                	jne    f0105d78 <syscall+0x4a8>
f0105d16:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105d19:	85 d2                	test   %edx,%edx
f0105d1b:	74 65                	je     f0105d82 <syscall+0x4b2>
f0105d1d:	85 c0                	test   %eax,%eax
f0105d1f:	90                   	nop
f0105d20:	75 6a                	jne    f0105d8c <syscall+0x4bc>
f0105d22:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105d26:	74 6e                	je     f0105d96 <syscall+0x4c6>
	{
		reqPage = page_lookup(srcEnv->env_pgdir, srcva, &entry);
f0105d28:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105d2b:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105d2f:	8b 45 10             	mov    0x10(%ebp),%eax
f0105d32:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105d36:	8b 42 60             	mov    0x60(%edx),%eax
f0105d39:	89 04 24             	mov    %eax,(%esp)
f0105d3c:	e8 df ba ff ff       	call   f0101820 <page_lookup>
		//cprintf("\nmap:reqPage:%p\n",reqPage);
		//srcva not mapped in src_env_pgdir
		if(!reqPage){
f0105d41:	85 c0                	test   %eax,%eax
f0105d43:	74 5b                	je     f0105da0 <syscall+0x4d0>
			//cprintf("\n no source mapping");
			return -E_INVAL;
		}
		//cprintf("entry:%p\n",*entry);
		isWritable = *entry & PTE_W;
		if(!isWritable)
f0105d45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105d48:	f6 02 02             	testb  $0x2,(%edx)
f0105d4b:	75 06                	jne    f0105d53 <syscall+0x483>
		{
			if(perm & PTE_W){
f0105d4d:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0105d51:	75 57                	jne    f0105daa <syscall+0x4da>
				//cprintf("\n writing to readable page\n");
				return -E_INVAL;
			}
		}
		//mapping the page to dst environment
		error = page_insert(dstEnv->env_pgdir, reqPage, dstva, perm);
f0105d53:	8b 75 1c             	mov    0x1c(%ebp),%esi
f0105d56:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0105d5a:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105d5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105d61:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105d65:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d68:	8b 40 60             	mov    0x60(%eax),%eax
f0105d6b:	89 04 24             	mov    %eax,(%esp)
f0105d6e:	e8 b5 bb ff ff       	call   f0101928 <page_insert>
f0105d73:	e9 b6 03 00 00       	jmp    f010612e <syscall+0x85e>
		return error;
	}
	return -E_BAD_ENV;
f0105d78:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105d7d:	e9 ac 03 00 00       	jmp    f010612e <syscall+0x85e>
f0105d82:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105d87:	e9 a2 03 00 00       	jmp    f010612e <syscall+0x85e>
f0105d8c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105d91:	e9 98 03 00 00       	jmp    f010612e <syscall+0x85e>
f0105d96:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105d9b:	e9 8e 03 00 00       	jmp    f010612e <syscall+0x85e>
		reqPage = page_lookup(srcEnv->env_pgdir, srcva, &entry);
		//cprintf("\nmap:reqPage:%p\n",reqPage);
		//srcva not mapped in src_env_pgdir
		if(!reqPage){
			//cprintf("\n no source mapping");
			return -E_INVAL;
f0105da0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105da5:	e9 84 03 00 00       	jmp    f010612e <syscall+0x85e>
		isWritable = *entry & PTE_W;
		if(!isWritable)
		{
			if(perm & PTE_W){
				//cprintf("\n writing to readable page\n");
				return -E_INVAL;
f0105daa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		case SYS_env_set_pgfault_upcall:
			return sys_env_set_pgfault_upcall(a1, (void *)a2);
		case SYS_page_alloc:
			return sys_page_alloc(a1, (void *)a2, a3);
		case SYS_page_map:
			return sys_page_map(a1, (void *)a2, a3, (void *)a4, a5);
f0105daf:	e9 7a 03 00 00       	jmp    f010612e <syscall+0x85e>
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
	//panic("sys_page_unmap not implemented");
	int error=0;
	struct Env *newEnv = NULL;
f0105db4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	error = envid2env(envid, &newEnv, 1);
f0105dbb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105dc2:	00 
f0105dc3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105dca:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105dcd:	89 04 24             	mov    %eax,(%esp)
f0105dd0:	e8 8f df ff ff       	call   f0103d64 <envid2env>
	if(error)
		return error;
f0105dd5:	89 c2                	mov    %eax,%edx
	//panic("sys_page_unmap not implemented");
	int error=0;
	struct Env *newEnv = NULL;

	error = envid2env(envid, &newEnv, 1);
	if(error)
f0105dd7:	85 c0                	test   %eax,%eax
f0105dd9:	75 3a                	jne    f0105e15 <syscall+0x545>
		return error;
	if(((uint32_t)va >= UTOP) || ((uint32_t)va % PGSIZE))
f0105ddb:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105de2:	77 25                	ja     f0105e09 <syscall+0x539>
f0105de4:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105deb:	75 23                	jne    f0105e10 <syscall+0x540>
		return -E_INVAL;
	page_remove(newEnv->env_pgdir, va);
f0105ded:	8b 45 10             	mov    0x10(%ebp),%eax
f0105df0:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105df7:	8b 40 60             	mov    0x60(%eax),%eax
f0105dfa:	89 04 24             	mov    %eax,(%esp)
f0105dfd:	e8 cb ba ff ff       	call   f01018cd <page_remove>

	return 0;
f0105e02:	ba 00 00 00 00       	mov    $0x0,%edx
f0105e07:	eb 0c                	jmp    f0105e15 <syscall+0x545>

	error = envid2env(envid, &newEnv, 1);
	if(error)
		return error;
	if(((uint32_t)va >= UTOP) || ((uint32_t)va % PGSIZE))
		return -E_INVAL;
f0105e09:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0105e0e:	eb 05                	jmp    f0105e15 <syscall+0x545>
f0105e10:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
		case SYS_page_alloc:
			return sys_page_alloc(a1, (void *)a2, a3);
		case SYS_page_map:
			return sys_page_map(a1, (void *)a2, a3, (void *)a4, a5);
		case SYS_page_unmap:
			return sys_page_unmap(a1, (void *)a2);
f0105e15:	89 d0                	mov    %edx,%eax
f0105e17:	e9 12 03 00 00       	jmp    f010612e <syscall+0x85e>
{
	// LAB 4: Your code here.
	//panic("sys_ipc_try_send not implemented");
	//cprintf("\nsend syscall.c\n");
	int error=0, page_status=-1;
	struct Env *newEnv = NULL;
f0105e1c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	struct PageInfo *reqPage = NULL;
	pte_t *entry;
	int isWritable = 0;
	int allowed_perm = PTE_U | PTE_P | PTE_AVAIL | PTE_W;
	int set_perm=0;
	error = envid2env(envid, &newEnv, 0);
f0105e23:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0105e2a:	00 
f0105e2b:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105e2e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105e32:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105e35:	89 04 24             	mov    %eax,(%esp)
f0105e38:	e8 27 df ff ff       	call   f0103d64 <envid2env>
f0105e3d:	89 c3                	mov    %eax,%ebx
	//cprintf("\nnewEnv:%p",newEnv);
	
	//error checking and all stuff
	//1. checking if dst envid is genuine
	//cprintf("\nchk1 pass\n");
	if(error || (newEnv==NULL)){
f0105e3f:	85 c0                	test   %eax,%eax
f0105e41:	75 07                	jne    f0105e4a <syscall+0x57a>
f0105e43:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105e46:	85 d2                	test   %edx,%edx
f0105e48:	75 13                	jne    f0105e5d <syscall+0x58d>
		cprintf("\nenvid error\n");
f0105e4a:	c7 04 24 05 a1 10 f0 	movl   $0xf010a105,(%esp)
f0105e51:	e8 d1 e9 ff ff       	call   f0104827 <cprintf>
		return error;
f0105e56:	89 d8                	mov    %ebx,%eax
f0105e58:	e9 d1 02 00 00       	jmp    f010612e <syscall+0x85e>
	}
	//2. checking if receive env is waiting or not
	//cprintf("\nreceiving state:%d",newEnv->env_ipc_recving);

	if(!newEnv->env_ipc_recving){
f0105e5d:	80 7a 68 00          	cmpb   $0x0,0x68(%edx)
f0105e61:	0f 84 08 01 00 00    	je     f0105f6f <syscall+0x69f>
		//cprintf("\nrecv not ready\n");
		return -E_IPC_NOT_RECV;
	}
	//cprintf("\nchk2 pass\n");
	//3. checking alignment of srcva if valid
	if((uintptr_t)srcva < UTOP)
f0105e67:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0105e6e:	0f 87 b7 00 00 00    	ja     f0105f2b <syscall+0x65b>
	{
		//cprintf("\nsrcva less than UTOP\n");
		if((uintptr_t)srcva % PGSIZE)
f0105e74:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f0105e7b:	0f 85 f8 00 00 00    	jne    f0105f79 <syscall+0x6a9>
			return -E_INVAL;	
	}
	//cprintf("\nchk3 pass\n");
	//4. permission check and 5. mapping existence and 6. will be checked in sys_map funtion itself.
	if(((uint32_t)srcva < UTOP) && ((uint32_t)newEnv->env_ipc_dstva < UTOP))
f0105e81:	81 7a 6c ff ff bf ee 	cmpl   $0xeebfffff,0x6c(%edx)
f0105e88:	0f 87 a4 00 00 00    	ja     f0105f32 <syscall+0x662>
	{
		//cprintf("\nmapping pages\n");
		//checking permissions
		if(((~allowed_perm) & perm)!=0){
f0105e8e:	f7 45 18 f8 f1 ff ff 	testl  $0xfffff1f8,0x18(%ebp)
f0105e95:	0f 85 e8 00 00 00    	jne    f0105f83 <syscall+0x6b3>
		//cprintf("\npermission mismatch\n");
		return -E_INVAL;
		}
		reqPage = page_lookup(curenv->env_pgdir, srcva, &entry);
f0105e9b:	e8 59 15 00 00       	call   f01073f9 <cpunum>
f0105ea0:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105ea3:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105ea7:	8b 75 14             	mov    0x14(%ebp),%esi
f0105eaa:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105eae:	6b c0 74             	imul   $0x74,%eax,%eax
f0105eb1:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105eb7:	8b 40 60             	mov    0x60(%eax),%eax
f0105eba:	89 04 24             	mov    %eax,(%esp)
f0105ebd:	e8 5e b9 ff ff       	call   f0101820 <page_lookup>
		//cprintf("\nmap:reqPage:%p",reqPage);
		//srcva not mapped in src_env_pgdir
		if(!reqPage){
f0105ec2:	85 c0                	test   %eax,%eax
f0105ec4:	75 16                	jne    f0105edc <syscall+0x60c>
			cprintf("\n no source mapping\n");
f0105ec6:	c7 04 24 13 a1 10 f0 	movl   $0xf010a113,(%esp)
f0105ecd:	e8 55 e9 ff ff       	call   f0104827 <cprintf>
			return -E_INVAL;
f0105ed2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105ed7:	e9 52 02 00 00       	jmp    f010612e <syscall+0x85e>
		}
		//cprintf("entry:%p",*entry);
		isWritable = *entry & PTE_W;
		if(!isWritable)
f0105edc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105edf:	f6 02 02             	testb  $0x2,(%edx)
f0105ee2:	75 1c                	jne    f0105f00 <syscall+0x630>
		{
			if(perm & PTE_W){
f0105ee4:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105ee8:	74 16                	je     f0105f00 <syscall+0x630>
				cprintf("\n writing to readable page\n");
f0105eea:	c7 04 24 28 a1 10 f0 	movl   $0xf010a128,(%esp)
f0105ef1:	e8 31 e9 ff ff       	call   f0104827 <cprintf>
				return -E_INVAL;
f0105ef6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105efb:	e9 2e 02 00 00       	jmp    f010612e <syscall+0x85e>
			}
		}
		//mapping the page to dst environment
		page_status = page_insert(newEnv->env_pgdir, reqPage, newEnv->env_ipc_dstva, perm);
f0105f00:	8b 5d 18             	mov    0x18(%ebp),%ebx
f0105f03:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105f06:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0105f0a:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0105f0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105f11:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105f15:	8b 42 60             	mov    0x60(%edx),%eax
f0105f18:	89 04 24             	mov    %eax,(%esp)
f0105f1b:	e8 08 ba ff ff       	call   f0101928 <page_insert>
f0105f20:	89 c2                	mov    %eax,%edx
		if(!page_status)
f0105f22:	85 d2                	test   %edx,%edx
f0105f24:	74 11                	je     f0105f37 <syscall+0x667>
f0105f26:	e9 03 02 00 00       	jmp    f010612e <syscall+0x85e>
	struct Env *newEnv = NULL;
	struct PageInfo *reqPage = NULL;
	pte_t *entry;
	int isWritable = 0;
	int allowed_perm = PTE_U | PTE_P | PTE_AVAIL | PTE_W;
	int set_perm=0;
f0105f2b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105f30:	eb 05                	jmp    f0105f37 <syscall+0x667>
f0105f32:	bb 00 00 00 00       	mov    $0x0,%ebx

	//if control reaches here then we can assume that send operation is successful.
	//Main IPC transfer
	//1. Mapping the page if dstva and srcva are valid
	//cprintf("\nsetting the send output\n");
	newEnv->env_ipc_recving = 0;
f0105f37:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105f3a:	c6 46 68 00          	movb   $0x0,0x68(%esi)
	newEnv->env_ipc_from = curenv->env_id;
f0105f3e:	e8 b6 14 00 00       	call   f01073f9 <cpunum>
f0105f43:	6b c0 74             	imul   $0x74,%eax,%eax
f0105f46:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105f4c:	8b 40 48             	mov    0x48(%eax),%eax
f0105f4f:	89 46 74             	mov    %eax,0x74(%esi)
	newEnv->env_ipc_value = value;
f0105f52:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105f55:	8b 75 10             	mov    0x10(%ebp),%esi
f0105f58:	89 70 70             	mov    %esi,0x70(%eax)
	newEnv->env_ipc_perm = set_perm;
f0105f5b:	89 58 78             	mov    %ebx,0x78(%eax)
	newEnv->env_status = ENV_RUNNABLE;
f0105f5e:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	//cprintf("\nsent the data. Receiver should receive\n");
	return 0;
f0105f65:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f6a:	e9 bf 01 00 00       	jmp    f010612e <syscall+0x85e>
	//2. checking if receive env is waiting or not
	//cprintf("\nreceiving state:%d",newEnv->env_ipc_recving);

	if(!newEnv->env_ipc_recving){
		//cprintf("\nrecv not ready\n");
		return -E_IPC_NOT_RECV;
f0105f6f:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
f0105f74:	e9 b5 01 00 00       	jmp    f010612e <syscall+0x85e>
	//3. checking alignment of srcva if valid
	if((uintptr_t)srcva < UTOP)
	{
		//cprintf("\nsrcva less than UTOP\n");
		if((uintptr_t)srcva % PGSIZE)
			return -E_INVAL;	
f0105f79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105f7e:	e9 ab 01 00 00       	jmp    f010612e <syscall+0x85e>
	{
		//cprintf("\nmapping pages\n");
		//checking permissions
		if(((~allowed_perm) & perm)!=0){
		//cprintf("\npermission mismatch\n");
		return -E_INVAL;
f0105f83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		case SYS_page_map:
			return sys_page_map(a1, (void *)a2, a3, (void *)a4, a5);
		case SYS_page_unmap:
			return sys_page_unmap(a1, (void *)a2);
		case SYS_ipc_try_send:
			return sys_ipc_try_send(a1, a2, (void *)a3, a4);
f0105f88:	e9 a1 01 00 00       	jmp    f010612e <syscall+0x85e>
{
	// LAB 4: Your code here.

	//panic("sys_ipc_recv not implemented");
	
	if((uintptr_t)dstva < UTOP)
f0105f8d:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105f94:	77 0d                	ja     f0105fa3 <syscall+0x6d3>
	{
		if((uintptr_t)dstva % PGSIZE)
f0105f96:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0105f9d:	0f 85 86 01 00 00    	jne    f0106129 <syscall+0x859>
			return -E_INVAL;	
	}
	curenv->env_ipc_recving = 1;
f0105fa3:	e8 51 14 00 00       	call   f01073f9 <cpunum>
f0105fa8:	6b c0 74             	imul   $0x74,%eax,%eax
f0105fab:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105fb1:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f0105fb5:	e8 3f 14 00 00       	call   f01073f9 <cpunum>
f0105fba:	6b c0 74             	imul   $0x74,%eax,%eax
f0105fbd:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105fc3:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105fc6:	89 78 6c             	mov    %edi,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105fc9:	e8 2b 14 00 00       	call   f01073f9 <cpunum>
f0105fce:	6b c0 74             	imul   $0x74,%eax,%eax
f0105fd1:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105fd7:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	curenv->env_tf.tf_regs.reg_eax = 0;
f0105fde:	e8 16 14 00 00       	call   f01073f9 <cpunum>
f0105fe3:	6b c0 74             	imul   $0x74,%eax,%eax
f0105fe6:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0105fec:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f0105ff3:	e8 d6 f7 ff ff       	call   f01057ce <sched_yield>
static int
sys_share_pages(envid_t dstid)
{
	int error=0;
	int i=0;
	struct Env *dstEnv = NULL;
f0105ff8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	error = envid2env(dstid, &dstEnv, 1);
f0105fff:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0106006:	00 
f0106007:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010600a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010600e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106011:	89 04 24             	mov    %eax,(%esp)
f0106014:	e8 4b dd ff ff       	call   f0103d64 <envid2env>
	if(error || (dstEnv==NULL))
		return error;
f0106019:	89 c2                	mov    %eax,%edx
{
	int error=0;
	int i=0;
	struct Env *dstEnv = NULL;
	error = envid2env(dstid, &dstEnv, 1);
	if(error || (dstEnv==NULL))
f010601b:	85 c0                	test   %eax,%eax
f010601d:	75 3b                	jne    f010605a <syscall+0x78a>
		return error;
f010601f:	ba 00 00 00 00       	mov    $0x0,%edx
{
	int error=0;
	int i=0;
	struct Env *dstEnv = NULL;
	error = envid2env(dstid, &dstEnv, 1);
	if(error || (dstEnv==NULL))
f0106024:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0106028:	74 30                	je     f010605a <syscall+0x78a>
		return error;
	//now copy complete source pgdir from USTACKTOP-1 to 0 into dest pgdir
	memcpy(dstEnv->env_pgdir, curenv->env_pgdir, (sizeof(pde_t) * (PDX(USTACKTOP) -1)));
f010602a:	e8 ca 13 00 00       	call   f01073f9 <cpunum>
f010602f:	c7 44 24 08 e4 0e 00 	movl   $0xee4,0x8(%esp)
f0106036:	00 
f0106037:	6b c0 74             	imul   $0x74,%eax,%eax
f010603a:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0106040:	8b 40 60             	mov    0x60(%eax),%eax
f0106043:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106047:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010604a:	8b 40 60             	mov    0x60(%eax),%eax
f010604d:	89 04 24             	mov    %eax,(%esp)
f0106050:	e8 07 0e 00 00       	call   f0106e5c <memcpy>
	//cprintf("\nsource pgdir:\n");
	/*for(i=900;i<961;i++)
	{
		cprintf("\n%d: %d<--->%d",i,curenv->env_pgdir[i], dstEnv->env_pgdir[i]);
	}*/
	return 0;
f0106055:	ba 00 00 00 00       	mov    $0x0,%edx
		case SYS_ipc_try_send:
			return sys_ipc_try_send(a1, a2, (void *)a3, a4);
		case SYS_ipc_recv:
			return sys_ipc_recv((void *)a1);
		case SYS_share_pages:
			return sys_share_pages(a1);
f010605a:	89 d0                	mov    %edx,%eax
f010605c:	e9 cd 00 00 00       	jmp    f010612e <syscall+0x85e>
{
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	//panic("sys_env_set_trapframe not implemented");
	struct Env *newEnv = NULL;
f0106061:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int error= -E_BAD_ENV;
	error = envid2env(envid, &newEnv, 1);
f0106068:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010606f:	00 
f0106070:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0106073:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106077:	8b 45 0c             	mov    0xc(%ebp),%eax
f010607a:	89 04 24             	mov    %eax,(%esp)
f010607d:	e8 e2 dc ff ff       	call   f0103d64 <envid2env>
	{
		newEnv->env_tf = *tf;
		newEnv->env_tf.tf_eflags |= FL_IF;
		return 0;
	}
	return error;
f0106082:	89 c2                	mov    %eax,%edx
	// address!
	//panic("sys_env_set_trapframe not implemented");
	struct Env *newEnv = NULL;
	int error= -E_BAD_ENV;
	error = envid2env(envid, &newEnv, 1);
	if((!error) && newEnv)
f0106084:	85 c0                	test   %eax,%eax
f0106086:	75 29                	jne    f01060b1 <syscall+0x7e1>
f0106088:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010608b:	85 c0                	test   %eax,%eax
f010608d:	74 1d                	je     f01060ac <syscall+0x7dc>
	{
		newEnv->env_tf = *tf;
f010608f:	b9 11 00 00 00       	mov    $0x11,%ecx
f0106094:	89 c7                	mov    %eax,%edi
f0106096:	8b 75 10             	mov    0x10(%ebp),%esi
f0106099:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		newEnv->env_tf.tf_eflags |= FL_IF;
f010609b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010609e:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
		return 0;
f01060a5:	ba 00 00 00 00       	mov    $0x0,%edx
f01060aa:	eb 05                	jmp    f01060b1 <syscall+0x7e1>
	}
	return error;
f01060ac:	ba 00 00 00 00       	mov    $0x0,%edx
		case SYS_ipc_recv:
			return sys_ipc_recv((void *)a1);
		case SYS_share_pages:
			return sys_share_pages(a1);
		case SYS_env_set_trapframe:
			return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
f01060b1:	89 d0                	mov    %edx,%eax
f01060b3:	eb 79                	jmp    f010612e <syscall+0x85e>
// Return the current time.
static int
sys_time_msec(void)
{
	// LAB 6: Your code here.
	return time_msec();
f01060b5:	e8 bb 22 00 00       	call   f0108375 <time_msec>
		case SYS_share_pages:
			return sys_share_pages(a1);
		case SYS_env_set_trapframe:
			return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
		case SYS_time_msec:
			return sys_time_msec();
f01060ba:	eb 72                	jmp    f010612e <syscall+0x85e>
	return time_msec();
}

static int sys_tx_packet(const char *data, size_t len)
{
	user_mem_assert(curenv, data, len, PTE_P|PTE_U);
f01060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01060c0:	e8 34 13 00 00       	call   f01073f9 <cpunum>
f01060c5:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f01060cc:	00 
f01060cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01060d0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01060d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01060d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01060db:	6b c0 74             	imul   $0x74,%eax,%eax
f01060de:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01060e4:	89 04 24             	mov    %eax,(%esp)
f01060e7:	e8 88 db ff ff       	call   f0103c74 <user_mem_assert>

	// Print the string supplied by the user.
	return tx_packet(data, len);
f01060ec:	8b 45 10             	mov    0x10(%ebp),%eax
f01060ef:	89 44 24 04          	mov    %eax,0x4(%esp)
f01060f3:	8b 45 0c             	mov    0xc(%ebp),%eax
f01060f6:	89 04 24             	mov    %eax,(%esp)
f01060f9:	e8 ce 1a 00 00       	call   f0107bcc <tx_packet>
		case SYS_env_set_trapframe:
			return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
		case SYS_time_msec:
			return sys_time_msec();
		case SYS_tx_packet:
			return sys_tx_packet((char *)a1, a2);
f01060fe:	eb 2e                	jmp    f010612e <syscall+0x85e>

static int sys_rx_packet(void *buf, int *len)
{
	//user_mem_assert(curenv, data, len, PTE_P|PTE_U);

	return rx_packet(buf, len);
f0106100:	8b 45 10             	mov    0x10(%ebp),%eax
f0106103:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106107:	8b 45 0c             	mov    0xc(%ebp),%eax
f010610a:	89 04 24             	mov    %eax,(%esp)
f010610d:	e8 43 1b 00 00       	call   f0107c55 <rx_packet>
		case SYS_time_msec:
			return sys_time_msec();
		case SYS_tx_packet:
			return sys_tx_packet((char *)a1, a2);
		case SYS_rx_packet:
			return sys_rx_packet((void *)a1, (int *)a2);
f0106112:	eb 1a                	jmp    f010612e <syscall+0x85e>
	return rx_packet(buf, len);
}

static int sys_read_mac(uint8_t *data)
{
	return get_mac(data);
f0106114:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106117:	89 04 24             	mov    %eax,(%esp)
f010611a:	e8 2e 17 00 00       	call   f010784d <get_mac>
		case SYS_tx_packet:
			return sys_tx_packet((char *)a1, a2);
		case SYS_rx_packet:
			return sys_rx_packet((void *)a1, (int *)a2);
		case SYS_read_mac:
			return sys_read_mac((uint8_t *)a1);
f010611f:	90                   	nop
f0106120:	eb 0c                	jmp    f010612e <syscall+0x85e>
		default:
			return -E_INVAL;
f0106122:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0106127:	eb 05                	jmp    f010612e <syscall+0x85e>
		case SYS_page_unmap:
			return sys_page_unmap(a1, (void *)a2);
		case SYS_ipc_try_send:
			return sys_ipc_try_send(a1, a2, (void *)a3, a4);
		case SYS_ipc_recv:
			return sys_ipc_recv((void *)a1);
f0106129:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		case SYS_read_mac:
			return sys_read_mac((uint8_t *)a1);
		default:
			return -E_INVAL;
	}
}
f010612e:	83 c4 2c             	add    $0x2c,%esp
f0106131:	5b                   	pop    %ebx
f0106132:	5e                   	pop    %esi
f0106133:	5f                   	pop    %edi
f0106134:	5d                   	pop    %ebp
f0106135:	c3                   	ret    

f0106136 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0106136:	55                   	push   %ebp
f0106137:	89 e5                	mov    %esp,%ebp
f0106139:	57                   	push   %edi
f010613a:	56                   	push   %esi
f010613b:	53                   	push   %ebx
f010613c:	83 ec 10             	sub    $0x10,%esp
f010613f:	89 c6                	mov    %eax,%esi
f0106141:	89 55 e8             	mov    %edx,-0x18(%ebp)
f0106144:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0106147:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f010614a:	8b 1a                	mov    (%edx),%ebx
f010614c:	8b 01                	mov    (%ecx),%eax
f010614e:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0106151:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

	while (l <= r) {
f0106158:	eb 77                	jmp    f01061d1 <stab_binsearch+0x9b>
		int true_m = (l + r) / 2, m = true_m;
f010615a:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010615d:	01 d8                	add    %ebx,%eax
f010615f:	b9 02 00 00 00       	mov    $0x2,%ecx
f0106164:	99                   	cltd   
f0106165:	f7 f9                	idiv   %ecx
f0106167:	89 c1                	mov    %eax,%ecx

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0106169:	eb 01                	jmp    f010616c <stab_binsearch+0x36>
			m--;
f010616b:	49                   	dec    %ecx

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f010616c:	39 d9                	cmp    %ebx,%ecx
f010616e:	7c 1d                	jl     f010618d <stab_binsearch+0x57>
f0106170:	6b d1 0c             	imul   $0xc,%ecx,%edx
f0106173:	0f b6 54 16 04       	movzbl 0x4(%esi,%edx,1),%edx
f0106178:	39 fa                	cmp    %edi,%edx
f010617a:	75 ef                	jne    f010616b <stab_binsearch+0x35>
f010617c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f010617f:	6b d1 0c             	imul   $0xc,%ecx,%edx
f0106182:	8b 54 16 08          	mov    0x8(%esi,%edx,1),%edx
f0106186:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0106189:	73 18                	jae    f01061a3 <stab_binsearch+0x6d>
f010618b:	eb 05                	jmp    f0106192 <stab_binsearch+0x5c>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f010618d:	8d 58 01             	lea    0x1(%eax),%ebx
			continue;
f0106190:	eb 3f                	jmp    f01061d1 <stab_binsearch+0x9b>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0106192:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0106195:	89 0b                	mov    %ecx,(%ebx)
			l = true_m + 1;
f0106197:	8d 58 01             	lea    0x1(%eax),%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f010619a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
f01061a1:	eb 2e                	jmp    f01061d1 <stab_binsearch+0x9b>
		if (stabs[m].n_value < addr) {
			*region_left = m;
			l = true_m + 1;
		} else if (stabs[m].n_value > addr) {
f01061a3:	39 55 0c             	cmp    %edx,0xc(%ebp)
f01061a6:	73 15                	jae    f01061bd <stab_binsearch+0x87>
			*region_right = m - 1;
f01061a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01061ab:	48                   	dec    %eax
f01061ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01061af:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01061b2:	89 01                	mov    %eax,(%ecx)
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f01061b4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
f01061bb:	eb 14                	jmp    f01061d1 <stab_binsearch+0x9b>
			*region_right = m - 1;
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f01061bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01061c0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
f01061c3:	89 18                	mov    %ebx,(%eax)
			l = m;
			addr++;
f01061c5:	ff 45 0c             	incl   0xc(%ebp)
f01061c8:	89 cb                	mov    %ecx,%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f01061ca:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
f01061d1:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f01061d4:	7e 84                	jle    f010615a <stab_binsearch+0x24>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f01061d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f01061da:	75 0d                	jne    f01061e9 <stab_binsearch+0xb3>
		*region_right = *region_left - 1;
f01061dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01061df:	8b 00                	mov    (%eax),%eax
f01061e1:	48                   	dec    %eax
f01061e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01061e5:	89 07                	mov    %eax,(%edi)
f01061e7:	eb 22                	jmp    f010620b <stab_binsearch+0xd5>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01061e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01061ec:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f01061ee:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f01061f1:	8b 0b                	mov    (%ebx),%ecx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01061f3:	eb 01                	jmp    f01061f6 <stab_binsearch+0xc0>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
f01061f5:	48                   	dec    %eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01061f6:	39 c1                	cmp    %eax,%ecx
f01061f8:	7d 0c                	jge    f0106206 <stab_binsearch+0xd0>
f01061fa:	6b d0 0c             	imul   $0xc,%eax,%edx
		     l > *region_left && stabs[l].n_type != type;
f01061fd:	0f b6 54 16 04       	movzbl 0x4(%esi,%edx,1),%edx
f0106202:	39 fa                	cmp    %edi,%edx
f0106204:	75 ef                	jne    f01061f5 <stab_binsearch+0xbf>
		     l--)
			/* do nothing */;
		*region_left = l;
f0106206:	8b 7d e8             	mov    -0x18(%ebp),%edi
f0106209:	89 07                	mov    %eax,(%edi)
	}
}
f010620b:	83 c4 10             	add    $0x10,%esp
f010620e:	5b                   	pop    %ebx
f010620f:	5e                   	pop    %esi
f0106210:	5f                   	pop    %edi
f0106211:	5d                   	pop    %ebp
f0106212:	c3                   	ret    

f0106213 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0106213:	55                   	push   %ebp
f0106214:	89 e5                	mov    %esp,%ebp
f0106216:	57                   	push   %edi
f0106217:	56                   	push   %esi
f0106218:	53                   	push   %ebx
f0106219:	83 ec 4c             	sub    $0x4c,%esp
f010621c:	8b 75 08             	mov    0x8(%ebp),%esi
f010621f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0106222:	c7 03 98 a1 10 f0    	movl   $0xf010a198,(%ebx)
	info->eip_line = 0;
f0106228:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f010622f:	c7 43 08 98 a1 10 f0 	movl   $0xf010a198,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0106236:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f010623d:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0106240:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0106247:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f010624d:	76 15                	jbe    f0106264 <debuginfo_eip+0x51>
			return -1;
  	    panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f010624f:	b8 8a cc 11 f0       	mov    $0xf011cc8a,%eax
f0106254:	3d 15 7c 11 f0       	cmp    $0xf0117c15,%eax
f0106259:	0f 86 7d 02 00 00    	jbe    f01064dc <debuginfo_eip+0x2c9>
f010625f:	e9 cc 00 00 00       	jmp    f0106330 <debuginfo_eip+0x11d>

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.

		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_P|PTE_U)<0)
f0106264:	e8 90 11 00 00       	call   f01073f9 <cpunum>
f0106269:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f0106270:	00 
f0106271:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0106278:	00 
f0106279:	c7 44 24 04 00 00 20 	movl   $0x200000,0x4(%esp)
f0106280:	00 
f0106281:	6b c0 74             	imul   $0x74,%eax,%eax
f0106284:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f010628a:	89 04 24             	mov    %eax,(%esp)
f010628d:	e8 9a d8 ff ff       	call   f0103b2c <user_mem_check>
f0106292:	85 c0                	test   %eax,%eax
f0106294:	0f 88 49 02 00 00    	js     f01064e3 <debuginfo_eip+0x2d0>
			return -1;

		stabs = usd->stabs;
f010629a:	8b 1d 00 00 20 00    	mov    0x200000,%ebx
		stab_end = usd->stab_end;
		stabstr = usd->stabstr;
f01062a0:	8b 35 08 00 20 00    	mov    0x200008,%esi

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.

		// Can't search for user-level addresses yet!
		if(user_mem_check(curenv, stabs, sizeof(struct Stab), PTE_P|PTE_U)<0)
f01062a6:	e8 4e 11 00 00       	call   f01073f9 <cpunum>
f01062ab:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f01062b2:	00 
f01062b3:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
f01062ba:	00 
f01062bb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01062bf:	6b c0 74             	imul   $0x74,%eax,%eax
f01062c2:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f01062c8:	89 04 24             	mov    %eax,(%esp)
f01062cb:	e8 5c d8 ff ff       	call   f0103b2c <user_mem_check>
f01062d0:	85 c0                	test   %eax,%eax
f01062d2:	0f 88 12 02 00 00    	js     f01064ea <debuginfo_eip+0x2d7>
			return -1;
		if(user_mem_check(curenv, usd, strlen(stabstr), PTE_P|PTE_U)<0)
f01062d8:	89 34 24             	mov    %esi,(%esp)
f01062db:	e8 40 09 00 00       	call   f0106c20 <strlen>
f01062e0:	89 c3                	mov    %eax,%ebx
f01062e2:	e8 12 11 00 00       	call   f01073f9 <cpunum>
f01062e7:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f01062ee:	00 
f01062ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f01062f3:	c7 44 24 04 00 00 20 	movl   $0x200000,0x4(%esp)
f01062fa:	00 
f01062fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01062fe:	8b 80 28 40 2c f0    	mov    -0xfd3bfd8(%eax),%eax
f0106304:	89 04 24             	mov    %eax,(%esp)
f0106307:	e8 20 d8 ff ff       	call   f0103b2c <user_mem_check>
f010630c:	85 c0                	test   %eax,%eax
f010630e:	0f 88 dd 01 00 00    	js     f01064f1 <debuginfo_eip+0x2de>
			return -1;
  	    panic("User address");
f0106314:	c7 44 24 08 a2 a1 10 	movl   $0xf010a1a2,0x8(%esp)
f010631b:	f0 
f010631c:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
f0106323:	00 
f0106324:	c7 04 24 af a1 10 f0 	movl   $0xf010a1af,(%esp)
f010632b:	e8 6d 9d ff ff       	call   f010009d <_panic>
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0106330:	80 3d 89 cc 11 f0 00 	cmpb   $0x0,0xf011cc89
f0106337:	0f 85 bb 01 00 00    	jne    f01064f8 <debuginfo_eip+0x2e5>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f010633d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0106344:	b8 14 7c 11 f0       	mov    $0xf0117c14,%eax
f0106349:	2d fc a9 10 f0       	sub    $0xf010a9fc,%eax
f010634e:	c1 f8 02             	sar    $0x2,%eax
f0106351:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0106357:	83 e8 01             	sub    $0x1,%eax
f010635a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f010635d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0106361:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0106368:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f010636b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010636e:	b8 fc a9 10 f0       	mov    $0xf010a9fc,%eax
f0106373:	e8 be fd ff ff       	call   f0106136 <stab_binsearch>
	if (lfile == 0)
f0106378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010637b:	85 c0                	test   %eax,%eax
f010637d:	0f 84 7c 01 00 00    	je     f01064ff <debuginfo_eip+0x2ec>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0106383:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0106386:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106389:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f010638c:	89 74 24 04          	mov    %esi,0x4(%esp)
f0106390:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0106397:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f010639a:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010639d:	b8 fc a9 10 f0       	mov    $0xf010a9fc,%eax
f01063a2:	e8 8f fd ff ff       	call   f0106136 <stab_binsearch>

	if (lfun <= rfun) {
f01063a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01063aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01063ad:	39 d0                	cmp    %edx,%eax
f01063af:	7f 3d                	jg     f01063ee <debuginfo_eip+0x1db>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f01063b1:	6b c8 0c             	imul   $0xc,%eax,%ecx
f01063b4:	8d b9 fc a9 10 f0    	lea    -0xfef5604(%ecx),%edi
f01063ba:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f01063bd:	8b 89 fc a9 10 f0    	mov    -0xfef5604(%ecx),%ecx
f01063c3:	bf 8a cc 11 f0       	mov    $0xf011cc8a,%edi
f01063c8:	81 ef 15 7c 11 f0    	sub    $0xf0117c15,%edi
f01063ce:	39 f9                	cmp    %edi,%ecx
f01063d0:	73 09                	jae    f01063db <debuginfo_eip+0x1c8>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f01063d2:	81 c1 15 7c 11 f0    	add    $0xf0117c15,%ecx
f01063d8:	89 4b 08             	mov    %ecx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f01063db:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f01063de:	8b 4f 08             	mov    0x8(%edi),%ecx
f01063e1:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f01063e4:	29 ce                	sub    %ecx,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f01063e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f01063e9:	89 55 d0             	mov    %edx,-0x30(%ebp)
f01063ec:	eb 0f                	jmp    f01063fd <debuginfo_eip+0x1ea>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f01063ee:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f01063f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01063f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f01063f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01063fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f01063fd:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0106404:	00 
f0106405:	8b 43 08             	mov    0x8(%ebx),%eax
f0106408:	89 04 24             	mov    %eax,(%esp)
f010640b:	e8 7b 09 00 00       	call   f0106d8b <strfind>
f0106410:	2b 43 08             	sub    0x8(%ebx),%eax
f0106413:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);	
f0106416:	89 74 24 04          	mov    %esi,0x4(%esp)
f010641a:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f0106421:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0106424:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0106427:	b8 fc a9 10 f0       	mov    $0xf010a9fc,%eax
f010642c:	e8 05 fd ff ff       	call   f0106136 <stab_binsearch>
	if(lline<=rline)
f0106431:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106434:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0106437:	0f 8f c9 00 00 00    	jg     f0106506 <debuginfo_eip+0x2f3>
		info->eip_line = stabs[rline].n_desc;
f010643d:	6b c0 0c             	imul   $0xc,%eax,%eax
f0106440:	0f b7 80 02 aa 10 f0 	movzwl -0xfef55fe(%eax),%eax
f0106447:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f010644a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010644d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0106450:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0106453:	6b d0 0c             	imul   $0xc,%eax,%edx
f0106456:	81 c2 fc a9 10 f0    	add    $0xf010a9fc,%edx
f010645c:	eb 06                	jmp    f0106464 <debuginfo_eip+0x251>
f010645e:	83 e8 01             	sub    $0x1,%eax
f0106461:	83 ea 0c             	sub    $0xc,%edx
f0106464:	89 c6                	mov    %eax,%esi
f0106466:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
f0106469:	7f 33                	jg     f010649e <debuginfo_eip+0x28b>
	       && stabs[lline].n_type != N_SOL
f010646b:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f010646f:	80 f9 84             	cmp    $0x84,%cl
f0106472:	74 0b                	je     f010647f <debuginfo_eip+0x26c>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0106474:	80 f9 64             	cmp    $0x64,%cl
f0106477:	75 e5                	jne    f010645e <debuginfo_eip+0x24b>
f0106479:	83 7a 08 00          	cmpl   $0x0,0x8(%edx)
f010647d:	74 df                	je     f010645e <debuginfo_eip+0x24b>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f010647f:	6b f6 0c             	imul   $0xc,%esi,%esi
f0106482:	8b 86 fc a9 10 f0    	mov    -0xfef5604(%esi),%eax
f0106488:	ba 8a cc 11 f0       	mov    $0xf011cc8a,%edx
f010648d:	81 ea 15 7c 11 f0    	sub    $0xf0117c15,%edx
f0106493:	39 d0                	cmp    %edx,%eax
f0106495:	73 07                	jae    f010649e <debuginfo_eip+0x28b>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0106497:	05 15 7c 11 f0       	add    $0xf0117c15,%eax
f010649c:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f010649e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01064a1:	8b 4d d8             	mov    -0x28(%ebp),%ecx
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f01064a4:	b8 00 00 00 00       	mov    $0x0,%eax
		info->eip_file = stabstr + stabs[lline].n_strx;


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f01064a9:	39 ca                	cmp    %ecx,%edx
f01064ab:	7d 65                	jge    f0106512 <debuginfo_eip+0x2ff>
		for (lline = lfun + 1;
f01064ad:	8d 42 01             	lea    0x1(%edx),%eax
f01064b0:	89 c2                	mov    %eax,%edx
f01064b2:	6b c0 0c             	imul   $0xc,%eax,%eax
f01064b5:	05 fc a9 10 f0       	add    $0xf010a9fc,%eax
f01064ba:	89 ce                	mov    %ecx,%esi
f01064bc:	eb 04                	jmp    f01064c2 <debuginfo_eip+0x2af>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f01064be:	83 43 14 01          	addl   $0x1,0x14(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f01064c2:	39 d6                	cmp    %edx,%esi
f01064c4:	7e 47                	jle    f010650d <debuginfo_eip+0x2fa>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01064c6:	0f b6 48 04          	movzbl 0x4(%eax),%ecx
f01064ca:	83 c2 01             	add    $0x1,%edx
f01064cd:	83 c0 0c             	add    $0xc,%eax
f01064d0:	80 f9 a0             	cmp    $0xa0,%cl
f01064d3:	74 e9                	je     f01064be <debuginfo_eip+0x2ab>
		     lline++)
			info->eip_fn_narg++;

	return 0;
f01064d5:	b8 00 00 00 00       	mov    $0x0,%eax
f01064da:	eb 36                	jmp    f0106512 <debuginfo_eip+0x2ff>
  	    panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
		return -1;
f01064dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01064e1:	eb 2f                	jmp    f0106512 <debuginfo_eip+0x2ff>
		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.

		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_P|PTE_U)<0)
			return -1;
f01064e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01064e8:	eb 28                	jmp    f0106512 <debuginfo_eip+0x2ff>
		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.

		// Can't search for user-level addresses yet!
		if(user_mem_check(curenv, stabs, sizeof(struct Stab), PTE_P|PTE_U)<0)
			return -1;
f01064ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01064ef:	eb 21                	jmp    f0106512 <debuginfo_eip+0x2ff>
		if(user_mem_check(curenv, usd, strlen(stabstr), PTE_P|PTE_U)<0)
			return -1;
f01064f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01064f6:	eb 1a                	jmp    f0106512 <debuginfo_eip+0x2ff>
  	    panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
		return -1;
f01064f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01064fd:	eb 13                	jmp    f0106512 <debuginfo_eip+0x2ff>
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
	rfile = (stab_end - stabs) - 1;
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
	if (lfile == 0)
		return -1;
f01064ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0106504:	eb 0c                	jmp    f0106512 <debuginfo_eip+0x2ff>

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);	
	if(lline<=rline)
		info->eip_line = stabs[rline].n_desc;
	else
		return -1;
f0106506:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010650b:	eb 05                	jmp    f0106512 <debuginfo_eip+0x2ff>
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f010650d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106512:	83 c4 4c             	add    $0x4c,%esp
f0106515:	5b                   	pop    %ebx
f0106516:	5e                   	pop    %esi
f0106517:	5f                   	pop    %edi
f0106518:	5d                   	pop    %ebp
f0106519:	c3                   	ret    
f010651a:	66 90                	xchg   %ax,%ax
f010651c:	66 90                	xchg   %ax,%ax
f010651e:	66 90                	xchg   %ax,%ax

f0106520 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0106520:	55                   	push   %ebp
f0106521:	89 e5                	mov    %esp,%ebp
f0106523:	57                   	push   %edi
f0106524:	56                   	push   %esi
f0106525:	53                   	push   %ebx
f0106526:	83 ec 3c             	sub    $0x3c,%esp
f0106529:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010652c:	89 d7                	mov    %edx,%edi
f010652e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106531:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0106534:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106537:	89 c3                	mov    %eax,%ebx
f0106539:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010653c:	8b 45 10             	mov    0x10(%ebp),%eax
f010653f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0106542:	b9 00 00 00 00       	mov    $0x0,%ecx
f0106547:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010654a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010654d:	39 d9                	cmp    %ebx,%ecx
f010654f:	72 05                	jb     f0106556 <printnum+0x36>
f0106551:	3b 45 e0             	cmp    -0x20(%ebp),%eax
f0106554:	77 69                	ja     f01065bf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0106556:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0106559:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f010655d:	83 ee 01             	sub    $0x1,%esi
f0106560:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0106564:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106568:	8b 44 24 08          	mov    0x8(%esp),%eax
f010656c:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0106570:	89 c3                	mov    %eax,%ebx
f0106572:	89 d6                	mov    %edx,%esi
f0106574:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0106577:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010657a:	89 54 24 08          	mov    %edx,0x8(%esp)
f010657e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0106582:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106585:	89 04 24             	mov    %eax,(%esp)
f0106588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010658b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010658f:	e8 fc 1d 00 00       	call   f0108390 <__udivdi3>
f0106594:	89 d9                	mov    %ebx,%ecx
f0106596:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010659a:	89 74 24 0c          	mov    %esi,0xc(%esp)
f010659e:	89 04 24             	mov    %eax,(%esp)
f01065a1:	89 54 24 04          	mov    %edx,0x4(%esp)
f01065a5:	89 fa                	mov    %edi,%edx
f01065a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01065aa:	e8 71 ff ff ff       	call   f0106520 <printnum>
f01065af:	eb 1b                	jmp    f01065cc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01065b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01065b5:	8b 45 18             	mov    0x18(%ebp),%eax
f01065b8:	89 04 24             	mov    %eax,(%esp)
f01065bb:	ff d3                	call   *%ebx
f01065bd:	eb 03                	jmp    f01065c2 <printnum+0xa2>
f01065bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f01065c2:	83 ee 01             	sub    $0x1,%esi
f01065c5:	85 f6                	test   %esi,%esi
f01065c7:	7f e8                	jg     f01065b1 <printnum+0x91>
f01065c9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01065cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01065d0:	8b 7c 24 04          	mov    0x4(%esp),%edi
f01065d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01065d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01065da:	89 44 24 08          	mov    %eax,0x8(%esp)
f01065de:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01065e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01065e5:	89 04 24             	mov    %eax,(%esp)
f01065e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01065eb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01065ef:	e8 cc 1e 00 00       	call   f01084c0 <__umoddi3>
f01065f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01065f8:	0f be 80 bd a1 10 f0 	movsbl -0xfef5e43(%eax),%eax
f01065ff:	89 04 24             	mov    %eax,(%esp)
f0106602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106605:	ff d0                	call   *%eax
}
f0106607:	83 c4 3c             	add    $0x3c,%esp
f010660a:	5b                   	pop    %ebx
f010660b:	5e                   	pop    %esi
f010660c:	5f                   	pop    %edi
f010660d:	5d                   	pop    %ebp
f010660e:	c3                   	ret    

f010660f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f010660f:	55                   	push   %ebp
f0106610:	89 e5                	mov    %esp,%ebp
f0106612:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0106615:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0106619:	8b 10                	mov    (%eax),%edx
f010661b:	3b 50 04             	cmp    0x4(%eax),%edx
f010661e:	73 0a                	jae    f010662a <sprintputch+0x1b>
		*b->buf++ = ch;
f0106620:	8d 4a 01             	lea    0x1(%edx),%ecx
f0106623:	89 08                	mov    %ecx,(%eax)
f0106625:	8b 45 08             	mov    0x8(%ebp),%eax
f0106628:	88 02                	mov    %al,(%edx)
}
f010662a:	5d                   	pop    %ebp
f010662b:	c3                   	ret    

f010662c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f010662c:	55                   	push   %ebp
f010662d:	89 e5                	mov    %esp,%ebp
f010662f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
f0106632:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0106635:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106639:	8b 45 10             	mov    0x10(%ebp),%eax
f010663c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106640:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106643:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106647:	8b 45 08             	mov    0x8(%ebp),%eax
f010664a:	89 04 24             	mov    %eax,(%esp)
f010664d:	e8 02 00 00 00       	call   f0106654 <vprintfmt>
	va_end(ap);
}
f0106652:	c9                   	leave  
f0106653:	c3                   	ret    

f0106654 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0106654:	55                   	push   %ebp
f0106655:	89 e5                	mov    %esp,%ebp
f0106657:	57                   	push   %edi
f0106658:	56                   	push   %esi
f0106659:	53                   	push   %ebx
f010665a:	83 ec 3c             	sub    $0x3c,%esp
f010665d:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0106660:	eb 17                	jmp    f0106679 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
f0106662:	85 c0                	test   %eax,%eax
f0106664:	0f 84 4b 04 00 00    	je     f0106ab5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
f010666a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010666d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106671:	89 04 24             	mov    %eax,(%esp)
f0106674:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
f0106677:	89 fb                	mov    %edi,%ebx
f0106679:	8d 7b 01             	lea    0x1(%ebx),%edi
f010667c:	0f b6 03             	movzbl (%ebx),%eax
f010667f:	83 f8 25             	cmp    $0x25,%eax
f0106682:	75 de                	jne    f0106662 <vprintfmt+0xe>
f0106684:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
f0106688:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f010668f:	be ff ff ff ff       	mov    $0xffffffff,%esi
f0106694:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
f010669b:	b9 00 00 00 00       	mov    $0x0,%ecx
f01066a0:	eb 18                	jmp    f01066ba <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01066a2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
f01066a4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
f01066a8:	eb 10                	jmp    f01066ba <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01066aa:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f01066ac:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
f01066b0:	eb 08                	jmp    f01066ba <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
f01066b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
f01066b5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01066ba:	8d 5f 01             	lea    0x1(%edi),%ebx
f01066bd:	0f b6 17             	movzbl (%edi),%edx
f01066c0:	0f b6 c2             	movzbl %dl,%eax
f01066c3:	83 ea 23             	sub    $0x23,%edx
f01066c6:	80 fa 55             	cmp    $0x55,%dl
f01066c9:	0f 87 c2 03 00 00    	ja     f0106a91 <vprintfmt+0x43d>
f01066cf:	0f b6 d2             	movzbl %dl,%edx
f01066d2:	ff 24 95 00 a3 10 f0 	jmp    *-0xfef5d00(,%edx,4)
f01066d9:	89 df                	mov    %ebx,%edi
f01066db:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f01066e0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
f01066e3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
f01066e7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
f01066ea:	8d 50 d0             	lea    -0x30(%eax),%edx
f01066ed:	83 fa 09             	cmp    $0x9,%edx
f01066f0:	77 33                	ja     f0106725 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f01066f2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
f01066f5:	eb e9                	jmp    f01066e0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f01066f7:	8b 45 14             	mov    0x14(%ebp),%eax
f01066fa:	8b 30                	mov    (%eax),%esi
f01066fc:	8d 40 04             	lea    0x4(%eax),%eax
f01066ff:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0106702:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
f0106704:	eb 1f                	jmp    f0106725 <vprintfmt+0xd1>
f0106706:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0106709:	85 ff                	test   %edi,%edi
f010670b:	b8 00 00 00 00       	mov    $0x0,%eax
f0106710:	0f 49 c7             	cmovns %edi,%eax
f0106713:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0106716:	89 df                	mov    %ebx,%edi
f0106718:	eb a0                	jmp    f01066ba <vprintfmt+0x66>
f010671a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
f010671c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
f0106723:	eb 95                	jmp    f01066ba <vprintfmt+0x66>

		process_precision:
			if (width < 0)
f0106725:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0106729:	79 8f                	jns    f01066ba <vprintfmt+0x66>
f010672b:	eb 85                	jmp    f01066b2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f010672d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0106730:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
f0106732:	eb 86                	jmp    f01066ba <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f0106734:	8b 45 14             	mov    0x14(%ebp),%eax
f0106737:	8d 70 04             	lea    0x4(%eax),%esi
f010673a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010673d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106741:	8b 45 14             	mov    0x14(%ebp),%eax
f0106744:	8b 00                	mov    (%eax),%eax
f0106746:	89 04 24             	mov    %eax,(%esp)
f0106749:	ff 55 08             	call   *0x8(%ebp)
f010674c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
f010674f:	e9 25 ff ff ff       	jmp    f0106679 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
f0106754:	8b 45 14             	mov    0x14(%ebp),%eax
f0106757:	8d 70 04             	lea    0x4(%eax),%esi
f010675a:	8b 00                	mov    (%eax),%eax
f010675c:	99                   	cltd   
f010675d:	31 d0                	xor    %edx,%eax
f010675f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0106761:	83 f8 15             	cmp    $0x15,%eax
f0106764:	7f 0b                	jg     f0106771 <vprintfmt+0x11d>
f0106766:	8b 14 85 60 a4 10 f0 	mov    -0xfef5ba0(,%eax,4),%edx
f010676d:	85 d2                	test   %edx,%edx
f010676f:	75 26                	jne    f0106797 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
f0106771:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106775:	c7 44 24 08 d5 a1 10 	movl   $0xf010a1d5,0x8(%esp)
f010677c:	f0 
f010677d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106780:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106784:	8b 45 08             	mov    0x8(%ebp),%eax
f0106787:	89 04 24             	mov    %eax,(%esp)
f010678a:	e8 9d fe ff ff       	call   f010662c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
f010678f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
f0106792:	e9 e2 fe ff ff       	jmp    f0106679 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
f0106797:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010679b:	c7 44 24 08 20 8e 10 	movl   $0xf0108e20,0x8(%esp)
f01067a2:	f0 
f01067a3:	8b 45 0c             	mov    0xc(%ebp),%eax
f01067a6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01067aa:	8b 45 08             	mov    0x8(%ebp),%eax
f01067ad:	89 04 24             	mov    %eax,(%esp)
f01067b0:	e8 77 fe ff ff       	call   f010662c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
f01067b5:	89 75 14             	mov    %esi,0x14(%ebp)
f01067b8:	e9 bc fe ff ff       	jmp    f0106679 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01067bd:	8b 45 14             	mov    0x14(%ebp),%eax
f01067c0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01067c3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f01067c6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
f01067ca:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f01067cc:	85 ff                	test   %edi,%edi
f01067ce:	b8 ce a1 10 f0       	mov    $0xf010a1ce,%eax
f01067d3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f01067d6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
f01067da:	0f 84 94 00 00 00    	je     f0106874 <vprintfmt+0x220>
f01067e0:	85 c9                	test   %ecx,%ecx
f01067e2:	0f 8e 94 00 00 00    	jle    f010687c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
f01067e8:	89 74 24 04          	mov    %esi,0x4(%esp)
f01067ec:	89 3c 24             	mov    %edi,(%esp)
f01067ef:	e8 44 04 00 00       	call   f0106c38 <strnlen>
f01067f4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f01067f7:	29 c1                	sub    %eax,%ecx
f01067f9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
f01067fc:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
f0106800:	89 7d dc             	mov    %edi,-0x24(%ebp)
f0106803:	89 75 d8             	mov    %esi,-0x28(%ebp)
f0106806:	8b 75 08             	mov    0x8(%ebp),%esi
f0106809:	89 5d 10             	mov    %ebx,0x10(%ebp)
f010680c:	89 cb                	mov    %ecx,%ebx
f010680e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0106810:	eb 0f                	jmp    f0106821 <vprintfmt+0x1cd>
					putch(padc, putdat);
f0106812:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106815:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106819:	89 3c 24             	mov    %edi,(%esp)
f010681c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f010681e:	83 eb 01             	sub    $0x1,%ebx
f0106821:	85 db                	test   %ebx,%ebx
f0106823:	7f ed                	jg     f0106812 <vprintfmt+0x1be>
f0106825:	8b 7d dc             	mov    -0x24(%ebp),%edi
f0106828:	8b 75 d8             	mov    -0x28(%ebp),%esi
f010682b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010682e:	85 c9                	test   %ecx,%ecx
f0106830:	b8 00 00 00 00       	mov    $0x0,%eax
f0106835:	0f 49 c1             	cmovns %ecx,%eax
f0106838:	29 c1                	sub    %eax,%ecx
f010683a:	89 cb                	mov    %ecx,%ebx
f010683c:	eb 44                	jmp    f0106882 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f010683e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0106842:	74 1e                	je     f0106862 <vprintfmt+0x20e>
f0106844:	0f be d2             	movsbl %dl,%edx
f0106847:	83 ea 20             	sub    $0x20,%edx
f010684a:	83 fa 5e             	cmp    $0x5e,%edx
f010684d:	76 13                	jbe    f0106862 <vprintfmt+0x20e>
					putch('?', putdat);
f010684f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106852:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106856:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f010685d:	ff 55 08             	call   *0x8(%ebp)
f0106860:	eb 0d                	jmp    f010686f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
f0106862:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106865:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106869:	89 04 24             	mov    %eax,(%esp)
f010686c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010686f:	83 eb 01             	sub    $0x1,%ebx
f0106872:	eb 0e                	jmp    f0106882 <vprintfmt+0x22e>
f0106874:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106877:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f010687a:	eb 06                	jmp    f0106882 <vprintfmt+0x22e>
f010687c:	89 5d 10             	mov    %ebx,0x10(%ebp)
f010687f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0106882:	83 c7 01             	add    $0x1,%edi
f0106885:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f0106889:	0f be c2             	movsbl %dl,%eax
f010688c:	85 c0                	test   %eax,%eax
f010688e:	74 27                	je     f01068b7 <vprintfmt+0x263>
f0106890:	85 f6                	test   %esi,%esi
f0106892:	78 aa                	js     f010683e <vprintfmt+0x1ea>
f0106894:	83 ee 01             	sub    $0x1,%esi
f0106897:	79 a5                	jns    f010683e <vprintfmt+0x1ea>
f0106899:	89 d8                	mov    %ebx,%eax
f010689b:	8b 75 08             	mov    0x8(%ebp),%esi
f010689e:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01068a1:	89 c3                	mov    %eax,%ebx
f01068a3:	eb 18                	jmp    f01068bd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f01068a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01068a9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01068b0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f01068b2:	83 eb 01             	sub    $0x1,%ebx
f01068b5:	eb 06                	jmp    f01068bd <vprintfmt+0x269>
f01068b7:	8b 75 08             	mov    0x8(%ebp),%esi
f01068ba:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01068bd:	85 db                	test   %ebx,%ebx
f01068bf:	7f e4                	jg     f01068a5 <vprintfmt+0x251>
f01068c1:	89 75 08             	mov    %esi,0x8(%ebp)
f01068c4:	89 7d 0c             	mov    %edi,0xc(%ebp)
f01068c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
f01068ca:	e9 aa fd ff ff       	jmp    f0106679 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f01068cf:	83 f9 01             	cmp    $0x1,%ecx
f01068d2:	7e 10                	jle    f01068e4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
f01068d4:	8b 45 14             	mov    0x14(%ebp),%eax
f01068d7:	8b 30                	mov    (%eax),%esi
f01068d9:	8b 78 04             	mov    0x4(%eax),%edi
f01068dc:	8d 40 08             	lea    0x8(%eax),%eax
f01068df:	89 45 14             	mov    %eax,0x14(%ebp)
f01068e2:	eb 26                	jmp    f010690a <vprintfmt+0x2b6>
	else if (lflag)
f01068e4:	85 c9                	test   %ecx,%ecx
f01068e6:	74 12                	je     f01068fa <vprintfmt+0x2a6>
		return va_arg(*ap, long);
f01068e8:	8b 45 14             	mov    0x14(%ebp),%eax
f01068eb:	8b 30                	mov    (%eax),%esi
f01068ed:	89 f7                	mov    %esi,%edi
f01068ef:	c1 ff 1f             	sar    $0x1f,%edi
f01068f2:	8d 40 04             	lea    0x4(%eax),%eax
f01068f5:	89 45 14             	mov    %eax,0x14(%ebp)
f01068f8:	eb 10                	jmp    f010690a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
f01068fa:	8b 45 14             	mov    0x14(%ebp),%eax
f01068fd:	8b 30                	mov    (%eax),%esi
f01068ff:	89 f7                	mov    %esi,%edi
f0106901:	c1 ff 1f             	sar    $0x1f,%edi
f0106904:	8d 40 04             	lea    0x4(%eax),%eax
f0106907:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f010690a:	89 f0                	mov    %esi,%eax
f010690c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
f010690e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
f0106913:	85 ff                	test   %edi,%edi
f0106915:	0f 89 3a 01 00 00    	jns    f0106a55 <vprintfmt+0x401>
				putch('-', putdat);
f010691b:	8b 45 0c             	mov    0xc(%ebp),%eax
f010691e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106922:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f0106929:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f010692c:	89 f0                	mov    %esi,%eax
f010692e:	89 fa                	mov    %edi,%edx
f0106930:	f7 d8                	neg    %eax
f0106932:	83 d2 00             	adc    $0x0,%edx
f0106935:	f7 da                	neg    %edx
			}
			base = 10;
f0106937:	b9 0a 00 00 00       	mov    $0xa,%ecx
f010693c:	e9 14 01 00 00       	jmp    f0106a55 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0106941:	83 f9 01             	cmp    $0x1,%ecx
f0106944:	7e 13                	jle    f0106959 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
f0106946:	8b 45 14             	mov    0x14(%ebp),%eax
f0106949:	8b 50 04             	mov    0x4(%eax),%edx
f010694c:	8b 00                	mov    (%eax),%eax
f010694e:	8b 75 14             	mov    0x14(%ebp),%esi
f0106951:	8d 4e 08             	lea    0x8(%esi),%ecx
f0106954:	89 4d 14             	mov    %ecx,0x14(%ebp)
f0106957:	eb 2c                	jmp    f0106985 <vprintfmt+0x331>
	else if (lflag)
f0106959:	85 c9                	test   %ecx,%ecx
f010695b:	74 15                	je     f0106972 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
f010695d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106960:	8b 00                	mov    (%eax),%eax
f0106962:	ba 00 00 00 00       	mov    $0x0,%edx
f0106967:	8b 75 14             	mov    0x14(%ebp),%esi
f010696a:	8d 76 04             	lea    0x4(%esi),%esi
f010696d:	89 75 14             	mov    %esi,0x14(%ebp)
f0106970:	eb 13                	jmp    f0106985 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
f0106972:	8b 45 14             	mov    0x14(%ebp),%eax
f0106975:	8b 00                	mov    (%eax),%eax
f0106977:	ba 00 00 00 00       	mov    $0x0,%edx
f010697c:	8b 75 14             	mov    0x14(%ebp),%esi
f010697f:	8d 76 04             	lea    0x4(%esi),%esi
f0106982:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
f0106985:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
f010698a:	e9 c6 00 00 00       	jmp    f0106a55 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f010698f:	83 f9 01             	cmp    $0x1,%ecx
f0106992:	7e 13                	jle    f01069a7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
f0106994:	8b 45 14             	mov    0x14(%ebp),%eax
f0106997:	8b 50 04             	mov    0x4(%eax),%edx
f010699a:	8b 00                	mov    (%eax),%eax
f010699c:	8b 75 14             	mov    0x14(%ebp),%esi
f010699f:	8d 4e 08             	lea    0x8(%esi),%ecx
f01069a2:	89 4d 14             	mov    %ecx,0x14(%ebp)
f01069a5:	eb 24                	jmp    f01069cb <vprintfmt+0x377>
	else if (lflag)
f01069a7:	85 c9                	test   %ecx,%ecx
f01069a9:	74 11                	je     f01069bc <vprintfmt+0x368>
		return va_arg(*ap, long);
f01069ab:	8b 45 14             	mov    0x14(%ebp),%eax
f01069ae:	8b 00                	mov    (%eax),%eax
f01069b0:	99                   	cltd   
f01069b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
f01069b4:	8d 71 04             	lea    0x4(%ecx),%esi
f01069b7:	89 75 14             	mov    %esi,0x14(%ebp)
f01069ba:	eb 0f                	jmp    f01069cb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
f01069bc:	8b 45 14             	mov    0x14(%ebp),%eax
f01069bf:	8b 00                	mov    (%eax),%eax
f01069c1:	99                   	cltd   
f01069c2:	8b 75 14             	mov    0x14(%ebp),%esi
f01069c5:	8d 76 04             	lea    0x4(%esi),%esi
f01069c8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
f01069cb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
f01069d0:	e9 80 00 00 00       	jmp    f0106a55 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01069d5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
f01069d8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01069db:	89 44 24 04          	mov    %eax,0x4(%esp)
f01069df:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f01069e6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f01069e9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01069ec:	89 44 24 04          	mov    %eax,0x4(%esp)
f01069f0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f01069f7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f01069fa:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
f01069fe:	8b 06                	mov    (%esi),%eax
f0106a00:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f0106a05:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
f0106a0a:	eb 49                	jmp    f0106a55 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0106a0c:	83 f9 01             	cmp    $0x1,%ecx
f0106a0f:	7e 13                	jle    f0106a24 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
f0106a11:	8b 45 14             	mov    0x14(%ebp),%eax
f0106a14:	8b 50 04             	mov    0x4(%eax),%edx
f0106a17:	8b 00                	mov    (%eax),%eax
f0106a19:	8b 75 14             	mov    0x14(%ebp),%esi
f0106a1c:	8d 4e 08             	lea    0x8(%esi),%ecx
f0106a1f:	89 4d 14             	mov    %ecx,0x14(%ebp)
f0106a22:	eb 2c                	jmp    f0106a50 <vprintfmt+0x3fc>
	else if (lflag)
f0106a24:	85 c9                	test   %ecx,%ecx
f0106a26:	74 15                	je     f0106a3d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
f0106a28:	8b 45 14             	mov    0x14(%ebp),%eax
f0106a2b:	8b 00                	mov    (%eax),%eax
f0106a2d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106a32:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0106a35:	8d 71 04             	lea    0x4(%ecx),%esi
f0106a38:	89 75 14             	mov    %esi,0x14(%ebp)
f0106a3b:	eb 13                	jmp    f0106a50 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
f0106a3d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106a40:	8b 00                	mov    (%eax),%eax
f0106a42:	ba 00 00 00 00       	mov    $0x0,%edx
f0106a47:	8b 75 14             	mov    0x14(%ebp),%esi
f0106a4a:	8d 76 04             	lea    0x4(%esi),%esi
f0106a4d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
f0106a50:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
f0106a55:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
f0106a59:	89 74 24 10          	mov    %esi,0x10(%esp)
f0106a5d:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0106a60:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0106a64:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106a68:	89 04 24             	mov    %eax,(%esp)
f0106a6b:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106a72:	8b 45 08             	mov    0x8(%ebp),%eax
f0106a75:	e8 a6 fa ff ff       	call   f0106520 <printnum>
			break;
f0106a7a:	e9 fa fb ff ff       	jmp    f0106679 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f0106a7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106a82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106a86:	89 04 24             	mov    %eax,(%esp)
f0106a89:	ff 55 08             	call   *0x8(%ebp)
			break;
f0106a8c:	e9 e8 fb ff ff       	jmp    f0106679 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f0106a91:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106a94:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106a98:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0106a9f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f0106aa2:	89 fb                	mov    %edi,%ebx
f0106aa4:	eb 03                	jmp    f0106aa9 <vprintfmt+0x455>
f0106aa6:	83 eb 01             	sub    $0x1,%ebx
f0106aa9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
f0106aad:	75 f7                	jne    f0106aa6 <vprintfmt+0x452>
f0106aaf:	90                   	nop
f0106ab0:	e9 c4 fb ff ff       	jmp    f0106679 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
f0106ab5:	83 c4 3c             	add    $0x3c,%esp
f0106ab8:	5b                   	pop    %ebx
f0106ab9:	5e                   	pop    %esi
f0106aba:	5f                   	pop    %edi
f0106abb:	5d                   	pop    %ebp
f0106abc:	c3                   	ret    

f0106abd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0106abd:	55                   	push   %ebp
f0106abe:	89 e5                	mov    %esp,%ebp
f0106ac0:	83 ec 28             	sub    $0x28,%esp
f0106ac3:	8b 45 08             	mov    0x8(%ebp),%eax
f0106ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0106ac9:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0106acc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0106ad0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0106ad3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0106ada:	85 c0                	test   %eax,%eax
f0106adc:	74 30                	je     f0106b0e <vsnprintf+0x51>
f0106ade:	85 d2                	test   %edx,%edx
f0106ae0:	7e 2c                	jle    f0106b0e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0106ae2:	8b 45 14             	mov    0x14(%ebp),%eax
f0106ae5:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106ae9:	8b 45 10             	mov    0x10(%ebp),%eax
f0106aec:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106af0:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0106af3:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106af7:	c7 04 24 0f 66 10 f0 	movl   $0xf010660f,(%esp)
f0106afe:	e8 51 fb ff ff       	call   f0106654 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0106b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106b06:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0106b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106b0c:	eb 05                	jmp    f0106b13 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
f0106b0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
f0106b13:	c9                   	leave  
f0106b14:	c3                   	ret    

f0106b15 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0106b15:	55                   	push   %ebp
f0106b16:	89 e5                	mov    %esp,%ebp
f0106b18:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106b1b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0106b1e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106b22:	8b 45 10             	mov    0x10(%ebp),%eax
f0106b25:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106b29:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106b30:	8b 45 08             	mov    0x8(%ebp),%eax
f0106b33:	89 04 24             	mov    %eax,(%esp)
f0106b36:	e8 82 ff ff ff       	call   f0106abd <vsnprintf>
	va_end(ap);

	return rc;
}
f0106b3b:	c9                   	leave  
f0106b3c:	c3                   	ret    
f0106b3d:	66 90                	xchg   %ax,%ax
f0106b3f:	90                   	nop

f0106b40 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0106b40:	55                   	push   %ebp
f0106b41:	89 e5                	mov    %esp,%ebp
f0106b43:	57                   	push   %edi
f0106b44:	56                   	push   %esi
f0106b45:	53                   	push   %ebx
f0106b46:	83 ec 1c             	sub    $0x1c,%esp
f0106b49:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106b4c:	85 c0                	test   %eax,%eax
f0106b4e:	74 10                	je     f0106b60 <readline+0x20>
		cprintf("%s", prompt);
f0106b50:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106b54:	c7 04 24 20 8e 10 f0 	movl   $0xf0108e20,(%esp)
f0106b5b:	e8 c7 dc ff ff       	call   f0104827 <cprintf>
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0106b60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0106b67:	e8 20 9d ff ff       	call   f010088c <iscons>
f0106b6c:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
f0106b6e:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
f0106b73:	e8 03 9d ff ff       	call   f010087b <getchar>
f0106b78:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0106b7a:	85 c0                	test   %eax,%eax
f0106b7c:	79 25                	jns    f0106ba3 <readline+0x63>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0106b7e:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
f0106b83:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0106b86:	0f 84 89 00 00 00    	je     f0106c15 <readline+0xd5>
				cprintf("read error: %e\n", c);
f0106b8c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0106b90:	c7 04 24 d7 a4 10 f0 	movl   $0xf010a4d7,(%esp)
f0106b97:	e8 8b dc ff ff       	call   f0104827 <cprintf>
			return NULL;
f0106b9c:	b8 00 00 00 00       	mov    $0x0,%eax
f0106ba1:	eb 72                	jmp    f0106c15 <readline+0xd5>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0106ba3:	83 f8 7f             	cmp    $0x7f,%eax
f0106ba6:	74 05                	je     f0106bad <readline+0x6d>
f0106ba8:	83 f8 08             	cmp    $0x8,%eax
f0106bab:	75 1a                	jne    f0106bc7 <readline+0x87>
f0106bad:	85 f6                	test   %esi,%esi
f0106baf:	90                   	nop
f0106bb0:	7e 15                	jle    f0106bc7 <readline+0x87>
			if (echoing)
f0106bb2:	85 ff                	test   %edi,%edi
f0106bb4:	74 0c                	je     f0106bc2 <readline+0x82>
				cputchar('\b');
f0106bb6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f0106bbd:	e8 a9 9c ff ff       	call   f010086b <cputchar>
			i--;
f0106bc2:	83 ee 01             	sub    $0x1,%esi
f0106bc5:	eb ac                	jmp    f0106b73 <readline+0x33>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0106bc7:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0106bcd:	7f 1c                	jg     f0106beb <readline+0xab>
f0106bcf:	83 fb 1f             	cmp    $0x1f,%ebx
f0106bd2:	7e 17                	jle    f0106beb <readline+0xab>
			if (echoing)
f0106bd4:	85 ff                	test   %edi,%edi
f0106bd6:	74 08                	je     f0106be0 <readline+0xa0>
				cputchar(c);
f0106bd8:	89 1c 24             	mov    %ebx,(%esp)
f0106bdb:	e8 8b 9c ff ff       	call   f010086b <cputchar>
			buf[i++] = c;
f0106be0:	88 9e 80 3a 2c f0    	mov    %bl,-0xfd3c580(%esi)
f0106be6:	8d 76 01             	lea    0x1(%esi),%esi
f0106be9:	eb 88                	jmp    f0106b73 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f0106beb:	83 fb 0d             	cmp    $0xd,%ebx
f0106bee:	74 09                	je     f0106bf9 <readline+0xb9>
f0106bf0:	83 fb 0a             	cmp    $0xa,%ebx
f0106bf3:	0f 85 7a ff ff ff    	jne    f0106b73 <readline+0x33>
			if (echoing)
f0106bf9:	85 ff                	test   %edi,%edi
f0106bfb:	74 0c                	je     f0106c09 <readline+0xc9>
				cputchar('\n');
f0106bfd:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f0106c04:	e8 62 9c ff ff       	call   f010086b <cputchar>
			buf[i] = 0;
f0106c09:	c6 86 80 3a 2c f0 00 	movb   $0x0,-0xfd3c580(%esi)
			return buf;
f0106c10:	b8 80 3a 2c f0       	mov    $0xf02c3a80,%eax
		}
	}
}
f0106c15:	83 c4 1c             	add    $0x1c,%esp
f0106c18:	5b                   	pop    %ebx
f0106c19:	5e                   	pop    %esi
f0106c1a:	5f                   	pop    %edi
f0106c1b:	5d                   	pop    %ebp
f0106c1c:	c3                   	ret    
f0106c1d:	66 90                	xchg   %ax,%ax
f0106c1f:	90                   	nop

f0106c20 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106c20:	55                   	push   %ebp
f0106c21:	89 e5                	mov    %esp,%ebp
f0106c23:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0106c26:	b8 00 00 00 00       	mov    $0x0,%eax
f0106c2b:	eb 03                	jmp    f0106c30 <strlen+0x10>
		n++;
f0106c2d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0106c30:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106c34:	75 f7                	jne    f0106c2d <strlen+0xd>
		n++;
	return n;
}
f0106c36:	5d                   	pop    %ebp
f0106c37:	c3                   	ret    

f0106c38 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0106c38:	55                   	push   %ebp
f0106c39:	89 e5                	mov    %esp,%ebp
f0106c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106c41:	b8 00 00 00 00       	mov    $0x0,%eax
f0106c46:	eb 03                	jmp    f0106c4b <strnlen+0x13>
		n++;
f0106c48:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106c4b:	39 d0                	cmp    %edx,%eax
f0106c4d:	74 06                	je     f0106c55 <strnlen+0x1d>
f0106c4f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0106c53:	75 f3                	jne    f0106c48 <strnlen+0x10>
		n++;
	return n;
}
f0106c55:	5d                   	pop    %ebp
f0106c56:	c3                   	ret    

f0106c57 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0106c57:	55                   	push   %ebp
f0106c58:	89 e5                	mov    %esp,%ebp
f0106c5a:	53                   	push   %ebx
f0106c5b:	8b 45 08             	mov    0x8(%ebp),%eax
f0106c5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0106c61:	89 c2                	mov    %eax,%edx
f0106c63:	83 c2 01             	add    $0x1,%edx
f0106c66:	83 c1 01             	add    $0x1,%ecx
f0106c69:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0106c6d:	88 5a ff             	mov    %bl,-0x1(%edx)
f0106c70:	84 db                	test   %bl,%bl
f0106c72:	75 ef                	jne    f0106c63 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0106c74:	5b                   	pop    %ebx
f0106c75:	5d                   	pop    %ebp
f0106c76:	c3                   	ret    

f0106c77 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0106c77:	55                   	push   %ebp
f0106c78:	89 e5                	mov    %esp,%ebp
f0106c7a:	53                   	push   %ebx
f0106c7b:	83 ec 08             	sub    $0x8,%esp
f0106c7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0106c81:	89 1c 24             	mov    %ebx,(%esp)
f0106c84:	e8 97 ff ff ff       	call   f0106c20 <strlen>
	strcpy(dst + len, src);
f0106c89:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106c8c:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106c90:	01 d8                	add    %ebx,%eax
f0106c92:	89 04 24             	mov    %eax,(%esp)
f0106c95:	e8 bd ff ff ff       	call   f0106c57 <strcpy>
	return dst;
}
f0106c9a:	89 d8                	mov    %ebx,%eax
f0106c9c:	83 c4 08             	add    $0x8,%esp
f0106c9f:	5b                   	pop    %ebx
f0106ca0:	5d                   	pop    %ebp
f0106ca1:	c3                   	ret    

f0106ca2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0106ca2:	55                   	push   %ebp
f0106ca3:	89 e5                	mov    %esp,%ebp
f0106ca5:	56                   	push   %esi
f0106ca6:	53                   	push   %ebx
f0106ca7:	8b 75 08             	mov    0x8(%ebp),%esi
f0106caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106cad:	89 f3                	mov    %esi,%ebx
f0106caf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0106cb2:	89 f2                	mov    %esi,%edx
f0106cb4:	eb 0f                	jmp    f0106cc5 <strncpy+0x23>
		*dst++ = *src;
f0106cb6:	83 c2 01             	add    $0x1,%edx
f0106cb9:	0f b6 01             	movzbl (%ecx),%eax
f0106cbc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0106cbf:	80 39 01             	cmpb   $0x1,(%ecx)
f0106cc2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0106cc5:	39 da                	cmp    %ebx,%edx
f0106cc7:	75 ed                	jne    f0106cb6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f0106cc9:	89 f0                	mov    %esi,%eax
f0106ccb:	5b                   	pop    %ebx
f0106ccc:	5e                   	pop    %esi
f0106ccd:	5d                   	pop    %ebp
f0106cce:	c3                   	ret    

f0106ccf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0106ccf:	55                   	push   %ebp
f0106cd0:	89 e5                	mov    %esp,%ebp
f0106cd2:	56                   	push   %esi
f0106cd3:	53                   	push   %ebx
f0106cd4:	8b 75 08             	mov    0x8(%ebp),%esi
f0106cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106cda:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0106cdd:	89 f0                	mov    %esi,%eax
f0106cdf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0106ce3:	85 c9                	test   %ecx,%ecx
f0106ce5:	75 0b                	jne    f0106cf2 <strlcpy+0x23>
f0106ce7:	eb 1d                	jmp    f0106d06 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0106ce9:	83 c0 01             	add    $0x1,%eax
f0106cec:	83 c2 01             	add    $0x1,%edx
f0106cef:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0106cf2:	39 d8                	cmp    %ebx,%eax
f0106cf4:	74 0b                	je     f0106d01 <strlcpy+0x32>
f0106cf6:	0f b6 0a             	movzbl (%edx),%ecx
f0106cf9:	84 c9                	test   %cl,%cl
f0106cfb:	75 ec                	jne    f0106ce9 <strlcpy+0x1a>
f0106cfd:	89 c2                	mov    %eax,%edx
f0106cff:	eb 02                	jmp    f0106d03 <strlcpy+0x34>
f0106d01:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
f0106d03:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
f0106d06:	29 f0                	sub    %esi,%eax
}
f0106d08:	5b                   	pop    %ebx
f0106d09:	5e                   	pop    %esi
f0106d0a:	5d                   	pop    %ebp
f0106d0b:	c3                   	ret    

f0106d0c <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0106d0c:	55                   	push   %ebp
f0106d0d:	89 e5                	mov    %esp,%ebp
f0106d0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106d12:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106d15:	eb 06                	jmp    f0106d1d <strcmp+0x11>
		p++, q++;
f0106d17:	83 c1 01             	add    $0x1,%ecx
f0106d1a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f0106d1d:	0f b6 01             	movzbl (%ecx),%eax
f0106d20:	84 c0                	test   %al,%al
f0106d22:	74 04                	je     f0106d28 <strcmp+0x1c>
f0106d24:	3a 02                	cmp    (%edx),%al
f0106d26:	74 ef                	je     f0106d17 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106d28:	0f b6 c0             	movzbl %al,%eax
f0106d2b:	0f b6 12             	movzbl (%edx),%edx
f0106d2e:	29 d0                	sub    %edx,%eax
}
f0106d30:	5d                   	pop    %ebp
f0106d31:	c3                   	ret    

f0106d32 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0106d32:	55                   	push   %ebp
f0106d33:	89 e5                	mov    %esp,%ebp
f0106d35:	53                   	push   %ebx
f0106d36:	8b 45 08             	mov    0x8(%ebp),%eax
f0106d39:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106d3c:	89 c3                	mov    %eax,%ebx
f0106d3e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0106d41:	eb 06                	jmp    f0106d49 <strncmp+0x17>
		n--, p++, q++;
f0106d43:	83 c0 01             	add    $0x1,%eax
f0106d46:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0106d49:	39 d8                	cmp    %ebx,%eax
f0106d4b:	74 15                	je     f0106d62 <strncmp+0x30>
f0106d4d:	0f b6 08             	movzbl (%eax),%ecx
f0106d50:	84 c9                	test   %cl,%cl
f0106d52:	74 04                	je     f0106d58 <strncmp+0x26>
f0106d54:	3a 0a                	cmp    (%edx),%cl
f0106d56:	74 eb                	je     f0106d43 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106d58:	0f b6 00             	movzbl (%eax),%eax
f0106d5b:	0f b6 12             	movzbl (%edx),%edx
f0106d5e:	29 d0                	sub    %edx,%eax
f0106d60:	eb 05                	jmp    f0106d67 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
f0106d62:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0106d67:	5b                   	pop    %ebx
f0106d68:	5d                   	pop    %ebp
f0106d69:	c3                   	ret    

f0106d6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0106d6a:	55                   	push   %ebp
f0106d6b:	89 e5                	mov    %esp,%ebp
f0106d6d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106d70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106d74:	eb 07                	jmp    f0106d7d <strchr+0x13>
		if (*s == c)
f0106d76:	38 ca                	cmp    %cl,%dl
f0106d78:	74 0f                	je     f0106d89 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f0106d7a:	83 c0 01             	add    $0x1,%eax
f0106d7d:	0f b6 10             	movzbl (%eax),%edx
f0106d80:	84 d2                	test   %dl,%dl
f0106d82:	75 f2                	jne    f0106d76 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
f0106d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106d89:	5d                   	pop    %ebp
f0106d8a:	c3                   	ret    

f0106d8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0106d8b:	55                   	push   %ebp
f0106d8c:	89 e5                	mov    %esp,%ebp
f0106d8e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106d91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106d95:	eb 07                	jmp    f0106d9e <strfind+0x13>
		if (*s == c)
f0106d97:	38 ca                	cmp    %cl,%dl
f0106d99:	74 0a                	je     f0106da5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f0106d9b:	83 c0 01             	add    $0x1,%eax
f0106d9e:	0f b6 10             	movzbl (%eax),%edx
f0106da1:	84 d2                	test   %dl,%dl
f0106da3:	75 f2                	jne    f0106d97 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
f0106da5:	5d                   	pop    %ebp
f0106da6:	c3                   	ret    

f0106da7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0106da7:	55                   	push   %ebp
f0106da8:	89 e5                	mov    %esp,%ebp
f0106daa:	57                   	push   %edi
f0106dab:	56                   	push   %esi
f0106dac:	53                   	push   %ebx
f0106dad:	8b 7d 08             	mov    0x8(%ebp),%edi
f0106db0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0106db3:	85 c9                	test   %ecx,%ecx
f0106db5:	74 36                	je     f0106ded <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0106db7:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0106dbd:	75 28                	jne    f0106de7 <memset+0x40>
f0106dbf:	f6 c1 03             	test   $0x3,%cl
f0106dc2:	75 23                	jne    f0106de7 <memset+0x40>
		c &= 0xFF;
f0106dc4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0106dc8:	89 d3                	mov    %edx,%ebx
f0106dca:	c1 e3 08             	shl    $0x8,%ebx
f0106dcd:	89 d6                	mov    %edx,%esi
f0106dcf:	c1 e6 18             	shl    $0x18,%esi
f0106dd2:	89 d0                	mov    %edx,%eax
f0106dd4:	c1 e0 10             	shl    $0x10,%eax
f0106dd7:	09 f0                	or     %esi,%eax
f0106dd9:	09 c2                	or     %eax,%edx
f0106ddb:	89 d0                	mov    %edx,%eax
f0106ddd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0106ddf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
f0106de2:	fc                   	cld    
f0106de3:	f3 ab                	rep stos %eax,%es:(%edi)
f0106de5:	eb 06                	jmp    f0106ded <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0106de7:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106dea:	fc                   	cld    
f0106deb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0106ded:	89 f8                	mov    %edi,%eax
f0106def:	5b                   	pop    %ebx
f0106df0:	5e                   	pop    %esi
f0106df1:	5f                   	pop    %edi
f0106df2:	5d                   	pop    %ebp
f0106df3:	c3                   	ret    

f0106df4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0106df4:	55                   	push   %ebp
f0106df5:	89 e5                	mov    %esp,%ebp
f0106df7:	57                   	push   %edi
f0106df8:	56                   	push   %esi
f0106df9:	8b 45 08             	mov    0x8(%ebp),%eax
f0106dfc:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106dff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0106e02:	39 c6                	cmp    %eax,%esi
f0106e04:	73 35                	jae    f0106e3b <memmove+0x47>
f0106e06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106e09:	39 d0                	cmp    %edx,%eax
f0106e0b:	73 2e                	jae    f0106e3b <memmove+0x47>
		s += n;
		d += n;
f0106e0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
f0106e10:	89 d6                	mov    %edx,%esi
f0106e12:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106e14:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106e1a:	75 13                	jne    f0106e2f <memmove+0x3b>
f0106e1c:	f6 c1 03             	test   $0x3,%cl
f0106e1f:	75 0e                	jne    f0106e2f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106e21:	83 ef 04             	sub    $0x4,%edi
f0106e24:	8d 72 fc             	lea    -0x4(%edx),%esi
f0106e27:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
f0106e2a:	fd                   	std    
f0106e2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106e2d:	eb 09                	jmp    f0106e38 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106e2f:	83 ef 01             	sub    $0x1,%edi
f0106e32:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0106e35:	fd                   	std    
f0106e36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0106e38:	fc                   	cld    
f0106e39:	eb 1d                	jmp    f0106e58 <memmove+0x64>
f0106e3b:	89 f2                	mov    %esi,%edx
f0106e3d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106e3f:	f6 c2 03             	test   $0x3,%dl
f0106e42:	75 0f                	jne    f0106e53 <memmove+0x5f>
f0106e44:	f6 c1 03             	test   $0x3,%cl
f0106e47:	75 0a                	jne    f0106e53 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0106e49:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
f0106e4c:	89 c7                	mov    %eax,%edi
f0106e4e:	fc                   	cld    
f0106e4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106e51:	eb 05                	jmp    f0106e58 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0106e53:	89 c7                	mov    %eax,%edi
f0106e55:	fc                   	cld    
f0106e56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0106e58:	5e                   	pop    %esi
f0106e59:	5f                   	pop    %edi
f0106e5a:	5d                   	pop    %ebp
f0106e5b:	c3                   	ret    

f0106e5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0106e5c:	55                   	push   %ebp
f0106e5d:	89 e5                	mov    %esp,%ebp
f0106e5f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106e62:	8b 45 10             	mov    0x10(%ebp),%eax
f0106e65:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106e69:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106e70:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e73:	89 04 24             	mov    %eax,(%esp)
f0106e76:	e8 79 ff ff ff       	call   f0106df4 <memmove>
}
f0106e7b:	c9                   	leave  
f0106e7c:	c3                   	ret    

f0106e7d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0106e7d:	55                   	push   %ebp
f0106e7e:	89 e5                	mov    %esp,%ebp
f0106e80:	56                   	push   %esi
f0106e81:	53                   	push   %ebx
f0106e82:	8b 55 08             	mov    0x8(%ebp),%edx
f0106e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106e88:	89 d6                	mov    %edx,%esi
f0106e8a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0106e8d:	eb 1a                	jmp    f0106ea9 <memcmp+0x2c>
		if (*s1 != *s2)
f0106e8f:	0f b6 02             	movzbl (%edx),%eax
f0106e92:	0f b6 19             	movzbl (%ecx),%ebx
f0106e95:	38 d8                	cmp    %bl,%al
f0106e97:	74 0a                	je     f0106ea3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
f0106e99:	0f b6 c0             	movzbl %al,%eax
f0106e9c:	0f b6 db             	movzbl %bl,%ebx
f0106e9f:	29 d8                	sub    %ebx,%eax
f0106ea1:	eb 0f                	jmp    f0106eb2 <memcmp+0x35>
		s1++, s2++;
f0106ea3:	83 c2 01             	add    $0x1,%edx
f0106ea6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0106ea9:	39 f2                	cmp    %esi,%edx
f0106eab:	75 e2                	jne    f0106e8f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f0106ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106eb2:	5b                   	pop    %ebx
f0106eb3:	5e                   	pop    %esi
f0106eb4:	5d                   	pop    %ebp
f0106eb5:	c3                   	ret    

f0106eb6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0106eb6:	55                   	push   %ebp
f0106eb7:	89 e5                	mov    %esp,%ebp
f0106eb9:	8b 45 08             	mov    0x8(%ebp),%eax
f0106ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0106ebf:	89 c2                	mov    %eax,%edx
f0106ec1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0106ec4:	eb 07                	jmp    f0106ecd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
f0106ec6:	38 08                	cmp    %cl,(%eax)
f0106ec8:	74 07                	je     f0106ed1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f0106eca:	83 c0 01             	add    $0x1,%eax
f0106ecd:	39 d0                	cmp    %edx,%eax
f0106ecf:	72 f5                	jb     f0106ec6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f0106ed1:	5d                   	pop    %ebp
f0106ed2:	c3                   	ret    

f0106ed3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0106ed3:	55                   	push   %ebp
f0106ed4:	89 e5                	mov    %esp,%ebp
f0106ed6:	57                   	push   %edi
f0106ed7:	56                   	push   %esi
f0106ed8:	53                   	push   %ebx
f0106ed9:	8b 55 08             	mov    0x8(%ebp),%edx
f0106edc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0106edf:	eb 03                	jmp    f0106ee4 <strtol+0x11>
		s++;
f0106ee1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0106ee4:	0f b6 0a             	movzbl (%edx),%ecx
f0106ee7:	80 f9 09             	cmp    $0x9,%cl
f0106eea:	74 f5                	je     f0106ee1 <strtol+0xe>
f0106eec:	80 f9 20             	cmp    $0x20,%cl
f0106eef:	74 f0                	je     f0106ee1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
f0106ef1:	80 f9 2b             	cmp    $0x2b,%cl
f0106ef4:	75 0a                	jne    f0106f00 <strtol+0x2d>
		s++;
f0106ef6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
f0106ef9:	bf 00 00 00 00       	mov    $0x0,%edi
f0106efe:	eb 11                	jmp    f0106f11 <strtol+0x3e>
f0106f00:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
f0106f05:	80 f9 2d             	cmp    $0x2d,%cl
f0106f08:	75 07                	jne    f0106f11 <strtol+0x3e>
		s++, neg = 1;
f0106f0a:	8d 52 01             	lea    0x1(%edx),%edx
f0106f0d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106f11:	a9 ef ff ff ff       	test   $0xffffffef,%eax
f0106f16:	75 15                	jne    f0106f2d <strtol+0x5a>
f0106f18:	80 3a 30             	cmpb   $0x30,(%edx)
f0106f1b:	75 10                	jne    f0106f2d <strtol+0x5a>
f0106f1d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0106f21:	75 0a                	jne    f0106f2d <strtol+0x5a>
		s += 2, base = 16;
f0106f23:	83 c2 02             	add    $0x2,%edx
f0106f26:	b8 10 00 00 00       	mov    $0x10,%eax
f0106f2b:	eb 10                	jmp    f0106f3d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
f0106f2d:	85 c0                	test   %eax,%eax
f0106f2f:	75 0c                	jne    f0106f3d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0106f31:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0106f33:	80 3a 30             	cmpb   $0x30,(%edx)
f0106f36:	75 05                	jne    f0106f3d <strtol+0x6a>
		s++, base = 8;
f0106f38:	83 c2 01             	add    $0x1,%edx
f0106f3b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
f0106f3d:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106f42:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0106f45:	0f b6 0a             	movzbl (%edx),%ecx
f0106f48:	8d 71 d0             	lea    -0x30(%ecx),%esi
f0106f4b:	89 f0                	mov    %esi,%eax
f0106f4d:	3c 09                	cmp    $0x9,%al
f0106f4f:	77 08                	ja     f0106f59 <strtol+0x86>
			dig = *s - '0';
f0106f51:	0f be c9             	movsbl %cl,%ecx
f0106f54:	83 e9 30             	sub    $0x30,%ecx
f0106f57:	eb 20                	jmp    f0106f79 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
f0106f59:	8d 71 9f             	lea    -0x61(%ecx),%esi
f0106f5c:	89 f0                	mov    %esi,%eax
f0106f5e:	3c 19                	cmp    $0x19,%al
f0106f60:	77 08                	ja     f0106f6a <strtol+0x97>
			dig = *s - 'a' + 10;
f0106f62:	0f be c9             	movsbl %cl,%ecx
f0106f65:	83 e9 57             	sub    $0x57,%ecx
f0106f68:	eb 0f                	jmp    f0106f79 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
f0106f6a:	8d 71 bf             	lea    -0x41(%ecx),%esi
f0106f6d:	89 f0                	mov    %esi,%eax
f0106f6f:	3c 19                	cmp    $0x19,%al
f0106f71:	77 16                	ja     f0106f89 <strtol+0xb6>
			dig = *s - 'A' + 10;
f0106f73:	0f be c9             	movsbl %cl,%ecx
f0106f76:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f0106f79:	3b 4d 10             	cmp    0x10(%ebp),%ecx
f0106f7c:	7d 0f                	jge    f0106f8d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
f0106f7e:	83 c2 01             	add    $0x1,%edx
f0106f81:	0f af 5d 10          	imul   0x10(%ebp),%ebx
f0106f85:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
f0106f87:	eb bc                	jmp    f0106f45 <strtol+0x72>
f0106f89:	89 d8                	mov    %ebx,%eax
f0106f8b:	eb 02                	jmp    f0106f8f <strtol+0xbc>
f0106f8d:	89 d8                	mov    %ebx,%eax

	if (endptr)
f0106f8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106f93:	74 05                	je     f0106f9a <strtol+0xc7>
		*endptr = (char *) s;
f0106f95:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106f98:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
f0106f9a:	f7 d8                	neg    %eax
f0106f9c:	85 ff                	test   %edi,%edi
f0106f9e:	0f 44 c3             	cmove  %ebx,%eax
}
f0106fa1:	5b                   	pop    %ebx
f0106fa2:	5e                   	pop    %esi
f0106fa3:	5f                   	pop    %edi
f0106fa4:	5d                   	pop    %ebp
f0106fa5:	c3                   	ret    
f0106fa6:	66 90                	xchg   %ax,%ax

f0106fa8 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0106fa8:	fa                   	cli    

	xorw    %ax, %ax
f0106fa9:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0106fab:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106fad:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106faf:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0106fb1:	0f 01 16             	lgdtl  (%esi)
f0106fb4:	74 70                	je     f0107026 <mpentry_end+0x4>
	movl    %cr0, %eax
f0106fb6:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0106fb9:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0106fbd:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0106fc0:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0106fc6:	08 00                	or     %al,(%eax)

f0106fc8 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0106fc8:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0106fcc:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106fce:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106fd0:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0106fd2:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0106fd6:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0106fd8:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0106fda:	b8 00 50 12 00       	mov    $0x125000,%eax
	movl    %eax, %cr3
f0106fdf:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0106fe2:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0106fe5:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0106fea:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0106fed:	8b 25 98 3e 2c f0    	mov    0xf02c3e98,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106ff3:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0106ff8:	b8 a7 02 10 f0       	mov    $0xf01002a7,%eax
	call    *%eax
f0106ffd:	ff d0                	call   *%eax

f0106fff <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106fff:	eb fe                	jmp    f0106fff <spin>
f0107001:	8d 76 00             	lea    0x0(%esi),%esi

f0107004 <gdt>:
	...
f010700c:	ff                   	(bad)  
f010700d:	ff 00                	incl   (%eax)
f010700f:	00 00                	add    %al,(%eax)
f0107011:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0107018:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

f010701c <gdtdesc>:
f010701c:	17                   	pop    %ss
f010701d:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0107022 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0107022:	90                   	nop
f0107023:	66 90                	xchg   %ax,%ax
f0107025:	66 90                	xchg   %ax,%ax
f0107027:	66 90                	xchg   %ax,%ax
f0107029:	66 90                	xchg   %ax,%ax
f010702b:	66 90                	xchg   %ax,%ax
f010702d:	66 90                	xchg   %ax,%ax
f010702f:	90                   	nop

f0107030 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0107030:	55                   	push   %ebp
f0107031:	89 e5                	mov    %esp,%ebp
f0107033:	56                   	push   %esi
f0107034:	53                   	push   %ebx
f0107035:	83 ec 10             	sub    $0x10,%esp
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0107038:	8b 0d 9c 3e 2c f0    	mov    0xf02c3e9c,%ecx
f010703e:	89 c3                	mov    %eax,%ebx
f0107040:	c1 eb 0c             	shr    $0xc,%ebx
f0107043:	39 cb                	cmp    %ecx,%ebx
f0107045:	72 20                	jb     f0107067 <mpsearch1+0x37>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107047:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010704b:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0107052:	f0 
f0107053:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f010705a:	00 
f010705b:	c7 04 24 75 a6 10 f0 	movl   $0xf010a675,(%esp)
f0107062:	e8 36 90 ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0107067:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f010706d:	01 d0                	add    %edx,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010706f:	89 c2                	mov    %eax,%edx
f0107071:	c1 ea 0c             	shr    $0xc,%edx
f0107074:	39 d1                	cmp    %edx,%ecx
f0107076:	77 20                	ja     f0107098 <mpsearch1+0x68>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107078:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010707c:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0107083:	f0 
f0107084:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f010708b:	00 
f010708c:	c7 04 24 75 a6 10 f0 	movl   $0xf010a675,(%esp)
f0107093:	e8 05 90 ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0107098:	8d b0 00 00 00 f0    	lea    -0x10000000(%eax),%esi

	for (; mp < end; mp++)
f010709e:	eb 36                	jmp    f01070d6 <mpsearch1+0xa6>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01070a0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f01070a7:	00 
f01070a8:	c7 44 24 04 85 a6 10 	movl   $0xf010a685,0x4(%esp)
f01070af:	f0 
f01070b0:	89 1c 24             	mov    %ebx,(%esp)
f01070b3:	e8 c5 fd ff ff       	call   f0106e7d <memcmp>
f01070b8:	85 c0                	test   %eax,%eax
f01070ba:	75 17                	jne    f01070d3 <mpsearch1+0xa3>
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f01070bc:	ba 00 00 00 00       	mov    $0x0,%edx
		sum += ((uint8_t *)addr)[i];
f01070c1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f01070c5:	01 c8                	add    %ecx,%eax
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f01070c7:	83 c2 01             	add    $0x1,%edx
f01070ca:	83 fa 10             	cmp    $0x10,%edx
f01070cd:	75 f2                	jne    f01070c1 <mpsearch1+0x91>
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01070cf:	84 c0                	test   %al,%al
f01070d1:	74 0e                	je     f01070e1 <mpsearch1+0xb1>
static struct mp *
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
f01070d3:	83 c3 10             	add    $0x10,%ebx
f01070d6:	39 f3                	cmp    %esi,%ebx
f01070d8:	72 c6                	jb     f01070a0 <mpsearch1+0x70>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f01070da:	b8 00 00 00 00       	mov    $0x0,%eax
f01070df:	eb 02                	jmp    f01070e3 <mpsearch1+0xb3>
f01070e1:	89 d8                	mov    %ebx,%eax
}
f01070e3:	83 c4 10             	add    $0x10,%esp
f01070e6:	5b                   	pop    %ebx
f01070e7:	5e                   	pop    %esi
f01070e8:	5d                   	pop    %ebp
f01070e9:	c3                   	ret    

f01070ea <mp_init>:
	return conf;
}

void
mp_init(void)
{
f01070ea:	55                   	push   %ebp
f01070eb:	89 e5                	mov    %esp,%ebp
f01070ed:	57                   	push   %edi
f01070ee:	56                   	push   %esi
f01070ef:	53                   	push   %ebx
f01070f0:	83 ec 2c             	sub    $0x2c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f01070f3:	c7 05 c0 43 2c f0 20 	movl   $0xf02c4020,0xf02c43c0
f01070fa:	40 2c f0 
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01070fd:	83 3d 9c 3e 2c f0 00 	cmpl   $0x0,0xf02c3e9c
f0107104:	75 24                	jne    f010712a <mp_init+0x40>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107106:	c7 44 24 0c 00 04 00 	movl   $0x400,0xc(%esp)
f010710d:	00 
f010710e:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f0107115:	f0 
f0107116:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
f010711d:	00 
f010711e:	c7 04 24 75 a6 10 f0 	movl   $0xf010a675,(%esp)
f0107125:	e8 73 8f ff ff       	call   f010009d <_panic>
	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f010712a:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0107131:	85 c0                	test   %eax,%eax
f0107133:	74 16                	je     f010714b <mp_init+0x61>
		p <<= 4;	// Translate from segment to PA
f0107135:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0107138:	ba 00 04 00 00       	mov    $0x400,%edx
f010713d:	e8 ee fe ff ff       	call   f0107030 <mpsearch1>
f0107142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0107145:	85 c0                	test   %eax,%eax
f0107147:	75 3c                	jne    f0107185 <mp_init+0x9b>
f0107149:	eb 20                	jmp    f010716b <mp_init+0x81>
			return mp;
	} else {
		// The size of base memory, in KB is in the two bytes
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
f010714b:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0107152:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0107155:	2d 00 04 00 00       	sub    $0x400,%eax
f010715a:	ba 00 04 00 00       	mov    $0x400,%edx
f010715f:	e8 cc fe ff ff       	call   f0107030 <mpsearch1>
f0107164:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0107167:	85 c0                	test   %eax,%eax
f0107169:	75 1a                	jne    f0107185 <mp_init+0x9b>
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f010716b:	ba 00 00 01 00       	mov    $0x10000,%edx
f0107170:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0107175:	e8 b6 fe ff ff       	call   f0107030 <mpsearch1>
f010717a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f010717d:	85 c0                	test   %eax,%eax
f010717f:	0f 84 54 02 00 00    	je     f01073d9 <mp_init+0x2ef>
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
f0107185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0107188:	8b 70 04             	mov    0x4(%eax),%esi
f010718b:	85 f6                	test   %esi,%esi
f010718d:	74 06                	je     f0107195 <mp_init+0xab>
f010718f:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0107193:	74 11                	je     f01071a6 <mp_init+0xbc>
		cprintf("SMP: Default configurations not implemented\n");
f0107195:	c7 04 24 e8 a4 10 f0 	movl   $0xf010a4e8,(%esp)
f010719c:	e8 86 d6 ff ff       	call   f0104827 <cprintf>
f01071a1:	e9 33 02 00 00       	jmp    f01073d9 <mp_init+0x2ef>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01071a6:	89 f0                	mov    %esi,%eax
f01071a8:	c1 e8 0c             	shr    $0xc,%eax
f01071ab:	3b 05 9c 3e 2c f0    	cmp    0xf02c3e9c,%eax
f01071b1:	72 20                	jb     f01071d3 <mp_init+0xe9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01071b3:	89 74 24 0c          	mov    %esi,0xc(%esp)
f01071b7:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f01071be:	f0 
f01071bf:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
f01071c6:	00 
f01071c7:	c7 04 24 75 a6 10 f0 	movl   $0xf010a675,(%esp)
f01071ce:	e8 ca 8e ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f01071d3:	8d 9e 00 00 00 f0    	lea    -0x10000000(%esi),%ebx
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
f01071d9:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f01071e0:	00 
f01071e1:	c7 44 24 04 8a a6 10 	movl   $0xf010a68a,0x4(%esp)
f01071e8:	f0 
f01071e9:	89 1c 24             	mov    %ebx,(%esp)
f01071ec:	e8 8c fc ff ff       	call   f0106e7d <memcmp>
f01071f1:	85 c0                	test   %eax,%eax
f01071f3:	74 11                	je     f0107206 <mp_init+0x11c>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f01071f5:	c7 04 24 18 a5 10 f0 	movl   $0xf010a518,(%esp)
f01071fc:	e8 26 d6 ff ff       	call   f0104827 <cprintf>
f0107201:	e9 d3 01 00 00       	jmp    f01073d9 <mp_init+0x2ef>
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0107206:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
f010720a:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
f010720e:	0f b7 f8             	movzwl %ax,%edi
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f0107211:	ba 00 00 00 00       	mov    $0x0,%edx
	for (i = 0; i < len; i++)
f0107216:	b8 00 00 00 00       	mov    $0x0,%eax
f010721b:	eb 0d                	jmp    f010722a <mp_init+0x140>
		sum += ((uint8_t *)addr)[i];
f010721d:	0f b6 8c 30 00 00 00 	movzbl -0x10000000(%eax,%esi,1),%ecx
f0107224:	f0 
f0107225:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0107227:	83 c0 01             	add    $0x1,%eax
f010722a:	39 c7                	cmp    %eax,%edi
f010722c:	7f ef                	jg     f010721d <mp_init+0x133>
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
		cprintf("SMP: Incorrect MP configuration table signature\n");
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f010722e:	84 d2                	test   %dl,%dl
f0107230:	74 11                	je     f0107243 <mp_init+0x159>
		cprintf("SMP: Bad MP configuration checksum\n");
f0107232:	c7 04 24 4c a5 10 f0 	movl   $0xf010a54c,(%esp)
f0107239:	e8 e9 d5 ff ff       	call   f0104827 <cprintf>
f010723e:	e9 96 01 00 00       	jmp    f01073d9 <mp_init+0x2ef>
		return NULL;
	}
	if (conf->version != 1 && conf->version != 4) {
f0107243:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
f0107247:	3c 04                	cmp    $0x4,%al
f0107249:	74 1f                	je     f010726a <mp_init+0x180>
f010724b:	3c 01                	cmp    $0x1,%al
f010724d:	8d 76 00             	lea    0x0(%esi),%esi
f0107250:	74 18                	je     f010726a <mp_init+0x180>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0107252:	0f b6 c0             	movzbl %al,%eax
f0107255:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107259:	c7 04 24 70 a5 10 f0 	movl   $0xf010a570,(%esp)
f0107260:	e8 c2 d5 ff ff       	call   f0104827 <cprintf>
f0107265:	e9 6f 01 00 00       	jmp    f01073d9 <mp_init+0x2ef>
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f010726a:	0f b7 73 28          	movzwl 0x28(%ebx),%esi
f010726e:	0f b7 7d e2          	movzwl -0x1e(%ebp),%edi
f0107272:	01 df                	add    %ebx,%edi
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f0107274:	ba 00 00 00 00       	mov    $0x0,%edx
	for (i = 0; i < len; i++)
f0107279:	b8 00 00 00 00       	mov    $0x0,%eax
f010727e:	eb 09                	jmp    f0107289 <mp_init+0x19f>
		sum += ((uint8_t *)addr)[i];
f0107280:	0f b6 0c 07          	movzbl (%edi,%eax,1),%ecx
f0107284:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0107286:	83 c0 01             	add    $0x1,%eax
f0107289:	39 c6                	cmp    %eax,%esi
f010728b:	7f f3                	jg     f0107280 <mp_init+0x196>
	}
	if (conf->version != 1 && conf->version != 4) {
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f010728d:	02 53 2a             	add    0x2a(%ebx),%dl
f0107290:	84 d2                	test   %dl,%dl
f0107292:	74 11                	je     f01072a5 <mp_init+0x1bb>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0107294:	c7 04 24 90 a5 10 f0 	movl   $0xf010a590,(%esp)
f010729b:	e8 87 d5 ff ff       	call   f0104827 <cprintf>
f01072a0:	e9 34 01 00 00       	jmp    f01073d9 <mp_init+0x2ef>
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
	if ((conf = mpconfig(&mp)) == 0)
f01072a5:	85 db                	test   %ebx,%ebx
f01072a7:	0f 84 2c 01 00 00    	je     f01073d9 <mp_init+0x2ef>
		return;
	ismp = 1;
f01072ad:	c7 05 00 40 2c f0 01 	movl   $0x1,0xf02c4000
f01072b4:	00 00 00 
	lapicaddr = conf->lapicaddr;
f01072b7:	8b 43 24             	mov    0x24(%ebx),%eax
f01072ba:	a3 00 50 30 f0       	mov    %eax,0xf0305000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f01072bf:	8d 7b 2c             	lea    0x2c(%ebx),%edi
f01072c2:	be 00 00 00 00       	mov    $0x0,%esi
f01072c7:	e9 86 00 00 00       	jmp    f0107352 <mp_init+0x268>
		switch (*p) {
f01072cc:	0f b6 07             	movzbl (%edi),%eax
f01072cf:	84 c0                	test   %al,%al
f01072d1:	74 06                	je     f01072d9 <mp_init+0x1ef>
f01072d3:	3c 04                	cmp    $0x4,%al
f01072d5:	77 57                	ja     f010732e <mp_init+0x244>
f01072d7:	eb 50                	jmp    f0107329 <mp_init+0x23f>
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f01072d9:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f01072dd:	8d 76 00             	lea    0x0(%esi),%esi
f01072e0:	74 11                	je     f01072f3 <mp_init+0x209>
				bootcpu = &cpus[ncpu];
f01072e2:	6b 05 c4 43 2c f0 74 	imul   $0x74,0xf02c43c4,%eax
f01072e9:	05 20 40 2c f0       	add    $0xf02c4020,%eax
f01072ee:	a3 c0 43 2c f0       	mov    %eax,0xf02c43c0
			if (ncpu < NCPU) {
f01072f3:	a1 c4 43 2c f0       	mov    0xf02c43c4,%eax
f01072f8:	83 f8 07             	cmp    $0x7,%eax
f01072fb:	7f 13                	jg     f0107310 <mp_init+0x226>
				cpus[ncpu].cpu_id = ncpu;
f01072fd:	6b d0 74             	imul   $0x74,%eax,%edx
f0107300:	88 82 20 40 2c f0    	mov    %al,-0xfd3bfe0(%edx)
				ncpu++;
f0107306:	83 c0 01             	add    $0x1,%eax
f0107309:	a3 c4 43 2c f0       	mov    %eax,0xf02c43c4
f010730e:	eb 14                	jmp    f0107324 <mp_init+0x23a>
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0107310:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0107314:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107318:	c7 04 24 c0 a5 10 f0 	movl   $0xf010a5c0,(%esp)
f010731f:	e8 03 d5 ff ff       	call   f0104827 <cprintf>
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0107324:	83 c7 14             	add    $0x14,%edi
			continue;
f0107327:	eb 26                	jmp    f010734f <mp_init+0x265>
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0107329:	83 c7 08             	add    $0x8,%edi
			continue;
f010732c:	eb 21                	jmp    f010734f <mp_init+0x265>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f010732e:	0f b6 c0             	movzbl %al,%eax
f0107331:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107335:	c7 04 24 e8 a5 10 f0 	movl   $0xf010a5e8,(%esp)
f010733c:	e8 e6 d4 ff ff       	call   f0104827 <cprintf>
			ismp = 0;
f0107341:	c7 05 00 40 2c f0 00 	movl   $0x0,0xf02c4000
f0107348:	00 00 00 
			i = conf->entry;
f010734b:	0f b7 73 22          	movzwl 0x22(%ebx),%esi
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
	lapicaddr = conf->lapicaddr;

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f010734f:	83 c6 01             	add    $0x1,%esi
f0107352:	0f b7 43 22          	movzwl 0x22(%ebx),%eax
f0107356:	39 c6                	cmp    %eax,%esi
f0107358:	0f 82 6e ff ff ff    	jb     f01072cc <mp_init+0x1e2>
			ismp = 0;
			i = conf->entry;
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f010735e:	a1 c0 43 2c f0       	mov    0xf02c43c0,%eax
f0107363:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f010736a:	83 3d 00 40 2c f0 00 	cmpl   $0x0,0xf02c4000
f0107371:	75 22                	jne    f0107395 <mp_init+0x2ab>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0107373:	c7 05 c4 43 2c f0 01 	movl   $0x1,0xf02c43c4
f010737a:	00 00 00 
		lapicaddr = 0;
f010737d:	c7 05 00 50 30 f0 00 	movl   $0x0,0xf0305000
f0107384:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0107387:	c7 04 24 08 a6 10 f0 	movl   $0xf010a608,(%esp)
f010738e:	e8 94 d4 ff ff       	call   f0104827 <cprintf>
		return;
f0107393:	eb 44                	jmp    f01073d9 <mp_init+0x2ef>
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0107395:	8b 15 c4 43 2c f0    	mov    0xf02c43c4,%edx
f010739b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010739f:	0f b6 00             	movzbl (%eax),%eax
f01073a2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01073a6:	c7 04 24 8f a6 10 f0 	movl   $0xf010a68f,(%esp)
f01073ad:	e8 75 d4 ff ff       	call   f0104827 <cprintf>

	if (mp->imcrp) {
f01073b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01073b5:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f01073b9:	74 1e                	je     f01073d9 <mp_init+0x2ef>
		// [MP 3.2.6.1] If the hardware implements PIC mode,
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f01073bb:	c7 04 24 34 a6 10 f0 	movl   $0xf010a634,(%esp)
f01073c2:	e8 60 d4 ff ff       	call   f0104827 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01073c7:	ba 22 00 00 00       	mov    $0x22,%edx
f01073cc:	b8 70 00 00 00       	mov    $0x70,%eax
f01073d1:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01073d2:	b2 23                	mov    $0x23,%dl
f01073d4:	ec                   	in     (%dx),%al
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f01073d5:	83 c8 01             	or     $0x1,%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01073d8:	ee                   	out    %al,(%dx)
	}
}
f01073d9:	83 c4 2c             	add    $0x2c,%esp
f01073dc:	5b                   	pop    %ebx
f01073dd:	5e                   	pop    %esi
f01073de:	5f                   	pop    %edi
f01073df:	5d                   	pop    %ebp
f01073e0:	c3                   	ret    

f01073e1 <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f01073e1:	55                   	push   %ebp
f01073e2:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f01073e4:	8b 0d 04 50 30 f0    	mov    0xf0305004,%ecx
f01073ea:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f01073ed:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f01073ef:	a1 04 50 30 f0       	mov    0xf0305004,%eax
f01073f4:	8b 40 20             	mov    0x20(%eax),%eax
}
f01073f7:	5d                   	pop    %ebp
f01073f8:	c3                   	ret    

f01073f9 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f01073f9:	55                   	push   %ebp
f01073fa:	89 e5                	mov    %esp,%ebp
	if (lapic)
f01073fc:	a1 04 50 30 f0       	mov    0xf0305004,%eax
f0107401:	85 c0                	test   %eax,%eax
f0107403:	74 08                	je     f010740d <cpunum+0x14>
		return lapic[ID] >> 24;
f0107405:	8b 40 20             	mov    0x20(%eax),%eax
f0107408:	c1 e8 18             	shr    $0x18,%eax
f010740b:	eb 05                	jmp    f0107412 <cpunum+0x19>
	return 0;
f010740d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0107412:	5d                   	pop    %ebp
f0107413:	c3                   	ret    

f0107414 <lapic_init>:
}

void
lapic_init(void)
{
	if (!lapicaddr)
f0107414:	a1 00 50 30 f0       	mov    0xf0305000,%eax
f0107419:	85 c0                	test   %eax,%eax
f010741b:	0f 84 38 01 00 00    	je     f0107559 <lapic_init+0x145>
	lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(void)
{
f0107421:	55                   	push   %ebp
f0107422:	89 e5                	mov    %esp,%ebp
f0107424:	83 ec 18             	sub    $0x18,%esp
	if (!lapicaddr)
		return;

	// lapicaddr is the physical address of the LAPIC's 4K MMIO
	// region.  Map it in to virtual memory so we can access it.
	cprintf("\nlapicaddr:%x\n",lapicaddr);
f0107427:	89 44 24 04          	mov    %eax,0x4(%esp)
f010742b:	c7 04 24 ac a6 10 f0 	movl   $0xf010a6ac,(%esp)
f0107432:	e8 f0 d3 ff ff       	call   f0104827 <cprintf>
	lapic = mmio_map_region(lapicaddr, 4096);
f0107437:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010743e:	00 
f010743f:	a1 00 50 30 f0       	mov    0xf0305000,%eax
f0107444:	89 04 24             	mov    %eax,(%esp)
f0107447:	e8 a3 a5 ff ff       	call   f01019ef <mmio_map_region>
f010744c:	a3 04 50 30 f0       	mov    %eax,0xf0305004

	// Enable local APIC; set spurious interrupt vector.
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0107451:	ba 27 01 00 00       	mov    $0x127,%edx
f0107456:	b8 3c 00 00 00       	mov    $0x3c,%eax
f010745b:	e8 81 ff ff ff       	call   f01073e1 <lapicw>

	// The timer repeatedly counts down at bus frequency
	// from lapic[TICR] and then issues an interrupt.  
	// If we cared more about precise timekeeping,
	// TICR would be calibrated using an external time source.
	lapicw(TDCR, X1);
f0107460:	ba 0b 00 00 00       	mov    $0xb,%edx
f0107465:	b8 f8 00 00 00       	mov    $0xf8,%eax
f010746a:	e8 72 ff ff ff       	call   f01073e1 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f010746f:	ba 20 00 02 00       	mov    $0x20020,%edx
f0107474:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0107479:	e8 63 ff ff ff       	call   f01073e1 <lapicw>
	lapicw(TICR, 10000000); 
f010747e:	ba 80 96 98 00       	mov    $0x989680,%edx
f0107483:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0107488:	e8 54 ff ff ff       	call   f01073e1 <lapicw>
	//
	// According to Intel MP Specification, the BIOS should initialize
	// BSP's local APIC in Virtual Wire Mode, in which 8259A's
	// INTR is virtually connected to BSP's LINTIN0. In this mode,
	// we do not need to program the IOAPIC.
	if (thiscpu != bootcpu)
f010748d:	e8 67 ff ff ff       	call   f01073f9 <cpunum>
f0107492:	6b c0 74             	imul   $0x74,%eax,%eax
f0107495:	05 20 40 2c f0       	add    $0xf02c4020,%eax
f010749a:	39 05 c0 43 2c f0    	cmp    %eax,0xf02c43c0
f01074a0:	74 0f                	je     f01074b1 <lapic_init+0x9d>
		lapicw(LINT0, MASKED);
f01074a2:	ba 00 00 01 00       	mov    $0x10000,%edx
f01074a7:	b8 d4 00 00 00       	mov    $0xd4,%eax
f01074ac:	e8 30 ff ff ff       	call   f01073e1 <lapicw>

	// Disable NMI (LINT1) on all CPUs
	lapicw(LINT1, MASKED);
f01074b1:	ba 00 00 01 00       	mov    $0x10000,%edx
f01074b6:	b8 d8 00 00 00       	mov    $0xd8,%eax
f01074bb:	e8 21 ff ff ff       	call   f01073e1 <lapicw>

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f01074c0:	a1 04 50 30 f0       	mov    0xf0305004,%eax
f01074c5:	8b 40 30             	mov    0x30(%eax),%eax
f01074c8:	c1 e8 10             	shr    $0x10,%eax
f01074cb:	3c 03                	cmp    $0x3,%al
f01074cd:	76 0f                	jbe    f01074de <lapic_init+0xca>
		lapicw(PCINT, MASKED);
f01074cf:	ba 00 00 01 00       	mov    $0x10000,%edx
f01074d4:	b8 d0 00 00 00       	mov    $0xd0,%eax
f01074d9:	e8 03 ff ff ff       	call   f01073e1 <lapicw>

	// Map error interrupt to IRQ_ERROR.
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f01074de:	ba 33 00 00 00       	mov    $0x33,%edx
f01074e3:	b8 dc 00 00 00       	mov    $0xdc,%eax
f01074e8:	e8 f4 fe ff ff       	call   f01073e1 <lapicw>

	// Clear error status register (requires back-to-back writes).
	lapicw(ESR, 0);
f01074ed:	ba 00 00 00 00       	mov    $0x0,%edx
f01074f2:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01074f7:	e8 e5 fe ff ff       	call   f01073e1 <lapicw>
	lapicw(ESR, 0);
f01074fc:	ba 00 00 00 00       	mov    $0x0,%edx
f0107501:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0107506:	e8 d6 fe ff ff       	call   f01073e1 <lapicw>

	// Ack any outstanding interrupts.
	lapicw(EOI, 0);
f010750b:	ba 00 00 00 00       	mov    $0x0,%edx
f0107510:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0107515:	e8 c7 fe ff ff       	call   f01073e1 <lapicw>

	// Send an Init Level De-Assert to synchronize arbitration ID's.
	lapicw(ICRHI, 0);
f010751a:	ba 00 00 00 00       	mov    $0x0,%edx
f010751f:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0107524:	e8 b8 fe ff ff       	call   f01073e1 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0107529:	ba 00 85 08 00       	mov    $0x88500,%edx
f010752e:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107533:	e8 a9 fe ff ff       	call   f01073e1 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0107538:	8b 15 04 50 30 f0    	mov    0xf0305004,%edx
f010753e:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0107544:	f6 c4 10             	test   $0x10,%ah
f0107547:	75 f5                	jne    f010753e <lapic_init+0x12a>
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
f0107549:	ba 00 00 00 00       	mov    $0x0,%edx
f010754e:	b8 20 00 00 00       	mov    $0x20,%eax
f0107553:	e8 89 fe ff ff       	call   f01073e1 <lapicw>
}
f0107558:	c9                   	leave  
f0107559:	f3 c3                	repz ret 

f010755b <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f010755b:	83 3d 04 50 30 f0 00 	cmpl   $0x0,0xf0305004
f0107562:	74 13                	je     f0107577 <lapic_eoi+0x1c>
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f0107564:	55                   	push   %ebp
f0107565:	89 e5                	mov    %esp,%ebp
	if (lapic)
		lapicw(EOI, 0);
f0107567:	ba 00 00 00 00       	mov    $0x0,%edx
f010756c:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0107571:	e8 6b fe ff ff       	call   f01073e1 <lapicw>
}
f0107576:	5d                   	pop    %ebp
f0107577:	f3 c3                	repz ret 

f0107579 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0107579:	55                   	push   %ebp
f010757a:	89 e5                	mov    %esp,%ebp
f010757c:	56                   	push   %esi
f010757d:	53                   	push   %ebx
f010757e:	83 ec 10             	sub    $0x10,%esp
f0107581:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0107584:	8b 75 0c             	mov    0xc(%ebp),%esi
f0107587:	ba 70 00 00 00       	mov    $0x70,%edx
f010758c:	b8 0f 00 00 00       	mov    $0xf,%eax
f0107591:	ee                   	out    %al,(%dx)
f0107592:	b2 71                	mov    $0x71,%dl
f0107594:	b8 0a 00 00 00       	mov    $0xa,%eax
f0107599:	ee                   	out    %al,(%dx)
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010759a:	83 3d 9c 3e 2c f0 00 	cmpl   $0x0,0xf02c3e9c
f01075a1:	75 24                	jne    f01075c7 <lapic_startap+0x4e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01075a3:	c7 44 24 0c 67 04 00 	movl   $0x467,0xc(%esp)
f01075aa:	00 
f01075ab:	c7 44 24 08 08 87 10 	movl   $0xf0108708,0x8(%esp)
f01075b2:	f0 
f01075b3:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
f01075ba:	00 
f01075bb:	c7 04 24 bb a6 10 f0 	movl   $0xf010a6bb,(%esp)
f01075c2:	e8 d6 8a ff ff       	call   f010009d <_panic>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f01075c7:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f01075ce:	00 00 
	wrv[1] = addr >> 4;
f01075d0:	89 f0                	mov    %esi,%eax
f01075d2:	c1 e8 04             	shr    $0x4,%eax
f01075d5:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f01075db:	c1 e3 18             	shl    $0x18,%ebx
f01075de:	89 da                	mov    %ebx,%edx
f01075e0:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01075e5:	e8 f7 fd ff ff       	call   f01073e1 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f01075ea:	ba 00 c5 00 00       	mov    $0xc500,%edx
f01075ef:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01075f4:	e8 e8 fd ff ff       	call   f01073e1 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f01075f9:	ba 00 85 00 00       	mov    $0x8500,%edx
f01075fe:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107603:	e8 d9 fd ff ff       	call   f01073e1 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0107608:	c1 ee 0c             	shr    $0xc,%esi
f010760b:	81 ce 00 06 00 00    	or     $0x600,%esi
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0107611:	89 da                	mov    %ebx,%edx
f0107613:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0107618:	e8 c4 fd ff ff       	call   f01073e1 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f010761d:	89 f2                	mov    %esi,%edx
f010761f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107624:	e8 b8 fd ff ff       	call   f01073e1 <lapicw>
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0107629:	89 da                	mov    %ebx,%edx
f010762b:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0107630:	e8 ac fd ff ff       	call   f01073e1 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0107635:	89 f2                	mov    %esi,%edx
f0107637:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010763c:	e8 a0 fd ff ff       	call   f01073e1 <lapicw>
		microdelay(200);
	}
}
f0107641:	83 c4 10             	add    $0x10,%esp
f0107644:	5b                   	pop    %ebx
f0107645:	5e                   	pop    %esi
f0107646:	5d                   	pop    %ebp
f0107647:	c3                   	ret    

f0107648 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0107648:	55                   	push   %ebp
f0107649:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f010764b:	8b 55 08             	mov    0x8(%ebp),%edx
f010764e:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0107654:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107659:	e8 83 fd ff ff       	call   f01073e1 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f010765e:	8b 15 04 50 30 f0    	mov    0xf0305004,%edx
f0107664:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010766a:	f6 c4 10             	test   $0x10,%ah
f010766d:	75 f5                	jne    f0107664 <lapic_ipi+0x1c>
		;
}
f010766f:	5d                   	pop    %ebp
f0107670:	c3                   	ret    

f0107671 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0107671:	55                   	push   %ebp
f0107672:	89 e5                	mov    %esp,%ebp
f0107674:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0107677:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f010767d:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107680:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0107683:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f010768a:	5d                   	pop    %ebp
f010768b:	c3                   	ret    

f010768c <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f010768c:	55                   	push   %ebp
f010768d:	89 e5                	mov    %esp,%ebp
f010768f:	56                   	push   %esi
f0107690:	53                   	push   %ebx
f0107691:	83 ec 20             	sub    $0x20,%esp
f0107694:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f0107697:	83 3b 00             	cmpl   $0x0,(%ebx)
f010769a:	75 07                	jne    f01076a3 <spin_lock+0x17>
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f010769c:	ba 01 00 00 00       	mov    $0x1,%edx
f01076a1:	eb 42                	jmp    f01076e5 <spin_lock+0x59>
f01076a3:	8b 73 08             	mov    0x8(%ebx),%esi
f01076a6:	e8 4e fd ff ff       	call   f01073f9 <cpunum>
f01076ab:	6b c0 74             	imul   $0x74,%eax,%eax
f01076ae:	05 20 40 2c f0       	add    $0xf02c4020,%eax
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f01076b3:	39 c6                	cmp    %eax,%esi
f01076b5:	75 e5                	jne    f010769c <spin_lock+0x10>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f01076b7:	8b 5b 04             	mov    0x4(%ebx),%ebx
f01076ba:	e8 3a fd ff ff       	call   f01073f9 <cpunum>
f01076bf:	89 5c 24 10          	mov    %ebx,0x10(%esp)
f01076c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01076c7:	c7 44 24 08 c8 a6 10 	movl   $0xf010a6c8,0x8(%esp)
f01076ce:	f0 
f01076cf:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
f01076d6:	00 
f01076d7:	c7 04 24 2a a7 10 f0 	movl   $0xf010a72a,(%esp)
f01076de:	e8 ba 89 ff ff       	call   f010009d <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f01076e3:	f3 90                	pause  
f01076e5:	89 d0                	mov    %edx,%eax
f01076e7:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f01076ea:	85 c0                	test   %eax,%eax
f01076ec:	75 f5                	jne    f01076e3 <spin_lock+0x57>
		asm volatile ("pause");

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f01076ee:	e8 06 fd ff ff       	call   f01073f9 <cpunum>
f01076f3:	6b c0 74             	imul   $0x74,%eax,%eax
f01076f6:	05 20 40 2c f0       	add    $0xf02c4020,%eax
f01076fb:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f01076fe:	83 c3 0c             	add    $0xc,%ebx
get_caller_pcs(uint32_t pcs[])
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
f0107701:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0107703:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0107708:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f010770e:	76 12                	jbe    f0107722 <spin_lock+0x96>
			break;
		pcs[i] = ebp[1];          // saved %eip
f0107710:	8b 4a 04             	mov    0x4(%edx),%ecx
f0107713:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0107716:	8b 12                	mov    (%edx),%edx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0107718:	83 c0 01             	add    $0x1,%eax
f010771b:	83 f8 0a             	cmp    $0xa,%eax
f010771e:	75 e8                	jne    f0107708 <spin_lock+0x7c>
f0107720:	eb 0f                	jmp    f0107731 <spin_lock+0xa5>
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
		pcs[i] = 0;
f0107722:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
f0107729:	83 c0 01             	add    $0x1,%eax
f010772c:	83 f8 09             	cmp    $0x9,%eax
f010772f:	7e f1                	jle    f0107722 <spin_lock+0x96>
	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
	get_caller_pcs(lk->pcs);
#endif
}
f0107731:	83 c4 20             	add    $0x20,%esp
f0107734:	5b                   	pop    %ebx
f0107735:	5e                   	pop    %esi
f0107736:	5d                   	pop    %ebp
f0107737:	c3                   	ret    

f0107738 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0107738:	55                   	push   %ebp
f0107739:	89 e5                	mov    %esp,%ebp
f010773b:	57                   	push   %edi
f010773c:	56                   	push   %esi
f010773d:	53                   	push   %ebx
f010773e:	83 ec 6c             	sub    $0x6c,%esp
f0107741:	8b 75 08             	mov    0x8(%ebp),%esi

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f0107744:	83 3e 00             	cmpl   $0x0,(%esi)
f0107747:	74 18                	je     f0107761 <spin_unlock+0x29>
f0107749:	8b 5e 08             	mov    0x8(%esi),%ebx
f010774c:	e8 a8 fc ff ff       	call   f01073f9 <cpunum>
f0107751:	6b c0 74             	imul   $0x74,%eax,%eax
f0107754:	05 20 40 2c f0       	add    $0xf02c4020,%eax
// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
f0107759:	39 c3                	cmp    %eax,%ebx
f010775b:	0f 84 ce 00 00 00    	je     f010782f <spin_unlock+0xf7>
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0107761:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
f0107768:	00 
f0107769:	8d 46 0c             	lea    0xc(%esi),%eax
f010776c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107770:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0107773:	89 1c 24             	mov    %ebx,(%esp)
f0107776:	e8 79 f6 ff ff       	call   f0106df4 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f010777b:	8b 46 08             	mov    0x8(%esi),%eax
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f010777e:	0f b6 38             	movzbl (%eax),%edi
f0107781:	8b 76 04             	mov    0x4(%esi),%esi
f0107784:	e8 70 fc ff ff       	call   f01073f9 <cpunum>
f0107789:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010778d:	89 74 24 08          	mov    %esi,0x8(%esp)
f0107791:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107795:	c7 04 24 f4 a6 10 f0 	movl   $0xf010a6f4,(%esp)
f010779c:	e8 86 d0 ff ff       	call   f0104827 <cprintf>
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01077a1:	8d 7d a8             	lea    -0x58(%ebp),%edi
f01077a4:	eb 65                	jmp    f010780b <spin_unlock+0xd3>
f01077a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01077aa:	89 04 24             	mov    %eax,(%esp)
f01077ad:	e8 61 ea ff ff       	call   f0106213 <debuginfo_eip>
f01077b2:	85 c0                	test   %eax,%eax
f01077b4:	78 39                	js     f01077ef <spin_unlock+0xb7>
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
f01077b6:	8b 06                	mov    (%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f01077b8:	89 c2                	mov    %eax,%edx
f01077ba:	2b 55 b8             	sub    -0x48(%ebp),%edx
f01077bd:	89 54 24 18          	mov    %edx,0x18(%esp)
f01077c1:	8b 55 b0             	mov    -0x50(%ebp),%edx
f01077c4:	89 54 24 14          	mov    %edx,0x14(%esp)
f01077c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
f01077cb:	89 54 24 10          	mov    %edx,0x10(%esp)
f01077cf:	8b 55 ac             	mov    -0x54(%ebp),%edx
f01077d2:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01077d6:	8b 55 a8             	mov    -0x58(%ebp),%edx
f01077d9:	89 54 24 08          	mov    %edx,0x8(%esp)
f01077dd:	89 44 24 04          	mov    %eax,0x4(%esp)
f01077e1:	c7 04 24 3a a7 10 f0 	movl   $0xf010a73a,(%esp)
f01077e8:	e8 3a d0 ff ff       	call   f0104827 <cprintf>
f01077ed:	eb 12                	jmp    f0107801 <spin_unlock+0xc9>
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
f01077ef:	8b 06                	mov    (%esi),%eax
f01077f1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01077f5:	c7 04 24 51 a7 10 f0 	movl   $0xf010a751,(%esp)
f01077fc:	e8 26 d0 ff ff       	call   f0104827 <cprintf>
f0107801:	83 c3 04             	add    $0x4,%ebx
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
f0107804:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0107807:	39 c3                	cmp    %eax,%ebx
f0107809:	74 08                	je     f0107813 <spin_unlock+0xdb>
f010780b:	89 de                	mov    %ebx,%esi
f010780d:	8b 03                	mov    (%ebx),%eax
f010780f:	85 c0                	test   %eax,%eax
f0107811:	75 93                	jne    f01077a6 <spin_unlock+0x6e>
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
f0107813:	c7 44 24 08 59 a7 10 	movl   $0xf010a759,0x8(%esp)
f010781a:	f0 
f010781b:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
f0107822:	00 
f0107823:	c7 04 24 2a a7 10 f0 	movl   $0xf010a72a,(%esp)
f010782a:	e8 6e 88 ff ff       	call   f010009d <_panic>
	}

	lk->pcs[0] = 0;
f010782f:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0107836:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
f010783d:	b8 00 00 00 00       	mov    $0x0,%eax
f0107842:	f0 87 06             	lock xchg %eax,(%esi)
	// Paper says that Intel 64 and IA-32 will not move a load
	// after a store. So lock->locked = 0 would work here.
	// The xchg being asm volatile ensures gcc emits it after
	// the above assignments (and after the critical section).
	xchg(&lk->locked, 0);
}
f0107845:	83 c4 6c             	add    $0x6c,%esp
f0107848:	5b                   	pop    %ebx
f0107849:	5e                   	pop    %esi
f010784a:	5f                   	pop    %edi
f010784b:	5d                   	pop    %ebp
f010784c:	c3                   	ret    

f010784d <get_mac>:
	rcv_init();
	get_mac(data);
}

int get_mac(uint8_t *data)
{
f010784d:	55                   	push   %ebp
f010784e:	89 e5                	mov    %esp,%ebp
f0107850:	57                   	push   %edi
f0107851:	56                   	push   %esi
f0107852:	53                   	push   %ebx
f0107853:	83 ec 1c             	sub    $0x1c,%esp
	uint16_t mac[3];
	int i=0;
	
	for(i=0;i<3;i++)
f0107856:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		nw_mmio[E1000_EERD/sizeof(uint32_t)] = 0;
f010785b:	8b 15 80 3e 2c f0    	mov    0xf02c3e80,%edx
f0107861:	c7 42 14 00 00 00 00 	movl   $0x0,0x14(%edx)
		nw_mmio[E1000_EERD/sizeof(uint32_t)] |= (i<<E1000_EEPROM_RW_ADDR_SHIFT);
f0107868:	8b 42 14             	mov    0x14(%edx),%eax
f010786b:	89 d9                	mov    %ebx,%ecx
f010786d:	c1 e1 08             	shl    $0x8,%ecx
f0107870:	09 c8                	or     %ecx,%eax
f0107872:	89 42 14             	mov    %eax,0x14(%edx)
		nw_mmio[E1000_EERD/sizeof(uint32_t)] |= E1000_EEPROM_RW_REG_START;
f0107875:	8b 42 14             	mov    0x14(%edx),%eax
f0107878:	83 c8 01             	or     $0x1,%eax
f010787b:	89 42 14             	mov    %eax,0x14(%edx)
		while(!(nw_mmio[E1000_EERD/sizeof(uint32_t)] & (1<<4)));
f010787e:	8b 42 14             	mov    0x14(%edx),%eax
f0107881:	a8 10                	test   $0x10,%al
f0107883:	74 f9                	je     f010787e <get_mac+0x31>
		//cprintf("\nmac:%x",nw_mmio[E1000_EERD/sizeof(uint32_t)]);
		mac[i] = nw_mmio[E1000_EERD/sizeof(uint32_t)]>>16;
f0107885:	8b 72 14             	mov    0x14(%edx),%esi
f0107888:	c1 ee 10             	shr    $0x10,%esi
		cprintf("\nmac-i:%d : %x",i,(mac[i]&0xff00)>>8);
f010788b:	89 f7                	mov    %esi,%edi
f010788d:	66 c1 ef 08          	shr    $0x8,%di
f0107891:	0f b7 c7             	movzwl %di,%eax
f0107894:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107898:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010789c:	c7 04 24 71 a7 10 f0 	movl   $0xf010a771,(%esp)
f01078a3:	e8 7f cf ff ff       	call   f0104827 <cprintf>
		data[(2*i)+1] = ((mac[i]&0xff00)>>8);
f01078a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01078ab:	89 f8                	mov    %edi,%eax
f01078ad:	88 44 59 01          	mov    %al,0x1(%ecx,%ebx,2)
		data[(2*i)] = mac[i] & 0xff;
f01078b1:	89 f0                	mov    %esi,%eax
f01078b3:	88 04 59             	mov    %al,(%ecx,%ebx,2)
int get_mac(uint8_t *data)
{
	uint16_t mac[3];
	int i=0;
	
	for(i=0;i<3;i++)
f01078b6:	83 c3 01             	add    $0x1,%ebx
f01078b9:	83 fb 03             	cmp    $0x3,%ebx
f01078bc:	75 9d                	jne    f010785b <get_mac+0xe>
		cprintf("\nmac-i:%d : %x",i,(mac[i]&0xff00)>>8);
		data[(2*i)+1] = ((mac[i]&0xff00)>>8);
		data[(2*i)] = mac[i] & 0xff;
	}
	return 0;
}
f01078be:	b8 00 00 00 00       	mov    $0x0,%eax
f01078c3:	83 c4 1c             	add    $0x1c,%esp
f01078c6:	5b                   	pop    %ebx
f01078c7:	5e                   	pop    %esi
f01078c8:	5f                   	pop    %edi
f01078c9:	5d                   	pop    %ebp
f01078ca:	c3                   	ret    

f01078cb <nw_init>:
volatile uint32_t *nw_mmio = NULL;
char txd_buffer[E1000_TXD_TOTAL][E1000_TXD_BUFFER_SIZE];
char rxd_buffer[E1000_RXD_TOTAL][E1000_RXD_BUFFER_SIZE];

void nw_init()
{
f01078cb:	55                   	push   %ebp
f01078cc:	89 e5                	mov    %esp,%ebp
f01078ce:	56                   	push   %esi
f01078cf:	53                   	push   %ebx
f01078d0:	83 ec 20             	sub    $0x20,%esp
{
	
	//1. set TDBAL to assigned descriptor array memory
	//address should be 16 byte aligned
	int i=0;
	memset(tx_desc, 0, sizeof(struct e1000_tx_desc)*E1000_TXD_TOTAL);
f01078d3:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
f01078da:	00 
f01078db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01078e2:	00 
f01078e3:	c7 04 24 20 50 34 f0 	movl   $0xf0345020,(%esp)
f01078ea:	e8 b8 f4 ff ff       	call   f0106da7 <memset>
f01078ef:	be 20 4f 37 f0       	mov    $0xf0374f20,%esi
f01078f4:	bb 20 58 34 f0       	mov    $0xf0345820,%ebx
	for(i=0;i<E1000_TXD_TOTAL;i++)
	{
		memset(&txd_buffer[i], 0, E1000_TXD_BUFFER_SIZE);
f01078f9:	c7 44 24 08 ee 05 00 	movl   $0x5ee,0x8(%esp)
f0107900:	00 
f0107901:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107908:	00 
f0107909:	89 1c 24             	mov    %ebx,(%esp)
f010790c:	e8 96 f4 ff ff       	call   f0106da7 <memset>
f0107911:	81 c3 ee 05 00 00    	add    $0x5ee,%ebx
	
	//1. set TDBAL to assigned descriptor array memory
	//address should be 16 byte aligned
	int i=0;
	memset(tx_desc, 0, sizeof(struct e1000_tx_desc)*E1000_TXD_TOTAL);
	for(i=0;i<E1000_TXD_TOTAL;i++)
f0107917:	39 f3                	cmp    %esi,%ebx
f0107919:	75 de                	jne    f01078f9 <nw_init+0x2e>
	{
		memset(&txd_buffer[i], 0, E1000_TXD_BUFFER_SIZE);
	}

	nw_mmio[E1000_TDBAL/sizeof(uint32_t)] = PADDR(tx_desc);
f010791b:	a1 80 3e 2c f0       	mov    0xf02c3e80,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0107920:	ba 20 50 34 f0       	mov    $0xf0345020,%edx
f0107925:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f010792b:	77 20                	ja     f010794d <nw_init+0x82>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010792d:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0107931:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0107938:	f0 
f0107939:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
f0107940:	00 
f0107941:	c7 04 24 80 a7 10 f0 	movl   $0xf010a780,(%esp)
f0107948:	e8 50 87 ff ff       	call   f010009d <_panic>
f010794d:	c7 80 00 38 00 00 20 	movl   $0x345020,0x3800(%eax)
f0107954:	50 34 00 
	nw_mmio[E1000_TDBAH/sizeof(uint32_t)] = 0;
f0107957:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
f010795e:	00 00 00 
	// what do you mean by register should be 128 byte aligned
	//2. set TDLEN to size of descriptor ring. should be multiple of 128
	//TDLEN ignores first 7 bits
	nw_mmio[E1000_TDLEN/sizeof(uint32_t)] = (sizeof(struct e1000_tx_desc)*E1000_TXD_TOTAL)<<7;
f0107961:	c7 80 08 38 00 00 00 	movl   $0x40000,0x3808(%eax)
f0107968:	00 04 00 
f010796b:	ba 20 50 34 f0       	mov    $0xf0345020,%edx
f0107970:	b9 20 58 34 f0       	mov    $0xf0345820,%ecx
	int i;
	//1. initialize buffer address of tx_desc
	for(i=0;i<E1000_TXD_TOTAL;i++)
	{
		desc = &tx_desc[i];
		desc->buffer_addr=0;
f0107975:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
f010797b:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0107982:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0107988:	77 20                	ja     f01079aa <nw_init+0xdf>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010798a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f010798e:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0107995:	f0 
f0107996:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
f010799d:	00 
f010799e:	c7 04 24 80 a7 10 f0 	movl   $0xf010a780,(%esp)
f01079a5:	e8 f3 86 ff ff       	call   f010009d <_panic>
f01079aa:	8d 99 00 00 00 10    	lea    0x10000000(%ecx),%ebx
		desc->buffer_addr = PADDR(&txd_buffer[i]);
f01079b0:	89 1a                	mov    %ebx,(%edx)
f01079b2:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
		desc->lower.flags.cmd = (1<<3);
f01079b9:	c6 42 0b 08          	movb   $0x8,0xb(%edx)
		desc->lower.flags.length = 0;
f01079bd:	66 c7 42 08 00 00    	movw   $0x0,0x8(%edx)
		desc->lower.flags.cso = 0;
f01079c3:	c6 42 0a 00          	movb   $0x0,0xa(%edx)
		desc->upper.fields.status = 1;
f01079c7:	c6 42 0c 01          	movb   $0x1,0xc(%edx)
		desc->upper.fields.css = 0;
f01079cb:	c6 42 0d 00          	movb   $0x0,0xd(%edx)
f01079cf:	81 c1 ee 05 00 00    	add    $0x5ee,%ecx
f01079d5:	83 c2 10             	add    $0x10,%edx
static void txd_setup()
{
	struct e1000_tx_desc *desc;
	int i;
	//1. initialize buffer address of tx_desc
	for(i=0;i<E1000_TXD_TOTAL;i++)
f01079d8:	39 ce                	cmp    %ecx,%esi
f01079da:	75 99                	jne    f0107975 <nw_init+0xaa>
	//2. set TDLEN to size of descriptor ring. should be multiple of 128
	//TDLEN ignores first 7 bits
	nw_mmio[E1000_TDLEN/sizeof(uint32_t)] = (sizeof(struct e1000_tx_desc)*E1000_TXD_TOTAL)<<7;
	txd_setup();
	//3. initialize TDH/TDT to 0
	nw_mmio[E1000_TDH/sizeof(uint32_t)] = 0;
f01079dc:	c7 80 10 38 00 00 00 	movl   $0x0,0x3810(%eax)
f01079e3:	00 00 00 
	nw_mmio[E1000_TDT/sizeof(uint32_t)] = 0;
f01079e6:	c7 80 18 38 00 00 00 	movl   $0x0,0x3818(%eax)
f01079ed:	00 00 00 
	//4. set TCTL.EN bit = 1
	nw_mmio[E1000_TCTL/sizeof(uint32_t)] |= E1000_TCTL_EN;
f01079f0:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f01079f6:	83 ca 02             	or     $0x2,%edx
f01079f9:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	//5. set TCTL.PSP bit = 1
	nw_mmio[E1000_TCTL/sizeof(uint32_t)] |= E1000_TCTL_PSP;
f01079ff:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f0107a05:	83 ca 08             	or     $0x8,%edx
f0107a08:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	nw_mmio[E1000_TCTL/sizeof(uint32_t)] |= (E1000_TCTL_CT & (0x10<<4));
f0107a0e:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f0107a14:	80 ce 01             	or     $0x1,%dh
f0107a17:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	//6. set TCTL.COLD = 0x40
	nw_mmio[E1000_TCTL/sizeof(uint32_t)] |= (E1000_TCTL_COLD & (0x40<<12));
f0107a1d:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f0107a23:	81 ca 00 00 04 00    	or     $0x40000,%edx
f0107a29:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	//7. set E1000_TIPG /* TX Inter-packet gap -RW */
	nw_mmio[E1000_TIPG/sizeof(uint32_t)] = 10|(8<<10)|(6<<20);
f0107a2f:	c7 80 10 04 00 00 0a 	movl   $0x60200a,0x410(%eax)
f0107a36:	20 60 00 

static void rcv_init()
{
	int i=0;
	//1. setting the MAC address 52:54:00:12:34:36
	memset(rx_desc, 0, sizeof(struct e1000_rx_desc)*E1000_RXD_TOTAL);
f0107a39:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
f0107a40:	00 
f0107a41:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107a48:	00 
f0107a49:	c7 04 24 20 4f 37 f0 	movl   $0xf0374f20,(%esp)
f0107a50:	e8 52 f3 ff ff       	call   f0106da7 <memset>
f0107a55:	bb 20 50 34 f0       	mov    $0xf0345020,%ebx
f0107a5a:	be 20 50 30 f0       	mov    $0xf0305020,%esi
	for(i=0;i<E1000_RXD_TOTAL;i++)
	{
		memset(&rxd_buffer[i], 0, E1000_RXD_BUFFER_SIZE);
f0107a5f:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
f0107a66:	00 
f0107a67:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107a6e:	00 
f0107a6f:	89 34 24             	mov    %esi,(%esp)
f0107a72:	e8 30 f3 ff ff       	call   f0106da7 <memset>
f0107a77:	81 c6 00 08 00 00    	add    $0x800,%esi
static void rcv_init()
{
	int i=0;
	//1. setting the MAC address 52:54:00:12:34:36
	memset(rx_desc, 0, sizeof(struct e1000_rx_desc)*E1000_RXD_TOTAL);
	for(i=0;i<E1000_RXD_TOTAL;i++)
f0107a7d:	39 de                	cmp    %ebx,%esi
f0107a7f:	75 de                	jne    f0107a5f <nw_init+0x194>
	{
		memset(&rxd_buffer[i], 0, E1000_RXD_BUFFER_SIZE);
	}
	nw_mmio[E1000_RAL/sizeof(uint32_t)] = LOW_MAC_ADDR;
f0107a81:	a1 80 3e 2c f0       	mov    0xf02c3e80,%eax
f0107a86:	c7 80 00 54 00 00 52 	movl   $0x12005452,0x5400(%eax)
f0107a8d:	54 00 12 
	nw_mmio[E1000_RAH/sizeof(uint32_t)] = HIGH_MAC_ADDR;
f0107a90:	c7 80 04 54 00 00 34 	movl   $0x5634,0x5404(%eax)
f0107a97:	56 00 00 
	nw_mmio[E1000_RAH/sizeof(uint32_t)] |= 1<<31;
f0107a9a:	8b 90 04 54 00 00    	mov    0x5404(%eax),%edx
f0107aa0:	81 ca 00 00 00 80    	or     $0x80000000,%edx
f0107aa6:	89 90 04 54 00 00    	mov    %edx,0x5404(%eax)
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0107aac:	ba 20 4f 37 f0       	mov    $0xf0374f20,%edx
f0107ab1:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0107ab7:	77 20                	ja     f0107ad9 <nw_init+0x20e>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0107ab9:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0107abd:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0107ac4:	f0 
f0107ac5:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
f0107acc:	00 
f0107acd:	c7 04 24 80 a7 10 f0 	movl   $0xf010a780,(%esp)
f0107ad4:	e8 c4 85 ff ff       	call   f010009d <_panic>

	//3. IMS registers pg. 297 - > RXT, RXO, RXDMT, RXSEQ, LSC

	//4. Allocate a region of memory for the receive descriptor list
	//address should be 16 byte aligned
	nw_mmio[E1000_RDBAL/sizeof(uint32_t)] = PADDR(rx_desc);
f0107ad9:	c7 80 00 28 00 00 20 	movl   $0x374f20,0x2800(%eax)
f0107ae0:	4f 37 00 
	nw_mmio[E1000_RDBAH/sizeof(uint32_t)] = 0;
f0107ae3:	c7 80 04 28 00 00 00 	movl   $0x0,0x2804(%eax)
f0107aea:	00 00 00 

	//5. Receive descriptor length
	nw_mmio[E1000_RDLEN/sizeof(uint32_t)] = ((sizeof(struct e1000_rx_desc)*E1000_RXD_TOTAL)<<7);
f0107aed:	c7 80 08 28 00 00 00 	movl   $0x40000,0x2808(%eax)
f0107af4:	00 04 00 
f0107af7:	ba 20 4f 37 f0       	mov    $0xf0374f20,%edx
f0107afc:	b9 20 50 30 f0       	mov    $0xf0305020,%ecx
	int i;
	//1. initialize buffer address of tx_desc
	for(i=0;i<E1000_RXD_TOTAL;i++)
	{
		desc = &rx_desc[i];
		desc->buffer_addr=0;
f0107b01:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
f0107b07:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0107b0e:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0107b14:	77 20                	ja     f0107b36 <nw_init+0x26b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0107b16:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0107b1a:	c7 44 24 08 2c 87 10 	movl   $0xf010872c,0x8(%esp)
f0107b21:	f0 
f0107b22:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
f0107b29:	00 
f0107b2a:	c7 04 24 80 a7 10 f0 	movl   $0xf010a780,(%esp)
f0107b31:	e8 67 85 ff ff       	call   f010009d <_panic>
f0107b36:	8d b1 00 00 00 10    	lea    0x10000000(%ecx),%esi
		desc->buffer_addr = PADDR(&rxd_buffer[i]);
f0107b3c:	89 32                	mov    %esi,(%edx)
f0107b3e:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
		desc->length = 0;
f0107b45:	66 c7 42 08 00 00    	movw   $0x0,0x8(%edx)
		desc->csum = 0;
f0107b4b:	66 c7 42 0a 00 00    	movw   $0x0,0xa(%edx)
		desc->status = 0;
f0107b51:	c6 42 0c 00          	movb   $0x0,0xc(%edx)
		desc->errors = 0;
f0107b55:	c6 42 0d 00          	movb   $0x0,0xd(%edx)
		desc->special = 0;
f0107b59:	66 c7 42 0e 00 00    	movw   $0x0,0xe(%edx)
f0107b5f:	81 c1 00 08 00 00    	add    $0x800,%ecx
f0107b65:	83 c2 10             	add    $0x10,%edx
static void rcv_setup()
{
	struct e1000_rx_desc *desc;
	int i;
	//1. initialize buffer address of tx_desc
	for(i=0;i<E1000_RXD_TOTAL;i++)
f0107b68:	39 cb                	cmp    %ecx,%ebx
f0107b6a:	75 95                	jne    f0107b01 <nw_init+0x236>
	nw_mmio[E1000_RDLEN/sizeof(uint32_t)] = ((sizeof(struct e1000_rx_desc)*E1000_RXD_TOTAL)<<7);
	
	//6. setting pointer to buffer in rx_descriptors
	rcv_setup();
	//7. setting head and tail.
	nw_mmio[E1000_RDH/sizeof(uint32_t)] = 0;
f0107b6c:	c7 80 10 28 00 00 00 	movl   $0x0,0x2810(%eax)
f0107b73:	00 00 00 
	nw_mmio[E1000_RDT/sizeof(uint32_t)] = 150;
f0107b76:	c7 80 18 28 00 00 96 	movl   $0x96,0x2818(%eax)
f0107b7d:	00 00 00 

	//8. Handling receive control register
	nw_mmio[E1000_RCTL/sizeof(uint32_t)] = 0;
f0107b80:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
f0107b87:	00 00 00 
	nw_mmio[E1000_RCTL/sizeof(uint32_t)] |= E1000_RCTL_EN;
f0107b8a:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f0107b90:	83 ca 02             	or     $0x2,%edx
f0107b93:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	
	nw_mmio[E1000_RCTL/sizeof(uint32_t)] |= E1000_RCTL_BAM;
f0107b99:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f0107b9f:	80 ce 80             	or     $0x80,%dh
f0107ba2:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	nw_mmio[E1000_RCTL/sizeof(uint32_t)] |= E1000_RCTL_SECRC;
f0107ba8:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f0107bae:	81 ca 00 00 00 04    	or     $0x4000000,%edx
f0107bb4:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	//initializing the transmit descriptor. Already memory allocated for 
	//transmit descriptor array and associated packet buffer in mem_init()
	uint8_t data[6];
	txd_init();
	rcv_init();
	get_mac(data);
f0107bba:	8d 45 f2             	lea    -0xe(%ebp),%eax
f0107bbd:	89 04 24             	mov    %eax,(%esp)
f0107bc0:	e8 88 fc ff ff       	call   f010784d <get_mac>
}
f0107bc5:	83 c4 20             	add    $0x20,%esp
f0107bc8:	5b                   	pop    %ebx
f0107bc9:	5e                   	pop    %esi
f0107bca:	5d                   	pop    %ebp
f0107bcb:	c3                   	ret    

f0107bcc <tx_packet>:
	}

}

int tx_packet(const char *data, size_t len)
{
f0107bcc:	55                   	push   %ebp
f0107bcd:	89 e5                	mov    %esp,%ebp
f0107bcf:	57                   	push   %edi
f0107bd0:	56                   	push   %esi
f0107bd1:	53                   	push   %ebx
f0107bd2:	83 ec 1c             	sub    $0x1c,%esp
f0107bd5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	//
	//. copy the data to buffer associated with tail descriptor
	int head_idx, tail_idx, desc_status;
	struct e1000_tx_desc *desc;
	head_idx = nw_mmio[E1000_TDH/sizeof(uint32_t)];
f0107bd8:	a1 80 3e 2c f0       	mov    0xf02c3e80,%eax
f0107bdd:	8b 90 10 38 00 00    	mov    0x3810(%eax),%edx
	tail_idx = nw_mmio[E1000_TDT/sizeof(uint32_t)];
f0107be3:	8b b0 18 38 00 00    	mov    0x3818(%eax),%esi
	//cprintf("\nhead_idx:%d\n",head_idx);
	//cprintf("\ntail_idx:%d\n",tail_idx);
	//cprintf("\ntx_packet:%.*s\n", len, data);
	desc = &tx_desc[tail_idx];
f0107be9:	89 f3                	mov    %esi,%ebx
f0107beb:	c1 e3 04             	shl    $0x4,%ebx
f0107bee:	81 c3 20 50 34 f0    	add    $0xf0345020,%ebx
	if(desc->upper.fields.status == 1)
f0107bf4:	80 7b 0c 01          	cmpb   $0x1,0xc(%ebx)
f0107bf8:	75 4e                	jne    f0107c48 <tx_packet+0x7c>
	{
		//safe to reuse the buffer associated with tail descriptor
		memcpy(&txd_buffer[tail_idx], data, len);
f0107bfa:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0107bfe:	8b 45 08             	mov    0x8(%ebp),%eax
f0107c01:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107c05:	69 c6 ee 05 00 00    	imul   $0x5ee,%esi,%eax
f0107c0b:	05 20 58 34 f0       	add    $0xf0345820,%eax
f0107c10:	89 04 24             	mov    %eax,(%esp)
f0107c13:	e8 44 f2 ff ff       	call   f0106e5c <memcpy>
		//set rs bit &in control. just for confirmation
		desc->lower.flags.cmd |= (1<<3 | 1);
f0107c18:	80 4b 0b 09          	orb    $0x9,0xb(%ebx)
		//set dd bit in status = 0
		desc->upper.fields.status = 0;
f0107c1c:	c6 43 0c 00          	movb   $0x0,0xc(%ebx)
		//set the length of descriptor
		desc->lower.flags.length = (uint16_t)len;
f0107c20:	66 89 7b 08          	mov    %di,0x8(%ebx)
		//updating TDT register
		nw_mmio[E1000_TDT/sizeof(uint32_t)] = (tail_idx+1) % E1000_TXD_TOTAL;
f0107c24:	83 c6 01             	add    $0x1,%esi
f0107c27:	89 f0                	mov    %esi,%eax
f0107c29:	c1 f8 1f             	sar    $0x1f,%eax
f0107c2c:	c1 e8 19             	shr    $0x19,%eax
f0107c2f:	01 c6                	add    %eax,%esi
f0107c31:	83 e6 7f             	and    $0x7f,%esi
f0107c34:	29 c6                	sub    %eax,%esi
f0107c36:	a1 80 3e 2c f0       	mov    0xf02c3e80,%eax
f0107c3b:	89 b0 18 38 00 00    	mov    %esi,0x3818(%eax)
		return E_TX_DESC_SUCCESS;
f0107c41:	b8 10 00 00 00       	mov    $0x10,%eax
f0107c46:	eb 05                	jmp    f0107c4d <tx_packet+0x81>
	}
	return -E_TX_DESC_FAILURE;
f0107c48:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
}
f0107c4d:	83 c4 1c             	add    $0x1c,%esp
f0107c50:	5b                   	pop    %ebx
f0107c51:	5e                   	pop    %esi
f0107c52:	5f                   	pop    %edi
f0107c53:	5d                   	pop    %ebp
f0107c54:	c3                   	ret    

f0107c55 <rx_packet>:

int rx_packet(void *rcv_buf, int *len)
{
	static int i=0;

	if(rx_desc[i].status & 1)
f0107c55:	a1 84 3e 2c f0       	mov    0xf02c3e84,%eax
f0107c5a:	89 c2                	mov    %eax,%edx
f0107c5c:	c1 e2 04             	shl    $0x4,%edx
f0107c5f:	f6 82 2c 4f 37 f0 01 	testb  $0x1,-0xfc8b0d4(%edx)
f0107c66:	74 6b                	je     f0107cd3 <rx_packet+0x7e>
	nw_mmio[E1000_RCTL/sizeof(uint32_t)] |= E1000_RCTL_SECRC;

}

int rx_packet(void *rcv_buf, int *len)
{
f0107c68:	55                   	push   %ebp
f0107c69:	89 e5                	mov    %esp,%ebp
f0107c6b:	53                   	push   %ebx
f0107c6c:	83 ec 14             	sub    $0x14,%esp
	static int i=0;

	if(rx_desc[i].status & 1)
	{
		//cprintf("\nbuffer:%s\n",&rxd_buffer[j]);
		memmove(rcv_buf, &rxd_buffer[i],rx_desc[i].length);
f0107c6f:	89 c2                	mov    %eax,%edx
f0107c71:	c1 e2 04             	shl    $0x4,%edx
f0107c74:	0f b7 92 28 4f 37 f0 	movzwl -0xfc8b0d8(%edx),%edx
f0107c7b:	89 54 24 08          	mov    %edx,0x8(%esp)
f0107c7f:	c1 e0 0b             	shl    $0xb,%eax
f0107c82:	05 20 50 30 f0       	add    $0xf0305020,%eax
f0107c87:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107c8b:	8b 45 08             	mov    0x8(%ebp),%eax
f0107c8e:	89 04 24             	mov    %eax,(%esp)
f0107c91:	e8 5e f1 ff ff       	call   f0106df4 <memmove>
		//hexdump("input: ", &rxd_buffer[i], rx_desc[i].length);
		*len = rx_desc[i].length;
f0107c96:	8b 15 84 3e 2c f0    	mov    0xf02c3e84,%edx
f0107c9c:	89 d0                	mov    %edx,%eax
f0107c9e:	c1 e0 04             	shl    $0x4,%eax
f0107ca1:	0f b7 98 28 4f 37 f0 	movzwl -0xfc8b0d8(%eax),%ebx
f0107ca8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0107cab:	89 19                	mov    %ebx,(%ecx)
		rx_desc[i].status = 0;
f0107cad:	c6 80 2c 4f 37 f0 00 	movb   $0x0,-0xfc8b0d4(%eax)
		i = (i+1)%E1000_RXD_TOTAL;
f0107cb4:	83 c2 01             	add    $0x1,%edx
f0107cb7:	89 d0                	mov    %edx,%eax
f0107cb9:	c1 f8 1f             	sar    $0x1f,%eax
f0107cbc:	c1 e8 19             	shr    $0x19,%eax
f0107cbf:	01 c2                	add    %eax,%edx
f0107cc1:	83 e2 7f             	and    $0x7f,%edx
f0107cc4:	29 c2                	sub    %eax,%edx
f0107cc6:	89 15 84 3e 2c f0    	mov    %edx,0xf02c3e84
		//cprintf("returning 0");
		return 0;
f0107ccc:	b8 00 00 00 00       	mov    $0x0,%eax
f0107cd1:	eb 06                	jmp    f0107cd9 <rx_packet+0x84>
	}
	return -1;
f0107cd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0107cd8:	c3                   	ret    
}
f0107cd9:	83 c4 14             	add    $0x14,%esp
f0107cdc:	5b                   	pop    %ebx
f0107cdd:	5d                   	pop    %ebp
f0107cde:	c3                   	ret    

f0107cdf <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0107cdf:	55                   	push   %ebp
f0107ce0:	89 e5                	mov    %esp,%ebp
f0107ce2:	57                   	push   %edi
f0107ce3:	56                   	push   %esi
f0107ce4:	53                   	push   %ebx
f0107ce5:	83 ec 2c             	sub    $0x2c,%esp
f0107ce8:	8b 7d 08             	mov    0x8(%ebp),%edi
f0107ceb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0107cee:	eb 41                	jmp    f0107d31 <pci_attach_match+0x52>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0107cf0:	39 3b                	cmp    %edi,(%ebx)
f0107cf2:	75 3a                	jne    f0107d2e <pci_attach_match+0x4f>
f0107cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107cf7:	39 56 04             	cmp    %edx,0x4(%esi)
f0107cfa:	75 32                	jne    f0107d2e <pci_attach_match+0x4f>
			int r = list[i].attachfn(pcif);
f0107cfc:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0107cff:	89 0c 24             	mov    %ecx,(%esp)
f0107d02:	ff d0                	call   *%eax
			if (r > 0)
f0107d04:	85 c0                	test   %eax,%eax
f0107d06:	7f 32                	jg     f0107d3a <pci_attach_match+0x5b>
				return r;
			if (r < 0)
f0107d08:	85 c0                	test   %eax,%eax
f0107d0a:	79 22                	jns    f0107d2e <pci_attach_match+0x4f>
				cprintf("pci_attach_match: attaching "
f0107d0c:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107d10:	8b 46 08             	mov    0x8(%esi),%eax
f0107d13:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107d17:	8b 45 0c             	mov    0xc(%ebp),%eax
f0107d1a:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107d1e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0107d22:	c7 04 24 90 a7 10 f0 	movl   $0xf010a790,(%esp)
f0107d29:	e8 f9 ca ff ff       	call   f0104827 <cprintf>
f0107d2e:	83 c3 0c             	add    $0xc,%ebx
f0107d31:	89 de                	mov    %ebx,%esi
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0107d33:	8b 43 08             	mov    0x8(%ebx),%eax
f0107d36:	85 c0                	test   %eax,%eax
f0107d38:	75 b6                	jne    f0107cf0 <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0107d3a:	83 c4 2c             	add    $0x2c,%esp
f0107d3d:	5b                   	pop    %ebx
f0107d3e:	5e                   	pop    %esi
f0107d3f:	5f                   	pop    %edi
f0107d40:	5d                   	pop    %ebp
f0107d41:	c3                   	ret    

f0107d42 <pci_conf1_set_addr>:
static void
pci_conf1_set_addr(uint32_t bus,
		   uint32_t dev,
		   uint32_t func,
		   uint32_t offset)
{
f0107d42:	55                   	push   %ebp
f0107d43:	89 e5                	mov    %esp,%ebp
f0107d45:	56                   	push   %esi
f0107d46:	53                   	push   %ebx
f0107d47:	83 ec 10             	sub    $0x10,%esp
f0107d4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f0107d4d:	3d ff 00 00 00       	cmp    $0xff,%eax
f0107d52:	76 24                	jbe    f0107d78 <pci_conf1_set_addr+0x36>
f0107d54:	c7 44 24 0c e8 a8 10 	movl   $0xf010a8e8,0xc(%esp)
f0107d5b:	f0 
f0107d5c:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0107d63:	f0 
f0107d64:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
f0107d6b:	00 
f0107d6c:	c7 04 24 f2 a8 10 f0 	movl   $0xf010a8f2,(%esp)
f0107d73:	e8 25 83 ff ff       	call   f010009d <_panic>
	assert(dev < 32);
f0107d78:	83 fa 1f             	cmp    $0x1f,%edx
f0107d7b:	76 24                	jbe    f0107da1 <pci_conf1_set_addr+0x5f>
f0107d7d:	c7 44 24 0c fd a8 10 	movl   $0xf010a8fd,0xc(%esp)
f0107d84:	f0 
f0107d85:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0107d8c:	f0 
f0107d8d:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
f0107d94:	00 
f0107d95:	c7 04 24 f2 a8 10 f0 	movl   $0xf010a8f2,(%esp)
f0107d9c:	e8 fc 82 ff ff       	call   f010009d <_panic>
	assert(func < 8);
f0107da1:	83 f9 07             	cmp    $0x7,%ecx
f0107da4:	76 24                	jbe    f0107dca <pci_conf1_set_addr+0x88>
f0107da6:	c7 44 24 0c 06 a9 10 	movl   $0xf010a906,0xc(%esp)
f0107dad:	f0 
f0107dae:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0107db5:	f0 
f0107db6:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
f0107dbd:	00 
f0107dbe:	c7 04 24 f2 a8 10 f0 	movl   $0xf010a8f2,(%esp)
f0107dc5:	e8 d3 82 ff ff       	call   f010009d <_panic>
	assert(offset < 256);
f0107dca:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0107dd0:	76 24                	jbe    f0107df6 <pci_conf1_set_addr+0xb4>
f0107dd2:	c7 44 24 0c 0f a9 10 	movl   $0xf010a90f,0xc(%esp)
f0107dd9:	f0 
f0107dda:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0107de1:	f0 
f0107de2:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
f0107de9:	00 
f0107dea:	c7 04 24 f2 a8 10 f0 	movl   $0xf010a8f2,(%esp)
f0107df1:	e8 a7 82 ff ff       	call   f010009d <_panic>
	assert((offset & 0x3) == 0);
f0107df6:	f6 c3 03             	test   $0x3,%bl
f0107df9:	74 24                	je     f0107e1f <pci_conf1_set_addr+0xdd>
f0107dfb:	c7 44 24 0c 1c a9 10 	movl   $0xf010a91c,0xc(%esp)
f0107e02:	f0 
f0107e03:	c7 44 24 08 0e 8e 10 	movl   $0xf0108e0e,0x8(%esp)
f0107e0a:	f0 
f0107e0b:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
f0107e12:	00 
f0107e13:	c7 04 24 f2 a8 10 f0 	movl   $0xf010a8f2,(%esp)
f0107e1a:	e8 7e 82 ff ff       	call   f010009d <_panic>

	uint32_t v = (1 << 31) |		// config-space
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0107e1f:	81 cb 00 00 00 80    	or     $0x80000000,%ebx
f0107e25:	c1 e1 08             	shl    $0x8,%ecx
f0107e28:	09 cb                	or     %ecx,%ebx
f0107e2a:	89 d6                	mov    %edx,%esi
f0107e2c:	c1 e6 0b             	shl    $0xb,%esi
f0107e2f:	09 f3                	or     %esi,%ebx
f0107e31:	c1 e0 10             	shl    $0x10,%eax
f0107e34:	89 c6                	mov    %eax,%esi
	assert(dev < 32);
	assert(func < 8);
	assert(offset < 256);
	assert((offset & 0x3) == 0);

	uint32_t v = (1 << 31) |		// config-space
f0107e36:	89 d8                	mov    %ebx,%eax
f0107e38:	09 f0                	or     %esi,%eax
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107e3a:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f0107e3f:	ef                   	out    %eax,(%dx)
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
	outl(pci_conf1_addr_ioport, v);
}
f0107e40:	83 c4 10             	add    $0x10,%esp
f0107e43:	5b                   	pop    %ebx
f0107e44:	5e                   	pop    %esi
f0107e45:	5d                   	pop    %ebp
f0107e46:	c3                   	ret    

f0107e47 <pci_conf_read>:

static uint32_t
pci_conf_read(struct pci_func *f, uint32_t off)
{
f0107e47:	55                   	push   %ebp
f0107e48:	89 e5                	mov    %esp,%ebp
f0107e4a:	53                   	push   %ebx
f0107e4b:	83 ec 14             	sub    $0x14,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107e4e:	8b 48 08             	mov    0x8(%eax),%ecx
f0107e51:	8b 58 04             	mov    0x4(%eax),%ebx
f0107e54:	8b 00                	mov    (%eax),%eax
f0107e56:	8b 40 04             	mov    0x4(%eax),%eax
f0107e59:	89 14 24             	mov    %edx,(%esp)
f0107e5c:	89 da                	mov    %ebx,%edx
f0107e5e:	e8 df fe ff ff       	call   f0107d42 <pci_conf1_set_addr>

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0107e63:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107e68:	ed                   	in     (%dx),%eax
	return inl(pci_conf1_data_ioport);
}
f0107e69:	83 c4 14             	add    $0x14,%esp
f0107e6c:	5b                   	pop    %ebx
f0107e6d:	5d                   	pop    %ebp
f0107e6e:	c3                   	ret    

f0107e6f <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0107e6f:	55                   	push   %ebp
f0107e70:	89 e5                	mov    %esp,%ebp
f0107e72:	57                   	push   %edi
f0107e73:	56                   	push   %esi
f0107e74:	53                   	push   %ebx
f0107e75:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
f0107e7b:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0107e7d:	c7 44 24 08 48 00 00 	movl   $0x48,0x8(%esp)
f0107e84:	00 
f0107e85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107e8c:	00 
f0107e8d:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0107e90:	89 04 24             	mov    %eax,(%esp)
f0107e93:	e8 0f ef ff ff       	call   f0106da7 <memset>
	df.bus = bus;
f0107e98:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107e9b:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
}

static int
pci_scan_bus(struct pci_bus *bus)
{
	int totaldev = 0;
f0107ea2:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f0107ea9:	00 00 00 
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0107eac:	ba 0c 00 00 00       	mov    $0xc,%edx
f0107eb1:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0107eb4:	e8 8e ff ff ff       	call   f0107e47 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0107eb9:	89 c2                	mov    %eax,%edx
f0107ebb:	c1 ea 10             	shr    $0x10,%edx
f0107ebe:	83 e2 7f             	and    $0x7f,%edx
f0107ec1:	83 fa 01             	cmp    $0x1,%edx
f0107ec4:	0f 87 6f 01 00 00    	ja     f0108039 <pci_scan_bus+0x1ca>
			continue;

		totaldev++;
f0107eca:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)

		struct pci_func f = df;
f0107ed1:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107ed6:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0107edc:	8d 75 a0             	lea    -0x60(%ebp),%esi
f0107edf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107ee1:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0107ee8:	00 00 00 
f0107eeb:	25 00 00 80 00       	and    $0x800000,%eax
f0107ef0:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
		     f.func++) {
			struct pci_func af = f;
f0107ef6:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
			continue;

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107efc:	e9 1d 01 00 00       	jmp    f010801e <pci_scan_bus+0x1af>
		     f.func++) {
			struct pci_func af = f;
f0107f01:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107f06:	89 df                	mov    %ebx,%edi
f0107f08:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f0107f0e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0107f10:	ba 00 00 00 00       	mov    $0x0,%edx
f0107f15:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0107f1b:	e8 27 ff ff ff       	call   f0107e47 <pci_conf_read>
f0107f20:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0107f26:	66 83 f8 ff          	cmp    $0xffff,%ax
f0107f2a:	0f 84 e7 00 00 00    	je     f0108017 <pci_scan_bus+0x1a8>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107f30:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0107f35:	89 d8                	mov    %ebx,%eax
f0107f37:	e8 0b ff ff ff       	call   f0107e47 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0107f3c:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0107f3f:	ba 08 00 00 00       	mov    $0x8,%edx
f0107f44:	89 d8                	mov    %ebx,%eax
f0107f46:	e8 fc fe ff ff       	call   f0107e47 <pci_conf_read>
f0107f4b:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

static void
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f0107f51:	89 c2                	mov    %eax,%edx
f0107f53:	c1 ea 18             	shr    $0x18,%edx
};

static void
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
f0107f56:	b9 30 a9 10 f0       	mov    $0xf010a930,%ecx
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f0107f5b:	83 fa 06             	cmp    $0x6,%edx
f0107f5e:	77 07                	ja     f0107f67 <pci_scan_bus+0xf8>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0107f60:	8b 0c 95 b8 a9 10 f0 	mov    -0xfef5648(,%edx,4),%ecx

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107f67:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
		class = pci_class[PCI_CLASS(f->dev_class)];

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107f6d:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f0107f71:	89 7c 24 24          	mov    %edi,0x24(%esp)
f0107f75:	89 4c 24 20          	mov    %ecx,0x20(%esp)
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f0107f79:	c1 e8 10             	shr    $0x10,%eax
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
		class = pci_class[PCI_CLASS(f->dev_class)];

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107f7c:	0f b6 c0             	movzbl %al,%eax
f0107f7f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0107f83:	89 54 24 18          	mov    %edx,0x18(%esp)
f0107f87:	89 f0                	mov    %esi,%eax
f0107f89:	c1 e8 10             	shr    $0x10,%eax
f0107f8c:	89 44 24 14          	mov    %eax,0x14(%esp)
f0107f90:	0f b7 f6             	movzwl %si,%esi
f0107f93:	89 74 24 10          	mov    %esi,0x10(%esp)
f0107f97:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
f0107f9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107fa1:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
f0107fa7:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107fab:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0107fb1:	8b 40 04             	mov    0x4(%eax),%eax
f0107fb4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107fb8:	c7 04 24 bc a7 10 f0 	movl   $0xf010a7bc,(%esp)
f0107fbf:	e8 63 c8 ff ff       	call   f0104827 <cprintf>
static int
pci_attach(struct pci_func *f)
{
	
	return
		pci_attach_match(PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), &pci_attach_class[0], f) 
f0107fc4:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
f0107fca:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0107fce:	c7 44 24 08 0c 74 12 	movl   $0xf012740c,0x8(%esp)
f0107fd5:	f0 
f0107fd6:	89 c2                	mov    %eax,%edx
f0107fd8:	c1 ea 10             	shr    $0x10,%edx
f0107fdb:	0f b6 d2             	movzbl %dl,%edx
f0107fde:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107fe2:	c1 e8 18             	shr    $0x18,%eax
f0107fe5:	89 04 24             	mov    %eax,(%esp)
f0107fe8:	e8 f2 fc ff ff       	call   f0107cdf <pci_attach_match>
		||
f0107fed:	85 c0                	test   %eax,%eax
f0107fef:	75 26                	jne    f0108017 <pci_scan_bus+0x1a8>
		pci_attach_match(PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id), &pci_attach_vendor[0], f);
f0107ff1:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
f0107ff7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0107ffb:	c7 44 24 08 f4 73 12 	movl   $0xf01273f4,0x8(%esp)
f0108002:	f0 
f0108003:	89 c2                	mov    %eax,%edx
f0108005:	c1 ea 10             	shr    $0x10,%edx
f0108008:	89 54 24 04          	mov    %edx,0x4(%esp)
f010800c:	0f b7 c0             	movzwl %ax,%eax
f010800f:	89 04 24             	mov    %eax,(%esp)
f0108012:	e8 c8 fc ff ff       	call   f0107cdf <pci_attach_match>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0108017:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
			continue;

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f010801e:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
f0108025:	19 c0                	sbb    %eax,%eax
f0108027:	83 e0 f9             	and    $0xfffffff9,%eax
f010802a:	83 c0 08             	add    $0x8,%eax
f010802d:	3b 85 18 ff ff ff    	cmp    -0xe8(%ebp),%eax
f0108033:	0f 87 c8 fe ff ff    	ja     f0107f01 <pci_scan_bus+0x92>
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0108039:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f010803c:	83 c0 01             	add    $0x1,%eax
f010803f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0108042:	83 f8 1f             	cmp    $0x1f,%eax
f0108045:	0f 86 61 fe ff ff    	jbe    f0107eac <pci_scan_bus+0x3d>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f010804b:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0108051:	81 c4 1c 01 00 00    	add    $0x11c,%esp
f0108057:	5b                   	pop    %ebx
f0108058:	5e                   	pop    %esi
f0108059:	5f                   	pop    %edi
f010805a:	5d                   	pop    %ebp
f010805b:	c3                   	ret    

f010805c <pci_bridge_attach>:
	return 1;
}

static int
pci_bridge_attach(struct pci_func *pcif)
{
f010805c:	55                   	push   %ebp
f010805d:	89 e5                	mov    %esp,%ebp
f010805f:	57                   	push   %edi
f0108060:	56                   	push   %esi
f0108061:	53                   	push   %ebx
f0108062:	83 ec 3c             	sub    $0x3c,%esp
f0108065:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0108068:	ba 1c 00 00 00       	mov    $0x1c,%edx
f010806d:	89 d8                	mov    %ebx,%eax
f010806f:	e8 d3 fd ff ff       	call   f0107e47 <pci_conf_read>
f0108074:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0108076:	ba 18 00 00 00       	mov    $0x18,%edx
f010807b:	89 d8                	mov    %ebx,%eax
f010807d:	e8 c5 fd ff ff       	call   f0107e47 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0108082:	83 e7 0f             	and    $0xf,%edi
f0108085:	83 ff 01             	cmp    $0x1,%edi
f0108088:	75 2a                	jne    f01080b4 <pci_bridge_attach+0x58>
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f010808a:	8b 43 08             	mov    0x8(%ebx),%eax
f010808d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0108091:	8b 43 04             	mov    0x4(%ebx),%eax
f0108094:	89 44 24 08          	mov    %eax,0x8(%esp)
f0108098:	8b 03                	mov    (%ebx),%eax
f010809a:	8b 40 04             	mov    0x4(%eax),%eax
f010809d:	89 44 24 04          	mov    %eax,0x4(%esp)
f01080a1:	c7 04 24 f8 a7 10 f0 	movl   $0xf010a7f8,(%esp)
f01080a8:	e8 7a c7 ff ff       	call   f0104827 <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
f01080ad:	b8 00 00 00 00       	mov    $0x0,%eax
f01080b2:	eb 67                	jmp    f010811b <pci_bridge_attach+0xbf>
f01080b4:	89 c6                	mov    %eax,%esi
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f01080b6:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f01080bd:	00 
f01080be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01080c5:	00 
f01080c6:	8d 7d e0             	lea    -0x20(%ebp),%edi
f01080c9:	89 3c 24             	mov    %edi,(%esp)
f01080cc:	e8 d6 ec ff ff       	call   f0106da7 <memset>
	nbus.parent_bridge = pcif;
f01080d1:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f01080d4:	89 f0                	mov    %esi,%eax
f01080d6:	0f b6 c4             	movzbl %ah,%eax
f01080d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f01080dc:	89 f2                	mov    %esi,%edx
f01080de:	c1 ea 10             	shr    $0x10,%edx
	memset(&nbus, 0, sizeof(nbus));
	nbus.parent_bridge = pcif;
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f01080e1:	0f b6 f2             	movzbl %dl,%esi
f01080e4:	89 74 24 14          	mov    %esi,0x14(%esp)
f01080e8:	89 44 24 10          	mov    %eax,0x10(%esp)
f01080ec:	8b 43 08             	mov    0x8(%ebx),%eax
f01080ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01080f3:	8b 43 04             	mov    0x4(%ebx),%eax
f01080f6:	89 44 24 08          	mov    %eax,0x8(%esp)
f01080fa:	8b 03                	mov    (%ebx),%eax
f01080fc:	8b 40 04             	mov    0x4(%eax),%eax
f01080ff:	89 44 24 04          	mov    %eax,0x4(%esp)
f0108103:	c7 04 24 2c a8 10 f0 	movl   $0xf010a82c,(%esp)
f010810a:	e8 18 c7 ff ff       	call   f0104827 <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);

	pci_scan_bus(&nbus);
f010810f:	89 f8                	mov    %edi,%eax
f0108111:	e8 59 fd ff ff       	call   f0107e6f <pci_scan_bus>
	return 1;
f0108116:	b8 01 00 00 00       	mov    $0x1,%eax
}
f010811b:	83 c4 3c             	add    $0x3c,%esp
f010811e:	5b                   	pop    %ebx
f010811f:	5e                   	pop    %esi
f0108120:	5f                   	pop    %edi
f0108121:	5d                   	pop    %ebp
f0108122:	c3                   	ret    

f0108123 <pci_conf_write>:
	return inl(pci_conf1_data_ioport);
}

static void
pci_conf_write(struct pci_func *f, uint32_t off, uint32_t v)
{
f0108123:	55                   	push   %ebp
f0108124:	89 e5                	mov    %esp,%ebp
f0108126:	56                   	push   %esi
f0108127:	53                   	push   %ebx
f0108128:	83 ec 10             	sub    $0x10,%esp
f010812b:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f010812d:	8b 48 08             	mov    0x8(%eax),%ecx
f0108130:	8b 70 04             	mov    0x4(%eax),%esi
f0108133:	8b 00                	mov    (%eax),%eax
f0108135:	8b 40 04             	mov    0x4(%eax),%eax
f0108138:	89 14 24             	mov    %edx,(%esp)
f010813b:	89 f2                	mov    %esi,%edx
f010813d:	e8 00 fc ff ff       	call   f0107d42 <pci_conf1_set_addr>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0108142:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0108147:	89 d8                	mov    %ebx,%eax
f0108149:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_data_ioport, v);
}
f010814a:	83 c4 10             	add    $0x10,%esp
f010814d:	5b                   	pop    %ebx
f010814e:	5e                   	pop    %esi
f010814f:	5d                   	pop    %ebp
f0108150:	c3                   	ret    

f0108151 <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0108151:	55                   	push   %ebp
f0108152:	89 e5                	mov    %esp,%ebp
f0108154:	57                   	push   %edi
f0108155:	56                   	push   %esi
f0108156:	53                   	push   %ebx
f0108157:	83 ec 4c             	sub    $0x4c,%esp
f010815a:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f010815d:	b9 07 00 00 00       	mov    $0x7,%ecx
f0108162:	ba 04 00 00 00       	mov    $0x4,%edx
f0108167:	89 f8                	mov    %edi,%eax
f0108169:	e8 b5 ff ff ff       	call   f0108123 <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f010816e:	be 10 00 00 00       	mov    $0x10,%esi
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);
f0108173:	89 f2                	mov    %esi,%edx
f0108175:	89 f8                	mov    %edi,%eax
f0108177:	e8 cb fc ff ff       	call   f0107e47 <pci_conf_read>
f010817c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		bar_width = 4;
		pci_conf_write(f, bar, 0xffffffff);
f010817f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0108184:	89 f2                	mov    %esi,%edx
f0108186:	89 f8                	mov    %edi,%eax
f0108188:	e8 96 ff ff ff       	call   f0108123 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f010818d:	89 f2                	mov    %esi,%edx
f010818f:	89 f8                	mov    %edi,%eax
f0108191:	e8 b1 fc ff ff       	call   f0107e47 <pci_conf_read>
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f0108196:	bb 04 00 00 00       	mov    $0x4,%ebx
		pci_conf_write(f, bar, 0xffffffff);
		uint32_t rv = pci_conf_read(f, bar);

		if (rv == 0)
f010819b:	85 c0                	test   %eax,%eax
f010819d:	0f 84 c1 00 00 00    	je     f0108264 <pci_func_enable+0x113>
			continue;

		int regnum = PCI_MAPREG_NUM(bar);
f01081a3:	8d 56 f0             	lea    -0x10(%esi),%edx
f01081a6:	c1 ea 02             	shr    $0x2,%edx
f01081a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f01081ac:	a8 01                	test   $0x1,%al
f01081ae:	75 2c                	jne    f01081dc <pci_func_enable+0x8b>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f01081b0:	89 c2                	mov    %eax,%edx
f01081b2:	83 e2 06             	and    $0x6,%edx
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f01081b5:	83 fa 04             	cmp    $0x4,%edx
f01081b8:	0f 94 c3             	sete   %bl
f01081bb:	0f b6 db             	movzbl %bl,%ebx
f01081be:	8d 1c 9d 04 00 00 00 	lea    0x4(,%ebx,4),%ebx
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
				bar_width = 8;

			size = PCI_MAPREG_MEM_SIZE(rv);
f01081c5:	83 e0 f0             	and    $0xfffffff0,%eax
f01081c8:	89 c2                	mov    %eax,%edx
f01081ca:	f7 da                	neg    %edx
f01081cc:	21 d0                	and    %edx,%eax
f01081ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = PCI_MAPREG_MEM_ADDR(oldv);
f01081d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01081d4:	83 e0 f0             	and    $0xfffffff0,%eax
f01081d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01081da:	eb 1a                	jmp    f01081f6 <pci_func_enable+0xa5>
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f01081dc:	83 e0 fc             	and    $0xfffffffc,%eax
f01081df:	89 c2                	mov    %eax,%edx
f01081e1:	f7 da                	neg    %edx
f01081e3:	21 d0                	and    %edx,%eax
f01081e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = PCI_MAPREG_IO_ADDR(oldv);
f01081e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01081eb:	83 e0 fc             	and    $0xfffffffc,%eax
f01081ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f01081f1:	bb 04 00 00 00       	mov    $0x4,%ebx
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f01081f6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01081f9:	89 f2                	mov    %esi,%edx
f01081fb:	89 f8                	mov    %edi,%eax
f01081fd:	e8 21 ff ff ff       	call   f0108123 <pci_conf_write>
f0108202:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0108205:	8d 04 87             	lea    (%edi,%eax,4),%eax
		f->reg_base[regnum] = base;
f0108208:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f010820b:	89 48 14             	mov    %ecx,0x14(%eax)
		f->reg_size[regnum] = size;
f010820e:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0108211:	89 50 2c             	mov    %edx,0x2c(%eax)

		if (size && !base)
f0108214:	85 c9                	test   %ecx,%ecx
f0108216:	75 4c                	jne    f0108264 <pci_func_enable+0x113>
f0108218:	85 d2                	test   %edx,%edx
f010821a:	74 48                	je     f0108264 <pci_func_enable+0x113>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f010821c:	8b 47 0c             	mov    0xc(%edi),%eax
		pci_conf_write(f, bar, oldv);
		f->reg_base[regnum] = base;
		f->reg_size[regnum] = size;

		if (size && !base)
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f010821f:	89 54 24 20          	mov    %edx,0x20(%esp)
f0108223:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0108226:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
f010822a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010822d:	89 4c 24 18          	mov    %ecx,0x18(%esp)
f0108231:	89 c2                	mov    %eax,%edx
f0108233:	c1 ea 10             	shr    $0x10,%edx
f0108236:	89 54 24 14          	mov    %edx,0x14(%esp)
f010823a:	0f b7 c0             	movzwl %ax,%eax
f010823d:	89 44 24 10          	mov    %eax,0x10(%esp)
f0108241:	8b 47 08             	mov    0x8(%edi),%eax
f0108244:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0108248:	8b 47 04             	mov    0x4(%edi),%eax
f010824b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010824f:	8b 07                	mov    (%edi),%eax
f0108251:	8b 40 04             	mov    0x4(%eax),%eax
f0108254:	89 44 24 04          	mov    %eax,0x4(%esp)
f0108258:	c7 04 24 5c a8 10 f0 	movl   $0xf010a85c,(%esp)
f010825f:	e8 c3 c5 ff ff       	call   f0104827 <cprintf>
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
f0108264:	01 de                	add    %ebx,%esi
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0108266:	83 fe 27             	cmp    $0x27,%esi
f0108269:	0f 86 04 ff ff ff    	jbe    f0108173 <pci_func_enable+0x22>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f010826f:	8b 47 0c             	mov    0xc(%edi),%eax
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0108272:	89 c2                	mov    %eax,%edx
f0108274:	c1 ea 10             	shr    $0x10,%edx
f0108277:	89 54 24 14          	mov    %edx,0x14(%esp)
f010827b:	0f b7 c0             	movzwl %ax,%eax
f010827e:	89 44 24 10          	mov    %eax,0x10(%esp)
f0108282:	8b 47 08             	mov    0x8(%edi),%eax
f0108285:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0108289:	8b 47 04             	mov    0x4(%edi),%eax
f010828c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0108290:	8b 07                	mov    (%edi),%eax
f0108292:	8b 40 04             	mov    0x4(%eax),%eax
f0108295:	89 44 24 04          	mov    %eax,0x4(%esp)
f0108299:	c7 04 24 b8 a8 10 f0 	movl   $0xf010a8b8,(%esp)
f01082a0:	e8 82 c5 ff ff       	call   f0104827 <cprintf>
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
}
f01082a5:	83 c4 4c             	add    $0x4c,%esp
f01082a8:	5b                   	pop    %ebx
f01082a9:	5e                   	pop    %esi
f01082aa:	5f                   	pop    %edi
f01082ab:	5d                   	pop    %ebp
f01082ac:	c3                   	ret    

f01082ad <pci_network_attach>:

	return totaldev;
}

static int pci_network_attach(struct pci_func *pcif)
{
f01082ad:	55                   	push   %ebp
f01082ae:	89 e5                	mov    %esp,%ebp
f01082b0:	53                   	push   %ebx
f01082b1:	83 ec 14             	sub    $0x14,%esp
f01082b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	{
		cprintf("\nbase %d :%x\n", i, pcif->reg_base[i]);
		cprintf("\nsize %d :%x\n", i, pcif->reg_size[i]);
	}
	cprintf("\nirqline:%d\n", pcif->irq_line);*/
	pci_func_enable(pcif);
f01082b7:	89 1c 24             	mov    %ebx,(%esp)
f01082ba:	e8 92 fe ff ff       	call   f0108151 <pci_func_enable>
	{
		cprintf("\nbase %d :%x\n", i, pcif->reg_base[i]);
		cprintf("\nsize %d :%x\n", i, pcif->reg_size[i]);
	}
	cprintf("\nirqline:%d\n", pcif->irq_line);*/
	nw_mmio = mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
f01082bf:	8b 43 2c             	mov    0x2c(%ebx),%eax
f01082c2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01082c6:	8b 43 14             	mov    0x14(%ebx),%eax
f01082c9:	89 04 24             	mov    %eax,(%esp)
f01082cc:	e8 1e 97 ff ff       	call   f01019ef <mmio_map_region>
f01082d1:	a3 80 3e 2c f0       	mov    %eax,0xf02c3e80
	nw_init();
f01082d6:	e8 f0 f5 ff ff       	call   f01078cb <nw_init>
	cprintf("\ntesting nw_mmio:%x\n",nw_mmio[E1000_STATUS/sizeof(uint32_t)]);
f01082db:	a1 80 3e 2c f0       	mov    0xf02c3e80,%eax
f01082e0:	8b 40 08             	mov    0x8(%eax),%eax
f01082e3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01082e7:	c7 04 24 38 a9 10 f0 	movl   $0xf010a938,(%esp)
f01082ee:	e8 34 c5 ff ff       	call   f0104827 <cprintf>
	return 1;
}
f01082f3:	b8 01 00 00 00       	mov    $0x1,%eax
f01082f8:	83 c4 14             	add    $0x14,%esp
f01082fb:	5b                   	pop    %ebx
f01082fc:	5d                   	pop    %ebp
f01082fd:	c3                   	ret    

f01082fe <pci_init>:
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
}

int
pci_init(void)
{
f01082fe:	55                   	push   %ebp
f01082ff:	89 e5                	mov    %esp,%ebp
f0108301:	83 ec 18             	sub    $0x18,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0108304:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f010830b:	00 
f010830c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0108313:	00 
f0108314:	c7 04 24 88 3e 2c f0 	movl   $0xf02c3e88,(%esp)
f010831b:	e8 87 ea ff ff       	call   f0106da7 <memset>

	return pci_scan_bus(&root_bus);
f0108320:	b8 88 3e 2c f0       	mov    $0xf02c3e88,%eax
f0108325:	e8 45 fb ff ff       	call   f0107e6f <pci_scan_bus>
}
f010832a:	c9                   	leave  
f010832b:	c3                   	ret    

f010832c <time_init>:

static unsigned int ticks;

void
time_init(void)
{
f010832c:	55                   	push   %ebp
f010832d:	89 e5                	mov    %esp,%ebp
	ticks = 0;
f010832f:	c7 05 90 3e 2c f0 00 	movl   $0x0,0xf02c3e90
f0108336:	00 00 00 
}
f0108339:	5d                   	pop    %ebp
f010833a:	c3                   	ret    

f010833b <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f010833b:	a1 90 3e 2c f0       	mov    0xf02c3e90,%eax
f0108340:	83 c0 01             	add    $0x1,%eax
f0108343:	a3 90 3e 2c f0       	mov    %eax,0xf02c3e90
	if (ticks * 10 < ticks)
f0108348:	8d 14 80             	lea    (%eax,%eax,4),%edx
f010834b:	01 d2                	add    %edx,%edx
f010834d:	39 d0                	cmp    %edx,%eax
f010834f:	76 22                	jbe    f0108373 <time_tick+0x38>

// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
f0108351:	55                   	push   %ebp
f0108352:	89 e5                	mov    %esp,%ebp
f0108354:	83 ec 18             	sub    $0x18,%esp
	ticks++;
	if (ticks * 10 < ticks)
		panic("time_tick: time overflowed");
f0108357:	c7 44 24 08 d4 a9 10 	movl   $0xf010a9d4,0x8(%esp)
f010835e:	f0 
f010835f:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
f0108366:	00 
f0108367:	c7 04 24 ef a9 10 f0 	movl   $0xf010a9ef,(%esp)
f010836e:	e8 2a 7d ff ff       	call   f010009d <_panic>
f0108373:	f3 c3                	repz ret 

f0108375 <time_msec>:
}

unsigned int
time_msec(void)
{
f0108375:	55                   	push   %ebp
f0108376:	89 e5                	mov    %esp,%ebp
	return ticks * 10;
f0108378:	a1 90 3e 2c f0       	mov    0xf02c3e90,%eax
f010837d:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0108380:	01 c0                	add    %eax,%eax
}
f0108382:	5d                   	pop    %ebp
f0108383:	c3                   	ret    
f0108384:	66 90                	xchg   %ax,%ax
f0108386:	66 90                	xchg   %ax,%ax
f0108388:	66 90                	xchg   %ax,%ax
f010838a:	66 90                	xchg   %ax,%ax
f010838c:	66 90                	xchg   %ax,%ax
f010838e:	66 90                	xchg   %ax,%ax

f0108390 <__udivdi3>:
f0108390:	55                   	push   %ebp
f0108391:	57                   	push   %edi
f0108392:	56                   	push   %esi
f0108393:	83 ec 0c             	sub    $0xc,%esp
f0108396:	8b 44 24 28          	mov    0x28(%esp),%eax
f010839a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
f010839e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
f01083a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f01083a6:	85 c0                	test   %eax,%eax
f01083a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01083ac:	89 ea                	mov    %ebp,%edx
f01083ae:	89 0c 24             	mov    %ecx,(%esp)
f01083b1:	75 2d                	jne    f01083e0 <__udivdi3+0x50>
f01083b3:	39 e9                	cmp    %ebp,%ecx
f01083b5:	77 61                	ja     f0108418 <__udivdi3+0x88>
f01083b7:	85 c9                	test   %ecx,%ecx
f01083b9:	89 ce                	mov    %ecx,%esi
f01083bb:	75 0b                	jne    f01083c8 <__udivdi3+0x38>
f01083bd:	b8 01 00 00 00       	mov    $0x1,%eax
f01083c2:	31 d2                	xor    %edx,%edx
f01083c4:	f7 f1                	div    %ecx
f01083c6:	89 c6                	mov    %eax,%esi
f01083c8:	31 d2                	xor    %edx,%edx
f01083ca:	89 e8                	mov    %ebp,%eax
f01083cc:	f7 f6                	div    %esi
f01083ce:	89 c5                	mov    %eax,%ebp
f01083d0:	89 f8                	mov    %edi,%eax
f01083d2:	f7 f6                	div    %esi
f01083d4:	89 ea                	mov    %ebp,%edx
f01083d6:	83 c4 0c             	add    $0xc,%esp
f01083d9:	5e                   	pop    %esi
f01083da:	5f                   	pop    %edi
f01083db:	5d                   	pop    %ebp
f01083dc:	c3                   	ret    
f01083dd:	8d 76 00             	lea    0x0(%esi),%esi
f01083e0:	39 e8                	cmp    %ebp,%eax
f01083e2:	77 24                	ja     f0108408 <__udivdi3+0x78>
f01083e4:	0f bd e8             	bsr    %eax,%ebp
f01083e7:	83 f5 1f             	xor    $0x1f,%ebp
f01083ea:	75 3c                	jne    f0108428 <__udivdi3+0x98>
f01083ec:	8b 74 24 04          	mov    0x4(%esp),%esi
f01083f0:	39 34 24             	cmp    %esi,(%esp)
f01083f3:	0f 86 9f 00 00 00    	jbe    f0108498 <__udivdi3+0x108>
f01083f9:	39 d0                	cmp    %edx,%eax
f01083fb:	0f 82 97 00 00 00    	jb     f0108498 <__udivdi3+0x108>
f0108401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0108408:	31 d2                	xor    %edx,%edx
f010840a:	31 c0                	xor    %eax,%eax
f010840c:	83 c4 0c             	add    $0xc,%esp
f010840f:	5e                   	pop    %esi
f0108410:	5f                   	pop    %edi
f0108411:	5d                   	pop    %ebp
f0108412:	c3                   	ret    
f0108413:	90                   	nop
f0108414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0108418:	89 f8                	mov    %edi,%eax
f010841a:	f7 f1                	div    %ecx
f010841c:	31 d2                	xor    %edx,%edx
f010841e:	83 c4 0c             	add    $0xc,%esp
f0108421:	5e                   	pop    %esi
f0108422:	5f                   	pop    %edi
f0108423:	5d                   	pop    %ebp
f0108424:	c3                   	ret    
f0108425:	8d 76 00             	lea    0x0(%esi),%esi
f0108428:	89 e9                	mov    %ebp,%ecx
f010842a:	8b 3c 24             	mov    (%esp),%edi
f010842d:	d3 e0                	shl    %cl,%eax
f010842f:	89 c6                	mov    %eax,%esi
f0108431:	b8 20 00 00 00       	mov    $0x20,%eax
f0108436:	29 e8                	sub    %ebp,%eax
f0108438:	89 c1                	mov    %eax,%ecx
f010843a:	d3 ef                	shr    %cl,%edi
f010843c:	89 e9                	mov    %ebp,%ecx
f010843e:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0108442:	8b 3c 24             	mov    (%esp),%edi
f0108445:	09 74 24 08          	or     %esi,0x8(%esp)
f0108449:	89 d6                	mov    %edx,%esi
f010844b:	d3 e7                	shl    %cl,%edi
f010844d:	89 c1                	mov    %eax,%ecx
f010844f:	89 3c 24             	mov    %edi,(%esp)
f0108452:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0108456:	d3 ee                	shr    %cl,%esi
f0108458:	89 e9                	mov    %ebp,%ecx
f010845a:	d3 e2                	shl    %cl,%edx
f010845c:	89 c1                	mov    %eax,%ecx
f010845e:	d3 ef                	shr    %cl,%edi
f0108460:	09 d7                	or     %edx,%edi
f0108462:	89 f2                	mov    %esi,%edx
f0108464:	89 f8                	mov    %edi,%eax
f0108466:	f7 74 24 08          	divl   0x8(%esp)
f010846a:	89 d6                	mov    %edx,%esi
f010846c:	89 c7                	mov    %eax,%edi
f010846e:	f7 24 24             	mull   (%esp)
f0108471:	39 d6                	cmp    %edx,%esi
f0108473:	89 14 24             	mov    %edx,(%esp)
f0108476:	72 30                	jb     f01084a8 <__udivdi3+0x118>
f0108478:	8b 54 24 04          	mov    0x4(%esp),%edx
f010847c:	89 e9                	mov    %ebp,%ecx
f010847e:	d3 e2                	shl    %cl,%edx
f0108480:	39 c2                	cmp    %eax,%edx
f0108482:	73 05                	jae    f0108489 <__udivdi3+0xf9>
f0108484:	3b 34 24             	cmp    (%esp),%esi
f0108487:	74 1f                	je     f01084a8 <__udivdi3+0x118>
f0108489:	89 f8                	mov    %edi,%eax
f010848b:	31 d2                	xor    %edx,%edx
f010848d:	e9 7a ff ff ff       	jmp    f010840c <__udivdi3+0x7c>
f0108492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0108498:	31 d2                	xor    %edx,%edx
f010849a:	b8 01 00 00 00       	mov    $0x1,%eax
f010849f:	e9 68 ff ff ff       	jmp    f010840c <__udivdi3+0x7c>
f01084a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01084a8:	8d 47 ff             	lea    -0x1(%edi),%eax
f01084ab:	31 d2                	xor    %edx,%edx
f01084ad:	83 c4 0c             	add    $0xc,%esp
f01084b0:	5e                   	pop    %esi
f01084b1:	5f                   	pop    %edi
f01084b2:	5d                   	pop    %ebp
f01084b3:	c3                   	ret    
f01084b4:	66 90                	xchg   %ax,%ax
f01084b6:	66 90                	xchg   %ax,%ax
f01084b8:	66 90                	xchg   %ax,%ax
f01084ba:	66 90                	xchg   %ax,%ax
f01084bc:	66 90                	xchg   %ax,%ax
f01084be:	66 90                	xchg   %ax,%ax

f01084c0 <__umoddi3>:
f01084c0:	55                   	push   %ebp
f01084c1:	57                   	push   %edi
f01084c2:	56                   	push   %esi
f01084c3:	83 ec 14             	sub    $0x14,%esp
f01084c6:	8b 44 24 28          	mov    0x28(%esp),%eax
f01084ca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f01084ce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
f01084d2:	89 c7                	mov    %eax,%edi
f01084d4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01084d8:	8b 44 24 30          	mov    0x30(%esp),%eax
f01084dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f01084e0:	89 34 24             	mov    %esi,(%esp)
f01084e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01084e7:	85 c0                	test   %eax,%eax
f01084e9:	89 c2                	mov    %eax,%edx
f01084eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01084ef:	75 17                	jne    f0108508 <__umoddi3+0x48>
f01084f1:	39 fe                	cmp    %edi,%esi
f01084f3:	76 4b                	jbe    f0108540 <__umoddi3+0x80>
f01084f5:	89 c8                	mov    %ecx,%eax
f01084f7:	89 fa                	mov    %edi,%edx
f01084f9:	f7 f6                	div    %esi
f01084fb:	89 d0                	mov    %edx,%eax
f01084fd:	31 d2                	xor    %edx,%edx
f01084ff:	83 c4 14             	add    $0x14,%esp
f0108502:	5e                   	pop    %esi
f0108503:	5f                   	pop    %edi
f0108504:	5d                   	pop    %ebp
f0108505:	c3                   	ret    
f0108506:	66 90                	xchg   %ax,%ax
f0108508:	39 f8                	cmp    %edi,%eax
f010850a:	77 54                	ja     f0108560 <__umoddi3+0xa0>
f010850c:	0f bd e8             	bsr    %eax,%ebp
f010850f:	83 f5 1f             	xor    $0x1f,%ebp
f0108512:	75 5c                	jne    f0108570 <__umoddi3+0xb0>
f0108514:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0108518:	39 3c 24             	cmp    %edi,(%esp)
f010851b:	0f 87 e7 00 00 00    	ja     f0108608 <__umoddi3+0x148>
f0108521:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0108525:	29 f1                	sub    %esi,%ecx
f0108527:	19 c7                	sbb    %eax,%edi
f0108529:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010852d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0108531:	8b 44 24 08          	mov    0x8(%esp),%eax
f0108535:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0108539:	83 c4 14             	add    $0x14,%esp
f010853c:	5e                   	pop    %esi
f010853d:	5f                   	pop    %edi
f010853e:	5d                   	pop    %ebp
f010853f:	c3                   	ret    
f0108540:	85 f6                	test   %esi,%esi
f0108542:	89 f5                	mov    %esi,%ebp
f0108544:	75 0b                	jne    f0108551 <__umoddi3+0x91>
f0108546:	b8 01 00 00 00       	mov    $0x1,%eax
f010854b:	31 d2                	xor    %edx,%edx
f010854d:	f7 f6                	div    %esi
f010854f:	89 c5                	mov    %eax,%ebp
f0108551:	8b 44 24 04          	mov    0x4(%esp),%eax
f0108555:	31 d2                	xor    %edx,%edx
f0108557:	f7 f5                	div    %ebp
f0108559:	89 c8                	mov    %ecx,%eax
f010855b:	f7 f5                	div    %ebp
f010855d:	eb 9c                	jmp    f01084fb <__umoddi3+0x3b>
f010855f:	90                   	nop
f0108560:	89 c8                	mov    %ecx,%eax
f0108562:	89 fa                	mov    %edi,%edx
f0108564:	83 c4 14             	add    $0x14,%esp
f0108567:	5e                   	pop    %esi
f0108568:	5f                   	pop    %edi
f0108569:	5d                   	pop    %ebp
f010856a:	c3                   	ret    
f010856b:	90                   	nop
f010856c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0108570:	8b 04 24             	mov    (%esp),%eax
f0108573:	be 20 00 00 00       	mov    $0x20,%esi
f0108578:	89 e9                	mov    %ebp,%ecx
f010857a:	29 ee                	sub    %ebp,%esi
f010857c:	d3 e2                	shl    %cl,%edx
f010857e:	89 f1                	mov    %esi,%ecx
f0108580:	d3 e8                	shr    %cl,%eax
f0108582:	89 e9                	mov    %ebp,%ecx
f0108584:	89 44 24 04          	mov    %eax,0x4(%esp)
f0108588:	8b 04 24             	mov    (%esp),%eax
f010858b:	09 54 24 04          	or     %edx,0x4(%esp)
f010858f:	89 fa                	mov    %edi,%edx
f0108591:	d3 e0                	shl    %cl,%eax
f0108593:	89 f1                	mov    %esi,%ecx
f0108595:	89 44 24 08          	mov    %eax,0x8(%esp)
f0108599:	8b 44 24 10          	mov    0x10(%esp),%eax
f010859d:	d3 ea                	shr    %cl,%edx
f010859f:	89 e9                	mov    %ebp,%ecx
f01085a1:	d3 e7                	shl    %cl,%edi
f01085a3:	89 f1                	mov    %esi,%ecx
f01085a5:	d3 e8                	shr    %cl,%eax
f01085a7:	89 e9                	mov    %ebp,%ecx
f01085a9:	09 f8                	or     %edi,%eax
f01085ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
f01085af:	f7 74 24 04          	divl   0x4(%esp)
f01085b3:	d3 e7                	shl    %cl,%edi
f01085b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01085b9:	89 d7                	mov    %edx,%edi
f01085bb:	f7 64 24 08          	mull   0x8(%esp)
f01085bf:	39 d7                	cmp    %edx,%edi
f01085c1:	89 c1                	mov    %eax,%ecx
f01085c3:	89 14 24             	mov    %edx,(%esp)
f01085c6:	72 2c                	jb     f01085f4 <__umoddi3+0x134>
f01085c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
f01085cc:	72 22                	jb     f01085f0 <__umoddi3+0x130>
f01085ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
f01085d2:	29 c8                	sub    %ecx,%eax
f01085d4:	19 d7                	sbb    %edx,%edi
f01085d6:	89 e9                	mov    %ebp,%ecx
f01085d8:	89 fa                	mov    %edi,%edx
f01085da:	d3 e8                	shr    %cl,%eax
f01085dc:	89 f1                	mov    %esi,%ecx
f01085de:	d3 e2                	shl    %cl,%edx
f01085e0:	89 e9                	mov    %ebp,%ecx
f01085e2:	d3 ef                	shr    %cl,%edi
f01085e4:	09 d0                	or     %edx,%eax
f01085e6:	89 fa                	mov    %edi,%edx
f01085e8:	83 c4 14             	add    $0x14,%esp
f01085eb:	5e                   	pop    %esi
f01085ec:	5f                   	pop    %edi
f01085ed:	5d                   	pop    %ebp
f01085ee:	c3                   	ret    
f01085ef:	90                   	nop
f01085f0:	39 d7                	cmp    %edx,%edi
f01085f2:	75 da                	jne    f01085ce <__umoddi3+0x10e>
f01085f4:	8b 14 24             	mov    (%esp),%edx
f01085f7:	89 c1                	mov    %eax,%ecx
f01085f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
f01085fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
f0108601:	eb cb                	jmp    f01085ce <__umoddi3+0x10e>
f0108603:	90                   	nop
f0108604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0108608:	3b 44 24 0c          	cmp    0xc(%esp),%eax
f010860c:	0f 82 0f ff ff ff    	jb     f0108521 <__umoddi3+0x61>
f0108612:	e9 1a ff ff ff       	jmp    f0108531 <__umoddi3+0x71>
