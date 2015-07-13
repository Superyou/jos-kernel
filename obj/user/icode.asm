
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 27 01 00 00       	call   800158 <libmain>
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
  800038:	81 ec 30 02 00 00    	sub    $0x230,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 40 80 00 80 	movl   $0x802e80,0x804000
  800045:	2e 80 00 

	cprintf("icode startup\n");
  800048:	c7 04 24 86 2e 80 00 	movl   $0x802e86,(%esp)
  80004f:	e8 5e 02 00 00       	call   8002b2 <cprintf>

	cprintf("icode: open /motd\n");
  800054:	c7 04 24 95 2e 80 00 	movl   $0x802e95,(%esp)
  80005b:	e8 52 02 00 00       	call   8002b2 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800060:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800067:	00 
  800068:	c7 04 24 a8 2e 80 00 	movl   $0x802ea8,(%esp)
  80006f:	e8 80 18 00 00       	call   8018f4 <open>
  800074:	89 c6                	mov    %eax,%esi
  800076:	85 c0                	test   %eax,%eax
  800078:	79 20                	jns    80009a <umain+0x67>
		panic("icode: open /motd: %e", fd);
  80007a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80007e:	c7 44 24 08 ae 2e 80 	movl   $0x802eae,0x8(%esp)
  800085:	00 
  800086:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  80008d:	00 
  80008e:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  800095:	e8 1f 01 00 00       	call   8001b9 <_panic>

	cprintf("icode: read /motd\n");
  80009a:	c7 04 24 d1 2e 80 00 	movl   $0x802ed1,(%esp)
  8000a1:	e8 0c 02 00 00       	call   8002b2 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000a6:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  8000ac:	eb 0c                	jmp    8000ba <umain+0x87>
		sys_cputs(buf, n);
  8000ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b2:	89 1c 24             	mov    %ebx,(%esp)
  8000b5:	e8 bc 0b 00 00       	call   800c76 <sys_cputs>
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ba:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8000c1:	00 
  8000c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000c6:	89 34 24             	mov    %esi,(%esp)
  8000c9:	e8 dc 12 00 00       	call   8013aa <read>
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	7f dc                	jg     8000ae <umain+0x7b>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000d2:	c7 04 24 e4 2e 80 00 	movl   $0x802ee4,(%esp)
  8000d9:	e8 d4 01 00 00       	call   8002b2 <cprintf>
	close(fd);
  8000de:	89 34 24             	mov    %esi,(%esp)
  8000e1:	e8 61 11 00 00       	call   801247 <close>

	cprintf("icode: spawn /init\n");
  8000e6:	c7 04 24 f8 2e 80 00 	movl   $0x802ef8,(%esp)
  8000ed:	e8 c0 01 00 00       	call   8002b2 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000f2:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8000f9:	00 
  8000fa:	c7 44 24 0c 0c 2f 80 	movl   $0x802f0c,0xc(%esp)
  800101:	00 
  800102:	c7 44 24 08 15 2f 80 	movl   $0x802f15,0x8(%esp)
  800109:	00 
  80010a:	c7 44 24 04 1f 2f 80 	movl   $0x802f1f,0x4(%esp)
  800111:	00 
  800112:	c7 04 24 1e 2f 80 00 	movl   $0x802f1e,(%esp)
  800119:	e8 b4 1e 00 00       	call   801fd2 <spawnl>
  80011e:	85 c0                	test   %eax,%eax
  800120:	79 20                	jns    800142 <umain+0x10f>
		panic("icode: spawn /init: %e", r);
  800122:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800126:	c7 44 24 08 24 2f 80 	movl   $0x802f24,0x8(%esp)
  80012d:	00 
  80012e:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800135:	00 
  800136:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
  80013d:	e8 77 00 00 00       	call   8001b9 <_panic>

	cprintf("icode: exiting\n");
  800142:	c7 04 24 3b 2f 80 00 	movl   $0x802f3b,(%esp)
  800149:	e8 64 01 00 00       	call   8002b2 <cprintf>
}
  80014e:	81 c4 30 02 00 00    	add    $0x230,%esp
  800154:	5b                   	pop    %ebx
  800155:	5e                   	pop    %esi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    

00800158 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
  80015d:	83 ec 10             	sub    $0x10,%esp
  800160:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800163:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800166:	e8 ec 0b 00 00       	call   800d57 <sys_getenvid>
  80016b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800170:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800173:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800178:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017d:	85 db                	test   %ebx,%ebx
  80017f:	7e 07                	jle    800188 <libmain+0x30>
		binaryname = argv[0];
  800181:	8b 06                	mov    (%esi),%eax
  800183:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800188:	89 74 24 04          	mov    %esi,0x4(%esp)
  80018c:	89 1c 24             	mov    %ebx,(%esp)
  80018f:	e8 9f fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800194:	e8 07 00 00 00       	call   8001a0 <exit>
}
  800199:	83 c4 10             	add    $0x10,%esp
  80019c:	5b                   	pop    %ebx
  80019d:	5e                   	pop    %esi
  80019e:	5d                   	pop    %ebp
  80019f:	c3                   	ret    

008001a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001a6:	e8 cf 10 00 00       	call   80127a <close_all>
	sys_env_destroy(0);
  8001ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001b2:	e8 fc 0a 00 00       	call   800cb3 <sys_env_destroy>
}
  8001b7:	c9                   	leave  
  8001b8:	c3                   	ret    

008001b9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	56                   	push   %esi
  8001bd:	53                   	push   %ebx
  8001be:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001c1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001c4:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001ca:	e8 88 0b 00 00       	call   800d57 <sys_getenvid>
  8001cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001dd:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e5:	c7 04 24 58 2f 80 00 	movl   $0x802f58,(%esp)
  8001ec:	e8 c1 00 00 00       	call   8002b2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001f1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f8:	89 04 24             	mov    %eax,(%esp)
  8001fb:	e8 51 00 00 00       	call   800251 <vcprintf>
	cprintf("\n");
  800200:	c7 04 24 a3 33 80 00 	movl   $0x8033a3,(%esp)
  800207:	e8 a6 00 00 00       	call   8002b2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80020c:	cc                   	int3   
  80020d:	eb fd                	jmp    80020c <_panic+0x53>

0080020f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	53                   	push   %ebx
  800213:	83 ec 14             	sub    $0x14,%esp
  800216:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800219:	8b 13                	mov    (%ebx),%edx
  80021b:	8d 42 01             	lea    0x1(%edx),%eax
  80021e:	89 03                	mov    %eax,(%ebx)
  800220:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800223:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800227:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022c:	75 19                	jne    800247 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80022e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800235:	00 
  800236:	8d 43 08             	lea    0x8(%ebx),%eax
  800239:	89 04 24             	mov    %eax,(%esp)
  80023c:	e8 35 0a 00 00       	call   800c76 <sys_cputs>
		b->idx = 0;
  800241:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800247:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80024b:	83 c4 14             	add    $0x14,%esp
  80024e:	5b                   	pop    %ebx
  80024f:	5d                   	pop    %ebp
  800250:	c3                   	ret    

00800251 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80025a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800261:	00 00 00 
	b.cnt = 0;
  800264:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80026b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800271:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800275:	8b 45 08             	mov    0x8(%ebp),%eax
  800278:	89 44 24 08          	mov    %eax,0x8(%esp)
  80027c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800282:	89 44 24 04          	mov    %eax,0x4(%esp)
  800286:	c7 04 24 0f 02 80 00 	movl   $0x80020f,(%esp)
  80028d:	e8 72 01 00 00       	call   800404 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800292:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800298:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a2:	89 04 24             	mov    %eax,(%esp)
  8002a5:	e8 cc 09 00 00       	call   800c76 <sys_cputs>

	return b.cnt;
}
  8002aa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	89 04 24             	mov    %eax,(%esp)
  8002c5:	e8 87 ff ff ff       	call   800251 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    
  8002cc:	66 90                	xchg   %ax,%ax
  8002ce:	66 90                	xchg   %ax,%ax

008002d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	57                   	push   %edi
  8002d4:	56                   	push   %esi
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 3c             	sub    $0x3c,%esp
  8002d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002dc:	89 d7                	mov    %edx,%edi
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e7:	89 c3                	mov    %eax,%ebx
  8002e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002fa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002fd:	39 d9                	cmp    %ebx,%ecx
  8002ff:	72 05                	jb     800306 <printnum+0x36>
  800301:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800304:	77 69                	ja     80036f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800306:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800309:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80030d:	83 ee 01             	sub    $0x1,%esi
  800310:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800314:	89 44 24 08          	mov    %eax,0x8(%esp)
  800318:	8b 44 24 08          	mov    0x8(%esp),%eax
  80031c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800320:	89 c3                	mov    %eax,%ebx
  800322:	89 d6                	mov    %edx,%esi
  800324:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800327:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80032a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80032e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033f:	e8 9c 28 00 00       	call   802be0 <__udivdi3>
  800344:	89 d9                	mov    %ebx,%ecx
  800346:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80034a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80034e:	89 04 24             	mov    %eax,(%esp)
  800351:	89 54 24 04          	mov    %edx,0x4(%esp)
  800355:	89 fa                	mov    %edi,%edx
  800357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80035a:	e8 71 ff ff ff       	call   8002d0 <printnum>
  80035f:	eb 1b                	jmp    80037c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800361:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800365:	8b 45 18             	mov    0x18(%ebp),%eax
  800368:	89 04 24             	mov    %eax,(%esp)
  80036b:	ff d3                	call   *%ebx
  80036d:	eb 03                	jmp    800372 <printnum+0xa2>
  80036f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800372:	83 ee 01             	sub    $0x1,%esi
  800375:	85 f6                	test   %esi,%esi
  800377:	7f e8                	jg     800361 <printnum+0x91>
  800379:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80037c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800380:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800384:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800387:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80038a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80038e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800395:	89 04 24             	mov    %eax,(%esp)
  800398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039f:	e8 6c 29 00 00       	call   802d10 <__umoddi3>
  8003a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a8:	0f be 80 7b 2f 80 00 	movsbl 0x802f7b(%eax),%eax
  8003af:	89 04 24             	mov    %eax,(%esp)
  8003b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b5:	ff d0                	call   *%eax
}
  8003b7:	83 c4 3c             	add    $0x3c,%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c9:	8b 10                	mov    (%eax),%edx
  8003cb:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ce:	73 0a                	jae    8003da <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003d3:	89 08                	mov    %ecx,(%eax)
  8003d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d8:	88 02                	mov    %al,(%edx)
}
  8003da:	5d                   	pop    %ebp
  8003db:	c3                   	ret    

008003dc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003e2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	89 04 24             	mov    %eax,(%esp)
  8003fd:	e8 02 00 00 00       	call   800404 <vprintfmt>
	va_end(ap);
}
  800402:	c9                   	leave  
  800403:	c3                   	ret    

