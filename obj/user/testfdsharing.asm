
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 e8 01 00 00       	call   800219 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800043:	00 
  800044:	c7 04 24 60 2f 80 00 	movl   $0x802f60,(%esp)
  80004b:	e8 14 1f 00 00       	call   801f64 <open>
  800050:	89 c3                	mov    %eax,%ebx
  800052:	85 c0                	test   %eax,%eax
  800054:	79 20                	jns    800076 <umain+0x43>
		panic("open motd: %e", fd);
  800056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005a:	c7 44 24 08 65 2f 80 	movl   $0x802f65,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 73 2f 80 00 	movl   $0x802f73,(%esp)
  800071:	e8 04 02 00 00       	call   80027a <_panic>
	seek(fd, 0);
  800076:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007d:	00 
  80007e:	89 04 24             	mov    %eax,(%esp)
  800081:	e8 fe 1a 00 00       	call   801b84 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800086:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 20 52 80 	movl   $0x805220,0x4(%esp)
  800095:	00 
  800096:	89 1c 24             	mov    %ebx,(%esp)
  800099:	e8 0e 1a 00 00       	call   801aac <readn>
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	85 c0                	test   %eax,%eax
  8000a2:	7f 20                	jg     8000c4 <umain+0x91>
		panic("readn: %e", n);
  8000a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a8:	c7 44 24 08 88 2f 80 	movl   $0x802f88,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b7:	00 
  8000b8:	c7 04 24 73 2f 80 00 	movl   $0x802f73,(%esp)
  8000bf:	e8 b6 01 00 00       	call   80027a <_panic>

	if ((r = fork()) < 0)
  8000c4:	e8 a6 12 00 00       	call   80136f <fork>
  8000c9:	89 c6                	mov    %eax,%esi
  8000cb:	85 c0                	test   %eax,%eax
  8000cd:	79 20                	jns    8000ef <umain+0xbc>
		panic("fork: %e", r);
  8000cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000d3:	c7 44 24 08 92 2f 80 	movl   $0x802f92,0x8(%esp)
  8000da:	00 
  8000db:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8000e2:	00 
  8000e3:	c7 04 24 73 2f 80 00 	movl   $0x802f73,(%esp)
  8000ea:	e8 8b 01 00 00       	call   80027a <_panic>
	if (r == 0) {
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	0f 85 bd 00 00 00    	jne    8001b4 <umain+0x181>
		seek(fd, 0);
  8000f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000fe:	00 
  8000ff:	89 1c 24             	mov    %ebx,(%esp)
  800102:	e8 7d 1a 00 00       	call   801b84 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  800107:	c7 04 24 d0 2f 80 00 	movl   $0x802fd0,(%esp)
  80010e:	e8 60 02 00 00       	call   800373 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800113:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80011a:	00 
  80011b:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  800122:	00 
  800123:	89 1c 24             	mov    %ebx,(%esp)
  800126:	e8 81 19 00 00       	call   801aac <readn>
  80012b:	39 f8                	cmp    %edi,%eax
  80012d:	74 24                	je     800153 <umain+0x120>
			panic("read in parent got %d, read in child got %d", n, n2);
  80012f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800133:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800137:	c7 44 24 08 14 30 80 	movl   $0x803014,0x8(%esp)
  80013e:	00 
  80013f:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  800146:	00 
  800147:	c7 04 24 73 2f 80 00 	movl   $0x802f73,(%esp)
  80014e:	e8 27 01 00 00       	call   80027a <_panic>
		if (memcmp(buf, buf2, n) != 0)
  800153:	89 44 24 08          	mov    %eax,0x8(%esp)
  800157:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  80015e:	00 
  80015f:	c7 04 24 20 52 80 00 	movl   $0x805220,(%esp)
  800166:	e8 a2 0a 00 00       	call   800c0d <memcmp>
  80016b:	85 c0                	test   %eax,%eax
  80016d:	74 1c                	je     80018b <umain+0x158>
			panic("read in parent got different bytes from read in child");
  80016f:	c7 44 24 08 40 30 80 	movl   $0x803040,0x8(%esp)
  800176:	00 
  800177:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80017e:	00 
  80017f:	c7 04 24 73 2f 80 00 	movl   $0x802f73,(%esp)
  800186:	e8 ef 00 00 00       	call   80027a <_panic>
		cprintf("read in child succeeded\n");
  80018b:	c7 04 24 9b 2f 80 00 	movl   $0x802f9b,(%esp)
  800192:	e8 dc 01 00 00       	call   800373 <cprintf>
		seek(fd, 0);
  800197:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80019e:	00 
  80019f:	89 1c 24             	mov    %ebx,(%esp)
  8001a2:	e8 dd 19 00 00       	call   801b84 <seek>
		close(fd);
  8001a7:	89 1c 24             	mov    %ebx,(%esp)
  8001aa:	e8 08 17 00 00       	call   8018b7 <close>
		exit();
  8001af:	e8 ad 00 00 00       	call   800261 <exit>
	}
	wait(r);
  8001b4:	89 34 24             	mov    %esi,(%esp)
  8001b7:	e8 fe 26 00 00       	call   8028ba <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8001bc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8001c3:	00 
  8001c4:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  8001cb:	00 
  8001cc:	89 1c 24             	mov    %ebx,(%esp)
  8001cf:	e8 d8 18 00 00       	call   801aac <readn>
  8001d4:	39 f8                	cmp    %edi,%eax
  8001d6:	74 24                	je     8001fc <umain+0x1c9>
		panic("read in parent got %d, then got %d", n, n2);
  8001d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001dc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001e0:	c7 44 24 08 78 30 80 	movl   $0x803078,0x8(%esp)
  8001e7:	00 
  8001e8:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8001ef:	00 
  8001f0:	c7 04 24 73 2f 80 00 	movl   $0x802f73,(%esp)
  8001f7:	e8 7e 00 00 00       	call   80027a <_panic>
	cprintf("read in parent succeeded\n");
  8001fc:	c7 04 24 b4 2f 80 00 	movl   $0x802fb4,(%esp)
  800203:	e8 6b 01 00 00       	call   800373 <cprintf>
	close(fd);
  800208:	89 1c 24             	mov    %ebx,(%esp)
  80020b:	e8 a7 16 00 00       	call   8018b7 <close>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800210:	cc                   	int3   

	breakpoint();
}
  800211:	83 c4 2c             	add    $0x2c,%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5f                   	pop    %edi
  800217:	5d                   	pop    %ebp
  800218:	c3                   	ret    

00800219 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	83 ec 10             	sub    $0x10,%esp
  800221:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800224:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800227:	e8 eb 0b 00 00       	call   800e17 <sys_getenvid>
  80022c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800231:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800234:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800239:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023e:	85 db                	test   %ebx,%ebx
  800240:	7e 07                	jle    800249 <libmain+0x30>
		binaryname = argv[0];
  800242:	8b 06                	mov    (%esi),%eax
  800244:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800249:	89 74 24 04          	mov    %esi,0x4(%esp)
  80024d:	89 1c 24             	mov    %ebx,(%esp)
  800250:	e8 de fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800255:	e8 07 00 00 00       	call   800261 <exit>
}
  80025a:	83 c4 10             	add    $0x10,%esp
  80025d:	5b                   	pop    %ebx
  80025e:	5e                   	pop    %esi
  80025f:	5d                   	pop    %ebp
  800260:	c3                   	ret    

00800261 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800267:	e8 7e 16 00 00       	call   8018ea <close_all>
	sys_env_destroy(0);
  80026c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800273:	e8 fb 0a 00 00       	call   800d73 <sys_env_destroy>
}
  800278:	c9                   	leave  
  800279:	c3                   	ret    

0080027a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800282:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800285:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80028b:	e8 87 0b 00 00       	call   800e17 <sys_getenvid>
  800290:	8b 55 0c             	mov    0xc(%ebp),%edx
  800293:	89 54 24 10          	mov    %edx,0x10(%esp)
  800297:	8b 55 08             	mov    0x8(%ebp),%edx
  80029a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80029e:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a6:	c7 04 24 a8 30 80 00 	movl   $0x8030a8,(%esp)
  8002ad:	e8 c1 00 00 00       	call   800373 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	89 04 24             	mov    %eax,(%esp)
  8002bc:	e8 51 00 00 00       	call   800312 <vcprintf>
	cprintf("\n");
  8002c1:	c7 04 24 ab 35 80 00 	movl   $0x8035ab,(%esp)
  8002c8:	e8 a6 00 00 00       	call   800373 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002cd:	cc                   	int3   
  8002ce:	eb fd                	jmp    8002cd <_panic+0x53>

008002d0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	53                   	push   %ebx
  8002d4:	83 ec 14             	sub    $0x14,%esp
  8002d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002da:	8b 13                	mov    (%ebx),%edx
  8002dc:	8d 42 01             	lea    0x1(%edx),%eax
  8002df:	89 03                	mov    %eax,(%ebx)
  8002e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ed:	75 19                	jne    800308 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002ef:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002f6:	00 
  8002f7:	8d 43 08             	lea    0x8(%ebx),%eax
  8002fa:	89 04 24             	mov    %eax,(%esp)
  8002fd:	e8 34 0a 00 00       	call   800d36 <sys_cputs>
		b->idx = 0;
  800302:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800308:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80030c:	83 c4 14             	add    $0x14,%esp
  80030f:	5b                   	pop    %ebx
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80031b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800322:	00 00 00 
	b.cnt = 0;
  800325:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800336:	8b 45 08             	mov    0x8(%ebp),%eax
  800339:	89 44 24 08          	mov    %eax,0x8(%esp)
  80033d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800343:	89 44 24 04          	mov    %eax,0x4(%esp)
  800347:	c7 04 24 d0 02 80 00 	movl   $0x8002d0,(%esp)
  80034e:	e8 71 01 00 00       	call   8004c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800353:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800359:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800363:	89 04 24             	mov    %eax,(%esp)
  800366:	e8 cb 09 00 00       	call   800d36 <sys_cputs>

	return b.cnt;
}
  80036b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800379:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80037c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	89 04 24             	mov    %eax,(%esp)
  800386:	e8 87 ff ff ff       	call   800312 <vcprintf>
	va_end(ap);

	return cnt;
}
  80038b:	c9                   	leave  
  80038c:	c3                   	ret    
  80038d:	66 90                	xchg   %ax,%ax
  80038f:	90                   	nop

00800390 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	57                   	push   %edi
  800394:	56                   	push   %esi
  800395:	53                   	push   %ebx
  800396:	83 ec 3c             	sub    $0x3c,%esp
  800399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80039c:	89 d7                	mov    %edx,%edi
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a7:	89 c3                	mov    %eax,%ebx
  8003a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003bd:	39 d9                	cmp    %ebx,%ecx
  8003bf:	72 05                	jb     8003c6 <printnum+0x36>
  8003c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003c4:	77 69                	ja     80042f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003cd:	83 ee 01             	sub    $0x1,%esi
  8003d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003e0:	89 c3                	mov    %eax,%ebx
  8003e2:	89 d6                	mov    %edx,%esi
  8003e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f5:	89 04 24             	mov    %eax,(%esp)
  8003f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ff:	e8 cc 28 00 00       	call   802cd0 <__udivdi3>
  800404:	89 d9                	mov    %ebx,%ecx
  800406:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80040a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80040e:	89 04 24             	mov    %eax,(%esp)
  800411:	89 54 24 04          	mov    %edx,0x4(%esp)
  800415:	89 fa                	mov    %edi,%edx
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	e8 71 ff ff ff       	call   800390 <printnum>
  80041f:	eb 1b                	jmp    80043c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800421:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800425:	8b 45 18             	mov    0x18(%ebp),%eax
  800428:	89 04 24             	mov    %eax,(%esp)
  80042b:	ff d3                	call   *%ebx
  80042d:	eb 03                	jmp    800432 <printnum+0xa2>
  80042f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800432:	83 ee 01             	sub    $0x1,%esi
  800435:	85 f6                	test   %esi,%esi
  800437:	7f e8                	jg     800421 <printnum+0x91>
  800439:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80043c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800440:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800444:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800447:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80044a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80044e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800452:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800455:	89 04 24             	mov    %eax,(%esp)
  800458:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80045b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045f:	e8 9c 29 00 00       	call   802e00 <__umoddi3>
  800464:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800468:	0f be 80 cb 30 80 00 	movsbl 0x8030cb(%eax),%eax
  80046f:	89 04 24             	mov    %eax,(%esp)
  800472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800475:	ff d0                	call   *%eax
}
  800477:	83 c4 3c             	add    $0x3c,%esp
  80047a:	5b                   	pop    %ebx
  80047b:	5e                   	pop    %esi
  80047c:	5f                   	pop    %edi
  80047d:	5d                   	pop    %ebp
  80047e:	c3                   	ret    

0080047f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800485:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800489:	8b 10                	mov    (%eax),%edx
  80048b:	3b 50 04             	cmp    0x4(%eax),%edx
  80048e:	73 0a                	jae    80049a <sprintputch+0x1b>
		*b->buf++ = ch;
  800490:	8d 4a 01             	lea    0x1(%edx),%ecx
  800493:	89 08                	mov    %ecx,(%eax)
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	88 02                	mov    %al,(%edx)
}
  80049a:	5d                   	pop    %ebp
  80049b:	c3                   	ret    

