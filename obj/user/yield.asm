
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 6d 00 00 00       	call   80009e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 08 40 80 00       	mov    0x804008,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	89 44 24 04          	mov    %eax,0x4(%esp)
  800046:	c7 04 24 20 27 80 00 	movl   $0x802720,(%esp)
  80004d:	e8 50 01 00 00       	call   8001a2 <cprintf>
	for (i = 0; i < 5; i++) {
  800052:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800057:	e8 0a 0c 00 00       	call   800c66 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005c:	a1 08 40 80 00       	mov    0x804008,%eax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  800061:	8b 40 48             	mov    0x48(%eax),%eax
  800064:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006c:	c7 04 24 40 27 80 00 	movl   $0x802740,(%esp)
  800073:	e8 2a 01 00 00       	call   8001a2 <cprintf>
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  800078:	83 c3 01             	add    $0x1,%ebx
  80007b:	83 fb 05             	cmp    $0x5,%ebx
  80007e:	75 d7                	jne    800057 <umain+0x24>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800080:	a1 08 40 80 00       	mov    0x804008,%eax
  800085:	8b 40 48             	mov    0x48(%eax),%eax
  800088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008c:	c7 04 24 6c 27 80 00 	movl   $0x80276c,(%esp)
  800093:	e8 0a 01 00 00       	call   8001a2 <cprintf>
}
  800098:	83 c4 14             	add    $0x14,%esp
  80009b:	5b                   	pop    %ebx
  80009c:	5d                   	pop    %ebp
  80009d:	c3                   	ret    

0080009e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	56                   	push   %esi
  8000a2:	53                   	push   %ebx
  8000a3:	83 ec 10             	sub    $0x10,%esp
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ac:	e8 96 0b 00 00       	call   800c47 <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000be:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c3:	85 db                	test   %ebx,%ebx
  8000c5:	7e 07                	jle    8000ce <libmain+0x30>
		binaryname = argv[0];
  8000c7:	8b 06                	mov    (%esi),%eax
  8000c9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000d2:	89 1c 24             	mov    %ebx,(%esp)
  8000d5:	e8 59 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000da:	e8 07 00 00 00       	call   8000e6 <exit>
}
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	5b                   	pop    %ebx
  8000e3:	5e                   	pop    %esi
  8000e4:	5d                   	pop    %ebp
  8000e5:	c3                   	ret    

008000e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000ec:	e8 79 10 00 00       	call   80116a <close_all>
	sys_env_destroy(0);
  8000f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f8:	e8 a6 0a 00 00       	call   800ba3 <sys_env_destroy>
}
  8000fd:	c9                   	leave  
  8000fe:	c3                   	ret    

008000ff <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	53                   	push   %ebx
  800103:	83 ec 14             	sub    $0x14,%esp
  800106:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800109:	8b 13                	mov    (%ebx),%edx
  80010b:	8d 42 01             	lea    0x1(%edx),%eax
  80010e:	89 03                	mov    %eax,(%ebx)
  800110:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800113:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800117:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011c:	75 19                	jne    800137 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80011e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800125:	00 
  800126:	8d 43 08             	lea    0x8(%ebx),%eax
  800129:	89 04 24             	mov    %eax,(%esp)
  80012c:	e8 35 0a 00 00       	call   800b66 <sys_cputs>
		b->idx = 0;
  800131:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800137:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013b:	83 c4 14             	add    $0x14,%esp
  80013e:	5b                   	pop    %ebx
  80013f:	5d                   	pop    %ebp
  800140:	c3                   	ret    

00800141 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80014a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800151:	00 00 00 
	b.cnt = 0;
  800154:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800161:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800165:	8b 45 08             	mov    0x8(%ebp),%eax
  800168:	89 44 24 08          	mov    %eax,0x8(%esp)
  80016c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800172:	89 44 24 04          	mov    %eax,0x4(%esp)
  800176:	c7 04 24 ff 00 80 00 	movl   $0x8000ff,(%esp)
  80017d:	e8 72 01 00 00       	call   8002f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800182:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800188:	89 44 24 04          	mov    %eax,0x4(%esp)
  80018c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800192:	89 04 24             	mov    %eax,(%esp)
  800195:	e8 cc 09 00 00       	call   800b66 <sys_cputs>

	return b.cnt;
}
  80019a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    

008001a2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001af:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b2:	89 04 24             	mov    %eax,(%esp)
  8001b5:	e8 87 ff ff ff       	call   800141 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ba:	c9                   	leave  
  8001bb:	c3                   	ret    
  8001bc:	66 90                	xchg   %ax,%ax
  8001be:	66 90                	xchg   %ax,%ax

008001c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 3c             	sub    $0x3c,%esp
  8001c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001cc:	89 d7                	mov    %edx,%edi
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	89 c3                	mov    %eax,%ebx
  8001d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ed:	39 d9                	cmp    %ebx,%ecx
  8001ef:	72 05                	jb     8001f6 <printnum+0x36>
  8001f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001f4:	77 69                	ja     80025f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001fd:	83 ee 01             	sub    $0x1,%esi
  800200:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800204:	89 44 24 08          	mov    %eax,0x8(%esp)
  800208:	8b 44 24 08          	mov    0x8(%esp),%eax
  80020c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800210:	89 c3                	mov    %eax,%ebx
  800212:	89 d6                	mov    %edx,%esi
  800214:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800217:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80021a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80021e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800225:	89 04 24             	mov    %eax,(%esp)
  800228:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80022b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022f:	e8 5c 22 00 00       	call   802490 <__udivdi3>
  800234:	89 d9                	mov    %ebx,%ecx
  800236:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80023a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80023e:	89 04 24             	mov    %eax,(%esp)
  800241:	89 54 24 04          	mov    %edx,0x4(%esp)
  800245:	89 fa                	mov    %edi,%edx
  800247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024a:	e8 71 ff ff ff       	call   8001c0 <printnum>
  80024f:	eb 1b                	jmp    80026c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800251:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800255:	8b 45 18             	mov    0x18(%ebp),%eax
  800258:	89 04 24             	mov    %eax,(%esp)
  80025b:	ff d3                	call   *%ebx
  80025d:	eb 03                	jmp    800262 <printnum+0xa2>
  80025f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800262:	83 ee 01             	sub    $0x1,%esi
  800265:	85 f6                	test   %esi,%esi
  800267:	7f e8                	jg     800251 <printnum+0x91>
  800269:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80026c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800270:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800274:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800277:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80027a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80027e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028f:	e8 2c 23 00 00       	call   8025c0 <__umoddi3>
  800294:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800298:	0f be 80 95 27 80 00 	movsbl 0x802795(%eax),%eax
  80029f:	89 04 24             	mov    %eax,(%esp)
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	ff d0                	call   *%eax
}
  8002a7:	83 c4 3c             	add    $0x3c,%esp
  8002aa:	5b                   	pop    %ebx
  8002ab:	5e                   	pop    %esi
  8002ac:	5f                   	pop    %edi
  8002ad:	5d                   	pop    %ebp
  8002ae:	c3                   	ret    

008002af <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002b9:	8b 10                	mov    (%eax),%edx
  8002bb:	3b 50 04             	cmp    0x4(%eax),%edx
  8002be:	73 0a                	jae    8002ca <sprintputch+0x1b>
		*b->buf++ = ch;
  8002c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c3:	89 08                	mov    %ecx,(%eax)
  8002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c8:	88 02                	mov    %al,(%edx)
}
  8002ca:	5d                   	pop    %ebp
  8002cb:	c3                   	ret    

008002cc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002d2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	89 04 24             	mov    %eax,(%esp)
  8002ed:	e8 02 00 00 00       	call   8002f4 <vprintfmt>
	va_end(ap);
}
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	57                   	push   %edi
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	83 ec 3c             	sub    $0x3c,%esp
  8002fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800300:	eb 17                	jmp    800319 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800302:	85 c0                	test   %eax,%eax
  800304:	0f 84 4b 04 00 00    	je     800755 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80030a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80030d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800311:	89 04 24             	mov    %eax,(%esp)
  800314:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800317:	89 fb                	mov    %edi,%ebx
  800319:	8d 7b 01             	lea    0x1(%ebx),%edi
  80031c:	0f b6 03             	movzbl (%ebx),%eax
  80031f:	83 f8 25             	cmp    $0x25,%eax
  800322:	75 de                	jne    800302 <vprintfmt+0xe>
  800324:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800328:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80032f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800334:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80033b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800340:	eb 18                	jmp    80035a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800342:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800344:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800348:	eb 10                	jmp    80035a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80034a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80034c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800350:	eb 08                	jmp    80035a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800352:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800355:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80035a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80035d:	0f b6 17             	movzbl (%edi),%edx
  800360:	0f b6 c2             	movzbl %dl,%eax
  800363:	83 ea 23             	sub    $0x23,%edx
  800366:	80 fa 55             	cmp    $0x55,%dl
  800369:	0f 87 c2 03 00 00    	ja     800731 <vprintfmt+0x43d>
  80036f:	0f b6 d2             	movzbl %dl,%edx
  800372:	ff 24 95 e0 28 80 00 	jmp    *0x8028e0(,%edx,4)
  800379:	89 df                	mov    %ebx,%edi
  80037b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800380:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800383:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800387:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80038a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80038d:	83 fa 09             	cmp    $0x9,%edx
  800390:	77 33                	ja     8003c5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800392:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800395:	eb e9                	jmp    800380 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800397:	8b 45 14             	mov    0x14(%ebp),%eax
  80039a:	8b 30                	mov    (%eax),%esi
  80039c:	8d 40 04             	lea    0x4(%eax),%eax
  80039f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003a4:	eb 1f                	jmp    8003c5 <vprintfmt+0xd1>
  8003a6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8003a9:	85 ff                	test   %edi,%edi
  8003ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b0:	0f 49 c7             	cmovns %edi,%eax
  8003b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	89 df                	mov    %ebx,%edi
  8003b8:	eb a0                	jmp    80035a <vprintfmt+0x66>
  8003ba:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003bc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8003c3:	eb 95                	jmp    80035a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8003c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c9:	79 8f                	jns    80035a <vprintfmt+0x66>
  8003cb:	eb 85                	jmp    800352 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003cd:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003d2:	eb 86                	jmp    80035a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d7:	8d 70 04             	lea    0x4(%eax),%esi
  8003da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e4:	8b 00                	mov    (%eax),%eax
  8003e6:	89 04 24             	mov    %eax,(%esp)
  8003e9:	ff 55 08             	call   *0x8(%ebp)
  8003ec:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8003ef:	e9 25 ff ff ff       	jmp    800319 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f7:	8d 70 04             	lea    0x4(%eax),%esi
  8003fa:	8b 00                	mov    (%eax),%eax
  8003fc:	99                   	cltd   
  8003fd:	31 d0                	xor    %edx,%eax
  8003ff:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800401:	83 f8 15             	cmp    $0x15,%eax
  800404:	7f 0b                	jg     800411 <vprintfmt+0x11d>
  800406:	8b 14 85 40 2a 80 00 	mov    0x802a40(,%eax,4),%edx
  80040d:	85 d2                	test   %edx,%edx
  80040f:	75 26                	jne    800437 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800411:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800415:	c7 44 24 08 ad 27 80 	movl   $0x8027ad,0x8(%esp)
  80041c:	00 
  80041d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800420:	89 44 24 04          	mov    %eax,0x4(%esp)
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	89 04 24             	mov    %eax,(%esp)
  80042a:	e8 9d fe ff ff       	call   8002cc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80042f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800432:	e9 e2 fe ff ff       	jmp    800319 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800437:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80043b:	c7 44 24 08 92 2b 80 	movl   $0x802b92,0x8(%esp)
  800442:	00 
  800443:	8b 45 0c             	mov    0xc(%ebp),%eax
  800446:	89 44 24 04          	mov    %eax,0x4(%esp)
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	89 04 24             	mov    %eax,(%esp)
  800450:	e8 77 fe ff ff       	call   8002cc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800455:	89 75 14             	mov    %esi,0x14(%ebp)
  800458:	e9 bc fe ff ff       	jmp    800319 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045d:	8b 45 14             	mov    0x14(%ebp),%eax
  800460:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800463:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800466:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80046a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80046c:	85 ff                	test   %edi,%edi
  80046e:	b8 a6 27 80 00       	mov    $0x8027a6,%eax
  800473:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800476:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80047a:	0f 84 94 00 00 00    	je     800514 <vprintfmt+0x220>
  800480:	85 c9                	test   %ecx,%ecx
  800482:	0f 8e 94 00 00 00    	jle    80051c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800488:	89 74 24 04          	mov    %esi,0x4(%esp)
  80048c:	89 3c 24             	mov    %edi,(%esp)
  80048f:	e8 64 03 00 00       	call   8007f8 <strnlen>
  800494:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800497:	29 c1                	sub    %eax,%ecx
  800499:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80049c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  8004a0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8004a3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004ac:	89 cb                	mov    %ecx,%ebx
  8004ae:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b0:	eb 0f                	jmp    8004c1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  8004b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b9:	89 3c 24             	mov    %edi,(%esp)
  8004bc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004be:	83 eb 01             	sub    $0x1,%ebx
  8004c1:	85 db                	test   %ebx,%ebx
  8004c3:	7f ed                	jg     8004b2 <vprintfmt+0x1be>
  8004c5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8004c8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004cb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ce:	85 c9                	test   %ecx,%ecx
  8004d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d5:	0f 49 c1             	cmovns %ecx,%eax
  8004d8:	29 c1                	sub    %eax,%ecx
  8004da:	89 cb                	mov    %ecx,%ebx
  8004dc:	eb 44                	jmp    800522 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004e2:	74 1e                	je     800502 <vprintfmt+0x20e>
  8004e4:	0f be d2             	movsbl %dl,%edx
  8004e7:	83 ea 20             	sub    $0x20,%edx
  8004ea:	83 fa 5e             	cmp    $0x5e,%edx
  8004ed:	76 13                	jbe    800502 <vprintfmt+0x20e>
					putch('?', putdat);
  8004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8004fd:	ff 55 08             	call   *0x8(%ebp)
  800500:	eb 0d                	jmp    80050f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800502:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800505:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800509:	89 04 24             	mov    %eax,(%esp)
  80050c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050f:	83 eb 01             	sub    $0x1,%ebx
  800512:	eb 0e                	jmp    800522 <vprintfmt+0x22e>
  800514:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800517:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80051a:	eb 06                	jmp    800522 <vprintfmt+0x22e>
  80051c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80051f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800522:	83 c7 01             	add    $0x1,%edi
  800525:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800529:	0f be c2             	movsbl %dl,%eax
  80052c:	85 c0                	test   %eax,%eax
  80052e:	74 27                	je     800557 <vprintfmt+0x263>
  800530:	85 f6                	test   %esi,%esi
  800532:	78 aa                	js     8004de <vprintfmt+0x1ea>
  800534:	83 ee 01             	sub    $0x1,%esi
  800537:	79 a5                	jns    8004de <vprintfmt+0x1ea>
  800539:	89 d8                	mov    %ebx,%eax
  80053b:	8b 75 08             	mov    0x8(%ebp),%esi
  80053e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800541:	89 c3                	mov    %eax,%ebx
  800543:	eb 18                	jmp    80055d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800545:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800549:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800550:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800552:	83 eb 01             	sub    $0x1,%ebx
  800555:	eb 06                	jmp    80055d <vprintfmt+0x269>
  800557:	8b 75 08             	mov    0x8(%ebp),%esi
  80055a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80055d:	85 db                	test   %ebx,%ebx
  80055f:	7f e4                	jg     800545 <vprintfmt+0x251>
  800561:	89 75 08             	mov    %esi,0x8(%ebp)
  800564:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800567:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80056a:	e9 aa fd ff ff       	jmp    800319 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80056f:	83 f9 01             	cmp    $0x1,%ecx
  800572:	7e 10                	jle    800584 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8b 30                	mov    (%eax),%esi
  800579:	8b 78 04             	mov    0x4(%eax),%edi
  80057c:	8d 40 08             	lea    0x8(%eax),%eax
  80057f:	89 45 14             	mov    %eax,0x14(%ebp)
  800582:	eb 26                	jmp    8005aa <vprintfmt+0x2b6>
	else if (lflag)
  800584:	85 c9                	test   %ecx,%ecx
  800586:	74 12                	je     80059a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8b 30                	mov    (%eax),%esi
  80058d:	89 f7                	mov    %esi,%edi
  80058f:	c1 ff 1f             	sar    $0x1f,%edi
  800592:	8d 40 04             	lea    0x4(%eax),%eax
  800595:	89 45 14             	mov    %eax,0x14(%ebp)
  800598:	eb 10                	jmp    8005aa <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 30                	mov    (%eax),%esi
  80059f:	89 f7                	mov    %esi,%edi
  8005a1:	c1 ff 1f             	sar    $0x1f,%edi
  8005a4:	8d 40 04             	lea    0x4(%eax),%eax
  8005a7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005aa:	89 f0                	mov    %esi,%eax
  8005ac:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005b3:	85 ff                	test   %edi,%edi
  8005b5:	0f 89 3a 01 00 00    	jns    8006f5 <vprintfmt+0x401>
				putch('-', putdat);
  8005bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005c9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005cc:	89 f0                	mov    %esi,%eax
  8005ce:	89 fa                	mov    %edi,%edx
  8005d0:	f7 d8                	neg    %eax
  8005d2:	83 d2 00             	adc    $0x0,%edx
  8005d5:	f7 da                	neg    %edx
			}
			base = 10;
  8005d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005dc:	e9 14 01 00 00       	jmp    8006f5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005e1:	83 f9 01             	cmp    $0x1,%ecx
  8005e4:	7e 13                	jle    8005f9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	8b 50 04             	mov    0x4(%eax),%edx
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	8b 75 14             	mov    0x14(%ebp),%esi
  8005f1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8005f4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005f7:	eb 2c                	jmp    800625 <vprintfmt+0x331>
	else if (lflag)
  8005f9:	85 c9                	test   %ecx,%ecx
  8005fb:	74 15                	je     800612 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 00                	mov    (%eax),%eax
  800602:	ba 00 00 00 00       	mov    $0x0,%edx
  800607:	8b 75 14             	mov    0x14(%ebp),%esi
  80060a:	8d 76 04             	lea    0x4(%esi),%esi
  80060d:	89 75 14             	mov    %esi,0x14(%ebp)
  800610:	eb 13                	jmp    800625 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	ba 00 00 00 00       	mov    $0x0,%edx
  80061c:	8b 75 14             	mov    0x14(%ebp),%esi
  80061f:	8d 76 04             	lea    0x4(%esi),%esi
  800622:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800625:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80062a:	e9 c6 00 00 00       	jmp    8006f5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80062f:	83 f9 01             	cmp    $0x1,%ecx
  800632:	7e 13                	jle    800647 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 50 04             	mov    0x4(%eax),%edx
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	8b 75 14             	mov    0x14(%ebp),%esi
  80063f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800642:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800645:	eb 24                	jmp    80066b <vprintfmt+0x377>
	else if (lflag)
  800647:	85 c9                	test   %ecx,%ecx
  800649:	74 11                	je     80065c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	99                   	cltd   
  800651:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800654:	8d 71 04             	lea    0x4(%ecx),%esi
  800657:	89 75 14             	mov    %esi,0x14(%ebp)
  80065a:	eb 0f                	jmp    80066b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	99                   	cltd   
  800662:	8b 75 14             	mov    0x14(%ebp),%esi
  800665:	8d 76 04             	lea    0x4(%esi),%esi
  800668:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80066b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800670:	e9 80 00 00 00       	jmp    8006f5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800675:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800678:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80067f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800686:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800690:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800697:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80069a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80069e:	8b 06                	mov    (%esi),%eax
  8006a0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006a5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006aa:	eb 49                	jmp    8006f5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006ac:	83 f9 01             	cmp    $0x1,%ecx
  8006af:	7e 13                	jle    8006c4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 50 04             	mov    0x4(%eax),%edx
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	8b 75 14             	mov    0x14(%ebp),%esi
  8006bc:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006bf:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006c2:	eb 2c                	jmp    8006f0 <vprintfmt+0x3fc>
	else if (lflag)
  8006c4:	85 c9                	test   %ecx,%ecx
  8006c6:	74 15                	je     8006dd <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8006d5:	8d 71 04             	lea    0x4(%ecx),%esi
  8006d8:	89 75 14             	mov    %esi,0x14(%ebp)
  8006db:	eb 13                	jmp    8006f0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e7:	8b 75 14             	mov    0x14(%ebp),%esi
  8006ea:	8d 76 04             	lea    0x4(%esi),%esi
  8006ed:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8006f0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006f5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8006f9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006fd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800700:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800704:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800708:	89 04 24             	mov    %eax,(%esp)
  80070b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80070f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	e8 a6 fa ff ff       	call   8001c0 <printnum>
			break;
  80071a:	e9 fa fb ff ff       	jmp    800319 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80071f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800722:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800726:	89 04 24             	mov    %eax,(%esp)
  800729:	ff 55 08             	call   *0x8(%ebp)
			break;
  80072c:	e9 e8 fb ff ff       	jmp    800319 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800731:	8b 45 0c             	mov    0xc(%ebp),%eax
  800734:	89 44 24 04          	mov    %eax,0x4(%esp)
  800738:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80073f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800742:	89 fb                	mov    %edi,%ebx
  800744:	eb 03                	jmp    800749 <vprintfmt+0x455>
  800746:	83 eb 01             	sub    $0x1,%ebx
  800749:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80074d:	75 f7                	jne    800746 <vprintfmt+0x452>
  80074f:	90                   	nop
  800750:	e9 c4 fb ff ff       	jmp    800319 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800755:	83 c4 3c             	add    $0x3c,%esp
  800758:	5b                   	pop    %ebx
  800759:	5e                   	pop    %esi
  80075a:	5f                   	pop    %edi
  80075b:	5d                   	pop    %ebp
  80075c:	c3                   	ret    

