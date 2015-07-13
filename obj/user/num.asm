
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 95 01 00 00       	call   8001c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 30             	sub    $0x30,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	e9 84 00 00 00       	jmp    8000ca <num+0x97>
		if (bol) {
  800046:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  80004d:	74 27                	je     800076 <num+0x43>
			printf("%5d ", ++line);
  80004f:	a1 00 40 80 00       	mov    0x804000,%eax
  800054:	83 c0 01             	add    $0x1,%eax
  800057:	a3 00 40 80 00       	mov    %eax,0x804000
  80005c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800060:	c7 04 24 80 29 80 00 	movl   $0x802980,(%esp)
  800067:	e8 cb 1a 00 00       	call   801b37 <printf>
			bol = 0;
  80006c:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800073:	00 00 00 
		}
		if ((r = write(1, &c, 1)) != 1)
  800076:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80007d:	00 
  80007e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800082:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800089:	e8 69 14 00 00       	call   8014f7 <write>
  80008e:	83 f8 01             	cmp    $0x1,%eax
  800091:	74 27                	je     8000ba <num+0x87>
			panic("write error copying %s: %e", s, r);
  800093:	89 44 24 10          	mov    %eax,0x10(%esp)
  800097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80009a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80009e:	c7 44 24 08 85 29 80 	movl   $0x802985,0x8(%esp)
  8000a5:	00 
  8000a6:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000ad:	00 
  8000ae:	c7 04 24 a0 29 80 00 	movl   $0x8029a0,(%esp)
  8000b5:	e8 6d 01 00 00       	call   800227 <_panic>
		if (c == '\n')
  8000ba:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  8000be:	75 0a                	jne    8000ca <num+0x97>
			bol = 1;
  8000c0:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c7:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000ca:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d1:	00 
  8000d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d6:	89 34 24             	mov    %esi,(%esp)
  8000d9:	e8 3c 13 00 00       	call   80141a <read>
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 8f 60 ff ff ff    	jg     800046 <num+0x13>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	79 27                	jns    800111 <num+0xde>
		panic("error reading %s: %e", s, n);
  8000ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f5:	c7 44 24 08 ab 29 80 	movl   $0x8029ab,0x8(%esp)
  8000fc:	00 
  8000fd:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  800104:	00 
  800105:	c7 04 24 a0 29 80 00 	movl   $0x8029a0,(%esp)
  80010c:	e8 16 01 00 00       	call   800227 <_panic>
}
  800111:	83 c4 30             	add    $0x30,%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5d                   	pop    %ebp
  800117:	c3                   	ret    

00800118 <umain>:

void
umain(int argc, char **argv)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	83 ec 2c             	sub    $0x2c,%esp
	int f, i;

	binaryname = "num";
  800121:	c7 05 04 30 80 00 c0 	movl   $0x8029c0,0x803004
  800128:	29 80 00 
	if (argc == 1)
  80012b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80012f:	74 0d                	je     80013e <umain+0x26>
  800131:	8b 45 0c             	mov    0xc(%ebp),%eax
  800134:	8d 58 04             	lea    0x4(%eax),%ebx
  800137:	bf 01 00 00 00       	mov    $0x1,%edi
  80013c:	eb 76                	jmp    8001b4 <umain+0x9c>
		num(0, "<stdin>");
  80013e:	c7 44 24 04 c4 29 80 	movl   $0x8029c4,0x4(%esp)
  800145:	00 
  800146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014d:	e8 e1 fe ff ff       	call   800033 <num>
  800152:	eb 65                	jmp    8001b9 <umain+0xa1>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800154:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800157:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80015e:	00 
  80015f:	8b 03                	mov    (%ebx),%eax
  800161:	89 04 24             	mov    %eax,(%esp)
  800164:	e8 fb 17 00 00       	call   801964 <open>
  800169:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80016b:	85 c0                	test   %eax,%eax
  80016d:	79 29                	jns    800198 <umain+0x80>
				panic("can't open %s: %e", argv[i], f);
  80016f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800176:	8b 00                	mov    (%eax),%eax
  800178:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80017c:	c7 44 24 08 cc 29 80 	movl   $0x8029cc,0x8(%esp)
  800183:	00 
  800184:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80018b:	00 
  80018c:	c7 04 24 a0 29 80 00 	movl   $0x8029a0,(%esp)
  800193:	e8 8f 00 00 00       	call   800227 <_panic>
			else {
				num(f, argv[i]);
  800198:	8b 03                	mov    (%ebx),%eax
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	89 34 24             	mov    %esi,(%esp)
  8001a1:	e8 8d fe ff ff       	call   800033 <num>
				close(f);
  8001a6:	89 34 24             	mov    %esi,(%esp)
  8001a9:	e8 09 11 00 00       	call   8012b7 <close>

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8001ae:	83 c7 01             	add    $0x1,%edi
  8001b1:	83 c3 04             	add    $0x4,%ebx
  8001b4:	3b 7d 08             	cmp    0x8(%ebp),%edi
  8001b7:	7c 9b                	jl     800154 <umain+0x3c>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8001b9:	e8 50 00 00 00       	call   80020e <exit>
}
  8001be:	83 c4 2c             	add    $0x2c,%esp
  8001c1:	5b                   	pop    %ebx
  8001c2:	5e                   	pop    %esi
  8001c3:	5f                   	pop    %edi
  8001c4:	5d                   	pop    %ebp
  8001c5:	c3                   	ret    

008001c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 10             	sub    $0x10,%esp
  8001ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8001d4:	e8 ee 0b 00 00       	call   800dc7 <sys_getenvid>
  8001d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001de:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e6:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001eb:	85 db                	test   %ebx,%ebx
  8001ed:	7e 07                	jle    8001f6 <libmain+0x30>
		binaryname = argv[0];
  8001ef:	8b 06                	mov    (%esi),%eax
  8001f1:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001fa:	89 1c 24             	mov    %ebx,(%esp)
  8001fd:	e8 16 ff ff ff       	call   800118 <umain>

	// exit gracefully
	exit();
  800202:	e8 07 00 00 00       	call   80020e <exit>
}
  800207:	83 c4 10             	add    $0x10,%esp
  80020a:	5b                   	pop    %ebx
  80020b:	5e                   	pop    %esi
  80020c:	5d                   	pop    %ebp
  80020d:	c3                   	ret    

0080020e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80020e:	55                   	push   %ebp
  80020f:	89 e5                	mov    %esp,%ebp
  800211:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800214:	e8 d1 10 00 00       	call   8012ea <close_all>
	sys_env_destroy(0);
  800219:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800220:	e8 fe 0a 00 00       	call   800d23 <sys_env_destroy>
}
  800225:	c9                   	leave  
  800226:	c3                   	ret    

00800227 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	56                   	push   %esi
  80022b:	53                   	push   %ebx
  80022c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80022f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800232:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800238:	e8 8a 0b 00 00       	call   800dc7 <sys_getenvid>
  80023d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800240:	89 54 24 10          	mov    %edx,0x10(%esp)
  800244:	8b 55 08             	mov    0x8(%ebp),%edx
  800247:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80024b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80024f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800253:	c7 04 24 e8 29 80 00 	movl   $0x8029e8,(%esp)
  80025a:	e8 c1 00 00 00       	call   800320 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800263:	8b 45 10             	mov    0x10(%ebp),%eax
  800266:	89 04 24             	mov    %eax,(%esp)
  800269:	e8 51 00 00 00       	call   8002bf <vcprintf>
	cprintf("\n");
  80026e:	c7 04 24 23 2e 80 00 	movl   $0x802e23,(%esp)
  800275:	e8 a6 00 00 00       	call   800320 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80027a:	cc                   	int3   
  80027b:	eb fd                	jmp    80027a <_panic+0x53>

0080027d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	53                   	push   %ebx
  800281:	83 ec 14             	sub    $0x14,%esp
  800284:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800287:	8b 13                	mov    (%ebx),%edx
  800289:	8d 42 01             	lea    0x1(%edx),%eax
  80028c:	89 03                	mov    %eax,(%ebx)
  80028e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800291:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800295:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029a:	75 19                	jne    8002b5 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80029c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002a3:	00 
  8002a4:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a7:	89 04 24             	mov    %eax,(%esp)
  8002aa:	e8 37 0a 00 00       	call   800ce6 <sys_cputs>
		b->idx = 0;
  8002af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b9:	83 c4 14             	add    $0x14,%esp
  8002bc:	5b                   	pop    %ebx
  8002bd:	5d                   	pop    %ebp
  8002be:	c3                   	ret    

008002bf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cf:	00 00 00 
	b.cnt = 0;
  8002d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f4:	c7 04 24 7d 02 80 00 	movl   $0x80027d,(%esp)
  8002fb:	e8 74 01 00 00       	call   800474 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800300:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800306:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800310:	89 04 24             	mov    %eax,(%esp)
  800313:	e8 ce 09 00 00       	call   800ce6 <sys_cputs>

	return b.cnt;
}
  800318:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800326:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800329:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032d:	8b 45 08             	mov    0x8(%ebp),%eax
  800330:	89 04 24             	mov    %eax,(%esp)
  800333:	e8 87 ff ff ff       	call   8002bf <vcprintf>
	va_end(ap);

	return cnt;
}
  800338:	c9                   	leave  
  800339:	c3                   	ret    
  80033a:	66 90                	xchg   %ax,%ax
  80033c:	66 90                	xchg   %ax,%ax
  80033e:	66 90                	xchg   %ax,%ax

00800340 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	57                   	push   %edi
  800344:	56                   	push   %esi
  800345:	53                   	push   %ebx
  800346:	83 ec 3c             	sub    $0x3c,%esp
  800349:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034c:	89 d7                	mov    %edx,%edi
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800354:	8b 45 0c             	mov    0xc(%ebp),%eax
  800357:	89 c3                	mov    %eax,%ebx
  800359:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800362:	b9 00 00 00 00       	mov    $0x0,%ecx
  800367:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80036d:	39 d9                	cmp    %ebx,%ecx
  80036f:	72 05                	jb     800376 <printnum+0x36>
  800371:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800374:	77 69                	ja     8003df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800376:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800379:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80037d:	83 ee 01             	sub    $0x1,%esi
  800380:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800384:	89 44 24 08          	mov    %eax,0x8(%esp)
  800388:	8b 44 24 08          	mov    0x8(%esp),%eax
  80038c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800390:	89 c3                	mov    %eax,%ebx
  800392:	89 d6                	mov    %edx,%esi
  800394:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800397:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80039a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80039e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	89 04 24             	mov    %eax,(%esp)
  8003a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003af:	e8 3c 23 00 00       	call   8026f0 <__udivdi3>
  8003b4:	89 d9                	mov    %ebx,%ecx
  8003b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003be:	89 04 24             	mov    %eax,(%esp)
  8003c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003c5:	89 fa                	mov    %edi,%edx
  8003c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ca:	e8 71 ff ff ff       	call   800340 <printnum>
  8003cf:	eb 1b                	jmp    8003ec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	89 04 24             	mov    %eax,(%esp)
  8003db:	ff d3                	call   *%ebx
  8003dd:	eb 03                	jmp    8003e2 <printnum+0xa2>
  8003df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e2:	83 ee 01             	sub    $0x1,%esi
  8003e5:	85 f6                	test   %esi,%esi
  8003e7:	7f e8                	jg     8003d1 <printnum+0x91>
  8003e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003f0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	89 04 24             	mov    %eax,(%esp)
  800408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80040b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040f:	e8 0c 24 00 00       	call   802820 <__umoddi3>
  800414:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800418:	0f be 80 0b 2a 80 00 	movsbl 0x802a0b(%eax),%eax
  80041f:	89 04 24             	mov    %eax,(%esp)
  800422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800425:	ff d0                	call   *%eax
}
  800427:	83 c4 3c             	add    $0x3c,%esp
  80042a:	5b                   	pop    %ebx
  80042b:	5e                   	pop    %esi
  80042c:	5f                   	pop    %edi
  80042d:	5d                   	pop    %ebp
  80042e:	c3                   	ret    

0080042f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800435:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800439:	8b 10                	mov    (%eax),%edx
  80043b:	3b 50 04             	cmp    0x4(%eax),%edx
  80043e:	73 0a                	jae    80044a <sprintputch+0x1b>
		*b->buf++ = ch;
  800440:	8d 4a 01             	lea    0x1(%edx),%ecx
  800443:	89 08                	mov    %ecx,(%eax)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	88 02                	mov    %al,(%edx)
}
  80044a:	5d                   	pop    %ebp
  80044b:	c3                   	ret    

0080044c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800452:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800455:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800459:	8b 45 10             	mov    0x10(%ebp),%eax
  80045c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800460:	8b 45 0c             	mov    0xc(%ebp),%eax
  800463:	89 44 24 04          	mov    %eax,0x4(%esp)
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	89 04 24             	mov    %eax,(%esp)
  80046d:	e8 02 00 00 00       	call   800474 <vprintfmt>
	va_end(ap);
}
  800472:	c9                   	leave  
  800473:	c3                   	ret    

