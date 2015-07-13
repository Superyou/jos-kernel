
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 ca 00 00 00       	call   8000fb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 be 11 00 00       	call   8011ff <fork>
  800041:	89 c3                	mov    %eax,%ebx
  800043:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800046:	85 c0                	test   %eax,%eax
  800048:	75 05                	jne    80004f <umain+0x1c>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80004a:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004d:	eb 3e                	jmp    80008d <umain+0x5a>
{
	envid_t who;

	if ((who = fork()) != 0) {
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004f:	e8 53 0c 00 00       	call   800ca7 <sys_getenvid>
  800054:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005c:	c7 04 24 e0 2d 80 00 	movl   $0x802de0,(%esp)
  800063:	e8 97 01 00 00       	call   8001ff <cprintf>
		ipc_send(who, 0, 0, 0);
  800068:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80006f:	00 
  800070:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800077:	00 
  800078:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007f:	00 
  800080:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800083:	89 04 24             	mov    %eax,(%esp)
  800086:	e8 7d 15 00 00       	call   801608 <ipc_send>
  80008b:	eb bd                	jmp    80004a <umain+0x17>
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80008d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800094:	00 
  800095:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80009c:	00 
  80009d:	89 34 24             	mov    %esi,(%esp)
  8000a0:	e8 fb 14 00 00       	call   8015a0 <ipc_recv>
  8000a5:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8000aa:	e8 f8 0b 00 00       	call   800ca7 <sys_getenvid>
  8000af:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bb:	c7 04 24 f6 2d 80 00 	movl   $0x802df6,(%esp)
  8000c2:	e8 38 01 00 00       	call   8001ff <cprintf>
		if (i == 10)
  8000c7:	83 fb 0a             	cmp    $0xa,%ebx
  8000ca:	74 27                	je     8000f3 <umain+0xc0>
			return;
		i++;
  8000cc:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  8000cf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000d6:	00 
  8000d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000de:	00 
  8000df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e6:	89 04 24             	mov    %eax,(%esp)
  8000e9:	e8 1a 15 00 00       	call   801608 <ipc_send>
		if (i == 10)
  8000ee:	83 fb 0a             	cmp    $0xa,%ebx
  8000f1:	75 9a                	jne    80008d <umain+0x5a>
			return;
	}

}
  8000f3:	83 c4 2c             	add    $0x2c,%esp
  8000f6:	5b                   	pop    %ebx
  8000f7:	5e                   	pop    %esi
  8000f8:	5f                   	pop    %edi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
  800100:	83 ec 10             	sub    $0x10,%esp
  800103:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800106:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800109:	e8 99 0b 00 00       	call   800ca7 <sys_getenvid>
  80010e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800113:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800116:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011b:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800120:	85 db                	test   %ebx,%ebx
  800122:	7e 07                	jle    80012b <libmain+0x30>
		binaryname = argv[0];
  800124:	8b 06                	mov    (%esi),%eax
  800126:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80012b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80012f:	89 1c 24             	mov    %ebx,(%esp)
  800132:	e8 fc fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800137:	e8 07 00 00 00       	call   800143 <exit>
}
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	5b                   	pop    %ebx
  800140:	5e                   	pop    %esi
  800141:	5d                   	pop    %ebp
  800142:	c3                   	ret    

00800143 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800149:	e8 3c 17 00 00       	call   80188a <close_all>
	sys_env_destroy(0);
  80014e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800155:	e8 a9 0a 00 00       	call   800c03 <sys_env_destroy>
}
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	53                   	push   %ebx
  800160:	83 ec 14             	sub    $0x14,%esp
  800163:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800166:	8b 13                	mov    (%ebx),%edx
  800168:	8d 42 01             	lea    0x1(%edx),%eax
  80016b:	89 03                	mov    %eax,(%ebx)
  80016d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800170:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800174:	3d ff 00 00 00       	cmp    $0xff,%eax
  800179:	75 19                	jne    800194 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80017b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800182:	00 
  800183:	8d 43 08             	lea    0x8(%ebx),%eax
  800186:	89 04 24             	mov    %eax,(%esp)
  800189:	e8 38 0a 00 00       	call   800bc6 <sys_cputs>
		b->idx = 0;
  80018e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800194:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800198:	83 c4 14             	add    $0x14,%esp
  80019b:	5b                   	pop    %ebx
  80019c:	5d                   	pop    %ebp
  80019d:	c3                   	ret    

0080019e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001a7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ae:	00 00 00 
	b.cnt = 0;
  8001b1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d3:	c7 04 24 5c 01 80 00 	movl   $0x80015c,(%esp)
  8001da:	e8 75 01 00 00       	call   800354 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001df:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ef:	89 04 24             	mov    %eax,(%esp)
  8001f2:	e8 cf 09 00 00       	call   800bc6 <sys_cputs>

	return b.cnt;
}
  8001f7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800205:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800208:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020c:	8b 45 08             	mov    0x8(%ebp),%eax
  80020f:	89 04 24             	mov    %eax,(%esp)
  800212:	e8 87 ff ff ff       	call   80019e <vcprintf>
	va_end(ap);

	return cnt;
}
  800217:	c9                   	leave  
  800218:	c3                   	ret    
  800219:	66 90                	xchg   %ax,%ax
  80021b:	66 90                	xchg   %ax,%ax
  80021d:	66 90                	xchg   %ax,%ax
  80021f:	90                   	nop

00800220 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	57                   	push   %edi
  800224:	56                   	push   %esi
  800225:	53                   	push   %ebx
  800226:	83 ec 3c             	sub    $0x3c,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80022c:	89 d7                	mov    %edx,%edi
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
  800237:	89 c3                	mov    %eax,%ebx
  800239:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80023c:	8b 45 10             	mov    0x10(%ebp),%eax
  80023f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800242:	b9 00 00 00 00       	mov    $0x0,%ecx
  800247:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80024d:	39 d9                	cmp    %ebx,%ecx
  80024f:	72 05                	jb     800256 <printnum+0x36>
  800251:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800254:	77 69                	ja     8002bf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800256:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800259:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80025d:	83 ee 01             	sub    $0x1,%esi
  800260:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800264:	89 44 24 08          	mov    %eax,0x8(%esp)
  800268:	8b 44 24 08          	mov    0x8(%esp),%eax
  80026c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800270:	89 c3                	mov    %eax,%ebx
  800272:	89 d6                	mov    %edx,%esi
  800274:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800277:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80027a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80027e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028f:	e8 bc 28 00 00       	call   802b50 <__udivdi3>
  800294:	89 d9                	mov    %ebx,%ecx
  800296:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80029a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80029e:	89 04 24             	mov    %eax,(%esp)
  8002a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002a5:	89 fa                	mov    %edi,%edx
  8002a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002aa:	e8 71 ff ff ff       	call   800220 <printnum>
  8002af:	eb 1b                	jmp    8002cc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	ff d3                	call   *%ebx
  8002bd:	eb 03                	jmp    8002c2 <printnum+0xa2>
  8002bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002c2:	83 ee 01             	sub    $0x1,%esi
  8002c5:	85 f6                	test   %esi,%esi
  8002c7:	7f e8                	jg     8002b1 <printnum+0x91>
  8002c9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002d0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002de:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e5:	89 04 24             	mov    %eax,(%esp)
  8002e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ef:	e8 8c 29 00 00       	call   802c80 <__umoddi3>
  8002f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f8:	0f be 80 13 2e 80 00 	movsbl 0x802e13(%eax),%eax
  8002ff:	89 04 24             	mov    %eax,(%esp)
  800302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800305:	ff d0                	call   *%eax
}
  800307:	83 c4 3c             	add    $0x3c,%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5f                   	pop    %edi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800315:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800319:	8b 10                	mov    (%eax),%edx
  80031b:	3b 50 04             	cmp    0x4(%eax),%edx
  80031e:	73 0a                	jae    80032a <sprintputch+0x1b>
		*b->buf++ = ch;
  800320:	8d 4a 01             	lea    0x1(%edx),%ecx
  800323:	89 08                	mov    %ecx,(%eax)
  800325:	8b 45 08             	mov    0x8(%ebp),%eax
  800328:	88 02                	mov    %al,(%edx)
}
  80032a:	5d                   	pop    %ebp
  80032b:	c3                   	ret    

