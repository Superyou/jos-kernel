
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 1f 00 00 00       	call   800050 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800039:	a1 00 00 10 f0       	mov    0xf0100000,%eax
  80003e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800042:	c7 04 24 e0 26 80 00 	movl   $0x8026e0,(%esp)
  800049:	e8 06 01 00 00       	call   800154 <cprintf>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	56                   	push   %esi
  800054:	53                   	push   %ebx
  800055:	83 ec 10             	sub    $0x10,%esp
  800058:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  80005e:	e8 94 0b 00 00       	call   800bf7 <sys_getenvid>
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800075:	85 db                	test   %ebx,%ebx
  800077:	7e 07                	jle    800080 <libmain+0x30>
		binaryname = argv[0];
  800079:	8b 06                	mov    (%esi),%eax
  80007b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800080:	89 74 24 04          	mov    %esi,0x4(%esp)
  800084:	89 1c 24             	mov    %ebx,(%esp)
  800087:	e8 a7 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008c:	e8 07 00 00 00       	call   800098 <exit>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	5b                   	pop    %ebx
  800095:	5e                   	pop    %esi
  800096:	5d                   	pop    %ebp
  800097:	c3                   	ret    

00800098 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800098:	55                   	push   %ebp
  800099:	89 e5                	mov    %esp,%ebp
  80009b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80009e:	e8 77 10 00 00       	call   80111a <close_all>
	sys_env_destroy(0);
  8000a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000aa:	e8 a4 0a 00 00       	call   800b53 <sys_env_destroy>
}
  8000af:	c9                   	leave  
  8000b0:	c3                   	ret    

008000b1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b1:	55                   	push   %ebp
  8000b2:	89 e5                	mov    %esp,%ebp
  8000b4:	53                   	push   %ebx
  8000b5:	83 ec 14             	sub    $0x14,%esp
  8000b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000bb:	8b 13                	mov    (%ebx),%edx
  8000bd:	8d 42 01             	lea    0x1(%edx),%eax
  8000c0:	89 03                	mov    %eax,(%ebx)
  8000c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000ce:	75 19                	jne    8000e9 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8000d0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8000d7:	00 
  8000d8:	8d 43 08             	lea    0x8(%ebx),%eax
  8000db:	89 04 24             	mov    %eax,(%esp)
  8000de:	e8 33 0a 00 00       	call   800b16 <sys_cputs>
		b->idx = 0;
  8000e3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8000e9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000ed:	83 c4 14             	add    $0x14,%esp
  8000f0:	5b                   	pop    %ebx
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8000fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800103:	00 00 00 
	b.cnt = 0;
  800106:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80010d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800110:	8b 45 0c             	mov    0xc(%ebp),%eax
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	8b 45 08             	mov    0x8(%ebp),%eax
  80011a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	89 44 24 04          	mov    %eax,0x4(%esp)
  800128:	c7 04 24 b1 00 80 00 	movl   $0x8000b1,(%esp)
  80012f:	e8 70 01 00 00       	call   8002a4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800134:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80013a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800144:	89 04 24             	mov    %eax,(%esp)
  800147:	e8 ca 09 00 00       	call   800b16 <sys_cputs>

	return b.cnt;
}
  80014c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80015a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800161:	8b 45 08             	mov    0x8(%ebp),%eax
  800164:	89 04 24             	mov    %eax,(%esp)
  800167:	e8 87 ff ff ff       	call   8000f3 <vcprintf>
	va_end(ap);

	return cnt;
}
  80016c:	c9                   	leave  
  80016d:	c3                   	ret    
  80016e:	66 90                	xchg   %ax,%ax

00800170 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 3c             	sub    $0x3c,%esp
  800179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80017c:	89 d7                	mov    %edx,%edi
  80017e:	8b 45 08             	mov    0x8(%ebp),%eax
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800184:	8b 45 0c             	mov    0xc(%ebp),%eax
  800187:	89 c3                	mov    %eax,%ebx
  800189:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80018c:	8b 45 10             	mov    0x10(%ebp),%eax
  80018f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800192:	b9 00 00 00 00       	mov    $0x0,%ecx
  800197:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80019d:	39 d9                	cmp    %ebx,%ecx
  80019f:	72 05                	jb     8001a6 <printnum+0x36>
  8001a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001a4:	77 69                	ja     80020f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001ad:	83 ee 01             	sub    $0x1,%esi
  8001b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8001bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8001c0:	89 c3                	mov    %eax,%ebx
  8001c2:	89 d6                	mov    %edx,%esi
  8001c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8001ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001ce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8001d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001df:	e8 5c 22 00 00       	call   802440 <__udivdi3>
  8001e4:	89 d9                	mov    %ebx,%ecx
  8001e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8001ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001ee:	89 04 24             	mov    %eax,(%esp)
  8001f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001f5:	89 fa                	mov    %edi,%edx
  8001f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001fa:	e8 71 ff ff ff       	call   800170 <printnum>
  8001ff:	eb 1b                	jmp    80021c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800201:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800205:	8b 45 18             	mov    0x18(%ebp),%eax
  800208:	89 04 24             	mov    %eax,(%esp)
  80020b:	ff d3                	call   *%ebx
  80020d:	eb 03                	jmp    800212 <printnum+0xa2>
  80020f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800212:	83 ee 01             	sub    $0x1,%esi
  800215:	85 f6                	test   %esi,%esi
  800217:	7f e8                	jg     800201 <printnum+0x91>
  800219:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800220:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800224:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800227:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80022a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80022e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800232:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800235:	89 04 24             	mov    %eax,(%esp)
  800238:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023f:	e8 2c 23 00 00       	call   802570 <__umoddi3>
  800244:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800248:	0f be 80 11 27 80 00 	movsbl 0x802711(%eax),%eax
  80024f:	89 04 24             	mov    %eax,(%esp)
  800252:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800255:	ff d0                	call   *%eax
}
  800257:	83 c4 3c             	add    $0x3c,%esp
  80025a:	5b                   	pop    %ebx
  80025b:	5e                   	pop    %esi
  80025c:	5f                   	pop    %edi
  80025d:	5d                   	pop    %ebp
  80025e:	c3                   	ret    

0080025f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800265:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800269:	8b 10                	mov    (%eax),%edx
  80026b:	3b 50 04             	cmp    0x4(%eax),%edx
  80026e:	73 0a                	jae    80027a <sprintputch+0x1b>
		*b->buf++ = ch;
  800270:	8d 4a 01             	lea    0x1(%edx),%ecx
  800273:	89 08                	mov    %ecx,(%eax)
  800275:	8b 45 08             	mov    0x8(%ebp),%eax
  800278:	88 02                	mov    %al,(%edx)
}
  80027a:	5d                   	pop    %ebp
  80027b:	c3                   	ret    

0080027c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800282:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800285:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800289:	8b 45 10             	mov    0x10(%ebp),%eax
  80028c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800290:	8b 45 0c             	mov    0xc(%ebp),%eax
  800293:	89 44 24 04          	mov    %eax,0x4(%esp)
  800297:	8b 45 08             	mov    0x8(%ebp),%eax
  80029a:	89 04 24             	mov    %eax,(%esp)
  80029d:	e8 02 00 00 00       	call   8002a4 <vprintfmt>
	va_end(ap);
}
  8002a2:	c9                   	leave  
  8002a3:	c3                   	ret    

008002a4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	57                   	push   %edi
  8002a8:	56                   	push   %esi
  8002a9:	53                   	push   %ebx
  8002aa:	83 ec 3c             	sub    $0x3c,%esp
  8002ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002b0:	eb 17                	jmp    8002c9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8002b2:	85 c0                	test   %eax,%eax
  8002b4:	0f 84 4b 04 00 00    	je     800705 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8002ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002c1:	89 04 24             	mov    %eax,(%esp)
  8002c4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8002c7:	89 fb                	mov    %edi,%ebx
  8002c9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8002cc:	0f b6 03             	movzbl (%ebx),%eax
  8002cf:	83 f8 25             	cmp    $0x25,%eax
  8002d2:	75 de                	jne    8002b2 <vprintfmt+0xe>
  8002d4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8002d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002df:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8002e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8002eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f0:	eb 18                	jmp    80030a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8002f2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8002f4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8002f8:	eb 10                	jmp    80030a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8002fc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800300:	eb 08                	jmp    80030a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800302:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800305:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80030d:	0f b6 17             	movzbl (%edi),%edx
  800310:	0f b6 c2             	movzbl %dl,%eax
  800313:	83 ea 23             	sub    $0x23,%edx
  800316:	80 fa 55             	cmp    $0x55,%dl
  800319:	0f 87 c2 03 00 00    	ja     8006e1 <vprintfmt+0x43d>
  80031f:	0f b6 d2             	movzbl %dl,%edx
  800322:	ff 24 95 60 28 80 00 	jmp    *0x802860(,%edx,4)
  800329:	89 df                	mov    %ebx,%edi
  80032b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800330:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800333:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800337:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80033a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80033d:	83 fa 09             	cmp    $0x9,%edx
  800340:	77 33                	ja     800375 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800342:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800345:	eb e9                	jmp    800330 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800347:	8b 45 14             	mov    0x14(%ebp),%eax
  80034a:	8b 30                	mov    (%eax),%esi
  80034c:	8d 40 04             	lea    0x4(%eax),%eax
  80034f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800352:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800354:	eb 1f                	jmp    800375 <vprintfmt+0xd1>
  800356:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800359:	85 ff                	test   %edi,%edi
  80035b:	b8 00 00 00 00       	mov    $0x0,%eax
  800360:	0f 49 c7             	cmovns %edi,%eax
  800363:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800366:	89 df                	mov    %ebx,%edi
  800368:	eb a0                	jmp    80030a <vprintfmt+0x66>
  80036a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80036c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800373:	eb 95                	jmp    80030a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800375:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800379:	79 8f                	jns    80030a <vprintfmt+0x66>
  80037b:	eb 85                	jmp    800302 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80037d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800380:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800382:	eb 86                	jmp    80030a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800384:	8b 45 14             	mov    0x14(%ebp),%eax
  800387:	8d 70 04             	lea    0x4(%eax),%esi
  80038a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800391:	8b 45 14             	mov    0x14(%ebp),%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	89 04 24             	mov    %eax,(%esp)
  800399:	ff 55 08             	call   *0x8(%ebp)
  80039c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80039f:	e9 25 ff ff ff       	jmp    8002c9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a7:	8d 70 04             	lea    0x4(%eax),%esi
  8003aa:	8b 00                	mov    (%eax),%eax
  8003ac:	99                   	cltd   
  8003ad:	31 d0                	xor    %edx,%eax
  8003af:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003b1:	83 f8 15             	cmp    $0x15,%eax
  8003b4:	7f 0b                	jg     8003c1 <vprintfmt+0x11d>
  8003b6:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  8003bd:	85 d2                	test   %edx,%edx
  8003bf:	75 26                	jne    8003e7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8003c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003c5:	c7 44 24 08 29 27 80 	movl   $0x802729,0x8(%esp)
  8003cc:	00 
  8003cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	89 04 24             	mov    %eax,(%esp)
  8003da:	e8 9d fe ff ff       	call   80027c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003df:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8003e2:	e9 e2 fe ff ff       	jmp    8002c9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8003e7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003eb:	c7 44 24 08 12 2b 80 	movl   $0x802b12,0x8(%esp)
  8003f2:	00 
  8003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	89 04 24             	mov    %eax,(%esp)
  800400:	e8 77 fe ff ff       	call   80027c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800405:	89 75 14             	mov    %esi,0x14(%ebp)
  800408:	e9 bc fe ff ff       	jmp    8002c9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800413:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800416:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80041a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80041c:	85 ff                	test   %edi,%edi
  80041e:	b8 22 27 80 00       	mov    $0x802722,%eax
  800423:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800426:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80042a:	0f 84 94 00 00 00    	je     8004c4 <vprintfmt+0x220>
  800430:	85 c9                	test   %ecx,%ecx
  800432:	0f 8e 94 00 00 00    	jle    8004cc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800438:	89 74 24 04          	mov    %esi,0x4(%esp)
  80043c:	89 3c 24             	mov    %edi,(%esp)
  80043f:	e8 64 03 00 00       	call   8007a8 <strnlen>
  800444:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800447:	29 c1                	sub    %eax,%ecx
  800449:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80044c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800450:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800453:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800456:	8b 75 08             	mov    0x8(%ebp),%esi
  800459:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80045c:	89 cb                	mov    %ecx,%ebx
  80045e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800460:	eb 0f                	jmp    800471 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800462:	8b 45 0c             	mov    0xc(%ebp),%eax
  800465:	89 44 24 04          	mov    %eax,0x4(%esp)
  800469:	89 3c 24             	mov    %edi,(%esp)
  80046c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80046e:	83 eb 01             	sub    $0x1,%ebx
  800471:	85 db                	test   %ebx,%ebx
  800473:	7f ed                	jg     800462 <vprintfmt+0x1be>
  800475:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800478:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80047b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80047e:	85 c9                	test   %ecx,%ecx
  800480:	b8 00 00 00 00       	mov    $0x0,%eax
  800485:	0f 49 c1             	cmovns %ecx,%eax
  800488:	29 c1                	sub    %eax,%ecx
  80048a:	89 cb                	mov    %ecx,%ebx
  80048c:	eb 44                	jmp    8004d2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80048e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800492:	74 1e                	je     8004b2 <vprintfmt+0x20e>
  800494:	0f be d2             	movsbl %dl,%edx
  800497:	83 ea 20             	sub    $0x20,%edx
  80049a:	83 fa 5e             	cmp    $0x5e,%edx
  80049d:	76 13                	jbe    8004b2 <vprintfmt+0x20e>
					putch('?', putdat);
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8004ad:	ff 55 08             	call   *0x8(%ebp)
  8004b0:	eb 0d                	jmp    8004bf <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8004b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004b5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004b9:	89 04 24             	mov    %eax,(%esp)
  8004bc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004bf:	83 eb 01             	sub    $0x1,%ebx
  8004c2:	eb 0e                	jmp    8004d2 <vprintfmt+0x22e>
  8004c4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004c7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004ca:	eb 06                	jmp    8004d2 <vprintfmt+0x22e>
  8004cc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004cf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004d2:	83 c7 01             	add    $0x1,%edi
  8004d5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004d9:	0f be c2             	movsbl %dl,%eax
  8004dc:	85 c0                	test   %eax,%eax
  8004de:	74 27                	je     800507 <vprintfmt+0x263>
  8004e0:	85 f6                	test   %esi,%esi
  8004e2:	78 aa                	js     80048e <vprintfmt+0x1ea>
  8004e4:	83 ee 01             	sub    $0x1,%esi
  8004e7:	79 a5                	jns    80048e <vprintfmt+0x1ea>
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ee:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004f1:	89 c3                	mov    %eax,%ebx
  8004f3:	eb 18                	jmp    80050d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8004f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800500:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800502:	83 eb 01             	sub    $0x1,%ebx
  800505:	eb 06                	jmp    80050d <vprintfmt+0x269>
  800507:	8b 75 08             	mov    0x8(%ebp),%esi
  80050a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80050d:	85 db                	test   %ebx,%ebx
  80050f:	7f e4                	jg     8004f5 <vprintfmt+0x251>
  800511:	89 75 08             	mov    %esi,0x8(%ebp)
  800514:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800517:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80051a:	e9 aa fd ff ff       	jmp    8002c9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80051f:	83 f9 01             	cmp    $0x1,%ecx
  800522:	7e 10                	jle    800534 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8b 30                	mov    (%eax),%esi
  800529:	8b 78 04             	mov    0x4(%eax),%edi
  80052c:	8d 40 08             	lea    0x8(%eax),%eax
  80052f:	89 45 14             	mov    %eax,0x14(%ebp)
  800532:	eb 26                	jmp    80055a <vprintfmt+0x2b6>
	else if (lflag)
  800534:	85 c9                	test   %ecx,%ecx
  800536:	74 12                	je     80054a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800538:	8b 45 14             	mov    0x14(%ebp),%eax
  80053b:	8b 30                	mov    (%eax),%esi
  80053d:	89 f7                	mov    %esi,%edi
  80053f:	c1 ff 1f             	sar    $0x1f,%edi
  800542:	8d 40 04             	lea    0x4(%eax),%eax
  800545:	89 45 14             	mov    %eax,0x14(%ebp)
  800548:	eb 10                	jmp    80055a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8b 30                	mov    (%eax),%esi
  80054f:	89 f7                	mov    %esi,%edi
  800551:	c1 ff 1f             	sar    $0x1f,%edi
  800554:	8d 40 04             	lea    0x4(%eax),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80055a:	89 f0                	mov    %esi,%eax
  80055c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80055e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800563:	85 ff                	test   %edi,%edi
  800565:	0f 89 3a 01 00 00    	jns    8006a5 <vprintfmt+0x401>
				putch('-', putdat);
  80056b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800572:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800579:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80057c:	89 f0                	mov    %esi,%eax
  80057e:	89 fa                	mov    %edi,%edx
  800580:	f7 d8                	neg    %eax
  800582:	83 d2 00             	adc    $0x0,%edx
  800585:	f7 da                	neg    %edx
			}
			base = 10;
  800587:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80058c:	e9 14 01 00 00       	jmp    8006a5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800591:	83 f9 01             	cmp    $0x1,%ecx
  800594:	7e 13                	jle    8005a9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8b 50 04             	mov    0x4(%eax),%edx
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	8b 75 14             	mov    0x14(%ebp),%esi
  8005a1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8005a4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005a7:	eb 2c                	jmp    8005d5 <vprintfmt+0x331>
	else if (lflag)
  8005a9:	85 c9                	test   %ecx,%ecx
  8005ab:	74 15                	je     8005c2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b7:	8b 75 14             	mov    0x14(%ebp),%esi
  8005ba:	8d 76 04             	lea    0x4(%esi),%esi
  8005bd:	89 75 14             	mov    %esi,0x14(%ebp)
  8005c0:	eb 13                	jmp    8005d5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cc:	8b 75 14             	mov    0x14(%ebp),%esi
  8005cf:	8d 76 04             	lea    0x4(%esi),%esi
  8005d2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8005d5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8005da:	e9 c6 00 00 00       	jmp    8006a5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005df:	83 f9 01             	cmp    $0x1,%ecx
  8005e2:	7e 13                	jle    8005f7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8b 50 04             	mov    0x4(%eax),%edx
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	8b 75 14             	mov    0x14(%ebp),%esi
  8005ef:	8d 4e 08             	lea    0x8(%esi),%ecx
  8005f2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005f5:	eb 24                	jmp    80061b <vprintfmt+0x377>
	else if (lflag)
  8005f7:	85 c9                	test   %ecx,%ecx
  8005f9:	74 11                	je     80060c <vprintfmt+0x368>
		return va_arg(*ap, long);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	99                   	cltd   
  800601:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800604:	8d 71 04             	lea    0x4(%ecx),%esi
  800607:	89 75 14             	mov    %esi,0x14(%ebp)
  80060a:	eb 0f                	jmp    80061b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	99                   	cltd   
  800612:	8b 75 14             	mov    0x14(%ebp),%esi
  800615:	8d 76 04             	lea    0x4(%esi),%esi
  800618:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80061b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800620:	e9 80 00 00 00       	jmp    8006a5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800625:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80062f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800636:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800640:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800647:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80064a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80064e:	8b 06                	mov    (%esi),%eax
  800650:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800655:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80065a:	eb 49                	jmp    8006a5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80065c:	83 f9 01             	cmp    $0x1,%ecx
  80065f:	7e 13                	jle    800674 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 50 04             	mov    0x4(%eax),%edx
  800667:	8b 00                	mov    (%eax),%eax
  800669:	8b 75 14             	mov    0x14(%ebp),%esi
  80066c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80066f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800672:	eb 2c                	jmp    8006a0 <vprintfmt+0x3fc>
	else if (lflag)
  800674:	85 c9                	test   %ecx,%ecx
  800676:	74 15                	je     80068d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	ba 00 00 00 00       	mov    $0x0,%edx
  800682:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800685:	8d 71 04             	lea    0x4(%ecx),%esi
  800688:	89 75 14             	mov    %esi,0x14(%ebp)
  80068b:	eb 13                	jmp    8006a0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	ba 00 00 00 00       	mov    $0x0,%edx
  800697:	8b 75 14             	mov    0x14(%ebp),%esi
  80069a:	8d 76 04             	lea    0x4(%esi),%esi
  80069d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8006a0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006a5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8006a9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006ad:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8006b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006b4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006b8:	89 04 24             	mov    %eax,(%esp)
  8006bb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	e8 a6 fa ff ff       	call   800170 <printnum>
			break;
  8006ca:	e9 fa fb ff ff       	jmp    8002c9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006d6:	89 04 24             	mov    %eax,(%esp)
  8006d9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006dc:	e9 e8 fb ff ff       	jmp    8002c9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006ef:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006f2:	89 fb                	mov    %edi,%ebx
  8006f4:	eb 03                	jmp    8006f9 <vprintfmt+0x455>
  8006f6:	83 eb 01             	sub    $0x1,%ebx
  8006f9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006fd:	75 f7                	jne    8006f6 <vprintfmt+0x452>
  8006ff:	90                   	nop
  800700:	e9 c4 fb ff ff       	jmp    8002c9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800705:	83 c4 3c             	add    $0x3c,%esp
  800708:	5b                   	pop    %ebx
  800709:	5e                   	pop    %esi
  80070a:	5f                   	pop    %edi
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	83 ec 28             	sub    $0x28,%esp
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800719:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80071c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800720:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800723:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80072a:	85 c0                	test   %eax,%eax
  80072c:	74 30                	je     80075e <vsnprintf+0x51>
  80072e:	85 d2                	test   %edx,%edx
  800730:	7e 2c                	jle    80075e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800739:	8b 45 10             	mov    0x10(%ebp),%eax
  80073c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800740:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800743:	89 44 24 04          	mov    %eax,0x4(%esp)
  800747:	c7 04 24 5f 02 80 00 	movl   $0x80025f,(%esp)
  80074e:	e8 51 fb ff ff       	call   8002a4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800753:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800756:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075c:	eb 05                	jmp    800763 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80075e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80076b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80076e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	89 44 24 08          	mov    %eax,0x8(%esp)
  800779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	89 04 24             	mov    %eax,(%esp)
  800786:	e8 82 ff ff ff       	call   80070d <vsnprintf>
	va_end(ap);

	return rc;
}
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    
  80078d:	66 90                	xchg   %ax,%ax
  80078f:	90                   	nop