00800474 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800474:	55                   	push   %ebp
  800475:	89 e5                	mov    %esp,%ebp
  800477:	57                   	push   %edi
  800478:	56                   	push   %esi
  800479:	53                   	push   %ebx
  80047a:	83 ec 3c             	sub    $0x3c,%esp
  80047d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800480:	eb 17                	jmp    800499 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800482:	85 c0                	test   %eax,%eax
  800484:	0f 84 4b 04 00 00    	je     8008d5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80048a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80048d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800491:	89 04 24             	mov    %eax,(%esp)
  800494:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800497:	89 fb                	mov    %edi,%ebx
  800499:	8d 7b 01             	lea    0x1(%ebx),%edi
  80049c:	0f b6 03             	movzbl (%ebx),%eax
  80049f:	83 f8 25             	cmp    $0x25,%eax
  8004a2:	75 de                	jne    800482 <vprintfmt+0xe>
  8004a4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8004a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8004af:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8004b4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004bb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004c0:	eb 18                	jmp    8004da <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004c4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8004c8:	eb 10                	jmp    8004da <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004cc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8004d0:	eb 08                	jmp    8004da <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8004d5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004da:	8d 5f 01             	lea    0x1(%edi),%ebx
  8004dd:	0f b6 17             	movzbl (%edi),%edx
  8004e0:	0f b6 c2             	movzbl %dl,%eax
  8004e3:	83 ea 23             	sub    $0x23,%edx
  8004e6:	80 fa 55             	cmp    $0x55,%dl
  8004e9:	0f 87 c2 03 00 00    	ja     8008b1 <vprintfmt+0x43d>
  8004ef:	0f b6 d2             	movzbl %dl,%edx
  8004f2:	ff 24 95 40 2b 80 00 	jmp    *0x802b40(,%edx,4)
  8004f9:	89 df                	mov    %ebx,%edi
  8004fb:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800500:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800503:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800507:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80050a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80050d:	83 fa 09             	cmp    $0x9,%edx
  800510:	77 33                	ja     800545 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800512:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800515:	eb e9                	jmp    800500 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8b 30                	mov    (%eax),%esi
  80051c:	8d 40 04             	lea    0x4(%eax),%eax
  80051f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800522:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800524:	eb 1f                	jmp    800545 <vprintfmt+0xd1>
  800526:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800529:	85 ff                	test   %edi,%edi
  80052b:	b8 00 00 00 00       	mov    $0x0,%eax
  800530:	0f 49 c7             	cmovns %edi,%eax
  800533:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800536:	89 df                	mov    %ebx,%edi
  800538:	eb a0                	jmp    8004da <vprintfmt+0x66>
  80053a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80053c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800543:	eb 95                	jmp    8004da <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800545:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800549:	79 8f                	jns    8004da <vprintfmt+0x66>
  80054b:	eb 85                	jmp    8004d2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80054d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800550:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800552:	eb 86                	jmp    8004da <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8d 70 04             	lea    0x4(%eax),%esi
  80055a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	89 04 24             	mov    %eax,(%esp)
  800569:	ff 55 08             	call   *0x8(%ebp)
  80056c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80056f:	e9 25 ff ff ff       	jmp    800499 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 70 04             	lea    0x4(%eax),%esi
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	99                   	cltd   
  80057d:	31 d0                	xor    %edx,%eax
  80057f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800581:	83 f8 15             	cmp    $0x15,%eax
  800584:	7f 0b                	jg     800591 <vprintfmt+0x11d>
  800586:	8b 14 85 a0 2c 80 00 	mov    0x802ca0(,%eax,4),%edx
  80058d:	85 d2                	test   %edx,%edx
  80058f:	75 26                	jne    8005b7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800591:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800595:	c7 44 24 08 23 2a 80 	movl   $0x802a23,0x8(%esp)
  80059c:	00 
  80059d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	89 04 24             	mov    %eax,(%esp)
  8005aa:	e8 9d fe ff ff       	call   80044c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005af:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8005b2:	e9 e2 fe ff ff       	jmp    800499 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005bb:	c7 44 24 08 f2 2d 80 	movl   $0x802df2,0x8(%esp)
  8005c2:	00 
  8005c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	89 04 24             	mov    %eax,(%esp)
  8005d0:	e8 77 fe ff ff       	call   80044c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005d5:	89 75 14             	mov    %esi,0x14(%ebp)
  8005d8:	e9 bc fe ff ff       	jmp    800499 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005e6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8005ea:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005ec:	85 ff                	test   %edi,%edi
  8005ee:	b8 1c 2a 80 00       	mov    $0x802a1c,%eax
  8005f3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8005f6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8005fa:	0f 84 94 00 00 00    	je     800694 <vprintfmt+0x220>
  800600:	85 c9                	test   %ecx,%ecx
  800602:	0f 8e 94 00 00 00    	jle    80069c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800608:	89 74 24 04          	mov    %esi,0x4(%esp)
  80060c:	89 3c 24             	mov    %edi,(%esp)
  80060f:	e8 64 03 00 00       	call   800978 <strnlen>
  800614:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800617:	29 c1                	sub    %eax,%ecx
  800619:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80061c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800620:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800623:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800626:	8b 75 08             	mov    0x8(%ebp),%esi
  800629:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80062c:	89 cb                	mov    %ecx,%ebx
  80062e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800630:	eb 0f                	jmp    800641 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800632:	8b 45 0c             	mov    0xc(%ebp),%eax
  800635:	89 44 24 04          	mov    %eax,0x4(%esp)
  800639:	89 3c 24             	mov    %edi,(%esp)
  80063c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80063e:	83 eb 01             	sub    $0x1,%ebx
  800641:	85 db                	test   %ebx,%ebx
  800643:	7f ed                	jg     800632 <vprintfmt+0x1be>
  800645:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800648:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80064b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80064e:	85 c9                	test   %ecx,%ecx
  800650:	b8 00 00 00 00       	mov    $0x0,%eax
  800655:	0f 49 c1             	cmovns %ecx,%eax
  800658:	29 c1                	sub    %eax,%ecx
  80065a:	89 cb                	mov    %ecx,%ebx
  80065c:	eb 44                	jmp    8006a2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80065e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800662:	74 1e                	je     800682 <vprintfmt+0x20e>
  800664:	0f be d2             	movsbl %dl,%edx
  800667:	83 ea 20             	sub    $0x20,%edx
  80066a:	83 fa 5e             	cmp    $0x5e,%edx
  80066d:	76 13                	jbe    800682 <vprintfmt+0x20e>
					putch('?', putdat);
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	89 44 24 04          	mov    %eax,0x4(%esp)
  800676:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80067d:	ff 55 08             	call   *0x8(%ebp)
  800680:	eb 0d                	jmp    80068f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800682:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800685:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800689:	89 04 24             	mov    %eax,(%esp)
  80068c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068f:	83 eb 01             	sub    $0x1,%ebx
  800692:	eb 0e                	jmp    8006a2 <vprintfmt+0x22e>
  800694:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800697:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80069a:	eb 06                	jmp    8006a2 <vprintfmt+0x22e>
  80069c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80069f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006a2:	83 c7 01             	add    $0x1,%edi
  8006a5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006a9:	0f be c2             	movsbl %dl,%eax
  8006ac:	85 c0                	test   %eax,%eax
  8006ae:	74 27                	je     8006d7 <vprintfmt+0x263>
  8006b0:	85 f6                	test   %esi,%esi
  8006b2:	78 aa                	js     80065e <vprintfmt+0x1ea>
  8006b4:	83 ee 01             	sub    $0x1,%esi
  8006b7:	79 a5                	jns    80065e <vprintfmt+0x1ea>
  8006b9:	89 d8                	mov    %ebx,%eax
  8006bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006be:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006c1:	89 c3                	mov    %eax,%ebx
  8006c3:	eb 18                	jmp    8006dd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006d0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d2:	83 eb 01             	sub    $0x1,%ebx
  8006d5:	eb 06                	jmp    8006dd <vprintfmt+0x269>
  8006d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8006da:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006dd:	85 db                	test   %ebx,%ebx
  8006df:	7f e4                	jg     8006c5 <vprintfmt+0x251>
  8006e1:	89 75 08             	mov    %esi,0x8(%ebp)
  8006e4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006ea:	e9 aa fd ff ff       	jmp    800499 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006ef:	83 f9 01             	cmp    $0x1,%ecx
  8006f2:	7e 10                	jle    800704 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 30                	mov    (%eax),%esi
  8006f9:	8b 78 04             	mov    0x4(%eax),%edi
  8006fc:	8d 40 08             	lea    0x8(%eax),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800702:	eb 26                	jmp    80072a <vprintfmt+0x2b6>
	else if (lflag)
  800704:	85 c9                	test   %ecx,%ecx
  800706:	74 12                	je     80071a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 30                	mov    (%eax),%esi
  80070d:	89 f7                	mov    %esi,%edi
  80070f:	c1 ff 1f             	sar    $0x1f,%edi
  800712:	8d 40 04             	lea    0x4(%eax),%eax
  800715:	89 45 14             	mov    %eax,0x14(%ebp)
  800718:	eb 10                	jmp    80072a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8b 30                	mov    (%eax),%esi
  80071f:	89 f7                	mov    %esi,%edi
  800721:	c1 ff 1f             	sar    $0x1f,%edi
  800724:	8d 40 04             	lea    0x4(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80072a:	89 f0                	mov    %esi,%eax
  80072c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80072e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800733:	85 ff                	test   %edi,%edi
  800735:	0f 89 3a 01 00 00    	jns    800875 <vprintfmt+0x401>
				putch('-', putdat);
  80073b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800742:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800749:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80074c:	89 f0                	mov    %esi,%eax
  80074e:	89 fa                	mov    %edi,%edx
  800750:	f7 d8                	neg    %eax
  800752:	83 d2 00             	adc    $0x0,%edx
  800755:	f7 da                	neg    %edx
			}
			base = 10;
  800757:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80075c:	e9 14 01 00 00       	jmp    800875 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800761:	83 f9 01             	cmp    $0x1,%ecx
  800764:	7e 13                	jle    800779 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 50 04             	mov    0x4(%eax),%edx
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	8b 75 14             	mov    0x14(%ebp),%esi
  800771:	8d 4e 08             	lea    0x8(%esi),%ecx
  800774:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800777:	eb 2c                	jmp    8007a5 <vprintfmt+0x331>
	else if (lflag)
  800779:	85 c9                	test   %ecx,%ecx
  80077b:	74 15                	je     800792 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	ba 00 00 00 00       	mov    $0x0,%edx
  800787:	8b 75 14             	mov    0x14(%ebp),%esi
  80078a:	8d 76 04             	lea    0x4(%esi),%esi
  80078d:	89 75 14             	mov    %esi,0x14(%ebp)
  800790:	eb 13                	jmp    8007a5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	ba 00 00 00 00       	mov    $0x0,%edx
  80079c:	8b 75 14             	mov    0x14(%ebp),%esi
  80079f:	8d 76 04             	lea    0x4(%esi),%esi
  8007a2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8007a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007aa:	e9 c6 00 00 00       	jmp    800875 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007af:	83 f9 01             	cmp    $0x1,%ecx
  8007b2:	7e 13                	jle    8007c7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8b 50 04             	mov    0x4(%eax),%edx
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	8b 75 14             	mov    0x14(%ebp),%esi
  8007bf:	8d 4e 08             	lea    0x8(%esi),%ecx
  8007c2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007c5:	eb 24                	jmp    8007eb <vprintfmt+0x377>
	else if (lflag)
  8007c7:	85 c9                	test   %ecx,%ecx
  8007c9:	74 11                	je     8007dc <vprintfmt+0x368>
		return va_arg(*ap, long);
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	99                   	cltd   
  8007d1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007d4:	8d 71 04             	lea    0x4(%ecx),%esi
  8007d7:	89 75 14             	mov    %esi,0x14(%ebp)
  8007da:	eb 0f                	jmp    8007eb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	99                   	cltd   
  8007e2:	8b 75 14             	mov    0x14(%ebp),%esi
  8007e5:	8d 76 04             	lea    0x4(%esi),%esi
  8007e8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  8007eb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007f0:	e9 80 00 00 00       	jmp    800875 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  8007f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ff:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800806:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800809:	8b 45 0c             	mov    0xc(%ebp),%eax
  80080c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800810:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800817:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80081a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80081e:	8b 06                	mov    (%esi),%eax
  800820:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800825:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80082a:	eb 49                	jmp    800875 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80082c:	83 f9 01             	cmp    $0x1,%ecx
  80082f:	7e 13                	jle    800844 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8b 50 04             	mov    0x4(%eax),%edx
  800837:	8b 00                	mov    (%eax),%eax
  800839:	8b 75 14             	mov    0x14(%ebp),%esi
  80083c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80083f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800842:	eb 2c                	jmp    800870 <vprintfmt+0x3fc>
	else if (lflag)
  800844:	85 c9                	test   %ecx,%ecx
  800846:	74 15                	je     80085d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	8b 00                	mov    (%eax),%eax
  80084d:	ba 00 00 00 00       	mov    $0x0,%edx
  800852:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800855:	8d 71 04             	lea    0x4(%ecx),%esi
  800858:	89 75 14             	mov    %esi,0x14(%ebp)
  80085b:	eb 13                	jmp    800870 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	ba 00 00 00 00       	mov    $0x0,%edx
  800867:	8b 75 14             	mov    0x14(%ebp),%esi
  80086a:	8d 76 04             	lea    0x4(%esi),%esi
  80086d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800870:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800875:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800879:	89 74 24 10          	mov    %esi,0x10(%esp)
  80087d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800880:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800884:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800888:	89 04 24             	mov    %eax,(%esp)
  80088b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80088f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	e8 a6 fa ff ff       	call   800340 <printnum>
			break;
  80089a:	e9 fa fb ff ff       	jmp    800499 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80089f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008a6:	89 04 24             	mov    %eax,(%esp)
  8008a9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008ac:	e9 e8 fb ff ff       	jmp    800499 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008bf:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c2:	89 fb                	mov    %edi,%ebx
  8008c4:	eb 03                	jmp    8008c9 <vprintfmt+0x455>
  8008c6:	83 eb 01             	sub    $0x1,%ebx
  8008c9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008cd:	75 f7                	jne    8008c6 <vprintfmt+0x452>
  8008cf:	90                   	nop
  8008d0:	e9 c4 fb ff ff       	jmp    800499 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8008d5:	83 c4 3c             	add    $0x3c,%esp
  8008d8:	5b                   	pop    %ebx
  8008d9:	5e                   	pop    %esi
  8008da:	5f                   	pop    %edi
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 28             	sub    $0x28,%esp
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ec:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008fa:	85 c0                	test   %eax,%eax
  8008fc:	74 30                	je     80092e <vsnprintf+0x51>
  8008fe:	85 d2                	test   %edx,%edx
  800900:	7e 2c                	jle    80092e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800909:	8b 45 10             	mov    0x10(%ebp),%eax
  80090c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800910:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800913:	89 44 24 04          	mov    %eax,0x4(%esp)
  800917:	c7 04 24 2f 04 80 00 	movl   $0x80042f,(%esp)
  80091e:	e8 51 fb ff ff       	call   800474 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800926:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092c:	eb 05                	jmp    800933 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80092e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800933:	c9                   	leave  
  800934:	c3                   	ret    

00800935 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80093e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800942:	8b 45 10             	mov    0x10(%ebp),%eax
  800945:	89 44 24 08          	mov    %eax,0x8(%esp)
  800949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	89 04 24             	mov    %eax,(%esp)
  800956:	e8 82 ff ff ff       	call   8008dd <vsnprintf>
	va_end(ap);

	return rc;
}
  80095b:	c9                   	leave  
  80095c:	c3                   	ret    
  80095d:	66 90                	xchg   %ax,%ax
  80095f:	90                   	nop

00800960 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
  80096b:	eb 03                	jmp    800970 <strlen+0x10>
		n++;
  80096d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800970:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800974:	75 f7                	jne    80096d <strlen+0xd>
		n++;
	return n;
}
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    

00800978 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800981:	b8 00 00 00 00       	mov    $0x0,%eax
  800986:	eb 03                	jmp    80098b <strnlen+0x13>
		n++;
  800988:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098b:	39 d0                	cmp    %edx,%eax
  80098d:	74 06                	je     800995 <strnlen+0x1d>
  80098f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800993:	75 f3                	jne    800988 <strnlen+0x10>
		n++;
	return n;
}
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	53                   	push   %ebx
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a1:	89 c2                	mov    %eax,%edx
  8009a3:	83 c2 01             	add    $0x1,%edx
  8009a6:	83 c1 01             	add    $0x1,%ecx
  8009a9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009b0:	84 db                	test   %bl,%bl
  8009b2:	75 ef                	jne    8009a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009b4:	5b                   	pop    %ebx
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	53                   	push   %ebx
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c1:	89 1c 24             	mov    %ebx,(%esp)
  8009c4:	e8 97 ff ff ff       	call   800960 <strlen>
	strcpy(dst + len, src);
  8009c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009d0:	01 d8                	add    %ebx,%eax
  8009d2:	89 04 24             	mov    %eax,(%esp)
  8009d5:	e8 bd ff ff ff       	call   800997 <strcpy>
	return dst;
}
  8009da:	89 d8                	mov    %ebx,%eax
  8009dc:	83 c4 08             	add    $0x8,%esp
  8009df:	5b                   	pop    %ebx
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	56                   	push   %esi
  8009e6:	53                   	push   %ebx
  8009e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ed:	89 f3                	mov    %esi,%ebx
  8009ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f2:	89 f2                	mov    %esi,%edx
  8009f4:	eb 0f                	jmp    800a05 <strncpy+0x23>
		*dst++ = *src;
  8009f6:	83 c2 01             	add    $0x1,%edx
  8009f9:	0f b6 01             	movzbl (%ecx),%eax
  8009fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800a02:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a05:	39 da                	cmp    %ebx,%edx
  800a07:	75 ed                	jne    8009f6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a09:	89 f0                	mov    %esi,%eax
  800a0b:	5b                   	pop    %ebx
  800a0c:	5e                   	pop    %esi
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	56                   	push   %esi
  800a13:	53                   	push   %ebx
  800a14:	8b 75 08             	mov    0x8(%ebp),%esi
  800a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a1d:	89 f0                	mov    %esi,%eax
  800a1f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a23:	85 c9                	test   %ecx,%ecx
  800a25:	75 0b                	jne    800a32 <strlcpy+0x23>
  800a27:	eb 1d                	jmp    800a46 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a29:	83 c0 01             	add    $0x1,%eax
  800a2c:	83 c2 01             	add    $0x1,%edx
  800a2f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a32:	39 d8                	cmp    %ebx,%eax
  800a34:	74 0b                	je     800a41 <strlcpy+0x32>
  800a36:	0f b6 0a             	movzbl (%edx),%ecx
  800a39:	84 c9                	test   %cl,%cl
  800a3b:	75 ec                	jne    800a29 <strlcpy+0x1a>
  800a3d:	89 c2                	mov    %eax,%edx
  800a3f:	eb 02                	jmp    800a43 <strlcpy+0x34>
  800a41:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a43:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a46:	29 f0                	sub    %esi,%eax
}
  800a48:	5b                   	pop    %ebx
  800a49:	5e                   	pop    %esi
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    