00800404 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	57                   	push   %edi
  800408:	56                   	push   %esi
  800409:	53                   	push   %ebx
  80040a:	83 ec 3c             	sub    $0x3c,%esp
  80040d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800410:	eb 17                	jmp    800429 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800412:	85 c0                	test   %eax,%eax
  800414:	0f 84 4b 04 00 00    	je     800865 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80041a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80041d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800421:	89 04 24             	mov    %eax,(%esp)
  800424:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800427:	89 fb                	mov    %edi,%ebx
  800429:	8d 7b 01             	lea    0x1(%ebx),%edi
  80042c:	0f b6 03             	movzbl (%ebx),%eax
  80042f:	83 f8 25             	cmp    $0x25,%eax
  800432:	75 de                	jne    800412 <vprintfmt+0xe>
  800434:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800438:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80043f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800444:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80044b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800450:	eb 18                	jmp    80046a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800452:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800454:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800458:	eb 10                	jmp    80046a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80045c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800460:	eb 08                	jmp    80046a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800462:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800465:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80046d:	0f b6 17             	movzbl (%edi),%edx
  800470:	0f b6 c2             	movzbl %dl,%eax
  800473:	83 ea 23             	sub    $0x23,%edx
  800476:	80 fa 55             	cmp    $0x55,%dl
  800479:	0f 87 c2 03 00 00    	ja     800841 <vprintfmt+0x43d>
  80047f:	0f b6 d2             	movzbl %dl,%edx
  800482:	ff 24 95 c0 30 80 00 	jmp    *0x8030c0(,%edx,4)
  800489:	89 df                	mov    %ebx,%edi
  80048b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800490:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800493:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800497:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80049a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80049d:	83 fa 09             	cmp    $0x9,%edx
  8004a0:	77 33                	ja     8004d5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004a2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004a5:	eb e9                	jmp    800490 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004aa:	8b 30                	mov    (%eax),%esi
  8004ac:	8d 40 04             	lea    0x4(%eax),%eax
  8004af:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004b4:	eb 1f                	jmp    8004d5 <vprintfmt+0xd1>
  8004b6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004b9:	85 ff                	test   %edi,%edi
  8004bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c0:	0f 49 c7             	cmovns %edi,%eax
  8004c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c6:	89 df                	mov    %ebx,%edi
  8004c8:	eb a0                	jmp    80046a <vprintfmt+0x66>
  8004ca:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004cc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8004d3:	eb 95                	jmp    80046a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8004d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d9:	79 8f                	jns    80046a <vprintfmt+0x66>
  8004db:	eb 85                	jmp    800462 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004dd:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004e2:	eb 86                	jmp    80046a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e7:	8d 70 04             	lea    0x4(%eax),%esi
  8004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	89 04 24             	mov    %eax,(%esp)
  8004f9:	ff 55 08             	call   *0x8(%ebp)
  8004fc:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8004ff:	e9 25 ff ff ff       	jmp    800429 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8d 70 04             	lea    0x4(%eax),%esi
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	99                   	cltd   
  80050d:	31 d0                	xor    %edx,%eax
  80050f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800511:	83 f8 15             	cmp    $0x15,%eax
  800514:	7f 0b                	jg     800521 <vprintfmt+0x11d>
  800516:	8b 14 85 20 32 80 00 	mov    0x803220(,%eax,4),%edx
  80051d:	85 d2                	test   %edx,%edx
  80051f:	75 26                	jne    800547 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800521:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800525:	c7 44 24 08 93 2f 80 	movl   $0x802f93,0x8(%esp)
  80052c:	00 
  80052d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800530:	89 44 24 04          	mov    %eax,0x4(%esp)
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	89 04 24             	mov    %eax,(%esp)
  80053a:	e8 9d fe ff ff       	call   8003dc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80053f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800542:	e9 e2 fe ff ff       	jmp    800429 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800547:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80054b:	c7 44 24 08 72 33 80 	movl   $0x803372,0x8(%esp)
  800552:	00 
  800553:	8b 45 0c             	mov    0xc(%ebp),%eax
  800556:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	89 04 24             	mov    %eax,(%esp)
  800560:	e8 77 fe ff ff       	call   8003dc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800565:	89 75 14             	mov    %esi,0x14(%ebp)
  800568:	e9 bc fe ff ff       	jmp    800429 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800573:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800576:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80057a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80057c:	85 ff                	test   %edi,%edi
  80057e:	b8 8c 2f 80 00       	mov    $0x802f8c,%eax
  800583:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800586:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80058a:	0f 84 94 00 00 00    	je     800624 <vprintfmt+0x220>
  800590:	85 c9                	test   %ecx,%ecx
  800592:	0f 8e 94 00 00 00    	jle    80062c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800598:	89 74 24 04          	mov    %esi,0x4(%esp)
  80059c:	89 3c 24             	mov    %edi,(%esp)
  80059f:	e8 64 03 00 00       	call   800908 <strnlen>
  8005a4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005a7:	29 c1                	sub    %eax,%ecx
  8005a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  8005ac:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  8005b0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8005b3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005b9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005bc:	89 cb                	mov    %ecx,%ebx
  8005be:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c0:	eb 0f                	jmp    8005d1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  8005c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c9:	89 3c 24             	mov    %edi,(%esp)
  8005cc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ce:	83 eb 01             	sub    $0x1,%ebx
  8005d1:	85 db                	test   %ebx,%ebx
  8005d3:	7f ed                	jg     8005c2 <vprintfmt+0x1be>
  8005d5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005de:	85 c9                	test   %ecx,%ecx
  8005e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e5:	0f 49 c1             	cmovns %ecx,%eax
  8005e8:	29 c1                	sub    %eax,%ecx
  8005ea:	89 cb                	mov    %ecx,%ebx
  8005ec:	eb 44                	jmp    800632 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f2:	74 1e                	je     800612 <vprintfmt+0x20e>
  8005f4:	0f be d2             	movsbl %dl,%edx
  8005f7:	83 ea 20             	sub    $0x20,%edx
  8005fa:	83 fa 5e             	cmp    $0x5e,%edx
  8005fd:	76 13                	jbe    800612 <vprintfmt+0x20e>
					putch('?', putdat);
  8005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800602:	89 44 24 04          	mov    %eax,0x4(%esp)
  800606:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80060d:	ff 55 08             	call   *0x8(%ebp)
  800610:	eb 0d                	jmp    80061f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800612:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800615:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800619:	89 04 24             	mov    %eax,(%esp)
  80061c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061f:	83 eb 01             	sub    $0x1,%ebx
  800622:	eb 0e                	jmp    800632 <vprintfmt+0x22e>
  800624:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800627:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80062a:	eb 06                	jmp    800632 <vprintfmt+0x22e>
  80062c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80062f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800632:	83 c7 01             	add    $0x1,%edi
  800635:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800639:	0f be c2             	movsbl %dl,%eax
  80063c:	85 c0                	test   %eax,%eax
  80063e:	74 27                	je     800667 <vprintfmt+0x263>
  800640:	85 f6                	test   %esi,%esi
  800642:	78 aa                	js     8005ee <vprintfmt+0x1ea>
  800644:	83 ee 01             	sub    $0x1,%esi
  800647:	79 a5                	jns    8005ee <vprintfmt+0x1ea>
  800649:	89 d8                	mov    %ebx,%eax
  80064b:	8b 75 08             	mov    0x8(%ebp),%esi
  80064e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800651:	89 c3                	mov    %eax,%ebx
  800653:	eb 18                	jmp    80066d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800655:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800659:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800660:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800662:	83 eb 01             	sub    $0x1,%ebx
  800665:	eb 06                	jmp    80066d <vprintfmt+0x269>
  800667:	8b 75 08             	mov    0x8(%ebp),%esi
  80066a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80066d:	85 db                	test   %ebx,%ebx
  80066f:	7f e4                	jg     800655 <vprintfmt+0x251>
  800671:	89 75 08             	mov    %esi,0x8(%ebp)
  800674:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800677:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80067a:	e9 aa fd ff ff       	jmp    800429 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80067f:	83 f9 01             	cmp    $0x1,%ecx
  800682:	7e 10                	jle    800694 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 30                	mov    (%eax),%esi
  800689:	8b 78 04             	mov    0x4(%eax),%edi
  80068c:	8d 40 08             	lea    0x8(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	eb 26                	jmp    8006ba <vprintfmt+0x2b6>
	else if (lflag)
  800694:	85 c9                	test   %ecx,%ecx
  800696:	74 12                	je     8006aa <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 30                	mov    (%eax),%esi
  80069d:	89 f7                	mov    %esi,%edi
  80069f:	c1 ff 1f             	sar    $0x1f,%edi
  8006a2:	8d 40 04             	lea    0x4(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a8:	eb 10                	jmp    8006ba <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 30                	mov    (%eax),%esi
  8006af:	89 f7                	mov    %esi,%edi
  8006b1:	c1 ff 1f             	sar    $0x1f,%edi
  8006b4:	8d 40 04             	lea    0x4(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ba:	89 f0                	mov    %esi,%eax
  8006bc:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006be:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006c3:	85 ff                	test   %edi,%edi
  8006c5:	0f 89 3a 01 00 00    	jns    800805 <vprintfmt+0x401>
				putch('-', putdat);
  8006cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006d2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006d9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006dc:	89 f0                	mov    %esi,%eax
  8006de:	89 fa                	mov    %edi,%edx
  8006e0:	f7 d8                	neg    %eax
  8006e2:	83 d2 00             	adc    $0x0,%edx
  8006e5:	f7 da                	neg    %edx
			}
			base = 10;
  8006e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006ec:	e9 14 01 00 00       	jmp    800805 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006f1:	83 f9 01             	cmp    $0x1,%ecx
  8006f4:	7e 13                	jle    800709 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 50 04             	mov    0x4(%eax),%edx
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	8b 75 14             	mov    0x14(%ebp),%esi
  800701:	8d 4e 08             	lea    0x8(%esi),%ecx
  800704:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800707:	eb 2c                	jmp    800735 <vprintfmt+0x331>
	else if (lflag)
  800709:	85 c9                	test   %ecx,%ecx
  80070b:	74 15                	je     800722 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	ba 00 00 00 00       	mov    $0x0,%edx
  800717:	8b 75 14             	mov    0x14(%ebp),%esi
  80071a:	8d 76 04             	lea    0x4(%esi),%esi
  80071d:	89 75 14             	mov    %esi,0x14(%ebp)
  800720:	eb 13                	jmp    800735 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	8b 75 14             	mov    0x14(%ebp),%esi
  80072f:	8d 76 04             	lea    0x4(%esi),%esi
  800732:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800735:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80073a:	e9 c6 00 00 00       	jmp    800805 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80073f:	83 f9 01             	cmp    $0x1,%ecx
  800742:	7e 13                	jle    800757 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8b 50 04             	mov    0x4(%eax),%edx
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	8b 75 14             	mov    0x14(%ebp),%esi
  80074f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800752:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800755:	eb 24                	jmp    80077b <vprintfmt+0x377>
	else if (lflag)
  800757:	85 c9                	test   %ecx,%ecx
  800759:	74 11                	je     80076c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	99                   	cltd   
  800761:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800764:	8d 71 04             	lea    0x4(%ecx),%esi
  800767:	89 75 14             	mov    %esi,0x14(%ebp)
  80076a:	eb 0f                	jmp    80077b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	99                   	cltd   
  800772:	8b 75 14             	mov    0x14(%ebp),%esi
  800775:	8d 76 04             	lea    0x4(%esi),%esi
  800778:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80077b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800780:	e9 80 00 00 00       	jmp    800805 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800785:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800796:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007a7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007aa:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007ae:	8b 06                	mov    (%esi),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007b5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007ba:	eb 49                	jmp    800805 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007bc:	83 f9 01             	cmp    $0x1,%ecx
  8007bf:	7e 13                	jle    8007d4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	8b 50 04             	mov    0x4(%eax),%edx
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	8b 75 14             	mov    0x14(%ebp),%esi
  8007cc:	8d 4e 08             	lea    0x8(%esi),%ecx
  8007cf:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007d2:	eb 2c                	jmp    800800 <vprintfmt+0x3fc>
	else if (lflag)
  8007d4:	85 c9                	test   %ecx,%ecx
  8007d6:	74 15                	je     8007ed <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007e5:	8d 71 04             	lea    0x4(%ecx),%esi
  8007e8:	89 75 14             	mov    %esi,0x14(%ebp)
  8007eb:	eb 13                	jmp    800800 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f7:	8b 75 14             	mov    0x14(%ebp),%esi
  8007fa:	8d 76 04             	lea    0x4(%esi),%esi
  8007fd:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800800:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800805:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800809:	89 74 24 10          	mov    %esi,0x10(%esp)
  80080d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800810:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800814:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800818:	89 04 24             	mov    %eax,(%esp)
  80081b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80081f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	e8 a6 fa ff ff       	call   8002d0 <printnum>
			break;
  80082a:	e9 fa fb ff ff       	jmp    800429 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80082f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800832:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800836:	89 04 24             	mov    %eax,(%esp)
  800839:	ff 55 08             	call   *0x8(%ebp)
			break;
  80083c:	e9 e8 fb ff ff       	jmp    800429 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800841:	8b 45 0c             	mov    0xc(%ebp),%eax
  800844:	89 44 24 04          	mov    %eax,0x4(%esp)
  800848:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80084f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800852:	89 fb                	mov    %edi,%ebx
  800854:	eb 03                	jmp    800859 <vprintfmt+0x455>
  800856:	83 eb 01             	sub    $0x1,%ebx
  800859:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80085d:	75 f7                	jne    800856 <vprintfmt+0x452>
  80085f:	90                   	nop
  800860:	e9 c4 fb ff ff       	jmp    800429 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800865:	83 c4 3c             	add    $0x3c,%esp
  800868:	5b                   	pop    %ebx
  800869:	5e                   	pop    %esi
  80086a:	5f                   	pop    %edi
  80086b:	5d                   	pop    %ebp
  80086c:	c3                   	ret    

0080086d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	83 ec 28             	sub    $0x28,%esp
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800879:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800880:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088a:	85 c0                	test   %eax,%eax
  80088c:	74 30                	je     8008be <vsnprintf+0x51>
  80088e:	85 d2                	test   %edx,%edx
  800890:	7e 2c                	jle    8008be <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800899:	8b 45 10             	mov    0x10(%ebp),%eax
  80089c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a7:	c7 04 24 bf 03 80 00 	movl   $0x8003bf,(%esp)
  8008ae:	e8 51 fb ff ff       	call   800404 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008bc:	eb 05                	jmp    8008c3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    

008008c5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008cb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	89 04 24             	mov    %eax,(%esp)
  8008e6:	e8 82 ff ff ff       	call   80086d <vsnprintf>
	va_end(ap);

	return rc;
}
  8008eb:	c9                   	leave  
  8008ec:	c3                   	ret    
  8008ed:	66 90                	xchg   %ax,%ax
  8008ef:	90                   	nop

008008f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fb:	eb 03                	jmp    800900 <strlen+0x10>
		n++;
  8008fd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800900:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800904:	75 f7                	jne    8008fd <strlen+0xd>
		n++;
	return n;
}
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800911:	b8 00 00 00 00       	mov    $0x0,%eax
  800916:	eb 03                	jmp    80091b <strnlen+0x13>
		n++;
  800918:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091b:	39 d0                	cmp    %edx,%eax
  80091d:	74 06                	je     800925 <strnlen+0x1d>
  80091f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800923:	75 f3                	jne    800918 <strnlen+0x10>
		n++;
	return n;
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	53                   	push   %ebx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800931:	89 c2                	mov    %eax,%edx
  800933:	83 c2 01             	add    $0x1,%edx
  800936:	83 c1 01             	add    $0x1,%ecx
  800939:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80093d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800940:	84 db                	test   %bl,%bl
  800942:	75 ef                	jne    800933 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800944:	5b                   	pop    %ebx
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	53                   	push   %ebx
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800951:	89 1c 24             	mov    %ebx,(%esp)
  800954:	e8 97 ff ff ff       	call   8008f0 <strlen>
	strcpy(dst + len, src);
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800960:	01 d8                	add    %ebx,%eax
  800962:	89 04 24             	mov    %eax,(%esp)
  800965:	e8 bd ff ff ff       	call   800927 <strcpy>
	return dst;
}
  80096a:	89 d8                	mov    %ebx,%eax
  80096c:	83 c4 08             	add    $0x8,%esp
  80096f:	5b                   	pop    %ebx
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	56                   	push   %esi
  800976:	53                   	push   %ebx
  800977:	8b 75 08             	mov    0x8(%ebp),%esi
  80097a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80097d:	89 f3                	mov    %esi,%ebx
  80097f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800982:	89 f2                	mov    %esi,%edx
  800984:	eb 0f                	jmp    800995 <strncpy+0x23>
		*dst++ = *src;
  800986:	83 c2 01             	add    $0x1,%edx
  800989:	0f b6 01             	movzbl (%ecx),%eax
  80098c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80098f:	80 39 01             	cmpb   $0x1,(%ecx)
  800992:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800995:	39 da                	cmp    %ebx,%edx
  800997:	75 ed                	jne    800986 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800999:	89 f0                	mov    %esi,%eax
  80099b:	5b                   	pop    %ebx
  80099c:	5e                   	pop    %esi
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	56                   	push   %esi
  8009a3:	53                   	push   %ebx
  8009a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009ad:	89 f0                	mov    %esi,%eax
  8009af:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b3:	85 c9                	test   %ecx,%ecx
  8009b5:	75 0b                	jne    8009c2 <strlcpy+0x23>
  8009b7:	eb 1d                	jmp    8009d6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009b9:	83 c0 01             	add    $0x1,%eax
  8009bc:	83 c2 01             	add    $0x1,%edx
  8009bf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009c2:	39 d8                	cmp    %ebx,%eax
  8009c4:	74 0b                	je     8009d1 <strlcpy+0x32>
  8009c6:	0f b6 0a             	movzbl (%edx),%ecx
  8009c9:	84 c9                	test   %cl,%cl
  8009cb:	75 ec                	jne    8009b9 <strlcpy+0x1a>
  8009cd:	89 c2                	mov    %eax,%edx
  8009cf:	eb 02                	jmp    8009d3 <strlcpy+0x34>
  8009d1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009d3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009d6:	29 f0                	sub    %esi,%eax
}
  8009d8:	5b                   	pop    %ebx
  8009d9:	5e                   	pop    %esi
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009e5:	eb 06                	jmp    8009ed <strcmp+0x11>
		p++, q++;
  8009e7:	83 c1 01             	add    $0x1,%ecx
  8009ea:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009ed:	0f b6 01             	movzbl (%ecx),%eax
  8009f0:	84 c0                	test   %al,%al
  8009f2:	74 04                	je     8009f8 <strcmp+0x1c>
  8009f4:	3a 02                	cmp    (%edx),%al
  8009f6:	74 ef                	je     8009e7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f8:	0f b6 c0             	movzbl %al,%eax
  8009fb:	0f b6 12             	movzbl (%edx),%edx
  8009fe:	29 d0                	sub    %edx,%eax
}
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	53                   	push   %ebx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0c:	89 c3                	mov    %eax,%ebx
  800a0e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a11:	eb 06                	jmp    800a19 <strncmp+0x17>
		n--, p++, q++;
  800a13:	83 c0 01             	add    $0x1,%eax
  800a16:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a19:	39 d8                	cmp    %ebx,%eax
  800a1b:	74 15                	je     800a32 <strncmp+0x30>
  800a1d:	0f b6 08             	movzbl (%eax),%ecx
  800a20:	84 c9                	test   %cl,%cl
  800a22:	74 04                	je     800a28 <strncmp+0x26>
  800a24:	3a 0a                	cmp    (%edx),%cl
  800a26:	74 eb                	je     800a13 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a28:	0f b6 00             	movzbl (%eax),%eax
  800a2b:	0f b6 12             	movzbl (%edx),%edx
  800a2e:	29 d0                	sub    %edx,%eax
  800a30:	eb 05                	jmp    800a37 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a32:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a37:	5b                   	pop    %ebx
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a44:	eb 07                	jmp    800a4d <strchr+0x13>
		if (*s == c)
  800a46:	38 ca                	cmp    %cl,%dl
  800a48:	74 0f                	je     800a59 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a4a:	83 c0 01             	add    $0x1,%eax
  800a4d:	0f b6 10             	movzbl (%eax),%edx
  800a50:	84 d2                	test   %dl,%dl
  800a52:	75 f2                	jne    800a46 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a65:	eb 07                	jmp    800a6e <strfind+0x13>
		if (*s == c)
  800a67:	38 ca                	cmp    %cl,%dl
  800a69:	74 0a                	je     800a75 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a6b:	83 c0 01             	add    $0x1,%eax
  800a6e:	0f b6 10             	movzbl (%eax),%edx
  800a71:	84 d2                	test   %dl,%dl
  800a73:	75 f2                	jne    800a67 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	57                   	push   %edi
  800a7b:	56                   	push   %esi
  800a7c:	53                   	push   %ebx
  800a7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a83:	85 c9                	test   %ecx,%ecx
  800a85:	74 36                	je     800abd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a87:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a8d:	75 28                	jne    800ab7 <memset+0x40>
  800a8f:	f6 c1 03             	test   $0x3,%cl
  800a92:	75 23                	jne    800ab7 <memset+0x40>
		c &= 0xFF;
  800a94:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a98:	89 d3                	mov    %edx,%ebx
  800a9a:	c1 e3 08             	shl    $0x8,%ebx
  800a9d:	89 d6                	mov    %edx,%esi
  800a9f:	c1 e6 18             	shl    $0x18,%esi
  800aa2:	89 d0                	mov    %edx,%eax
  800aa4:	c1 e0 10             	shl    $0x10,%eax
  800aa7:	09 f0                	or     %esi,%eax
  800aa9:	09 c2                	or     %eax,%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aaf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ab2:	fc                   	cld    
  800ab3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab5:	eb 06                	jmp    800abd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aba:	fc                   	cld    
  800abb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abd:	89 f8                	mov    %edi,%eax
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5f                   	pop    %edi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	57                   	push   %edi
  800ac8:	56                   	push   %esi
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800acf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad2:	39 c6                	cmp    %eax,%esi
  800ad4:	73 35                	jae    800b0b <memmove+0x47>
  800ad6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad9:	39 d0                	cmp    %edx,%eax
  800adb:	73 2e                	jae    800b0b <memmove+0x47>
		s += n;
		d += n;
  800add:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ae0:	89 d6                	mov    %edx,%esi
  800ae2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aea:	75 13                	jne    800aff <memmove+0x3b>
  800aec:	f6 c1 03             	test   $0x3,%cl
  800aef:	75 0e                	jne    800aff <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af1:	83 ef 04             	sub    $0x4,%edi
  800af4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800afa:	fd                   	std    
  800afb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afd:	eb 09                	jmp    800b08 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aff:	83 ef 01             	sub    $0x1,%edi
  800b02:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b05:	fd                   	std    
  800b06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b08:	fc                   	cld    
  800b09:	eb 1d                	jmp    800b28 <memmove+0x64>
  800b0b:	89 f2                	mov    %esi,%edx
  800b0d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0f:	f6 c2 03             	test   $0x3,%dl
  800b12:	75 0f                	jne    800b23 <memmove+0x5f>
  800b14:	f6 c1 03             	test   $0x3,%cl
  800b17:	75 0a                	jne    800b23 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b19:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b1c:	89 c7                	mov    %eax,%edi
  800b1e:	fc                   	cld    
  800b1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b21:	eb 05                	jmp    800b28 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b23:	89 c7                	mov    %eax,%edi
  800b25:	fc                   	cld    
  800b26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b28:	5e                   	pop    %esi
  800b29:	5f                   	pop    %edi
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b32:	8b 45 10             	mov    0x10(%ebp),%eax
  800b35:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	89 04 24             	mov    %eax,(%esp)
  800b46:	e8 79 ff ff ff       	call   800ac4 <memmove>
}
  800b4b:	c9                   	leave  
  800b4c:	c3                   	ret    

00800b4d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
  800b52:	8b 55 08             	mov    0x8(%ebp),%edx
  800b55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b58:	89 d6                	mov    %edx,%esi
  800b5a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b5d:	eb 1a                	jmp    800b79 <memcmp+0x2c>
		if (*s1 != *s2)
  800b5f:	0f b6 02             	movzbl (%edx),%eax
  800b62:	0f b6 19             	movzbl (%ecx),%ebx
  800b65:	38 d8                	cmp    %bl,%al
  800b67:	74 0a                	je     800b73 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b69:	0f b6 c0             	movzbl %al,%eax
  800b6c:	0f b6 db             	movzbl %bl,%ebx
  800b6f:	29 d8                	sub    %ebx,%eax
  800b71:	eb 0f                	jmp    800b82 <memcmp+0x35>
		s1++, s2++;
  800b73:	83 c2 01             	add    $0x1,%edx
  800b76:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b79:	39 f2                	cmp    %esi,%edx
  800b7b:	75 e2                	jne    800b5f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    

