
obj/user/testtime.debug:     file format elf32-i386


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
  80002c:	e8 e5 00 00 00       	call   800116 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	unsigned now = sys_time_msec();
  800047:	e8 91 0f 00 00       	call   800fdd <sys_time_msec>
	unsigned end = now + sec * 1000;
  80004c:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  800053:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  800055:	83 f8 eb             	cmp    $0xffffffeb,%eax
  800058:	7c 29                	jl     800083 <sleep+0x43>
  80005a:	89 c2                	mov    %eax,%edx
  80005c:	c1 ea 1f             	shr    $0x1f,%edx
  80005f:	84 d2                	test   %dl,%dl
  800061:	74 20                	je     800083 <sleep+0x43>
		panic("sys_time_msec: %e", (int)now);
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 a0 27 80 	movl   $0x8027a0,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 b2 27 80 00 	movl   $0x8027b2,(%esp)
  80007e:	e8 f4 00 00 00       	call   800177 <_panic>
	if (end < now)
  800083:	39 d8                	cmp    %ebx,%eax
  800085:	76 21                	jbe    8000a8 <sleep+0x68>
		panic("sleep: wrap");
  800087:	c7 44 24 08 c2 27 80 	movl   $0x8027c2,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800096:	00 
  800097:	c7 04 24 b2 27 80 00 	movl   $0x8027b2,(%esp)
  80009e:	e8 d4 00 00 00       	call   800177 <_panic>

	while (sys_time_msec() < end)
		sys_yield();
  8000a3:	e8 8e 0c 00 00       	call   800d36 <sys_yield>
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000a8:	e8 30 0f 00 00       	call   800fdd <sys_time_msec>
  8000ad:	39 c3                	cmp    %eax,%ebx
  8000af:	90                   	nop
  8000b0:	77 f1                	ja     8000a3 <sleep+0x63>
		sys_yield();
}
  8000b2:	83 c4 14             	add    $0x14,%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <umain>:

void
umain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	53                   	push   %ebx
  8000bc:	83 ec 14             	sub    $0x14,%esp
  8000bf:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  8000c4:	e8 6d 0c 00 00       	call   800d36 <sys_yield>
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  8000c9:	83 eb 01             	sub    $0x1,%ebx
  8000cc:	75 f6                	jne    8000c4 <umain+0xc>
		sys_yield();

	cprintf("starting count down: ");
  8000ce:	c7 04 24 ce 27 80 00 	movl   $0x8027ce,(%esp)
  8000d5:	e8 96 01 00 00       	call   800270 <cprintf>
	for (i = 5; i >= 0; i--) {
  8000da:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e3:	c7 04 24 e4 27 80 00 	movl   $0x8027e4,(%esp)
  8000ea:	e8 81 01 00 00       	call   800270 <cprintf>
		sleep(1);
  8000ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000f6:	e8 45 ff ff ff       	call   800040 <sleep>
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  8000fb:	83 eb 01             	sub    $0x1,%ebx
  8000fe:	83 fb ff             	cmp    $0xffffffff,%ebx
  800101:	75 dc                	jne    8000df <umain+0x27>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  800103:	c7 04 24 43 2c 80 00 	movl   $0x802c43,(%esp)
  80010a:	e8 61 01 00 00       	call   800270 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  80010f:	cc                   	int3   
	breakpoint();
}
  800110:	83 c4 14             	add    $0x14,%esp
  800113:	5b                   	pop    %ebx
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    

00800116 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	56                   	push   %esi
  80011a:	53                   	push   %ebx
  80011b:	83 ec 10             	sub    $0x10,%esp
  80011e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800121:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800124:	e8 ee 0b 00 00       	call   800d17 <sys_getenvid>
  800129:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800131:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800136:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013b:	85 db                	test   %ebx,%ebx
  80013d:	7e 07                	jle    800146 <libmain+0x30>
		binaryname = argv[0];
  80013f:	8b 06                	mov    (%esi),%eax
  800141:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800146:	89 74 24 04          	mov    %esi,0x4(%esp)
  80014a:	89 1c 24             	mov    %ebx,(%esp)
  80014d:	e8 66 ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  800152:	e8 07 00 00 00       	call   80015e <exit>
}
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	5b                   	pop    %ebx
  80015b:	5e                   	pop    %esi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800164:	e8 d1 10 00 00       	call   80123a <close_all>
	sys_env_destroy(0);
  800169:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800170:	e8 fe 0a 00 00       	call   800c73 <sys_env_destroy>
}
  800175:	c9                   	leave  
  800176:	c3                   	ret    

00800177 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	56                   	push   %esi
  80017b:	53                   	push   %ebx
  80017c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80017f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800182:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800188:	e8 8a 0b 00 00       	call   800d17 <sys_getenvid>
  80018d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800190:	89 54 24 10          	mov    %edx,0x10(%esp)
  800194:	8b 55 08             	mov    0x8(%ebp),%edx
  800197:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80019b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80019f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a3:	c7 04 24 f4 27 80 00 	movl   $0x8027f4,(%esp)
  8001aa:	e8 c1 00 00 00       	call   800270 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b6:	89 04 24             	mov    %eax,(%esp)
  8001b9:	e8 51 00 00 00       	call   80020f <vcprintf>
	cprintf("\n");
  8001be:	c7 04 24 43 2c 80 00 	movl   $0x802c43,(%esp)
  8001c5:	e8 a6 00 00 00       	call   800270 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ca:	cc                   	int3   
  8001cb:	eb fd                	jmp    8001ca <_panic+0x53>

008001cd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	53                   	push   %ebx
  8001d1:	83 ec 14             	sub    $0x14,%esp
  8001d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d7:	8b 13                	mov    (%ebx),%edx
  8001d9:	8d 42 01             	lea    0x1(%edx),%eax
  8001dc:	89 03                	mov    %eax,(%ebx)
  8001de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ea:	75 19                	jne    800205 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001ec:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001f3:	00 
  8001f4:	8d 43 08             	lea    0x8(%ebx),%eax
  8001f7:	89 04 24             	mov    %eax,(%esp)
  8001fa:	e8 37 0a 00 00       	call   800c36 <sys_cputs>
		b->idx = 0;
  8001ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800205:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800209:	83 c4 14             	add    $0x14,%esp
  80020c:	5b                   	pop    %ebx
  80020d:	5d                   	pop    %ebp
  80020e:	c3                   	ret    

0080020f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800218:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021f:	00 00 00 
	b.cnt = 0;
  800222:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800229:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800233:	8b 45 08             	mov    0x8(%ebp),%eax
  800236:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800240:	89 44 24 04          	mov    %eax,0x4(%esp)
  800244:	c7 04 24 cd 01 80 00 	movl   $0x8001cd,(%esp)
  80024b:	e8 74 01 00 00       	call   8003c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800250:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800256:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800260:	89 04 24             	mov    %eax,(%esp)
  800263:	e8 ce 09 00 00       	call   800c36 <sys_cputs>

	return b.cnt;
}
  800268:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800276:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800279:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027d:	8b 45 08             	mov    0x8(%ebp),%eax
  800280:	89 04 24             	mov    %eax,(%esp)
  800283:	e8 87 ff ff ff       	call   80020f <vcprintf>
	va_end(ap);

	return cnt;
}
  800288:	c9                   	leave  
  800289:	c3                   	ret    
  80028a:	66 90                	xchg   %ax,%ax
  80028c:	66 90                	xchg   %ax,%ax
  80028e:	66 90                	xchg   %ax,%ax

00800290 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 3c             	sub    $0x3c,%esp
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	89 d7                	mov    %edx,%edi
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a7:	89 c3                	mov    %eax,%ebx
  8002a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8002af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002bd:	39 d9                	cmp    %ebx,%ecx
  8002bf:	72 05                	jb     8002c6 <printnum+0x36>
  8002c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c4:	77 69                	ja     80032f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002cd:	83 ee 01             	sub    $0x1,%esi
  8002d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002e0:	89 c3                	mov    %eax,%ebx
  8002e2:	89 d6                	mov    %edx,%esi
  8002e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ff:	e8 0c 22 00 00       	call   802510 <__udivdi3>
  800304:	89 d9                	mov    %ebx,%ecx
  800306:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80030a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80030e:	89 04 24             	mov    %eax,(%esp)
  800311:	89 54 24 04          	mov    %edx,0x4(%esp)
  800315:	89 fa                	mov    %edi,%edx
  800317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031a:	e8 71 ff ff ff       	call   800290 <printnum>
  80031f:	eb 1b                	jmp    80033c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800321:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800325:	8b 45 18             	mov    0x18(%ebp),%eax
  800328:	89 04 24             	mov    %eax,(%esp)
  80032b:	ff d3                	call   *%ebx
  80032d:	eb 03                	jmp    800332 <printnum+0xa2>
  80032f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800332:	83 ee 01             	sub    $0x1,%esi
  800335:	85 f6                	test   %esi,%esi
  800337:	7f e8                	jg     800321 <printnum+0x91>
  800339:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800340:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800344:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800347:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80034a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80034e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800355:	89 04 24             	mov    %eax,(%esp)
  800358:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035f:	e8 dc 22 00 00       	call   802640 <__umoddi3>
  800364:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800368:	0f be 80 17 28 80 00 	movsbl 0x802817(%eax),%eax
  80036f:	89 04 24             	mov    %eax,(%esp)
  800372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800375:	ff d0                	call   *%eax
}
  800377:	83 c4 3c             	add    $0x3c,%esp
  80037a:	5b                   	pop    %ebx
  80037b:	5e                   	pop    %esi
  80037c:	5f                   	pop    %edi
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800385:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800389:	8b 10                	mov    (%eax),%edx
  80038b:	3b 50 04             	cmp    0x4(%eax),%edx
  80038e:	73 0a                	jae    80039a <sprintputch+0x1b>
		*b->buf++ = ch;
  800390:	8d 4a 01             	lea    0x1(%edx),%ecx
  800393:	89 08                	mov    %ecx,(%eax)
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	88 02                	mov    %al,(%edx)
}
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003a2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ba:	89 04 24             	mov    %eax,(%esp)
  8003bd:	e8 02 00 00 00       	call   8003c4 <vprintfmt>
	va_end(ap);
}
  8003c2:	c9                   	leave  
  8003c3:	c3                   	ret    

