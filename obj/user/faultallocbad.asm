
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 af 00 00 00       	call   8000e0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 24             	sub    $0x24,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800043:	c7 04 24 40 28 80 00 	movl   $0x802840,(%esp)
  80004a:	e8 eb 01 00 00       	call   80023a <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800056:	00 
  800057:	89 d8                	mov    %ebx,%eax
  800059:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800069:	e8 b7 0c 00 00       	call   800d25 <sys_page_alloc>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 24                	jns    800096 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800072:	89 44 24 10          	mov    %eax,0x10(%esp)
  800076:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007a:	c7 44 24 08 60 28 80 	movl   $0x802860,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800089:	00 
  80008a:	c7 04 24 4a 28 80 00 	movl   $0x80284a,(%esp)
  800091:	e8 ab 00 00 00       	call   800141 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009a:	c7 44 24 08 8c 28 80 	movl   $0x80288c,0x8(%esp)
  8000a1:	00 
  8000a2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000a9:	00 
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	e8 a3 07 00 00       	call   800855 <snprintf>
}
  8000b2:	83 c4 24             	add    $0x24,%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <umain>:

void
umain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  8000be:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000c5:	e8 64 0f 00 00       	call   80102e <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000ca:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000d1:	00 
  8000d2:	c7 04 24 ef be ad de 	movl   $0xdeadbeef,(%esp)
  8000d9:	e8 28 0b 00 00       	call   800c06 <sys_cputs>
}
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 10             	sub    $0x10,%esp
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ee:	e8 f4 0b 00 00       	call   800ce7 <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800100:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800105:	85 db                	test   %ebx,%ebx
  800107:	7e 07                	jle    800110 <libmain+0x30>
		binaryname = argv[0];
  800109:	8b 06                	mov    (%esi),%eax
  80010b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800110:	89 74 24 04          	mov    %esi,0x4(%esp)
  800114:	89 1c 24             	mov    %ebx,(%esp)
  800117:	e8 9c ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  80011c:	e8 07 00 00 00       	call   800128 <exit>
}
  800121:	83 c4 10             	add    $0x10,%esp
  800124:	5b                   	pop    %ebx
  800125:	5e                   	pop    %esi
  800126:	5d                   	pop    %ebp
  800127:	c3                   	ret    

00800128 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80012e:	e8 97 11 00 00       	call   8012ca <close_all>
	sys_env_destroy(0);
  800133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80013a:	e8 04 0b 00 00       	call   800c43 <sys_env_destroy>
}
  80013f:	c9                   	leave  
  800140:	c3                   	ret    

00800141 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	56                   	push   %esi
  800145:	53                   	push   %ebx
  800146:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800149:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80014c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800152:	e8 90 0b 00 00       	call   800ce7 <sys_getenvid>
  800157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80015a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80015e:	8b 55 08             	mov    0x8(%ebp),%edx
  800161:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800165:	89 74 24 08          	mov    %esi,0x8(%esp)
  800169:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016d:	c7 04 24 b8 28 80 00 	movl   $0x8028b8,(%esp)
  800174:	e8 c1 00 00 00       	call   80023a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800179:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	89 04 24             	mov    %eax,(%esp)
  800183:	e8 51 00 00 00       	call   8001d9 <vcprintf>
	cprintf("\n");
  800188:	c7 04 24 47 2d 80 00 	movl   $0x802d47,(%esp)
  80018f:	e8 a6 00 00 00       	call   80023a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800194:	cc                   	int3   
  800195:	eb fd                	jmp    800194 <_panic+0x53>

00800197 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	83 ec 14             	sub    $0x14,%esp
  80019e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a1:	8b 13                	mov    (%ebx),%edx
  8001a3:	8d 42 01             	lea    0x1(%edx),%eax
  8001a6:	89 03                	mov    %eax,(%ebx)
  8001a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b4:	75 19                	jne    8001cf <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001b6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001bd:	00 
  8001be:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c1:	89 04 24             	mov    %eax,(%esp)
  8001c4:	e8 3d 0a 00 00       	call   800c06 <sys_cputs>
		b->idx = 0;
  8001c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001cf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d3:	83 c4 14             	add    $0x14,%esp
  8001d6:	5b                   	pop    %ebx
  8001d7:	5d                   	pop    %ebp
  8001d8:	c3                   	ret    

008001d9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e9:	00 00 00 
	b.cnt = 0;
  8001ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800200:	89 44 24 08          	mov    %eax,0x8(%esp)
  800204:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020e:	c7 04 24 97 01 80 00 	movl   $0x800197,(%esp)
  800215:	e8 7a 01 00 00       	call   800394 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80021a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800220:	89 44 24 04          	mov    %eax,0x4(%esp)
  800224:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80022a:	89 04 24             	mov    %eax,(%esp)
  80022d:	e8 d4 09 00 00       	call   800c06 <sys_cputs>

	return b.cnt;
}
  800232:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800240:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800243:	89 44 24 04          	mov    %eax,0x4(%esp)
  800247:	8b 45 08             	mov    0x8(%ebp),%eax
  80024a:	89 04 24             	mov    %eax,(%esp)
  80024d:	e8 87 ff ff ff       	call   8001d9 <vcprintf>
	va_end(ap);

	return cnt;
}
  800252:	c9                   	leave  
  800253:	c3                   	ret    
  800254:	66 90                	xchg   %ax,%ax
  800256:	66 90                	xchg   %ax,%ax
  800258:	66 90                	xchg   %ax,%ax
  80025a:	66 90                	xchg   %ax,%ax
  80025c:	66 90                	xchg   %ax,%ax
  80025e:	66 90                	xchg   %ax,%ax

00800260 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	57                   	push   %edi
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	83 ec 3c             	sub    $0x3c,%esp
  800269:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80026c:	89 d7                	mov    %edx,%edi
  80026e:	8b 45 08             	mov    0x8(%ebp),%eax
  800271:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800274:	8b 45 0c             	mov    0xc(%ebp),%eax
  800277:	89 c3                	mov    %eax,%ebx
  800279:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80027c:	8b 45 10             	mov    0x10(%ebp),%eax
  80027f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
  800287:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80028a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80028d:	39 d9                	cmp    %ebx,%ecx
  80028f:	72 05                	jb     800296 <printnum+0x36>
  800291:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800294:	77 69                	ja     8002ff <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800296:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800299:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80029d:	83 ee 01             	sub    $0x1,%esi
  8002a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002ac:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002b0:	89 c3                	mov    %eax,%ebx
  8002b2:	89 d6                	mov    %edx,%esi
  8002b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ba:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002be:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c5:	89 04 24             	mov    %eax,(%esp)
  8002c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	e8 cc 22 00 00       	call   8025a0 <__udivdi3>
  8002d4:	89 d9                	mov    %ebx,%ecx
  8002d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002de:	89 04 24             	mov    %eax,(%esp)
  8002e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002e5:	89 fa                	mov    %edi,%edx
  8002e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ea:	e8 71 ff ff ff       	call   800260 <printnum>
  8002ef:	eb 1b                	jmp    80030c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f8:	89 04 24             	mov    %eax,(%esp)
  8002fb:	ff d3                	call   *%ebx
  8002fd:	eb 03                	jmp    800302 <printnum+0xa2>
  8002ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800302:	83 ee 01             	sub    $0x1,%esi
  800305:	85 f6                	test   %esi,%esi
  800307:	7f e8                	jg     8002f1 <printnum+0x91>
  800309:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80030c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800310:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800314:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800317:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80031a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032f:	e8 9c 23 00 00       	call   8026d0 <__umoddi3>
  800334:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800338:	0f be 80 db 28 80 00 	movsbl 0x8028db(%eax),%eax
  80033f:	89 04 24             	mov    %eax,(%esp)
  800342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800345:	ff d0                	call   *%eax
}
  800347:	83 c4 3c             	add    $0x3c,%esp
  80034a:	5b                   	pop    %ebx
  80034b:	5e                   	pop    %esi
  80034c:	5f                   	pop    %edi
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800355:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800359:	8b 10                	mov    (%eax),%edx
  80035b:	3b 50 04             	cmp    0x4(%eax),%edx
  80035e:	73 0a                	jae    80036a <sprintputch+0x1b>
		*b->buf++ = ch;
  800360:	8d 4a 01             	lea    0x1(%edx),%ecx
  800363:	89 08                	mov    %ecx,(%eax)
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	88 02                	mov    %al,(%edx)
}
  80036a:	5d                   	pop    %ebp
  80036b:	c3                   	ret    

0080036c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800372:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800375:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800379:	8b 45 10             	mov    0x10(%ebp),%eax
  80037c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800380:	8b 45 0c             	mov    0xc(%ebp),%eax
  800383:	89 44 24 04          	mov    %eax,0x4(%esp)
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	89 04 24             	mov    %eax,(%esp)
  80038d:	e8 02 00 00 00       	call   800394 <vprintfmt>
	va_end(ap);
}
  800392:	c9                   	leave  
  800393:	c3                   	ret    

