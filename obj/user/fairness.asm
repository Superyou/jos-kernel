
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 91 00 00 00       	call   8000c2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 20             	sub    $0x20,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 27 0c 00 00       	call   800c67 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 08 40 80 00 7c 	cmpl   $0xeec0007c,0x804008
  800049:	00 c0 ee 
  80004c:	75 34                	jne    800082 <umain+0x4f>
		while (1) {
			ipc_recv(&who, 0, 0);
  80004e:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800051:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800060:	00 
  800061:	89 34 24             	mov    %esi,(%esp)
  800064:	e8 47 0f 00 00       	call   800fb0 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  800069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80006c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800070:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800074:	c7 04 24 40 27 80 00 	movl   $0x802740,(%esp)
  80007b:	e8 46 01 00 00       	call   8001c6 <cprintf>
  800080:	eb cf                	jmp    800051 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800082:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800087:	89 44 24 08          	mov    %eax,0x8(%esp)
  80008b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80008f:	c7 04 24 51 27 80 00 	movl   $0x802751,(%esp)
  800096:	e8 2b 01 00 00       	call   8001c6 <cprintf>
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80009b:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  8000a0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000a7:	00 
  8000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b7:	00 
  8000b8:	89 04 24             	mov    %eax,(%esp)
  8000bb:	e8 58 0f 00 00       	call   801018 <ipc_send>
  8000c0:	eb d9                	jmp    80009b <umain+0x68>

008000c2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c2:	55                   	push   %ebp
  8000c3:	89 e5                	mov    %esp,%ebp
  8000c5:	56                   	push   %esi
  8000c6:	53                   	push   %ebx
  8000c7:	83 ec 10             	sub    $0x10,%esp
  8000ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000cd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d0:	e8 92 0b 00 00       	call   800c67 <sys_getenvid>
  8000d5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000da:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e2:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e7:	85 db                	test   %ebx,%ebx
  8000e9:	7e 07                	jle    8000f2 <libmain+0x30>
		binaryname = argv[0];
  8000eb:	8b 06                	mov    (%esi),%eax
  8000ed:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000f6:	89 1c 24             	mov    %ebx,(%esp)
  8000f9:	e8 35 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000fe:	e8 07 00 00 00       	call   80010a <exit>
}
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	5b                   	pop    %ebx
  800107:	5e                   	pop    %esi
  800108:	5d                   	pop    %ebp
  800109:	c3                   	ret    

0080010a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010a:	55                   	push   %ebp
  80010b:	89 e5                	mov    %esp,%ebp
  80010d:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800110:	e8 85 11 00 00       	call   80129a <close_all>
	sys_env_destroy(0);
  800115:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80011c:	e8 a2 0a 00 00       	call   800bc3 <sys_env_destroy>
}
  800121:	c9                   	leave  
  800122:	c3                   	ret    

00800123 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800123:	55                   	push   %ebp
  800124:	89 e5                	mov    %esp,%ebp
  800126:	53                   	push   %ebx
  800127:	83 ec 14             	sub    $0x14,%esp
  80012a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012d:	8b 13                	mov    (%ebx),%edx
  80012f:	8d 42 01             	lea    0x1(%edx),%eax
  800132:	89 03                	mov    %eax,(%ebx)
  800134:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800137:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80013b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800140:	75 19                	jne    80015b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800142:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800149:	00 
  80014a:	8d 43 08             	lea    0x8(%ebx),%eax
  80014d:	89 04 24             	mov    %eax,(%esp)
  800150:	e8 31 0a 00 00       	call   800b86 <sys_cputs>
		b->idx = 0;
  800155:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80015b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80015f:	83 c4 14             	add    $0x14,%esp
  800162:	5b                   	pop    %ebx
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    

00800165 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80016e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800175:	00 00 00 
	b.cnt = 0;
  800178:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800182:	8b 45 0c             	mov    0xc(%ebp),%eax
  800185:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800189:	8b 45 08             	mov    0x8(%ebp),%eax
  80018c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800190:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800196:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019a:	c7 04 24 23 01 80 00 	movl   $0x800123,(%esp)
  8001a1:	e8 6e 01 00 00       	call   800314 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b6:	89 04 24             	mov    %eax,(%esp)
  8001b9:	e8 c8 09 00 00       	call   800b86 <sys_cputs>

	return b.cnt;
}
  8001be:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    

008001c6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001cc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d6:	89 04 24             	mov    %eax,(%esp)
  8001d9:	e8 87 ff ff ff       	call   800165 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    

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
  80024f:	e8 5c 22 00 00       	call   8024b0 <__udivdi3>
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
  8002af:	e8 2c 23 00 00       	call   8025e0 <__umoddi3>
  8002b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b8:	0f be 80 72 27 80 00 	movsbl 0x802772(%eax),%eax
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
  800392:	ff 24 95 c0 28 80 00 	jmp    *0x8028c0(,%edx,4)
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
  800426:	8b 14 85 20 2a 80 00 	mov    0x802a20(,%eax,4),%edx
  80042d:	85 d2                	test   %edx,%edx
  80042f:	75 26                	jne    800457 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800431:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800435:	c7 44 24 08 8a 27 80 	movl   $0x80278a,0x8(%esp)
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
  80045b:	c7 44 24 08 9e 2b 80 	movl   $0x802b9e,0x8(%esp)
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
  80048e:	b8 83 27 80 00       	mov    $0x802783,%eax
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
  800bf1:	c7 44 24 08 97 2a 80 	movl   $0x802a97,0x8(%esp)
  800bf8:	00 
  800bf9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c00:	00 
  800c01:	c7 04 24 b4 2a 80 00 	movl   $0x802ab4,(%esp)
  800c08:	e8 09 18 00 00       	call   802416 <_panic>

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
  800c43:	c7 44 24 08 97 2a 80 	movl   $0x802a97,0x8(%esp)
  800c4a:	00 
  800c4b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c52:	00 
  800c53:	c7 04 24 b4 2a 80 00 	movl   $0x802ab4,(%esp)
  800c5a:	e8 b7 17 00 00       	call   802416 <_panic>

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
  800cd5:	c7 44 24 08 97 2a 80 	movl   $0x802a97,0x8(%esp)
  800cdc:	00 
  800cdd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce4:	00 
  800ce5:	c7 04 24 b4 2a 80 00 	movl   $0x802ab4,(%esp)
  800cec:	e8 25 17 00 00       	call   802416 <_panic>

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
  800d28:	c7 44 24 08 97 2a 80 	movl   $0x802a97,0x8(%esp)
  800d2f:	00 
  800d30:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d37:	00 
  800d38:	c7 04 24 b4 2a 80 00 	movl   $0x802ab4,(%esp)
  800d3f:	e8 d2 16 00 00       	call   802416 <_panic>

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
  800d7b:	c7 44 24 08 97 2a 80 	movl   $0x802a97,0x8(%esp)
  800d82:	00 
  800d83:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d8a:	00 
  800d8b:	c7 04 24 b4 2a 80 00 	movl   $0x802ab4,(%esp)
  800d92:	e8 7f 16 00 00       	call   802416 <_panic>

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
  800dee:	c7 44 24 08 97 2a 80 	movl   $0x802a97,0x8(%esp)
  800df5:	00 
  800df6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dfd:	00 
  800dfe:	c7 04 24 b4 2a 80 00 	movl   $0x802ab4,(%esp)
  800e05:	e8 0c 16 00 00       	call   802416 <_panic>

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
  800e41:	c7 44 24 08 97 2a 80 	movl   $0x802a97,0x8(%esp)
  800e48:	00 
  800e49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e50:	00 
  800e51:	c7 04 24 b4 2a 80 00 	movl   $0x802ab4,(%esp)
  800e58:	e8 b9 15 00 00       	call   802416 <_panic>

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
  800e94:	c7 44 24 08 97 2a 80 	movl   $0x802a97,0x8(%esp)
  800e9b:	00 
  800e9c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea3:	00 
  800ea4:	c7 04 24 b4 2a 80 00 	movl   $0x802ab4,(%esp)
  800eab:	e8 66 15 00 00       	call   802416 <_panic>

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
  800f09:	c7 44 24 08 97 2a 80 	movl   $0x802a97,0x8(%esp)
  800f10:	00 
  800f11:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f18:	00 
  800f19:	c7 04 24 b4 2a 80 00 	movl   $0x802ab4,(%esp)
  800f20:	e8 f1 14 00 00       	call   802416 <_panic>

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
  800fae:	66 90                	xchg   %ax,%ax

00800fb0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
  800fb5:	83 ec 10             	sub    $0x10,%esp
  800fb8:	8b 75 08             	mov    0x8(%ebp),%esi
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  800fc1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  800fc3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  800fc8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  800fcb:	89 04 24             	mov    %eax,(%esp)
  800fce:	e8 08 ff ff ff       	call   800edb <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	75 26                	jne    800ffd <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  800fd7:	85 f6                	test   %esi,%esi
  800fd9:	74 0a                	je     800fe5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  800fdb:	a1 08 40 80 00       	mov    0x804008,%eax
  800fe0:	8b 40 74             	mov    0x74(%eax),%eax
  800fe3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  800fe5:	85 db                	test   %ebx,%ebx
  800fe7:	74 0a                	je     800ff3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  800fe9:	a1 08 40 80 00       	mov    0x804008,%eax
  800fee:	8b 40 78             	mov    0x78(%eax),%eax
  800ff1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  800ff3:	a1 08 40 80 00       	mov    0x804008,%eax
  800ff8:	8b 40 70             	mov    0x70(%eax),%eax
  800ffb:	eb 14                	jmp    801011 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  800ffd:	85 f6                	test   %esi,%esi
  800fff:	74 06                	je     801007 <ipc_recv+0x57>
			*from_env_store = 0;
  801001:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801007:	85 db                	test   %ebx,%ebx
  801009:	74 06                	je     801011 <ipc_recv+0x61>
			*perm_store = 0;
  80100b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  801011:	83 c4 10             	add    $0x10,%esp
  801014:	5b                   	pop    %ebx
  801015:	5e                   	pop    %esi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
  80101e:	83 ec 1c             	sub    $0x1c,%esp
  801021:	8b 7d 08             	mov    0x8(%ebp),%edi
  801024:	8b 75 0c             	mov    0xc(%ebp),%esi
  801027:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80102a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80102c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  801031:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80103b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80103f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801043:	89 3c 24             	mov    %edi,(%esp)
  801046:	e8 6d fe ff ff       	call   800eb8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80104b:	85 c0                	test   %eax,%eax
  80104d:	74 28                	je     801077 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80104f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801052:	74 1c                	je     801070 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  801054:	c7 44 24 08 c4 2a 80 	movl   $0x802ac4,0x8(%esp)
  80105b:	00 
  80105c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801063:	00 
  801064:	c7 04 24 e5 2a 80 00 	movl   $0x802ae5,(%esp)
  80106b:	e8 a6 13 00 00       	call   802416 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  801070:	e8 11 fc ff ff       	call   800c86 <sys_yield>
	}
  801075:	eb bd                	jmp    801034 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  801077:	83 c4 1c             	add    $0x1c,%esp
  80107a:	5b                   	pop    %ebx
  80107b:	5e                   	pop    %esi
  80107c:	5f                   	pop    %edi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801085:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80108a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80108d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801093:	8b 52 50             	mov    0x50(%edx),%edx
  801096:	39 ca                	cmp    %ecx,%edx
  801098:	75 0d                	jne    8010a7 <ipc_find_env+0x28>
			return envs[i].env_id;
  80109a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80109d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8010a2:	8b 40 40             	mov    0x40(%eax),%eax
  8010a5:	eb 0e                	jmp    8010b5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8010a7:	83 c0 01             	add    $0x1,%eax
  8010aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8010af:	75 d9                	jne    80108a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8010b1:	66 b8 00 00          	mov    $0x0,%ax
}
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    
  8010b7:	66 90                	xchg   %ax,%ax
  8010b9:	66 90                	xchg   %ax,%ax
  8010bb:	66 90                	xchg   %ax,%ax
  8010bd:	66 90                	xchg   %ax,%ax
  8010bf:	90                   	nop