00800790 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800796:	b8 00 00 00 00       	mov    $0x0,%eax
  80079b:	eb 03                	jmp    8007a0 <strlen+0x10>
		n++;
  80079d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a4:	75 f7                	jne    80079d <strlen+0xd>
		n++;
	return n;
}
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b6:	eb 03                	jmp    8007bb <strnlen+0x13>
		n++;
  8007b8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bb:	39 d0                	cmp    %edx,%eax
  8007bd:	74 06                	je     8007c5 <strnlen+0x1d>
  8007bf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007c3:	75 f3                	jne    8007b8 <strnlen+0x10>
		n++;
	return n;
}
  8007c5:	5d                   	pop    %ebp
  8007c6:	c3                   	ret    

008007c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c7:	55                   	push   %ebp
  8007c8:	89 e5                	mov    %esp,%ebp
  8007ca:	53                   	push   %ebx
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d1:	89 c2                	mov    %eax,%edx
  8007d3:	83 c2 01             	add    $0x1,%edx
  8007d6:	83 c1 01             	add    $0x1,%ecx
  8007d9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007dd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007e0:	84 db                	test   %bl,%bl
  8007e2:	75 ef                	jne    8007d3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007e4:	5b                   	pop    %ebx
  8007e5:	5d                   	pop    %ebp
  8007e6:	c3                   	ret    

008007e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f1:	89 1c 24             	mov    %ebx,(%esp)
  8007f4:	e8 97 ff ff ff       	call   800790 <strlen>
	strcpy(dst + len, src);
  8007f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800800:	01 d8                	add    %ebx,%eax
  800802:	89 04 24             	mov    %eax,(%esp)
  800805:	e8 bd ff ff ff       	call   8007c7 <strcpy>
	return dst;
}
  80080a:	89 d8                	mov    %ebx,%eax
  80080c:	83 c4 08             	add    $0x8,%esp
  80080f:	5b                   	pop    %ebx
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	56                   	push   %esi
  800816:	53                   	push   %ebx
  800817:	8b 75 08             	mov    0x8(%ebp),%esi
  80081a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80081d:	89 f3                	mov    %esi,%ebx
  80081f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800822:	89 f2                	mov    %esi,%edx
  800824:	eb 0f                	jmp    800835 <strncpy+0x23>
		*dst++ = *src;
  800826:	83 c2 01             	add    $0x1,%edx
  800829:	0f b6 01             	movzbl (%ecx),%eax
  80082c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80082f:	80 39 01             	cmpb   $0x1,(%ecx)
  800832:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800835:	39 da                	cmp    %ebx,%edx
  800837:	75 ed                	jne    800826 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800839:	89 f0                	mov    %esi,%eax
  80083b:	5b                   	pop    %ebx
  80083c:	5e                   	pop    %esi
  80083d:	5d                   	pop    %ebp
  80083e:	c3                   	ret    