00800394 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	57                   	push   %edi
  800398:	56                   	push   %esi
  800399:	53                   	push   %ebx
  80039a:	83 ec 3c             	sub    $0x3c,%esp
  80039d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003a0:	eb 17                	jmp    8003b9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8003a2:	85 c0                	test   %eax,%eax
  8003a4:	0f 84 4b 04 00 00    	je     8007f5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8003aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003b1:	89 04 24             	mov    %eax,(%esp)
  8003b4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8003b7:	89 fb                	mov    %edi,%ebx
  8003b9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8003bc:	0f b6 03             	movzbl (%ebx),%eax
  8003bf:	83 f8 25             	cmp    $0x25,%eax
  8003c2:	75 de                	jne    8003a2 <vprintfmt+0xe>
  8003c4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8003c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003cf:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8003d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003e0:	eb 18                	jmp    8003fa <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003e4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8003e8:	eb 10                	jmp    8003fa <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ea:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003ec:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8003f0:	eb 08                	jmp    8003fa <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003f2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8003f5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	8d 5f 01             	lea    0x1(%edi),%ebx
  8003fd:	0f b6 17             	movzbl (%edi),%edx
  800400:	0f b6 c2             	movzbl %dl,%eax
  800403:	83 ea 23             	sub    $0x23,%edx
  800406:	80 fa 55             	cmp    $0x55,%dl
  800409:	0f 87 c2 03 00 00    	ja     8007d1 <vprintfmt+0x43d>
  80040f:	0f b6 d2             	movzbl %dl,%edx
  800412:	ff 24 95 20 2a 80 00 	jmp    *0x802a20(,%edx,4)
  800419:	89 df                	mov    %ebx,%edi
  80041b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800420:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800423:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800427:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80042a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80042d:	83 fa 09             	cmp    $0x9,%edx
  800430:	77 33                	ja     800465 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800432:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800435:	eb e9                	jmp    800420 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	8b 30                	mov    (%eax),%esi
  80043c:	8d 40 04             	lea    0x4(%eax),%eax
  80043f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800442:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800444:	eb 1f                	jmp    800465 <vprintfmt+0xd1>
  800446:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800449:	85 ff                	test   %edi,%edi
  80044b:	b8 00 00 00 00       	mov    $0x0,%eax
  800450:	0f 49 c7             	cmovns %edi,%eax
  800453:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800456:	89 df                	mov    %ebx,%edi
  800458:	eb a0                	jmp    8003fa <vprintfmt+0x66>
  80045a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80045c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800463:	eb 95                	jmp    8003fa <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800465:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800469:	79 8f                	jns    8003fa <vprintfmt+0x66>
  80046b:	eb 85                	jmp    8003f2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80046d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800470:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800472:	eb 86                	jmp    8003fa <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8d 70 04             	lea    0x4(%eax),%esi
  80047a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800481:	8b 45 14             	mov    0x14(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	89 04 24             	mov    %eax,(%esp)
  800489:	ff 55 08             	call   *0x8(%ebp)
  80048c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80048f:	e9 25 ff ff ff       	jmp    8003b9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800494:	8b 45 14             	mov    0x14(%ebp),%eax
  800497:	8d 70 04             	lea    0x4(%eax),%esi
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	99                   	cltd   
  80049d:	31 d0                	xor    %edx,%eax
  80049f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a1:	83 f8 15             	cmp    $0x15,%eax
  8004a4:	7f 0b                	jg     8004b1 <vprintfmt+0x11d>
  8004a6:	8b 14 85 80 2b 80 00 	mov    0x802b80(,%eax,4),%edx
  8004ad:	85 d2                	test   %edx,%edx
  8004af:	75 26                	jne    8004d7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8004b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004b5:	c7 44 24 08 f3 28 80 	movl   $0x8028f3,0x8(%esp)
  8004bc:	00 
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	89 04 24             	mov    %eax,(%esp)
  8004ca:	e8 9d fe ff ff       	call   80036c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004cf:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8004d2:	e9 e2 fe ff ff       	jmp    8003b9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004d7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004db:	c7 44 24 08 16 2d 80 	movl   $0x802d16,0x8(%esp)
  8004e2:	00 
  8004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	89 04 24             	mov    %eax,(%esp)
  8004f0:	e8 77 fe ff ff       	call   80036c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004f5:	89 75 14             	mov    %esi,0x14(%ebp)
  8004f8:	e9 bc fe ff ff       	jmp    8003b9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800500:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800503:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800506:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80050a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80050c:	85 ff                	test   %edi,%edi
  80050e:	b8 ec 28 80 00       	mov    $0x8028ec,%eax
  800513:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800516:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80051a:	0f 84 94 00 00 00    	je     8005b4 <vprintfmt+0x220>
  800520:	85 c9                	test   %ecx,%ecx
  800522:	0f 8e 94 00 00 00    	jle    8005bc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800528:	89 74 24 04          	mov    %esi,0x4(%esp)
  80052c:	89 3c 24             	mov    %edi,(%esp)
  80052f:	e8 64 03 00 00       	call   800898 <strnlen>
  800534:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800537:	29 c1                	sub    %eax,%ecx
  800539:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80053c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800540:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800543:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800546:	8b 75 08             	mov    0x8(%ebp),%esi
  800549:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80054c:	89 cb                	mov    %ecx,%ebx
  80054e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800550:	eb 0f                	jmp    800561 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800552:	8b 45 0c             	mov    0xc(%ebp),%eax
  800555:	89 44 24 04          	mov    %eax,0x4(%esp)
  800559:	89 3c 24             	mov    %edi,(%esp)
  80055c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80055e:	83 eb 01             	sub    $0x1,%ebx
  800561:	85 db                	test   %ebx,%ebx
  800563:	7f ed                	jg     800552 <vprintfmt+0x1be>
  800565:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800568:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80056b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80056e:	85 c9                	test   %ecx,%ecx
  800570:	b8 00 00 00 00       	mov    $0x0,%eax
  800575:	0f 49 c1             	cmovns %ecx,%eax
  800578:	29 c1                	sub    %eax,%ecx
  80057a:	89 cb                	mov    %ecx,%ebx
  80057c:	eb 44                	jmp    8005c2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80057e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800582:	74 1e                	je     8005a2 <vprintfmt+0x20e>
  800584:	0f be d2             	movsbl %dl,%edx
  800587:	83 ea 20             	sub    $0x20,%edx
  80058a:	83 fa 5e             	cmp    $0x5e,%edx
  80058d:	76 13                	jbe    8005a2 <vprintfmt+0x20e>
					putch('?', putdat);
  80058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800592:	89 44 24 04          	mov    %eax,0x4(%esp)
  800596:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80059d:	ff 55 08             	call   *0x8(%ebp)
  8005a0:	eb 0d                	jmp    8005af <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8005a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005a5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005a9:	89 04 24             	mov    %eax,(%esp)
  8005ac:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005af:	83 eb 01             	sub    $0x1,%ebx
  8005b2:	eb 0e                	jmp    8005c2 <vprintfmt+0x22e>
  8005b4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005b7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005ba:	eb 06                	jmp    8005c2 <vprintfmt+0x22e>
  8005bc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005bf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005c2:	83 c7 01             	add    $0x1,%edi
  8005c5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005c9:	0f be c2             	movsbl %dl,%eax
  8005cc:	85 c0                	test   %eax,%eax
  8005ce:	74 27                	je     8005f7 <vprintfmt+0x263>
  8005d0:	85 f6                	test   %esi,%esi
  8005d2:	78 aa                	js     80057e <vprintfmt+0x1ea>
  8005d4:	83 ee 01             	sub    $0x1,%esi
  8005d7:	79 a5                	jns    80057e <vprintfmt+0x1ea>
  8005d9:	89 d8                	mov    %ebx,%eax
  8005db:	8b 75 08             	mov    0x8(%ebp),%esi
  8005de:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005e1:	89 c3                	mov    %eax,%ebx
  8005e3:	eb 18                	jmp    8005fd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005e9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005f0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005f2:	83 eb 01             	sub    $0x1,%ebx
  8005f5:	eb 06                	jmp    8005fd <vprintfmt+0x269>
  8005f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005fd:	85 db                	test   %ebx,%ebx
  8005ff:	7f e4                	jg     8005e5 <vprintfmt+0x251>
  800601:	89 75 08             	mov    %esi,0x8(%ebp)
  800604:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800607:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80060a:	e9 aa fd ff ff       	jmp    8003b9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80060f:	83 f9 01             	cmp    $0x1,%ecx
  800612:	7e 10                	jle    800624 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8b 30                	mov    (%eax),%esi
  800619:	8b 78 04             	mov    0x4(%eax),%edi
  80061c:	8d 40 08             	lea    0x8(%eax),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
  800622:	eb 26                	jmp    80064a <vprintfmt+0x2b6>
	else if (lflag)
  800624:	85 c9                	test   %ecx,%ecx
  800626:	74 12                	je     80063a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 30                	mov    (%eax),%esi
  80062d:	89 f7                	mov    %esi,%edi
  80062f:	c1 ff 1f             	sar    $0x1f,%edi
  800632:	8d 40 04             	lea    0x4(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
  800638:	eb 10                	jmp    80064a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 30                	mov    (%eax),%esi
  80063f:	89 f7                	mov    %esi,%edi
  800641:	c1 ff 1f             	sar    $0x1f,%edi
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80064a:	89 f0                	mov    %esi,%eax
  80064c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80064e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800653:	85 ff                	test   %edi,%edi
  800655:	0f 89 3a 01 00 00    	jns    800795 <vprintfmt+0x401>
				putch('-', putdat);
  80065b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800662:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800669:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80066c:	89 f0                	mov    %esi,%eax
  80066e:	89 fa                	mov    %edi,%edx
  800670:	f7 d8                	neg    %eax
  800672:	83 d2 00             	adc    $0x0,%edx
  800675:	f7 da                	neg    %edx
			}
			base = 10;
  800677:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80067c:	e9 14 01 00 00       	jmp    800795 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800681:	83 f9 01             	cmp    $0x1,%ecx
  800684:	7e 13                	jle    800699 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 50 04             	mov    0x4(%eax),%edx
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	8b 75 14             	mov    0x14(%ebp),%esi
  800691:	8d 4e 08             	lea    0x8(%esi),%ecx
  800694:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800697:	eb 2c                	jmp    8006c5 <vprintfmt+0x331>
	else if (lflag)
  800699:	85 c9                	test   %ecx,%ecx
  80069b:	74 15                	je     8006b2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a7:	8b 75 14             	mov    0x14(%ebp),%esi
  8006aa:	8d 76 04             	lea    0x4(%esi),%esi
  8006ad:	89 75 14             	mov    %esi,0x14(%ebp)
  8006b0:	eb 13                	jmp    8006c5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	8b 75 14             	mov    0x14(%ebp),%esi
  8006bf:	8d 76 04             	lea    0x4(%esi),%esi
  8006c2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8006c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006ca:	e9 c6 00 00 00       	jmp    800795 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006cf:	83 f9 01             	cmp    $0x1,%ecx
  8006d2:	7e 13                	jle    8006e7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 50 04             	mov    0x4(%eax),%edx
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	8b 75 14             	mov    0x14(%ebp),%esi
  8006df:	8d 4e 08             	lea    0x8(%esi),%ecx
  8006e2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006e5:	eb 24                	jmp    80070b <vprintfmt+0x377>
	else if (lflag)
  8006e7:	85 c9                	test   %ecx,%ecx
  8006e9:	74 11                	je     8006fc <vprintfmt+0x368>
		return va_arg(*ap, long);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	99                   	cltd   
  8006f1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8006f4:	8d 71 04             	lea    0x4(%ecx),%esi
  8006f7:	89 75 14             	mov    %esi,0x14(%ebp)
  8006fa:	eb 0f                	jmp    80070b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
  800702:	8b 75 14             	mov    0x14(%ebp),%esi
  800705:	8d 76 04             	lea    0x4(%esi),%esi
  800708:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80070b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800710:	e9 80 00 00 00       	jmp    800795 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800715:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800726:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800730:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800737:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80073a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80073e:	8b 06                	mov    (%esi),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800745:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80074a:	eb 49                	jmp    800795 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80074c:	83 f9 01             	cmp    $0x1,%ecx
  80074f:	7e 13                	jle    800764 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	8b 75 14             	mov    0x14(%ebp),%esi
  80075c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80075f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800762:	eb 2c                	jmp    800790 <vprintfmt+0x3fc>
	else if (lflag)
  800764:	85 c9                	test   %ecx,%ecx
  800766:	74 15                	je     80077d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	ba 00 00 00 00       	mov    $0x0,%edx
  800772:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800775:	8d 71 04             	lea    0x4(%ecx),%esi
  800778:	89 75 14             	mov    %esi,0x14(%ebp)
  80077b:	eb 13                	jmp    800790 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	ba 00 00 00 00       	mov    $0x0,%edx
  800787:	8b 75 14             	mov    0x14(%ebp),%esi
  80078a:	8d 76 04             	lea    0x4(%esi),%esi
  80078d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800790:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800795:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800799:	89 74 24 10          	mov    %esi,0x10(%esp)
  80079d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8007a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007a4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007a8:	89 04 24             	mov    %eax,(%esp)
  8007ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	e8 a6 fa ff ff       	call   800260 <printnum>
			break;
  8007ba:	e9 fa fb ff ff       	jmp    8003b9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007c6:	89 04 24             	mov    %eax,(%esp)
  8007c9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007cc:	e9 e8 fb ff ff       	jmp    8003b9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007df:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e2:	89 fb                	mov    %edi,%ebx
  8007e4:	eb 03                	jmp    8007e9 <vprintfmt+0x455>
  8007e6:	83 eb 01             	sub    $0x1,%ebx
  8007e9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007ed:	75 f7                	jne    8007e6 <vprintfmt+0x452>
  8007ef:	90                   	nop
  8007f0:	e9 c4 fb ff ff       	jmp    8003b9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007f5:	83 c4 3c             	add    $0x3c,%esp
  8007f8:	5b                   	pop    %ebx
  8007f9:	5e                   	pop    %esi
  8007fa:	5f                   	pop    %edi
  8007fb:	5d                   	pop    %ebp
  8007fc:	c3                   	ret    

008007fd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	83 ec 28             	sub    $0x28,%esp
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800809:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80080c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800810:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800813:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80081a:	85 c0                	test   %eax,%eax
  80081c:	74 30                	je     80084e <vsnprintf+0x51>
  80081e:	85 d2                	test   %edx,%edx
  800820:	7e 2c                	jle    80084e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800829:	8b 45 10             	mov    0x10(%ebp),%eax
  80082c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800830:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800833:	89 44 24 04          	mov    %eax,0x4(%esp)
  800837:	c7 04 24 4f 03 80 00 	movl   $0x80034f,(%esp)
  80083e:	e8 51 fb ff ff       	call   800394 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800846:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084c:	eb 05                	jmp    800853 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80084e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800853:	c9                   	leave  
  800854:	c3                   	ret    

00800855 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80085b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80085e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800862:	8b 45 10             	mov    0x10(%ebp),%eax
  800865:	89 44 24 08          	mov    %eax,0x8(%esp)
  800869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 04 24             	mov    %eax,(%esp)
  800876:	e8 82 ff ff ff       	call   8007fd <vsnprintf>
	va_end(ap);

	return rc;
}
  80087b:	c9                   	leave  
  80087c:	c3                   	ret    
  80087d:	66 90                	xchg   %ax,%ax
  80087f:	90                   	nop

00800880 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800886:	b8 00 00 00 00       	mov    $0x0,%eax
  80088b:	eb 03                	jmp    800890 <strlen+0x10>
		n++;
  80088d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800890:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800894:	75 f7                	jne    80088d <strlen+0xd>
		n++;
	return n;
}
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a6:	eb 03                	jmp    8008ab <strnlen+0x13>
		n++;
  8008a8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ab:	39 d0                	cmp    %edx,%eax
  8008ad:	74 06                	je     8008b5 <strnlen+0x1d>
  8008af:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008b3:	75 f3                	jne    8008a8 <strnlen+0x10>
		n++;
	return n;
}
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	53                   	push   %ebx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c1:	89 c2                	mov    %eax,%edx
  8008c3:	83 c2 01             	add    $0x1,%edx
  8008c6:	83 c1 01             	add    $0x1,%ecx
  8008c9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008cd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008d0:	84 db                	test   %bl,%bl
  8008d2:	75 ef                	jne    8008c3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008d4:	5b                   	pop    %ebx
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e1:	89 1c 24             	mov    %ebx,(%esp)
  8008e4:	e8 97 ff ff ff       	call   800880 <strlen>
	strcpy(dst + len, src);
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008f0:	01 d8                	add    %ebx,%eax
  8008f2:	89 04 24             	mov    %eax,(%esp)
  8008f5:	e8 bd ff ff ff       	call   8008b7 <strcpy>
	return dst;
}
  8008fa:	89 d8                	mov    %ebx,%eax
  8008fc:	83 c4 08             	add    $0x8,%esp
  8008ff:	5b                   	pop    %ebx
  800900:	5d                   	pop    %ebp
  800901:	c3                   	ret    

00800902 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	56                   	push   %esi
  800906:	53                   	push   %ebx
  800907:	8b 75 08             	mov    0x8(%ebp),%esi
  80090a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80090d:	89 f3                	mov    %esi,%ebx
  80090f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800912:	89 f2                	mov    %esi,%edx
  800914:	eb 0f                	jmp    800925 <strncpy+0x23>
		*dst++ = *src;
  800916:	83 c2 01             	add    $0x1,%edx
  800919:	0f b6 01             	movzbl (%ecx),%eax
  80091c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80091f:	80 39 01             	cmpb   $0x1,(%ecx)
  800922:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800925:	39 da                	cmp    %ebx,%edx
  800927:	75 ed                	jne    800916 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800929:	89 f0                	mov    %esi,%eax
  80092b:	5b                   	pop    %ebx
  80092c:	5e                   	pop    %esi
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	56                   	push   %esi
  800933:	53                   	push   %ebx
  800934:	8b 75 08             	mov    0x8(%ebp),%esi
  800937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80093d:	89 f0                	mov    %esi,%eax
  80093f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800943:	85 c9                	test   %ecx,%ecx
  800945:	75 0b                	jne    800952 <strlcpy+0x23>
  800947:	eb 1d                	jmp    800966 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800949:	83 c0 01             	add    $0x1,%eax
  80094c:	83 c2 01             	add    $0x1,%edx
  80094f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800952:	39 d8                	cmp    %ebx,%eax
  800954:	74 0b                	je     800961 <strlcpy+0x32>
  800956:	0f b6 0a             	movzbl (%edx),%ecx
  800959:	84 c9                	test   %cl,%cl
  80095b:	75 ec                	jne    800949 <strlcpy+0x1a>
  80095d:	89 c2                	mov    %eax,%edx
  80095f:	eb 02                	jmp    800963 <strlcpy+0x34>
  800961:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800963:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800966:	29 f0                	sub    %esi,%eax
}
  800968:	5b                   	pop    %ebx
  800969:	5e                   	pop    %esi
  80096a:	5d                   	pop    %ebp
  80096b:	c3                   	ret    

0080096c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800972:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800975:	eb 06                	jmp    80097d <strcmp+0x11>
		p++, q++;
  800977:	83 c1 01             	add    $0x1,%ecx
  80097a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80097d:	0f b6 01             	movzbl (%ecx),%eax
  800980:	84 c0                	test   %al,%al
  800982:	74 04                	je     800988 <strcmp+0x1c>
  800984:	3a 02                	cmp    (%edx),%al
  800986:	74 ef                	je     800977 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800988:	0f b6 c0             	movzbl %al,%eax
  80098b:	0f b6 12             	movzbl (%edx),%edx
  80098e:	29 d0                	sub    %edx,%eax
}
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	53                   	push   %ebx
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099c:	89 c3                	mov    %eax,%ebx
  80099e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009a1:	eb 06                	jmp    8009a9 <strncmp+0x17>
		n--, p++, q++;
  8009a3:	83 c0 01             	add    $0x1,%eax
  8009a6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009a9:	39 d8                	cmp    %ebx,%eax
  8009ab:	74 15                	je     8009c2 <strncmp+0x30>
  8009ad:	0f b6 08             	movzbl (%eax),%ecx
  8009b0:	84 c9                	test   %cl,%cl
  8009b2:	74 04                	je     8009b8 <strncmp+0x26>
  8009b4:	3a 0a                	cmp    (%edx),%cl
  8009b6:	74 eb                	je     8009a3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b8:	0f b6 00             	movzbl (%eax),%eax
  8009bb:	0f b6 12             	movzbl (%edx),%edx
  8009be:	29 d0                	sub    %edx,%eax
  8009c0:	eb 05                	jmp    8009c7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009c2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009c7:	5b                   	pop    %ebx
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d4:	eb 07                	jmp    8009dd <strchr+0x13>
		if (*s == c)
  8009d6:	38 ca                	cmp    %cl,%dl
  8009d8:	74 0f                	je     8009e9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009da:	83 c0 01             	add    $0x1,%eax
  8009dd:	0f b6 10             	movzbl (%eax),%edx
  8009e0:	84 d2                	test   %dl,%dl
  8009e2:	75 f2                	jne    8009d6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e9:	5d                   	pop    %ebp
  8009ea:	c3                   	ret    

