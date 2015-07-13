
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 e4 02 00 00       	call   800315 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 c4 80             	add    $0xffffff80,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 40 80 00 60 	movl   $0x803060,0x804004
  800042:	30 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 c4 27 00 00       	call   802814 <pipe>
  800050:	89 c6                	mov    %eax,%esi
  800052:	85 c0                	test   %eax,%eax
  800054:	79 20                	jns    800076 <umain+0x43>
		panic("pipe: %e", i);
  800056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005a:	c7 44 24 08 6c 30 80 	movl   $0x80306c,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 75 30 80 00 	movl   $0x803075,(%esp)
  800071:	e8 00 03 00 00       	call   800376 <_panic>

	if ((pid = fork()) < 0)
  800076:	e8 f4 13 00 00       	call   80146f <fork>
  80007b:	89 c3                	mov    %eax,%ebx
  80007d:	85 c0                	test   %eax,%eax
  80007f:	79 20                	jns    8000a1 <umain+0x6e>
		panic("fork: %e", i);
  800081:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800085:	c7 44 24 08 85 30 80 	movl   $0x803085,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800094:	00 
  800095:	c7 04 24 75 30 80 00 	movl   $0x803075,(%esp)
  80009c:	e8 d5 02 00 00       	call   800376 <_panic>

	if (pid == 0) {
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	0f 85 d5 00 00 00    	jne    80017e <umain+0x14b>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  8000a9:	a1 08 50 80 00       	mov    0x805008,%eax
  8000ae:	8b 40 48             	mov    0x48(%eax),%eax
  8000b1:	8b 55 90             	mov    -0x70(%ebp),%edx
  8000b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bc:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  8000c3:	e8 a7 03 00 00       	call   80046f <cprintf>
		close(p[1]);
  8000c8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000cb:	89 04 24             	mov    %eax,(%esp)
  8000ce:	e8 e4 18 00 00       	call   8019b7 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  8000d3:	a1 08 50 80 00       	mov    0x805008,%eax
  8000d8:	8b 40 48             	mov    0x48(%eax),%eax
  8000db:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8000de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e6:	c7 04 24 ab 30 80 00 	movl   $0x8030ab,(%esp)
  8000ed:	e8 7d 03 00 00       	call   80046f <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000f2:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000f9:	00 
  8000fa:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800104:	89 04 24             	mov    %eax,(%esp)
  800107:	e8 a0 1a 00 00       	call   801bac <readn>
  80010c:	89 c6                	mov    %eax,%esi
		if (i < 0)
  80010e:	85 c0                	test   %eax,%eax
  800110:	79 20                	jns    800132 <umain+0xff>
			panic("read: %e", i);
  800112:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800116:	c7 44 24 08 c8 30 80 	movl   $0x8030c8,0x8(%esp)
  80011d:	00 
  80011e:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 75 30 80 00 	movl   $0x803075,(%esp)
  80012d:	e8 44 02 00 00       	call   800376 <_panic>
		buf[i] = 0;
  800132:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  800137:	a1 00 40 80 00       	mov    0x804000,%eax
  80013c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800140:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800143:	89 04 24             	mov    %eax,(%esp)
  800146:	e8 51 0a 00 00       	call   800b9c <strcmp>
  80014b:	85 c0                	test   %eax,%eax
  80014d:	75 0e                	jne    80015d <umain+0x12a>
			cprintf("\npipe read closed properly\n");
  80014f:	c7 04 24 d1 30 80 00 	movl   $0x8030d1,(%esp)
  800156:	e8 14 03 00 00       	call   80046f <cprintf>
  80015b:	eb 17                	jmp    800174 <umain+0x141>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  80015d:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800160:	89 44 24 08          	mov    %eax,0x8(%esp)
  800164:	89 74 24 04          	mov    %esi,0x4(%esp)
  800168:	c7 04 24 ed 30 80 00 	movl   $0x8030ed,(%esp)
  80016f:	e8 fb 02 00 00       	call   80046f <cprintf>
		exit();
  800174:	e8 e4 01 00 00       	call   80035d <exit>
  800179:	e9 ac 00 00 00       	jmp    80022a <umain+0x1f7>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80017e:	a1 08 50 80 00       	mov    0x805008,%eax
  800183:	8b 40 48             	mov    0x48(%eax),%eax
  800186:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800189:	89 54 24 08          	mov    %edx,0x8(%esp)
  80018d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800191:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  800198:	e8 d2 02 00 00       	call   80046f <cprintf>
		close(p[0]);
  80019d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8001a0:	89 04 24             	mov    %eax,(%esp)
  8001a3:	e8 0f 18 00 00       	call   8019b7 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001a8:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ad:	8b 40 48             	mov    0x48(%eax),%eax
  8001b0:	8b 55 90             	mov    -0x70(%ebp),%edx
  8001b3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bb:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  8001c2:	e8 a8 02 00 00       	call   80046f <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8001c7:	a1 00 40 80 00       	mov    0x804000,%eax
  8001cc:	89 04 24             	mov    %eax,(%esp)
  8001cf:	e8 dc 08 00 00       	call   800ab0 <strlen>
  8001d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d8:	a1 00 40 80 00       	mov    0x804000,%eax
  8001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001e4:	89 04 24             	mov    %eax,(%esp)
  8001e7:	e8 0b 1a 00 00       	call   801bf7 <write>
  8001ec:	89 c6                	mov    %eax,%esi
  8001ee:	a1 00 40 80 00       	mov    0x804000,%eax
  8001f3:	89 04 24             	mov    %eax,(%esp)
  8001f6:	e8 b5 08 00 00       	call   800ab0 <strlen>
  8001fb:	39 c6                	cmp    %eax,%esi
  8001fd:	74 20                	je     80021f <umain+0x1ec>
			panic("write: %e", i);
  8001ff:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800203:	c7 44 24 08 1d 31 80 	movl   $0x80311d,0x8(%esp)
  80020a:	00 
  80020b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800212:	00 
  800213:	c7 04 24 75 30 80 00 	movl   $0x803075,(%esp)
  80021a:	e8 57 01 00 00       	call   800376 <_panic>
		close(p[1]);
  80021f:	8b 45 90             	mov    -0x70(%ebp),%eax
  800222:	89 04 24             	mov    %eax,(%esp)
  800225:	e8 8d 17 00 00       	call   8019b7 <close>
	}
	wait(pid);
  80022a:	89 1c 24             	mov    %ebx,(%esp)
  80022d:	e8 88 27 00 00       	call   8029ba <wait>

	binaryname = "pipewriteeof";
  800232:	c7 05 04 40 80 00 27 	movl   $0x803127,0x804004
  800239:	31 80 00 
	if ((i = pipe(p)) < 0)
  80023c:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80023f:	89 04 24             	mov    %eax,(%esp)
  800242:	e8 cd 25 00 00       	call   802814 <pipe>
  800247:	89 c6                	mov    %eax,%esi
  800249:	85 c0                	test   %eax,%eax
  80024b:	79 20                	jns    80026d <umain+0x23a>
		panic("pipe: %e", i);
  80024d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800251:	c7 44 24 08 6c 30 80 	movl   $0x80306c,0x8(%esp)
  800258:	00 
  800259:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  800260:	00 
  800261:	c7 04 24 75 30 80 00 	movl   $0x803075,(%esp)
  800268:	e8 09 01 00 00       	call   800376 <_panic>

	if ((pid = fork()) < 0)
  80026d:	e8 fd 11 00 00       	call   80146f <fork>
  800272:	89 c3                	mov    %eax,%ebx
  800274:	85 c0                	test   %eax,%eax
  800276:	79 20                	jns    800298 <umain+0x265>
		panic("fork: %e", i);
  800278:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80027c:	c7 44 24 08 85 30 80 	movl   $0x803085,0x8(%esp)
  800283:	00 
  800284:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  80028b:	00 
  80028c:	c7 04 24 75 30 80 00 	movl   $0x803075,(%esp)
  800293:	e8 de 00 00 00       	call   800376 <_panic>

	if (pid == 0) {
  800298:	85 c0                	test   %eax,%eax
  80029a:	75 48                	jne    8002e4 <umain+0x2b1>
		close(p[0]);
  80029c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80029f:	89 04 24             	mov    %eax,(%esp)
  8002a2:	e8 10 17 00 00       	call   8019b7 <close>
		while (1) {
			cprintf(".");
  8002a7:	c7 04 24 34 31 80 00 	movl   $0x803134,(%esp)
  8002ae:	e8 bc 01 00 00       	call   80046f <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002b3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002ba:	00 
  8002bb:	c7 44 24 04 36 31 80 	movl   $0x803136,0x4(%esp)
  8002c2:	00 
  8002c3:	8b 55 90             	mov    -0x70(%ebp),%edx
  8002c6:	89 14 24             	mov    %edx,(%esp)
  8002c9:	e8 29 19 00 00       	call   801bf7 <write>
  8002ce:	83 f8 01             	cmp    $0x1,%eax
  8002d1:	74 d4                	je     8002a7 <umain+0x274>
				break;
		}
		cprintf("\npipe write closed properly\n");
  8002d3:	c7 04 24 38 31 80 00 	movl   $0x803138,(%esp)
  8002da:	e8 90 01 00 00       	call   80046f <cprintf>
		exit();
  8002df:	e8 79 00 00 00       	call   80035d <exit>
	}
	close(p[0]);
  8002e4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002e7:	89 04 24             	mov    %eax,(%esp)
  8002ea:	e8 c8 16 00 00       	call   8019b7 <close>
	close(p[1]);
  8002ef:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002f2:	89 04 24             	mov    %eax,(%esp)
  8002f5:	e8 bd 16 00 00       	call   8019b7 <close>
	wait(pid);
  8002fa:	89 1c 24             	mov    %ebx,(%esp)
  8002fd:	e8 b8 26 00 00       	call   8029ba <wait>

	cprintf("pipe tests passed\n");
  800302:	c7 04 24 55 31 80 00 	movl   $0x803155,(%esp)
  800309:	e8 61 01 00 00       	call   80046f <cprintf>
}
  80030e:	83 ec 80             	sub    $0xffffff80,%esp
  800311:	5b                   	pop    %ebx
  800312:	5e                   	pop    %esi
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    

00800315 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 10             	sub    $0x10,%esp
  80031d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800320:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800323:	e8 ef 0b 00 00       	call   800f17 <sys_getenvid>
  800328:	25 ff 03 00 00       	and    $0x3ff,%eax
  80032d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800330:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800335:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80033a:	85 db                	test   %ebx,%ebx
  80033c:	7e 07                	jle    800345 <libmain+0x30>
		binaryname = argv[0];
  80033e:	8b 06                	mov    (%esi),%eax
  800340:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  800345:	89 74 24 04          	mov    %esi,0x4(%esp)
  800349:	89 1c 24             	mov    %ebx,(%esp)
  80034c:	e8 e2 fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800351:	e8 07 00 00 00       	call   80035d <exit>
}
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	5b                   	pop    %ebx
  80035a:	5e                   	pop    %esi
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    

0080035d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800363:	e8 82 16 00 00       	call   8019ea <close_all>
	sys_env_destroy(0);
  800368:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80036f:	e8 ff 0a 00 00       	call   800e73 <sys_env_destroy>
}
  800374:	c9                   	leave  
  800375:	c3                   	ret    

00800376 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	56                   	push   %esi
  80037a:	53                   	push   %ebx
  80037b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80037e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800381:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800387:	e8 8b 0b 00 00       	call   800f17 <sys_getenvid>
  80038c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038f:	89 54 24 10          	mov    %edx,0x10(%esp)
  800393:	8b 55 08             	mov    0x8(%ebp),%edx
  800396:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80039a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80039e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a2:	c7 04 24 b8 31 80 00 	movl   $0x8031b8,(%esp)
  8003a9:	e8 c1 00 00 00       	call   80046f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b5:	89 04 24             	mov    %eax,(%esp)
  8003b8:	e8 51 00 00 00       	call   80040e <vcprintf>
	cprintf("\n");
  8003bd:	c7 04 24 cb 36 80 00 	movl   $0x8036cb,(%esp)
  8003c4:	e8 a6 00 00 00       	call   80046f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003c9:	cc                   	int3   
  8003ca:	eb fd                	jmp    8003c9 <_panic+0x53>

008003cc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	53                   	push   %ebx
  8003d0:	83 ec 14             	sub    $0x14,%esp
  8003d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003d6:	8b 13                	mov    (%ebx),%edx
  8003d8:	8d 42 01             	lea    0x1(%edx),%eax
  8003db:	89 03                	mov    %eax,(%ebx)
  8003dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e9:	75 19                	jne    800404 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003eb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003f2:	00 
  8003f3:	8d 43 08             	lea    0x8(%ebx),%eax
  8003f6:	89 04 24             	mov    %eax,(%esp)
  8003f9:	e8 38 0a 00 00       	call   800e36 <sys_cputs>
		b->idx = 0;
  8003fe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800404:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800408:	83 c4 14             	add    $0x14,%esp
  80040b:	5b                   	pop    %ebx
  80040c:	5d                   	pop    %ebp
  80040d:	c3                   	ret    

0080040e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800417:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80041e:	00 00 00 
	b.cnt = 0;
  800421:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800428:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80042b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	89 44 24 08          	mov    %eax,0x8(%esp)
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800443:	c7 04 24 cc 03 80 00 	movl   $0x8003cc,(%esp)
  80044a:	e8 75 01 00 00       	call   8005c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80044f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800455:	89 44 24 04          	mov    %eax,0x4(%esp)
  800459:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80045f:	89 04 24             	mov    %eax,(%esp)
  800462:	e8 cf 09 00 00       	call   800e36 <sys_cputs>

	return b.cnt;
}
  800467:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80046d:	c9                   	leave  
  80046e:	c3                   	ret    

0080046f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800475:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800478:	89 44 24 04          	mov    %eax,0x4(%esp)
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	89 04 24             	mov    %eax,(%esp)
  800482:	e8 87 ff ff ff       	call   80040e <vcprintf>
	va_end(ap);

	return cnt;
}
  800487:	c9                   	leave  
  800488:	c3                   	ret    
  800489:	66 90                	xchg   %ax,%ax
  80048b:	66 90                	xchg   %ax,%ax
  80048d:	66 90                	xchg   %ax,%ax
  80048f:	90                   	nop

00800490 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	57                   	push   %edi
  800494:	56                   	push   %esi
  800495:	53                   	push   %ebx
  800496:	83 ec 3c             	sub    $0x3c,%esp
  800499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80049c:	89 d7                	mov    %edx,%edi
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a7:	89 c3                	mov    %eax,%ebx
  8004a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8004af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004bd:	39 d9                	cmp    %ebx,%ecx
  8004bf:	72 05                	jb     8004c6 <printnum+0x36>
  8004c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004c4:	77 69                	ja     80052f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004cd:	83 ee 01             	sub    $0x1,%esi
  8004d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004e0:	89 c3                	mov    %eax,%ebx
  8004e2:	89 d6                	mov    %edx,%esi
  8004e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8004f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f5:	89 04 24             	mov    %eax,(%esp)
  8004f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ff:	e8 cc 28 00 00       	call   802dd0 <__udivdi3>
  800504:	89 d9                	mov    %ebx,%ecx
  800506:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80050a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80050e:	89 04 24             	mov    %eax,(%esp)
  800511:	89 54 24 04          	mov    %edx,0x4(%esp)
  800515:	89 fa                	mov    %edi,%edx
  800517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80051a:	e8 71 ff ff ff       	call   800490 <printnum>
  80051f:	eb 1b                	jmp    80053c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800521:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800525:	8b 45 18             	mov    0x18(%ebp),%eax
  800528:	89 04 24             	mov    %eax,(%esp)
  80052b:	ff d3                	call   *%ebx
  80052d:	eb 03                	jmp    800532 <printnum+0xa2>
  80052f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800532:	83 ee 01             	sub    $0x1,%esi
  800535:	85 f6                	test   %esi,%esi
  800537:	7f e8                	jg     800521 <printnum+0x91>
  800539:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800540:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800544:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800547:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80054a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80054e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800552:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800555:	89 04 24             	mov    %eax,(%esp)
  800558:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80055b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055f:	e8 9c 29 00 00       	call   802f00 <__umoddi3>
  800564:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800568:	0f be 80 db 31 80 00 	movsbl 0x8031db(%eax),%eax
  80056f:	89 04 24             	mov    %eax,(%esp)
  800572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800575:	ff d0                	call   *%eax
}
  800577:	83 c4 3c             	add    $0x3c,%esp
  80057a:	5b                   	pop    %ebx
  80057b:	5e                   	pop    %esi
  80057c:	5f                   	pop    %edi
  80057d:	5d                   	pop    %ebp
  80057e:	c3                   	ret    

0080057f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
  800582:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800585:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800589:	8b 10                	mov    (%eax),%edx
  80058b:	3b 50 04             	cmp    0x4(%eax),%edx
  80058e:	73 0a                	jae    80059a <sprintputch+0x1b>
		*b->buf++ = ch;
  800590:	8d 4a 01             	lea    0x1(%edx),%ecx
  800593:	89 08                	mov    %ecx,(%eax)
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	88 02                	mov    %al,(%edx)
}
  80059a:	5d                   	pop    %ebp
  80059b:	c3                   	ret    

0080059c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005a2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	89 04 24             	mov    %eax,(%esp)
  8005bd:	e8 02 00 00 00       	call   8005c4 <vprintfmt>
	va_end(ap);
}
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

