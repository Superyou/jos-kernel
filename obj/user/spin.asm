
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 8e 00 00 00       	call   8000bf <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800047:	c7 04 24 c0 2d 80 00 	movl   $0x802dc0,(%esp)
  80004e:	e8 70 01 00 00       	call   8001c3 <cprintf>
	if ((env = fork()) == 0) {
  800053:	e8 67 11 00 00       	call   8011bf <fork>
  800058:	89 c3                	mov    %eax,%ebx
  80005a:	85 c0                	test   %eax,%eax
  80005c:	75 0e                	jne    80006c <umain+0x2c>
		cprintf("I am the child.  Spinning...\n");
  80005e:	c7 04 24 38 2e 80 00 	movl   $0x802e38,(%esp)
  800065:	e8 59 01 00 00       	call   8001c3 <cprintf>
  80006a:	eb fe                	jmp    80006a <umain+0x2a>
		while (1)
			/* do nothing */;
	}


	cprintf("I am the parent.  Running the child...\n");
  80006c:	c7 04 24 e8 2d 80 00 	movl   $0x802de8,(%esp)
  800073:	e8 4b 01 00 00       	call   8001c3 <cprintf>
	sys_yield();
  800078:	e8 09 0c 00 00       	call   800c86 <sys_yield>
	sys_yield();
  80007d:	e8 04 0c 00 00       	call   800c86 <sys_yield>
	sys_yield();
  800082:	e8 ff 0b 00 00       	call   800c86 <sys_yield>
	sys_yield();
  800087:	e8 fa 0b 00 00       	call   800c86 <sys_yield>
	sys_yield();
  80008c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800090:	e8 f1 0b 00 00       	call   800c86 <sys_yield>
	sys_yield();
  800095:	e8 ec 0b 00 00       	call   800c86 <sys_yield>
	sys_yield();
  80009a:	e8 e7 0b 00 00       	call   800c86 <sys_yield>
	sys_yield();
  80009f:	90                   	nop
  8000a0:	e8 e1 0b 00 00       	call   800c86 <sys_yield>
	cprintf("I am the parent.  Killing the child...\n");
  8000a5:	c7 04 24 10 2e 80 00 	movl   $0x802e10,(%esp)
  8000ac:	e8 12 01 00 00       	call   8001c3 <cprintf>
	sys_env_destroy(env);
  8000b1:	89 1c 24             	mov    %ebx,(%esp)
  8000b4:	e8 0a 0b 00 00       	call   800bc3 <sys_env_destroy>
}
  8000b9:	83 c4 14             	add    $0x14,%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5d                   	pop    %ebp
  8000be:	c3                   	ret    

008000bf <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	56                   	push   %esi
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 10             	sub    $0x10,%esp
  8000c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ca:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8000cd:	e8 95 0b 00 00       	call   800c67 <sys_getenvid>
  8000d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000df:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e4:	85 db                	test   %ebx,%ebx
  8000e6:	7e 07                	jle    8000ef <libmain+0x30>
		binaryname = argv[0];
  8000e8:	8b 06                	mov    (%esi),%eax
  8000ea:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000f3:	89 1c 24             	mov    %ebx,(%esp)
  8000f6:	e8 45 ff ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  8000fb:	e8 07 00 00 00       	call   800107 <exit>
}
  800100:	83 c4 10             	add    $0x10,%esp
  800103:	5b                   	pop    %ebx
  800104:	5e                   	pop    %esi
  800105:	5d                   	pop    %ebp
  800106:	c3                   	ret    

00800107 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80010d:	e8 28 16 00 00       	call   80173a <close_all>
	sys_env_destroy(0);
  800112:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800119:	e8 a5 0a 00 00       	call   800bc3 <sys_env_destroy>
}
  80011e:	c9                   	leave  
  80011f:	c3                   	ret    

00800120 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	53                   	push   %ebx
  800124:	83 ec 14             	sub    $0x14,%esp
  800127:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012a:	8b 13                	mov    (%ebx),%edx
  80012c:	8d 42 01             	lea    0x1(%edx),%eax
  80012f:	89 03                	mov    %eax,(%ebx)
  800131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800134:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800138:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013d:	75 19                	jne    800158 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80013f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800146:	00 
  800147:	8d 43 08             	lea    0x8(%ebx),%eax
  80014a:	89 04 24             	mov    %eax,(%esp)
  80014d:	e8 34 0a 00 00       	call   800b86 <sys_cputs>
		b->idx = 0;
  800152:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800158:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80015c:	83 c4 14             	add    $0x14,%esp
  80015f:	5b                   	pop    %ebx
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80016b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800172:	00 00 00 
	b.cnt = 0;
  800175:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800182:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800186:	8b 45 08             	mov    0x8(%ebp),%eax
  800189:	89 44 24 08          	mov    %eax,0x8(%esp)
  80018d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800193:	89 44 24 04          	mov    %eax,0x4(%esp)
  800197:	c7 04 24 20 01 80 00 	movl   $0x800120,(%esp)
  80019e:	e8 71 01 00 00       	call   800314 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ad:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b3:	89 04 24             	mov    %eax,(%esp)
  8001b6:	e8 cb 09 00 00       	call   800b86 <sys_cputs>

	return b.cnt;
}
  8001bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c1:	c9                   	leave  
  8001c2:	c3                   	ret    

008001c3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c3:	55                   	push   %ebp
  8001c4:	89 e5                	mov    %esp,%ebp
  8001c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001c9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d3:	89 04 24             	mov    %eax,(%esp)
  8001d6:	e8 87 ff ff ff       	call   800162 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    
  8001dd:	66 90                	xchg   %ax,%ax
  8001df:	90                   	nop

008001e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	57                   	push   %edi
  8001e4:	56                   	push   %esi
  8001e5:	53                   	push   %ebx
  8001e6:	83 ec 3c             	sub    $0x3c,%esp
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001ec:	89 d7                	mov    %edx,%edi
  8001ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f7:	89 c3                	mov    %eax,%ebx
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ff:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800202:	b9 00 00 00 00       	mov    $0x0,%ecx
  800207:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80020a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80020d:	39 d9                	cmp    %ebx,%ecx
  80020f:	72 05                	jb     800216 <printnum+0x36>
  800211:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800214:	77 69                	ja     80027f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800216:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800219:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80021d:	83 ee 01             	sub    $0x1,%esi
  800220:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800224:	89 44 24 08          	mov    %eax,0x8(%esp)
  800228:	8b 44 24 08          	mov    0x8(%esp),%eax
  80022c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800230:	89 c3                	mov    %eax,%ebx
  800232:	89 d6                	mov    %edx,%esi
  800234:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800237:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80023a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80023e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800242:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80024b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024f:	e8 cc 28 00 00       	call   802b20 <__udivdi3>
  800254:	89 d9                	mov    %ebx,%ecx
  800256:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80025a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80025e:	89 04 24             	mov    %eax,(%esp)
  800261:	89 54 24 04          	mov    %edx,0x4(%esp)
  800265:	89 fa                	mov    %edi,%edx
  800267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80026a:	e8 71 ff ff ff       	call   8001e0 <printnum>
  80026f:	eb 1b                	jmp    80028c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800271:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800275:	8b 45 18             	mov    0x18(%ebp),%eax
  800278:	89 04 24             	mov    %eax,(%esp)
  80027b:	ff d3                	call   *%ebx
  80027d:	eb 03                	jmp    800282 <printnum+0xa2>
  80027f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800282:	83 ee 01             	sub    $0x1,%esi
  800285:	85 f6                	test   %esi,%esi
  800287:	7f e8                	jg     800271 <printnum+0x91>
  800289:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80028c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800290:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800294:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800297:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80029a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80029e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a5:	89 04 24             	mov    %eax,(%esp)
  8002a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002af:	e8 9c 29 00 00       	call   802c50 <__umoddi3>
  8002b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b8:	0f be 80 60 2e 80 00 	movsbl 0x802e60(%eax),%eax
  8002bf:	89 04 24             	mov    %eax,(%esp)
  8002c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c5:	ff d0                	call   *%eax
}
  8002c7:	83 c4 3c             	add    $0x3c,%esp
  8002ca:	5b                   	pop    %ebx
  8002cb:	5e                   	pop    %esi
  8002cc:	5f                   	pop    %edi
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d9:	8b 10                	mov    (%eax),%edx
  8002db:	3b 50 04             	cmp    0x4(%eax),%edx
  8002de:	73 0a                	jae    8002ea <sprintputch+0x1b>
		*b->buf++ = ch;
  8002e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e3:	89 08                	mov    %ecx,(%eax)
  8002e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e8:	88 02                	mov    %al,(%edx)
}
  8002ea:	5d                   	pop    %ebp
  8002eb:	c3                   	ret    

008002ec <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002f2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	89 44 24 04          	mov    %eax,0x4(%esp)
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	89 04 24             	mov    %eax,(%esp)
  80030d:	e8 02 00 00 00       	call   800314 <vprintfmt>
	va_end(ap);
}
  800312:	c9                   	leave  
  800313:	c3                   	ret    

00800314 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	57                   	push   %edi
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 3c             	sub    $0x3c,%esp
  80031d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800320:	eb 17                	jmp    800339 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800322:	85 c0                	test   %eax,%eax
  800324:	0f 84 4b 04 00 00    	je     800775 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80032a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800331:	89 04 24             	mov    %eax,(%esp)
  800334:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800337:	89 fb                	mov    %edi,%ebx
  800339:	8d 7b 01             	lea    0x1(%ebx),%edi
  80033c:	0f b6 03             	movzbl (%ebx),%eax
  80033f:	83 f8 25             	cmp    $0x25,%eax
  800342:	75 de                	jne    800322 <vprintfmt+0xe>
  800344:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800348:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80034f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800354:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80035b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800360:	eb 18                	jmp    80037a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800362:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800364:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800368:	eb 10                	jmp    80037a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80036c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800370:	eb 08                	jmp    80037a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800372:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800375:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80037a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80037d:	0f b6 17             	movzbl (%edi),%edx
  800380:	0f b6 c2             	movzbl %dl,%eax
  800383:	83 ea 23             	sub    $0x23,%edx
  800386:	80 fa 55             	cmp    $0x55,%dl
  800389:	0f 87 c2 03 00 00    	ja     800751 <vprintfmt+0x43d>
  80038f:	0f b6 d2             	movzbl %dl,%edx
  800392:	ff 24 95 a0 2f 80 00 	jmp    *0x802fa0(,%edx,4)
  800399:	89 df                	mov    %ebx,%edi
  80039b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003a0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8003a3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8003a7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  8003aa:	8d 50 d0             	lea    -0x30(%eax),%edx
  8003ad:	83 fa 09             	cmp    $0x9,%edx
  8003b0:	77 33                	ja     8003e5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003b2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003b5:	eb e9                	jmp    8003a0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ba:	8b 30                	mov    (%eax),%esi
  8003bc:	8d 40 04             	lea    0x4(%eax),%eax
  8003bf:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003c4:	eb 1f                	jmp    8003e5 <vprintfmt+0xd1>
  8003c6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8003c9:	85 ff                	test   %edi,%edi
  8003cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d0:	0f 49 c7             	cmovns %edi,%eax
  8003d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	89 df                	mov    %ebx,%edi
  8003d8:	eb a0                	jmp    80037a <vprintfmt+0x66>
  8003da:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003dc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8003e3:	eb 95                	jmp    80037a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8003e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e9:	79 8f                	jns    80037a <vprintfmt+0x66>
  8003eb:	eb 85                	jmp    800372 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003ed:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003f2:	eb 86                	jmp    80037a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f7:	8d 70 04             	lea    0x4(%eax),%esi
  8003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	89 04 24             	mov    %eax,(%esp)
  800409:	ff 55 08             	call   *0x8(%ebp)
  80040c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80040f:	e9 25 ff ff ff       	jmp    800339 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800414:	8b 45 14             	mov    0x14(%ebp),%eax
  800417:	8d 70 04             	lea    0x4(%eax),%esi
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	99                   	cltd   
  80041d:	31 d0                	xor    %edx,%eax
  80041f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800421:	83 f8 15             	cmp    $0x15,%eax
  800424:	7f 0b                	jg     800431 <vprintfmt+0x11d>
  800426:	8b 14 85 00 31 80 00 	mov    0x803100(,%eax,4),%edx
  80042d:	85 d2                	test   %edx,%edx
  80042f:	75 26                	jne    800457 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800431:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800435:	c7 44 24 08 78 2e 80 	movl   $0x802e78,0x8(%esp)
  80043c:	00 
  80043d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800440:	89 44 24 04          	mov    %eax,0x4(%esp)
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	89 04 24             	mov    %eax,(%esp)
  80044a:	e8 9d fe ff ff       	call   8002ec <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80044f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800452:	e9 e2 fe ff ff       	jmp    800339 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800457:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80045b:	c7 44 24 08 1a 33 80 	movl   $0x80331a,0x8(%esp)
  800462:	00 
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
  800466:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	89 04 24             	mov    %eax,(%esp)
  800470:	e8 77 fe ff ff       	call   8002ec <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800475:	89 75 14             	mov    %esi,0x14(%ebp)
  800478:	e9 bc fe ff ff       	jmp    800339 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800483:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800486:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80048a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80048c:	85 ff                	test   %edi,%edi
  80048e:	b8 71 2e 80 00       	mov    $0x802e71,%eax
  800493:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800496:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80049a:	0f 84 94 00 00 00    	je     800534 <vprintfmt+0x220>
  8004a0:	85 c9                	test   %ecx,%ecx
  8004a2:	0f 8e 94 00 00 00    	jle    80053c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ac:	89 3c 24             	mov    %edi,(%esp)
  8004af:	e8 64 03 00 00       	call   800818 <strnlen>
  8004b4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8004b7:	29 c1                	sub    %eax,%ecx
  8004b9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  8004bc:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  8004c0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8004c3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004cc:	89 cb                	mov    %ecx,%ebx
  8004ce:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d0:	eb 0f                	jmp    8004e1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  8004d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004d9:	89 3c 24             	mov    %edi,(%esp)
  8004dc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004de:	83 eb 01             	sub    $0x1,%ebx
  8004e1:	85 db                	test   %ebx,%ebx
  8004e3:	7f ed                	jg     8004d2 <vprintfmt+0x1be>
  8004e5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8004e8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ee:	85 c9                	test   %ecx,%ecx
  8004f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f5:	0f 49 c1             	cmovns %ecx,%eax
  8004f8:	29 c1                	sub    %eax,%ecx
  8004fa:	89 cb                	mov    %ecx,%ebx
  8004fc:	eb 44                	jmp    800542 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800502:	74 1e                	je     800522 <vprintfmt+0x20e>
  800504:	0f be d2             	movsbl %dl,%edx
  800507:	83 ea 20             	sub    $0x20,%edx
  80050a:	83 fa 5e             	cmp    $0x5e,%edx
  80050d:	76 13                	jbe    800522 <vprintfmt+0x20e>
					putch('?', putdat);
  80050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800512:	89 44 24 04          	mov    %eax,0x4(%esp)
  800516:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80051d:	ff 55 08             	call   *0x8(%ebp)
  800520:	eb 0d                	jmp    80052f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800522:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800525:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800529:	89 04 24             	mov    %eax,(%esp)
  80052c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80052f:	83 eb 01             	sub    $0x1,%ebx
  800532:	eb 0e                	jmp    800542 <vprintfmt+0x22e>
  800534:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800537:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80053a:	eb 06                	jmp    800542 <vprintfmt+0x22e>
  80053c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80053f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800542:	83 c7 01             	add    $0x1,%edi
  800545:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800549:	0f be c2             	movsbl %dl,%eax
  80054c:	85 c0                	test   %eax,%eax
  80054e:	74 27                	je     800577 <vprintfmt+0x263>
  800550:	85 f6                	test   %esi,%esi
  800552:	78 aa                	js     8004fe <vprintfmt+0x1ea>
  800554:	83 ee 01             	sub    $0x1,%esi
  800557:	79 a5                	jns    8004fe <vprintfmt+0x1ea>
  800559:	89 d8                	mov    %ebx,%eax
  80055b:	8b 75 08             	mov    0x8(%ebp),%esi
  80055e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800561:	89 c3                	mov    %eax,%ebx
  800563:	eb 18                	jmp    80057d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800565:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800569:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800570:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800572:	83 eb 01             	sub    $0x1,%ebx
  800575:	eb 06                	jmp    80057d <vprintfmt+0x269>
  800577:	8b 75 08             	mov    0x8(%ebp),%esi
  80057a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80057d:	85 db                	test   %ebx,%ebx
  80057f:	7f e4                	jg     800565 <vprintfmt+0x251>
  800581:	89 75 08             	mov    %esi,0x8(%ebp)
  800584:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800587:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80058a:	e9 aa fd ff ff       	jmp    800339 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80058f:	83 f9 01             	cmp    $0x1,%ecx
  800592:	7e 10                	jle    8005a4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 30                	mov    (%eax),%esi
  800599:	8b 78 04             	mov    0x4(%eax),%edi
  80059c:	8d 40 08             	lea    0x8(%eax),%eax
  80059f:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a2:	eb 26                	jmp    8005ca <vprintfmt+0x2b6>
	else if (lflag)
  8005a4:	85 c9                	test   %ecx,%ecx
  8005a6:	74 12                	je     8005ba <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8b 30                	mov    (%eax),%esi
  8005ad:	89 f7                	mov    %esi,%edi
  8005af:	c1 ff 1f             	sar    $0x1f,%edi
  8005b2:	8d 40 04             	lea    0x4(%eax),%eax
  8005b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b8:	eb 10                	jmp    8005ca <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8b 30                	mov    (%eax),%esi
  8005bf:	89 f7                	mov    %esi,%edi
  8005c1:	c1 ff 1f             	sar    $0x1f,%edi
  8005c4:	8d 40 04             	lea    0x4(%eax),%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005ca:	89 f0                	mov    %esi,%eax
  8005cc:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005d3:	85 ff                	test   %edi,%edi
  8005d5:	0f 89 3a 01 00 00    	jns    800715 <vprintfmt+0x401>
				putch('-', putdat);
  8005db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005e9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005ec:	89 f0                	mov    %esi,%eax
  8005ee:	89 fa                	mov    %edi,%edx
  8005f0:	f7 d8                	neg    %eax
  8005f2:	83 d2 00             	adc    $0x0,%edx
  8005f5:	f7 da                	neg    %edx
			}
			base = 10;
  8005f7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005fc:	e9 14 01 00 00       	jmp    800715 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800601:	83 f9 01             	cmp    $0x1,%ecx
  800604:	7e 13                	jle    800619 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8b 50 04             	mov    0x4(%eax),%edx
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	8b 75 14             	mov    0x14(%ebp),%esi
  800611:	8d 4e 08             	lea    0x8(%esi),%ecx
  800614:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800617:	eb 2c                	jmp    800645 <vprintfmt+0x331>
	else if (lflag)
  800619:	85 c9                	test   %ecx,%ecx
  80061b:	74 15                	je     800632 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	ba 00 00 00 00       	mov    $0x0,%edx
  800627:	8b 75 14             	mov    0x14(%ebp),%esi
  80062a:	8d 76 04             	lea    0x4(%esi),%esi
  80062d:	89 75 14             	mov    %esi,0x14(%ebp)
  800630:	eb 13                	jmp    800645 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	ba 00 00 00 00       	mov    $0x0,%edx
  80063c:	8b 75 14             	mov    0x14(%ebp),%esi
  80063f:	8d 76 04             	lea    0x4(%esi),%esi
  800642:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800645:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80064a:	e9 c6 00 00 00       	jmp    800715 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80064f:	83 f9 01             	cmp    $0x1,%ecx
  800652:	7e 13                	jle    800667 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 50 04             	mov    0x4(%eax),%edx
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	8b 75 14             	mov    0x14(%ebp),%esi
  80065f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800662:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800665:	eb 24                	jmp    80068b <vprintfmt+0x377>
	else if (lflag)
  800667:	85 c9                	test   %ecx,%ecx
  800669:	74 11                	je     80067c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	99                   	cltd   
  800671:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800674:	8d 71 04             	lea    0x4(%ecx),%esi
  800677:	89 75 14             	mov    %esi,0x14(%ebp)
  80067a:	eb 0f                	jmp    80068b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	99                   	cltd   
  800682:	8b 75 14             	mov    0x14(%ebp),%esi
  800685:	8d 76 04             	lea    0x4(%esi),%esi
  800688:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80068b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800690:	e9 80 00 00 00       	jmp    800715 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800695:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80069f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006a6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006b0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006b7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006ba:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006be:	8b 06                	mov    (%esi),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006c5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006ca:	eb 49                	jmp    800715 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006cc:	83 f9 01             	cmp    $0x1,%ecx
  8006cf:	7e 13                	jle    8006e4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 50 04             	mov    0x4(%eax),%edx
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	8b 75 14             	mov    0x14(%ebp),%esi
  8006dc:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006df:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006e2:	eb 2c                	jmp    800710 <vprintfmt+0x3fc>
	else if (lflag)
  8006e4:	85 c9                	test   %ecx,%ecx
  8006e6:	74 15                	je     8006fd <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8006f5:	8d 71 04             	lea    0x4(%ecx),%esi
  8006f8:	89 75 14             	mov    %esi,0x14(%ebp)
  8006fb:	eb 13                	jmp    800710 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	ba 00 00 00 00       	mov    $0x0,%edx
  800707:	8b 75 14             	mov    0x14(%ebp),%esi
  80070a:	8d 76 04             	lea    0x4(%esi),%esi
  80070d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800710:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800715:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800719:	89 74 24 10          	mov    %esi,0x10(%esp)
  80071d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800720:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800724:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800728:	89 04 24             	mov    %eax,(%esp)
  80072b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80072f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	e8 a6 fa ff ff       	call   8001e0 <printnum>
			break;
  80073a:	e9 fa fb ff ff       	jmp    800339 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80073f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800742:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800746:	89 04 24             	mov    %eax,(%esp)
  800749:	ff 55 08             	call   *0x8(%ebp)
			break;
  80074c:	e9 e8 fb ff ff       	jmp    800339 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800751:	8b 45 0c             	mov    0xc(%ebp),%eax
  800754:	89 44 24 04          	mov    %eax,0x4(%esp)
  800758:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80075f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800762:	89 fb                	mov    %edi,%ebx
  800764:	eb 03                	jmp    800769 <vprintfmt+0x455>
  800766:	83 eb 01             	sub    $0x1,%ebx
  800769:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80076d:	75 f7                	jne    800766 <vprintfmt+0x452>
  80076f:	90                   	nop
  800770:	e9 c4 fb ff ff       	jmp    800339 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800775:	83 c4 3c             	add    $0x3c,%esp
  800778:	5b                   	pop    %ebx
  800779:	5e                   	pop    %esi
  80077a:	5f                   	pop    %edi
  80077b:	5d                   	pop    %ebp
  80077c:	c3                   	ret    