008003c4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	57                   	push   %edi
  8003c8:	56                   	push   %esi
  8003c9:	53                   	push   %ebx
  8003ca:	83 ec 3c             	sub    $0x3c,%esp
  8003cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003d0:	eb 17                	jmp    8003e9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8003d2:	85 c0                	test   %eax,%eax
  8003d4:	0f 84 4b 04 00 00    	je     800825 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003e1:	89 04 24             	mov    %eax,(%esp)
  8003e4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8003e7:	89 fb                	mov    %edi,%ebx
  8003e9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8003ec:	0f b6 03             	movzbl (%ebx),%eax
  8003ef:	83 f8 25             	cmp    $0x25,%eax
  8003f2:	75 de                	jne    8003d2 <vprintfmt+0xe>
  8003f4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8003f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003ff:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800404:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80040b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800410:	eb 18                	jmp    80042a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800412:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800414:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800418:	eb 10                	jmp    80042a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80041c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800420:	eb 08                	jmp    80042a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800422:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800425:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80042d:	0f b6 17             	movzbl (%edi),%edx
  800430:	0f b6 c2             	movzbl %dl,%eax
  800433:	83 ea 23             	sub    $0x23,%edx
  800436:	80 fa 55             	cmp    $0x55,%dl
  800439:	0f 87 c2 03 00 00    	ja     800801 <vprintfmt+0x43d>
  80043f:	0f b6 d2             	movzbl %dl,%edx
  800442:	ff 24 95 60 29 80 00 	jmp    *0x802960(,%edx,4)
  800449:	89 df                	mov    %ebx,%edi
  80044b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800450:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800453:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800457:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80045a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80045d:	83 fa 09             	cmp    $0x9,%edx
  800460:	77 33                	ja     800495 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800462:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800465:	eb e9                	jmp    800450 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	8b 30                	mov    (%eax),%esi
  80046c:	8d 40 04             	lea    0x4(%eax),%eax
  80046f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800472:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800474:	eb 1f                	jmp    800495 <vprintfmt+0xd1>
  800476:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800479:	85 ff                	test   %edi,%edi
  80047b:	b8 00 00 00 00       	mov    $0x0,%eax
  800480:	0f 49 c7             	cmovns %edi,%eax
  800483:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800486:	89 df                	mov    %ebx,%edi
  800488:	eb a0                	jmp    80042a <vprintfmt+0x66>
  80048a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80048c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800493:	eb 95                	jmp    80042a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800495:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800499:	79 8f                	jns    80042a <vprintfmt+0x66>
  80049b:	eb 85                	jmp    800422 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80049d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004a2:	eb 86                	jmp    80042a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 70 04             	lea    0x4(%eax),%esi
  8004aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	89 04 24             	mov    %eax,(%esp)
  8004b9:	ff 55 08             	call   *0x8(%ebp)
  8004bc:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8004bf:	e9 25 ff ff ff       	jmp    8003e9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 70 04             	lea    0x4(%eax),%esi
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	99                   	cltd   
  8004cd:	31 d0                	xor    %edx,%eax
  8004cf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004d1:	83 f8 15             	cmp    $0x15,%eax
  8004d4:	7f 0b                	jg     8004e1 <vprintfmt+0x11d>
  8004d6:	8b 14 85 c0 2a 80 00 	mov    0x802ac0(,%eax,4),%edx
  8004dd:	85 d2                	test   %edx,%edx
  8004df:	75 26                	jne    800507 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8004e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004e5:	c7 44 24 08 2f 28 80 	movl   $0x80282f,0x8(%esp)
  8004ec:	00 
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f7:	89 04 24             	mov    %eax,(%esp)
  8004fa:	e8 9d fe ff ff       	call   80039c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004ff:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800502:	e9 e2 fe ff ff       	jmp    8003e9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800507:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80050b:	c7 44 24 08 12 2c 80 	movl   $0x802c12,0x8(%esp)
  800512:	00 
  800513:	8b 45 0c             	mov    0xc(%ebp),%eax
  800516:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	e8 77 fe ff ff       	call   80039c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800525:	89 75 14             	mov    %esi,0x14(%ebp)
  800528:	e9 bc fe ff ff       	jmp    8003e9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800533:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800536:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80053a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80053c:	85 ff                	test   %edi,%edi
  80053e:	b8 28 28 80 00       	mov    $0x802828,%eax
  800543:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800546:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80054a:	0f 84 94 00 00 00    	je     8005e4 <vprintfmt+0x220>
  800550:	85 c9                	test   %ecx,%ecx
  800552:	0f 8e 94 00 00 00    	jle    8005ec <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800558:	89 74 24 04          	mov    %esi,0x4(%esp)
  80055c:	89 3c 24             	mov    %edi,(%esp)
  80055f:	e8 64 03 00 00       	call   8008c8 <strnlen>
  800564:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800567:	29 c1                	sub    %eax,%ecx
  800569:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80056c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800570:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800573:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800576:	8b 75 08             	mov    0x8(%ebp),%esi
  800579:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80057c:	89 cb                	mov    %ecx,%ebx
  80057e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800580:	eb 0f                	jmp    800591 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800582:	8b 45 0c             	mov    0xc(%ebp),%eax
  800585:	89 44 24 04          	mov    %eax,0x4(%esp)
  800589:	89 3c 24             	mov    %edi,(%esp)
  80058c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80058e:	83 eb 01             	sub    $0x1,%ebx
  800591:	85 db                	test   %ebx,%ebx
  800593:	7f ed                	jg     800582 <vprintfmt+0x1be>
  800595:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800598:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80059b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059e:	85 c9                	test   %ecx,%ecx
  8005a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a5:	0f 49 c1             	cmovns %ecx,%eax
  8005a8:	29 c1                	sub    %eax,%ecx
  8005aa:	89 cb                	mov    %ecx,%ebx
  8005ac:	eb 44                	jmp    8005f2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b2:	74 1e                	je     8005d2 <vprintfmt+0x20e>
  8005b4:	0f be d2             	movsbl %dl,%edx
  8005b7:	83 ea 20             	sub    $0x20,%edx
  8005ba:	83 fa 5e             	cmp    $0x5e,%edx
  8005bd:	76 13                	jbe    8005d2 <vprintfmt+0x20e>
					putch('?', putdat);
  8005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005cd:	ff 55 08             	call   *0x8(%ebp)
  8005d0:	eb 0d                	jmp    8005df <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8005d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005d9:	89 04 24             	mov    %eax,(%esp)
  8005dc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005df:	83 eb 01             	sub    $0x1,%ebx
  8005e2:	eb 0e                	jmp    8005f2 <vprintfmt+0x22e>
  8005e4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005e7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005ea:	eb 06                	jmp    8005f2 <vprintfmt+0x22e>
  8005ec:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005ef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005f2:	83 c7 01             	add    $0x1,%edi
  8005f5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005f9:	0f be c2             	movsbl %dl,%eax
  8005fc:	85 c0                	test   %eax,%eax
  8005fe:	74 27                	je     800627 <vprintfmt+0x263>
  800600:	85 f6                	test   %esi,%esi
  800602:	78 aa                	js     8005ae <vprintfmt+0x1ea>
  800604:	83 ee 01             	sub    $0x1,%esi
  800607:	79 a5                	jns    8005ae <vprintfmt+0x1ea>
  800609:	89 d8                	mov    %ebx,%eax
  80060b:	8b 75 08             	mov    0x8(%ebp),%esi
  80060e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800611:	89 c3                	mov    %eax,%ebx
  800613:	eb 18                	jmp    80062d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800615:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800619:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800620:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800622:	83 eb 01             	sub    $0x1,%ebx
  800625:	eb 06                	jmp    80062d <vprintfmt+0x269>
  800627:	8b 75 08             	mov    0x8(%ebp),%esi
  80062a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80062d:	85 db                	test   %ebx,%ebx
  80062f:	7f e4                	jg     800615 <vprintfmt+0x251>
  800631:	89 75 08             	mov    %esi,0x8(%ebp)
  800634:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800637:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80063a:	e9 aa fd ff ff       	jmp    8003e9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80063f:	83 f9 01             	cmp    $0x1,%ecx
  800642:	7e 10                	jle    800654 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 30                	mov    (%eax),%esi
  800649:	8b 78 04             	mov    0x4(%eax),%edi
  80064c:	8d 40 08             	lea    0x8(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
  800652:	eb 26                	jmp    80067a <vprintfmt+0x2b6>
	else if (lflag)
  800654:	85 c9                	test   %ecx,%ecx
  800656:	74 12                	je     80066a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 30                	mov    (%eax),%esi
  80065d:	89 f7                	mov    %esi,%edi
  80065f:	c1 ff 1f             	sar    $0x1f,%edi
  800662:	8d 40 04             	lea    0x4(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
  800668:	eb 10                	jmp    80067a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 30                	mov    (%eax),%esi
  80066f:	89 f7                	mov    %esi,%edi
  800671:	c1 ff 1f             	sar    $0x1f,%edi
  800674:	8d 40 04             	lea    0x4(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80067a:	89 f0                	mov    %esi,%eax
  80067c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80067e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800683:	85 ff                	test   %edi,%edi
  800685:	0f 89 3a 01 00 00    	jns    8007c5 <vprintfmt+0x401>
				putch('-', putdat);
  80068b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800692:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800699:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80069c:	89 f0                	mov    %esi,%eax
  80069e:	89 fa                	mov    %edi,%edx
  8006a0:	f7 d8                	neg    %eax
  8006a2:	83 d2 00             	adc    $0x0,%edx
  8006a5:	f7 da                	neg    %edx
			}
			base = 10;
  8006a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006ac:	e9 14 01 00 00       	jmp    8007c5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006b1:	83 f9 01             	cmp    $0x1,%ecx
  8006b4:	7e 13                	jle    8006c9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8b 50 04             	mov    0x4(%eax),%edx
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	8b 75 14             	mov    0x14(%ebp),%esi
  8006c1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006c4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006c7:	eb 2c                	jmp    8006f5 <vprintfmt+0x331>
	else if (lflag)
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	74 15                	je     8006e2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d7:	8b 75 14             	mov    0x14(%ebp),%esi
  8006da:	8d 76 04             	lea    0x4(%esi),%esi
  8006dd:	89 75 14             	mov    %esi,0x14(%ebp)
  8006e0:	eb 13                	jmp    8006f5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ec:	8b 75 14             	mov    0x14(%ebp),%esi
  8006ef:	8d 76 04             	lea    0x4(%esi),%esi
  8006f2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8006f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006fa:	e9 c6 00 00 00       	jmp    8007c5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006ff:	83 f9 01             	cmp    $0x1,%ecx
  800702:	7e 13                	jle    800717 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8b 50 04             	mov    0x4(%eax),%edx
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	8b 75 14             	mov    0x14(%ebp),%esi
  80070f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800712:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800715:	eb 24                	jmp    80073b <vprintfmt+0x377>
	else if (lflag)
  800717:	85 c9                	test   %ecx,%ecx
  800719:	74 11                	je     80072c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	99                   	cltd   
  800721:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800724:	8d 71 04             	lea    0x4(%ecx),%esi
  800727:	89 75 14             	mov    %esi,0x14(%ebp)
  80072a:	eb 0f                	jmp    80073b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	99                   	cltd   
  800732:	8b 75 14             	mov    0x14(%ebp),%esi
  800735:	8d 76 04             	lea    0x4(%esi),%esi
  800738:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80073b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800740:	e9 80 00 00 00       	jmp    8007c5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800745:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800756:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800760:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800767:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80076a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80076e:	8b 06                	mov    (%esi),%eax
  800770:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800775:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80077a:	eb 49                	jmp    8007c5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80077c:	83 f9 01             	cmp    $0x1,%ecx
  80077f:	7e 13                	jle    800794 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 50 04             	mov    0x4(%eax),%edx
  800787:	8b 00                	mov    (%eax),%eax
  800789:	8b 75 14             	mov    0x14(%ebp),%esi
  80078c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80078f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800792:	eb 2c                	jmp    8007c0 <vprintfmt+0x3fc>
	else if (lflag)
  800794:	85 c9                	test   %ecx,%ecx
  800796:	74 15                	je     8007ad <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007a5:	8d 71 04             	lea    0x4(%ecx),%esi
  8007a8:	89 75 14             	mov    %esi,0x14(%ebp)
  8007ab:	eb 13                	jmp    8007c0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b7:	8b 75 14             	mov    0x14(%ebp),%esi
  8007ba:	8d 76 04             	lea    0x4(%esi),%esi
  8007bd:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8007c0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007c5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8007c9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007cd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8007d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007d4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007d8:	89 04 24             	mov    %eax,(%esp)
  8007db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	e8 a6 fa ff ff       	call   800290 <printnum>
			break;
  8007ea:	e9 fa fb ff ff       	jmp    8003e9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007f6:	89 04 24             	mov    %eax,(%esp)
  8007f9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007fc:	e9 e8 fb ff ff       	jmp    8003e9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800801:	8b 45 0c             	mov    0xc(%ebp),%eax
  800804:	89 44 24 04          	mov    %eax,0x4(%esp)
  800808:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80080f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800812:	89 fb                	mov    %edi,%ebx
  800814:	eb 03                	jmp    800819 <vprintfmt+0x455>
  800816:	83 eb 01             	sub    $0x1,%ebx
  800819:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80081d:	75 f7                	jne    800816 <vprintfmt+0x452>
  80081f:	90                   	nop
  800820:	e9 c4 fb ff ff       	jmp    8003e9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800825:	83 c4 3c             	add    $0x3c,%esp
  800828:	5b                   	pop    %ebx
  800829:	5e                   	pop    %esi
  80082a:	5f                   	pop    %edi
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	83 ec 28             	sub    $0x28,%esp
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800839:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80083c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800840:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800843:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80084a:	85 c0                	test   %eax,%eax
  80084c:	74 30                	je     80087e <vsnprintf+0x51>
  80084e:	85 d2                	test   %edx,%edx
  800850:	7e 2c                	jle    80087e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800859:	8b 45 10             	mov    0x10(%ebp),%eax
  80085c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800860:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800863:	89 44 24 04          	mov    %eax,0x4(%esp)
  800867:	c7 04 24 7f 03 80 00 	movl   $0x80037f,(%esp)
  80086e:	e8 51 fb ff ff       	call   8003c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800876:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087c:	eb 05                	jmp    800883 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80087e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80088b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80088e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800892:	8b 45 10             	mov    0x10(%ebp),%eax
  800895:	89 44 24 08          	mov    %eax,0x8(%esp)
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	89 04 24             	mov    %eax,(%esp)
  8008a6:	e8 82 ff ff ff       	call   80082d <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ab:	c9                   	leave  
  8008ac:	c3                   	ret    
  8008ad:	66 90                	xchg   %ax,%ax
  8008af:	90                   	nop

008008b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bb:	eb 03                	jmp    8008c0 <strlen+0x10>
		n++;
  8008bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c4:	75 f7                	jne    8008bd <strlen+0xd>
		n++;
	return n;
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	eb 03                	jmp    8008db <strnlen+0x13>
		n++;
  8008d8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008db:	39 d0                	cmp    %edx,%eax
  8008dd:	74 06                	je     8008e5 <strnlen+0x1d>
  8008df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e3:	75 f3                	jne    8008d8 <strnlen+0x10>
		n++;
	return n;
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	83 c2 01             	add    $0x1,%edx
  8008f6:	83 c1 01             	add    $0x1,%ecx
  8008f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800900:	84 db                	test   %bl,%bl
  800902:	75 ef                	jne    8008f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800904:	5b                   	pop    %ebx
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	53                   	push   %ebx
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800911:	89 1c 24             	mov    %ebx,(%esp)
  800914:	e8 97 ff ff ff       	call   8008b0 <strlen>
	strcpy(dst + len, src);
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800920:	01 d8                	add    %ebx,%eax
  800922:	89 04 24             	mov    %eax,(%esp)
  800925:	e8 bd ff ff ff       	call   8008e7 <strcpy>
	return dst;
}
  80092a:	89 d8                	mov    %ebx,%eax
  80092c:	83 c4 08             	add    $0x8,%esp
  80092f:	5b                   	pop    %ebx
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	56                   	push   %esi
  800936:	53                   	push   %ebx
  800937:	8b 75 08             	mov    0x8(%ebp),%esi
  80093a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093d:	89 f3                	mov    %esi,%ebx
  80093f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800942:	89 f2                	mov    %esi,%edx
  800944:	eb 0f                	jmp    800955 <strncpy+0x23>
		*dst++ = *src;
  800946:	83 c2 01             	add    $0x1,%edx
  800949:	0f b6 01             	movzbl (%ecx),%eax
  80094c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094f:	80 39 01             	cmpb   $0x1,(%ecx)
  800952:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800955:	39 da                	cmp    %ebx,%edx
  800957:	75 ed                	jne    800946 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800959:	89 f0                	mov    %esi,%eax
  80095b:	5b                   	pop    %ebx
  80095c:	5e                   	pop    %esi
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	56                   	push   %esi
  800963:	53                   	push   %ebx
  800964:	8b 75 08             	mov    0x8(%ebp),%esi
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80096d:	89 f0                	mov    %esi,%eax
  80096f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800973:	85 c9                	test   %ecx,%ecx
  800975:	75 0b                	jne    800982 <strlcpy+0x23>
  800977:	eb 1d                	jmp    800996 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800979:	83 c0 01             	add    $0x1,%eax
  80097c:	83 c2 01             	add    $0x1,%edx
  80097f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800982:	39 d8                	cmp    %ebx,%eax
  800984:	74 0b                	je     800991 <strlcpy+0x32>
  800986:	0f b6 0a             	movzbl (%edx),%ecx
  800989:	84 c9                	test   %cl,%cl
  80098b:	75 ec                	jne    800979 <strlcpy+0x1a>
  80098d:	89 c2                	mov    %eax,%edx
  80098f:	eb 02                	jmp    800993 <strlcpy+0x34>
  800991:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800993:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800996:	29 f0                	sub    %esi,%eax
}
  800998:	5b                   	pop    %ebx
  800999:	5e                   	pop    %esi
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a5:	eb 06                	jmp    8009ad <strcmp+0x11>
		p++, q++;
  8009a7:	83 c1 01             	add    $0x1,%ecx
  8009aa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009ad:	0f b6 01             	movzbl (%ecx),%eax
  8009b0:	84 c0                	test   %al,%al
  8009b2:	74 04                	je     8009b8 <strcmp+0x1c>
  8009b4:	3a 02                	cmp    (%edx),%al
  8009b6:	74 ef                	je     8009a7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b8:	0f b6 c0             	movzbl %al,%eax
  8009bb:	0f b6 12             	movzbl (%edx),%edx
  8009be:	29 d0                	sub    %edx,%eax
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	53                   	push   %ebx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cc:	89 c3                	mov    %eax,%ebx
  8009ce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d1:	eb 06                	jmp    8009d9 <strncmp+0x17>
		n--, p++, q++;
  8009d3:	83 c0 01             	add    $0x1,%eax
  8009d6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009d9:	39 d8                	cmp    %ebx,%eax
  8009db:	74 15                	je     8009f2 <strncmp+0x30>
  8009dd:	0f b6 08             	movzbl (%eax),%ecx
  8009e0:	84 c9                	test   %cl,%cl
  8009e2:	74 04                	je     8009e8 <strncmp+0x26>
  8009e4:	3a 0a                	cmp    (%edx),%cl
  8009e6:	74 eb                	je     8009d3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e8:	0f b6 00             	movzbl (%eax),%eax
  8009eb:	0f b6 12             	movzbl (%edx),%edx
  8009ee:	29 d0                	sub    %edx,%eax
  8009f0:	eb 05                	jmp    8009f7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a04:	eb 07                	jmp    800a0d <strchr+0x13>
		if (*s == c)
  800a06:	38 ca                	cmp    %cl,%dl
  800a08:	74 0f                	je     800a19 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a0a:	83 c0 01             	add    $0x1,%eax
  800a0d:	0f b6 10             	movzbl (%eax),%edx
  800a10:	84 d2                	test   %dl,%dl
  800a12:	75 f2                	jne    800a06 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a25:	eb 07                	jmp    800a2e <strfind+0x13>
		if (*s == c)
  800a27:	38 ca                	cmp    %cl,%dl
  800a29:	74 0a                	je     800a35 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	0f b6 10             	movzbl (%eax),%edx
  800a31:	84 d2                	test   %dl,%dl
  800a33:	75 f2                	jne    800a27 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	57                   	push   %edi
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a43:	85 c9                	test   %ecx,%ecx
  800a45:	74 36                	je     800a7d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a47:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4d:	75 28                	jne    800a77 <memset+0x40>
  800a4f:	f6 c1 03             	test   $0x3,%cl
  800a52:	75 23                	jne    800a77 <memset+0x40>
		c &= 0xFF;
  800a54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a58:	89 d3                	mov    %edx,%ebx
  800a5a:	c1 e3 08             	shl    $0x8,%ebx
  800a5d:	89 d6                	mov    %edx,%esi
  800a5f:	c1 e6 18             	shl    $0x18,%esi
  800a62:	89 d0                	mov    %edx,%eax
  800a64:	c1 e0 10             	shl    $0x10,%eax
  800a67:	09 f0                	or     %esi,%eax
  800a69:	09 c2                	or     %eax,%edx
  800a6b:	89 d0                	mov    %edx,%eax
  800a6d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a6f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a72:	fc                   	cld    
  800a73:	f3 ab                	rep stos %eax,%es:(%edi)
  800a75:	eb 06                	jmp    800a7d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	fc                   	cld    
  800a7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7d:	89 f8                	mov    %edi,%eax
  800a7f:	5b                   	pop    %ebx
  800a80:	5e                   	pop    %esi
  800a81:	5f                   	pop    %edi
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	57                   	push   %edi
  800a88:	56                   	push   %esi
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a92:	39 c6                	cmp    %eax,%esi
  800a94:	73 35                	jae    800acb <memmove+0x47>
  800a96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a99:	39 d0                	cmp    %edx,%eax
  800a9b:	73 2e                	jae    800acb <memmove+0x47>
		s += n;
		d += n;
  800a9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800aa0:	89 d6                	mov    %edx,%esi
  800aa2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aaa:	75 13                	jne    800abf <memmove+0x3b>
  800aac:	f6 c1 03             	test   $0x3,%cl
  800aaf:	75 0e                	jne    800abf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab1:	83 ef 04             	sub    $0x4,%edi
  800ab4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aba:	fd                   	std    
  800abb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abd:	eb 09                	jmp    800ac8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abf:	83 ef 01             	sub    $0x1,%edi
  800ac2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ac5:	fd                   	std    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac8:	fc                   	cld    
  800ac9:	eb 1d                	jmp    800ae8 <memmove+0x64>
  800acb:	89 f2                	mov    %esi,%edx
  800acd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acf:	f6 c2 03             	test   $0x3,%dl
  800ad2:	75 0f                	jne    800ae3 <memmove+0x5f>
  800ad4:	f6 c1 03             	test   $0x3,%cl
  800ad7:	75 0a                	jne    800ae3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800adc:	89 c7                	mov    %eax,%edi
  800ade:	fc                   	cld    
  800adf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae1:	eb 05                	jmp    800ae8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ae3:	89 c7                	mov    %eax,%edi
  800ae5:	fc                   	cld    
  800ae6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af2:	8b 45 10             	mov    0x10(%ebp),%eax
  800af5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	89 04 24             	mov    %eax,(%esp)
  800b06:	e8 79 ff ff ff       	call   800a84 <memmove>
}
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	8b 55 08             	mov    0x8(%ebp),%edx
  800b15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b18:	89 d6                	mov    %edx,%esi
  800b1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1d:	eb 1a                	jmp    800b39 <memcmp+0x2c>
		if (*s1 != *s2)
  800b1f:	0f b6 02             	movzbl (%edx),%eax
  800b22:	0f b6 19             	movzbl (%ecx),%ebx
  800b25:	38 d8                	cmp    %bl,%al
  800b27:	74 0a                	je     800b33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b29:	0f b6 c0             	movzbl %al,%eax
  800b2c:	0f b6 db             	movzbl %bl,%ebx
  800b2f:	29 d8                	sub    %ebx,%eax
  800b31:	eb 0f                	jmp    800b42 <memcmp+0x35>
		s1++, s2++;
  800b33:	83 c2 01             	add    $0x1,%edx
  800b36:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b39:	39 f2                	cmp    %esi,%edx
  800b3b:	75 e2                	jne    800b1f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b4f:	89 c2                	mov    %eax,%edx
  800b51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b54:	eb 07                	jmp    800b5d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b56:	38 08                	cmp    %cl,(%eax)
  800b58:	74 07                	je     800b61 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b5a:	83 c0 01             	add    $0x1,%eax
  800b5d:	39 d0                	cmp    %edx,%eax
  800b5f:	72 f5                	jb     800b56 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6f:	eb 03                	jmp    800b74 <strtol+0x11>
		s++;
  800b71:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b74:	0f b6 0a             	movzbl (%edx),%ecx
  800b77:	80 f9 09             	cmp    $0x9,%cl
  800b7a:	74 f5                	je     800b71 <strtol+0xe>
  800b7c:	80 f9 20             	cmp    $0x20,%cl
  800b7f:	74 f0                	je     800b71 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b81:	80 f9 2b             	cmp    $0x2b,%cl
  800b84:	75 0a                	jne    800b90 <strtol+0x2d>
		s++;
  800b86:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b89:	bf 00 00 00 00       	mov    $0x0,%edi
  800b8e:	eb 11                	jmp    800ba1 <strtol+0x3e>
  800b90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b95:	80 f9 2d             	cmp    $0x2d,%cl
  800b98:	75 07                	jne    800ba1 <strtol+0x3e>
		s++, neg = 1;
  800b9a:	8d 52 01             	lea    0x1(%edx),%edx
  800b9d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ba6:	75 15                	jne    800bbd <strtol+0x5a>
  800ba8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bab:	75 10                	jne    800bbd <strtol+0x5a>
  800bad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bb1:	75 0a                	jne    800bbd <strtol+0x5a>
		s += 2, base = 16;
  800bb3:	83 c2 02             	add    $0x2,%edx
  800bb6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bbb:	eb 10                	jmp    800bcd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bbd:	85 c0                	test   %eax,%eax
  800bbf:	75 0c                	jne    800bcd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bc6:	75 05                	jne    800bcd <strtol+0x6a>
		s++, base = 8;
  800bc8:	83 c2 01             	add    $0x1,%edx
  800bcb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bd2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bd5:	0f b6 0a             	movzbl (%edx),%ecx
  800bd8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bdb:	89 f0                	mov    %esi,%eax
  800bdd:	3c 09                	cmp    $0x9,%al
  800bdf:	77 08                	ja     800be9 <strtol+0x86>
			dig = *s - '0';
  800be1:	0f be c9             	movsbl %cl,%ecx
  800be4:	83 e9 30             	sub    $0x30,%ecx
  800be7:	eb 20                	jmp    800c09 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800be9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bec:	89 f0                	mov    %esi,%eax
  800bee:	3c 19                	cmp    $0x19,%al
  800bf0:	77 08                	ja     800bfa <strtol+0x97>
			dig = *s - 'a' + 10;
  800bf2:	0f be c9             	movsbl %cl,%ecx
  800bf5:	83 e9 57             	sub    $0x57,%ecx
  800bf8:	eb 0f                	jmp    800c09 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bfa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bfd:	89 f0                	mov    %esi,%eax
  800bff:	3c 19                	cmp    $0x19,%al
  800c01:	77 16                	ja     800c19 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c03:	0f be c9             	movsbl %cl,%ecx
  800c06:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c09:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c0c:	7d 0f                	jge    800c1d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c0e:	83 c2 01             	add    $0x1,%edx
  800c11:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c15:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c17:	eb bc                	jmp    800bd5 <strtol+0x72>
  800c19:	89 d8                	mov    %ebx,%eax
  800c1b:	eb 02                	jmp    800c1f <strtol+0xbc>
  800c1d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c23:	74 05                	je     800c2a <strtol+0xc7>
		*endptr = (char *) s;
  800c25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c28:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c2a:	f7 d8                	neg    %eax
  800c2c:	85 ff                	test   %edi,%edi
  800c2e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5f                   	pop    %edi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c44:	8b 55 08             	mov    0x8(%ebp),%edx
  800c47:	89 c3                	mov    %eax,%ebx
  800c49:	89 c7                	mov    %eax,%edi
  800c4b:	89 c6                	mov    %eax,%esi
  800c4d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c64:	89 d1                	mov    %edx,%ecx
  800c66:	89 d3                	mov    %edx,%ebx
  800c68:	89 d7                	mov    %edx,%edi
  800c6a:	89 d6                	mov    %edx,%esi
  800c6c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c81:	b8 03 00 00 00       	mov    $0x3,%eax
  800c86:	8b 55 08             	mov    0x8(%ebp),%edx
  800c89:	89 cb                	mov    %ecx,%ebx
  800c8b:	89 cf                	mov    %ecx,%edi
  800c8d:	89 ce                	mov    %ecx,%esi
  800c8f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c91:	85 c0                	test   %eax,%eax
  800c93:	7e 28                	jle    800cbd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c99:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ca0:	00 
  800ca1:	c7 44 24 08 37 2b 80 	movl   $0x802b37,0x8(%esp)
  800ca8:	00 
  800ca9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb0:	00 
  800cb1:	c7 04 24 54 2b 80 00 	movl   $0x802b54,(%esp)
  800cb8:	e8 ba f4 ff ff       	call   800177 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbd:	83 c4 2c             	add    $0x2c,%esp
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
  800ccb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cce:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd3:	b8 04 00 00 00       	mov    $0x4,%eax
  800cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdb:	89 cb                	mov    %ecx,%ebx
  800cdd:	89 cf                	mov    %ecx,%edi
  800cdf:	89 ce                	mov    %ecx,%esi
  800ce1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	7e 28                	jle    800d0f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ceb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cf2:	00 
  800cf3:	c7 44 24 08 37 2b 80 	movl   $0x802b37,0x8(%esp)
  800cfa:	00 
  800cfb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d02:	00 
  800d03:	c7 04 24 54 2b 80 00 	movl   $0x802b54,(%esp)
  800d0a:	e8 68 f4 ff ff       	call   800177 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800d0f:	83 c4 2c             	add    $0x2c,%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d22:	b8 02 00 00 00       	mov    $0x2,%eax
  800d27:	89 d1                	mov    %edx,%ecx
  800d29:	89 d3                	mov    %edx,%ebx
  800d2b:	89 d7                	mov    %edx,%edi
  800d2d:	89 d6                	mov    %edx,%esi
  800d2f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <sys_yield>:

void
sys_yield(void)
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
  800d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d41:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d46:	89 d1                	mov    %edx,%ecx
  800d48:	89 d3                	mov    %edx,%ebx
  800d4a:	89 d7                	mov    %edx,%edi
  800d4c:	89 d6                	mov    %edx,%esi
  800d4e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5e:	be 00 00 00 00       	mov    $0x0,%esi
  800d63:	b8 05 00 00 00       	mov    $0x5,%eax
  800d68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d71:	89 f7                	mov    %esi,%edi
  800d73:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d75:	85 c0                	test   %eax,%eax
  800d77:	7e 28                	jle    800da1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d79:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d84:	00 
  800d85:	c7 44 24 08 37 2b 80 	movl   $0x802b37,0x8(%esp)
  800d8c:	00 
  800d8d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d94:	00 
  800d95:	c7 04 24 54 2b 80 00 	movl   $0x802b54,(%esp)
  800d9c:	e8 d6 f3 ff ff       	call   800177 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800da1:	83 c4 2c             	add    $0x2c,%esp
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5f                   	pop    %edi
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    

00800da9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db2:	b8 06 00 00 00       	mov    $0x6,%eax
  800db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dba:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc3:	8b 75 18             	mov    0x18(%ebp),%esi
  800dc6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	7e 28                	jle    800df4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dd7:	00 
  800dd8:	c7 44 24 08 37 2b 80 	movl   $0x802b37,0x8(%esp)
  800ddf:	00 
  800de0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de7:	00 
  800de8:	c7 04 24 54 2b 80 00 	movl   $0x802b54,(%esp)
  800def:	e8 83 f3 ff ff       	call   800177 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800df4:	83 c4 2c             	add    $0x2c,%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0a:	b8 07 00 00 00       	mov    $0x7,%eax
  800e0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	89 df                	mov    %ebx,%edi
  800e17:	89 de                	mov    %ebx,%esi
  800e19:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7e 28                	jle    800e47 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e23:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800e2a:	00 
  800e2b:	c7 44 24 08 37 2b 80 	movl   $0x802b37,0x8(%esp)
  800e32:	00 
  800e33:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3a:	00 
  800e3b:	c7 04 24 54 2b 80 00 	movl   $0x802b54,(%esp)
  800e42:	e8 30 f3 ff ff       	call   800177 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e47:	83 c4 2c             	add    $0x2c,%esp
  800e4a:	5b                   	pop    %ebx
  800e4b:	5e                   	pop    %esi
  800e4c:	5f                   	pop    %edi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	89 cb                	mov    %ecx,%ebx
  800e64:	89 cf                	mov    %ecx,%edi
  800e66:	89 ce                	mov    %ecx,%esi
  800e68:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800e6a:	5b                   	pop    %ebx
  800e6b:	5e                   	pop    %esi
  800e6c:	5f                   	pop    %edi
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	57                   	push   %edi
  800e73:	56                   	push   %esi
  800e74:	53                   	push   %ebx
  800e75:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e85:	8b 55 08             	mov    0x8(%ebp),%edx
  800e88:	89 df                	mov    %ebx,%edi
  800e8a:	89 de                	mov    %ebx,%esi
  800e8c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e8e:	85 c0                	test   %eax,%eax
  800e90:	7e 28                	jle    800eba <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e92:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e96:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e9d:	00 
  800e9e:	c7 44 24 08 37 2b 80 	movl   $0x802b37,0x8(%esp)
  800ea5:	00 
  800ea6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ead:	00 
  800eae:	c7 04 24 54 2b 80 00 	movl   $0x802b54,(%esp)
  800eb5:	e8 bd f2 ff ff       	call   800177 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eba:	83 c4 2c             	add    $0x2c,%esp
  800ebd:	5b                   	pop    %ebx
  800ebe:	5e                   	pop    %esi
  800ebf:	5f                   	pop    %edi
  800ec0:	5d                   	pop    %ebp
  800ec1:	c3                   	ret    

00800ec2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	57                   	push   %edi
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
  800ec8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ecb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  800edb:	89 df                	mov    %ebx,%edi
  800edd:	89 de                	mov    %ebx,%esi
  800edf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee1:	85 c0                	test   %eax,%eax
  800ee3:	7e 28                	jle    800f0d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ef0:	00 
  800ef1:	c7 44 24 08 37 2b 80 	movl   $0x802b37,0x8(%esp)
  800ef8:	00 
  800ef9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f00:	00 
  800f01:	c7 04 24 54 2b 80 00 	movl   $0x802b54,(%esp)
  800f08:	e8 6a f2 ff ff       	call   800177 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f0d:	83 c4 2c             	add    $0x2c,%esp
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5f                   	pop    %edi
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    

00800f15 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	57                   	push   %edi
  800f19:	56                   	push   %esi
  800f1a:	53                   	push   %ebx
  800f1b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f23:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2e:	89 df                	mov    %ebx,%edi
  800f30:	89 de                	mov    %ebx,%esi
  800f32:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f34:	85 c0                	test   %eax,%eax
  800f36:	7e 28                	jle    800f60 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f38:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f43:	00 
  800f44:	c7 44 24 08 37 2b 80 	movl   $0x802b37,0x8(%esp)
  800f4b:	00 
  800f4c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f53:	00 
  800f54:	c7 04 24 54 2b 80 00 	movl   $0x802b54,(%esp)
  800f5b:	e8 17 f2 ff ff       	call   800177 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f60:	83 c4 2c             	add    $0x2c,%esp
  800f63:	5b                   	pop    %ebx
  800f64:	5e                   	pop    %esi
  800f65:	5f                   	pop    %edi
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    