0080075d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
  800760:	83 ec 28             	sub    $0x28,%esp
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800769:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80076c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800770:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077a:	85 c0                	test   %eax,%eax
  80077c:	74 30                	je     8007ae <vsnprintf+0x51>
  80077e:	85 d2                	test   %edx,%edx
  800780:	7e 2c                	jle    8007ae <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800789:	8b 45 10             	mov    0x10(%ebp),%eax
  80078c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800790:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800793:	89 44 24 04          	mov    %eax,0x4(%esp)
  800797:	c7 04 24 af 02 80 00 	movl   $0x8002af,(%esp)
  80079e:	e8 51 fb ff ff       	call   8002f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ac:	eb 05                	jmp    8007b3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    

008007b5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007bb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 04 24             	mov    %eax,(%esp)
  8007d6:	e8 82 ff ff ff       	call   80075d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007db:	c9                   	leave  
  8007dc:	c3                   	ret    
  8007dd:	66 90                	xchg   %ax,%ax
  8007df:	90                   	nop

008007e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	eb 03                	jmp    8007f0 <strlen+0x10>
		n++;
  8007ed:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f4:	75 f7                	jne    8007ed <strlen+0xd>
		n++;
	return n;
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800801:	b8 00 00 00 00       	mov    $0x0,%eax
  800806:	eb 03                	jmp    80080b <strnlen+0x13>
		n++;
  800808:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080b:	39 d0                	cmp    %edx,%eax
  80080d:	74 06                	je     800815 <strnlen+0x1d>
  80080f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800813:	75 f3                	jne    800808 <strnlen+0x10>
		n++;
	return n;
}
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800821:	89 c2                	mov    %eax,%edx
  800823:	83 c2 01             	add    $0x1,%edx
  800826:	83 c1 01             	add    $0x1,%ecx
  800829:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80082d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800830:	84 db                	test   %bl,%bl
  800832:	75 ef                	jne    800823 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800834:	5b                   	pop    %ebx
  800835:	5d                   	pop    %ebp
  800836:	c3                   	ret    

00800837 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	53                   	push   %ebx
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800841:	89 1c 24             	mov    %ebx,(%esp)
  800844:	e8 97 ff ff ff       	call   8007e0 <strlen>
	strcpy(dst + len, src);
  800849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800850:	01 d8                	add    %ebx,%eax
  800852:	89 04 24             	mov    %eax,(%esp)
  800855:	e8 bd ff ff ff       	call   800817 <strcpy>
	return dst;
}
  80085a:	89 d8                	mov    %ebx,%eax
  80085c:	83 c4 08             	add    $0x8,%esp
  80085f:	5b                   	pop    %ebx
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	56                   	push   %esi
  800866:	53                   	push   %ebx
  800867:	8b 75 08             	mov    0x8(%ebp),%esi
  80086a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80086d:	89 f3                	mov    %esi,%ebx
  80086f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800872:	89 f2                	mov    %esi,%edx
  800874:	eb 0f                	jmp    800885 <strncpy+0x23>
		*dst++ = *src;
  800876:	83 c2 01             	add    $0x1,%edx
  800879:	0f b6 01             	movzbl (%ecx),%eax
  80087c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80087f:	80 39 01             	cmpb   $0x1,(%ecx)
  800882:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800885:	39 da                	cmp    %ebx,%edx
  800887:	75 ed                	jne    800876 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800889:	89 f0                	mov    %esi,%eax
  80088b:	5b                   	pop    %ebx
  80088c:	5e                   	pop    %esi
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	56                   	push   %esi
  800893:	53                   	push   %ebx
  800894:	8b 75 08             	mov    0x8(%ebp),%esi
  800897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80089d:	89 f0                	mov    %esi,%eax
  80089f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a3:	85 c9                	test   %ecx,%ecx
  8008a5:	75 0b                	jne    8008b2 <strlcpy+0x23>
  8008a7:	eb 1d                	jmp    8008c6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	83 c2 01             	add    $0x1,%edx
  8008af:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008b2:	39 d8                	cmp    %ebx,%eax
  8008b4:	74 0b                	je     8008c1 <strlcpy+0x32>
  8008b6:	0f b6 0a             	movzbl (%edx),%ecx
  8008b9:	84 c9                	test   %cl,%cl
  8008bb:	75 ec                	jne    8008a9 <strlcpy+0x1a>
  8008bd:	89 c2                	mov    %eax,%edx
  8008bf:	eb 02                	jmp    8008c3 <strlcpy+0x34>
  8008c1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008c3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8008c6:	29 f0                	sub    %esi,%eax
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5e                   	pop    %esi
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008d5:	eb 06                	jmp    8008dd <strcmp+0x11>
		p++, q++;
  8008d7:	83 c1 01             	add    $0x1,%ecx
  8008da:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008dd:	0f b6 01             	movzbl (%ecx),%eax
  8008e0:	84 c0                	test   %al,%al
  8008e2:	74 04                	je     8008e8 <strcmp+0x1c>
  8008e4:	3a 02                	cmp    (%edx),%al
  8008e6:	74 ef                	je     8008d7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e8:	0f b6 c0             	movzbl %al,%eax
  8008eb:	0f b6 12             	movzbl (%edx),%edx
  8008ee:	29 d0                	sub    %edx,%eax
}
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    