008005c4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	57                   	push   %edi
  8005c8:	56                   	push   %esi
  8005c9:	53                   	push   %ebx
  8005ca:	83 ec 3c             	sub    $0x3c,%esp
  8005cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005d0:	eb 17                	jmp    8005e9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  8005d2:	85 c0                	test   %eax,%eax
  8005d4:	0f 84 4b 04 00 00    	je     800a25 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  8005da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005e1:	89 04 24             	mov    %eax,(%esp)
  8005e4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  8005e7:	89 fb                	mov    %edi,%ebx
  8005e9:	8d 7b 01             	lea    0x1(%ebx),%edi
  8005ec:	0f b6 03             	movzbl (%ebx),%eax
  8005ef:	83 f8 25             	cmp    $0x25,%eax
  8005f2:	75 de                	jne    8005d2 <vprintfmt+0xe>
  8005f4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8005f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005ff:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800604:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80060b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800610:	eb 18                	jmp    80062a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800612:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800614:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800618:	eb 10                	jmp    80062a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80061c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800620:	eb 08                	jmp    80062a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800622:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800625:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80062d:	0f b6 17             	movzbl (%edi),%edx
  800630:	0f b6 c2             	movzbl %dl,%eax
  800633:	83 ea 23             	sub    $0x23,%edx
  800636:	80 fa 55             	cmp    $0x55,%dl
  800639:	0f 87 c2 03 00 00    	ja     800a01 <vprintfmt+0x43d>
  80063f:	0f b6 d2             	movzbl %dl,%edx
  800642:	ff 24 95 20 33 80 00 	jmp    *0x803320(,%edx,4)
  800649:	89 df                	mov    %ebx,%edi
  80064b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800650:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800653:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800657:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80065a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80065d:	83 fa 09             	cmp    $0x9,%edx
  800660:	77 33                	ja     800695 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800662:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800665:	eb e9                	jmp    800650 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8b 30                	mov    (%eax),%esi
  80066c:	8d 40 04             	lea    0x4(%eax),%eax
  80066f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800672:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800674:	eb 1f                	jmp    800695 <vprintfmt+0xd1>
  800676:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800679:	85 ff                	test   %edi,%edi
  80067b:	b8 00 00 00 00       	mov    $0x0,%eax
  800680:	0f 49 c7             	cmovns %edi,%eax
  800683:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800686:	89 df                	mov    %ebx,%edi
  800688:	eb a0                	jmp    80062a <vprintfmt+0x66>
  80068a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80068c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800693:	eb 95                	jmp    80062a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800695:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800699:	79 8f                	jns    80062a <vprintfmt+0x66>
  80069b:	eb 85                	jmp    800622 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80069d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006a2:	eb 86                	jmp    80062a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8d 70 04             	lea    0x4(%eax),%esi
  8006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	89 04 24             	mov    %eax,(%esp)
  8006b9:	ff 55 08             	call   *0x8(%ebp)
  8006bc:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8006bf:	e9 25 ff ff ff       	jmp    8005e9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8d 70 04             	lea    0x4(%eax),%esi
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	99                   	cltd   
  8006cd:	31 d0                	xor    %edx,%eax
  8006cf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006d1:	83 f8 15             	cmp    $0x15,%eax
  8006d4:	7f 0b                	jg     8006e1 <vprintfmt+0x11d>
  8006d6:	8b 14 85 80 34 80 00 	mov    0x803480(,%eax,4),%edx
  8006dd:	85 d2                	test   %edx,%edx
  8006df:	75 26                	jne    800707 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  8006e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006e5:	c7 44 24 08 f3 31 80 	movl   $0x8031f3,0x8(%esp)
  8006ec:	00 
  8006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	89 04 24             	mov    %eax,(%esp)
  8006fa:	e8 9d fe ff ff       	call   80059c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006ff:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800702:	e9 e2 fe ff ff       	jmp    8005e9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800707:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80070b:	c7 44 24 08 9a 36 80 	movl   $0x80369a,0x8(%esp)
  800712:	00 
  800713:	8b 45 0c             	mov    0xc(%ebp),%eax
  800716:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	89 04 24             	mov    %eax,(%esp)
  800720:	e8 77 fe ff ff       	call   80059c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800725:	89 75 14             	mov    %esi,0x14(%ebp)
  800728:	e9 bc fe ff ff       	jmp    8005e9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800733:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800736:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80073a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80073c:	85 ff                	test   %edi,%edi
  80073e:	b8 ec 31 80 00       	mov    $0x8031ec,%eax
  800743:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800746:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80074a:	0f 84 94 00 00 00    	je     8007e4 <vprintfmt+0x220>
  800750:	85 c9                	test   %ecx,%ecx
  800752:	0f 8e 94 00 00 00    	jle    8007ec <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800758:	89 74 24 04          	mov    %esi,0x4(%esp)
  80075c:	89 3c 24             	mov    %edi,(%esp)
  80075f:	e8 64 03 00 00       	call   800ac8 <strnlen>
  800764:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800767:	29 c1                	sub    %eax,%ecx
  800769:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80076c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800770:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800773:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800776:	8b 75 08             	mov    0x8(%ebp),%esi
  800779:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80077c:	89 cb                	mov    %ecx,%ebx
  80077e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800780:	eb 0f                	jmp    800791 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800782:	8b 45 0c             	mov    0xc(%ebp),%eax
  800785:	89 44 24 04          	mov    %eax,0x4(%esp)
  800789:	89 3c 24             	mov    %edi,(%esp)
  80078c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80078e:	83 eb 01             	sub    $0x1,%ebx
  800791:	85 db                	test   %ebx,%ebx
  800793:	7f ed                	jg     800782 <vprintfmt+0x1be>
  800795:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800798:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80079b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80079e:	85 c9                	test   %ecx,%ecx
  8007a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a5:	0f 49 c1             	cmovns %ecx,%eax
  8007a8:	29 c1                	sub    %eax,%ecx
  8007aa:	89 cb                	mov    %ecx,%ebx
  8007ac:	eb 44                	jmp    8007f2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b2:	74 1e                	je     8007d2 <vprintfmt+0x20e>
  8007b4:	0f be d2             	movsbl %dl,%edx
  8007b7:	83 ea 20             	sub    $0x20,%edx
  8007ba:	83 fa 5e             	cmp    $0x5e,%edx
  8007bd:	76 13                	jbe    8007d2 <vprintfmt+0x20e>
					putch('?', putdat);
  8007bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007cd:	ff 55 08             	call   *0x8(%ebp)
  8007d0:	eb 0d                	jmp    8007df <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8007d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007d5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007d9:	89 04 24             	mov    %eax,(%esp)
  8007dc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007df:	83 eb 01             	sub    $0x1,%ebx
  8007e2:	eb 0e                	jmp    8007f2 <vprintfmt+0x22e>
  8007e4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007e7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8007ea:	eb 06                	jmp    8007f2 <vprintfmt+0x22e>
  8007ec:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007ef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8007f2:	83 c7 01             	add    $0x1,%edi
  8007f5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8007f9:	0f be c2             	movsbl %dl,%eax
  8007fc:	85 c0                	test   %eax,%eax
  8007fe:	74 27                	je     800827 <vprintfmt+0x263>
  800800:	85 f6                	test   %esi,%esi
  800802:	78 aa                	js     8007ae <vprintfmt+0x1ea>
  800804:	83 ee 01             	sub    $0x1,%esi
  800807:	79 a5                	jns    8007ae <vprintfmt+0x1ea>
  800809:	89 d8                	mov    %ebx,%eax
  80080b:	8b 75 08             	mov    0x8(%ebp),%esi
  80080e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800811:	89 c3                	mov    %eax,%ebx
  800813:	eb 18                	jmp    80082d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800815:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800819:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800820:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800822:	83 eb 01             	sub    $0x1,%ebx
  800825:	eb 06                	jmp    80082d <vprintfmt+0x269>
  800827:	8b 75 08             	mov    0x8(%ebp),%esi
  80082a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80082d:	85 db                	test   %ebx,%ebx
  80082f:	7f e4                	jg     800815 <vprintfmt+0x251>
  800831:	89 75 08             	mov    %esi,0x8(%ebp)
  800834:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800837:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80083a:	e9 aa fd ff ff       	jmp    8005e9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80083f:	83 f9 01             	cmp    $0x1,%ecx
  800842:	7e 10                	jle    800854 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 30                	mov    (%eax),%esi
  800849:	8b 78 04             	mov    0x4(%eax),%edi
  80084c:	8d 40 08             	lea    0x8(%eax),%eax
  80084f:	89 45 14             	mov    %eax,0x14(%ebp)
  800852:	eb 26                	jmp    80087a <vprintfmt+0x2b6>
	else if (lflag)
  800854:	85 c9                	test   %ecx,%ecx
  800856:	74 12                	je     80086a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8b 30                	mov    (%eax),%esi
  80085d:	89 f7                	mov    %esi,%edi
  80085f:	c1 ff 1f             	sar    $0x1f,%edi
  800862:	8d 40 04             	lea    0x4(%eax),%eax
  800865:	89 45 14             	mov    %eax,0x14(%ebp)
  800868:	eb 10                	jmp    80087a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8b 30                	mov    (%eax),%esi
  80086f:	89 f7                	mov    %esi,%edi
  800871:	c1 ff 1f             	sar    $0x1f,%edi
  800874:	8d 40 04             	lea    0x4(%eax),%eax
  800877:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80087a:	89 f0                	mov    %esi,%eax
  80087c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80087e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800883:	85 ff                	test   %edi,%edi
  800885:	0f 89 3a 01 00 00    	jns    8009c5 <vprintfmt+0x401>
				putch('-', putdat);
  80088b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800892:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800899:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80089c:	89 f0                	mov    %esi,%eax
  80089e:	89 fa                	mov    %edi,%edx
  8008a0:	f7 d8                	neg    %eax
  8008a2:	83 d2 00             	adc    $0x0,%edx
  8008a5:	f7 da                	neg    %edx
			}
			base = 10;
  8008a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8008ac:	e9 14 01 00 00       	jmp    8009c5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008b1:	83 f9 01             	cmp    $0x1,%ecx
  8008b4:	7e 13                	jle    8008c9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	8b 50 04             	mov    0x4(%eax),%edx
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	8b 75 14             	mov    0x14(%ebp),%esi
  8008c1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8008c4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008c7:	eb 2c                	jmp    8008f5 <vprintfmt+0x331>
	else if (lflag)
  8008c9:	85 c9                	test   %ecx,%ecx
  8008cb:	74 15                	je     8008e2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d7:	8b 75 14             	mov    0x14(%ebp),%esi
  8008da:	8d 76 04             	lea    0x4(%esi),%esi
  8008dd:	89 75 14             	mov    %esi,0x14(%ebp)
  8008e0:	eb 13                	jmp    8008f5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ec:	8b 75 14             	mov    0x14(%ebp),%esi
  8008ef:	8d 76 04             	lea    0x4(%esi),%esi
  8008f2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8008f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8008fa:	e9 c6 00 00 00       	jmp    8009c5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008ff:	83 f9 01             	cmp    $0x1,%ecx
  800902:	7e 13                	jle    800917 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	8b 50 04             	mov    0x4(%eax),%edx
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	8b 75 14             	mov    0x14(%ebp),%esi
  80090f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800912:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800915:	eb 24                	jmp    80093b <vprintfmt+0x377>
	else if (lflag)
  800917:	85 c9                	test   %ecx,%ecx
  800919:	74 11                	je     80092c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	99                   	cltd   
  800921:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800924:	8d 71 04             	lea    0x4(%ecx),%esi
  800927:	89 75 14             	mov    %esi,0x14(%ebp)
  80092a:	eb 0f                	jmp    80093b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	99                   	cltd   
  800932:	8b 75 14             	mov    0x14(%ebp),%esi
  800935:	8d 76 04             	lea    0x4(%esi),%esi
  800938:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80093b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800940:	e9 80 00 00 00       	jmp    8009c5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800945:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80094f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800956:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800960:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800967:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80096a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80096e:	8b 06                	mov    (%esi),%eax
  800970:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800975:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80097a:	eb 49                	jmp    8009c5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80097c:	83 f9 01             	cmp    $0x1,%ecx
  80097f:	7e 13                	jle    800994 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800981:	8b 45 14             	mov    0x14(%ebp),%eax
  800984:	8b 50 04             	mov    0x4(%eax),%edx
  800987:	8b 00                	mov    (%eax),%eax
  800989:	8b 75 14             	mov    0x14(%ebp),%esi
  80098c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80098f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800992:	eb 2c                	jmp    8009c0 <vprintfmt+0x3fc>
	else if (lflag)
  800994:	85 c9                	test   %ecx,%ecx
  800996:	74 15                	je     8009ad <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8009a5:	8d 71 04             	lea    0x4(%ecx),%esi
  8009a8:	89 75 14             	mov    %esi,0x14(%ebp)
  8009ab:	eb 13                	jmp    8009c0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b7:	8b 75 14             	mov    0x14(%ebp),%esi
  8009ba:	8d 76 04             	lea    0x4(%esi),%esi
  8009bd:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8009c0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009c5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8009c9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8009cd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8009d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009d4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009d8:	89 04 24             	mov    %eax,(%esp)
  8009db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	e8 a6 fa ff ff       	call   800490 <printnum>
			break;
  8009ea:	e9 fa fb ff ff       	jmp    8005e9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009f6:	89 04 24             	mov    %eax,(%esp)
  8009f9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009fc:	e9 e8 fb ff ff       	jmp    8005e9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a08:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a0f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a12:	89 fb                	mov    %edi,%ebx
  800a14:	eb 03                	jmp    800a19 <vprintfmt+0x455>
  800a16:	83 eb 01             	sub    $0x1,%ebx
  800a19:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800a1d:	75 f7                	jne    800a16 <vprintfmt+0x452>
  800a1f:	90                   	nop
  800a20:	e9 c4 fb ff ff       	jmp    8005e9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800a25:	83 c4 3c             	add    $0x3c,%esp
  800a28:	5b                   	pop    %ebx
  800a29:	5e                   	pop    %esi
  800a2a:	5f                   	pop    %edi
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	83 ec 28             	sub    $0x28,%esp
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a3c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a40:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a4a:	85 c0                	test   %eax,%eax
  800a4c:	74 30                	je     800a7e <vsnprintf+0x51>
  800a4e:	85 d2                	test   %edx,%edx
  800a50:	7e 2c                	jle    800a7e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a52:	8b 45 14             	mov    0x14(%ebp),%eax
  800a55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a59:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a60:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a67:	c7 04 24 7f 05 80 00 	movl   $0x80057f,(%esp)
  800a6e:	e8 51 fb ff ff       	call   8005c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a76:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a7c:	eb 05                	jmp    800a83 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a8b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a92:	8b 45 10             	mov    0x10(%ebp),%eax
  800a95:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	89 04 24             	mov    %eax,(%esp)
  800aa6:	e8 82 ff ff ff       	call   800a2d <vsnprintf>
	va_end(ap);

	return rc;
}
  800aab:	c9                   	leave  
  800aac:	c3                   	ret    
  800aad:	66 90                	xchg   %ax,%ax
  800aaf:	90                   	nop

00800ab0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  800abb:	eb 03                	jmp    800ac0 <strlen+0x10>
		n++;
  800abd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ac4:	75 f7                	jne    800abd <strlen+0xd>
		n++;
	return n;
}
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ace:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad6:	eb 03                	jmp    800adb <strnlen+0x13>
		n++;
  800ad8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800adb:	39 d0                	cmp    %edx,%eax
  800add:	74 06                	je     800ae5 <strnlen+0x1d>
  800adf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ae3:	75 f3                	jne    800ad8 <strnlen+0x10>
		n++;
	return n;
}
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	53                   	push   %ebx
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800af1:	89 c2                	mov    %eax,%edx
  800af3:	83 c2 01             	add    $0x1,%edx
  800af6:	83 c1 01             	add    $0x1,%ecx
  800af9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800afd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b00:	84 db                	test   %bl,%bl
  800b02:	75 ef                	jne    800af3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b04:	5b                   	pop    %ebx
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	53                   	push   %ebx
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b11:	89 1c 24             	mov    %ebx,(%esp)
  800b14:	e8 97 ff ff ff       	call   800ab0 <strlen>
	strcpy(dst + len, src);
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b20:	01 d8                	add    %ebx,%eax
  800b22:	89 04 24             	mov    %eax,(%esp)
  800b25:	e8 bd ff ff ff       	call   800ae7 <strcpy>
	return dst;
}
  800b2a:	89 d8                	mov    %ebx,%eax
  800b2c:	83 c4 08             	add    $0x8,%esp
  800b2f:	5b                   	pop    %ebx
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	56                   	push   %esi
  800b36:	53                   	push   %ebx
  800b37:	8b 75 08             	mov    0x8(%ebp),%esi
  800b3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3d:	89 f3                	mov    %esi,%ebx
  800b3f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b42:	89 f2                	mov    %esi,%edx
  800b44:	eb 0f                	jmp    800b55 <strncpy+0x23>
		*dst++ = *src;
  800b46:	83 c2 01             	add    $0x1,%edx
  800b49:	0f b6 01             	movzbl (%ecx),%eax
  800b4c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b4f:	80 39 01             	cmpb   $0x1,(%ecx)
  800b52:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b55:	39 da                	cmp    %ebx,%edx
  800b57:	75 ed                	jne    800b46 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b59:	89 f0                	mov    %esi,%eax
  800b5b:	5b                   	pop    %ebx
  800b5c:	5e                   	pop    %esi
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    

00800b5f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	56                   	push   %esi
  800b63:	53                   	push   %ebx
  800b64:	8b 75 08             	mov    0x8(%ebp),%esi
  800b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b6d:	89 f0                	mov    %esi,%eax
  800b6f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b73:	85 c9                	test   %ecx,%ecx
  800b75:	75 0b                	jne    800b82 <strlcpy+0x23>
  800b77:	eb 1d                	jmp    800b96 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b79:	83 c0 01             	add    $0x1,%eax
  800b7c:	83 c2 01             	add    $0x1,%edx
  800b7f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b82:	39 d8                	cmp    %ebx,%eax
  800b84:	74 0b                	je     800b91 <strlcpy+0x32>
  800b86:	0f b6 0a             	movzbl (%edx),%ecx
  800b89:	84 c9                	test   %cl,%cl
  800b8b:	75 ec                	jne    800b79 <strlcpy+0x1a>
  800b8d:	89 c2                	mov    %eax,%edx
  800b8f:	eb 02                	jmp    800b93 <strlcpy+0x34>
  800b91:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b93:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800b96:	29 f0                	sub    %esi,%eax
}
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ba5:	eb 06                	jmp    800bad <strcmp+0x11>
		p++, q++;
  800ba7:	83 c1 01             	add    $0x1,%ecx
  800baa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bad:	0f b6 01             	movzbl (%ecx),%eax
  800bb0:	84 c0                	test   %al,%al
  800bb2:	74 04                	je     800bb8 <strcmp+0x1c>
  800bb4:	3a 02                	cmp    (%edx),%al
  800bb6:	74 ef                	je     800ba7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb8:	0f b6 c0             	movzbl %al,%eax
  800bbb:	0f b6 12             	movzbl (%edx),%edx
  800bbe:	29 d0                	sub    %edx,%eax
}
  800bc0:	5d                   	pop    %ebp
  800bc1:	c3                   	ret    

00800bc2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	53                   	push   %ebx
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcc:	89 c3                	mov    %eax,%ebx
  800bce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bd1:	eb 06                	jmp    800bd9 <strncmp+0x17>
		n--, p++, q++;
  800bd3:	83 c0 01             	add    $0x1,%eax
  800bd6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800bd9:	39 d8                	cmp    %ebx,%eax
  800bdb:	74 15                	je     800bf2 <strncmp+0x30>
  800bdd:	0f b6 08             	movzbl (%eax),%ecx
  800be0:	84 c9                	test   %cl,%cl
  800be2:	74 04                	je     800be8 <strncmp+0x26>
  800be4:	3a 0a                	cmp    (%edx),%cl
  800be6:	74 eb                	je     800bd3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800be8:	0f b6 00             	movzbl (%eax),%eax
  800beb:	0f b6 12             	movzbl (%edx),%edx
  800bee:	29 d0                	sub    %edx,%eax
  800bf0:	eb 05                	jmp    800bf7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800bf2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800bf7:	5b                   	pop    %ebx
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c04:	eb 07                	jmp    800c0d <strchr+0x13>
		if (*s == c)
  800c06:	38 ca                	cmp    %cl,%dl
  800c08:	74 0f                	je     800c19 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c0a:	83 c0 01             	add    $0x1,%eax
  800c0d:	0f b6 10             	movzbl (%eax),%edx
  800c10:	84 d2                	test   %dl,%dl
  800c12:	75 f2                	jne    800c06 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800c14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c19:	5d                   	pop    %ebp
  800c1a:	c3                   	ret    