008010c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010e0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    

008010e7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ed:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010f2:	89 c2                	mov    %eax,%edx
  8010f4:	c1 ea 16             	shr    $0x16,%edx
  8010f7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010fe:	f6 c2 01             	test   $0x1,%dl
  801101:	74 11                	je     801114 <fd_alloc+0x2d>
  801103:	89 c2                	mov    %eax,%edx
  801105:	c1 ea 0c             	shr    $0xc,%edx
  801108:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80110f:	f6 c2 01             	test   $0x1,%dl
  801112:	75 09                	jne    80111d <fd_alloc+0x36>
			*fd_store = fd;
  801114:	89 01                	mov    %eax,(%ecx)
			return 0;
  801116:	b8 00 00 00 00       	mov    $0x0,%eax
  80111b:	eb 17                	jmp    801134 <fd_alloc+0x4d>
  80111d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801122:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801127:	75 c9                	jne    8010f2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801129:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80112f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    

00801136 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80113c:	83 f8 1f             	cmp    $0x1f,%eax
  80113f:	77 36                	ja     801177 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801141:	c1 e0 0c             	shl    $0xc,%eax
  801144:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801149:	89 c2                	mov    %eax,%edx
  80114b:	c1 ea 16             	shr    $0x16,%edx
  80114e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801155:	f6 c2 01             	test   $0x1,%dl
  801158:	74 24                	je     80117e <fd_lookup+0x48>
  80115a:	89 c2                	mov    %eax,%edx
  80115c:	c1 ea 0c             	shr    $0xc,%edx
  80115f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801166:	f6 c2 01             	test   $0x1,%dl
  801169:	74 1a                	je     801185 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80116b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116e:	89 02                	mov    %eax,(%edx)
	return 0;
  801170:	b8 00 00 00 00       	mov    $0x0,%eax
  801175:	eb 13                	jmp    80118a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801177:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80117c:	eb 0c                	jmp    80118a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80117e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801183:	eb 05                	jmp    80118a <fd_lookup+0x54>
  801185:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    

0080118c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	83 ec 18             	sub    $0x18,%esp
  801192:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801195:	ba 00 00 00 00       	mov    $0x0,%edx
  80119a:	eb 13                	jmp    8011af <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80119c:	39 08                	cmp    %ecx,(%eax)
  80119e:	75 0c                	jne    8011ac <dev_lookup+0x20>
			*dev = devtab[i];
  8011a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011aa:	eb 38                	jmp    8011e4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011ac:	83 c2 01             	add    $0x1,%edx
  8011af:	8b 04 95 6c 2b 80 00 	mov    0x802b6c(,%edx,4),%eax
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 e2                	jne    80119c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011ba:	a1 08 40 80 00       	mov    0x804008,%eax
  8011bf:	8b 40 48             	mov    0x48(%eax),%eax
  8011c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ca:	c7 04 24 f0 2a 80 00 	movl   $0x802af0,(%esp)
  8011d1:	e8 f0 ef ff ff       	call   8001c6 <cprintf>
	*dev = 0;
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	56                   	push   %esi
  8011ea:	53                   	push   %ebx
  8011eb:	83 ec 20             	sub    $0x20,%esp
  8011ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8011f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801201:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801204:	89 04 24             	mov    %eax,(%esp)
  801207:	e8 2a ff ff ff       	call   801136 <fd_lookup>
  80120c:	85 c0                	test   %eax,%eax
  80120e:	78 05                	js     801215 <fd_close+0x2f>
	    || fd != fd2)
  801210:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801213:	74 0c                	je     801221 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801215:	84 db                	test   %bl,%bl
  801217:	ba 00 00 00 00       	mov    $0x0,%edx
  80121c:	0f 44 c2             	cmove  %edx,%eax
  80121f:	eb 3f                	jmp    801260 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801221:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801224:	89 44 24 04          	mov    %eax,0x4(%esp)
  801228:	8b 06                	mov    (%esi),%eax
  80122a:	89 04 24             	mov    %eax,(%esp)
  80122d:	e8 5a ff ff ff       	call   80118c <dev_lookup>
  801232:	89 c3                	mov    %eax,%ebx
  801234:	85 c0                	test   %eax,%eax
  801236:	78 16                	js     80124e <fd_close+0x68>
		if (dev->dev_close)
  801238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80123e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801243:	85 c0                	test   %eax,%eax
  801245:	74 07                	je     80124e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801247:	89 34 24             	mov    %esi,(%esp)
  80124a:	ff d0                	call   *%eax
  80124c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80124e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801252:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801259:	e8 ee fa ff ff       	call   800d4c <sys_page_unmap>
	return r;
  80125e:	89 d8                	mov    %ebx,%eax
}
  801260:	83 c4 20             	add    $0x20,%esp
  801263:	5b                   	pop    %ebx
  801264:	5e                   	pop    %esi
  801265:	5d                   	pop    %ebp
  801266:	c3                   	ret    

00801267 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80126d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801270:	89 44 24 04          	mov    %eax,0x4(%esp)
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	89 04 24             	mov    %eax,(%esp)
  80127a:	e8 b7 fe ff ff       	call   801136 <fd_lookup>
  80127f:	89 c2                	mov    %eax,%edx
  801281:	85 d2                	test   %edx,%edx
  801283:	78 13                	js     801298 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801285:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80128c:	00 
  80128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801290:	89 04 24             	mov    %eax,(%esp)
  801293:	e8 4e ff ff ff       	call   8011e6 <fd_close>
}
  801298:	c9                   	leave  
  801299:	c3                   	ret    

0080129a <close_all>:

void
close_all(void)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	53                   	push   %ebx
  80129e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012a6:	89 1c 24             	mov    %ebx,(%esp)
  8012a9:	e8 b9 ff ff ff       	call   801267 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012ae:	83 c3 01             	add    $0x1,%ebx
  8012b1:	83 fb 20             	cmp    $0x20,%ebx
  8012b4:	75 f0                	jne    8012a6 <close_all+0xc>
		close(i);
}
  8012b6:	83 c4 14             	add    $0x14,%esp
  8012b9:	5b                   	pop    %ebx
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	57                   	push   %edi
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	89 04 24             	mov    %eax,(%esp)
  8012d2:	e8 5f fe ff ff       	call   801136 <fd_lookup>
  8012d7:	89 c2                	mov    %eax,%edx
  8012d9:	85 d2                	test   %edx,%edx
  8012db:	0f 88 e1 00 00 00    	js     8013c2 <dup+0x106>
		return r;
	close(newfdnum);
  8012e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e4:	89 04 24             	mov    %eax,(%esp)
  8012e7:	e8 7b ff ff ff       	call   801267 <close>

	newfd = INDEX2FD(newfdnum);
  8012ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012ef:	c1 e3 0c             	shl    $0xc,%ebx
  8012f2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012fb:	89 04 24             	mov    %eax,(%esp)
  8012fe:	e8 cd fd ff ff       	call   8010d0 <fd2data>
  801303:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801305:	89 1c 24             	mov    %ebx,(%esp)
  801308:	e8 c3 fd ff ff       	call   8010d0 <fd2data>
  80130d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80130f:	89 f0                	mov    %esi,%eax
  801311:	c1 e8 16             	shr    $0x16,%eax
  801314:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80131b:	a8 01                	test   $0x1,%al
  80131d:	74 43                	je     801362 <dup+0xa6>
  80131f:	89 f0                	mov    %esi,%eax
  801321:	c1 e8 0c             	shr    $0xc,%eax
  801324:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80132b:	f6 c2 01             	test   $0x1,%dl
  80132e:	74 32                	je     801362 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801330:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801337:	25 07 0e 00 00       	and    $0xe07,%eax
  80133c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801340:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801344:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80134b:	00 
  80134c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801350:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801357:	e8 9d f9 ff ff       	call   800cf9 <sys_page_map>
  80135c:	89 c6                	mov    %eax,%esi
  80135e:	85 c0                	test   %eax,%eax
  801360:	78 3e                	js     8013a0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801365:	89 c2                	mov    %eax,%edx
  801367:	c1 ea 0c             	shr    $0xc,%edx
  80136a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801371:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801377:	89 54 24 10          	mov    %edx,0x10(%esp)
  80137b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80137f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801386:	00 
  801387:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801392:	e8 62 f9 ff ff       	call   800cf9 <sys_page_map>
  801397:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801399:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80139c:	85 f6                	test   %esi,%esi
  80139e:	79 22                	jns    8013c2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ab:	e8 9c f9 ff ff       	call   800d4c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013bb:	e8 8c f9 ff ff       	call   800d4c <sys_page_unmap>
	return r;
  8013c0:	89 f0                	mov    %esi,%eax
}
  8013c2:	83 c4 3c             	add    $0x3c,%esp
  8013c5:	5b                   	pop    %ebx
  8013c6:	5e                   	pop    %esi
  8013c7:	5f                   	pop    %edi
  8013c8:	5d                   	pop    %ebp
  8013c9:	c3                   	ret    