0080083f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	56                   	push   %esi
  800843:	53                   	push   %ebx
  800844:	8b 75 08             	mov    0x8(%ebp),%esi
  800847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800853:	85 c9                	test   %ecx,%ecx
  800855:	75 0b                	jne    800862 <strlcpy+0x23>
  800857:	eb 1d                	jmp    800876 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800859:	83 c0 01             	add    $0x1,%eax
  80085c:	83 c2 01             	add    $0x1,%edx
  80085f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800862:	39 d8                	cmp    %ebx,%eax
  800864:	74 0b                	je     800871 <strlcpy+0x32>
  800866:	0f b6 0a             	movzbl (%edx),%ecx
  800869:	84 c9                	test   %cl,%cl
  80086b:	75 ec                	jne    800859 <strlcpy+0x1a>
  80086d:	89 c2                	mov    %eax,%edx
  80086f:	eb 02                	jmp    800873 <strlcpy+0x34>
  800871:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800873:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800876:	29 f0                	sub    %esi,%eax
}
  800878:	5b                   	pop    %ebx
  800879:	5e                   	pop    %esi
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800882:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800885:	eb 06                	jmp    80088d <strcmp+0x11>
		p++, q++;
  800887:	83 c1 01             	add    $0x1,%ecx
  80088a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80088d:	0f b6 01             	movzbl (%ecx),%eax
  800890:	84 c0                	test   %al,%al
  800892:	74 04                	je     800898 <strcmp+0x1c>
  800894:	3a 02                	cmp    (%edx),%al
  800896:	74 ef                	je     800887 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800898:	0f b6 c0             	movzbl %al,%eax
  80089b:	0f b6 12             	movzbl (%edx),%edx
  80089e:	29 d0                	sub    %edx,%eax
}
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	53                   	push   %ebx
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ac:	89 c3                	mov    %eax,%ebx
  8008ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b1:	eb 06                	jmp    8008b9 <strncmp+0x17>
		n--, p++, q++;
  8008b3:	83 c0 01             	add    $0x1,%eax
  8008b6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008b9:	39 d8                	cmp    %ebx,%eax
  8008bb:	74 15                	je     8008d2 <strncmp+0x30>
  8008bd:	0f b6 08             	movzbl (%eax),%ecx
  8008c0:	84 c9                	test   %cl,%cl
  8008c2:	74 04                	je     8008c8 <strncmp+0x26>
  8008c4:	3a 0a                	cmp    (%edx),%cl
  8008c6:	74 eb                	je     8008b3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c8:	0f b6 00             	movzbl (%eax),%eax
  8008cb:	0f b6 12             	movzbl (%edx),%edx
  8008ce:	29 d0                	sub    %edx,%eax
  8008d0:	eb 05                	jmp    8008d7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008d7:	5b                   	pop    %ebx
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e4:	eb 07                	jmp    8008ed <strchr+0x13>
		if (*s == c)
  8008e6:	38 ca                	cmp    %cl,%dl
  8008e8:	74 0f                	je     8008f9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	0f b6 10             	movzbl (%eax),%edx
  8008f0:	84 d2                	test   %dl,%dl
  8008f2:	75 f2                	jne    8008e6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800905:	eb 07                	jmp    80090e <strfind+0x13>
		if (*s == c)
  800907:	38 ca                	cmp    %cl,%dl
  800909:	74 0a                	je     800915 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80090b:	83 c0 01             	add    $0x1,%eax
  80090e:	0f b6 10             	movzbl (%eax),%edx
  800911:	84 d2                	test   %dl,%dl
  800913:	75 f2                	jne    800907 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	57                   	push   %edi
  80091b:	56                   	push   %esi
  80091c:	53                   	push   %ebx
  80091d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800920:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800923:	85 c9                	test   %ecx,%ecx
  800925:	74 36                	je     80095d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800927:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80092d:	75 28                	jne    800957 <memset+0x40>
  80092f:	f6 c1 03             	test   $0x3,%cl
  800932:	75 23                	jne    800957 <memset+0x40>
		c &= 0xFF;
  800934:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800938:	89 d3                	mov    %edx,%ebx
  80093a:	c1 e3 08             	shl    $0x8,%ebx
  80093d:	89 d6                	mov    %edx,%esi
  80093f:	c1 e6 18             	shl    $0x18,%esi
  800942:	89 d0                	mov    %edx,%eax
  800944:	c1 e0 10             	shl    $0x10,%eax
  800947:	09 f0                	or     %esi,%eax
  800949:	09 c2                	or     %eax,%edx
  80094b:	89 d0                	mov    %edx,%eax
  80094d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80094f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800952:	fc                   	cld    
  800953:	f3 ab                	rep stos %eax,%es:(%edi)
  800955:	eb 06                	jmp    80095d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	fc                   	cld    
  80095b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095d:	89 f8                	mov    %edi,%eax
  80095f:	5b                   	pop    %ebx
  800960:	5e                   	pop    %esi
  800961:	5f                   	pop    %edi
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	57                   	push   %edi
  800968:	56                   	push   %esi
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80096f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800972:	39 c6                	cmp    %eax,%esi
  800974:	73 35                	jae    8009ab <memmove+0x47>
  800976:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800979:	39 d0                	cmp    %edx,%eax
  80097b:	73 2e                	jae    8009ab <memmove+0x47>
		s += n;
		d += n;
  80097d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800980:	89 d6                	mov    %edx,%esi
  800982:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800984:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80098a:	75 13                	jne    80099f <memmove+0x3b>
  80098c:	f6 c1 03             	test   $0x3,%cl
  80098f:	75 0e                	jne    80099f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800991:	83 ef 04             	sub    $0x4,%edi
  800994:	8d 72 fc             	lea    -0x4(%edx),%esi
  800997:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80099a:	fd                   	std    
  80099b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099d:	eb 09                	jmp    8009a8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80099f:	83 ef 01             	sub    $0x1,%edi
  8009a2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009a5:	fd                   	std    
  8009a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a8:	fc                   	cld    
  8009a9:	eb 1d                	jmp    8009c8 <memmove+0x64>
  8009ab:	89 f2                	mov    %esi,%edx
  8009ad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009af:	f6 c2 03             	test   $0x3,%dl
  8009b2:	75 0f                	jne    8009c3 <memmove+0x5f>
  8009b4:	f6 c1 03             	test   $0x3,%cl
  8009b7:	75 0a                	jne    8009c3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009bc:	89 c7                	mov    %eax,%edi
  8009be:	fc                   	cld    
  8009bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c1:	eb 05                	jmp    8009c8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009c3:	89 c7                	mov    %eax,%edi
  8009c5:	fc                   	cld    
  8009c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c8:	5e                   	pop    %esi
  8009c9:	5f                   	pop    %edi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	89 04 24             	mov    %eax,(%esp)
  8009e6:	e8 79 ff ff ff       	call   800964 <memmove>
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	56                   	push   %esi
  8009f1:	53                   	push   %ebx
  8009f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f8:	89 d6                	mov    %edx,%esi
  8009fa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009fd:	eb 1a                	jmp    800a19 <memcmp+0x2c>
		if (*s1 != *s2)
  8009ff:	0f b6 02             	movzbl (%edx),%eax
  800a02:	0f b6 19             	movzbl (%ecx),%ebx
  800a05:	38 d8                	cmp    %bl,%al
  800a07:	74 0a                	je     800a13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a09:	0f b6 c0             	movzbl %al,%eax
  800a0c:	0f b6 db             	movzbl %bl,%ebx
  800a0f:	29 d8                	sub    %ebx,%eax
  800a11:	eb 0f                	jmp    800a22 <memcmp+0x35>
		s1++, s2++;
  800a13:	83 c2 01             	add    $0x1,%edx
  800a16:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a19:	39 f2                	cmp    %esi,%edx
  800a1b:	75 e2                	jne    8009ff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a22:	5b                   	pop    %ebx
  800a23:	5e                   	pop    %esi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a34:	eb 07                	jmp    800a3d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a36:	38 08                	cmp    %cl,(%eax)
  800a38:	74 07                	je     800a41 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	39 d0                	cmp    %edx,%eax
  800a3f:	72 f5                	jb     800a36 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	57                   	push   %edi
  800a47:	56                   	push   %esi
  800a48:	53                   	push   %ebx
  800a49:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a4f:	eb 03                	jmp    800a54 <strtol+0x11>
		s++;
  800a51:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a54:	0f b6 0a             	movzbl (%edx),%ecx
  800a57:	80 f9 09             	cmp    $0x9,%cl
  800a5a:	74 f5                	je     800a51 <strtol+0xe>
  800a5c:	80 f9 20             	cmp    $0x20,%cl
  800a5f:	74 f0                	je     800a51 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a61:	80 f9 2b             	cmp    $0x2b,%cl
  800a64:	75 0a                	jne    800a70 <strtol+0x2d>
		s++;
  800a66:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a69:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6e:	eb 11                	jmp    800a81 <strtol+0x3e>
  800a70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a75:	80 f9 2d             	cmp    $0x2d,%cl
  800a78:	75 07                	jne    800a81 <strtol+0x3e>
		s++, neg = 1;
  800a7a:	8d 52 01             	lea    0x1(%edx),%edx
  800a7d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a81:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a86:	75 15                	jne    800a9d <strtol+0x5a>
  800a88:	80 3a 30             	cmpb   $0x30,(%edx)
  800a8b:	75 10                	jne    800a9d <strtol+0x5a>
  800a8d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a91:	75 0a                	jne    800a9d <strtol+0x5a>
		s += 2, base = 16;
  800a93:	83 c2 02             	add    $0x2,%edx
  800a96:	b8 10 00 00 00       	mov    $0x10,%eax
  800a9b:	eb 10                	jmp    800aad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800a9d:	85 c0                	test   %eax,%eax
  800a9f:	75 0c                	jne    800aad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa3:	80 3a 30             	cmpb   $0x30,(%edx)
  800aa6:	75 05                	jne    800aad <strtol+0x6a>
		s++, base = 8;
  800aa8:	83 c2 01             	add    $0x1,%edx
  800aab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800aad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ab5:	0f b6 0a             	movzbl (%edx),%ecx
  800ab8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800abb:	89 f0                	mov    %esi,%eax
  800abd:	3c 09                	cmp    $0x9,%al
  800abf:	77 08                	ja     800ac9 <strtol+0x86>
			dig = *s - '0';
  800ac1:	0f be c9             	movsbl %cl,%ecx
  800ac4:	83 e9 30             	sub    $0x30,%ecx
  800ac7:	eb 20                	jmp    800ae9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ac9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800acc:	89 f0                	mov    %esi,%eax
  800ace:	3c 19                	cmp    $0x19,%al
  800ad0:	77 08                	ja     800ada <strtol+0x97>
			dig = *s - 'a' + 10;
  800ad2:	0f be c9             	movsbl %cl,%ecx
  800ad5:	83 e9 57             	sub    $0x57,%ecx
  800ad8:	eb 0f                	jmp    800ae9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800ada:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800add:	89 f0                	mov    %esi,%eax
  800adf:	3c 19                	cmp    $0x19,%al
  800ae1:	77 16                	ja     800af9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ae3:	0f be c9             	movsbl %cl,%ecx
  800ae6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ae9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800aec:	7d 0f                	jge    800afd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800aee:	83 c2 01             	add    $0x1,%edx
  800af1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800af5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800af7:	eb bc                	jmp    800ab5 <strtol+0x72>
  800af9:	89 d8                	mov    %ebx,%eax
  800afb:	eb 02                	jmp    800aff <strtol+0xbc>
  800afd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800aff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b03:	74 05                	je     800b0a <strtol+0xc7>
		*endptr = (char *) s;
  800b05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b08:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b0a:	f7 d8                	neg    %eax
  800b0c:	85 ff                	test   %edi,%edi
  800b0e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	57                   	push   %edi
  800b1a:	56                   	push   %esi
  800b1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b24:	8b 55 08             	mov    0x8(%ebp),%edx
  800b27:	89 c3                	mov    %eax,%ebx
  800b29:	89 c7                	mov    %eax,%edi
  800b2b:	89 c6                	mov    %eax,%esi
  800b2d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5f                   	pop    %edi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	57                   	push   %edi
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b44:	89 d1                	mov    %edx,%ecx
  800b46:	89 d3                	mov    %edx,%ebx
  800b48:	89 d7                	mov    %edx,%edi
  800b4a:	89 d6                	mov    %edx,%esi
  800b4c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b4e:	5b                   	pop    %ebx
  800b4f:	5e                   	pop    %esi
  800b50:	5f                   	pop    %edi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b61:	b8 03 00 00 00       	mov    $0x3,%eax
  800b66:	8b 55 08             	mov    0x8(%ebp),%edx
  800b69:	89 cb                	mov    %ecx,%ebx
  800b6b:	89 cf                	mov    %ecx,%edi
  800b6d:	89 ce                	mov    %ecx,%esi
  800b6f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800b71:	85 c0                	test   %eax,%eax
  800b73:	7e 28                	jle    800b9d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b75:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b79:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b80:	00 
  800b81:	c7 44 24 08 37 2a 80 	movl   $0x802a37,0x8(%esp)
  800b88:	00 
  800b89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b90:	00 
  800b91:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  800b98:	e8 f9 16 00 00       	call   802296 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b9d:	83 c4 2c             	add    $0x2c,%esp
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
  800bab:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bae:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb3:	b8 04 00 00 00       	mov    $0x4,%eax
  800bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbb:	89 cb                	mov    %ecx,%ebx
  800bbd:	89 cf                	mov    %ecx,%edi
  800bbf:	89 ce                	mov    %ecx,%esi
  800bc1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bc3:	85 c0                	test   %eax,%eax
  800bc5:	7e 28                	jle    800bef <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bcb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800bd2:	00 
  800bd3:	c7 44 24 08 37 2a 80 	movl   $0x802a37,0x8(%esp)
  800bda:	00 
  800bdb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800be2:	00 
  800be3:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  800bea:	e8 a7 16 00 00       	call   802296 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800bef:	83 c4 2c             	add    $0x2c,%esp
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800c02:	b8 02 00 00 00       	mov    $0x2,%eax
  800c07:	89 d1                	mov    %edx,%ecx
  800c09:	89 d3                	mov    %edx,%ebx
  800c0b:	89 d7                	mov    %edx,%edi
  800c0d:	89 d6                	mov    %edx,%esi
  800c0f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <sys_yield>:

void
sys_yield(void)
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
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c21:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c26:	89 d1                	mov    %edx,%ecx
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	89 d7                	mov    %edx,%edi
  800c2c:	89 d6                	mov    %edx,%esi
  800c2e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	57                   	push   %edi
  800c39:	56                   	push   %esi
  800c3a:	53                   	push   %ebx
  800c3b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3e:	be 00 00 00 00       	mov    $0x0,%esi
  800c43:	b8 05 00 00 00       	mov    $0x5,%eax
  800c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c51:	89 f7                	mov    %esi,%edi
  800c53:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c55:	85 c0                	test   %eax,%eax
  800c57:	7e 28                	jle    800c81 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c59:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c5d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c64:	00 
  800c65:	c7 44 24 08 37 2a 80 	movl   $0x802a37,0x8(%esp)
  800c6c:	00 
  800c6d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c74:	00 
  800c75:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  800c7c:	e8 15 16 00 00       	call   802296 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c81:	83 c4 2c             	add    $0x2c,%esp
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	57                   	push   %edi
  800c8d:	56                   	push   %esi
  800c8e:	53                   	push   %ebx
  800c8f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c92:	b8 06 00 00 00       	mov    $0x6,%eax
  800c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca3:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ca8:	85 c0                	test   %eax,%eax
  800caa:	7e 28                	jle    800cd4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cac:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cb0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800cb7:	00 
  800cb8:	c7 44 24 08 37 2a 80 	movl   $0x802a37,0x8(%esp)
  800cbf:	00 
  800cc0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc7:	00 
  800cc8:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  800ccf:	e8 c2 15 00 00       	call   802296 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cd4:	83 c4 2c             	add    $0x2c,%esp
  800cd7:	5b                   	pop    %ebx
  800cd8:	5e                   	pop    %esi
  800cd9:	5f                   	pop    %edi
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    

00800cdc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	57                   	push   %edi
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
  800ce2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cea:	b8 07 00 00 00       	mov    $0x7,%eax
  800cef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	89 df                	mov    %ebx,%edi
  800cf7:	89 de                	mov    %ebx,%esi
  800cf9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cfb:	85 c0                	test   %eax,%eax
  800cfd:	7e 28                	jle    800d27 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cff:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d03:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800d0a:	00 
  800d0b:	c7 44 24 08 37 2a 80 	movl   $0x802a37,0x8(%esp)
  800d12:	00 
  800d13:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d1a:	00 
  800d1b:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  800d22:	e8 6f 15 00 00       	call   802296 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d27:	83 c4 2c             	add    $0x2c,%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d35:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d3a:	b8 10 00 00 00       	mov    $0x10,%eax
  800d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d42:	89 cb                	mov    %ecx,%ebx
  800d44:	89 cf                	mov    %ecx,%edi
  800d46:	89 ce                	mov    %ecx,%esi
  800d48:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800d4a:	5b                   	pop    %ebx
  800d4b:	5e                   	pop    %esi
  800d4c:	5f                   	pop    %edi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	57                   	push   %edi
  800d53:	56                   	push   %esi
  800d54:	53                   	push   %ebx
  800d55:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5d:	b8 09 00 00 00       	mov    $0x9,%eax
  800d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d65:	8b 55 08             	mov    0x8(%ebp),%edx
  800d68:	89 df                	mov    %ebx,%edi
  800d6a:	89 de                	mov    %ebx,%esi
  800d6c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	7e 28                	jle    800d9a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d72:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d76:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d7d:	00 
  800d7e:	c7 44 24 08 37 2a 80 	movl   $0x802a37,0x8(%esp)
  800d85:	00 
  800d86:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d8d:	00 
  800d8e:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  800d95:	e8 fc 14 00 00       	call   802296 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d9a:	83 c4 2c             	add    $0x2c,%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
  800da8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	89 df                	mov    %ebx,%edi
  800dbd:	89 de                	mov    %ebx,%esi
  800dbf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	7e 28                	jle    800ded <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800dd0:	00 
  800dd1:	c7 44 24 08 37 2a 80 	movl   $0x802a37,0x8(%esp)
  800dd8:	00 
  800dd9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de0:	00 
  800de1:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  800de8:	e8 a9 14 00 00       	call   802296 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ded:	83 c4 2c             	add    $0x2c,%esp
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	57                   	push   %edi
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e03:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	89 df                	mov    %ebx,%edi
  800e10:	89 de                	mov    %ebx,%esi
  800e12:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e14:	85 c0                	test   %eax,%eax
  800e16:	7e 28                	jle    800e40 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e18:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800e23:	00 
  800e24:	c7 44 24 08 37 2a 80 	movl   $0x802a37,0x8(%esp)
  800e2b:	00 
  800e2c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e33:	00 
  800e34:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  800e3b:	e8 56 14 00 00       	call   802296 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e40:	83 c4 2c             	add    $0x2c,%esp
  800e43:	5b                   	pop    %ebx
  800e44:	5e                   	pop    %esi
  800e45:	5f                   	pop    %edi
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    

00800e48 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	57                   	push   %edi
  800e4c:	56                   	push   %esi
  800e4d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4e:	be 00 00 00 00       	mov    $0x0,%esi
  800e53:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e61:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e64:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    

