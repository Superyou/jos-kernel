
obj/user/spawnhello.debug:     file format elf32-i386


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
  80002c:	e8 62 00 00 00       	call   800093 <libmain>
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
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 08 50 80 00       	mov    0x805008,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	89 44 24 04          	mov    %eax,0x4(%esp)
  800045:	c7 04 24 c0 2d 80 00 	movl   $0x802dc0,(%esp)
  80004c:	e8 9c 01 00 00       	call   8001ed <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  800051:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 de 2d 80 	movl   $0x802dde,0x4(%esp)
  800060:	00 
  800061:	c7 04 24 de 2d 80 00 	movl   $0x802dde,(%esp)
  800068:	e8 a5 1e 00 00       	call   801f12 <spawnl>
  80006d:	85 c0                	test   %eax,%eax
  80006f:	79 20                	jns    800091 <umain+0x5e>
		panic("spawn(hello) failed: %e", r);
  800071:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800075:	c7 44 24 08 e4 2d 80 	movl   $0x802de4,0x8(%esp)
  80007c:	00 
  80007d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800084:	00 
  800085:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  80008c:	e8 63 00 00 00       	call   8000f4 <_panic>
}
  800091:	c9                   	leave  
  800092:	c3                   	ret    

00800093 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800093:	55                   	push   %ebp
  800094:	89 e5                	mov    %esp,%ebp
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	83 ec 10             	sub    $0x10,%esp
  80009b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80009e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a1:	e8 f1 0b 00 00       	call   800c97 <sys_getenvid>
  8000a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ab:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b3:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b8:	85 db                	test   %ebx,%ebx
  8000ba:	7e 07                	jle    8000c3 <libmain+0x30>
		binaryname = argv[0];
  8000bc:	8b 06                	mov    (%esi),%eax
  8000be:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000c7:	89 1c 24             	mov    %ebx,(%esp)
  8000ca:	e8 64 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000cf:	e8 07 00 00 00       	call   8000db <exit>
}
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    

008000db <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000e1:	e8 d4 10 00 00       	call   8011ba <close_all>
	sys_env_destroy(0);
  8000e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ed:	e8 01 0b 00 00       	call   800bf3 <sys_env_destroy>
}
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8000fc:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000ff:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800105:	e8 8d 0b 00 00       	call   800c97 <sys_getenvid>
  80010a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80010d:	89 54 24 10          	mov    %edx,0x10(%esp)
  800111:	8b 55 08             	mov    0x8(%ebp),%edx
  800114:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800118:	89 74 24 08          	mov    %esi,0x8(%esp)
  80011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800120:	c7 04 24 18 2e 80 00 	movl   $0x802e18,(%esp)
  800127:	e8 c1 00 00 00       	call   8001ed <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80012c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800130:	8b 45 10             	mov    0x10(%ebp),%eax
  800133:	89 04 24             	mov    %eax,(%esp)
  800136:	e8 51 00 00 00       	call   80018c <vcprintf>
	cprintf("\n");
  80013b:	c7 04 24 63 32 80 00 	movl   $0x803263,(%esp)
  800142:	e8 a6 00 00 00       	call   8001ed <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800147:	cc                   	int3   
  800148:	eb fd                	jmp    800147 <_panic+0x53>

0080014a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	53                   	push   %ebx
  80014e:	83 ec 14             	sub    $0x14,%esp
  800151:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800154:	8b 13                	mov    (%ebx),%edx
  800156:	8d 42 01             	lea    0x1(%edx),%eax
  800159:	89 03                	mov    %eax,(%ebx)
  80015b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800162:	3d ff 00 00 00       	cmp    $0xff,%eax
  800167:	75 19                	jne    800182 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800169:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800170:	00 
  800171:	8d 43 08             	lea    0x8(%ebx),%eax
  800174:	89 04 24             	mov    %eax,(%esp)
  800177:	e8 3a 0a 00 00       	call   800bb6 <sys_cputs>
		b->idx = 0;
  80017c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800182:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800186:	83 c4 14             	add    $0x14,%esp
  800189:	5b                   	pop    %ebx
  80018a:	5d                   	pop    %ebp
  80018b:	c3                   	ret    

0080018c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800195:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80019c:	00 00 00 
	b.cnt = 0;
  80019f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001b7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c1:	c7 04 24 4a 01 80 00 	movl   $0x80014a,(%esp)
  8001c8:	e8 77 01 00 00       	call   800344 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001cd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001dd:	89 04 24             	mov    %eax,(%esp)
  8001e0:	e8 d1 09 00 00       	call   800bb6 <sys_cputs>

	return b.cnt;
}
  8001e5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001eb:	c9                   	leave  
  8001ec:	c3                   	ret    

008001ed <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fd:	89 04 24             	mov    %eax,(%esp)
  800200:	e8 87 ff ff ff       	call   80018c <vcprintf>
	va_end(ap);

	return cnt;
}
  800205:	c9                   	leave  
  800206:	c3                   	ret    
  800207:	66 90                	xchg   %ax,%ax
  800209:	66 90                	xchg   %ax,%ax
  80020b:	66 90                	xchg   %ax,%ax
  80020d:	66 90                	xchg   %ax,%ax
  80020f:	90                   	nop

00800210 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 3c             	sub    $0x3c,%esp
  800219:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80021c:	89 d7                	mov    %edx,%edi
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800224:	8b 45 0c             	mov    0xc(%ebp),%eax
  800227:	89 c3                	mov    %eax,%ebx
  800229:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80022c:	8b 45 10             	mov    0x10(%ebp),%eax
  80022f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800232:	b9 00 00 00 00       	mov    $0x0,%ecx
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80023d:	39 d9                	cmp    %ebx,%ecx
  80023f:	72 05                	jb     800246 <printnum+0x36>
  800241:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800244:	77 69                	ja     8002af <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800246:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800249:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80024d:	83 ee 01             	sub    $0x1,%esi
  800250:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800254:	89 44 24 08          	mov    %eax,0x8(%esp)
  800258:	8b 44 24 08          	mov    0x8(%esp),%eax
  80025c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800260:	89 c3                	mov    %eax,%ebx
  800262:	89 d6                	mov    %edx,%esi
  800264:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800267:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80026a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80026e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800275:	89 04 24             	mov    %eax,(%esp)
  800278:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027f:	e8 9c 28 00 00       	call   802b20 <__udivdi3>
  800284:	89 d9                	mov    %ebx,%ecx
  800286:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80028a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80028e:	89 04 24             	mov    %eax,(%esp)
  800291:	89 54 24 04          	mov    %edx,0x4(%esp)
  800295:	89 fa                	mov    %edi,%edx
  800297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80029a:	e8 71 ff ff ff       	call   800210 <printnum>
  80029f:	eb 1b                	jmp    8002bc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002a8:	89 04 24             	mov    %eax,(%esp)
  8002ab:	ff d3                	call   *%ebx
  8002ad:	eb 03                	jmp    8002b2 <printnum+0xa2>
  8002af:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b2:	83 ee 01             	sub    $0x1,%esi
  8002b5:	85 f6                	test   %esi,%esi
  8002b7:	7f e8                	jg     8002a1 <printnum+0x91>
  8002b9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002c0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002df:	e8 6c 29 00 00       	call   802c50 <__umoddi3>
  8002e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002e8:	0f be 80 3b 2e 80 00 	movsbl 0x802e3b(%eax),%eax
  8002ef:	89 04 24             	mov    %eax,(%esp)
  8002f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002f5:	ff d0                	call   *%eax
}
  8002f7:	83 c4 3c             	add    $0x3c,%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    

008002ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800305:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800309:	8b 10                	mov    (%eax),%edx
  80030b:	3b 50 04             	cmp    0x4(%eax),%edx
  80030e:	73 0a                	jae    80031a <sprintputch+0x1b>
		*b->buf++ = ch;
  800310:	8d 4a 01             	lea    0x1(%edx),%ecx
  800313:	89 08                	mov    %ecx,(%eax)
  800315:	8b 45 08             	mov    0x8(%ebp),%eax
  800318:	88 02                	mov    %al,(%edx)
}
  80031a:	5d                   	pop    %ebp
  80031b:	c3                   	ret    

0080031c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800322:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800325:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800329:	8b 45 10             	mov    0x10(%ebp),%eax
  80032c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800330:	8b 45 0c             	mov    0xc(%ebp),%eax
  800333:	89 44 24 04          	mov    %eax,0x4(%esp)
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	89 04 24             	mov    %eax,(%esp)
  80033d:	e8 02 00 00 00       	call   800344 <vprintfmt>
	va_end(ap);
}
  800342:	c9                   	leave  
  800343:	c3                   	ret    

