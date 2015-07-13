
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 34 01 00 00       	call   800165 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 20             	sub    $0x20,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003e:	eb 43                	jmp    800083 <cat+0x50>
		if ((r = write(1, buf, n)) != n)
  800040:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800044:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  80004b:	00 
  80004c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800053:	e8 3f 14 00 00       	call   801497 <write>
  800058:	39 d8                	cmp    %ebx,%eax
  80005a:	74 27                	je     800083 <cat+0x50>
			panic("write error copying %s: %e", s, r);
  80005c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800060:	8b 45 0c             	mov    0xc(%ebp),%eax
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 20 29 80 	movl   $0x802920,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 3b 29 80 00 	movl   $0x80293b,(%esp)
  80007e:	e8 43 01 00 00       	call   8001c6 <_panic>
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800083:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
  80008a:	00 
  80008b:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  800092:	00 
  800093:	89 34 24             	mov    %esi,(%esp)
  800096:	e8 1f 13 00 00       	call   8013ba <read>
  80009b:	89 c3                	mov    %eax,%ebx
  80009d:	85 c0                	test   %eax,%eax
  80009f:	7f 9f                	jg     800040 <cat+0xd>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	79 27                	jns    8000cc <cat+0x99>
		panic("error reading %s: %e", s, n);
  8000a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	c7 44 24 08 46 29 80 	movl   $0x802946,0x8(%esp)
  8000b7:	00 
  8000b8:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 3b 29 80 00 	movl   $0x80293b,(%esp)
  8000c7:	e8 fa 00 00 00       	call   8001c6 <_panic>
}
  8000cc:	83 c4 20             	add    $0x20,%esp
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <umain>:

void
umain(int argc, char **argv)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 1c             	sub    $0x1c,%esp
  8000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000df:	c7 05 00 30 80 00 5b 	movl   $0x80295b,0x803000
  8000e6:	29 80 00 
	if (argc == 1)
  8000e9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ed:	74 07                	je     8000f6 <umain+0x23>
  8000ef:	bb 01 00 00 00       	mov    $0x1,%ebx
  8000f4:	eb 62                	jmp    800158 <umain+0x85>
		cat(0, "<stdin>");
  8000f6:	c7 44 24 04 5f 29 80 	movl   $0x80295f,0x4(%esp)
  8000fd:	00 
  8000fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800105:	e8 29 ff ff ff       	call   800033 <cat>
  80010a:	eb 51                	jmp    80015d <umain+0x8a>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  80010c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800113:	00 
  800114:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800117:	89 04 24             	mov    %eax,(%esp)
  80011a:	e8 e5 17 00 00       	call   801904 <open>
  80011f:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800121:	85 c0                	test   %eax,%eax
  800123:	79 19                	jns    80013e <umain+0x6b>
				printf("can't open %s: %e\n", argv[i], f);
  800125:	89 44 24 08          	mov    %eax,0x8(%esp)
  800129:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800130:	c7 04 24 67 29 80 00 	movl   $0x802967,(%esp)
  800137:	e8 9b 19 00 00       	call   801ad7 <printf>
  80013c:	eb 17                	jmp    800155 <umain+0x82>
			else {
				cat(f, argv[i]);
  80013e:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800141:	89 44 24 04          	mov    %eax,0x4(%esp)
  800145:	89 34 24             	mov    %esi,(%esp)
  800148:	e8 e6 fe ff ff       	call   800033 <cat>
				close(f);
  80014d:	89 34 24             	mov    %esi,(%esp)
  800150:	e8 02 11 00 00       	call   801257 <close>

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800155:	83 c3 01             	add    $0x1,%ebx
  800158:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  80015b:	7c af                	jl     80010c <umain+0x39>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  80015d:	83 c4 1c             	add    $0x1c,%esp
  800160:	5b                   	pop    %ebx
  800161:	5e                   	pop    %esi
  800162:	5f                   	pop    %edi
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    

00800165 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	56                   	push   %esi
  800169:	53                   	push   %ebx
  80016a:	83 ec 10             	sub    $0x10,%esp
  80016d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800170:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800173:	e8 ef 0b 00 00       	call   800d67 <sys_getenvid>
  800178:	25 ff 03 00 00       	and    $0x3ff,%eax
  80017d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800180:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800185:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018a:	85 db                	test   %ebx,%ebx
  80018c:	7e 07                	jle    800195 <libmain+0x30>
		binaryname = argv[0];
  80018e:	8b 06                	mov    (%esi),%eax
  800190:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800195:	89 74 24 04          	mov    %esi,0x4(%esp)
  800199:	89 1c 24             	mov    %ebx,(%esp)
  80019c:	e8 32 ff ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  8001a1:	e8 07 00 00 00       	call   8001ad <exit>
}
  8001a6:	83 c4 10             	add    $0x10,%esp
  8001a9:	5b                   	pop    %ebx
  8001aa:	5e                   	pop    %esi
  8001ab:	5d                   	pop    %ebp
  8001ac:	c3                   	ret    

008001ad <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b3:	e8 d2 10 00 00       	call   80128a <close_all>
	sys_env_destroy(0);
  8001b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001bf:	e8 ff 0a 00 00       	call   800cc3 <sys_env_destroy>
}
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    

008001c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001ce:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001d1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001d7:	e8 8b 0b 00 00       	call   800d67 <sys_getenvid>
  8001dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001df:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001ea:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f2:	c7 04 24 84 29 80 00 	movl   $0x802984,(%esp)
  8001f9:	e8 c1 00 00 00       	call   8002bf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800202:	8b 45 10             	mov    0x10(%ebp),%eax
  800205:	89 04 24             	mov    %eax,(%esp)
  800208:	e8 51 00 00 00       	call   80025e <vcprintf>
	cprintf("\n");
  80020d:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  800214:	e8 a6 00 00 00       	call   8002bf <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800219:	cc                   	int3   
  80021a:	eb fd                	jmp    800219 <_panic+0x53>

0080021c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	53                   	push   %ebx
  800220:	83 ec 14             	sub    $0x14,%esp
  800223:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800226:	8b 13                	mov    (%ebx),%edx
  800228:	8d 42 01             	lea    0x1(%edx),%eax
  80022b:	89 03                	mov    %eax,(%ebx)
  80022d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800230:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800234:	3d ff 00 00 00       	cmp    $0xff,%eax
  800239:	75 19                	jne    800254 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80023b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800242:	00 
  800243:	8d 43 08             	lea    0x8(%ebx),%eax
  800246:	89 04 24             	mov    %eax,(%esp)
  800249:	e8 38 0a 00 00       	call   800c86 <sys_cputs>
		b->idx = 0;
  80024e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800254:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800258:	83 c4 14             	add    $0x14,%esp
  80025b:	5b                   	pop    %ebx
  80025c:	5d                   	pop    %ebp
  80025d:	c3                   	ret    

0080025e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800267:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80026e:	00 00 00 
	b.cnt = 0;
  800271:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800278:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	89 44 24 08          	mov    %eax,0x8(%esp)
  800289:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800293:	c7 04 24 1c 02 80 00 	movl   $0x80021c,(%esp)
  80029a:	e8 75 01 00 00       	call   800414 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80029f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002af:	89 04 24             	mov    %eax,(%esp)
  8002b2:	e8 cf 09 00 00       	call   800c86 <sys_cputs>

	return b.cnt;
}
  8002b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002bd:	c9                   	leave  
  8002be:	c3                   	ret    

008002bf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cf:	89 04 24             	mov    %eax,(%esp)
  8002d2:	e8 87 ff ff ff       	call   80025e <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d7:	c9                   	leave  
  8002d8:	c3                   	ret    
  8002d9:	66 90                	xchg   %ax,%ax
  8002db:	66 90                	xchg   %ax,%ax
  8002dd:	66 90                	xchg   %ax,%ax
  8002df:	90                   	nop

008002e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	57                   	push   %edi
  8002e4:	56                   	push   %esi
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 3c             	sub    $0x3c,%esp
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	89 d7                	mov    %edx,%edi
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f7:	89 c3                	mov    %eax,%ebx
  8002f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ff:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800302:	b9 00 00 00 00       	mov    $0x0,%ecx
  800307:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80030a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80030d:	39 d9                	cmp    %ebx,%ecx
  80030f:	72 05                	jb     800316 <printnum+0x36>
  800311:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800314:	77 69                	ja     80037f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800316:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800319:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80031d:	83 ee 01             	sub    $0x1,%esi
  800320:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800324:	89 44 24 08          	mov    %eax,0x8(%esp)
  800328:	8b 44 24 08          	mov    0x8(%esp),%eax
  80032c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800330:	89 c3                	mov    %eax,%ebx
  800332:	89 d6                	mov    %edx,%esi
  800334:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800337:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80033a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80033e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034f:	e8 3c 23 00 00       	call   802690 <__udivdi3>
  800354:	89 d9                	mov    %ebx,%ecx
  800356:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80035a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80035e:	89 04 24             	mov    %eax,(%esp)
  800361:	89 54 24 04          	mov    %edx,0x4(%esp)
  800365:	89 fa                	mov    %edi,%edx
  800367:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80036a:	e8 71 ff ff ff       	call   8002e0 <printnum>
  80036f:	eb 1b                	jmp    80038c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800371:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800375:	8b 45 18             	mov    0x18(%ebp),%eax
  800378:	89 04 24             	mov    %eax,(%esp)
  80037b:	ff d3                	call   *%ebx
  80037d:	eb 03                	jmp    800382 <printnum+0xa2>
  80037f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800382:	83 ee 01             	sub    $0x1,%esi
  800385:	85 f6                	test   %esi,%esi
  800387:	7f e8                	jg     800371 <printnum+0x91>
  800389:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800390:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800394:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800397:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80039a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80039e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	89 04 24             	mov    %eax,(%esp)
  8003a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003af:	e8 0c 24 00 00       	call   8027c0 <__umoddi3>
  8003b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003b8:	0f be 80 a7 29 80 00 	movsbl 0x8029a7(%eax),%eax
  8003bf:	89 04 24             	mov    %eax,(%esp)
  8003c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003c5:	ff d0                	call   *%eax
}
  8003c7:	83 c4 3c             	add    $0x3c,%esp
  8003ca:	5b                   	pop    %ebx
  8003cb:	5e                   	pop    %esi
  8003cc:	5f                   	pop    %edi
  8003cd:	5d                   	pop    %ebp
  8003ce:	c3                   	ret    

008003cf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
  8003d2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d9:	8b 10                	mov    (%eax),%edx
  8003db:	3b 50 04             	cmp    0x4(%eax),%edx
  8003de:	73 0a                	jae    8003ea <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e3:	89 08                	mov    %ecx,(%eax)
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	88 02                	mov    %al,(%edx)
}
  8003ea:	5d                   	pop    %ebp
  8003eb:	c3                   	ret    

008003ec <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003f2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800400:	8b 45 0c             	mov    0xc(%ebp),%eax
  800403:	89 44 24 04          	mov    %eax,0x4(%esp)
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	89 04 24             	mov    %eax,(%esp)
  80040d:	e8 02 00 00 00       	call   800414 <vprintfmt>
	va_end(ap);
}
  800412:	c9                   	leave  
  800413:	c3                   	ret    