0080032c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800332:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800335:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800339:	8b 45 10             	mov    0x10(%ebp),%eax
  80033c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800340:	8b 45 0c             	mov    0xc(%ebp),%eax
  800343:	89 44 24 04          	mov    %eax,0x4(%esp)
  800347:	8b 45 08             	mov    0x8(%ebp),%eax
  80034a:	89 04 24             	mov    %eax,(%esp)
  80034d:	e8 02 00 00 00       	call   800354 <vprintfmt>
	va_end(ap);
}
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	53                   	push   %ebx
  80035a:	83 ec 3c             	sub    $0x3c,%esp
  80035d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800360:	eb 17                	jmp    800379 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800362:	85 c0                	test   %eax,%eax
  800364:	0f 84 4b 04 00 00    	je     8007b5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80036a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80036d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800371:	89 04 24             	mov    %eax,(%esp)
  800374:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800377:	89 fb                	mov    %edi,%ebx
  800379:	8d 7b 01             	lea    0x1(%ebx),%edi
  80037c:	0f b6 03             	movzbl (%ebx),%eax
  80037f:	83 f8 25             	cmp    $0x25,%eax
  800382:	75 de                	jne    800362 <vprintfmt+0xe>
  800384:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800388:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80038f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800394:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80039b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003a0:	eb 18                	jmp    8003ba <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003a4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8003a8:	eb 10                	jmp    8003ba <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003aa:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003ac:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8003b0:	eb 08                	jmp    8003ba <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8003b5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	8d 5f 01             	lea    0x1(%edi),%ebx
  8003bd:	0f b6 17             	movzbl (%edi),%edx
  8003c0:	0f b6 c2             	movzbl %dl,%eax
  8003c3:	83 ea 23             	sub    $0x23,%edx
  8003c6:	80 fa 55             	cmp    $0x55,%dl
  8003c9:	0f 87 c2 03 00 00    	ja     800791 <vprintfmt+0x43d>
  8003cf:	0f b6 d2             	movzbl %dl,%edx
  8003d2:	ff 24 95 60 2f 80 00 	jmp    *0x802f60(,%edx,4)
  8003d9:	89 df                	mov    %ebx,%edi
  8003db:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003e0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8003e3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8003e7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  8003ea:	8d 50 d0             	lea    -0x30(%eax),%edx
  8003ed:	83 fa 09             	cmp    $0x9,%edx
  8003f0:	77 33                	ja     800425 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003f2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003f5:	eb e9                	jmp    8003e0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fa:	8b 30                	mov    (%eax),%esi
  8003fc:	8d 40 04             	lea    0x4(%eax),%eax
  8003ff:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800402:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800404:	eb 1f                	jmp    800425 <vprintfmt+0xd1>
  800406:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800409:	85 ff                	test   %edi,%edi
  80040b:	b8 00 00 00 00       	mov    $0x0,%eax
  800410:	0f 49 c7             	cmovns %edi,%eax
  800413:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800416:	89 df                	mov    %ebx,%edi
  800418:	eb a0                	jmp    8003ba <vprintfmt+0x66>
  80041a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80041c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800423:	eb 95                	jmp    8003ba <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800425:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800429:	79 8f                	jns    8003ba <vprintfmt+0x66>
  80042b:	eb 85                	jmp    8003b2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80042d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800430:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800432:	eb 86                	jmp    8003ba <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800434:	8b 45 14             	mov    0x14(%ebp),%eax
  800437:	8d 70 04             	lea    0x4(%eax),%esi
  80043a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800441:	8b 45 14             	mov    0x14(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	89 04 24             	mov    %eax,(%esp)
  800449:	ff 55 08             	call   *0x8(%ebp)
  80044c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80044f:	e9 25 ff ff ff       	jmp    800379 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8d 70 04             	lea    0x4(%eax),%esi
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	99                   	cltd   
  80045d:	31 d0                	xor    %edx,%eax
  80045f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800461:	83 f8 15             	cmp    $0x15,%eax
  800464:	7f 0b                	jg     800471 <vprintfmt+0x11d>
  800466:	8b 14 85 c0 30 80 00 	mov    0x8030c0(,%eax,4),%edx
  80046d:	85 d2                	test   %edx,%edx
  80046f:	75 26                	jne    800497 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800471:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800475:	c7 44 24 08 2b 2e 80 	movl   $0x802e2b,0x8(%esp)
  80047c:	00 
  80047d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800480:	89 44 24 04          	mov    %eax,0x4(%esp)
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	89 04 24             	mov    %eax,(%esp)
  80048a:	e8 9d fe ff ff       	call   80032c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80048f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800492:	e9 e2 fe ff ff       	jmp    800379 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800497:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80049b:	c7 44 24 08 06 33 80 	movl   $0x803306,0x8(%esp)
  8004a2:	00 
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	89 04 24             	mov    %eax,(%esp)
  8004b0:	e8 77 fe ff ff       	call   80032c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004b5:	89 75 14             	mov    %esi,0x14(%ebp)
  8004b8:	e9 bc fe ff ff       	jmp    800379 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004c6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004ca:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004cc:	85 ff                	test   %edi,%edi
  8004ce:	b8 24 2e 80 00       	mov    $0x802e24,%eax
  8004d3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004d6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8004da:	0f 84 94 00 00 00    	je     800574 <vprintfmt+0x220>
  8004e0:	85 c9                	test   %ecx,%ecx
  8004e2:	0f 8e 94 00 00 00    	jle    80057c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ec:	89 3c 24             	mov    %edi,(%esp)
  8004ef:	e8 64 03 00 00       	call   800858 <strnlen>
  8004f4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8004f7:	29 c1                	sub    %eax,%ecx
  8004f9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  8004fc:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800500:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800503:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800506:	8b 75 08             	mov    0x8(%ebp),%esi
  800509:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80050c:	89 cb                	mov    %ecx,%ebx
  80050e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800510:	eb 0f                	jmp    800521 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800512:	8b 45 0c             	mov    0xc(%ebp),%eax
  800515:	89 44 24 04          	mov    %eax,0x4(%esp)
  800519:	89 3c 24             	mov    %edi,(%esp)
  80051c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80051e:	83 eb 01             	sub    $0x1,%ebx
  800521:	85 db                	test   %ebx,%ebx
  800523:	7f ed                	jg     800512 <vprintfmt+0x1be>
  800525:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800528:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80052b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80052e:	85 c9                	test   %ecx,%ecx
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
  800535:	0f 49 c1             	cmovns %ecx,%eax
  800538:	29 c1                	sub    %eax,%ecx
  80053a:	89 cb                	mov    %ecx,%ebx
  80053c:	eb 44                	jmp    800582 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80053e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800542:	74 1e                	je     800562 <vprintfmt+0x20e>
  800544:	0f be d2             	movsbl %dl,%edx
  800547:	83 ea 20             	sub    $0x20,%edx
  80054a:	83 fa 5e             	cmp    $0x5e,%edx
  80054d:	76 13                	jbe    800562 <vprintfmt+0x20e>
					putch('?', putdat);
  80054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800552:	89 44 24 04          	mov    %eax,0x4(%esp)
  800556:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80055d:	ff 55 08             	call   *0x8(%ebp)
  800560:	eb 0d                	jmp    80056f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800562:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800565:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800569:	89 04 24             	mov    %eax,(%esp)
  80056c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80056f:	83 eb 01             	sub    $0x1,%ebx
  800572:	eb 0e                	jmp    800582 <vprintfmt+0x22e>
  800574:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800577:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80057a:	eb 06                	jmp    800582 <vprintfmt+0x22e>
  80057c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80057f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800582:	83 c7 01             	add    $0x1,%edi
  800585:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800589:	0f be c2             	movsbl %dl,%eax
  80058c:	85 c0                	test   %eax,%eax
  80058e:	74 27                	je     8005b7 <vprintfmt+0x263>
  800590:	85 f6                	test   %esi,%esi
  800592:	78 aa                	js     80053e <vprintfmt+0x1ea>
  800594:	83 ee 01             	sub    $0x1,%esi
  800597:	79 a5                	jns    80053e <vprintfmt+0x1ea>
  800599:	89 d8                	mov    %ebx,%eax
  80059b:	8b 75 08             	mov    0x8(%ebp),%esi
  80059e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005a1:	89 c3                	mov    %eax,%ebx
  8005a3:	eb 18                	jmp    8005bd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005b0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005b2:	83 eb 01             	sub    $0x1,%ebx
  8005b5:	eb 06                	jmp    8005bd <vprintfmt+0x269>
  8005b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ba:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005bd:	85 db                	test   %ebx,%ebx
  8005bf:	7f e4                	jg     8005a5 <vprintfmt+0x251>
  8005c1:	89 75 08             	mov    %esi,0x8(%ebp)
  8005c4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005ca:	e9 aa fd ff ff       	jmp    800379 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005cf:	83 f9 01             	cmp    $0x1,%ecx
  8005d2:	7e 10                	jle    8005e4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8b 30                	mov    (%eax),%esi
  8005d9:	8b 78 04             	mov    0x4(%eax),%edi
  8005dc:	8d 40 08             	lea    0x8(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e2:	eb 26                	jmp    80060a <vprintfmt+0x2b6>
	else if (lflag)
  8005e4:	85 c9                	test   %ecx,%ecx
  8005e6:	74 12                	je     8005fa <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 30                	mov    (%eax),%esi
  8005ed:	89 f7                	mov    %esi,%edi
  8005ef:	c1 ff 1f             	sar    $0x1f,%edi
  8005f2:	8d 40 04             	lea    0x4(%eax),%eax
  8005f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f8:	eb 10                	jmp    80060a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 30                	mov    (%eax),%esi
  8005ff:	89 f7                	mov    %esi,%edi
  800601:	c1 ff 1f             	sar    $0x1f,%edi
  800604:	8d 40 04             	lea    0x4(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80060a:	89 f0                	mov    %esi,%eax
  80060c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80060e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800613:	85 ff                	test   %edi,%edi
  800615:	0f 89 3a 01 00 00    	jns    800755 <vprintfmt+0x401>
				putch('-', putdat);
  80061b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800622:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800629:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80062c:	89 f0                	mov    %esi,%eax
  80062e:	89 fa                	mov    %edi,%edx
  800630:	f7 d8                	neg    %eax
  800632:	83 d2 00             	adc    $0x0,%edx
  800635:	f7 da                	neg    %edx
			}
			base = 10;
  800637:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80063c:	e9 14 01 00 00       	jmp    800755 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800641:	83 f9 01             	cmp    $0x1,%ecx
  800644:	7e 13                	jle    800659 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 50 04             	mov    0x4(%eax),%edx
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	8b 75 14             	mov    0x14(%ebp),%esi
  800651:	8d 4e 08             	lea    0x8(%esi),%ecx
  800654:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800657:	eb 2c                	jmp    800685 <vprintfmt+0x331>
	else if (lflag)
  800659:	85 c9                	test   %ecx,%ecx
  80065b:	74 15                	je     800672 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	ba 00 00 00 00       	mov    $0x0,%edx
  800667:	8b 75 14             	mov    0x14(%ebp),%esi
  80066a:	8d 76 04             	lea    0x4(%esi),%esi
  80066d:	89 75 14             	mov    %esi,0x14(%ebp)
  800670:	eb 13                	jmp    800685 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	8b 75 14             	mov    0x14(%ebp),%esi
  80067f:	8d 76 04             	lea    0x4(%esi),%esi
  800682:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800685:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80068a:	e9 c6 00 00 00       	jmp    800755 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80068f:	83 f9 01             	cmp    $0x1,%ecx
  800692:	7e 13                	jle    8006a7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 50 04             	mov    0x4(%eax),%edx
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	8b 75 14             	mov    0x14(%ebp),%esi
  80069f:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006a2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006a5:	eb 24                	jmp    8006cb <vprintfmt+0x377>
	else if (lflag)
  8006a7:	85 c9                	test   %ecx,%ecx
  8006a9:	74 11                	je     8006bc <vprintfmt+0x368>
		return va_arg(*ap, long);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	99                   	cltd   
  8006b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8006b4:	8d 71 04             	lea    0x4(%ecx),%esi
  8006b7:	89 75 14             	mov    %esi,0x14(%ebp)
  8006ba:	eb 0f                	jmp    8006cb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	99                   	cltd   
  8006c2:	8b 75 14             	mov    0x14(%ebp),%esi
  8006c5:	8d 76 04             	lea    0x4(%esi),%esi
  8006c8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  8006cb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006d0:	e9 80 00 00 00       	jmp    800755 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006df:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006e6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006f0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006f7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006fa:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006fe:	8b 06                	mov    (%esi),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800705:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80070a:	eb 49                	jmp    800755 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80070c:	83 f9 01             	cmp    $0x1,%ecx
  80070f:	7e 13                	jle    800724 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 50 04             	mov    0x4(%eax),%edx
  800717:	8b 00                	mov    (%eax),%eax
  800719:	8b 75 14             	mov    0x14(%ebp),%esi
  80071c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80071f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800722:	eb 2c                	jmp    800750 <vprintfmt+0x3fc>
	else if (lflag)
  800724:	85 c9                	test   %ecx,%ecx
  800726:	74 15                	je     80073d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	ba 00 00 00 00       	mov    $0x0,%edx
  800732:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800735:	8d 71 04             	lea    0x4(%ecx),%esi
  800738:	89 75 14             	mov    %esi,0x14(%ebp)
  80073b:	eb 13                	jmp    800750 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	ba 00 00 00 00       	mov    $0x0,%edx
  800747:	8b 75 14             	mov    0x14(%ebp),%esi
  80074a:	8d 76 04             	lea    0x4(%esi),%esi
  80074d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800750:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800755:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800759:	89 74 24 10          	mov    %esi,0x10(%esp)
  80075d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800760:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800764:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800768:	89 04 24             	mov    %eax,(%esp)
  80076b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80076f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	e8 a6 fa ff ff       	call   800220 <printnum>
			break;
  80077a:	e9 fa fb ff ff       	jmp    800379 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80077f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800782:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800786:	89 04 24             	mov    %eax,(%esp)
  800789:	ff 55 08             	call   *0x8(%ebp)
			break;
  80078c:	e9 e8 fb ff ff       	jmp    800379 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800791:	8b 45 0c             	mov    0xc(%ebp),%eax
  800794:	89 44 24 04          	mov    %eax,0x4(%esp)
  800798:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80079f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007a2:	89 fb                	mov    %edi,%ebx
  8007a4:	eb 03                	jmp    8007a9 <vprintfmt+0x455>
  8007a6:	83 eb 01             	sub    $0x1,%ebx
  8007a9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007ad:	75 f7                	jne    8007a6 <vprintfmt+0x452>
  8007af:	90                   	nop
  8007b0:	e9 c4 fb ff ff       	jmp    800379 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007b5:	83 c4 3c             	add    $0x3c,%esp
  8007b8:	5b                   	pop    %ebx
  8007b9:	5e                   	pop    %esi
  8007ba:	5f                   	pop    %edi
  8007bb:	5d                   	pop    %ebp
  8007bc:	c3                   	ret    

008007bd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	83 ec 28             	sub    $0x28,%esp
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007cc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007d0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007da:	85 c0                	test   %eax,%eax
  8007dc:	74 30                	je     80080e <vsnprintf+0x51>
  8007de:	85 d2                	test   %edx,%edx
  8007e0:	7e 2c                	jle    80080e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007f7:	c7 04 24 0f 03 80 00 	movl   $0x80030f,(%esp)
  8007fe:	e8 51 fb ff ff       	call   800354 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800806:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80080c:	eb 05                	jmp    800813 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80080e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800813:	c9                   	leave  
  800814:	c3                   	ret    

00800815 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80081b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80081e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800822:	8b 45 10             	mov    0x10(%ebp),%eax
  800825:	89 44 24 08          	mov    %eax,0x8(%esp)
  800829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	89 04 24             	mov    %eax,(%esp)
  800836:	e8 82 ff ff ff       	call   8007bd <vsnprintf>
	va_end(ap);

	return rc;
}
  80083b:	c9                   	leave  
  80083c:	c3                   	ret    
  80083d:	66 90                	xchg   %ax,%ax
  80083f:	90                   	nop

00800840 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
  80084b:	eb 03                	jmp    800850 <strlen+0x10>
		n++;
  80084d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800850:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800854:	75 f7                	jne    80084d <strlen+0xd>
		n++;
	return n;
}
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800861:	b8 00 00 00 00       	mov    $0x0,%eax
  800866:	eb 03                	jmp    80086b <strnlen+0x13>
		n++;
  800868:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086b:	39 d0                	cmp    %edx,%eax
  80086d:	74 06                	je     800875 <strnlen+0x1d>
  80086f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800873:	75 f3                	jne    800868 <strnlen+0x10>
		n++;
	return n;
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800881:	89 c2                	mov    %eax,%edx
  800883:	83 c2 01             	add    $0x1,%edx
  800886:	83 c1 01             	add    $0x1,%ecx
  800889:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80088d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800890:	84 db                	test   %bl,%bl
  800892:	75 ef                	jne    800883 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800894:	5b                   	pop    %ebx
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a1:	89 1c 24             	mov    %ebx,(%esp)
  8008a4:	e8 97 ff ff ff       	call   800840 <strlen>
	strcpy(dst + len, src);
  8008a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008b0:	01 d8                	add    %ebx,%eax
  8008b2:	89 04 24             	mov    %eax,(%esp)
  8008b5:	e8 bd ff ff ff       	call   800877 <strcpy>
	return dst;
}
  8008ba:	89 d8                	mov    %ebx,%eax
  8008bc:	83 c4 08             	add    $0x8,%esp
  8008bf:	5b                   	pop    %ebx
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	56                   	push   %esi
  8008c6:	53                   	push   %ebx
  8008c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cd:	89 f3                	mov    %esi,%ebx
  8008cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d2:	89 f2                	mov    %esi,%edx
  8008d4:	eb 0f                	jmp    8008e5 <strncpy+0x23>
		*dst++ = *src;
  8008d6:	83 c2 01             	add    $0x1,%edx
  8008d9:	0f b6 01             	movzbl (%ecx),%eax
  8008dc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008df:	80 39 01             	cmpb   $0x1,(%ecx)
  8008e2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e5:	39 da                	cmp    %ebx,%edx
  8008e7:	75 ed                	jne    8008d6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008e9:	89 f0                	mov    %esi,%eax
  8008eb:	5b                   	pop    %ebx
  8008ec:	5e                   	pop    %esi
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	56                   	push   %esi
  8008f3:	53                   	push   %ebx
  8008f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008fd:	89 f0                	mov    %esi,%eax
  8008ff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800903:	85 c9                	test   %ecx,%ecx
  800905:	75 0b                	jne    800912 <strlcpy+0x23>
  800907:	eb 1d                	jmp    800926 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	83 c2 01             	add    $0x1,%edx
  80090f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800912:	39 d8                	cmp    %ebx,%eax
  800914:	74 0b                	je     800921 <strlcpy+0x32>
  800916:	0f b6 0a             	movzbl (%edx),%ecx
  800919:	84 c9                	test   %cl,%cl
  80091b:	75 ec                	jne    800909 <strlcpy+0x1a>
  80091d:	89 c2                	mov    %eax,%edx
  80091f:	eb 02                	jmp    800923 <strlcpy+0x34>
  800921:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800923:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800926:	29 f0                	sub    %esi,%eax
}
  800928:	5b                   	pop    %ebx
  800929:	5e                   	pop    %esi
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800932:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800935:	eb 06                	jmp    80093d <strcmp+0x11>
		p++, q++;
  800937:	83 c1 01             	add    $0x1,%ecx
  80093a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80093d:	0f b6 01             	movzbl (%ecx),%eax
  800940:	84 c0                	test   %al,%al
  800942:	74 04                	je     800948 <strcmp+0x1c>
  800944:	3a 02                	cmp    (%edx),%al
  800946:	74 ef                	je     800937 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800948:	0f b6 c0             	movzbl %al,%eax
  80094b:	0f b6 12             	movzbl (%edx),%edx
  80094e:	29 d0                	sub    %edx,%eax
}
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	53                   	push   %ebx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	89 c3                	mov    %eax,%ebx
  80095e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800961:	eb 06                	jmp    800969 <strncmp+0x17>
		n--, p++, q++;
  800963:	83 c0 01             	add    $0x1,%eax
  800966:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800969:	39 d8                	cmp    %ebx,%eax
  80096b:	74 15                	je     800982 <strncmp+0x30>
  80096d:	0f b6 08             	movzbl (%eax),%ecx
  800970:	84 c9                	test   %cl,%cl
  800972:	74 04                	je     800978 <strncmp+0x26>
  800974:	3a 0a                	cmp    (%edx),%cl
  800976:	74 eb                	je     800963 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800978:	0f b6 00             	movzbl (%eax),%eax
  80097b:	0f b6 12             	movzbl (%edx),%edx
  80097e:	29 d0                	sub    %edx,%eax
  800980:	eb 05                	jmp    800987 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800982:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800987:	5b                   	pop    %ebx
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800994:	eb 07                	jmp    80099d <strchr+0x13>
		if (*s == c)
  800996:	38 ca                	cmp    %cl,%dl
  800998:	74 0f                	je     8009a9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80099a:	83 c0 01             	add    $0x1,%eax
  80099d:	0f b6 10             	movzbl (%eax),%edx
  8009a0:	84 d2                	test   %dl,%dl
  8009a2:	75 f2                	jne    800996 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b5:	eb 07                	jmp    8009be <strfind+0x13>
		if (*s == c)
  8009b7:	38 ca                	cmp    %cl,%dl
  8009b9:	74 0a                	je     8009c5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009bb:	83 c0 01             	add    $0x1,%eax
  8009be:	0f b6 10             	movzbl (%eax),%edx
  8009c1:	84 d2                	test   %dl,%dl
  8009c3:	75 f2                	jne    8009b7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	57                   	push   %edi
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d3:	85 c9                	test   %ecx,%ecx
  8009d5:	74 36                	je     800a0d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009dd:	75 28                	jne    800a07 <memset+0x40>
  8009df:	f6 c1 03             	test   $0x3,%cl
  8009e2:	75 23                	jne    800a07 <memset+0x40>
		c &= 0xFF;
  8009e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e8:	89 d3                	mov    %edx,%ebx
  8009ea:	c1 e3 08             	shl    $0x8,%ebx
  8009ed:	89 d6                	mov    %edx,%esi
  8009ef:	c1 e6 18             	shl    $0x18,%esi
  8009f2:	89 d0                	mov    %edx,%eax
  8009f4:	c1 e0 10             	shl    $0x10,%eax
  8009f7:	09 f0                	or     %esi,%eax
  8009f9:	09 c2                	or     %eax,%edx
  8009fb:	89 d0                	mov    %edx,%eax
  8009fd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ff:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a02:	fc                   	cld    
  800a03:	f3 ab                	rep stos %eax,%es:(%edi)
  800a05:	eb 06                	jmp    800a0d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0a:	fc                   	cld    
  800a0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a0d:	89 f8                	mov    %edi,%eax
  800a0f:	5b                   	pop    %ebx
  800a10:	5e                   	pop    %esi
  800a11:	5f                   	pop    %edi
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a22:	39 c6                	cmp    %eax,%esi
  800a24:	73 35                	jae    800a5b <memmove+0x47>
  800a26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a29:	39 d0                	cmp    %edx,%eax
  800a2b:	73 2e                	jae    800a5b <memmove+0x47>
		s += n;
		d += n;
  800a2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a30:	89 d6                	mov    %edx,%esi
  800a32:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a34:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a3a:	75 13                	jne    800a4f <memmove+0x3b>
  800a3c:	f6 c1 03             	test   $0x3,%cl
  800a3f:	75 0e                	jne    800a4f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a41:	83 ef 04             	sub    $0x4,%edi
  800a44:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a47:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a4a:	fd                   	std    
  800a4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4d:	eb 09                	jmp    800a58 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a4f:	83 ef 01             	sub    $0x1,%edi
  800a52:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a55:	fd                   	std    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a58:	fc                   	cld    
  800a59:	eb 1d                	jmp    800a78 <memmove+0x64>
  800a5b:	89 f2                	mov    %esi,%edx
  800a5d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5f:	f6 c2 03             	test   $0x3,%dl
  800a62:	75 0f                	jne    800a73 <memmove+0x5f>
  800a64:	f6 c1 03             	test   $0x3,%cl
  800a67:	75 0a                	jne    800a73 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a69:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a6c:	89 c7                	mov    %eax,%edi
  800a6e:	fc                   	cld    
  800a6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a71:	eb 05                	jmp    800a78 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a73:	89 c7                	mov    %eax,%edi
  800a75:	fc                   	cld    
  800a76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a78:	5e                   	pop    %esi
  800a79:	5f                   	pop    %edi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a82:	8b 45 10             	mov    0x10(%ebp),%eax
  800a85:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	89 04 24             	mov    %eax,(%esp)
  800a96:	e8 79 ff ff ff       	call   800a14 <memmove>
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa8:	89 d6                	mov    %edx,%esi
  800aaa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aad:	eb 1a                	jmp    800ac9 <memcmp+0x2c>
		if (*s1 != *s2)
  800aaf:	0f b6 02             	movzbl (%edx),%eax
  800ab2:	0f b6 19             	movzbl (%ecx),%ebx
  800ab5:	38 d8                	cmp    %bl,%al
  800ab7:	74 0a                	je     800ac3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ab9:	0f b6 c0             	movzbl %al,%eax
  800abc:	0f b6 db             	movzbl %bl,%ebx
  800abf:	29 d8                	sub    %ebx,%eax
  800ac1:	eb 0f                	jmp    800ad2 <memcmp+0x35>
		s1++, s2++;
  800ac3:	83 c2 01             	add    $0x1,%edx
  800ac6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac9:	39 f2                	cmp    %esi,%edx
  800acb:	75 e2                	jne    800aaf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800adf:	89 c2                	mov    %eax,%edx
  800ae1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae4:	eb 07                	jmp    800aed <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae6:	38 08                	cmp    %cl,(%eax)
  800ae8:	74 07                	je     800af1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800aea:	83 c0 01             	add    $0x1,%eax
  800aed:	39 d0                	cmp    %edx,%eax
  800aef:	72 f5                	jb     800ae6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	57                   	push   %edi
  800af7:	56                   	push   %esi
  800af8:	53                   	push   %ebx
  800af9:	8b 55 08             	mov    0x8(%ebp),%edx
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aff:	eb 03                	jmp    800b04 <strtol+0x11>
		s++;
  800b01:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b04:	0f b6 0a             	movzbl (%edx),%ecx
  800b07:	80 f9 09             	cmp    $0x9,%cl
  800b0a:	74 f5                	je     800b01 <strtol+0xe>
  800b0c:	80 f9 20             	cmp    $0x20,%cl
  800b0f:	74 f0                	je     800b01 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b11:	80 f9 2b             	cmp    $0x2b,%cl
  800b14:	75 0a                	jne    800b20 <strtol+0x2d>
		s++;
  800b16:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b19:	bf 00 00 00 00       	mov    $0x0,%edi
  800b1e:	eb 11                	jmp    800b31 <strtol+0x3e>
  800b20:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b25:	80 f9 2d             	cmp    $0x2d,%cl
  800b28:	75 07                	jne    800b31 <strtol+0x3e>
		s++, neg = 1;
  800b2a:	8d 52 01             	lea    0x1(%edx),%edx
  800b2d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b31:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b36:	75 15                	jne    800b4d <strtol+0x5a>
  800b38:	80 3a 30             	cmpb   $0x30,(%edx)
  800b3b:	75 10                	jne    800b4d <strtol+0x5a>
  800b3d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b41:	75 0a                	jne    800b4d <strtol+0x5a>
		s += 2, base = 16;
  800b43:	83 c2 02             	add    $0x2,%edx
  800b46:	b8 10 00 00 00       	mov    $0x10,%eax
  800b4b:	eb 10                	jmp    800b5d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b4d:	85 c0                	test   %eax,%eax
  800b4f:	75 0c                	jne    800b5d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b51:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b53:	80 3a 30             	cmpb   $0x30,(%edx)
  800b56:	75 05                	jne    800b5d <strtol+0x6a>
		s++, base = 8;
  800b58:	83 c2 01             	add    $0x1,%edx
  800b5b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b62:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b65:	0f b6 0a             	movzbl (%edx),%ecx
  800b68:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b6b:	89 f0                	mov    %esi,%eax
  800b6d:	3c 09                	cmp    $0x9,%al
  800b6f:	77 08                	ja     800b79 <strtol+0x86>
			dig = *s - '0';
  800b71:	0f be c9             	movsbl %cl,%ecx
  800b74:	83 e9 30             	sub    $0x30,%ecx
  800b77:	eb 20                	jmp    800b99 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b79:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b7c:	89 f0                	mov    %esi,%eax
  800b7e:	3c 19                	cmp    $0x19,%al
  800b80:	77 08                	ja     800b8a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b82:	0f be c9             	movsbl %cl,%ecx
  800b85:	83 e9 57             	sub    $0x57,%ecx
  800b88:	eb 0f                	jmp    800b99 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b8a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b8d:	89 f0                	mov    %esi,%eax
  800b8f:	3c 19                	cmp    $0x19,%al
  800b91:	77 16                	ja     800ba9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b93:	0f be c9             	movsbl %cl,%ecx
  800b96:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b99:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b9c:	7d 0f                	jge    800bad <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b9e:	83 c2 01             	add    $0x1,%edx
  800ba1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ba5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ba7:	eb bc                	jmp    800b65 <strtol+0x72>
  800ba9:	89 d8                	mov    %ebx,%eax
  800bab:	eb 02                	jmp    800baf <strtol+0xbc>
  800bad:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb3:	74 05                	je     800bba <strtol+0xc7>
		*endptr = (char *) s;
  800bb5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bba:	f7 d8                	neg    %eax
  800bbc:	85 ff                	test   %edi,%edi
  800bbe:	0f 44 c3             	cmove  %ebx,%eax
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	89 c3                	mov    %eax,%ebx
  800bd9:	89 c7                	mov    %eax,%edi
  800bdb:	89 c6                	mov    %eax,%esi
  800bdd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bea:	ba 00 00 00 00       	mov    $0x0,%edx
  800bef:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf4:	89 d1                	mov    %edx,%ecx
  800bf6:	89 d3                	mov    %edx,%ebx
  800bf8:	89 d7                	mov    %edx,%edi
  800bfa:	89 d6                	mov    %edx,%esi
  800bfc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c11:	b8 03 00 00 00       	mov    $0x3,%eax
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	89 cb                	mov    %ecx,%ebx
  800c1b:	89 cf                	mov    %ecx,%edi
  800c1d:	89 ce                	mov    %ecx,%esi
  800c1f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c21:	85 c0                	test   %eax,%eax
  800c23:	7e 28                	jle    800c4d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c25:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c29:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c30:	00 
  800c31:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800c38:	00 
  800c39:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c40:	00 
  800c41:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800c48:	e8 b9 1d 00 00       	call   802a06 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c4d:	83 c4 2c             	add    $0x2c,%esp
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c63:	b8 04 00 00 00       	mov    $0x4,%eax
  800c68:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6b:	89 cb                	mov    %ecx,%ebx
  800c6d:	89 cf                	mov    %ecx,%edi
  800c6f:	89 ce                	mov    %ecx,%esi
  800c71:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c73:	85 c0                	test   %eax,%eax
  800c75:	7e 28                	jle    800c9f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c77:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c7b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c82:	00 
  800c83:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800c8a:	00 
  800c8b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c92:	00 
  800c93:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800c9a:	e8 67 1d 00 00       	call   802a06 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800c9f:	83 c4 2c             	add    $0x2c,%esp
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5f                   	pop    %edi
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    