008008f2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	53                   	push   %ebx
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fc:	89 c3                	mov    %eax,%ebx
  8008fe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800901:	eb 06                	jmp    800909 <strncmp+0x17>
		n--, p++, q++;
  800903:	83 c0 01             	add    $0x1,%eax
  800906:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800909:	39 d8                	cmp    %ebx,%eax
  80090b:	74 15                	je     800922 <strncmp+0x30>
  80090d:	0f b6 08             	movzbl (%eax),%ecx
  800910:	84 c9                	test   %cl,%cl
  800912:	74 04                	je     800918 <strncmp+0x26>
  800914:	3a 0a                	cmp    (%edx),%cl
  800916:	74 eb                	je     800903 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800918:	0f b6 00             	movzbl (%eax),%eax
  80091b:	0f b6 12             	movzbl (%edx),%edx
  80091e:	29 d0                	sub    %edx,%eax
  800920:	eb 05                	jmp    800927 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800922:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800927:	5b                   	pop    %ebx
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800934:	eb 07                	jmp    80093d <strchr+0x13>
		if (*s == c)
  800936:	38 ca                	cmp    %cl,%dl
  800938:	74 0f                	je     800949 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80093a:	83 c0 01             	add    $0x1,%eax
  80093d:	0f b6 10             	movzbl (%eax),%edx
  800940:	84 d2                	test   %dl,%dl
  800942:	75 f2                	jne    800936 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800955:	eb 07                	jmp    80095e <strfind+0x13>
		if (*s == c)
  800957:	38 ca                	cmp    %cl,%dl
  800959:	74 0a                	je     800965 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80095b:	83 c0 01             	add    $0x1,%eax
  80095e:	0f b6 10             	movzbl (%eax),%edx
  800961:	84 d2                	test   %dl,%dl
  800963:	75 f2                	jne    800957 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	57                   	push   %edi
  80096b:	56                   	push   %esi
  80096c:	53                   	push   %ebx
  80096d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800970:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800973:	85 c9                	test   %ecx,%ecx
  800975:	74 36                	je     8009ad <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800977:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80097d:	75 28                	jne    8009a7 <memset+0x40>
  80097f:	f6 c1 03             	test   $0x3,%cl
  800982:	75 23                	jne    8009a7 <memset+0x40>
		c &= 0xFF;
  800984:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800988:	89 d3                	mov    %edx,%ebx
  80098a:	c1 e3 08             	shl    $0x8,%ebx
  80098d:	89 d6                	mov    %edx,%esi
  80098f:	c1 e6 18             	shl    $0x18,%esi
  800992:	89 d0                	mov    %edx,%eax
  800994:	c1 e0 10             	shl    $0x10,%eax
  800997:	09 f0                	or     %esi,%eax
  800999:	09 c2                	or     %eax,%edx
  80099b:	89 d0                	mov    %edx,%eax
  80099d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80099f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009a2:	fc                   	cld    
  8009a3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a5:	eb 06                	jmp    8009ad <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009aa:	fc                   	cld    
  8009ab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ad:	89 f8                	mov    %edi,%eax
  8009af:	5b                   	pop    %ebx
  8009b0:	5e                   	pop    %esi
  8009b1:	5f                   	pop    %edi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	57                   	push   %edi
  8009b8:	56                   	push   %esi
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c2:	39 c6                	cmp    %eax,%esi
  8009c4:	73 35                	jae    8009fb <memmove+0x47>
  8009c6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009c9:	39 d0                	cmp    %edx,%eax
  8009cb:	73 2e                	jae    8009fb <memmove+0x47>
		s += n;
		d += n;
  8009cd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009d0:	89 d6                	mov    %edx,%esi
  8009d2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009da:	75 13                	jne    8009ef <memmove+0x3b>
  8009dc:	f6 c1 03             	test   $0x3,%cl
  8009df:	75 0e                	jne    8009ef <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e1:	83 ef 04             	sub    $0x4,%edi
  8009e4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009ea:	fd                   	std    
  8009eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ed:	eb 09                	jmp    8009f8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ef:	83 ef 01             	sub    $0x1,%edi
  8009f2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009f5:	fd                   	std    
  8009f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f8:	fc                   	cld    
  8009f9:	eb 1d                	jmp    800a18 <memmove+0x64>
  8009fb:	89 f2                	mov    %esi,%edx
  8009fd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ff:	f6 c2 03             	test   $0x3,%dl
  800a02:	75 0f                	jne    800a13 <memmove+0x5f>
  800a04:	f6 c1 03             	test   $0x3,%cl
  800a07:	75 0a                	jne    800a13 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a09:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a0c:	89 c7                	mov    %eax,%edi
  800a0e:	fc                   	cld    
  800a0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a11:	eb 05                	jmp    800a18 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a13:	89 c7                	mov    %eax,%edi
  800a15:	fc                   	cld    
  800a16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a18:	5e                   	pop    %esi
  800a19:	5f                   	pop    %edi
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a22:	8b 45 10             	mov    0x10(%ebp),%eax
  800a25:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	89 04 24             	mov    %eax,(%esp)
  800a36:	e8 79 ff ff ff       	call   8009b4 <memmove>
}
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	8b 55 08             	mov    0x8(%ebp),%edx
  800a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a48:	89 d6                	mov    %edx,%esi
  800a4a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a4d:	eb 1a                	jmp    800a69 <memcmp+0x2c>
		if (*s1 != *s2)
  800a4f:	0f b6 02             	movzbl (%edx),%eax
  800a52:	0f b6 19             	movzbl (%ecx),%ebx
  800a55:	38 d8                	cmp    %bl,%al
  800a57:	74 0a                	je     800a63 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a59:	0f b6 c0             	movzbl %al,%eax
  800a5c:	0f b6 db             	movzbl %bl,%ebx
  800a5f:	29 d8                	sub    %ebx,%eax
  800a61:	eb 0f                	jmp    800a72 <memcmp+0x35>
		s1++, s2++;
  800a63:	83 c2 01             	add    $0x1,%edx
  800a66:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a69:	39 f2                	cmp    %esi,%edx
  800a6b:	75 e2                	jne    800a4f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a72:	5b                   	pop    %ebx
  800a73:	5e                   	pop    %esi
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a7f:	89 c2                	mov    %eax,%edx
  800a81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a84:	eb 07                	jmp    800a8d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a86:	38 08                	cmp    %cl,(%eax)
  800a88:	74 07                	je     800a91 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	39 d0                	cmp    %edx,%eax
  800a8f:	72 f5                	jb     800a86 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	57                   	push   %edi
  800a97:	56                   	push   %esi
  800a98:	53                   	push   %ebx
  800a99:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a9f:	eb 03                	jmp    800aa4 <strtol+0x11>
		s++;
  800aa1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa4:	0f b6 0a             	movzbl (%edx),%ecx
  800aa7:	80 f9 09             	cmp    $0x9,%cl
  800aaa:	74 f5                	je     800aa1 <strtol+0xe>
  800aac:	80 f9 20             	cmp    $0x20,%cl
  800aaf:	74 f0                	je     800aa1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ab1:	80 f9 2b             	cmp    $0x2b,%cl
  800ab4:	75 0a                	jne    800ac0 <strtol+0x2d>
		s++;
  800ab6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ab9:	bf 00 00 00 00       	mov    $0x0,%edi
  800abe:	eb 11                	jmp    800ad1 <strtol+0x3e>
  800ac0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ac5:	80 f9 2d             	cmp    $0x2d,%cl
  800ac8:	75 07                	jne    800ad1 <strtol+0x3e>
		s++, neg = 1;
  800aca:	8d 52 01             	lea    0x1(%edx),%edx
  800acd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ad6:	75 15                	jne    800aed <strtol+0x5a>
  800ad8:	80 3a 30             	cmpb   $0x30,(%edx)
  800adb:	75 10                	jne    800aed <strtol+0x5a>
  800add:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ae1:	75 0a                	jne    800aed <strtol+0x5a>
		s += 2, base = 16;
  800ae3:	83 c2 02             	add    $0x2,%edx
  800ae6:	b8 10 00 00 00       	mov    $0x10,%eax
  800aeb:	eb 10                	jmp    800afd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800aed:	85 c0                	test   %eax,%eax
  800aef:	75 0c                	jne    800afd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800af3:	80 3a 30             	cmpb   $0x30,(%edx)
  800af6:	75 05                	jne    800afd <strtol+0x6a>
		s++, base = 8;
  800af8:	83 c2 01             	add    $0x1,%edx
  800afb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800afd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b02:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b05:	0f b6 0a             	movzbl (%edx),%ecx
  800b08:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b0b:	89 f0                	mov    %esi,%eax
  800b0d:	3c 09                	cmp    $0x9,%al
  800b0f:	77 08                	ja     800b19 <strtol+0x86>
			dig = *s - '0';
  800b11:	0f be c9             	movsbl %cl,%ecx
  800b14:	83 e9 30             	sub    $0x30,%ecx
  800b17:	eb 20                	jmp    800b39 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b19:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b1c:	89 f0                	mov    %esi,%eax
  800b1e:	3c 19                	cmp    $0x19,%al
  800b20:	77 08                	ja     800b2a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b22:	0f be c9             	movsbl %cl,%ecx
  800b25:	83 e9 57             	sub    $0x57,%ecx
  800b28:	eb 0f                	jmp    800b39 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b2a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b2d:	89 f0                	mov    %esi,%eax
  800b2f:	3c 19                	cmp    $0x19,%al
  800b31:	77 16                	ja     800b49 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b33:	0f be c9             	movsbl %cl,%ecx
  800b36:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b39:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b3c:	7d 0f                	jge    800b4d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b3e:	83 c2 01             	add    $0x1,%edx
  800b41:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b45:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b47:	eb bc                	jmp    800b05 <strtol+0x72>
  800b49:	89 d8                	mov    %ebx,%eax
  800b4b:	eb 02                	jmp    800b4f <strtol+0xbc>
  800b4d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b53:	74 05                	je     800b5a <strtol+0xc7>
		*endptr = (char *) s;
  800b55:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b58:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b5a:	f7 d8                	neg    %eax
  800b5c:	85 ff                	test   %edi,%edi
  800b5e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b74:	8b 55 08             	mov    0x8(%ebp),%edx
  800b77:	89 c3                	mov    %eax,%ebx
  800b79:	89 c7                	mov    %eax,%edi
  800b7b:	89 c6                	mov    %eax,%esi
  800b7d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b94:	89 d1                	mov    %edx,%ecx
  800b96:	89 d3                	mov    %edx,%ebx
  800b98:	89 d7                	mov    %edx,%edi
  800b9a:	89 d6                	mov    %edx,%esi
  800b9c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	57                   	push   %edi
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
  800ba9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bac:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb9:	89 cb                	mov    %ecx,%ebx
  800bbb:	89 cf                	mov    %ecx,%edi
  800bbd:	89 ce                	mov    %ecx,%esi
  800bbf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bc1:	85 c0                	test   %eax,%eax
  800bc3:	7e 28                	jle    800bed <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bc9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800bd0:	00 
  800bd1:	c7 44 24 08 b7 2a 80 	movl   $0x802ab7,0x8(%esp)
  800bd8:	00 
  800bd9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800be0:	00 
  800be1:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  800be8:	e8 f9 16 00 00       	call   8022e6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bed:	83 c4 2c             	add    $0x2c,%esp
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5f                   	pop    %edi
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	57                   	push   %edi
  800bf9:	56                   	push   %esi
  800bfa:	53                   	push   %ebx
  800bfb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c03:	b8 04 00 00 00       	mov    $0x4,%eax
  800c08:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0b:	89 cb                	mov    %ecx,%ebx
  800c0d:	89 cf                	mov    %ecx,%edi
  800c0f:	89 ce                	mov    %ecx,%esi
  800c11:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c13:	85 c0                	test   %eax,%eax
  800c15:	7e 28                	jle    800c3f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c17:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c1b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c22:	00 
  800c23:	c7 44 24 08 b7 2a 80 	movl   $0x802ab7,0x8(%esp)
  800c2a:	00 
  800c2b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c32:	00 
  800c33:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  800c3a:	e8 a7 16 00 00       	call   8022e6 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800c3f:	83 c4 2c             	add    $0x2c,%esp
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c52:	b8 02 00 00 00       	mov    $0x2,%eax
  800c57:	89 d1                	mov    %edx,%ecx
  800c59:	89 d3                	mov    %edx,%ebx
  800c5b:	89 d7                	mov    %edx,%edi
  800c5d:	89 d6                	mov    %edx,%esi
  800c5f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5f                   	pop    %edi
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <sys_yield>:

void
sys_yield(void)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	57                   	push   %edi
  800c6a:	56                   	push   %esi
  800c6b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c71:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c76:	89 d1                	mov    %edx,%ecx
  800c78:	89 d3                	mov    %edx,%ebx
  800c7a:	89 d7                	mov    %edx,%edi
  800c7c:	89 d6                	mov    %edx,%esi
  800c7e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
  800c8b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8e:	be 00 00 00 00       	mov    $0x0,%esi
  800c93:	b8 05 00 00 00       	mov    $0x5,%eax
  800c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca1:	89 f7                	mov    %esi,%edi
  800ca3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	7e 28                	jle    800cd1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cad:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800cb4:	00 
  800cb5:	c7 44 24 08 b7 2a 80 	movl   $0x802ab7,0x8(%esp)
  800cbc:	00 
  800cbd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc4:	00 
  800cc5:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  800ccc:	e8 15 16 00 00       	call   8022e6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cd1:	83 c4 2c             	add    $0x2c,%esp
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce2:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ced:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf3:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cf8:	85 c0                	test   %eax,%eax
  800cfa:	7e 28                	jle    800d24 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d00:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d07:	00 
  800d08:	c7 44 24 08 b7 2a 80 	movl   $0x802ab7,0x8(%esp)
  800d0f:	00 
  800d10:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d17:	00 
  800d18:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  800d1f:	e8 c2 15 00 00       	call   8022e6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d24:	83 c4 2c             	add    $0x2c,%esp
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	57                   	push   %edi
  800d30:	56                   	push   %esi
  800d31:	53                   	push   %ebx
  800d32:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d35:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3a:	b8 07 00 00 00       	mov    $0x7,%eax
  800d3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d42:	8b 55 08             	mov    0x8(%ebp),%edx
  800d45:	89 df                	mov    %ebx,%edi
  800d47:	89 de                	mov    %ebx,%esi
  800d49:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	7e 28                	jle    800d77 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d53:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800d5a:	00 
  800d5b:	c7 44 24 08 b7 2a 80 	movl   $0x802ab7,0x8(%esp)
  800d62:	00 
  800d63:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d6a:	00 
  800d6b:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  800d72:	e8 6f 15 00 00       	call   8022e6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d77:	83 c4 2c             	add    $0x2c,%esp
  800d7a:	5b                   	pop    %ebx
  800d7b:	5e                   	pop    %esi
  800d7c:	5f                   	pop    %edi
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    

00800d7f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	57                   	push   %edi
  800d83:	56                   	push   %esi
  800d84:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d85:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d8a:	b8 10 00 00 00       	mov    $0x10,%eax
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	89 cb                	mov    %ecx,%ebx
  800d94:	89 cf                	mov    %ecx,%edi
  800d96:	89 ce                	mov    %ecx,%esi
  800d98:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    

00800d9f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
  800da5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dad:	b8 09 00 00 00       	mov    $0x9,%eax
  800db2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db5:	8b 55 08             	mov    0x8(%ebp),%edx
  800db8:	89 df                	mov    %ebx,%edi
  800dba:	89 de                	mov    %ebx,%esi
  800dbc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dbe:	85 c0                	test   %eax,%eax
  800dc0:	7e 28                	jle    800dea <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dcd:	00 
  800dce:	c7 44 24 08 b7 2a 80 	movl   $0x802ab7,0x8(%esp)
  800dd5:	00 
  800dd6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ddd:	00 
  800dde:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  800de5:	e8 fc 14 00 00       	call   8022e6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dea:	83 c4 2c             	add    $0x2c,%esp
  800ded:	5b                   	pop    %ebx
  800dee:	5e                   	pop    %esi
  800def:	5f                   	pop    %edi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    

00800df2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	57                   	push   %edi
  800df6:	56                   	push   %esi
  800df7:	53                   	push   %ebx
  800df8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e00:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e08:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0b:	89 df                	mov    %ebx,%edi
  800e0d:	89 de                	mov    %ebx,%esi
  800e0f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e11:	85 c0                	test   %eax,%eax
  800e13:	7e 28                	jle    800e3d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e15:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e19:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e20:	00 
  800e21:	c7 44 24 08 b7 2a 80 	movl   $0x802ab7,0x8(%esp)
  800e28:	00 
  800e29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e30:	00 
  800e31:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  800e38:	e8 a9 14 00 00       	call   8022e6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e3d:	83 c4 2c             	add    $0x2c,%esp
  800e40:	5b                   	pop    %ebx
  800e41:	5e                   	pop    %esi
  800e42:	5f                   	pop    %edi
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    

00800e45 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	57                   	push   %edi
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
  800e4b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e53:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	89 df                	mov    %ebx,%edi
  800e60:	89 de                	mov    %ebx,%esi
  800e62:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e64:	85 c0                	test   %eax,%eax
  800e66:	7e 28                	jle    800e90 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e68:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800e73:	00 
  800e74:	c7 44 24 08 b7 2a 80 	movl   $0x802ab7,0x8(%esp)
  800e7b:	00 
  800e7c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e83:	00 
  800e84:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  800e8b:	e8 56 14 00 00       	call   8022e6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e90:	83 c4 2c             	add    $0x2c,%esp
  800e93:	5b                   	pop    %ebx
  800e94:	5e                   	pop    %esi
  800e95:	5f                   	pop    %edi
  800e96:	5d                   	pop    %ebp
  800e97:	c3                   	ret    

00800e98 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	57                   	push   %edi
  800e9c:	56                   	push   %esi
  800e9d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9e:	be 00 00 00 00       	mov    $0x0,%esi
  800ea3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5f                   	pop    %edi
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	57                   	push   %edi
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
  800ec1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	89 cb                	mov    %ecx,%ebx
  800ed3:	89 cf                	mov    %ecx,%edi
  800ed5:	89 ce                	mov    %ecx,%esi
  800ed7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	7e 28                	jle    800f05 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800edd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800ee8:	00 
  800ee9:	c7 44 24 08 b7 2a 80 	movl   $0x802ab7,0x8(%esp)
  800ef0:	00 
  800ef1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef8:	00 
  800ef9:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  800f00:	e8 e1 13 00 00       	call   8022e6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f05:	83 c4 2c             	add    $0x2c,%esp
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <sys_time_msec>:

unsigned int
sys_time_msec(void)
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
  800f13:	ba 00 00 00 00       	mov    $0x0,%edx
  800f18:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f1d:	89 d1                	mov    %edx,%ecx
  800f1f:	89 d3                	mov    %edx,%ebx
  800f21:	89 d7                	mov    %edx,%edi
  800f23:	89 d6                	mov    %edx,%esi
  800f25:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	57                   	push   %edi
  800f30:	56                   	push   %esi
  800f31:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f37:	b8 11 00 00 00       	mov    $0x11,%eax
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	89 df                	mov    %ebx,%edi
  800f44:	89 de                	mov    %ebx,%esi
  800f46:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800f48:	5b                   	pop    %ebx
  800f49:	5e                   	pop    %esi
  800f4a:	5f                   	pop    %edi
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    

00800f4d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	57                   	push   %edi
  800f51:	56                   	push   %esi
  800f52:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f58:	b8 12 00 00 00       	mov    $0x12,%eax
  800f5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f60:	8b 55 08             	mov    0x8(%ebp),%edx
  800f63:	89 df                	mov    %ebx,%edi
  800f65:	89 de                	mov    %ebx,%esi
  800f67:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  800f69:	5b                   	pop    %ebx
  800f6a:	5e                   	pop    %esi
  800f6b:	5f                   	pop    %edi
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    

00800f6e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f74:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f79:	b8 13 00 00 00       	mov    $0x13,%eax
  800f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f81:	89 cb                	mov    %ecx,%ebx
  800f83:	89 cf                	mov    %ecx,%edi
  800f85:	89 ce                	mov    %ecx,%esi
  800f87:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5f                   	pop    %edi
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    
  800f8e:	66 90                	xchg   %ax,%ax

00800f90 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	05 00 00 00 30       	add    $0x30000000,%eax
  800f9b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800fab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fb0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fbd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fc2:	89 c2                	mov    %eax,%edx
  800fc4:	c1 ea 16             	shr    $0x16,%edx
  800fc7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fce:	f6 c2 01             	test   $0x1,%dl
  800fd1:	74 11                	je     800fe4 <fd_alloc+0x2d>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	c1 ea 0c             	shr    $0xc,%edx
  800fd8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fdf:	f6 c2 01             	test   $0x1,%dl
  800fe2:	75 09                	jne    800fed <fd_alloc+0x36>
			*fd_store = fd;
  800fe4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  800feb:	eb 17                	jmp    801004 <fd_alloc+0x4d>
  800fed:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800ff2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ff7:	75 c9                	jne    800fc2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ff9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800fff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    

00801006 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80100c:	83 f8 1f             	cmp    $0x1f,%eax
  80100f:	77 36                	ja     801047 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801011:	c1 e0 0c             	shl    $0xc,%eax
  801014:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801019:	89 c2                	mov    %eax,%edx
  80101b:	c1 ea 16             	shr    $0x16,%edx
  80101e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801025:	f6 c2 01             	test   $0x1,%dl
  801028:	74 24                	je     80104e <fd_lookup+0x48>
  80102a:	89 c2                	mov    %eax,%edx
  80102c:	c1 ea 0c             	shr    $0xc,%edx
  80102f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801036:	f6 c2 01             	test   $0x1,%dl
  801039:	74 1a                	je     801055 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80103b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103e:	89 02                	mov    %eax,(%edx)
	return 0;
  801040:	b8 00 00 00 00       	mov    $0x0,%eax
  801045:	eb 13                	jmp    80105a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801047:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80104c:	eb 0c                	jmp    80105a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80104e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801053:	eb 05                	jmp    80105a <fd_lookup+0x54>
  801055:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    

0080105c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 18             	sub    $0x18,%esp
  801062:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801065:	ba 00 00 00 00       	mov    $0x0,%edx
  80106a:	eb 13                	jmp    80107f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80106c:	39 08                	cmp    %ecx,(%eax)
  80106e:	75 0c                	jne    80107c <dev_lookup+0x20>
			*dev = devtab[i];
  801070:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801073:	89 01                	mov    %eax,(%ecx)
			return 0;
  801075:	b8 00 00 00 00       	mov    $0x0,%eax
  80107a:	eb 38                	jmp    8010b4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80107c:	83 c2 01             	add    $0x1,%edx
  80107f:	8b 04 95 60 2b 80 00 	mov    0x802b60(,%edx,4),%eax
  801086:	85 c0                	test   %eax,%eax
  801088:	75 e2                	jne    80106c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80108a:	a1 08 40 80 00       	mov    0x804008,%eax
  80108f:	8b 40 48             	mov    0x48(%eax),%eax
  801092:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801096:	89 44 24 04          	mov    %eax,0x4(%esp)
  80109a:	c7 04 24 e4 2a 80 00 	movl   $0x802ae4,(%esp)
  8010a1:	e8 fc f0 ff ff       	call   8001a2 <cprintf>
	*dev = 0;
  8010a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	56                   	push   %esi
  8010ba:	53                   	push   %ebx
  8010bb:	83 ec 20             	sub    $0x20,%esp
  8010be:	8b 75 08             	mov    0x8(%ebp),%esi
  8010c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010cb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010d1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010d4:	89 04 24             	mov    %eax,(%esp)
  8010d7:	e8 2a ff ff ff       	call   801006 <fd_lookup>
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	78 05                	js     8010e5 <fd_close+0x2f>
	    || fd != fd2)
  8010e0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8010e3:	74 0c                	je     8010f1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8010e5:	84 db                	test   %bl,%bl
  8010e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ec:	0f 44 c2             	cmove  %edx,%eax
  8010ef:	eb 3f                	jmp    801130 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010f8:	8b 06                	mov    (%esi),%eax
  8010fa:	89 04 24             	mov    %eax,(%esp)
  8010fd:	e8 5a ff ff ff       	call   80105c <dev_lookup>
  801102:	89 c3                	mov    %eax,%ebx
  801104:	85 c0                	test   %eax,%eax
  801106:	78 16                	js     80111e <fd_close+0x68>
		if (dev->dev_close)
  801108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80110e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801113:	85 c0                	test   %eax,%eax
  801115:	74 07                	je     80111e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801117:	89 34 24             	mov    %esi,(%esp)
  80111a:	ff d0                	call   *%eax
  80111c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80111e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801122:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801129:	e8 fe fb ff ff       	call   800d2c <sys_page_unmap>
	return r;
  80112e:	89 d8                	mov    %ebx,%eax
}
  801130:	83 c4 20             	add    $0x20,%esp
  801133:	5b                   	pop    %ebx
  801134:	5e                   	pop    %esi
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80113d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801140:	89 44 24 04          	mov    %eax,0x4(%esp)
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	89 04 24             	mov    %eax,(%esp)
  80114a:	e8 b7 fe ff ff       	call   801006 <fd_lookup>
  80114f:	89 c2                	mov    %eax,%edx
  801151:	85 d2                	test   %edx,%edx
  801153:	78 13                	js     801168 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801155:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80115c:	00 
  80115d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801160:	89 04 24             	mov    %eax,(%esp)
  801163:	e8 4e ff ff ff       	call   8010b6 <fd_close>
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <close_all>:

void
close_all(void)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	53                   	push   %ebx
  80116e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801171:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801176:	89 1c 24             	mov    %ebx,(%esp)
  801179:	e8 b9 ff ff ff       	call   801137 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80117e:	83 c3 01             	add    $0x1,%ebx
  801181:	83 fb 20             	cmp    $0x20,%ebx
  801184:	75 f0                	jne    801176 <close_all+0xc>
		close(i);
}
  801186:	83 c4 14             	add    $0x14,%esp
  801189:	5b                   	pop    %ebx
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    

0080118c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	57                   	push   %edi
  801190:	56                   	push   %esi
  801191:	53                   	push   %ebx
  801192:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801195:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	89 04 24             	mov    %eax,(%esp)
  8011a2:	e8 5f fe ff ff       	call   801006 <fd_lookup>
  8011a7:	89 c2                	mov    %eax,%edx
  8011a9:	85 d2                	test   %edx,%edx
  8011ab:	0f 88 e1 00 00 00    	js     801292 <dup+0x106>
		return r;
	close(newfdnum);
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	89 04 24             	mov    %eax,(%esp)
  8011b7:	e8 7b ff ff ff       	call   801137 <close>

	newfd = INDEX2FD(newfdnum);
  8011bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8011bf:	c1 e3 0c             	shl    $0xc,%ebx
  8011c2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8011c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011cb:	89 04 24             	mov    %eax,(%esp)
  8011ce:	e8 cd fd ff ff       	call   800fa0 <fd2data>
  8011d3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8011d5:	89 1c 24             	mov    %ebx,(%esp)
  8011d8:	e8 c3 fd ff ff       	call   800fa0 <fd2data>
  8011dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011df:	89 f0                	mov    %esi,%eax
  8011e1:	c1 e8 16             	shr    $0x16,%eax
  8011e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011eb:	a8 01                	test   $0x1,%al
  8011ed:	74 43                	je     801232 <dup+0xa6>
  8011ef:	89 f0                	mov    %esi,%eax
  8011f1:	c1 e8 0c             	shr    $0xc,%eax
  8011f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011fb:	f6 c2 01             	test   $0x1,%dl
  8011fe:	74 32                	je     801232 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801200:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801207:	25 07 0e 00 00       	and    $0xe07,%eax
  80120c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801210:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801214:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80121b:	00 
  80121c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801220:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801227:	e8 ad fa ff ff       	call   800cd9 <sys_page_map>
  80122c:	89 c6                	mov    %eax,%esi
  80122e:	85 c0                	test   %eax,%eax
  801230:	78 3e                	js     801270 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801235:	89 c2                	mov    %eax,%edx
  801237:	c1 ea 0c             	shr    $0xc,%edx
  80123a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801241:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801247:	89 54 24 10          	mov    %edx,0x10(%esp)
  80124b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80124f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801256:	00 
  801257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80125b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801262:	e8 72 fa ff ff       	call   800cd9 <sys_page_map>
  801267:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80126c:	85 f6                	test   %esi,%esi
  80126e:	79 22                	jns    801292 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801270:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801274:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80127b:	e8 ac fa ff ff       	call   800d2c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801280:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801284:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80128b:	e8 9c fa ff ff       	call   800d2c <sys_page_unmap>
	return r;
  801290:	89 f0                	mov    %esi,%eax
}
  801292:	83 c4 3c             	add    $0x3c,%esp
  801295:	5b                   	pop    %ebx
  801296:	5e                   	pop    %esi
  801297:	5f                   	pop    %edi
  801298:	5d                   	pop    %ebp
  801299:	c3                   	ret    

0080129a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	53                   	push   %ebx
  80129e:	83 ec 24             	sub    $0x24,%esp
  8012a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ab:	89 1c 24             	mov    %ebx,(%esp)
  8012ae:	e8 53 fd ff ff       	call   801006 <fd_lookup>
  8012b3:	89 c2                	mov    %eax,%edx
  8012b5:	85 d2                	test   %edx,%edx
  8012b7:	78 6d                	js     801326 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c3:	8b 00                	mov    (%eax),%eax
  8012c5:	89 04 24             	mov    %eax,(%esp)
  8012c8:	e8 8f fd ff ff       	call   80105c <dev_lookup>
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	78 55                	js     801326 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d4:	8b 50 08             	mov    0x8(%eax),%edx
  8012d7:	83 e2 03             	and    $0x3,%edx
  8012da:	83 fa 01             	cmp    $0x1,%edx
  8012dd:	75 23                	jne    801302 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012df:	a1 08 40 80 00       	mov    0x804008,%eax
  8012e4:	8b 40 48             	mov    0x48(%eax),%eax
  8012e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ef:	c7 04 24 25 2b 80 00 	movl   $0x802b25,(%esp)
  8012f6:	e8 a7 ee ff ff       	call   8001a2 <cprintf>
		return -E_INVAL;
  8012fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801300:	eb 24                	jmp    801326 <read+0x8c>
	}
	if (!dev->dev_read)
  801302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801305:	8b 52 08             	mov    0x8(%edx),%edx
  801308:	85 d2                	test   %edx,%edx
  80130a:	74 15                	je     801321 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80130c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80130f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801313:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801316:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80131a:	89 04 24             	mov    %eax,(%esp)
  80131d:	ff d2                	call   *%edx
  80131f:	eb 05                	jmp    801326 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801321:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801326:	83 c4 24             	add    $0x24,%esp
  801329:	5b                   	pop    %ebx
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    

0080132c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	57                   	push   %edi
  801330:	56                   	push   %esi
  801331:	53                   	push   %ebx
  801332:	83 ec 1c             	sub    $0x1c,%esp
  801335:	8b 7d 08             	mov    0x8(%ebp),%edi
  801338:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80133b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801340:	eb 23                	jmp    801365 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801342:	89 f0                	mov    %esi,%eax
  801344:	29 d8                	sub    %ebx,%eax
  801346:	89 44 24 08          	mov    %eax,0x8(%esp)
  80134a:	89 d8                	mov    %ebx,%eax
  80134c:	03 45 0c             	add    0xc(%ebp),%eax
  80134f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801353:	89 3c 24             	mov    %edi,(%esp)
  801356:	e8 3f ff ff ff       	call   80129a <read>
		if (m < 0)
  80135b:	85 c0                	test   %eax,%eax
  80135d:	78 10                	js     80136f <readn+0x43>
			return m;
		if (m == 0)
  80135f:	85 c0                	test   %eax,%eax
  801361:	74 0a                	je     80136d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801363:	01 c3                	add    %eax,%ebx
  801365:	39 f3                	cmp    %esi,%ebx
  801367:	72 d9                	jb     801342 <readn+0x16>
  801369:	89 d8                	mov    %ebx,%eax
  80136b:	eb 02                	jmp    80136f <readn+0x43>
  80136d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80136f:	83 c4 1c             	add    $0x1c,%esp
  801372:	5b                   	pop    %ebx
  801373:	5e                   	pop    %esi
  801374:	5f                   	pop    %edi
  801375:	5d                   	pop    %ebp
  801376:	c3                   	ret    

00801377 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	53                   	push   %ebx
  80137b:	83 ec 24             	sub    $0x24,%esp
  80137e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801381:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801384:	89 44 24 04          	mov    %eax,0x4(%esp)
  801388:	89 1c 24             	mov    %ebx,(%esp)
  80138b:	e8 76 fc ff ff       	call   801006 <fd_lookup>
  801390:	89 c2                	mov    %eax,%edx
  801392:	85 d2                	test   %edx,%edx
  801394:	78 68                	js     8013fe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801396:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801399:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	8b 00                	mov    (%eax),%eax
  8013a2:	89 04 24             	mov    %eax,(%esp)
  8013a5:	e8 b2 fc ff ff       	call   80105c <dev_lookup>
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	78 50                	js     8013fe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013b5:	75 23                	jne    8013da <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013b7:	a1 08 40 80 00       	mov    0x804008,%eax
  8013bc:	8b 40 48             	mov    0x48(%eax),%eax
  8013bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c7:	c7 04 24 41 2b 80 00 	movl   $0x802b41,(%esp)
  8013ce:	e8 cf ed ff ff       	call   8001a2 <cprintf>
		return -E_INVAL;
  8013d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d8:	eb 24                	jmp    8013fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013dd:	8b 52 0c             	mov    0xc(%edx),%edx
  8013e0:	85 d2                	test   %edx,%edx
  8013e2:	74 15                	je     8013f9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013f2:	89 04 24             	mov    %eax,(%esp)
  8013f5:	ff d2                	call   *%edx
  8013f7:	eb 05                	jmp    8013fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8013f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8013fe:	83 c4 24             	add    $0x24,%esp
  801401:	5b                   	pop    %ebx
  801402:	5d                   	pop    %ebp
  801403:	c3                   	ret    

