
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 16 01 00 00       	call   800147 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 3c             	sub    $0x3c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 0d 14 00 00       	call   80144e <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	74 5e                	je     8000a6 <umain+0x73>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  800048:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  80004e:	e8 a4 0c 00 00       	call   800cf7 <sys_getenvid>
  800053:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800057:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005b:	c7 04 24 40 2e 80 00 	movl   $0x802e40,(%esp)
  800062:	e8 e4 01 00 00       	call   80024b <cprintf>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800067:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80006a:	e8 88 0c 00 00       	call   800cf7 <sys_getenvid>
  80006f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800073:	89 44 24 04          	mov    %eax,0x4(%esp)
  800077:	c7 04 24 5a 2e 80 00 	movl   $0x802e5a,(%esp)
  80007e:	e8 c8 01 00 00       	call   80024b <cprintf>
		ipc_send(who, 0, 0, 0);
  800083:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80008a:	00 
  80008b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800092:	00 
  800093:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80009a:	00 
  80009b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80009e:	89 04 24             	mov    %eax,(%esp)
  8000a1:	e8 b2 15 00 00       	call   801658 <ipc_send>
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  8000a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b5:	00 
  8000b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8000b9:	89 04 24             	mov    %eax,(%esp)
  8000bc:	e8 2f 15 00 00       	call   8015f0 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  8000c1:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  8000c7:	8b 7b 48             	mov    0x48(%ebx),%edi
  8000ca:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8000cd:	a1 08 50 80 00       	mov    0x805008,%eax
  8000d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000d5:	e8 1d 0c 00 00       	call   800cf7 <sys_getenvid>
  8000da:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8000de:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8000e2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8000e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000f1:	c7 04 24 70 2e 80 00 	movl   $0x802e70,(%esp)
  8000f8:	e8 4e 01 00 00       	call   80024b <cprintf>
		if (val == 10)
  8000fd:	a1 08 50 80 00       	mov    0x805008,%eax
  800102:	83 f8 0a             	cmp    $0xa,%eax
  800105:	74 38                	je     80013f <umain+0x10c>
			return;
		++val;
  800107:	83 c0 01             	add    $0x1,%eax
  80010a:	a3 08 50 80 00       	mov    %eax,0x805008
		ipc_send(who, 0, 0, 0);
  80010f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800116:	00 
  800117:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800126:	00 
  800127:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012a:	89 04 24             	mov    %eax,(%esp)
  80012d:	e8 26 15 00 00       	call   801658 <ipc_send>
		if (val == 10)
  800132:	83 3d 08 50 80 00 0a 	cmpl   $0xa,0x805008
  800139:	0f 85 67 ff ff ff    	jne    8000a6 <umain+0x73>
			return;
	}

}
  80013f:	83 c4 3c             	add    $0x3c,%esp
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5f                   	pop    %edi
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    

00800147 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	56                   	push   %esi
  80014b:	53                   	push   %ebx
  80014c:	83 ec 10             	sub    $0x10,%esp
  80014f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800152:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800155:	e8 9d 0b 00 00       	call   800cf7 <sys_getenvid>
  80015a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80015f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800162:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800167:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016c:	85 db                	test   %ebx,%ebx
  80016e:	7e 07                	jle    800177 <libmain+0x30>
		binaryname = argv[0];
  800170:	8b 06                	mov    (%esi),%eax
  800172:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800177:	89 74 24 04          	mov    %esi,0x4(%esp)
  80017b:	89 1c 24             	mov    %ebx,(%esp)
  80017e:	e8 b0 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800183:	e8 07 00 00 00       	call   80018f <exit>
}
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	5b                   	pop    %ebx
  80018c:	5e                   	pop    %esi
  80018d:	5d                   	pop    %ebp
  80018e:	c3                   	ret    

0080018f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800195:	e8 40 17 00 00       	call   8018da <close_all>
	sys_env_destroy(0);
  80019a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a1:	e8 ad 0a 00 00       	call   800c53 <sys_env_destroy>
}
  8001a6:	c9                   	leave  
  8001a7:	c3                   	ret    

008001a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 14             	sub    $0x14,%esp
  8001af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b2:	8b 13                	mov    (%ebx),%edx
  8001b4:	8d 42 01             	lea    0x1(%edx),%eax
  8001b7:	89 03                	mov    %eax,(%ebx)
  8001b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001bc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c5:	75 19                	jne    8001e0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001c7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001ce:	00 
  8001cf:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d2:	89 04 24             	mov    %eax,(%esp)
  8001d5:	e8 3c 0a 00 00       	call   800c16 <sys_cputs>
		b->idx = 0;
  8001da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001e0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001e4:	83 c4 14             	add    $0x14,%esp
  8001e7:	5b                   	pop    %ebx
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fa:	00 00 00 
	b.cnt = 0;
  8001fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800204:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80020e:	8b 45 08             	mov    0x8(%ebp),%eax
  800211:	89 44 24 08          	mov    %eax,0x8(%esp)
  800215:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021f:	c7 04 24 a8 01 80 00 	movl   $0x8001a8,(%esp)
  800226:	e8 79 01 00 00       	call   8003a4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80022b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800231:	89 44 24 04          	mov    %eax,0x4(%esp)
  800235:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023b:	89 04 24             	mov    %eax,(%esp)
  80023e:	e8 d3 09 00 00       	call   800c16 <sys_cputs>

	return b.cnt;
}
  800243:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800251:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800254:	89 44 24 04          	mov    %eax,0x4(%esp)
  800258:	8b 45 08             	mov    0x8(%ebp),%eax
  80025b:	89 04 24             	mov    %eax,(%esp)
  80025e:	e8 87 ff ff ff       	call   8001ea <vcprintf>
	va_end(ap);

	return cnt;
}
  800263:	c9                   	leave  
  800264:	c3                   	ret    
  800265:	66 90                	xchg   %ax,%ax
  800267:	66 90                	xchg   %ax,%ax
  800269:	66 90                	xchg   %ax,%ax
  80026b:	66 90                	xchg   %ax,%ax
  80026d:	66 90                	xchg   %ax,%ax
  80026f:	90                   	nop

00800270 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	57                   	push   %edi
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
  800276:	83 ec 3c             	sub    $0x3c,%esp
  800279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027c:	89 d7                	mov    %edx,%edi
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	89 c3                	mov    %eax,%ebx
  800289:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80028c:	8b 45 10             	mov    0x10(%ebp),%eax
  80028f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800292:	b9 00 00 00 00       	mov    $0x0,%ecx
  800297:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80029d:	39 d9                	cmp    %ebx,%ecx
  80029f:	72 05                	jb     8002a6 <printnum+0x36>
  8002a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a4:	77 69                	ja     80030f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002ad:	83 ee 01             	sub    $0x1,%esi
  8002b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002c0:	89 c3                	mov    %eax,%ebx
  8002c2:	89 d6                	mov    %edx,%esi
  8002c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002df:	e8 bc 28 00 00       	call   802ba0 <__udivdi3>
  8002e4:	89 d9                	mov    %ebx,%ecx
  8002e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002f5:	89 fa                	mov    %edi,%edx
  8002f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002fa:	e8 71 ff ff ff       	call   800270 <printnum>
  8002ff:	eb 1b                	jmp    80031c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800301:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800305:	8b 45 18             	mov    0x18(%ebp),%eax
  800308:	89 04 24             	mov    %eax,(%esp)
  80030b:	ff d3                	call   *%ebx
  80030d:	eb 03                	jmp    800312 <printnum+0xa2>
  80030f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800312:	83 ee 01             	sub    $0x1,%esi
  800315:	85 f6                	test   %esi,%esi
  800317:	7f e8                	jg     800301 <printnum+0x91>
  800319:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800320:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800324:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800327:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80032a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80032e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033f:	e8 8c 29 00 00       	call   802cd0 <__umoddi3>
  800344:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800348:	0f be 80 a0 2e 80 00 	movsbl 0x802ea0(%eax),%eax
  80034f:	89 04 24             	mov    %eax,(%esp)
  800352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800355:	ff d0                	call   *%eax
}
  800357:	83 c4 3c             	add    $0x3c,%esp
  80035a:	5b                   	pop    %ebx
  80035b:	5e                   	pop    %esi
  80035c:	5f                   	pop    %edi
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800365:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800369:	8b 10                	mov    (%eax),%edx
  80036b:	3b 50 04             	cmp    0x4(%eax),%edx
  80036e:	73 0a                	jae    80037a <sprintputch+0x1b>
		*b->buf++ = ch;
  800370:	8d 4a 01             	lea    0x1(%edx),%ecx
  800373:	89 08                	mov    %ecx,(%eax)
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	88 02                	mov    %al,(%edx)
}
  80037a:	5d                   	pop    %ebp
  80037b:	c3                   	ret    

0080037c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800382:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800385:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800389:	8b 45 10             	mov    0x10(%ebp),%eax
  80038c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800390:	8b 45 0c             	mov    0xc(%ebp),%eax
  800393:	89 44 24 04          	mov    %eax,0x4(%esp)
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	89 04 24             	mov    %eax,(%esp)
  80039d:	e8 02 00 00 00       	call   8003a4 <vprintfmt>
	va_end(ap);
}
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	57                   	push   %edi
  8003a8:	56                   	push   %esi
  8003a9:	53                   	push   %ebx
  8003aa:	83 ec 3c             	sub    $0x3c,%esp
  8003ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003b0:	eb 17                	jmp    8003c9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	0f 84 4b 04 00 00    	je     800805 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8003ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003bd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003c1:	89 04 24             	mov    %eax,(%esp)
  8003c4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8003c7:	89 fb                	mov    %edi,%ebx
  8003c9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8003cc:	0f b6 03             	movzbl (%ebx),%eax
  8003cf:	83 f8 25             	cmp    $0x25,%eax
  8003d2:	75 de                	jne    8003b2 <vprintfmt+0xe>
  8003d4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8003d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003df:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8003e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f0:	eb 18                	jmp    80040a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003f4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8003f8:	eb 10                	jmp    80040a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003fc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800400:	eb 08                	jmp    80040a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800402:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800405:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80040d:	0f b6 17             	movzbl (%edi),%edx
  800410:	0f b6 c2             	movzbl %dl,%eax
  800413:	83 ea 23             	sub    $0x23,%edx
  800416:	80 fa 55             	cmp    $0x55,%dl
  800419:	0f 87 c2 03 00 00    	ja     8007e1 <vprintfmt+0x43d>
  80041f:	0f b6 d2             	movzbl %dl,%edx
  800422:	ff 24 95 e0 2f 80 00 	jmp    *0x802fe0(,%edx,4)
  800429:	89 df                	mov    %ebx,%edi
  80042b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800430:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800433:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800437:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80043a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80043d:	83 fa 09             	cmp    $0x9,%edx
  800440:	77 33                	ja     800475 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800442:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800445:	eb e9                	jmp    800430 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8b 30                	mov    (%eax),%esi
  80044c:	8d 40 04             	lea    0x4(%eax),%eax
  80044f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800452:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800454:	eb 1f                	jmp    800475 <vprintfmt+0xd1>
  800456:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800459:	85 ff                	test   %edi,%edi
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
  800460:	0f 49 c7             	cmovns %edi,%eax
  800463:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800466:	89 df                	mov    %ebx,%edi
  800468:	eb a0                	jmp    80040a <vprintfmt+0x66>
  80046a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80046c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800473:	eb 95                	jmp    80040a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800475:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800479:	79 8f                	jns    80040a <vprintfmt+0x66>
  80047b:	eb 85                	jmp    800402 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80047d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800480:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800482:	eb 86                	jmp    80040a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	8d 70 04             	lea    0x4(%eax),%esi
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	89 04 24             	mov    %eax,(%esp)
  800499:	ff 55 08             	call   *0x8(%ebp)
  80049c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80049f:	e9 25 ff ff ff       	jmp    8003c9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 70 04             	lea    0x4(%eax),%esi
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	99                   	cltd   
  8004ad:	31 d0                	xor    %edx,%eax
  8004af:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004b1:	83 f8 15             	cmp    $0x15,%eax
  8004b4:	7f 0b                	jg     8004c1 <vprintfmt+0x11d>
  8004b6:	8b 14 85 40 31 80 00 	mov    0x803140(,%eax,4),%edx
  8004bd:	85 d2                	test   %edx,%edx
  8004bf:	75 26                	jne    8004e7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8004c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004c5:	c7 44 24 08 b8 2e 80 	movl   $0x802eb8,0x8(%esp)
  8004cc:	00 
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	89 04 24             	mov    %eax,(%esp)
  8004da:	e8 9d fe ff ff       	call   80037c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004df:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004e2:	e9 e2 fe ff ff       	jmp    8003c9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004e7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004eb:	c7 44 24 08 86 33 80 	movl   $0x803386,0x8(%esp)
  8004f2:	00 
  8004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	89 04 24             	mov    %eax,(%esp)
  800500:	e8 77 fe ff ff       	call   80037c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800505:	89 75 14             	mov    %esi,0x14(%ebp)
  800508:	e9 bc fe ff ff       	jmp    8003c9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800513:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800516:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80051a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80051c:	85 ff                	test   %edi,%edi
  80051e:	b8 b1 2e 80 00       	mov    $0x802eb1,%eax
  800523:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800526:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80052a:	0f 84 94 00 00 00    	je     8005c4 <vprintfmt+0x220>
  800530:	85 c9                	test   %ecx,%ecx
  800532:	0f 8e 94 00 00 00    	jle    8005cc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800538:	89 74 24 04          	mov    %esi,0x4(%esp)
  80053c:	89 3c 24             	mov    %edi,(%esp)
  80053f:	e8 64 03 00 00       	call   8008a8 <strnlen>
  800544:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800547:	29 c1                	sub    %eax,%ecx
  800549:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80054c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800550:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800553:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800556:	8b 75 08             	mov    0x8(%ebp),%esi
  800559:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80055c:	89 cb                	mov    %ecx,%ebx
  80055e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800560:	eb 0f                	jmp    800571 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800562:	8b 45 0c             	mov    0xc(%ebp),%eax
  800565:	89 44 24 04          	mov    %eax,0x4(%esp)
  800569:	89 3c 24             	mov    %edi,(%esp)
  80056c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80056e:	83 eb 01             	sub    $0x1,%ebx
  800571:	85 db                	test   %ebx,%ebx
  800573:	7f ed                	jg     800562 <vprintfmt+0x1be>
  800575:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800578:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80057b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80057e:	85 c9                	test   %ecx,%ecx
  800580:	b8 00 00 00 00       	mov    $0x0,%eax
  800585:	0f 49 c1             	cmovns %ecx,%eax
  800588:	29 c1                	sub    %eax,%ecx
  80058a:	89 cb                	mov    %ecx,%ebx
  80058c:	eb 44                	jmp    8005d2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80058e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800592:	74 1e                	je     8005b2 <vprintfmt+0x20e>
  800594:	0f be d2             	movsbl %dl,%edx
  800597:	83 ea 20             	sub    $0x20,%edx
  80059a:	83 fa 5e             	cmp    $0x5e,%edx
  80059d:	76 13                	jbe    8005b2 <vprintfmt+0x20e>
					putch('?', putdat);
  80059f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005ad:	ff 55 08             	call   *0x8(%ebp)
  8005b0:	eb 0d                	jmp    8005bf <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8005b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005b9:	89 04 24             	mov    %eax,(%esp)
  8005bc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005bf:	83 eb 01             	sub    $0x1,%ebx
  8005c2:	eb 0e                	jmp    8005d2 <vprintfmt+0x22e>
  8005c4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005ca:	eb 06                	jmp    8005d2 <vprintfmt+0x22e>
  8005cc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005cf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005d2:	83 c7 01             	add    $0x1,%edi
  8005d5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005d9:	0f be c2             	movsbl %dl,%eax
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	74 27                	je     800607 <vprintfmt+0x263>
  8005e0:	85 f6                	test   %esi,%esi
  8005e2:	78 aa                	js     80058e <vprintfmt+0x1ea>
  8005e4:	83 ee 01             	sub    $0x1,%esi
  8005e7:	79 a5                	jns    80058e <vprintfmt+0x1ea>
  8005e9:	89 d8                	mov    %ebx,%eax
  8005eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ee:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005f1:	89 c3                	mov    %eax,%ebx
  8005f3:	eb 18                	jmp    80060d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005f9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800600:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800602:	83 eb 01             	sub    $0x1,%ebx
  800605:	eb 06                	jmp    80060d <vprintfmt+0x269>
  800607:	8b 75 08             	mov    0x8(%ebp),%esi
  80060a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80060d:	85 db                	test   %ebx,%ebx
  80060f:	7f e4                	jg     8005f5 <vprintfmt+0x251>
  800611:	89 75 08             	mov    %esi,0x8(%ebp)
  800614:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800617:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80061a:	e9 aa fd ff ff       	jmp    8003c9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80061f:	83 f9 01             	cmp    $0x1,%ecx
  800622:	7e 10                	jle    800634 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8b 30                	mov    (%eax),%esi
  800629:	8b 78 04             	mov    0x4(%eax),%edi
  80062c:	8d 40 08             	lea    0x8(%eax),%eax
  80062f:	89 45 14             	mov    %eax,0x14(%ebp)
  800632:	eb 26                	jmp    80065a <vprintfmt+0x2b6>
	else if (lflag)
  800634:	85 c9                	test   %ecx,%ecx
  800636:	74 12                	je     80064a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 30                	mov    (%eax),%esi
  80063d:	89 f7                	mov    %esi,%edi
  80063f:	c1 ff 1f             	sar    $0x1f,%edi
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
  800648:	eb 10                	jmp    80065a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8b 30                	mov    (%eax),%esi
  80064f:	89 f7                	mov    %esi,%edi
  800651:	c1 ff 1f             	sar    $0x1f,%edi
  800654:	8d 40 04             	lea    0x4(%eax),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80065a:	89 f0                	mov    %esi,%eax
  80065c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80065e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800663:	85 ff                	test   %edi,%edi
  800665:	0f 89 3a 01 00 00    	jns    8007a5 <vprintfmt+0x401>
				putch('-', putdat);
  80066b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800672:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800679:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80067c:	89 f0                	mov    %esi,%eax
  80067e:	89 fa                	mov    %edi,%edx
  800680:	f7 d8                	neg    %eax
  800682:	83 d2 00             	adc    $0x0,%edx
  800685:	f7 da                	neg    %edx
			}
			base = 10;
  800687:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80068c:	e9 14 01 00 00       	jmp    8007a5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800691:	83 f9 01             	cmp    $0x1,%ecx
  800694:	7e 13                	jle    8006a9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8b 50 04             	mov    0x4(%eax),%edx
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	8b 75 14             	mov    0x14(%ebp),%esi
  8006a1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006a4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006a7:	eb 2c                	jmp    8006d5 <vprintfmt+0x331>
	else if (lflag)
  8006a9:	85 c9                	test   %ecx,%ecx
  8006ab:	74 15                	je     8006c2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	8b 75 14             	mov    0x14(%ebp),%esi
  8006ba:	8d 76 04             	lea    0x4(%esi),%esi
  8006bd:	89 75 14             	mov    %esi,0x14(%ebp)
  8006c0:	eb 13                	jmp    8006d5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	8b 75 14             	mov    0x14(%ebp),%esi
  8006cf:	8d 76 04             	lea    0x4(%esi),%esi
  8006d2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8006d5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006da:	e9 c6 00 00 00       	jmp    8007a5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006df:	83 f9 01             	cmp    $0x1,%ecx
  8006e2:	7e 13                	jle    8006f7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	8b 75 14             	mov    0x14(%ebp),%esi
  8006ef:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006f2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006f5:	eb 24                	jmp    80071b <vprintfmt+0x377>
	else if (lflag)
  8006f7:	85 c9                	test   %ecx,%ecx
  8006f9:	74 11                	je     80070c <vprintfmt+0x368>
		return va_arg(*ap, long);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	99                   	cltd   
  800701:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800704:	8d 71 04             	lea    0x4(%ecx),%esi
  800707:	89 75 14             	mov    %esi,0x14(%ebp)
  80070a:	eb 0f                	jmp    80071b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	99                   	cltd   
  800712:	8b 75 14             	mov    0x14(%ebp),%esi
  800715:	8d 76 04             	lea    0x4(%esi),%esi
  800718:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80071b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800720:	e9 80 00 00 00       	jmp    8007a5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800725:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800736:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800739:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800740:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800747:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80074a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80074e:	8b 06                	mov    (%esi),%eax
  800750:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800755:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80075a:	eb 49                	jmp    8007a5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80075c:	83 f9 01             	cmp    $0x1,%ecx
  80075f:	7e 13                	jle    800774 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 50 04             	mov    0x4(%eax),%edx
  800767:	8b 00                	mov    (%eax),%eax
  800769:	8b 75 14             	mov    0x14(%ebp),%esi
  80076c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80076f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800772:	eb 2c                	jmp    8007a0 <vprintfmt+0x3fc>
	else if (lflag)
  800774:	85 c9                	test   %ecx,%ecx
  800776:	74 15                	je     80078d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	ba 00 00 00 00       	mov    $0x0,%edx
  800782:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800785:	8d 71 04             	lea    0x4(%ecx),%esi
  800788:	89 75 14             	mov    %esi,0x14(%ebp)
  80078b:	eb 13                	jmp    8007a0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
  800797:	8b 75 14             	mov    0x14(%ebp),%esi
  80079a:	8d 76 04             	lea    0x4(%esi),%esi
  80079d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8007a0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8007a9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007ad:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8007b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007b4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007b8:	89 04 24             	mov    %eax,(%esp)
  8007bb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	e8 a6 fa ff ff       	call   800270 <printnum>
			break;
  8007ca:	e9 fa fb ff ff       	jmp    8003c9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007d6:	89 04 24             	mov    %eax,(%esp)
  8007d9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007dc:	e9 e8 fb ff ff       	jmp    8003c9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007ef:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f2:	89 fb                	mov    %edi,%ebx
  8007f4:	eb 03                	jmp    8007f9 <vprintfmt+0x455>
  8007f6:	83 eb 01             	sub    $0x1,%ebx
  8007f9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007fd:	75 f7                	jne    8007f6 <vprintfmt+0x452>
  8007ff:	90                   	nop
  800800:	e9 c4 fb ff ff       	jmp    8003c9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800805:	83 c4 3c             	add    $0x3c,%esp
  800808:	5b                   	pop    %ebx
  800809:	5e                   	pop    %esi
  80080a:	5f                   	pop    %edi
  80080b:	5d                   	pop    %ebp
  80080c:	c3                   	ret    