00800f68 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	57                   	push   %edi
  800f6c:	56                   	push   %esi
  800f6d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6e:	be 00 00 00 00       	mov    $0x0,%esi
  800f73:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f81:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f84:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	57                   	push   %edi
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
  800f91:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f99:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	89 cb                	mov    %ecx,%ebx
  800fa3:	89 cf                	mov    %ecx,%edi
  800fa5:	89 ce                	mov    %ecx,%esi
  800fa7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	7e 28                	jle    800fd5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800fb8:	00 
  800fb9:	c7 44 24 08 37 2b 80 	movl   $0x802b37,0x8(%esp)
  800fc0:	00 
  800fc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc8:	00 
  800fc9:	c7 04 24 54 2b 80 00 	movl   $0x802b54,(%esp)
  800fd0:	e8 a2 f1 ff ff       	call   800177 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fd5:	83 c4 2c             	add    $0x2c,%esp
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	57                   	push   %edi
  800fe1:	56                   	push   %esi
  800fe2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fed:	89 d1                	mov    %edx,%ecx
  800fef:	89 d3                	mov    %edx,%ebx
  800ff1:	89 d7                	mov    %edx,%edi
  800ff3:	89 d6                	mov    %edx,%esi
  800ff5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ff7:	5b                   	pop    %ebx
  800ff8:	5e                   	pop    %esi
  800ff9:	5f                   	pop    %edi
  800ffa:	5d                   	pop    %ebp
  800ffb:	c3                   	ret    

00800ffc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	57                   	push   %edi
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801002:	bb 00 00 00 00       	mov    $0x0,%ebx
  801007:	b8 11 00 00 00       	mov    $0x11,%eax
  80100c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100f:	8b 55 08             	mov    0x8(%ebp),%edx
  801012:	89 df                	mov    %ebx,%edi
  801014:	89 de                	mov    %ebx,%esi
  801016:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801018:	5b                   	pop    %ebx
  801019:	5e                   	pop    %esi
  80101a:	5f                   	pop    %edi
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	57                   	push   %edi
  801021:	56                   	push   %esi
  801022:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801023:	bb 00 00 00 00       	mov    $0x0,%ebx
  801028:	b8 12 00 00 00       	mov    $0x12,%eax
  80102d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	89 df                	mov    %ebx,%edi
  801035:	89 de                	mov    %ebx,%esi
  801037:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	57                   	push   %edi
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801044:	b9 00 00 00 00       	mov    $0x0,%ecx
  801049:	b8 13 00 00 00       	mov    $0x13,%eax
  80104e:	8b 55 08             	mov    0x8(%ebp),%edx
  801051:	89 cb                	mov    %ecx,%ebx
  801053:	89 cf                	mov    %ecx,%edi
  801055:	89 ce                	mov    %ecx,%esi
  801057:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801059:	5b                   	pop    %ebx
  80105a:	5e                   	pop    %esi
  80105b:	5f                   	pop    %edi
  80105c:	5d                   	pop    %ebp
  80105d:	c3                   	ret    
  80105e:	66 90                	xchg   %ax,%ax

00801060 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	05 00 00 00 30       	add    $0x30000000,%eax
  80106b:	c1 e8 0c             	shr    $0xc,%eax
}
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80107b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801080:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    

00801087 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801092:	89 c2                	mov    %eax,%edx
  801094:	c1 ea 16             	shr    $0x16,%edx
  801097:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80109e:	f6 c2 01             	test   $0x1,%dl
  8010a1:	74 11                	je     8010b4 <fd_alloc+0x2d>
  8010a3:	89 c2                	mov    %eax,%edx
  8010a5:	c1 ea 0c             	shr    $0xc,%edx
  8010a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010af:	f6 c2 01             	test   $0x1,%dl
  8010b2:	75 09                	jne    8010bd <fd_alloc+0x36>
			*fd_store = fd;
  8010b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bb:	eb 17                	jmp    8010d4 <fd_alloc+0x4d>
  8010bd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010c7:	75 c9                	jne    801092 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010c9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010dc:	83 f8 1f             	cmp    $0x1f,%eax
  8010df:	77 36                	ja     801117 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010e1:	c1 e0 0c             	shl    $0xc,%eax
  8010e4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010e9:	89 c2                	mov    %eax,%edx
  8010eb:	c1 ea 16             	shr    $0x16,%edx
  8010ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010f5:	f6 c2 01             	test   $0x1,%dl
  8010f8:	74 24                	je     80111e <fd_lookup+0x48>
  8010fa:	89 c2                	mov    %eax,%edx
  8010fc:	c1 ea 0c             	shr    $0xc,%edx
  8010ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801106:	f6 c2 01             	test   $0x1,%dl
  801109:	74 1a                	je     801125 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80110b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110e:	89 02                	mov    %eax,(%edx)
	return 0;
  801110:	b8 00 00 00 00       	mov    $0x0,%eax
  801115:	eb 13                	jmp    80112a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801117:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111c:	eb 0c                	jmp    80112a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80111e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801123:	eb 05                	jmp    80112a <fd_lookup+0x54>
  801125:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    

0080112c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	83 ec 18             	sub    $0x18,%esp
  801132:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801135:	ba 00 00 00 00       	mov    $0x0,%edx
  80113a:	eb 13                	jmp    80114f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80113c:	39 08                	cmp    %ecx,(%eax)
  80113e:	75 0c                	jne    80114c <dev_lookup+0x20>
			*dev = devtab[i];
  801140:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801143:	89 01                	mov    %eax,(%ecx)
			return 0;
  801145:	b8 00 00 00 00       	mov    $0x0,%eax
  80114a:	eb 38                	jmp    801184 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80114c:	83 c2 01             	add    $0x1,%edx
  80114f:	8b 04 95 e0 2b 80 00 	mov    0x802be0(,%edx,4),%eax
  801156:	85 c0                	test   %eax,%eax
  801158:	75 e2                	jne    80113c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80115a:	a1 08 40 80 00       	mov    0x804008,%eax
  80115f:	8b 40 48             	mov    0x48(%eax),%eax
  801162:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80116a:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  801171:	e8 fa f0 ff ff       	call   800270 <cprintf>
	*dev = 0;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80117f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	56                   	push   %esi
  80118a:	53                   	push   %ebx
  80118b:	83 ec 20             	sub    $0x20,%esp
  80118e:	8b 75 08             	mov    0x8(%ebp),%esi
  801191:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801194:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801197:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80119b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011a1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011a4:	89 04 24             	mov    %eax,(%esp)
  8011a7:	e8 2a ff ff ff       	call   8010d6 <fd_lookup>
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	78 05                	js     8011b5 <fd_close+0x2f>
	    || fd != fd2)
  8011b0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011b3:	74 0c                	je     8011c1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011b5:	84 db                	test   %bl,%bl
  8011b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bc:	0f 44 c2             	cmove  %edx,%eax
  8011bf:	eb 3f                	jmp    801200 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c8:	8b 06                	mov    (%esi),%eax
  8011ca:	89 04 24             	mov    %eax,(%esp)
  8011cd:	e8 5a ff ff ff       	call   80112c <dev_lookup>
  8011d2:	89 c3                	mov    %eax,%ebx
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	78 16                	js     8011ee <fd_close+0x68>
		if (dev->dev_close)
  8011d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	74 07                	je     8011ee <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011e7:	89 34 24             	mov    %esi,(%esp)
  8011ea:	ff d0                	call   *%eax
  8011ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011f9:	e8 fe fb ff ff       	call   800dfc <sys_page_unmap>
	return r;
  8011fe:	89 d8                	mov    %ebx,%eax
}
  801200:	83 c4 20             	add    $0x20,%esp
  801203:	5b                   	pop    %ebx
  801204:	5e                   	pop    %esi
  801205:	5d                   	pop    %ebp
  801206:	c3                   	ret    

00801207 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80120d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801210:	89 44 24 04          	mov    %eax,0x4(%esp)
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	89 04 24             	mov    %eax,(%esp)
  80121a:	e8 b7 fe ff ff       	call   8010d6 <fd_lookup>
  80121f:	89 c2                	mov    %eax,%edx
  801221:	85 d2                	test   %edx,%edx
  801223:	78 13                	js     801238 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801225:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80122c:	00 
  80122d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801230:	89 04 24             	mov    %eax,(%esp)
  801233:	e8 4e ff ff ff       	call   801186 <fd_close>
}
  801238:	c9                   	leave  
  801239:	c3                   	ret    

0080123a <close_all>:

void
close_all(void)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	53                   	push   %ebx
  80123e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801241:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801246:	89 1c 24             	mov    %ebx,(%esp)
  801249:	e8 b9 ff ff ff       	call   801207 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80124e:	83 c3 01             	add    $0x1,%ebx
  801251:	83 fb 20             	cmp    $0x20,%ebx
  801254:	75 f0                	jne    801246 <close_all+0xc>
		close(i);
}
  801256:	83 c4 14             	add    $0x14,%esp
  801259:	5b                   	pop    %ebx
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    

0080125c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	57                   	push   %edi
  801260:	56                   	push   %esi
  801261:	53                   	push   %ebx
  801262:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801265:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	89 04 24             	mov    %eax,(%esp)
  801272:	e8 5f fe ff ff       	call   8010d6 <fd_lookup>
  801277:	89 c2                	mov    %eax,%edx
  801279:	85 d2                	test   %edx,%edx
  80127b:	0f 88 e1 00 00 00    	js     801362 <dup+0x106>
		return r;
	close(newfdnum);
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	89 04 24             	mov    %eax,(%esp)
  801287:	e8 7b ff ff ff       	call   801207 <close>

	newfd = INDEX2FD(newfdnum);
  80128c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80128f:	c1 e3 0c             	shl    $0xc,%ebx
  801292:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801298:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80129b:	89 04 24             	mov    %eax,(%esp)
  80129e:	e8 cd fd ff ff       	call   801070 <fd2data>
  8012a3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012a5:	89 1c 24             	mov    %ebx,(%esp)
  8012a8:	e8 c3 fd ff ff       	call   801070 <fd2data>
  8012ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012af:	89 f0                	mov    %esi,%eax
  8012b1:	c1 e8 16             	shr    $0x16,%eax
  8012b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012bb:	a8 01                	test   $0x1,%al
  8012bd:	74 43                	je     801302 <dup+0xa6>
  8012bf:	89 f0                	mov    %esi,%eax
  8012c1:	c1 e8 0c             	shr    $0xc,%eax
  8012c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012cb:	f6 c2 01             	test   $0x1,%dl
  8012ce:	74 32                	je     801302 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012e0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012eb:	00 
  8012ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012f7:	e8 ad fa ff ff       	call   800da9 <sys_page_map>
  8012fc:	89 c6                	mov    %eax,%esi
  8012fe:	85 c0                	test   %eax,%eax
  801300:	78 3e                	js     801340 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801305:	89 c2                	mov    %eax,%edx
  801307:	c1 ea 0c             	shr    $0xc,%edx
  80130a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801311:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801317:	89 54 24 10          	mov    %edx,0x10(%esp)
  80131b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80131f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801326:	00 
  801327:	89 44 24 04          	mov    %eax,0x4(%esp)
  80132b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801332:	e8 72 fa ff ff       	call   800da9 <sys_page_map>
  801337:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80133c:	85 f6                	test   %esi,%esi
  80133e:	79 22                	jns    801362 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801340:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801344:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80134b:	e8 ac fa ff ff       	call   800dfc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801350:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801354:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80135b:	e8 9c fa ff ff       	call   800dfc <sys_page_unmap>
	return r;
  801360:	89 f0                	mov    %esi,%eax
}
  801362:	83 c4 3c             	add    $0x3c,%esp
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5f                   	pop    %edi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	53                   	push   %ebx
  80136e:	83 ec 24             	sub    $0x24,%esp
  801371:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801374:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801377:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137b:	89 1c 24             	mov    %ebx,(%esp)
  80137e:	e8 53 fd ff ff       	call   8010d6 <fd_lookup>
  801383:	89 c2                	mov    %eax,%edx
  801385:	85 d2                	test   %edx,%edx
  801387:	78 6d                	js     8013f6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801389:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801393:	8b 00                	mov    (%eax),%eax
  801395:	89 04 24             	mov    %eax,(%esp)
  801398:	e8 8f fd ff ff       	call   80112c <dev_lookup>
  80139d:	85 c0                	test   %eax,%eax
  80139f:	78 55                	js     8013f6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a4:	8b 50 08             	mov    0x8(%eax),%edx
  8013a7:	83 e2 03             	and    $0x3,%edx
  8013aa:	83 fa 01             	cmp    $0x1,%edx
  8013ad:	75 23                	jne    8013d2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013af:	a1 08 40 80 00       	mov    0x804008,%eax
  8013b4:	8b 40 48             	mov    0x48(%eax),%eax
  8013b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bf:	c7 04 24 a5 2b 80 00 	movl   $0x802ba5,(%esp)
  8013c6:	e8 a5 ee ff ff       	call   800270 <cprintf>
		return -E_INVAL;
  8013cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d0:	eb 24                	jmp    8013f6 <read+0x8c>
	}
	if (!dev->dev_read)
  8013d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d5:	8b 52 08             	mov    0x8(%edx),%edx
  8013d8:	85 d2                	test   %edx,%edx
  8013da:	74 15                	je     8013f1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013ea:	89 04 24             	mov    %eax,(%esp)
  8013ed:	ff d2                	call   *%edx
  8013ef:	eb 05                	jmp    8013f6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013f6:	83 c4 24             	add    $0x24,%esp
  8013f9:	5b                   	pop    %ebx
  8013fa:	5d                   	pop    %ebp
  8013fb:	c3                   	ret    

008013fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	57                   	push   %edi
  801400:	56                   	push   %esi
  801401:	53                   	push   %ebx
  801402:	83 ec 1c             	sub    $0x1c,%esp
  801405:	8b 7d 08             	mov    0x8(%ebp),%edi
  801408:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80140b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801410:	eb 23                	jmp    801435 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801412:	89 f0                	mov    %esi,%eax
  801414:	29 d8                	sub    %ebx,%eax
  801416:	89 44 24 08          	mov    %eax,0x8(%esp)
  80141a:	89 d8                	mov    %ebx,%eax
  80141c:	03 45 0c             	add    0xc(%ebp),%eax
  80141f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801423:	89 3c 24             	mov    %edi,(%esp)
  801426:	e8 3f ff ff ff       	call   80136a <read>
		if (m < 0)
  80142b:	85 c0                	test   %eax,%eax
  80142d:	78 10                	js     80143f <readn+0x43>
			return m;
		if (m == 0)
  80142f:	85 c0                	test   %eax,%eax
  801431:	74 0a                	je     80143d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801433:	01 c3                	add    %eax,%ebx
  801435:	39 f3                	cmp    %esi,%ebx
  801437:	72 d9                	jb     801412 <readn+0x16>
  801439:	89 d8                	mov    %ebx,%eax
  80143b:	eb 02                	jmp    80143f <readn+0x43>
  80143d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80143f:	83 c4 1c             	add    $0x1c,%esp
  801442:	5b                   	pop    %ebx
  801443:	5e                   	pop    %esi
  801444:	5f                   	pop    %edi
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    