00800b86 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b8f:	89 c2                	mov    %eax,%edx
  800b91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b94:	eb 07                	jmp    800b9d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b96:	38 08                	cmp    %cl,(%eax)
  800b98:	74 07                	je     800ba1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b9a:	83 c0 01             	add    $0x1,%eax
  800b9d:	39 d0                	cmp    %edx,%eax
  800b9f:	72 f5                	jb     800b96 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	57                   	push   %edi
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
  800ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bac:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800baf:	eb 03                	jmp    800bb4 <strtol+0x11>
		s++;
  800bb1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb4:	0f b6 0a             	movzbl (%edx),%ecx
  800bb7:	80 f9 09             	cmp    $0x9,%cl
  800bba:	74 f5                	je     800bb1 <strtol+0xe>
  800bbc:	80 f9 20             	cmp    $0x20,%cl
  800bbf:	74 f0                	je     800bb1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bc1:	80 f9 2b             	cmp    $0x2b,%cl
  800bc4:	75 0a                	jne    800bd0 <strtol+0x2d>
		s++;
  800bc6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bc9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bce:	eb 11                	jmp    800be1 <strtol+0x3e>
  800bd0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bd5:	80 f9 2d             	cmp    $0x2d,%cl
  800bd8:	75 07                	jne    800be1 <strtol+0x3e>
		s++, neg = 1;
  800bda:	8d 52 01             	lea    0x1(%edx),%edx
  800bdd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800be6:	75 15                	jne    800bfd <strtol+0x5a>
  800be8:	80 3a 30             	cmpb   $0x30,(%edx)
  800beb:	75 10                	jne    800bfd <strtol+0x5a>
  800bed:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bf1:	75 0a                	jne    800bfd <strtol+0x5a>
		s += 2, base = 16;
  800bf3:	83 c2 02             	add    $0x2,%edx
  800bf6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bfb:	eb 10                	jmp    800c0d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bfd:	85 c0                	test   %eax,%eax
  800bff:	75 0c                	jne    800c0d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c01:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c03:	80 3a 30             	cmpb   $0x30,(%edx)
  800c06:	75 05                	jne    800c0d <strtol+0x6a>
		s++, base = 8;
  800c08:	83 c2 01             	add    $0x1,%edx
  800c0b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c12:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c15:	0f b6 0a             	movzbl (%edx),%ecx
  800c18:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c1b:	89 f0                	mov    %esi,%eax
  800c1d:	3c 09                	cmp    $0x9,%al
  800c1f:	77 08                	ja     800c29 <strtol+0x86>
			dig = *s - '0';
  800c21:	0f be c9             	movsbl %cl,%ecx
  800c24:	83 e9 30             	sub    $0x30,%ecx
  800c27:	eb 20                	jmp    800c49 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c29:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c2c:	89 f0                	mov    %esi,%eax
  800c2e:	3c 19                	cmp    $0x19,%al
  800c30:	77 08                	ja     800c3a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c32:	0f be c9             	movsbl %cl,%ecx
  800c35:	83 e9 57             	sub    $0x57,%ecx
  800c38:	eb 0f                	jmp    800c49 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c3a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c3d:	89 f0                	mov    %esi,%eax
  800c3f:	3c 19                	cmp    $0x19,%al
  800c41:	77 16                	ja     800c59 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c43:	0f be c9             	movsbl %cl,%ecx
  800c46:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c49:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c4c:	7d 0f                	jge    800c5d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c4e:	83 c2 01             	add    $0x1,%edx
  800c51:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c55:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c57:	eb bc                	jmp    800c15 <strtol+0x72>
  800c59:	89 d8                	mov    %ebx,%eax
  800c5b:	eb 02                	jmp    800c5f <strtol+0xbc>
  800c5d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c63:	74 05                	je     800c6a <strtol+0xc7>
		*endptr = (char *) s;
  800c65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c68:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c6a:	f7 d8                	neg    %eax
  800c6c:	85 ff                	test   %edi,%edi
  800c6e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    

00800c76 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	57                   	push   %edi
  800c7a:	56                   	push   %esi
  800c7b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c84:	8b 55 08             	mov    0x8(%ebp),%edx
  800c87:	89 c3                	mov    %eax,%ebx
  800c89:	89 c7                	mov    %eax,%edi
  800c8b:	89 c6                	mov    %eax,%esi
  800c8d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9f:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca4:	89 d1                	mov    %edx,%ecx
  800ca6:	89 d3                	mov    %edx,%ebx
  800ca8:	89 d7                	mov    %edx,%edi
  800caa:	89 d6                	mov    %edx,%esi
  800cac:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cae:	5b                   	pop    %ebx
  800caf:	5e                   	pop    %esi
  800cb0:	5f                   	pop    %edi
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    

00800cb3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	89 cb                	mov    %ecx,%ebx
  800ccb:	89 cf                	mov    %ecx,%edi
  800ccd:	89 ce                	mov    %ecx,%esi
  800ccf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cd1:	85 c0                	test   %eax,%eax
  800cd3:	7e 28                	jle    800cfd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cd9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ce0:	00 
  800ce1:	c7 44 24 08 97 32 80 	movl   $0x803297,0x8(%esp)
  800ce8:	00 
  800ce9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf0:	00 
  800cf1:	c7 04 24 b4 32 80 00 	movl   $0x8032b4,(%esp)
  800cf8:	e8 bc f4 ff ff       	call   8001b9 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cfd:	83 c4 2c             	add    $0x2c,%esp
  800d00:	5b                   	pop    %ebx
  800d01:	5e                   	pop    %esi
  800d02:	5f                   	pop    %edi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
  800d0b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d13:	b8 04 00 00 00       	mov    $0x4,%eax
  800d18:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1b:	89 cb                	mov    %ecx,%ebx
  800d1d:	89 cf                	mov    %ecx,%edi
  800d1f:	89 ce                	mov    %ecx,%esi
  800d21:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7e 28                	jle    800d4f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d27:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d2b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d32:	00 
  800d33:	c7 44 24 08 97 32 80 	movl   $0x803297,0x8(%esp)
  800d3a:	00 
  800d3b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d42:	00 
  800d43:	c7 04 24 b4 32 80 00 	movl   $0x8032b4,(%esp)
  800d4a:	e8 6a f4 ff ff       	call   8001b9 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800d4f:	83 c4 2c             	add    $0x2c,%esp
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d62:	b8 02 00 00 00       	mov    $0x2,%eax
  800d67:	89 d1                	mov    %edx,%ecx
  800d69:	89 d3                	mov    %edx,%ebx
  800d6b:	89 d7                	mov    %edx,%edi
  800d6d:	89 d6                	mov    %edx,%esi
  800d6f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5f                   	pop    %edi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <sys_yield>:

void
sys_yield(void)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	57                   	push   %edi
  800d7a:	56                   	push   %esi
  800d7b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d81:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d86:	89 d1                	mov    %edx,%ecx
  800d88:	89 d3                	mov    %edx,%ebx
  800d8a:	89 d7                	mov    %edx,%edi
  800d8c:	89 d6                	mov    %edx,%esi
  800d8e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    

00800d95 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
  800d9b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9e:	be 00 00 00 00       	mov    $0x0,%esi
  800da3:	b8 05 00 00 00       	mov    $0x5,%eax
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	8b 55 08             	mov    0x8(%ebp),%edx
  800dae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db1:	89 f7                	mov    %esi,%edi
  800db3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db5:	85 c0                	test   %eax,%eax
  800db7:	7e 28                	jle    800de1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dbd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dc4:	00 
  800dc5:	c7 44 24 08 97 32 80 	movl   $0x803297,0x8(%esp)
  800dcc:	00 
  800dcd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd4:	00 
  800dd5:	c7 04 24 b4 32 80 00 	movl   $0x8032b4,(%esp)
  800ddc:	e8 d8 f3 ff ff       	call   8001b9 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800de1:	83 c4 2c             	add    $0x2c,%esp
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	53                   	push   %ebx
  800def:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df2:	b8 06 00 00 00       	mov    $0x6,%eax
  800df7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e00:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e03:	8b 75 18             	mov    0x18(%ebp),%esi
  800e06:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	7e 28                	jle    800e34 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e10:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e17:	00 
  800e18:	c7 44 24 08 97 32 80 	movl   $0x803297,0x8(%esp)
  800e1f:	00 
  800e20:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e27:	00 
  800e28:	c7 04 24 b4 32 80 00 	movl   $0x8032b4,(%esp)
  800e2f:	e8 85 f3 ff ff       	call   8001b9 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e34:	83 c4 2c             	add    $0x2c,%esp
  800e37:	5b                   	pop    %ebx
  800e38:	5e                   	pop    %esi
  800e39:	5f                   	pop    %edi
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
  800e42:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4a:	b8 07 00 00 00       	mov    $0x7,%eax
  800e4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e52:	8b 55 08             	mov    0x8(%ebp),%edx
  800e55:	89 df                	mov    %ebx,%edi
  800e57:	89 de                	mov    %ebx,%esi
  800e59:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	7e 28                	jle    800e87 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e63:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800e6a:	00 
  800e6b:	c7 44 24 08 97 32 80 	movl   $0x803297,0x8(%esp)
  800e72:	00 
  800e73:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7a:	00 
  800e7b:	c7 04 24 b4 32 80 00 	movl   $0x8032b4,(%esp)
  800e82:	e8 32 f3 ff ff       	call   8001b9 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e87:	83 c4 2c             	add    $0x2c,%esp
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    

00800e8f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e95:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e9a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	89 cb                	mov    %ecx,%ebx
  800ea4:	89 cf                	mov    %ecx,%edi
  800ea6:	89 ce                	mov    %ecx,%esi
  800ea8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800eaa:	5b                   	pop    %ebx
  800eab:	5e                   	pop    %esi
  800eac:	5f                   	pop    %edi
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    

00800eaf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	57                   	push   %edi
  800eb3:	56                   	push   %esi
  800eb4:	53                   	push   %ebx
  800eb5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebd:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec8:	89 df                	mov    %ebx,%edi
  800eca:	89 de                	mov    %ebx,%esi
  800ecc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	7e 28                	jle    800efa <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800edd:	00 
  800ede:	c7 44 24 08 97 32 80 	movl   $0x803297,0x8(%esp)
  800ee5:	00 
  800ee6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eed:	00 
  800eee:	c7 04 24 b4 32 80 00 	movl   $0x8032b4,(%esp)
  800ef5:	e8 bf f2 ff ff       	call   8001b9 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800efa:	83 c4 2c             	add    $0x2c,%esp
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    

00800f02 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
  800f08:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	89 df                	mov    %ebx,%edi
  800f1d:	89 de                	mov    %ebx,%esi
  800f1f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	7e 28                	jle    800f4d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f25:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f29:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f30:	00 
  800f31:	c7 44 24 08 97 32 80 	movl   $0x803297,0x8(%esp)
  800f38:	00 
  800f39:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f40:	00 
  800f41:	c7 04 24 b4 32 80 00 	movl   $0x8032b4,(%esp)
  800f48:	e8 6c f2 ff ff       	call   8001b9 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f4d:	83 c4 2c             	add    $0x2c,%esp
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	57                   	push   %edi
  800f59:	56                   	push   %esi
  800f5a:	53                   	push   %ebx
  800f5b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f63:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	89 df                	mov    %ebx,%edi
  800f70:	89 de                	mov    %ebx,%esi
  800f72:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f74:	85 c0                	test   %eax,%eax
  800f76:	7e 28                	jle    800fa0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f78:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f7c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f83:	00 
  800f84:	c7 44 24 08 97 32 80 	movl   $0x803297,0x8(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f93:	00 
  800f94:	c7 04 24 b4 32 80 00 	movl   $0x8032b4,(%esp)
  800f9b:	e8 19 f2 ff ff       	call   8001b9 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fa0:	83 c4 2c             	add    $0x2c,%esp
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    

00800fa8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fae:	be 00 00 00 00       	mov    $0x0,%esi
  800fb3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
  800fd1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	89 cb                	mov    %ecx,%ebx
  800fe3:	89 cf                	mov    %ecx,%edi
  800fe5:	89 ce                	mov    %ecx,%esi
  800fe7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7e 28                	jle    801015 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fed:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800ff8:	00 
  800ff9:	c7 44 24 08 97 32 80 	movl   $0x803297,0x8(%esp)
  801000:	00 
  801001:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801008:	00 
  801009:	c7 04 24 b4 32 80 00 	movl   $0x8032b4,(%esp)
  801010:	e8 a4 f1 ff ff       	call   8001b9 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801015:	83 c4 2c             	add    $0x2c,%esp
  801018:	5b                   	pop    %ebx
  801019:	5e                   	pop    %esi
  80101a:	5f                   	pop    %edi
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	57                   	push   %edi
  801021:	56                   	push   %esi
  801022:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801023:	ba 00 00 00 00       	mov    $0x0,%edx
  801028:	b8 0f 00 00 00       	mov    $0xf,%eax
  80102d:	89 d1                	mov    %edx,%ecx
  80102f:	89 d3                	mov    %edx,%ebx
  801031:	89 d7                	mov    %edx,%edi
  801033:	89 d6                	mov    %edx,%esi
  801035:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801037:	5b                   	pop    %ebx
  801038:	5e                   	pop    %esi
  801039:	5f                   	pop    %edi
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	57                   	push   %edi
  801040:	56                   	push   %esi
  801041:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801042:	bb 00 00 00 00       	mov    $0x0,%ebx
  801047:	b8 11 00 00 00       	mov    $0x11,%eax
  80104c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104f:	8b 55 08             	mov    0x8(%ebp),%edx
  801052:	89 df                	mov    %ebx,%edi
  801054:	89 de                	mov    %ebx,%esi
  801056:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801058:	5b                   	pop    %ebx
  801059:	5e                   	pop    %esi
  80105a:	5f                   	pop    %edi
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    

0080105d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	57                   	push   %edi
  801061:	56                   	push   %esi
  801062:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801063:	bb 00 00 00 00       	mov    $0x0,%ebx
  801068:	b8 12 00 00 00       	mov    $0x12,%eax
  80106d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801070:	8b 55 08             	mov    0x8(%ebp),%edx
  801073:	89 df                	mov    %ebx,%edi
  801075:	89 de                	mov    %ebx,%esi
  801077:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801079:	5b                   	pop    %ebx
  80107a:	5e                   	pop    %esi
  80107b:	5f                   	pop    %edi
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801084:	b9 00 00 00 00       	mov    $0x0,%ecx
  801089:	b8 13 00 00 00       	mov    $0x13,%eax
  80108e:	8b 55 08             	mov    0x8(%ebp),%edx
  801091:	89 cb                	mov    %ecx,%ebx
  801093:	89 cf                	mov    %ecx,%edi
  801095:	89 ce                	mov    %ecx,%esi
  801097:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801099:	5b                   	pop    %ebx
  80109a:	5e                   	pop    %esi
  80109b:	5f                   	pop    %edi
  80109c:	5d                   	pop    %ebp
  80109d:	c3                   	ret    
  80109e:	66 90                	xchg   %ax,%ax

008010a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    

008010b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    

008010c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	c1 ea 16             	shr    $0x16,%edx
  8010d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010de:	f6 c2 01             	test   $0x1,%dl
  8010e1:	74 11                	je     8010f4 <fd_alloc+0x2d>
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	c1 ea 0c             	shr    $0xc,%edx
  8010e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ef:	f6 c2 01             	test   $0x1,%dl
  8010f2:	75 09                	jne    8010fd <fd_alloc+0x36>
			*fd_store = fd;
  8010f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fb:	eb 17                	jmp    801114 <fd_alloc+0x4d>
  8010fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801102:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801107:	75 c9                	jne    8010d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801109:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80110f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    

00801116 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80111c:	83 f8 1f             	cmp    $0x1f,%eax
  80111f:	77 36                	ja     801157 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801121:	c1 e0 0c             	shl    $0xc,%eax
  801124:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801129:	89 c2                	mov    %eax,%edx
  80112b:	c1 ea 16             	shr    $0x16,%edx
  80112e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801135:	f6 c2 01             	test   $0x1,%dl
  801138:	74 24                	je     80115e <fd_lookup+0x48>
  80113a:	89 c2                	mov    %eax,%edx
  80113c:	c1 ea 0c             	shr    $0xc,%edx
  80113f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801146:	f6 c2 01             	test   $0x1,%dl
  801149:	74 1a                	je     801165 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80114b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114e:	89 02                	mov    %eax,(%edx)
	return 0;
  801150:	b8 00 00 00 00       	mov    $0x0,%eax
  801155:	eb 13                	jmp    80116a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801157:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115c:	eb 0c                	jmp    80116a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80115e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801163:	eb 05                	jmp    80116a <fd_lookup+0x54>
  801165:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 18             	sub    $0x18,%esp
  801172:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801175:	ba 00 00 00 00       	mov    $0x0,%edx
  80117a:	eb 13                	jmp    80118f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80117c:	39 08                	cmp    %ecx,(%eax)
  80117e:	75 0c                	jne    80118c <dev_lookup+0x20>
			*dev = devtab[i];
  801180:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801183:	89 01                	mov    %eax,(%ecx)
			return 0;
  801185:	b8 00 00 00 00       	mov    $0x0,%eax
  80118a:	eb 38                	jmp    8011c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80118c:	83 c2 01             	add    $0x1,%edx
  80118f:	8b 04 95 40 33 80 00 	mov    0x803340(,%edx,4),%eax
  801196:	85 c0                	test   %eax,%eax
  801198:	75 e2                	jne    80117c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80119a:	a1 08 50 80 00       	mov    0x805008,%eax
  80119f:	8b 40 48             	mov    0x48(%eax),%eax
  8011a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011aa:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  8011b1:	e8 fc f0 ff ff       	call   8002b2 <cprintf>
	*dev = 0;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

008011c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	56                   	push   %esi
  8011ca:	53                   	push   %ebx
  8011cb:	83 ec 20             	sub    $0x20,%esp
  8011ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e4:	89 04 24             	mov    %eax,(%esp)
  8011e7:	e8 2a ff ff ff       	call   801116 <fd_lookup>
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	78 05                	js     8011f5 <fd_close+0x2f>
	    || fd != fd2)
  8011f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011f3:	74 0c                	je     801201 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011f5:	84 db                	test   %bl,%bl
  8011f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011fc:	0f 44 c2             	cmove  %edx,%eax
  8011ff:	eb 3f                	jmp    801240 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801201:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801204:	89 44 24 04          	mov    %eax,0x4(%esp)
  801208:	8b 06                	mov    (%esi),%eax
  80120a:	89 04 24             	mov    %eax,(%esp)
  80120d:	e8 5a ff ff ff       	call   80116c <dev_lookup>
  801212:	89 c3                	mov    %eax,%ebx
  801214:	85 c0                	test   %eax,%eax
  801216:	78 16                	js     80122e <fd_close+0x68>
		if (dev->dev_close)
  801218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80121b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80121e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801223:	85 c0                	test   %eax,%eax
  801225:	74 07                	je     80122e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801227:	89 34 24             	mov    %esi,(%esp)
  80122a:	ff d0                	call   *%eax
  80122c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80122e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801232:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801239:	e8 fe fb ff ff       	call   800e3c <sys_page_unmap>
	return r;
  80123e:	89 d8                	mov    %ebx,%eax
}
  801240:	83 c4 20             	add    $0x20,%esp
  801243:	5b                   	pop    %ebx
  801244:	5e                   	pop    %esi
  801245:	5d                   	pop    %ebp
  801246:	c3                   	ret    

