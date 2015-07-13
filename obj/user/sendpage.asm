
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 af 01 00 00       	call   8001e0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 28             	sub    $0x28,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 a1 12 00 00       	call   8012df <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 85 bd 00 00 00    	jne    800106 <umain+0xd3>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  800049:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800050:	00 
  800051:	c7 44 24 04 00 00 b0 	movl   $0xb00000,0x4(%esp)
  800058:	00 
  800059:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80005c:	89 04 24             	mov    %eax,(%esp)
  80005f:	e8 1c 16 00 00       	call   801680 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800064:	c7 44 24 08 00 00 b0 	movl   $0xb00000,0x8(%esp)
  80006b:	00 
  80006c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800073:	c7 04 24 c0 2e 80 00 	movl   $0x802ec0,(%esp)
  80007a:	e8 65 02 00 00       	call   8002e4 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  80007f:	a1 04 40 80 00       	mov    0x804004,%eax
  800084:	89 04 24             	mov    %eax,(%esp)
  800087:	e8 94 08 00 00       	call   800920 <strlen>
  80008c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800090:	a1 04 40 80 00       	mov    0x804004,%eax
  800095:	89 44 24 04          	mov    %eax,0x4(%esp)
  800099:	c7 04 24 00 00 b0 00 	movl   $0xb00000,(%esp)
  8000a0:	e8 8d 09 00 00       	call   800a32 <strncmp>
  8000a5:	85 c0                	test   %eax,%eax
  8000a7:	75 0c                	jne    8000b5 <umain+0x82>
			cprintf("child received correct message\n");
  8000a9:	c7 04 24 d4 2e 80 00 	movl   $0x802ed4,(%esp)
  8000b0:	e8 2f 02 00 00       	call   8002e4 <cprintf>

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  8000b5:	a1 00 40 80 00       	mov    0x804000,%eax
  8000ba:	89 04 24             	mov    %eax,(%esp)
  8000bd:	e8 5e 08 00 00       	call   800920 <strlen>
  8000c2:	83 c0 01             	add    $0x1,%eax
  8000c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c9:	a1 00 40 80 00       	mov    0x804000,%eax
  8000ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000d2:	c7 04 24 00 00 b0 00 	movl   $0xb00000,(%esp)
  8000d9:	e8 7e 0a 00 00       	call   800b5c <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000de:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8000e5:	00 
  8000e6:	c7 44 24 08 00 00 b0 	movl   $0xb00000,0x8(%esp)
  8000ed:	00 
  8000ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000f5:	00 
  8000f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f9:	89 04 24             	mov    %eax,(%esp)
  8000fc:	e8 e7 15 00 00       	call   8016e8 <ipc_send>
		return;
  800101:	e9 d8 00 00 00       	jmp    8001de <umain+0x1ab>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800106:	a1 08 50 80 00       	mov    0x805008,%eax
  80010b:	8b 40 48             	mov    0x48(%eax),%eax
  80010e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800115:	00 
  800116:	c7 44 24 04 00 00 a0 	movl   $0xa00000,0x4(%esp)
  80011d:	00 
  80011e:	89 04 24             	mov    %eax,(%esp)
  800121:	e8 9f 0c 00 00       	call   800dc5 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800126:	a1 04 40 80 00       	mov    0x804004,%eax
  80012b:	89 04 24             	mov    %eax,(%esp)
  80012e:	e8 ed 07 00 00       	call   800920 <strlen>
  800133:	83 c0 01             	add    $0x1,%eax
  800136:	89 44 24 08          	mov    %eax,0x8(%esp)
  80013a:	a1 04 40 80 00       	mov    0x804004,%eax
  80013f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800143:	c7 04 24 00 00 a0 00 	movl   $0xa00000,(%esp)
  80014a:	e8 0d 0a 00 00       	call   800b5c <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80014f:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800156:	00 
  800157:	c7 44 24 08 00 00 a0 	movl   $0xa00000,0x8(%esp)
  80015e:	00 
  80015f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800166:	00 
  800167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016a:	89 04 24             	mov    %eax,(%esp)
  80016d:	e8 76 15 00 00       	call   8016e8 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800172:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800179:	00 
  80017a:	c7 44 24 04 00 00 a0 	movl   $0xa00000,0x4(%esp)
  800181:	00 
  800182:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800185:	89 04 24             	mov    %eax,(%esp)
  800188:	e8 f3 14 00 00       	call   801680 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  80018d:	c7 44 24 08 00 00 a0 	movl   $0xa00000,0x8(%esp)
  800194:	00 
  800195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019c:	c7 04 24 c0 2e 80 00 	movl   $0x802ec0,(%esp)
  8001a3:	e8 3c 01 00 00       	call   8002e4 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8001a8:	a1 00 40 80 00       	mov    0x804000,%eax
  8001ad:	89 04 24             	mov    %eax,(%esp)
  8001b0:	e8 6b 07 00 00       	call   800920 <strlen>
  8001b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001b9:	a1 00 40 80 00       	mov    0x804000,%eax
  8001be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c2:	c7 04 24 00 00 a0 00 	movl   $0xa00000,(%esp)
  8001c9:	e8 64 08 00 00       	call   800a32 <strncmp>
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	75 0c                	jne    8001de <umain+0x1ab>
		cprintf("parent received correct message\n");
  8001d2:	c7 04 24 f4 2e 80 00 	movl   $0x802ef4,(%esp)
  8001d9:	e8 06 01 00 00       	call   8002e4 <cprintf>
	return;
}
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    

008001e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	56                   	push   %esi
  8001e4:	53                   	push   %ebx
  8001e5:	83 ec 10             	sub    $0x10,%esp
  8001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8001ee:	e8 94 0b 00 00       	call   800d87 <sys_getenvid>
  8001f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800200:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800205:	85 db                	test   %ebx,%ebx
  800207:	7e 07                	jle    800210 <libmain+0x30>
		binaryname = argv[0];
  800209:	8b 06                	mov    (%esi),%eax
  80020b:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  800210:	89 74 24 04          	mov    %esi,0x4(%esp)
  800214:	89 1c 24             	mov    %ebx,(%esp)
  800217:	e8 17 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80021c:	e8 07 00 00 00       	call   800228 <exit>
}
  800221:	83 c4 10             	add    $0x10,%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80022e:	e8 37 17 00 00       	call   80196a <close_all>
	sys_env_destroy(0);
  800233:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80023a:	e8 a4 0a 00 00       	call   800ce3 <sys_env_destroy>
}
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	53                   	push   %ebx
  800245:	83 ec 14             	sub    $0x14,%esp
  800248:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80024b:	8b 13                	mov    (%ebx),%edx
  80024d:	8d 42 01             	lea    0x1(%edx),%eax
  800250:	89 03                	mov    %eax,(%ebx)
  800252:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800255:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800259:	3d ff 00 00 00       	cmp    $0xff,%eax
  80025e:	75 19                	jne    800279 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800260:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800267:	00 
  800268:	8d 43 08             	lea    0x8(%ebx),%eax
  80026b:	89 04 24             	mov    %eax,(%esp)
  80026e:	e8 33 0a 00 00       	call   800ca6 <sys_cputs>
		b->idx = 0;
  800273:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800279:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80027d:	83 c4 14             	add    $0x14,%esp
  800280:	5b                   	pop    %ebx
  800281:	5d                   	pop    %ebp
  800282:	c3                   	ret    

00800283 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80028c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800293:	00 00 00 
	b.cnt = 0;
  800296:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b8:	c7 04 24 41 02 80 00 	movl   $0x800241,(%esp)
  8002bf:	e8 70 01 00 00       	call   800434 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002c4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ce:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d4:	89 04 24             	mov    %eax,(%esp)
  8002d7:	e8 ca 09 00 00       	call   800ca6 <sys_cputs>

	return b.cnt;
}
  8002dc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ea:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f4:	89 04 24             	mov    %eax,(%esp)
  8002f7:	e8 87 ff ff ff       	call   800283 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    
  8002fe:	66 90                	xchg   %ax,%ax

00800300 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	57                   	push   %edi
  800304:	56                   	push   %esi
  800305:	53                   	push   %ebx
  800306:	83 ec 3c             	sub    $0x3c,%esp
  800309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030c:	89 d7                	mov    %edx,%edi
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800314:	8b 45 0c             	mov    0xc(%ebp),%eax
  800317:	89 c3                	mov    %eax,%ebx
  800319:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80031c:	8b 45 10             	mov    0x10(%ebp),%eax
  80031f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800322:	b9 00 00 00 00       	mov    $0x0,%ecx
  800327:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80032d:	39 d9                	cmp    %ebx,%ecx
  80032f:	72 05                	jb     800336 <printnum+0x36>
  800331:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800334:	77 69                	ja     80039f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800336:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800339:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80033d:	83 ee 01             	sub    $0x1,%esi
  800340:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800344:	89 44 24 08          	mov    %eax,0x8(%esp)
  800348:	8b 44 24 08          	mov    0x8(%esp),%eax
  80034c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800350:	89 c3                	mov    %eax,%ebx
  800352:	89 d6                	mov    %edx,%esi
  800354:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800357:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80035a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80035e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800365:	89 04 24             	mov    %eax,(%esp)
  800368:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80036b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036f:	e8 bc 28 00 00       	call   802c30 <__udivdi3>
  800374:	89 d9                	mov    %ebx,%ecx
  800376:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80037a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80037e:	89 04 24             	mov    %eax,(%esp)
  800381:	89 54 24 04          	mov    %edx,0x4(%esp)
  800385:	89 fa                	mov    %edi,%edx
  800387:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038a:	e8 71 ff ff ff       	call   800300 <printnum>
  80038f:	eb 1b                	jmp    8003ac <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800391:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800395:	8b 45 18             	mov    0x18(%ebp),%eax
  800398:	89 04 24             	mov    %eax,(%esp)
  80039b:	ff d3                	call   *%ebx
  80039d:	eb 03                	jmp    8003a2 <printnum+0xa2>
  80039f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a2:	83 ee 01             	sub    $0x1,%esi
  8003a5:	85 f6                	test   %esi,%esi
  8003a7:	7f e8                	jg     800391 <printnum+0x91>
  8003a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003b0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003be:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c5:	89 04 24             	mov    %eax,(%esp)
  8003c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003cf:	e8 8c 29 00 00       	call   802d60 <__umoddi3>
  8003d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003d8:	0f be 80 6c 2f 80 00 	movsbl 0x802f6c(%eax),%eax
  8003df:	89 04 24             	mov    %eax,(%esp)
  8003e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003e5:	ff d0                	call   *%eax
}
  8003e7:	83 c4 3c             	add    $0x3c,%esp
  8003ea:	5b                   	pop    %ebx
  8003eb:	5e                   	pop    %esi
  8003ec:	5f                   	pop    %edi
  8003ed:	5d                   	pop    %ebp
  8003ee:	c3                   	ret    

008003ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f9:	8b 10                	mov    (%eax),%edx
  8003fb:	3b 50 04             	cmp    0x4(%eax),%edx
  8003fe:	73 0a                	jae    80040a <sprintputch+0x1b>
		*b->buf++ = ch;
  800400:	8d 4a 01             	lea    0x1(%edx),%ecx
  800403:	89 08                	mov    %ecx,(%eax)
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	88 02                	mov    %al,(%edx)
}
  80040a:	5d                   	pop    %ebp
  80040b:	c3                   	ret    