00800ca7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	57                   	push   %edi
  800cab:	56                   	push   %esi
  800cac:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cad:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb2:	b8 02 00 00 00       	mov    $0x2,%eax
  800cb7:	89 d1                	mov    %edx,%ecx
  800cb9:	89 d3                	mov    %edx,%ebx
  800cbb:	89 d7                	mov    %edx,%edi
  800cbd:	89 d6                	mov    %edx,%esi
  800cbf:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <sys_yield>:

void
sys_yield(void)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccc:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cd6:	89 d1                	mov    %edx,%ecx
  800cd8:	89 d3                	mov    %edx,%ebx
  800cda:	89 d7                	mov    %edx,%edi
  800cdc:	89 d6                	mov    %edx,%esi
  800cde:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	57                   	push   %edi
  800ce9:	56                   	push   %esi
  800cea:	53                   	push   %ebx
  800ceb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cee:	be 00 00 00 00       	mov    $0x0,%esi
  800cf3:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d01:	89 f7                	mov    %esi,%edi
  800d03:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d05:	85 c0                	test   %eax,%eax
  800d07:	7e 28                	jle    800d31 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d09:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d0d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d14:	00 
  800d15:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800d1c:	00 
  800d1d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d24:	00 
  800d25:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800d2c:	e8 d5 1c 00 00       	call   802a06 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d31:	83 c4 2c             	add    $0x2c,%esp
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d42:	b8 06 00 00 00       	mov    $0x6,%eax
  800d47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d50:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d53:	8b 75 18             	mov    0x18(%ebp),%esi
  800d56:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d58:	85 c0                	test   %eax,%eax
  800d5a:	7e 28                	jle    800d84 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d60:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d67:	00 
  800d68:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800d6f:	00 
  800d70:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d77:	00 
  800d78:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800d7f:	e8 82 1c 00 00       	call   802a06 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d84:	83 c4 2c             	add    $0x2c,%esp
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
  800d92:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9a:	b8 07 00 00 00       	mov    $0x7,%eax
  800d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da2:	8b 55 08             	mov    0x8(%ebp),%edx
  800da5:	89 df                	mov    %ebx,%edi
  800da7:	89 de                	mov    %ebx,%esi
  800da9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dab:	85 c0                	test   %eax,%eax
  800dad:	7e 28                	jle    800dd7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800daf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800dba:	00 
  800dbb:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800dc2:	00 
  800dc3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dca:	00 
  800dcb:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800dd2:	e8 2f 1c 00 00       	call   802a06 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd7:	83 c4 2c             	add    $0x2c,%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	57                   	push   %edi
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dea:	b8 10 00 00 00       	mov    $0x10,%eax
  800def:	8b 55 08             	mov    0x8(%ebp),%edx
  800df2:	89 cb                	mov    %ecx,%ebx
  800df4:	89 cf                	mov    %ecx,%edi
  800df6:	89 ce                	mov    %ecx,%esi
  800df8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800dfa:	5b                   	pop    %ebx
  800dfb:	5e                   	pop    %esi
  800dfc:	5f                   	pop    %edi
  800dfd:	5d                   	pop    %ebp
  800dfe:	c3                   	ret    

00800dff <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	57                   	push   %edi
  800e03:	56                   	push   %esi
  800e04:	53                   	push   %ebx
  800e05:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e08:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e15:	8b 55 08             	mov    0x8(%ebp),%edx
  800e18:	89 df                	mov    %ebx,%edi
  800e1a:	89 de                	mov    %ebx,%esi
  800e1c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	7e 28                	jle    800e4a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e22:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e26:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e2d:	00 
  800e2e:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800e35:	00 
  800e36:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3d:	00 
  800e3e:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800e45:	e8 bc 1b 00 00       	call   802a06 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e4a:	83 c4 2c             	add    $0x2c,%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    

00800e52 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e60:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6b:	89 df                	mov    %ebx,%edi
  800e6d:	89 de                	mov    %ebx,%esi
  800e6f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e71:	85 c0                	test   %eax,%eax
  800e73:	7e 28                	jle    800e9d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e75:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e79:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e80:	00 
  800e81:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800e88:	00 
  800e89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e90:	00 
  800e91:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800e98:	e8 69 1b 00 00       	call   802a06 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e9d:	83 c4 2c             	add    $0x2c,%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    

00800ea5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
  800eab:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	89 df                	mov    %ebx,%edi
  800ec0:	89 de                	mov    %ebx,%esi
  800ec2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7e 28                	jle    800ef0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ecc:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800ed3:	00 
  800ed4:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800edb:	00 
  800edc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee3:	00 
  800ee4:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800eeb:	e8 16 1b 00 00       	call   802a06 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef0:	83 c4 2c             	add    $0x2c,%esp
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efe:	be 00 00 00 00       	mov    $0x0,%esi
  800f03:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f11:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f14:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
  800f21:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f24:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f29:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	89 cb                	mov    %ecx,%ebx
  800f33:	89 cf                	mov    %ecx,%edi
  800f35:	89 ce                	mov    %ecx,%esi
  800f37:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	7e 28                	jle    800f65 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f41:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800f48:	00 
  800f49:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  800f50:	00 
  800f51:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f58:	00 
  800f59:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  800f60:	e8 a1 1a 00 00       	call   802a06 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f65:	83 c4 2c             	add    $0x2c,%esp
  800f68:	5b                   	pop    %ebx
  800f69:	5e                   	pop    %esi
  800f6a:	5f                   	pop    %edi
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <sys_time_msec>:

unsigned int
sys_time_msec(void)
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
  800f73:	ba 00 00 00 00       	mov    $0x0,%edx
  800f78:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f7d:	89 d1                	mov    %edx,%ecx
  800f7f:	89 d3                	mov    %edx,%ebx
  800f81:	89 d7                	mov    %edx,%edi
  800f83:	89 d6                	mov    %edx,%esi
  800f85:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f87:	5b                   	pop    %ebx
  800f88:	5e                   	pop    %esi
  800f89:	5f                   	pop    %edi
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	57                   	push   %edi
  800f90:	56                   	push   %esi
  800f91:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f97:	b8 11 00 00 00       	mov    $0x11,%eax
  800f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	89 df                	mov    %ebx,%edi
  800fa4:	89 de                	mov    %ebx,%esi
  800fa6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb8:	b8 12 00 00 00       	mov    $0x12,%eax
  800fbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc3:	89 df                	mov    %ebx,%edi
  800fc5:	89 de                	mov    %ebx,%esi
  800fc7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  800fc9:	5b                   	pop    %ebx
  800fca:	5e                   	pop    %esi
  800fcb:	5f                   	pop    %edi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    

00800fce <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	57                   	push   %edi
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd9:	b8 13 00 00 00       	mov    $0x13,%eax
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	89 cb                	mov    %ecx,%ebx
  800fe3:	89 cf                	mov    %ecx,%edi
  800fe5:	89 ce                	mov    %ecx,%esi
  800fe7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  800fe9:	5b                   	pop    %ebx
  800fea:	5e                   	pop    %esi
  800feb:	5f                   	pop    %edi
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    

00800fee <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	57                   	push   %edi
  800ff2:	56                   	push   %esi
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 2c             	sub    $0x2c,%esp
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ffa:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  800ffc:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  800fff:	89 f8                	mov    %edi,%eax
  801001:	c1 e8 0c             	shr    $0xc,%eax
  801004:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801007:	e8 9b fc ff ff       	call   800ca7 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80100c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801012:	0f 84 de 00 00 00    	je     8010f6 <pgfault+0x108>
  801018:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  80101a:	85 c0                	test   %eax,%eax
  80101c:	79 20                	jns    80103e <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  80101e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801022:	c7 44 24 08 62 31 80 	movl   $0x803162,0x8(%esp)
  801029:	00 
  80102a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801031:	00 
  801032:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  801039:	e8 c8 19 00 00       	call   802a06 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  80103e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801041:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  801048:	25 05 08 00 00       	and    $0x805,%eax
  80104d:	3d 05 08 00 00       	cmp    $0x805,%eax
  801052:	0f 85 ba 00 00 00    	jne    801112 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801058:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80105f:	00 
  801060:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801067:	00 
  801068:	89 1c 24             	mov    %ebx,(%esp)
  80106b:	e8 75 fc ff ff       	call   800ce5 <sys_page_alloc>
  801070:	85 c0                	test   %eax,%eax
  801072:	79 20                	jns    801094 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  801074:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801078:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80107f:	00 
  801080:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801087:	00 
  801088:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80108f:	e8 72 19 00 00       	call   802a06 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801094:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80109a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8010a1:	00 
  8010a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010a6:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8010ad:	e8 62 f9 ff ff       	call   800a14 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  8010b2:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8010b9:	00 
  8010ba:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8010be:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8010c2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010c9:	00 
  8010ca:	89 1c 24             	mov    %ebx,(%esp)
  8010cd:	e8 67 fc ff ff       	call   800d39 <sys_page_map>
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	79 3c                	jns    801112 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  8010d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010da:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  8010e1:	00 
  8010e2:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8010e9:	00 
  8010ea:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8010f1:	e8 10 19 00 00       	call   802a06 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  8010f6:	c7 44 24 08 c0 31 80 	movl   $0x8031c0,0x8(%esp)
  8010fd:	00 
  8010fe:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801105:	00 
  801106:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80110d:	e8 f4 18 00 00       	call   802a06 <_panic>
}
  801112:	83 c4 2c             	add    $0x2c,%esp
  801115:	5b                   	pop    %ebx
  801116:	5e                   	pop    %esi
  801117:	5f                   	pop    %edi
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    

0080111a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	56                   	push   %esi
  80111e:	53                   	push   %ebx
  80111f:	83 ec 20             	sub    $0x20,%esp
  801122:	8b 75 08             	mov    0x8(%ebp),%esi
  801125:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801128:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80112f:	00 
  801130:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801134:	89 34 24             	mov    %esi,(%esp)
  801137:	e8 a9 fb ff ff       	call   800ce5 <sys_page_alloc>
  80113c:	85 c0                	test   %eax,%eax
  80113e:	79 20                	jns    801160 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  801140:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801144:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80114b:	00 
  80114c:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  801153:	00 
  801154:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80115b:	e8 a6 18 00 00       	call   802a06 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801160:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801167:	00 
  801168:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  80116f:	00 
  801170:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801177:	00 
  801178:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80117c:	89 34 24             	mov    %esi,(%esp)
  80117f:	e8 b5 fb ff ff       	call   800d39 <sys_page_map>
  801184:	85 c0                	test   %eax,%eax
  801186:	79 20                	jns    8011a8 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  801188:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80118c:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  801193:	00 
  801194:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80119b:	00 
  80119c:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8011a3:	e8 5e 18 00 00       	call   802a06 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8011a8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011af:	00 
  8011b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011b4:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8011bb:	e8 54 f8 ff ff       	call   800a14 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8011c0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8011c7:	00 
  8011c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011cf:	e8 b8 fb ff ff       	call   800d8c <sys_page_unmap>
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	79 20                	jns    8011f8 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8011d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011dc:	c7 44 24 08 ad 31 80 	movl   $0x8031ad,0x8(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8011eb:	00 
  8011ec:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8011f3:	e8 0e 18 00 00       	call   802a06 <_panic>

}
  8011f8:	83 c4 20             	add    $0x20,%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5d                   	pop    %ebp
  8011fe:	c3                   	ret    

