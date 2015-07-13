
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 31 00 00 00       	call   800062 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	zero = 0;
  800039:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	89 44 24 04          	mov    %eax,0x4(%esp)
  800054:	c7 04 24 e0 26 80 00 	movl   $0x8026e0,(%esp)
  80005b:	e8 06 01 00 00       	call   800166 <cprintf>
}
  800060:	c9                   	leave  
  800061:	c3                   	ret    

00800062 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800062:	55                   	push   %ebp
  800063:	89 e5                	mov    %esp,%ebp
  800065:	56                   	push   %esi
  800066:	53                   	push   %ebx
  800067:	83 ec 10             	sub    $0x10,%esp
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800070:	e8 92 0b 00 00       	call   800c07 <sys_getenvid>
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800082:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800087:	85 db                	test   %ebx,%ebx
  800089:	7e 07                	jle    800092 <libmain+0x30>
		binaryname = argv[0];
  80008b:	8b 06                	mov    (%esi),%eax
  80008d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800092:	89 74 24 04          	mov    %esi,0x4(%esp)
  800096:	89 1c 24             	mov    %ebx,(%esp)
  800099:	e8 95 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009e:	e8 07 00 00 00       	call   8000aa <exit>
}
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	5b                   	pop    %ebx
  8000a7:	5e                   	pop    %esi
  8000a8:	5d                   	pop    %ebp
  8000a9:	c3                   	ret    

008000aa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000b0:	e8 75 10 00 00       	call   80112a <close_all>
	sys_env_destroy(0);
  8000b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000bc:	e8 a2 0a 00 00       	call   800b63 <sys_env_destroy>
}
  8000c1:	c9                   	leave  
  8000c2:	c3                   	ret    

008000c3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	53                   	push   %ebx
  8000c7:	83 ec 14             	sub    $0x14,%esp
  8000ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000cd:	8b 13                	mov    (%ebx),%edx
  8000cf:	8d 42 01             	lea    0x1(%edx),%eax
  8000d2:	89 03                	mov    %eax,(%ebx)
  8000d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000db:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e0:	75 19                	jne    8000fb <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8000e2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8000e9:	00 
  8000ea:	8d 43 08             	lea    0x8(%ebx),%eax
  8000ed:	89 04 24             	mov    %eax,(%esp)
  8000f0:	e8 31 0a 00 00       	call   800b26 <sys_cputs>
		b->idx = 0;
  8000f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8000fb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000ff:	83 c4 14             	add    $0x14,%esp
  800102:	5b                   	pop    %ebx
  800103:	5d                   	pop    %ebp
  800104:	c3                   	ret    

00800105 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800105:	55                   	push   %ebp
  800106:	89 e5                	mov    %esp,%ebp
  800108:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80010e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800115:	00 00 00 
	b.cnt = 0;
  800118:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800122:	8b 45 0c             	mov    0xc(%ebp),%eax
  800125:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800129:	8b 45 08             	mov    0x8(%ebp),%eax
  80012c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800130:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800136:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013a:	c7 04 24 c3 00 80 00 	movl   $0x8000c3,(%esp)
  800141:	e8 6e 01 00 00       	call   8002b4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800146:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800150:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800156:	89 04 24             	mov    %eax,(%esp)
  800159:	e8 c8 09 00 00       	call   800b26 <sys_cputs>

	return b.cnt;
}
  80015e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800164:	c9                   	leave  
  800165:	c3                   	ret    

00800166 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800166:	55                   	push   %ebp
  800167:	89 e5                	mov    %esp,%ebp
  800169:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80016c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80016f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800173:	8b 45 08             	mov    0x8(%ebp),%eax
  800176:	89 04 24             	mov    %eax,(%esp)
  800179:	e8 87 ff ff ff       	call   800105 <vcprintf>
	va_end(ap);

	return cnt;
}
  80017e:	c9                   	leave  
  80017f:	c3                   	ret    

00800180 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	57                   	push   %edi
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	83 ec 3c             	sub    $0x3c,%esp
  800189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80018c:	89 d7                	mov    %edx,%edi
  80018e:	8b 45 08             	mov    0x8(%ebp),%eax
  800191:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800194:	8b 45 0c             	mov    0xc(%ebp),%eax
  800197:	89 c3                	mov    %eax,%ebx
  800199:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ad:	39 d9                	cmp    %ebx,%ecx
  8001af:	72 05                	jb     8001b6 <printnum+0x36>
  8001b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001b4:	77 69                	ja     80021f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001bd:	83 ee 01             	sub    $0x1,%esi
  8001c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8001cc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8001d0:	89 c3                	mov    %eax,%ebx
  8001d2:	89 d6                	mov    %edx,%esi
  8001d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8001da:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8001e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e5:	89 04 24             	mov    %eax,(%esp)
  8001e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ef:	e8 5c 22 00 00       	call   802450 <__udivdi3>
  8001f4:	89 d9                	mov    %ebx,%ecx
  8001f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8001fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001fe:	89 04 24             	mov    %eax,(%esp)
  800201:	89 54 24 04          	mov    %edx,0x4(%esp)
  800205:	89 fa                	mov    %edi,%edx
  800207:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020a:	e8 71 ff ff ff       	call   800180 <printnum>
  80020f:	eb 1b                	jmp    80022c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800211:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800215:	8b 45 18             	mov    0x18(%ebp),%eax
  800218:	89 04 24             	mov    %eax,(%esp)
  80021b:	ff d3                	call   *%ebx
  80021d:	eb 03                	jmp    800222 <printnum+0xa2>
  80021f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800222:	83 ee 01             	sub    $0x1,%esi
  800225:	85 f6                	test   %esi,%esi
  800227:	7f e8                	jg     800211 <printnum+0x91>
  800229:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80022c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800230:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800234:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800237:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80023a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800242:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80024b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024f:	e8 2c 23 00 00       	call   802580 <__umoddi3>
  800254:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800258:	0f be 80 f8 26 80 00 	movsbl 0x8026f8(%eax),%eax
  80025f:	89 04 24             	mov    %eax,(%esp)
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	ff d0                	call   *%eax
}
  800267:	83 c4 3c             	add    $0x3c,%esp
  80026a:	5b                   	pop    %ebx
  80026b:	5e                   	pop    %esi
  80026c:	5f                   	pop    %edi
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800275:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800279:	8b 10                	mov    (%eax),%edx
  80027b:	3b 50 04             	cmp    0x4(%eax),%edx
  80027e:	73 0a                	jae    80028a <sprintputch+0x1b>
		*b->buf++ = ch;
  800280:	8d 4a 01             	lea    0x1(%edx),%ecx
  800283:	89 08                	mov    %ecx,(%eax)
  800285:	8b 45 08             	mov    0x8(%ebp),%eax
  800288:	88 02                	mov    %al,(%edx)
}
  80028a:	5d                   	pop    %ebp
  80028b:	c3                   	ret    

0080028c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800292:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800295:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800299:	8b 45 10             	mov    0x10(%ebp),%eax
  80029c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002aa:	89 04 24             	mov    %eax,(%esp)
  8002ad:	e8 02 00 00 00       	call   8002b4 <vprintfmt>
	va_end(ap);
}
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

008002b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	57                   	push   %edi
  8002b8:	56                   	push   %esi
  8002b9:	53                   	push   %ebx
  8002ba:	83 ec 3c             	sub    $0x3c,%esp
  8002bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002c0:	eb 17                	jmp    8002d9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8002c2:	85 c0                	test   %eax,%eax
  8002c4:	0f 84 4b 04 00 00    	je     800715 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8002ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002d1:	89 04 24             	mov    %eax,(%esp)
  8002d4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8002d7:	89 fb                	mov    %edi,%ebx
  8002d9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8002dc:	0f b6 03             	movzbl (%ebx),%eax
  8002df:	83 f8 25             	cmp    $0x25,%eax
  8002e2:	75 de                	jne    8002c2 <vprintfmt+0xe>
  8002e4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8002e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002ef:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8002f4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8002fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800300:	eb 18                	jmp    80031a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800302:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800304:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800308:	eb 10                	jmp    80031a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80030c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800310:	eb 08                	jmp    80031a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800312:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800315:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80031a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80031d:	0f b6 17             	movzbl (%edi),%edx
  800320:	0f b6 c2             	movzbl %dl,%eax
  800323:	83 ea 23             	sub    $0x23,%edx
  800326:	80 fa 55             	cmp    $0x55,%dl
  800329:	0f 87 c2 03 00 00    	ja     8006f1 <vprintfmt+0x43d>
  80032f:	0f b6 d2             	movzbl %dl,%edx
  800332:	ff 24 95 40 28 80 00 	jmp    *0x802840(,%edx,4)
  800339:	89 df                	mov    %ebx,%edi
  80033b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800340:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800343:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800347:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80034a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80034d:	83 fa 09             	cmp    $0x9,%edx
  800350:	77 33                	ja     800385 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800352:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800355:	eb e9                	jmp    800340 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800357:	8b 45 14             	mov    0x14(%ebp),%eax
  80035a:	8b 30                	mov    (%eax),%esi
  80035c:	8d 40 04             	lea    0x4(%eax),%eax
  80035f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800362:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800364:	eb 1f                	jmp    800385 <vprintfmt+0xd1>
  800366:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800369:	85 ff                	test   %edi,%edi
  80036b:	b8 00 00 00 00       	mov    $0x0,%eax
  800370:	0f 49 c7             	cmovns %edi,%eax
  800373:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800376:	89 df                	mov    %ebx,%edi
  800378:	eb a0                	jmp    80031a <vprintfmt+0x66>
  80037a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80037c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800383:	eb 95                	jmp    80031a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800385:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800389:	79 8f                	jns    80031a <vprintfmt+0x66>
  80038b:	eb 85                	jmp    800312 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80038d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800390:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800392:	eb 86                	jmp    80031a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800394:	8b 45 14             	mov    0x14(%ebp),%eax
  800397:	8d 70 04             	lea    0x4(%eax),%esi
  80039a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	89 04 24             	mov    %eax,(%esp)
  8003a9:	ff 55 08             	call   *0x8(%ebp)
  8003ac:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8003af:	e9 25 ff ff ff       	jmp    8002d9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b7:	8d 70 04             	lea    0x4(%eax),%esi
  8003ba:	8b 00                	mov    (%eax),%eax
  8003bc:	99                   	cltd   
  8003bd:	31 d0                	xor    %edx,%eax
  8003bf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c1:	83 f8 15             	cmp    $0x15,%eax
  8003c4:	7f 0b                	jg     8003d1 <vprintfmt+0x11d>
  8003c6:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  8003cd:	85 d2                	test   %edx,%edx
  8003cf:	75 26                	jne    8003f7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8003d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003d5:	c7 44 24 08 10 27 80 	movl   $0x802710,0x8(%esp)
  8003dc:	00 
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	89 04 24             	mov    %eax,(%esp)
  8003ea:	e8 9d fe ff ff       	call   80028c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003ef:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8003f2:	e9 e2 fe ff ff       	jmp    8002d9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8003f7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003fb:	c7 44 24 08 f2 2a 80 	movl   $0x802af2,0x8(%esp)
  800402:	00 
  800403:	8b 45 0c             	mov    0xc(%ebp),%eax
  800406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	89 04 24             	mov    %eax,(%esp)
  800410:	e8 77 fe ff ff       	call   80028c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800415:	89 75 14             	mov    %esi,0x14(%ebp)
  800418:	e9 bc fe ff ff       	jmp    8002d9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041d:	8b 45 14             	mov    0x14(%ebp),%eax
  800420:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800423:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800426:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80042a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80042c:	85 ff                	test   %edi,%edi
  80042e:	b8 09 27 80 00       	mov    $0x802709,%eax
  800433:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800436:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80043a:	0f 84 94 00 00 00    	je     8004d4 <vprintfmt+0x220>
  800440:	85 c9                	test   %ecx,%ecx
  800442:	0f 8e 94 00 00 00    	jle    8004dc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800448:	89 74 24 04          	mov    %esi,0x4(%esp)
  80044c:	89 3c 24             	mov    %edi,(%esp)
  80044f:	e8 64 03 00 00       	call   8007b8 <strnlen>
  800454:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800457:	29 c1                	sub    %eax,%ecx
  800459:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80045c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800460:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800463:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800466:	8b 75 08             	mov    0x8(%ebp),%esi
  800469:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80046c:	89 cb                	mov    %ecx,%ebx
  80046e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800470:	eb 0f                	jmp    800481 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800472:	8b 45 0c             	mov    0xc(%ebp),%eax
  800475:	89 44 24 04          	mov    %eax,0x4(%esp)
  800479:	89 3c 24             	mov    %edi,(%esp)
  80047c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80047e:	83 eb 01             	sub    $0x1,%ebx
  800481:	85 db                	test   %ebx,%ebx
  800483:	7f ed                	jg     800472 <vprintfmt+0x1be>
  800485:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800488:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80048b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048e:	85 c9                	test   %ecx,%ecx
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
  800495:	0f 49 c1             	cmovns %ecx,%eax
  800498:	29 c1                	sub    %eax,%ecx
  80049a:	89 cb                	mov    %ecx,%ebx
  80049c:	eb 44                	jmp    8004e2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80049e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004a2:	74 1e                	je     8004c2 <vprintfmt+0x20e>
  8004a4:	0f be d2             	movsbl %dl,%edx
  8004a7:	83 ea 20             	sub    $0x20,%edx
  8004aa:	83 fa 5e             	cmp    $0x5e,%edx
  8004ad:	76 13                	jbe    8004c2 <vprintfmt+0x20e>
					putch('?', putdat);
  8004af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8004bd:	ff 55 08             	call   *0x8(%ebp)
  8004c0:	eb 0d                	jmp    8004cf <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8004c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004c9:	89 04 24             	mov    %eax,(%esp)
  8004cc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004cf:	83 eb 01             	sub    $0x1,%ebx
  8004d2:	eb 0e                	jmp    8004e2 <vprintfmt+0x22e>
  8004d4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004d7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004da:	eb 06                	jmp    8004e2 <vprintfmt+0x22e>
  8004dc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004df:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e2:	83 c7 01             	add    $0x1,%edi
  8004e5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004e9:	0f be c2             	movsbl %dl,%eax
  8004ec:	85 c0                	test   %eax,%eax
  8004ee:	74 27                	je     800517 <vprintfmt+0x263>
  8004f0:	85 f6                	test   %esi,%esi
  8004f2:	78 aa                	js     80049e <vprintfmt+0x1ea>
  8004f4:	83 ee 01             	sub    $0x1,%esi
  8004f7:	79 a5                	jns    80049e <vprintfmt+0x1ea>
  8004f9:	89 d8                	mov    %ebx,%eax
  8004fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800501:	89 c3                	mov    %eax,%ebx
  800503:	eb 18                	jmp    80051d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800505:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800509:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800510:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800512:	83 eb 01             	sub    $0x1,%ebx
  800515:	eb 06                	jmp    80051d <vprintfmt+0x269>
  800517:	8b 75 08             	mov    0x8(%ebp),%esi
  80051a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80051d:	85 db                	test   %ebx,%ebx
  80051f:	7f e4                	jg     800505 <vprintfmt+0x251>
  800521:	89 75 08             	mov    %esi,0x8(%ebp)
  800524:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800527:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80052a:	e9 aa fd ff ff       	jmp    8002d9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80052f:	83 f9 01             	cmp    $0x1,%ecx
  800532:	7e 10                	jle    800544 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8b 30                	mov    (%eax),%esi
  800539:	8b 78 04             	mov    0x4(%eax),%edi
  80053c:	8d 40 08             	lea    0x8(%eax),%eax
  80053f:	89 45 14             	mov    %eax,0x14(%ebp)
  800542:	eb 26                	jmp    80056a <vprintfmt+0x2b6>
	else if (lflag)
  800544:	85 c9                	test   %ecx,%ecx
  800546:	74 12                	je     80055a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	8b 30                	mov    (%eax),%esi
  80054d:	89 f7                	mov    %esi,%edi
  80054f:	c1 ff 1f             	sar    $0x1f,%edi
  800552:	8d 40 04             	lea    0x4(%eax),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
  800558:	eb 10                	jmp    80056a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8b 30                	mov    (%eax),%esi
  80055f:	89 f7                	mov    %esi,%edi
  800561:	c1 ff 1f             	sar    $0x1f,%edi
  800564:	8d 40 04             	lea    0x4(%eax),%eax
  800567:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80056a:	89 f0                	mov    %esi,%eax
  80056c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80056e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800573:	85 ff                	test   %edi,%edi
  800575:	0f 89 3a 01 00 00    	jns    8006b5 <vprintfmt+0x401>
				putch('-', putdat);
  80057b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800582:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800589:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80058c:	89 f0                	mov    %esi,%eax
  80058e:	89 fa                	mov    %edi,%edx
  800590:	f7 d8                	neg    %eax
  800592:	83 d2 00             	adc    $0x0,%edx
  800595:	f7 da                	neg    %edx
			}
			base = 10;
  800597:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80059c:	e9 14 01 00 00       	jmp    8006b5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005a1:	83 f9 01             	cmp    $0x1,%ecx
  8005a4:	7e 13                	jle    8005b9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 50 04             	mov    0x4(%eax),%edx
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	8b 75 14             	mov    0x14(%ebp),%esi
  8005b1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8005b4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005b7:	eb 2c                	jmp    8005e5 <vprintfmt+0x331>
	else if (lflag)
  8005b9:	85 c9                	test   %ecx,%ecx
  8005bb:	74 15                	je     8005d2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8b 00                	mov    (%eax),%eax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c7:	8b 75 14             	mov    0x14(%ebp),%esi
  8005ca:	8d 76 04             	lea    0x4(%esi),%esi
  8005cd:	89 75 14             	mov    %esi,0x14(%ebp)
  8005d0:	eb 13                	jmp    8005e5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dc:	8b 75 14             	mov    0x14(%ebp),%esi
  8005df:	8d 76 04             	lea    0x4(%esi),%esi
  8005e2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8005e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8005ea:	e9 c6 00 00 00       	jmp    8006b5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005ef:	83 f9 01             	cmp    $0x1,%ecx
  8005f2:	7e 13                	jle    800607 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8b 50 04             	mov    0x4(%eax),%edx
  8005fa:	8b 00                	mov    (%eax),%eax
  8005fc:	8b 75 14             	mov    0x14(%ebp),%esi
  8005ff:	8d 4e 08             	lea    0x8(%esi),%ecx
  800602:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800605:	eb 24                	jmp    80062b <vprintfmt+0x377>
	else if (lflag)
  800607:	85 c9                	test   %ecx,%ecx
  800609:	74 11                	je     80061c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	99                   	cltd   
  800611:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800614:	8d 71 04             	lea    0x4(%ecx),%esi
  800617:	89 75 14             	mov    %esi,0x14(%ebp)
  80061a:	eb 0f                	jmp    80062b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	99                   	cltd   
  800622:	8b 75 14             	mov    0x14(%ebp),%esi
  800625:	8d 76 04             	lea    0x4(%esi),%esi
  800628:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80062b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800630:	e9 80 00 00 00       	jmp    8006b5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800635:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80063f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800646:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800650:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800657:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80065a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80065e:	8b 06                	mov    (%esi),%eax
  800660:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800665:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80066a:	eb 49                	jmp    8006b5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80066c:	83 f9 01             	cmp    $0x1,%ecx
  80066f:	7e 13                	jle    800684 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 50 04             	mov    0x4(%eax),%edx
  800677:	8b 00                	mov    (%eax),%eax
  800679:	8b 75 14             	mov    0x14(%ebp),%esi
  80067c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80067f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800682:	eb 2c                	jmp    8006b0 <vprintfmt+0x3fc>
	else if (lflag)
  800684:	85 c9                	test   %ecx,%ecx
  800686:	74 15                	je     80069d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	ba 00 00 00 00       	mov    $0x0,%edx
  800692:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800695:	8d 71 04             	lea    0x4(%ecx),%esi
  800698:	89 75 14             	mov    %esi,0x14(%ebp)
  80069b:	eb 13                	jmp    8006b0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a7:	8b 75 14             	mov    0x14(%ebp),%esi
  8006aa:	8d 76 04             	lea    0x4(%esi),%esi
  8006ad:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8006b0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006b5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8006b9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006bd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8006c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006c4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006c8:	89 04 24             	mov    %eax,(%esp)
  8006cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	e8 a6 fa ff ff       	call   800180 <printnum>
			break;
  8006da:	e9 fa fb ff ff       	jmp    8002d9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006e6:	89 04 24             	mov    %eax,(%esp)
  8006e9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006ec:	e9 e8 fb ff ff       	jmp    8002d9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006f8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006ff:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800702:	89 fb                	mov    %edi,%ebx
  800704:	eb 03                	jmp    800709 <vprintfmt+0x455>
  800706:	83 eb 01             	sub    $0x1,%ebx
  800709:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80070d:	75 f7                	jne    800706 <vprintfmt+0x452>
  80070f:	90                   	nop
  800710:	e9 c4 fb ff ff       	jmp    8002d9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800715:	83 c4 3c             	add    $0x3c,%esp
  800718:	5b                   	pop    %ebx
  800719:	5e                   	pop    %esi
  80071a:	5f                   	pop    %edi
  80071b:	5d                   	pop    %ebp
  80071c:	c3                   	ret    

