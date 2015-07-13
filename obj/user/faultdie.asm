
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 61 00 00 00       	call   800092 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
  800046:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800049:	8b 50 04             	mov    0x4(%eax),%edx
  80004c:	83 e2 07             	and    $0x7,%edx
  80004f:	89 54 24 08          	mov    %edx,0x8(%esp)
  800053:	8b 00                	mov    (%eax),%eax
  800055:	89 44 24 04          	mov    %eax,0x4(%esp)
  800059:	c7 04 24 e0 27 80 00 	movl   $0x8027e0,(%esp)
  800060:	e8 31 01 00 00       	call   800196 <cprintf>
	sys_env_destroy(sys_getenvid());
  800065:	e8 cd 0b 00 00       	call   800c37 <sys_getenvid>
  80006a:	89 04 24             	mov    %eax,(%esp)
  80006d:	e8 21 0b 00 00       	call   800b93 <sys_env_destroy>
}
  800072:	c9                   	leave  
  800073:	c3                   	ret    

00800074 <umain>:

void
umain(int argc, char **argv)
{
  800074:	55                   	push   %ebp
  800075:	89 e5                	mov    %esp,%ebp
  800077:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  80007a:	c7 04 24 40 00 80 00 	movl   $0x800040,(%esp)
  800081:	e8 f8 0e 00 00       	call   800f7e <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800086:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  80008d:	00 00 00 
}
  800090:	c9                   	leave  
  800091:	c3                   	ret    

00800092 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
  800097:	83 ec 10             	sub    $0x10,%esp
  80009a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80009d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a0:	e8 92 0b 00 00       	call   800c37 <sys_getenvid>
  8000a5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000aa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b2:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b7:	85 db                	test   %ebx,%ebx
  8000b9:	7e 07                	jle    8000c2 <libmain+0x30>
		binaryname = argv[0];
  8000bb:	8b 06                	mov    (%esi),%eax
  8000bd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	e8 a6 ff ff ff       	call   800074 <umain>

	// exit gracefully
	exit();
  8000ce:	e8 07 00 00 00       	call   8000da <exit>
}
  8000d3:	83 c4 10             	add    $0x10,%esp
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5d                   	pop    %ebp
  8000d9:	c3                   	ret    

008000da <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000e0:	e8 35 11 00 00       	call   80121a <close_all>
	sys_env_destroy(0);
  8000e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ec:	e8 a2 0a 00 00       	call   800b93 <sys_env_destroy>
}
  8000f1:	c9                   	leave  
  8000f2:	c3                   	ret    

008000f3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 14             	sub    $0x14,%esp
  8000fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000fd:	8b 13                	mov    (%ebx),%edx
  8000ff:	8d 42 01             	lea    0x1(%edx),%eax
  800102:	89 03                	mov    %eax,(%ebx)
  800104:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800107:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800110:	75 19                	jne    80012b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800112:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800119:	00 
  80011a:	8d 43 08             	lea    0x8(%ebx),%eax
  80011d:	89 04 24             	mov    %eax,(%esp)
  800120:	e8 31 0a 00 00       	call   800b56 <sys_cputs>
		b->idx = 0;
  800125:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80012b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80012f:	83 c4 14             	add    $0x14,%esp
  800132:	5b                   	pop    %ebx
  800133:	5d                   	pop    %ebp
  800134:	c3                   	ret    

00800135 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80013e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800145:	00 00 00 
	b.cnt = 0;
  800148:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80014f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800152:	8b 45 0c             	mov    0xc(%ebp),%eax
  800155:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800159:	8b 45 08             	mov    0x8(%ebp),%eax
  80015c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800160:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016a:	c7 04 24 f3 00 80 00 	movl   $0x8000f3,(%esp)
  800171:	e8 6e 01 00 00       	call   8002e4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800176:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80017c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800180:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800186:	89 04 24             	mov    %eax,(%esp)
  800189:	e8 c8 09 00 00       	call   800b56 <sys_cputs>

	return b.cnt;
}
  80018e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a6:	89 04 24             	mov    %eax,(%esp)
  8001a9:	e8 87 ff ff ff       	call   800135 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    

008001b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	57                   	push   %edi
  8001b4:	56                   	push   %esi
  8001b5:	53                   	push   %ebx
  8001b6:	83 ec 3c             	sub    $0x3c,%esp
  8001b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001bc:	89 d7                	mov    %edx,%edi
  8001be:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c7:	89 c3                	mov    %eax,%ebx
  8001c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001cf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001da:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001dd:	39 d9                	cmp    %ebx,%ecx
  8001df:	72 05                	jb     8001e6 <printnum+0x36>
  8001e1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e4:	77 69                	ja     80024f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001e9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001ed:	83 ee 01             	sub    $0x1,%esi
  8001f0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8001fc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800200:	89 c3                	mov    %eax,%ebx
  800202:	89 d6                	mov    %edx,%esi
  800204:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800207:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80020a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80020e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800212:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800215:	89 04 24             	mov    %eax,(%esp)
  800218:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80021b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021f:	e8 1c 23 00 00       	call   802540 <__udivdi3>
  800224:	89 d9                	mov    %ebx,%ecx
  800226:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80022a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80022e:	89 04 24             	mov    %eax,(%esp)
  800231:	89 54 24 04          	mov    %edx,0x4(%esp)
  800235:	89 fa                	mov    %edi,%edx
  800237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023a:	e8 71 ff ff ff       	call   8001b0 <printnum>
  80023f:	eb 1b                	jmp    80025c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800241:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800245:	8b 45 18             	mov    0x18(%ebp),%eax
  800248:	89 04 24             	mov    %eax,(%esp)
  80024b:	ff d3                	call   *%ebx
  80024d:	eb 03                	jmp    800252 <printnum+0xa2>
  80024f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800252:	83 ee 01             	sub    $0x1,%esi
  800255:	85 f6                	test   %esi,%esi
  800257:	7f e8                	jg     800241 <printnum+0x91>
  800259:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800260:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800264:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800267:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80026a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800275:	89 04 24             	mov    %eax,(%esp)
  800278:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027f:	e8 ec 23 00 00       	call   802670 <__umoddi3>
  800284:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800288:	0f be 80 06 28 80 00 	movsbl 0x802806(%eax),%eax
  80028f:	89 04 24             	mov    %eax,(%esp)
  800292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800295:	ff d0                	call   *%eax
}
  800297:	83 c4 3c             	add    $0x3c,%esp
  80029a:	5b                   	pop    %ebx
  80029b:	5e                   	pop    %esi
  80029c:	5f                   	pop    %edi
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    

0080029f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a9:	8b 10                	mov    (%eax),%edx
  8002ab:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ae:	73 0a                	jae    8002ba <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b3:	89 08                	mov    %ecx,(%eax)
  8002b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b8:	88 02                	mov    %al,(%edx)
}
  8002ba:	5d                   	pop    %ebp
  8002bb:	c3                   	ret    

008002bc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002c2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002da:	89 04 24             	mov    %eax,(%esp)
  8002dd:	e8 02 00 00 00       	call   8002e4 <vprintfmt>
	va_end(ap);
}
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	57                   	push   %edi
  8002e8:	56                   	push   %esi
  8002e9:	53                   	push   %ebx
  8002ea:	83 ec 3c             	sub    $0x3c,%esp
  8002ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f0:	eb 17                	jmp    800309 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8002f2:	85 c0                	test   %eax,%eax
  8002f4:	0f 84 4b 04 00 00    	je     800745 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8002fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800301:	89 04 24             	mov    %eax,(%esp)
  800304:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800307:	89 fb                	mov    %edi,%ebx
  800309:	8d 7b 01             	lea    0x1(%ebx),%edi
  80030c:	0f b6 03             	movzbl (%ebx),%eax
  80030f:	83 f8 25             	cmp    $0x25,%eax
  800312:	75 de                	jne    8002f2 <vprintfmt+0xe>
  800314:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800318:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80031f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800324:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80032b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800330:	eb 18                	jmp    80034a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800332:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800334:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800338:	eb 10                	jmp    80034a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80033c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800340:	eb 08                	jmp    80034a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800342:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800345:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80034a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80034d:	0f b6 17             	movzbl (%edi),%edx
  800350:	0f b6 c2             	movzbl %dl,%eax
  800353:	83 ea 23             	sub    $0x23,%edx
  800356:	80 fa 55             	cmp    $0x55,%dl
  800359:	0f 87 c2 03 00 00    	ja     800721 <vprintfmt+0x43d>
  80035f:	0f b6 d2             	movzbl %dl,%edx
  800362:	ff 24 95 40 29 80 00 	jmp    *0x802940(,%edx,4)
  800369:	89 df                	mov    %ebx,%edi
  80036b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800370:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800373:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800377:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80037a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80037d:	83 fa 09             	cmp    $0x9,%edx
  800380:	77 33                	ja     8003b5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800382:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800385:	eb e9                	jmp    800370 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800387:	8b 45 14             	mov    0x14(%ebp),%eax
  80038a:	8b 30                	mov    (%eax),%esi
  80038c:	8d 40 04             	lea    0x4(%eax),%eax
  80038f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800392:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800394:	eb 1f                	jmp    8003b5 <vprintfmt+0xd1>
  800396:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800399:	85 ff                	test   %edi,%edi
  80039b:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a0:	0f 49 c7             	cmovns %edi,%eax
  8003a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	89 df                	mov    %ebx,%edi
  8003a8:	eb a0                	jmp    80034a <vprintfmt+0x66>
  8003aa:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003ac:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8003b3:	eb 95                	jmp    80034a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8003b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b9:	79 8f                	jns    80034a <vprintfmt+0x66>
  8003bb:	eb 85                	jmp    800342 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003bd:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003c2:	eb 86                	jmp    80034a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c7:	8d 70 04             	lea    0x4(%eax),%esi
  8003ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 04 24             	mov    %eax,(%esp)
  8003d9:	ff 55 08             	call   *0x8(%ebp)
  8003dc:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8003df:	e9 25 ff ff ff       	jmp    800309 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e7:	8d 70 04             	lea    0x4(%eax),%esi
  8003ea:	8b 00                	mov    (%eax),%eax
  8003ec:	99                   	cltd   
  8003ed:	31 d0                	xor    %edx,%eax
  8003ef:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003f1:	83 f8 15             	cmp    $0x15,%eax
  8003f4:	7f 0b                	jg     800401 <vprintfmt+0x11d>
  8003f6:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  8003fd:	85 d2                	test   %edx,%edx
  8003ff:	75 26                	jne    800427 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800401:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800405:	c7 44 24 08 1e 28 80 	movl   $0x80281e,0x8(%esp)
  80040c:	00 
  80040d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800410:	89 44 24 04          	mov    %eax,0x4(%esp)
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	89 04 24             	mov    %eax,(%esp)
  80041a:	e8 9d fe ff ff       	call   8002bc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80041f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800422:	e9 e2 fe ff ff       	jmp    800309 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800427:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80042b:	c7 44 24 08 36 2c 80 	movl   $0x802c36,0x8(%esp)
  800432:	00 
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	89 44 24 04          	mov    %eax,0x4(%esp)
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	89 04 24             	mov    %eax,(%esp)
  800440:	e8 77 fe ff ff       	call   8002bc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800445:	89 75 14             	mov    %esi,0x14(%ebp)
  800448:	e9 bc fe ff ff       	jmp    800309 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800453:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800456:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80045a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80045c:	85 ff                	test   %edi,%edi
  80045e:	b8 17 28 80 00       	mov    $0x802817,%eax
  800463:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800466:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80046a:	0f 84 94 00 00 00    	je     800504 <vprintfmt+0x220>
  800470:	85 c9                	test   %ecx,%ecx
  800472:	0f 8e 94 00 00 00    	jle    80050c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800478:	89 74 24 04          	mov    %esi,0x4(%esp)
  80047c:	89 3c 24             	mov    %edi,(%esp)
  80047f:	e8 64 03 00 00       	call   8007e8 <strnlen>
  800484:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800487:	29 c1                	sub    %eax,%ecx
  800489:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80048c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800490:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800493:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800496:	8b 75 08             	mov    0x8(%ebp),%esi
  800499:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80049c:	89 cb                	mov    %ecx,%ebx
  80049e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a0:	eb 0f                	jmp    8004b1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  8004a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a9:	89 3c 24             	mov    %edi,(%esp)
  8004ac:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ae:	83 eb 01             	sub    $0x1,%ebx
  8004b1:	85 db                	test   %ebx,%ebx
  8004b3:	7f ed                	jg     8004a2 <vprintfmt+0x1be>
  8004b5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8004b8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004be:	85 c9                	test   %ecx,%ecx
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	0f 49 c1             	cmovns %ecx,%eax
  8004c8:	29 c1                	sub    %eax,%ecx
  8004ca:	89 cb                	mov    %ecx,%ebx
  8004cc:	eb 44                	jmp    800512 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004d2:	74 1e                	je     8004f2 <vprintfmt+0x20e>
  8004d4:	0f be d2             	movsbl %dl,%edx
  8004d7:	83 ea 20             	sub    $0x20,%edx
  8004da:	83 fa 5e             	cmp    $0x5e,%edx
  8004dd:	76 13                	jbe    8004f2 <vprintfmt+0x20e>
					putch('?', putdat);
  8004df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8004ed:	ff 55 08             	call   *0x8(%ebp)
  8004f0:	eb 0d                	jmp    8004ff <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8004f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004f9:	89 04 24             	mov    %eax,(%esp)
  8004fc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ff:	83 eb 01             	sub    $0x1,%ebx
  800502:	eb 0e                	jmp    800512 <vprintfmt+0x22e>
  800504:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800507:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80050a:	eb 06                	jmp    800512 <vprintfmt+0x22e>
  80050c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80050f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800512:	83 c7 01             	add    $0x1,%edi
  800515:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800519:	0f be c2             	movsbl %dl,%eax
  80051c:	85 c0                	test   %eax,%eax
  80051e:	74 27                	je     800547 <vprintfmt+0x263>
  800520:	85 f6                	test   %esi,%esi
  800522:	78 aa                	js     8004ce <vprintfmt+0x1ea>
  800524:	83 ee 01             	sub    $0x1,%esi
  800527:	79 a5                	jns    8004ce <vprintfmt+0x1ea>
  800529:	89 d8                	mov    %ebx,%eax
  80052b:	8b 75 08             	mov    0x8(%ebp),%esi
  80052e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800531:	89 c3                	mov    %eax,%ebx
  800533:	eb 18                	jmp    80054d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800535:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800539:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800540:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800542:	83 eb 01             	sub    $0x1,%ebx
  800545:	eb 06                	jmp    80054d <vprintfmt+0x269>
  800547:	8b 75 08             	mov    0x8(%ebp),%esi
  80054a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80054d:	85 db                	test   %ebx,%ebx
  80054f:	7f e4                	jg     800535 <vprintfmt+0x251>
  800551:	89 75 08             	mov    %esi,0x8(%ebp)
  800554:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800557:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80055a:	e9 aa fd ff ff       	jmp    800309 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80055f:	83 f9 01             	cmp    $0x1,%ecx
  800562:	7e 10                	jle    800574 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8b 30                	mov    (%eax),%esi
  800569:	8b 78 04             	mov    0x4(%eax),%edi
  80056c:	8d 40 08             	lea    0x8(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
  800572:	eb 26                	jmp    80059a <vprintfmt+0x2b6>
	else if (lflag)
  800574:	85 c9                	test   %ecx,%ecx
  800576:	74 12                	je     80058a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	8b 30                	mov    (%eax),%esi
  80057d:	89 f7                	mov    %esi,%edi
  80057f:	c1 ff 1f             	sar    $0x1f,%edi
  800582:	8d 40 04             	lea    0x4(%eax),%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
  800588:	eb 10                	jmp    80059a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8b 30                	mov    (%eax),%esi
  80058f:	89 f7                	mov    %esi,%edi
  800591:	c1 ff 1f             	sar    $0x1f,%edi
  800594:	8d 40 04             	lea    0x4(%eax),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80059a:	89 f0                	mov    %esi,%eax
  80059c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80059e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005a3:	85 ff                	test   %edi,%edi
  8005a5:	0f 89 3a 01 00 00    	jns    8006e5 <vprintfmt+0x401>
				putch('-', putdat);
  8005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005b9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005bc:	89 f0                	mov    %esi,%eax
  8005be:	89 fa                	mov    %edi,%edx
  8005c0:	f7 d8                	neg    %eax
  8005c2:	83 d2 00             	adc    $0x0,%edx
  8005c5:	f7 da                	neg    %edx
			}
			base = 10;
  8005c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005cc:	e9 14 01 00 00       	jmp    8006e5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005d1:	83 f9 01             	cmp    $0x1,%ecx
  8005d4:	7e 13                	jle    8005e9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8b 50 04             	mov    0x4(%eax),%edx
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	8b 75 14             	mov    0x14(%ebp),%esi
  8005e1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8005e4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005e7:	eb 2c                	jmp    800615 <vprintfmt+0x331>
	else if (lflag)
  8005e9:	85 c9                	test   %ecx,%ecx
  8005eb:	74 15                	je     800602 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f7:	8b 75 14             	mov    0x14(%ebp),%esi
  8005fa:	8d 76 04             	lea    0x4(%esi),%esi
  8005fd:	89 75 14             	mov    %esi,0x14(%ebp)
  800600:	eb 13                	jmp    800615 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	ba 00 00 00 00       	mov    $0x0,%edx
  80060c:	8b 75 14             	mov    0x14(%ebp),%esi
  80060f:	8d 76 04             	lea    0x4(%esi),%esi
  800612:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800615:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80061a:	e9 c6 00 00 00       	jmp    8006e5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80061f:	83 f9 01             	cmp    $0x1,%ecx
  800622:	7e 13                	jle    800637 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8b 50 04             	mov    0x4(%eax),%edx
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	8b 75 14             	mov    0x14(%ebp),%esi
  80062f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800632:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800635:	eb 24                	jmp    80065b <vprintfmt+0x377>
	else if (lflag)
  800637:	85 c9                	test   %ecx,%ecx
  800639:	74 11                	je     80064c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	99                   	cltd   
  800641:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800644:	8d 71 04             	lea    0x4(%ecx),%esi
  800647:	89 75 14             	mov    %esi,0x14(%ebp)
  80064a:	eb 0f                	jmp    80065b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	99                   	cltd   
  800652:	8b 75 14             	mov    0x14(%ebp),%esi
  800655:	8d 76 04             	lea    0x4(%esi),%esi
  800658:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80065b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800660:	e9 80 00 00 00       	jmp    8006e5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800665:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800668:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80066f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800676:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800679:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800680:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800687:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80068a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80068e:	8b 06                	mov    (%esi),%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800695:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80069a:	eb 49                	jmp    8006e5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80069c:	83 f9 01             	cmp    $0x1,%ecx
  80069f:	7e 13                	jle    8006b4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 50 04             	mov    0x4(%eax),%edx
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	8b 75 14             	mov    0x14(%ebp),%esi
  8006ac:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006af:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006b2:	eb 2c                	jmp    8006e0 <vprintfmt+0x3fc>
	else if (lflag)
  8006b4:	85 c9                	test   %ecx,%ecx
  8006b6:	74 15                	je     8006cd <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8006c5:	8d 71 04             	lea    0x4(%ecx),%esi
  8006c8:	89 75 14             	mov    %esi,0x14(%ebp)
  8006cb:	eb 13                	jmp    8006e0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d7:	8b 75 14             	mov    0x14(%ebp),%esi
  8006da:	8d 76 04             	lea    0x4(%esi),%esi
  8006dd:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8006e0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006e5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8006e9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006ed:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8006f0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006f4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006f8:	89 04 24             	mov    %eax,(%esp)
  8006fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	e8 a6 fa ff ff       	call   8001b0 <printnum>
			break;
  80070a:	e9 fa fb ff ff       	jmp    800309 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80070f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800712:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800716:	89 04 24             	mov    %eax,(%esp)
  800719:	ff 55 08             	call   *0x8(%ebp)
			break;
  80071c:	e9 e8 fb ff ff       	jmp    800309 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800721:	8b 45 0c             	mov    0xc(%ebp),%eax
  800724:	89 44 24 04          	mov    %eax,0x4(%esp)
  800728:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80072f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800732:	89 fb                	mov    %edi,%ebx
  800734:	eb 03                	jmp    800739 <vprintfmt+0x455>
  800736:	83 eb 01             	sub    $0x1,%ebx
  800739:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80073d:	75 f7                	jne    800736 <vprintfmt+0x452>
  80073f:	90                   	nop
  800740:	e9 c4 fb ff ff       	jmp    800309 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800745:	83 c4 3c             	add    $0x3c,%esp
  800748:	5b                   	pop    %ebx
  800749:	5e                   	pop    %esi
  80074a:	5f                   	pop    %edi
  80074b:	5d                   	pop    %ebp
  80074c:	c3                   	ret    