0080080d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	83 ec 28             	sub    $0x28,%esp
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800819:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80081c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800820:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800823:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80082a:	85 c0                	test   %eax,%eax
  80082c:	74 30                	je     80085e <vsnprintf+0x51>
  80082e:	85 d2                	test   %edx,%edx
  800830:	7e 2c                	jle    80085e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800839:	8b 45 10             	mov    0x10(%ebp),%eax
  80083c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800840:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800843:	89 44 24 04          	mov    %eax,0x4(%esp)
  800847:	c7 04 24 5f 03 80 00 	movl   $0x80035f,(%esp)
  80084e:	e8 51 fb ff ff       	call   8003a4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800853:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800856:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80085c:	eb 05                	jmp    800863 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80085e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800863:	c9                   	leave  
  800864:	c3                   	ret    

00800865 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80086b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80086e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800872:	8b 45 10             	mov    0x10(%ebp),%eax
  800875:	89 44 24 08          	mov    %eax,0x8(%esp)
  800879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	89 04 24             	mov    %eax,(%esp)
  800886:	e8 82 ff ff ff       	call   80080d <vsnprintf>
	va_end(ap);

	return rc;
}
  80088b:	c9                   	leave  
  80088c:	c3                   	ret    
  80088d:	66 90                	xchg   %ax,%ax
  80088f:	90                   	nop

00800890 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800896:	b8 00 00 00 00       	mov    $0x0,%eax
  80089b:	eb 03                	jmp    8008a0 <strlen+0x10>
		n++;
  80089d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008a4:	75 f7                	jne    80089d <strlen+0xd>
		n++;
	return n;
}
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b6:	eb 03                	jmp    8008bb <strnlen+0x13>
		n++;
  8008b8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008bb:	39 d0                	cmp    %edx,%eax
  8008bd:	74 06                	je     8008c5 <strnlen+0x1d>
  8008bf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008c3:	75 f3                	jne    8008b8 <strnlen+0x10>
		n++;
	return n;
}
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	53                   	push   %ebx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008d1:	89 c2                	mov    %eax,%edx
  8008d3:	83 c2 01             	add    $0x1,%edx
  8008d6:	83 c1 01             	add    $0x1,%ecx
  8008d9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008dd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008e0:	84 db                	test   %bl,%bl
  8008e2:	75 ef                	jne    8008d3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008e4:	5b                   	pop    %ebx
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008f1:	89 1c 24             	mov    %ebx,(%esp)
  8008f4:	e8 97 ff ff ff       	call   800890 <strlen>
	strcpy(dst + len, src);
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800900:	01 d8                	add    %ebx,%eax
  800902:	89 04 24             	mov    %eax,(%esp)
  800905:	e8 bd ff ff ff       	call   8008c7 <strcpy>
	return dst;
}
  80090a:	89 d8                	mov    %ebx,%eax
  80090c:	83 c4 08             	add    $0x8,%esp
  80090f:	5b                   	pop    %ebx
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	56                   	push   %esi
  800916:	53                   	push   %ebx
  800917:	8b 75 08             	mov    0x8(%ebp),%esi
  80091a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091d:	89 f3                	mov    %esi,%ebx
  80091f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800922:	89 f2                	mov    %esi,%edx
  800924:	eb 0f                	jmp    800935 <strncpy+0x23>
		*dst++ = *src;
  800926:	83 c2 01             	add    $0x1,%edx
  800929:	0f b6 01             	movzbl (%ecx),%eax
  80092c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80092f:	80 39 01             	cmpb   $0x1,(%ecx)
  800932:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800935:	39 da                	cmp    %ebx,%edx
  800937:	75 ed                	jne    800926 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800939:	89 f0                	mov    %esi,%eax
  80093b:	5b                   	pop    %ebx
  80093c:	5e                   	pop    %esi
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	56                   	push   %esi
  800943:	53                   	push   %ebx
  800944:	8b 75 08             	mov    0x8(%ebp),%esi
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80094d:	89 f0                	mov    %esi,%eax
  80094f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800953:	85 c9                	test   %ecx,%ecx
  800955:	75 0b                	jne    800962 <strlcpy+0x23>
  800957:	eb 1d                	jmp    800976 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800959:	83 c0 01             	add    $0x1,%eax
  80095c:	83 c2 01             	add    $0x1,%edx
  80095f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800962:	39 d8                	cmp    %ebx,%eax
  800964:	74 0b                	je     800971 <strlcpy+0x32>
  800966:	0f b6 0a             	movzbl (%edx),%ecx
  800969:	84 c9                	test   %cl,%cl
  80096b:	75 ec                	jne    800959 <strlcpy+0x1a>
  80096d:	89 c2                	mov    %eax,%edx
  80096f:	eb 02                	jmp    800973 <strlcpy+0x34>
  800971:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800973:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800976:	29 f0                	sub    %esi,%eax
}
  800978:	5b                   	pop    %ebx
  800979:	5e                   	pop    %esi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800985:	eb 06                	jmp    80098d <strcmp+0x11>
		p++, q++;
  800987:	83 c1 01             	add    $0x1,%ecx
  80098a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80098d:	0f b6 01             	movzbl (%ecx),%eax
  800990:	84 c0                	test   %al,%al
  800992:	74 04                	je     800998 <strcmp+0x1c>
  800994:	3a 02                	cmp    (%edx),%al
  800996:	74 ef                	je     800987 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800998:	0f b6 c0             	movzbl %al,%eax
  80099b:	0f b6 12             	movzbl (%edx),%edx
  80099e:	29 d0                	sub    %edx,%eax
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ac:	89 c3                	mov    %eax,%ebx
  8009ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b1:	eb 06                	jmp    8009b9 <strncmp+0x17>
		n--, p++, q++;
  8009b3:	83 c0 01             	add    $0x1,%eax
  8009b6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009b9:	39 d8                	cmp    %ebx,%eax
  8009bb:	74 15                	je     8009d2 <strncmp+0x30>
  8009bd:	0f b6 08             	movzbl (%eax),%ecx
  8009c0:	84 c9                	test   %cl,%cl
  8009c2:	74 04                	je     8009c8 <strncmp+0x26>
  8009c4:	3a 0a                	cmp    (%edx),%cl
  8009c6:	74 eb                	je     8009b3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c8:	0f b6 00             	movzbl (%eax),%eax
  8009cb:	0f b6 12             	movzbl (%edx),%edx
  8009ce:	29 d0                	sub    %edx,%eax
  8009d0:	eb 05                	jmp    8009d7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009d7:	5b                   	pop    %ebx
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e4:	eb 07                	jmp    8009ed <strchr+0x13>
		if (*s == c)
  8009e6:	38 ca                	cmp    %cl,%dl
  8009e8:	74 0f                	je     8009f9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ea:	83 c0 01             	add    $0x1,%eax
  8009ed:	0f b6 10             	movzbl (%eax),%edx
  8009f0:	84 d2                	test   %dl,%dl
  8009f2:	75 f2                	jne    8009e6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a05:	eb 07                	jmp    800a0e <strfind+0x13>
		if (*s == c)
  800a07:	38 ca                	cmp    %cl,%dl
  800a09:	74 0a                	je     800a15 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a0b:	83 c0 01             	add    $0x1,%eax
  800a0e:	0f b6 10             	movzbl (%eax),%edx
  800a11:	84 d2                	test   %dl,%dl
  800a13:	75 f2                	jne    800a07 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	57                   	push   %edi
  800a1b:	56                   	push   %esi
  800a1c:	53                   	push   %ebx
  800a1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a20:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a23:	85 c9                	test   %ecx,%ecx
  800a25:	74 36                	je     800a5d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a27:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a2d:	75 28                	jne    800a57 <memset+0x40>
  800a2f:	f6 c1 03             	test   $0x3,%cl
  800a32:	75 23                	jne    800a57 <memset+0x40>
		c &= 0xFF;
  800a34:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a38:	89 d3                	mov    %edx,%ebx
  800a3a:	c1 e3 08             	shl    $0x8,%ebx
  800a3d:	89 d6                	mov    %edx,%esi
  800a3f:	c1 e6 18             	shl    $0x18,%esi
  800a42:	89 d0                	mov    %edx,%eax
  800a44:	c1 e0 10             	shl    $0x10,%eax
  800a47:	09 f0                	or     %esi,%eax
  800a49:	09 c2                	or     %eax,%edx
  800a4b:	89 d0                	mov    %edx,%eax
  800a4d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a4f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a52:	fc                   	cld    
  800a53:	f3 ab                	rep stos %eax,%es:(%edi)
  800a55:	eb 06                	jmp    800a5d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5a:	fc                   	cld    
  800a5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5d:	89 f8                	mov    %edi,%eax
  800a5f:	5b                   	pop    %ebx
  800a60:	5e                   	pop    %esi
  800a61:	5f                   	pop    %edi
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	57                   	push   %edi
  800a68:	56                   	push   %esi
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a72:	39 c6                	cmp    %eax,%esi
  800a74:	73 35                	jae    800aab <memmove+0x47>
  800a76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a79:	39 d0                	cmp    %edx,%eax
  800a7b:	73 2e                	jae    800aab <memmove+0x47>
		s += n;
		d += n;
  800a7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a80:	89 d6                	mov    %edx,%esi
  800a82:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a84:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a8a:	75 13                	jne    800a9f <memmove+0x3b>
  800a8c:	f6 c1 03             	test   $0x3,%cl
  800a8f:	75 0e                	jne    800a9f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a91:	83 ef 04             	sub    $0x4,%edi
  800a94:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a97:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a9a:	fd                   	std    
  800a9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9d:	eb 09                	jmp    800aa8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a9f:	83 ef 01             	sub    $0x1,%edi
  800aa2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800aa5:	fd                   	std    
  800aa6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa8:	fc                   	cld    
  800aa9:	eb 1d                	jmp    800ac8 <memmove+0x64>
  800aab:	89 f2                	mov    %esi,%edx
  800aad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aaf:	f6 c2 03             	test   $0x3,%dl
  800ab2:	75 0f                	jne    800ac3 <memmove+0x5f>
  800ab4:	f6 c1 03             	test   $0x3,%cl
  800ab7:	75 0a                	jne    800ac3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ab9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800abc:	89 c7                	mov    %eax,%edi
  800abe:	fc                   	cld    
  800abf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac1:	eb 05                	jmp    800ac8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ac3:	89 c7                	mov    %eax,%edi
  800ac5:	fc                   	cld    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac8:	5e                   	pop    %esi
  800ac9:	5f                   	pop    %edi
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	89 04 24             	mov    %eax,(%esp)
  800ae6:	e8 79 ff ff ff       	call   800a64 <memmove>
}
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    