0080071d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80071d:	55                   	push   %ebp
  80071e:	89 e5                	mov    %esp,%ebp
  800720:	83 ec 28             	sub    $0x28,%esp
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800729:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80072c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800730:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800733:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80073a:	85 c0                	test   %eax,%eax
  80073c:	74 30                	je     80076e <vsnprintf+0x51>
  80073e:	85 d2                	test   %edx,%edx
  800740:	7e 2c                	jle    80076e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800749:	8b 45 10             	mov    0x10(%ebp),%eax
  80074c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800750:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800753:	89 44 24 04          	mov    %eax,0x4(%esp)
  800757:	c7 04 24 6f 02 80 00 	movl   $0x80026f,(%esp)
  80075e:	e8 51 fb ff ff       	call   8002b4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800763:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800766:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80076c:	eb 05                	jmp    800773 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80076e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800773:	c9                   	leave  
  800774:	c3                   	ret    

00800775 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80077b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80077e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800782:	8b 45 10             	mov    0x10(%ebp),%eax
  800785:	89 44 24 08          	mov    %eax,0x8(%esp)
  800789:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	89 04 24             	mov    %eax,(%esp)
  800796:	e8 82 ff ff ff       	call   80071d <vsnprintf>
	va_end(ap);

	return rc;
}
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    
  80079d:	66 90                	xchg   %ax,%ax
  80079f:	90                   	nop

008007a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	eb 03                	jmp    8007b0 <strlen+0x10>
		n++;
  8007ad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007b4:	75 f7                	jne    8007ad <strlen+0xd>
		n++;
	return n;
}
  8007b6:	5d                   	pop    %ebp
  8007b7:	c3                   	ret    

008007b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007be:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c6:	eb 03                	jmp    8007cb <strnlen+0x13>
		n++;
  8007c8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007cb:	39 d0                	cmp    %edx,%eax
  8007cd:	74 06                	je     8007d5 <strnlen+0x1d>
  8007cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007d3:	75 f3                	jne    8007c8 <strnlen+0x10>
		n++;
	return n;
}
  8007d5:	5d                   	pop    %ebp
  8007d6:	c3                   	ret    

008007d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	53                   	push   %ebx
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007e1:	89 c2                	mov    %eax,%edx
  8007e3:	83 c2 01             	add    $0x1,%edx
  8007e6:	83 c1 01             	add    $0x1,%ecx
  8007e9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007ed:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007f0:	84 db                	test   %bl,%bl
  8007f2:	75 ef                	jne    8007e3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007f4:	5b                   	pop    %ebx
  8007f5:	5d                   	pop    %ebp
  8007f6:	c3                   	ret    

008007f7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	53                   	push   %ebx
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800801:	89 1c 24             	mov    %ebx,(%esp)
  800804:	e8 97 ff ff ff       	call   8007a0 <strlen>
	strcpy(dst + len, src);
  800809:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800810:	01 d8                	add    %ebx,%eax
  800812:	89 04 24             	mov    %eax,(%esp)
  800815:	e8 bd ff ff ff       	call   8007d7 <strcpy>
	return dst;
}
  80081a:	89 d8                	mov    %ebx,%eax
  80081c:	83 c4 08             	add    $0x8,%esp
  80081f:	5b                   	pop    %ebx
  800820:	5d                   	pop    %ebp
  800821:	c3                   	ret    

00800822 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	56                   	push   %esi
  800826:	53                   	push   %ebx
  800827:	8b 75 08             	mov    0x8(%ebp),%esi
  80082a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082d:	89 f3                	mov    %esi,%ebx
  80082f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800832:	89 f2                	mov    %esi,%edx
  800834:	eb 0f                	jmp    800845 <strncpy+0x23>
		*dst++ = *src;
  800836:	83 c2 01             	add    $0x1,%edx
  800839:	0f b6 01             	movzbl (%ecx),%eax
  80083c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80083f:	80 39 01             	cmpb   $0x1,(%ecx)
  800842:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800845:	39 da                	cmp    %ebx,%edx
  800847:	75 ed                	jne    800836 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800849:	89 f0                	mov    %esi,%eax
  80084b:	5b                   	pop    %ebx
  80084c:	5e                   	pop    %esi
  80084d:	5d                   	pop    %ebp
  80084e:	c3                   	ret    

0080084f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	56                   	push   %esi
  800853:	53                   	push   %ebx
  800854:	8b 75 08             	mov    0x8(%ebp),%esi
  800857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80085d:	89 f0                	mov    %esi,%eax
  80085f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800863:	85 c9                	test   %ecx,%ecx
  800865:	75 0b                	jne    800872 <strlcpy+0x23>
  800867:	eb 1d                	jmp    800886 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800869:	83 c0 01             	add    $0x1,%eax
  80086c:	83 c2 01             	add    $0x1,%edx
  80086f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800872:	39 d8                	cmp    %ebx,%eax
  800874:	74 0b                	je     800881 <strlcpy+0x32>
  800876:	0f b6 0a             	movzbl (%edx),%ecx
  800879:	84 c9                	test   %cl,%cl
  80087b:	75 ec                	jne    800869 <strlcpy+0x1a>
  80087d:	89 c2                	mov    %eax,%edx
  80087f:	eb 02                	jmp    800883 <strlcpy+0x34>
  800881:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800883:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800886:	29 f0                	sub    %esi,%eax
}
  800888:	5b                   	pop    %ebx
  800889:	5e                   	pop    %esi
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800892:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800895:	eb 06                	jmp    80089d <strcmp+0x11>
		p++, q++;
  800897:	83 c1 01             	add    $0x1,%ecx
  80089a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80089d:	0f b6 01             	movzbl (%ecx),%eax
  8008a0:	84 c0                	test   %al,%al
  8008a2:	74 04                	je     8008a8 <strcmp+0x1c>
  8008a4:	3a 02                	cmp    (%edx),%al
  8008a6:	74 ef                	je     800897 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a8:	0f b6 c0             	movzbl %al,%eax
  8008ab:	0f b6 12             	movzbl (%edx),%edx
  8008ae:	29 d0                	sub    %edx,%eax
}
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	53                   	push   %ebx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bc:	89 c3                	mov    %eax,%ebx
  8008be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c1:	eb 06                	jmp    8008c9 <strncmp+0x17>
		n--, p++, q++;
  8008c3:	83 c0 01             	add    $0x1,%eax
  8008c6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008c9:	39 d8                	cmp    %ebx,%eax
  8008cb:	74 15                	je     8008e2 <strncmp+0x30>
  8008cd:	0f b6 08             	movzbl (%eax),%ecx
  8008d0:	84 c9                	test   %cl,%cl
  8008d2:	74 04                	je     8008d8 <strncmp+0x26>
  8008d4:	3a 0a                	cmp    (%edx),%cl
  8008d6:	74 eb                	je     8008c3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d8:	0f b6 00             	movzbl (%eax),%eax
  8008db:	0f b6 12             	movzbl (%edx),%edx
  8008de:	29 d0                	sub    %edx,%eax
  8008e0:	eb 05                	jmp    8008e7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008e2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008e7:	5b                   	pop    %ebx
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f4:	eb 07                	jmp    8008fd <strchr+0x13>
		if (*s == c)
  8008f6:	38 ca                	cmp    %cl,%dl
  8008f8:	74 0f                	je     800909 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	0f b6 10             	movzbl (%eax),%edx
  800900:	84 d2                	test   %dl,%dl
  800902:	75 f2                	jne    8008f6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800915:	eb 07                	jmp    80091e <strfind+0x13>
		if (*s == c)
  800917:	38 ca                	cmp    %cl,%dl
  800919:	74 0a                	je     800925 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80091b:	83 c0 01             	add    $0x1,%eax
  80091e:	0f b6 10             	movzbl (%eax),%edx
  800921:	84 d2                	test   %dl,%dl
  800923:	75 f2                	jne    800917 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	57                   	push   %edi
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800930:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800933:	85 c9                	test   %ecx,%ecx
  800935:	74 36                	je     80096d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800937:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80093d:	75 28                	jne    800967 <memset+0x40>
  80093f:	f6 c1 03             	test   $0x3,%cl
  800942:	75 23                	jne    800967 <memset+0x40>
		c &= 0xFF;
  800944:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800948:	89 d3                	mov    %edx,%ebx
  80094a:	c1 e3 08             	shl    $0x8,%ebx
  80094d:	89 d6                	mov    %edx,%esi
  80094f:	c1 e6 18             	shl    $0x18,%esi
  800952:	89 d0                	mov    %edx,%eax
  800954:	c1 e0 10             	shl    $0x10,%eax
  800957:	09 f0                	or     %esi,%eax
  800959:	09 c2                	or     %eax,%edx
  80095b:	89 d0                	mov    %edx,%eax
  80095d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80095f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800962:	fc                   	cld    
  800963:	f3 ab                	rep stos %eax,%es:(%edi)
  800965:	eb 06                	jmp    80096d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	fc                   	cld    
  80096b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80096d:	89 f8                	mov    %edi,%eax
  80096f:	5b                   	pop    %ebx
  800970:	5e                   	pop    %esi
  800971:	5f                   	pop    %edi
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	57                   	push   %edi
  800978:	56                   	push   %esi
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80097f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800982:	39 c6                	cmp    %eax,%esi
  800984:	73 35                	jae    8009bb <memmove+0x47>
  800986:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800989:	39 d0                	cmp    %edx,%eax
  80098b:	73 2e                	jae    8009bb <memmove+0x47>
		s += n;
		d += n;
  80098d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800990:	89 d6                	mov    %edx,%esi
  800992:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800994:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80099a:	75 13                	jne    8009af <memmove+0x3b>
  80099c:	f6 c1 03             	test   $0x3,%cl
  80099f:	75 0e                	jne    8009af <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009a1:	83 ef 04             	sub    $0x4,%edi
  8009a4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009aa:	fd                   	std    
  8009ab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ad:	eb 09                	jmp    8009b8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009af:	83 ef 01             	sub    $0x1,%edi
  8009b2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009b5:	fd                   	std    
  8009b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009b8:	fc                   	cld    
  8009b9:	eb 1d                	jmp    8009d8 <memmove+0x64>
  8009bb:	89 f2                	mov    %esi,%edx
  8009bd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bf:	f6 c2 03             	test   $0x3,%dl
  8009c2:	75 0f                	jne    8009d3 <memmove+0x5f>
  8009c4:	f6 c1 03             	test   $0x3,%cl
  8009c7:	75 0a                	jne    8009d3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009c9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009cc:	89 c7                	mov    %eax,%edi
  8009ce:	fc                   	cld    
  8009cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d1:	eb 05                	jmp    8009d8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009d3:	89 c7                	mov    %eax,%edi
  8009d5:	fc                   	cld    
  8009d6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d8:	5e                   	pop    %esi
  8009d9:	5f                   	pop    %edi
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	89 04 24             	mov    %eax,(%esp)
  8009f6:	e8 79 ff ff ff       	call   800974 <memmove>
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	56                   	push   %esi
  800a01:	53                   	push   %ebx
  800a02:	8b 55 08             	mov    0x8(%ebp),%edx
  800a05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a08:	89 d6                	mov    %edx,%esi
  800a0a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a0d:	eb 1a                	jmp    800a29 <memcmp+0x2c>
		if (*s1 != *s2)
  800a0f:	0f b6 02             	movzbl (%edx),%eax
  800a12:	0f b6 19             	movzbl (%ecx),%ebx
  800a15:	38 d8                	cmp    %bl,%al
  800a17:	74 0a                	je     800a23 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a19:	0f b6 c0             	movzbl %al,%eax
  800a1c:	0f b6 db             	movzbl %bl,%ebx
  800a1f:	29 d8                	sub    %ebx,%eax
  800a21:	eb 0f                	jmp    800a32 <memcmp+0x35>
		s1++, s2++;
  800a23:	83 c2 01             	add    $0x1,%edx
  800a26:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a29:	39 f2                	cmp    %esi,%edx
  800a2b:	75 e2                	jne    800a0f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a32:	5b                   	pop    %ebx
  800a33:	5e                   	pop    %esi
  800a34:	5d                   	pop    %ebp
  800a35:	c3                   	ret    