0080074d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 28             	sub    $0x28,%esp
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800759:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80075c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800760:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800763:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076a:	85 c0                	test   %eax,%eax
  80076c:	74 30                	je     80079e <vsnprintf+0x51>
  80076e:	85 d2                	test   %edx,%edx
  800770:	7e 2c                	jle    80079e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800779:	8b 45 10             	mov    0x10(%ebp),%eax
  80077c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800780:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800783:	89 44 24 04          	mov    %eax,0x4(%esp)
  800787:	c7 04 24 9f 02 80 00 	movl   $0x80029f,(%esp)
  80078e:	e8 51 fb ff ff       	call   8002e4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800796:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80079c:	eb 05                	jmp    8007a3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80079e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007a3:	c9                   	leave  
  8007a4:	c3                   	ret    

008007a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007a5:	55                   	push   %ebp
  8007a6:	89 e5                	mov    %esp,%ebp
  8007a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007ab:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	89 04 24             	mov    %eax,(%esp)
  8007c6:	e8 82 ff ff ff       	call   80074d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007cb:	c9                   	leave  
  8007cc:	c3                   	ret    
  8007cd:	66 90                	xchg   %ax,%ax
  8007cf:	90                   	nop

008007d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007db:	eb 03                	jmp    8007e0 <strlen+0x10>
		n++;
  8007dd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e4:	75 f7                	jne    8007dd <strlen+0xd>
		n++;
	return n;
}
  8007e6:	5d                   	pop    %ebp
  8007e7:	c3                   	ret    

008007e8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ee:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f6:	eb 03                	jmp    8007fb <strnlen+0x13>
		n++;
  8007f8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007fb:	39 d0                	cmp    %edx,%eax
  8007fd:	74 06                	je     800805 <strnlen+0x1d>
  8007ff:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800803:	75 f3                	jne    8007f8 <strnlen+0x10>
		n++;
	return n;
}
  800805:	5d                   	pop    %ebp
  800806:	c3                   	ret    

00800807 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	53                   	push   %ebx
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800811:	89 c2                	mov    %eax,%edx
  800813:	83 c2 01             	add    $0x1,%edx
  800816:	83 c1 01             	add    $0x1,%ecx
  800819:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80081d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800820:	84 db                	test   %bl,%bl
  800822:	75 ef                	jne    800813 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800824:	5b                   	pop    %ebx
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	53                   	push   %ebx
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800831:	89 1c 24             	mov    %ebx,(%esp)
  800834:	e8 97 ff ff ff       	call   8007d0 <strlen>
	strcpy(dst + len, src);
  800839:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800840:	01 d8                	add    %ebx,%eax
  800842:	89 04 24             	mov    %eax,(%esp)
  800845:	e8 bd ff ff ff       	call   800807 <strcpy>
	return dst;
}
  80084a:	89 d8                	mov    %ebx,%eax
  80084c:	83 c4 08             	add    $0x8,%esp
  80084f:	5b                   	pop    %ebx
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	56                   	push   %esi
  800856:	53                   	push   %ebx
  800857:	8b 75 08             	mov    0x8(%ebp),%esi
  80085a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085d:	89 f3                	mov    %esi,%ebx
  80085f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800862:	89 f2                	mov    %esi,%edx
  800864:	eb 0f                	jmp    800875 <strncpy+0x23>
		*dst++ = *src;
  800866:	83 c2 01             	add    $0x1,%edx
  800869:	0f b6 01             	movzbl (%ecx),%eax
  80086c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80086f:	80 39 01             	cmpb   $0x1,(%ecx)
  800872:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800875:	39 da                	cmp    %ebx,%edx
  800877:	75 ed                	jne    800866 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800879:	89 f0                	mov    %esi,%eax
  80087b:	5b                   	pop    %ebx
  80087c:	5e                   	pop    %esi
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    

0080087f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	56                   	push   %esi
  800883:	53                   	push   %ebx
  800884:	8b 75 08             	mov    0x8(%ebp),%esi
  800887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80088d:	89 f0                	mov    %esi,%eax
  80088f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800893:	85 c9                	test   %ecx,%ecx
  800895:	75 0b                	jne    8008a2 <strlcpy+0x23>
  800897:	eb 1d                	jmp    8008b6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800899:	83 c0 01             	add    $0x1,%eax
  80089c:	83 c2 01             	add    $0x1,%edx
  80089f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008a2:	39 d8                	cmp    %ebx,%eax
  8008a4:	74 0b                	je     8008b1 <strlcpy+0x32>
  8008a6:	0f b6 0a             	movzbl (%edx),%ecx
  8008a9:	84 c9                	test   %cl,%cl
  8008ab:	75 ec                	jne    800899 <strlcpy+0x1a>
  8008ad:	89 c2                	mov    %eax,%edx
  8008af:	eb 02                	jmp    8008b3 <strlcpy+0x34>
  8008b1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008b3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8008b6:	29 f0                	sub    %esi,%eax
}
  8008b8:	5b                   	pop    %ebx
  8008b9:	5e                   	pop    %esi
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008c5:	eb 06                	jmp    8008cd <strcmp+0x11>
		p++, q++;
  8008c7:	83 c1 01             	add    $0x1,%ecx
  8008ca:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008cd:	0f b6 01             	movzbl (%ecx),%eax
  8008d0:	84 c0                	test   %al,%al
  8008d2:	74 04                	je     8008d8 <strcmp+0x1c>
  8008d4:	3a 02                	cmp    (%edx),%al
  8008d6:	74 ef                	je     8008c7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d8:	0f b6 c0             	movzbl %al,%eax
  8008db:	0f b6 12             	movzbl (%edx),%edx
  8008de:	29 d0                	sub    %edx,%eax
}
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	53                   	push   %ebx
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	89 c3                	mov    %eax,%ebx
  8008ee:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f1:	eb 06                	jmp    8008f9 <strncmp+0x17>
		n--, p++, q++;
  8008f3:	83 c0 01             	add    $0x1,%eax
  8008f6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008f9:	39 d8                	cmp    %ebx,%eax
  8008fb:	74 15                	je     800912 <strncmp+0x30>
  8008fd:	0f b6 08             	movzbl (%eax),%ecx
  800900:	84 c9                	test   %cl,%cl
  800902:	74 04                	je     800908 <strncmp+0x26>
  800904:	3a 0a                	cmp    (%edx),%cl
  800906:	74 eb                	je     8008f3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800908:	0f b6 00             	movzbl (%eax),%eax
  80090b:	0f b6 12             	movzbl (%edx),%edx
  80090e:	29 d0                	sub    %edx,%eax
  800910:	eb 05                	jmp    800917 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800912:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800917:	5b                   	pop    %ebx
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800924:	eb 07                	jmp    80092d <strchr+0x13>
		if (*s == c)
  800926:	38 ca                	cmp    %cl,%dl
  800928:	74 0f                	je     800939 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80092a:	83 c0 01             	add    $0x1,%eax
  80092d:	0f b6 10             	movzbl (%eax),%edx
  800930:	84 d2                	test   %dl,%dl
  800932:	75 f2                	jne    800926 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800934:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800945:	eb 07                	jmp    80094e <strfind+0x13>
		if (*s == c)
  800947:	38 ca                	cmp    %cl,%dl
  800949:	74 0a                	je     800955 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80094b:	83 c0 01             	add    $0x1,%eax
  80094e:	0f b6 10             	movzbl (%eax),%edx
  800951:	84 d2                	test   %dl,%dl
  800953:	75 f2                	jne    800947 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	57                   	push   %edi
  80095b:	56                   	push   %esi
  80095c:	53                   	push   %ebx
  80095d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800960:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800963:	85 c9                	test   %ecx,%ecx
  800965:	74 36                	je     80099d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800967:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80096d:	75 28                	jne    800997 <memset+0x40>
  80096f:	f6 c1 03             	test   $0x3,%cl
  800972:	75 23                	jne    800997 <memset+0x40>
		c &= 0xFF;
  800974:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800978:	89 d3                	mov    %edx,%ebx
  80097a:	c1 e3 08             	shl    $0x8,%ebx
  80097d:	89 d6                	mov    %edx,%esi
  80097f:	c1 e6 18             	shl    $0x18,%esi
  800982:	89 d0                	mov    %edx,%eax
  800984:	c1 e0 10             	shl    $0x10,%eax
  800987:	09 f0                	or     %esi,%eax
  800989:	09 c2                	or     %eax,%edx
  80098b:	89 d0                	mov    %edx,%eax
  80098d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80098f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800992:	fc                   	cld    
  800993:	f3 ab                	rep stos %eax,%es:(%edi)
  800995:	eb 06                	jmp    80099d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099a:	fc                   	cld    
  80099b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80099d:	89 f8                	mov    %edi,%eax
  80099f:	5b                   	pop    %ebx
  8009a0:	5e                   	pop    %esi
  8009a1:	5f                   	pop    %edi
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	57                   	push   %edi
  8009a8:	56                   	push   %esi
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009af:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009b2:	39 c6                	cmp    %eax,%esi
  8009b4:	73 35                	jae    8009eb <memmove+0x47>
  8009b6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009b9:	39 d0                	cmp    %edx,%eax
  8009bb:	73 2e                	jae    8009eb <memmove+0x47>
		s += n;
		d += n;
  8009bd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009c0:	89 d6                	mov    %edx,%esi
  8009c2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ca:	75 13                	jne    8009df <memmove+0x3b>
  8009cc:	f6 c1 03             	test   $0x3,%cl
  8009cf:	75 0e                	jne    8009df <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d1:	83 ef 04             	sub    $0x4,%edi
  8009d4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009d7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009da:	fd                   	std    
  8009db:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009dd:	eb 09                	jmp    8009e8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009df:	83 ef 01             	sub    $0x1,%edi
  8009e2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009e5:	fd                   	std    
  8009e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e8:	fc                   	cld    
  8009e9:	eb 1d                	jmp    800a08 <memmove+0x64>
  8009eb:	89 f2                	mov    %esi,%edx
  8009ed:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ef:	f6 c2 03             	test   $0x3,%dl
  8009f2:	75 0f                	jne    800a03 <memmove+0x5f>
  8009f4:	f6 c1 03             	test   $0x3,%cl
  8009f7:	75 0a                	jne    800a03 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009f9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009fc:	89 c7                	mov    %eax,%edi
  8009fe:	fc                   	cld    
  8009ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a01:	eb 05                	jmp    800a08 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a03:	89 c7                	mov    %eax,%edi
  800a05:	fc                   	cld    
  800a06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a08:	5e                   	pop    %esi
  800a09:	5f                   	pop    %edi
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a12:	8b 45 10             	mov    0x10(%ebp),%eax
  800a15:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	89 04 24             	mov    %eax,(%esp)
  800a26:	e8 79 ff ff ff       	call   8009a4 <memmove>
}
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	56                   	push   %esi
  800a31:	53                   	push   %ebx
  800a32:	8b 55 08             	mov    0x8(%ebp),%edx
  800a35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a38:	89 d6                	mov    %edx,%esi
  800a3a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a3d:	eb 1a                	jmp    800a59 <memcmp+0x2c>
		if (*s1 != *s2)
  800a3f:	0f b6 02             	movzbl (%edx),%eax
  800a42:	0f b6 19             	movzbl (%ecx),%ebx
  800a45:	38 d8                	cmp    %bl,%al
  800a47:	74 0a                	je     800a53 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a49:	0f b6 c0             	movzbl %al,%eax
  800a4c:	0f b6 db             	movzbl %bl,%ebx
  800a4f:	29 d8                	sub    %ebx,%eax
  800a51:	eb 0f                	jmp    800a62 <memcmp+0x35>
		s1++, s2++;
  800a53:	83 c2 01             	add    $0x1,%edx
  800a56:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a59:	39 f2                	cmp    %esi,%edx
  800a5b:	75 e2                	jne    800a3f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a62:	5b                   	pop    %ebx
  800a63:	5e                   	pop    %esi
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a6f:	89 c2                	mov    %eax,%edx
  800a71:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a74:	eb 07                	jmp    800a7d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a76:	38 08                	cmp    %cl,(%eax)
  800a78:	74 07                	je     800a81 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a7a:	83 c0 01             	add    $0x1,%eax
  800a7d:	39 d0                	cmp    %edx,%eax
  800a7f:	72 f5                	jb     800a76 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a81:	5d                   	pop    %ebp
  800a82:	c3                   	ret    