00801247 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80124d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801250:	89 44 24 04          	mov    %eax,0x4(%esp)
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	89 04 24             	mov    %eax,(%esp)
  80125a:	e8 b7 fe ff ff       	call   801116 <fd_lookup>
  80125f:	89 c2                	mov    %eax,%edx
  801261:	85 d2                	test   %edx,%edx
  801263:	78 13                	js     801278 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801265:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80126c:	00 
  80126d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801270:	89 04 24             	mov    %eax,(%esp)
  801273:	e8 4e ff ff ff       	call   8011c6 <fd_close>
}
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <close_all>:

void
close_all(void)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	53                   	push   %ebx
  80127e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801281:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801286:	89 1c 24             	mov    %ebx,(%esp)
  801289:	e8 b9 ff ff ff       	call   801247 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80128e:	83 c3 01             	add    $0x1,%ebx
  801291:	83 fb 20             	cmp    $0x20,%ebx
  801294:	75 f0                	jne    801286 <close_all+0xc>
		close(i);
}
  801296:	83 c4 14             	add    $0x14,%esp
  801299:	5b                   	pop    %ebx
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    

0080129c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 04 24             	mov    %eax,(%esp)
  8012b2:	e8 5f fe ff ff       	call   801116 <fd_lookup>
  8012b7:	89 c2                	mov    %eax,%edx
  8012b9:	85 d2                	test   %edx,%edx
  8012bb:	0f 88 e1 00 00 00    	js     8013a2 <dup+0x106>
		return r;
	close(newfdnum);
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	89 04 24             	mov    %eax,(%esp)
  8012c7:	e8 7b ff ff ff       	call   801247 <close>

	newfd = INDEX2FD(newfdnum);
  8012cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012cf:	c1 e3 0c             	shl    $0xc,%ebx
  8012d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012db:	89 04 24             	mov    %eax,(%esp)
  8012de:	e8 cd fd ff ff       	call   8010b0 <fd2data>
  8012e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012e5:	89 1c 24             	mov    %ebx,(%esp)
  8012e8:	e8 c3 fd ff ff       	call   8010b0 <fd2data>
  8012ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ef:	89 f0                	mov    %esi,%eax
  8012f1:	c1 e8 16             	shr    $0x16,%eax
  8012f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012fb:	a8 01                	test   $0x1,%al
  8012fd:	74 43                	je     801342 <dup+0xa6>
  8012ff:	89 f0                	mov    %esi,%eax
  801301:	c1 e8 0c             	shr    $0xc,%eax
  801304:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80130b:	f6 c2 01             	test   $0x1,%dl
  80130e:	74 32                	je     801342 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801310:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801317:	25 07 0e 00 00       	and    $0xe07,%eax
  80131c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801320:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801324:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80132b:	00 
  80132c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801330:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801337:	e8 ad fa ff ff       	call   800de9 <sys_page_map>
  80133c:	89 c6                	mov    %eax,%esi
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 3e                	js     801380 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801345:	89 c2                	mov    %eax,%edx
  801347:	c1 ea 0c             	shr    $0xc,%edx
  80134a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801351:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801357:	89 54 24 10          	mov    %edx,0x10(%esp)
  80135b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80135f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801366:	00 
  801367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801372:	e8 72 fa ff ff       	call   800de9 <sys_page_map>
  801377:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801379:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80137c:	85 f6                	test   %esi,%esi
  80137e:	79 22                	jns    8013a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801380:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801384:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80138b:	e8 ac fa ff ff       	call   800e3c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801390:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801394:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80139b:	e8 9c fa ff ff       	call   800e3c <sys_page_unmap>
	return r;
  8013a0:	89 f0                	mov    %esi,%eax
}
  8013a2:	83 c4 3c             	add    $0x3c,%esp
  8013a5:	5b                   	pop    %ebx
  8013a6:	5e                   	pop    %esi
  8013a7:	5f                   	pop    %edi
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    

008013aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	53                   	push   %ebx
  8013ae:	83 ec 24             	sub    $0x24,%esp
  8013b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bb:	89 1c 24             	mov    %ebx,(%esp)
  8013be:	e8 53 fd ff ff       	call   801116 <fd_lookup>
  8013c3:	89 c2                	mov    %eax,%edx
  8013c5:	85 d2                	test   %edx,%edx
  8013c7:	78 6d                	js     801436 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	89 04 24             	mov    %eax,(%esp)
  8013d8:	e8 8f fd ff ff       	call   80116c <dev_lookup>
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	78 55                	js     801436 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e4:	8b 50 08             	mov    0x8(%eax),%edx
  8013e7:	83 e2 03             	and    $0x3,%edx
  8013ea:	83 fa 01             	cmp    $0x1,%edx
  8013ed:	75 23                	jne    801412 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ef:	a1 08 50 80 00       	mov    0x805008,%eax
  8013f4:	8b 40 48             	mov    0x48(%eax),%eax
  8013f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ff:	c7 04 24 05 33 80 00 	movl   $0x803305,(%esp)
  801406:	e8 a7 ee ff ff       	call   8002b2 <cprintf>
		return -E_INVAL;
  80140b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801410:	eb 24                	jmp    801436 <read+0x8c>
	}
	if (!dev->dev_read)
  801412:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801415:	8b 52 08             	mov    0x8(%edx),%edx
  801418:	85 d2                	test   %edx,%edx
  80141a:	74 15                	je     801431 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80141c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80141f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801423:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801426:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80142a:	89 04 24             	mov    %eax,(%esp)
  80142d:	ff d2                	call   *%edx
  80142f:	eb 05                	jmp    801436 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801431:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801436:	83 c4 24             	add    $0x24,%esp
  801439:	5b                   	pop    %ebx
  80143a:	5d                   	pop    %ebp
  80143b:	c3                   	ret    

0080143c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	57                   	push   %edi
  801440:	56                   	push   %esi
  801441:	53                   	push   %ebx
  801442:	83 ec 1c             	sub    $0x1c,%esp
  801445:	8b 7d 08             	mov    0x8(%ebp),%edi
  801448:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80144b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801450:	eb 23                	jmp    801475 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801452:	89 f0                	mov    %esi,%eax
  801454:	29 d8                	sub    %ebx,%eax
  801456:	89 44 24 08          	mov    %eax,0x8(%esp)
  80145a:	89 d8                	mov    %ebx,%eax
  80145c:	03 45 0c             	add    0xc(%ebp),%eax
  80145f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801463:	89 3c 24             	mov    %edi,(%esp)
  801466:	e8 3f ff ff ff       	call   8013aa <read>
		if (m < 0)
  80146b:	85 c0                	test   %eax,%eax
  80146d:	78 10                	js     80147f <readn+0x43>
			return m;
		if (m == 0)
  80146f:	85 c0                	test   %eax,%eax
  801471:	74 0a                	je     80147d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801473:	01 c3                	add    %eax,%ebx
  801475:	39 f3                	cmp    %esi,%ebx
  801477:	72 d9                	jb     801452 <readn+0x16>
  801479:	89 d8                	mov    %ebx,%eax
  80147b:	eb 02                	jmp    80147f <readn+0x43>
  80147d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80147f:	83 c4 1c             	add    $0x1c,%esp
  801482:	5b                   	pop    %ebx
  801483:	5e                   	pop    %esi
  801484:	5f                   	pop    %edi
  801485:	5d                   	pop    %ebp
  801486:	c3                   	ret    

00801487 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	53                   	push   %ebx
  80148b:	83 ec 24             	sub    $0x24,%esp
  80148e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801491:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801494:	89 44 24 04          	mov    %eax,0x4(%esp)
  801498:	89 1c 24             	mov    %ebx,(%esp)
  80149b:	e8 76 fc ff ff       	call   801116 <fd_lookup>
  8014a0:	89 c2                	mov    %eax,%edx
  8014a2:	85 d2                	test   %edx,%edx
  8014a4:	78 68                	js     80150e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b0:	8b 00                	mov    (%eax),%eax
  8014b2:	89 04 24             	mov    %eax,(%esp)
  8014b5:	e8 b2 fc ff ff       	call   80116c <dev_lookup>
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	78 50                	js     80150e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014c5:	75 23                	jne    8014ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c7:	a1 08 50 80 00       	mov    0x805008,%eax
  8014cc:	8b 40 48             	mov    0x48(%eax),%eax
  8014cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d7:	c7 04 24 21 33 80 00 	movl   $0x803321,(%esp)
  8014de:	e8 cf ed ff ff       	call   8002b2 <cprintf>
		return -E_INVAL;
  8014e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e8:	eb 24                	jmp    80150e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8014f0:	85 d2                	test   %edx,%edx
  8014f2:	74 15                	je     801509 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801502:	89 04 24             	mov    %eax,(%esp)
  801505:	ff d2                	call   *%edx
  801507:	eb 05                	jmp    80150e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801509:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80150e:	83 c4 24             	add    $0x24,%esp
  801511:	5b                   	pop    %ebx
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    

00801514 <seek>:

int
seek(int fdnum, off_t offset)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80151a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80151d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	89 04 24             	mov    %eax,(%esp)
  801527:	e8 ea fb ff ff       	call   801116 <fd_lookup>
  80152c:	85 c0                	test   %eax,%eax
  80152e:	78 0e                	js     80153e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801530:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801533:	8b 55 0c             	mov    0xc(%ebp),%edx
  801536:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	53                   	push   %ebx
  801544:	83 ec 24             	sub    $0x24,%esp
  801547:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801551:	89 1c 24             	mov    %ebx,(%esp)
  801554:	e8 bd fb ff ff       	call   801116 <fd_lookup>
  801559:	89 c2                	mov    %eax,%edx
  80155b:	85 d2                	test   %edx,%edx
  80155d:	78 61                	js     8015c0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80155f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801562:	89 44 24 04          	mov    %eax,0x4(%esp)
  801566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801569:	8b 00                	mov    (%eax),%eax
  80156b:	89 04 24             	mov    %eax,(%esp)
  80156e:	e8 f9 fb ff ff       	call   80116c <dev_lookup>
  801573:	85 c0                	test   %eax,%eax
  801575:	78 49                	js     8015c0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80157e:	75 23                	jne    8015a3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801580:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801585:	8b 40 48             	mov    0x48(%eax),%eax
  801588:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80158c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801590:	c7 04 24 e4 32 80 00 	movl   $0x8032e4,(%esp)
  801597:	e8 16 ed ff ff       	call   8002b2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80159c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a1:	eb 1d                	jmp    8015c0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a6:	8b 52 18             	mov    0x18(%edx),%edx
  8015a9:	85 d2                	test   %edx,%edx
  8015ab:	74 0e                	je     8015bb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015b4:	89 04 24             	mov    %eax,(%esp)
  8015b7:	ff d2                	call   *%edx
  8015b9:	eb 05                	jmp    8015c0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015c0:	83 c4 24             	add    $0x24,%esp
  8015c3:	5b                   	pop    %ebx
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	53                   	push   %ebx
  8015ca:	83 ec 24             	sub    $0x24,%esp
  8015cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	89 04 24             	mov    %eax,(%esp)
  8015dd:	e8 34 fb ff ff       	call   801116 <fd_lookup>
  8015e2:	89 c2                	mov    %eax,%edx
  8015e4:	85 d2                	test   %edx,%edx
  8015e6:	78 52                	js     80163a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f2:	8b 00                	mov    (%eax),%eax
  8015f4:	89 04 24             	mov    %eax,(%esp)
  8015f7:	e8 70 fb ff ff       	call   80116c <dev_lookup>
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	78 3a                	js     80163a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801603:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801607:	74 2c                	je     801635 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801609:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80160c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801613:	00 00 00 
	stat->st_isdir = 0;
  801616:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80161d:	00 00 00 
	stat->st_dev = dev;
  801620:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801626:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80162a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80162d:	89 14 24             	mov    %edx,(%esp)
  801630:	ff 50 14             	call   *0x14(%eax)
  801633:	eb 05                	jmp    80163a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801635:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80163a:	83 c4 24             	add    $0x24,%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	56                   	push   %esi
  801644:	53                   	push   %ebx
  801645:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80164f:	00 
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	89 04 24             	mov    %eax,(%esp)
  801656:	e8 99 02 00 00       	call   8018f4 <open>
  80165b:	89 c3                	mov    %eax,%ebx
  80165d:	85 db                	test   %ebx,%ebx
  80165f:	78 1b                	js     80167c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801661:	8b 45 0c             	mov    0xc(%ebp),%eax
  801664:	89 44 24 04          	mov    %eax,0x4(%esp)
  801668:	89 1c 24             	mov    %ebx,(%esp)
  80166b:	e8 56 ff ff ff       	call   8015c6 <fstat>
  801670:	89 c6                	mov    %eax,%esi
	close(fd);
  801672:	89 1c 24             	mov    %ebx,(%esp)
  801675:	e8 cd fb ff ff       	call   801247 <close>
	return r;
  80167a:	89 f0                	mov    %esi,%eax
}
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	5b                   	pop    %ebx
  801680:	5e                   	pop    %esi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	56                   	push   %esi
  801687:	53                   	push   %ebx
  801688:	83 ec 10             	sub    $0x10,%esp
  80168b:	89 c6                	mov    %eax,%esi
  80168d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80168f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801696:	75 11                	jne    8016a9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801698:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80169f:	e8 bb 14 00 00       	call   802b5f <ipc_find_env>
  8016a4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016a9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016b0:	00 
  8016b1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8016b8:	00 
  8016b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016bd:	a1 00 50 80 00       	mov    0x805000,%eax
  8016c2:	89 04 24             	mov    %eax,(%esp)
  8016c5:	e8 2e 14 00 00       	call   802af8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016d1:	00 
  8016d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016dd:	e8 ae 13 00 00       	call   802a90 <ipc_recv>
}
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8016fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801702:	ba 00 00 00 00       	mov    $0x0,%edx
  801707:	b8 02 00 00 00       	mov    $0x2,%eax
  80170c:	e8 72 ff ff ff       	call   801683 <fsipc>
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	8b 40 0c             	mov    0xc(%eax),%eax
  80171f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801724:	ba 00 00 00 00       	mov    $0x0,%edx
  801729:	b8 06 00 00 00       	mov    $0x6,%eax
  80172e:	e8 50 ff ff ff       	call   801683 <fsipc>
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	53                   	push   %ebx
  801739:	83 ec 14             	sub    $0x14,%esp
  80173c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8b 40 0c             	mov    0xc(%eax),%eax
  801745:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80174a:	ba 00 00 00 00       	mov    $0x0,%edx
  80174f:	b8 05 00 00 00       	mov    $0x5,%eax
  801754:	e8 2a ff ff ff       	call   801683 <fsipc>
  801759:	89 c2                	mov    %eax,%edx
  80175b:	85 d2                	test   %edx,%edx
  80175d:	78 2b                	js     80178a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80175f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801766:	00 
  801767:	89 1c 24             	mov    %ebx,(%esp)
  80176a:	e8 b8 f1 ff ff       	call   800927 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80176f:	a1 80 60 80 00       	mov    0x806080,%eax
  801774:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80177a:	a1 84 60 80 00       	mov    0x806084,%eax
  80177f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801785:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178a:	83 c4 14             	add    $0x14,%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    

00801790 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	53                   	push   %ebx
  801794:	83 ec 14             	sub    $0x14,%esp
  801797:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80179a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  8017a0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8017a5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ab:	8b 52 0c             	mov    0xc(%edx),%edx
  8017ae:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  8017b4:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  8017b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c4:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  8017cb:	e8 f4 f2 ff ff       	call   800ac4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  8017d0:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  8017d7:	00 
  8017d8:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  8017df:	e8 ce ea ff ff       	call   8002b2 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e9:	b8 04 00 00 00       	mov    $0x4,%eax
  8017ee:	e8 90 fe ff ff       	call   801683 <fsipc>
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	78 53                	js     80184a <devfile_write+0xba>
		return r;
	assert(r <= n);
  8017f7:	39 c3                	cmp    %eax,%ebx
  8017f9:	73 24                	jae    80181f <devfile_write+0x8f>
  8017fb:	c7 44 24 0c 59 33 80 	movl   $0x803359,0xc(%esp)
  801802:	00 
  801803:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  80180a:	00 
  80180b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801812:	00 
  801813:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  80181a:	e8 9a e9 ff ff       	call   8001b9 <_panic>
	assert(r <= PGSIZE);
  80181f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801824:	7e 24                	jle    80184a <devfile_write+0xba>
  801826:	c7 44 24 0c 80 33 80 	movl   $0x803380,0xc(%esp)
  80182d:	00 
  80182e:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  801835:	00 
  801836:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  80183d:	00 
  80183e:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  801845:	e8 6f e9 ff ff       	call   8001b9 <_panic>
	return r;
}
  80184a:	83 c4 14             	add    $0x14,%esp
  80184d:	5b                   	pop    %ebx
  80184e:	5d                   	pop    %ebp
  80184f:	c3                   	ret    