00800a36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a3f:	89 c2                	mov    %eax,%edx
  800a41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a44:	eb 07                	jmp    800a4d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a46:	38 08                	cmp    %cl,(%eax)
  800a48:	74 07                	je     800a51 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a4a:	83 c0 01             	add    $0x1,%eax
  800a4d:	39 d0                	cmp    %edx,%eax
  800a4f:	72 f5                	jb     800a46 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	57                   	push   %edi
  800a57:	56                   	push   %esi
  800a58:	53                   	push   %ebx
  800a59:	8b 55 08             	mov    0x8(%ebp),%edx
  800a5c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a5f:	eb 03                	jmp    800a64 <strtol+0x11>
		s++;
  800a61:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a64:	0f b6 0a             	movzbl (%edx),%ecx
  800a67:	80 f9 09             	cmp    $0x9,%cl
  800a6a:	74 f5                	je     800a61 <strtol+0xe>
  800a6c:	80 f9 20             	cmp    $0x20,%cl
  800a6f:	74 f0                	je     800a61 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a71:	80 f9 2b             	cmp    $0x2b,%cl
  800a74:	75 0a                	jne    800a80 <strtol+0x2d>
		s++;
  800a76:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a79:	bf 00 00 00 00       	mov    $0x0,%edi
  800a7e:	eb 11                	jmp    800a91 <strtol+0x3e>
  800a80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a85:	80 f9 2d             	cmp    $0x2d,%cl
  800a88:	75 07                	jne    800a91 <strtol+0x3e>
		s++, neg = 1;
  800a8a:	8d 52 01             	lea    0x1(%edx),%edx
  800a8d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a91:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a96:	75 15                	jne    800aad <strtol+0x5a>
  800a98:	80 3a 30             	cmpb   $0x30,(%edx)
  800a9b:	75 10                	jne    800aad <strtol+0x5a>
  800a9d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800aa1:	75 0a                	jne    800aad <strtol+0x5a>
		s += 2, base = 16;
  800aa3:	83 c2 02             	add    $0x2,%edx
  800aa6:	b8 10 00 00 00       	mov    $0x10,%eax
  800aab:	eb 10                	jmp    800abd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800aad:	85 c0                	test   %eax,%eax
  800aaf:	75 0c                	jne    800abd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ab1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ab3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ab6:	75 05                	jne    800abd <strtol+0x6a>
		s++, base = 8;
  800ab8:	83 c2 01             	add    $0x1,%edx
  800abb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800abd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ac2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ac5:	0f b6 0a             	movzbl (%edx),%ecx
  800ac8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800acb:	89 f0                	mov    %esi,%eax
  800acd:	3c 09                	cmp    $0x9,%al
  800acf:	77 08                	ja     800ad9 <strtol+0x86>
			dig = *s - '0';
  800ad1:	0f be c9             	movsbl %cl,%ecx
  800ad4:	83 e9 30             	sub    $0x30,%ecx
  800ad7:	eb 20                	jmp    800af9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ad9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800adc:	89 f0                	mov    %esi,%eax
  800ade:	3c 19                	cmp    $0x19,%al
  800ae0:	77 08                	ja     800aea <strtol+0x97>
			dig = *s - 'a' + 10;
  800ae2:	0f be c9             	movsbl %cl,%ecx
  800ae5:	83 e9 57             	sub    $0x57,%ecx
  800ae8:	eb 0f                	jmp    800af9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800aea:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800aed:	89 f0                	mov    %esi,%eax
  800aef:	3c 19                	cmp    $0x19,%al
  800af1:	77 16                	ja     800b09 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800af3:	0f be c9             	movsbl %cl,%ecx
  800af6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800af9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800afc:	7d 0f                	jge    800b0d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800afe:	83 c2 01             	add    $0x1,%edx
  800b01:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b05:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b07:	eb bc                	jmp    800ac5 <strtol+0x72>
  800b09:	89 d8                	mov    %ebx,%eax
  800b0b:	eb 02                	jmp    800b0f <strtol+0xbc>
  800b0d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b13:	74 05                	je     800b1a <strtol+0xc7>
		*endptr = (char *) s;
  800b15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b18:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b1a:	f7 d8                	neg    %eax
  800b1c:	85 ff                	test   %edi,%edi
  800b1e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5f                   	pop    %edi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	57                   	push   %edi
  800b2a:	56                   	push   %esi
  800b2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b34:	8b 55 08             	mov    0x8(%ebp),%edx
  800b37:	89 c3                	mov    %eax,%ebx
  800b39:	89 c7                	mov    %eax,%edi
  800b3b:	89 c6                	mov    %eax,%esi
  800b3d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	57                   	push   %edi
  800b48:	56                   	push   %esi
  800b49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b54:	89 d1                	mov    %edx,%ecx
  800b56:	89 d3                	mov    %edx,%ebx
  800b58:	89 d7                	mov    %edx,%edi
  800b5a:	89 d6                	mov    %edx,%esi
  800b5c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b5e:	5b                   	pop    %ebx
  800b5f:	5e                   	pop    %esi
  800b60:	5f                   	pop    %edi
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b71:	b8 03 00 00 00       	mov    $0x3,%eax
  800b76:	8b 55 08             	mov    0x8(%ebp),%edx
  800b79:	89 cb                	mov    %ecx,%ebx
  800b7b:	89 cf                	mov    %ecx,%edi
  800b7d:	89 ce                	mov    %ecx,%esi
  800b7f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800b81:	85 c0                	test   %eax,%eax
  800b83:	7e 28                	jle    800bad <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b85:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b89:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b90:	00 
  800b91:	c7 44 24 08 17 2a 80 	movl   $0x802a17,0x8(%esp)
  800b98:	00 
  800b99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ba0:	00 
  800ba1:	c7 04 24 34 2a 80 00 	movl   $0x802a34,(%esp)
  800ba8:	e8 f9 16 00 00       	call   8022a6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bad:	83 c4 2c             	add    $0x2c,%esp
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	57                   	push   %edi
  800bb9:	56                   	push   %esi
  800bba:	53                   	push   %ebx
  800bbb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc3:	b8 04 00 00 00       	mov    $0x4,%eax
  800bc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcb:	89 cb                	mov    %ecx,%ebx
  800bcd:	89 cf                	mov    %ecx,%edi
  800bcf:	89 ce                	mov    %ecx,%esi
  800bd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bd3:	85 c0                	test   %eax,%eax
  800bd5:	7e 28                	jle    800bff <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bdb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800be2:	00 
  800be3:	c7 44 24 08 17 2a 80 	movl   $0x802a17,0x8(%esp)
  800bea:	00 
  800beb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bf2:	00 
  800bf3:	c7 04 24 34 2a 80 00 	movl   $0x802a34,(%esp)
  800bfa:	e8 a7 16 00 00       	call   8022a6 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800bff:	83 c4 2c             	add    $0x2c,%esp
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5f                   	pop    %edi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c12:	b8 02 00 00 00       	mov    $0x2,%eax
  800c17:	89 d1                	mov    %edx,%ecx
  800c19:	89 d3                	mov    %edx,%ebx
  800c1b:	89 d7                	mov    %edx,%edi
  800c1d:	89 d6                	mov    %edx,%esi
  800c1f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <sys_yield>:

void
sys_yield(void)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c31:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c36:	89 d1                	mov    %edx,%ecx
  800c38:	89 d3                	mov    %edx,%ebx
  800c3a:	89 d7                	mov    %edx,%edi
  800c3c:	89 d6                	mov    %edx,%esi
  800c3e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	57                   	push   %edi
  800c49:	56                   	push   %esi
  800c4a:	53                   	push   %ebx
  800c4b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4e:	be 00 00 00 00       	mov    $0x0,%esi
  800c53:	b8 05 00 00 00       	mov    $0x5,%eax
  800c58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c61:	89 f7                	mov    %esi,%edi
  800c63:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c65:	85 c0                	test   %eax,%eax
  800c67:	7e 28                	jle    800c91 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c69:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c6d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c74:	00 
  800c75:	c7 44 24 08 17 2a 80 	movl   $0x802a17,0x8(%esp)
  800c7c:	00 
  800c7d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c84:	00 
  800c85:	c7 04 24 34 2a 80 00 	movl   $0x802a34,(%esp)
  800c8c:	e8 15 16 00 00       	call   8022a6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c91:	83 c4 2c             	add    $0x2c,%esp
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
  800c9f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca2:	b8 06 00 00 00       	mov    $0x6,%eax
  800ca7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cb3:	8b 75 18             	mov    0x18(%ebp),%esi
  800cb6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cb8:	85 c0                	test   %eax,%eax
  800cba:	7e 28                	jle    800ce4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cc0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800cc7:	00 
  800cc8:	c7 44 24 08 17 2a 80 	movl   $0x802a17,0x8(%esp)
  800ccf:	00 
  800cd0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd7:	00 
  800cd8:	c7 04 24 34 2a 80 00 	movl   $0x802a34,(%esp)
  800cdf:	e8 c2 15 00 00       	call   8022a6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ce4:	83 c4 2c             	add    $0x2c,%esp
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5f                   	pop    %edi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfa:	b8 07 00 00 00       	mov    $0x7,%eax
  800cff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d02:	8b 55 08             	mov    0x8(%ebp),%edx
  800d05:	89 df                	mov    %ebx,%edi
  800d07:	89 de                	mov    %ebx,%esi
  800d09:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	7e 28                	jle    800d37 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d13:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800d1a:	00 
  800d1b:	c7 44 24 08 17 2a 80 	movl   $0x802a17,0x8(%esp)
  800d22:	00 
  800d23:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d2a:	00 
  800d2b:	c7 04 24 34 2a 80 00 	movl   $0x802a34,(%esp)
  800d32:	e8 6f 15 00 00       	call   8022a6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d37:	83 c4 2c             	add    $0x2c,%esp
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d45:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d4a:	b8 10 00 00 00       	mov    $0x10,%eax
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	89 cb                	mov    %ecx,%ebx
  800d54:	89 cf                	mov    %ecx,%edi
  800d56:	89 ce                	mov    %ecx,%esi
  800d58:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
  800d65:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6d:	b8 09 00 00 00       	mov    $0x9,%eax
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	8b 55 08             	mov    0x8(%ebp),%edx
  800d78:	89 df                	mov    %ebx,%edi
  800d7a:	89 de                	mov    %ebx,%esi
  800d7c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d7e:	85 c0                	test   %eax,%eax
  800d80:	7e 28                	jle    800daa <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d82:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d86:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d8d:	00 
  800d8e:	c7 44 24 08 17 2a 80 	movl   $0x802a17,0x8(%esp)
  800d95:	00 
  800d96:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d9d:	00 
  800d9e:	c7 04 24 34 2a 80 00 	movl   $0x802a34,(%esp)
  800da5:	e8 fc 14 00 00       	call   8022a6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800daa:	83 c4 2c             	add    $0x2c,%esp
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    

00800db2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcb:	89 df                	mov    %ebx,%edi
  800dcd:	89 de                	mov    %ebx,%esi
  800dcf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	7e 28                	jle    800dfd <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800de0:	00 
  800de1:	c7 44 24 08 17 2a 80 	movl   $0x802a17,0x8(%esp)
  800de8:	00 
  800de9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df0:	00 
  800df1:	c7 04 24 34 2a 80 00 	movl   $0x802a34,(%esp)
  800df8:	e8 a9 14 00 00       	call   8022a6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dfd:	83 c4 2c             	add    $0x2c,%esp
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5f                   	pop    %edi
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	57                   	push   %edi
  800e09:	56                   	push   %esi
  800e0a:	53                   	push   %ebx
  800e0b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e13:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	89 df                	mov    %ebx,%edi
  800e20:	89 de                	mov    %ebx,%esi
  800e22:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e24:	85 c0                	test   %eax,%eax
  800e26:	7e 28                	jle    800e50 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e28:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e2c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800e33:	00 
  800e34:	c7 44 24 08 17 2a 80 	movl   $0x802a17,0x8(%esp)
  800e3b:	00 
  800e3c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e43:	00 
  800e44:	c7 04 24 34 2a 80 00 	movl   $0x802a34,(%esp)
  800e4b:	e8 56 14 00 00       	call   8022a6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e50:	83 c4 2c             	add    $0x2c,%esp
  800e53:	5b                   	pop    %ebx
  800e54:	5e                   	pop    %esi
  800e55:	5f                   	pop    %edi
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	57                   	push   %edi
  800e5c:	56                   	push   %esi
  800e5d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5e:	be 00 00 00 00       	mov    $0x0,%esi
  800e63:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e71:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e74:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
  800e81:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e84:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e89:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e91:	89 cb                	mov    %ecx,%ebx
  800e93:	89 cf                	mov    %ecx,%edi
  800e95:	89 ce                	mov    %ecx,%esi
  800e97:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7e 28                	jle    800ec5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800ea8:	00 
  800ea9:	c7 44 24 08 17 2a 80 	movl   $0x802a17,0x8(%esp)
  800eb0:	00 
  800eb1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb8:	00 
  800eb9:	c7 04 24 34 2a 80 00 	movl   $0x802a34,(%esp)
  800ec0:	e8 e1 13 00 00       	call   8022a6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec5:	83 c4 2c             	add    $0x2c,%esp
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800edd:	89 d1                	mov    %edx,%ecx
  800edf:	89 d3                	mov    %edx,%ebx
  800ee1:	89 d7                	mov    %edx,%edi
  800ee3:	89 d6                	mov    %edx,%esi
  800ee5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ee7:	5b                   	pop    %ebx
  800ee8:	5e                   	pop    %esi
  800ee9:	5f                   	pop    %edi
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    