00801404 <seek>:

int
seek(int fdnum, off_t offset)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80140a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80140d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	89 04 24             	mov    %eax,(%esp)
  801417:	e8 ea fb ff ff       	call   801006 <fd_lookup>
  80141c:	85 c0                	test   %eax,%eax
  80141e:	78 0e                	js     80142e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801420:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801423:	8b 55 0c             	mov    0xc(%ebp),%edx
  801426:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801429:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	53                   	push   %ebx
  801434:	83 ec 24             	sub    $0x24,%esp
  801437:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80143a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80143d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801441:	89 1c 24             	mov    %ebx,(%esp)
  801444:	e8 bd fb ff ff       	call   801006 <fd_lookup>
  801449:	89 c2                	mov    %eax,%edx
  80144b:	85 d2                	test   %edx,%edx
  80144d:	78 61                	js     8014b0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80144f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801452:	89 44 24 04          	mov    %eax,0x4(%esp)
  801456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801459:	8b 00                	mov    (%eax),%eax
  80145b:	89 04 24             	mov    %eax,(%esp)
  80145e:	e8 f9 fb ff ff       	call   80105c <dev_lookup>
  801463:	85 c0                	test   %eax,%eax
  801465:	78 49                	js     8014b0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80146e:	75 23                	jne    801493 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801470:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801475:	8b 40 48             	mov    0x48(%eax),%eax
  801478:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80147c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801480:	c7 04 24 04 2b 80 00 	movl   $0x802b04,(%esp)
  801487:	e8 16 ed ff ff       	call   8001a2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80148c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801491:	eb 1d                	jmp    8014b0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801493:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801496:	8b 52 18             	mov    0x18(%edx),%edx
  801499:	85 d2                	test   %edx,%edx
  80149b:	74 0e                	je     8014ab <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80149d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014a4:	89 04 24             	mov    %eax,(%esp)
  8014a7:	ff d2                	call   *%edx
  8014a9:	eb 05                	jmp    8014b0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8014ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8014b0:	83 c4 24             	add    $0x24,%esp
  8014b3:	5b                   	pop    %ebx
  8014b4:	5d                   	pop    %ebp
  8014b5:	c3                   	ret    

008014b6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	53                   	push   %ebx
  8014ba:	83 ec 24             	sub    $0x24,%esp
  8014bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	89 04 24             	mov    %eax,(%esp)
  8014cd:	e8 34 fb ff ff       	call   801006 <fd_lookup>
  8014d2:	89 c2                	mov    %eax,%edx
  8014d4:	85 d2                	test   %edx,%edx
  8014d6:	78 52                	js     80152a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e2:	8b 00                	mov    (%eax),%eax
  8014e4:	89 04 24             	mov    %eax,(%esp)
  8014e7:	e8 70 fb ff ff       	call   80105c <dev_lookup>
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 3a                	js     80152a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8014f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014f7:	74 2c                	je     801525 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014f9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014fc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801503:	00 00 00 
	stat->st_isdir = 0;
  801506:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80150d:	00 00 00 
	stat->st_dev = dev;
  801510:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801516:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80151a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80151d:	89 14 24             	mov    %edx,(%esp)
  801520:	ff 50 14             	call   *0x14(%eax)
  801523:	eb 05                	jmp    80152a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801525:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80152a:	83 c4 24             	add    $0x24,%esp
  80152d:	5b                   	pop    %ebx
  80152e:	5d                   	pop    %ebp
  80152f:	c3                   	ret    

00801530 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	56                   	push   %esi
  801534:	53                   	push   %ebx
  801535:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801538:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80153f:	00 
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	89 04 24             	mov    %eax,(%esp)
  801546:	e8 99 02 00 00       	call   8017e4 <open>
  80154b:	89 c3                	mov    %eax,%ebx
  80154d:	85 db                	test   %ebx,%ebx
  80154f:	78 1b                	js     80156c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	89 44 24 04          	mov    %eax,0x4(%esp)
  801558:	89 1c 24             	mov    %ebx,(%esp)
  80155b:	e8 56 ff ff ff       	call   8014b6 <fstat>
  801560:	89 c6                	mov    %eax,%esi
	close(fd);
  801562:	89 1c 24             	mov    %ebx,(%esp)
  801565:	e8 cd fb ff ff       	call   801137 <close>
	return r;
  80156a:	89 f0                	mov    %esi,%eax
}
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	5b                   	pop    %ebx
  801570:	5e                   	pop    %esi
  801571:	5d                   	pop    %ebp
  801572:	c3                   	ret    

00801573 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	56                   	push   %esi
  801577:	53                   	push   %ebx
  801578:	83 ec 10             	sub    $0x10,%esp
  80157b:	89 c6                	mov    %eax,%esi
  80157d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80157f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801586:	75 11                	jne    801599 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801588:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80158f:	e8 7b 0e 00 00       	call   80240f <ipc_find_env>
  801594:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801599:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015a0:	00 
  8015a1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015a8:	00 
  8015a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015ad:	a1 00 40 80 00       	mov    0x804000,%eax
  8015b2:	89 04 24             	mov    %eax,(%esp)
  8015b5:	e8 ee 0d 00 00       	call   8023a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015c1:	00 
  8015c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015cd:	e8 6e 0d 00 00       	call   802340 <ipc_recv>
}
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	5b                   	pop    %ebx
  8015d6:	5e                   	pop    %esi
  8015d7:	5d                   	pop    %ebp
  8015d8:	c3                   	ret    

008015d9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ed:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8015fc:	e8 72 ff ff ff       	call   801573 <fsipc>
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	8b 40 0c             	mov    0xc(%eax),%eax
  80160f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801614:	ba 00 00 00 00       	mov    $0x0,%edx
  801619:	b8 06 00 00 00       	mov    $0x6,%eax
  80161e:	e8 50 ff ff ff       	call   801573 <fsipc>
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	53                   	push   %ebx
  801629:	83 ec 14             	sub    $0x14,%esp
  80162c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8b 40 0c             	mov    0xc(%eax),%eax
  801635:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80163a:	ba 00 00 00 00       	mov    $0x0,%edx
  80163f:	b8 05 00 00 00       	mov    $0x5,%eax
  801644:	e8 2a ff ff ff       	call   801573 <fsipc>
  801649:	89 c2                	mov    %eax,%edx
  80164b:	85 d2                	test   %edx,%edx
  80164d:	78 2b                	js     80167a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80164f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801656:	00 
  801657:	89 1c 24             	mov    %ebx,(%esp)
  80165a:	e8 b8 f1 ff ff       	call   800817 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80165f:	a1 80 50 80 00       	mov    0x805080,%eax
  801664:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80166a:	a1 84 50 80 00       	mov    0x805084,%eax
  80166f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167a:	83 c4 14             	add    $0x14,%esp
  80167d:	5b                   	pop    %ebx
  80167e:	5d                   	pop    %ebp
  80167f:	c3                   	ret    

00801680 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	53                   	push   %ebx
  801684:	83 ec 14             	sub    $0x14,%esp
  801687:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80168a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801690:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801695:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801698:	8b 55 08             	mov    0x8(%ebp),%edx
  80169b:	8b 52 0c             	mov    0xc(%edx),%edx
  80169e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  8016a4:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  8016a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b4:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8016bb:	e8 f4 f2 ff ff       	call   8009b4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  8016c0:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  8016c7:	00 
  8016c8:	c7 04 24 74 2b 80 00 	movl   $0x802b74,(%esp)
  8016cf:	e8 ce ea ff ff       	call   8001a2 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d9:	b8 04 00 00 00       	mov    $0x4,%eax
  8016de:	e8 90 fe ff ff       	call   801573 <fsipc>
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 53                	js     80173a <devfile_write+0xba>
		return r;
	assert(r <= n);
  8016e7:	39 c3                	cmp    %eax,%ebx
  8016e9:	73 24                	jae    80170f <devfile_write+0x8f>
  8016eb:	c7 44 24 0c 79 2b 80 	movl   $0x802b79,0xc(%esp)
  8016f2:	00 
  8016f3:	c7 44 24 08 80 2b 80 	movl   $0x802b80,0x8(%esp)
  8016fa:	00 
  8016fb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801702:	00 
  801703:	c7 04 24 95 2b 80 00 	movl   $0x802b95,(%esp)
  80170a:	e8 d7 0b 00 00       	call   8022e6 <_panic>
	assert(r <= PGSIZE);
  80170f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801714:	7e 24                	jle    80173a <devfile_write+0xba>
  801716:	c7 44 24 0c a0 2b 80 	movl   $0x802ba0,0xc(%esp)
  80171d:	00 
  80171e:	c7 44 24 08 80 2b 80 	movl   $0x802b80,0x8(%esp)
  801725:	00 
  801726:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  80172d:	00 
  80172e:	c7 04 24 95 2b 80 00 	movl   $0x802b95,(%esp)
  801735:	e8 ac 0b 00 00       	call   8022e6 <_panic>
	return r;
}
  80173a:	83 c4 14             	add    $0x14,%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5d                   	pop    %ebp
  80173f:	c3                   	ret    

00801740 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
  801745:	83 ec 10             	sub    $0x10,%esp
  801748:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8b 40 0c             	mov    0xc(%eax),%eax
  801751:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801756:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80175c:	ba 00 00 00 00       	mov    $0x0,%edx
  801761:	b8 03 00 00 00       	mov    $0x3,%eax
  801766:	e8 08 fe ff ff       	call   801573 <fsipc>
  80176b:	89 c3                	mov    %eax,%ebx
  80176d:	85 c0                	test   %eax,%eax
  80176f:	78 6a                	js     8017db <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801771:	39 c6                	cmp    %eax,%esi
  801773:	73 24                	jae    801799 <devfile_read+0x59>
  801775:	c7 44 24 0c 79 2b 80 	movl   $0x802b79,0xc(%esp)
  80177c:	00 
  80177d:	c7 44 24 08 80 2b 80 	movl   $0x802b80,0x8(%esp)
  801784:	00 
  801785:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80178c:	00 
  80178d:	c7 04 24 95 2b 80 00 	movl   $0x802b95,(%esp)
  801794:	e8 4d 0b 00 00       	call   8022e6 <_panic>
	assert(r <= PGSIZE);
  801799:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80179e:	7e 24                	jle    8017c4 <devfile_read+0x84>
  8017a0:	c7 44 24 0c a0 2b 80 	movl   $0x802ba0,0xc(%esp)
  8017a7:	00 
  8017a8:	c7 44 24 08 80 2b 80 	movl   $0x802b80,0x8(%esp)
  8017af:	00 
  8017b0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8017b7:	00 
  8017b8:	c7 04 24 95 2b 80 00 	movl   $0x802b95,(%esp)
  8017bf:	e8 22 0b 00 00       	call   8022e6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017c8:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017cf:	00 
  8017d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d3:	89 04 24             	mov    %eax,(%esp)
  8017d6:	e8 d9 f1 ff ff       	call   8009b4 <memmove>
	return r;
}
  8017db:	89 d8                	mov    %ebx,%eax
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	5b                   	pop    %ebx
  8017e1:	5e                   	pop    %esi
  8017e2:	5d                   	pop    %ebp
  8017e3:	c3                   	ret    

008017e4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	53                   	push   %ebx
  8017e8:	83 ec 24             	sub    $0x24,%esp
  8017eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017ee:	89 1c 24             	mov    %ebx,(%esp)
  8017f1:	e8 ea ef ff ff       	call   8007e0 <strlen>
  8017f6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017fb:	7f 60                	jg     80185d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801800:	89 04 24             	mov    %eax,(%esp)
  801803:	e8 af f7 ff ff       	call   800fb7 <fd_alloc>
  801808:	89 c2                	mov    %eax,%edx
  80180a:	85 d2                	test   %edx,%edx
  80180c:	78 54                	js     801862 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80180e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801812:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801819:	e8 f9 ef ff ff       	call   800817 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80181e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801821:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801826:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801829:	b8 01 00 00 00       	mov    $0x1,%eax
  80182e:	e8 40 fd ff ff       	call   801573 <fsipc>
  801833:	89 c3                	mov    %eax,%ebx
  801835:	85 c0                	test   %eax,%eax
  801837:	79 17                	jns    801850 <open+0x6c>
		fd_close(fd, 0);
  801839:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801840:	00 
  801841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801844:	89 04 24             	mov    %eax,(%esp)
  801847:	e8 6a f8 ff ff       	call   8010b6 <fd_close>
		return r;
  80184c:	89 d8                	mov    %ebx,%eax
  80184e:	eb 12                	jmp    801862 <open+0x7e>
	}

	return fd2num(fd);
  801850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801853:	89 04 24             	mov    %eax,(%esp)
  801856:	e8 35 f7 ff ff       	call   800f90 <fd2num>
  80185b:	eb 05                	jmp    801862 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80185d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801862:	83 c4 24             	add    $0x24,%esp
  801865:	5b                   	pop    %ebx
  801866:	5d                   	pop    %ebp
  801867:	c3                   	ret    

00801868 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	b8 08 00 00 00       	mov    $0x8,%eax
  801878:	e8 f6 fc ff ff       	call   801573 <fsipc>
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <evict>:

int evict(void)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801885:	c7 04 24 ac 2b 80 00 	movl   $0x802bac,(%esp)
  80188c:	e8 11 e9 ff ff       	call   8001a2 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801891:	ba 00 00 00 00       	mov    $0x0,%edx
  801896:	b8 09 00 00 00       	mov    $0x9,%eax
  80189b:	e8 d3 fc ff ff       	call   801573 <fsipc>
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    
  8018a2:	66 90                	xchg   %ax,%ax
  8018a4:	66 90                	xchg   %ax,%ax
  8018a6:	66 90                	xchg   %ax,%ax
  8018a8:	66 90                	xchg   %ax,%ax
  8018aa:	66 90                	xchg   %ax,%ax
  8018ac:	66 90                	xchg   %ax,%ax
  8018ae:	66 90                	xchg   %ax,%ax

008018b0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8018b6:	c7 44 24 04 c5 2b 80 	movl   $0x802bc5,0x4(%esp)
  8018bd:	00 
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	89 04 24             	mov    %eax,(%esp)
  8018c4:	e8 4e ef ff ff       	call   800817 <strcpy>
	return 0;
}
  8018c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	53                   	push   %ebx
  8018d4:	83 ec 14             	sub    $0x14,%esp
  8018d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018da:	89 1c 24             	mov    %ebx,(%esp)
  8018dd:	e8 65 0b 00 00       	call   802447 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8018e2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8018e7:	83 f8 01             	cmp    $0x1,%eax
  8018ea:	75 0d                	jne    8018f9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8018ec:	8b 43 0c             	mov    0xc(%ebx),%eax
  8018ef:	89 04 24             	mov    %eax,(%esp)
  8018f2:	e8 29 03 00 00       	call   801c20 <nsipc_close>
  8018f7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8018f9:	89 d0                	mov    %edx,%eax
  8018fb:	83 c4 14             	add    $0x14,%esp
  8018fe:	5b                   	pop    %ebx
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    