00800414 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
  800417:	57                   	push   %edi
  800418:	56                   	push   %esi
  800419:	53                   	push   %ebx
  80041a:	83 ec 3c             	sub    $0x3c,%esp
  80041d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800420:	eb 17                	jmp    800439 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800422:	85 c0                	test   %eax,%eax
  800424:	0f 84 4b 04 00 00    	je     800875 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80042a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80042d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800431:	89 04 24             	mov    %eax,(%esp)
  800434:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800437:	89 fb                	mov    %edi,%ebx
  800439:	8d 7b 01             	lea    0x1(%ebx),%edi
  80043c:	0f b6 03             	movzbl (%ebx),%eax
  80043f:	83 f8 25             	cmp    $0x25,%eax
  800442:	75 de                	jne    800422 <vprintfmt+0xe>
  800444:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800448:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80044f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800454:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80045b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800460:	eb 18                	jmp    80047a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800462:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800464:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800468:	eb 10                	jmp    80047a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80046c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800470:	eb 08                	jmp    80047a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800472:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800475:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80047d:	0f b6 17             	movzbl (%edi),%edx
  800480:	0f b6 c2             	movzbl %dl,%eax
  800483:	83 ea 23             	sub    $0x23,%edx
  800486:	80 fa 55             	cmp    $0x55,%dl
  800489:	0f 87 c2 03 00 00    	ja     800851 <vprintfmt+0x43d>
  80048f:	0f b6 d2             	movzbl %dl,%edx
  800492:	ff 24 95 e0 2a 80 00 	jmp    *0x802ae0(,%edx,4)
  800499:	89 df                	mov    %ebx,%edi
  80049b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004a0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8004a3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8004a7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  8004aa:	8d 50 d0             	lea    -0x30(%eax),%edx
  8004ad:	83 fa 09             	cmp    $0x9,%edx
  8004b0:	77 33                	ja     8004e5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004b2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004b5:	eb e9                	jmp    8004a0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ba:	8b 30                	mov    (%eax),%esi
  8004bc:	8d 40 04             	lea    0x4(%eax),%eax
  8004bf:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004c4:	eb 1f                	jmp    8004e5 <vprintfmt+0xd1>
  8004c6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004c9:	85 ff                	test   %edi,%edi
  8004cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d0:	0f 49 c7             	cmovns %edi,%eax
  8004d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d6:	89 df                	mov    %ebx,%edi
  8004d8:	eb a0                	jmp    80047a <vprintfmt+0x66>
  8004da:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004dc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8004e3:	eb 95                	jmp    80047a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8004e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e9:	79 8f                	jns    80047a <vprintfmt+0x66>
  8004eb:	eb 85                	jmp    800472 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004ed:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004f2:	eb 86                	jmp    80047a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	8d 70 04             	lea    0x4(%eax),%esi
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	89 04 24             	mov    %eax,(%esp)
  800509:	ff 55 08             	call   *0x8(%ebp)
  80050c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80050f:	e9 25 ff ff ff       	jmp    800439 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	8d 70 04             	lea    0x4(%eax),%esi
  80051a:	8b 00                	mov    (%eax),%eax
  80051c:	99                   	cltd   
  80051d:	31 d0                	xor    %edx,%eax
  80051f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800521:	83 f8 15             	cmp    $0x15,%eax
  800524:	7f 0b                	jg     800531 <vprintfmt+0x11d>
  800526:	8b 14 85 40 2c 80 00 	mov    0x802c40(,%eax,4),%edx
  80052d:	85 d2                	test   %edx,%edx
  80052f:	75 26                	jne    800557 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800531:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800535:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  80053c:	00 
  80053d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800540:	89 44 24 04          	mov    %eax,0x4(%esp)
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	89 04 24             	mov    %eax,(%esp)
  80054a:	e8 9d fe ff ff       	call   8003ec <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80054f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800552:	e9 e2 fe ff ff       	jmp    800439 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800557:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80055b:	c7 44 24 08 92 2d 80 	movl   $0x802d92,0x8(%esp)
  800562:	00 
  800563:	8b 45 0c             	mov    0xc(%ebp),%eax
  800566:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	89 04 24             	mov    %eax,(%esp)
  800570:	e8 77 fe ff ff       	call   8003ec <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800575:	89 75 14             	mov    %esi,0x14(%ebp)
  800578:	e9 bc fe ff ff       	jmp    800439 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800583:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800586:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80058a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80058c:	85 ff                	test   %edi,%edi
  80058e:	b8 b8 29 80 00       	mov    $0x8029b8,%eax
  800593:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800596:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80059a:	0f 84 94 00 00 00    	je     800634 <vprintfmt+0x220>
  8005a0:	85 c9                	test   %ecx,%ecx
  8005a2:	0f 8e 94 00 00 00    	jle    80063c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ac:	89 3c 24             	mov    %edi,(%esp)
  8005af:	e8 64 03 00 00       	call   800918 <strnlen>
  8005b4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005b7:	29 c1                	sub    %eax,%ecx
  8005b9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  8005bc:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  8005c0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8005c3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005cc:	89 cb                	mov    %ecx,%ebx
  8005ce:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d0:	eb 0f                	jmp    8005e1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  8005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005d9:	89 3c 24             	mov    %edi,(%esp)
  8005dc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005de:	83 eb 01             	sub    $0x1,%ebx
  8005e1:	85 db                	test   %ebx,%ebx
  8005e3:	7f ed                	jg     8005d2 <vprintfmt+0x1be>
  8005e5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005e8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005ee:	85 c9                	test   %ecx,%ecx
  8005f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f5:	0f 49 c1             	cmovns %ecx,%eax
  8005f8:	29 c1                	sub    %eax,%ecx
  8005fa:	89 cb                	mov    %ecx,%ebx
  8005fc:	eb 44                	jmp    800642 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800602:	74 1e                	je     800622 <vprintfmt+0x20e>
  800604:	0f be d2             	movsbl %dl,%edx
  800607:	83 ea 20             	sub    $0x20,%edx
  80060a:	83 fa 5e             	cmp    $0x5e,%edx
  80060d:	76 13                	jbe    800622 <vprintfmt+0x20e>
					putch('?', putdat);
  80060f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800612:	89 44 24 04          	mov    %eax,0x4(%esp)
  800616:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80061d:	ff 55 08             	call   *0x8(%ebp)
  800620:	eb 0d                	jmp    80062f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800622:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800625:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800629:	89 04 24             	mov    %eax,(%esp)
  80062c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80062f:	83 eb 01             	sub    $0x1,%ebx
  800632:	eb 0e                	jmp    800642 <vprintfmt+0x22e>
  800634:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800637:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80063a:	eb 06                	jmp    800642 <vprintfmt+0x22e>
  80063c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80063f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800642:	83 c7 01             	add    $0x1,%edi
  800645:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800649:	0f be c2             	movsbl %dl,%eax
  80064c:	85 c0                	test   %eax,%eax
  80064e:	74 27                	je     800677 <vprintfmt+0x263>
  800650:	85 f6                	test   %esi,%esi
  800652:	78 aa                	js     8005fe <vprintfmt+0x1ea>
  800654:	83 ee 01             	sub    $0x1,%esi
  800657:	79 a5                	jns    8005fe <vprintfmt+0x1ea>
  800659:	89 d8                	mov    %ebx,%eax
  80065b:	8b 75 08             	mov    0x8(%ebp),%esi
  80065e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800661:	89 c3                	mov    %eax,%ebx
  800663:	eb 18                	jmp    80067d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800665:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800669:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800670:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800672:	83 eb 01             	sub    $0x1,%ebx
  800675:	eb 06                	jmp    80067d <vprintfmt+0x269>
  800677:	8b 75 08             	mov    0x8(%ebp),%esi
  80067a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80067d:	85 db                	test   %ebx,%ebx
  80067f:	7f e4                	jg     800665 <vprintfmt+0x251>
  800681:	89 75 08             	mov    %esi,0x8(%ebp)
  800684:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800687:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80068a:	e9 aa fd ff ff       	jmp    800439 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80068f:	83 f9 01             	cmp    $0x1,%ecx
  800692:	7e 10                	jle    8006a4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 30                	mov    (%eax),%esi
  800699:	8b 78 04             	mov    0x4(%eax),%edi
  80069c:	8d 40 08             	lea    0x8(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a2:	eb 26                	jmp    8006ca <vprintfmt+0x2b6>
	else if (lflag)
  8006a4:	85 c9                	test   %ecx,%ecx
  8006a6:	74 12                	je     8006ba <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 30                	mov    (%eax),%esi
  8006ad:	89 f7                	mov    %esi,%edi
  8006af:	c1 ff 1f             	sar    $0x1f,%edi
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b8:	eb 10                	jmp    8006ca <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 30                	mov    (%eax),%esi
  8006bf:	89 f7                	mov    %esi,%edi
  8006c1:	c1 ff 1f             	sar    $0x1f,%edi
  8006c4:	8d 40 04             	lea    0x4(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ca:	89 f0                	mov    %esi,%eax
  8006cc:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006d3:	85 ff                	test   %edi,%edi
  8006d5:	0f 89 3a 01 00 00    	jns    800815 <vprintfmt+0x401>
				putch('-', putdat);
  8006db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006e9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006ec:	89 f0                	mov    %esi,%eax
  8006ee:	89 fa                	mov    %edi,%edx
  8006f0:	f7 d8                	neg    %eax
  8006f2:	83 d2 00             	adc    $0x0,%edx
  8006f5:	f7 da                	neg    %edx
			}
			base = 10;
  8006f7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006fc:	e9 14 01 00 00       	jmp    800815 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800701:	83 f9 01             	cmp    $0x1,%ecx
  800704:	7e 13                	jle    800719 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 50 04             	mov    0x4(%eax),%edx
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	8b 75 14             	mov    0x14(%ebp),%esi
  800711:	8d 4e 08             	lea    0x8(%esi),%ecx
  800714:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800717:	eb 2c                	jmp    800745 <vprintfmt+0x331>
	else if (lflag)
  800719:	85 c9                	test   %ecx,%ecx
  80071b:	74 15                	je     800732 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	ba 00 00 00 00       	mov    $0x0,%edx
  800727:	8b 75 14             	mov    0x14(%ebp),%esi
  80072a:	8d 76 04             	lea    0x4(%esi),%esi
  80072d:	89 75 14             	mov    %esi,0x14(%ebp)
  800730:	eb 13                	jmp    800745 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	ba 00 00 00 00       	mov    $0x0,%edx
  80073c:	8b 75 14             	mov    0x14(%ebp),%esi
  80073f:	8d 76 04             	lea    0x4(%esi),%esi
  800742:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800745:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80074a:	e9 c6 00 00 00       	jmp    800815 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80074f:	83 f9 01             	cmp    $0x1,%ecx
  800752:	7e 13                	jle    800767 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	8b 50 04             	mov    0x4(%eax),%edx
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	8b 75 14             	mov    0x14(%ebp),%esi
  80075f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800762:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800765:	eb 24                	jmp    80078b <vprintfmt+0x377>
	else if (lflag)
  800767:	85 c9                	test   %ecx,%ecx
  800769:	74 11                	je     80077c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	99                   	cltd   
  800771:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800774:	8d 71 04             	lea    0x4(%ecx),%esi
  800777:	89 75 14             	mov    %esi,0x14(%ebp)
  80077a:	eb 0f                	jmp    80078b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	99                   	cltd   
  800782:	8b 75 14             	mov    0x14(%ebp),%esi
  800785:	8d 76 04             	lea    0x4(%esi),%esi
  800788:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80078b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800790:	e9 80 00 00 00       	jmp    800815 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800795:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007a6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007b7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007ba:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007be:	8b 06                	mov    (%esi),%eax
  8007c0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007c5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007ca:	eb 49                	jmp    800815 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007cc:	83 f9 01             	cmp    $0x1,%ecx
  8007cf:	7e 13                	jle    8007e4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8b 50 04             	mov    0x4(%eax),%edx
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	8b 75 14             	mov    0x14(%ebp),%esi
  8007dc:	8d 4e 08             	lea    0x8(%esi),%ecx
  8007df:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007e2:	eb 2c                	jmp    800810 <vprintfmt+0x3fc>
	else if (lflag)
  8007e4:	85 c9                	test   %ecx,%ecx
  8007e6:	74 15                	je     8007fd <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007f5:	8d 71 04             	lea    0x4(%ecx),%esi
  8007f8:	89 75 14             	mov    %esi,0x14(%ebp)
  8007fb:	eb 13                	jmp    800810 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8b 00                	mov    (%eax),%eax
  800802:	ba 00 00 00 00       	mov    $0x0,%edx
  800807:	8b 75 14             	mov    0x14(%ebp),%esi
  80080a:	8d 76 04             	lea    0x4(%esi),%esi
  80080d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800810:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800815:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800819:	89 74 24 10          	mov    %esi,0x10(%esp)
  80081d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800820:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800824:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800828:	89 04 24             	mov    %eax,(%esp)
  80082b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80082f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	e8 a6 fa ff ff       	call   8002e0 <printnum>
			break;
  80083a:	e9 fa fb ff ff       	jmp    800439 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80083f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800842:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800846:	89 04 24             	mov    %eax,(%esp)
  800849:	ff 55 08             	call   *0x8(%ebp)
			break;
  80084c:	e9 e8 fb ff ff       	jmp    800439 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800851:	8b 45 0c             	mov    0xc(%ebp),%eax
  800854:	89 44 24 04          	mov    %eax,0x4(%esp)
  800858:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80085f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800862:	89 fb                	mov    %edi,%ebx
  800864:	eb 03                	jmp    800869 <vprintfmt+0x455>
  800866:	83 eb 01             	sub    $0x1,%ebx
  800869:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80086d:	75 f7                	jne    800866 <vprintfmt+0x452>
  80086f:	90                   	nop
  800870:	e9 c4 fb ff ff       	jmp    800439 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800875:	83 c4 3c             	add    $0x3c,%esp
  800878:	5b                   	pop    %ebx
  800879:	5e                   	pop    %esi
  80087a:	5f                   	pop    %edi
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	83 ec 28             	sub    $0x28,%esp
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800889:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800890:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800893:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089a:	85 c0                	test   %eax,%eax
  80089c:	74 30                	je     8008ce <vsnprintf+0x51>
  80089e:	85 d2                	test   %edx,%edx
  8008a0:	7e 2c                	jle    8008ce <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b7:	c7 04 24 cf 03 80 00 	movl   $0x8003cf,(%esp)
  8008be:	e8 51 fb ff ff       	call   800414 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008cc:	eb 05                	jmp    8008d3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008d3:	c9                   	leave  
  8008d4:	c3                   	ret    

008008d5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008db:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	89 04 24             	mov    %eax,(%esp)
  8008f6:	e8 82 ff ff ff       	call   80087d <vsnprintf>
	va_end(ap);

	return rc;
}
  8008fb:	c9                   	leave  
  8008fc:	c3                   	ret    
  8008fd:	66 90                	xchg   %ax,%ax
  8008ff:	90                   	nop

00800900 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800906:	b8 00 00 00 00       	mov    $0x0,%eax
  80090b:	eb 03                	jmp    800910 <strlen+0x10>
		n++;
  80090d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800910:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800914:	75 f7                	jne    80090d <strlen+0xd>
		n++;
	return n;
}
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800921:	b8 00 00 00 00       	mov    $0x0,%eax
  800926:	eb 03                	jmp    80092b <strnlen+0x13>
		n++;
  800928:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092b:	39 d0                	cmp    %edx,%eax
  80092d:	74 06                	je     800935 <strnlen+0x1d>
  80092f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800933:	75 f3                	jne    800928 <strnlen+0x10>
		n++;
	return n;
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	53                   	push   %ebx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800941:	89 c2                	mov    %eax,%edx
  800943:	83 c2 01             	add    $0x1,%edx
  800946:	83 c1 01             	add    $0x1,%ecx
  800949:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80094d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800950:	84 db                	test   %bl,%bl
  800952:	75 ef                	jne    800943 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800954:	5b                   	pop    %ebx
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800961:	89 1c 24             	mov    %ebx,(%esp)
  800964:	e8 97 ff ff ff       	call   800900 <strlen>
	strcpy(dst + len, src);
  800969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800970:	01 d8                	add    %ebx,%eax
  800972:	89 04 24             	mov    %eax,(%esp)
  800975:	e8 bd ff ff ff       	call   800937 <strcpy>
	return dst;
}
  80097a:	89 d8                	mov    %ebx,%eax
  80097c:	83 c4 08             	add    $0x8,%esp
  80097f:	5b                   	pop    %ebx
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	56                   	push   %esi
  800986:	53                   	push   %ebx
  800987:	8b 75 08             	mov    0x8(%ebp),%esi
  80098a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098d:	89 f3                	mov    %esi,%ebx
  80098f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800992:	89 f2                	mov    %esi,%edx
  800994:	eb 0f                	jmp    8009a5 <strncpy+0x23>
		*dst++ = *src;
  800996:	83 c2 01             	add    $0x1,%edx
  800999:	0f b6 01             	movzbl (%ecx),%eax
  80099c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099f:	80 39 01             	cmpb   $0x1,(%ecx)
  8009a2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a5:	39 da                	cmp    %ebx,%edx
  8009a7:	75 ed                	jne    800996 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009a9:	89 f0                	mov    %esi,%eax
  8009ab:	5b                   	pop    %ebx
  8009ac:	5e                   	pop    %esi
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    