00800aed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	8b 55 08             	mov    0x8(%ebp),%edx
  800af5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af8:	89 d6                	mov    %edx,%esi
  800afa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afd:	eb 1a                	jmp    800b19 <memcmp+0x2c>
		if (*s1 != *s2)
  800aff:	0f b6 02             	movzbl (%edx),%eax
  800b02:	0f b6 19             	movzbl (%ecx),%ebx
  800b05:	38 d8                	cmp    %bl,%al
  800b07:	74 0a                	je     800b13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b09:	0f b6 c0             	movzbl %al,%eax
  800b0c:	0f b6 db             	movzbl %bl,%ebx
  800b0f:	29 d8                	sub    %ebx,%eax
  800b11:	eb 0f                	jmp    800b22 <memcmp+0x35>
		s1++, s2++;
  800b13:	83 c2 01             	add    $0x1,%edx
  800b16:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b19:	39 f2                	cmp    %esi,%edx
  800b1b:	75 e2                	jne    800aff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b34:	eb 07                	jmp    800b3d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b36:	38 08                	cmp    %cl,(%eax)
  800b38:	74 07                	je     800b41 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b3a:	83 c0 01             	add    $0x1,%eax
  800b3d:	39 d0                	cmp    %edx,%eax
  800b3f:	72 f5                	jb     800b36 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	57                   	push   %edi
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4f:	eb 03                	jmp    800b54 <strtol+0x11>
		s++;
  800b51:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b54:	0f b6 0a             	movzbl (%edx),%ecx
  800b57:	80 f9 09             	cmp    $0x9,%cl
  800b5a:	74 f5                	je     800b51 <strtol+0xe>
  800b5c:	80 f9 20             	cmp    $0x20,%cl
  800b5f:	74 f0                	je     800b51 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b61:	80 f9 2b             	cmp    $0x2b,%cl
  800b64:	75 0a                	jne    800b70 <strtol+0x2d>
		s++;
  800b66:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b69:	bf 00 00 00 00       	mov    $0x0,%edi
  800b6e:	eb 11                	jmp    800b81 <strtol+0x3e>
  800b70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b75:	80 f9 2d             	cmp    $0x2d,%cl
  800b78:	75 07                	jne    800b81 <strtol+0x3e>
		s++, neg = 1;
  800b7a:	8d 52 01             	lea    0x1(%edx),%edx
  800b7d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b81:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b86:	75 15                	jne    800b9d <strtol+0x5a>
  800b88:	80 3a 30             	cmpb   $0x30,(%edx)
  800b8b:	75 10                	jne    800b9d <strtol+0x5a>
  800b8d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b91:	75 0a                	jne    800b9d <strtol+0x5a>
		s += 2, base = 16;
  800b93:	83 c2 02             	add    $0x2,%edx
  800b96:	b8 10 00 00 00       	mov    $0x10,%eax
  800b9b:	eb 10                	jmp    800bad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b9d:	85 c0                	test   %eax,%eax
  800b9f:	75 0c                	jne    800bad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ba3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ba6:	75 05                	jne    800bad <strtol+0x6a>
		s++, base = 8;
  800ba8:	83 c2 01             	add    $0x1,%edx
  800bab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bb5:	0f b6 0a             	movzbl (%edx),%ecx
  800bb8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bbb:	89 f0                	mov    %esi,%eax
  800bbd:	3c 09                	cmp    $0x9,%al
  800bbf:	77 08                	ja     800bc9 <strtol+0x86>
			dig = *s - '0';
  800bc1:	0f be c9             	movsbl %cl,%ecx
  800bc4:	83 e9 30             	sub    $0x30,%ecx
  800bc7:	eb 20                	jmp    800be9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800bc9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bcc:	89 f0                	mov    %esi,%eax
  800bce:	3c 19                	cmp    $0x19,%al
  800bd0:	77 08                	ja     800bda <strtol+0x97>
			dig = *s - 'a' + 10;
  800bd2:	0f be c9             	movsbl %cl,%ecx
  800bd5:	83 e9 57             	sub    $0x57,%ecx
  800bd8:	eb 0f                	jmp    800be9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bda:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bdd:	89 f0                	mov    %esi,%eax
  800bdf:	3c 19                	cmp    $0x19,%al
  800be1:	77 16                	ja     800bf9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800be3:	0f be c9             	movsbl %cl,%ecx
  800be6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800be9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bec:	7d 0f                	jge    800bfd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bf5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bf7:	eb bc                	jmp    800bb5 <strtol+0x72>
  800bf9:	89 d8                	mov    %ebx,%eax
  800bfb:	eb 02                	jmp    800bff <strtol+0xbc>
  800bfd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c03:	74 05                	je     800c0a <strtol+0xc7>
		*endptr = (char *) s;
  800c05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c08:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c0a:	f7 d8                	neg    %eax
  800c0c:	85 ff                	test   %edi,%edi
  800c0e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c24:	8b 55 08             	mov    0x8(%ebp),%edx
  800c27:	89 c3                	mov    %eax,%ebx
  800c29:	89 c7                	mov    %eax,%edi
  800c2b:	89 c6                	mov    %eax,%esi
  800c2d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c44:	89 d1                	mov    %edx,%ecx
  800c46:	89 d3                	mov    %edx,%ebx
  800c48:	89 d7                	mov    %edx,%edi
  800c4a:	89 d6                	mov    %edx,%esi
  800c4c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c4e:	5b                   	pop    %ebx
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c61:	b8 03 00 00 00       	mov    $0x3,%eax
  800c66:	8b 55 08             	mov    0x8(%ebp),%edx
  800c69:	89 cb                	mov    %ecx,%ebx
  800c6b:	89 cf                	mov    %ecx,%edi
  800c6d:	89 ce                	mov    %ecx,%esi
  800c6f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c71:	85 c0                	test   %eax,%eax
  800c73:	7e 28                	jle    800c9d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c75:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c79:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c80:	00 
  800c81:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800c88:	00 
  800c89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c90:	00 
  800c91:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800c98:	e8 b9 1d 00 00       	call   802a56 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c9d:	83 c4 2c             	add    $0x2c,%esp
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
  800cab:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cae:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb3:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	89 cb                	mov    %ecx,%ebx
  800cbd:	89 cf                	mov    %ecx,%edi
  800cbf:	89 ce                	mov    %ecx,%esi
  800cc1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc3:	85 c0                	test   %eax,%eax
  800cc5:	7e 28                	jle    800cef <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ccb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cd2:	00 
  800cd3:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800cda:	00 
  800cdb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce2:	00 
  800ce3:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800cea:	e8 67 1d 00 00       	call   802a56 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800cef:	83 c4 2c             	add    $0x2c,%esp
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	b8 02 00 00 00       	mov    $0x2,%eax
  800d07:	89 d1                	mov    %edx,%ecx
  800d09:	89 d3                	mov    %edx,%ebx
  800d0b:	89 d7                	mov    %edx,%edi
  800d0d:	89 d6                	mov    %edx,%esi
  800d0f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <sys_yield>:

void
sys_yield(void)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d21:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d26:	89 d1                	mov    %edx,%ecx
  800d28:	89 d3                	mov    %edx,%ebx
  800d2a:	89 d7                	mov    %edx,%edi
  800d2c:	89 d6                	mov    %edx,%esi
  800d2e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3e:	be 00 00 00 00       	mov    $0x0,%esi
  800d43:	b8 05 00 00 00       	mov    $0x5,%eax
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d51:	89 f7                	mov    %esi,%edi
  800d53:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	7e 28                	jle    800d81 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d59:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d5d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d64:	00 
  800d65:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800d6c:	00 
  800d6d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d74:	00 
  800d75:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800d7c:	e8 d5 1c 00 00       	call   802a56 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d81:	83 c4 2c             	add    $0x2c,%esp
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d92:	b8 06 00 00 00       	mov    $0x6,%eax
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da3:	8b 75 18             	mov    0x18(%ebp),%esi
  800da6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da8:	85 c0                	test   %eax,%eax
  800daa:	7e 28                	jle    800dd4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dac:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800db7:	00 
  800db8:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800dbf:	00 
  800dc0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc7:	00 
  800dc8:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800dcf:	e8 82 1c 00 00       	call   802a56 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd4:	83 c4 2c             	add    $0x2c,%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dea:	b8 07 00 00 00       	mov    $0x7,%eax
  800def:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df2:	8b 55 08             	mov    0x8(%ebp),%edx
  800df5:	89 df                	mov    %ebx,%edi
  800df7:	89 de                	mov    %ebx,%esi
  800df9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	7e 28                	jle    800e27 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dff:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e03:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800e0a:	00 
  800e0b:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800e12:	00 
  800e13:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1a:	00 
  800e1b:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800e22:	e8 2f 1c 00 00       	call   802a56 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e27:	83 c4 2c             	add    $0x2c,%esp
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e35:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	89 cb                	mov    %ecx,%ebx
  800e44:	89 cf                	mov    %ecx,%edi
  800e46:	89 ce                	mov    %ecx,%esi
  800e48:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800e4a:	5b                   	pop    %ebx
  800e4b:	5e                   	pop    %esi
  800e4c:	5f                   	pop    %edi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e65:	8b 55 08             	mov    0x8(%ebp),%edx
  800e68:	89 df                	mov    %ebx,%edi
  800e6a:	89 de                	mov    %ebx,%esi
  800e6c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	7e 28                	jle    800e9a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e72:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e76:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e7d:	00 
  800e7e:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800e85:	00 
  800e86:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8d:	00 
  800e8e:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800e95:	e8 bc 1b 00 00       	call   802a56 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e9a:	83 c4 2c             	add    $0x2c,%esp
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5f                   	pop    %edi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
  800ea8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebb:	89 df                	mov    %ebx,%edi
  800ebd:	89 de                	mov    %ebx,%esi
  800ebf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	7e 28                	jle    800eed <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ed0:	00 
  800ed1:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800ed8:	00 
  800ed9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee0:	00 
  800ee1:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800ee8:	e8 69 1b 00 00       	call   802a56 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eed:	83 c4 2c             	add    $0x2c,%esp
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	57                   	push   %edi
  800ef9:	56                   	push   %esi
  800efa:	53                   	push   %ebx
  800efb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f03:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0e:	89 df                	mov    %ebx,%edi
  800f10:	89 de                	mov    %ebx,%esi
  800f12:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f14:	85 c0                	test   %eax,%eax
  800f16:	7e 28                	jle    800f40 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f18:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f1c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f23:	00 
  800f24:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800f2b:	00 
  800f2c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f33:	00 
  800f34:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800f3b:	e8 16 1b 00 00       	call   802a56 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f40:	83 c4 2c             	add    $0x2c,%esp
  800f43:	5b                   	pop    %ebx
  800f44:	5e                   	pop    %esi
  800f45:	5f                   	pop    %edi
  800f46:	5d                   	pop    %ebp
  800f47:	c3                   	ret    

00800f48 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	57                   	push   %edi
  800f4c:	56                   	push   %esi
  800f4d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4e:	be 00 00 00 00       	mov    $0x0,%esi
  800f53:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f61:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f64:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
  800f71:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f74:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f79:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f81:	89 cb                	mov    %ecx,%ebx
  800f83:	89 cf                	mov    %ecx,%edi
  800f85:	89 ce                	mov    %ecx,%esi
  800f87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	7e 28                	jle    800fb5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f91:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800f98:	00 
  800f99:	c7 44 24 08 b7 31 80 	movl   $0x8031b7,0x8(%esp)
  800fa0:	00 
  800fa1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa8:	00 
  800fa9:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  800fb0:	e8 a1 1a 00 00       	call   802a56 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fb5:	83 c4 2c             	add    $0x2c,%esp
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	57                   	push   %edi
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fcd:	89 d1                	mov    %edx,%ecx
  800fcf:	89 d3                	mov    %edx,%ebx
  800fd1:	89 d7                	mov    %edx,%edi
  800fd3:	89 d6                	mov    %edx,%esi
  800fd5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe7:	b8 11 00 00 00       	mov    $0x11,%eax
  800fec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff2:	89 df                	mov    %ebx,%edi
  800ff4:	89 de                	mov    %ebx,%esi
  800ff6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800ff8:	5b                   	pop    %ebx
  800ff9:	5e                   	pop    %esi
  800ffa:	5f                   	pop    %edi
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    

00800ffd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	57                   	push   %edi
  801001:	56                   	push   %esi
  801002:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801003:	bb 00 00 00 00       	mov    $0x0,%ebx
  801008:	b8 12 00 00 00       	mov    $0x12,%eax
  80100d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801010:	8b 55 08             	mov    0x8(%ebp),%edx
  801013:	89 df                	mov    %ebx,%edi
  801015:	89 de                	mov    %ebx,%esi
  801017:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801019:	5b                   	pop    %ebx
  80101a:	5e                   	pop    %esi
  80101b:	5f                   	pop    %edi
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    

0080101e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801024:	b9 00 00 00 00       	mov    $0x0,%ecx
  801029:	b8 13 00 00 00       	mov    $0x13,%eax
  80102e:	8b 55 08             	mov    0x8(%ebp),%edx
  801031:	89 cb                	mov    %ecx,%ebx
  801033:	89 cf                	mov    %ecx,%edi
  801035:	89 ce                	mov    %ecx,%esi
  801037:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	57                   	push   %edi
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
  801044:	83 ec 2c             	sub    $0x2c,%esp
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80104a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80104c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80104f:	89 f8                	mov    %edi,%eax
  801051:	c1 e8 0c             	shr    $0xc,%eax
  801054:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801057:	e8 9b fc ff ff       	call   800cf7 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80105c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801062:	0f 84 de 00 00 00    	je     801146 <pgfault+0x108>
  801068:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  80106a:	85 c0                	test   %eax,%eax
  80106c:	79 20                	jns    80108e <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  80106e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801072:	c7 44 24 08 e2 31 80 	movl   $0x8031e2,0x8(%esp)
  801079:	00 
  80107a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801081:	00 
  801082:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  801089:	e8 c8 19 00 00       	call   802a56 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  80108e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801091:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  801098:	25 05 08 00 00       	and    $0x805,%eax
  80109d:	3d 05 08 00 00       	cmp    $0x805,%eax
  8010a2:	0f 85 ba 00 00 00    	jne    801162 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8010a8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010af:	00 
  8010b0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010b7:	00 
  8010b8:	89 1c 24             	mov    %ebx,(%esp)
  8010bb:	e8 75 fc ff ff       	call   800d35 <sys_page_alloc>
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	79 20                	jns    8010e4 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  8010c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010c8:	c7 44 24 08 09 32 80 	movl   $0x803209,0x8(%esp)
  8010cf:	00 
  8010d0:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8010d7:	00 
  8010d8:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8010df:	e8 72 19 00 00       	call   802a56 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  8010e4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8010ea:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8010f1:	00 
  8010f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010f6:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8010fd:	e8 62 f9 ff ff       	call   800a64 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801102:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801109:	00 
  80110a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80110e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801112:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801119:	00 
  80111a:	89 1c 24             	mov    %ebx,(%esp)
  80111d:	e8 67 fc ff ff       	call   800d89 <sys_page_map>
  801122:	85 c0                	test   %eax,%eax
  801124:	79 3c                	jns    801162 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801126:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80112a:	c7 44 24 08 1c 32 80 	movl   $0x80321c,0x8(%esp)
  801131:	00 
  801132:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801139:	00 
  80113a:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  801141:	e8 10 19 00 00       	call   802a56 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801146:	c7 44 24 08 40 32 80 	movl   $0x803240,0x8(%esp)
  80114d:	00 
  80114e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801155:	00 
  801156:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  80115d:	e8 f4 18 00 00       	call   802a56 <_panic>
}
  801162:	83 c4 2c             	add    $0x2c,%esp
  801165:	5b                   	pop    %ebx
  801166:	5e                   	pop    %esi
  801167:	5f                   	pop    %edi
  801168:	5d                   	pop    %ebp
  801169:	c3                   	ret    

0080116a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	56                   	push   %esi
  80116e:	53                   	push   %ebx
  80116f:	83 ec 20             	sub    $0x20,%esp
  801172:	8b 75 08             	mov    0x8(%ebp),%esi
  801175:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801178:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80117f:	00 
  801180:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801184:	89 34 24             	mov    %esi,(%esp)
  801187:	e8 a9 fb ff ff       	call   800d35 <sys_page_alloc>
  80118c:	85 c0                	test   %eax,%eax
  80118e:	79 20                	jns    8011b0 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  801190:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801194:	c7 44 24 08 09 32 80 	movl   $0x803209,0x8(%esp)
  80119b:	00 
  80119c:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8011a3:	00 
  8011a4:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8011ab:	e8 a6 18 00 00       	call   802a56 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8011b0:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8011b7:	00 
  8011b8:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8011bf:	00 
  8011c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011c7:	00 
  8011c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011cc:	89 34 24             	mov    %esi,(%esp)
  8011cf:	e8 b5 fb ff ff       	call   800d89 <sys_page_map>
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	79 20                	jns    8011f8 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  8011d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011dc:	c7 44 24 08 1c 32 80 	movl   $0x80321c,0x8(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8011eb:	00 
  8011ec:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8011f3:	e8 5e 18 00 00       	call   802a56 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8011f8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011ff:	00 
  801200:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801204:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  80120b:	e8 54 f8 ff ff       	call   800a64 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801210:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801217:	00 
  801218:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80121f:	e8 b8 fb ff ff       	call   800ddc <sys_page_unmap>
  801224:	85 c0                	test   %eax,%eax
  801226:	79 20                	jns    801248 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801228:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122c:	c7 44 24 08 2d 32 80 	movl   $0x80322d,0x8(%esp)
  801233:	00 
  801234:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80123b:	00 
  80123c:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  801243:	e8 0e 18 00 00       	call   802a56 <_panic>

}
  801248:	83 c4 20             	add    $0x20,%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5e                   	pop    %esi
  80124d:	5d                   	pop    %ebp
  80124e:	c3                   	ret    

