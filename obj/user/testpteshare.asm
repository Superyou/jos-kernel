
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 86 01 00 00       	call   8001b7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	strcpy(VA, msg2);
  800039:	a1 00 40 80 00       	mov    0x804000,%eax
  80003e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800042:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800049:	e8 39 09 00 00       	call   800987 <strcpy>
	exit();
  80004e:	e8 ac 01 00 00       	call   8001ff <exit>
}
  800053:	c9                   	leave  
  800054:	c3                   	ret    

00800055 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	53                   	push   %ebx
  800059:	83 ec 14             	sub    $0x14,%esp
	int r;

	if (argc != 0)
  80005c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800060:	74 05                	je     800067 <umain+0x12>
		childofspawn();
  800062:	e8 cc ff ff ff       	call   800033 <childofspawn>

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800067:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 00 00 00 	movl   $0xa0000000,0x4(%esp)
  800076:	a0 
  800077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80007e:	e8 72 0d 00 00       	call   800df5 <sys_page_alloc>
  800083:	85 c0                	test   %eax,%eax
  800085:	79 20                	jns    8000a7 <umain+0x52>
		panic("sys_page_alloc: %e", r);
  800087:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008b:	c7 44 24 08 ac 35 80 	movl   $0x8035ac,0x8(%esp)
  800092:	00 
  800093:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80009a:	00 
  80009b:	c7 04 24 bf 35 80 00 	movl   $0x8035bf,(%esp)
  8000a2:	e8 71 01 00 00       	call   800218 <_panic>

	// check fork
	if ((r = fork()) < 0)
  8000a7:	e8 63 12 00 00       	call   80130f <fork>
  8000ac:	89 c3                	mov    %eax,%ebx
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	79 20                	jns    8000d2 <umain+0x7d>
		panic("fork: %e", r);
  8000b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b6:	c7 44 24 08 d3 35 80 	movl   $0x8035d3,0x8(%esp)
  8000bd:	00 
  8000be:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8000c5:	00 
  8000c6:	c7 04 24 bf 35 80 00 	movl   $0x8035bf,(%esp)
  8000cd:	e8 46 01 00 00       	call   800218 <_panic>
	if (r == 0) {
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	75 1a                	jne    8000f0 <umain+0x9b>
		strcpy(VA, msg);
  8000d6:	a1 04 40 80 00       	mov    0x804004,%eax
  8000db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000df:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  8000e6:	e8 9c 08 00 00       	call   800987 <strcpy>
		exit();
  8000eb:	e8 0f 01 00 00       	call   8001ff <exit>
	}
	wait(r);
  8000f0:	89 1c 24             	mov    %ebx,(%esp)
  8000f3:	e8 f2 2d 00 00       	call   802eea <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800108:	e8 2f 09 00 00       	call   800a3c <strcmp>
  80010d:	85 c0                	test   %eax,%eax
  80010f:	b8 a0 35 80 00       	mov    $0x8035a0,%eax
  800114:	ba a6 35 80 00       	mov    $0x8035a6,%edx
  800119:	0f 45 c2             	cmovne %edx,%eax
  80011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800120:	c7 04 24 dc 35 80 00 	movl   $0x8035dc,(%esp)
  800127:	e8 e5 01 00 00       	call   800311 <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80012c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800133:	00 
  800134:	c7 44 24 08 f7 35 80 	movl   $0x8035f7,0x8(%esp)
  80013b:	00 
  80013c:	c7 44 24 04 fc 35 80 	movl   $0x8035fc,0x4(%esp)
  800143:	00 
  800144:	c7 04 24 fb 35 80 00 	movl   $0x8035fb,(%esp)
  80014b:	e8 92 24 00 00       	call   8025e2 <spawnl>
  800150:	85 c0                	test   %eax,%eax
  800152:	79 20                	jns    800174 <umain+0x11f>
		panic("spawn: %e", r);
  800154:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800158:	c7 44 24 08 09 36 80 	movl   $0x803609,0x8(%esp)
  80015f:	00 
  800160:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800167:	00 
  800168:	c7 04 24 bf 35 80 00 	movl   $0x8035bf,(%esp)
  80016f:	e8 a4 00 00 00       	call   800218 <_panic>
	wait(r);
  800174:	89 04 24             	mov    %eax,(%esp)
  800177:	e8 6e 2d 00 00       	call   802eea <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80017c:	a1 00 40 80 00       	mov    0x804000,%eax
  800181:	89 44 24 04          	mov    %eax,0x4(%esp)
  800185:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80018c:	e8 ab 08 00 00       	call   800a3c <strcmp>
  800191:	85 c0                	test   %eax,%eax
  800193:	b8 a0 35 80 00       	mov    $0x8035a0,%eax
  800198:	ba a6 35 80 00       	mov    $0x8035a6,%edx
  80019d:	0f 45 c2             	cmovne %edx,%eax
  8001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a4:	c7 04 24 13 36 80 00 	movl   $0x803613,(%esp)
  8001ab:	e8 61 01 00 00       	call   800311 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001b0:	cc                   	int3   

	breakpoint();
}
  8001b1:	83 c4 14             	add    $0x14,%esp
  8001b4:	5b                   	pop    %ebx
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	56                   	push   %esi
  8001bb:	53                   	push   %ebx
  8001bc:	83 ec 10             	sub    $0x10,%esp
  8001bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001c2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8001c5:	e8 ed 0b 00 00       	call   800db7 <sys_getenvid>
  8001ca:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001cf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001d2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001d7:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001dc:	85 db                	test   %ebx,%ebx
  8001de:	7e 07                	jle    8001e7 <libmain+0x30>
		binaryname = argv[0];
  8001e0:	8b 06                	mov    (%esi),%eax
  8001e2:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001eb:	89 1c 24             	mov    %ebx,(%esp)
  8001ee:	e8 62 fe ff ff       	call   800055 <umain>

	// exit gracefully
	exit();
  8001f3:	e8 07 00 00 00       	call   8001ff <exit>
}
  8001f8:	83 c4 10             	add    $0x10,%esp
  8001fb:	5b                   	pop    %ebx
  8001fc:	5e                   	pop    %esi
  8001fd:	5d                   	pop    %ebp
  8001fe:	c3                   	ret    

008001ff <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800205:	e8 80 16 00 00       	call   80188a <close_all>
	sys_env_destroy(0);
  80020a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800211:	e8 fd 0a 00 00       	call   800d13 <sys_env_destroy>
}
  800216:	c9                   	leave  
  800217:	c3                   	ret    

00800218 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	56                   	push   %esi
  80021c:	53                   	push   %ebx
  80021d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800220:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800223:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800229:	e8 89 0b 00 00       	call   800db7 <sys_getenvid>
  80022e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800231:	89 54 24 10          	mov    %edx,0x10(%esp)
  800235:	8b 55 08             	mov    0x8(%ebp),%edx
  800238:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80023c:	89 74 24 08          	mov    %esi,0x8(%esp)
  800240:	89 44 24 04          	mov    %eax,0x4(%esp)
  800244:	c7 04 24 58 36 80 00 	movl   $0x803658,(%esp)
  80024b:	e8 c1 00 00 00       	call   800311 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800250:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800254:	8b 45 10             	mov    0x10(%ebp),%eax
  800257:	89 04 24             	mov    %eax,(%esp)
  80025a:	e8 51 00 00 00       	call   8002b0 <vcprintf>
	cprintf("\n");
  80025f:	c7 04 24 5b 3b 80 00 	movl   $0x803b5b,(%esp)
  800266:	e8 a6 00 00 00       	call   800311 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026b:	cc                   	int3   
  80026c:	eb fd                	jmp    80026b <_panic+0x53>

0080026e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	53                   	push   %ebx
  800272:	83 ec 14             	sub    $0x14,%esp
  800275:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800278:	8b 13                	mov    (%ebx),%edx
  80027a:	8d 42 01             	lea    0x1(%edx),%eax
  80027d:	89 03                	mov    %eax,(%ebx)
  80027f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800282:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800286:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028b:	75 19                	jne    8002a6 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80028d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800294:	00 
  800295:	8d 43 08             	lea    0x8(%ebx),%eax
  800298:	89 04 24             	mov    %eax,(%esp)
  80029b:	e8 36 0a 00 00       	call   800cd6 <sys_cputs>
		b->idx = 0;
  8002a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002a6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002aa:	83 c4 14             	add    $0x14,%esp
  8002ad:	5b                   	pop    %ebx
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    

008002b0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c0:	00 00 00 
	b.cnt = 0;
  8002c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ca:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e5:	c7 04 24 6e 02 80 00 	movl   $0x80026e,(%esp)
  8002ec:	e8 73 01 00 00       	call   800464 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800301:	89 04 24             	mov    %eax,(%esp)
  800304:	e8 cd 09 00 00       	call   800cd6 <sys_cputs>

	return b.cnt;
}
  800309:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800317:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80031a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	89 04 24             	mov    %eax,(%esp)
  800324:	e8 87 ff ff ff       	call   8002b0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800329:	c9                   	leave  
  80032a:	c3                   	ret    
  80032b:	66 90                	xchg   %ax,%ax
  80032d:	66 90                	xchg   %ax,%ax
  80032f:	90                   	nop

00800330 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	57                   	push   %edi
  800334:	56                   	push   %esi
  800335:	53                   	push   %ebx
  800336:	83 ec 3c             	sub    $0x3c,%esp
  800339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033c:	89 d7                	mov    %edx,%edi
  80033e:	8b 45 08             	mov    0x8(%ebp),%eax
  800341:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800344:	8b 45 0c             	mov    0xc(%ebp),%eax
  800347:	89 c3                	mov    %eax,%ebx
  800349:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80034c:	8b 45 10             	mov    0x10(%ebp),%eax
  80034f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800352:	b9 00 00 00 00       	mov    $0x0,%ecx
  800357:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80035d:	39 d9                	cmp    %ebx,%ecx
  80035f:	72 05                	jb     800366 <printnum+0x36>
  800361:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800364:	77 69                	ja     8003cf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800366:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800369:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80036d:	83 ee 01             	sub    $0x1,%esi
  800370:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800374:	89 44 24 08          	mov    %eax,0x8(%esp)
  800378:	8b 44 24 08          	mov    0x8(%esp),%eax
  80037c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800380:	89 c3                	mov    %eax,%ebx
  800382:	89 d6                	mov    %edx,%esi
  800384:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800387:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80038a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80038e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800395:	89 04 24             	mov    %eax,(%esp)
  800398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039f:	e8 5c 2f 00 00       	call   803300 <__udivdi3>
  8003a4:	89 d9                	mov    %ebx,%ecx
  8003a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003aa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003ae:	89 04 24             	mov    %eax,(%esp)
  8003b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003b5:	89 fa                	mov    %edi,%edx
  8003b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ba:	e8 71 ff ff ff       	call   800330 <printnum>
  8003bf:	eb 1b                	jmp    8003dc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c8:	89 04 24             	mov    %eax,(%esp)
  8003cb:	ff d3                	call   *%ebx
  8003cd:	eb 03                	jmp    8003d2 <printnum+0xa2>
  8003cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d2:	83 ee 01             	sub    $0x1,%esi
  8003d5:	85 f6                	test   %esi,%esi
  8003d7:	7f e8                	jg     8003c1 <printnum+0x91>
  8003d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003e0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f5:	89 04 24             	mov    %eax,(%esp)
  8003f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ff:	e8 2c 30 00 00       	call   803430 <__umoddi3>
  800404:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800408:	0f be 80 7b 36 80 00 	movsbl 0x80367b(%eax),%eax
  80040f:	89 04 24             	mov    %eax,(%esp)
  800412:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800415:	ff d0                	call   *%eax
}
  800417:	83 c4 3c             	add    $0x3c,%esp
  80041a:	5b                   	pop    %ebx
  80041b:	5e                   	pop    %esi
  80041c:	5f                   	pop    %edi
  80041d:	5d                   	pop    %ebp
  80041e:	c3                   	ret    

0080041f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800425:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800429:	8b 10                	mov    (%eax),%edx
  80042b:	3b 50 04             	cmp    0x4(%eax),%edx
  80042e:	73 0a                	jae    80043a <sprintputch+0x1b>
		*b->buf++ = ch;
  800430:	8d 4a 01             	lea    0x1(%edx),%ecx
  800433:	89 08                	mov    %ecx,(%eax)
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	88 02                	mov    %al,(%edx)
}
  80043a:	5d                   	pop    %ebp
  80043b:	c3                   	ret    

0080043c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80043c:	55                   	push   %ebp
  80043d:	89 e5                	mov    %esp,%ebp
  80043f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800442:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800445:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800449:	8b 45 10             	mov    0x10(%ebp),%eax
  80044c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800450:	8b 45 0c             	mov    0xc(%ebp),%eax
  800453:	89 44 24 04          	mov    %eax,0x4(%esp)
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	89 04 24             	mov    %eax,(%esp)
  80045d:	e8 02 00 00 00       	call   800464 <vprintfmt>
	va_end(ap);
}
  800462:	c9                   	leave  
  800463:	c3                   	ret    