00800a83 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	57                   	push   %edi
  800a87:	56                   	push   %esi
  800a88:	53                   	push   %ebx
  800a89:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a8f:	eb 03                	jmp    800a94 <strtol+0x11>
		s++;
  800a91:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a94:	0f b6 0a             	movzbl (%edx),%ecx
  800a97:	80 f9 09             	cmp    $0x9,%cl
  800a9a:	74 f5                	je     800a91 <strtol+0xe>
  800a9c:	80 f9 20             	cmp    $0x20,%cl
  800a9f:	74 f0                	je     800a91 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800aa1:	80 f9 2b             	cmp    $0x2b,%cl
  800aa4:	75 0a                	jne    800ab0 <strtol+0x2d>
		s++;
  800aa6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800aa9:	bf 00 00 00 00       	mov    $0x0,%edi
  800aae:	eb 11                	jmp    800ac1 <strtol+0x3e>
  800ab0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ab5:	80 f9 2d             	cmp    $0x2d,%cl
  800ab8:	75 07                	jne    800ac1 <strtol+0x3e>
		s++, neg = 1;
  800aba:	8d 52 01             	lea    0x1(%edx),%edx
  800abd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ac6:	75 15                	jne    800add <strtol+0x5a>
  800ac8:	80 3a 30             	cmpb   $0x30,(%edx)
  800acb:	75 10                	jne    800add <strtol+0x5a>
  800acd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ad1:	75 0a                	jne    800add <strtol+0x5a>
		s += 2, base = 16;
  800ad3:	83 c2 02             	add    $0x2,%edx
  800ad6:	b8 10 00 00 00       	mov    $0x10,%eax
  800adb:	eb 10                	jmp    800aed <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800add:	85 c0                	test   %eax,%eax
  800adf:	75 0c                	jne    800aed <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ae3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ae6:	75 05                	jne    800aed <strtol+0x6a>
		s++, base = 8;
  800ae8:	83 c2 01             	add    $0x1,%edx
  800aeb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800aed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800af5:	0f b6 0a             	movzbl (%edx),%ecx
  800af8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800afb:	89 f0                	mov    %esi,%eax
  800afd:	3c 09                	cmp    $0x9,%al
  800aff:	77 08                	ja     800b09 <strtol+0x86>
			dig = *s - '0';
  800b01:	0f be c9             	movsbl %cl,%ecx
  800b04:	83 e9 30             	sub    $0x30,%ecx
  800b07:	eb 20                	jmp    800b29 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b09:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b0c:	89 f0                	mov    %esi,%eax
  800b0e:	3c 19                	cmp    $0x19,%al
  800b10:	77 08                	ja     800b1a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b12:	0f be c9             	movsbl %cl,%ecx
  800b15:	83 e9 57             	sub    $0x57,%ecx
  800b18:	eb 0f                	jmp    800b29 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b1a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b1d:	89 f0                	mov    %esi,%eax
  800b1f:	3c 19                	cmp    $0x19,%al
  800b21:	77 16                	ja     800b39 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b23:	0f be c9             	movsbl %cl,%ecx
  800b26:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b29:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b2c:	7d 0f                	jge    800b3d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b2e:	83 c2 01             	add    $0x1,%edx
  800b31:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b35:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b37:	eb bc                	jmp    800af5 <strtol+0x72>
  800b39:	89 d8                	mov    %ebx,%eax
  800b3b:	eb 02                	jmp    800b3f <strtol+0xbc>
  800b3d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b43:	74 05                	je     800b4a <strtol+0xc7>
		*endptr = (char *) s;
  800b45:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b48:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b4a:	f7 d8                	neg    %eax
  800b4c:	85 ff                	test   %edi,%edi
  800b4e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5f                   	pop    %edi
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	57                   	push   %edi
  800b5a:	56                   	push   %esi
  800b5b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b64:	8b 55 08             	mov    0x8(%ebp),%edx
  800b67:	89 c3                	mov    %eax,%ebx
  800b69:	89 c7                	mov    %eax,%edi
  800b6b:	89 c6                	mov    %eax,%esi
  800b6d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5f                   	pop    %edi
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b84:	89 d1                	mov    %edx,%ecx
  800b86:	89 d3                	mov    %edx,%ebx
  800b88:	89 d7                	mov    %edx,%edi
  800b8a:	89 d6                	mov    %edx,%esi
  800b8c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b8e:	5b                   	pop    %ebx
  800b8f:	5e                   	pop    %esi
  800b90:	5f                   	pop    %edi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	57                   	push   %edi
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba9:	89 cb                	mov    %ecx,%ebx
  800bab:	89 cf                	mov    %ecx,%edi
  800bad:	89 ce                	mov    %ecx,%esi
  800baf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bb1:	85 c0                	test   %eax,%eax
  800bb3:	7e 28                	jle    800bdd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bb9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800bc0:	00 
  800bc1:	c7 44 24 08 17 2b 80 	movl   $0x802b17,0x8(%esp)
  800bc8:	00 
  800bc9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bd0:	00 
  800bd1:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  800bd8:	e8 b9 17 00 00       	call   802396 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bdd:	83 c4 2c             	add    $0x2c,%esp
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	57                   	push   %edi
  800be9:	56                   	push   %esi
  800bea:	53                   	push   %ebx
  800beb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf3:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfb:	89 cb                	mov    %ecx,%ebx
  800bfd:	89 cf                	mov    %ecx,%edi
  800bff:	89 ce                	mov    %ecx,%esi
  800c01:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c03:	85 c0                	test   %eax,%eax
  800c05:	7e 28                	jle    800c2f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c0b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c12:	00 
  800c13:	c7 44 24 08 17 2b 80 	movl   $0x802b17,0x8(%esp)
  800c1a:	00 
  800c1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c22:	00 
  800c23:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  800c2a:	e8 67 17 00 00       	call   802396 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800c2f:	83 c4 2c             	add    $0x2c,%esp
  800c32:	5b                   	pop    %ebx
  800c33:	5e                   	pop    %esi
  800c34:	5f                   	pop    %edi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c42:	b8 02 00 00 00       	mov    $0x2,%eax
  800c47:	89 d1                	mov    %edx,%ecx
  800c49:	89 d3                	mov    %edx,%ebx
  800c4b:	89 d7                	mov    %edx,%edi
  800c4d:	89 d6                	mov    %edx,%esi
  800c4f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <sys_yield>:

void
sys_yield(void)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	57                   	push   %edi
  800c5a:	56                   	push   %esi
  800c5b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c61:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c66:	89 d1                	mov    %edx,%ecx
  800c68:	89 d3                	mov    %edx,%ebx
  800c6a:	89 d7                	mov    %edx,%edi
  800c6c:	89 d6                	mov    %edx,%esi
  800c6e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	57                   	push   %edi
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
  800c7b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7e:	be 00 00 00 00       	mov    $0x0,%esi
  800c83:	b8 05 00 00 00       	mov    $0x5,%eax
  800c88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c91:	89 f7                	mov    %esi,%edi
  800c93:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c95:	85 c0                	test   %eax,%eax
  800c97:	7e 28                	jle    800cc1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c99:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c9d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ca4:	00 
  800ca5:	c7 44 24 08 17 2b 80 	movl   $0x802b17,0x8(%esp)
  800cac:	00 
  800cad:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb4:	00 
  800cb5:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  800cbc:	e8 d5 16 00 00       	call   802396 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cc1:	83 c4 2c             	add    $0x2c,%esp
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
  800ccf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd2:	b8 06 00 00 00       	mov    $0x6,%eax
  800cd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cda:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce3:	8b 75 18             	mov    0x18(%ebp),%esi
  800ce6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ce8:	85 c0                	test   %eax,%eax
  800cea:	7e 28                	jle    800d14 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cec:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cf0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800cf7:	00 
  800cf8:	c7 44 24 08 17 2b 80 	movl   $0x802b17,0x8(%esp)
  800cff:	00 
  800d00:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d07:	00 
  800d08:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  800d0f:	e8 82 16 00 00       	call   802396 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d14:	83 c4 2c             	add    $0x2c,%esp
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	57                   	push   %edi
  800d20:	56                   	push   %esi
  800d21:	53                   	push   %ebx
  800d22:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2a:	b8 07 00 00 00       	mov    $0x7,%eax
  800d2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d32:	8b 55 08             	mov    0x8(%ebp),%edx
  800d35:	89 df                	mov    %ebx,%edi
  800d37:	89 de                	mov    %ebx,%esi
  800d39:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d3b:	85 c0                	test   %eax,%eax
  800d3d:	7e 28                	jle    800d67 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d43:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800d4a:	00 
  800d4b:	c7 44 24 08 17 2b 80 	movl   $0x802b17,0x8(%esp)
  800d52:	00 
  800d53:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d5a:	00 
  800d5b:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  800d62:	e8 2f 16 00 00       	call   802396 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d67:	83 c4 2c             	add    $0x2c,%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	57                   	push   %edi
  800d73:	56                   	push   %esi
  800d74:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d75:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d7a:	b8 10 00 00 00       	mov    $0x10,%eax
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	89 cb                	mov    %ecx,%ebx
  800d84:	89 cf                	mov    %ecx,%edi
  800d86:	89 ce                	mov    %ecx,%esi
  800d88:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	57                   	push   %edi
  800d93:	56                   	push   %esi
  800d94:	53                   	push   %ebx
  800d95:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9d:	b8 09 00 00 00       	mov    $0x9,%eax
  800da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	89 df                	mov    %ebx,%edi
  800daa:	89 de                	mov    %ebx,%esi
  800dac:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dae:	85 c0                	test   %eax,%eax
  800db0:	7e 28                	jle    800dda <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dbd:	00 
  800dbe:	c7 44 24 08 17 2b 80 	movl   $0x802b17,0x8(%esp)
  800dc5:	00 
  800dc6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dcd:	00 
  800dce:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  800dd5:	e8 bc 15 00 00       	call   802396 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dda:	83 c4 2c             	add    $0x2c,%esp
  800ddd:	5b                   	pop    %ebx
  800dde:	5e                   	pop    %esi
  800ddf:	5f                   	pop    %edi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    

00800de2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	57                   	push   %edi
  800de6:	56                   	push   %esi
  800de7:	53                   	push   %ebx
  800de8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800deb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	89 df                	mov    %ebx,%edi
  800dfd:	89 de                	mov    %ebx,%esi
  800dff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e01:	85 c0                	test   %eax,%eax
  800e03:	7e 28                	jle    800e2d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e05:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e09:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e10:	00 
  800e11:	c7 44 24 08 17 2b 80 	movl   $0x802b17,0x8(%esp)
  800e18:	00 
  800e19:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e20:	00 
  800e21:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  800e28:	e8 69 15 00 00       	call   802396 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e2d:	83 c4 2c             	add    $0x2c,%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	57                   	push   %edi
  800e39:	56                   	push   %esi
  800e3a:	53                   	push   %ebx
  800e3b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e43:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	89 df                	mov    %ebx,%edi
  800e50:	89 de                	mov    %ebx,%esi
  800e52:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e54:	85 c0                	test   %eax,%eax
  800e56:	7e 28                	jle    800e80 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e58:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e5c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800e63:	00 
  800e64:	c7 44 24 08 17 2b 80 	movl   $0x802b17,0x8(%esp)
  800e6b:	00 
  800e6c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e73:	00 
  800e74:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  800e7b:	e8 16 15 00 00       	call   802396 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e80:	83 c4 2c             	add    $0x2c,%esp
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5f                   	pop    %edi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    

00800e88 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8e:	be 00 00 00 00       	mov    $0x0,%esi
  800e93:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ea6:	5b                   	pop    %ebx
  800ea7:	5e                   	pop    %esi
  800ea8:	5f                   	pop    %edi
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
  800eb1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	89 cb                	mov    %ecx,%ebx
  800ec3:	89 cf                	mov    %ecx,%edi
  800ec5:	89 ce                	mov    %ecx,%esi
  800ec7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	7e 28                	jle    800ef5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800ed8:	00 
  800ed9:	c7 44 24 08 17 2b 80 	movl   $0x802b17,0x8(%esp)
  800ee0:	00 
  800ee1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee8:	00 
  800ee9:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  800ef0:	e8 a1 14 00 00       	call   802396 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef5:	83 c4 2c             	add    $0x2c,%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <sys_time_msec>:

unsigned int
sys_time_msec(void)
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
  800f03:	ba 00 00 00 00       	mov    $0x0,%edx
  800f08:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f0d:	89 d1                	mov    %edx,%ecx
  800f0f:	89 d3                	mov    %edx,%ebx
  800f11:	89 d7                	mov    %edx,%edi
  800f13:	89 d6                	mov    %edx,%esi
  800f15:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f27:	b8 11 00 00 00       	mov    $0x11,%eax
  800f2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f32:	89 df                	mov    %ebx,%edi
  800f34:	89 de                	mov    %ebx,%esi
  800f36:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    