00800eec <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	57                   	push   %edi
  800ef0:	56                   	push   %esi
  800ef1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef7:	b8 11 00 00 00       	mov    $0x11,%eax
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	89 df                	mov    %ebx,%edi
  800f04:	89 de                	mov    %ebx,%esi
  800f06:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f18:	b8 12 00 00 00       	mov    $0x12,%eax
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	89 df                	mov    %ebx,%edi
  800f25:	89 de                	mov    %ebx,%esi
  800f27:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f34:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f39:	b8 13 00 00 00       	mov    $0x13,%eax
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	89 cb                	mov    %ecx,%ebx
  800f43:	89 cf                	mov    %ecx,%edi
  800f45:	89 ce                	mov    %ecx,%esi
  800f47:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  800f49:	5b                   	pop    %ebx
  800f4a:	5e                   	pop    %esi
  800f4b:	5f                   	pop    %edi
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    
  800f4e:	66 90                	xchg   %ax,%ax

00800f50 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	05 00 00 00 30       	add    $0x30000000,%eax
  800f5b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800f6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f70:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f7d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f82:	89 c2                	mov    %eax,%edx
  800f84:	c1 ea 16             	shr    $0x16,%edx
  800f87:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f8e:	f6 c2 01             	test   $0x1,%dl
  800f91:	74 11                	je     800fa4 <fd_alloc+0x2d>
  800f93:	89 c2                	mov    %eax,%edx
  800f95:	c1 ea 0c             	shr    $0xc,%edx
  800f98:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f9f:	f6 c2 01             	test   $0x1,%dl
  800fa2:	75 09                	jne    800fad <fd_alloc+0x36>
			*fd_store = fd;
  800fa4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fab:	eb 17                	jmp    800fc4 <fd_alloc+0x4d>
  800fad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fb2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fb7:	75 c9                	jne    800f82 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fb9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800fbf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    

00800fc6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fcc:	83 f8 1f             	cmp    $0x1f,%eax
  800fcf:	77 36                	ja     801007 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fd1:	c1 e0 0c             	shl    $0xc,%eax
  800fd4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fd9:	89 c2                	mov    %eax,%edx
  800fdb:	c1 ea 16             	shr    $0x16,%edx
  800fde:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fe5:	f6 c2 01             	test   $0x1,%dl
  800fe8:	74 24                	je     80100e <fd_lookup+0x48>
  800fea:	89 c2                	mov    %eax,%edx
  800fec:	c1 ea 0c             	shr    $0xc,%edx
  800fef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ff6:	f6 c2 01             	test   $0x1,%dl
  800ff9:	74 1a                	je     801015 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffe:	89 02                	mov    %eax,(%edx)
	return 0;
  801000:	b8 00 00 00 00       	mov    $0x0,%eax
  801005:	eb 13                	jmp    80101a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801007:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80100c:	eb 0c                	jmp    80101a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80100e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801013:	eb 05                	jmp    80101a <fd_lookup+0x54>
  801015:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    

0080101c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	83 ec 18             	sub    $0x18,%esp
  801022:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801025:	ba 00 00 00 00       	mov    $0x0,%edx
  80102a:	eb 13                	jmp    80103f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80102c:	39 08                	cmp    %ecx,(%eax)
  80102e:	75 0c                	jne    80103c <dev_lookup+0x20>
			*dev = devtab[i];
  801030:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801033:	89 01                	mov    %eax,(%ecx)
			return 0;
  801035:	b8 00 00 00 00       	mov    $0x0,%eax
  80103a:	eb 38                	jmp    801074 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80103c:	83 c2 01             	add    $0x1,%edx
  80103f:	8b 04 95 c0 2a 80 00 	mov    0x802ac0(,%edx,4),%eax
  801046:	85 c0                	test   %eax,%eax
  801048:	75 e2                	jne    80102c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80104a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80104f:	8b 40 48             	mov    0x48(%eax),%eax
  801052:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801056:	89 44 24 04          	mov    %eax,0x4(%esp)
  80105a:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  801061:	e8 00 f1 ff ff       	call   800166 <cprintf>
	*dev = 0;
  801066:	8b 45 0c             	mov    0xc(%ebp),%eax
  801069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80106f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	56                   	push   %esi
  80107a:	53                   	push   %ebx
  80107b:	83 ec 20             	sub    $0x20,%esp
  80107e:	8b 75 08             	mov    0x8(%ebp),%esi
  801081:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801084:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801087:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80108b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801091:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801094:	89 04 24             	mov    %eax,(%esp)
  801097:	e8 2a ff ff ff       	call   800fc6 <fd_lookup>
  80109c:	85 c0                	test   %eax,%eax
  80109e:	78 05                	js     8010a5 <fd_close+0x2f>
	    || fd != fd2)
  8010a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8010a3:	74 0c                	je     8010b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8010a5:	84 db                	test   %bl,%bl
  8010a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ac:	0f 44 c2             	cmove  %edx,%eax
  8010af:	eb 3f                	jmp    8010f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010b8:	8b 06                	mov    (%esi),%eax
  8010ba:	89 04 24             	mov    %eax,(%esp)
  8010bd:	e8 5a ff ff ff       	call   80101c <dev_lookup>
  8010c2:	89 c3                	mov    %eax,%ebx
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	78 16                	js     8010de <fd_close+0x68>
		if (dev->dev_close)
  8010c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8010ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	74 07                	je     8010de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8010d7:	89 34 24             	mov    %esi,(%esp)
  8010da:	ff d0                	call   *%eax
  8010dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010e9:	e8 fe fb ff ff       	call   800cec <sys_page_unmap>
	return r;
  8010ee:	89 d8                	mov    %ebx,%eax
}
  8010f0:	83 c4 20             	add    $0x20,%esp
  8010f3:	5b                   	pop    %ebx
  8010f4:	5e                   	pop    %esi
  8010f5:	5d                   	pop    %ebp
  8010f6:	c3                   	ret    

008010f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801100:	89 44 24 04          	mov    %eax,0x4(%esp)
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	89 04 24             	mov    %eax,(%esp)
  80110a:	e8 b7 fe ff ff       	call   800fc6 <fd_lookup>
  80110f:	89 c2                	mov    %eax,%edx
  801111:	85 d2                	test   %edx,%edx
  801113:	78 13                	js     801128 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801115:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80111c:	00 
  80111d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801120:	89 04 24             	mov    %eax,(%esp)
  801123:	e8 4e ff ff ff       	call   801076 <fd_close>
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <close_all>:

void
close_all(void)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	53                   	push   %ebx
  80112e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801131:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801136:	89 1c 24             	mov    %ebx,(%esp)
  801139:	e8 b9 ff ff ff       	call   8010f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80113e:	83 c3 01             	add    $0x1,%ebx
  801141:	83 fb 20             	cmp    $0x20,%ebx
  801144:	75 f0                	jne    801136 <close_all+0xc>
		close(i);
}
  801146:	83 c4 14             	add    $0x14,%esp
  801149:	5b                   	pop    %ebx
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	57                   	push   %edi
  801150:	56                   	push   %esi
  801151:	53                   	push   %ebx
  801152:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801155:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801158:	89 44 24 04          	mov    %eax,0x4(%esp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	89 04 24             	mov    %eax,(%esp)
  801162:	e8 5f fe ff ff       	call   800fc6 <fd_lookup>
  801167:	89 c2                	mov    %eax,%edx
  801169:	85 d2                	test   %edx,%edx
  80116b:	0f 88 e1 00 00 00    	js     801252 <dup+0x106>
		return r;
	close(newfdnum);
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	89 04 24             	mov    %eax,(%esp)
  801177:	e8 7b ff ff ff       	call   8010f7 <close>

	newfd = INDEX2FD(newfdnum);
  80117c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80117f:	c1 e3 0c             	shl    $0xc,%ebx
  801182:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801188:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80118b:	89 04 24             	mov    %eax,(%esp)
  80118e:	e8 cd fd ff ff       	call   800f60 <fd2data>
  801193:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801195:	89 1c 24             	mov    %ebx,(%esp)
  801198:	e8 c3 fd ff ff       	call   800f60 <fd2data>
  80119d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80119f:	89 f0                	mov    %esi,%eax
  8011a1:	c1 e8 16             	shr    $0x16,%eax
  8011a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011ab:	a8 01                	test   $0x1,%al
  8011ad:	74 43                	je     8011f2 <dup+0xa6>
  8011af:	89 f0                	mov    %esi,%eax
  8011b1:	c1 e8 0c             	shr    $0xc,%eax
  8011b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011bb:	f6 c2 01             	test   $0x1,%dl
  8011be:	74 32                	je     8011f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011db:	00 
  8011dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011e7:	e8 ad fa ff ff       	call   800c99 <sys_page_map>
  8011ec:	89 c6                	mov    %eax,%esi
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	78 3e                	js     801230 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f5:	89 c2                	mov    %eax,%edx
  8011f7:	c1 ea 0c             	shr    $0xc,%edx
  8011fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801201:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801207:	89 54 24 10          	mov    %edx,0x10(%esp)
  80120b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80120f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801216:	00 
  801217:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801222:	e8 72 fa ff ff       	call   800c99 <sys_page_map>
  801227:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80122c:	85 f6                	test   %esi,%esi
  80122e:	79 22                	jns    801252 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801230:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801234:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80123b:	e8 ac fa ff ff       	call   800cec <sys_page_unmap>
	sys_page_unmap(0, nva);
  801240:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801244:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80124b:	e8 9c fa ff ff       	call   800cec <sys_page_unmap>
	return r;
  801250:	89 f0                	mov    %esi,%eax
}
  801252:	83 c4 3c             	add    $0x3c,%esp
  801255:	5b                   	pop    %ebx
  801256:	5e                   	pop    %esi
  801257:	5f                   	pop    %edi
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    

0080125a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	53                   	push   %ebx
  80125e:	83 ec 24             	sub    $0x24,%esp
  801261:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801264:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801267:	89 44 24 04          	mov    %eax,0x4(%esp)
  80126b:	89 1c 24             	mov    %ebx,(%esp)
  80126e:	e8 53 fd ff ff       	call   800fc6 <fd_lookup>
  801273:	89 c2                	mov    %eax,%edx
  801275:	85 d2                	test   %edx,%edx
  801277:	78 6d                	js     8012e6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801279:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801283:	8b 00                	mov    (%eax),%eax
  801285:	89 04 24             	mov    %eax,(%esp)
  801288:	e8 8f fd ff ff       	call   80101c <dev_lookup>
  80128d:	85 c0                	test   %eax,%eax
  80128f:	78 55                	js     8012e6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801294:	8b 50 08             	mov    0x8(%eax),%edx
  801297:	83 e2 03             	and    $0x3,%edx
  80129a:	83 fa 01             	cmp    $0x1,%edx
  80129d:	75 23                	jne    8012c2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80129f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012a4:	8b 40 48             	mov    0x48(%eax),%eax
  8012a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012af:	c7 04 24 85 2a 80 00 	movl   $0x802a85,(%esp)
  8012b6:	e8 ab ee ff ff       	call   800166 <cprintf>
		return -E_INVAL;
  8012bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c0:	eb 24                	jmp    8012e6 <read+0x8c>
	}
	if (!dev->dev_read)
  8012c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c5:	8b 52 08             	mov    0x8(%edx),%edx
  8012c8:	85 d2                	test   %edx,%edx
  8012ca:	74 15                	je     8012e1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8012da:	89 04 24             	mov    %eax,(%esp)
  8012dd:	ff d2                	call   *%edx
  8012df:	eb 05                	jmp    8012e6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8012e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8012e6:	83 c4 24             	add    $0x24,%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    

008012ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	57                   	push   %edi
  8012f0:	56                   	push   %esi
  8012f1:	53                   	push   %ebx
  8012f2:	83 ec 1c             	sub    $0x1c,%esp
  8012f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801300:	eb 23                	jmp    801325 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801302:	89 f0                	mov    %esi,%eax
  801304:	29 d8                	sub    %ebx,%eax
  801306:	89 44 24 08          	mov    %eax,0x8(%esp)
  80130a:	89 d8                	mov    %ebx,%eax
  80130c:	03 45 0c             	add    0xc(%ebp),%eax
  80130f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801313:	89 3c 24             	mov    %edi,(%esp)
  801316:	e8 3f ff ff ff       	call   80125a <read>
		if (m < 0)
  80131b:	85 c0                	test   %eax,%eax
  80131d:	78 10                	js     80132f <readn+0x43>
			return m;
		if (m == 0)
  80131f:	85 c0                	test   %eax,%eax
  801321:	74 0a                	je     80132d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801323:	01 c3                	add    %eax,%ebx
  801325:	39 f3                	cmp    %esi,%ebx
  801327:	72 d9                	jb     801302 <readn+0x16>
  801329:	89 d8                	mov    %ebx,%eax
  80132b:	eb 02                	jmp    80132f <readn+0x43>
  80132d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80132f:	83 c4 1c             	add    $0x1c,%esp
  801332:	5b                   	pop    %ebx
  801333:	5e                   	pop    %esi
  801334:	5f                   	pop    %edi
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    