0080049c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004a2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ba:	89 04 24             	mov    %eax,(%esp)
  8004bd:	e8 02 00 00 00       	call   8004c4 <vprintfmt>
	va_end(ap);
}
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	57                   	push   %edi
  8004c8:	56                   	push   %esi
  8004c9:	53                   	push   %ebx
  8004ca:	83 ec 3c             	sub    $0x3c,%esp
  8004cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004d0:	eb 17                	jmp    8004e9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8004d2:	85 c0                	test   %eax,%eax
  8004d4:	0f 84 4b 04 00 00    	je     800925 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8004da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004e1:	89 04 24             	mov    %eax,(%esp)
  8004e4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8004e7:	89 fb                	mov    %edi,%ebx
  8004e9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8004ec:	0f b6 03             	movzbl (%ebx),%eax
  8004ef:	83 f8 25             	cmp    $0x25,%eax
  8004f2:	75 de                	jne    8004d2 <vprintfmt+0xe>
  8004f4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8004f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8004ff:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800504:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80050b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800510:	eb 18                	jmp    80052a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800512:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800514:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800518:	eb 10                	jmp    80052a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80051c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800520:	eb 08                	jmp    80052a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800522:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800525:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80052d:	0f b6 17             	movzbl (%edi),%edx
  800530:	0f b6 c2             	movzbl %dl,%eax
  800533:	83 ea 23             	sub    $0x23,%edx
  800536:	80 fa 55             	cmp    $0x55,%dl
  800539:	0f 87 c2 03 00 00    	ja     800901 <vprintfmt+0x43d>
  80053f:	0f b6 d2             	movzbl %dl,%edx
  800542:	ff 24 95 00 32 80 00 	jmp    *0x803200(,%edx,4)
  800549:	89 df                	mov    %ebx,%edi
  80054b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800550:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800553:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800557:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80055a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80055d:	83 fa 09             	cmp    $0x9,%edx
  800560:	77 33                	ja     800595 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800562:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800565:	eb e9                	jmp    800550 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8b 30                	mov    (%eax),%esi
  80056c:	8d 40 04             	lea    0x4(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800572:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800574:	eb 1f                	jmp    800595 <vprintfmt+0xd1>
  800576:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800579:	85 ff                	test   %edi,%edi
  80057b:	b8 00 00 00 00       	mov    $0x0,%eax
  800580:	0f 49 c7             	cmovns %edi,%eax
  800583:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800586:	89 df                	mov    %ebx,%edi
  800588:	eb a0                	jmp    80052a <vprintfmt+0x66>
  80058a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80058c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800593:	eb 95                	jmp    80052a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800595:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800599:	79 8f                	jns    80052a <vprintfmt+0x66>
  80059b:	eb 85                	jmp    800522 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80059d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005a2:	eb 86                	jmp    80052a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 70 04             	lea    0x4(%eax),%esi
  8005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	89 04 24             	mov    %eax,(%esp)
  8005b9:	ff 55 08             	call   *0x8(%ebp)
  8005bc:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8005bf:	e9 25 ff ff ff       	jmp    8004e9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 70 04             	lea    0x4(%eax),%esi
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	99                   	cltd   
  8005cd:	31 d0                	xor    %edx,%eax
  8005cf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005d1:	83 f8 15             	cmp    $0x15,%eax
  8005d4:	7f 0b                	jg     8005e1 <vprintfmt+0x11d>
  8005d6:	8b 14 85 60 33 80 00 	mov    0x803360(,%eax,4),%edx
  8005dd:	85 d2                	test   %edx,%edx
  8005df:	75 26                	jne    800607 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8005e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005e5:	c7 44 24 08 e3 30 80 	movl   $0x8030e3,0x8(%esp)
  8005ec:	00 
  8005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	89 04 24             	mov    %eax,(%esp)
  8005fa:	e8 9d fe ff ff       	call   80049c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005ff:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800602:	e9 e2 fe ff ff       	jmp    8004e9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800607:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80060b:	c7 44 24 08 7a 35 80 	movl   $0x80357a,0x8(%esp)
  800612:	00 
  800613:	8b 45 0c             	mov    0xc(%ebp),%eax
  800616:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	89 04 24             	mov    %eax,(%esp)
  800620:	e8 77 fe ff ff       	call   80049c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800625:	89 75 14             	mov    %esi,0x14(%ebp)
  800628:	e9 bc fe ff ff       	jmp    8004e9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800633:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800636:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80063a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80063c:	85 ff                	test   %edi,%edi
  80063e:	b8 dc 30 80 00       	mov    $0x8030dc,%eax
  800643:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800646:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80064a:	0f 84 94 00 00 00    	je     8006e4 <vprintfmt+0x220>
  800650:	85 c9                	test   %ecx,%ecx
  800652:	0f 8e 94 00 00 00    	jle    8006ec <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800658:	89 74 24 04          	mov    %esi,0x4(%esp)
  80065c:	89 3c 24             	mov    %edi,(%esp)
  80065f:	e8 64 03 00 00       	call   8009c8 <strnlen>
  800664:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800667:	29 c1                	sub    %eax,%ecx
  800669:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80066c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800670:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800673:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800676:	8b 75 08             	mov    0x8(%ebp),%esi
  800679:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80067c:	89 cb                	mov    %ecx,%ebx
  80067e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800680:	eb 0f                	jmp    800691 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800682:	8b 45 0c             	mov    0xc(%ebp),%eax
  800685:	89 44 24 04          	mov    %eax,0x4(%esp)
  800689:	89 3c 24             	mov    %edi,(%esp)
  80068c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80068e:	83 eb 01             	sub    $0x1,%ebx
  800691:	85 db                	test   %ebx,%ebx
  800693:	7f ed                	jg     800682 <vprintfmt+0x1be>
  800695:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800698:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80069b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80069e:	85 c9                	test   %ecx,%ecx
  8006a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a5:	0f 49 c1             	cmovns %ecx,%eax
  8006a8:	29 c1                	sub    %eax,%ecx
  8006aa:	89 cb                	mov    %ecx,%ebx
  8006ac:	eb 44                	jmp    8006f2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b2:	74 1e                	je     8006d2 <vprintfmt+0x20e>
  8006b4:	0f be d2             	movsbl %dl,%edx
  8006b7:	83 ea 20             	sub    $0x20,%edx
  8006ba:	83 fa 5e             	cmp    $0x5e,%edx
  8006bd:	76 13                	jbe    8006d2 <vprintfmt+0x20e>
					putch('?', putdat);
  8006bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006cd:	ff 55 08             	call   *0x8(%ebp)
  8006d0:	eb 0d                	jmp    8006df <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8006d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006d9:	89 04 24             	mov    %eax,(%esp)
  8006dc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006df:	83 eb 01             	sub    $0x1,%ebx
  8006e2:	eb 0e                	jmp    8006f2 <vprintfmt+0x22e>
  8006e4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006e7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006ea:	eb 06                	jmp    8006f2 <vprintfmt+0x22e>
  8006ec:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006ef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006f2:	83 c7 01             	add    $0x1,%edi
  8006f5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006f9:	0f be c2             	movsbl %dl,%eax
  8006fc:	85 c0                	test   %eax,%eax
  8006fe:	74 27                	je     800727 <vprintfmt+0x263>
  800700:	85 f6                	test   %esi,%esi
  800702:	78 aa                	js     8006ae <vprintfmt+0x1ea>
  800704:	83 ee 01             	sub    $0x1,%esi
  800707:	79 a5                	jns    8006ae <vprintfmt+0x1ea>
  800709:	89 d8                	mov    %ebx,%eax
  80070b:	8b 75 08             	mov    0x8(%ebp),%esi
  80070e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800711:	89 c3                	mov    %eax,%ebx
  800713:	eb 18                	jmp    80072d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800715:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800719:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800720:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800722:	83 eb 01             	sub    $0x1,%ebx
  800725:	eb 06                	jmp    80072d <vprintfmt+0x269>
  800727:	8b 75 08             	mov    0x8(%ebp),%esi
  80072a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80072d:	85 db                	test   %ebx,%ebx
  80072f:	7f e4                	jg     800715 <vprintfmt+0x251>
  800731:	89 75 08             	mov    %esi,0x8(%ebp)
  800734:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800737:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80073a:	e9 aa fd ff ff       	jmp    8004e9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80073f:	83 f9 01             	cmp    $0x1,%ecx
  800742:	7e 10                	jle    800754 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8b 30                	mov    (%eax),%esi
  800749:	8b 78 04             	mov    0x4(%eax),%edi
  80074c:	8d 40 08             	lea    0x8(%eax),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
  800752:	eb 26                	jmp    80077a <vprintfmt+0x2b6>
	else if (lflag)
  800754:	85 c9                	test   %ecx,%ecx
  800756:	74 12                	je     80076a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 30                	mov    (%eax),%esi
  80075d:	89 f7                	mov    %esi,%edi
  80075f:	c1 ff 1f             	sar    $0x1f,%edi
  800762:	8d 40 04             	lea    0x4(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
  800768:	eb 10                	jmp    80077a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8b 30                	mov    (%eax),%esi
  80076f:	89 f7                	mov    %esi,%edi
  800771:	c1 ff 1f             	sar    $0x1f,%edi
  800774:	8d 40 04             	lea    0x4(%eax),%eax
  800777:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80077a:	89 f0                	mov    %esi,%eax
  80077c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80077e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800783:	85 ff                	test   %edi,%edi
  800785:	0f 89 3a 01 00 00    	jns    8008c5 <vprintfmt+0x401>
				putch('-', putdat);
  80078b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800792:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800799:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80079c:	89 f0                	mov    %esi,%eax
  80079e:	89 fa                	mov    %edi,%edx
  8007a0:	f7 d8                	neg    %eax
  8007a2:	83 d2 00             	adc    $0x0,%edx
  8007a5:	f7 da                	neg    %edx
			}
			base = 10;
  8007a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007ac:	e9 14 01 00 00       	jmp    8008c5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007b1:	83 f9 01             	cmp    $0x1,%ecx
  8007b4:	7e 13                	jle    8007c9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8b 50 04             	mov    0x4(%eax),%edx
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	8b 75 14             	mov    0x14(%ebp),%esi
  8007c1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8007c4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007c7:	eb 2c                	jmp    8007f5 <vprintfmt+0x331>
	else if (lflag)
  8007c9:	85 c9                	test   %ecx,%ecx
  8007cb:	74 15                	je     8007e2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d7:	8b 75 14             	mov    0x14(%ebp),%esi
  8007da:	8d 76 04             	lea    0x4(%esi),%esi
  8007dd:	89 75 14             	mov    %esi,0x14(%ebp)
  8007e0:	eb 13                	jmp    8007f5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ec:	8b 75 14             	mov    0x14(%ebp),%esi
  8007ef:	8d 76 04             	lea    0x4(%esi),%esi
  8007f2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8007f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007fa:	e9 c6 00 00 00       	jmp    8008c5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007ff:	83 f9 01             	cmp    $0x1,%ecx
  800802:	7e 13                	jle    800817 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8b 50 04             	mov    0x4(%eax),%edx
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	8b 75 14             	mov    0x14(%ebp),%esi
  80080f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800812:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800815:	eb 24                	jmp    80083b <vprintfmt+0x377>
	else if (lflag)
  800817:	85 c9                	test   %ecx,%ecx
  800819:	74 11                	je     80082c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	99                   	cltd   
  800821:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800824:	8d 71 04             	lea    0x4(%ecx),%esi
  800827:	89 75 14             	mov    %esi,0x14(%ebp)
  80082a:	eb 0f                	jmp    80083b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	99                   	cltd   
  800832:	8b 75 14             	mov    0x14(%ebp),%esi
  800835:	8d 76 04             	lea    0x4(%esi),%esi
  800838:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80083b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800840:	e9 80 00 00 00       	jmp    8008c5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800845:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800856:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800859:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800860:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800867:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80086a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80086e:	8b 06                	mov    (%esi),%eax
  800870:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800875:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80087a:	eb 49                	jmp    8008c5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80087c:	83 f9 01             	cmp    $0x1,%ecx
  80087f:	7e 13                	jle    800894 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8b 50 04             	mov    0x4(%eax),%edx
  800887:	8b 00                	mov    (%eax),%eax
  800889:	8b 75 14             	mov    0x14(%ebp),%esi
  80088c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80088f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800892:	eb 2c                	jmp    8008c0 <vprintfmt+0x3fc>
	else if (lflag)
  800894:	85 c9                	test   %ecx,%ecx
  800896:	74 15                	je     8008ad <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	8b 00                	mov    (%eax),%eax
  80089d:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8008a5:	8d 71 04             	lea    0x4(%ecx),%esi
  8008a8:	89 75 14             	mov    %esi,0x14(%ebp)
  8008ab:	eb 13                	jmp    8008c0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b7:	8b 75 14             	mov    0x14(%ebp),%esi
  8008ba:	8d 76 04             	lea    0x4(%esi),%esi
  8008bd:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8008c0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008c5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8008c9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8008cd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8008d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8008d4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008d8:	89 04 24             	mov    %eax,(%esp)
  8008db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	e8 a6 fa ff ff       	call   800390 <printnum>
			break;
  8008ea:	e9 fa fb ff ff       	jmp    8004e9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008f6:	89 04 24             	mov    %eax,(%esp)
  8008f9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008fc:	e9 e8 fb ff ff       	jmp    8004e9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800901:	8b 45 0c             	mov    0xc(%ebp),%eax
  800904:	89 44 24 04          	mov    %eax,0x4(%esp)
  800908:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80090f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800912:	89 fb                	mov    %edi,%ebx
  800914:	eb 03                	jmp    800919 <vprintfmt+0x455>
  800916:	83 eb 01             	sub    $0x1,%ebx
  800919:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80091d:	75 f7                	jne    800916 <vprintfmt+0x452>
  80091f:	90                   	nop
  800920:	e9 c4 fb ff ff       	jmp    8004e9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800925:	83 c4 3c             	add    $0x3c,%esp
  800928:	5b                   	pop    %ebx
  800929:	5e                   	pop    %esi
  80092a:	5f                   	pop    %edi
  80092b:	5d                   	pop    %ebp
  80092c:	c3                   	ret    

0080092d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	83 ec 28             	sub    $0x28,%esp
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800939:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80093c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800940:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800943:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80094a:	85 c0                	test   %eax,%eax
  80094c:	74 30                	je     80097e <vsnprintf+0x51>
  80094e:	85 d2                	test   %edx,%edx
  800950:	7e 2c                	jle    80097e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800959:	8b 45 10             	mov    0x10(%ebp),%eax
  80095c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800960:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800963:	89 44 24 04          	mov    %eax,0x4(%esp)
  800967:	c7 04 24 7f 04 80 00 	movl   $0x80047f,(%esp)
  80096e:	e8 51 fb ff ff       	call   8004c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800973:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800976:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80097c:	eb 05                	jmp    800983 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80097e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800983:	c9                   	leave  
  800984:	c3                   	ret    

00800985 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80098b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80098e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800992:	8b 45 10             	mov    0x10(%ebp),%eax
  800995:	89 44 24 08          	mov    %eax,0x8(%esp)
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	89 04 24             	mov    %eax,(%esp)
  8009a6:	e8 82 ff ff ff       	call   80092d <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    
  8009ad:	66 90                	xchg   %ax,%ax
  8009af:	90                   	nop

008009b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bb:	eb 03                	jmp    8009c0 <strlen+0x10>
		n++;
  8009bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009c4:	75 f7                	jne    8009bd <strlen+0xd>
		n++;
	return n;
}
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d6:	eb 03                	jmp    8009db <strnlen+0x13>
		n++;
  8009d8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009db:	39 d0                	cmp    %edx,%eax
  8009dd:	74 06                	je     8009e5 <strnlen+0x1d>
  8009df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009e3:	75 f3                	jne    8009d8 <strnlen+0x10>
		n++;
	return n;
}
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	53                   	push   %ebx
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009f1:	89 c2                	mov    %eax,%edx
  8009f3:	83 c2 01             	add    $0x1,%edx
  8009f6:	83 c1 01             	add    $0x1,%ecx
  8009f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a00:	84 db                	test   %bl,%bl
  800a02:	75 ef                	jne    8009f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a04:	5b                   	pop    %ebx
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	53                   	push   %ebx
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a11:	89 1c 24             	mov    %ebx,(%esp)
  800a14:	e8 97 ff ff ff       	call   8009b0 <strlen>
	strcpy(dst + len, src);
  800a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a20:	01 d8                	add    %ebx,%eax
  800a22:	89 04 24             	mov    %eax,(%esp)
  800a25:	e8 bd ff ff ff       	call   8009e7 <strcpy>
	return dst;
}
  800a2a:	89 d8                	mov    %ebx,%eax
  800a2c:	83 c4 08             	add    $0x8,%esp
  800a2f:	5b                   	pop    %ebx
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	56                   	push   %esi
  800a36:	53                   	push   %ebx
  800a37:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a3d:	89 f3                	mov    %esi,%ebx
  800a3f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a42:	89 f2                	mov    %esi,%edx
  800a44:	eb 0f                	jmp    800a55 <strncpy+0x23>
		*dst++ = *src;
  800a46:	83 c2 01             	add    $0x1,%edx
  800a49:	0f b6 01             	movzbl (%ecx),%eax
  800a4c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a4f:	80 39 01             	cmpb   $0x1,(%ecx)
  800a52:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a55:	39 da                	cmp    %ebx,%edx
  800a57:	75 ed                	jne    800a46 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a59:	89 f0                	mov    %esi,%eax
  800a5b:	5b                   	pop    %ebx
  800a5c:	5e                   	pop    %esi
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	56                   	push   %esi
  800a63:	53                   	push   %ebx
  800a64:	8b 75 08             	mov    0x8(%ebp),%esi
  800a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a6d:	89 f0                	mov    %esi,%eax
  800a6f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a73:	85 c9                	test   %ecx,%ecx
  800a75:	75 0b                	jne    800a82 <strlcpy+0x23>
  800a77:	eb 1d                	jmp    800a96 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a79:	83 c0 01             	add    $0x1,%eax
  800a7c:	83 c2 01             	add    $0x1,%edx
  800a7f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a82:	39 d8                	cmp    %ebx,%eax
  800a84:	74 0b                	je     800a91 <strlcpy+0x32>
  800a86:	0f b6 0a             	movzbl (%edx),%ecx
  800a89:	84 c9                	test   %cl,%cl
  800a8b:	75 ec                	jne    800a79 <strlcpy+0x1a>
  800a8d:	89 c2                	mov    %eax,%edx
  800a8f:	eb 02                	jmp    800a93 <strlcpy+0x34>
  800a91:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a93:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a96:	29 f0                	sub    %esi,%eax
}
  800a98:	5b                   	pop    %ebx
  800a99:	5e                   	pop    %esi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aa5:	eb 06                	jmp    800aad <strcmp+0x11>
		p++, q++;
  800aa7:	83 c1 01             	add    $0x1,%ecx
  800aaa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aad:	0f b6 01             	movzbl (%ecx),%eax
  800ab0:	84 c0                	test   %al,%al
  800ab2:	74 04                	je     800ab8 <strcmp+0x1c>
  800ab4:	3a 02                	cmp    (%edx),%al
  800ab6:	74 ef                	je     800aa7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab8:	0f b6 c0             	movzbl %al,%eax
  800abb:	0f b6 12             	movzbl (%edx),%edx
  800abe:	29 d0                	sub    %edx,%eax
}
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	53                   	push   %ebx
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acc:	89 c3                	mov    %eax,%ebx
  800ace:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ad1:	eb 06                	jmp    800ad9 <strncmp+0x17>
		n--, p++, q++;
  800ad3:	83 c0 01             	add    $0x1,%eax
  800ad6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ad9:	39 d8                	cmp    %ebx,%eax
  800adb:	74 15                	je     800af2 <strncmp+0x30>
  800add:	0f b6 08             	movzbl (%eax),%ecx
  800ae0:	84 c9                	test   %cl,%cl
  800ae2:	74 04                	je     800ae8 <strncmp+0x26>
  800ae4:	3a 0a                	cmp    (%edx),%cl
  800ae6:	74 eb                	je     800ad3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae8:	0f b6 00             	movzbl (%eax),%eax
  800aeb:	0f b6 12             	movzbl (%edx),%edx
  800aee:	29 d0                	sub    %edx,%eax
  800af0:	eb 05                	jmp    800af7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800af2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800af7:	5b                   	pop    %ebx
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b04:	eb 07                	jmp    800b0d <strchr+0x13>
		if (*s == c)
  800b06:	38 ca                	cmp    %cl,%dl
  800b08:	74 0f                	je     800b19 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b0a:	83 c0 01             	add    $0x1,%eax
  800b0d:	0f b6 10             	movzbl (%eax),%edx
  800b10:	84 d2                	test   %dl,%dl
  800b12:	75 f2                	jne    800b06 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800b14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b25:	eb 07                	jmp    800b2e <strfind+0x13>
		if (*s == c)
  800b27:	38 ca                	cmp    %cl,%dl
  800b29:	74 0a                	je     800b35 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b2b:	83 c0 01             	add    $0x1,%eax
  800b2e:	0f b6 10             	movzbl (%eax),%edx
  800b31:	84 d2                	test   %dl,%dl
  800b33:	75 f2                	jne    800b27 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	57                   	push   %edi
  800b3b:	56                   	push   %esi
  800b3c:	53                   	push   %ebx
  800b3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b43:	85 c9                	test   %ecx,%ecx
  800b45:	74 36                	je     800b7d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b47:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b4d:	75 28                	jne    800b77 <memset+0x40>
  800b4f:	f6 c1 03             	test   $0x3,%cl
  800b52:	75 23                	jne    800b77 <memset+0x40>
		c &= 0xFF;
  800b54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b58:	89 d3                	mov    %edx,%ebx
  800b5a:	c1 e3 08             	shl    $0x8,%ebx
  800b5d:	89 d6                	mov    %edx,%esi
  800b5f:	c1 e6 18             	shl    $0x18,%esi
  800b62:	89 d0                	mov    %edx,%eax
  800b64:	c1 e0 10             	shl    $0x10,%eax
  800b67:	09 f0                	or     %esi,%eax
  800b69:	09 c2                	or     %eax,%edx
  800b6b:	89 d0                	mov    %edx,%eax
  800b6d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b6f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b72:	fc                   	cld    
  800b73:	f3 ab                	rep stos %eax,%es:(%edi)
  800b75:	eb 06                	jmp    800b7d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7a:	fc                   	cld    
  800b7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b7d:	89 f8                	mov    %edi,%eax
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b92:	39 c6                	cmp    %eax,%esi
  800b94:	73 35                	jae    800bcb <memmove+0x47>
  800b96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b99:	39 d0                	cmp    %edx,%eax
  800b9b:	73 2e                	jae    800bcb <memmove+0x47>
		s += n;
		d += n;
  800b9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ba0:	89 d6                	mov    %edx,%esi
  800ba2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ba4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800baa:	75 13                	jne    800bbf <memmove+0x3b>
  800bac:	f6 c1 03             	test   $0x3,%cl
  800baf:	75 0e                	jne    800bbf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bb1:	83 ef 04             	sub    $0x4,%edi
  800bb4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bb7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800bba:	fd                   	std    
  800bbb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bbd:	eb 09                	jmp    800bc8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bbf:	83 ef 01             	sub    $0x1,%edi
  800bc2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bc5:	fd                   	std    
  800bc6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bc8:	fc                   	cld    
  800bc9:	eb 1d                	jmp    800be8 <memmove+0x64>
  800bcb:	89 f2                	mov    %esi,%edx
  800bcd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bcf:	f6 c2 03             	test   $0x3,%dl
  800bd2:	75 0f                	jne    800be3 <memmove+0x5f>
  800bd4:	f6 c1 03             	test   $0x3,%cl
  800bd7:	75 0a                	jne    800be3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bd9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800bdc:	89 c7                	mov    %eax,%edi
  800bde:	fc                   	cld    
  800bdf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800be1:	eb 05                	jmp    800be8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800be3:	89 c7                	mov    %eax,%edi
  800be5:	fc                   	cld    
  800be6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800be8:	5e                   	pop    %esi
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	89 04 24             	mov    %eax,(%esp)
  800c06:	e8 79 ff ff ff       	call   800b84 <memmove>
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	89 d6                	mov    %edx,%esi
  800c1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c1d:	eb 1a                	jmp    800c39 <memcmp+0x2c>
		if (*s1 != *s2)
  800c1f:	0f b6 02             	movzbl (%edx),%eax
  800c22:	0f b6 19             	movzbl (%ecx),%ebx
  800c25:	38 d8                	cmp    %bl,%al
  800c27:	74 0a                	je     800c33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800c29:	0f b6 c0             	movzbl %al,%eax
  800c2c:	0f b6 db             	movzbl %bl,%ebx
  800c2f:	29 d8                	sub    %ebx,%eax
  800c31:	eb 0f                	jmp    800c42 <memcmp+0x35>
		s1++, s2++;
  800c33:	83 c2 01             	add    $0x1,%edx
  800c36:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c39:	39 f2                	cmp    %esi,%edx
  800c3b:	75 e2                	jne    800c1f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    