00800464 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	57                   	push   %edi
  800468:	56                   	push   %esi
  800469:	53                   	push   %ebx
  80046a:	83 ec 3c             	sub    $0x3c,%esp
  80046d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800470:	eb 17                	jmp    800489 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800472:	85 c0                	test   %eax,%eax
  800474:	0f 84 4b 04 00 00    	je     8008c5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80047a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80047d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800481:	89 04 24             	mov    %eax,(%esp)
  800484:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800487:	89 fb                	mov    %edi,%ebx
  800489:	8d 7b 01             	lea    0x1(%ebx),%edi
  80048c:	0f b6 03             	movzbl (%ebx),%eax
  80048f:	83 f8 25             	cmp    $0x25,%eax
  800492:	75 de                	jne    800472 <vprintfmt+0xe>
  800494:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800498:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80049f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8004a4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004b0:	eb 18                	jmp    8004ca <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004b4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8004b8:	eb 10                	jmp    8004ca <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004bc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8004c0:	eb 08                	jmp    8004ca <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8004c5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	8d 5f 01             	lea    0x1(%edi),%ebx
  8004cd:	0f b6 17             	movzbl (%edi),%edx
  8004d0:	0f b6 c2             	movzbl %dl,%eax
  8004d3:	83 ea 23             	sub    $0x23,%edx
  8004d6:	80 fa 55             	cmp    $0x55,%dl
  8004d9:	0f 87 c2 03 00 00    	ja     8008a1 <vprintfmt+0x43d>
  8004df:	0f b6 d2             	movzbl %dl,%edx
  8004e2:	ff 24 95 c0 37 80 00 	jmp    *0x8037c0(,%edx,4)
  8004e9:	89 df                	mov    %ebx,%edi
  8004eb:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004f0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8004f3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8004f7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  8004fa:	8d 50 d0             	lea    -0x30(%eax),%edx
  8004fd:	83 fa 09             	cmp    $0x9,%edx
  800500:	77 33                	ja     800535 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800502:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800505:	eb e9                	jmp    8004f0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	8b 30                	mov    (%eax),%esi
  80050c:	8d 40 04             	lea    0x4(%eax),%eax
  80050f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800512:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800514:	eb 1f                	jmp    800535 <vprintfmt+0xd1>
  800516:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800519:	85 ff                	test   %edi,%edi
  80051b:	b8 00 00 00 00       	mov    $0x0,%eax
  800520:	0f 49 c7             	cmovns %edi,%eax
  800523:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800526:	89 df                	mov    %ebx,%edi
  800528:	eb a0                	jmp    8004ca <vprintfmt+0x66>
  80052a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80052c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800533:	eb 95                	jmp    8004ca <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800535:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800539:	79 8f                	jns    8004ca <vprintfmt+0x66>
  80053b:	eb 85                	jmp    8004c2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80053d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800540:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800542:	eb 86                	jmp    8004ca <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 70 04             	lea    0x4(%eax),%esi
  80054a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	89 04 24             	mov    %eax,(%esp)
  800559:	ff 55 08             	call   *0x8(%ebp)
  80055c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80055f:	e9 25 ff ff ff       	jmp    800489 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8d 70 04             	lea    0x4(%eax),%esi
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	99                   	cltd   
  80056d:	31 d0                	xor    %edx,%eax
  80056f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800571:	83 f8 15             	cmp    $0x15,%eax
  800574:	7f 0b                	jg     800581 <vprintfmt+0x11d>
  800576:	8b 14 85 20 39 80 00 	mov    0x803920(,%eax,4),%edx
  80057d:	85 d2                	test   %edx,%edx
  80057f:	75 26                	jne    8005a7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800581:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800585:	c7 44 24 08 93 36 80 	movl   $0x803693,0x8(%esp)
  80058c:	00 
  80058d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800590:	89 44 24 04          	mov    %eax,0x4(%esp)
  800594:	8b 45 08             	mov    0x8(%ebp),%eax
  800597:	89 04 24             	mov    %eax,(%esp)
  80059a:	e8 9d fe ff ff       	call   80043c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80059f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8005a2:	e9 e2 fe ff ff       	jmp    800489 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005a7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ab:	c7 44 24 08 2a 3b 80 	movl   $0x803b2a,0x8(%esp)
  8005b2:	00 
  8005b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	89 04 24             	mov    %eax,(%esp)
  8005c0:	e8 77 fe ff ff       	call   80043c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005c5:	89 75 14             	mov    %esi,0x14(%ebp)
  8005c8:	e9 bc fe ff ff       	jmp    800489 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005d3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005d6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8005da:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005dc:	85 ff                	test   %edi,%edi
  8005de:	b8 8c 36 80 00       	mov    $0x80368c,%eax
  8005e3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8005e6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8005ea:	0f 84 94 00 00 00    	je     800684 <vprintfmt+0x220>
  8005f0:	85 c9                	test   %ecx,%ecx
  8005f2:	0f 8e 94 00 00 00    	jle    80068c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005fc:	89 3c 24             	mov    %edi,(%esp)
  8005ff:	e8 64 03 00 00       	call   800968 <strnlen>
  800604:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800607:	29 c1                	sub    %eax,%ecx
  800609:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80060c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800610:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800613:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800616:	8b 75 08             	mov    0x8(%ebp),%esi
  800619:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80061c:	89 cb                	mov    %ecx,%ebx
  80061e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800620:	eb 0f                	jmp    800631 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800622:	8b 45 0c             	mov    0xc(%ebp),%eax
  800625:	89 44 24 04          	mov    %eax,0x4(%esp)
  800629:	89 3c 24             	mov    %edi,(%esp)
  80062c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80062e:	83 eb 01             	sub    $0x1,%ebx
  800631:	85 db                	test   %ebx,%ebx
  800633:	7f ed                	jg     800622 <vprintfmt+0x1be>
  800635:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800638:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80063b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80063e:	85 c9                	test   %ecx,%ecx
  800640:	b8 00 00 00 00       	mov    $0x0,%eax
  800645:	0f 49 c1             	cmovns %ecx,%eax
  800648:	29 c1                	sub    %eax,%ecx
  80064a:	89 cb                	mov    %ecx,%ebx
  80064c:	eb 44                	jmp    800692 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80064e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800652:	74 1e                	je     800672 <vprintfmt+0x20e>
  800654:	0f be d2             	movsbl %dl,%edx
  800657:	83 ea 20             	sub    $0x20,%edx
  80065a:	83 fa 5e             	cmp    $0x5e,%edx
  80065d:	76 13                	jbe    800672 <vprintfmt+0x20e>
					putch('?', putdat);
  80065f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800662:	89 44 24 04          	mov    %eax,0x4(%esp)
  800666:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80066d:	ff 55 08             	call   *0x8(%ebp)
  800670:	eb 0d                	jmp    80067f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800672:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800675:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800679:	89 04 24             	mov    %eax,(%esp)
  80067c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80067f:	83 eb 01             	sub    $0x1,%ebx
  800682:	eb 0e                	jmp    800692 <vprintfmt+0x22e>
  800684:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800687:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80068a:	eb 06                	jmp    800692 <vprintfmt+0x22e>
  80068c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80068f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800692:	83 c7 01             	add    $0x1,%edi
  800695:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800699:	0f be c2             	movsbl %dl,%eax
  80069c:	85 c0                	test   %eax,%eax
  80069e:	74 27                	je     8006c7 <vprintfmt+0x263>
  8006a0:	85 f6                	test   %esi,%esi
  8006a2:	78 aa                	js     80064e <vprintfmt+0x1ea>
  8006a4:	83 ee 01             	sub    $0x1,%esi
  8006a7:	79 a5                	jns    80064e <vprintfmt+0x1ea>
  8006a9:	89 d8                	mov    %ebx,%eax
  8006ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006b1:	89 c3                	mov    %eax,%ebx
  8006b3:	eb 18                	jmp    8006cd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006c0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006c2:	83 eb 01             	sub    $0x1,%ebx
  8006c5:	eb 06                	jmp    8006cd <vprintfmt+0x269>
  8006c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006cd:	85 db                	test   %ebx,%ebx
  8006cf:	7f e4                	jg     8006b5 <vprintfmt+0x251>
  8006d1:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006da:	e9 aa fd ff ff       	jmp    800489 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006df:	83 f9 01             	cmp    $0x1,%ecx
  8006e2:	7e 10                	jle    8006f4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 30                	mov    (%eax),%esi
  8006e9:	8b 78 04             	mov    0x4(%eax),%edi
  8006ec:	8d 40 08             	lea    0x8(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	eb 26                	jmp    80071a <vprintfmt+0x2b6>
	else if (lflag)
  8006f4:	85 c9                	test   %ecx,%ecx
  8006f6:	74 12                	je     80070a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 30                	mov    (%eax),%esi
  8006fd:	89 f7                	mov    %esi,%edi
  8006ff:	c1 ff 1f             	sar    $0x1f,%edi
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
  800708:	eb 10                	jmp    80071a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 30                	mov    (%eax),%esi
  80070f:	89 f7                	mov    %esi,%edi
  800711:	c1 ff 1f             	sar    $0x1f,%edi
  800714:	8d 40 04             	lea    0x4(%eax),%eax
  800717:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80071a:	89 f0                	mov    %esi,%eax
  80071c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80071e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800723:	85 ff                	test   %edi,%edi
  800725:	0f 89 3a 01 00 00    	jns    800865 <vprintfmt+0x401>
				putch('-', putdat);
  80072b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800732:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800739:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80073c:	89 f0                	mov    %esi,%eax
  80073e:	89 fa                	mov    %edi,%edx
  800740:	f7 d8                	neg    %eax
  800742:	83 d2 00             	adc    $0x0,%edx
  800745:	f7 da                	neg    %edx
			}
			base = 10;
  800747:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80074c:	e9 14 01 00 00       	jmp    800865 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800751:	83 f9 01             	cmp    $0x1,%ecx
  800754:	7e 13                	jle    800769 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8b 50 04             	mov    0x4(%eax),%edx
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	8b 75 14             	mov    0x14(%ebp),%esi
  800761:	8d 4e 08             	lea    0x8(%esi),%ecx
  800764:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800767:	eb 2c                	jmp    800795 <vprintfmt+0x331>
	else if (lflag)
  800769:	85 c9                	test   %ecx,%ecx
  80076b:	74 15                	je     800782 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	8b 75 14             	mov    0x14(%ebp),%esi
  80077a:	8d 76 04             	lea    0x4(%esi),%esi
  80077d:	89 75 14             	mov    %esi,0x14(%ebp)
  800780:	eb 13                	jmp    800795 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	ba 00 00 00 00       	mov    $0x0,%edx
  80078c:	8b 75 14             	mov    0x14(%ebp),%esi
  80078f:	8d 76 04             	lea    0x4(%esi),%esi
  800792:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800795:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80079a:	e9 c6 00 00 00       	jmp    800865 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80079f:	83 f9 01             	cmp    $0x1,%ecx
  8007a2:	7e 13                	jle    8007b7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 50 04             	mov    0x4(%eax),%edx
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	8b 75 14             	mov    0x14(%ebp),%esi
  8007af:	8d 4e 08             	lea    0x8(%esi),%ecx
  8007b2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007b5:	eb 24                	jmp    8007db <vprintfmt+0x377>
	else if (lflag)
  8007b7:	85 c9                	test   %ecx,%ecx
  8007b9:	74 11                	je     8007cc <vprintfmt+0x368>
		return va_arg(*ap, long);
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	99                   	cltd   
  8007c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007c4:	8d 71 04             	lea    0x4(%ecx),%esi
  8007c7:	89 75 14             	mov    %esi,0x14(%ebp)
  8007ca:	eb 0f                	jmp    8007db <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	99                   	cltd   
  8007d2:	8b 75 14             	mov    0x14(%ebp),%esi
  8007d5:	8d 76 04             	lea    0x4(%esi),%esi
  8007d8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  8007db:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007e0:	e9 80 00 00 00       	jmp    800865 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  8007e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ef:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007f6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800800:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800807:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80080a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80080e:	8b 06                	mov    (%esi),%eax
  800810:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800815:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80081a:	eb 49                	jmp    800865 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80081c:	83 f9 01             	cmp    $0x1,%ecx
  80081f:	7e 13                	jle    800834 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	8b 50 04             	mov    0x4(%eax),%edx
  800827:	8b 00                	mov    (%eax),%eax
  800829:	8b 75 14             	mov    0x14(%ebp),%esi
  80082c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80082f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800832:	eb 2c                	jmp    800860 <vprintfmt+0x3fc>
	else if (lflag)
  800834:	85 c9                	test   %ecx,%ecx
  800836:	74 15                	je     80084d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	ba 00 00 00 00       	mov    $0x0,%edx
  800842:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800845:	8d 71 04             	lea    0x4(%ecx),%esi
  800848:	89 75 14             	mov    %esi,0x14(%ebp)
  80084b:	eb 13                	jmp    800860 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8b 00                	mov    (%eax),%eax
  800852:	ba 00 00 00 00       	mov    $0x0,%edx
  800857:	8b 75 14             	mov    0x14(%ebp),%esi
  80085a:	8d 76 04             	lea    0x4(%esi),%esi
  80085d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800860:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800865:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800869:	89 74 24 10          	mov    %esi,0x10(%esp)
  80086d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800870:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800874:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800878:	89 04 24             	mov    %eax,(%esp)
  80087b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80087f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	e8 a6 fa ff ff       	call   800330 <printnum>
			break;
  80088a:	e9 fa fb ff ff       	jmp    800489 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80088f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800892:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800896:	89 04 24             	mov    %eax,(%esp)
  800899:	ff 55 08             	call   *0x8(%ebp)
			break;
  80089c:	e9 e8 fb ff ff       	jmp    800489 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008af:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b2:	89 fb                	mov    %edi,%ebx
  8008b4:	eb 03                	jmp    8008b9 <vprintfmt+0x455>
  8008b6:	83 eb 01             	sub    $0x1,%ebx
  8008b9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008bd:	75 f7                	jne    8008b6 <vprintfmt+0x452>
  8008bf:	90                   	nop
  8008c0:	e9 c4 fb ff ff       	jmp    800489 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8008c5:	83 c4 3c             	add    $0x3c,%esp
  8008c8:	5b                   	pop    %ebx
  8008c9:	5e                   	pop    %esi
  8008ca:	5f                   	pop    %edi
  8008cb:	5d                   	pop    %ebp
  8008cc:	c3                   	ret    

008008cd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	83 ec 28             	sub    $0x28,%esp
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008dc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008e0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ea:	85 c0                	test   %eax,%eax
  8008ec:	74 30                	je     80091e <vsnprintf+0x51>
  8008ee:	85 d2                	test   %edx,%edx
  8008f0:	7e 2c                	jle    80091e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800900:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800903:	89 44 24 04          	mov    %eax,0x4(%esp)
  800907:	c7 04 24 1f 04 80 00 	movl   $0x80041f,(%esp)
  80090e:	e8 51 fb ff ff       	call   800464 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800916:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80091c:	eb 05                	jmp    800923 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80091e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800923:	c9                   	leave  
  800924:	c3                   	ret    

00800925 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80092b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80092e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800932:	8b 45 10             	mov    0x10(%ebp),%eax
  800935:	89 44 24 08          	mov    %eax,0x8(%esp)
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	89 04 24             	mov    %eax,(%esp)
  800946:	e8 82 ff ff ff       	call   8008cd <vsnprintf>
	va_end(ap);

	return rc;
}
  80094b:	c9                   	leave  
  80094c:	c3                   	ret    
  80094d:	66 90                	xchg   %ax,%ax
  80094f:	90                   	nop

00800950 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	eb 03                	jmp    800960 <strlen+0x10>
		n++;
  80095d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800960:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800964:	75 f7                	jne    80095d <strlen+0xd>
		n++;
	return n;
}
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800971:	b8 00 00 00 00       	mov    $0x0,%eax
  800976:	eb 03                	jmp    80097b <strnlen+0x13>
		n++;
  800978:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097b:	39 d0                	cmp    %edx,%eax
  80097d:	74 06                	je     800985 <strnlen+0x1d>
  80097f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800983:	75 f3                	jne    800978 <strnlen+0x10>
		n++;
	return n;
}
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	53                   	push   %ebx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800991:	89 c2                	mov    %eax,%edx
  800993:	83 c2 01             	add    $0x1,%edx
  800996:	83 c1 01             	add    $0x1,%ecx
  800999:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80099d:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a0:	84 db                	test   %bl,%bl
  8009a2:	75 ef                	jne    800993 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009a4:	5b                   	pop    %ebx
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	53                   	push   %ebx
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009b1:	89 1c 24             	mov    %ebx,(%esp)
  8009b4:	e8 97 ff ff ff       	call   800950 <strlen>
	strcpy(dst + len, src);
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009c0:	01 d8                	add    %ebx,%eax
  8009c2:	89 04 24             	mov    %eax,(%esp)
  8009c5:	e8 bd ff ff ff       	call   800987 <strcpy>
	return dst;
}
  8009ca:	89 d8                	mov    %ebx,%eax
  8009cc:	83 c4 08             	add    $0x8,%esp
  8009cf:	5b                   	pop    %ebx
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009dd:	89 f3                	mov    %esi,%ebx
  8009df:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e2:	89 f2                	mov    %esi,%edx
  8009e4:	eb 0f                	jmp    8009f5 <strncpy+0x23>
		*dst++ = *src;
  8009e6:	83 c2 01             	add    $0x1,%edx
  8009e9:	0f b6 01             	movzbl (%ecx),%eax
  8009ec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ef:	80 39 01             	cmpb   $0x1,(%ecx)
  8009f2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f5:	39 da                	cmp    %ebx,%edx
  8009f7:	75 ed                	jne    8009e6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009f9:	89 f0                	mov    %esi,%eax
  8009fb:	5b                   	pop    %ebx
  8009fc:	5e                   	pop    %esi
  8009fd:	5d                   	pop    %ebp
  8009fe:	c3                   	ret    

008009ff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	56                   	push   %esi
  800a03:	53                   	push   %ebx
  800a04:	8b 75 08             	mov    0x8(%ebp),%esi
  800a07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a0d:	89 f0                	mov    %esi,%eax
  800a0f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a13:	85 c9                	test   %ecx,%ecx
  800a15:	75 0b                	jne    800a22 <strlcpy+0x23>
  800a17:	eb 1d                	jmp    800a36 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a19:	83 c0 01             	add    $0x1,%eax
  800a1c:	83 c2 01             	add    $0x1,%edx
  800a1f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a22:	39 d8                	cmp    %ebx,%eax
  800a24:	74 0b                	je     800a31 <strlcpy+0x32>
  800a26:	0f b6 0a             	movzbl (%edx),%ecx
  800a29:	84 c9                	test   %cl,%cl
  800a2b:	75 ec                	jne    800a19 <strlcpy+0x1a>
  800a2d:	89 c2                	mov    %eax,%edx
  800a2f:	eb 02                	jmp    800a33 <strlcpy+0x34>
  800a31:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a33:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a36:	29 f0                	sub    %esi,%eax
}
  800a38:	5b                   	pop    %ebx
  800a39:	5e                   	pop    %esi
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a42:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a45:	eb 06                	jmp    800a4d <strcmp+0x11>
		p++, q++;
  800a47:	83 c1 01             	add    $0x1,%ecx
  800a4a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a4d:	0f b6 01             	movzbl (%ecx),%eax
  800a50:	84 c0                	test   %al,%al
  800a52:	74 04                	je     800a58 <strcmp+0x1c>
  800a54:	3a 02                	cmp    (%edx),%al
  800a56:	74 ef                	je     800a47 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a58:	0f b6 c0             	movzbl %al,%eax
  800a5b:	0f b6 12             	movzbl (%edx),%edx
  800a5e:	29 d0                	sub    %edx,%eax
}
  800a60:	5d                   	pop    %ebp
  800a61:	c3                   	ret    

00800a62 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	53                   	push   %ebx
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6c:	89 c3                	mov    %eax,%ebx
  800a6e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a71:	eb 06                	jmp    800a79 <strncmp+0x17>
		n--, p++, q++;
  800a73:	83 c0 01             	add    $0x1,%eax
  800a76:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a79:	39 d8                	cmp    %ebx,%eax
  800a7b:	74 15                	je     800a92 <strncmp+0x30>
  800a7d:	0f b6 08             	movzbl (%eax),%ecx
  800a80:	84 c9                	test   %cl,%cl
  800a82:	74 04                	je     800a88 <strncmp+0x26>
  800a84:	3a 0a                	cmp    (%edx),%cl
  800a86:	74 eb                	je     800a73 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a88:	0f b6 00             	movzbl (%eax),%eax
  800a8b:	0f b6 12             	movzbl (%edx),%edx
  800a8e:	29 d0                	sub    %edx,%eax
  800a90:	eb 05                	jmp    800a97 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a97:	5b                   	pop    %ebx
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa4:	eb 07                	jmp    800aad <strchr+0x13>
		if (*s == c)
  800aa6:	38 ca                	cmp    %cl,%dl
  800aa8:	74 0f                	je     800ab9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	0f b6 10             	movzbl (%eax),%edx
  800ab0:	84 d2                	test   %dl,%dl
  800ab2:	75 f2                	jne    800aa6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800ab4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac5:	eb 07                	jmp    800ace <strfind+0x13>
		if (*s == c)
  800ac7:	38 ca                	cmp    %cl,%dl
  800ac9:	74 0a                	je     800ad5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800acb:	83 c0 01             	add    $0x1,%eax
  800ace:	0f b6 10             	movzbl (%eax),%edx
  800ad1:	84 d2                	test   %dl,%dl
  800ad3:	75 f2                	jne    800ac7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	57                   	push   %edi
  800adb:	56                   	push   %esi
  800adc:	53                   	push   %ebx
  800add:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ae0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ae3:	85 c9                	test   %ecx,%ecx
  800ae5:	74 36                	je     800b1d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ae7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aed:	75 28                	jne    800b17 <memset+0x40>
  800aef:	f6 c1 03             	test   $0x3,%cl
  800af2:	75 23                	jne    800b17 <memset+0x40>
		c &= 0xFF;
  800af4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800af8:	89 d3                	mov    %edx,%ebx
  800afa:	c1 e3 08             	shl    $0x8,%ebx
  800afd:	89 d6                	mov    %edx,%esi
  800aff:	c1 e6 18             	shl    $0x18,%esi
  800b02:	89 d0                	mov    %edx,%eax
  800b04:	c1 e0 10             	shl    $0x10,%eax
  800b07:	09 f0                	or     %esi,%eax
  800b09:	09 c2                	or     %eax,%edx
  800b0b:	89 d0                	mov    %edx,%eax
  800b0d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b0f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b12:	fc                   	cld    
  800b13:	f3 ab                	rep stos %eax,%es:(%edi)
  800b15:	eb 06                	jmp    800b1d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	fc                   	cld    
  800b1b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b1d:	89 f8                	mov    %edi,%eax
  800b1f:	5b                   	pop    %ebx
  800b20:	5e                   	pop    %esi
  800b21:	5f                   	pop    %edi
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    