00801337 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	53                   	push   %ebx
  80133b:	83 ec 24             	sub    $0x24,%esp
  80133e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801341:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801344:	89 44 24 04          	mov    %eax,0x4(%esp)
  801348:	89 1c 24             	mov    %ebx,(%esp)
  80134b:	e8 76 fc ff ff       	call   800fc6 <fd_lookup>
  801350:	89 c2                	mov    %eax,%edx
  801352:	85 d2                	test   %edx,%edx
  801354:	78 68                	js     8013be <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801356:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801359:	89 44 24 04          	mov    %eax,0x4(%esp)
  80135d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801360:	8b 00                	mov    (%eax),%eax
  801362:	89 04 24             	mov    %eax,(%esp)
  801365:	e8 b2 fc ff ff       	call   80101c <dev_lookup>
  80136a:	85 c0                	test   %eax,%eax
  80136c:	78 50                	js     8013be <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80136e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801371:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801375:	75 23                	jne    80139a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801377:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80137c:	8b 40 48             	mov    0x48(%eax),%eax
  80137f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801383:	89 44 24 04          	mov    %eax,0x4(%esp)
  801387:	c7 04 24 a1 2a 80 00 	movl   $0x802aa1,(%esp)
  80138e:	e8 d3 ed ff ff       	call   800166 <cprintf>
		return -E_INVAL;
  801393:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801398:	eb 24                	jmp    8013be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80139a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139d:	8b 52 0c             	mov    0xc(%edx),%edx
  8013a0:	85 d2                	test   %edx,%edx
  8013a2:	74 15                	je     8013b9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013b2:	89 04 24             	mov    %eax,(%esp)
  8013b5:	ff d2                	call   *%edx
  8013b7:	eb 05                	jmp    8013be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8013b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8013be:	83 c4 24             	add    $0x24,%esp
  8013c1:	5b                   	pop    %ebx
  8013c2:	5d                   	pop    %ebp
  8013c3:	c3                   	ret    

008013c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	89 04 24             	mov    %eax,(%esp)
  8013d7:	e8 ea fb ff ff       	call   800fc6 <fd_lookup>
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	78 0e                	js     8013ee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8013e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	53                   	push   %ebx
  8013f4:	83 ec 24             	sub    $0x24,%esp
  8013f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801401:	89 1c 24             	mov    %ebx,(%esp)
  801404:	e8 bd fb ff ff       	call   800fc6 <fd_lookup>
  801409:	89 c2                	mov    %eax,%edx
  80140b:	85 d2                	test   %edx,%edx
  80140d:	78 61                	js     801470 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801412:	89 44 24 04          	mov    %eax,0x4(%esp)
  801416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801419:	8b 00                	mov    (%eax),%eax
  80141b:	89 04 24             	mov    %eax,(%esp)
  80141e:	e8 f9 fb ff ff       	call   80101c <dev_lookup>
  801423:	85 c0                	test   %eax,%eax
  801425:	78 49                	js     801470 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80142e:	75 23                	jne    801453 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801430:	a1 0c 40 80 00       	mov    0x80400c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801435:	8b 40 48             	mov    0x48(%eax),%eax
  801438:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80143c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801440:	c7 04 24 64 2a 80 00 	movl   $0x802a64,(%esp)
  801447:	e8 1a ed ff ff       	call   800166 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80144c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801451:	eb 1d                	jmp    801470 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801453:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801456:	8b 52 18             	mov    0x18(%edx),%edx
  801459:	85 d2                	test   %edx,%edx
  80145b:	74 0e                	je     80146b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80145d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801460:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801464:	89 04 24             	mov    %eax,(%esp)
  801467:	ff d2                	call   *%edx
  801469:	eb 05                	jmp    801470 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80146b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801470:	83 c4 24             	add    $0x24,%esp
  801473:	5b                   	pop    %ebx
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    

00801476 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	53                   	push   %ebx
  80147a:	83 ec 24             	sub    $0x24,%esp
  80147d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801480:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801483:	89 44 24 04          	mov    %eax,0x4(%esp)
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	89 04 24             	mov    %eax,(%esp)
  80148d:	e8 34 fb ff ff       	call   800fc6 <fd_lookup>
  801492:	89 c2                	mov    %eax,%edx
  801494:	85 d2                	test   %edx,%edx
  801496:	78 52                	js     8014ea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801498:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a2:	8b 00                	mov    (%eax),%eax
  8014a4:	89 04 24             	mov    %eax,(%esp)
  8014a7:	e8 70 fb ff ff       	call   80101c <dev_lookup>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	78 3a                	js     8014ea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8014b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014b7:	74 2c                	je     8014e5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014b9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014bc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014c3:	00 00 00 
	stat->st_isdir = 0;
  8014c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014cd:	00 00 00 
	stat->st_dev = dev;
  8014d0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014dd:	89 14 24             	mov    %edx,(%esp)
  8014e0:	ff 50 14             	call   *0x14(%eax)
  8014e3:	eb 05                	jmp    8014ea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8014e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8014ea:	83 c4 24             	add    $0x24,%esp
  8014ed:	5b                   	pop    %ebx
  8014ee:	5d                   	pop    %ebp
  8014ef:	c3                   	ret    

008014f0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	56                   	push   %esi
  8014f4:	53                   	push   %ebx
  8014f5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014ff:	00 
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	89 04 24             	mov    %eax,(%esp)
  801506:	e8 99 02 00 00       	call   8017a4 <open>
  80150b:	89 c3                	mov    %eax,%ebx
  80150d:	85 db                	test   %ebx,%ebx
  80150f:	78 1b                	js     80152c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	89 44 24 04          	mov    %eax,0x4(%esp)
  801518:	89 1c 24             	mov    %ebx,(%esp)
  80151b:	e8 56 ff ff ff       	call   801476 <fstat>
  801520:	89 c6                	mov    %eax,%esi
	close(fd);
  801522:	89 1c 24             	mov    %ebx,(%esp)
  801525:	e8 cd fb ff ff       	call   8010f7 <close>
	return r;
  80152a:	89 f0                	mov    %esi,%eax
}
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	5b                   	pop    %ebx
  801530:	5e                   	pop    %esi
  801531:	5d                   	pop    %ebp
  801532:	c3                   	ret    

00801533 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	56                   	push   %esi
  801537:	53                   	push   %ebx
  801538:	83 ec 10             	sub    $0x10,%esp
  80153b:	89 c6                	mov    %eax,%esi
  80153d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80153f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801546:	75 11                	jne    801559 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801548:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80154f:	e8 7b 0e 00 00       	call   8023cf <ipc_find_env>
  801554:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801559:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801560:	00 
  801561:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801568:	00 
  801569:	89 74 24 04          	mov    %esi,0x4(%esp)
  80156d:	a1 00 40 80 00       	mov    0x804000,%eax
  801572:	89 04 24             	mov    %eax,(%esp)
  801575:	e8 ee 0d 00 00       	call   802368 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80157a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801581:	00 
  801582:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801586:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80158d:	e8 6e 0d 00 00       	call   802300 <ipc_recv>
}
  801592:	83 c4 10             	add    $0x10,%esp
  801595:	5b                   	pop    %ebx
  801596:	5e                   	pop    %esi
  801597:	5d                   	pop    %ebp
  801598:	c3                   	ret    

00801599 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8015bc:	e8 72 ff ff ff       	call   801533 <fsipc>
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8015cf:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d9:	b8 06 00 00 00       	mov    $0x6,%eax
  8015de:	e8 50 ff ff ff       	call   801533 <fsipc>
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	53                   	push   %ebx
  8015e9:	83 ec 14             	sub    $0x14,%esp
  8015ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ff:	b8 05 00 00 00       	mov    $0x5,%eax
  801604:	e8 2a ff ff ff       	call   801533 <fsipc>
  801609:	89 c2                	mov    %eax,%edx
  80160b:	85 d2                	test   %edx,%edx
  80160d:	78 2b                	js     80163a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80160f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801616:	00 
  801617:	89 1c 24             	mov    %ebx,(%esp)
  80161a:	e8 b8 f1 ff ff       	call   8007d7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80161f:	a1 80 50 80 00       	mov    0x805080,%eax
  801624:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80162a:	a1 84 50 80 00       	mov    0x805084,%eax
  80162f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801635:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163a:	83 c4 14             	add    $0x14,%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	53                   	push   %ebx
  801644:	83 ec 14             	sub    $0x14,%esp
  801647:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80164a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801650:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801655:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801658:	8b 55 08             	mov    0x8(%ebp),%edx
  80165b:	8b 52 0c             	mov    0xc(%edx),%edx
  80165e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  801664:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801669:	89 44 24 08          	mov    %eax,0x8(%esp)
  80166d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801670:	89 44 24 04          	mov    %eax,0x4(%esp)
  801674:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80167b:	e8 f4 f2 ff ff       	call   800974 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801680:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  801687:	00 
  801688:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  80168f:	e8 d2 ea ff ff       	call   800166 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801694:	ba 00 00 00 00       	mov    $0x0,%edx
  801699:	b8 04 00 00 00       	mov    $0x4,%eax
  80169e:	e8 90 fe ff ff       	call   801533 <fsipc>
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	78 53                	js     8016fa <devfile_write+0xba>
		return r;
	assert(r <= n);
  8016a7:	39 c3                	cmp    %eax,%ebx
  8016a9:	73 24                	jae    8016cf <devfile_write+0x8f>
  8016ab:	c7 44 24 0c d9 2a 80 	movl   $0x802ad9,0xc(%esp)
  8016b2:	00 
  8016b3:	c7 44 24 08 e0 2a 80 	movl   $0x802ae0,0x8(%esp)
  8016ba:	00 
  8016bb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8016c2:	00 
  8016c3:	c7 04 24 f5 2a 80 00 	movl   $0x802af5,(%esp)
  8016ca:	e8 d7 0b 00 00       	call   8022a6 <_panic>
	assert(r <= PGSIZE);
  8016cf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016d4:	7e 24                	jle    8016fa <devfile_write+0xba>
  8016d6:	c7 44 24 0c 00 2b 80 	movl   $0x802b00,0xc(%esp)
  8016dd:	00 
  8016de:	c7 44 24 08 e0 2a 80 	movl   $0x802ae0,0x8(%esp)
  8016e5:	00 
  8016e6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8016ed:	00 
  8016ee:	c7 04 24 f5 2a 80 00 	movl   $0x802af5,(%esp)
  8016f5:	e8 ac 0b 00 00       	call   8022a6 <_panic>
	return r;
}
  8016fa:	83 c4 14             	add    $0x14,%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    

00801700 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	56                   	push   %esi
  801704:	53                   	push   %ebx
  801705:	83 ec 10             	sub    $0x10,%esp
  801708:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	8b 40 0c             	mov    0xc(%eax),%eax
  801711:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801716:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80171c:	ba 00 00 00 00       	mov    $0x0,%edx
  801721:	b8 03 00 00 00       	mov    $0x3,%eax
  801726:	e8 08 fe ff ff       	call   801533 <fsipc>
  80172b:	89 c3                	mov    %eax,%ebx
  80172d:	85 c0                	test   %eax,%eax
  80172f:	78 6a                	js     80179b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801731:	39 c6                	cmp    %eax,%esi
  801733:	73 24                	jae    801759 <devfile_read+0x59>
  801735:	c7 44 24 0c d9 2a 80 	movl   $0x802ad9,0xc(%esp)
  80173c:	00 
  80173d:	c7 44 24 08 e0 2a 80 	movl   $0x802ae0,0x8(%esp)
  801744:	00 
  801745:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80174c:	00 
  80174d:	c7 04 24 f5 2a 80 00 	movl   $0x802af5,(%esp)
  801754:	e8 4d 0b 00 00       	call   8022a6 <_panic>
	assert(r <= PGSIZE);
  801759:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80175e:	7e 24                	jle    801784 <devfile_read+0x84>
  801760:	c7 44 24 0c 00 2b 80 	movl   $0x802b00,0xc(%esp)
  801767:	00 
  801768:	c7 44 24 08 e0 2a 80 	movl   $0x802ae0,0x8(%esp)
  80176f:	00 
  801770:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801777:	00 
  801778:	c7 04 24 f5 2a 80 00 	movl   $0x802af5,(%esp)
  80177f:	e8 22 0b 00 00       	call   8022a6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801784:	89 44 24 08          	mov    %eax,0x8(%esp)
  801788:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80178f:	00 
  801790:	8b 45 0c             	mov    0xc(%ebp),%eax
  801793:	89 04 24             	mov    %eax,(%esp)
  801796:	e8 d9 f1 ff ff       	call   800974 <memmove>
	return r;
}
  80179b:	89 d8                	mov    %ebx,%eax
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	5b                   	pop    %ebx
  8017a1:	5e                   	pop    %esi
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    

008017a4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	53                   	push   %ebx
  8017a8:	83 ec 24             	sub    $0x24,%esp
  8017ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017ae:	89 1c 24             	mov    %ebx,(%esp)
  8017b1:	e8 ea ef ff ff       	call   8007a0 <strlen>
  8017b6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017bb:	7f 60                	jg     80181d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c0:	89 04 24             	mov    %eax,(%esp)
  8017c3:	e8 af f7 ff ff       	call   800f77 <fd_alloc>
  8017c8:	89 c2                	mov    %eax,%edx
  8017ca:	85 d2                	test   %edx,%edx
  8017cc:	78 54                	js     801822 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8017ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017d2:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8017d9:	e8 f9 ef ff ff       	call   8007d7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e1:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ee:	e8 40 fd ff ff       	call   801533 <fsipc>
  8017f3:	89 c3                	mov    %eax,%ebx
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	79 17                	jns    801810 <open+0x6c>
		fd_close(fd, 0);
  8017f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801800:	00 
  801801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801804:	89 04 24             	mov    %eax,(%esp)
  801807:	e8 6a f8 ff ff       	call   801076 <fd_close>
		return r;
  80180c:	89 d8                	mov    %ebx,%eax
  80180e:	eb 12                	jmp    801822 <open+0x7e>
	}

	return fd2num(fd);
  801810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801813:	89 04 24             	mov    %eax,(%esp)
  801816:	e8 35 f7 ff ff       	call   800f50 <fd2num>
  80181b:	eb 05                	jmp    801822 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80181d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801822:	83 c4 24             	add    $0x24,%esp
  801825:	5b                   	pop    %ebx
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    

00801828 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80182e:	ba 00 00 00 00       	mov    $0x0,%edx
  801833:	b8 08 00 00 00       	mov    $0x8,%eax
  801838:	e8 f6 fc ff ff       	call   801533 <fsipc>
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <evict>:

int evict(void)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801845:	c7 04 24 0c 2b 80 00 	movl   $0x802b0c,(%esp)
  80184c:	e8 15 e9 ff ff       	call   800166 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
  801856:	b8 09 00 00 00       	mov    $0x9,%eax
  80185b:	e8 d3 fc ff ff       	call   801533 <fsipc>
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    
  801862:	66 90                	xchg   %ax,%ax
  801864:	66 90                	xchg   %ax,%ax
  801866:	66 90                	xchg   %ax,%ax
  801868:	66 90                	xchg   %ax,%ax
  80186a:	66 90                	xchg   %ax,%ax
  80186c:	66 90                	xchg   %ax,%ax
  80186e:	66 90                	xchg   %ax,%ax

00801870 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801876:	c7 44 24 04 25 2b 80 	movl   $0x802b25,0x4(%esp)
  80187d:	00 
  80187e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801881:	89 04 24             	mov    %eax,(%esp)
  801884:	e8 4e ef ff ff       	call   8007d7 <strcpy>
	return 0;
}
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	53                   	push   %ebx
  801894:	83 ec 14             	sub    $0x14,%esp
  801897:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80189a:	89 1c 24             	mov    %ebx,(%esp)
  80189d:	e8 65 0b 00 00       	call   802407 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8018a2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8018a7:	83 f8 01             	cmp    $0x1,%eax
  8018aa:	75 0d                	jne    8018b9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8018ac:	8b 43 0c             	mov    0xc(%ebx),%eax
  8018af:	89 04 24             	mov    %eax,(%esp)
  8018b2:	e8 29 03 00 00       	call   801be0 <nsipc_close>
  8018b7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8018b9:	89 d0                	mov    %edx,%eax
  8018bb:	83 c4 14             	add    $0x14,%esp
  8018be:	5b                   	pop    %ebx
  8018bf:	5d                   	pop    %ebp
  8018c0:	c3                   	ret    