00800f3d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	57                   	push   %edi
  800f41:	56                   	push   %esi
  800f42:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f48:	b8 12 00 00 00       	mov    $0x12,%eax
  800f4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
  800f53:	89 df                	mov    %ebx,%edi
  800f55:	89 de                	mov    %ebx,%esi
  800f57:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  800f59:	5b                   	pop    %ebx
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f64:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f69:	b8 13 00 00 00       	mov    $0x13,%eax
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	89 cb                	mov    %ecx,%ebx
  800f73:	89 cf                	mov    %ecx,%edi
  800f75:	89 ce                	mov    %ecx,%esi
  800f77:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5f                   	pop    %edi
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    

00800f7e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f84:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800f8b:	75 7a                	jne    801007 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  800f8d:	e8 a5 fc ff ff       	call   800c37 <sys_getenvid>
  800f92:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800f99:	00 
  800f9a:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800fa1:	ee 
  800fa2:	89 04 24             	mov    %eax,(%esp)
  800fa5:	e8 cb fc ff ff       	call   800c75 <sys_page_alloc>
  800faa:	85 c0                	test   %eax,%eax
  800fac:	79 20                	jns    800fce <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  800fae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fb2:	c7 44 24 08 42 2b 80 	movl   $0x802b42,0x8(%esp)
  800fb9:	00 
  800fba:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  800fc1:	00 
  800fc2:	c7 04 24 55 2b 80 00 	movl   $0x802b55,(%esp)
  800fc9:	e8 c8 13 00 00       	call   802396 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  800fce:	e8 64 fc ff ff       	call   800c37 <sys_getenvid>
  800fd3:	c7 44 24 04 11 10 80 	movl   $0x801011,0x4(%esp)
  800fda:	00 
  800fdb:	89 04 24             	mov    %eax,(%esp)
  800fde:	e8 52 fe ff ff       	call   800e35 <sys_env_set_pgfault_upcall>
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	79 20                	jns    801007 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  800fe7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800feb:	c7 44 24 08 64 2b 80 	movl   $0x802b64,0x8(%esp)
  800ff2:	00 
  800ff3:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  800ffa:	00 
  800ffb:	c7 04 24 55 2b 80 00 	movl   $0x802b55,(%esp)
  801002:	e8 8f 13 00 00       	call   802396 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801011:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801012:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801017:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801019:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  80101c:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  801020:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801024:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  801027:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  80102b:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  80102d:	83 c4 08             	add    $0x8,%esp
	popal
  801030:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  801031:	83 c4 04             	add    $0x4,%esp
	popfl
  801034:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801035:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801036:	c3                   	ret    
  801037:	66 90                	xchg   %ax,%ax
  801039:	66 90                	xchg   %ax,%ax
  80103b:	66 90                	xchg   %ax,%ax
  80103d:	66 90                	xchg   %ax,%ax
  80103f:	90                   	nop

00801040 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	05 00 00 00 30       	add    $0x30000000,%eax
  80104b:	c1 e8 0c             	shr    $0xc,%eax
}
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80105b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801060:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801065:	5d                   	pop    %ebp
  801066:	c3                   	ret    

00801067 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80106d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801072:	89 c2                	mov    %eax,%edx
  801074:	c1 ea 16             	shr    $0x16,%edx
  801077:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80107e:	f6 c2 01             	test   $0x1,%dl
  801081:	74 11                	je     801094 <fd_alloc+0x2d>
  801083:	89 c2                	mov    %eax,%edx
  801085:	c1 ea 0c             	shr    $0xc,%edx
  801088:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80108f:	f6 c2 01             	test   $0x1,%dl
  801092:	75 09                	jne    80109d <fd_alloc+0x36>
			*fd_store = fd;
  801094:	89 01                	mov    %eax,(%ecx)
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 17                	jmp    8010b4 <fd_alloc+0x4d>
  80109d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010a2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010a7:	75 c9                	jne    801072 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010a9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010af:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010bc:	83 f8 1f             	cmp    $0x1f,%eax
  8010bf:	77 36                	ja     8010f7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010c1:	c1 e0 0c             	shl    $0xc,%eax
  8010c4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010c9:	89 c2                	mov    %eax,%edx
  8010cb:	c1 ea 16             	shr    $0x16,%edx
  8010ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010d5:	f6 c2 01             	test   $0x1,%dl
  8010d8:	74 24                	je     8010fe <fd_lookup+0x48>
  8010da:	89 c2                	mov    %eax,%edx
  8010dc:	c1 ea 0c             	shr    $0xc,%edx
  8010df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010e6:	f6 c2 01             	test   $0x1,%dl
  8010e9:	74 1a                	je     801105 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ee:	89 02                	mov    %eax,(%edx)
	return 0;
  8010f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f5:	eb 13                	jmp    80110a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010fc:	eb 0c                	jmp    80110a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801103:	eb 05                	jmp    80110a <fd_lookup+0x54>
  801105:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 18             	sub    $0x18,%esp
  801112:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801115:	ba 00 00 00 00       	mov    $0x0,%edx
  80111a:	eb 13                	jmp    80112f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80111c:	39 08                	cmp    %ecx,(%eax)
  80111e:	75 0c                	jne    80112c <dev_lookup+0x20>
			*dev = devtab[i];
  801120:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801123:	89 01                	mov    %eax,(%ecx)
			return 0;
  801125:	b8 00 00 00 00       	mov    $0x0,%eax
  80112a:	eb 38                	jmp    801164 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80112c:	83 c2 01             	add    $0x1,%edx
  80112f:	8b 04 95 04 2c 80 00 	mov    0x802c04(,%edx,4),%eax
  801136:	85 c0                	test   %eax,%eax
  801138:	75 e2                	jne    80111c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80113a:	a1 08 40 80 00       	mov    0x804008,%eax
  80113f:	8b 40 48             	mov    0x48(%eax),%eax
  801142:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801146:	89 44 24 04          	mov    %eax,0x4(%esp)
  80114a:	c7 04 24 88 2b 80 00 	movl   $0x802b88,(%esp)
  801151:	e8 40 f0 ff ff       	call   800196 <cprintf>
	*dev = 0;
  801156:	8b 45 0c             	mov    0xc(%ebp),%eax
  801159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80115f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	56                   	push   %esi
  80116a:	53                   	push   %ebx
  80116b:	83 ec 20             	sub    $0x20,%esp
  80116e:	8b 75 08             	mov    0x8(%ebp),%esi
  801171:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801174:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801177:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80117b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801181:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801184:	89 04 24             	mov    %eax,(%esp)
  801187:	e8 2a ff ff ff       	call   8010b6 <fd_lookup>
  80118c:	85 c0                	test   %eax,%eax
  80118e:	78 05                	js     801195 <fd_close+0x2f>
	    || fd != fd2)
  801190:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801193:	74 0c                	je     8011a1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801195:	84 db                	test   %bl,%bl
  801197:	ba 00 00 00 00       	mov    $0x0,%edx
  80119c:	0f 44 c2             	cmove  %edx,%eax
  80119f:	eb 3f                	jmp    8011e0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011a8:	8b 06                	mov    (%esi),%eax
  8011aa:	89 04 24             	mov    %eax,(%esp)
  8011ad:	e8 5a ff ff ff       	call   80110c <dev_lookup>
  8011b2:	89 c3                	mov    %eax,%ebx
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	78 16                	js     8011ce <fd_close+0x68>
		if (dev->dev_close)
  8011b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011be:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	74 07                	je     8011ce <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011c7:	89 34 24             	mov    %esi,(%esp)
  8011ca:	ff d0                	call   *%eax
  8011cc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d9:	e8 3e fb ff ff       	call   800d1c <sys_page_unmap>
	return r;
  8011de:	89 d8                	mov    %ebx,%eax
}
  8011e0:	83 c4 20             	add    $0x20,%esp
  8011e3:	5b                   	pop    %ebx
  8011e4:	5e                   	pop    %esi
  8011e5:	5d                   	pop    %ebp
  8011e6:	c3                   	ret    

008011e7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	89 04 24             	mov    %eax,(%esp)
  8011fa:	e8 b7 fe ff ff       	call   8010b6 <fd_lookup>
  8011ff:	89 c2                	mov    %eax,%edx
  801201:	85 d2                	test   %edx,%edx
  801203:	78 13                	js     801218 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801205:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80120c:	00 
  80120d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801210:	89 04 24             	mov    %eax,(%esp)
  801213:	e8 4e ff ff ff       	call   801166 <fd_close>
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <close_all>:

void
close_all(void)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	53                   	push   %ebx
  80121e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801221:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801226:	89 1c 24             	mov    %ebx,(%esp)
  801229:	e8 b9 ff ff ff       	call   8011e7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80122e:	83 c3 01             	add    $0x1,%ebx
  801231:	83 fb 20             	cmp    $0x20,%ebx
  801234:	75 f0                	jne    801226 <close_all+0xc>
		close(i);
}
  801236:	83 c4 14             	add    $0x14,%esp
  801239:	5b                   	pop    %ebx
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    

0080123c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	57                   	push   %edi
  801240:	56                   	push   %esi
  801241:	53                   	push   %ebx
  801242:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801245:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801248:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	89 04 24             	mov    %eax,(%esp)
  801252:	e8 5f fe ff ff       	call   8010b6 <fd_lookup>
  801257:	89 c2                	mov    %eax,%edx
  801259:	85 d2                	test   %edx,%edx
  80125b:	0f 88 e1 00 00 00    	js     801342 <dup+0x106>
		return r;
	close(newfdnum);
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	89 04 24             	mov    %eax,(%esp)
  801267:	e8 7b ff ff ff       	call   8011e7 <close>

	newfd = INDEX2FD(newfdnum);
  80126c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80126f:	c1 e3 0c             	shl    $0xc,%ebx
  801272:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80127b:	89 04 24             	mov    %eax,(%esp)
  80127e:	e8 cd fd ff ff       	call   801050 <fd2data>
  801283:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801285:	89 1c 24             	mov    %ebx,(%esp)
  801288:	e8 c3 fd ff ff       	call   801050 <fd2data>
  80128d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80128f:	89 f0                	mov    %esi,%eax
  801291:	c1 e8 16             	shr    $0x16,%eax
  801294:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80129b:	a8 01                	test   $0x1,%al
  80129d:	74 43                	je     8012e2 <dup+0xa6>
  80129f:	89 f0                	mov    %esi,%eax
  8012a1:	c1 e8 0c             	shr    $0xc,%eax
  8012a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012ab:	f6 c2 01             	test   $0x1,%dl
  8012ae:	74 32                	je     8012e2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012c0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012cb:	00 
  8012cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d7:	e8 ed f9 ff ff       	call   800cc9 <sys_page_map>
  8012dc:	89 c6                	mov    %eax,%esi
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	78 3e                	js     801320 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012e5:	89 c2                	mov    %eax,%edx
  8012e7:	c1 ea 0c             	shr    $0xc,%edx
  8012ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8012f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801306:	00 
  801307:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801312:	e8 b2 f9 ff ff       	call   800cc9 <sys_page_map>
  801317:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801319:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80131c:	85 f6                	test   %esi,%esi
  80131e:	79 22                	jns    801342 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801320:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801324:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80132b:	e8 ec f9 ff ff       	call   800d1c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801330:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801334:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133b:	e8 dc f9 ff ff       	call   800d1c <sys_page_unmap>
	return r;
  801340:	89 f0                	mov    %esi,%eax
}
  801342:	83 c4 3c             	add    $0x3c,%esp
  801345:	5b                   	pop    %ebx
  801346:	5e                   	pop    %esi
  801347:	5f                   	pop    %edi
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    

0080134a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	53                   	push   %ebx
  80134e:	83 ec 24             	sub    $0x24,%esp
  801351:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801354:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801357:	89 44 24 04          	mov    %eax,0x4(%esp)
  80135b:	89 1c 24             	mov    %ebx,(%esp)
  80135e:	e8 53 fd ff ff       	call   8010b6 <fd_lookup>
  801363:	89 c2                	mov    %eax,%edx
  801365:	85 d2                	test   %edx,%edx
  801367:	78 6d                	js     8013d6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801369:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801373:	8b 00                	mov    (%eax),%eax
  801375:	89 04 24             	mov    %eax,(%esp)
  801378:	e8 8f fd ff ff       	call   80110c <dev_lookup>
  80137d:	85 c0                	test   %eax,%eax
  80137f:	78 55                	js     8013d6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801384:	8b 50 08             	mov    0x8(%eax),%edx
  801387:	83 e2 03             	and    $0x3,%edx
  80138a:	83 fa 01             	cmp    $0x1,%edx
  80138d:	75 23                	jne    8013b2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80138f:	a1 08 40 80 00       	mov    0x804008,%eax
  801394:	8b 40 48             	mov    0x48(%eax),%eax
  801397:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80139b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139f:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  8013a6:	e8 eb ed ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  8013ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b0:	eb 24                	jmp    8013d6 <read+0x8c>
	}
	if (!dev->dev_read)
  8013b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b5:	8b 52 08             	mov    0x8(%edx),%edx
  8013b8:	85 d2                	test   %edx,%edx
  8013ba:	74 15                	je     8013d1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013ca:	89 04 24             	mov    %eax,(%esp)
  8013cd:	ff d2                	call   *%edx
  8013cf:	eb 05                	jmp    8013d6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013d6:	83 c4 24             	add    $0x24,%esp
  8013d9:	5b                   	pop    %ebx
  8013da:	5d                   	pop    %ebp
  8013db:	c3                   	ret    

008013dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	57                   	push   %edi
  8013e0:	56                   	push   %esi
  8013e1:	53                   	push   %ebx
  8013e2:	83 ec 1c             	sub    $0x1c,%esp
  8013e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f0:	eb 23                	jmp    801415 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f2:	89 f0                	mov    %esi,%eax
  8013f4:	29 d8                	sub    %ebx,%eax
  8013f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013fa:	89 d8                	mov    %ebx,%eax
  8013fc:	03 45 0c             	add    0xc(%ebp),%eax
  8013ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801403:	89 3c 24             	mov    %edi,(%esp)
  801406:	e8 3f ff ff ff       	call   80134a <read>
		if (m < 0)
  80140b:	85 c0                	test   %eax,%eax
  80140d:	78 10                	js     80141f <readn+0x43>
			return m;
		if (m == 0)
  80140f:	85 c0                	test   %eax,%eax
  801411:	74 0a                	je     80141d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801413:	01 c3                	add    %eax,%ebx
  801415:	39 f3                	cmp    %esi,%ebx
  801417:	72 d9                	jb     8013f2 <readn+0x16>
  801419:	89 d8                	mov    %ebx,%eax
  80141b:	eb 02                	jmp    80141f <readn+0x43>
  80141d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80141f:	83 c4 1c             	add    $0x1c,%esp
  801422:	5b                   	pop    %ebx
  801423:	5e                   	pop    %esi
  801424:	5f                   	pop    %edi
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    