00800b24 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	57                   	push   %edi
  800b28:	56                   	push   %esi
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b32:	39 c6                	cmp    %eax,%esi
  800b34:	73 35                	jae    800b6b <memmove+0x47>
  800b36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b39:	39 d0                	cmp    %edx,%eax
  800b3b:	73 2e                	jae    800b6b <memmove+0x47>
		s += n;
		d += n;
  800b3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b40:	89 d6                	mov    %edx,%esi
  800b42:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b44:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b4a:	75 13                	jne    800b5f <memmove+0x3b>
  800b4c:	f6 c1 03             	test   $0x3,%cl
  800b4f:	75 0e                	jne    800b5f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b51:	83 ef 04             	sub    $0x4,%edi
  800b54:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b57:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b5a:	fd                   	std    
  800b5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b5d:	eb 09                	jmp    800b68 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b5f:	83 ef 01             	sub    $0x1,%edi
  800b62:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b65:	fd                   	std    
  800b66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b68:	fc                   	cld    
  800b69:	eb 1d                	jmp    800b88 <memmove+0x64>
  800b6b:	89 f2                	mov    %esi,%edx
  800b6d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6f:	f6 c2 03             	test   $0x3,%dl
  800b72:	75 0f                	jne    800b83 <memmove+0x5f>
  800b74:	f6 c1 03             	test   $0x3,%cl
  800b77:	75 0a                	jne    800b83 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b79:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b7c:	89 c7                	mov    %eax,%edi
  800b7e:	fc                   	cld    
  800b7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b81:	eb 05                	jmp    800b88 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b83:	89 c7                	mov    %eax,%edi
  800b85:	fc                   	cld    
  800b86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b88:	5e                   	pop    %esi
  800b89:	5f                   	pop    %edi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b92:	8b 45 10             	mov    0x10(%ebp),%eax
  800b95:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 04 24             	mov    %eax,(%esp)
  800ba6:	e8 79 ff ff ff       	call   800b24 <memmove>
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	56                   	push   %esi
  800bb1:	53                   	push   %ebx
  800bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb8:	89 d6                	mov    %edx,%esi
  800bba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bbd:	eb 1a                	jmp    800bd9 <memcmp+0x2c>
		if (*s1 != *s2)
  800bbf:	0f b6 02             	movzbl (%edx),%eax
  800bc2:	0f b6 19             	movzbl (%ecx),%ebx
  800bc5:	38 d8                	cmp    %bl,%al
  800bc7:	74 0a                	je     800bd3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800bc9:	0f b6 c0             	movzbl %al,%eax
  800bcc:	0f b6 db             	movzbl %bl,%ebx
  800bcf:	29 d8                	sub    %ebx,%eax
  800bd1:	eb 0f                	jmp    800be2 <memcmp+0x35>
		s1++, s2++;
  800bd3:	83 c2 01             	add    $0x1,%edx
  800bd6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bd9:	39 f2                	cmp    %esi,%edx
  800bdb:	75 e2                	jne    800bbf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bef:	89 c2                	mov    %eax,%edx
  800bf1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bf4:	eb 07                	jmp    800bfd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bf6:	38 08                	cmp    %cl,(%eax)
  800bf8:	74 07                	je     800c01 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bfa:	83 c0 01             	add    $0x1,%eax
  800bfd:	39 d0                	cmp    %edx,%eax
  800bff:	72 f5                	jb     800bf6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c0f:	eb 03                	jmp    800c14 <strtol+0x11>
		s++;
  800c11:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c14:	0f b6 0a             	movzbl (%edx),%ecx
  800c17:	80 f9 09             	cmp    $0x9,%cl
  800c1a:	74 f5                	je     800c11 <strtol+0xe>
  800c1c:	80 f9 20             	cmp    $0x20,%cl
  800c1f:	74 f0                	je     800c11 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c21:	80 f9 2b             	cmp    $0x2b,%cl
  800c24:	75 0a                	jne    800c30 <strtol+0x2d>
		s++;
  800c26:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c29:	bf 00 00 00 00       	mov    $0x0,%edi
  800c2e:	eb 11                	jmp    800c41 <strtol+0x3e>
  800c30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c35:	80 f9 2d             	cmp    $0x2d,%cl
  800c38:	75 07                	jne    800c41 <strtol+0x3e>
		s++, neg = 1;
  800c3a:	8d 52 01             	lea    0x1(%edx),%edx
  800c3d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c41:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c46:	75 15                	jne    800c5d <strtol+0x5a>
  800c48:	80 3a 30             	cmpb   $0x30,(%edx)
  800c4b:	75 10                	jne    800c5d <strtol+0x5a>
  800c4d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c51:	75 0a                	jne    800c5d <strtol+0x5a>
		s += 2, base = 16;
  800c53:	83 c2 02             	add    $0x2,%edx
  800c56:	b8 10 00 00 00       	mov    $0x10,%eax
  800c5b:	eb 10                	jmp    800c6d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c5d:	85 c0                	test   %eax,%eax
  800c5f:	75 0c                	jne    800c6d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c61:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c63:	80 3a 30             	cmpb   $0x30,(%edx)
  800c66:	75 05                	jne    800c6d <strtol+0x6a>
		s++, base = 8;
  800c68:	83 c2 01             	add    $0x1,%edx
  800c6b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c72:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c75:	0f b6 0a             	movzbl (%edx),%ecx
  800c78:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c7b:	89 f0                	mov    %esi,%eax
  800c7d:	3c 09                	cmp    $0x9,%al
  800c7f:	77 08                	ja     800c89 <strtol+0x86>
			dig = *s - '0';
  800c81:	0f be c9             	movsbl %cl,%ecx
  800c84:	83 e9 30             	sub    $0x30,%ecx
  800c87:	eb 20                	jmp    800ca9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c89:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c8c:	89 f0                	mov    %esi,%eax
  800c8e:	3c 19                	cmp    $0x19,%al
  800c90:	77 08                	ja     800c9a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c92:	0f be c9             	movsbl %cl,%ecx
  800c95:	83 e9 57             	sub    $0x57,%ecx
  800c98:	eb 0f                	jmp    800ca9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c9a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c9d:	89 f0                	mov    %esi,%eax
  800c9f:	3c 19                	cmp    $0x19,%al
  800ca1:	77 16                	ja     800cb9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ca3:	0f be c9             	movsbl %cl,%ecx
  800ca6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ca9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800cac:	7d 0f                	jge    800cbd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800cae:	83 c2 01             	add    $0x1,%edx
  800cb1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800cb5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800cb7:	eb bc                	jmp    800c75 <strtol+0x72>
  800cb9:	89 d8                	mov    %ebx,%eax
  800cbb:	eb 02                	jmp    800cbf <strtol+0xbc>
  800cbd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800cbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc3:	74 05                	je     800cca <strtol+0xc7>
		*endptr = (char *) s;
  800cc5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cca:	f7 d8                	neg    %eax
  800ccc:	85 ff                	test   %edi,%edi
  800cce:	0f 44 c3             	cmove  %ebx,%eax
}
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce7:	89 c3                	mov    %eax,%ebx
  800ce9:	89 c7                	mov    %eax,%edi
  800ceb:	89 c6                	mov    %eax,%esi
  800ced:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    

00800cf4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	57                   	push   %edi
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfa:	ba 00 00 00 00       	mov    $0x0,%edx
  800cff:	b8 01 00 00 00       	mov    $0x1,%eax
  800d04:	89 d1                	mov    %edx,%ecx
  800d06:	89 d3                	mov    %edx,%ebx
  800d08:	89 d7                	mov    %edx,%edi
  800d0a:	89 d6                	mov    %edx,%esi
  800d0c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5f                   	pop    %edi
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d21:	b8 03 00 00 00       	mov    $0x3,%eax
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	89 cb                	mov    %ecx,%ebx
  800d2b:	89 cf                	mov    %ecx,%edi
  800d2d:	89 ce                	mov    %ecx,%esi
  800d2f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d31:	85 c0                	test   %eax,%eax
  800d33:	7e 28                	jle    800d5d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d35:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d39:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d40:	00 
  800d41:	c7 44 24 08 97 39 80 	movl   $0x803997,0x8(%esp)
  800d48:	00 
  800d49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d50:	00 
  800d51:	c7 04 24 b4 39 80 00 	movl   $0x8039b4,(%esp)
  800d58:	e8 bb f4 ff ff       	call   800218 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d5d:	83 c4 2c             	add    $0x2c,%esp
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5f                   	pop    %edi
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	57                   	push   %edi
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
  800d6b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d73:	b8 04 00 00 00       	mov    $0x4,%eax
  800d78:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7b:	89 cb                	mov    %ecx,%ebx
  800d7d:	89 cf                	mov    %ecx,%edi
  800d7f:	89 ce                	mov    %ecx,%esi
  800d81:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7e 28                	jle    800daf <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d87:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d8b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d92:	00 
  800d93:	c7 44 24 08 97 39 80 	movl   $0x803997,0x8(%esp)
  800d9a:	00 
  800d9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da2:	00 
  800da3:	c7 04 24 b4 39 80 00 	movl   $0x8039b4,(%esp)
  800daa:	e8 69 f4 ff ff       	call   800218 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800daf:	83 c4 2c             	add    $0x2c,%esp
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5f                   	pop    %edi
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc2:	b8 02 00 00 00       	mov    $0x2,%eax
  800dc7:	89 d1                	mov    %edx,%ecx
  800dc9:	89 d3                	mov    %edx,%ebx
  800dcb:	89 d7                	mov    %edx,%edi
  800dcd:	89 d6                	mov    %edx,%esi
  800dcf:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <sys_yield>:

void
sys_yield(void)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  800de1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800de6:	89 d1                	mov    %edx,%ecx
  800de8:	89 d3                	mov    %edx,%ebx
  800dea:	89 d7                	mov    %edx,%edi
  800dec:	89 d6                	mov    %edx,%esi
  800dee:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800dfe:	be 00 00 00 00       	mov    $0x0,%esi
  800e03:	b8 05 00 00 00       	mov    $0x5,%eax
  800e08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e11:	89 f7                	mov    %esi,%edi
  800e13:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e15:	85 c0                	test   %eax,%eax
  800e17:	7e 28                	jle    800e41 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e19:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e24:	00 
  800e25:	c7 44 24 08 97 39 80 	movl   $0x803997,0x8(%esp)
  800e2c:	00 
  800e2d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e34:	00 
  800e35:	c7 04 24 b4 39 80 00 	movl   $0x8039b4,(%esp)
  800e3c:	e8 d7 f3 ff ff       	call   800218 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e41:	83 c4 2c             	add    $0x2c,%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e52:	b8 06 00 00 00       	mov    $0x6,%eax
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e60:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e63:	8b 75 18             	mov    0x18(%ebp),%esi
  800e66:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	7e 28                	jle    800e94 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e70:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e77:	00 
  800e78:	c7 44 24 08 97 39 80 	movl   $0x803997,0x8(%esp)
  800e7f:	00 
  800e80:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e87:	00 
  800e88:	c7 04 24 b4 39 80 00 	movl   $0x8039b4,(%esp)
  800e8f:	e8 84 f3 ff ff       	call   800218 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e94:	83 c4 2c             	add    $0x2c,%esp
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	57                   	push   %edi
  800ea0:	56                   	push   %esi
  800ea1:	53                   	push   %ebx
  800ea2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eaa:	b8 07 00 00 00       	mov    $0x7,%eax
  800eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb5:	89 df                	mov    %ebx,%edi
  800eb7:	89 de                	mov    %ebx,%esi
  800eb9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ebb:	85 c0                	test   %eax,%eax
  800ebd:	7e 28                	jle    800ee7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800eca:	00 
  800ecb:	c7 44 24 08 97 39 80 	movl   $0x803997,0x8(%esp)
  800ed2:	00 
  800ed3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eda:	00 
  800edb:	c7 04 24 b4 39 80 00 	movl   $0x8039b4,(%esp)
  800ee2:	e8 31 f3 ff ff       	call   800218 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ee7:	83 c4 2c             	add    $0x2c,%esp
  800eea:	5b                   	pop    %ebx
  800eeb:	5e                   	pop    %esi
  800eec:	5f                   	pop    %edi
  800eed:	5d                   	pop    %ebp
  800eee:	c3                   	ret    

00800eef <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800efa:	b8 10 00 00 00       	mov    $0x10,%eax
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	89 cb                	mov    %ecx,%ebx
  800f04:	89 cf                	mov    %ecx,%edi
  800f06:	89 ce                	mov    %ecx,%esi
  800f08:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800f0a:	5b                   	pop    %ebx
  800f0b:	5e                   	pop    %esi
  800f0c:	5f                   	pop    %edi
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    

00800f0f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
  800f15:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1d:	b8 09 00 00 00       	mov    $0x9,%eax
  800f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f25:	8b 55 08             	mov    0x8(%ebp),%edx
  800f28:	89 df                	mov    %ebx,%edi
  800f2a:	89 de                	mov    %ebx,%esi
  800f2c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	7e 28                	jle    800f5a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f32:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f36:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f3d:	00 
  800f3e:	c7 44 24 08 97 39 80 	movl   $0x803997,0x8(%esp)
  800f45:	00 
  800f46:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4d:	00 
  800f4e:	c7 04 24 b4 39 80 00 	movl   $0x8039b4,(%esp)
  800f55:	e8 be f2 ff ff       	call   800218 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f5a:	83 c4 2c             	add    $0x2c,%esp
  800f5d:	5b                   	pop    %ebx
  800f5e:	5e                   	pop    %esi
  800f5f:	5f                   	pop    %edi
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	53                   	push   %ebx
  800f68:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f70:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f78:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7b:	89 df                	mov    %ebx,%edi
  800f7d:	89 de                	mov    %ebx,%esi
  800f7f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	7e 28                	jle    800fad <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f85:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f89:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f90:	00 
  800f91:	c7 44 24 08 97 39 80 	movl   $0x803997,0x8(%esp)
  800f98:	00 
  800f99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa0:	00 
  800fa1:	c7 04 24 b4 39 80 00 	movl   $0x8039b4,(%esp)
  800fa8:	e8 6b f2 ff ff       	call   800218 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fad:	83 c4 2c             	add    $0x2c,%esp
  800fb0:	5b                   	pop    %ebx
  800fb1:	5e                   	pop    %esi
  800fb2:	5f                   	pop    %edi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	57                   	push   %edi
  800fb9:	56                   	push   %esi
  800fba:	53                   	push   %ebx
  800fbb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fce:	89 df                	mov    %ebx,%edi
  800fd0:	89 de                	mov    %ebx,%esi
  800fd2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	7e 28                	jle    801000 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fdc:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800fe3:	00 
  800fe4:	c7 44 24 08 97 39 80 	movl   $0x803997,0x8(%esp)
  800feb:	00 
  800fec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff3:	00 
  800ff4:	c7 04 24 b4 39 80 00 	movl   $0x8039b4,(%esp)
  800ffb:	e8 18 f2 ff ff       	call   800218 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801000:	83 c4 2c             	add    $0x2c,%esp
  801003:	5b                   	pop    %ebx
  801004:	5e                   	pop    %esi
  801005:	5f                   	pop    %edi
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	57                   	push   %edi
  80100c:	56                   	push   %esi
  80100d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100e:	be 00 00 00 00       	mov    $0x0,%esi
  801013:	b8 0d 00 00 00       	mov    $0xd,%eax
  801018:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101b:	8b 55 08             	mov    0x8(%ebp),%edx
  80101e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801021:	8b 7d 14             	mov    0x14(%ebp),%edi
  801024:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801026:	5b                   	pop    %ebx
  801027:	5e                   	pop    %esi
  801028:	5f                   	pop    %edi
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	57                   	push   %edi
  80102f:	56                   	push   %esi
  801030:	53                   	push   %ebx
  801031:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801034:	b9 00 00 00 00       	mov    $0x0,%ecx
  801039:	b8 0e 00 00 00       	mov    $0xe,%eax
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
  801041:	89 cb                	mov    %ecx,%ebx
  801043:	89 cf                	mov    %ecx,%edi
  801045:	89 ce                	mov    %ecx,%esi
  801047:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801049:	85 c0                	test   %eax,%eax
  80104b:	7e 28                	jle    801075 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80104d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801051:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801058:	00 
  801059:	c7 44 24 08 97 39 80 	movl   $0x803997,0x8(%esp)
  801060:	00 
  801061:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801068:	00 
  801069:	c7 04 24 b4 39 80 00 	movl   $0x8039b4,(%esp)
  801070:	e8 a3 f1 ff ff       	call   800218 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801075:	83 c4 2c             	add    $0x2c,%esp
  801078:	5b                   	pop    %ebx
  801079:	5e                   	pop    %esi
  80107a:	5f                   	pop    %edi
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	57                   	push   %edi
  801081:	56                   	push   %esi
  801082:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801083:	ba 00 00 00 00       	mov    $0x0,%edx
  801088:	b8 0f 00 00 00       	mov    $0xf,%eax
  80108d:	89 d1                	mov    %edx,%ecx
  80108f:	89 d3                	mov    %edx,%ebx
  801091:	89 d7                	mov    %edx,%edi
  801093:	89 d6                	mov    %edx,%esi
  801095:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801097:	5b                   	pop    %ebx
  801098:	5e                   	pop    %esi
  801099:	5f                   	pop    %edi
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    

0080109c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	57                   	push   %edi
  8010a0:	56                   	push   %esi
  8010a1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a7:	b8 11 00 00 00       	mov    $0x11,%eax
  8010ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010af:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b2:	89 df                	mov    %ebx,%edi
  8010b4:	89 de                	mov    %ebx,%esi
  8010b6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  8010b8:	5b                   	pop    %ebx
  8010b9:	5e                   	pop    %esi
  8010ba:	5f                   	pop    %edi
  8010bb:	5d                   	pop    %ebp
  8010bc:	c3                   	ret    

008010bd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  8010bd:	55                   	push   %ebp
  8010be:	89 e5                	mov    %esp,%ebp
  8010c0:	57                   	push   %edi
  8010c1:	56                   	push   %esi
  8010c2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c8:	b8 12 00 00 00       	mov    $0x12,%eax
  8010cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d3:	89 df                	mov    %ebx,%edi
  8010d5:	89 de                	mov    %ebx,%esi
  8010d7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8010d9:	5b                   	pop    %ebx
  8010da:	5e                   	pop    %esi
  8010db:	5f                   	pop    %edi
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	57                   	push   %edi
  8010e2:	56                   	push   %esi
  8010e3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e9:	b8 13 00 00 00       	mov    $0x13,%eax
  8010ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f1:	89 cb                	mov    %ecx,%ebx
  8010f3:	89 cf                	mov    %ecx,%edi
  8010f5:	89 ce                	mov    %ecx,%esi
  8010f7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8010f9:	5b                   	pop    %ebx
  8010fa:	5e                   	pop    %esi
  8010fb:	5f                   	pop    %edi
  8010fc:	5d                   	pop    %ebp
  8010fd:	c3                   	ret    

008010fe <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	57                   	push   %edi
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	83 ec 2c             	sub    $0x2c,%esp
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80110a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80110c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80110f:	89 f8                	mov    %edi,%eax
  801111:	c1 e8 0c             	shr    $0xc,%eax
  801114:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801117:	e8 9b fc ff ff       	call   800db7 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80111c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801122:	0f 84 de 00 00 00    	je     801206 <pgfault+0x108>
  801128:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  80112a:	85 c0                	test   %eax,%eax
  80112c:	79 20                	jns    80114e <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  80112e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801132:	c7 44 24 08 c2 39 80 	movl   $0x8039c2,0x8(%esp)
  801139:	00 
  80113a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801141:	00 
  801142:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  801149:	e8 ca f0 ff ff       	call   800218 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  80114e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801151:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  801158:	25 05 08 00 00       	and    $0x805,%eax
  80115d:	3d 05 08 00 00       	cmp    $0x805,%eax
  801162:	0f 85 ba 00 00 00    	jne    801222 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801168:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80116f:	00 
  801170:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801177:	00 
  801178:	89 1c 24             	mov    %ebx,(%esp)
  80117b:	e8 75 fc ff ff       	call   800df5 <sys_page_alloc>
  801180:	85 c0                	test   %eax,%eax
  801182:	79 20                	jns    8011a4 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  801184:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801188:	c7 44 24 08 ac 35 80 	movl   $0x8035ac,0x8(%esp)
  80118f:	00 
  801190:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801197:	00 
  801198:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  80119f:	e8 74 f0 ff ff       	call   800218 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  8011a4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8011aa:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011b1:	00 
  8011b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011b6:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8011bd:	e8 62 f9 ff ff       	call   800b24 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  8011c2:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8011c9:	00 
  8011ca:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011ce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011d2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011d9:	00 
  8011da:	89 1c 24             	mov    %ebx,(%esp)
  8011dd:	e8 67 fc ff ff       	call   800e49 <sys_page_map>
  8011e2:	85 c0                	test   %eax,%eax
  8011e4:	79 3c                	jns    801222 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  8011e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ea:	c7 44 24 08 e9 39 80 	movl   $0x8039e9,0x8(%esp)
  8011f1:	00 
  8011f2:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8011f9:	00 
  8011fa:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  801201:	e8 12 f0 ff ff       	call   800218 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801206:	c7 44 24 08 10 3a 80 	movl   $0x803a10,0x8(%esp)
  80120d:	00 
  80120e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801215:	00 
  801216:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  80121d:	e8 f6 ef ff ff       	call   800218 <_panic>
}
  801222:	83 c4 2c             	add    $0x2c,%esp
  801225:	5b                   	pop    %ebx
  801226:	5e                   	pop    %esi
  801227:	5f                   	pop    %edi
  801228:	5d                   	pop    %ebp
  801229:	c3                   	ret    