008009af <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	56                   	push   %esi
  8009b3:	53                   	push   %ebx
  8009b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009bd:	89 f0                	mov    %esi,%eax
  8009bf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c3:	85 c9                	test   %ecx,%ecx
  8009c5:	75 0b                	jne    8009d2 <strlcpy+0x23>
  8009c7:	eb 1d                	jmp    8009e6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009c9:	83 c0 01             	add    $0x1,%eax
  8009cc:	83 c2 01             	add    $0x1,%edx
  8009cf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009d2:	39 d8                	cmp    %ebx,%eax
  8009d4:	74 0b                	je     8009e1 <strlcpy+0x32>
  8009d6:	0f b6 0a             	movzbl (%edx),%ecx
  8009d9:	84 c9                	test   %cl,%cl
  8009db:	75 ec                	jne    8009c9 <strlcpy+0x1a>
  8009dd:	89 c2                	mov    %eax,%edx
  8009df:	eb 02                	jmp    8009e3 <strlcpy+0x34>
  8009e1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009e3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009e6:	29 f0                	sub    %esi,%eax
}
  8009e8:	5b                   	pop    %ebx
  8009e9:	5e                   	pop    %esi
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f5:	eb 06                	jmp    8009fd <strcmp+0x11>
		p++, q++;
  8009f7:	83 c1 01             	add    $0x1,%ecx
  8009fa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009fd:	0f b6 01             	movzbl (%ecx),%eax
  800a00:	84 c0                	test   %al,%al
  800a02:	74 04                	je     800a08 <strcmp+0x1c>
  800a04:	3a 02                	cmp    (%edx),%al
  800a06:	74 ef                	je     8009f7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a08:	0f b6 c0             	movzbl %al,%eax
  800a0b:	0f b6 12             	movzbl (%edx),%edx
  800a0e:	29 d0                	sub    %edx,%eax
}
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	53                   	push   %ebx
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1c:	89 c3                	mov    %eax,%ebx
  800a1e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a21:	eb 06                	jmp    800a29 <strncmp+0x17>
		n--, p++, q++;
  800a23:	83 c0 01             	add    $0x1,%eax
  800a26:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a29:	39 d8                	cmp    %ebx,%eax
  800a2b:	74 15                	je     800a42 <strncmp+0x30>
  800a2d:	0f b6 08             	movzbl (%eax),%ecx
  800a30:	84 c9                	test   %cl,%cl
  800a32:	74 04                	je     800a38 <strncmp+0x26>
  800a34:	3a 0a                	cmp    (%edx),%cl
  800a36:	74 eb                	je     800a23 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a38:	0f b6 00             	movzbl (%eax),%eax
  800a3b:	0f b6 12             	movzbl (%edx),%edx
  800a3e:	29 d0                	sub    %edx,%eax
  800a40:	eb 05                	jmp    800a47 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a42:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a47:	5b                   	pop    %ebx
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a54:	eb 07                	jmp    800a5d <strchr+0x13>
		if (*s == c)
  800a56:	38 ca                	cmp    %cl,%dl
  800a58:	74 0f                	je     800a69 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a5a:	83 c0 01             	add    $0x1,%eax
  800a5d:	0f b6 10             	movzbl (%eax),%edx
  800a60:	84 d2                	test   %dl,%dl
  800a62:	75 f2                	jne    800a56 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a75:	eb 07                	jmp    800a7e <strfind+0x13>
		if (*s == c)
  800a77:	38 ca                	cmp    %cl,%dl
  800a79:	74 0a                	je     800a85 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a7b:	83 c0 01             	add    $0x1,%eax
  800a7e:	0f b6 10             	movzbl (%eax),%edx
  800a81:	84 d2                	test   %dl,%dl
  800a83:	75 f2                	jne    800a77 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	57                   	push   %edi
  800a8b:	56                   	push   %esi
  800a8c:	53                   	push   %ebx
  800a8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a93:	85 c9                	test   %ecx,%ecx
  800a95:	74 36                	je     800acd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a97:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a9d:	75 28                	jne    800ac7 <memset+0x40>
  800a9f:	f6 c1 03             	test   $0x3,%cl
  800aa2:	75 23                	jne    800ac7 <memset+0x40>
		c &= 0xFF;
  800aa4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aa8:	89 d3                	mov    %edx,%ebx
  800aaa:	c1 e3 08             	shl    $0x8,%ebx
  800aad:	89 d6                	mov    %edx,%esi
  800aaf:	c1 e6 18             	shl    $0x18,%esi
  800ab2:	89 d0                	mov    %edx,%eax
  800ab4:	c1 e0 10             	shl    $0x10,%eax
  800ab7:	09 f0                	or     %esi,%eax
  800ab9:	09 c2                	or     %eax,%edx
  800abb:	89 d0                	mov    %edx,%eax
  800abd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800abf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ac2:	fc                   	cld    
  800ac3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac5:	eb 06                	jmp    800acd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aca:	fc                   	cld    
  800acb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800acd:	89 f8                	mov    %edi,%eax
  800acf:	5b                   	pop    %ebx
  800ad0:	5e                   	pop    %esi
  800ad1:	5f                   	pop    %edi
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	57                   	push   %edi
  800ad8:	56                   	push   %esi
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800adf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae2:	39 c6                	cmp    %eax,%esi
  800ae4:	73 35                	jae    800b1b <memmove+0x47>
  800ae6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ae9:	39 d0                	cmp    %edx,%eax
  800aeb:	73 2e                	jae    800b1b <memmove+0x47>
		s += n;
		d += n;
  800aed:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800af0:	89 d6                	mov    %edx,%esi
  800af2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800afa:	75 13                	jne    800b0f <memmove+0x3b>
  800afc:	f6 c1 03             	test   $0x3,%cl
  800aff:	75 0e                	jne    800b0f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b01:	83 ef 04             	sub    $0x4,%edi
  800b04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b07:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b0a:	fd                   	std    
  800b0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0d:	eb 09                	jmp    800b18 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b0f:	83 ef 01             	sub    $0x1,%edi
  800b12:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b15:	fd                   	std    
  800b16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b18:	fc                   	cld    
  800b19:	eb 1d                	jmp    800b38 <memmove+0x64>
  800b1b:	89 f2                	mov    %esi,%edx
  800b1d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1f:	f6 c2 03             	test   $0x3,%dl
  800b22:	75 0f                	jne    800b33 <memmove+0x5f>
  800b24:	f6 c1 03             	test   $0x3,%cl
  800b27:	75 0a                	jne    800b33 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b29:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b2c:	89 c7                	mov    %eax,%edi
  800b2e:	fc                   	cld    
  800b2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b31:	eb 05                	jmp    800b38 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b33:	89 c7                	mov    %eax,%edi
  800b35:	fc                   	cld    
  800b36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b38:	5e                   	pop    %esi
  800b39:	5f                   	pop    %edi
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b42:	8b 45 10             	mov    0x10(%ebp),%eax
  800b45:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	89 04 24             	mov    %eax,(%esp)
  800b56:	e8 79 ff ff ff       	call   800ad4 <memmove>
}
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    

00800b5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b68:	89 d6                	mov    %edx,%esi
  800b6a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b6d:	eb 1a                	jmp    800b89 <memcmp+0x2c>
		if (*s1 != *s2)
  800b6f:	0f b6 02             	movzbl (%edx),%eax
  800b72:	0f b6 19             	movzbl (%ecx),%ebx
  800b75:	38 d8                	cmp    %bl,%al
  800b77:	74 0a                	je     800b83 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b79:	0f b6 c0             	movzbl %al,%eax
  800b7c:	0f b6 db             	movzbl %bl,%ebx
  800b7f:	29 d8                	sub    %ebx,%eax
  800b81:	eb 0f                	jmp    800b92 <memcmp+0x35>
		s1++, s2++;
  800b83:	83 c2 01             	add    $0x1,%edx
  800b86:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b89:	39 f2                	cmp    %esi,%edx
  800b8b:	75 e2                	jne    800b6f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b92:	5b                   	pop    %ebx
  800b93:	5e                   	pop    %esi
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b9f:	89 c2                	mov    %eax,%edx
  800ba1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ba4:	eb 07                	jmp    800bad <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba6:	38 08                	cmp    %cl,(%eax)
  800ba8:	74 07                	je     800bb1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800baa:	83 c0 01             	add    $0x1,%eax
  800bad:	39 d0                	cmp    %edx,%eax
  800baf:	72 f5                	jb     800ba6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	57                   	push   %edi
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bbf:	eb 03                	jmp    800bc4 <strtol+0x11>
		s++;
  800bc1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc4:	0f b6 0a             	movzbl (%edx),%ecx
  800bc7:	80 f9 09             	cmp    $0x9,%cl
  800bca:	74 f5                	je     800bc1 <strtol+0xe>
  800bcc:	80 f9 20             	cmp    $0x20,%cl
  800bcf:	74 f0                	je     800bc1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bd1:	80 f9 2b             	cmp    $0x2b,%cl
  800bd4:	75 0a                	jne    800be0 <strtol+0x2d>
		s++;
  800bd6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bd9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bde:	eb 11                	jmp    800bf1 <strtol+0x3e>
  800be0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800be5:	80 f9 2d             	cmp    $0x2d,%cl
  800be8:	75 07                	jne    800bf1 <strtol+0x3e>
		s++, neg = 1;
  800bea:	8d 52 01             	lea    0x1(%edx),%edx
  800bed:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800bf6:	75 15                	jne    800c0d <strtol+0x5a>
  800bf8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bfb:	75 10                	jne    800c0d <strtol+0x5a>
  800bfd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c01:	75 0a                	jne    800c0d <strtol+0x5a>
		s += 2, base = 16;
  800c03:	83 c2 02             	add    $0x2,%edx
  800c06:	b8 10 00 00 00       	mov    $0x10,%eax
  800c0b:	eb 10                	jmp    800c1d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c0d:	85 c0                	test   %eax,%eax
  800c0f:	75 0c                	jne    800c1d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c11:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c13:	80 3a 30             	cmpb   $0x30,(%edx)
  800c16:	75 05                	jne    800c1d <strtol+0x6a>
		s++, base = 8;
  800c18:	83 c2 01             	add    $0x1,%edx
  800c1b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c22:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c25:	0f b6 0a             	movzbl (%edx),%ecx
  800c28:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c2b:	89 f0                	mov    %esi,%eax
  800c2d:	3c 09                	cmp    $0x9,%al
  800c2f:	77 08                	ja     800c39 <strtol+0x86>
			dig = *s - '0';
  800c31:	0f be c9             	movsbl %cl,%ecx
  800c34:	83 e9 30             	sub    $0x30,%ecx
  800c37:	eb 20                	jmp    800c59 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c39:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c3c:	89 f0                	mov    %esi,%eax
  800c3e:	3c 19                	cmp    $0x19,%al
  800c40:	77 08                	ja     800c4a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c42:	0f be c9             	movsbl %cl,%ecx
  800c45:	83 e9 57             	sub    $0x57,%ecx
  800c48:	eb 0f                	jmp    800c59 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c4a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c4d:	89 f0                	mov    %esi,%eax
  800c4f:	3c 19                	cmp    $0x19,%al
  800c51:	77 16                	ja     800c69 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c53:	0f be c9             	movsbl %cl,%ecx
  800c56:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c59:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c5c:	7d 0f                	jge    800c6d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c5e:	83 c2 01             	add    $0x1,%edx
  800c61:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c65:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c67:	eb bc                	jmp    800c25 <strtol+0x72>
  800c69:	89 d8                	mov    %ebx,%eax
  800c6b:	eb 02                	jmp    800c6f <strtol+0xbc>
  800c6d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c73:	74 05                	je     800c7a <strtol+0xc7>
		*endptr = (char *) s;
  800c75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c78:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c7a:	f7 d8                	neg    %eax
  800c7c:	85 ff                	test   %edi,%edi
  800c7e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
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
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	89 c3                	mov    %eax,%ebx
  800c99:	89 c7                	mov    %eax,%edi
  800c9b:	89 c6                	mov    %eax,%esi
  800c9d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800caa:	ba 00 00 00 00       	mov    $0x0,%edx
  800caf:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb4:	89 d1                	mov    %edx,%ecx
  800cb6:	89 d3                	mov    %edx,%ebx
  800cb8:	89 d7                	mov    %edx,%edi
  800cba:	89 d6                	mov    %edx,%esi
  800cbc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	89 cb                	mov    %ecx,%ebx
  800cdb:	89 cf                	mov    %ecx,%edi
  800cdd:	89 ce                	mov    %ecx,%esi
  800cdf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ce1:	85 c0                	test   %eax,%eax
  800ce3:	7e 28                	jle    800d0d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ce9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cf0:	00 
  800cf1:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800cf8:	00 
  800cf9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d00:	00 
  800d01:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800d08:	e8 b9 f4 ff ff       	call   8001c6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0d:	83 c4 2c             	add    $0x2c,%esp
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
  800d1b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d23:	b8 04 00 00 00       	mov    $0x4,%eax
  800d28:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2b:	89 cb                	mov    %ecx,%ebx
  800d2d:	89 cf                	mov    %ecx,%edi
  800d2f:	89 ce                	mov    %ecx,%esi
  800d31:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d33:	85 c0                	test   %eax,%eax
  800d35:	7e 28                	jle    800d5f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d37:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d3b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d42:	00 
  800d43:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800d4a:	00 
  800d4b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d52:	00 
  800d53:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800d5a:	e8 67 f4 ff ff       	call   8001c6 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800d5f:	83 c4 2c             	add    $0x2c,%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	57                   	push   %edi
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d72:	b8 02 00 00 00       	mov    $0x2,%eax
  800d77:	89 d1                	mov    %edx,%ecx
  800d79:	89 d3                	mov    %edx,%ebx
  800d7b:	89 d7                	mov    %edx,%edi
  800d7d:	89 d6                	mov    %edx,%esi
  800d7f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <sys_yield>:

void
sys_yield(void)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d91:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d96:	89 d1                	mov    %edx,%ecx
  800d98:	89 d3                	mov    %edx,%ebx
  800d9a:	89 d7                	mov    %edx,%edi
  800d9c:	89 d6                	mov    %edx,%esi
  800d9e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
  800dab:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dae:	be 00 00 00 00       	mov    $0x0,%esi
  800db3:	b8 05 00 00 00       	mov    $0x5,%eax
  800db8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc1:	89 f7                	mov    %esi,%edi
  800dc3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dc5:	85 c0                	test   %eax,%eax
  800dc7:	7e 28                	jle    800df1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dcd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dd4:	00 
  800dd5:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800ddc:	00 
  800ddd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de4:	00 
  800de5:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800dec:	e8 d5 f3 ff ff       	call   8001c6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800df1:	83 c4 2c             	add    $0x2c,%esp
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
  800dff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e02:	b8 06 00 00 00       	mov    $0x6,%eax
  800e07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e10:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e13:	8b 75 18             	mov    0x18(%ebp),%esi
  800e16:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	7e 28                	jle    800e44 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e20:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e27:	00 
  800e28:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800e2f:	00 
  800e30:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e37:	00 
  800e38:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800e3f:	e8 82 f3 ff ff       	call   8001c6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e44:	83 c4 2c             	add    $0x2c,%esp
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
  800e52:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5a:	b8 07 00 00 00       	mov    $0x7,%eax
  800e5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	89 df                	mov    %ebx,%edi
  800e67:	89 de                	mov    %ebx,%esi
  800e69:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	7e 28                	jle    800e97 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e73:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800e7a:	00 
  800e7b:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800e82:	00 
  800e83:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8a:	00 
  800e8b:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800e92:	e8 2f f3 ff ff       	call   8001c6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e97:	83 c4 2c             	add    $0x2c,%esp
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eaa:	b8 10 00 00 00       	mov    $0x10,%eax
  800eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb2:	89 cb                	mov    %ecx,%ebx
  800eb4:	89 cf                	mov    %ecx,%edi
  800eb6:	89 ce                	mov    %ecx,%esi
  800eb8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800eba:	5b                   	pop    %ebx
  800ebb:	5e                   	pop    %esi
  800ebc:	5f                   	pop    %edi
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    

00800ebf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	57                   	push   %edi
  800ec3:	56                   	push   %esi
  800ec4:	53                   	push   %ebx
  800ec5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecd:	b8 09 00 00 00       	mov    $0x9,%eax
  800ed2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	89 df                	mov    %ebx,%edi
  800eda:	89 de                	mov    %ebx,%esi
  800edc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	7e 28                	jle    800f0a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800eed:	00 
  800eee:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800ef5:	00 
  800ef6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efd:	00 
  800efe:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800f05:	e8 bc f2 ff ff       	call   8001c6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f0a:	83 c4 2c             	add    $0x2c,%esp
  800f0d:	5b                   	pop    %ebx
  800f0e:	5e                   	pop    %esi
  800f0f:	5f                   	pop    %edi
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    

00800f12 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
  800f18:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f20:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	89 df                	mov    %ebx,%edi
  800f2d:	89 de                	mov    %ebx,%esi
  800f2f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f31:	85 c0                	test   %eax,%eax
  800f33:	7e 28                	jle    800f5d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f35:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f39:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f40:	00 
  800f41:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800f48:	00 
  800f49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f50:	00 
  800f51:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800f58:	e8 69 f2 ff ff       	call   8001c6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f5d:	83 c4 2c             	add    $0x2c,%esp
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
  800f6b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f73:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	89 df                	mov    %ebx,%edi
  800f80:	89 de                	mov    %ebx,%esi
  800f82:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f84:	85 c0                	test   %eax,%eax
  800f86:	7e 28                	jle    800fb0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f88:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f93:	00 
  800f94:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800f9b:	00 
  800f9c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa3:	00 
  800fa4:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800fab:	e8 16 f2 ff ff       	call   8001c6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fb0:	83 c4 2c             	add    $0x2c,%esp
  800fb3:	5b                   	pop    %ebx
  800fb4:	5e                   	pop    %esi
  800fb5:	5f                   	pop    %edi
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    

00800fb8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	57                   	push   %edi
  800fbc:	56                   	push   %esi
  800fbd:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbe:	be 00 00 00 00       	mov    $0x0,%esi
  800fc3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fd6:	5b                   	pop    %ebx
  800fd7:	5e                   	pop    %esi
  800fd8:	5f                   	pop    %edi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    

00800fdb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	57                   	push   %edi
  800fdf:	56                   	push   %esi
  800fe0:	53                   	push   %ebx
  800fe1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff1:	89 cb                	mov    %ecx,%ebx
  800ff3:	89 cf                	mov    %ecx,%edi
  800ff5:	89 ce                	mov    %ecx,%esi
  800ff7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	7e 28                	jle    801025 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801001:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801008:	00 
  801009:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  801010:	00 
  801011:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801018:	00 
  801019:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  801020:	e8 a1 f1 ff ff       	call   8001c6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801025:	83 c4 2c             	add    $0x2c,%esp
  801028:	5b                   	pop    %ebx
  801029:	5e                   	pop    %esi
  80102a:	5f                   	pop    %edi
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    