0080077d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	83 ec 28             	sub    $0x28,%esp
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800789:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80078c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800790:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800793:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80079a:	85 c0                	test   %eax,%eax
  80079c:	74 30                	je     8007ce <vsnprintf+0x51>
  80079e:	85 d2                	test   %edx,%edx
  8007a0:	7e 2c                	jle    8007ce <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b7:	c7 04 24 cf 02 80 00 	movl   $0x8002cf,(%esp)
  8007be:	e8 51 fb ff ff       	call   800314 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007cc:	eb 05                	jmp    8007d3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007d3:	c9                   	leave  
  8007d4:	c3                   	ret    

008007d5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007db:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	89 04 24             	mov    %eax,(%esp)
  8007f6:	e8 82 ff ff ff       	call   80077d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007fb:	c9                   	leave  
  8007fc:	c3                   	ret    
  8007fd:	66 90                	xchg   %ax,%ax
  8007ff:	90                   	nop

00800800 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800806:	b8 00 00 00 00       	mov    $0x0,%eax
  80080b:	eb 03                	jmp    800810 <strlen+0x10>
		n++;
  80080d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800810:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800814:	75 f7                	jne    80080d <strlen+0xd>
		n++;
	return n;
}
  800816:	5d                   	pop    %ebp
  800817:	c3                   	ret    

00800818 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800821:	b8 00 00 00 00       	mov    $0x0,%eax
  800826:	eb 03                	jmp    80082b <strnlen+0x13>
		n++;
  800828:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80082b:	39 d0                	cmp    %edx,%eax
  80082d:	74 06                	je     800835 <strnlen+0x1d>
  80082f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800833:	75 f3                	jne    800828 <strnlen+0x10>
		n++;
	return n;
}
  800835:	5d                   	pop    %ebp
  800836:	c3                   	ret    

00800837 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	53                   	push   %ebx
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800841:	89 c2                	mov    %eax,%edx
  800843:	83 c2 01             	add    $0x1,%edx
  800846:	83 c1 01             	add    $0x1,%ecx
  800849:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80084d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800850:	84 db                	test   %bl,%bl
  800852:	75 ef                	jne    800843 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800854:	5b                   	pop    %ebx
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	53                   	push   %ebx
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800861:	89 1c 24             	mov    %ebx,(%esp)
  800864:	e8 97 ff ff ff       	call   800800 <strlen>
	strcpy(dst + len, src);
  800869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800870:	01 d8                	add    %ebx,%eax
  800872:	89 04 24             	mov    %eax,(%esp)
  800875:	e8 bd ff ff ff       	call   800837 <strcpy>
	return dst;
}
  80087a:	89 d8                	mov    %ebx,%eax
  80087c:	83 c4 08             	add    $0x8,%esp
  80087f:	5b                   	pop    %ebx
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	8b 75 08             	mov    0x8(%ebp),%esi
  80088a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088d:	89 f3                	mov    %esi,%ebx
  80088f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800892:	89 f2                	mov    %esi,%edx
  800894:	eb 0f                	jmp    8008a5 <strncpy+0x23>
		*dst++ = *src;
  800896:	83 c2 01             	add    $0x1,%edx
  800899:	0f b6 01             	movzbl (%ecx),%eax
  80089c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80089f:	80 39 01             	cmpb   $0x1,(%ecx)
  8008a2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a5:	39 da                	cmp    %ebx,%edx
  8008a7:	75 ed                	jne    800896 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008a9:	89 f0                	mov    %esi,%eax
  8008ab:	5b                   	pop    %ebx
  8008ac:	5e                   	pop    %esi
  8008ad:	5d                   	pop    %ebp
  8008ae:	c3                   	ret    

008008af <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	56                   	push   %esi
  8008b3:	53                   	push   %ebx
  8008b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008bd:	89 f0                	mov    %esi,%eax
  8008bf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008c3:	85 c9                	test   %ecx,%ecx
  8008c5:	75 0b                	jne    8008d2 <strlcpy+0x23>
  8008c7:	eb 1d                	jmp    8008e6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008c9:	83 c0 01             	add    $0x1,%eax
  8008cc:	83 c2 01             	add    $0x1,%edx
  8008cf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008d2:	39 d8                	cmp    %ebx,%eax
  8008d4:	74 0b                	je     8008e1 <strlcpy+0x32>
  8008d6:	0f b6 0a             	movzbl (%edx),%ecx
  8008d9:	84 c9                	test   %cl,%cl
  8008db:	75 ec                	jne    8008c9 <strlcpy+0x1a>
  8008dd:	89 c2                	mov    %eax,%edx
  8008df:	eb 02                	jmp    8008e3 <strlcpy+0x34>
  8008e1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008e3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8008e6:	29 f0                	sub    %esi,%eax
}
  8008e8:	5b                   	pop    %ebx
  8008e9:	5e                   	pop    %esi
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f5:	eb 06                	jmp    8008fd <strcmp+0x11>
		p++, q++;
  8008f7:	83 c1 01             	add    $0x1,%ecx
  8008fa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008fd:	0f b6 01             	movzbl (%ecx),%eax
  800900:	84 c0                	test   %al,%al
  800902:	74 04                	je     800908 <strcmp+0x1c>
  800904:	3a 02                	cmp    (%edx),%al
  800906:	74 ef                	je     8008f7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800908:	0f b6 c0             	movzbl %al,%eax
  80090b:	0f b6 12             	movzbl (%edx),%edx
  80090e:	29 d0                	sub    %edx,%eax
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	53                   	push   %ebx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091c:	89 c3                	mov    %eax,%ebx
  80091e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800921:	eb 06                	jmp    800929 <strncmp+0x17>
		n--, p++, q++;
  800923:	83 c0 01             	add    $0x1,%eax
  800926:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800929:	39 d8                	cmp    %ebx,%eax
  80092b:	74 15                	je     800942 <strncmp+0x30>
  80092d:	0f b6 08             	movzbl (%eax),%ecx
  800930:	84 c9                	test   %cl,%cl
  800932:	74 04                	je     800938 <strncmp+0x26>
  800934:	3a 0a                	cmp    (%edx),%cl
  800936:	74 eb                	je     800923 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800938:	0f b6 00             	movzbl (%eax),%eax
  80093b:	0f b6 12             	movzbl (%edx),%edx
  80093e:	29 d0                	sub    %edx,%eax
  800940:	eb 05                	jmp    800947 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800942:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800947:	5b                   	pop    %ebx
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800954:	eb 07                	jmp    80095d <strchr+0x13>
		if (*s == c)
  800956:	38 ca                	cmp    %cl,%dl
  800958:	74 0f                	je     800969 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80095a:	83 c0 01             	add    $0x1,%eax
  80095d:	0f b6 10             	movzbl (%eax),%edx
  800960:	84 d2                	test   %dl,%dl
  800962:	75 f2                	jne    800956 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800964:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800975:	eb 07                	jmp    80097e <strfind+0x13>
		if (*s == c)
  800977:	38 ca                	cmp    %cl,%dl
  800979:	74 0a                	je     800985 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80097b:	83 c0 01             	add    $0x1,%eax
  80097e:	0f b6 10             	movzbl (%eax),%edx
  800981:	84 d2                	test   %dl,%dl
  800983:	75 f2                	jne    800977 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	57                   	push   %edi
  80098b:	56                   	push   %esi
  80098c:	53                   	push   %ebx
  80098d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800990:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800993:	85 c9                	test   %ecx,%ecx
  800995:	74 36                	je     8009cd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800997:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80099d:	75 28                	jne    8009c7 <memset+0x40>
  80099f:	f6 c1 03             	test   $0x3,%cl
  8009a2:	75 23                	jne    8009c7 <memset+0x40>
		c &= 0xFF;
  8009a4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009a8:	89 d3                	mov    %edx,%ebx
  8009aa:	c1 e3 08             	shl    $0x8,%ebx
  8009ad:	89 d6                	mov    %edx,%esi
  8009af:	c1 e6 18             	shl    $0x18,%esi
  8009b2:	89 d0                	mov    %edx,%eax
  8009b4:	c1 e0 10             	shl    $0x10,%eax
  8009b7:	09 f0                	or     %esi,%eax
  8009b9:	09 c2                	or     %eax,%edx
  8009bb:	89 d0                	mov    %edx,%eax
  8009bd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009bf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009c2:	fc                   	cld    
  8009c3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009c5:	eb 06                	jmp    8009cd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ca:	fc                   	cld    
  8009cb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009cd:	89 f8                	mov    %edi,%eax
  8009cf:	5b                   	pop    %ebx
  8009d0:	5e                   	pop    %esi
  8009d1:	5f                   	pop    %edi
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	57                   	push   %edi
  8009d8:	56                   	push   %esi
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009df:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e2:	39 c6                	cmp    %eax,%esi
  8009e4:	73 35                	jae    800a1b <memmove+0x47>
  8009e6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009e9:	39 d0                	cmp    %edx,%eax
  8009eb:	73 2e                	jae    800a1b <memmove+0x47>
		s += n;
		d += n;
  8009ed:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009f0:	89 d6                	mov    %edx,%esi
  8009f2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009fa:	75 13                	jne    800a0f <memmove+0x3b>
  8009fc:	f6 c1 03             	test   $0x3,%cl
  8009ff:	75 0e                	jne    800a0f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a01:	83 ef 04             	sub    $0x4,%edi
  800a04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a07:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a0a:	fd                   	std    
  800a0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0d:	eb 09                	jmp    800a18 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a0f:	83 ef 01             	sub    $0x1,%edi
  800a12:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a15:	fd                   	std    
  800a16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a18:	fc                   	cld    
  800a19:	eb 1d                	jmp    800a38 <memmove+0x64>
  800a1b:	89 f2                	mov    %esi,%edx
  800a1d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1f:	f6 c2 03             	test   $0x3,%dl
  800a22:	75 0f                	jne    800a33 <memmove+0x5f>
  800a24:	f6 c1 03             	test   $0x3,%cl
  800a27:	75 0a                	jne    800a33 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a29:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a2c:	89 c7                	mov    %eax,%edi
  800a2e:	fc                   	cld    
  800a2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a31:	eb 05                	jmp    800a38 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a33:	89 c7                	mov    %eax,%edi
  800a35:	fc                   	cld    
  800a36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a38:	5e                   	pop    %esi
  800a39:	5f                   	pop    %edi
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a42:	8b 45 10             	mov    0x10(%ebp),%eax
  800a45:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	89 04 24             	mov    %eax,(%esp)
  800a56:	e8 79 ff ff ff       	call   8009d4 <memmove>
}
  800a5b:	c9                   	leave  
  800a5c:	c3                   	ret    