0080122a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	56                   	push   %esi
  80122e:	53                   	push   %ebx
  80122f:	83 ec 20             	sub    $0x20,%esp
  801232:	8b 75 08             	mov    0x8(%ebp),%esi
  801235:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801238:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80123f:	00 
  801240:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801244:	89 34 24             	mov    %esi,(%esp)
  801247:	e8 a9 fb ff ff       	call   800df5 <sys_page_alloc>
  80124c:	85 c0                	test   %eax,%eax
  80124e:	79 20                	jns    801270 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  801250:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801254:	c7 44 24 08 ac 35 80 	movl   $0x8035ac,0x8(%esp)
  80125b:	00 
  80125c:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  801263:	00 
  801264:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  80126b:	e8 a8 ef ff ff       	call   800218 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801270:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801277:	00 
  801278:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  80127f:	00 
  801280:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801287:	00 
  801288:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80128c:	89 34 24             	mov    %esi,(%esp)
  80128f:	e8 b5 fb ff ff       	call   800e49 <sys_page_map>
  801294:	85 c0                	test   %eax,%eax
  801296:	79 20                	jns    8012b8 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  801298:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80129c:	c7 44 24 08 e9 39 80 	movl   $0x8039e9,0x8(%esp)
  8012a3:	00 
  8012a4:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8012ab:	00 
  8012ac:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  8012b3:	e8 60 ef ff ff       	call   800218 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8012b8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8012bf:	00 
  8012c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012c4:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8012cb:	e8 54 f8 ff ff       	call   800b24 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8012d0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8012d7:	00 
  8012d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012df:	e8 b8 fb ff ff       	call   800e9c <sys_page_unmap>
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	79 20                	jns    801308 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8012e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012ec:	c7 44 24 08 fa 39 80 	movl   $0x8039fa,0x8(%esp)
  8012f3:	00 
  8012f4:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8012fb:	00 
  8012fc:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  801303:	e8 10 ef ff ff       	call   800218 <_panic>

}
  801308:	83 c4 20             	add    $0x20,%esp
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5d                   	pop    %ebp
  80130e:	c3                   	ret    

0080130f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	57                   	push   %edi
  801313:	56                   	push   %esi
  801314:	53                   	push   %ebx
  801315:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801318:	c7 04 24 fe 10 80 00 	movl   $0x8010fe,(%esp)
  80131f:	e8 d2 1d 00 00       	call   8030f6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801324:	b8 08 00 00 00       	mov    $0x8,%eax
  801329:	cd 30                	int    $0x30
  80132b:	89 c6                	mov    %eax,%esi
  80132d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801330:	85 c0                	test   %eax,%eax
  801332:	79 20                	jns    801354 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801334:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801338:	c7 44 24 08 34 3a 80 	movl   $0x803a34,0x8(%esp)
  80133f:	00 
  801340:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  801347:	00 
  801348:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  80134f:	e8 c4 ee ff ff       	call   800218 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801354:	bb 00 00 00 00       	mov    $0x0,%ebx
  801359:	85 c0                	test   %eax,%eax
  80135b:	75 21                	jne    80137e <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80135d:	e8 55 fa ff ff       	call   800db7 <sys_getenvid>
  801362:	25 ff 03 00 00       	and    $0x3ff,%eax
  801367:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80136a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80136f:	a3 08 50 80 00       	mov    %eax,0x805008
		//set_pgfault_handler(pgfault);
		return 0;
  801374:	b8 00 00 00 00       	mov    $0x0,%eax
  801379:	e9 88 01 00 00       	jmp    801506 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  80137e:	89 d8                	mov    %ebx,%eax
  801380:	c1 e8 16             	shr    $0x16,%eax
  801383:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80138a:	a8 01                	test   $0x1,%al
  80138c:	0f 84 e0 00 00 00    	je     801472 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801392:	89 df                	mov    %ebx,%edi
  801394:	c1 ef 0c             	shr    $0xc,%edi
  801397:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  80139e:	a8 01                	test   $0x1,%al
  8013a0:	0f 84 c4 00 00 00    	je     80146a <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  8013a6:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  8013ad:	f6 c4 04             	test   $0x4,%ah
  8013b0:	74 0d                	je     8013bf <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  8013b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8013b7:	83 c8 05             	or     $0x5,%eax
  8013ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013bd:	eb 1b                	jmp    8013da <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  8013bf:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  8013c4:	83 f8 01             	cmp    $0x1,%eax
  8013c7:	19 c0                	sbb    %eax,%eax
  8013c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013cc:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  8013d3:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  8013da:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  8013dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013e4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013ef:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fa:	e8 4a fa ff ff       	call   800e49 <sys_page_map>
  8013ff:	85 c0                	test   %eax,%eax
  801401:	79 20                	jns    801423 <fork+0x114>
		panic("sys_page_map: %e", r);
  801403:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801407:	c7 44 24 08 e9 39 80 	movl   $0x8039e9,0x8(%esp)
  80140e:	00 
  80140f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801416:	00 
  801417:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  80141e:	e8 f5 ed ff ff       	call   800218 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801426:	89 44 24 10          	mov    %eax,0x10(%esp)
  80142a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80142e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801435:	00 
  801436:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80143a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801441:	e8 03 fa ff ff       	call   800e49 <sys_page_map>
  801446:	85 c0                	test   %eax,%eax
  801448:	79 20                	jns    80146a <fork+0x15b>
		panic("sys_page_map: %e", r);
  80144a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80144e:	c7 44 24 08 e9 39 80 	movl   $0x8039e9,0x8(%esp)
  801455:	00 
  801456:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  80145d:	00 
  80145e:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  801465:	e8 ae ed ff ff       	call   800218 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  80146a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801470:	eb 06                	jmp    801478 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  801472:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  801478:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  80147e:	0f 86 fa fe ff ff    	jbe    80137e <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801484:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80148b:	00 
  80148c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801493:	ee 
  801494:	89 34 24             	mov    %esi,(%esp)
  801497:	e8 59 f9 ff ff       	call   800df5 <sys_page_alloc>
  80149c:	85 c0                	test   %eax,%eax
  80149e:	79 20                	jns    8014c0 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  8014a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014a4:	c7 44 24 08 ac 35 80 	movl   $0x8035ac,0x8(%esp)
  8014ab:	00 
  8014ac:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  8014b3:	00 
  8014b4:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  8014bb:	e8 58 ed ff ff       	call   800218 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8014c0:	c7 44 24 04 89 31 80 	movl   $0x803189,0x4(%esp)
  8014c7:	00 
  8014c8:	89 34 24             	mov    %esi,(%esp)
  8014cb:	e8 e5 fa ff ff       	call   800fb5 <sys_env_set_pgfault_upcall>
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	79 20                	jns    8014f4 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  8014d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014d8:	c7 44 24 08 58 3a 80 	movl   $0x803a58,0x8(%esp)
  8014df:	00 
  8014e0:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  8014e7:	00 
  8014e8:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  8014ef:	e8 24 ed ff ff       	call   800218 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  8014f4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8014fb:	00 
  8014fc:	89 34 24             	mov    %esi,(%esp)
  8014ff:	e8 0b fa ff ff       	call   800f0f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801504:	89 f0                	mov    %esi,%eax

}
  801506:	83 c4 2c             	add    $0x2c,%esp
  801509:	5b                   	pop    %ebx
  80150a:	5e                   	pop    %esi
  80150b:	5f                   	pop    %edi
  80150c:	5d                   	pop    %ebp
  80150d:	c3                   	ret    

0080150e <sfork>:

// Challenge!
int
sfork(void)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	57                   	push   %edi
  801512:	56                   	push   %esi
  801513:	53                   	push   %ebx
  801514:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801517:	c7 04 24 fe 10 80 00 	movl   $0x8010fe,(%esp)
  80151e:	e8 d3 1b 00 00       	call   8030f6 <set_pgfault_handler>
  801523:	b8 08 00 00 00       	mov    $0x8,%eax
  801528:	cd 30                	int    $0x30
  80152a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  80152c:	85 c0                	test   %eax,%eax
  80152e:	79 20                	jns    801550 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801530:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801534:	c7 44 24 08 34 3a 80 	movl   $0x803a34,0x8(%esp)
  80153b:	00 
  80153c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  801543:	00 
  801544:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  80154b:	e8 c8 ec ff ff       	call   800218 <_panic>
  801550:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801552:	bb 00 00 00 00       	mov    $0x0,%ebx
  801557:	85 c0                	test   %eax,%eax
  801559:	75 2d                	jne    801588 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80155b:	e8 57 f8 ff ff       	call   800db7 <sys_getenvid>
  801560:	25 ff 03 00 00       	and    $0x3ff,%eax
  801565:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801568:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80156d:	a3 08 50 80 00       	mov    %eax,0x805008
		set_pgfault_handler(pgfault);
  801572:	c7 04 24 fe 10 80 00 	movl   $0x8010fe,(%esp)
  801579:	e8 78 1b 00 00       	call   8030f6 <set_pgfault_handler>
		return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
  801583:	e9 1d 01 00 00       	jmp    8016a5 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801588:	89 d8                	mov    %ebx,%eax
  80158a:	c1 e8 16             	shr    $0x16,%eax
  80158d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801594:	a8 01                	test   $0x1,%al
  801596:	74 69                	je     801601 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801598:	89 d8                	mov    %ebx,%eax
  80159a:	c1 e8 0c             	shr    $0xc,%eax
  80159d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015a4:	f6 c2 01             	test   $0x1,%dl
  8015a7:	74 50                	je     8015f9 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  8015a9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  8015b0:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  8015b3:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  8015b9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015c1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8015c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d0:	e8 74 f8 ff ff       	call   800e49 <sys_page_map>
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	79 20                	jns    8015f9 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  8015d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015dd:	c7 44 24 08 e9 39 80 	movl   $0x8039e9,0x8(%esp)
  8015e4:	00 
  8015e5:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8015ec:	00 
  8015ed:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  8015f4:	e8 1f ec ff ff       	call   800218 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8015f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015ff:	eb 06                	jmp    801607 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801601:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801607:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  80160d:	0f 86 75 ff ff ff    	jbe    801588 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801613:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  80161a:	ee 
  80161b:	89 34 24             	mov    %esi,(%esp)
  80161e:	e8 07 fc ff ff       	call   80122a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801623:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80162a:	00 
  80162b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801632:	ee 
  801633:	89 34 24             	mov    %esi,(%esp)
  801636:	e8 ba f7 ff ff       	call   800df5 <sys_page_alloc>
  80163b:	85 c0                	test   %eax,%eax
  80163d:	79 20                	jns    80165f <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  80163f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801643:	c7 44 24 08 ac 35 80 	movl   $0x8035ac,0x8(%esp)
  80164a:	00 
  80164b:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  801652:	00 
  801653:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  80165a:	e8 b9 eb ff ff       	call   800218 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80165f:	c7 44 24 04 89 31 80 	movl   $0x803189,0x4(%esp)
  801666:	00 
  801667:	89 34 24             	mov    %esi,(%esp)
  80166a:	e8 46 f9 ff ff       	call   800fb5 <sys_env_set_pgfault_upcall>
  80166f:	85 c0                	test   %eax,%eax
  801671:	79 20                	jns    801693 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  801673:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801677:	c7 44 24 08 58 3a 80 	movl   $0x803a58,0x8(%esp)
  80167e:	00 
  80167f:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  801686:	00 
  801687:	c7 04 24 de 39 80 00 	movl   $0x8039de,(%esp)
  80168e:	e8 85 eb ff ff       	call   800218 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801693:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80169a:	00 
  80169b:	89 34 24             	mov    %esi,(%esp)
  80169e:	e8 6c f8 ff ff       	call   800f0f <sys_env_set_status>
	return envid;
  8016a3:	89 f0                	mov    %esi,%eax

}
  8016a5:	83 c4 2c             	add    $0x2c,%esp
  8016a8:	5b                   	pop    %ebx
  8016a9:	5e                   	pop    %esi
  8016aa:	5f                   	pop    %edi
  8016ab:	5d                   	pop    %ebp
  8016ac:	c3                   	ret    
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
  80179f:	8b 04 95 f8 3a 80 00 	mov    0x803af8(,%edx,4),%eax
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
  8017ba:	c7 04 24 7c 3a 80 00 	movl   $0x803a7c,(%esp)
  8017c1:	e8 4b eb ff ff       	call   800311 <cprintf>
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
  801849:	e8 4e f6 ff ff       	call   800e9c <sys_page_unmap>
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
  801947:	e8 fd f4 ff ff       	call   800e49 <sys_page_map>
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
  801982:	e8 c2 f4 ff ff       	call   800e49 <sys_page_map>
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
  80199b:	e8 fc f4 ff ff       	call   800e9c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ab:	e8 ec f4 ff ff       	call   800e9c <sys_page_unmap>
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
  801a0f:	c7 04 24 bd 3a 80 00 	movl   $0x803abd,(%esp)
  801a16:	e8 f6 e8 ff ff       	call   800311 <cprintf>
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
  801ae7:	c7 04 24 d9 3a 80 00 	movl   $0x803ad9,(%esp)
  801aee:	e8 1e e8 ff ff       	call   800311 <cprintf>
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
  801ba0:	c7 04 24 9c 3a 80 00 	movl   $0x803a9c,(%esp)
  801ba7:	e8 65 e7 ff ff       	call   800311 <cprintf>
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
  801caf:	e8 cb 15 00 00       	call   80327f <ipc_find_env>
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
  801cd5:	e8 3e 15 00 00       	call   803218 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cda:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ce1:	00 
  801ce2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ce6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ced:	e8 be 14 00 00       	call   8031b0 <ipc_recv>
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
  801d7a:	e8 08 ec ff ff       	call   800987 <strcpy>
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
  801ddb:	e8 44 ed ff ff       	call   800b24 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801de0:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801de7:	00 
  801de8:	c7 04 24 0c 3b 80 00 	movl   $0x803b0c,(%esp)
  801def:	e8 1d e5 ff ff       	call   800311 <cprintf>
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
  801e0b:	c7 44 24 0c 11 3b 80 	movl   $0x803b11,0xc(%esp)
  801e12:	00 
  801e13:	c7 44 24 08 18 3b 80 	movl   $0x803b18,0x8(%esp)
  801e1a:	00 
  801e1b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801e22:	00 
  801e23:	c7 04 24 2d 3b 80 00 	movl   $0x803b2d,(%esp)
  801e2a:	e8 e9 e3 ff ff       	call   800218 <_panic>
	assert(r <= PGSIZE);
  801e2f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e34:	7e 24                	jle    801e5a <devfile_write+0xba>
  801e36:	c7 44 24 0c 38 3b 80 	movl   $0x803b38,0xc(%esp)
  801e3d:	00 
  801e3e:	c7 44 24 08 18 3b 80 	movl   $0x803b18,0x8(%esp)
  801e45:	00 
  801e46:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801e4d:	00 
  801e4e:	c7 04 24 2d 3b 80 00 	movl   $0x803b2d,(%esp)
  801e55:	e8 be e3 ff ff       	call   800218 <_panic>
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
  801e95:	c7 44 24 0c 11 3b 80 	movl   $0x803b11,0xc(%esp)
  801e9c:	00 
  801e9d:	c7 44 24 08 18 3b 80 	movl   $0x803b18,0x8(%esp)
  801ea4:	00 
  801ea5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801eac:	00 
  801ead:	c7 04 24 2d 3b 80 00 	movl   $0x803b2d,(%esp)
  801eb4:	e8 5f e3 ff ff       	call   800218 <_panic>
	assert(r <= PGSIZE);
  801eb9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ebe:	7e 24                	jle    801ee4 <devfile_read+0x84>
  801ec0:	c7 44 24 0c 38 3b 80 	movl   $0x803b38,0xc(%esp)
  801ec7:	00 
  801ec8:	c7 44 24 08 18 3b 80 	movl   $0x803b18,0x8(%esp)
  801ecf:	00 
  801ed0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801ed7:	00 
  801ed8:	c7 04 24 2d 3b 80 00 	movl   $0x803b2d,(%esp)
  801edf:	e8 34 e3 ff ff       	call   800218 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ee4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ee8:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801eef:	00 
  801ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef3:	89 04 24             	mov    %eax,(%esp)
  801ef6:	e8 29 ec ff ff       	call   800b24 <memmove>
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
  801f11:	e8 3a ea ff ff       	call   800950 <strlen>
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
  801f39:	e8 49 ea ff ff       	call   800987 <strcpy>
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
  801fa5:	c7 04 24 44 3b 80 00 	movl   $0x803b44,(%esp)
  801fac:	e8 60 e3 ff ff       	call   800311 <cprintf>

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