0080102d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	57                   	push   %edi
  801031:	56                   	push   %esi
  801032:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801033:	ba 00 00 00 00       	mov    $0x0,%edx
  801038:	b8 0f 00 00 00       	mov    $0xf,%eax
  80103d:	89 d1                	mov    %edx,%ecx
  80103f:	89 d3                	mov    %edx,%ebx
  801041:	89 d7                	mov    %edx,%edi
  801043:	89 d6                	mov    %edx,%esi
  801045:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801047:	5b                   	pop    %ebx
  801048:	5e                   	pop    %esi
  801049:	5f                   	pop    %edi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    

0080104c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	57                   	push   %edi
  801050:	56                   	push   %esi
  801051:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801052:	bb 00 00 00 00       	mov    $0x0,%ebx
  801057:	b8 11 00 00 00       	mov    $0x11,%eax
  80105c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105f:	8b 55 08             	mov    0x8(%ebp),%edx
  801062:	89 df                	mov    %ebx,%edi
  801064:	89 de                	mov    %ebx,%esi
  801066:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801068:	5b                   	pop    %ebx
  801069:	5e                   	pop    %esi
  80106a:	5f                   	pop    %edi
  80106b:	5d                   	pop    %ebp
  80106c:	c3                   	ret    

0080106d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	57                   	push   %edi
  801071:	56                   	push   %esi
  801072:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801073:	bb 00 00 00 00       	mov    $0x0,%ebx
  801078:	b8 12 00 00 00       	mov    $0x12,%eax
  80107d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801080:	8b 55 08             	mov    0x8(%ebp),%edx
  801083:	89 df                	mov    %ebx,%edi
  801085:	89 de                	mov    %ebx,%esi
  801087:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801089:	5b                   	pop    %ebx
  80108a:	5e                   	pop    %esi
  80108b:	5f                   	pop    %edi
  80108c:	5d                   	pop    %ebp
  80108d:	c3                   	ret    

0080108e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	57                   	push   %edi
  801092:	56                   	push   %esi
  801093:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801094:	b9 00 00 00 00       	mov    $0x0,%ecx
  801099:	b8 13 00 00 00       	mov    $0x13,%eax
  80109e:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a1:	89 cb                	mov    %ecx,%ebx
  8010a3:	89 cf                	mov    %ecx,%edi
  8010a5:	89 ce                	mov    %ecx,%esi
  8010a7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8010a9:	5b                   	pop    %ebx
  8010aa:	5e                   	pop    %esi
  8010ab:	5f                   	pop    %edi
  8010ac:	5d                   	pop    %ebp
  8010ad:	c3                   	ret    
  8010ae:	66 90                	xchg   %ax,%ax

008010b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    

008010c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010dd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010e2:	89 c2                	mov    %eax,%edx
  8010e4:	c1 ea 16             	shr    $0x16,%edx
  8010e7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ee:	f6 c2 01             	test   $0x1,%dl
  8010f1:	74 11                	je     801104 <fd_alloc+0x2d>
  8010f3:	89 c2                	mov    %eax,%edx
  8010f5:	c1 ea 0c             	shr    $0xc,%edx
  8010f8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ff:	f6 c2 01             	test   $0x1,%dl
  801102:	75 09                	jne    80110d <fd_alloc+0x36>
			*fd_store = fd;
  801104:	89 01                	mov    %eax,(%ecx)
			return 0;
  801106:	b8 00 00 00 00       	mov    $0x0,%eax
  80110b:	eb 17                	jmp    801124 <fd_alloc+0x4d>
  80110d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801112:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801117:	75 c9                	jne    8010e2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801119:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80111f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801124:	5d                   	pop    %ebp
  801125:	c3                   	ret    

00801126 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80112c:	83 f8 1f             	cmp    $0x1f,%eax
  80112f:	77 36                	ja     801167 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801131:	c1 e0 0c             	shl    $0xc,%eax
  801134:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801139:	89 c2                	mov    %eax,%edx
  80113b:	c1 ea 16             	shr    $0x16,%edx
  80113e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801145:	f6 c2 01             	test   $0x1,%dl
  801148:	74 24                	je     80116e <fd_lookup+0x48>
  80114a:	89 c2                	mov    %eax,%edx
  80114c:	c1 ea 0c             	shr    $0xc,%edx
  80114f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801156:	f6 c2 01             	test   $0x1,%dl
  801159:	74 1a                	je     801175 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80115b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115e:	89 02                	mov    %eax,(%edx)
	return 0;
  801160:	b8 00 00 00 00       	mov    $0x0,%eax
  801165:	eb 13                	jmp    80117a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801167:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116c:	eb 0c                	jmp    80117a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80116e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801173:	eb 05                	jmp    80117a <fd_lookup+0x54>
  801175:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    

0080117c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	83 ec 18             	sub    $0x18,%esp
  801182:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801185:	ba 00 00 00 00       	mov    $0x0,%edx
  80118a:	eb 13                	jmp    80119f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80118c:	39 08                	cmp    %ecx,(%eax)
  80118e:	75 0c                	jne    80119c <dev_lookup+0x20>
			*dev = devtab[i];
  801190:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801193:	89 01                	mov    %eax,(%ecx)
			return 0;
  801195:	b8 00 00 00 00       	mov    $0x0,%eax
  80119a:	eb 38                	jmp    8011d4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80119c:	83 c2 01             	add    $0x1,%edx
  80119f:	8b 04 95 60 2d 80 00 	mov    0x802d60(,%edx,4),%eax
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	75 e2                	jne    80118c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011aa:	a1 20 60 80 00       	mov    0x806020,%eax
  8011af:	8b 40 48             	mov    0x48(%eax),%eax
  8011b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ba:	c7 04 24 e4 2c 80 00 	movl   $0x802ce4,(%esp)
  8011c1:	e8 f9 f0 ff ff       	call   8002bf <cprintf>
	*dev = 0;
  8011c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	56                   	push   %esi
  8011da:	53                   	push   %ebx
  8011db:	83 ec 20             	sub    $0x20,%esp
  8011de:	8b 75 08             	mov    0x8(%ebp),%esi
  8011e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011eb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011f1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f4:	89 04 24             	mov    %eax,(%esp)
  8011f7:	e8 2a ff ff ff       	call   801126 <fd_lookup>
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	78 05                	js     801205 <fd_close+0x2f>
	    || fd != fd2)
  801200:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801203:	74 0c                	je     801211 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801205:	84 db                	test   %bl,%bl
  801207:	ba 00 00 00 00       	mov    $0x0,%edx
  80120c:	0f 44 c2             	cmove  %edx,%eax
  80120f:	eb 3f                	jmp    801250 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801211:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801214:	89 44 24 04          	mov    %eax,0x4(%esp)
  801218:	8b 06                	mov    (%esi),%eax
  80121a:	89 04 24             	mov    %eax,(%esp)
  80121d:	e8 5a ff ff ff       	call   80117c <dev_lookup>
  801222:	89 c3                	mov    %eax,%ebx
  801224:	85 c0                	test   %eax,%eax
  801226:	78 16                	js     80123e <fd_close+0x68>
		if (dev->dev_close)
  801228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80122e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801233:	85 c0                	test   %eax,%eax
  801235:	74 07                	je     80123e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801237:	89 34 24             	mov    %esi,(%esp)
  80123a:	ff d0                	call   *%eax
  80123c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80123e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801242:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801249:	e8 fe fb ff ff       	call   800e4c <sys_page_unmap>
	return r;
  80124e:	89 d8                	mov    %ebx,%eax
}
  801250:	83 c4 20             	add    $0x20,%esp
  801253:	5b                   	pop    %ebx
  801254:	5e                   	pop    %esi
  801255:	5d                   	pop    %ebp
  801256:	c3                   	ret    

00801257 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80125d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801260:	89 44 24 04          	mov    %eax,0x4(%esp)
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	89 04 24             	mov    %eax,(%esp)
  80126a:	e8 b7 fe ff ff       	call   801126 <fd_lookup>
  80126f:	89 c2                	mov    %eax,%edx
  801271:	85 d2                	test   %edx,%edx
  801273:	78 13                	js     801288 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801275:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80127c:	00 
  80127d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801280:	89 04 24             	mov    %eax,(%esp)
  801283:	e8 4e ff ff ff       	call   8011d6 <fd_close>
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <close_all>:

void
close_all(void)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	53                   	push   %ebx
  80128e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801291:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801296:	89 1c 24             	mov    %ebx,(%esp)
  801299:	e8 b9 ff ff ff       	call   801257 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80129e:	83 c3 01             	add    $0x1,%ebx
  8012a1:	83 fb 20             	cmp    $0x20,%ebx
  8012a4:	75 f0                	jne    801296 <close_all+0xc>
		close(i);
}
  8012a6:	83 c4 14             	add    $0x14,%esp
  8012a9:	5b                   	pop    %ebx
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    

008012ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	57                   	push   %edi
  8012b0:	56                   	push   %esi
  8012b1:	53                   	push   %ebx
  8012b2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	89 04 24             	mov    %eax,(%esp)
  8012c2:	e8 5f fe ff ff       	call   801126 <fd_lookup>
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	85 d2                	test   %edx,%edx
  8012cb:	0f 88 e1 00 00 00    	js     8013b2 <dup+0x106>
		return r;
	close(newfdnum);
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	89 04 24             	mov    %eax,(%esp)
  8012d7:	e8 7b ff ff ff       	call   801257 <close>

	newfd = INDEX2FD(newfdnum);
  8012dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012df:	c1 e3 0c             	shl    $0xc,%ebx
  8012e2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012eb:	89 04 24             	mov    %eax,(%esp)
  8012ee:	e8 cd fd ff ff       	call   8010c0 <fd2data>
  8012f3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012f5:	89 1c 24             	mov    %ebx,(%esp)
  8012f8:	e8 c3 fd ff ff       	call   8010c0 <fd2data>
  8012fd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ff:	89 f0                	mov    %esi,%eax
  801301:	c1 e8 16             	shr    $0x16,%eax
  801304:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80130b:	a8 01                	test   $0x1,%al
  80130d:	74 43                	je     801352 <dup+0xa6>
  80130f:	89 f0                	mov    %esi,%eax
  801311:	c1 e8 0c             	shr    $0xc,%eax
  801314:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80131b:	f6 c2 01             	test   $0x1,%dl
  80131e:	74 32                	je     801352 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801320:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801327:	25 07 0e 00 00       	and    $0xe07,%eax
  80132c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801330:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801334:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80133b:	00 
  80133c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801340:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801347:	e8 ad fa ff ff       	call   800df9 <sys_page_map>
  80134c:	89 c6                	mov    %eax,%esi
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 3e                	js     801390 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801355:	89 c2                	mov    %eax,%edx
  801357:	c1 ea 0c             	shr    $0xc,%edx
  80135a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801361:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801367:	89 54 24 10          	mov    %edx,0x10(%esp)
  80136b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80136f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801376:	00 
  801377:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801382:	e8 72 fa ff ff       	call   800df9 <sys_page_map>
  801387:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801389:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80138c:	85 f6                	test   %esi,%esi
  80138e:	79 22                	jns    8013b2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801390:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801394:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80139b:	e8 ac fa ff ff       	call   800e4c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ab:	e8 9c fa ff ff       	call   800e4c <sys_page_unmap>
	return r;
  8013b0:	89 f0                	mov    %esi,%eax
}
  8013b2:	83 c4 3c             	add    $0x3c,%esp
  8013b5:	5b                   	pop    %ebx
  8013b6:	5e                   	pop    %esi
  8013b7:	5f                   	pop    %edi
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    

008013ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	53                   	push   %ebx
  8013be:	83 ec 24             	sub    $0x24,%esp
  8013c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013cb:	89 1c 24             	mov    %ebx,(%esp)
  8013ce:	e8 53 fd ff ff       	call   801126 <fd_lookup>
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	85 d2                	test   %edx,%edx
  8013d7:	78 6d                	js     801446 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e3:	8b 00                	mov    (%eax),%eax
  8013e5:	89 04 24             	mov    %eax,(%esp)
  8013e8:	e8 8f fd ff ff       	call   80117c <dev_lookup>
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	78 55                	js     801446 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f4:	8b 50 08             	mov    0x8(%eax),%edx
  8013f7:	83 e2 03             	and    $0x3,%edx
  8013fa:	83 fa 01             	cmp    $0x1,%edx
  8013fd:	75 23                	jne    801422 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ff:	a1 20 60 80 00       	mov    0x806020,%eax
  801404:	8b 40 48             	mov    0x48(%eax),%eax
  801407:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80140b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140f:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  801416:	e8 a4 ee ff ff       	call   8002bf <cprintf>
		return -E_INVAL;
  80141b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801420:	eb 24                	jmp    801446 <read+0x8c>
	}
	if (!dev->dev_read)
  801422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801425:	8b 52 08             	mov    0x8(%edx),%edx
  801428:	85 d2                	test   %edx,%edx
  80142a:	74 15                	je     801441 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80142c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80142f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801433:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801436:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80143a:	89 04 24             	mov    %eax,(%esp)
  80143d:	ff d2                	call   *%edx
  80143f:	eb 05                	jmp    801446 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801441:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801446:	83 c4 24             	add    $0x24,%esp
  801449:	5b                   	pop    %ebx
  80144a:	5d                   	pop    %ebp
  80144b:	c3                   	ret    

0080144c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	57                   	push   %edi
  801450:	56                   	push   %esi
  801451:	53                   	push   %ebx
  801452:	83 ec 1c             	sub    $0x1c,%esp
  801455:	8b 7d 08             	mov    0x8(%ebp),%edi
  801458:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80145b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801460:	eb 23                	jmp    801485 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801462:	89 f0                	mov    %esi,%eax
  801464:	29 d8                	sub    %ebx,%eax
  801466:	89 44 24 08          	mov    %eax,0x8(%esp)
  80146a:	89 d8                	mov    %ebx,%eax
  80146c:	03 45 0c             	add    0xc(%ebp),%eax
  80146f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801473:	89 3c 24             	mov    %edi,(%esp)
  801476:	e8 3f ff ff ff       	call   8013ba <read>
		if (m < 0)
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 10                	js     80148f <readn+0x43>
			return m;
		if (m == 0)
  80147f:	85 c0                	test   %eax,%eax
  801481:	74 0a                	je     80148d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801483:	01 c3                	add    %eax,%ebx
  801485:	39 f3                	cmp    %esi,%ebx
  801487:	72 d9                	jb     801462 <readn+0x16>
  801489:	89 d8                	mov    %ebx,%eax
  80148b:	eb 02                	jmp    80148f <readn+0x43>
  80148d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80148f:	83 c4 1c             	add    $0x1c,%esp
  801492:	5b                   	pop    %ebx
  801493:	5e                   	pop    %esi
  801494:	5f                   	pop    %edi
  801495:	5d                   	pop    %ebp
  801496:	c3                   	ret    

00801497 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	53                   	push   %ebx
  80149b:	83 ec 24             	sub    $0x24,%esp
  80149e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a8:	89 1c 24             	mov    %ebx,(%esp)
  8014ab:	e8 76 fc ff ff       	call   801126 <fd_lookup>
  8014b0:	89 c2                	mov    %eax,%edx
  8014b2:	85 d2                	test   %edx,%edx
  8014b4:	78 68                	js     80151e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c0:	8b 00                	mov    (%eax),%eax
  8014c2:	89 04 24             	mov    %eax,(%esp)
  8014c5:	e8 b2 fc ff ff       	call   80117c <dev_lookup>
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	78 50                	js     80151e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d5:	75 23                	jne    8014fa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d7:	a1 20 60 80 00       	mov    0x806020,%eax
  8014dc:	8b 40 48             	mov    0x48(%eax),%eax
  8014df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e7:	c7 04 24 41 2d 80 00 	movl   $0x802d41,(%esp)
  8014ee:	e8 cc ed ff ff       	call   8002bf <cprintf>
		return -E_INVAL;
  8014f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f8:	eb 24                	jmp    80151e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fd:	8b 52 0c             	mov    0xc(%edx),%edx
  801500:	85 d2                	test   %edx,%edx
  801502:	74 15                	je     801519 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801504:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801507:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80150b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80150e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801512:	89 04 24             	mov    %eax,(%esp)
  801515:	ff d2                	call   *%edx
  801517:	eb 05                	jmp    80151e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801519:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80151e:	83 c4 24             	add    $0x24,%esp
  801521:	5b                   	pop    %ebx
  801522:	5d                   	pop    %ebp
  801523:	c3                   	ret    