008013ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	53                   	push   %ebx
  8013ce:	83 ec 24             	sub    $0x24,%esp
  8013d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013db:	89 1c 24             	mov    %ebx,(%esp)
  8013de:	e8 53 fd ff ff       	call   801136 <fd_lookup>
  8013e3:	89 c2                	mov    %eax,%edx
  8013e5:	85 d2                	test   %edx,%edx
  8013e7:	78 6d                	js     801456 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f3:	8b 00                	mov    (%eax),%eax
  8013f5:	89 04 24             	mov    %eax,(%esp)
  8013f8:	e8 8f fd ff ff       	call   80118c <dev_lookup>
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 55                	js     801456 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801404:	8b 50 08             	mov    0x8(%eax),%edx
  801407:	83 e2 03             	and    $0x3,%edx
  80140a:	83 fa 01             	cmp    $0x1,%edx
  80140d:	75 23                	jne    801432 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80140f:	a1 08 40 80 00       	mov    0x804008,%eax
  801414:	8b 40 48             	mov    0x48(%eax),%eax
  801417:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80141b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141f:	c7 04 24 31 2b 80 00 	movl   $0x802b31,(%esp)
  801426:	e8 9b ed ff ff       	call   8001c6 <cprintf>
		return -E_INVAL;
  80142b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801430:	eb 24                	jmp    801456 <read+0x8c>
	}
	if (!dev->dev_read)
  801432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801435:	8b 52 08             	mov    0x8(%edx),%edx
  801438:	85 d2                	test   %edx,%edx
  80143a:	74 15                	je     801451 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80143c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80143f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801443:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801446:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80144a:	89 04 24             	mov    %eax,(%esp)
  80144d:	ff d2                	call   *%edx
  80144f:	eb 05                	jmp    801456 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801451:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801456:	83 c4 24             	add    $0x24,%esp
  801459:	5b                   	pop    %ebx
  80145a:	5d                   	pop    %ebp
  80145b:	c3                   	ret    

0080145c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	57                   	push   %edi
  801460:	56                   	push   %esi
  801461:	53                   	push   %ebx
  801462:	83 ec 1c             	sub    $0x1c,%esp
  801465:	8b 7d 08             	mov    0x8(%ebp),%edi
  801468:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80146b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801470:	eb 23                	jmp    801495 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801472:	89 f0                	mov    %esi,%eax
  801474:	29 d8                	sub    %ebx,%eax
  801476:	89 44 24 08          	mov    %eax,0x8(%esp)
  80147a:	89 d8                	mov    %ebx,%eax
  80147c:	03 45 0c             	add    0xc(%ebp),%eax
  80147f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801483:	89 3c 24             	mov    %edi,(%esp)
  801486:	e8 3f ff ff ff       	call   8013ca <read>
		if (m < 0)
  80148b:	85 c0                	test   %eax,%eax
  80148d:	78 10                	js     80149f <readn+0x43>
			return m;
		if (m == 0)
  80148f:	85 c0                	test   %eax,%eax
  801491:	74 0a                	je     80149d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801493:	01 c3                	add    %eax,%ebx
  801495:	39 f3                	cmp    %esi,%ebx
  801497:	72 d9                	jb     801472 <readn+0x16>
  801499:	89 d8                	mov    %ebx,%eax
  80149b:	eb 02                	jmp    80149f <readn+0x43>
  80149d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80149f:	83 c4 1c             	add    $0x1c,%esp
  8014a2:	5b                   	pop    %ebx
  8014a3:	5e                   	pop    %esi
  8014a4:	5f                   	pop    %edi
  8014a5:	5d                   	pop    %ebp
  8014a6:	c3                   	ret    

008014a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	53                   	push   %ebx
  8014ab:	83 ec 24             	sub    $0x24,%esp
  8014ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b8:	89 1c 24             	mov    %ebx,(%esp)
  8014bb:	e8 76 fc ff ff       	call   801136 <fd_lookup>
  8014c0:	89 c2                	mov    %eax,%edx
  8014c2:	85 d2                	test   %edx,%edx
  8014c4:	78 68                	js     80152e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d0:	8b 00                	mov    (%eax),%eax
  8014d2:	89 04 24             	mov    %eax,(%esp)
  8014d5:	e8 b2 fc ff ff       	call   80118c <dev_lookup>
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	78 50                	js     80152e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014e5:	75 23                	jne    80150a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8014ec:	8b 40 48             	mov    0x48(%eax),%eax
  8014ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f7:	c7 04 24 4d 2b 80 00 	movl   $0x802b4d,(%esp)
  8014fe:	e8 c3 ec ff ff       	call   8001c6 <cprintf>
		return -E_INVAL;
  801503:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801508:	eb 24                	jmp    80152e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80150a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150d:	8b 52 0c             	mov    0xc(%edx),%edx
  801510:	85 d2                	test   %edx,%edx
  801512:	74 15                	je     801529 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801514:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801517:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80151b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80151e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801522:	89 04 24             	mov    %eax,(%esp)
  801525:	ff d2                	call   *%edx
  801527:	eb 05                	jmp    80152e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801529:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80152e:	83 c4 24             	add    $0x24,%esp
  801531:	5b                   	pop    %ebx
  801532:	5d                   	pop    %ebp
  801533:	c3                   	ret    

00801534 <seek>:

int
seek(int fdnum, off_t offset)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80153a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80153d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 04 24             	mov    %eax,(%esp)
  801547:	e8 ea fb ff ff       	call   801136 <fd_lookup>
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 0e                	js     80155e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801550:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801553:	8b 55 0c             	mov    0xc(%ebp),%edx
  801556:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	53                   	push   %ebx
  801564:	83 ec 24             	sub    $0x24,%esp
  801567:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80156a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80156d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801571:	89 1c 24             	mov    %ebx,(%esp)
  801574:	e8 bd fb ff ff       	call   801136 <fd_lookup>
  801579:	89 c2                	mov    %eax,%edx
  80157b:	85 d2                	test   %edx,%edx
  80157d:	78 61                	js     8015e0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801582:	89 44 24 04          	mov    %eax,0x4(%esp)
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801589:	8b 00                	mov    (%eax),%eax
  80158b:	89 04 24             	mov    %eax,(%esp)
  80158e:	e8 f9 fb ff ff       	call   80118c <dev_lookup>
  801593:	85 c0                	test   %eax,%eax
  801595:	78 49                	js     8015e0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80159e:	75 23                	jne    8015c3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015a0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015a5:	8b 40 48             	mov    0x48(%eax),%eax
  8015a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b0:	c7 04 24 10 2b 80 00 	movl   $0x802b10,(%esp)
  8015b7:	e8 0a ec ff ff       	call   8001c6 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c1:	eb 1d                	jmp    8015e0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c6:	8b 52 18             	mov    0x18(%edx),%edx
  8015c9:	85 d2                	test   %edx,%edx
  8015cb:	74 0e                	je     8015db <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015d4:	89 04 24             	mov    %eax,(%esp)
  8015d7:	ff d2                	call   *%edx
  8015d9:	eb 05                	jmp    8015e0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015e0:	83 c4 24             	add    $0x24,%esp
  8015e3:	5b                   	pop    %ebx
  8015e4:	5d                   	pop    %ebp
  8015e5:	c3                   	ret    

008015e6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	53                   	push   %ebx
  8015ea:	83 ec 24             	sub    $0x24,%esp
  8015ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	89 04 24             	mov    %eax,(%esp)
  8015fd:	e8 34 fb ff ff       	call   801136 <fd_lookup>
  801602:	89 c2                	mov    %eax,%edx
  801604:	85 d2                	test   %edx,%edx
  801606:	78 52                	js     80165a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801608:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801612:	8b 00                	mov    (%eax),%eax
  801614:	89 04 24             	mov    %eax,(%esp)
  801617:	e8 70 fb ff ff       	call   80118c <dev_lookup>
  80161c:	85 c0                	test   %eax,%eax
  80161e:	78 3a                	js     80165a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801623:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801627:	74 2c                	je     801655 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801629:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80162c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801633:	00 00 00 
	stat->st_isdir = 0;
  801636:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80163d:	00 00 00 
	stat->st_dev = dev;
  801640:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801646:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80164a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80164d:	89 14 24             	mov    %edx,(%esp)
  801650:	ff 50 14             	call   *0x14(%eax)
  801653:	eb 05                	jmp    80165a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801655:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80165a:	83 c4 24             	add    $0x24,%esp
  80165d:	5b                   	pop    %ebx
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	56                   	push   %esi
  801664:	53                   	push   %ebx
  801665:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801668:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80166f:	00 
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	89 04 24             	mov    %eax,(%esp)
  801676:	e8 99 02 00 00       	call   801914 <open>
  80167b:	89 c3                	mov    %eax,%ebx
  80167d:	85 db                	test   %ebx,%ebx
  80167f:	78 1b                	js     80169c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801681:	8b 45 0c             	mov    0xc(%ebp),%eax
  801684:	89 44 24 04          	mov    %eax,0x4(%esp)
  801688:	89 1c 24             	mov    %ebx,(%esp)
  80168b:	e8 56 ff ff ff       	call   8015e6 <fstat>
  801690:	89 c6                	mov    %eax,%esi
	close(fd);
  801692:	89 1c 24             	mov    %ebx,(%esp)
  801695:	e8 cd fb ff ff       	call   801267 <close>
	return r;
  80169a:	89 f0                	mov    %esi,%eax
}
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	5b                   	pop    %ebx
  8016a0:	5e                   	pop    %esi
  8016a1:	5d                   	pop    %ebp
  8016a2:	c3                   	ret    

008016a3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	56                   	push   %esi
  8016a7:	53                   	push   %ebx
  8016a8:	83 ec 10             	sub    $0x10,%esp
  8016ab:	89 c6                	mov    %eax,%esi
  8016ad:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016af:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016b6:	75 11                	jne    8016c9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016bf:	e8 bb f9 ff ff       	call   80107f <ipc_find_env>
  8016c4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016c9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016d0:	00 
  8016d1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8016d8:	00 
  8016d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016dd:	a1 00 40 80 00       	mov    0x804000,%eax
  8016e2:	89 04 24             	mov    %eax,(%esp)
  8016e5:	e8 2e f9 ff ff       	call   801018 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016f1:	00 
  8016f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016fd:	e8 ae f8 ff ff       	call   800fb0 <ipc_recv>
}
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	5b                   	pop    %ebx
  801706:	5e                   	pop    %esi
  801707:	5d                   	pop    %ebp
  801708:	c3                   	ret    