00800a4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a52:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a55:	eb 06                	jmp    800a5d <strcmp+0x11>
		p++, q++;
  800a57:	83 c1 01             	add    $0x1,%ecx
  800a5a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a5d:	0f b6 01             	movzbl (%ecx),%eax
  800a60:	84 c0                	test   %al,%al
  800a62:	74 04                	je     800a68 <strcmp+0x1c>
  800a64:	3a 02                	cmp    (%edx),%al
  800a66:	74 ef                	je     800a57 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a68:	0f b6 c0             	movzbl %al,%eax
  800a6b:	0f b6 12             	movzbl (%edx),%edx
  800a6e:	29 d0                	sub    %edx,%eax
}
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	53                   	push   %ebx
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7c:	89 c3                	mov    %eax,%ebx
  800a7e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a81:	eb 06                	jmp    800a89 <strncmp+0x17>
		n--, p++, q++;
  800a83:	83 c0 01             	add    $0x1,%eax
  800a86:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a89:	39 d8                	cmp    %ebx,%eax
  800a8b:	74 15                	je     800aa2 <strncmp+0x30>
  800a8d:	0f b6 08             	movzbl (%eax),%ecx
  800a90:	84 c9                	test   %cl,%cl
  800a92:	74 04                	je     800a98 <strncmp+0x26>
  800a94:	3a 0a                	cmp    (%edx),%cl
  800a96:	74 eb                	je     800a83 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a98:	0f b6 00             	movzbl (%eax),%eax
  800a9b:	0f b6 12             	movzbl (%edx),%edx
  800a9e:	29 d0                	sub    %edx,%eax
  800aa0:	eb 05                	jmp    800aa7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800aa2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800aa7:	5b                   	pop    %ebx
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab4:	eb 07                	jmp    800abd <strchr+0x13>
		if (*s == c)
  800ab6:	38 ca                	cmp    %cl,%dl
  800ab8:	74 0f                	je     800ac9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aba:	83 c0 01             	add    $0x1,%eax
  800abd:	0f b6 10             	movzbl (%eax),%edx
  800ac0:	84 d2                	test   %dl,%dl
  800ac2:	75 f2                	jne    800ab6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800ac4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad5:	eb 07                	jmp    800ade <strfind+0x13>
		if (*s == c)
  800ad7:	38 ca                	cmp    %cl,%dl
  800ad9:	74 0a                	je     800ae5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800adb:	83 c0 01             	add    $0x1,%eax
  800ade:	0f b6 10             	movzbl (%eax),%edx
  800ae1:	84 d2                	test   %dl,%dl
  800ae3:	75 f2                	jne    800ad7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	57                   	push   %edi
  800aeb:	56                   	push   %esi
  800aec:	53                   	push   %ebx
  800aed:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af3:	85 c9                	test   %ecx,%ecx
  800af5:	74 36                	je     800b2d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800afd:	75 28                	jne    800b27 <memset+0x40>
  800aff:	f6 c1 03             	test   $0x3,%cl
  800b02:	75 23                	jne    800b27 <memset+0x40>
		c &= 0xFF;
  800b04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b08:	89 d3                	mov    %edx,%ebx
  800b0a:	c1 e3 08             	shl    $0x8,%ebx
  800b0d:	89 d6                	mov    %edx,%esi
  800b0f:	c1 e6 18             	shl    $0x18,%esi
  800b12:	89 d0                	mov    %edx,%eax
  800b14:	c1 e0 10             	shl    $0x10,%eax
  800b17:	09 f0                	or     %esi,%eax
  800b19:	09 c2                	or     %eax,%edx
  800b1b:	89 d0                	mov    %edx,%eax
  800b1d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b1f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b22:	fc                   	cld    
  800b23:	f3 ab                	rep stos %eax,%es:(%edi)
  800b25:	eb 06                	jmp    800b2d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2a:	fc                   	cld    
  800b2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b2d:	89 f8                	mov    %edi,%eax
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5f                   	pop    %edi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	57                   	push   %edi
  800b38:	56                   	push   %esi
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b42:	39 c6                	cmp    %eax,%esi
  800b44:	73 35                	jae    800b7b <memmove+0x47>
  800b46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b49:	39 d0                	cmp    %edx,%eax
  800b4b:	73 2e                	jae    800b7b <memmove+0x47>
		s += n;
		d += n;
  800b4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b50:	89 d6                	mov    %edx,%esi
  800b52:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b5a:	75 13                	jne    800b6f <memmove+0x3b>
  800b5c:	f6 c1 03             	test   $0x3,%cl
  800b5f:	75 0e                	jne    800b6f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b61:	83 ef 04             	sub    $0x4,%edi
  800b64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b6a:	fd                   	std    
  800b6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b6d:	eb 09                	jmp    800b78 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b6f:	83 ef 01             	sub    $0x1,%edi
  800b72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b75:	fd                   	std    
  800b76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b78:	fc                   	cld    
  800b79:	eb 1d                	jmp    800b98 <memmove+0x64>
  800b7b:	89 f2                	mov    %esi,%edx
  800b7d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b7f:	f6 c2 03             	test   $0x3,%dl
  800b82:	75 0f                	jne    800b93 <memmove+0x5f>
  800b84:	f6 c1 03             	test   $0x3,%cl
  800b87:	75 0a                	jne    800b93 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b89:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b8c:	89 c7                	mov    %eax,%edi
  800b8e:	fc                   	cld    
  800b8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b91:	eb 05                	jmp    800b98 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b93:	89 c7                	mov    %eax,%edi
  800b95:	fc                   	cld    
  800b96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b98:	5e                   	pop    %esi
  800b99:	5f                   	pop    %edi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	89 04 24             	mov    %eax,(%esp)
  800bb6:	e8 79 ff ff ff       	call   800b34 <memmove>
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	56                   	push   %esi
  800bc1:	53                   	push   %ebx
  800bc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc8:	89 d6                	mov    %edx,%esi
  800bca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bcd:	eb 1a                	jmp    800be9 <memcmp+0x2c>
		if (*s1 != *s2)
  800bcf:	0f b6 02             	movzbl (%edx),%eax
  800bd2:	0f b6 19             	movzbl (%ecx),%ebx
  800bd5:	38 d8                	cmp    %bl,%al
  800bd7:	74 0a                	je     800be3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800bd9:	0f b6 c0             	movzbl %al,%eax
  800bdc:	0f b6 db             	movzbl %bl,%ebx
  800bdf:	29 d8                	sub    %ebx,%eax
  800be1:	eb 0f                	jmp    800bf2 <memcmp+0x35>
		s1++, s2++;
  800be3:	83 c2 01             	add    $0x1,%edx
  800be6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800be9:	39 f2                	cmp    %esi,%edx
  800beb:	75 e2                	jne    800bcf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bff:	89 c2                	mov    %eax,%edx
  800c01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c04:	eb 07                	jmp    800c0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c06:	38 08                	cmp    %cl,(%eax)
  800c08:	74 07                	je     800c11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c0a:	83 c0 01             	add    $0x1,%eax
  800c0d:	39 d0                	cmp    %edx,%eax
  800c0f:	72 f5                	jb     800c06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	57                   	push   %edi
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
  800c19:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c1f:	eb 03                	jmp    800c24 <strtol+0x11>
		s++;
  800c21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c24:	0f b6 0a             	movzbl (%edx),%ecx
  800c27:	80 f9 09             	cmp    $0x9,%cl
  800c2a:	74 f5                	je     800c21 <strtol+0xe>
  800c2c:	80 f9 20             	cmp    $0x20,%cl
  800c2f:	74 f0                	je     800c21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c31:	80 f9 2b             	cmp    $0x2b,%cl
  800c34:	75 0a                	jne    800c40 <strtol+0x2d>
		s++;
  800c36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c39:	bf 00 00 00 00       	mov    $0x0,%edi
  800c3e:	eb 11                	jmp    800c51 <strtol+0x3e>
  800c40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c45:	80 f9 2d             	cmp    $0x2d,%cl
  800c48:	75 07                	jne    800c51 <strtol+0x3e>
		s++, neg = 1;
  800c4a:	8d 52 01             	lea    0x1(%edx),%edx
  800c4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c56:	75 15                	jne    800c6d <strtol+0x5a>
  800c58:	80 3a 30             	cmpb   $0x30,(%edx)
  800c5b:	75 10                	jne    800c6d <strtol+0x5a>
  800c5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c61:	75 0a                	jne    800c6d <strtol+0x5a>
		s += 2, base = 16;
  800c63:	83 c2 02             	add    $0x2,%edx
  800c66:	b8 10 00 00 00       	mov    $0x10,%eax
  800c6b:	eb 10                	jmp    800c7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c6d:	85 c0                	test   %eax,%eax
  800c6f:	75 0c                	jne    800c7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c73:	80 3a 30             	cmpb   $0x30,(%edx)
  800c76:	75 05                	jne    800c7d <strtol+0x6a>
		s++, base = 8;
  800c78:	83 c2 01             	add    $0x1,%edx
  800c7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c85:	0f b6 0a             	movzbl (%edx),%ecx
  800c88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c8b:	89 f0                	mov    %esi,%eax
  800c8d:	3c 09                	cmp    $0x9,%al
  800c8f:	77 08                	ja     800c99 <strtol+0x86>
			dig = *s - '0';
  800c91:	0f be c9             	movsbl %cl,%ecx
  800c94:	83 e9 30             	sub    $0x30,%ecx
  800c97:	eb 20                	jmp    800cb9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c9c:	89 f0                	mov    %esi,%eax
  800c9e:	3c 19                	cmp    $0x19,%al
  800ca0:	77 08                	ja     800caa <strtol+0x97>
			dig = *s - 'a' + 10;
  800ca2:	0f be c9             	movsbl %cl,%ecx
  800ca5:	83 e9 57             	sub    $0x57,%ecx
  800ca8:	eb 0f                	jmp    800cb9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800caa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cad:	89 f0                	mov    %esi,%eax
  800caf:	3c 19                	cmp    $0x19,%al
  800cb1:	77 16                	ja     800cc9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800cb3:	0f be c9             	movsbl %cl,%ecx
  800cb6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cb9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800cbc:	7d 0f                	jge    800ccd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800cbe:	83 c2 01             	add    $0x1,%edx
  800cc1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800cc5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800cc7:	eb bc                	jmp    800c85 <strtol+0x72>
  800cc9:	89 d8                	mov    %ebx,%eax
  800ccb:	eb 02                	jmp    800ccf <strtol+0xbc>
  800ccd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ccf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd3:	74 05                	je     800cda <strtol+0xc7>
		*endptr = (char *) s;
  800cd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cd8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cda:	f7 d8                	neg    %eax
  800cdc:	85 ff                	test   %edi,%edi
  800cde:	0f 44 c3             	cmove  %ebx,%eax
}
  800ce1:	5b                   	pop    %ebx
  800ce2:	5e                   	pop    %esi
  800ce3:	5f                   	pop    %edi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	57                   	push   %edi
  800cea:	56                   	push   %esi
  800ceb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cec:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf7:	89 c3                	mov    %eax,%ebx
  800cf9:	89 c7                	mov    %eax,%edi
  800cfb:	89 c6                	mov    %eax,%esi
  800cfd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d14:	89 d1                	mov    %edx,%ecx
  800d16:	89 d3                	mov    %edx,%ebx
  800d18:	89 d7                	mov    %edx,%edi
  800d1a:	89 d6                	mov    %edx,%esi
  800d1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5f                   	pop    %edi
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
  800d29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d31:	b8 03 00 00 00       	mov    $0x3,%eax
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	89 cb                	mov    %ecx,%ebx
  800d3b:	89 cf                	mov    %ecx,%edi
  800d3d:	89 ce                	mov    %ecx,%esi
  800d3f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d41:	85 c0                	test   %eax,%eax
  800d43:	7e 28                	jle    800d6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d50:	00 
  800d51:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  800d58:	00 
  800d59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d60:	00 
  800d61:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  800d68:	e8 ba f4 ff ff       	call   800227 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d6d:	83 c4 2c             	add    $0x2c,%esp
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d83:	b8 04 00 00 00       	mov    $0x4,%eax
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	89 cb                	mov    %ecx,%ebx
  800d8d:	89 cf                	mov    %ecx,%edi
  800d8f:	89 ce                	mov    %ecx,%esi
  800d91:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d93:	85 c0                	test   %eax,%eax
  800d95:	7e 28                	jle    800dbf <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d97:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d9b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800da2:	00 
  800da3:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  800daa:	00 
  800dab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db2:	00 
  800db3:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  800dba:	e8 68 f4 ff ff       	call   800227 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800dbf:	83 c4 2c             	add    $0x2c,%esp
  800dc2:	5b                   	pop    %ebx
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd2:	b8 02 00 00 00       	mov    $0x2,%eax
  800dd7:	89 d1                	mov    %edx,%ecx
  800dd9:	89 d3                	mov    %edx,%ebx
  800ddb:	89 d7                	mov    %edx,%edi
  800ddd:	89 d6                	mov    %edx,%esi
  800ddf:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_yield>:

void
sys_yield(void)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dec:	ba 00 00 00 00       	mov    $0x0,%edx
  800df1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800df6:	89 d1                	mov    %edx,%ecx
  800df8:	89 d3                	mov    %edx,%ebx
  800dfa:	89 d7                	mov    %edx,%edi
  800dfc:	89 d6                	mov    %edx,%esi
  800dfe:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5f                   	pop    %edi
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800e0e:	be 00 00 00 00       	mov    $0x0,%esi
  800e13:	b8 05 00 00 00       	mov    $0x5,%eax
  800e18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e21:	89 f7                	mov    %esi,%edi
  800e23:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e25:	85 c0                	test   %eax,%eax
  800e27:	7e 28                	jle    800e51 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e29:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e2d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e34:	00 
  800e35:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  800e3c:	00 
  800e3d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e44:	00 
  800e45:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  800e4c:	e8 d6 f3 ff ff       	call   800227 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e51:	83 c4 2c             	add    $0x2c,%esp
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
  800e5f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e62:	b8 06 00 00 00       	mov    $0x6,%eax
  800e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e70:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e73:	8b 75 18             	mov    0x18(%ebp),%esi
  800e76:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	7e 28                	jle    800ea4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e80:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e87:	00 
  800e88:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  800e8f:	00 
  800e90:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e97:	00 
  800e98:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  800e9f:	e8 83 f3 ff ff       	call   800227 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ea4:	83 c4 2c             	add    $0x2c,%esp
  800ea7:	5b                   	pop    %ebx
  800ea8:	5e                   	pop    %esi
  800ea9:	5f                   	pop    %edi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	57                   	push   %edi
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
  800eb2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eba:	b8 07 00 00 00       	mov    $0x7,%eax
  800ebf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	89 df                	mov    %ebx,%edi
  800ec7:	89 de                	mov    %ebx,%esi
  800ec9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	7e 28                	jle    800ef7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800eda:	00 
  800edb:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  800ee2:	00 
  800ee3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eea:	00 
  800eeb:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  800ef2:	e8 30 f3 ff ff       	call   800227 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ef7:	83 c4 2c             	add    $0x2c,%esp
  800efa:	5b                   	pop    %ebx
  800efb:	5e                   	pop    %esi
  800efc:	5f                   	pop    %edi
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    

00800eff <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	57                   	push   %edi
  800f03:	56                   	push   %esi
  800f04:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f05:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0a:	b8 10 00 00 00       	mov    $0x10,%eax
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	89 cb                	mov    %ecx,%ebx
  800f14:	89 cf                	mov    %ecx,%edi
  800f16:	89 ce                	mov    %ecx,%esi
  800f18:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	57                   	push   %edi
  800f23:	56                   	push   %esi
  800f24:	53                   	push   %ebx
  800f25:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2d:	b8 09 00 00 00       	mov    $0x9,%eax
  800f32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	89 df                	mov    %ebx,%edi
  800f3a:	89 de                	mov    %ebx,%esi
  800f3c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	7e 28                	jle    800f6a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f42:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f46:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f4d:	00 
  800f4e:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  800f55:	00 
  800f56:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f5d:	00 
  800f5e:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  800f65:	e8 bd f2 ff ff       	call   800227 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f6a:	83 c4 2c             	add    $0x2c,%esp
  800f6d:	5b                   	pop    %ebx
  800f6e:	5e                   	pop    %esi
  800f6f:	5f                   	pop    %edi
  800f70:	5d                   	pop    %ebp
  800f71:	c3                   	ret    