00801524 <seek>:

int
seek(int fdnum, off_t offset)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80152a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80152d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	89 04 24             	mov    %eax,(%esp)
  801537:	e8 ea fb ff ff       	call   801126 <fd_lookup>
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 0e                	js     80154e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801549:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	53                   	push   %ebx
  801554:	83 ec 24             	sub    $0x24,%esp
  801557:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80155a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80155d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801561:	89 1c 24             	mov    %ebx,(%esp)
  801564:	e8 bd fb ff ff       	call   801126 <fd_lookup>
  801569:	89 c2                	mov    %eax,%edx
  80156b:	85 d2                	test   %edx,%edx
  80156d:	78 61                	js     8015d0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801572:	89 44 24 04          	mov    %eax,0x4(%esp)
  801576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	89 04 24             	mov    %eax,(%esp)
  80157e:	e8 f9 fb ff ff       	call   80117c <dev_lookup>
  801583:	85 c0                	test   %eax,%eax
  801585:	78 49                	js     8015d0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80158e:	75 23                	jne    8015b3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801590:	a1 20 60 80 00       	mov    0x806020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801595:	8b 40 48             	mov    0x48(%eax),%eax
  801598:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80159c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a0:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  8015a7:	e8 13 ed ff ff       	call   8002bf <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b1:	eb 1d                	jmp    8015d0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b6:	8b 52 18             	mov    0x18(%edx),%edx
  8015b9:	85 d2                	test   %edx,%edx
  8015bb:	74 0e                	je     8015cb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015c0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015c4:	89 04 24             	mov    %eax,(%esp)
  8015c7:	ff d2                	call   *%edx
  8015c9:	eb 05                	jmp    8015d0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015d0:	83 c4 24             	add    $0x24,%esp
  8015d3:	5b                   	pop    %ebx
  8015d4:	5d                   	pop    %ebp
  8015d5:	c3                   	ret    

008015d6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	53                   	push   %ebx
  8015da:	83 ec 24             	sub    $0x24,%esp
  8015dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	89 04 24             	mov    %eax,(%esp)
  8015ed:	e8 34 fb ff ff       	call   801126 <fd_lookup>
  8015f2:	89 c2                	mov    %eax,%edx
  8015f4:	85 d2                	test   %edx,%edx
  8015f6:	78 52                	js     80164a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801602:	8b 00                	mov    (%eax),%eax
  801604:	89 04 24             	mov    %eax,(%esp)
  801607:	e8 70 fb ff ff       	call   80117c <dev_lookup>
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 3a                	js     80164a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801613:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801617:	74 2c                	je     801645 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801619:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80161c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801623:	00 00 00 
	stat->st_isdir = 0;
  801626:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80162d:	00 00 00 
	stat->st_dev = dev;
  801630:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801636:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80163a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80163d:	89 14 24             	mov    %edx,(%esp)
  801640:	ff 50 14             	call   *0x14(%eax)
  801643:	eb 05                	jmp    80164a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801645:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80164a:	83 c4 24             	add    $0x24,%esp
  80164d:	5b                   	pop    %ebx
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
  801655:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801658:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80165f:	00 
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	89 04 24             	mov    %eax,(%esp)
  801666:	e8 99 02 00 00       	call   801904 <open>
  80166b:	89 c3                	mov    %eax,%ebx
  80166d:	85 db                	test   %ebx,%ebx
  80166f:	78 1b                	js     80168c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801671:	8b 45 0c             	mov    0xc(%ebp),%eax
  801674:	89 44 24 04          	mov    %eax,0x4(%esp)
  801678:	89 1c 24             	mov    %ebx,(%esp)
  80167b:	e8 56 ff ff ff       	call   8015d6 <fstat>
  801680:	89 c6                	mov    %eax,%esi
	close(fd);
  801682:	89 1c 24             	mov    %ebx,(%esp)
  801685:	e8 cd fb ff ff       	call   801257 <close>
	return r;
  80168a:	89 f0                	mov    %esi,%eax
}
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	5b                   	pop    %ebx
  801690:	5e                   	pop    %esi
  801691:	5d                   	pop    %ebp
  801692:	c3                   	ret    

00801693 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	56                   	push   %esi
  801697:	53                   	push   %ebx
  801698:	83 ec 10             	sub    $0x10,%esp
  80169b:	89 c6                	mov    %eax,%esi
  80169d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80169f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016a6:	75 11                	jne    8016b9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016af:	e8 5b 0f 00 00       	call   80260f <ipc_find_env>
  8016b4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016b9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016c0:	00 
  8016c1:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8016c8:	00 
  8016c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016cd:	a1 00 40 80 00       	mov    0x804000,%eax
  8016d2:	89 04 24             	mov    %eax,(%esp)
  8016d5:	e8 ce 0e 00 00       	call   8025a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016e1:	00 
  8016e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016ed:	e8 4e 0e 00 00       	call   802540 <ipc_recv>
}
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	5b                   	pop    %ebx
  8016f6:	5e                   	pop    %esi
  8016f7:	5d                   	pop    %ebp
  8016f8:	c3                   	ret    

008016f9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8b 40 0c             	mov    0xc(%eax),%eax
  801705:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80170a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170d:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801712:	ba 00 00 00 00       	mov    $0x0,%edx
  801717:	b8 02 00 00 00       	mov    $0x2,%eax
  80171c:	e8 72 ff ff ff       	call   801693 <fsipc>
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	8b 40 0c             	mov    0xc(%eax),%eax
  80172f:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801734:	ba 00 00 00 00       	mov    $0x0,%edx
  801739:	b8 06 00 00 00       	mov    $0x6,%eax
  80173e:	e8 50 ff ff ff       	call   801693 <fsipc>
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	53                   	push   %ebx
  801749:	83 ec 14             	sub    $0x14,%esp
  80174c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8b 40 0c             	mov    0xc(%eax),%eax
  801755:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80175a:	ba 00 00 00 00       	mov    $0x0,%edx
  80175f:	b8 05 00 00 00       	mov    $0x5,%eax
  801764:	e8 2a ff ff ff       	call   801693 <fsipc>
  801769:	89 c2                	mov    %eax,%edx
  80176b:	85 d2                	test   %edx,%edx
  80176d:	78 2b                	js     80179a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80176f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801776:	00 
  801777:	89 1c 24             	mov    %ebx,(%esp)
  80177a:	e8 b8 f1 ff ff       	call   800937 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80177f:	a1 80 70 80 00       	mov    0x807080,%eax
  801784:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80178a:	a1 84 70 80 00       	mov    0x807084,%eax
  80178f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179a:	83 c4 14             	add    $0x14,%esp
  80179d:	5b                   	pop    %ebx
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	53                   	push   %ebx
  8017a4:	83 ec 14             	sub    $0x14,%esp
  8017a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  8017aa:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  8017b0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8017b5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017bb:	8b 52 0c             	mov    0xc(%edx),%edx
  8017be:	89 15 00 70 80 00    	mov    %edx,0x807000
	fsipcbuf.write.req_n = count;
  8017c4:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, count);
  8017c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d4:	c7 04 24 08 70 80 00 	movl   $0x807008,(%esp)
  8017db:	e8 f4 f2 ff ff       	call   800ad4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  8017e0:	c7 44 24 04 08 70 80 	movl   $0x807008,0x4(%esp)
  8017e7:	00 
  8017e8:	c7 04 24 74 2d 80 00 	movl   $0x802d74,(%esp)
  8017ef:	e8 cb ea ff ff       	call   8002bf <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f9:	b8 04 00 00 00       	mov    $0x4,%eax
  8017fe:	e8 90 fe ff ff       	call   801693 <fsipc>
  801803:	85 c0                	test   %eax,%eax
  801805:	78 53                	js     80185a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801807:	39 c3                	cmp    %eax,%ebx
  801809:	73 24                	jae    80182f <devfile_write+0x8f>
  80180b:	c7 44 24 0c 79 2d 80 	movl   $0x802d79,0xc(%esp)
  801812:	00 
  801813:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  80181a:	00 
  80181b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801822:	00 
  801823:	c7 04 24 95 2d 80 00 	movl   $0x802d95,(%esp)
  80182a:	e8 97 e9 ff ff       	call   8001c6 <_panic>
	assert(r <= PGSIZE);
  80182f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801834:	7e 24                	jle    80185a <devfile_write+0xba>
  801836:	c7 44 24 0c a0 2d 80 	movl   $0x802da0,0xc(%esp)
  80183d:	00 
  80183e:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  801845:	00 
  801846:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  80184d:	00 
  80184e:	c7 04 24 95 2d 80 00 	movl   $0x802d95,(%esp)
  801855:	e8 6c e9 ff ff       	call   8001c6 <_panic>
	return r;
}
  80185a:	83 c4 14             	add    $0x14,%esp
  80185d:	5b                   	pop    %ebx
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    

00801860 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	56                   	push   %esi
  801864:	53                   	push   %ebx
  801865:	83 ec 10             	sub    $0x10,%esp
  801868:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	8b 40 0c             	mov    0xc(%eax),%eax
  801871:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801876:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80187c:	ba 00 00 00 00       	mov    $0x0,%edx
  801881:	b8 03 00 00 00       	mov    $0x3,%eax
  801886:	e8 08 fe ff ff       	call   801693 <fsipc>
  80188b:	89 c3                	mov    %eax,%ebx
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 6a                	js     8018fb <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801891:	39 c6                	cmp    %eax,%esi
  801893:	73 24                	jae    8018b9 <devfile_read+0x59>
  801895:	c7 44 24 0c 79 2d 80 	movl   $0x802d79,0xc(%esp)
  80189c:	00 
  80189d:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  8018a4:	00 
  8018a5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8018ac:	00 
  8018ad:	c7 04 24 95 2d 80 00 	movl   $0x802d95,(%esp)
  8018b4:	e8 0d e9 ff ff       	call   8001c6 <_panic>
	assert(r <= PGSIZE);
  8018b9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018be:	7e 24                	jle    8018e4 <devfile_read+0x84>
  8018c0:	c7 44 24 0c a0 2d 80 	movl   $0x802da0,0xc(%esp)
  8018c7:	00 
  8018c8:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  8018cf:	00 
  8018d0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8018d7:	00 
  8018d8:	c7 04 24 95 2d 80 00 	movl   $0x802d95,(%esp)
  8018df:	e8 e2 e8 ff ff       	call   8001c6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018e8:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8018ef:	00 
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	89 04 24             	mov    %eax,(%esp)
  8018f6:	e8 d9 f1 ff ff       	call   800ad4 <memmove>
	return r;
}
  8018fb:	89 d8                	mov    %ebx,%eax
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	5b                   	pop    %ebx
  801901:	5e                   	pop    %esi
  801902:	5d                   	pop    %ebp
  801903:	c3                   	ret    

00801904 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	53                   	push   %ebx
  801908:	83 ec 24             	sub    $0x24,%esp
  80190b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80190e:	89 1c 24             	mov    %ebx,(%esp)
  801911:	e8 ea ef ff ff       	call   800900 <strlen>
  801916:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80191b:	7f 60                	jg     80197d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80191d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801920:	89 04 24             	mov    %eax,(%esp)
  801923:	e8 af f7 ff ff       	call   8010d7 <fd_alloc>
  801928:	89 c2                	mov    %eax,%edx
  80192a:	85 d2                	test   %edx,%edx
  80192c:	78 54                	js     801982 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80192e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801932:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  801939:	e8 f9 ef ff ff       	call   800937 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80193e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801941:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801946:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801949:	b8 01 00 00 00       	mov    $0x1,%eax
  80194e:	e8 40 fd ff ff       	call   801693 <fsipc>
  801953:	89 c3                	mov    %eax,%ebx
  801955:	85 c0                	test   %eax,%eax
  801957:	79 17                	jns    801970 <open+0x6c>
		fd_close(fd, 0);
  801959:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801960:	00 
  801961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801964:	89 04 24             	mov    %eax,(%esp)
  801967:	e8 6a f8 ff ff       	call   8011d6 <fd_close>
		return r;
  80196c:	89 d8                	mov    %ebx,%eax
  80196e:	eb 12                	jmp    801982 <open+0x7e>
	}

	return fd2num(fd);
  801970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801973:	89 04 24             	mov    %eax,(%esp)
  801976:	e8 35 f7 ff ff       	call   8010b0 <fd2num>
  80197b:	eb 05                	jmp    801982 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80197d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801982:	83 c4 24             	add    $0x24,%esp
  801985:	5b                   	pop    %ebx
  801986:	5d                   	pop    %ebp
  801987:	c3                   	ret    

00801988 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80198e:	ba 00 00 00 00       	mov    $0x0,%edx
  801993:	b8 08 00 00 00       	mov    $0x8,%eax
  801998:	e8 f6 fc ff ff       	call   801693 <fsipc>
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <evict>:

int evict(void)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  8019a5:	c7 04 24 ac 2d 80 00 	movl   $0x802dac,(%esp)
  8019ac:	e8 0e e9 ff ff       	call   8002bf <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  8019b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b6:	b8 09 00 00 00       	mov    $0x9,%eax
  8019bb:	e8 d3 fc ff ff       	call   801693 <fsipc>
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	53                   	push   %ebx
  8019c6:	83 ec 14             	sub    $0x14,%esp
  8019c9:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8019cb:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019cf:	7e 31                	jle    801a02 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019d1:	8b 40 04             	mov    0x4(%eax),%eax
  8019d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019d8:	8d 43 10             	lea    0x10(%ebx),%eax
  8019db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019df:	8b 03                	mov    (%ebx),%eax
  8019e1:	89 04 24             	mov    %eax,(%esp)
  8019e4:	e8 ae fa ff ff       	call   801497 <write>
		if (result > 0)
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	7e 03                	jle    8019f0 <writebuf+0x2e>
			b->result += result;
  8019ed:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019f0:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019f3:	74 0d                	je     801a02 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fc:	0f 4f c2             	cmovg  %edx,%eax
  8019ff:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a02:	83 c4 14             	add    $0x14,%esp
  801a05:	5b                   	pop    %ebx
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    

00801a08 <putch>:

static void
putch(int ch, void *thunk)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	53                   	push   %ebx
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a12:	8b 53 04             	mov    0x4(%ebx),%edx
  801a15:	8d 42 01             	lea    0x1(%edx),%eax
  801a18:	89 43 04             	mov    %eax,0x4(%ebx)
  801a1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a1e:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a22:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a27:	75 0e                	jne    801a37 <putch+0x2f>
		writebuf(b);
  801a29:	89 d8                	mov    %ebx,%eax
  801a2b:	e8 92 ff ff ff       	call   8019c2 <writebuf>
		b->idx = 0;
  801a30:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801a37:	83 c4 04             	add    $0x4,%esp
  801a3a:	5b                   	pop    %ebx
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    

00801a3d <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a4f:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a56:	00 00 00 
	b.result = 0;
  801a59:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a60:	00 00 00 
	b.error = 1;
  801a63:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a6a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a70:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a77:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a7b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a85:	c7 04 24 08 1a 80 00 	movl   $0x801a08,(%esp)
  801a8c:	e8 83 e9 ff ff       	call   800414 <vprintfmt>
	if (b.idx > 0)
  801a91:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a98:	7e 0b                	jle    801aa5 <vfprintf+0x68>
		writebuf(&b);
  801a9a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801aa0:	e8 1d ff ff ff       	call   8019c2 <writebuf>

	return (b.result ? b.result : b.error);
  801aa5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801aab:	85 c0                	test   %eax,%eax
  801aad:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801abc:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801abf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	89 04 24             	mov    %eax,(%esp)
  801ad0:	e8 68 ff ff ff       	call   801a3d <vfprintf>
	va_end(ap);

	return cnt;
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <printf>:

int
printf(const char *fmt, ...)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801add:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801ae0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aeb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801af2:	e8 46 ff ff ff       	call   801a3d <vfprintf>
	va_end(ap);

	return cnt;
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    
  801af9:	66 90                	xchg   %ax,%ax
  801afb:	66 90                	xchg   %ax,%ax
  801afd:	66 90                	xchg   %ax,%ax
  801aff:	90                   	nop

00801b00 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801b06:	c7 44 24 04 c5 2d 80 	movl   $0x802dc5,0x4(%esp)
  801b0d:	00 
  801b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b11:	89 04 24             	mov    %eax,(%esp)
  801b14:	e8 1e ee ff ff       	call   800937 <strcpy>
	return 0;
}
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	53                   	push   %ebx
  801b24:	83 ec 14             	sub    $0x14,%esp
  801b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b2a:	89 1c 24             	mov    %ebx,(%esp)
  801b2d:	e8 15 0b 00 00       	call   802647 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801b32:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801b37:	83 f8 01             	cmp    $0x1,%eax
  801b3a:	75 0d                	jne    801b49 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801b3c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801b3f:	89 04 24             	mov    %eax,(%esp)
  801b42:	e8 29 03 00 00       	call   801e70 <nsipc_close>
  801b47:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801b49:	89 d0                	mov    %edx,%eax
  801b4b:	83 c4 14             	add    $0x14,%esp
  801b4e:	5b                   	pop    %ebx
  801b4f:	5d                   	pop    %ebp
  801b50:	c3                   	ret    

00801b51 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b57:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b5e:	00 
  801b5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b62:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	8b 40 0c             	mov    0xc(%eax),%eax
  801b73:	89 04 24             	mov    %eax,(%esp)
  801b76:	e8 f0 03 00 00       	call   801f6b <nsipc_send>
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b83:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b8a:	00 
  801b8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b9f:	89 04 24             	mov    %eax,(%esp)
  801ba2:	e8 44 03 00 00       	call   801eeb <nsipc_recv>
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801baf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bb2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bb6:	89 04 24             	mov    %eax,(%esp)
  801bb9:	e8 68 f5 ff ff       	call   801126 <fd_lookup>
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	78 17                	js     801bd9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801bcb:	39 08                	cmp    %ecx,(%eax)
  801bcd:	75 05                	jne    801bd4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801bcf:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd2:	eb 05                	jmp    801bd9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801bd4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	56                   	push   %esi
  801bdf:	53                   	push   %ebx
  801be0:	83 ec 20             	sub    $0x20,%esp
  801be3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801be5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be8:	89 04 24             	mov    %eax,(%esp)
  801beb:	e8 e7 f4 ff ff       	call   8010d7 <fd_alloc>
  801bf0:	89 c3                	mov    %eax,%ebx
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	78 21                	js     801c17 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bf6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bfd:	00 
  801bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c05:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0c:	e8 94 f1 ff ff       	call   800da5 <sys_page_alloc>
  801c11:	89 c3                	mov    %eax,%ebx
  801c13:	85 c0                	test   %eax,%eax
  801c15:	79 0c                	jns    801c23 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801c17:	89 34 24             	mov    %esi,(%esp)
  801c1a:	e8 51 02 00 00       	call   801e70 <nsipc_close>
		return r;
  801c1f:	89 d8                	mov    %ebx,%eax
  801c21:	eb 20                	jmp    801c43 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801c23:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c31:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801c38:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801c3b:	89 14 24             	mov    %edx,(%esp)
  801c3e:	e8 6d f4 ff ff       	call   8010b0 <fd2num>
}
  801c43:	83 c4 20             	add    $0x20,%esp
  801c46:	5b                   	pop    %ebx
  801c47:	5e                   	pop    %esi
  801c48:	5d                   	pop    %ebp
  801c49:	c3                   	ret    

00801c4a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	e8 51 ff ff ff       	call   801ba9 <fd2sockid>
		return r;
  801c58:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	78 23                	js     801c81 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c5e:	8b 55 10             	mov    0x10(%ebp),%edx
  801c61:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c68:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c6c:	89 04 24             	mov    %eax,(%esp)
  801c6f:	e8 45 01 00 00       	call   801db9 <nsipc_accept>
		return r;
  801c74:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c76:	85 c0                	test   %eax,%eax
  801c78:	78 07                	js     801c81 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801c7a:	e8 5c ff ff ff       	call   801bdb <alloc_sockfd>
  801c7f:	89 c1                	mov    %eax,%ecx
}
  801c81:	89 c8                	mov    %ecx,%eax
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	e8 16 ff ff ff       	call   801ba9 <fd2sockid>
  801c93:	89 c2                	mov    %eax,%edx
  801c95:	85 d2                	test   %edx,%edx
  801c97:	78 16                	js     801caf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801c99:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca7:	89 14 24             	mov    %edx,(%esp)
  801caa:	e8 60 01 00 00       	call   801e0f <nsipc_bind>
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <shutdown>:

int
shutdown(int s, int how)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	e8 ea fe ff ff       	call   801ba9 <fd2sockid>
  801cbf:	89 c2                	mov    %eax,%edx
  801cc1:	85 d2                	test   %edx,%edx
  801cc3:	78 0f                	js     801cd4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ccc:	89 14 24             	mov    %edx,(%esp)
  801ccf:	e8 7a 01 00 00       	call   801e4e <nsipc_shutdown>
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	e8 c5 fe ff ff       	call   801ba9 <fd2sockid>
  801ce4:	89 c2                	mov    %eax,%edx
  801ce6:	85 d2                	test   %edx,%edx
  801ce8:	78 16                	js     801d00 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801cea:	8b 45 10             	mov    0x10(%ebp),%eax
  801ced:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf8:	89 14 24             	mov    %edx,(%esp)
  801cfb:	e8 8a 01 00 00       	call   801e8a <nsipc_connect>
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <listen>:

int
listen(int s, int backlog)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	e8 99 fe ff ff       	call   801ba9 <fd2sockid>
  801d10:	89 c2                	mov    %eax,%edx
  801d12:	85 d2                	test   %edx,%edx
  801d14:	78 0f                	js     801d25 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1d:	89 14 24             	mov    %edx,(%esp)
  801d20:	e8 a4 01 00 00       	call   801ec9 <nsipc_listen>
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d30:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	89 04 24             	mov    %eax,(%esp)
  801d41:	e8 98 02 00 00       	call   801fde <nsipc_socket>
  801d46:	89 c2                	mov    %eax,%edx
  801d48:	85 d2                	test   %edx,%edx
  801d4a:	78 05                	js     801d51 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801d4c:	e8 8a fe ff ff       	call   801bdb <alloc_sockfd>
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	53                   	push   %ebx
  801d57:	83 ec 14             	sub    $0x14,%esp
  801d5a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d5c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d63:	75 11                	jne    801d76 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d65:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801d6c:	e8 9e 08 00 00       	call   80260f <ipc_find_env>
  801d71:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d76:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d7d:	00 
  801d7e:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  801d85:	00 
  801d86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d8a:	a1 04 40 80 00       	mov    0x804004,%eax
  801d8f:	89 04 24             	mov    %eax,(%esp)
  801d92:	e8 11 08 00 00       	call   8025a8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d9e:	00 
  801d9f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801da6:	00 
  801da7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dae:	e8 8d 07 00 00       	call   802540 <ipc_recv>
}
  801db3:	83 c4 14             	add    $0x14,%esp
  801db6:	5b                   	pop    %ebx
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    

00801db9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	56                   	push   %esi
  801dbd:	53                   	push   %ebx
  801dbe:	83 ec 10             	sub    $0x10,%esp
  801dc1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801dcc:	8b 06                	mov    (%esi),%eax
  801dce:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801dd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd8:	e8 76 ff ff ff       	call   801d53 <nsipc>
  801ddd:	89 c3                	mov    %eax,%ebx
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	78 23                	js     801e06 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801de3:	a1 10 80 80 00       	mov    0x808010,%eax
  801de8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dec:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801df3:	00 
  801df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df7:	89 04 24             	mov    %eax,(%esp)
  801dfa:	e8 d5 ec ff ff       	call   800ad4 <memmove>
		*addrlen = ret->ret_addrlen;
  801dff:	a1 10 80 80 00       	mov    0x808010,%eax
  801e04:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801e06:	89 d8                	mov    %ebx,%eax
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	5b                   	pop    %ebx
  801e0c:	5e                   	pop    %esi
  801e0d:	5d                   	pop    %ebp
  801e0e:	c3                   	ret    

00801e0f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	53                   	push   %ebx
  801e13:	83 ec 14             	sub    $0x14,%esp
  801e16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e21:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2c:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  801e33:	e8 9c ec ff ff       	call   800ad4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e38:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801e3e:	b8 02 00 00 00       	mov    $0x2,%eax
  801e43:	e8 0b ff ff ff       	call   801d53 <nsipc>
}
  801e48:	83 c4 14             	add    $0x14,%esp
  801e4b:	5b                   	pop    %ebx
  801e4c:	5d                   	pop    %ebp
  801e4d:	c3                   	ret    

00801e4e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5f:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801e64:	b8 03 00 00 00       	mov    $0x3,%eax
  801e69:	e8 e5 fe ff ff       	call   801d53 <nsipc>
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <nsipc_close>:

int
nsipc_close(int s)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801e7e:	b8 04 00 00 00       	mov    $0x4,%eax
  801e83:	e8 cb fe ff ff       	call   801d53 <nsipc>
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	53                   	push   %ebx
  801e8e:	83 ec 14             	sub    $0x14,%esp
  801e91:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e94:	8b 45 08             	mov    0x8(%ebp),%eax
  801e97:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e9c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea7:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  801eae:	e8 21 ec ff ff       	call   800ad4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801eb3:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801eb9:	b8 05 00 00 00       	mov    $0x5,%eax
  801ebe:	e8 90 fe ff ff       	call   801d53 <nsipc>
}
  801ec3:	83 c4 14             	add    $0x14,%esp
  801ec6:	5b                   	pop    %ebx
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    

00801ec9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eda:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801edf:	b8 06 00 00 00       	mov    $0x6,%eax
  801ee4:	e8 6a fe ff ff       	call   801d53 <nsipc>
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	56                   	push   %esi
  801eef:	53                   	push   %ebx
  801ef0:	83 ec 10             	sub    $0x10,%esp
  801ef3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801efe:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801f04:	8b 45 14             	mov    0x14(%ebp),%eax
  801f07:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f0c:	b8 07 00 00 00       	mov    $0x7,%eax
  801f11:	e8 3d fe ff ff       	call   801d53 <nsipc>
  801f16:	89 c3                	mov    %eax,%ebx
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	78 46                	js     801f62 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801f1c:	39 f0                	cmp    %esi,%eax
  801f1e:	7f 07                	jg     801f27 <nsipc_recv+0x3c>
  801f20:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f25:	7e 24                	jle    801f4b <nsipc_recv+0x60>
  801f27:	c7 44 24 0c d1 2d 80 	movl   $0x802dd1,0xc(%esp)
  801f2e:	00 
  801f2f:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  801f36:	00 
  801f37:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801f3e:	00 
  801f3f:	c7 04 24 e6 2d 80 00 	movl   $0x802de6,(%esp)
  801f46:	e8 7b e2 ff ff       	call   8001c6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f4b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f4f:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801f56:	00 
  801f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5a:	89 04 24             	mov    %eax,(%esp)
  801f5d:	e8 72 eb ff ff       	call   800ad4 <memmove>
	}

	return r;
}
  801f62:	89 d8                	mov    %ebx,%eax
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    

00801f6b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	53                   	push   %ebx
  801f6f:	83 ec 14             	sub    $0x14,%esp
  801f72:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801f7d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f83:	7e 24                	jle    801fa9 <nsipc_send+0x3e>
  801f85:	c7 44 24 0c f2 2d 80 	movl   $0x802df2,0xc(%esp)
  801f8c:	00 
  801f8d:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  801f94:	00 
  801f95:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801f9c:	00 
  801f9d:	c7 04 24 e6 2d 80 00 	movl   $0x802de6,(%esp)
  801fa4:	e8 1d e2 ff ff       	call   8001c6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fa9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb4:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  801fbb:	e8 14 eb ff ff       	call   800ad4 <memmove>
	nsipcbuf.send.req_size = size;
  801fc0:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801fc6:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc9:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801fce:	b8 08 00 00 00       	mov    $0x8,%eax
  801fd3:	e8 7b fd ff ff       	call   801d53 <nsipc>
}
  801fd8:	83 c4 14             	add    $0x14,%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5d                   	pop    %ebp
  801fdd:	c3                   	ret    

00801fde <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fef:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff7:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801ffc:	b8 09 00 00 00       	mov    $0x9,%eax
  802001:	e8 4d fd ff ff       	call   801d53 <nsipc>
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	56                   	push   %esi
  80200c:	53                   	push   %ebx
  80200d:	83 ec 10             	sub    $0x10,%esp
  802010:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	89 04 24             	mov    %eax,(%esp)
  802019:	e8 a2 f0 ff ff       	call   8010c0 <fd2data>
  80201e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802020:	c7 44 24 04 fe 2d 80 	movl   $0x802dfe,0x4(%esp)
  802027:	00 
  802028:	89 1c 24             	mov    %ebx,(%esp)
  80202b:	e8 07 e9 ff ff       	call   800937 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802030:	8b 46 04             	mov    0x4(%esi),%eax
  802033:	2b 06                	sub    (%esi),%eax
  802035:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80203b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802042:	00 00 00 
	stat->st_dev = &devpipe;
  802045:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80204c:	30 80 00 
	return 0;
}
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
  802054:	83 c4 10             	add    $0x10,%esp
  802057:	5b                   	pop    %ebx
  802058:	5e                   	pop    %esi
  802059:	5d                   	pop    %ebp
  80205a:	c3                   	ret    

0080205b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	53                   	push   %ebx
  80205f:	83 ec 14             	sub    $0x14,%esp
  802062:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802065:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802069:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802070:	e8 d7 ed ff ff       	call   800e4c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802075:	89 1c 24             	mov    %ebx,(%esp)
  802078:	e8 43 f0 ff ff       	call   8010c0 <fd2data>
  80207d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802081:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802088:	e8 bf ed ff ff       	call   800e4c <sys_page_unmap>
}
  80208d:	83 c4 14             	add    $0x14,%esp
  802090:	5b                   	pop    %ebx
  802091:	5d                   	pop    %ebp
  802092:	c3                   	ret    

00802093 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	57                   	push   %edi
  802097:	56                   	push   %esi
  802098:	53                   	push   %ebx
  802099:	83 ec 2c             	sub    $0x2c,%esp
  80209c:	89 c6                	mov    %eax,%esi
  80209e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8020a1:	a1 20 60 80 00       	mov    0x806020,%eax
  8020a6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020a9:	89 34 24             	mov    %esi,(%esp)
  8020ac:	e8 96 05 00 00       	call   802647 <pageref>
  8020b1:	89 c7                	mov    %eax,%edi
  8020b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020b6:	89 04 24             	mov    %eax,(%esp)
  8020b9:	e8 89 05 00 00       	call   802647 <pageref>
  8020be:	39 c7                	cmp    %eax,%edi
  8020c0:	0f 94 c2             	sete   %dl
  8020c3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8020c6:	8b 0d 20 60 80 00    	mov    0x806020,%ecx
  8020cc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8020cf:	39 fb                	cmp    %edi,%ebx
  8020d1:	74 21                	je     8020f4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8020d3:	84 d2                	test   %dl,%dl
  8020d5:	74 ca                	je     8020a1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020d7:	8b 51 58             	mov    0x58(%ecx),%edx
  8020da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020e6:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8020ed:	e8 cd e1 ff ff       	call   8002bf <cprintf>
  8020f2:	eb ad                	jmp    8020a1 <_pipeisclosed+0xe>
	}
}
  8020f4:	83 c4 2c             	add    $0x2c,%esp
  8020f7:	5b                   	pop    %ebx
  8020f8:	5e                   	pop    %esi
  8020f9:	5f                   	pop    %edi
  8020fa:	5d                   	pop    %ebp
  8020fb:	c3                   	ret    