00801427 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	53                   	push   %ebx
  80142b:	83 ec 24             	sub    $0x24,%esp
  80142e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801431:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801434:	89 44 24 04          	mov    %eax,0x4(%esp)
  801438:	89 1c 24             	mov    %ebx,(%esp)
  80143b:	e8 76 fc ff ff       	call   8010b6 <fd_lookup>
  801440:	89 c2                	mov    %eax,%edx
  801442:	85 d2                	test   %edx,%edx
  801444:	78 68                	js     8014ae <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801446:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801449:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801450:	8b 00                	mov    (%eax),%eax
  801452:	89 04 24             	mov    %eax,(%esp)
  801455:	e8 b2 fc ff ff       	call   80110c <dev_lookup>
  80145a:	85 c0                	test   %eax,%eax
  80145c:	78 50                	js     8014ae <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80145e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801461:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801465:	75 23                	jne    80148a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801467:	a1 08 40 80 00       	mov    0x804008,%eax
  80146c:	8b 40 48             	mov    0x48(%eax),%eax
  80146f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801473:	89 44 24 04          	mov    %eax,0x4(%esp)
  801477:	c7 04 24 e5 2b 80 00 	movl   $0x802be5,(%esp)
  80147e:	e8 13 ed ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  801483:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801488:	eb 24                	jmp    8014ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80148a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80148d:	8b 52 0c             	mov    0xc(%edx),%edx
  801490:	85 d2                	test   %edx,%edx
  801492:	74 15                	je     8014a9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801494:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801497:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80149b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80149e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014a2:	89 04 24             	mov    %eax,(%esp)
  8014a5:	ff d2                	call   *%edx
  8014a7:	eb 05                	jmp    8014ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014ae:	83 c4 24             	add    $0x24,%esp
  8014b1:	5b                   	pop    %ebx
  8014b2:	5d                   	pop    %ebp
  8014b3:	c3                   	ret    

008014b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 04 24             	mov    %eax,(%esp)
  8014c7:	e8 ea fb ff ff       	call   8010b6 <fd_lookup>
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 0e                	js     8014de <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	53                   	push   %ebx
  8014e4:	83 ec 24             	sub    $0x24,%esp
  8014e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f1:	89 1c 24             	mov    %ebx,(%esp)
  8014f4:	e8 bd fb ff ff       	call   8010b6 <fd_lookup>
  8014f9:	89 c2                	mov    %eax,%edx
  8014fb:	85 d2                	test   %edx,%edx
  8014fd:	78 61                	js     801560 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801502:	89 44 24 04          	mov    %eax,0x4(%esp)
  801506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801509:	8b 00                	mov    (%eax),%eax
  80150b:	89 04 24             	mov    %eax,(%esp)
  80150e:	e8 f9 fb ff ff       	call   80110c <dev_lookup>
  801513:	85 c0                	test   %eax,%eax
  801515:	78 49                	js     801560 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80151e:	75 23                	jne    801543 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801520:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801525:	8b 40 48             	mov    0x48(%eax),%eax
  801528:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80152c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801530:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  801537:	e8 5a ec ff ff       	call   800196 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80153c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801541:	eb 1d                	jmp    801560 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801546:	8b 52 18             	mov    0x18(%edx),%edx
  801549:	85 d2                	test   %edx,%edx
  80154b:	74 0e                	je     80155b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80154d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801550:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801554:	89 04 24             	mov    %eax,(%esp)
  801557:	ff d2                	call   *%edx
  801559:	eb 05                	jmp    801560 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80155b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801560:	83 c4 24             	add    $0x24,%esp
  801563:	5b                   	pop    %ebx
  801564:	5d                   	pop    %ebp
  801565:	c3                   	ret    

00801566 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	53                   	push   %ebx
  80156a:	83 ec 24             	sub    $0x24,%esp
  80156d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801570:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801573:	89 44 24 04          	mov    %eax,0x4(%esp)
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	89 04 24             	mov    %eax,(%esp)
  80157d:	e8 34 fb ff ff       	call   8010b6 <fd_lookup>
  801582:	89 c2                	mov    %eax,%edx
  801584:	85 d2                	test   %edx,%edx
  801586:	78 52                	js     8015da <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801588:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801592:	8b 00                	mov    (%eax),%eax
  801594:	89 04 24             	mov    %eax,(%esp)
  801597:	e8 70 fb ff ff       	call   80110c <dev_lookup>
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 3a                	js     8015da <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015a7:	74 2c                	je     8015d5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015b3:	00 00 00 
	stat->st_isdir = 0;
  8015b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015bd:	00 00 00 
	stat->st_dev = dev;
  8015c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cd:	89 14 24             	mov    %edx,(%esp)
  8015d0:	ff 50 14             	call   *0x14(%eax)
  8015d3:	eb 05                	jmp    8015da <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015da:	83 c4 24             	add    $0x24,%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    

008015e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	56                   	push   %esi
  8015e4:	53                   	push   %ebx
  8015e5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015ef:	00 
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	89 04 24             	mov    %eax,(%esp)
  8015f6:	e8 99 02 00 00       	call   801894 <open>
  8015fb:	89 c3                	mov    %eax,%ebx
  8015fd:	85 db                	test   %ebx,%ebx
  8015ff:	78 1b                	js     80161c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	89 44 24 04          	mov    %eax,0x4(%esp)
  801608:	89 1c 24             	mov    %ebx,(%esp)
  80160b:	e8 56 ff ff ff       	call   801566 <fstat>
  801610:	89 c6                	mov    %eax,%esi
	close(fd);
  801612:	89 1c 24             	mov    %ebx,(%esp)
  801615:	e8 cd fb ff ff       	call   8011e7 <close>
	return r;
  80161a:	89 f0                	mov    %esi,%eax
}
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	5b                   	pop    %ebx
  801620:	5e                   	pop    %esi
  801621:	5d                   	pop    %ebp
  801622:	c3                   	ret    

00801623 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	56                   	push   %esi
  801627:	53                   	push   %ebx
  801628:	83 ec 10             	sub    $0x10,%esp
  80162b:	89 c6                	mov    %eax,%esi
  80162d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80162f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801636:	75 11                	jne    801649 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801638:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80163f:	e8 7b 0e 00 00       	call   8024bf <ipc_find_env>
  801644:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801649:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801650:	00 
  801651:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801658:	00 
  801659:	89 74 24 04          	mov    %esi,0x4(%esp)
  80165d:	a1 00 40 80 00       	mov    0x804000,%eax
  801662:	89 04 24             	mov    %eax,(%esp)
  801665:	e8 ee 0d 00 00       	call   802458 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80166a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801671:	00 
  801672:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801676:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80167d:	e8 6e 0d 00 00       	call   8023f0 <ipc_recv>
}
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	5b                   	pop    %ebx
  801686:	5e                   	pop    %esi
  801687:	5d                   	pop    %ebp
  801688:	c3                   	ret    

00801689 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8b 40 0c             	mov    0xc(%eax),%eax
  801695:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80169a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016ac:	e8 72 ff ff ff       	call   801623 <fsipc>
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bf:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016ce:	e8 50 ff ff ff       	call   801623 <fsipc>
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	53                   	push   %ebx
  8016d9:	83 ec 14             	sub    $0x14,%esp
  8016dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8016f4:	e8 2a ff ff ff       	call   801623 <fsipc>
  8016f9:	89 c2                	mov    %eax,%edx
  8016fb:	85 d2                	test   %edx,%edx
  8016fd:	78 2b                	js     80172a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016ff:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801706:	00 
  801707:	89 1c 24             	mov    %ebx,(%esp)
  80170a:	e8 f8 f0 ff ff       	call   800807 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80170f:	a1 80 50 80 00       	mov    0x805080,%eax
  801714:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80171a:	a1 84 50 80 00       	mov    0x805084,%eax
  80171f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172a:	83 c4 14             	add    $0x14,%esp
  80172d:	5b                   	pop    %ebx
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    

00801730 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	53                   	push   %ebx
  801734:	83 ec 14             	sub    $0x14,%esp
  801737:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80173a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801740:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801745:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801748:	8b 55 08             	mov    0x8(%ebp),%edx
  80174b:	8b 52 0c             	mov    0xc(%edx),%edx
  80174e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  801754:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801759:	89 44 24 08          	mov    %eax,0x8(%esp)
  80175d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801760:	89 44 24 04          	mov    %eax,0x4(%esp)
  801764:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80176b:	e8 34 f2 ff ff       	call   8009a4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801770:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  801777:	00 
  801778:	c7 04 24 18 2c 80 00 	movl   $0x802c18,(%esp)
  80177f:	e8 12 ea ff ff       	call   800196 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801784:	ba 00 00 00 00       	mov    $0x0,%edx
  801789:	b8 04 00 00 00       	mov    $0x4,%eax
  80178e:	e8 90 fe ff ff       	call   801623 <fsipc>
  801793:	85 c0                	test   %eax,%eax
  801795:	78 53                	js     8017ea <devfile_write+0xba>
		return r;
	assert(r <= n);
  801797:	39 c3                	cmp    %eax,%ebx
  801799:	73 24                	jae    8017bf <devfile_write+0x8f>
  80179b:	c7 44 24 0c 1d 2c 80 	movl   $0x802c1d,0xc(%esp)
  8017a2:	00 
  8017a3:	c7 44 24 08 24 2c 80 	movl   $0x802c24,0x8(%esp)
  8017aa:	00 
  8017ab:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  8017b2:	00 
  8017b3:	c7 04 24 39 2c 80 00 	movl   $0x802c39,(%esp)
  8017ba:	e8 d7 0b 00 00       	call   802396 <_panic>
	assert(r <= PGSIZE);
  8017bf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017c4:	7e 24                	jle    8017ea <devfile_write+0xba>
  8017c6:	c7 44 24 0c 44 2c 80 	movl   $0x802c44,0xc(%esp)
  8017cd:	00 
  8017ce:	c7 44 24 08 24 2c 80 	movl   $0x802c24,0x8(%esp)
  8017d5:	00 
  8017d6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8017dd:	00 
  8017de:	c7 04 24 39 2c 80 00 	movl   $0x802c39,(%esp)
  8017e5:	e8 ac 0b 00 00       	call   802396 <_panic>
	return r;
}
  8017ea:	83 c4 14             	add    $0x14,%esp
  8017ed:	5b                   	pop    %ebx
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	56                   	push   %esi
  8017f4:	53                   	push   %ebx
  8017f5:	83 ec 10             	sub    $0x10,%esp
  8017f8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801801:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801806:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80180c:	ba 00 00 00 00       	mov    $0x0,%edx
  801811:	b8 03 00 00 00       	mov    $0x3,%eax
  801816:	e8 08 fe ff ff       	call   801623 <fsipc>
  80181b:	89 c3                	mov    %eax,%ebx
  80181d:	85 c0                	test   %eax,%eax
  80181f:	78 6a                	js     80188b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801821:	39 c6                	cmp    %eax,%esi
  801823:	73 24                	jae    801849 <devfile_read+0x59>
  801825:	c7 44 24 0c 1d 2c 80 	movl   $0x802c1d,0xc(%esp)
  80182c:	00 
  80182d:	c7 44 24 08 24 2c 80 	movl   $0x802c24,0x8(%esp)
  801834:	00 
  801835:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80183c:	00 
  80183d:	c7 04 24 39 2c 80 00 	movl   $0x802c39,(%esp)
  801844:	e8 4d 0b 00 00       	call   802396 <_panic>
	assert(r <= PGSIZE);
  801849:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80184e:	7e 24                	jle    801874 <devfile_read+0x84>
  801850:	c7 44 24 0c 44 2c 80 	movl   $0x802c44,0xc(%esp)
  801857:	00 
  801858:	c7 44 24 08 24 2c 80 	movl   $0x802c24,0x8(%esp)
  80185f:	00 
  801860:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801867:	00 
  801868:	c7 04 24 39 2c 80 00 	movl   $0x802c39,(%esp)
  80186f:	e8 22 0b 00 00       	call   802396 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801874:	89 44 24 08          	mov    %eax,0x8(%esp)
  801878:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80187f:	00 
  801880:	8b 45 0c             	mov    0xc(%ebp),%eax
  801883:	89 04 24             	mov    %eax,(%esp)
  801886:	e8 19 f1 ff ff       	call   8009a4 <memmove>
	return r;
}
  80188b:	89 d8                	mov    %ebx,%eax
  80188d:	83 c4 10             	add    $0x10,%esp
  801890:	5b                   	pop    %ebx
  801891:	5e                   	pop    %esi
  801892:	5d                   	pop    %ebp
  801893:	c3                   	ret    

00801894 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	53                   	push   %ebx
  801898:	83 ec 24             	sub    $0x24,%esp
  80189b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80189e:	89 1c 24             	mov    %ebx,(%esp)
  8018a1:	e8 2a ef ff ff       	call   8007d0 <strlen>
  8018a6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018ab:	7f 60                	jg     80190d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b0:	89 04 24             	mov    %eax,(%esp)
  8018b3:	e8 af f7 ff ff       	call   801067 <fd_alloc>
  8018b8:	89 c2                	mov    %eax,%edx
  8018ba:	85 d2                	test   %edx,%edx
  8018bc:	78 54                	js     801912 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018c2:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018c9:	e8 39 ef ff ff       	call   800807 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d1:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018de:	e8 40 fd ff ff       	call   801623 <fsipc>
  8018e3:	89 c3                	mov    %eax,%ebx
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	79 17                	jns    801900 <open+0x6c>
		fd_close(fd, 0);
  8018e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018f0:	00 
  8018f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f4:	89 04 24             	mov    %eax,(%esp)
  8018f7:	e8 6a f8 ff ff       	call   801166 <fd_close>
		return r;
  8018fc:	89 d8                	mov    %ebx,%eax
  8018fe:	eb 12                	jmp    801912 <open+0x7e>
	}

	return fd2num(fd);
  801900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801903:	89 04 24             	mov    %eax,(%esp)
  801906:	e8 35 f7 ff ff       	call   801040 <fd2num>
  80190b:	eb 05                	jmp    801912 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80190d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801912:	83 c4 24             	add    $0x24,%esp
  801915:	5b                   	pop    %ebx
  801916:	5d                   	pop    %ebp
  801917:	c3                   	ret    

00801918 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80191e:	ba 00 00 00 00       	mov    $0x0,%edx
  801923:	b8 08 00 00 00       	mov    $0x8,%eax
  801928:	e8 f6 fc ff ff       	call   801623 <fsipc>
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <evict>:

int evict(void)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801935:	c7 04 24 50 2c 80 00 	movl   $0x802c50,(%esp)
  80193c:	e8 55 e8 ff ff       	call   800196 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801941:	ba 00 00 00 00       	mov    $0x0,%edx
  801946:	b8 09 00 00 00       	mov    $0x9,%eax
  80194b:	e8 d3 fc ff ff       	call   801623 <fsipc>
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    
  801952:	66 90                	xchg   %ax,%ax
  801954:	66 90                	xchg   %ax,%ax
  801956:	66 90                	xchg   %ax,%ax
  801958:	66 90                	xchg   %ax,%ax
  80195a:	66 90                	xchg   %ax,%ax
  80195c:	66 90                	xchg   %ax,%ax
  80195e:	66 90                	xchg   %ax,%ax