0080040c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800412:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800415:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800419:	8b 45 10             	mov    0x10(%ebp),%eax
  80041c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800420:	8b 45 0c             	mov    0xc(%ebp),%eax
  800423:	89 44 24 04          	mov    %eax,0x4(%esp)
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	89 04 24             	mov    %eax,(%esp)
  80042d:	e8 02 00 00 00       	call   800434 <vprintfmt>
	va_end(ap);
}
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	57                   	push   %edi
  800438:	56                   	push   %esi
  800439:	53                   	push   %ebx
  80043a:	83 ec 3c             	sub    $0x3c,%esp
  80043d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800440:	eb 17                	jmp    800459 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800442:	85 c0                	test   %eax,%eax
  800444:	0f 84 4b 04 00 00    	je     800895 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80044a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80044d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800451:	89 04 24             	mov    %eax,(%esp)
  800454:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800457:	89 fb                	mov    %edi,%ebx
  800459:	8d 7b 01             	lea    0x1(%ebx),%edi
  80045c:	0f b6 03             	movzbl (%ebx),%eax
  80045f:	83 f8 25             	cmp    $0x25,%eax
  800462:	75 de                	jne    800442 <vprintfmt+0xe>
  800464:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800468:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80046f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800474:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80047b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800480:	eb 18                	jmp    80049a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800482:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800484:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800488:	eb 10                	jmp    80049a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80048c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800490:	eb 08                	jmp    80049a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800492:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800495:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80049d:	0f b6 17             	movzbl (%edi),%edx
  8004a0:	0f b6 c2             	movzbl %dl,%eax
  8004a3:	83 ea 23             	sub    $0x23,%edx
  8004a6:	80 fa 55             	cmp    $0x55,%dl
  8004a9:	0f 87 c2 03 00 00    	ja     800871 <vprintfmt+0x43d>
  8004af:	0f b6 d2             	movzbl %dl,%edx
  8004b2:	ff 24 95 a0 30 80 00 	jmp    *0x8030a0(,%edx,4)
  8004b9:	89 df                	mov    %ebx,%edi
  8004bb:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004c0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8004c3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8004c7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  8004ca:	8d 50 d0             	lea    -0x30(%eax),%edx
  8004cd:	83 fa 09             	cmp    $0x9,%edx
  8004d0:	77 33                	ja     800505 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004d2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004d5:	eb e9                	jmp    8004c0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004da:	8b 30                	mov    (%eax),%esi
  8004dc:	8d 40 04             	lea    0x4(%eax),%eax
  8004df:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004e4:	eb 1f                	jmp    800505 <vprintfmt+0xd1>
  8004e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004e9:	85 ff                	test   %edi,%edi
  8004eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f0:	0f 49 c7             	cmovns %edi,%eax
  8004f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	89 df                	mov    %ebx,%edi
  8004f8:	eb a0                	jmp    80049a <vprintfmt+0x66>
  8004fa:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004fc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800503:	eb 95                	jmp    80049a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800505:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800509:	79 8f                	jns    80049a <vprintfmt+0x66>
  80050b:	eb 85                	jmp    800492 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80050d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800510:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800512:	eb 86                	jmp    80049a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	8d 70 04             	lea    0x4(%eax),%esi
  80051a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	89 04 24             	mov    %eax,(%esp)
  800529:	ff 55 08             	call   *0x8(%ebp)
  80052c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80052f:	e9 25 ff ff ff       	jmp    800459 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8d 70 04             	lea    0x4(%eax),%esi
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	99                   	cltd   
  80053d:	31 d0                	xor    %edx,%eax
  80053f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800541:	83 f8 15             	cmp    $0x15,%eax
  800544:	7f 0b                	jg     800551 <vprintfmt+0x11d>
  800546:	8b 14 85 00 32 80 00 	mov    0x803200(,%eax,4),%edx
  80054d:	85 d2                	test   %edx,%edx
  80054f:	75 26                	jne    800577 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800551:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800555:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  80055c:	00 
  80055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800560:	89 44 24 04          	mov    %eax,0x4(%esp)
  800564:	8b 45 08             	mov    0x8(%ebp),%eax
  800567:	89 04 24             	mov    %eax,(%esp)
  80056a:	e8 9d fe ff ff       	call   80040c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80056f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800572:	e9 e2 fe ff ff       	jmp    800459 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800577:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80057b:	c7 44 24 08 46 34 80 	movl   $0x803446,0x8(%esp)
  800582:	00 
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	89 44 24 04          	mov    %eax,0x4(%esp)
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	89 04 24             	mov    %eax,(%esp)
  800590:	e8 77 fe ff ff       	call   80040c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800595:	89 75 14             	mov    %esi,0x14(%ebp)
  800598:	e9 bc fe ff ff       	jmp    800459 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005a6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8005aa:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005ac:	85 ff                	test   %edi,%edi
  8005ae:	b8 7d 2f 80 00       	mov    $0x802f7d,%eax
  8005b3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8005b6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8005ba:	0f 84 94 00 00 00    	je     800654 <vprintfmt+0x220>
  8005c0:	85 c9                	test   %ecx,%ecx
  8005c2:	0f 8e 94 00 00 00    	jle    80065c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005cc:	89 3c 24             	mov    %edi,(%esp)
  8005cf:	e8 64 03 00 00       	call   800938 <strnlen>
  8005d4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005d7:	29 c1                	sub    %eax,%ecx
  8005d9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  8005dc:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  8005e0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8005e3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005ec:	89 cb                	mov    %ecx,%ebx
  8005ee:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f0:	eb 0f                	jmp    800601 <vprintfmt+0x1cd>
					putch(padc, putdat);
  8005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f9:	89 3c 24             	mov    %edi,(%esp)
  8005fc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fe:	83 eb 01             	sub    $0x1,%ebx
  800601:	85 db                	test   %ebx,%ebx
  800603:	7f ed                	jg     8005f2 <vprintfmt+0x1be>
  800605:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800608:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80060b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80060e:	85 c9                	test   %ecx,%ecx
  800610:	b8 00 00 00 00       	mov    $0x0,%eax
  800615:	0f 49 c1             	cmovns %ecx,%eax
  800618:	29 c1                	sub    %eax,%ecx
  80061a:	89 cb                	mov    %ecx,%ebx
  80061c:	eb 44                	jmp    800662 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80061e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800622:	74 1e                	je     800642 <vprintfmt+0x20e>
  800624:	0f be d2             	movsbl %dl,%edx
  800627:	83 ea 20             	sub    $0x20,%edx
  80062a:	83 fa 5e             	cmp    $0x5e,%edx
  80062d:	76 13                	jbe    800642 <vprintfmt+0x20e>
					putch('?', putdat);
  80062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800632:	89 44 24 04          	mov    %eax,0x4(%esp)
  800636:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80063d:	ff 55 08             	call   *0x8(%ebp)
  800640:	eb 0d                	jmp    80064f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800642:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800645:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800649:	89 04 24             	mov    %eax,(%esp)
  80064c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80064f:	83 eb 01             	sub    $0x1,%ebx
  800652:	eb 0e                	jmp    800662 <vprintfmt+0x22e>
  800654:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800657:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80065a:	eb 06                	jmp    800662 <vprintfmt+0x22e>
  80065c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80065f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800662:	83 c7 01             	add    $0x1,%edi
  800665:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800669:	0f be c2             	movsbl %dl,%eax
  80066c:	85 c0                	test   %eax,%eax
  80066e:	74 27                	je     800697 <vprintfmt+0x263>
  800670:	85 f6                	test   %esi,%esi
  800672:	78 aa                	js     80061e <vprintfmt+0x1ea>
  800674:	83 ee 01             	sub    $0x1,%esi
  800677:	79 a5                	jns    80061e <vprintfmt+0x1ea>
  800679:	89 d8                	mov    %ebx,%eax
  80067b:	8b 75 08             	mov    0x8(%ebp),%esi
  80067e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800681:	89 c3                	mov    %eax,%ebx
  800683:	eb 18                	jmp    80069d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800685:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800689:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800690:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800692:	83 eb 01             	sub    $0x1,%ebx
  800695:	eb 06                	jmp    80069d <vprintfmt+0x269>
  800697:	8b 75 08             	mov    0x8(%ebp),%esi
  80069a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80069d:	85 db                	test   %ebx,%ebx
  80069f:	7f e4                	jg     800685 <vprintfmt+0x251>
  8006a1:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006aa:	e9 aa fd ff ff       	jmp    800459 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006af:	83 f9 01             	cmp    $0x1,%ecx
  8006b2:	7e 10                	jle    8006c4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8b 30                	mov    (%eax),%esi
  8006b9:	8b 78 04             	mov    0x4(%eax),%edi
  8006bc:	8d 40 08             	lea    0x8(%eax),%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c2:	eb 26                	jmp    8006ea <vprintfmt+0x2b6>
	else if (lflag)
  8006c4:	85 c9                	test   %ecx,%ecx
  8006c6:	74 12                	je     8006da <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 30                	mov    (%eax),%esi
  8006cd:	89 f7                	mov    %esi,%edi
  8006cf:	c1 ff 1f             	sar    $0x1f,%edi
  8006d2:	8d 40 04             	lea    0x4(%eax),%eax
  8006d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d8:	eb 10                	jmp    8006ea <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 30                	mov    (%eax),%esi
  8006df:	89 f7                	mov    %esi,%edi
  8006e1:	c1 ff 1f             	sar    $0x1f,%edi
  8006e4:	8d 40 04             	lea    0x4(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ea:	89 f0                	mov    %esi,%eax
  8006ec:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006ee:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006f3:	85 ff                	test   %edi,%edi
  8006f5:	0f 89 3a 01 00 00    	jns    800835 <vprintfmt+0x401>
				putch('-', putdat);
  8006fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800702:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800709:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80070c:	89 f0                	mov    %esi,%eax
  80070e:	89 fa                	mov    %edi,%edx
  800710:	f7 d8                	neg    %eax
  800712:	83 d2 00             	adc    $0x0,%edx
  800715:	f7 da                	neg    %edx
			}
			base = 10;
  800717:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80071c:	e9 14 01 00 00       	jmp    800835 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800721:	83 f9 01             	cmp    $0x1,%ecx
  800724:	7e 13                	jle    800739 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 50 04             	mov    0x4(%eax),%edx
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	8b 75 14             	mov    0x14(%ebp),%esi
  800731:	8d 4e 08             	lea    0x8(%esi),%ecx
  800734:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800737:	eb 2c                	jmp    800765 <vprintfmt+0x331>
	else if (lflag)
  800739:	85 c9                	test   %ecx,%ecx
  80073b:	74 15                	je     800752 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	ba 00 00 00 00       	mov    $0x0,%edx
  800747:	8b 75 14             	mov    0x14(%ebp),%esi
  80074a:	8d 76 04             	lea    0x4(%esi),%esi
  80074d:	89 75 14             	mov    %esi,0x14(%ebp)
  800750:	eb 13                	jmp    800765 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	ba 00 00 00 00       	mov    $0x0,%edx
  80075c:	8b 75 14             	mov    0x14(%ebp),%esi
  80075f:	8d 76 04             	lea    0x4(%esi),%esi
  800762:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800765:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80076a:	e9 c6 00 00 00       	jmp    800835 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80076f:	83 f9 01             	cmp    $0x1,%ecx
  800772:	7e 13                	jle    800787 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 50 04             	mov    0x4(%eax),%edx
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	8b 75 14             	mov    0x14(%ebp),%esi
  80077f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800782:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800785:	eb 24                	jmp    8007ab <vprintfmt+0x377>
	else if (lflag)
  800787:	85 c9                	test   %ecx,%ecx
  800789:	74 11                	je     80079c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	99                   	cltd   
  800791:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800794:	8d 71 04             	lea    0x4(%ecx),%esi
  800797:	89 75 14             	mov    %esi,0x14(%ebp)
  80079a:	eb 0f                	jmp    8007ab <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	99                   	cltd   
  8007a2:	8b 75 14             	mov    0x14(%ebp),%esi
  8007a5:	8d 76 04             	lea    0x4(%esi),%esi
  8007a8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  8007ab:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007b0:	e9 80 00 00 00       	jmp    800835 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  8007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007bf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007c6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007d7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007da:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007de:	8b 06                	mov    (%esi),%eax
  8007e0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007e5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007ea:	eb 49                	jmp    800835 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007ec:	83 f9 01             	cmp    $0x1,%ecx
  8007ef:	7e 13                	jle    800804 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8b 50 04             	mov    0x4(%eax),%edx
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	8b 75 14             	mov    0x14(%ebp),%esi
  8007fc:	8d 4e 08             	lea    0x8(%esi),%ecx
  8007ff:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800802:	eb 2c                	jmp    800830 <vprintfmt+0x3fc>
	else if (lflag)
  800804:	85 c9                	test   %ecx,%ecx
  800806:	74 15                	je     80081d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	ba 00 00 00 00       	mov    $0x0,%edx
  800812:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800815:	8d 71 04             	lea    0x4(%ecx),%esi
  800818:	89 75 14             	mov    %esi,0x14(%ebp)
  80081b:	eb 13                	jmp    800830 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
  800827:	8b 75 14             	mov    0x14(%ebp),%esi
  80082a:	8d 76 04             	lea    0x4(%esi),%esi
  80082d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800830:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800835:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800839:	89 74 24 10          	mov    %esi,0x10(%esp)
  80083d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800840:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800844:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800848:	89 04 24             	mov    %eax,(%esp)
  80084b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80084f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	e8 a6 fa ff ff       	call   800300 <printnum>
			break;
  80085a:	e9 fa fb ff ff       	jmp    800459 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80085f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800862:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800866:	89 04 24             	mov    %eax,(%esp)
  800869:	ff 55 08             	call   *0x8(%ebp)
			break;
  80086c:	e9 e8 fb ff ff       	jmp    800459 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800871:	8b 45 0c             	mov    0xc(%ebp),%eax
  800874:	89 44 24 04          	mov    %eax,0x4(%esp)
  800878:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80087f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800882:	89 fb                	mov    %edi,%ebx
  800884:	eb 03                	jmp    800889 <vprintfmt+0x455>
  800886:	83 eb 01             	sub    $0x1,%ebx
  800889:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80088d:	75 f7                	jne    800886 <vprintfmt+0x452>
  80088f:	90                   	nop
  800890:	e9 c4 fb ff ff       	jmp    800459 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800895:	83 c4 3c             	add    $0x3c,%esp
  800898:	5b                   	pop    %ebx
  800899:	5e                   	pop    %esi
  80089a:	5f                   	pop    %edi
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	83 ec 28             	sub    $0x28,%esp
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ac:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008b0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ba:	85 c0                	test   %eax,%eax
  8008bc:	74 30                	je     8008ee <vsnprintf+0x51>
  8008be:	85 d2                	test   %edx,%edx
  8008c0:	7e 2c                	jle    8008ee <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008d0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d7:	c7 04 24 ef 03 80 00 	movl   $0x8003ef,(%esp)
  8008de:	e8 51 fb ff ff       	call   800434 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ec:	eb 05                	jmp    8008f3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008f3:	c9                   	leave  
  8008f4:	c3                   	ret    

008008f5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008fb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800902:	8b 45 10             	mov    0x10(%ebp),%eax
  800905:	89 44 24 08          	mov    %eax,0x8(%esp)
  800909:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	89 04 24             	mov    %eax,(%esp)
  800916:	e8 82 ff ff ff       	call   80089d <vsnprintf>
	va_end(ap);

	return rc;
}
  80091b:	c9                   	leave  
  80091c:	c3                   	ret    
  80091d:	66 90                	xchg   %ax,%ax
  80091f:	90                   	nop

00800920 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800926:	b8 00 00 00 00       	mov    $0x0,%eax
  80092b:	eb 03                	jmp    800930 <strlen+0x10>
		n++;
  80092d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800930:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800934:	75 f7                	jne    80092d <strlen+0xd>
		n++;
	return n;
}
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800941:	b8 00 00 00 00       	mov    $0x0,%eax
  800946:	eb 03                	jmp    80094b <strnlen+0x13>
		n++;
  800948:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094b:	39 d0                	cmp    %edx,%eax
  80094d:	74 06                	je     800955 <strnlen+0x1d>
  80094f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800953:	75 f3                	jne    800948 <strnlen+0x10>
		n++;
	return n;
}
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800961:	89 c2                	mov    %eax,%edx
  800963:	83 c2 01             	add    $0x1,%edx
  800966:	83 c1 01             	add    $0x1,%ecx
  800969:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80096d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800970:	84 db                	test   %bl,%bl
  800972:	75 ef                	jne    800963 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800974:	5b                   	pop    %ebx
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800981:	89 1c 24             	mov    %ebx,(%esp)
  800984:	e8 97 ff ff ff       	call   800920 <strlen>
	strcpy(dst + len, src);
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800990:	01 d8                	add    %ebx,%eax
  800992:	89 04 24             	mov    %eax,(%esp)
  800995:	e8 bd ff ff ff       	call   800957 <strcpy>
	return dst;
}
  80099a:	89 d8                	mov    %ebx,%eax
  80099c:	83 c4 08             	add    $0x8,%esp
  80099f:	5b                   	pop    %ebx
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	56                   	push   %esi
  8009a6:	53                   	push   %ebx
  8009a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ad:	89 f3                	mov    %esi,%ebx
  8009af:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b2:	89 f2                	mov    %esi,%edx
  8009b4:	eb 0f                	jmp    8009c5 <strncpy+0x23>
		*dst++ = *src;
  8009b6:	83 c2 01             	add    $0x1,%edx
  8009b9:	0f b6 01             	movzbl (%ecx),%eax
  8009bc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009bf:	80 39 01             	cmpb   $0x1,(%ecx)
  8009c2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c5:	39 da                	cmp    %ebx,%edx
  8009c7:	75 ed                	jne    8009b6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009c9:	89 f0                	mov    %esi,%eax
  8009cb:	5b                   	pop    %ebx
  8009cc:	5e                   	pop    %esi
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	56                   	push   %esi
  8009d3:	53                   	push   %ebx
  8009d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009dd:	89 f0                	mov    %esi,%eax
  8009df:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e3:	85 c9                	test   %ecx,%ecx
  8009e5:	75 0b                	jne    8009f2 <strlcpy+0x23>
  8009e7:	eb 1d                	jmp    800a06 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009e9:	83 c0 01             	add    $0x1,%eax
  8009ec:	83 c2 01             	add    $0x1,%edx
  8009ef:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009f2:	39 d8                	cmp    %ebx,%eax
  8009f4:	74 0b                	je     800a01 <strlcpy+0x32>
  8009f6:	0f b6 0a             	movzbl (%edx),%ecx
  8009f9:	84 c9                	test   %cl,%cl
  8009fb:	75 ec                	jne    8009e9 <strlcpy+0x1a>
  8009fd:	89 c2                	mov    %eax,%edx
  8009ff:	eb 02                	jmp    800a03 <strlcpy+0x34>
  800a01:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a03:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a06:	29 f0                	sub    %esi,%eax
}
  800a08:	5b                   	pop    %ebx
  800a09:	5e                   	pop    %esi
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a15:	eb 06                	jmp    800a1d <strcmp+0x11>
		p++, q++;
  800a17:	83 c1 01             	add    $0x1,%ecx
  800a1a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a1d:	0f b6 01             	movzbl (%ecx),%eax
  800a20:	84 c0                	test   %al,%al
  800a22:	74 04                	je     800a28 <strcmp+0x1c>
  800a24:	3a 02                	cmp    (%edx),%al
  800a26:	74 ef                	je     800a17 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a28:	0f b6 c0             	movzbl %al,%eax
  800a2b:	0f b6 12             	movzbl (%edx),%edx
  800a2e:	29 d0                	sub    %edx,%eax
}
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	53                   	push   %ebx
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3c:	89 c3                	mov    %eax,%ebx
  800a3e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a41:	eb 06                	jmp    800a49 <strncmp+0x17>
		n--, p++, q++;
  800a43:	83 c0 01             	add    $0x1,%eax
  800a46:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a49:	39 d8                	cmp    %ebx,%eax
  800a4b:	74 15                	je     800a62 <strncmp+0x30>
  800a4d:	0f b6 08             	movzbl (%eax),%ecx
  800a50:	84 c9                	test   %cl,%cl
  800a52:	74 04                	je     800a58 <strncmp+0x26>
  800a54:	3a 0a                	cmp    (%edx),%cl
  800a56:	74 eb                	je     800a43 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a58:	0f b6 00             	movzbl (%eax),%eax
  800a5b:	0f b6 12             	movzbl (%edx),%edx
  800a5e:	29 d0                	sub    %edx,%eax
  800a60:	eb 05                	jmp    800a67 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a62:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a67:	5b                   	pop    %ebx
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a74:	eb 07                	jmp    800a7d <strchr+0x13>
		if (*s == c)
  800a76:	38 ca                	cmp    %cl,%dl
  800a78:	74 0f                	je     800a89 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a7a:	83 c0 01             	add    $0x1,%eax
  800a7d:	0f b6 10             	movzbl (%eax),%edx
  800a80:	84 d2                	test   %dl,%dl
  800a82:	75 f2                	jne    800a76 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a95:	eb 07                	jmp    800a9e <strfind+0x13>
		if (*s == c)
  800a97:	38 ca                	cmp    %cl,%dl
  800a99:	74 0a                	je     800aa5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a9b:	83 c0 01             	add    $0x1,%eax
  800a9e:	0f b6 10             	movzbl (%eax),%edx
  800aa1:	84 d2                	test   %dl,%dl
  800aa3:	75 f2                	jne    800a97 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	57                   	push   %edi
  800aab:	56                   	push   %esi
  800aac:	53                   	push   %ebx
  800aad:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab3:	85 c9                	test   %ecx,%ecx
  800ab5:	74 36                	je     800aed <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800abd:	75 28                	jne    800ae7 <memset+0x40>
  800abf:	f6 c1 03             	test   $0x3,%cl
  800ac2:	75 23                	jne    800ae7 <memset+0x40>
		c &= 0xFF;
  800ac4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac8:	89 d3                	mov    %edx,%ebx
  800aca:	c1 e3 08             	shl    $0x8,%ebx
  800acd:	89 d6                	mov    %edx,%esi
  800acf:	c1 e6 18             	shl    $0x18,%esi
  800ad2:	89 d0                	mov    %edx,%eax
  800ad4:	c1 e0 10             	shl    $0x10,%eax
  800ad7:	09 f0                	or     %esi,%eax
  800ad9:	09 c2                	or     %eax,%edx
  800adb:	89 d0                	mov    %edx,%eax
  800add:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800adf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ae2:	fc                   	cld    
  800ae3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae5:	eb 06                	jmp    800aed <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	fc                   	cld    
  800aeb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aed:	89 f8                	mov    %edi,%eax
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b02:	39 c6                	cmp    %eax,%esi
  800b04:	73 35                	jae    800b3b <memmove+0x47>
  800b06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b09:	39 d0                	cmp    %edx,%eax
  800b0b:	73 2e                	jae    800b3b <memmove+0x47>
		s += n;
		d += n;
  800b0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b10:	89 d6                	mov    %edx,%esi
  800b12:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b14:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b1a:	75 13                	jne    800b2f <memmove+0x3b>
  800b1c:	f6 c1 03             	test   $0x3,%cl
  800b1f:	75 0e                	jne    800b2f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b21:	83 ef 04             	sub    $0x4,%edi
  800b24:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b27:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b2a:	fd                   	std    
  800b2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2d:	eb 09                	jmp    800b38 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b2f:	83 ef 01             	sub    $0x1,%edi
  800b32:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b35:	fd                   	std    
  800b36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b38:	fc                   	cld    
  800b39:	eb 1d                	jmp    800b58 <memmove+0x64>
  800b3b:	89 f2                	mov    %esi,%edx
  800b3d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3f:	f6 c2 03             	test   $0x3,%dl
  800b42:	75 0f                	jne    800b53 <memmove+0x5f>
  800b44:	f6 c1 03             	test   $0x3,%cl
  800b47:	75 0a                	jne    800b53 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b49:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b4c:	89 c7                	mov    %eax,%edi
  800b4e:	fc                   	cld    
  800b4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b51:	eb 05                	jmp    800b58 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b53:	89 c7                	mov    %eax,%edi
  800b55:	fc                   	cld    
  800b56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 04 24             	mov    %eax,(%esp)
  800b76:	e8 79 ff ff ff       	call   800af4 <memmove>
}
  800b7b:	c9                   	leave  
  800b7c:	c3                   	ret    