00800e6b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	57                   	push   %edi
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
  800e71:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e74:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e79:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e81:	89 cb                	mov    %ecx,%ebx
  800e83:	89 cf                	mov    %ecx,%edi
  800e85:	89 ce                	mov    %ecx,%esi
  800e87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	7e 28                	jle    800eb5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e91:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800e98:	00 
  800e99:	c7 44 24 08 37 2a 80 	movl   $0x802a37,0x8(%esp)
  800ea0:	00 
  800ea1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea8:	00 
  800ea9:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  800eb0:	e8 e1 13 00 00       	call   802296 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eb5:	83 c4 2c             	add    $0x2c,%esp
  800eb8:	5b                   	pop    %ebx
  800eb9:	5e                   	pop    %esi
  800eba:	5f                   	pop    %edi
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	57                   	push   %edi
  800ec1:	56                   	push   %esi
  800ec2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ecd:	89 d1                	mov    %edx,%ecx
  800ecf:	89 d3                	mov    %edx,%ebx
  800ed1:	89 d7                	mov    %edx,%edi
  800ed3:	89 d6                	mov    %edx,%esi
  800ed5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ed7:	5b                   	pop    %ebx
  800ed8:	5e                   	pop    %esi
  800ed9:	5f                   	pop    %edi
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee7:	b8 11 00 00 00       	mov    $0x11,%eax
  800eec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef2:	89 df                	mov    %ebx,%edi
  800ef4:	89 de                	mov    %ebx,%esi
  800ef6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f08:	b8 12 00 00 00       	mov    $0x12,%eax
  800f0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f10:	8b 55 08             	mov    0x8(%ebp),%edx
  800f13:	89 df                	mov    %ebx,%edi
  800f15:	89 de                	mov    %ebx,%esi
  800f17:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    

00800f1e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f24:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f29:	b8 13 00 00 00       	mov    $0x13,%eax
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	89 cb                	mov    %ecx,%ebx
  800f33:	89 cf                	mov    %ecx,%edi
  800f35:	89 ce                	mov    %ecx,%esi
  800f37:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  800f39:	5b                   	pop    %ebx
  800f3a:	5e                   	pop    %esi
  800f3b:	5f                   	pop    %edi
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    
  800f3e:	66 90                	xchg   %ax,%ax

00800f40 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	05 00 00 00 30       	add    $0x30000000,%eax
  800f4b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800f5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f60:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f6d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f72:	89 c2                	mov    %eax,%edx
  800f74:	c1 ea 16             	shr    $0x16,%edx
  800f77:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f7e:	f6 c2 01             	test   $0x1,%dl
  800f81:	74 11                	je     800f94 <fd_alloc+0x2d>
  800f83:	89 c2                	mov    %eax,%edx
  800f85:	c1 ea 0c             	shr    $0xc,%edx
  800f88:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f8f:	f6 c2 01             	test   $0x1,%dl
  800f92:	75 09                	jne    800f9d <fd_alloc+0x36>
			*fd_store = fd;
  800f94:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f96:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9b:	eb 17                	jmp    800fb4 <fd_alloc+0x4d>
  800f9d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fa2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fa7:	75 c9                	jne    800f72 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fa9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800faf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fbc:	83 f8 1f             	cmp    $0x1f,%eax
  800fbf:	77 36                	ja     800ff7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fc1:	c1 e0 0c             	shl    $0xc,%eax
  800fc4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fc9:	89 c2                	mov    %eax,%edx
  800fcb:	c1 ea 16             	shr    $0x16,%edx
  800fce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fd5:	f6 c2 01             	test   $0x1,%dl
  800fd8:	74 24                	je     800ffe <fd_lookup+0x48>
  800fda:	89 c2                	mov    %eax,%edx
  800fdc:	c1 ea 0c             	shr    $0xc,%edx
  800fdf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fe6:	f6 c2 01             	test   $0x1,%dl
  800fe9:	74 1a                	je     801005 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fee:	89 02                	mov    %eax,(%edx)
	return 0;
  800ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff5:	eb 13                	jmp    80100a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800ff7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ffc:	eb 0c                	jmp    80100a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800ffe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801003:	eb 05                	jmp    80100a <fd_lookup+0x54>
  801005:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 18             	sub    $0x18,%esp
  801012:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801015:	ba 00 00 00 00       	mov    $0x0,%edx
  80101a:	eb 13                	jmp    80102f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80101c:	39 08                	cmp    %ecx,(%eax)
  80101e:	75 0c                	jne    80102c <dev_lookup+0x20>
			*dev = devtab[i];
  801020:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801023:	89 01                	mov    %eax,(%ecx)
			return 0;
  801025:	b8 00 00 00 00       	mov    $0x0,%eax
  80102a:	eb 38                	jmp    801064 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80102c:	83 c2 01             	add    $0x1,%edx
  80102f:	8b 04 95 e0 2a 80 00 	mov    0x802ae0(,%edx,4),%eax
  801036:	85 c0                	test   %eax,%eax
  801038:	75 e2                	jne    80101c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80103a:	a1 08 40 80 00       	mov    0x804008,%eax
  80103f:	8b 40 48             	mov    0x48(%eax),%eax
  801042:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80104a:	c7 04 24 64 2a 80 00 	movl   $0x802a64,(%esp)
  801051:	e8 fe f0 ff ff       	call   800154 <cprintf>
	*dev = 0;
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80105f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	56                   	push   %esi
  80106a:	53                   	push   %ebx
  80106b:	83 ec 20             	sub    $0x20,%esp
  80106e:	8b 75 08             	mov    0x8(%ebp),%esi
  801071:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801074:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801077:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80107b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801081:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801084:	89 04 24             	mov    %eax,(%esp)
  801087:	e8 2a ff ff ff       	call   800fb6 <fd_lookup>
  80108c:	85 c0                	test   %eax,%eax
  80108e:	78 05                	js     801095 <fd_close+0x2f>
	    || fd != fd2)
  801090:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801093:	74 0c                	je     8010a1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801095:	84 db                	test   %bl,%bl
  801097:	ba 00 00 00 00       	mov    $0x0,%edx
  80109c:	0f 44 c2             	cmove  %edx,%eax
  80109f:	eb 3f                	jmp    8010e0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010a8:	8b 06                	mov    (%esi),%eax
  8010aa:	89 04 24             	mov    %eax,(%esp)
  8010ad:	e8 5a ff ff ff       	call   80100c <dev_lookup>
  8010b2:	89 c3                	mov    %eax,%ebx
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	78 16                	js     8010ce <fd_close+0x68>
		if (dev->dev_close)
  8010b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8010be:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	74 07                	je     8010ce <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8010c7:	89 34 24             	mov    %esi,(%esp)
  8010ca:	ff d0                	call   *%eax
  8010cc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010d9:	e8 fe fb ff ff       	call   800cdc <sys_page_unmap>
	return r;
  8010de:	89 d8                	mov    %ebx,%eax
}
  8010e0:	83 c4 20             	add    $0x20,%esp
  8010e3:	5b                   	pop    %ebx
  8010e4:	5e                   	pop    %esi
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    

008010e7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	89 04 24             	mov    %eax,(%esp)
  8010fa:	e8 b7 fe ff ff       	call   800fb6 <fd_lookup>
  8010ff:	89 c2                	mov    %eax,%edx
  801101:	85 d2                	test   %edx,%edx
  801103:	78 13                	js     801118 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801105:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80110c:	00 
  80110d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801110:	89 04 24             	mov    %eax,(%esp)
  801113:	e8 4e ff ff ff       	call   801066 <fd_close>
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <close_all>:

void
close_all(void)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	53                   	push   %ebx
  80111e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801121:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801126:	89 1c 24             	mov    %ebx,(%esp)
  801129:	e8 b9 ff ff ff       	call   8010e7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80112e:	83 c3 01             	add    $0x1,%ebx
  801131:	83 fb 20             	cmp    $0x20,%ebx
  801134:	75 f0                	jne    801126 <close_all+0xc>
		close(i);
}
  801136:	83 c4 14             	add    $0x14,%esp
  801139:	5b                   	pop    %ebx
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    

0080113c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	57                   	push   %edi
  801140:	56                   	push   %esi
  801141:	53                   	push   %ebx
  801142:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801145:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801148:	89 44 24 04          	mov    %eax,0x4(%esp)
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	89 04 24             	mov    %eax,(%esp)
  801152:	e8 5f fe ff ff       	call   800fb6 <fd_lookup>
  801157:	89 c2                	mov    %eax,%edx
  801159:	85 d2                	test   %edx,%edx
  80115b:	0f 88 e1 00 00 00    	js     801242 <dup+0x106>
		return r;
	close(newfdnum);
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	89 04 24             	mov    %eax,(%esp)
  801167:	e8 7b ff ff ff       	call   8010e7 <close>

	newfd = INDEX2FD(newfdnum);
  80116c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80116f:	c1 e3 0c             	shl    $0xc,%ebx
  801172:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80117b:	89 04 24             	mov    %eax,(%esp)
  80117e:	e8 cd fd ff ff       	call   800f50 <fd2data>
  801183:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801185:	89 1c 24             	mov    %ebx,(%esp)
  801188:	e8 c3 fd ff ff       	call   800f50 <fd2data>
  80118d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80118f:	89 f0                	mov    %esi,%eax
  801191:	c1 e8 16             	shr    $0x16,%eax
  801194:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80119b:	a8 01                	test   $0x1,%al
  80119d:	74 43                	je     8011e2 <dup+0xa6>
  80119f:	89 f0                	mov    %esi,%eax
  8011a1:	c1 e8 0c             	shr    $0xc,%eax
  8011a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011ab:	f6 c2 01             	test   $0x1,%dl
  8011ae:	74 32                	je     8011e2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011cb:	00 
  8011cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d7:	e8 ad fa ff ff       	call   800c89 <sys_page_map>
  8011dc:	89 c6                	mov    %eax,%esi
  8011de:	85 c0                	test   %eax,%eax
  8011e0:	78 3e                	js     801220 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011e5:	89 c2                	mov    %eax,%edx
  8011e7:	c1 ea 0c             	shr    $0xc,%edx
  8011ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8011f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8011fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801206:	00 
  801207:	89 44 24 04          	mov    %eax,0x4(%esp)
  80120b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801212:	e8 72 fa ff ff       	call   800c89 <sys_page_map>
  801217:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80121c:	85 f6                	test   %esi,%esi
  80121e:	79 22                	jns    801242 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801220:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801224:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80122b:	e8 ac fa ff ff       	call   800cdc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801230:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801234:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80123b:	e8 9c fa ff ff       	call   800cdc <sys_page_unmap>
	return r;
  801240:	89 f0                	mov    %esi,%eax
}
  801242:	83 c4 3c             	add    $0x3c,%esp
  801245:	5b                   	pop    %ebx
  801246:	5e                   	pop    %esi
  801247:	5f                   	pop    %edi
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    

0080124a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	53                   	push   %ebx
  80124e:	83 ec 24             	sub    $0x24,%esp
  801251:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801254:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80125b:	89 1c 24             	mov    %ebx,(%esp)
  80125e:	e8 53 fd ff ff       	call   800fb6 <fd_lookup>
  801263:	89 c2                	mov    %eax,%edx
  801265:	85 d2                	test   %edx,%edx
  801267:	78 6d                	js     8012d6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801269:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801273:	8b 00                	mov    (%eax),%eax
  801275:	89 04 24             	mov    %eax,(%esp)
  801278:	e8 8f fd ff ff       	call   80100c <dev_lookup>
  80127d:	85 c0                	test   %eax,%eax
  80127f:	78 55                	js     8012d6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801284:	8b 50 08             	mov    0x8(%eax),%edx
  801287:	83 e2 03             	and    $0x3,%edx
  80128a:	83 fa 01             	cmp    $0x1,%edx
  80128d:	75 23                	jne    8012b2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80128f:	a1 08 40 80 00       	mov    0x804008,%eax
  801294:	8b 40 48             	mov    0x48(%eax),%eax
  801297:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80129b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80129f:	c7 04 24 a5 2a 80 00 	movl   $0x802aa5,(%esp)
  8012a6:	e8 a9 ee ff ff       	call   800154 <cprintf>
		return -E_INVAL;
  8012ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b0:	eb 24                	jmp    8012d6 <read+0x8c>
	}
	if (!dev->dev_read)
  8012b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b5:	8b 52 08             	mov    0x8(%edx),%edx
  8012b8:	85 d2                	test   %edx,%edx
  8012ba:	74 15                	je     8012d1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8012ca:	89 04 24             	mov    %eax,(%esp)
  8012cd:	ff d2                	call   *%edx
  8012cf:	eb 05                	jmp    8012d6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8012d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8012d6:	83 c4 24             	add    $0x24,%esp
  8012d9:	5b                   	pop    %ebx
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    

008012dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	57                   	push   %edi
  8012e0:	56                   	push   %esi
  8012e1:	53                   	push   %ebx
  8012e2:	83 ec 1c             	sub    $0x1c,%esp
  8012e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f0:	eb 23                	jmp    801315 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012f2:	89 f0                	mov    %esi,%eax
  8012f4:	29 d8                	sub    %ebx,%eax
  8012f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012fa:	89 d8                	mov    %ebx,%eax
  8012fc:	03 45 0c             	add    0xc(%ebp),%eax
  8012ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801303:	89 3c 24             	mov    %edi,(%esp)
  801306:	e8 3f ff ff ff       	call   80124a <read>
		if (m < 0)
  80130b:	85 c0                	test   %eax,%eax
  80130d:	78 10                	js     80131f <readn+0x43>
			return m;
		if (m == 0)
  80130f:	85 c0                	test   %eax,%eax
  801311:	74 0a                	je     80131d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801313:	01 c3                	add    %eax,%ebx
  801315:	39 f3                	cmp    %esi,%ebx
  801317:	72 d9                	jb     8012f2 <readn+0x16>
  801319:	89 d8                	mov    %ebx,%eax
  80131b:	eb 02                	jmp    80131f <readn+0x43>
  80131d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80131f:	83 c4 1c             	add    $0x1c,%esp
  801322:	5b                   	pop    %ebx
  801323:	5e                   	pop    %esi
  801324:	5f                   	pop    %edi
  801325:	5d                   	pop    %ebp
  801326:	c3                   	ret    

00801327 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	53                   	push   %ebx
  80132b:	83 ec 24             	sub    $0x24,%esp
  80132e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801331:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801334:	89 44 24 04          	mov    %eax,0x4(%esp)
  801338:	89 1c 24             	mov    %ebx,(%esp)
  80133b:	e8 76 fc ff ff       	call   800fb6 <fd_lookup>
  801340:	89 c2                	mov    %eax,%edx
  801342:	85 d2                	test   %edx,%edx
  801344:	78 68                	js     8013ae <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801346:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801349:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801350:	8b 00                	mov    (%eax),%eax
  801352:	89 04 24             	mov    %eax,(%esp)
  801355:	e8 b2 fc ff ff       	call   80100c <dev_lookup>
  80135a:	85 c0                	test   %eax,%eax
  80135c:	78 50                	js     8013ae <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80135e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801361:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801365:	75 23                	jne    80138a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801367:	a1 08 40 80 00       	mov    0x804008,%eax
  80136c:	8b 40 48             	mov    0x48(%eax),%eax
  80136f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801373:	89 44 24 04          	mov    %eax,0x4(%esp)
  801377:	c7 04 24 c1 2a 80 00 	movl   $0x802ac1,(%esp)
  80137e:	e8 d1 ed ff ff       	call   800154 <cprintf>
		return -E_INVAL;
  801383:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801388:	eb 24                	jmp    8013ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80138a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138d:	8b 52 0c             	mov    0xc(%edx),%edx
  801390:	85 d2                	test   %edx,%edx
  801392:	74 15                	je     8013a9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801394:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801397:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80139b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013a2:	89 04 24             	mov    %eax,(%esp)
  8013a5:	ff d2                	call   *%edx
  8013a7:	eb 05                	jmp    8013ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8013a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8013ae:	83 c4 24             	add    $0x24,%esp
  8013b1:	5b                   	pop    %ebx
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    