00801447 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	53                   	push   %ebx
  80144b:	83 ec 24             	sub    $0x24,%esp
  80144e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801451:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801454:	89 44 24 04          	mov    %eax,0x4(%esp)
  801458:	89 1c 24             	mov    %ebx,(%esp)
  80145b:	e8 76 fc ff ff       	call   8010d6 <fd_lookup>
  801460:	89 c2                	mov    %eax,%edx
  801462:	85 d2                	test   %edx,%edx
  801464:	78 68                	js     8014ce <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801466:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801469:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801470:	8b 00                	mov    (%eax),%eax
  801472:	89 04 24             	mov    %eax,(%esp)
  801475:	e8 b2 fc ff ff       	call   80112c <dev_lookup>
  80147a:	85 c0                	test   %eax,%eax
  80147c:	78 50                	js     8014ce <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80147e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801481:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801485:	75 23                	jne    8014aa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801487:	a1 08 40 80 00       	mov    0x804008,%eax
  80148c:	8b 40 48             	mov    0x48(%eax),%eax
  80148f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801493:	89 44 24 04          	mov    %eax,0x4(%esp)
  801497:	c7 04 24 c1 2b 80 00 	movl   $0x802bc1,(%esp)
  80149e:	e8 cd ed ff ff       	call   800270 <cprintf>
		return -E_INVAL;
  8014a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a8:	eb 24                	jmp    8014ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8014b0:	85 d2                	test   %edx,%edx
  8014b2:	74 15                	je     8014c9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014c2:	89 04 24             	mov    %eax,(%esp)
  8014c5:	ff d2                	call   *%edx
  8014c7:	eb 05                	jmp    8014ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014ce:	83 c4 24             	add    $0x24,%esp
  8014d1:	5b                   	pop    %ebx
  8014d2:	5d                   	pop    %ebp
  8014d3:	c3                   	ret    

008014d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014da:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 04 24             	mov    %eax,(%esp)
  8014e7:	e8 ea fb ff ff       	call   8010d6 <fd_lookup>
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 0e                	js     8014fe <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	53                   	push   %ebx
  801504:	83 ec 24             	sub    $0x24,%esp
  801507:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801511:	89 1c 24             	mov    %ebx,(%esp)
  801514:	e8 bd fb ff ff       	call   8010d6 <fd_lookup>
  801519:	89 c2                	mov    %eax,%edx
  80151b:	85 d2                	test   %edx,%edx
  80151d:	78 61                	js     801580 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801522:	89 44 24 04          	mov    %eax,0x4(%esp)
  801526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	89 04 24             	mov    %eax,(%esp)
  80152e:	e8 f9 fb ff ff       	call   80112c <dev_lookup>
  801533:	85 c0                	test   %eax,%eax
  801535:	78 49                	js     801580 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80153e:	75 23                	jne    801563 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801540:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801545:	8b 40 48             	mov    0x48(%eax),%eax
  801548:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80154c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801550:	c7 04 24 84 2b 80 00 	movl   $0x802b84,(%esp)
  801557:	e8 14 ed ff ff       	call   800270 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80155c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801561:	eb 1d                	jmp    801580 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801566:	8b 52 18             	mov    0x18(%edx),%edx
  801569:	85 d2                	test   %edx,%edx
  80156b:	74 0e                	je     80157b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80156d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801570:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801574:	89 04 24             	mov    %eax,(%esp)
  801577:	ff d2                	call   *%edx
  801579:	eb 05                	jmp    801580 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80157b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801580:	83 c4 24             	add    $0x24,%esp
  801583:	5b                   	pop    %ebx
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	53                   	push   %ebx
  80158a:	83 ec 24             	sub    $0x24,%esp
  80158d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801590:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801593:	89 44 24 04          	mov    %eax,0x4(%esp)
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	89 04 24             	mov    %eax,(%esp)
  80159d:	e8 34 fb ff ff       	call   8010d6 <fd_lookup>
  8015a2:	89 c2                	mov    %eax,%edx
  8015a4:	85 d2                	test   %edx,%edx
  8015a6:	78 52                	js     8015fa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b2:	8b 00                	mov    (%eax),%eax
  8015b4:	89 04 24             	mov    %eax,(%esp)
  8015b7:	e8 70 fb ff ff       	call   80112c <dev_lookup>
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 3a                	js     8015fa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015c7:	74 2c                	je     8015f5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015c9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015cc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015d3:	00 00 00 
	stat->st_isdir = 0;
  8015d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015dd:	00 00 00 
	stat->st_dev = dev;
  8015e0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ed:	89 14 24             	mov    %edx,(%esp)
  8015f0:	ff 50 14             	call   *0x14(%eax)
  8015f3:	eb 05                	jmp    8015fa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015fa:	83 c4 24             	add    $0x24,%esp
  8015fd:	5b                   	pop    %ebx
  8015fe:	5d                   	pop    %ebp
  8015ff:	c3                   	ret    

00801600 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	56                   	push   %esi
  801604:	53                   	push   %ebx
  801605:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801608:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80160f:	00 
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	89 04 24             	mov    %eax,(%esp)
  801616:	e8 99 02 00 00       	call   8018b4 <open>
  80161b:	89 c3                	mov    %eax,%ebx
  80161d:	85 db                	test   %ebx,%ebx
  80161f:	78 1b                	js     80163c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801621:	8b 45 0c             	mov    0xc(%ebp),%eax
  801624:	89 44 24 04          	mov    %eax,0x4(%esp)
  801628:	89 1c 24             	mov    %ebx,(%esp)
  80162b:	e8 56 ff ff ff       	call   801586 <fstat>
  801630:	89 c6                	mov    %eax,%esi
	close(fd);
  801632:	89 1c 24             	mov    %ebx,(%esp)
  801635:	e8 cd fb ff ff       	call   801207 <close>
	return r;
  80163a:	89 f0                	mov    %esi,%eax
}
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	5b                   	pop    %ebx
  801640:	5e                   	pop    %esi
  801641:	5d                   	pop    %ebp
  801642:	c3                   	ret    

00801643 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	56                   	push   %esi
  801647:	53                   	push   %ebx
  801648:	83 ec 10             	sub    $0x10,%esp
  80164b:	89 c6                	mov    %eax,%esi
  80164d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80164f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801656:	75 11                	jne    801669 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801658:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80165f:	e8 2b 0e 00 00       	call   80248f <ipc_find_env>
  801664:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801669:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801670:	00 
  801671:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801678:	00 
  801679:	89 74 24 04          	mov    %esi,0x4(%esp)
  80167d:	a1 00 40 80 00       	mov    0x804000,%eax
  801682:	89 04 24             	mov    %eax,(%esp)
  801685:	e8 9e 0d 00 00       	call   802428 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80168a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801691:	00 
  801692:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801696:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80169d:	e8 1e 0d 00 00       	call   8023c0 <ipc_recv>
}
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    

008016a9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016cc:	e8 72 ff ff ff       	call   801643 <fsipc>
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016df:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016ee:	e8 50 ff ff ff       	call   801643 <fsipc>
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	53                   	push   %ebx
  8016f9:	83 ec 14             	sub    $0x14,%esp
  8016fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8b 40 0c             	mov    0xc(%eax),%eax
  801705:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80170a:	ba 00 00 00 00       	mov    $0x0,%edx
  80170f:	b8 05 00 00 00       	mov    $0x5,%eax
  801714:	e8 2a ff ff ff       	call   801643 <fsipc>
  801719:	89 c2                	mov    %eax,%edx
  80171b:	85 d2                	test   %edx,%edx
  80171d:	78 2b                	js     80174a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80171f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801726:	00 
  801727:	89 1c 24             	mov    %ebx,(%esp)
  80172a:	e8 b8 f1 ff ff       	call   8008e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80172f:	a1 80 50 80 00       	mov    0x805080,%eax
  801734:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80173a:	a1 84 50 80 00       	mov    0x805084,%eax
  80173f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801745:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174a:	83 c4 14             	add    $0x14,%esp
  80174d:	5b                   	pop    %ebx
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	53                   	push   %ebx
  801754:	83 ec 14             	sub    $0x14,%esp
  801757:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80175a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801760:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801765:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801768:	8b 55 08             	mov    0x8(%ebp),%edx
  80176b:	8b 52 0c             	mov    0xc(%edx),%edx
  80176e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  801774:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801779:	89 44 24 08          	mov    %eax,0x8(%esp)
  80177d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801780:	89 44 24 04          	mov    %eax,0x4(%esp)
  801784:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80178b:	e8 f4 f2 ff ff       	call   800a84 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801790:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  801797:	00 
  801798:	c7 04 24 f4 2b 80 00 	movl   $0x802bf4,(%esp)
  80179f:	e8 cc ea ff ff       	call   800270 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a9:	b8 04 00 00 00       	mov    $0x4,%eax
  8017ae:	e8 90 fe ff ff       	call   801643 <fsipc>
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	78 53                	js     80180a <devfile_write+0xba>
		return r;
	assert(r <= n);
  8017b7:	39 c3                	cmp    %eax,%ebx
  8017b9:	73 24                	jae    8017df <devfile_write+0x8f>
  8017bb:	c7 44 24 0c f9 2b 80 	movl   $0x802bf9,0xc(%esp)
  8017c2:	00 
  8017c3:	c7 44 24 08 00 2c 80 	movl   $0x802c00,0x8(%esp)
  8017ca:	00 
  8017cb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8017d2:	00 
  8017d3:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
  8017da:	e8 98 e9 ff ff       	call   800177 <_panic>
	assert(r <= PGSIZE);
  8017df:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017e4:	7e 24                	jle    80180a <devfile_write+0xba>
  8017e6:	c7 44 24 0c 20 2c 80 	movl   $0x802c20,0xc(%esp)
  8017ed:	00 
  8017ee:	c7 44 24 08 00 2c 80 	movl   $0x802c00,0x8(%esp)
  8017f5:	00 
  8017f6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8017fd:	00 
  8017fe:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
  801805:	e8 6d e9 ff ff       	call   800177 <_panic>
	return r;
}
  80180a:	83 c4 14             	add    $0x14,%esp
  80180d:	5b                   	pop    %ebx
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    

00801810 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	56                   	push   %esi
  801814:	53                   	push   %ebx
  801815:	83 ec 10             	sub    $0x10,%esp
  801818:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8b 40 0c             	mov    0xc(%eax),%eax
  801821:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801826:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80182c:	ba 00 00 00 00       	mov    $0x0,%edx
  801831:	b8 03 00 00 00       	mov    $0x3,%eax
  801836:	e8 08 fe ff ff       	call   801643 <fsipc>
  80183b:	89 c3                	mov    %eax,%ebx
  80183d:	85 c0                	test   %eax,%eax
  80183f:	78 6a                	js     8018ab <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801841:	39 c6                	cmp    %eax,%esi
  801843:	73 24                	jae    801869 <devfile_read+0x59>
  801845:	c7 44 24 0c f9 2b 80 	movl   $0x802bf9,0xc(%esp)
  80184c:	00 
  80184d:	c7 44 24 08 00 2c 80 	movl   $0x802c00,0x8(%esp)
  801854:	00 
  801855:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80185c:	00 
  80185d:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
  801864:	e8 0e e9 ff ff       	call   800177 <_panic>
	assert(r <= PGSIZE);
  801869:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80186e:	7e 24                	jle    801894 <devfile_read+0x84>
  801870:	c7 44 24 0c 20 2c 80 	movl   $0x802c20,0xc(%esp)
  801877:	00 
  801878:	c7 44 24 08 00 2c 80 	movl   $0x802c00,0x8(%esp)
  80187f:	00 
  801880:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801887:	00 
  801888:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
  80188f:	e8 e3 e8 ff ff       	call   800177 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801894:	89 44 24 08          	mov    %eax,0x8(%esp)
  801898:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80189f:	00 
  8018a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a3:	89 04 24             	mov    %eax,(%esp)
  8018a6:	e8 d9 f1 ff ff       	call   800a84 <memmove>
	return r;
}
  8018ab:	89 d8                	mov    %ebx,%eax
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	5b                   	pop    %ebx
  8018b1:	5e                   	pop    %esi
  8018b2:	5d                   	pop    %ebp
  8018b3:	c3                   	ret    

008018b4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	53                   	push   %ebx
  8018b8:	83 ec 24             	sub    $0x24,%esp
  8018bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018be:	89 1c 24             	mov    %ebx,(%esp)
  8018c1:	e8 ea ef ff ff       	call   8008b0 <strlen>
  8018c6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018cb:	7f 60                	jg     80192d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d0:	89 04 24             	mov    %eax,(%esp)
  8018d3:	e8 af f7 ff ff       	call   801087 <fd_alloc>
  8018d8:	89 c2                	mov    %eax,%edx
  8018da:	85 d2                	test   %edx,%edx
  8018dc:	78 54                	js     801932 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018e2:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018e9:	e8 f9 ef ff ff       	call   8008e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f1:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018fe:	e8 40 fd ff ff       	call   801643 <fsipc>
  801903:	89 c3                	mov    %eax,%ebx
  801905:	85 c0                	test   %eax,%eax
  801907:	79 17                	jns    801920 <open+0x6c>
		fd_close(fd, 0);
  801909:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801910:	00 
  801911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801914:	89 04 24             	mov    %eax,(%esp)
  801917:	e8 6a f8 ff ff       	call   801186 <fd_close>
		return r;
  80191c:	89 d8                	mov    %ebx,%eax
  80191e:	eb 12                	jmp    801932 <open+0x7e>
	}

	return fd2num(fd);
  801920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801923:	89 04 24             	mov    %eax,(%esp)
  801926:	e8 35 f7 ff ff       	call   801060 <fd2num>
  80192b:	eb 05                	jmp    801932 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80192d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801932:	83 c4 24             	add    $0x24,%esp
  801935:	5b                   	pop    %ebx
  801936:	5d                   	pop    %ebp
  801937:	c3                   	ret    

00801938 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80193e:	ba 00 00 00 00       	mov    $0x0,%edx
  801943:	b8 08 00 00 00       	mov    $0x8,%eax
  801948:	e8 f6 fc ff ff       	call   801643 <fsipc>
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <evict>:

int evict(void)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801955:	c7 04 24 2c 2c 80 00 	movl   $0x802c2c,(%esp)
  80195c:	e8 0f e9 ff ff       	call   800270 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801961:	ba 00 00 00 00       	mov    $0x0,%edx
  801966:	b8 09 00 00 00       	mov    $0x9,%eax
  80196b:	e8 d3 fc ff ff       	call   801643 <fsipc>
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    
  801972:	66 90                	xchg   %ax,%ax
  801974:	66 90                	xchg   %ax,%ax
  801976:	66 90                	xchg   %ax,%ax
  801978:	66 90                	xchg   %ax,%ax
  80197a:	66 90                	xchg   %ax,%ax
  80197c:	66 90                	xchg   %ax,%ax
  80197e:	66 90                	xchg   %ax,%ax