00801850 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	56                   	push   %esi
  801854:	53                   	push   %ebx
  801855:	83 ec 10             	sub    $0x10,%esp
  801858:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	8b 40 0c             	mov    0xc(%eax),%eax
  801861:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801866:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80186c:	ba 00 00 00 00       	mov    $0x0,%edx
  801871:	b8 03 00 00 00       	mov    $0x3,%eax
  801876:	e8 08 fe ff ff       	call   801683 <fsipc>
  80187b:	89 c3                	mov    %eax,%ebx
  80187d:	85 c0                	test   %eax,%eax
  80187f:	78 6a                	js     8018eb <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801881:	39 c6                	cmp    %eax,%esi
  801883:	73 24                	jae    8018a9 <devfile_read+0x59>
  801885:	c7 44 24 0c 59 33 80 	movl   $0x803359,0xc(%esp)
  80188c:	00 
  80188d:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  801894:	00 
  801895:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80189c:	00 
  80189d:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  8018a4:	e8 10 e9 ff ff       	call   8001b9 <_panic>
	assert(r <= PGSIZE);
  8018a9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ae:	7e 24                	jle    8018d4 <devfile_read+0x84>
  8018b0:	c7 44 24 0c 80 33 80 	movl   $0x803380,0xc(%esp)
  8018b7:	00 
  8018b8:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  8018bf:	00 
  8018c0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8018c7:	00 
  8018c8:	c7 04 24 75 33 80 00 	movl   $0x803375,(%esp)
  8018cf:	e8 e5 e8 ff ff       	call   8001b9 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018d8:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8018df:	00 
  8018e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e3:	89 04 24             	mov    %eax,(%esp)
  8018e6:	e8 d9 f1 ff ff       	call   800ac4 <memmove>
	return r;
}
  8018eb:	89 d8                	mov    %ebx,%eax
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	5b                   	pop    %ebx
  8018f1:	5e                   	pop    %esi
  8018f2:	5d                   	pop    %ebp
  8018f3:	c3                   	ret    

008018f4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	53                   	push   %ebx
  8018f8:	83 ec 24             	sub    $0x24,%esp
  8018fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018fe:	89 1c 24             	mov    %ebx,(%esp)
  801901:	e8 ea ef ff ff       	call   8008f0 <strlen>
  801906:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80190b:	7f 60                	jg     80196d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80190d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801910:	89 04 24             	mov    %eax,(%esp)
  801913:	e8 af f7 ff ff       	call   8010c7 <fd_alloc>
  801918:	89 c2                	mov    %eax,%edx
  80191a:	85 d2                	test   %edx,%edx
  80191c:	78 54                	js     801972 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80191e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801922:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801929:	e8 f9 ef ff ff       	call   800927 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801936:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801939:	b8 01 00 00 00       	mov    $0x1,%eax
  80193e:	e8 40 fd ff ff       	call   801683 <fsipc>
  801943:	89 c3                	mov    %eax,%ebx
  801945:	85 c0                	test   %eax,%eax
  801947:	79 17                	jns    801960 <open+0x6c>
		fd_close(fd, 0);
  801949:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801950:	00 
  801951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801954:	89 04 24             	mov    %eax,(%esp)
  801957:	e8 6a f8 ff ff       	call   8011c6 <fd_close>
		return r;
  80195c:	89 d8                	mov    %ebx,%eax
  80195e:	eb 12                	jmp    801972 <open+0x7e>
	}

	return fd2num(fd);
  801960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801963:	89 04 24             	mov    %eax,(%esp)
  801966:	e8 35 f7 ff ff       	call   8010a0 <fd2num>
  80196b:	eb 05                	jmp    801972 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80196d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801972:	83 c4 24             	add    $0x24,%esp
  801975:	5b                   	pop    %ebx
  801976:	5d                   	pop    %ebp
  801977:	c3                   	ret    

00801978 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80197e:	ba 00 00 00 00       	mov    $0x0,%edx
  801983:	b8 08 00 00 00       	mov    $0x8,%eax
  801988:	e8 f6 fc ff ff       	call   801683 <fsipc>
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <evict>:

int evict(void)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801995:	c7 04 24 8c 33 80 00 	movl   $0x80338c,(%esp)
  80199c:	e8 11 e9 ff ff       	call   8002b2 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  8019a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a6:	b8 09 00 00 00       	mov    $0x9,%eax
  8019ab:	e8 d3 fc ff ff       	call   801683 <fsipc>
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    
  8019b2:	66 90                	xchg   %ax,%ax
  8019b4:	66 90                	xchg   %ax,%ax
  8019b6:	66 90                	xchg   %ax,%ax
  8019b8:	66 90                	xchg   %ax,%ax
  8019ba:	66 90                	xchg   %ax,%ax
  8019bc:	66 90                	xchg   %ax,%ax
  8019be:	66 90                	xchg   %ax,%ax

008019c0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	57                   	push   %edi
  8019c4:	56                   	push   %esi
  8019c5:	53                   	push   %ebx
  8019c6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019d3:	00 
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	89 04 24             	mov    %eax,(%esp)
  8019da:	e8 15 ff ff ff       	call   8018f4 <open>
  8019df:	89 c1                	mov    %eax,%ecx
  8019e1:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	0f 88 41 05 00 00    	js     801f30 <spawn+0x570>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019ef:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8019f6:	00 
  8019f7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8019fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a01:	89 0c 24             	mov    %ecx,(%esp)
  801a04:	e8 33 fa ff ff       	call   80143c <readn>
  801a09:	3d 00 02 00 00       	cmp    $0x200,%eax
  801a0e:	75 0c                	jne    801a1c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801a10:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801a17:	45 4c 46 
  801a1a:	74 36                	je     801a52 <spawn+0x92>
		close(fd);
  801a1c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801a22:	89 04 24             	mov    %eax,(%esp)
  801a25:	e8 1d f8 ff ff       	call   801247 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a2a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801a31:	46 
  801a32:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3c:	c7 04 24 a5 33 80 00 	movl   $0x8033a5,(%esp)
  801a43:	e8 6a e8 ff ff       	call   8002b2 <cprintf>
		return -E_NOT_EXEC;
  801a48:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801a4d:	e9 3d 05 00 00       	jmp    801f8f <spawn+0x5cf>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801a52:	b8 08 00 00 00       	mov    $0x8,%eax
  801a57:	cd 30                	int    $0x30
  801a59:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801a5f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a65:	85 c0                	test   %eax,%eax
  801a67:	0f 88 cb 04 00 00    	js     801f38 <spawn+0x578>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a6d:	89 c6                	mov    %eax,%esi
  801a6f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801a75:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801a78:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a7e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a84:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a8b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a91:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a97:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801a9c:	be 00 00 00 00       	mov    $0x0,%esi
  801aa1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801aa4:	eb 0f                	jmp    801ab5 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801aa6:	89 04 24             	mov    %eax,(%esp)
  801aa9:	e8 42 ee ff ff       	call   8008f0 <strlen>
  801aae:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801ab2:	83 c3 01             	add    $0x1,%ebx
  801ab5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801abc:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	75 e3                	jne    801aa6 <spawn+0xe6>
  801ac3:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801ac9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801acf:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ad4:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ad6:	89 fa                	mov    %edi,%edx
  801ad8:	83 e2 fc             	and    $0xfffffffc,%edx
  801adb:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ae2:	29 c2                	sub    %eax,%edx
  801ae4:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801aea:	8d 42 f8             	lea    -0x8(%edx),%eax
  801aed:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801af2:	0f 86 50 04 00 00    	jbe    801f48 <spawn+0x588>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801af8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801aff:	00 
  801b00:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b07:	00 
  801b08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b0f:	e8 81 f2 ff ff       	call   800d95 <sys_page_alloc>
  801b14:	85 c0                	test   %eax,%eax
  801b16:	0f 88 73 04 00 00    	js     801f8f <spawn+0x5cf>
  801b1c:	be 00 00 00 00       	mov    $0x0,%esi
  801b21:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801b27:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b2a:	eb 30                	jmp    801b5c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801b2c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b32:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801b38:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  801b3b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b42:	89 3c 24             	mov    %edi,(%esp)
  801b45:	e8 dd ed ff ff       	call   800927 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b4a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801b4d:	89 04 24             	mov    %eax,(%esp)
  801b50:	e8 9b ed ff ff       	call   8008f0 <strlen>
  801b55:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b59:	83 c6 01             	add    $0x1,%esi
  801b5c:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  801b62:	7c c8                	jl     801b2c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801b64:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b6a:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801b70:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b77:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b7d:	74 24                	je     801ba3 <spawn+0x1e3>
  801b7f:	c7 44 24 0c 3c 34 80 	movl   $0x80343c,0xc(%esp)
  801b86:	00 
  801b87:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  801b8e:	00 
  801b8f:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  801b96:	00 
  801b97:	c7 04 24 bf 33 80 00 	movl   $0x8033bf,(%esp)
  801b9e:	e8 16 e6 ff ff       	call   8001b9 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801ba3:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801ba9:	89 c8                	mov    %ecx,%eax
  801bab:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801bb0:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801bb3:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801bb9:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801bbc:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801bc2:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801bc8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801bcf:	00 
  801bd0:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801bd7:	ee 
  801bd8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801bde:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801be9:	00 
  801bea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bf1:	e8 f3 f1 ff ff       	call   800de9 <sys_page_map>
  801bf6:	89 c3                	mov    %eax,%ebx
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	0f 88 79 03 00 00    	js     801f79 <spawn+0x5b9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801c00:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c07:	00 
  801c08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0f:	e8 28 f2 ff ff       	call   800e3c <sys_page_unmap>
  801c14:	89 c3                	mov    %eax,%ebx
  801c16:	85 c0                	test   %eax,%eax
  801c18:	0f 88 5b 03 00 00    	js     801f79 <spawn+0x5b9>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801c1e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801c24:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801c2b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c31:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801c38:	00 00 00 
  801c3b:	e9 b6 01 00 00       	jmp    801df6 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  801c40:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801c46:	83 38 01             	cmpl   $0x1,(%eax)
  801c49:	0f 85 99 01 00 00    	jne    801de8 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801c4f:	89 c2                	mov    %eax,%edx
  801c51:	8b 40 18             	mov    0x18(%eax),%eax
  801c54:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801c57:	83 f8 01             	cmp    $0x1,%eax
  801c5a:	19 c0                	sbb    %eax,%eax
  801c5c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801c62:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  801c69:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801c70:	89 d0                	mov    %edx,%eax
  801c72:	8b 4a 04             	mov    0x4(%edx),%ecx
  801c75:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801c7b:	8b 52 10             	mov    0x10(%edx),%edx
  801c7e:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  801c84:	8b 48 14             	mov    0x14(%eax),%ecx
  801c87:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  801c8d:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801c90:	89 f0                	mov    %esi,%eax
  801c92:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c97:	74 14                	je     801cad <spawn+0x2ed>
		va -= i;
  801c99:	29 c6                	sub    %eax,%esi
		memsz += i;
  801c9b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801ca1:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801ca7:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801cad:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cb2:	e9 23 01 00 00       	jmp    801dda <spawn+0x41a>
		if (i >= filesz) {
  801cb7:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801cbd:	77 2b                	ja     801cea <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801cbf:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cc5:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ccd:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801cd3:	89 04 24             	mov    %eax,(%esp)
  801cd6:	e8 ba f0 ff ff       	call   800d95 <sys_page_alloc>
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	0f 89 eb 00 00 00    	jns    801dce <spawn+0x40e>
  801ce3:	89 c3                	mov    %eax,%ebx
  801ce5:	e9 6f 02 00 00       	jmp    801f59 <spawn+0x599>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801cea:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801cf1:	00 
  801cf2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cf9:	00 
  801cfa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d01:	e8 8f f0 ff ff       	call   800d95 <sys_page_alloc>
  801d06:	85 c0                	test   %eax,%eax
  801d08:	0f 88 41 02 00 00    	js     801f4f <spawn+0x58f>
  801d0e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801d14:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801d16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1a:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d20:	89 04 24             	mov    %eax,(%esp)
  801d23:	e8 ec f7 ff ff       	call   801514 <seek>
  801d28:	85 c0                	test   %eax,%eax
  801d2a:	0f 88 23 02 00 00    	js     801f53 <spawn+0x593>
  801d30:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801d36:	29 f9                	sub    %edi,%ecx
  801d38:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d3a:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  801d40:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d45:	0f 47 c2             	cmova  %edx,%eax
  801d48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d4c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d53:	00 
  801d54:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d5a:	89 04 24             	mov    %eax,(%esp)
  801d5d:	e8 da f6 ff ff       	call   80143c <readn>
  801d62:	85 c0                	test   %eax,%eax
  801d64:	0f 88 ed 01 00 00    	js     801f57 <spawn+0x597>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801d6a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d70:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d74:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d78:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801d7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d82:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d89:	00 
  801d8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d91:	e8 53 f0 ff ff       	call   800de9 <sys_page_map>
  801d96:	85 c0                	test   %eax,%eax
  801d98:	79 20                	jns    801dba <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  801d9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d9e:	c7 44 24 08 cb 33 80 	movl   $0x8033cb,0x8(%esp)
  801da5:	00 
  801da6:	c7 44 24 04 a8 01 00 	movl   $0x1a8,0x4(%esp)
  801dad:	00 
  801dae:	c7 04 24 bf 33 80 00 	movl   $0x8033bf,(%esp)
  801db5:	e8 ff e3 ff ff       	call   8001b9 <_panic>
			sys_page_unmap(0, UTEMP);
  801dba:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801dc1:	00 
  801dc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dc9:	e8 6e f0 ff ff       	call   800e3c <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801dce:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801dd4:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801dda:	89 df                	mov    %ebx,%edi
  801ddc:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801de2:	0f 87 cf fe ff ff    	ja     801cb7 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801de8:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  801def:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801df6:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801dfd:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  801e03:	0f 8c 37 fe ff ff    	jl     801c40 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801e09:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e0f:	89 04 24             	mov    %eax,(%esp)
  801e12:	e8 30 f4 ff ff       	call   801247 <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
  801e17:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e1c:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801e22:	89 d8                	mov    %ebx,%eax
  801e24:	c1 e8 16             	shr    $0x16,%eax
  801e27:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e2e:	a8 01                	test   $0x1,%al
  801e30:	74 76                	je     801ea8 <spawn+0x4e8>
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
  801e32:	89 d8                	mov    %ebx,%eax
  801e34:	c1 e8 0c             	shr    $0xc,%eax
  801e37:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e3e:	f6 c6 04             	test   $0x4,%dh
  801e41:	74 5d                	je     801ea0 <spawn+0x4e0>
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  801e43:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
				cprintf("\nspawn addr:%p\n",addr);
  801e4a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e4e:	c7 04 24 e8 33 80 00 	movl   $0x8033e8,(%esp)
  801e55:	e8 58 e4 ff ff       	call   8002b2 <cprintf>
		if(uvpd[PDX(addr)] & PTE_P)
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  801e5a:	81 e7 07 0e 00 00    	and    $0xe07,%edi
				cprintf("\nspawn addr:%p\n",addr);
				if ((r = sys_page_map(0, (void *)addr, child, (void *)addr, perm)) < 0)
  801e60:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801e64:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e68:	89 74 24 08          	mov    %esi,0x8(%esp)
  801e6c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e77:	e8 6d ef ff ff       	call   800de9 <sys_page_map>
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	79 20                	jns    801ea0 <spawn+0x4e0>
					panic("sys_page_map: %e", r);
  801e80:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e84:	c7 44 24 08 f8 33 80 	movl   $0x8033f8,0x8(%esp)
  801e8b:	00 
  801e8c:	c7 44 24 04 c2 01 00 	movl   $0x1c2,0x4(%esp)
  801e93:	00 
  801e94:	c7 04 24 bf 33 80 00 	movl   $0x8033bf,(%esp)
  801e9b:	e8 19 e3 ff ff       	call   8001b9 <_panic>
			}
			addr += PGSIZE;
  801ea0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ea6:	eb 06                	jmp    801eae <spawn+0x4ee>
		}
		else
		{
			addr = addr + PTSIZE;
  801ea8:	81 c3 00 00 40 00    	add    $0x400000,%ebx
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
  801eae:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  801eb4:	0f 86 68 ff ff ff    	jbe    801e22 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801eba:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801ec0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec4:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801eca:	89 04 24             	mov    %eax,(%esp)
  801ecd:	e8 30 f0 ff ff       	call   800f02 <sys_env_set_trapframe>
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	79 20                	jns    801ef6 <spawn+0x536>
		panic("sys_env_set_trapframe: %e", r);
  801ed6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801eda:	c7 44 24 08 09 34 80 	movl   $0x803409,0x8(%esp)
  801ee1:	00 
  801ee2:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801ee9:	00 
  801eea:	c7 04 24 bf 33 80 00 	movl   $0x8033bf,(%esp)
  801ef1:	e8 c3 e2 ff ff       	call   8001b9 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801ef6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801efd:	00 
  801efe:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f04:	89 04 24             	mov    %eax,(%esp)
  801f07:	e8 a3 ef ff ff       	call   800eaf <sys_env_set_status>
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	79 30                	jns    801f40 <spawn+0x580>
		panic("sys_env_set_status: %e", r);
  801f10:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f14:	c7 44 24 08 23 34 80 	movl   $0x803423,0x8(%esp)
  801f1b:	00 
  801f1c:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  801f23:	00 
  801f24:	c7 04 24 bf 33 80 00 	movl   $0x8033bf,(%esp)
  801f2b:	e8 89 e2 ff ff       	call   8001b9 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801f30:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801f36:	eb 57                	jmp    801f8f <spawn+0x5cf>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801f38:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f3e:	eb 4f                	jmp    801f8f <spawn+0x5cf>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801f40:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f46:	eb 47                	jmp    801f8f <spawn+0x5cf>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801f48:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801f4d:	eb 40                	jmp    801f8f <spawn+0x5cf>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f4f:	89 c3                	mov    %eax,%ebx
  801f51:	eb 06                	jmp    801f59 <spawn+0x599>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801f53:	89 c3                	mov    %eax,%ebx
  801f55:	eb 02                	jmp    801f59 <spawn+0x599>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801f57:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  801f59:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f5f:	89 04 24             	mov    %eax,(%esp)
  801f62:	e8 4c ed ff ff       	call   800cb3 <sys_env_destroy>
	close(fd);
  801f67:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801f6d:	89 04 24             	mov    %eax,(%esp)
  801f70:	e8 d2 f2 ff ff       	call   801247 <close>
	return r;
  801f75:	89 d8                	mov    %ebx,%eax
  801f77:	eb 16                	jmp    801f8f <spawn+0x5cf>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801f79:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f80:	00 
  801f81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f88:	e8 af ee ff ff       	call   800e3c <sys_page_unmap>
  801f8d:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801f8f:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  801f95:	5b                   	pop    %ebx
  801f96:	5e                   	pop    %esi
  801f97:	5f                   	pop    %edi
  801f98:	5d                   	pop    %ebp
  801f99:	c3                   	ret    

00801f9a <exec>:

int
exec(const char *prog, const char **argv)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	sys_env_destroy(child);
	close(fd);
	return r;*/
	return 0;

}
  801f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    