008011ff <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	57                   	push   %edi
  801203:	56                   	push   %esi
  801204:	53                   	push   %ebx
  801205:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801208:	c7 04 24 ee 0f 80 00 	movl   $0x800fee,(%esp)
  80120f:	e8 48 18 00 00       	call   802a5c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801214:	b8 08 00 00 00       	mov    $0x8,%eax
  801219:	cd 30                	int    $0x30
  80121b:	89 c6                	mov    %eax,%esi
  80121d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801220:	85 c0                	test   %eax,%eax
  801222:	79 20                	jns    801244 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801224:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801228:	c7 44 24 08 e4 31 80 	movl   $0x8031e4,0x8(%esp)
  80122f:	00 
  801230:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  801237:	00 
  801238:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80123f:	e8 c2 17 00 00       	call   802a06 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801244:	bb 00 00 00 00       	mov    $0x0,%ebx
  801249:	85 c0                	test   %eax,%eax
  80124b:	75 21                	jne    80126e <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80124d:	e8 55 fa ff ff       	call   800ca7 <sys_getenvid>
  801252:	25 ff 03 00 00       	and    $0x3ff,%eax
  801257:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80125a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80125f:	a3 08 50 80 00       	mov    %eax,0x805008
		//set_pgfault_handler(pgfault);
		return 0;
  801264:	b8 00 00 00 00       	mov    $0x0,%eax
  801269:	e9 88 01 00 00       	jmp    8013f6 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  80126e:	89 d8                	mov    %ebx,%eax
  801270:	c1 e8 16             	shr    $0x16,%eax
  801273:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80127a:	a8 01                	test   $0x1,%al
  80127c:	0f 84 e0 00 00 00    	je     801362 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801282:	89 df                	mov    %ebx,%edi
  801284:	c1 ef 0c             	shr    $0xc,%edi
  801287:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  80128e:	a8 01                	test   $0x1,%al
  801290:	0f 84 c4 00 00 00    	je     80135a <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801296:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  80129d:	f6 c4 04             	test   $0x4,%ah
  8012a0:	74 0d                	je     8012af <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  8012a2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012a7:	83 c8 05             	or     $0x5,%eax
  8012aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012ad:	eb 1b                	jmp    8012ca <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  8012af:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  8012b4:	83 f8 01             	cmp    $0x1,%eax
  8012b7:	19 c0                	sbb    %eax,%eax
  8012b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012bc:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  8012c3:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  8012ca:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  8012cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012d4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012df:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ea:	e8 4a fa ff ff       	call   800d39 <sys_page_map>
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	79 20                	jns    801313 <fork+0x114>
		panic("sys_page_map: %e", r);
  8012f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012f7:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  8012fe:	00 
  8012ff:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801306:	00 
  801307:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80130e:	e8 f3 16 00 00       	call   802a06 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801316:	89 44 24 10          	mov    %eax,0x10(%esp)
  80131a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80131e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801325:	00 
  801326:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80132a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801331:	e8 03 fa ff ff       	call   800d39 <sys_page_map>
  801336:	85 c0                	test   %eax,%eax
  801338:	79 20                	jns    80135a <fork+0x15b>
		panic("sys_page_map: %e", r);
  80133a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80133e:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  801345:	00 
  801346:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  80134d:	00 
  80134e:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  801355:	e8 ac 16 00 00       	call   802a06 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  80135a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801360:	eb 06                	jmp    801368 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  801362:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  801368:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  80136e:	0f 86 fa fe ff ff    	jbe    80126e <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801374:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80137b:	00 
  80137c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801383:	ee 
  801384:	89 34 24             	mov    %esi,(%esp)
  801387:	e8 59 f9 ff ff       	call   800ce5 <sys_page_alloc>
  80138c:	85 c0                	test   %eax,%eax
  80138e:	79 20                	jns    8013b0 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801390:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801394:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80139b:	00 
  80139c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  8013a3:	00 
  8013a4:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8013ab:	e8 56 16 00 00       	call   802a06 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8013b0:	c7 44 24 04 ef 2a 80 	movl   $0x802aef,0x4(%esp)
  8013b7:	00 
  8013b8:	89 34 24             	mov    %esi,(%esp)
  8013bb:	e8 e5 fa ff ff       	call   800ea5 <sys_env_set_pgfault_upcall>
  8013c0:	85 c0                	test   %eax,%eax
  8013c2:	79 20                	jns    8013e4 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  8013c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013c8:	c7 44 24 08 08 32 80 	movl   $0x803208,0x8(%esp)
  8013cf:	00 
  8013d0:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  8013d7:	00 
  8013d8:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8013df:	e8 22 16 00 00       	call   802a06 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  8013e4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013eb:	00 
  8013ec:	89 34 24             	mov    %esi,(%esp)
  8013ef:	e8 0b fa ff ff       	call   800dff <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  8013f4:	89 f0                	mov    %esi,%eax

}
  8013f6:	83 c4 2c             	add    $0x2c,%esp
  8013f9:	5b                   	pop    %ebx
  8013fa:	5e                   	pop    %esi
  8013fb:	5f                   	pop    %edi
  8013fc:	5d                   	pop    %ebp
  8013fd:	c3                   	ret    

008013fe <sfork>:

// Challenge!
int
sfork(void)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	57                   	push   %edi
  801402:	56                   	push   %esi
  801403:	53                   	push   %ebx
  801404:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801407:	c7 04 24 ee 0f 80 00 	movl   $0x800fee,(%esp)
  80140e:	e8 49 16 00 00       	call   802a5c <set_pgfault_handler>
  801413:	b8 08 00 00 00       	mov    $0x8,%eax
  801418:	cd 30                	int    $0x30
  80141a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  80141c:	85 c0                	test   %eax,%eax
  80141e:	79 20                	jns    801440 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801420:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801424:	c7 44 24 08 e4 31 80 	movl   $0x8031e4,0x8(%esp)
  80142b:	00 
  80142c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  801433:	00 
  801434:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80143b:	e8 c6 15 00 00       	call   802a06 <_panic>
  801440:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801442:	bb 00 00 00 00       	mov    $0x0,%ebx
  801447:	85 c0                	test   %eax,%eax
  801449:	75 2d                	jne    801478 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80144b:	e8 57 f8 ff ff       	call   800ca7 <sys_getenvid>
  801450:	25 ff 03 00 00       	and    $0x3ff,%eax
  801455:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801458:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80145d:	a3 08 50 80 00       	mov    %eax,0x805008
		set_pgfault_handler(pgfault);
  801462:	c7 04 24 ee 0f 80 00 	movl   $0x800fee,(%esp)
  801469:	e8 ee 15 00 00       	call   802a5c <set_pgfault_handler>
		return 0;
  80146e:	b8 00 00 00 00       	mov    $0x0,%eax
  801473:	e9 1d 01 00 00       	jmp    801595 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801478:	89 d8                	mov    %ebx,%eax
  80147a:	c1 e8 16             	shr    $0x16,%eax
  80147d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801484:	a8 01                	test   $0x1,%al
  801486:	74 69                	je     8014f1 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801488:	89 d8                	mov    %ebx,%eax
  80148a:	c1 e8 0c             	shr    $0xc,%eax
  80148d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801494:	f6 c2 01             	test   $0x1,%dl
  801497:	74 50                	je     8014e9 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801499:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  8014a0:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  8014a3:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  8014a9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8014ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014b1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c0:	e8 74 f8 ff ff       	call   800d39 <sys_page_map>
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	79 20                	jns    8014e9 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  8014c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014cd:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  8014d4:	00 
  8014d5:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8014dc:	00 
  8014dd:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  8014e4:	e8 1d 15 00 00       	call   802a06 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8014e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014ef:	eb 06                	jmp    8014f7 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  8014f1:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  8014f7:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  8014fd:	0f 86 75 ff ff ff    	jbe    801478 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801503:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  80150a:	ee 
  80150b:	89 34 24             	mov    %esi,(%esp)
  80150e:	e8 07 fc ff ff       	call   80111a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801513:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80151a:	00 
  80151b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801522:	ee 
  801523:	89 34 24             	mov    %esi,(%esp)
  801526:	e8 ba f7 ff ff       	call   800ce5 <sys_page_alloc>
  80152b:	85 c0                	test   %eax,%eax
  80152d:	79 20                	jns    80154f <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  80152f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801533:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80153a:	00 
  80153b:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  801542:	00 
  801543:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80154a:	e8 b7 14 00 00       	call   802a06 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80154f:	c7 44 24 04 ef 2a 80 	movl   $0x802aef,0x4(%esp)
  801556:	00 
  801557:	89 34 24             	mov    %esi,(%esp)
  80155a:	e8 46 f9 ff ff       	call   800ea5 <sys_env_set_pgfault_upcall>
  80155f:	85 c0                	test   %eax,%eax
  801561:	79 20                	jns    801583 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  801563:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801567:	c7 44 24 08 08 32 80 	movl   $0x803208,0x8(%esp)
  80156e:	00 
  80156f:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  801576:	00 
  801577:	c7 04 24 7e 31 80 00 	movl   $0x80317e,(%esp)
  80157e:	e8 83 14 00 00       	call   802a06 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801583:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80158a:	00 
  80158b:	89 34 24             	mov    %esi,(%esp)
  80158e:	e8 6c f8 ff ff       	call   800dff <sys_env_set_status>
	return envid;
  801593:	89 f0                	mov    %esi,%eax

}
  801595:	83 c4 2c             	add    $0x2c,%esp
  801598:	5b                   	pop    %ebx
  801599:	5e                   	pop    %esi
  80159a:	5f                   	pop    %edi
  80159b:	5d                   	pop    %ebp
  80159c:	c3                   	ret    
  80159d:	66 90                	xchg   %ax,%ax
  80159f:	90                   	nop

008015a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	56                   	push   %esi
  8015a4:	53                   	push   %ebx
  8015a5:	83 ec 10             	sub    $0x10,%esp
  8015a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8015b1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8015b3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8015b8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8015bb:	89 04 24             	mov    %eax,(%esp)
  8015be:	e8 58 f9 ff ff       	call   800f1b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	75 26                	jne    8015ed <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8015c7:	85 f6                	test   %esi,%esi
  8015c9:	74 0a                	je     8015d5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8015cb:	a1 08 50 80 00       	mov    0x805008,%eax
  8015d0:	8b 40 74             	mov    0x74(%eax),%eax
  8015d3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  8015d5:	85 db                	test   %ebx,%ebx
  8015d7:	74 0a                	je     8015e3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  8015d9:	a1 08 50 80 00       	mov    0x805008,%eax
  8015de:	8b 40 78             	mov    0x78(%eax),%eax
  8015e1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8015e3:	a1 08 50 80 00       	mov    0x805008,%eax
  8015e8:	8b 40 70             	mov    0x70(%eax),%eax
  8015eb:	eb 14                	jmp    801601 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  8015ed:	85 f6                	test   %esi,%esi
  8015ef:	74 06                	je     8015f7 <ipc_recv+0x57>
			*from_env_store = 0;
  8015f1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8015f7:	85 db                	test   %ebx,%ebx
  8015f9:	74 06                	je     801601 <ipc_recv+0x61>
			*perm_store = 0;
  8015fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	5b                   	pop    %ebx
  801605:	5e                   	pop    %esi
  801606:	5d                   	pop    %ebp
  801607:	c3                   	ret    

00801608 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	57                   	push   %edi
  80160c:	56                   	push   %esi
  80160d:	53                   	push   %ebx
  80160e:	83 ec 1c             	sub    $0x1c,%esp
  801611:	8b 7d 08             	mov    0x8(%ebp),%edi
  801614:	8b 75 0c             	mov    0xc(%ebp),%esi
  801617:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80161a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80161c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  801621:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801624:	8b 45 14             	mov    0x14(%ebp),%eax
  801627:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80162b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80162f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801633:	89 3c 24             	mov    %edi,(%esp)
  801636:	e8 bd f8 ff ff       	call   800ef8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80163b:	85 c0                	test   %eax,%eax
  80163d:	74 28                	je     801667 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80163f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801642:	74 1c                	je     801660 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  801644:	c7 44 24 08 2c 32 80 	movl   $0x80322c,0x8(%esp)
  80164b:	00 
  80164c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801653:	00 
  801654:	c7 04 24 4d 32 80 00 	movl   $0x80324d,(%esp)
  80165b:	e8 a6 13 00 00       	call   802a06 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  801660:	e8 61 f6 ff ff       	call   800cc6 <sys_yield>
	}
  801665:	eb bd                	jmp    801624 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  801667:	83 c4 1c             	add    $0x1c,%esp
  80166a:	5b                   	pop    %ebx
  80166b:	5e                   	pop    %esi
  80166c:	5f                   	pop    %edi
  80166d:	5d                   	pop    %ebp
  80166e:	c3                   	ret    

0080166f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80167a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80167d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801683:	8b 52 50             	mov    0x50(%edx),%edx
  801686:	39 ca                	cmp    %ecx,%edx
  801688:	75 0d                	jne    801697 <ipc_find_env+0x28>
			return envs[i].env_id;
  80168a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80168d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801692:	8b 40 40             	mov    0x40(%eax),%eax
  801695:	eb 0e                	jmp    8016a5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801697:	83 c0 01             	add    $0x1,%eax
  80169a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80169f:	75 d9                	jne    80167a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8016a1:	66 b8 00 00          	mov    $0x0,%ax
}
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    
  8016a7:	66 90                	xchg   %ax,%ax
  8016a9:	66 90                	xchg   %ax,%ax
  8016ab:	66 90                	xchg   %ax,%ax
  8016ad:	66 90                	xchg   %ax,%ax
  8016af:	90                   	nop

008016b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8016bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    

008016c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8016cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016d0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016d5:	5d                   	pop    %ebp
  8016d6:	c3                   	ret    

008016d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016dd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016e2:	89 c2                	mov    %eax,%edx
  8016e4:	c1 ea 16             	shr    $0x16,%edx
  8016e7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016ee:	f6 c2 01             	test   $0x1,%dl
  8016f1:	74 11                	je     801704 <fd_alloc+0x2d>
  8016f3:	89 c2                	mov    %eax,%edx
  8016f5:	c1 ea 0c             	shr    $0xc,%edx
  8016f8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016ff:	f6 c2 01             	test   $0x1,%dl
  801702:	75 09                	jne    80170d <fd_alloc+0x36>
			*fd_store = fd;
  801704:	89 01                	mov    %eax,(%ecx)
			return 0;
  801706:	b8 00 00 00 00       	mov    $0x0,%eax
  80170b:	eb 17                	jmp    801724 <fd_alloc+0x4d>
  80170d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801712:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801717:	75 c9                	jne    8016e2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801719:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80171f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    

00801726 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80172c:	83 f8 1f             	cmp    $0x1f,%eax
  80172f:	77 36                	ja     801767 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801731:	c1 e0 0c             	shl    $0xc,%eax
  801734:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801739:	89 c2                	mov    %eax,%edx
  80173b:	c1 ea 16             	shr    $0x16,%edx
  80173e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801745:	f6 c2 01             	test   $0x1,%dl
  801748:	74 24                	je     80176e <fd_lookup+0x48>
  80174a:	89 c2                	mov    %eax,%edx
  80174c:	c1 ea 0c             	shr    $0xc,%edx
  80174f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801756:	f6 c2 01             	test   $0x1,%dl
  801759:	74 1a                	je     801775 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80175b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175e:	89 02                	mov    %eax,(%edx)
	return 0;
  801760:	b8 00 00 00 00       	mov    $0x0,%eax
  801765:	eb 13                	jmp    80177a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801767:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176c:	eb 0c                	jmp    80177a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80176e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801773:	eb 05                	jmp    80177a <fd_lookup+0x54>
  801775:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80177a:	5d                   	pop    %ebp
  80177b:	c3                   	ret    

0080177c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 18             	sub    $0x18,%esp
  801782:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801785:	ba 00 00 00 00       	mov    $0x0,%edx
  80178a:	eb 13                	jmp    80179f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80178c:	39 08                	cmp    %ecx,(%eax)
  80178e:	75 0c                	jne    80179c <dev_lookup+0x20>
			*dev = devtab[i];
  801790:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801793:	89 01                	mov    %eax,(%ecx)
			return 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
  80179a:	eb 38                	jmp    8017d4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80179c:	83 c2 01             	add    $0x1,%edx
  80179f:	8b 04 95 d4 32 80 00 	mov    0x8032d4(,%edx,4),%eax
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	75 e2                	jne    80178c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017aa:	a1 08 50 80 00       	mov    0x805008,%eax
  8017af:	8b 40 48             	mov    0x48(%eax),%eax
  8017b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ba:	c7 04 24 58 32 80 00 	movl   $0x803258,(%esp)
  8017c1:	e8 39 ea ff ff       	call   8001ff <cprintf>
	*dev = 0;
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	56                   	push   %esi
  8017da:	53                   	push   %ebx
  8017db:	83 ec 20             	sub    $0x20,%esp
  8017de:	8b 75 08             	mov    0x8(%ebp),%esi
  8017e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017eb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017f1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017f4:	89 04 24             	mov    %eax,(%esp)
  8017f7:	e8 2a ff ff ff       	call   801726 <fd_lookup>
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	78 05                	js     801805 <fd_close+0x2f>
	    || fd != fd2)
  801800:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801803:	74 0c                	je     801811 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801805:	84 db                	test   %bl,%bl
  801807:	ba 00 00 00 00       	mov    $0x0,%edx
  80180c:	0f 44 c2             	cmove  %edx,%eax
  80180f:	eb 3f                	jmp    801850 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801811:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801814:	89 44 24 04          	mov    %eax,0x4(%esp)
  801818:	8b 06                	mov    (%esi),%eax
  80181a:	89 04 24             	mov    %eax,(%esp)
  80181d:	e8 5a ff ff ff       	call   80177c <dev_lookup>
  801822:	89 c3                	mov    %eax,%ebx
  801824:	85 c0                	test   %eax,%eax
  801826:	78 16                	js     80183e <fd_close+0x68>
		if (dev->dev_close)
  801828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80182e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801833:	85 c0                	test   %eax,%eax
  801835:	74 07                	je     80183e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801837:	89 34 24             	mov    %esi,(%esp)
  80183a:	ff d0                	call   *%eax
  80183c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80183e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801842:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801849:	e8 3e f5 ff ff       	call   800d8c <sys_page_unmap>
	return r;
  80184e:	89 d8                	mov    %ebx,%eax
}
  801850:	83 c4 20             	add    $0x20,%esp
  801853:	5b                   	pop    %ebx
  801854:	5e                   	pop    %esi
  801855:	5d                   	pop    %ebp
  801856:	c3                   	ret    

00801857 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80185d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801860:	89 44 24 04          	mov    %eax,0x4(%esp)
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	89 04 24             	mov    %eax,(%esp)
  80186a:	e8 b7 fe ff ff       	call   801726 <fd_lookup>
  80186f:	89 c2                	mov    %eax,%edx
  801871:	85 d2                	test   %edx,%edx
  801873:	78 13                	js     801888 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801875:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80187c:	00 
  80187d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801880:	89 04 24             	mov    %eax,(%esp)
  801883:	e8 4e ff ff ff       	call   8017d6 <fd_close>
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <close_all>:

void
close_all(void)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	53                   	push   %ebx
  80188e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801891:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801896:	89 1c 24             	mov    %ebx,(%esp)
  801899:	e8 b9 ff ff ff       	call   801857 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80189e:	83 c3 01             	add    $0x1,%ebx
  8018a1:	83 fb 20             	cmp    $0x20,%ebx
  8018a4:	75 f0                	jne    801896 <close_all+0xc>
		close(i);
}
  8018a6:	83 c4 14             	add    $0x14,%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    

008018ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	57                   	push   %edi
  8018b0:	56                   	push   %esi
  8018b1:	53                   	push   %ebx
  8018b2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 04 24             	mov    %eax,(%esp)
  8018c2:	e8 5f fe ff ff       	call   801726 <fd_lookup>
  8018c7:	89 c2                	mov    %eax,%edx
  8018c9:	85 d2                	test   %edx,%edx
  8018cb:	0f 88 e1 00 00 00    	js     8019b2 <dup+0x106>
		return r;
	close(newfdnum);
  8018d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d4:	89 04 24             	mov    %eax,(%esp)
  8018d7:	e8 7b ff ff ff       	call   801857 <close>

	newfd = INDEX2FD(newfdnum);
  8018dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018df:	c1 e3 0c             	shl    $0xc,%ebx
  8018e2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8018e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018eb:	89 04 24             	mov    %eax,(%esp)
  8018ee:	e8 cd fd ff ff       	call   8016c0 <fd2data>
  8018f3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8018f5:	89 1c 24             	mov    %ebx,(%esp)
  8018f8:	e8 c3 fd ff ff       	call   8016c0 <fd2data>
  8018fd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018ff:	89 f0                	mov    %esi,%eax
  801901:	c1 e8 16             	shr    $0x16,%eax
  801904:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80190b:	a8 01                	test   $0x1,%al
  80190d:	74 43                	je     801952 <dup+0xa6>
  80190f:	89 f0                	mov    %esi,%eax
  801911:	c1 e8 0c             	shr    $0xc,%eax
  801914:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80191b:	f6 c2 01             	test   $0x1,%dl
  80191e:	74 32                	je     801952 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801920:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801927:	25 07 0e 00 00       	and    $0xe07,%eax
  80192c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801930:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801934:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80193b:	00 
  80193c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801940:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801947:	e8 ed f3 ff ff       	call   800d39 <sys_page_map>
  80194c:	89 c6                	mov    %eax,%esi
  80194e:	85 c0                	test   %eax,%eax
  801950:	78 3e                	js     801990 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801955:	89 c2                	mov    %eax,%edx
  801957:	c1 ea 0c             	shr    $0xc,%edx
  80195a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801961:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801967:	89 54 24 10          	mov    %edx,0x10(%esp)
  80196b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80196f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801976:	00 
  801977:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801982:	e8 b2 f3 ff ff       	call   800d39 <sys_page_map>
  801987:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80198c:	85 f6                	test   %esi,%esi
  80198e:	79 22                	jns    8019b2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801990:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801994:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80199b:	e8 ec f3 ff ff       	call   800d8c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ab:	e8 dc f3 ff ff       	call   800d8c <sys_page_unmap>
	return r;
  8019b0:	89 f0                	mov    %esi,%eax
}
  8019b2:	83 c4 3c             	add    $0x3c,%esp
  8019b5:	5b                   	pop    %ebx
  8019b6:	5e                   	pop    %esi
  8019b7:	5f                   	pop    %edi
  8019b8:	5d                   	pop    %ebp
  8019b9:	c3                   	ret    

008019ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	53                   	push   %ebx
  8019be:	83 ec 24             	sub    $0x24,%esp
  8019c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cb:	89 1c 24             	mov    %ebx,(%esp)
  8019ce:	e8 53 fd ff ff       	call   801726 <fd_lookup>
  8019d3:	89 c2                	mov    %eax,%edx
  8019d5:	85 d2                	test   %edx,%edx
  8019d7:	78 6d                	js     801a46 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e3:	8b 00                	mov    (%eax),%eax
  8019e5:	89 04 24             	mov    %eax,(%esp)
  8019e8:	e8 8f fd ff ff       	call   80177c <dev_lookup>
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 55                	js     801a46 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f4:	8b 50 08             	mov    0x8(%eax),%edx
  8019f7:	83 e2 03             	and    $0x3,%edx
  8019fa:	83 fa 01             	cmp    $0x1,%edx
  8019fd:	75 23                	jne    801a22 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019ff:	a1 08 50 80 00       	mov    0x805008,%eax
  801a04:	8b 40 48             	mov    0x48(%eax),%eax
  801a07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0f:	c7 04 24 99 32 80 00 	movl   $0x803299,(%esp)
  801a16:	e8 e4 e7 ff ff       	call   8001ff <cprintf>
		return -E_INVAL;
  801a1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a20:	eb 24                	jmp    801a46 <read+0x8c>
	}
	if (!dev->dev_read)
  801a22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a25:	8b 52 08             	mov    0x8(%edx),%edx
  801a28:	85 d2                	test   %edx,%edx
  801a2a:	74 15                	je     801a41 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a36:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a3a:	89 04 24             	mov    %eax,(%esp)
  801a3d:	ff d2                	call   *%edx
  801a3f:	eb 05                	jmp    801a46 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801a41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801a46:	83 c4 24             	add    $0x24,%esp
  801a49:	5b                   	pop    %ebx
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    

00801a4c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	57                   	push   %edi
  801a50:	56                   	push   %esi
  801a51:	53                   	push   %ebx
  801a52:	83 ec 1c             	sub    $0x1c,%esp
  801a55:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a58:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a60:	eb 23                	jmp    801a85 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a62:	89 f0                	mov    %esi,%eax
  801a64:	29 d8                	sub    %ebx,%eax
  801a66:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a6a:	89 d8                	mov    %ebx,%eax
  801a6c:	03 45 0c             	add    0xc(%ebp),%eax
  801a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a73:	89 3c 24             	mov    %edi,(%esp)
  801a76:	e8 3f ff ff ff       	call   8019ba <read>
		if (m < 0)
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 10                	js     801a8f <readn+0x43>
			return m;
		if (m == 0)
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	74 0a                	je     801a8d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a83:	01 c3                	add    %eax,%ebx
  801a85:	39 f3                	cmp    %esi,%ebx
  801a87:	72 d9                	jb     801a62 <readn+0x16>
  801a89:	89 d8                	mov    %ebx,%eax
  801a8b:	eb 02                	jmp    801a8f <readn+0x43>
  801a8d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a8f:	83 c4 1c             	add    $0x1c,%esp
  801a92:	5b                   	pop    %ebx
  801a93:	5e                   	pop    %esi
  801a94:	5f                   	pop    %edi
  801a95:	5d                   	pop    %ebp
  801a96:	c3                   	ret    

00801a97 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	53                   	push   %ebx
  801a9b:	83 ec 24             	sub    $0x24,%esp
  801a9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa8:	89 1c 24             	mov    %ebx,(%esp)
  801aab:	e8 76 fc ff ff       	call   801726 <fd_lookup>
  801ab0:	89 c2                	mov    %eax,%edx
  801ab2:	85 d2                	test   %edx,%edx
  801ab4:	78 68                	js     801b1e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac0:	8b 00                	mov    (%eax),%eax
  801ac2:	89 04 24             	mov    %eax,(%esp)
  801ac5:	e8 b2 fc ff ff       	call   80177c <dev_lookup>
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 50                	js     801b1e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ad5:	75 23                	jne    801afa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ad7:	a1 08 50 80 00       	mov    0x805008,%eax
  801adc:	8b 40 48             	mov    0x48(%eax),%eax
  801adf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae7:	c7 04 24 b5 32 80 00 	movl   $0x8032b5,(%esp)
  801aee:	e8 0c e7 ff ff       	call   8001ff <cprintf>
		return -E_INVAL;
  801af3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801af8:	eb 24                	jmp    801b1e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801afd:	8b 52 0c             	mov    0xc(%edx),%edx
  801b00:	85 d2                	test   %edx,%edx
  801b02:	74 15                	je     801b19 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b12:	89 04 24             	mov    %eax,(%esp)
  801b15:	ff d2                	call   *%edx
  801b17:	eb 05                	jmp    801b1e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801b19:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801b1e:	83 c4 24             	add    $0x24,%esp
  801b21:	5b                   	pop    %ebx
  801b22:	5d                   	pop    %ebp
  801b23:	c3                   	ret    

00801b24 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b2a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	89 04 24             	mov    %eax,(%esp)
  801b37:	e8 ea fb ff ff       	call   801726 <fd_lookup>
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	78 0e                	js     801b4e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801b40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	53                   	push   %ebx
  801b54:	83 ec 24             	sub    $0x24,%esp
  801b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b61:	89 1c 24             	mov    %ebx,(%esp)
  801b64:	e8 bd fb ff ff       	call   801726 <fd_lookup>
  801b69:	89 c2                	mov    %eax,%edx
  801b6b:	85 d2                	test   %edx,%edx
  801b6d:	78 61                	js     801bd0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b79:	8b 00                	mov    (%eax),%eax
  801b7b:	89 04 24             	mov    %eax,(%esp)
  801b7e:	e8 f9 fb ff ff       	call   80177c <dev_lookup>
  801b83:	85 c0                	test   %eax,%eax
  801b85:	78 49                	js     801bd0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b8e:	75 23                	jne    801bb3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801b90:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b95:	8b 40 48             	mov    0x48(%eax),%eax
  801b98:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba0:	c7 04 24 78 32 80 00 	movl   $0x803278,(%esp)
  801ba7:	e8 53 e6 ff ff       	call   8001ff <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801bac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bb1:	eb 1d                	jmp    801bd0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801bb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb6:	8b 52 18             	mov    0x18(%edx),%edx
  801bb9:	85 d2                	test   %edx,%edx
  801bbb:	74 0e                	je     801bcb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801bbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bc0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bc4:	89 04 24             	mov    %eax,(%esp)
  801bc7:	ff d2                	call   *%edx
  801bc9:	eb 05                	jmp    801bd0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801bcb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801bd0:	83 c4 24             	add    $0x24,%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5d                   	pop    %ebp
  801bd5:	c3                   	ret    

00801bd6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	53                   	push   %ebx
  801bda:	83 ec 24             	sub    $0x24,%esp
  801bdd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801be0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801be3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	89 04 24             	mov    %eax,(%esp)
  801bed:	e8 34 fb ff ff       	call   801726 <fd_lookup>
  801bf2:	89 c2                	mov    %eax,%edx
  801bf4:	85 d2                	test   %edx,%edx
  801bf6:	78 52                	js     801c4a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bf8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c02:	8b 00                	mov    (%eax),%eax
  801c04:	89 04 24             	mov    %eax,(%esp)
  801c07:	e8 70 fb ff ff       	call   80177c <dev_lookup>
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	78 3a                	js     801c4a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c13:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c17:	74 2c                	je     801c45 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c19:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c1c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c23:	00 00 00 
	stat->st_isdir = 0;
  801c26:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c2d:	00 00 00 
	stat->st_dev = dev;
  801c30:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c3d:	89 14 24             	mov    %edx,(%esp)
  801c40:	ff 50 14             	call   *0x14(%eax)
  801c43:	eb 05                	jmp    801c4a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801c45:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801c4a:	83 c4 24             	add    $0x24,%esp
  801c4d:	5b                   	pop    %ebx
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    

00801c50 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	56                   	push   %esi
  801c54:	53                   	push   %ebx
  801c55:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c58:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c5f:	00 
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	89 04 24             	mov    %eax,(%esp)
  801c66:	e8 99 02 00 00       	call   801f04 <open>
  801c6b:	89 c3                	mov    %eax,%ebx
  801c6d:	85 db                	test   %ebx,%ebx
  801c6f:	78 1b                	js     801c8c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c78:	89 1c 24             	mov    %ebx,(%esp)
  801c7b:	e8 56 ff ff ff       	call   801bd6 <fstat>
  801c80:	89 c6                	mov    %eax,%esi
	close(fd);
  801c82:	89 1c 24             	mov    %ebx,(%esp)
  801c85:	e8 cd fb ff ff       	call   801857 <close>
	return r;
  801c8a:	89 f0                	mov    %esi,%eax
}
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	5b                   	pop    %ebx
  801c90:	5e                   	pop    %esi
  801c91:	5d                   	pop    %ebp
  801c92:	c3                   	ret    

00801c93 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	56                   	push   %esi
  801c97:	53                   	push   %ebx
  801c98:	83 ec 10             	sub    $0x10,%esp
  801c9b:	89 c6                	mov    %eax,%esi
  801c9d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c9f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ca6:	75 11                	jne    801cb9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ca8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801caf:	e8 bb f9 ff ff       	call   80166f <ipc_find_env>
  801cb4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801cb9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801cc0:	00 
  801cc1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801cc8:	00 
  801cc9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ccd:	a1 00 50 80 00       	mov    0x805000,%eax
  801cd2:	89 04 24             	mov    %eax,(%esp)
  801cd5:	e8 2e f9 ff ff       	call   801608 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cda:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ce1:	00 
  801ce2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ce6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ced:	e8 ae f8 ff ff       	call   8015a0 <ipc_recv>
}
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	5b                   	pop    %ebx
  801cf6:	5e                   	pop    %esi
  801cf7:	5d                   	pop    %ebp
  801cf8:	c3                   	ret    

00801cf9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	8b 40 0c             	mov    0xc(%eax),%eax
  801d05:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d12:	ba 00 00 00 00       	mov    $0x0,%edx
  801d17:	b8 02 00 00 00       	mov    $0x2,%eax
  801d1c:	e8 72 ff ff ff       	call   801c93 <fsipc>
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d34:	ba 00 00 00 00       	mov    $0x0,%edx
  801d39:	b8 06 00 00 00       	mov    $0x6,%eax
  801d3e:	e8 50 ff ff ff       	call   801c93 <fsipc>
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	53                   	push   %ebx
  801d49:	83 ec 14             	sub    $0x14,%esp
  801d4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	8b 40 0c             	mov    0xc(%eax),%eax
  801d55:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d64:	e8 2a ff ff ff       	call   801c93 <fsipc>
  801d69:	89 c2                	mov    %eax,%edx
  801d6b:	85 d2                	test   %edx,%edx
  801d6d:	78 2b                	js     801d9a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d6f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d76:	00 
  801d77:	89 1c 24             	mov    %ebx,(%esp)
  801d7a:	e8 f8 ea ff ff       	call   800877 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d7f:	a1 80 60 80 00       	mov    0x806080,%eax
  801d84:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d8a:	a1 84 60 80 00       	mov    0x806084,%eax
  801d8f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9a:	83 c4 14             	add    $0x14,%esp
  801d9d:	5b                   	pop    %ebx
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    

00801da0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	53                   	push   %ebx
  801da4:	83 ec 14             	sub    $0x14,%esp
  801da7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801daa:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801db0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801db5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801db8:	8b 55 08             	mov    0x8(%ebp),%edx
  801dbb:	8b 52 0c             	mov    0xc(%edx),%edx
  801dbe:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801dc4:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801dc9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd4:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801ddb:	e8 34 ec ff ff       	call   800a14 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801de0:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801de7:	00 
  801de8:	c7 04 24 e8 32 80 00 	movl   $0x8032e8,(%esp)
  801def:	e8 0b e4 ff ff       	call   8001ff <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801df4:	ba 00 00 00 00       	mov    $0x0,%edx
  801df9:	b8 04 00 00 00       	mov    $0x4,%eax
  801dfe:	e8 90 fe ff ff       	call   801c93 <fsipc>
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 53                	js     801e5a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801e07:	39 c3                	cmp    %eax,%ebx
  801e09:	73 24                	jae    801e2f <devfile_write+0x8f>
  801e0b:	c7 44 24 0c ed 32 80 	movl   $0x8032ed,0xc(%esp)
  801e12:	00 
  801e13:	c7 44 24 08 f4 32 80 	movl   $0x8032f4,0x8(%esp)
  801e1a:	00 
  801e1b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801e22:	00 
  801e23:	c7 04 24 09 33 80 00 	movl   $0x803309,(%esp)
  801e2a:	e8 d7 0b 00 00       	call   802a06 <_panic>
	assert(r <= PGSIZE);
  801e2f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e34:	7e 24                	jle    801e5a <devfile_write+0xba>
  801e36:	c7 44 24 0c 14 33 80 	movl   $0x803314,0xc(%esp)
  801e3d:	00 
  801e3e:	c7 44 24 08 f4 32 80 	movl   $0x8032f4,0x8(%esp)
  801e45:	00 
  801e46:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801e4d:	00 
  801e4e:	c7 04 24 09 33 80 00 	movl   $0x803309,(%esp)
  801e55:	e8 ac 0b 00 00       	call   802a06 <_panic>
	return r;
}
  801e5a:	83 c4 14             	add    $0x14,%esp
  801e5d:	5b                   	pop    %ebx
  801e5e:	5d                   	pop    %ebp
  801e5f:	c3                   	ret    