00800c1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c25:	eb 07                	jmp    800c2e <strfind+0x13>
		if (*s == c)
  800c27:	38 ca                	cmp    %cl,%dl
  800c29:	74 0a                	je     800c35 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c2b:	83 c0 01             	add    $0x1,%eax
  800c2e:	0f b6 10             	movzbl (%eax),%edx
  800c31:	84 d2                	test   %dl,%dl
  800c33:	75 f2                	jne    800c27 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c43:	85 c9                	test   %ecx,%ecx
  800c45:	74 36                	je     800c7d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c47:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c4d:	75 28                	jne    800c77 <memset+0x40>
  800c4f:	f6 c1 03             	test   $0x3,%cl
  800c52:	75 23                	jne    800c77 <memset+0x40>
		c &= 0xFF;
  800c54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c58:	89 d3                	mov    %edx,%ebx
  800c5a:	c1 e3 08             	shl    $0x8,%ebx
  800c5d:	89 d6                	mov    %edx,%esi
  800c5f:	c1 e6 18             	shl    $0x18,%esi
  800c62:	89 d0                	mov    %edx,%eax
  800c64:	c1 e0 10             	shl    $0x10,%eax
  800c67:	09 f0                	or     %esi,%eax
  800c69:	09 c2                	or     %eax,%edx
  800c6b:	89 d0                	mov    %edx,%eax
  800c6d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c6f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c72:	fc                   	cld    
  800c73:	f3 ab                	rep stos %eax,%es:(%edi)
  800c75:	eb 06                	jmp    800c7d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7a:	fc                   	cld    
  800c7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c7d:	89 f8                	mov    %edi,%eax
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	57                   	push   %edi
  800c88:	56                   	push   %esi
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c92:	39 c6                	cmp    %eax,%esi
  800c94:	73 35                	jae    800ccb <memmove+0x47>
  800c96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c99:	39 d0                	cmp    %edx,%eax
  800c9b:	73 2e                	jae    800ccb <memmove+0x47>
		s += n;
		d += n;
  800c9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800caa:	75 13                	jne    800cbf <memmove+0x3b>
  800cac:	f6 c1 03             	test   $0x3,%cl
  800caf:	75 0e                	jne    800cbf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cb1:	83 ef 04             	sub    $0x4,%edi
  800cb4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cb7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800cba:	fd                   	std    
  800cbb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cbd:	eb 09                	jmp    800cc8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cbf:	83 ef 01             	sub    $0x1,%edi
  800cc2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800cc5:	fd                   	std    
  800cc6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cc8:	fc                   	cld    
  800cc9:	eb 1d                	jmp    800ce8 <memmove+0x64>
  800ccb:	89 f2                	mov    %esi,%edx
  800ccd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ccf:	f6 c2 03             	test   $0x3,%dl
  800cd2:	75 0f                	jne    800ce3 <memmove+0x5f>
  800cd4:	f6 c1 03             	test   $0x3,%cl
  800cd7:	75 0a                	jne    800ce3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cd9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800cdc:	89 c7                	mov    %eax,%edi
  800cde:	fc                   	cld    
  800cdf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ce1:	eb 05                	jmp    800ce8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ce3:	89 c7                	mov    %eax,%edi
  800ce5:	fc                   	cld    
  800ce6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ce8:	5e                   	pop    %esi
  800ce9:	5f                   	pop    %edi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	89 04 24             	mov    %eax,(%esp)
  800d06:	e8 79 ff ff ff       	call   800c84 <memmove>
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
  800d12:	8b 55 08             	mov    0x8(%ebp),%edx
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	89 d6                	mov    %edx,%esi
  800d1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d1d:	eb 1a                	jmp    800d39 <memcmp+0x2c>
		if (*s1 != *s2)
  800d1f:	0f b6 02             	movzbl (%edx),%eax
  800d22:	0f b6 19             	movzbl (%ecx),%ebx
  800d25:	38 d8                	cmp    %bl,%al
  800d27:	74 0a                	je     800d33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800d29:	0f b6 c0             	movzbl %al,%eax
  800d2c:	0f b6 db             	movzbl %bl,%ebx
  800d2f:	29 d8                	sub    %ebx,%eax
  800d31:	eb 0f                	jmp    800d42 <memcmp+0x35>
		s1++, s2++;
  800d33:	83 c2 01             	add    $0x1,%edx
  800d36:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d39:	39 f2                	cmp    %esi,%edx
  800d3b:	75 e2                	jne    800d1f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d4f:	89 c2                	mov    %eax,%edx
  800d51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d54:	eb 07                	jmp    800d5d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d56:	38 08                	cmp    %cl,(%eax)
  800d58:	74 07                	je     800d61 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d5a:	83 c0 01             	add    $0x1,%eax
  800d5d:	39 d0                	cmp    %edx,%eax
  800d5f:	72 f5                	jb     800d56 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d6f:	eb 03                	jmp    800d74 <strtol+0x11>
		s++;
  800d71:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d74:	0f b6 0a             	movzbl (%edx),%ecx
  800d77:	80 f9 09             	cmp    $0x9,%cl
  800d7a:	74 f5                	je     800d71 <strtol+0xe>
  800d7c:	80 f9 20             	cmp    $0x20,%cl
  800d7f:	74 f0                	je     800d71 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d81:	80 f9 2b             	cmp    $0x2b,%cl
  800d84:	75 0a                	jne    800d90 <strtol+0x2d>
		s++;
  800d86:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d89:	bf 00 00 00 00       	mov    $0x0,%edi
  800d8e:	eb 11                	jmp    800da1 <strtol+0x3e>
  800d90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d95:	80 f9 2d             	cmp    $0x2d,%cl
  800d98:	75 07                	jne    800da1 <strtol+0x3e>
		s++, neg = 1;
  800d9a:	8d 52 01             	lea    0x1(%edx),%edx
  800d9d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800da6:	75 15                	jne    800dbd <strtol+0x5a>
  800da8:	80 3a 30             	cmpb   $0x30,(%edx)
  800dab:	75 10                	jne    800dbd <strtol+0x5a>
  800dad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800db1:	75 0a                	jne    800dbd <strtol+0x5a>
		s += 2, base = 16;
  800db3:	83 c2 02             	add    $0x2,%edx
  800db6:	b8 10 00 00 00       	mov    $0x10,%eax
  800dbb:	eb 10                	jmp    800dcd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	75 0c                	jne    800dcd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dc1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800dc3:	80 3a 30             	cmpb   $0x30,(%edx)
  800dc6:	75 05                	jne    800dcd <strtol+0x6a>
		s++, base = 8;
  800dc8:	83 c2 01             	add    $0x1,%edx
  800dcb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800dcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dd5:	0f b6 0a             	movzbl (%edx),%ecx
  800dd8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800ddb:	89 f0                	mov    %esi,%eax
  800ddd:	3c 09                	cmp    $0x9,%al
  800ddf:	77 08                	ja     800de9 <strtol+0x86>
			dig = *s - '0';
  800de1:	0f be c9             	movsbl %cl,%ecx
  800de4:	83 e9 30             	sub    $0x30,%ecx
  800de7:	eb 20                	jmp    800e09 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800de9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800dec:	89 f0                	mov    %esi,%eax
  800dee:	3c 19                	cmp    $0x19,%al
  800df0:	77 08                	ja     800dfa <strtol+0x97>
			dig = *s - 'a' + 10;
  800df2:	0f be c9             	movsbl %cl,%ecx
  800df5:	83 e9 57             	sub    $0x57,%ecx
  800df8:	eb 0f                	jmp    800e09 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800dfa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800dfd:	89 f0                	mov    %esi,%eax
  800dff:	3c 19                	cmp    $0x19,%al
  800e01:	77 16                	ja     800e19 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800e03:	0f be c9             	movsbl %cl,%ecx
  800e06:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e09:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800e0c:	7d 0f                	jge    800e1d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800e0e:	83 c2 01             	add    $0x1,%edx
  800e11:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800e15:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800e17:	eb bc                	jmp    800dd5 <strtol+0x72>
  800e19:	89 d8                	mov    %ebx,%eax
  800e1b:	eb 02                	jmp    800e1f <strtol+0xbc>
  800e1d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800e1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e23:	74 05                	je     800e2a <strtol+0xc7>
		*endptr = (char *) s;
  800e25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e28:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800e2a:	f7 d8                	neg    %eax
  800e2c:	85 ff                	test   %edi,%edi
  800e2e:	0f 44 c3             	cmove  %ebx,%eax
}
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	89 c3                	mov    %eax,%ebx
  800e49:	89 c7                	mov    %eax,%edi
  800e4b:	89 c6                	mov    %eax,%esi
  800e4d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e4f:	5b                   	pop    %ebx
  800e50:	5e                   	pop    %esi
  800e51:	5f                   	pop    %edi
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e64:	89 d1                	mov    %edx,%ecx
  800e66:	89 d3                	mov    %edx,%ebx
  800e68:	89 d7                	mov    %edx,%edi
  800e6a:	89 d6                	mov    %edx,%esi
  800e6c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e6e:	5b                   	pop    %ebx
  800e6f:	5e                   	pop    %esi
  800e70:	5f                   	pop    %edi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
  800e79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e81:	b8 03 00 00 00       	mov    $0x3,%eax
  800e86:	8b 55 08             	mov    0x8(%ebp),%edx
  800e89:	89 cb                	mov    %ecx,%ebx
  800e8b:	89 cf                	mov    %ecx,%edi
  800e8d:	89 ce                	mov    %ecx,%esi
  800e8f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e91:	85 c0                	test   %eax,%eax
  800e93:	7e 28                	jle    800ebd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e95:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e99:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ea0:	00 
  800ea1:	c7 44 24 08 f7 34 80 	movl   $0x8034f7,0x8(%esp)
  800ea8:	00 
  800ea9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb0:	00 
  800eb1:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  800eb8:	e8 b9 f4 ff ff       	call   800376 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ebd:	83 c4 2c             	add    $0x2c,%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    

00800ec5 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	57                   	push   %edi
  800ec9:	56                   	push   %esi
  800eca:	53                   	push   %ebx
  800ecb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ece:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed3:	b8 04 00 00 00       	mov    $0x4,%eax
  800ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  800edb:	89 cb                	mov    %ecx,%ebx
  800edd:	89 cf                	mov    %ecx,%edi
  800edf:	89 ce                	mov    %ecx,%esi
  800ee1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	7e 28                	jle    800f0f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eeb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ef2:	00 
  800ef3:	c7 44 24 08 f7 34 80 	movl   $0x8034f7,0x8(%esp)
  800efa:	00 
  800efb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f02:	00 
  800f03:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  800f0a:	e8 67 f4 ff ff       	call   800376 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800f0f:	83 c4 2c             	add    $0x2c,%esp
  800f12:	5b                   	pop    %ebx
  800f13:	5e                   	pop    %esi
  800f14:	5f                   	pop    %edi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	57                   	push   %edi
  800f1b:	56                   	push   %esi
  800f1c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f22:	b8 02 00 00 00       	mov    $0x2,%eax
  800f27:	89 d1                	mov    %edx,%ecx
  800f29:	89 d3                	mov    %edx,%ebx
  800f2b:	89 d7                	mov    %edx,%edi
  800f2d:	89 d6                	mov    %edx,%esi
  800f2f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    

00800f36 <sys_yield>:

void
sys_yield(void)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	57                   	push   %edi
  800f3a:	56                   	push   %esi
  800f3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f41:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f46:	89 d1                	mov    %edx,%ecx
  800f48:	89 d3                	mov    %edx,%ebx
  800f4a:	89 d7                	mov    %edx,%edi
  800f4c:	89 d6                	mov    %edx,%esi
  800f4e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800f5e:	be 00 00 00 00       	mov    $0x0,%esi
  800f63:	b8 05 00 00 00       	mov    $0x5,%eax
  800f68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f71:	89 f7                	mov    %esi,%edi
  800f73:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f75:	85 c0                	test   %eax,%eax
  800f77:	7e 28                	jle    800fa1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f79:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f7d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f84:	00 
  800f85:	c7 44 24 08 f7 34 80 	movl   $0x8034f7,0x8(%esp)
  800f8c:	00 
  800f8d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f94:	00 
  800f95:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  800f9c:	e8 d5 f3 ff ff       	call   800376 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fa1:	83 c4 2c             	add    $0x2c,%esp
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    

00800fa9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	57                   	push   %edi
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
  800faf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb2:	b8 06 00 00 00       	mov    $0x6,%eax
  800fb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fba:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc3:	8b 75 18             	mov    0x18(%ebp),%esi
  800fc6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	7e 28                	jle    800ff4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fd7:	00 
  800fd8:	c7 44 24 08 f7 34 80 	movl   $0x8034f7,0x8(%esp)
  800fdf:	00 
  800fe0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe7:	00 
  800fe8:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  800fef:	e8 82 f3 ff ff       	call   800376 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ff4:	83 c4 2c             	add    $0x2c,%esp
  800ff7:	5b                   	pop    %ebx
  800ff8:	5e                   	pop    %esi
  800ff9:	5f                   	pop    %edi
  800ffa:	5d                   	pop    %ebp
  800ffb:	c3                   	ret    

00800ffc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	57                   	push   %edi
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
  801002:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801005:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100a:	b8 07 00 00 00       	mov    $0x7,%eax
  80100f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801012:	8b 55 08             	mov    0x8(%ebp),%edx
  801015:	89 df                	mov    %ebx,%edi
  801017:	89 de                	mov    %ebx,%esi
  801019:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80101b:	85 c0                	test   %eax,%eax
  80101d:	7e 28                	jle    801047 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101f:	89 44 24 10          	mov    %eax,0x10(%esp)
  801023:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80102a:	00 
  80102b:	c7 44 24 08 f7 34 80 	movl   $0x8034f7,0x8(%esp)
  801032:	00 
  801033:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80103a:	00 
  80103b:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  801042:	e8 2f f3 ff ff       	call   800376 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801047:	83 c4 2c             	add    $0x2c,%esp
  80104a:	5b                   	pop    %ebx
  80104b:	5e                   	pop    %esi
  80104c:	5f                   	pop    %edi
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	57                   	push   %edi
  801053:	56                   	push   %esi
  801054:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801055:	b9 00 00 00 00       	mov    $0x0,%ecx
  80105a:	b8 10 00 00 00       	mov    $0x10,%eax
  80105f:	8b 55 08             	mov    0x8(%ebp),%edx
  801062:	89 cb                	mov    %ecx,%ebx
  801064:	89 cf                	mov    %ecx,%edi
  801066:	89 ce                	mov    %ecx,%esi
  801068:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80106a:	5b                   	pop    %ebx
  80106b:	5e                   	pop    %esi
  80106c:	5f                   	pop    %edi
  80106d:	5d                   	pop    %ebp
  80106e:	c3                   	ret    

0080106f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	57                   	push   %edi
  801073:	56                   	push   %esi
  801074:	53                   	push   %ebx
  801075:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801078:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107d:	b8 09 00 00 00       	mov    $0x9,%eax
  801082:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801085:	8b 55 08             	mov    0x8(%ebp),%edx
  801088:	89 df                	mov    %ebx,%edi
  80108a:	89 de                	mov    %ebx,%esi
  80108c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80108e:	85 c0                	test   %eax,%eax
  801090:	7e 28                	jle    8010ba <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801092:	89 44 24 10          	mov    %eax,0x10(%esp)
  801096:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80109d:	00 
  80109e:	c7 44 24 08 f7 34 80 	movl   $0x8034f7,0x8(%esp)
  8010a5:	00 
  8010a6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ad:	00 
  8010ae:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  8010b5:	e8 bc f2 ff ff       	call   800376 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010ba:	83 c4 2c             	add    $0x2c,%esp
  8010bd:	5b                   	pop    %ebx
  8010be:	5e                   	pop    %esi
  8010bf:	5f                   	pop    %edi
  8010c0:	5d                   	pop    %ebp
  8010c1:	c3                   	ret    

008010c2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	57                   	push   %edi
  8010c6:	56                   	push   %esi
  8010c7:	53                   	push   %ebx
  8010c8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010db:	89 df                	mov    %ebx,%edi
  8010dd:	89 de                	mov    %ebx,%esi
  8010df:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010e1:	85 c0                	test   %eax,%eax
  8010e3:	7e 28                	jle    80110d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010f0:	00 
  8010f1:	c7 44 24 08 f7 34 80 	movl   $0x8034f7,0x8(%esp)
  8010f8:	00 
  8010f9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801100:	00 
  801101:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  801108:	e8 69 f2 ff ff       	call   800376 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80110d:	83 c4 2c             	add    $0x2c,%esp
  801110:	5b                   	pop    %ebx
  801111:	5e                   	pop    %esi
  801112:	5f                   	pop    %edi
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	57                   	push   %edi
  801119:	56                   	push   %esi
  80111a:	53                   	push   %ebx
  80111b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801123:	b8 0b 00 00 00       	mov    $0xb,%eax
  801128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112b:	8b 55 08             	mov    0x8(%ebp),%edx
  80112e:	89 df                	mov    %ebx,%edi
  801130:	89 de                	mov    %ebx,%esi
  801132:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801134:	85 c0                	test   %eax,%eax
  801136:	7e 28                	jle    801160 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801138:	89 44 24 10          	mov    %eax,0x10(%esp)
  80113c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801143:	00 
  801144:	c7 44 24 08 f7 34 80 	movl   $0x8034f7,0x8(%esp)
  80114b:	00 
  80114c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801153:	00 
  801154:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  80115b:	e8 16 f2 ff ff       	call   800376 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801160:	83 c4 2c             	add    $0x2c,%esp
  801163:	5b                   	pop    %ebx
  801164:	5e                   	pop    %esi
  801165:	5f                   	pop    %edi
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    

00801168 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	57                   	push   %edi
  80116c:	56                   	push   %esi
  80116d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80116e:	be 00 00 00 00       	mov    $0x0,%esi
  801173:	b8 0d 00 00 00       	mov    $0xd,%eax
  801178:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117b:	8b 55 08             	mov    0x8(%ebp),%edx
  80117e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801181:	8b 7d 14             	mov    0x14(%ebp),%edi
  801184:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801186:	5b                   	pop    %ebx
  801187:	5e                   	pop    %esi
  801188:	5f                   	pop    %edi
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	57                   	push   %edi
  80118f:	56                   	push   %esi
  801190:	53                   	push   %ebx
  801191:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801194:	b9 00 00 00 00       	mov    $0x0,%ecx
  801199:	b8 0e 00 00 00       	mov    $0xe,%eax
  80119e:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a1:	89 cb                	mov    %ecx,%ebx
  8011a3:	89 cf                	mov    %ecx,%edi
  8011a5:	89 ce                	mov    %ecx,%esi
  8011a7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	7e 28                	jle    8011d5 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ad:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8011b8:	00 
  8011b9:	c7 44 24 08 f7 34 80 	movl   $0x8034f7,0x8(%esp)
  8011c0:	00 
  8011c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011c8:	00 
  8011c9:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  8011d0:	e8 a1 f1 ff ff       	call   800376 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011d5:	83 c4 2c             	add    $0x2c,%esp
  8011d8:	5b                   	pop    %ebx
  8011d9:	5e                   	pop    %esi
  8011da:	5f                   	pop    %edi
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	57                   	push   %edi
  8011e1:	56                   	push   %esi
  8011e2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011e8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011ed:	89 d1                	mov    %edx,%ecx
  8011ef:	89 d3                	mov    %edx,%ebx
  8011f1:	89 d7                	mov    %edx,%edi
  8011f3:	89 d6                	mov    %edx,%esi
  8011f5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011f7:	5b                   	pop    %ebx
  8011f8:	5e                   	pop    %esi
  8011f9:	5f                   	pop    %edi
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	57                   	push   %edi
  801200:	56                   	push   %esi
  801201:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801202:	bb 00 00 00 00       	mov    $0x0,%ebx
  801207:	b8 11 00 00 00       	mov    $0x11,%eax
  80120c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80120f:	8b 55 08             	mov    0x8(%ebp),%edx
  801212:	89 df                	mov    %ebx,%edi
  801214:	89 de                	mov    %ebx,%esi
  801216:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801218:	5b                   	pop    %ebx
  801219:	5e                   	pop    %esi
  80121a:	5f                   	pop    %edi
  80121b:	5d                   	pop    %ebp
  80121c:	c3                   	ret    