008009eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f5:	eb 07                	jmp    8009fe <strfind+0x13>
		if (*s == c)
  8009f7:	38 ca                	cmp    %cl,%dl
  8009f9:	74 0a                	je     800a05 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009fb:	83 c0 01             	add    $0x1,%eax
  8009fe:	0f b6 10             	movzbl (%eax),%edx
  800a01:	84 d2                	test   %dl,%dl
  800a03:	75 f2                	jne    8009f7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	57                   	push   %edi
  800a0b:	56                   	push   %esi
  800a0c:	53                   	push   %ebx
  800a0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a13:	85 c9                	test   %ecx,%ecx
  800a15:	74 36                	je     800a4d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a17:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a1d:	75 28                	jne    800a47 <memset+0x40>
  800a1f:	f6 c1 03             	test   $0x3,%cl
  800a22:	75 23                	jne    800a47 <memset+0x40>
		c &= 0xFF;
  800a24:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a28:	89 d3                	mov    %edx,%ebx
  800a2a:	c1 e3 08             	shl    $0x8,%ebx
  800a2d:	89 d6                	mov    %edx,%esi
  800a2f:	c1 e6 18             	shl    $0x18,%esi
  800a32:	89 d0                	mov    %edx,%eax
  800a34:	c1 e0 10             	shl    $0x10,%eax
  800a37:	09 f0                	or     %esi,%eax
  800a39:	09 c2                	or     %eax,%edx
  800a3b:	89 d0                	mov    %edx,%eax
  800a3d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a3f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a42:	fc                   	cld    
  800a43:	f3 ab                	rep stos %eax,%es:(%edi)
  800a45:	eb 06                	jmp    800a4d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4a:	fc                   	cld    
  800a4b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a4d:	89 f8                	mov    %edi,%eax
  800a4f:	5b                   	pop    %ebx
  800a50:	5e                   	pop    %esi
  800a51:	5f                   	pop    %edi
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	57                   	push   %edi
  800a58:	56                   	push   %esi
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a62:	39 c6                	cmp    %eax,%esi
  800a64:	73 35                	jae    800a9b <memmove+0x47>
  800a66:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a69:	39 d0                	cmp    %edx,%eax
  800a6b:	73 2e                	jae    800a9b <memmove+0x47>
		s += n;
		d += n;
  800a6d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a70:	89 d6                	mov    %edx,%esi
  800a72:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a74:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a7a:	75 13                	jne    800a8f <memmove+0x3b>
  800a7c:	f6 c1 03             	test   $0x3,%cl
  800a7f:	75 0e                	jne    800a8f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a81:	83 ef 04             	sub    $0x4,%edi
  800a84:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a87:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a8a:	fd                   	std    
  800a8b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a8d:	eb 09                	jmp    800a98 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a8f:	83 ef 01             	sub    $0x1,%edi
  800a92:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a95:	fd                   	std    
  800a96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a98:	fc                   	cld    
  800a99:	eb 1d                	jmp    800ab8 <memmove+0x64>
  800a9b:	89 f2                	mov    %esi,%edx
  800a9d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9f:	f6 c2 03             	test   $0x3,%dl
  800aa2:	75 0f                	jne    800ab3 <memmove+0x5f>
  800aa4:	f6 c1 03             	test   $0x3,%cl
  800aa7:	75 0a                	jne    800ab3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aa9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800aac:	89 c7                	mov    %eax,%edi
  800aae:	fc                   	cld    
  800aaf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab1:	eb 05                	jmp    800ab8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ab3:	89 c7                	mov    %eax,%edi
  800ab5:	fc                   	cld    
  800ab6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ab8:	5e                   	pop    %esi
  800ab9:	5f                   	pop    %edi
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ac2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	89 04 24             	mov    %eax,(%esp)
  800ad6:	e8 79 ff ff ff       	call   800a54 <memmove>
}
  800adb:	c9                   	leave  
  800adc:	c3                   	ret    

00800add <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	56                   	push   %esi
  800ae1:	53                   	push   %ebx
  800ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae8:	89 d6                	mov    %edx,%esi
  800aea:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aed:	eb 1a                	jmp    800b09 <memcmp+0x2c>
		if (*s1 != *s2)
  800aef:	0f b6 02             	movzbl (%edx),%eax
  800af2:	0f b6 19             	movzbl (%ecx),%ebx
  800af5:	38 d8                	cmp    %bl,%al
  800af7:	74 0a                	je     800b03 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800af9:	0f b6 c0             	movzbl %al,%eax
  800afc:	0f b6 db             	movzbl %bl,%ebx
  800aff:	29 d8                	sub    %ebx,%eax
  800b01:	eb 0f                	jmp    800b12 <memcmp+0x35>
		s1++, s2++;
  800b03:	83 c2 01             	add    $0x1,%edx
  800b06:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b09:	39 f2                	cmp    %esi,%edx
  800b0b:	75 e2                	jne    800aef <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b12:	5b                   	pop    %ebx
  800b13:	5e                   	pop    %esi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b1f:	89 c2                	mov    %eax,%edx
  800b21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b24:	eb 07                	jmp    800b2d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b26:	38 08                	cmp    %cl,(%eax)
  800b28:	74 07                	je     800b31 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b2a:	83 c0 01             	add    $0x1,%eax
  800b2d:	39 d0                	cmp    %edx,%eax
  800b2f:	72 f5                	jb     800b26 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	57                   	push   %edi
  800b37:	56                   	push   %esi
  800b38:	53                   	push   %ebx
  800b39:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b3f:	eb 03                	jmp    800b44 <strtol+0x11>
		s++;
  800b41:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b44:	0f b6 0a             	movzbl (%edx),%ecx
  800b47:	80 f9 09             	cmp    $0x9,%cl
  800b4a:	74 f5                	je     800b41 <strtol+0xe>
  800b4c:	80 f9 20             	cmp    $0x20,%cl
  800b4f:	74 f0                	je     800b41 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b51:	80 f9 2b             	cmp    $0x2b,%cl
  800b54:	75 0a                	jne    800b60 <strtol+0x2d>
		s++;
  800b56:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b59:	bf 00 00 00 00       	mov    $0x0,%edi
  800b5e:	eb 11                	jmp    800b71 <strtol+0x3e>
  800b60:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b65:	80 f9 2d             	cmp    $0x2d,%cl
  800b68:	75 07                	jne    800b71 <strtol+0x3e>
		s++, neg = 1;
  800b6a:	8d 52 01             	lea    0x1(%edx),%edx
  800b6d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b71:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b76:	75 15                	jne    800b8d <strtol+0x5a>
  800b78:	80 3a 30             	cmpb   $0x30,(%edx)
  800b7b:	75 10                	jne    800b8d <strtol+0x5a>
  800b7d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b81:	75 0a                	jne    800b8d <strtol+0x5a>
		s += 2, base = 16;
  800b83:	83 c2 02             	add    $0x2,%edx
  800b86:	b8 10 00 00 00       	mov    $0x10,%eax
  800b8b:	eb 10                	jmp    800b9d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b8d:	85 c0                	test   %eax,%eax
  800b8f:	75 0c                	jne    800b9d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b91:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b93:	80 3a 30             	cmpb   $0x30,(%edx)
  800b96:	75 05                	jne    800b9d <strtol+0x6a>
		s++, base = 8;
  800b98:	83 c2 01             	add    $0x1,%edx
  800b9b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ba2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ba5:	0f b6 0a             	movzbl (%edx),%ecx
  800ba8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bab:	89 f0                	mov    %esi,%eax
  800bad:	3c 09                	cmp    $0x9,%al
  800baf:	77 08                	ja     800bb9 <strtol+0x86>
			dig = *s - '0';
  800bb1:	0f be c9             	movsbl %cl,%ecx
  800bb4:	83 e9 30             	sub    $0x30,%ecx
  800bb7:	eb 20                	jmp    800bd9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800bb9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bbc:	89 f0                	mov    %esi,%eax
  800bbe:	3c 19                	cmp    $0x19,%al
  800bc0:	77 08                	ja     800bca <strtol+0x97>
			dig = *s - 'a' + 10;
  800bc2:	0f be c9             	movsbl %cl,%ecx
  800bc5:	83 e9 57             	sub    $0x57,%ecx
  800bc8:	eb 0f                	jmp    800bd9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bca:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bcd:	89 f0                	mov    %esi,%eax
  800bcf:	3c 19                	cmp    $0x19,%al
  800bd1:	77 16                	ja     800be9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800bd3:	0f be c9             	movsbl %cl,%ecx
  800bd6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bd9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bdc:	7d 0f                	jge    800bed <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bde:	83 c2 01             	add    $0x1,%edx
  800be1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800be5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800be7:	eb bc                	jmp    800ba5 <strtol+0x72>
  800be9:	89 d8                	mov    %ebx,%eax
  800beb:	eb 02                	jmp    800bef <strtol+0xbc>
  800bed:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf3:	74 05                	je     800bfa <strtol+0xc7>
		*endptr = (char *) s;
  800bf5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bfa:	f7 d8                	neg    %eax
  800bfc:	85 ff                	test   %edi,%edi
  800bfe:	0f 44 c3             	cmove  %ebx,%eax
}
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5f                   	pop    %edi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	57                   	push   %edi
  800c0a:	56                   	push   %esi
  800c0b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c14:	8b 55 08             	mov    0x8(%ebp),%edx
  800c17:	89 c3                	mov    %eax,%ebx
  800c19:	89 c7                	mov    %eax,%edi
  800c1b:	89 c6                	mov    %eax,%esi
  800c1d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c34:	89 d1                	mov    %edx,%ecx
  800c36:	89 d3                	mov    %edx,%ebx
  800c38:	89 d7                	mov    %edx,%edi
  800c3a:	89 d6                	mov    %edx,%esi
  800c3c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c51:	b8 03 00 00 00       	mov    $0x3,%eax
  800c56:	8b 55 08             	mov    0x8(%ebp),%edx
  800c59:	89 cb                	mov    %ecx,%ebx
  800c5b:	89 cf                	mov    %ecx,%edi
  800c5d:	89 ce                	mov    %ecx,%esi
  800c5f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c61:	85 c0                	test   %eax,%eax
  800c63:	7e 28                	jle    800c8d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c65:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c69:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c70:	00 
  800c71:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800c78:	00 
  800c79:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c80:	00 
  800c81:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800c88:	e8 b4 f4 ff ff       	call   800141 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c8d:	83 c4 2c             	add    $0x2c,%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca3:	b8 04 00 00 00       	mov    $0x4,%eax
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	89 cb                	mov    %ecx,%ebx
  800cad:	89 cf                	mov    %ecx,%edi
  800caf:	89 ce                	mov    %ecx,%esi
  800cb1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cb3:	85 c0                	test   %eax,%eax
  800cb5:	7e 28                	jle    800cdf <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cbb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cc2:	00 
  800cc3:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800cca:	00 
  800ccb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd2:	00 
  800cd3:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800cda:	e8 62 f4 ff ff       	call   800141 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800cdf:	83 c4 2c             	add    $0x2c,%esp
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ced:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf2:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf7:	89 d1                	mov    %edx,%ecx
  800cf9:	89 d3                	mov    %edx,%ebx
  800cfb:	89 d7                	mov    %edx,%edi
  800cfd:	89 d6                	mov    %edx,%esi
  800cff:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5f                   	pop    %edi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <sys_yield>:

void
sys_yield(void)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d11:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d16:	89 d1                	mov    %edx,%ecx
  800d18:	89 d3                	mov    %edx,%ebx
  800d1a:	89 d7                	mov    %edx,%edi
  800d1c:	89 d6                	mov    %edx,%esi
  800d1e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2e:	be 00 00 00 00       	mov    $0x0,%esi
  800d33:	b8 05 00 00 00       	mov    $0x5,%eax
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d41:	89 f7                	mov    %esi,%edi
  800d43:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	7e 28                	jle    800d71 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d49:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d4d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d54:	00 
  800d55:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800d5c:	00 
  800d5d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d64:	00 
  800d65:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800d6c:	e8 d0 f3 ff ff       	call   800141 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d71:	83 c4 2c             	add    $0x2c,%esp
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    

00800d79 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	57                   	push   %edi
  800d7d:	56                   	push   %esi
  800d7e:	53                   	push   %ebx
  800d7f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d82:	b8 06 00 00 00       	mov    $0x6,%eax
  800d87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d90:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d93:	8b 75 18             	mov    0x18(%ebp),%esi
  800d96:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d98:	85 c0                	test   %eax,%eax
  800d9a:	7e 28                	jle    800dc4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800da7:	00 
  800da8:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800daf:	00 
  800db0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db7:	00 
  800db8:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800dbf:	e8 7d f3 ff ff       	call   800141 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dc4:	83 c4 2c             	add    $0x2c,%esp
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	57                   	push   %edi
  800dd0:	56                   	push   %esi
  800dd1:	53                   	push   %ebx
  800dd2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dda:	b8 07 00 00 00       	mov    $0x7,%eax
  800ddf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de2:	8b 55 08             	mov    0x8(%ebp),%edx
  800de5:	89 df                	mov    %ebx,%edi
  800de7:	89 de                	mov    %ebx,%esi
  800de9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800deb:	85 c0                	test   %eax,%eax
  800ded:	7e 28                	jle    800e17 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800def:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800dfa:	00 
  800dfb:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800e02:	00 
  800e03:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e0a:	00 
  800e0b:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800e12:	e8 2a f3 ff ff       	call   800141 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e17:	83 c4 2c             	add    $0x2c,%esp
  800e1a:	5b                   	pop    %ebx
  800e1b:	5e                   	pop    %esi
  800e1c:	5f                   	pop    %edi
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    

00800e1f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e25:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e2a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e32:	89 cb                	mov    %ecx,%ebx
  800e34:	89 cf                	mov    %ecx,%edi
  800e36:	89 ce                	mov    %ecx,%esi
  800e38:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	57                   	push   %edi
  800e43:	56                   	push   %esi
  800e44:	53                   	push   %ebx
  800e45:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e55:	8b 55 08             	mov    0x8(%ebp),%edx
  800e58:	89 df                	mov    %ebx,%edi
  800e5a:	89 de                	mov    %ebx,%esi
  800e5c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	7e 28                	jle    800e8a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e62:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e66:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e6d:	00 
  800e6e:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800e75:	00 
  800e76:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7d:	00 
  800e7e:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800e85:	e8 b7 f2 ff ff       	call   800141 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e8a:	83 c4 2c             	add    $0x2c,%esp
  800e8d:	5b                   	pop    %ebx
  800e8e:	5e                   	pop    %esi
  800e8f:	5f                   	pop    %edi
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    

00800e92 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	57                   	push   %edi
  800e96:	56                   	push   %esi
  800e97:	53                   	push   %ebx
  800e98:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eab:	89 df                	mov    %ebx,%edi
  800ead:	89 de                	mov    %ebx,%esi
  800eaf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb1:	85 c0                	test   %eax,%eax
  800eb3:	7e 28                	jle    800edd <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eb9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ec0:	00 
  800ec1:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800ec8:	00 
  800ec9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed0:	00 
  800ed1:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800ed8:	e8 64 f2 ff ff       	call   800141 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800edd:	83 c4 2c             	add    $0x2c,%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	57                   	push   %edi
  800ee9:	56                   	push   %esi
  800eea:	53                   	push   %ebx
  800eeb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ef8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efb:	8b 55 08             	mov    0x8(%ebp),%edx
  800efe:	89 df                	mov    %ebx,%edi
  800f00:	89 de                	mov    %ebx,%esi
  800f02:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f04:	85 c0                	test   %eax,%eax
  800f06:	7e 28                	jle    800f30 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f08:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f0c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f13:	00 
  800f14:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800f1b:	00 
  800f1c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f23:	00 
  800f24:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800f2b:	e8 11 f2 ff ff       	call   800141 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f30:	83 c4 2c             	add    $0x2c,%esp
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	57                   	push   %edi
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3e:	be 00 00 00 00       	mov    $0x0,%esi
  800f43:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f51:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f54:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
  800f61:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f64:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f69:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	89 cb                	mov    %ecx,%ebx
  800f73:	89 cf                	mov    %ecx,%edi
  800f75:	89 ce                	mov    %ecx,%esi
  800f77:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	7e 28                	jle    800fa5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f81:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800f88:	00 
  800f89:	c7 44 24 08 f7 2b 80 	movl   $0x802bf7,0x8(%esp)
  800f90:	00 
  800f91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f98:	00 
  800f99:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  800fa0:	e8 9c f1 ff ff       	call   800141 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa5:	83 c4 2c             	add    $0x2c,%esp
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <sys_time_msec>:

unsigned int
sys_time_msec(void)
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
  800fb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fbd:	89 d1                	mov    %edx,%ecx
  800fbf:	89 d3                	mov    %edx,%ebx
  800fc1:	89 d7                	mov    %edx,%edi
  800fc3:	89 d6                	mov    %edx,%esi
  800fc5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fc7:	5b                   	pop    %ebx
  800fc8:	5e                   	pop    %esi
  800fc9:	5f                   	pop    %edi
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	57                   	push   %edi
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd7:	b8 11 00 00 00       	mov    $0x11,%eax
  800fdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	89 df                	mov    %ebx,%edi
  800fe4:	89 de                	mov    %ebx,%esi
  800fe6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800fe8:	5b                   	pop    %ebx
  800fe9:	5e                   	pop    %esi
  800fea:	5f                   	pop    %edi
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    

00800fed <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	57                   	push   %edi
  800ff1:	56                   	push   %esi
  800ff2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff8:	b8 12 00 00 00       	mov    $0x12,%eax
  800ffd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801000:	8b 55 08             	mov    0x8(%ebp),%edx
  801003:	89 df                	mov    %ebx,%edi
  801005:	89 de                	mov    %ebx,%esi
  801007:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801009:	5b                   	pop    %ebx
  80100a:	5e                   	pop    %esi
  80100b:	5f                   	pop    %edi
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    

0080100e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	57                   	push   %edi
  801012:	56                   	push   %esi
  801013:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801014:	b9 00 00 00 00       	mov    $0x0,%ecx
  801019:	b8 13 00 00 00       	mov    $0x13,%eax
  80101e:	8b 55 08             	mov    0x8(%ebp),%edx
  801021:	89 cb                	mov    %ecx,%ebx
  801023:	89 cf                	mov    %ecx,%edi
  801025:	89 ce                	mov    %ecx,%esi
  801027:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801029:	5b                   	pop    %ebx
  80102a:	5e                   	pop    %esi
  80102b:	5f                   	pop    %edi
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    

0080102e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  801034:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  80103b:	75 7a                	jne    8010b7 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80103d:	e8 a5 fc ff ff       	call   800ce7 <sys_getenvid>
  801042:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801049:	00 
  80104a:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801051:	ee 
  801052:	89 04 24             	mov    %eax,(%esp)
  801055:	e8 cb fc ff ff       	call   800d25 <sys_page_alloc>
  80105a:	85 c0                	test   %eax,%eax
  80105c:	79 20                	jns    80107e <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  80105e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801062:	c7 44 24 08 22 2c 80 	movl   $0x802c22,0x8(%esp)
  801069:	00 
  80106a:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  801071:	00 
  801072:	c7 04 24 35 2c 80 00 	movl   $0x802c35,(%esp)
  801079:	e8 c3 f0 ff ff       	call   800141 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  80107e:	e8 64 fc ff ff       	call   800ce7 <sys_getenvid>
  801083:	c7 44 24 04 c1 10 80 	movl   $0x8010c1,0x4(%esp)
  80108a:	00 
  80108b:	89 04 24             	mov    %eax,(%esp)
  80108e:	e8 52 fe ff ff       	call   800ee5 <sys_env_set_pgfault_upcall>
  801093:	85 c0                	test   %eax,%eax
  801095:	79 20                	jns    8010b7 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  801097:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80109b:	c7 44 24 08 44 2c 80 	movl   $0x802c44,0x8(%esp)
  8010a2:	00 
  8010a3:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8010aa:	00 
  8010ab:	c7 04 24 35 2c 80 00 	movl   $0x802c35,(%esp)
  8010b2:	e8 8a f0 ff ff       	call   800141 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8010c1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8010c2:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  8010c7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8010c9:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  8010cc:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  8010d0:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8010d4:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  8010d7:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  8010db:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  8010dd:	83 c4 08             	add    $0x8,%esp
	popal
  8010e0:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  8010e1:	83 c4 04             	add    $0x4,%esp
	popfl
  8010e4:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8010e5:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8010e6:	c3                   	ret    
  8010e7:	66 90                	xchg   %ax,%ax
  8010e9:	66 90                	xchg   %ax,%ax
  8010eb:	66 90                	xchg   %ax,%ax
  8010ed:	66 90                	xchg   %ax,%ax
  8010ef:	90                   	nop

008010f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    

00801100 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80110b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801110:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    

00801117 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801122:	89 c2                	mov    %eax,%edx
  801124:	c1 ea 16             	shr    $0x16,%edx
  801127:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80112e:	f6 c2 01             	test   $0x1,%dl
  801131:	74 11                	je     801144 <fd_alloc+0x2d>
  801133:	89 c2                	mov    %eax,%edx
  801135:	c1 ea 0c             	shr    $0xc,%edx
  801138:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80113f:	f6 c2 01             	test   $0x1,%dl
  801142:	75 09                	jne    80114d <fd_alloc+0x36>
			*fd_store = fd;
  801144:	89 01                	mov    %eax,(%ecx)
			return 0;
  801146:	b8 00 00 00 00       	mov    $0x0,%eax
  80114b:	eb 17                	jmp    801164 <fd_alloc+0x4d>
  80114d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801152:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801157:	75 c9                	jne    801122 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801159:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80115f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80116c:	83 f8 1f             	cmp    $0x1f,%eax
  80116f:	77 36                	ja     8011a7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801171:	c1 e0 0c             	shl    $0xc,%eax
  801174:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801179:	89 c2                	mov    %eax,%edx
  80117b:	c1 ea 16             	shr    $0x16,%edx
  80117e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801185:	f6 c2 01             	test   $0x1,%dl
  801188:	74 24                	je     8011ae <fd_lookup+0x48>
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	c1 ea 0c             	shr    $0xc,%edx
  80118f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801196:	f6 c2 01             	test   $0x1,%dl
  801199:	74 1a                	je     8011b5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80119b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119e:	89 02                	mov    %eax,(%edx)
	return 0;
  8011a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a5:	eb 13                	jmp    8011ba <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ac:	eb 0c                	jmp    8011ba <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b3:	eb 05                	jmp    8011ba <fd_lookup+0x54>
  8011b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8011ba:	5d                   	pop    %ebp
  8011bb:	c3                   	ret    

008011bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 18             	sub    $0x18,%esp
  8011c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ca:	eb 13                	jmp    8011df <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8011cc:	39 08                	cmp    %ecx,(%eax)
  8011ce:	75 0c                	jne    8011dc <dev_lookup+0x20>
			*dev = devtab[i];
  8011d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011da:	eb 38                	jmp    801214 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011dc:	83 c2 01             	add    $0x1,%edx
  8011df:	8b 04 95 e4 2c 80 00 	mov    0x802ce4(,%edx,4),%eax
  8011e6:	85 c0                	test   %eax,%eax
  8011e8:	75 e2                	jne    8011cc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8011ef:	8b 40 48             	mov    0x48(%eax),%eax
  8011f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011fa:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  801201:	e8 34 f0 ff ff       	call   80023a <cprintf>
	*dev = 0;
  801206:	8b 45 0c             	mov    0xc(%ebp),%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80120f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	56                   	push   %esi
  80121a:	53                   	push   %ebx
  80121b:	83 ec 20             	sub    $0x20,%esp
  80121e:	8b 75 08             	mov    0x8(%ebp),%esi
  801221:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801224:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801227:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80122b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801231:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801234:	89 04 24             	mov    %eax,(%esp)
  801237:	e8 2a ff ff ff       	call   801166 <fd_lookup>
  80123c:	85 c0                	test   %eax,%eax
  80123e:	78 05                	js     801245 <fd_close+0x2f>
	    || fd != fd2)
  801240:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801243:	74 0c                	je     801251 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801245:	84 db                	test   %bl,%bl
  801247:	ba 00 00 00 00       	mov    $0x0,%edx
  80124c:	0f 44 c2             	cmove  %edx,%eax
  80124f:	eb 3f                	jmp    801290 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801251:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801254:	89 44 24 04          	mov    %eax,0x4(%esp)
  801258:	8b 06                	mov    (%esi),%eax
  80125a:	89 04 24             	mov    %eax,(%esp)
  80125d:	e8 5a ff ff ff       	call   8011bc <dev_lookup>
  801262:	89 c3                	mov    %eax,%ebx
  801264:	85 c0                	test   %eax,%eax
  801266:	78 16                	js     80127e <fd_close+0x68>
		if (dev->dev_close)
  801268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80126e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801273:	85 c0                	test   %eax,%eax
  801275:	74 07                	je     80127e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801277:	89 34 24             	mov    %esi,(%esp)
  80127a:	ff d0                	call   *%eax
  80127c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80127e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801282:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801289:	e8 3e fb ff ff       	call   800dcc <sys_page_unmap>
	return r;
  80128e:	89 d8                	mov    %ebx,%eax
}
  801290:	83 c4 20             	add    $0x20,%esp
  801293:	5b                   	pop    %ebx
  801294:	5e                   	pop    %esi
  801295:	5d                   	pop    %ebp
  801296:	c3                   	ret    

00801297 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80129d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	89 04 24             	mov    %eax,(%esp)
  8012aa:	e8 b7 fe ff ff       	call   801166 <fd_lookup>
  8012af:	89 c2                	mov    %eax,%edx
  8012b1:	85 d2                	test   %edx,%edx
  8012b3:	78 13                	js     8012c8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012bc:	00 
  8012bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c0:	89 04 24             	mov    %eax,(%esp)
  8012c3:	e8 4e ff ff ff       	call   801216 <fd_close>
}
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <close_all>:

void
close_all(void)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	53                   	push   %ebx
  8012ce:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012d6:	89 1c 24             	mov    %ebx,(%esp)
  8012d9:	e8 b9 ff ff ff       	call   801297 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012de:	83 c3 01             	add    $0x1,%ebx
  8012e1:	83 fb 20             	cmp    $0x20,%ebx
  8012e4:	75 f0                	jne    8012d6 <close_all+0xc>
		close(i);
}
  8012e6:	83 c4 14             	add    $0x14,%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    

008012ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	57                   	push   %edi
  8012f0:	56                   	push   %esi
  8012f1:	53                   	push   %ebx
  8012f2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	89 04 24             	mov    %eax,(%esp)
  801302:	e8 5f fe ff ff       	call   801166 <fd_lookup>
  801307:	89 c2                	mov    %eax,%edx
  801309:	85 d2                	test   %edx,%edx
  80130b:	0f 88 e1 00 00 00    	js     8013f2 <dup+0x106>
		return r;
	close(newfdnum);
  801311:	8b 45 0c             	mov    0xc(%ebp),%eax
  801314:	89 04 24             	mov    %eax,(%esp)
  801317:	e8 7b ff ff ff       	call   801297 <close>

	newfd = INDEX2FD(newfdnum);
  80131c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80131f:	c1 e3 0c             	shl    $0xc,%ebx
  801322:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80132b:	89 04 24             	mov    %eax,(%esp)
  80132e:	e8 cd fd ff ff       	call   801100 <fd2data>
  801333:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801335:	89 1c 24             	mov    %ebx,(%esp)
  801338:	e8 c3 fd ff ff       	call   801100 <fd2data>
  80133d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80133f:	89 f0                	mov    %esi,%eax
  801341:	c1 e8 16             	shr    $0x16,%eax
  801344:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80134b:	a8 01                	test   $0x1,%al
  80134d:	74 43                	je     801392 <dup+0xa6>
  80134f:	89 f0                	mov    %esi,%eax
  801351:	c1 e8 0c             	shr    $0xc,%eax
  801354:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80135b:	f6 c2 01             	test   $0x1,%dl
  80135e:	74 32                	je     801392 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801360:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801367:	25 07 0e 00 00       	and    $0xe07,%eax
  80136c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801370:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801374:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80137b:	00 
  80137c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801380:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801387:	e8 ed f9 ff ff       	call   800d79 <sys_page_map>
  80138c:	89 c6                	mov    %eax,%esi
  80138e:	85 c0                	test   %eax,%eax
  801390:	78 3e                	js     8013d0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801392:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801395:	89 c2                	mov    %eax,%edx
  801397:	c1 ea 0c             	shr    $0xc,%edx
  80139a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013a1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013b6:	00 
  8013b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c2:	e8 b2 f9 ff ff       	call   800d79 <sys_page_map>
  8013c7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013cc:	85 f6                	test   %esi,%esi
  8013ce:	79 22                	jns    8013f2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013db:	e8 ec f9 ff ff       	call   800dcc <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013eb:	e8 dc f9 ff ff       	call   800dcc <sys_page_unmap>
	return r;
  8013f0:	89 f0                	mov    %esi,%eax
}
  8013f2:	83 c4 3c             	add    $0x3c,%esp
  8013f5:	5b                   	pop    %ebx
  8013f6:	5e                   	pop    %esi
  8013f7:	5f                   	pop    %edi
  8013f8:	5d                   	pop    %ebp
  8013f9:	c3                   	ret    

008013fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	53                   	push   %ebx
  8013fe:	83 ec 24             	sub    $0x24,%esp
  801401:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801404:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801407:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140b:	89 1c 24             	mov    %ebx,(%esp)
  80140e:	e8 53 fd ff ff       	call   801166 <fd_lookup>
  801413:	89 c2                	mov    %eax,%edx
  801415:	85 d2                	test   %edx,%edx
  801417:	78 6d                	js     801486 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801419:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801423:	8b 00                	mov    (%eax),%eax
  801425:	89 04 24             	mov    %eax,(%esp)
  801428:	e8 8f fd ff ff       	call   8011bc <dev_lookup>
  80142d:	85 c0                	test   %eax,%eax
  80142f:	78 55                	js     801486 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801434:	8b 50 08             	mov    0x8(%eax),%edx
  801437:	83 e2 03             	and    $0x3,%edx
  80143a:	83 fa 01             	cmp    $0x1,%edx
  80143d:	75 23                	jne    801462 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80143f:	a1 08 40 80 00       	mov    0x804008,%eax
  801444:	8b 40 48             	mov    0x48(%eax),%eax
  801447:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80144b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144f:	c7 04 24 a9 2c 80 00 	movl   $0x802ca9,(%esp)
  801456:	e8 df ed ff ff       	call   80023a <cprintf>
		return -E_INVAL;
  80145b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801460:	eb 24                	jmp    801486 <read+0x8c>
	}
	if (!dev->dev_read)
  801462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801465:	8b 52 08             	mov    0x8(%edx),%edx
  801468:	85 d2                	test   %edx,%edx
  80146a:	74 15                	je     801481 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80146c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80146f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801473:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801476:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80147a:	89 04 24             	mov    %eax,(%esp)
  80147d:	ff d2                	call   *%edx
  80147f:	eb 05                	jmp    801486 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801481:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801486:	83 c4 24             	add    $0x24,%esp
  801489:	5b                   	pop    %ebx
  80148a:	5d                   	pop    %ebp
  80148b:	c3                   	ret    