00800a5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	56                   	push   %esi
  800a61:	53                   	push   %ebx
  800a62:	8b 55 08             	mov    0x8(%ebp),%edx
  800a65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a68:	89 d6                	mov    %edx,%esi
  800a6a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6d:	eb 1a                	jmp    800a89 <memcmp+0x2c>
		if (*s1 != *s2)
  800a6f:	0f b6 02             	movzbl (%edx),%eax
  800a72:	0f b6 19             	movzbl (%ecx),%ebx
  800a75:	38 d8                	cmp    %bl,%al
  800a77:	74 0a                	je     800a83 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a79:	0f b6 c0             	movzbl %al,%eax
  800a7c:	0f b6 db             	movzbl %bl,%ebx
  800a7f:	29 d8                	sub    %ebx,%eax
  800a81:	eb 0f                	jmp    800a92 <memcmp+0x35>
		s1++, s2++;
  800a83:	83 c2 01             	add    $0x1,%edx
  800a86:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a89:	39 f2                	cmp    %esi,%edx
  800a8b:	75 e2                	jne    800a6f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a92:	5b                   	pop    %ebx
  800a93:	5e                   	pop    %esi
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a9f:	89 c2                	mov    %eax,%edx
  800aa1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa4:	eb 07                	jmp    800aad <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aa6:	38 08                	cmp    %cl,(%eax)
  800aa8:	74 07                	je     800ab1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	39 d0                	cmp    %edx,%eax
  800aaf:	72 f5                	jb     800aa6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	57                   	push   %edi
  800ab7:	56                   	push   %esi
  800ab8:	53                   	push   %ebx
  800ab9:	8b 55 08             	mov    0x8(%ebp),%edx
  800abc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800abf:	eb 03                	jmp    800ac4 <strtol+0x11>
		s++;
  800ac1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ac4:	0f b6 0a             	movzbl (%edx),%ecx
  800ac7:	80 f9 09             	cmp    $0x9,%cl
  800aca:	74 f5                	je     800ac1 <strtol+0xe>
  800acc:	80 f9 20             	cmp    $0x20,%cl
  800acf:	74 f0                	je     800ac1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ad1:	80 f9 2b             	cmp    $0x2b,%cl
  800ad4:	75 0a                	jne    800ae0 <strtol+0x2d>
		s++;
  800ad6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ad9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ade:	eb 11                	jmp    800af1 <strtol+0x3e>
  800ae0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ae5:	80 f9 2d             	cmp    $0x2d,%cl
  800ae8:	75 07                	jne    800af1 <strtol+0x3e>
		s++, neg = 1;
  800aea:	8d 52 01             	lea    0x1(%edx),%edx
  800aed:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800af6:	75 15                	jne    800b0d <strtol+0x5a>
  800af8:	80 3a 30             	cmpb   $0x30,(%edx)
  800afb:	75 10                	jne    800b0d <strtol+0x5a>
  800afd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b01:	75 0a                	jne    800b0d <strtol+0x5a>
		s += 2, base = 16;
  800b03:	83 c2 02             	add    $0x2,%edx
  800b06:	b8 10 00 00 00       	mov    $0x10,%eax
  800b0b:	eb 10                	jmp    800b1d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b0d:	85 c0                	test   %eax,%eax
  800b0f:	75 0c                	jne    800b1d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b11:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b13:	80 3a 30             	cmpb   $0x30,(%edx)
  800b16:	75 05                	jne    800b1d <strtol+0x6a>
		s++, base = 8;
  800b18:	83 c2 01             	add    $0x1,%edx
  800b1b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b22:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b25:	0f b6 0a             	movzbl (%edx),%ecx
  800b28:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b2b:	89 f0                	mov    %esi,%eax
  800b2d:	3c 09                	cmp    $0x9,%al
  800b2f:	77 08                	ja     800b39 <strtol+0x86>
			dig = *s - '0';
  800b31:	0f be c9             	movsbl %cl,%ecx
  800b34:	83 e9 30             	sub    $0x30,%ecx
  800b37:	eb 20                	jmp    800b59 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b39:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b3c:	89 f0                	mov    %esi,%eax
  800b3e:	3c 19                	cmp    $0x19,%al
  800b40:	77 08                	ja     800b4a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b42:	0f be c9             	movsbl %cl,%ecx
  800b45:	83 e9 57             	sub    $0x57,%ecx
  800b48:	eb 0f                	jmp    800b59 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b4a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b4d:	89 f0                	mov    %esi,%eax
  800b4f:	3c 19                	cmp    $0x19,%al
  800b51:	77 16                	ja     800b69 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b53:	0f be c9             	movsbl %cl,%ecx
  800b56:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b59:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b5c:	7d 0f                	jge    800b6d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b5e:	83 c2 01             	add    $0x1,%edx
  800b61:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b65:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b67:	eb bc                	jmp    800b25 <strtol+0x72>
  800b69:	89 d8                	mov    %ebx,%eax
  800b6b:	eb 02                	jmp    800b6f <strtol+0xbc>
  800b6d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b73:	74 05                	je     800b7a <strtol+0xc7>
		*endptr = (char *) s;
  800b75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b78:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b7a:	f7 d8                	neg    %eax
  800b7c:	85 ff                	test   %edi,%edi
  800b7e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b81:	5b                   	pop    %ebx
  800b82:	5e                   	pop    %esi
  800b83:	5f                   	pop    %edi
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    

00800b86 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	57                   	push   %edi
  800b8a:	56                   	push   %esi
  800b8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b94:	8b 55 08             	mov    0x8(%ebp),%edx
  800b97:	89 c3                	mov    %eax,%ebx
  800b99:	89 c7                	mov    %eax,%edi
  800b9b:	89 c6                	mov    %eax,%esi
  800b9d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b9f:	5b                   	pop    %ebx
  800ba0:	5e                   	pop    %esi
  800ba1:	5f                   	pop    %edi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	57                   	push   %edi
  800ba8:	56                   	push   %esi
  800ba9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800baa:	ba 00 00 00 00       	mov    $0x0,%edx
  800baf:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb4:	89 d1                	mov    %edx,%ecx
  800bb6:	89 d3                	mov    %edx,%ebx
  800bb8:	89 d7                	mov    %edx,%edi
  800bba:	89 d6                	mov    %edx,%esi
  800bbc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bbe:	5b                   	pop    %ebx
  800bbf:	5e                   	pop    %esi
  800bc0:	5f                   	pop    %edi
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	57                   	push   %edi
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
  800bc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bcc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	89 cb                	mov    %ecx,%ebx
  800bdb:	89 cf                	mov    %ecx,%edi
  800bdd:	89 ce                	mov    %ecx,%esi
  800bdf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800be1:	85 c0                	test   %eax,%eax
  800be3:	7e 28                	jle    800c0d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800be5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800be9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800bf0:	00 
  800bf1:	c7 44 24 08 77 31 80 	movl   $0x803177,0x8(%esp)
  800bf8:	00 
  800bf9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c00:	00 
  800c01:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  800c08:	e8 a9 1c 00 00       	call   8028b6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c0d:	83 c4 2c             	add    $0x2c,%esp
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	57                   	push   %edi
  800c19:	56                   	push   %esi
  800c1a:	53                   	push   %ebx
  800c1b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c23:	b8 04 00 00 00       	mov    $0x4,%eax
  800c28:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2b:	89 cb                	mov    %ecx,%ebx
  800c2d:	89 cf                	mov    %ecx,%edi
  800c2f:	89 ce                	mov    %ecx,%esi
  800c31:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c33:	85 c0                	test   %eax,%eax
  800c35:	7e 28                	jle    800c5f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c37:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c3b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c42:	00 
  800c43:	c7 44 24 08 77 31 80 	movl   $0x803177,0x8(%esp)
  800c4a:	00 
  800c4b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c52:	00 
  800c53:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  800c5a:	e8 57 1c 00 00       	call   8028b6 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800c5f:	83 c4 2c             	add    $0x2c,%esp
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	57                   	push   %edi
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c72:	b8 02 00 00 00       	mov    $0x2,%eax
  800c77:	89 d1                	mov    %edx,%ecx
  800c79:	89 d3                	mov    %edx,%ebx
  800c7b:	89 d7                	mov    %edx,%edi
  800c7d:	89 d6                	mov    %edx,%esi
  800c7f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <sys_yield>:

void
sys_yield(void)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c91:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c96:	89 d1                	mov    %edx,%ecx
  800c98:	89 d3                	mov    %edx,%ebx
  800c9a:	89 d7                	mov    %edx,%edi
  800c9c:	89 d6                	mov    %edx,%esi
  800c9e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800cae:	be 00 00 00 00       	mov    $0x0,%esi
  800cb3:	b8 05 00 00 00       	mov    $0x5,%eax
  800cb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc1:	89 f7                	mov    %esi,%edi
  800cc3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc5:	85 c0                	test   %eax,%eax
  800cc7:	7e 28                	jle    800cf1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ccd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800cd4:	00 
  800cd5:	c7 44 24 08 77 31 80 	movl   $0x803177,0x8(%esp)
  800cdc:	00 
  800cdd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce4:	00 
  800ce5:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  800cec:	e8 c5 1b 00 00       	call   8028b6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cf1:	83 c4 2c             	add    $0x2c,%esp
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	57                   	push   %edi
  800cfd:	56                   	push   %esi
  800cfe:	53                   	push   %ebx
  800cff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d02:	b8 06 00 00 00       	mov    $0x6,%eax
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d10:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d13:	8b 75 18             	mov    0x18(%ebp),%esi
  800d16:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d18:	85 c0                	test   %eax,%eax
  800d1a:	7e 28                	jle    800d44 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d20:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d27:	00 
  800d28:	c7 44 24 08 77 31 80 	movl   $0x803177,0x8(%esp)
  800d2f:	00 
  800d30:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d37:	00 
  800d38:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  800d3f:	e8 72 1b 00 00       	call   8028b6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d44:	83 c4 2c             	add    $0x2c,%esp
  800d47:	5b                   	pop    %ebx
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	57                   	push   %edi
  800d50:	56                   	push   %esi
  800d51:	53                   	push   %ebx
  800d52:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5a:	b8 07 00 00 00       	mov    $0x7,%eax
  800d5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	89 df                	mov    %ebx,%edi
  800d67:	89 de                	mov    %ebx,%esi
  800d69:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	7e 28                	jle    800d97 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d73:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800d7a:	00 
  800d7b:	c7 44 24 08 77 31 80 	movl   $0x803177,0x8(%esp)
  800d82:	00 
  800d83:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d8a:	00 
  800d8b:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  800d92:	e8 1f 1b 00 00       	call   8028b6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d97:	83 c4 2c             	add    $0x2c,%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    

00800d9f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800daa:	b8 10 00 00 00       	mov    $0x10,%eax
  800daf:	8b 55 08             	mov    0x8(%ebp),%edx
  800db2:	89 cb                	mov    %ecx,%ebx
  800db4:	89 cf                	mov    %ecx,%edi
  800db6:	89 ce                	mov    %ecx,%esi
  800db8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5f                   	pop    %edi
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	57                   	push   %edi
  800dc3:	56                   	push   %esi
  800dc4:	53                   	push   %ebx
  800dc5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcd:	b8 09 00 00 00       	mov    $0x9,%eax
  800dd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	89 df                	mov    %ebx,%edi
  800dda:	89 de                	mov    %ebx,%esi
  800ddc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dde:	85 c0                	test   %eax,%eax
  800de0:	7e 28                	jle    800e0a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ded:	00 
  800dee:	c7 44 24 08 77 31 80 	movl   $0x803177,0x8(%esp)
  800df5:	00 
  800df6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dfd:	00 
  800dfe:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  800e05:	e8 ac 1a 00 00       	call   8028b6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e0a:	83 c4 2c             	add    $0x2c,%esp
  800e0d:	5b                   	pop    %ebx
  800e0e:	5e                   	pop    %esi
  800e0f:	5f                   	pop    %edi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    

00800e12 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	57                   	push   %edi
  800e16:	56                   	push   %esi
  800e17:	53                   	push   %ebx
  800e18:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e20:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	89 df                	mov    %ebx,%edi
  800e2d:	89 de                	mov    %ebx,%esi
  800e2f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e31:	85 c0                	test   %eax,%eax
  800e33:	7e 28                	jle    800e5d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e35:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e39:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e40:	00 
  800e41:	c7 44 24 08 77 31 80 	movl   $0x803177,0x8(%esp)
  800e48:	00 
  800e49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e50:	00 
  800e51:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  800e58:	e8 59 1a 00 00       	call   8028b6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e5d:	83 c4 2c             	add    $0x2c,%esp
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	57                   	push   %edi
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
  800e6b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e73:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7e:	89 df                	mov    %ebx,%edi
  800e80:	89 de                	mov    %ebx,%esi
  800e82:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	7e 28                	jle    800eb0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e88:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800e93:	00 
  800e94:	c7 44 24 08 77 31 80 	movl   $0x803177,0x8(%esp)
  800e9b:	00 
  800e9c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea3:	00 
  800ea4:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  800eab:	e8 06 1a 00 00       	call   8028b6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb0:	83 c4 2c             	add    $0x2c,%esp
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5f                   	pop    %edi
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    

00800eb8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebe:	be 00 00 00 00       	mov    $0x0,%esi
  800ec3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ec8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ece:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed6:	5b                   	pop    %ebx
  800ed7:	5e                   	pop    %esi
  800ed8:	5f                   	pop    %edi
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	57                   	push   %edi
  800edf:	56                   	push   %esi
  800ee0:	53                   	push   %ebx
  800ee1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef1:	89 cb                	mov    %ecx,%ebx
  800ef3:	89 cf                	mov    %ecx,%edi
  800ef5:	89 ce                	mov    %ecx,%esi
  800ef7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	7e 28                	jle    800f25 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800efd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f01:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800f08:	00 
  800f09:	c7 44 24 08 77 31 80 	movl   $0x803177,0x8(%esp)
  800f10:	00 
  800f11:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f18:	00 
  800f19:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  800f20:	e8 91 19 00 00       	call   8028b6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f25:	83 c4 2c             	add    $0x2c,%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    

00800f2d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	57                   	push   %edi
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f33:	ba 00 00 00 00       	mov    $0x0,%edx
  800f38:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f3d:	89 d1                	mov    %edx,%ecx
  800f3f:	89 d3                	mov    %edx,%ebx
  800f41:	89 d7                	mov    %edx,%edi
  800f43:	89 d6                	mov    %edx,%esi
  800f45:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f47:	5b                   	pop    %ebx
  800f48:	5e                   	pop    %esi
  800f49:	5f                   	pop    %edi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    

00800f4c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	57                   	push   %edi
  800f50:	56                   	push   %esi
  800f51:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f57:	b8 11 00 00 00       	mov    $0x11,%eax
  800f5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	89 df                	mov    %ebx,%edi
  800f64:	89 de                	mov    %ebx,%esi
  800f66:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800f68:	5b                   	pop    %ebx
  800f69:	5e                   	pop    %esi
  800f6a:	5f                   	pop    %edi
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	57                   	push   %edi
  800f71:	56                   	push   %esi
  800f72:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f78:	b8 12 00 00 00       	mov    $0x12,%eax
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	89 df                	mov    %ebx,%edi
  800f85:	89 de                	mov    %ebx,%esi
  800f87:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5f                   	pop    %edi
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    

00800f8e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f99:	b8 13 00 00 00       	mov    $0x13,%eax
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	89 cb                	mov    %ecx,%ebx
  800fa3:	89 cf                	mov    %ecx,%edi
  800fa5:	89 ce                	mov    %ecx,%esi
  800fa7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  800fa9:	5b                   	pop    %ebx
  800faa:	5e                   	pop    %esi
  800fab:	5f                   	pop    %edi
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    

00800fae <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	57                   	push   %edi
  800fb2:	56                   	push   %esi
  800fb3:	53                   	push   %ebx
  800fb4:	83 ec 2c             	sub    $0x2c,%esp
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fba:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  800fbc:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  800fbf:	89 f8                	mov    %edi,%eax
  800fc1:	c1 e8 0c             	shr    $0xc,%eax
  800fc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  800fc7:	e8 9b fc ff ff       	call   800c67 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  800fcc:	f7 c6 02 00 00 00    	test   $0x2,%esi
  800fd2:	0f 84 de 00 00 00    	je     8010b6 <pgfault+0x108>
  800fd8:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	79 20                	jns    800ffe <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  800fde:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fe2:	c7 44 24 08 a2 31 80 	movl   $0x8031a2,0x8(%esp)
  800fe9:	00 
  800fea:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  800ff1:	00 
  800ff2:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  800ff9:	e8 b8 18 00 00       	call   8028b6 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  800ffe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801001:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  801008:	25 05 08 00 00       	and    $0x805,%eax
  80100d:	3d 05 08 00 00       	cmp    $0x805,%eax
  801012:	0f 85 ba 00 00 00    	jne    8010d2 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801018:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80101f:	00 
  801020:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801027:	00 
  801028:	89 1c 24             	mov    %ebx,(%esp)
  80102b:	e8 75 fc ff ff       	call   800ca5 <sys_page_alloc>
  801030:	85 c0                	test   %eax,%eax
  801032:	79 20                	jns    801054 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  801034:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801038:	c7 44 24 08 c9 31 80 	movl   $0x8031c9,0x8(%esp)
  80103f:	00 
  801040:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801047:	00 
  801048:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  80104f:	e8 62 18 00 00       	call   8028b6 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801054:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80105a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801061:	00 
  801062:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801066:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80106d:	e8 62 f9 ff ff       	call   8009d4 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801072:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801079:	00 
  80107a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80107e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801082:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801089:	00 
  80108a:	89 1c 24             	mov    %ebx,(%esp)
  80108d:	e8 67 fc ff ff       	call   800cf9 <sys_page_map>
  801092:	85 c0                	test   %eax,%eax
  801094:	79 3c                	jns    8010d2 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801096:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80109a:	c7 44 24 08 dc 31 80 	movl   $0x8031dc,0x8(%esp)
  8010a1:	00 
  8010a2:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8010a9:	00 
  8010aa:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8010b1:	e8 00 18 00 00       	call   8028b6 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  8010b6:	c7 44 24 08 00 32 80 	movl   $0x803200,0x8(%esp)
  8010bd:	00 
  8010be:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8010c5:	00 
  8010c6:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8010cd:	e8 e4 17 00 00       	call   8028b6 <_panic>
}
  8010d2:	83 c4 2c             	add    $0x2c,%esp
  8010d5:	5b                   	pop    %ebx
  8010d6:	5e                   	pop    %esi
  8010d7:	5f                   	pop    %edi
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    

008010da <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	56                   	push   %esi
  8010de:	53                   	push   %ebx
  8010df:	83 ec 20             	sub    $0x20,%esp
  8010e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8010e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8010e8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010ef:	00 
  8010f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010f4:	89 34 24             	mov    %esi,(%esp)
  8010f7:	e8 a9 fb ff ff       	call   800ca5 <sys_page_alloc>
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	79 20                	jns    801120 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  801100:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801104:	c7 44 24 08 c9 31 80 	movl   $0x8031c9,0x8(%esp)
  80110b:	00 
  80110c:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  801113:	00 
  801114:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  80111b:	e8 96 17 00 00       	call   8028b6 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801120:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801127:	00 
  801128:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  80112f:	00 
  801130:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801137:	00 
  801138:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80113c:	89 34 24             	mov    %esi,(%esp)
  80113f:	e8 b5 fb ff ff       	call   800cf9 <sys_page_map>
  801144:	85 c0                	test   %eax,%eax
  801146:	79 20                	jns    801168 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  801148:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80114c:	c7 44 24 08 dc 31 80 	movl   $0x8031dc,0x8(%esp)
  801153:	00 
  801154:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80115b:	00 
  80115c:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  801163:	e8 4e 17 00 00       	call   8028b6 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  801168:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80116f:	00 
  801170:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801174:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  80117b:	e8 54 f8 ff ff       	call   8009d4 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801180:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801187:	00 
  801188:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80118f:	e8 b8 fb ff ff       	call   800d4c <sys_page_unmap>
  801194:	85 c0                	test   %eax,%eax
  801196:	79 20                	jns    8011b8 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801198:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80119c:	c7 44 24 08 ed 31 80 	movl   $0x8031ed,0x8(%esp)
  8011a3:	00 
  8011a4:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8011ab:	00 
  8011ac:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8011b3:	e8 fe 16 00 00       	call   8028b6 <_panic>

}
  8011b8:	83 c4 20             	add    $0x20,%esp
  8011bb:	5b                   	pop    %ebx
  8011bc:	5e                   	pop    %esi
  8011bd:	5d                   	pop    %ebp
  8011be:	c3                   	ret    