00800b7d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
  800b82:	8b 55 08             	mov    0x8(%ebp),%edx
  800b85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b88:	89 d6                	mov    %edx,%esi
  800b8a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b8d:	eb 1a                	jmp    800ba9 <memcmp+0x2c>
		if (*s1 != *s2)
  800b8f:	0f b6 02             	movzbl (%edx),%eax
  800b92:	0f b6 19             	movzbl (%ecx),%ebx
  800b95:	38 d8                	cmp    %bl,%al
  800b97:	74 0a                	je     800ba3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b99:	0f b6 c0             	movzbl %al,%eax
  800b9c:	0f b6 db             	movzbl %bl,%ebx
  800b9f:	29 d8                	sub    %ebx,%eax
  800ba1:	eb 0f                	jmp    800bb2 <memcmp+0x35>
		s1++, s2++;
  800ba3:	83 c2 01             	add    $0x1,%edx
  800ba6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba9:	39 f2                	cmp    %esi,%edx
  800bab:	75 e2                	jne    800b8f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb2:	5b                   	pop    %ebx
  800bb3:	5e                   	pop    %esi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bbf:	89 c2                	mov    %eax,%edx
  800bc1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bc4:	eb 07                	jmp    800bcd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc6:	38 08                	cmp    %cl,(%eax)
  800bc8:	74 07                	je     800bd1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bca:	83 c0 01             	add    $0x1,%eax
  800bcd:	39 d0                	cmp    %edx,%eax
  800bcf:	72 f5                	jb     800bc6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bdf:	eb 03                	jmp    800be4 <strtol+0x11>
		s++;
  800be1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800be4:	0f b6 0a             	movzbl (%edx),%ecx
  800be7:	80 f9 09             	cmp    $0x9,%cl
  800bea:	74 f5                	je     800be1 <strtol+0xe>
  800bec:	80 f9 20             	cmp    $0x20,%cl
  800bef:	74 f0                	je     800be1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bf1:	80 f9 2b             	cmp    $0x2b,%cl
  800bf4:	75 0a                	jne    800c00 <strtol+0x2d>
		s++;
  800bf6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bf9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bfe:	eb 11                	jmp    800c11 <strtol+0x3e>
  800c00:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c05:	80 f9 2d             	cmp    $0x2d,%cl
  800c08:	75 07                	jne    800c11 <strtol+0x3e>
		s++, neg = 1;
  800c0a:	8d 52 01             	lea    0x1(%edx),%edx
  800c0d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c11:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c16:	75 15                	jne    800c2d <strtol+0x5a>
  800c18:	80 3a 30             	cmpb   $0x30,(%edx)
  800c1b:	75 10                	jne    800c2d <strtol+0x5a>
  800c1d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c21:	75 0a                	jne    800c2d <strtol+0x5a>
		s += 2, base = 16;
  800c23:	83 c2 02             	add    $0x2,%edx
  800c26:	b8 10 00 00 00       	mov    $0x10,%eax
  800c2b:	eb 10                	jmp    800c3d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c2d:	85 c0                	test   %eax,%eax
  800c2f:	75 0c                	jne    800c3d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c31:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c33:	80 3a 30             	cmpb   $0x30,(%edx)
  800c36:	75 05                	jne    800c3d <strtol+0x6a>
		s++, base = 8;
  800c38:	83 c2 01             	add    $0x1,%edx
  800c3b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c42:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c45:	0f b6 0a             	movzbl (%edx),%ecx
  800c48:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c4b:	89 f0                	mov    %esi,%eax
  800c4d:	3c 09                	cmp    $0x9,%al
  800c4f:	77 08                	ja     800c59 <strtol+0x86>
			dig = *s - '0';
  800c51:	0f be c9             	movsbl %cl,%ecx
  800c54:	83 e9 30             	sub    $0x30,%ecx
  800c57:	eb 20                	jmp    800c79 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c59:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c5c:	89 f0                	mov    %esi,%eax
  800c5e:	3c 19                	cmp    $0x19,%al
  800c60:	77 08                	ja     800c6a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c62:	0f be c9             	movsbl %cl,%ecx
  800c65:	83 e9 57             	sub    $0x57,%ecx
  800c68:	eb 0f                	jmp    800c79 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c6a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c6d:	89 f0                	mov    %esi,%eax
  800c6f:	3c 19                	cmp    $0x19,%al
  800c71:	77 16                	ja     800c89 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c73:	0f be c9             	movsbl %cl,%ecx
  800c76:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c79:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c7c:	7d 0f                	jge    800c8d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c7e:	83 c2 01             	add    $0x1,%edx
  800c81:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c85:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c87:	eb bc                	jmp    800c45 <strtol+0x72>
  800c89:	89 d8                	mov    %ebx,%eax
  800c8b:	eb 02                	jmp    800c8f <strtol+0xbc>
  800c8d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c93:	74 05                	je     800c9a <strtol+0xc7>
		*endptr = (char *) s;
  800c95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c98:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c9a:	f7 d8                	neg    %eax
  800c9c:	85 ff                	test   %edi,%edi
  800c9e:	0f 44 c3             	cmove  %ebx,%eax
}
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cac:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	89 c3                	mov    %eax,%ebx
  800cb9:	89 c7                	mov    %eax,%edi
  800cbb:	89 c6                	mov    %eax,%esi
  800cbd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccf:	b8 01 00 00 00       	mov    $0x1,%eax
  800cd4:	89 d1                	mov    %edx,%ecx
  800cd6:	89 d3                	mov    %edx,%ebx
  800cd8:	89 d7                	mov    %edx,%edi
  800cda:	89 d6                	mov    %edx,%esi
  800cdc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
  800ce9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	89 cb                	mov    %ecx,%ebx
  800cfb:	89 cf                	mov    %ecx,%edi
  800cfd:	89 ce                	mov    %ecx,%esi
  800cff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d01:	85 c0                	test   %eax,%eax
  800d03:	7e 28                	jle    800d2d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d05:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d09:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d10:	00 
  800d11:	c7 44 24 08 77 32 80 	movl   $0x803277,0x8(%esp)
  800d18:	00 
  800d19:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d20:	00 
  800d21:	c7 04 24 94 32 80 00 	movl   $0x803294,(%esp)
  800d28:	e8 b9 1d 00 00       	call   802ae6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d2d:	83 c4 2c             	add    $0x2c,%esp
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d43:	b8 04 00 00 00       	mov    $0x4,%eax
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	89 cb                	mov    %ecx,%ebx
  800d4d:	89 cf                	mov    %ecx,%edi
  800d4f:	89 ce                	mov    %ecx,%esi
  800d51:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d53:	85 c0                	test   %eax,%eax
  800d55:	7e 28                	jle    800d7f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d57:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d5b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d62:	00 
  800d63:	c7 44 24 08 77 32 80 	movl   $0x803277,0x8(%esp)
  800d6a:	00 
  800d6b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d72:	00 
  800d73:	c7 04 24 94 32 80 00 	movl   $0x803294,(%esp)
  800d7a:	e8 67 1d 00 00       	call   802ae6 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800d7f:	83 c4 2c             	add    $0x2c,%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5f                   	pop    %edi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d92:	b8 02 00 00 00       	mov    $0x2,%eax
  800d97:	89 d1                	mov    %edx,%ecx
  800d99:	89 d3                	mov    %edx,%ebx
  800d9b:	89 d7                	mov    %edx,%edi
  800d9d:	89 d6                	mov    %edx,%esi
  800d9f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800da1:	5b                   	pop    %ebx
  800da2:	5e                   	pop    %esi
  800da3:	5f                   	pop    %edi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <sys_yield>:

void
sys_yield(void)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	57                   	push   %edi
  800daa:	56                   	push   %esi
  800dab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dac:	ba 00 00 00 00       	mov    $0x0,%edx
  800db1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800db6:	89 d1                	mov    %edx,%ecx
  800db8:	89 d3                	mov    %edx,%ebx
  800dba:	89 d7                	mov    %edx,%edi
  800dbc:	89 d6                	mov    %edx,%esi
  800dbe:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    

00800dc5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	57                   	push   %edi
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
  800dcb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dce:	be 00 00 00 00       	mov    $0x0,%esi
  800dd3:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de1:	89 f7                	mov    %esi,%edi
  800de3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de5:	85 c0                	test   %eax,%eax
  800de7:	7e 28                	jle    800e11 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ded:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800df4:	00 
  800df5:	c7 44 24 08 77 32 80 	movl   $0x803277,0x8(%esp)
  800dfc:	00 
  800dfd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e04:	00 
  800e05:	c7 04 24 94 32 80 00 	movl   $0x803294,(%esp)
  800e0c:	e8 d5 1c 00 00       	call   802ae6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e11:	83 c4 2c             	add    $0x2c,%esp
  800e14:	5b                   	pop    %ebx
  800e15:	5e                   	pop    %esi
  800e16:	5f                   	pop    %edi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    

00800e19 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
  800e1f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e22:	b8 06 00 00 00       	mov    $0x6,%eax
  800e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e30:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e33:	8b 75 18             	mov    0x18(%ebp),%esi
  800e36:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	7e 28                	jle    800e64 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e40:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e47:	00 
  800e48:	c7 44 24 08 77 32 80 	movl   $0x803277,0x8(%esp)
  800e4f:	00 
  800e50:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e57:	00 
  800e58:	c7 04 24 94 32 80 00 	movl   $0x803294,(%esp)
  800e5f:	e8 82 1c 00 00       	call   802ae6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e64:	83 c4 2c             	add    $0x2c,%esp
  800e67:	5b                   	pop    %ebx
  800e68:	5e                   	pop    %esi
  800e69:	5f                   	pop    %edi
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    

00800e6c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	57                   	push   %edi
  800e70:	56                   	push   %esi
  800e71:	53                   	push   %ebx
  800e72:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7a:	b8 07 00 00 00       	mov    $0x7,%eax
  800e7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	89 df                	mov    %ebx,%edi
  800e87:	89 de                	mov    %ebx,%esi
  800e89:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	7e 28                	jle    800eb7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e93:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800e9a:	00 
  800e9b:	c7 44 24 08 77 32 80 	movl   $0x803277,0x8(%esp)
  800ea2:	00 
  800ea3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eaa:	00 
  800eab:	c7 04 24 94 32 80 00 	movl   $0x803294,(%esp)
  800eb2:	e8 2f 1c 00 00       	call   802ae6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eb7:	83 c4 2c             	add    $0x2c,%esp
  800eba:	5b                   	pop    %ebx
  800ebb:	5e                   	pop    %esi
  800ebc:	5f                   	pop    %edi
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    

00800ebf <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	57                   	push   %edi
  800ec3:	56                   	push   %esi
  800ec4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eca:	b8 10 00 00 00       	mov    $0x10,%eax
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	89 cb                	mov    %ecx,%ebx
  800ed4:	89 cf                	mov    %ecx,%edi
  800ed6:	89 ce                	mov    %ecx,%esi
  800ed8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800eda:	5b                   	pop    %ebx
  800edb:	5e                   	pop    %esi
  800edc:	5f                   	pop    %edi
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    

00800edf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	57                   	push   %edi
  800ee3:	56                   	push   %esi
  800ee4:	53                   	push   %ebx
  800ee5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eed:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef8:	89 df                	mov    %ebx,%edi
  800efa:	89 de                	mov    %ebx,%esi
  800efc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800efe:	85 c0                	test   %eax,%eax
  800f00:	7e 28                	jle    800f2a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f02:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f06:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f0d:	00 
  800f0e:	c7 44 24 08 77 32 80 	movl   $0x803277,0x8(%esp)
  800f15:	00 
  800f16:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f1d:	00 
  800f1e:	c7 04 24 94 32 80 00 	movl   $0x803294,(%esp)
  800f25:	e8 bc 1b 00 00       	call   802ae6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f2a:	83 c4 2c             	add    $0x2c,%esp
  800f2d:	5b                   	pop    %ebx
  800f2e:	5e                   	pop    %esi
  800f2f:	5f                   	pop    %edi
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    

00800f32 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	57                   	push   %edi
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
  800f38:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f40:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f48:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4b:	89 df                	mov    %ebx,%edi
  800f4d:	89 de                	mov    %ebx,%esi
  800f4f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f51:	85 c0                	test   %eax,%eax
  800f53:	7e 28                	jle    800f7d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f55:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f59:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f60:	00 
  800f61:	c7 44 24 08 77 32 80 	movl   $0x803277,0x8(%esp)
  800f68:	00 
  800f69:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f70:	00 
  800f71:	c7 04 24 94 32 80 00 	movl   $0x803294,(%esp)
  800f78:	e8 69 1b 00 00       	call   802ae6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f7d:	83 c4 2c             	add    $0x2c,%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
  800f8b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f93:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	89 df                	mov    %ebx,%edi
  800fa0:	89 de                	mov    %ebx,%esi
  800fa2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	7e 28                	jle    800fd0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fac:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800fb3:	00 
  800fb4:	c7 44 24 08 77 32 80 	movl   $0x803277,0x8(%esp)
  800fbb:	00 
  800fbc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc3:	00 
  800fc4:	c7 04 24 94 32 80 00 	movl   $0x803294,(%esp)
  800fcb:	e8 16 1b 00 00       	call   802ae6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fd0:	83 c4 2c             	add    $0x2c,%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5f                   	pop    %edi
  800fd6:	5d                   	pop    %ebp
  800fd7:	c3                   	ret    

00800fd8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	57                   	push   %edi
  800fdc:	56                   	push   %esi
  800fdd:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fde:	be 00 00 00 00       	mov    $0x0,%esi
  800fe3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fe8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800feb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ff4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	57                   	push   %edi
  800fff:	56                   	push   %esi
  801000:	53                   	push   %ebx
  801001:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801004:	b9 00 00 00 00       	mov    $0x0,%ecx
  801009:	b8 0e 00 00 00       	mov    $0xe,%eax
  80100e:	8b 55 08             	mov    0x8(%ebp),%edx
  801011:	89 cb                	mov    %ecx,%ebx
  801013:	89 cf                	mov    %ecx,%edi
  801015:	89 ce                	mov    %ecx,%esi
  801017:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801019:	85 c0                	test   %eax,%eax
  80101b:	7e 28                	jle    801045 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801021:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801028:	00 
  801029:	c7 44 24 08 77 32 80 	movl   $0x803277,0x8(%esp)
  801030:	00 
  801031:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801038:	00 
  801039:	c7 04 24 94 32 80 00 	movl   $0x803294,(%esp)
  801040:	e8 a1 1a 00 00       	call   802ae6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801045:	83 c4 2c             	add    $0x2c,%esp
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801053:	ba 00 00 00 00       	mov    $0x0,%edx
  801058:	b8 0f 00 00 00       	mov    $0xf,%eax
  80105d:	89 d1                	mov    %edx,%ecx
  80105f:	89 d3                	mov    %edx,%ebx
  801061:	89 d7                	mov    %edx,%edi
  801063:	89 d6                	mov    %edx,%esi
  801065:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801067:	5b                   	pop    %ebx
  801068:	5e                   	pop    %esi
  801069:	5f                   	pop    %edi
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    

0080106c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	57                   	push   %edi
  801070:	56                   	push   %esi
  801071:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801072:	bb 00 00 00 00       	mov    $0x0,%ebx
  801077:	b8 11 00 00 00       	mov    $0x11,%eax
  80107c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107f:	8b 55 08             	mov    0x8(%ebp),%edx
  801082:	89 df                	mov    %ebx,%edi
  801084:	89 de                	mov    %ebx,%esi
  801086:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801088:	5b                   	pop    %ebx
  801089:	5e                   	pop    %esi
  80108a:	5f                   	pop    %edi
  80108b:	5d                   	pop    %ebp
  80108c:	c3                   	ret    

0080108d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
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
  801093:	bb 00 00 00 00       	mov    $0x0,%ebx
  801098:	b8 12 00 00 00       	mov    $0x12,%eax
  80109d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a3:	89 df                	mov    %ebx,%edi
  8010a5:	89 de                	mov    %ebx,%esi
  8010a7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8010a9:	5b                   	pop    %ebx
  8010aa:	5e                   	pop    %esi
  8010ab:	5f                   	pop    %edi
  8010ac:	5d                   	pop    %ebp
  8010ad:	c3                   	ret    

008010ae <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	57                   	push   %edi
  8010b2:	56                   	push   %esi
  8010b3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b9:	b8 13 00 00 00       	mov    $0x13,%eax
  8010be:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c1:	89 cb                	mov    %ecx,%ebx
  8010c3:	89 cf                	mov    %ecx,%edi
  8010c5:	89 ce                	mov    %ecx,%esi
  8010c7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8010c9:	5b                   	pop    %ebx
  8010ca:	5e                   	pop    %esi
  8010cb:	5f                   	pop    %edi
  8010cc:	5d                   	pop    %ebp
  8010cd:	c3                   	ret    

008010ce <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	57                   	push   %edi
  8010d2:	56                   	push   %esi
  8010d3:	53                   	push   %ebx
  8010d4:	83 ec 2c             	sub    $0x2c,%esp
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010da:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  8010dc:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  8010df:	89 f8                	mov    %edi,%eax
  8010e1:	c1 e8 0c             	shr    $0xc,%eax
  8010e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  8010e7:	e8 9b fc ff ff       	call   800d87 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  8010ec:	f7 c6 02 00 00 00    	test   $0x2,%esi
  8010f2:	0f 84 de 00 00 00    	je     8011d6 <pgfault+0x108>
  8010f8:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	79 20                	jns    80111e <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  8010fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801102:	c7 44 24 08 a2 32 80 	movl   $0x8032a2,0x8(%esp)
  801109:	00 
  80110a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801111:	00 
  801112:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  801119:	e8 c8 19 00 00       	call   802ae6 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  80111e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801121:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  801128:	25 05 08 00 00       	and    $0x805,%eax
  80112d:	3d 05 08 00 00       	cmp    $0x805,%eax
  801132:	0f 85 ba 00 00 00    	jne    8011f2 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801138:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80113f:	00 
  801140:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801147:	00 
  801148:	89 1c 24             	mov    %ebx,(%esp)
  80114b:	e8 75 fc ff ff       	call   800dc5 <sys_page_alloc>
  801150:	85 c0                	test   %eax,%eax
  801152:	79 20                	jns    801174 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  801154:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801158:	c7 44 24 08 c9 32 80 	movl   $0x8032c9,0x8(%esp)
  80115f:	00 
  801160:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801167:	00 
  801168:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80116f:	e8 72 19 00 00       	call   802ae6 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801174:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80117a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801181:	00 
  801182:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801186:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80118d:	e8 62 f9 ff ff       	call   800af4 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801192:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801199:	00 
  80119a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80119e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011a2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011a9:	00 
  8011aa:	89 1c 24             	mov    %ebx,(%esp)
  8011ad:	e8 67 fc ff ff       	call   800e19 <sys_page_map>
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	79 3c                	jns    8011f2 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  8011b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ba:	c7 44 24 08 dc 32 80 	movl   $0x8032dc,0x8(%esp)
  8011c1:	00 
  8011c2:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8011c9:	00 
  8011ca:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  8011d1:	e8 10 19 00 00       	call   802ae6 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  8011d6:	c7 44 24 08 00 33 80 	movl   $0x803300,0x8(%esp)
  8011dd:	00 
  8011de:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  8011e5:	00 
  8011e6:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  8011ed:	e8 f4 18 00 00       	call   802ae6 <_panic>
}
  8011f2:	83 c4 2c             	add    $0x2c,%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5f                   	pop    %edi
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    