0080148c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	57                   	push   %edi
  801490:	56                   	push   %esi
  801491:	53                   	push   %ebx
  801492:	83 ec 1c             	sub    $0x1c,%esp
  801495:	8b 7d 08             	mov    0x8(%ebp),%edi
  801498:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80149b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a0:	eb 23                	jmp    8014c5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014a2:	89 f0                	mov    %esi,%eax
  8014a4:	29 d8                	sub    %ebx,%eax
  8014a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014aa:	89 d8                	mov    %ebx,%eax
  8014ac:	03 45 0c             	add    0xc(%ebp),%eax
  8014af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b3:	89 3c 24             	mov    %edi,(%esp)
  8014b6:	e8 3f ff ff ff       	call   8013fa <read>
		if (m < 0)
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	78 10                	js     8014cf <readn+0x43>
			return m;
		if (m == 0)
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	74 0a                	je     8014cd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014c3:	01 c3                	add    %eax,%ebx
  8014c5:	39 f3                	cmp    %esi,%ebx
  8014c7:	72 d9                	jb     8014a2 <readn+0x16>
  8014c9:	89 d8                	mov    %ebx,%eax
  8014cb:	eb 02                	jmp    8014cf <readn+0x43>
  8014cd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014cf:	83 c4 1c             	add    $0x1c,%esp
  8014d2:	5b                   	pop    %ebx
  8014d3:	5e                   	pop    %esi
  8014d4:	5f                   	pop    %edi
  8014d5:	5d                   	pop    %ebp
  8014d6:	c3                   	ret    

008014d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	53                   	push   %ebx
  8014db:	83 ec 24             	sub    $0x24,%esp
  8014de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e8:	89 1c 24             	mov    %ebx,(%esp)
  8014eb:	e8 76 fc ff ff       	call   801166 <fd_lookup>
  8014f0:	89 c2                	mov    %eax,%edx
  8014f2:	85 d2                	test   %edx,%edx
  8014f4:	78 68                	js     80155e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801500:	8b 00                	mov    (%eax),%eax
  801502:	89 04 24             	mov    %eax,(%esp)
  801505:	e8 b2 fc ff ff       	call   8011bc <dev_lookup>
  80150a:	85 c0                	test   %eax,%eax
  80150c:	78 50                	js     80155e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80150e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801511:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801515:	75 23                	jne    80153a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801517:	a1 08 40 80 00       	mov    0x804008,%eax
  80151c:	8b 40 48             	mov    0x48(%eax),%eax
  80151f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801523:	89 44 24 04          	mov    %eax,0x4(%esp)
  801527:	c7 04 24 c5 2c 80 00 	movl   $0x802cc5,(%esp)
  80152e:	e8 07 ed ff ff       	call   80023a <cprintf>
		return -E_INVAL;
  801533:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801538:	eb 24                	jmp    80155e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80153a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80153d:	8b 52 0c             	mov    0xc(%edx),%edx
  801540:	85 d2                	test   %edx,%edx
  801542:	74 15                	je     801559 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801544:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801547:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80154b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80154e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801552:	89 04 24             	mov    %eax,(%esp)
  801555:	ff d2                	call   *%edx
  801557:	eb 05                	jmp    80155e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801559:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80155e:	83 c4 24             	add    $0x24,%esp
  801561:	5b                   	pop    %ebx
  801562:	5d                   	pop    %ebp
  801563:	c3                   	ret    

00801564 <seek>:

int
seek(int fdnum, off_t offset)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80156a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80156d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	89 04 24             	mov    %eax,(%esp)
  801577:	e8 ea fb ff ff       	call   801166 <fd_lookup>
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 0e                	js     80158e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801583:	8b 55 0c             	mov    0xc(%ebp),%edx
  801586:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	53                   	push   %ebx
  801594:	83 ec 24             	sub    $0x24,%esp
  801597:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80159a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80159d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a1:	89 1c 24             	mov    %ebx,(%esp)
  8015a4:	e8 bd fb ff ff       	call   801166 <fd_lookup>
  8015a9:	89 c2                	mov    %eax,%edx
  8015ab:	85 d2                	test   %edx,%edx
  8015ad:	78 61                	js     801610 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b9:	8b 00                	mov    (%eax),%eax
  8015bb:	89 04 24             	mov    %eax,(%esp)
  8015be:	e8 f9 fb ff ff       	call   8011bc <dev_lookup>
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	78 49                	js     801610 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ce:	75 23                	jne    8015f3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015d0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015d5:	8b 40 48             	mov    0x48(%eax),%eax
  8015d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e0:	c7 04 24 88 2c 80 00 	movl   $0x802c88,(%esp)
  8015e7:	e8 4e ec ff ff       	call   80023a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f1:	eb 1d                	jmp    801610 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f6:	8b 52 18             	mov    0x18(%edx),%edx
  8015f9:	85 d2                	test   %edx,%edx
  8015fb:	74 0e                	je     80160b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801600:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801604:	89 04 24             	mov    %eax,(%esp)
  801607:	ff d2                	call   *%edx
  801609:	eb 05                	jmp    801610 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80160b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801610:	83 c4 24             	add    $0x24,%esp
  801613:	5b                   	pop    %ebx
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	53                   	push   %ebx
  80161a:	83 ec 24             	sub    $0x24,%esp
  80161d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801620:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801623:	89 44 24 04          	mov    %eax,0x4(%esp)
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	89 04 24             	mov    %eax,(%esp)
  80162d:	e8 34 fb ff ff       	call   801166 <fd_lookup>
  801632:	89 c2                	mov    %eax,%edx
  801634:	85 d2                	test   %edx,%edx
  801636:	78 52                	js     80168a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801638:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801642:	8b 00                	mov    (%eax),%eax
  801644:	89 04 24             	mov    %eax,(%esp)
  801647:	e8 70 fb ff ff       	call   8011bc <dev_lookup>
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 3a                	js     80168a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801653:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801657:	74 2c                	je     801685 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801659:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80165c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801663:	00 00 00 
	stat->st_isdir = 0;
  801666:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80166d:	00 00 00 
	stat->st_dev = dev;
  801670:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801676:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80167a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80167d:	89 14 24             	mov    %edx,(%esp)
  801680:	ff 50 14             	call   *0x14(%eax)
  801683:	eb 05                	jmp    80168a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801685:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80168a:	83 c4 24             	add    $0x24,%esp
  80168d:	5b                   	pop    %ebx
  80168e:	5d                   	pop    %ebp
  80168f:	c3                   	ret    

00801690 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	56                   	push   %esi
  801694:	53                   	push   %ebx
  801695:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801698:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80169f:	00 
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	89 04 24             	mov    %eax,(%esp)
  8016a6:	e8 99 02 00 00       	call   801944 <open>
  8016ab:	89 c3                	mov    %eax,%ebx
  8016ad:	85 db                	test   %ebx,%ebx
  8016af:	78 1b                	js     8016cc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b8:	89 1c 24             	mov    %ebx,(%esp)
  8016bb:	e8 56 ff ff ff       	call   801616 <fstat>
  8016c0:	89 c6                	mov    %eax,%esi
	close(fd);
  8016c2:	89 1c 24             	mov    %ebx,(%esp)
  8016c5:	e8 cd fb ff ff       	call   801297 <close>
	return r;
  8016ca:	89 f0                	mov    %esi,%eax
}
  8016cc:	83 c4 10             	add    $0x10,%esp
  8016cf:	5b                   	pop    %ebx
  8016d0:	5e                   	pop    %esi
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    

008016d3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	56                   	push   %esi
  8016d7:	53                   	push   %ebx
  8016d8:	83 ec 10             	sub    $0x10,%esp
  8016db:	89 c6                	mov    %eax,%esi
  8016dd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016df:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016e6:	75 11                	jne    8016f9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016ef:	e8 2b 0e 00 00       	call   80251f <ipc_find_env>
  8016f4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016f9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801700:	00 
  801701:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801708:	00 
  801709:	89 74 24 04          	mov    %esi,0x4(%esp)
  80170d:	a1 00 40 80 00       	mov    0x804000,%eax
  801712:	89 04 24             	mov    %eax,(%esp)
  801715:	e8 9e 0d 00 00       	call   8024b8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80171a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801721:	00 
  801722:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801726:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80172d:	e8 1e 0d 00 00       	call   802450 <ipc_recv>
}
  801732:	83 c4 10             	add    $0x10,%esp
  801735:	5b                   	pop    %ebx
  801736:	5e                   	pop    %esi
  801737:	5d                   	pop    %ebp
  801738:	c3                   	ret    

00801739 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8b 40 0c             	mov    0xc(%eax),%eax
  801745:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80174a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801752:	ba 00 00 00 00       	mov    $0x0,%edx
  801757:	b8 02 00 00 00       	mov    $0x2,%eax
  80175c:	e8 72 ff ff ff       	call   8016d3 <fsipc>
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	8b 40 0c             	mov    0xc(%eax),%eax
  80176f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801774:	ba 00 00 00 00       	mov    $0x0,%edx
  801779:	b8 06 00 00 00       	mov    $0x6,%eax
  80177e:	e8 50 ff ff ff       	call   8016d3 <fsipc>
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	53                   	push   %ebx
  801789:	83 ec 14             	sub    $0x14,%esp
  80178c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8b 40 0c             	mov    0xc(%eax),%eax
  801795:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80179a:	ba 00 00 00 00       	mov    $0x0,%edx
  80179f:	b8 05 00 00 00       	mov    $0x5,%eax
  8017a4:	e8 2a ff ff ff       	call   8016d3 <fsipc>
  8017a9:	89 c2                	mov    %eax,%edx
  8017ab:	85 d2                	test   %edx,%edx
  8017ad:	78 2b                	js     8017da <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017af:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017b6:	00 
  8017b7:	89 1c 24             	mov    %ebx,(%esp)
  8017ba:	e8 f8 f0 ff ff       	call   8008b7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017bf:	a1 80 50 80 00       	mov    0x805080,%eax
  8017c4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017ca:	a1 84 50 80 00       	mov    0x805084,%eax
  8017cf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017da:	83 c4 14             	add    $0x14,%esp
  8017dd:	5b                   	pop    %ebx
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    

008017e0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 14             	sub    $0x14,%esp
  8017e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  8017ea:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  8017f0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8017f5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fb:	8b 52 0c             	mov    0xc(%edx),%edx
  8017fe:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  801804:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801809:	89 44 24 08          	mov    %eax,0x8(%esp)
  80180d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801810:	89 44 24 04          	mov    %eax,0x4(%esp)
  801814:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80181b:	e8 34 f2 ff ff       	call   800a54 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801820:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  801827:	00 
  801828:	c7 04 24 f8 2c 80 00 	movl   $0x802cf8,(%esp)
  80182f:	e8 06 ea ff ff       	call   80023a <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801834:	ba 00 00 00 00       	mov    $0x0,%edx
  801839:	b8 04 00 00 00       	mov    $0x4,%eax
  80183e:	e8 90 fe ff ff       	call   8016d3 <fsipc>
  801843:	85 c0                	test   %eax,%eax
  801845:	78 53                	js     80189a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801847:	39 c3                	cmp    %eax,%ebx
  801849:	73 24                	jae    80186f <devfile_write+0x8f>
  80184b:	c7 44 24 0c fd 2c 80 	movl   $0x802cfd,0xc(%esp)
  801852:	00 
  801853:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  80185a:	00 
  80185b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801862:	00 
  801863:	c7 04 24 19 2d 80 00 	movl   $0x802d19,(%esp)
  80186a:	e8 d2 e8 ff ff       	call   800141 <_panic>
	assert(r <= PGSIZE);
  80186f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801874:	7e 24                	jle    80189a <devfile_write+0xba>
  801876:	c7 44 24 0c 24 2d 80 	movl   $0x802d24,0xc(%esp)
  80187d:	00 
  80187e:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  801885:	00 
  801886:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  80188d:	00 
  80188e:	c7 04 24 19 2d 80 00 	movl   $0x802d19,(%esp)
  801895:	e8 a7 e8 ff ff       	call   800141 <_panic>
	return r;
}
  80189a:	83 c4 14             	add    $0x14,%esp
  80189d:	5b                   	pop    %ebx
  80189e:	5d                   	pop    %ebp
  80189f:	c3                   	ret    

008018a0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	56                   	push   %esi
  8018a4:	53                   	push   %ebx
  8018a5:	83 ec 10             	sub    $0x10,%esp
  8018a8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018b6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c1:	b8 03 00 00 00       	mov    $0x3,%eax
  8018c6:	e8 08 fe ff ff       	call   8016d3 <fsipc>
  8018cb:	89 c3                	mov    %eax,%ebx
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	78 6a                	js     80193b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018d1:	39 c6                	cmp    %eax,%esi
  8018d3:	73 24                	jae    8018f9 <devfile_read+0x59>
  8018d5:	c7 44 24 0c fd 2c 80 	movl   $0x802cfd,0xc(%esp)
  8018dc:	00 
  8018dd:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  8018e4:	00 
  8018e5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8018ec:	00 
  8018ed:	c7 04 24 19 2d 80 00 	movl   $0x802d19,(%esp)
  8018f4:	e8 48 e8 ff ff       	call   800141 <_panic>
	assert(r <= PGSIZE);
  8018f9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018fe:	7e 24                	jle    801924 <devfile_read+0x84>
  801900:	c7 44 24 0c 24 2d 80 	movl   $0x802d24,0xc(%esp)
  801907:	00 
  801908:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  80190f:	00 
  801910:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801917:	00 
  801918:	c7 04 24 19 2d 80 00 	movl   $0x802d19,(%esp)
  80191f:	e8 1d e8 ff ff       	call   800141 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801924:	89 44 24 08          	mov    %eax,0x8(%esp)
  801928:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80192f:	00 
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	89 04 24             	mov    %eax,(%esp)
  801936:	e8 19 f1 ff ff       	call   800a54 <memmove>
	return r;
}
  80193b:	89 d8                	mov    %ebx,%eax
  80193d:	83 c4 10             	add    $0x10,%esp
  801940:	5b                   	pop    %ebx
  801941:	5e                   	pop    %esi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    

00801944 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	53                   	push   %ebx
  801948:	83 ec 24             	sub    $0x24,%esp
  80194b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80194e:	89 1c 24             	mov    %ebx,(%esp)
  801951:	e8 2a ef ff ff       	call   800880 <strlen>
  801956:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80195b:	7f 60                	jg     8019bd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80195d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801960:	89 04 24             	mov    %eax,(%esp)
  801963:	e8 af f7 ff ff       	call   801117 <fd_alloc>
  801968:	89 c2                	mov    %eax,%edx
  80196a:	85 d2                	test   %edx,%edx
  80196c:	78 54                	js     8019c2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80196e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801972:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801979:	e8 39 ef ff ff       	call   8008b7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801989:	b8 01 00 00 00       	mov    $0x1,%eax
  80198e:	e8 40 fd ff ff       	call   8016d3 <fsipc>
  801993:	89 c3                	mov    %eax,%ebx
  801995:	85 c0                	test   %eax,%eax
  801997:	79 17                	jns    8019b0 <open+0x6c>
		fd_close(fd, 0);
  801999:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019a0:	00 
  8019a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a4:	89 04 24             	mov    %eax,(%esp)
  8019a7:	e8 6a f8 ff ff       	call   801216 <fd_close>
		return r;
  8019ac:	89 d8                	mov    %ebx,%eax
  8019ae:	eb 12                	jmp    8019c2 <open+0x7e>
	}

	return fd2num(fd);
  8019b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b3:	89 04 24             	mov    %eax,(%esp)
  8019b6:	e8 35 f7 ff ff       	call   8010f0 <fd2num>
  8019bb:	eb 05                	jmp    8019c2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8019bd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8019c2:	83 c4 24             	add    $0x24,%esp
  8019c5:	5b                   	pop    %ebx
  8019c6:	5d                   	pop    %ebp
  8019c7:	c3                   	ret    

008019c8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d8:	e8 f6 fc ff ff       	call   8016d3 <fsipc>
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <evict>:

int evict(void)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  8019e5:	c7 04 24 30 2d 80 00 	movl   $0x802d30,(%esp)
  8019ec:	e8 49 e8 ff ff       	call   80023a <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  8019f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f6:	b8 09 00 00 00       	mov    $0x9,%eax
  8019fb:	e8 d3 fc ff ff       	call   8016d3 <fsipc>
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    
  801a02:	66 90                	xchg   %ax,%ax
  801a04:	66 90                	xchg   %ax,%ax
  801a06:	66 90                	xchg   %ax,%ax
  801a08:	66 90                	xchg   %ax,%ax
  801a0a:	66 90                	xchg   %ax,%ax
  801a0c:	66 90                	xchg   %ax,%ax
  801a0e:	66 90                	xchg   %ax,%ax

00801a10 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801a16:	c7 44 24 04 49 2d 80 	movl   $0x802d49,0x4(%esp)
  801a1d:	00 
  801a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a21:	89 04 24             	mov    %eax,(%esp)
  801a24:	e8 8e ee ff ff       	call   8008b7 <strcpy>
	return 0;
}
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	53                   	push   %ebx
  801a34:	83 ec 14             	sub    $0x14,%esp
  801a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a3a:	89 1c 24             	mov    %ebx,(%esp)
  801a3d:	e8 15 0b 00 00       	call   802557 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801a42:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801a47:	83 f8 01             	cmp    $0x1,%eax
  801a4a:	75 0d                	jne    801a59 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801a4c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801a4f:	89 04 24             	mov    %eax,(%esp)
  801a52:	e8 29 03 00 00       	call   801d80 <nsipc_close>
  801a57:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801a59:	89 d0                	mov    %edx,%eax
  801a5b:	83 c4 14             	add    $0x14,%esp
  801a5e:	5b                   	pop    %ebx
  801a5f:	5d                   	pop    %ebp
  801a60:	c3                   	ret    

00801a61 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a67:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a6e:	00 
  801a6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a72:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	8b 40 0c             	mov    0xc(%eax),%eax
  801a83:	89 04 24             	mov    %eax,(%esp)
  801a86:	e8 f0 03 00 00       	call   801e7b <nsipc_send>
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a93:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a9a:	00 
  801a9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	8b 40 0c             	mov    0xc(%eax),%eax
  801aaf:	89 04 24             	mov    %eax,(%esp)
  801ab2:	e8 44 03 00 00       	call   801dfb <nsipc_recv>
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801abf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ac2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ac6:	89 04 24             	mov    %eax,(%esp)
  801ac9:	e8 98 f6 ff ff       	call   801166 <fd_lookup>
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 17                	js     801ae9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801adb:	39 08                	cmp    %ecx,(%eax)
  801add:	75 05                	jne    801ae4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801adf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae2:	eb 05                	jmp    801ae9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ae4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	83 ec 20             	sub    $0x20,%esp
  801af3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801af5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af8:	89 04 24             	mov    %eax,(%esp)
  801afb:	e8 17 f6 ff ff       	call   801117 <fd_alloc>
  801b00:	89 c3                	mov    %eax,%ebx
  801b02:	85 c0                	test   %eax,%eax
  801b04:	78 21                	js     801b27 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b06:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b0d:	00 
  801b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1c:	e8 04 f2 ff ff       	call   800d25 <sys_page_alloc>
  801b21:	89 c3                	mov    %eax,%ebx
  801b23:	85 c0                	test   %eax,%eax
  801b25:	79 0c                	jns    801b33 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801b27:	89 34 24             	mov    %esi,(%esp)
  801b2a:	e8 51 02 00 00       	call   801d80 <nsipc_close>
		return r;
  801b2f:	89 d8                	mov    %ebx,%eax
  801b31:	eb 20                	jmp    801b53 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801b33:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b41:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801b48:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801b4b:	89 14 24             	mov    %edx,(%esp)
  801b4e:	e8 9d f5 ff ff       	call   8010f0 <fd2num>
}
  801b53:	83 c4 20             	add    $0x20,%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5e                   	pop    %esi
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    

00801b5a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	e8 51 ff ff ff       	call   801ab9 <fd2sockid>
		return r;
  801b68:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 23                	js     801b91 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b6e:	8b 55 10             	mov    0x10(%ebp),%edx
  801b71:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b78:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b7c:	89 04 24             	mov    %eax,(%esp)
  801b7f:	e8 45 01 00 00       	call   801cc9 <nsipc_accept>
		return r;
  801b84:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b86:	85 c0                	test   %eax,%eax
  801b88:	78 07                	js     801b91 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801b8a:	e8 5c ff ff ff       	call   801aeb <alloc_sockfd>
  801b8f:	89 c1                	mov    %eax,%ecx
}
  801b91:	89 c8                	mov    %ecx,%eax
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	e8 16 ff ff ff       	call   801ab9 <fd2sockid>
  801ba3:	89 c2                	mov    %eax,%edx
  801ba5:	85 d2                	test   %edx,%edx
  801ba7:	78 16                	js     801bbf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bac:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb7:	89 14 24             	mov    %edx,(%esp)
  801bba:	e8 60 01 00 00       	call   801d1f <nsipc_bind>
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <shutdown>:

int
shutdown(int s, int how)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	e8 ea fe ff ff       	call   801ab9 <fd2sockid>
  801bcf:	89 c2                	mov    %eax,%edx
  801bd1:	85 d2                	test   %edx,%edx
  801bd3:	78 0f                	js     801be4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdc:	89 14 24             	mov    %edx,(%esp)
  801bdf:	e8 7a 01 00 00       	call   801d5e <nsipc_shutdown>
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	e8 c5 fe ff ff       	call   801ab9 <fd2sockid>
  801bf4:	89 c2                	mov    %eax,%edx
  801bf6:	85 d2                	test   %edx,%edx
  801bf8:	78 16                	js     801c10 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801bfa:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c08:	89 14 24             	mov    %edx,(%esp)
  801c0b:	e8 8a 01 00 00       	call   801d9a <nsipc_connect>
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <listen>:

int
listen(int s, int backlog)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	e8 99 fe ff ff       	call   801ab9 <fd2sockid>
  801c20:	89 c2                	mov    %eax,%edx
  801c22:	85 d2                	test   %edx,%edx
  801c24:	78 0f                	js     801c35 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2d:	89 14 24             	mov    %edx,(%esp)
  801c30:	e8 a4 01 00 00       	call   801dd9 <nsipc_listen>
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c40:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	89 04 24             	mov    %eax,(%esp)
  801c51:	e8 98 02 00 00       	call   801eee <nsipc_socket>
  801c56:	89 c2                	mov    %eax,%edx
  801c58:	85 d2                	test   %edx,%edx
  801c5a:	78 05                	js     801c61 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801c5c:	e8 8a fe ff ff       	call   801aeb <alloc_sockfd>
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	53                   	push   %ebx
  801c67:	83 ec 14             	sub    $0x14,%esp
  801c6a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c6c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c73:	75 11                	jne    801c86 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c75:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801c7c:	e8 9e 08 00 00       	call   80251f <ipc_find_env>
  801c81:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c86:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c8d:	00 
  801c8e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c95:	00 
  801c96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c9a:	a1 04 40 80 00       	mov    0x804004,%eax
  801c9f:	89 04 24             	mov    %eax,(%esp)
  801ca2:	e8 11 08 00 00       	call   8024b8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ca7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cae:	00 
  801caf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cb6:	00 
  801cb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cbe:	e8 8d 07 00 00       	call   802450 <ipc_recv>
}
  801cc3:	83 c4 14             	add    $0x14,%esp
  801cc6:	5b                   	pop    %ebx
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    

00801cc9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	56                   	push   %esi
  801ccd:	53                   	push   %ebx
  801cce:	83 ec 10             	sub    $0x10,%esp
  801cd1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cdc:	8b 06                	mov    (%esi),%eax
  801cde:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ce3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce8:	e8 76 ff ff ff       	call   801c63 <nsipc>
  801ced:	89 c3                	mov    %eax,%ebx
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	78 23                	js     801d16 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cf3:	a1 10 60 80 00       	mov    0x806010,%eax
  801cf8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cfc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d03:	00 
  801d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d07:	89 04 24             	mov    %eax,(%esp)
  801d0a:	e8 45 ed ff ff       	call   800a54 <memmove>
		*addrlen = ret->ret_addrlen;
  801d0f:	a1 10 60 80 00       	mov    0x806010,%eax
  801d14:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801d16:	89 d8                	mov    %ebx,%eax
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	5b                   	pop    %ebx
  801d1c:	5e                   	pop    %esi
  801d1d:	5d                   	pop    %ebp
  801d1e:	c3                   	ret    

00801d1f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	53                   	push   %ebx
  801d23:	83 ec 14             	sub    $0x14,%esp
  801d26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d31:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d43:	e8 0c ed ff ff       	call   800a54 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d48:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d4e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d53:	e8 0b ff ff ff       	call   801c63 <nsipc>
}
  801d58:	83 c4 14             	add    $0x14,%esp
  801d5b:	5b                   	pop    %ebx
  801d5c:	5d                   	pop    %ebp
  801d5d:	c3                   	ret    

00801d5e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d74:	b8 03 00 00 00       	mov    $0x3,%eax
  801d79:	e8 e5 fe ff ff       	call   801c63 <nsipc>
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <nsipc_close>:

int
nsipc_close(int s)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d8e:	b8 04 00 00 00       	mov    $0x4,%eax
  801d93:	e8 cb fe ff ff       	call   801c63 <nsipc>
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	53                   	push   %ebx
  801d9e:	83 ec 14             	sub    $0x14,%esp
  801da1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801dac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801dbe:	e8 91 ec ff ff       	call   800a54 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dc3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801dc9:	b8 05 00 00 00       	mov    $0x5,%eax
  801dce:	e8 90 fe ff ff       	call   801c63 <nsipc>
}
  801dd3:	83 c4 14             	add    $0x14,%esp
  801dd6:	5b                   	pop    %ebx
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    

00801dd9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dea:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801def:	b8 06 00 00 00       	mov    $0x6,%eax
  801df4:	e8 6a fe ff ff       	call   801c63 <nsipc>
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	56                   	push   %esi
  801dff:	53                   	push   %ebx
  801e00:	83 ec 10             	sub    $0x10,%esp
  801e03:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e0e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e14:	8b 45 14             	mov    0x14(%ebp),%eax
  801e17:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e1c:	b8 07 00 00 00       	mov    $0x7,%eax
  801e21:	e8 3d fe ff ff       	call   801c63 <nsipc>
  801e26:	89 c3                	mov    %eax,%ebx
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	78 46                	js     801e72 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801e2c:	39 f0                	cmp    %esi,%eax
  801e2e:	7f 07                	jg     801e37 <nsipc_recv+0x3c>
  801e30:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e35:	7e 24                	jle    801e5b <nsipc_recv+0x60>
  801e37:	c7 44 24 0c 55 2d 80 	movl   $0x802d55,0xc(%esp)
  801e3e:	00 
  801e3f:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  801e46:	00 
  801e47:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801e4e:	00 
  801e4f:	c7 04 24 6a 2d 80 00 	movl   $0x802d6a,(%esp)
  801e56:	e8 e6 e2 ff ff       	call   800141 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e5f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e66:	00 
  801e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6a:	89 04 24             	mov    %eax,(%esp)
  801e6d:	e8 e2 eb ff ff       	call   800a54 <memmove>
	}

	return r;
}
  801e72:	89 d8                	mov    %ebx,%eax
  801e74:	83 c4 10             	add    $0x10,%esp
  801e77:	5b                   	pop    %ebx
  801e78:	5e                   	pop    %esi
  801e79:	5d                   	pop    %ebp
  801e7a:	c3                   	ret    

00801e7b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	53                   	push   %ebx
  801e7f:	83 ec 14             	sub    $0x14,%esp
  801e82:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e8d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e93:	7e 24                	jle    801eb9 <nsipc_send+0x3e>
  801e95:	c7 44 24 0c 76 2d 80 	movl   $0x802d76,0xc(%esp)
  801e9c:	00 
  801e9d:	c7 44 24 08 04 2d 80 	movl   $0x802d04,0x8(%esp)
  801ea4:	00 
  801ea5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801eac:	00 
  801ead:	c7 04 24 6a 2d 80 00 	movl   $0x802d6a,(%esp)
  801eb4:	e8 88 e2 ff ff       	call   800141 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801eb9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801ecb:	e8 84 eb ff ff       	call   800a54 <memmove>
	nsipcbuf.send.req_size = size;
  801ed0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ede:	b8 08 00 00 00       	mov    $0x8,%eax
  801ee3:	e8 7b fd ff ff       	call   801c63 <nsipc>
}
  801ee8:	83 c4 14             	add    $0x14,%esp
  801eeb:	5b                   	pop    %ebx
  801eec:	5d                   	pop    %ebp
  801eed:	c3                   	ret    

00801eee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eff:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f04:	8b 45 10             	mov    0x10(%ebp),%eax
  801f07:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f0c:	b8 09 00 00 00       	mov    $0x9,%eax
  801f11:	e8 4d fd ff ff       	call   801c63 <nsipc>
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	56                   	push   %esi
  801f1c:	53                   	push   %ebx
  801f1d:	83 ec 10             	sub    $0x10,%esp
  801f20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	89 04 24             	mov    %eax,(%esp)
  801f29:	e8 d2 f1 ff ff       	call   801100 <fd2data>
  801f2e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f30:	c7 44 24 04 82 2d 80 	movl   $0x802d82,0x4(%esp)
  801f37:	00 
  801f38:	89 1c 24             	mov    %ebx,(%esp)
  801f3b:	e8 77 e9 ff ff       	call   8008b7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f40:	8b 46 04             	mov    0x4(%esi),%eax
  801f43:	2b 06                	sub    (%esi),%eax
  801f45:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f4b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f52:	00 00 00 
	stat->st_dev = &devpipe;
  801f55:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f5c:	30 80 00 
	return 0;
}
  801f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    

00801f6b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	53                   	push   %ebx
  801f6f:	83 ec 14             	sub    $0x14,%esp
  801f72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f75:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f80:	e8 47 ee ff ff       	call   800dcc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f85:	89 1c 24             	mov    %ebx,(%esp)
  801f88:	e8 73 f1 ff ff       	call   801100 <fd2data>
  801f8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f98:	e8 2f ee ff ff       	call   800dcc <sys_page_unmap>
}
  801f9d:	83 c4 14             	add    $0x14,%esp
  801fa0:	5b                   	pop    %ebx
  801fa1:	5d                   	pop    %ebp
  801fa2:	c3                   	ret    

00801fa3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	57                   	push   %edi
  801fa7:	56                   	push   %esi
  801fa8:	53                   	push   %ebx
  801fa9:	83 ec 2c             	sub    $0x2c,%esp
  801fac:	89 c6                	mov    %eax,%esi
  801fae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801fb1:	a1 08 40 80 00       	mov    0x804008,%eax
  801fb6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fb9:	89 34 24             	mov    %esi,(%esp)
  801fbc:	e8 96 05 00 00       	call   802557 <pageref>
  801fc1:	89 c7                	mov    %eax,%edi
  801fc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc6:	89 04 24             	mov    %eax,(%esp)
  801fc9:	e8 89 05 00 00       	call   802557 <pageref>
  801fce:	39 c7                	cmp    %eax,%edi
  801fd0:	0f 94 c2             	sete   %dl
  801fd3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801fd6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801fdc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801fdf:	39 fb                	cmp    %edi,%ebx
  801fe1:	74 21                	je     802004 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801fe3:	84 d2                	test   %dl,%dl
  801fe5:	74 ca                	je     801fb1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fe7:	8b 51 58             	mov    0x58(%ecx),%edx
  801fea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fee:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ff2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ff6:	c7 04 24 89 2d 80 00 	movl   $0x802d89,(%esp)
  801ffd:	e8 38 e2 ff ff       	call   80023a <cprintf>
  802002:	eb ad                	jmp    801fb1 <_pipeisclosed+0xe>
	}
}
  802004:	83 c4 2c             	add    $0x2c,%esp
  802007:	5b                   	pop    %ebx
  802008:	5e                   	pop    %esi
  802009:	5f                   	pop    %edi
  80200a:	5d                   	pop    %ebp
  80200b:	c3                   	ret    