00800344 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	57                   	push   %edi
  800348:	56                   	push   %esi
  800349:	53                   	push   %ebx
  80034a:	83 ec 3c             	sub    $0x3c,%esp
  80034d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800350:	eb 17                	jmp    800369 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800352:	85 c0                	test   %eax,%eax
  800354:	0f 84 4b 04 00 00    	je     8007a5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80035a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80035d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800361:	89 04 24             	mov    %eax,(%esp)
  800364:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800367:	89 fb                	mov    %edi,%ebx
  800369:	8d 7b 01             	lea    0x1(%ebx),%edi
  80036c:	0f b6 03             	movzbl (%ebx),%eax
  80036f:	83 f8 25             	cmp    $0x25,%eax
  800372:	75 de                	jne    800352 <vprintfmt+0xe>
  800374:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800378:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80037f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800384:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80038b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800390:	eb 18                	jmp    8003aa <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800392:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800394:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800398:	eb 10                	jmp    8003aa <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80039a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80039c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8003a0:	eb 08                	jmp    8003aa <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003a2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8003a5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003aa:	8d 5f 01             	lea    0x1(%edi),%ebx
  8003ad:	0f b6 17             	movzbl (%edi),%edx
  8003b0:	0f b6 c2             	movzbl %dl,%eax
  8003b3:	83 ea 23             	sub    $0x23,%edx
  8003b6:	80 fa 55             	cmp    $0x55,%dl
  8003b9:	0f 87 c2 03 00 00    	ja     800781 <vprintfmt+0x43d>
  8003bf:	0f b6 d2             	movzbl %dl,%edx
  8003c2:	ff 24 95 80 2f 80 00 	jmp    *0x802f80(,%edx,4)
  8003c9:	89 df                	mov    %ebx,%edi
  8003cb:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003d0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8003d3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8003d7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  8003da:	8d 50 d0             	lea    -0x30(%eax),%edx
  8003dd:	83 fa 09             	cmp    $0x9,%edx
  8003e0:	77 33                	ja     800415 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003e2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003e5:	eb e9                	jmp    8003d0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ea:	8b 30                	mov    (%eax),%esi
  8003ec:	8d 40 04             	lea    0x4(%eax),%eax
  8003ef:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003f4:	eb 1f                	jmp    800415 <vprintfmt+0xd1>
  8003f6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8003f9:	85 ff                	test   %edi,%edi
  8003fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800400:	0f 49 c7             	cmovns %edi,%eax
  800403:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800406:	89 df                	mov    %ebx,%edi
  800408:	eb a0                	jmp    8003aa <vprintfmt+0x66>
  80040a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80040c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800413:	eb 95                	jmp    8003aa <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800415:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800419:	79 8f                	jns    8003aa <vprintfmt+0x66>
  80041b:	eb 85                	jmp    8003a2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80041d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800420:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800422:	eb 86                	jmp    8003aa <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	8d 70 04             	lea    0x4(%eax),%esi
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800431:	8b 45 14             	mov    0x14(%ebp),%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	89 04 24             	mov    %eax,(%esp)
  800439:	ff 55 08             	call   *0x8(%ebp)
  80043c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80043f:	e9 25 ff ff ff       	jmp    800369 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800444:	8b 45 14             	mov    0x14(%ebp),%eax
  800447:	8d 70 04             	lea    0x4(%eax),%esi
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	99                   	cltd   
  80044d:	31 d0                	xor    %edx,%eax
  80044f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800451:	83 f8 15             	cmp    $0x15,%eax
  800454:	7f 0b                	jg     800461 <vprintfmt+0x11d>
  800456:	8b 14 85 e0 30 80 00 	mov    0x8030e0(,%eax,4),%edx
  80045d:	85 d2                	test   %edx,%edx
  80045f:	75 26                	jne    800487 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800461:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800465:	c7 44 24 08 53 2e 80 	movl   $0x802e53,0x8(%esp)
  80046c:	00 
  80046d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800470:	89 44 24 04          	mov    %eax,0x4(%esp)
  800474:	8b 45 08             	mov    0x8(%ebp),%eax
  800477:	89 04 24             	mov    %eax,(%esp)
  80047a:	e8 9d fe ff ff       	call   80031c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80047f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800482:	e9 e2 fe ff ff       	jmp    800369 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800487:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80048b:	c7 44 24 08 32 32 80 	movl   $0x803232,0x8(%esp)
  800492:	00 
  800493:	8b 45 0c             	mov    0xc(%ebp),%eax
  800496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	89 04 24             	mov    %eax,(%esp)
  8004a0:	e8 77 fe ff ff       	call   80031c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004a5:	89 75 14             	mov    %esi,0x14(%ebp)
  8004a8:	e9 bc fe ff ff       	jmp    800369 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004b6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004ba:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004bc:	85 ff                	test   %edi,%edi
  8004be:	b8 4c 2e 80 00       	mov    $0x802e4c,%eax
  8004c3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004c6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8004ca:	0f 84 94 00 00 00    	je     800564 <vprintfmt+0x220>
  8004d0:	85 c9                	test   %ecx,%ecx
  8004d2:	0f 8e 94 00 00 00    	jle    80056c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004dc:	89 3c 24             	mov    %edi,(%esp)
  8004df:	e8 64 03 00 00       	call   800848 <strnlen>
  8004e4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8004e7:	29 c1                	sub    %eax,%ecx
  8004e9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  8004ec:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  8004f0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8004f3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004fc:	89 cb                	mov    %ecx,%ebx
  8004fe:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800500:	eb 0f                	jmp    800511 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800502:	8b 45 0c             	mov    0xc(%ebp),%eax
  800505:	89 44 24 04          	mov    %eax,0x4(%esp)
  800509:	89 3c 24             	mov    %edi,(%esp)
  80050c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80050e:	83 eb 01             	sub    $0x1,%ebx
  800511:	85 db                	test   %ebx,%ebx
  800513:	7f ed                	jg     800502 <vprintfmt+0x1be>
  800515:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800518:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80051b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051e:	85 c9                	test   %ecx,%ecx
  800520:	b8 00 00 00 00       	mov    $0x0,%eax
  800525:	0f 49 c1             	cmovns %ecx,%eax
  800528:	29 c1                	sub    %eax,%ecx
  80052a:	89 cb                	mov    %ecx,%ebx
  80052c:	eb 44                	jmp    800572 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80052e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800532:	74 1e                	je     800552 <vprintfmt+0x20e>
  800534:	0f be d2             	movsbl %dl,%edx
  800537:	83 ea 20             	sub    $0x20,%edx
  80053a:	83 fa 5e             	cmp    $0x5e,%edx
  80053d:	76 13                	jbe    800552 <vprintfmt+0x20e>
					putch('?', putdat);
  80053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800542:	89 44 24 04          	mov    %eax,0x4(%esp)
  800546:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80054d:	ff 55 08             	call   *0x8(%ebp)
  800550:	eb 0d                	jmp    80055f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800552:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800555:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800559:	89 04 24             	mov    %eax,(%esp)
  80055c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80055f:	83 eb 01             	sub    $0x1,%ebx
  800562:	eb 0e                	jmp    800572 <vprintfmt+0x22e>
  800564:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800567:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80056a:	eb 06                	jmp    800572 <vprintfmt+0x22e>
  80056c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80056f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800572:	83 c7 01             	add    $0x1,%edi
  800575:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800579:	0f be c2             	movsbl %dl,%eax
  80057c:	85 c0                	test   %eax,%eax
  80057e:	74 27                	je     8005a7 <vprintfmt+0x263>
  800580:	85 f6                	test   %esi,%esi
  800582:	78 aa                	js     80052e <vprintfmt+0x1ea>
  800584:	83 ee 01             	sub    $0x1,%esi
  800587:	79 a5                	jns    80052e <vprintfmt+0x1ea>
  800589:	89 d8                	mov    %ebx,%eax
  80058b:	8b 75 08             	mov    0x8(%ebp),%esi
  80058e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800591:	89 c3                	mov    %eax,%ebx
  800593:	eb 18                	jmp    8005ad <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800595:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800599:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005a0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005a2:	83 eb 01             	sub    $0x1,%ebx
  8005a5:	eb 06                	jmp    8005ad <vprintfmt+0x269>
  8005a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8005aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005ad:	85 db                	test   %ebx,%ebx
  8005af:	7f e4                	jg     800595 <vprintfmt+0x251>
  8005b1:	89 75 08             	mov    %esi,0x8(%ebp)
  8005b4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005ba:	e9 aa fd ff ff       	jmp    800369 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005bf:	83 f9 01             	cmp    $0x1,%ecx
  8005c2:	7e 10                	jle    8005d4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8b 30                	mov    (%eax),%esi
  8005c9:	8b 78 04             	mov    0x4(%eax),%edi
  8005cc:	8d 40 08             	lea    0x8(%eax),%eax
  8005cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d2:	eb 26                	jmp    8005fa <vprintfmt+0x2b6>
	else if (lflag)
  8005d4:	85 c9                	test   %ecx,%ecx
  8005d6:	74 12                	je     8005ea <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8b 30                	mov    (%eax),%esi
  8005dd:	89 f7                	mov    %esi,%edi
  8005df:	c1 ff 1f             	sar    $0x1f,%edi
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb 10                	jmp    8005fa <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8b 30                	mov    (%eax),%esi
  8005ef:	89 f7                	mov    %esi,%edi
  8005f1:	c1 ff 1f             	sar    $0x1f,%edi
  8005f4:	8d 40 04             	lea    0x4(%eax),%eax
  8005f7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005fa:	89 f0                	mov    %esi,%eax
  8005fc:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800603:	85 ff                	test   %edi,%edi
  800605:	0f 89 3a 01 00 00    	jns    800745 <vprintfmt+0x401>
				putch('-', putdat);
  80060b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800612:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800619:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80061c:	89 f0                	mov    %esi,%eax
  80061e:	89 fa                	mov    %edi,%edx
  800620:	f7 d8                	neg    %eax
  800622:	83 d2 00             	adc    $0x0,%edx
  800625:	f7 da                	neg    %edx
			}
			base = 10;
  800627:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80062c:	e9 14 01 00 00       	jmp    800745 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800631:	83 f9 01             	cmp    $0x1,%ecx
  800634:	7e 13                	jle    800649 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 50 04             	mov    0x4(%eax),%edx
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	8b 75 14             	mov    0x14(%ebp),%esi
  800641:	8d 4e 08             	lea    0x8(%esi),%ecx
  800644:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800647:	eb 2c                	jmp    800675 <vprintfmt+0x331>
	else if (lflag)
  800649:	85 c9                	test   %ecx,%ecx
  80064b:	74 15                	je     800662 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	ba 00 00 00 00       	mov    $0x0,%edx
  800657:	8b 75 14             	mov    0x14(%ebp),%esi
  80065a:	8d 76 04             	lea    0x4(%esi),%esi
  80065d:	89 75 14             	mov    %esi,0x14(%ebp)
  800660:	eb 13                	jmp    800675 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	ba 00 00 00 00       	mov    $0x0,%edx
  80066c:	8b 75 14             	mov    0x14(%ebp),%esi
  80066f:	8d 76 04             	lea    0x4(%esi),%esi
  800672:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800675:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80067a:	e9 c6 00 00 00       	jmp    800745 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80067f:	83 f9 01             	cmp    $0x1,%ecx
  800682:	7e 13                	jle    800697 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 50 04             	mov    0x4(%eax),%edx
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8b 75 14             	mov    0x14(%ebp),%esi
  80068f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800692:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800695:	eb 24                	jmp    8006bb <vprintfmt+0x377>
	else if (lflag)
  800697:	85 c9                	test   %ecx,%ecx
  800699:	74 11                	je     8006ac <vprintfmt+0x368>
		return va_arg(*ap, long);
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	99                   	cltd   
  8006a1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8006a4:	8d 71 04             	lea    0x4(%ecx),%esi
  8006a7:	89 75 14             	mov    %esi,0x14(%ebp)
  8006aa:	eb 0f                	jmp    8006bb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	99                   	cltd   
  8006b2:	8b 75 14             	mov    0x14(%ebp),%esi
  8006b5:	8d 76 04             	lea    0x4(%esi),%esi
  8006b8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  8006bb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006c0:	e9 80 00 00 00       	jmp    800745 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  8006c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006cf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006d6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006e7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006ea:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006ee:	8b 06                	mov    (%esi),%eax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006f5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006fa:	eb 49                	jmp    800745 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006fc:	83 f9 01             	cmp    $0x1,%ecx
  8006ff:	7e 13                	jle    800714 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8b 50 04             	mov    0x4(%eax),%edx
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8b 75 14             	mov    0x14(%ebp),%esi
  80070c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80070f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800712:	eb 2c                	jmp    800740 <vprintfmt+0x3fc>
	else if (lflag)
  800714:	85 c9                	test   %ecx,%ecx
  800716:	74 15                	je     80072d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	ba 00 00 00 00       	mov    $0x0,%edx
  800722:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800725:	8d 71 04             	lea    0x4(%ecx),%esi
  800728:	89 75 14             	mov    %esi,0x14(%ebp)
  80072b:	eb 13                	jmp    800740 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	ba 00 00 00 00       	mov    $0x0,%edx
  800737:	8b 75 14             	mov    0x14(%ebp),%esi
  80073a:	8d 76 04             	lea    0x4(%esi),%esi
  80073d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800740:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800745:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800749:	89 74 24 10          	mov    %esi,0x10(%esp)
  80074d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800750:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800754:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800758:	89 04 24             	mov    %eax,(%esp)
  80075b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80075f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	e8 a6 fa ff ff       	call   800210 <printnum>
			break;
  80076a:	e9 fa fb ff ff       	jmp    800369 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80076f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800772:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800776:	89 04 24             	mov    %eax,(%esp)
  800779:	ff 55 08             	call   *0x8(%ebp)
			break;
  80077c:	e9 e8 fb ff ff       	jmp    800369 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800781:	8b 45 0c             	mov    0xc(%ebp),%eax
  800784:	89 44 24 04          	mov    %eax,0x4(%esp)
  800788:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80078f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800792:	89 fb                	mov    %edi,%ebx
  800794:	eb 03                	jmp    800799 <vprintfmt+0x455>
  800796:	83 eb 01             	sub    $0x1,%ebx
  800799:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80079d:	75 f7                	jne    800796 <vprintfmt+0x452>
  80079f:	90                   	nop
  8007a0:	e9 c4 fb ff ff       	jmp    800369 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007a5:	83 c4 3c             	add    $0x3c,%esp
  8007a8:	5b                   	pop    %ebx
  8007a9:	5e                   	pop    %esi
  8007aa:	5f                   	pop    %edi
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 28             	sub    $0x28,%esp
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007bc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ca:	85 c0                	test   %eax,%eax
  8007cc:	74 30                	je     8007fe <vsnprintf+0x51>
  8007ce:	85 d2                	test   %edx,%edx
  8007d0:	7e 2c                	jle    8007fe <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e7:	c7 04 24 ff 02 80 00 	movl   $0x8002ff,(%esp)
  8007ee:	e8 51 fb ff ff       	call   800344 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007fc:	eb 05                	jmp    800803 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800803:	c9                   	leave  
  800804:	c3                   	ret    

00800805 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80080b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80080e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800812:	8b 45 10             	mov    0x10(%ebp),%eax
  800815:	89 44 24 08          	mov    %eax,0x8(%esp)
  800819:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	89 04 24             	mov    %eax,(%esp)
  800826:	e8 82 ff ff ff       	call   8007ad <vsnprintf>
	va_end(ap);

	return rc;
}
  80082b:	c9                   	leave  
  80082c:	c3                   	ret    
  80082d:	66 90                	xchg   %ax,%ax
  80082f:	90                   	nop