00801709 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8b 40 0c             	mov    0xc(%eax),%eax
  801715:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80171a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801722:	ba 00 00 00 00       	mov    $0x0,%edx
  801727:	b8 02 00 00 00       	mov    $0x2,%eax
  80172c:	e8 72 ff ff ff       	call   8016a3 <fsipc>
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8b 40 0c             	mov    0xc(%eax),%eax
  80173f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801744:	ba 00 00 00 00       	mov    $0x0,%edx
  801749:	b8 06 00 00 00       	mov    $0x6,%eax
  80174e:	e8 50 ff ff ff       	call   8016a3 <fsipc>
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	53                   	push   %ebx
  801759:	83 ec 14             	sub    $0x14,%esp
  80175c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	8b 40 0c             	mov    0xc(%eax),%eax
  801765:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80176a:	ba 00 00 00 00       	mov    $0x0,%edx
  80176f:	b8 05 00 00 00       	mov    $0x5,%eax
  801774:	e8 2a ff ff ff       	call   8016a3 <fsipc>
  801779:	89 c2                	mov    %eax,%edx
  80177b:	85 d2                	test   %edx,%edx
  80177d:	78 2b                	js     8017aa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80177f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801786:	00 
  801787:	89 1c 24             	mov    %ebx,(%esp)
  80178a:	e8 a8 f0 ff ff       	call   800837 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80178f:	a1 80 50 80 00       	mov    0x805080,%eax
  801794:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80179a:	a1 84 50 80 00       	mov    0x805084,%eax
  80179f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017aa:	83 c4 14             	add    $0x14,%esp
  8017ad:	5b                   	pop    %ebx
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 14             	sub    $0x14,%esp
  8017b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  8017ba:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  8017c0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8017c5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017cb:	8b 52 0c             	mov    0xc(%edx),%edx
  8017ce:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  8017d4:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  8017d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e4:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8017eb:	e8 e4 f1 ff ff       	call   8009d4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  8017f0:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  8017f7:	00 
  8017f8:	c7 04 24 80 2b 80 00 	movl   $0x802b80,(%esp)
  8017ff:	e8 c2 e9 ff ff       	call   8001c6 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801804:	ba 00 00 00 00       	mov    $0x0,%edx
  801809:	b8 04 00 00 00       	mov    $0x4,%eax
  80180e:	e8 90 fe ff ff       	call   8016a3 <fsipc>
  801813:	85 c0                	test   %eax,%eax
  801815:	78 53                	js     80186a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801817:	39 c3                	cmp    %eax,%ebx
  801819:	73 24                	jae    80183f <devfile_write+0x8f>
  80181b:	c7 44 24 0c 85 2b 80 	movl   $0x802b85,0xc(%esp)
  801822:	00 
  801823:	c7 44 24 08 8c 2b 80 	movl   $0x802b8c,0x8(%esp)
  80182a:	00 
  80182b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801832:	00 
  801833:	c7 04 24 a1 2b 80 00 	movl   $0x802ba1,(%esp)
  80183a:	e8 d7 0b 00 00       	call   802416 <_panic>
	assert(r <= PGSIZE);
  80183f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801844:	7e 24                	jle    80186a <devfile_write+0xba>
  801846:	c7 44 24 0c ac 2b 80 	movl   $0x802bac,0xc(%esp)
  80184d:	00 
  80184e:	c7 44 24 08 8c 2b 80 	movl   $0x802b8c,0x8(%esp)
  801855:	00 
  801856:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  80185d:	00 
  80185e:	c7 04 24 a1 2b 80 00 	movl   $0x802ba1,(%esp)
  801865:	e8 ac 0b 00 00       	call   802416 <_panic>
	return r;
}
  80186a:	83 c4 14             	add    $0x14,%esp
  80186d:	5b                   	pop    %ebx
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    

00801870 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	56                   	push   %esi
  801874:	53                   	push   %ebx
  801875:	83 ec 10             	sub    $0x10,%esp
  801878:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	8b 40 0c             	mov    0xc(%eax),%eax
  801881:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801886:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80188c:	ba 00 00 00 00       	mov    $0x0,%edx
  801891:	b8 03 00 00 00       	mov    $0x3,%eax
  801896:	e8 08 fe ff ff       	call   8016a3 <fsipc>
  80189b:	89 c3                	mov    %eax,%ebx
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 6a                	js     80190b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018a1:	39 c6                	cmp    %eax,%esi
  8018a3:	73 24                	jae    8018c9 <devfile_read+0x59>
  8018a5:	c7 44 24 0c 85 2b 80 	movl   $0x802b85,0xc(%esp)
  8018ac:	00 
  8018ad:	c7 44 24 08 8c 2b 80 	movl   $0x802b8c,0x8(%esp)
  8018b4:	00 
  8018b5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8018bc:	00 
  8018bd:	c7 04 24 a1 2b 80 00 	movl   $0x802ba1,(%esp)
  8018c4:	e8 4d 0b 00 00       	call   802416 <_panic>
	assert(r <= PGSIZE);
  8018c9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ce:	7e 24                	jle    8018f4 <devfile_read+0x84>
  8018d0:	c7 44 24 0c ac 2b 80 	movl   $0x802bac,0xc(%esp)
  8018d7:	00 
  8018d8:	c7 44 24 08 8c 2b 80 	movl   $0x802b8c,0x8(%esp)
  8018df:	00 
  8018e0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8018e7:	00 
  8018e8:	c7 04 24 a1 2b 80 00 	movl   $0x802ba1,(%esp)
  8018ef:	e8 22 0b 00 00       	call   802416 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018f8:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8018ff:	00 
  801900:	8b 45 0c             	mov    0xc(%ebp),%eax
  801903:	89 04 24             	mov    %eax,(%esp)
  801906:	e8 c9 f0 ff ff       	call   8009d4 <memmove>
	return r;
}
  80190b:	89 d8                	mov    %ebx,%eax
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	5b                   	pop    %ebx
  801911:	5e                   	pop    %esi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    

00801914 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	53                   	push   %ebx
  801918:	83 ec 24             	sub    $0x24,%esp
  80191b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80191e:	89 1c 24             	mov    %ebx,(%esp)
  801921:	e8 da ee ff ff       	call   800800 <strlen>
  801926:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80192b:	7f 60                	jg     80198d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80192d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801930:	89 04 24             	mov    %eax,(%esp)
  801933:	e8 af f7 ff ff       	call   8010e7 <fd_alloc>
  801938:	89 c2                	mov    %eax,%edx
  80193a:	85 d2                	test   %edx,%edx
  80193c:	78 54                	js     801992 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80193e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801942:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801949:	e8 e9 ee ff ff       	call   800837 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80194e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801951:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801956:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801959:	b8 01 00 00 00       	mov    $0x1,%eax
  80195e:	e8 40 fd ff ff       	call   8016a3 <fsipc>
  801963:	89 c3                	mov    %eax,%ebx
  801965:	85 c0                	test   %eax,%eax
  801967:	79 17                	jns    801980 <open+0x6c>
		fd_close(fd, 0);
  801969:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801970:	00 
  801971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801974:	89 04 24             	mov    %eax,(%esp)
  801977:	e8 6a f8 ff ff       	call   8011e6 <fd_close>
		return r;
  80197c:	89 d8                	mov    %ebx,%eax
  80197e:	eb 12                	jmp    801992 <open+0x7e>
	}

	return fd2num(fd);
  801980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801983:	89 04 24             	mov    %eax,(%esp)
  801986:	e8 35 f7 ff ff       	call   8010c0 <fd2num>
  80198b:	eb 05                	jmp    801992 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80198d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801992:	83 c4 24             	add    $0x24,%esp
  801995:	5b                   	pop    %ebx
  801996:	5d                   	pop    %ebp
  801997:	c3                   	ret    

00801998 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80199e:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a3:	b8 08 00 00 00       	mov    $0x8,%eax
  8019a8:	e8 f6 fc ff ff       	call   8016a3 <fsipc>
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <evict>:

int evict(void)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  8019b5:	c7 04 24 b8 2b 80 00 	movl   $0x802bb8,(%esp)
  8019bc:	e8 05 e8 ff ff       	call   8001c6 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  8019c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c6:	b8 09 00 00 00       	mov    $0x9,%eax
  8019cb:	e8 d3 fc ff ff       	call   8016a3 <fsipc>
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    
  8019d2:	66 90                	xchg   %ax,%ax
  8019d4:	66 90                	xchg   %ax,%ax
  8019d6:	66 90                	xchg   %ax,%ax
  8019d8:	66 90                	xchg   %ax,%ax
  8019da:	66 90                	xchg   %ax,%ax
  8019dc:	66 90                	xchg   %ax,%ax
  8019de:	66 90                	xchg   %ax,%ax

008019e0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8019e6:	c7 44 24 04 d1 2b 80 	movl   $0x802bd1,0x4(%esp)
  8019ed:	00 
  8019ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f1:	89 04 24             	mov    %eax,(%esp)
  8019f4:	e8 3e ee ff ff       	call   800837 <strcpy>
	return 0;
}
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	53                   	push   %ebx
  801a04:	83 ec 14             	sub    $0x14,%esp
  801a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a0a:	89 1c 24             	mov    %ebx,(%esp)
  801a0d:	e8 5a 0a 00 00       	call   80246c <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801a12:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801a17:	83 f8 01             	cmp    $0x1,%eax
  801a1a:	75 0d                	jne    801a29 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801a1c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801a1f:	89 04 24             	mov    %eax,(%esp)
  801a22:	e8 29 03 00 00       	call   801d50 <nsipc_close>
  801a27:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801a29:	89 d0                	mov    %edx,%eax
  801a2b:	83 c4 14             	add    $0x14,%esp
  801a2e:	5b                   	pop    %ebx
  801a2f:	5d                   	pop    %ebp
  801a30:	c3                   	ret    