008020fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	57                   	push   %edi
  802100:	56                   	push   %esi
  802101:	53                   	push   %ebx
  802102:	83 ec 1c             	sub    $0x1c,%esp
  802105:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802108:	89 34 24             	mov    %esi,(%esp)
  80210b:	e8 b0 ef ff ff       	call   8010c0 <fd2data>
  802110:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802112:	bf 00 00 00 00       	mov    $0x0,%edi
  802117:	eb 45                	jmp    80215e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802119:	89 da                	mov    %ebx,%edx
  80211b:	89 f0                	mov    %esi,%eax
  80211d:	e8 71 ff ff ff       	call   802093 <_pipeisclosed>
  802122:	85 c0                	test   %eax,%eax
  802124:	75 41                	jne    802167 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802126:	e8 5b ec ff ff       	call   800d86 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80212b:	8b 43 04             	mov    0x4(%ebx),%eax
  80212e:	8b 0b                	mov    (%ebx),%ecx
  802130:	8d 51 20             	lea    0x20(%ecx),%edx
  802133:	39 d0                	cmp    %edx,%eax
  802135:	73 e2                	jae    802119 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80213a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80213e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802141:	99                   	cltd   
  802142:	c1 ea 1b             	shr    $0x1b,%edx
  802145:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802148:	83 e1 1f             	and    $0x1f,%ecx
  80214b:	29 d1                	sub    %edx,%ecx
  80214d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802151:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802155:	83 c0 01             	add    $0x1,%eax
  802158:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80215b:	83 c7 01             	add    $0x1,%edi
  80215e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802161:	75 c8                	jne    80212b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802163:	89 f8                	mov    %edi,%eax
  802165:	eb 05                	jmp    80216c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802167:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80216c:	83 c4 1c             	add    $0x1c,%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5f                   	pop    %edi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    

00802174 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	57                   	push   %edi
  802178:	56                   	push   %esi
  802179:	53                   	push   %ebx
  80217a:	83 ec 1c             	sub    $0x1c,%esp
  80217d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802180:	89 3c 24             	mov    %edi,(%esp)
  802183:	e8 38 ef ff ff       	call   8010c0 <fd2data>
  802188:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80218a:	be 00 00 00 00       	mov    $0x0,%esi
  80218f:	eb 3d                	jmp    8021ce <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802191:	85 f6                	test   %esi,%esi
  802193:	74 04                	je     802199 <devpipe_read+0x25>
				return i;
  802195:	89 f0                	mov    %esi,%eax
  802197:	eb 43                	jmp    8021dc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802199:	89 da                	mov    %ebx,%edx
  80219b:	89 f8                	mov    %edi,%eax
  80219d:	e8 f1 fe ff ff       	call   802093 <_pipeisclosed>
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	75 31                	jne    8021d7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8021a6:	e8 db eb ff ff       	call   800d86 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8021ab:	8b 03                	mov    (%ebx),%eax
  8021ad:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021b0:	74 df                	je     802191 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021b2:	99                   	cltd   
  8021b3:	c1 ea 1b             	shr    $0x1b,%edx
  8021b6:	01 d0                	add    %edx,%eax
  8021b8:	83 e0 1f             	and    $0x1f,%eax
  8021bb:	29 d0                	sub    %edx,%eax
  8021bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021c8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021cb:	83 c6 01             	add    $0x1,%esi
  8021ce:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021d1:	75 d8                	jne    8021ab <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8021d3:	89 f0                	mov    %esi,%eax
  8021d5:	eb 05                	jmp    8021dc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021d7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8021dc:	83 c4 1c             	add    $0x1c,%esp
  8021df:	5b                   	pop    %ebx
  8021e0:	5e                   	pop    %esi
  8021e1:	5f                   	pop    %edi
  8021e2:	5d                   	pop    %ebp
  8021e3:	c3                   	ret    

008021e4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	56                   	push   %esi
  8021e8:	53                   	push   %ebx
  8021e9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8021ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ef:	89 04 24             	mov    %eax,(%esp)
  8021f2:	e8 e0 ee ff ff       	call   8010d7 <fd_alloc>
  8021f7:	89 c2                	mov    %eax,%edx
  8021f9:	85 d2                	test   %edx,%edx
  8021fb:	0f 88 4d 01 00 00    	js     80234e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802201:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802208:	00 
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802210:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802217:	e8 89 eb ff ff       	call   800da5 <sys_page_alloc>
  80221c:	89 c2                	mov    %eax,%edx
  80221e:	85 d2                	test   %edx,%edx
  802220:	0f 88 28 01 00 00    	js     80234e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802226:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802229:	89 04 24             	mov    %eax,(%esp)
  80222c:	e8 a6 ee ff ff       	call   8010d7 <fd_alloc>
  802231:	89 c3                	mov    %eax,%ebx
  802233:	85 c0                	test   %eax,%eax
  802235:	0f 88 fe 00 00 00    	js     802339 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80223b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802242:	00 
  802243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802246:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802251:	e8 4f eb ff ff       	call   800da5 <sys_page_alloc>
  802256:	89 c3                	mov    %eax,%ebx
  802258:	85 c0                	test   %eax,%eax
  80225a:	0f 88 d9 00 00 00    	js     802339 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	89 04 24             	mov    %eax,(%esp)
  802266:	e8 55 ee ff ff       	call   8010c0 <fd2data>
  80226b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80226d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802274:	00 
  802275:	89 44 24 04          	mov    %eax,0x4(%esp)
  802279:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802280:	e8 20 eb ff ff       	call   800da5 <sys_page_alloc>
  802285:	89 c3                	mov    %eax,%ebx
  802287:	85 c0                	test   %eax,%eax
  802289:	0f 88 97 00 00 00    	js     802326 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80228f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802292:	89 04 24             	mov    %eax,(%esp)
  802295:	e8 26 ee ff ff       	call   8010c0 <fd2data>
  80229a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8022a1:	00 
  8022a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022ad:	00 
  8022ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b9:	e8 3b eb ff ff       	call   800df9 <sys_page_map>
  8022be:	89 c3                	mov    %eax,%ebx
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	78 52                	js     802316 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8022c4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8022d9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	89 04 24             	mov    %eax,(%esp)
  8022f4:	e8 b7 ed ff ff       	call   8010b0 <fd2num>
  8022f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022fc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802301:	89 04 24             	mov    %eax,(%esp)
  802304:	e8 a7 ed ff ff       	call   8010b0 <fd2num>
  802309:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80230c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80230f:	b8 00 00 00 00       	mov    $0x0,%eax
  802314:	eb 38                	jmp    80234e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802316:	89 74 24 04          	mov    %esi,0x4(%esp)
  80231a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802321:	e8 26 eb ff ff       	call   800e4c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802329:	89 44 24 04          	mov    %eax,0x4(%esp)
  80232d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802334:	e8 13 eb ff ff       	call   800e4c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802340:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802347:	e8 00 eb ff ff       	call   800e4c <sys_page_unmap>
  80234c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80234e:	83 c4 30             	add    $0x30,%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    

00802355 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
  802358:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80235b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80235e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	89 04 24             	mov    %eax,(%esp)
  802368:	e8 b9 ed ff ff       	call   801126 <fd_lookup>
  80236d:	89 c2                	mov    %eax,%edx
  80236f:	85 d2                	test   %edx,%edx
  802371:	78 15                	js     802388 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	89 04 24             	mov    %eax,(%esp)
  802379:	e8 42 ed ff ff       	call   8010c0 <fd2data>
	return _pipeisclosed(fd, p);
  80237e:	89 c2                	mov    %eax,%edx
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	e8 0b fd ff ff       	call   802093 <_pipeisclosed>
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    
  80238a:	66 90                	xchg   %ax,%ax
  80238c:	66 90                	xchg   %ax,%ax
  80238e:	66 90                	xchg   %ax,%ax

00802390 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
  802398:	5d                   	pop    %ebp
  802399:	c3                   	ret    

0080239a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8023a0:	c7 44 24 04 1d 2e 80 	movl   $0x802e1d,0x4(%esp)
  8023a7:	00 
  8023a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ab:	89 04 24             	mov    %eax,(%esp)
  8023ae:	e8 84 e5 ff ff       	call   800937 <strcpy>
	return 0;
}
  8023b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	57                   	push   %edi
  8023be:	56                   	push   %esi
  8023bf:	53                   	push   %ebx
  8023c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023cb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023d1:	eb 31                	jmp    802404 <devcons_write+0x4a>
		m = n - tot;
  8023d3:	8b 75 10             	mov    0x10(%ebp),%esi
  8023d6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8023d8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8023db:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8023e0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023e3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8023e7:	03 45 0c             	add    0xc(%ebp),%eax
  8023ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ee:	89 3c 24             	mov    %edi,(%esp)
  8023f1:	e8 de e6 ff ff       	call   800ad4 <memmove>
		sys_cputs(buf, m);
  8023f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023fa:	89 3c 24             	mov    %edi,(%esp)
  8023fd:	e8 84 e8 ff ff       	call   800c86 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802402:	01 f3                	add    %esi,%ebx
  802404:	89 d8                	mov    %ebx,%eax
  802406:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802409:	72 c8                	jb     8023d3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80240b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802411:	5b                   	pop    %ebx
  802412:	5e                   	pop    %esi
  802413:	5f                   	pop    %edi
  802414:	5d                   	pop    %ebp
  802415:	c3                   	ret    

00802416 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
  802419:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80241c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802421:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802425:	75 07                	jne    80242e <devcons_read+0x18>
  802427:	eb 2a                	jmp    802453 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802429:	e8 58 e9 ff ff       	call   800d86 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80242e:	66 90                	xchg   %ax,%ax
  802430:	e8 6f e8 ff ff       	call   800ca4 <sys_cgetc>
  802435:	85 c0                	test   %eax,%eax
  802437:	74 f0                	je     802429 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802439:	85 c0                	test   %eax,%eax
  80243b:	78 16                	js     802453 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80243d:	83 f8 04             	cmp    $0x4,%eax
  802440:	74 0c                	je     80244e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802442:	8b 55 0c             	mov    0xc(%ebp),%edx
  802445:	88 02                	mov    %al,(%edx)
	return 1;
  802447:	b8 01 00 00 00       	mov    $0x1,%eax
  80244c:	eb 05                	jmp    802453 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80244e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802453:	c9                   	leave  
  802454:	c3                   	ret    

00802455 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
  802458:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80245b:	8b 45 08             	mov    0x8(%ebp),%eax
  80245e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802461:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802468:	00 
  802469:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80246c:	89 04 24             	mov    %eax,(%esp)
  80246f:	e8 12 e8 ff ff       	call   800c86 <sys_cputs>
}
  802474:	c9                   	leave  
  802475:	c3                   	ret    

00802476 <getchar>:

int
getchar(void)
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
  802479:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80247c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802483:	00 
  802484:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802487:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802492:	e8 23 ef ff ff       	call   8013ba <read>
	if (r < 0)
  802497:	85 c0                	test   %eax,%eax
  802499:	78 0f                	js     8024aa <getchar+0x34>
		return r;
	if (r < 1)
  80249b:	85 c0                	test   %eax,%eax
  80249d:	7e 06                	jle    8024a5 <getchar+0x2f>
		return -E_EOF;
	return c;
  80249f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8024a3:	eb 05                	jmp    8024aa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8024a5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	89 04 24             	mov    %eax,(%esp)
  8024bf:	e8 62 ec ff ff       	call   801126 <fd_lookup>
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	78 11                	js     8024d9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024d1:	39 10                	cmp    %edx,(%eax)
  8024d3:	0f 94 c0             	sete   %al
  8024d6:	0f b6 c0             	movzbl %al,%eax
}
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <opencons>:

int
opencons(void)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024e4:	89 04 24             	mov    %eax,(%esp)
  8024e7:	e8 eb eb ff ff       	call   8010d7 <fd_alloc>
		return r;
  8024ec:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	78 40                	js     802532 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024f9:	00 
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802501:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802508:	e8 98 e8 ff ff       	call   800da5 <sys_page_alloc>
		return r;
  80250d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80250f:	85 c0                	test   %eax,%eax
  802511:	78 1f                	js     802532 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802513:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802528:	89 04 24             	mov    %eax,(%esp)
  80252b:	e8 80 eb ff ff       	call   8010b0 <fd2num>
  802530:	89 c2                	mov    %eax,%edx
}
  802532:	89 d0                	mov    %edx,%eax
  802534:	c9                   	leave  
  802535:	c3                   	ret    
  802536:	66 90                	xchg   %ax,%ax
  802538:	66 90                	xchg   %ax,%ax
  80253a:	66 90                	xchg   %ax,%ax
  80253c:	66 90                	xchg   %ax,%ax
  80253e:	66 90                	xchg   %ax,%ax

00802540 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
  802543:	56                   	push   %esi
  802544:	53                   	push   %ebx
  802545:	83 ec 10             	sub    $0x10,%esp
  802548:	8b 75 08             	mov    0x8(%ebp),%esi
  80254b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802551:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802553:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802558:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80255b:	89 04 24             	mov    %eax,(%esp)
  80255e:	e8 78 ea ff ff       	call   800fdb <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802563:	85 c0                	test   %eax,%eax
  802565:	75 26                	jne    80258d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802567:	85 f6                	test   %esi,%esi
  802569:	74 0a                	je     802575 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80256b:	a1 20 60 80 00       	mov    0x806020,%eax
  802570:	8b 40 74             	mov    0x74(%eax),%eax
  802573:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802575:	85 db                	test   %ebx,%ebx
  802577:	74 0a                	je     802583 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802579:	a1 20 60 80 00       	mov    0x806020,%eax
  80257e:	8b 40 78             	mov    0x78(%eax),%eax
  802581:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802583:	a1 20 60 80 00       	mov    0x806020,%eax
  802588:	8b 40 70             	mov    0x70(%eax),%eax
  80258b:	eb 14                	jmp    8025a1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80258d:	85 f6                	test   %esi,%esi
  80258f:	74 06                	je     802597 <ipc_recv+0x57>
			*from_env_store = 0;
  802591:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802597:	85 db                	test   %ebx,%ebx
  802599:	74 06                	je     8025a1 <ipc_recv+0x61>
			*perm_store = 0;
  80259b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  8025a1:	83 c4 10             	add    $0x10,%esp
  8025a4:	5b                   	pop    %ebx
  8025a5:	5e                   	pop    %esi
  8025a6:	5d                   	pop    %ebp
  8025a7:	c3                   	ret    

008025a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	57                   	push   %edi
  8025ac:	56                   	push   %esi
  8025ad:	53                   	push   %ebx
  8025ae:	83 ec 1c             	sub    $0x1c,%esp
  8025b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8025b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8025b7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  8025ba:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  8025bc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8025c1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8025c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8025c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025d3:	89 3c 24             	mov    %edi,(%esp)
  8025d6:	e8 dd e9 ff ff       	call   800fb8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	74 28                	je     802607 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  8025df:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025e2:	74 1c                	je     802600 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  8025e4:	c7 44 24 08 2c 2e 80 	movl   $0x802e2c,0x8(%esp)
  8025eb:	00 
  8025ec:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8025f3:	00 
  8025f4:	c7 04 24 50 2e 80 00 	movl   $0x802e50,(%esp)
  8025fb:	e8 c6 db ff ff       	call   8001c6 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802600:	e8 81 e7 ff ff       	call   800d86 <sys_yield>
	}
  802605:	eb bd                	jmp    8025c4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802607:	83 c4 1c             	add    $0x1c,%esp
  80260a:	5b                   	pop    %ebx
  80260b:	5e                   	pop    %esi
  80260c:	5f                   	pop    %edi
  80260d:	5d                   	pop    %ebp
  80260e:	c3                   	ret    