00801fd0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	57                   	push   %edi
  801fd4:	56                   	push   %esi
  801fd5:	53                   	push   %ebx
  801fd6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801fdc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fe3:	00 
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	89 04 24             	mov    %eax,(%esp)
  801fea:	e8 15 ff ff ff       	call   801f04 <open>
  801fef:	89 c1                	mov    %eax,%ecx
  801ff1:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	0f 88 41 05 00 00    	js     802540 <spawn+0x570>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801fff:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802006:	00 
  802007:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80200d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802011:	89 0c 24             	mov    %ecx,(%esp)
  802014:	e8 33 fa ff ff       	call   801a4c <readn>
  802019:	3d 00 02 00 00       	cmp    $0x200,%eax
  80201e:	75 0c                	jne    80202c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  802020:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802027:	45 4c 46 
  80202a:	74 36                	je     802062 <spawn+0x92>
		close(fd);
  80202c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802032:	89 04 24             	mov    %eax,(%esp)
  802035:	e8 1d f8 ff ff       	call   801857 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80203a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802041:	46 
  802042:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802048:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204c:	c7 04 24 5d 3b 80 00 	movl   $0x803b5d,(%esp)
  802053:	e8 b9 e2 ff ff       	call   800311 <cprintf>
		return -E_NOT_EXEC;
  802058:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80205d:	e9 3d 05 00 00       	jmp    80259f <spawn+0x5cf>
  802062:	b8 08 00 00 00       	mov    $0x8,%eax
  802067:	cd 30                	int    $0x30
  802069:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80206f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802075:	85 c0                	test   %eax,%eax
  802077:	0f 88 cb 04 00 00    	js     802548 <spawn+0x578>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80207d:	89 c6                	mov    %eax,%esi
  80207f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802085:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802088:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80208e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802094:	b9 11 00 00 00       	mov    $0x11,%ecx
  802099:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80209b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8020a1:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8020a7:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8020ac:	be 00 00 00 00       	mov    $0x0,%esi
  8020b1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8020b4:	eb 0f                	jmp    8020c5 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  8020b6:	89 04 24             	mov    %eax,(%esp)
  8020b9:	e8 92 e8 ff ff       	call   800950 <strlen>
  8020be:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8020c2:	83 c3 01             	add    $0x1,%ebx
  8020c5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8020cc:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	75 e3                	jne    8020b6 <spawn+0xe6>
  8020d3:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8020d9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8020df:	bf 00 10 40 00       	mov    $0x401000,%edi
  8020e4:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8020e6:	89 fa                	mov    %edi,%edx
  8020e8:	83 e2 fc             	and    $0xfffffffc,%edx
  8020eb:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8020f2:	29 c2                	sub    %eax,%edx
  8020f4:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8020fa:	8d 42 f8             	lea    -0x8(%edx),%eax
  8020fd:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802102:	0f 86 50 04 00 00    	jbe    802558 <spawn+0x588>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802108:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80210f:	00 
  802110:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802117:	00 
  802118:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80211f:	e8 d1 ec ff ff       	call   800df5 <sys_page_alloc>
  802124:	85 c0                	test   %eax,%eax
  802126:	0f 88 73 04 00 00    	js     80259f <spawn+0x5cf>
  80212c:	be 00 00 00 00       	mov    $0x0,%esi
  802131:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80213a:	eb 30                	jmp    80216c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  80213c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802142:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802148:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  80214b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80214e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802152:	89 3c 24             	mov    %edi,(%esp)
  802155:	e8 2d e8 ff ff       	call   800987 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80215a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80215d:	89 04 24             	mov    %eax,(%esp)
  802160:	e8 eb e7 ff ff       	call   800950 <strlen>
  802165:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802169:	83 c6 01             	add    $0x1,%esi
  80216c:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  802172:	7c c8                	jl     80213c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802174:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80217a:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802180:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802187:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80218d:	74 24                	je     8021b3 <spawn+0x1e3>
  80218f:	c7 44 24 0c e4 3b 80 	movl   $0x803be4,0xc(%esp)
  802196:	00 
  802197:	c7 44 24 08 18 3b 80 	movl   $0x803b18,0x8(%esp)
  80219e:	00 
  80219f:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  8021a6:	00 
  8021a7:	c7 04 24 77 3b 80 00 	movl   $0x803b77,(%esp)
  8021ae:	e8 65 e0 ff ff       	call   800218 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8021b3:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8021b9:	89 c8                	mov    %ecx,%eax
  8021bb:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8021c0:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8021c3:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8021c9:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8021cc:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  8021d2:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8021d8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8021df:	00 
  8021e0:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  8021e7:	ee 
  8021e8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021f2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021f9:	00 
  8021fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802201:	e8 43 ec ff ff       	call   800e49 <sys_page_map>
  802206:	89 c3                	mov    %eax,%ebx
  802208:	85 c0                	test   %eax,%eax
  80220a:	0f 88 79 03 00 00    	js     802589 <spawn+0x5b9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802210:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802217:	00 
  802218:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80221f:	e8 78 ec ff ff       	call   800e9c <sys_page_unmap>
  802224:	89 c3                	mov    %eax,%ebx
  802226:	85 c0                	test   %eax,%eax
  802228:	0f 88 5b 03 00 00    	js     802589 <spawn+0x5b9>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80222e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802234:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  80223b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802241:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802248:	00 00 00 
  80224b:	e9 b6 01 00 00       	jmp    802406 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  802250:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802256:	83 38 01             	cmpl   $0x1,(%eax)
  802259:	0f 85 99 01 00 00    	jne    8023f8 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80225f:	89 c2                	mov    %eax,%edx
  802261:	8b 40 18             	mov    0x18(%eax),%eax
  802264:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802267:	83 f8 01             	cmp    $0x1,%eax
  80226a:	19 c0                	sbb    %eax,%eax
  80226c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802272:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  802279:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802280:	89 d0                	mov    %edx,%eax
  802282:	8b 4a 04             	mov    0x4(%edx),%ecx
  802285:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  80228b:	8b 52 10             	mov    0x10(%edx),%edx
  80228e:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  802294:	8b 48 14             	mov    0x14(%eax),%ecx
  802297:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  80229d:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8022a0:	89 f0                	mov    %esi,%eax
  8022a2:	25 ff 0f 00 00       	and    $0xfff,%eax
  8022a7:	74 14                	je     8022bd <spawn+0x2ed>
		va -= i;
  8022a9:	29 c6                	sub    %eax,%esi
		memsz += i;
  8022ab:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  8022b1:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  8022b7:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8022bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022c2:	e9 23 01 00 00       	jmp    8023ea <spawn+0x41a>
		if (i >= filesz) {
  8022c7:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8022cd:	77 2b                	ja     8022fa <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8022cf:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8022d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022dd:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8022e3:	89 04 24             	mov    %eax,(%esp)
  8022e6:	e8 0a eb ff ff       	call   800df5 <sys_page_alloc>
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	0f 89 eb 00 00 00    	jns    8023de <spawn+0x40e>
  8022f3:	89 c3                	mov    %eax,%ebx
  8022f5:	e9 6f 02 00 00       	jmp    802569 <spawn+0x599>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8022fa:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802301:	00 
  802302:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802309:	00 
  80230a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802311:	e8 df ea ff ff       	call   800df5 <sys_page_alloc>
  802316:	85 c0                	test   %eax,%eax
  802318:	0f 88 41 02 00 00    	js     80255f <spawn+0x58f>
  80231e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802324:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802326:	89 44 24 04          	mov    %eax,0x4(%esp)
  80232a:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802330:	89 04 24             	mov    %eax,(%esp)
  802333:	e8 ec f7 ff ff       	call   801b24 <seek>
  802338:	85 c0                	test   %eax,%eax
  80233a:	0f 88 23 02 00 00    	js     802563 <spawn+0x593>
  802340:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802346:	29 f9                	sub    %edi,%ecx
  802348:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80234a:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  802350:	ba 00 10 00 00       	mov    $0x1000,%edx
  802355:	0f 47 c2             	cmova  %edx,%eax
  802358:	89 44 24 08          	mov    %eax,0x8(%esp)
  80235c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802363:	00 
  802364:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80236a:	89 04 24             	mov    %eax,(%esp)
  80236d:	e8 da f6 ff ff       	call   801a4c <readn>
  802372:	85 c0                	test   %eax,%eax
  802374:	0f 88 ed 01 00 00    	js     802567 <spawn+0x597>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80237a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802380:	89 44 24 10          	mov    %eax,0x10(%esp)
  802384:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802388:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80238e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802392:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802399:	00 
  80239a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023a1:	e8 a3 ea ff ff       	call   800e49 <sys_page_map>
  8023a6:	85 c0                	test   %eax,%eax
  8023a8:	79 20                	jns    8023ca <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  8023aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ae:	c7 44 24 08 83 3b 80 	movl   $0x803b83,0x8(%esp)
  8023b5:	00 
  8023b6:	c7 44 24 04 a8 01 00 	movl   $0x1a8,0x4(%esp)
  8023bd:	00 
  8023be:	c7 04 24 77 3b 80 00 	movl   $0x803b77,(%esp)
  8023c5:	e8 4e de ff ff       	call   800218 <_panic>
			sys_page_unmap(0, UTEMP);
  8023ca:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023d1:	00 
  8023d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d9:	e8 be ea ff ff       	call   800e9c <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8023de:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8023e4:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8023ea:	89 df                	mov    %ebx,%edi
  8023ec:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  8023f2:	0f 87 cf fe ff ff    	ja     8022c7 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8023f8:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  8023ff:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802406:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80240d:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  802413:	0f 8c 37 fe ff ff    	jl     802250 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802419:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80241f:	89 04 24             	mov    %eax,(%esp)
  802422:	e8 30 f4 ff ff       	call   801857 <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
  802427:	bb 00 00 00 00       	mov    $0x0,%ebx
  80242c:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  802432:	89 d8                	mov    %ebx,%eax
  802434:	c1 e8 16             	shr    $0x16,%eax
  802437:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80243e:	a8 01                	test   $0x1,%al
  802440:	74 76                	je     8024b8 <spawn+0x4e8>
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
  802442:	89 d8                	mov    %ebx,%eax
  802444:	c1 e8 0c             	shr    $0xc,%eax
  802447:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80244e:	f6 c6 04             	test   $0x4,%dh
  802451:	74 5d                	je     8024b0 <spawn+0x4e0>
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  802453:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
				cprintf("\nspawn addr:%p\n",addr);
  80245a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80245e:	c7 04 24 a0 3b 80 00 	movl   $0x803ba0,(%esp)
  802465:	e8 a7 de ff ff       	call   800311 <cprintf>
		if(uvpd[PDX(addr)] & PTE_P)
		{
			if((uvpt[PGNUM(addr)] & PTE_SHARE)) 
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  80246a:	81 e7 07 0e 00 00    	and    $0xe07,%edi
				cprintf("\nspawn addr:%p\n",addr);
				if ((r = sys_page_map(0, (void *)addr, child, (void *)addr, perm)) < 0)
  802470:	89 7c 24 10          	mov    %edi,0x10(%esp)
  802474:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802478:	89 74 24 08          	mov    %esi,0x8(%esp)
  80247c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802480:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802487:	e8 bd e9 ff ff       	call   800e49 <sys_page_map>
  80248c:	85 c0                	test   %eax,%eax
  80248e:	79 20                	jns    8024b0 <spawn+0x4e0>
					panic("sys_page_map: %e", r);
  802490:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802494:	c7 44 24 08 e9 39 80 	movl   $0x8039e9,0x8(%esp)
  80249b:	00 
  80249c:	c7 44 24 04 c2 01 00 	movl   $0x1c2,0x4(%esp)
  8024a3:	00 
  8024a4:	c7 04 24 77 3b 80 00 	movl   $0x803b77,(%esp)
  8024ab:	e8 68 dd ff ff       	call   800218 <_panic>
			}
			addr += PGSIZE;
  8024b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8024b6:	eb 06                	jmp    8024be <spawn+0x4ee>
		}
		else
		{
			addr = addr + PTSIZE;
  8024b8:	81 c3 00 00 40 00    	add    $0x400000,%ebx
{
	// LAB 5: Your code here.
	uintptr_t addr=0;
	int perm = 0;
	int r=-1;
	while(addr<(UXSTACKTOP-PGSIZE))
  8024be:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  8024c4:	0f 86 68 ff ff ff    	jbe    802432 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8024ca:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8024d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d4:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8024da:	89 04 24             	mov    %eax,(%esp)
  8024dd:	e8 80 ea ff ff       	call   800f62 <sys_env_set_trapframe>
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	79 20                	jns    802506 <spawn+0x536>
		panic("sys_env_set_trapframe: %e", r);
  8024e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024ea:	c7 44 24 08 b0 3b 80 	movl   $0x803bb0,0x8(%esp)
  8024f1:	00 
  8024f2:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  8024f9:	00 
  8024fa:	c7 04 24 77 3b 80 00 	movl   $0x803b77,(%esp)
  802501:	e8 12 dd ff ff       	call   800218 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802506:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80250d:	00 
  80250e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802514:	89 04 24             	mov    %eax,(%esp)
  802517:	e8 f3 e9 ff ff       	call   800f0f <sys_env_set_status>
  80251c:	85 c0                	test   %eax,%eax
  80251e:	79 30                	jns    802550 <spawn+0x580>
		panic("sys_env_set_status: %e", r);
  802520:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802524:	c7 44 24 08 ca 3b 80 	movl   $0x803bca,0x8(%esp)
  80252b:	00 
  80252c:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  802533:	00 
  802534:	c7 04 24 77 3b 80 00 	movl   $0x803b77,(%esp)
  80253b:	e8 d8 dc ff ff       	call   800218 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  802540:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802546:	eb 57                	jmp    80259f <spawn+0x5cf>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  802548:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80254e:	eb 4f                	jmp    80259f <spawn+0x5cf>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  802550:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802556:	eb 47                	jmp    80259f <spawn+0x5cf>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802558:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80255d:	eb 40                	jmp    80259f <spawn+0x5cf>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80255f:	89 c3                	mov    %eax,%ebx
  802561:	eb 06                	jmp    802569 <spawn+0x599>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802563:	89 c3                	mov    %eax,%ebx
  802565:	eb 02                	jmp    802569 <spawn+0x599>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802567:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802569:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80256f:	89 04 24             	mov    %eax,(%esp)
  802572:	e8 9c e7 ff ff       	call   800d13 <sys_env_destroy>
	close(fd);
  802577:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80257d:	89 04 24             	mov    %eax,(%esp)
  802580:	e8 d2 f2 ff ff       	call   801857 <close>
	return r;
  802585:	89 d8                	mov    %ebx,%eax
  802587:	eb 16                	jmp    80259f <spawn+0x5cf>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802589:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802590:	00 
  802591:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802598:	e8 ff e8 ff ff       	call   800e9c <sys_page_unmap>
  80259d:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80259f:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  8025a5:	5b                   	pop    %ebx
  8025a6:	5e                   	pop    %esi
  8025a7:	5f                   	pop    %edi
  8025a8:	5d                   	pop    %ebp
  8025a9:	c3                   	ret    

008025aa <exec>:

int
exec(const char *prog, const char **argv)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
	sys_env_destroy(child);
	close(fd);
	return r;*/
	return 0;

}
  8025ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b2:	5d                   	pop    %ebp
  8025b3:	c3                   	ret    

008025b4 <execl>:


int execl(const char *prog, const char *arg0, ...)
{
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8025b7:	8d 45 10             	lea    0x10(%ebp),%eax


int execl(const char *prog, const char *arg0, ...)
{
	//works same as spawnl
	int argc=0;
  8025ba:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8025bf:	eb 03                	jmp    8025c4 <execl+0x10>
		argc++;
  8025c1:	83 c2 01             	add    $0x1,%edx
{
	//works same as spawnl
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8025c4:	83 c0 04             	add    $0x4,%eax
  8025c7:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  8025cb:	75 f4                	jne    8025c1 <execl+0xd>
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8025cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d2:	eb 03                	jmp    8025d7 <execl+0x23>
		argv[i+1] = va_arg(vl, const char *);
  8025d4:	83 c0 01             	add    $0x1,%eax
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8025d7:	39 d0                	cmp    %edx,%eax
  8025d9:	75 f9                	jne    8025d4 <execl+0x20>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
}
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e0:	5d                   	pop    %ebp
  8025e1:	c3                   	ret    

008025e2 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	56                   	push   %esi
  8025e6:	53                   	push   %ebx
  8025e7:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8025ea:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8025ed:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8025f2:	eb 03                	jmp    8025f7 <spawnl+0x15>
		argc++;
  8025f4:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8025f7:	83 c0 04             	add    $0x4,%eax
  8025fa:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  8025fe:	75 f4                	jne    8025f4 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802600:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  802607:	83 e0 f0             	and    $0xfffffff0,%eax
  80260a:	29 c4                	sub    %eax,%esp
  80260c:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802610:	c1 e8 02             	shr    $0x2,%eax
  802613:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  80261a:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80261c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80261f:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  802626:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  80262d:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80262e:	b8 00 00 00 00       	mov    $0x0,%eax
  802633:	eb 0a                	jmp    80263f <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  802635:	83 c0 01             	add    $0x1,%eax
  802638:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  80263c:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80263f:	39 d0                	cmp    %edx,%eax
  802641:	75 f2                	jne    802635 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802643:	89 74 24 04          	mov    %esi,0x4(%esp)
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	89 04 24             	mov    %eax,(%esp)
  80264d:	e8 7e f9 ff ff       	call   801fd0 <spawn>
}
  802652:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802655:	5b                   	pop    %ebx
  802656:	5e                   	pop    %esi
  802657:	5d                   	pop    %ebp
  802658:	c3                   	ret    
  802659:	66 90                	xchg   %ax,%ax
  80265b:	66 90                	xchg   %ax,%ax
  80265d:	66 90                	xchg   %ax,%ax
  80265f:	90                   	nop

00802660 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
  802663:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802666:	c7 44 24 04 0a 3c 80 	movl   $0x803c0a,0x4(%esp)
  80266d:	00 
  80266e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802671:	89 04 24             	mov    %eax,(%esp)
  802674:	e8 0e e3 ff ff       	call   800987 <strcpy>
	return 0;
}
  802679:	b8 00 00 00 00       	mov    $0x0,%eax
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	53                   	push   %ebx
  802684:	83 ec 14             	sub    $0x14,%esp
  802687:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80268a:	89 1c 24             	mov    %ebx,(%esp)
  80268d:	e8 25 0c 00 00       	call   8032b7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802692:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802697:	83 f8 01             	cmp    $0x1,%eax
  80269a:	75 0d                	jne    8026a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80269c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80269f:	89 04 24             	mov    %eax,(%esp)
  8026a2:	e8 29 03 00 00       	call   8029d0 <nsipc_close>
  8026a7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8026a9:	89 d0                	mov    %edx,%eax
  8026ab:	83 c4 14             	add    $0x14,%esp
  8026ae:	5b                   	pop    %ebx
  8026af:	5d                   	pop    %ebp
  8026b0:	c3                   	ret    

008026b1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8026b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8026be:	00 
  8026bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8026c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d3:	89 04 24             	mov    %eax,(%esp)
  8026d6:	e8 f0 03 00 00       	call   802acb <nsipc_send>
}
  8026db:	c9                   	leave  
  8026dc:	c3                   	ret    