00801fa4 <execl>:


int execl(const char *prog, const char *arg0, ...)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801fa7:	8d 45 10             	lea    0x10(%ebp),%eax


int execl(const char *prog, const char *arg0, ...)
{
	//works same as spawnl
	int argc=0;
  801faa:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801faf:	eb 03                	jmp    801fb4 <execl+0x10>
		argc++;
  801fb1:	83 c2 01             	add    $0x1,%edx
{
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801fb4:	83 c0 04             	add    $0x4,%eax
  801fb7:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801fbb:	75 f4                	jne    801fb1 <execl+0xd>
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc2:	eb 03                	jmp    801fc7 <execl+0x23>
		argv[i+1] = va_arg(vl, const char *);
  801fc4:	83 c0 01             	add    $0x1,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801fc7:	39 d0                	cmp    %edx,%eax
  801fc9:	75 f9                	jne    801fc4 <execl+0x20>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
}
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	5d                   	pop    %ebp
  801fd1:	c3                   	ret    

00801fd2 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	56                   	push   %esi
  801fd6:	53                   	push   %ebx
  801fd7:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801fda:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801fdd:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801fe2:	eb 03                	jmp    801fe7 <spawnl+0x15>
		argc++;
  801fe4:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801fe7:	83 c0 04             	add    $0x4,%eax
  801fea:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801fee:	75 f4                	jne    801fe4 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801ff0:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  801ff7:	83 e0 f0             	and    $0xfffffff0,%eax
  801ffa:	29 c4                	sub    %eax,%esp
  801ffc:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802000:	c1 e8 02             	shr    $0x2,%eax
  802003:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  80200a:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80200c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80200f:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  802016:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  80201d:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
  802023:	eb 0a                	jmp    80202f <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  802025:	83 c0 01             	add    $0x1,%eax
  802028:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  80202c:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80202f:	39 d0                	cmp    %edx,%eax
  802031:	75 f2                	jne    802025 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802033:	89 74 24 04          	mov    %esi,0x4(%esp)
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	89 04 24             	mov    %eax,(%esp)
  80203d:	e8 7e f9 ff ff       	call   8019c0 <spawn>
}
  802042:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802045:	5b                   	pop    %ebx
  802046:	5e                   	pop    %esi
  802047:	5d                   	pop    %ebp
  802048:	c3                   	ret    
  802049:	66 90                	xchg   %ax,%ax
  80204b:	66 90                	xchg   %ax,%ax
  80204d:	66 90                	xchg   %ax,%ax
  80204f:	90                   	nop

00802050 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802056:	c7 44 24 04 62 34 80 	movl   $0x803462,0x4(%esp)
  80205d:	00 
  80205e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802061:	89 04 24             	mov    %eax,(%esp)
  802064:	e8 be e8 ff ff       	call   800927 <strcpy>
	return 0;
}
  802069:	b8 00 00 00 00       	mov    $0x0,%eax
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	53                   	push   %ebx
  802074:	83 ec 14             	sub    $0x14,%esp
  802077:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80207a:	89 1c 24             	mov    %ebx,(%esp)
  80207d:	e8 15 0b 00 00       	call   802b97 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802082:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802087:	83 f8 01             	cmp    $0x1,%eax
  80208a:	75 0d                	jne    802099 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80208c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80208f:	89 04 24             	mov    %eax,(%esp)
  802092:	e8 29 03 00 00       	call   8023c0 <nsipc_close>
  802097:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802099:	89 d0                	mov    %edx,%eax
  80209b:	83 c4 14             	add    $0x14,%esp
  80209e:	5b                   	pop    %ebx
  80209f:	5d                   	pop    %ebp
  8020a0:	c3                   	ret    

008020a1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020a7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020ae:	00 
  8020af:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c3:	89 04 24             	mov    %eax,(%esp)
  8020c6:	e8 f0 03 00 00       	call   8024bb <nsipc_send>
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020da:	00 
  8020db:	8b 45 10             	mov    0x10(%ebp),%eax
  8020de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ef:	89 04 24             	mov    %eax,(%esp)
  8020f2:	e8 44 03 00 00       	call   80243b <nsipc_recv>
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020ff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802102:	89 54 24 04          	mov    %edx,0x4(%esp)
  802106:	89 04 24             	mov    %eax,(%esp)
  802109:	e8 08 f0 ff ff       	call   801116 <fd_lookup>
  80210e:	85 c0                	test   %eax,%eax
  802110:	78 17                	js     802129 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80211b:	39 08                	cmp    %ecx,(%eax)
  80211d:	75 05                	jne    802124 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80211f:	8b 40 0c             	mov    0xc(%eax),%eax
  802122:	eb 05                	jmp    802129 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802124:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	56                   	push   %esi
  80212f:	53                   	push   %ebx
  802130:	83 ec 20             	sub    $0x20,%esp
  802133:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802135:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802138:	89 04 24             	mov    %eax,(%esp)
  80213b:	e8 87 ef ff ff       	call   8010c7 <fd_alloc>
  802140:	89 c3                	mov    %eax,%ebx
  802142:	85 c0                	test   %eax,%eax
  802144:	78 21                	js     802167 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802146:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80214d:	00 
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	89 44 24 04          	mov    %eax,0x4(%esp)
  802155:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80215c:	e8 34 ec ff ff       	call   800d95 <sys_page_alloc>
  802161:	89 c3                	mov    %eax,%ebx
  802163:	85 c0                	test   %eax,%eax
  802165:	79 0c                	jns    802173 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802167:	89 34 24             	mov    %esi,(%esp)
  80216a:	e8 51 02 00 00       	call   8023c0 <nsipc_close>
		return r;
  80216f:	89 d8                	mov    %ebx,%eax
  802171:	eb 20                	jmp    802193 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802173:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80217e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802181:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802188:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80218b:	89 14 24             	mov    %edx,(%esp)
  80218e:	e8 0d ef ff ff       	call   8010a0 <fd2num>
}
  802193:	83 c4 20             	add    $0x20,%esp
  802196:	5b                   	pop    %ebx
  802197:	5e                   	pop    %esi
  802198:	5d                   	pop    %ebp
  802199:	c3                   	ret    

0080219a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	e8 51 ff ff ff       	call   8020f9 <fd2sockid>
		return r;
  8021a8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	78 23                	js     8021d1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021ae:	8b 55 10             	mov    0x10(%ebp),%edx
  8021b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021bc:	89 04 24             	mov    %eax,(%esp)
  8021bf:	e8 45 01 00 00       	call   802309 <nsipc_accept>
		return r;
  8021c4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	78 07                	js     8021d1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8021ca:	e8 5c ff ff ff       	call   80212b <alloc_sockfd>
  8021cf:	89 c1                	mov    %eax,%ecx
}
  8021d1:	89 c8                	mov    %ecx,%eax
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	e8 16 ff ff ff       	call   8020f9 <fd2sockid>
  8021e3:	89 c2                	mov    %eax,%edx
  8021e5:	85 d2                	test   %edx,%edx
  8021e7:	78 16                	js     8021ff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8021e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f7:	89 14 24             	mov    %edx,(%esp)
  8021fa:	e8 60 01 00 00       	call   80235f <nsipc_bind>
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <shutdown>:

int
shutdown(int s, int how)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
  802204:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	e8 ea fe ff ff       	call   8020f9 <fd2sockid>
  80220f:	89 c2                	mov    %eax,%edx
  802211:	85 d2                	test   %edx,%edx
  802213:	78 0f                	js     802224 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802215:	8b 45 0c             	mov    0xc(%ebp),%eax
  802218:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221c:	89 14 24             	mov    %edx,(%esp)
  80221f:	e8 7a 01 00 00       	call   80239e <nsipc_shutdown>
}
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	e8 c5 fe ff ff       	call   8020f9 <fd2sockid>
  802234:	89 c2                	mov    %eax,%edx
  802236:	85 d2                	test   %edx,%edx
  802238:	78 16                	js     802250 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80223a:	8b 45 10             	mov    0x10(%ebp),%eax
  80223d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802241:	8b 45 0c             	mov    0xc(%ebp),%eax
  802244:	89 44 24 04          	mov    %eax,0x4(%esp)
  802248:	89 14 24             	mov    %edx,(%esp)
  80224b:	e8 8a 01 00 00       	call   8023da <nsipc_connect>
}
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <listen>:

int
listen(int s, int backlog)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	e8 99 fe ff ff       	call   8020f9 <fd2sockid>
  802260:	89 c2                	mov    %eax,%edx
  802262:	85 d2                	test   %edx,%edx
  802264:	78 0f                	js     802275 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802266:	8b 45 0c             	mov    0xc(%ebp),%eax
  802269:	89 44 24 04          	mov    %eax,0x4(%esp)
  80226d:	89 14 24             	mov    %edx,(%esp)
  802270:	e8 a4 01 00 00       	call   802419 <nsipc_listen>
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80227d:	8b 45 10             	mov    0x10(%ebp),%eax
  802280:	89 44 24 08          	mov    %eax,0x8(%esp)
  802284:	8b 45 0c             	mov    0xc(%ebp),%eax
  802287:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	89 04 24             	mov    %eax,(%esp)
  802291:	e8 98 02 00 00       	call   80252e <nsipc_socket>
  802296:	89 c2                	mov    %eax,%edx
  802298:	85 d2                	test   %edx,%edx
  80229a:	78 05                	js     8022a1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80229c:	e8 8a fe ff ff       	call   80212b <alloc_sockfd>
}
  8022a1:	c9                   	leave  
  8022a2:	c3                   	ret    

008022a3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022a3:	55                   	push   %ebp
  8022a4:	89 e5                	mov    %esp,%ebp
  8022a6:	53                   	push   %ebx
  8022a7:	83 ec 14             	sub    $0x14,%esp
  8022aa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022ac:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8022b3:	75 11                	jne    8022c6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022b5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8022bc:	e8 9e 08 00 00       	call   802b5f <ipc_find_env>
  8022c1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022c6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022cd:	00 
  8022ce:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8022d5:	00 
  8022d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022da:	a1 04 50 80 00       	mov    0x805004,%eax
  8022df:	89 04 24             	mov    %eax,(%esp)
  8022e2:	e8 11 08 00 00       	call   802af8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022ee:	00 
  8022ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022f6:	00 
  8022f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022fe:	e8 8d 07 00 00       	call   802a90 <ipc_recv>
}
  802303:	83 c4 14             	add    $0x14,%esp
  802306:	5b                   	pop    %ebx
  802307:	5d                   	pop    %ebp
  802308:	c3                   	ret    

00802309 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	56                   	push   %esi
  80230d:	53                   	push   %ebx
  80230e:	83 ec 10             	sub    $0x10,%esp
  802311:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80231c:	8b 06                	mov    (%esi),%eax
  80231e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802323:	b8 01 00 00 00       	mov    $0x1,%eax
  802328:	e8 76 ff ff ff       	call   8022a3 <nsipc>
  80232d:	89 c3                	mov    %eax,%ebx
  80232f:	85 c0                	test   %eax,%eax
  802331:	78 23                	js     802356 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802333:	a1 10 70 80 00       	mov    0x807010,%eax
  802338:	89 44 24 08          	mov    %eax,0x8(%esp)
  80233c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802343:	00 
  802344:	8b 45 0c             	mov    0xc(%ebp),%eax
  802347:	89 04 24             	mov    %eax,(%esp)
  80234a:	e8 75 e7 ff ff       	call   800ac4 <memmove>
		*addrlen = ret->ret_addrlen;
  80234f:	a1 10 70 80 00       	mov    0x807010,%eax
  802354:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802356:	89 d8                	mov    %ebx,%eax
  802358:	83 c4 10             	add    $0x10,%esp
  80235b:	5b                   	pop    %ebx
  80235c:	5e                   	pop    %esi
  80235d:	5d                   	pop    %ebp
  80235e:	c3                   	ret    

0080235f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	53                   	push   %ebx
  802363:	83 ec 14             	sub    $0x14,%esp
  802366:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802371:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802375:	8b 45 0c             	mov    0xc(%ebp),%eax
  802378:	89 44 24 04          	mov    %eax,0x4(%esp)
  80237c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802383:	e8 3c e7 ff ff       	call   800ac4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802388:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80238e:	b8 02 00 00 00       	mov    $0x2,%eax
  802393:	e8 0b ff ff ff       	call   8022a3 <nsipc>
}
  802398:	83 c4 14             	add    $0x14,%esp
  80239b:	5b                   	pop    %ebx
  80239c:	5d                   	pop    %ebp
  80239d:	c3                   	ret    

0080239e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8023ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023af:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8023b4:	b8 03 00 00 00       	mov    $0x3,%eax
  8023b9:	e8 e5 fe ff ff       	call   8022a3 <nsipc>
}
  8023be:	c9                   	leave  
  8023bf:	c3                   	ret    

008023c0 <nsipc_close>:

int
nsipc_close(int s)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023ce:	b8 04 00 00 00       	mov    $0x4,%eax
  8023d3:	e8 cb fe ff ff       	call   8022a3 <nsipc>
}
  8023d8:	c9                   	leave  
  8023d9:	c3                   	ret    

008023da <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
  8023dd:	53                   	push   %ebx
  8023de:	83 ec 14             	sub    $0x14,%esp
  8023e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8023fe:	e8 c1 e6 ff ff       	call   800ac4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802403:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802409:	b8 05 00 00 00       	mov    $0x5,%eax
  80240e:	e8 90 fe ff ff       	call   8022a3 <nsipc>
}
  802413:	83 c4 14             	add    $0x14,%esp
  802416:	5b                   	pop    %ebx
  802417:	5d                   	pop    %ebp
  802418:	c3                   	ret    

00802419 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
  80241c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80242f:	b8 06 00 00 00       	mov    $0x6,%eax
  802434:	e8 6a fe ff ff       	call   8022a3 <nsipc>
}
  802439:	c9                   	leave  
  80243a:	c3                   	ret    

0080243b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	56                   	push   %esi
  80243f:	53                   	push   %ebx
  802440:	83 ec 10             	sub    $0x10,%esp
  802443:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80244e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802454:	8b 45 14             	mov    0x14(%ebp),%eax
  802457:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80245c:	b8 07 00 00 00       	mov    $0x7,%eax
  802461:	e8 3d fe ff ff       	call   8022a3 <nsipc>
  802466:	89 c3                	mov    %eax,%ebx
  802468:	85 c0                	test   %eax,%eax
  80246a:	78 46                	js     8024b2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80246c:	39 f0                	cmp    %esi,%eax
  80246e:	7f 07                	jg     802477 <nsipc_recv+0x3c>
  802470:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802475:	7e 24                	jle    80249b <nsipc_recv+0x60>
  802477:	c7 44 24 0c 6e 34 80 	movl   $0x80346e,0xc(%esp)
  80247e:	00 
  80247f:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  802486:	00 
  802487:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80248e:	00 
  80248f:	c7 04 24 83 34 80 00 	movl   $0x803483,(%esp)
  802496:	e8 1e dd ff ff       	call   8001b9 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80249b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80249f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8024a6:	00 
  8024a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024aa:	89 04 24             	mov    %eax,(%esp)
  8024ad:	e8 12 e6 ff ff       	call   800ac4 <memmove>
	}

	return r;
}
  8024b2:	89 d8                	mov    %ebx,%eax
  8024b4:	83 c4 10             	add    $0x10,%esp
  8024b7:	5b                   	pop    %ebx
  8024b8:	5e                   	pop    %esi
  8024b9:	5d                   	pop    %ebp
  8024ba:	c3                   	ret    

008024bb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	53                   	push   %ebx
  8024bf:	83 ec 14             	sub    $0x14,%esp
  8024c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8024c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8024cd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8024d3:	7e 24                	jle    8024f9 <nsipc_send+0x3e>
  8024d5:	c7 44 24 0c 8f 34 80 	movl   $0x80348f,0xc(%esp)
  8024dc:	00 
  8024dd:	c7 44 24 08 60 33 80 	movl   $0x803360,0x8(%esp)
  8024e4:	00 
  8024e5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8024ec:	00 
  8024ed:	c7 04 24 83 34 80 00 	movl   $0x803483,(%esp)
  8024f4:	e8 c0 dc ff ff       	call   8001b9 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8024f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802500:	89 44 24 04          	mov    %eax,0x4(%esp)
  802504:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80250b:	e8 b4 e5 ff ff       	call   800ac4 <memmove>
	nsipcbuf.send.req_size = size;
  802510:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802516:	8b 45 14             	mov    0x14(%ebp),%eax
  802519:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80251e:	b8 08 00 00 00       	mov    $0x8,%eax
  802523:	e8 7b fd ff ff       	call   8022a3 <nsipc>
}
  802528:	83 c4 14             	add    $0x14,%esp
  80252b:	5b                   	pop    %ebx
  80252c:	5d                   	pop    %ebp
  80252d:	c3                   	ret    