00800830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800836:	b8 00 00 00 00       	mov    $0x0,%eax
  80083b:	eb 03                	jmp    800840 <strlen+0x10>
		n++;
  80083d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800840:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800844:	75 f7                	jne    80083d <strlen+0xd>
		n++;
	return n;
}
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800851:	b8 00 00 00 00       	mov    $0x0,%eax
  800856:	eb 03                	jmp    80085b <strnlen+0x13>
		n++;
  800858:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085b:	39 d0                	cmp    %edx,%eax
  80085d:	74 06                	je     800865 <strnlen+0x1d>
  80085f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800863:	75 f3                	jne    800858 <strnlen+0x10>
		n++;
	return n;
}
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800871:	89 c2                	mov    %eax,%edx
  800873:	83 c2 01             	add    $0x1,%edx
  800876:	83 c1 01             	add    $0x1,%ecx
  800879:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80087d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800880:	84 db                	test   %bl,%bl
  800882:	75 ef                	jne    800873 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800884:	5b                   	pop    %ebx
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	53                   	push   %ebx
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800891:	89 1c 24             	mov    %ebx,(%esp)
  800894:	e8 97 ff ff ff       	call   800830 <strlen>
	strcpy(dst + len, src);
  800899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008a0:	01 d8                	add    %ebx,%eax
  8008a2:	89 04 24             	mov    %eax,(%esp)
  8008a5:	e8 bd ff ff ff       	call   800867 <strcpy>
	return dst;
}
  8008aa:	89 d8                	mov    %ebx,%eax
  8008ac:	83 c4 08             	add    $0x8,%esp
  8008af:	5b                   	pop    %ebx
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	56                   	push   %esi
  8008b6:	53                   	push   %ebx
  8008b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008bd:	89 f3                	mov    %esi,%ebx
  8008bf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c2:	89 f2                	mov    %esi,%edx
  8008c4:	eb 0f                	jmp    8008d5 <strncpy+0x23>
		*dst++ = *src;
  8008c6:	83 c2 01             	add    $0x1,%edx
  8008c9:	0f b6 01             	movzbl (%ecx),%eax
  8008cc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008cf:	80 39 01             	cmpb   $0x1,(%ecx)
  8008d2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d5:	39 da                	cmp    %ebx,%edx
  8008d7:	75 ed                	jne    8008c6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008d9:	89 f0                	mov    %esi,%eax
  8008db:	5b                   	pop    %ebx
  8008dc:	5e                   	pop    %esi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	56                   	push   %esi
  8008e3:	53                   	push   %ebx
  8008e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008ed:	89 f0                	mov    %esi,%eax
  8008ef:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f3:	85 c9                	test   %ecx,%ecx
  8008f5:	75 0b                	jne    800902 <strlcpy+0x23>
  8008f7:	eb 1d                	jmp    800916 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	83 c2 01             	add    $0x1,%edx
  8008ff:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800902:	39 d8                	cmp    %ebx,%eax
  800904:	74 0b                	je     800911 <strlcpy+0x32>
  800906:	0f b6 0a             	movzbl (%edx),%ecx
  800909:	84 c9                	test   %cl,%cl
  80090b:	75 ec                	jne    8008f9 <strlcpy+0x1a>
  80090d:	89 c2                	mov    %eax,%edx
  80090f:	eb 02                	jmp    800913 <strlcpy+0x34>
  800911:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800913:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800916:	29 f0                	sub    %esi,%eax
}
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800922:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800925:	eb 06                	jmp    80092d <strcmp+0x11>
		p++, q++;
  800927:	83 c1 01             	add    $0x1,%ecx
  80092a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80092d:	0f b6 01             	movzbl (%ecx),%eax
  800930:	84 c0                	test   %al,%al
  800932:	74 04                	je     800938 <strcmp+0x1c>
  800934:	3a 02                	cmp    (%edx),%al
  800936:	74 ef                	je     800927 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	0f b6 12             	movzbl (%edx),%edx
  80093e:	29 d0                	sub    %edx,%eax
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 c3                	mov    %eax,%ebx
  80094e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800951:	eb 06                	jmp    800959 <strncmp+0x17>
		n--, p++, q++;
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800959:	39 d8                	cmp    %ebx,%eax
  80095b:	74 15                	je     800972 <strncmp+0x30>
  80095d:	0f b6 08             	movzbl (%eax),%ecx
  800960:	84 c9                	test   %cl,%cl
  800962:	74 04                	je     800968 <strncmp+0x26>
  800964:	3a 0a                	cmp    (%edx),%cl
  800966:	74 eb                	je     800953 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 00             	movzbl (%eax),%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
  800970:	eb 05                	jmp    800977 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800972:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800977:	5b                   	pop    %ebx
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800984:	eb 07                	jmp    80098d <strchr+0x13>
		if (*s == c)
  800986:	38 ca                	cmp    %cl,%dl
  800988:	74 0f                	je     800999 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	0f b6 10             	movzbl (%eax),%edx
  800990:	84 d2                	test   %dl,%dl
  800992:	75 f2                	jne    800986 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a5:	eb 07                	jmp    8009ae <strfind+0x13>
		if (*s == c)
  8009a7:	38 ca                	cmp    %cl,%dl
  8009a9:	74 0a                	je     8009b5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009ab:	83 c0 01             	add    $0x1,%eax
  8009ae:	0f b6 10             	movzbl (%eax),%edx
  8009b1:	84 d2                	test   %dl,%dl
  8009b3:	75 f2                	jne    8009a7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	57                   	push   %edi
  8009bb:	56                   	push   %esi
  8009bc:	53                   	push   %ebx
  8009bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c3:	85 c9                	test   %ecx,%ecx
  8009c5:	74 36                	je     8009fd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009c7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009cd:	75 28                	jne    8009f7 <memset+0x40>
  8009cf:	f6 c1 03             	test   $0x3,%cl
  8009d2:	75 23                	jne    8009f7 <memset+0x40>
		c &= 0xFF;
  8009d4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d8:	89 d3                	mov    %edx,%ebx
  8009da:	c1 e3 08             	shl    $0x8,%ebx
  8009dd:	89 d6                	mov    %edx,%esi
  8009df:	c1 e6 18             	shl    $0x18,%esi
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	c1 e0 10             	shl    $0x10,%eax
  8009e7:	09 f0                	or     %esi,%eax
  8009e9:	09 c2                	or     %eax,%edx
  8009eb:	89 d0                	mov    %edx,%eax
  8009ed:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ef:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009f2:	fc                   	cld    
  8009f3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f5:	eb 06                	jmp    8009fd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fa:	fc                   	cld    
  8009fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fd:	89 f8                	mov    %edi,%eax
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5f                   	pop    %edi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	57                   	push   %edi
  800a08:	56                   	push   %esi
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a12:	39 c6                	cmp    %eax,%esi
  800a14:	73 35                	jae    800a4b <memmove+0x47>
  800a16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a19:	39 d0                	cmp    %edx,%eax
  800a1b:	73 2e                	jae    800a4b <memmove+0x47>
		s += n;
		d += n;
  800a1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a20:	89 d6                	mov    %edx,%esi
  800a22:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2a:	75 13                	jne    800a3f <memmove+0x3b>
  800a2c:	f6 c1 03             	test   $0x3,%cl
  800a2f:	75 0e                	jne    800a3f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a31:	83 ef 04             	sub    $0x4,%edi
  800a34:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a37:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a3a:	fd                   	std    
  800a3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3d:	eb 09                	jmp    800a48 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3f:	83 ef 01             	sub    $0x1,%edi
  800a42:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a45:	fd                   	std    
  800a46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a48:	fc                   	cld    
  800a49:	eb 1d                	jmp    800a68 <memmove+0x64>
  800a4b:	89 f2                	mov    %esi,%edx
  800a4d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4f:	f6 c2 03             	test   $0x3,%dl
  800a52:	75 0f                	jne    800a63 <memmove+0x5f>
  800a54:	f6 c1 03             	test   $0x3,%cl
  800a57:	75 0a                	jne    800a63 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a59:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a5c:	89 c7                	mov    %eax,%edi
  800a5e:	fc                   	cld    
  800a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a61:	eb 05                	jmp    800a68 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a63:	89 c7                	mov    %eax,%edi
  800a65:	fc                   	cld    
  800a66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a68:	5e                   	pop    %esi
  800a69:	5f                   	pop    %edi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a72:	8b 45 10             	mov    0x10(%ebp),%eax
  800a75:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 04 24             	mov    %eax,(%esp)
  800a86:	e8 79 ff ff ff       	call   800a04 <memmove>
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	56                   	push   %esi
  800a91:	53                   	push   %ebx
  800a92:	8b 55 08             	mov    0x8(%ebp),%edx
  800a95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a98:	89 d6                	mov    %edx,%esi
  800a9a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9d:	eb 1a                	jmp    800ab9 <memcmp+0x2c>
		if (*s1 != *s2)
  800a9f:	0f b6 02             	movzbl (%edx),%eax
  800aa2:	0f b6 19             	movzbl (%ecx),%ebx
  800aa5:	38 d8                	cmp    %bl,%al
  800aa7:	74 0a                	je     800ab3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800aa9:	0f b6 c0             	movzbl %al,%eax
  800aac:	0f b6 db             	movzbl %bl,%ebx
  800aaf:	29 d8                	sub    %ebx,%eax
  800ab1:	eb 0f                	jmp    800ac2 <memcmp+0x35>
		s1++, s2++;
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ab9:	39 f2                	cmp    %esi,%edx
  800abb:	75 e2                	jne    800a9f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800abd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac2:	5b                   	pop    %ebx
  800ac3:	5e                   	pop    %esi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad4:	eb 07                	jmp    800add <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad6:	38 08                	cmp    %cl,(%eax)
  800ad8:	74 07                	je     800ae1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	39 d0                	cmp    %edx,%eax
  800adf:	72 f5                	jb     800ad6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	57                   	push   %edi
  800ae7:	56                   	push   %esi
  800ae8:	53                   	push   %ebx
  800ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aec:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aef:	eb 03                	jmp    800af4 <strtol+0x11>
		s++;
  800af1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af4:	0f b6 0a             	movzbl (%edx),%ecx
  800af7:	80 f9 09             	cmp    $0x9,%cl
  800afa:	74 f5                	je     800af1 <strtol+0xe>
  800afc:	80 f9 20             	cmp    $0x20,%cl
  800aff:	74 f0                	je     800af1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b01:	80 f9 2b             	cmp    $0x2b,%cl
  800b04:	75 0a                	jne    800b10 <strtol+0x2d>
		s++;
  800b06:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b09:	bf 00 00 00 00       	mov    $0x0,%edi
  800b0e:	eb 11                	jmp    800b21 <strtol+0x3e>
  800b10:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b15:	80 f9 2d             	cmp    $0x2d,%cl
  800b18:	75 07                	jne    800b21 <strtol+0x3e>
		s++, neg = 1;
  800b1a:	8d 52 01             	lea    0x1(%edx),%edx
  800b1d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b21:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b26:	75 15                	jne    800b3d <strtol+0x5a>
  800b28:	80 3a 30             	cmpb   $0x30,(%edx)
  800b2b:	75 10                	jne    800b3d <strtol+0x5a>
  800b2d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b31:	75 0a                	jne    800b3d <strtol+0x5a>
		s += 2, base = 16;
  800b33:	83 c2 02             	add    $0x2,%edx
  800b36:	b8 10 00 00 00       	mov    $0x10,%eax
  800b3b:	eb 10                	jmp    800b4d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b3d:	85 c0                	test   %eax,%eax
  800b3f:	75 0c                	jne    800b4d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b41:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b43:	80 3a 30             	cmpb   $0x30,(%edx)
  800b46:	75 05                	jne    800b4d <strtol+0x6a>
		s++, base = 8;
  800b48:	83 c2 01             	add    $0x1,%edx
  800b4b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b52:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b55:	0f b6 0a             	movzbl (%edx),%ecx
  800b58:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b5b:	89 f0                	mov    %esi,%eax
  800b5d:	3c 09                	cmp    $0x9,%al
  800b5f:	77 08                	ja     800b69 <strtol+0x86>
			dig = *s - '0';
  800b61:	0f be c9             	movsbl %cl,%ecx
  800b64:	83 e9 30             	sub    $0x30,%ecx
  800b67:	eb 20                	jmp    800b89 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b69:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b6c:	89 f0                	mov    %esi,%eax
  800b6e:	3c 19                	cmp    $0x19,%al
  800b70:	77 08                	ja     800b7a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b72:	0f be c9             	movsbl %cl,%ecx
  800b75:	83 e9 57             	sub    $0x57,%ecx
  800b78:	eb 0f                	jmp    800b89 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b7a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	3c 19                	cmp    $0x19,%al
  800b81:	77 16                	ja     800b99 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b83:	0f be c9             	movsbl %cl,%ecx
  800b86:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b89:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b8c:	7d 0f                	jge    800b9d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b8e:	83 c2 01             	add    $0x1,%edx
  800b91:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b95:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b97:	eb bc                	jmp    800b55 <strtol+0x72>
  800b99:	89 d8                	mov    %ebx,%eax
  800b9b:	eb 02                	jmp    800b9f <strtol+0xbc>
  800b9d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba3:	74 05                	je     800baa <strtol+0xc7>
		*endptr = (char *) s;
  800ba5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800baa:	f7 d8                	neg    %eax
  800bac:	85 ff                	test   %edi,%edi
  800bae:	0f 44 c3             	cmove  %ebx,%eax
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc7:	89 c3                	mov    %eax,%ebx
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bda:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdf:	b8 01 00 00 00       	mov    $0x1,%eax
  800be4:	89 d1                	mov    %edx,%ecx
  800be6:	89 d3                	mov    %edx,%ebx
  800be8:	89 d7                	mov    %edx,%edi
  800bea:	89 d6                	mov    %edx,%esi
  800bec:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c01:	b8 03 00 00 00       	mov    $0x3,%eax
  800c06:	8b 55 08             	mov    0x8(%ebp),%edx
  800c09:	89 cb                	mov    %ecx,%ebx
  800c0b:	89 cf                	mov    %ecx,%edi
  800c0d:	89 ce                	mov    %ecx,%esi
  800c0f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c11:	85 c0                	test   %eax,%eax
  800c13:	7e 28                	jle    800c3d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c15:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c19:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c20:	00 
  800c21:	c7 44 24 08 57 31 80 	movl   $0x803157,0x8(%esp)
  800c28:	00 
  800c29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c30:	00 
  800c31:	c7 04 24 74 31 80 00 	movl   $0x803174,(%esp)
  800c38:	e8 b7 f4 ff ff       	call   8000f4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c3d:	83 c4 2c             	add    $0x2c,%esp
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
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
  800c4e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c53:	b8 04 00 00 00       	mov    $0x4,%eax
  800c58:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5b:	89 cb                	mov    %ecx,%ebx
  800c5d:	89 cf                	mov    %ecx,%edi
  800c5f:	89 ce                	mov    %ecx,%esi
  800c61:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c63:	85 c0                	test   %eax,%eax
  800c65:	7e 28                	jle    800c8f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c67:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c6b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c72:	00 
  800c73:	c7 44 24 08 57 31 80 	movl   $0x803157,0x8(%esp)
  800c7a:	00 
  800c7b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c82:	00 
  800c83:	c7 04 24 74 31 80 00 	movl   $0x803174,(%esp)
  800c8a:	e8 65 f4 ff ff       	call   8000f4 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800c8f:	83 c4 2c             	add    $0x2c,%esp
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	57                   	push   %edi
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca2:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca7:	89 d1                	mov    %edx,%ecx
  800ca9:	89 d3                	mov    %edx,%ebx
  800cab:	89 d7                	mov    %edx,%edi
  800cad:	89 d6                	mov    %edx,%esi
  800caf:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <sys_yield>:

void
sys_yield(void)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	57                   	push   %edi
  800cba:	56                   	push   %esi
  800cbb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cc6:	89 d1                	mov    %edx,%ecx
  800cc8:	89 d3                	mov    %edx,%ebx
  800cca:	89 d7                	mov    %edx,%edi
  800ccc:	89 d6                	mov    %edx,%esi
  800cce:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	57                   	push   %edi
  800cd9:	56                   	push   %esi
  800cda:	53                   	push   %ebx
  800cdb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cde:	be 00 00 00 00       	mov    $0x0,%esi
  800ce3:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf1:	89 f7                	mov    %esi,%edi
  800cf3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cf5:	85 c0                	test   %eax,%eax
  800cf7:	7e 28                	jle    800d21 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cfd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d04:	00 
  800d05:	c7 44 24 08 57 31 80 	movl   $0x803157,0x8(%esp)
  800d0c:	00 
  800d0d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d14:	00 
  800d15:	c7 04 24 74 31 80 00 	movl   $0x803174,(%esp)
  800d1c:	e8 d3 f3 ff ff       	call   8000f4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d21:	83 c4 2c             	add    $0x2c,%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d32:	b8 06 00 00 00       	mov    $0x6,%eax
  800d37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d40:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d43:	8b 75 18             	mov    0x18(%ebp),%esi
  800d46:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	7e 28                	jle    800d74 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d50:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d57:	00 
  800d58:	c7 44 24 08 57 31 80 	movl   $0x803157,0x8(%esp)
  800d5f:	00 
  800d60:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d67:	00 
  800d68:	c7 04 24 74 31 80 00 	movl   $0x803174,(%esp)
  800d6f:	e8 80 f3 ff ff       	call   8000f4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d74:	83 c4 2c             	add    $0x2c,%esp
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	57                   	push   %edi
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
  800d82:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8a:	b8 07 00 00 00       	mov    $0x7,%eax
  800d8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d92:	8b 55 08             	mov    0x8(%ebp),%edx
  800d95:	89 df                	mov    %ebx,%edi
  800d97:	89 de                	mov    %ebx,%esi
  800d99:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d9b:	85 c0                	test   %eax,%eax
  800d9d:	7e 28                	jle    800dc7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800daa:	00 
  800dab:	c7 44 24 08 57 31 80 	movl   $0x803157,0x8(%esp)
  800db2:	00 
  800db3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dba:	00 
  800dbb:	c7 04 24 74 31 80 00 	movl   $0x803174,(%esp)
  800dc2:	e8 2d f3 ff ff       	call   8000f4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dc7:	83 c4 2c             	add    $0x2c,%esp
  800dca:	5b                   	pop    %ebx
  800dcb:	5e                   	pop    %esi
  800dcc:	5f                   	pop    %edi
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    

00800dcf <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	57                   	push   %edi
  800dd3:	56                   	push   %esi
  800dd4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dda:	b8 10 00 00 00       	mov    $0x10,%eax
  800ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  800de2:	89 cb                	mov    %ecx,%ebx
  800de4:	89 cf                	mov    %ecx,%edi
  800de6:	89 ce                	mov    %ecx,%esi
  800de8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800dea:	5b                   	pop    %ebx
  800deb:	5e                   	pop    %esi
  800dec:	5f                   	pop    %edi
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    

00800def <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfd:	b8 09 00 00 00       	mov    $0x9,%eax
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	89 df                	mov    %ebx,%edi
  800e0a:	89 de                	mov    %ebx,%esi
  800e0c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7e 28                	jle    800e3a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e12:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e16:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e1d:	00 
  800e1e:	c7 44 24 08 57 31 80 	movl   $0x803157,0x8(%esp)
  800e25:	00 
  800e26:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2d:	00 
  800e2e:	c7 04 24 74 31 80 00 	movl   $0x803174,(%esp)
  800e35:	e8 ba f2 ff ff       	call   8000f4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e3a:	83 c4 2c             	add    $0x2c,%esp
  800e3d:	5b                   	pop    %ebx
  800e3e:	5e                   	pop    %esi
  800e3f:	5f                   	pop    %edi
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    

00800e42 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e50:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e58:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5b:	89 df                	mov    %ebx,%edi
  800e5d:	89 de                	mov    %ebx,%esi
  800e5f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e61:	85 c0                	test   %eax,%eax
  800e63:	7e 28                	jle    800e8d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e65:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e69:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e70:	00 
  800e71:	c7 44 24 08 57 31 80 	movl   $0x803157,0x8(%esp)
  800e78:	00 
  800e79:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e80:	00 
  800e81:	c7 04 24 74 31 80 00 	movl   $0x803174,(%esp)
  800e88:	e8 67 f2 ff ff       	call   8000f4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e8d:	83 c4 2c             	add    $0x2c,%esp
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	57                   	push   %edi
  800e99:	56                   	push   %esi
  800e9a:	53                   	push   %ebx
  800e9b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	89 df                	mov    %ebx,%edi
  800eb0:	89 de                	mov    %ebx,%esi
  800eb2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb4:	85 c0                	test   %eax,%eax
  800eb6:	7e 28                	jle    800ee0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ebc:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800ec3:	00 
  800ec4:	c7 44 24 08 57 31 80 	movl   $0x803157,0x8(%esp)
  800ecb:	00 
  800ecc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed3:	00 
  800ed4:	c7 04 24 74 31 80 00 	movl   $0x803174,(%esp)
  800edb:	e8 14 f2 ff ff       	call   8000f4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ee0:	83 c4 2c             	add    $0x2c,%esp
  800ee3:	5b                   	pop    %ebx
  800ee4:	5e                   	pop    %esi
  800ee5:	5f                   	pop    %edi
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	57                   	push   %edi
  800eec:	56                   	push   %esi
  800eed:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eee:	be 00 00 00 00       	mov    $0x0,%esi
  800ef3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ef8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efb:	8b 55 08             	mov    0x8(%ebp),%edx
  800efe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f01:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f04:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5f                   	pop    %edi
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	57                   	push   %edi
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
  800f11:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f19:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	89 cb                	mov    %ecx,%ebx
  800f23:	89 cf                	mov    %ecx,%edi
  800f25:	89 ce                	mov    %ecx,%esi
  800f27:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	7e 28                	jle    800f55 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f31:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800f38:	00 
  800f39:	c7 44 24 08 57 31 80 	movl   $0x803157,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 74 31 80 00 	movl   $0x803174,(%esp)
  800f50:	e8 9f f1 ff ff       	call   8000f4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f55:	83 c4 2c             	add    $0x2c,%esp
  800f58:	5b                   	pop    %ebx
  800f59:	5e                   	pop    %esi
  800f5a:	5f                   	pop    %edi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	57                   	push   %edi
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f63:	ba 00 00 00 00       	mov    $0x0,%edx
  800f68:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f6d:	89 d1                	mov    %edx,%ecx
  800f6f:	89 d3                	mov    %edx,%ebx
  800f71:	89 d7                	mov    %edx,%edi
  800f73:	89 d6                	mov    %edx,%esi
  800f75:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f87:	b8 11 00 00 00       	mov    $0x11,%eax
  800f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f92:	89 df                	mov    %ebx,%edi
  800f94:	89 de                	mov    %ebx,%esi
  800f96:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800f98:	5b                   	pop    %ebx
  800f99:	5e                   	pop    %esi
  800f9a:	5f                   	pop    %edi
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	57                   	push   %edi
  800fa1:	56                   	push   %esi
  800fa2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa8:	b8 12 00 00 00       	mov    $0x12,%eax
  800fad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	89 df                	mov    %ebx,%edi
  800fb5:	89 de                	mov    %ebx,%esi
  800fb7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	57                   	push   %edi
  800fc2:	56                   	push   %esi
  800fc3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc9:	b8 13 00 00 00       	mov    $0x13,%eax
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	89 cb                	mov    %ecx,%ebx
  800fd3:	89 cf                	mov    %ecx,%edi
  800fd5:	89 ce                	mov    %ecx,%esi
  800fd7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  800fd9:	5b                   	pop    %ebx
  800fda:	5e                   	pop    %esi
  800fdb:	5f                   	pop    %edi
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    
  800fde:	66 90                	xchg   %ax,%ax