0080200c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	57                   	push   %edi
  802010:	56                   	push   %esi
  802011:	53                   	push   %ebx
  802012:	83 ec 1c             	sub    $0x1c,%esp
  802015:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802018:	89 34 24             	mov    %esi,(%esp)
  80201b:	e8 e0 f0 ff ff       	call   801100 <fd2data>
  802020:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802022:	bf 00 00 00 00       	mov    $0x0,%edi
  802027:	eb 45                	jmp    80206e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802029:	89 da                	mov    %ebx,%edx
  80202b:	89 f0                	mov    %esi,%eax
  80202d:	e8 71 ff ff ff       	call   801fa3 <_pipeisclosed>
  802032:	85 c0                	test   %eax,%eax
  802034:	75 41                	jne    802077 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802036:	e8 cb ec ff ff       	call   800d06 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80203b:	8b 43 04             	mov    0x4(%ebx),%eax
  80203e:	8b 0b                	mov    (%ebx),%ecx
  802040:	8d 51 20             	lea    0x20(%ecx),%edx
  802043:	39 d0                	cmp    %edx,%eax
  802045:	73 e2                	jae    802029 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802047:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80204a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80204e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802051:	99                   	cltd   
  802052:	c1 ea 1b             	shr    $0x1b,%edx
  802055:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802058:	83 e1 1f             	and    $0x1f,%ecx
  80205b:	29 d1                	sub    %edx,%ecx
  80205d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802061:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802065:	83 c0 01             	add    $0x1,%eax
  802068:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80206b:	83 c7 01             	add    $0x1,%edi
  80206e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802071:	75 c8                	jne    80203b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802073:	89 f8                	mov    %edi,%eax
  802075:	eb 05                	jmp    80207c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80207c:	83 c4 1c             	add    $0x1c,%esp
  80207f:	5b                   	pop    %ebx
  802080:	5e                   	pop    %esi
  802081:	5f                   	pop    %edi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    

00802084 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	57                   	push   %edi
  802088:	56                   	push   %esi
  802089:	53                   	push   %ebx
  80208a:	83 ec 1c             	sub    $0x1c,%esp
  80208d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802090:	89 3c 24             	mov    %edi,(%esp)
  802093:	e8 68 f0 ff ff       	call   801100 <fd2data>
  802098:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80209a:	be 00 00 00 00       	mov    $0x0,%esi
  80209f:	eb 3d                	jmp    8020de <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8020a1:	85 f6                	test   %esi,%esi
  8020a3:	74 04                	je     8020a9 <devpipe_read+0x25>
				return i;
  8020a5:	89 f0                	mov    %esi,%eax
  8020a7:	eb 43                	jmp    8020ec <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8020a9:	89 da                	mov    %ebx,%edx
  8020ab:	89 f8                	mov    %edi,%eax
  8020ad:	e8 f1 fe ff ff       	call   801fa3 <_pipeisclosed>
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	75 31                	jne    8020e7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8020b6:	e8 4b ec ff ff       	call   800d06 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8020bb:	8b 03                	mov    (%ebx),%eax
  8020bd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020c0:	74 df                	je     8020a1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020c2:	99                   	cltd   
  8020c3:	c1 ea 1b             	shr    $0x1b,%edx
  8020c6:	01 d0                	add    %edx,%eax
  8020c8:	83 e0 1f             	and    $0x1f,%eax
  8020cb:	29 d0                	sub    %edx,%eax
  8020cd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020d5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020d8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020db:	83 c6 01             	add    $0x1,%esi
  8020de:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020e1:	75 d8                	jne    8020bb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020e3:	89 f0                	mov    %esi,%eax
  8020e5:	eb 05                	jmp    8020ec <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8020ec:	83 c4 1c             	add    $0x1c,%esp
  8020ef:	5b                   	pop    %ebx
  8020f0:	5e                   	pop    %esi
  8020f1:	5f                   	pop    %edi
  8020f2:	5d                   	pop    %ebp
  8020f3:	c3                   	ret    

008020f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	56                   	push   %esi
  8020f8:	53                   	push   %ebx
  8020f9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ff:	89 04 24             	mov    %eax,(%esp)
  802102:	e8 10 f0 ff ff       	call   801117 <fd_alloc>
  802107:	89 c2                	mov    %eax,%edx
  802109:	85 d2                	test   %edx,%edx
  80210b:	0f 88 4d 01 00 00    	js     80225e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802111:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802118:	00 
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802120:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802127:	e8 f9 eb ff ff       	call   800d25 <sys_page_alloc>
  80212c:	89 c2                	mov    %eax,%edx
  80212e:	85 d2                	test   %edx,%edx
  802130:	0f 88 28 01 00 00    	js     80225e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802136:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802139:	89 04 24             	mov    %eax,(%esp)
  80213c:	e8 d6 ef ff ff       	call   801117 <fd_alloc>
  802141:	89 c3                	mov    %eax,%ebx
  802143:	85 c0                	test   %eax,%eax
  802145:	0f 88 fe 00 00 00    	js     802249 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80214b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802152:	00 
  802153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802156:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802161:	e8 bf eb ff ff       	call   800d25 <sys_page_alloc>
  802166:	89 c3                	mov    %eax,%ebx
  802168:	85 c0                	test   %eax,%eax
  80216a:	0f 88 d9 00 00 00    	js     802249 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	89 04 24             	mov    %eax,(%esp)
  802176:	e8 85 ef ff ff       	call   801100 <fd2data>
  80217b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80217d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802184:	00 
  802185:	89 44 24 04          	mov    %eax,0x4(%esp)
  802189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802190:	e8 90 eb ff ff       	call   800d25 <sys_page_alloc>
  802195:	89 c3                	mov    %eax,%ebx
  802197:	85 c0                	test   %eax,%eax
  802199:	0f 88 97 00 00 00    	js     802236 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80219f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a2:	89 04 24             	mov    %eax,(%esp)
  8021a5:	e8 56 ef ff ff       	call   801100 <fd2data>
  8021aa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8021b1:	00 
  8021b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021bd:	00 
  8021be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021c9:	e8 ab eb ff ff       	call   800d79 <sys_page_map>
  8021ce:	89 c3                	mov    %eax,%ebx
  8021d0:	85 c0                	test   %eax,%eax
  8021d2:	78 52                	js     802226 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021d4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8021e9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8021fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802201:	89 04 24             	mov    %eax,(%esp)
  802204:	e8 e7 ee ff ff       	call   8010f0 <fd2num>
  802209:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80220c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80220e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802211:	89 04 24             	mov    %eax,(%esp)
  802214:	e8 d7 ee ff ff       	call   8010f0 <fd2num>
  802219:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80221c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
  802224:	eb 38                	jmp    80225e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802226:	89 74 24 04          	mov    %esi,0x4(%esp)
  80222a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802231:	e8 96 eb ff ff       	call   800dcc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802239:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802244:	e8 83 eb ff ff       	call   800dcc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802250:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802257:	e8 70 eb ff ff       	call   800dcc <sys_page_unmap>
  80225c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80225e:	83 c4 30             	add    $0x30,%esp
  802261:	5b                   	pop    %ebx
  802262:	5e                   	pop    %esi
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    

00802265 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80226b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80226e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	89 04 24             	mov    %eax,(%esp)
  802278:	e8 e9 ee ff ff       	call   801166 <fd_lookup>
  80227d:	89 c2                	mov    %eax,%edx
  80227f:	85 d2                	test   %edx,%edx
  802281:	78 15                	js     802298 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	89 04 24             	mov    %eax,(%esp)
  802289:	e8 72 ee ff ff       	call   801100 <fd2data>
	return _pipeisclosed(fd, p);
  80228e:	89 c2                	mov    %eax,%edx
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	e8 0b fd ff ff       	call   801fa3 <_pipeisclosed>
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    
  80229a:	66 90                	xchg   %ax,%ax
  80229c:	66 90                	xchg   %ax,%ax
  80229e:	66 90                	xchg   %ax,%ax

008022a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a8:	5d                   	pop    %ebp
  8022a9:	c3                   	ret    

008022aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8022b0:	c7 44 24 04 a1 2d 80 	movl   $0x802da1,0x4(%esp)
  8022b7:	00 
  8022b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bb:	89 04 24             	mov    %eax,(%esp)
  8022be:	e8 f4 e5 ff ff       	call   8008b7 <strcpy>
	return 0;
}
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	57                   	push   %edi
  8022ce:	56                   	push   %esi
  8022cf:	53                   	push   %ebx
  8022d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022e1:	eb 31                	jmp    802314 <devcons_write+0x4a>
		m = n - tot;
  8022e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8022e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8022e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8022f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022f7:	03 45 0c             	add    0xc(%ebp),%eax
  8022fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fe:	89 3c 24             	mov    %edi,(%esp)
  802301:	e8 4e e7 ff ff       	call   800a54 <memmove>
		sys_cputs(buf, m);
  802306:	89 74 24 04          	mov    %esi,0x4(%esp)
  80230a:	89 3c 24             	mov    %edi,(%esp)
  80230d:	e8 f4 e8 ff ff       	call   800c06 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802312:	01 f3                	add    %esi,%ebx
  802314:	89 d8                	mov    %ebx,%eax
  802316:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802319:	72 c8                	jb     8022e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80231b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802321:	5b                   	pop    %ebx
  802322:	5e                   	pop    %esi
  802323:	5f                   	pop    %edi
  802324:	5d                   	pop    %ebp
  802325:	c3                   	ret    

00802326 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80232c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802331:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802335:	75 07                	jne    80233e <devcons_read+0x18>
  802337:	eb 2a                	jmp    802363 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802339:	e8 c8 e9 ff ff       	call   800d06 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80233e:	66 90                	xchg   %ax,%ax
  802340:	e8 df e8 ff ff       	call   800c24 <sys_cgetc>
  802345:	85 c0                	test   %eax,%eax
  802347:	74 f0                	je     802339 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802349:	85 c0                	test   %eax,%eax
  80234b:	78 16                	js     802363 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80234d:	83 f8 04             	cmp    $0x4,%eax
  802350:	74 0c                	je     80235e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802352:	8b 55 0c             	mov    0xc(%ebp),%edx
  802355:	88 02                	mov    %al,(%edx)
	return 1;
  802357:	b8 01 00 00 00       	mov    $0x1,%eax
  80235c:	eb 05                	jmp    802363 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802371:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802378:	00 
  802379:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80237c:	89 04 24             	mov    %eax,(%esp)
  80237f:	e8 82 e8 ff ff       	call   800c06 <sys_cputs>
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <getchar>:

int
getchar(void)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80238c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802393:	00 
  802394:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802397:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023a2:	e8 53 f0 ff ff       	call   8013fa <read>
	if (r < 0)
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	78 0f                	js     8023ba <getchar+0x34>
		return r;
	if (r < 1)
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	7e 06                	jle    8023b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8023af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8023b3:	eb 05                	jmp    8023ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8023b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	89 04 24             	mov    %eax,(%esp)
  8023cf:	e8 92 ed ff ff       	call   801166 <fd_lookup>
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	78 11                	js     8023e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023e1:	39 10                	cmp    %edx,(%eax)
  8023e3:	0f 94 c0             	sete   %al
  8023e6:	0f b6 c0             	movzbl %al,%eax
}
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <opencons>:

int
opencons(void)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f4:	89 04 24             	mov    %eax,(%esp)
  8023f7:	e8 1b ed ff ff       	call   801117 <fd_alloc>
		return r;
  8023fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023fe:	85 c0                	test   %eax,%eax
  802400:	78 40                	js     802442 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802402:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802409:	00 
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802411:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802418:	e8 08 e9 ff ff       	call   800d25 <sys_page_alloc>
		return r;
  80241d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80241f:	85 c0                	test   %eax,%eax
  802421:	78 1f                	js     802442 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802423:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802438:	89 04 24             	mov    %eax,(%esp)
  80243b:	e8 b0 ec ff ff       	call   8010f0 <fd2num>
  802440:	89 c2                	mov    %eax,%edx
}
  802442:	89 d0                	mov    %edx,%eax
  802444:	c9                   	leave  
  802445:	c3                   	ret    
  802446:	66 90                	xchg   %ax,%ax
  802448:	66 90                	xchg   %ax,%ax
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	66 90                	xchg   %ax,%ax
  80244e:	66 90                	xchg   %ax,%ax

00802450 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	56                   	push   %esi
  802454:	53                   	push   %ebx
  802455:	83 ec 10             	sub    $0x10,%esp
  802458:	8b 75 08             	mov    0x8(%ebp),%esi
  80245b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802461:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802463:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802468:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80246b:	89 04 24             	mov    %eax,(%esp)
  80246e:	e8 e8 ea ff ff       	call   800f5b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802473:	85 c0                	test   %eax,%eax
  802475:	75 26                	jne    80249d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802477:	85 f6                	test   %esi,%esi
  802479:	74 0a                	je     802485 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80247b:	a1 08 40 80 00       	mov    0x804008,%eax
  802480:	8b 40 74             	mov    0x74(%eax),%eax
  802483:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802485:	85 db                	test   %ebx,%ebx
  802487:	74 0a                	je     802493 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802489:	a1 08 40 80 00       	mov    0x804008,%eax
  80248e:	8b 40 78             	mov    0x78(%eax),%eax
  802491:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802493:	a1 08 40 80 00       	mov    0x804008,%eax
  802498:	8b 40 70             	mov    0x70(%eax),%eax
  80249b:	eb 14                	jmp    8024b1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80249d:	85 f6                	test   %esi,%esi
  80249f:	74 06                	je     8024a7 <ipc_recv+0x57>
			*from_env_store = 0;
  8024a1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8024a7:	85 db                	test   %ebx,%ebx
  8024a9:	74 06                	je     8024b1 <ipc_recv+0x61>
			*perm_store = 0;
  8024ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  8024b1:	83 c4 10             	add    $0x10,%esp
  8024b4:	5b                   	pop    %ebx
  8024b5:	5e                   	pop    %esi
  8024b6:	5d                   	pop    %ebp
  8024b7:	c3                   	ret    

008024b8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024b8:	55                   	push   %ebp
  8024b9:	89 e5                	mov    %esp,%ebp
  8024bb:	57                   	push   %edi
  8024bc:	56                   	push   %esi
  8024bd:	53                   	push   %ebx
  8024be:	83 ec 1c             	sub    $0x1c,%esp
  8024c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024c4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024c7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  8024ca:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  8024cc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8024d1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8024d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8024d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024e3:	89 3c 24             	mov    %edi,(%esp)
  8024e6:	e8 4d ea ff ff       	call   800f38 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	74 28                	je     802517 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  8024ef:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024f2:	74 1c                	je     802510 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  8024f4:	c7 44 24 08 b0 2d 80 	movl   $0x802db0,0x8(%esp)
  8024fb:	00 
  8024fc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802503:	00 
  802504:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  80250b:	e8 31 dc ff ff       	call   800141 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802510:	e8 f1 e7 ff ff       	call   800d06 <sys_yield>
	}
  802515:	eb bd                	jmp    8024d4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802517:	83 c4 1c             	add    $0x1c,%esp
  80251a:	5b                   	pop    %ebx
  80251b:	5e                   	pop    %esi
  80251c:	5f                   	pop    %edi
  80251d:	5d                   	pop    %ebp
  80251e:	c3                   	ret    