0080124f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	57                   	push   %edi
  801253:	56                   	push   %esi
  801254:	53                   	push   %ebx
  801255:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801258:	c7 04 24 3e 10 80 00 	movl   $0x80103e,(%esp)
  80125f:	e8 48 18 00 00       	call   802aac <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801264:	b8 08 00 00 00       	mov    $0x8,%eax
  801269:	cd 30                	int    $0x30
  80126b:	89 c6                	mov    %eax,%esi
  80126d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801270:	85 c0                	test   %eax,%eax
  801272:	79 20                	jns    801294 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801274:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801278:	c7 44 24 08 64 32 80 	movl   $0x803264,0x8(%esp)
  80127f:	00 
  801280:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  801287:	00 
  801288:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  80128f:	e8 c2 17 00 00       	call   802a56 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801294:	bb 00 00 00 00       	mov    $0x0,%ebx
  801299:	85 c0                	test   %eax,%eax
  80129b:	75 21                	jne    8012be <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80129d:	e8 55 fa ff ff       	call   800cf7 <sys_getenvid>
  8012a2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012a7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012aa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012af:	a3 0c 50 80 00       	mov    %eax,0x80500c
		//set_pgfault_handler(pgfault);
		return 0;
  8012b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b9:	e9 88 01 00 00       	jmp    801446 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8012be:	89 d8                	mov    %ebx,%eax
  8012c0:	c1 e8 16             	shr    $0x16,%eax
  8012c3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ca:	a8 01                	test   $0x1,%al
  8012cc:	0f 84 e0 00 00 00    	je     8013b2 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8012d2:	89 df                	mov    %ebx,%edi
  8012d4:	c1 ef 0c             	shr    $0xc,%edi
  8012d7:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  8012de:	a8 01                	test   $0x1,%al
  8012e0:	0f 84 c4 00 00 00    	je     8013aa <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  8012e6:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  8012ed:	f6 c4 04             	test   $0x4,%ah
  8012f0:	74 0d                	je     8012ff <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  8012f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012f7:	83 c8 05             	or     $0x5,%eax
  8012fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012fd:	eb 1b                	jmp    80131a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  8012ff:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801304:	83 f8 01             	cmp    $0x1,%eax
  801307:	19 c0                	sbb    %eax,%eax
  801309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80130c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801313:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  80131a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  80131d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801320:	89 44 24 10          	mov    %eax,0x10(%esp)
  801324:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80132b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80132f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801333:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133a:	e8 4a fa ff ff       	call   800d89 <sys_page_map>
  80133f:	85 c0                	test   %eax,%eax
  801341:	79 20                	jns    801363 <fork+0x114>
		panic("sys_page_map: %e", r);
  801343:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801347:	c7 44 24 08 1c 32 80 	movl   $0x80321c,0x8(%esp)
  80134e:	00 
  80134f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801356:	00 
  801357:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  80135e:	e8 f3 16 00 00       	call   802a56 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801363:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801366:	89 44 24 10          	mov    %eax,0x10(%esp)
  80136a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80136e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801375:	00 
  801376:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80137a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801381:	e8 03 fa ff ff       	call   800d89 <sys_page_map>
  801386:	85 c0                	test   %eax,%eax
  801388:	79 20                	jns    8013aa <fork+0x15b>
		panic("sys_page_map: %e", r);
  80138a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80138e:	c7 44 24 08 1c 32 80 	movl   $0x80321c,0x8(%esp)
  801395:	00 
  801396:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  80139d:	00 
  80139e:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8013a5:	e8 ac 16 00 00       	call   802a56 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8013aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013b0:	eb 06                	jmp    8013b8 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  8013b2:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  8013b8:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  8013be:	0f 86 fa fe ff ff    	jbe    8012be <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8013c4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013cb:	00 
  8013cc:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013d3:	ee 
  8013d4:	89 34 24             	mov    %esi,(%esp)
  8013d7:	e8 59 f9 ff ff       	call   800d35 <sys_page_alloc>
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	79 20                	jns    801400 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  8013e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013e4:	c7 44 24 08 09 32 80 	movl   $0x803209,0x8(%esp)
  8013eb:	00 
  8013ec:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  8013f3:	00 
  8013f4:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8013fb:	e8 56 16 00 00       	call   802a56 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801400:	c7 44 24 04 3f 2b 80 	movl   $0x802b3f,0x4(%esp)
  801407:	00 
  801408:	89 34 24             	mov    %esi,(%esp)
  80140b:	e8 e5 fa ff ff       	call   800ef5 <sys_env_set_pgfault_upcall>
  801410:	85 c0                	test   %eax,%eax
  801412:	79 20                	jns    801434 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801414:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801418:	c7 44 24 08 88 32 80 	movl   $0x803288,0x8(%esp)
  80141f:	00 
  801420:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801427:	00 
  801428:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  80142f:	e8 22 16 00 00       	call   802a56 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801434:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80143b:	00 
  80143c:	89 34 24             	mov    %esi,(%esp)
  80143f:	e8 0b fa ff ff       	call   800e4f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801444:	89 f0                	mov    %esi,%eax

}
  801446:	83 c4 2c             	add    $0x2c,%esp
  801449:	5b                   	pop    %ebx
  80144a:	5e                   	pop    %esi
  80144b:	5f                   	pop    %edi
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <sfork>:

// Challenge!
int
sfork(void)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	57                   	push   %edi
  801452:	56                   	push   %esi
  801453:	53                   	push   %ebx
  801454:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801457:	c7 04 24 3e 10 80 00 	movl   $0x80103e,(%esp)
  80145e:	e8 49 16 00 00       	call   802aac <set_pgfault_handler>
  801463:	b8 08 00 00 00       	mov    $0x8,%eax
  801468:	cd 30                	int    $0x30
  80146a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  80146c:	85 c0                	test   %eax,%eax
  80146e:	79 20                	jns    801490 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801470:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801474:	c7 44 24 08 64 32 80 	movl   $0x803264,0x8(%esp)
  80147b:	00 
  80147c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  801483:	00 
  801484:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  80148b:	e8 c6 15 00 00       	call   802a56 <_panic>
  801490:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801492:	bb 00 00 00 00       	mov    $0x0,%ebx
  801497:	85 c0                	test   %eax,%eax
  801499:	75 2d                	jne    8014c8 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80149b:	e8 57 f8 ff ff       	call   800cf7 <sys_getenvid>
  8014a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014a5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014ad:	a3 0c 50 80 00       	mov    %eax,0x80500c
		set_pgfault_handler(pgfault);
  8014b2:	c7 04 24 3e 10 80 00 	movl   $0x80103e,(%esp)
  8014b9:	e8 ee 15 00 00       	call   802aac <set_pgfault_handler>
		return 0;
  8014be:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c3:	e9 1d 01 00 00       	jmp    8015e5 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8014c8:	89 d8                	mov    %ebx,%eax
  8014ca:	c1 e8 16             	shr    $0x16,%eax
  8014cd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014d4:	a8 01                	test   $0x1,%al
  8014d6:	74 69                	je     801541 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8014d8:	89 d8                	mov    %ebx,%eax
  8014da:	c1 e8 0c             	shr    $0xc,%eax
  8014dd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014e4:	f6 c2 01             	test   $0x1,%dl
  8014e7:	74 50                	je     801539 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  8014e9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  8014f0:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  8014f3:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  8014f9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8014fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801501:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801505:	89 44 24 04          	mov    %eax,0x4(%esp)
  801509:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801510:	e8 74 f8 ff ff       	call   800d89 <sys_page_map>
  801515:	85 c0                	test   %eax,%eax
  801517:	79 20                	jns    801539 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801519:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80151d:	c7 44 24 08 1c 32 80 	movl   $0x80321c,0x8(%esp)
  801524:	00 
  801525:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  80152c:	00 
  80152d:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  801534:	e8 1d 15 00 00       	call   802a56 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801539:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80153f:	eb 06                	jmp    801547 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801541:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801547:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  80154d:	0f 86 75 ff ff ff    	jbe    8014c8 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801553:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  80155a:	ee 
  80155b:	89 34 24             	mov    %esi,(%esp)
  80155e:	e8 07 fc ff ff       	call   80116a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801563:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80156a:	00 
  80156b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801572:	ee 
  801573:	89 34 24             	mov    %esi,(%esp)
  801576:	e8 ba f7 ff ff       	call   800d35 <sys_page_alloc>
  80157b:	85 c0                	test   %eax,%eax
  80157d:	79 20                	jns    80159f <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  80157f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801583:	c7 44 24 08 09 32 80 	movl   $0x803209,0x8(%esp)
  80158a:	00 
  80158b:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  801592:	00 
  801593:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  80159a:	e8 b7 14 00 00       	call   802a56 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80159f:	c7 44 24 04 3f 2b 80 	movl   $0x802b3f,0x4(%esp)
  8015a6:	00 
  8015a7:	89 34 24             	mov    %esi,(%esp)
  8015aa:	e8 46 f9 ff ff       	call   800ef5 <sys_env_set_pgfault_upcall>
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	79 20                	jns    8015d3 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  8015b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015b7:	c7 44 24 08 88 32 80 	movl   $0x803288,0x8(%esp)
  8015be:	00 
  8015bf:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  8015c6:	00 
  8015c7:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  8015ce:	e8 83 14 00 00       	call   802a56 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  8015d3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8015da:	00 
  8015db:	89 34 24             	mov    %esi,(%esp)
  8015de:	e8 6c f8 ff ff       	call   800e4f <sys_env_set_status>
	return envid;
  8015e3:	89 f0                	mov    %esi,%eax

}
  8015e5:	83 c4 2c             	add    $0x2c,%esp
  8015e8:	5b                   	pop    %ebx
  8015e9:	5e                   	pop    %esi
  8015ea:	5f                   	pop    %edi
  8015eb:	5d                   	pop    %ebp
  8015ec:	c3                   	ret    
  8015ed:	66 90                	xchg   %ax,%ax
  8015ef:	90                   	nop

008015f0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	56                   	push   %esi
  8015f4:	53                   	push   %ebx
  8015f5:	83 ec 10             	sub    $0x10,%esp
  8015f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  801601:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  801603:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801608:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80160b:	89 04 24             	mov    %eax,(%esp)
  80160e:	e8 58 f9 ff ff       	call   800f6b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  801613:	85 c0                	test   %eax,%eax
  801615:	75 26                	jne    80163d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  801617:	85 f6                	test   %esi,%esi
  801619:	74 0a                	je     801625 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80161b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801620:	8b 40 74             	mov    0x74(%eax),%eax
  801623:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  801625:	85 db                	test   %ebx,%ebx
  801627:	74 0a                	je     801633 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  801629:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80162e:	8b 40 78             	mov    0x78(%eax),%eax
  801631:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801633:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801638:	8b 40 70             	mov    0x70(%eax),%eax
  80163b:	eb 14                	jmp    801651 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80163d:	85 f6                	test   %esi,%esi
  80163f:	74 06                	je     801647 <ipc_recv+0x57>
			*from_env_store = 0;
  801641:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801647:	85 db                	test   %ebx,%ebx
  801649:	74 06                	je     801651 <ipc_recv+0x61>
			*perm_store = 0;
  80164b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	5b                   	pop    %ebx
  801655:	5e                   	pop    %esi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    

00801658 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	57                   	push   %edi
  80165c:	56                   	push   %esi
  80165d:	53                   	push   %ebx
  80165e:	83 ec 1c             	sub    $0x1c,%esp
  801661:	8b 7d 08             	mov    0x8(%ebp),%edi
  801664:	8b 75 0c             	mov    0xc(%ebp),%esi
  801667:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80166a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80166c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  801671:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801674:	8b 45 14             	mov    0x14(%ebp),%eax
  801677:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80167b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80167f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801683:	89 3c 24             	mov    %edi,(%esp)
  801686:	e8 bd f8 ff ff       	call   800f48 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80168b:	85 c0                	test   %eax,%eax
  80168d:	74 28                	je     8016b7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80168f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801692:	74 1c                	je     8016b0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  801694:	c7 44 24 08 ac 32 80 	movl   $0x8032ac,0x8(%esp)
  80169b:	00 
  80169c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8016a3:	00 
  8016a4:	c7 04 24 cd 32 80 00 	movl   $0x8032cd,(%esp)
  8016ab:	e8 a6 13 00 00       	call   802a56 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8016b0:	e8 61 f6 ff ff       	call   800d16 <sys_yield>
	}
  8016b5:	eb bd                	jmp    801674 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8016b7:	83 c4 1c             	add    $0x1c,%esp
  8016ba:	5b                   	pop    %ebx
  8016bb:	5e                   	pop    %esi
  8016bc:	5f                   	pop    %edi
  8016bd:	5d                   	pop    %ebp
  8016be:	c3                   	ret    

008016bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8016c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8016ca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8016cd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8016d3:	8b 52 50             	mov    0x50(%edx),%edx
  8016d6:	39 ca                	cmp    %ecx,%edx
  8016d8:	75 0d                	jne    8016e7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8016da:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8016dd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8016e2:	8b 40 40             	mov    0x40(%eax),%eax
  8016e5:	eb 0e                	jmp    8016f5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8016e7:	83 c0 01             	add    $0x1,%eax
  8016ea:	3d 00 04 00 00       	cmp    $0x400,%eax
  8016ef:	75 d9                	jne    8016ca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8016f1:	66 b8 00 00          	mov    $0x0,%ax
}
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    
  8016f7:	66 90                	xchg   %ax,%ax
  8016f9:	66 90                	xchg   %ax,%ax
  8016fb:	66 90                	xchg   %ax,%ax
  8016fd:	66 90                	xchg   %ax,%ax
  8016ff:	90                   	nop

00801700 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	05 00 00 00 30       	add    $0x30000000,%eax
  80170b:	c1 e8 0c             	shr    $0xc,%eax
}
  80170e:	5d                   	pop    %ebp
  80170f:	c3                   	ret    

00801710 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80171b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801720:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801725:	5d                   	pop    %ebp
  801726:	c3                   	ret    

00801727 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801732:	89 c2                	mov    %eax,%edx
  801734:	c1 ea 16             	shr    $0x16,%edx
  801737:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80173e:	f6 c2 01             	test   $0x1,%dl
  801741:	74 11                	je     801754 <fd_alloc+0x2d>
  801743:	89 c2                	mov    %eax,%edx
  801745:	c1 ea 0c             	shr    $0xc,%edx
  801748:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80174f:	f6 c2 01             	test   $0x1,%dl
  801752:	75 09                	jne    80175d <fd_alloc+0x36>
			*fd_store = fd;
  801754:	89 01                	mov    %eax,(%ecx)
			return 0;
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	eb 17                	jmp    801774 <fd_alloc+0x4d>
  80175d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801762:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801767:	75 c9                	jne    801732 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801769:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80176f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80177c:	83 f8 1f             	cmp    $0x1f,%eax
  80177f:	77 36                	ja     8017b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801781:	c1 e0 0c             	shl    $0xc,%eax
  801784:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801789:	89 c2                	mov    %eax,%edx
  80178b:	c1 ea 16             	shr    $0x16,%edx
  80178e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801795:	f6 c2 01             	test   $0x1,%dl
  801798:	74 24                	je     8017be <fd_lookup+0x48>
  80179a:	89 c2                	mov    %eax,%edx
  80179c:	c1 ea 0c             	shr    $0xc,%edx
  80179f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017a6:	f6 c2 01             	test   $0x1,%dl
  8017a9:	74 1a                	je     8017c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8017b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b5:	eb 13                	jmp    8017ca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8017b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017bc:	eb 0c                	jmp    8017ca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8017be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c3:	eb 05                	jmp    8017ca <fd_lookup+0x54>
  8017c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8017ca:	5d                   	pop    %ebp
  8017cb:	c3                   	ret    

008017cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 18             	sub    $0x18,%esp
  8017d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017da:	eb 13                	jmp    8017ef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8017dc:	39 08                	cmp    %ecx,(%eax)
  8017de:	75 0c                	jne    8017ec <dev_lookup+0x20>
			*dev = devtab[i];
  8017e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ea:	eb 38                	jmp    801824 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017ec:	83 c2 01             	add    $0x1,%edx
  8017ef:	8b 04 95 54 33 80 00 	mov    0x803354(,%edx,4),%eax
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	75 e2                	jne    8017dc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017fa:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8017ff:	8b 40 48             	mov    0x48(%eax),%eax
  801802:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801806:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180a:	c7 04 24 d8 32 80 00 	movl   $0x8032d8,(%esp)
  801811:	e8 35 ea ff ff       	call   80024b <cprintf>
	*dev = 0;
  801816:	8b 45 0c             	mov    0xc(%ebp),%eax
  801819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80181f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	56                   	push   %esi
  80182a:	53                   	push   %ebx
  80182b:	83 ec 20             	sub    $0x20,%esp
  80182e:	8b 75 08             	mov    0x8(%ebp),%esi
  801831:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801834:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801837:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80183b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801841:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801844:	89 04 24             	mov    %eax,(%esp)
  801847:	e8 2a ff ff ff       	call   801776 <fd_lookup>
  80184c:	85 c0                	test   %eax,%eax
  80184e:	78 05                	js     801855 <fd_close+0x2f>
	    || fd != fd2)
  801850:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801853:	74 0c                	je     801861 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801855:	84 db                	test   %bl,%bl
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	0f 44 c2             	cmove  %edx,%eax
  80185f:	eb 3f                	jmp    8018a0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801861:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801864:	89 44 24 04          	mov    %eax,0x4(%esp)
  801868:	8b 06                	mov    (%esi),%eax
  80186a:	89 04 24             	mov    %eax,(%esp)
  80186d:	e8 5a ff ff ff       	call   8017cc <dev_lookup>
  801872:	89 c3                	mov    %eax,%ebx
  801874:	85 c0                	test   %eax,%eax
  801876:	78 16                	js     80188e <fd_close+0x68>
		if (dev->dev_close)
  801878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80187e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801883:	85 c0                	test   %eax,%eax
  801885:	74 07                	je     80188e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801887:	89 34 24             	mov    %esi,(%esp)
  80188a:	ff d0                	call   *%eax
  80188c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80188e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801892:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801899:	e8 3e f5 ff ff       	call   800ddc <sys_page_unmap>
	return r;
  80189e:	89 d8                	mov    %ebx,%eax
}
  8018a0:	83 c4 20             	add    $0x20,%esp
  8018a3:	5b                   	pop    %ebx
  8018a4:	5e                   	pop    %esi
  8018a5:	5d                   	pop    %ebp
  8018a6:	c3                   	ret    

008018a7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	89 04 24             	mov    %eax,(%esp)
  8018ba:	e8 b7 fe ff ff       	call   801776 <fd_lookup>
  8018bf:	89 c2                	mov    %eax,%edx
  8018c1:	85 d2                	test   %edx,%edx
  8018c3:	78 13                	js     8018d8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8018c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018cc:	00 
  8018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d0:	89 04 24             	mov    %eax,(%esp)
  8018d3:	e8 4e ff ff ff       	call   801826 <fd_close>
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <close_all>:

void
close_all(void)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018e6:	89 1c 24             	mov    %ebx,(%esp)
  8018e9:	e8 b9 ff ff ff       	call   8018a7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8018ee:	83 c3 01             	add    $0x1,%ebx
  8018f1:	83 fb 20             	cmp    $0x20,%ebx
  8018f4:	75 f0                	jne    8018e6 <close_all+0xc>
		close(i);
}
  8018f6:	83 c4 14             	add    $0x14,%esp
  8018f9:	5b                   	pop    %ebx
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    

008018fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	57                   	push   %edi
  801900:	56                   	push   %esi
  801901:	53                   	push   %ebx
  801902:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801905:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801908:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	89 04 24             	mov    %eax,(%esp)
  801912:	e8 5f fe ff ff       	call   801776 <fd_lookup>
  801917:	89 c2                	mov    %eax,%edx
  801919:	85 d2                	test   %edx,%edx
  80191b:	0f 88 e1 00 00 00    	js     801a02 <dup+0x106>
		return r;
	close(newfdnum);
  801921:	8b 45 0c             	mov    0xc(%ebp),%eax
  801924:	89 04 24             	mov    %eax,(%esp)
  801927:	e8 7b ff ff ff       	call   8018a7 <close>

	newfd = INDEX2FD(newfdnum);
  80192c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80192f:	c1 e3 0c             	shl    $0xc,%ebx
  801932:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80193b:	89 04 24             	mov    %eax,(%esp)
  80193e:	e8 cd fd ff ff       	call   801710 <fd2data>
  801943:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801945:	89 1c 24             	mov    %ebx,(%esp)
  801948:	e8 c3 fd ff ff       	call   801710 <fd2data>
  80194d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80194f:	89 f0                	mov    %esi,%eax
  801951:	c1 e8 16             	shr    $0x16,%eax
  801954:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80195b:	a8 01                	test   $0x1,%al
  80195d:	74 43                	je     8019a2 <dup+0xa6>
  80195f:	89 f0                	mov    %esi,%eax
  801961:	c1 e8 0c             	shr    $0xc,%eax
  801964:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80196b:	f6 c2 01             	test   $0x1,%dl
  80196e:	74 32                	je     8019a2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801970:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801977:	25 07 0e 00 00       	and    $0xe07,%eax
  80197c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801980:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801984:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80198b:	00 
  80198c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801990:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801997:	e8 ed f3 ff ff       	call   800d89 <sys_page_map>
  80199c:	89 c6                	mov    %eax,%esi
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 3e                	js     8019e0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019a5:	89 c2                	mov    %eax,%edx
  8019a7:	c1 ea 0c             	shr    $0xc,%edx
  8019aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019b1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8019b7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8019bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8019bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019c6:	00 
  8019c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019d2:	e8 b2 f3 ff ff       	call   800d89 <sys_page_map>
  8019d7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8019d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019dc:	85 f6                	test   %esi,%esi
  8019de:	79 22                	jns    801a02 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8019e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019eb:	e8 ec f3 ff ff       	call   800ddc <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019fb:	e8 dc f3 ff ff       	call   800ddc <sys_page_unmap>
	return r;
  801a00:	89 f0                	mov    %esi,%eax
}
  801a02:	83 c4 3c             	add    $0x3c,%esp
  801a05:	5b                   	pop    %ebx
  801a06:	5e                   	pop    %esi
  801a07:	5f                   	pop    %edi
  801a08:	5d                   	pop    %ebp
  801a09:	c3                   	ret    

00801a0a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	53                   	push   %ebx
  801a0e:	83 ec 24             	sub    $0x24,%esp
  801a11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a14:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1b:	89 1c 24             	mov    %ebx,(%esp)
  801a1e:	e8 53 fd ff ff       	call   801776 <fd_lookup>
  801a23:	89 c2                	mov    %eax,%edx
  801a25:	85 d2                	test   %edx,%edx
  801a27:	78 6d                	js     801a96 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a33:	8b 00                	mov    (%eax),%eax
  801a35:	89 04 24             	mov    %eax,(%esp)
  801a38:	e8 8f fd ff ff       	call   8017cc <dev_lookup>
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	78 55                	js     801a96 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a44:	8b 50 08             	mov    0x8(%eax),%edx
  801a47:	83 e2 03             	and    $0x3,%edx
  801a4a:	83 fa 01             	cmp    $0x1,%edx
  801a4d:	75 23                	jne    801a72 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a4f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801a54:	8b 40 48             	mov    0x48(%eax),%eax
  801a57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5f:	c7 04 24 19 33 80 00 	movl   $0x803319,(%esp)
  801a66:	e8 e0 e7 ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  801a6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a70:	eb 24                	jmp    801a96 <read+0x8c>
	}
	if (!dev->dev_read)
  801a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a75:	8b 52 08             	mov    0x8(%edx),%edx
  801a78:	85 d2                	test   %edx,%edx
  801a7a:	74 15                	je     801a91 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a8a:	89 04 24             	mov    %eax,(%esp)
  801a8d:	ff d2                	call   *%edx
  801a8f:	eb 05                	jmp    801a96 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801a91:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801a96:	83 c4 24             	add    $0x24,%esp
  801a99:	5b                   	pop    %ebx
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    

00801a9c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	57                   	push   %edi
  801aa0:	56                   	push   %esi
  801aa1:	53                   	push   %ebx
  801aa2:	83 ec 1c             	sub    $0x1c,%esp
  801aa5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801aa8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801aab:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ab0:	eb 23                	jmp    801ad5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ab2:	89 f0                	mov    %esi,%eax
  801ab4:	29 d8                	sub    %ebx,%eax
  801ab6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aba:	89 d8                	mov    %ebx,%eax
  801abc:	03 45 0c             	add    0xc(%ebp),%eax
  801abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac3:	89 3c 24             	mov    %edi,(%esp)
  801ac6:	e8 3f ff ff ff       	call   801a0a <read>
		if (m < 0)
  801acb:	85 c0                	test   %eax,%eax
  801acd:	78 10                	js     801adf <readn+0x43>
			return m;
		if (m == 0)
  801acf:	85 c0                	test   %eax,%eax
  801ad1:	74 0a                	je     801add <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ad3:	01 c3                	add    %eax,%ebx
  801ad5:	39 f3                	cmp    %esi,%ebx
  801ad7:	72 d9                	jb     801ab2 <readn+0x16>
  801ad9:	89 d8                	mov    %ebx,%eax
  801adb:	eb 02                	jmp    801adf <readn+0x43>
  801add:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801adf:	83 c4 1c             	add    $0x1c,%esp
  801ae2:	5b                   	pop    %ebx
  801ae3:	5e                   	pop    %esi
  801ae4:	5f                   	pop    %edi
  801ae5:	5d                   	pop    %ebp
  801ae6:	c3                   	ret    

00801ae7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	53                   	push   %ebx
  801aeb:	83 ec 24             	sub    $0x24,%esp
  801aee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af8:	89 1c 24             	mov    %ebx,(%esp)
  801afb:	e8 76 fc ff ff       	call   801776 <fd_lookup>
  801b00:	89 c2                	mov    %eax,%edx
  801b02:	85 d2                	test   %edx,%edx
  801b04:	78 68                	js     801b6e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b10:	8b 00                	mov    (%eax),%eax
  801b12:	89 04 24             	mov    %eax,(%esp)
  801b15:	e8 b2 fc ff ff       	call   8017cc <dev_lookup>
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 50                	js     801b6e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b21:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b25:	75 23                	jne    801b4a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b27:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801b2c:	8b 40 48             	mov    0x48(%eax),%eax
  801b2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b37:	c7 04 24 35 33 80 00 	movl   $0x803335,(%esp)
  801b3e:	e8 08 e7 ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  801b43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b48:	eb 24                	jmp    801b6e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b4d:	8b 52 0c             	mov    0xc(%edx),%edx
  801b50:	85 d2                	test   %edx,%edx
  801b52:	74 15                	je     801b69 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b54:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b62:	89 04 24             	mov    %eax,(%esp)
  801b65:	ff d2                	call   *%edx
  801b67:	eb 05                	jmp    801b6e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801b69:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801b6e:	83 c4 24             	add    $0x24,%esp
  801b71:	5b                   	pop    %ebx
  801b72:	5d                   	pop    %ebp
  801b73:	c3                   	ret    

00801b74 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b7a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	89 04 24             	mov    %eax,(%esp)
  801b87:	e8 ea fb ff ff       	call   801776 <fd_lookup>
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 0e                	js     801b9e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b96:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	53                   	push   %ebx
  801ba4:	83 ec 24             	sub    $0x24,%esp
  801ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801baa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb1:	89 1c 24             	mov    %ebx,(%esp)
  801bb4:	e8 bd fb ff ff       	call   801776 <fd_lookup>
  801bb9:	89 c2                	mov    %eax,%edx
  801bbb:	85 d2                	test   %edx,%edx
  801bbd:	78 61                	js     801c20 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc9:	8b 00                	mov    (%eax),%eax
  801bcb:	89 04 24             	mov    %eax,(%esp)
  801bce:	e8 f9 fb ff ff       	call   8017cc <dev_lookup>
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	78 49                	js     801c20 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bda:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bde:	75 23                	jne    801c03 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801be0:	a1 0c 50 80 00       	mov    0x80500c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801be5:	8b 40 48             	mov    0x48(%eax),%eax
  801be8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf0:	c7 04 24 f8 32 80 00 	movl   $0x8032f8,(%esp)
  801bf7:	e8 4f e6 ff ff       	call   80024b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801bfc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c01:	eb 1d                	jmp    801c20 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c06:	8b 52 18             	mov    0x18(%edx),%edx
  801c09:	85 d2                	test   %edx,%edx
  801c0b:	74 0e                	je     801c1b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c10:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c14:	89 04 24             	mov    %eax,(%esp)
  801c17:	ff d2                	call   *%edx
  801c19:	eb 05                	jmp    801c20 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801c1b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801c20:	83 c4 24             	add    $0x24,%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5d                   	pop    %ebp
  801c25:	c3                   	ret    

00801c26 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	53                   	push   %ebx
  801c2a:	83 ec 24             	sub    $0x24,%esp
  801c2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c30:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	89 04 24             	mov    %eax,(%esp)
  801c3d:	e8 34 fb ff ff       	call   801776 <fd_lookup>
  801c42:	89 c2                	mov    %eax,%edx
  801c44:	85 d2                	test   %edx,%edx
  801c46:	78 52                	js     801c9a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c52:	8b 00                	mov    (%eax),%eax
  801c54:	89 04 24             	mov    %eax,(%esp)
  801c57:	e8 70 fb ff ff       	call   8017cc <dev_lookup>
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	78 3a                	js     801c9a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c63:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c67:	74 2c                	je     801c95 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c69:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c6c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c73:	00 00 00 
	stat->st_isdir = 0;
  801c76:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c7d:	00 00 00 
	stat->st_dev = dev;
  801c80:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c8d:	89 14 24             	mov    %edx,(%esp)
  801c90:	ff 50 14             	call   *0x14(%eax)
  801c93:	eb 05                	jmp    801c9a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801c95:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801c9a:	83 c4 24             	add    $0x24,%esp
  801c9d:	5b                   	pop    %ebx
  801c9e:	5d                   	pop    %ebp
  801c9f:	c3                   	ret    

00801ca0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
  801ca5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ca8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801caf:	00 
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	89 04 24             	mov    %eax,(%esp)
  801cb6:	e8 99 02 00 00       	call   801f54 <open>
  801cbb:	89 c3                	mov    %eax,%ebx
  801cbd:	85 db                	test   %ebx,%ebx
  801cbf:	78 1b                	js     801cdc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc8:	89 1c 24             	mov    %ebx,(%esp)
  801ccb:	e8 56 ff ff ff       	call   801c26 <fstat>
  801cd0:	89 c6                	mov    %eax,%esi
	close(fd);
  801cd2:	89 1c 24             	mov    %ebx,(%esp)
  801cd5:	e8 cd fb ff ff       	call   8018a7 <close>
	return r;
  801cda:	89 f0                	mov    %esi,%eax
}
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    

00801ce3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	56                   	push   %esi
  801ce7:	53                   	push   %ebx
  801ce8:	83 ec 10             	sub    $0x10,%esp
  801ceb:	89 c6                	mov    %eax,%esi
  801ced:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801cef:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801cf6:	75 11                	jne    801d09 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cf8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801cff:	e8 bb f9 ff ff       	call   8016bf <ipc_find_env>
  801d04:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d09:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d10:	00 
  801d11:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d18:	00 
  801d19:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d1d:	a1 00 50 80 00       	mov    0x805000,%eax
  801d22:	89 04 24             	mov    %eax,(%esp)
  801d25:	e8 2e f9 ff ff       	call   801658 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d2a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d31:	00 
  801d32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d3d:	e8 ae f8 ff ff       	call   8015f0 <ipc_recv>
}
  801d42:	83 c4 10             	add    $0x10,%esp
  801d45:	5b                   	pop    %ebx
  801d46:	5e                   	pop    %esi
  801d47:	5d                   	pop    %ebp
  801d48:	c3                   	ret    

00801d49 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	8b 40 0c             	mov    0xc(%eax),%eax
  801d55:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d62:	ba 00 00 00 00       	mov    $0x0,%edx
  801d67:	b8 02 00 00 00       	mov    $0x2,%eax
  801d6c:	e8 72 ff ff ff       	call   801ce3 <fsipc>
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d84:	ba 00 00 00 00       	mov    $0x0,%edx
  801d89:	b8 06 00 00 00       	mov    $0x6,%eax
  801d8e:	e8 50 ff ff ff       	call   801ce3 <fsipc>
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	53                   	push   %ebx
  801d99:	83 ec 14             	sub    $0x14,%esp
  801d9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	8b 40 0c             	mov    0xc(%eax),%eax
  801da5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801daa:	ba 00 00 00 00       	mov    $0x0,%edx
  801daf:	b8 05 00 00 00       	mov    $0x5,%eax
  801db4:	e8 2a ff ff ff       	call   801ce3 <fsipc>
  801db9:	89 c2                	mov    %eax,%edx
  801dbb:	85 d2                	test   %edx,%edx
  801dbd:	78 2b                	js     801dea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dbf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801dc6:	00 
  801dc7:	89 1c 24             	mov    %ebx,(%esp)
  801dca:	e8 f8 ea ff ff       	call   8008c7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801dcf:	a1 80 60 80 00       	mov    0x806080,%eax
  801dd4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dda:	a1 84 60 80 00       	mov    0x806084,%eax
  801ddf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dea:	83 c4 14             	add    $0x14,%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    

00801df0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	53                   	push   %ebx
  801df4:	83 ec 14             	sub    $0x14,%esp
  801df7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801dfa:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801e00:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801e05:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e08:	8b 55 08             	mov    0x8(%ebp),%edx
  801e0b:	8b 52 0c             	mov    0xc(%edx),%edx
  801e0e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801e14:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801e19:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e24:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801e2b:	e8 34 ec ff ff       	call   800a64 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801e30:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801e37:	00 
  801e38:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  801e3f:	e8 07 e4 ff ff       	call   80024b <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e44:	ba 00 00 00 00       	mov    $0x0,%edx
  801e49:	b8 04 00 00 00       	mov    $0x4,%eax
  801e4e:	e8 90 fe ff ff       	call   801ce3 <fsipc>
  801e53:	85 c0                	test   %eax,%eax
  801e55:	78 53                	js     801eaa <devfile_write+0xba>
		return r;
	assert(r <= n);
  801e57:	39 c3                	cmp    %eax,%ebx
  801e59:	73 24                	jae    801e7f <devfile_write+0x8f>
  801e5b:	c7 44 24 0c 6d 33 80 	movl   $0x80336d,0xc(%esp)
  801e62:	00 
  801e63:	c7 44 24 08 74 33 80 	movl   $0x803374,0x8(%esp)
  801e6a:	00 
  801e6b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801e72:	00 
  801e73:	c7 04 24 89 33 80 00 	movl   $0x803389,(%esp)
  801e7a:	e8 d7 0b 00 00       	call   802a56 <_panic>
	assert(r <= PGSIZE);
  801e7f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e84:	7e 24                	jle    801eaa <devfile_write+0xba>
  801e86:	c7 44 24 0c 94 33 80 	movl   $0x803394,0xc(%esp)
  801e8d:	00 
  801e8e:	c7 44 24 08 74 33 80 	movl   $0x803374,0x8(%esp)
  801e95:	00 
  801e96:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801e9d:	00 
  801e9e:	c7 04 24 89 33 80 00 	movl   $0x803389,(%esp)
  801ea5:	e8 ac 0b 00 00       	call   802a56 <_panic>
	return r;
}
  801eaa:	83 c4 14             	add    $0x14,%esp
  801ead:	5b                   	pop    %ebx
  801eae:	5d                   	pop    %ebp
  801eaf:	c3                   	ret    