00800fe0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	05 00 00 00 30       	add    $0x30000000,%eax
  800feb:	c1 e8 0c             	shr    $0xc,%eax
}
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800ffb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801000:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801012:	89 c2                	mov    %eax,%edx
  801014:	c1 ea 16             	shr    $0x16,%edx
  801017:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80101e:	f6 c2 01             	test   $0x1,%dl
  801021:	74 11                	je     801034 <fd_alloc+0x2d>
  801023:	89 c2                	mov    %eax,%edx
  801025:	c1 ea 0c             	shr    $0xc,%edx
  801028:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80102f:	f6 c2 01             	test   $0x1,%dl
  801032:	75 09                	jne    80103d <fd_alloc+0x36>
			*fd_store = fd;
  801034:	89 01                	mov    %eax,(%ecx)
			return 0;
  801036:	b8 00 00 00 00       	mov    $0x0,%eax
  80103b:	eb 17                	jmp    801054 <fd_alloc+0x4d>
  80103d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801042:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801047:	75 c9                	jne    801012 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801049:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80104f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    

00801056 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80105c:	83 f8 1f             	cmp    $0x1f,%eax
  80105f:	77 36                	ja     801097 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801061:	c1 e0 0c             	shl    $0xc,%eax
  801064:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801069:	89 c2                	mov    %eax,%edx
  80106b:	c1 ea 16             	shr    $0x16,%edx
  80106e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801075:	f6 c2 01             	test   $0x1,%dl
  801078:	74 24                	je     80109e <fd_lookup+0x48>
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	c1 ea 0c             	shr    $0xc,%edx
  80107f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801086:	f6 c2 01             	test   $0x1,%dl
  801089:	74 1a                	je     8010a5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80108b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108e:	89 02                	mov    %eax,(%edx)
	return 0;
  801090:	b8 00 00 00 00       	mov    $0x0,%eax
  801095:	eb 13                	jmp    8010aa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801097:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109c:	eb 0c                	jmp    8010aa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80109e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a3:	eb 05                	jmp    8010aa <fd_lookup+0x54>
  8010a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8010aa:	5d                   	pop    %ebp
  8010ab:	c3                   	ret    

008010ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	83 ec 18             	sub    $0x18,%esp
  8010b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ba:	eb 13                	jmp    8010cf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8010bc:	39 08                	cmp    %ecx,(%eax)
  8010be:	75 0c                	jne    8010cc <dev_lookup+0x20>
			*dev = devtab[i];
  8010c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ca:	eb 38                	jmp    801104 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010cc:	83 c2 01             	add    $0x1,%edx
  8010cf:	8b 04 95 00 32 80 00 	mov    0x803200(,%edx,4),%eax
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	75 e2                	jne    8010bc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010da:	a1 08 50 80 00       	mov    0x805008,%eax
  8010df:	8b 40 48             	mov    0x48(%eax),%eax
  8010e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010ea:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  8010f1:	e8 f7 f0 ff ff       	call   8001ed <cprintf>
	*dev = 0;
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
  80110b:	83 ec 20             	sub    $0x20,%esp
  80110e:	8b 75 08             	mov    0x8(%ebp),%esi
  801111:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801114:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801117:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80111b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801121:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801124:	89 04 24             	mov    %eax,(%esp)
  801127:	e8 2a ff ff ff       	call   801056 <fd_lookup>
  80112c:	85 c0                	test   %eax,%eax
  80112e:	78 05                	js     801135 <fd_close+0x2f>
	    || fd != fd2)
  801130:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801133:	74 0c                	je     801141 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801135:	84 db                	test   %bl,%bl
  801137:	ba 00 00 00 00       	mov    $0x0,%edx
  80113c:	0f 44 c2             	cmove  %edx,%eax
  80113f:	eb 3f                	jmp    801180 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801141:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801144:	89 44 24 04          	mov    %eax,0x4(%esp)
  801148:	8b 06                	mov    (%esi),%eax
  80114a:	89 04 24             	mov    %eax,(%esp)
  80114d:	e8 5a ff ff ff       	call   8010ac <dev_lookup>
  801152:	89 c3                	mov    %eax,%ebx
  801154:	85 c0                	test   %eax,%eax
  801156:	78 16                	js     80116e <fd_close+0x68>
		if (dev->dev_close)
  801158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80115b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80115e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801163:	85 c0                	test   %eax,%eax
  801165:	74 07                	je     80116e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801167:	89 34 24             	mov    %esi,(%esp)
  80116a:	ff d0                	call   *%eax
  80116c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80116e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801172:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801179:	e8 fe fb ff ff       	call   800d7c <sys_page_unmap>
	return r;
  80117e:	89 d8                	mov    %ebx,%eax
}
  801180:	83 c4 20             	add    $0x20,%esp
  801183:	5b                   	pop    %ebx
  801184:	5e                   	pop    %esi
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    

00801187 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80118d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801190:	89 44 24 04          	mov    %eax,0x4(%esp)
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	89 04 24             	mov    %eax,(%esp)
  80119a:	e8 b7 fe ff ff       	call   801056 <fd_lookup>
  80119f:	89 c2                	mov    %eax,%edx
  8011a1:	85 d2                	test   %edx,%edx
  8011a3:	78 13                	js     8011b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8011a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011ac:	00 
  8011ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b0:	89 04 24             	mov    %eax,(%esp)
  8011b3:	e8 4e ff ff ff       	call   801106 <fd_close>
}
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

008011ba <close_all>:

void
close_all(void)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	53                   	push   %ebx
  8011be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011c6:	89 1c 24             	mov    %ebx,(%esp)
  8011c9:	e8 b9 ff ff ff       	call   801187 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8011ce:	83 c3 01             	add    $0x1,%ebx
  8011d1:	83 fb 20             	cmp    $0x20,%ebx
  8011d4:	75 f0                	jne    8011c6 <close_all+0xc>
		close(i);
}
  8011d6:	83 c4 14             	add    $0x14,%esp
  8011d9:	5b                   	pop    %ebx
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    

008011dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	57                   	push   %edi
  8011e0:	56                   	push   %esi
  8011e1:	53                   	push   %ebx
  8011e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	89 04 24             	mov    %eax,(%esp)
  8011f2:	e8 5f fe ff ff       	call   801056 <fd_lookup>
  8011f7:	89 c2                	mov    %eax,%edx
  8011f9:	85 d2                	test   %edx,%edx
  8011fb:	0f 88 e1 00 00 00    	js     8012e2 <dup+0x106>
		return r;
	close(newfdnum);
  801201:	8b 45 0c             	mov    0xc(%ebp),%eax
  801204:	89 04 24             	mov    %eax,(%esp)
  801207:	e8 7b ff ff ff       	call   801187 <close>

	newfd = INDEX2FD(newfdnum);
  80120c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80120f:	c1 e3 0c             	shl    $0xc,%ebx
  801212:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801218:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80121b:	89 04 24             	mov    %eax,(%esp)
  80121e:	e8 cd fd ff ff       	call   800ff0 <fd2data>
  801223:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801225:	89 1c 24             	mov    %ebx,(%esp)
  801228:	e8 c3 fd ff ff       	call   800ff0 <fd2data>
  80122d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80122f:	89 f0                	mov    %esi,%eax
  801231:	c1 e8 16             	shr    $0x16,%eax
  801234:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80123b:	a8 01                	test   $0x1,%al
  80123d:	74 43                	je     801282 <dup+0xa6>
  80123f:	89 f0                	mov    %esi,%eax
  801241:	c1 e8 0c             	shr    $0xc,%eax
  801244:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80124b:	f6 c2 01             	test   $0x1,%dl
  80124e:	74 32                	je     801282 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801250:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801257:	25 07 0e 00 00       	and    $0xe07,%eax
  80125c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801260:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801264:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80126b:	00 
  80126c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801277:	e8 ad fa ff ff       	call   800d29 <sys_page_map>
  80127c:	89 c6                	mov    %eax,%esi
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 3e                	js     8012c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801285:	89 c2                	mov    %eax,%edx
  801287:	c1 ea 0c             	shr    $0xc,%edx
  80128a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801291:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801297:	89 54 24 10          	mov    %edx,0x10(%esp)
  80129b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80129f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012a6:	00 
  8012a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012b2:	e8 72 fa ff ff       	call   800d29 <sys_page_map>
  8012b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012bc:	85 f6                	test   %esi,%esi
  8012be:	79 22                	jns    8012e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8012c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012cb:	e8 ac fa ff ff       	call   800d7c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012db:	e8 9c fa ff ff       	call   800d7c <sys_page_unmap>
	return r;
  8012e0:	89 f0                	mov    %esi,%eax
}
  8012e2:	83 c4 3c             	add    $0x3c,%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 24             	sub    $0x24,%esp
  8012f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012fb:	89 1c 24             	mov    %ebx,(%esp)
  8012fe:	e8 53 fd ff ff       	call   801056 <fd_lookup>
  801303:	89 c2                	mov    %eax,%edx
  801305:	85 d2                	test   %edx,%edx
  801307:	78 6d                	js     801376 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801309:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801313:	8b 00                	mov    (%eax),%eax
  801315:	89 04 24             	mov    %eax,(%esp)
  801318:	e8 8f fd ff ff       	call   8010ac <dev_lookup>
  80131d:	85 c0                	test   %eax,%eax
  80131f:	78 55                	js     801376 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801324:	8b 50 08             	mov    0x8(%eax),%edx
  801327:	83 e2 03             	and    $0x3,%edx
  80132a:	83 fa 01             	cmp    $0x1,%edx
  80132d:	75 23                	jne    801352 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80132f:	a1 08 50 80 00       	mov    0x805008,%eax
  801334:	8b 40 48             	mov    0x48(%eax),%eax
  801337:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80133b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80133f:	c7 04 24 c5 31 80 00 	movl   $0x8031c5,(%esp)
  801346:	e8 a2 ee ff ff       	call   8001ed <cprintf>
		return -E_INVAL;
  80134b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801350:	eb 24                	jmp    801376 <read+0x8c>
	}
	if (!dev->dev_read)
  801352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801355:	8b 52 08             	mov    0x8(%edx),%edx
  801358:	85 d2                	test   %edx,%edx
  80135a:	74 15                	je     801371 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80135c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80135f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801363:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801366:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80136a:	89 04 24             	mov    %eax,(%esp)
  80136d:	ff d2                	call   *%edx
  80136f:	eb 05                	jmp    801376 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801371:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801376:	83 c4 24             	add    $0x24,%esp
  801379:	5b                   	pop    %ebx
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    

0080137c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	57                   	push   %edi
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
  801382:	83 ec 1c             	sub    $0x1c,%esp
  801385:	8b 7d 08             	mov    0x8(%ebp),%edi
  801388:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80138b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801390:	eb 23                	jmp    8013b5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801392:	89 f0                	mov    %esi,%eax
  801394:	29 d8                	sub    %ebx,%eax
  801396:	89 44 24 08          	mov    %eax,0x8(%esp)
  80139a:	89 d8                	mov    %ebx,%eax
  80139c:	03 45 0c             	add    0xc(%ebp),%eax
  80139f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a3:	89 3c 24             	mov    %edi,(%esp)
  8013a6:	e8 3f ff ff ff       	call   8012ea <read>
		if (m < 0)
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	78 10                	js     8013bf <readn+0x43>
			return m;
		if (m == 0)
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	74 0a                	je     8013bd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013b3:	01 c3                	add    %eax,%ebx
  8013b5:	39 f3                	cmp    %esi,%ebx
  8013b7:	72 d9                	jb     801392 <readn+0x16>
  8013b9:	89 d8                	mov    %ebx,%eax
  8013bb:	eb 02                	jmp    8013bf <readn+0x43>
  8013bd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8013bf:	83 c4 1c             	add    $0x1c,%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5f                   	pop    %edi
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	53                   	push   %ebx
  8013cb:	83 ec 24             	sub    $0x24,%esp
  8013ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d8:	89 1c 24             	mov    %ebx,(%esp)
  8013db:	e8 76 fc ff ff       	call   801056 <fd_lookup>
  8013e0:	89 c2                	mov    %eax,%edx
  8013e2:	85 d2                	test   %edx,%edx
  8013e4:	78 68                	js     80144e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f0:	8b 00                	mov    (%eax),%eax
  8013f2:	89 04 24             	mov    %eax,(%esp)
  8013f5:	e8 b2 fc ff ff       	call   8010ac <dev_lookup>
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 50                	js     80144e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801401:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801405:	75 23                	jne    80142a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801407:	a1 08 50 80 00       	mov    0x805008,%eax
  80140c:	8b 40 48             	mov    0x48(%eax),%eax
  80140f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801413:	89 44 24 04          	mov    %eax,0x4(%esp)
  801417:	c7 04 24 e1 31 80 00 	movl   $0x8031e1,(%esp)
  80141e:	e8 ca ed ff ff       	call   8001ed <cprintf>
		return -E_INVAL;
  801423:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801428:	eb 24                	jmp    80144e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80142a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142d:	8b 52 0c             	mov    0xc(%edx),%edx
  801430:	85 d2                	test   %edx,%edx
  801432:	74 15                	je     801449 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801434:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801437:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80143b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801442:	89 04 24             	mov    %eax,(%esp)
  801445:	ff d2                	call   *%edx
  801447:	eb 05                	jmp    80144e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801449:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80144e:	83 c4 24             	add    $0x24,%esp
  801451:	5b                   	pop    %ebx
  801452:	5d                   	pop    %ebp
  801453:	c3                   	ret    

00801454 <seek>:

int
seek(int fdnum, off_t offset)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80145a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80145d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	89 04 24             	mov    %eax,(%esp)
  801467:	e8 ea fb ff ff       	call   801056 <fd_lookup>
  80146c:	85 c0                	test   %eax,%eax
  80146e:	78 0e                	js     80147e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801470:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801473:	8b 55 0c             	mov    0xc(%ebp),%edx
  801476:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801479:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	53                   	push   %ebx
  801484:	83 ec 24             	sub    $0x24,%esp
  801487:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801491:	89 1c 24             	mov    %ebx,(%esp)
  801494:	e8 bd fb ff ff       	call   801056 <fd_lookup>
  801499:	89 c2                	mov    %eax,%edx
  80149b:	85 d2                	test   %edx,%edx
  80149d:	78 61                	js     801500 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a9:	8b 00                	mov    (%eax),%eax
  8014ab:	89 04 24             	mov    %eax,(%esp)
  8014ae:	e8 f9 fb ff ff       	call   8010ac <dev_lookup>
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	78 49                	js     801500 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014be:	75 23                	jne    8014e3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014c0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014c5:	8b 40 48             	mov    0x48(%eax),%eax
  8014c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d0:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  8014d7:	e8 11 ed ff ff       	call   8001ed <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e1:	eb 1d                	jmp    801500 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8014e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e6:	8b 52 18             	mov    0x18(%edx),%edx
  8014e9:	85 d2                	test   %edx,%edx
  8014eb:	74 0e                	je     8014fb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014f4:	89 04 24             	mov    %eax,(%esp)
  8014f7:	ff d2                	call   *%edx
  8014f9:	eb 05                	jmp    801500 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8014fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801500:	83 c4 24             	add    $0x24,%esp
  801503:	5b                   	pop    %ebx
  801504:	5d                   	pop    %ebp
  801505:	c3                   	ret    

00801506 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	53                   	push   %ebx
  80150a:	83 ec 24             	sub    $0x24,%esp
  80150d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801510:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801513:	89 44 24 04          	mov    %eax,0x4(%esp)
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	89 04 24             	mov    %eax,(%esp)
  80151d:	e8 34 fb ff ff       	call   801056 <fd_lookup>
  801522:	89 c2                	mov    %eax,%edx
  801524:	85 d2                	test   %edx,%edx
  801526:	78 52                	js     80157a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801528:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801532:	8b 00                	mov    (%eax),%eax
  801534:	89 04 24             	mov    %eax,(%esp)
  801537:	e8 70 fb ff ff       	call   8010ac <dev_lookup>
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 3a                	js     80157a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801543:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801547:	74 2c                	je     801575 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801549:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80154c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801553:	00 00 00 
	stat->st_isdir = 0;
  801556:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80155d:	00 00 00 
	stat->st_dev = dev;
  801560:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801566:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80156a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156d:	89 14 24             	mov    %edx,(%esp)
  801570:	ff 50 14             	call   *0x14(%eax)
  801573:	eb 05                	jmp    80157a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801575:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80157a:	83 c4 24             	add    $0x24,%esp
  80157d:	5b                   	pop    %ebx
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    

00801580 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	56                   	push   %esi
  801584:	53                   	push   %ebx
  801585:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801588:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80158f:	00 
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	89 04 24             	mov    %eax,(%esp)
  801596:	e8 99 02 00 00       	call   801834 <open>
  80159b:	89 c3                	mov    %eax,%ebx
  80159d:	85 db                	test   %ebx,%ebx
  80159f:	78 1b                	js     8015bc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a8:	89 1c 24             	mov    %ebx,(%esp)
  8015ab:	e8 56 ff ff ff       	call   801506 <fstat>
  8015b0:	89 c6                	mov    %eax,%esi
	close(fd);
  8015b2:	89 1c 24             	mov    %ebx,(%esp)
  8015b5:	e8 cd fb ff ff       	call   801187 <close>
	return r;
  8015ba:	89 f0                	mov    %esi,%eax
}
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	5b                   	pop    %ebx
  8015c0:	5e                   	pop    %esi
  8015c1:	5d                   	pop    %ebp
  8015c2:	c3                   	ret    

008015c3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	56                   	push   %esi
  8015c7:	53                   	push   %ebx
  8015c8:	83 ec 10             	sub    $0x10,%esp
  8015cb:	89 c6                	mov    %eax,%esi
  8015cd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015cf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8015d6:	75 11                	jne    8015e9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015df:	e8 bb 14 00 00       	call   802a9f <ipc_find_env>
  8015e4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015e9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015f0:	00 
  8015f1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8015f8:	00 
  8015f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015fd:	a1 00 50 80 00       	mov    0x805000,%eax
  801602:	89 04 24             	mov    %eax,(%esp)
  801605:	e8 2e 14 00 00       	call   802a38 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80160a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801611:	00 
  801612:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801616:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80161d:	e8 ae 13 00 00       	call   8029d0 <ipc_recv>
}
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	5b                   	pop    %ebx
  801626:	5e                   	pop    %esi
  801627:	5d                   	pop    %ebp
  801628:	c3                   	ret    

00801629 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8b 40 0c             	mov    0xc(%eax),%eax
  801635:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801642:	ba 00 00 00 00       	mov    $0x0,%edx
  801647:	b8 02 00 00 00       	mov    $0x2,%eax
  80164c:	e8 72 ff ff ff       	call   8015c3 <fsipc>
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	8b 40 0c             	mov    0xc(%eax),%eax
  80165f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801664:	ba 00 00 00 00       	mov    $0x0,%edx
  801669:	b8 06 00 00 00       	mov    $0x6,%eax
  80166e:	e8 50 ff ff ff       	call   8015c3 <fsipc>
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	53                   	push   %ebx
  801679:	83 ec 14             	sub    $0x14,%esp
  80167c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8b 40 0c             	mov    0xc(%eax),%eax
  801685:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80168a:	ba 00 00 00 00       	mov    $0x0,%edx
  80168f:	b8 05 00 00 00       	mov    $0x5,%eax
  801694:	e8 2a ff ff ff       	call   8015c3 <fsipc>
  801699:	89 c2                	mov    %eax,%edx
  80169b:	85 d2                	test   %edx,%edx
  80169d:	78 2b                	js     8016ca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80169f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8016a6:	00 
  8016a7:	89 1c 24             	mov    %ebx,(%esp)
  8016aa:	e8 b8 f1 ff ff       	call   800867 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016af:	a1 80 60 80 00       	mov    0x806080,%eax
  8016b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016ba:	a1 84 60 80 00       	mov    0x806084,%eax
  8016bf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ca:	83 c4 14             	add    $0x14,%esp
  8016cd:	5b                   	pop    %ebx
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    

008016d0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	53                   	push   %ebx
  8016d4:	83 ec 14             	sub    $0x14,%esp
  8016d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  8016da:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  8016e0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8016e5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016eb:	8b 52 0c             	mov    0xc(%edx),%edx
  8016ee:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  8016f4:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  8016f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801700:	89 44 24 04          	mov    %eax,0x4(%esp)
  801704:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  80170b:	e8 f4 f2 ff ff       	call   800a04 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801710:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801717:	00 
  801718:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  80171f:	e8 c9 ea ff ff       	call   8001ed <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801724:	ba 00 00 00 00       	mov    $0x0,%edx
  801729:	b8 04 00 00 00       	mov    $0x4,%eax
  80172e:	e8 90 fe ff ff       	call   8015c3 <fsipc>
  801733:	85 c0                	test   %eax,%eax
  801735:	78 53                	js     80178a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801737:	39 c3                	cmp    %eax,%ebx
  801739:	73 24                	jae    80175f <devfile_write+0x8f>
  80173b:	c7 44 24 0c 19 32 80 	movl   $0x803219,0xc(%esp)
  801742:	00 
  801743:	c7 44 24 08 20 32 80 	movl   $0x803220,0x8(%esp)
  80174a:	00 
  80174b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801752:	00 
  801753:	c7 04 24 35 32 80 00 	movl   $0x803235,(%esp)
  80175a:	e8 95 e9 ff ff       	call   8000f4 <_panic>
	assert(r <= PGSIZE);
  80175f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801764:	7e 24                	jle    80178a <devfile_write+0xba>
  801766:	c7 44 24 0c 40 32 80 	movl   $0x803240,0xc(%esp)
  80176d:	00 
  80176e:	c7 44 24 08 20 32 80 	movl   $0x803220,0x8(%esp)
  801775:	00 
  801776:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  80177d:	00 
  80177e:	c7 04 24 35 32 80 00 	movl   $0x803235,(%esp)
  801785:	e8 6a e9 ff ff       	call   8000f4 <_panic>
	return r;
}
  80178a:	83 c4 14             	add    $0x14,%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    

00801790 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	56                   	push   %esi
  801794:	53                   	push   %ebx
  801795:	83 ec 10             	sub    $0x10,%esp
  801798:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8017a6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8017b6:	e8 08 fe ff ff       	call   8015c3 <fsipc>
  8017bb:	89 c3                	mov    %eax,%ebx
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	78 6a                	js     80182b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017c1:	39 c6                	cmp    %eax,%esi
  8017c3:	73 24                	jae    8017e9 <devfile_read+0x59>
  8017c5:	c7 44 24 0c 19 32 80 	movl   $0x803219,0xc(%esp)
  8017cc:	00 
  8017cd:	c7 44 24 08 20 32 80 	movl   $0x803220,0x8(%esp)
  8017d4:	00 
  8017d5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8017dc:	00 
  8017dd:	c7 04 24 35 32 80 00 	movl   $0x803235,(%esp)
  8017e4:	e8 0b e9 ff ff       	call   8000f4 <_panic>
	assert(r <= PGSIZE);
  8017e9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017ee:	7e 24                	jle    801814 <devfile_read+0x84>
  8017f0:	c7 44 24 0c 40 32 80 	movl   $0x803240,0xc(%esp)
  8017f7:	00 
  8017f8:	c7 44 24 08 20 32 80 	movl   $0x803220,0x8(%esp)
  8017ff:	00 
  801800:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801807:	00 
  801808:	c7 04 24 35 32 80 00 	movl   $0x803235,(%esp)
  80180f:	e8 e0 e8 ff ff       	call   8000f4 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801814:	89 44 24 08          	mov    %eax,0x8(%esp)
  801818:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80181f:	00 
  801820:	8b 45 0c             	mov    0xc(%ebp),%eax
  801823:	89 04 24             	mov    %eax,(%esp)
  801826:	e8 d9 f1 ff ff       	call   800a04 <memmove>
	return r;
}
  80182b:	89 d8                	mov    %ebx,%eax
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	5b                   	pop    %ebx
  801831:	5e                   	pop    %esi
  801832:	5d                   	pop    %ebp
  801833:	c3                   	ret    

00801834 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	53                   	push   %ebx
  801838:	83 ec 24             	sub    $0x24,%esp
  80183b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80183e:	89 1c 24             	mov    %ebx,(%esp)
  801841:	e8 ea ef ff ff       	call   800830 <strlen>
  801846:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80184b:	7f 60                	jg     8018ad <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80184d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801850:	89 04 24             	mov    %eax,(%esp)
  801853:	e8 af f7 ff ff       	call   801007 <fd_alloc>
  801858:	89 c2                	mov    %eax,%edx
  80185a:	85 d2                	test   %edx,%edx
  80185c:	78 54                	js     8018b2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80185e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801862:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801869:	e8 f9 ef ff ff       	call   800867 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80186e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801871:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801876:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801879:	b8 01 00 00 00       	mov    $0x1,%eax
  80187e:	e8 40 fd ff ff       	call   8015c3 <fsipc>
  801883:	89 c3                	mov    %eax,%ebx
  801885:	85 c0                	test   %eax,%eax
  801887:	79 17                	jns    8018a0 <open+0x6c>
		fd_close(fd, 0);
  801889:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801890:	00 
  801891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801894:	89 04 24             	mov    %eax,(%esp)
  801897:	e8 6a f8 ff ff       	call   801106 <fd_close>
		return r;
  80189c:	89 d8                	mov    %ebx,%eax
  80189e:	eb 12                	jmp    8018b2 <open+0x7e>
	}

	return fd2num(fd);
  8018a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a3:	89 04 24             	mov    %eax,(%esp)
  8018a6:	e8 35 f7 ff ff       	call   800fe0 <fd2num>
  8018ab:	eb 05                	jmp    8018b2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018ad:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8018b2:	83 c4 24             	add    $0x24,%esp
  8018b5:	5b                   	pop    %ebx
  8018b6:	5d                   	pop    %ebp
  8018b7:	c3                   	ret    

008018b8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018be:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c3:	b8 08 00 00 00       	mov    $0x8,%eax
  8018c8:	e8 f6 fc ff ff       	call   8015c3 <fsipc>
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <evict>:

int evict(void)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  8018d5:	c7 04 24 4c 32 80 00 	movl   $0x80324c,(%esp)
  8018dc:	e8 0c e9 ff ff       	call   8001ed <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  8018e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e6:	b8 09 00 00 00       	mov    $0x9,%eax
  8018eb:	e8 d3 fc ff ff       	call   8015c3 <fsipc>
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    
  8018f2:	66 90                	xchg   %ax,%ax
  8018f4:	66 90                	xchg   %ax,%ax
  8018f6:	66 90                	xchg   %ax,%ax
  8018f8:	66 90                	xchg   %ax,%ax
  8018fa:	66 90                	xchg   %ax,%ax
  8018fc:	66 90                	xchg   %ax,%ax
  8018fe:	66 90                	xchg   %ax,%ax