00800c46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c4f:	89 c2                	mov    %eax,%edx
  800c51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c54:	eb 07                	jmp    800c5d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c56:	38 08                	cmp    %cl,(%eax)
  800c58:	74 07                	je     800c61 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c5a:	83 c0 01             	add    $0x1,%eax
  800c5d:	39 d0                	cmp    %edx,%eax
  800c5f:	72 f5                	jb     800c56 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6f:	eb 03                	jmp    800c74 <strtol+0x11>
		s++;
  800c71:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c74:	0f b6 0a             	movzbl (%edx),%ecx
  800c77:	80 f9 09             	cmp    $0x9,%cl
  800c7a:	74 f5                	je     800c71 <strtol+0xe>
  800c7c:	80 f9 20             	cmp    $0x20,%cl
  800c7f:	74 f0                	je     800c71 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c81:	80 f9 2b             	cmp    $0x2b,%cl
  800c84:	75 0a                	jne    800c90 <strtol+0x2d>
		s++;
  800c86:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c89:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8e:	eb 11                	jmp    800ca1 <strtol+0x3e>
  800c90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c95:	80 f9 2d             	cmp    $0x2d,%cl
  800c98:	75 07                	jne    800ca1 <strtol+0x3e>
		s++, neg = 1;
  800c9a:	8d 52 01             	lea    0x1(%edx),%edx
  800c9d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ca6:	75 15                	jne    800cbd <strtol+0x5a>
  800ca8:	80 3a 30             	cmpb   $0x30,(%edx)
  800cab:	75 10                	jne    800cbd <strtol+0x5a>
  800cad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cb1:	75 0a                	jne    800cbd <strtol+0x5a>
		s += 2, base = 16;
  800cb3:	83 c2 02             	add    $0x2,%edx
  800cb6:	b8 10 00 00 00       	mov    $0x10,%eax
  800cbb:	eb 10                	jmp    800ccd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	75 0c                	jne    800ccd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cc3:	80 3a 30             	cmpb   $0x30,(%edx)
  800cc6:	75 05                	jne    800ccd <strtol+0x6a>
		s++, base = 8;
  800cc8:	83 c2 01             	add    $0x1,%edx
  800ccb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800ccd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cd5:	0f b6 0a             	movzbl (%edx),%ecx
  800cd8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800cdb:	89 f0                	mov    %esi,%eax
  800cdd:	3c 09                	cmp    $0x9,%al
  800cdf:	77 08                	ja     800ce9 <strtol+0x86>
			dig = *s - '0';
  800ce1:	0f be c9             	movsbl %cl,%ecx
  800ce4:	83 e9 30             	sub    $0x30,%ecx
  800ce7:	eb 20                	jmp    800d09 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ce9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cec:	89 f0                	mov    %esi,%eax
  800cee:	3c 19                	cmp    $0x19,%al
  800cf0:	77 08                	ja     800cfa <strtol+0x97>
			dig = *s - 'a' + 10;
  800cf2:	0f be c9             	movsbl %cl,%ecx
  800cf5:	83 e9 57             	sub    $0x57,%ecx
  800cf8:	eb 0f                	jmp    800d09 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800cfa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cfd:	89 f0                	mov    %esi,%eax
  800cff:	3c 19                	cmp    $0x19,%al
  800d01:	77 16                	ja     800d19 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800d03:	0f be c9             	movsbl %cl,%ecx
  800d06:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d09:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d0c:	7d 0f                	jge    800d1d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800d0e:	83 c2 01             	add    $0x1,%edx
  800d11:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d15:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d17:	eb bc                	jmp    800cd5 <strtol+0x72>
  800d19:	89 d8                	mov    %ebx,%eax
  800d1b:	eb 02                	jmp    800d1f <strtol+0xbc>
  800d1d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d23:	74 05                	je     800d2a <strtol+0xc7>
		*endptr = (char *) s;
  800d25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d28:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d2a:	f7 d8                	neg    %eax
  800d2c:	85 ff                	test   %edi,%edi
  800d2e:	0f 44 c3             	cmove  %ebx,%eax
}
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d44:	8b 55 08             	mov    0x8(%ebp),%edx
  800d47:	89 c3                	mov    %eax,%ebx
  800d49:	89 c7                	mov    %eax,%edi
  800d4b:	89 c6                	mov    %eax,%esi
  800d4d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d64:	89 d1                	mov    %edx,%ecx
  800d66:	89 d3                	mov    %edx,%ebx
  800d68:	89 d7                	mov    %edx,%edi
  800d6a:	89 d6                	mov    %edx,%esi
  800d6c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d6e:	5b                   	pop    %ebx
  800d6f:	5e                   	pop    %esi
  800d70:	5f                   	pop    %edi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d81:	b8 03 00 00 00       	mov    $0x3,%eax
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	89 cb                	mov    %ecx,%ebx
  800d8b:	89 cf                	mov    %ecx,%edi
  800d8d:	89 ce                	mov    %ecx,%esi
  800d8f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d91:	85 c0                	test   %eax,%eax
  800d93:	7e 28                	jle    800dbd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d95:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d99:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800da0:	00 
  800da1:	c7 44 24 08 d7 33 80 	movl   $0x8033d7,0x8(%esp)
  800da8:	00 
  800da9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db0:	00 
  800db1:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  800db8:	e8 bd f4 ff ff       	call   80027a <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dbd:	83 c4 2c             	add    $0x2c,%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    

00800dc5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	57                   	push   %edi
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
  800dcb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dce:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd3:	b8 04 00 00 00       	mov    $0x4,%eax
  800dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddb:	89 cb                	mov    %ecx,%ebx
  800ddd:	89 cf                	mov    %ecx,%edi
  800ddf:	89 ce                	mov    %ecx,%esi
  800de1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de3:	85 c0                	test   %eax,%eax
  800de5:	7e 28                	jle    800e0f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800deb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800df2:	00 
  800df3:	c7 44 24 08 d7 33 80 	movl   $0x8033d7,0x8(%esp)
  800dfa:	00 
  800dfb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e02:	00 
  800e03:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  800e0a:	e8 6b f4 ff ff       	call   80027a <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800e0f:	83 c4 2c             	add    $0x2c,%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e22:	b8 02 00 00 00       	mov    $0x2,%eax
  800e27:	89 d1                	mov    %edx,%ecx
  800e29:	89 d3                	mov    %edx,%ebx
  800e2b:	89 d7                	mov    %edx,%edi
  800e2d:	89 d6                	mov    %edx,%esi
  800e2f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <sys_yield>:

void
sys_yield(void)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e41:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e46:	89 d1                	mov    %edx,%ecx
  800e48:	89 d3                	mov    %edx,%ebx
  800e4a:	89 d7                	mov    %edx,%edi
  800e4c:	89 d6                	mov    %edx,%esi
  800e4e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e50:	5b                   	pop    %ebx
  800e51:	5e                   	pop    %esi
  800e52:	5f                   	pop    %edi
  800e53:	5d                   	pop    %ebp
  800e54:	c3                   	ret    

00800e55 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	57                   	push   %edi
  800e59:	56                   	push   %esi
  800e5a:	53                   	push   %ebx
  800e5b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5e:	be 00 00 00 00       	mov    $0x0,%esi
  800e63:	b8 05 00 00 00       	mov    $0x5,%eax
  800e68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e71:	89 f7                	mov    %esi,%edi
  800e73:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e75:	85 c0                	test   %eax,%eax
  800e77:	7e 28                	jle    800ea1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e79:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e7d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e84:	00 
  800e85:	c7 44 24 08 d7 33 80 	movl   $0x8033d7,0x8(%esp)
  800e8c:	00 
  800e8d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e94:	00 
  800e95:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  800e9c:	e8 d9 f3 ff ff       	call   80027a <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ea1:	83 c4 2c             	add    $0x2c,%esp
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5f                   	pop    %edi
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    

00800ea9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	57                   	push   %edi
  800ead:	56                   	push   %esi
  800eae:	53                   	push   %ebx
  800eaf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb2:	b8 06 00 00 00       	mov    $0x6,%eax
  800eb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec3:	8b 75 18             	mov    0x18(%ebp),%esi
  800ec6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	7e 28                	jle    800ef4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ed7:	00 
  800ed8:	c7 44 24 08 d7 33 80 	movl   $0x8033d7,0x8(%esp)
  800edf:	00 
  800ee0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee7:	00 
  800ee8:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  800eef:	e8 86 f3 ff ff       	call   80027a <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ef4:	83 c4 2c             	add    $0x2c,%esp
  800ef7:	5b                   	pop    %ebx
  800ef8:	5e                   	pop    %esi
  800ef9:	5f                   	pop    %edi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    

00800efc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	57                   	push   %edi
  800f00:	56                   	push   %esi
  800f01:	53                   	push   %ebx
  800f02:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0a:	b8 07 00 00 00       	mov    $0x7,%eax
  800f0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f12:	8b 55 08             	mov    0x8(%ebp),%edx
  800f15:	89 df                	mov    %ebx,%edi
  800f17:	89 de                	mov    %ebx,%esi
  800f19:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	7e 28                	jle    800f47 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f23:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800f2a:	00 
  800f2b:	c7 44 24 08 d7 33 80 	movl   $0x8033d7,0x8(%esp)
  800f32:	00 
  800f33:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3a:	00 
  800f3b:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  800f42:	e8 33 f3 ff ff       	call   80027a <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f47:	83 c4 2c             	add    $0x2c,%esp
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    

00800f4f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5a:	b8 10 00 00 00       	mov    $0x10,%eax
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	89 cb                	mov    %ecx,%ebx
  800f64:	89 cf                	mov    %ecx,%edi
  800f66:	89 ce                	mov    %ecx,%esi
  800f68:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
  800f75:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7d:	b8 09 00 00 00       	mov    $0x9,%eax
  800f82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f85:	8b 55 08             	mov    0x8(%ebp),%edx
  800f88:	89 df                	mov    %ebx,%edi
  800f8a:	89 de                	mov    %ebx,%esi
  800f8c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	7e 28                	jle    800fba <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f92:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f96:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f9d:	00 
  800f9e:	c7 44 24 08 d7 33 80 	movl   $0x8033d7,0x8(%esp)
  800fa5:	00 
  800fa6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fad:	00 
  800fae:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  800fb5:	e8 c0 f2 ff ff       	call   80027a <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fba:	83 c4 2c             	add    $0x2c,%esp
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	57                   	push   %edi
  800fc6:	56                   	push   %esi
  800fc7:	53                   	push   %ebx
  800fc8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdb:	89 df                	mov    %ebx,%edi
  800fdd:	89 de                	mov    %ebx,%esi
  800fdf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	7e 28                	jle    80100d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ff0:	00 
  800ff1:	c7 44 24 08 d7 33 80 	movl   $0x8033d7,0x8(%esp)
  800ff8:	00 
  800ff9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801000:	00 
  801001:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  801008:	e8 6d f2 ff ff       	call   80027a <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80100d:	83 c4 2c             	add    $0x2c,%esp
  801010:	5b                   	pop    %ebx
  801011:	5e                   	pop    %esi
  801012:	5f                   	pop    %edi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	57                   	push   %edi
  801019:	56                   	push   %esi
  80101a:	53                   	push   %ebx
  80101b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801023:	b8 0b 00 00 00       	mov    $0xb,%eax
  801028:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102b:	8b 55 08             	mov    0x8(%ebp),%edx
  80102e:	89 df                	mov    %ebx,%edi
  801030:	89 de                	mov    %ebx,%esi
  801032:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801034:	85 c0                	test   %eax,%eax
  801036:	7e 28                	jle    801060 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801038:	89 44 24 10          	mov    %eax,0x10(%esp)
  80103c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801043:	00 
  801044:	c7 44 24 08 d7 33 80 	movl   $0x8033d7,0x8(%esp)
  80104b:	00 
  80104c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801053:	00 
  801054:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  80105b:	e8 1a f2 ff ff       	call   80027a <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801060:	83 c4 2c             	add    $0x2c,%esp
  801063:	5b                   	pop    %ebx
  801064:	5e                   	pop    %esi
  801065:	5f                   	pop    %edi
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    

00801068 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	57                   	push   %edi
  80106c:	56                   	push   %esi
  80106d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106e:	be 00 00 00 00       	mov    $0x0,%esi
  801073:	b8 0d 00 00 00       	mov    $0xd,%eax
  801078:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801081:	8b 7d 14             	mov    0x14(%ebp),%edi
  801084:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801086:	5b                   	pop    %ebx
  801087:	5e                   	pop    %esi
  801088:	5f                   	pop    %edi
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    

0080108b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	57                   	push   %edi
  80108f:	56                   	push   %esi
  801090:	53                   	push   %ebx
  801091:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801094:	b9 00 00 00 00       	mov    $0x0,%ecx
  801099:	b8 0e 00 00 00       	mov    $0xe,%eax
  80109e:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a1:	89 cb                	mov    %ecx,%ebx
  8010a3:	89 cf                	mov    %ecx,%edi
  8010a5:	89 ce                	mov    %ecx,%esi
  8010a7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	7e 28                	jle    8010d5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ad:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010b1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8010b8:	00 
  8010b9:	c7 44 24 08 d7 33 80 	movl   $0x8033d7,0x8(%esp)
  8010c0:	00 
  8010c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c8:	00 
  8010c9:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  8010d0:	e8 a5 f1 ff ff       	call   80027a <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010d5:	83 c4 2c             	add    $0x2c,%esp
  8010d8:	5b                   	pop    %ebx
  8010d9:	5e                   	pop    %esi
  8010da:	5f                   	pop    %edi
  8010db:	5d                   	pop    %ebp
  8010dc:	c3                   	ret    

008010dd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	57                   	push   %edi
  8010e1:	56                   	push   %esi
  8010e2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010ed:	89 d1                	mov    %edx,%ecx
  8010ef:	89 d3                	mov    %edx,%ebx
  8010f1:	89 d7                	mov    %edx,%edi
  8010f3:	89 d6                	mov    %edx,%esi
  8010f5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010f7:	5b                   	pop    %ebx
  8010f8:	5e                   	pop    %esi
  8010f9:	5f                   	pop    %edi
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	57                   	push   %edi
  801100:	56                   	push   %esi
  801101:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801102:	bb 00 00 00 00       	mov    $0x0,%ebx
  801107:	b8 11 00 00 00       	mov    $0x11,%eax
  80110c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110f:	8b 55 08             	mov    0x8(%ebp),%edx
  801112:	89 df                	mov    %ebx,%edi
  801114:	89 de                	mov    %ebx,%esi
  801116:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801118:	5b                   	pop    %ebx
  801119:	5e                   	pop    %esi
  80111a:	5f                   	pop    %edi
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	57                   	push   %edi
  801121:	56                   	push   %esi
  801122:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801123:	bb 00 00 00 00       	mov    $0x0,%ebx
  801128:	b8 12 00 00 00       	mov    $0x12,%eax
  80112d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801130:	8b 55 08             	mov    0x8(%ebp),%edx
  801133:	89 df                	mov    %ebx,%edi
  801135:	89 de                	mov    %ebx,%esi
  801137:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801139:	5b                   	pop    %ebx
  80113a:	5e                   	pop    %esi
  80113b:	5f                   	pop    %edi
  80113c:	5d                   	pop    %ebp
  80113d:	c3                   	ret    

0080113e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	57                   	push   %edi
  801142:	56                   	push   %esi
  801143:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801144:	b9 00 00 00 00       	mov    $0x0,%ecx
  801149:	b8 13 00 00 00       	mov    $0x13,%eax
  80114e:	8b 55 08             	mov    0x8(%ebp),%edx
  801151:	89 cb                	mov    %ecx,%ebx
  801153:	89 cf                	mov    %ecx,%edi
  801155:	89 ce                	mov    %ecx,%esi
  801157:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801159:	5b                   	pop    %ebx
  80115a:	5e                   	pop    %esi
  80115b:	5f                   	pop    %edi
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	57                   	push   %edi
  801162:	56                   	push   %esi
  801163:	53                   	push   %ebx
  801164:	83 ec 2c             	sub    $0x2c,%esp
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80116a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80116c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80116f:	89 f8                	mov    %edi,%eax
  801171:	c1 e8 0c             	shr    $0xc,%eax
  801174:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801177:	e8 9b fc ff ff       	call   800e17 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80117c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801182:	0f 84 de 00 00 00    	je     801266 <pgfault+0x108>
  801188:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  80118a:	85 c0                	test   %eax,%eax
  80118c:	79 20                	jns    8011ae <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  80118e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801192:	c7 44 24 08 02 34 80 	movl   $0x803402,0x8(%esp)
  801199:	00 
  80119a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8011a1:	00 
  8011a2:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  8011a9:	e8 cc f0 ff ff       	call   80027a <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  8011ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  8011b8:	25 05 08 00 00       	and    $0x805,%eax
  8011bd:	3d 05 08 00 00       	cmp    $0x805,%eax
  8011c2:	0f 85 ba 00 00 00    	jne    801282 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8011c8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011cf:	00 
  8011d0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011d7:	00 
  8011d8:	89 1c 24             	mov    %ebx,(%esp)
  8011db:	e8 75 fc ff ff       	call   800e55 <sys_page_alloc>
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	79 20                	jns    801204 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  8011e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011e8:	c7 44 24 08 29 34 80 	movl   $0x803429,0x8(%esp)
  8011ef:	00 
  8011f0:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8011f7:	00 
  8011f8:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  8011ff:	e8 76 f0 ff ff       	call   80027a <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801204:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80120a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801211:	00 
  801212:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801216:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80121d:	e8 62 f9 ff ff       	call   800b84 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801222:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801229:	00 
  80122a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80122e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801232:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801239:	00 
  80123a:	89 1c 24             	mov    %ebx,(%esp)
  80123d:	e8 67 fc ff ff       	call   800ea9 <sys_page_map>
  801242:	85 c0                	test   %eax,%eax
  801244:	79 3c                	jns    801282 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801246:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80124a:	c7 44 24 08 3c 34 80 	movl   $0x80343c,0x8(%esp)
  801251:	00 
  801252:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801259:	00 
  80125a:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  801261:	e8 14 f0 ff ff       	call   80027a <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801266:	c7 44 24 08 60 34 80 	movl   $0x803460,0x8(%esp)
  80126d:	00 
  80126e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801275:	00 
  801276:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  80127d:	e8 f8 ef ff ff       	call   80027a <_panic>
}
  801282:	83 c4 2c             	add    $0x2c,%esp
  801285:	5b                   	pop    %ebx
  801286:	5e                   	pop    %esi
  801287:	5f                   	pop    %edi
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    