008026dd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8026e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8026ea:	00 
  8026eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ff:	89 04 24             	mov    %eax,(%esp)
  802702:	e8 44 03 00 00       	call   802a4b <nsipc_recv>
}
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80270f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802712:	89 54 24 04          	mov    %edx,0x4(%esp)
  802716:	89 04 24             	mov    %eax,(%esp)
  802719:	e8 08 f0 ff ff       	call   801726 <fd_lookup>
  80271e:	85 c0                	test   %eax,%eax
  802720:	78 17                	js     802739 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  80272b:	39 08                	cmp    %ecx,(%eax)
  80272d:	75 05                	jne    802734 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80272f:	8b 40 0c             	mov    0xc(%eax),%eax
  802732:	eb 05                	jmp    802739 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802734:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802739:	c9                   	leave  
  80273a:	c3                   	ret    

0080273b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80273b:	55                   	push   %ebp
  80273c:	89 e5                	mov    %esp,%ebp
  80273e:	56                   	push   %esi
  80273f:	53                   	push   %ebx
  802740:	83 ec 20             	sub    $0x20,%esp
  802743:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802745:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802748:	89 04 24             	mov    %eax,(%esp)
  80274b:	e8 87 ef ff ff       	call   8016d7 <fd_alloc>
  802750:	89 c3                	mov    %eax,%ebx
  802752:	85 c0                	test   %eax,%eax
  802754:	78 21                	js     802777 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802756:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80275d:	00 
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	89 44 24 04          	mov    %eax,0x4(%esp)
  802765:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80276c:	e8 84 e6 ff ff       	call   800df5 <sys_page_alloc>
  802771:	89 c3                	mov    %eax,%ebx
  802773:	85 c0                	test   %eax,%eax
  802775:	79 0c                	jns    802783 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802777:	89 34 24             	mov    %esi,(%esp)
  80277a:	e8 51 02 00 00       	call   8029d0 <nsipc_close>
		return r;
  80277f:	89 d8                	mov    %ebx,%eax
  802781:	eb 20                	jmp    8027a3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802783:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80278e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802791:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802798:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80279b:	89 14 24             	mov    %edx,(%esp)
  80279e:	e8 0d ef ff ff       	call   8016b0 <fd2num>
}
  8027a3:	83 c4 20             	add    $0x20,%esp
  8027a6:	5b                   	pop    %ebx
  8027a7:	5e                   	pop    %esi
  8027a8:	5d                   	pop    %ebp
  8027a9:	c3                   	ret    

008027aa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b3:	e8 51 ff ff ff       	call   802709 <fd2sockid>
		return r;
  8027b8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	78 23                	js     8027e1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8027be:	8b 55 10             	mov    0x10(%ebp),%edx
  8027c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027cc:	89 04 24             	mov    %eax,(%esp)
  8027cf:	e8 45 01 00 00       	call   802919 <nsipc_accept>
		return r;
  8027d4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	78 07                	js     8027e1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8027da:	e8 5c ff ff ff       	call   80273b <alloc_sockfd>
  8027df:	89 c1                	mov    %eax,%ecx
}
  8027e1:	89 c8                	mov    %ecx,%eax
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	e8 16 ff ff ff       	call   802709 <fd2sockid>
  8027f3:	89 c2                	mov    %eax,%edx
  8027f5:	85 d2                	test   %edx,%edx
  8027f7:	78 16                	js     80280f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8027f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8027fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802800:	8b 45 0c             	mov    0xc(%ebp),%eax
  802803:	89 44 24 04          	mov    %eax,0x4(%esp)
  802807:	89 14 24             	mov    %edx,(%esp)
  80280a:	e8 60 01 00 00       	call   80296f <nsipc_bind>
}
  80280f:	c9                   	leave  
  802810:	c3                   	ret    

00802811 <shutdown>:

int
shutdown(int s, int how)
{
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
  802814:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	e8 ea fe ff ff       	call   802709 <fd2sockid>
  80281f:	89 c2                	mov    %eax,%edx
  802821:	85 d2                	test   %edx,%edx
  802823:	78 0f                	js     802834 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802825:	8b 45 0c             	mov    0xc(%ebp),%eax
  802828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80282c:	89 14 24             	mov    %edx,(%esp)
  80282f:	e8 7a 01 00 00       	call   8029ae <nsipc_shutdown>
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80283c:	8b 45 08             	mov    0x8(%ebp),%eax
  80283f:	e8 c5 fe ff ff       	call   802709 <fd2sockid>
  802844:	89 c2                	mov    %eax,%edx
  802846:	85 d2                	test   %edx,%edx
  802848:	78 16                	js     802860 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80284a:	8b 45 10             	mov    0x10(%ebp),%eax
  80284d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802851:	8b 45 0c             	mov    0xc(%ebp),%eax
  802854:	89 44 24 04          	mov    %eax,0x4(%esp)
  802858:	89 14 24             	mov    %edx,(%esp)
  80285b:	e8 8a 01 00 00       	call   8029ea <nsipc_connect>
}
  802860:	c9                   	leave  
  802861:	c3                   	ret    

00802862 <listen>:

int
listen(int s, int backlog)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	e8 99 fe ff ff       	call   802709 <fd2sockid>
  802870:	89 c2                	mov    %eax,%edx
  802872:	85 d2                	test   %edx,%edx
  802874:	78 0f                	js     802885 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802876:	8b 45 0c             	mov    0xc(%ebp),%eax
  802879:	89 44 24 04          	mov    %eax,0x4(%esp)
  80287d:	89 14 24             	mov    %edx,(%esp)
  802880:	e8 a4 01 00 00       	call   802a29 <nsipc_listen>
}
  802885:	c9                   	leave  
  802886:	c3                   	ret    

00802887 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802887:	55                   	push   %ebp
  802888:	89 e5                	mov    %esp,%ebp
  80288a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80288d:	8b 45 10             	mov    0x10(%ebp),%eax
  802890:	89 44 24 08          	mov    %eax,0x8(%esp)
  802894:	8b 45 0c             	mov    0xc(%ebp),%eax
  802897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	89 04 24             	mov    %eax,(%esp)
  8028a1:	e8 98 02 00 00       	call   802b3e <nsipc_socket>
  8028a6:	89 c2                	mov    %eax,%edx
  8028a8:	85 d2                	test   %edx,%edx
  8028aa:	78 05                	js     8028b1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8028ac:	e8 8a fe ff ff       	call   80273b <alloc_sockfd>
}
  8028b1:	c9                   	leave  
  8028b2:	c3                   	ret    

008028b3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
  8028b6:	53                   	push   %ebx
  8028b7:	83 ec 14             	sub    $0x14,%esp
  8028ba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8028bc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8028c3:	75 11                	jne    8028d6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8028c5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8028cc:	e8 ae 09 00 00       	call   80327f <ipc_find_env>
  8028d1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8028d6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8028dd:	00 
  8028de:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8028e5:	00 
  8028e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028ea:	a1 04 50 80 00       	mov    0x805004,%eax
  8028ef:	89 04 24             	mov    %eax,(%esp)
  8028f2:	e8 21 09 00 00       	call   803218 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8028f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8028fe:	00 
  8028ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802906:	00 
  802907:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80290e:	e8 9d 08 00 00       	call   8031b0 <ipc_recv>
}
  802913:	83 c4 14             	add    $0x14,%esp
  802916:	5b                   	pop    %ebx
  802917:	5d                   	pop    %ebp
  802918:	c3                   	ret    

00802919 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802919:	55                   	push   %ebp
  80291a:	89 e5                	mov    %esp,%ebp
  80291c:	56                   	push   %esi
  80291d:	53                   	push   %ebx
  80291e:	83 ec 10             	sub    $0x10,%esp
  802921:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802924:	8b 45 08             	mov    0x8(%ebp),%eax
  802927:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80292c:	8b 06                	mov    (%esi),%eax
  80292e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802933:	b8 01 00 00 00       	mov    $0x1,%eax
  802938:	e8 76 ff ff ff       	call   8028b3 <nsipc>
  80293d:	89 c3                	mov    %eax,%ebx
  80293f:	85 c0                	test   %eax,%eax
  802941:	78 23                	js     802966 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802943:	a1 10 70 80 00       	mov    0x807010,%eax
  802948:	89 44 24 08          	mov    %eax,0x8(%esp)
  80294c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802953:	00 
  802954:	8b 45 0c             	mov    0xc(%ebp),%eax
  802957:	89 04 24             	mov    %eax,(%esp)
  80295a:	e8 c5 e1 ff ff       	call   800b24 <memmove>
		*addrlen = ret->ret_addrlen;
  80295f:	a1 10 70 80 00       	mov    0x807010,%eax
  802964:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802966:	89 d8                	mov    %ebx,%eax
  802968:	83 c4 10             	add    $0x10,%esp
  80296b:	5b                   	pop    %ebx
  80296c:	5e                   	pop    %esi
  80296d:	5d                   	pop    %ebp
  80296e:	c3                   	ret    

0080296f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	53                   	push   %ebx
  802973:	83 ec 14             	sub    $0x14,%esp
  802976:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802981:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802985:	8b 45 0c             	mov    0xc(%ebp),%eax
  802988:	89 44 24 04          	mov    %eax,0x4(%esp)
  80298c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802993:	e8 8c e1 ff ff       	call   800b24 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802998:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80299e:	b8 02 00 00 00       	mov    $0x2,%eax
  8029a3:	e8 0b ff ff ff       	call   8028b3 <nsipc>
}
  8029a8:	83 c4 14             	add    $0x14,%esp
  8029ab:	5b                   	pop    %ebx
  8029ac:	5d                   	pop    %ebp
  8029ad:	c3                   	ret    

008029ae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
  8029b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8029bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029bf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8029c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8029c9:	e8 e5 fe ff ff       	call   8028b3 <nsipc>
}
  8029ce:	c9                   	leave  
  8029cf:	c3                   	ret    

008029d0 <nsipc_close>:

int
nsipc_close(int s)
{
  8029d0:	55                   	push   %ebp
  8029d1:	89 e5                	mov    %esp,%ebp
  8029d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8029de:	b8 04 00 00 00       	mov    $0x4,%eax
  8029e3:	e8 cb fe ff ff       	call   8028b3 <nsipc>
}
  8029e8:	c9                   	leave  
  8029e9:	c3                   	ret    

008029ea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8029ea:	55                   	push   %ebp
  8029eb:	89 e5                	mov    %esp,%ebp
  8029ed:	53                   	push   %ebx
  8029ee:	83 ec 14             	sub    $0x14,%esp
  8029f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8029fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a07:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802a0e:	e8 11 e1 ff ff       	call   800b24 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802a13:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802a19:	b8 05 00 00 00       	mov    $0x5,%eax
  802a1e:	e8 90 fe ff ff       	call   8028b3 <nsipc>
}
  802a23:	83 c4 14             	add    $0x14,%esp
  802a26:	5b                   	pop    %ebx
  802a27:	5d                   	pop    %ebp
  802a28:	c3                   	ret    

00802a29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802a29:	55                   	push   %ebp
  802a2a:	89 e5                	mov    %esp,%ebp
  802a2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a3a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802a3f:	b8 06 00 00 00       	mov    $0x6,%eax
  802a44:	e8 6a fe ff ff       	call   8028b3 <nsipc>
}
  802a49:	c9                   	leave  
  802a4a:	c3                   	ret    

00802a4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
  802a4e:	56                   	push   %esi
  802a4f:	53                   	push   %ebx
  802a50:	83 ec 10             	sub    $0x10,%esp
  802a53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802a5e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802a64:	8b 45 14             	mov    0x14(%ebp),%eax
  802a67:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802a6c:	b8 07 00 00 00       	mov    $0x7,%eax
  802a71:	e8 3d fe ff ff       	call   8028b3 <nsipc>
  802a76:	89 c3                	mov    %eax,%ebx
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	78 46                	js     802ac2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802a7c:	39 f0                	cmp    %esi,%eax
  802a7e:	7f 07                	jg     802a87 <nsipc_recv+0x3c>
  802a80:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802a85:	7e 24                	jle    802aab <nsipc_recv+0x60>
  802a87:	c7 44 24 0c 16 3c 80 	movl   $0x803c16,0xc(%esp)
  802a8e:	00 
  802a8f:	c7 44 24 08 18 3b 80 	movl   $0x803b18,0x8(%esp)
  802a96:	00 
  802a97:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  802a9e:	00 
  802a9f:	c7 04 24 2b 3c 80 00 	movl   $0x803c2b,(%esp)
  802aa6:	e8 6d d7 ff ff       	call   800218 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802aab:	89 44 24 08          	mov    %eax,0x8(%esp)
  802aaf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802ab6:	00 
  802ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aba:	89 04 24             	mov    %eax,(%esp)
  802abd:	e8 62 e0 ff ff       	call   800b24 <memmove>
	}

	return r;
}
  802ac2:	89 d8                	mov    %ebx,%eax
  802ac4:	83 c4 10             	add    $0x10,%esp
  802ac7:	5b                   	pop    %ebx
  802ac8:	5e                   	pop    %esi
  802ac9:	5d                   	pop    %ebp
  802aca:	c3                   	ret    

00802acb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802acb:	55                   	push   %ebp
  802acc:	89 e5                	mov    %esp,%ebp
  802ace:	53                   	push   %ebx
  802acf:	83 ec 14             	sub    $0x14,%esp
  802ad2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802add:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802ae3:	7e 24                	jle    802b09 <nsipc_send+0x3e>
  802ae5:	c7 44 24 0c 37 3c 80 	movl   $0x803c37,0xc(%esp)
  802aec:	00 
  802aed:	c7 44 24 08 18 3b 80 	movl   $0x803b18,0x8(%esp)
  802af4:	00 
  802af5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  802afc:	00 
  802afd:	c7 04 24 2b 3c 80 00 	movl   $0x803c2b,(%esp)
  802b04:	e8 0f d7 ff ff       	call   800218 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802b09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b14:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  802b1b:	e8 04 e0 ff ff       	call   800b24 <memmove>
	nsipcbuf.send.req_size = size;
  802b20:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802b26:	8b 45 14             	mov    0x14(%ebp),%eax
  802b29:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802b2e:	b8 08 00 00 00       	mov    $0x8,%eax
  802b33:	e8 7b fd ff ff       	call   8028b3 <nsipc>
}
  802b38:	83 c4 14             	add    $0x14,%esp
  802b3b:	5b                   	pop    %ebx
  802b3c:	5d                   	pop    %ebp
  802b3d:	c3                   	ret    

00802b3e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802b3e:	55                   	push   %ebp
  802b3f:	89 e5                	mov    %esp,%ebp
  802b41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b4f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802b54:	8b 45 10             	mov    0x10(%ebp),%eax
  802b57:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802b5c:	b8 09 00 00 00       	mov    $0x9,%eax
  802b61:	e8 4d fd ff ff       	call   8028b3 <nsipc>
}
  802b66:	c9                   	leave  
  802b67:	c3                   	ret    

00802b68 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802b68:	55                   	push   %ebp
  802b69:	89 e5                	mov    %esp,%ebp
  802b6b:	56                   	push   %esi
  802b6c:	53                   	push   %ebx
  802b6d:	83 ec 10             	sub    $0x10,%esp
  802b70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	89 04 24             	mov    %eax,(%esp)
  802b79:	e8 42 eb ff ff       	call   8016c0 <fd2data>
  802b7e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802b80:	c7 44 24 04 43 3c 80 	movl   $0x803c43,0x4(%esp)
  802b87:	00 
  802b88:	89 1c 24             	mov    %ebx,(%esp)
  802b8b:	e8 f7 dd ff ff       	call   800987 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802b90:	8b 46 04             	mov    0x4(%esi),%eax
  802b93:	2b 06                	sub    (%esi),%eax
  802b95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802b9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802ba2:	00 00 00 
	stat->st_dev = &devpipe;
  802ba5:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  802bac:	40 80 00 
	return 0;
}
  802baf:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb4:	83 c4 10             	add    $0x10,%esp
  802bb7:	5b                   	pop    %ebx
  802bb8:	5e                   	pop    %esi
  802bb9:	5d                   	pop    %ebp
  802bba:	c3                   	ret    

00802bbb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802bbb:	55                   	push   %ebp
  802bbc:	89 e5                	mov    %esp,%ebp
  802bbe:	53                   	push   %ebx
  802bbf:	83 ec 14             	sub    $0x14,%esp
  802bc2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802bc5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802bc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bd0:	e8 c7 e2 ff ff       	call   800e9c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802bd5:	89 1c 24             	mov    %ebx,(%esp)
  802bd8:	e8 e3 ea ff ff       	call   8016c0 <fd2data>
  802bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802be1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802be8:	e8 af e2 ff ff       	call   800e9c <sys_page_unmap>
}
  802bed:	83 c4 14             	add    $0x14,%esp
  802bf0:	5b                   	pop    %ebx
  802bf1:	5d                   	pop    %ebp
  802bf2:	c3                   	ret    

00802bf3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802bf3:	55                   	push   %ebp
  802bf4:	89 e5                	mov    %esp,%ebp
  802bf6:	57                   	push   %edi
  802bf7:	56                   	push   %esi
  802bf8:	53                   	push   %ebx
  802bf9:	83 ec 2c             	sub    $0x2c,%esp
  802bfc:	89 c6                	mov    %eax,%esi
  802bfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c01:	a1 08 50 80 00       	mov    0x805008,%eax
  802c06:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802c09:	89 34 24             	mov    %esi,(%esp)
  802c0c:	e8 a6 06 00 00       	call   8032b7 <pageref>
  802c11:	89 c7                	mov    %eax,%edi
  802c13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c16:	89 04 24             	mov    %eax,(%esp)
  802c19:	e8 99 06 00 00       	call   8032b7 <pageref>
  802c1e:	39 c7                	cmp    %eax,%edi
  802c20:	0f 94 c2             	sete   %dl
  802c23:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802c26:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  802c2c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802c2f:	39 fb                	cmp    %edi,%ebx
  802c31:	74 21                	je     802c54 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802c33:	84 d2                	test   %dl,%dl
  802c35:	74 ca                	je     802c01 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c37:	8b 51 58             	mov    0x58(%ecx),%edx
  802c3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c3e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802c46:	c7 04 24 4a 3c 80 00 	movl   $0x803c4a,(%esp)
  802c4d:	e8 bf d6 ff ff       	call   800311 <cprintf>
  802c52:	eb ad                	jmp    802c01 <_pipeisclosed+0xe>
	}
}
  802c54:	83 c4 2c             	add    $0x2c,%esp
  802c57:	5b                   	pop    %ebx
  802c58:	5e                   	pop    %esi
  802c59:	5f                   	pop    %edi
  802c5a:	5d                   	pop    %ebp
  802c5b:	c3                   	ret    