0080121d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	57                   	push   %edi
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801223:	bb 00 00 00 00       	mov    $0x0,%ebx
  801228:	b8 12 00 00 00       	mov    $0x12,%eax
  80122d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801230:	8b 55 08             	mov    0x8(%ebp),%edx
  801233:	89 df                	mov    %ebx,%edi
  801235:	89 de                	mov    %ebx,%esi
  801237:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801239:	5b                   	pop    %ebx
  80123a:	5e                   	pop    %esi
  80123b:	5f                   	pop    %edi
  80123c:	5d                   	pop    %ebp
  80123d:	c3                   	ret    

0080123e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	57                   	push   %edi
  801242:	56                   	push   %esi
  801243:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801244:	b9 00 00 00 00       	mov    $0x0,%ecx
  801249:	b8 13 00 00 00       	mov    $0x13,%eax
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	89 cb                	mov    %ecx,%ebx
  801253:	89 cf                	mov    %ecx,%edi
  801255:	89 ce                	mov    %ecx,%esi
  801257:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801259:	5b                   	pop    %ebx
  80125a:	5e                   	pop    %esi
  80125b:	5f                   	pop    %edi
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    

0080125e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	57                   	push   %edi
  801262:	56                   	push   %esi
  801263:	53                   	push   %ebx
  801264:	83 ec 2c             	sub    $0x2c,%esp
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80126a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80126c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80126f:	89 f8                	mov    %edi,%eax
  801271:	c1 e8 0c             	shr    $0xc,%eax
  801274:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801277:	e8 9b fc ff ff       	call   800f17 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80127c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801282:	0f 84 de 00 00 00    	je     801366 <pgfault+0x108>
  801288:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  80128a:	85 c0                	test   %eax,%eax
  80128c:	79 20                	jns    8012ae <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  80128e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801292:	c7 44 24 08 22 35 80 	movl   $0x803522,0x8(%esp)
  801299:	00 
  80129a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8012a1:	00 
  8012a2:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  8012a9:	e8 c8 f0 ff ff       	call   800376 <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  8012ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  8012b8:	25 05 08 00 00       	and    $0x805,%eax
  8012bd:	3d 05 08 00 00       	cmp    $0x805,%eax
  8012c2:	0f 85 ba 00 00 00    	jne    801382 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8012c8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012cf:	00 
  8012d0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012d7:	00 
  8012d8:	89 1c 24             	mov    %ebx,(%esp)
  8012db:	e8 75 fc ff ff       	call   800f55 <sys_page_alloc>
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	79 20                	jns    801304 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  8012e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012e8:	c7 44 24 08 49 35 80 	movl   $0x803549,0x8(%esp)
  8012ef:	00 
  8012f0:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8012f7:	00 
  8012f8:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  8012ff:	e8 72 f0 ff ff       	call   800376 <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  801304:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  80130a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801311:	00 
  801312:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801316:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80131d:	e8 62 f9 ff ff       	call   800c84 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  801322:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801329:	00 
  80132a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80132e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801332:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801339:	00 
  80133a:	89 1c 24             	mov    %ebx,(%esp)
  80133d:	e8 67 fc ff ff       	call   800fa9 <sys_page_map>
  801342:	85 c0                	test   %eax,%eax
  801344:	79 3c                	jns    801382 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  801346:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80134a:	c7 44 24 08 5c 35 80 	movl   $0x80355c,0x8(%esp)
  801351:	00 
  801352:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801359:	00 
  80135a:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  801361:	e8 10 f0 ff ff       	call   800376 <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801366:	c7 44 24 08 80 35 80 	movl   $0x803580,0x8(%esp)
  80136d:	00 
  80136e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801375:	00 
  801376:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  80137d:	e8 f4 ef ff ff       	call   800376 <_panic>
}
  801382:	83 c4 2c             	add    $0x2c,%esp
  801385:	5b                   	pop    %ebx
  801386:	5e                   	pop    %esi
  801387:	5f                   	pop    %edi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	56                   	push   %esi
  80138e:	53                   	push   %ebx
  80138f:	83 ec 20             	sub    $0x20,%esp
  801392:	8b 75 08             	mov    0x8(%ebp),%esi
  801395:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801398:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80139f:	00 
  8013a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013a4:	89 34 24             	mov    %esi,(%esp)
  8013a7:	e8 a9 fb ff ff       	call   800f55 <sys_page_alloc>
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	79 20                	jns    8013d0 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  8013b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013b4:	c7 44 24 08 49 35 80 	movl   $0x803549,0x8(%esp)
  8013bb:	00 
  8013bc:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8013c3:	00 
  8013c4:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  8013cb:	e8 a6 ef ff ff       	call   800376 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8013d0:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8013d7:	00 
  8013d8:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8013df:	00 
  8013e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013e7:	00 
  8013e8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013ec:	89 34 24             	mov    %esi,(%esp)
  8013ef:	e8 b5 fb ff ff       	call   800fa9 <sys_page_map>
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	79 20                	jns    801418 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  8013f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013fc:	c7 44 24 08 5c 35 80 	movl   $0x80355c,0x8(%esp)
  801403:	00 
  801404:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80140b:	00 
  80140c:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  801413:	e8 5e ef ff ff       	call   800376 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  801418:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80141f:	00 
  801420:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801424:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  80142b:	e8 54 f8 ff ff       	call   800c84 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801430:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801437:	00 
  801438:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80143f:	e8 b8 fb ff ff       	call   800ffc <sys_page_unmap>
  801444:	85 c0                	test   %eax,%eax
  801446:	79 20                	jns    801468 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  801448:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80144c:	c7 44 24 08 6d 35 80 	movl   $0x80356d,0x8(%esp)
  801453:	00 
  801454:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80145b:	00 
  80145c:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  801463:	e8 0e ef ff ff       	call   800376 <_panic>

}
  801468:	83 c4 20             	add    $0x20,%esp
  80146b:	5b                   	pop    %ebx
  80146c:	5e                   	pop    %esi
  80146d:	5d                   	pop    %ebp
  80146e:	c3                   	ret    

0080146f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	57                   	push   %edi
  801473:	56                   	push   %esi
  801474:	53                   	push   %ebx
  801475:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801478:	c7 04 24 5e 12 80 00 	movl   $0x80125e,(%esp)
  80147f:	e8 42 17 00 00       	call   802bc6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801484:	b8 08 00 00 00       	mov    $0x8,%eax
  801489:	cd 30                	int    $0x30
  80148b:	89 c6                	mov    %eax,%esi
  80148d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801490:	85 c0                	test   %eax,%eax
  801492:	79 20                	jns    8014b4 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801494:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801498:	c7 44 24 08 a4 35 80 	movl   $0x8035a4,0x8(%esp)
  80149f:	00 
  8014a0:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  8014a7:	00 
  8014a8:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  8014af:	e8 c2 ee ff ff       	call   800376 <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8014b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	75 21                	jne    8014de <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8014bd:	e8 55 fa ff ff       	call   800f17 <sys_getenvid>
  8014c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014c7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014ca:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014cf:	a3 08 50 80 00       	mov    %eax,0x805008
		//set_pgfault_handler(pgfault);
		return 0;
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d9:	e9 88 01 00 00       	jmp    801666 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8014de:	89 d8                	mov    %ebx,%eax
  8014e0:	c1 e8 16             	shr    $0x16,%eax
  8014e3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014ea:	a8 01                	test   $0x1,%al
  8014ec:	0f 84 e0 00 00 00    	je     8015d2 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8014f2:	89 df                	mov    %ebx,%edi
  8014f4:	c1 ef 0c             	shr    $0xc,%edi
  8014f7:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  8014fe:	a8 01                	test   $0x1,%al
  801500:	0f 84 c4 00 00 00    	je     8015ca <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801506:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  80150d:	f6 c4 04             	test   $0x4,%ah
  801510:	74 0d                	je     80151f <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  801512:	25 07 0e 00 00       	and    $0xe07,%eax
  801517:	83 c8 05             	or     $0x5,%eax
  80151a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80151d:	eb 1b                	jmp    80153a <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  80151f:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  801524:	83 f8 01             	cmp    $0x1,%eax
  801527:	19 c0                	sbb    %eax,%eax
  801529:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80152c:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  801533:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  80153a:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  80153d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801540:	89 44 24 10          	mov    %eax,0x10(%esp)
  801544:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801548:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80154f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801553:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80155a:	e8 4a fa ff ff       	call   800fa9 <sys_page_map>
  80155f:	85 c0                	test   %eax,%eax
  801561:	79 20                	jns    801583 <fork+0x114>
		panic("sys_page_map: %e", r);
  801563:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801567:	c7 44 24 08 5c 35 80 	movl   $0x80355c,0x8(%esp)
  80156e:	00 
  80156f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801576:	00 
  801577:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  80157e:	e8 f3 ed ff ff       	call   800376 <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801586:	89 44 24 10          	mov    %eax,0x10(%esp)
  80158a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80158e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801595:	00 
  801596:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80159a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a1:	e8 03 fa ff ff       	call   800fa9 <sys_page_map>
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	79 20                	jns    8015ca <fork+0x15b>
		panic("sys_page_map: %e", r);
  8015aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015ae:	c7 44 24 08 5c 35 80 	movl   $0x80355c,0x8(%esp)
  8015b5:	00 
  8015b6:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  8015bd:	00 
  8015be:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  8015c5:	e8 ac ed ff ff       	call   800376 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  8015ca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015d0:	eb 06                	jmp    8015d8 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  8015d2:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  8015d8:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  8015de:	0f 86 fa fe ff ff    	jbe    8014de <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8015e4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015eb:	00 
  8015ec:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8015f3:	ee 
  8015f4:	89 34 24             	mov    %esi,(%esp)
  8015f7:	e8 59 f9 ff ff       	call   800f55 <sys_page_alloc>
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	79 20                	jns    801620 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  801600:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801604:	c7 44 24 08 49 35 80 	movl   $0x803549,0x8(%esp)
  80160b:	00 
  80160c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  801613:	00 
  801614:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  80161b:	e8 56 ed ff ff       	call   800376 <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  801620:	c7 44 24 04 59 2c 80 	movl   $0x802c59,0x4(%esp)
  801627:	00 
  801628:	89 34 24             	mov    %esi,(%esp)
  80162b:	e8 e5 fa ff ff       	call   801115 <sys_env_set_pgfault_upcall>
  801630:	85 c0                	test   %eax,%eax
  801632:	79 20                	jns    801654 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  801634:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801638:	c7 44 24 08 c8 35 80 	movl   $0x8035c8,0x8(%esp)
  80163f:	00 
  801640:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  801647:	00 
  801648:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  80164f:	e8 22 ed ff ff       	call   800376 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801654:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80165b:	00 
  80165c:	89 34 24             	mov    %esi,(%esp)
  80165f:	e8 0b fa ff ff       	call   80106f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801664:	89 f0                	mov    %esi,%eax

}
  801666:	83 c4 2c             	add    $0x2c,%esp
  801669:	5b                   	pop    %ebx
  80166a:	5e                   	pop    %esi
  80166b:	5f                   	pop    %edi
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    

0080166e <sfork>:

// Challenge!
int
sfork(void)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	57                   	push   %edi
  801672:	56                   	push   %esi
  801673:	53                   	push   %ebx
  801674:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801677:	c7 04 24 5e 12 80 00 	movl   $0x80125e,(%esp)
  80167e:	e8 43 15 00 00       	call   802bc6 <set_pgfault_handler>
  801683:	b8 08 00 00 00       	mov    $0x8,%eax
  801688:	cd 30                	int    $0x30
  80168a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  80168c:	85 c0                	test   %eax,%eax
  80168e:	79 20                	jns    8016b0 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801690:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801694:	c7 44 24 08 a4 35 80 	movl   $0x8035a4,0x8(%esp)
  80169b:	00 
  80169c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  8016a3:	00 
  8016a4:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  8016ab:	e8 c6 ec ff ff       	call   800376 <_panic>
  8016b0:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  8016b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b7:	85 c0                	test   %eax,%eax
  8016b9:	75 2d                	jne    8016e8 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  8016bb:	e8 57 f8 ff ff       	call   800f17 <sys_getenvid>
  8016c0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016c5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8016c8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016cd:	a3 08 50 80 00       	mov    %eax,0x805008
		set_pgfault_handler(pgfault);
  8016d2:	c7 04 24 5e 12 80 00 	movl   $0x80125e,(%esp)
  8016d9:	e8 e8 14 00 00       	call   802bc6 <set_pgfault_handler>
		return 0;
  8016de:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e3:	e9 1d 01 00 00       	jmp    801805 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  8016e8:	89 d8                	mov    %ebx,%eax
  8016ea:	c1 e8 16             	shr    $0x16,%eax
  8016ed:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016f4:	a8 01                	test   $0x1,%al
  8016f6:	74 69                	je     801761 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8016f8:	89 d8                	mov    %ebx,%eax
  8016fa:	c1 e8 0c             	shr    $0xc,%eax
  8016fd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801704:	f6 c2 01             	test   $0x1,%dl
  801707:	74 50                	je     801759 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  801709:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  801710:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  801713:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  801719:	89 54 24 10          	mov    %edx,0x10(%esp)
  80171d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801721:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801725:	89 44 24 04          	mov    %eax,0x4(%esp)
  801729:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801730:	e8 74 f8 ff ff       	call   800fa9 <sys_page_map>
  801735:	85 c0                	test   %eax,%eax
  801737:	79 20                	jns    801759 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  801739:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80173d:	c7 44 24 08 5c 35 80 	movl   $0x80355c,0x8(%esp)
  801744:	00 
  801745:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  80174c:	00 
  80174d:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  801754:	e8 1d ec ff ff       	call   800376 <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801759:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80175f:	eb 06                	jmp    801767 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801761:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801767:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  80176d:	0f 86 75 ff ff ff    	jbe    8016e8 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801773:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  80177a:	ee 
  80177b:	89 34 24             	mov    %esi,(%esp)
  80177e:	e8 07 fc ff ff       	call   80138a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801783:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80178a:	00 
  80178b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801792:	ee 
  801793:	89 34 24             	mov    %esi,(%esp)
  801796:	e8 ba f7 ff ff       	call   800f55 <sys_page_alloc>
  80179b:	85 c0                	test   %eax,%eax
  80179d:	79 20                	jns    8017bf <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  80179f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017a3:	c7 44 24 08 49 35 80 	movl   $0x803549,0x8(%esp)
  8017aa:	00 
  8017ab:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  8017b2:	00 
  8017b3:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  8017ba:	e8 b7 eb ff ff       	call   800376 <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8017bf:	c7 44 24 04 59 2c 80 	movl   $0x802c59,0x4(%esp)
  8017c6:	00 
  8017c7:	89 34 24             	mov    %esi,(%esp)
  8017ca:	e8 46 f9 ff ff       	call   801115 <sys_env_set_pgfault_upcall>
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	79 20                	jns    8017f3 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  8017d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017d7:	c7 44 24 08 c8 35 80 	movl   $0x8035c8,0x8(%esp)
  8017de:	00 
  8017df:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  8017e6:	00 
  8017e7:	c7 04 24 3e 35 80 00 	movl   $0x80353e,(%esp)
  8017ee:	e8 83 eb ff ff       	call   800376 <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  8017f3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8017fa:	00 
  8017fb:	89 34 24             	mov    %esi,(%esp)
  8017fe:	e8 6c f8 ff ff       	call   80106f <sys_env_set_status>
	return envid;
  801803:	89 f0                	mov    %esi,%eax

}
  801805:	83 c4 2c             	add    $0x2c,%esp
  801808:	5b                   	pop    %ebx
  801809:	5e                   	pop    %esi
  80180a:	5f                   	pop    %edi
  80180b:	5d                   	pop    %ebp
  80180c:	c3                   	ret    
  80180d:	66 90                	xchg   %ax,%ax
  80180f:	90                   	nop

00801810 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	05 00 00 00 30       	add    $0x30000000,%eax
  80181b:	c1 e8 0c             	shr    $0xc,%eax
}
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    

00801820 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80182b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801830:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801835:	5d                   	pop    %ebp
  801836:	c3                   	ret    

00801837 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80183d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801842:	89 c2                	mov    %eax,%edx
  801844:	c1 ea 16             	shr    $0x16,%edx
  801847:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80184e:	f6 c2 01             	test   $0x1,%dl
  801851:	74 11                	je     801864 <fd_alloc+0x2d>
  801853:	89 c2                	mov    %eax,%edx
  801855:	c1 ea 0c             	shr    $0xc,%edx
  801858:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80185f:	f6 c2 01             	test   $0x1,%dl
  801862:	75 09                	jne    80186d <fd_alloc+0x36>
			*fd_store = fd;
  801864:	89 01                	mov    %eax,(%ecx)
			return 0;
  801866:	b8 00 00 00 00       	mov    $0x0,%eax
  80186b:	eb 17                	jmp    801884 <fd_alloc+0x4d>
  80186d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801872:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801877:	75 c9                	jne    801842 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801879:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80187f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801884:	5d                   	pop    %ebp
  801885:	c3                   	ret    

00801886 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80188c:	83 f8 1f             	cmp    $0x1f,%eax
  80188f:	77 36                	ja     8018c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801891:	c1 e0 0c             	shl    $0xc,%eax
  801894:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801899:	89 c2                	mov    %eax,%edx
  80189b:	c1 ea 16             	shr    $0x16,%edx
  80189e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018a5:	f6 c2 01             	test   $0x1,%dl
  8018a8:	74 24                	je     8018ce <fd_lookup+0x48>
  8018aa:	89 c2                	mov    %eax,%edx
  8018ac:	c1 ea 0c             	shr    $0xc,%edx
  8018af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018b6:	f6 c2 01             	test   $0x1,%dl
  8018b9:	74 1a                	je     8018d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018be:	89 02                	mov    %eax,(%edx)
	return 0;
  8018c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c5:	eb 13                	jmp    8018da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018cc:	eb 0c                	jmp    8018da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d3:	eb 05                	jmp    8018da <fd_lookup+0x54>
  8018d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    