00801900 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	57                   	push   %edi
  801904:	56                   	push   %esi
  801905:	53                   	push   %ebx
  801906:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80190c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801913:	00 
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	89 04 24             	mov    %eax,(%esp)
  80191a:	e8 15 ff ff ff       	call   801834 <open>
  80191f:	89 c1                	mov    %eax,%ecx
  801921:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801927:	85 c0                	test   %eax,%eax
  801929:	0f 88 41 05 00 00    	js     801e70 <spawn+0x570>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80192f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801936:	00 
  801937:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80193d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801941:	89 0c 24             	mov    %ecx,(%esp)
  801944:	e8 33 fa ff ff       	call   80137c <readn>
  801949:	3d 00 02 00 00       	cmp    $0x200,%eax
  80194e:	75 0c                	jne    80195c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801950:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801957:	45 4c 46 
  80195a:	74 36                	je     801992 <spawn+0x92>
		close(fd);
  80195c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801962:	89 04 24             	mov    %eax,(%esp)
  801965:	e8 1d f8 ff ff       	call   801187 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80196a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801971:	46 
  801972:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801978:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197c:	c7 04 24 65 32 80 00 	movl   $0x803265,(%esp)
  801983:	e8 65 e8 ff ff       	call   8001ed <cprintf>
		return -E_NOT_EXEC;
  801988:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80198d:	e9 3d 05 00 00       	jmp    801ecf <spawn+0x5cf>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801992:	b8 08 00 00 00       	mov    $0x8,%eax
  801997:	cd 30                	int    $0x30
  801999:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80199f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8019a5:	85 c0                	test   %eax,%eax
  8019a7:	0f 88 cb 04 00 00    	js     801e78 <spawn+0x578>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8019ad:	89 c6                	mov    %eax,%esi
  8019af:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8019b5:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8019b8:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8019be:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8019c4:	b9 11 00 00 00       	mov    $0x11,%ecx
  8019c9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8019cb:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8019d1:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019d7:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8019dc:	be 00 00 00 00       	mov    $0x0,%esi
  8019e1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8019e4:	eb 0f                	jmp    8019f5 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  8019e6:	89 04 24             	mov    %eax,(%esp)
  8019e9:	e8 42 ee ff ff       	call   800830 <strlen>
  8019ee:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019f2:	83 c3 01             	add    $0x1,%ebx
  8019f5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8019fc:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	75 e3                	jne    8019e6 <spawn+0xe6>
  801a03:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801a09:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a0f:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a14:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a16:	89 fa                	mov    %edi,%edx
  801a18:	83 e2 fc             	and    $0xfffffffc,%edx
  801a1b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801a22:	29 c2                	sub    %eax,%edx
  801a24:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801a2a:	8d 42 f8             	lea    -0x8(%edx),%eax
  801a2d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a32:	0f 86 50 04 00 00    	jbe    801e88 <spawn+0x588>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a38:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a3f:	00 
  801a40:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a47:	00 
  801a48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a4f:	e8 81 f2 ff ff       	call   800cd5 <sys_page_alloc>
  801a54:	85 c0                	test   %eax,%eax
  801a56:	0f 88 73 04 00 00    	js     801ecf <spawn+0x5cf>
  801a5c:	be 00 00 00 00       	mov    $0x0,%esi
  801a61:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801a67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a6a:	eb 30                	jmp    801a9c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801a6c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a72:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801a78:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  801a7b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a82:	89 3c 24             	mov    %edi,(%esp)
  801a85:	e8 dd ed ff ff       	call   800867 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a8a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801a8d:	89 04 24             	mov    %eax,(%esp)
  801a90:	e8 9b ed ff ff       	call   800830 <strlen>
  801a95:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a99:	83 c6 01             	add    $0x1,%esi
  801a9c:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  801aa2:	7c c8                	jl     801a6c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801aa4:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801aaa:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801ab0:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ab7:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801abd:	74 24                	je     801ae3 <spawn+0x1e3>
  801abf:	c7 44 24 0c fc 32 80 	movl   $0x8032fc,0xc(%esp)
  801ac6:	00 
  801ac7:	c7 44 24 08 20 32 80 	movl   $0x803220,0x8(%esp)
  801ace:	00 
  801acf:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  801ad6:	00 
  801ad7:	c7 04 24 7f 32 80 00 	movl   $0x80327f,(%esp)
  801ade:	e8 11 e6 ff ff       	call   8000f4 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801ae3:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801ae9:	89 c8                	mov    %ecx,%eax
  801aeb:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801af0:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801af3:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801af9:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801afc:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801b02:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b08:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801b0f:	00 
  801b10:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801b17:	ee 
  801b18:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b22:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b29:	00 
  801b2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b31:	e8 f3 f1 ff ff       	call   800d29 <sys_page_map>
  801b36:	89 c3                	mov    %eax,%ebx
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	0f 88 79 03 00 00    	js     801eb9 <spawn+0x5b9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b40:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b47:	00 
  801b48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b4f:	e8 28 f2 ff ff       	call   800d7c <sys_page_unmap>
  801b54:	89 c3                	mov    %eax,%ebx
  801b56:	85 c0                	test   %eax,%eax
  801b58:	0f 88 5b 03 00 00    	js     801eb9 <spawn+0x5b9>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b5e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b64:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801b6b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b71:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801b78:	00 00 00 
  801b7b:	e9 b6 01 00 00       	jmp    801d36 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  801b80:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801b86:	83 38 01             	cmpl   $0x1,(%eax)
  801b89:	0f 85 99 01 00 00    	jne    801d28 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801b8f:	89 c2                	mov    %eax,%edx
  801b91:	8b 40 18             	mov    0x18(%eax),%eax
  801b94:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801b97:	83 f8 01             	cmp    $0x1,%eax
  801b9a:	19 c0                	sbb    %eax,%eax
  801b9c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801ba2:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  801ba9:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801bb0:	89 d0                	mov    %edx,%eax
  801bb2:	8b 4a 04             	mov    0x4(%edx),%ecx
  801bb5:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801bbb:	8b 52 10             	mov    0x10(%edx),%edx
  801bbe:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  801bc4:	8b 48 14             	mov    0x14(%eax),%ecx
  801bc7:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  801bcd:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801bd0:	89 f0                	mov    %esi,%eax
  801bd2:	25 ff 0f 00 00       	and    $0xfff,%eax
  801bd7:	74 14                	je     801bed <spawn+0x2ed>
		va -= i;
  801bd9:	29 c6                	sub    %eax,%esi
		memsz += i;
  801bdb:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801be1:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801be7:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801bed:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bf2:	e9 23 01 00 00       	jmp    801d1a <spawn+0x41a>
		if (i >= filesz) {
  801bf7:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801bfd:	77 2b                	ja     801c2a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801bff:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c05:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c09:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c0d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801c13:	89 04 24             	mov    %eax,(%esp)
  801c16:	e8 ba f0 ff ff       	call   800cd5 <sys_page_alloc>
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	0f 89 eb 00 00 00    	jns    801d0e <spawn+0x40e>
  801c23:	89 c3                	mov    %eax,%ebx
  801c25:	e9 6f 02 00 00       	jmp    801e99 <spawn+0x599>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c2a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c31:	00 
  801c32:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c39:	00 
  801c3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c41:	e8 8f f0 ff ff       	call   800cd5 <sys_page_alloc>
  801c46:	85 c0                	test   %eax,%eax
  801c48:	0f 88 41 02 00 00    	js     801e8f <spawn+0x58f>
  801c4e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c54:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5a:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c60:	89 04 24             	mov    %eax,(%esp)
  801c63:	e8 ec f7 ff ff       	call   801454 <seek>
  801c68:	85 c0                	test   %eax,%eax
  801c6a:	0f 88 23 02 00 00    	js     801e93 <spawn+0x593>
  801c70:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801c76:	29 f9                	sub    %edi,%ecx
  801c78:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c7a:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  801c80:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c85:	0f 47 c2             	cmova  %edx,%eax
  801c88:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c8c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c93:	00 
  801c94:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c9a:	89 04 24             	mov    %eax,(%esp)
  801c9d:	e8 da f6 ff ff       	call   80137c <readn>
  801ca2:	85 c0                	test   %eax,%eax
  801ca4:	0f 88 ed 01 00 00    	js     801e97 <spawn+0x597>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801caa:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  801cb4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801cb8:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801cbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cc9:	00 
  801cca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cd1:	e8 53 f0 ff ff       	call   800d29 <sys_page_map>
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	79 20                	jns    801cfa <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  801cda:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cde:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  801ce5:	00 
  801ce6:	c7 44 24 04 a8 01 00 	movl   $0x1a8,0x4(%esp)
  801ced:	00 
  801cee:	c7 04 24 7f 32 80 00 	movl   $0x80327f,(%esp)
  801cf5:	e8 fa e3 ff ff       	call   8000f4 <_panic>
			sys_page_unmap(0, UTEMP);
  801cfa:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d01:	00 
  801d02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d09:	e8 6e f0 ff ff       	call   800d7c <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801d0e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d14:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801d1a:	89 df                	mov    %ebx,%edi
  801d1c:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801d22:	0f 87 cf fe ff ff    	ja     801bf7 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d28:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  801d2f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801d36:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d3d:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  801d43:	0f 8c 37 fe ff ff    	jl     801b80 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801d49:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d4f:	89 04 24             	mov    %eax,(%esp)
  801d52:	e8 30 f4 ff ff       	call   801187 <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
  801d57:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d5c:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801d62:	89 d8                	mov    %ebx,%eax
  801d64:	c1 e8 16             	shr    $0x16,%eax
  801d67:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d6e:	a8 01                	test   $0x1,%al
  801d70:	74 76                	je     801de8 <spawn+0x4e8>
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
  801d72:	89 d8                	mov    %ebx,%eax
  801d74:	c1 e8 0c             	shr    $0xc,%eax
  801d77:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801d7e:	f6 c6 04             	test   $0x4,%dh
  801d81:	74 5d                	je     801de0 <spawn+0x4e0>
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  801d83:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
				cprintf("\nspawn addr:%p\n",addr);
  801d8a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d8e:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  801d95:	e8 53 e4 ff ff       	call   8001ed <cprintf>
		if(uvpd[PDX(addr)] & PTE_P)
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  801d9a:	81 e7 07 0e 00 00    	and    $0xe07,%edi
				cprintf("\nspawn addr:%p\n",addr);
				if ((r = sys_page_map(0, (void *)addr, child, (void *)addr, perm)) < 0)
  801da0:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801da4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801da8:	89 74 24 08          	mov    %esi,0x8(%esp)
  801dac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801db0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db7:	e8 6d ef ff ff       	call   800d29 <sys_page_map>
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	79 20                	jns    801de0 <spawn+0x4e0>
					panic("sys_page_map: %e", r);
  801dc0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dc4:	c7 44 24 08 b8 32 80 	movl   $0x8032b8,0x8(%esp)
  801dcb:	00 
  801dcc:	c7 44 24 04 c2 01 00 	movl   $0x1c2,0x4(%esp)
  801dd3:	00 
  801dd4:	c7 04 24 7f 32 80 00 	movl   $0x80327f,(%esp)
  801ddb:	e8 14 e3 ff ff       	call   8000f4 <_panic>
			}
			addr += PGSIZE;
  801de0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801de6:	eb 06                	jmp    801dee <spawn+0x4ee>
		}
		else
		{
			addr = addr + PTSIZE;
  801de8:	81 c3 00 00 40 00    	add    $0x400000,%ebx
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
  801dee:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  801df4:	0f 86 68 ff ff ff    	jbe    801d62 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801dfa:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e04:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e0a:	89 04 24             	mov    %eax,(%esp)
  801e0d:	e8 30 f0 ff ff       	call   800e42 <sys_env_set_trapframe>
  801e12:	85 c0                	test   %eax,%eax
  801e14:	79 20                	jns    801e36 <spawn+0x536>
		panic("sys_env_set_trapframe: %e", r);
  801e16:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e1a:	c7 44 24 08 c9 32 80 	movl   $0x8032c9,0x8(%esp)
  801e21:	00 
  801e22:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801e29:	00 
  801e2a:	c7 04 24 7f 32 80 00 	movl   $0x80327f,(%esp)
  801e31:	e8 be e2 ff ff       	call   8000f4 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e36:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801e3d:	00 
  801e3e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e44:	89 04 24             	mov    %eax,(%esp)
  801e47:	e8 a3 ef ff ff       	call   800def <sys_env_set_status>
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	79 30                	jns    801e80 <spawn+0x580>
		panic("sys_env_set_status: %e", r);
  801e50:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e54:	c7 44 24 08 e3 32 80 	movl   $0x8032e3,0x8(%esp)
  801e5b:	00 
  801e5c:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  801e63:	00 
  801e64:	c7 04 24 7f 32 80 00 	movl   $0x80327f,(%esp)
  801e6b:	e8 84 e2 ff ff       	call   8000f4 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801e70:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e76:	eb 57                	jmp    801ecf <spawn+0x5cf>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801e78:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e7e:	eb 4f                	jmp    801ecf <spawn+0x5cf>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801e80:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e86:	eb 47                	jmp    801ecf <spawn+0x5cf>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801e88:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801e8d:	eb 40                	jmp    801ecf <spawn+0x5cf>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e8f:	89 c3                	mov    %eax,%ebx
  801e91:	eb 06                	jmp    801e99 <spawn+0x599>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801e93:	89 c3                	mov    %eax,%ebx
  801e95:	eb 02                	jmp    801e99 <spawn+0x599>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801e97:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  801e99:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e9f:	89 04 24             	mov    %eax,(%esp)
  801ea2:	e8 4c ed ff ff       	call   800bf3 <sys_env_destroy>
	close(fd);
  801ea7:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801ead:	89 04 24             	mov    %eax,(%esp)
  801eb0:	e8 d2 f2 ff ff       	call   801187 <close>
	return r;
  801eb5:	89 d8                	mov    %ebx,%eax
  801eb7:	eb 16                	jmp    801ecf <spawn+0x5cf>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801eb9:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ec0:	00 
  801ec1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ec8:	e8 af ee ff ff       	call   800d7c <sys_page_unmap>
  801ecd:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801ecf:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  801ed5:	5b                   	pop    %ebx
  801ed6:	5e                   	pop    %esi
  801ed7:	5f                   	pop    %edi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    

00801eda <exec>:

int
exec(const char *prog, const char **argv)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	sys_env_destroy(child);
	close(fd);
	return r;*/
	return 0;

}
  801edd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    

00801ee4 <execl>:


int execl(const char *prog, const char *arg0, ...)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801ee7:	8d 45 10             	lea    0x10(%ebp),%eax


int execl(const char *prog, const char *arg0, ...)
{
	//works same as spawnl
	int argc=0;
  801eea:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801eef:	eb 03                	jmp    801ef4 <execl+0x10>
		argc++;
  801ef1:	83 c2 01             	add    $0x1,%edx
{
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801ef4:	83 c0 04             	add    $0x4,%eax
  801ef7:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801efb:	75 f4                	jne    801ef1 <execl+0xd>
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801efd:	b8 00 00 00 00       	mov    $0x0,%eax
  801f02:	eb 03                	jmp    801f07 <execl+0x23>
		argv[i+1] = va_arg(vl, const char *);
  801f04:	83 c0 01             	add    $0x1,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801f07:	39 d0                	cmp    %edx,%eax
  801f09:	75 f9                	jne    801f04 <execl+0x20>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
}
  801f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f10:	5d                   	pop    %ebp
  801f11:	c3                   	ret    

00801f12 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	56                   	push   %esi
  801f16:	53                   	push   %ebx
  801f17:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801f1a:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801f1d:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801f22:	eb 03                	jmp    801f27 <spawnl+0x15>
		argc++;
  801f24:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801f27:	83 c0 04             	add    $0x4,%eax
  801f2a:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801f2e:	75 f4                	jne    801f24 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801f30:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  801f37:	83 e0 f0             	and    $0xfffffff0,%eax
  801f3a:	29 c4                	sub    %eax,%esp
  801f3c:	8d 44 24 0b          	lea    0xb(%esp),%eax
  801f40:	c1 e8 02             	shr    $0x2,%eax
  801f43:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  801f4a:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f4f:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  801f56:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  801f5d:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f63:	eb 0a                	jmp    801f6f <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  801f65:	83 c0 01             	add    $0x1,%eax
  801f68:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  801f6c:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801f6f:	39 d0                	cmp    %edx,%eax
  801f71:	75 f2                	jne    801f65 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801f73:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	89 04 24             	mov    %eax,(%esp)
  801f7d:	e8 7e f9 ff ff       	call   801900 <spawn>
}
  801f82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f85:	5b                   	pop    %ebx
  801f86:	5e                   	pop    %esi
  801f87:	5d                   	pop    %ebp
  801f88:	c3                   	ret    
  801f89:	66 90                	xchg   %ax,%ax
  801f8b:	66 90                	xchg   %ax,%ax
  801f8d:	66 90                	xchg   %ax,%ax
  801f8f:	90                   	nop

00801f90 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f96:	c7 44 24 04 22 33 80 	movl   $0x803322,0x4(%esp)
  801f9d:	00 
  801f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa1:	89 04 24             	mov    %eax,(%esp)
  801fa4:	e8 be e8 ff ff       	call   800867 <strcpy>
	return 0;
}
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	53                   	push   %ebx
  801fb4:	83 ec 14             	sub    $0x14,%esp
  801fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fba:	89 1c 24             	mov    %ebx,(%esp)
  801fbd:	e8 15 0b 00 00       	call   802ad7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801fc2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801fc7:	83 f8 01             	cmp    $0x1,%eax
  801fca:	75 0d                	jne    801fd9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801fcc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801fcf:	89 04 24             	mov    %eax,(%esp)
  801fd2:	e8 29 03 00 00       	call   802300 <nsipc_close>
  801fd7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801fd9:	89 d0                	mov    %edx,%eax
  801fdb:	83 c4 14             	add    $0x14,%esp
  801fde:	5b                   	pop    %ebx
  801fdf:	5d                   	pop    %ebp
  801fe0:	c3                   	ret    