00802c5c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802c5c:	55                   	push   %ebp
  802c5d:	89 e5                	mov    %esp,%ebp
  802c5f:	57                   	push   %edi
  802c60:	56                   	push   %esi
  802c61:	53                   	push   %ebx
  802c62:	83 ec 1c             	sub    $0x1c,%esp
  802c65:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802c68:	89 34 24             	mov    %esi,(%esp)
  802c6b:	e8 50 ea ff ff       	call   8016c0 <fd2data>
  802c70:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802c72:	bf 00 00 00 00       	mov    $0x0,%edi
  802c77:	eb 45                	jmp    802cbe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802c79:	89 da                	mov    %ebx,%edx
  802c7b:	89 f0                	mov    %esi,%eax
  802c7d:	e8 71 ff ff ff       	call   802bf3 <_pipeisclosed>
  802c82:	85 c0                	test   %eax,%eax
  802c84:	75 41                	jne    802cc7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802c86:	e8 4b e1 ff ff       	call   800dd6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802c8b:	8b 43 04             	mov    0x4(%ebx),%eax
  802c8e:	8b 0b                	mov    (%ebx),%ecx
  802c90:	8d 51 20             	lea    0x20(%ecx),%edx
  802c93:	39 d0                	cmp    %edx,%eax
  802c95:	73 e2                	jae    802c79 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c9a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802c9e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802ca1:	99                   	cltd   
  802ca2:	c1 ea 1b             	shr    $0x1b,%edx
  802ca5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802ca8:	83 e1 1f             	and    $0x1f,%ecx
  802cab:	29 d1                	sub    %edx,%ecx
  802cad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802cb1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802cb5:	83 c0 01             	add    $0x1,%eax
  802cb8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802cbb:	83 c7 01             	add    $0x1,%edi
  802cbe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802cc1:	75 c8                	jne    802c8b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802cc3:	89 f8                	mov    %edi,%eax
  802cc5:	eb 05                	jmp    802ccc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802cc7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802ccc:	83 c4 1c             	add    $0x1c,%esp
  802ccf:	5b                   	pop    %ebx
  802cd0:	5e                   	pop    %esi
  802cd1:	5f                   	pop    %edi
  802cd2:	5d                   	pop    %ebp
  802cd3:	c3                   	ret    

00802cd4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802cd4:	55                   	push   %ebp
  802cd5:	89 e5                	mov    %esp,%ebp
  802cd7:	57                   	push   %edi
  802cd8:	56                   	push   %esi
  802cd9:	53                   	push   %ebx
  802cda:	83 ec 1c             	sub    $0x1c,%esp
  802cdd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802ce0:	89 3c 24             	mov    %edi,(%esp)
  802ce3:	e8 d8 e9 ff ff       	call   8016c0 <fd2data>
  802ce8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802cea:	be 00 00 00 00       	mov    $0x0,%esi
  802cef:	eb 3d                	jmp    802d2e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802cf1:	85 f6                	test   %esi,%esi
  802cf3:	74 04                	je     802cf9 <devpipe_read+0x25>
				return i;
  802cf5:	89 f0                	mov    %esi,%eax
  802cf7:	eb 43                	jmp    802d3c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802cf9:	89 da                	mov    %ebx,%edx
  802cfb:	89 f8                	mov    %edi,%eax
  802cfd:	e8 f1 fe ff ff       	call   802bf3 <_pipeisclosed>
  802d02:	85 c0                	test   %eax,%eax
  802d04:	75 31                	jne    802d37 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802d06:	e8 cb e0 ff ff       	call   800dd6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802d0b:	8b 03                	mov    (%ebx),%eax
  802d0d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802d10:	74 df                	je     802cf1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d12:	99                   	cltd   
  802d13:	c1 ea 1b             	shr    $0x1b,%edx
  802d16:	01 d0                	add    %edx,%eax
  802d18:	83 e0 1f             	and    $0x1f,%eax
  802d1b:	29 d0                	sub    %edx,%eax
  802d1d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d25:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802d28:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d2b:	83 c6 01             	add    $0x1,%esi
  802d2e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d31:	75 d8                	jne    802d0b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802d33:	89 f0                	mov    %esi,%eax
  802d35:	eb 05                	jmp    802d3c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802d37:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802d3c:	83 c4 1c             	add    $0x1c,%esp
  802d3f:	5b                   	pop    %ebx
  802d40:	5e                   	pop    %esi
  802d41:	5f                   	pop    %edi
  802d42:	5d                   	pop    %ebp
  802d43:	c3                   	ret    

00802d44 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802d44:	55                   	push   %ebp
  802d45:	89 e5                	mov    %esp,%ebp
  802d47:	56                   	push   %esi
  802d48:	53                   	push   %ebx
  802d49:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802d4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d4f:	89 04 24             	mov    %eax,(%esp)
  802d52:	e8 80 e9 ff ff       	call   8016d7 <fd_alloc>
  802d57:	89 c2                	mov    %eax,%edx
  802d59:	85 d2                	test   %edx,%edx
  802d5b:	0f 88 4d 01 00 00    	js     802eae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d61:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d68:	00 
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d77:	e8 79 e0 ff ff       	call   800df5 <sys_page_alloc>
  802d7c:	89 c2                	mov    %eax,%edx
  802d7e:	85 d2                	test   %edx,%edx
  802d80:	0f 88 28 01 00 00    	js     802eae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802d86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d89:	89 04 24             	mov    %eax,(%esp)
  802d8c:	e8 46 e9 ff ff       	call   8016d7 <fd_alloc>
  802d91:	89 c3                	mov    %eax,%ebx
  802d93:	85 c0                	test   %eax,%eax
  802d95:	0f 88 fe 00 00 00    	js     802e99 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d9b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802da2:	00 
  802da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802daa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802db1:	e8 3f e0 ff ff       	call   800df5 <sys_page_alloc>
  802db6:	89 c3                	mov    %eax,%ebx
  802db8:	85 c0                	test   %eax,%eax
  802dba:	0f 88 d9 00 00 00    	js     802e99 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc3:	89 04 24             	mov    %eax,(%esp)
  802dc6:	e8 f5 e8 ff ff       	call   8016c0 <fd2data>
  802dcb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dcd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802dd4:	00 
  802dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802de0:	e8 10 e0 ff ff       	call   800df5 <sys_page_alloc>
  802de5:	89 c3                	mov    %eax,%ebx
  802de7:	85 c0                	test   %eax,%eax
  802de9:	0f 88 97 00 00 00    	js     802e86 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df2:	89 04 24             	mov    %eax,(%esp)
  802df5:	e8 c6 e8 ff ff       	call   8016c0 <fd2data>
  802dfa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802e01:	00 
  802e02:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802e0d:	00 
  802e0e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e19:	e8 2b e0 ff ff       	call   800e49 <sys_page_map>
  802e1e:	89 c3                	mov    %eax,%ebx
  802e20:	85 c0                	test   %eax,%eax
  802e22:	78 52                	js     802e76 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802e24:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802e39:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e42:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e47:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	89 04 24             	mov    %eax,(%esp)
  802e54:	e8 57 e8 ff ff       	call   8016b0 <fd2num>
  802e59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e5c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e61:	89 04 24             	mov    %eax,(%esp)
  802e64:	e8 47 e8 ff ff       	call   8016b0 <fd2num>
  802e69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e6c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e74:	eb 38                	jmp    802eae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802e76:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e81:	e8 16 e0 ff ff       	call   800e9c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e89:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e94:	e8 03 e0 ff ff       	call   800e9c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ea0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ea7:	e8 f0 df ff ff       	call   800e9c <sys_page_unmap>
  802eac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802eae:	83 c4 30             	add    $0x30,%esp
  802eb1:	5b                   	pop    %ebx
  802eb2:	5e                   	pop    %esi
  802eb3:	5d                   	pop    %ebp
  802eb4:	c3                   	ret    

00802eb5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802eb5:	55                   	push   %ebp
  802eb6:	89 e5                	mov    %esp,%ebp
  802eb8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ebb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	89 04 24             	mov    %eax,(%esp)
  802ec8:	e8 59 e8 ff ff       	call   801726 <fd_lookup>
  802ecd:	89 c2                	mov    %eax,%edx
  802ecf:	85 d2                	test   %edx,%edx
  802ed1:	78 15                	js     802ee8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	89 04 24             	mov    %eax,(%esp)
  802ed9:	e8 e2 e7 ff ff       	call   8016c0 <fd2data>
	return _pipeisclosed(fd, p);
  802ede:	89 c2                	mov    %eax,%edx
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	e8 0b fd ff ff       	call   802bf3 <_pipeisclosed>
}
  802ee8:	c9                   	leave  
  802ee9:	c3                   	ret    

00802eea <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802eea:	55                   	push   %ebp
  802eeb:	89 e5                	mov    %esp,%ebp
  802eed:	56                   	push   %esi
  802eee:	53                   	push   %ebx
  802eef:	83 ec 10             	sub    $0x10,%esp
  802ef2:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802ef5:	85 f6                	test   %esi,%esi
  802ef7:	75 24                	jne    802f1d <wait+0x33>
  802ef9:	c7 44 24 0c 62 3c 80 	movl   $0x803c62,0xc(%esp)
  802f00:	00 
  802f01:	c7 44 24 08 18 3b 80 	movl   $0x803b18,0x8(%esp)
  802f08:	00 
  802f09:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802f10:	00 
  802f11:	c7 04 24 6d 3c 80 00 	movl   $0x803c6d,(%esp)
  802f18:	e8 fb d2 ff ff       	call   800218 <_panic>
	e = &envs[ENVX(envid)];
  802f1d:	89 f3                	mov    %esi,%ebx
  802f1f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802f25:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802f28:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802f2e:	eb 05                	jmp    802f35 <wait+0x4b>
		sys_yield();
  802f30:	e8 a1 de ff ff       	call   800dd6 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802f35:	8b 43 48             	mov    0x48(%ebx),%eax
  802f38:	39 f0                	cmp    %esi,%eax
  802f3a:	75 07                	jne    802f43 <wait+0x59>
  802f3c:	8b 43 54             	mov    0x54(%ebx),%eax
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	75 ed                	jne    802f30 <wait+0x46>
		sys_yield();
}
  802f43:	83 c4 10             	add    $0x10,%esp
  802f46:	5b                   	pop    %ebx
  802f47:	5e                   	pop    %esi
  802f48:	5d                   	pop    %ebp
  802f49:	c3                   	ret    
  802f4a:	66 90                	xchg   %ax,%ax
  802f4c:	66 90                	xchg   %ax,%ax
  802f4e:	66 90                	xchg   %ax,%ax

00802f50 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802f50:	55                   	push   %ebp
  802f51:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802f53:	b8 00 00 00 00       	mov    $0x0,%eax
  802f58:	5d                   	pop    %ebp
  802f59:	c3                   	ret    

00802f5a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802f5a:	55                   	push   %ebp
  802f5b:	89 e5                	mov    %esp,%ebp
  802f5d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802f60:	c7 44 24 04 78 3c 80 	movl   $0x803c78,0x4(%esp)
  802f67:	00 
  802f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6b:	89 04 24             	mov    %eax,(%esp)
  802f6e:	e8 14 da ff ff       	call   800987 <strcpy>
	return 0;
}
  802f73:	b8 00 00 00 00       	mov    $0x0,%eax
  802f78:	c9                   	leave  
  802f79:	c3                   	ret    

00802f7a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802f7a:	55                   	push   %ebp
  802f7b:	89 e5                	mov    %esp,%ebp
  802f7d:	57                   	push   %edi
  802f7e:	56                   	push   %esi
  802f7f:	53                   	push   %ebx
  802f80:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802f86:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802f8b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802f91:	eb 31                	jmp    802fc4 <devcons_write+0x4a>
		m = n - tot;
  802f93:	8b 75 10             	mov    0x10(%ebp),%esi
  802f96:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802f98:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802f9b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802fa0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802fa3:	89 74 24 08          	mov    %esi,0x8(%esp)
  802fa7:	03 45 0c             	add    0xc(%ebp),%eax
  802faa:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fae:	89 3c 24             	mov    %edi,(%esp)
  802fb1:	e8 6e db ff ff       	call   800b24 <memmove>
		sys_cputs(buf, m);
  802fb6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802fba:	89 3c 24             	mov    %edi,(%esp)
  802fbd:	e8 14 dd ff ff       	call   800cd6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802fc2:	01 f3                	add    %esi,%ebx
  802fc4:	89 d8                	mov    %ebx,%eax
  802fc6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802fc9:	72 c8                	jb     802f93 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802fcb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802fd1:	5b                   	pop    %ebx
  802fd2:	5e                   	pop    %esi
  802fd3:	5f                   	pop    %edi
  802fd4:	5d                   	pop    %ebp
  802fd5:	c3                   	ret    

00802fd6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802fd6:	55                   	push   %ebp
  802fd7:	89 e5                	mov    %esp,%ebp
  802fd9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802fdc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802fe1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802fe5:	75 07                	jne    802fee <devcons_read+0x18>
  802fe7:	eb 2a                	jmp    803013 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802fe9:	e8 e8 dd ff ff       	call   800dd6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802fee:	66 90                	xchg   %ax,%ax
  802ff0:	e8 ff dc ff ff       	call   800cf4 <sys_cgetc>
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	74 f0                	je     802fe9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802ff9:	85 c0                	test   %eax,%eax
  802ffb:	78 16                	js     803013 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802ffd:	83 f8 04             	cmp    $0x4,%eax
  803000:	74 0c                	je     80300e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  803002:	8b 55 0c             	mov    0xc(%ebp),%edx
  803005:	88 02                	mov    %al,(%edx)
	return 1;
  803007:	b8 01 00 00 00       	mov    $0x1,%eax
  80300c:	eb 05                	jmp    803013 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80300e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803013:	c9                   	leave  
  803014:	c3                   	ret    

00803015 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803015:	55                   	push   %ebp
  803016:	89 e5                	mov    %esp,%ebp
  803018:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803021:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803028:	00 
  803029:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80302c:	89 04 24             	mov    %eax,(%esp)
  80302f:	e8 a2 dc ff ff       	call   800cd6 <sys_cputs>
}
  803034:	c9                   	leave  
  803035:	c3                   	ret    

00803036 <getchar>:

int
getchar(void)
{
  803036:	55                   	push   %ebp
  803037:	89 e5                	mov    %esp,%ebp
  803039:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80303c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803043:	00 
  803044:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803047:	89 44 24 04          	mov    %eax,0x4(%esp)
  80304b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803052:	e8 63 e9 ff ff       	call   8019ba <read>
	if (r < 0)
  803057:	85 c0                	test   %eax,%eax
  803059:	78 0f                	js     80306a <getchar+0x34>
		return r;
	if (r < 1)
  80305b:	85 c0                	test   %eax,%eax
  80305d:	7e 06                	jle    803065 <getchar+0x2f>
		return -E_EOF;
	return c;
  80305f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803063:	eb 05                	jmp    80306a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803065:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80306a:	c9                   	leave  
  80306b:	c3                   	ret    

0080306c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80306c:	55                   	push   %ebp
  80306d:	89 e5                	mov    %esp,%ebp
  80306f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803072:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803075:	89 44 24 04          	mov    %eax,0x4(%esp)
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	89 04 24             	mov    %eax,(%esp)
  80307f:	e8 a2 e6 ff ff       	call   801726 <fd_lookup>
  803084:	85 c0                	test   %eax,%eax
  803086:	78 11                	js     803099 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 15 60 40 80 00    	mov    0x804060,%edx
  803091:	39 10                	cmp    %edx,(%eax)
  803093:	0f 94 c0             	sete   %al
  803096:	0f b6 c0             	movzbl %al,%eax
}
  803099:	c9                   	leave  
  80309a:	c3                   	ret    

0080309b <opencons>:

int
opencons(void)
{
  80309b:	55                   	push   %ebp
  80309c:	89 e5                	mov    %esp,%ebp
  80309e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8030a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030a4:	89 04 24             	mov    %eax,(%esp)
  8030a7:	e8 2b e6 ff ff       	call   8016d7 <fd_alloc>
		return r;
  8030ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	78 40                	js     8030f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8030b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8030b9:	00 
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030c8:	e8 28 dd ff ff       	call   800df5 <sys_page_alloc>
		return r;
  8030cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8030cf:	85 c0                	test   %eax,%eax
  8030d1:	78 1f                	js     8030f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8030d3:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8030e8:	89 04 24             	mov    %eax,(%esp)
  8030eb:	e8 c0 e5 ff ff       	call   8016b0 <fd2num>
  8030f0:	89 c2                	mov    %eax,%edx
}
  8030f2:	89 d0                	mov    %edx,%eax
  8030f4:	c9                   	leave  
  8030f5:	c3                   	ret    

008030f6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8030f6:	55                   	push   %ebp
  8030f7:	89 e5                	mov    %esp,%ebp
  8030f9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8030fc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  803103:	75 7a                	jne    80317f <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  803105:	e8 ad dc ff ff       	call   800db7 <sys_getenvid>
  80310a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803111:	00 
  803112:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803119:	ee 
  80311a:	89 04 24             	mov    %eax,(%esp)
  80311d:	e8 d3 dc ff ff       	call   800df5 <sys_page_alloc>
  803122:	85 c0                	test   %eax,%eax
  803124:	79 20                	jns    803146 <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  803126:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80312a:	c7 44 24 08 ac 35 80 	movl   $0x8035ac,0x8(%esp)
  803131:	00 
  803132:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  803139:	00 
  80313a:	c7 04 24 84 3c 80 00 	movl   $0x803c84,(%esp)
  803141:	e8 d2 d0 ff ff       	call   800218 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  803146:	e8 6c dc ff ff       	call   800db7 <sys_getenvid>
  80314b:	c7 44 24 04 89 31 80 	movl   $0x803189,0x4(%esp)
  803152:	00 
  803153:	89 04 24             	mov    %eax,(%esp)
  803156:	e8 5a de ff ff       	call   800fb5 <sys_env_set_pgfault_upcall>
  80315b:	85 c0                	test   %eax,%eax
  80315d:	79 20                	jns    80317f <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  80315f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803163:	c7 44 24 08 58 3a 80 	movl   $0x803a58,0x8(%esp)
  80316a:	00 
  80316b:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  803172:	00 
  803173:	c7 04 24 84 3c 80 00 	movl   $0x803c84,(%esp)
  80317a:	e8 99 d0 ff ff       	call   800218 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	a3 00 80 80 00       	mov    %eax,0x808000
}
  803187:	c9                   	leave  
  803188:	c3                   	ret    

00803189 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803189:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80318a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80318f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803191:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  803194:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  803198:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80319c:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  80319f:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  8031a3:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  8031a5:	83 c4 08             	add    $0x8,%esp
	popal
  8031a8:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  8031a9:	83 c4 04             	add    $0x4,%esp
	popfl
  8031ac:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8031ad:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8031ae:	c3                   	ret    
  8031af:	90                   	nop