00801980 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801986:	c7 44 24 04 45 2c 80 	movl   $0x802c45,0x4(%esp)
  80198d:	00 
  80198e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801991:	89 04 24             	mov    %eax,(%esp)
  801994:	e8 4e ef ff ff       	call   8008e7 <strcpy>
	return 0;
}
  801999:	b8 00 00 00 00       	mov    $0x0,%eax
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	53                   	push   %ebx
  8019a4:	83 ec 14             	sub    $0x14,%esp
  8019a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019aa:	89 1c 24             	mov    %ebx,(%esp)
  8019ad:	e8 15 0b 00 00       	call   8024c7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8019b2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8019b7:	83 f8 01             	cmp    $0x1,%eax
  8019ba:	75 0d                	jne    8019c9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8019bc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8019bf:	89 04 24             	mov    %eax,(%esp)
  8019c2:	e8 29 03 00 00       	call   801cf0 <nsipc_close>
  8019c7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8019c9:	89 d0                	mov    %edx,%eax
  8019cb:	83 c4 14             	add    $0x14,%esp
  8019ce:	5b                   	pop    %ebx
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    

008019d1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019de:	00 
  8019df:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f3:	89 04 24             	mov    %eax,(%esp)
  8019f6:	e8 f0 03 00 00       	call   801deb <nsipc_send>
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a03:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a0a:	00 
  801a0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1f:	89 04 24             	mov    %eax,(%esp)
  801a22:	e8 44 03 00 00       	call   801d6b <nsipc_recv>
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a2f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a32:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a36:	89 04 24             	mov    %eax,(%esp)
  801a39:	e8 98 f6 ff ff       	call   8010d6 <fd_lookup>
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 17                	js     801a59 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a45:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a4b:	39 08                	cmp    %ecx,(%eax)
  801a4d:	75 05                	jne    801a54 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801a4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a52:	eb 05                	jmp    801a59 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801a54:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	56                   	push   %esi
  801a5f:	53                   	push   %ebx
  801a60:	83 ec 20             	sub    $0x20,%esp
  801a63:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a68:	89 04 24             	mov    %eax,(%esp)
  801a6b:	e8 17 f6 ff ff       	call   801087 <fd_alloc>
  801a70:	89 c3                	mov    %eax,%ebx
  801a72:	85 c0                	test   %eax,%eax
  801a74:	78 21                	js     801a97 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a76:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a7d:	00 
  801a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8c:	e8 c4 f2 ff ff       	call   800d55 <sys_page_alloc>
  801a91:	89 c3                	mov    %eax,%ebx
  801a93:	85 c0                	test   %eax,%eax
  801a95:	79 0c                	jns    801aa3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801a97:	89 34 24             	mov    %esi,(%esp)
  801a9a:	e8 51 02 00 00       	call   801cf0 <nsipc_close>
		return r;
  801a9f:	89 d8                	mov    %ebx,%eax
  801aa1:	eb 20                	jmp    801ac3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801aa3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801aae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801ab8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801abb:	89 14 24             	mov    %edx,(%esp)
  801abe:	e8 9d f5 ff ff       	call   801060 <fd2num>
}
  801ac3:	83 c4 20             	add    $0x20,%esp
  801ac6:	5b                   	pop    %ebx
  801ac7:	5e                   	pop    %esi
  801ac8:	5d                   	pop    %ebp
  801ac9:	c3                   	ret    

00801aca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	e8 51 ff ff ff       	call   801a29 <fd2sockid>
		return r;
  801ad8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ada:	85 c0                	test   %eax,%eax
  801adc:	78 23                	js     801b01 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ade:	8b 55 10             	mov    0x10(%ebp),%edx
  801ae1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801aec:	89 04 24             	mov    %eax,(%esp)
  801aef:	e8 45 01 00 00       	call   801c39 <nsipc_accept>
		return r;
  801af4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 07                	js     801b01 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801afa:	e8 5c ff ff ff       	call   801a5b <alloc_sockfd>
  801aff:	89 c1                	mov    %eax,%ecx
}
  801b01:	89 c8                	mov    %ecx,%eax
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	e8 16 ff ff ff       	call   801a29 <fd2sockid>
  801b13:	89 c2                	mov    %eax,%edx
  801b15:	85 d2                	test   %edx,%edx
  801b17:	78 16                	js     801b2f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801b19:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b27:	89 14 24             	mov    %edx,(%esp)
  801b2a:	e8 60 01 00 00       	call   801c8f <nsipc_bind>
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <shutdown>:

int
shutdown(int s, int how)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	e8 ea fe ff ff       	call   801a29 <fd2sockid>
  801b3f:	89 c2                	mov    %eax,%edx
  801b41:	85 d2                	test   %edx,%edx
  801b43:	78 0f                	js     801b54 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4c:	89 14 24             	mov    %edx,(%esp)
  801b4f:	e8 7a 01 00 00       	call   801cce <nsipc_shutdown>
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	e8 c5 fe ff ff       	call   801a29 <fd2sockid>
  801b64:	89 c2                	mov    %eax,%edx
  801b66:	85 d2                	test   %edx,%edx
  801b68:	78 16                	js     801b80 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b78:	89 14 24             	mov    %edx,(%esp)
  801b7b:	e8 8a 01 00 00       	call   801d0a <nsipc_connect>
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <listen>:

int
listen(int s, int backlog)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	e8 99 fe ff ff       	call   801a29 <fd2sockid>
  801b90:	89 c2                	mov    %eax,%edx
  801b92:	85 d2                	test   %edx,%edx
  801b94:	78 0f                	js     801ba5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9d:	89 14 24             	mov    %edx,(%esp)
  801ba0:	e8 a4 01 00 00       	call   801d49 <nsipc_listen>
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bad:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	89 04 24             	mov    %eax,(%esp)
  801bc1:	e8 98 02 00 00       	call   801e5e <nsipc_socket>
  801bc6:	89 c2                	mov    %eax,%edx
  801bc8:	85 d2                	test   %edx,%edx
  801bca:	78 05                	js     801bd1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801bcc:	e8 8a fe ff ff       	call   801a5b <alloc_sockfd>
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	53                   	push   %ebx
  801bd7:	83 ec 14             	sub    $0x14,%esp
  801bda:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bdc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801be3:	75 11                	jne    801bf6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801be5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801bec:	e8 9e 08 00 00       	call   80248f <ipc_find_env>
  801bf1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bf6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bfd:	00 
  801bfe:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c05:	00 
  801c06:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c0a:	a1 04 40 80 00       	mov    0x804004,%eax
  801c0f:	89 04 24             	mov    %eax,(%esp)
  801c12:	e8 11 08 00 00       	call   802428 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c17:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c1e:	00 
  801c1f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c26:	00 
  801c27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c2e:	e8 8d 07 00 00       	call   8023c0 <ipc_recv>
}
  801c33:	83 c4 14             	add    $0x14,%esp
  801c36:	5b                   	pop    %ebx
  801c37:	5d                   	pop    %ebp
  801c38:	c3                   	ret    

00801c39 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	56                   	push   %esi
  801c3d:	53                   	push   %ebx
  801c3e:	83 ec 10             	sub    $0x10,%esp
  801c41:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c4c:	8b 06                	mov    (%esi),%eax
  801c4e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c53:	b8 01 00 00 00       	mov    $0x1,%eax
  801c58:	e8 76 ff ff ff       	call   801bd3 <nsipc>
  801c5d:	89 c3                	mov    %eax,%ebx
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	78 23                	js     801c86 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c63:	a1 10 60 80 00       	mov    0x806010,%eax
  801c68:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c6c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c73:	00 
  801c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c77:	89 04 24             	mov    %eax,(%esp)
  801c7a:	e8 05 ee ff ff       	call   800a84 <memmove>
		*addrlen = ret->ret_addrlen;
  801c7f:	a1 10 60 80 00       	mov    0x806010,%eax
  801c84:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801c86:	89 d8                	mov    %ebx,%eax
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	5b                   	pop    %ebx
  801c8c:	5e                   	pop    %esi
  801c8d:	5d                   	pop    %ebp
  801c8e:	c3                   	ret    

00801c8f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	53                   	push   %ebx
  801c93:	83 ec 14             	sub    $0x14,%esp
  801c96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ca1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cac:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801cb3:	e8 cc ed ff ff       	call   800a84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cb8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cbe:	b8 02 00 00 00       	mov    $0x2,%eax
  801cc3:	e8 0b ff ff ff       	call   801bd3 <nsipc>
}
  801cc8:	83 c4 14             	add    $0x14,%esp
  801ccb:	5b                   	pop    %ebx
  801ccc:	5d                   	pop    %ebp
  801ccd:	c3                   	ret    

00801cce <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ce4:	b8 03 00 00 00       	mov    $0x3,%eax
  801ce9:	e8 e5 fe ff ff       	call   801bd3 <nsipc>
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <nsipc_close>:

int
nsipc_close(int s)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cfe:	b8 04 00 00 00       	mov    $0x4,%eax
  801d03:	e8 cb fe ff ff       	call   801bd3 <nsipc>
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	53                   	push   %ebx
  801d0e:	83 ec 14             	sub    $0x14,%esp
  801d11:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d1c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d27:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d2e:	e8 51 ed ff ff       	call   800a84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d33:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d39:	b8 05 00 00 00       	mov    $0x5,%eax
  801d3e:	e8 90 fe ff ff       	call   801bd3 <nsipc>
}
  801d43:	83 c4 14             	add    $0x14,%esp
  801d46:	5b                   	pop    %ebx
  801d47:	5d                   	pop    %ebp
  801d48:	c3                   	ret    

00801d49 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d5f:	b8 06 00 00 00       	mov    $0x6,%eax
  801d64:	e8 6a fe ff ff       	call   801bd3 <nsipc>
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
  801d70:	83 ec 10             	sub    $0x10,%esp
  801d73:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d7e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d84:	8b 45 14             	mov    0x14(%ebp),%eax
  801d87:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d8c:	b8 07 00 00 00       	mov    $0x7,%eax
  801d91:	e8 3d fe ff ff       	call   801bd3 <nsipc>
  801d96:	89 c3                	mov    %eax,%ebx
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	78 46                	js     801de2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d9c:	39 f0                	cmp    %esi,%eax
  801d9e:	7f 07                	jg     801da7 <nsipc_recv+0x3c>
  801da0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801da5:	7e 24                	jle    801dcb <nsipc_recv+0x60>
  801da7:	c7 44 24 0c 51 2c 80 	movl   $0x802c51,0xc(%esp)
  801dae:	00 
  801daf:	c7 44 24 08 00 2c 80 	movl   $0x802c00,0x8(%esp)
  801db6:	00 
  801db7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801dbe:	00 
  801dbf:	c7 04 24 66 2c 80 00 	movl   $0x802c66,(%esp)
  801dc6:	e8 ac e3 ff ff       	call   800177 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dcb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dcf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801dd6:	00 
  801dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dda:	89 04 24             	mov    %eax,(%esp)
  801ddd:	e8 a2 ec ff ff       	call   800a84 <memmove>
	}

	return r;
}
  801de2:	89 d8                	mov    %ebx,%eax
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    

00801deb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	53                   	push   %ebx
  801def:	83 ec 14             	sub    $0x14,%esp
  801df2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dfd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e03:	7e 24                	jle    801e29 <nsipc_send+0x3e>
  801e05:	c7 44 24 0c 72 2c 80 	movl   $0x802c72,0xc(%esp)
  801e0c:	00 
  801e0d:	c7 44 24 08 00 2c 80 	movl   $0x802c00,0x8(%esp)
  801e14:	00 
  801e15:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801e1c:	00 
  801e1d:	c7 04 24 66 2c 80 00 	movl   $0x802c66,(%esp)
  801e24:	e8 4e e3 ff ff       	call   800177 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e29:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e34:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801e3b:	e8 44 ec ff ff       	call   800a84 <memmove>
	nsipcbuf.send.req_size = size;
  801e40:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e46:	8b 45 14             	mov    0x14(%ebp),%eax
  801e49:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e4e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e53:	e8 7b fd ff ff       	call   801bd3 <nsipc>
}
  801e58:	83 c4 14             	add    $0x14,%esp
  801e5b:	5b                   	pop    %ebx
  801e5c:	5d                   	pop    %ebp
  801e5d:	c3                   	ret    

00801e5e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e74:	8b 45 10             	mov    0x10(%ebp),%eax
  801e77:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e7c:	b8 09 00 00 00       	mov    $0x9,%eax
  801e81:	e8 4d fd ff ff       	call   801bd3 <nsipc>
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	56                   	push   %esi
  801e8c:	53                   	push   %ebx
  801e8d:	83 ec 10             	sub    $0x10,%esp
  801e90:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	89 04 24             	mov    %eax,(%esp)
  801e99:	e8 d2 f1 ff ff       	call   801070 <fd2data>
  801e9e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ea0:	c7 44 24 04 7e 2c 80 	movl   $0x802c7e,0x4(%esp)
  801ea7:	00 
  801ea8:	89 1c 24             	mov    %ebx,(%esp)
  801eab:	e8 37 ea ff ff       	call   8008e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801eb0:	8b 46 04             	mov    0x4(%esi),%eax
  801eb3:	2b 06                	sub    (%esi),%eax
  801eb5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ebb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ec2:	00 00 00 
	stat->st_dev = &devpipe;
  801ec5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ecc:	30 80 00 
	return 0;
}
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	5b                   	pop    %ebx
  801ed8:	5e                   	pop    %esi
  801ed9:	5d                   	pop    %ebp
  801eda:	c3                   	ret    

00801edb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	53                   	push   %ebx
  801edf:	83 ec 14             	sub    $0x14,%esp
  801ee2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ee5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ee9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef0:	e8 07 ef ff ff       	call   800dfc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ef5:	89 1c 24             	mov    %ebx,(%esp)
  801ef8:	e8 73 f1 ff ff       	call   801070 <fd2data>
  801efd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f08:	e8 ef ee ff ff       	call   800dfc <sys_page_unmap>
}
  801f0d:	83 c4 14             	add    $0x14,%esp
  801f10:	5b                   	pop    %ebx
  801f11:	5d                   	pop    %ebp
  801f12:	c3                   	ret    

00801f13 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	57                   	push   %edi
  801f17:	56                   	push   %esi
  801f18:	53                   	push   %ebx
  801f19:	83 ec 2c             	sub    $0x2c,%esp
  801f1c:	89 c6                	mov    %eax,%esi
  801f1e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f21:	a1 08 40 80 00       	mov    0x804008,%eax
  801f26:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f29:	89 34 24             	mov    %esi,(%esp)
  801f2c:	e8 96 05 00 00       	call   8024c7 <pageref>
  801f31:	89 c7                	mov    %eax,%edi
  801f33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f36:	89 04 24             	mov    %eax,(%esp)
  801f39:	e8 89 05 00 00       	call   8024c7 <pageref>
  801f3e:	39 c7                	cmp    %eax,%edi
  801f40:	0f 94 c2             	sete   %dl
  801f43:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f46:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801f4c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f4f:	39 fb                	cmp    %edi,%ebx
  801f51:	74 21                	je     801f74 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f53:	84 d2                	test   %dl,%dl
  801f55:	74 ca                	je     801f21 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f57:	8b 51 58             	mov    0x58(%ecx),%edx
  801f5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f5e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f66:	c7 04 24 85 2c 80 00 	movl   $0x802c85,(%esp)
  801f6d:	e8 fe e2 ff ff       	call   800270 <cprintf>
  801f72:	eb ad                	jmp    801f21 <_pipeisclosed+0xe>
	}
}
  801f74:	83 c4 2c             	add    $0x2c,%esp
  801f77:	5b                   	pop    %ebx
  801f78:	5e                   	pop    %esi
  801f79:	5f                   	pop    %edi
  801f7a:	5d                   	pop    %ebp
  801f7b:	c3                   	ret    