00800f72 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	57                   	push   %edi
  800f76:	56                   	push   %esi
  800f77:	53                   	push   %ebx
  800f78:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f88:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8b:	89 df                	mov    %ebx,%edi
  800f8d:	89 de                	mov    %ebx,%esi
  800f8f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f91:	85 c0                	test   %eax,%eax
  800f93:	7e 28                	jle    800fbd <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f95:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f99:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fa0:	00 
  800fa1:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  800fa8:	00 
  800fa9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb0:	00 
  800fb1:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  800fb8:	e8 6a f2 ff ff       	call   800227 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fbd:	83 c4 2c             	add    $0x2c,%esp
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	57                   	push   %edi
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
  800fcb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fce:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fde:	89 df                	mov    %ebx,%edi
  800fe0:	89 de                	mov    %ebx,%esi
  800fe2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe4:	85 c0                	test   %eax,%eax
  800fe6:	7e 28                	jle    801010 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fec:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800ff3:	00 
  800ff4:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801003:	00 
  801004:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  80100b:	e8 17 f2 ff ff       	call   800227 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801010:	83 c4 2c             	add    $0x2c,%esp
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5f                   	pop    %edi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101e:	be 00 00 00 00       	mov    $0x0,%esi
  801023:	b8 0d 00 00 00       	mov    $0xd,%eax
  801028:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102b:	8b 55 08             	mov    0x8(%ebp),%edx
  80102e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801031:	8b 7d 14             	mov    0x14(%ebp),%edi
  801034:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801036:	5b                   	pop    %ebx
  801037:	5e                   	pop    %esi
  801038:	5f                   	pop    %edi
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	57                   	push   %edi
  80103f:	56                   	push   %esi
  801040:	53                   	push   %ebx
  801041:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801044:	b9 00 00 00 00       	mov    $0x0,%ecx
  801049:	b8 0e 00 00 00       	mov    $0xe,%eax
  80104e:	8b 55 08             	mov    0x8(%ebp),%edx
  801051:	89 cb                	mov    %ecx,%ebx
  801053:	89 cf                	mov    %ecx,%edi
  801055:	89 ce                	mov    %ecx,%esi
  801057:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801059:	85 c0                	test   %eax,%eax
  80105b:	7e 28                	jle    801085 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80105d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801061:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801068:	00 
  801069:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  801070:	00 
  801071:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801078:	00 
  801079:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  801080:	e8 a2 f1 ff ff       	call   800227 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801085:	83 c4 2c             	add    $0x2c,%esp
  801088:	5b                   	pop    %ebx
  801089:	5e                   	pop    %esi
  80108a:	5f                   	pop    %edi
  80108b:	5d                   	pop    %ebp
  80108c:	c3                   	ret    

0080108d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	57                   	push   %edi
  801091:	56                   	push   %esi
  801092:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801093:	ba 00 00 00 00       	mov    $0x0,%edx
  801098:	b8 0f 00 00 00       	mov    $0xf,%eax
  80109d:	89 d1                	mov    %edx,%ecx
  80109f:	89 d3                	mov    %edx,%ebx
  8010a1:	89 d7                	mov    %edx,%edi
  8010a3:	89 d6                	mov    %edx,%esi
  8010a5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010a7:	5b                   	pop    %ebx
  8010a8:	5e                   	pop    %esi
  8010a9:	5f                   	pop    %edi
  8010aa:	5d                   	pop    %ebp
  8010ab:	c3                   	ret    

008010ac <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	57                   	push   %edi
  8010b0:	56                   	push   %esi
  8010b1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b7:	b8 11 00 00 00       	mov    $0x11,%eax
  8010bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c2:	89 df                	mov    %ebx,%edi
  8010c4:	89 de                	mov    %ebx,%esi
  8010c6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  8010c8:	5b                   	pop    %ebx
  8010c9:	5e                   	pop    %esi
  8010ca:	5f                   	pop    %edi
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    

008010cd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	57                   	push   %edi
  8010d1:	56                   	push   %esi
  8010d2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d8:	b8 12 00 00 00       	mov    $0x12,%eax
  8010dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e3:	89 df                	mov    %ebx,%edi
  8010e5:	89 de                	mov    %ebx,%esi
  8010e7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8010e9:	5b                   	pop    %ebx
  8010ea:	5e                   	pop    %esi
  8010eb:	5f                   	pop    %edi
  8010ec:	5d                   	pop    %ebp
  8010ed:	c3                   	ret    

008010ee <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
  8010f1:	57                   	push   %edi
  8010f2:	56                   	push   %esi
  8010f3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f9:	b8 13 00 00 00       	mov    $0x13,%eax
  8010fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801101:	89 cb                	mov    %ecx,%ebx
  801103:	89 cf                	mov    %ecx,%edi
  801105:	89 ce                	mov    %ecx,%esi
  801107:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801109:	5b                   	pop    %ebx
  80110a:	5e                   	pop    %esi
  80110b:	5f                   	pop    %edi
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    
  80110e:	66 90                	xchg   %ax,%ax

00801110 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	05 00 00 00 30       	add    $0x30000000,%eax
  80111b:	c1 e8 0c             	shr    $0xc,%eax
}
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    

00801120 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80112b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801130:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801142:	89 c2                	mov    %eax,%edx
  801144:	c1 ea 16             	shr    $0x16,%edx
  801147:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80114e:	f6 c2 01             	test   $0x1,%dl
  801151:	74 11                	je     801164 <fd_alloc+0x2d>
  801153:	89 c2                	mov    %eax,%edx
  801155:	c1 ea 0c             	shr    $0xc,%edx
  801158:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80115f:	f6 c2 01             	test   $0x1,%dl
  801162:	75 09                	jne    80116d <fd_alloc+0x36>
			*fd_store = fd;
  801164:	89 01                	mov    %eax,(%ecx)
			return 0;
  801166:	b8 00 00 00 00       	mov    $0x0,%eax
  80116b:	eb 17                	jmp    801184 <fd_alloc+0x4d>
  80116d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801172:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801177:	75 c9                	jne    801142 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801179:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80117f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    

00801186 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80118c:	83 f8 1f             	cmp    $0x1f,%eax
  80118f:	77 36                	ja     8011c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801191:	c1 e0 0c             	shl    $0xc,%eax
  801194:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801199:	89 c2                	mov    %eax,%edx
  80119b:	c1 ea 16             	shr    $0x16,%edx
  80119e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011a5:	f6 c2 01             	test   $0x1,%dl
  8011a8:	74 24                	je     8011ce <fd_lookup+0x48>
  8011aa:	89 c2                	mov    %eax,%edx
  8011ac:	c1 ea 0c             	shr    $0xc,%edx
  8011af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011b6:	f6 c2 01             	test   $0x1,%dl
  8011b9:	74 1a                	je     8011d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011be:	89 02                	mov    %eax,(%edx)
	return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c5:	eb 13                	jmp    8011da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011cc:	eb 0c                	jmp    8011da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d3:	eb 05                	jmp    8011da <fd_lookup+0x54>
  8011d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    

008011dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 18             	sub    $0x18,%esp
  8011e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ea:	eb 13                	jmp    8011ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8011ec:	39 08                	cmp    %ecx,(%eax)
  8011ee:	75 0c                	jne    8011fc <dev_lookup+0x20>
			*dev = devtab[i];
  8011f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fa:	eb 38                	jmp    801234 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011fc:	83 c2 01             	add    $0x1,%edx
  8011ff:	8b 04 95 c0 2d 80 00 	mov    0x802dc0(,%edx,4),%eax
  801206:	85 c0                	test   %eax,%eax
  801208:	75 e2                	jne    8011ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80120a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80120f:	8b 40 48             	mov    0x48(%eax),%eax
  801212:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801216:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121a:	c7 04 24 44 2d 80 00 	movl   $0x802d44,(%esp)
  801221:	e8 fa f0 ff ff       	call   800320 <cprintf>
	*dev = 0;
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80122f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	56                   	push   %esi
  80123a:	53                   	push   %ebx
  80123b:	83 ec 20             	sub    $0x20,%esp
  80123e:	8b 75 08             	mov    0x8(%ebp),%esi
  801241:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801244:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801247:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801251:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801254:	89 04 24             	mov    %eax,(%esp)
  801257:	e8 2a ff ff ff       	call   801186 <fd_lookup>
  80125c:	85 c0                	test   %eax,%eax
  80125e:	78 05                	js     801265 <fd_close+0x2f>
	    || fd != fd2)
  801260:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801263:	74 0c                	je     801271 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801265:	84 db                	test   %bl,%bl
  801267:	ba 00 00 00 00       	mov    $0x0,%edx
  80126c:	0f 44 c2             	cmove  %edx,%eax
  80126f:	eb 3f                	jmp    8012b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801271:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801274:	89 44 24 04          	mov    %eax,0x4(%esp)
  801278:	8b 06                	mov    (%esi),%eax
  80127a:	89 04 24             	mov    %eax,(%esp)
  80127d:	e8 5a ff ff ff       	call   8011dc <dev_lookup>
  801282:	89 c3                	mov    %eax,%ebx
  801284:	85 c0                	test   %eax,%eax
  801286:	78 16                	js     80129e <fd_close+0x68>
		if (dev->dev_close)
  801288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80128e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801293:	85 c0                	test   %eax,%eax
  801295:	74 07                	je     80129e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801297:	89 34 24             	mov    %esi,(%esp)
  80129a:	ff d0                	call   *%eax
  80129c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80129e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a9:	e8 fe fb ff ff       	call   800eac <sys_page_unmap>
	return r;
  8012ae:	89 d8                	mov    %ebx,%eax
}
  8012b0:	83 c4 20             	add    $0x20,%esp
  8012b3:	5b                   	pop    %ebx
  8012b4:	5e                   	pop    %esi
  8012b5:	5d                   	pop    %ebp
  8012b6:	c3                   	ret    

008012b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	89 04 24             	mov    %eax,(%esp)
  8012ca:	e8 b7 fe ff ff       	call   801186 <fd_lookup>
  8012cf:	89 c2                	mov    %eax,%edx
  8012d1:	85 d2                	test   %edx,%edx
  8012d3:	78 13                	js     8012e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012dc:	00 
  8012dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e0:	89 04 24             	mov    %eax,(%esp)
  8012e3:	e8 4e ff ff ff       	call   801236 <fd_close>
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <close_all>:

void
close_all(void)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012f6:	89 1c 24             	mov    %ebx,(%esp)
  8012f9:	e8 b9 ff ff ff       	call   8012b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012fe:	83 c3 01             	add    $0x1,%ebx
  801301:	83 fb 20             	cmp    $0x20,%ebx
  801304:	75 f0                	jne    8012f6 <close_all+0xc>
		close(i);
}
  801306:	83 c4 14             	add    $0x14,%esp
  801309:	5b                   	pop    %ebx
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	57                   	push   %edi
  801310:	56                   	push   %esi
  801311:	53                   	push   %ebx
  801312:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801315:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801318:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 04 24             	mov    %eax,(%esp)
  801322:	e8 5f fe ff ff       	call   801186 <fd_lookup>
  801327:	89 c2                	mov    %eax,%edx
  801329:	85 d2                	test   %edx,%edx
  80132b:	0f 88 e1 00 00 00    	js     801412 <dup+0x106>
		return r;
	close(newfdnum);
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	89 04 24             	mov    %eax,(%esp)
  801337:	e8 7b ff ff ff       	call   8012b7 <close>

	newfd = INDEX2FD(newfdnum);
  80133c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80133f:	c1 e3 0c             	shl    $0xc,%ebx
  801342:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80134b:	89 04 24             	mov    %eax,(%esp)
  80134e:	e8 cd fd ff ff       	call   801120 <fd2data>
  801353:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801355:	89 1c 24             	mov    %ebx,(%esp)
  801358:	e8 c3 fd ff ff       	call   801120 <fd2data>
  80135d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80135f:	89 f0                	mov    %esi,%eax
  801361:	c1 e8 16             	shr    $0x16,%eax
  801364:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80136b:	a8 01                	test   $0x1,%al
  80136d:	74 43                	je     8013b2 <dup+0xa6>
  80136f:	89 f0                	mov    %esi,%eax
  801371:	c1 e8 0c             	shr    $0xc,%eax
  801374:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80137b:	f6 c2 01             	test   $0x1,%dl
  80137e:	74 32                	je     8013b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801380:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801387:	25 07 0e 00 00       	and    $0xe07,%eax
  80138c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801390:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801394:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80139b:	00 
  80139c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a7:	e8 ad fa ff ff       	call   800e59 <sys_page_map>
  8013ac:	89 c6                	mov    %eax,%esi
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	78 3e                	js     8013f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b5:	89 c2                	mov    %eax,%edx
  8013b7:	c1 ea 0c             	shr    $0xc,%edx
  8013ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013d6:	00 
  8013d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e2:	e8 72 fa ff ff       	call   800e59 <sys_page_map>
  8013e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ec:	85 f6                	test   %esi,%esi
  8013ee:	79 22                	jns    801412 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fb:	e8 ac fa ff ff       	call   800eac <sys_page_unmap>
	sys_page_unmap(0, nva);
  801400:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801404:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80140b:	e8 9c fa ff ff       	call   800eac <sys_page_unmap>
	return r;
  801410:	89 f0                	mov    %esi,%eax
}
  801412:	83 c4 3c             	add    $0x3c,%esp
  801415:	5b                   	pop    %ebx
  801416:	5e                   	pop    %esi
  801417:	5f                   	pop    %edi
  801418:	5d                   	pop    %ebp
  801419:	c3                   	ret    

0080141a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	53                   	push   %ebx
  80141e:	83 ec 24             	sub    $0x24,%esp
  801421:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801424:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801427:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142b:	89 1c 24             	mov    %ebx,(%esp)
  80142e:	e8 53 fd ff ff       	call   801186 <fd_lookup>
  801433:	89 c2                	mov    %eax,%edx
  801435:	85 d2                	test   %edx,%edx
  801437:	78 6d                	js     8014a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801439:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801443:	8b 00                	mov    (%eax),%eax
  801445:	89 04 24             	mov    %eax,(%esp)
  801448:	e8 8f fd ff ff       	call   8011dc <dev_lookup>
  80144d:	85 c0                	test   %eax,%eax
  80144f:	78 55                	js     8014a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801454:	8b 50 08             	mov    0x8(%eax),%edx
  801457:	83 e2 03             	and    $0x3,%edx
  80145a:	83 fa 01             	cmp    $0x1,%edx
  80145d:	75 23                	jne    801482 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80145f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801464:	8b 40 48             	mov    0x48(%eax),%eax
  801467:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80146b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146f:	c7 04 24 85 2d 80 00 	movl   $0x802d85,(%esp)
  801476:	e8 a5 ee ff ff       	call   800320 <cprintf>
		return -E_INVAL;
  80147b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801480:	eb 24                	jmp    8014a6 <read+0x8c>
	}
	if (!dev->dev_read)
  801482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801485:	8b 52 08             	mov    0x8(%edx),%edx
  801488:	85 d2                	test   %edx,%edx
  80148a:	74 15                	je     8014a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80148c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80148f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801493:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801496:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80149a:	89 04 24             	mov    %eax,(%esp)
  80149d:	ff d2                	call   *%edx
  80149f:	eb 05                	jmp    8014a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014a6:	83 c4 24             	add    $0x24,%esp
  8014a9:	5b                   	pop    %ebx
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    

008014ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	57                   	push   %edi
  8014b0:	56                   	push   %esi
  8014b1:	53                   	push   %ebx
  8014b2:	83 ec 1c             	sub    $0x1c,%esp
  8014b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014c0:	eb 23                	jmp    8014e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c2:	89 f0                	mov    %esi,%eax
  8014c4:	29 d8                	sub    %ebx,%eax
  8014c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ca:	89 d8                	mov    %ebx,%eax
  8014cc:	03 45 0c             	add    0xc(%ebp),%eax
  8014cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d3:	89 3c 24             	mov    %edi,(%esp)
  8014d6:	e8 3f ff ff ff       	call   80141a <read>
		if (m < 0)
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	78 10                	js     8014ef <readn+0x43>
			return m;
		if (m == 0)
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	74 0a                	je     8014ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014e3:	01 c3                	add    %eax,%ebx
  8014e5:	39 f3                	cmp    %esi,%ebx
  8014e7:	72 d9                	jb     8014c2 <readn+0x16>
  8014e9:	89 d8                	mov    %ebx,%eax
  8014eb:	eb 02                	jmp    8014ef <readn+0x43>
  8014ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014ef:	83 c4 1c             	add    $0x1c,%esp
  8014f2:	5b                   	pop    %ebx
  8014f3:	5e                   	pop    %esi
  8014f4:	5f                   	pop    %edi
  8014f5:	5d                   	pop    %ebp
  8014f6:	c3                   	ret    