008011fa <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	56                   	push   %esi
  8011fe:	53                   	push   %ebx
  8011ff:	83 ec 20             	sub    $0x20,%esp
  801202:	8b 75 08             	mov    0x8(%ebp),%esi
  801205:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801208:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80120f:	00 
  801210:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801214:	89 34 24             	mov    %esi,(%esp)
  801217:	e8 a9 fb ff ff       	call   800dc5 <sys_page_alloc>
  80121c:	85 c0                	test   %eax,%eax
  80121e:	79 20                	jns    801240 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  801220:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801224:	c7 44 24 08 c9 32 80 	movl   $0x8032c9,0x8(%esp)
  80122b:	00 
  80122c:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  801233:	00 
  801234:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80123b:	e8 a6 18 00 00       	call   802ae6 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801240:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801247:	00 
  801248:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  80124f:	00 
  801250:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801257:	00 
  801258:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80125c:	89 34 24             	mov    %esi,(%esp)
  80125f:	e8 b5 fb ff ff       	call   800e19 <sys_page_map>
  801264:	85 c0                	test   %eax,%eax
  801266:	79 20                	jns    801288 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  801268:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80126c:	c7 44 24 08 dc 32 80 	movl   $0x8032dc,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  801283:	e8 5e 18 00 00       	call   802ae6 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  801288:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80128f:	00 
  801290:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801294:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  80129b:	e8 54 f8 ff ff       	call   800af4 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8012a0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8012a7:	00 
  8012a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012af:	e8 b8 fb ff ff       	call   800e6c <sys_page_unmap>
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	79 20                	jns    8012d8 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8012b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012bc:	c7 44 24 08 ed 32 80 	movl   $0x8032ed,0x8(%esp)
  8012c3:	00 
  8012c4:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8012cb:	00 
  8012cc:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  8012d3:	e8 0e 18 00 00       	call   802ae6 <_panic>

}
  8012d8:	83 c4 20             	add    $0x20,%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5d                   	pop    %ebp
  8012de:	c3                   	ret    

008012df <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	57                   	push   %edi
  8012e3:	56                   	push   %esi
  8012e4:	53                   	push   %ebx
  8012e5:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  8012e8:	c7 04 24 ce 10 80 00 	movl   $0x8010ce,(%esp)
  8012ef:	e8 48 18 00 00       	call   802b3c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8012f4:	b8 08 00 00 00       	mov    $0x8,%eax
  8012f9:	cd 30                	int    $0x30
  8012fb:	89 c6                	mov    %eax,%esi
  8012fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801300:	85 c0                	test   %eax,%eax
  801302:	79 20                	jns    801324 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801304:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801308:	c7 44 24 08 24 33 80 	movl   $0x803324,0x8(%esp)
  80130f:	00 
  801310:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  801317:	00 
  801318:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80131f:	e8 c2 17 00 00       	call   802ae6 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801324:	bb 00 00 00 00       	mov    $0x0,%ebx
  801329:	85 c0                	test   %eax,%eax
  80132b:	75 21                	jne    80134e <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80132d:	e8 55 fa ff ff       	call   800d87 <sys_getenvid>
  801332:	25 ff 03 00 00       	and    $0x3ff,%eax
  801337:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80133a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80133f:	a3 08 50 80 00       	mov    %eax,0x805008
		//set_pgfault_handler(pgfault);
		return 0;
  801344:	b8 00 00 00 00       	mov    $0x0,%eax
  801349:	e9 88 01 00 00       	jmp    8014d6 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  80134e:	89 d8                	mov    %ebx,%eax
  801350:	c1 e8 16             	shr    $0x16,%eax
  801353:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80135a:	a8 01                	test   $0x1,%al
  80135c:	0f 84 e0 00 00 00    	je     801442 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801362:	89 df                	mov    %ebx,%edi
  801364:	c1 ef 0c             	shr    $0xc,%edi
  801367:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  80136e:	a8 01                	test   $0x1,%al
  801370:	0f 84 c4 00 00 00    	je     80143a <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801376:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  80137d:	f6 c4 04             	test   $0x4,%ah
  801380:	74 0d                	je     80138f <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  801382:	25 07 0e 00 00       	and    $0xe07,%eax
  801387:	83 c8 05             	or     $0x5,%eax
  80138a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80138d:	eb 1b                	jmp    8013aa <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  80138f:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801394:	83 f8 01             	cmp    $0x1,%eax
  801397:	19 c0                	sbb    %eax,%eax
  801399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80139c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  8013a3:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  8013aa:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  8013ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013b4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013bf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ca:	e8 4a fa ff ff       	call   800e19 <sys_page_map>
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	79 20                	jns    8013f3 <fork+0x114>
		panic("sys_page_map: %e", r);
  8013d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013d7:	c7 44 24 08 dc 32 80 	movl   $0x8032dc,0x8(%esp)
  8013de:	00 
  8013df:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  8013e6:	00 
  8013e7:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  8013ee:	e8 f3 16 00 00       	call   802ae6 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  8013f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013fa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801405:	00 
  801406:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80140a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801411:	e8 03 fa ff ff       	call   800e19 <sys_page_map>
  801416:	85 c0                	test   %eax,%eax
  801418:	79 20                	jns    80143a <fork+0x15b>
		panic("sys_page_map: %e", r);
  80141a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80141e:	c7 44 24 08 dc 32 80 	movl   $0x8032dc,0x8(%esp)
  801425:	00 
  801426:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  80142d:	00 
  80142e:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  801435:	e8 ac 16 00 00       	call   802ae6 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  80143a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801440:	eb 06                	jmp    801448 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  801442:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  801448:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  80144e:	0f 86 fa fe ff ff    	jbe    80134e <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801454:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80145b:	00 
  80145c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801463:	ee 
  801464:	89 34 24             	mov    %esi,(%esp)
  801467:	e8 59 f9 ff ff       	call   800dc5 <sys_page_alloc>
  80146c:	85 c0                	test   %eax,%eax
  80146e:	79 20                	jns    801490 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801470:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801474:	c7 44 24 08 c9 32 80 	movl   $0x8032c9,0x8(%esp)
  80147b:	00 
  80147c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  801483:	00 
  801484:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80148b:	e8 56 16 00 00       	call   802ae6 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801490:	c7 44 24 04 cf 2b 80 	movl   $0x802bcf,0x4(%esp)
  801497:	00 
  801498:	89 34 24             	mov    %esi,(%esp)
  80149b:	e8 e5 fa ff ff       	call   800f85 <sys_env_set_pgfault_upcall>
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	79 20                	jns    8014c4 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  8014a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014a8:	c7 44 24 08 48 33 80 	movl   $0x803348,0x8(%esp)
  8014af:	00 
  8014b0:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  8014b7:	00 
  8014b8:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  8014bf:	e8 22 16 00 00       	call   802ae6 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  8014c4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8014cb:	00 
  8014cc:	89 34 24             	mov    %esi,(%esp)
  8014cf:	e8 0b fa ff ff       	call   800edf <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  8014d4:	89 f0                	mov    %esi,%eax

}
  8014d6:	83 c4 2c             	add    $0x2c,%esp
  8014d9:	5b                   	pop    %ebx
  8014da:	5e                   	pop    %esi
  8014db:	5f                   	pop    %edi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    

008014de <sfork>:

// Challenge!
int
sfork(void)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	57                   	push   %edi
  8014e2:	56                   	push   %esi
  8014e3:	53                   	push   %ebx
  8014e4:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  8014e7:	c7 04 24 ce 10 80 00 	movl   $0x8010ce,(%esp)
  8014ee:	e8 49 16 00 00       	call   802b3c <set_pgfault_handler>
  8014f3:	b8 08 00 00 00       	mov    $0x8,%eax
  8014f8:	cd 30                	int    $0x30
  8014fa:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	79 20                	jns    801520 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801500:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801504:	c7 44 24 08 24 33 80 	movl   $0x803324,0x8(%esp)
  80150b:	00 
  80150c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  801513:	00 
  801514:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80151b:	e8 c6 15 00 00       	call   802ae6 <_panic>
  801520:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801522:	bb 00 00 00 00       	mov    $0x0,%ebx
  801527:	85 c0                	test   %eax,%eax
  801529:	75 2d                	jne    801558 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80152b:	e8 57 f8 ff ff       	call   800d87 <sys_getenvid>
  801530:	25 ff 03 00 00       	and    $0x3ff,%eax
  801535:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801538:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80153d:	a3 08 50 80 00       	mov    %eax,0x805008
		set_pgfault_handler(pgfault);
  801542:	c7 04 24 ce 10 80 00 	movl   $0x8010ce,(%esp)
  801549:	e8 ee 15 00 00       	call   802b3c <set_pgfault_handler>
		return 0;
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	e9 1d 01 00 00       	jmp    801675 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801558:	89 d8                	mov    %ebx,%eax
  80155a:	c1 e8 16             	shr    $0x16,%eax
  80155d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801564:	a8 01                	test   $0x1,%al
  801566:	74 69                	je     8015d1 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  801568:	89 d8                	mov    %ebx,%eax
  80156a:	c1 e8 0c             	shr    $0xc,%eax
  80156d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801574:	f6 c2 01             	test   $0x1,%dl
  801577:	74 50                	je     8015c9 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801579:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801580:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  801583:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801589:	89 54 24 10          	mov    %edx,0x10(%esp)
  80158d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801591:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801595:	89 44 24 04          	mov    %eax,0x4(%esp)
  801599:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a0:	e8 74 f8 ff ff       	call   800e19 <sys_page_map>
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	79 20                	jns    8015c9 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  8015a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015ad:	c7 44 24 08 dc 32 80 	movl   $0x8032dc,0x8(%esp)
  8015b4:	00 
  8015b5:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8015bc:	00 
  8015bd:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  8015c4:	e8 1d 15 00 00       	call   802ae6 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8015c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015cf:	eb 06                	jmp    8015d7 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  8015d1:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  8015d7:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  8015dd:	0f 86 75 ff ff ff    	jbe    801558 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  8015e3:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  8015ea:	ee 
  8015eb:	89 34 24             	mov    %esi,(%esp)
  8015ee:	e8 07 fc ff ff       	call   8011fa <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8015f3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015fa:	00 
  8015fb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801602:	ee 
  801603:	89 34 24             	mov    %esi,(%esp)
  801606:	e8 ba f7 ff ff       	call   800dc5 <sys_page_alloc>
  80160b:	85 c0                	test   %eax,%eax
  80160d:	79 20                	jns    80162f <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  80160f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801613:	c7 44 24 08 c9 32 80 	movl   $0x8032c9,0x8(%esp)
  80161a:	00 
  80161b:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  801622:	00 
  801623:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80162a:	e8 b7 14 00 00       	call   802ae6 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80162f:	c7 44 24 04 cf 2b 80 	movl   $0x802bcf,0x4(%esp)
  801636:	00 
  801637:	89 34 24             	mov    %esi,(%esp)
  80163a:	e8 46 f9 ff ff       	call   800f85 <sys_env_set_pgfault_upcall>
  80163f:	85 c0                	test   %eax,%eax
  801641:	79 20                	jns    801663 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  801643:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801647:	c7 44 24 08 48 33 80 	movl   $0x803348,0x8(%esp)
  80164e:	00 
  80164f:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  801656:	00 
  801657:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80165e:	e8 83 14 00 00       	call   802ae6 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801663:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80166a:	00 
  80166b:	89 34 24             	mov    %esi,(%esp)
  80166e:	e8 6c f8 ff ff       	call   800edf <sys_env_set_status>
	return envid;
  801673:	89 f0                	mov    %esi,%eax

}
  801675:	83 c4 2c             	add    $0x2c,%esp
  801678:	5b                   	pop    %ebx
  801679:	5e                   	pop    %esi
  80167a:	5f                   	pop    %edi
  80167b:	5d                   	pop    %ebp
  80167c:	c3                   	ret    
  80167d:	66 90                	xchg   %ax,%ax
  80167f:	90                   	nop

00801680 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	56                   	push   %esi
  801684:	53                   	push   %ebx
  801685:	83 ec 10             	sub    $0x10,%esp
  801688:	8b 75 08             	mov    0x8(%ebp),%esi
  80168b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  801691:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  801693:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801698:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80169b:	89 04 24             	mov    %eax,(%esp)
  80169e:	e8 58 f9 ff ff       	call   800ffb <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	75 26                	jne    8016cd <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8016a7:	85 f6                	test   %esi,%esi
  8016a9:	74 0a                	je     8016b5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8016ab:	a1 08 50 80 00       	mov    0x805008,%eax
  8016b0:	8b 40 74             	mov    0x74(%eax),%eax
  8016b3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  8016b5:	85 db                	test   %ebx,%ebx
  8016b7:	74 0a                	je     8016c3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  8016b9:	a1 08 50 80 00       	mov    0x805008,%eax
  8016be:	8b 40 78             	mov    0x78(%eax),%eax
  8016c1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8016c3:	a1 08 50 80 00       	mov    0x805008,%eax
  8016c8:	8b 40 70             	mov    0x70(%eax),%eax
  8016cb:	eb 14                	jmp    8016e1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  8016cd:	85 f6                	test   %esi,%esi
  8016cf:	74 06                	je     8016d7 <ipc_recv+0x57>
			*from_env_store = 0;
  8016d1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8016d7:	85 db                	test   %ebx,%ebx
  8016d9:	74 06                	je     8016e1 <ipc_recv+0x61>
			*perm_store = 0;
  8016db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	5b                   	pop    %ebx
  8016e5:	5e                   	pop    %esi
  8016e6:	5d                   	pop    %ebp
  8016e7:	c3                   	ret    

008016e8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	57                   	push   %edi
  8016ec:	56                   	push   %esi
  8016ed:	53                   	push   %ebx
  8016ee:	83 ec 1c             	sub    $0x1c,%esp
  8016f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016f4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016f7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  8016fa:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  8016fc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  801701:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801704:	8b 45 14             	mov    0x14(%ebp),%eax
  801707:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80170b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80170f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801713:	89 3c 24             	mov    %edi,(%esp)
  801716:	e8 bd f8 ff ff       	call   800fd8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80171b:	85 c0                	test   %eax,%eax
  80171d:	74 28                	je     801747 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80171f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801722:	74 1c                	je     801740 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  801724:	c7 44 24 08 6c 33 80 	movl   $0x80336c,0x8(%esp)
  80172b:	00 
  80172c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801733:	00 
  801734:	c7 04 24 8d 33 80 00 	movl   $0x80338d,(%esp)
  80173b:	e8 a6 13 00 00       	call   802ae6 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  801740:	e8 61 f6 ff ff       	call   800da6 <sys_yield>
	}
  801745:	eb bd                	jmp    801704 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  801747:	83 c4 1c             	add    $0x1c,%esp
  80174a:	5b                   	pop    %ebx
  80174b:	5e                   	pop    %esi
  80174c:	5f                   	pop    %edi
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80175a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80175d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801763:	8b 52 50             	mov    0x50(%edx),%edx
  801766:	39 ca                	cmp    %ecx,%edx
  801768:	75 0d                	jne    801777 <ipc_find_env+0x28>
			return envs[i].env_id;
  80176a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80176d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801772:	8b 40 40             	mov    0x40(%eax),%eax
  801775:	eb 0e                	jmp    801785 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801777:	83 c0 01             	add    $0x1,%eax
  80177a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80177f:	75 d9                	jne    80175a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801781:	66 b8 00 00          	mov    $0x0,%ax
}
  801785:	5d                   	pop    %ebp
  801786:	c3                   	ret    
  801787:	66 90                	xchg   %ax,%ax
  801789:	66 90                	xchg   %ax,%ax
  80178b:	66 90                	xchg   %ax,%ax
  80178d:	66 90                	xchg   %ax,%ax
  80178f:	90                   	nop

00801790 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	05 00 00 00 30       	add    $0x30000000,%eax
  80179b:	c1 e8 0c             	shr    $0xc,%eax
}
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8017ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017b5:	5d                   	pop    %ebp
  8017b6:	c3                   	ret    

008017b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017c2:	89 c2                	mov    %eax,%edx
  8017c4:	c1 ea 16             	shr    $0x16,%edx
  8017c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017ce:	f6 c2 01             	test   $0x1,%dl
  8017d1:	74 11                	je     8017e4 <fd_alloc+0x2d>
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	c1 ea 0c             	shr    $0xc,%edx
  8017d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017df:	f6 c2 01             	test   $0x1,%dl
  8017e2:	75 09                	jne    8017ed <fd_alloc+0x36>
			*fd_store = fd;
  8017e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017eb:	eb 17                	jmp    801804 <fd_alloc+0x4d>
  8017ed:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8017f2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017f7:	75 c9                	jne    8017c2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017f9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8017ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    