00801901 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801907:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80190e:	00 
  80190f:	8b 45 10             	mov    0x10(%ebp),%eax
  801912:	89 44 24 08          	mov    %eax,0x8(%esp)
  801916:	8b 45 0c             	mov    0xc(%ebp),%eax
  801919:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	8b 40 0c             	mov    0xc(%eax),%eax
  801923:	89 04 24             	mov    %eax,(%esp)
  801926:	e8 f0 03 00 00       	call   801d1b <nsipc_send>
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801933:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80193a:	00 
  80193b:	8b 45 10             	mov    0x10(%ebp),%eax
  80193e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	89 44 24 04          	mov    %eax,0x4(%esp)
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	8b 40 0c             	mov    0xc(%eax),%eax
  80194f:	89 04 24             	mov    %eax,(%esp)
  801952:	e8 44 03 00 00       	call   801c9b <nsipc_recv>
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80195f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801962:	89 54 24 04          	mov    %edx,0x4(%esp)
  801966:	89 04 24             	mov    %eax,(%esp)
  801969:	e8 98 f6 ff ff       	call   801006 <fd_lookup>
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 17                	js     801989 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801975:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80197b:	39 08                	cmp    %ecx,(%eax)
  80197d:	75 05                	jne    801984 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80197f:	8b 40 0c             	mov    0xc(%eax),%eax
  801982:	eb 05                	jmp    801989 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801984:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	83 ec 20             	sub    $0x20,%esp
  801993:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801995:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801998:	89 04 24             	mov    %eax,(%esp)
  80199b:	e8 17 f6 ff ff       	call   800fb7 <fd_alloc>
  8019a0:	89 c3                	mov    %eax,%ebx
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	78 21                	js     8019c7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019a6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019ad:	00 
  8019ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019bc:	e8 c4 f2 ff ff       	call   800c85 <sys_page_alloc>
  8019c1:	89 c3                	mov    %eax,%ebx
  8019c3:	85 c0                	test   %eax,%eax
  8019c5:	79 0c                	jns    8019d3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8019c7:	89 34 24             	mov    %esi,(%esp)
  8019ca:	e8 51 02 00 00       	call   801c20 <nsipc_close>
		return r;
  8019cf:	89 d8                	mov    %ebx,%eax
  8019d1:	eb 20                	jmp    8019f3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8019d3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019dc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8019e8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8019eb:	89 14 24             	mov    %edx,(%esp)
  8019ee:	e8 9d f5 ff ff       	call   800f90 <fd2num>
}
  8019f3:	83 c4 20             	add    $0x20,%esp
  8019f6:	5b                   	pop    %ebx
  8019f7:	5e                   	pop    %esi
  8019f8:	5d                   	pop    %ebp
  8019f9:	c3                   	ret    

008019fa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	e8 51 ff ff ff       	call   801959 <fd2sockid>
		return r;
  801a08:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	78 23                	js     801a31 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a0e:	8b 55 10             	mov    0x10(%ebp),%edx
  801a11:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a18:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a1c:	89 04 24             	mov    %eax,(%esp)
  801a1f:	e8 45 01 00 00       	call   801b69 <nsipc_accept>
		return r;
  801a24:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a26:	85 c0                	test   %eax,%eax
  801a28:	78 07                	js     801a31 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801a2a:	e8 5c ff ff ff       	call   80198b <alloc_sockfd>
  801a2f:	89 c1                	mov    %eax,%ecx
}
  801a31:	89 c8                	mov    %ecx,%eax
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	e8 16 ff ff ff       	call   801959 <fd2sockid>
  801a43:	89 c2                	mov    %eax,%edx
  801a45:	85 d2                	test   %edx,%edx
  801a47:	78 16                	js     801a5f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801a49:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a57:	89 14 24             	mov    %edx,(%esp)
  801a5a:	e8 60 01 00 00       	call   801bbf <nsipc_bind>
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <shutdown>:

int
shutdown(int s, int how)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	e8 ea fe ff ff       	call   801959 <fd2sockid>
  801a6f:	89 c2                	mov    %eax,%edx
  801a71:	85 d2                	test   %edx,%edx
  801a73:	78 0f                	js     801a84 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7c:	89 14 24             	mov    %edx,(%esp)
  801a7f:	e8 7a 01 00 00       	call   801bfe <nsipc_shutdown>
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	e8 c5 fe ff ff       	call   801959 <fd2sockid>
  801a94:	89 c2                	mov    %eax,%edx
  801a96:	85 d2                	test   %edx,%edx
  801a98:	78 16                	js     801ab0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801a9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa8:	89 14 24             	mov    %edx,(%esp)
  801aab:	e8 8a 01 00 00       	call   801c3a <nsipc_connect>
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <listen>:

int
listen(int s, int backlog)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	e8 99 fe ff ff       	call   801959 <fd2sockid>
  801ac0:	89 c2                	mov    %eax,%edx
  801ac2:	85 d2                	test   %edx,%edx
  801ac4:	78 0f                	js     801ad5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acd:	89 14 24             	mov    %edx,(%esp)
  801ad0:	e8 a4 01 00 00       	call   801c79 <nsipc_listen>
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801add:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	89 04 24             	mov    %eax,(%esp)
  801af1:	e8 98 02 00 00       	call   801d8e <nsipc_socket>
  801af6:	89 c2                	mov    %eax,%edx
  801af8:	85 d2                	test   %edx,%edx
  801afa:	78 05                	js     801b01 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801afc:	e8 8a fe ff ff       	call   80198b <alloc_sockfd>
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	53                   	push   %ebx
  801b07:	83 ec 14             	sub    $0x14,%esp
  801b0a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b0c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b13:	75 11                	jne    801b26 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b15:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801b1c:	e8 ee 08 00 00       	call   80240f <ipc_find_env>
  801b21:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b26:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b2d:	00 
  801b2e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b35:	00 
  801b36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b3a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b3f:	89 04 24             	mov    %eax,(%esp)
  801b42:	e8 61 08 00 00       	call   8023a8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b47:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b4e:	00 
  801b4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b56:	00 
  801b57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b5e:	e8 dd 07 00 00       	call   802340 <ipc_recv>
}
  801b63:	83 c4 14             	add    $0x14,%esp
  801b66:	5b                   	pop    %ebx
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    

00801b69 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	56                   	push   %esi
  801b6d:	53                   	push   %ebx
  801b6e:	83 ec 10             	sub    $0x10,%esp
  801b71:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b7c:	8b 06                	mov    (%esi),%eax
  801b7e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b83:	b8 01 00 00 00       	mov    $0x1,%eax
  801b88:	e8 76 ff ff ff       	call   801b03 <nsipc>
  801b8d:	89 c3                	mov    %eax,%ebx
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	78 23                	js     801bb6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b93:	a1 10 60 80 00       	mov    0x806010,%eax
  801b98:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b9c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ba3:	00 
  801ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba7:	89 04 24             	mov    %eax,(%esp)
  801baa:	e8 05 ee ff ff       	call   8009b4 <memmove>
		*addrlen = ret->ret_addrlen;
  801baf:	a1 10 60 80 00       	mov    0x806010,%eax
  801bb4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801bb6:	89 d8                	mov    %ebx,%eax
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5e                   	pop    %esi
  801bbd:	5d                   	pop    %ebp
  801bbe:	c3                   	ret    

00801bbf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	53                   	push   %ebx
  801bc3:	83 ec 14             	sub    $0x14,%esp
  801bc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bd1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801be3:	e8 cc ed ff ff       	call   8009b4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801be8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bee:	b8 02 00 00 00       	mov    $0x2,%eax
  801bf3:	e8 0b ff ff ff       	call   801b03 <nsipc>
}
  801bf8:	83 c4 14             	add    $0x14,%esp
  801bfb:	5b                   	pop    %ebx
  801bfc:	5d                   	pop    %ebp
  801bfd:	c3                   	ret    

00801bfe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c14:	b8 03 00 00 00       	mov    $0x3,%eax
  801c19:	e8 e5 fe ff ff       	call   801b03 <nsipc>
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <nsipc_close>:

int
nsipc_close(int s)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c2e:	b8 04 00 00 00       	mov    $0x4,%eax
  801c33:	e8 cb fe ff ff       	call   801b03 <nsipc>
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	53                   	push   %ebx
  801c3e:	83 ec 14             	sub    $0x14,%esp
  801c41:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c4c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c57:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c5e:	e8 51 ed ff ff       	call   8009b4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c63:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c69:	b8 05 00 00 00       	mov    $0x5,%eax
  801c6e:	e8 90 fe ff ff       	call   801b03 <nsipc>
}
  801c73:	83 c4 14             	add    $0x14,%esp
  801c76:	5b                   	pop    %ebx
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    

00801c79 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c8f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c94:	e8 6a fe ff ff       	call   801b03 <nsipc>
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 10             	sub    $0x10,%esp
  801ca3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cae:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cbc:	b8 07 00 00 00       	mov    $0x7,%eax
  801cc1:	e8 3d fe ff ff       	call   801b03 <nsipc>
  801cc6:	89 c3                	mov    %eax,%ebx
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	78 46                	js     801d12 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801ccc:	39 f0                	cmp    %esi,%eax
  801cce:	7f 07                	jg     801cd7 <nsipc_recv+0x3c>
  801cd0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cd5:	7e 24                	jle    801cfb <nsipc_recv+0x60>
  801cd7:	c7 44 24 0c d1 2b 80 	movl   $0x802bd1,0xc(%esp)
  801cde:	00 
  801cdf:	c7 44 24 08 80 2b 80 	movl   $0x802b80,0x8(%esp)
  801ce6:	00 
  801ce7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801cee:	00 
  801cef:	c7 04 24 e6 2b 80 00 	movl   $0x802be6,(%esp)
  801cf6:	e8 eb 05 00 00       	call   8022e6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cfb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cff:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d06:	00 
  801d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0a:	89 04 24             	mov    %eax,(%esp)
  801d0d:	e8 a2 ec ff ff       	call   8009b4 <memmove>
	}

	return r;
}
  801d12:	89 d8                	mov    %ebx,%eax
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5d                   	pop    %ebp
  801d1a:	c3                   	ret    

00801d1b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	53                   	push   %ebx
  801d1f:	83 ec 14             	sub    $0x14,%esp
  801d22:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d2d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d33:	7e 24                	jle    801d59 <nsipc_send+0x3e>
  801d35:	c7 44 24 0c f2 2b 80 	movl   $0x802bf2,0xc(%esp)
  801d3c:	00 
  801d3d:	c7 44 24 08 80 2b 80 	movl   $0x802b80,0x8(%esp)
  801d44:	00 
  801d45:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801d4c:	00 
  801d4d:	c7 04 24 e6 2b 80 00 	movl   $0x802be6,(%esp)
  801d54:	e8 8d 05 00 00       	call   8022e6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d59:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d64:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801d6b:	e8 44 ec ff ff       	call   8009b4 <memmove>
	nsipcbuf.send.req_size = size;
  801d70:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d76:	8b 45 14             	mov    0x14(%ebp),%eax
  801d79:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d7e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d83:	e8 7b fd ff ff       	call   801b03 <nsipc>
}
  801d88:	83 c4 14             	add    $0x14,%esp
  801d8b:	5b                   	pop    %ebx
  801d8c:	5d                   	pop    %ebp
  801d8d:	c3                   	ret    

00801d8e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801da4:	8b 45 10             	mov    0x10(%ebp),%eax
  801da7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dac:	b8 09 00 00 00       	mov    $0x9,%eax
  801db1:	e8 4d fd ff ff       	call   801b03 <nsipc>
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	56                   	push   %esi
  801dbc:	53                   	push   %ebx
  801dbd:	83 ec 10             	sub    $0x10,%esp
  801dc0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	89 04 24             	mov    %eax,(%esp)
  801dc9:	e8 d2 f1 ff ff       	call   800fa0 <fd2data>
  801dce:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dd0:	c7 44 24 04 fe 2b 80 	movl   $0x802bfe,0x4(%esp)
  801dd7:	00 
  801dd8:	89 1c 24             	mov    %ebx,(%esp)
  801ddb:	e8 37 ea ff ff       	call   800817 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801de0:	8b 46 04             	mov    0x4(%esi),%eax
  801de3:	2b 06                	sub    (%esi),%eax
  801de5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801deb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801df2:	00 00 00 
	stat->st_dev = &devpipe;
  801df5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dfc:	30 80 00 
	return 0;
}
  801dff:	b8 00 00 00 00       	mov    $0x0,%eax
  801e04:	83 c4 10             	add    $0x10,%esp
  801e07:	5b                   	pop    %ebx
  801e08:	5e                   	pop    %esi
  801e09:	5d                   	pop    %ebp
  801e0a:	c3                   	ret    

00801e0b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	53                   	push   %ebx
  801e0f:	83 ec 14             	sub    $0x14,%esp
  801e12:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e15:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e20:	e8 07 ef ff ff       	call   800d2c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e25:	89 1c 24             	mov    %ebx,(%esp)
  801e28:	e8 73 f1 ff ff       	call   800fa0 <fd2data>
  801e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e38:	e8 ef ee ff ff       	call   800d2c <sys_page_unmap>
}
  801e3d:	83 c4 14             	add    $0x14,%esp
  801e40:	5b                   	pop    %ebx
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    

00801e43 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	57                   	push   %edi
  801e47:	56                   	push   %esi
  801e48:	53                   	push   %ebx
  801e49:	83 ec 2c             	sub    $0x2c,%esp
  801e4c:	89 c6                	mov    %eax,%esi
  801e4e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e51:	a1 08 40 80 00       	mov    0x804008,%eax
  801e56:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e59:	89 34 24             	mov    %esi,(%esp)
  801e5c:	e8 e6 05 00 00       	call   802447 <pageref>
  801e61:	89 c7                	mov    %eax,%edi
  801e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e66:	89 04 24             	mov    %eax,(%esp)
  801e69:	e8 d9 05 00 00       	call   802447 <pageref>
  801e6e:	39 c7                	cmp    %eax,%edi
  801e70:	0f 94 c2             	sete   %dl
  801e73:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e76:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801e7c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e7f:	39 fb                	cmp    %edi,%ebx
  801e81:	74 21                	je     801ea4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e83:	84 d2                	test   %dl,%dl
  801e85:	74 ca                	je     801e51 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e87:	8b 51 58             	mov    0x58(%ecx),%edx
  801e8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e8e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e92:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e96:	c7 04 24 05 2c 80 00 	movl   $0x802c05,(%esp)
  801e9d:	e8 00 e3 ff ff       	call   8001a2 <cprintf>
  801ea2:	eb ad                	jmp    801e51 <_pipeisclosed+0xe>
	}
}
  801ea4:	83 c4 2c             	add    $0x2c,%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5f                   	pop    %edi
  801eaa:	5d                   	pop    %ebp
  801eab:	c3                   	ret    