00801eb0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	56                   	push   %esi
  801eb4:	53                   	push   %ebx
  801eb5:	83 ec 10             	sub    $0x10,%esp
  801eb8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ec6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ecc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed1:	b8 03 00 00 00       	mov    $0x3,%eax
  801ed6:	e8 08 fe ff ff       	call   801ce3 <fsipc>
  801edb:	89 c3                	mov    %eax,%ebx
  801edd:	85 c0                	test   %eax,%eax
  801edf:	78 6a                	js     801f4b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ee1:	39 c6                	cmp    %eax,%esi
  801ee3:	73 24                	jae    801f09 <devfile_read+0x59>
  801ee5:	c7 44 24 0c 6d 33 80 	movl   $0x80336d,0xc(%esp)
  801eec:	00 
  801eed:	c7 44 24 08 74 33 80 	movl   $0x803374,0x8(%esp)
  801ef4:	00 
  801ef5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801efc:	00 
  801efd:	c7 04 24 89 33 80 00 	movl   $0x803389,(%esp)
  801f04:	e8 4d 0b 00 00       	call   802a56 <_panic>
	assert(r <= PGSIZE);
  801f09:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f0e:	7e 24                	jle    801f34 <devfile_read+0x84>
  801f10:	c7 44 24 0c 94 33 80 	movl   $0x803394,0xc(%esp)
  801f17:	00 
  801f18:	c7 44 24 08 74 33 80 	movl   $0x803374,0x8(%esp)
  801f1f:	00 
  801f20:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801f27:	00 
  801f28:	c7 04 24 89 33 80 00 	movl   $0x803389,(%esp)
  801f2f:	e8 22 0b 00 00       	call   802a56 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f34:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f38:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f3f:	00 
  801f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f43:	89 04 24             	mov    %eax,(%esp)
  801f46:	e8 19 eb ff ff       	call   800a64 <memmove>
	return r;
}
  801f4b:	89 d8                	mov    %ebx,%eax
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	5b                   	pop    %ebx
  801f51:	5e                   	pop    %esi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    

00801f54 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	53                   	push   %ebx
  801f58:	83 ec 24             	sub    $0x24,%esp
  801f5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801f5e:	89 1c 24             	mov    %ebx,(%esp)
  801f61:	e8 2a e9 ff ff       	call   800890 <strlen>
  801f66:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f6b:	7f 60                	jg     801fcd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801f6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f70:	89 04 24             	mov    %eax,(%esp)
  801f73:	e8 af f7 ff ff       	call   801727 <fd_alloc>
  801f78:	89 c2                	mov    %eax,%edx
  801f7a:	85 d2                	test   %edx,%edx
  801f7c:	78 54                	js     801fd2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801f7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f82:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801f89:	e8 39 e9 ff ff       	call   8008c7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f91:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f99:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9e:	e8 40 fd ff ff       	call   801ce3 <fsipc>
  801fa3:	89 c3                	mov    %eax,%ebx
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	79 17                	jns    801fc0 <open+0x6c>
		fd_close(fd, 0);
  801fa9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fb0:	00 
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	89 04 24             	mov    %eax,(%esp)
  801fb7:	e8 6a f8 ff ff       	call   801826 <fd_close>
		return r;
  801fbc:	89 d8                	mov    %ebx,%eax
  801fbe:	eb 12                	jmp    801fd2 <open+0x7e>
	}

	return fd2num(fd);
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	89 04 24             	mov    %eax,(%esp)
  801fc6:	e8 35 f7 ff ff       	call   801700 <fd2num>
  801fcb:	eb 05                	jmp    801fd2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801fcd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801fd2:	83 c4 24             	add    $0x24,%esp
  801fd5:	5b                   	pop    %ebx
  801fd6:	5d                   	pop    %ebp
  801fd7:	c3                   	ret    

00801fd8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fde:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe3:	b8 08 00 00 00       	mov    $0x8,%eax
  801fe8:	e8 f6 fc ff ff       	call   801ce3 <fsipc>
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <evict>:

int evict(void)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801ff5:	c7 04 24 a0 33 80 00 	movl   $0x8033a0,(%esp)
  801ffc:	e8 4a e2 ff ff       	call   80024b <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  802001:	ba 00 00 00 00       	mov    $0x0,%edx
  802006:	b8 09 00 00 00       	mov    $0x9,%eax
  80200b:	e8 d3 fc ff ff       	call   801ce3 <fsipc>
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    
  802012:	66 90                	xchg   %ax,%ax
  802014:	66 90                	xchg   %ax,%ax
  802016:	66 90                	xchg   %ax,%ax
  802018:	66 90                	xchg   %ax,%ax
  80201a:	66 90                	xchg   %ax,%ax
  80201c:	66 90                	xchg   %ax,%ax
  80201e:	66 90                	xchg   %ax,%ax

00802020 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802026:	c7 44 24 04 b9 33 80 	movl   $0x8033b9,0x4(%esp)
  80202d:	00 
  80202e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802031:	89 04 24             	mov    %eax,(%esp)
  802034:	e8 8e e8 ff ff       	call   8008c7 <strcpy>
	return 0;
}
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	53                   	push   %ebx
  802044:	83 ec 14             	sub    $0x14,%esp
  802047:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80204a:	89 1c 24             	mov    %ebx,(%esp)
  80204d:	e8 13 0b 00 00       	call   802b65 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802052:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802057:	83 f8 01             	cmp    $0x1,%eax
  80205a:	75 0d                	jne    802069 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80205c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80205f:	89 04 24             	mov    %eax,(%esp)
  802062:	e8 29 03 00 00       	call   802390 <nsipc_close>
  802067:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802069:	89 d0                	mov    %edx,%eax
  80206b:	83 c4 14             	add    $0x14,%esp
  80206e:	5b                   	pop    %ebx
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    

00802071 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802077:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80207e:	00 
  80207f:	8b 45 10             	mov    0x10(%ebp),%eax
  802082:	89 44 24 08          	mov    %eax,0x8(%esp)
  802086:	8b 45 0c             	mov    0xc(%ebp),%eax
  802089:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	8b 40 0c             	mov    0xc(%eax),%eax
  802093:	89 04 24             	mov    %eax,(%esp)
  802096:	e8 f0 03 00 00       	call   80248b <nsipc_send>
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020aa:	00 
  8020ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8020bf:	89 04 24             	mov    %eax,(%esp)
  8020c2:	e8 44 03 00 00       	call   80240b <nsipc_recv>
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020cf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020d2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020d6:	89 04 24             	mov    %eax,(%esp)
  8020d9:	e8 98 f6 ff ff       	call   801776 <fd_lookup>
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	78 17                	js     8020f9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8020eb:	39 08                	cmp    %ecx,(%eax)
  8020ed:	75 05                	jne    8020f4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8020ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f2:	eb 05                	jmp    8020f9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8020f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	56                   	push   %esi
  8020ff:	53                   	push   %ebx
  802100:	83 ec 20             	sub    $0x20,%esp
  802103:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802105:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802108:	89 04 24             	mov    %eax,(%esp)
  80210b:	e8 17 f6 ff ff       	call   801727 <fd_alloc>
  802110:	89 c3                	mov    %eax,%ebx
  802112:	85 c0                	test   %eax,%eax
  802114:	78 21                	js     802137 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802116:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80211d:	00 
  80211e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802121:	89 44 24 04          	mov    %eax,0x4(%esp)
  802125:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80212c:	e8 04 ec ff ff       	call   800d35 <sys_page_alloc>
  802131:	89 c3                	mov    %eax,%ebx
  802133:	85 c0                	test   %eax,%eax
  802135:	79 0c                	jns    802143 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802137:	89 34 24             	mov    %esi,(%esp)
  80213a:	e8 51 02 00 00       	call   802390 <nsipc_close>
		return r;
  80213f:	89 d8                	mov    %ebx,%eax
  802141:	eb 20                	jmp    802163 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802143:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80214e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802151:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802158:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80215b:	89 14 24             	mov    %edx,(%esp)
  80215e:	e8 9d f5 ff ff       	call   801700 <fd2num>
}
  802163:	83 c4 20             	add    $0x20,%esp
  802166:	5b                   	pop    %ebx
  802167:	5e                   	pop    %esi
  802168:	5d                   	pop    %ebp
  802169:	c3                   	ret    

0080216a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	e8 51 ff ff ff       	call   8020c9 <fd2sockid>
		return r;
  802178:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80217a:	85 c0                	test   %eax,%eax
  80217c:	78 23                	js     8021a1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80217e:	8b 55 10             	mov    0x10(%ebp),%edx
  802181:	89 54 24 08          	mov    %edx,0x8(%esp)
  802185:	8b 55 0c             	mov    0xc(%ebp),%edx
  802188:	89 54 24 04          	mov    %edx,0x4(%esp)
  80218c:	89 04 24             	mov    %eax,(%esp)
  80218f:	e8 45 01 00 00       	call   8022d9 <nsipc_accept>
		return r;
  802194:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802196:	85 c0                	test   %eax,%eax
  802198:	78 07                	js     8021a1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80219a:	e8 5c ff ff ff       	call   8020fb <alloc_sockfd>
  80219f:	89 c1                	mov    %eax,%ecx
}
  8021a1:	89 c8                	mov    %ecx,%eax
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	e8 16 ff ff ff       	call   8020c9 <fd2sockid>
  8021b3:	89 c2                	mov    %eax,%edx
  8021b5:	85 d2                	test   %edx,%edx
  8021b7:	78 16                	js     8021cf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8021b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c7:	89 14 24             	mov    %edx,(%esp)
  8021ca:	e8 60 01 00 00       	call   80232f <nsipc_bind>
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <shutdown>:

int
shutdown(int s, int how)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	e8 ea fe ff ff       	call   8020c9 <fd2sockid>
  8021df:	89 c2                	mov    %eax,%edx
  8021e1:	85 d2                	test   %edx,%edx
  8021e3:	78 0f                	js     8021f4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8021e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ec:	89 14 24             	mov    %edx,(%esp)
  8021ef:	e8 7a 01 00 00       	call   80236e <nsipc_shutdown>
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	e8 c5 fe ff ff       	call   8020c9 <fd2sockid>
  802204:	89 c2                	mov    %eax,%edx
  802206:	85 d2                	test   %edx,%edx
  802208:	78 16                	js     802220 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80220a:	8b 45 10             	mov    0x10(%ebp),%eax
  80220d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802211:	8b 45 0c             	mov    0xc(%ebp),%eax
  802214:	89 44 24 04          	mov    %eax,0x4(%esp)
  802218:	89 14 24             	mov    %edx,(%esp)
  80221b:	e8 8a 01 00 00       	call   8023aa <nsipc_connect>
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <listen>:

int
listen(int s, int backlog)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	e8 99 fe ff ff       	call   8020c9 <fd2sockid>
  802230:	89 c2                	mov    %eax,%edx
  802232:	85 d2                	test   %edx,%edx
  802234:	78 0f                	js     802245 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802236:	8b 45 0c             	mov    0xc(%ebp),%eax
  802239:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223d:	89 14 24             	mov    %edx,(%esp)
  802240:	e8 a4 01 00 00       	call   8023e9 <nsipc_listen>
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
  80224a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80224d:	8b 45 10             	mov    0x10(%ebp),%eax
  802250:	89 44 24 08          	mov    %eax,0x8(%esp)
  802254:	8b 45 0c             	mov    0xc(%ebp),%eax
  802257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	89 04 24             	mov    %eax,(%esp)
  802261:	e8 98 02 00 00       	call   8024fe <nsipc_socket>
  802266:	89 c2                	mov    %eax,%edx
  802268:	85 d2                	test   %edx,%edx
  80226a:	78 05                	js     802271 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80226c:	e8 8a fe ff ff       	call   8020fb <alloc_sockfd>
}
  802271:	c9                   	leave  
  802272:	c3                   	ret    

00802273 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	53                   	push   %ebx
  802277:	83 ec 14             	sub    $0x14,%esp
  80227a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80227c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802283:	75 11                	jne    802296 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802285:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80228c:	e8 2e f4 ff ff       	call   8016bf <ipc_find_env>
  802291:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802296:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80229d:	00 
  80229e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8022a5:	00 
  8022a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022aa:	a1 04 50 80 00       	mov    0x805004,%eax
  8022af:	89 04 24             	mov    %eax,(%esp)
  8022b2:	e8 a1 f3 ff ff       	call   801658 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022be:	00 
  8022bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022c6:	00 
  8022c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022ce:	e8 1d f3 ff ff       	call   8015f0 <ipc_recv>
}
  8022d3:	83 c4 14             	add    $0x14,%esp
  8022d6:	5b                   	pop    %ebx
  8022d7:	5d                   	pop    %ebp
  8022d8:	c3                   	ret    

008022d9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	56                   	push   %esi
  8022dd:	53                   	push   %ebx
  8022de:	83 ec 10             	sub    $0x10,%esp
  8022e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022ec:	8b 06                	mov    (%esi),%eax
  8022ee:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f8:	e8 76 ff ff ff       	call   802273 <nsipc>
  8022fd:	89 c3                	mov    %eax,%ebx
  8022ff:	85 c0                	test   %eax,%eax
  802301:	78 23                	js     802326 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802303:	a1 10 70 80 00       	mov    0x807010,%eax
  802308:	89 44 24 08          	mov    %eax,0x8(%esp)
  80230c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802313:	00 
  802314:	8b 45 0c             	mov    0xc(%ebp),%eax
  802317:	89 04 24             	mov    %eax,(%esp)
  80231a:	e8 45 e7 ff ff       	call   800a64 <memmove>
		*addrlen = ret->ret_addrlen;
  80231f:	a1 10 70 80 00       	mov    0x807010,%eax
  802324:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802326:	89 d8                	mov    %ebx,%eax
  802328:	83 c4 10             	add    $0x10,%esp
  80232b:	5b                   	pop    %ebx
  80232c:	5e                   	pop    %esi
  80232d:	5d                   	pop    %ebp
  80232e:	c3                   	ret    

0080232f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	53                   	push   %ebx
  802333:	83 ec 14             	sub    $0x14,%esp
  802336:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802341:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802345:	8b 45 0c             	mov    0xc(%ebp),%eax
  802348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802353:	e8 0c e7 ff ff       	call   800a64 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802358:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80235e:	b8 02 00 00 00       	mov    $0x2,%eax
  802363:	e8 0b ff ff ff       	call   802273 <nsipc>
}
  802368:	83 c4 14             	add    $0x14,%esp
  80236b:	5b                   	pop    %ebx
  80236c:	5d                   	pop    %ebp
  80236d:	c3                   	ret    

0080236e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80237c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802384:	b8 03 00 00 00       	mov    $0x3,%eax
  802389:	e8 e5 fe ff ff       	call   802273 <nsipc>
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <nsipc_close>:

int
nsipc_close(int s)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80239e:	b8 04 00 00 00       	mov    $0x4,%eax
  8023a3:	e8 cb fe ff ff       	call   802273 <nsipc>
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	53                   	push   %ebx
  8023ae:	83 ec 14             	sub    $0x14,%esp
  8023b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8023ce:	e8 91 e6 ff ff       	call   800a64 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023d3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8023de:	e8 90 fe ff ff       	call   802273 <nsipc>
}
  8023e3:	83 c4 14             	add    $0x14,%esp
  8023e6:	5b                   	pop    %ebx
  8023e7:	5d                   	pop    %ebp
  8023e8:	c3                   	ret    

008023e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
  8023ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023ff:	b8 06 00 00 00       	mov    $0x6,%eax
  802404:	e8 6a fe ff ff       	call   802273 <nsipc>
}
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
  80240e:	56                   	push   %esi
  80240f:	53                   	push   %ebx
  802410:	83 ec 10             	sub    $0x10,%esp
  802413:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802416:	8b 45 08             	mov    0x8(%ebp),%eax
  802419:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80241e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802424:	8b 45 14             	mov    0x14(%ebp),%eax
  802427:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80242c:	b8 07 00 00 00       	mov    $0x7,%eax
  802431:	e8 3d fe ff ff       	call   802273 <nsipc>
  802436:	89 c3                	mov    %eax,%ebx
  802438:	85 c0                	test   %eax,%eax
  80243a:	78 46                	js     802482 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80243c:	39 f0                	cmp    %esi,%eax
  80243e:	7f 07                	jg     802447 <nsipc_recv+0x3c>
  802440:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802445:	7e 24                	jle    80246b <nsipc_recv+0x60>
  802447:	c7 44 24 0c c5 33 80 	movl   $0x8033c5,0xc(%esp)
  80244e:	00 
  80244f:	c7 44 24 08 74 33 80 	movl   $0x803374,0x8(%esp)
  802456:	00 
  802457:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80245e:	00 
  80245f:	c7 04 24 da 33 80 00 	movl   $0x8033da,(%esp)
  802466:	e8 eb 05 00 00       	call   802a56 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80246b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80246f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802476:	00 
  802477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247a:	89 04 24             	mov    %eax,(%esp)
  80247d:	e8 e2 e5 ff ff       	call   800a64 <memmove>
	}

	return r;
}
  802482:	89 d8                	mov    %ebx,%eax
  802484:	83 c4 10             	add    $0x10,%esp
  802487:	5b                   	pop    %ebx
  802488:	5e                   	pop    %esi
  802489:	5d                   	pop    %ebp
  80248a:	c3                   	ret    

0080248b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
  80248e:	53                   	push   %ebx
  80248f:	83 ec 14             	sub    $0x14,%esp
  802492:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80249d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8024a3:	7e 24                	jle    8024c9 <nsipc_send+0x3e>
  8024a5:	c7 44 24 0c e6 33 80 	movl   $0x8033e6,0xc(%esp)
  8024ac:	00 
  8024ad:	c7 44 24 08 74 33 80 	movl   $0x803374,0x8(%esp)
  8024b4:	00 
  8024b5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8024bc:	00 
  8024bd:	c7 04 24 da 33 80 00 	movl   $0x8033da,(%esp)
  8024c4:	e8 8d 05 00 00       	call   802a56 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8024c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8024db:	e8 84 e5 ff ff       	call   800a64 <memmove>
	nsipcbuf.send.req_size = size;
  8024e0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8024e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8024e9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8024ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8024f3:	e8 7b fd ff ff       	call   802273 <nsipc>
}
  8024f8:	83 c4 14             	add    $0x14,%esp
  8024fb:	5b                   	pop    %ebx
  8024fc:	5d                   	pop    %ebp
  8024fd:	c3                   	ret    