0080252e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
  802531:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802534:	8b 45 08             	mov    0x8(%ebp),%eax
  802537:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80253c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802544:	8b 45 10             	mov    0x10(%ebp),%eax
  802547:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80254c:	b8 09 00 00 00       	mov    $0x9,%eax
  802551:	e8 4d fd ff ff       	call   8022a3 <nsipc>
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	56                   	push   %esi
  80255c:	53                   	push   %ebx
  80255d:	83 ec 10             	sub    $0x10,%esp
  802560:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	89 04 24             	mov    %eax,(%esp)
  802569:	e8 42 eb ff ff       	call   8010b0 <fd2data>
  80256e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802570:	c7 44 24 04 9b 34 80 	movl   $0x80349b,0x4(%esp)
  802577:	00 
  802578:	89 1c 24             	mov    %ebx,(%esp)
  80257b:	e8 a7 e3 ff ff       	call   800927 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802580:	8b 46 04             	mov    0x4(%esi),%eax
  802583:	2b 06                	sub    (%esi),%eax
  802585:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80258b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802592:	00 00 00 
	stat->st_dev = &devpipe;
  802595:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80259c:	40 80 00 
	return 0;
}
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a4:	83 c4 10             	add    $0x10,%esp
  8025a7:	5b                   	pop    %ebx
  8025a8:	5e                   	pop    %esi
  8025a9:	5d                   	pop    %ebp
  8025aa:	c3                   	ret    

008025ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
  8025ae:	53                   	push   %ebx
  8025af:	83 ec 14             	sub    $0x14,%esp
  8025b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c0:	e8 77 e8 ff ff       	call   800e3c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025c5:	89 1c 24             	mov    %ebx,(%esp)
  8025c8:	e8 e3 ea ff ff       	call   8010b0 <fd2data>
  8025cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d8:	e8 5f e8 ff ff       	call   800e3c <sys_page_unmap>
}
  8025dd:	83 c4 14             	add    $0x14,%esp
  8025e0:	5b                   	pop    %ebx
  8025e1:	5d                   	pop    %ebp
  8025e2:	c3                   	ret    

008025e3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	57                   	push   %edi
  8025e7:	56                   	push   %esi
  8025e8:	53                   	push   %ebx
  8025e9:	83 ec 2c             	sub    $0x2c,%esp
  8025ec:	89 c6                	mov    %eax,%esi
  8025ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8025f1:	a1 08 50 80 00       	mov    0x805008,%eax
  8025f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025f9:	89 34 24             	mov    %esi,(%esp)
  8025fc:	e8 96 05 00 00       	call   802b97 <pageref>
  802601:	89 c7                	mov    %eax,%edi
  802603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802606:	89 04 24             	mov    %eax,(%esp)
  802609:	e8 89 05 00 00       	call   802b97 <pageref>
  80260e:	39 c7                	cmp    %eax,%edi
  802610:	0f 94 c2             	sete   %dl
  802613:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802616:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80261c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80261f:	39 fb                	cmp    %edi,%ebx
  802621:	74 21                	je     802644 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802623:	84 d2                	test   %dl,%dl
  802625:	74 ca                	je     8025f1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802627:	8b 51 58             	mov    0x58(%ecx),%edx
  80262a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80262e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802632:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802636:	c7 04 24 a2 34 80 00 	movl   $0x8034a2,(%esp)
  80263d:	e8 70 dc ff ff       	call   8002b2 <cprintf>
  802642:	eb ad                	jmp    8025f1 <_pipeisclosed+0xe>
	}
}
  802644:	83 c4 2c             	add    $0x2c,%esp
  802647:	5b                   	pop    %ebx
  802648:	5e                   	pop    %esi
  802649:	5f                   	pop    %edi
  80264a:	5d                   	pop    %ebp
  80264b:	c3                   	ret    

0080264c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	57                   	push   %edi
  802650:	56                   	push   %esi
  802651:	53                   	push   %ebx
  802652:	83 ec 1c             	sub    $0x1c,%esp
  802655:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802658:	89 34 24             	mov    %esi,(%esp)
  80265b:	e8 50 ea ff ff       	call   8010b0 <fd2data>
  802660:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802662:	bf 00 00 00 00       	mov    $0x0,%edi
  802667:	eb 45                	jmp    8026ae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802669:	89 da                	mov    %ebx,%edx
  80266b:	89 f0                	mov    %esi,%eax
  80266d:	e8 71 ff ff ff       	call   8025e3 <_pipeisclosed>
  802672:	85 c0                	test   %eax,%eax
  802674:	75 41                	jne    8026b7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802676:	e8 fb e6 ff ff       	call   800d76 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80267b:	8b 43 04             	mov    0x4(%ebx),%eax
  80267e:	8b 0b                	mov    (%ebx),%ecx
  802680:	8d 51 20             	lea    0x20(%ecx),%edx
  802683:	39 d0                	cmp    %edx,%eax
  802685:	73 e2                	jae    802669 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802687:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80268a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80268e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802691:	99                   	cltd   
  802692:	c1 ea 1b             	shr    $0x1b,%edx
  802695:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802698:	83 e1 1f             	and    $0x1f,%ecx
  80269b:	29 d1                	sub    %edx,%ecx
  80269d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8026a1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8026a5:	83 c0 01             	add    $0x1,%eax
  8026a8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026ab:	83 c7 01             	add    $0x1,%edi
  8026ae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8026b1:	75 c8                	jne    80267b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8026b3:	89 f8                	mov    %edi,%eax
  8026b5:	eb 05                	jmp    8026bc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026b7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8026bc:	83 c4 1c             	add    $0x1c,%esp
  8026bf:	5b                   	pop    %ebx
  8026c0:	5e                   	pop    %esi
  8026c1:	5f                   	pop    %edi
  8026c2:	5d                   	pop    %ebp
  8026c3:	c3                   	ret    

008026c4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
  8026c7:	57                   	push   %edi
  8026c8:	56                   	push   %esi
  8026c9:	53                   	push   %ebx
  8026ca:	83 ec 1c             	sub    $0x1c,%esp
  8026cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8026d0:	89 3c 24             	mov    %edi,(%esp)
  8026d3:	e8 d8 e9 ff ff       	call   8010b0 <fd2data>
  8026d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026da:	be 00 00 00 00       	mov    $0x0,%esi
  8026df:	eb 3d                	jmp    80271e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8026e1:	85 f6                	test   %esi,%esi
  8026e3:	74 04                	je     8026e9 <devpipe_read+0x25>
				return i;
  8026e5:	89 f0                	mov    %esi,%eax
  8026e7:	eb 43                	jmp    80272c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8026e9:	89 da                	mov    %ebx,%edx
  8026eb:	89 f8                	mov    %edi,%eax
  8026ed:	e8 f1 fe ff ff       	call   8025e3 <_pipeisclosed>
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	75 31                	jne    802727 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8026f6:	e8 7b e6 ff ff       	call   800d76 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8026fb:	8b 03                	mov    (%ebx),%eax
  8026fd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802700:	74 df                	je     8026e1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802702:	99                   	cltd   
  802703:	c1 ea 1b             	shr    $0x1b,%edx
  802706:	01 d0                	add    %edx,%eax
  802708:	83 e0 1f             	and    $0x1f,%eax
  80270b:	29 d0                	sub    %edx,%eax
  80270d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802712:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802715:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802718:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80271b:	83 c6 01             	add    $0x1,%esi
  80271e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802721:	75 d8                	jne    8026fb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802723:	89 f0                	mov    %esi,%eax
  802725:	eb 05                	jmp    80272c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802727:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80272c:	83 c4 1c             	add    $0x1c,%esp
  80272f:	5b                   	pop    %ebx
  802730:	5e                   	pop    %esi
  802731:	5f                   	pop    %edi
  802732:	5d                   	pop    %ebp
  802733:	c3                   	ret    

00802734 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
  802737:	56                   	push   %esi
  802738:	53                   	push   %ebx
  802739:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80273c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80273f:	89 04 24             	mov    %eax,(%esp)
  802742:	e8 80 e9 ff ff       	call   8010c7 <fd_alloc>
  802747:	89 c2                	mov    %eax,%edx
  802749:	85 d2                	test   %edx,%edx
  80274b:	0f 88 4d 01 00 00    	js     80289e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802751:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802758:	00 
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802760:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802767:	e8 29 e6 ff ff       	call   800d95 <sys_page_alloc>
  80276c:	89 c2                	mov    %eax,%edx
  80276e:	85 d2                	test   %edx,%edx
  802770:	0f 88 28 01 00 00    	js     80289e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802776:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802779:	89 04 24             	mov    %eax,(%esp)
  80277c:	e8 46 e9 ff ff       	call   8010c7 <fd_alloc>
  802781:	89 c3                	mov    %eax,%ebx
  802783:	85 c0                	test   %eax,%eax
  802785:	0f 88 fe 00 00 00    	js     802889 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80278b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802792:	00 
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	89 44 24 04          	mov    %eax,0x4(%esp)
  80279a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027a1:	e8 ef e5 ff ff       	call   800d95 <sys_page_alloc>
  8027a6:	89 c3                	mov    %eax,%ebx
  8027a8:	85 c0                	test   %eax,%eax
  8027aa:	0f 88 d9 00 00 00    	js     802889 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	89 04 24             	mov    %eax,(%esp)
  8027b6:	e8 f5 e8 ff ff       	call   8010b0 <fd2data>
  8027bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027bd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027c4:	00 
  8027c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d0:	e8 c0 e5 ff ff       	call   800d95 <sys_page_alloc>
  8027d5:	89 c3                	mov    %eax,%ebx
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	0f 88 97 00 00 00    	js     802876 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	89 04 24             	mov    %eax,(%esp)
  8027e5:	e8 c6 e8 ff ff       	call   8010b0 <fd2data>
  8027ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8027f1:	00 
  8027f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8027fd:	00 
  8027fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802802:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802809:	e8 db e5 ff ff       	call   800de9 <sys_page_map>
  80280e:	89 c3                	mov    %eax,%ebx
  802810:	85 c0                	test   %eax,%eax
  802812:	78 52                	js     802866 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802814:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802829:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80282f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802832:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802837:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	89 04 24             	mov    %eax,(%esp)
  802844:	e8 57 e8 ff ff       	call   8010a0 <fd2num>
  802849:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80284c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80284e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802851:	89 04 24             	mov    %eax,(%esp)
  802854:	e8 47 e8 ff ff       	call   8010a0 <fd2num>
  802859:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80285c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80285f:	b8 00 00 00 00       	mov    $0x0,%eax
  802864:	eb 38                	jmp    80289e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802866:	89 74 24 04          	mov    %esi,0x4(%esp)
  80286a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802871:	e8 c6 e5 ff ff       	call   800e3c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	89 44 24 04          	mov    %eax,0x4(%esp)
  80287d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802884:	e8 b3 e5 ff ff       	call   800e3c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802890:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802897:	e8 a0 e5 ff ff       	call   800e3c <sys_page_unmap>
  80289c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80289e:	83 c4 30             	add    $0x30,%esp
  8028a1:	5b                   	pop    %ebx
  8028a2:	5e                   	pop    %esi
  8028a3:	5d                   	pop    %ebp
  8028a4:	c3                   	ret    

008028a5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
  8028a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	89 04 24             	mov    %eax,(%esp)
  8028b8:	e8 59 e8 ff ff       	call   801116 <fd_lookup>
  8028bd:	89 c2                	mov    %eax,%edx
  8028bf:	85 d2                	test   %edx,%edx
  8028c1:	78 15                	js     8028d8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	89 04 24             	mov    %eax,(%esp)
  8028c9:	e8 e2 e7 ff ff       	call   8010b0 <fd2data>
	return _pipeisclosed(fd, p);
  8028ce:	89 c2                	mov    %eax,%edx
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	e8 0b fd ff ff       	call   8025e3 <_pipeisclosed>
}
  8028d8:	c9                   	leave  
  8028d9:	c3                   	ret    
  8028da:	66 90                	xchg   %ax,%ax
  8028dc:	66 90                	xchg   %ax,%ax
  8028de:	66 90                	xchg   %ax,%ax

008028e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8028e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e8:	5d                   	pop    %ebp
  8028e9:	c3                   	ret    

008028ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
  8028ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8028f0:	c7 44 24 04 ba 34 80 	movl   $0x8034ba,0x4(%esp)
  8028f7:	00 
  8028f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028fb:	89 04 24             	mov    %eax,(%esp)
  8028fe:	e8 24 e0 ff ff       	call   800927 <strcpy>
	return 0;
}
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	57                   	push   %edi
  80290e:	56                   	push   %esi
  80290f:	53                   	push   %ebx
  802910:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802916:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80291b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802921:	eb 31                	jmp    802954 <devcons_write+0x4a>
		m = n - tot;
  802923:	8b 75 10             	mov    0x10(%ebp),%esi
  802926:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802928:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80292b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802930:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802933:	89 74 24 08          	mov    %esi,0x8(%esp)
  802937:	03 45 0c             	add    0xc(%ebp),%eax
  80293a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80293e:	89 3c 24             	mov    %edi,(%esp)
  802941:	e8 7e e1 ff ff       	call   800ac4 <memmove>
		sys_cputs(buf, m);
  802946:	89 74 24 04          	mov    %esi,0x4(%esp)
  80294a:	89 3c 24             	mov    %edi,(%esp)
  80294d:	e8 24 e3 ff ff       	call   800c76 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802952:	01 f3                	add    %esi,%ebx
  802954:	89 d8                	mov    %ebx,%eax
  802956:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802959:	72 c8                	jb     802923 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80295b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802961:	5b                   	pop    %ebx
  802962:	5e                   	pop    %esi
  802963:	5f                   	pop    %edi
  802964:	5d                   	pop    %ebp
  802965:	c3                   	ret    

00802966 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
  802969:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80296c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802971:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802975:	75 07                	jne    80297e <devcons_read+0x18>
  802977:	eb 2a                	jmp    8029a3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802979:	e8 f8 e3 ff ff       	call   800d76 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80297e:	66 90                	xchg   %ax,%ax
  802980:	e8 0f e3 ff ff       	call   800c94 <sys_cgetc>
  802985:	85 c0                	test   %eax,%eax
  802987:	74 f0                	je     802979 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802989:	85 c0                	test   %eax,%eax
  80298b:	78 16                	js     8029a3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80298d:	83 f8 04             	cmp    $0x4,%eax
  802990:	74 0c                	je     80299e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802992:	8b 55 0c             	mov    0xc(%ebp),%edx
  802995:	88 02                	mov    %al,(%edx)
	return 1;
  802997:	b8 01 00 00 00       	mov    $0x1,%eax
  80299c:	eb 05                	jmp    8029a3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8029a3:	c9                   	leave  
  8029a4:	c3                   	ret    

008029a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029a5:	55                   	push   %ebp
  8029a6:	89 e5                	mov    %esp,%ebp
  8029a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029b8:	00 
  8029b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029bc:	89 04 24             	mov    %eax,(%esp)
  8029bf:	e8 b2 e2 ff ff       	call   800c76 <sys_cputs>
}
  8029c4:	c9                   	leave  
  8029c5:	c3                   	ret    

008029c6 <getchar>:

int
getchar(void)
{
  8029c6:	55                   	push   %ebp
  8029c7:	89 e5                	mov    %esp,%ebp
  8029c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8029cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8029d3:	00 
  8029d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029e2:	e8 c3 e9 ff ff       	call   8013aa <read>
	if (r < 0)
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	78 0f                	js     8029fa <getchar+0x34>
		return r;
	if (r < 1)
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	7e 06                	jle    8029f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8029ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8029f3:	eb 05                	jmp    8029fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8029f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8029fa:	c9                   	leave  
  8029fb:	c3                   	ret    

008029fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8029fc:	55                   	push   %ebp
  8029fd:	89 e5                	mov    %esp,%ebp
  8029ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a05:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	89 04 24             	mov    %eax,(%esp)
  802a0f:	e8 02 e7 ff ff       	call   801116 <fd_lookup>
  802a14:	85 c0                	test   %eax,%eax
  802a16:	78 11                	js     802a29 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a21:	39 10                	cmp    %edx,(%eax)
  802a23:	0f 94 c0             	sete   %al
  802a26:	0f b6 c0             	movzbl %al,%eax
}
  802a29:	c9                   	leave  
  802a2a:	c3                   	ret    

00802a2b <opencons>:

int
opencons(void)
{
  802a2b:	55                   	push   %ebp
  802a2c:	89 e5                	mov    %esp,%ebp
  802a2e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a31:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a34:	89 04 24             	mov    %eax,(%esp)
  802a37:	e8 8b e6 ff ff       	call   8010c7 <fd_alloc>
		return r;
  802a3c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a3e:	85 c0                	test   %eax,%eax
  802a40:	78 40                	js     802a82 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a42:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a49:	00 
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a58:	e8 38 e3 ff ff       	call   800d95 <sys_page_alloc>
		return r;
  802a5d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	78 1f                	js     802a82 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a63:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a78:	89 04 24             	mov    %eax,(%esp)
  802a7b:	e8 20 e6 ff ff       	call   8010a0 <fd2num>
  802a80:	89 c2                	mov    %eax,%edx
}
  802a82:	89 d0                	mov    %edx,%eax
  802a84:	c9                   	leave  
  802a85:	c3                   	ret    
  802a86:	66 90                	xchg   %ax,%ax
  802a88:	66 90                	xchg   %ax,%ax
  802a8a:	66 90                	xchg   %ax,%ax
  802a8c:	66 90                	xchg   %ax,%ax
  802a8e:	66 90                	xchg   %ax,%ax

00802a90 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a90:	55                   	push   %ebp
  802a91:	89 e5                	mov    %esp,%ebp
  802a93:	56                   	push   %esi
  802a94:	53                   	push   %ebx
  802a95:	83 ec 10             	sub    $0x10,%esp
  802a98:	8b 75 08             	mov    0x8(%ebp),%esi
  802a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802aa1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802aa3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802aa8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802aab:	89 04 24             	mov    %eax,(%esp)
  802aae:	e8 18 e5 ff ff       	call   800fcb <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802ab3:	85 c0                	test   %eax,%eax
  802ab5:	75 26                	jne    802add <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802ab7:	85 f6                	test   %esi,%esi
  802ab9:	74 0a                	je     802ac5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802abb:	a1 08 50 80 00       	mov    0x805008,%eax
  802ac0:	8b 40 74             	mov    0x74(%eax),%eax
  802ac3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802ac5:	85 db                	test   %ebx,%ebx
  802ac7:	74 0a                	je     802ad3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802ac9:	a1 08 50 80 00       	mov    0x805008,%eax
  802ace:	8b 40 78             	mov    0x78(%eax),%eax
  802ad1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802ad3:	a1 08 50 80 00       	mov    0x805008,%eax
  802ad8:	8b 40 70             	mov    0x70(%eax),%eax
  802adb:	eb 14                	jmp    802af1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  802add:	85 f6                	test   %esi,%esi
  802adf:	74 06                	je     802ae7 <ipc_recv+0x57>
			*from_env_store = 0;
  802ae1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802ae7:	85 db                	test   %ebx,%ebx
  802ae9:	74 06                	je     802af1 <ipc_recv+0x61>
			*perm_store = 0;
  802aeb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802af1:	83 c4 10             	add    $0x10,%esp
  802af4:	5b                   	pop    %ebx
  802af5:	5e                   	pop    %esi
  802af6:	5d                   	pop    %ebp
  802af7:	c3                   	ret    