008014f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	53                   	push   %ebx
  8014fb:	83 ec 24             	sub    $0x24,%esp
  8014fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801501:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801504:	89 44 24 04          	mov    %eax,0x4(%esp)
  801508:	89 1c 24             	mov    %ebx,(%esp)
  80150b:	e8 76 fc ff ff       	call   801186 <fd_lookup>
  801510:	89 c2                	mov    %eax,%edx
  801512:	85 d2                	test   %edx,%edx
  801514:	78 68                	js     80157e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801516:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801519:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801520:	8b 00                	mov    (%eax),%eax
  801522:	89 04 24             	mov    %eax,(%esp)
  801525:	e8 b2 fc ff ff       	call   8011dc <dev_lookup>
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 50                	js     80157e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801531:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801535:	75 23                	jne    80155a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801537:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80153c:	8b 40 48             	mov    0x48(%eax),%eax
  80153f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801543:	89 44 24 04          	mov    %eax,0x4(%esp)
  801547:	c7 04 24 a1 2d 80 00 	movl   $0x802da1,(%esp)
  80154e:	e8 cd ed ff ff       	call   800320 <cprintf>
		return -E_INVAL;
  801553:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801558:	eb 24                	jmp    80157e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80155a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155d:	8b 52 0c             	mov    0xc(%edx),%edx
  801560:	85 d2                	test   %edx,%edx
  801562:	74 15                	je     801579 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801564:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801567:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80156b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80156e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801572:	89 04 24             	mov    %eax,(%esp)
  801575:	ff d2                	call   *%edx
  801577:	eb 05                	jmp    80157e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801579:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80157e:	83 c4 24             	add    $0x24,%esp
  801581:	5b                   	pop    %ebx
  801582:	5d                   	pop    %ebp
  801583:	c3                   	ret    

00801584 <seek>:

int
seek(int fdnum, off_t offset)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80158d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	89 04 24             	mov    %eax,(%esp)
  801597:	e8 ea fb ff ff       	call   801186 <fd_lookup>
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 0e                	js     8015ae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	53                   	push   %ebx
  8015b4:	83 ec 24             	sub    $0x24,%esp
  8015b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c1:	89 1c 24             	mov    %ebx,(%esp)
  8015c4:	e8 bd fb ff ff       	call   801186 <fd_lookup>
  8015c9:	89 c2                	mov    %eax,%edx
  8015cb:	85 d2                	test   %edx,%edx
  8015cd:	78 61                	js     801630 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d9:	8b 00                	mov    (%eax),%eax
  8015db:	89 04 24             	mov    %eax,(%esp)
  8015de:	e8 f9 fb ff ff       	call   8011dc <dev_lookup>
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	78 49                	js     801630 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ee:	75 23                	jne    801613 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015f0:	a1 0c 40 80 00       	mov    0x80400c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015f5:	8b 40 48             	mov    0x48(%eax),%eax
  8015f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801600:	c7 04 24 64 2d 80 00 	movl   $0x802d64,(%esp)
  801607:	e8 14 ed ff ff       	call   800320 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80160c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801611:	eb 1d                	jmp    801630 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801613:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801616:	8b 52 18             	mov    0x18(%edx),%edx
  801619:	85 d2                	test   %edx,%edx
  80161b:	74 0e                	je     80162b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80161d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801620:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801624:	89 04 24             	mov    %eax,(%esp)
  801627:	ff d2                	call   *%edx
  801629:	eb 05                	jmp    801630 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80162b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801630:	83 c4 24             	add    $0x24,%esp
  801633:	5b                   	pop    %ebx
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    

00801636 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	53                   	push   %ebx
  80163a:	83 ec 24             	sub    $0x24,%esp
  80163d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801640:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801643:	89 44 24 04          	mov    %eax,0x4(%esp)
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	89 04 24             	mov    %eax,(%esp)
  80164d:	e8 34 fb ff ff       	call   801186 <fd_lookup>
  801652:	89 c2                	mov    %eax,%edx
  801654:	85 d2                	test   %edx,%edx
  801656:	78 52                	js     8016aa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801658:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801662:	8b 00                	mov    (%eax),%eax
  801664:	89 04 24             	mov    %eax,(%esp)
  801667:	e8 70 fb ff ff       	call   8011dc <dev_lookup>
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 3a                	js     8016aa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801673:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801677:	74 2c                	je     8016a5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801679:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80167c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801683:	00 00 00 
	stat->st_isdir = 0;
  801686:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80168d:	00 00 00 
	stat->st_dev = dev;
  801690:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801696:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80169a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80169d:	89 14 24             	mov    %edx,(%esp)
  8016a0:	ff 50 14             	call   *0x14(%eax)
  8016a3:	eb 05                	jmp    8016aa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016aa:	83 c4 24             	add    $0x24,%esp
  8016ad:	5b                   	pop    %ebx
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    

008016b0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
  8016b5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016bf:	00 
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	89 04 24             	mov    %eax,(%esp)
  8016c6:	e8 99 02 00 00       	call   801964 <open>
  8016cb:	89 c3                	mov    %eax,%ebx
  8016cd:	85 db                	test   %ebx,%ebx
  8016cf:	78 1b                	js     8016ec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d8:	89 1c 24             	mov    %ebx,(%esp)
  8016db:	e8 56 ff ff ff       	call   801636 <fstat>
  8016e0:	89 c6                	mov    %eax,%esi
	close(fd);
  8016e2:	89 1c 24             	mov    %ebx,(%esp)
  8016e5:	e8 cd fb ff ff       	call   8012b7 <close>
	return r;
  8016ea:	89 f0                	mov    %esi,%eax
}
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	5b                   	pop    %ebx
  8016f0:	5e                   	pop    %esi
  8016f1:	5d                   	pop    %ebp
  8016f2:	c3                   	ret    

008016f3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	56                   	push   %esi
  8016f7:	53                   	push   %ebx
  8016f8:	83 ec 10             	sub    $0x10,%esp
  8016fb:	89 c6                	mov    %eax,%esi
  8016fd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016ff:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801706:	75 11                	jne    801719 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801708:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80170f:	e8 5b 0f 00 00       	call   80266f <ipc_find_env>
  801714:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801719:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801720:	00 
  801721:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801728:	00 
  801729:	89 74 24 04          	mov    %esi,0x4(%esp)
  80172d:	a1 04 40 80 00       	mov    0x804004,%eax
  801732:	89 04 24             	mov    %eax,(%esp)
  801735:	e8 ce 0e 00 00       	call   802608 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80173a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801741:	00 
  801742:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801746:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80174d:	e8 4e 0e 00 00       	call   8025a0 <ipc_recv>
}
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    

00801759 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	8b 40 0c             	mov    0xc(%eax),%eax
  801765:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80176a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801772:	ba 00 00 00 00       	mov    $0x0,%edx
  801777:	b8 02 00 00 00       	mov    $0x2,%eax
  80177c:	e8 72 ff ff ff       	call   8016f3 <fsipc>
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	8b 40 0c             	mov    0xc(%eax),%eax
  80178f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801794:	ba 00 00 00 00       	mov    $0x0,%edx
  801799:	b8 06 00 00 00       	mov    $0x6,%eax
  80179e:	e8 50 ff ff ff       	call   8016f3 <fsipc>
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 14             	sub    $0x14,%esp
  8017ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8017c4:	e8 2a ff ff ff       	call   8016f3 <fsipc>
  8017c9:	89 c2                	mov    %eax,%edx
  8017cb:	85 d2                	test   %edx,%edx
  8017cd:	78 2b                	js     8017fa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017cf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017d6:	00 
  8017d7:	89 1c 24             	mov    %ebx,(%esp)
  8017da:	e8 b8 f1 ff ff       	call   800997 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017df:	a1 80 50 80 00       	mov    0x805080,%eax
  8017e4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017ea:	a1 84 50 80 00       	mov    0x805084,%eax
  8017ef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fa:	83 c4 14             	add    $0x14,%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	53                   	push   %ebx
  801804:	83 ec 14             	sub    $0x14,%esp
  801807:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80180a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801810:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801815:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801818:	8b 55 08             	mov    0x8(%ebp),%edx
  80181b:	8b 52 0c             	mov    0xc(%edx),%edx
  80181e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  801824:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801829:	89 44 24 08          	mov    %eax,0x8(%esp)
  80182d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801830:	89 44 24 04          	mov    %eax,0x4(%esp)
  801834:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80183b:	e8 f4 f2 ff ff       	call   800b34 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801840:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  801847:	00 
  801848:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  80184f:	e8 cc ea ff ff       	call   800320 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801854:	ba 00 00 00 00       	mov    $0x0,%edx
  801859:	b8 04 00 00 00       	mov    $0x4,%eax
  80185e:	e8 90 fe ff ff       	call   8016f3 <fsipc>
  801863:	85 c0                	test   %eax,%eax
  801865:	78 53                	js     8018ba <devfile_write+0xba>
		return r;
	assert(r <= n);
  801867:	39 c3                	cmp    %eax,%ebx
  801869:	73 24                	jae    80188f <devfile_write+0x8f>
  80186b:	c7 44 24 0c d9 2d 80 	movl   $0x802dd9,0xc(%esp)
  801872:	00 
  801873:	c7 44 24 08 e0 2d 80 	movl   $0x802de0,0x8(%esp)
  80187a:	00 
  80187b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801882:	00 
  801883:	c7 04 24 f5 2d 80 00 	movl   $0x802df5,(%esp)
  80188a:	e8 98 e9 ff ff       	call   800227 <_panic>
	assert(r <= PGSIZE);
  80188f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801894:	7e 24                	jle    8018ba <devfile_write+0xba>
  801896:	c7 44 24 0c 00 2e 80 	movl   $0x802e00,0xc(%esp)
  80189d:	00 
  80189e:	c7 44 24 08 e0 2d 80 	movl   $0x802de0,0x8(%esp)
  8018a5:	00 
  8018a6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8018ad:	00 
  8018ae:	c7 04 24 f5 2d 80 00 	movl   $0x802df5,(%esp)
  8018b5:	e8 6d e9 ff ff       	call   800227 <_panic>
	return r;
}
  8018ba:	83 c4 14             	add    $0x14,%esp
  8018bd:	5b                   	pop    %ebx
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    

008018c0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	56                   	push   %esi
  8018c4:	53                   	push   %ebx
  8018c5:	83 ec 10             	sub    $0x10,%esp
  8018c8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018d6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8018e6:	e8 08 fe ff ff       	call   8016f3 <fsipc>
  8018eb:	89 c3                	mov    %eax,%ebx
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	78 6a                	js     80195b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018f1:	39 c6                	cmp    %eax,%esi
  8018f3:	73 24                	jae    801919 <devfile_read+0x59>
  8018f5:	c7 44 24 0c d9 2d 80 	movl   $0x802dd9,0xc(%esp)
  8018fc:	00 
  8018fd:	c7 44 24 08 e0 2d 80 	movl   $0x802de0,0x8(%esp)
  801904:	00 
  801905:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80190c:	00 
  80190d:	c7 04 24 f5 2d 80 00 	movl   $0x802df5,(%esp)
  801914:	e8 0e e9 ff ff       	call   800227 <_panic>
	assert(r <= PGSIZE);
  801919:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80191e:	7e 24                	jle    801944 <devfile_read+0x84>
  801920:	c7 44 24 0c 00 2e 80 	movl   $0x802e00,0xc(%esp)
  801927:	00 
  801928:	c7 44 24 08 e0 2d 80 	movl   $0x802de0,0x8(%esp)
  80192f:	00 
  801930:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801937:	00 
  801938:	c7 04 24 f5 2d 80 00 	movl   $0x802df5,(%esp)
  80193f:	e8 e3 e8 ff ff       	call   800227 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801944:	89 44 24 08          	mov    %eax,0x8(%esp)
  801948:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80194f:	00 
  801950:	8b 45 0c             	mov    0xc(%ebp),%eax
  801953:	89 04 24             	mov    %eax,(%esp)
  801956:	e8 d9 f1 ff ff       	call   800b34 <memmove>
	return r;
}
  80195b:	89 d8                	mov    %ebx,%eax
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	5b                   	pop    %ebx
  801961:	5e                   	pop    %esi
  801962:	5d                   	pop    %ebp
  801963:	c3                   	ret    

00801964 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	53                   	push   %ebx
  801968:	83 ec 24             	sub    $0x24,%esp
  80196b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80196e:	89 1c 24             	mov    %ebx,(%esp)
  801971:	e8 ea ef ff ff       	call   800960 <strlen>
  801976:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80197b:	7f 60                	jg     8019dd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80197d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801980:	89 04 24             	mov    %eax,(%esp)
  801983:	e8 af f7 ff ff       	call   801137 <fd_alloc>
  801988:	89 c2                	mov    %eax,%edx
  80198a:	85 d2                	test   %edx,%edx
  80198c:	78 54                	js     8019e2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80198e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801992:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801999:	e8 f9 ef ff ff       	call   800997 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80199e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a1:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ae:	e8 40 fd ff ff       	call   8016f3 <fsipc>
  8019b3:	89 c3                	mov    %eax,%ebx
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	79 17                	jns    8019d0 <open+0x6c>
		fd_close(fd, 0);
  8019b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019c0:	00 
  8019c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c4:	89 04 24             	mov    %eax,(%esp)
  8019c7:	e8 6a f8 ff ff       	call   801236 <fd_close>
		return r;
  8019cc:	89 d8                	mov    %ebx,%eax
  8019ce:	eb 12                	jmp    8019e2 <open+0x7e>
	}

	return fd2num(fd);
  8019d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d3:	89 04 24             	mov    %eax,(%esp)
  8019d6:	e8 35 f7 ff ff       	call   801110 <fd2num>
  8019db:	eb 05                	jmp    8019e2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8019dd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8019e2:	83 c4 24             	add    $0x24,%esp
  8019e5:	5b                   	pop    %ebx
  8019e6:	5d                   	pop    %ebp
  8019e7:	c3                   	ret    

008019e8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f3:	b8 08 00 00 00       	mov    $0x8,%eax
  8019f8:	e8 f6 fc ff ff       	call   8016f3 <fsipc>
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <evict>:

int evict(void)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801a05:	c7 04 24 0c 2e 80 00 	movl   $0x802e0c,(%esp)
  801a0c:	e8 0f e9 ff ff       	call   800320 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801a11:	ba 00 00 00 00       	mov    $0x0,%edx
  801a16:	b8 09 00 00 00       	mov    $0x9,%eax
  801a1b:	e8 d3 fc ff ff       	call   8016f3 <fsipc>
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	53                   	push   %ebx
  801a26:	83 ec 14             	sub    $0x14,%esp
  801a29:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801a2b:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a2f:	7e 31                	jle    801a62 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a31:	8b 40 04             	mov    0x4(%eax),%eax
  801a34:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a38:	8d 43 10             	lea    0x10(%ebx),%eax
  801a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3f:	8b 03                	mov    (%ebx),%eax
  801a41:	89 04 24             	mov    %eax,(%esp)
  801a44:	e8 ae fa ff ff       	call   8014f7 <write>
		if (result > 0)
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	7e 03                	jle    801a50 <writebuf+0x2e>
			b->result += result;
  801a4d:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a50:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a53:	74 0d                	je     801a62 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801a55:	85 c0                	test   %eax,%eax
  801a57:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5c:	0f 4f c2             	cmovg  %edx,%eax
  801a5f:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a62:	83 c4 14             	add    $0x14,%esp
  801a65:	5b                   	pop    %ebx
  801a66:	5d                   	pop    %ebp
  801a67:	c3                   	ret    

00801a68 <putch>:

static void
putch(int ch, void *thunk)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 04             	sub    $0x4,%esp
  801a6f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a72:	8b 53 04             	mov    0x4(%ebx),%edx
  801a75:	8d 42 01             	lea    0x1(%edx),%eax
  801a78:	89 43 04             	mov    %eax,0x4(%ebx)
  801a7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a7e:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a82:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a87:	75 0e                	jne    801a97 <putch+0x2f>
		writebuf(b);
  801a89:	89 d8                	mov    %ebx,%eax
  801a8b:	e8 92 ff ff ff       	call   801a22 <writebuf>
		b->idx = 0;
  801a90:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801a97:	83 c4 04             	add    $0x4,%esp
  801a9a:	5b                   	pop    %ebx
  801a9b:	5d                   	pop    %ebp
  801a9c:	c3                   	ret    

00801a9d <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801aaf:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801ab6:	00 00 00 
	b.result = 0;
  801ab9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ac0:	00 00 00 
	b.error = 1;
  801ac3:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801aca:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801acd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801adb:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae5:	c7 04 24 68 1a 80 00 	movl   $0x801a68,(%esp)
  801aec:	e8 83 e9 ff ff       	call   800474 <vprintfmt>
	if (b.idx > 0)
  801af1:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801af8:	7e 0b                	jle    801b05 <vfprintf+0x68>
		writebuf(&b);
  801afa:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b00:	e8 1d ff ff ff       	call   801a22 <writebuf>

	return (b.result ? b.result : b.error);
  801b05:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801b0b:	85 c0                	test   %eax,%eax
  801b0d:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b1c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b1f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b26:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	89 04 24             	mov    %eax,(%esp)
  801b30:	e8 68 ff ff ff       	call   801a9d <vfprintf>
	va_end(ap);

	return cnt;
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <printf>:

int
printf(const char *fmt, ...)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b3d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b40:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b52:	e8 46 ff ff ff       	call   801a9d <vfprintf>
	va_end(ap);

	return cnt;
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    
  801b59:	66 90                	xchg   %ax,%ax
  801b5b:	66 90                	xchg   %ax,%ax
  801b5d:	66 90                	xchg   %ax,%ax
  801b5f:	90                   	nop

00801b60 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801b66:	c7 44 24 04 25 2e 80 	movl   $0x802e25,0x4(%esp)
  801b6d:	00 
  801b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b71:	89 04 24             	mov    %eax,(%esp)
  801b74:	e8 1e ee ff ff       	call   800997 <strcpy>
	return 0;
}
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	53                   	push   %ebx
  801b84:	83 ec 14             	sub    $0x14,%esp
  801b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b8a:	89 1c 24             	mov    %ebx,(%esp)
  801b8d:	e8 15 0b 00 00       	call   8026a7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801b92:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801b97:	83 f8 01             	cmp    $0x1,%eax
  801b9a:	75 0d                	jne    801ba9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801b9c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801b9f:	89 04 24             	mov    %eax,(%esp)
  801ba2:	e8 29 03 00 00       	call   801ed0 <nsipc_close>
  801ba7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801ba9:	89 d0                	mov    %edx,%eax
  801bab:	83 c4 14             	add    $0x14,%esp
  801bae:	5b                   	pop    %ebx
  801baf:	5d                   	pop    %ebp
  801bb0:	c3                   	ret    

00801bb1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bb7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801bbe:	00 
  801bbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd3:	89 04 24             	mov    %eax,(%esp)
  801bd6:	e8 f0 03 00 00       	call   801fcb <nsipc_send>
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801be3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801bea:	00 
  801beb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bee:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bff:	89 04 24             	mov    %eax,(%esp)
  801c02:	e8 44 03 00 00       	call   801f4b <nsipc_recv>
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c0f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c12:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c16:	89 04 24             	mov    %eax,(%esp)
  801c19:	e8 68 f5 ff ff       	call   801186 <fd_lookup>
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	78 17                	js     801c39 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c25:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801c2b:	39 08                	cmp    %ecx,(%eax)
  801c2d:	75 05                	jne    801c34 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801c2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c32:	eb 05                	jmp    801c39 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801c34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	56                   	push   %esi
  801c3f:	53                   	push   %ebx
  801c40:	83 ec 20             	sub    $0x20,%esp
  801c43:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801c45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c48:	89 04 24             	mov    %eax,(%esp)
  801c4b:	e8 e7 f4 ff ff       	call   801137 <fd_alloc>
  801c50:	89 c3                	mov    %eax,%ebx
  801c52:	85 c0                	test   %eax,%eax
  801c54:	78 21                	js     801c77 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c56:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c5d:	00 
  801c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c6c:	e8 94 f1 ff ff       	call   800e05 <sys_page_alloc>
  801c71:	89 c3                	mov    %eax,%ebx
  801c73:	85 c0                	test   %eax,%eax
  801c75:	79 0c                	jns    801c83 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801c77:	89 34 24             	mov    %esi,(%esp)
  801c7a:	e8 51 02 00 00       	call   801ed0 <nsipc_close>
		return r;
  801c7f:	89 d8                	mov    %ebx,%eax
  801c81:	eb 20                	jmp    801ca3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801c83:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c91:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801c98:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801c9b:	89 14 24             	mov    %edx,(%esp)
  801c9e:	e8 6d f4 ff ff       	call   801110 <fd2num>
}
  801ca3:	83 c4 20             	add    $0x20,%esp
  801ca6:	5b                   	pop    %ebx
  801ca7:	5e                   	pop    %esi
  801ca8:	5d                   	pop    %ebp
  801ca9:	c3                   	ret    

00801caa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	e8 51 ff ff ff       	call   801c09 <fd2sockid>
		return r;
  801cb8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	78 23                	js     801ce1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cbe:	8b 55 10             	mov    0x10(%ebp),%edx
  801cc1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801cc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ccc:	89 04 24             	mov    %eax,(%esp)
  801ccf:	e8 45 01 00 00       	call   801e19 <nsipc_accept>
		return r;
  801cd4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	78 07                	js     801ce1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801cda:	e8 5c ff ff ff       	call   801c3b <alloc_sockfd>
  801cdf:	89 c1                	mov    %eax,%ecx
}
  801ce1:	89 c8                	mov    %ecx,%eax
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	e8 16 ff ff ff       	call   801c09 <fd2sockid>
  801cf3:	89 c2                	mov    %eax,%edx
  801cf5:	85 d2                	test   %edx,%edx
  801cf7:	78 16                	js     801d0f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d07:	89 14 24             	mov    %edx,(%esp)
  801d0a:	e8 60 01 00 00       	call   801e6f <nsipc_bind>
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <shutdown>:

int
shutdown(int s, int how)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	e8 ea fe ff ff       	call   801c09 <fd2sockid>
  801d1f:	89 c2                	mov    %eax,%edx
  801d21:	85 d2                	test   %edx,%edx
  801d23:	78 0f                	js     801d34 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2c:	89 14 24             	mov    %edx,(%esp)
  801d2f:	e8 7a 01 00 00       	call   801eae <nsipc_shutdown>
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	e8 c5 fe ff ff       	call   801c09 <fd2sockid>
  801d44:	89 c2                	mov    %eax,%edx
  801d46:	85 d2                	test   %edx,%edx
  801d48:	78 16                	js     801d60 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801d4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d58:	89 14 24             	mov    %edx,(%esp)
  801d5b:	e8 8a 01 00 00       	call   801eea <nsipc_connect>
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <listen>:

int
listen(int s, int backlog)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	e8 99 fe ff ff       	call   801c09 <fd2sockid>
  801d70:	89 c2                	mov    %eax,%edx
  801d72:	85 d2                	test   %edx,%edx
  801d74:	78 0f                	js     801d85 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7d:	89 14 24             	mov    %edx,(%esp)
  801d80:	e8 a4 01 00 00       	call   801f29 <nsipc_listen>
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	89 04 24             	mov    %eax,(%esp)
  801da1:	e8 98 02 00 00       	call   80203e <nsipc_socket>
  801da6:	89 c2                	mov    %eax,%edx
  801da8:	85 d2                	test   %edx,%edx
  801daa:	78 05                	js     801db1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801dac:	e8 8a fe ff ff       	call   801c3b <alloc_sockfd>
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	53                   	push   %ebx
  801db7:	83 ec 14             	sub    $0x14,%esp
  801dba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801dbc:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801dc3:	75 11                	jne    801dd6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801dc5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801dcc:	e8 9e 08 00 00       	call   80266f <ipc_find_env>
  801dd1:	a3 08 40 80 00       	mov    %eax,0x804008
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801dd6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ddd:	00 
  801dde:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801de5:	00 
  801de6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dea:	a1 08 40 80 00       	mov    0x804008,%eax
  801def:	89 04 24             	mov    %eax,(%esp)
  801df2:	e8 11 08 00 00       	call   802608 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801df7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dfe:	00 
  801dff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e06:	00 
  801e07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e0e:	e8 8d 07 00 00       	call   8025a0 <ipc_recv>
}
  801e13:	83 c4 14             	add    $0x14,%esp
  801e16:	5b                   	pop    %ebx
  801e17:	5d                   	pop    %ebp
  801e18:	c3                   	ret    

00801e19 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	56                   	push   %esi
  801e1d:	53                   	push   %ebx
  801e1e:	83 ec 10             	sub    $0x10,%esp
  801e21:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e2c:	8b 06                	mov    (%esi),%eax
  801e2e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e33:	b8 01 00 00 00       	mov    $0x1,%eax
  801e38:	e8 76 ff ff ff       	call   801db3 <nsipc>
  801e3d:	89 c3                	mov    %eax,%ebx
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	78 23                	js     801e66 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e43:	a1 10 60 80 00       	mov    0x806010,%eax
  801e48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e4c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e53:	00 
  801e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e57:	89 04 24             	mov    %eax,(%esp)
  801e5a:	e8 d5 ec ff ff       	call   800b34 <memmove>
		*addrlen = ret->ret_addrlen;
  801e5f:	a1 10 60 80 00       	mov    0x806010,%eax
  801e64:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801e66:	89 d8                	mov    %ebx,%eax
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	5b                   	pop    %ebx
  801e6c:	5e                   	pop    %esi
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    

00801e6f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	53                   	push   %ebx
  801e73:	83 ec 14             	sub    $0x14,%esp
  801e76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e8c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801e93:	e8 9c ec ff ff       	call   800b34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e98:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e9e:	b8 02 00 00 00       	mov    $0x2,%eax
  801ea3:	e8 0b ff ff ff       	call   801db3 <nsipc>
}
  801ea8:	83 c4 14             	add    $0x14,%esp
  801eab:	5b                   	pop    %ebx
  801eac:	5d                   	pop    %ebp
  801ead:	c3                   	ret    

00801eae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ec4:	b8 03 00 00 00       	mov    $0x3,%eax
  801ec9:	e8 e5 fe ff ff       	call   801db3 <nsipc>
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <nsipc_close>:

int
nsipc_close(int s)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ede:	b8 04 00 00 00       	mov    $0x4,%eax
  801ee3:	e8 cb fe ff ff       	call   801db3 <nsipc>
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	53                   	push   %ebx
  801eee:	83 ec 14             	sub    $0x14,%esp
  801ef1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801efc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f07:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801f0e:	e8 21 ec ff ff       	call   800b34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f13:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f19:	b8 05 00 00 00       	mov    $0x5,%eax
  801f1e:	e8 90 fe ff ff       	call   801db3 <nsipc>
}
  801f23:	83 c4 14             	add    $0x14,%esp
  801f26:	5b                   	pop    %ebx
  801f27:	5d                   	pop    %ebp
  801f28:	c3                   	ret    

00801f29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f3f:	b8 06 00 00 00       	mov    $0x6,%eax
  801f44:	e8 6a fe ff ff       	call   801db3 <nsipc>
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	56                   	push   %esi
  801f4f:	53                   	push   %ebx
  801f50:	83 ec 10             	sub    $0x10,%esp
  801f53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f5e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f64:	8b 45 14             	mov    0x14(%ebp),%eax
  801f67:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f6c:	b8 07 00 00 00       	mov    $0x7,%eax
  801f71:	e8 3d fe ff ff       	call   801db3 <nsipc>
  801f76:	89 c3                	mov    %eax,%ebx
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	78 46                	js     801fc2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801f7c:	39 f0                	cmp    %esi,%eax
  801f7e:	7f 07                	jg     801f87 <nsipc_recv+0x3c>
  801f80:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f85:	7e 24                	jle    801fab <nsipc_recv+0x60>
  801f87:	c7 44 24 0c 31 2e 80 	movl   $0x802e31,0xc(%esp)
  801f8e:	00 
  801f8f:	c7 44 24 08 e0 2d 80 	movl   $0x802de0,0x8(%esp)
  801f96:	00 
  801f97:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801f9e:	00 
  801f9f:	c7 04 24 46 2e 80 00 	movl   $0x802e46,(%esp)
  801fa6:	e8 7c e2 ff ff       	call   800227 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801fab:	89 44 24 08          	mov    %eax,0x8(%esp)
  801faf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fb6:	00 
  801fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fba:	89 04 24             	mov    %eax,(%esp)
  801fbd:	e8 72 eb ff ff       	call   800b34 <memmove>
	}

	return r;
}
  801fc2:	89 d8                	mov    %ebx,%eax
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	5b                   	pop    %ebx
  801fc8:	5e                   	pop    %esi
  801fc9:	5d                   	pop    %ebp
  801fca:	c3                   	ret    

00801fcb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	53                   	push   %ebx
  801fcf:	83 ec 14             	sub    $0x14,%esp
  801fd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801fdd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fe3:	7e 24                	jle    802009 <nsipc_send+0x3e>
  801fe5:	c7 44 24 0c 52 2e 80 	movl   $0x802e52,0xc(%esp)
  801fec:	00 
  801fed:	c7 44 24 08 e0 2d 80 	movl   $0x802de0,0x8(%esp)
  801ff4:	00 
  801ff5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801ffc:	00 
  801ffd:	c7 04 24 46 2e 80 00 	movl   $0x802e46,(%esp)
  802004:	e8 1e e2 ff ff       	call   800227 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802009:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80200d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802010:	89 44 24 04          	mov    %eax,0x4(%esp)
  802014:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80201b:	e8 14 eb ff ff       	call   800b34 <memmove>
	nsipcbuf.send.req_size = size;
  802020:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802026:	8b 45 14             	mov    0x14(%ebp),%eax
  802029:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80202e:	b8 08 00 00 00       	mov    $0x8,%eax
  802033:	e8 7b fd ff ff       	call   801db3 <nsipc>
}
  802038:	83 c4 14             	add    $0x14,%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5d                   	pop    %ebp
  80203d:	c3                   	ret    

0080203e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80204c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802054:	8b 45 10             	mov    0x10(%ebp),%eax
  802057:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80205c:	b8 09 00 00 00       	mov    $0x9,%eax
  802061:	e8 4d fd ff ff       	call   801db3 <nsipc>
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	56                   	push   %esi
  80206c:	53                   	push   %ebx
  80206d:	83 ec 10             	sub    $0x10,%esp
  802070:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	89 04 24             	mov    %eax,(%esp)
  802079:	e8 a2 f0 ff ff       	call   801120 <fd2data>
  80207e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802080:	c7 44 24 04 5e 2e 80 	movl   $0x802e5e,0x4(%esp)
  802087:	00 
  802088:	89 1c 24             	mov    %ebx,(%esp)
  80208b:	e8 07 e9 ff ff       	call   800997 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802090:	8b 46 04             	mov    0x4(%esi),%eax
  802093:	2b 06                	sub    (%esi),%eax
  802095:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80209b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020a2:	00 00 00 
	stat->st_dev = &devpipe;
  8020a5:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  8020ac:	30 80 00 
	return 0;
}
  8020af:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	5b                   	pop    %ebx
  8020b8:	5e                   	pop    %esi
  8020b9:	5d                   	pop    %ebp
  8020ba:	c3                   	ret    

008020bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	53                   	push   %ebx
  8020bf:	83 ec 14             	sub    $0x14,%esp
  8020c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d0:	e8 d7 ed ff ff       	call   800eac <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020d5:	89 1c 24             	mov    %ebx,(%esp)
  8020d8:	e8 43 f0 ff ff       	call   801120 <fd2data>
  8020dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e8:	e8 bf ed ff ff       	call   800eac <sys_page_unmap>
}
  8020ed:	83 c4 14             	add    $0x14,%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5d                   	pop    %ebp
  8020f2:	c3                   	ret    