00801f7c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	57                   	push   %edi
  801f80:	56                   	push   %esi
  801f81:	53                   	push   %ebx
  801f82:	83 ec 1c             	sub    $0x1c,%esp
  801f85:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f88:	89 34 24             	mov    %esi,(%esp)
  801f8b:	e8 e0 f0 ff ff       	call   801070 <fd2data>
  801f90:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f92:	bf 00 00 00 00       	mov    $0x0,%edi
  801f97:	eb 45                	jmp    801fde <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f99:	89 da                	mov    %ebx,%edx
  801f9b:	89 f0                	mov    %esi,%eax
  801f9d:	e8 71 ff ff ff       	call   801f13 <_pipeisclosed>
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	75 41                	jne    801fe7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801fa6:	e8 8b ed ff ff       	call   800d36 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fab:	8b 43 04             	mov    0x4(%ebx),%eax
  801fae:	8b 0b                	mov    (%ebx),%ecx
  801fb0:	8d 51 20             	lea    0x20(%ecx),%edx
  801fb3:	39 d0                	cmp    %edx,%eax
  801fb5:	73 e2                	jae    801f99 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fbe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fc1:	99                   	cltd   
  801fc2:	c1 ea 1b             	shr    $0x1b,%edx
  801fc5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801fc8:	83 e1 1f             	and    $0x1f,%ecx
  801fcb:	29 d1                	sub    %edx,%ecx
  801fcd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801fd1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801fd5:	83 c0 01             	add    $0x1,%eax
  801fd8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fdb:	83 c7 01             	add    $0x1,%edi
  801fde:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fe1:	75 c8                	jne    801fab <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801fe3:	89 f8                	mov    %edi,%eax
  801fe5:	eb 05                	jmp    801fec <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801fec:	83 c4 1c             	add    $0x1c,%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5e                   	pop    %esi
  801ff1:	5f                   	pop    %edi
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    

00801ff4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	57                   	push   %edi
  801ff8:	56                   	push   %esi
  801ff9:	53                   	push   %ebx
  801ffa:	83 ec 1c             	sub    $0x1c,%esp
  801ffd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802000:	89 3c 24             	mov    %edi,(%esp)
  802003:	e8 68 f0 ff ff       	call   801070 <fd2data>
  802008:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80200a:	be 00 00 00 00       	mov    $0x0,%esi
  80200f:	eb 3d                	jmp    80204e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802011:	85 f6                	test   %esi,%esi
  802013:	74 04                	je     802019 <devpipe_read+0x25>
				return i;
  802015:	89 f0                	mov    %esi,%eax
  802017:	eb 43                	jmp    80205c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802019:	89 da                	mov    %ebx,%edx
  80201b:	89 f8                	mov    %edi,%eax
  80201d:	e8 f1 fe ff ff       	call   801f13 <_pipeisclosed>
  802022:	85 c0                	test   %eax,%eax
  802024:	75 31                	jne    802057 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802026:	e8 0b ed ff ff       	call   800d36 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80202b:	8b 03                	mov    (%ebx),%eax
  80202d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802030:	74 df                	je     802011 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802032:	99                   	cltd   
  802033:	c1 ea 1b             	shr    $0x1b,%edx
  802036:	01 d0                	add    %edx,%eax
  802038:	83 e0 1f             	and    $0x1f,%eax
  80203b:	29 d0                	sub    %edx,%eax
  80203d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802042:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802045:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802048:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80204b:	83 c6 01             	add    $0x1,%esi
  80204e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802051:	75 d8                	jne    80202b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802053:	89 f0                	mov    %esi,%eax
  802055:	eb 05                	jmp    80205c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80205c:	83 c4 1c             	add    $0x1c,%esp
  80205f:	5b                   	pop    %ebx
  802060:	5e                   	pop    %esi
  802061:	5f                   	pop    %edi
  802062:	5d                   	pop    %ebp
  802063:	c3                   	ret    

00802064 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	56                   	push   %esi
  802068:	53                   	push   %ebx
  802069:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80206c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80206f:	89 04 24             	mov    %eax,(%esp)
  802072:	e8 10 f0 ff ff       	call   801087 <fd_alloc>
  802077:	89 c2                	mov    %eax,%edx
  802079:	85 d2                	test   %edx,%edx
  80207b:	0f 88 4d 01 00 00    	js     8021ce <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802081:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802088:	00 
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802090:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802097:	e8 b9 ec ff ff       	call   800d55 <sys_page_alloc>
  80209c:	89 c2                	mov    %eax,%edx
  80209e:	85 d2                	test   %edx,%edx
  8020a0:	0f 88 28 01 00 00    	js     8021ce <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8020a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020a9:	89 04 24             	mov    %eax,(%esp)
  8020ac:	e8 d6 ef ff ff       	call   801087 <fd_alloc>
  8020b1:	89 c3                	mov    %eax,%ebx
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	0f 88 fe 00 00 00    	js     8021b9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020bb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020c2:	00 
  8020c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d1:	e8 7f ec ff ff       	call   800d55 <sys_page_alloc>
  8020d6:	89 c3                	mov    %eax,%ebx
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	0f 88 d9 00 00 00    	js     8021b9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	89 04 24             	mov    %eax,(%esp)
  8020e6:	e8 85 ef ff ff       	call   801070 <fd2data>
  8020eb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ed:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020f4:	00 
  8020f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802100:	e8 50 ec ff ff       	call   800d55 <sys_page_alloc>
  802105:	89 c3                	mov    %eax,%ebx
  802107:	85 c0                	test   %eax,%eax
  802109:	0f 88 97 00 00 00    	js     8021a6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80210f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802112:	89 04 24             	mov    %eax,(%esp)
  802115:	e8 56 ef ff ff       	call   801070 <fd2data>
  80211a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802121:	00 
  802122:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802126:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80212d:	00 
  80212e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802132:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802139:	e8 6b ec ff ff       	call   800da9 <sys_page_map>
  80213e:	89 c3                	mov    %eax,%ebx
  802140:	85 c0                	test   %eax,%eax
  802142:	78 52                	js     802196 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802144:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802159:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80215f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802162:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802167:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	89 04 24             	mov    %eax,(%esp)
  802174:	e8 e7 ee ff ff       	call   801060 <fd2num>
  802179:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80217c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80217e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802181:	89 04 24             	mov    %eax,(%esp)
  802184:	e8 d7 ee ff ff       	call   801060 <fd2num>
  802189:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80218c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80218f:	b8 00 00 00 00       	mov    $0x0,%eax
  802194:	eb 38                	jmp    8021ce <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802196:	89 74 24 04          	mov    %esi,0x4(%esp)
  80219a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a1:	e8 56 ec ff ff       	call   800dfc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8021a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b4:	e8 43 ec ff ff       	call   800dfc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8021b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021c7:	e8 30 ec ff ff       	call   800dfc <sys_page_unmap>
  8021cc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8021ce:	83 c4 30             	add    $0x30,%esp
  8021d1:	5b                   	pop    %ebx
  8021d2:	5e                   	pop    %esi
  8021d3:	5d                   	pop    %ebp
  8021d4:	c3                   	ret    

008021d5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	89 04 24             	mov    %eax,(%esp)
  8021e8:	e8 e9 ee ff ff       	call   8010d6 <fd_lookup>
  8021ed:	89 c2                	mov    %eax,%edx
  8021ef:	85 d2                	test   %edx,%edx
  8021f1:	78 15                	js     802208 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f6:	89 04 24             	mov    %eax,(%esp)
  8021f9:	e8 72 ee ff ff       	call   801070 <fd2data>
	return _pipeisclosed(fd, p);
  8021fe:	89 c2                	mov    %eax,%edx
  802200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802203:	e8 0b fd ff ff       	call   801f13 <_pipeisclosed>
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    
  80220a:	66 90                	xchg   %ax,%ax
  80220c:	66 90                	xchg   %ax,%ax
  80220e:	66 90                	xchg   %ax,%ax

00802210 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802213:	b8 00 00 00 00       	mov    $0x0,%eax
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    

0080221a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802220:	c7 44 24 04 9d 2c 80 	movl   $0x802c9d,0x4(%esp)
  802227:	00 
  802228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222b:	89 04 24             	mov    %eax,(%esp)
  80222e:	e8 b4 e6 ff ff       	call   8008e7 <strcpy>
	return 0;
}
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	57                   	push   %edi
  80223e:	56                   	push   %esi
  80223f:	53                   	push   %ebx
  802240:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802246:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80224b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802251:	eb 31                	jmp    802284 <devcons_write+0x4a>
		m = n - tot;
  802253:	8b 75 10             	mov    0x10(%ebp),%esi
  802256:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802258:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80225b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802260:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802263:	89 74 24 08          	mov    %esi,0x8(%esp)
  802267:	03 45 0c             	add    0xc(%ebp),%eax
  80226a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80226e:	89 3c 24             	mov    %edi,(%esp)
  802271:	e8 0e e8 ff ff       	call   800a84 <memmove>
		sys_cputs(buf, m);
  802276:	89 74 24 04          	mov    %esi,0x4(%esp)
  80227a:	89 3c 24             	mov    %edi,(%esp)
  80227d:	e8 b4 e9 ff ff       	call   800c36 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802282:	01 f3                	add    %esi,%ebx
  802284:	89 d8                	mov    %ebx,%eax
  802286:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802289:	72 c8                	jb     802253 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80228b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802291:	5b                   	pop    %ebx
  802292:	5e                   	pop    %esi
  802293:	5f                   	pop    %edi
  802294:	5d                   	pop    %ebp
  802295:	c3                   	ret    

00802296 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80229c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8022a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022a5:	75 07                	jne    8022ae <devcons_read+0x18>
  8022a7:	eb 2a                	jmp    8022d3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8022a9:	e8 88 ea ff ff       	call   800d36 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8022ae:	66 90                	xchg   %ax,%ax
  8022b0:	e8 9f e9 ff ff       	call   800c54 <sys_cgetc>
  8022b5:	85 c0                	test   %eax,%eax
  8022b7:	74 f0                	je     8022a9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	78 16                	js     8022d3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8022bd:	83 f8 04             	cmp    $0x4,%eax
  8022c0:	74 0c                	je     8022ce <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8022c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c5:	88 02                	mov    %al,(%edx)
	return 1;
  8022c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cc:	eb 05                	jmp    8022d3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
  8022d8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022e8:	00 
  8022e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022ec:	89 04 24             	mov    %eax,(%esp)
  8022ef:	e8 42 e9 ff ff       	call   800c36 <sys_cputs>
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <getchar>:

int
getchar(void)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802303:	00 
  802304:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802307:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802312:	e8 53 f0 ff ff       	call   80136a <read>
	if (r < 0)
  802317:	85 c0                	test   %eax,%eax
  802319:	78 0f                	js     80232a <getchar+0x34>
		return r;
	if (r < 1)
  80231b:	85 c0                	test   %eax,%eax
  80231d:	7e 06                	jle    802325 <getchar+0x2f>
		return -E_EOF;
	return c;
  80231f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802323:	eb 05                	jmp    80232a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802325:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802332:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802335:	89 44 24 04          	mov    %eax,0x4(%esp)
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	89 04 24             	mov    %eax,(%esp)
  80233f:	e8 92 ed ff ff       	call   8010d6 <fd_lookup>
  802344:	85 c0                	test   %eax,%eax
  802346:	78 11                	js     802359 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802351:	39 10                	cmp    %edx,(%eax)
  802353:	0f 94 c0             	sete   %al
  802356:	0f b6 c0             	movzbl %al,%eax
}
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <opencons>:

int
opencons(void)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802361:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802364:	89 04 24             	mov    %eax,(%esp)
  802367:	e8 1b ed ff ff       	call   801087 <fd_alloc>
		return r;
  80236c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80236e:	85 c0                	test   %eax,%eax
  802370:	78 40                	js     8023b2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802372:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802379:	00 
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802381:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802388:	e8 c8 e9 ff ff       	call   800d55 <sys_page_alloc>
		return r;
  80238d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80238f:	85 c0                	test   %eax,%eax
  802391:	78 1f                	js     8023b2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802393:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023a8:	89 04 24             	mov    %eax,(%esp)
  8023ab:	e8 b0 ec ff ff       	call   801060 <fd2num>
  8023b0:	89 c2                	mov    %eax,%edx
}
  8023b2:	89 d0                	mov    %edx,%eax
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    
  8023b6:	66 90                	xchg   %ax,%ax
  8023b8:	66 90                	xchg   %ax,%ax
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	56                   	push   %esi
  8023c4:	53                   	push   %ebx
  8023c5:	83 ec 10             	sub    $0x10,%esp
  8023c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8023cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8023d1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8023d3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8023d8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8023db:	89 04 24             	mov    %eax,(%esp)
  8023de:	e8 a8 eb ff ff       	call   800f8b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8023e3:	85 c0                	test   %eax,%eax
  8023e5:	75 26                	jne    80240d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8023e7:	85 f6                	test   %esi,%esi
  8023e9:	74 0a                	je     8023f5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8023eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8023f0:	8b 40 74             	mov    0x74(%eax),%eax
  8023f3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  8023f5:	85 db                	test   %ebx,%ebx
  8023f7:	74 0a                	je     802403 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  8023f9:	a1 08 40 80 00       	mov    0x804008,%eax
  8023fe:	8b 40 78             	mov    0x78(%eax),%eax
  802401:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802403:	a1 08 40 80 00       	mov    0x804008,%eax
  802408:	8b 40 70             	mov    0x70(%eax),%eax
  80240b:	eb 14                	jmp    802421 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80240d:	85 f6                	test   %esi,%esi
  80240f:	74 06                	je     802417 <ipc_recv+0x57>
			*from_env_store = 0;
  802411:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802417:	85 db                	test   %ebx,%ebx
  802419:	74 06                	je     802421 <ipc_recv+0x61>
			*perm_store = 0;
  80241b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802421:	83 c4 10             	add    $0x10,%esp
  802424:	5b                   	pop    %ebx
  802425:	5e                   	pop    %esi
  802426:	5d                   	pop    %ebp
  802427:	c3                   	ret    

00802428 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	57                   	push   %edi
  80242c:	56                   	push   %esi
  80242d:	53                   	push   %ebx
  80242e:	83 ec 1c             	sub    $0x1c,%esp
  802431:	8b 7d 08             	mov    0x8(%ebp),%edi
  802434:	8b 75 0c             	mov    0xc(%ebp),%esi
  802437:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80243a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80243c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802441:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802444:	8b 45 14             	mov    0x14(%ebp),%eax
  802447:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80244b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80244f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802453:	89 3c 24             	mov    %edi,(%esp)
  802456:	e8 0d eb ff ff       	call   800f68 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80245b:	85 c0                	test   %eax,%eax
  80245d:	74 28                	je     802487 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80245f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802462:	74 1c                	je     802480 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802464:	c7 44 24 08 ac 2c 80 	movl   $0x802cac,0x8(%esp)
  80246b:	00 
  80246c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802473:	00 
  802474:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  80247b:	e8 f7 dc ff ff       	call   800177 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802480:	e8 b1 e8 ff ff       	call   800d36 <sys_yield>
	}
  802485:	eb bd                	jmp    802444 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802487:	83 c4 1c             	add    $0x1c,%esp
  80248a:	5b                   	pop    %ebx
  80248b:	5e                   	pop    %esi
  80248c:	5f                   	pop    %edi
  80248d:	5d                   	pop    %ebp
  80248e:	c3                   	ret    