0080260f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
  802612:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802615:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80261a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80261d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802623:	8b 52 50             	mov    0x50(%edx),%edx
  802626:	39 ca                	cmp    %ecx,%edx
  802628:	75 0d                	jne    802637 <ipc_find_env+0x28>
			return envs[i].env_id;
  80262a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80262d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802632:	8b 40 40             	mov    0x40(%eax),%eax
  802635:	eb 0e                	jmp    802645 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802637:	83 c0 01             	add    $0x1,%eax
  80263a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80263f:	75 d9                	jne    80261a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802641:	66 b8 00 00          	mov    $0x0,%ax
}
  802645:	5d                   	pop    %ebp
  802646:	c3                   	ret    

00802647 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802647:	55                   	push   %ebp
  802648:	89 e5                	mov    %esp,%ebp
  80264a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80264d:	89 d0                	mov    %edx,%eax
  80264f:	c1 e8 16             	shr    $0x16,%eax
  802652:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80265e:	f6 c1 01             	test   $0x1,%cl
  802661:	74 1d                	je     802680 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802663:	c1 ea 0c             	shr    $0xc,%edx
  802666:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80266d:	f6 c2 01             	test   $0x1,%dl
  802670:	74 0e                	je     802680 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802672:	c1 ea 0c             	shr    $0xc,%edx
  802675:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80267c:	ef 
  80267d:	0f b7 c0             	movzwl %ax,%eax
}
  802680:	5d                   	pop    %ebp
  802681:	c3                   	ret    
  802682:	66 90                	xchg   %ax,%ax
  802684:	66 90                	xchg   %ax,%ax
  802686:	66 90                	xchg   %ax,%ax
  802688:	66 90                	xchg   %ax,%ax
  80268a:	66 90                	xchg   %ax,%ax
  80268c:	66 90                	xchg   %ax,%ax
  80268e:	66 90                	xchg   %ax,%ax

00802690 <__udivdi3>:
  802690:	55                   	push   %ebp
  802691:	57                   	push   %edi
  802692:	56                   	push   %esi
  802693:	83 ec 0c             	sub    $0xc,%esp
  802696:	8b 44 24 28          	mov    0x28(%esp),%eax
  80269a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80269e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8026a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8026ac:	89 ea                	mov    %ebp,%edx
  8026ae:	89 0c 24             	mov    %ecx,(%esp)
  8026b1:	75 2d                	jne    8026e0 <__udivdi3+0x50>
  8026b3:	39 e9                	cmp    %ebp,%ecx
  8026b5:	77 61                	ja     802718 <__udivdi3+0x88>
  8026b7:	85 c9                	test   %ecx,%ecx
  8026b9:	89 ce                	mov    %ecx,%esi
  8026bb:	75 0b                	jne    8026c8 <__udivdi3+0x38>
  8026bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c2:	31 d2                	xor    %edx,%edx
  8026c4:	f7 f1                	div    %ecx
  8026c6:	89 c6                	mov    %eax,%esi
  8026c8:	31 d2                	xor    %edx,%edx
  8026ca:	89 e8                	mov    %ebp,%eax
  8026cc:	f7 f6                	div    %esi
  8026ce:	89 c5                	mov    %eax,%ebp
  8026d0:	89 f8                	mov    %edi,%eax
  8026d2:	f7 f6                	div    %esi
  8026d4:	89 ea                	mov    %ebp,%edx
  8026d6:	83 c4 0c             	add    $0xc,%esp
  8026d9:	5e                   	pop    %esi
  8026da:	5f                   	pop    %edi
  8026db:	5d                   	pop    %ebp
  8026dc:	c3                   	ret    
  8026dd:	8d 76 00             	lea    0x0(%esi),%esi
  8026e0:	39 e8                	cmp    %ebp,%eax
  8026e2:	77 24                	ja     802708 <__udivdi3+0x78>
  8026e4:	0f bd e8             	bsr    %eax,%ebp
  8026e7:	83 f5 1f             	xor    $0x1f,%ebp
  8026ea:	75 3c                	jne    802728 <__udivdi3+0x98>
  8026ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8026f0:	39 34 24             	cmp    %esi,(%esp)
  8026f3:	0f 86 9f 00 00 00    	jbe    802798 <__udivdi3+0x108>
  8026f9:	39 d0                	cmp    %edx,%eax
  8026fb:	0f 82 97 00 00 00    	jb     802798 <__udivdi3+0x108>
  802701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802708:	31 d2                	xor    %edx,%edx
  80270a:	31 c0                	xor    %eax,%eax
  80270c:	83 c4 0c             	add    $0xc,%esp
  80270f:	5e                   	pop    %esi
  802710:	5f                   	pop    %edi
  802711:	5d                   	pop    %ebp
  802712:	c3                   	ret    
  802713:	90                   	nop
  802714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802718:	89 f8                	mov    %edi,%eax
  80271a:	f7 f1                	div    %ecx
  80271c:	31 d2                	xor    %edx,%edx
  80271e:	83 c4 0c             	add    $0xc,%esp
  802721:	5e                   	pop    %esi
  802722:	5f                   	pop    %edi
  802723:	5d                   	pop    %ebp
  802724:	c3                   	ret    
  802725:	8d 76 00             	lea    0x0(%esi),%esi
  802728:	89 e9                	mov    %ebp,%ecx
  80272a:	8b 3c 24             	mov    (%esp),%edi
  80272d:	d3 e0                	shl    %cl,%eax
  80272f:	89 c6                	mov    %eax,%esi
  802731:	b8 20 00 00 00       	mov    $0x20,%eax
  802736:	29 e8                	sub    %ebp,%eax
  802738:	89 c1                	mov    %eax,%ecx
  80273a:	d3 ef                	shr    %cl,%edi
  80273c:	89 e9                	mov    %ebp,%ecx
  80273e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802742:	8b 3c 24             	mov    (%esp),%edi
  802745:	09 74 24 08          	or     %esi,0x8(%esp)
  802749:	89 d6                	mov    %edx,%esi
  80274b:	d3 e7                	shl    %cl,%edi
  80274d:	89 c1                	mov    %eax,%ecx
  80274f:	89 3c 24             	mov    %edi,(%esp)
  802752:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802756:	d3 ee                	shr    %cl,%esi
  802758:	89 e9                	mov    %ebp,%ecx
  80275a:	d3 e2                	shl    %cl,%edx
  80275c:	89 c1                	mov    %eax,%ecx
  80275e:	d3 ef                	shr    %cl,%edi
  802760:	09 d7                	or     %edx,%edi
  802762:	89 f2                	mov    %esi,%edx
  802764:	89 f8                	mov    %edi,%eax
  802766:	f7 74 24 08          	divl   0x8(%esp)
  80276a:	89 d6                	mov    %edx,%esi
  80276c:	89 c7                	mov    %eax,%edi
  80276e:	f7 24 24             	mull   (%esp)
  802771:	39 d6                	cmp    %edx,%esi
  802773:	89 14 24             	mov    %edx,(%esp)
  802776:	72 30                	jb     8027a8 <__udivdi3+0x118>
  802778:	8b 54 24 04          	mov    0x4(%esp),%edx
  80277c:	89 e9                	mov    %ebp,%ecx
  80277e:	d3 e2                	shl    %cl,%edx
  802780:	39 c2                	cmp    %eax,%edx
  802782:	73 05                	jae    802789 <__udivdi3+0xf9>
  802784:	3b 34 24             	cmp    (%esp),%esi
  802787:	74 1f                	je     8027a8 <__udivdi3+0x118>
  802789:	89 f8                	mov    %edi,%eax
  80278b:	31 d2                	xor    %edx,%edx
  80278d:	e9 7a ff ff ff       	jmp    80270c <__udivdi3+0x7c>
  802792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802798:	31 d2                	xor    %edx,%edx
  80279a:	b8 01 00 00 00       	mov    $0x1,%eax
  80279f:	e9 68 ff ff ff       	jmp    80270c <__udivdi3+0x7c>
  8027a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027a8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8027ab:	31 d2                	xor    %edx,%edx
  8027ad:	83 c4 0c             	add    $0xc,%esp
  8027b0:	5e                   	pop    %esi
  8027b1:	5f                   	pop    %edi
  8027b2:	5d                   	pop    %ebp
  8027b3:	c3                   	ret    
  8027b4:	66 90                	xchg   %ax,%ax
  8027b6:	66 90                	xchg   %ax,%ax
  8027b8:	66 90                	xchg   %ax,%ax
  8027ba:	66 90                	xchg   %ax,%ax
  8027bc:	66 90                	xchg   %ax,%ax
  8027be:	66 90                	xchg   %ax,%ax

008027c0 <__umoddi3>:
  8027c0:	55                   	push   %ebp
  8027c1:	57                   	push   %edi
  8027c2:	56                   	push   %esi
  8027c3:	83 ec 14             	sub    $0x14,%esp
  8027c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8027ca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8027ce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8027d2:	89 c7                	mov    %eax,%edi
  8027d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8027dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8027e0:	89 34 24             	mov    %esi,(%esp)
  8027e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	89 c2                	mov    %eax,%edx
  8027eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027ef:	75 17                	jne    802808 <__umoddi3+0x48>
  8027f1:	39 fe                	cmp    %edi,%esi
  8027f3:	76 4b                	jbe    802840 <__umoddi3+0x80>
  8027f5:	89 c8                	mov    %ecx,%eax
  8027f7:	89 fa                	mov    %edi,%edx
  8027f9:	f7 f6                	div    %esi
  8027fb:	89 d0                	mov    %edx,%eax
  8027fd:	31 d2                	xor    %edx,%edx
  8027ff:	83 c4 14             	add    $0x14,%esp
  802802:	5e                   	pop    %esi
  802803:	5f                   	pop    %edi
  802804:	5d                   	pop    %ebp
  802805:	c3                   	ret    
  802806:	66 90                	xchg   %ax,%ax
  802808:	39 f8                	cmp    %edi,%eax
  80280a:	77 54                	ja     802860 <__umoddi3+0xa0>
  80280c:	0f bd e8             	bsr    %eax,%ebp
  80280f:	83 f5 1f             	xor    $0x1f,%ebp
  802812:	75 5c                	jne    802870 <__umoddi3+0xb0>
  802814:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802818:	39 3c 24             	cmp    %edi,(%esp)
  80281b:	0f 87 e7 00 00 00    	ja     802908 <__umoddi3+0x148>
  802821:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802825:	29 f1                	sub    %esi,%ecx
  802827:	19 c7                	sbb    %eax,%edi
  802829:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80282d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802831:	8b 44 24 08          	mov    0x8(%esp),%eax
  802835:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802839:	83 c4 14             	add    $0x14,%esp
  80283c:	5e                   	pop    %esi
  80283d:	5f                   	pop    %edi
  80283e:	5d                   	pop    %ebp
  80283f:	c3                   	ret    
  802840:	85 f6                	test   %esi,%esi
  802842:	89 f5                	mov    %esi,%ebp
  802844:	75 0b                	jne    802851 <__umoddi3+0x91>
  802846:	b8 01 00 00 00       	mov    $0x1,%eax
  80284b:	31 d2                	xor    %edx,%edx
  80284d:	f7 f6                	div    %esi
  80284f:	89 c5                	mov    %eax,%ebp
  802851:	8b 44 24 04          	mov    0x4(%esp),%eax
  802855:	31 d2                	xor    %edx,%edx
  802857:	f7 f5                	div    %ebp
  802859:	89 c8                	mov    %ecx,%eax
  80285b:	f7 f5                	div    %ebp
  80285d:	eb 9c                	jmp    8027fb <__umoddi3+0x3b>
  80285f:	90                   	nop
  802860:	89 c8                	mov    %ecx,%eax
  802862:	89 fa                	mov    %edi,%edx
  802864:	83 c4 14             	add    $0x14,%esp
  802867:	5e                   	pop    %esi
  802868:	5f                   	pop    %edi
  802869:	5d                   	pop    %ebp
  80286a:	c3                   	ret    
  80286b:	90                   	nop
  80286c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802870:	8b 04 24             	mov    (%esp),%eax
  802873:	be 20 00 00 00       	mov    $0x20,%esi
  802878:	89 e9                	mov    %ebp,%ecx
  80287a:	29 ee                	sub    %ebp,%esi
  80287c:	d3 e2                	shl    %cl,%edx
  80287e:	89 f1                	mov    %esi,%ecx
  802880:	d3 e8                	shr    %cl,%eax
  802882:	89 e9                	mov    %ebp,%ecx
  802884:	89 44 24 04          	mov    %eax,0x4(%esp)
  802888:	8b 04 24             	mov    (%esp),%eax
  80288b:	09 54 24 04          	or     %edx,0x4(%esp)
  80288f:	89 fa                	mov    %edi,%edx
  802891:	d3 e0                	shl    %cl,%eax
  802893:	89 f1                	mov    %esi,%ecx
  802895:	89 44 24 08          	mov    %eax,0x8(%esp)
  802899:	8b 44 24 10          	mov    0x10(%esp),%eax
  80289d:	d3 ea                	shr    %cl,%edx
  80289f:	89 e9                	mov    %ebp,%ecx
  8028a1:	d3 e7                	shl    %cl,%edi
  8028a3:	89 f1                	mov    %esi,%ecx
  8028a5:	d3 e8                	shr    %cl,%eax
  8028a7:	89 e9                	mov    %ebp,%ecx
  8028a9:	09 f8                	or     %edi,%eax
  8028ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8028af:	f7 74 24 04          	divl   0x4(%esp)
  8028b3:	d3 e7                	shl    %cl,%edi
  8028b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028b9:	89 d7                	mov    %edx,%edi
  8028bb:	f7 64 24 08          	mull   0x8(%esp)
  8028bf:	39 d7                	cmp    %edx,%edi
  8028c1:	89 c1                	mov    %eax,%ecx
  8028c3:	89 14 24             	mov    %edx,(%esp)
  8028c6:	72 2c                	jb     8028f4 <__umoddi3+0x134>
  8028c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8028cc:	72 22                	jb     8028f0 <__umoddi3+0x130>
  8028ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8028d2:	29 c8                	sub    %ecx,%eax
  8028d4:	19 d7                	sbb    %edx,%edi
  8028d6:	89 e9                	mov    %ebp,%ecx
  8028d8:	89 fa                	mov    %edi,%edx
  8028da:	d3 e8                	shr    %cl,%eax
  8028dc:	89 f1                	mov    %esi,%ecx
  8028de:	d3 e2                	shl    %cl,%edx
  8028e0:	89 e9                	mov    %ebp,%ecx
  8028e2:	d3 ef                	shr    %cl,%edi
  8028e4:	09 d0                	or     %edx,%eax
  8028e6:	89 fa                	mov    %edi,%edx
  8028e8:	83 c4 14             	add    $0x14,%esp
  8028eb:	5e                   	pop    %esi
  8028ec:	5f                   	pop    %edi
  8028ed:	5d                   	pop    %ebp
  8028ee:	c3                   	ret    
  8028ef:	90                   	nop
  8028f0:	39 d7                	cmp    %edx,%edi
  8028f2:	75 da                	jne    8028ce <__umoddi3+0x10e>
  8028f4:	8b 14 24             	mov    (%esp),%edx
  8028f7:	89 c1                	mov    %eax,%ecx
  8028f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8028fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802901:	eb cb                	jmp    8028ce <__umoddi3+0x10e>
  802903:	90                   	nop
  802904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802908:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80290c:	0f 82 0f ff ff ff    	jb     802821 <__umoddi3+0x61>
  802912:	e9 1a ff ff ff       	jmp    802831 <__umoddi3+0x71>