00801806 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80180c:	83 f8 1f             	cmp    $0x1f,%eax
  80180f:	77 36                	ja     801847 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801811:	c1 e0 0c             	shl    $0xc,%eax
  801814:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801819:	89 c2                	mov    %eax,%edx
  80181b:	c1 ea 16             	shr    $0x16,%edx
  80181e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801825:	f6 c2 01             	test   $0x1,%dl
  801828:	74 24                	je     80184e <fd_lookup+0x48>
  80182a:	89 c2                	mov    %eax,%edx
  80182c:	c1 ea 0c             	shr    $0xc,%edx
  80182f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801836:	f6 c2 01             	test   $0x1,%dl
  801839:	74 1a                	je     801855 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80183b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183e:	89 02                	mov    %eax,(%edx)
	return 0;
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
  801845:	eb 13                	jmp    80185a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801847:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80184c:	eb 0c                	jmp    80185a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80184e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801853:	eb 05                	jmp    80185a <fd_lookup+0x54>
  801855:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 18             	sub    $0x18,%esp
  801862:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801865:	ba 00 00 00 00       	mov    $0x0,%edx
  80186a:	eb 13                	jmp    80187f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80186c:	39 08                	cmp    %ecx,(%eax)
  80186e:	75 0c                	jne    80187c <dev_lookup+0x20>
			*dev = devtab[i];
  801870:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801873:	89 01                	mov    %eax,(%ecx)
			return 0;
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
  80187a:	eb 38                	jmp    8018b4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80187c:	83 c2 01             	add    $0x1,%edx
  80187f:	8b 04 95 14 34 80 00 	mov    0x803414(,%edx,4),%eax
  801886:	85 c0                	test   %eax,%eax
  801888:	75 e2                	jne    80186c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80188a:	a1 08 50 80 00       	mov    0x805008,%eax
  80188f:	8b 40 48             	mov    0x48(%eax),%eax
  801892:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801896:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189a:	c7 04 24 98 33 80 00 	movl   $0x803398,(%esp)
  8018a1:	e8 3e ea ff ff       	call   8002e4 <cprintf>
	*dev = 0;
  8018a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	56                   	push   %esi
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 20             	sub    $0x20,%esp
  8018be:	8b 75 08             	mov    0x8(%ebp),%esi
  8018c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018cb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018d1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018d4:	89 04 24             	mov    %eax,(%esp)
  8018d7:	e8 2a ff ff ff       	call   801806 <fd_lookup>
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	78 05                	js     8018e5 <fd_close+0x2f>
	    || fd != fd2)
  8018e0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018e3:	74 0c                	je     8018f1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8018e5:	84 db                	test   %bl,%bl
  8018e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ec:	0f 44 c2             	cmove  %edx,%eax
  8018ef:	eb 3f                	jmp    801930 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f8:	8b 06                	mov    (%esi),%eax
  8018fa:	89 04 24             	mov    %eax,(%esp)
  8018fd:	e8 5a ff ff ff       	call   80185c <dev_lookup>
  801902:	89 c3                	mov    %eax,%ebx
  801904:	85 c0                	test   %eax,%eax
  801906:	78 16                	js     80191e <fd_close+0x68>
		if (dev->dev_close)
  801908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80190e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801913:	85 c0                	test   %eax,%eax
  801915:	74 07                	je     80191e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801917:	89 34 24             	mov    %esi,(%esp)
  80191a:	ff d0                	call   *%eax
  80191c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80191e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801922:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801929:	e8 3e f5 ff ff       	call   800e6c <sys_page_unmap>
	return r;
  80192e:	89 d8                	mov    %ebx,%eax
}
  801930:	83 c4 20             	add    $0x20,%esp
  801933:	5b                   	pop    %ebx
  801934:	5e                   	pop    %esi
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    

00801937 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80193d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801940:	89 44 24 04          	mov    %eax,0x4(%esp)
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	89 04 24             	mov    %eax,(%esp)
  80194a:	e8 b7 fe ff ff       	call   801806 <fd_lookup>
  80194f:	89 c2                	mov    %eax,%edx
  801951:	85 d2                	test   %edx,%edx
  801953:	78 13                	js     801968 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801955:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80195c:	00 
  80195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801960:	89 04 24             	mov    %eax,(%esp)
  801963:	e8 4e ff ff ff       	call   8018b6 <fd_close>
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <close_all>:

void
close_all(void)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	53                   	push   %ebx
  80196e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801971:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801976:	89 1c 24             	mov    %ebx,(%esp)
  801979:	e8 b9 ff ff ff       	call   801937 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80197e:	83 c3 01             	add    $0x1,%ebx
  801981:	83 fb 20             	cmp    $0x20,%ebx
  801984:	75 f0                	jne    801976 <close_all+0xc>
		close(i);
}
  801986:	83 c4 14             	add    $0x14,%esp
  801989:	5b                   	pop    %ebx
  80198a:	5d                   	pop    %ebp
  80198b:	c3                   	ret    

0080198c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	57                   	push   %edi
  801990:	56                   	push   %esi
  801991:	53                   	push   %ebx
  801992:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801995:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	89 04 24             	mov    %eax,(%esp)
  8019a2:	e8 5f fe ff ff       	call   801806 <fd_lookup>
  8019a7:	89 c2                	mov    %eax,%edx
  8019a9:	85 d2                	test   %edx,%edx
  8019ab:	0f 88 e1 00 00 00    	js     801a92 <dup+0x106>
		return r;
	close(newfdnum);
  8019b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b4:	89 04 24             	mov    %eax,(%esp)
  8019b7:	e8 7b ff ff ff       	call   801937 <close>

	newfd = INDEX2FD(newfdnum);
  8019bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019bf:	c1 e3 0c             	shl    $0xc,%ebx
  8019c2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8019c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019cb:	89 04 24             	mov    %eax,(%esp)
  8019ce:	e8 cd fd ff ff       	call   8017a0 <fd2data>
  8019d3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8019d5:	89 1c 24             	mov    %ebx,(%esp)
  8019d8:	e8 c3 fd ff ff       	call   8017a0 <fd2data>
  8019dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019df:	89 f0                	mov    %esi,%eax
  8019e1:	c1 e8 16             	shr    $0x16,%eax
  8019e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019eb:	a8 01                	test   $0x1,%al
  8019ed:	74 43                	je     801a32 <dup+0xa6>
  8019ef:	89 f0                	mov    %esi,%eax
  8019f1:	c1 e8 0c             	shr    $0xc,%eax
  8019f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019fb:	f6 c2 01             	test   $0x1,%dl
  8019fe:	74 32                	je     801a32 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a00:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a07:	25 07 0e 00 00       	and    $0xe07,%eax
  801a0c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a10:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a14:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a1b:	00 
  801a1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a27:	e8 ed f3 ff ff       	call   800e19 <sys_page_map>
  801a2c:	89 c6                	mov    %eax,%esi
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	78 3e                	js     801a70 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a35:	89 c2                	mov    %eax,%edx
  801a37:	c1 ea 0c             	shr    $0xc,%edx
  801a3a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a41:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a47:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a56:	00 
  801a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a62:	e8 b2 f3 ff ff       	call   800e19 <sys_page_map>
  801a67:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801a69:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a6c:	85 f6                	test   %esi,%esi
  801a6e:	79 22                	jns    801a92 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7b:	e8 ec f3 ff ff       	call   800e6c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a80:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8b:	e8 dc f3 ff ff       	call   800e6c <sys_page_unmap>
	return r;
  801a90:	89 f0                	mov    %esi,%eax
}
  801a92:	83 c4 3c             	add    $0x3c,%esp
  801a95:	5b                   	pop    %ebx
  801a96:	5e                   	pop    %esi
  801a97:	5f                   	pop    %edi
  801a98:	5d                   	pop    %ebp
  801a99:	c3                   	ret    

00801a9a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	53                   	push   %ebx
  801a9e:	83 ec 24             	sub    $0x24,%esp
  801aa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aab:	89 1c 24             	mov    %ebx,(%esp)
  801aae:	e8 53 fd ff ff       	call   801806 <fd_lookup>
  801ab3:	89 c2                	mov    %eax,%edx
  801ab5:	85 d2                	test   %edx,%edx
  801ab7:	78 6d                	js     801b26 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac3:	8b 00                	mov    (%eax),%eax
  801ac5:	89 04 24             	mov    %eax,(%esp)
  801ac8:	e8 8f fd ff ff       	call   80185c <dev_lookup>
  801acd:	85 c0                	test   %eax,%eax
  801acf:	78 55                	js     801b26 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad4:	8b 50 08             	mov    0x8(%eax),%edx
  801ad7:	83 e2 03             	and    $0x3,%edx
  801ada:	83 fa 01             	cmp    $0x1,%edx
  801add:	75 23                	jne    801b02 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801adf:	a1 08 50 80 00       	mov    0x805008,%eax
  801ae4:	8b 40 48             	mov    0x48(%eax),%eax
  801ae7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aef:	c7 04 24 d9 33 80 00 	movl   $0x8033d9,(%esp)
  801af6:	e8 e9 e7 ff ff       	call   8002e4 <cprintf>
		return -E_INVAL;
  801afb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b00:	eb 24                	jmp    801b26 <read+0x8c>
	}
	if (!dev->dev_read)
  801b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b05:	8b 52 08             	mov    0x8(%edx),%edx
  801b08:	85 d2                	test   %edx,%edx
  801b0a:	74 15                	je     801b21 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b1a:	89 04 24             	mov    %eax,(%esp)
  801b1d:	ff d2                	call   *%edx
  801b1f:	eb 05                	jmp    801b26 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801b21:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801b26:	83 c4 24             	add    $0x24,%esp
  801b29:	5b                   	pop    %ebx
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    

00801b2c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	57                   	push   %edi
  801b30:	56                   	push   %esi
  801b31:	53                   	push   %ebx
  801b32:	83 ec 1c             	sub    $0x1c,%esp
  801b35:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b38:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b40:	eb 23                	jmp    801b65 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b42:	89 f0                	mov    %esi,%eax
  801b44:	29 d8                	sub    %ebx,%eax
  801b46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b4a:	89 d8                	mov    %ebx,%eax
  801b4c:	03 45 0c             	add    0xc(%ebp),%eax
  801b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b53:	89 3c 24             	mov    %edi,(%esp)
  801b56:	e8 3f ff ff ff       	call   801a9a <read>
		if (m < 0)
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 10                	js     801b6f <readn+0x43>
			return m;
		if (m == 0)
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	74 0a                	je     801b6d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b63:	01 c3                	add    %eax,%ebx
  801b65:	39 f3                	cmp    %esi,%ebx
  801b67:	72 d9                	jb     801b42 <readn+0x16>
  801b69:	89 d8                	mov    %ebx,%eax
  801b6b:	eb 02                	jmp    801b6f <readn+0x43>
  801b6d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b6f:	83 c4 1c             	add    $0x1c,%esp
  801b72:	5b                   	pop    %ebx
  801b73:	5e                   	pop    %esi
  801b74:	5f                   	pop    %edi
  801b75:	5d                   	pop    %ebp
  801b76:	c3                   	ret    

00801b77 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	53                   	push   %ebx
  801b7b:	83 ec 24             	sub    $0x24,%esp
  801b7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b81:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b88:	89 1c 24             	mov    %ebx,(%esp)
  801b8b:	e8 76 fc ff ff       	call   801806 <fd_lookup>
  801b90:	89 c2                	mov    %eax,%edx
  801b92:	85 d2                	test   %edx,%edx
  801b94:	78 68                	js     801bfe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba0:	8b 00                	mov    (%eax),%eax
  801ba2:	89 04 24             	mov    %eax,(%esp)
  801ba5:	e8 b2 fc ff ff       	call   80185c <dev_lookup>
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 50                	js     801bfe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bb5:	75 23                	jne    801bda <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bb7:	a1 08 50 80 00       	mov    0x805008,%eax
  801bbc:	8b 40 48             	mov    0x48(%eax),%eax
  801bbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc7:	c7 04 24 f5 33 80 00 	movl   $0x8033f5,(%esp)
  801bce:	e8 11 e7 ff ff       	call   8002e4 <cprintf>
		return -E_INVAL;
  801bd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd8:	eb 24                	jmp    801bfe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bdd:	8b 52 0c             	mov    0xc(%edx),%edx
  801be0:	85 d2                	test   %edx,%edx
  801be2:	74 15                	je     801bf9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801be4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801beb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bf2:	89 04 24             	mov    %eax,(%esp)
  801bf5:	ff d2                	call   *%edx
  801bf7:	eb 05                	jmp    801bfe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801bf9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801bfe:	83 c4 24             	add    $0x24,%esp
  801c01:	5b                   	pop    %ebx
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    

00801c04 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c0a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	89 04 24             	mov    %eax,(%esp)
  801c17:	e8 ea fb ff ff       	call   801806 <fd_lookup>
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	78 0e                	js     801c2e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801c20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c26:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	53                   	push   %ebx
  801c34:	83 ec 24             	sub    $0x24,%esp
  801c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c3a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c41:	89 1c 24             	mov    %ebx,(%esp)
  801c44:	e8 bd fb ff ff       	call   801806 <fd_lookup>
  801c49:	89 c2                	mov    %eax,%edx
  801c4b:	85 d2                	test   %edx,%edx
  801c4d:	78 61                	js     801cb0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c59:	8b 00                	mov    (%eax),%eax
  801c5b:	89 04 24             	mov    %eax,(%esp)
  801c5e:	e8 f9 fb ff ff       	call   80185c <dev_lookup>
  801c63:	85 c0                	test   %eax,%eax
  801c65:	78 49                	js     801cb0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c6e:	75 23                	jne    801c93 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801c70:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c75:	8b 40 48             	mov    0x48(%eax),%eax
  801c78:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c80:	c7 04 24 b8 33 80 00 	movl   $0x8033b8,(%esp)
  801c87:	e8 58 e6 ff ff       	call   8002e4 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801c8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c91:	eb 1d                	jmp    801cb0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801c93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c96:	8b 52 18             	mov    0x18(%edx),%edx
  801c99:	85 d2                	test   %edx,%edx
  801c9b:	74 0e                	je     801cab <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ca0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca4:	89 04 24             	mov    %eax,(%esp)
  801ca7:	ff d2                	call   *%edx
  801ca9:	eb 05                	jmp    801cb0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801cab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801cb0:	83 c4 24             	add    $0x24,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5d                   	pop    %ebp
  801cb5:	c3                   	ret    

00801cb6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	53                   	push   %ebx
  801cba:	83 ec 24             	sub    $0x24,%esp
  801cbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	89 04 24             	mov    %eax,(%esp)
  801ccd:	e8 34 fb ff ff       	call   801806 <fd_lookup>
  801cd2:	89 c2                	mov    %eax,%edx
  801cd4:	85 d2                	test   %edx,%edx
  801cd6:	78 52                	js     801d2a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce2:	8b 00                	mov    (%eax),%eax
  801ce4:	89 04 24             	mov    %eax,(%esp)
  801ce7:	e8 70 fb ff ff       	call   80185c <dev_lookup>
  801cec:	85 c0                	test   %eax,%eax
  801cee:	78 3a                	js     801d2a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cf7:	74 2c                	je     801d25 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cf9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cfc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d03:	00 00 00 
	stat->st_isdir = 0;
  801d06:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d0d:	00 00 00 
	stat->st_dev = dev;
  801d10:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d16:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d1d:	89 14 24             	mov    %edx,(%esp)
  801d20:	ff 50 14             	call   *0x14(%eax)
  801d23:	eb 05                	jmp    801d2a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801d25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801d2a:	83 c4 24             	add    $0x24,%esp
  801d2d:	5b                   	pop    %ebx
  801d2e:	5d                   	pop    %ebp
  801d2f:	c3                   	ret    

00801d30 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	56                   	push   %esi
  801d34:	53                   	push   %ebx
  801d35:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d3f:	00 
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	89 04 24             	mov    %eax,(%esp)
  801d46:	e8 99 02 00 00       	call   801fe4 <open>
  801d4b:	89 c3                	mov    %eax,%ebx
  801d4d:	85 db                	test   %ebx,%ebx
  801d4f:	78 1b                	js     801d6c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d58:	89 1c 24             	mov    %ebx,(%esp)
  801d5b:	e8 56 ff ff ff       	call   801cb6 <fstat>
  801d60:	89 c6                	mov    %eax,%esi
	close(fd);
  801d62:	89 1c 24             	mov    %ebx,(%esp)
  801d65:	e8 cd fb ff ff       	call   801937 <close>
	return r;
  801d6a:	89 f0                	mov    %esi,%eax
}
  801d6c:	83 c4 10             	add    $0x10,%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    

00801d73 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	56                   	push   %esi
  801d77:	53                   	push   %ebx
  801d78:	83 ec 10             	sub    $0x10,%esp
  801d7b:	89 c6                	mov    %eax,%esi
  801d7d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d7f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d86:	75 11                	jne    801d99 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d8f:	e8 bb f9 ff ff       	call   80174f <ipc_find_env>
  801d94:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d99:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801da0:	00 
  801da1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801da8:	00 
  801da9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dad:	a1 00 50 80 00       	mov    0x805000,%eax
  801db2:	89 04 24             	mov    %eax,(%esp)
  801db5:	e8 2e f9 ff ff       	call   8016e8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801dba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dc1:	00 
  801dc2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dcd:	e8 ae f8 ff ff       	call   801680 <ipc_recv>
}
  801dd2:	83 c4 10             	add    $0x10,%esp
  801dd5:	5b                   	pop    %ebx
  801dd6:	5e                   	pop    %esi
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    

00801dd9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	8b 40 0c             	mov    0xc(%eax),%eax
  801de5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ded:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801df2:	ba 00 00 00 00       	mov    $0x0,%edx
  801df7:	b8 02 00 00 00       	mov    $0x2,%eax
  801dfc:	e8 72 ff ff ff       	call   801d73 <fsipc>
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e14:	ba 00 00 00 00       	mov    $0x0,%edx
  801e19:	b8 06 00 00 00       	mov    $0x6,%eax
  801e1e:	e8 50 ff ff ff       	call   801d73 <fsipc>
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	53                   	push   %ebx
  801e29:	83 ec 14             	sub    $0x14,%esp
  801e2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	8b 40 0c             	mov    0xc(%eax),%eax
  801e35:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801e44:	e8 2a ff ff ff       	call   801d73 <fsipc>
  801e49:	89 c2                	mov    %eax,%edx
  801e4b:	85 d2                	test   %edx,%edx
  801e4d:	78 2b                	js     801e7a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e4f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e56:	00 
  801e57:	89 1c 24             	mov    %ebx,(%esp)
  801e5a:	e8 f8 ea ff ff       	call   800957 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e5f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e6a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7a:	83 c4 14             	add    $0x14,%esp
  801e7d:	5b                   	pop    %ebx
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    

00801e80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	53                   	push   %ebx
  801e84:	83 ec 14             	sub    $0x14,%esp
  801e87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801e8a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801e90:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801e95:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e98:	8b 55 08             	mov    0x8(%ebp),%edx
  801e9b:	8b 52 0c             	mov    0xc(%edx),%edx
  801e9e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801ea4:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801ea9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb4:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801ebb:	e8 34 ec ff ff       	call   800af4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801ec0:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801ec7:	00 
  801ec8:	c7 04 24 28 34 80 00 	movl   $0x803428,(%esp)
  801ecf:	e8 10 e4 ff ff       	call   8002e4 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ed4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed9:	b8 04 00 00 00       	mov    $0x4,%eax
  801ede:	e8 90 fe ff ff       	call   801d73 <fsipc>
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	78 53                	js     801f3a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801ee7:	39 c3                	cmp    %eax,%ebx
  801ee9:	73 24                	jae    801f0f <devfile_write+0x8f>
  801eeb:	c7 44 24 0c 2d 34 80 	movl   $0x80342d,0xc(%esp)
  801ef2:	00 
  801ef3:	c7 44 24 08 34 34 80 	movl   $0x803434,0x8(%esp)
  801efa:	00 
  801efb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801f02:	00 
  801f03:	c7 04 24 49 34 80 00 	movl   $0x803449,(%esp)
  801f0a:	e8 d7 0b 00 00       	call   802ae6 <_panic>
	assert(r <= PGSIZE);
  801f0f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f14:	7e 24                	jle    801f3a <devfile_write+0xba>
  801f16:	c7 44 24 0c 54 34 80 	movl   $0x803454,0xc(%esp)
  801f1d:	00 
  801f1e:	c7 44 24 08 34 34 80 	movl   $0x803434,0x8(%esp)
  801f25:	00 
  801f26:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801f2d:	00 
  801f2e:	c7 04 24 49 34 80 00 	movl   $0x803449,(%esp)
  801f35:	e8 ac 0b 00 00       	call   802ae6 <_panic>
	return r;
}
  801f3a:	83 c4 14             	add    $0x14,%esp
  801f3d:	5b                   	pop    %ebx
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    