008011bf <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	57                   	push   %edi
  8011c3:	56                   	push   %esi
  8011c4:	53                   	push   %ebx
  8011c5:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  8011c8:	c7 04 24 ae 0f 80 00 	movl   $0x800fae,(%esp)
  8011cf:	e8 38 17 00 00       	call   80290c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8011d4:	b8 08 00 00 00       	mov    $0x8,%eax
  8011d9:	cd 30                	int    $0x30
  8011db:	89 c6                	mov    %eax,%esi
  8011dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	79 20                	jns    801204 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  8011e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011e8:	c7 44 24 08 24 32 80 	movl   $0x803224,0x8(%esp)
  8011ef:	00 
  8011f0:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  8011f7:	00 
  8011f8:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8011ff:	e8 b2 16 00 00       	call   8028b6 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801204:	bb 00 00 00 00       	mov    $0x0,%ebx
  801209:	85 c0                	test   %eax,%eax
  80120b:	75 21                	jne    80122e <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80120d:	e8 55 fa ff ff       	call   800c67 <sys_getenvid>
  801212:	25 ff 03 00 00       	and    $0x3ff,%eax
  801217:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80121a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80121f:	a3 08 50 80 00       	mov    %eax,0x805008
		//set_pgfault_handler(pgfault);
		return 0;
  801224:	b8 00 00 00 00       	mov    $0x0,%eax
  801229:	e9 88 01 00 00       	jmp    8013b6 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  80122e:	89 d8                	mov    %ebx,%eax
  801230:	c1 e8 16             	shr    $0x16,%eax
  801233:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80123a:	a8 01                	test   $0x1,%al
  80123c:	0f 84 e0 00 00 00    	je     801322 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801242:	89 df                	mov    %ebx,%edi
  801244:	c1 ef 0c             	shr    $0xc,%edi
  801247:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  80124e:	a8 01                	test   $0x1,%al
  801250:	0f 84 c4 00 00 00    	je     80131a <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801256:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  80125d:	f6 c4 04             	test   $0x4,%ah
  801260:	74 0d                	je     80126f <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  801262:	25 07 0e 00 00       	and    $0xe07,%eax
  801267:	83 c8 05             	or     $0x5,%eax
  80126a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80126d:	eb 1b                	jmp    80128a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  80126f:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801274:	83 f8 01             	cmp    $0x1,%eax
  801277:	19 c0                	sbb    %eax,%eax
  801279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80127c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801283:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  80128a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  80128d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801290:	89 44 24 10          	mov    %eax,0x10(%esp)
  801294:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801298:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80129b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80129f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012aa:	e8 4a fa ff ff       	call   800cf9 <sys_page_map>
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	79 20                	jns    8012d3 <fork+0x114>
		panic("sys_page_map: %e", r);
  8012b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012b7:	c7 44 24 08 dc 31 80 	movl   $0x8031dc,0x8(%esp)
  8012be:	00 
  8012bf:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  8012c6:	00 
  8012c7:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8012ce:	e8 e3 15 00 00       	call   8028b6 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  8012d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012da:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012e5:	00 
  8012e6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012f1:	e8 03 fa ff ff       	call   800cf9 <sys_page_map>
  8012f6:	85 c0                	test   %eax,%eax
  8012f8:	79 20                	jns    80131a <fork+0x15b>
		panic("sys_page_map: %e", r);
  8012fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012fe:	c7 44 24 08 dc 31 80 	movl   $0x8031dc,0x8(%esp)
  801305:	00 
  801306:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  80130d:	00 
  80130e:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  801315:	e8 9c 15 00 00       	call   8028b6 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  80131a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801320:	eb 06                	jmp    801328 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  801322:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  801328:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  80132e:	0f 86 fa fe ff ff    	jbe    80122e <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801334:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80133b:	00 
  80133c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801343:	ee 
  801344:	89 34 24             	mov    %esi,(%esp)
  801347:	e8 59 f9 ff ff       	call   800ca5 <sys_page_alloc>
  80134c:	85 c0                	test   %eax,%eax
  80134e:	79 20                	jns    801370 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801350:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801354:	c7 44 24 08 c9 31 80 	movl   $0x8031c9,0x8(%esp)
  80135b:	00 
  80135c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  801363:	00 
  801364:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  80136b:	e8 46 15 00 00       	call   8028b6 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801370:	c7 44 24 04 9f 29 80 	movl   $0x80299f,0x4(%esp)
  801377:	00 
  801378:	89 34 24             	mov    %esi,(%esp)
  80137b:	e8 e5 fa ff ff       	call   800e65 <sys_env_set_pgfault_upcall>
  801380:	85 c0                	test   %eax,%eax
  801382:	79 20                	jns    8013a4 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801384:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801388:	c7 44 24 08 48 32 80 	movl   $0x803248,0x8(%esp)
  80138f:	00 
  801390:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801397:	00 
  801398:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  80139f:	e8 12 15 00 00       	call   8028b6 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  8013a4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013ab:	00 
  8013ac:	89 34 24             	mov    %esi,(%esp)
  8013af:	e8 0b fa ff ff       	call   800dbf <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  8013b4:	89 f0                	mov    %esi,%eax

}
  8013b6:	83 c4 2c             	add    $0x2c,%esp
  8013b9:	5b                   	pop    %ebx
  8013ba:	5e                   	pop    %esi
  8013bb:	5f                   	pop    %edi
  8013bc:	5d                   	pop    %ebp
  8013bd:	c3                   	ret    

008013be <sfork>:

// Challenge!
int
sfork(void)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	57                   	push   %edi
  8013c2:	56                   	push   %esi
  8013c3:	53                   	push   %ebx
  8013c4:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  8013c7:	c7 04 24 ae 0f 80 00 	movl   $0x800fae,(%esp)
  8013ce:	e8 39 15 00 00       	call   80290c <set_pgfault_handler>
  8013d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8013d8:	cd 30                	int    $0x30
  8013da:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	79 20                	jns    801400 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  8013e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013e4:	c7 44 24 08 24 32 80 	movl   $0x803224,0x8(%esp)
  8013eb:	00 
  8013ec:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  8013f3:	00 
  8013f4:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8013fb:	e8 b6 14 00 00       	call   8028b6 <_panic>
  801400:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801402:	bb 00 00 00 00       	mov    $0x0,%ebx
  801407:	85 c0                	test   %eax,%eax
  801409:	75 2d                	jne    801438 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80140b:	e8 57 f8 ff ff       	call   800c67 <sys_getenvid>
  801410:	25 ff 03 00 00       	and    $0x3ff,%eax
  801415:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801418:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80141d:	a3 08 50 80 00       	mov    %eax,0x805008
		set_pgfault_handler(pgfault);
  801422:	c7 04 24 ae 0f 80 00 	movl   $0x800fae,(%esp)
  801429:	e8 de 14 00 00       	call   80290c <set_pgfault_handler>
		return 0;
  80142e:	b8 00 00 00 00       	mov    $0x0,%eax
  801433:	e9 1d 01 00 00       	jmp    801555 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801438:	89 d8                	mov    %ebx,%eax
  80143a:	c1 e8 16             	shr    $0x16,%eax
  80143d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801444:	a8 01                	test   $0x1,%al
  801446:	74 69                	je     8014b1 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801448:	89 d8                	mov    %ebx,%eax
  80144a:	c1 e8 0c             	shr    $0xc,%eax
  80144d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801454:	f6 c2 01             	test   $0x1,%dl
  801457:	74 50                	je     8014a9 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801459:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801460:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  801463:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801469:	89 54 24 10          	mov    %edx,0x10(%esp)
  80146d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801471:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801475:	89 44 24 04          	mov    %eax,0x4(%esp)
  801479:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801480:	e8 74 f8 ff ff       	call   800cf9 <sys_page_map>
  801485:	85 c0                	test   %eax,%eax
  801487:	79 20                	jns    8014a9 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801489:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80148d:	c7 44 24 08 dc 31 80 	movl   $0x8031dc,0x8(%esp)
  801494:	00 
  801495:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  80149c:	00 
  80149d:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  8014a4:	e8 0d 14 00 00       	call   8028b6 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8014a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014af:	eb 06                	jmp    8014b7 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  8014b1:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  8014b7:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  8014bd:	0f 86 75 ff ff ff    	jbe    801438 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  8014c3:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  8014ca:	ee 
  8014cb:	89 34 24             	mov    %esi,(%esp)
  8014ce:	e8 07 fc ff ff       	call   8010da <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8014d3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014da:	00 
  8014db:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014e2:	ee 
  8014e3:	89 34 24             	mov    %esi,(%esp)
  8014e6:	e8 ba f7 ff ff       	call   800ca5 <sys_page_alloc>
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	79 20                	jns    80150f <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  8014ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014f3:	c7 44 24 08 c9 31 80 	movl   $0x8031c9,0x8(%esp)
  8014fa:	00 
  8014fb:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  801502:	00 
  801503:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  80150a:	e8 a7 13 00 00       	call   8028b6 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80150f:	c7 44 24 04 9f 29 80 	movl   $0x80299f,0x4(%esp)
  801516:	00 
  801517:	89 34 24             	mov    %esi,(%esp)
  80151a:	e8 46 f9 ff ff       	call   800e65 <sys_env_set_pgfault_upcall>
  80151f:	85 c0                	test   %eax,%eax
  801521:	79 20                	jns    801543 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  801523:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801527:	c7 44 24 08 48 32 80 	movl   $0x803248,0x8(%esp)
  80152e:	00 
  80152f:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  801536:	00 
  801537:	c7 04 24 be 31 80 00 	movl   $0x8031be,(%esp)
  80153e:	e8 73 13 00 00       	call   8028b6 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801543:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80154a:	00 
  80154b:	89 34 24             	mov    %esi,(%esp)
  80154e:	e8 6c f8 ff ff       	call   800dbf <sys_env_set_status>
	return envid;
  801553:	89 f0                	mov    %esi,%eax

}
  801555:	83 c4 2c             	add    $0x2c,%esp
  801558:	5b                   	pop    %ebx
  801559:	5e                   	pop    %esi
  80155a:	5f                   	pop    %edi
  80155b:	5d                   	pop    %ebp
  80155c:	c3                   	ret    
  80155d:	66 90                	xchg   %ax,%ax
  80155f:	90                   	nop

00801560 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	05 00 00 00 30       	add    $0x30000000,%eax
  80156b:	c1 e8 0c             	shr    $0xc,%eax
}
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80157b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801580:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801585:	5d                   	pop    %ebp
  801586:	c3                   	ret    

00801587 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801592:	89 c2                	mov    %eax,%edx
  801594:	c1 ea 16             	shr    $0x16,%edx
  801597:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80159e:	f6 c2 01             	test   $0x1,%dl
  8015a1:	74 11                	je     8015b4 <fd_alloc+0x2d>
  8015a3:	89 c2                	mov    %eax,%edx
  8015a5:	c1 ea 0c             	shr    $0xc,%edx
  8015a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015af:	f6 c2 01             	test   $0x1,%dl
  8015b2:	75 09                	jne    8015bd <fd_alloc+0x36>
			*fd_store = fd;
  8015b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bb:	eb 17                	jmp    8015d4 <fd_alloc+0x4d>
  8015bd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8015c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015c7:	75 c9                	jne    801592 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015c9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8015cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015d4:	5d                   	pop    %ebp
  8015d5:	c3                   	ret    

008015d6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015dc:	83 f8 1f             	cmp    $0x1f,%eax
  8015df:	77 36                	ja     801617 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015e1:	c1 e0 0c             	shl    $0xc,%eax
  8015e4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015e9:	89 c2                	mov    %eax,%edx
  8015eb:	c1 ea 16             	shr    $0x16,%edx
  8015ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015f5:	f6 c2 01             	test   $0x1,%dl
  8015f8:	74 24                	je     80161e <fd_lookup+0x48>
  8015fa:	89 c2                	mov    %eax,%edx
  8015fc:	c1 ea 0c             	shr    $0xc,%edx
  8015ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801606:	f6 c2 01             	test   $0x1,%dl
  801609:	74 1a                	je     801625 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80160b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160e:	89 02                	mov    %eax,(%edx)
	return 0;
  801610:	b8 00 00 00 00       	mov    $0x0,%eax
  801615:	eb 13                	jmp    80162a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801617:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161c:	eb 0c                	jmp    80162a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80161e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801623:	eb 05                	jmp    80162a <fd_lookup+0x54>
  801625:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    

0080162c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 18             	sub    $0x18,%esp
  801632:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801635:	ba 00 00 00 00       	mov    $0x0,%edx
  80163a:	eb 13                	jmp    80164f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80163c:	39 08                	cmp    %ecx,(%eax)
  80163e:	75 0c                	jne    80164c <dev_lookup+0x20>
			*dev = devtab[i];
  801640:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801643:	89 01                	mov    %eax,(%ecx)
			return 0;
  801645:	b8 00 00 00 00       	mov    $0x0,%eax
  80164a:	eb 38                	jmp    801684 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80164c:	83 c2 01             	add    $0x1,%edx
  80164f:	8b 04 95 e8 32 80 00 	mov    0x8032e8(,%edx,4),%eax
  801656:	85 c0                	test   %eax,%eax
  801658:	75 e2                	jne    80163c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80165a:	a1 08 50 80 00       	mov    0x805008,%eax
  80165f:	8b 40 48             	mov    0x48(%eax),%eax
  801662:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801666:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166a:	c7 04 24 6c 32 80 00 	movl   $0x80326c,(%esp)
  801671:	e8 4d eb ff ff       	call   8001c3 <cprintf>
	*dev = 0;
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80167f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	56                   	push   %esi
  80168a:	53                   	push   %ebx
  80168b:	83 ec 20             	sub    $0x20,%esp
  80168e:	8b 75 08             	mov    0x8(%ebp),%esi
  801691:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801694:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801697:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80169b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016a1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016a4:	89 04 24             	mov    %eax,(%esp)
  8016a7:	e8 2a ff ff ff       	call   8015d6 <fd_lookup>
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	78 05                	js     8016b5 <fd_close+0x2f>
	    || fd != fd2)
  8016b0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016b3:	74 0c                	je     8016c1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8016b5:	84 db                	test   %bl,%bl
  8016b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bc:	0f 44 c2             	cmove  %edx,%eax
  8016bf:	eb 3f                	jmp    801700 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c8:	8b 06                	mov    (%esi),%eax
  8016ca:	89 04 24             	mov    %eax,(%esp)
  8016cd:	e8 5a ff ff ff       	call   80162c <dev_lookup>
  8016d2:	89 c3                	mov    %eax,%ebx
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	78 16                	js     8016ee <fd_close+0x68>
		if (dev->dev_close)
  8016d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8016de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	74 07                	je     8016ee <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8016e7:	89 34 24             	mov    %esi,(%esp)
  8016ea:	ff d0                	call   *%eax
  8016ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f9:	e8 4e f6 ff ff       	call   800d4c <sys_page_unmap>
	return r;
  8016fe:	89 d8                	mov    %ebx,%eax
}
  801700:	83 c4 20             	add    $0x20,%esp
  801703:	5b                   	pop    %ebx
  801704:	5e                   	pop    %esi
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    

00801707 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80170d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801710:	89 44 24 04          	mov    %eax,0x4(%esp)
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	89 04 24             	mov    %eax,(%esp)
  80171a:	e8 b7 fe ff ff       	call   8015d6 <fd_lookup>
  80171f:	89 c2                	mov    %eax,%edx
  801721:	85 d2                	test   %edx,%edx
  801723:	78 13                	js     801738 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801725:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80172c:	00 
  80172d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801730:	89 04 24             	mov    %eax,(%esp)
  801733:	e8 4e ff ff ff       	call   801686 <fd_close>
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <close_all>:

void
close_all(void)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801741:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801746:	89 1c 24             	mov    %ebx,(%esp)
  801749:	e8 b9 ff ff ff       	call   801707 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80174e:	83 c3 01             	add    $0x1,%ebx
  801751:	83 fb 20             	cmp    $0x20,%ebx
  801754:	75 f0                	jne    801746 <close_all+0xc>
		close(i);
}
  801756:	83 c4 14             	add    $0x14,%esp
  801759:	5b                   	pop    %ebx
  80175a:	5d                   	pop    %ebp
  80175b:	c3                   	ret    