00801e60 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	56                   	push   %esi
  801e64:	53                   	push   %ebx
  801e65:	83 ec 10             	sub    $0x10,%esp
  801e68:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e71:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e76:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e81:	b8 03 00 00 00       	mov    $0x3,%eax
  801e86:	e8 08 fe ff ff       	call   801c93 <fsipc>
  801e8b:	89 c3                	mov    %eax,%ebx
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	78 6a                	js     801efb <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801e91:	39 c6                	cmp    %eax,%esi
  801e93:	73 24                	jae    801eb9 <devfile_read+0x59>
  801e95:	c7 44 24 0c ed 32 80 	movl   $0x8032ed,0xc(%esp)
  801e9c:	00 
  801e9d:	c7 44 24 08 f4 32 80 	movl   $0x8032f4,0x8(%esp)
  801ea4:	00 
  801ea5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801eac:	00 
  801ead:	c7 04 24 09 33 80 00 	movl   $0x803309,(%esp)
  801eb4:	e8 4d 0b 00 00       	call   802a06 <_panic>
	assert(r <= PGSIZE);
  801eb9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ebe:	7e 24                	jle    801ee4 <devfile_read+0x84>
  801ec0:	c7 44 24 0c 14 33 80 	movl   $0x803314,0xc(%esp)
  801ec7:	00 
  801ec8:	c7 44 24 08 f4 32 80 	movl   $0x8032f4,0x8(%esp)
  801ecf:	00 
  801ed0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801ed7:	00 
  801ed8:	c7 04 24 09 33 80 00 	movl   $0x803309,(%esp)
  801edf:	e8 22 0b 00 00       	call   802a06 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ee4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ee8:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801eef:	00 
  801ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef3:	89 04 24             	mov    %eax,(%esp)
  801ef6:	e8 19 eb ff ff       	call   800a14 <memmove>
	return r;
}
  801efb:	89 d8                	mov    %ebx,%eax
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	5b                   	pop    %ebx
  801f01:	5e                   	pop    %esi
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    

00801f04 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	53                   	push   %ebx
  801f08:	83 ec 24             	sub    $0x24,%esp
  801f0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801f0e:	89 1c 24             	mov    %ebx,(%esp)
  801f11:	e8 2a e9 ff ff       	call   800840 <strlen>
  801f16:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f1b:	7f 60                	jg     801f7d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801f1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f20:	89 04 24             	mov    %eax,(%esp)
  801f23:	e8 af f7 ff ff       	call   8016d7 <fd_alloc>
  801f28:	89 c2                	mov    %eax,%edx
  801f2a:	85 d2                	test   %edx,%edx
  801f2c:	78 54                	js     801f82 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801f2e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f32:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801f39:	e8 39 e9 ff ff       	call   800877 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f41:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f49:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4e:	e8 40 fd ff ff       	call   801c93 <fsipc>
  801f53:	89 c3                	mov    %eax,%ebx
  801f55:	85 c0                	test   %eax,%eax
  801f57:	79 17                	jns    801f70 <open+0x6c>
		fd_close(fd, 0);
  801f59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f60:	00 
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	89 04 24             	mov    %eax,(%esp)
  801f67:	e8 6a f8 ff ff       	call   8017d6 <fd_close>
		return r;
  801f6c:	89 d8                	mov    %ebx,%eax
  801f6e:	eb 12                	jmp    801f82 <open+0x7e>
	}

	return fd2num(fd);
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	89 04 24             	mov    %eax,(%esp)
  801f76:	e8 35 f7 ff ff       	call   8016b0 <fd2num>
  801f7b:	eb 05                	jmp    801f82 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801f7d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801f82:	83 c4 24             	add    $0x24,%esp
  801f85:	5b                   	pop    %ebx
  801f86:	5d                   	pop    %ebp
  801f87:	c3                   	ret    

00801f88 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f93:	b8 08 00 00 00       	mov    $0x8,%eax
  801f98:	e8 f6 fc ff ff       	call   801c93 <fsipc>
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <evict>:

int evict(void)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801fa5:	c7 04 24 20 33 80 00 	movl   $0x803320,(%esp)
  801fac:	e8 4e e2 ff ff       	call   8001ff <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801fb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb6:	b8 09 00 00 00       	mov    $0x9,%eax
  801fbb:	e8 d3 fc ff ff       	call   801c93 <fsipc>
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    
  801fc2:	66 90                	xchg   %ax,%ax
  801fc4:	66 90                	xchg   %ax,%ax
  801fc6:	66 90                	xchg   %ax,%ax
  801fc8:	66 90                	xchg   %ax,%ax
  801fca:	66 90                	xchg   %ax,%ax
  801fcc:	66 90                	xchg   %ax,%ax
  801fce:	66 90                	xchg   %ax,%ax

00801fd0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801fd6:	c7 44 24 04 39 33 80 	movl   $0x803339,0x4(%esp)
  801fdd:	00 
  801fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe1:	89 04 24             	mov    %eax,(%esp)
  801fe4:	e8 8e e8 ff ff       	call   800877 <strcpy>
	return 0;
}
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	53                   	push   %ebx
  801ff4:	83 ec 14             	sub    $0x14,%esp
  801ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ffa:	89 1c 24             	mov    %ebx,(%esp)
  801ffd:	e8 13 0b 00 00       	call   802b15 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802002:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802007:	83 f8 01             	cmp    $0x1,%eax
  80200a:	75 0d                	jne    802019 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80200c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80200f:	89 04 24             	mov    %eax,(%esp)
  802012:	e8 29 03 00 00       	call   802340 <nsipc_close>
  802017:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802019:	89 d0                	mov    %edx,%eax
  80201b:	83 c4 14             	add    $0x14,%esp
  80201e:	5b                   	pop    %ebx
  80201f:	5d                   	pop    %ebp
  802020:	c3                   	ret    

00802021 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802027:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80202e:	00 
  80202f:	8b 45 10             	mov    0x10(%ebp),%eax
  802032:	89 44 24 08          	mov    %eax,0x8(%esp)
  802036:	8b 45 0c             	mov    0xc(%ebp),%eax
  802039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	8b 40 0c             	mov    0xc(%eax),%eax
  802043:	89 04 24             	mov    %eax,(%esp)
  802046:	e8 f0 03 00 00       	call   80243b <nsipc_send>
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802053:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80205a:	00 
  80205b:	8b 45 10             	mov    0x10(%ebp),%eax
  80205e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802062:	8b 45 0c             	mov    0xc(%ebp),%eax
  802065:	89 44 24 04          	mov    %eax,0x4(%esp)
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	8b 40 0c             	mov    0xc(%eax),%eax
  80206f:	89 04 24             	mov    %eax,(%esp)
  802072:	e8 44 03 00 00       	call   8023bb <nsipc_recv>
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80207f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802082:	89 54 24 04          	mov    %edx,0x4(%esp)
  802086:	89 04 24             	mov    %eax,(%esp)
  802089:	e8 98 f6 ff ff       	call   801726 <fd_lookup>
  80208e:	85 c0                	test   %eax,%eax
  802090:	78 17                	js     8020a9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80209b:	39 08                	cmp    %ecx,(%eax)
  80209d:	75 05                	jne    8020a4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80209f:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a2:	eb 05                	jmp    8020a9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8020a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	56                   	push   %esi
  8020af:	53                   	push   %ebx
  8020b0:	83 ec 20             	sub    $0x20,%esp
  8020b3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8020b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b8:	89 04 24             	mov    %eax,(%esp)
  8020bb:	e8 17 f6 ff ff       	call   8016d7 <fd_alloc>
  8020c0:	89 c3                	mov    %eax,%ebx
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	78 21                	js     8020e7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020c6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020cd:	00 
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020dc:	e8 04 ec ff ff       	call   800ce5 <sys_page_alloc>
  8020e1:	89 c3                	mov    %eax,%ebx
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	79 0c                	jns    8020f3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8020e7:	89 34 24             	mov    %esi,(%esp)
  8020ea:	e8 51 02 00 00       	call   802340 <nsipc_close>
		return r;
  8020ef:	89 d8                	mov    %ebx,%eax
  8020f1:	eb 20                	jmp    802113 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8020f3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802101:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802108:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80210b:	89 14 24             	mov    %edx,(%esp)
  80210e:	e8 9d f5 ff ff       	call   8016b0 <fd2num>
}
  802113:	83 c4 20             	add    $0x20,%esp
  802116:	5b                   	pop    %ebx
  802117:	5e                   	pop    %esi
  802118:	5d                   	pop    %ebp
  802119:	c3                   	ret    

0080211a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	e8 51 ff ff ff       	call   802079 <fd2sockid>
		return r;
  802128:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80212a:	85 c0                	test   %eax,%eax
  80212c:	78 23                	js     802151 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80212e:	8b 55 10             	mov    0x10(%ebp),%edx
  802131:	89 54 24 08          	mov    %edx,0x8(%esp)
  802135:	8b 55 0c             	mov    0xc(%ebp),%edx
  802138:	89 54 24 04          	mov    %edx,0x4(%esp)
  80213c:	89 04 24             	mov    %eax,(%esp)
  80213f:	e8 45 01 00 00       	call   802289 <nsipc_accept>
		return r;
  802144:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802146:	85 c0                	test   %eax,%eax
  802148:	78 07                	js     802151 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80214a:	e8 5c ff ff ff       	call   8020ab <alloc_sockfd>
  80214f:	89 c1                	mov    %eax,%ecx
}
  802151:	89 c8                	mov    %ecx,%eax
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	e8 16 ff ff ff       	call   802079 <fd2sockid>
  802163:	89 c2                	mov    %eax,%edx
  802165:	85 d2                	test   %edx,%edx
  802167:	78 16                	js     80217f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802169:	8b 45 10             	mov    0x10(%ebp),%eax
  80216c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802170:	8b 45 0c             	mov    0xc(%ebp),%eax
  802173:	89 44 24 04          	mov    %eax,0x4(%esp)
  802177:	89 14 24             	mov    %edx,(%esp)
  80217a:	e8 60 01 00 00       	call   8022df <nsipc_bind>
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <shutdown>:

int
shutdown(int s, int how)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	e8 ea fe ff ff       	call   802079 <fd2sockid>
  80218f:	89 c2                	mov    %eax,%edx
  802191:	85 d2                	test   %edx,%edx
  802193:	78 0f                	js     8021a4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802195:	8b 45 0c             	mov    0xc(%ebp),%eax
  802198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219c:	89 14 24             	mov    %edx,(%esp)
  80219f:	e8 7a 01 00 00       	call   80231e <nsipc_shutdown>
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	e8 c5 fe ff ff       	call   802079 <fd2sockid>
  8021b4:	89 c2                	mov    %eax,%edx
  8021b6:	85 d2                	test   %edx,%edx
  8021b8:	78 16                	js     8021d0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8021ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c8:	89 14 24             	mov    %edx,(%esp)
  8021cb:	e8 8a 01 00 00       	call   80235a <nsipc_connect>
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <listen>:

int
listen(int s, int backlog)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	e8 99 fe ff ff       	call   802079 <fd2sockid>
  8021e0:	89 c2                	mov    %eax,%edx
  8021e2:	85 d2                	test   %edx,%edx
  8021e4:	78 0f                	js     8021f5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ed:	89 14 24             	mov    %edx,(%esp)
  8021f0:	e8 a4 01 00 00       	call   802399 <nsipc_listen>
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802200:	89 44 24 08          	mov    %eax,0x8(%esp)
  802204:	8b 45 0c             	mov    0xc(%ebp),%eax
  802207:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	89 04 24             	mov    %eax,(%esp)
  802211:	e8 98 02 00 00       	call   8024ae <nsipc_socket>
  802216:	89 c2                	mov    %eax,%edx
  802218:	85 d2                	test   %edx,%edx
  80221a:	78 05                	js     802221 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80221c:	e8 8a fe ff ff       	call   8020ab <alloc_sockfd>
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	53                   	push   %ebx
  802227:	83 ec 14             	sub    $0x14,%esp
  80222a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80222c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802233:	75 11                	jne    802246 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802235:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80223c:	e8 2e f4 ff ff       	call   80166f <ipc_find_env>
  802241:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802246:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80224d:	00 
  80224e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802255:	00 
  802256:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80225a:	a1 04 50 80 00       	mov    0x805004,%eax
  80225f:	89 04 24             	mov    %eax,(%esp)
  802262:	e8 a1 f3 ff ff       	call   801608 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802267:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80226e:	00 
  80226f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802276:	00 
  802277:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80227e:	e8 1d f3 ff ff       	call   8015a0 <ipc_recv>
}
  802283:	83 c4 14             	add    $0x14,%esp
  802286:	5b                   	pop    %ebx
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    

00802289 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	56                   	push   %esi
  80228d:	53                   	push   %ebx
  80228e:	83 ec 10             	sub    $0x10,%esp
  802291:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80229c:	8b 06                	mov    (%esi),%eax
  80229e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a8:	e8 76 ff ff ff       	call   802223 <nsipc>
  8022ad:	89 c3                	mov    %eax,%ebx
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	78 23                	js     8022d6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022b3:	a1 10 70 80 00       	mov    0x807010,%eax
  8022b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022bc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022c3:	00 
  8022c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c7:	89 04 24             	mov    %eax,(%esp)
  8022ca:	e8 45 e7 ff ff       	call   800a14 <memmove>
		*addrlen = ret->ret_addrlen;
  8022cf:	a1 10 70 80 00       	mov    0x807010,%eax
  8022d4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8022d6:	89 d8                	mov    %ebx,%eax
  8022d8:	83 c4 10             	add    $0x10,%esp
  8022db:	5b                   	pop    %ebx
  8022dc:	5e                   	pop    %esi
  8022dd:	5d                   	pop    %ebp
  8022de:	c3                   	ret    

008022df <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	53                   	push   %ebx
  8022e3:	83 ec 14             	sub    $0x14,%esp
  8022e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022f1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802303:	e8 0c e7 ff ff       	call   800a14 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802308:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80230e:	b8 02 00 00 00       	mov    $0x2,%eax
  802313:	e8 0b ff ff ff       	call   802223 <nsipc>
}
  802318:	83 c4 14             	add    $0x14,%esp
  80231b:	5b                   	pop    %ebx
  80231c:	5d                   	pop    %ebp
  80231d:	c3                   	ret    

0080231e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80232c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802334:	b8 03 00 00 00       	mov    $0x3,%eax
  802339:	e8 e5 fe ff ff       	call   802223 <nsipc>
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <nsipc_close>:

int
nsipc_close(int s)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80234e:	b8 04 00 00 00       	mov    $0x4,%eax
  802353:	e8 cb fe ff ff       	call   802223 <nsipc>
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	53                   	push   %ebx
  80235e:	83 ec 14             	sub    $0x14,%esp
  802361:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80236c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802370:	8b 45 0c             	mov    0xc(%ebp),%eax
  802373:	89 44 24 04          	mov    %eax,0x4(%esp)
  802377:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80237e:	e8 91 e6 ff ff       	call   800a14 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802383:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802389:	b8 05 00 00 00       	mov    $0x5,%eax
  80238e:	e8 90 fe ff ff       	call   802223 <nsipc>
}
  802393:	83 c4 14             	add    $0x14,%esp
  802396:	5b                   	pop    %ebx
  802397:	5d                   	pop    %ebp
  802398:	c3                   	ret    

00802399 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023aa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023af:	b8 06 00 00 00       	mov    $0x6,%eax
  8023b4:	e8 6a fe ff ff       	call   802223 <nsipc>
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	56                   	push   %esi
  8023bf:	53                   	push   %ebx
  8023c0:	83 ec 10             	sub    $0x10,%esp
  8023c3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023ce:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023d7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8023e1:	e8 3d fe ff ff       	call   802223 <nsipc>
  8023e6:	89 c3                	mov    %eax,%ebx
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	78 46                	js     802432 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8023ec:	39 f0                	cmp    %esi,%eax
  8023ee:	7f 07                	jg     8023f7 <nsipc_recv+0x3c>
  8023f0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023f5:	7e 24                	jle    80241b <nsipc_recv+0x60>
  8023f7:	c7 44 24 0c 45 33 80 	movl   $0x803345,0xc(%esp)
  8023fe:	00 
  8023ff:	c7 44 24 08 f4 32 80 	movl   $0x8032f4,0x8(%esp)
  802406:	00 
  802407:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80240e:	00 
  80240f:	c7 04 24 5a 33 80 00 	movl   $0x80335a,(%esp)
  802416:	e8 eb 05 00 00       	call   802a06 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80241b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80241f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802426:	00 
  802427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242a:	89 04 24             	mov    %eax,(%esp)
  80242d:	e8 e2 e5 ff ff       	call   800a14 <memmove>
	}

	return r;
}
  802432:	89 d8                	mov    %ebx,%eax
  802434:	83 c4 10             	add    $0x10,%esp
  802437:	5b                   	pop    %ebx
  802438:	5e                   	pop    %esi
  802439:	5d                   	pop    %ebp
  80243a:	c3                   	ret    

0080243b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	53                   	push   %ebx
  80243f:	83 ec 14             	sub    $0x14,%esp
  802442:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802445:	8b 45 08             	mov    0x8(%ebp),%eax
  802448:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80244d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802453:	7e 24                	jle    802479 <nsipc_send+0x3e>
  802455:	c7 44 24 0c 66 33 80 	movl   $0x803366,0xc(%esp)
  80245c:	00 
  80245d:	c7 44 24 08 f4 32 80 	movl   $0x8032f4,0x8(%esp)
  802464:	00 
  802465:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80246c:	00 
  80246d:	c7 04 24 5a 33 80 00 	movl   $0x80335a,(%esp)
  802474:	e8 8d 05 00 00       	call   802a06 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802479:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80247d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802480:	89 44 24 04          	mov    %eax,0x4(%esp)
  802484:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80248b:	e8 84 e5 ff ff       	call   800a14 <memmove>
	nsipcbuf.send.req_size = size;
  802490:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802496:	8b 45 14             	mov    0x14(%ebp),%eax
  802499:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80249e:	b8 08 00 00 00       	mov    $0x8,%eax
  8024a3:	e8 7b fd ff ff       	call   802223 <nsipc>
}
  8024a8:	83 c4 14             	add    $0x14,%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5d                   	pop    %ebp
  8024ad:	c3                   	ret    