008020f3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	57                   	push   %edi
  8020f7:	56                   	push   %esi
  8020f8:	53                   	push   %ebx
  8020f9:	83 ec 2c             	sub    $0x2c,%esp
  8020fc:	89 c6                	mov    %eax,%esi
  8020fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802101:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802106:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802109:	89 34 24             	mov    %esi,(%esp)
  80210c:	e8 96 05 00 00       	call   8026a7 <pageref>
  802111:	89 c7                	mov    %eax,%edi
  802113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802116:	89 04 24             	mov    %eax,(%esp)
  802119:	e8 89 05 00 00       	call   8026a7 <pageref>
  80211e:	39 c7                	cmp    %eax,%edi
  802120:	0f 94 c2             	sete   %dl
  802123:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802126:	8b 0d 0c 40 80 00    	mov    0x80400c,%ecx
  80212c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80212f:	39 fb                	cmp    %edi,%ebx
  802131:	74 21                	je     802154 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802133:	84 d2                	test   %dl,%dl
  802135:	74 ca                	je     802101 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802137:	8b 51 58             	mov    0x58(%ecx),%edx
  80213a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80213e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802142:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802146:	c7 04 24 65 2e 80 00 	movl   $0x802e65,(%esp)
  80214d:	e8 ce e1 ff ff       	call   800320 <cprintf>
  802152:	eb ad                	jmp    802101 <_pipeisclosed+0xe>
	}
}
  802154:	83 c4 2c             	add    $0x2c,%esp
  802157:	5b                   	pop    %ebx
  802158:	5e                   	pop    %esi
  802159:	5f                   	pop    %edi
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    

0080215c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	57                   	push   %edi
  802160:	56                   	push   %esi
  802161:	53                   	push   %ebx
  802162:	83 ec 1c             	sub    $0x1c,%esp
  802165:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802168:	89 34 24             	mov    %esi,(%esp)
  80216b:	e8 b0 ef ff ff       	call   801120 <fd2data>
  802170:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802172:	bf 00 00 00 00       	mov    $0x0,%edi
  802177:	eb 45                	jmp    8021be <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802179:	89 da                	mov    %ebx,%edx
  80217b:	89 f0                	mov    %esi,%eax
  80217d:	e8 71 ff ff ff       	call   8020f3 <_pipeisclosed>
  802182:	85 c0                	test   %eax,%eax
  802184:	75 41                	jne    8021c7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802186:	e8 5b ec ff ff       	call   800de6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80218b:	8b 43 04             	mov    0x4(%ebx),%eax
  80218e:	8b 0b                	mov    (%ebx),%ecx
  802190:	8d 51 20             	lea    0x20(%ecx),%edx
  802193:	39 d0                	cmp    %edx,%eax
  802195:	73 e2                	jae    802179 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80219a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80219e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021a1:	99                   	cltd   
  8021a2:	c1 ea 1b             	shr    $0x1b,%edx
  8021a5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8021a8:	83 e1 1f             	and    $0x1f,%ecx
  8021ab:	29 d1                	sub    %edx,%ecx
  8021ad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8021b1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8021b5:	83 c0 01             	add    $0x1,%eax
  8021b8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021bb:	83 c7 01             	add    $0x1,%edi
  8021be:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021c1:	75 c8                	jne    80218b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8021c3:	89 f8                	mov    %edi,%eax
  8021c5:	eb 05                	jmp    8021cc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021c7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8021cc:	83 c4 1c             	add    $0x1c,%esp
  8021cf:	5b                   	pop    %ebx
  8021d0:	5e                   	pop    %esi
  8021d1:	5f                   	pop    %edi
  8021d2:	5d                   	pop    %ebp
  8021d3:	c3                   	ret    

008021d4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	57                   	push   %edi
  8021d8:	56                   	push   %esi
  8021d9:	53                   	push   %ebx
  8021da:	83 ec 1c             	sub    $0x1c,%esp
  8021dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8021e0:	89 3c 24             	mov    %edi,(%esp)
  8021e3:	e8 38 ef ff ff       	call   801120 <fd2data>
  8021e8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021ea:	be 00 00 00 00       	mov    $0x0,%esi
  8021ef:	eb 3d                	jmp    80222e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021f1:	85 f6                	test   %esi,%esi
  8021f3:	74 04                	je     8021f9 <devpipe_read+0x25>
				return i;
  8021f5:	89 f0                	mov    %esi,%eax
  8021f7:	eb 43                	jmp    80223c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021f9:	89 da                	mov    %ebx,%edx
  8021fb:	89 f8                	mov    %edi,%eax
  8021fd:	e8 f1 fe ff ff       	call   8020f3 <_pipeisclosed>
  802202:	85 c0                	test   %eax,%eax
  802204:	75 31                	jne    802237 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802206:	e8 db eb ff ff       	call   800de6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80220b:	8b 03                	mov    (%ebx),%eax
  80220d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802210:	74 df                	je     8021f1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802212:	99                   	cltd   
  802213:	c1 ea 1b             	shr    $0x1b,%edx
  802216:	01 d0                	add    %edx,%eax
  802218:	83 e0 1f             	and    $0x1f,%eax
  80221b:	29 d0                	sub    %edx,%eax
  80221d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802222:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802225:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802228:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80222b:	83 c6 01             	add    $0x1,%esi
  80222e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802231:	75 d8                	jne    80220b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802233:	89 f0                	mov    %esi,%eax
  802235:	eb 05                	jmp    80223c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802237:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80223c:	83 c4 1c             	add    $0x1c,%esp
  80223f:	5b                   	pop    %ebx
  802240:	5e                   	pop    %esi
  802241:	5f                   	pop    %edi
  802242:	5d                   	pop    %ebp
  802243:	c3                   	ret    

00802244 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	56                   	push   %esi
  802248:	53                   	push   %ebx
  802249:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80224c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80224f:	89 04 24             	mov    %eax,(%esp)
  802252:	e8 e0 ee ff ff       	call   801137 <fd_alloc>
  802257:	89 c2                	mov    %eax,%edx
  802259:	85 d2                	test   %edx,%edx
  80225b:	0f 88 4d 01 00 00    	js     8023ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802261:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802268:	00 
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802277:	e8 89 eb ff ff       	call   800e05 <sys_page_alloc>
  80227c:	89 c2                	mov    %eax,%edx
  80227e:	85 d2                	test   %edx,%edx
  802280:	0f 88 28 01 00 00    	js     8023ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802286:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802289:	89 04 24             	mov    %eax,(%esp)
  80228c:	e8 a6 ee ff ff       	call   801137 <fd_alloc>
  802291:	89 c3                	mov    %eax,%ebx
  802293:	85 c0                	test   %eax,%eax
  802295:	0f 88 fe 00 00 00    	js     802399 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80229b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022a2:	00 
  8022a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b1:	e8 4f eb ff ff       	call   800e05 <sys_page_alloc>
  8022b6:	89 c3                	mov    %eax,%ebx
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	0f 88 d9 00 00 00    	js     802399 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	89 04 24             	mov    %eax,(%esp)
  8022c6:	e8 55 ee ff ff       	call   801120 <fd2data>
  8022cb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022cd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022d4:	00 
  8022d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e0:	e8 20 eb ff ff       	call   800e05 <sys_page_alloc>
  8022e5:	89 c3                	mov    %eax,%ebx
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	0f 88 97 00 00 00    	js     802386 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f2:	89 04 24             	mov    %eax,(%esp)
  8022f5:	e8 26 ee ff ff       	call   801120 <fd2data>
  8022fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802301:	00 
  802302:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802306:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80230d:	00 
  80230e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802312:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802319:	e8 3b eb ff ff       	call   800e59 <sys_page_map>
  80231e:	89 c3                	mov    %eax,%ebx
  802320:	85 c0                	test   %eax,%eax
  802322:	78 52                	js     802376 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802324:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802339:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80233f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802342:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802347:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	89 04 24             	mov    %eax,(%esp)
  802354:	e8 b7 ed ff ff       	call   801110 <fd2num>
  802359:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80235c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80235e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802361:	89 04 24             	mov    %eax,(%esp)
  802364:	e8 a7 ed ff ff       	call   801110 <fd2num>
  802369:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80236c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
  802374:	eb 38                	jmp    8023ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802376:	89 74 24 04          	mov    %esi,0x4(%esp)
  80237a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802381:	e8 26 eb ff ff       	call   800eac <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802389:	89 44 24 04          	mov    %eax,0x4(%esp)
  80238d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802394:	e8 13 eb ff ff       	call   800eac <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023a7:	e8 00 eb ff ff       	call   800eac <sys_page_unmap>
  8023ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8023ae:	83 c4 30             	add    $0x30,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5d                   	pop    %ebp
  8023b4:	c3                   	ret    

008023b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
  8023b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	89 04 24             	mov    %eax,(%esp)
  8023c8:	e8 b9 ed ff ff       	call   801186 <fd_lookup>
  8023cd:	89 c2                	mov    %eax,%edx
  8023cf:	85 d2                	test   %edx,%edx
  8023d1:	78 15                	js     8023e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	89 04 24             	mov    %eax,(%esp)
  8023d9:	e8 42 ed ff ff       	call   801120 <fd2data>
	return _pipeisclosed(fd, p);
  8023de:	89 c2                	mov    %eax,%edx
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	e8 0b fd ff ff       	call   8020f3 <_pipeisclosed>
}
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    
  8023ea:	66 90                	xchg   %ax,%ax
  8023ec:	66 90                	xchg   %ax,%ax
  8023ee:	66 90                	xchg   %ax,%ax

008023f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8023f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f8:	5d                   	pop    %ebp
  8023f9:	c3                   	ret    

008023fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802400:	c7 44 24 04 7d 2e 80 	movl   $0x802e7d,0x4(%esp)
  802407:	00 
  802408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240b:	89 04 24             	mov    %eax,(%esp)
  80240e:	e8 84 e5 ff ff       	call   800997 <strcpy>
	return 0;
}
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	57                   	push   %edi
  80241e:	56                   	push   %esi
  80241f:	53                   	push   %ebx
  802420:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802426:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80242b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802431:	eb 31                	jmp    802464 <devcons_write+0x4a>
		m = n - tot;
  802433:	8b 75 10             	mov    0x10(%ebp),%esi
  802436:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802438:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80243b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802440:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802443:	89 74 24 08          	mov    %esi,0x8(%esp)
  802447:	03 45 0c             	add    0xc(%ebp),%eax
  80244a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80244e:	89 3c 24             	mov    %edi,(%esp)
  802451:	e8 de e6 ff ff       	call   800b34 <memmove>
		sys_cputs(buf, m);
  802456:	89 74 24 04          	mov    %esi,0x4(%esp)
  80245a:	89 3c 24             	mov    %edi,(%esp)
  80245d:	e8 84 e8 ff ff       	call   800ce6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802462:	01 f3                	add    %esi,%ebx
  802464:	89 d8                	mov    %ebx,%eax
  802466:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802469:	72 c8                	jb     802433 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80246b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802471:	5b                   	pop    %ebx
  802472:	5e                   	pop    %esi
  802473:	5f                   	pop    %edi
  802474:	5d                   	pop    %ebp
  802475:	c3                   	ret    

00802476 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
  802479:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802481:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802485:	75 07                	jne    80248e <devcons_read+0x18>
  802487:	eb 2a                	jmp    8024b3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802489:	e8 58 e9 ff ff       	call   800de6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80248e:	66 90                	xchg   %ax,%ax
  802490:	e8 6f e8 ff ff       	call   800d04 <sys_cgetc>
  802495:	85 c0                	test   %eax,%eax
  802497:	74 f0                	je     802489 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802499:	85 c0                	test   %eax,%eax
  80249b:	78 16                	js     8024b3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80249d:	83 f8 04             	cmp    $0x4,%eax
  8024a0:	74 0c                	je     8024ae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8024a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a5:	88 02                	mov    %al,(%edx)
	return 1;
  8024a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ac:	eb 05                	jmp    8024b3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8024ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8024c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8024c8:	00 
  8024c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024cc:	89 04 24             	mov    %eax,(%esp)
  8024cf:	e8 12 e8 ff ff       	call   800ce6 <sys_cputs>
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <getchar>:

int
getchar(void)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8024dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8024e3:	00 
  8024e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024f2:	e8 23 ef ff ff       	call   80141a <read>
	if (r < 0)
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	78 0f                	js     80250a <getchar+0x34>
		return r;
	if (r < 1)
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	7e 06                	jle    802505 <getchar+0x2f>
		return -E_EOF;
	return c;
  8024ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802503:	eb 05                	jmp    80250a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802505:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802512:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802515:	89 44 24 04          	mov    %eax,0x4(%esp)
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	89 04 24             	mov    %eax,(%esp)
  80251f:	e8 62 ec ff ff       	call   801186 <fd_lookup>
  802524:	85 c0                	test   %eax,%eax
  802526:	78 11                	js     802539 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802531:	39 10                	cmp    %edx,(%eax)
  802533:	0f 94 c0             	sete   %al
  802536:	0f b6 c0             	movzbl %al,%eax
}
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <opencons>:

int
opencons(void)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802541:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802544:	89 04 24             	mov    %eax,(%esp)
  802547:	e8 eb eb ff ff       	call   801137 <fd_alloc>
		return r;
  80254c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80254e:	85 c0                	test   %eax,%eax
  802550:	78 40                	js     802592 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802552:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802559:	00 
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802561:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802568:	e8 98 e8 ff ff       	call   800e05 <sys_page_alloc>
		return r;
  80256d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80256f:	85 c0                	test   %eax,%eax
  802571:	78 1f                	js     802592 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802573:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802588:	89 04 24             	mov    %eax,(%esp)
  80258b:	e8 80 eb ff ff       	call   801110 <fd2num>
  802590:	89 c2                	mov    %eax,%edx
}
  802592:	89 d0                	mov    %edx,%eax
  802594:	c9                   	leave  
  802595:	c3                   	ret    
  802596:	66 90                	xchg   %ax,%ax
  802598:	66 90                	xchg   %ax,%ax
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	66 90                	xchg   %ax,%ax
  80259e:	66 90                	xchg   %ax,%ax

008025a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
  8025a3:	56                   	push   %esi
  8025a4:	53                   	push   %ebx
  8025a5:	83 ec 10             	sub    $0x10,%esp
  8025a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8025ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8025b1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8025b3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8025b8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8025bb:	89 04 24             	mov    %eax,(%esp)
  8025be:	e8 78 ea ff ff       	call   80103b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8025c3:	85 c0                	test   %eax,%eax
  8025c5:	75 26                	jne    8025ed <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8025c7:	85 f6                	test   %esi,%esi
  8025c9:	74 0a                	je     8025d5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8025cb:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8025d0:	8b 40 74             	mov    0x74(%eax),%eax
  8025d3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  8025d5:	85 db                	test   %ebx,%ebx
  8025d7:	74 0a                	je     8025e3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  8025d9:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8025de:	8b 40 78             	mov    0x78(%eax),%eax
  8025e1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8025e3:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8025e8:	8b 40 70             	mov    0x70(%eax),%eax
  8025eb:	eb 14                	jmp    802601 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  8025ed:	85 f6                	test   %esi,%esi
  8025ef:	74 06                	je     8025f7 <ipc_recv+0x57>
			*from_env_store = 0;
  8025f1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8025f7:	85 db                	test   %ebx,%ebx
  8025f9:	74 06                	je     802601 <ipc_recv+0x61>
			*perm_store = 0;
  8025fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802601:	83 c4 10             	add    $0x10,%esp
  802604:	5b                   	pop    %ebx
  802605:	5e                   	pop    %esi
  802606:	5d                   	pop    %ebp
  802607:	c3                   	ret    