0080175c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	57                   	push   %edi
  801760:	56                   	push   %esi
  801761:	53                   	push   %ebx
  801762:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801765:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801768:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	89 04 24             	mov    %eax,(%esp)
  801772:	e8 5f fe ff ff       	call   8015d6 <fd_lookup>
  801777:	89 c2                	mov    %eax,%edx
  801779:	85 d2                	test   %edx,%edx
  80177b:	0f 88 e1 00 00 00    	js     801862 <dup+0x106>
		return r;
	close(newfdnum);
  801781:	8b 45 0c             	mov    0xc(%ebp),%eax
  801784:	89 04 24             	mov    %eax,(%esp)
  801787:	e8 7b ff ff ff       	call   801707 <close>

	newfd = INDEX2FD(newfdnum);
  80178c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80178f:	c1 e3 0c             	shl    $0xc,%ebx
  801792:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80179b:	89 04 24             	mov    %eax,(%esp)
  80179e:	e8 cd fd ff ff       	call   801570 <fd2data>
  8017a3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8017a5:	89 1c 24             	mov    %ebx,(%esp)
  8017a8:	e8 c3 fd ff ff       	call   801570 <fd2data>
  8017ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017af:	89 f0                	mov    %esi,%eax
  8017b1:	c1 e8 16             	shr    $0x16,%eax
  8017b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017bb:	a8 01                	test   $0x1,%al
  8017bd:	74 43                	je     801802 <dup+0xa6>
  8017bf:	89 f0                	mov    %esi,%eax
  8017c1:	c1 e8 0c             	shr    $0xc,%eax
  8017c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017cb:	f6 c2 01             	test   $0x1,%dl
  8017ce:	74 32                	je     801802 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017e0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017eb:	00 
  8017ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f7:	e8 fd f4 ff ff       	call   800cf9 <sys_page_map>
  8017fc:	89 c6                	mov    %eax,%esi
  8017fe:	85 c0                	test   %eax,%eax
  801800:	78 3e                	js     801840 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801805:	89 c2                	mov    %eax,%edx
  801807:	c1 ea 0c             	shr    $0xc,%edx
  80180a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801811:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801817:	89 54 24 10          	mov    %edx,0x10(%esp)
  80181b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80181f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801826:	00 
  801827:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801832:	e8 c2 f4 ff ff       	call   800cf9 <sys_page_map>
  801837:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80183c:	85 f6                	test   %esi,%esi
  80183e:	79 22                	jns    801862 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801840:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801844:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80184b:	e8 fc f4 ff ff       	call   800d4c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801850:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801854:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80185b:	e8 ec f4 ff ff       	call   800d4c <sys_page_unmap>
	return r;
  801860:	89 f0                	mov    %esi,%eax
}
  801862:	83 c4 3c             	add    $0x3c,%esp
  801865:	5b                   	pop    %ebx
  801866:	5e                   	pop    %esi
  801867:	5f                   	pop    %edi
  801868:	5d                   	pop    %ebp
  801869:	c3                   	ret    

0080186a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	53                   	push   %ebx
  80186e:	83 ec 24             	sub    $0x24,%esp
  801871:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801874:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801877:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187b:	89 1c 24             	mov    %ebx,(%esp)
  80187e:	e8 53 fd ff ff       	call   8015d6 <fd_lookup>
  801883:	89 c2                	mov    %eax,%edx
  801885:	85 d2                	test   %edx,%edx
  801887:	78 6d                	js     8018f6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801889:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801893:	8b 00                	mov    (%eax),%eax
  801895:	89 04 24             	mov    %eax,(%esp)
  801898:	e8 8f fd ff ff       	call   80162c <dev_lookup>
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 55                	js     8018f6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a4:	8b 50 08             	mov    0x8(%eax),%edx
  8018a7:	83 e2 03             	and    $0x3,%edx
  8018aa:	83 fa 01             	cmp    $0x1,%edx
  8018ad:	75 23                	jne    8018d2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018af:	a1 08 50 80 00       	mov    0x805008,%eax
  8018b4:	8b 40 48             	mov    0x48(%eax),%eax
  8018b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bf:	c7 04 24 ad 32 80 00 	movl   $0x8032ad,(%esp)
  8018c6:	e8 f8 e8 ff ff       	call   8001c3 <cprintf>
		return -E_INVAL;
  8018cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d0:	eb 24                	jmp    8018f6 <read+0x8c>
	}
	if (!dev->dev_read)
  8018d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d5:	8b 52 08             	mov    0x8(%edx),%edx
  8018d8:	85 d2                	test   %edx,%edx
  8018da:	74 15                	je     8018f1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018ea:	89 04 24             	mov    %eax,(%esp)
  8018ed:	ff d2                	call   *%edx
  8018ef:	eb 05                	jmp    8018f6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018f6:	83 c4 24             	add    $0x24,%esp
  8018f9:	5b                   	pop    %ebx
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    

008018fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	57                   	push   %edi
  801900:	56                   	push   %esi
  801901:	53                   	push   %ebx
  801902:	83 ec 1c             	sub    $0x1c,%esp
  801905:	8b 7d 08             	mov    0x8(%ebp),%edi
  801908:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80190b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801910:	eb 23                	jmp    801935 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801912:	89 f0                	mov    %esi,%eax
  801914:	29 d8                	sub    %ebx,%eax
  801916:	89 44 24 08          	mov    %eax,0x8(%esp)
  80191a:	89 d8                	mov    %ebx,%eax
  80191c:	03 45 0c             	add    0xc(%ebp),%eax
  80191f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801923:	89 3c 24             	mov    %edi,(%esp)
  801926:	e8 3f ff ff ff       	call   80186a <read>
		if (m < 0)
  80192b:	85 c0                	test   %eax,%eax
  80192d:	78 10                	js     80193f <readn+0x43>
			return m;
		if (m == 0)
  80192f:	85 c0                	test   %eax,%eax
  801931:	74 0a                	je     80193d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801933:	01 c3                	add    %eax,%ebx
  801935:	39 f3                	cmp    %esi,%ebx
  801937:	72 d9                	jb     801912 <readn+0x16>
  801939:	89 d8                	mov    %ebx,%eax
  80193b:	eb 02                	jmp    80193f <readn+0x43>
  80193d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80193f:	83 c4 1c             	add    $0x1c,%esp
  801942:	5b                   	pop    %ebx
  801943:	5e                   	pop    %esi
  801944:	5f                   	pop    %edi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	53                   	push   %ebx
  80194b:	83 ec 24             	sub    $0x24,%esp
  80194e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801951:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801954:	89 44 24 04          	mov    %eax,0x4(%esp)
  801958:	89 1c 24             	mov    %ebx,(%esp)
  80195b:	e8 76 fc ff ff       	call   8015d6 <fd_lookup>
  801960:	89 c2                	mov    %eax,%edx
  801962:	85 d2                	test   %edx,%edx
  801964:	78 68                	js     8019ce <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801966:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801969:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	89 04 24             	mov    %eax,(%esp)
  801975:	e8 b2 fc ff ff       	call   80162c <dev_lookup>
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 50                	js     8019ce <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80197e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801981:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801985:	75 23                	jne    8019aa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801987:	a1 08 50 80 00       	mov    0x805008,%eax
  80198c:	8b 40 48             	mov    0x48(%eax),%eax
  80198f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801993:	89 44 24 04          	mov    %eax,0x4(%esp)
  801997:	c7 04 24 c9 32 80 00 	movl   $0x8032c9,(%esp)
  80199e:	e8 20 e8 ff ff       	call   8001c3 <cprintf>
		return -E_INVAL;
  8019a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019a8:	eb 24                	jmp    8019ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8019b0:	85 d2                	test   %edx,%edx
  8019b2:	74 15                	je     8019c9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019c2:	89 04 24             	mov    %eax,(%esp)
  8019c5:	ff d2                	call   *%edx
  8019c7:	eb 05                	jmp    8019ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8019c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8019ce:	83 c4 24             	add    $0x24,%esp
  8019d1:	5b                   	pop    %ebx
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019da:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	89 04 24             	mov    %eax,(%esp)
  8019e7:	e8 ea fb ff ff       	call   8015d6 <fd_lookup>
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	78 0e                	js     8019fe <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	53                   	push   %ebx
  801a04:	83 ec 24             	sub    $0x24,%esp
  801a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a0a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a11:	89 1c 24             	mov    %ebx,(%esp)
  801a14:	e8 bd fb ff ff       	call   8015d6 <fd_lookup>
  801a19:	89 c2                	mov    %eax,%edx
  801a1b:	85 d2                	test   %edx,%edx
  801a1d:	78 61                	js     801a80 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a22:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a29:	8b 00                	mov    (%eax),%eax
  801a2b:	89 04 24             	mov    %eax,(%esp)
  801a2e:	e8 f9 fb ff ff       	call   80162c <dev_lookup>
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 49                	js     801a80 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a3e:	75 23                	jne    801a63 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a40:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a45:	8b 40 48             	mov    0x48(%eax),%eax
  801a48:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a50:	c7 04 24 8c 32 80 00 	movl   $0x80328c,(%esp)
  801a57:	e8 67 e7 ff ff       	call   8001c3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a61:	eb 1d                	jmp    801a80 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a66:	8b 52 18             	mov    0x18(%edx),%edx
  801a69:	85 d2                	test   %edx,%edx
  801a6b:	74 0e                	je     801a7b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a70:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a74:	89 04 24             	mov    %eax,(%esp)
  801a77:	ff d2                	call   *%edx
  801a79:	eb 05                	jmp    801a80 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a7b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a80:	83 c4 24             	add    $0x24,%esp
  801a83:	5b                   	pop    %ebx
  801a84:	5d                   	pop    %ebp
  801a85:	c3                   	ret    

00801a86 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	53                   	push   %ebx
  801a8a:	83 ec 24             	sub    $0x24,%esp
  801a8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a90:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	89 04 24             	mov    %eax,(%esp)
  801a9d:	e8 34 fb ff ff       	call   8015d6 <fd_lookup>
  801aa2:	89 c2                	mov    %eax,%edx
  801aa4:	85 d2                	test   %edx,%edx
  801aa6:	78 52                	js     801afa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab2:	8b 00                	mov    (%eax),%eax
  801ab4:	89 04 24             	mov    %eax,(%esp)
  801ab7:	e8 70 fb ff ff       	call   80162c <dev_lookup>
  801abc:	85 c0                	test   %eax,%eax
  801abe:	78 3a                	js     801afa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ac7:	74 2c                	je     801af5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ac9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801acc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ad3:	00 00 00 
	stat->st_isdir = 0;
  801ad6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801add:	00 00 00 
	stat->st_dev = dev;
  801ae0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ae6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aed:	89 14 24             	mov    %edx,(%esp)
  801af0:	ff 50 14             	call   *0x14(%eax)
  801af3:	eb 05                	jmp    801afa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801af5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801afa:	83 c4 24             	add    $0x24,%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    

00801b00 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	56                   	push   %esi
  801b04:	53                   	push   %ebx
  801b05:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b0f:	00 
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	89 04 24             	mov    %eax,(%esp)
  801b16:	e8 99 02 00 00       	call   801db4 <open>
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	85 db                	test   %ebx,%ebx
  801b1f:	78 1b                	js     801b3c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b28:	89 1c 24             	mov    %ebx,(%esp)
  801b2b:	e8 56 ff ff ff       	call   801a86 <fstat>
  801b30:	89 c6                	mov    %eax,%esi
	close(fd);
  801b32:	89 1c 24             	mov    %ebx,(%esp)
  801b35:	e8 cd fb ff ff       	call   801707 <close>
	return r;
  801b3a:	89 f0                	mov    %esi,%eax
}
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5d                   	pop    %ebp
  801b42:	c3                   	ret    

00801b43 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	83 ec 10             	sub    $0x10,%esp
  801b4b:	89 c6                	mov    %eax,%esi
  801b4d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b4f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b56:	75 11                	jne    801b69 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b5f:	e8 3b 0f 00 00       	call   802a9f <ipc_find_env>
  801b64:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b69:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b70:	00 
  801b71:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b78:	00 
  801b79:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b7d:	a1 00 50 80 00       	mov    0x805000,%eax
  801b82:	89 04 24             	mov    %eax,(%esp)
  801b85:	e8 ae 0e 00 00       	call   802a38 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b8a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b91:	00 
  801b92:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b9d:	e8 2e 0e 00 00       	call   8029d0 <ipc_recv>
}
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	5b                   	pop    %ebx
  801ba6:	5e                   	pop    %esi
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    

00801ba9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc7:	b8 02 00 00 00       	mov    $0x2,%eax
  801bcc:	e8 72 ff ff ff       	call   801b43 <fsipc>
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bdf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801be4:	ba 00 00 00 00       	mov    $0x0,%edx
  801be9:	b8 06 00 00 00       	mov    $0x6,%eax
  801bee:	e8 50 ff ff ff       	call   801b43 <fsipc>
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	53                   	push   %ebx
  801bf9:	83 ec 14             	sub    $0x14,%esp
  801bfc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	8b 40 0c             	mov    0xc(%eax),%eax
  801c05:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c14:	e8 2a ff ff ff       	call   801b43 <fsipc>
  801c19:	89 c2                	mov    %eax,%edx
  801c1b:	85 d2                	test   %edx,%edx
  801c1d:	78 2b                	js     801c4a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c1f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c26:	00 
  801c27:	89 1c 24             	mov    %ebx,(%esp)
  801c2a:	e8 08 ec ff ff       	call   800837 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c2f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c34:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c3a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c3f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4a:	83 c4 14             	add    $0x14,%esp
  801c4d:	5b                   	pop    %ebx
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    

00801c50 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	53                   	push   %ebx
  801c54:	83 ec 14             	sub    $0x14,%esp
  801c57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801c5a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801c60:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801c65:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c68:	8b 55 08             	mov    0x8(%ebp),%edx
  801c6b:	8b 52 0c             	mov    0xc(%edx),%edx
  801c6e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801c74:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801c79:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c84:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c8b:	e8 44 ed ff ff       	call   8009d4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801c90:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801c97:	00 
  801c98:	c7 04 24 fc 32 80 00 	movl   $0x8032fc,(%esp)
  801c9f:	e8 1f e5 ff ff       	call   8001c3 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ca4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca9:	b8 04 00 00 00       	mov    $0x4,%eax
  801cae:	e8 90 fe ff ff       	call   801b43 <fsipc>
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	78 53                	js     801d0a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801cb7:	39 c3                	cmp    %eax,%ebx
  801cb9:	73 24                	jae    801cdf <devfile_write+0x8f>
  801cbb:	c7 44 24 0c 01 33 80 	movl   $0x803301,0xc(%esp)
  801cc2:	00 
  801cc3:	c7 44 24 08 08 33 80 	movl   $0x803308,0x8(%esp)
  801cca:	00 
  801ccb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801cd2:	00 
  801cd3:	c7 04 24 1d 33 80 00 	movl   $0x80331d,(%esp)
  801cda:	e8 d7 0b 00 00       	call   8028b6 <_panic>
	assert(r <= PGSIZE);
  801cdf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ce4:	7e 24                	jle    801d0a <devfile_write+0xba>
  801ce6:	c7 44 24 0c 28 33 80 	movl   $0x803328,0xc(%esp)
  801ced:	00 
  801cee:	c7 44 24 08 08 33 80 	movl   $0x803308,0x8(%esp)
  801cf5:	00 
  801cf6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801cfd:	00 
  801cfe:	c7 04 24 1d 33 80 00 	movl   $0x80331d,(%esp)
  801d05:	e8 ac 0b 00 00       	call   8028b6 <_panic>
	return r;
}
  801d0a:	83 c4 14             	add    $0x14,%esp
  801d0d:	5b                   	pop    %ebx
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    

00801d10 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	56                   	push   %esi
  801d14:	53                   	push   %ebx
  801d15:	83 ec 10             	sub    $0x10,%esp
  801d18:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d21:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d26:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d31:	b8 03 00 00 00       	mov    $0x3,%eax
  801d36:	e8 08 fe ff ff       	call   801b43 <fsipc>
  801d3b:	89 c3                	mov    %eax,%ebx
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	78 6a                	js     801dab <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d41:	39 c6                	cmp    %eax,%esi
  801d43:	73 24                	jae    801d69 <devfile_read+0x59>
  801d45:	c7 44 24 0c 01 33 80 	movl   $0x803301,0xc(%esp)
  801d4c:	00 
  801d4d:	c7 44 24 08 08 33 80 	movl   $0x803308,0x8(%esp)
  801d54:	00 
  801d55:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d5c:	00 
  801d5d:	c7 04 24 1d 33 80 00 	movl   $0x80331d,(%esp)
  801d64:	e8 4d 0b 00 00       	call   8028b6 <_panic>
	assert(r <= PGSIZE);
  801d69:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d6e:	7e 24                	jle    801d94 <devfile_read+0x84>
  801d70:	c7 44 24 0c 28 33 80 	movl   $0x803328,0xc(%esp)
  801d77:	00 
  801d78:	c7 44 24 08 08 33 80 	movl   $0x803308,0x8(%esp)
  801d7f:	00 
  801d80:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d87:	00 
  801d88:	c7 04 24 1d 33 80 00 	movl   $0x80331d,(%esp)
  801d8f:	e8 22 0b 00 00       	call   8028b6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d94:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d98:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d9f:	00 
  801da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da3:	89 04 24             	mov    %eax,(%esp)
  801da6:	e8 29 ec ff ff       	call   8009d4 <memmove>
	return r;
}
  801dab:	89 d8                	mov    %ebx,%eax
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    

00801db4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	53                   	push   %ebx
  801db8:	83 ec 24             	sub    $0x24,%esp
  801dbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801dbe:	89 1c 24             	mov    %ebx,(%esp)
  801dc1:	e8 3a ea ff ff       	call   800800 <strlen>
  801dc6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dcb:	7f 60                	jg     801e2d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801dcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd0:	89 04 24             	mov    %eax,(%esp)
  801dd3:	e8 af f7 ff ff       	call   801587 <fd_alloc>
  801dd8:	89 c2                	mov    %eax,%edx
  801dda:	85 d2                	test   %edx,%edx
  801ddc:	78 54                	js     801e32 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801dde:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801de2:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801de9:	e8 49 ea ff ff       	call   800837 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df1:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801df6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfe:	e8 40 fd ff ff       	call   801b43 <fsipc>
  801e03:	89 c3                	mov    %eax,%ebx
  801e05:	85 c0                	test   %eax,%eax
  801e07:	79 17                	jns    801e20 <open+0x6c>
		fd_close(fd, 0);
  801e09:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e10:	00 
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e14:	89 04 24             	mov    %eax,(%esp)
  801e17:	e8 6a f8 ff ff       	call   801686 <fd_close>
		return r;
  801e1c:	89 d8                	mov    %ebx,%eax
  801e1e:	eb 12                	jmp    801e32 <open+0x7e>
	}

	return fd2num(fd);
  801e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e23:	89 04 24             	mov    %eax,(%esp)
  801e26:	e8 35 f7 ff ff       	call   801560 <fd2num>
  801e2b:	eb 05                	jmp    801e32 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801e2d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801e32:	83 c4 24             	add    $0x24,%esp
  801e35:	5b                   	pop    %ebx
  801e36:	5d                   	pop    %ebp
  801e37:	c3                   	ret    