008013b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	89 04 24             	mov    %eax,(%esp)
  8013c7:	e8 ea fb ff ff       	call   800fb6 <fd_lookup>
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 0e                	js     8013de <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8013d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	53                   	push   %ebx
  8013e4:	83 ec 24             	sub    $0x24,%esp
  8013e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f1:	89 1c 24             	mov    %ebx,(%esp)
  8013f4:	e8 bd fb ff ff       	call   800fb6 <fd_lookup>
  8013f9:	89 c2                	mov    %eax,%edx
  8013fb:	85 d2                	test   %edx,%edx
  8013fd:	78 61                	js     801460 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801402:	89 44 24 04          	mov    %eax,0x4(%esp)
  801406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801409:	8b 00                	mov    (%eax),%eax
  80140b:	89 04 24             	mov    %eax,(%esp)
  80140e:	e8 f9 fb ff ff       	call   80100c <dev_lookup>
  801413:	85 c0                	test   %eax,%eax
  801415:	78 49                	js     801460 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80141e:	75 23                	jne    801443 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801420:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801425:	8b 40 48             	mov    0x48(%eax),%eax
  801428:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80142c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801430:	c7 04 24 84 2a 80 00 	movl   $0x802a84,(%esp)
  801437:	e8 18 ed ff ff       	call   800154 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80143c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801441:	eb 1d                	jmp    801460 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801443:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801446:	8b 52 18             	mov    0x18(%edx),%edx
  801449:	85 d2                	test   %edx,%edx
  80144b:	74 0e                	je     80145b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80144d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801450:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801454:	89 04 24             	mov    %eax,(%esp)
  801457:	ff d2                	call   *%edx
  801459:	eb 05                	jmp    801460 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80145b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801460:	83 c4 24             	add    $0x24,%esp
  801463:	5b                   	pop    %ebx
  801464:	5d                   	pop    %ebp
  801465:	c3                   	ret    

00801466 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	53                   	push   %ebx
  80146a:	83 ec 24             	sub    $0x24,%esp
  80146d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801470:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801473:	89 44 24 04          	mov    %eax,0x4(%esp)
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	89 04 24             	mov    %eax,(%esp)
  80147d:	e8 34 fb ff ff       	call   800fb6 <fd_lookup>
  801482:	89 c2                	mov    %eax,%edx
  801484:	85 d2                	test   %edx,%edx
  801486:	78 52                	js     8014da <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801488:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801492:	8b 00                	mov    (%eax),%eax
  801494:	89 04 24             	mov    %eax,(%esp)
  801497:	e8 70 fb ff ff       	call   80100c <dev_lookup>
  80149c:	85 c0                	test   %eax,%eax
  80149e:	78 3a                	js     8014da <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8014a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014a7:	74 2c                	je     8014d5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014b3:	00 00 00 
	stat->st_isdir = 0;
  8014b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014bd:	00 00 00 
	stat->st_dev = dev;
  8014c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014cd:	89 14 24             	mov    %edx,(%esp)
  8014d0:	ff 50 14             	call   *0x14(%eax)
  8014d3:	eb 05                	jmp    8014da <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8014d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8014da:	83 c4 24             	add    $0x24,%esp
  8014dd:	5b                   	pop    %ebx
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    

008014e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	56                   	push   %esi
  8014e4:	53                   	push   %ebx
  8014e5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014ef:	00 
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	89 04 24             	mov    %eax,(%esp)
  8014f6:	e8 99 02 00 00       	call   801794 <open>
  8014fb:	89 c3                	mov    %eax,%ebx
  8014fd:	85 db                	test   %ebx,%ebx
  8014ff:	78 1b                	js     80151c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	89 44 24 04          	mov    %eax,0x4(%esp)
  801508:	89 1c 24             	mov    %ebx,(%esp)
  80150b:	e8 56 ff ff ff       	call   801466 <fstat>
  801510:	89 c6                	mov    %eax,%esi
	close(fd);
  801512:	89 1c 24             	mov    %ebx,(%esp)
  801515:	e8 cd fb ff ff       	call   8010e7 <close>
	return r;
  80151a:	89 f0                	mov    %esi,%eax
}
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	5b                   	pop    %ebx
  801520:	5e                   	pop    %esi
  801521:	5d                   	pop    %ebp
  801522:	c3                   	ret    

00801523 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	56                   	push   %esi
  801527:	53                   	push   %ebx
  801528:	83 ec 10             	sub    $0x10,%esp
  80152b:	89 c6                	mov    %eax,%esi
  80152d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80152f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801536:	75 11                	jne    801549 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801538:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80153f:	e8 7b 0e 00 00       	call   8023bf <ipc_find_env>
  801544:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801549:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801550:	00 
  801551:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801558:	00 
  801559:	89 74 24 04          	mov    %esi,0x4(%esp)
  80155d:	a1 00 40 80 00       	mov    0x804000,%eax
  801562:	89 04 24             	mov    %eax,(%esp)
  801565:	e8 ee 0d 00 00       	call   802358 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80156a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801571:	00 
  801572:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801576:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80157d:	e8 6e 0d 00 00       	call   8022f0 <ipc_recv>
}
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	5b                   	pop    %ebx
  801586:	5e                   	pop    %esi
  801587:	5d                   	pop    %ebp
  801588:	c3                   	ret    

00801589 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8b 40 0c             	mov    0xc(%eax),%eax
  801595:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80159a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8015ac:	e8 72 ff ff ff       	call   801523 <fsipc>
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bf:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8015ce:	e8 50 ff ff ff       	call   801523 <fsipc>
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	53                   	push   %ebx
  8015d9:	83 ec 14             	sub    $0x14,%esp
  8015dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8015f4:	e8 2a ff ff ff       	call   801523 <fsipc>
  8015f9:	89 c2                	mov    %eax,%edx
  8015fb:	85 d2                	test   %edx,%edx
  8015fd:	78 2b                	js     80162a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015ff:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801606:	00 
  801607:	89 1c 24             	mov    %ebx,(%esp)
  80160a:	e8 b8 f1 ff ff       	call   8007c7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80160f:	a1 80 50 80 00       	mov    0x805080,%eax
  801614:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80161a:	a1 84 50 80 00       	mov    0x805084,%eax
  80161f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162a:	83 c4 14             	add    $0x14,%esp
  80162d:	5b                   	pop    %ebx
  80162e:	5d                   	pop    %ebp
  80162f:	c3                   	ret    

00801630 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	53                   	push   %ebx
  801634:	83 ec 14             	sub    $0x14,%esp
  801637:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80163a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801640:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801645:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801648:	8b 55 08             	mov    0x8(%ebp),%edx
  80164b:	8b 52 0c             	mov    0xc(%edx),%edx
  80164e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  801654:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801659:	89 44 24 08          	mov    %eax,0x8(%esp)
  80165d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801660:	89 44 24 04          	mov    %eax,0x4(%esp)
  801664:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80166b:	e8 f4 f2 ff ff       	call   800964 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801670:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  801677:	00 
  801678:	c7 04 24 f4 2a 80 00 	movl   $0x802af4,(%esp)
  80167f:	e8 d0 ea ff ff       	call   800154 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801684:	ba 00 00 00 00       	mov    $0x0,%edx
  801689:	b8 04 00 00 00       	mov    $0x4,%eax
  80168e:	e8 90 fe ff ff       	call   801523 <fsipc>
  801693:	85 c0                	test   %eax,%eax
  801695:	78 53                	js     8016ea <devfile_write+0xba>
		return r;
	assert(r <= n);
  801697:	39 c3                	cmp    %eax,%ebx
  801699:	73 24                	jae    8016bf <devfile_write+0x8f>
  80169b:	c7 44 24 0c f9 2a 80 	movl   $0x802af9,0xc(%esp)
  8016a2:	00 
  8016a3:	c7 44 24 08 00 2b 80 	movl   $0x802b00,0x8(%esp)
  8016aa:	00 
  8016ab:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8016b2:	00 
  8016b3:	c7 04 24 15 2b 80 00 	movl   $0x802b15,(%esp)
  8016ba:	e8 d7 0b 00 00       	call   802296 <_panic>
	assert(r <= PGSIZE);
  8016bf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016c4:	7e 24                	jle    8016ea <devfile_write+0xba>
  8016c6:	c7 44 24 0c 20 2b 80 	movl   $0x802b20,0xc(%esp)
  8016cd:	00 
  8016ce:	c7 44 24 08 00 2b 80 	movl   $0x802b00,0x8(%esp)
  8016d5:	00 
  8016d6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8016dd:	00 
  8016de:	c7 04 24 15 2b 80 00 	movl   $0x802b15,(%esp)
  8016e5:	e8 ac 0b 00 00       	call   802296 <_panic>
	return r;
}
  8016ea:	83 c4 14             	add    $0x14,%esp
  8016ed:	5b                   	pop    %ebx
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	56                   	push   %esi
  8016f4:	53                   	push   %ebx
  8016f5:	83 ec 10             	sub    $0x10,%esp
  8016f8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801701:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801706:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80170c:	ba 00 00 00 00       	mov    $0x0,%edx
  801711:	b8 03 00 00 00       	mov    $0x3,%eax
  801716:	e8 08 fe ff ff       	call   801523 <fsipc>
  80171b:	89 c3                	mov    %eax,%ebx
  80171d:	85 c0                	test   %eax,%eax
  80171f:	78 6a                	js     80178b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801721:	39 c6                	cmp    %eax,%esi
  801723:	73 24                	jae    801749 <devfile_read+0x59>
  801725:	c7 44 24 0c f9 2a 80 	movl   $0x802af9,0xc(%esp)
  80172c:	00 
  80172d:	c7 44 24 08 00 2b 80 	movl   $0x802b00,0x8(%esp)
  801734:	00 
  801735:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80173c:	00 
  80173d:	c7 04 24 15 2b 80 00 	movl   $0x802b15,(%esp)
  801744:	e8 4d 0b 00 00       	call   802296 <_panic>
	assert(r <= PGSIZE);
  801749:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80174e:	7e 24                	jle    801774 <devfile_read+0x84>
  801750:	c7 44 24 0c 20 2b 80 	movl   $0x802b20,0xc(%esp)
  801757:	00 
  801758:	c7 44 24 08 00 2b 80 	movl   $0x802b00,0x8(%esp)
  80175f:	00 
  801760:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801767:	00 
  801768:	c7 04 24 15 2b 80 00 	movl   $0x802b15,(%esp)
  80176f:	e8 22 0b 00 00       	call   802296 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801774:	89 44 24 08          	mov    %eax,0x8(%esp)
  801778:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80177f:	00 
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	89 04 24             	mov    %eax,(%esp)
  801786:	e8 d9 f1 ff ff       	call   800964 <memmove>
	return r;
}
  80178b:	89 d8                	mov    %ebx,%eax
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	5b                   	pop    %ebx
  801791:	5e                   	pop    %esi
  801792:	5d                   	pop    %ebp
  801793:	c3                   	ret    

00801794 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	53                   	push   %ebx
  801798:	83 ec 24             	sub    $0x24,%esp
  80179b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80179e:	89 1c 24             	mov    %ebx,(%esp)
  8017a1:	e8 ea ef ff ff       	call   800790 <strlen>
  8017a6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017ab:	7f 60                	jg     80180d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b0:	89 04 24             	mov    %eax,(%esp)
  8017b3:	e8 af f7 ff ff       	call   800f67 <fd_alloc>
  8017b8:	89 c2                	mov    %eax,%edx
  8017ba:	85 d2                	test   %edx,%edx
  8017bc:	78 54                	js     801812 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8017be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017c2:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8017c9:	e8 f9 ef ff ff       	call   8007c7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8017de:	e8 40 fd ff ff       	call   801523 <fsipc>
  8017e3:	89 c3                	mov    %eax,%ebx
  8017e5:	85 c0                	test   %eax,%eax
  8017e7:	79 17                	jns    801800 <open+0x6c>
		fd_close(fd, 0);
  8017e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017f0:	00 
  8017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f4:	89 04 24             	mov    %eax,(%esp)
  8017f7:	e8 6a f8 ff ff       	call   801066 <fd_close>
		return r;
  8017fc:	89 d8                	mov    %ebx,%eax
  8017fe:	eb 12                	jmp    801812 <open+0x7e>
	}

	return fd2num(fd);
  801800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801803:	89 04 24             	mov    %eax,(%esp)
  801806:	e8 35 f7 ff ff       	call   800f40 <fd2num>
  80180b:	eb 05                	jmp    801812 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80180d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801812:	83 c4 24             	add    $0x24,%esp
  801815:	5b                   	pop    %ebx
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    

00801818 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80181e:	ba 00 00 00 00       	mov    $0x0,%edx
  801823:	b8 08 00 00 00       	mov    $0x8,%eax
  801828:	e8 f6 fc ff ff       	call   801523 <fsipc>
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <evict>:

int evict(void)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801835:	c7 04 24 2c 2b 80 00 	movl   $0x802b2c,(%esp)
  80183c:	e8 13 e9 ff ff       	call   800154 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801841:	ba 00 00 00 00       	mov    $0x0,%edx
  801846:	b8 09 00 00 00       	mov    $0x9,%eax
  80184b:	e8 d3 fc ff ff       	call   801523 <fsipc>
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    
  801852:	66 90                	xchg   %ax,%ax
  801854:	66 90                	xchg   %ax,%ax
  801856:	66 90                	xchg   %ax,%ax
  801858:	66 90                	xchg   %ax,%ax
  80185a:	66 90                	xchg   %ax,%ax
  80185c:	66 90                	xchg   %ax,%ax
  80185e:	66 90                	xchg   %ax,%ax

00801860 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801866:	c7 44 24 04 45 2b 80 	movl   $0x802b45,0x4(%esp)
  80186d:	00 
  80186e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801871:	89 04 24             	mov    %eax,(%esp)
  801874:	e8 4e ef ff ff       	call   8007c7 <strcpy>
	return 0;
}
  801879:	b8 00 00 00 00       	mov    $0x0,%eax
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	53                   	push   %ebx
  801884:	83 ec 14             	sub    $0x14,%esp
  801887:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80188a:	89 1c 24             	mov    %ebx,(%esp)
  80188d:	e8 65 0b 00 00       	call   8023f7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801892:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801897:	83 f8 01             	cmp    $0x1,%eax
  80189a:	75 0d                	jne    8018a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80189c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80189f:	89 04 24             	mov    %eax,(%esp)
  8018a2:	e8 29 03 00 00       	call   801bd0 <nsipc_close>
  8018a7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8018a9:	89 d0                	mov    %edx,%eax
  8018ab:	83 c4 14             	add    $0x14,%esp
  8018ae:	5b                   	pop    %ebx
  8018af:	5d                   	pop    %ebp
  8018b0:	c3                   	ret    