00801f40 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	56                   	push   %esi
  801f44:	53                   	push   %ebx
  801f45:	83 ec 10             	sub    $0x10,%esp
  801f48:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f51:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f56:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f61:	b8 03 00 00 00       	mov    $0x3,%eax
  801f66:	e8 08 fe ff ff       	call   801d73 <fsipc>
  801f6b:	89 c3                	mov    %eax,%ebx
  801f6d:	85 c0                	test   %eax,%eax
  801f6f:	78 6a                	js     801fdb <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801f71:	39 c6                	cmp    %eax,%esi
  801f73:	73 24                	jae    801f99 <devfile_read+0x59>
  801f75:	c7 44 24 0c 2d 34 80 	movl   $0x80342d,0xc(%esp)
  801f7c:	00 
  801f7d:	c7 44 24 08 34 34 80 	movl   $0x803434,0x8(%esp)
  801f84:	00 
  801f85:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801f8c:	00 
  801f8d:	c7 04 24 49 34 80 00 	movl   $0x803449,(%esp)
  801f94:	e8 4d 0b 00 00       	call   802ae6 <_panic>
	assert(r <= PGSIZE);
  801f99:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f9e:	7e 24                	jle    801fc4 <devfile_read+0x84>
  801fa0:	c7 44 24 0c 54 34 80 	movl   $0x803454,0xc(%esp)
  801fa7:	00 
  801fa8:	c7 44 24 08 34 34 80 	movl   $0x803434,0x8(%esp)
  801faf:	00 
  801fb0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801fb7:	00 
  801fb8:	c7 04 24 49 34 80 00 	movl   $0x803449,(%esp)
  801fbf:	e8 22 0b 00 00       	call   802ae6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801fc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc8:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fcf:	00 
  801fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd3:	89 04 24             	mov    %eax,(%esp)
  801fd6:	e8 19 eb ff ff       	call   800af4 <memmove>
	return r;
}
  801fdb:	89 d8                	mov    %ebx,%eax
  801fdd:	83 c4 10             	add    $0x10,%esp
  801fe0:	5b                   	pop    %ebx
  801fe1:	5e                   	pop    %esi
  801fe2:	5d                   	pop    %ebp
  801fe3:	c3                   	ret    

00801fe4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	53                   	push   %ebx
  801fe8:	83 ec 24             	sub    $0x24,%esp
  801feb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801fee:	89 1c 24             	mov    %ebx,(%esp)
  801ff1:	e8 2a e9 ff ff       	call   800920 <strlen>
  801ff6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ffb:	7f 60                	jg     80205d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ffd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802000:	89 04 24             	mov    %eax,(%esp)
  802003:	e8 af f7 ff ff       	call   8017b7 <fd_alloc>
  802008:	89 c2                	mov    %eax,%edx
  80200a:	85 d2                	test   %edx,%edx
  80200c:	78 54                	js     802062 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80200e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802012:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802019:	e8 39 e9 ff ff       	call   800957 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80201e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802021:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802026:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802029:	b8 01 00 00 00       	mov    $0x1,%eax
  80202e:	e8 40 fd ff ff       	call   801d73 <fsipc>
  802033:	89 c3                	mov    %eax,%ebx
  802035:	85 c0                	test   %eax,%eax
  802037:	79 17                	jns    802050 <open+0x6c>
		fd_close(fd, 0);
  802039:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802040:	00 
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	89 04 24             	mov    %eax,(%esp)
  802047:	e8 6a f8 ff ff       	call   8018b6 <fd_close>
		return r;
  80204c:	89 d8                	mov    %ebx,%eax
  80204e:	eb 12                	jmp    802062 <open+0x7e>
	}

	return fd2num(fd);
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	89 04 24             	mov    %eax,(%esp)
  802056:	e8 35 f7 ff ff       	call   801790 <fd2num>
  80205b:	eb 05                	jmp    802062 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80205d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802062:	83 c4 24             	add    $0x24,%esp
  802065:	5b                   	pop    %ebx
  802066:	5d                   	pop    %ebp
  802067:	c3                   	ret    

00802068 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80206e:	ba 00 00 00 00       	mov    $0x0,%edx
  802073:	b8 08 00 00 00       	mov    $0x8,%eax
  802078:	e8 f6 fc ff ff       	call   801d73 <fsipc>
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <evict>:

int evict(void)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  802085:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  80208c:	e8 53 e2 ff ff       	call   8002e4 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  802091:	ba 00 00 00 00       	mov    $0x0,%edx
  802096:	b8 09 00 00 00       	mov    $0x9,%eax
  80209b:	e8 d3 fc ff ff       	call   801d73 <fsipc>
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    
  8020a2:	66 90                	xchg   %ax,%ax
  8020a4:	66 90                	xchg   %ax,%ax
  8020a6:	66 90                	xchg   %ax,%ax
  8020a8:	66 90                	xchg   %ax,%ax
  8020aa:	66 90                	xchg   %ax,%ax
  8020ac:	66 90                	xchg   %ax,%ax
  8020ae:	66 90                	xchg   %ax,%ax

008020b0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8020b6:	c7 44 24 04 79 34 80 	movl   $0x803479,0x4(%esp)
  8020bd:	00 
  8020be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c1:	89 04 24             	mov    %eax,(%esp)
  8020c4:	e8 8e e8 ff ff       	call   800957 <strcpy>
	return 0;
}
  8020c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	53                   	push   %ebx
  8020d4:	83 ec 14             	sub    $0x14,%esp
  8020d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020da:	89 1c 24             	mov    %ebx,(%esp)
  8020dd:	e8 13 0b 00 00       	call   802bf5 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8020e2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8020e7:	83 f8 01             	cmp    $0x1,%eax
  8020ea:	75 0d                	jne    8020f9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8020ec:	8b 43 0c             	mov    0xc(%ebx),%eax
  8020ef:	89 04 24             	mov    %eax,(%esp)
  8020f2:	e8 29 03 00 00       	call   802420 <nsipc_close>
  8020f7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8020f9:	89 d0                	mov    %edx,%eax
  8020fb:	83 c4 14             	add    $0x14,%esp
  8020fe:	5b                   	pop    %ebx
  8020ff:	5d                   	pop    %ebp
  802100:	c3                   	ret    

00802101 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802107:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80210e:	00 
  80210f:	8b 45 10             	mov    0x10(%ebp),%eax
  802112:	89 44 24 08          	mov    %eax,0x8(%esp)
  802116:	8b 45 0c             	mov    0xc(%ebp),%eax
  802119:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	8b 40 0c             	mov    0xc(%eax),%eax
  802123:	89 04 24             	mov    %eax,(%esp)
  802126:	e8 f0 03 00 00       	call   80251b <nsipc_send>
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802133:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80213a:	00 
  80213b:	8b 45 10             	mov    0x10(%ebp),%eax
  80213e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802142:	8b 45 0c             	mov    0xc(%ebp),%eax
  802145:	89 44 24 04          	mov    %eax,0x4(%esp)
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8b 40 0c             	mov    0xc(%eax),%eax
  80214f:	89 04 24             	mov    %eax,(%esp)
  802152:	e8 44 03 00 00       	call   80249b <nsipc_recv>
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80215f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802162:	89 54 24 04          	mov    %edx,0x4(%esp)
  802166:	89 04 24             	mov    %eax,(%esp)
  802169:	e8 98 f6 ff ff       	call   801806 <fd_lookup>
  80216e:	85 c0                	test   %eax,%eax
  802170:	78 17                	js     802189 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802175:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  80217b:	39 08                	cmp    %ecx,(%eax)
  80217d:	75 05                	jne    802184 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80217f:	8b 40 0c             	mov    0xc(%eax),%eax
  802182:	eb 05                	jmp    802189 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802184:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	56                   	push   %esi
  80218f:	53                   	push   %ebx
  802190:	83 ec 20             	sub    $0x20,%esp
  802193:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802195:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802198:	89 04 24             	mov    %eax,(%esp)
  80219b:	e8 17 f6 ff ff       	call   8017b7 <fd_alloc>
  8021a0:	89 c3                	mov    %eax,%ebx
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	78 21                	js     8021c7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8021a6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021ad:	00 
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021bc:	e8 04 ec ff ff       	call   800dc5 <sys_page_alloc>
  8021c1:	89 c3                	mov    %eax,%ebx
  8021c3:	85 c0                	test   %eax,%eax
  8021c5:	79 0c                	jns    8021d3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8021c7:	89 34 24             	mov    %esi,(%esp)
  8021ca:	e8 51 02 00 00       	call   802420 <nsipc_close>
		return r;
  8021cf:	89 d8                	mov    %ebx,%eax
  8021d1:	eb 20                	jmp    8021f3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8021d3:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8021de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8021e8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8021eb:	89 14 24             	mov    %edx,(%esp)
  8021ee:	e8 9d f5 ff ff       	call   801790 <fd2num>
}
  8021f3:	83 c4 20             	add    $0x20,%esp
  8021f6:	5b                   	pop    %ebx
  8021f7:	5e                   	pop    %esi
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    

008021fa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	e8 51 ff ff ff       	call   802159 <fd2sockid>
		return r;
  802208:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80220a:	85 c0                	test   %eax,%eax
  80220c:	78 23                	js     802231 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80220e:	8b 55 10             	mov    0x10(%ebp),%edx
  802211:	89 54 24 08          	mov    %edx,0x8(%esp)
  802215:	8b 55 0c             	mov    0xc(%ebp),%edx
  802218:	89 54 24 04          	mov    %edx,0x4(%esp)
  80221c:	89 04 24             	mov    %eax,(%esp)
  80221f:	e8 45 01 00 00       	call   802369 <nsipc_accept>
		return r;
  802224:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802226:	85 c0                	test   %eax,%eax
  802228:	78 07                	js     802231 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80222a:	e8 5c ff ff ff       	call   80218b <alloc_sockfd>
  80222f:	89 c1                	mov    %eax,%ecx
}
  802231:	89 c8                	mov    %ecx,%eax
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	e8 16 ff ff ff       	call   802159 <fd2sockid>
  802243:	89 c2                	mov    %eax,%edx
  802245:	85 d2                	test   %edx,%edx
  802247:	78 16                	js     80225f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802249:	8b 45 10             	mov    0x10(%ebp),%eax
  80224c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802250:	8b 45 0c             	mov    0xc(%ebp),%eax
  802253:	89 44 24 04          	mov    %eax,0x4(%esp)
  802257:	89 14 24             	mov    %edx,(%esp)
  80225a:	e8 60 01 00 00       	call   8023bf <nsipc_bind>
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <shutdown>:

int
shutdown(int s, int how)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	e8 ea fe ff ff       	call   802159 <fd2sockid>
  80226f:	89 c2                	mov    %eax,%edx
  802271:	85 d2                	test   %edx,%edx
  802273:	78 0f                	js     802284 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802275:	8b 45 0c             	mov    0xc(%ebp),%eax
  802278:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227c:	89 14 24             	mov    %edx,(%esp)
  80227f:	e8 7a 01 00 00       	call   8023fe <nsipc_shutdown>
}
  802284:	c9                   	leave  
  802285:	c3                   	ret    

00802286 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
  802289:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	e8 c5 fe ff ff       	call   802159 <fd2sockid>
  802294:	89 c2                	mov    %eax,%edx
  802296:	85 d2                	test   %edx,%edx
  802298:	78 16                	js     8022b0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80229a:	8b 45 10             	mov    0x10(%ebp),%eax
  80229d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a8:	89 14 24             	mov    %edx,(%esp)
  8022ab:	e8 8a 01 00 00       	call   80243a <nsipc_connect>
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <listen>:

int
listen(int s, int backlog)
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
  8022b5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	e8 99 fe ff ff       	call   802159 <fd2sockid>
  8022c0:	89 c2                	mov    %eax,%edx
  8022c2:	85 d2                	test   %edx,%edx
  8022c4:	78 0f                	js     8022d5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8022c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022cd:	89 14 24             	mov    %edx,(%esp)
  8022d0:	e8 a4 01 00 00       	call   802479 <nsipc_listen>
}
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8022dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	89 04 24             	mov    %eax,(%esp)
  8022f1:	e8 98 02 00 00       	call   80258e <nsipc_socket>
  8022f6:	89 c2                	mov    %eax,%edx
  8022f8:	85 d2                	test   %edx,%edx
  8022fa:	78 05                	js     802301 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8022fc:	e8 8a fe ff ff       	call   80218b <alloc_sockfd>
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	53                   	push   %ebx
  802307:	83 ec 14             	sub    $0x14,%esp
  80230a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80230c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802313:	75 11                	jne    802326 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802315:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80231c:	e8 2e f4 ff ff       	call   80174f <ipc_find_env>
  802321:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802326:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80232d:	00 
  80232e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802335:	00 
  802336:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80233a:	a1 04 50 80 00       	mov    0x805004,%eax
  80233f:	89 04 24             	mov    %eax,(%esp)
  802342:	e8 a1 f3 ff ff       	call   8016e8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802347:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80234e:	00 
  80234f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802356:	00 
  802357:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80235e:	e8 1d f3 ff ff       	call   801680 <ipc_recv>
}
  802363:	83 c4 14             	add    $0x14,%esp
  802366:	5b                   	pop    %ebx
  802367:	5d                   	pop    %ebp
  802368:	c3                   	ret    

00802369 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	56                   	push   %esi
  80236d:	53                   	push   %ebx
  80236e:	83 ec 10             	sub    $0x10,%esp
  802371:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80237c:	8b 06                	mov    (%esi),%eax
  80237e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802383:	b8 01 00 00 00       	mov    $0x1,%eax
  802388:	e8 76 ff ff ff       	call   802303 <nsipc>
  80238d:	89 c3                	mov    %eax,%ebx
  80238f:	85 c0                	test   %eax,%eax
  802391:	78 23                	js     8023b6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802393:	a1 10 70 80 00       	mov    0x807010,%eax
  802398:	89 44 24 08          	mov    %eax,0x8(%esp)
  80239c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8023a3:	00 
  8023a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a7:	89 04 24             	mov    %eax,(%esp)
  8023aa:	e8 45 e7 ff ff       	call   800af4 <memmove>
		*addrlen = ret->ret_addrlen;
  8023af:	a1 10 70 80 00       	mov    0x807010,%eax
  8023b4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8023b6:	89 d8                	mov    %ebx,%eax
  8023b8:	83 c4 10             	add    $0x10,%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5e                   	pop    %esi
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	53                   	push   %ebx
  8023c3:	83 ec 14             	sub    $0x14,%esp
  8023c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8023d1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023dc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8023e3:	e8 0c e7 ff ff       	call   800af4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023e8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8023ee:	b8 02 00 00 00       	mov    $0x2,%eax
  8023f3:	e8 0b ff ff ff       	call   802303 <nsipc>
}
  8023f8:	83 c4 14             	add    $0x14,%esp
  8023fb:	5b                   	pop    %ebx
  8023fc:	5d                   	pop    %ebp
  8023fd:	c3                   	ret    

008023fe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80240c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802414:	b8 03 00 00 00       	mov    $0x3,%eax
  802419:	e8 e5 fe ff ff       	call   802303 <nsipc>
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <nsipc_close>:

int
nsipc_close(int s)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80242e:	b8 04 00 00 00       	mov    $0x4,%eax
  802433:	e8 cb fe ff ff       	call   802303 <nsipc>
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	53                   	push   %ebx
  80243e:	83 ec 14             	sub    $0x14,%esp
  802441:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80244c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802450:	8b 45 0c             	mov    0xc(%ebp),%eax
  802453:	89 44 24 04          	mov    %eax,0x4(%esp)
  802457:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80245e:	e8 91 e6 ff ff       	call   800af4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802463:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802469:	b8 05 00 00 00       	mov    $0x5,%eax
  80246e:	e8 90 fe ff ff       	call   802303 <nsipc>
}
  802473:	83 c4 14             	add    $0x14,%esp
  802476:	5b                   	pop    %ebx
  802477:	5d                   	pop    %ebp
  802478:	c3                   	ret    

00802479 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
  80247c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80248f:	b8 06 00 00 00       	mov    $0x6,%eax
  802494:	e8 6a fe ff ff       	call   802303 <nsipc>
}
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	56                   	push   %esi
  80249f:	53                   	push   %ebx
  8024a0:	83 ec 10             	sub    $0x10,%esp
  8024a3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8024ae:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8024b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8024b7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8024bc:	b8 07 00 00 00       	mov    $0x7,%eax
  8024c1:	e8 3d fe ff ff       	call   802303 <nsipc>
  8024c6:	89 c3                	mov    %eax,%ebx
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	78 46                	js     802512 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8024cc:	39 f0                	cmp    %esi,%eax
  8024ce:	7f 07                	jg     8024d7 <nsipc_recv+0x3c>
  8024d0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8024d5:	7e 24                	jle    8024fb <nsipc_recv+0x60>
  8024d7:	c7 44 24 0c 85 34 80 	movl   $0x803485,0xc(%esp)
  8024de:	00 
  8024df:	c7 44 24 08 34 34 80 	movl   $0x803434,0x8(%esp)
  8024e6:	00 
  8024e7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8024ee:	00 
  8024ef:	c7 04 24 9a 34 80 00 	movl   $0x80349a,(%esp)
  8024f6:	e8 eb 05 00 00       	call   802ae6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8024fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024ff:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802506:	00 
  802507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250a:	89 04 24             	mov    %eax,(%esp)
  80250d:	e8 e2 e5 ff ff       	call   800af4 <memmove>
	}

	return r;
}
  802512:	89 d8                	mov    %ebx,%eax
  802514:	83 c4 10             	add    $0x10,%esp
  802517:	5b                   	pop    %ebx
  802518:	5e                   	pop    %esi
  802519:	5d                   	pop    %ebp
  80251a:	c3                   	ret    