00801a31 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a37:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a3e:	00 
  801a3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	8b 40 0c             	mov    0xc(%eax),%eax
  801a53:	89 04 24             	mov    %eax,(%esp)
  801a56:	e8 f0 03 00 00       	call   801e4b <nsipc_send>
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a63:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a6a:	00 
  801a6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7f:	89 04 24             	mov    %eax,(%esp)
  801a82:	e8 44 03 00 00       	call   801dcb <nsipc_recv>
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a8f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a92:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a96:	89 04 24             	mov    %eax,(%esp)
  801a99:	e8 98 f6 ff ff       	call   801136 <fd_lookup>
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 17                	js     801ab9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801aab:	39 08                	cmp    %ecx,(%eax)
  801aad:	75 05                	jne    801ab4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801aaf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab2:	eb 05                	jmp    801ab9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ab4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	56                   	push   %esi
  801abf:	53                   	push   %ebx
  801ac0:	83 ec 20             	sub    $0x20,%esp
  801ac3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ac5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac8:	89 04 24             	mov    %eax,(%esp)
  801acb:	e8 17 f6 ff ff       	call   8010e7 <fd_alloc>
  801ad0:	89 c3                	mov    %eax,%ebx
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 21                	js     801af7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ad6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801add:	00 
  801ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aec:	e8 b4 f1 ff ff       	call   800ca5 <sys_page_alloc>
  801af1:	89 c3                	mov    %eax,%ebx
  801af3:	85 c0                	test   %eax,%eax
  801af5:	79 0c                	jns    801b03 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801af7:	89 34 24             	mov    %esi,(%esp)
  801afa:	e8 51 02 00 00       	call   801d50 <nsipc_close>
		return r;
  801aff:	89 d8                	mov    %ebx,%eax
  801b01:	eb 20                	jmp    801b23 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801b03:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b11:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801b18:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801b1b:	89 14 24             	mov    %edx,(%esp)
  801b1e:	e8 9d f5 ff ff       	call   8010c0 <fd2num>
}
  801b23:	83 c4 20             	add    $0x20,%esp
  801b26:	5b                   	pop    %ebx
  801b27:	5e                   	pop    %esi
  801b28:	5d                   	pop    %ebp
  801b29:	c3                   	ret    

00801b2a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	e8 51 ff ff ff       	call   801a89 <fd2sockid>
		return r;
  801b38:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	78 23                	js     801b61 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b3e:	8b 55 10             	mov    0x10(%ebp),%edx
  801b41:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b48:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b4c:	89 04 24             	mov    %eax,(%esp)
  801b4f:	e8 45 01 00 00       	call   801c99 <nsipc_accept>
		return r;
  801b54:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b56:	85 c0                	test   %eax,%eax
  801b58:	78 07                	js     801b61 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801b5a:	e8 5c ff ff ff       	call   801abb <alloc_sockfd>
  801b5f:	89 c1                	mov    %eax,%ecx
}
  801b61:	89 c8                	mov    %ecx,%eax
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	e8 16 ff ff ff       	call   801a89 <fd2sockid>
  801b73:	89 c2                	mov    %eax,%edx
  801b75:	85 d2                	test   %edx,%edx
  801b77:	78 16                	js     801b8f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801b79:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b87:	89 14 24             	mov    %edx,(%esp)
  801b8a:	e8 60 01 00 00       	call   801cef <nsipc_bind>
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <shutdown>:

int
shutdown(int s, int how)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	e8 ea fe ff ff       	call   801a89 <fd2sockid>
  801b9f:	89 c2                	mov    %eax,%edx
  801ba1:	85 d2                	test   %edx,%edx
  801ba3:	78 0f                	js     801bb4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bac:	89 14 24             	mov    %edx,(%esp)
  801baf:	e8 7a 01 00 00       	call   801d2e <nsipc_shutdown>
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	e8 c5 fe ff ff       	call   801a89 <fd2sockid>
  801bc4:	89 c2                	mov    %eax,%edx
  801bc6:	85 d2                	test   %edx,%edx
  801bc8:	78 16                	js     801be0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801bca:	8b 45 10             	mov    0x10(%ebp),%eax
  801bcd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd8:	89 14 24             	mov    %edx,(%esp)
  801bdb:	e8 8a 01 00 00       	call   801d6a <nsipc_connect>
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <listen>:

int
listen(int s, int backlog)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	e8 99 fe ff ff       	call   801a89 <fd2sockid>
  801bf0:	89 c2                	mov    %eax,%edx
  801bf2:	85 d2                	test   %edx,%edx
  801bf4:	78 0f                	js     801c05 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfd:	89 14 24             	mov    %edx,(%esp)
  801c00:	e8 a4 01 00 00       	call   801da9 <nsipc_listen>
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c10:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	89 04 24             	mov    %eax,(%esp)
  801c21:	e8 98 02 00 00       	call   801ebe <nsipc_socket>
  801c26:	89 c2                	mov    %eax,%edx
  801c28:	85 d2                	test   %edx,%edx
  801c2a:	78 05                	js     801c31 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801c2c:	e8 8a fe ff ff       	call   801abb <alloc_sockfd>
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	53                   	push   %ebx
  801c37:	83 ec 14             	sub    $0x14,%esp
  801c3a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c3c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c43:	75 11                	jne    801c56 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c45:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801c4c:	e8 2e f4 ff ff       	call   80107f <ipc_find_env>
  801c51:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c56:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c5d:	00 
  801c5e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c65:	00 
  801c66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c6a:	a1 04 40 80 00       	mov    0x804004,%eax
  801c6f:	89 04 24             	mov    %eax,(%esp)
  801c72:	e8 a1 f3 ff ff       	call   801018 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c77:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c7e:	00 
  801c7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c86:	00 
  801c87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c8e:	e8 1d f3 ff ff       	call   800fb0 <ipc_recv>
}
  801c93:	83 c4 14             	add    $0x14,%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5d                   	pop    %ebp
  801c98:	c3                   	ret    

00801c99 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	56                   	push   %esi
  801c9d:	53                   	push   %ebx
  801c9e:	83 ec 10             	sub    $0x10,%esp
  801ca1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cac:	8b 06                	mov    (%esi),%eax
  801cae:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cb3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb8:	e8 76 ff ff ff       	call   801c33 <nsipc>
  801cbd:	89 c3                	mov    %eax,%ebx
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	78 23                	js     801ce6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cc3:	a1 10 60 80 00       	mov    0x806010,%eax
  801cc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ccc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cd3:	00 
  801cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd7:	89 04 24             	mov    %eax,(%esp)
  801cda:	e8 f5 ec ff ff       	call   8009d4 <memmove>
		*addrlen = ret->ret_addrlen;
  801cdf:	a1 10 60 80 00       	mov    0x806010,%eax
  801ce4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801ce6:	89 d8                	mov    %ebx,%eax
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5e                   	pop    %esi
  801ced:	5d                   	pop    %ebp
  801cee:	c3                   	ret    

00801cef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	53                   	push   %ebx
  801cf3:	83 ec 14             	sub    $0x14,%esp
  801cf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d01:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d13:	e8 bc ec ff ff       	call   8009d4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d18:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d1e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d23:	e8 0b ff ff ff       	call   801c33 <nsipc>
}
  801d28:	83 c4 14             	add    $0x14,%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5d                   	pop    %ebp
  801d2d:	c3                   	ret    

00801d2e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d44:	b8 03 00 00 00       	mov    $0x3,%eax
  801d49:	e8 e5 fe ff ff       	call   801c33 <nsipc>
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <nsipc_close>:

int
nsipc_close(int s)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d5e:	b8 04 00 00 00       	mov    $0x4,%eax
  801d63:	e8 cb fe ff ff       	call   801c33 <nsipc>
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	53                   	push   %ebx
  801d6e:	83 ec 14             	sub    $0x14,%esp
  801d71:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d7c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d87:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d8e:	e8 41 ec ff ff       	call   8009d4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d93:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d99:	b8 05 00 00 00       	mov    $0x5,%eax
  801d9e:	e8 90 fe ff ff       	call   801c33 <nsipc>
}
  801da3:	83 c4 14             	add    $0x14,%esp
  801da6:	5b                   	pop    %ebx
  801da7:	5d                   	pop    %ebp
  801da8:	c3                   	ret    

00801da9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dba:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801dbf:	b8 06 00 00 00       	mov    $0x6,%eax
  801dc4:	e8 6a fe ff ff       	call   801c33 <nsipc>
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	56                   	push   %esi
  801dcf:	53                   	push   %ebx
  801dd0:	83 ec 10             	sub    $0x10,%esp
  801dd3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dde:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801de4:	8b 45 14             	mov    0x14(%ebp),%eax
  801de7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801dec:	b8 07 00 00 00       	mov    $0x7,%eax
  801df1:	e8 3d fe ff ff       	call   801c33 <nsipc>
  801df6:	89 c3                	mov    %eax,%ebx
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	78 46                	js     801e42 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801dfc:	39 f0                	cmp    %esi,%eax
  801dfe:	7f 07                	jg     801e07 <nsipc_recv+0x3c>
  801e00:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e05:	7e 24                	jle    801e2b <nsipc_recv+0x60>
  801e07:	c7 44 24 0c dd 2b 80 	movl   $0x802bdd,0xc(%esp)
  801e0e:	00 
  801e0f:	c7 44 24 08 8c 2b 80 	movl   $0x802b8c,0x8(%esp)
  801e16:	00 
  801e17:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801e1e:	00 
  801e1f:	c7 04 24 f2 2b 80 00 	movl   $0x802bf2,(%esp)
  801e26:	e8 eb 05 00 00       	call   802416 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e2f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e36:	00 
  801e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3a:	89 04 24             	mov    %eax,(%esp)
  801e3d:	e8 92 eb ff ff       	call   8009d4 <memmove>
	}

	return r;
}
  801e42:	89 d8                	mov    %ebx,%eax
  801e44:	83 c4 10             	add    $0x10,%esp
  801e47:	5b                   	pop    %ebx
  801e48:	5e                   	pop    %esi
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    