008018b1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018be:	00 
  8018bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d3:	89 04 24             	mov    %eax,(%esp)
  8018d6:	e8 f0 03 00 00       	call   801ccb <nsipc_send>
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018ea:	00 
  8018eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ff:	89 04 24             	mov    %eax,(%esp)
  801902:	e8 44 03 00 00       	call   801c4b <nsipc_recv>
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80190f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801912:	89 54 24 04          	mov    %edx,0x4(%esp)
  801916:	89 04 24             	mov    %eax,(%esp)
  801919:	e8 98 f6 ff ff       	call   800fb6 <fd_lookup>
  80191e:	85 c0                	test   %eax,%eax
  801920:	78 17                	js     801939 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801925:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80192b:	39 08                	cmp    %ecx,(%eax)
  80192d:	75 05                	jne    801934 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80192f:	8b 40 0c             	mov    0xc(%eax),%eax
  801932:	eb 05                	jmp    801939 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801934:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	56                   	push   %esi
  80193f:	53                   	push   %ebx
  801940:	83 ec 20             	sub    $0x20,%esp
  801943:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801945:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801948:	89 04 24             	mov    %eax,(%esp)
  80194b:	e8 17 f6 ff ff       	call   800f67 <fd_alloc>
  801950:	89 c3                	mov    %eax,%ebx
  801952:	85 c0                	test   %eax,%eax
  801954:	78 21                	js     801977 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801956:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80195d:	00 
  80195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801961:	89 44 24 04          	mov    %eax,0x4(%esp)
  801965:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80196c:	e8 c4 f2 ff ff       	call   800c35 <sys_page_alloc>
  801971:	89 c3                	mov    %eax,%ebx
  801973:	85 c0                	test   %eax,%eax
  801975:	79 0c                	jns    801983 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801977:	89 34 24             	mov    %esi,(%esp)
  80197a:	e8 51 02 00 00       	call   801bd0 <nsipc_close>
		return r;
  80197f:	89 d8                	mov    %ebx,%eax
  801981:	eb 20                	jmp    8019a3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801983:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80198e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801991:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801998:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80199b:	89 14 24             	mov    %edx,(%esp)
  80199e:	e8 9d f5 ff ff       	call   800f40 <fd2num>
}
  8019a3:	83 c4 20             	add    $0x20,%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5e                   	pop    %esi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    

008019aa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	e8 51 ff ff ff       	call   801909 <fd2sockid>
		return r;
  8019b8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	78 23                	js     8019e1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019be:	8b 55 10             	mov    0x10(%ebp),%edx
  8019c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019cc:	89 04 24             	mov    %eax,(%esp)
  8019cf:	e8 45 01 00 00       	call   801b19 <nsipc_accept>
		return r;
  8019d4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	78 07                	js     8019e1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8019da:	e8 5c ff ff ff       	call   80193b <alloc_sockfd>
  8019df:	89 c1                	mov    %eax,%ecx
}
  8019e1:	89 c8                	mov    %ecx,%eax
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	e8 16 ff ff ff       	call   801909 <fd2sockid>
  8019f3:	89 c2                	mov    %eax,%edx
  8019f5:	85 d2                	test   %edx,%edx
  8019f7:	78 16                	js     801a0f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8019f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a07:	89 14 24             	mov    %edx,(%esp)
  801a0a:	e8 60 01 00 00       	call   801b6f <nsipc_bind>
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <shutdown>:

int
shutdown(int s, int how)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	e8 ea fe ff ff       	call   801909 <fd2sockid>
  801a1f:	89 c2                	mov    %eax,%edx
  801a21:	85 d2                	test   %edx,%edx
  801a23:	78 0f                	js     801a34 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2c:	89 14 24             	mov    %edx,(%esp)
  801a2f:	e8 7a 01 00 00       	call   801bae <nsipc_shutdown>
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	e8 c5 fe ff ff       	call   801909 <fd2sockid>
  801a44:	89 c2                	mov    %eax,%edx
  801a46:	85 d2                	test   %edx,%edx
  801a48:	78 16                	js     801a60 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a58:	89 14 24             	mov    %edx,(%esp)
  801a5b:	e8 8a 01 00 00       	call   801bea <nsipc_connect>
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <listen>:

int
listen(int s, int backlog)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	e8 99 fe ff ff       	call   801909 <fd2sockid>
  801a70:	89 c2                	mov    %eax,%edx
  801a72:	85 d2                	test   %edx,%edx
  801a74:	78 0f                	js     801a85 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7d:	89 14 24             	mov    %edx,(%esp)
  801a80:	e8 a4 01 00 00       	call   801c29 <nsipc_listen>
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	89 04 24             	mov    %eax,(%esp)
  801aa1:	e8 98 02 00 00       	call   801d3e <nsipc_socket>
  801aa6:	89 c2                	mov    %eax,%edx
  801aa8:	85 d2                	test   %edx,%edx
  801aaa:	78 05                	js     801ab1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801aac:	e8 8a fe ff ff       	call   80193b <alloc_sockfd>
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 14             	sub    $0x14,%esp
  801aba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801abc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ac3:	75 11                	jne    801ad6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ac5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801acc:	e8 ee 08 00 00       	call   8023bf <ipc_find_env>
  801ad1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ad6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801add:	00 
  801ade:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ae5:	00 
  801ae6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aea:	a1 04 40 80 00       	mov    0x804004,%eax
  801aef:	89 04 24             	mov    %eax,(%esp)
  801af2:	e8 61 08 00 00       	call   802358 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801af7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801afe:	00 
  801aff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b06:	00 
  801b07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b0e:	e8 dd 07 00 00       	call   8022f0 <ipc_recv>
}
  801b13:	83 c4 14             	add    $0x14,%esp
  801b16:	5b                   	pop    %ebx
  801b17:	5d                   	pop    %ebp
  801b18:	c3                   	ret    

00801b19 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	56                   	push   %esi
  801b1d:	53                   	push   %ebx
  801b1e:	83 ec 10             	sub    $0x10,%esp
  801b21:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b2c:	8b 06                	mov    (%esi),%eax
  801b2e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b33:	b8 01 00 00 00       	mov    $0x1,%eax
  801b38:	e8 76 ff ff ff       	call   801ab3 <nsipc>
  801b3d:	89 c3                	mov    %eax,%ebx
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	78 23                	js     801b66 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b43:	a1 10 60 80 00       	mov    0x806010,%eax
  801b48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b4c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b53:	00 
  801b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b57:	89 04 24             	mov    %eax,(%esp)
  801b5a:	e8 05 ee ff ff       	call   800964 <memmove>
		*addrlen = ret->ret_addrlen;
  801b5f:	a1 10 60 80 00       	mov    0x806010,%eax
  801b64:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801b66:	89 d8                	mov    %ebx,%eax
  801b68:	83 c4 10             	add    $0x10,%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5d                   	pop    %ebp
  801b6e:	c3                   	ret    

00801b6f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	53                   	push   %ebx
  801b73:	83 ec 14             	sub    $0x14,%esp
  801b76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b93:	e8 cc ed ff ff       	call   800964 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b98:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b9e:	b8 02 00 00 00       	mov    $0x2,%eax
  801ba3:	e8 0b ff ff ff       	call   801ab3 <nsipc>
}
  801ba8:	83 c4 14             	add    $0x14,%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5d                   	pop    %ebp
  801bad:	c3                   	ret    

00801bae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bc4:	b8 03 00 00 00       	mov    $0x3,%eax
  801bc9:	e8 e5 fe ff ff       	call   801ab3 <nsipc>
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <nsipc_close>:

int
nsipc_close(int s)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bde:	b8 04 00 00 00       	mov    $0x4,%eax
  801be3:	e8 cb fe ff ff       	call   801ab3 <nsipc>
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	53                   	push   %ebx
  801bee:	83 ec 14             	sub    $0x14,%esp
  801bf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bfc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c07:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c0e:	e8 51 ed ff ff       	call   800964 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c13:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c19:	b8 05 00 00 00       	mov    $0x5,%eax
  801c1e:	e8 90 fe ff ff       	call   801ab3 <nsipc>
}
  801c23:	83 c4 14             	add    $0x14,%esp
  801c26:	5b                   	pop    %ebx
  801c27:	5d                   	pop    %ebp
  801c28:	c3                   	ret    

00801c29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c3f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c44:	e8 6a fe ff ff       	call   801ab3 <nsipc>
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 10             	sub    $0x10,%esp
  801c53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c5e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c6c:	b8 07 00 00 00       	mov    $0x7,%eax
  801c71:	e8 3d fe ff ff       	call   801ab3 <nsipc>
  801c76:	89 c3                	mov    %eax,%ebx
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	78 46                	js     801cc2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801c7c:	39 f0                	cmp    %esi,%eax
  801c7e:	7f 07                	jg     801c87 <nsipc_recv+0x3c>
  801c80:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c85:	7e 24                	jle    801cab <nsipc_recv+0x60>
  801c87:	c7 44 24 0c 51 2b 80 	movl   $0x802b51,0xc(%esp)
  801c8e:	00 
  801c8f:	c7 44 24 08 00 2b 80 	movl   $0x802b00,0x8(%esp)
  801c96:	00 
  801c97:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801c9e:	00 
  801c9f:	c7 04 24 66 2b 80 00 	movl   $0x802b66,(%esp)
  801ca6:	e8 eb 05 00 00       	call   802296 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cab:	89 44 24 08          	mov    %eax,0x8(%esp)
  801caf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cb6:	00 
  801cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cba:	89 04 24             	mov    %eax,(%esp)
  801cbd:	e8 a2 ec ff ff       	call   800964 <memmove>
	}

	return r;
}
  801cc2:	89 d8                	mov    %ebx,%eax
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5d                   	pop    %ebp
  801cca:	c3                   	ret    

00801ccb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 14             	sub    $0x14,%esp
  801cd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801cdd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ce3:	7e 24                	jle    801d09 <nsipc_send+0x3e>
  801ce5:	c7 44 24 0c 72 2b 80 	movl   $0x802b72,0xc(%esp)
  801cec:	00 
  801ced:	c7 44 24 08 00 2b 80 	movl   $0x802b00,0x8(%esp)
  801cf4:	00 
  801cf5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801cfc:	00 
  801cfd:	c7 04 24 66 2b 80 00 	movl   $0x802b66,(%esp)
  801d04:	e8 8d 05 00 00       	call   802296 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d14:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801d1b:	e8 44 ec ff ff       	call   800964 <memmove>
	nsipcbuf.send.req_size = size;
  801d20:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d26:	8b 45 14             	mov    0x14(%ebp),%eax
  801d29:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d2e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d33:	e8 7b fd ff ff       	call   801ab3 <nsipc>
}
  801d38:	83 c4 14             	add    $0x14,%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5d                   	pop    %ebp
  801d3d:	c3                   	ret    

00801d3e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d5c:	b8 09 00 00 00       	mov    $0x9,%eax
  801d61:	e8 4d fd ff ff       	call   801ab3 <nsipc>
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	56                   	push   %esi
  801d6c:	53                   	push   %ebx
  801d6d:	83 ec 10             	sub    $0x10,%esp
  801d70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	89 04 24             	mov    %eax,(%esp)
  801d79:	e8 d2 f1 ff ff       	call   800f50 <fd2data>
  801d7e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d80:	c7 44 24 04 7e 2b 80 	movl   $0x802b7e,0x4(%esp)
  801d87:	00 
  801d88:	89 1c 24             	mov    %ebx,(%esp)
  801d8b:	e8 37 ea ff ff       	call   8007c7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d90:	8b 46 04             	mov    0x4(%esi),%eax
  801d93:	2b 06                	sub    (%esi),%eax
  801d95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801da2:	00 00 00 
	stat->st_dev = &devpipe;
  801da5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dac:	30 80 00 
	return 0;
}
  801daf:	b8 00 00 00 00       	mov    $0x0,%eax
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5d                   	pop    %ebp
  801dba:	c3                   	ret    

00801dbb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	53                   	push   %ebx
  801dbf:	83 ec 14             	sub    $0x14,%esp
  801dc2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dc5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dd0:	e8 07 ef ff ff       	call   800cdc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dd5:	89 1c 24             	mov    %ebx,(%esp)
  801dd8:	e8 73 f1 ff ff       	call   800f50 <fd2data>
  801ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801de8:	e8 ef ee ff ff       	call   800cdc <sys_page_unmap>
}
  801ded:	83 c4 14             	add    $0x14,%esp
  801df0:	5b                   	pop    %ebx
  801df1:	5d                   	pop    %ebp
  801df2:	c3                   	ret    

00801df3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	57                   	push   %edi
  801df7:	56                   	push   %esi
  801df8:	53                   	push   %ebx
  801df9:	83 ec 2c             	sub    $0x2c,%esp
  801dfc:	89 c6                	mov    %eax,%esi
  801dfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e01:	a1 08 40 80 00       	mov    0x804008,%eax
  801e06:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e09:	89 34 24             	mov    %esi,(%esp)
  801e0c:	e8 e6 05 00 00       	call   8023f7 <pageref>
  801e11:	89 c7                	mov    %eax,%edi
  801e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e16:	89 04 24             	mov    %eax,(%esp)
  801e19:	e8 d9 05 00 00       	call   8023f7 <pageref>
  801e1e:	39 c7                	cmp    %eax,%edi
  801e20:	0f 94 c2             	sete   %dl
  801e23:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e26:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801e2c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e2f:	39 fb                	cmp    %edi,%ebx
  801e31:	74 21                	je     801e54 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e33:	84 d2                	test   %dl,%dl
  801e35:	74 ca                	je     801e01 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e37:	8b 51 58             	mov    0x58(%ecx),%edx
  801e3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e3e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e46:	c7 04 24 85 2b 80 00 	movl   $0x802b85,(%esp)
  801e4d:	e8 02 e3 ff ff       	call   800154 <cprintf>
  801e52:	eb ad                	jmp    801e01 <_pipeisclosed+0xe>
	}
}
  801e54:	83 c4 2c             	add    $0x2c,%esp
  801e57:	5b                   	pop    %ebx
  801e58:	5e                   	pop    %esi
  801e59:	5f                   	pop    %edi
  801e5a:	5d                   	pop    %ebp
  801e5b:	c3                   	ret    