0080128a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	56                   	push   %esi
  80128e:	53                   	push   %ebx
  80128f:	83 ec 20             	sub    $0x20,%esp
  801292:	8b 75 08             	mov    0x8(%ebp),%esi
  801295:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801298:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80129f:	00 
  8012a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012a4:	89 34 24             	mov    %esi,(%esp)
  8012a7:	e8 a9 fb ff ff       	call   800e55 <sys_page_alloc>
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	79 20                	jns    8012d0 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  8012b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012b4:	c7 44 24 08 29 34 80 	movl   $0x803429,0x8(%esp)
  8012bb:	00 
  8012bc:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8012c3:	00 
  8012c4:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  8012cb:	e8 aa ef ff ff       	call   80027a <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8012d0:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8012d7:	00 
  8012d8:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8012df:	00 
  8012e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012e7:	00 
  8012e8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012ec:	89 34 24             	mov    %esi,(%esp)
  8012ef:	e8 b5 fb ff ff       	call   800ea9 <sys_page_map>
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	79 20                	jns    801318 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  8012f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012fc:	c7 44 24 08 3c 34 80 	movl   $0x80343c,0x8(%esp)
  801303:	00 
  801304:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80130b:	00 
  80130c:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  801313:	e8 62 ef ff ff       	call   80027a <_panic>
	memmove(UTEMP, addr, PGSIZE);
  801318:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80131f:	00 
  801320:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801324:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  80132b:	e8 54 f8 ff ff       	call   800b84 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801330:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801337:	00 
  801338:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133f:	e8 b8 fb ff ff       	call   800efc <sys_page_unmap>
  801344:	85 c0                	test   %eax,%eax
  801346:	79 20                	jns    801368 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801348:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80134c:	c7 44 24 08 4d 34 80 	movl   $0x80344d,0x8(%esp)
  801353:	00 
  801354:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80135b:	00 
  80135c:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  801363:	e8 12 ef ff ff       	call   80027a <_panic>

}
  801368:	83 c4 20             	add    $0x20,%esp
  80136b:	5b                   	pop    %ebx
  80136c:	5e                   	pop    %esi
  80136d:	5d                   	pop    %ebp
  80136e:	c3                   	ret    

0080136f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	57                   	push   %edi
  801373:	56                   	push   %esi
  801374:	53                   	push   %ebx
  801375:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801378:	c7 04 24 5e 11 80 00 	movl   $0x80115e,(%esp)
  80137f:	e8 42 17 00 00       	call   802ac6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801384:	b8 08 00 00 00       	mov    $0x8,%eax
  801389:	cd 30                	int    $0x30
  80138b:	89 c6                	mov    %eax,%esi
  80138d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801390:	85 c0                	test   %eax,%eax
  801392:	79 20                	jns    8013b4 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801394:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801398:	c7 44 24 08 84 34 80 	movl   $0x803484,0x8(%esp)
  80139f:	00 
  8013a0:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  8013a7:	00 
  8013a8:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  8013af:	e8 c6 ee ff ff       	call   80027a <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8013b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	75 21                	jne    8013de <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8013bd:	e8 55 fa ff ff       	call   800e17 <sys_getenvid>
  8013c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013c7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013ca:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013cf:	a3 20 54 80 00       	mov    %eax,0x805420
		//set_pgfault_handler(pgfault);
		return 0;
  8013d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d9:	e9 88 01 00 00       	jmp    801566 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8013de:	89 d8                	mov    %ebx,%eax
  8013e0:	c1 e8 16             	shr    $0x16,%eax
  8013e3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013ea:	a8 01                	test   $0x1,%al
  8013ec:	0f 84 e0 00 00 00    	je     8014d2 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8013f2:	89 df                	mov    %ebx,%edi
  8013f4:	c1 ef 0c             	shr    $0xc,%edi
  8013f7:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  8013fe:	a8 01                	test   $0x1,%al
  801400:	0f 84 c4 00 00 00    	je     8014ca <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801406:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  80140d:	f6 c4 04             	test   $0x4,%ah
  801410:	74 0d                	je     80141f <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  801412:	25 07 0e 00 00       	and    $0xe07,%eax
  801417:	83 c8 05             	or     $0x5,%eax
  80141a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80141d:	eb 1b                	jmp    80143a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  80141f:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801424:	83 f8 01             	cmp    $0x1,%eax
  801427:	19 c0                	sbb    %eax,%eax
  801429:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80142c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801433:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  80143a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  80143d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801440:	89 44 24 10          	mov    %eax,0x10(%esp)
  801444:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801448:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80144f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801453:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80145a:	e8 4a fa ff ff       	call   800ea9 <sys_page_map>
  80145f:	85 c0                	test   %eax,%eax
  801461:	79 20                	jns    801483 <fork+0x114>
		panic("sys_page_map: %e", r);
  801463:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801467:	c7 44 24 08 3c 34 80 	movl   $0x80343c,0x8(%esp)
  80146e:	00 
  80146f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801476:	00 
  801477:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  80147e:	e8 f7 ed ff ff       	call   80027a <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801486:	89 44 24 10          	mov    %eax,0x10(%esp)
  80148a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80148e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801495:	00 
  801496:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80149a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014a1:	e8 03 fa ff ff       	call   800ea9 <sys_page_map>
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	79 20                	jns    8014ca <fork+0x15b>
		panic("sys_page_map: %e", r);
  8014aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014ae:	c7 44 24 08 3c 34 80 	movl   $0x80343c,0x8(%esp)
  8014b5:	00 
  8014b6:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  8014bd:	00 
  8014be:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  8014c5:	e8 b0 ed ff ff       	call   80027a <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8014ca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014d0:	eb 06                	jmp    8014d8 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  8014d2:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  8014d8:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  8014de:	0f 86 fa fe ff ff    	jbe    8013de <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8014e4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014eb:	00 
  8014ec:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014f3:	ee 
  8014f4:	89 34 24             	mov    %esi,(%esp)
  8014f7:	e8 59 f9 ff ff       	call   800e55 <sys_page_alloc>
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	79 20                	jns    801520 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801500:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801504:	c7 44 24 08 29 34 80 	movl   $0x803429,0x8(%esp)
  80150b:	00 
  80150c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  801513:	00 
  801514:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  80151b:	e8 5a ed ff ff       	call   80027a <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801520:	c7 44 24 04 59 2b 80 	movl   $0x802b59,0x4(%esp)
  801527:	00 
  801528:	89 34 24             	mov    %esi,(%esp)
  80152b:	e8 e5 fa ff ff       	call   801015 <sys_env_set_pgfault_upcall>
  801530:	85 c0                	test   %eax,%eax
  801532:	79 20                	jns    801554 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801534:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801538:	c7 44 24 08 a8 34 80 	movl   $0x8034a8,0x8(%esp)
  80153f:	00 
  801540:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801547:	00 
  801548:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  80154f:	e8 26 ed ff ff       	call   80027a <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801554:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80155b:	00 
  80155c:	89 34 24             	mov    %esi,(%esp)
  80155f:	e8 0b fa ff ff       	call   800f6f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801564:	89 f0                	mov    %esi,%eax

}
  801566:	83 c4 2c             	add    $0x2c,%esp
  801569:	5b                   	pop    %ebx
  80156a:	5e                   	pop    %esi
  80156b:	5f                   	pop    %edi
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    

0080156e <sfork>:

// Challenge!
int
sfork(void)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	57                   	push   %edi
  801572:	56                   	push   %esi
  801573:	53                   	push   %ebx
  801574:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801577:	c7 04 24 5e 11 80 00 	movl   $0x80115e,(%esp)
  80157e:	e8 43 15 00 00       	call   802ac6 <set_pgfault_handler>
  801583:	b8 08 00 00 00       	mov    $0x8,%eax
  801588:	cd 30                	int    $0x30
  80158a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  80158c:	85 c0                	test   %eax,%eax
  80158e:	79 20                	jns    8015b0 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801590:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801594:	c7 44 24 08 84 34 80 	movl   $0x803484,0x8(%esp)
  80159b:	00 
  80159c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  8015a3:	00 
  8015a4:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  8015ab:	e8 ca ec ff ff       	call   80027a <_panic>
  8015b0:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8015b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	75 2d                	jne    8015e8 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8015bb:	e8 57 f8 ff ff       	call   800e17 <sys_getenvid>
  8015c0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015c5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8015c8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015cd:	a3 20 54 80 00       	mov    %eax,0x805420
		set_pgfault_handler(pgfault);
  8015d2:	c7 04 24 5e 11 80 00 	movl   $0x80115e,(%esp)
  8015d9:	e8 e8 14 00 00       	call   802ac6 <set_pgfault_handler>
		return 0;
  8015de:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e3:	e9 1d 01 00 00       	jmp    801705 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8015e8:	89 d8                	mov    %ebx,%eax
  8015ea:	c1 e8 16             	shr    $0x16,%eax
  8015ed:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015f4:	a8 01                	test   $0x1,%al
  8015f6:	74 69                	je     801661 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8015f8:	89 d8                	mov    %ebx,%eax
  8015fa:	c1 e8 0c             	shr    $0xc,%eax
  8015fd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801604:	f6 c2 01             	test   $0x1,%dl
  801607:	74 50                	je     801659 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801609:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801610:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  801613:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801619:	89 54 24 10          	mov    %edx,0x10(%esp)
  80161d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801621:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801625:	89 44 24 04          	mov    %eax,0x4(%esp)
  801629:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801630:	e8 74 f8 ff ff       	call   800ea9 <sys_page_map>
  801635:	85 c0                	test   %eax,%eax
  801637:	79 20                	jns    801659 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801639:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80163d:	c7 44 24 08 3c 34 80 	movl   $0x80343c,0x8(%esp)
  801644:	00 
  801645:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  80164c:	00 
  80164d:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  801654:	e8 21 ec ff ff       	call   80027a <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80165f:	eb 06                	jmp    801667 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801661:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801667:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  80166d:	0f 86 75 ff ff ff    	jbe    8015e8 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801673:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  80167a:	ee 
  80167b:	89 34 24             	mov    %esi,(%esp)
  80167e:	e8 07 fc ff ff       	call   80128a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801683:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80168a:	00 
  80168b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801692:	ee 
  801693:	89 34 24             	mov    %esi,(%esp)
  801696:	e8 ba f7 ff ff       	call   800e55 <sys_page_alloc>
  80169b:	85 c0                	test   %eax,%eax
  80169d:	79 20                	jns    8016bf <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  80169f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016a3:	c7 44 24 08 29 34 80 	movl   $0x803429,0x8(%esp)
  8016aa:	00 
  8016ab:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  8016b2:	00 
  8016b3:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  8016ba:	e8 bb eb ff ff       	call   80027a <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8016bf:	c7 44 24 04 59 2b 80 	movl   $0x802b59,0x4(%esp)
  8016c6:	00 
  8016c7:	89 34 24             	mov    %esi,(%esp)
  8016ca:	e8 46 f9 ff ff       	call   801015 <sys_env_set_pgfault_upcall>
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	79 20                	jns    8016f3 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  8016d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016d7:	c7 44 24 08 a8 34 80 	movl   $0x8034a8,0x8(%esp)
  8016de:	00 
  8016df:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  8016e6:	00 
  8016e7:	c7 04 24 1e 34 80 00 	movl   $0x80341e,(%esp)
  8016ee:	e8 87 eb ff ff       	call   80027a <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  8016f3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8016fa:	00 
  8016fb:	89 34 24             	mov    %esi,(%esp)
  8016fe:	e8 6c f8 ff ff       	call   800f6f <sys_env_set_status>
	return envid;
  801703:	89 f0                	mov    %esi,%eax

}
  801705:	83 c4 2c             	add    $0x2c,%esp
  801708:	5b                   	pop    %ebx
  801709:	5e                   	pop    %esi
  80170a:	5f                   	pop    %edi
  80170b:	5d                   	pop    %ebp
  80170c:	c3                   	ret    
  80170d:	66 90                	xchg   %ax,%ax
  80170f:	90                   	nop

00801710 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	05 00 00 00 30       	add    $0x30000000,%eax
  80171b:	c1 e8 0c             	shr    $0xc,%eax
}
  80171e:	5d                   	pop    %ebp
  80171f:	c3                   	ret    

00801720 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80172b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801730:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801735:	5d                   	pop    %ebp
  801736:	c3                   	ret    

00801737 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801742:	89 c2                	mov    %eax,%edx
  801744:	c1 ea 16             	shr    $0x16,%edx
  801747:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80174e:	f6 c2 01             	test   $0x1,%dl
  801751:	74 11                	je     801764 <fd_alloc+0x2d>
  801753:	89 c2                	mov    %eax,%edx
  801755:	c1 ea 0c             	shr    $0xc,%edx
  801758:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80175f:	f6 c2 01             	test   $0x1,%dl
  801762:	75 09                	jne    80176d <fd_alloc+0x36>
			*fd_store = fd;
  801764:	89 01                	mov    %eax,(%ecx)
			return 0;
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	eb 17                	jmp    801784 <fd_alloc+0x4d>
  80176d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801772:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801777:	75 c9                	jne    801742 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801779:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80177f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801784:	5d                   	pop    %ebp
  801785:	c3                   	ret    

00801786 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80178c:	83 f8 1f             	cmp    $0x1f,%eax
  80178f:	77 36                	ja     8017c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801791:	c1 e0 0c             	shl    $0xc,%eax
  801794:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801799:	89 c2                	mov    %eax,%edx
  80179b:	c1 ea 16             	shr    $0x16,%edx
  80179e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017a5:	f6 c2 01             	test   $0x1,%dl
  8017a8:	74 24                	je     8017ce <fd_lookup+0x48>
  8017aa:	89 c2                	mov    %eax,%edx
  8017ac:	c1 ea 0c             	shr    $0xc,%edx
  8017af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017b6:	f6 c2 01             	test   $0x1,%dl
  8017b9:	74 1a                	je     8017d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017be:	89 02                	mov    %eax,(%edx)
	return 0;
  8017c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c5:	eb 13                	jmp    8017da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8017c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017cc:	eb 0c                	jmp    8017da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8017ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d3:	eb 05                	jmp    8017da <fd_lookup+0x54>
  8017d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    

008017dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 18             	sub    $0x18,%esp
  8017e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ea:	eb 13                	jmp    8017ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8017ec:	39 08                	cmp    %ecx,(%eax)
  8017ee:	75 0c                	jne    8017fc <dev_lookup+0x20>
			*dev = devtab[i];
  8017f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fa:	eb 38                	jmp    801834 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017fc:	83 c2 01             	add    $0x1,%edx
  8017ff:	8b 04 95 48 35 80 00 	mov    0x803548(,%edx,4),%eax
  801806:	85 c0                	test   %eax,%eax
  801808:	75 e2                	jne    8017ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80180a:	a1 20 54 80 00       	mov    0x805420,%eax
  80180f:	8b 40 48             	mov    0x48(%eax),%eax
  801812:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801816:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181a:	c7 04 24 cc 34 80 00 	movl   $0x8034cc,(%esp)
  801821:	e8 4d eb ff ff       	call   800373 <cprintf>
	*dev = 0;
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80182f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	83 ec 20             	sub    $0x20,%esp
  80183e:	8b 75 08             	mov    0x8(%ebp),%esi
  801841:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801844:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801847:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80184b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801851:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801854:	89 04 24             	mov    %eax,(%esp)
  801857:	e8 2a ff ff ff       	call   801786 <fd_lookup>
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 05                	js     801865 <fd_close+0x2f>
	    || fd != fd2)
  801860:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801863:	74 0c                	je     801871 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801865:	84 db                	test   %bl,%bl
  801867:	ba 00 00 00 00       	mov    $0x0,%edx
  80186c:	0f 44 c2             	cmove  %edx,%eax
  80186f:	eb 3f                	jmp    8018b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801871:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801874:	89 44 24 04          	mov    %eax,0x4(%esp)
  801878:	8b 06                	mov    (%esi),%eax
  80187a:	89 04 24             	mov    %eax,(%esp)
  80187d:	e8 5a ff ff ff       	call   8017dc <dev_lookup>
  801882:	89 c3                	mov    %eax,%ebx
  801884:	85 c0                	test   %eax,%eax
  801886:	78 16                	js     80189e <fd_close+0x68>
		if (dev->dev_close)
  801888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80188e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801893:	85 c0                	test   %eax,%eax
  801895:	74 07                	je     80189e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801897:	89 34 24             	mov    %esi,(%esp)
  80189a:	ff d0                	call   *%eax
  80189c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80189e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a9:	e8 4e f6 ff ff       	call   800efc <sys_page_unmap>
	return r;
  8018ae:	89 d8                	mov    %ebx,%eax
}
  8018b0:	83 c4 20             	add    $0x20,%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5e                   	pop    %esi
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	89 04 24             	mov    %eax,(%esp)
  8018ca:	e8 b7 fe ff ff       	call   801786 <fd_lookup>
  8018cf:	89 c2                	mov    %eax,%edx
  8018d1:	85 d2                	test   %edx,%edx
  8018d3:	78 13                	js     8018e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8018d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018dc:	00 
  8018dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e0:	89 04 24             	mov    %eax,(%esp)
  8018e3:	e8 4e ff ff ff       	call   801836 <fd_close>
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <close_all>:

void
close_all(void)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	53                   	push   %ebx
  8018ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018f6:	89 1c 24             	mov    %ebx,(%esp)
  8018f9:	e8 b9 ff ff ff       	call   8018b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8018fe:	83 c3 01             	add    $0x1,%ebx
  801901:	83 fb 20             	cmp    $0x20,%ebx
  801904:	75 f0                	jne    8018f6 <close_all+0xc>
		close(i);
}
  801906:	83 c4 14             	add    $0x14,%esp
  801909:	5b                   	pop    %ebx
  80190a:	5d                   	pop    %ebp
  80190b:	c3                   	ret    