00801eac <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	57                   	push   %edi
  801eb0:	56                   	push   %esi
  801eb1:	53                   	push   %ebx
  801eb2:	83 ec 1c             	sub    $0x1c,%esp
  801eb5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801eb8:	89 34 24             	mov    %esi,(%esp)
  801ebb:	e8 e0 f0 ff ff       	call   800fa0 <fd2data>
  801ec0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ec2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec7:	eb 45                	jmp    801f0e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801ec9:	89 da                	mov    %ebx,%edx
  801ecb:	89 f0                	mov    %esi,%eax
  801ecd:	e8 71 ff ff ff       	call   801e43 <_pipeisclosed>
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	75 41                	jne    801f17 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801ed6:	e8 8b ed ff ff       	call   800c66 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801edb:	8b 43 04             	mov    0x4(%ebx),%eax
  801ede:	8b 0b                	mov    (%ebx),%ecx
  801ee0:	8d 51 20             	lea    0x20(%ecx),%edx
  801ee3:	39 d0                	cmp    %edx,%eax
  801ee5:	73 e2                	jae    801ec9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ee7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ef1:	99                   	cltd   
  801ef2:	c1 ea 1b             	shr    $0x1b,%edx
  801ef5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ef8:	83 e1 1f             	and    $0x1f,%ecx
  801efb:	29 d1                	sub    %edx,%ecx
  801efd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801f01:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801f05:	83 c0 01             	add    $0x1,%eax
  801f08:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f0b:	83 c7 01             	add    $0x1,%edi
  801f0e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f11:	75 c8                	jne    801edb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f13:	89 f8                	mov    %edi,%eax
  801f15:	eb 05                	jmp    801f1c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f17:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f1c:	83 c4 1c             	add    $0x1c,%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	5f                   	pop    %edi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    

00801f24 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	57                   	push   %edi
  801f28:	56                   	push   %esi
  801f29:	53                   	push   %ebx
  801f2a:	83 ec 1c             	sub    $0x1c,%esp
  801f2d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f30:	89 3c 24             	mov    %edi,(%esp)
  801f33:	e8 68 f0 ff ff       	call   800fa0 <fd2data>
  801f38:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f3a:	be 00 00 00 00       	mov    $0x0,%esi
  801f3f:	eb 3d                	jmp    801f7e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f41:	85 f6                	test   %esi,%esi
  801f43:	74 04                	je     801f49 <devpipe_read+0x25>
				return i;
  801f45:	89 f0                	mov    %esi,%eax
  801f47:	eb 43                	jmp    801f8c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f49:	89 da                	mov    %ebx,%edx
  801f4b:	89 f8                	mov    %edi,%eax
  801f4d:	e8 f1 fe ff ff       	call   801e43 <_pipeisclosed>
  801f52:	85 c0                	test   %eax,%eax
  801f54:	75 31                	jne    801f87 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f56:	e8 0b ed ff ff       	call   800c66 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f5b:	8b 03                	mov    (%ebx),%eax
  801f5d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f60:	74 df                	je     801f41 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f62:	99                   	cltd   
  801f63:	c1 ea 1b             	shr    $0x1b,%edx
  801f66:	01 d0                	add    %edx,%eax
  801f68:	83 e0 1f             	and    $0x1f,%eax
  801f6b:	29 d0                	sub    %edx,%eax
  801f6d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f75:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f78:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f7b:	83 c6 01             	add    $0x1,%esi
  801f7e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f81:	75 d8                	jne    801f5b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f83:	89 f0                	mov    %esi,%eax
  801f85:	eb 05                	jmp    801f8c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f8c:	83 c4 1c             	add    $0x1c,%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5f                   	pop    %edi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    

00801f94 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	56                   	push   %esi
  801f98:	53                   	push   %ebx
  801f99:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f9f:	89 04 24             	mov    %eax,(%esp)
  801fa2:	e8 10 f0 ff ff       	call   800fb7 <fd_alloc>
  801fa7:	89 c2                	mov    %eax,%edx
  801fa9:	85 d2                	test   %edx,%edx
  801fab:	0f 88 4d 01 00 00    	js     8020fe <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fb8:	00 
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc7:	e8 b9 ec ff ff       	call   800c85 <sys_page_alloc>
  801fcc:	89 c2                	mov    %eax,%edx
  801fce:	85 d2                	test   %edx,%edx
  801fd0:	0f 88 28 01 00 00    	js     8020fe <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fd6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fd9:	89 04 24             	mov    %eax,(%esp)
  801fdc:	e8 d6 ef ff ff       	call   800fb7 <fd_alloc>
  801fe1:	89 c3                	mov    %eax,%ebx
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	0f 88 fe 00 00 00    	js     8020e9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801feb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ff2:	00 
  801ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ffa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802001:	e8 7f ec ff ff       	call   800c85 <sys_page_alloc>
  802006:	89 c3                	mov    %eax,%ebx
  802008:	85 c0                	test   %eax,%eax
  80200a:	0f 88 d9 00 00 00    	js     8020e9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802013:	89 04 24             	mov    %eax,(%esp)
  802016:	e8 85 ef ff ff       	call   800fa0 <fd2data>
  80201b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802024:	00 
  802025:	89 44 24 04          	mov    %eax,0x4(%esp)
  802029:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802030:	e8 50 ec ff ff       	call   800c85 <sys_page_alloc>
  802035:	89 c3                	mov    %eax,%ebx
  802037:	85 c0                	test   %eax,%eax
  802039:	0f 88 97 00 00 00    	js     8020d6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80203f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802042:	89 04 24             	mov    %eax,(%esp)
  802045:	e8 56 ef ff ff       	call   800fa0 <fd2data>
  80204a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802051:	00 
  802052:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802056:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80205d:	00 
  80205e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802069:	e8 6b ec ff ff       	call   800cd9 <sys_page_map>
  80206e:	89 c3                	mov    %eax,%ebx
  802070:	85 c0                	test   %eax,%eax
  802072:	78 52                	js     8020c6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802074:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802089:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80208f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802092:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802097:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	89 04 24             	mov    %eax,(%esp)
  8020a4:	e8 e7 ee ff ff       	call   800f90 <fd2num>
  8020a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ac:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b1:	89 04 24             	mov    %eax,(%esp)
  8020b4:	e8 d7 ee ff ff       	call   800f90 <fd2num>
  8020b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020bc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c4:	eb 38                	jmp    8020fe <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8020c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d1:	e8 56 ec ff ff       	call   800d2c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e4:	e8 43 ec ff ff       	call   800d2c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f7:	e8 30 ec ff ff       	call   800d2c <sys_page_unmap>
  8020fc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8020fe:	83 c4 30             	add    $0x30,%esp
  802101:	5b                   	pop    %ebx
  802102:	5e                   	pop    %esi
  802103:	5d                   	pop    %ebp
  802104:	c3                   	ret    

00802105 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80210b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80210e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	89 04 24             	mov    %eax,(%esp)
  802118:	e8 e9 ee ff ff       	call   801006 <fd_lookup>
  80211d:	89 c2                	mov    %eax,%edx
  80211f:	85 d2                	test   %edx,%edx
  802121:	78 15                	js     802138 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	89 04 24             	mov    %eax,(%esp)
  802129:	e8 72 ee ff ff       	call   800fa0 <fd2data>
	return _pipeisclosed(fd, p);
  80212e:	89 c2                	mov    %eax,%edx
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	e8 0b fd ff ff       	call   801e43 <_pipeisclosed>
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    
  80213a:	66 90                	xchg   %ax,%ax
  80213c:	66 90                	xchg   %ax,%ax
  80213e:	66 90                	xchg   %ax,%ax

00802140 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802143:	b8 00 00 00 00       	mov    $0x0,%eax
  802148:	5d                   	pop    %ebp
  802149:	c3                   	ret    

0080214a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802150:	c7 44 24 04 1d 2c 80 	movl   $0x802c1d,0x4(%esp)
  802157:	00 
  802158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215b:	89 04 24             	mov    %eax,(%esp)
  80215e:	e8 b4 e6 ff ff       	call   800817 <strcpy>
	return 0;
}
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	57                   	push   %edi
  80216e:	56                   	push   %esi
  80216f:	53                   	push   %ebx
  802170:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802176:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80217b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802181:	eb 31                	jmp    8021b4 <devcons_write+0x4a>
		m = n - tot;
  802183:	8b 75 10             	mov    0x10(%ebp),%esi
  802186:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802188:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80218b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802190:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802193:	89 74 24 08          	mov    %esi,0x8(%esp)
  802197:	03 45 0c             	add    0xc(%ebp),%eax
  80219a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219e:	89 3c 24             	mov    %edi,(%esp)
  8021a1:	e8 0e e8 ff ff       	call   8009b4 <memmove>
		sys_cputs(buf, m);
  8021a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021aa:	89 3c 24             	mov    %edi,(%esp)
  8021ad:	e8 b4 e9 ff ff       	call   800b66 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021b2:	01 f3                	add    %esi,%ebx
  8021b4:	89 d8                	mov    %ebx,%eax
  8021b6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8021b9:	72 c8                	jb     802183 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8021bb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8021c1:	5b                   	pop    %ebx
  8021c2:	5e                   	pop    %esi
  8021c3:	5f                   	pop    %edi
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    

008021c6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8021cc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8021d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021d5:	75 07                	jne    8021de <devcons_read+0x18>
  8021d7:	eb 2a                	jmp    802203 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021d9:	e8 88 ea ff ff       	call   800c66 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021de:	66 90                	xchg   %ax,%ax
  8021e0:	e8 9f e9 ff ff       	call   800b84 <sys_cgetc>
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	74 f0                	je     8021d9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	78 16                	js     802203 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8021ed:	83 f8 04             	cmp    $0x4,%eax
  8021f0:	74 0c                	je     8021fe <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8021f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f5:	88 02                	mov    %al,(%edx)
	return 1;
  8021f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fc:	eb 05                	jmp    802203 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802211:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802218:	00 
  802219:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80221c:	89 04 24             	mov    %eax,(%esp)
  80221f:	e8 42 e9 ff ff       	call   800b66 <sys_cputs>
}
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <getchar>:

int
getchar(void)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80222c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802233:	00 
  802234:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802237:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802242:	e8 53 f0 ff ff       	call   80129a <read>
	if (r < 0)
  802247:	85 c0                	test   %eax,%eax
  802249:	78 0f                	js     80225a <getchar+0x34>
		return r;
	if (r < 1)
  80224b:	85 c0                	test   %eax,%eax
  80224d:	7e 06                	jle    802255 <getchar+0x2f>
		return -E_EOF;
	return c;
  80224f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802253:	eb 05                	jmp    80225a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802255:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802262:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802265:	89 44 24 04          	mov    %eax,0x4(%esp)
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	89 04 24             	mov    %eax,(%esp)
  80226f:	e8 92 ed ff ff       	call   801006 <fd_lookup>
  802274:	85 c0                	test   %eax,%eax
  802276:	78 11                	js     802289 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802281:	39 10                	cmp    %edx,(%eax)
  802283:	0f 94 c0             	sete   %al
  802286:	0f b6 c0             	movzbl %al,%eax
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <opencons>:

int
opencons(void)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802291:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802294:	89 04 24             	mov    %eax,(%esp)
  802297:	e8 1b ed ff ff       	call   800fb7 <fd_alloc>
		return r;
  80229c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	78 40                	js     8022e2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022a2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022a9:	00 
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b8:	e8 c8 e9 ff ff       	call   800c85 <sys_page_alloc>
		return r;
  8022bd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	78 1f                	js     8022e2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8022c3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022d8:	89 04 24             	mov    %eax,(%esp)
  8022db:	e8 b0 ec ff ff       	call   800f90 <fd2num>
  8022e0:	89 c2                	mov    %eax,%edx
}
  8022e2:	89 d0                	mov    %edx,%eax
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	56                   	push   %esi
  8022ea:	53                   	push   %ebx
  8022eb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8022ee:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022f1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8022f7:	e8 4b e9 ff ff       	call   800c47 <sys_getenvid>
  8022fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ff:	89 54 24 10          	mov    %edx,0x10(%esp)
  802303:	8b 55 08             	mov    0x8(%ebp),%edx
  802306:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80230a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80230e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802312:	c7 04 24 2c 2c 80 00 	movl   $0x802c2c,(%esp)
  802319:	e8 84 de ff ff       	call   8001a2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80231e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802322:	8b 45 10             	mov    0x10(%ebp),%eax
  802325:	89 04 24             	mov    %eax,(%esp)
  802328:	e8 14 de ff ff       	call   800141 <vcprintf>
	cprintf("\n");
  80232d:	c7 04 24 c3 2b 80 00 	movl   $0x802bc3,(%esp)
  802334:	e8 69 de ff ff       	call   8001a2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802339:	cc                   	int3   
  80233a:	eb fd                	jmp    802339 <_panic+0x53>
  80233c:	66 90                	xchg   %ax,%ax
  80233e:	66 90                	xchg   %ax,%ax

00802340 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	56                   	push   %esi
  802344:	53                   	push   %ebx
  802345:	83 ec 10             	sub    $0x10,%esp
  802348:	8b 75 08             	mov    0x8(%ebp),%esi
  80234b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802351:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802353:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802358:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80235b:	89 04 24             	mov    %eax,(%esp)
  80235e:	e8 58 eb ff ff       	call   800ebb <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802363:	85 c0                	test   %eax,%eax
  802365:	75 26                	jne    80238d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802367:	85 f6                	test   %esi,%esi
  802369:	74 0a                	je     802375 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80236b:	a1 08 40 80 00       	mov    0x804008,%eax
  802370:	8b 40 74             	mov    0x74(%eax),%eax
  802373:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802375:	85 db                	test   %ebx,%ebx
  802377:	74 0a                	je     802383 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802379:	a1 08 40 80 00       	mov    0x804008,%eax
  80237e:	8b 40 78             	mov    0x78(%eax),%eax
  802381:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802383:	a1 08 40 80 00       	mov    0x804008,%eax
  802388:	8b 40 70             	mov    0x70(%eax),%eax
  80238b:	eb 14                	jmp    8023a1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80238d:	85 f6                	test   %esi,%esi
  80238f:	74 06                	je     802397 <ipc_recv+0x57>
			*from_env_store = 0;
  802391:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802397:	85 db                	test   %ebx,%ebx
  802399:	74 06                	je     8023a1 <ipc_recv+0x61>
			*perm_store = 0;
  80239b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  8023a1:	83 c4 10             	add    $0x10,%esp
  8023a4:	5b                   	pop    %ebx
  8023a5:	5e                   	pop    %esi
  8023a6:	5d                   	pop    %ebp
  8023a7:	c3                   	ret    

008023a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
  8023ab:	57                   	push   %edi
  8023ac:	56                   	push   %esi
  8023ad:	53                   	push   %ebx
  8023ae:	83 ec 1c             	sub    $0x1c,%esp
  8023b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023b7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  8023ba:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  8023bc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8023c1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8023c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023d3:	89 3c 24             	mov    %edi,(%esp)
  8023d6:	e8 bd ea ff ff       	call   800e98 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	74 28                	je     802407 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  8023df:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023e2:	74 1c                	je     802400 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  8023e4:	c7 44 24 08 50 2c 80 	movl   $0x802c50,0x8(%esp)
  8023eb:	00 
  8023ec:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8023f3:	00 
  8023f4:	c7 04 24 74 2c 80 00 	movl   $0x802c74,(%esp)
  8023fb:	e8 e6 fe ff ff       	call   8022e6 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802400:	e8 61 e8 ff ff       	call   800c66 <sys_yield>
	}
  802405:	eb bd                	jmp    8023c4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802407:	83 c4 1c             	add    $0x1c,%esp
  80240a:	5b                   	pop    %ebx
  80240b:	5e                   	pop    %esi
  80240c:	5f                   	pop    %edi
  80240d:	5d                   	pop    %ebp
  80240e:	c3                   	ret    