00801e5c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	57                   	push   %edi
  801e60:	56                   	push   %esi
  801e61:	53                   	push   %ebx
  801e62:	83 ec 1c             	sub    $0x1c,%esp
  801e65:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e68:	89 34 24             	mov    %esi,(%esp)
  801e6b:	e8 e0 f0 ff ff       	call   800f50 <fd2data>
  801e70:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e72:	bf 00 00 00 00       	mov    $0x0,%edi
  801e77:	eb 45                	jmp    801ebe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e79:	89 da                	mov    %ebx,%edx
  801e7b:	89 f0                	mov    %esi,%eax
  801e7d:	e8 71 ff ff ff       	call   801df3 <_pipeisclosed>
  801e82:	85 c0                	test   %eax,%eax
  801e84:	75 41                	jne    801ec7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e86:	e8 8b ed ff ff       	call   800c16 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e8b:	8b 43 04             	mov    0x4(%ebx),%eax
  801e8e:	8b 0b                	mov    (%ebx),%ecx
  801e90:	8d 51 20             	lea    0x20(%ecx),%edx
  801e93:	39 d0                	cmp    %edx,%eax
  801e95:	73 e2                	jae    801e79 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e9a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e9e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ea1:	99                   	cltd   
  801ea2:	c1 ea 1b             	shr    $0x1b,%edx
  801ea5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ea8:	83 e1 1f             	and    $0x1f,%ecx
  801eab:	29 d1                	sub    %edx,%ecx
  801ead:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801eb1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801eb5:	83 c0 01             	add    $0x1,%eax
  801eb8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ebb:	83 c7 01             	add    $0x1,%edi
  801ebe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ec1:	75 c8                	jne    801e8b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801ec3:	89 f8                	mov    %edi,%eax
  801ec5:	eb 05                	jmp    801ecc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ecc:	83 c4 1c             	add    $0x1c,%esp
  801ecf:	5b                   	pop    %ebx
  801ed0:	5e                   	pop    %esi
  801ed1:	5f                   	pop    %edi
  801ed2:	5d                   	pop    %ebp
  801ed3:	c3                   	ret    

00801ed4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	57                   	push   %edi
  801ed8:	56                   	push   %esi
  801ed9:	53                   	push   %ebx
  801eda:	83 ec 1c             	sub    $0x1c,%esp
  801edd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ee0:	89 3c 24             	mov    %edi,(%esp)
  801ee3:	e8 68 f0 ff ff       	call   800f50 <fd2data>
  801ee8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eea:	be 00 00 00 00       	mov    $0x0,%esi
  801eef:	eb 3d                	jmp    801f2e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ef1:	85 f6                	test   %esi,%esi
  801ef3:	74 04                	je     801ef9 <devpipe_read+0x25>
				return i;
  801ef5:	89 f0                	mov    %esi,%eax
  801ef7:	eb 43                	jmp    801f3c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ef9:	89 da                	mov    %ebx,%edx
  801efb:	89 f8                	mov    %edi,%eax
  801efd:	e8 f1 fe ff ff       	call   801df3 <_pipeisclosed>
  801f02:	85 c0                	test   %eax,%eax
  801f04:	75 31                	jne    801f37 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f06:	e8 0b ed ff ff       	call   800c16 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f0b:	8b 03                	mov    (%ebx),%eax
  801f0d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f10:	74 df                	je     801ef1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f12:	99                   	cltd   
  801f13:	c1 ea 1b             	shr    $0x1b,%edx
  801f16:	01 d0                	add    %edx,%eax
  801f18:	83 e0 1f             	and    $0x1f,%eax
  801f1b:	29 d0                	sub    %edx,%eax
  801f1d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f25:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f28:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f2b:	83 c6 01             	add    $0x1,%esi
  801f2e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f31:	75 d8                	jne    801f0b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f33:	89 f0                	mov    %esi,%eax
  801f35:	eb 05                	jmp    801f3c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f3c:	83 c4 1c             	add    $0x1c,%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5e                   	pop    %esi
  801f41:	5f                   	pop    %edi
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    

00801f44 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	56                   	push   %esi
  801f48:	53                   	push   %ebx
  801f49:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4f:	89 04 24             	mov    %eax,(%esp)
  801f52:	e8 10 f0 ff ff       	call   800f67 <fd_alloc>
  801f57:	89 c2                	mov    %eax,%edx
  801f59:	85 d2                	test   %edx,%edx
  801f5b:	0f 88 4d 01 00 00    	js     8020ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f61:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f68:	00 
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f77:	e8 b9 ec ff ff       	call   800c35 <sys_page_alloc>
  801f7c:	89 c2                	mov    %eax,%edx
  801f7e:	85 d2                	test   %edx,%edx
  801f80:	0f 88 28 01 00 00    	js     8020ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f89:	89 04 24             	mov    %eax,(%esp)
  801f8c:	e8 d6 ef ff ff       	call   800f67 <fd_alloc>
  801f91:	89 c3                	mov    %eax,%ebx
  801f93:	85 c0                	test   %eax,%eax
  801f95:	0f 88 fe 00 00 00    	js     802099 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fa2:	00 
  801fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801faa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb1:	e8 7f ec ff ff       	call   800c35 <sys_page_alloc>
  801fb6:	89 c3                	mov    %eax,%ebx
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	0f 88 d9 00 00 00    	js     802099 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	89 04 24             	mov    %eax,(%esp)
  801fc6:	e8 85 ef ff ff       	call   800f50 <fd2data>
  801fcb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fcd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fd4:	00 
  801fd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe0:	e8 50 ec ff ff       	call   800c35 <sys_page_alloc>
  801fe5:	89 c3                	mov    %eax,%ebx
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	0f 88 97 00 00 00    	js     802086 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff2:	89 04 24             	mov    %eax,(%esp)
  801ff5:	e8 56 ef ff ff       	call   800f50 <fd2data>
  801ffa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802001:	00 
  802002:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802006:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80200d:	00 
  80200e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802012:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802019:	e8 6b ec ff ff       	call   800c89 <sys_page_map>
  80201e:	89 c3                	mov    %eax,%ebx
  802020:	85 c0                	test   %eax,%eax
  802022:	78 52                	js     802076 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802024:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802039:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80203f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802042:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802047:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	89 04 24             	mov    %eax,(%esp)
  802054:	e8 e7 ee ff ff       	call   800f40 <fd2num>
  802059:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80205c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80205e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802061:	89 04 24             	mov    %eax,(%esp)
  802064:	e8 d7 ee ff ff       	call   800f40 <fd2num>
  802069:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
  802074:	eb 38                	jmp    8020ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802076:	89 74 24 04          	mov    %esi,0x4(%esp)
  80207a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802081:	e8 56 ec ff ff       	call   800cdc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802089:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802094:	e8 43 ec ff ff       	call   800cdc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a7:	e8 30 ec ff ff       	call   800cdc <sys_page_unmap>
  8020ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8020ae:	83 c4 30             	add    $0x30,%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5d                   	pop    %ebp
  8020b4:	c3                   	ret    

008020b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	89 04 24             	mov    %eax,(%esp)
  8020c8:	e8 e9 ee ff ff       	call   800fb6 <fd_lookup>
  8020cd:	89 c2                	mov    %eax,%edx
  8020cf:	85 d2                	test   %edx,%edx
  8020d1:	78 15                	js     8020e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d6:	89 04 24             	mov    %eax,(%esp)
  8020d9:	e8 72 ee ff ff       	call   800f50 <fd2data>
	return _pipeisclosed(fd, p);
  8020de:	89 c2                	mov    %eax,%edx
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	e8 0b fd ff ff       	call   801df3 <_pipeisclosed>
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    
  8020ea:	66 90                	xchg   %ax,%ax
  8020ec:	66 90                	xchg   %ax,%ax
  8020ee:	66 90                	xchg   %ax,%ax

008020f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	5d                   	pop    %ebp
  8020f9:	c3                   	ret    

008020fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802100:	c7 44 24 04 9d 2b 80 	movl   $0x802b9d,0x4(%esp)
  802107:	00 
  802108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210b:	89 04 24             	mov    %eax,(%esp)
  80210e:	e8 b4 e6 ff ff       	call   8007c7 <strcpy>
	return 0;
}
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	57                   	push   %edi
  80211e:	56                   	push   %esi
  80211f:	53                   	push   %ebx
  802120:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802126:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80212b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802131:	eb 31                	jmp    802164 <devcons_write+0x4a>
		m = n - tot;
  802133:	8b 75 10             	mov    0x10(%ebp),%esi
  802136:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802138:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80213b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802140:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802143:	89 74 24 08          	mov    %esi,0x8(%esp)
  802147:	03 45 0c             	add    0xc(%ebp),%eax
  80214a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214e:	89 3c 24             	mov    %edi,(%esp)
  802151:	e8 0e e8 ff ff       	call   800964 <memmove>
		sys_cputs(buf, m);
  802156:	89 74 24 04          	mov    %esi,0x4(%esp)
  80215a:	89 3c 24             	mov    %edi,(%esp)
  80215d:	e8 b4 e9 ff ff       	call   800b16 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802162:	01 f3                	add    %esi,%ebx
  802164:	89 d8                	mov    %ebx,%eax
  802166:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802169:	72 c8                	jb     802133 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80216b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5f                   	pop    %edi
  802174:	5d                   	pop    %ebp
  802175:	c3                   	ret    

00802176 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802181:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802185:	75 07                	jne    80218e <devcons_read+0x18>
  802187:	eb 2a                	jmp    8021b3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802189:	e8 88 ea ff ff       	call   800c16 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80218e:	66 90                	xchg   %ax,%ax
  802190:	e8 9f e9 ff ff       	call   800b34 <sys_cgetc>
  802195:	85 c0                	test   %eax,%eax
  802197:	74 f0                	je     802189 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802199:	85 c0                	test   %eax,%eax
  80219b:	78 16                	js     8021b3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80219d:	83 f8 04             	cmp    $0x4,%eax
  8021a0:	74 0c                	je     8021ae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8021a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a5:	88 02                	mov    %al,(%edx)
	return 1;
  8021a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ac:	eb 05                	jmp    8021b3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021c8:	00 
  8021c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021cc:	89 04 24             	mov    %eax,(%esp)
  8021cf:	e8 42 e9 ff ff       	call   800b16 <sys_cputs>
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <getchar>:

int
getchar(void)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8021dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8021e3:	00 
  8021e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f2:	e8 53 f0 ff ff       	call   80124a <read>
	if (r < 0)
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	78 0f                	js     80220a <getchar+0x34>
		return r;
	if (r < 1)
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	7e 06                	jle    802205 <getchar+0x2f>
		return -E_EOF;
	return c;
  8021ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802203:	eb 05                	jmp    80220a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802205:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802212:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802215:	89 44 24 04          	mov    %eax,0x4(%esp)
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	89 04 24             	mov    %eax,(%esp)
  80221f:	e8 92 ed ff ff       	call   800fb6 <fd_lookup>
  802224:	85 c0                	test   %eax,%eax
  802226:	78 11                	js     802239 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802231:	39 10                	cmp    %edx,(%eax)
  802233:	0f 94 c0             	sete   %al
  802236:	0f b6 c0             	movzbl %al,%eax
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <opencons>:

int
opencons(void)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802241:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802244:	89 04 24             	mov    %eax,(%esp)
  802247:	e8 1b ed ff ff       	call   800f67 <fd_alloc>
		return r;
  80224c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80224e:	85 c0                	test   %eax,%eax
  802250:	78 40                	js     802292 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802252:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802259:	00 
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802261:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802268:	e8 c8 e9 ff ff       	call   800c35 <sys_page_alloc>
		return r;
  80226d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80226f:	85 c0                	test   %eax,%eax
  802271:	78 1f                	js     802292 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802273:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802288:	89 04 24             	mov    %eax,(%esp)
  80228b:	e8 b0 ec ff ff       	call   800f40 <fd2num>
  802290:	89 c2                	mov    %eax,%edx
}
  802292:	89 d0                	mov    %edx,%eax
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	56                   	push   %esi
  80229a:	53                   	push   %ebx
  80229b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80229e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022a1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8022a7:	e8 4b e9 ff ff       	call   800bf7 <sys_getenvid>
  8022ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022af:	89 54 24 10          	mov    %edx,0x10(%esp)
  8022b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022ba:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c2:	c7 04 24 ac 2b 80 00 	movl   $0x802bac,(%esp)
  8022c9:	e8 86 de ff ff       	call   800154 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d5:	89 04 24             	mov    %eax,(%esp)
  8022d8:	e8 16 de ff ff       	call   8000f3 <vcprintf>
	cprintf("\n");
  8022dd:	c7 04 24 43 2b 80 00 	movl   $0x802b43,(%esp)
  8022e4:	e8 6b de ff ff       	call   800154 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022e9:	cc                   	int3   
  8022ea:	eb fd                	jmp    8022e9 <_panic+0x53>
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	56                   	push   %esi
  8022f4:	53                   	push   %ebx
  8022f5:	83 ec 10             	sub    $0x10,%esp
  8022f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802301:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802303:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802308:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80230b:	89 04 24             	mov    %eax,(%esp)
  80230e:	e8 58 eb ff ff       	call   800e6b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802313:	85 c0                	test   %eax,%eax
  802315:	75 26                	jne    80233d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802317:	85 f6                	test   %esi,%esi
  802319:	74 0a                	je     802325 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80231b:	a1 08 40 80 00       	mov    0x804008,%eax
  802320:	8b 40 74             	mov    0x74(%eax),%eax
  802323:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802325:	85 db                	test   %ebx,%ebx
  802327:	74 0a                	je     802333 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802329:	a1 08 40 80 00       	mov    0x804008,%eax
  80232e:	8b 40 78             	mov    0x78(%eax),%eax
  802331:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802333:	a1 08 40 80 00       	mov    0x804008,%eax
  802338:	8b 40 70             	mov    0x70(%eax),%eax
  80233b:	eb 14                	jmp    802351 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80233d:	85 f6                	test   %esi,%esi
  80233f:	74 06                	je     802347 <ipc_recv+0x57>
			*from_env_store = 0;
  802341:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802347:	85 db                	test   %ebx,%ebx
  802349:	74 06                	je     802351 <ipc_recv+0x61>
			*perm_store = 0;
  80234b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802351:	83 c4 10             	add    $0x10,%esp
  802354:	5b                   	pop    %ebx
  802355:	5e                   	pop    %esi
  802356:	5d                   	pop    %ebp
  802357:	c3                   	ret    

00802358 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	57                   	push   %edi
  80235c:	56                   	push   %esi
  80235d:	53                   	push   %ebx
  80235e:	83 ec 1c             	sub    $0x1c,%esp
  802361:	8b 7d 08             	mov    0x8(%ebp),%edi
  802364:	8b 75 0c             	mov    0xc(%ebp),%esi
  802367:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80236a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80236c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802371:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802374:	8b 45 14             	mov    0x14(%ebp),%eax
  802377:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80237b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80237f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802383:	89 3c 24             	mov    %edi,(%esp)
  802386:	e8 bd ea ff ff       	call   800e48 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80238b:	85 c0                	test   %eax,%eax
  80238d:	74 28                	je     8023b7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80238f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802392:	74 1c                	je     8023b0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802394:	c7 44 24 08 d0 2b 80 	movl   $0x802bd0,0x8(%esp)
  80239b:	00 
  80239c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8023a3:	00 
  8023a4:	c7 04 24 f4 2b 80 00 	movl   $0x802bf4,(%esp)
  8023ab:	e8 e6 fe ff ff       	call   802296 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8023b0:	e8 61 e8 ff ff       	call   800c16 <sys_yield>
	}
  8023b5:	eb bd                	jmp    802374 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8023b7:	83 c4 1c             	add    $0x1c,%esp
  8023ba:	5b                   	pop    %ebx
  8023bb:	5e                   	pop    %esi
  8023bc:	5f                   	pop    %edi
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023ca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023cd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023d3:	8b 52 50             	mov    0x50(%edx),%edx
  8023d6:	39 ca                	cmp    %ecx,%edx
  8023d8:	75 0d                	jne    8023e7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8023da:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023dd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8023e2:	8b 40 40             	mov    0x40(%eax),%eax
  8023e5:	eb 0e                	jmp    8023f5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023e7:	83 c0 01             	add    $0x1,%eax
  8023ea:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023ef:	75 d9                	jne    8023ca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023f1:	66 b8 00 00          	mov    $0x0,%ax
}
  8023f5:	5d                   	pop    %ebp
  8023f6:	c3                   	ret    