008018c1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018ce:	00 
  8018cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e3:	89 04 24             	mov    %eax,(%esp)
  8018e6:	e8 f0 03 00 00       	call   801cdb <nsipc_send>
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018fa:	00 
  8018fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801902:	8b 45 0c             	mov    0xc(%ebp),%eax
  801905:	89 44 24 04          	mov    %eax,0x4(%esp)
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	8b 40 0c             	mov    0xc(%eax),%eax
  80190f:	89 04 24             	mov    %eax,(%esp)
  801912:	e8 44 03 00 00       	call   801c5b <nsipc_recv>
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80191f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801922:	89 54 24 04          	mov    %edx,0x4(%esp)
  801926:	89 04 24             	mov    %eax,(%esp)
  801929:	e8 98 f6 ff ff       	call   800fc6 <fd_lookup>
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 17                	js     801949 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801935:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80193b:	39 08                	cmp    %ecx,(%eax)
  80193d:	75 05                	jne    801944 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80193f:	8b 40 0c             	mov    0xc(%eax),%eax
  801942:	eb 05                	jmp    801949 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801944:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	56                   	push   %esi
  80194f:	53                   	push   %ebx
  801950:	83 ec 20             	sub    $0x20,%esp
  801953:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801955:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801958:	89 04 24             	mov    %eax,(%esp)
  80195b:	e8 17 f6 ff ff       	call   800f77 <fd_alloc>
  801960:	89 c3                	mov    %eax,%ebx
  801962:	85 c0                	test   %eax,%eax
  801964:	78 21                	js     801987 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801966:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80196d:	00 
  80196e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801971:	89 44 24 04          	mov    %eax,0x4(%esp)
  801975:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80197c:	e8 c4 f2 ff ff       	call   800c45 <sys_page_alloc>
  801981:	89 c3                	mov    %eax,%ebx
  801983:	85 c0                	test   %eax,%eax
  801985:	79 0c                	jns    801993 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801987:	89 34 24             	mov    %esi,(%esp)
  80198a:	e8 51 02 00 00       	call   801be0 <nsipc_close>
		return r;
  80198f:	89 d8                	mov    %ebx,%eax
  801991:	eb 20                	jmp    8019b3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801993:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80199e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8019a8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8019ab:	89 14 24             	mov    %edx,(%esp)
  8019ae:	e8 9d f5 ff ff       	call   800f50 <fd2num>
}
  8019b3:	83 c4 20             	add    $0x20,%esp
  8019b6:	5b                   	pop    %ebx
  8019b7:	5e                   	pop    %esi
  8019b8:	5d                   	pop    %ebp
  8019b9:	c3                   	ret    

008019ba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	e8 51 ff ff ff       	call   801919 <fd2sockid>
		return r;
  8019c8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	78 23                	js     8019f1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019ce:	8b 55 10             	mov    0x10(%ebp),%edx
  8019d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019dc:	89 04 24             	mov    %eax,(%esp)
  8019df:	e8 45 01 00 00       	call   801b29 <nsipc_accept>
		return r;
  8019e4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 07                	js     8019f1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8019ea:	e8 5c ff ff ff       	call   80194b <alloc_sockfd>
  8019ef:	89 c1                	mov    %eax,%ecx
}
  8019f1:	89 c8                	mov    %ecx,%eax
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	e8 16 ff ff ff       	call   801919 <fd2sockid>
  801a03:	89 c2                	mov    %eax,%edx
  801a05:	85 d2                	test   %edx,%edx
  801a07:	78 16                	js     801a1f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801a09:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a17:	89 14 24             	mov    %edx,(%esp)
  801a1a:	e8 60 01 00 00       	call   801b7f <nsipc_bind>
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <shutdown>:

int
shutdown(int s, int how)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	e8 ea fe ff ff       	call   801919 <fd2sockid>
  801a2f:	89 c2                	mov    %eax,%edx
  801a31:	85 d2                	test   %edx,%edx
  801a33:	78 0f                	js     801a44 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3c:	89 14 24             	mov    %edx,(%esp)
  801a3f:	e8 7a 01 00 00       	call   801bbe <nsipc_shutdown>
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	e8 c5 fe ff ff       	call   801919 <fd2sockid>
  801a54:	89 c2                	mov    %eax,%edx
  801a56:	85 d2                	test   %edx,%edx
  801a58:	78 16                	js     801a70 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a68:	89 14 24             	mov    %edx,(%esp)
  801a6b:	e8 8a 01 00 00       	call   801bfa <nsipc_connect>
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <listen>:

int
listen(int s, int backlog)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	e8 99 fe ff ff       	call   801919 <fd2sockid>
  801a80:	89 c2                	mov    %eax,%edx
  801a82:	85 d2                	test   %edx,%edx
  801a84:	78 0f                	js     801a95 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8d:	89 14 24             	mov    %edx,(%esp)
  801a90:	e8 a4 01 00 00       	call   801c39 <nsipc_listen>
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	89 04 24             	mov    %eax,(%esp)
  801ab1:	e8 98 02 00 00       	call   801d4e <nsipc_socket>
  801ab6:	89 c2                	mov    %eax,%edx
  801ab8:	85 d2                	test   %edx,%edx
  801aba:	78 05                	js     801ac1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801abc:	e8 8a fe ff ff       	call   80194b <alloc_sockfd>
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	53                   	push   %ebx
  801ac7:	83 ec 14             	sub    $0x14,%esp
  801aca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801acc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ad3:	75 11                	jne    801ae6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ad5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801adc:	e8 ee 08 00 00       	call   8023cf <ipc_find_env>
  801ae1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ae6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801aed:	00 
  801aee:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801af5:	00 
  801af6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801afa:	a1 04 40 80 00       	mov    0x804004,%eax
  801aff:	89 04 24             	mov    %eax,(%esp)
  801b02:	e8 61 08 00 00       	call   802368 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b07:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b0e:	00 
  801b0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b16:	00 
  801b17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1e:	e8 dd 07 00 00       	call   802300 <ipc_recv>
}
  801b23:	83 c4 14             	add    $0x14,%esp
  801b26:	5b                   	pop    %ebx
  801b27:	5d                   	pop    %ebp
  801b28:	c3                   	ret    

00801b29 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	56                   	push   %esi
  801b2d:	53                   	push   %ebx
  801b2e:	83 ec 10             	sub    $0x10,%esp
  801b31:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b3c:	8b 06                	mov    (%esi),%eax
  801b3e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b43:	b8 01 00 00 00       	mov    $0x1,%eax
  801b48:	e8 76 ff ff ff       	call   801ac3 <nsipc>
  801b4d:	89 c3                	mov    %eax,%ebx
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	78 23                	js     801b76 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b53:	a1 10 60 80 00       	mov    0x806010,%eax
  801b58:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b5c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b63:	00 
  801b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b67:	89 04 24             	mov    %eax,(%esp)
  801b6a:	e8 05 ee ff ff       	call   800974 <memmove>
		*addrlen = ret->ret_addrlen;
  801b6f:	a1 10 60 80 00       	mov    0x806010,%eax
  801b74:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801b76:	89 d8                	mov    %ebx,%eax
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    

00801b7f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	53                   	push   %ebx
  801b83:	83 ec 14             	sub    $0x14,%esp
  801b86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801ba3:	e8 cc ed ff ff       	call   800974 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ba8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bae:	b8 02 00 00 00       	mov    $0x2,%eax
  801bb3:	e8 0b ff ff ff       	call   801ac3 <nsipc>
}
  801bb8:	83 c4 14             	add    $0x14,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5d                   	pop    %ebp
  801bbd:	c3                   	ret    

00801bbe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bd4:	b8 03 00 00 00       	mov    $0x3,%eax
  801bd9:	e8 e5 fe ff ff       	call   801ac3 <nsipc>
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <nsipc_close>:

int
nsipc_close(int s)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bee:	b8 04 00 00 00       	mov    $0x4,%eax
  801bf3:	e8 cb fe ff ff       	call   801ac3 <nsipc>
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 14             	sub    $0x14,%esp
  801c01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c0c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c17:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c1e:	e8 51 ed ff ff       	call   800974 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c23:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c29:	b8 05 00 00 00       	mov    $0x5,%eax
  801c2e:	e8 90 fe ff ff       	call   801ac3 <nsipc>
}
  801c33:	83 c4 14             	add    $0x14,%esp
  801c36:	5b                   	pop    %ebx
  801c37:	5d                   	pop    %ebp
  801c38:	c3                   	ret    

00801c39 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c4f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c54:	e8 6a fe ff ff       	call   801ac3 <nsipc>
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 10             	sub    $0x10,%esp
  801c63:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c6e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c74:	8b 45 14             	mov    0x14(%ebp),%eax
  801c77:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c7c:	b8 07 00 00 00       	mov    $0x7,%eax
  801c81:	e8 3d fe ff ff       	call   801ac3 <nsipc>
  801c86:	89 c3                	mov    %eax,%ebx
  801c88:	85 c0                	test   %eax,%eax
  801c8a:	78 46                	js     801cd2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801c8c:	39 f0                	cmp    %esi,%eax
  801c8e:	7f 07                	jg     801c97 <nsipc_recv+0x3c>
  801c90:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c95:	7e 24                	jle    801cbb <nsipc_recv+0x60>
  801c97:	c7 44 24 0c 31 2b 80 	movl   $0x802b31,0xc(%esp)
  801c9e:	00 
  801c9f:	c7 44 24 08 e0 2a 80 	movl   $0x802ae0,0x8(%esp)
  801ca6:	00 
  801ca7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801cae:	00 
  801caf:	c7 04 24 46 2b 80 00 	movl   $0x802b46,(%esp)
  801cb6:	e8 eb 05 00 00       	call   8022a6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cbb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cbf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cc6:	00 
  801cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cca:	89 04 24             	mov    %eax,(%esp)
  801ccd:	e8 a2 ec ff ff       	call   800974 <memmove>
	}

	return r;
}
  801cd2:	89 d8                	mov    %ebx,%eax
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5d                   	pop    %ebp
  801cda:	c3                   	ret    

00801cdb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	53                   	push   %ebx
  801cdf:	83 ec 14             	sub    $0x14,%esp
  801ce2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ced:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cf3:	7e 24                	jle    801d19 <nsipc_send+0x3e>
  801cf5:	c7 44 24 0c 52 2b 80 	movl   $0x802b52,0xc(%esp)
  801cfc:	00 
  801cfd:	c7 44 24 08 e0 2a 80 	movl   $0x802ae0,0x8(%esp)
  801d04:	00 
  801d05:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801d0c:	00 
  801d0d:	c7 04 24 46 2b 80 00 	movl   $0x802b46,(%esp)
  801d14:	e8 8d 05 00 00       	call   8022a6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d24:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801d2b:	e8 44 ec ff ff       	call   800974 <memmove>
	nsipcbuf.send.req_size = size;
  801d30:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d36:	8b 45 14             	mov    0x14(%ebp),%eax
  801d39:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d3e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d43:	e8 7b fd ff ff       	call   801ac3 <nsipc>
}
  801d48:	83 c4 14             	add    $0x14,%esp
  801d4b:	5b                   	pop    %ebx
  801d4c:	5d                   	pop    %ebp
  801d4d:	c3                   	ret    

00801d4e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d64:	8b 45 10             	mov    0x10(%ebp),%eax
  801d67:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d6c:	b8 09 00 00 00       	mov    $0x9,%eax
  801d71:	e8 4d fd ff ff       	call   801ac3 <nsipc>
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	56                   	push   %esi
  801d7c:	53                   	push   %ebx
  801d7d:	83 ec 10             	sub    $0x10,%esp
  801d80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	89 04 24             	mov    %eax,(%esp)
  801d89:	e8 d2 f1 ff ff       	call   800f60 <fd2data>
  801d8e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d90:	c7 44 24 04 5e 2b 80 	movl   $0x802b5e,0x4(%esp)
  801d97:	00 
  801d98:	89 1c 24             	mov    %ebx,(%esp)
  801d9b:	e8 37 ea ff ff       	call   8007d7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801da0:	8b 46 04             	mov    0x4(%esi),%eax
  801da3:	2b 06                	sub    (%esi),%eax
  801da5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801db2:	00 00 00 
	stat->st_dev = &devpipe;
  801db5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dbc:	30 80 00 
	return 0;
}
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	53                   	push   %ebx
  801dcf:	83 ec 14             	sub    $0x14,%esp
  801dd2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dd5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801de0:	e8 07 ef ff ff       	call   800cec <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801de5:	89 1c 24             	mov    %ebx,(%esp)
  801de8:	e8 73 f1 ff ff       	call   800f60 <fd2data>
  801ded:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df8:	e8 ef ee ff ff       	call   800cec <sys_page_unmap>
}
  801dfd:	83 c4 14             	add    $0x14,%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5d                   	pop    %ebp
  801e02:	c3                   	ret    

00801e03 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	57                   	push   %edi
  801e07:	56                   	push   %esi
  801e08:	53                   	push   %ebx
  801e09:	83 ec 2c             	sub    $0x2c,%esp
  801e0c:	89 c6                	mov    %eax,%esi
  801e0e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e11:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801e16:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e19:	89 34 24             	mov    %esi,(%esp)
  801e1c:	e8 e6 05 00 00       	call   802407 <pageref>
  801e21:	89 c7                	mov    %eax,%edi
  801e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e26:	89 04 24             	mov    %eax,(%esp)
  801e29:	e8 d9 05 00 00       	call   802407 <pageref>
  801e2e:	39 c7                	cmp    %eax,%edi
  801e30:	0f 94 c2             	sete   %dl
  801e33:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e36:	8b 0d 0c 40 80 00    	mov    0x80400c,%ecx
  801e3c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e3f:	39 fb                	cmp    %edi,%ebx
  801e41:	74 21                	je     801e64 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e43:	84 d2                	test   %dl,%dl
  801e45:	74 ca                	je     801e11 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e47:	8b 51 58             	mov    0x58(%ecx),%edx
  801e4a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e4e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e52:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e56:	c7 04 24 65 2b 80 00 	movl   $0x802b65,(%esp)
  801e5d:	e8 04 e3 ff ff       	call   800166 <cprintf>
  801e62:	eb ad                	jmp    801e11 <_pipeisclosed+0xe>
	}
}
  801e64:	83 c4 2c             	add    $0x2c,%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5f                   	pop    %edi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    