008024fe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80250c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802514:	8b 45 10             	mov    0x10(%ebp),%eax
  802517:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80251c:	b8 09 00 00 00       	mov    $0x9,%eax
  802521:	e8 4d fd ff ff       	call   802273 <nsipc>
}
  802526:	c9                   	leave  
  802527:	c3                   	ret    

00802528 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802528:	55                   	push   %ebp
  802529:	89 e5                	mov    %esp,%ebp
  80252b:	56                   	push   %esi
  80252c:	53                   	push   %ebx
  80252d:	83 ec 10             	sub    $0x10,%esp
  802530:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	89 04 24             	mov    %eax,(%esp)
  802539:	e8 d2 f1 ff ff       	call   801710 <fd2data>
  80253e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802540:	c7 44 24 04 f2 33 80 	movl   $0x8033f2,0x4(%esp)
  802547:	00 
  802548:	89 1c 24             	mov    %ebx,(%esp)
  80254b:	e8 77 e3 ff ff       	call   8008c7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802550:	8b 46 04             	mov    0x4(%esi),%eax
  802553:	2b 06                	sub    (%esi),%eax
  802555:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80255b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802562:	00 00 00 
	stat->st_dev = &devpipe;
  802565:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80256c:	40 80 00 
	return 0;
}
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
  802574:	83 c4 10             	add    $0x10,%esp
  802577:	5b                   	pop    %ebx
  802578:	5e                   	pop    %esi
  802579:	5d                   	pop    %ebp
  80257a:	c3                   	ret    

0080257b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	53                   	push   %ebx
  80257f:	83 ec 14             	sub    $0x14,%esp
  802582:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802585:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802589:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802590:	e8 47 e8 ff ff       	call   800ddc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802595:	89 1c 24             	mov    %ebx,(%esp)
  802598:	e8 73 f1 ff ff       	call   801710 <fd2data>
  80259d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a8:	e8 2f e8 ff ff       	call   800ddc <sys_page_unmap>
}
  8025ad:	83 c4 14             	add    $0x14,%esp
  8025b0:	5b                   	pop    %ebx
  8025b1:	5d                   	pop    %ebp
  8025b2:	c3                   	ret    

008025b3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
  8025b6:	57                   	push   %edi
  8025b7:	56                   	push   %esi
  8025b8:	53                   	push   %ebx
  8025b9:	83 ec 2c             	sub    $0x2c,%esp
  8025bc:	89 c6                	mov    %eax,%esi
  8025be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8025c1:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8025c6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025c9:	89 34 24             	mov    %esi,(%esp)
  8025cc:	e8 94 05 00 00       	call   802b65 <pageref>
  8025d1:	89 c7                	mov    %eax,%edi
  8025d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d6:	89 04 24             	mov    %eax,(%esp)
  8025d9:	e8 87 05 00 00       	call   802b65 <pageref>
  8025de:	39 c7                	cmp    %eax,%edi
  8025e0:	0f 94 c2             	sete   %dl
  8025e3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8025e6:	8b 0d 0c 50 80 00    	mov    0x80500c,%ecx
  8025ec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8025ef:	39 fb                	cmp    %edi,%ebx
  8025f1:	74 21                	je     802614 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8025f3:	84 d2                	test   %dl,%dl
  8025f5:	74 ca                	je     8025c1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8025f7:	8b 51 58             	mov    0x58(%ecx),%edx
  8025fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025fe:	89 54 24 08          	mov    %edx,0x8(%esp)
  802602:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802606:	c7 04 24 f9 33 80 00 	movl   $0x8033f9,(%esp)
  80260d:	e8 39 dc ff ff       	call   80024b <cprintf>
  802612:	eb ad                	jmp    8025c1 <_pipeisclosed+0xe>
	}
}
  802614:	83 c4 2c             	add    $0x2c,%esp
  802617:	5b                   	pop    %ebx
  802618:	5e                   	pop    %esi
  802619:	5f                   	pop    %edi
  80261a:	5d                   	pop    %ebp
  80261b:	c3                   	ret    

0080261c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	57                   	push   %edi
  802620:	56                   	push   %esi
  802621:	53                   	push   %ebx
  802622:	83 ec 1c             	sub    $0x1c,%esp
  802625:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802628:	89 34 24             	mov    %esi,(%esp)
  80262b:	e8 e0 f0 ff ff       	call   801710 <fd2data>
  802630:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802632:	bf 00 00 00 00       	mov    $0x0,%edi
  802637:	eb 45                	jmp    80267e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802639:	89 da                	mov    %ebx,%edx
  80263b:	89 f0                	mov    %esi,%eax
  80263d:	e8 71 ff ff ff       	call   8025b3 <_pipeisclosed>
  802642:	85 c0                	test   %eax,%eax
  802644:	75 41                	jne    802687 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802646:	e8 cb e6 ff ff       	call   800d16 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80264b:	8b 43 04             	mov    0x4(%ebx),%eax
  80264e:	8b 0b                	mov    (%ebx),%ecx
  802650:	8d 51 20             	lea    0x20(%ecx),%edx
  802653:	39 d0                	cmp    %edx,%eax
  802655:	73 e2                	jae    802639 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802657:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80265a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80265e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802661:	99                   	cltd   
  802662:	c1 ea 1b             	shr    $0x1b,%edx
  802665:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802668:	83 e1 1f             	and    $0x1f,%ecx
  80266b:	29 d1                	sub    %edx,%ecx
  80266d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802671:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802675:	83 c0 01             	add    $0x1,%eax
  802678:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80267b:	83 c7 01             	add    $0x1,%edi
  80267e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802681:	75 c8                	jne    80264b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802683:	89 f8                	mov    %edi,%eax
  802685:	eb 05                	jmp    80268c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802687:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80268c:	83 c4 1c             	add    $0x1c,%esp
  80268f:	5b                   	pop    %ebx
  802690:	5e                   	pop    %esi
  802691:	5f                   	pop    %edi
  802692:	5d                   	pop    %ebp
  802693:	c3                   	ret    

00802694 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802694:	55                   	push   %ebp
  802695:	89 e5                	mov    %esp,%ebp
  802697:	57                   	push   %edi
  802698:	56                   	push   %esi
  802699:	53                   	push   %ebx
  80269a:	83 ec 1c             	sub    $0x1c,%esp
  80269d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8026a0:	89 3c 24             	mov    %edi,(%esp)
  8026a3:	e8 68 f0 ff ff       	call   801710 <fd2data>
  8026a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026aa:	be 00 00 00 00       	mov    $0x0,%esi
  8026af:	eb 3d                	jmp    8026ee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8026b1:	85 f6                	test   %esi,%esi
  8026b3:	74 04                	je     8026b9 <devpipe_read+0x25>
				return i;
  8026b5:	89 f0                	mov    %esi,%eax
  8026b7:	eb 43                	jmp    8026fc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8026b9:	89 da                	mov    %ebx,%edx
  8026bb:	89 f8                	mov    %edi,%eax
  8026bd:	e8 f1 fe ff ff       	call   8025b3 <_pipeisclosed>
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	75 31                	jne    8026f7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8026c6:	e8 4b e6 ff ff       	call   800d16 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8026cb:	8b 03                	mov    (%ebx),%eax
  8026cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026d0:	74 df                	je     8026b1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026d2:	99                   	cltd   
  8026d3:	c1 ea 1b             	shr    $0x1b,%edx
  8026d6:	01 d0                	add    %edx,%eax
  8026d8:	83 e0 1f             	and    $0x1f,%eax
  8026db:	29 d0                	sub    %edx,%eax
  8026dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8026e8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026eb:	83 c6 01             	add    $0x1,%esi
  8026ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026f1:	75 d8                	jne    8026cb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8026f3:	89 f0                	mov    %esi,%eax
  8026f5:	eb 05                	jmp    8026fc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026f7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8026fc:	83 c4 1c             	add    $0x1c,%esp
  8026ff:	5b                   	pop    %ebx
  802700:	5e                   	pop    %esi
  802701:	5f                   	pop    %edi
  802702:	5d                   	pop    %ebp
  802703:	c3                   	ret    

00802704 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802704:	55                   	push   %ebp
  802705:	89 e5                	mov    %esp,%ebp
  802707:	56                   	push   %esi
  802708:	53                   	push   %ebx
  802709:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80270c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80270f:	89 04 24             	mov    %eax,(%esp)
  802712:	e8 10 f0 ff ff       	call   801727 <fd_alloc>
  802717:	89 c2                	mov    %eax,%edx
  802719:	85 d2                	test   %edx,%edx
  80271b:	0f 88 4d 01 00 00    	js     80286e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802721:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802728:	00 
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802730:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802737:	e8 f9 e5 ff ff       	call   800d35 <sys_page_alloc>
  80273c:	89 c2                	mov    %eax,%edx
  80273e:	85 d2                	test   %edx,%edx
  802740:	0f 88 28 01 00 00    	js     80286e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802746:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802749:	89 04 24             	mov    %eax,(%esp)
  80274c:	e8 d6 ef ff ff       	call   801727 <fd_alloc>
  802751:	89 c3                	mov    %eax,%ebx
  802753:	85 c0                	test   %eax,%eax
  802755:	0f 88 fe 00 00 00    	js     802859 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80275b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802762:	00 
  802763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802766:	89 44 24 04          	mov    %eax,0x4(%esp)
  80276a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802771:	e8 bf e5 ff ff       	call   800d35 <sys_page_alloc>
  802776:	89 c3                	mov    %eax,%ebx
  802778:	85 c0                	test   %eax,%eax
  80277a:	0f 88 d9 00 00 00    	js     802859 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	89 04 24             	mov    %eax,(%esp)
  802786:	e8 85 ef ff ff       	call   801710 <fd2data>
  80278b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80278d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802794:	00 
  802795:	89 44 24 04          	mov    %eax,0x4(%esp)
  802799:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027a0:	e8 90 e5 ff ff       	call   800d35 <sys_page_alloc>
  8027a5:	89 c3                	mov    %eax,%ebx
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	0f 88 97 00 00 00    	js     802846 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b2:	89 04 24             	mov    %eax,(%esp)
  8027b5:	e8 56 ef ff ff       	call   801710 <fd2data>
  8027ba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8027c1:	00 
  8027c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8027cd:	00 
  8027ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d9:	e8 ab e5 ff ff       	call   800d89 <sys_page_map>
  8027de:	89 c3                	mov    %eax,%ebx
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	78 52                	js     802836 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8027e4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8027f9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8027ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802802:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802807:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	89 04 24             	mov    %eax,(%esp)
  802814:	e8 e7 ee ff ff       	call   801700 <fd2num>
  802819:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80281c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80281e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802821:	89 04 24             	mov    %eax,(%esp)
  802824:	e8 d7 ee ff ff       	call   801700 <fd2num>
  802829:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80282c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80282f:	b8 00 00 00 00       	mov    $0x0,%eax
  802834:	eb 38                	jmp    80286e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802836:	89 74 24 04          	mov    %esi,0x4(%esp)
  80283a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802841:	e8 96 e5 ff ff       	call   800ddc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802849:	89 44 24 04          	mov    %eax,0x4(%esp)
  80284d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802854:	e8 83 e5 ff ff       	call   800ddc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802860:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802867:	e8 70 e5 ff ff       	call   800ddc <sys_page_unmap>
  80286c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80286e:	83 c4 30             	add    $0x30,%esp
  802871:	5b                   	pop    %ebx
  802872:	5e                   	pop    %esi
  802873:	5d                   	pop    %ebp
  802874:	c3                   	ret    

00802875 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
  802878:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80287b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80287e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802882:	8b 45 08             	mov    0x8(%ebp),%eax
  802885:	89 04 24             	mov    %eax,(%esp)
  802888:	e8 e9 ee ff ff       	call   801776 <fd_lookup>
  80288d:	89 c2                	mov    %eax,%edx
  80288f:	85 d2                	test   %edx,%edx
  802891:	78 15                	js     8028a8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	89 04 24             	mov    %eax,(%esp)
  802899:	e8 72 ee ff ff       	call   801710 <fd2data>
	return _pipeisclosed(fd, p);
  80289e:	89 c2                	mov    %eax,%edx
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	e8 0b fd ff ff       	call   8025b3 <_pipeisclosed>
}
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    
  8028aa:	66 90                	xchg   %ax,%ax
  8028ac:	66 90                	xchg   %ax,%ax
  8028ae:	66 90                	xchg   %ax,%ax

008028b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8028b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b8:	5d                   	pop    %ebp
  8028b9:	c3                   	ret    

008028ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8028ba:	55                   	push   %ebp
  8028bb:	89 e5                	mov    %esp,%ebp
  8028bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8028c0:	c7 44 24 04 11 34 80 	movl   $0x803411,0x4(%esp)
  8028c7:	00 
  8028c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028cb:	89 04 24             	mov    %eax,(%esp)
  8028ce:	e8 f4 df ff ff       	call   8008c7 <strcpy>
	return 0;
}
  8028d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    

008028da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
  8028dd:	57                   	push   %edi
  8028de:	56                   	push   %esi
  8028df:	53                   	push   %ebx
  8028e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028f1:	eb 31                	jmp    802924 <devcons_write+0x4a>
		m = n - tot;
  8028f3:	8b 75 10             	mov    0x10(%ebp),%esi
  8028f6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8028f8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8028fb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802900:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802903:	89 74 24 08          	mov    %esi,0x8(%esp)
  802907:	03 45 0c             	add    0xc(%ebp),%eax
  80290a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80290e:	89 3c 24             	mov    %edi,(%esp)
  802911:	e8 4e e1 ff ff       	call   800a64 <memmove>
		sys_cputs(buf, m);
  802916:	89 74 24 04          	mov    %esi,0x4(%esp)
  80291a:	89 3c 24             	mov    %edi,(%esp)
  80291d:	e8 f4 e2 ff ff       	call   800c16 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802922:	01 f3                	add    %esi,%ebx
  802924:	89 d8                	mov    %ebx,%eax
  802926:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802929:	72 c8                	jb     8028f3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80292b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802931:	5b                   	pop    %ebx
  802932:	5e                   	pop    %esi
  802933:	5f                   	pop    %edi
  802934:	5d                   	pop    %ebp
  802935:	c3                   	ret    

00802936 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
  802939:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80293c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802941:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802945:	75 07                	jne    80294e <devcons_read+0x18>
  802947:	eb 2a                	jmp    802973 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802949:	e8 c8 e3 ff ff       	call   800d16 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80294e:	66 90                	xchg   %ax,%ax
  802950:	e8 df e2 ff ff       	call   800c34 <sys_cgetc>
  802955:	85 c0                	test   %eax,%eax
  802957:	74 f0                	je     802949 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802959:	85 c0                	test   %eax,%eax
  80295b:	78 16                	js     802973 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80295d:	83 f8 04             	cmp    $0x4,%eax
  802960:	74 0c                	je     80296e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802962:	8b 55 0c             	mov    0xc(%ebp),%edx
  802965:	88 02                	mov    %al,(%edx)
	return 1;
  802967:	b8 01 00 00 00       	mov    $0x1,%eax
  80296c:	eb 05                	jmp    802973 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80296e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802973:	c9                   	leave  
  802974:	c3                   	ret    

00802975 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
  802978:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802981:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802988:	00 
  802989:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80298c:	89 04 24             	mov    %eax,(%esp)
  80298f:	e8 82 e2 ff ff       	call   800c16 <sys_cputs>
}
  802994:	c9                   	leave  
  802995:	c3                   	ret    

00802996 <getchar>:

int
getchar(void)
{
  802996:	55                   	push   %ebp
  802997:	89 e5                	mov    %esp,%ebp
  802999:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80299c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8029a3:	00 
  8029a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029b2:	e8 53 f0 ff ff       	call   801a0a <read>
	if (r < 0)
  8029b7:	85 c0                	test   %eax,%eax
  8029b9:	78 0f                	js     8029ca <getchar+0x34>
		return r;
	if (r < 1)
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	7e 06                	jle    8029c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8029bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8029c3:	eb 05                	jmp    8029ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8029c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8029ca:	c9                   	leave  
  8029cb:	c3                   	ret    

008029cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8029cc:	55                   	push   %ebp
  8029cd:	89 e5                	mov    %esp,%ebp
  8029cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	89 04 24             	mov    %eax,(%esp)
  8029df:	e8 92 ed ff ff       	call   801776 <fd_lookup>
  8029e4:	85 c0                	test   %eax,%eax
  8029e6:	78 11                	js     8029f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029f1:	39 10                	cmp    %edx,(%eax)
  8029f3:	0f 94 c0             	sete   %al
  8029f6:	0f b6 c0             	movzbl %al,%eax
}
  8029f9:	c9                   	leave  
  8029fa:	c3                   	ret    

008029fb <opencons>:

int
opencons(void)
{
  8029fb:	55                   	push   %ebp
  8029fc:	89 e5                	mov    %esp,%ebp
  8029fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a04:	89 04 24             	mov    %eax,(%esp)
  802a07:	e8 1b ed ff ff       	call   801727 <fd_alloc>
		return r;
  802a0c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	78 40                	js     802a52 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a12:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a19:	00 
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a28:	e8 08 e3 ff ff       	call   800d35 <sys_page_alloc>
		return r;
  802a2d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	78 1f                	js     802a52 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a33:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a48:	89 04 24             	mov    %eax,(%esp)
  802a4b:	e8 b0 ec ff ff       	call   801700 <fd2num>
  802a50:	89 c2                	mov    %eax,%edx
}
  802a52:	89 d0                	mov    %edx,%eax
  802a54:	c9                   	leave  
  802a55:	c3                   	ret    