00801e38 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e43:	b8 08 00 00 00       	mov    $0x8,%eax
  801e48:	e8 f6 fc ff ff       	call   801b43 <fsipc>
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <evict>:

int evict(void)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801e55:	c7 04 24 34 33 80 00 	movl   $0x803334,(%esp)
  801e5c:	e8 62 e3 ff ff       	call   8001c3 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801e61:	ba 00 00 00 00       	mov    $0x0,%edx
  801e66:	b8 09 00 00 00       	mov    $0x9,%eax
  801e6b:	e8 d3 fc ff ff       	call   801b43 <fsipc>
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    
  801e72:	66 90                	xchg   %ax,%ax
  801e74:	66 90                	xchg   %ax,%ax
  801e76:	66 90                	xchg   %ax,%ax
  801e78:	66 90                	xchg   %ax,%ax
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	66 90                	xchg   %ax,%ax
  801e7e:	66 90                	xchg   %ax,%ax

00801e80 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e86:	c7 44 24 04 4d 33 80 	movl   $0x80334d,0x4(%esp)
  801e8d:	00 
  801e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e91:	89 04 24             	mov    %eax,(%esp)
  801e94:	e8 9e e9 ff ff       	call   800837 <strcpy>
	return 0;
}
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 14             	sub    $0x14,%esp
  801ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801eaa:	89 1c 24             	mov    %ebx,(%esp)
  801ead:	e8 25 0c 00 00       	call   802ad7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801eb2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801eb7:	83 f8 01             	cmp    $0x1,%eax
  801eba:	75 0d                	jne    801ec9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801ebc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801ebf:	89 04 24             	mov    %eax,(%esp)
  801ec2:	e8 29 03 00 00       	call   8021f0 <nsipc_close>
  801ec7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801ec9:	89 d0                	mov    %edx,%eax
  801ecb:	83 c4 14             	add    $0x14,%esp
  801ece:	5b                   	pop    %ebx
  801ecf:	5d                   	pop    %ebp
  801ed0:	c3                   	ret    

00801ed1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ed7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ede:	00 
  801edf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef3:	89 04 24             	mov    %eax,(%esp)
  801ef6:	e8 f0 03 00 00       	call   8022eb <nsipc_send>
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f03:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f0a:	00 
  801f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1f:	89 04 24             	mov    %eax,(%esp)
  801f22:	e8 44 03 00 00       	call   80226b <nsipc_recv>
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f2f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f32:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f36:	89 04 24             	mov    %eax,(%esp)
  801f39:	e8 98 f6 ff ff       	call   8015d6 <fd_lookup>
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	78 17                	js     801f59 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f4b:	39 08                	cmp    %ecx,(%eax)
  801f4d:	75 05                	jne    801f54 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f52:	eb 05                	jmp    801f59 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801f54:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	56                   	push   %esi
  801f5f:	53                   	push   %ebx
  801f60:	83 ec 20             	sub    $0x20,%esp
  801f63:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f68:	89 04 24             	mov    %eax,(%esp)
  801f6b:	e8 17 f6 ff ff       	call   801587 <fd_alloc>
  801f70:	89 c3                	mov    %eax,%ebx
  801f72:	85 c0                	test   %eax,%eax
  801f74:	78 21                	js     801f97 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f76:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f7d:	00 
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f8c:	e8 14 ed ff ff       	call   800ca5 <sys_page_alloc>
  801f91:	89 c3                	mov    %eax,%ebx
  801f93:	85 c0                	test   %eax,%eax
  801f95:	79 0c                	jns    801fa3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f97:	89 34 24             	mov    %esi,(%esp)
  801f9a:	e8 51 02 00 00       	call   8021f0 <nsipc_close>
		return r;
  801f9f:	89 d8                	mov    %ebx,%eax
  801fa1:	eb 20                	jmp    801fc3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801fa3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801fb8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801fbb:	89 14 24             	mov    %edx,(%esp)
  801fbe:	e8 9d f5 ff ff       	call   801560 <fd2num>
}
  801fc3:	83 c4 20             	add    $0x20,%esp
  801fc6:	5b                   	pop    %ebx
  801fc7:	5e                   	pop    %esi
  801fc8:	5d                   	pop    %ebp
  801fc9:	c3                   	ret    

00801fca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	e8 51 ff ff ff       	call   801f29 <fd2sockid>
		return r;
  801fd8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	78 23                	js     802001 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fde:	8b 55 10             	mov    0x10(%ebp),%edx
  801fe1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fe5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fec:	89 04 24             	mov    %eax,(%esp)
  801fef:	e8 45 01 00 00       	call   802139 <nsipc_accept>
		return r;
  801ff4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	78 07                	js     802001 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801ffa:	e8 5c ff ff ff       	call   801f5b <alloc_sockfd>
  801fff:	89 c1                	mov    %eax,%ecx
}
  802001:	89 c8                	mov    %ecx,%eax
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	e8 16 ff ff ff       	call   801f29 <fd2sockid>
  802013:	89 c2                	mov    %eax,%edx
  802015:	85 d2                	test   %edx,%edx
  802017:	78 16                	js     80202f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802019:	8b 45 10             	mov    0x10(%ebp),%eax
  80201c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802020:	8b 45 0c             	mov    0xc(%ebp),%eax
  802023:	89 44 24 04          	mov    %eax,0x4(%esp)
  802027:	89 14 24             	mov    %edx,(%esp)
  80202a:	e8 60 01 00 00       	call   80218f <nsipc_bind>
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <shutdown>:

int
shutdown(int s, int how)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	e8 ea fe ff ff       	call   801f29 <fd2sockid>
  80203f:	89 c2                	mov    %eax,%edx
  802041:	85 d2                	test   %edx,%edx
  802043:	78 0f                	js     802054 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802045:	8b 45 0c             	mov    0xc(%ebp),%eax
  802048:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204c:	89 14 24             	mov    %edx,(%esp)
  80204f:	e8 7a 01 00 00       	call   8021ce <nsipc_shutdown>
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	e8 c5 fe ff ff       	call   801f29 <fd2sockid>
  802064:	89 c2                	mov    %eax,%edx
  802066:	85 d2                	test   %edx,%edx
  802068:	78 16                	js     802080 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80206a:	8b 45 10             	mov    0x10(%ebp),%eax
  80206d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802071:	8b 45 0c             	mov    0xc(%ebp),%eax
  802074:	89 44 24 04          	mov    %eax,0x4(%esp)
  802078:	89 14 24             	mov    %edx,(%esp)
  80207b:	e8 8a 01 00 00       	call   80220a <nsipc_connect>
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <listen>:

int
listen(int s, int backlog)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	e8 99 fe ff ff       	call   801f29 <fd2sockid>
  802090:	89 c2                	mov    %eax,%edx
  802092:	85 d2                	test   %edx,%edx
  802094:	78 0f                	js     8020a5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802096:	8b 45 0c             	mov    0xc(%ebp),%eax
  802099:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209d:	89 14 24             	mov    %edx,(%esp)
  8020a0:	e8 a4 01 00 00       	call   802249 <nsipc_listen>
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	89 04 24             	mov    %eax,(%esp)
  8020c1:	e8 98 02 00 00       	call   80235e <nsipc_socket>
  8020c6:	89 c2                	mov    %eax,%edx
  8020c8:	85 d2                	test   %edx,%edx
  8020ca:	78 05                	js     8020d1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8020cc:	e8 8a fe ff ff       	call   801f5b <alloc_sockfd>
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	53                   	push   %ebx
  8020d7:	83 ec 14             	sub    $0x14,%esp
  8020da:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020dc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020e3:	75 11                	jne    8020f6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8020ec:	e8 ae 09 00 00       	call   802a9f <ipc_find_env>
  8020f1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020f6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8020fd:	00 
  8020fe:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802105:	00 
  802106:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80210a:	a1 04 50 80 00       	mov    0x805004,%eax
  80210f:	89 04 24             	mov    %eax,(%esp)
  802112:	e8 21 09 00 00       	call   802a38 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802117:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80211e:	00 
  80211f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802126:	00 
  802127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80212e:	e8 9d 08 00 00       	call   8029d0 <ipc_recv>
}
  802133:	83 c4 14             	add    $0x14,%esp
  802136:	5b                   	pop    %ebx
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    

00802139 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	56                   	push   %esi
  80213d:	53                   	push   %ebx
  80213e:	83 ec 10             	sub    $0x10,%esp
  802141:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80214c:	8b 06                	mov    (%esi),%eax
  80214e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802153:	b8 01 00 00 00       	mov    $0x1,%eax
  802158:	e8 76 ff ff ff       	call   8020d3 <nsipc>
  80215d:	89 c3                	mov    %eax,%ebx
  80215f:	85 c0                	test   %eax,%eax
  802161:	78 23                	js     802186 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802163:	a1 10 70 80 00       	mov    0x807010,%eax
  802168:	89 44 24 08          	mov    %eax,0x8(%esp)
  80216c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802173:	00 
  802174:	8b 45 0c             	mov    0xc(%ebp),%eax
  802177:	89 04 24             	mov    %eax,(%esp)
  80217a:	e8 55 e8 ff ff       	call   8009d4 <memmove>
		*addrlen = ret->ret_addrlen;
  80217f:	a1 10 70 80 00       	mov    0x807010,%eax
  802184:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802186:	89 d8                	mov    %ebx,%eax
  802188:	83 c4 10             	add    $0x10,%esp
  80218b:	5b                   	pop    %ebx
  80218c:	5e                   	pop    %esi
  80218d:	5d                   	pop    %ebp
  80218e:	c3                   	ret    

0080218f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	53                   	push   %ebx
  802193:	83 ec 14             	sub    $0x14,%esp
  802196:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021a1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ac:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021b3:	e8 1c e8 ff ff       	call   8009d4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021b8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021be:	b8 02 00 00 00       	mov    $0x2,%eax
  8021c3:	e8 0b ff ff ff       	call   8020d3 <nsipc>
}
  8021c8:	83 c4 14             	add    $0x14,%esp
  8021cb:	5b                   	pop    %ebx
  8021cc:	5d                   	pop    %ebp
  8021cd:	c3                   	ret    

008021ce <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021df:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8021e9:	e8 e5 fe ff ff       	call   8020d3 <nsipc>
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <nsipc_close>:

int
nsipc_close(int s)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021fe:	b8 04 00 00 00       	mov    $0x4,%eax
  802203:	e8 cb fe ff ff       	call   8020d3 <nsipc>
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	53                   	push   %ebx
  80220e:	83 ec 14             	sub    $0x14,%esp
  802211:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80221c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802220:	8b 45 0c             	mov    0xc(%ebp),%eax
  802223:	89 44 24 04          	mov    %eax,0x4(%esp)
  802227:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80222e:	e8 a1 e7 ff ff       	call   8009d4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802233:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802239:	b8 05 00 00 00       	mov    $0x5,%eax
  80223e:	e8 90 fe ff ff       	call   8020d3 <nsipc>
}
  802243:	83 c4 14             	add    $0x14,%esp
  802246:	5b                   	pop    %ebx
  802247:	5d                   	pop    %ebp
  802248:	c3                   	ret    

00802249 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80225f:	b8 06 00 00 00       	mov    $0x6,%eax
  802264:	e8 6a fe ff ff       	call   8020d3 <nsipc>
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	56                   	push   %esi
  80226f:	53                   	push   %ebx
  802270:	83 ec 10             	sub    $0x10,%esp
  802273:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80227e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802284:	8b 45 14             	mov    0x14(%ebp),%eax
  802287:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80228c:	b8 07 00 00 00       	mov    $0x7,%eax
  802291:	e8 3d fe ff ff       	call   8020d3 <nsipc>
  802296:	89 c3                	mov    %eax,%ebx
  802298:	85 c0                	test   %eax,%eax
  80229a:	78 46                	js     8022e2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80229c:	39 f0                	cmp    %esi,%eax
  80229e:	7f 07                	jg     8022a7 <nsipc_recv+0x3c>
  8022a0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022a5:	7e 24                	jle    8022cb <nsipc_recv+0x60>
  8022a7:	c7 44 24 0c 59 33 80 	movl   $0x803359,0xc(%esp)
  8022ae:	00 
  8022af:	c7 44 24 08 08 33 80 	movl   $0x803308,0x8(%esp)
  8022b6:	00 
  8022b7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8022be:	00 
  8022bf:	c7 04 24 6e 33 80 00 	movl   $0x80336e,(%esp)
  8022c6:	e8 eb 05 00 00       	call   8028b6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022cf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022d6:	00 
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	89 04 24             	mov    %eax,(%esp)
  8022dd:	e8 f2 e6 ff ff       	call   8009d4 <memmove>
	}

	return r;
}
  8022e2:	89 d8                	mov    %ebx,%eax
  8022e4:	83 c4 10             	add    $0x10,%esp
  8022e7:	5b                   	pop    %ebx
  8022e8:	5e                   	pop    %esi
  8022e9:	5d                   	pop    %ebp
  8022ea:	c3                   	ret    

008022eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	53                   	push   %ebx
  8022ef:	83 ec 14             	sub    $0x14,%esp
  8022f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802303:	7e 24                	jle    802329 <nsipc_send+0x3e>
  802305:	c7 44 24 0c 7a 33 80 	movl   $0x80337a,0xc(%esp)
  80230c:	00 
  80230d:	c7 44 24 08 08 33 80 	movl   $0x803308,0x8(%esp)
  802314:	00 
  802315:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80231c:	00 
  80231d:	c7 04 24 6e 33 80 00 	movl   $0x80336e,(%esp)
  802324:	e8 8d 05 00 00       	call   8028b6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802329:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80232d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802330:	89 44 24 04          	mov    %eax,0x4(%esp)
  802334:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80233b:	e8 94 e6 ff ff       	call   8009d4 <memmove>
	nsipcbuf.send.req_size = size;
  802340:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802346:	8b 45 14             	mov    0x14(%ebp),%eax
  802349:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80234e:	b8 08 00 00 00       	mov    $0x8,%eax
  802353:	e8 7b fd ff ff       	call   8020d3 <nsipc>
}
  802358:	83 c4 14             	add    $0x14,%esp
  80235b:	5b                   	pop    %ebx
  80235c:	5d                   	pop    %ebp
  80235d:	c3                   	ret    

0080235e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80236c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802374:	8b 45 10             	mov    0x10(%ebp),%eax
  802377:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80237c:	b8 09 00 00 00       	mov    $0x9,%eax
  802381:	e8 4d fd ff ff       	call   8020d3 <nsipc>
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	56                   	push   %esi
  80238c:	53                   	push   %ebx
  80238d:	83 ec 10             	sub    $0x10,%esp
  802390:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	89 04 24             	mov    %eax,(%esp)
  802399:	e8 d2 f1 ff ff       	call   801570 <fd2data>
  80239e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023a0:	c7 44 24 04 86 33 80 	movl   $0x803386,0x4(%esp)
  8023a7:	00 
  8023a8:	89 1c 24             	mov    %ebx,(%esp)
  8023ab:	e8 87 e4 ff ff       	call   800837 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023b0:	8b 46 04             	mov    0x4(%esi),%eax
  8023b3:	2b 06                	sub    (%esi),%eax
  8023b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023c2:	00 00 00 
	stat->st_dev = &devpipe;
  8023c5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023cc:	40 80 00 
	return 0;
}
  8023cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d4:	83 c4 10             	add    $0x10,%esp
  8023d7:	5b                   	pop    %ebx
  8023d8:	5e                   	pop    %esi
  8023d9:	5d                   	pop    %ebp
  8023da:	c3                   	ret    

008023db <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	53                   	push   %ebx
  8023df:	83 ec 14             	sub    $0x14,%esp
  8023e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f0:	e8 57 e9 ff ff       	call   800d4c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023f5:	89 1c 24             	mov    %ebx,(%esp)
  8023f8:	e8 73 f1 ff ff       	call   801570 <fd2data>
  8023fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802401:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802408:	e8 3f e9 ff ff       	call   800d4c <sys_page_unmap>
}
  80240d:	83 c4 14             	add    $0x14,%esp
  802410:	5b                   	pop    %ebx
  802411:	5d                   	pop    %ebp
  802412:	c3                   	ret    

00802413 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	57                   	push   %edi
  802417:	56                   	push   %esi
  802418:	53                   	push   %ebx
  802419:	83 ec 2c             	sub    $0x2c,%esp
  80241c:	89 c6                	mov    %eax,%esi
  80241e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802421:	a1 08 50 80 00       	mov    0x805008,%eax
  802426:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802429:	89 34 24             	mov    %esi,(%esp)
  80242c:	e8 a6 06 00 00       	call   802ad7 <pageref>
  802431:	89 c7                	mov    %eax,%edi
  802433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802436:	89 04 24             	mov    %eax,(%esp)
  802439:	e8 99 06 00 00       	call   802ad7 <pageref>
  80243e:	39 c7                	cmp    %eax,%edi
  802440:	0f 94 c2             	sete   %dl
  802443:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802446:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80244c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80244f:	39 fb                	cmp    %edi,%ebx
  802451:	74 21                	je     802474 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802453:	84 d2                	test   %dl,%dl
  802455:	74 ca                	je     802421 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802457:	8b 51 58             	mov    0x58(%ecx),%edx
  80245a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80245e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802462:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802466:	c7 04 24 8d 33 80 00 	movl   $0x80338d,(%esp)
  80246d:	e8 51 dd ff ff       	call   8001c3 <cprintf>
  802472:	eb ad                	jmp    802421 <_pipeisclosed+0xe>
	}
}
  802474:	83 c4 2c             	add    $0x2c,%esp
  802477:	5b                   	pop    %ebx
  802478:	5e                   	pop    %esi
  802479:	5f                   	pop    %edi
  80247a:	5d                   	pop    %ebp
  80247b:	c3                   	ret    