00801e6c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	57                   	push   %edi
  801e70:	56                   	push   %esi
  801e71:	53                   	push   %ebx
  801e72:	83 ec 1c             	sub    $0x1c,%esp
  801e75:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e78:	89 34 24             	mov    %esi,(%esp)
  801e7b:	e8 e0 f0 ff ff       	call   800f60 <fd2data>
  801e80:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e82:	bf 00 00 00 00       	mov    $0x0,%edi
  801e87:	eb 45                	jmp    801ece <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e89:	89 da                	mov    %ebx,%edx
  801e8b:	89 f0                	mov    %esi,%eax
  801e8d:	e8 71 ff ff ff       	call   801e03 <_pipeisclosed>
  801e92:	85 c0                	test   %eax,%eax
  801e94:	75 41                	jne    801ed7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e96:	e8 8b ed ff ff       	call   800c26 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e9b:	8b 43 04             	mov    0x4(%ebx),%eax
  801e9e:	8b 0b                	mov    (%ebx),%ecx
  801ea0:	8d 51 20             	lea    0x20(%ecx),%edx
  801ea3:	39 d0                	cmp    %edx,%eax
  801ea5:	73 e2                	jae    801e89 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eaa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801eb1:	99                   	cltd   
  801eb2:	c1 ea 1b             	shr    $0x1b,%edx
  801eb5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801eb8:	83 e1 1f             	and    $0x1f,%ecx
  801ebb:	29 d1                	sub    %edx,%ecx
  801ebd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801ec1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ec5:	83 c0 01             	add    $0x1,%eax
  801ec8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ecb:	83 c7 01             	add    $0x1,%edi
  801ece:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ed1:	75 c8                	jne    801e9b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801ed3:	89 f8                	mov    %edi,%eax
  801ed5:	eb 05                	jmp    801edc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801edc:	83 c4 1c             	add    $0x1c,%esp
  801edf:	5b                   	pop    %ebx
  801ee0:	5e                   	pop    %esi
  801ee1:	5f                   	pop    %edi
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    

00801ee4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	57                   	push   %edi
  801ee8:	56                   	push   %esi
  801ee9:	53                   	push   %ebx
  801eea:	83 ec 1c             	sub    $0x1c,%esp
  801eed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ef0:	89 3c 24             	mov    %edi,(%esp)
  801ef3:	e8 68 f0 ff ff       	call   800f60 <fd2data>
  801ef8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801efa:	be 00 00 00 00       	mov    $0x0,%esi
  801eff:	eb 3d                	jmp    801f3e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f01:	85 f6                	test   %esi,%esi
  801f03:	74 04                	je     801f09 <devpipe_read+0x25>
				return i;
  801f05:	89 f0                	mov    %esi,%eax
  801f07:	eb 43                	jmp    801f4c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f09:	89 da                	mov    %ebx,%edx
  801f0b:	89 f8                	mov    %edi,%eax
  801f0d:	e8 f1 fe ff ff       	call   801e03 <_pipeisclosed>
  801f12:	85 c0                	test   %eax,%eax
  801f14:	75 31                	jne    801f47 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f16:	e8 0b ed ff ff       	call   800c26 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f1b:	8b 03                	mov    (%ebx),%eax
  801f1d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f20:	74 df                	je     801f01 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f22:	99                   	cltd   
  801f23:	c1 ea 1b             	shr    $0x1b,%edx
  801f26:	01 d0                	add    %edx,%eax
  801f28:	83 e0 1f             	and    $0x1f,%eax
  801f2b:	29 d0                	sub    %edx,%eax
  801f2d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f35:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f38:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f3b:	83 c6 01             	add    $0x1,%esi
  801f3e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f41:	75 d8                	jne    801f1b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f43:	89 f0                	mov    %esi,%eax
  801f45:	eb 05                	jmp    801f4c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f4c:	83 c4 1c             	add    $0x1c,%esp
  801f4f:	5b                   	pop    %ebx
  801f50:	5e                   	pop    %esi
  801f51:	5f                   	pop    %edi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    

00801f54 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	56                   	push   %esi
  801f58:	53                   	push   %ebx
  801f59:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5f:	89 04 24             	mov    %eax,(%esp)
  801f62:	e8 10 f0 ff ff       	call   800f77 <fd_alloc>
  801f67:	89 c2                	mov    %eax,%edx
  801f69:	85 d2                	test   %edx,%edx
  801f6b:	0f 88 4d 01 00 00    	js     8020be <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f71:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f78:	00 
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f87:	e8 b9 ec ff ff       	call   800c45 <sys_page_alloc>
  801f8c:	89 c2                	mov    %eax,%edx
  801f8e:	85 d2                	test   %edx,%edx
  801f90:	0f 88 28 01 00 00    	js     8020be <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f99:	89 04 24             	mov    %eax,(%esp)
  801f9c:	e8 d6 ef ff ff       	call   800f77 <fd_alloc>
  801fa1:	89 c3                	mov    %eax,%ebx
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	0f 88 fe 00 00 00    	js     8020a9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fb2:	00 
  801fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc1:	e8 7f ec ff ff       	call   800c45 <sys_page_alloc>
  801fc6:	89 c3                	mov    %eax,%ebx
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	0f 88 d9 00 00 00    	js     8020a9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd3:	89 04 24             	mov    %eax,(%esp)
  801fd6:	e8 85 ef ff ff       	call   800f60 <fd2data>
  801fdb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fdd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fe4:	00 
  801fe5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff0:	e8 50 ec ff ff       	call   800c45 <sys_page_alloc>
  801ff5:	89 c3                	mov    %eax,%ebx
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	0f 88 97 00 00 00    	js     802096 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802002:	89 04 24             	mov    %eax,(%esp)
  802005:	e8 56 ef ff ff       	call   800f60 <fd2data>
  80200a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802011:	00 
  802012:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802016:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80201d:	00 
  80201e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802022:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802029:	e8 6b ec ff ff       	call   800c99 <sys_page_map>
  80202e:	89 c3                	mov    %eax,%ebx
  802030:	85 c0                	test   %eax,%eax
  802032:	78 52                	js     802086 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802034:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80203a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802049:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80204f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802052:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802057:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	89 04 24             	mov    %eax,(%esp)
  802064:	e8 e7 ee ff ff       	call   800f50 <fd2num>
  802069:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80206e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802071:	89 04 24             	mov    %eax,(%esp)
  802074:	e8 d7 ee ff ff       	call   800f50 <fd2num>
  802079:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80207c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	eb 38                	jmp    8020be <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802086:	89 74 24 04          	mov    %esi,0x4(%esp)
  80208a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802091:	e8 56 ec ff ff       	call   800cec <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802099:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a4:	e8 43 ec ff ff       	call   800cec <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b7:	e8 30 ec ff ff       	call   800cec <sys_page_unmap>
  8020bc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8020be:	83 c4 30             	add    $0x30,%esp
  8020c1:	5b                   	pop    %ebx
  8020c2:	5e                   	pop    %esi
  8020c3:	5d                   	pop    %ebp
  8020c4:	c3                   	ret    

008020c5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	89 04 24             	mov    %eax,(%esp)
  8020d8:	e8 e9 ee ff ff       	call   800fc6 <fd_lookup>
  8020dd:	89 c2                	mov    %eax,%edx
  8020df:	85 d2                	test   %edx,%edx
  8020e1:	78 15                	js     8020f8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	89 04 24             	mov    %eax,(%esp)
  8020e9:	e8 72 ee ff ff       	call   800f60 <fd2data>
	return _pipeisclosed(fd, p);
  8020ee:	89 c2                	mov    %eax,%edx
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	e8 0b fd ff ff       	call   801e03 <_pipeisclosed>
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    
  8020fa:	66 90                	xchg   %ax,%ax
  8020fc:	66 90                	xchg   %ax,%ax
  8020fe:	66 90                	xchg   %ax,%ax

00802100 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
  802108:	5d                   	pop    %ebp
  802109:	c3                   	ret    

0080210a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802110:	c7 44 24 04 7d 2b 80 	movl   $0x802b7d,0x4(%esp)
  802117:	00 
  802118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211b:	89 04 24             	mov    %eax,(%esp)
  80211e:	e8 b4 e6 ff ff       	call   8007d7 <strcpy>
	return 0;
}
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	57                   	push   %edi
  80212e:	56                   	push   %esi
  80212f:	53                   	push   %ebx
  802130:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802136:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80213b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802141:	eb 31                	jmp    802174 <devcons_write+0x4a>
		m = n - tot;
  802143:	8b 75 10             	mov    0x10(%ebp),%esi
  802146:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802148:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80214b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802150:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802153:	89 74 24 08          	mov    %esi,0x8(%esp)
  802157:	03 45 0c             	add    0xc(%ebp),%eax
  80215a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215e:	89 3c 24             	mov    %edi,(%esp)
  802161:	e8 0e e8 ff ff       	call   800974 <memmove>
		sys_cputs(buf, m);
  802166:	89 74 24 04          	mov    %esi,0x4(%esp)
  80216a:	89 3c 24             	mov    %edi,(%esp)
  80216d:	e8 b4 e9 ff ff       	call   800b26 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802172:	01 f3                	add    %esi,%ebx
  802174:	89 d8                	mov    %ebx,%eax
  802176:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802179:	72 c8                	jb     802143 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80217b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802181:	5b                   	pop    %ebx
  802182:	5e                   	pop    %esi
  802183:	5f                   	pop    %edi
  802184:	5d                   	pop    %ebp
  802185:	c3                   	ret    

00802186 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80218c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802191:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802195:	75 07                	jne    80219e <devcons_read+0x18>
  802197:	eb 2a                	jmp    8021c3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802199:	e8 88 ea ff ff       	call   800c26 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80219e:	66 90                	xchg   %ax,%ax
  8021a0:	e8 9f e9 ff ff       	call   800b44 <sys_cgetc>
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	74 f0                	je     802199 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	78 16                	js     8021c3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8021ad:	83 f8 04             	cmp    $0x4,%eax
  8021b0:	74 0c                	je     8021be <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8021b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b5:	88 02                	mov    %al,(%edx)
	return 1;
  8021b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021bc:	eb 05                	jmp    8021c3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8021be:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021d8:	00 
  8021d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021dc:	89 04 24             	mov    %eax,(%esp)
  8021df:	e8 42 e9 ff ff       	call   800b26 <sys_cputs>
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <getchar>:

int
getchar(void)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8021ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8021f3:	00 
  8021f4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802202:	e8 53 f0 ff ff       	call   80125a <read>
	if (r < 0)
  802207:	85 c0                	test   %eax,%eax
  802209:	78 0f                	js     80221a <getchar+0x34>
		return r;
	if (r < 1)
  80220b:	85 c0                	test   %eax,%eax
  80220d:	7e 06                	jle    802215 <getchar+0x2f>
		return -E_EOF;
	return c;
  80220f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802213:	eb 05                	jmp    80221a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802215:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802222:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802225:	89 44 24 04          	mov    %eax,0x4(%esp)
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	89 04 24             	mov    %eax,(%esp)
  80222f:	e8 92 ed ff ff       	call   800fc6 <fd_lookup>
  802234:	85 c0                	test   %eax,%eax
  802236:	78 11                	js     802249 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802241:	39 10                	cmp    %edx,(%eax)
  802243:	0f 94 c0             	sete   %al
  802246:	0f b6 c0             	movzbl %al,%eax
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <opencons>:

int
opencons(void)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802251:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802254:	89 04 24             	mov    %eax,(%esp)
  802257:	e8 1b ed ff ff       	call   800f77 <fd_alloc>
		return r;
  80225c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80225e:	85 c0                	test   %eax,%eax
  802260:	78 40                	js     8022a2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802262:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802269:	00 
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802271:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802278:	e8 c8 e9 ff ff       	call   800c45 <sys_page_alloc>
		return r;
  80227d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80227f:	85 c0                	test   %eax,%eax
  802281:	78 1f                	js     8022a2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802283:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802298:	89 04 24             	mov    %eax,(%esp)
  80229b:	e8 b0 ec ff ff       	call   800f50 <fd2num>
  8022a0:	89 c2                	mov    %eax,%edx
}
  8022a2:	89 d0                	mov    %edx,%eax
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	56                   	push   %esi
  8022aa:	53                   	push   %ebx
  8022ab:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8022ae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022b1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8022b7:	e8 4b e9 ff ff       	call   800c07 <sys_getenvid>
  8022bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bf:	89 54 24 10          	mov    %edx,0x10(%esp)
  8022c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022ca:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d2:	c7 04 24 8c 2b 80 00 	movl   $0x802b8c,(%esp)
  8022d9:	e8 88 de ff ff       	call   800166 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e5:	89 04 24             	mov    %eax,(%esp)
  8022e8:	e8 18 de ff ff       	call   800105 <vcprintf>
	cprintf("\n");
  8022ed:	c7 04 24 ec 26 80 00 	movl   $0x8026ec,(%esp)
  8022f4:	e8 6d de ff ff       	call   800166 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022f9:	cc                   	int3   
  8022fa:	eb fd                	jmp    8022f9 <_panic+0x53>
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	56                   	push   %esi
  802304:	53                   	push   %ebx
  802305:	83 ec 10             	sub    $0x10,%esp
  802308:	8b 75 08             	mov    0x8(%ebp),%esi
  80230b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802311:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802313:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802318:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80231b:	89 04 24             	mov    %eax,(%esp)
  80231e:	e8 58 eb ff ff       	call   800e7b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802323:	85 c0                	test   %eax,%eax
  802325:	75 26                	jne    80234d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802327:	85 f6                	test   %esi,%esi
  802329:	74 0a                	je     802335 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80232b:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802330:	8b 40 74             	mov    0x74(%eax),%eax
  802333:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802335:	85 db                	test   %ebx,%ebx
  802337:	74 0a                	je     802343 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802339:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80233e:	8b 40 78             	mov    0x78(%eax),%eax
  802341:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802343:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802348:	8b 40 70             	mov    0x70(%eax),%eax
  80234b:	eb 14                	jmp    802361 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80234d:	85 f6                	test   %esi,%esi
  80234f:	74 06                	je     802357 <ipc_recv+0x57>
			*from_env_store = 0;
  802351:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802357:	85 db                	test   %ebx,%ebx
  802359:	74 06                	je     802361 <ipc_recv+0x61>
			*perm_store = 0;
  80235b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802361:	83 c4 10             	add    $0x10,%esp
  802364:	5b                   	pop    %ebx
  802365:	5e                   	pop    %esi
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    

00802368 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	57                   	push   %edi
  80236c:	56                   	push   %esi
  80236d:	53                   	push   %ebx
  80236e:	83 ec 1c             	sub    $0x1c,%esp
  802371:	8b 7d 08             	mov    0x8(%ebp),%edi
  802374:	8b 75 0c             	mov    0xc(%ebp),%esi
  802377:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80237a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80237c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802381:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802384:	8b 45 14             	mov    0x14(%ebp),%eax
  802387:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80238b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80238f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802393:	89 3c 24             	mov    %edi,(%esp)
  802396:	e8 bd ea ff ff       	call   800e58 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80239b:	85 c0                	test   %eax,%eax
  80239d:	74 28                	je     8023c7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80239f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023a2:	74 1c                	je     8023c0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  8023a4:	c7 44 24 08 b0 2b 80 	movl   $0x802bb0,0x8(%esp)
  8023ab:	00 
  8023ac:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8023b3:	00 
  8023b4:	c7 04 24 d4 2b 80 00 	movl   $0x802bd4,(%esp)
  8023bb:	e8 e6 fe ff ff       	call   8022a6 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8023c0:	e8 61 e8 ff ff       	call   800c26 <sys_yield>
	}
  8023c5:	eb bd                	jmp    802384 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8023c7:	83 c4 1c             	add    $0x1c,%esp
  8023ca:	5b                   	pop    %ebx
  8023cb:	5e                   	pop    %esi
  8023cc:	5f                   	pop    %edi
  8023cd:	5d                   	pop    %ebp
  8023ce:	c3                   	ret    