00801960 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801966:	c7 44 24 04 69 2c 80 	movl   $0x802c69,0x4(%esp)
  80196d:	00 
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	89 04 24             	mov    %eax,(%esp)
  801974:	e8 8e ee ff ff       	call   800807 <strcpy>
	return 0;
}
  801979:	b8 00 00 00 00       	mov    $0x0,%eax
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	53                   	push   %ebx
  801984:	83 ec 14             	sub    $0x14,%esp
  801987:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80198a:	89 1c 24             	mov    %ebx,(%esp)
  80198d:	e8 65 0b 00 00       	call   8024f7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801992:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801997:	83 f8 01             	cmp    $0x1,%eax
  80199a:	75 0d                	jne    8019a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80199c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80199f:	89 04 24             	mov    %eax,(%esp)
  8019a2:	e8 29 03 00 00       	call   801cd0 <nsipc_close>
  8019a7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8019a9:	89 d0                	mov    %edx,%eax
  8019ab:	83 c4 14             	add    $0x14,%esp
  8019ae:	5b                   	pop    %ebx
  8019af:	5d                   	pop    %ebp
  8019b0:	c3                   	ret    

008019b1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019be:	00 
  8019bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d3:	89 04 24             	mov    %eax,(%esp)
  8019d6:	e8 f0 03 00 00       	call   801dcb <nsipc_send>
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019ea:	00 
  8019eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ff:	89 04 24             	mov    %eax,(%esp)
  801a02:	e8 44 03 00 00       	call   801d4b <nsipc_recv>
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a0f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a12:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a16:	89 04 24             	mov    %eax,(%esp)
  801a19:	e8 98 f6 ff ff       	call   8010b6 <fd_lookup>
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 17                	js     801a39 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a25:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a2b:	39 08                	cmp    %ecx,(%eax)
  801a2d:	75 05                	jne    801a34 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801a2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a32:	eb 05                	jmp    801a39 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801a34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 20             	sub    $0x20,%esp
  801a43:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a48:	89 04 24             	mov    %eax,(%esp)
  801a4b:	e8 17 f6 ff ff       	call   801067 <fd_alloc>
  801a50:	89 c3                	mov    %eax,%ebx
  801a52:	85 c0                	test   %eax,%eax
  801a54:	78 21                	js     801a77 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a56:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a5d:	00 
  801a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a6c:	e8 04 f2 ff ff       	call   800c75 <sys_page_alloc>
  801a71:	89 c3                	mov    %eax,%ebx
  801a73:	85 c0                	test   %eax,%eax
  801a75:	79 0c                	jns    801a83 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801a77:	89 34 24             	mov    %esi,(%esp)
  801a7a:	e8 51 02 00 00       	call   801cd0 <nsipc_close>
		return r;
  801a7f:	89 d8                	mov    %ebx,%eax
  801a81:	eb 20                	jmp    801aa3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801a83:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a91:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801a98:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801a9b:	89 14 24             	mov    %edx,(%esp)
  801a9e:	e8 9d f5 ff ff       	call   801040 <fd2num>
}
  801aa3:	83 c4 20             	add    $0x20,%esp
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	5d                   	pop    %ebp
  801aa9:	c3                   	ret    

00801aaa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	e8 51 ff ff ff       	call   801a09 <fd2sockid>
		return r;
  801ab8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aba:	85 c0                	test   %eax,%eax
  801abc:	78 23                	js     801ae1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801abe:	8b 55 10             	mov    0x10(%ebp),%edx
  801ac1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801acc:	89 04 24             	mov    %eax,(%esp)
  801acf:	e8 45 01 00 00       	call   801c19 <nsipc_accept>
		return r;
  801ad4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	78 07                	js     801ae1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801ada:	e8 5c ff ff ff       	call   801a3b <alloc_sockfd>
  801adf:	89 c1                	mov    %eax,%ecx
}
  801ae1:	89 c8                	mov    %ecx,%eax
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	e8 16 ff ff ff       	call   801a09 <fd2sockid>
  801af3:	89 c2                	mov    %eax,%edx
  801af5:	85 d2                	test   %edx,%edx
  801af7:	78 16                	js     801b0f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801af9:	8b 45 10             	mov    0x10(%ebp),%eax
  801afc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b07:	89 14 24             	mov    %edx,(%esp)
  801b0a:	e8 60 01 00 00       	call   801c6f <nsipc_bind>
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <shutdown>:

int
shutdown(int s, int how)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	e8 ea fe ff ff       	call   801a09 <fd2sockid>
  801b1f:	89 c2                	mov    %eax,%edx
  801b21:	85 d2                	test   %edx,%edx
  801b23:	78 0f                	js     801b34 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2c:	89 14 24             	mov    %edx,(%esp)
  801b2f:	e8 7a 01 00 00       	call   801cae <nsipc_shutdown>
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	e8 c5 fe ff ff       	call   801a09 <fd2sockid>
  801b44:	89 c2                	mov    %eax,%edx
  801b46:	85 d2                	test   %edx,%edx
  801b48:	78 16                	js     801b60 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801b4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b58:	89 14 24             	mov    %edx,(%esp)
  801b5b:	e8 8a 01 00 00       	call   801cea <nsipc_connect>
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <listen>:

int
listen(int s, int backlog)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	e8 99 fe ff ff       	call   801a09 <fd2sockid>
  801b70:	89 c2                	mov    %eax,%edx
  801b72:	85 d2                	test   %edx,%edx
  801b74:	78 0f                	js     801b85 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7d:	89 14 24             	mov    %edx,(%esp)
  801b80:	e8 a4 01 00 00       	call   801d29 <nsipc_listen>
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	89 04 24             	mov    %eax,(%esp)
  801ba1:	e8 98 02 00 00       	call   801e3e <nsipc_socket>
  801ba6:	89 c2                	mov    %eax,%edx
  801ba8:	85 d2                	test   %edx,%edx
  801baa:	78 05                	js     801bb1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801bac:	e8 8a fe ff ff       	call   801a3b <alloc_sockfd>
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	53                   	push   %ebx
  801bb7:	83 ec 14             	sub    $0x14,%esp
  801bba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bbc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bc3:	75 11                	jne    801bd6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bc5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801bcc:	e8 ee 08 00 00       	call   8024bf <ipc_find_env>
  801bd1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bd6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bdd:	00 
  801bde:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801be5:	00 
  801be6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bea:	a1 04 40 80 00       	mov    0x804004,%eax
  801bef:	89 04 24             	mov    %eax,(%esp)
  801bf2:	e8 61 08 00 00       	call   802458 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bf7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bfe:	00 
  801bff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c06:	00 
  801c07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0e:	e8 dd 07 00 00       	call   8023f0 <ipc_recv>
}
  801c13:	83 c4 14             	add    $0x14,%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    

00801c19 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	56                   	push   %esi
  801c1d:	53                   	push   %ebx
  801c1e:	83 ec 10             	sub    $0x10,%esp
  801c21:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c2c:	8b 06                	mov    (%esi),%eax
  801c2e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c33:	b8 01 00 00 00       	mov    $0x1,%eax
  801c38:	e8 76 ff ff ff       	call   801bb3 <nsipc>
  801c3d:	89 c3                	mov    %eax,%ebx
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	78 23                	js     801c66 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c43:	a1 10 60 80 00       	mov    0x806010,%eax
  801c48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c4c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c53:	00 
  801c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c57:	89 04 24             	mov    %eax,(%esp)
  801c5a:	e8 45 ed ff ff       	call   8009a4 <memmove>
		*addrlen = ret->ret_addrlen;
  801c5f:	a1 10 60 80 00       	mov    0x806010,%eax
  801c64:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801c66:	89 d8                	mov    %ebx,%eax
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    

00801c6f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	53                   	push   %ebx
  801c73:	83 ec 14             	sub    $0x14,%esp
  801c76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c93:	e8 0c ed ff ff       	call   8009a4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c98:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c9e:	b8 02 00 00 00       	mov    $0x2,%eax
  801ca3:	e8 0b ff ff ff       	call   801bb3 <nsipc>
}
  801ca8:	83 c4 14             	add    $0x14,%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5d                   	pop    %ebp
  801cad:	c3                   	ret    

00801cae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cc4:	b8 03 00 00 00       	mov    $0x3,%eax
  801cc9:	e8 e5 fe ff ff       	call   801bb3 <nsipc>
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <nsipc_close>:

int
nsipc_close(int s)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cde:	b8 04 00 00 00       	mov    $0x4,%eax
  801ce3:	e8 cb fe ff ff       	call   801bb3 <nsipc>
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	53                   	push   %ebx
  801cee:	83 ec 14             	sub    $0x14,%esp
  801cf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cfc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d07:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d0e:	e8 91 ec ff ff       	call   8009a4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d13:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d19:	b8 05 00 00 00       	mov    $0x5,%eax
  801d1e:	e8 90 fe ff ff       	call   801bb3 <nsipc>
}
  801d23:	83 c4 14             	add    $0x14,%esp
  801d26:	5b                   	pop    %ebx
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    

00801d29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d3f:	b8 06 00 00 00       	mov    $0x6,%eax
  801d44:	e8 6a fe ff ff       	call   801bb3 <nsipc>
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	83 ec 10             	sub    $0x10,%esp
  801d53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d5e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d64:	8b 45 14             	mov    0x14(%ebp),%eax
  801d67:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d6c:	b8 07 00 00 00       	mov    $0x7,%eax
  801d71:	e8 3d fe ff ff       	call   801bb3 <nsipc>
  801d76:	89 c3                	mov    %eax,%ebx
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	78 46                	js     801dc2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d7c:	39 f0                	cmp    %esi,%eax
  801d7e:	7f 07                	jg     801d87 <nsipc_recv+0x3c>
  801d80:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d85:	7e 24                	jle    801dab <nsipc_recv+0x60>
  801d87:	c7 44 24 0c 75 2c 80 	movl   $0x802c75,0xc(%esp)
  801d8e:	00 
  801d8f:	c7 44 24 08 24 2c 80 	movl   $0x802c24,0x8(%esp)
  801d96:	00 
  801d97:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801d9e:	00 
  801d9f:	c7 04 24 8a 2c 80 00 	movl   $0x802c8a,(%esp)
  801da6:	e8 eb 05 00 00       	call   802396 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dab:	89 44 24 08          	mov    %eax,0x8(%esp)
  801daf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801db6:	00 
  801db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dba:	89 04 24             	mov    %eax,(%esp)
  801dbd:	e8 e2 eb ff ff       	call   8009a4 <memmove>
	}

	return r;
}
  801dc2:	89 d8                	mov    %ebx,%eax
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	53                   	push   %ebx
  801dcf:	83 ec 14             	sub    $0x14,%esp
  801dd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ddd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801de3:	7e 24                	jle    801e09 <nsipc_send+0x3e>
  801de5:	c7 44 24 0c 96 2c 80 	movl   $0x802c96,0xc(%esp)
  801dec:	00 
  801ded:	c7 44 24 08 24 2c 80 	movl   $0x802c24,0x8(%esp)
  801df4:	00 
  801df5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801dfc:	00 
  801dfd:	c7 04 24 8a 2c 80 00 	movl   $0x802c8a,(%esp)
  801e04:	e8 8d 05 00 00       	call   802396 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e14:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801e1b:	e8 84 eb ff ff       	call   8009a4 <memmove>
	nsipcbuf.send.req_size = size;
  801e20:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e26:	8b 45 14             	mov    0x14(%ebp),%eax
  801e29:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e2e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e33:	e8 7b fd ff ff       	call   801bb3 <nsipc>
}
  801e38:	83 c4 14             	add    $0x14,%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5d                   	pop    %ebp
  801e3d:	c3                   	ret    

00801e3e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e54:	8b 45 10             	mov    0x10(%ebp),%eax
  801e57:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e5c:	b8 09 00 00 00       	mov    $0x9,%eax
  801e61:	e8 4d fd ff ff       	call   801bb3 <nsipc>
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	56                   	push   %esi
  801e6c:	53                   	push   %ebx
  801e6d:	83 ec 10             	sub    $0x10,%esp
  801e70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	89 04 24             	mov    %eax,(%esp)
  801e79:	e8 d2 f1 ff ff       	call   801050 <fd2data>
  801e7e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e80:	c7 44 24 04 a2 2c 80 	movl   $0x802ca2,0x4(%esp)
  801e87:	00 
  801e88:	89 1c 24             	mov    %ebx,(%esp)
  801e8b:	e8 77 e9 ff ff       	call   800807 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e90:	8b 46 04             	mov    0x4(%esi),%eax
  801e93:	2b 06                	sub    (%esi),%eax
  801e95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ea2:	00 00 00 
	stat->st_dev = &devpipe;
  801ea5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801eac:	30 80 00 
	return 0;
}
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	5b                   	pop    %ebx
  801eb8:	5e                   	pop    %esi
  801eb9:	5d                   	pop    %ebp
  801eba:	c3                   	ret    

00801ebb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	53                   	push   %ebx
  801ebf:	83 ec 14             	sub    $0x14,%esp
  801ec2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ec5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ec9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ed0:	e8 47 ee ff ff       	call   800d1c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ed5:	89 1c 24             	mov    %ebx,(%esp)
  801ed8:	e8 73 f1 ff ff       	call   801050 <fd2data>
  801edd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee8:	e8 2f ee ff ff       	call   800d1c <sys_page_unmap>
}
  801eed:	83 c4 14             	add    $0x14,%esp
  801ef0:	5b                   	pop    %ebx
  801ef1:	5d                   	pop    %ebp
  801ef2:	c3                   	ret    

00801ef3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	57                   	push   %edi
  801ef7:	56                   	push   %esi
  801ef8:	53                   	push   %ebx
  801ef9:	83 ec 2c             	sub    $0x2c,%esp
  801efc:	89 c6                	mov    %eax,%esi
  801efe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f01:	a1 08 40 80 00       	mov    0x804008,%eax
  801f06:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f09:	89 34 24             	mov    %esi,(%esp)
  801f0c:	e8 e6 05 00 00       	call   8024f7 <pageref>
  801f11:	89 c7                	mov    %eax,%edi
  801f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f16:	89 04 24             	mov    %eax,(%esp)
  801f19:	e8 d9 05 00 00       	call   8024f7 <pageref>
  801f1e:	39 c7                	cmp    %eax,%edi
  801f20:	0f 94 c2             	sete   %dl
  801f23:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f26:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801f2c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f2f:	39 fb                	cmp    %edi,%ebx
  801f31:	74 21                	je     801f54 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f33:	84 d2                	test   %dl,%dl
  801f35:	74 ca                	je     801f01 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f37:	8b 51 58             	mov    0x58(%ecx),%edx
  801f3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f3e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f46:	c7 04 24 a9 2c 80 00 	movl   $0x802ca9,(%esp)
  801f4d:	e8 44 e2 ff ff       	call   800196 <cprintf>
  801f52:	eb ad                	jmp    801f01 <_pipeisclosed+0xe>
	}
}
  801f54:	83 c4 2c             	add    $0x2c,%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	57                   	push   %edi
  801f60:	56                   	push   %esi
  801f61:	53                   	push   %ebx
  801f62:	83 ec 1c             	sub    $0x1c,%esp
  801f65:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f68:	89 34 24             	mov    %esi,(%esp)
  801f6b:	e8 e0 f0 ff ff       	call   801050 <fd2data>
  801f70:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f72:	bf 00 00 00 00       	mov    $0x0,%edi
  801f77:	eb 45                	jmp    801fbe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f79:	89 da                	mov    %ebx,%edx
  801f7b:	89 f0                	mov    %esi,%eax
  801f7d:	e8 71 ff ff ff       	call   801ef3 <_pipeisclosed>
  801f82:	85 c0                	test   %eax,%eax
  801f84:	75 41                	jne    801fc7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f86:	e8 cb ec ff ff       	call   800c56 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f8b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f8e:	8b 0b                	mov    (%ebx),%ecx
  801f90:	8d 51 20             	lea    0x20(%ecx),%edx
  801f93:	39 d0                	cmp    %edx,%eax
  801f95:	73 e2                	jae    801f79 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f9a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f9e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fa1:	99                   	cltd   
  801fa2:	c1 ea 1b             	shr    $0x1b,%edx
  801fa5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801fa8:	83 e1 1f             	and    $0x1f,%ecx
  801fab:	29 d1                	sub    %edx,%ecx
  801fad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801fb1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801fb5:	83 c0 01             	add    $0x1,%eax
  801fb8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fbb:	83 c7 01             	add    $0x1,%edi
  801fbe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fc1:	75 c8                	jne    801f8b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801fc3:	89 f8                	mov    %edi,%eax
  801fc5:	eb 05                	jmp    801fcc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801fcc:	83 c4 1c             	add    $0x1c,%esp
  801fcf:	5b                   	pop    %ebx
  801fd0:	5e                   	pop    %esi
  801fd1:	5f                   	pop    %edi
  801fd2:	5d                   	pop    %ebp
  801fd3:	c3                   	ret    