00802a56 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
  802a59:	56                   	push   %esi
  802a5a:	53                   	push   %ebx
  802a5b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  802a5e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802a61:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802a67:	e8 8b e2 ff ff       	call   800cf7 <sys_getenvid>
  802a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a6f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802a73:	8b 55 08             	mov    0x8(%ebp),%edx
  802a76:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802a7a:	89 74 24 08          	mov    %esi,0x8(%esp)
  802a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a82:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  802a89:	e8 bd d7 ff ff       	call   80024b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802a8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a92:	8b 45 10             	mov    0x10(%ebp),%eax
  802a95:	89 04 24             	mov    %eax,(%esp)
  802a98:	e8 4d d7 ff ff       	call   8001ea <vcprintf>
	cprintf("\n");
  802a9d:	c7 04 24 b7 33 80 00 	movl   $0x8033b7,(%esp)
  802aa4:	e8 a2 d7 ff ff       	call   80024b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802aa9:	cc                   	int3   
  802aaa:	eb fd                	jmp    802aa9 <_panic+0x53>

00802aac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802aac:	55                   	push   %ebp
  802aad:	89 e5                	mov    %esp,%ebp
  802aaf:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802ab2:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802ab9:	75 7a                	jne    802b35 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802abb:	e8 37 e2 ff ff       	call   800cf7 <sys_getenvid>
  802ac0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802ac7:	00 
  802ac8:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802acf:	ee 
  802ad0:	89 04 24             	mov    %eax,(%esp)
  802ad3:	e8 5d e2 ff ff       	call   800d35 <sys_page_alloc>
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	79 20                	jns    802afc <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802adc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ae0:	c7 44 24 08 09 32 80 	movl   $0x803209,0x8(%esp)
  802ae7:	00 
  802ae8:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802aef:	00 
  802af0:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  802af7:	e8 5a ff ff ff       	call   802a56 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802afc:	e8 f6 e1 ff ff       	call   800cf7 <sys_getenvid>
  802b01:	c7 44 24 04 3f 2b 80 	movl   $0x802b3f,0x4(%esp)
  802b08:	00 
  802b09:	89 04 24             	mov    %eax,(%esp)
  802b0c:	e8 e4 e3 ff ff       	call   800ef5 <sys_env_set_pgfault_upcall>
  802b11:	85 c0                	test   %eax,%eax
  802b13:	79 20                	jns    802b35 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802b15:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b19:	c7 44 24 08 88 32 80 	movl   $0x803288,0x8(%esp)
  802b20:	00 
  802b21:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802b28:	00 
  802b29:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  802b30:	e8 21 ff ff ff       	call   802a56 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802b3d:	c9                   	leave  
  802b3e:	c3                   	ret    

00802b3f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b3f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b40:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802b45:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b47:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802b4a:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802b4e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802b52:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802b55:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802b59:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802b5b:	83 c4 08             	add    $0x8,%esp
	popal
  802b5e:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802b5f:	83 c4 04             	add    $0x4,%esp
	popfl
  802b62:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802b63:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802b64:	c3                   	ret    

00802b65 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b65:	55                   	push   %ebp
  802b66:	89 e5                	mov    %esp,%ebp
  802b68:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b6b:	89 d0                	mov    %edx,%eax
  802b6d:	c1 e8 16             	shr    $0x16,%eax
  802b70:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b77:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b7c:	f6 c1 01             	test   $0x1,%cl
  802b7f:	74 1d                	je     802b9e <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b81:	c1 ea 0c             	shr    $0xc,%edx
  802b84:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b8b:	f6 c2 01             	test   $0x1,%dl
  802b8e:	74 0e                	je     802b9e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b90:	c1 ea 0c             	shr    $0xc,%edx
  802b93:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b9a:	ef 
  802b9b:	0f b7 c0             	movzwl %ax,%eax
}
  802b9e:	5d                   	pop    %ebp
  802b9f:	c3                   	ret    

00802ba0 <__udivdi3>:
  802ba0:	55                   	push   %ebp
  802ba1:	57                   	push   %edi
  802ba2:	56                   	push   %esi
  802ba3:	83 ec 0c             	sub    $0xc,%esp
  802ba6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802baa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802bae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802bb2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802bbc:	89 ea                	mov    %ebp,%edx
  802bbe:	89 0c 24             	mov    %ecx,(%esp)
  802bc1:	75 2d                	jne    802bf0 <__udivdi3+0x50>
  802bc3:	39 e9                	cmp    %ebp,%ecx
  802bc5:	77 61                	ja     802c28 <__udivdi3+0x88>
  802bc7:	85 c9                	test   %ecx,%ecx
  802bc9:	89 ce                	mov    %ecx,%esi
  802bcb:	75 0b                	jne    802bd8 <__udivdi3+0x38>
  802bcd:	b8 01 00 00 00       	mov    $0x1,%eax
  802bd2:	31 d2                	xor    %edx,%edx
  802bd4:	f7 f1                	div    %ecx
  802bd6:	89 c6                	mov    %eax,%esi
  802bd8:	31 d2                	xor    %edx,%edx
  802bda:	89 e8                	mov    %ebp,%eax
  802bdc:	f7 f6                	div    %esi
  802bde:	89 c5                	mov    %eax,%ebp
  802be0:	89 f8                	mov    %edi,%eax
  802be2:	f7 f6                	div    %esi
  802be4:	89 ea                	mov    %ebp,%edx
  802be6:	83 c4 0c             	add    $0xc,%esp
  802be9:	5e                   	pop    %esi
  802bea:	5f                   	pop    %edi
  802beb:	5d                   	pop    %ebp
  802bec:	c3                   	ret    
  802bed:	8d 76 00             	lea    0x0(%esi),%esi
  802bf0:	39 e8                	cmp    %ebp,%eax
  802bf2:	77 24                	ja     802c18 <__udivdi3+0x78>
  802bf4:	0f bd e8             	bsr    %eax,%ebp
  802bf7:	83 f5 1f             	xor    $0x1f,%ebp
  802bfa:	75 3c                	jne    802c38 <__udivdi3+0x98>
  802bfc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c00:	39 34 24             	cmp    %esi,(%esp)
  802c03:	0f 86 9f 00 00 00    	jbe    802ca8 <__udivdi3+0x108>
  802c09:	39 d0                	cmp    %edx,%eax
  802c0b:	0f 82 97 00 00 00    	jb     802ca8 <__udivdi3+0x108>
  802c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c18:	31 d2                	xor    %edx,%edx
  802c1a:	31 c0                	xor    %eax,%eax
  802c1c:	83 c4 0c             	add    $0xc,%esp
  802c1f:	5e                   	pop    %esi
  802c20:	5f                   	pop    %edi
  802c21:	5d                   	pop    %ebp
  802c22:	c3                   	ret    
  802c23:	90                   	nop
  802c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c28:	89 f8                	mov    %edi,%eax
  802c2a:	f7 f1                	div    %ecx
  802c2c:	31 d2                	xor    %edx,%edx
  802c2e:	83 c4 0c             	add    $0xc,%esp
  802c31:	5e                   	pop    %esi
  802c32:	5f                   	pop    %edi
  802c33:	5d                   	pop    %ebp
  802c34:	c3                   	ret    
  802c35:	8d 76 00             	lea    0x0(%esi),%esi
  802c38:	89 e9                	mov    %ebp,%ecx
  802c3a:	8b 3c 24             	mov    (%esp),%edi
  802c3d:	d3 e0                	shl    %cl,%eax
  802c3f:	89 c6                	mov    %eax,%esi
  802c41:	b8 20 00 00 00       	mov    $0x20,%eax
  802c46:	29 e8                	sub    %ebp,%eax
  802c48:	89 c1                	mov    %eax,%ecx
  802c4a:	d3 ef                	shr    %cl,%edi
  802c4c:	89 e9                	mov    %ebp,%ecx
  802c4e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c52:	8b 3c 24             	mov    (%esp),%edi
  802c55:	09 74 24 08          	or     %esi,0x8(%esp)
  802c59:	89 d6                	mov    %edx,%esi
  802c5b:	d3 e7                	shl    %cl,%edi
  802c5d:	89 c1                	mov    %eax,%ecx
  802c5f:	89 3c 24             	mov    %edi,(%esp)
  802c62:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c66:	d3 ee                	shr    %cl,%esi
  802c68:	89 e9                	mov    %ebp,%ecx
  802c6a:	d3 e2                	shl    %cl,%edx
  802c6c:	89 c1                	mov    %eax,%ecx
  802c6e:	d3 ef                	shr    %cl,%edi
  802c70:	09 d7                	or     %edx,%edi
  802c72:	89 f2                	mov    %esi,%edx
  802c74:	89 f8                	mov    %edi,%eax
  802c76:	f7 74 24 08          	divl   0x8(%esp)
  802c7a:	89 d6                	mov    %edx,%esi
  802c7c:	89 c7                	mov    %eax,%edi
  802c7e:	f7 24 24             	mull   (%esp)
  802c81:	39 d6                	cmp    %edx,%esi
  802c83:	89 14 24             	mov    %edx,(%esp)
  802c86:	72 30                	jb     802cb8 <__udivdi3+0x118>
  802c88:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c8c:	89 e9                	mov    %ebp,%ecx
  802c8e:	d3 e2                	shl    %cl,%edx
  802c90:	39 c2                	cmp    %eax,%edx
  802c92:	73 05                	jae    802c99 <__udivdi3+0xf9>
  802c94:	3b 34 24             	cmp    (%esp),%esi
  802c97:	74 1f                	je     802cb8 <__udivdi3+0x118>
  802c99:	89 f8                	mov    %edi,%eax
  802c9b:	31 d2                	xor    %edx,%edx
  802c9d:	e9 7a ff ff ff       	jmp    802c1c <__udivdi3+0x7c>
  802ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ca8:	31 d2                	xor    %edx,%edx
  802caa:	b8 01 00 00 00       	mov    $0x1,%eax
  802caf:	e9 68 ff ff ff       	jmp    802c1c <__udivdi3+0x7c>
  802cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cb8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802cbb:	31 d2                	xor    %edx,%edx
  802cbd:	83 c4 0c             	add    $0xc,%esp
  802cc0:	5e                   	pop    %esi
  802cc1:	5f                   	pop    %edi
  802cc2:	5d                   	pop    %ebp
  802cc3:	c3                   	ret    
  802cc4:	66 90                	xchg   %ax,%ax
  802cc6:	66 90                	xchg   %ax,%ax
  802cc8:	66 90                	xchg   %ax,%ax
  802cca:	66 90                	xchg   %ax,%ax
  802ccc:	66 90                	xchg   %ax,%ax
  802cce:	66 90                	xchg   %ax,%ax

00802cd0 <__umoddi3>:
  802cd0:	55                   	push   %ebp
  802cd1:	57                   	push   %edi
  802cd2:	56                   	push   %esi
  802cd3:	83 ec 14             	sub    $0x14,%esp
  802cd6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802cda:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802cde:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802ce2:	89 c7                	mov    %eax,%edi
  802ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ce8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802cec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802cf0:	89 34 24             	mov    %esi,(%esp)
  802cf3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cf7:	85 c0                	test   %eax,%eax
  802cf9:	89 c2                	mov    %eax,%edx
  802cfb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cff:	75 17                	jne    802d18 <__umoddi3+0x48>
  802d01:	39 fe                	cmp    %edi,%esi
  802d03:	76 4b                	jbe    802d50 <__umoddi3+0x80>
  802d05:	89 c8                	mov    %ecx,%eax
  802d07:	89 fa                	mov    %edi,%edx
  802d09:	f7 f6                	div    %esi
  802d0b:	89 d0                	mov    %edx,%eax
  802d0d:	31 d2                	xor    %edx,%edx
  802d0f:	83 c4 14             	add    $0x14,%esp
  802d12:	5e                   	pop    %esi
  802d13:	5f                   	pop    %edi
  802d14:	5d                   	pop    %ebp
  802d15:	c3                   	ret    
  802d16:	66 90                	xchg   %ax,%ax
  802d18:	39 f8                	cmp    %edi,%eax
  802d1a:	77 54                	ja     802d70 <__umoddi3+0xa0>
  802d1c:	0f bd e8             	bsr    %eax,%ebp
  802d1f:	83 f5 1f             	xor    $0x1f,%ebp
  802d22:	75 5c                	jne    802d80 <__umoddi3+0xb0>
  802d24:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d28:	39 3c 24             	cmp    %edi,(%esp)
  802d2b:	0f 87 e7 00 00 00    	ja     802e18 <__umoddi3+0x148>
  802d31:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d35:	29 f1                	sub    %esi,%ecx
  802d37:	19 c7                	sbb    %eax,%edi
  802d39:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d41:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d45:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d49:	83 c4 14             	add    $0x14,%esp
  802d4c:	5e                   	pop    %esi
  802d4d:	5f                   	pop    %edi
  802d4e:	5d                   	pop    %ebp
  802d4f:	c3                   	ret    
  802d50:	85 f6                	test   %esi,%esi
  802d52:	89 f5                	mov    %esi,%ebp
  802d54:	75 0b                	jne    802d61 <__umoddi3+0x91>
  802d56:	b8 01 00 00 00       	mov    $0x1,%eax
  802d5b:	31 d2                	xor    %edx,%edx
  802d5d:	f7 f6                	div    %esi
  802d5f:	89 c5                	mov    %eax,%ebp
  802d61:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d65:	31 d2                	xor    %edx,%edx
  802d67:	f7 f5                	div    %ebp
  802d69:	89 c8                	mov    %ecx,%eax
  802d6b:	f7 f5                	div    %ebp
  802d6d:	eb 9c                	jmp    802d0b <__umoddi3+0x3b>
  802d6f:	90                   	nop
  802d70:	89 c8                	mov    %ecx,%eax
  802d72:	89 fa                	mov    %edi,%edx
  802d74:	83 c4 14             	add    $0x14,%esp
  802d77:	5e                   	pop    %esi
  802d78:	5f                   	pop    %edi
  802d79:	5d                   	pop    %ebp
  802d7a:	c3                   	ret    
  802d7b:	90                   	nop
  802d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d80:	8b 04 24             	mov    (%esp),%eax
  802d83:	be 20 00 00 00       	mov    $0x20,%esi
  802d88:	89 e9                	mov    %ebp,%ecx
  802d8a:	29 ee                	sub    %ebp,%esi
  802d8c:	d3 e2                	shl    %cl,%edx
  802d8e:	89 f1                	mov    %esi,%ecx
  802d90:	d3 e8                	shr    %cl,%eax
  802d92:	89 e9                	mov    %ebp,%ecx
  802d94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d98:	8b 04 24             	mov    (%esp),%eax
  802d9b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d9f:	89 fa                	mov    %edi,%edx
  802da1:	d3 e0                	shl    %cl,%eax
  802da3:	89 f1                	mov    %esi,%ecx
  802da5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802da9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802dad:	d3 ea                	shr    %cl,%edx
  802daf:	89 e9                	mov    %ebp,%ecx
  802db1:	d3 e7                	shl    %cl,%edi
  802db3:	89 f1                	mov    %esi,%ecx
  802db5:	d3 e8                	shr    %cl,%eax
  802db7:	89 e9                	mov    %ebp,%ecx
  802db9:	09 f8                	or     %edi,%eax
  802dbb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802dbf:	f7 74 24 04          	divl   0x4(%esp)
  802dc3:	d3 e7                	shl    %cl,%edi
  802dc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dc9:	89 d7                	mov    %edx,%edi
  802dcb:	f7 64 24 08          	mull   0x8(%esp)
  802dcf:	39 d7                	cmp    %edx,%edi
  802dd1:	89 c1                	mov    %eax,%ecx
  802dd3:	89 14 24             	mov    %edx,(%esp)
  802dd6:	72 2c                	jb     802e04 <__umoddi3+0x134>
  802dd8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802ddc:	72 22                	jb     802e00 <__umoddi3+0x130>
  802dde:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802de2:	29 c8                	sub    %ecx,%eax
  802de4:	19 d7                	sbb    %edx,%edi
  802de6:	89 e9                	mov    %ebp,%ecx
  802de8:	89 fa                	mov    %edi,%edx
  802dea:	d3 e8                	shr    %cl,%eax
  802dec:	89 f1                	mov    %esi,%ecx
  802dee:	d3 e2                	shl    %cl,%edx
  802df0:	89 e9                	mov    %ebp,%ecx
  802df2:	d3 ef                	shr    %cl,%edi
  802df4:	09 d0                	or     %edx,%eax
  802df6:	89 fa                	mov    %edi,%edx
  802df8:	83 c4 14             	add    $0x14,%esp
  802dfb:	5e                   	pop    %esi
  802dfc:	5f                   	pop    %edi
  802dfd:	5d                   	pop    %ebp
  802dfe:	c3                   	ret    
  802dff:	90                   	nop
  802e00:	39 d7                	cmp    %edx,%edi
  802e02:	75 da                	jne    802dde <__umoddi3+0x10e>
  802e04:	8b 14 24             	mov    (%esp),%edx
  802e07:	89 c1                	mov    %eax,%ecx
  802e09:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802e0d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802e11:	eb cb                	jmp    802dde <__umoddi3+0x10e>
  802e13:	90                   	nop
  802e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e18:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802e1c:	0f 82 0f ff ff ff    	jb     802d31 <__umoddi3+0x61>
  802e22:	e9 1a ff ff ff       	jmp    802d41 <__umoddi3+0x71>