00801e4b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	53                   	push   %ebx
  801e4f:	83 ec 14             	sub    $0x14,%esp
  801e52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e5d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e63:	7e 24                	jle    801e89 <nsipc_send+0x3e>
  801e65:	c7 44 24 0c fe 2b 80 	movl   $0x802bfe,0xc(%esp)
  801e6c:	00 
  801e6d:	c7 44 24 08 8c 2b 80 	movl   $0x802b8c,0x8(%esp)
  801e74:	00 
  801e75:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801e7c:	00 
  801e7d:	c7 04 24 f2 2b 80 00 	movl   $0x802bf2,(%esp)
  801e84:	e8 8d 05 00 00       	call   802416 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e89:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e94:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801e9b:	e8 34 eb ff ff       	call   8009d4 <memmove>
	nsipcbuf.send.req_size = size;
  801ea0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801eae:	b8 08 00 00 00       	mov    $0x8,%eax
  801eb3:	e8 7b fd ff ff       	call   801c33 <nsipc>
}
  801eb8:	83 c4 14             	add    $0x14,%esp
  801ebb:	5b                   	pop    %ebx
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    

00801ebe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801edc:	b8 09 00 00 00       	mov    $0x9,%eax
  801ee1:	e8 4d fd ff ff       	call   801c33 <nsipc>
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	56                   	push   %esi
  801eec:	53                   	push   %ebx
  801eed:	83 ec 10             	sub    $0x10,%esp
  801ef0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	89 04 24             	mov    %eax,(%esp)
  801ef9:	e8 d2 f1 ff ff       	call   8010d0 <fd2data>
  801efe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f00:	c7 44 24 04 0a 2c 80 	movl   $0x802c0a,0x4(%esp)
  801f07:	00 
  801f08:	89 1c 24             	mov    %ebx,(%esp)
  801f0b:	e8 27 e9 ff ff       	call   800837 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f10:	8b 46 04             	mov    0x4(%esi),%eax
  801f13:	2b 06                	sub    (%esi),%eax
  801f15:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f1b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f22:	00 00 00 
	stat->st_dev = &devpipe;
  801f25:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f2c:	30 80 00 
	return 0;
}
  801f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5d                   	pop    %ebp
  801f3a:	c3                   	ret    

00801f3b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	53                   	push   %ebx
  801f3f:	83 ec 14             	sub    $0x14,%esp
  801f42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f45:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f50:	e8 f7 ed ff ff       	call   800d4c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f55:	89 1c 24             	mov    %ebx,(%esp)
  801f58:	e8 73 f1 ff ff       	call   8010d0 <fd2data>
  801f5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f68:	e8 df ed ff ff       	call   800d4c <sys_page_unmap>
}
  801f6d:	83 c4 14             	add    $0x14,%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    

00801f73 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	57                   	push   %edi
  801f77:	56                   	push   %esi
  801f78:	53                   	push   %ebx
  801f79:	83 ec 2c             	sub    $0x2c,%esp
  801f7c:	89 c6                	mov    %eax,%esi
  801f7e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f81:	a1 08 40 80 00       	mov    0x804008,%eax
  801f86:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f89:	89 34 24             	mov    %esi,(%esp)
  801f8c:	e8 db 04 00 00       	call   80246c <pageref>
  801f91:	89 c7                	mov    %eax,%edi
  801f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f96:	89 04 24             	mov    %eax,(%esp)
  801f99:	e8 ce 04 00 00       	call   80246c <pageref>
  801f9e:	39 c7                	cmp    %eax,%edi
  801fa0:	0f 94 c2             	sete   %dl
  801fa3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801fa6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801fac:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801faf:	39 fb                	cmp    %edi,%ebx
  801fb1:	74 21                	je     801fd4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801fb3:	84 d2                	test   %dl,%dl
  801fb5:	74 ca                	je     801f81 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fb7:	8b 51 58             	mov    0x58(%ecx),%edx
  801fba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fbe:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fc2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fc6:	c7 04 24 11 2c 80 00 	movl   $0x802c11,(%esp)
  801fcd:	e8 f4 e1 ff ff       	call   8001c6 <cprintf>
  801fd2:	eb ad                	jmp    801f81 <_pipeisclosed+0xe>
	}
}
  801fd4:	83 c4 2c             	add    $0x2c,%esp
  801fd7:	5b                   	pop    %ebx
  801fd8:	5e                   	pop    %esi
  801fd9:	5f                   	pop    %edi
  801fda:	5d                   	pop    %ebp
  801fdb:	c3                   	ret    

00801fdc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	57                   	push   %edi
  801fe0:	56                   	push   %esi
  801fe1:	53                   	push   %ebx
  801fe2:	83 ec 1c             	sub    $0x1c,%esp
  801fe5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fe8:	89 34 24             	mov    %esi,(%esp)
  801feb:	e8 e0 f0 ff ff       	call   8010d0 <fd2data>
  801ff0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ff2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff7:	eb 45                	jmp    80203e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801ff9:	89 da                	mov    %ebx,%edx
  801ffb:	89 f0                	mov    %esi,%eax
  801ffd:	e8 71 ff ff ff       	call   801f73 <_pipeisclosed>
  802002:	85 c0                	test   %eax,%eax
  802004:	75 41                	jne    802047 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802006:	e8 7b ec ff ff       	call   800c86 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80200b:	8b 43 04             	mov    0x4(%ebx),%eax
  80200e:	8b 0b                	mov    (%ebx),%ecx
  802010:	8d 51 20             	lea    0x20(%ecx),%edx
  802013:	39 d0                	cmp    %edx,%eax
  802015:	73 e2                	jae    801ff9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802017:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80201a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80201e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802021:	99                   	cltd   
  802022:	c1 ea 1b             	shr    $0x1b,%edx
  802025:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802028:	83 e1 1f             	and    $0x1f,%ecx
  80202b:	29 d1                	sub    %edx,%ecx
  80202d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802031:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802035:	83 c0 01             	add    $0x1,%eax
  802038:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80203b:	83 c7 01             	add    $0x1,%edi
  80203e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802041:	75 c8                	jne    80200b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802043:	89 f8                	mov    %edi,%eax
  802045:	eb 05                	jmp    80204c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80204c:	83 c4 1c             	add    $0x1c,%esp
  80204f:	5b                   	pop    %ebx
  802050:	5e                   	pop    %esi
  802051:	5f                   	pop    %edi
  802052:	5d                   	pop    %ebp
  802053:	c3                   	ret    

00802054 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	57                   	push   %edi
  802058:	56                   	push   %esi
  802059:	53                   	push   %ebx
  80205a:	83 ec 1c             	sub    $0x1c,%esp
  80205d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802060:	89 3c 24             	mov    %edi,(%esp)
  802063:	e8 68 f0 ff ff       	call   8010d0 <fd2data>
  802068:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80206a:	be 00 00 00 00       	mov    $0x0,%esi
  80206f:	eb 3d                	jmp    8020ae <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802071:	85 f6                	test   %esi,%esi
  802073:	74 04                	je     802079 <devpipe_read+0x25>
				return i;
  802075:	89 f0                	mov    %esi,%eax
  802077:	eb 43                	jmp    8020bc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802079:	89 da                	mov    %ebx,%edx
  80207b:	89 f8                	mov    %edi,%eax
  80207d:	e8 f1 fe ff ff       	call   801f73 <_pipeisclosed>
  802082:	85 c0                	test   %eax,%eax
  802084:	75 31                	jne    8020b7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802086:	e8 fb eb ff ff       	call   800c86 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80208b:	8b 03                	mov    (%ebx),%eax
  80208d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802090:	74 df                	je     802071 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802092:	99                   	cltd   
  802093:	c1 ea 1b             	shr    $0x1b,%edx
  802096:	01 d0                	add    %edx,%eax
  802098:	83 e0 1f             	and    $0x1f,%eax
  80209b:	29 d0                	sub    %edx,%eax
  80209d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020a5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020a8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020ab:	83 c6 01             	add    $0x1,%esi
  8020ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020b1:	75 d8                	jne    80208b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020b3:	89 f0                	mov    %esi,%eax
  8020b5:	eb 05                	jmp    8020bc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8020bc:	83 c4 1c             	add    $0x1c,%esp
  8020bf:	5b                   	pop    %ebx
  8020c0:	5e                   	pop    %esi
  8020c1:	5f                   	pop    %edi
  8020c2:	5d                   	pop    %ebp
  8020c3:	c3                   	ret    

008020c4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	56                   	push   %esi
  8020c8:	53                   	push   %ebx
  8020c9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020cf:	89 04 24             	mov    %eax,(%esp)
  8020d2:	e8 10 f0 ff ff       	call   8010e7 <fd_alloc>
  8020d7:	89 c2                	mov    %eax,%edx
  8020d9:	85 d2                	test   %edx,%edx
  8020db:	0f 88 4d 01 00 00    	js     80222e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020e1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020e8:	00 
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f7:	e8 a9 eb ff ff       	call   800ca5 <sys_page_alloc>
  8020fc:	89 c2                	mov    %eax,%edx
  8020fe:	85 d2                	test   %edx,%edx
  802100:	0f 88 28 01 00 00    	js     80222e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802106:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802109:	89 04 24             	mov    %eax,(%esp)
  80210c:	e8 d6 ef ff ff       	call   8010e7 <fd_alloc>
  802111:	89 c3                	mov    %eax,%ebx
  802113:	85 c0                	test   %eax,%eax
  802115:	0f 88 fe 00 00 00    	js     802219 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80211b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802122:	00 
  802123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802126:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802131:	e8 6f eb ff ff       	call   800ca5 <sys_page_alloc>
  802136:	89 c3                	mov    %eax,%ebx
  802138:	85 c0                	test   %eax,%eax
  80213a:	0f 88 d9 00 00 00    	js     802219 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	89 04 24             	mov    %eax,(%esp)
  802146:	e8 85 ef ff ff       	call   8010d0 <fd2data>
  80214b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80214d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802154:	00 
  802155:	89 44 24 04          	mov    %eax,0x4(%esp)
  802159:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802160:	e8 40 eb ff ff       	call   800ca5 <sys_page_alloc>
  802165:	89 c3                	mov    %eax,%ebx
  802167:	85 c0                	test   %eax,%eax
  802169:	0f 88 97 00 00 00    	js     802206 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80216f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802172:	89 04 24             	mov    %eax,(%esp)
  802175:	e8 56 ef ff ff       	call   8010d0 <fd2data>
  80217a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802181:	00 
  802182:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802186:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80218d:	00 
  80218e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802192:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802199:	e8 5b eb ff ff       	call   800cf9 <sys_page_map>
  80219e:	89 c3                	mov    %eax,%ebx
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	78 52                	js     8021f6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021a4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8021b9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	89 04 24             	mov    %eax,(%esp)
  8021d4:	e8 e7 ee ff ff       	call   8010c0 <fd2num>
  8021d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021dc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e1:	89 04 24             	mov    %eax,(%esp)
  8021e4:	e8 d7 ee ff ff       	call   8010c0 <fd2num>
  8021e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021ec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f4:	eb 38                	jmp    80222e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8021f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802201:	e8 46 eb ff ff       	call   800d4c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802206:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802209:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802214:	e8 33 eb ff ff       	call   800d4c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802220:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802227:	e8 20 eb ff ff       	call   800d4c <sys_page_unmap>
  80222c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80222e:	83 c4 30             	add    $0x30,%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    