0080251b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	53                   	push   %ebx
  80251f:	83 ec 14             	sub    $0x14,%esp
  802522:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80252d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802533:	7e 24                	jle    802559 <nsipc_send+0x3e>
  802535:	c7 44 24 0c a6 34 80 	movl   $0x8034a6,0xc(%esp)
  80253c:	00 
  80253d:	c7 44 24 08 34 34 80 	movl   $0x803434,0x8(%esp)
  802544:	00 
  802545:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80254c:	00 
  80254d:	c7 04 24 9a 34 80 00 	movl   $0x80349a,(%esp)
  802554:	e8 8d 05 00 00       	call   802ae6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802559:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80255d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802560:	89 44 24 04          	mov    %eax,0x4(%esp)
  802564:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80256b:	e8 84 e5 ff ff       	call   800af4 <memmove>
	nsipcbuf.send.req_size = size;
  802570:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802576:	8b 45 14             	mov    0x14(%ebp),%eax
  802579:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80257e:	b8 08 00 00 00       	mov    $0x8,%eax
  802583:	e8 7b fd ff ff       	call   802303 <nsipc>
}
  802588:	83 c4 14             	add    $0x14,%esp
  80258b:	5b                   	pop    %ebx
  80258c:	5d                   	pop    %ebp
  80258d:	c3                   	ret    

0080258e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
  802591:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80259c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8025a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8025ac:	b8 09 00 00 00       	mov    $0x9,%eax
  8025b1:	e8 4d fd ff ff       	call   802303 <nsipc>
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	56                   	push   %esi
  8025bc:	53                   	push   %ebx
  8025bd:	83 ec 10             	sub    $0x10,%esp
  8025c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	89 04 24             	mov    %eax,(%esp)
  8025c9:	e8 d2 f1 ff ff       	call   8017a0 <fd2data>
  8025ce:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8025d0:	c7 44 24 04 b2 34 80 	movl   $0x8034b2,0x4(%esp)
  8025d7:	00 
  8025d8:	89 1c 24             	mov    %ebx,(%esp)
  8025db:	e8 77 e3 ff ff       	call   800957 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8025e0:	8b 46 04             	mov    0x4(%esi),%eax
  8025e3:	2b 06                	sub    (%esi),%eax
  8025e5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8025eb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8025f2:	00 00 00 
	stat->st_dev = &devpipe;
  8025f5:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  8025fc:	40 80 00 
	return 0;
}
  8025ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802604:	83 c4 10             	add    $0x10,%esp
  802607:	5b                   	pop    %ebx
  802608:	5e                   	pop    %esi
  802609:	5d                   	pop    %ebp
  80260a:	c3                   	ret    

0080260b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
  80260e:	53                   	push   %ebx
  80260f:	83 ec 14             	sub    $0x14,%esp
  802612:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802615:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802619:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802620:	e8 47 e8 ff ff       	call   800e6c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802625:	89 1c 24             	mov    %ebx,(%esp)
  802628:	e8 73 f1 ff ff       	call   8017a0 <fd2data>
  80262d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802631:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802638:	e8 2f e8 ff ff       	call   800e6c <sys_page_unmap>
}
  80263d:	83 c4 14             	add    $0x14,%esp
  802640:	5b                   	pop    %ebx
  802641:	5d                   	pop    %ebp
  802642:	c3                   	ret    

00802643 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	57                   	push   %edi
  802647:	56                   	push   %esi
  802648:	53                   	push   %ebx
  802649:	83 ec 2c             	sub    $0x2c,%esp
  80264c:	89 c6                	mov    %eax,%esi
  80264e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802651:	a1 08 50 80 00       	mov    0x805008,%eax
  802656:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802659:	89 34 24             	mov    %esi,(%esp)
  80265c:	e8 94 05 00 00       	call   802bf5 <pageref>
  802661:	89 c7                	mov    %eax,%edi
  802663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802666:	89 04 24             	mov    %eax,(%esp)
  802669:	e8 87 05 00 00       	call   802bf5 <pageref>
  80266e:	39 c7                	cmp    %eax,%edi
  802670:	0f 94 c2             	sete   %dl
  802673:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802676:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80267c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80267f:	39 fb                	cmp    %edi,%ebx
  802681:	74 21                	je     8026a4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802683:	84 d2                	test   %dl,%dl
  802685:	74 ca                	je     802651 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802687:	8b 51 58             	mov    0x58(%ecx),%edx
  80268a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80268e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802692:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802696:	c7 04 24 b9 34 80 00 	movl   $0x8034b9,(%esp)
  80269d:	e8 42 dc ff ff       	call   8002e4 <cprintf>
  8026a2:	eb ad                	jmp    802651 <_pipeisclosed+0xe>
	}
}
  8026a4:	83 c4 2c             	add    $0x2c,%esp
  8026a7:	5b                   	pop    %ebx
  8026a8:	5e                   	pop    %esi
  8026a9:	5f                   	pop    %edi
  8026aa:	5d                   	pop    %ebp
  8026ab:	c3                   	ret    

008026ac <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026ac:	55                   	push   %ebp
  8026ad:	89 e5                	mov    %esp,%ebp
  8026af:	57                   	push   %edi
  8026b0:	56                   	push   %esi
  8026b1:	53                   	push   %ebx
  8026b2:	83 ec 1c             	sub    $0x1c,%esp
  8026b5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8026b8:	89 34 24             	mov    %esi,(%esp)
  8026bb:	e8 e0 f0 ff ff       	call   8017a0 <fd2data>
  8026c0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c7:	eb 45                	jmp    80270e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8026c9:	89 da                	mov    %ebx,%edx
  8026cb:	89 f0                	mov    %esi,%eax
  8026cd:	e8 71 ff ff ff       	call   802643 <_pipeisclosed>
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	75 41                	jne    802717 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8026d6:	e8 cb e6 ff ff       	call   800da6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026db:	8b 43 04             	mov    0x4(%ebx),%eax
  8026de:	8b 0b                	mov    (%ebx),%ecx
  8026e0:	8d 51 20             	lea    0x20(%ecx),%edx
  8026e3:	39 d0                	cmp    %edx,%eax
  8026e5:	73 e2                	jae    8026c9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026ea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8026ee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8026f1:	99                   	cltd   
  8026f2:	c1 ea 1b             	shr    $0x1b,%edx
  8026f5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8026f8:	83 e1 1f             	and    $0x1f,%ecx
  8026fb:	29 d1                	sub    %edx,%ecx
  8026fd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802701:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802705:	83 c0 01             	add    $0x1,%eax
  802708:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80270b:	83 c7 01             	add    $0x1,%edi
  80270e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802711:	75 c8                	jne    8026db <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802713:	89 f8                	mov    %edi,%eax
  802715:	eb 05                	jmp    80271c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80271c:	83 c4 1c             	add    $0x1c,%esp
  80271f:	5b                   	pop    %ebx
  802720:	5e                   	pop    %esi
  802721:	5f                   	pop    %edi
  802722:	5d                   	pop    %ebp
  802723:	c3                   	ret    

00802724 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
  802727:	57                   	push   %edi
  802728:	56                   	push   %esi
  802729:	53                   	push   %ebx
  80272a:	83 ec 1c             	sub    $0x1c,%esp
  80272d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802730:	89 3c 24             	mov    %edi,(%esp)
  802733:	e8 68 f0 ff ff       	call   8017a0 <fd2data>
  802738:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80273a:	be 00 00 00 00       	mov    $0x0,%esi
  80273f:	eb 3d                	jmp    80277e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802741:	85 f6                	test   %esi,%esi
  802743:	74 04                	je     802749 <devpipe_read+0x25>
				return i;
  802745:	89 f0                	mov    %esi,%eax
  802747:	eb 43                	jmp    80278c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802749:	89 da                	mov    %ebx,%edx
  80274b:	89 f8                	mov    %edi,%eax
  80274d:	e8 f1 fe ff ff       	call   802643 <_pipeisclosed>
  802752:	85 c0                	test   %eax,%eax
  802754:	75 31                	jne    802787 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802756:	e8 4b e6 ff ff       	call   800da6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80275b:	8b 03                	mov    (%ebx),%eax
  80275d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802760:	74 df                	je     802741 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802762:	99                   	cltd   
  802763:	c1 ea 1b             	shr    $0x1b,%edx
  802766:	01 d0                	add    %edx,%eax
  802768:	83 e0 1f             	and    $0x1f,%eax
  80276b:	29 d0                	sub    %edx,%eax
  80276d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802772:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802775:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802778:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80277b:	83 c6 01             	add    $0x1,%esi
  80277e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802781:	75 d8                	jne    80275b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802783:	89 f0                	mov    %esi,%eax
  802785:	eb 05                	jmp    80278c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80278c:	83 c4 1c             	add    $0x1c,%esp
  80278f:	5b                   	pop    %ebx
  802790:	5e                   	pop    %esi
  802791:	5f                   	pop    %edi
  802792:	5d                   	pop    %ebp
  802793:	c3                   	ret    

00802794 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802794:	55                   	push   %ebp
  802795:	89 e5                	mov    %esp,%ebp
  802797:	56                   	push   %esi
  802798:	53                   	push   %ebx
  802799:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80279c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80279f:	89 04 24             	mov    %eax,(%esp)
  8027a2:	e8 10 f0 ff ff       	call   8017b7 <fd_alloc>
  8027a7:	89 c2                	mov    %eax,%edx
  8027a9:	85 d2                	test   %edx,%edx
  8027ab:	0f 88 4d 01 00 00    	js     8028fe <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027b1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027b8:	00 
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027c7:	e8 f9 e5 ff ff       	call   800dc5 <sys_page_alloc>
  8027cc:	89 c2                	mov    %eax,%edx
  8027ce:	85 d2                	test   %edx,%edx
  8027d0:	0f 88 28 01 00 00    	js     8028fe <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8027d9:	89 04 24             	mov    %eax,(%esp)
  8027dc:	e8 d6 ef ff ff       	call   8017b7 <fd_alloc>
  8027e1:	89 c3                	mov    %eax,%ebx
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	0f 88 fe 00 00 00    	js     8028e9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027eb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027f2:	00 
  8027f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802801:	e8 bf e5 ff ff       	call   800dc5 <sys_page_alloc>
  802806:	89 c3                	mov    %eax,%ebx
  802808:	85 c0                	test   %eax,%eax
  80280a:	0f 88 d9 00 00 00    	js     8028e9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	89 04 24             	mov    %eax,(%esp)
  802816:	e8 85 ef ff ff       	call   8017a0 <fd2data>
  80281b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80281d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802824:	00 
  802825:	89 44 24 04          	mov    %eax,0x4(%esp)
  802829:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802830:	e8 90 e5 ff ff       	call   800dc5 <sys_page_alloc>
  802835:	89 c3                	mov    %eax,%ebx
  802837:	85 c0                	test   %eax,%eax
  802839:	0f 88 97 00 00 00    	js     8028d6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802842:	89 04 24             	mov    %eax,(%esp)
  802845:	e8 56 ef ff ff       	call   8017a0 <fd2data>
  80284a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802851:	00 
  802852:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802856:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80285d:	00 
  80285e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802862:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802869:	e8 ab e5 ff ff       	call   800e19 <sys_page_map>
  80286e:	89 c3                	mov    %eax,%ebx
  802870:	85 c0                	test   %eax,%eax
  802872:	78 52                	js     8028c6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802874:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802889:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	89 04 24             	mov    %eax,(%esp)
  8028a4:	e8 e7 ee ff ff       	call   801790 <fd2num>
  8028a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028ac:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	89 04 24             	mov    %eax,(%esp)
  8028b4:	e8 d7 ee ff ff       	call   801790 <fd2num>
  8028b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028bc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8028bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c4:	eb 38                	jmp    8028fe <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8028c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d1:	e8 96 e5 ff ff       	call   800e6c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8028d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028e4:	e8 83 e5 ff ff       	call   800e6c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028f7:	e8 70 e5 ff ff       	call   800e6c <sys_page_unmap>
  8028fc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8028fe:	83 c4 30             	add    $0x30,%esp
  802901:	5b                   	pop    %ebx
  802902:	5e                   	pop    %esi
  802903:	5d                   	pop    %ebp
  802904:	c3                   	ret    

00802905 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802905:	55                   	push   %ebp
  802906:	89 e5                	mov    %esp,%ebp
  802908:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80290b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80290e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	89 04 24             	mov    %eax,(%esp)
  802918:	e8 e9 ee ff ff       	call   801806 <fd_lookup>
  80291d:	89 c2                	mov    %eax,%edx
  80291f:	85 d2                	test   %edx,%edx
  802921:	78 15                	js     802938 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	89 04 24             	mov    %eax,(%esp)
  802929:	e8 72 ee ff ff       	call   8017a0 <fd2data>
	return _pipeisclosed(fd, p);
  80292e:	89 c2                	mov    %eax,%edx
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	e8 0b fd ff ff       	call   802643 <_pipeisclosed>
}
  802938:	c9                   	leave  
  802939:	c3                   	ret    
  80293a:	66 90                	xchg   %ax,%ax
  80293c:	66 90                	xchg   %ax,%ax
  80293e:	66 90                	xchg   %ax,%ax

00802940 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802943:	b8 00 00 00 00       	mov    $0x0,%eax
  802948:	5d                   	pop    %ebp
  802949:	c3                   	ret    

0080294a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802950:	c7 44 24 04 d1 34 80 	movl   $0x8034d1,0x4(%esp)
  802957:	00 
  802958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295b:	89 04 24             	mov    %eax,(%esp)
  80295e:	e8 f4 df ff ff       	call   800957 <strcpy>
	return 0;
}
  802963:	b8 00 00 00 00       	mov    $0x0,%eax
  802968:	c9                   	leave  
  802969:	c3                   	ret    

0080296a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
  80296d:	57                   	push   %edi
  80296e:	56                   	push   %esi
  80296f:	53                   	push   %ebx
  802970:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802976:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80297b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802981:	eb 31                	jmp    8029b4 <devcons_write+0x4a>
		m = n - tot;
  802983:	8b 75 10             	mov    0x10(%ebp),%esi
  802986:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802988:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80298b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802990:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802993:	89 74 24 08          	mov    %esi,0x8(%esp)
  802997:	03 45 0c             	add    0xc(%ebp),%eax
  80299a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80299e:	89 3c 24             	mov    %edi,(%esp)
  8029a1:	e8 4e e1 ff ff       	call   800af4 <memmove>
		sys_cputs(buf, m);
  8029a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029aa:	89 3c 24             	mov    %edi,(%esp)
  8029ad:	e8 f4 e2 ff ff       	call   800ca6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029b2:	01 f3                	add    %esi,%ebx
  8029b4:	89 d8                	mov    %ebx,%eax
  8029b6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8029b9:	72 c8                	jb     802983 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8029bb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8029c1:	5b                   	pop    %ebx
  8029c2:	5e                   	pop    %esi
  8029c3:	5f                   	pop    %edi
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    

008029c6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8029c6:	55                   	push   %ebp
  8029c7:	89 e5                	mov    %esp,%ebp
  8029c9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8029cc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8029d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029d5:	75 07                	jne    8029de <devcons_read+0x18>
  8029d7:	eb 2a                	jmp    802a03 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8029d9:	e8 c8 e3 ff ff       	call   800da6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8029de:	66 90                	xchg   %ax,%ax
  8029e0:	e8 df e2 ff ff       	call   800cc4 <sys_cgetc>
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	74 f0                	je     8029d9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	78 16                	js     802a03 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8029ed:	83 f8 04             	cmp    $0x4,%eax
  8029f0:	74 0c                	je     8029fe <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8029f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029f5:	88 02                	mov    %al,(%edx)
	return 1;
  8029f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8029fc:	eb 05                	jmp    802a03 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8029fe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802a03:	c9                   	leave  
  802a04:	c3                   	ret    

00802a05 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802a05:	55                   	push   %ebp
  802a06:	89 e5                	mov    %esp,%ebp
  802a08:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802a11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802a18:	00 
  802a19:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a1c:	89 04 24             	mov    %eax,(%esp)
  802a1f:	e8 82 e2 ff ff       	call   800ca6 <sys_cputs>
}
  802a24:	c9                   	leave  
  802a25:	c3                   	ret    

00802a26 <getchar>:

int
getchar(void)
{
  802a26:	55                   	push   %ebp
  802a27:	89 e5                	mov    %esp,%ebp
  802a29:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802a2c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802a33:	00 
  802a34:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a42:	e8 53 f0 ff ff       	call   801a9a <read>
	if (r < 0)
  802a47:	85 c0                	test   %eax,%eax
  802a49:	78 0f                	js     802a5a <getchar+0x34>
		return r;
	if (r < 1)
  802a4b:	85 c0                	test   %eax,%eax
  802a4d:	7e 06                	jle    802a55 <getchar+0x2f>
		return -E_EOF;
	return c;
  802a4f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802a53:	eb 05                	jmp    802a5a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802a55:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802a5a:	c9                   	leave  
  802a5b:	c3                   	ret    

00802a5c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a5c:	55                   	push   %ebp
  802a5d:	89 e5                	mov    %esp,%ebp
  802a5f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a65:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	89 04 24             	mov    %eax,(%esp)
  802a6f:	e8 92 ed ff ff       	call   801806 <fd_lookup>
  802a74:	85 c0                	test   %eax,%eax
  802a76:	78 11                	js     802a89 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802a81:	39 10                	cmp    %edx,(%eax)
  802a83:	0f 94 c0             	sete   %al
  802a86:	0f b6 c0             	movzbl %al,%eax
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    

00802a8b <opencons>:

int
opencons(void)
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
  802a8e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a94:	89 04 24             	mov    %eax,(%esp)
  802a97:	e8 1b ed ff ff       	call   8017b7 <fd_alloc>
		return r;
  802a9c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	78 40                	js     802ae2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802aa2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802aa9:	00 
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ab8:	e8 08 e3 ff ff       	call   800dc5 <sys_page_alloc>
		return r;
  802abd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	78 1f                	js     802ae2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802ac3:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802ad8:	89 04 24             	mov    %eax,(%esp)
  802adb:	e8 b0 ec ff ff       	call   801790 <fd2num>
  802ae0:	89 c2                	mov    %eax,%edx
}
  802ae2:	89 d0                	mov    %edx,%eax
  802ae4:	c9                   	leave  
  802ae5:	c3                   	ret    