008018dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 18             	sub    $0x18,%esp
  8018e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ea:	eb 13                	jmp    8018ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8018ec:	39 08                	cmp    %ecx,(%eax)
  8018ee:	75 0c                	jne    8018fc <dev_lookup+0x20>
			*dev = devtab[i];
  8018f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fa:	eb 38                	jmp    801934 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018fc:	83 c2 01             	add    $0x1,%edx
  8018ff:	8b 04 95 68 36 80 00 	mov    0x803668(,%edx,4),%eax
  801906:	85 c0                	test   %eax,%eax
  801908:	75 e2                	jne    8018ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80190a:	a1 08 50 80 00       	mov    0x805008,%eax
  80190f:	8b 40 48             	mov    0x48(%eax),%eax
  801912:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801916:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191a:	c7 04 24 ec 35 80 00 	movl   $0x8035ec,(%esp)
  801921:	e8 49 eb ff ff       	call   80046f <cprintf>
	*dev = 0;
  801926:	8b 45 0c             	mov    0xc(%ebp),%eax
  801929:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80192f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	56                   	push   %esi
  80193a:	53                   	push   %ebx
  80193b:	83 ec 20             	sub    $0x20,%esp
  80193e:	8b 75 08             	mov    0x8(%ebp),%esi
  801941:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801944:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801947:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80194b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801951:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801954:	89 04 24             	mov    %eax,(%esp)
  801957:	e8 2a ff ff ff       	call   801886 <fd_lookup>
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 05                	js     801965 <fd_close+0x2f>
	    || fd != fd2)
  801960:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801963:	74 0c                	je     801971 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801965:	84 db                	test   %bl,%bl
  801967:	ba 00 00 00 00       	mov    $0x0,%edx
  80196c:	0f 44 c2             	cmove  %edx,%eax
  80196f:	eb 3f                	jmp    8019b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801971:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801974:	89 44 24 04          	mov    %eax,0x4(%esp)
  801978:	8b 06                	mov    (%esi),%eax
  80197a:	89 04 24             	mov    %eax,(%esp)
  80197d:	e8 5a ff ff ff       	call   8018dc <dev_lookup>
  801982:	89 c3                	mov    %eax,%ebx
  801984:	85 c0                	test   %eax,%eax
  801986:	78 16                	js     80199e <fd_close+0x68>
		if (dev->dev_close)
  801988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80198e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801993:	85 c0                	test   %eax,%eax
  801995:	74 07                	je     80199e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801997:	89 34 24             	mov    %esi,(%esp)
  80199a:	ff d0                	call   *%eax
  80199c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80199e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019a9:	e8 4e f6 ff ff       	call   800ffc <sys_page_unmap>
	return r;
  8019ae:	89 d8                	mov    %ebx,%eax
}
  8019b0:	83 c4 20             	add    $0x20,%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5e                   	pop    %esi
  8019b5:	5d                   	pop    %ebp
  8019b6:	c3                   	ret    

008019b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	89 04 24             	mov    %eax,(%esp)
  8019ca:	e8 b7 fe ff ff       	call   801886 <fd_lookup>
  8019cf:	89 c2                	mov    %eax,%edx
  8019d1:	85 d2                	test   %edx,%edx
  8019d3:	78 13                	js     8019e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8019d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8019dc:	00 
  8019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e0:	89 04 24             	mov    %eax,(%esp)
  8019e3:	e8 4e ff ff ff       	call   801936 <fd_close>
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <close_all>:

void
close_all(void)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	53                   	push   %ebx
  8019ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019f6:	89 1c 24             	mov    %ebx,(%esp)
  8019f9:	e8 b9 ff ff ff       	call   8019b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8019fe:	83 c3 01             	add    $0x1,%ebx
  801a01:	83 fb 20             	cmp    $0x20,%ebx
  801a04:	75 f0                	jne    8019f6 <close_all+0xc>
		close(i);
}
  801a06:	83 c4 14             	add    $0x14,%esp
  801a09:	5b                   	pop    %ebx
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    

00801a0c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	57                   	push   %edi
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a15:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	89 04 24             	mov    %eax,(%esp)
  801a22:	e8 5f fe ff ff       	call   801886 <fd_lookup>
  801a27:	89 c2                	mov    %eax,%edx
  801a29:	85 d2                	test   %edx,%edx
  801a2b:	0f 88 e1 00 00 00    	js     801b12 <dup+0x106>
		return r;
	close(newfdnum);
  801a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a34:	89 04 24             	mov    %eax,(%esp)
  801a37:	e8 7b ff ff ff       	call   8019b7 <close>

	newfd = INDEX2FD(newfdnum);
  801a3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a3f:	c1 e3 0c             	shl    $0xc,%ebx
  801a42:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a4b:	89 04 24             	mov    %eax,(%esp)
  801a4e:	e8 cd fd ff ff       	call   801820 <fd2data>
  801a53:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801a55:	89 1c 24             	mov    %ebx,(%esp)
  801a58:	e8 c3 fd ff ff       	call   801820 <fd2data>
  801a5d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a5f:	89 f0                	mov    %esi,%eax
  801a61:	c1 e8 16             	shr    $0x16,%eax
  801a64:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a6b:	a8 01                	test   $0x1,%al
  801a6d:	74 43                	je     801ab2 <dup+0xa6>
  801a6f:	89 f0                	mov    %esi,%eax
  801a71:	c1 e8 0c             	shr    $0xc,%eax
  801a74:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a7b:	f6 c2 01             	test   $0x1,%dl
  801a7e:	74 32                	je     801ab2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a80:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a87:	25 07 0e 00 00       	and    $0xe07,%eax
  801a8c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a90:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a94:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a9b:	00 
  801a9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801aa0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aa7:	e8 fd f4 ff ff       	call   800fa9 <sys_page_map>
  801aac:	89 c6                	mov    %eax,%esi
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	78 3e                	js     801af0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ab5:	89 c2                	mov    %eax,%edx
  801ab7:	c1 ea 0c             	shr    $0xc,%edx
  801aba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ac1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801ac7:	89 54 24 10          	mov    %edx,0x10(%esp)
  801acb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801acf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ad6:	00 
  801ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae2:	e8 c2 f4 ff ff       	call   800fa9 <sys_page_map>
  801ae7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801aec:	85 f6                	test   %esi,%esi
  801aee:	79 22                	jns    801b12 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801af0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801af4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801afb:	e8 fc f4 ff ff       	call   800ffc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b0b:	e8 ec f4 ff ff       	call   800ffc <sys_page_unmap>
	return r;
  801b10:	89 f0                	mov    %esi,%eax
}
  801b12:	83 c4 3c             	add    $0x3c,%esp
  801b15:	5b                   	pop    %ebx
  801b16:	5e                   	pop    %esi
  801b17:	5f                   	pop    %edi
  801b18:	5d                   	pop    %ebp
  801b19:	c3                   	ret    

00801b1a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	53                   	push   %ebx
  801b1e:	83 ec 24             	sub    $0x24,%esp
  801b21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b24:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2b:	89 1c 24             	mov    %ebx,(%esp)
  801b2e:	e8 53 fd ff ff       	call   801886 <fd_lookup>
  801b33:	89 c2                	mov    %eax,%edx
  801b35:	85 d2                	test   %edx,%edx
  801b37:	78 6d                	js     801ba6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b43:	8b 00                	mov    (%eax),%eax
  801b45:	89 04 24             	mov    %eax,(%esp)
  801b48:	e8 8f fd ff ff       	call   8018dc <dev_lookup>
  801b4d:	85 c0                	test   %eax,%eax
  801b4f:	78 55                	js     801ba6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b54:	8b 50 08             	mov    0x8(%eax),%edx
  801b57:	83 e2 03             	and    $0x3,%edx
  801b5a:	83 fa 01             	cmp    $0x1,%edx
  801b5d:	75 23                	jne    801b82 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b5f:	a1 08 50 80 00       	mov    0x805008,%eax
  801b64:	8b 40 48             	mov    0x48(%eax),%eax
  801b67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6f:	c7 04 24 2d 36 80 00 	movl   $0x80362d,(%esp)
  801b76:	e8 f4 e8 ff ff       	call   80046f <cprintf>
		return -E_INVAL;
  801b7b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b80:	eb 24                	jmp    801ba6 <read+0x8c>
	}
	if (!dev->dev_read)
  801b82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b85:	8b 52 08             	mov    0x8(%edx),%edx
  801b88:	85 d2                	test   %edx,%edx
  801b8a:	74 15                	je     801ba1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b9a:	89 04 24             	mov    %eax,(%esp)
  801b9d:	ff d2                	call   *%edx
  801b9f:	eb 05                	jmp    801ba6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801ba1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801ba6:	83 c4 24             	add    $0x24,%esp
  801ba9:	5b                   	pop    %ebx
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    

00801bac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	57                   	push   %edi
  801bb0:	56                   	push   %esi
  801bb1:	53                   	push   %ebx
  801bb2:	83 ec 1c             	sub    $0x1c,%esp
  801bb5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bb8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bc0:	eb 23                	jmp    801be5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bc2:	89 f0                	mov    %esi,%eax
  801bc4:	29 d8                	sub    %ebx,%eax
  801bc6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bca:	89 d8                	mov    %ebx,%eax
  801bcc:	03 45 0c             	add    0xc(%ebp),%eax
  801bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd3:	89 3c 24             	mov    %edi,(%esp)
  801bd6:	e8 3f ff ff ff       	call   801b1a <read>
		if (m < 0)
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	78 10                	js     801bef <readn+0x43>
			return m;
		if (m == 0)
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	74 0a                	je     801bed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801be3:	01 c3                	add    %eax,%ebx
  801be5:	39 f3                	cmp    %esi,%ebx
  801be7:	72 d9                	jb     801bc2 <readn+0x16>
  801be9:	89 d8                	mov    %ebx,%eax
  801beb:	eb 02                	jmp    801bef <readn+0x43>
  801bed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801bef:	83 c4 1c             	add    $0x1c,%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5e                   	pop    %esi
  801bf4:	5f                   	pop    %edi
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    

00801bf7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	53                   	push   %ebx
  801bfb:	83 ec 24             	sub    $0x24,%esp
  801bfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c08:	89 1c 24             	mov    %ebx,(%esp)
  801c0b:	e8 76 fc ff ff       	call   801886 <fd_lookup>
  801c10:	89 c2                	mov    %eax,%edx
  801c12:	85 d2                	test   %edx,%edx
  801c14:	78 68                	js     801c7e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c20:	8b 00                	mov    (%eax),%eax
  801c22:	89 04 24             	mov    %eax,(%esp)
  801c25:	e8 b2 fc ff ff       	call   8018dc <dev_lookup>
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	78 50                	js     801c7e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c31:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c35:	75 23                	jne    801c5a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c37:	a1 08 50 80 00       	mov    0x805008,%eax
  801c3c:	8b 40 48             	mov    0x48(%eax),%eax
  801c3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c47:	c7 04 24 49 36 80 00 	movl   $0x803649,(%esp)
  801c4e:	e8 1c e8 ff ff       	call   80046f <cprintf>
		return -E_INVAL;
  801c53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c58:	eb 24                	jmp    801c7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c5d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c60:	85 d2                	test   %edx,%edx
  801c62:	74 15                	je     801c79 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c72:	89 04 24             	mov    %eax,(%esp)
  801c75:	ff d2                	call   *%edx
  801c77:	eb 05                	jmp    801c7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801c79:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801c7e:	83 c4 24             	add    $0x24,%esp
  801c81:	5b                   	pop    %ebx
  801c82:	5d                   	pop    %ebp
  801c83:	c3                   	ret    

00801c84 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c8a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	89 04 24             	mov    %eax,(%esp)
  801c97:	e8 ea fb ff ff       	call   801886 <fd_lookup>
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	78 0e                	js     801cae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	53                   	push   %ebx
  801cb4:	83 ec 24             	sub    $0x24,%esp
  801cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc1:	89 1c 24             	mov    %ebx,(%esp)
  801cc4:	e8 bd fb ff ff       	call   801886 <fd_lookup>
  801cc9:	89 c2                	mov    %eax,%edx
  801ccb:	85 d2                	test   %edx,%edx
  801ccd:	78 61                	js     801d30 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ccf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd9:	8b 00                	mov    (%eax),%eax
  801cdb:	89 04 24             	mov    %eax,(%esp)
  801cde:	e8 f9 fb ff ff       	call   8018dc <dev_lookup>
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	78 49                	js     801d30 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cee:	75 23                	jne    801d13 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801cf0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cf5:	8b 40 48             	mov    0x48(%eax),%eax
  801cf8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d00:	c7 04 24 0c 36 80 00 	movl   $0x80360c,(%esp)
  801d07:	e8 63 e7 ff ff       	call   80046f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801d0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d11:	eb 1d                	jmp    801d30 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801d13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d16:	8b 52 18             	mov    0x18(%edx),%edx
  801d19:	85 d2                	test   %edx,%edx
  801d1b:	74 0e                	je     801d2b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d24:	89 04 24             	mov    %eax,(%esp)
  801d27:	ff d2                	call   *%edx
  801d29:	eb 05                	jmp    801d30 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801d2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801d30:	83 c4 24             	add    $0x24,%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5d                   	pop    %ebp
  801d35:	c3                   	ret    

00801d36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	53                   	push   %ebx
  801d3a:	83 ec 24             	sub    $0x24,%esp
  801d3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	89 04 24             	mov    %eax,(%esp)
  801d4d:	e8 34 fb ff ff       	call   801886 <fd_lookup>
  801d52:	89 c2                	mov    %eax,%edx
  801d54:	85 d2                	test   %edx,%edx
  801d56:	78 52                	js     801daa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d62:	8b 00                	mov    (%eax),%eax
  801d64:	89 04 24             	mov    %eax,(%esp)
  801d67:	e8 70 fb ff ff       	call   8018dc <dev_lookup>
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	78 3a                	js     801daa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d73:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d77:	74 2c                	je     801da5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d79:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d7c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d83:	00 00 00 
	stat->st_isdir = 0;
  801d86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d8d:	00 00 00 
	stat->st_dev = dev;
  801d90:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d9d:	89 14 24             	mov    %edx,(%esp)
  801da0:	ff 50 14             	call   *0x14(%eax)
  801da3:	eb 05                	jmp    801daa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801da5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801daa:	83 c4 24             	add    $0x24,%esp
  801dad:	5b                   	pop    %ebx
  801dae:	5d                   	pop    %ebp
  801daf:	c3                   	ret    

00801db0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	56                   	push   %esi
  801db4:	53                   	push   %ebx
  801db5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801db8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dbf:	00 
  801dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc3:	89 04 24             	mov    %eax,(%esp)
  801dc6:	e8 99 02 00 00       	call   802064 <open>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	85 db                	test   %ebx,%ebx
  801dcf:	78 1b                	js     801dec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd8:	89 1c 24             	mov    %ebx,(%esp)
  801ddb:	e8 56 ff ff ff       	call   801d36 <fstat>
  801de0:	89 c6                	mov    %eax,%esi
	close(fd);
  801de2:	89 1c 24             	mov    %ebx,(%esp)
  801de5:	e8 cd fb ff ff       	call   8019b7 <close>
	return r;
  801dea:	89 f0                	mov    %esi,%eax
}
  801dec:	83 c4 10             	add    $0x10,%esp
  801def:	5b                   	pop    %ebx
  801df0:	5e                   	pop    %esi
  801df1:	5d                   	pop    %ebp
  801df2:	c3                   	ret    

00801df3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	56                   	push   %esi
  801df7:	53                   	push   %ebx
  801df8:	83 ec 10             	sub    $0x10,%esp
  801dfb:	89 c6                	mov    %eax,%esi
  801dfd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801dff:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801e06:	75 11                	jne    801e19 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e0f:	e8 3b 0f 00 00       	call   802d4f <ipc_find_env>
  801e14:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e19:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e20:	00 
  801e21:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801e28:	00 
  801e29:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e2d:	a1 00 50 80 00       	mov    0x805000,%eax
  801e32:	89 04 24             	mov    %eax,(%esp)
  801e35:	e8 ae 0e 00 00       	call   802ce8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e41:	00 
  801e42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e4d:	e8 2e 0e 00 00       	call   802c80 <ipc_recv>
}
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	5b                   	pop    %ebx
  801e56:	5e                   	pop    %esi
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    

00801e59 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	8b 40 0c             	mov    0xc(%eax),%eax
  801e65:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e72:	ba 00 00 00 00       	mov    $0x0,%edx
  801e77:	b8 02 00 00 00       	mov    $0x2,%eax
  801e7c:	e8 72 ff ff ff       	call   801df3 <fsipc>
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e94:	ba 00 00 00 00       	mov    $0x0,%edx
  801e99:	b8 06 00 00 00       	mov    $0x6,%eax
  801e9e:	e8 50 ff ff ff       	call   801df3 <fsipc>
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	53                   	push   %ebx
  801ea9:	83 ec 14             	sub    $0x14,%esp
  801eac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801eba:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ec4:	e8 2a ff ff ff       	call   801df3 <fsipc>
  801ec9:	89 c2                	mov    %eax,%edx
  801ecb:	85 d2                	test   %edx,%edx
  801ecd:	78 2b                	js     801efa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ecf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ed6:	00 
  801ed7:	89 1c 24             	mov    %ebx,(%esp)
  801eda:	e8 08 ec ff ff       	call   800ae7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801edf:	a1 80 60 80 00       	mov    0x806080,%eax
  801ee4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801eea:	a1 84 60 80 00       	mov    0x806084,%eax
  801eef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efa:	83 c4 14             	add    $0x14,%esp
  801efd:	5b                   	pop    %ebx
  801efe:	5d                   	pop    %ebp
  801eff:	c3                   	ret    

00801f00 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	53                   	push   %ebx
  801f04:	83 ec 14             	sub    $0x14,%esp
  801f07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801f0a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801f10:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801f15:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f18:	8b 55 08             	mov    0x8(%ebp),%edx
  801f1b:	8b 52 0c             	mov    0xc(%edx),%edx
  801f1e:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801f24:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801f29:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f34:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801f3b:	e8 44 ed ff ff       	call   800c84 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801f40:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801f47:	00 
  801f48:	c7 04 24 7c 36 80 00 	movl   $0x80367c,(%esp)
  801f4f:	e8 1b e5 ff ff       	call   80046f <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f54:	ba 00 00 00 00       	mov    $0x0,%edx
  801f59:	b8 04 00 00 00       	mov    $0x4,%eax
  801f5e:	e8 90 fe ff ff       	call   801df3 <fsipc>
  801f63:	85 c0                	test   %eax,%eax
  801f65:	78 53                	js     801fba <devfile_write+0xba>
		return r;
	assert(r <= n);
  801f67:	39 c3                	cmp    %eax,%ebx
  801f69:	73 24                	jae    801f8f <devfile_write+0x8f>
  801f6b:	c7 44 24 0c 81 36 80 	movl   $0x803681,0xc(%esp)
  801f72:	00 
  801f73:	c7 44 24 08 88 36 80 	movl   $0x803688,0x8(%esp)
  801f7a:	00 
  801f7b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801f82:	00 
  801f83:	c7 04 24 9d 36 80 00 	movl   $0x80369d,(%esp)
  801f8a:	e8 e7 e3 ff ff       	call   800376 <_panic>
	assert(r <= PGSIZE);
  801f8f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f94:	7e 24                	jle    801fba <devfile_write+0xba>
  801f96:	c7 44 24 0c a8 36 80 	movl   $0x8036a8,0xc(%esp)
  801f9d:	00 
  801f9e:	c7 44 24 08 88 36 80 	movl   $0x803688,0x8(%esp)
  801fa5:	00 
  801fa6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801fad:	00 
  801fae:	c7 04 24 9d 36 80 00 	movl   $0x80369d,(%esp)
  801fb5:	e8 bc e3 ff ff       	call   800376 <_panic>
	return r;
}
  801fba:	83 c4 14             	add    $0x14,%esp
  801fbd:	5b                   	pop    %ebx
  801fbe:	5d                   	pop    %ebp
  801fbf:	c3                   	ret    