00802235 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80223b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80223e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	89 04 24             	mov    %eax,(%esp)
  802248:	e8 e9 ee ff ff       	call   801136 <fd_lookup>
  80224d:	89 c2                	mov    %eax,%edx
  80224f:	85 d2                	test   %edx,%edx
  802251:	78 15                	js     802268 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	89 04 24             	mov    %eax,(%esp)
  802259:	e8 72 ee ff ff       	call   8010d0 <fd2data>
	return _pipeisclosed(fd, p);
  80225e:	89 c2                	mov    %eax,%edx
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	e8 0b fd ff ff       	call   801f73 <_pipeisclosed>
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    
  80226a:	66 90                	xchg   %ax,%ax
  80226c:	66 90                	xchg   %ax,%ax
  80226e:	66 90                	xchg   %ax,%ax

00802270 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802273:	b8 00 00 00 00       	mov    $0x0,%eax
  802278:	5d                   	pop    %ebp
  802279:	c3                   	ret    

0080227a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802280:	c7 44 24 04 29 2c 80 	movl   $0x802c29,0x4(%esp)
  802287:	00 
  802288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228b:	89 04 24             	mov    %eax,(%esp)
  80228e:	e8 a4 e5 ff ff       	call   800837 <strcpy>
	return 0;
}
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	57                   	push   %edi
  80229e:	56                   	push   %esi
  80229f:	53                   	push   %ebx
  8022a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022b1:	eb 31                	jmp    8022e4 <devcons_write+0x4a>
		m = n - tot;
  8022b3:	8b 75 10             	mov    0x10(%ebp),%esi
  8022b6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8022b8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022bb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8022c0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022c3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022c7:	03 45 0c             	add    0xc(%ebp),%eax
  8022ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ce:	89 3c 24             	mov    %edi,(%esp)
  8022d1:	e8 fe e6 ff ff       	call   8009d4 <memmove>
		sys_cputs(buf, m);
  8022d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022da:	89 3c 24             	mov    %edi,(%esp)
  8022dd:	e8 a4 e8 ff ff       	call   800b86 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022e2:	01 f3                	add    %esi,%ebx
  8022e4:	89 d8                	mov    %ebx,%eax
  8022e6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8022e9:	72 c8                	jb     8022b3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8022eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    

008022f6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8022fc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802301:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802305:	75 07                	jne    80230e <devcons_read+0x18>
  802307:	eb 2a                	jmp    802333 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802309:	e8 78 e9 ff ff       	call   800c86 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80230e:	66 90                	xchg   %ax,%ax
  802310:	e8 8f e8 ff ff       	call   800ba4 <sys_cgetc>
  802315:	85 c0                	test   %eax,%eax
  802317:	74 f0                	je     802309 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802319:	85 c0                	test   %eax,%eax
  80231b:	78 16                	js     802333 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80231d:	83 f8 04             	cmp    $0x4,%eax
  802320:	74 0c                	je     80232e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802322:	8b 55 0c             	mov    0xc(%ebp),%edx
  802325:	88 02                	mov    %al,(%edx)
	return 1;
  802327:	b8 01 00 00 00       	mov    $0x1,%eax
  80232c:	eb 05                	jmp    802333 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80232e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802341:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802348:	00 
  802349:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80234c:	89 04 24             	mov    %eax,(%esp)
  80234f:	e8 32 e8 ff ff       	call   800b86 <sys_cputs>
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <getchar>:

int
getchar(void)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80235c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802363:	00 
  802364:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802372:	e8 53 f0 ff ff       	call   8013ca <read>
	if (r < 0)
  802377:	85 c0                	test   %eax,%eax
  802379:	78 0f                	js     80238a <getchar+0x34>
		return r;
	if (r < 1)
  80237b:	85 c0                	test   %eax,%eax
  80237d:	7e 06                	jle    802385 <getchar+0x2f>
		return -E_EOF;
	return c;
  80237f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802383:	eb 05                	jmp    80238a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802385:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802392:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802395:	89 44 24 04          	mov    %eax,0x4(%esp)
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	89 04 24             	mov    %eax,(%esp)
  80239f:	e8 92 ed ff ff       	call   801136 <fd_lookup>
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	78 11                	js     8023b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023b1:	39 10                	cmp    %edx,(%eax)
  8023b3:	0f 94 c0             	sete   %al
  8023b6:	0f b6 c0             	movzbl %al,%eax
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <opencons>:

int
opencons(void)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023c4:	89 04 24             	mov    %eax,(%esp)
  8023c7:	e8 1b ed ff ff       	call   8010e7 <fd_alloc>
		return r;
  8023cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	78 40                	js     802412 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023d9:	00 
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e8:	e8 b8 e8 ff ff       	call   800ca5 <sys_page_alloc>
		return r;
  8023ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	78 1f                	js     802412 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8023f3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802408:	89 04 24             	mov    %eax,(%esp)
  80240b:	e8 b0 ec ff ff       	call   8010c0 <fd2num>
  802410:	89 c2                	mov    %eax,%edx
}
  802412:	89 d0                	mov    %edx,%eax
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
  802419:	56                   	push   %esi
  80241a:	53                   	push   %ebx
  80241b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80241e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802421:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802427:	e8 3b e8 ff ff       	call   800c67 <sys_getenvid>
  80242c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802433:	8b 55 08             	mov    0x8(%ebp),%edx
  802436:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80243a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80243e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802442:	c7 04 24 38 2c 80 00 	movl   $0x802c38,(%esp)
  802449:	e8 78 dd ff ff       	call   8001c6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80244e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802452:	8b 45 10             	mov    0x10(%ebp),%eax
  802455:	89 04 24             	mov    %eax,(%esp)
  802458:	e8 08 dd ff ff       	call   800165 <vcprintf>
	cprintf("\n");
  80245d:	c7 04 24 cf 2b 80 00 	movl   $0x802bcf,(%esp)
  802464:	e8 5d dd ff ff       	call   8001c6 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802469:	cc                   	int3   
  80246a:	eb fd                	jmp    802469 <_panic+0x53>

0080246c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802472:	89 d0                	mov    %edx,%eax
  802474:	c1 e8 16             	shr    $0x16,%eax
  802477:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80247e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802483:	f6 c1 01             	test   $0x1,%cl
  802486:	74 1d                	je     8024a5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802488:	c1 ea 0c             	shr    $0xc,%edx
  80248b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802492:	f6 c2 01             	test   $0x1,%dl
  802495:	74 0e                	je     8024a5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802497:	c1 ea 0c             	shr    $0xc,%edx
  80249a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024a1:	ef 
  8024a2:	0f b7 c0             	movzwl %ax,%eax
}
  8024a5:	5d                   	pop    %ebp
  8024a6:	c3                   	ret    
  8024a7:	66 90                	xchg   %ax,%ax
  8024a9:	66 90                	xchg   %ax,%ax
  8024ab:	66 90                	xchg   %ax,%ax
  8024ad:	66 90                	xchg   %ax,%ax
  8024af:	90                   	nop