008031b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8031b0:	55                   	push   %ebp
  8031b1:	89 e5                	mov    %esp,%ebp
  8031b3:	56                   	push   %esi
  8031b4:	53                   	push   %ebx
  8031b5:	83 ec 10             	sub    $0x10,%esp
  8031b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8031bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8031c1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8031c3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8031c8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8031cb:	89 04 24             	mov    %eax,(%esp)
  8031ce:	e8 58 de ff ff       	call   80102b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	75 26                	jne    8031fd <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8031d7:	85 f6                	test   %esi,%esi
  8031d9:	74 0a                	je     8031e5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8031db:	a1 08 50 80 00       	mov    0x805008,%eax
  8031e0:	8b 40 74             	mov    0x74(%eax),%eax
  8031e3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  8031e5:	85 db                	test   %ebx,%ebx
  8031e7:	74 0a                	je     8031f3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  8031e9:	a1 08 50 80 00       	mov    0x805008,%eax
  8031ee:	8b 40 78             	mov    0x78(%eax),%eax
  8031f1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8031f3:	a1 08 50 80 00       	mov    0x805008,%eax
  8031f8:	8b 40 70             	mov    0x70(%eax),%eax
  8031fb:	eb 14                	jmp    803211 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  8031fd:	85 f6                	test   %esi,%esi
  8031ff:	74 06                	je     803207 <ipc_recv+0x57>
			*from_env_store = 0;
  803201:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  803207:	85 db                	test   %ebx,%ebx
  803209:	74 06                	je     803211 <ipc_recv+0x61>
			*perm_store = 0;
  80320b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  803211:	83 c4 10             	add    $0x10,%esp
  803214:	5b                   	pop    %ebx
  803215:	5e                   	pop    %esi
  803216:	5d                   	pop    %ebp
  803217:	c3                   	ret    

00803218 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803218:	55                   	push   %ebp
  803219:	89 e5                	mov    %esp,%ebp
  80321b:	57                   	push   %edi
  80321c:	56                   	push   %esi
  80321d:	53                   	push   %ebx
  80321e:	83 ec 1c             	sub    $0x1c,%esp
  803221:	8b 7d 08             	mov    0x8(%ebp),%edi
  803224:	8b 75 0c             	mov    0xc(%ebp),%esi
  803227:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80322a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80322c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  803231:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  803234:	8b 45 14             	mov    0x14(%ebp),%eax
  803237:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80323b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80323f:	89 74 24 04          	mov    %esi,0x4(%esp)
  803243:	89 3c 24             	mov    %edi,(%esp)
  803246:	e8 bd dd ff ff       	call   801008 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80324b:	85 c0                	test   %eax,%eax
  80324d:	74 28                	je     803277 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80324f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803252:	74 1c                	je     803270 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  803254:	c7 44 24 08 94 3c 80 	movl   $0x803c94,0x8(%esp)
  80325b:	00 
  80325c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  803263:	00 
  803264:	c7 04 24 b8 3c 80 00 	movl   $0x803cb8,(%esp)
  80326b:	e8 a8 cf ff ff       	call   800218 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  803270:	e8 61 db ff ff       	call   800dd6 <sys_yield>
	}
  803275:	eb bd                	jmp    803234 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  803277:	83 c4 1c             	add    $0x1c,%esp
  80327a:	5b                   	pop    %ebx
  80327b:	5e                   	pop    %esi
  80327c:	5f                   	pop    %edi
  80327d:	5d                   	pop    %ebp
  80327e:	c3                   	ret    

0080327f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80327f:	55                   	push   %ebp
  803280:	89 e5                	mov    %esp,%ebp
  803282:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803285:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80328a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80328d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803293:	8b 52 50             	mov    0x50(%edx),%edx
  803296:	39 ca                	cmp    %ecx,%edx
  803298:	75 0d                	jne    8032a7 <ipc_find_env+0x28>
			return envs[i].env_id;
  80329a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80329d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8032a2:	8b 40 40             	mov    0x40(%eax),%eax
  8032a5:	eb 0e                	jmp    8032b5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8032a7:	83 c0 01             	add    $0x1,%eax
  8032aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8032af:	75 d9                	jne    80328a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8032b1:	66 b8 00 00          	mov    $0x0,%ax
}
  8032b5:	5d                   	pop    %ebp
  8032b6:	c3                   	ret    

008032b7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8032b7:	55                   	push   %ebp
  8032b8:	89 e5                	mov    %esp,%ebp
  8032ba:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8032bd:	89 d0                	mov    %edx,%eax
  8032bf:	c1 e8 16             	shr    $0x16,%eax
  8032c2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8032c9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8032ce:	f6 c1 01             	test   $0x1,%cl
  8032d1:	74 1d                	je     8032f0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8032d3:	c1 ea 0c             	shr    $0xc,%edx
  8032d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8032dd:	f6 c2 01             	test   $0x1,%dl
  8032e0:	74 0e                	je     8032f0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8032e2:	c1 ea 0c             	shr    $0xc,%edx
  8032e5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8032ec:	ef 
  8032ed:	0f b7 c0             	movzwl %ax,%eax
}
  8032f0:	5d                   	pop    %ebp
  8032f1:	c3                   	ret    
  8032f2:	66 90                	xchg   %ax,%ax
  8032f4:	66 90                	xchg   %ax,%ax
  8032f6:	66 90                	xchg   %ax,%ax
  8032f8:	66 90                	xchg   %ax,%ax
  8032fa:	66 90                	xchg   %ax,%ax
  8032fc:	66 90                	xchg   %ax,%ax
  8032fe:	66 90                	xchg   %ax,%ax

00803300 <__udivdi3>:
  803300:	55                   	push   %ebp
  803301:	57                   	push   %edi
  803302:	56                   	push   %esi
  803303:	83 ec 0c             	sub    $0xc,%esp
  803306:	8b 44 24 28          	mov    0x28(%esp),%eax
  80330a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80330e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803312:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803316:	85 c0                	test   %eax,%eax
  803318:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80331c:	89 ea                	mov    %ebp,%edx
  80331e:	89 0c 24             	mov    %ecx,(%esp)
  803321:	75 2d                	jne    803350 <__udivdi3+0x50>
  803323:	39 e9                	cmp    %ebp,%ecx
  803325:	77 61                	ja     803388 <__udivdi3+0x88>
  803327:	85 c9                	test   %ecx,%ecx
  803329:	89 ce                	mov    %ecx,%esi
  80332b:	75 0b                	jne    803338 <__udivdi3+0x38>
  80332d:	b8 01 00 00 00       	mov    $0x1,%eax
  803332:	31 d2                	xor    %edx,%edx
  803334:	f7 f1                	div    %ecx
  803336:	89 c6                	mov    %eax,%esi
  803338:	31 d2                	xor    %edx,%edx
  80333a:	89 e8                	mov    %ebp,%eax
  80333c:	f7 f6                	div    %esi
  80333e:	89 c5                	mov    %eax,%ebp
  803340:	89 f8                	mov    %edi,%eax
  803342:	f7 f6                	div    %esi
  803344:	89 ea                	mov    %ebp,%edx
  803346:	83 c4 0c             	add    $0xc,%esp
  803349:	5e                   	pop    %esi
  80334a:	5f                   	pop    %edi
  80334b:	5d                   	pop    %ebp
  80334c:	c3                   	ret    
  80334d:	8d 76 00             	lea    0x0(%esi),%esi
  803350:	39 e8                	cmp    %ebp,%eax
  803352:	77 24                	ja     803378 <__udivdi3+0x78>
  803354:	0f bd e8             	bsr    %eax,%ebp
  803357:	83 f5 1f             	xor    $0x1f,%ebp
  80335a:	75 3c                	jne    803398 <__udivdi3+0x98>
  80335c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803360:	39 34 24             	cmp    %esi,(%esp)
  803363:	0f 86 9f 00 00 00    	jbe    803408 <__udivdi3+0x108>
  803369:	39 d0                	cmp    %edx,%eax
  80336b:	0f 82 97 00 00 00    	jb     803408 <__udivdi3+0x108>
  803371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803378:	31 d2                	xor    %edx,%edx
  80337a:	31 c0                	xor    %eax,%eax
  80337c:	83 c4 0c             	add    $0xc,%esp
  80337f:	5e                   	pop    %esi
  803380:	5f                   	pop    %edi
  803381:	5d                   	pop    %ebp
  803382:	c3                   	ret    
  803383:	90                   	nop
  803384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803388:	89 f8                	mov    %edi,%eax
  80338a:	f7 f1                	div    %ecx
  80338c:	31 d2                	xor    %edx,%edx
  80338e:	83 c4 0c             	add    $0xc,%esp
  803391:	5e                   	pop    %esi
  803392:	5f                   	pop    %edi
  803393:	5d                   	pop    %ebp
  803394:	c3                   	ret    
  803395:	8d 76 00             	lea    0x0(%esi),%esi
  803398:	89 e9                	mov    %ebp,%ecx
  80339a:	8b 3c 24             	mov    (%esp),%edi
  80339d:	d3 e0                	shl    %cl,%eax
  80339f:	89 c6                	mov    %eax,%esi
  8033a1:	b8 20 00 00 00       	mov    $0x20,%eax
  8033a6:	29 e8                	sub    %ebp,%eax
  8033a8:	89 c1                	mov    %eax,%ecx
  8033aa:	d3 ef                	shr    %cl,%edi
  8033ac:	89 e9                	mov    %ebp,%ecx
  8033ae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8033b2:	8b 3c 24             	mov    (%esp),%edi
  8033b5:	09 74 24 08          	or     %esi,0x8(%esp)
  8033b9:	89 d6                	mov    %edx,%esi
  8033bb:	d3 e7                	shl    %cl,%edi
  8033bd:	89 c1                	mov    %eax,%ecx
  8033bf:	89 3c 24             	mov    %edi,(%esp)
  8033c2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8033c6:	d3 ee                	shr    %cl,%esi
  8033c8:	89 e9                	mov    %ebp,%ecx
  8033ca:	d3 e2                	shl    %cl,%edx
  8033cc:	89 c1                	mov    %eax,%ecx
  8033ce:	d3 ef                	shr    %cl,%edi
  8033d0:	09 d7                	or     %edx,%edi
  8033d2:	89 f2                	mov    %esi,%edx
  8033d4:	89 f8                	mov    %edi,%eax
  8033d6:	f7 74 24 08          	divl   0x8(%esp)
  8033da:	89 d6                	mov    %edx,%esi
  8033dc:	89 c7                	mov    %eax,%edi
  8033de:	f7 24 24             	mull   (%esp)
  8033e1:	39 d6                	cmp    %edx,%esi
  8033e3:	89 14 24             	mov    %edx,(%esp)
  8033e6:	72 30                	jb     803418 <__udivdi3+0x118>
  8033e8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8033ec:	89 e9                	mov    %ebp,%ecx
  8033ee:	d3 e2                	shl    %cl,%edx
  8033f0:	39 c2                	cmp    %eax,%edx
  8033f2:	73 05                	jae    8033f9 <__udivdi3+0xf9>
  8033f4:	3b 34 24             	cmp    (%esp),%esi
  8033f7:	74 1f                	je     803418 <__udivdi3+0x118>
  8033f9:	89 f8                	mov    %edi,%eax
  8033fb:	31 d2                	xor    %edx,%edx
  8033fd:	e9 7a ff ff ff       	jmp    80337c <__udivdi3+0x7c>
  803402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803408:	31 d2                	xor    %edx,%edx
  80340a:	b8 01 00 00 00       	mov    $0x1,%eax
  80340f:	e9 68 ff ff ff       	jmp    80337c <__udivdi3+0x7c>
  803414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803418:	8d 47 ff             	lea    -0x1(%edi),%eax
  80341b:	31 d2                	xor    %edx,%edx
  80341d:	83 c4 0c             	add    $0xc,%esp
  803420:	5e                   	pop    %esi
  803421:	5f                   	pop    %edi
  803422:	5d                   	pop    %ebp
  803423:	c3                   	ret    
  803424:	66 90                	xchg   %ax,%ax
  803426:	66 90                	xchg   %ax,%ax
  803428:	66 90                	xchg   %ax,%ax
  80342a:	66 90                	xchg   %ax,%ax
  80342c:	66 90                	xchg   %ax,%ax
  80342e:	66 90                	xchg   %ax,%ax

00803430 <__umoddi3>:
  803430:	55                   	push   %ebp
  803431:	57                   	push   %edi
  803432:	56                   	push   %esi
  803433:	83 ec 14             	sub    $0x14,%esp
  803436:	8b 44 24 28          	mov    0x28(%esp),%eax
  80343a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80343e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803442:	89 c7                	mov    %eax,%edi
  803444:	89 44 24 04          	mov    %eax,0x4(%esp)
  803448:	8b 44 24 30          	mov    0x30(%esp),%eax
  80344c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803450:	89 34 24             	mov    %esi,(%esp)
  803453:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803457:	85 c0                	test   %eax,%eax
  803459:	89 c2                	mov    %eax,%edx
  80345b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80345f:	75 17                	jne    803478 <__umoddi3+0x48>
  803461:	39 fe                	cmp    %edi,%esi
  803463:	76 4b                	jbe    8034b0 <__umoddi3+0x80>
  803465:	89 c8                	mov    %ecx,%eax
  803467:	89 fa                	mov    %edi,%edx
  803469:	f7 f6                	div    %esi
  80346b:	89 d0                	mov    %edx,%eax
  80346d:	31 d2                	xor    %edx,%edx
  80346f:	83 c4 14             	add    $0x14,%esp
  803472:	5e                   	pop    %esi
  803473:	5f                   	pop    %edi
  803474:	5d                   	pop    %ebp
  803475:	c3                   	ret    
  803476:	66 90                	xchg   %ax,%ax
  803478:	39 f8                	cmp    %edi,%eax
  80347a:	77 54                	ja     8034d0 <__umoddi3+0xa0>
  80347c:	0f bd e8             	bsr    %eax,%ebp
  80347f:	83 f5 1f             	xor    $0x1f,%ebp
  803482:	75 5c                	jne    8034e0 <__umoddi3+0xb0>
  803484:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803488:	39 3c 24             	cmp    %edi,(%esp)
  80348b:	0f 87 e7 00 00 00    	ja     803578 <__umoddi3+0x148>
  803491:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803495:	29 f1                	sub    %esi,%ecx
  803497:	19 c7                	sbb    %eax,%edi
  803499:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80349d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034a1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8034a9:	83 c4 14             	add    $0x14,%esp
  8034ac:	5e                   	pop    %esi
  8034ad:	5f                   	pop    %edi
  8034ae:	5d                   	pop    %ebp
  8034af:	c3                   	ret    
  8034b0:	85 f6                	test   %esi,%esi
  8034b2:	89 f5                	mov    %esi,%ebp
  8034b4:	75 0b                	jne    8034c1 <__umoddi3+0x91>
  8034b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034bb:	31 d2                	xor    %edx,%edx
  8034bd:	f7 f6                	div    %esi
  8034bf:	89 c5                	mov    %eax,%ebp
  8034c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034c5:	31 d2                	xor    %edx,%edx
  8034c7:	f7 f5                	div    %ebp
  8034c9:	89 c8                	mov    %ecx,%eax
  8034cb:	f7 f5                	div    %ebp
  8034cd:	eb 9c                	jmp    80346b <__umoddi3+0x3b>
  8034cf:	90                   	nop
  8034d0:	89 c8                	mov    %ecx,%eax
  8034d2:	89 fa                	mov    %edi,%edx
  8034d4:	83 c4 14             	add    $0x14,%esp
  8034d7:	5e                   	pop    %esi
  8034d8:	5f                   	pop    %edi
  8034d9:	5d                   	pop    %ebp
  8034da:	c3                   	ret    
  8034db:	90                   	nop
  8034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8034e0:	8b 04 24             	mov    (%esp),%eax
  8034e3:	be 20 00 00 00       	mov    $0x20,%esi
  8034e8:	89 e9                	mov    %ebp,%ecx
  8034ea:	29 ee                	sub    %ebp,%esi
  8034ec:	d3 e2                	shl    %cl,%edx
  8034ee:	89 f1                	mov    %esi,%ecx
  8034f0:	d3 e8                	shr    %cl,%eax
  8034f2:	89 e9                	mov    %ebp,%ecx
  8034f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034f8:	8b 04 24             	mov    (%esp),%eax
  8034fb:	09 54 24 04          	or     %edx,0x4(%esp)
  8034ff:	89 fa                	mov    %edi,%edx
  803501:	d3 e0                	shl    %cl,%eax
  803503:	89 f1                	mov    %esi,%ecx
  803505:	89 44 24 08          	mov    %eax,0x8(%esp)
  803509:	8b 44 24 10          	mov    0x10(%esp),%eax
  80350d:	d3 ea                	shr    %cl,%edx
  80350f:	89 e9                	mov    %ebp,%ecx
  803511:	d3 e7                	shl    %cl,%edi
  803513:	89 f1                	mov    %esi,%ecx
  803515:	d3 e8                	shr    %cl,%eax
  803517:	89 e9                	mov    %ebp,%ecx
  803519:	09 f8                	or     %edi,%eax
  80351b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80351f:	f7 74 24 04          	divl   0x4(%esp)
  803523:	d3 e7                	shl    %cl,%edi
  803525:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803529:	89 d7                	mov    %edx,%edi
  80352b:	f7 64 24 08          	mull   0x8(%esp)
  80352f:	39 d7                	cmp    %edx,%edi
  803531:	89 c1                	mov    %eax,%ecx
  803533:	89 14 24             	mov    %edx,(%esp)
  803536:	72 2c                	jb     803564 <__umoddi3+0x134>
  803538:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80353c:	72 22                	jb     803560 <__umoddi3+0x130>
  80353e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803542:	29 c8                	sub    %ecx,%eax
  803544:	19 d7                	sbb    %edx,%edi
  803546:	89 e9                	mov    %ebp,%ecx
  803548:	89 fa                	mov    %edi,%edx
  80354a:	d3 e8                	shr    %cl,%eax
  80354c:	89 f1                	mov    %esi,%ecx
  80354e:	d3 e2                	shl    %cl,%edx
  803550:	89 e9                	mov    %ebp,%ecx
  803552:	d3 ef                	shr    %cl,%edi
  803554:	09 d0                	or     %edx,%eax
  803556:	89 fa                	mov    %edi,%edx
  803558:	83 c4 14             	add    $0x14,%esp
  80355b:	5e                   	pop    %esi
  80355c:	5f                   	pop    %edi
  80355d:	5d                   	pop    %ebp
  80355e:	c3                   	ret    
  80355f:	90                   	nop
  803560:	39 d7                	cmp    %edx,%edi
  803562:	75 da                	jne    80353e <__umoddi3+0x10e>
  803564:	8b 14 24             	mov    (%esp),%edx
  803567:	89 c1                	mov    %eax,%ecx
  803569:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80356d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803571:	eb cb                	jmp    80353e <__umoddi3+0x10e>
  803573:	90                   	nop
  803574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803578:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80357c:	0f 82 0f ff ff ff    	jb     803491 <__umoddi3+0x61>
  803582:	e9 1a ff ff ff       	jmp    8034a1 <__umoddi3+0x71>