0080248f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80249a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80249d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024a3:	8b 52 50             	mov    0x50(%edx),%edx
  8024a6:	39 ca                	cmp    %ecx,%edx
  8024a8:	75 0d                	jne    8024b7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8024aa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024ad:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8024b2:	8b 40 40             	mov    0x40(%eax),%eax
  8024b5:	eb 0e                	jmp    8024c5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024b7:	83 c0 01             	add    $0x1,%eax
  8024ba:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024bf:	75 d9                	jne    80249a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024c1:	66 b8 00 00          	mov    $0x0,%ax
}
  8024c5:	5d                   	pop    %ebp
  8024c6:	c3                   	ret    

008024c7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024cd:	89 d0                	mov    %edx,%eax
  8024cf:	c1 e8 16             	shr    $0x16,%eax
  8024d2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024d9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024de:	f6 c1 01             	test   $0x1,%cl
  8024e1:	74 1d                	je     802500 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024e3:	c1 ea 0c             	shr    $0xc,%edx
  8024e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024ed:	f6 c2 01             	test   $0x1,%dl
  8024f0:	74 0e                	je     802500 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024f2:	c1 ea 0c             	shr    $0xc,%edx
  8024f5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024fc:	ef 
  8024fd:	0f b7 c0             	movzwl %ax,%eax
}
  802500:	5d                   	pop    %ebp
  802501:	c3                   	ret    
  802502:	66 90                	xchg   %ax,%ax
  802504:	66 90                	xchg   %ax,%ax
  802506:	66 90                	xchg   %ax,%ax
  802508:	66 90                	xchg   %ax,%ax
  80250a:	66 90                	xchg   %ax,%ax
  80250c:	66 90                	xchg   %ax,%ax
  80250e:	66 90                	xchg   %ax,%ax

00802510 <__udivdi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	83 ec 0c             	sub    $0xc,%esp
  802516:	8b 44 24 28          	mov    0x28(%esp),%eax
  80251a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80251e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802522:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802526:	85 c0                	test   %eax,%eax
  802528:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80252c:	89 ea                	mov    %ebp,%edx
  80252e:	89 0c 24             	mov    %ecx,(%esp)
  802531:	75 2d                	jne    802560 <__udivdi3+0x50>
  802533:	39 e9                	cmp    %ebp,%ecx
  802535:	77 61                	ja     802598 <__udivdi3+0x88>
  802537:	85 c9                	test   %ecx,%ecx
  802539:	89 ce                	mov    %ecx,%esi
  80253b:	75 0b                	jne    802548 <__udivdi3+0x38>
  80253d:	b8 01 00 00 00       	mov    $0x1,%eax
  802542:	31 d2                	xor    %edx,%edx
  802544:	f7 f1                	div    %ecx
  802546:	89 c6                	mov    %eax,%esi
  802548:	31 d2                	xor    %edx,%edx
  80254a:	89 e8                	mov    %ebp,%eax
  80254c:	f7 f6                	div    %esi
  80254e:	89 c5                	mov    %eax,%ebp
  802550:	89 f8                	mov    %edi,%eax
  802552:	f7 f6                	div    %esi
  802554:	89 ea                	mov    %ebp,%edx
  802556:	83 c4 0c             	add    $0xc,%esp
  802559:	5e                   	pop    %esi
  80255a:	5f                   	pop    %edi
  80255b:	5d                   	pop    %ebp
  80255c:	c3                   	ret    
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	39 e8                	cmp    %ebp,%eax
  802562:	77 24                	ja     802588 <__udivdi3+0x78>
  802564:	0f bd e8             	bsr    %eax,%ebp
  802567:	83 f5 1f             	xor    $0x1f,%ebp
  80256a:	75 3c                	jne    8025a8 <__udivdi3+0x98>
  80256c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802570:	39 34 24             	cmp    %esi,(%esp)
  802573:	0f 86 9f 00 00 00    	jbe    802618 <__udivdi3+0x108>
  802579:	39 d0                	cmp    %edx,%eax
  80257b:	0f 82 97 00 00 00    	jb     802618 <__udivdi3+0x108>
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	31 d2                	xor    %edx,%edx
  80258a:	31 c0                	xor    %eax,%eax
  80258c:	83 c4 0c             	add    $0xc,%esp
  80258f:	5e                   	pop    %esi
  802590:	5f                   	pop    %edi
  802591:	5d                   	pop    %ebp
  802592:	c3                   	ret    
  802593:	90                   	nop
  802594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802598:	89 f8                	mov    %edi,%eax
  80259a:	f7 f1                	div    %ecx
  80259c:	31 d2                	xor    %edx,%edx
  80259e:	83 c4 0c             	add    $0xc,%esp
  8025a1:	5e                   	pop    %esi
  8025a2:	5f                   	pop    %edi
  8025a3:	5d                   	pop    %ebp
  8025a4:	c3                   	ret    
  8025a5:	8d 76 00             	lea    0x0(%esi),%esi
  8025a8:	89 e9                	mov    %ebp,%ecx
  8025aa:	8b 3c 24             	mov    (%esp),%edi
  8025ad:	d3 e0                	shl    %cl,%eax
  8025af:	89 c6                	mov    %eax,%esi
  8025b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8025b6:	29 e8                	sub    %ebp,%eax
  8025b8:	89 c1                	mov    %eax,%ecx
  8025ba:	d3 ef                	shr    %cl,%edi
  8025bc:	89 e9                	mov    %ebp,%ecx
  8025be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025c2:	8b 3c 24             	mov    (%esp),%edi
  8025c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8025c9:	89 d6                	mov    %edx,%esi
  8025cb:	d3 e7                	shl    %cl,%edi
  8025cd:	89 c1                	mov    %eax,%ecx
  8025cf:	89 3c 24             	mov    %edi,(%esp)
  8025d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025d6:	d3 ee                	shr    %cl,%esi
  8025d8:	89 e9                	mov    %ebp,%ecx
  8025da:	d3 e2                	shl    %cl,%edx
  8025dc:	89 c1                	mov    %eax,%ecx
  8025de:	d3 ef                	shr    %cl,%edi
  8025e0:	09 d7                	or     %edx,%edi
  8025e2:	89 f2                	mov    %esi,%edx
  8025e4:	89 f8                	mov    %edi,%eax
  8025e6:	f7 74 24 08          	divl   0x8(%esp)
  8025ea:	89 d6                	mov    %edx,%esi
  8025ec:	89 c7                	mov    %eax,%edi
  8025ee:	f7 24 24             	mull   (%esp)
  8025f1:	39 d6                	cmp    %edx,%esi
  8025f3:	89 14 24             	mov    %edx,(%esp)
  8025f6:	72 30                	jb     802628 <__udivdi3+0x118>
  8025f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025fc:	89 e9                	mov    %ebp,%ecx
  8025fe:	d3 e2                	shl    %cl,%edx
  802600:	39 c2                	cmp    %eax,%edx
  802602:	73 05                	jae    802609 <__udivdi3+0xf9>
  802604:	3b 34 24             	cmp    (%esp),%esi
  802607:	74 1f                	je     802628 <__udivdi3+0x118>
  802609:	89 f8                	mov    %edi,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	e9 7a ff ff ff       	jmp    80258c <__udivdi3+0x7c>
  802612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802618:	31 d2                	xor    %edx,%edx
  80261a:	b8 01 00 00 00       	mov    $0x1,%eax
  80261f:	e9 68 ff ff ff       	jmp    80258c <__udivdi3+0x7c>
  802624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802628:	8d 47 ff             	lea    -0x1(%edi),%eax
  80262b:	31 d2                	xor    %edx,%edx
  80262d:	83 c4 0c             	add    $0xc,%esp
  802630:	5e                   	pop    %esi
  802631:	5f                   	pop    %edi
  802632:	5d                   	pop    %ebp
  802633:	c3                   	ret    
  802634:	66 90                	xchg   %ax,%ax
  802636:	66 90                	xchg   %ax,%ax
  802638:	66 90                	xchg   %ax,%ax
  80263a:	66 90                	xchg   %ax,%ax
  80263c:	66 90                	xchg   %ax,%ax
  80263e:	66 90                	xchg   %ax,%ax

00802640 <__umoddi3>:
  802640:	55                   	push   %ebp
  802641:	57                   	push   %edi
  802642:	56                   	push   %esi
  802643:	83 ec 14             	sub    $0x14,%esp
  802646:	8b 44 24 28          	mov    0x28(%esp),%eax
  80264a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80264e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802652:	89 c7                	mov    %eax,%edi
  802654:	89 44 24 04          	mov    %eax,0x4(%esp)
  802658:	8b 44 24 30          	mov    0x30(%esp),%eax
  80265c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802660:	89 34 24             	mov    %esi,(%esp)
  802663:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802667:	85 c0                	test   %eax,%eax
  802669:	89 c2                	mov    %eax,%edx
  80266b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80266f:	75 17                	jne    802688 <__umoddi3+0x48>
  802671:	39 fe                	cmp    %edi,%esi
  802673:	76 4b                	jbe    8026c0 <__umoddi3+0x80>
  802675:	89 c8                	mov    %ecx,%eax
  802677:	89 fa                	mov    %edi,%edx
  802679:	f7 f6                	div    %esi
  80267b:	89 d0                	mov    %edx,%eax
  80267d:	31 d2                	xor    %edx,%edx
  80267f:	83 c4 14             	add    $0x14,%esp
  802682:	5e                   	pop    %esi
  802683:	5f                   	pop    %edi
  802684:	5d                   	pop    %ebp
  802685:	c3                   	ret    
  802686:	66 90                	xchg   %ax,%ax
  802688:	39 f8                	cmp    %edi,%eax
  80268a:	77 54                	ja     8026e0 <__umoddi3+0xa0>
  80268c:	0f bd e8             	bsr    %eax,%ebp
  80268f:	83 f5 1f             	xor    $0x1f,%ebp
  802692:	75 5c                	jne    8026f0 <__umoddi3+0xb0>
  802694:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802698:	39 3c 24             	cmp    %edi,(%esp)
  80269b:	0f 87 e7 00 00 00    	ja     802788 <__umoddi3+0x148>
  8026a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026a5:	29 f1                	sub    %esi,%ecx
  8026a7:	19 c7                	sbb    %eax,%edi
  8026a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026b5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8026b9:	83 c4 14             	add    $0x14,%esp
  8026bc:	5e                   	pop    %esi
  8026bd:	5f                   	pop    %edi
  8026be:	5d                   	pop    %ebp
  8026bf:	c3                   	ret    
  8026c0:	85 f6                	test   %esi,%esi
  8026c2:	89 f5                	mov    %esi,%ebp
  8026c4:	75 0b                	jne    8026d1 <__umoddi3+0x91>
  8026c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026cb:	31 d2                	xor    %edx,%edx
  8026cd:	f7 f6                	div    %esi
  8026cf:	89 c5                	mov    %eax,%ebp
  8026d1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026d5:	31 d2                	xor    %edx,%edx
  8026d7:	f7 f5                	div    %ebp
  8026d9:	89 c8                	mov    %ecx,%eax
  8026db:	f7 f5                	div    %ebp
  8026dd:	eb 9c                	jmp    80267b <__umoddi3+0x3b>
  8026df:	90                   	nop
  8026e0:	89 c8                	mov    %ecx,%eax
  8026e2:	89 fa                	mov    %edi,%edx
  8026e4:	83 c4 14             	add    $0x14,%esp
  8026e7:	5e                   	pop    %esi
  8026e8:	5f                   	pop    %edi
  8026e9:	5d                   	pop    %ebp
  8026ea:	c3                   	ret    
  8026eb:	90                   	nop
  8026ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026f0:	8b 04 24             	mov    (%esp),%eax
  8026f3:	be 20 00 00 00       	mov    $0x20,%esi
  8026f8:	89 e9                	mov    %ebp,%ecx
  8026fa:	29 ee                	sub    %ebp,%esi
  8026fc:	d3 e2                	shl    %cl,%edx
  8026fe:	89 f1                	mov    %esi,%ecx
  802700:	d3 e8                	shr    %cl,%eax
  802702:	89 e9                	mov    %ebp,%ecx
  802704:	89 44 24 04          	mov    %eax,0x4(%esp)
  802708:	8b 04 24             	mov    (%esp),%eax
  80270b:	09 54 24 04          	or     %edx,0x4(%esp)
  80270f:	89 fa                	mov    %edi,%edx
  802711:	d3 e0                	shl    %cl,%eax
  802713:	89 f1                	mov    %esi,%ecx
  802715:	89 44 24 08          	mov    %eax,0x8(%esp)
  802719:	8b 44 24 10          	mov    0x10(%esp),%eax
  80271d:	d3 ea                	shr    %cl,%edx
  80271f:	89 e9                	mov    %ebp,%ecx
  802721:	d3 e7                	shl    %cl,%edi
  802723:	89 f1                	mov    %esi,%ecx
  802725:	d3 e8                	shr    %cl,%eax
  802727:	89 e9                	mov    %ebp,%ecx
  802729:	09 f8                	or     %edi,%eax
  80272b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80272f:	f7 74 24 04          	divl   0x4(%esp)
  802733:	d3 e7                	shl    %cl,%edi
  802735:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802739:	89 d7                	mov    %edx,%edi
  80273b:	f7 64 24 08          	mull   0x8(%esp)
  80273f:	39 d7                	cmp    %edx,%edi
  802741:	89 c1                	mov    %eax,%ecx
  802743:	89 14 24             	mov    %edx,(%esp)
  802746:	72 2c                	jb     802774 <__umoddi3+0x134>
  802748:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80274c:	72 22                	jb     802770 <__umoddi3+0x130>
  80274e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802752:	29 c8                	sub    %ecx,%eax
  802754:	19 d7                	sbb    %edx,%edi
  802756:	89 e9                	mov    %ebp,%ecx
  802758:	89 fa                	mov    %edi,%edx
  80275a:	d3 e8                	shr    %cl,%eax
  80275c:	89 f1                	mov    %esi,%ecx
  80275e:	d3 e2                	shl    %cl,%edx
  802760:	89 e9                	mov    %ebp,%ecx
  802762:	d3 ef                	shr    %cl,%edi
  802764:	09 d0                	or     %edx,%eax
  802766:	89 fa                	mov    %edi,%edx
  802768:	83 c4 14             	add    $0x14,%esp
  80276b:	5e                   	pop    %esi
  80276c:	5f                   	pop    %edi
  80276d:	5d                   	pop    %ebp
  80276e:	c3                   	ret    
  80276f:	90                   	nop
  802770:	39 d7                	cmp    %edx,%edi
  802772:	75 da                	jne    80274e <__umoddi3+0x10e>
  802774:	8b 14 24             	mov    (%esp),%edx
  802777:	89 c1                	mov    %eax,%ecx
  802779:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80277d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802781:	eb cb                	jmp    80274e <__umoddi3+0x10e>
  802783:	90                   	nop
  802784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802788:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80278c:	0f 82 0f ff ff ff    	jb     8026a1 <__umoddi3+0x61>
  802792:	e9 1a ff ff ff       	jmp    8026b1 <__umoddi3+0x71>