0080240f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802415:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80241a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80241d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802423:	8b 52 50             	mov    0x50(%edx),%edx
  802426:	39 ca                	cmp    %ecx,%edx
  802428:	75 0d                	jne    802437 <ipc_find_env+0x28>
			return envs[i].env_id;
  80242a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80242d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802432:	8b 40 40             	mov    0x40(%eax),%eax
  802435:	eb 0e                	jmp    802445 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802437:	83 c0 01             	add    $0x1,%eax
  80243a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80243f:	75 d9                	jne    80241a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802441:	66 b8 00 00          	mov    $0x0,%ax
}
  802445:	5d                   	pop    %ebp
  802446:	c3                   	ret    

00802447 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80244d:	89 d0                	mov    %edx,%eax
  80244f:	c1 e8 16             	shr    $0x16,%eax
  802452:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80245e:	f6 c1 01             	test   $0x1,%cl
  802461:	74 1d                	je     802480 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802463:	c1 ea 0c             	shr    $0xc,%edx
  802466:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80246d:	f6 c2 01             	test   $0x1,%dl
  802470:	74 0e                	je     802480 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802472:	c1 ea 0c             	shr    $0xc,%edx
  802475:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80247c:	ef 
  80247d:	0f b7 c0             	movzwl %ax,%eax
}
  802480:	5d                   	pop    %ebp
  802481:	c3                   	ret    
  802482:	66 90                	xchg   %ax,%ax
  802484:	66 90                	xchg   %ax,%ax
  802486:	66 90                	xchg   %ax,%ax
  802488:	66 90                	xchg   %ax,%ax
  80248a:	66 90                	xchg   %ax,%ax
  80248c:	66 90                	xchg   %ax,%ax
  80248e:	66 90                	xchg   %ax,%ax

00802490 <__udivdi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	83 ec 0c             	sub    $0xc,%esp
  802496:	8b 44 24 28          	mov    0x28(%esp),%eax
  80249a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80249e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024ac:	89 ea                	mov    %ebp,%edx
  8024ae:	89 0c 24             	mov    %ecx,(%esp)
  8024b1:	75 2d                	jne    8024e0 <__udivdi3+0x50>
  8024b3:	39 e9                	cmp    %ebp,%ecx
  8024b5:	77 61                	ja     802518 <__udivdi3+0x88>
  8024b7:	85 c9                	test   %ecx,%ecx
  8024b9:	89 ce                	mov    %ecx,%esi
  8024bb:	75 0b                	jne    8024c8 <__udivdi3+0x38>
  8024bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c2:	31 d2                	xor    %edx,%edx
  8024c4:	f7 f1                	div    %ecx
  8024c6:	89 c6                	mov    %eax,%esi
  8024c8:	31 d2                	xor    %edx,%edx
  8024ca:	89 e8                	mov    %ebp,%eax
  8024cc:	f7 f6                	div    %esi
  8024ce:	89 c5                	mov    %eax,%ebp
  8024d0:	89 f8                	mov    %edi,%eax
  8024d2:	f7 f6                	div    %esi
  8024d4:	89 ea                	mov    %ebp,%edx
  8024d6:	83 c4 0c             	add    $0xc,%esp
  8024d9:	5e                   	pop    %esi
  8024da:	5f                   	pop    %edi
  8024db:	5d                   	pop    %ebp
  8024dc:	c3                   	ret    
  8024dd:	8d 76 00             	lea    0x0(%esi),%esi
  8024e0:	39 e8                	cmp    %ebp,%eax
  8024e2:	77 24                	ja     802508 <__udivdi3+0x78>
  8024e4:	0f bd e8             	bsr    %eax,%ebp
  8024e7:	83 f5 1f             	xor    $0x1f,%ebp
  8024ea:	75 3c                	jne    802528 <__udivdi3+0x98>
  8024ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024f0:	39 34 24             	cmp    %esi,(%esp)
  8024f3:	0f 86 9f 00 00 00    	jbe    802598 <__udivdi3+0x108>
  8024f9:	39 d0                	cmp    %edx,%eax
  8024fb:	0f 82 97 00 00 00    	jb     802598 <__udivdi3+0x108>
  802501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802508:	31 d2                	xor    %edx,%edx
  80250a:	31 c0                	xor    %eax,%eax
  80250c:	83 c4 0c             	add    $0xc,%esp
  80250f:	5e                   	pop    %esi
  802510:	5f                   	pop    %edi
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    
  802513:	90                   	nop
  802514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802518:	89 f8                	mov    %edi,%eax
  80251a:	f7 f1                	div    %ecx
  80251c:	31 d2                	xor    %edx,%edx
  80251e:	83 c4 0c             	add    $0xc,%esp
  802521:	5e                   	pop    %esi
  802522:	5f                   	pop    %edi
  802523:	5d                   	pop    %ebp
  802524:	c3                   	ret    
  802525:	8d 76 00             	lea    0x0(%esi),%esi
  802528:	89 e9                	mov    %ebp,%ecx
  80252a:	8b 3c 24             	mov    (%esp),%edi
  80252d:	d3 e0                	shl    %cl,%eax
  80252f:	89 c6                	mov    %eax,%esi
  802531:	b8 20 00 00 00       	mov    $0x20,%eax
  802536:	29 e8                	sub    %ebp,%eax
  802538:	89 c1                	mov    %eax,%ecx
  80253a:	d3 ef                	shr    %cl,%edi
  80253c:	89 e9                	mov    %ebp,%ecx
  80253e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802542:	8b 3c 24             	mov    (%esp),%edi
  802545:	09 74 24 08          	or     %esi,0x8(%esp)
  802549:	89 d6                	mov    %edx,%esi
  80254b:	d3 e7                	shl    %cl,%edi
  80254d:	89 c1                	mov    %eax,%ecx
  80254f:	89 3c 24             	mov    %edi,(%esp)
  802552:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802556:	d3 ee                	shr    %cl,%esi
  802558:	89 e9                	mov    %ebp,%ecx
  80255a:	d3 e2                	shl    %cl,%edx
  80255c:	89 c1                	mov    %eax,%ecx
  80255e:	d3 ef                	shr    %cl,%edi
  802560:	09 d7                	or     %edx,%edi
  802562:	89 f2                	mov    %esi,%edx
  802564:	89 f8                	mov    %edi,%eax
  802566:	f7 74 24 08          	divl   0x8(%esp)
  80256a:	89 d6                	mov    %edx,%esi
  80256c:	89 c7                	mov    %eax,%edi
  80256e:	f7 24 24             	mull   (%esp)
  802571:	39 d6                	cmp    %edx,%esi
  802573:	89 14 24             	mov    %edx,(%esp)
  802576:	72 30                	jb     8025a8 <__udivdi3+0x118>
  802578:	8b 54 24 04          	mov    0x4(%esp),%edx
  80257c:	89 e9                	mov    %ebp,%ecx
  80257e:	d3 e2                	shl    %cl,%edx
  802580:	39 c2                	cmp    %eax,%edx
  802582:	73 05                	jae    802589 <__udivdi3+0xf9>
  802584:	3b 34 24             	cmp    (%esp),%esi
  802587:	74 1f                	je     8025a8 <__udivdi3+0x118>
  802589:	89 f8                	mov    %edi,%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	e9 7a ff ff ff       	jmp    80250c <__udivdi3+0x7c>
  802592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802598:	31 d2                	xor    %edx,%edx
  80259a:	b8 01 00 00 00       	mov    $0x1,%eax
  80259f:	e9 68 ff ff ff       	jmp    80250c <__udivdi3+0x7c>
  8025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	83 c4 0c             	add    $0xc,%esp
  8025b0:	5e                   	pop    %esi
  8025b1:	5f                   	pop    %edi
  8025b2:	5d                   	pop    %ebp
  8025b3:	c3                   	ret    
  8025b4:	66 90                	xchg   %ax,%ax
  8025b6:	66 90                	xchg   %ax,%ax
  8025b8:	66 90                	xchg   %ax,%ax
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	66 90                	xchg   %ax,%ax
  8025be:	66 90                	xchg   %ax,%ax

008025c0 <__umoddi3>:
  8025c0:	55                   	push   %ebp
  8025c1:	57                   	push   %edi
  8025c2:	56                   	push   %esi
  8025c3:	83 ec 14             	sub    $0x14,%esp
  8025c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025ca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025ce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8025d2:	89 c7                	mov    %eax,%edi
  8025d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8025dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025e0:	89 34 24             	mov    %esi,(%esp)
  8025e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	89 c2                	mov    %eax,%edx
  8025eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ef:	75 17                	jne    802608 <__umoddi3+0x48>
  8025f1:	39 fe                	cmp    %edi,%esi
  8025f3:	76 4b                	jbe    802640 <__umoddi3+0x80>
  8025f5:	89 c8                	mov    %ecx,%eax
  8025f7:	89 fa                	mov    %edi,%edx
  8025f9:	f7 f6                	div    %esi
  8025fb:	89 d0                	mov    %edx,%eax
  8025fd:	31 d2                	xor    %edx,%edx
  8025ff:	83 c4 14             	add    $0x14,%esp
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    
  802606:	66 90                	xchg   %ax,%ax
  802608:	39 f8                	cmp    %edi,%eax
  80260a:	77 54                	ja     802660 <__umoddi3+0xa0>
  80260c:	0f bd e8             	bsr    %eax,%ebp
  80260f:	83 f5 1f             	xor    $0x1f,%ebp
  802612:	75 5c                	jne    802670 <__umoddi3+0xb0>
  802614:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802618:	39 3c 24             	cmp    %edi,(%esp)
  80261b:	0f 87 e7 00 00 00    	ja     802708 <__umoddi3+0x148>
  802621:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802625:	29 f1                	sub    %esi,%ecx
  802627:	19 c7                	sbb    %eax,%edi
  802629:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80262d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802631:	8b 44 24 08          	mov    0x8(%esp),%eax
  802635:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802639:	83 c4 14             	add    $0x14,%esp
  80263c:	5e                   	pop    %esi
  80263d:	5f                   	pop    %edi
  80263e:	5d                   	pop    %ebp
  80263f:	c3                   	ret    
  802640:	85 f6                	test   %esi,%esi
  802642:	89 f5                	mov    %esi,%ebp
  802644:	75 0b                	jne    802651 <__umoddi3+0x91>
  802646:	b8 01 00 00 00       	mov    $0x1,%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	f7 f6                	div    %esi
  80264f:	89 c5                	mov    %eax,%ebp
  802651:	8b 44 24 04          	mov    0x4(%esp),%eax
  802655:	31 d2                	xor    %edx,%edx
  802657:	f7 f5                	div    %ebp
  802659:	89 c8                	mov    %ecx,%eax
  80265b:	f7 f5                	div    %ebp
  80265d:	eb 9c                	jmp    8025fb <__umoddi3+0x3b>
  80265f:	90                   	nop
  802660:	89 c8                	mov    %ecx,%eax
  802662:	89 fa                	mov    %edi,%edx
  802664:	83 c4 14             	add    $0x14,%esp
  802667:	5e                   	pop    %esi
  802668:	5f                   	pop    %edi
  802669:	5d                   	pop    %ebp
  80266a:	c3                   	ret    
  80266b:	90                   	nop
  80266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802670:	8b 04 24             	mov    (%esp),%eax
  802673:	be 20 00 00 00       	mov    $0x20,%esi
  802678:	89 e9                	mov    %ebp,%ecx
  80267a:	29 ee                	sub    %ebp,%esi
  80267c:	d3 e2                	shl    %cl,%edx
  80267e:	89 f1                	mov    %esi,%ecx
  802680:	d3 e8                	shr    %cl,%eax
  802682:	89 e9                	mov    %ebp,%ecx
  802684:	89 44 24 04          	mov    %eax,0x4(%esp)
  802688:	8b 04 24             	mov    (%esp),%eax
  80268b:	09 54 24 04          	or     %edx,0x4(%esp)
  80268f:	89 fa                	mov    %edi,%edx
  802691:	d3 e0                	shl    %cl,%eax
  802693:	89 f1                	mov    %esi,%ecx
  802695:	89 44 24 08          	mov    %eax,0x8(%esp)
  802699:	8b 44 24 10          	mov    0x10(%esp),%eax
  80269d:	d3 ea                	shr    %cl,%edx
  80269f:	89 e9                	mov    %ebp,%ecx
  8026a1:	d3 e7                	shl    %cl,%edi
  8026a3:	89 f1                	mov    %esi,%ecx
  8026a5:	d3 e8                	shr    %cl,%eax
  8026a7:	89 e9                	mov    %ebp,%ecx
  8026a9:	09 f8                	or     %edi,%eax
  8026ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026af:	f7 74 24 04          	divl   0x4(%esp)
  8026b3:	d3 e7                	shl    %cl,%edi
  8026b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026b9:	89 d7                	mov    %edx,%edi
  8026bb:	f7 64 24 08          	mull   0x8(%esp)
  8026bf:	39 d7                	cmp    %edx,%edi
  8026c1:	89 c1                	mov    %eax,%ecx
  8026c3:	89 14 24             	mov    %edx,(%esp)
  8026c6:	72 2c                	jb     8026f4 <__umoddi3+0x134>
  8026c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8026cc:	72 22                	jb     8026f0 <__umoddi3+0x130>
  8026ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8026d2:	29 c8                	sub    %ecx,%eax
  8026d4:	19 d7                	sbb    %edx,%edi
  8026d6:	89 e9                	mov    %ebp,%ecx
  8026d8:	89 fa                	mov    %edi,%edx
  8026da:	d3 e8                	shr    %cl,%eax
  8026dc:	89 f1                	mov    %esi,%ecx
  8026de:	d3 e2                	shl    %cl,%edx
  8026e0:	89 e9                	mov    %ebp,%ecx
  8026e2:	d3 ef                	shr    %cl,%edi
  8026e4:	09 d0                	or     %edx,%eax
  8026e6:	89 fa                	mov    %edi,%edx
  8026e8:	83 c4 14             	add    $0x14,%esp
  8026eb:	5e                   	pop    %esi
  8026ec:	5f                   	pop    %edi
  8026ed:	5d                   	pop    %ebp
  8026ee:	c3                   	ret    
  8026ef:	90                   	nop
  8026f0:	39 d7                	cmp    %edx,%edi
  8026f2:	75 da                	jne    8026ce <__umoddi3+0x10e>
  8026f4:	8b 14 24             	mov    (%esp),%edx
  8026f7:	89 c1                	mov    %eax,%ecx
  8026f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802701:	eb cb                	jmp    8026ce <__umoddi3+0x10e>
  802703:	90                   	nop
  802704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802708:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80270c:	0f 82 0f ff ff ff    	jb     802621 <__umoddi3+0x61>
  802712:	e9 1a ff ff ff       	jmp    802631 <__umoddi3+0x71>