0080190c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	57                   	push   %edi
  801910:	56                   	push   %esi
  801911:	53                   	push   %ebx
  801912:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801915:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801918:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	89 04 24             	mov    %eax,(%esp)
  801922:	e8 5f fe ff ff       	call   801786 <fd_lookup>
  801927:	89 c2                	mov    %eax,%edx
  801929:	85 d2                	test   %edx,%edx
  80192b:	0f 88 e1 00 00 00    	js     801a12 <dup+0x106>
		return r;
	close(newfdnum);
  801931:	8b 45 0c             	mov    0xc(%ebp),%eax
  801934:	89 04 24             	mov    %eax,(%esp)
  801937:	e8 7b ff ff ff       	call   8018b7 <close>

	newfd = INDEX2FD(newfdnum);
  80193c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80193f:	c1 e3 0c             	shl    $0xc,%ebx
  801942:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80194b:	89 04 24             	mov    %eax,(%esp)
  80194e:	e8 cd fd ff ff       	call   801720 <fd2data>
  801953:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801955:	89 1c 24             	mov    %ebx,(%esp)
  801958:	e8 c3 fd ff ff       	call   801720 <fd2data>
  80195d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80195f:	89 f0                	mov    %esi,%eax
  801961:	c1 e8 16             	shr    $0x16,%eax
  801964:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80196b:	a8 01                	test   $0x1,%al
  80196d:	74 43                	je     8019b2 <dup+0xa6>
  80196f:	89 f0                	mov    %esi,%eax
  801971:	c1 e8 0c             	shr    $0xc,%eax
  801974:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80197b:	f6 c2 01             	test   $0x1,%dl
  80197e:	74 32                	je     8019b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801980:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801987:	25 07 0e 00 00       	and    $0xe07,%eax
  80198c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801990:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801994:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80199b:	00 
  80199c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019a7:	e8 fd f4 ff ff       	call   800ea9 <sys_page_map>
  8019ac:	89 c6                	mov    %eax,%esi
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 3e                	js     8019f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019b5:	89 c2                	mov    %eax,%edx
  8019b7:	c1 ea 0c             	shr    $0xc,%edx
  8019ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8019c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8019cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8019cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019d6:	00 
  8019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019e2:	e8 c2 f4 ff ff       	call   800ea9 <sys_page_map>
  8019e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8019e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019ec:	85 f6                	test   %esi,%esi
  8019ee:	79 22                	jns    801a12 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8019f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019fb:	e8 fc f4 ff ff       	call   800efc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a0b:	e8 ec f4 ff ff       	call   800efc <sys_page_unmap>
	return r;
  801a10:	89 f0                	mov    %esi,%eax
}
  801a12:	83 c4 3c             	add    $0x3c,%esp
  801a15:	5b                   	pop    %ebx
  801a16:	5e                   	pop    %esi
  801a17:	5f                   	pop    %edi
  801a18:	5d                   	pop    %ebp
  801a19:	c3                   	ret    

00801a1a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	53                   	push   %ebx
  801a1e:	83 ec 24             	sub    $0x24,%esp
  801a21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a24:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2b:	89 1c 24             	mov    %ebx,(%esp)
  801a2e:	e8 53 fd ff ff       	call   801786 <fd_lookup>
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	85 d2                	test   %edx,%edx
  801a37:	78 6d                	js     801aa6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a43:	8b 00                	mov    (%eax),%eax
  801a45:	89 04 24             	mov    %eax,(%esp)
  801a48:	e8 8f fd ff ff       	call   8017dc <dev_lookup>
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	78 55                	js     801aa6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a54:	8b 50 08             	mov    0x8(%eax),%edx
  801a57:	83 e2 03             	and    $0x3,%edx
  801a5a:	83 fa 01             	cmp    $0x1,%edx
  801a5d:	75 23                	jne    801a82 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a5f:	a1 20 54 80 00       	mov    0x805420,%eax
  801a64:	8b 40 48             	mov    0x48(%eax),%eax
  801a67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6f:	c7 04 24 0d 35 80 00 	movl   $0x80350d,(%esp)
  801a76:	e8 f8 e8 ff ff       	call   800373 <cprintf>
		return -E_INVAL;
  801a7b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a80:	eb 24                	jmp    801aa6 <read+0x8c>
	}
	if (!dev->dev_read)
  801a82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a85:	8b 52 08             	mov    0x8(%edx),%edx
  801a88:	85 d2                	test   %edx,%edx
  801a8a:	74 15                	je     801aa1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a9a:	89 04 24             	mov    %eax,(%esp)
  801a9d:	ff d2                	call   *%edx
  801a9f:	eb 05                	jmp    801aa6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801aa1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801aa6:	83 c4 24             	add    $0x24,%esp
  801aa9:	5b                   	pop    %ebx
  801aaa:	5d                   	pop    %ebp
  801aab:	c3                   	ret    

00801aac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	57                   	push   %edi
  801ab0:	56                   	push   %esi
  801ab1:	53                   	push   %ebx
  801ab2:	83 ec 1c             	sub    $0x1c,%esp
  801ab5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ab8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801abb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ac0:	eb 23                	jmp    801ae5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ac2:	89 f0                	mov    %esi,%eax
  801ac4:	29 d8                	sub    %ebx,%eax
  801ac6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aca:	89 d8                	mov    %ebx,%eax
  801acc:	03 45 0c             	add    0xc(%ebp),%eax
  801acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad3:	89 3c 24             	mov    %edi,(%esp)
  801ad6:	e8 3f ff ff ff       	call   801a1a <read>
		if (m < 0)
  801adb:	85 c0                	test   %eax,%eax
  801add:	78 10                	js     801aef <readn+0x43>
			return m;
		if (m == 0)
  801adf:	85 c0                	test   %eax,%eax
  801ae1:	74 0a                	je     801aed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ae3:	01 c3                	add    %eax,%ebx
  801ae5:	39 f3                	cmp    %esi,%ebx
  801ae7:	72 d9                	jb     801ac2 <readn+0x16>
  801ae9:	89 d8                	mov    %ebx,%eax
  801aeb:	eb 02                	jmp    801aef <readn+0x43>
  801aed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801aef:	83 c4 1c             	add    $0x1c,%esp
  801af2:	5b                   	pop    %ebx
  801af3:	5e                   	pop    %esi
  801af4:	5f                   	pop    %edi
  801af5:	5d                   	pop    %ebp
  801af6:	c3                   	ret    

00801af7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	53                   	push   %ebx
  801afb:	83 ec 24             	sub    $0x24,%esp
  801afe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b08:	89 1c 24             	mov    %ebx,(%esp)
  801b0b:	e8 76 fc ff ff       	call   801786 <fd_lookup>
  801b10:	89 c2                	mov    %eax,%edx
  801b12:	85 d2                	test   %edx,%edx
  801b14:	78 68                	js     801b7e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b20:	8b 00                	mov    (%eax),%eax
  801b22:	89 04 24             	mov    %eax,(%esp)
  801b25:	e8 b2 fc ff ff       	call   8017dc <dev_lookup>
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	78 50                	js     801b7e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b31:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b35:	75 23                	jne    801b5a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b37:	a1 20 54 80 00       	mov    0x805420,%eax
  801b3c:	8b 40 48             	mov    0x48(%eax),%eax
  801b3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b47:	c7 04 24 29 35 80 00 	movl   $0x803529,(%esp)
  801b4e:	e8 20 e8 ff ff       	call   800373 <cprintf>
		return -E_INVAL;
  801b53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b58:	eb 24                	jmp    801b7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b5d:	8b 52 0c             	mov    0xc(%edx),%edx
  801b60:	85 d2                	test   %edx,%edx
  801b62:	74 15                	je     801b79 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b72:	89 04 24             	mov    %eax,(%esp)
  801b75:	ff d2                	call   *%edx
  801b77:	eb 05                	jmp    801b7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801b79:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801b7e:	83 c4 24             	add    $0x24,%esp
  801b81:	5b                   	pop    %ebx
  801b82:	5d                   	pop    %ebp
  801b83:	c3                   	ret    

00801b84 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b8a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	89 04 24             	mov    %eax,(%esp)
  801b97:	e8 ea fb ff ff       	call   801786 <fd_lookup>
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	78 0e                	js     801bae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ba9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	53                   	push   %ebx
  801bb4:	83 ec 24             	sub    $0x24,%esp
  801bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc1:	89 1c 24             	mov    %ebx,(%esp)
  801bc4:	e8 bd fb ff ff       	call   801786 <fd_lookup>
  801bc9:	89 c2                	mov    %eax,%edx
  801bcb:	85 d2                	test   %edx,%edx
  801bcd:	78 61                	js     801c30 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd9:	8b 00                	mov    (%eax),%eax
  801bdb:	89 04 24             	mov    %eax,(%esp)
  801bde:	e8 f9 fb ff ff       	call   8017dc <dev_lookup>
  801be3:	85 c0                	test   %eax,%eax
  801be5:	78 49                	js     801c30 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bee:	75 23                	jne    801c13 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801bf0:	a1 20 54 80 00       	mov    0x805420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bf5:	8b 40 48             	mov    0x48(%eax),%eax
  801bf8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c00:	c7 04 24 ec 34 80 00 	movl   $0x8034ec,(%esp)
  801c07:	e8 67 e7 ff ff       	call   800373 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801c0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c11:	eb 1d                	jmp    801c30 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801c13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c16:	8b 52 18             	mov    0x18(%edx),%edx
  801c19:	85 d2                	test   %edx,%edx
  801c1b:	74 0e                	je     801c2b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c24:	89 04 24             	mov    %eax,(%esp)
  801c27:	ff d2                	call   *%edx
  801c29:	eb 05                	jmp    801c30 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801c2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801c30:	83 c4 24             	add    $0x24,%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5d                   	pop    %ebp
  801c35:	c3                   	ret    

00801c36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	53                   	push   %ebx
  801c3a:	83 ec 24             	sub    $0x24,%esp
  801c3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	89 04 24             	mov    %eax,(%esp)
  801c4d:	e8 34 fb ff ff       	call   801786 <fd_lookup>
  801c52:	89 c2                	mov    %eax,%edx
  801c54:	85 d2                	test   %edx,%edx
  801c56:	78 52                	js     801caa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c62:	8b 00                	mov    (%eax),%eax
  801c64:	89 04 24             	mov    %eax,(%esp)
  801c67:	e8 70 fb ff ff       	call   8017dc <dev_lookup>
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 3a                	js     801caa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c73:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c77:	74 2c                	je     801ca5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c79:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c7c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c83:	00 00 00 
	stat->st_isdir = 0;
  801c86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c8d:	00 00 00 
	stat->st_dev = dev;
  801c90:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c9d:	89 14 24             	mov    %edx,(%esp)
  801ca0:	ff 50 14             	call   *0x14(%eax)
  801ca3:	eb 05                	jmp    801caa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ca5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801caa:	83 c4 24             	add    $0x24,%esp
  801cad:	5b                   	pop    %ebx
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    

00801cb0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	56                   	push   %esi
  801cb4:	53                   	push   %ebx
  801cb5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cbf:	00 
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	89 04 24             	mov    %eax,(%esp)
  801cc6:	e8 99 02 00 00       	call   801f64 <open>
  801ccb:	89 c3                	mov    %eax,%ebx
  801ccd:	85 db                	test   %ebx,%ebx
  801ccf:	78 1b                	js     801cec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd8:	89 1c 24             	mov    %ebx,(%esp)
  801cdb:	e8 56 ff ff ff       	call   801c36 <fstat>
  801ce0:	89 c6                	mov    %eax,%esi
	close(fd);
  801ce2:	89 1c 24             	mov    %ebx,(%esp)
  801ce5:	e8 cd fb ff ff       	call   8018b7 <close>
	return r;
  801cea:	89 f0                	mov    %esi,%eax
}
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	56                   	push   %esi
  801cf7:	53                   	push   %ebx
  801cf8:	83 ec 10             	sub    $0x10,%esp
  801cfb:	89 c6                	mov    %eax,%esi
  801cfd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801cff:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d06:	75 11                	jne    801d19 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d0f:	e8 3b 0f 00 00       	call   802c4f <ipc_find_env>
  801d14:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d19:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d20:	00 
  801d21:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d28:	00 
  801d29:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d2d:	a1 00 50 80 00       	mov    0x805000,%eax
  801d32:	89 04 24             	mov    %eax,(%esp)
  801d35:	e8 ae 0e 00 00       	call   802be8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d41:	00 
  801d42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d4d:	e8 2e 0e 00 00       	call   802b80 <ipc_recv>
}
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	5b                   	pop    %ebx
  801d56:	5e                   	pop    %esi
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    

00801d59 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	8b 40 0c             	mov    0xc(%eax),%eax
  801d65:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d72:	ba 00 00 00 00       	mov    $0x0,%edx
  801d77:	b8 02 00 00 00       	mov    $0x2,%eax
  801d7c:	e8 72 ff ff ff       	call   801cf3 <fsipc>
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d94:	ba 00 00 00 00       	mov    $0x0,%edx
  801d99:	b8 06 00 00 00       	mov    $0x6,%eax
  801d9e:	e8 50 ff ff ff       	call   801cf3 <fsipc>
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	53                   	push   %ebx
  801da9:	83 ec 14             	sub    $0x14,%esp
  801dac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	8b 40 0c             	mov    0xc(%eax),%eax
  801db5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dba:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbf:	b8 05 00 00 00       	mov    $0x5,%eax
  801dc4:	e8 2a ff ff ff       	call   801cf3 <fsipc>
  801dc9:	89 c2                	mov    %eax,%edx
  801dcb:	85 d2                	test   %edx,%edx
  801dcd:	78 2b                	js     801dfa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dcf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801dd6:	00 
  801dd7:	89 1c 24             	mov    %ebx,(%esp)
  801dda:	e8 08 ec ff ff       	call   8009e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ddf:	a1 80 60 80 00       	mov    0x806080,%eax
  801de4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dea:	a1 84 60 80 00       	mov    0x806084,%eax
  801def:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfa:	83 c4 14             	add    $0x14,%esp
  801dfd:	5b                   	pop    %ebx
  801dfe:	5d                   	pop    %ebp
  801dff:	c3                   	ret    

00801e00 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	53                   	push   %ebx
  801e04:	83 ec 14             	sub    $0x14,%esp
  801e07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801e0a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801e10:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801e15:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e18:	8b 55 08             	mov    0x8(%ebp),%edx
  801e1b:	8b 52 0c             	mov    0xc(%edx),%edx
  801e1e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801e24:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801e29:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e34:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801e3b:	e8 44 ed ff ff       	call   800b84 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801e40:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801e47:	00 
  801e48:	c7 04 24 5c 35 80 00 	movl   $0x80355c,(%esp)
  801e4f:	e8 1f e5 ff ff       	call   800373 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e54:	ba 00 00 00 00       	mov    $0x0,%edx
  801e59:	b8 04 00 00 00       	mov    $0x4,%eax
  801e5e:	e8 90 fe ff ff       	call   801cf3 <fsipc>
  801e63:	85 c0                	test   %eax,%eax
  801e65:	78 53                	js     801eba <devfile_write+0xba>
		return r;
	assert(r <= n);
  801e67:	39 c3                	cmp    %eax,%ebx
  801e69:	73 24                	jae    801e8f <devfile_write+0x8f>
  801e6b:	c7 44 24 0c 61 35 80 	movl   $0x803561,0xc(%esp)
  801e72:	00 
  801e73:	c7 44 24 08 68 35 80 	movl   $0x803568,0x8(%esp)
  801e7a:	00 
  801e7b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801e82:	00 
  801e83:	c7 04 24 7d 35 80 00 	movl   $0x80357d,(%esp)
  801e8a:	e8 eb e3 ff ff       	call   80027a <_panic>
	assert(r <= PGSIZE);
  801e8f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e94:	7e 24                	jle    801eba <devfile_write+0xba>
  801e96:	c7 44 24 0c 88 35 80 	movl   $0x803588,0xc(%esp)
  801e9d:	00 
  801e9e:	c7 44 24 08 68 35 80 	movl   $0x803568,0x8(%esp)
  801ea5:	00 
  801ea6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801ead:	00 
  801eae:	c7 04 24 7d 35 80 00 	movl   $0x80357d,(%esp)
  801eb5:	e8 c0 e3 ff ff       	call   80027a <_panic>
	return r;
}
  801eba:	83 c4 14             	add    $0x14,%esp
  801ebd:	5b                   	pop    %ebx
  801ebe:	5d                   	pop    %ebp
  801ebf:	c3                   	ret    

00801ec0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	56                   	push   %esi
  801ec4:	53                   	push   %ebx
  801ec5:	83 ec 10             	sub    $0x10,%esp
  801ec8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ed6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801edc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee1:	b8 03 00 00 00       	mov    $0x3,%eax
  801ee6:	e8 08 fe ff ff       	call   801cf3 <fsipc>
  801eeb:	89 c3                	mov    %eax,%ebx
  801eed:	85 c0                	test   %eax,%eax
  801eef:	78 6a                	js     801f5b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ef1:	39 c6                	cmp    %eax,%esi
  801ef3:	73 24                	jae    801f19 <devfile_read+0x59>
  801ef5:	c7 44 24 0c 61 35 80 	movl   $0x803561,0xc(%esp)
  801efc:	00 
  801efd:	c7 44 24 08 68 35 80 	movl   $0x803568,0x8(%esp)
  801f04:	00 
  801f05:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801f0c:	00 
  801f0d:	c7 04 24 7d 35 80 00 	movl   $0x80357d,(%esp)
  801f14:	e8 61 e3 ff ff       	call   80027a <_panic>
	assert(r <= PGSIZE);
  801f19:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f1e:	7e 24                	jle    801f44 <devfile_read+0x84>
  801f20:	c7 44 24 0c 88 35 80 	movl   $0x803588,0xc(%esp)
  801f27:	00 
  801f28:	c7 44 24 08 68 35 80 	movl   $0x803568,0x8(%esp)
  801f2f:	00 
  801f30:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801f37:	00 
  801f38:	c7 04 24 7d 35 80 00 	movl   $0x80357d,(%esp)
  801f3f:	e8 36 e3 ff ff       	call   80027a <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f44:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f48:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f4f:	00 
  801f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f53:	89 04 24             	mov    %eax,(%esp)
  801f56:	e8 29 ec ff ff       	call   800b84 <memmove>
	return r;
}
  801f5b:	89 d8                	mov    %ebx,%eax
  801f5d:	83 c4 10             	add    $0x10,%esp
  801f60:	5b                   	pop    %ebx
  801f61:	5e                   	pop    %esi
  801f62:	5d                   	pop    %ebp
  801f63:	c3                   	ret    