0080247c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	57                   	push   %edi
  802480:	56                   	push   %esi
  802481:	53                   	push   %ebx
  802482:	83 ec 1c             	sub    $0x1c,%esp
  802485:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802488:	89 34 24             	mov    %esi,(%esp)
  80248b:	e8 e0 f0 ff ff       	call   801570 <fd2data>
  802490:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802492:	bf 00 00 00 00       	mov    $0x0,%edi
  802497:	eb 45                	jmp    8024de <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802499:	89 da                	mov    %ebx,%edx
  80249b:	89 f0                	mov    %esi,%eax
  80249d:	e8 71 ff ff ff       	call   802413 <_pipeisclosed>
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	75 41                	jne    8024e7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024a6:	e8 db e7 ff ff       	call   800c86 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024ab:	8b 43 04             	mov    0x4(%ebx),%eax
  8024ae:	8b 0b                	mov    (%ebx),%ecx
  8024b0:	8d 51 20             	lea    0x20(%ecx),%edx
  8024b3:	39 d0                	cmp    %edx,%eax
  8024b5:	73 e2                	jae    802499 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024ba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024be:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024c1:	99                   	cltd   
  8024c2:	c1 ea 1b             	shr    $0x1b,%edx
  8024c5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8024c8:	83 e1 1f             	and    $0x1f,%ecx
  8024cb:	29 d1                	sub    %edx,%ecx
  8024cd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8024d1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8024d5:	83 c0 01             	add    $0x1,%eax
  8024d8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024db:	83 c7 01             	add    $0x1,%edi
  8024de:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024e1:	75 c8                	jne    8024ab <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8024e3:	89 f8                	mov    %edi,%eax
  8024e5:	eb 05                	jmp    8024ec <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8024ec:	83 c4 1c             	add    $0x1c,%esp
  8024ef:	5b                   	pop    %ebx
  8024f0:	5e                   	pop    %esi
  8024f1:	5f                   	pop    %edi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    

008024f4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	57                   	push   %edi
  8024f8:	56                   	push   %esi
  8024f9:	53                   	push   %ebx
  8024fa:	83 ec 1c             	sub    $0x1c,%esp
  8024fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802500:	89 3c 24             	mov    %edi,(%esp)
  802503:	e8 68 f0 ff ff       	call   801570 <fd2data>
  802508:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80250a:	be 00 00 00 00       	mov    $0x0,%esi
  80250f:	eb 3d                	jmp    80254e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802511:	85 f6                	test   %esi,%esi
  802513:	74 04                	je     802519 <devpipe_read+0x25>
				return i;
  802515:	89 f0                	mov    %esi,%eax
  802517:	eb 43                	jmp    80255c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802519:	89 da                	mov    %ebx,%edx
  80251b:	89 f8                	mov    %edi,%eax
  80251d:	e8 f1 fe ff ff       	call   802413 <_pipeisclosed>
  802522:	85 c0                	test   %eax,%eax
  802524:	75 31                	jne    802557 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802526:	e8 5b e7 ff ff       	call   800c86 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80252b:	8b 03                	mov    (%ebx),%eax
  80252d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802530:	74 df                	je     802511 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802532:	99                   	cltd   
  802533:	c1 ea 1b             	shr    $0x1b,%edx
  802536:	01 d0                	add    %edx,%eax
  802538:	83 e0 1f             	and    $0x1f,%eax
  80253b:	29 d0                	sub    %edx,%eax
  80253d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802542:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802545:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802548:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80254b:	83 c6 01             	add    $0x1,%esi
  80254e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802551:	75 d8                	jne    80252b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802553:	89 f0                	mov    %esi,%eax
  802555:	eb 05                	jmp    80255c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802557:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80255c:	83 c4 1c             	add    $0x1c,%esp
  80255f:	5b                   	pop    %ebx
  802560:	5e                   	pop    %esi
  802561:	5f                   	pop    %edi
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    

00802564 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	56                   	push   %esi
  802568:	53                   	push   %ebx
  802569:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80256c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80256f:	89 04 24             	mov    %eax,(%esp)
  802572:	e8 10 f0 ff ff       	call   801587 <fd_alloc>
  802577:	89 c2                	mov    %eax,%edx
  802579:	85 d2                	test   %edx,%edx
  80257b:	0f 88 4d 01 00 00    	js     8026ce <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802581:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802588:	00 
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802590:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802597:	e8 09 e7 ff ff       	call   800ca5 <sys_page_alloc>
  80259c:	89 c2                	mov    %eax,%edx
  80259e:	85 d2                	test   %edx,%edx
  8025a0:	0f 88 28 01 00 00    	js     8026ce <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025a9:	89 04 24             	mov    %eax,(%esp)
  8025ac:	e8 d6 ef ff ff       	call   801587 <fd_alloc>
  8025b1:	89 c3                	mov    %eax,%ebx
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	0f 88 fe 00 00 00    	js     8026b9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025bb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025c2:	00 
  8025c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d1:	e8 cf e6 ff ff       	call   800ca5 <sys_page_alloc>
  8025d6:	89 c3                	mov    %eax,%ebx
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	0f 88 d9 00 00 00    	js     8026b9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	89 04 24             	mov    %eax,(%esp)
  8025e6:	e8 85 ef ff ff       	call   801570 <fd2data>
  8025eb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ed:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025f4:	00 
  8025f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802600:	e8 a0 e6 ff ff       	call   800ca5 <sys_page_alloc>
  802605:	89 c3                	mov    %eax,%ebx
  802607:	85 c0                	test   %eax,%eax
  802609:	0f 88 97 00 00 00    	js     8026a6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80260f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802612:	89 04 24             	mov    %eax,(%esp)
  802615:	e8 56 ef ff ff       	call   801570 <fd2data>
  80261a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802621:	00 
  802622:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802626:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80262d:	00 
  80262e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802632:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802639:	e8 bb e6 ff ff       	call   800cf9 <sys_page_map>
  80263e:	89 c3                	mov    %eax,%ebx
  802640:	85 c0                	test   %eax,%eax
  802642:	78 52                	js     802696 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802644:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802659:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80265f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802662:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	89 04 24             	mov    %eax,(%esp)
  802674:	e8 e7 ee ff ff       	call   801560 <fd2num>
  802679:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80267c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80267e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802681:	89 04 24             	mov    %eax,(%esp)
  802684:	e8 d7 ee ff ff       	call   801560 <fd2num>
  802689:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80268f:	b8 00 00 00 00       	mov    $0x0,%eax
  802694:	eb 38                	jmp    8026ce <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802696:	89 74 24 04          	mov    %esi,0x4(%esp)
  80269a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a1:	e8 a6 e6 ff ff       	call   800d4c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8026a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b4:	e8 93 e6 ff ff       	call   800d4c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c7:	e8 80 e6 ff ff       	call   800d4c <sys_page_unmap>
  8026cc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8026ce:	83 c4 30             	add    $0x30,%esp
  8026d1:	5b                   	pop    %ebx
  8026d2:	5e                   	pop    %esi
  8026d3:	5d                   	pop    %ebp
  8026d4:	c3                   	ret    

008026d5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	89 04 24             	mov    %eax,(%esp)
  8026e8:	e8 e9 ee ff ff       	call   8015d6 <fd_lookup>
  8026ed:	89 c2                	mov    %eax,%edx
  8026ef:	85 d2                	test   %edx,%edx
  8026f1:	78 15                	js     802708 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	89 04 24             	mov    %eax,(%esp)
  8026f9:	e8 72 ee ff ff       	call   801570 <fd2data>
	return _pipeisclosed(fd, p);
  8026fe:	89 c2                	mov    %eax,%edx
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	e8 0b fd ff ff       	call   802413 <_pipeisclosed>
}
  802708:	c9                   	leave  
  802709:	c3                   	ret    
  80270a:	66 90                	xchg   %ax,%ax
  80270c:	66 90                	xchg   %ax,%ax
  80270e:	66 90                	xchg   %ax,%ax

00802710 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802713:	b8 00 00 00 00       	mov    $0x0,%eax
  802718:	5d                   	pop    %ebp
  802719:	c3                   	ret    

0080271a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
  80271d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802720:	c7 44 24 04 a5 33 80 	movl   $0x8033a5,0x4(%esp)
  802727:	00 
  802728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272b:	89 04 24             	mov    %eax,(%esp)
  80272e:	e8 04 e1 ff ff       	call   800837 <strcpy>
	return 0;
}
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
  802738:	c9                   	leave  
  802739:	c3                   	ret    

0080273a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80273a:	55                   	push   %ebp
  80273b:	89 e5                	mov    %esp,%ebp
  80273d:	57                   	push   %edi
  80273e:	56                   	push   %esi
  80273f:	53                   	push   %ebx
  802740:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802746:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80274b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802751:	eb 31                	jmp    802784 <devcons_write+0x4a>
		m = n - tot;
  802753:	8b 75 10             	mov    0x10(%ebp),%esi
  802756:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802758:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80275b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802760:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802763:	89 74 24 08          	mov    %esi,0x8(%esp)
  802767:	03 45 0c             	add    0xc(%ebp),%eax
  80276a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80276e:	89 3c 24             	mov    %edi,(%esp)
  802771:	e8 5e e2 ff ff       	call   8009d4 <memmove>
		sys_cputs(buf, m);
  802776:	89 74 24 04          	mov    %esi,0x4(%esp)
  80277a:	89 3c 24             	mov    %edi,(%esp)
  80277d:	e8 04 e4 ff ff       	call   800b86 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802782:	01 f3                	add    %esi,%ebx
  802784:	89 d8                	mov    %ebx,%eax
  802786:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802789:	72 c8                	jb     802753 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80278b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802791:	5b                   	pop    %ebx
  802792:	5e                   	pop    %esi
  802793:	5f                   	pop    %edi
  802794:	5d                   	pop    %ebp
  802795:	c3                   	ret    

00802796 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
  802799:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8027a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027a5:	75 07                	jne    8027ae <devcons_read+0x18>
  8027a7:	eb 2a                	jmp    8027d3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8027a9:	e8 d8 e4 ff ff       	call   800c86 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8027ae:	66 90                	xchg   %ax,%ax
  8027b0:	e8 ef e3 ff ff       	call   800ba4 <sys_cgetc>
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	74 f0                	je     8027a9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8027b9:	85 c0                	test   %eax,%eax
  8027bb:	78 16                	js     8027d3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8027bd:	83 f8 04             	cmp    $0x4,%eax
  8027c0:	74 0c                	je     8027ce <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8027c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c5:	88 02                	mov    %al,(%edx)
	return 1;
  8027c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8027cc:	eb 05                	jmp    8027d3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
  8027d8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8027db:	8b 45 08             	mov    0x8(%ebp),%eax
  8027de:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8027e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8027e8:	00 
  8027e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027ec:	89 04 24             	mov    %eax,(%esp)
  8027ef:	e8 92 e3 ff ff       	call   800b86 <sys_cputs>
}
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    

008027f6 <getchar>:

int
getchar(void)
{
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
  8027f9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8027fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802803:	00 
  802804:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80280b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802812:	e8 53 f0 ff ff       	call   80186a <read>
	if (r < 0)
  802817:	85 c0                	test   %eax,%eax
  802819:	78 0f                	js     80282a <getchar+0x34>
		return r;
	if (r < 1)
  80281b:	85 c0                	test   %eax,%eax
  80281d:	7e 06                	jle    802825 <getchar+0x2f>
		return -E_EOF;
	return c;
  80281f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802823:	eb 05                	jmp    80282a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802825:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80282a:	c9                   	leave  
  80282b:	c3                   	ret    

0080282c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
  80282f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802832:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802835:	89 44 24 04          	mov    %eax,0x4(%esp)
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	89 04 24             	mov    %eax,(%esp)
  80283f:	e8 92 ed ff ff       	call   8015d6 <fd_lookup>
  802844:	85 c0                	test   %eax,%eax
  802846:	78 11                	js     802859 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802851:	39 10                	cmp    %edx,(%eax)
  802853:	0f 94 c0             	sete   %al
  802856:	0f b6 c0             	movzbl %al,%eax
}
  802859:	c9                   	leave  
  80285a:	c3                   	ret    

0080285b <opencons>:

int
opencons(void)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
  80285e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802861:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802864:	89 04 24             	mov    %eax,(%esp)
  802867:	e8 1b ed ff ff       	call   801587 <fd_alloc>
		return r;
  80286c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80286e:	85 c0                	test   %eax,%eax
  802870:	78 40                	js     8028b2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802872:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802879:	00 
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802881:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802888:	e8 18 e4 ff ff       	call   800ca5 <sys_page_alloc>
		return r;
  80288d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80288f:	85 c0                	test   %eax,%eax
  802891:	78 1f                	js     8028b2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802893:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028a8:	89 04 24             	mov    %eax,(%esp)
  8028ab:	e8 b0 ec ff ff       	call   801560 <fd2num>
  8028b0:	89 c2                	mov    %eax,%edx
}
  8028b2:	89 d0                	mov    %edx,%eax
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    

008028b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8028b6:	55                   	push   %ebp
  8028b7:	89 e5                	mov    %esp,%ebp
  8028b9:	56                   	push   %esi
  8028ba:	53                   	push   %ebx
  8028bb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8028be:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8028c1:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8028c7:	e8 9b e3 ff ff       	call   800c67 <sys_getenvid>
  8028cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028cf:	89 54 24 10          	mov    %edx,0x10(%esp)
  8028d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8028da:	89 74 24 08          	mov    %esi,0x8(%esp)
  8028de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e2:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  8028e9:	e8 d5 d8 ff ff       	call   8001c3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8028ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028f5:	89 04 24             	mov    %eax,(%esp)
  8028f8:	e8 65 d8 ff ff       	call   800162 <vcprintf>
	cprintf("\n");
  8028fd:	c7 04 24 54 2e 80 00 	movl   $0x802e54,(%esp)
  802904:	e8 ba d8 ff ff       	call   8001c3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802909:	cc                   	int3   
  80290a:	eb fd                	jmp    802909 <_panic+0x53>

0080290c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80290c:	55                   	push   %ebp
  80290d:	89 e5                	mov    %esp,%ebp
  80290f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802912:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802919:	75 7a                	jne    802995 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80291b:	e8 47 e3 ff ff       	call   800c67 <sys_getenvid>
  802920:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802927:	00 
  802928:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80292f:	ee 
  802930:	89 04 24             	mov    %eax,(%esp)
  802933:	e8 6d e3 ff ff       	call   800ca5 <sys_page_alloc>
  802938:	85 c0                	test   %eax,%eax
  80293a:	79 20                	jns    80295c <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  80293c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802940:	c7 44 24 08 c9 31 80 	movl   $0x8031c9,0x8(%esp)
  802947:	00 
  802948:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  80294f:	00 
  802950:	c7 04 24 d7 33 80 00 	movl   $0x8033d7,(%esp)
  802957:	e8 5a ff ff ff       	call   8028b6 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  80295c:	e8 06 e3 ff ff       	call   800c67 <sys_getenvid>
  802961:	c7 44 24 04 9f 29 80 	movl   $0x80299f,0x4(%esp)
  802968:	00 
  802969:	89 04 24             	mov    %eax,(%esp)
  80296c:	e8 f4 e4 ff ff       	call   800e65 <sys_env_set_pgfault_upcall>
  802971:	85 c0                	test   %eax,%eax
  802973:	79 20                	jns    802995 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802975:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802979:	c7 44 24 08 48 32 80 	movl   $0x803248,0x8(%esp)
  802980:	00 
  802981:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802988:	00 
  802989:	c7 04 24 d7 33 80 00 	movl   $0x8033d7,(%esp)
  802990:	e8 21 ff ff ff       	call   8028b6 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80299d:	c9                   	leave  
  80299e:	c3                   	ret    

0080299f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80299f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029a0:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029a5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029a7:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  8029aa:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  8029ae:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8029b2:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  8029b5:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  8029b9:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  8029bb:	83 c4 08             	add    $0x8,%esp
	popal
  8029be:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  8029bf:	83 c4 04             	add    $0x4,%esp
	popfl
  8029c2:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029c3:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8029c4:	c3                   	ret    
  8029c5:	66 90                	xchg   %ax,%ax
  8029c7:	66 90                	xchg   %ax,%ax
  8029c9:	66 90                	xchg   %ax,%ax
  8029cb:	66 90                	xchg   %ax,%ax
  8029cd:	66 90                	xchg   %ax,%ax
  8029cf:	90                   	nop

008029d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029d0:	55                   	push   %ebp
  8029d1:	89 e5                	mov    %esp,%ebp
  8029d3:	56                   	push   %esi
  8029d4:	53                   	push   %ebx
  8029d5:	83 ec 10             	sub    $0x10,%esp
  8029d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8029db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8029e1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8029e3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8029e8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8029eb:	89 04 24             	mov    %eax,(%esp)
  8029ee:	e8 e8 e4 ff ff       	call   800edb <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8029f3:	85 c0                	test   %eax,%eax
  8029f5:	75 26                	jne    802a1d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8029f7:	85 f6                	test   %esi,%esi
  8029f9:	74 0a                	je     802a05 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8029fb:	a1 08 50 80 00       	mov    0x805008,%eax
  802a00:	8b 40 74             	mov    0x74(%eax),%eax
  802a03:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802a05:	85 db                	test   %ebx,%ebx
  802a07:	74 0a                	je     802a13 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802a09:	a1 08 50 80 00       	mov    0x805008,%eax
  802a0e:	8b 40 78             	mov    0x78(%eax),%eax
  802a11:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802a13:	a1 08 50 80 00       	mov    0x805008,%eax
  802a18:	8b 40 70             	mov    0x70(%eax),%eax
  802a1b:	eb 14                	jmp    802a31 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  802a1d:	85 f6                	test   %esi,%esi
  802a1f:	74 06                	je     802a27 <ipc_recv+0x57>
			*from_env_store = 0;
  802a21:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a27:	85 db                	test   %ebx,%ebx
  802a29:	74 06                	je     802a31 <ipc_recv+0x61>
			*perm_store = 0;
  802a2b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802a31:	83 c4 10             	add    $0x10,%esp
  802a34:	5b                   	pop    %ebx
  802a35:	5e                   	pop    %esi
  802a36:	5d                   	pop    %ebp
  802a37:	c3                   	ret    