008024ae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024cc:	b8 09 00 00 00       	mov    $0x9,%eax
  8024d1:	e8 4d fd ff ff       	call   802223 <nsipc>
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	56                   	push   %esi
  8024dc:	53                   	push   %ebx
  8024dd:	83 ec 10             	sub    $0x10,%esp
  8024e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	89 04 24             	mov    %eax,(%esp)
  8024e9:	e8 d2 f1 ff ff       	call   8016c0 <fd2data>
  8024ee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024f0:	c7 44 24 04 72 33 80 	movl   $0x803372,0x4(%esp)
  8024f7:	00 
  8024f8:	89 1c 24             	mov    %ebx,(%esp)
  8024fb:	e8 77 e3 ff ff       	call   800877 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802500:	8b 46 04             	mov    0x4(%esi),%eax
  802503:	2b 06                	sub    (%esi),%eax
  802505:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80250b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802512:	00 00 00 
	stat->st_dev = &devpipe;
  802515:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80251c:	40 80 00 
	return 0;
}
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
  802524:	83 c4 10             	add    $0x10,%esp
  802527:	5b                   	pop    %ebx
  802528:	5e                   	pop    %esi
  802529:	5d                   	pop    %ebp
  80252a:	c3                   	ret    

0080252b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
  80252e:	53                   	push   %ebx
  80252f:	83 ec 14             	sub    $0x14,%esp
  802532:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802535:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802539:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802540:	e8 47 e8 ff ff       	call   800d8c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802545:	89 1c 24             	mov    %ebx,(%esp)
  802548:	e8 73 f1 ff ff       	call   8016c0 <fd2data>
  80254d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802551:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802558:	e8 2f e8 ff ff       	call   800d8c <sys_page_unmap>
}
  80255d:	83 c4 14             	add    $0x14,%esp
  802560:	5b                   	pop    %ebx
  802561:	5d                   	pop    %ebp
  802562:	c3                   	ret    

00802563 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
  802566:	57                   	push   %edi
  802567:	56                   	push   %esi
  802568:	53                   	push   %ebx
  802569:	83 ec 2c             	sub    $0x2c,%esp
  80256c:	89 c6                	mov    %eax,%esi
  80256e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802571:	a1 08 50 80 00       	mov    0x805008,%eax
  802576:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802579:	89 34 24             	mov    %esi,(%esp)
  80257c:	e8 94 05 00 00       	call   802b15 <pageref>
  802581:	89 c7                	mov    %eax,%edi
  802583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802586:	89 04 24             	mov    %eax,(%esp)
  802589:	e8 87 05 00 00       	call   802b15 <pageref>
  80258e:	39 c7                	cmp    %eax,%edi
  802590:	0f 94 c2             	sete   %dl
  802593:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802596:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80259c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80259f:	39 fb                	cmp    %edi,%ebx
  8025a1:	74 21                	je     8025c4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8025a3:	84 d2                	test   %dl,%dl
  8025a5:	74 ca                	je     802571 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8025a7:	8b 51 58             	mov    0x58(%ecx),%edx
  8025aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025b6:	c7 04 24 79 33 80 00 	movl   $0x803379,(%esp)
  8025bd:	e8 3d dc ff ff       	call   8001ff <cprintf>
  8025c2:	eb ad                	jmp    802571 <_pipeisclosed+0xe>
	}
}
  8025c4:	83 c4 2c             	add    $0x2c,%esp
  8025c7:	5b                   	pop    %ebx
  8025c8:	5e                   	pop    %esi
  8025c9:	5f                   	pop    %edi
  8025ca:	5d                   	pop    %ebp
  8025cb:	c3                   	ret    

008025cc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
  8025cf:	57                   	push   %edi
  8025d0:	56                   	push   %esi
  8025d1:	53                   	push   %ebx
  8025d2:	83 ec 1c             	sub    $0x1c,%esp
  8025d5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8025d8:	89 34 24             	mov    %esi,(%esp)
  8025db:	e8 e0 f0 ff ff       	call   8016c0 <fd2data>
  8025e0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e7:	eb 45                	jmp    80262e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8025e9:	89 da                	mov    %ebx,%edx
  8025eb:	89 f0                	mov    %esi,%eax
  8025ed:	e8 71 ff ff ff       	call   802563 <_pipeisclosed>
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	75 41                	jne    802637 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8025f6:	e8 cb e6 ff ff       	call   800cc6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8025fe:	8b 0b                	mov    (%ebx),%ecx
  802600:	8d 51 20             	lea    0x20(%ecx),%edx
  802603:	39 d0                	cmp    %edx,%eax
  802605:	73 e2                	jae    8025e9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802607:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80260a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80260e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802611:	99                   	cltd   
  802612:	c1 ea 1b             	shr    $0x1b,%edx
  802615:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802618:	83 e1 1f             	and    $0x1f,%ecx
  80261b:	29 d1                	sub    %edx,%ecx
  80261d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802621:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802625:	83 c0 01             	add    $0x1,%eax
  802628:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80262b:	83 c7 01             	add    $0x1,%edi
  80262e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802631:	75 c8                	jne    8025fb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802633:	89 f8                	mov    %edi,%eax
  802635:	eb 05                	jmp    80263c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80263c:	83 c4 1c             	add    $0x1c,%esp
  80263f:	5b                   	pop    %ebx
  802640:	5e                   	pop    %esi
  802641:	5f                   	pop    %edi
  802642:	5d                   	pop    %ebp
  802643:	c3                   	ret    

00802644 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	57                   	push   %edi
  802648:	56                   	push   %esi
  802649:	53                   	push   %ebx
  80264a:	83 ec 1c             	sub    $0x1c,%esp
  80264d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802650:	89 3c 24             	mov    %edi,(%esp)
  802653:	e8 68 f0 ff ff       	call   8016c0 <fd2data>
  802658:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80265a:	be 00 00 00 00       	mov    $0x0,%esi
  80265f:	eb 3d                	jmp    80269e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802661:	85 f6                	test   %esi,%esi
  802663:	74 04                	je     802669 <devpipe_read+0x25>
				return i;
  802665:	89 f0                	mov    %esi,%eax
  802667:	eb 43                	jmp    8026ac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802669:	89 da                	mov    %ebx,%edx
  80266b:	89 f8                	mov    %edi,%eax
  80266d:	e8 f1 fe ff ff       	call   802563 <_pipeisclosed>
  802672:	85 c0                	test   %eax,%eax
  802674:	75 31                	jne    8026a7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802676:	e8 4b e6 ff ff       	call   800cc6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80267b:	8b 03                	mov    (%ebx),%eax
  80267d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802680:	74 df                	je     802661 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802682:	99                   	cltd   
  802683:	c1 ea 1b             	shr    $0x1b,%edx
  802686:	01 d0                	add    %edx,%eax
  802688:	83 e0 1f             	and    $0x1f,%eax
  80268b:	29 d0                	sub    %edx,%eax
  80268d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802692:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802695:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802698:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80269b:	83 c6 01             	add    $0x1,%esi
  80269e:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026a1:	75 d8                	jne    80267b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8026a3:	89 f0                	mov    %esi,%eax
  8026a5:	eb 05                	jmp    8026ac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8026ac:	83 c4 1c             	add    $0x1c,%esp
  8026af:	5b                   	pop    %ebx
  8026b0:	5e                   	pop    %esi
  8026b1:	5f                   	pop    %edi
  8026b2:	5d                   	pop    %ebp
  8026b3:	c3                   	ret    

008026b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	56                   	push   %esi
  8026b8:	53                   	push   %ebx
  8026b9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026bf:	89 04 24             	mov    %eax,(%esp)
  8026c2:	e8 10 f0 ff ff       	call   8016d7 <fd_alloc>
  8026c7:	89 c2                	mov    %eax,%edx
  8026c9:	85 d2                	test   %edx,%edx
  8026cb:	0f 88 4d 01 00 00    	js     80281e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026d1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026d8:	00 
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e7:	e8 f9 e5 ff ff       	call   800ce5 <sys_page_alloc>
  8026ec:	89 c2                	mov    %eax,%edx
  8026ee:	85 d2                	test   %edx,%edx
  8026f0:	0f 88 28 01 00 00    	js     80281e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026f9:	89 04 24             	mov    %eax,(%esp)
  8026fc:	e8 d6 ef ff ff       	call   8016d7 <fd_alloc>
  802701:	89 c3                	mov    %eax,%ebx
  802703:	85 c0                	test   %eax,%eax
  802705:	0f 88 fe 00 00 00    	js     802809 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80270b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802712:	00 
  802713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802716:	89 44 24 04          	mov    %eax,0x4(%esp)
  80271a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802721:	e8 bf e5 ff ff       	call   800ce5 <sys_page_alloc>
  802726:	89 c3                	mov    %eax,%ebx
  802728:	85 c0                	test   %eax,%eax
  80272a:	0f 88 d9 00 00 00    	js     802809 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	89 04 24             	mov    %eax,(%esp)
  802736:	e8 85 ef ff ff       	call   8016c0 <fd2data>
  80273b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80273d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802744:	00 
  802745:	89 44 24 04          	mov    %eax,0x4(%esp)
  802749:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802750:	e8 90 e5 ff ff       	call   800ce5 <sys_page_alloc>
  802755:	89 c3                	mov    %eax,%ebx
  802757:	85 c0                	test   %eax,%eax
  802759:	0f 88 97 00 00 00    	js     8027f6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	89 04 24             	mov    %eax,(%esp)
  802765:	e8 56 ef ff ff       	call   8016c0 <fd2data>
  80276a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802771:	00 
  802772:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802776:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80277d:	00 
  80277e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802782:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802789:	e8 ab e5 ff ff       	call   800d39 <sys_page_map>
  80278e:	89 c3                	mov    %eax,%ebx
  802790:	85 c0                	test   %eax,%eax
  802792:	78 52                	js     8027e6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802794:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8027a9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8027b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	89 04 24             	mov    %eax,(%esp)
  8027c4:	e8 e7 ee ff ff       	call   8016b0 <fd2num>
  8027c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8027ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d1:	89 04 24             	mov    %eax,(%esp)
  8027d4:	e8 d7 ee ff ff       	call   8016b0 <fd2num>
  8027d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8027df:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e4:	eb 38                	jmp    80281e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8027e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027f1:	e8 96 e5 ff ff       	call   800d8c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802804:	e8 83 e5 ff ff       	call   800d8c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802810:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802817:	e8 70 e5 ff ff       	call   800d8c <sys_page_unmap>
  80281c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80281e:	83 c4 30             	add    $0x30,%esp
  802821:	5b                   	pop    %ebx
  802822:	5e                   	pop    %esi
  802823:	5d                   	pop    %ebp
  802824:	c3                   	ret    

00802825 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80282b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80282e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	89 04 24             	mov    %eax,(%esp)
  802838:	e8 e9 ee ff ff       	call   801726 <fd_lookup>
  80283d:	89 c2                	mov    %eax,%edx
  80283f:	85 d2                	test   %edx,%edx
  802841:	78 15                	js     802858 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	89 04 24             	mov    %eax,(%esp)
  802849:	e8 72 ee ff ff       	call   8016c0 <fd2data>
	return _pipeisclosed(fd, p);
  80284e:	89 c2                	mov    %eax,%edx
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	e8 0b fd ff ff       	call   802563 <_pipeisclosed>
}
  802858:	c9                   	leave  
  802859:	c3                   	ret    
  80285a:	66 90                	xchg   %ax,%ax
  80285c:	66 90                	xchg   %ax,%ax
  80285e:	66 90                	xchg   %ax,%ax

00802860 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
  802868:	5d                   	pop    %ebp
  802869:	c3                   	ret    

0080286a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
  80286d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802870:	c7 44 24 04 91 33 80 	movl   $0x803391,0x4(%esp)
  802877:	00 
  802878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287b:	89 04 24             	mov    %eax,(%esp)
  80287e:	e8 f4 df ff ff       	call   800877 <strcpy>
	return 0;
}
  802883:	b8 00 00 00 00       	mov    $0x0,%eax
  802888:	c9                   	leave  
  802889:	c3                   	ret    

0080288a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
  80288d:	57                   	push   %edi
  80288e:	56                   	push   %esi
  80288f:	53                   	push   %ebx
  802890:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802896:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80289b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028a1:	eb 31                	jmp    8028d4 <devcons_write+0x4a>
		m = n - tot;
  8028a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8028a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8028a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8028ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8028b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8028b7:	03 45 0c             	add    0xc(%ebp),%eax
  8028ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028be:	89 3c 24             	mov    %edi,(%esp)
  8028c1:	e8 4e e1 ff ff       	call   800a14 <memmove>
		sys_cputs(buf, m);
  8028c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028ca:	89 3c 24             	mov    %edi,(%esp)
  8028cd:	e8 f4 e2 ff ff       	call   800bc6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028d2:	01 f3                	add    %esi,%ebx
  8028d4:	89 d8                	mov    %ebx,%eax
  8028d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8028d9:	72 c8                	jb     8028a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8028db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8028e1:	5b                   	pop    %ebx
  8028e2:	5e                   	pop    %esi
  8028e3:	5f                   	pop    %edi
  8028e4:	5d                   	pop    %ebp
  8028e5:	c3                   	ret    

008028e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028e6:	55                   	push   %ebp
  8028e7:	89 e5                	mov    %esp,%ebp
  8028e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8028ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8028f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028f5:	75 07                	jne    8028fe <devcons_read+0x18>
  8028f7:	eb 2a                	jmp    802923 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8028f9:	e8 c8 e3 ff ff       	call   800cc6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8028fe:	66 90                	xchg   %ax,%ax
  802900:	e8 df e2 ff ff       	call   800be4 <sys_cgetc>
  802905:	85 c0                	test   %eax,%eax
  802907:	74 f0                	je     8028f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802909:	85 c0                	test   %eax,%eax
  80290b:	78 16                	js     802923 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80290d:	83 f8 04             	cmp    $0x4,%eax
  802910:	74 0c                	je     80291e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802912:	8b 55 0c             	mov    0xc(%ebp),%edx
  802915:	88 02                	mov    %al,(%edx)
	return 1;
  802917:	b8 01 00 00 00       	mov    $0x1,%eax
  80291c:	eb 05                	jmp    802923 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80291e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802923:	c9                   	leave  
  802924:	c3                   	ret    

00802925 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802925:	55                   	push   %ebp
  802926:	89 e5                	mov    %esp,%ebp
  802928:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802931:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802938:	00 
  802939:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80293c:	89 04 24             	mov    %eax,(%esp)
  80293f:	e8 82 e2 ff ff       	call   800bc6 <sys_cputs>
}
  802944:	c9                   	leave  
  802945:	c3                   	ret    

00802946 <getchar>:

int
getchar(void)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80294c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802953:	00 
  802954:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802957:	89 44 24 04          	mov    %eax,0x4(%esp)
  80295b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802962:	e8 53 f0 ff ff       	call   8019ba <read>
	if (r < 0)
  802967:	85 c0                	test   %eax,%eax
  802969:	78 0f                	js     80297a <getchar+0x34>
		return r;
	if (r < 1)
  80296b:	85 c0                	test   %eax,%eax
  80296d:	7e 06                	jle    802975 <getchar+0x2f>
		return -E_EOF;
	return c;
  80296f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802973:	eb 05                	jmp    80297a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802975:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80297a:	c9                   	leave  
  80297b:	c3                   	ret    

0080297c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80297c:	55                   	push   %ebp
  80297d:	89 e5                	mov    %esp,%ebp
  80297f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802982:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802985:	89 44 24 04          	mov    %eax,0x4(%esp)
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	89 04 24             	mov    %eax,(%esp)
  80298f:	e8 92 ed ff ff       	call   801726 <fd_lookup>
  802994:	85 c0                	test   %eax,%eax
  802996:	78 11                	js     8029a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029a1:	39 10                	cmp    %edx,(%eax)
  8029a3:	0f 94 c0             	sete   %al
  8029a6:	0f b6 c0             	movzbl %al,%eax
}
  8029a9:	c9                   	leave  
  8029aa:	c3                   	ret    

008029ab <opencons>:

int
opencons(void)
{
  8029ab:	55                   	push   %ebp
  8029ac:	89 e5                	mov    %esp,%ebp
  8029ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029b4:	89 04 24             	mov    %eax,(%esp)
  8029b7:	e8 1b ed ff ff       	call   8016d7 <fd_alloc>
		return r;
  8029bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	78 40                	js     802a02 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029c9:	00 
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029d8:	e8 08 e3 ff ff       	call   800ce5 <sys_page_alloc>
		return r;
  8029dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	78 1f                	js     802a02 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8029e3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8029f8:	89 04 24             	mov    %eax,(%esp)
  8029fb:	e8 b0 ec ff ff       	call   8016b0 <fd2num>
  802a00:	89 c2                	mov    %eax,%edx
}
  802a02:	89 d0                	mov    %edx,%eax
  802a04:	c9                   	leave  
  802a05:	c3                   	ret    