00801f64 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	53                   	push   %ebx
  801f68:	83 ec 24             	sub    $0x24,%esp
  801f6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801f6e:	89 1c 24             	mov    %ebx,(%esp)
  801f71:	e8 3a ea ff ff       	call   8009b0 <strlen>
  801f76:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f7b:	7f 60                	jg     801fdd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801f7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f80:	89 04 24             	mov    %eax,(%esp)
  801f83:	e8 af f7 ff ff       	call   801737 <fd_alloc>
  801f88:	89 c2                	mov    %eax,%edx
  801f8a:	85 d2                	test   %edx,%edx
  801f8c:	78 54                	js     801fe2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801f8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f92:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801f99:	e8 49 ea ff ff       	call   8009e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa1:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fae:	e8 40 fd ff ff       	call   801cf3 <fsipc>
  801fb3:	89 c3                	mov    %eax,%ebx
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	79 17                	jns    801fd0 <open+0x6c>
		fd_close(fd, 0);
  801fb9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fc0:	00 
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	89 04 24             	mov    %eax,(%esp)
  801fc7:	e8 6a f8 ff ff       	call   801836 <fd_close>
		return r;
  801fcc:	89 d8                	mov    %ebx,%eax
  801fce:	eb 12                	jmp    801fe2 <open+0x7e>
	}

	return fd2num(fd);
  801fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd3:	89 04 24             	mov    %eax,(%esp)
  801fd6:	e8 35 f7 ff ff       	call   801710 <fd2num>
  801fdb:	eb 05                	jmp    801fe2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801fdd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801fe2:	83 c4 24             	add    $0x24,%esp
  801fe5:	5b                   	pop    %ebx
  801fe6:	5d                   	pop    %ebp
  801fe7:	c3                   	ret    

00801fe8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fee:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff3:	b8 08 00 00 00       	mov    $0x8,%eax
  801ff8:	e8 f6 fc ff ff       	call   801cf3 <fsipc>
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <evict>:

int evict(void)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  802005:	c7 04 24 94 35 80 00 	movl   $0x803594,(%esp)
  80200c:	e8 62 e3 ff ff       	call   800373 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  802011:	ba 00 00 00 00       	mov    $0x0,%edx
  802016:	b8 09 00 00 00       	mov    $0x9,%eax
  80201b:	e8 d3 fc ff ff       	call   801cf3 <fsipc>
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    
  802022:	66 90                	xchg   %ax,%ax
  802024:	66 90                	xchg   %ax,%ax
  802026:	66 90                	xchg   %ax,%ax
  802028:	66 90                	xchg   %ax,%ax
  80202a:	66 90                	xchg   %ax,%ax
  80202c:	66 90                	xchg   %ax,%ax
  80202e:	66 90                	xchg   %ax,%ax

00802030 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802036:	c7 44 24 04 ad 35 80 	movl   $0x8035ad,0x4(%esp)
  80203d:	00 
  80203e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802041:	89 04 24             	mov    %eax,(%esp)
  802044:	e8 9e e9 ff ff       	call   8009e7 <strcpy>
	return 0;
}
  802049:	b8 00 00 00 00       	mov    $0x0,%eax
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	53                   	push   %ebx
  802054:	83 ec 14             	sub    $0x14,%esp
  802057:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80205a:	89 1c 24             	mov    %ebx,(%esp)
  80205d:	e8 25 0c 00 00       	call   802c87 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802062:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802067:	83 f8 01             	cmp    $0x1,%eax
  80206a:	75 0d                	jne    802079 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80206c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80206f:	89 04 24             	mov    %eax,(%esp)
  802072:	e8 29 03 00 00       	call   8023a0 <nsipc_close>
  802077:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802079:	89 d0                	mov    %edx,%eax
  80207b:	83 c4 14             	add    $0x14,%esp
  80207e:	5b                   	pop    %ebx
  80207f:	5d                   	pop    %ebp
  802080:	c3                   	ret    

00802081 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802087:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80208e:	00 
  80208f:	8b 45 10             	mov    0x10(%ebp),%eax
  802092:	89 44 24 08          	mov    %eax,0x8(%esp)
  802096:	8b 45 0c             	mov    0xc(%ebp),%eax
  802099:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a3:	89 04 24             	mov    %eax,(%esp)
  8020a6:	e8 f0 03 00 00       	call   80249b <nsipc_send>
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020ba:	00 
  8020bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8020be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8020cf:	89 04 24             	mov    %eax,(%esp)
  8020d2:	e8 44 03 00 00       	call   80241b <nsipc_recv>
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020df:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020e6:	89 04 24             	mov    %eax,(%esp)
  8020e9:	e8 98 f6 ff ff       	call   801786 <fd_lookup>
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	78 17                	js     802109 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8020fb:	39 08                	cmp    %ecx,(%eax)
  8020fd:	75 05                	jne    802104 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8020ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802102:	eb 05                	jmp    802109 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802104:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	56                   	push   %esi
  80210f:	53                   	push   %ebx
  802110:	83 ec 20             	sub    $0x20,%esp
  802113:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802115:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802118:	89 04 24             	mov    %eax,(%esp)
  80211b:	e8 17 f6 ff ff       	call   801737 <fd_alloc>
  802120:	89 c3                	mov    %eax,%ebx
  802122:	85 c0                	test   %eax,%eax
  802124:	78 21                	js     802147 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802126:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80212d:	00 
  80212e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802131:	89 44 24 04          	mov    %eax,0x4(%esp)
  802135:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213c:	e8 14 ed ff ff       	call   800e55 <sys_page_alloc>
  802141:	89 c3                	mov    %eax,%ebx
  802143:	85 c0                	test   %eax,%eax
  802145:	79 0c                	jns    802153 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802147:	89 34 24             	mov    %esi,(%esp)
  80214a:	e8 51 02 00 00       	call   8023a0 <nsipc_close>
		return r;
  80214f:	89 d8                	mov    %ebx,%eax
  802151:	eb 20                	jmp    802173 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802153:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80215e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802161:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802168:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80216b:	89 14 24             	mov    %edx,(%esp)
  80216e:	e8 9d f5 ff ff       	call   801710 <fd2num>
}
  802173:	83 c4 20             	add    $0x20,%esp
  802176:	5b                   	pop    %ebx
  802177:	5e                   	pop    %esi
  802178:	5d                   	pop    %ebp
  802179:	c3                   	ret    

0080217a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	e8 51 ff ff ff       	call   8020d9 <fd2sockid>
		return r;
  802188:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80218a:	85 c0                	test   %eax,%eax
  80218c:	78 23                	js     8021b1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80218e:	8b 55 10             	mov    0x10(%ebp),%edx
  802191:	89 54 24 08          	mov    %edx,0x8(%esp)
  802195:	8b 55 0c             	mov    0xc(%ebp),%edx
  802198:	89 54 24 04          	mov    %edx,0x4(%esp)
  80219c:	89 04 24             	mov    %eax,(%esp)
  80219f:	e8 45 01 00 00       	call   8022e9 <nsipc_accept>
		return r;
  8021a4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	78 07                	js     8021b1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8021aa:	e8 5c ff ff ff       	call   80210b <alloc_sockfd>
  8021af:	89 c1                	mov    %eax,%ecx
}
  8021b1:	89 c8                	mov    %ecx,%eax
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	e8 16 ff ff ff       	call   8020d9 <fd2sockid>
  8021c3:	89 c2                	mov    %eax,%edx
  8021c5:	85 d2                	test   %edx,%edx
  8021c7:	78 16                	js     8021df <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8021c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d7:	89 14 24             	mov    %edx,(%esp)
  8021da:	e8 60 01 00 00       	call   80233f <nsipc_bind>
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <shutdown>:

int
shutdown(int s, int how)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	e8 ea fe ff ff       	call   8020d9 <fd2sockid>
  8021ef:	89 c2                	mov    %eax,%edx
  8021f1:	85 d2                	test   %edx,%edx
  8021f3:	78 0f                	js     802204 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8021f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021fc:	89 14 24             	mov    %edx,(%esp)
  8021ff:	e8 7a 01 00 00       	call   80237e <nsipc_shutdown>
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	e8 c5 fe ff ff       	call   8020d9 <fd2sockid>
  802214:	89 c2                	mov    %eax,%edx
  802216:	85 d2                	test   %edx,%edx
  802218:	78 16                	js     802230 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80221a:	8b 45 10             	mov    0x10(%ebp),%eax
  80221d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802221:	8b 45 0c             	mov    0xc(%ebp),%eax
  802224:	89 44 24 04          	mov    %eax,0x4(%esp)
  802228:	89 14 24             	mov    %edx,(%esp)
  80222b:	e8 8a 01 00 00       	call   8023ba <nsipc_connect>
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <listen>:

int
listen(int s, int backlog)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	e8 99 fe ff ff       	call   8020d9 <fd2sockid>
  802240:	89 c2                	mov    %eax,%edx
  802242:	85 d2                	test   %edx,%edx
  802244:	78 0f                	js     802255 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802246:	8b 45 0c             	mov    0xc(%ebp),%eax
  802249:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224d:	89 14 24             	mov    %edx,(%esp)
  802250:	e8 a4 01 00 00       	call   8023f9 <nsipc_listen>
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80225d:	8b 45 10             	mov    0x10(%ebp),%eax
  802260:	89 44 24 08          	mov    %eax,0x8(%esp)
  802264:	8b 45 0c             	mov    0xc(%ebp),%eax
  802267:	89 44 24 04          	mov    %eax,0x4(%esp)
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	89 04 24             	mov    %eax,(%esp)
  802271:	e8 98 02 00 00       	call   80250e <nsipc_socket>
  802276:	89 c2                	mov    %eax,%edx
  802278:	85 d2                	test   %edx,%edx
  80227a:	78 05                	js     802281 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80227c:	e8 8a fe ff ff       	call   80210b <alloc_sockfd>
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	53                   	push   %ebx
  802287:	83 ec 14             	sub    $0x14,%esp
  80228a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80228c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802293:	75 11                	jne    8022a6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802295:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80229c:	e8 ae 09 00 00       	call   802c4f <ipc_find_env>
  8022a1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022a6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022ad:	00 
  8022ae:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8022b5:	00 
  8022b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022ba:	a1 04 50 80 00       	mov    0x805004,%eax
  8022bf:	89 04 24             	mov    %eax,(%esp)
  8022c2:	e8 21 09 00 00       	call   802be8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022ce:	00 
  8022cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022d6:	00 
  8022d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022de:	e8 9d 08 00 00       	call   802b80 <ipc_recv>
}
  8022e3:	83 c4 14             	add    $0x14,%esp
  8022e6:	5b                   	pop    %ebx
  8022e7:	5d                   	pop    %ebp
  8022e8:	c3                   	ret    

008022e9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	56                   	push   %esi
  8022ed:	53                   	push   %ebx
  8022ee:	83 ec 10             	sub    $0x10,%esp
  8022f1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022fc:	8b 06                	mov    (%esi),%eax
  8022fe:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802303:	b8 01 00 00 00       	mov    $0x1,%eax
  802308:	e8 76 ff ff ff       	call   802283 <nsipc>
  80230d:	89 c3                	mov    %eax,%ebx
  80230f:	85 c0                	test   %eax,%eax
  802311:	78 23                	js     802336 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802313:	a1 10 70 80 00       	mov    0x807010,%eax
  802318:	89 44 24 08          	mov    %eax,0x8(%esp)
  80231c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802323:	00 
  802324:	8b 45 0c             	mov    0xc(%ebp),%eax
  802327:	89 04 24             	mov    %eax,(%esp)
  80232a:	e8 55 e8 ff ff       	call   800b84 <memmove>
		*addrlen = ret->ret_addrlen;
  80232f:	a1 10 70 80 00       	mov    0x807010,%eax
  802334:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802336:	89 d8                	mov    %ebx,%eax
  802338:	83 c4 10             	add    $0x10,%esp
  80233b:	5b                   	pop    %ebx
  80233c:	5e                   	pop    %esi
  80233d:	5d                   	pop    %ebp
  80233e:	c3                   	ret    

0080233f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	53                   	push   %ebx
  802343:	83 ec 14             	sub    $0x14,%esp
  802346:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802351:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802355:	8b 45 0c             	mov    0xc(%ebp),%eax
  802358:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802363:	e8 1c e8 ff ff       	call   800b84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802368:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80236e:	b8 02 00 00 00       	mov    $0x2,%eax
  802373:	e8 0b ff ff ff       	call   802283 <nsipc>
}
  802378:	83 c4 14             	add    $0x14,%esp
  80237b:	5b                   	pop    %ebx
  80237c:	5d                   	pop    %ebp
  80237d:	c3                   	ret    

0080237e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80238c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802394:	b8 03 00 00 00       	mov    $0x3,%eax
  802399:	e8 e5 fe ff ff       	call   802283 <nsipc>
}
  80239e:	c9                   	leave  
  80239f:	c3                   	ret    

008023a0 <nsipc_close>:

int
nsipc_close(int s)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023ae:	b8 04 00 00 00       	mov    $0x4,%eax
  8023b3:	e8 cb fe ff ff       	call   802283 <nsipc>
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	53                   	push   %ebx
  8023be:	83 ec 14             	sub    $0x14,%esp
  8023c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8023de:	e8 a1 e7 ff ff       	call   800b84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023e3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8023ee:	e8 90 fe ff ff       	call   802283 <nsipc>
}
  8023f3:	83 c4 14             	add    $0x14,%esp
  8023f6:	5b                   	pop    %ebx
  8023f7:	5d                   	pop    %ebp
  8023f8:	c3                   	ret    

008023f9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80240f:	b8 06 00 00 00       	mov    $0x6,%eax
  802414:	e8 6a fe ff ff       	call   802283 <nsipc>
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	56                   	push   %esi
  80241f:	53                   	push   %ebx
  802420:	83 ec 10             	sub    $0x10,%esp
  802423:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80242e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802434:	8b 45 14             	mov    0x14(%ebp),%eax
  802437:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80243c:	b8 07 00 00 00       	mov    $0x7,%eax
  802441:	e8 3d fe ff ff       	call   802283 <nsipc>
  802446:	89 c3                	mov    %eax,%ebx
  802448:	85 c0                	test   %eax,%eax
  80244a:	78 46                	js     802492 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80244c:	39 f0                	cmp    %esi,%eax
  80244e:	7f 07                	jg     802457 <nsipc_recv+0x3c>
  802450:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802455:	7e 24                	jle    80247b <nsipc_recv+0x60>
  802457:	c7 44 24 0c b9 35 80 	movl   $0x8035b9,0xc(%esp)
  80245e:	00 
  80245f:	c7 44 24 08 68 35 80 	movl   $0x803568,0x8(%esp)
  802466:	00 
  802467:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80246e:	00 
  80246f:	c7 04 24 ce 35 80 00 	movl   $0x8035ce,(%esp)
  802476:	e8 ff dd ff ff       	call   80027a <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80247b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80247f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802486:	00 
  802487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248a:	89 04 24             	mov    %eax,(%esp)
  80248d:	e8 f2 e6 ff ff       	call   800b84 <memmove>
	}

	return r;
}
  802492:	89 d8                	mov    %ebx,%eax
  802494:	83 c4 10             	add    $0x10,%esp
  802497:	5b                   	pop    %ebx
  802498:	5e                   	pop    %esi
  802499:	5d                   	pop    %ebp
  80249a:	c3                   	ret    

0080249b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	53                   	push   %ebx
  80249f:	83 ec 14             	sub    $0x14,%esp
  8024a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8024ad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8024b3:	7e 24                	jle    8024d9 <nsipc_send+0x3e>
  8024b5:	c7 44 24 0c da 35 80 	movl   $0x8035da,0xc(%esp)
  8024bc:	00 
  8024bd:	c7 44 24 08 68 35 80 	movl   $0x803568,0x8(%esp)
  8024c4:	00 
  8024c5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8024cc:	00 
  8024cd:	c7 04 24 ce 35 80 00 	movl   $0x8035ce,(%esp)
  8024d4:	e8 a1 dd ff ff       	call   80027a <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8024d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8024eb:	e8 94 e6 ff ff       	call   800b84 <memmove>
	nsipcbuf.send.req_size = size;
  8024f0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8024f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8024fe:	b8 08 00 00 00       	mov    $0x8,%eax
  802503:	e8 7b fd ff ff       	call   802283 <nsipc>
}
  802508:	83 c4 14             	add    $0x14,%esp
  80250b:	5b                   	pop    %ebx
  80250c:	5d                   	pop    %ebp
  80250d:	c3                   	ret    

0080250e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80251c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802524:	8b 45 10             	mov    0x10(%ebp),%eax
  802527:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80252c:	b8 09 00 00 00       	mov    $0x9,%eax
  802531:	e8 4d fd ff ff       	call   802283 <nsipc>
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	56                   	push   %esi
  80253c:	53                   	push   %ebx
  80253d:	83 ec 10             	sub    $0x10,%esp
  802540:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	89 04 24             	mov    %eax,(%esp)
  802549:	e8 d2 f1 ff ff       	call   801720 <fd2data>
  80254e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802550:	c7 44 24 04 e6 35 80 	movl   $0x8035e6,0x4(%esp)
  802557:	00 
  802558:	89 1c 24             	mov    %ebx,(%esp)
  80255b:	e8 87 e4 ff ff       	call   8009e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802560:	8b 46 04             	mov    0x4(%esi),%eax
  802563:	2b 06                	sub    (%esi),%eax
  802565:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80256b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802572:	00 00 00 
	stat->st_dev = &devpipe;
  802575:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80257c:	40 80 00 
	return 0;
}
  80257f:	b8 00 00 00 00       	mov    $0x0,%eax
  802584:	83 c4 10             	add    $0x10,%esp
  802587:	5b                   	pop    %ebx
  802588:	5e                   	pop    %esi
  802589:	5d                   	pop    %ebp
  80258a:	c3                   	ret    

0080258b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
  80258e:	53                   	push   %ebx
  80258f:	83 ec 14             	sub    $0x14,%esp
  802592:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802595:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802599:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a0:	e8 57 e9 ff ff       	call   800efc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025a5:	89 1c 24             	mov    %ebx,(%esp)
  8025a8:	e8 73 f1 ff ff       	call   801720 <fd2data>
  8025ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025b8:	e8 3f e9 ff ff       	call   800efc <sys_page_unmap>
}
  8025bd:	83 c4 14             	add    $0x14,%esp
  8025c0:	5b                   	pop    %ebx
  8025c1:	5d                   	pop    %ebp
  8025c2:	c3                   	ret    

008025c3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	57                   	push   %edi
  8025c7:	56                   	push   %esi
  8025c8:	53                   	push   %ebx
  8025c9:	83 ec 2c             	sub    $0x2c,%esp
  8025cc:	89 c6                	mov    %eax,%esi
  8025ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8025d1:	a1 20 54 80 00       	mov    0x805420,%eax
  8025d6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025d9:	89 34 24             	mov    %esi,(%esp)
  8025dc:	e8 a6 06 00 00       	call   802c87 <pageref>
  8025e1:	89 c7                	mov    %eax,%edi
  8025e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e6:	89 04 24             	mov    %eax,(%esp)
  8025e9:	e8 99 06 00 00       	call   802c87 <pageref>
  8025ee:	39 c7                	cmp    %eax,%edi
  8025f0:	0f 94 c2             	sete   %dl
  8025f3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8025f6:	8b 0d 20 54 80 00    	mov    0x805420,%ecx
  8025fc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8025ff:	39 fb                	cmp    %edi,%ebx
  802601:	74 21                	je     802624 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802603:	84 d2                	test   %dl,%dl
  802605:	74 ca                	je     8025d1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802607:	8b 51 58             	mov    0x58(%ecx),%edx
  80260a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80260e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802612:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802616:	c7 04 24 ed 35 80 00 	movl   $0x8035ed,(%esp)
  80261d:	e8 51 dd ff ff       	call   800373 <cprintf>
  802622:	eb ad                	jmp    8025d1 <_pipeisclosed+0xe>
	}
}
  802624:	83 c4 2c             	add    $0x2c,%esp
  802627:	5b                   	pop    %ebx
  802628:	5e                   	pop    %esi
  802629:	5f                   	pop    %edi
  80262a:	5d                   	pop    %ebp
  80262b:	c3                   	ret    