00802a38 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a38:	55                   	push   %ebp
  802a39:	89 e5                	mov    %esp,%ebp
  802a3b:	57                   	push   %edi
  802a3c:	56                   	push   %esi
  802a3d:	53                   	push   %ebx
  802a3e:	83 ec 1c             	sub    $0x1c,%esp
  802a41:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a44:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a47:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  802a4a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  802a4c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802a51:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802a54:	8b 45 14             	mov    0x14(%ebp),%eax
  802a57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a5f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a63:	89 3c 24             	mov    %edi,(%esp)
  802a66:	e8 4d e4 ff ff       	call   800eb8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	74 28                	je     802a97 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802a6f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a72:	74 1c                	je     802a90 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802a74:	c7 44 24 08 e8 33 80 	movl   $0x8033e8,0x8(%esp)
  802a7b:	00 
  802a7c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802a83:	00 
  802a84:	c7 04 24 0c 34 80 00 	movl   $0x80340c,(%esp)
  802a8b:	e8 26 fe ff ff       	call   8028b6 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802a90:	e8 f1 e1 ff ff       	call   800c86 <sys_yield>
	}
  802a95:	eb bd                	jmp    802a54 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802a97:	83 c4 1c             	add    $0x1c,%esp
  802a9a:	5b                   	pop    %ebx
  802a9b:	5e                   	pop    %esi
  802a9c:	5f                   	pop    %edi
  802a9d:	5d                   	pop    %ebp
  802a9e:	c3                   	ret    

00802a9f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a9f:	55                   	push   %ebp
  802aa0:	89 e5                	mov    %esp,%ebp
  802aa2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802aa5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802aaa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802aad:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802ab3:	8b 52 50             	mov    0x50(%edx),%edx
  802ab6:	39 ca                	cmp    %ecx,%edx
  802ab8:	75 0d                	jne    802ac7 <ipc_find_env+0x28>
			return envs[i].env_id;
  802aba:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802abd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802ac2:	8b 40 40             	mov    0x40(%eax),%eax
  802ac5:	eb 0e                	jmp    802ad5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802ac7:	83 c0 01             	add    $0x1,%eax
  802aca:	3d 00 04 00 00       	cmp    $0x400,%eax
  802acf:	75 d9                	jne    802aaa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802ad1:	66 b8 00 00          	mov    $0x0,%ax
}
  802ad5:	5d                   	pop    %ebp
  802ad6:	c3                   	ret    

00802ad7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ad7:	55                   	push   %ebp
  802ad8:	89 e5                	mov    %esp,%ebp
  802ada:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802add:	89 d0                	mov    %edx,%eax
  802adf:	c1 e8 16             	shr    $0x16,%eax
  802ae2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ae9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802aee:	f6 c1 01             	test   $0x1,%cl
  802af1:	74 1d                	je     802b10 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802af3:	c1 ea 0c             	shr    $0xc,%edx
  802af6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802afd:	f6 c2 01             	test   $0x1,%dl
  802b00:	74 0e                	je     802b10 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b02:	c1 ea 0c             	shr    $0xc,%edx
  802b05:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b0c:	ef 
  802b0d:	0f b7 c0             	movzwl %ax,%eax
}
  802b10:	5d                   	pop    %ebp
  802b11:	c3                   	ret    
  802b12:	66 90                	xchg   %ax,%ax
  802b14:	66 90                	xchg   %ax,%ax
  802b16:	66 90                	xchg   %ax,%ax
  802b18:	66 90                	xchg   %ax,%ax
  802b1a:	66 90                	xchg   %ax,%ax
  802b1c:	66 90                	xchg   %ax,%ax
  802b1e:	66 90                	xchg   %ax,%ax

00802b20 <__udivdi3>:
  802b20:	55                   	push   %ebp
  802b21:	57                   	push   %edi
  802b22:	56                   	push   %esi
  802b23:	83 ec 0c             	sub    $0xc,%esp
  802b26:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b2a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b2e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802b32:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b36:	85 c0                	test   %eax,%eax
  802b38:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b3c:	89 ea                	mov    %ebp,%edx
  802b3e:	89 0c 24             	mov    %ecx,(%esp)
  802b41:	75 2d                	jne    802b70 <__udivdi3+0x50>
  802b43:	39 e9                	cmp    %ebp,%ecx
  802b45:	77 61                	ja     802ba8 <__udivdi3+0x88>
  802b47:	85 c9                	test   %ecx,%ecx
  802b49:	89 ce                	mov    %ecx,%esi
  802b4b:	75 0b                	jne    802b58 <__udivdi3+0x38>
  802b4d:	b8 01 00 00 00       	mov    $0x1,%eax
  802b52:	31 d2                	xor    %edx,%edx
  802b54:	f7 f1                	div    %ecx
  802b56:	89 c6                	mov    %eax,%esi
  802b58:	31 d2                	xor    %edx,%edx
  802b5a:	89 e8                	mov    %ebp,%eax
  802b5c:	f7 f6                	div    %esi
  802b5e:	89 c5                	mov    %eax,%ebp
  802b60:	89 f8                	mov    %edi,%eax
  802b62:	f7 f6                	div    %esi
  802b64:	89 ea                	mov    %ebp,%edx
  802b66:	83 c4 0c             	add    $0xc,%esp
  802b69:	5e                   	pop    %esi
  802b6a:	5f                   	pop    %edi
  802b6b:	5d                   	pop    %ebp
  802b6c:	c3                   	ret    
  802b6d:	8d 76 00             	lea    0x0(%esi),%esi
  802b70:	39 e8                	cmp    %ebp,%eax
  802b72:	77 24                	ja     802b98 <__udivdi3+0x78>
  802b74:	0f bd e8             	bsr    %eax,%ebp
  802b77:	83 f5 1f             	xor    $0x1f,%ebp
  802b7a:	75 3c                	jne    802bb8 <__udivdi3+0x98>
  802b7c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802b80:	39 34 24             	cmp    %esi,(%esp)
  802b83:	0f 86 9f 00 00 00    	jbe    802c28 <__udivdi3+0x108>
  802b89:	39 d0                	cmp    %edx,%eax
  802b8b:	0f 82 97 00 00 00    	jb     802c28 <__udivdi3+0x108>
  802b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b98:	31 d2                	xor    %edx,%edx
  802b9a:	31 c0                	xor    %eax,%eax
  802b9c:	83 c4 0c             	add    $0xc,%esp
  802b9f:	5e                   	pop    %esi
  802ba0:	5f                   	pop    %edi
  802ba1:	5d                   	pop    %ebp
  802ba2:	c3                   	ret    
  802ba3:	90                   	nop
  802ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ba8:	89 f8                	mov    %edi,%eax
  802baa:	f7 f1                	div    %ecx
  802bac:	31 d2                	xor    %edx,%edx
  802bae:	83 c4 0c             	add    $0xc,%esp
  802bb1:	5e                   	pop    %esi
  802bb2:	5f                   	pop    %edi
  802bb3:	5d                   	pop    %ebp
  802bb4:	c3                   	ret    
  802bb5:	8d 76 00             	lea    0x0(%esi),%esi
  802bb8:	89 e9                	mov    %ebp,%ecx
  802bba:	8b 3c 24             	mov    (%esp),%edi
  802bbd:	d3 e0                	shl    %cl,%eax
  802bbf:	89 c6                	mov    %eax,%esi
  802bc1:	b8 20 00 00 00       	mov    $0x20,%eax
  802bc6:	29 e8                	sub    %ebp,%eax
  802bc8:	89 c1                	mov    %eax,%ecx
  802bca:	d3 ef                	shr    %cl,%edi
  802bcc:	89 e9                	mov    %ebp,%ecx
  802bce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802bd2:	8b 3c 24             	mov    (%esp),%edi
  802bd5:	09 74 24 08          	or     %esi,0x8(%esp)
  802bd9:	89 d6                	mov    %edx,%esi
  802bdb:	d3 e7                	shl    %cl,%edi
  802bdd:	89 c1                	mov    %eax,%ecx
  802bdf:	89 3c 24             	mov    %edi,(%esp)
  802be2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802be6:	d3 ee                	shr    %cl,%esi
  802be8:	89 e9                	mov    %ebp,%ecx
  802bea:	d3 e2                	shl    %cl,%edx
  802bec:	89 c1                	mov    %eax,%ecx
  802bee:	d3 ef                	shr    %cl,%edi
  802bf0:	09 d7                	or     %edx,%edi
  802bf2:	89 f2                	mov    %esi,%edx
  802bf4:	89 f8                	mov    %edi,%eax
  802bf6:	f7 74 24 08          	divl   0x8(%esp)
  802bfa:	89 d6                	mov    %edx,%esi
  802bfc:	89 c7                	mov    %eax,%edi
  802bfe:	f7 24 24             	mull   (%esp)
  802c01:	39 d6                	cmp    %edx,%esi
  802c03:	89 14 24             	mov    %edx,(%esp)
  802c06:	72 30                	jb     802c38 <__udivdi3+0x118>
  802c08:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c0c:	89 e9                	mov    %ebp,%ecx
  802c0e:	d3 e2                	shl    %cl,%edx
  802c10:	39 c2                	cmp    %eax,%edx
  802c12:	73 05                	jae    802c19 <__udivdi3+0xf9>
  802c14:	3b 34 24             	cmp    (%esp),%esi
  802c17:	74 1f                	je     802c38 <__udivdi3+0x118>
  802c19:	89 f8                	mov    %edi,%eax
  802c1b:	31 d2                	xor    %edx,%edx
  802c1d:	e9 7a ff ff ff       	jmp    802b9c <__udivdi3+0x7c>
  802c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c28:	31 d2                	xor    %edx,%edx
  802c2a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c2f:	e9 68 ff ff ff       	jmp    802b9c <__udivdi3+0x7c>
  802c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c38:	8d 47 ff             	lea    -0x1(%edi),%eax
  802c3b:	31 d2                	xor    %edx,%edx
  802c3d:	83 c4 0c             	add    $0xc,%esp
  802c40:	5e                   	pop    %esi
  802c41:	5f                   	pop    %edi
  802c42:	5d                   	pop    %ebp
  802c43:	c3                   	ret    
  802c44:	66 90                	xchg   %ax,%ax
  802c46:	66 90                	xchg   %ax,%ax
  802c48:	66 90                	xchg   %ax,%ax
  802c4a:	66 90                	xchg   %ax,%ax
  802c4c:	66 90                	xchg   %ax,%ax
  802c4e:	66 90                	xchg   %ax,%ax

00802c50 <__umoddi3>:
  802c50:	55                   	push   %ebp
  802c51:	57                   	push   %edi
  802c52:	56                   	push   %esi
  802c53:	83 ec 14             	sub    $0x14,%esp
  802c56:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c5a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c5e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802c62:	89 c7                	mov    %eax,%edi
  802c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c68:	8b 44 24 30          	mov    0x30(%esp),%eax
  802c6c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802c70:	89 34 24             	mov    %esi,(%esp)
  802c73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c77:	85 c0                	test   %eax,%eax
  802c79:	89 c2                	mov    %eax,%edx
  802c7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c7f:	75 17                	jne    802c98 <__umoddi3+0x48>
  802c81:	39 fe                	cmp    %edi,%esi
  802c83:	76 4b                	jbe    802cd0 <__umoddi3+0x80>
  802c85:	89 c8                	mov    %ecx,%eax
  802c87:	89 fa                	mov    %edi,%edx
  802c89:	f7 f6                	div    %esi
  802c8b:	89 d0                	mov    %edx,%eax
  802c8d:	31 d2                	xor    %edx,%edx
  802c8f:	83 c4 14             	add    $0x14,%esp
  802c92:	5e                   	pop    %esi
  802c93:	5f                   	pop    %edi
  802c94:	5d                   	pop    %ebp
  802c95:	c3                   	ret    
  802c96:	66 90                	xchg   %ax,%ax
  802c98:	39 f8                	cmp    %edi,%eax
  802c9a:	77 54                	ja     802cf0 <__umoddi3+0xa0>
  802c9c:	0f bd e8             	bsr    %eax,%ebp
  802c9f:	83 f5 1f             	xor    $0x1f,%ebp
  802ca2:	75 5c                	jne    802d00 <__umoddi3+0xb0>
  802ca4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802ca8:	39 3c 24             	cmp    %edi,(%esp)
  802cab:	0f 87 e7 00 00 00    	ja     802d98 <__umoddi3+0x148>
  802cb1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802cb5:	29 f1                	sub    %esi,%ecx
  802cb7:	19 c7                	sbb    %eax,%edi
  802cb9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cc1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802cc5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802cc9:	83 c4 14             	add    $0x14,%esp
  802ccc:	5e                   	pop    %esi
  802ccd:	5f                   	pop    %edi
  802cce:	5d                   	pop    %ebp
  802ccf:	c3                   	ret    
  802cd0:	85 f6                	test   %esi,%esi
  802cd2:	89 f5                	mov    %esi,%ebp
  802cd4:	75 0b                	jne    802ce1 <__umoddi3+0x91>
  802cd6:	b8 01 00 00 00       	mov    $0x1,%eax
  802cdb:	31 d2                	xor    %edx,%edx
  802cdd:	f7 f6                	div    %esi
  802cdf:	89 c5                	mov    %eax,%ebp
  802ce1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ce5:	31 d2                	xor    %edx,%edx
  802ce7:	f7 f5                	div    %ebp
  802ce9:	89 c8                	mov    %ecx,%eax
  802ceb:	f7 f5                	div    %ebp
  802ced:	eb 9c                	jmp    802c8b <__umoddi3+0x3b>
  802cef:	90                   	nop
  802cf0:	89 c8                	mov    %ecx,%eax
  802cf2:	89 fa                	mov    %edi,%edx
  802cf4:	83 c4 14             	add    $0x14,%esp
  802cf7:	5e                   	pop    %esi
  802cf8:	5f                   	pop    %edi
  802cf9:	5d                   	pop    %ebp
  802cfa:	c3                   	ret    
  802cfb:	90                   	nop
  802cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d00:	8b 04 24             	mov    (%esp),%eax
  802d03:	be 20 00 00 00       	mov    $0x20,%esi
  802d08:	89 e9                	mov    %ebp,%ecx
  802d0a:	29 ee                	sub    %ebp,%esi
  802d0c:	d3 e2                	shl    %cl,%edx
  802d0e:	89 f1                	mov    %esi,%ecx
  802d10:	d3 e8                	shr    %cl,%eax
  802d12:	89 e9                	mov    %ebp,%ecx
  802d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d18:	8b 04 24             	mov    (%esp),%eax
  802d1b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d1f:	89 fa                	mov    %edi,%edx
  802d21:	d3 e0                	shl    %cl,%eax
  802d23:	89 f1                	mov    %esi,%ecx
  802d25:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d29:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d2d:	d3 ea                	shr    %cl,%edx
  802d2f:	89 e9                	mov    %ebp,%ecx
  802d31:	d3 e7                	shl    %cl,%edi
  802d33:	89 f1                	mov    %esi,%ecx
  802d35:	d3 e8                	shr    %cl,%eax
  802d37:	89 e9                	mov    %ebp,%ecx
  802d39:	09 f8                	or     %edi,%eax
  802d3b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802d3f:	f7 74 24 04          	divl   0x4(%esp)
  802d43:	d3 e7                	shl    %cl,%edi
  802d45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d49:	89 d7                	mov    %edx,%edi
  802d4b:	f7 64 24 08          	mull   0x8(%esp)
  802d4f:	39 d7                	cmp    %edx,%edi
  802d51:	89 c1                	mov    %eax,%ecx
  802d53:	89 14 24             	mov    %edx,(%esp)
  802d56:	72 2c                	jb     802d84 <__umoddi3+0x134>
  802d58:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802d5c:	72 22                	jb     802d80 <__umoddi3+0x130>
  802d5e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802d62:	29 c8                	sub    %ecx,%eax
  802d64:	19 d7                	sbb    %edx,%edi
  802d66:	89 e9                	mov    %ebp,%ecx
  802d68:	89 fa                	mov    %edi,%edx
  802d6a:	d3 e8                	shr    %cl,%eax
  802d6c:	89 f1                	mov    %esi,%ecx
  802d6e:	d3 e2                	shl    %cl,%edx
  802d70:	89 e9                	mov    %ebp,%ecx
  802d72:	d3 ef                	shr    %cl,%edi
  802d74:	09 d0                	or     %edx,%eax
  802d76:	89 fa                	mov    %edi,%edx
  802d78:	83 c4 14             	add    $0x14,%esp
  802d7b:	5e                   	pop    %esi
  802d7c:	5f                   	pop    %edi
  802d7d:	5d                   	pop    %ebp
  802d7e:	c3                   	ret    
  802d7f:	90                   	nop
  802d80:	39 d7                	cmp    %edx,%edi
  802d82:	75 da                	jne    802d5e <__umoddi3+0x10e>
  802d84:	8b 14 24             	mov    (%esp),%edx
  802d87:	89 c1                	mov    %eax,%ecx
  802d89:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802d8d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802d91:	eb cb                	jmp    802d5e <__umoddi3+0x10e>
  802d93:	90                   	nop
  802d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d98:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802d9c:	0f 82 0f ff ff ff    	jb     802cb1 <__umoddi3+0x61>
  802da2:	e9 1a ff ff ff       	jmp    802cc1 <__umoddi3+0x71>