00802a06 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802a06:	55                   	push   %ebp
  802a07:	89 e5                	mov    %esp,%ebp
  802a09:	56                   	push   %esi
  802a0a:	53                   	push   %ebx
  802a0b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  802a0e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802a11:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802a17:	e8 8b e2 ff ff       	call   800ca7 <sys_getenvid>
  802a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a1f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802a23:	8b 55 08             	mov    0x8(%ebp),%edx
  802a26:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802a2a:	89 74 24 08          	mov    %esi,0x8(%esp)
  802a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a32:	c7 04 24 a0 33 80 00 	movl   $0x8033a0,(%esp)
  802a39:	e8 c1 d7 ff ff       	call   8001ff <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802a3e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a42:	8b 45 10             	mov    0x10(%ebp),%eax
  802a45:	89 04 24             	mov    %eax,(%esp)
  802a48:	e8 51 d7 ff ff       	call   80019e <vcprintf>
	cprintf("\n");
  802a4d:	c7 04 24 37 33 80 00 	movl   $0x803337,(%esp)
  802a54:	e8 a6 d7 ff ff       	call   8001ff <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802a59:	cc                   	int3   
  802a5a:	eb fd                	jmp    802a59 <_panic+0x53>

00802a5c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a5c:	55                   	push   %ebp
  802a5d:	89 e5                	mov    %esp,%ebp
  802a5f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802a62:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802a69:	75 7a                	jne    802ae5 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802a6b:	e8 37 e2 ff ff       	call   800ca7 <sys_getenvid>
  802a70:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802a77:	00 
  802a78:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802a7f:	ee 
  802a80:	89 04 24             	mov    %eax,(%esp)
  802a83:	e8 5d e2 ff ff       	call   800ce5 <sys_page_alloc>
  802a88:	85 c0                	test   %eax,%eax
  802a8a:	79 20                	jns    802aac <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802a8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a90:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  802a97:	00 
  802a98:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802a9f:	00 
  802aa0:	c7 04 24 c4 33 80 00 	movl   $0x8033c4,(%esp)
  802aa7:	e8 5a ff ff ff       	call   802a06 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802aac:	e8 f6 e1 ff ff       	call   800ca7 <sys_getenvid>
  802ab1:	c7 44 24 04 ef 2a 80 	movl   $0x802aef,0x4(%esp)
  802ab8:	00 
  802ab9:	89 04 24             	mov    %eax,(%esp)
  802abc:	e8 e4 e3 ff ff       	call   800ea5 <sys_env_set_pgfault_upcall>
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	79 20                	jns    802ae5 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802ac5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ac9:	c7 44 24 08 08 32 80 	movl   $0x803208,0x8(%esp)
  802ad0:	00 
  802ad1:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802ad8:	00 
  802ad9:	c7 04 24 c4 33 80 00 	movl   $0x8033c4,(%esp)
  802ae0:	e8 21 ff ff ff       	call   802a06 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802aed:	c9                   	leave  
  802aee:	c3                   	ret    

00802aef <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802aef:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802af0:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802af5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802af7:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802afa:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802afe:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802b02:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802b05:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802b09:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802b0b:	83 c4 08             	add    $0x8,%esp
	popal
  802b0e:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802b0f:	83 c4 04             	add    $0x4,%esp
	popfl
  802b12:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802b13:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802b14:	c3                   	ret    

00802b15 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b15:	55                   	push   %ebp
  802b16:	89 e5                	mov    %esp,%ebp
  802b18:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b1b:	89 d0                	mov    %edx,%eax
  802b1d:	c1 e8 16             	shr    $0x16,%eax
  802b20:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b27:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b2c:	f6 c1 01             	test   $0x1,%cl
  802b2f:	74 1d                	je     802b4e <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b31:	c1 ea 0c             	shr    $0xc,%edx
  802b34:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b3b:	f6 c2 01             	test   $0x1,%dl
  802b3e:	74 0e                	je     802b4e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b40:	c1 ea 0c             	shr    $0xc,%edx
  802b43:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b4a:	ef 
  802b4b:	0f b7 c0             	movzwl %ax,%eax
}
  802b4e:	5d                   	pop    %ebp
  802b4f:	c3                   	ret    

00802b50 <__udivdi3>:
  802b50:	55                   	push   %ebp
  802b51:	57                   	push   %edi
  802b52:	56                   	push   %esi
  802b53:	83 ec 0c             	sub    $0xc,%esp
  802b56:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b5a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b5e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802b62:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b66:	85 c0                	test   %eax,%eax
  802b68:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b6c:	89 ea                	mov    %ebp,%edx
  802b6e:	89 0c 24             	mov    %ecx,(%esp)
  802b71:	75 2d                	jne    802ba0 <__udivdi3+0x50>
  802b73:	39 e9                	cmp    %ebp,%ecx
  802b75:	77 61                	ja     802bd8 <__udivdi3+0x88>
  802b77:	85 c9                	test   %ecx,%ecx
  802b79:	89 ce                	mov    %ecx,%esi
  802b7b:	75 0b                	jne    802b88 <__udivdi3+0x38>
  802b7d:	b8 01 00 00 00       	mov    $0x1,%eax
  802b82:	31 d2                	xor    %edx,%edx
  802b84:	f7 f1                	div    %ecx
  802b86:	89 c6                	mov    %eax,%esi
  802b88:	31 d2                	xor    %edx,%edx
  802b8a:	89 e8                	mov    %ebp,%eax
  802b8c:	f7 f6                	div    %esi
  802b8e:	89 c5                	mov    %eax,%ebp
  802b90:	89 f8                	mov    %edi,%eax
  802b92:	f7 f6                	div    %esi
  802b94:	89 ea                	mov    %ebp,%edx
  802b96:	83 c4 0c             	add    $0xc,%esp
  802b99:	5e                   	pop    %esi
  802b9a:	5f                   	pop    %edi
  802b9b:	5d                   	pop    %ebp
  802b9c:	c3                   	ret    
  802b9d:	8d 76 00             	lea    0x0(%esi),%esi
  802ba0:	39 e8                	cmp    %ebp,%eax
  802ba2:	77 24                	ja     802bc8 <__udivdi3+0x78>
  802ba4:	0f bd e8             	bsr    %eax,%ebp
  802ba7:	83 f5 1f             	xor    $0x1f,%ebp
  802baa:	75 3c                	jne    802be8 <__udivdi3+0x98>
  802bac:	8b 74 24 04          	mov    0x4(%esp),%esi
  802bb0:	39 34 24             	cmp    %esi,(%esp)
  802bb3:	0f 86 9f 00 00 00    	jbe    802c58 <__udivdi3+0x108>
  802bb9:	39 d0                	cmp    %edx,%eax
  802bbb:	0f 82 97 00 00 00    	jb     802c58 <__udivdi3+0x108>
  802bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bc8:	31 d2                	xor    %edx,%edx
  802bca:	31 c0                	xor    %eax,%eax
  802bcc:	83 c4 0c             	add    $0xc,%esp
  802bcf:	5e                   	pop    %esi
  802bd0:	5f                   	pop    %edi
  802bd1:	5d                   	pop    %ebp
  802bd2:	c3                   	ret    
  802bd3:	90                   	nop
  802bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd8:	89 f8                	mov    %edi,%eax
  802bda:	f7 f1                	div    %ecx
  802bdc:	31 d2                	xor    %edx,%edx
  802bde:	83 c4 0c             	add    $0xc,%esp
  802be1:	5e                   	pop    %esi
  802be2:	5f                   	pop    %edi
  802be3:	5d                   	pop    %ebp
  802be4:	c3                   	ret    
  802be5:	8d 76 00             	lea    0x0(%esi),%esi
  802be8:	89 e9                	mov    %ebp,%ecx
  802bea:	8b 3c 24             	mov    (%esp),%edi
  802bed:	d3 e0                	shl    %cl,%eax
  802bef:	89 c6                	mov    %eax,%esi
  802bf1:	b8 20 00 00 00       	mov    $0x20,%eax
  802bf6:	29 e8                	sub    %ebp,%eax
  802bf8:	89 c1                	mov    %eax,%ecx
  802bfa:	d3 ef                	shr    %cl,%edi
  802bfc:	89 e9                	mov    %ebp,%ecx
  802bfe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c02:	8b 3c 24             	mov    (%esp),%edi
  802c05:	09 74 24 08          	or     %esi,0x8(%esp)
  802c09:	89 d6                	mov    %edx,%esi
  802c0b:	d3 e7                	shl    %cl,%edi
  802c0d:	89 c1                	mov    %eax,%ecx
  802c0f:	89 3c 24             	mov    %edi,(%esp)
  802c12:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c16:	d3 ee                	shr    %cl,%esi
  802c18:	89 e9                	mov    %ebp,%ecx
  802c1a:	d3 e2                	shl    %cl,%edx
  802c1c:	89 c1                	mov    %eax,%ecx
  802c1e:	d3 ef                	shr    %cl,%edi
  802c20:	09 d7                	or     %edx,%edi
  802c22:	89 f2                	mov    %esi,%edx
  802c24:	89 f8                	mov    %edi,%eax
  802c26:	f7 74 24 08          	divl   0x8(%esp)
  802c2a:	89 d6                	mov    %edx,%esi
  802c2c:	89 c7                	mov    %eax,%edi
  802c2e:	f7 24 24             	mull   (%esp)
  802c31:	39 d6                	cmp    %edx,%esi
  802c33:	89 14 24             	mov    %edx,(%esp)
  802c36:	72 30                	jb     802c68 <__udivdi3+0x118>
  802c38:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c3c:	89 e9                	mov    %ebp,%ecx
  802c3e:	d3 e2                	shl    %cl,%edx
  802c40:	39 c2                	cmp    %eax,%edx
  802c42:	73 05                	jae    802c49 <__udivdi3+0xf9>
  802c44:	3b 34 24             	cmp    (%esp),%esi
  802c47:	74 1f                	je     802c68 <__udivdi3+0x118>
  802c49:	89 f8                	mov    %edi,%eax
  802c4b:	31 d2                	xor    %edx,%edx
  802c4d:	e9 7a ff ff ff       	jmp    802bcc <__udivdi3+0x7c>
  802c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c58:	31 d2                	xor    %edx,%edx
  802c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c5f:	e9 68 ff ff ff       	jmp    802bcc <__udivdi3+0x7c>
  802c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c68:	8d 47 ff             	lea    -0x1(%edi),%eax
  802c6b:	31 d2                	xor    %edx,%edx
  802c6d:	83 c4 0c             	add    $0xc,%esp
  802c70:	5e                   	pop    %esi
  802c71:	5f                   	pop    %edi
  802c72:	5d                   	pop    %ebp
  802c73:	c3                   	ret    
  802c74:	66 90                	xchg   %ax,%ax
  802c76:	66 90                	xchg   %ax,%ax
  802c78:	66 90                	xchg   %ax,%ax
  802c7a:	66 90                	xchg   %ax,%ax
  802c7c:	66 90                	xchg   %ax,%ax
  802c7e:	66 90                	xchg   %ax,%ax

00802c80 <__umoddi3>:
  802c80:	55                   	push   %ebp
  802c81:	57                   	push   %edi
  802c82:	56                   	push   %esi
  802c83:	83 ec 14             	sub    $0x14,%esp
  802c86:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c8a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c8e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802c92:	89 c7                	mov    %eax,%edi
  802c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c98:	8b 44 24 30          	mov    0x30(%esp),%eax
  802c9c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ca0:	89 34 24             	mov    %esi,(%esp)
  802ca3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	89 c2                	mov    %eax,%edx
  802cab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802caf:	75 17                	jne    802cc8 <__umoddi3+0x48>
  802cb1:	39 fe                	cmp    %edi,%esi
  802cb3:	76 4b                	jbe    802d00 <__umoddi3+0x80>
  802cb5:	89 c8                	mov    %ecx,%eax
  802cb7:	89 fa                	mov    %edi,%edx
  802cb9:	f7 f6                	div    %esi
  802cbb:	89 d0                	mov    %edx,%eax
  802cbd:	31 d2                	xor    %edx,%edx
  802cbf:	83 c4 14             	add    $0x14,%esp
  802cc2:	5e                   	pop    %esi
  802cc3:	5f                   	pop    %edi
  802cc4:	5d                   	pop    %ebp
  802cc5:	c3                   	ret    
  802cc6:	66 90                	xchg   %ax,%ax
  802cc8:	39 f8                	cmp    %edi,%eax
  802cca:	77 54                	ja     802d20 <__umoddi3+0xa0>
  802ccc:	0f bd e8             	bsr    %eax,%ebp
  802ccf:	83 f5 1f             	xor    $0x1f,%ebp
  802cd2:	75 5c                	jne    802d30 <__umoddi3+0xb0>
  802cd4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802cd8:	39 3c 24             	cmp    %edi,(%esp)
  802cdb:	0f 87 e7 00 00 00    	ja     802dc8 <__umoddi3+0x148>
  802ce1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ce5:	29 f1                	sub    %esi,%ecx
  802ce7:	19 c7                	sbb    %eax,%edi
  802ce9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ced:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cf1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802cf5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802cf9:	83 c4 14             	add    $0x14,%esp
  802cfc:	5e                   	pop    %esi
  802cfd:	5f                   	pop    %edi
  802cfe:	5d                   	pop    %ebp
  802cff:	c3                   	ret    
  802d00:	85 f6                	test   %esi,%esi
  802d02:	89 f5                	mov    %esi,%ebp
  802d04:	75 0b                	jne    802d11 <__umoddi3+0x91>
  802d06:	b8 01 00 00 00       	mov    $0x1,%eax
  802d0b:	31 d2                	xor    %edx,%edx
  802d0d:	f7 f6                	div    %esi
  802d0f:	89 c5                	mov    %eax,%ebp
  802d11:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d15:	31 d2                	xor    %edx,%edx
  802d17:	f7 f5                	div    %ebp
  802d19:	89 c8                	mov    %ecx,%eax
  802d1b:	f7 f5                	div    %ebp
  802d1d:	eb 9c                	jmp    802cbb <__umoddi3+0x3b>
  802d1f:	90                   	nop
  802d20:	89 c8                	mov    %ecx,%eax
  802d22:	89 fa                	mov    %edi,%edx
  802d24:	83 c4 14             	add    $0x14,%esp
  802d27:	5e                   	pop    %esi
  802d28:	5f                   	pop    %edi
  802d29:	5d                   	pop    %ebp
  802d2a:	c3                   	ret    
  802d2b:	90                   	nop
  802d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d30:	8b 04 24             	mov    (%esp),%eax
  802d33:	be 20 00 00 00       	mov    $0x20,%esi
  802d38:	89 e9                	mov    %ebp,%ecx
  802d3a:	29 ee                	sub    %ebp,%esi
  802d3c:	d3 e2                	shl    %cl,%edx
  802d3e:	89 f1                	mov    %esi,%ecx
  802d40:	d3 e8                	shr    %cl,%eax
  802d42:	89 e9                	mov    %ebp,%ecx
  802d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d48:	8b 04 24             	mov    (%esp),%eax
  802d4b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d4f:	89 fa                	mov    %edi,%edx
  802d51:	d3 e0                	shl    %cl,%eax
  802d53:	89 f1                	mov    %esi,%ecx
  802d55:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d59:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d5d:	d3 ea                	shr    %cl,%edx
  802d5f:	89 e9                	mov    %ebp,%ecx
  802d61:	d3 e7                	shl    %cl,%edi
  802d63:	89 f1                	mov    %esi,%ecx
  802d65:	d3 e8                	shr    %cl,%eax
  802d67:	89 e9                	mov    %ebp,%ecx
  802d69:	09 f8                	or     %edi,%eax
  802d6b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802d6f:	f7 74 24 04          	divl   0x4(%esp)
  802d73:	d3 e7                	shl    %cl,%edi
  802d75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d79:	89 d7                	mov    %edx,%edi
  802d7b:	f7 64 24 08          	mull   0x8(%esp)
  802d7f:	39 d7                	cmp    %edx,%edi
  802d81:	89 c1                	mov    %eax,%ecx
  802d83:	89 14 24             	mov    %edx,(%esp)
  802d86:	72 2c                	jb     802db4 <__umoddi3+0x134>
  802d88:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802d8c:	72 22                	jb     802db0 <__umoddi3+0x130>
  802d8e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802d92:	29 c8                	sub    %ecx,%eax
  802d94:	19 d7                	sbb    %edx,%edi
  802d96:	89 e9                	mov    %ebp,%ecx
  802d98:	89 fa                	mov    %edi,%edx
  802d9a:	d3 e8                	shr    %cl,%eax
  802d9c:	89 f1                	mov    %esi,%ecx
  802d9e:	d3 e2                	shl    %cl,%edx
  802da0:	89 e9                	mov    %ebp,%ecx
  802da2:	d3 ef                	shr    %cl,%edi
  802da4:	09 d0                	or     %edx,%eax
  802da6:	89 fa                	mov    %edi,%edx
  802da8:	83 c4 14             	add    $0x14,%esp
  802dab:	5e                   	pop    %esi
  802dac:	5f                   	pop    %edi
  802dad:	5d                   	pop    %ebp
  802dae:	c3                   	ret    
  802daf:	90                   	nop
  802db0:	39 d7                	cmp    %edx,%edi
  802db2:	75 da                	jne    802d8e <__umoddi3+0x10e>
  802db4:	8b 14 24             	mov    (%esp),%edx
  802db7:	89 c1                	mov    %eax,%ecx
  802db9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802dbd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802dc1:	eb cb                	jmp    802d8e <__umoddi3+0x10e>
  802dc3:	90                   	nop
  802dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dc8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802dcc:	0f 82 0f ff ff ff    	jb     802ce1 <__umoddi3+0x61>
  802dd2:	e9 1a ff ff ff       	jmp    802cf1 <__umoddi3+0x71>