00801fc0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	56                   	push   %esi
  801fc4:	53                   	push   %ebx
  801fc5:	83 ec 10             	sub    $0x10,%esp
  801fc8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801fd6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801fdc:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe1:	b8 03 00 00 00       	mov    $0x3,%eax
  801fe6:	e8 08 fe ff ff       	call   801df3 <fsipc>
  801feb:	89 c3                	mov    %eax,%ebx
  801fed:	85 c0                	test   %eax,%eax
  801fef:	78 6a                	js     80205b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ff1:	39 c6                	cmp    %eax,%esi
  801ff3:	73 24                	jae    802019 <devfile_read+0x59>
  801ff5:	c7 44 24 0c 81 36 80 	movl   $0x803681,0xc(%esp)
  801ffc:	00 
  801ffd:	c7 44 24 08 88 36 80 	movl   $0x803688,0x8(%esp)
  802004:	00 
  802005:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80200c:	00 
  80200d:	c7 04 24 9d 36 80 00 	movl   $0x80369d,(%esp)
  802014:	e8 5d e3 ff ff       	call   800376 <_panic>
	assert(r <= PGSIZE);
  802019:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80201e:	7e 24                	jle    802044 <devfile_read+0x84>
  802020:	c7 44 24 0c a8 36 80 	movl   $0x8036a8,0xc(%esp)
  802027:	00 
  802028:	c7 44 24 08 88 36 80 	movl   $0x803688,0x8(%esp)
  80202f:	00 
  802030:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802037:	00 
  802038:	c7 04 24 9d 36 80 00 	movl   $0x80369d,(%esp)
  80203f:	e8 32 e3 ff ff       	call   800376 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802044:	89 44 24 08          	mov    %eax,0x8(%esp)
  802048:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80204f:	00 
  802050:	8b 45 0c             	mov    0xc(%ebp),%eax
  802053:	89 04 24             	mov    %eax,(%esp)
  802056:	e8 29 ec ff ff       	call   800c84 <memmove>
	return r;
}
  80205b:	89 d8                	mov    %ebx,%eax
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	5b                   	pop    %ebx
  802061:	5e                   	pop    %esi
  802062:	5d                   	pop    %ebp
  802063:	c3                   	ret    

00802064 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	53                   	push   %ebx
  802068:	83 ec 24             	sub    $0x24,%esp
  80206b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80206e:	89 1c 24             	mov    %ebx,(%esp)
  802071:	e8 3a ea ff ff       	call   800ab0 <strlen>
  802076:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80207b:	7f 60                	jg     8020dd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80207d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802080:	89 04 24             	mov    %eax,(%esp)
  802083:	e8 af f7 ff ff       	call   801837 <fd_alloc>
  802088:	89 c2                	mov    %eax,%edx
  80208a:	85 d2                	test   %edx,%edx
  80208c:	78 54                	js     8020e2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80208e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802092:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802099:	e8 49 ea ff ff       	call   800ae7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80209e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a1:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8020a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ae:	e8 40 fd ff ff       	call   801df3 <fsipc>
  8020b3:	89 c3                	mov    %eax,%ebx
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	79 17                	jns    8020d0 <open+0x6c>
		fd_close(fd, 0);
  8020b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020c0:	00 
  8020c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c4:	89 04 24             	mov    %eax,(%esp)
  8020c7:	e8 6a f8 ff ff       	call   801936 <fd_close>
		return r;
  8020cc:	89 d8                	mov    %ebx,%eax
  8020ce:	eb 12                	jmp    8020e2 <open+0x7e>
	}

	return fd2num(fd);
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	89 04 24             	mov    %eax,(%esp)
  8020d6:	e8 35 f7 ff ff       	call   801810 <fd2num>
  8020db:	eb 05                	jmp    8020e2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8020dd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8020e2:	83 c4 24             	add    $0x24,%esp
  8020e5:	5b                   	pop    %ebx
  8020e6:	5d                   	pop    %ebp
  8020e7:	c3                   	ret    

008020e8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8020ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f3:	b8 08 00 00 00       	mov    $0x8,%eax
  8020f8:	e8 f6 fc ff ff       	call   801df3 <fsipc>
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <evict>:

int evict(void)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  802105:	c7 04 24 b4 36 80 00 	movl   $0x8036b4,(%esp)
  80210c:	e8 5e e3 ff ff       	call   80046f <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  802111:	ba 00 00 00 00       	mov    $0x0,%edx
  802116:	b8 09 00 00 00       	mov    $0x9,%eax
  80211b:	e8 d3 fc ff ff       	call   801df3 <fsipc>
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    
  802122:	66 90                	xchg   %ax,%ax
  802124:	66 90                	xchg   %ax,%ax
  802126:	66 90                	xchg   %ax,%ax
  802128:	66 90                	xchg   %ax,%ax
  80212a:	66 90                	xchg   %ax,%ax
  80212c:	66 90                	xchg   %ax,%ax
  80212e:	66 90                	xchg   %ax,%ax

00802130 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802136:	c7 44 24 04 cd 36 80 	movl   $0x8036cd,0x4(%esp)
  80213d:	00 
  80213e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802141:	89 04 24             	mov    %eax,(%esp)
  802144:	e8 9e e9 ff ff       	call   800ae7 <strcpy>
	return 0;
}
  802149:	b8 00 00 00 00       	mov    $0x0,%eax
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	53                   	push   %ebx
  802154:	83 ec 14             	sub    $0x14,%esp
  802157:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80215a:	89 1c 24             	mov    %ebx,(%esp)
  80215d:	e8 25 0c 00 00       	call   802d87 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802162:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802167:	83 f8 01             	cmp    $0x1,%eax
  80216a:	75 0d                	jne    802179 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80216c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80216f:	89 04 24             	mov    %eax,(%esp)
  802172:	e8 29 03 00 00       	call   8024a0 <nsipc_close>
  802177:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802179:	89 d0                	mov    %edx,%eax
  80217b:	83 c4 14             	add    $0x14,%esp
  80217e:	5b                   	pop    %ebx
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    

00802181 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802187:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80218e:	00 
  80218f:	8b 45 10             	mov    0x10(%ebp),%eax
  802192:	89 44 24 08          	mov    %eax,0x8(%esp)
  802196:	8b 45 0c             	mov    0xc(%ebp),%eax
  802199:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a3:	89 04 24             	mov    %eax,(%esp)
  8021a6:	e8 f0 03 00 00       	call   80259b <nsipc_send>
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8021b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021ba:	00 
  8021bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8021be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8021cf:	89 04 24             	mov    %eax,(%esp)
  8021d2:	e8 44 03 00 00       	call   80251b <nsipc_recv>
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021df:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021e6:	89 04 24             	mov    %eax,(%esp)
  8021e9:	e8 98 f6 ff ff       	call   801886 <fd_lookup>
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	78 17                	js     802209 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  8021fb:	39 08                	cmp    %ecx,(%eax)
  8021fd:	75 05                	jne    802204 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8021ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802202:	eb 05                	jmp    802209 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802204:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	56                   	push   %esi
  80220f:	53                   	push   %ebx
  802210:	83 ec 20             	sub    $0x20,%esp
  802213:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802215:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802218:	89 04 24             	mov    %eax,(%esp)
  80221b:	e8 17 f6 ff ff       	call   801837 <fd_alloc>
  802220:	89 c3                	mov    %eax,%ebx
  802222:	85 c0                	test   %eax,%eax
  802224:	78 21                	js     802247 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802226:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80222d:	00 
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	89 44 24 04          	mov    %eax,0x4(%esp)
  802235:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80223c:	e8 14 ed ff ff       	call   800f55 <sys_page_alloc>
  802241:	89 c3                	mov    %eax,%ebx
  802243:	85 c0                	test   %eax,%eax
  802245:	79 0c                	jns    802253 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802247:	89 34 24             	mov    %esi,(%esp)
  80224a:	e8 51 02 00 00       	call   8024a0 <nsipc_close>
		return r;
  80224f:	89 d8                	mov    %ebx,%eax
  802251:	eb 20                	jmp    802273 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802253:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80225e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802261:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802268:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80226b:	89 14 24             	mov    %edx,(%esp)
  80226e:	e8 9d f5 ff ff       	call   801810 <fd2num>
}
  802273:	83 c4 20             	add    $0x20,%esp
  802276:	5b                   	pop    %ebx
  802277:	5e                   	pop    %esi
  802278:	5d                   	pop    %ebp
  802279:	c3                   	ret    

0080227a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	e8 51 ff ff ff       	call   8021d9 <fd2sockid>
		return r;
  802288:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80228a:	85 c0                	test   %eax,%eax
  80228c:	78 23                	js     8022b1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80228e:	8b 55 10             	mov    0x10(%ebp),%edx
  802291:	89 54 24 08          	mov    %edx,0x8(%esp)
  802295:	8b 55 0c             	mov    0xc(%ebp),%edx
  802298:	89 54 24 04          	mov    %edx,0x4(%esp)
  80229c:	89 04 24             	mov    %eax,(%esp)
  80229f:	e8 45 01 00 00       	call   8023e9 <nsipc_accept>
		return r;
  8022a4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	78 07                	js     8022b1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8022aa:	e8 5c ff ff ff       	call   80220b <alloc_sockfd>
  8022af:	89 c1                	mov    %eax,%ecx
}
  8022b1:	89 c8                	mov    %ecx,%eax
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	e8 16 ff ff ff       	call   8021d9 <fd2sockid>
  8022c3:	89 c2                	mov    %eax,%edx
  8022c5:	85 d2                	test   %edx,%edx
  8022c7:	78 16                	js     8022df <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8022c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d7:	89 14 24             	mov    %edx,(%esp)
  8022da:	e8 60 01 00 00       	call   80243f <nsipc_bind>
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <shutdown>:

int
shutdown(int s, int how)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	e8 ea fe ff ff       	call   8021d9 <fd2sockid>
  8022ef:	89 c2                	mov    %eax,%edx
  8022f1:	85 d2                	test   %edx,%edx
  8022f3:	78 0f                	js     802304 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8022f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fc:	89 14 24             	mov    %edx,(%esp)
  8022ff:	e8 7a 01 00 00       	call   80247e <nsipc_shutdown>
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	e8 c5 fe ff ff       	call   8021d9 <fd2sockid>
  802314:	89 c2                	mov    %eax,%edx
  802316:	85 d2                	test   %edx,%edx
  802318:	78 16                	js     802330 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80231a:	8b 45 10             	mov    0x10(%ebp),%eax
  80231d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802321:	8b 45 0c             	mov    0xc(%ebp),%eax
  802324:	89 44 24 04          	mov    %eax,0x4(%esp)
  802328:	89 14 24             	mov    %edx,(%esp)
  80232b:	e8 8a 01 00 00       	call   8024ba <nsipc_connect>
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <listen>:

int
listen(int s, int backlog)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	e8 99 fe ff ff       	call   8021d9 <fd2sockid>
  802340:	89 c2                	mov    %eax,%edx
  802342:	85 d2                	test   %edx,%edx
  802344:	78 0f                	js     802355 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802346:	8b 45 0c             	mov    0xc(%ebp),%eax
  802349:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234d:	89 14 24             	mov    %edx,(%esp)
  802350:	e8 a4 01 00 00       	call   8024f9 <nsipc_listen>
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80235d:	8b 45 10             	mov    0x10(%ebp),%eax
  802360:	89 44 24 08          	mov    %eax,0x8(%esp)
  802364:	8b 45 0c             	mov    0xc(%ebp),%eax
  802367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	89 04 24             	mov    %eax,(%esp)
  802371:	e8 98 02 00 00       	call   80260e <nsipc_socket>
  802376:	89 c2                	mov    %eax,%edx
  802378:	85 d2                	test   %edx,%edx
  80237a:	78 05                	js     802381 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80237c:	e8 8a fe ff ff       	call   80220b <alloc_sockfd>
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	53                   	push   %ebx
  802387:	83 ec 14             	sub    $0x14,%esp
  80238a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80238c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802393:	75 11                	jne    8023a6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802395:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80239c:	e8 ae 09 00 00       	call   802d4f <ipc_find_env>
  8023a1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8023a6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8023ad:	00 
  8023ae:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8023b5:	00 
  8023b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023ba:	a1 04 50 80 00       	mov    0x805004,%eax
  8023bf:	89 04 24             	mov    %eax,(%esp)
  8023c2:	e8 21 09 00 00       	call   802ce8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8023c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023ce:	00 
  8023cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023d6:	00 
  8023d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023de:	e8 9d 08 00 00       	call   802c80 <ipc_recv>
}
  8023e3:	83 c4 14             	add    $0x14,%esp
  8023e6:	5b                   	pop    %ebx
  8023e7:	5d                   	pop    %ebp
  8023e8:	c3                   	ret    

008023e9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
  8023ec:	56                   	push   %esi
  8023ed:	53                   	push   %ebx
  8023ee:	83 ec 10             	sub    $0x10,%esp
  8023f1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8023fc:	8b 06                	mov    (%esi),%eax
  8023fe:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802403:	b8 01 00 00 00       	mov    $0x1,%eax
  802408:	e8 76 ff ff ff       	call   802383 <nsipc>
  80240d:	89 c3                	mov    %eax,%ebx
  80240f:	85 c0                	test   %eax,%eax
  802411:	78 23                	js     802436 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802413:	a1 10 70 80 00       	mov    0x807010,%eax
  802418:	89 44 24 08          	mov    %eax,0x8(%esp)
  80241c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802423:	00 
  802424:	8b 45 0c             	mov    0xc(%ebp),%eax
  802427:	89 04 24             	mov    %eax,(%esp)
  80242a:	e8 55 e8 ff ff       	call   800c84 <memmove>
		*addrlen = ret->ret_addrlen;
  80242f:	a1 10 70 80 00       	mov    0x807010,%eax
  802434:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802436:	89 d8                	mov    %ebx,%eax
  802438:	83 c4 10             	add    $0x10,%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5d                   	pop    %ebp
  80243e:	c3                   	ret    

0080243f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
  802442:	53                   	push   %ebx
  802443:	83 ec 14             	sub    $0x14,%esp
  802446:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802451:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802455:	8b 45 0c             	mov    0xc(%ebp),%eax
  802458:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802463:	e8 1c e8 ff ff       	call   800c84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802468:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80246e:	b8 02 00 00 00       	mov    $0x2,%eax
  802473:	e8 0b ff ff ff       	call   802383 <nsipc>
}
  802478:	83 c4 14             	add    $0x14,%esp
  80247b:	5b                   	pop    %ebx
  80247c:	5d                   	pop    %ebp
  80247d:	c3                   	ret    

0080247e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80248c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802494:	b8 03 00 00 00       	mov    $0x3,%eax
  802499:	e8 e5 fe ff ff       	call   802383 <nsipc>
}
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <nsipc_close>:

int
nsipc_close(int s)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8024ae:	b8 04 00 00 00       	mov    $0x4,%eax
  8024b3:	e8 cb fe ff ff       	call   802383 <nsipc>
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	53                   	push   %ebx
  8024be:	83 ec 14             	sub    $0x14,%esp
  8024c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8024cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8024de:	e8 a1 e7 ff ff       	call   800c84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8024e3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8024e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8024ee:	e8 90 fe ff ff       	call   802383 <nsipc>
}
  8024f3:	83 c4 14             	add    $0x14,%esp
  8024f6:	5b                   	pop    %ebx
  8024f7:	5d                   	pop    %ebp
  8024f8:	c3                   	ret    

008024f9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8024ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802502:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80250f:	b8 06 00 00 00       	mov    $0x6,%eax
  802514:	e8 6a fe ff ff       	call   802383 <nsipc>
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	56                   	push   %esi
  80251f:	53                   	push   %ebx
  802520:	83 ec 10             	sub    $0x10,%esp
  802523:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80252e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802534:	8b 45 14             	mov    0x14(%ebp),%eax
  802537:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80253c:	b8 07 00 00 00       	mov    $0x7,%eax
  802541:	e8 3d fe ff ff       	call   802383 <nsipc>
  802546:	89 c3                	mov    %eax,%ebx
  802548:	85 c0                	test   %eax,%eax
  80254a:	78 46                	js     802592 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80254c:	39 f0                	cmp    %esi,%eax
  80254e:	7f 07                	jg     802557 <nsipc_recv+0x3c>
  802550:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802555:	7e 24                	jle    80257b <nsipc_recv+0x60>
  802557:	c7 44 24 0c d9 36 80 	movl   $0x8036d9,0xc(%esp)
  80255e:	00 
  80255f:	c7 44 24 08 88 36 80 	movl   $0x803688,0x8(%esp)
  802566:	00 
  802567:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80256e:	00 
  80256f:	c7 04 24 ee 36 80 00 	movl   $0x8036ee,(%esp)
  802576:	e8 fb dd ff ff       	call   800376 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80257b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80257f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802586:	00 
  802587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80258a:	89 04 24             	mov    %eax,(%esp)
  80258d:	e8 f2 e6 ff ff       	call   800c84 <memmove>
	}

	return r;
}
  802592:	89 d8                	mov    %ebx,%eax
  802594:	83 c4 10             	add    $0x10,%esp
  802597:	5b                   	pop    %ebx
  802598:	5e                   	pop    %esi
  802599:	5d                   	pop    %ebp
  80259a:	c3                   	ret    

0080259b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	53                   	push   %ebx
  80259f:	83 ec 14             	sub    $0x14,%esp
  8025a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8025ad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8025b3:	7e 24                	jle    8025d9 <nsipc_send+0x3e>
  8025b5:	c7 44 24 0c fa 36 80 	movl   $0x8036fa,0xc(%esp)
  8025bc:	00 
  8025bd:	c7 44 24 08 88 36 80 	movl   $0x803688,0x8(%esp)
  8025c4:	00 
  8025c5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8025cc:	00 
  8025cd:	c7 04 24 ee 36 80 00 	movl   $0x8036ee,(%esp)
  8025d4:	e8 9d dd ff ff       	call   800376 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8025d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8025eb:	e8 94 e6 ff ff       	call   800c84 <memmove>
	nsipcbuf.send.req_size = size;
  8025f0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8025f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8025f9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8025fe:	b8 08 00 00 00       	mov    $0x8,%eax
  802603:	e8 7b fd ff ff       	call   802383 <nsipc>
}
  802608:	83 c4 14             	add    $0x14,%esp
  80260b:	5b                   	pop    %ebx
  80260c:	5d                   	pop    %ebp
  80260d:	c3                   	ret    

0080260e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
  802611:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80261c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80261f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802624:	8b 45 10             	mov    0x10(%ebp),%eax
  802627:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80262c:	b8 09 00 00 00       	mov    $0x9,%eax
  802631:	e8 4d fd ff ff       	call   802383 <nsipc>
}
  802636:	c9                   	leave  
  802637:	c3                   	ret    

00802638 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
  80263b:	56                   	push   %esi
  80263c:	53                   	push   %ebx
  80263d:	83 ec 10             	sub    $0x10,%esp
  802640:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	89 04 24             	mov    %eax,(%esp)
  802649:	e8 d2 f1 ff ff       	call   801820 <fd2data>
  80264e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802650:	c7 44 24 04 06 37 80 	movl   $0x803706,0x4(%esp)
  802657:	00 
  802658:	89 1c 24             	mov    %ebx,(%esp)
  80265b:	e8 87 e4 ff ff       	call   800ae7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802660:	8b 46 04             	mov    0x4(%esi),%eax
  802663:	2b 06                	sub    (%esi),%eax
  802665:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80266b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802672:	00 00 00 
	stat->st_dev = &devpipe;
  802675:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80267c:	40 80 00 
	return 0;
}
  80267f:	b8 00 00 00 00       	mov    $0x0,%eax
  802684:	83 c4 10             	add    $0x10,%esp
  802687:	5b                   	pop    %ebx
  802688:	5e                   	pop    %esi
  802689:	5d                   	pop    %ebp
  80268a:	c3                   	ret    

0080268b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
  80268e:	53                   	push   %ebx
  80268f:	83 ec 14             	sub    $0x14,%esp
  802692:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802695:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802699:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a0:	e8 57 e9 ff ff       	call   800ffc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026a5:	89 1c 24             	mov    %ebx,(%esp)
  8026a8:	e8 73 f1 ff ff       	call   801820 <fd2data>
  8026ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b8:	e8 3f e9 ff ff       	call   800ffc <sys_page_unmap>
}
  8026bd:	83 c4 14             	add    $0x14,%esp
  8026c0:	5b                   	pop    %ebx
  8026c1:	5d                   	pop    %ebp
  8026c2:	c3                   	ret    