008023cf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023da:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023dd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023e3:	8b 52 50             	mov    0x50(%edx),%edx
  8023e6:	39 ca                	cmp    %ecx,%edx
  8023e8:	75 0d                	jne    8023f7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8023ea:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023ed:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8023f2:	8b 40 40             	mov    0x40(%eax),%eax
  8023f5:	eb 0e                	jmp    802405 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023f7:	83 c0 01             	add    $0x1,%eax
  8023fa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023ff:	75 d9                	jne    8023da <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802401:	66 b8 00 00          	mov    $0x0,%ax
}
  802405:	5d                   	pop    %ebp
  802406:	c3                   	ret    

00802407 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80240d:	89 d0                	mov    %edx,%eax
  80240f:	c1 e8 16             	shr    $0x16,%eax
  802412:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802419:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80241e:	f6 c1 01             	test   $0x1,%cl
  802421:	74 1d                	je     802440 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802423:	c1 ea 0c             	shr    $0xc,%edx
  802426:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80242d:	f6 c2 01             	test   $0x1,%dl
  802430:	74 0e                	je     802440 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802432:	c1 ea 0c             	shr    $0xc,%edx
  802435:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80243c:	ef 
  80243d:	0f b7 c0             	movzwl %ax,%eax
}
  802440:	5d                   	pop    %ebp
  802441:	c3                   	ret    
  802442:	66 90                	xchg   %ax,%ax
  802444:	66 90                	xchg   %ax,%ax
  802446:	66 90                	xchg   %ax,%ax
  802448:	66 90                	xchg   %ax,%ax
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	66 90                	xchg   %ax,%ax
  80244e:	66 90                	xchg   %ax,%ax

00802450 <__udivdi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	8b 44 24 28          	mov    0x28(%esp),%eax
  80245a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80245e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802462:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802466:	85 c0                	test   %eax,%eax
  802468:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80246c:	89 ea                	mov    %ebp,%edx
  80246e:	89 0c 24             	mov    %ecx,(%esp)
  802471:	75 2d                	jne    8024a0 <__udivdi3+0x50>
  802473:	39 e9                	cmp    %ebp,%ecx
  802475:	77 61                	ja     8024d8 <__udivdi3+0x88>
  802477:	85 c9                	test   %ecx,%ecx
  802479:	89 ce                	mov    %ecx,%esi
  80247b:	75 0b                	jne    802488 <__udivdi3+0x38>
  80247d:	b8 01 00 00 00       	mov    $0x1,%eax
  802482:	31 d2                	xor    %edx,%edx
  802484:	f7 f1                	div    %ecx
  802486:	89 c6                	mov    %eax,%esi
  802488:	31 d2                	xor    %edx,%edx
  80248a:	89 e8                	mov    %ebp,%eax
  80248c:	f7 f6                	div    %esi
  80248e:	89 c5                	mov    %eax,%ebp
  802490:	89 f8                	mov    %edi,%eax
  802492:	f7 f6                	div    %esi
  802494:	89 ea                	mov    %ebp,%edx
  802496:	83 c4 0c             	add    $0xc,%esp
  802499:	5e                   	pop    %esi
  80249a:	5f                   	pop    %edi
  80249b:	5d                   	pop    %ebp
  80249c:	c3                   	ret    
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	39 e8                	cmp    %ebp,%eax
  8024a2:	77 24                	ja     8024c8 <__udivdi3+0x78>
  8024a4:	0f bd e8             	bsr    %eax,%ebp
  8024a7:	83 f5 1f             	xor    $0x1f,%ebp
  8024aa:	75 3c                	jne    8024e8 <__udivdi3+0x98>
  8024ac:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024b0:	39 34 24             	cmp    %esi,(%esp)
  8024b3:	0f 86 9f 00 00 00    	jbe    802558 <__udivdi3+0x108>
  8024b9:	39 d0                	cmp    %edx,%eax
  8024bb:	0f 82 97 00 00 00    	jb     802558 <__udivdi3+0x108>
  8024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	31 d2                	xor    %edx,%edx
  8024ca:	31 c0                	xor    %eax,%eax
  8024cc:	83 c4 0c             	add    $0xc,%esp
  8024cf:	5e                   	pop    %esi
  8024d0:	5f                   	pop    %edi
  8024d1:	5d                   	pop    %ebp
  8024d2:	c3                   	ret    
  8024d3:	90                   	nop
  8024d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024d8:	89 f8                	mov    %edi,%eax
  8024da:	f7 f1                	div    %ecx
  8024dc:	31 d2                	xor    %edx,%edx
  8024de:	83 c4 0c             	add    $0xc,%esp
  8024e1:	5e                   	pop    %esi
  8024e2:	5f                   	pop    %edi
  8024e3:	5d                   	pop    %ebp
  8024e4:	c3                   	ret    
  8024e5:	8d 76 00             	lea    0x0(%esi),%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	8b 3c 24             	mov    (%esp),%edi
  8024ed:	d3 e0                	shl    %cl,%eax
  8024ef:	89 c6                	mov    %eax,%esi
  8024f1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024f6:	29 e8                	sub    %ebp,%eax
  8024f8:	89 c1                	mov    %eax,%ecx
  8024fa:	d3 ef                	shr    %cl,%edi
  8024fc:	89 e9                	mov    %ebp,%ecx
  8024fe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802502:	8b 3c 24             	mov    (%esp),%edi
  802505:	09 74 24 08          	or     %esi,0x8(%esp)
  802509:	89 d6                	mov    %edx,%esi
  80250b:	d3 e7                	shl    %cl,%edi
  80250d:	89 c1                	mov    %eax,%ecx
  80250f:	89 3c 24             	mov    %edi,(%esp)
  802512:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802516:	d3 ee                	shr    %cl,%esi
  802518:	89 e9                	mov    %ebp,%ecx
  80251a:	d3 e2                	shl    %cl,%edx
  80251c:	89 c1                	mov    %eax,%ecx
  80251e:	d3 ef                	shr    %cl,%edi
  802520:	09 d7                	or     %edx,%edi
  802522:	89 f2                	mov    %esi,%edx
  802524:	89 f8                	mov    %edi,%eax
  802526:	f7 74 24 08          	divl   0x8(%esp)
  80252a:	89 d6                	mov    %edx,%esi
  80252c:	89 c7                	mov    %eax,%edi
  80252e:	f7 24 24             	mull   (%esp)
  802531:	39 d6                	cmp    %edx,%esi
  802533:	89 14 24             	mov    %edx,(%esp)
  802536:	72 30                	jb     802568 <__udivdi3+0x118>
  802538:	8b 54 24 04          	mov    0x4(%esp),%edx
  80253c:	89 e9                	mov    %ebp,%ecx
  80253e:	d3 e2                	shl    %cl,%edx
  802540:	39 c2                	cmp    %eax,%edx
  802542:	73 05                	jae    802549 <__udivdi3+0xf9>
  802544:	3b 34 24             	cmp    (%esp),%esi
  802547:	74 1f                	je     802568 <__udivdi3+0x118>
  802549:	89 f8                	mov    %edi,%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	e9 7a ff ff ff       	jmp    8024cc <__udivdi3+0x7c>
  802552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802558:	31 d2                	xor    %edx,%edx
  80255a:	b8 01 00 00 00       	mov    $0x1,%eax
  80255f:	e9 68 ff ff ff       	jmp    8024cc <__udivdi3+0x7c>
  802564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802568:	8d 47 ff             	lea    -0x1(%edi),%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	83 c4 0c             	add    $0xc,%esp
  802570:	5e                   	pop    %esi
  802571:	5f                   	pop    %edi
  802572:	5d                   	pop    %ebp
  802573:	c3                   	ret    
  802574:	66 90                	xchg   %ax,%ax
  802576:	66 90                	xchg   %ax,%ax
  802578:	66 90                	xchg   %ax,%ax
  80257a:	66 90                	xchg   %ax,%ax
  80257c:	66 90                	xchg   %ax,%ax
  80257e:	66 90                	xchg   %ax,%ax

00802580 <__umoddi3>:
  802580:	55                   	push   %ebp
  802581:	57                   	push   %edi
  802582:	56                   	push   %esi
  802583:	83 ec 14             	sub    $0x14,%esp
  802586:	8b 44 24 28          	mov    0x28(%esp),%eax
  80258a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80258e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802592:	89 c7                	mov    %eax,%edi
  802594:	89 44 24 04          	mov    %eax,0x4(%esp)
  802598:	8b 44 24 30          	mov    0x30(%esp),%eax
  80259c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025a0:	89 34 24             	mov    %esi,(%esp)
  8025a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	89 c2                	mov    %eax,%edx
  8025ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025af:	75 17                	jne    8025c8 <__umoddi3+0x48>
  8025b1:	39 fe                	cmp    %edi,%esi
  8025b3:	76 4b                	jbe    802600 <__umoddi3+0x80>
  8025b5:	89 c8                	mov    %ecx,%eax
  8025b7:	89 fa                	mov    %edi,%edx
  8025b9:	f7 f6                	div    %esi
  8025bb:	89 d0                	mov    %edx,%eax
  8025bd:	31 d2                	xor    %edx,%edx
  8025bf:	83 c4 14             	add    $0x14,%esp
  8025c2:	5e                   	pop    %esi
  8025c3:	5f                   	pop    %edi
  8025c4:	5d                   	pop    %ebp
  8025c5:	c3                   	ret    
  8025c6:	66 90                	xchg   %ax,%ax
  8025c8:	39 f8                	cmp    %edi,%eax
  8025ca:	77 54                	ja     802620 <__umoddi3+0xa0>
  8025cc:	0f bd e8             	bsr    %eax,%ebp
  8025cf:	83 f5 1f             	xor    $0x1f,%ebp
  8025d2:	75 5c                	jne    802630 <__umoddi3+0xb0>
  8025d4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025d8:	39 3c 24             	cmp    %edi,(%esp)
  8025db:	0f 87 e7 00 00 00    	ja     8026c8 <__umoddi3+0x148>
  8025e1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025e5:	29 f1                	sub    %esi,%ecx
  8025e7:	19 c7                	sbb    %eax,%edi
  8025e9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025f1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025f5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025f9:	83 c4 14             	add    $0x14,%esp
  8025fc:	5e                   	pop    %esi
  8025fd:	5f                   	pop    %edi
  8025fe:	5d                   	pop    %ebp
  8025ff:	c3                   	ret    
  802600:	85 f6                	test   %esi,%esi
  802602:	89 f5                	mov    %esi,%ebp
  802604:	75 0b                	jne    802611 <__umoddi3+0x91>
  802606:	b8 01 00 00 00       	mov    $0x1,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	f7 f6                	div    %esi
  80260f:	89 c5                	mov    %eax,%ebp
  802611:	8b 44 24 04          	mov    0x4(%esp),%eax
  802615:	31 d2                	xor    %edx,%edx
  802617:	f7 f5                	div    %ebp
  802619:	89 c8                	mov    %ecx,%eax
  80261b:	f7 f5                	div    %ebp
  80261d:	eb 9c                	jmp    8025bb <__umoddi3+0x3b>
  80261f:	90                   	nop
  802620:	89 c8                	mov    %ecx,%eax
  802622:	89 fa                	mov    %edi,%edx
  802624:	83 c4 14             	add    $0x14,%esp
  802627:	5e                   	pop    %esi
  802628:	5f                   	pop    %edi
  802629:	5d                   	pop    %ebp
  80262a:	c3                   	ret    
  80262b:	90                   	nop
  80262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802630:	8b 04 24             	mov    (%esp),%eax
  802633:	be 20 00 00 00       	mov    $0x20,%esi
  802638:	89 e9                	mov    %ebp,%ecx
  80263a:	29 ee                	sub    %ebp,%esi
  80263c:	d3 e2                	shl    %cl,%edx
  80263e:	89 f1                	mov    %esi,%ecx
  802640:	d3 e8                	shr    %cl,%eax
  802642:	89 e9                	mov    %ebp,%ecx
  802644:	89 44 24 04          	mov    %eax,0x4(%esp)
  802648:	8b 04 24             	mov    (%esp),%eax
  80264b:	09 54 24 04          	or     %edx,0x4(%esp)
  80264f:	89 fa                	mov    %edi,%edx
  802651:	d3 e0                	shl    %cl,%eax
  802653:	89 f1                	mov    %esi,%ecx
  802655:	89 44 24 08          	mov    %eax,0x8(%esp)
  802659:	8b 44 24 10          	mov    0x10(%esp),%eax
  80265d:	d3 ea                	shr    %cl,%edx
  80265f:	89 e9                	mov    %ebp,%ecx
  802661:	d3 e7                	shl    %cl,%edi
  802663:	89 f1                	mov    %esi,%ecx
  802665:	d3 e8                	shr    %cl,%eax
  802667:	89 e9                	mov    %ebp,%ecx
  802669:	09 f8                	or     %edi,%eax
  80266b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80266f:	f7 74 24 04          	divl   0x4(%esp)
  802673:	d3 e7                	shl    %cl,%edi
  802675:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802679:	89 d7                	mov    %edx,%edi
  80267b:	f7 64 24 08          	mull   0x8(%esp)
  80267f:	39 d7                	cmp    %edx,%edi
  802681:	89 c1                	mov    %eax,%ecx
  802683:	89 14 24             	mov    %edx,(%esp)
  802686:	72 2c                	jb     8026b4 <__umoddi3+0x134>
  802688:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80268c:	72 22                	jb     8026b0 <__umoddi3+0x130>
  80268e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802692:	29 c8                	sub    %ecx,%eax
  802694:	19 d7                	sbb    %edx,%edi
  802696:	89 e9                	mov    %ebp,%ecx
  802698:	89 fa                	mov    %edi,%edx
  80269a:	d3 e8                	shr    %cl,%eax
  80269c:	89 f1                	mov    %esi,%ecx
  80269e:	d3 e2                	shl    %cl,%edx
  8026a0:	89 e9                	mov    %ebp,%ecx
  8026a2:	d3 ef                	shr    %cl,%edi
  8026a4:	09 d0                	or     %edx,%eax
  8026a6:	89 fa                	mov    %edi,%edx
  8026a8:	83 c4 14             	add    $0x14,%esp
  8026ab:	5e                   	pop    %esi
  8026ac:	5f                   	pop    %edi
  8026ad:	5d                   	pop    %ebp
  8026ae:	c3                   	ret    
  8026af:	90                   	nop
  8026b0:	39 d7                	cmp    %edx,%edi
  8026b2:	75 da                	jne    80268e <__umoddi3+0x10e>
  8026b4:	8b 14 24             	mov    (%esp),%edx
  8026b7:	89 c1                	mov    %eax,%ecx
  8026b9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026bd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026c1:	eb cb                	jmp    80268e <__umoddi3+0x10e>
  8026c3:	90                   	nop
  8026c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026cc:	0f 82 0f ff ff ff    	jb     8025e1 <__umoddi3+0x61>
  8026d2:	e9 1a ff ff ff       	jmp    8025f1 <__umoddi3+0x71>