00801fd4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	57                   	push   %edi
  801fd8:	56                   	push   %esi
  801fd9:	53                   	push   %ebx
  801fda:	83 ec 1c             	sub    $0x1c,%esp
  801fdd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801fe0:	89 3c 24             	mov    %edi,(%esp)
  801fe3:	e8 68 f0 ff ff       	call   801050 <fd2data>
  801fe8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fea:	be 00 00 00 00       	mov    $0x0,%esi
  801fef:	eb 3d                	jmp    80202e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ff1:	85 f6                	test   %esi,%esi
  801ff3:	74 04                	je     801ff9 <devpipe_read+0x25>
				return i;
  801ff5:	89 f0                	mov    %esi,%eax
  801ff7:	eb 43                	jmp    80203c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ff9:	89 da                	mov    %ebx,%edx
  801ffb:	89 f8                	mov    %edi,%eax
  801ffd:	e8 f1 fe ff ff       	call   801ef3 <_pipeisclosed>
  802002:	85 c0                	test   %eax,%eax
  802004:	75 31                	jne    802037 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802006:	e8 4b ec ff ff       	call   800c56 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80200b:	8b 03                	mov    (%ebx),%eax
  80200d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802010:	74 df                	je     801ff1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802012:	99                   	cltd   
  802013:	c1 ea 1b             	shr    $0x1b,%edx
  802016:	01 d0                	add    %edx,%eax
  802018:	83 e0 1f             	and    $0x1f,%eax
  80201b:	29 d0                	sub    %edx,%eax
  80201d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802022:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802025:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802028:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80202b:	83 c6 01             	add    $0x1,%esi
  80202e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802031:	75 d8                	jne    80200b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802033:	89 f0                	mov    %esi,%eax
  802035:	eb 05                	jmp    80203c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80203c:	83 c4 1c             	add    $0x1c,%esp
  80203f:	5b                   	pop    %ebx
  802040:	5e                   	pop    %esi
  802041:	5f                   	pop    %edi
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    

00802044 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	56                   	push   %esi
  802048:	53                   	push   %ebx
  802049:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80204c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80204f:	89 04 24             	mov    %eax,(%esp)
  802052:	e8 10 f0 ff ff       	call   801067 <fd_alloc>
  802057:	89 c2                	mov    %eax,%edx
  802059:	85 d2                	test   %edx,%edx
  80205b:	0f 88 4d 01 00 00    	js     8021ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802061:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802068:	00 
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802070:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802077:	e8 f9 eb ff ff       	call   800c75 <sys_page_alloc>
  80207c:	89 c2                	mov    %eax,%edx
  80207e:	85 d2                	test   %edx,%edx
  802080:	0f 88 28 01 00 00    	js     8021ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802086:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802089:	89 04 24             	mov    %eax,(%esp)
  80208c:	e8 d6 ef ff ff       	call   801067 <fd_alloc>
  802091:	89 c3                	mov    %eax,%ebx
  802093:	85 c0                	test   %eax,%eax
  802095:	0f 88 fe 00 00 00    	js     802199 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80209b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020a2:	00 
  8020a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b1:	e8 bf eb ff ff       	call   800c75 <sys_page_alloc>
  8020b6:	89 c3                	mov    %eax,%ebx
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	0f 88 d9 00 00 00    	js     802199 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	89 04 24             	mov    %eax,(%esp)
  8020c6:	e8 85 ef ff ff       	call   801050 <fd2data>
  8020cb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020cd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020d4:	00 
  8020d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e0:	e8 90 eb ff ff       	call   800c75 <sys_page_alloc>
  8020e5:	89 c3                	mov    %eax,%ebx
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	0f 88 97 00 00 00    	js     802186 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	89 04 24             	mov    %eax,(%esp)
  8020f5:	e8 56 ef ff ff       	call   801050 <fd2data>
  8020fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802101:	00 
  802102:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802106:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80210d:	00 
  80210e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802112:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802119:	e8 ab eb ff ff       	call   800cc9 <sys_page_map>
  80211e:	89 c3                	mov    %eax,%ebx
  802120:	85 c0                	test   %eax,%eax
  802122:	78 52                	js     802176 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802124:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802139:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80213f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802142:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802147:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	89 04 24             	mov    %eax,(%esp)
  802154:	e8 e7 ee ff ff       	call   801040 <fd2num>
  802159:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80215e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802161:	89 04 24             	mov    %eax,(%esp)
  802164:	e8 d7 ee ff ff       	call   801040 <fd2num>
  802169:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80216c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
  802174:	eb 38                	jmp    8021ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802176:	89 74 24 04          	mov    %esi,0x4(%esp)
  80217a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802181:	e8 96 eb ff ff       	call   800d1c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802189:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802194:	e8 83 eb ff ff       	call   800d1c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a7:	e8 70 eb ff ff       	call   800d1c <sys_page_unmap>
  8021ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8021ae:	83 c4 30             	add    $0x30,%esp
  8021b1:	5b                   	pop    %ebx
  8021b2:	5e                   	pop    %esi
  8021b3:	5d                   	pop    %ebp
  8021b4:	c3                   	ret    

008021b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	89 04 24             	mov    %eax,(%esp)
  8021c8:	e8 e9 ee ff ff       	call   8010b6 <fd_lookup>
  8021cd:	89 c2                	mov    %eax,%edx
  8021cf:	85 d2                	test   %edx,%edx
  8021d1:	78 15                	js     8021e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	89 04 24             	mov    %eax,(%esp)
  8021d9:	e8 72 ee ff ff       	call   801050 <fd2data>
	return _pipeisclosed(fd, p);
  8021de:	89 c2                	mov    %eax,%edx
  8021e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e3:	e8 0b fd ff ff       	call   801ef3 <_pipeisclosed>
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	66 90                	xchg   %ax,%ax
  8021ee:	66 90                	xchg   %ax,%ax

008021f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    

008021fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802200:	c7 44 24 04 c1 2c 80 	movl   $0x802cc1,0x4(%esp)
  802207:	00 
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	89 04 24             	mov    %eax,(%esp)
  80220e:	e8 f4 e5 ff ff       	call   800807 <strcpy>
	return 0;
}
  802213:	b8 00 00 00 00       	mov    $0x0,%eax
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	57                   	push   %edi
  80221e:	56                   	push   %esi
  80221f:	53                   	push   %ebx
  802220:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802226:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80222b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802231:	eb 31                	jmp    802264 <devcons_write+0x4a>
		m = n - tot;
  802233:	8b 75 10             	mov    0x10(%ebp),%esi
  802236:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802238:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80223b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802240:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802243:	89 74 24 08          	mov    %esi,0x8(%esp)
  802247:	03 45 0c             	add    0xc(%ebp),%eax
  80224a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224e:	89 3c 24             	mov    %edi,(%esp)
  802251:	e8 4e e7 ff ff       	call   8009a4 <memmove>
		sys_cputs(buf, m);
  802256:	89 74 24 04          	mov    %esi,0x4(%esp)
  80225a:	89 3c 24             	mov    %edi,(%esp)
  80225d:	e8 f4 e8 ff ff       	call   800b56 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802262:	01 f3                	add    %esi,%ebx
  802264:	89 d8                	mov    %ebx,%eax
  802266:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802269:	72 c8                	jb     802233 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80226b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5f                   	pop    %edi
  802274:	5d                   	pop    %ebp
  802275:	c3                   	ret    

00802276 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802281:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802285:	75 07                	jne    80228e <devcons_read+0x18>
  802287:	eb 2a                	jmp    8022b3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802289:	e8 c8 e9 ff ff       	call   800c56 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80228e:	66 90                	xchg   %ax,%ax
  802290:	e8 df e8 ff ff       	call   800b74 <sys_cgetc>
  802295:	85 c0                	test   %eax,%eax
  802297:	74 f0                	je     802289 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802299:	85 c0                	test   %eax,%eax
  80229b:	78 16                	js     8022b3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80229d:	83 f8 04             	cmp    $0x4,%eax
  8022a0:	74 0c                	je     8022ae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8022a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a5:	88 02                	mov    %al,(%edx)
	return 1;
  8022a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ac:	eb 05                	jmp    8022b3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8022ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022c8:	00 
  8022c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022cc:	89 04 24             	mov    %eax,(%esp)
  8022cf:	e8 82 e8 ff ff       	call   800b56 <sys_cputs>
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <getchar>:

int
getchar(void)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022e3:	00 
  8022e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f2:	e8 53 f0 ff ff       	call   80134a <read>
	if (r < 0)
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	78 0f                	js     80230a <getchar+0x34>
		return r;
	if (r < 1)
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	7e 06                	jle    802305 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802303:	eb 05                	jmp    80230a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802305:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802312:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802315:	89 44 24 04          	mov    %eax,0x4(%esp)
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	89 04 24             	mov    %eax,(%esp)
  80231f:	e8 92 ed ff ff       	call   8010b6 <fd_lookup>
  802324:	85 c0                	test   %eax,%eax
  802326:	78 11                	js     802339 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802331:	39 10                	cmp    %edx,(%eax)
  802333:	0f 94 c0             	sete   %al
  802336:	0f b6 c0             	movzbl %al,%eax
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <opencons>:

int
opencons(void)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802341:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802344:	89 04 24             	mov    %eax,(%esp)
  802347:	e8 1b ed ff ff       	call   801067 <fd_alloc>
		return r;
  80234c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80234e:	85 c0                	test   %eax,%eax
  802350:	78 40                	js     802392 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802352:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802359:	00 
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802361:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802368:	e8 08 e9 ff ff       	call   800c75 <sys_page_alloc>
		return r;
  80236d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80236f:	85 c0                	test   %eax,%eax
  802371:	78 1f                	js     802392 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802373:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802388:	89 04 24             	mov    %eax,(%esp)
  80238b:	e8 b0 ec ff ff       	call   801040 <fd2num>
  802390:	89 c2                	mov    %eax,%edx
}
  802392:	89 d0                	mov    %edx,%eax
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	56                   	push   %esi
  80239a:	53                   	push   %ebx
  80239b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80239e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023a1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8023a7:	e8 8b e8 ff ff       	call   800c37 <sys_getenvid>
  8023ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023af:	89 54 24 10          	mov    %edx,0x10(%esp)
  8023b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8023ba:	89 74 24 08          	mov    %esi,0x8(%esp)
  8023be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c2:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  8023c9:	e8 c8 dd ff ff       	call   800196 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8023ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d5:	89 04 24             	mov    %eax,(%esp)
  8023d8:	e8 58 dd ff ff       	call   800135 <vcprintf>
	cprintf("\n");
  8023dd:	c7 04 24 67 2c 80 00 	movl   $0x802c67,(%esp)
  8023e4:	e8 ad dd ff ff       	call   800196 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023e9:	cc                   	int3   
  8023ea:	eb fd                	jmp    8023e9 <_panic+0x53>
  8023ec:	66 90                	xchg   %ax,%ax
  8023ee:	66 90                	xchg   %ax,%ax

008023f0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	56                   	push   %esi
  8023f4:	53                   	push   %ebx
  8023f5:	83 ec 10             	sub    $0x10,%esp
  8023f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8023fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802401:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802403:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802408:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80240b:	89 04 24             	mov    %eax,(%esp)
  80240e:	e8 98 ea ff ff       	call   800eab <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802413:	85 c0                	test   %eax,%eax
  802415:	75 26                	jne    80243d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802417:	85 f6                	test   %esi,%esi
  802419:	74 0a                	je     802425 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80241b:	a1 08 40 80 00       	mov    0x804008,%eax
  802420:	8b 40 74             	mov    0x74(%eax),%eax
  802423:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802425:	85 db                	test   %ebx,%ebx
  802427:	74 0a                	je     802433 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802429:	a1 08 40 80 00       	mov    0x804008,%eax
  80242e:	8b 40 78             	mov    0x78(%eax),%eax
  802431:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802433:	a1 08 40 80 00       	mov    0x804008,%eax
  802438:	8b 40 70             	mov    0x70(%eax),%eax
  80243b:	eb 14                	jmp    802451 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80243d:	85 f6                	test   %esi,%esi
  80243f:	74 06                	je     802447 <ipc_recv+0x57>
			*from_env_store = 0;
  802441:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802447:	85 db                	test   %ebx,%ebx
  802449:	74 06                	je     802451 <ipc_recv+0x61>
			*perm_store = 0;
  80244b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802451:	83 c4 10             	add    $0x10,%esp
  802454:	5b                   	pop    %ebx
  802455:	5e                   	pop    %esi
  802456:	5d                   	pop    %ebp
  802457:	c3                   	ret    

00802458 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	57                   	push   %edi
  80245c:	56                   	push   %esi
  80245d:	53                   	push   %ebx
  80245e:	83 ec 1c             	sub    $0x1c,%esp
  802461:	8b 7d 08             	mov    0x8(%ebp),%edi
  802464:	8b 75 0c             	mov    0xc(%ebp),%esi
  802467:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80246a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80246c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802471:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802474:	8b 45 14             	mov    0x14(%ebp),%eax
  802477:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80247b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80247f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802483:	89 3c 24             	mov    %edi,(%esp)
  802486:	e8 fd e9 ff ff       	call   800e88 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80248b:	85 c0                	test   %eax,%eax
  80248d:	74 28                	je     8024b7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80248f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802492:	74 1c                	je     8024b0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802494:	c7 44 24 08 f4 2c 80 	movl   $0x802cf4,0x8(%esp)
  80249b:	00 
  80249c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8024a3:	00 
  8024a4:	c7 04 24 18 2d 80 00 	movl   $0x802d18,(%esp)
  8024ab:	e8 e6 fe ff ff       	call   802396 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8024b0:	e8 a1 e7 ff ff       	call   800c56 <sys_yield>
	}
  8024b5:	eb bd                	jmp    802474 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8024b7:	83 c4 1c             	add    $0x1c,%esp
  8024ba:	5b                   	pop    %ebx
  8024bb:	5e                   	pop    %esi
  8024bc:	5f                   	pop    %edi
  8024bd:	5d                   	pop    %ebp
  8024be:	c3                   	ret    