008026c3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
  8026c6:	57                   	push   %edi
  8026c7:	56                   	push   %esi
  8026c8:	53                   	push   %ebx
  8026c9:	83 ec 2c             	sub    $0x2c,%esp
  8026cc:	89 c6                	mov    %eax,%esi
  8026ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8026d1:	a1 08 50 80 00       	mov    0x805008,%eax
  8026d6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026d9:	89 34 24             	mov    %esi,(%esp)
  8026dc:	e8 a6 06 00 00       	call   802d87 <pageref>
  8026e1:	89 c7                	mov    %eax,%edi
  8026e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e6:	89 04 24             	mov    %eax,(%esp)
  8026e9:	e8 99 06 00 00       	call   802d87 <pageref>
  8026ee:	39 c7                	cmp    %eax,%edi
  8026f0:	0f 94 c2             	sete   %dl
  8026f3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8026f6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8026fc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8026ff:	39 fb                	cmp    %edi,%ebx
  802701:	74 21                	je     802724 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802703:	84 d2                	test   %dl,%dl
  802705:	74 ca                	je     8026d1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802707:	8b 51 58             	mov    0x58(%ecx),%edx
  80270a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80270e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802712:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802716:	c7 04 24 0d 37 80 00 	movl   $0x80370d,(%esp)
  80271d:	e8 4d dd ff ff       	call   80046f <cprintf>
  802722:	eb ad                	jmp    8026d1 <_pipeisclosed+0xe>
	}
}
  802724:	83 c4 2c             	add    $0x2c,%esp
  802727:	5b                   	pop    %ebx
  802728:	5e                   	pop    %esi
  802729:	5f                   	pop    %edi
  80272a:	5d                   	pop    %ebp
  80272b:	c3                   	ret    

0080272c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	57                   	push   %edi
  802730:	56                   	push   %esi
  802731:	53                   	push   %ebx
  802732:	83 ec 1c             	sub    $0x1c,%esp
  802735:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802738:	89 34 24             	mov    %esi,(%esp)
  80273b:	e8 e0 f0 ff ff       	call   801820 <fd2data>
  802740:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802742:	bf 00 00 00 00       	mov    $0x0,%edi
  802747:	eb 45                	jmp    80278e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802749:	89 da                	mov    %ebx,%edx
  80274b:	89 f0                	mov    %esi,%eax
  80274d:	e8 71 ff ff ff       	call   8026c3 <_pipeisclosed>
  802752:	85 c0                	test   %eax,%eax
  802754:	75 41                	jne    802797 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802756:	e8 db e7 ff ff       	call   800f36 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80275b:	8b 43 04             	mov    0x4(%ebx),%eax
  80275e:	8b 0b                	mov    (%ebx),%ecx
  802760:	8d 51 20             	lea    0x20(%ecx),%edx
  802763:	39 d0                	cmp    %edx,%eax
  802765:	73 e2                	jae    802749 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802767:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80276a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80276e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802771:	99                   	cltd   
  802772:	c1 ea 1b             	shr    $0x1b,%edx
  802775:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802778:	83 e1 1f             	and    $0x1f,%ecx
  80277b:	29 d1                	sub    %edx,%ecx
  80277d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802781:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802785:	83 c0 01             	add    $0x1,%eax
  802788:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80278b:	83 c7 01             	add    $0x1,%edi
  80278e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802791:	75 c8                	jne    80275b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802793:	89 f8                	mov    %edi,%eax
  802795:	eb 05                	jmp    80279c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802797:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80279c:	83 c4 1c             	add    $0x1c,%esp
  80279f:	5b                   	pop    %ebx
  8027a0:	5e                   	pop    %esi
  8027a1:	5f                   	pop    %edi
  8027a2:	5d                   	pop    %ebp
  8027a3:	c3                   	ret    

008027a4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
  8027a7:	57                   	push   %edi
  8027a8:	56                   	push   %esi
  8027a9:	53                   	push   %ebx
  8027aa:	83 ec 1c             	sub    $0x1c,%esp
  8027ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8027b0:	89 3c 24             	mov    %edi,(%esp)
  8027b3:	e8 68 f0 ff ff       	call   801820 <fd2data>
  8027b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027ba:	be 00 00 00 00       	mov    $0x0,%esi
  8027bf:	eb 3d                	jmp    8027fe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8027c1:	85 f6                	test   %esi,%esi
  8027c3:	74 04                	je     8027c9 <devpipe_read+0x25>
				return i;
  8027c5:	89 f0                	mov    %esi,%eax
  8027c7:	eb 43                	jmp    80280c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8027c9:	89 da                	mov    %ebx,%edx
  8027cb:	89 f8                	mov    %edi,%eax
  8027cd:	e8 f1 fe ff ff       	call   8026c3 <_pipeisclosed>
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	75 31                	jne    802807 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8027d6:	e8 5b e7 ff ff       	call   800f36 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8027db:	8b 03                	mov    (%ebx),%eax
  8027dd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027e0:	74 df                	je     8027c1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027e2:	99                   	cltd   
  8027e3:	c1 ea 1b             	shr    $0x1b,%edx
  8027e6:	01 d0                	add    %edx,%eax
  8027e8:	83 e0 1f             	and    $0x1f,%eax
  8027eb:	29 d0                	sub    %edx,%eax
  8027ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8027f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8027f8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027fb:	83 c6 01             	add    $0x1,%esi
  8027fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  802801:	75 d8                	jne    8027db <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802803:	89 f0                	mov    %esi,%eax
  802805:	eb 05                	jmp    80280c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802807:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80280c:	83 c4 1c             	add    $0x1c,%esp
  80280f:	5b                   	pop    %ebx
  802810:	5e                   	pop    %esi
  802811:	5f                   	pop    %edi
  802812:	5d                   	pop    %ebp
  802813:	c3                   	ret    

00802814 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	56                   	push   %esi
  802818:	53                   	push   %ebx
  802819:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80281c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80281f:	89 04 24             	mov    %eax,(%esp)
  802822:	e8 10 f0 ff ff       	call   801837 <fd_alloc>
  802827:	89 c2                	mov    %eax,%edx
  802829:	85 d2                	test   %edx,%edx
  80282b:	0f 88 4d 01 00 00    	js     80297e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802831:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802838:	00 
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802840:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802847:	e8 09 e7 ff ff       	call   800f55 <sys_page_alloc>
  80284c:	89 c2                	mov    %eax,%edx
  80284e:	85 d2                	test   %edx,%edx
  802850:	0f 88 28 01 00 00    	js     80297e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802856:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802859:	89 04 24             	mov    %eax,(%esp)
  80285c:	e8 d6 ef ff ff       	call   801837 <fd_alloc>
  802861:	89 c3                	mov    %eax,%ebx
  802863:	85 c0                	test   %eax,%eax
  802865:	0f 88 fe 00 00 00    	js     802969 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80286b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802872:	00 
  802873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802876:	89 44 24 04          	mov    %eax,0x4(%esp)
  80287a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802881:	e8 cf e6 ff ff       	call   800f55 <sys_page_alloc>
  802886:	89 c3                	mov    %eax,%ebx
  802888:	85 c0                	test   %eax,%eax
  80288a:	0f 88 d9 00 00 00    	js     802969 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	89 04 24             	mov    %eax,(%esp)
  802896:	e8 85 ef ff ff       	call   801820 <fd2data>
  80289b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80289d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028a4:	00 
  8028a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028b0:	e8 a0 e6 ff ff       	call   800f55 <sys_page_alloc>
  8028b5:	89 c3                	mov    %eax,%ebx
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	0f 88 97 00 00 00    	js     802956 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c2:	89 04 24             	mov    %eax,(%esp)
  8028c5:	e8 56 ef ff ff       	call   801820 <fd2data>
  8028ca:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8028d1:	00 
  8028d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8028dd:	00 
  8028de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028e9:	e8 bb e6 ff ff       	call   800fa9 <sys_page_map>
  8028ee:	89 c3                	mov    %eax,%ebx
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	78 52                	js     802946 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8028f4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802909:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802917:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	89 04 24             	mov    %eax,(%esp)
  802924:	e8 e7 ee ff ff       	call   801810 <fd2num>
  802929:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80292c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80292e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802931:	89 04 24             	mov    %eax,(%esp)
  802934:	e8 d7 ee ff ff       	call   801810 <fd2num>
  802939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80293c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80293f:	b8 00 00 00 00       	mov    $0x0,%eax
  802944:	eb 38                	jmp    80297e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802946:	89 74 24 04          	mov    %esi,0x4(%esp)
  80294a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802951:	e8 a6 e6 ff ff       	call   800ffc <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802959:	89 44 24 04          	mov    %eax,0x4(%esp)
  80295d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802964:	e8 93 e6 ff ff       	call   800ffc <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802970:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802977:	e8 80 e6 ff ff       	call   800ffc <sys_page_unmap>
  80297c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80297e:	83 c4 30             	add    $0x30,%esp
  802981:	5b                   	pop    %ebx
  802982:	5e                   	pop    %esi
  802983:	5d                   	pop    %ebp
  802984:	c3                   	ret    

00802985 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802985:	55                   	push   %ebp
  802986:	89 e5                	mov    %esp,%ebp
  802988:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80298b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80298e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	89 04 24             	mov    %eax,(%esp)
  802998:	e8 e9 ee ff ff       	call   801886 <fd_lookup>
  80299d:	89 c2                	mov    %eax,%edx
  80299f:	85 d2                	test   %edx,%edx
  8029a1:	78 15                	js     8029b8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	89 04 24             	mov    %eax,(%esp)
  8029a9:	e8 72 ee ff ff       	call   801820 <fd2data>
	return _pipeisclosed(fd, p);
  8029ae:	89 c2                	mov    %eax,%edx
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	e8 0b fd ff ff       	call   8026c3 <_pipeisclosed>
}
  8029b8:	c9                   	leave  
  8029b9:	c3                   	ret    

008029ba <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	56                   	push   %esi
  8029be:	53                   	push   %ebx
  8029bf:	83 ec 10             	sub    $0x10,%esp
  8029c2:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8029c5:	85 f6                	test   %esi,%esi
  8029c7:	75 24                	jne    8029ed <wait+0x33>
  8029c9:	c7 44 24 0c 25 37 80 	movl   $0x803725,0xc(%esp)
  8029d0:	00 
  8029d1:	c7 44 24 08 88 36 80 	movl   $0x803688,0x8(%esp)
  8029d8:	00 
  8029d9:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8029e0:	00 
  8029e1:	c7 04 24 30 37 80 00 	movl   $0x803730,(%esp)
  8029e8:	e8 89 d9 ff ff       	call   800376 <_panic>
	e = &envs[ENVX(envid)];
  8029ed:	89 f3                	mov    %esi,%ebx
  8029ef:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8029f5:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8029f8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8029fe:	eb 05                	jmp    802a05 <wait+0x4b>
		sys_yield();
  802a00:	e8 31 e5 ff ff       	call   800f36 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a05:	8b 43 48             	mov    0x48(%ebx),%eax
  802a08:	39 f0                	cmp    %esi,%eax
  802a0a:	75 07                	jne    802a13 <wait+0x59>
  802a0c:	8b 43 54             	mov    0x54(%ebx),%eax
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	75 ed                	jne    802a00 <wait+0x46>
		sys_yield();
}
  802a13:	83 c4 10             	add    $0x10,%esp
  802a16:	5b                   	pop    %ebx
  802a17:	5e                   	pop    %esi
  802a18:	5d                   	pop    %ebp
  802a19:	c3                   	ret    
  802a1a:	66 90                	xchg   %ax,%ax
  802a1c:	66 90                	xchg   %ax,%ax
  802a1e:	66 90                	xchg   %ax,%ax

00802a20 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802a20:	55                   	push   %ebp
  802a21:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802a23:	b8 00 00 00 00       	mov    $0x0,%eax
  802a28:	5d                   	pop    %ebp
  802a29:	c3                   	ret    

00802a2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802a2a:	55                   	push   %ebp
  802a2b:	89 e5                	mov    %esp,%ebp
  802a2d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802a30:	c7 44 24 04 3b 37 80 	movl   $0x80373b,0x4(%esp)
  802a37:	00 
  802a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a3b:	89 04 24             	mov    %eax,(%esp)
  802a3e:	e8 a4 e0 ff ff       	call   800ae7 <strcpy>
	return 0;
}
  802a43:	b8 00 00 00 00       	mov    $0x0,%eax
  802a48:	c9                   	leave  
  802a49:	c3                   	ret    

00802a4a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a4a:	55                   	push   %ebp
  802a4b:	89 e5                	mov    %esp,%ebp
  802a4d:	57                   	push   %edi
  802a4e:	56                   	push   %esi
  802a4f:	53                   	push   %ebx
  802a50:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a56:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a5b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a61:	eb 31                	jmp    802a94 <devcons_write+0x4a>
		m = n - tot;
  802a63:	8b 75 10             	mov    0x10(%ebp),%esi
  802a66:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802a68:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802a6b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802a70:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a73:	89 74 24 08          	mov    %esi,0x8(%esp)
  802a77:	03 45 0c             	add    0xc(%ebp),%eax
  802a7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a7e:	89 3c 24             	mov    %edi,(%esp)
  802a81:	e8 fe e1 ff ff       	call   800c84 <memmove>
		sys_cputs(buf, m);
  802a86:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a8a:	89 3c 24             	mov    %edi,(%esp)
  802a8d:	e8 a4 e3 ff ff       	call   800e36 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a92:	01 f3                	add    %esi,%ebx
  802a94:	89 d8                	mov    %ebx,%eax
  802a96:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802a99:	72 c8                	jb     802a63 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802a9b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802aa1:	5b                   	pop    %ebx
  802aa2:	5e                   	pop    %esi
  802aa3:	5f                   	pop    %edi
  802aa4:	5d                   	pop    %ebp
  802aa5:	c3                   	ret    

00802aa6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802aa6:	55                   	push   %ebp
  802aa7:	89 e5                	mov    %esp,%ebp
  802aa9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802aac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802ab1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802ab5:	75 07                	jne    802abe <devcons_read+0x18>
  802ab7:	eb 2a                	jmp    802ae3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802ab9:	e8 78 e4 ff ff       	call   800f36 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802abe:	66 90                	xchg   %ax,%ax
  802ac0:	e8 8f e3 ff ff       	call   800e54 <sys_cgetc>
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	74 f0                	je     802ab9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	78 16                	js     802ae3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802acd:	83 f8 04             	cmp    $0x4,%eax
  802ad0:	74 0c                	je     802ade <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ad5:	88 02                	mov    %al,(%edx)
	return 1;
  802ad7:	b8 01 00 00 00       	mov    $0x1,%eax
  802adc:	eb 05                	jmp    802ae3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802ade:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802ae3:	c9                   	leave  
  802ae4:	c3                   	ret    

00802ae5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802ae5:	55                   	push   %ebp
  802ae6:	89 e5                	mov    %esp,%ebp
  802ae8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802af1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802af8:	00 
  802af9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802afc:	89 04 24             	mov    %eax,(%esp)
  802aff:	e8 32 e3 ff ff       	call   800e36 <sys_cputs>
}
  802b04:	c9                   	leave  
  802b05:	c3                   	ret    

00802b06 <getchar>:

int
getchar(void)
{
  802b06:	55                   	push   %ebp
  802b07:	89 e5                	mov    %esp,%ebp
  802b09:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802b0c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802b13:	00 
  802b14:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b17:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b22:	e8 f3 ef ff ff       	call   801b1a <read>
	if (r < 0)
  802b27:	85 c0                	test   %eax,%eax
  802b29:	78 0f                	js     802b3a <getchar+0x34>
		return r;
	if (r < 1)
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	7e 06                	jle    802b35 <getchar+0x2f>
		return -E_EOF;
	return c;
  802b2f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802b33:	eb 05                	jmp    802b3a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802b35:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802b3a:	c9                   	leave  
  802b3b:	c3                   	ret    

00802b3c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802b3c:	55                   	push   %ebp
  802b3d:	89 e5                	mov    %esp,%ebp
  802b3f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b45:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b49:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4c:	89 04 24             	mov    %eax,(%esp)
  802b4f:	e8 32 ed ff ff       	call   801886 <fd_lookup>
  802b54:	85 c0                	test   %eax,%eax
  802b56:	78 11                	js     802b69 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802b61:	39 10                	cmp    %edx,(%eax)
  802b63:	0f 94 c0             	sete   %al
  802b66:	0f b6 c0             	movzbl %al,%eax
}
  802b69:	c9                   	leave  
  802b6a:	c3                   	ret    

00802b6b <opencons>:

int
opencons(void)
{
  802b6b:	55                   	push   %ebp
  802b6c:	89 e5                	mov    %esp,%ebp
  802b6e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802b71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b74:	89 04 24             	mov    %eax,(%esp)
  802b77:	e8 bb ec ff ff       	call   801837 <fd_alloc>
		return r;
  802b7c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	78 40                	js     802bc2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b82:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b89:	00 
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b98:	e8 b8 e3 ff ff       	call   800f55 <sys_page_alloc>
		return r;
  802b9d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	78 1f                	js     802bc2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802ba3:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802bb8:	89 04 24             	mov    %eax,(%esp)
  802bbb:	e8 50 ec ff ff       	call   801810 <fd2num>
  802bc0:	89 c2                	mov    %eax,%edx
}
  802bc2:	89 d0                	mov    %edx,%eax
  802bc4:	c9                   	leave  
  802bc5:	c3                   	ret    

00802bc6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802bc6:	55                   	push   %ebp
  802bc7:	89 e5                	mov    %esp,%ebp
  802bc9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802bcc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802bd3:	75 7a                	jne    802c4f <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802bd5:	e8 3d e3 ff ff       	call   800f17 <sys_getenvid>
  802bda:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802be1:	00 
  802be2:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802be9:	ee 
  802bea:	89 04 24             	mov    %eax,(%esp)
  802bed:	e8 63 e3 ff ff       	call   800f55 <sys_page_alloc>
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	79 20                	jns    802c16 <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802bf6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bfa:	c7 44 24 08 49 35 80 	movl   $0x803549,0x8(%esp)
  802c01:	00 
  802c02:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802c09:	00 
  802c0a:	c7 04 24 47 37 80 00 	movl   $0x803747,(%esp)
  802c11:	e8 60 d7 ff ff       	call   800376 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802c16:	e8 fc e2 ff ff       	call   800f17 <sys_getenvid>
  802c1b:	c7 44 24 04 59 2c 80 	movl   $0x802c59,0x4(%esp)
  802c22:	00 
  802c23:	89 04 24             	mov    %eax,(%esp)
  802c26:	e8 ea e4 ff ff       	call   801115 <sys_env_set_pgfault_upcall>
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	79 20                	jns    802c4f <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802c2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c33:	c7 44 24 08 c8 35 80 	movl   $0x8035c8,0x8(%esp)
  802c3a:	00 
  802c3b:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802c42:	00 
  802c43:	c7 04 24 47 37 80 00 	movl   $0x803747,(%esp)
  802c4a:	e8 27 d7 ff ff       	call   800376 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802c57:	c9                   	leave  
  802c58:	c3                   	ret    