00801fe1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fe7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fee:	00 
  801fef:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	8b 40 0c             	mov    0xc(%eax),%eax
  802003:	89 04 24             	mov    %eax,(%esp)
  802006:	e8 f0 03 00 00       	call   8023fb <nsipc_send>
}
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802013:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80201a:	00 
  80201b:	8b 45 10             	mov    0x10(%ebp),%eax
  80201e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802022:	8b 45 0c             	mov    0xc(%ebp),%eax
  802025:	89 44 24 04          	mov    %eax,0x4(%esp)
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	8b 40 0c             	mov    0xc(%eax),%eax
  80202f:	89 04 24             	mov    %eax,(%esp)
  802032:	e8 44 03 00 00       	call   80237b <nsipc_recv>
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80203f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802042:	89 54 24 04          	mov    %edx,0x4(%esp)
  802046:	89 04 24             	mov    %eax,(%esp)
  802049:	e8 08 f0 ff ff       	call   801056 <fd_lookup>
  80204e:	85 c0                	test   %eax,%eax
  802050:	78 17                	js     802069 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80205b:	39 08                	cmp    %ecx,(%eax)
  80205d:	75 05                	jne    802064 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80205f:	8b 40 0c             	mov    0xc(%eax),%eax
  802062:	eb 05                	jmp    802069 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802064:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	56                   	push   %esi
  80206f:	53                   	push   %ebx
  802070:	83 ec 20             	sub    $0x20,%esp
  802073:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802075:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802078:	89 04 24             	mov    %eax,(%esp)
  80207b:	e8 87 ef ff ff       	call   801007 <fd_alloc>
  802080:	89 c3                	mov    %eax,%ebx
  802082:	85 c0                	test   %eax,%eax
  802084:	78 21                	js     8020a7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802086:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80208d:	00 
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	89 44 24 04          	mov    %eax,0x4(%esp)
  802095:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80209c:	e8 34 ec ff ff       	call   800cd5 <sys_page_alloc>
  8020a1:	89 c3                	mov    %eax,%ebx
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	79 0c                	jns    8020b3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8020a7:	89 34 24             	mov    %esi,(%esp)
  8020aa:	e8 51 02 00 00       	call   802300 <nsipc_close>
		return r;
  8020af:	89 d8                	mov    %ebx,%eax
  8020b1:	eb 20                	jmp    8020d3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8020b3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8020b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8020c8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8020cb:	89 14 24             	mov    %edx,(%esp)
  8020ce:	e8 0d ef ff ff       	call   800fe0 <fd2num>
}
  8020d3:	83 c4 20             	add    $0x20,%esp
  8020d6:	5b                   	pop    %ebx
  8020d7:	5e                   	pop    %esi
  8020d8:	5d                   	pop    %ebp
  8020d9:	c3                   	ret    

008020da <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	e8 51 ff ff ff       	call   802039 <fd2sockid>
		return r;
  8020e8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	78 23                	js     802111 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020ee:	8b 55 10             	mov    0x10(%ebp),%edx
  8020f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020fc:	89 04 24             	mov    %eax,(%esp)
  8020ff:	e8 45 01 00 00       	call   802249 <nsipc_accept>
		return r;
  802104:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802106:	85 c0                	test   %eax,%eax
  802108:	78 07                	js     802111 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80210a:	e8 5c ff ff ff       	call   80206b <alloc_sockfd>
  80210f:	89 c1                	mov    %eax,%ecx
}
  802111:	89 c8                	mov    %ecx,%eax
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	e8 16 ff ff ff       	call   802039 <fd2sockid>
  802123:	89 c2                	mov    %eax,%edx
  802125:	85 d2                	test   %edx,%edx
  802127:	78 16                	js     80213f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802129:	8b 45 10             	mov    0x10(%ebp),%eax
  80212c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802130:	8b 45 0c             	mov    0xc(%ebp),%eax
  802133:	89 44 24 04          	mov    %eax,0x4(%esp)
  802137:	89 14 24             	mov    %edx,(%esp)
  80213a:	e8 60 01 00 00       	call   80229f <nsipc_bind>
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <shutdown>:

int
shutdown(int s, int how)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	e8 ea fe ff ff       	call   802039 <fd2sockid>
  80214f:	89 c2                	mov    %eax,%edx
  802151:	85 d2                	test   %edx,%edx
  802153:	78 0f                	js     802164 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802155:	8b 45 0c             	mov    0xc(%ebp),%eax
  802158:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215c:	89 14 24             	mov    %edx,(%esp)
  80215f:	e8 7a 01 00 00       	call   8022de <nsipc_shutdown>
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	e8 c5 fe ff ff       	call   802039 <fd2sockid>
  802174:	89 c2                	mov    %eax,%edx
  802176:	85 d2                	test   %edx,%edx
  802178:	78 16                	js     802190 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80217a:	8b 45 10             	mov    0x10(%ebp),%eax
  80217d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802181:	8b 45 0c             	mov    0xc(%ebp),%eax
  802184:	89 44 24 04          	mov    %eax,0x4(%esp)
  802188:	89 14 24             	mov    %edx,(%esp)
  80218b:	e8 8a 01 00 00       	call   80231a <nsipc_connect>
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <listen>:

int
listen(int s, int backlog)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	e8 99 fe ff ff       	call   802039 <fd2sockid>
  8021a0:	89 c2                	mov    %eax,%edx
  8021a2:	85 d2                	test   %edx,%edx
  8021a4:	78 0f                	js     8021b5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8021a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ad:	89 14 24             	mov    %edx,(%esp)
  8021b0:	e8 a4 01 00 00       	call   802359 <nsipc_listen>
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	89 04 24             	mov    %eax,(%esp)
  8021d1:	e8 98 02 00 00       	call   80246e <nsipc_socket>
  8021d6:	89 c2                	mov    %eax,%edx
  8021d8:	85 d2                	test   %edx,%edx
  8021da:	78 05                	js     8021e1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8021dc:	e8 8a fe ff ff       	call   80206b <alloc_sockfd>
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	53                   	push   %ebx
  8021e7:	83 ec 14             	sub    $0x14,%esp
  8021ea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021ec:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021f3:	75 11                	jne    802206 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8021fc:	e8 9e 08 00 00       	call   802a9f <ipc_find_env>
  802201:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802206:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80220d:	00 
  80220e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802215:	00 
  802216:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80221a:	a1 04 50 80 00       	mov    0x805004,%eax
  80221f:	89 04 24             	mov    %eax,(%esp)
  802222:	e8 11 08 00 00       	call   802a38 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802227:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80222e:	00 
  80222f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802236:	00 
  802237:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80223e:	e8 8d 07 00 00       	call   8029d0 <ipc_recv>
}
  802243:	83 c4 14             	add    $0x14,%esp
  802246:	5b                   	pop    %ebx
  802247:	5d                   	pop    %ebp
  802248:	c3                   	ret    

00802249 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	56                   	push   %esi
  80224d:	53                   	push   %ebx
  80224e:	83 ec 10             	sub    $0x10,%esp
  802251:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80225c:	8b 06                	mov    (%esi),%eax
  80225e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802263:	b8 01 00 00 00       	mov    $0x1,%eax
  802268:	e8 76 ff ff ff       	call   8021e3 <nsipc>
  80226d:	89 c3                	mov    %eax,%ebx
  80226f:	85 c0                	test   %eax,%eax
  802271:	78 23                	js     802296 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802273:	a1 10 70 80 00       	mov    0x807010,%eax
  802278:	89 44 24 08          	mov    %eax,0x8(%esp)
  80227c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802283:	00 
  802284:	8b 45 0c             	mov    0xc(%ebp),%eax
  802287:	89 04 24             	mov    %eax,(%esp)
  80228a:	e8 75 e7 ff ff       	call   800a04 <memmove>
		*addrlen = ret->ret_addrlen;
  80228f:	a1 10 70 80 00       	mov    0x807010,%eax
  802294:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802296:	89 d8                	mov    %ebx,%eax
  802298:	83 c4 10             	add    $0x10,%esp
  80229b:	5b                   	pop    %ebx
  80229c:	5e                   	pop    %esi
  80229d:	5d                   	pop    %ebp
  80229e:	c3                   	ret    

0080229f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	53                   	push   %ebx
  8022a3:	83 ec 14             	sub    $0x14,%esp
  8022a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022bc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8022c3:	e8 3c e7 ff ff       	call   800a04 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022c8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8022d3:	e8 0b ff ff ff       	call   8021e3 <nsipc>
}
  8022d8:	83 c4 14             	add    $0x14,%esp
  8022db:	5b                   	pop    %ebx
  8022dc:	5d                   	pop    %ebp
  8022dd:	c3                   	ret    

008022de <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ef:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8022f9:	e8 e5 fe ff ff       	call   8021e3 <nsipc>
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <nsipc_close>:

int
nsipc_close(int s)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80230e:	b8 04 00 00 00       	mov    $0x4,%eax
  802313:	e8 cb fe ff ff       	call   8021e3 <nsipc>
}
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
  80231d:	53                   	push   %ebx
  80231e:	83 ec 14             	sub    $0x14,%esp
  802321:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80232c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802330:	8b 45 0c             	mov    0xc(%ebp),%eax
  802333:	89 44 24 04          	mov    %eax,0x4(%esp)
  802337:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80233e:	e8 c1 e6 ff ff       	call   800a04 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802343:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802349:	b8 05 00 00 00       	mov    $0x5,%eax
  80234e:	e8 90 fe ff ff       	call   8021e3 <nsipc>
}
  802353:	83 c4 14             	add    $0x14,%esp
  802356:	5b                   	pop    %ebx
  802357:	5d                   	pop    %ebp
  802358:	c3                   	ret    

00802359 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80236f:	b8 06 00 00 00       	mov    $0x6,%eax
  802374:	e8 6a fe ff ff       	call   8021e3 <nsipc>
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	56                   	push   %esi
  80237f:	53                   	push   %ebx
  802380:	83 ec 10             	sub    $0x10,%esp
  802383:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80238e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802394:	8b 45 14             	mov    0x14(%ebp),%eax
  802397:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80239c:	b8 07 00 00 00       	mov    $0x7,%eax
  8023a1:	e8 3d fe ff ff       	call   8021e3 <nsipc>
  8023a6:	89 c3                	mov    %eax,%ebx
  8023a8:	85 c0                	test   %eax,%eax
  8023aa:	78 46                	js     8023f2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8023ac:	39 f0                	cmp    %esi,%eax
  8023ae:	7f 07                	jg     8023b7 <nsipc_recv+0x3c>
  8023b0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023b5:	7e 24                	jle    8023db <nsipc_recv+0x60>
  8023b7:	c7 44 24 0c 2e 33 80 	movl   $0x80332e,0xc(%esp)
  8023be:	00 
  8023bf:	c7 44 24 08 20 32 80 	movl   $0x803220,0x8(%esp)
  8023c6:	00 
  8023c7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8023ce:	00 
  8023cf:	c7 04 24 43 33 80 00 	movl   $0x803343,(%esp)
  8023d6:	e8 19 dd ff ff       	call   8000f4 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023df:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8023e6:	00 
  8023e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ea:	89 04 24             	mov    %eax,(%esp)
  8023ed:	e8 12 e6 ff ff       	call   800a04 <memmove>
	}

	return r;
}
  8023f2:	89 d8                	mov    %ebx,%eax
  8023f4:	83 c4 10             	add    $0x10,%esp
  8023f7:	5b                   	pop    %ebx
  8023f8:	5e                   	pop    %esi
  8023f9:	5d                   	pop    %ebp
  8023fa:	c3                   	ret    

008023fb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	53                   	push   %ebx
  8023ff:	83 ec 14             	sub    $0x14,%esp
  802402:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80240d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802413:	7e 24                	jle    802439 <nsipc_send+0x3e>
  802415:	c7 44 24 0c 4f 33 80 	movl   $0x80334f,0xc(%esp)
  80241c:	00 
  80241d:	c7 44 24 08 20 32 80 	movl   $0x803220,0x8(%esp)
  802424:	00 
  802425:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80242c:	00 
  80242d:	c7 04 24 43 33 80 00 	movl   $0x803343,(%esp)
  802434:	e8 bb dc ff ff       	call   8000f4 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802439:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80243d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802440:	89 44 24 04          	mov    %eax,0x4(%esp)
  802444:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80244b:	e8 b4 e5 ff ff       	call   800a04 <memmove>
	nsipcbuf.send.req_size = size;
  802450:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802456:	8b 45 14             	mov    0x14(%ebp),%eax
  802459:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80245e:	b8 08 00 00 00       	mov    $0x8,%eax
  802463:	e8 7b fd ff ff       	call   8021e3 <nsipc>
}
  802468:	83 c4 14             	add    $0x14,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5d                   	pop    %ebp
  80246d:	c3                   	ret    

0080246e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
  802471:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80247c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802484:	8b 45 10             	mov    0x10(%ebp),%eax
  802487:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80248c:	b8 09 00 00 00       	mov    $0x9,%eax
  802491:	e8 4d fd ff ff       	call   8021e3 <nsipc>
}
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	56                   	push   %esi
  80249c:	53                   	push   %ebx
  80249d:	83 ec 10             	sub    $0x10,%esp
  8024a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	89 04 24             	mov    %eax,(%esp)
  8024a9:	e8 42 eb ff ff       	call   800ff0 <fd2data>
  8024ae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024b0:	c7 44 24 04 5b 33 80 	movl   $0x80335b,0x4(%esp)
  8024b7:	00 
  8024b8:	89 1c 24             	mov    %ebx,(%esp)
  8024bb:	e8 a7 e3 ff ff       	call   800867 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024c0:	8b 46 04             	mov    0x4(%esi),%eax
  8024c3:	2b 06                	sub    (%esi),%eax
  8024c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024d2:	00 00 00 
	stat->st_dev = &devpipe;
  8024d5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8024dc:	40 80 00 
	return 0;
}
  8024df:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e4:	83 c4 10             	add    $0x10,%esp
  8024e7:	5b                   	pop    %ebx
  8024e8:	5e                   	pop    %esi
  8024e9:	5d                   	pop    %ebp
  8024ea:	c3                   	ret    

008024eb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	53                   	push   %ebx
  8024ef:	83 ec 14             	sub    $0x14,%esp
  8024f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802500:	e8 77 e8 ff ff       	call   800d7c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802505:	89 1c 24             	mov    %ebx,(%esp)
  802508:	e8 e3 ea ff ff       	call   800ff0 <fd2data>
  80250d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802511:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802518:	e8 5f e8 ff ff       	call   800d7c <sys_page_unmap>
}
  80251d:	83 c4 14             	add    $0x14,%esp
  802520:	5b                   	pop    %ebx
  802521:	5d                   	pop    %ebp
  802522:	c3                   	ret    