00802af8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802af8:	55                   	push   %ebp
  802af9:	89 e5                	mov    %esp,%ebp
  802afb:	57                   	push   %edi
  802afc:	56                   	push   %esi
  802afd:	53                   	push   %ebx
  802afe:	83 ec 1c             	sub    $0x1c,%esp
  802b01:	8b 7d 08             	mov    0x8(%ebp),%edi
  802b04:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b07:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  802b0a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  802b0c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802b11:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802b14:	8b 45 14             	mov    0x14(%ebp),%eax
  802b17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b1f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b23:	89 3c 24             	mov    %edi,(%esp)
  802b26:	e8 7d e4 ff ff       	call   800fa8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	74 28                	je     802b57 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802b2f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b32:	74 1c                	je     802b50 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802b34:	c7 44 24 08 c8 34 80 	movl   $0x8034c8,0x8(%esp)
  802b3b:	00 
  802b3c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802b43:	00 
  802b44:	c7 04 24 ec 34 80 00 	movl   $0x8034ec,(%esp)
  802b4b:	e8 69 d6 ff ff       	call   8001b9 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802b50:	e8 21 e2 ff ff       	call   800d76 <sys_yield>
	}
  802b55:	eb bd                	jmp    802b14 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802b57:	83 c4 1c             	add    $0x1c,%esp
  802b5a:	5b                   	pop    %ebx
  802b5b:	5e                   	pop    %esi
  802b5c:	5f                   	pop    %edi
  802b5d:	5d                   	pop    %ebp
  802b5e:	c3                   	ret    

00802b5f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b5f:	55                   	push   %ebp
  802b60:	89 e5                	mov    %esp,%ebp
  802b62:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802b65:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802b6a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802b6d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802b73:	8b 52 50             	mov    0x50(%edx),%edx
  802b76:	39 ca                	cmp    %ecx,%edx
  802b78:	75 0d                	jne    802b87 <ipc_find_env+0x28>
			return envs[i].env_id;
  802b7a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802b7d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802b82:	8b 40 40             	mov    0x40(%eax),%eax
  802b85:	eb 0e                	jmp    802b95 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802b87:	83 c0 01             	add    $0x1,%eax
  802b8a:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b8f:	75 d9                	jne    802b6a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802b91:	66 b8 00 00          	mov    $0x0,%ax
}
  802b95:	5d                   	pop    %ebp
  802b96:	c3                   	ret    

00802b97 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b97:	55                   	push   %ebp
  802b98:	89 e5                	mov    %esp,%ebp
  802b9a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b9d:	89 d0                	mov    %edx,%eax
  802b9f:	c1 e8 16             	shr    $0x16,%eax
  802ba2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ba9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802bae:	f6 c1 01             	test   $0x1,%cl
  802bb1:	74 1d                	je     802bd0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802bb3:	c1 ea 0c             	shr    $0xc,%edx
  802bb6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802bbd:	f6 c2 01             	test   $0x1,%dl
  802bc0:	74 0e                	je     802bd0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802bc2:	c1 ea 0c             	shr    $0xc,%edx
  802bc5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802bcc:	ef 
  802bcd:	0f b7 c0             	movzwl %ax,%eax
}
  802bd0:	5d                   	pop    %ebp
  802bd1:	c3                   	ret    
  802bd2:	66 90                	xchg   %ax,%ax
  802bd4:	66 90                	xchg   %ax,%ax
  802bd6:	66 90                	xchg   %ax,%ax
  802bd8:	66 90                	xchg   %ax,%ax
  802bda:	66 90                	xchg   %ax,%ax
  802bdc:	66 90                	xchg   %ax,%ax
  802bde:	66 90                	xchg   %ax,%ax

00802be0 <__udivdi3>:
  802be0:	55                   	push   %ebp
  802be1:	57                   	push   %edi
  802be2:	56                   	push   %esi
  802be3:	83 ec 0c             	sub    $0xc,%esp
  802be6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802bea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802bee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802bf2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802bfc:	89 ea                	mov    %ebp,%edx
  802bfe:	89 0c 24             	mov    %ecx,(%esp)
  802c01:	75 2d                	jne    802c30 <__udivdi3+0x50>
  802c03:	39 e9                	cmp    %ebp,%ecx
  802c05:	77 61                	ja     802c68 <__udivdi3+0x88>
  802c07:	85 c9                	test   %ecx,%ecx
  802c09:	89 ce                	mov    %ecx,%esi
  802c0b:	75 0b                	jne    802c18 <__udivdi3+0x38>
  802c0d:	b8 01 00 00 00       	mov    $0x1,%eax
  802c12:	31 d2                	xor    %edx,%edx
  802c14:	f7 f1                	div    %ecx
  802c16:	89 c6                	mov    %eax,%esi
  802c18:	31 d2                	xor    %edx,%edx
  802c1a:	89 e8                	mov    %ebp,%eax
  802c1c:	f7 f6                	div    %esi
  802c1e:	89 c5                	mov    %eax,%ebp
  802c20:	89 f8                	mov    %edi,%eax
  802c22:	f7 f6                	div    %esi
  802c24:	89 ea                	mov    %ebp,%edx
  802c26:	83 c4 0c             	add    $0xc,%esp
  802c29:	5e                   	pop    %esi
  802c2a:	5f                   	pop    %edi
  802c2b:	5d                   	pop    %ebp
  802c2c:	c3                   	ret    
  802c2d:	8d 76 00             	lea    0x0(%esi),%esi
  802c30:	39 e8                	cmp    %ebp,%eax
  802c32:	77 24                	ja     802c58 <__udivdi3+0x78>
  802c34:	0f bd e8             	bsr    %eax,%ebp
  802c37:	83 f5 1f             	xor    $0x1f,%ebp
  802c3a:	75 3c                	jne    802c78 <__udivdi3+0x98>
  802c3c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c40:	39 34 24             	cmp    %esi,(%esp)
  802c43:	0f 86 9f 00 00 00    	jbe    802ce8 <__udivdi3+0x108>
  802c49:	39 d0                	cmp    %edx,%eax
  802c4b:	0f 82 97 00 00 00    	jb     802ce8 <__udivdi3+0x108>
  802c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c58:	31 d2                	xor    %edx,%edx
  802c5a:	31 c0                	xor    %eax,%eax
  802c5c:	83 c4 0c             	add    $0xc,%esp
  802c5f:	5e                   	pop    %esi
  802c60:	5f                   	pop    %edi
  802c61:	5d                   	pop    %ebp
  802c62:	c3                   	ret    
  802c63:	90                   	nop
  802c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c68:	89 f8                	mov    %edi,%eax
  802c6a:	f7 f1                	div    %ecx
  802c6c:	31 d2                	xor    %edx,%edx
  802c6e:	83 c4 0c             	add    $0xc,%esp
  802c71:	5e                   	pop    %esi
  802c72:	5f                   	pop    %edi
  802c73:	5d                   	pop    %ebp
  802c74:	c3                   	ret    
  802c75:	8d 76 00             	lea    0x0(%esi),%esi
  802c78:	89 e9                	mov    %ebp,%ecx
  802c7a:	8b 3c 24             	mov    (%esp),%edi
  802c7d:	d3 e0                	shl    %cl,%eax
  802c7f:	89 c6                	mov    %eax,%esi
  802c81:	b8 20 00 00 00       	mov    $0x20,%eax
  802c86:	29 e8                	sub    %ebp,%eax
  802c88:	89 c1                	mov    %eax,%ecx
  802c8a:	d3 ef                	shr    %cl,%edi
  802c8c:	89 e9                	mov    %ebp,%ecx
  802c8e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c92:	8b 3c 24             	mov    (%esp),%edi
  802c95:	09 74 24 08          	or     %esi,0x8(%esp)
  802c99:	89 d6                	mov    %edx,%esi
  802c9b:	d3 e7                	shl    %cl,%edi
  802c9d:	89 c1                	mov    %eax,%ecx
  802c9f:	89 3c 24             	mov    %edi,(%esp)
  802ca2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ca6:	d3 ee                	shr    %cl,%esi
  802ca8:	89 e9                	mov    %ebp,%ecx
  802caa:	d3 e2                	shl    %cl,%edx
  802cac:	89 c1                	mov    %eax,%ecx
  802cae:	d3 ef                	shr    %cl,%edi
  802cb0:	09 d7                	or     %edx,%edi
  802cb2:	89 f2                	mov    %esi,%edx
  802cb4:	89 f8                	mov    %edi,%eax
  802cb6:	f7 74 24 08          	divl   0x8(%esp)
  802cba:	89 d6                	mov    %edx,%esi
  802cbc:	89 c7                	mov    %eax,%edi
  802cbe:	f7 24 24             	mull   (%esp)
  802cc1:	39 d6                	cmp    %edx,%esi
  802cc3:	89 14 24             	mov    %edx,(%esp)
  802cc6:	72 30                	jb     802cf8 <__udivdi3+0x118>
  802cc8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ccc:	89 e9                	mov    %ebp,%ecx
  802cce:	d3 e2                	shl    %cl,%edx
  802cd0:	39 c2                	cmp    %eax,%edx
  802cd2:	73 05                	jae    802cd9 <__udivdi3+0xf9>
  802cd4:	3b 34 24             	cmp    (%esp),%esi
  802cd7:	74 1f                	je     802cf8 <__udivdi3+0x118>
  802cd9:	89 f8                	mov    %edi,%eax
  802cdb:	31 d2                	xor    %edx,%edx
  802cdd:	e9 7a ff ff ff       	jmp    802c5c <__udivdi3+0x7c>
  802ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ce8:	31 d2                	xor    %edx,%edx
  802cea:	b8 01 00 00 00       	mov    $0x1,%eax
  802cef:	e9 68 ff ff ff       	jmp    802c5c <__udivdi3+0x7c>
  802cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cf8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802cfb:	31 d2                	xor    %edx,%edx
  802cfd:	83 c4 0c             	add    $0xc,%esp
  802d00:	5e                   	pop    %esi
  802d01:	5f                   	pop    %edi
  802d02:	5d                   	pop    %ebp
  802d03:	c3                   	ret    
  802d04:	66 90                	xchg   %ax,%ax
  802d06:	66 90                	xchg   %ax,%ax
  802d08:	66 90                	xchg   %ax,%ax
  802d0a:	66 90                	xchg   %ax,%ax
  802d0c:	66 90                	xchg   %ax,%ax
  802d0e:	66 90                	xchg   %ax,%ax

00802d10 <__umoddi3>:
  802d10:	55                   	push   %ebp
  802d11:	57                   	push   %edi
  802d12:	56                   	push   %esi
  802d13:	83 ec 14             	sub    $0x14,%esp
  802d16:	8b 44 24 28          	mov    0x28(%esp),%eax
  802d1a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802d1e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802d22:	89 c7                	mov    %eax,%edi
  802d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d28:	8b 44 24 30          	mov    0x30(%esp),%eax
  802d2c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802d30:	89 34 24             	mov    %esi,(%esp)
  802d33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d37:	85 c0                	test   %eax,%eax
  802d39:	89 c2                	mov    %eax,%edx
  802d3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d3f:	75 17                	jne    802d58 <__umoddi3+0x48>
  802d41:	39 fe                	cmp    %edi,%esi
  802d43:	76 4b                	jbe    802d90 <__umoddi3+0x80>
  802d45:	89 c8                	mov    %ecx,%eax
  802d47:	89 fa                	mov    %edi,%edx
  802d49:	f7 f6                	div    %esi
  802d4b:	89 d0                	mov    %edx,%eax
  802d4d:	31 d2                	xor    %edx,%edx
  802d4f:	83 c4 14             	add    $0x14,%esp
  802d52:	5e                   	pop    %esi
  802d53:	5f                   	pop    %edi
  802d54:	5d                   	pop    %ebp
  802d55:	c3                   	ret    
  802d56:	66 90                	xchg   %ax,%ax
  802d58:	39 f8                	cmp    %edi,%eax
  802d5a:	77 54                	ja     802db0 <__umoddi3+0xa0>
  802d5c:	0f bd e8             	bsr    %eax,%ebp
  802d5f:	83 f5 1f             	xor    $0x1f,%ebp
  802d62:	75 5c                	jne    802dc0 <__umoddi3+0xb0>
  802d64:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d68:	39 3c 24             	cmp    %edi,(%esp)
  802d6b:	0f 87 e7 00 00 00    	ja     802e58 <__umoddi3+0x148>
  802d71:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d75:	29 f1                	sub    %esi,%ecx
  802d77:	19 c7                	sbb    %eax,%edi
  802d79:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d81:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d85:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d89:	83 c4 14             	add    $0x14,%esp
  802d8c:	5e                   	pop    %esi
  802d8d:	5f                   	pop    %edi
  802d8e:	5d                   	pop    %ebp
  802d8f:	c3                   	ret    
  802d90:	85 f6                	test   %esi,%esi
  802d92:	89 f5                	mov    %esi,%ebp
  802d94:	75 0b                	jne    802da1 <__umoddi3+0x91>
  802d96:	b8 01 00 00 00       	mov    $0x1,%eax
  802d9b:	31 d2                	xor    %edx,%edx
  802d9d:	f7 f6                	div    %esi
  802d9f:	89 c5                	mov    %eax,%ebp
  802da1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802da5:	31 d2                	xor    %edx,%edx
  802da7:	f7 f5                	div    %ebp
  802da9:	89 c8                	mov    %ecx,%eax
  802dab:	f7 f5                	div    %ebp
  802dad:	eb 9c                	jmp    802d4b <__umoddi3+0x3b>
  802daf:	90                   	nop
  802db0:	89 c8                	mov    %ecx,%eax
  802db2:	89 fa                	mov    %edi,%edx
  802db4:	83 c4 14             	add    $0x14,%esp
  802db7:	5e                   	pop    %esi
  802db8:	5f                   	pop    %edi
  802db9:	5d                   	pop    %ebp
  802dba:	c3                   	ret    
  802dbb:	90                   	nop
  802dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dc0:	8b 04 24             	mov    (%esp),%eax
  802dc3:	be 20 00 00 00       	mov    $0x20,%esi
  802dc8:	89 e9                	mov    %ebp,%ecx
  802dca:	29 ee                	sub    %ebp,%esi
  802dcc:	d3 e2                	shl    %cl,%edx
  802dce:	89 f1                	mov    %esi,%ecx
  802dd0:	d3 e8                	shr    %cl,%eax
  802dd2:	89 e9                	mov    %ebp,%ecx
  802dd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dd8:	8b 04 24             	mov    (%esp),%eax
  802ddb:	09 54 24 04          	or     %edx,0x4(%esp)
  802ddf:	89 fa                	mov    %edi,%edx
  802de1:	d3 e0                	shl    %cl,%eax
  802de3:	89 f1                	mov    %esi,%ecx
  802de5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802de9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802ded:	d3 ea                	shr    %cl,%edx
  802def:	89 e9                	mov    %ebp,%ecx
  802df1:	d3 e7                	shl    %cl,%edi
  802df3:	89 f1                	mov    %esi,%ecx
  802df5:	d3 e8                	shr    %cl,%eax
  802df7:	89 e9                	mov    %ebp,%ecx
  802df9:	09 f8                	or     %edi,%eax
  802dfb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802dff:	f7 74 24 04          	divl   0x4(%esp)
  802e03:	d3 e7                	shl    %cl,%edi
  802e05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e09:	89 d7                	mov    %edx,%edi
  802e0b:	f7 64 24 08          	mull   0x8(%esp)
  802e0f:	39 d7                	cmp    %edx,%edi
  802e11:	89 c1                	mov    %eax,%ecx
  802e13:	89 14 24             	mov    %edx,(%esp)
  802e16:	72 2c                	jb     802e44 <__umoddi3+0x134>
  802e18:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802e1c:	72 22                	jb     802e40 <__umoddi3+0x130>
  802e1e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802e22:	29 c8                	sub    %ecx,%eax
  802e24:	19 d7                	sbb    %edx,%edi
  802e26:	89 e9                	mov    %ebp,%ecx
  802e28:	89 fa                	mov    %edi,%edx
  802e2a:	d3 e8                	shr    %cl,%eax
  802e2c:	89 f1                	mov    %esi,%ecx
  802e2e:	d3 e2                	shl    %cl,%edx
  802e30:	89 e9                	mov    %ebp,%ecx
  802e32:	d3 ef                	shr    %cl,%edi
  802e34:	09 d0                	or     %edx,%eax
  802e36:	89 fa                	mov    %edi,%edx
  802e38:	83 c4 14             	add    $0x14,%esp
  802e3b:	5e                   	pop    %esi
  802e3c:	5f                   	pop    %edi
  802e3d:	5d                   	pop    %ebp
  802e3e:	c3                   	ret    
  802e3f:	90                   	nop
  802e40:	39 d7                	cmp    %edx,%edi
  802e42:	75 da                	jne    802e1e <__umoddi3+0x10e>
  802e44:	8b 14 24             	mov    (%esp),%edx
  802e47:	89 c1                	mov    %eax,%ecx
  802e49:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802e4d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802e51:	eb cb                	jmp    802e1e <__umoddi3+0x10e>
  802e53:	90                   	nop
  802e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e58:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802e5c:	0f 82 0f ff ff ff    	jb     802d71 <__umoddi3+0x61>
  802e62:	e9 1a ff ff ff       	jmp    802d81 <__umoddi3+0x71>