008023f7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
  8023fa:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023fd:	89 d0                	mov    %edx,%eax
  8023ff:	c1 e8 16             	shr    $0x16,%eax
  802402:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802409:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80240e:	f6 c1 01             	test   $0x1,%cl
  802411:	74 1d                	je     802430 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802413:	c1 ea 0c             	shr    $0xc,%edx
  802416:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80241d:	f6 c2 01             	test   $0x1,%dl
  802420:	74 0e                	je     802430 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802422:	c1 ea 0c             	shr    $0xc,%edx
  802425:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80242c:	ef 
  80242d:	0f b7 c0             	movzwl %ax,%eax
}
  802430:	5d                   	pop    %ebp
  802431:	c3                   	ret    
  802432:	66 90                	xchg   %ax,%ax
  802434:	66 90                	xchg   %ax,%ax
  802436:	66 90                	xchg   %ax,%ax
  802438:	66 90                	xchg   %ax,%ax
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	66 90                	xchg   %ax,%ax
  80243e:	66 90                	xchg   %ax,%ax

00802440 <__udivdi3>:
  802440:	55                   	push   %ebp
  802441:	57                   	push   %edi
  802442:	56                   	push   %esi
  802443:	83 ec 0c             	sub    $0xc,%esp
  802446:	8b 44 24 28          	mov    0x28(%esp),%eax
  80244a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80244e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802452:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802456:	85 c0                	test   %eax,%eax
  802458:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80245c:	89 ea                	mov    %ebp,%edx
  80245e:	89 0c 24             	mov    %ecx,(%esp)
  802461:	75 2d                	jne    802490 <__udivdi3+0x50>
  802463:	39 e9                	cmp    %ebp,%ecx
  802465:	77 61                	ja     8024c8 <__udivdi3+0x88>
  802467:	85 c9                	test   %ecx,%ecx
  802469:	89 ce                	mov    %ecx,%esi
  80246b:	75 0b                	jne    802478 <__udivdi3+0x38>
  80246d:	b8 01 00 00 00       	mov    $0x1,%eax
  802472:	31 d2                	xor    %edx,%edx
  802474:	f7 f1                	div    %ecx
  802476:	89 c6                	mov    %eax,%esi
  802478:	31 d2                	xor    %edx,%edx
  80247a:	89 e8                	mov    %ebp,%eax
  80247c:	f7 f6                	div    %esi
  80247e:	89 c5                	mov    %eax,%ebp
  802480:	89 f8                	mov    %edi,%eax
  802482:	f7 f6                	div    %esi
  802484:	89 ea                	mov    %ebp,%edx
  802486:	83 c4 0c             	add    $0xc,%esp
  802489:	5e                   	pop    %esi
  80248a:	5f                   	pop    %edi
  80248b:	5d                   	pop    %ebp
  80248c:	c3                   	ret    
  80248d:	8d 76 00             	lea    0x0(%esi),%esi
  802490:	39 e8                	cmp    %ebp,%eax
  802492:	77 24                	ja     8024b8 <__udivdi3+0x78>
  802494:	0f bd e8             	bsr    %eax,%ebp
  802497:	83 f5 1f             	xor    $0x1f,%ebp
  80249a:	75 3c                	jne    8024d8 <__udivdi3+0x98>
  80249c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024a0:	39 34 24             	cmp    %esi,(%esp)
  8024a3:	0f 86 9f 00 00 00    	jbe    802548 <__udivdi3+0x108>
  8024a9:	39 d0                	cmp    %edx,%eax
  8024ab:	0f 82 97 00 00 00    	jb     802548 <__udivdi3+0x108>
  8024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	31 d2                	xor    %edx,%edx
  8024ba:	31 c0                	xor    %eax,%eax
  8024bc:	83 c4 0c             	add    $0xc,%esp
  8024bf:	5e                   	pop    %esi
  8024c0:	5f                   	pop    %edi
  8024c1:	5d                   	pop    %ebp
  8024c2:	c3                   	ret    
  8024c3:	90                   	nop
  8024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	89 f8                	mov    %edi,%eax
  8024ca:	f7 f1                	div    %ecx
  8024cc:	31 d2                	xor    %edx,%edx
  8024ce:	83 c4 0c             	add    $0xc,%esp
  8024d1:	5e                   	pop    %esi
  8024d2:	5f                   	pop    %edi
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    
  8024d5:	8d 76 00             	lea    0x0(%esi),%esi
  8024d8:	89 e9                	mov    %ebp,%ecx
  8024da:	8b 3c 24             	mov    (%esp),%edi
  8024dd:	d3 e0                	shl    %cl,%eax
  8024df:	89 c6                	mov    %eax,%esi
  8024e1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024e6:	29 e8                	sub    %ebp,%eax
  8024e8:	89 c1                	mov    %eax,%ecx
  8024ea:	d3 ef                	shr    %cl,%edi
  8024ec:	89 e9                	mov    %ebp,%ecx
  8024ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024f2:	8b 3c 24             	mov    (%esp),%edi
  8024f5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024f9:	89 d6                	mov    %edx,%esi
  8024fb:	d3 e7                	shl    %cl,%edi
  8024fd:	89 c1                	mov    %eax,%ecx
  8024ff:	89 3c 24             	mov    %edi,(%esp)
  802502:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802506:	d3 ee                	shr    %cl,%esi
  802508:	89 e9                	mov    %ebp,%ecx
  80250a:	d3 e2                	shl    %cl,%edx
  80250c:	89 c1                	mov    %eax,%ecx
  80250e:	d3 ef                	shr    %cl,%edi
  802510:	09 d7                	or     %edx,%edi
  802512:	89 f2                	mov    %esi,%edx
  802514:	89 f8                	mov    %edi,%eax
  802516:	f7 74 24 08          	divl   0x8(%esp)
  80251a:	89 d6                	mov    %edx,%esi
  80251c:	89 c7                	mov    %eax,%edi
  80251e:	f7 24 24             	mull   (%esp)
  802521:	39 d6                	cmp    %edx,%esi
  802523:	89 14 24             	mov    %edx,(%esp)
  802526:	72 30                	jb     802558 <__udivdi3+0x118>
  802528:	8b 54 24 04          	mov    0x4(%esp),%edx
  80252c:	89 e9                	mov    %ebp,%ecx
  80252e:	d3 e2                	shl    %cl,%edx
  802530:	39 c2                	cmp    %eax,%edx
  802532:	73 05                	jae    802539 <__udivdi3+0xf9>
  802534:	3b 34 24             	cmp    (%esp),%esi
  802537:	74 1f                	je     802558 <__udivdi3+0x118>
  802539:	89 f8                	mov    %edi,%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	e9 7a ff ff ff       	jmp    8024bc <__udivdi3+0x7c>
  802542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802548:	31 d2                	xor    %edx,%edx
  80254a:	b8 01 00 00 00       	mov    $0x1,%eax
  80254f:	e9 68 ff ff ff       	jmp    8024bc <__udivdi3+0x7c>
  802554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802558:	8d 47 ff             	lea    -0x1(%edi),%eax
  80255b:	31 d2                	xor    %edx,%edx
  80255d:	83 c4 0c             	add    $0xc,%esp
  802560:	5e                   	pop    %esi
  802561:	5f                   	pop    %edi
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    
  802564:	66 90                	xchg   %ax,%ax
  802566:	66 90                	xchg   %ax,%ax
  802568:	66 90                	xchg   %ax,%ax
  80256a:	66 90                	xchg   %ax,%ax
  80256c:	66 90                	xchg   %ax,%ax
  80256e:	66 90                	xchg   %ax,%ax

00802570 <__umoddi3>:
  802570:	55                   	push   %ebp
  802571:	57                   	push   %edi
  802572:	56                   	push   %esi
  802573:	83 ec 14             	sub    $0x14,%esp
  802576:	8b 44 24 28          	mov    0x28(%esp),%eax
  80257a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80257e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802582:	89 c7                	mov    %eax,%edi
  802584:	89 44 24 04          	mov    %eax,0x4(%esp)
  802588:	8b 44 24 30          	mov    0x30(%esp),%eax
  80258c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802590:	89 34 24             	mov    %esi,(%esp)
  802593:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802597:	85 c0                	test   %eax,%eax
  802599:	89 c2                	mov    %eax,%edx
  80259b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80259f:	75 17                	jne    8025b8 <__umoddi3+0x48>
  8025a1:	39 fe                	cmp    %edi,%esi
  8025a3:	76 4b                	jbe    8025f0 <__umoddi3+0x80>
  8025a5:	89 c8                	mov    %ecx,%eax
  8025a7:	89 fa                	mov    %edi,%edx
  8025a9:	f7 f6                	div    %esi
  8025ab:	89 d0                	mov    %edx,%eax
  8025ad:	31 d2                	xor    %edx,%edx
  8025af:	83 c4 14             	add    $0x14,%esp
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    
  8025b6:	66 90                	xchg   %ax,%ax
  8025b8:	39 f8                	cmp    %edi,%eax
  8025ba:	77 54                	ja     802610 <__umoddi3+0xa0>
  8025bc:	0f bd e8             	bsr    %eax,%ebp
  8025bf:	83 f5 1f             	xor    $0x1f,%ebp
  8025c2:	75 5c                	jne    802620 <__umoddi3+0xb0>
  8025c4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025c8:	39 3c 24             	cmp    %edi,(%esp)
  8025cb:	0f 87 e7 00 00 00    	ja     8026b8 <__umoddi3+0x148>
  8025d1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025d5:	29 f1                	sub    %esi,%ecx
  8025d7:	19 c7                	sbb    %eax,%edi
  8025d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025e1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025e5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025e9:	83 c4 14             	add    $0x14,%esp
  8025ec:	5e                   	pop    %esi
  8025ed:	5f                   	pop    %edi
  8025ee:	5d                   	pop    %ebp
  8025ef:	c3                   	ret    
  8025f0:	85 f6                	test   %esi,%esi
  8025f2:	89 f5                	mov    %esi,%ebp
  8025f4:	75 0b                	jne    802601 <__umoddi3+0x91>
  8025f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025fb:	31 d2                	xor    %edx,%edx
  8025fd:	f7 f6                	div    %esi
  8025ff:	89 c5                	mov    %eax,%ebp
  802601:	8b 44 24 04          	mov    0x4(%esp),%eax
  802605:	31 d2                	xor    %edx,%edx
  802607:	f7 f5                	div    %ebp
  802609:	89 c8                	mov    %ecx,%eax
  80260b:	f7 f5                	div    %ebp
  80260d:	eb 9c                	jmp    8025ab <__umoddi3+0x3b>
  80260f:	90                   	nop
  802610:	89 c8                	mov    %ecx,%eax
  802612:	89 fa                	mov    %edi,%edx
  802614:	83 c4 14             	add    $0x14,%esp
  802617:	5e                   	pop    %esi
  802618:	5f                   	pop    %edi
  802619:	5d                   	pop    %ebp
  80261a:	c3                   	ret    
  80261b:	90                   	nop
  80261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802620:	8b 04 24             	mov    (%esp),%eax
  802623:	be 20 00 00 00       	mov    $0x20,%esi
  802628:	89 e9                	mov    %ebp,%ecx
  80262a:	29 ee                	sub    %ebp,%esi
  80262c:	d3 e2                	shl    %cl,%edx
  80262e:	89 f1                	mov    %esi,%ecx
  802630:	d3 e8                	shr    %cl,%eax
  802632:	89 e9                	mov    %ebp,%ecx
  802634:	89 44 24 04          	mov    %eax,0x4(%esp)
  802638:	8b 04 24             	mov    (%esp),%eax
  80263b:	09 54 24 04          	or     %edx,0x4(%esp)
  80263f:	89 fa                	mov    %edi,%edx
  802641:	d3 e0                	shl    %cl,%eax
  802643:	89 f1                	mov    %esi,%ecx
  802645:	89 44 24 08          	mov    %eax,0x8(%esp)
  802649:	8b 44 24 10          	mov    0x10(%esp),%eax
  80264d:	d3 ea                	shr    %cl,%edx
  80264f:	89 e9                	mov    %ebp,%ecx
  802651:	d3 e7                	shl    %cl,%edi
  802653:	89 f1                	mov    %esi,%ecx
  802655:	d3 e8                	shr    %cl,%eax
  802657:	89 e9                	mov    %ebp,%ecx
  802659:	09 f8                	or     %edi,%eax
  80265b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80265f:	f7 74 24 04          	divl   0x4(%esp)
  802663:	d3 e7                	shl    %cl,%edi
  802665:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802669:	89 d7                	mov    %edx,%edi
  80266b:	f7 64 24 08          	mull   0x8(%esp)
  80266f:	39 d7                	cmp    %edx,%edi
  802671:	89 c1                	mov    %eax,%ecx
  802673:	89 14 24             	mov    %edx,(%esp)
  802676:	72 2c                	jb     8026a4 <__umoddi3+0x134>
  802678:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80267c:	72 22                	jb     8026a0 <__umoddi3+0x130>
  80267e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802682:	29 c8                	sub    %ecx,%eax
  802684:	19 d7                	sbb    %edx,%edi
  802686:	89 e9                	mov    %ebp,%ecx
  802688:	89 fa                	mov    %edi,%edx
  80268a:	d3 e8                	shr    %cl,%eax
  80268c:	89 f1                	mov    %esi,%ecx
  80268e:	d3 e2                	shl    %cl,%edx
  802690:	89 e9                	mov    %ebp,%ecx
  802692:	d3 ef                	shr    %cl,%edi
  802694:	09 d0                	or     %edx,%eax
  802696:	89 fa                	mov    %edi,%edx
  802698:	83 c4 14             	add    $0x14,%esp
  80269b:	5e                   	pop    %esi
  80269c:	5f                   	pop    %edi
  80269d:	5d                   	pop    %ebp
  80269e:	c3                   	ret    
  80269f:	90                   	nop
  8026a0:	39 d7                	cmp    %edx,%edi
  8026a2:	75 da                	jne    80267e <__umoddi3+0x10e>
  8026a4:	8b 14 24             	mov    (%esp),%edx
  8026a7:	89 c1                	mov    %eax,%ecx
  8026a9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026ad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026b1:	eb cb                	jmp    80267e <__umoddi3+0x10e>
  8026b3:	90                   	nop
  8026b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026b8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026bc:	0f 82 0f ff ff ff    	jb     8025d1 <__umoddi3+0x61>
  8026c2:	e9 1a ff ff ff       	jmp    8025e1 <__umoddi3+0x71>