00802523 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	57                   	push   %edi
  802527:	56                   	push   %esi
  802528:	53                   	push   %ebx
  802529:	83 ec 2c             	sub    $0x2c,%esp
  80252c:	89 c6                	mov    %eax,%esi
  80252e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802531:	a1 08 50 80 00       	mov    0x805008,%eax
  802536:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802539:	89 34 24             	mov    %esi,(%esp)
  80253c:	e8 96 05 00 00       	call   802ad7 <pageref>
  802541:	89 c7                	mov    %eax,%edi
  802543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802546:	89 04 24             	mov    %eax,(%esp)
  802549:	e8 89 05 00 00       	call   802ad7 <pageref>
  80254e:	39 c7                	cmp    %eax,%edi
  802550:	0f 94 c2             	sete   %dl
  802553:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802556:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80255c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80255f:	39 fb                	cmp    %edi,%ebx
  802561:	74 21                	je     802584 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802563:	84 d2                	test   %dl,%dl
  802565:	74 ca                	je     802531 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802567:	8b 51 58             	mov    0x58(%ecx),%edx
  80256a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80256e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802572:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802576:	c7 04 24 62 33 80 00 	movl   $0x803362,(%esp)
  80257d:	e8 6b dc ff ff       	call   8001ed <cprintf>
  802582:	eb ad                	jmp    802531 <_pipeisclosed+0xe>
	}
}
  802584:	83 c4 2c             	add    $0x2c,%esp
  802587:	5b                   	pop    %ebx
  802588:	5e                   	pop    %esi
  802589:	5f                   	pop    %edi
  80258a:	5d                   	pop    %ebp
  80258b:	c3                   	ret    

0080258c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	57                   	push   %edi
  802590:	56                   	push   %esi
  802591:	53                   	push   %ebx
  802592:	83 ec 1c             	sub    $0x1c,%esp
  802595:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802598:	89 34 24             	mov    %esi,(%esp)
  80259b:	e8 50 ea ff ff       	call   800ff0 <fd2data>
  8025a0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8025a7:	eb 45                	jmp    8025ee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8025a9:	89 da                	mov    %ebx,%edx
  8025ab:	89 f0                	mov    %esi,%eax
  8025ad:	e8 71 ff ff ff       	call   802523 <_pipeisclosed>
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	75 41                	jne    8025f7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8025b6:	e8 fb e6 ff ff       	call   800cb6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025bb:	8b 43 04             	mov    0x4(%ebx),%eax
  8025be:	8b 0b                	mov    (%ebx),%ecx
  8025c0:	8d 51 20             	lea    0x20(%ecx),%edx
  8025c3:	39 d0                	cmp    %edx,%eax
  8025c5:	73 e2                	jae    8025a9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025ca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8025ce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025d1:	99                   	cltd   
  8025d2:	c1 ea 1b             	shr    $0x1b,%edx
  8025d5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8025d8:	83 e1 1f             	and    $0x1f,%ecx
  8025db:	29 d1                	sub    %edx,%ecx
  8025dd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8025e1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8025e5:	83 c0 01             	add    $0x1,%eax
  8025e8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025eb:	83 c7 01             	add    $0x1,%edi
  8025ee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8025f1:	75 c8                	jne    8025bb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8025f3:	89 f8                	mov    %edi,%eax
  8025f5:	eb 05                	jmp    8025fc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8025fc:	83 c4 1c             	add    $0x1c,%esp
  8025ff:	5b                   	pop    %ebx
  802600:	5e                   	pop    %esi
  802601:	5f                   	pop    %edi
  802602:	5d                   	pop    %ebp
  802603:	c3                   	ret    

00802604 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
  802607:	57                   	push   %edi
  802608:	56                   	push   %esi
  802609:	53                   	push   %ebx
  80260a:	83 ec 1c             	sub    $0x1c,%esp
  80260d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802610:	89 3c 24             	mov    %edi,(%esp)
  802613:	e8 d8 e9 ff ff       	call   800ff0 <fd2data>
  802618:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80261a:	be 00 00 00 00       	mov    $0x0,%esi
  80261f:	eb 3d                	jmp    80265e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802621:	85 f6                	test   %esi,%esi
  802623:	74 04                	je     802629 <devpipe_read+0x25>
				return i;
  802625:	89 f0                	mov    %esi,%eax
  802627:	eb 43                	jmp    80266c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802629:	89 da                	mov    %ebx,%edx
  80262b:	89 f8                	mov    %edi,%eax
  80262d:	e8 f1 fe ff ff       	call   802523 <_pipeisclosed>
  802632:	85 c0                	test   %eax,%eax
  802634:	75 31                	jne    802667 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802636:	e8 7b e6 ff ff       	call   800cb6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80263b:	8b 03                	mov    (%ebx),%eax
  80263d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802640:	74 df                	je     802621 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802642:	99                   	cltd   
  802643:	c1 ea 1b             	shr    $0x1b,%edx
  802646:	01 d0                	add    %edx,%eax
  802648:	83 e0 1f             	and    $0x1f,%eax
  80264b:	29 d0                	sub    %edx,%eax
  80264d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802652:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802655:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802658:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80265b:	83 c6 01             	add    $0x1,%esi
  80265e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802661:	75 d8                	jne    80263b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802663:	89 f0                	mov    %esi,%eax
  802665:	eb 05                	jmp    80266c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80266c:	83 c4 1c             	add    $0x1c,%esp
  80266f:	5b                   	pop    %ebx
  802670:	5e                   	pop    %esi
  802671:	5f                   	pop    %edi
  802672:	5d                   	pop    %ebp
  802673:	c3                   	ret    

00802674 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	56                   	push   %esi
  802678:	53                   	push   %ebx
  802679:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80267c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80267f:	89 04 24             	mov    %eax,(%esp)
  802682:	e8 80 e9 ff ff       	call   801007 <fd_alloc>
  802687:	89 c2                	mov    %eax,%edx
  802689:	85 d2                	test   %edx,%edx
  80268b:	0f 88 4d 01 00 00    	js     8027de <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802691:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802698:	00 
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a7:	e8 29 e6 ff ff       	call   800cd5 <sys_page_alloc>
  8026ac:	89 c2                	mov    %eax,%edx
  8026ae:	85 d2                	test   %edx,%edx
  8026b0:	0f 88 28 01 00 00    	js     8027de <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026b9:	89 04 24             	mov    %eax,(%esp)
  8026bc:	e8 46 e9 ff ff       	call   801007 <fd_alloc>
  8026c1:	89 c3                	mov    %eax,%ebx
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	0f 88 fe 00 00 00    	js     8027c9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026cb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026d2:	00 
  8026d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e1:	e8 ef e5 ff ff       	call   800cd5 <sys_page_alloc>
  8026e6:	89 c3                	mov    %eax,%ebx
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	0f 88 d9 00 00 00    	js     8027c9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	89 04 24             	mov    %eax,(%esp)
  8026f6:	e8 f5 e8 ff ff       	call   800ff0 <fd2data>
  8026fb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026fd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802704:	00 
  802705:	89 44 24 04          	mov    %eax,0x4(%esp)
  802709:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802710:	e8 c0 e5 ff ff       	call   800cd5 <sys_page_alloc>
  802715:	89 c3                	mov    %eax,%ebx
  802717:	85 c0                	test   %eax,%eax
  802719:	0f 88 97 00 00 00    	js     8027b6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802722:	89 04 24             	mov    %eax,(%esp)
  802725:	e8 c6 e8 ff ff       	call   800ff0 <fd2data>
  80272a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802731:	00 
  802732:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802736:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80273d:	00 
  80273e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802742:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802749:	e8 db e5 ff ff       	call   800d29 <sys_page_map>
  80274e:	89 c3                	mov    %eax,%ebx
  802750:	85 c0                	test   %eax,%eax
  802752:	78 52                	js     8027a6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802754:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802769:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80276f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802772:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802777:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	89 04 24             	mov    %eax,(%esp)
  802784:	e8 57 e8 ff ff       	call   800fe0 <fd2num>
  802789:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80278c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80278e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802791:	89 04 24             	mov    %eax,(%esp)
  802794:	e8 47 e8 ff ff       	call   800fe0 <fd2num>
  802799:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80279c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80279f:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a4:	eb 38                	jmp    8027de <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8027a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027b1:	e8 c6 e5 ff ff       	call   800d7c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8027b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027c4:	e8 b3 e5 ff ff       	call   800d7c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d7:	e8 a0 e5 ff ff       	call   800d7c <sys_page_unmap>
  8027dc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8027de:	83 c4 30             	add    $0x30,%esp
  8027e1:	5b                   	pop    %ebx
  8027e2:	5e                   	pop    %esi
  8027e3:	5d                   	pop    %ebp
  8027e4:	c3                   	ret    

008027e5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	89 04 24             	mov    %eax,(%esp)
  8027f8:	e8 59 e8 ff ff       	call   801056 <fd_lookup>
  8027fd:	89 c2                	mov    %eax,%edx
  8027ff:	85 d2                	test   %edx,%edx
  802801:	78 15                	js     802818 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	89 04 24             	mov    %eax,(%esp)
  802809:	e8 e2 e7 ff ff       	call   800ff0 <fd2data>
	return _pipeisclosed(fd, p);
  80280e:	89 c2                	mov    %eax,%edx
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	e8 0b fd ff ff       	call   802523 <_pipeisclosed>
}
  802818:	c9                   	leave  
  802819:	c3                   	ret    
  80281a:	66 90                	xchg   %ax,%ax
  80281c:	66 90                	xchg   %ax,%ax
  80281e:	66 90                	xchg   %ax,%ax

00802820 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802823:	b8 00 00 00 00       	mov    $0x0,%eax
  802828:	5d                   	pop    %ebp
  802829:	c3                   	ret    

0080282a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802830:	c7 44 24 04 7a 33 80 	movl   $0x80337a,0x4(%esp)
  802837:	00 
  802838:	8b 45 0c             	mov    0xc(%ebp),%eax
  80283b:	89 04 24             	mov    %eax,(%esp)
  80283e:	e8 24 e0 ff ff       	call   800867 <strcpy>
	return 0;
}
  802843:	b8 00 00 00 00       	mov    $0x0,%eax
  802848:	c9                   	leave  
  802849:	c3                   	ret    

0080284a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80284a:	55                   	push   %ebp
  80284b:	89 e5                	mov    %esp,%ebp
  80284d:	57                   	push   %edi
  80284e:	56                   	push   %esi
  80284f:	53                   	push   %ebx
  802850:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802856:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80285b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802861:	eb 31                	jmp    802894 <devcons_write+0x4a>
		m = n - tot;
  802863:	8b 75 10             	mov    0x10(%ebp),%esi
  802866:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802868:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80286b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802870:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802873:	89 74 24 08          	mov    %esi,0x8(%esp)
  802877:	03 45 0c             	add    0xc(%ebp),%eax
  80287a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80287e:	89 3c 24             	mov    %edi,(%esp)
  802881:	e8 7e e1 ff ff       	call   800a04 <memmove>
		sys_cputs(buf, m);
  802886:	89 74 24 04          	mov    %esi,0x4(%esp)
  80288a:	89 3c 24             	mov    %edi,(%esp)
  80288d:	e8 24 e3 ff ff       	call   800bb6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802892:	01 f3                	add    %esi,%ebx
  802894:	89 d8                	mov    %ebx,%eax
  802896:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802899:	72 c8                	jb     802863 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80289b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8028a1:	5b                   	pop    %ebx
  8028a2:	5e                   	pop    %esi
  8028a3:	5f                   	pop    %edi
  8028a4:	5d                   	pop    %ebp
  8028a5:	c3                   	ret    

008028a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028a6:	55                   	push   %ebp
  8028a7:	89 e5                	mov    %esp,%ebp
  8028a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8028ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8028b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028b5:	75 07                	jne    8028be <devcons_read+0x18>
  8028b7:	eb 2a                	jmp    8028e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8028b9:	e8 f8 e3 ff ff       	call   800cb6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8028be:	66 90                	xchg   %ax,%ax
  8028c0:	e8 0f e3 ff ff       	call   800bd4 <sys_cgetc>
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	74 f0                	je     8028b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	78 16                	js     8028e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8028cd:	83 f8 04             	cmp    $0x4,%eax
  8028d0:	74 0c                	je     8028de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8028d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d5:	88 02                	mov    %al,(%edx)
	return 1;
  8028d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8028dc:	eb 05                	jmp    8028e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8028de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8028e3:	c9                   	leave  
  8028e4:	c3                   	ret    

008028e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8028e5:	55                   	push   %ebp
  8028e6:	89 e5                	mov    %esp,%ebp
  8028e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8028f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028f8:	00 
  8028f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028fc:	89 04 24             	mov    %eax,(%esp)
  8028ff:	e8 b2 e2 ff ff       	call   800bb6 <sys_cputs>
}
  802904:	c9                   	leave  
  802905:	c3                   	ret    

00802906 <getchar>:

int
getchar(void)
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
  802909:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80290c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802913:	00 
  802914:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802917:	89 44 24 04          	mov    %eax,0x4(%esp)
  80291b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802922:	e8 c3 e9 ff ff       	call   8012ea <read>
	if (r < 0)
  802927:	85 c0                	test   %eax,%eax
  802929:	78 0f                	js     80293a <getchar+0x34>
		return r;
	if (r < 1)
  80292b:	85 c0                	test   %eax,%eax
  80292d:	7e 06                	jle    802935 <getchar+0x2f>
		return -E_EOF;
	return c;
  80292f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802933:	eb 05                	jmp    80293a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802935:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80293a:	c9                   	leave  
  80293b:	c3                   	ret    

0080293c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80293c:	55                   	push   %ebp
  80293d:	89 e5                	mov    %esp,%ebp
  80293f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802942:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802945:	89 44 24 04          	mov    %eax,0x4(%esp)
  802949:	8b 45 08             	mov    0x8(%ebp),%eax
  80294c:	89 04 24             	mov    %eax,(%esp)
  80294f:	e8 02 e7 ff ff       	call   801056 <fd_lookup>
  802954:	85 c0                	test   %eax,%eax
  802956:	78 11                	js     802969 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802961:	39 10                	cmp    %edx,(%eax)
  802963:	0f 94 c0             	sete   %al
  802966:	0f b6 c0             	movzbl %al,%eax
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <opencons>:

int
opencons(void)
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
  80296e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802971:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802974:	89 04 24             	mov    %eax,(%esp)
  802977:	e8 8b e6 ff ff       	call   801007 <fd_alloc>
		return r;
  80297c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80297e:	85 c0                	test   %eax,%eax
  802980:	78 40                	js     8029c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802982:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802989:	00 
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802991:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802998:	e8 38 e3 ff ff       	call   800cd5 <sys_page_alloc>
		return r;
  80299d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	78 1f                	js     8029c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8029a3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8029b8:	89 04 24             	mov    %eax,(%esp)
  8029bb:	e8 20 e6 ff ff       	call   800fe0 <fd2num>
  8029c0:	89 c2                	mov    %eax,%edx
}
  8029c2:	89 d0                	mov    %edx,%eax
  8029c4:	c9                   	leave  
  8029c5:	c3                   	ret    
  8029c6:	66 90                	xchg   %ax,%ax
  8029c8:	66 90                	xchg   %ax,%ax
  8029ca:	66 90                	xchg   %ax,%ax
  8029cc:	66 90                	xchg   %ax,%ax
  8029ce:	66 90                	xchg   %ax,%ax

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
  8029ee:	e8 18 e5 ff ff       	call   800f0b <sys_ipc_recv>
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
  802a66:	e8 7d e4 ff ff       	call   800ee8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	74 28                	je     802a97 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802a6f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a72:	74 1c                	je     802a90 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802a74:	c7 44 24 08 88 33 80 	movl   $0x803388,0x8(%esp)
  802a7b:	00 
  802a7c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802a83:	00 
  802a84:	c7 04 24 ac 33 80 00 	movl   $0x8033ac,(%esp)
  802a8b:	e8 64 d6 ff ff       	call   8000f4 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802a90:	e8 21 e2 ff ff       	call   800cb6 <sys_yield>
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