00802608 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
  80260b:	57                   	push   %edi
  80260c:	56                   	push   %esi
  80260d:	53                   	push   %ebx
  80260e:	83 ec 1c             	sub    $0x1c,%esp
  802611:	8b 7d 08             	mov    0x8(%ebp),%edi
  802614:	8b 75 0c             	mov    0xc(%ebp),%esi
  802617:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80261a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80261c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802621:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802624:	8b 45 14             	mov    0x14(%ebp),%eax
  802627:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80262b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80262f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802633:	89 3c 24             	mov    %edi,(%esp)
  802636:	e8 dd e9 ff ff       	call   801018 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80263b:	85 c0                	test   %eax,%eax
  80263d:	74 28                	je     802667 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80263f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802642:	74 1c                	je     802660 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802644:	c7 44 24 08 8c 2e 80 	movl   $0x802e8c,0x8(%esp)
  80264b:	00 
  80264c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802653:	00 
  802654:	c7 04 24 b0 2e 80 00 	movl   $0x802eb0,(%esp)
  80265b:	e8 c7 db ff ff       	call   800227 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802660:	e8 81 e7 ff ff       	call   800de6 <sys_yield>
	}
  802665:	eb bd                	jmp    802624 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802667:	83 c4 1c             	add    $0x1c,%esp
  80266a:	5b                   	pop    %ebx
  80266b:	5e                   	pop    %esi
  80266c:	5f                   	pop    %edi
  80266d:	5d                   	pop    %ebp
  80266e:	c3                   	ret    

0080266f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80266f:	55                   	push   %ebp
  802670:	89 e5                	mov    %esp,%ebp
  802672:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802675:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80267a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80267d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802683:	8b 52 50             	mov    0x50(%edx),%edx
  802686:	39 ca                	cmp    %ecx,%edx
  802688:	75 0d                	jne    802697 <ipc_find_env+0x28>
			return envs[i].env_id;
  80268a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80268d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802692:	8b 40 40             	mov    0x40(%eax),%eax
  802695:	eb 0e                	jmp    8026a5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802697:	83 c0 01             	add    $0x1,%eax
  80269a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80269f:	75 d9                	jne    80267a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8026a1:	66 b8 00 00          	mov    $0x0,%ax
}
  8026a5:	5d                   	pop    %ebp
  8026a6:	c3                   	ret    

008026a7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
  8026aa:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026ad:	89 d0                	mov    %edx,%eax
  8026af:	c1 e8 16             	shr    $0x16,%eax
  8026b2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026be:	f6 c1 01             	test   $0x1,%cl
  8026c1:	74 1d                	je     8026e0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8026c3:	c1 ea 0c             	shr    $0xc,%edx
  8026c6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8026cd:	f6 c2 01             	test   $0x1,%dl
  8026d0:	74 0e                	je     8026e0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026d2:	c1 ea 0c             	shr    $0xc,%edx
  8026d5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8026dc:	ef 
  8026dd:	0f b7 c0             	movzwl %ax,%eax
}
  8026e0:	5d                   	pop    %ebp
  8026e1:	c3                   	ret    
  8026e2:	66 90                	xchg   %ax,%ax
  8026e4:	66 90                	xchg   %ax,%ax
  8026e6:	66 90                	xchg   %ax,%ax
  8026e8:	66 90                	xchg   %ax,%ax
  8026ea:	66 90                	xchg   %ax,%ax
  8026ec:	66 90                	xchg   %ax,%ax
  8026ee:	66 90                	xchg   %ax,%ax

008026f0 <__udivdi3>:
  8026f0:	55                   	push   %ebp
  8026f1:	57                   	push   %edi
  8026f2:	56                   	push   %esi
  8026f3:	83 ec 0c             	sub    $0xc,%esp
  8026f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8026fa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8026fe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802702:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802706:	85 c0                	test   %eax,%eax
  802708:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80270c:	89 ea                	mov    %ebp,%edx
  80270e:	89 0c 24             	mov    %ecx,(%esp)
  802711:	75 2d                	jne    802740 <__udivdi3+0x50>
  802713:	39 e9                	cmp    %ebp,%ecx
  802715:	77 61                	ja     802778 <__udivdi3+0x88>
  802717:	85 c9                	test   %ecx,%ecx
  802719:	89 ce                	mov    %ecx,%esi
  80271b:	75 0b                	jne    802728 <__udivdi3+0x38>
  80271d:	b8 01 00 00 00       	mov    $0x1,%eax
  802722:	31 d2                	xor    %edx,%edx
  802724:	f7 f1                	div    %ecx
  802726:	89 c6                	mov    %eax,%esi
  802728:	31 d2                	xor    %edx,%edx
  80272a:	89 e8                	mov    %ebp,%eax
  80272c:	f7 f6                	div    %esi
  80272e:	89 c5                	mov    %eax,%ebp
  802730:	89 f8                	mov    %edi,%eax
  802732:	f7 f6                	div    %esi
  802734:	89 ea                	mov    %ebp,%edx
  802736:	83 c4 0c             	add    $0xc,%esp
  802739:	5e                   	pop    %esi
  80273a:	5f                   	pop    %edi
  80273b:	5d                   	pop    %ebp
  80273c:	c3                   	ret    
  80273d:	8d 76 00             	lea    0x0(%esi),%esi
  802740:	39 e8                	cmp    %ebp,%eax
  802742:	77 24                	ja     802768 <__udivdi3+0x78>
  802744:	0f bd e8             	bsr    %eax,%ebp
  802747:	83 f5 1f             	xor    $0x1f,%ebp
  80274a:	75 3c                	jne    802788 <__udivdi3+0x98>
  80274c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802750:	39 34 24             	cmp    %esi,(%esp)
  802753:	0f 86 9f 00 00 00    	jbe    8027f8 <__udivdi3+0x108>
  802759:	39 d0                	cmp    %edx,%eax
  80275b:	0f 82 97 00 00 00    	jb     8027f8 <__udivdi3+0x108>
  802761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802768:	31 d2                	xor    %edx,%edx
  80276a:	31 c0                	xor    %eax,%eax
  80276c:	83 c4 0c             	add    $0xc,%esp
  80276f:	5e                   	pop    %esi
  802770:	5f                   	pop    %edi
  802771:	5d                   	pop    %ebp
  802772:	c3                   	ret    
  802773:	90                   	nop
  802774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802778:	89 f8                	mov    %edi,%eax
  80277a:	f7 f1                	div    %ecx
  80277c:	31 d2                	xor    %edx,%edx
  80277e:	83 c4 0c             	add    $0xc,%esp
  802781:	5e                   	pop    %esi
  802782:	5f                   	pop    %edi
  802783:	5d                   	pop    %ebp
  802784:	c3                   	ret    
  802785:	8d 76 00             	lea    0x0(%esi),%esi
  802788:	89 e9                	mov    %ebp,%ecx
  80278a:	8b 3c 24             	mov    (%esp),%edi
  80278d:	d3 e0                	shl    %cl,%eax
  80278f:	89 c6                	mov    %eax,%esi
  802791:	b8 20 00 00 00       	mov    $0x20,%eax
  802796:	29 e8                	sub    %ebp,%eax
  802798:	89 c1                	mov    %eax,%ecx
  80279a:	d3 ef                	shr    %cl,%edi
  80279c:	89 e9                	mov    %ebp,%ecx
  80279e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8027a2:	8b 3c 24             	mov    (%esp),%edi
  8027a5:	09 74 24 08          	or     %esi,0x8(%esp)
  8027a9:	89 d6                	mov    %edx,%esi
  8027ab:	d3 e7                	shl    %cl,%edi
  8027ad:	89 c1                	mov    %eax,%ecx
  8027af:	89 3c 24             	mov    %edi,(%esp)
  8027b2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8027b6:	d3 ee                	shr    %cl,%esi
  8027b8:	89 e9                	mov    %ebp,%ecx
  8027ba:	d3 e2                	shl    %cl,%edx
  8027bc:	89 c1                	mov    %eax,%ecx
  8027be:	d3 ef                	shr    %cl,%edi
  8027c0:	09 d7                	or     %edx,%edi
  8027c2:	89 f2                	mov    %esi,%edx
  8027c4:	89 f8                	mov    %edi,%eax
  8027c6:	f7 74 24 08          	divl   0x8(%esp)
  8027ca:	89 d6                	mov    %edx,%esi
  8027cc:	89 c7                	mov    %eax,%edi
  8027ce:	f7 24 24             	mull   (%esp)
  8027d1:	39 d6                	cmp    %edx,%esi
  8027d3:	89 14 24             	mov    %edx,(%esp)
  8027d6:	72 30                	jb     802808 <__udivdi3+0x118>
  8027d8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027dc:	89 e9                	mov    %ebp,%ecx
  8027de:	d3 e2                	shl    %cl,%edx
  8027e0:	39 c2                	cmp    %eax,%edx
  8027e2:	73 05                	jae    8027e9 <__udivdi3+0xf9>
  8027e4:	3b 34 24             	cmp    (%esp),%esi
  8027e7:	74 1f                	je     802808 <__udivdi3+0x118>
  8027e9:	89 f8                	mov    %edi,%eax
  8027eb:	31 d2                	xor    %edx,%edx
  8027ed:	e9 7a ff ff ff       	jmp    80276c <__udivdi3+0x7c>
  8027f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027f8:	31 d2                	xor    %edx,%edx
  8027fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ff:	e9 68 ff ff ff       	jmp    80276c <__udivdi3+0x7c>
  802804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802808:	8d 47 ff             	lea    -0x1(%edi),%eax
  80280b:	31 d2                	xor    %edx,%edx
  80280d:	83 c4 0c             	add    $0xc,%esp
  802810:	5e                   	pop    %esi
  802811:	5f                   	pop    %edi
  802812:	5d                   	pop    %ebp
  802813:	c3                   	ret    
  802814:	66 90                	xchg   %ax,%ax
  802816:	66 90                	xchg   %ax,%ax
  802818:	66 90                	xchg   %ax,%ax
  80281a:	66 90                	xchg   %ax,%ax
  80281c:	66 90                	xchg   %ax,%ax
  80281e:	66 90                	xchg   %ax,%ax

00802820 <__umoddi3>:
  802820:	55                   	push   %ebp
  802821:	57                   	push   %edi
  802822:	56                   	push   %esi
  802823:	83 ec 14             	sub    $0x14,%esp
  802826:	8b 44 24 28          	mov    0x28(%esp),%eax
  80282a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80282e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802832:	89 c7                	mov    %eax,%edi
  802834:	89 44 24 04          	mov    %eax,0x4(%esp)
  802838:	8b 44 24 30          	mov    0x30(%esp),%eax
  80283c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802840:	89 34 24             	mov    %esi,(%esp)
  802843:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802847:	85 c0                	test   %eax,%eax
  802849:	89 c2                	mov    %eax,%edx
  80284b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80284f:	75 17                	jne    802868 <__umoddi3+0x48>
  802851:	39 fe                	cmp    %edi,%esi
  802853:	76 4b                	jbe    8028a0 <__umoddi3+0x80>
  802855:	89 c8                	mov    %ecx,%eax
  802857:	89 fa                	mov    %edi,%edx
  802859:	f7 f6                	div    %esi
  80285b:	89 d0                	mov    %edx,%eax
  80285d:	31 d2                	xor    %edx,%edx
  80285f:	83 c4 14             	add    $0x14,%esp
  802862:	5e                   	pop    %esi
  802863:	5f                   	pop    %edi
  802864:	5d                   	pop    %ebp
  802865:	c3                   	ret    
  802866:	66 90                	xchg   %ax,%ax
  802868:	39 f8                	cmp    %edi,%eax
  80286a:	77 54                	ja     8028c0 <__umoddi3+0xa0>
  80286c:	0f bd e8             	bsr    %eax,%ebp
  80286f:	83 f5 1f             	xor    $0x1f,%ebp
  802872:	75 5c                	jne    8028d0 <__umoddi3+0xb0>
  802874:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802878:	39 3c 24             	cmp    %edi,(%esp)
  80287b:	0f 87 e7 00 00 00    	ja     802968 <__umoddi3+0x148>
  802881:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802885:	29 f1                	sub    %esi,%ecx
  802887:	19 c7                	sbb    %eax,%edi
  802889:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80288d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802891:	8b 44 24 08          	mov    0x8(%esp),%eax
  802895:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802899:	83 c4 14             	add    $0x14,%esp
  80289c:	5e                   	pop    %esi
  80289d:	5f                   	pop    %edi
  80289e:	5d                   	pop    %ebp
  80289f:	c3                   	ret    
  8028a0:	85 f6                	test   %esi,%esi
  8028a2:	89 f5                	mov    %esi,%ebp
  8028a4:	75 0b                	jne    8028b1 <__umoddi3+0x91>
  8028a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ab:	31 d2                	xor    %edx,%edx
  8028ad:	f7 f6                	div    %esi
  8028af:	89 c5                	mov    %eax,%ebp
  8028b1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028b5:	31 d2                	xor    %edx,%edx
  8028b7:	f7 f5                	div    %ebp
  8028b9:	89 c8                	mov    %ecx,%eax
  8028bb:	f7 f5                	div    %ebp
  8028bd:	eb 9c                	jmp    80285b <__umoddi3+0x3b>
  8028bf:	90                   	nop
  8028c0:	89 c8                	mov    %ecx,%eax
  8028c2:	89 fa                	mov    %edi,%edx
  8028c4:	83 c4 14             	add    $0x14,%esp
  8028c7:	5e                   	pop    %esi
  8028c8:	5f                   	pop    %edi
  8028c9:	5d                   	pop    %ebp
  8028ca:	c3                   	ret    
  8028cb:	90                   	nop
  8028cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028d0:	8b 04 24             	mov    (%esp),%eax
  8028d3:	be 20 00 00 00       	mov    $0x20,%esi
  8028d8:	89 e9                	mov    %ebp,%ecx
  8028da:	29 ee                	sub    %ebp,%esi
  8028dc:	d3 e2                	shl    %cl,%edx
  8028de:	89 f1                	mov    %esi,%ecx
  8028e0:	d3 e8                	shr    %cl,%eax
  8028e2:	89 e9                	mov    %ebp,%ecx
  8028e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e8:	8b 04 24             	mov    (%esp),%eax
  8028eb:	09 54 24 04          	or     %edx,0x4(%esp)
  8028ef:	89 fa                	mov    %edi,%edx
  8028f1:	d3 e0                	shl    %cl,%eax
  8028f3:	89 f1                	mov    %esi,%ecx
  8028f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028f9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8028fd:	d3 ea                	shr    %cl,%edx
  8028ff:	89 e9                	mov    %ebp,%ecx
  802901:	d3 e7                	shl    %cl,%edi
  802903:	89 f1                	mov    %esi,%ecx
  802905:	d3 e8                	shr    %cl,%eax
  802907:	89 e9                	mov    %ebp,%ecx
  802909:	09 f8                	or     %edi,%eax
  80290b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80290f:	f7 74 24 04          	divl   0x4(%esp)
  802913:	d3 e7                	shl    %cl,%edi
  802915:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802919:	89 d7                	mov    %edx,%edi
  80291b:	f7 64 24 08          	mull   0x8(%esp)
  80291f:	39 d7                	cmp    %edx,%edi
  802921:	89 c1                	mov    %eax,%ecx
  802923:	89 14 24             	mov    %edx,(%esp)
  802926:	72 2c                	jb     802954 <__umoddi3+0x134>
  802928:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80292c:	72 22                	jb     802950 <__umoddi3+0x130>
  80292e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802932:	29 c8                	sub    %ecx,%eax
  802934:	19 d7                	sbb    %edx,%edi
  802936:	89 e9                	mov    %ebp,%ecx
  802938:	89 fa                	mov    %edi,%edx
  80293a:	d3 e8                	shr    %cl,%eax
  80293c:	89 f1                	mov    %esi,%ecx
  80293e:	d3 e2                	shl    %cl,%edx
  802940:	89 e9                	mov    %ebp,%ecx
  802942:	d3 ef                	shr    %cl,%edi
  802944:	09 d0                	or     %edx,%eax
  802946:	89 fa                	mov    %edi,%edx
  802948:	83 c4 14             	add    $0x14,%esp
  80294b:	5e                   	pop    %esi
  80294c:	5f                   	pop    %edi
  80294d:	5d                   	pop    %ebp
  80294e:	c3                   	ret    
  80294f:	90                   	nop
  802950:	39 d7                	cmp    %edx,%edi
  802952:	75 da                	jne    80292e <__umoddi3+0x10e>
  802954:	8b 14 24             	mov    (%esp),%edx
  802957:	89 c1                	mov    %eax,%ecx
  802959:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80295d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802961:	eb cb                	jmp    80292e <__umoddi3+0x10e>
  802963:	90                   	nop
  802964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802968:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80296c:	0f 82 0f ff ff ff    	jb     802881 <__umoddi3+0x61>
  802972:	e9 1a ff ff ff       	jmp    802891 <__umoddi3+0x71>