008024bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
  8024c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024ca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8024cd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024d3:	8b 52 50             	mov    0x50(%edx),%edx
  8024d6:	39 ca                	cmp    %ecx,%edx
  8024d8:	75 0d                	jne    8024e7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8024da:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024dd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8024e2:	8b 40 40             	mov    0x40(%eax),%eax
  8024e5:	eb 0e                	jmp    8024f5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024e7:	83 c0 01             	add    $0x1,%eax
  8024ea:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024ef:	75 d9                	jne    8024ca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024f1:	66 b8 00 00          	mov    $0x0,%ax
}
  8024f5:	5d                   	pop    %ebp
  8024f6:	c3                   	ret    

008024f7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024fd:	89 d0                	mov    %edx,%eax
  8024ff:	c1 e8 16             	shr    $0x16,%eax
  802502:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80250e:	f6 c1 01             	test   $0x1,%cl
  802511:	74 1d                	je     802530 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802513:	c1 ea 0c             	shr    $0xc,%edx
  802516:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80251d:	f6 c2 01             	test   $0x1,%dl
  802520:	74 0e                	je     802530 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802522:	c1 ea 0c             	shr    $0xc,%edx
  802525:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80252c:	ef 
  80252d:	0f b7 c0             	movzwl %ax,%eax
}
  802530:	5d                   	pop    %ebp
  802531:	c3                   	ret    
  802532:	66 90                	xchg   %ax,%ax
  802534:	66 90                	xchg   %ax,%ax
  802536:	66 90                	xchg   %ax,%ax
  802538:	66 90                	xchg   %ax,%ax
  80253a:	66 90                	xchg   %ax,%ax
  80253c:	66 90                	xchg   %ax,%ax
  80253e:	66 90                	xchg   %ax,%ax

00802540 <__udivdi3>:
  802540:	55                   	push   %ebp
  802541:	57                   	push   %edi
  802542:	56                   	push   %esi
  802543:	83 ec 0c             	sub    $0xc,%esp
  802546:	8b 44 24 28          	mov    0x28(%esp),%eax
  80254a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80254e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802552:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802556:	85 c0                	test   %eax,%eax
  802558:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80255c:	89 ea                	mov    %ebp,%edx
  80255e:	89 0c 24             	mov    %ecx,(%esp)
  802561:	75 2d                	jne    802590 <__udivdi3+0x50>
  802563:	39 e9                	cmp    %ebp,%ecx
  802565:	77 61                	ja     8025c8 <__udivdi3+0x88>
  802567:	85 c9                	test   %ecx,%ecx
  802569:	89 ce                	mov    %ecx,%esi
  80256b:	75 0b                	jne    802578 <__udivdi3+0x38>
  80256d:	b8 01 00 00 00       	mov    $0x1,%eax
  802572:	31 d2                	xor    %edx,%edx
  802574:	f7 f1                	div    %ecx
  802576:	89 c6                	mov    %eax,%esi
  802578:	31 d2                	xor    %edx,%edx
  80257a:	89 e8                	mov    %ebp,%eax
  80257c:	f7 f6                	div    %esi
  80257e:	89 c5                	mov    %eax,%ebp
  802580:	89 f8                	mov    %edi,%eax
  802582:	f7 f6                	div    %esi
  802584:	89 ea                	mov    %ebp,%edx
  802586:	83 c4 0c             	add    $0xc,%esp
  802589:	5e                   	pop    %esi
  80258a:	5f                   	pop    %edi
  80258b:	5d                   	pop    %ebp
  80258c:	c3                   	ret    
  80258d:	8d 76 00             	lea    0x0(%esi),%esi
  802590:	39 e8                	cmp    %ebp,%eax
  802592:	77 24                	ja     8025b8 <__udivdi3+0x78>
  802594:	0f bd e8             	bsr    %eax,%ebp
  802597:	83 f5 1f             	xor    $0x1f,%ebp
  80259a:	75 3c                	jne    8025d8 <__udivdi3+0x98>
  80259c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8025a0:	39 34 24             	cmp    %esi,(%esp)
  8025a3:	0f 86 9f 00 00 00    	jbe    802648 <__udivdi3+0x108>
  8025a9:	39 d0                	cmp    %edx,%eax
  8025ab:	0f 82 97 00 00 00    	jb     802648 <__udivdi3+0x108>
  8025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025b8:	31 d2                	xor    %edx,%edx
  8025ba:	31 c0                	xor    %eax,%eax
  8025bc:	83 c4 0c             	add    $0xc,%esp
  8025bf:	5e                   	pop    %esi
  8025c0:	5f                   	pop    %edi
  8025c1:	5d                   	pop    %ebp
  8025c2:	c3                   	ret    
  8025c3:	90                   	nop
  8025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025c8:	89 f8                	mov    %edi,%eax
  8025ca:	f7 f1                	div    %ecx
  8025cc:	31 d2                	xor    %edx,%edx
  8025ce:	83 c4 0c             	add    $0xc,%esp
  8025d1:	5e                   	pop    %esi
  8025d2:	5f                   	pop    %edi
  8025d3:	5d                   	pop    %ebp
  8025d4:	c3                   	ret    
  8025d5:	8d 76 00             	lea    0x0(%esi),%esi
  8025d8:	89 e9                	mov    %ebp,%ecx
  8025da:	8b 3c 24             	mov    (%esp),%edi
  8025dd:	d3 e0                	shl    %cl,%eax
  8025df:	89 c6                	mov    %eax,%esi
  8025e1:	b8 20 00 00 00       	mov    $0x20,%eax
  8025e6:	29 e8                	sub    %ebp,%eax
  8025e8:	89 c1                	mov    %eax,%ecx
  8025ea:	d3 ef                	shr    %cl,%edi
  8025ec:	89 e9                	mov    %ebp,%ecx
  8025ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025f2:	8b 3c 24             	mov    (%esp),%edi
  8025f5:	09 74 24 08          	or     %esi,0x8(%esp)
  8025f9:	89 d6                	mov    %edx,%esi
  8025fb:	d3 e7                	shl    %cl,%edi
  8025fd:	89 c1                	mov    %eax,%ecx
  8025ff:	89 3c 24             	mov    %edi,(%esp)
  802602:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802606:	d3 ee                	shr    %cl,%esi
  802608:	89 e9                	mov    %ebp,%ecx
  80260a:	d3 e2                	shl    %cl,%edx
  80260c:	89 c1                	mov    %eax,%ecx
  80260e:	d3 ef                	shr    %cl,%edi
  802610:	09 d7                	or     %edx,%edi
  802612:	89 f2                	mov    %esi,%edx
  802614:	89 f8                	mov    %edi,%eax
  802616:	f7 74 24 08          	divl   0x8(%esp)
  80261a:	89 d6                	mov    %edx,%esi
  80261c:	89 c7                	mov    %eax,%edi
  80261e:	f7 24 24             	mull   (%esp)
  802621:	39 d6                	cmp    %edx,%esi
  802623:	89 14 24             	mov    %edx,(%esp)
  802626:	72 30                	jb     802658 <__udivdi3+0x118>
  802628:	8b 54 24 04          	mov    0x4(%esp),%edx
  80262c:	89 e9                	mov    %ebp,%ecx
  80262e:	d3 e2                	shl    %cl,%edx
  802630:	39 c2                	cmp    %eax,%edx
  802632:	73 05                	jae    802639 <__udivdi3+0xf9>
  802634:	3b 34 24             	cmp    (%esp),%esi
  802637:	74 1f                	je     802658 <__udivdi3+0x118>
  802639:	89 f8                	mov    %edi,%eax
  80263b:	31 d2                	xor    %edx,%edx
  80263d:	e9 7a ff ff ff       	jmp    8025bc <__udivdi3+0x7c>
  802642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802648:	31 d2                	xor    %edx,%edx
  80264a:	b8 01 00 00 00       	mov    $0x1,%eax
  80264f:	e9 68 ff ff ff       	jmp    8025bc <__udivdi3+0x7c>
  802654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802658:	8d 47 ff             	lea    -0x1(%edi),%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	83 c4 0c             	add    $0xc,%esp
  802660:	5e                   	pop    %esi
  802661:	5f                   	pop    %edi
  802662:	5d                   	pop    %ebp
  802663:	c3                   	ret    
  802664:	66 90                	xchg   %ax,%ax
  802666:	66 90                	xchg   %ax,%ax
  802668:	66 90                	xchg   %ax,%ax
  80266a:	66 90                	xchg   %ax,%ax
  80266c:	66 90                	xchg   %ax,%ax
  80266e:	66 90                	xchg   %ax,%ax

00802670 <__umoddi3>:
  802670:	55                   	push   %ebp
  802671:	57                   	push   %edi
  802672:	56                   	push   %esi
  802673:	83 ec 14             	sub    $0x14,%esp
  802676:	8b 44 24 28          	mov    0x28(%esp),%eax
  80267a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80267e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802682:	89 c7                	mov    %eax,%edi
  802684:	89 44 24 04          	mov    %eax,0x4(%esp)
  802688:	8b 44 24 30          	mov    0x30(%esp),%eax
  80268c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802690:	89 34 24             	mov    %esi,(%esp)
  802693:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802697:	85 c0                	test   %eax,%eax
  802699:	89 c2                	mov    %eax,%edx
  80269b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80269f:	75 17                	jne    8026b8 <__umoddi3+0x48>
  8026a1:	39 fe                	cmp    %edi,%esi
  8026a3:	76 4b                	jbe    8026f0 <__umoddi3+0x80>
  8026a5:	89 c8                	mov    %ecx,%eax
  8026a7:	89 fa                	mov    %edi,%edx
  8026a9:	f7 f6                	div    %esi
  8026ab:	89 d0                	mov    %edx,%eax
  8026ad:	31 d2                	xor    %edx,%edx
  8026af:	83 c4 14             	add    $0x14,%esp
  8026b2:	5e                   	pop    %esi
  8026b3:	5f                   	pop    %edi
  8026b4:	5d                   	pop    %ebp
  8026b5:	c3                   	ret    
  8026b6:	66 90                	xchg   %ax,%ax
  8026b8:	39 f8                	cmp    %edi,%eax
  8026ba:	77 54                	ja     802710 <__umoddi3+0xa0>
  8026bc:	0f bd e8             	bsr    %eax,%ebp
  8026bf:	83 f5 1f             	xor    $0x1f,%ebp
  8026c2:	75 5c                	jne    802720 <__umoddi3+0xb0>
  8026c4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8026c8:	39 3c 24             	cmp    %edi,(%esp)
  8026cb:	0f 87 e7 00 00 00    	ja     8027b8 <__umoddi3+0x148>
  8026d1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026d5:	29 f1                	sub    %esi,%ecx
  8026d7:	19 c7                	sbb    %eax,%edi
  8026d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026e1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026e5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8026e9:	83 c4 14             	add    $0x14,%esp
  8026ec:	5e                   	pop    %esi
  8026ed:	5f                   	pop    %edi
  8026ee:	5d                   	pop    %ebp
  8026ef:	c3                   	ret    
  8026f0:	85 f6                	test   %esi,%esi
  8026f2:	89 f5                	mov    %esi,%ebp
  8026f4:	75 0b                	jne    802701 <__umoddi3+0x91>
  8026f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026fb:	31 d2                	xor    %edx,%edx
  8026fd:	f7 f6                	div    %esi
  8026ff:	89 c5                	mov    %eax,%ebp
  802701:	8b 44 24 04          	mov    0x4(%esp),%eax
  802705:	31 d2                	xor    %edx,%edx
  802707:	f7 f5                	div    %ebp
  802709:	89 c8                	mov    %ecx,%eax
  80270b:	f7 f5                	div    %ebp
  80270d:	eb 9c                	jmp    8026ab <__umoddi3+0x3b>
  80270f:	90                   	nop
  802710:	89 c8                	mov    %ecx,%eax
  802712:	89 fa                	mov    %edi,%edx
  802714:	83 c4 14             	add    $0x14,%esp
  802717:	5e                   	pop    %esi
  802718:	5f                   	pop    %edi
  802719:	5d                   	pop    %ebp
  80271a:	c3                   	ret    
  80271b:	90                   	nop
  80271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802720:	8b 04 24             	mov    (%esp),%eax
  802723:	be 20 00 00 00       	mov    $0x20,%esi
  802728:	89 e9                	mov    %ebp,%ecx
  80272a:	29 ee                	sub    %ebp,%esi
  80272c:	d3 e2                	shl    %cl,%edx
  80272e:	89 f1                	mov    %esi,%ecx
  802730:	d3 e8                	shr    %cl,%eax
  802732:	89 e9                	mov    %ebp,%ecx
  802734:	89 44 24 04          	mov    %eax,0x4(%esp)
  802738:	8b 04 24             	mov    (%esp),%eax
  80273b:	09 54 24 04          	or     %edx,0x4(%esp)
  80273f:	89 fa                	mov    %edi,%edx
  802741:	d3 e0                	shl    %cl,%eax
  802743:	89 f1                	mov    %esi,%ecx
  802745:	89 44 24 08          	mov    %eax,0x8(%esp)
  802749:	8b 44 24 10          	mov    0x10(%esp),%eax
  80274d:	d3 ea                	shr    %cl,%edx
  80274f:	89 e9                	mov    %ebp,%ecx
  802751:	d3 e7                	shl    %cl,%edi
  802753:	89 f1                	mov    %esi,%ecx
  802755:	d3 e8                	shr    %cl,%eax
  802757:	89 e9                	mov    %ebp,%ecx
  802759:	09 f8                	or     %edi,%eax
  80275b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80275f:	f7 74 24 04          	divl   0x4(%esp)
  802763:	d3 e7                	shl    %cl,%edi
  802765:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802769:	89 d7                	mov    %edx,%edi
  80276b:	f7 64 24 08          	mull   0x8(%esp)
  80276f:	39 d7                	cmp    %edx,%edi
  802771:	89 c1                	mov    %eax,%ecx
  802773:	89 14 24             	mov    %edx,(%esp)
  802776:	72 2c                	jb     8027a4 <__umoddi3+0x134>
  802778:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80277c:	72 22                	jb     8027a0 <__umoddi3+0x130>
  80277e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802782:	29 c8                	sub    %ecx,%eax
  802784:	19 d7                	sbb    %edx,%edi
  802786:	89 e9                	mov    %ebp,%ecx
  802788:	89 fa                	mov    %edi,%edx
  80278a:	d3 e8                	shr    %cl,%eax
  80278c:	89 f1                	mov    %esi,%ecx
  80278e:	d3 e2                	shl    %cl,%edx
  802790:	89 e9                	mov    %ebp,%ecx
  802792:	d3 ef                	shr    %cl,%edi
  802794:	09 d0                	or     %edx,%eax
  802796:	89 fa                	mov    %edi,%edx
  802798:	83 c4 14             	add    $0x14,%esp
  80279b:	5e                   	pop    %esi
  80279c:	5f                   	pop    %edi
  80279d:	5d                   	pop    %ebp
  80279e:	c3                   	ret    
  80279f:	90                   	nop
  8027a0:	39 d7                	cmp    %edx,%edi
  8027a2:	75 da                	jne    80277e <__umoddi3+0x10e>
  8027a4:	8b 14 24             	mov    (%esp),%edx
  8027a7:	89 c1                	mov    %eax,%ecx
  8027a9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8027ad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8027b1:	eb cb                	jmp    80277e <__umoddi3+0x10e>
  8027b3:	90                   	nop
  8027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027b8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8027bc:	0f 82 0f ff ff ff    	jb     8026d1 <__umoddi3+0x61>
  8027c2:	e9 1a ff ff ff       	jmp    8026e1 <__umoddi3+0x71>