0080262c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	57                   	push   %edi
  802630:	56                   	push   %esi
  802631:	53                   	push   %ebx
  802632:	83 ec 1c             	sub    $0x1c,%esp
  802635:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802638:	89 34 24             	mov    %esi,(%esp)
  80263b:	e8 e0 f0 ff ff       	call   801720 <fd2data>
  802640:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802642:	bf 00 00 00 00       	mov    $0x0,%edi
  802647:	eb 45                	jmp    80268e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802649:	89 da                	mov    %ebx,%edx
  80264b:	89 f0                	mov    %esi,%eax
  80264d:	e8 71 ff ff ff       	call   8025c3 <_pipeisclosed>
  802652:	85 c0                	test   %eax,%eax
  802654:	75 41                	jne    802697 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802656:	e8 db e7 ff ff       	call   800e36 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80265b:	8b 43 04             	mov    0x4(%ebx),%eax
  80265e:	8b 0b                	mov    (%ebx),%ecx
  802660:	8d 51 20             	lea    0x20(%ecx),%edx
  802663:	39 d0                	cmp    %edx,%eax
  802665:	73 e2                	jae    802649 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802667:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80266a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80266e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802671:	99                   	cltd   
  802672:	c1 ea 1b             	shr    $0x1b,%edx
  802675:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802678:	83 e1 1f             	and    $0x1f,%ecx
  80267b:	29 d1                	sub    %edx,%ecx
  80267d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802681:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802685:	83 c0 01             	add    $0x1,%eax
  802688:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80268b:	83 c7 01             	add    $0x1,%edi
  80268e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802691:	75 c8                	jne    80265b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802693:	89 f8                	mov    %edi,%eax
  802695:	eb 05                	jmp    80269c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80269c:	83 c4 1c             	add    $0x1c,%esp
  80269f:	5b                   	pop    %ebx
  8026a0:	5e                   	pop    %esi
  8026a1:	5f                   	pop    %edi
  8026a2:	5d                   	pop    %ebp
  8026a3:	c3                   	ret    

008026a4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	57                   	push   %edi
  8026a8:	56                   	push   %esi
  8026a9:	53                   	push   %ebx
  8026aa:	83 ec 1c             	sub    $0x1c,%esp
  8026ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8026b0:	89 3c 24             	mov    %edi,(%esp)
  8026b3:	e8 68 f0 ff ff       	call   801720 <fd2data>
  8026b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026ba:	be 00 00 00 00       	mov    $0x0,%esi
  8026bf:	eb 3d                	jmp    8026fe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8026c1:	85 f6                	test   %esi,%esi
  8026c3:	74 04                	je     8026c9 <devpipe_read+0x25>
				return i;
  8026c5:	89 f0                	mov    %esi,%eax
  8026c7:	eb 43                	jmp    80270c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8026c9:	89 da                	mov    %ebx,%edx
  8026cb:	89 f8                	mov    %edi,%eax
  8026cd:	e8 f1 fe ff ff       	call   8025c3 <_pipeisclosed>
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	75 31                	jne    802707 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8026d6:	e8 5b e7 ff ff       	call   800e36 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8026db:	8b 03                	mov    (%ebx),%eax
  8026dd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026e0:	74 df                	je     8026c1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026e2:	99                   	cltd   
  8026e3:	c1 ea 1b             	shr    $0x1b,%edx
  8026e6:	01 d0                	add    %edx,%eax
  8026e8:	83 e0 1f             	and    $0x1f,%eax
  8026eb:	29 d0                	sub    %edx,%eax
  8026ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8026f8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026fb:	83 c6 01             	add    $0x1,%esi
  8026fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  802701:	75 d8                	jne    8026db <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802703:	89 f0                	mov    %esi,%eax
  802705:	eb 05                	jmp    80270c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802707:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80270c:	83 c4 1c             	add    $0x1c,%esp
  80270f:	5b                   	pop    %ebx
  802710:	5e                   	pop    %esi
  802711:	5f                   	pop    %edi
  802712:	5d                   	pop    %ebp
  802713:	c3                   	ret    

00802714 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
  802717:	56                   	push   %esi
  802718:	53                   	push   %ebx
  802719:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80271c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80271f:	89 04 24             	mov    %eax,(%esp)
  802722:	e8 10 f0 ff ff       	call   801737 <fd_alloc>
  802727:	89 c2                	mov    %eax,%edx
  802729:	85 d2                	test   %edx,%edx
  80272b:	0f 88 4d 01 00 00    	js     80287e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802731:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802738:	00 
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802740:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802747:	e8 09 e7 ff ff       	call   800e55 <sys_page_alloc>
  80274c:	89 c2                	mov    %eax,%edx
  80274e:	85 d2                	test   %edx,%edx
  802750:	0f 88 28 01 00 00    	js     80287e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802756:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802759:	89 04 24             	mov    %eax,(%esp)
  80275c:	e8 d6 ef ff ff       	call   801737 <fd_alloc>
  802761:	89 c3                	mov    %eax,%ebx
  802763:	85 c0                	test   %eax,%eax
  802765:	0f 88 fe 00 00 00    	js     802869 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80276b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802772:	00 
  802773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802776:	89 44 24 04          	mov    %eax,0x4(%esp)
  80277a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802781:	e8 cf e6 ff ff       	call   800e55 <sys_page_alloc>
  802786:	89 c3                	mov    %eax,%ebx
  802788:	85 c0                	test   %eax,%eax
  80278a:	0f 88 d9 00 00 00    	js     802869 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	89 04 24             	mov    %eax,(%esp)
  802796:	e8 85 ef ff ff       	call   801720 <fd2data>
  80279b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80279d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027a4:	00 
  8027a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027b0:	e8 a0 e6 ff ff       	call   800e55 <sys_page_alloc>
  8027b5:	89 c3                	mov    %eax,%ebx
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	0f 88 97 00 00 00    	js     802856 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c2:	89 04 24             	mov    %eax,(%esp)
  8027c5:	e8 56 ef ff ff       	call   801720 <fd2data>
  8027ca:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8027d1:	00 
  8027d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8027dd:	00 
  8027de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027e9:	e8 bb e6 ff ff       	call   800ea9 <sys_page_map>
  8027ee:	89 c3                	mov    %eax,%ebx
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	78 52                	js     802846 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8027f4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802809:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80280f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802812:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802817:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	89 04 24             	mov    %eax,(%esp)
  802824:	e8 e7 ee ff ff       	call   801710 <fd2num>
  802829:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80282c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	89 04 24             	mov    %eax,(%esp)
  802834:	e8 d7 ee ff ff       	call   801710 <fd2num>
  802839:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80283c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80283f:	b8 00 00 00 00       	mov    $0x0,%eax
  802844:	eb 38                	jmp    80287e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802846:	89 74 24 04          	mov    %esi,0x4(%esp)
  80284a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802851:	e8 a6 e6 ff ff       	call   800efc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802859:	89 44 24 04          	mov    %eax,0x4(%esp)
  80285d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802864:	e8 93 e6 ff ff       	call   800efc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802870:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802877:	e8 80 e6 ff ff       	call   800efc <sys_page_unmap>
  80287c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80287e:	83 c4 30             	add    $0x30,%esp
  802881:	5b                   	pop    %ebx
  802882:	5e                   	pop    %esi
  802883:	5d                   	pop    %ebp
  802884:	c3                   	ret    

00802885 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802885:	55                   	push   %ebp
  802886:	89 e5                	mov    %esp,%ebp
  802888:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80288b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80288e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802892:	8b 45 08             	mov    0x8(%ebp),%eax
  802895:	89 04 24             	mov    %eax,(%esp)
  802898:	e8 e9 ee ff ff       	call   801786 <fd_lookup>
  80289d:	89 c2                	mov    %eax,%edx
  80289f:	85 d2                	test   %edx,%edx
  8028a1:	78 15                	js     8028b8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	89 04 24             	mov    %eax,(%esp)
  8028a9:	e8 72 ee ff ff       	call   801720 <fd2data>
	return _pipeisclosed(fd, p);
  8028ae:	89 c2                	mov    %eax,%edx
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	e8 0b fd ff ff       	call   8025c3 <_pipeisclosed>
}
  8028b8:	c9                   	leave  
  8028b9:	c3                   	ret    

008028ba <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8028ba:	55                   	push   %ebp
  8028bb:	89 e5                	mov    %esp,%ebp
  8028bd:	56                   	push   %esi
  8028be:	53                   	push   %ebx
  8028bf:	83 ec 10             	sub    $0x10,%esp
  8028c2:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8028c5:	85 f6                	test   %esi,%esi
  8028c7:	75 24                	jne    8028ed <wait+0x33>
  8028c9:	c7 44 24 0c 05 36 80 	movl   $0x803605,0xc(%esp)
  8028d0:	00 
  8028d1:	c7 44 24 08 68 35 80 	movl   $0x803568,0x8(%esp)
  8028d8:	00 
  8028d9:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8028e0:	00 
  8028e1:	c7 04 24 10 36 80 00 	movl   $0x803610,(%esp)
  8028e8:	e8 8d d9 ff ff       	call   80027a <_panic>
	e = &envs[ENVX(envid)];
  8028ed:	89 f3                	mov    %esi,%ebx
  8028ef:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8028f5:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8028f8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8028fe:	eb 05                	jmp    802905 <wait+0x4b>
		sys_yield();
  802900:	e8 31 e5 ff ff       	call   800e36 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802905:	8b 43 48             	mov    0x48(%ebx),%eax
  802908:	39 f0                	cmp    %esi,%eax
  80290a:	75 07                	jne    802913 <wait+0x59>
  80290c:	8b 43 54             	mov    0x54(%ebx),%eax
  80290f:	85 c0                	test   %eax,%eax
  802911:	75 ed                	jne    802900 <wait+0x46>
		sys_yield();
}
  802913:	83 c4 10             	add    $0x10,%esp
  802916:	5b                   	pop    %ebx
  802917:	5e                   	pop    %esi
  802918:	5d                   	pop    %ebp
  802919:	c3                   	ret    
  80291a:	66 90                	xchg   %ax,%ax
  80291c:	66 90                	xchg   %ax,%ax
  80291e:	66 90                	xchg   %ax,%ax

00802920 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802923:	b8 00 00 00 00       	mov    $0x0,%eax
  802928:	5d                   	pop    %ebp
  802929:	c3                   	ret    

0080292a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80292a:	55                   	push   %ebp
  80292b:	89 e5                	mov    %esp,%ebp
  80292d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802930:	c7 44 24 04 1b 36 80 	movl   $0x80361b,0x4(%esp)
  802937:	00 
  802938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80293b:	89 04 24             	mov    %eax,(%esp)
  80293e:	e8 a4 e0 ff ff       	call   8009e7 <strcpy>
	return 0;
}
  802943:	b8 00 00 00 00       	mov    $0x0,%eax
  802948:	c9                   	leave  
  802949:	c3                   	ret    

0080294a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	57                   	push   %edi
  80294e:	56                   	push   %esi
  80294f:	53                   	push   %ebx
  802950:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802956:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80295b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802961:	eb 31                	jmp    802994 <devcons_write+0x4a>
		m = n - tot;
  802963:	8b 75 10             	mov    0x10(%ebp),%esi
  802966:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802968:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80296b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802970:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802973:	89 74 24 08          	mov    %esi,0x8(%esp)
  802977:	03 45 0c             	add    0xc(%ebp),%eax
  80297a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80297e:	89 3c 24             	mov    %edi,(%esp)
  802981:	e8 fe e1 ff ff       	call   800b84 <memmove>
		sys_cputs(buf, m);
  802986:	89 74 24 04          	mov    %esi,0x4(%esp)
  80298a:	89 3c 24             	mov    %edi,(%esp)
  80298d:	e8 a4 e3 ff ff       	call   800d36 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802992:	01 f3                	add    %esi,%ebx
  802994:	89 d8                	mov    %ebx,%eax
  802996:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802999:	72 c8                	jb     802963 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80299b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8029a1:	5b                   	pop    %ebx
  8029a2:	5e                   	pop    %esi
  8029a3:	5f                   	pop    %edi
  8029a4:	5d                   	pop    %ebp
  8029a5:	c3                   	ret    

008029a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8029a6:	55                   	push   %ebp
  8029a7:	89 e5                	mov    %esp,%ebp
  8029a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8029ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8029b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029b5:	75 07                	jne    8029be <devcons_read+0x18>
  8029b7:	eb 2a                	jmp    8029e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8029b9:	e8 78 e4 ff ff       	call   800e36 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8029be:	66 90                	xchg   %ax,%ax
  8029c0:	e8 8f e3 ff ff       	call   800d54 <sys_cgetc>
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	74 f0                	je     8029b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8029c9:	85 c0                	test   %eax,%eax
  8029cb:	78 16                	js     8029e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8029cd:	83 f8 04             	cmp    $0x4,%eax
  8029d0:	74 0c                	je     8029de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8029d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d5:	88 02                	mov    %al,(%edx)
	return 1;
  8029d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8029dc:	eb 05                	jmp    8029e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8029de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8029e3:	c9                   	leave  
  8029e4:	c3                   	ret    

008029e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
  8029e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029f8:	00 
  8029f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029fc:	89 04 24             	mov    %eax,(%esp)
  8029ff:	e8 32 e3 ff ff       	call   800d36 <sys_cputs>
}
  802a04:	c9                   	leave  
  802a05:	c3                   	ret    

00802a06 <getchar>:

int
getchar(void)
{
  802a06:	55                   	push   %ebp
  802a07:	89 e5                	mov    %esp,%ebp
  802a09:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802a0c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802a13:	00 
  802a14:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a22:	e8 f3 ef ff ff       	call   801a1a <read>
	if (r < 0)
  802a27:	85 c0                	test   %eax,%eax
  802a29:	78 0f                	js     802a3a <getchar+0x34>
		return r;
	if (r < 1)
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	7e 06                	jle    802a35 <getchar+0x2f>
		return -E_EOF;
	return c;
  802a2f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802a33:	eb 05                	jmp    802a3a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802a35:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802a3a:	c9                   	leave  
  802a3b:	c3                   	ret    

00802a3c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a3c:	55                   	push   %ebp
  802a3d:	89 e5                	mov    %esp,%ebp
  802a3f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a45:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	89 04 24             	mov    %eax,(%esp)
  802a4f:	e8 32 ed ff ff       	call   801786 <fd_lookup>
  802a54:	85 c0                	test   %eax,%eax
  802a56:	78 11                	js     802a69 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a61:	39 10                	cmp    %edx,(%eax)
  802a63:	0f 94 c0             	sete   %al
  802a66:	0f b6 c0             	movzbl %al,%eax
}
  802a69:	c9                   	leave  
  802a6a:	c3                   	ret    

00802a6b <opencons>:

int
opencons(void)
{
  802a6b:	55                   	push   %ebp
  802a6c:	89 e5                	mov    %esp,%ebp
  802a6e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a74:	89 04 24             	mov    %eax,(%esp)
  802a77:	e8 bb ec ff ff       	call   801737 <fd_alloc>
		return r;
  802a7c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a7e:	85 c0                	test   %eax,%eax
  802a80:	78 40                	js     802ac2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a82:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a89:	00 
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a98:	e8 b8 e3 ff ff       	call   800e55 <sys_page_alloc>
		return r;
  802a9d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	78 1f                	js     802ac2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802aa3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802ab8:	89 04 24             	mov    %eax,(%esp)
  802abb:	e8 50 ec ff ff       	call   801710 <fd2num>
  802ac0:	89 c2                	mov    %eax,%edx
}
  802ac2:	89 d0                	mov    %edx,%eax
  802ac4:	c9                   	leave  
  802ac5:	c3                   	ret    

00802ac6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802ac6:	55                   	push   %ebp
  802ac7:	89 e5                	mov    %esp,%ebp
  802ac9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802acc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802ad3:	75 7a                	jne    802b4f <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802ad5:	e8 3d e3 ff ff       	call   800e17 <sys_getenvid>
  802ada:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802ae1:	00 
  802ae2:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802ae9:	ee 
  802aea:	89 04 24             	mov    %eax,(%esp)
  802aed:	e8 63 e3 ff ff       	call   800e55 <sys_page_alloc>
  802af2:	85 c0                	test   %eax,%eax
  802af4:	79 20                	jns    802b16 <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802af6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802afa:	c7 44 24 08 29 34 80 	movl   $0x803429,0x8(%esp)
  802b01:	00 
  802b02:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802b09:	00 
  802b0a:	c7 04 24 27 36 80 00 	movl   $0x803627,(%esp)
  802b11:	e8 64 d7 ff ff       	call   80027a <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802b16:	e8 fc e2 ff ff       	call   800e17 <sys_getenvid>
  802b1b:	c7 44 24 04 59 2b 80 	movl   $0x802b59,0x4(%esp)
  802b22:	00 
  802b23:	89 04 24             	mov    %eax,(%esp)
  802b26:	e8 ea e4 ff ff       	call   801015 <sys_env_set_pgfault_upcall>
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	79 20                	jns    802b4f <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802b2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b33:	c7 44 24 08 a8 34 80 	movl   $0x8034a8,0x8(%esp)
  802b3a:	00 
  802b3b:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802b42:	00 
  802b43:	c7 04 24 27 36 80 00 	movl   $0x803627,(%esp)
  802b4a:	e8 2b d7 ff ff       	call   80027a <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802b57:	c9                   	leave  
  802b58:	c3                   	ret    

00802b59 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b59:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b5a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802b5f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b61:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802b64:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802b68:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802b6c:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802b6f:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802b73:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802b75:	83 c4 08             	add    $0x8,%esp
	popal
  802b78:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802b79:	83 c4 04             	add    $0x4,%esp
	popfl
  802b7c:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802b7d:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802b7e:	c3                   	ret    
  802b7f:	90                   	nop