00802c59 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802c59:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802c5a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802c5f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802c61:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802c64:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802c68:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802c6c:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802c6f:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802c73:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802c75:	83 c4 08             	add    $0x8,%esp
	popal
  802c78:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802c79:	83 c4 04             	add    $0x4,%esp
	popfl
  802c7c:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802c7d:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802c7e:	c3                   	ret    
  802c7f:	90                   	nop

00802c80 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c80:	55                   	push   %ebp
  802c81:	89 e5                	mov    %esp,%ebp
  802c83:	56                   	push   %esi
  802c84:	53                   	push   %ebx
  802c85:	83 ec 10             	sub    $0x10,%esp
  802c88:	8b 75 08             	mov    0x8(%ebp),%esi
  802c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802c91:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802c93:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802c98:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802c9b:	89 04 24             	mov    %eax,(%esp)
  802c9e:	e8 e8 e4 ff ff       	call   80118b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	75 26                	jne    802ccd <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802ca7:	85 f6                	test   %esi,%esi
  802ca9:	74 0a                	je     802cb5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802cab:	a1 08 50 80 00       	mov    0x805008,%eax
  802cb0:	8b 40 74             	mov    0x74(%eax),%eax
  802cb3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802cb5:	85 db                	test   %ebx,%ebx
  802cb7:	74 0a                	je     802cc3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802cb9:	a1 08 50 80 00       	mov    0x805008,%eax
  802cbe:	8b 40 78             	mov    0x78(%eax),%eax
  802cc1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802cc3:	a1 08 50 80 00       	mov    0x805008,%eax
  802cc8:	8b 40 70             	mov    0x70(%eax),%eax
  802ccb:	eb 14                	jmp    802ce1 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  802ccd:	85 f6                	test   %esi,%esi
  802ccf:	74 06                	je     802cd7 <ipc_recv+0x57>
			*from_env_store = 0;
  802cd1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802cd7:	85 db                	test   %ebx,%ebx
  802cd9:	74 06                	je     802ce1 <ipc_recv+0x61>
			*perm_store = 0;
  802cdb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802ce1:	83 c4 10             	add    $0x10,%esp
  802ce4:	5b                   	pop    %ebx
  802ce5:	5e                   	pop    %esi
  802ce6:	5d                   	pop    %ebp
  802ce7:	c3                   	ret    

00802ce8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
  802ceb:	57                   	push   %edi
  802cec:	56                   	push   %esi
  802ced:	53                   	push   %ebx
  802cee:	83 ec 1c             	sub    $0x1c,%esp
  802cf1:	8b 7d 08             	mov    0x8(%ebp),%edi
  802cf4:	8b 75 0c             	mov    0xc(%ebp),%esi
  802cf7:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  802cfa:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  802cfc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802d01:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802d04:	8b 45 14             	mov    0x14(%ebp),%eax
  802d07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d13:	89 3c 24             	mov    %edi,(%esp)
  802d16:	e8 4d e4 ff ff       	call   801168 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	74 28                	je     802d47 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802d1f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d22:	74 1c                	je     802d40 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802d24:	c7 44 24 08 58 37 80 	movl   $0x803758,0x8(%esp)
  802d2b:	00 
  802d2c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802d33:	00 
  802d34:	c7 04 24 7c 37 80 00 	movl   $0x80377c,(%esp)
  802d3b:	e8 36 d6 ff ff       	call   800376 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802d40:	e8 f1 e1 ff ff       	call   800f36 <sys_yield>
	}
  802d45:	eb bd                	jmp    802d04 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802d47:	83 c4 1c             	add    $0x1c,%esp
  802d4a:	5b                   	pop    %ebx
  802d4b:	5e                   	pop    %esi
  802d4c:	5f                   	pop    %edi
  802d4d:	5d                   	pop    %ebp
  802d4e:	c3                   	ret    

00802d4f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802d4f:	55                   	push   %ebp
  802d50:	89 e5                	mov    %esp,%ebp
  802d52:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802d55:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802d5a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802d5d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802d63:	8b 52 50             	mov    0x50(%edx),%edx
  802d66:	39 ca                	cmp    %ecx,%edx
  802d68:	75 0d                	jne    802d77 <ipc_find_env+0x28>
			return envs[i].env_id;
  802d6a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802d6d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802d72:	8b 40 40             	mov    0x40(%eax),%eax
  802d75:	eb 0e                	jmp    802d85 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802d77:	83 c0 01             	add    $0x1,%eax
  802d7a:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d7f:	75 d9                	jne    802d5a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802d81:	66 b8 00 00          	mov    $0x0,%ax
}
  802d85:	5d                   	pop    %ebp
  802d86:	c3                   	ret    

00802d87 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d87:	55                   	push   %ebp
  802d88:	89 e5                	mov    %esp,%ebp
  802d8a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d8d:	89 d0                	mov    %edx,%eax
  802d8f:	c1 e8 16             	shr    $0x16,%eax
  802d92:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802d99:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802d9e:	f6 c1 01             	test   $0x1,%cl
  802da1:	74 1d                	je     802dc0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802da3:	c1 ea 0c             	shr    $0xc,%edx
  802da6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802dad:	f6 c2 01             	test   $0x1,%dl
  802db0:	74 0e                	je     802dc0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802db2:	c1 ea 0c             	shr    $0xc,%edx
  802db5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802dbc:	ef 
  802dbd:	0f b7 c0             	movzwl %ax,%eax
}
  802dc0:	5d                   	pop    %ebp
  802dc1:	c3                   	ret    
  802dc2:	66 90                	xchg   %ax,%ax
  802dc4:	66 90                	xchg   %ax,%ax
  802dc6:	66 90                	xchg   %ax,%ax
  802dc8:	66 90                	xchg   %ax,%ax
  802dca:	66 90                	xchg   %ax,%ax
  802dcc:	66 90                	xchg   %ax,%ax
  802dce:	66 90                	xchg   %ax,%ax

00802dd0 <__udivdi3>:
  802dd0:	55                   	push   %ebp
  802dd1:	57                   	push   %edi
  802dd2:	56                   	push   %esi
  802dd3:	83 ec 0c             	sub    $0xc,%esp
  802dd6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802dda:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802dde:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802de2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802de6:	85 c0                	test   %eax,%eax
  802de8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802dec:	89 ea                	mov    %ebp,%edx
  802dee:	89 0c 24             	mov    %ecx,(%esp)
  802df1:	75 2d                	jne    802e20 <__udivdi3+0x50>
  802df3:	39 e9                	cmp    %ebp,%ecx
  802df5:	77 61                	ja     802e58 <__udivdi3+0x88>
  802df7:	85 c9                	test   %ecx,%ecx
  802df9:	89 ce                	mov    %ecx,%esi
  802dfb:	75 0b                	jne    802e08 <__udivdi3+0x38>
  802dfd:	b8 01 00 00 00       	mov    $0x1,%eax
  802e02:	31 d2                	xor    %edx,%edx
  802e04:	f7 f1                	div    %ecx
  802e06:	89 c6                	mov    %eax,%esi
  802e08:	31 d2                	xor    %edx,%edx
  802e0a:	89 e8                	mov    %ebp,%eax
  802e0c:	f7 f6                	div    %esi
  802e0e:	89 c5                	mov    %eax,%ebp
  802e10:	89 f8                	mov    %edi,%eax
  802e12:	f7 f6                	div    %esi
  802e14:	89 ea                	mov    %ebp,%edx
  802e16:	83 c4 0c             	add    $0xc,%esp
  802e19:	5e                   	pop    %esi
  802e1a:	5f                   	pop    %edi
  802e1b:	5d                   	pop    %ebp
  802e1c:	c3                   	ret    
  802e1d:	8d 76 00             	lea    0x0(%esi),%esi
  802e20:	39 e8                	cmp    %ebp,%eax
  802e22:	77 24                	ja     802e48 <__udivdi3+0x78>
  802e24:	0f bd e8             	bsr    %eax,%ebp
  802e27:	83 f5 1f             	xor    $0x1f,%ebp
  802e2a:	75 3c                	jne    802e68 <__udivdi3+0x98>
  802e2c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802e30:	39 34 24             	cmp    %esi,(%esp)
  802e33:	0f 86 9f 00 00 00    	jbe    802ed8 <__udivdi3+0x108>
  802e39:	39 d0                	cmp    %edx,%eax
  802e3b:	0f 82 97 00 00 00    	jb     802ed8 <__udivdi3+0x108>
  802e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e48:	31 d2                	xor    %edx,%edx
  802e4a:	31 c0                	xor    %eax,%eax
  802e4c:	83 c4 0c             	add    $0xc,%esp
  802e4f:	5e                   	pop    %esi
  802e50:	5f                   	pop    %edi
  802e51:	5d                   	pop    %ebp
  802e52:	c3                   	ret    
  802e53:	90                   	nop
  802e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e58:	89 f8                	mov    %edi,%eax
  802e5a:	f7 f1                	div    %ecx
  802e5c:	31 d2                	xor    %edx,%edx
  802e5e:	83 c4 0c             	add    $0xc,%esp
  802e61:	5e                   	pop    %esi
  802e62:	5f                   	pop    %edi
  802e63:	5d                   	pop    %ebp
  802e64:	c3                   	ret    
  802e65:	8d 76 00             	lea    0x0(%esi),%esi
  802e68:	89 e9                	mov    %ebp,%ecx
  802e6a:	8b 3c 24             	mov    (%esp),%edi
  802e6d:	d3 e0                	shl    %cl,%eax
  802e6f:	89 c6                	mov    %eax,%esi
  802e71:	b8 20 00 00 00       	mov    $0x20,%eax
  802e76:	29 e8                	sub    %ebp,%eax
  802e78:	89 c1                	mov    %eax,%ecx
  802e7a:	d3 ef                	shr    %cl,%edi
  802e7c:	89 e9                	mov    %ebp,%ecx
  802e7e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802e82:	8b 3c 24             	mov    (%esp),%edi
  802e85:	09 74 24 08          	or     %esi,0x8(%esp)
  802e89:	89 d6                	mov    %edx,%esi
  802e8b:	d3 e7                	shl    %cl,%edi
  802e8d:	89 c1                	mov    %eax,%ecx
  802e8f:	89 3c 24             	mov    %edi,(%esp)
  802e92:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802e96:	d3 ee                	shr    %cl,%esi
  802e98:	89 e9                	mov    %ebp,%ecx
  802e9a:	d3 e2                	shl    %cl,%edx
  802e9c:	89 c1                	mov    %eax,%ecx
  802e9e:	d3 ef                	shr    %cl,%edi
  802ea0:	09 d7                	or     %edx,%edi
  802ea2:	89 f2                	mov    %esi,%edx
  802ea4:	89 f8                	mov    %edi,%eax
  802ea6:	f7 74 24 08          	divl   0x8(%esp)
  802eaa:	89 d6                	mov    %edx,%esi
  802eac:	89 c7                	mov    %eax,%edi
  802eae:	f7 24 24             	mull   (%esp)
  802eb1:	39 d6                	cmp    %edx,%esi
  802eb3:	89 14 24             	mov    %edx,(%esp)
  802eb6:	72 30                	jb     802ee8 <__udivdi3+0x118>
  802eb8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ebc:	89 e9                	mov    %ebp,%ecx
  802ebe:	d3 e2                	shl    %cl,%edx
  802ec0:	39 c2                	cmp    %eax,%edx
  802ec2:	73 05                	jae    802ec9 <__udivdi3+0xf9>
  802ec4:	3b 34 24             	cmp    (%esp),%esi
  802ec7:	74 1f                	je     802ee8 <__udivdi3+0x118>
  802ec9:	89 f8                	mov    %edi,%eax
  802ecb:	31 d2                	xor    %edx,%edx
  802ecd:	e9 7a ff ff ff       	jmp    802e4c <__udivdi3+0x7c>
  802ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ed8:	31 d2                	xor    %edx,%edx
  802eda:	b8 01 00 00 00       	mov    $0x1,%eax
  802edf:	e9 68 ff ff ff       	jmp    802e4c <__udivdi3+0x7c>
  802ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ee8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802eeb:	31 d2                	xor    %edx,%edx
  802eed:	83 c4 0c             	add    $0xc,%esp
  802ef0:	5e                   	pop    %esi
  802ef1:	5f                   	pop    %edi
  802ef2:	5d                   	pop    %ebp
  802ef3:	c3                   	ret    
  802ef4:	66 90                	xchg   %ax,%ax
  802ef6:	66 90                	xchg   %ax,%ax
  802ef8:	66 90                	xchg   %ax,%ax
  802efa:	66 90                	xchg   %ax,%ax
  802efc:	66 90                	xchg   %ax,%ax
  802efe:	66 90                	xchg   %ax,%ax

00802f00 <__umoddi3>:
  802f00:	55                   	push   %ebp
  802f01:	57                   	push   %edi
  802f02:	56                   	push   %esi
  802f03:	83 ec 14             	sub    $0x14,%esp
  802f06:	8b 44 24 28          	mov    0x28(%esp),%eax
  802f0a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802f0e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802f12:	89 c7                	mov    %eax,%edi
  802f14:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f18:	8b 44 24 30          	mov    0x30(%esp),%eax
  802f1c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802f20:	89 34 24             	mov    %esi,(%esp)
  802f23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f27:	85 c0                	test   %eax,%eax
  802f29:	89 c2                	mov    %eax,%edx
  802f2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f2f:	75 17                	jne    802f48 <__umoddi3+0x48>
  802f31:	39 fe                	cmp    %edi,%esi
  802f33:	76 4b                	jbe    802f80 <__umoddi3+0x80>
  802f35:	89 c8                	mov    %ecx,%eax
  802f37:	89 fa                	mov    %edi,%edx
  802f39:	f7 f6                	div    %esi
  802f3b:	89 d0                	mov    %edx,%eax
  802f3d:	31 d2                	xor    %edx,%edx
  802f3f:	83 c4 14             	add    $0x14,%esp
  802f42:	5e                   	pop    %esi
  802f43:	5f                   	pop    %edi
  802f44:	5d                   	pop    %ebp
  802f45:	c3                   	ret    
  802f46:	66 90                	xchg   %ax,%ax
  802f48:	39 f8                	cmp    %edi,%eax
  802f4a:	77 54                	ja     802fa0 <__umoddi3+0xa0>
  802f4c:	0f bd e8             	bsr    %eax,%ebp
  802f4f:	83 f5 1f             	xor    $0x1f,%ebp
  802f52:	75 5c                	jne    802fb0 <__umoddi3+0xb0>
  802f54:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802f58:	39 3c 24             	cmp    %edi,(%esp)
  802f5b:	0f 87 e7 00 00 00    	ja     803048 <__umoddi3+0x148>
  802f61:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802f65:	29 f1                	sub    %esi,%ecx
  802f67:	19 c7                	sbb    %eax,%edi
  802f69:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f71:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f75:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802f79:	83 c4 14             	add    $0x14,%esp
  802f7c:	5e                   	pop    %esi
  802f7d:	5f                   	pop    %edi
  802f7e:	5d                   	pop    %ebp
  802f7f:	c3                   	ret    
  802f80:	85 f6                	test   %esi,%esi
  802f82:	89 f5                	mov    %esi,%ebp
  802f84:	75 0b                	jne    802f91 <__umoddi3+0x91>
  802f86:	b8 01 00 00 00       	mov    $0x1,%eax
  802f8b:	31 d2                	xor    %edx,%edx
  802f8d:	f7 f6                	div    %esi
  802f8f:	89 c5                	mov    %eax,%ebp
  802f91:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f95:	31 d2                	xor    %edx,%edx
  802f97:	f7 f5                	div    %ebp
  802f99:	89 c8                	mov    %ecx,%eax
  802f9b:	f7 f5                	div    %ebp
  802f9d:	eb 9c                	jmp    802f3b <__umoddi3+0x3b>
  802f9f:	90                   	nop
  802fa0:	89 c8                	mov    %ecx,%eax
  802fa2:	89 fa                	mov    %edi,%edx
  802fa4:	83 c4 14             	add    $0x14,%esp
  802fa7:	5e                   	pop    %esi
  802fa8:	5f                   	pop    %edi
  802fa9:	5d                   	pop    %ebp
  802faa:	c3                   	ret    
  802fab:	90                   	nop
  802fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fb0:	8b 04 24             	mov    (%esp),%eax
  802fb3:	be 20 00 00 00       	mov    $0x20,%esi
  802fb8:	89 e9                	mov    %ebp,%ecx
  802fba:	29 ee                	sub    %ebp,%esi
  802fbc:	d3 e2                	shl    %cl,%edx
  802fbe:	89 f1                	mov    %esi,%ecx
  802fc0:	d3 e8                	shr    %cl,%eax
  802fc2:	89 e9                	mov    %ebp,%ecx
  802fc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fc8:	8b 04 24             	mov    (%esp),%eax
  802fcb:	09 54 24 04          	or     %edx,0x4(%esp)
  802fcf:	89 fa                	mov    %edi,%edx
  802fd1:	d3 e0                	shl    %cl,%eax
  802fd3:	89 f1                	mov    %esi,%ecx
  802fd5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802fd9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802fdd:	d3 ea                	shr    %cl,%edx
  802fdf:	89 e9                	mov    %ebp,%ecx
  802fe1:	d3 e7                	shl    %cl,%edi
  802fe3:	89 f1                	mov    %esi,%ecx
  802fe5:	d3 e8                	shr    %cl,%eax
  802fe7:	89 e9                	mov    %ebp,%ecx
  802fe9:	09 f8                	or     %edi,%eax
  802feb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802fef:	f7 74 24 04          	divl   0x4(%esp)
  802ff3:	d3 e7                	shl    %cl,%edi
  802ff5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ff9:	89 d7                	mov    %edx,%edi
  802ffb:	f7 64 24 08          	mull   0x8(%esp)
  802fff:	39 d7                	cmp    %edx,%edi
  803001:	89 c1                	mov    %eax,%ecx
  803003:	89 14 24             	mov    %edx,(%esp)
  803006:	72 2c                	jb     803034 <__umoddi3+0x134>
  803008:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80300c:	72 22                	jb     803030 <__umoddi3+0x130>
  80300e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803012:	29 c8                	sub    %ecx,%eax
  803014:	19 d7                	sbb    %edx,%edi
  803016:	89 e9                	mov    %ebp,%ecx
  803018:	89 fa                	mov    %edi,%edx
  80301a:	d3 e8                	shr    %cl,%eax
  80301c:	89 f1                	mov    %esi,%ecx
  80301e:	d3 e2                	shl    %cl,%edx
  803020:	89 e9                	mov    %ebp,%ecx
  803022:	d3 ef                	shr    %cl,%edi
  803024:	09 d0                	or     %edx,%eax
  803026:	89 fa                	mov    %edi,%edx
  803028:	83 c4 14             	add    $0x14,%esp
  80302b:	5e                   	pop    %esi
  80302c:	5f                   	pop    %edi
  80302d:	5d                   	pop    %ebp
  80302e:	c3                   	ret    
  80302f:	90                   	nop
  803030:	39 d7                	cmp    %edx,%edi
  803032:	75 da                	jne    80300e <__umoddi3+0x10e>
  803034:	8b 14 24             	mov    (%esp),%edx
  803037:	89 c1                	mov    %eax,%ecx
  803039:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80303d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803041:	eb cb                	jmp    80300e <__umoddi3+0x10e>
  803043:	90                   	nop
  803044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803048:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80304c:	0f 82 0f ff ff ff    	jb     802f61 <__umoddi3+0x61>
  803052:	e9 1a ff ff ff       	jmp    802f71 <__umoddi3+0x71>