008024b0 <__udivdi3>:
  8024b0:	55                   	push   %ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	83 ec 0c             	sub    $0xc,%esp
  8024b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8024be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024cc:	89 ea                	mov    %ebp,%edx
  8024ce:	89 0c 24             	mov    %ecx,(%esp)
  8024d1:	75 2d                	jne    802500 <__udivdi3+0x50>
  8024d3:	39 e9                	cmp    %ebp,%ecx
  8024d5:	77 61                	ja     802538 <__udivdi3+0x88>
  8024d7:	85 c9                	test   %ecx,%ecx
  8024d9:	89 ce                	mov    %ecx,%esi
  8024db:	75 0b                	jne    8024e8 <__udivdi3+0x38>
  8024dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e2:	31 d2                	xor    %edx,%edx
  8024e4:	f7 f1                	div    %ecx
  8024e6:	89 c6                	mov    %eax,%esi
  8024e8:	31 d2                	xor    %edx,%edx
  8024ea:	89 e8                	mov    %ebp,%eax
  8024ec:	f7 f6                	div    %esi
  8024ee:	89 c5                	mov    %eax,%ebp
  8024f0:	89 f8                	mov    %edi,%eax
  8024f2:	f7 f6                	div    %esi
  8024f4:	89 ea                	mov    %ebp,%edx
  8024f6:	83 c4 0c             	add    $0xc,%esp
  8024f9:	5e                   	pop    %esi
  8024fa:	5f                   	pop    %edi
  8024fb:	5d                   	pop    %ebp
  8024fc:	c3                   	ret    
  8024fd:	8d 76 00             	lea    0x0(%esi),%esi
  802500:	39 e8                	cmp    %ebp,%eax
  802502:	77 24                	ja     802528 <__udivdi3+0x78>
  802504:	0f bd e8             	bsr    %eax,%ebp
  802507:	83 f5 1f             	xor    $0x1f,%ebp
  80250a:	75 3c                	jne    802548 <__udivdi3+0x98>
  80250c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802510:	39 34 24             	cmp    %esi,(%esp)
  802513:	0f 86 9f 00 00 00    	jbe    8025b8 <__udivdi3+0x108>
  802519:	39 d0                	cmp    %edx,%eax
  80251b:	0f 82 97 00 00 00    	jb     8025b8 <__udivdi3+0x108>
  802521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802528:	31 d2                	xor    %edx,%edx
  80252a:	31 c0                	xor    %eax,%eax
  80252c:	83 c4 0c             	add    $0xc,%esp
  80252f:	5e                   	pop    %esi
  802530:	5f                   	pop    %edi
  802531:	5d                   	pop    %ebp
  802532:	c3                   	ret    
  802533:	90                   	nop
  802534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802538:	89 f8                	mov    %edi,%eax
  80253a:	f7 f1                	div    %ecx
  80253c:	31 d2                	xor    %edx,%edx
  80253e:	83 c4 0c             	add    $0xc,%esp
  802541:	5e                   	pop    %esi
  802542:	5f                   	pop    %edi
  802543:	5d                   	pop    %ebp
  802544:	c3                   	ret    
  802545:	8d 76 00             	lea    0x0(%esi),%esi
  802548:	89 e9                	mov    %ebp,%ecx
  80254a:	8b 3c 24             	mov    (%esp),%edi
  80254d:	d3 e0                	shl    %cl,%eax
  80254f:	89 c6                	mov    %eax,%esi
  802551:	b8 20 00 00 00       	mov    $0x20,%eax
  802556:	29 e8                	sub    %ebp,%eax
  802558:	89 c1                	mov    %eax,%ecx
  80255a:	d3 ef                	shr    %cl,%edi
  80255c:	89 e9                	mov    %ebp,%ecx
  80255e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802562:	8b 3c 24             	mov    (%esp),%edi
  802565:	09 74 24 08          	or     %esi,0x8(%esp)
  802569:	89 d6                	mov    %edx,%esi
  80256b:	d3 e7                	shl    %cl,%edi
  80256d:	89 c1                	mov    %eax,%ecx
  80256f:	89 3c 24             	mov    %edi,(%esp)
  802572:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802576:	d3 ee                	shr    %cl,%esi
  802578:	89 e9                	mov    %ebp,%ecx
  80257a:	d3 e2                	shl    %cl,%edx
  80257c:	89 c1                	mov    %eax,%ecx
  80257e:	d3 ef                	shr    %cl,%edi
  802580:	09 d7                	or     %edx,%edi
  802582:	89 f2                	mov    %esi,%edx
  802584:	89 f8                	mov    %edi,%eax
  802586:	f7 74 24 08          	divl   0x8(%esp)
  80258a:	89 d6                	mov    %edx,%esi
  80258c:	89 c7                	mov    %eax,%edi
  80258e:	f7 24 24             	mull   (%esp)
  802591:	39 d6                	cmp    %edx,%esi
  802593:	89 14 24             	mov    %edx,(%esp)
  802596:	72 30                	jb     8025c8 <__udivdi3+0x118>
  802598:	8b 54 24 04          	mov    0x4(%esp),%edx
  80259c:	89 e9                	mov    %ebp,%ecx
  80259e:	d3 e2                	shl    %cl,%edx
  8025a0:	39 c2                	cmp    %eax,%edx
  8025a2:	73 05                	jae    8025a9 <__udivdi3+0xf9>
  8025a4:	3b 34 24             	cmp    (%esp),%esi
  8025a7:	74 1f                	je     8025c8 <__udivdi3+0x118>
  8025a9:	89 f8                	mov    %edi,%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	e9 7a ff ff ff       	jmp    80252c <__udivdi3+0x7c>
  8025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025b8:	31 d2                	xor    %edx,%edx
  8025ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bf:	e9 68 ff ff ff       	jmp    80252c <__udivdi3+0x7c>
  8025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	83 c4 0c             	add    $0xc,%esp
  8025d0:	5e                   	pop    %esi
  8025d1:	5f                   	pop    %edi
  8025d2:	5d                   	pop    %ebp
  8025d3:	c3                   	ret    
  8025d4:	66 90                	xchg   %ax,%ax
  8025d6:	66 90                	xchg   %ax,%ax
  8025d8:	66 90                	xchg   %ax,%ax
  8025da:	66 90                	xchg   %ax,%ax
  8025dc:	66 90                	xchg   %ax,%ax
  8025de:	66 90                	xchg   %ax,%ax

008025e0 <__umoddi3>:
  8025e0:	55                   	push   %ebp
  8025e1:	57                   	push   %edi
  8025e2:	56                   	push   %esi
  8025e3:	83 ec 14             	sub    $0x14,%esp
  8025e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8025f2:	89 c7                	mov    %eax,%edi
  8025f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8025fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802600:	89 34 24             	mov    %esi,(%esp)
  802603:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802607:	85 c0                	test   %eax,%eax
  802609:	89 c2                	mov    %eax,%edx
  80260b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80260f:	75 17                	jne    802628 <__umoddi3+0x48>
  802611:	39 fe                	cmp    %edi,%esi
  802613:	76 4b                	jbe    802660 <__umoddi3+0x80>
  802615:	89 c8                	mov    %ecx,%eax
  802617:	89 fa                	mov    %edi,%edx
  802619:	f7 f6                	div    %esi
  80261b:	89 d0                	mov    %edx,%eax
  80261d:	31 d2                	xor    %edx,%edx
  80261f:	83 c4 14             	add    $0x14,%esp
  802622:	5e                   	pop    %esi
  802623:	5f                   	pop    %edi
  802624:	5d                   	pop    %ebp
  802625:	c3                   	ret    
  802626:	66 90                	xchg   %ax,%ax
  802628:	39 f8                	cmp    %edi,%eax
  80262a:	77 54                	ja     802680 <__umoddi3+0xa0>
  80262c:	0f bd e8             	bsr    %eax,%ebp
  80262f:	83 f5 1f             	xor    $0x1f,%ebp
  802632:	75 5c                	jne    802690 <__umoddi3+0xb0>
  802634:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802638:	39 3c 24             	cmp    %edi,(%esp)
  80263b:	0f 87 e7 00 00 00    	ja     802728 <__umoddi3+0x148>
  802641:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802645:	29 f1                	sub    %esi,%ecx
  802647:	19 c7                	sbb    %eax,%edi
  802649:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80264d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802651:	8b 44 24 08          	mov    0x8(%esp),%eax
  802655:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802659:	83 c4 14             	add    $0x14,%esp
  80265c:	5e                   	pop    %esi
  80265d:	5f                   	pop    %edi
  80265e:	5d                   	pop    %ebp
  80265f:	c3                   	ret    
  802660:	85 f6                	test   %esi,%esi
  802662:	89 f5                	mov    %esi,%ebp
  802664:	75 0b                	jne    802671 <__umoddi3+0x91>
  802666:	b8 01 00 00 00       	mov    $0x1,%eax
  80266b:	31 d2                	xor    %edx,%edx
  80266d:	f7 f6                	div    %esi
  80266f:	89 c5                	mov    %eax,%ebp
  802671:	8b 44 24 04          	mov    0x4(%esp),%eax
  802675:	31 d2                	xor    %edx,%edx
  802677:	f7 f5                	div    %ebp
  802679:	89 c8                	mov    %ecx,%eax
  80267b:	f7 f5                	div    %ebp
  80267d:	eb 9c                	jmp    80261b <__umoddi3+0x3b>
  80267f:	90                   	nop
  802680:	89 c8                	mov    %ecx,%eax
  802682:	89 fa                	mov    %edi,%edx
  802684:	83 c4 14             	add    $0x14,%esp
  802687:	5e                   	pop    %esi
  802688:	5f                   	pop    %edi
  802689:	5d                   	pop    %ebp
  80268a:	c3                   	ret    
  80268b:	90                   	nop
  80268c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802690:	8b 04 24             	mov    (%esp),%eax
  802693:	be 20 00 00 00       	mov    $0x20,%esi
  802698:	89 e9                	mov    %ebp,%ecx
  80269a:	29 ee                	sub    %ebp,%esi
  80269c:	d3 e2                	shl    %cl,%edx
  80269e:	89 f1                	mov    %esi,%ecx
  8026a0:	d3 e8                	shr    %cl,%eax
  8026a2:	89 e9                	mov    %ebp,%ecx
  8026a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a8:	8b 04 24             	mov    (%esp),%eax
  8026ab:	09 54 24 04          	or     %edx,0x4(%esp)
  8026af:	89 fa                	mov    %edi,%edx
  8026b1:	d3 e0                	shl    %cl,%eax
  8026b3:	89 f1                	mov    %esi,%ecx
  8026b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026b9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8026bd:	d3 ea                	shr    %cl,%edx
  8026bf:	89 e9                	mov    %ebp,%ecx
  8026c1:	d3 e7                	shl    %cl,%edi
  8026c3:	89 f1                	mov    %esi,%ecx
  8026c5:	d3 e8                	shr    %cl,%eax
  8026c7:	89 e9                	mov    %ebp,%ecx
  8026c9:	09 f8                	or     %edi,%eax
  8026cb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026cf:	f7 74 24 04          	divl   0x4(%esp)
  8026d3:	d3 e7                	shl    %cl,%edi
  8026d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026d9:	89 d7                	mov    %edx,%edi
  8026db:	f7 64 24 08          	mull   0x8(%esp)
  8026df:	39 d7                	cmp    %edx,%edi
  8026e1:	89 c1                	mov    %eax,%ecx
  8026e3:	89 14 24             	mov    %edx,(%esp)
  8026e6:	72 2c                	jb     802714 <__umoddi3+0x134>
  8026e8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8026ec:	72 22                	jb     802710 <__umoddi3+0x130>
  8026ee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8026f2:	29 c8                	sub    %ecx,%eax
  8026f4:	19 d7                	sbb    %edx,%edi
  8026f6:	89 e9                	mov    %ebp,%ecx
  8026f8:	89 fa                	mov    %edi,%edx
  8026fa:	d3 e8                	shr    %cl,%eax
  8026fc:	89 f1                	mov    %esi,%ecx
  8026fe:	d3 e2                	shl    %cl,%edx
  802700:	89 e9                	mov    %ebp,%ecx
  802702:	d3 ef                	shr    %cl,%edi
  802704:	09 d0                	or     %edx,%eax
  802706:	89 fa                	mov    %edi,%edx
  802708:	83 c4 14             	add    $0x14,%esp
  80270b:	5e                   	pop    %esi
  80270c:	5f                   	pop    %edi
  80270d:	5d                   	pop    %ebp
  80270e:	c3                   	ret    
  80270f:	90                   	nop
  802710:	39 d7                	cmp    %edx,%edi
  802712:	75 da                	jne    8026ee <__umoddi3+0x10e>
  802714:	8b 14 24             	mov    (%esp),%edx
  802717:	89 c1                	mov    %eax,%ecx
  802719:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80271d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802721:	eb cb                	jmp    8026ee <__umoddi3+0x10e>
  802723:	90                   	nop
  802724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802728:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80272c:	0f 82 0f ff ff ff    	jb     802641 <__umoddi3+0x61>
  802732:	e9 1a ff ff ff       	jmp    802651 <__umoddi3+0x71>