00802b80 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802b80:	55                   	push   %ebp
  802b81:	89 e5                	mov    %esp,%ebp
  802b83:	56                   	push   %esi
  802b84:	53                   	push   %ebx
  802b85:	83 ec 10             	sub    $0x10,%esp
  802b88:	8b 75 08             	mov    0x8(%ebp),%esi
  802b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802b91:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802b93:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802b98:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802b9b:	89 04 24             	mov    %eax,(%esp)
  802b9e:	e8 e8 e4 ff ff       	call   80108b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	75 26                	jne    802bcd <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802ba7:	85 f6                	test   %esi,%esi
  802ba9:	74 0a                	je     802bb5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802bab:	a1 20 54 80 00       	mov    0x805420,%eax
  802bb0:	8b 40 74             	mov    0x74(%eax),%eax
  802bb3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802bb5:	85 db                	test   %ebx,%ebx
  802bb7:	74 0a                	je     802bc3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802bb9:	a1 20 54 80 00       	mov    0x805420,%eax
  802bbe:	8b 40 78             	mov    0x78(%eax),%eax
  802bc1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802bc3:	a1 20 54 80 00       	mov    0x805420,%eax
  802bc8:	8b 40 70             	mov    0x70(%eax),%eax
  802bcb:	eb 14                	jmp    802be1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  802bcd:	85 f6                	test   %esi,%esi
  802bcf:	74 06                	je     802bd7 <ipc_recv+0x57>
			*from_env_store = 0;
  802bd1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802bd7:	85 db                	test   %ebx,%ebx
  802bd9:	74 06                	je     802be1 <ipc_recv+0x61>
			*perm_store = 0;
  802bdb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802be1:	83 c4 10             	add    $0x10,%esp
  802be4:	5b                   	pop    %ebx
  802be5:	5e                   	pop    %esi
  802be6:	5d                   	pop    %ebp
  802be7:	c3                   	ret    

00802be8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802be8:	55                   	push   %ebp
  802be9:	89 e5                	mov    %esp,%ebp
  802beb:	57                   	push   %edi
  802bec:	56                   	push   %esi
  802bed:	53                   	push   %ebx
  802bee:	83 ec 1c             	sub    $0x1c,%esp
  802bf1:	8b 7d 08             	mov    0x8(%ebp),%edi
  802bf4:	8b 75 0c             	mov    0xc(%ebp),%esi
  802bf7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  802bfa:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  802bfc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802c01:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802c04:	8b 45 14             	mov    0x14(%ebp),%eax
  802c07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c13:	89 3c 24             	mov    %edi,(%esp)
  802c16:	e8 4d e4 ff ff       	call   801068 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	74 28                	je     802c47 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802c1f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c22:	74 1c                	je     802c40 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802c24:	c7 44 24 08 38 36 80 	movl   $0x803638,0x8(%esp)
  802c2b:	00 
  802c2c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802c33:	00 
  802c34:	c7 04 24 5c 36 80 00 	movl   $0x80365c,(%esp)
  802c3b:	e8 3a d6 ff ff       	call   80027a <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802c40:	e8 f1 e1 ff ff       	call   800e36 <sys_yield>
	}
  802c45:	eb bd                	jmp    802c04 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802c47:	83 c4 1c             	add    $0x1c,%esp
  802c4a:	5b                   	pop    %ebx
  802c4b:	5e                   	pop    %esi
  802c4c:	5f                   	pop    %edi
  802c4d:	5d                   	pop    %ebp
  802c4e:	c3                   	ret    

00802c4f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802c4f:	55                   	push   %ebp
  802c50:	89 e5                	mov    %esp,%ebp
  802c52:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802c55:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802c5a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802c5d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802c63:	8b 52 50             	mov    0x50(%edx),%edx
  802c66:	39 ca                	cmp    %ecx,%edx
  802c68:	75 0d                	jne    802c77 <ipc_find_env+0x28>
			return envs[i].env_id;
  802c6a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802c6d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802c72:	8b 40 40             	mov    0x40(%eax),%eax
  802c75:	eb 0e                	jmp    802c85 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802c77:	83 c0 01             	add    $0x1,%eax
  802c7a:	3d 00 04 00 00       	cmp    $0x400,%eax
  802c7f:	75 d9                	jne    802c5a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802c81:	66 b8 00 00          	mov    $0x0,%ax
}
  802c85:	5d                   	pop    %ebp
  802c86:	c3                   	ret    

00802c87 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c87:	55                   	push   %ebp
  802c88:	89 e5                	mov    %esp,%ebp
  802c8a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c8d:	89 d0                	mov    %edx,%eax
  802c8f:	c1 e8 16             	shr    $0x16,%eax
  802c92:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802c99:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c9e:	f6 c1 01             	test   $0x1,%cl
  802ca1:	74 1d                	je     802cc0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802ca3:	c1 ea 0c             	shr    $0xc,%edx
  802ca6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802cad:	f6 c2 01             	test   $0x1,%dl
  802cb0:	74 0e                	je     802cc0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802cb2:	c1 ea 0c             	shr    $0xc,%edx
  802cb5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802cbc:	ef 
  802cbd:	0f b7 c0             	movzwl %ax,%eax
}
  802cc0:	5d                   	pop    %ebp
  802cc1:	c3                   	ret    
  802cc2:	66 90                	xchg   %ax,%ax
  802cc4:	66 90                	xchg   %ax,%ax
  802cc6:	66 90                	xchg   %ax,%ax
  802cc8:	66 90                	xchg   %ax,%ax
  802cca:	66 90                	xchg   %ax,%ax
  802ccc:	66 90                	xchg   %ax,%ax
  802cce:	66 90                	xchg   %ax,%ax

00802cd0 <__udivdi3>:
  802cd0:	55                   	push   %ebp
  802cd1:	57                   	push   %edi
  802cd2:	56                   	push   %esi
  802cd3:	83 ec 0c             	sub    $0xc,%esp
  802cd6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802cda:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802cde:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802ce2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802cec:	89 ea                	mov    %ebp,%edx
  802cee:	89 0c 24             	mov    %ecx,(%esp)
  802cf1:	75 2d                	jne    802d20 <__udivdi3+0x50>
  802cf3:	39 e9                	cmp    %ebp,%ecx
  802cf5:	77 61                	ja     802d58 <__udivdi3+0x88>
  802cf7:	85 c9                	test   %ecx,%ecx
  802cf9:	89 ce                	mov    %ecx,%esi
  802cfb:	75 0b                	jne    802d08 <__udivdi3+0x38>
  802cfd:	b8 01 00 00 00       	mov    $0x1,%eax
  802d02:	31 d2                	xor    %edx,%edx
  802d04:	f7 f1                	div    %ecx
  802d06:	89 c6                	mov    %eax,%esi
  802d08:	31 d2                	xor    %edx,%edx
  802d0a:	89 e8                	mov    %ebp,%eax
  802d0c:	f7 f6                	div    %esi
  802d0e:	89 c5                	mov    %eax,%ebp
  802d10:	89 f8                	mov    %edi,%eax
  802d12:	f7 f6                	div    %esi
  802d14:	89 ea                	mov    %ebp,%edx
  802d16:	83 c4 0c             	add    $0xc,%esp
  802d19:	5e                   	pop    %esi
  802d1a:	5f                   	pop    %edi
  802d1b:	5d                   	pop    %ebp
  802d1c:	c3                   	ret    
  802d1d:	8d 76 00             	lea    0x0(%esi),%esi
  802d20:	39 e8                	cmp    %ebp,%eax
  802d22:	77 24                	ja     802d48 <__udivdi3+0x78>
  802d24:	0f bd e8             	bsr    %eax,%ebp
  802d27:	83 f5 1f             	xor    $0x1f,%ebp
  802d2a:	75 3c                	jne    802d68 <__udivdi3+0x98>
  802d2c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802d30:	39 34 24             	cmp    %esi,(%esp)
  802d33:	0f 86 9f 00 00 00    	jbe    802dd8 <__udivdi3+0x108>
  802d39:	39 d0                	cmp    %edx,%eax
  802d3b:	0f 82 97 00 00 00    	jb     802dd8 <__udivdi3+0x108>
  802d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d48:	31 d2                	xor    %edx,%edx
  802d4a:	31 c0                	xor    %eax,%eax
  802d4c:	83 c4 0c             	add    $0xc,%esp
  802d4f:	5e                   	pop    %esi
  802d50:	5f                   	pop    %edi
  802d51:	5d                   	pop    %ebp
  802d52:	c3                   	ret    
  802d53:	90                   	nop
  802d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d58:	89 f8                	mov    %edi,%eax
  802d5a:	f7 f1                	div    %ecx
  802d5c:	31 d2                	xor    %edx,%edx
  802d5e:	83 c4 0c             	add    $0xc,%esp
  802d61:	5e                   	pop    %esi
  802d62:	5f                   	pop    %edi
  802d63:	5d                   	pop    %ebp
  802d64:	c3                   	ret    
  802d65:	8d 76 00             	lea    0x0(%esi),%esi
  802d68:	89 e9                	mov    %ebp,%ecx
  802d6a:	8b 3c 24             	mov    (%esp),%edi
  802d6d:	d3 e0                	shl    %cl,%eax
  802d6f:	89 c6                	mov    %eax,%esi
  802d71:	b8 20 00 00 00       	mov    $0x20,%eax
  802d76:	29 e8                	sub    %ebp,%eax
  802d78:	89 c1                	mov    %eax,%ecx
  802d7a:	d3 ef                	shr    %cl,%edi
  802d7c:	89 e9                	mov    %ebp,%ecx
  802d7e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802d82:	8b 3c 24             	mov    (%esp),%edi
  802d85:	09 74 24 08          	or     %esi,0x8(%esp)
  802d89:	89 d6                	mov    %edx,%esi
  802d8b:	d3 e7                	shl    %cl,%edi
  802d8d:	89 c1                	mov    %eax,%ecx
  802d8f:	89 3c 24             	mov    %edi,(%esp)
  802d92:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d96:	d3 ee                	shr    %cl,%esi
  802d98:	89 e9                	mov    %ebp,%ecx
  802d9a:	d3 e2                	shl    %cl,%edx
  802d9c:	89 c1                	mov    %eax,%ecx
  802d9e:	d3 ef                	shr    %cl,%edi
  802da0:	09 d7                	or     %edx,%edi
  802da2:	89 f2                	mov    %esi,%edx
  802da4:	89 f8                	mov    %edi,%eax
  802da6:	f7 74 24 08          	divl   0x8(%esp)
  802daa:	89 d6                	mov    %edx,%esi
  802dac:	89 c7                	mov    %eax,%edi
  802dae:	f7 24 24             	mull   (%esp)
  802db1:	39 d6                	cmp    %edx,%esi
  802db3:	89 14 24             	mov    %edx,(%esp)
  802db6:	72 30                	jb     802de8 <__udivdi3+0x118>
  802db8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802dbc:	89 e9                	mov    %ebp,%ecx
  802dbe:	d3 e2                	shl    %cl,%edx
  802dc0:	39 c2                	cmp    %eax,%edx
  802dc2:	73 05                	jae    802dc9 <__udivdi3+0xf9>
  802dc4:	3b 34 24             	cmp    (%esp),%esi
  802dc7:	74 1f                	je     802de8 <__udivdi3+0x118>
  802dc9:	89 f8                	mov    %edi,%eax
  802dcb:	31 d2                	xor    %edx,%edx
  802dcd:	e9 7a ff ff ff       	jmp    802d4c <__udivdi3+0x7c>
  802dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802dd8:	31 d2                	xor    %edx,%edx
  802dda:	b8 01 00 00 00       	mov    $0x1,%eax
  802ddf:	e9 68 ff ff ff       	jmp    802d4c <__udivdi3+0x7c>
  802de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802de8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802deb:	31 d2                	xor    %edx,%edx
  802ded:	83 c4 0c             	add    $0xc,%esp
  802df0:	5e                   	pop    %esi
  802df1:	5f                   	pop    %edi
  802df2:	5d                   	pop    %ebp
  802df3:	c3                   	ret    
  802df4:	66 90                	xchg   %ax,%ax
  802df6:	66 90                	xchg   %ax,%ax
  802df8:	66 90                	xchg   %ax,%ax
  802dfa:	66 90                	xchg   %ax,%ax
  802dfc:	66 90                	xchg   %ax,%ax
  802dfe:	66 90                	xchg   %ax,%ax

00802e00 <__umoddi3>:
  802e00:	55                   	push   %ebp
  802e01:	57                   	push   %edi
  802e02:	56                   	push   %esi
  802e03:	83 ec 14             	sub    $0x14,%esp
  802e06:	8b 44 24 28          	mov    0x28(%esp),%eax
  802e0a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802e0e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802e12:	89 c7                	mov    %eax,%edi
  802e14:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e18:	8b 44 24 30          	mov    0x30(%esp),%eax
  802e1c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802e20:	89 34 24             	mov    %esi,(%esp)
  802e23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e27:	85 c0                	test   %eax,%eax
  802e29:	89 c2                	mov    %eax,%edx
  802e2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e2f:	75 17                	jne    802e48 <__umoddi3+0x48>
  802e31:	39 fe                	cmp    %edi,%esi
  802e33:	76 4b                	jbe    802e80 <__umoddi3+0x80>
  802e35:	89 c8                	mov    %ecx,%eax
  802e37:	89 fa                	mov    %edi,%edx
  802e39:	f7 f6                	div    %esi
  802e3b:	89 d0                	mov    %edx,%eax
  802e3d:	31 d2                	xor    %edx,%edx
  802e3f:	83 c4 14             	add    $0x14,%esp
  802e42:	5e                   	pop    %esi
  802e43:	5f                   	pop    %edi
  802e44:	5d                   	pop    %ebp
  802e45:	c3                   	ret    
  802e46:	66 90                	xchg   %ax,%ax
  802e48:	39 f8                	cmp    %edi,%eax
  802e4a:	77 54                	ja     802ea0 <__umoddi3+0xa0>
  802e4c:	0f bd e8             	bsr    %eax,%ebp
  802e4f:	83 f5 1f             	xor    $0x1f,%ebp
  802e52:	75 5c                	jne    802eb0 <__umoddi3+0xb0>
  802e54:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802e58:	39 3c 24             	cmp    %edi,(%esp)
  802e5b:	0f 87 e7 00 00 00    	ja     802f48 <__umoddi3+0x148>
  802e61:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802e65:	29 f1                	sub    %esi,%ecx
  802e67:	19 c7                	sbb    %eax,%edi
  802e69:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e71:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e75:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802e79:	83 c4 14             	add    $0x14,%esp
  802e7c:	5e                   	pop    %esi
  802e7d:	5f                   	pop    %edi
  802e7e:	5d                   	pop    %ebp
  802e7f:	c3                   	ret    
  802e80:	85 f6                	test   %esi,%esi
  802e82:	89 f5                	mov    %esi,%ebp
  802e84:	75 0b                	jne    802e91 <__umoddi3+0x91>
  802e86:	b8 01 00 00 00       	mov    $0x1,%eax
  802e8b:	31 d2                	xor    %edx,%edx
  802e8d:	f7 f6                	div    %esi
  802e8f:	89 c5                	mov    %eax,%ebp
  802e91:	8b 44 24 04          	mov    0x4(%esp),%eax
  802e95:	31 d2                	xor    %edx,%edx
  802e97:	f7 f5                	div    %ebp
  802e99:	89 c8                	mov    %ecx,%eax
  802e9b:	f7 f5                	div    %ebp
  802e9d:	eb 9c                	jmp    802e3b <__umoddi3+0x3b>
  802e9f:	90                   	nop
  802ea0:	89 c8                	mov    %ecx,%eax
  802ea2:	89 fa                	mov    %edi,%edx
  802ea4:	83 c4 14             	add    $0x14,%esp
  802ea7:	5e                   	pop    %esi
  802ea8:	5f                   	pop    %edi
  802ea9:	5d                   	pop    %ebp
  802eaa:	c3                   	ret    
  802eab:	90                   	nop
  802eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802eb0:	8b 04 24             	mov    (%esp),%eax
  802eb3:	be 20 00 00 00       	mov    $0x20,%esi
  802eb8:	89 e9                	mov    %ebp,%ecx
  802eba:	29 ee                	sub    %ebp,%esi
  802ebc:	d3 e2                	shl    %cl,%edx
  802ebe:	89 f1                	mov    %esi,%ecx
  802ec0:	d3 e8                	shr    %cl,%eax
  802ec2:	89 e9                	mov    %ebp,%ecx
  802ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ec8:	8b 04 24             	mov    (%esp),%eax
  802ecb:	09 54 24 04          	or     %edx,0x4(%esp)
  802ecf:	89 fa                	mov    %edi,%edx
  802ed1:	d3 e0                	shl    %cl,%eax
  802ed3:	89 f1                	mov    %esi,%ecx
  802ed5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ed9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802edd:	d3 ea                	shr    %cl,%edx
  802edf:	89 e9                	mov    %ebp,%ecx
  802ee1:	d3 e7                	shl    %cl,%edi
  802ee3:	89 f1                	mov    %esi,%ecx
  802ee5:	d3 e8                	shr    %cl,%eax
  802ee7:	89 e9                	mov    %ebp,%ecx
  802ee9:	09 f8                	or     %edi,%eax
  802eeb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802eef:	f7 74 24 04          	divl   0x4(%esp)
  802ef3:	d3 e7                	shl    %cl,%edi
  802ef5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ef9:	89 d7                	mov    %edx,%edi
  802efb:	f7 64 24 08          	mull   0x8(%esp)
  802eff:	39 d7                	cmp    %edx,%edi
  802f01:	89 c1                	mov    %eax,%ecx
  802f03:	89 14 24             	mov    %edx,(%esp)
  802f06:	72 2c                	jb     802f34 <__umoddi3+0x134>
  802f08:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802f0c:	72 22                	jb     802f30 <__umoddi3+0x130>
  802f0e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802f12:	29 c8                	sub    %ecx,%eax
  802f14:	19 d7                	sbb    %edx,%edi
  802f16:	89 e9                	mov    %ebp,%ecx
  802f18:	89 fa                	mov    %edi,%edx
  802f1a:	d3 e8                	shr    %cl,%eax
  802f1c:	89 f1                	mov    %esi,%ecx
  802f1e:	d3 e2                	shl    %cl,%edx
  802f20:	89 e9                	mov    %ebp,%ecx
  802f22:	d3 ef                	shr    %cl,%edi
  802f24:	09 d0                	or     %edx,%eax
  802f26:	89 fa                	mov    %edi,%edx
  802f28:	83 c4 14             	add    $0x14,%esp
  802f2b:	5e                   	pop    %esi
  802f2c:	5f                   	pop    %edi
  802f2d:	5d                   	pop    %ebp
  802f2e:	c3                   	ret    
  802f2f:	90                   	nop
  802f30:	39 d7                	cmp    %edx,%edi
  802f32:	75 da                	jne    802f0e <__umoddi3+0x10e>
  802f34:	8b 14 24             	mov    (%esp),%edx
  802f37:	89 c1                	mov    %eax,%ecx
  802f39:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802f3d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802f41:	eb cb                	jmp    802f0e <__umoddi3+0x10e>
  802f43:	90                   	nop
  802f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f48:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802f4c:	0f 82 0f ff ff ff    	jb     802e61 <__umoddi3+0x61>
  802f52:	e9 1a ff ff ff       	jmp    802e71 <__umoddi3+0x71>