0080251f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80251f:	55                   	push   %ebp
  802520:	89 e5                	mov    %esp,%ebp
  802522:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802525:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80252a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80252d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802533:	8b 52 50             	mov    0x50(%edx),%edx
  802536:	39 ca                	cmp    %ecx,%edx
  802538:	75 0d                	jne    802547 <ipc_find_env+0x28>
			return envs[i].env_id;
  80253a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80253d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802542:	8b 40 40             	mov    0x40(%eax),%eax
  802545:	eb 0e                	jmp    802555 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802547:	83 c0 01             	add    $0x1,%eax
  80254a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80254f:	75 d9                	jne    80252a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802551:	66 b8 00 00          	mov    $0x0,%ax
}
  802555:	5d                   	pop    %ebp
  802556:	c3                   	ret    

00802557 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
  80255a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80255d:	89 d0                	mov    %edx,%eax
  80255f:	c1 e8 16             	shr    $0x16,%eax
  802562:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802569:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80256e:	f6 c1 01             	test   $0x1,%cl
  802571:	74 1d                	je     802590 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802573:	c1 ea 0c             	shr    $0xc,%edx
  802576:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80257d:	f6 c2 01             	test   $0x1,%dl
  802580:	74 0e                	je     802590 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802582:	c1 ea 0c             	shr    $0xc,%edx
  802585:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80258c:	ef 
  80258d:	0f b7 c0             	movzwl %ax,%eax
}
  802590:	5d                   	pop    %ebp
  802591:	c3                   	ret    
  802592:	66 90                	xchg   %ax,%ax
  802594:	66 90                	xchg   %ax,%ax
  802596:	66 90                	xchg   %ax,%ax
  802598:	66 90                	xchg   %ax,%ax
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	66 90                	xchg   %ax,%ax
  80259e:	66 90                	xchg   %ax,%ax

008025a0 <__udivdi3>:
  8025a0:	55                   	push   %ebp
  8025a1:	57                   	push   %edi
  8025a2:	56                   	push   %esi
  8025a3:	83 ec 0c             	sub    $0xc,%esp
  8025a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025aa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8025ae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8025b2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025bc:	89 ea                	mov    %ebp,%edx
  8025be:	89 0c 24             	mov    %ecx,(%esp)
  8025c1:	75 2d                	jne    8025f0 <__udivdi3+0x50>
  8025c3:	39 e9                	cmp    %ebp,%ecx
  8025c5:	77 61                	ja     802628 <__udivdi3+0x88>
  8025c7:	85 c9                	test   %ecx,%ecx
  8025c9:	89 ce                	mov    %ecx,%esi
  8025cb:	75 0b                	jne    8025d8 <__udivdi3+0x38>
  8025cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d2:	31 d2                	xor    %edx,%edx
  8025d4:	f7 f1                	div    %ecx
  8025d6:	89 c6                	mov    %eax,%esi
  8025d8:	31 d2                	xor    %edx,%edx
  8025da:	89 e8                	mov    %ebp,%eax
  8025dc:	f7 f6                	div    %esi
  8025de:	89 c5                	mov    %eax,%ebp
  8025e0:	89 f8                	mov    %edi,%eax
  8025e2:	f7 f6                	div    %esi
  8025e4:	89 ea                	mov    %ebp,%edx
  8025e6:	83 c4 0c             	add    $0xc,%esp
  8025e9:	5e                   	pop    %esi
  8025ea:	5f                   	pop    %edi
  8025eb:	5d                   	pop    %ebp
  8025ec:	c3                   	ret    
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	39 e8                	cmp    %ebp,%eax
  8025f2:	77 24                	ja     802618 <__udivdi3+0x78>
  8025f4:	0f bd e8             	bsr    %eax,%ebp
  8025f7:	83 f5 1f             	xor    $0x1f,%ebp
  8025fa:	75 3c                	jne    802638 <__udivdi3+0x98>
  8025fc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802600:	39 34 24             	cmp    %esi,(%esp)
  802603:	0f 86 9f 00 00 00    	jbe    8026a8 <__udivdi3+0x108>
  802609:	39 d0                	cmp    %edx,%eax
  80260b:	0f 82 97 00 00 00    	jb     8026a8 <__udivdi3+0x108>
  802611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802618:	31 d2                	xor    %edx,%edx
  80261a:	31 c0                	xor    %eax,%eax
  80261c:	83 c4 0c             	add    $0xc,%esp
  80261f:	5e                   	pop    %esi
  802620:	5f                   	pop    %edi
  802621:	5d                   	pop    %ebp
  802622:	c3                   	ret    
  802623:	90                   	nop
  802624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802628:	89 f8                	mov    %edi,%eax
  80262a:	f7 f1                	div    %ecx
  80262c:	31 d2                	xor    %edx,%edx
  80262e:	83 c4 0c             	add    $0xc,%esp
  802631:	5e                   	pop    %esi
  802632:	5f                   	pop    %edi
  802633:	5d                   	pop    %ebp
  802634:	c3                   	ret    
  802635:	8d 76 00             	lea    0x0(%esi),%esi
  802638:	89 e9                	mov    %ebp,%ecx
  80263a:	8b 3c 24             	mov    (%esp),%edi
  80263d:	d3 e0                	shl    %cl,%eax
  80263f:	89 c6                	mov    %eax,%esi
  802641:	b8 20 00 00 00       	mov    $0x20,%eax
  802646:	29 e8                	sub    %ebp,%eax
  802648:	89 c1                	mov    %eax,%ecx
  80264a:	d3 ef                	shr    %cl,%edi
  80264c:	89 e9                	mov    %ebp,%ecx
  80264e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802652:	8b 3c 24             	mov    (%esp),%edi
  802655:	09 74 24 08          	or     %esi,0x8(%esp)
  802659:	89 d6                	mov    %edx,%esi
  80265b:	d3 e7                	shl    %cl,%edi
  80265d:	89 c1                	mov    %eax,%ecx
  80265f:	89 3c 24             	mov    %edi,(%esp)
  802662:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802666:	d3 ee                	shr    %cl,%esi
  802668:	89 e9                	mov    %ebp,%ecx
  80266a:	d3 e2                	shl    %cl,%edx
  80266c:	89 c1                	mov    %eax,%ecx
  80266e:	d3 ef                	shr    %cl,%edi
  802670:	09 d7                	or     %edx,%edi
  802672:	89 f2                	mov    %esi,%edx
  802674:	89 f8                	mov    %edi,%eax
  802676:	f7 74 24 08          	divl   0x8(%esp)
  80267a:	89 d6                	mov    %edx,%esi
  80267c:	89 c7                	mov    %eax,%edi
  80267e:	f7 24 24             	mull   (%esp)
  802681:	39 d6                	cmp    %edx,%esi
  802683:	89 14 24             	mov    %edx,(%esp)
  802686:	72 30                	jb     8026b8 <__udivdi3+0x118>
  802688:	8b 54 24 04          	mov    0x4(%esp),%edx
  80268c:	89 e9                	mov    %ebp,%ecx
  80268e:	d3 e2                	shl    %cl,%edx
  802690:	39 c2                	cmp    %eax,%edx
  802692:	73 05                	jae    802699 <__udivdi3+0xf9>
  802694:	3b 34 24             	cmp    (%esp),%esi
  802697:	74 1f                	je     8026b8 <__udivdi3+0x118>
  802699:	89 f8                	mov    %edi,%eax
  80269b:	31 d2                	xor    %edx,%edx
  80269d:	e9 7a ff ff ff       	jmp    80261c <__udivdi3+0x7c>
  8026a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026a8:	31 d2                	xor    %edx,%edx
  8026aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8026af:	e9 68 ff ff ff       	jmp    80261c <__udivdi3+0x7c>
  8026b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026b8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8026bb:	31 d2                	xor    %edx,%edx
  8026bd:	83 c4 0c             	add    $0xc,%esp
  8026c0:	5e                   	pop    %esi
  8026c1:	5f                   	pop    %edi
  8026c2:	5d                   	pop    %ebp
  8026c3:	c3                   	ret    
  8026c4:	66 90                	xchg   %ax,%ax
  8026c6:	66 90                	xchg   %ax,%ax
  8026c8:	66 90                	xchg   %ax,%ax
  8026ca:	66 90                	xchg   %ax,%ax
  8026cc:	66 90                	xchg   %ax,%ax
  8026ce:	66 90                	xchg   %ax,%ax

008026d0 <__umoddi3>:
  8026d0:	55                   	push   %ebp
  8026d1:	57                   	push   %edi
  8026d2:	56                   	push   %esi
  8026d3:	83 ec 14             	sub    $0x14,%esp
  8026d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8026da:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8026de:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8026e2:	89 c7                	mov    %eax,%edi
  8026e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8026ec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8026f0:	89 34 24             	mov    %esi,(%esp)
  8026f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	89 c2                	mov    %eax,%edx
  8026fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ff:	75 17                	jne    802718 <__umoddi3+0x48>
  802701:	39 fe                	cmp    %edi,%esi
  802703:	76 4b                	jbe    802750 <__umoddi3+0x80>
  802705:	89 c8                	mov    %ecx,%eax
  802707:	89 fa                	mov    %edi,%edx
  802709:	f7 f6                	div    %esi
  80270b:	89 d0                	mov    %edx,%eax
  80270d:	31 d2                	xor    %edx,%edx
  80270f:	83 c4 14             	add    $0x14,%esp
  802712:	5e                   	pop    %esi
  802713:	5f                   	pop    %edi
  802714:	5d                   	pop    %ebp
  802715:	c3                   	ret    
  802716:	66 90                	xchg   %ax,%ax
  802718:	39 f8                	cmp    %edi,%eax
  80271a:	77 54                	ja     802770 <__umoddi3+0xa0>
  80271c:	0f bd e8             	bsr    %eax,%ebp
  80271f:	83 f5 1f             	xor    $0x1f,%ebp
  802722:	75 5c                	jne    802780 <__umoddi3+0xb0>
  802724:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802728:	39 3c 24             	cmp    %edi,(%esp)
  80272b:	0f 87 e7 00 00 00    	ja     802818 <__umoddi3+0x148>
  802731:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802735:	29 f1                	sub    %esi,%ecx
  802737:	19 c7                	sbb    %eax,%edi
  802739:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80273d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802741:	8b 44 24 08          	mov    0x8(%esp),%eax
  802745:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802749:	83 c4 14             	add    $0x14,%esp
  80274c:	5e                   	pop    %esi
  80274d:	5f                   	pop    %edi
  80274e:	5d                   	pop    %ebp
  80274f:	c3                   	ret    
  802750:	85 f6                	test   %esi,%esi
  802752:	89 f5                	mov    %esi,%ebp
  802754:	75 0b                	jne    802761 <__umoddi3+0x91>
  802756:	b8 01 00 00 00       	mov    $0x1,%eax
  80275b:	31 d2                	xor    %edx,%edx
  80275d:	f7 f6                	div    %esi
  80275f:	89 c5                	mov    %eax,%ebp
  802761:	8b 44 24 04          	mov    0x4(%esp),%eax
  802765:	31 d2                	xor    %edx,%edx
  802767:	f7 f5                	div    %ebp
  802769:	89 c8                	mov    %ecx,%eax
  80276b:	f7 f5                	div    %ebp
  80276d:	eb 9c                	jmp    80270b <__umoddi3+0x3b>
  80276f:	90                   	nop
  802770:	89 c8                	mov    %ecx,%eax
  802772:	89 fa                	mov    %edi,%edx
  802774:	83 c4 14             	add    $0x14,%esp
  802777:	5e                   	pop    %esi
  802778:	5f                   	pop    %edi
  802779:	5d                   	pop    %ebp
  80277a:	c3                   	ret    
  80277b:	90                   	nop
  80277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802780:	8b 04 24             	mov    (%esp),%eax
  802783:	be 20 00 00 00       	mov    $0x20,%esi
  802788:	89 e9                	mov    %ebp,%ecx
  80278a:	29 ee                	sub    %ebp,%esi
  80278c:	d3 e2                	shl    %cl,%edx
  80278e:	89 f1                	mov    %esi,%ecx
  802790:	d3 e8                	shr    %cl,%eax
  802792:	89 e9                	mov    %ebp,%ecx
  802794:	89 44 24 04          	mov    %eax,0x4(%esp)
  802798:	8b 04 24             	mov    (%esp),%eax
  80279b:	09 54 24 04          	or     %edx,0x4(%esp)
  80279f:	89 fa                	mov    %edi,%edx
  8027a1:	d3 e0                	shl    %cl,%eax
  8027a3:	89 f1                	mov    %esi,%ecx
  8027a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027a9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8027ad:	d3 ea                	shr    %cl,%edx
  8027af:	89 e9                	mov    %ebp,%ecx
  8027b1:	d3 e7                	shl    %cl,%edi
  8027b3:	89 f1                	mov    %esi,%ecx
  8027b5:	d3 e8                	shr    %cl,%eax
  8027b7:	89 e9                	mov    %ebp,%ecx
  8027b9:	09 f8                	or     %edi,%eax
  8027bb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8027bf:	f7 74 24 04          	divl   0x4(%esp)
  8027c3:	d3 e7                	shl    %cl,%edi
  8027c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027c9:	89 d7                	mov    %edx,%edi
  8027cb:	f7 64 24 08          	mull   0x8(%esp)
  8027cf:	39 d7                	cmp    %edx,%edi
  8027d1:	89 c1                	mov    %eax,%ecx
  8027d3:	89 14 24             	mov    %edx,(%esp)
  8027d6:	72 2c                	jb     802804 <__umoddi3+0x134>
  8027d8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8027dc:	72 22                	jb     802800 <__umoddi3+0x130>
  8027de:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8027e2:	29 c8                	sub    %ecx,%eax
  8027e4:	19 d7                	sbb    %edx,%edi
  8027e6:	89 e9                	mov    %ebp,%ecx
  8027e8:	89 fa                	mov    %edi,%edx
  8027ea:	d3 e8                	shr    %cl,%eax
  8027ec:	89 f1                	mov    %esi,%ecx
  8027ee:	d3 e2                	shl    %cl,%edx
  8027f0:	89 e9                	mov    %ebp,%ecx
  8027f2:	d3 ef                	shr    %cl,%edi
  8027f4:	09 d0                	or     %edx,%eax
  8027f6:	89 fa                	mov    %edi,%edx
  8027f8:	83 c4 14             	add    $0x14,%esp
  8027fb:	5e                   	pop    %esi
  8027fc:	5f                   	pop    %edi
  8027fd:	5d                   	pop    %ebp
  8027fe:	c3                   	ret    
  8027ff:	90                   	nop
  802800:	39 d7                	cmp    %edx,%edi
  802802:	75 da                	jne    8027de <__umoddi3+0x10e>
  802804:	8b 14 24             	mov    (%esp),%edx
  802807:	89 c1                	mov    %eax,%ecx
  802809:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80280d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802811:	eb cb                	jmp    8027de <__umoddi3+0x10e>
  802813:	90                   	nop
  802814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802818:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80281c:	0f 82 0f ff ff ff    	jb     802731 <__umoddi3+0x61>
  802822:	e9 1a ff ff ff       	jmp    802741 <__umoddi3+0x71>