00802ae6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802ae6:	55                   	push   %ebp
  802ae7:	89 e5                	mov    %esp,%ebp
  802ae9:	56                   	push   %esi
  802aea:	53                   	push   %ebx
  802aeb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  802aee:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802af1:	8b 35 08 40 80 00    	mov    0x804008,%esi
  802af7:	e8 8b e2 ff ff       	call   800d87 <sys_getenvid>
  802afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aff:	89 54 24 10          	mov    %edx,0x10(%esp)
  802b03:	8b 55 08             	mov    0x8(%ebp),%edx
  802b06:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802b0a:	89 74 24 08          	mov    %esi,0x8(%esp)
  802b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b12:	c7 04 24 e0 34 80 00 	movl   $0x8034e0,(%esp)
  802b19:	e8 c6 d7 ff ff       	call   8002e4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802b1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802b22:	8b 45 10             	mov    0x10(%ebp),%eax
  802b25:	89 04 24             	mov    %eax,(%esp)
  802b28:	e8 56 d7 ff ff       	call   800283 <vcprintf>
	cprintf("\n");
  802b2d:	c7 04 24 77 34 80 00 	movl   $0x803477,(%esp)
  802b34:	e8 ab d7 ff ff       	call   8002e4 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802b39:	cc                   	int3   
  802b3a:	eb fd                	jmp    802b39 <_panic+0x53>

00802b3c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b3c:	55                   	push   %ebp
  802b3d:	89 e5                	mov    %esp,%ebp
  802b3f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b42:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802b49:	75 7a                	jne    802bc5 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802b4b:	e8 37 e2 ff ff       	call   800d87 <sys_getenvid>
  802b50:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802b57:	00 
  802b58:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802b5f:	ee 
  802b60:	89 04 24             	mov    %eax,(%esp)
  802b63:	e8 5d e2 ff ff       	call   800dc5 <sys_page_alloc>
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	79 20                	jns    802b8c <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802b6c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b70:	c7 44 24 08 c9 32 80 	movl   $0x8032c9,0x8(%esp)
  802b77:	00 
  802b78:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802b7f:	00 
  802b80:	c7 04 24 04 35 80 00 	movl   $0x803504,(%esp)
  802b87:	e8 5a ff ff ff       	call   802ae6 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802b8c:	e8 f6 e1 ff ff       	call   800d87 <sys_getenvid>
  802b91:	c7 44 24 04 cf 2b 80 	movl   $0x802bcf,0x4(%esp)
  802b98:	00 
  802b99:	89 04 24             	mov    %eax,(%esp)
  802b9c:	e8 e4 e3 ff ff       	call   800f85 <sys_env_set_pgfault_upcall>
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	79 20                	jns    802bc5 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802ba5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ba9:	c7 44 24 08 48 33 80 	movl   $0x803348,0x8(%esp)
  802bb0:	00 
  802bb1:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802bb8:	00 
  802bb9:	c7 04 24 04 35 80 00 	movl   $0x803504,(%esp)
  802bc0:	e8 21 ff ff ff       	call   802ae6 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802bcd:	c9                   	leave  
  802bce:	c3                   	ret    

00802bcf <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802bcf:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802bd0:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802bd5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802bd7:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802bda:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802bde:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802be2:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802be5:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802be9:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802beb:	83 c4 08             	add    $0x8,%esp
	popal
  802bee:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802bef:	83 c4 04             	add    $0x4,%esp
	popfl
  802bf2:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802bf3:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802bf4:	c3                   	ret    

00802bf5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802bf5:	55                   	push   %ebp
  802bf6:	89 e5                	mov    %esp,%ebp
  802bf8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802bfb:	89 d0                	mov    %edx,%eax
  802bfd:	c1 e8 16             	shr    $0x16,%eax
  802c00:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802c07:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c0c:	f6 c1 01             	test   $0x1,%cl
  802c0f:	74 1d                	je     802c2e <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802c11:	c1 ea 0c             	shr    $0xc,%edx
  802c14:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802c1b:	f6 c2 01             	test   $0x1,%dl
  802c1e:	74 0e                	je     802c2e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802c20:	c1 ea 0c             	shr    $0xc,%edx
  802c23:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802c2a:	ef 
  802c2b:	0f b7 c0             	movzwl %ax,%eax
}
  802c2e:	5d                   	pop    %ebp
  802c2f:	c3                   	ret    

00802c30 <__udivdi3>:
  802c30:	55                   	push   %ebp
  802c31:	57                   	push   %edi
  802c32:	56                   	push   %esi
  802c33:	83 ec 0c             	sub    $0xc,%esp
  802c36:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c3a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802c3e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802c42:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c46:	85 c0                	test   %eax,%eax
  802c48:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802c4c:	89 ea                	mov    %ebp,%edx
  802c4e:	89 0c 24             	mov    %ecx,(%esp)
  802c51:	75 2d                	jne    802c80 <__udivdi3+0x50>
  802c53:	39 e9                	cmp    %ebp,%ecx
  802c55:	77 61                	ja     802cb8 <__udivdi3+0x88>
  802c57:	85 c9                	test   %ecx,%ecx
  802c59:	89 ce                	mov    %ecx,%esi
  802c5b:	75 0b                	jne    802c68 <__udivdi3+0x38>
  802c5d:	b8 01 00 00 00       	mov    $0x1,%eax
  802c62:	31 d2                	xor    %edx,%edx
  802c64:	f7 f1                	div    %ecx
  802c66:	89 c6                	mov    %eax,%esi
  802c68:	31 d2                	xor    %edx,%edx
  802c6a:	89 e8                	mov    %ebp,%eax
  802c6c:	f7 f6                	div    %esi
  802c6e:	89 c5                	mov    %eax,%ebp
  802c70:	89 f8                	mov    %edi,%eax
  802c72:	f7 f6                	div    %esi
  802c74:	89 ea                	mov    %ebp,%edx
  802c76:	83 c4 0c             	add    $0xc,%esp
  802c79:	5e                   	pop    %esi
  802c7a:	5f                   	pop    %edi
  802c7b:	5d                   	pop    %ebp
  802c7c:	c3                   	ret    
  802c7d:	8d 76 00             	lea    0x0(%esi),%esi
  802c80:	39 e8                	cmp    %ebp,%eax
  802c82:	77 24                	ja     802ca8 <__udivdi3+0x78>
  802c84:	0f bd e8             	bsr    %eax,%ebp
  802c87:	83 f5 1f             	xor    $0x1f,%ebp
  802c8a:	75 3c                	jne    802cc8 <__udivdi3+0x98>
  802c8c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c90:	39 34 24             	cmp    %esi,(%esp)
  802c93:	0f 86 9f 00 00 00    	jbe    802d38 <__udivdi3+0x108>
  802c99:	39 d0                	cmp    %edx,%eax
  802c9b:	0f 82 97 00 00 00    	jb     802d38 <__udivdi3+0x108>
  802ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ca8:	31 d2                	xor    %edx,%edx
  802caa:	31 c0                	xor    %eax,%eax
  802cac:	83 c4 0c             	add    $0xc,%esp
  802caf:	5e                   	pop    %esi
  802cb0:	5f                   	pop    %edi
  802cb1:	5d                   	pop    %ebp
  802cb2:	c3                   	ret    
  802cb3:	90                   	nop
  802cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cb8:	89 f8                	mov    %edi,%eax
  802cba:	f7 f1                	div    %ecx
  802cbc:	31 d2                	xor    %edx,%edx
  802cbe:	83 c4 0c             	add    $0xc,%esp
  802cc1:	5e                   	pop    %esi
  802cc2:	5f                   	pop    %edi
  802cc3:	5d                   	pop    %ebp
  802cc4:	c3                   	ret    
  802cc5:	8d 76 00             	lea    0x0(%esi),%esi
  802cc8:	89 e9                	mov    %ebp,%ecx
  802cca:	8b 3c 24             	mov    (%esp),%edi
  802ccd:	d3 e0                	shl    %cl,%eax
  802ccf:	89 c6                	mov    %eax,%esi
  802cd1:	b8 20 00 00 00       	mov    $0x20,%eax
  802cd6:	29 e8                	sub    %ebp,%eax
  802cd8:	89 c1                	mov    %eax,%ecx
  802cda:	d3 ef                	shr    %cl,%edi
  802cdc:	89 e9                	mov    %ebp,%ecx
  802cde:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ce2:	8b 3c 24             	mov    (%esp),%edi
  802ce5:	09 74 24 08          	or     %esi,0x8(%esp)
  802ce9:	89 d6                	mov    %edx,%esi
  802ceb:	d3 e7                	shl    %cl,%edi
  802ced:	89 c1                	mov    %eax,%ecx
  802cef:	89 3c 24             	mov    %edi,(%esp)
  802cf2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802cf6:	d3 ee                	shr    %cl,%esi
  802cf8:	89 e9                	mov    %ebp,%ecx
  802cfa:	d3 e2                	shl    %cl,%edx
  802cfc:	89 c1                	mov    %eax,%ecx
  802cfe:	d3 ef                	shr    %cl,%edi
  802d00:	09 d7                	or     %edx,%edi
  802d02:	89 f2                	mov    %esi,%edx
  802d04:	89 f8                	mov    %edi,%eax
  802d06:	f7 74 24 08          	divl   0x8(%esp)
  802d0a:	89 d6                	mov    %edx,%esi
  802d0c:	89 c7                	mov    %eax,%edi
  802d0e:	f7 24 24             	mull   (%esp)
  802d11:	39 d6                	cmp    %edx,%esi
  802d13:	89 14 24             	mov    %edx,(%esp)
  802d16:	72 30                	jb     802d48 <__udivdi3+0x118>
  802d18:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d1c:	89 e9                	mov    %ebp,%ecx
  802d1e:	d3 e2                	shl    %cl,%edx
  802d20:	39 c2                	cmp    %eax,%edx
  802d22:	73 05                	jae    802d29 <__udivdi3+0xf9>
  802d24:	3b 34 24             	cmp    (%esp),%esi
  802d27:	74 1f                	je     802d48 <__udivdi3+0x118>
  802d29:	89 f8                	mov    %edi,%eax
  802d2b:	31 d2                	xor    %edx,%edx
  802d2d:	e9 7a ff ff ff       	jmp    802cac <__udivdi3+0x7c>
  802d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d38:	31 d2                	xor    %edx,%edx
  802d3a:	b8 01 00 00 00       	mov    $0x1,%eax
  802d3f:	e9 68 ff ff ff       	jmp    802cac <__udivdi3+0x7c>
  802d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d48:	8d 47 ff             	lea    -0x1(%edi),%eax
  802d4b:	31 d2                	xor    %edx,%edx
  802d4d:	83 c4 0c             	add    $0xc,%esp
  802d50:	5e                   	pop    %esi
  802d51:	5f                   	pop    %edi
  802d52:	5d                   	pop    %ebp
  802d53:	c3                   	ret    
  802d54:	66 90                	xchg   %ax,%ax
  802d56:	66 90                	xchg   %ax,%ax
  802d58:	66 90                	xchg   %ax,%ax
  802d5a:	66 90                	xchg   %ax,%ax
  802d5c:	66 90                	xchg   %ax,%ax
  802d5e:	66 90                	xchg   %ax,%ax

00802d60 <__umoddi3>:
  802d60:	55                   	push   %ebp
  802d61:	57                   	push   %edi
  802d62:	56                   	push   %esi
  802d63:	83 ec 14             	sub    $0x14,%esp
  802d66:	8b 44 24 28          	mov    0x28(%esp),%eax
  802d6a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802d6e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802d72:	89 c7                	mov    %eax,%edi
  802d74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d78:	8b 44 24 30          	mov    0x30(%esp),%eax
  802d7c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802d80:	89 34 24             	mov    %esi,(%esp)
  802d83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d87:	85 c0                	test   %eax,%eax
  802d89:	89 c2                	mov    %eax,%edx
  802d8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d8f:	75 17                	jne    802da8 <__umoddi3+0x48>
  802d91:	39 fe                	cmp    %edi,%esi
  802d93:	76 4b                	jbe    802de0 <__umoddi3+0x80>
  802d95:	89 c8                	mov    %ecx,%eax
  802d97:	89 fa                	mov    %edi,%edx
  802d99:	f7 f6                	div    %esi
  802d9b:	89 d0                	mov    %edx,%eax
  802d9d:	31 d2                	xor    %edx,%edx
  802d9f:	83 c4 14             	add    $0x14,%esp
  802da2:	5e                   	pop    %esi
  802da3:	5f                   	pop    %edi
  802da4:	5d                   	pop    %ebp
  802da5:	c3                   	ret    
  802da6:	66 90                	xchg   %ax,%ax
  802da8:	39 f8                	cmp    %edi,%eax
  802daa:	77 54                	ja     802e00 <__umoddi3+0xa0>
  802dac:	0f bd e8             	bsr    %eax,%ebp
  802daf:	83 f5 1f             	xor    $0x1f,%ebp
  802db2:	75 5c                	jne    802e10 <__umoddi3+0xb0>
  802db4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802db8:	39 3c 24             	cmp    %edi,(%esp)
  802dbb:	0f 87 e7 00 00 00    	ja     802ea8 <__umoddi3+0x148>
  802dc1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802dc5:	29 f1                	sub    %esi,%ecx
  802dc7:	19 c7                	sbb    %eax,%edi
  802dc9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802dcd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dd1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802dd5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802dd9:	83 c4 14             	add    $0x14,%esp
  802ddc:	5e                   	pop    %esi
  802ddd:	5f                   	pop    %edi
  802dde:	5d                   	pop    %ebp
  802ddf:	c3                   	ret    
  802de0:	85 f6                	test   %esi,%esi
  802de2:	89 f5                	mov    %esi,%ebp
  802de4:	75 0b                	jne    802df1 <__umoddi3+0x91>
  802de6:	b8 01 00 00 00       	mov    $0x1,%eax
  802deb:	31 d2                	xor    %edx,%edx
  802ded:	f7 f6                	div    %esi
  802def:	89 c5                	mov    %eax,%ebp
  802df1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802df5:	31 d2                	xor    %edx,%edx
  802df7:	f7 f5                	div    %ebp
  802df9:	89 c8                	mov    %ecx,%eax
  802dfb:	f7 f5                	div    %ebp
  802dfd:	eb 9c                	jmp    802d9b <__umoddi3+0x3b>
  802dff:	90                   	nop
  802e00:	89 c8                	mov    %ecx,%eax
  802e02:	89 fa                	mov    %edi,%edx
  802e04:	83 c4 14             	add    $0x14,%esp
  802e07:	5e                   	pop    %esi
  802e08:	5f                   	pop    %edi
  802e09:	5d                   	pop    %ebp
  802e0a:	c3                   	ret    
  802e0b:	90                   	nop
  802e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e10:	8b 04 24             	mov    (%esp),%eax
  802e13:	be 20 00 00 00       	mov    $0x20,%esi
  802e18:	89 e9                	mov    %ebp,%ecx
  802e1a:	29 ee                	sub    %ebp,%esi
  802e1c:	d3 e2                	shl    %cl,%edx
  802e1e:	89 f1                	mov    %esi,%ecx
  802e20:	d3 e8                	shr    %cl,%eax
  802e22:	89 e9                	mov    %ebp,%ecx
  802e24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e28:	8b 04 24             	mov    (%esp),%eax
  802e2b:	09 54 24 04          	or     %edx,0x4(%esp)
  802e2f:	89 fa                	mov    %edi,%edx
  802e31:	d3 e0                	shl    %cl,%eax
  802e33:	89 f1                	mov    %esi,%ecx
  802e35:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e39:	8b 44 24 10          	mov    0x10(%esp),%eax
  802e3d:	d3 ea                	shr    %cl,%edx
  802e3f:	89 e9                	mov    %ebp,%ecx
  802e41:	d3 e7                	shl    %cl,%edi
  802e43:	89 f1                	mov    %esi,%ecx
  802e45:	d3 e8                	shr    %cl,%eax
  802e47:	89 e9                	mov    %ebp,%ecx
  802e49:	09 f8                	or     %edi,%eax
  802e4b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802e4f:	f7 74 24 04          	divl   0x4(%esp)
  802e53:	d3 e7                	shl    %cl,%edi
  802e55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e59:	89 d7                	mov    %edx,%edi
  802e5b:	f7 64 24 08          	mull   0x8(%esp)
  802e5f:	39 d7                	cmp    %edx,%edi
  802e61:	89 c1                	mov    %eax,%ecx
  802e63:	89 14 24             	mov    %edx,(%esp)
  802e66:	72 2c                	jb     802e94 <__umoddi3+0x134>
  802e68:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802e6c:	72 22                	jb     802e90 <__umoddi3+0x130>
  802e6e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802e72:	29 c8                	sub    %ecx,%eax
  802e74:	19 d7                	sbb    %edx,%edi
  802e76:	89 e9                	mov    %ebp,%ecx
  802e78:	89 fa                	mov    %edi,%edx
  802e7a:	d3 e8                	shr    %cl,%eax
  802e7c:	89 f1                	mov    %esi,%ecx
  802e7e:	d3 e2                	shl    %cl,%edx
  802e80:	89 e9                	mov    %ebp,%ecx
  802e82:	d3 ef                	shr    %cl,%edi
  802e84:	09 d0                	or     %edx,%eax
  802e86:	89 fa                	mov    %edi,%edx
  802e88:	83 c4 14             	add    $0x14,%esp
  802e8b:	5e                   	pop    %esi
  802e8c:	5f                   	pop    %edi
  802e8d:	5d                   	pop    %ebp
  802e8e:	c3                   	ret    
  802e8f:	90                   	nop
  802e90:	39 d7                	cmp    %edx,%edi
  802e92:	75 da                	jne    802e6e <__umoddi3+0x10e>
  802e94:	8b 14 24             	mov    (%esp),%edx
  802e97:	89 c1                	mov    %eax,%ecx
  802e99:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802e9d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802ea1:	eb cb                	jmp    802e6e <__umoddi3+0x10e>
  802ea3:	90                   	nop
  802ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ea8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802eac:	0f 82 0f ff ff ff    	jb     802dc1 <__umoddi3+0x61>
  802eb2:	e9 1a ff ff ff       	jmp    802dd1 <__umoddi3+0x71>
