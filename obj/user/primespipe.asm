
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 8c 02 00 00       	call   8002bd <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 3c             	sub    $0x3c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
{
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80004c:	00 
  80004d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800051:	89 1c 24             	mov    %ebx,(%esp)
  800054:	e8 03 1b 00 00       	call   801b5c <readn>
  800059:	83 f8 04             	cmp    $0x4,%eax
  80005c:	74 2e                	je     80008c <primeproc+0x59>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80005e:	85 c0                	test   %eax,%eax
  800060:	ba 00 00 00 00       	mov    $0x0,%edx
  800065:	0f 4e d0             	cmovle %eax,%edx
  800068:	89 54 24 10          	mov    %edx,0x10(%esp)
  80006c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800070:	c7 44 24 08 c0 2f 80 	movl   $0x802fc0,0x8(%esp)
  800077:	00 
  800078:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  80007f:	00 
  800080:	c7 04 24 ef 2f 80 00 	movl   $0x802fef,(%esp)
  800087:	e8 92 02 00 00       	call   80031e <_panic>

	cprintf("%d\n", p);
  80008c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80008f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800093:	c7 04 24 01 30 80 00 	movl   $0x803001,(%esp)
  80009a:	e8 78 03 00 00       	call   800417 <cprintf>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  80009f:	89 3c 24             	mov    %edi,(%esp)
  8000a2:	e8 1d 27 00 00       	call   8027c4 <pipe>
  8000a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	79 20                	jns    8000ce <primeproc+0x9b>
		panic("pipe: %e", i);
  8000ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b2:	c7 44 24 08 05 30 80 	movl   $0x803005,0x8(%esp)
  8000b9:	00 
  8000ba:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8000c1:	00 
  8000c2:	c7 04 24 ef 2f 80 00 	movl   $0x802fef,(%esp)
  8000c9:	e8 50 02 00 00       	call   80031e <_panic>
	if ((id = fork()) < 0)
  8000ce:	e8 4c 13 00 00       	call   80141f <fork>
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	79 20                	jns    8000f7 <primeproc+0xc4>
		panic("fork: %e", id);
  8000d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000db:	c7 44 24 08 0e 30 80 	movl   $0x80300e,0x8(%esp)
  8000e2:	00 
  8000e3:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8000ea:	00 
  8000eb:	c7 04 24 ef 2f 80 00 	movl   $0x802fef,(%esp)
  8000f2:	e8 27 02 00 00       	call   80031e <_panic>
	if (id == 0) {
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	75 1b                	jne    800116 <primeproc+0xe3>
		close(fd);
  8000fb:	89 1c 24             	mov    %ebx,(%esp)
  8000fe:	e8 64 18 00 00       	call   801967 <close>
		close(pfd[1]);
  800103:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800106:	89 04 24             	mov    %eax,(%esp)
  800109:	e8 59 18 00 00       	call   801967 <close>
		fd = pfd[0];
  80010e:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  800111:	e9 2f ff ff ff       	jmp    800045 <primeproc+0x12>
	}

	close(pfd[0]);
  800116:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800119:	89 04 24             	mov    %eax,(%esp)
  80011c:	e8 46 18 00 00       	call   801967 <close>
	wfd = pfd[1];
  800121:	8b 7d dc             	mov    -0x24(%ebp),%edi

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  800124:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800127:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80012e:	00 
  80012f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800133:	89 1c 24             	mov    %ebx,(%esp)
  800136:	e8 21 1a 00 00       	call   801b5c <readn>
  80013b:	83 f8 04             	cmp    $0x4,%eax
  80013e:	74 39                	je     800179 <primeproc+0x146>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800140:	85 c0                	test   %eax,%eax
  800142:	ba 00 00 00 00       	mov    $0x0,%edx
  800147:	0f 4e d0             	cmovle %eax,%edx
  80014a:	89 54 24 18          	mov    %edx,0x18(%esp)
  80014e:	89 44 24 14          	mov    %eax,0x14(%esp)
  800152:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800156:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800159:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015d:	c7 44 24 08 17 30 80 	movl   $0x803017,0x8(%esp)
  800164:	00 
  800165:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  80016c:	00 
  80016d:	c7 04 24 ef 2f 80 00 	movl   $0x802fef,(%esp)
  800174:	e8 a5 01 00 00       	call   80031e <_panic>
		if (i%p)
  800179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017c:	99                   	cltd   
  80017d:	f7 7d e0             	idivl  -0x20(%ebp)
  800180:	85 d2                	test   %edx,%edx
  800182:	74 a3                	je     800127 <primeproc+0xf4>
			if ((r=write(wfd, &i, 4)) != 4)
  800184:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80018b:	00 
  80018c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800190:	89 3c 24             	mov    %edi,(%esp)
  800193:	e8 0f 1a 00 00       	call   801ba7 <write>
  800198:	83 f8 04             	cmp    $0x4,%eax
  80019b:	74 8a                	je     800127 <primeproc+0xf4>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80019d:	85 c0                	test   %eax,%eax
  80019f:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a4:	0f 4e d0             	cmovle %eax,%edx
  8001a7:	89 54 24 14          	mov    %edx,0x14(%esp)
  8001ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 ef 2f 80 00 	movl   $0x802fef,(%esp)
  8001cd:	e8 4c 01 00 00       	call   80031e <_panic>

008001d2 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 34             	sub    $0x34,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  8001d9:	c7 05 00 40 80 00 4d 	movl   $0x80304d,0x804000
  8001e0:	30 80 00 

	if ((i=pipe(p)) < 0)
  8001e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001e6:	89 04 24             	mov    %eax,(%esp)
  8001e9:	e8 d6 25 00 00       	call   8027c4 <pipe>
  8001ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	79 20                	jns    800215 <umain+0x43>
		panic("pipe: %e", i);
  8001f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f9:	c7 44 24 08 05 30 80 	movl   $0x803005,0x8(%esp)
  800200:	00 
  800201:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800208:	00 
  800209:	c7 04 24 ef 2f 80 00 	movl   $0x802fef,(%esp)
  800210:	e8 09 01 00 00       	call   80031e <_panic>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800215:	e8 05 12 00 00       	call   80141f <fork>
  80021a:	85 c0                	test   %eax,%eax
  80021c:	79 20                	jns    80023e <umain+0x6c>
		panic("fork: %e", id);
  80021e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800222:	c7 44 24 08 0e 30 80 	movl   $0x80300e,0x8(%esp)
  800229:	00 
  80022a:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  800231:	00 
  800232:	c7 04 24 ef 2f 80 00 	movl   $0x802fef,(%esp)
  800239:	e8 e0 00 00 00       	call   80031e <_panic>

	if (id == 0) {
  80023e:	85 c0                	test   %eax,%eax
  800240:	75 16                	jne    800258 <umain+0x86>
		close(p[1]);
  800242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	e8 1a 17 00 00       	call   801967 <close>
		primeproc(p[0]);
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	89 04 24             	mov    %eax,(%esp)
  800253:	e8 db fd ff ff       	call   800033 <primeproc>
	}

	close(p[0]);
  800258:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025b:	89 04 24             	mov    %eax,(%esp)
  80025e:	e8 04 17 00 00       	call   801967 <close>

	// feed all the integers through
	for (i=2;; i++)
  800263:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80026a:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  80026d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800274:	00 
  800275:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80027c:	89 04 24             	mov    %eax,(%esp)
  80027f:	e8 23 19 00 00       	call   801ba7 <write>
  800284:	83 f8 04             	cmp    $0x4,%eax
  800287:	74 2e                	je     8002b7 <umain+0xe5>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800289:	85 c0                	test   %eax,%eax
  80028b:	ba 00 00 00 00       	mov    $0x0,%edx
  800290:	0f 4e d0             	cmovle %eax,%edx
  800293:	89 54 24 10          	mov    %edx,0x10(%esp)
  800297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029b:	c7 44 24 08 58 30 80 	movl   $0x803058,0x8(%esp)
  8002a2:	00 
  8002a3:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8002aa:	00 
  8002ab:	c7 04 24 ef 2f 80 00 	movl   $0x802fef,(%esp)
  8002b2:	e8 67 00 00 00       	call   80031e <_panic>
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  8002b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  8002bb:	eb b0                	jmp    80026d <umain+0x9b>

008002bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	56                   	push   %esi
  8002c1:	53                   	push   %ebx
  8002c2:	83 ec 10             	sub    $0x10,%esp
  8002c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8002cb:	e8 f7 0b 00 00       	call   800ec7 <sys_getenvid>
  8002d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002d5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002dd:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e2:	85 db                	test   %ebx,%ebx
  8002e4:	7e 07                	jle    8002ed <libmain+0x30>
		binaryname = argv[0];
  8002e6:	8b 06                	mov    (%esi),%eax
  8002e8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8002ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002f1:	89 1c 24             	mov    %ebx,(%esp)
  8002f4:	e8 d9 fe ff ff       	call   8001d2 <umain>

	// exit gracefully
	exit();
  8002f9:	e8 07 00 00 00       	call   800305 <exit>
}
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	5b                   	pop    %ebx
  800302:	5e                   	pop    %esi
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80030b:	e8 8a 16 00 00       	call   80199a <close_all>
	sys_env_destroy(0);
  800310:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800317:	e8 07 0b 00 00       	call   800e23 <sys_env_destroy>
}
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	56                   	push   %esi
  800322:	53                   	push   %ebx
  800323:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800326:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800329:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80032f:	e8 93 0b 00 00       	call   800ec7 <sys_getenvid>
  800334:	8b 55 0c             	mov    0xc(%ebp),%edx
  800337:	89 54 24 10          	mov    %edx,0x10(%esp)
  80033b:	8b 55 08             	mov    0x8(%ebp),%edx
  80033e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800342:	89 74 24 08          	mov    %esi,0x8(%esp)
  800346:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034a:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  800351:	e8 c1 00 00 00       	call   800417 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800356:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80035a:	8b 45 10             	mov    0x10(%ebp),%eax
  80035d:	89 04 24             	mov    %eax,(%esp)
  800360:	e8 51 00 00 00       	call   8003b6 <vcprintf>
	cprintf("\n");
  800365:	c7 04 24 8b 35 80 00 	movl   $0x80358b,(%esp)
  80036c:	e8 a6 00 00 00       	call   800417 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800371:	cc                   	int3   
  800372:	eb fd                	jmp    800371 <_panic+0x53>

00800374 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	53                   	push   %ebx
  800378:	83 ec 14             	sub    $0x14,%esp
  80037b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80037e:	8b 13                	mov    (%ebx),%edx
  800380:	8d 42 01             	lea    0x1(%edx),%eax
  800383:	89 03                	mov    %eax,(%ebx)
  800385:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800388:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80038c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800391:	75 19                	jne    8003ac <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800393:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80039a:	00 
  80039b:	8d 43 08             	lea    0x8(%ebx),%eax
  80039e:	89 04 24             	mov    %eax,(%esp)
  8003a1:	e8 40 0a 00 00       	call   800de6 <sys_cputs>
		b->idx = 0;
  8003a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003ac:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b0:	83 c4 14             	add    $0x14,%esp
  8003b3:	5b                   	pop    %ebx
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c6:	00 00 00 
	b.cnt = 0;
  8003c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003da:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003eb:	c7 04 24 74 03 80 00 	movl   $0x800374,(%esp)
  8003f2:	e8 7d 01 00 00       	call   800574 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003f7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8003fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800401:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800407:	89 04 24             	mov    %eax,(%esp)
  80040a:	e8 d7 09 00 00       	call   800de6 <sys_cputs>

	return b.cnt;
}
  80040f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800415:	c9                   	leave  
  800416:	c3                   	ret    

00800417 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80041d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800420:	89 44 24 04          	mov    %eax,0x4(%esp)
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	89 04 24             	mov    %eax,(%esp)
  80042a:	e8 87 ff ff ff       	call   8003b6 <vcprintf>
	va_end(ap);

	return cnt;
}
  80042f:	c9                   	leave  
  800430:	c3                   	ret    
  800431:	66 90                	xchg   %ax,%ax
  800433:	66 90                	xchg   %ax,%ax
  800435:	66 90                	xchg   %ax,%ax
  800437:	66 90                	xchg   %ax,%ax
  800439:	66 90                	xchg   %ax,%ax
  80043b:	66 90                	xchg   %ax,%ax
  80043d:	66 90                	xchg   %ax,%ax
  80043f:	90                   	nop

00800440 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	57                   	push   %edi
  800444:	56                   	push   %esi
  800445:	53                   	push   %ebx
  800446:	83 ec 3c             	sub    $0x3c,%esp
  800449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80044c:	89 d7                	mov    %edx,%edi
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800454:	8b 45 0c             	mov    0xc(%ebp),%eax
  800457:	89 c3                	mov    %eax,%ebx
  800459:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80045c:	8b 45 10             	mov    0x10(%ebp),%eax
  80045f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800462:	b9 00 00 00 00       	mov    $0x0,%ecx
  800467:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80046d:	39 d9                	cmp    %ebx,%ecx
  80046f:	72 05                	jb     800476 <printnum+0x36>
  800471:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800474:	77 69                	ja     8004df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800476:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800479:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80047d:	83 ee 01             	sub    $0x1,%esi
  800480:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800484:	89 44 24 08          	mov    %eax,0x8(%esp)
  800488:	8b 44 24 08          	mov    0x8(%esp),%eax
  80048c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800490:	89 c3                	mov    %eax,%ebx
  800492:	89 d6                	mov    %edx,%esi
  800494:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800497:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80049a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80049e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8004a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a5:	89 04 24             	mov    %eax,(%esp)
  8004a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004af:	e8 6c 28 00 00       	call   802d20 <__udivdi3>
  8004b4:	89 d9                	mov    %ebx,%ecx
  8004b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004c5:	89 fa                	mov    %edi,%edx
  8004c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ca:	e8 71 ff ff ff       	call   800440 <printnum>
  8004cf:	eb 1b                	jmp    8004ec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d8:	89 04 24             	mov    %eax,(%esp)
  8004db:	ff d3                	call   *%ebx
  8004dd:	eb 03                	jmp    8004e2 <printnum+0xa2>
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e2:	83 ee 01             	sub    $0x1,%esi
  8004e5:	85 f6                	test   %esi,%esi
  8004e7:	7f e8                	jg     8004d1 <printnum+0x91>
  8004e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8004f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050f:	e8 3c 29 00 00       	call   802e50 <__umoddi3>
  800514:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800518:	0f be 80 9f 30 80 00 	movsbl 0x80309f(%eax),%eax
  80051f:	89 04 24             	mov    %eax,(%esp)
  800522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800525:	ff d0                	call   *%eax
}
  800527:	83 c4 3c             	add    $0x3c,%esp
  80052a:	5b                   	pop    %ebx
  80052b:	5e                   	pop    %esi
  80052c:	5f                   	pop    %edi
  80052d:	5d                   	pop    %ebp
  80052e:	c3                   	ret    

0080052f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800535:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800539:	8b 10                	mov    (%eax),%edx
  80053b:	3b 50 04             	cmp    0x4(%eax),%edx
  80053e:	73 0a                	jae    80054a <sprintputch+0x1b>
		*b->buf++ = ch;
  800540:	8d 4a 01             	lea    0x1(%edx),%ecx
  800543:	89 08                	mov    %ecx,(%eax)
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	88 02                	mov    %al,(%edx)
}
  80054a:	5d                   	pop    %ebp
  80054b:	c3                   	ret    

0080054c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80054c:	55                   	push   %ebp
  80054d:	89 e5                	mov    %esp,%ebp
  80054f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800552:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800555:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800559:	8b 45 10             	mov    0x10(%ebp),%eax
  80055c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800560:	8b 45 0c             	mov    0xc(%ebp),%eax
  800563:	89 44 24 04          	mov    %eax,0x4(%esp)
  800567:	8b 45 08             	mov    0x8(%ebp),%eax
  80056a:	89 04 24             	mov    %eax,(%esp)
  80056d:	e8 02 00 00 00       	call   800574 <vprintfmt>
	va_end(ap);
}
  800572:	c9                   	leave  
  800573:	c3                   	ret    

00800574 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
  800577:	57                   	push   %edi
  800578:	56                   	push   %esi
  800579:	53                   	push   %ebx
  80057a:	83 ec 3c             	sub    $0x3c,%esp
  80057d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800580:	eb 17                	jmp    800599 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800582:	85 c0                	test   %eax,%eax
  800584:	0f 84 4b 04 00 00    	je     8009d5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80058a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80058d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800591:	89 04 24             	mov    %eax,(%esp)
  800594:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800597:	89 fb                	mov    %edi,%ebx
  800599:	8d 7b 01             	lea    0x1(%ebx),%edi
  80059c:	0f b6 03             	movzbl (%ebx),%eax
  80059f:	83 f8 25             	cmp    $0x25,%eax
  8005a2:	75 de                	jne    800582 <vprintfmt+0xe>
  8005a4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8005a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005af:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8005b4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005bb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c0:	eb 18                	jmp    8005da <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8005c4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8005c8:	eb 10                	jmp    8005da <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ca:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005cc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8005d0:	eb 08                	jmp    8005da <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8005d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005d5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	8d 5f 01             	lea    0x1(%edi),%ebx
  8005dd:	0f b6 17             	movzbl (%edi),%edx
  8005e0:	0f b6 c2             	movzbl %dl,%eax
  8005e3:	83 ea 23             	sub    $0x23,%edx
  8005e6:	80 fa 55             	cmp    $0x55,%dl
  8005e9:	0f 87 c2 03 00 00    	ja     8009b1 <vprintfmt+0x43d>
  8005ef:	0f b6 d2             	movzbl %dl,%edx
  8005f2:	ff 24 95 e0 31 80 00 	jmp    *0x8031e0(,%edx,4)
  8005f9:	89 df                	mov    %ebx,%edi
  8005fb:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800600:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800603:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800607:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80060a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80060d:	83 fa 09             	cmp    $0x9,%edx
  800610:	77 33                	ja     800645 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800612:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800615:	eb e9                	jmp    800600 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 30                	mov    (%eax),%esi
  80061c:	8d 40 04             	lea    0x4(%eax),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800622:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800624:	eb 1f                	jmp    800645 <vprintfmt+0xd1>
  800626:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800629:	85 ff                	test   %edi,%edi
  80062b:	b8 00 00 00 00       	mov    $0x0,%eax
  800630:	0f 49 c7             	cmovns %edi,%eax
  800633:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800636:	89 df                	mov    %ebx,%edi
  800638:	eb a0                	jmp    8005da <vprintfmt+0x66>
  80063a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80063c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800643:	eb 95                	jmp    8005da <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800645:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800649:	79 8f                	jns    8005da <vprintfmt+0x66>
  80064b:	eb 85                	jmp    8005d2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80064d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800650:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800652:	eb 86                	jmp    8005da <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 70 04             	lea    0x4(%eax),%esi
  80065a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	89 04 24             	mov    %eax,(%esp)
  800669:	ff 55 08             	call   *0x8(%ebp)
  80066c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80066f:	e9 25 ff ff ff       	jmp    800599 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 70 04             	lea    0x4(%eax),%esi
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	99                   	cltd   
  80067d:	31 d0                	xor    %edx,%eax
  80067f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800681:	83 f8 15             	cmp    $0x15,%eax
  800684:	7f 0b                	jg     800691 <vprintfmt+0x11d>
  800686:	8b 14 85 40 33 80 00 	mov    0x803340(,%eax,4),%edx
  80068d:	85 d2                	test   %edx,%edx
  80068f:	75 26                	jne    8006b7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800691:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800695:	c7 44 24 08 b7 30 80 	movl   $0x8030b7,0x8(%esp)
  80069c:	00 
  80069d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	89 04 24             	mov    %eax,(%esp)
  8006aa:	e8 9d fe ff ff       	call   80054c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006af:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8006b2:	e9 e2 fe ff ff       	jmp    800599 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8006b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006bb:	c7 44 24 08 5a 35 80 	movl   $0x80355a,0x8(%esp)
  8006c2:	00 
  8006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	89 04 24             	mov    %eax,(%esp)
  8006d0:	e8 77 fe ff ff       	call   80054c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d5:	89 75 14             	mov    %esi,0x14(%ebp)
  8006d8:	e9 bc fe ff ff       	jmp    800599 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006e3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8006ea:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8006ec:	85 ff                	test   %edi,%edi
  8006ee:	b8 b0 30 80 00       	mov    $0x8030b0,%eax
  8006f3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8006f6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8006fa:	0f 84 94 00 00 00    	je     800794 <vprintfmt+0x220>
  800700:	85 c9                	test   %ecx,%ecx
  800702:	0f 8e 94 00 00 00    	jle    80079c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800708:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070c:	89 3c 24             	mov    %edi,(%esp)
  80070f:	e8 64 03 00 00       	call   800a78 <strnlen>
  800714:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800717:	29 c1                	sub    %eax,%ecx
  800719:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80071c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  800720:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800723:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800726:	8b 75 08             	mov    0x8(%ebp),%esi
  800729:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80072c:	89 cb                	mov    %ecx,%ebx
  80072e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800730:	eb 0f                	jmp    800741 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	89 44 24 04          	mov    %eax,0x4(%esp)
  800739:	89 3c 24             	mov    %edi,(%esp)
  80073c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80073e:	83 eb 01             	sub    $0x1,%ebx
  800741:	85 db                	test   %ebx,%ebx
  800743:	7f ed                	jg     800732 <vprintfmt+0x1be>
  800745:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800748:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80074b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80074e:	85 c9                	test   %ecx,%ecx
  800750:	b8 00 00 00 00       	mov    $0x0,%eax
  800755:	0f 49 c1             	cmovns %ecx,%eax
  800758:	29 c1                	sub    %eax,%ecx
  80075a:	89 cb                	mov    %ecx,%ebx
  80075c:	eb 44                	jmp    8007a2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80075e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800762:	74 1e                	je     800782 <vprintfmt+0x20e>
  800764:	0f be d2             	movsbl %dl,%edx
  800767:	83 ea 20             	sub    $0x20,%edx
  80076a:	83 fa 5e             	cmp    $0x5e,%edx
  80076d:	76 13                	jbe    800782 <vprintfmt+0x20e>
					putch('?', putdat);
  80076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800772:	89 44 24 04          	mov    %eax,0x4(%esp)
  800776:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80077d:	ff 55 08             	call   *0x8(%ebp)
  800780:	eb 0d                	jmp    80078f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800782:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800785:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800789:	89 04 24             	mov    %eax,(%esp)
  80078c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80078f:	83 eb 01             	sub    $0x1,%ebx
  800792:	eb 0e                	jmp    8007a2 <vprintfmt+0x22e>
  800794:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800797:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80079a:	eb 06                	jmp    8007a2 <vprintfmt+0x22e>
  80079c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80079f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8007a2:	83 c7 01             	add    $0x1,%edi
  8007a5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8007a9:	0f be c2             	movsbl %dl,%eax
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	74 27                	je     8007d7 <vprintfmt+0x263>
  8007b0:	85 f6                	test   %esi,%esi
  8007b2:	78 aa                	js     80075e <vprintfmt+0x1ea>
  8007b4:	83 ee 01             	sub    $0x1,%esi
  8007b7:	79 a5                	jns    80075e <vprintfmt+0x1ea>
  8007b9:	89 d8                	mov    %ebx,%eax
  8007bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007be:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007c1:	89 c3                	mov    %eax,%ebx
  8007c3:	eb 18                	jmp    8007dd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8007c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8007d0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d2:	83 eb 01             	sub    $0x1,%ebx
  8007d5:	eb 06                	jmp    8007dd <vprintfmt+0x269>
  8007d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007da:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007dd:	85 db                	test   %ebx,%ebx
  8007df:	7f e4                	jg     8007c5 <vprintfmt+0x251>
  8007e1:	89 75 08             	mov    %esi,0x8(%ebp)
  8007e4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007ea:	e9 aa fd ff ff       	jmp    800599 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007ef:	83 f9 01             	cmp    $0x1,%ecx
  8007f2:	7e 10                	jle    800804 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8b 30                	mov    (%eax),%esi
  8007f9:	8b 78 04             	mov    0x4(%eax),%edi
  8007fc:	8d 40 08             	lea    0x8(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	eb 26                	jmp    80082a <vprintfmt+0x2b6>
	else if (lflag)
  800804:	85 c9                	test   %ecx,%ecx
  800806:	74 12                	je     80081a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 30                	mov    (%eax),%esi
  80080d:	89 f7                	mov    %esi,%edi
  80080f:	c1 ff 1f             	sar    $0x1f,%edi
  800812:	8d 40 04             	lea    0x4(%eax),%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
  800818:	eb 10                	jmp    80082a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8b 30                	mov    (%eax),%esi
  80081f:	89 f7                	mov    %esi,%edi
  800821:	c1 ff 1f             	sar    $0x1f,%edi
  800824:	8d 40 04             	lea    0x4(%eax),%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80082a:	89 f0                	mov    %esi,%eax
  80082c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80082e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800833:	85 ff                	test   %edi,%edi
  800835:	0f 89 3a 01 00 00    	jns    800975 <vprintfmt+0x401>
				putch('-', putdat);
  80083b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800842:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800849:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80084c:	89 f0                	mov    %esi,%eax
  80084e:	89 fa                	mov    %edi,%edx
  800850:	f7 d8                	neg    %eax
  800852:	83 d2 00             	adc    $0x0,%edx
  800855:	f7 da                	neg    %edx
			}
			base = 10;
  800857:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80085c:	e9 14 01 00 00       	jmp    800975 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800861:	83 f9 01             	cmp    $0x1,%ecx
  800864:	7e 13                	jle    800879 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 50 04             	mov    0x4(%eax),%edx
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	8b 75 14             	mov    0x14(%ebp),%esi
  800871:	8d 4e 08             	lea    0x8(%esi),%ecx
  800874:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800877:	eb 2c                	jmp    8008a5 <vprintfmt+0x331>
	else if (lflag)
  800879:	85 c9                	test   %ecx,%ecx
  80087b:	74 15                	je     800892 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	ba 00 00 00 00       	mov    $0x0,%edx
  800887:	8b 75 14             	mov    0x14(%ebp),%esi
  80088a:	8d 76 04             	lea    0x4(%esi),%esi
  80088d:	89 75 14             	mov    %esi,0x14(%ebp)
  800890:	eb 13                	jmp    8008a5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	ba 00 00 00 00       	mov    $0x0,%edx
  80089c:	8b 75 14             	mov    0x14(%ebp),%esi
  80089f:	8d 76 04             	lea    0x4(%esi),%esi
  8008a2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8008a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8008aa:	e9 c6 00 00 00       	jmp    800975 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008af:	83 f9 01             	cmp    $0x1,%ecx
  8008b2:	7e 13                	jle    8008c7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8b 50 04             	mov    0x4(%eax),%edx
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	8b 75 14             	mov    0x14(%ebp),%esi
  8008bf:	8d 4e 08             	lea    0x8(%esi),%ecx
  8008c2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008c5:	eb 24                	jmp    8008eb <vprintfmt+0x377>
	else if (lflag)
  8008c7:	85 c9                	test   %ecx,%ecx
  8008c9:	74 11                	je     8008dc <vprintfmt+0x368>
		return va_arg(*ap, long);
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	99                   	cltd   
  8008d1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8008d4:	8d 71 04             	lea    0x4(%ecx),%esi
  8008d7:	89 75 14             	mov    %esi,0x14(%ebp)
  8008da:	eb 0f                	jmp    8008eb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	99                   	cltd   
  8008e2:	8b 75 14             	mov    0x14(%ebp),%esi
  8008e5:	8d 76 04             	lea    0x4(%esi),%esi
  8008e8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  8008eb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8008f0:	e9 80 00 00 00       	jmp    800975 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  8008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ff:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800906:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800909:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800910:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800917:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80091a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80091e:	8b 06                	mov    (%esi),%eax
  800920:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800925:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80092a:	eb 49                	jmp    800975 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80092c:	83 f9 01             	cmp    $0x1,%ecx
  80092f:	7e 13                	jle    800944 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8b 50 04             	mov    0x4(%eax),%edx
  800937:	8b 00                	mov    (%eax),%eax
  800939:	8b 75 14             	mov    0x14(%ebp),%esi
  80093c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80093f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800942:	eb 2c                	jmp    800970 <vprintfmt+0x3fc>
	else if (lflag)
  800944:	85 c9                	test   %ecx,%ecx
  800946:	74 15                	je     80095d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	ba 00 00 00 00       	mov    $0x0,%edx
  800952:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800955:	8d 71 04             	lea    0x4(%ecx),%esi
  800958:	89 75 14             	mov    %esi,0x14(%ebp)
  80095b:	eb 13                	jmp    800970 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	8b 00                	mov    (%eax),%eax
  800962:	ba 00 00 00 00       	mov    $0x0,%edx
  800967:	8b 75 14             	mov    0x14(%ebp),%esi
  80096a:	8d 76 04             	lea    0x4(%esi),%esi
  80096d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800970:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800975:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800979:	89 74 24 10          	mov    %esi,0x10(%esp)
  80097d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800980:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800984:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800988:	89 04 24             	mov    %eax,(%esp)
  80098b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80098f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	e8 a6 fa ff ff       	call   800440 <printnum>
			break;
  80099a:	e9 fa fb ff ff       	jmp    800599 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80099f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009a6:	89 04 24             	mov    %eax,(%esp)
  8009a9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009ac:	e9 e8 fb ff ff       	jmp    800599 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009bf:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009c2:	89 fb                	mov    %edi,%ebx
  8009c4:	eb 03                	jmp    8009c9 <vprintfmt+0x455>
  8009c6:	83 eb 01             	sub    $0x1,%ebx
  8009c9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009cd:	75 f7                	jne    8009c6 <vprintfmt+0x452>
  8009cf:	90                   	nop
  8009d0:	e9 c4 fb ff ff       	jmp    800599 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8009d5:	83 c4 3c             	add    $0x3c,%esp
  8009d8:	5b                   	pop    %ebx
  8009d9:	5e                   	pop    %esi
  8009da:	5f                   	pop    %edi
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	83 ec 28             	sub    $0x28,%esp
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ec:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009f0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009fa:	85 c0                	test   %eax,%eax
  8009fc:	74 30                	je     800a2e <vsnprintf+0x51>
  8009fe:	85 d2                	test   %edx,%edx
  800a00:	7e 2c                	jle    800a2e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a02:	8b 45 14             	mov    0x14(%ebp),%eax
  800a05:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a09:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a10:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a17:	c7 04 24 2f 05 80 00 	movl   $0x80052f,(%esp)
  800a1e:	e8 51 fb ff ff       	call   800574 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a26:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a2c:	eb 05                	jmp    800a33 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a3b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a42:	8b 45 10             	mov    0x10(%ebp),%eax
  800a45:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	89 04 24             	mov    %eax,(%esp)
  800a56:	e8 82 ff ff ff       	call   8009dd <vsnprintf>
	va_end(ap);

	return rc;
}
  800a5b:	c9                   	leave  
  800a5c:	c3                   	ret    
  800a5d:	66 90                	xchg   %ax,%ax
  800a5f:	90                   	nop

00800a60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a66:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6b:	eb 03                	jmp    800a70 <strlen+0x10>
		n++;
  800a6d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a70:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a74:	75 f7                	jne    800a6d <strlen+0xd>
		n++;
	return n;
}
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a81:	b8 00 00 00 00       	mov    $0x0,%eax
  800a86:	eb 03                	jmp    800a8b <strnlen+0x13>
		n++;
  800a88:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8b:	39 d0                	cmp    %edx,%eax
  800a8d:	74 06                	je     800a95 <strnlen+0x1d>
  800a8f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a93:	75 f3                	jne    800a88 <strnlen+0x10>
		n++;
	return n;
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	53                   	push   %ebx
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aa1:	89 c2                	mov    %eax,%edx
  800aa3:	83 c2 01             	add    $0x1,%edx
  800aa6:	83 c1 01             	add    $0x1,%ecx
  800aa9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800aad:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ab0:	84 db                	test   %bl,%bl
  800ab2:	75 ef                	jne    800aa3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ab4:	5b                   	pop    %ebx
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	53                   	push   %ebx
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ac1:	89 1c 24             	mov    %ebx,(%esp)
  800ac4:	e8 97 ff ff ff       	call   800a60 <strlen>
	strcpy(dst + len, src);
  800ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ad0:	01 d8                	add    %ebx,%eax
  800ad2:	89 04 24             	mov    %eax,(%esp)
  800ad5:	e8 bd ff ff ff       	call   800a97 <strcpy>
	return dst;
}
  800ada:	89 d8                	mov    %ebx,%eax
  800adc:	83 c4 08             	add    $0x8,%esp
  800adf:	5b                   	pop    %ebx
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	56                   	push   %esi
  800ae6:	53                   	push   %ebx
  800ae7:	8b 75 08             	mov    0x8(%ebp),%esi
  800aea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aed:	89 f3                	mov    %esi,%ebx
  800aef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800af2:	89 f2                	mov    %esi,%edx
  800af4:	eb 0f                	jmp    800b05 <strncpy+0x23>
		*dst++ = *src;
  800af6:	83 c2 01             	add    $0x1,%edx
  800af9:	0f b6 01             	movzbl (%ecx),%eax
  800afc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aff:	80 39 01             	cmpb   $0x1,(%ecx)
  800b02:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b05:	39 da                	cmp    %ebx,%edx
  800b07:	75 ed                	jne    800af6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b09:	89 f0                	mov    %esi,%eax
  800b0b:	5b                   	pop    %ebx
  800b0c:	5e                   	pop    %esi
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	56                   	push   %esi
  800b13:	53                   	push   %ebx
  800b14:	8b 75 08             	mov    0x8(%ebp),%esi
  800b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b1d:	89 f0                	mov    %esi,%eax
  800b1f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b23:	85 c9                	test   %ecx,%ecx
  800b25:	75 0b                	jne    800b32 <strlcpy+0x23>
  800b27:	eb 1d                	jmp    800b46 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b29:	83 c0 01             	add    $0x1,%eax
  800b2c:	83 c2 01             	add    $0x1,%edx
  800b2f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b32:	39 d8                	cmp    %ebx,%eax
  800b34:	74 0b                	je     800b41 <strlcpy+0x32>
  800b36:	0f b6 0a             	movzbl (%edx),%ecx
  800b39:	84 c9                	test   %cl,%cl
  800b3b:	75 ec                	jne    800b29 <strlcpy+0x1a>
  800b3d:	89 c2                	mov    %eax,%edx
  800b3f:	eb 02                	jmp    800b43 <strlcpy+0x34>
  800b41:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b43:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800b46:	29 f0                	sub    %esi,%eax
}
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b52:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b55:	eb 06                	jmp    800b5d <strcmp+0x11>
		p++, q++;
  800b57:	83 c1 01             	add    $0x1,%ecx
  800b5a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b5d:	0f b6 01             	movzbl (%ecx),%eax
  800b60:	84 c0                	test   %al,%al
  800b62:	74 04                	je     800b68 <strcmp+0x1c>
  800b64:	3a 02                	cmp    (%edx),%al
  800b66:	74 ef                	je     800b57 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b68:	0f b6 c0             	movzbl %al,%eax
  800b6b:	0f b6 12             	movzbl (%edx),%edx
  800b6e:	29 d0                	sub    %edx,%eax
}
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7c:	89 c3                	mov    %eax,%ebx
  800b7e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b81:	eb 06                	jmp    800b89 <strncmp+0x17>
		n--, p++, q++;
  800b83:	83 c0 01             	add    $0x1,%eax
  800b86:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b89:	39 d8                	cmp    %ebx,%eax
  800b8b:	74 15                	je     800ba2 <strncmp+0x30>
  800b8d:	0f b6 08             	movzbl (%eax),%ecx
  800b90:	84 c9                	test   %cl,%cl
  800b92:	74 04                	je     800b98 <strncmp+0x26>
  800b94:	3a 0a                	cmp    (%edx),%cl
  800b96:	74 eb                	je     800b83 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b98:	0f b6 00             	movzbl (%eax),%eax
  800b9b:	0f b6 12             	movzbl (%edx),%edx
  800b9e:	29 d0                	sub    %edx,%eax
  800ba0:	eb 05                	jmp    800ba7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ba2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ba7:	5b                   	pop    %ebx
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bb4:	eb 07                	jmp    800bbd <strchr+0x13>
		if (*s == c)
  800bb6:	38 ca                	cmp    %cl,%dl
  800bb8:	74 0f                	je     800bc9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bba:	83 c0 01             	add    $0x1,%eax
  800bbd:	0f b6 10             	movzbl (%eax),%edx
  800bc0:	84 d2                	test   %dl,%dl
  800bc2:	75 f2                	jne    800bb6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd5:	eb 07                	jmp    800bde <strfind+0x13>
		if (*s == c)
  800bd7:	38 ca                	cmp    %cl,%dl
  800bd9:	74 0a                	je     800be5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bdb:	83 c0 01             	add    $0x1,%eax
  800bde:	0f b6 10             	movzbl (%eax),%edx
  800be1:	84 d2                	test   %dl,%dl
  800be3:	75 f2                	jne    800bd7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
  800bed:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bf3:	85 c9                	test   %ecx,%ecx
  800bf5:	74 36                	je     800c2d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bf7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bfd:	75 28                	jne    800c27 <memset+0x40>
  800bff:	f6 c1 03             	test   $0x3,%cl
  800c02:	75 23                	jne    800c27 <memset+0x40>
		c &= 0xFF;
  800c04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c08:	89 d3                	mov    %edx,%ebx
  800c0a:	c1 e3 08             	shl    $0x8,%ebx
  800c0d:	89 d6                	mov    %edx,%esi
  800c0f:	c1 e6 18             	shl    $0x18,%esi
  800c12:	89 d0                	mov    %edx,%eax
  800c14:	c1 e0 10             	shl    $0x10,%eax
  800c17:	09 f0                	or     %esi,%eax
  800c19:	09 c2                	or     %eax,%edx
  800c1b:	89 d0                	mov    %edx,%eax
  800c1d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c1f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c22:	fc                   	cld    
  800c23:	f3 ab                	rep stos %eax,%es:(%edi)
  800c25:	eb 06                	jmp    800c2d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	fc                   	cld    
  800c2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c2d:	89 f8                	mov    %edi,%eax
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c42:	39 c6                	cmp    %eax,%esi
  800c44:	73 35                	jae    800c7b <memmove+0x47>
  800c46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c49:	39 d0                	cmp    %edx,%eax
  800c4b:	73 2e                	jae    800c7b <memmove+0x47>
		s += n;
		d += n;
  800c4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c50:	89 d6                	mov    %edx,%esi
  800c52:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c5a:	75 13                	jne    800c6f <memmove+0x3b>
  800c5c:	f6 c1 03             	test   $0x3,%cl
  800c5f:	75 0e                	jne    800c6f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c61:	83 ef 04             	sub    $0x4,%edi
  800c64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c6a:	fd                   	std    
  800c6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c6d:	eb 09                	jmp    800c78 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c6f:	83 ef 01             	sub    $0x1,%edi
  800c72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c75:	fd                   	std    
  800c76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c78:	fc                   	cld    
  800c79:	eb 1d                	jmp    800c98 <memmove+0x64>
  800c7b:	89 f2                	mov    %esi,%edx
  800c7d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c7f:	f6 c2 03             	test   $0x3,%dl
  800c82:	75 0f                	jne    800c93 <memmove+0x5f>
  800c84:	f6 c1 03             	test   $0x3,%cl
  800c87:	75 0a                	jne    800c93 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c89:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c8c:	89 c7                	mov    %eax,%edi
  800c8e:	fc                   	cld    
  800c8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c91:	eb 05                	jmp    800c98 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c93:	89 c7                	mov    %eax,%edi
  800c95:	fc                   	cld    
  800c96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 04 24             	mov    %eax,(%esp)
  800cb6:	e8 79 ff ff ff       	call   800c34 <memmove>
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
  800cc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc8:	89 d6                	mov    %edx,%esi
  800cca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ccd:	eb 1a                	jmp    800ce9 <memcmp+0x2c>
		if (*s1 != *s2)
  800ccf:	0f b6 02             	movzbl (%edx),%eax
  800cd2:	0f b6 19             	movzbl (%ecx),%ebx
  800cd5:	38 d8                	cmp    %bl,%al
  800cd7:	74 0a                	je     800ce3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800cd9:	0f b6 c0             	movzbl %al,%eax
  800cdc:	0f b6 db             	movzbl %bl,%ebx
  800cdf:	29 d8                	sub    %ebx,%eax
  800ce1:	eb 0f                	jmp    800cf2 <memcmp+0x35>
		s1++, s2++;
  800ce3:	83 c2 01             	add    $0x1,%edx
  800ce6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ce9:	39 f2                	cmp    %esi,%edx
  800ceb:	75 e2                	jne    800ccf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cff:	89 c2                	mov    %eax,%edx
  800d01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d04:	eb 07                	jmp    800d0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d06:	38 08                	cmp    %cl,(%eax)
  800d08:	74 07                	je     800d11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d0a:	83 c0 01             	add    $0x1,%eax
  800d0d:	39 d0                	cmp    %edx,%eax
  800d0f:	72 f5                	jb     800d06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d1f:	eb 03                	jmp    800d24 <strtol+0x11>
		s++;
  800d21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d24:	0f b6 0a             	movzbl (%edx),%ecx
  800d27:	80 f9 09             	cmp    $0x9,%cl
  800d2a:	74 f5                	je     800d21 <strtol+0xe>
  800d2c:	80 f9 20             	cmp    $0x20,%cl
  800d2f:	74 f0                	je     800d21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d31:	80 f9 2b             	cmp    $0x2b,%cl
  800d34:	75 0a                	jne    800d40 <strtol+0x2d>
		s++;
  800d36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d39:	bf 00 00 00 00       	mov    $0x0,%edi
  800d3e:	eb 11                	jmp    800d51 <strtol+0x3e>
  800d40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d45:	80 f9 2d             	cmp    $0x2d,%cl
  800d48:	75 07                	jne    800d51 <strtol+0x3e>
		s++, neg = 1;
  800d4a:	8d 52 01             	lea    0x1(%edx),%edx
  800d4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d56:	75 15                	jne    800d6d <strtol+0x5a>
  800d58:	80 3a 30             	cmpb   $0x30,(%edx)
  800d5b:	75 10                	jne    800d6d <strtol+0x5a>
  800d5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d61:	75 0a                	jne    800d6d <strtol+0x5a>
		s += 2, base = 16;
  800d63:	83 c2 02             	add    $0x2,%edx
  800d66:	b8 10 00 00 00       	mov    $0x10,%eax
  800d6b:	eb 10                	jmp    800d7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	75 0c                	jne    800d7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d73:	80 3a 30             	cmpb   $0x30,(%edx)
  800d76:	75 05                	jne    800d7d <strtol+0x6a>
		s++, base = 8;
  800d78:	83 c2 01             	add    $0x1,%edx
  800d7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d85:	0f b6 0a             	movzbl (%edx),%ecx
  800d88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d8b:	89 f0                	mov    %esi,%eax
  800d8d:	3c 09                	cmp    $0x9,%al
  800d8f:	77 08                	ja     800d99 <strtol+0x86>
			dig = *s - '0';
  800d91:	0f be c9             	movsbl %cl,%ecx
  800d94:	83 e9 30             	sub    $0x30,%ecx
  800d97:	eb 20                	jmp    800db9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800d99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800d9c:	89 f0                	mov    %esi,%eax
  800d9e:	3c 19                	cmp    $0x19,%al
  800da0:	77 08                	ja     800daa <strtol+0x97>
			dig = *s - 'a' + 10;
  800da2:	0f be c9             	movsbl %cl,%ecx
  800da5:	83 e9 57             	sub    $0x57,%ecx
  800da8:	eb 0f                	jmp    800db9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800daa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800dad:	89 f0                	mov    %esi,%eax
  800daf:	3c 19                	cmp    $0x19,%al
  800db1:	77 16                	ja     800dc9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800db3:	0f be c9             	movsbl %cl,%ecx
  800db6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800db9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800dbc:	7d 0f                	jge    800dcd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800dbe:	83 c2 01             	add    $0x1,%edx
  800dc1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800dc5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800dc7:	eb bc                	jmp    800d85 <strtol+0x72>
  800dc9:	89 d8                	mov    %ebx,%eax
  800dcb:	eb 02                	jmp    800dcf <strtol+0xbc>
  800dcd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800dcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd3:	74 05                	je     800dda <strtol+0xc7>
		*endptr = (char *) s;
  800dd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dd8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800dda:	f7 d8                	neg    %eax
  800ddc:	85 ff                	test   %edi,%edi
  800dde:	0f 44 c3             	cmove  %ebx,%eax
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
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
  800dec:	b8 00 00 00 00       	mov    $0x0,%eax
  800df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	89 c3                	mov    %eax,%ebx
  800df9:	89 c7                	mov    %eax,%edi
  800dfb:	89 c6                	mov    %eax,%esi
  800dfd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e14:	89 d1                	mov    %edx,%ecx
  800e16:	89 d3                	mov    %edx,%ebx
  800e18:	89 d7                	mov    %edx,%edi
  800e1a:	89 d6                	mov    %edx,%esi
  800e1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	57                   	push   %edi
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
  800e29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e31:	b8 03 00 00 00       	mov    $0x3,%eax
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	89 cb                	mov    %ecx,%ebx
  800e3b:	89 cf                	mov    %ecx,%edi
  800e3d:	89 ce                	mov    %ecx,%esi
  800e3f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	7e 28                	jle    800e6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e50:	00 
  800e51:	c7 44 24 08 b7 33 80 	movl   $0x8033b7,0x8(%esp)
  800e58:	00 
  800e59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e60:	00 
  800e61:	c7 04 24 d4 33 80 00 	movl   $0x8033d4,(%esp)
  800e68:	e8 b1 f4 ff ff       	call   80031e <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e6d:	83 c4 2c             	add    $0x2c,%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
  800e7b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e83:	b8 04 00 00 00       	mov    $0x4,%eax
  800e88:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8b:	89 cb                	mov    %ecx,%ebx
  800e8d:	89 cf                	mov    %ecx,%edi
  800e8f:	89 ce                	mov    %ecx,%esi
  800e91:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	7e 28                	jle    800ebf <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e97:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e9b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ea2:	00 
  800ea3:	c7 44 24 08 b7 33 80 	movl   $0x8033b7,0x8(%esp)
  800eaa:	00 
  800eab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb2:	00 
  800eb3:	c7 04 24 d4 33 80 00 	movl   $0x8033d4,(%esp)
  800eba:	e8 5f f4 ff ff       	call   80031e <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800ebf:	83 c4 2c             	add    $0x2c,%esp
  800ec2:	5b                   	pop    %ebx
  800ec3:	5e                   	pop    %esi
  800ec4:	5f                   	pop    %edi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ecd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed2:	b8 02 00 00 00       	mov    $0x2,%eax
  800ed7:	89 d1                	mov    %edx,%ecx
  800ed9:	89 d3                	mov    %edx,%ebx
  800edb:	89 d7                	mov    %edx,%edi
  800edd:	89 d6                	mov    %edx,%esi
  800edf:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <sys_yield>:

void
sys_yield(void)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	57                   	push   %edi
  800eea:	56                   	push   %esi
  800eeb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eec:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef6:	89 d1                	mov    %edx,%ecx
  800ef8:	89 d3                	mov    %edx,%ebx
  800efa:	89 d7                	mov    %edx,%edi
  800efc:	89 d6                	mov    %edx,%esi
  800efe:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	57                   	push   %edi
  800f09:	56                   	push   %esi
  800f0a:	53                   	push   %ebx
  800f0b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0e:	be 00 00 00 00       	mov    $0x0,%esi
  800f13:	b8 05 00 00 00       	mov    $0x5,%eax
  800f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f21:	89 f7                	mov    %esi,%edi
  800f23:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	7e 28                	jle    800f51 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f29:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f34:	00 
  800f35:	c7 44 24 08 b7 33 80 	movl   $0x8033b7,0x8(%esp)
  800f3c:	00 
  800f3d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f44:	00 
  800f45:	c7 04 24 d4 33 80 00 	movl   $0x8033d4,(%esp)
  800f4c:	e8 cd f3 ff ff       	call   80031e <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f51:	83 c4 2c             	add    $0x2c,%esp
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	57                   	push   %edi
  800f5d:	56                   	push   %esi
  800f5e:	53                   	push   %ebx
  800f5f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f62:	b8 06 00 00 00       	mov    $0x6,%eax
  800f67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f70:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f73:	8b 75 18             	mov    0x18(%ebp),%esi
  800f76:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	7e 28                	jle    800fa4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f80:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f87:	00 
  800f88:	c7 44 24 08 b7 33 80 	movl   $0x8033b7,0x8(%esp)
  800f8f:	00 
  800f90:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f97:	00 
  800f98:	c7 04 24 d4 33 80 00 	movl   $0x8033d4,(%esp)
  800f9f:	e8 7a f3 ff ff       	call   80031e <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fa4:	83 c4 2c             	add    $0x2c,%esp
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    

00800fac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	57                   	push   %edi
  800fb0:	56                   	push   %esi
  800fb1:	53                   	push   %ebx
  800fb2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fba:	b8 07 00 00 00       	mov    $0x7,%eax
  800fbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc5:	89 df                	mov    %ebx,%edi
  800fc7:	89 de                	mov    %ebx,%esi
  800fc9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	7e 28                	jle    800ff7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcf:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800fda:	00 
  800fdb:	c7 44 24 08 b7 33 80 	movl   $0x8033b7,0x8(%esp)
  800fe2:	00 
  800fe3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fea:	00 
  800feb:	c7 04 24 d4 33 80 00 	movl   $0x8033d4,(%esp)
  800ff2:	e8 27 f3 ff ff       	call   80031e <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ff7:	83 c4 2c             	add    $0x2c,%esp
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801005:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100a:	b8 10 00 00 00       	mov    $0x10,%eax
  80100f:	8b 55 08             	mov    0x8(%ebp),%edx
  801012:	89 cb                	mov    %ecx,%ebx
  801014:	89 cf                	mov    %ecx,%edi
  801016:	89 ce                	mov    %ecx,%esi
  801018:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80101a:	5b                   	pop    %ebx
  80101b:	5e                   	pop    %esi
  80101c:	5f                   	pop    %edi
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    

0080101f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	57                   	push   %edi
  801023:	56                   	push   %esi
  801024:	53                   	push   %ebx
  801025:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801028:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102d:	b8 09 00 00 00       	mov    $0x9,%eax
  801032:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801035:	8b 55 08             	mov    0x8(%ebp),%edx
  801038:	89 df                	mov    %ebx,%edi
  80103a:	89 de                	mov    %ebx,%esi
  80103c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80103e:	85 c0                	test   %eax,%eax
  801040:	7e 28                	jle    80106a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801042:	89 44 24 10          	mov    %eax,0x10(%esp)
  801046:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80104d:	00 
  80104e:	c7 44 24 08 b7 33 80 	movl   $0x8033b7,0x8(%esp)
  801055:	00 
  801056:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80105d:	00 
  80105e:	c7 04 24 d4 33 80 00 	movl   $0x8033d4,(%esp)
  801065:	e8 b4 f2 ff ff       	call   80031e <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80106a:	83 c4 2c             	add    $0x2c,%esp
  80106d:	5b                   	pop    %ebx
  80106e:	5e                   	pop    %esi
  80106f:	5f                   	pop    %edi
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    

00801072 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	57                   	push   %edi
  801076:	56                   	push   %esi
  801077:	53                   	push   %ebx
  801078:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801080:	b8 0a 00 00 00       	mov    $0xa,%eax
  801085:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
  80108b:	89 df                	mov    %ebx,%edi
  80108d:	89 de                	mov    %ebx,%esi
  80108f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801091:	85 c0                	test   %eax,%eax
  801093:	7e 28                	jle    8010bd <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801095:	89 44 24 10          	mov    %eax,0x10(%esp)
  801099:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010a0:	00 
  8010a1:	c7 44 24 08 b7 33 80 	movl   $0x8033b7,0x8(%esp)
  8010a8:	00 
  8010a9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b0:	00 
  8010b1:	c7 04 24 d4 33 80 00 	movl   $0x8033d4,(%esp)
  8010b8:	e8 61 f2 ff ff       	call   80031e <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010bd:	83 c4 2c             	add    $0x2c,%esp
  8010c0:	5b                   	pop    %ebx
  8010c1:	5e                   	pop    %esi
  8010c2:	5f                   	pop    %edi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    

008010c5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	57                   	push   %edi
  8010c9:	56                   	push   %esi
  8010ca:	53                   	push   %ebx
  8010cb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010db:	8b 55 08             	mov    0x8(%ebp),%edx
  8010de:	89 df                	mov    %ebx,%edi
  8010e0:	89 de                	mov    %ebx,%esi
  8010e2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	7e 28                	jle    801110 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ec:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8010f3:	00 
  8010f4:	c7 44 24 08 b7 33 80 	movl   $0x8033b7,0x8(%esp)
  8010fb:	00 
  8010fc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801103:	00 
  801104:	c7 04 24 d4 33 80 00 	movl   $0x8033d4,(%esp)
  80110b:	e8 0e f2 ff ff       	call   80031e <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801110:	83 c4 2c             	add    $0x2c,%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5f                   	pop    %edi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    

00801118 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
  80111b:	57                   	push   %edi
  80111c:	56                   	push   %esi
  80111d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111e:	be 00 00 00 00       	mov    $0x0,%esi
  801123:	b8 0d 00 00 00       	mov    $0xd,%eax
  801128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112b:	8b 55 08             	mov    0x8(%ebp),%edx
  80112e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801131:	8b 7d 14             	mov    0x14(%ebp),%edi
  801134:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801136:	5b                   	pop    %ebx
  801137:	5e                   	pop    %esi
  801138:	5f                   	pop    %edi
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    

0080113b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	57                   	push   %edi
  80113f:	56                   	push   %esi
  801140:	53                   	push   %ebx
  801141:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801144:	b9 00 00 00 00       	mov    $0x0,%ecx
  801149:	b8 0e 00 00 00       	mov    $0xe,%eax
  80114e:	8b 55 08             	mov    0x8(%ebp),%edx
  801151:	89 cb                	mov    %ecx,%ebx
  801153:	89 cf                	mov    %ecx,%edi
  801155:	89 ce                	mov    %ecx,%esi
  801157:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801159:	85 c0                	test   %eax,%eax
  80115b:	7e 28                	jle    801185 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80115d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801161:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801168:	00 
  801169:	c7 44 24 08 b7 33 80 	movl   $0x8033b7,0x8(%esp)
  801170:	00 
  801171:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801178:	00 
  801179:	c7 04 24 d4 33 80 00 	movl   $0x8033d4,(%esp)
  801180:	e8 99 f1 ff ff       	call   80031e <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801185:	83 c4 2c             	add    $0x2c,%esp
  801188:	5b                   	pop    %ebx
  801189:	5e                   	pop    %esi
  80118a:	5f                   	pop    %edi
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	57                   	push   %edi
  801191:	56                   	push   %esi
  801192:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801193:	ba 00 00 00 00       	mov    $0x0,%edx
  801198:	b8 0f 00 00 00       	mov    $0xf,%eax
  80119d:	89 d1                	mov    %edx,%ecx
  80119f:	89 d3                	mov    %edx,%ebx
  8011a1:	89 d7                	mov    %edx,%edi
  8011a3:	89 d6                	mov    %edx,%esi
  8011a5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011a7:	5b                   	pop    %ebx
  8011a8:	5e                   	pop    %esi
  8011a9:	5f                   	pop    %edi
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    

008011ac <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b7:	b8 11 00 00 00       	mov    $0x11,%eax
  8011bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c2:	89 df                	mov    %ebx,%edi
  8011c4:	89 de                	mov    %ebx,%esi
  8011c6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  8011c8:	5b                   	pop    %ebx
  8011c9:	5e                   	pop    %esi
  8011ca:	5f                   	pop    %edi
  8011cb:	5d                   	pop    %ebp
  8011cc:	c3                   	ret    

008011cd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	57                   	push   %edi
  8011d1:	56                   	push   %esi
  8011d2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d8:	b8 12 00 00 00       	mov    $0x12,%eax
  8011dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e3:	89 df                	mov    %ebx,%edi
  8011e5:	89 de                	mov    %ebx,%esi
  8011e7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8011e9:	5b                   	pop    %ebx
  8011ea:	5e                   	pop    %esi
  8011eb:	5f                   	pop    %edi
  8011ec:	5d                   	pop    %ebp
  8011ed:	c3                   	ret    

008011ee <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	57                   	push   %edi
  8011f2:	56                   	push   %esi
  8011f3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011f9:	b8 13 00 00 00       	mov    $0x13,%eax
  8011fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801201:	89 cb                	mov    %ecx,%ebx
  801203:	89 cf                	mov    %ecx,%edi
  801205:	89 ce                	mov    %ecx,%esi
  801207:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801209:	5b                   	pop    %ebx
  80120a:	5e                   	pop    %esi
  80120b:	5f                   	pop    %edi
  80120c:	5d                   	pop    %ebp
  80120d:	c3                   	ret    

0080120e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	57                   	push   %edi
  801212:	56                   	push   %esi
  801213:	53                   	push   %ebx
  801214:	83 ec 2c             	sub    $0x2c,%esp
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80121a:	8b 38                	mov    (%eax),%edi
	uint32_t err = utf->utf_err;
  80121c:	8b 70 04             	mov    0x4(%eax),%esi
	int r;
	pte_t ptentry=0;
	pte_t page_num = PGNUM(addr);
  80121f:	89 f8                	mov    %edi,%eax
  801221:	c1 e8 0c             	shr    $0xc,%eax
  801224:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t src_envid = sys_getenvid();
  801227:	e8 9b fc ff ff       	call   800ec7 <sys_getenvid>

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
	//checks if fault because of write action //violation//
	if(err & FEC_WR)
  80122c:	f7 c6 02 00 00 00    	test   $0x2,%esi
  801232:	0f 84 de 00 00 00    	je     801316 <pgfault+0x108>
  801238:	89 c3                	mov    %eax,%ebx
	{
		if(src_envid <0)
  80123a:	85 c0                	test   %eax,%eax
  80123c:	79 20                	jns    80125e <pgfault+0x50>
			panic("\nenvironment value wrong:%e",src_envid);	
  80123e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801242:	c7 44 24 08 e2 33 80 	movl   $0x8033e2,0x8(%esp)
  801249:	00 
  80124a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801251:	00 
  801252:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  801259:	e8 c0 f0 ff ff       	call   80031e <_panic>
		//check if the the page is copy on write
		ptentry = uvpt[page_num];
  80125e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801261:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
		if((ptentry & PTE_COW) && (ptentry & PTE_U) && (ptentry & PTE_P))
  801268:	25 05 08 00 00       	and    $0x805,%eax
  80126d:	3d 05 08 00 00       	cmp    $0x805,%eax
  801272:	0f 85 ba 00 00 00    	jne    801332 <pgfault+0x124>
		{
			//allocating page mapped at virtual address PFTEMP in current address space
			//cprintf("\nenvid:%d nd thisenvid:%d",src_envid, thisenv->env_id);
			if ((r = sys_page_alloc(src_envid, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801278:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80127f:	00 
  801280:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801287:	00 
  801288:	89 1c 24             	mov    %ebx,(%esp)
  80128b:	e8 75 fc ff ff       	call   800f05 <sys_page_alloc>
  801290:	85 c0                	test   %eax,%eax
  801292:	79 20                	jns    8012b4 <pgfault+0xa6>
				panic("sys_page_alloc: %e", r);
  801294:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801298:	c7 44 24 08 09 34 80 	movl   $0x803409,0x8(%esp)
  80129f:	00 
  8012a0:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8012a7:	00 
  8012a8:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  8012af:	e8 6a f0 ff ff       	call   80031e <_panic>
			//copying the data at addr to newly mapped page
			memmove((void *)PFTEMP, (void *)PTE_ADDR(addr), PGSIZE);
  8012b4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8012ba:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8012c1:	00 
  8012c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012c6:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8012cd:	e8 62 f9 ff ff       	call   800c34 <memmove>
				So our PFTEMP addr is already pointing to old page faulted page. So during this new
				page insert it pages will obviously not be same so will remove the old page mapping
				So old page mapping will go from 2 to 1 which is no and also was consistent.

			*/
			if ((r = sys_page_map(src_envid, PFTEMP, src_envid, (void *)PTE_ADDR(addr), PTE_P|PTE_U|PTE_W)) < 0)
  8012d2:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8012d9:	00 
  8012da:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012de:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012e2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012e9:	00 
  8012ea:	89 1c 24             	mov    %ebx,(%esp)
  8012ed:	e8 67 fc ff ff       	call   800f59 <sys_page_map>
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	79 3c                	jns    801332 <pgfault+0x124>
				panic("sys_page_map: %e", r);
  8012f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012fa:	c7 44 24 08 1c 34 80 	movl   $0x80341c,0x8(%esp)
  801301:	00 
  801302:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801309:	00 
  80130a:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  801311:	e8 08 f0 ff ff       	call   80031e <_panic>
		}

	}
	else
		panic("\nviolation of page fault handler\n");
  801316:	c7 44 24 08 40 34 80 	movl   $0x803440,0x8(%esp)
  80131d:	00 
  80131e:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  801325:	00 
  801326:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  80132d:	e8 ec ef ff ff       	call   80031e <_panic>
}
  801332:	83 c4 2c             	add    $0x2c,%esp
  801335:	5b                   	pop    %ebx
  801336:	5e                   	pop    %esi
  801337:	5f                   	pop    %edi
  801338:	5d                   	pop    %ebp
  801339:	c3                   	ret    

0080133a <sf_stack_duppage>:

void
sf_stack_duppage(envid_t dstenv, void *addr)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	56                   	push   %esi
  80133e:	53                   	push   %ebx
  80133f:	83 ec 20             	sub    $0x20,%esp
  801342:	8b 75 08             	mov    0x8(%ebp),%esi
  801345:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	//cprintf("\nsf_stack_duppage\n");
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801348:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80134f:	00 
  801350:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801354:	89 34 24             	mov    %esi,(%esp)
  801357:	e8 a9 fb ff ff       	call   800f05 <sys_page_alloc>
  80135c:	85 c0                	test   %eax,%eax
  80135e:	79 20                	jns    801380 <sf_stack_duppage+0x46>
		panic("sys_page_alloc: %e", r);
  801360:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801364:	c7 44 24 08 09 34 80 	movl   $0x803409,0x8(%esp)
  80136b:	00 
  80136c:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  801373:	00 
  801374:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  80137b:	e8 9e ef ff ff       	call   80031e <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801380:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801387:	00 
  801388:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  80138f:	00 
  801390:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801397:	00 
  801398:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80139c:	89 34 24             	mov    %esi,(%esp)
  80139f:	e8 b5 fb ff ff       	call   800f59 <sys_page_map>
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	79 20                	jns    8013c8 <sf_stack_duppage+0x8e>
		panic("sys_page_map: %e", r);
  8013a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ac:	c7 44 24 08 1c 34 80 	movl   $0x80341c,0x8(%esp)
  8013b3:	00 
  8013b4:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8013bb:	00 
  8013bc:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  8013c3:	e8 56 ef ff ff       	call   80031e <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8013c8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8013cf:	00 
  8013d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013d4:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8013db:	e8 54 f8 ff ff       	call   800c34 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8013e0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8013e7:	00 
  8013e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ef:	e8 b8 fb ff ff       	call   800fac <sys_page_unmap>
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	79 20                	jns    801418 <sf_stack_duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8013f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013fc:	c7 44 24 08 2d 34 80 	movl   $0x80342d,0x8(%esp)
  801403:	00 
  801404:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80140b:	00 
  80140c:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  801413:	e8 06 ef ff ff       	call   80031e <_panic>

}
  801418:	83 c4 20             	add    $0x20,%esp
  80141b:	5b                   	pop    %ebx
  80141c:	5e                   	pop    %esi
  80141d:	5d                   	pop    %ebp
  80141e:	c3                   	ret    

0080141f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	57                   	push   %edi
  801423:	56                   	push   %esi
  801424:	53                   	push   %ebx
  801425:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;
	//cprintf("\nin fork envid:%x\n", thisenv->env_id);
	set_pgfault_handler(pgfault);
  801428:	c7 04 24 0e 12 80 00 	movl   $0x80120e,(%esp)
  80142f:	e8 e2 16 00 00       	call   802b16 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801434:	b8 08 00 00 00       	mov    $0x8,%eax
  801439:	cd 30                	int    $0x30
  80143b:	89 c6                	mov    %eax,%esi
  80143d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if((envid=sys_exofork())<0)
  801440:	85 c0                	test   %eax,%eax
  801442:	79 20                	jns    801464 <fork+0x45>
		panic("\nCannot create a child process:%e\n",envid);
  801444:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801448:	c7 44 24 08 64 34 80 	movl   $0x803464,0x8(%esp)
  80144f:	00 
  801450:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  801457:	00 
  801458:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  80145f:	e8 ba ee ff ff       	call   80031e <_panic>
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801464:	bb 00 00 00 00       	mov    $0x0,%ebx
  801469:	85 c0                	test   %eax,%eax
  80146b:	75 21                	jne    80148e <fork+0x6f>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80146d:	e8 55 fa ff ff       	call   800ec7 <sys_getenvid>
  801472:	25 ff 03 00 00       	and    $0x3ff,%eax
  801477:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80147a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80147f:	a3 08 50 80 00       	mov    %eax,0x805008
		//set_pgfault_handler(pgfault);
		return 0;
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
  801489:	e9 88 01 00 00       	jmp    801616 <fork+0x1f7>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  80148e:	89 d8                	mov    %ebx,%eax
  801490:	c1 e8 16             	shr    $0x16,%eax
  801493:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80149a:	a8 01                	test   $0x1,%al
  80149c:	0f 84 e0 00 00 00    	je     801582 <fork+0x163>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8014a2:	89 df                	mov    %ebx,%edi
  8014a4:	c1 ef 0c             	shr    $0xc,%edi
  8014a7:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
  8014ae:	a8 01                	test   $0x1,%al
  8014b0:	0f 84 c4 00 00 00    	je     80157a <fork+0x15b>
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	int next_check = 1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  8014b6:	8b 04 bd 00 00 40 ef 	mov    -0x10c00000(,%edi,4),%eax
	//need to check whether the entry is write or cow orread
	///cprintf("\norig perm:%x\n",PGOFF(addr));

	if((addr & PTE_SYSCALL) & PTE_SHARE){
  8014bd:	f6 c4 04             	test   $0x4,%ah
  8014c0:	74 0d                	je     8014cf <fork+0xb0>
		perm |= (addr & PTE_SYSCALL); //not sure whether to and with fff or PTE_SYSCALL
  8014c2:	25 07 0e 00 00       	and    $0xe07,%eax
  8014c7:	83 c8 05             	or     $0x5,%eax
  8014ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014cd:	eb 1b                	jmp    8014ea <fork+0xcb>
		next_check=0;
	}

	if(((addr & PTE_W) || (addr & PTE_COW)) & next_check)
  8014cf:	25 02 08 00 00       	and    $0x802,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
  8014d4:	83 f8 01             	cmp    $0x1,%eax
  8014d7:	19 c0                	sbb    %eax,%eax
  8014d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014dc:	81 65 e4 00 f8 ff ff 	andl   $0xfffff800,-0x1c(%ebp)
  8014e3:	81 45 e4 05 08 00 00 	addl   $0x805,-0x1c(%ebp)
		perm |= PTE_COW;
	}

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  8014ea:	c1 e7 0c             	shl    $0xc,%edi
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	//eid = sys_getenvid();
	//cprintf("\nchecking source - envid:%d - %d.\ndestn:%d", eid, thisenv->env_id, envid);
	//cprintf("add:%p envid:%d",addr, thisenv->env_id);
	//So in dest envid we have create page table entry mapping 
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  8014ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014f4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ff:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801503:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80150a:	e8 4a fa ff ff       	call   800f59 <sys_page_map>
  80150f:	85 c0                	test   %eax,%eax
  801511:	79 20                	jns    801533 <fork+0x114>
		panic("sys_page_map: %e", r);
  801513:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801517:	c7 44 24 08 1c 34 80 	movl   $0x80341c,0x8(%esp)
  80151e:	00 
  80151f:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  801526:	00 
  801527:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  80152e:	e8 eb ed ff ff       	call   80031e <_panic>
	if ((r = sys_page_map(0, (void *)addr, 0, (void *)addr, perm)) < 0)
  801533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801536:	89 44 24 10          	mov    %eax,0x10(%esp)
  80153a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80153e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801545:	00 
  801546:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80154a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801551:	e8 03 fa ff ff       	call   800f59 <sys_page_map>
  801556:	85 c0                	test   %eax,%eax
  801558:	79 20                	jns    80157a <fork+0x15b>
		panic("sys_page_map: %e", r);
  80155a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80155e:	c7 44 24 08 1c 34 80 	movl   $0x80341c,0x8(%esp)
  801565:	00 
  801566:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  80156d:	00 
  80156e:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  801575:	e8 a4 ed ff ff       	call   80031e <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  80157a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801580:	eb 06                	jmp    801588 <fork+0x169>
		}
		else
		{
			addr = addr + PTSIZE;
  801582:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		//set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(UXSTACKTOP-PGSIZE))
  801588:	81 fb ff ef bf ee    	cmp    $0xeebfefff,%ebx
  80158e:	0f 86 fa fe ff ff    	jbe    80148e <fork+0x6f>
		{
			addr = addr + PTSIZE;
		}
	}

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801594:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80159b:	00 
  80159c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8015a3:	ee 
  8015a4:	89 34 24             	mov    %esi,(%esp)
  8015a7:	e8 59 f9 ff ff       	call   800f05 <sys_page_alloc>
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	79 20                	jns    8015d0 <fork+0x1b1>
		panic("sys_page_alloc: %e", r);
  8015b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015b4:	c7 44 24 08 09 34 80 	movl   $0x803409,0x8(%esp)
  8015bb:	00 
  8015bc:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  8015c3:	00 
  8015c4:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  8015cb:	e8 4e ed ff ff       	call   80031e <_panic>
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8015d0:	c7 44 24 04 a9 2b 80 	movl   $0x802ba9,0x4(%esp)
  8015d7:	00 
  8015d8:	89 34 24             	mov    %esi,(%esp)
  8015db:	e8 e5 fa ff ff       	call   8010c5 <sys_env_set_pgfault_upcall>
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	79 20                	jns    801604 <fork+0x1e5>
		panic("pagefault upcall setup error: %e", r);
  8015e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015e8:	c7 44 24 08 88 34 80 	movl   $0x803488,0x8(%esp)
  8015ef:	00 
  8015f0:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  8015f7:	00 
  8015f8:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  8015ff:	e8 1a ed ff ff       	call   80031e <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  801604:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80160b:	00 
  80160c:	89 34 24             	mov    %esi,(%esp)
  80160f:	e8 0b fa ff ff       	call   80101f <sys_env_set_status>
	//cprintf("\n fork exiting - envid:%x\n",thisenv->env_id);
	return envid;
  801614:	89 f0                	mov    %esi,%eax

}
  801616:	83 c4 2c             	add    $0x2c,%esp
  801619:	5b                   	pop    %ebx
  80161a:	5e                   	pop    %esi
  80161b:	5f                   	pop    %edi
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    

0080161e <sfork>:

// Challenge!
int
sfork(void)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	57                   	push   %edi
  801622:	56                   	push   %esi
  801623:	53                   	push   %ebx
  801624:	83 ec 2c             	sub    $0x2c,%esp
	pde_t pdentry=0;
	uintptr_t addr=0;
	int pdindex = 0, pte_perm=0, pte_loop=0;
	int r=-1;

	set_pgfault_handler(pgfault);
  801627:	c7 04 24 0e 12 80 00 	movl   $0x80120e,(%esp)
  80162e:	e8 e3 14 00 00       	call   802b16 <set_pgfault_handler>
  801633:	b8 08 00 00 00       	mov    $0x8,%eax
  801638:	cd 30                	int    $0x30
  80163a:	89 c6                	mov    %eax,%esi
	if((envid=sys_exofork())<0)
  80163c:	85 c0                	test   %eax,%eax
  80163e:	79 20                	jns    801660 <sfork+0x42>
		panic("\nCannot create a child process:%e\n",envid);
  801640:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801644:	c7 44 24 08 64 34 80 	movl   $0x803464,0x8(%esp)
  80164b:	00 
  80164c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  801653:	00 
  801654:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  80165b:	e8 be ec ff ff       	call   80031e <_panic>
  801660:	89 c7                	mov    %eax,%edi
	//cprintf("\nenvid of newly created child:%x\n",envid);
	if (envid == 0) {
  801662:	bb 00 00 00 00       	mov    $0x0,%ebx
  801667:	85 c0                	test   %eax,%eax
  801669:	75 2d                	jne    801698 <sfork+0x7a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  80166b:	e8 57 f8 ff ff       	call   800ec7 <sys_getenvid>
  801670:	25 ff 03 00 00       	and    $0x3ff,%eax
  801675:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801678:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80167d:	a3 08 50 80 00       	mov    %eax,0x805008
		set_pgfault_handler(pgfault);
  801682:	c7 04 24 0e 12 80 00 	movl   $0x80120e,(%esp)
  801689:	e8 88 14 00 00       	call   802b16 <set_pgfault_handler>
		return 0;
  80168e:	b8 00 00 00 00       	mov    $0x0,%eax
  801693:	e9 1d 01 00 00       	jmp    8017b5 <sfork+0x197>
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
	{
		//cprintf("parent address:%x",addr);
		if(uvpd[PDX(addr)] & PTE_P)
  801698:	89 d8                	mov    %ebx,%eax
  80169a:	c1 e8 16             	shr    $0x16,%eax
  80169d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016a4:	a8 01                	test   $0x1,%al
  8016a6:	74 69                	je     801711 <sfork+0xf3>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8016a8:	89 d8                	mov    %ebx,%eax
  8016aa:	c1 e8 0c             	shr    $0xc,%eax
  8016ad:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016b4:	f6 c2 01             	test   $0x1,%dl
  8016b7:	74 50                	je     801709 <sfork+0xeb>
	int r;
	int perm = PTE_P|PTE_U;  //this will keep genuine read as read ony pages. Neither child or parent can edit it.
	uintptr_t addr;
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
  8016b9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	
	perm = PGOFF(addr) & PTE_SYSCALL;

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
  8016c0:	c1 e0 0c             	shl    $0xc,%eax
	envid_t eid=-1;
	//extract the the page table entry from uvpt to check the permissions of page mapped at virtual address pn*PGSIZE
	addr = uvpt[pn]; //page table entry for the page(data page)
	//need to check whether the entry is write or cow orread
	
	perm = PGOFF(addr) & PTE_SYSCALL;
  8016c3:	81 e2 07 0e 00 00    	and    $0xe07,%edx

	//realligning the virtual address to page boundary
	//basically shifting 12 bits to left to make it correct virtual address
	addr = pn *PGSIZE;
	//cprintf("\nperm:%x \npn:%p \naddr:%p\n",perm, pn, addr);
	if ((r = sys_page_map(0, (void *)addr, envid, (void *)addr, perm)) < 0)
  8016c9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016d1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8016d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e0:	e8 74 f8 ff ff       	call   800f59 <sys_page_map>
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	79 20                	jns    801709 <sfork+0xeb>
		panic("sys_page_map: %e", r);
  8016e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016ed:	c7 44 24 08 1c 34 80 	movl   $0x80341c,0x8(%esp)
  8016f4:	00 
  8016f5:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  8016fc:	00 
  8016fd:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  801704:	e8 15 ec ff ff       	call   80031e <_panic>
			if(uvpt[PGNUM(addr)] & PTE_P)
			{
				//cprintf("\ncalling duppgae for address %x\n",addr);
				s_duppage(envid, PGNUM(addr));
			}
			addr += PGSIZE;
  801709:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80170f:	eb 06                	jmp    801717 <sfork+0xf9>
		}
		else
		{
			addr = addr + PTSIZE;
  801711:	81 c3 00 00 40 00    	add    $0x400000,%ebx
		set_pgfault_handler(pgfault);
		return 0;
	}
	//Incrementing by PGSIZE in loop because 1 page of pgsize corresponds to 1 page taable entry
	//Incrementing the address by 4MB because uvpd has no entry means 1 uvpd->4 MB region so need to skip it.
	while(addr<(USTACKTOP-PGSIZE))
  801717:	81 fb ff cf bf ee    	cmp    $0xeebfcfff,%ebx
  80171d:	0f 86 75 ff ff ff    	jbe    801698 <sfork+0x7a>
		{
			addr = addr + PTSIZE;
		}
	}

	sf_stack_duppage(envid, (void *)USTACKTOP-PGSIZE);
  801723:	c7 44 24 04 00 d0 bf 	movl   $0xeebfd000,0x4(%esp)
  80172a:	ee 
  80172b:	89 34 24             	mov    %esi,(%esp)
  80172e:	e8 07 fc ff ff       	call   80133a <sf_stack_duppage>
			s_duppage(envid, PGNUM(addr));
		}
		addr += PGSIZE;
	}*/

	if ((r = sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801733:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80173a:	00 
  80173b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801742:	ee 
  801743:	89 34 24             	mov    %esi,(%esp)
  801746:	e8 ba f7 ff ff       	call   800f05 <sys_page_alloc>
  80174b:	85 c0                	test   %eax,%eax
  80174d:	79 20                	jns    80176f <sfork+0x151>
		panic("sys_page_alloc: %e", r);
  80174f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801753:	c7 44 24 08 09 34 80 	movl   $0x803409,0x8(%esp)
  80175a:	00 
  80175b:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  801762:	00 
  801763:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  80176a:	e8 af eb ff ff       	call   80031e <_panic>

	
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80176f:	c7 44 24 04 a9 2b 80 	movl   $0x802ba9,0x4(%esp)
  801776:	00 
  801777:	89 34 24             	mov    %esi,(%esp)
  80177a:	e8 46 f9 ff ff       	call   8010c5 <sys_env_set_pgfault_upcall>
  80177f:	85 c0                	test   %eax,%eax
  801781:	79 20                	jns    8017a3 <sfork+0x185>
		panic("pagefault upcall setup error: %e", r);
  801783:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801787:	c7 44 24 08 88 34 80 	movl   $0x803488,0x8(%esp)
  80178e:	00 
  80178f:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  801796:	00 
  801797:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  80179e:	e8 7b eb ff ff       	call   80031e <_panic>
	sys_env_set_status(envid, ENV_RUNNABLE);
  8017a3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8017aa:	00 
  8017ab:	89 34 24             	mov    %esi,(%esp)
  8017ae:	e8 6c f8 ff ff       	call   80101f <sys_env_set_status>
	return envid;
  8017b3:	89 f0                	mov    %esi,%eax

}
  8017b5:	83 c4 2c             	add    $0x2c,%esp
  8017b8:	5b                   	pop    %ebx
  8017b9:	5e                   	pop    %esi
  8017ba:	5f                   	pop    %edi
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    
  8017bd:	66 90                	xchg   %ax,%ax
  8017bf:	90                   	nop

008017c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8017cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8017ce:	5d                   	pop    %ebp
  8017cf:	c3                   	ret    

008017d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8017db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017e0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017e5:	5d                   	pop    %ebp
  8017e6:	c3                   	ret    

008017e7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ed:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017f2:	89 c2                	mov    %eax,%edx
  8017f4:	c1 ea 16             	shr    $0x16,%edx
  8017f7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017fe:	f6 c2 01             	test   $0x1,%dl
  801801:	74 11                	je     801814 <fd_alloc+0x2d>
  801803:	89 c2                	mov    %eax,%edx
  801805:	c1 ea 0c             	shr    $0xc,%edx
  801808:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80180f:	f6 c2 01             	test   $0x1,%dl
  801812:	75 09                	jne    80181d <fd_alloc+0x36>
			*fd_store = fd;
  801814:	89 01                	mov    %eax,(%ecx)
			return 0;
  801816:	b8 00 00 00 00       	mov    $0x0,%eax
  80181b:	eb 17                	jmp    801834 <fd_alloc+0x4d>
  80181d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801822:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801827:	75 c9                	jne    8017f2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801829:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80182f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    

00801836 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80183c:	83 f8 1f             	cmp    $0x1f,%eax
  80183f:	77 36                	ja     801877 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801841:	c1 e0 0c             	shl    $0xc,%eax
  801844:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801849:	89 c2                	mov    %eax,%edx
  80184b:	c1 ea 16             	shr    $0x16,%edx
  80184e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801855:	f6 c2 01             	test   $0x1,%dl
  801858:	74 24                	je     80187e <fd_lookup+0x48>
  80185a:	89 c2                	mov    %eax,%edx
  80185c:	c1 ea 0c             	shr    $0xc,%edx
  80185f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801866:	f6 c2 01             	test   $0x1,%dl
  801869:	74 1a                	je     801885 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80186b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186e:	89 02                	mov    %eax,(%edx)
	return 0;
  801870:	b8 00 00 00 00       	mov    $0x0,%eax
  801875:	eb 13                	jmp    80188a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801877:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80187c:	eb 0c                	jmp    80188a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80187e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801883:	eb 05                	jmp    80188a <fd_lookup+0x54>
  801885:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 18             	sub    $0x18,%esp
  801892:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801895:	ba 00 00 00 00       	mov    $0x0,%edx
  80189a:	eb 13                	jmp    8018af <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80189c:	39 08                	cmp    %ecx,(%eax)
  80189e:	75 0c                	jne    8018ac <dev_lookup+0x20>
			*dev = devtab[i];
  8018a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018aa:	eb 38                	jmp    8018e4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018ac:	83 c2 01             	add    $0x1,%edx
  8018af:	8b 04 95 28 35 80 00 	mov    0x803528(,%edx,4),%eax
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	75 e2                	jne    80189c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018ba:	a1 08 50 80 00       	mov    0x805008,%eax
  8018bf:	8b 40 48             	mov    0x48(%eax),%eax
  8018c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ca:	c7 04 24 ac 34 80 00 	movl   $0x8034ac,(%esp)
  8018d1:	e8 41 eb ff ff       	call   800417 <cprintf>
	*dev = 0;
  8018d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	56                   	push   %esi
  8018ea:	53                   	push   %ebx
  8018eb:	83 ec 20             	sub    $0x20,%esp
  8018ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8018f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801901:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801904:	89 04 24             	mov    %eax,(%esp)
  801907:	e8 2a ff ff ff       	call   801836 <fd_lookup>
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 05                	js     801915 <fd_close+0x2f>
	    || fd != fd2)
  801910:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801913:	74 0c                	je     801921 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801915:	84 db                	test   %bl,%bl
  801917:	ba 00 00 00 00       	mov    $0x0,%edx
  80191c:	0f 44 c2             	cmove  %edx,%eax
  80191f:	eb 3f                	jmp    801960 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801921:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801924:	89 44 24 04          	mov    %eax,0x4(%esp)
  801928:	8b 06                	mov    (%esi),%eax
  80192a:	89 04 24             	mov    %eax,(%esp)
  80192d:	e8 5a ff ff ff       	call   80188c <dev_lookup>
  801932:	89 c3                	mov    %eax,%ebx
  801934:	85 c0                	test   %eax,%eax
  801936:	78 16                	js     80194e <fd_close+0x68>
		if (dev->dev_close)
  801938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80193e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801943:	85 c0                	test   %eax,%eax
  801945:	74 07                	je     80194e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801947:	89 34 24             	mov    %esi,(%esp)
  80194a:	ff d0                	call   *%eax
  80194c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80194e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801952:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801959:	e8 4e f6 ff ff       	call   800fac <sys_page_unmap>
	return r;
  80195e:	89 d8                	mov    %ebx,%eax
}
  801960:	83 c4 20             	add    $0x20,%esp
  801963:	5b                   	pop    %ebx
  801964:	5e                   	pop    %esi
  801965:	5d                   	pop    %ebp
  801966:	c3                   	ret    

00801967 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80196d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801970:	89 44 24 04          	mov    %eax,0x4(%esp)
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	89 04 24             	mov    %eax,(%esp)
  80197a:	e8 b7 fe ff ff       	call   801836 <fd_lookup>
  80197f:	89 c2                	mov    %eax,%edx
  801981:	85 d2                	test   %edx,%edx
  801983:	78 13                	js     801998 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801985:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80198c:	00 
  80198d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801990:	89 04 24             	mov    %eax,(%esp)
  801993:	e8 4e ff ff ff       	call   8018e6 <fd_close>
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <close_all>:

void
close_all(void)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	53                   	push   %ebx
  80199e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019a6:	89 1c 24             	mov    %ebx,(%esp)
  8019a9:	e8 b9 ff ff ff       	call   801967 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8019ae:	83 c3 01             	add    $0x1,%ebx
  8019b1:	83 fb 20             	cmp    $0x20,%ebx
  8019b4:	75 f0                	jne    8019a6 <close_all+0xc>
		close(i);
}
  8019b6:	83 c4 14             	add    $0x14,%esp
  8019b9:	5b                   	pop    %ebx
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    

008019bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	57                   	push   %edi
  8019c0:	56                   	push   %esi
  8019c1:	53                   	push   %ebx
  8019c2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	89 04 24             	mov    %eax,(%esp)
  8019d2:	e8 5f fe ff ff       	call   801836 <fd_lookup>
  8019d7:	89 c2                	mov    %eax,%edx
  8019d9:	85 d2                	test   %edx,%edx
  8019db:	0f 88 e1 00 00 00    	js     801ac2 <dup+0x106>
		return r;
	close(newfdnum);
  8019e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e4:	89 04 24             	mov    %eax,(%esp)
  8019e7:	e8 7b ff ff ff       	call   801967 <close>

	newfd = INDEX2FD(newfdnum);
  8019ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019ef:	c1 e3 0c             	shl    $0xc,%ebx
  8019f2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8019f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019fb:	89 04 24             	mov    %eax,(%esp)
  8019fe:	e8 cd fd ff ff       	call   8017d0 <fd2data>
  801a03:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801a05:	89 1c 24             	mov    %ebx,(%esp)
  801a08:	e8 c3 fd ff ff       	call   8017d0 <fd2data>
  801a0d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a0f:	89 f0                	mov    %esi,%eax
  801a11:	c1 e8 16             	shr    $0x16,%eax
  801a14:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a1b:	a8 01                	test   $0x1,%al
  801a1d:	74 43                	je     801a62 <dup+0xa6>
  801a1f:	89 f0                	mov    %esi,%eax
  801a21:	c1 e8 0c             	shr    $0xc,%eax
  801a24:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a2b:	f6 c2 01             	test   $0x1,%dl
  801a2e:	74 32                	je     801a62 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a30:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a37:	25 07 0e 00 00       	and    $0xe07,%eax
  801a3c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a40:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a44:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a4b:	00 
  801a4c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a57:	e8 fd f4 ff ff       	call   800f59 <sys_page_map>
  801a5c:	89 c6                	mov    %eax,%esi
  801a5e:	85 c0                	test   %eax,%eax
  801a60:	78 3e                	js     801aa0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a65:	89 c2                	mov    %eax,%edx
  801a67:	c1 ea 0c             	shr    $0xc,%edx
  801a6a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a71:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a77:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a7f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a86:	00 
  801a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a92:	e8 c2 f4 ff ff       	call   800f59 <sys_page_map>
  801a97:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801a99:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a9c:	85 f6                	test   %esi,%esi
  801a9e:	79 22                	jns    801ac2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801aa0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aa4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aab:	e8 fc f4 ff ff       	call   800fac <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ab0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ab4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801abb:	e8 ec f4 ff ff       	call   800fac <sys_page_unmap>
	return r;
  801ac0:	89 f0                	mov    %esi,%eax
}
  801ac2:	83 c4 3c             	add    $0x3c,%esp
  801ac5:	5b                   	pop    %ebx
  801ac6:	5e                   	pop    %esi
  801ac7:	5f                   	pop    %edi
  801ac8:	5d                   	pop    %ebp
  801ac9:	c3                   	ret    

00801aca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	53                   	push   %ebx
  801ace:	83 ec 24             	sub    $0x24,%esp
  801ad1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ad4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adb:	89 1c 24             	mov    %ebx,(%esp)
  801ade:	e8 53 fd ff ff       	call   801836 <fd_lookup>
  801ae3:	89 c2                	mov    %eax,%edx
  801ae5:	85 d2                	test   %edx,%edx
  801ae7:	78 6d                	js     801b56 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af3:	8b 00                	mov    (%eax),%eax
  801af5:	89 04 24             	mov    %eax,(%esp)
  801af8:	e8 8f fd ff ff       	call   80188c <dev_lookup>
  801afd:	85 c0                	test   %eax,%eax
  801aff:	78 55                	js     801b56 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b04:	8b 50 08             	mov    0x8(%eax),%edx
  801b07:	83 e2 03             	and    $0x3,%edx
  801b0a:	83 fa 01             	cmp    $0x1,%edx
  801b0d:	75 23                	jne    801b32 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b0f:	a1 08 50 80 00       	mov    0x805008,%eax
  801b14:	8b 40 48             	mov    0x48(%eax),%eax
  801b17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1f:	c7 04 24 ed 34 80 00 	movl   $0x8034ed,(%esp)
  801b26:	e8 ec e8 ff ff       	call   800417 <cprintf>
		return -E_INVAL;
  801b2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b30:	eb 24                	jmp    801b56 <read+0x8c>
	}
	if (!dev->dev_read)
  801b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b35:	8b 52 08             	mov    0x8(%edx),%edx
  801b38:	85 d2                	test   %edx,%edx
  801b3a:	74 15                	je     801b51 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b4a:	89 04 24             	mov    %eax,(%esp)
  801b4d:	ff d2                	call   *%edx
  801b4f:	eb 05                	jmp    801b56 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801b51:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801b56:	83 c4 24             	add    $0x24,%esp
  801b59:	5b                   	pop    %ebx
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    

00801b5c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	57                   	push   %edi
  801b60:	56                   	push   %esi
  801b61:	53                   	push   %ebx
  801b62:	83 ec 1c             	sub    $0x1c,%esp
  801b65:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b68:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b70:	eb 23                	jmp    801b95 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b72:	89 f0                	mov    %esi,%eax
  801b74:	29 d8                	sub    %ebx,%eax
  801b76:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b7a:	89 d8                	mov    %ebx,%eax
  801b7c:	03 45 0c             	add    0xc(%ebp),%eax
  801b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b83:	89 3c 24             	mov    %edi,(%esp)
  801b86:	e8 3f ff ff ff       	call   801aca <read>
		if (m < 0)
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	78 10                	js     801b9f <readn+0x43>
			return m;
		if (m == 0)
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	74 0a                	je     801b9d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b93:	01 c3                	add    %eax,%ebx
  801b95:	39 f3                	cmp    %esi,%ebx
  801b97:	72 d9                	jb     801b72 <readn+0x16>
  801b99:	89 d8                	mov    %ebx,%eax
  801b9b:	eb 02                	jmp    801b9f <readn+0x43>
  801b9d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b9f:	83 c4 1c             	add    $0x1c,%esp
  801ba2:	5b                   	pop    %ebx
  801ba3:	5e                   	pop    %esi
  801ba4:	5f                   	pop    %edi
  801ba5:	5d                   	pop    %ebp
  801ba6:	c3                   	ret    

00801ba7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	53                   	push   %ebx
  801bab:	83 ec 24             	sub    $0x24,%esp
  801bae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb8:	89 1c 24             	mov    %ebx,(%esp)
  801bbb:	e8 76 fc ff ff       	call   801836 <fd_lookup>
  801bc0:	89 c2                	mov    %eax,%edx
  801bc2:	85 d2                	test   %edx,%edx
  801bc4:	78 68                	js     801c2e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd0:	8b 00                	mov    (%eax),%eax
  801bd2:	89 04 24             	mov    %eax,(%esp)
  801bd5:	e8 b2 fc ff ff       	call   80188c <dev_lookup>
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	78 50                	js     801c2e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801be5:	75 23                	jne    801c0a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801be7:	a1 08 50 80 00       	mov    0x805008,%eax
  801bec:	8b 40 48             	mov    0x48(%eax),%eax
  801bef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf7:	c7 04 24 09 35 80 00 	movl   $0x803509,(%esp)
  801bfe:	e8 14 e8 ff ff       	call   800417 <cprintf>
		return -E_INVAL;
  801c03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c08:	eb 24                	jmp    801c2e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c0d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c10:	85 d2                	test   %edx,%edx
  801c12:	74 15                	je     801c29 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c22:	89 04 24             	mov    %eax,(%esp)
  801c25:	ff d2                	call   *%edx
  801c27:	eb 05                	jmp    801c2e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801c29:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801c2e:	83 c4 24             	add    $0x24,%esp
  801c31:	5b                   	pop    %ebx
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    

00801c34 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c3a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	89 04 24             	mov    %eax,(%esp)
  801c47:	e8 ea fb ff ff       	call   801836 <fd_lookup>
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	78 0e                	js     801c5e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801c50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c56:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	53                   	push   %ebx
  801c64:	83 ec 24             	sub    $0x24,%esp
  801c67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c6a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c71:	89 1c 24             	mov    %ebx,(%esp)
  801c74:	e8 bd fb ff ff       	call   801836 <fd_lookup>
  801c79:	89 c2                	mov    %eax,%edx
  801c7b:	85 d2                	test   %edx,%edx
  801c7d:	78 61                	js     801ce0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c82:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c89:	8b 00                	mov    (%eax),%eax
  801c8b:	89 04 24             	mov    %eax,(%esp)
  801c8e:	e8 f9 fb ff ff       	call   80188c <dev_lookup>
  801c93:	85 c0                	test   %eax,%eax
  801c95:	78 49                	js     801ce0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c9e:	75 23                	jne    801cc3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801ca0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ca5:	8b 40 48             	mov    0x48(%eax),%eax
  801ca8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb0:	c7 04 24 cc 34 80 00 	movl   $0x8034cc,(%esp)
  801cb7:	e8 5b e7 ff ff       	call   800417 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801cbc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cc1:	eb 1d                	jmp    801ce0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc6:	8b 52 18             	mov    0x18(%edx),%edx
  801cc9:	85 d2                	test   %edx,%edx
  801ccb:	74 0e                	je     801cdb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ccd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cd0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cd4:	89 04 24             	mov    %eax,(%esp)
  801cd7:	ff d2                	call   *%edx
  801cd9:	eb 05                	jmp    801ce0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801cdb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801ce0:	83 c4 24             	add    $0x24,%esp
  801ce3:	5b                   	pop    %ebx
  801ce4:	5d                   	pop    %ebp
  801ce5:	c3                   	ret    

00801ce6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	53                   	push   %ebx
  801cea:	83 ec 24             	sub    $0x24,%esp
  801ced:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cf0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	89 04 24             	mov    %eax,(%esp)
  801cfd:	e8 34 fb ff ff       	call   801836 <fd_lookup>
  801d02:	89 c2                	mov    %eax,%edx
  801d04:	85 d2                	test   %edx,%edx
  801d06:	78 52                	js     801d5a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d12:	8b 00                	mov    (%eax),%eax
  801d14:	89 04 24             	mov    %eax,(%esp)
  801d17:	e8 70 fb ff ff       	call   80188c <dev_lookup>
  801d1c:	85 c0                	test   %eax,%eax
  801d1e:	78 3a                	js     801d5a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d23:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d27:	74 2c                	je     801d55 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d29:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d2c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d33:	00 00 00 
	stat->st_isdir = 0;
  801d36:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d3d:	00 00 00 
	stat->st_dev = dev;
  801d40:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d4d:	89 14 24             	mov    %edx,(%esp)
  801d50:	ff 50 14             	call   *0x14(%eax)
  801d53:	eb 05                	jmp    801d5a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801d55:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801d5a:	83 c4 24             	add    $0x24,%esp
  801d5d:	5b                   	pop    %ebx
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    

00801d60 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	56                   	push   %esi
  801d64:	53                   	push   %ebx
  801d65:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d6f:	00 
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	89 04 24             	mov    %eax,(%esp)
  801d76:	e8 99 02 00 00       	call   802014 <open>
  801d7b:	89 c3                	mov    %eax,%ebx
  801d7d:	85 db                	test   %ebx,%ebx
  801d7f:	78 1b                	js     801d9c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d88:	89 1c 24             	mov    %ebx,(%esp)
  801d8b:	e8 56 ff ff ff       	call   801ce6 <fstat>
  801d90:	89 c6                	mov    %eax,%esi
	close(fd);
  801d92:	89 1c 24             	mov    %ebx,(%esp)
  801d95:	e8 cd fb ff ff       	call   801967 <close>
	return r;
  801d9a:	89 f0                	mov    %esi,%eax
}
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	5b                   	pop    %ebx
  801da0:	5e                   	pop    %esi
  801da1:	5d                   	pop    %ebp
  801da2:	c3                   	ret    

00801da3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	56                   	push   %esi
  801da7:	53                   	push   %ebx
  801da8:	83 ec 10             	sub    $0x10,%esp
  801dab:	89 c6                	mov    %eax,%esi
  801dad:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801daf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801db6:	75 11                	jne    801dc9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801db8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801dbf:	e8 db 0e 00 00       	call   802c9f <ipc_find_env>
  801dc4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801dc9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801dd0:	00 
  801dd1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801dd8:	00 
  801dd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ddd:	a1 00 50 80 00       	mov    0x805000,%eax
  801de2:	89 04 24             	mov    %eax,(%esp)
  801de5:	e8 4e 0e 00 00       	call   802c38 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801dea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801df1:	00 
  801df2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801df6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dfd:	e8 ce 0d 00 00       	call   802bd0 <ipc_recv>
}
  801e02:	83 c4 10             	add    $0x10,%esp
  801e05:	5b                   	pop    %ebx
  801e06:	5e                   	pop    %esi
  801e07:	5d                   	pop    %ebp
  801e08:	c3                   	ret    

00801e09 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	8b 40 0c             	mov    0xc(%eax),%eax
  801e15:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e22:	ba 00 00 00 00       	mov    $0x0,%edx
  801e27:	b8 02 00 00 00       	mov    $0x2,%eax
  801e2c:	e8 72 ff ff ff       	call   801da3 <fsipc>
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e3f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e44:	ba 00 00 00 00       	mov    $0x0,%edx
  801e49:	b8 06 00 00 00       	mov    $0x6,%eax
  801e4e:	e8 50 ff ff ff       	call   801da3 <fsipc>
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	53                   	push   %ebx
  801e59:	83 ec 14             	sub    $0x14,%esp
  801e5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	8b 40 0c             	mov    0xc(%eax),%eax
  801e65:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6f:	b8 05 00 00 00       	mov    $0x5,%eax
  801e74:	e8 2a ff ff ff       	call   801da3 <fsipc>
  801e79:	89 c2                	mov    %eax,%edx
  801e7b:	85 d2                	test   %edx,%edx
  801e7d:	78 2b                	js     801eaa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e7f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e86:	00 
  801e87:	89 1c 24             	mov    %ebx,(%esp)
  801e8a:	e8 08 ec ff ff       	call   800a97 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e8f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e94:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e9a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e9f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eaa:	83 c4 14             	add    $0x14,%esp
  801ead:	5b                   	pop    %ebx
  801eae:	5d                   	pop    %ebp
  801eaf:	c3                   	ret    

00801eb0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	53                   	push   %ebx
  801eb4:	83 ec 14             	sub    $0x14,%esp
  801eb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801eba:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801ec0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801ec5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  801ecb:	8b 52 0c             	mov    0xc(%edx),%edx
  801ece:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801ed4:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801ed9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee4:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801eeb:	e8 44 ed ff ff       	call   800c34 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801ef0:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801ef7:	00 
  801ef8:	c7 04 24 3c 35 80 00 	movl   $0x80353c,(%esp)
  801eff:	e8 13 e5 ff ff       	call   800417 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f04:	ba 00 00 00 00       	mov    $0x0,%edx
  801f09:	b8 04 00 00 00       	mov    $0x4,%eax
  801f0e:	e8 90 fe ff ff       	call   801da3 <fsipc>
  801f13:	85 c0                	test   %eax,%eax
  801f15:	78 53                	js     801f6a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801f17:	39 c3                	cmp    %eax,%ebx
  801f19:	73 24                	jae    801f3f <devfile_write+0x8f>
  801f1b:	c7 44 24 0c 41 35 80 	movl   $0x803541,0xc(%esp)
  801f22:	00 
  801f23:	c7 44 24 08 48 35 80 	movl   $0x803548,0x8(%esp)
  801f2a:	00 
  801f2b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801f32:	00 
  801f33:	c7 04 24 5d 35 80 00 	movl   $0x80355d,(%esp)
  801f3a:	e8 df e3 ff ff       	call   80031e <_panic>
	assert(r <= PGSIZE);
  801f3f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f44:	7e 24                	jle    801f6a <devfile_write+0xba>
  801f46:	c7 44 24 0c 68 35 80 	movl   $0x803568,0xc(%esp)
  801f4d:	00 
  801f4e:	c7 44 24 08 48 35 80 	movl   $0x803548,0x8(%esp)
  801f55:	00 
  801f56:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801f5d:	00 
  801f5e:	c7 04 24 5d 35 80 00 	movl   $0x80355d,(%esp)
  801f65:	e8 b4 e3 ff ff       	call   80031e <_panic>
	return r;
}
  801f6a:	83 c4 14             	add    $0x14,%esp
  801f6d:	5b                   	pop    %ebx
  801f6e:	5d                   	pop    %ebp
  801f6f:	c3                   	ret    

00801f70 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	56                   	push   %esi
  801f74:	53                   	push   %ebx
  801f75:	83 ec 10             	sub    $0x10,%esp
  801f78:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f81:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f86:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f91:	b8 03 00 00 00       	mov    $0x3,%eax
  801f96:	e8 08 fe ff ff       	call   801da3 <fsipc>
  801f9b:	89 c3                	mov    %eax,%ebx
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	78 6a                	js     80200b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801fa1:	39 c6                	cmp    %eax,%esi
  801fa3:	73 24                	jae    801fc9 <devfile_read+0x59>
  801fa5:	c7 44 24 0c 41 35 80 	movl   $0x803541,0xc(%esp)
  801fac:	00 
  801fad:	c7 44 24 08 48 35 80 	movl   $0x803548,0x8(%esp)
  801fb4:	00 
  801fb5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801fbc:	00 
  801fbd:	c7 04 24 5d 35 80 00 	movl   $0x80355d,(%esp)
  801fc4:	e8 55 e3 ff ff       	call   80031e <_panic>
	assert(r <= PGSIZE);
  801fc9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fce:	7e 24                	jle    801ff4 <devfile_read+0x84>
  801fd0:	c7 44 24 0c 68 35 80 	movl   $0x803568,0xc(%esp)
  801fd7:	00 
  801fd8:	c7 44 24 08 48 35 80 	movl   $0x803548,0x8(%esp)
  801fdf:	00 
  801fe0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801fe7:	00 
  801fe8:	c7 04 24 5d 35 80 00 	movl   $0x80355d,(%esp)
  801fef:	e8 2a e3 ff ff       	call   80031e <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ff4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ff8:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fff:	00 
  802000:	8b 45 0c             	mov    0xc(%ebp),%eax
  802003:	89 04 24             	mov    %eax,(%esp)
  802006:	e8 29 ec ff ff       	call   800c34 <memmove>
	return r;
}
  80200b:	89 d8                	mov    %ebx,%eax
  80200d:	83 c4 10             	add    $0x10,%esp
  802010:	5b                   	pop    %ebx
  802011:	5e                   	pop    %esi
  802012:	5d                   	pop    %ebp
  802013:	c3                   	ret    

00802014 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	53                   	push   %ebx
  802018:	83 ec 24             	sub    $0x24,%esp
  80201b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80201e:	89 1c 24             	mov    %ebx,(%esp)
  802021:	e8 3a ea ff ff       	call   800a60 <strlen>
  802026:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80202b:	7f 60                	jg     80208d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80202d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802030:	89 04 24             	mov    %eax,(%esp)
  802033:	e8 af f7 ff ff       	call   8017e7 <fd_alloc>
  802038:	89 c2                	mov    %eax,%edx
  80203a:	85 d2                	test   %edx,%edx
  80203c:	78 54                	js     802092 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80203e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802042:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802049:	e8 49 ea ff ff       	call   800a97 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80204e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802051:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802059:	b8 01 00 00 00       	mov    $0x1,%eax
  80205e:	e8 40 fd ff ff       	call   801da3 <fsipc>
  802063:	89 c3                	mov    %eax,%ebx
  802065:	85 c0                	test   %eax,%eax
  802067:	79 17                	jns    802080 <open+0x6c>
		fd_close(fd, 0);
  802069:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802070:	00 
  802071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802074:	89 04 24             	mov    %eax,(%esp)
  802077:	e8 6a f8 ff ff       	call   8018e6 <fd_close>
		return r;
  80207c:	89 d8                	mov    %ebx,%eax
  80207e:	eb 12                	jmp    802092 <open+0x7e>
	}

	return fd2num(fd);
  802080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802083:	89 04 24             	mov    %eax,(%esp)
  802086:	e8 35 f7 ff ff       	call   8017c0 <fd2num>
  80208b:	eb 05                	jmp    802092 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80208d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802092:	83 c4 24             	add    $0x24,%esp
  802095:	5b                   	pop    %ebx
  802096:	5d                   	pop    %ebp
  802097:	c3                   	ret    

00802098 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80209e:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a3:	b8 08 00 00 00       	mov    $0x8,%eax
  8020a8:	e8 f6 fc ff ff       	call   801da3 <fsipc>
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <evict>:

int evict(void)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  8020b5:	c7 04 24 74 35 80 00 	movl   $0x803574,(%esp)
  8020bc:	e8 56 e3 ff ff       	call   800417 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  8020c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c6:	b8 09 00 00 00       	mov    $0x9,%eax
  8020cb:	e8 d3 fc ff ff       	call   801da3 <fsipc>
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    
  8020d2:	66 90                	xchg   %ax,%ax
  8020d4:	66 90                	xchg   %ax,%ax
  8020d6:	66 90                	xchg   %ax,%ax
  8020d8:	66 90                	xchg   %ax,%ax
  8020da:	66 90                	xchg   %ax,%ax
  8020dc:	66 90                	xchg   %ax,%ax
  8020de:	66 90                	xchg   %ax,%ax

008020e0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8020e6:	c7 44 24 04 8d 35 80 	movl   $0x80358d,0x4(%esp)
  8020ed:	00 
  8020ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f1:	89 04 24             	mov    %eax,(%esp)
  8020f4:	e8 9e e9 ff ff       	call   800a97 <strcpy>
	return 0;
}
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	53                   	push   %ebx
  802104:	83 ec 14             	sub    $0x14,%esp
  802107:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80210a:	89 1c 24             	mov    %ebx,(%esp)
  80210d:	e8 c5 0b 00 00       	call   802cd7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802112:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802117:	83 f8 01             	cmp    $0x1,%eax
  80211a:	75 0d                	jne    802129 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80211c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80211f:	89 04 24             	mov    %eax,(%esp)
  802122:	e8 29 03 00 00       	call   802450 <nsipc_close>
  802127:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802129:	89 d0                	mov    %edx,%eax
  80212b:	83 c4 14             	add    $0x14,%esp
  80212e:	5b                   	pop    %ebx
  80212f:	5d                   	pop    %ebp
  802130:	c3                   	ret    

00802131 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802137:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80213e:	00 
  80213f:	8b 45 10             	mov    0x10(%ebp),%eax
  802142:	89 44 24 08          	mov    %eax,0x8(%esp)
  802146:	8b 45 0c             	mov    0xc(%ebp),%eax
  802149:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	8b 40 0c             	mov    0xc(%eax),%eax
  802153:	89 04 24             	mov    %eax,(%esp)
  802156:	e8 f0 03 00 00       	call   80254b <nsipc_send>
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802163:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80216a:	00 
  80216b:	8b 45 10             	mov    0x10(%ebp),%eax
  80216e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802172:	8b 45 0c             	mov    0xc(%ebp),%eax
  802175:	89 44 24 04          	mov    %eax,0x4(%esp)
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	8b 40 0c             	mov    0xc(%eax),%eax
  80217f:	89 04 24             	mov    %eax,(%esp)
  802182:	e8 44 03 00 00       	call   8024cb <nsipc_recv>
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80218f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802192:	89 54 24 04          	mov    %edx,0x4(%esp)
  802196:	89 04 24             	mov    %eax,(%esp)
  802199:	e8 98 f6 ff ff       	call   801836 <fd_lookup>
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	78 17                	js     8021b9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8021ab:	39 08                	cmp    %ecx,(%eax)
  8021ad:	75 05                	jne    8021b4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8021af:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b2:	eb 05                	jmp    8021b9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8021b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	56                   	push   %esi
  8021bf:	53                   	push   %ebx
  8021c0:	83 ec 20             	sub    $0x20,%esp
  8021c3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c8:	89 04 24             	mov    %eax,(%esp)
  8021cb:	e8 17 f6 ff ff       	call   8017e7 <fd_alloc>
  8021d0:	89 c3                	mov    %eax,%ebx
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	78 21                	js     8021f7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8021d6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021dd:	00 
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ec:	e8 14 ed ff ff       	call   800f05 <sys_page_alloc>
  8021f1:	89 c3                	mov    %eax,%ebx
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	79 0c                	jns    802203 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8021f7:	89 34 24             	mov    %esi,(%esp)
  8021fa:	e8 51 02 00 00       	call   802450 <nsipc_close>
		return r;
  8021ff:	89 d8                	mov    %ebx,%eax
  802201:	eb 20                	jmp    802223 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802203:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80220e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802211:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802218:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80221b:	89 14 24             	mov    %edx,(%esp)
  80221e:	e8 9d f5 ff ff       	call   8017c0 <fd2num>
}
  802223:	83 c4 20             	add    $0x20,%esp
  802226:	5b                   	pop    %ebx
  802227:	5e                   	pop    %esi
  802228:	5d                   	pop    %ebp
  802229:	c3                   	ret    

0080222a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	e8 51 ff ff ff       	call   802189 <fd2sockid>
		return r;
  802238:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80223a:	85 c0                	test   %eax,%eax
  80223c:	78 23                	js     802261 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80223e:	8b 55 10             	mov    0x10(%ebp),%edx
  802241:	89 54 24 08          	mov    %edx,0x8(%esp)
  802245:	8b 55 0c             	mov    0xc(%ebp),%edx
  802248:	89 54 24 04          	mov    %edx,0x4(%esp)
  80224c:	89 04 24             	mov    %eax,(%esp)
  80224f:	e8 45 01 00 00       	call   802399 <nsipc_accept>
		return r;
  802254:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802256:	85 c0                	test   %eax,%eax
  802258:	78 07                	js     802261 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80225a:	e8 5c ff ff ff       	call   8021bb <alloc_sockfd>
  80225f:	89 c1                	mov    %eax,%ecx
}
  802261:	89 c8                	mov    %ecx,%eax
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	e8 16 ff ff ff       	call   802189 <fd2sockid>
  802273:	89 c2                	mov    %eax,%edx
  802275:	85 d2                	test   %edx,%edx
  802277:	78 16                	js     80228f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802279:	8b 45 10             	mov    0x10(%ebp),%eax
  80227c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802280:	8b 45 0c             	mov    0xc(%ebp),%eax
  802283:	89 44 24 04          	mov    %eax,0x4(%esp)
  802287:	89 14 24             	mov    %edx,(%esp)
  80228a:	e8 60 01 00 00       	call   8023ef <nsipc_bind>
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <shutdown>:

int
shutdown(int s, int how)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	e8 ea fe ff ff       	call   802189 <fd2sockid>
  80229f:	89 c2                	mov    %eax,%edx
  8022a1:	85 d2                	test   %edx,%edx
  8022a3:	78 0f                	js     8022b4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8022a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ac:	89 14 24             	mov    %edx,(%esp)
  8022af:	e8 7a 01 00 00       	call   80242e <nsipc_shutdown>
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	e8 c5 fe ff ff       	call   802189 <fd2sockid>
  8022c4:	89 c2                	mov    %eax,%edx
  8022c6:	85 d2                	test   %edx,%edx
  8022c8:	78 16                	js     8022e0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8022ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8022cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d8:	89 14 24             	mov    %edx,(%esp)
  8022db:	e8 8a 01 00 00       	call   80246a <nsipc_connect>
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <listen>:

int
listen(int s, int backlog)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	e8 99 fe ff ff       	call   802189 <fd2sockid>
  8022f0:	89 c2                	mov    %eax,%edx
  8022f2:	85 d2                	test   %edx,%edx
  8022f4:	78 0f                	js     802305 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8022f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fd:	89 14 24             	mov    %edx,(%esp)
  802300:	e8 a4 01 00 00       	call   8024a9 <nsipc_listen>
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80230d:	8b 45 10             	mov    0x10(%ebp),%eax
  802310:	89 44 24 08          	mov    %eax,0x8(%esp)
  802314:	8b 45 0c             	mov    0xc(%ebp),%eax
  802317:	89 44 24 04          	mov    %eax,0x4(%esp)
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	89 04 24             	mov    %eax,(%esp)
  802321:	e8 98 02 00 00       	call   8025be <nsipc_socket>
  802326:	89 c2                	mov    %eax,%edx
  802328:	85 d2                	test   %edx,%edx
  80232a:	78 05                	js     802331 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80232c:	e8 8a fe ff ff       	call   8021bb <alloc_sockfd>
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	53                   	push   %ebx
  802337:	83 ec 14             	sub    $0x14,%esp
  80233a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80233c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802343:	75 11                	jne    802356 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802345:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80234c:	e8 4e 09 00 00       	call   802c9f <ipc_find_env>
  802351:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802356:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80235d:	00 
  80235e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802365:	00 
  802366:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80236a:	a1 04 50 80 00       	mov    0x805004,%eax
  80236f:	89 04 24             	mov    %eax,(%esp)
  802372:	e8 c1 08 00 00       	call   802c38 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802377:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80237e:	00 
  80237f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802386:	00 
  802387:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80238e:	e8 3d 08 00 00       	call   802bd0 <ipc_recv>
}
  802393:	83 c4 14             	add    $0x14,%esp
  802396:	5b                   	pop    %ebx
  802397:	5d                   	pop    %ebp
  802398:	c3                   	ret    

00802399 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	56                   	push   %esi
  80239d:	53                   	push   %ebx
  80239e:	83 ec 10             	sub    $0x10,%esp
  8023a1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8023ac:	8b 06                	mov    (%esi),%eax
  8023ae:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8023b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b8:	e8 76 ff ff ff       	call   802333 <nsipc>
  8023bd:	89 c3                	mov    %eax,%ebx
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	78 23                	js     8023e6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023c3:	a1 10 70 80 00       	mov    0x807010,%eax
  8023c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023cc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8023d3:	00 
  8023d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d7:	89 04 24             	mov    %eax,(%esp)
  8023da:	e8 55 e8 ff ff       	call   800c34 <memmove>
		*addrlen = ret->ret_addrlen;
  8023df:	a1 10 70 80 00       	mov    0x807010,%eax
  8023e4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8023e6:	89 d8                	mov    %ebx,%eax
  8023e8:	83 c4 10             	add    $0x10,%esp
  8023eb:	5b                   	pop    %ebx
  8023ec:	5e                   	pop    %esi
  8023ed:	5d                   	pop    %ebp
  8023ee:	c3                   	ret    

008023ef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	53                   	push   %ebx
  8023f3:	83 ec 14             	sub    $0x14,%esp
  8023f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802401:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802405:	8b 45 0c             	mov    0xc(%ebp),%eax
  802408:	89 44 24 04          	mov    %eax,0x4(%esp)
  80240c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802413:	e8 1c e8 ff ff       	call   800c34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802418:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80241e:	b8 02 00 00 00       	mov    $0x2,%eax
  802423:	e8 0b ff ff ff       	call   802333 <nsipc>
}
  802428:	83 c4 14             	add    $0x14,%esp
  80242b:	5b                   	pop    %ebx
  80242c:	5d                   	pop    %ebp
  80242d:	c3                   	ret    

0080242e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
  802431:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80243c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802444:	b8 03 00 00 00       	mov    $0x3,%eax
  802449:	e8 e5 fe ff ff       	call   802333 <nsipc>
}
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    

00802450 <nsipc_close>:

int
nsipc_close(int s)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80245e:	b8 04 00 00 00       	mov    $0x4,%eax
  802463:	e8 cb fe ff ff       	call   802333 <nsipc>
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	53                   	push   %ebx
  80246e:	83 ec 14             	sub    $0x14,%esp
  802471:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80247c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802480:	8b 45 0c             	mov    0xc(%ebp),%eax
  802483:	89 44 24 04          	mov    %eax,0x4(%esp)
  802487:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80248e:	e8 a1 e7 ff ff       	call   800c34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802493:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802499:	b8 05 00 00 00       	mov    $0x5,%eax
  80249e:	e8 90 fe ff ff       	call   802333 <nsipc>
}
  8024a3:	83 c4 14             	add    $0x14,%esp
  8024a6:	5b                   	pop    %ebx
  8024a7:	5d                   	pop    %ebp
  8024a8:	c3                   	ret    

008024a9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
  8024ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8024b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ba:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8024bf:	b8 06 00 00 00       	mov    $0x6,%eax
  8024c4:	e8 6a fe ff ff       	call   802333 <nsipc>
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
  8024ce:	56                   	push   %esi
  8024cf:	53                   	push   %ebx
  8024d0:	83 ec 10             	sub    $0x10,%esp
  8024d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8024de:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8024e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8024e7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8024ec:	b8 07 00 00 00       	mov    $0x7,%eax
  8024f1:	e8 3d fe ff ff       	call   802333 <nsipc>
  8024f6:	89 c3                	mov    %eax,%ebx
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	78 46                	js     802542 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8024fc:	39 f0                	cmp    %esi,%eax
  8024fe:	7f 07                	jg     802507 <nsipc_recv+0x3c>
  802500:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802505:	7e 24                	jle    80252b <nsipc_recv+0x60>
  802507:	c7 44 24 0c 99 35 80 	movl   $0x803599,0xc(%esp)
  80250e:	00 
  80250f:	c7 44 24 08 48 35 80 	movl   $0x803548,0x8(%esp)
  802516:	00 
  802517:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80251e:	00 
  80251f:	c7 04 24 ae 35 80 00 	movl   $0x8035ae,(%esp)
  802526:	e8 f3 dd ff ff       	call   80031e <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80252b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80252f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802536:	00 
  802537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253a:	89 04 24             	mov    %eax,(%esp)
  80253d:	e8 f2 e6 ff ff       	call   800c34 <memmove>
	}

	return r;
}
  802542:	89 d8                	mov    %ebx,%eax
  802544:	83 c4 10             	add    $0x10,%esp
  802547:	5b                   	pop    %ebx
  802548:	5e                   	pop    %esi
  802549:	5d                   	pop    %ebp
  80254a:	c3                   	ret    

0080254b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
  80254e:	53                   	push   %ebx
  80254f:	83 ec 14             	sub    $0x14,%esp
  802552:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80255d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802563:	7e 24                	jle    802589 <nsipc_send+0x3e>
  802565:	c7 44 24 0c ba 35 80 	movl   $0x8035ba,0xc(%esp)
  80256c:	00 
  80256d:	c7 44 24 08 48 35 80 	movl   $0x803548,0x8(%esp)
  802574:	00 
  802575:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80257c:	00 
  80257d:	c7 04 24 ae 35 80 00 	movl   $0x8035ae,(%esp)
  802584:	e8 95 dd ff ff       	call   80031e <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802589:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80258d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802590:	89 44 24 04          	mov    %eax,0x4(%esp)
  802594:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80259b:	e8 94 e6 ff ff       	call   800c34 <memmove>
	nsipcbuf.send.req_size = size;
  8025a0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8025a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8025a9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8025ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8025b3:	e8 7b fd ff ff       	call   802333 <nsipc>
}
  8025b8:	83 c4 14             	add    $0x14,%esp
  8025bb:	5b                   	pop    %ebx
  8025bc:	5d                   	pop    %ebp
  8025bd:	c3                   	ret    

008025be <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
  8025c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8025cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025cf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8025d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8025dc:	b8 09 00 00 00       	mov    $0x9,%eax
  8025e1:	e8 4d fd ff ff       	call   802333 <nsipc>
}
  8025e6:	c9                   	leave  
  8025e7:	c3                   	ret    

008025e8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
  8025eb:	56                   	push   %esi
  8025ec:	53                   	push   %ebx
  8025ed:	83 ec 10             	sub    $0x10,%esp
  8025f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	89 04 24             	mov    %eax,(%esp)
  8025f9:	e8 d2 f1 ff ff       	call   8017d0 <fd2data>
  8025fe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802600:	c7 44 24 04 c6 35 80 	movl   $0x8035c6,0x4(%esp)
  802607:	00 
  802608:	89 1c 24             	mov    %ebx,(%esp)
  80260b:	e8 87 e4 ff ff       	call   800a97 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802610:	8b 46 04             	mov    0x4(%esi),%eax
  802613:	2b 06                	sub    (%esi),%eax
  802615:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80261b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802622:	00 00 00 
	stat->st_dev = &devpipe;
  802625:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80262c:	40 80 00 
	return 0;
}
  80262f:	b8 00 00 00 00       	mov    $0x0,%eax
  802634:	83 c4 10             	add    $0x10,%esp
  802637:	5b                   	pop    %ebx
  802638:	5e                   	pop    %esi
  802639:	5d                   	pop    %ebp
  80263a:	c3                   	ret    

0080263b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	53                   	push   %ebx
  80263f:	83 ec 14             	sub    $0x14,%esp
  802642:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802645:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802649:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802650:	e8 57 e9 ff ff       	call   800fac <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802655:	89 1c 24             	mov    %ebx,(%esp)
  802658:	e8 73 f1 ff ff       	call   8017d0 <fd2data>
  80265d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802661:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802668:	e8 3f e9 ff ff       	call   800fac <sys_page_unmap>
}
  80266d:	83 c4 14             	add    $0x14,%esp
  802670:	5b                   	pop    %ebx
  802671:	5d                   	pop    %ebp
  802672:	c3                   	ret    

00802673 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	57                   	push   %edi
  802677:	56                   	push   %esi
  802678:	53                   	push   %ebx
  802679:	83 ec 2c             	sub    $0x2c,%esp
  80267c:	89 c6                	mov    %eax,%esi
  80267e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802681:	a1 08 50 80 00       	mov    0x805008,%eax
  802686:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802689:	89 34 24             	mov    %esi,(%esp)
  80268c:	e8 46 06 00 00       	call   802cd7 <pageref>
  802691:	89 c7                	mov    %eax,%edi
  802693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802696:	89 04 24             	mov    %eax,(%esp)
  802699:	e8 39 06 00 00       	call   802cd7 <pageref>
  80269e:	39 c7                	cmp    %eax,%edi
  8026a0:	0f 94 c2             	sete   %dl
  8026a3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8026a6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8026ac:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8026af:	39 fb                	cmp    %edi,%ebx
  8026b1:	74 21                	je     8026d4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8026b3:	84 d2                	test   %dl,%dl
  8026b5:	74 ca                	je     802681 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8026b7:	8b 51 58             	mov    0x58(%ecx),%edx
  8026ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026be:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026c6:	c7 04 24 cd 35 80 00 	movl   $0x8035cd,(%esp)
  8026cd:	e8 45 dd ff ff       	call   800417 <cprintf>
  8026d2:	eb ad                	jmp    802681 <_pipeisclosed+0xe>
	}
}
  8026d4:	83 c4 2c             	add    $0x2c,%esp
  8026d7:	5b                   	pop    %ebx
  8026d8:	5e                   	pop    %esi
  8026d9:	5f                   	pop    %edi
  8026da:	5d                   	pop    %ebp
  8026db:	c3                   	ret    

008026dc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	57                   	push   %edi
  8026e0:	56                   	push   %esi
  8026e1:	53                   	push   %ebx
  8026e2:	83 ec 1c             	sub    $0x1c,%esp
  8026e5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8026e8:	89 34 24             	mov    %esi,(%esp)
  8026eb:	e8 e0 f0 ff ff       	call   8017d0 <fd2data>
  8026f0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f7:	eb 45                	jmp    80273e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8026f9:	89 da                	mov    %ebx,%edx
  8026fb:	89 f0                	mov    %esi,%eax
  8026fd:	e8 71 ff ff ff       	call   802673 <_pipeisclosed>
  802702:	85 c0                	test   %eax,%eax
  802704:	75 41                	jne    802747 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802706:	e8 db e7 ff ff       	call   800ee6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80270b:	8b 43 04             	mov    0x4(%ebx),%eax
  80270e:	8b 0b                	mov    (%ebx),%ecx
  802710:	8d 51 20             	lea    0x20(%ecx),%edx
  802713:	39 d0                	cmp    %edx,%eax
  802715:	73 e2                	jae    8026f9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802717:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80271a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80271e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802721:	99                   	cltd   
  802722:	c1 ea 1b             	shr    $0x1b,%edx
  802725:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802728:	83 e1 1f             	and    $0x1f,%ecx
  80272b:	29 d1                	sub    %edx,%ecx
  80272d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802731:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802735:	83 c0 01             	add    $0x1,%eax
  802738:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80273b:	83 c7 01             	add    $0x1,%edi
  80273e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802741:	75 c8                	jne    80270b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802743:	89 f8                	mov    %edi,%eax
  802745:	eb 05                	jmp    80274c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802747:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80274c:	83 c4 1c             	add    $0x1c,%esp
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5f                   	pop    %edi
  802752:	5d                   	pop    %ebp
  802753:	c3                   	ret    

00802754 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	57                   	push   %edi
  802758:	56                   	push   %esi
  802759:	53                   	push   %ebx
  80275a:	83 ec 1c             	sub    $0x1c,%esp
  80275d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802760:	89 3c 24             	mov    %edi,(%esp)
  802763:	e8 68 f0 ff ff       	call   8017d0 <fd2data>
  802768:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80276a:	be 00 00 00 00       	mov    $0x0,%esi
  80276f:	eb 3d                	jmp    8027ae <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802771:	85 f6                	test   %esi,%esi
  802773:	74 04                	je     802779 <devpipe_read+0x25>
				return i;
  802775:	89 f0                	mov    %esi,%eax
  802777:	eb 43                	jmp    8027bc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802779:	89 da                	mov    %ebx,%edx
  80277b:	89 f8                	mov    %edi,%eax
  80277d:	e8 f1 fe ff ff       	call   802673 <_pipeisclosed>
  802782:	85 c0                	test   %eax,%eax
  802784:	75 31                	jne    8027b7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802786:	e8 5b e7 ff ff       	call   800ee6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80278b:	8b 03                	mov    (%ebx),%eax
  80278d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802790:	74 df                	je     802771 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802792:	99                   	cltd   
  802793:	c1 ea 1b             	shr    $0x1b,%edx
  802796:	01 d0                	add    %edx,%eax
  802798:	83 e0 1f             	and    $0x1f,%eax
  80279b:	29 d0                	sub    %edx,%eax
  80279d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8027a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027a5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8027a8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027ab:	83 c6 01             	add    $0x1,%esi
  8027ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027b1:	75 d8                	jne    80278b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8027b3:	89 f0                	mov    %esi,%eax
  8027b5:	eb 05                	jmp    8027bc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8027bc:	83 c4 1c             	add    $0x1c,%esp
  8027bf:	5b                   	pop    %ebx
  8027c0:	5e                   	pop    %esi
  8027c1:	5f                   	pop    %edi
  8027c2:	5d                   	pop    %ebp
  8027c3:	c3                   	ret    

008027c4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	56                   	push   %esi
  8027c8:	53                   	push   %ebx
  8027c9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027cf:	89 04 24             	mov    %eax,(%esp)
  8027d2:	e8 10 f0 ff ff       	call   8017e7 <fd_alloc>
  8027d7:	89 c2                	mov    %eax,%edx
  8027d9:	85 d2                	test   %edx,%edx
  8027db:	0f 88 4d 01 00 00    	js     80292e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027e1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027e8:	00 
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027f7:	e8 09 e7 ff ff       	call   800f05 <sys_page_alloc>
  8027fc:	89 c2                	mov    %eax,%edx
  8027fe:	85 d2                	test   %edx,%edx
  802800:	0f 88 28 01 00 00    	js     80292e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802806:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802809:	89 04 24             	mov    %eax,(%esp)
  80280c:	e8 d6 ef ff ff       	call   8017e7 <fd_alloc>
  802811:	89 c3                	mov    %eax,%ebx
  802813:	85 c0                	test   %eax,%eax
  802815:	0f 88 fe 00 00 00    	js     802919 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80281b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802822:	00 
  802823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802826:	89 44 24 04          	mov    %eax,0x4(%esp)
  80282a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802831:	e8 cf e6 ff ff       	call   800f05 <sys_page_alloc>
  802836:	89 c3                	mov    %eax,%ebx
  802838:	85 c0                	test   %eax,%eax
  80283a:	0f 88 d9 00 00 00    	js     802919 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	89 04 24             	mov    %eax,(%esp)
  802846:	e8 85 ef ff ff       	call   8017d0 <fd2data>
  80284b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80284d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802854:	00 
  802855:	89 44 24 04          	mov    %eax,0x4(%esp)
  802859:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802860:	e8 a0 e6 ff ff       	call   800f05 <sys_page_alloc>
  802865:	89 c3                	mov    %eax,%ebx
  802867:	85 c0                	test   %eax,%eax
  802869:	0f 88 97 00 00 00    	js     802906 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80286f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802872:	89 04 24             	mov    %eax,(%esp)
  802875:	e8 56 ef ff ff       	call   8017d0 <fd2data>
  80287a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802881:	00 
  802882:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802886:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80288d:	00 
  80288e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802892:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802899:	e8 bb e6 ff ff       	call   800f59 <sys_page_map>
  80289e:	89 c3                	mov    %eax,%ebx
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	78 52                	js     8028f6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8028a4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8028b9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8028bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8028c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	89 04 24             	mov    %eax,(%esp)
  8028d4:	e8 e7 ee ff ff       	call   8017c0 <fd2num>
  8028d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028dc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8028de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e1:	89 04 24             	mov    %eax,(%esp)
  8028e4:	e8 d7 ee ff ff       	call   8017c0 <fd2num>
  8028e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028ec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f4:	eb 38                	jmp    80292e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8028f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802901:	e8 a6 e6 ff ff       	call   800fac <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	89 44 24 04          	mov    %eax,0x4(%esp)
  80290d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802914:	e8 93 e6 ff ff       	call   800fac <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802920:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802927:	e8 80 e6 ff ff       	call   800fac <sys_page_unmap>
  80292c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80292e:	83 c4 30             	add    $0x30,%esp
  802931:	5b                   	pop    %ebx
  802932:	5e                   	pop    %esi
  802933:	5d                   	pop    %ebp
  802934:	c3                   	ret    

00802935 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
  802938:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80293b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80293e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	89 04 24             	mov    %eax,(%esp)
  802948:	e8 e9 ee ff ff       	call   801836 <fd_lookup>
  80294d:	89 c2                	mov    %eax,%edx
  80294f:	85 d2                	test   %edx,%edx
  802951:	78 15                	js     802968 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	89 04 24             	mov    %eax,(%esp)
  802959:	e8 72 ee ff ff       	call   8017d0 <fd2data>
	return _pipeisclosed(fd, p);
  80295e:	89 c2                	mov    %eax,%edx
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	e8 0b fd ff ff       	call   802673 <_pipeisclosed>
}
  802968:	c9                   	leave  
  802969:	c3                   	ret    
  80296a:	66 90                	xchg   %ax,%ax
  80296c:	66 90                	xchg   %ax,%ax
  80296e:	66 90                	xchg   %ax,%ax

00802970 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
  802978:	5d                   	pop    %ebp
  802979:	c3                   	ret    

0080297a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
  80297d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802980:	c7 44 24 04 e0 35 80 	movl   $0x8035e0,0x4(%esp)
  802987:	00 
  802988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80298b:	89 04 24             	mov    %eax,(%esp)
  80298e:	e8 04 e1 ff ff       	call   800a97 <strcpy>
	return 0;
}
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
  802998:	c9                   	leave  
  802999:	c3                   	ret    

0080299a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	57                   	push   %edi
  80299e:	56                   	push   %esi
  80299f:	53                   	push   %ebx
  8029a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8029ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029b1:	eb 31                	jmp    8029e4 <devcons_write+0x4a>
		m = n - tot;
  8029b3:	8b 75 10             	mov    0x10(%ebp),%esi
  8029b6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8029b8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8029bb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8029c0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8029c3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8029c7:	03 45 0c             	add    0xc(%ebp),%eax
  8029ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ce:	89 3c 24             	mov    %edi,(%esp)
  8029d1:	e8 5e e2 ff ff       	call   800c34 <memmove>
		sys_cputs(buf, m);
  8029d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029da:	89 3c 24             	mov    %edi,(%esp)
  8029dd:	e8 04 e4 ff ff       	call   800de6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029e2:	01 f3                	add    %esi,%ebx
  8029e4:	89 d8                	mov    %ebx,%eax
  8029e6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8029e9:	72 c8                	jb     8029b3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8029eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8029f1:	5b                   	pop    %ebx
  8029f2:	5e                   	pop    %esi
  8029f3:	5f                   	pop    %edi
  8029f4:	5d                   	pop    %ebp
  8029f5:	c3                   	ret    

008029f6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8029f6:	55                   	push   %ebp
  8029f7:	89 e5                	mov    %esp,%ebp
  8029f9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8029fc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802a01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a05:	75 07                	jne    802a0e <devcons_read+0x18>
  802a07:	eb 2a                	jmp    802a33 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802a09:	e8 d8 e4 ff ff       	call   800ee6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802a0e:	66 90                	xchg   %ax,%ax
  802a10:	e8 ef e3 ff ff       	call   800e04 <sys_cgetc>
  802a15:	85 c0                	test   %eax,%eax
  802a17:	74 f0                	je     802a09 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	78 16                	js     802a33 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802a1d:	83 f8 04             	cmp    $0x4,%eax
  802a20:	74 0c                	je     802a2e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a25:	88 02                	mov    %al,(%edx)
	return 1;
  802a27:	b8 01 00 00 00       	mov    $0x1,%eax
  802a2c:	eb 05                	jmp    802a33 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802a2e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802a33:	c9                   	leave  
  802a34:	c3                   	ret    

00802a35 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802a35:	55                   	push   %ebp
  802a36:	89 e5                	mov    %esp,%ebp
  802a38:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802a41:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802a48:	00 
  802a49:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a4c:	89 04 24             	mov    %eax,(%esp)
  802a4f:	e8 92 e3 ff ff       	call   800de6 <sys_cputs>
}
  802a54:	c9                   	leave  
  802a55:	c3                   	ret    

00802a56 <getchar>:

int
getchar(void)
{
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
  802a59:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802a5c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802a63:	00 
  802a64:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a72:	e8 53 f0 ff ff       	call   801aca <read>
	if (r < 0)
  802a77:	85 c0                	test   %eax,%eax
  802a79:	78 0f                	js     802a8a <getchar+0x34>
		return r;
	if (r < 1)
  802a7b:	85 c0                	test   %eax,%eax
  802a7d:	7e 06                	jle    802a85 <getchar+0x2f>
		return -E_EOF;
	return c;
  802a7f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802a83:	eb 05                	jmp    802a8a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802a85:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802a8a:	c9                   	leave  
  802a8b:	c3                   	ret    

00802a8c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
  802a8f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a92:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a95:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	89 04 24             	mov    %eax,(%esp)
  802a9f:	e8 92 ed ff ff       	call   801836 <fd_lookup>
  802aa4:	85 c0                	test   %eax,%eax
  802aa6:	78 11                	js     802ab9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802ab1:	39 10                	cmp    %edx,(%eax)
  802ab3:	0f 94 c0             	sete   %al
  802ab6:	0f b6 c0             	movzbl %al,%eax
}
  802ab9:	c9                   	leave  
  802aba:	c3                   	ret    

00802abb <opencons>:

int
opencons(void)
{
  802abb:	55                   	push   %ebp
  802abc:	89 e5                	mov    %esp,%ebp
  802abe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802ac1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ac4:	89 04 24             	mov    %eax,(%esp)
  802ac7:	e8 1b ed ff ff       	call   8017e7 <fd_alloc>
		return r;
  802acc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	78 40                	js     802b12 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802ad2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802ad9:	00 
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ae1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ae8:	e8 18 e4 ff ff       	call   800f05 <sys_page_alloc>
		return r;
  802aed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802aef:	85 c0                	test   %eax,%eax
  802af1:	78 1f                	js     802b12 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802af3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b08:	89 04 24             	mov    %eax,(%esp)
  802b0b:	e8 b0 ec ff ff       	call   8017c0 <fd2num>
  802b10:	89 c2                	mov    %eax,%edx
}
  802b12:	89 d0                	mov    %edx,%eax
  802b14:	c9                   	leave  
  802b15:	c3                   	ret    

00802b16 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b16:	55                   	push   %ebp
  802b17:	89 e5                	mov    %esp,%ebp
  802b19:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b1c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802b23:	75 7a                	jne    802b9f <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802b25:	e8 9d e3 ff ff       	call   800ec7 <sys_getenvid>
  802b2a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802b31:	00 
  802b32:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802b39:	ee 
  802b3a:	89 04 24             	mov    %eax,(%esp)
  802b3d:	e8 c3 e3 ff ff       	call   800f05 <sys_page_alloc>
  802b42:	85 c0                	test   %eax,%eax
  802b44:	79 20                	jns    802b66 <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802b46:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b4a:	c7 44 24 08 09 34 80 	movl   $0x803409,0x8(%esp)
  802b51:	00 
  802b52:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802b59:	00 
  802b5a:	c7 04 24 ec 35 80 00 	movl   $0x8035ec,(%esp)
  802b61:	e8 b8 d7 ff ff       	call   80031e <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802b66:	e8 5c e3 ff ff       	call   800ec7 <sys_getenvid>
  802b6b:	c7 44 24 04 a9 2b 80 	movl   $0x802ba9,0x4(%esp)
  802b72:	00 
  802b73:	89 04 24             	mov    %eax,(%esp)
  802b76:	e8 4a e5 ff ff       	call   8010c5 <sys_env_set_pgfault_upcall>
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	79 20                	jns    802b9f <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  802b7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b83:	c7 44 24 08 88 34 80 	movl   $0x803488,0x8(%esp)
  802b8a:	00 
  802b8b:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  802b92:	00 
  802b93:	c7 04 24 ec 35 80 00 	movl   $0x8035ec,(%esp)
  802b9a:	e8 7f d7 ff ff       	call   80031e <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802ba7:	c9                   	leave  
  802ba8:	c3                   	ret    

00802ba9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802ba9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802baa:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802baf:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802bb1:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  802bb4:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  802bb8:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802bbc:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  802bbf:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  802bc3:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  802bc5:	83 c4 08             	add    $0x8,%esp
	popal
  802bc8:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  802bc9:	83 c4 04             	add    $0x4,%esp
	popfl
  802bcc:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802bcd:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802bce:	c3                   	ret    
  802bcf:	90                   	nop

00802bd0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802bd0:	55                   	push   %ebp
  802bd1:	89 e5                	mov    %esp,%ebp
  802bd3:	56                   	push   %esi
  802bd4:	53                   	push   %ebx
  802bd5:	83 ec 10             	sub    $0x10,%esp
  802bd8:	8b 75 08             	mov    0x8(%ebp),%esi
  802bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bde:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802be1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802be3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802be8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802beb:	89 04 24             	mov    %eax,(%esp)
  802bee:	e8 48 e5 ff ff       	call   80113b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	75 26                	jne    802c1d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802bf7:	85 f6                	test   %esi,%esi
  802bf9:	74 0a                	je     802c05 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802bfb:	a1 08 50 80 00       	mov    0x805008,%eax
  802c00:	8b 40 74             	mov    0x74(%eax),%eax
  802c03:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802c05:	85 db                	test   %ebx,%ebx
  802c07:	74 0a                	je     802c13 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802c09:	a1 08 50 80 00       	mov    0x805008,%eax
  802c0e:	8b 40 78             	mov    0x78(%eax),%eax
  802c11:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802c13:	a1 08 50 80 00       	mov    0x805008,%eax
  802c18:	8b 40 70             	mov    0x70(%eax),%eax
  802c1b:	eb 14                	jmp    802c31 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  802c1d:	85 f6                	test   %esi,%esi
  802c1f:	74 06                	je     802c27 <ipc_recv+0x57>
			*from_env_store = 0;
  802c21:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802c27:	85 db                	test   %ebx,%ebx
  802c29:	74 06                	je     802c31 <ipc_recv+0x61>
			*perm_store = 0;
  802c2b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802c31:	83 c4 10             	add    $0x10,%esp
  802c34:	5b                   	pop    %ebx
  802c35:	5e                   	pop    %esi
  802c36:	5d                   	pop    %ebp
  802c37:	c3                   	ret    

00802c38 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802c38:	55                   	push   %ebp
  802c39:	89 e5                	mov    %esp,%ebp
  802c3b:	57                   	push   %edi
  802c3c:	56                   	push   %esi
  802c3d:	53                   	push   %ebx
  802c3e:	83 ec 1c             	sub    $0x1c,%esp
  802c41:	8b 7d 08             	mov    0x8(%ebp),%edi
  802c44:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c47:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  802c4a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  802c4c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802c51:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802c54:	8b 45 14             	mov    0x14(%ebp),%eax
  802c57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c5f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c63:	89 3c 24             	mov    %edi,(%esp)
  802c66:	e8 ad e4 ff ff       	call   801118 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	74 28                	je     802c97 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  802c6f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c72:	74 1c                	je     802c90 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802c74:	c7 44 24 08 fc 35 80 	movl   $0x8035fc,0x8(%esp)
  802c7b:	00 
  802c7c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802c83:	00 
  802c84:	c7 04 24 20 36 80 00 	movl   $0x803620,(%esp)
  802c8b:	e8 8e d6 ff ff       	call   80031e <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802c90:	e8 51 e2 ff ff       	call   800ee6 <sys_yield>
	}
  802c95:	eb bd                	jmp    802c54 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802c97:	83 c4 1c             	add    $0x1c,%esp
  802c9a:	5b                   	pop    %ebx
  802c9b:	5e                   	pop    %esi
  802c9c:	5f                   	pop    %edi
  802c9d:	5d                   	pop    %ebp
  802c9e:	c3                   	ret    

00802c9f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802c9f:	55                   	push   %ebp
  802ca0:	89 e5                	mov    %esp,%ebp
  802ca2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802ca5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802caa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802cad:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802cb3:	8b 52 50             	mov    0x50(%edx),%edx
  802cb6:	39 ca                	cmp    %ecx,%edx
  802cb8:	75 0d                	jne    802cc7 <ipc_find_env+0x28>
			return envs[i].env_id;
  802cba:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802cbd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802cc2:	8b 40 40             	mov    0x40(%eax),%eax
  802cc5:	eb 0e                	jmp    802cd5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802cc7:	83 c0 01             	add    $0x1,%eax
  802cca:	3d 00 04 00 00       	cmp    $0x400,%eax
  802ccf:	75 d9                	jne    802caa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802cd1:	66 b8 00 00          	mov    $0x0,%ax
}
  802cd5:	5d                   	pop    %ebp
  802cd6:	c3                   	ret    

00802cd7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802cd7:	55                   	push   %ebp
  802cd8:	89 e5                	mov    %esp,%ebp
  802cda:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802cdd:	89 d0                	mov    %edx,%eax
  802cdf:	c1 e8 16             	shr    $0x16,%eax
  802ce2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ce9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802cee:	f6 c1 01             	test   $0x1,%cl
  802cf1:	74 1d                	je     802d10 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802cf3:	c1 ea 0c             	shr    $0xc,%edx
  802cf6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802cfd:	f6 c2 01             	test   $0x1,%dl
  802d00:	74 0e                	je     802d10 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d02:	c1 ea 0c             	shr    $0xc,%edx
  802d05:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802d0c:	ef 
  802d0d:	0f b7 c0             	movzwl %ax,%eax
}
  802d10:	5d                   	pop    %ebp
  802d11:	c3                   	ret    
  802d12:	66 90                	xchg   %ax,%ax
  802d14:	66 90                	xchg   %ax,%ax
  802d16:	66 90                	xchg   %ax,%ax
  802d18:	66 90                	xchg   %ax,%ax
  802d1a:	66 90                	xchg   %ax,%ax
  802d1c:	66 90                	xchg   %ax,%ax
  802d1e:	66 90                	xchg   %ax,%ax

00802d20 <__udivdi3>:
  802d20:	55                   	push   %ebp
  802d21:	57                   	push   %edi
  802d22:	56                   	push   %esi
  802d23:	83 ec 0c             	sub    $0xc,%esp
  802d26:	8b 44 24 28          	mov    0x28(%esp),%eax
  802d2a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802d2e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802d32:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802d36:	85 c0                	test   %eax,%eax
  802d38:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802d3c:	89 ea                	mov    %ebp,%edx
  802d3e:	89 0c 24             	mov    %ecx,(%esp)
  802d41:	75 2d                	jne    802d70 <__udivdi3+0x50>
  802d43:	39 e9                	cmp    %ebp,%ecx
  802d45:	77 61                	ja     802da8 <__udivdi3+0x88>
  802d47:	85 c9                	test   %ecx,%ecx
  802d49:	89 ce                	mov    %ecx,%esi
  802d4b:	75 0b                	jne    802d58 <__udivdi3+0x38>
  802d4d:	b8 01 00 00 00       	mov    $0x1,%eax
  802d52:	31 d2                	xor    %edx,%edx
  802d54:	f7 f1                	div    %ecx
  802d56:	89 c6                	mov    %eax,%esi
  802d58:	31 d2                	xor    %edx,%edx
  802d5a:	89 e8                	mov    %ebp,%eax
  802d5c:	f7 f6                	div    %esi
  802d5e:	89 c5                	mov    %eax,%ebp
  802d60:	89 f8                	mov    %edi,%eax
  802d62:	f7 f6                	div    %esi
  802d64:	89 ea                	mov    %ebp,%edx
  802d66:	83 c4 0c             	add    $0xc,%esp
  802d69:	5e                   	pop    %esi
  802d6a:	5f                   	pop    %edi
  802d6b:	5d                   	pop    %ebp
  802d6c:	c3                   	ret    
  802d6d:	8d 76 00             	lea    0x0(%esi),%esi
  802d70:	39 e8                	cmp    %ebp,%eax
  802d72:	77 24                	ja     802d98 <__udivdi3+0x78>
  802d74:	0f bd e8             	bsr    %eax,%ebp
  802d77:	83 f5 1f             	xor    $0x1f,%ebp
  802d7a:	75 3c                	jne    802db8 <__udivdi3+0x98>
  802d7c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802d80:	39 34 24             	cmp    %esi,(%esp)
  802d83:	0f 86 9f 00 00 00    	jbe    802e28 <__udivdi3+0x108>
  802d89:	39 d0                	cmp    %edx,%eax
  802d8b:	0f 82 97 00 00 00    	jb     802e28 <__udivdi3+0x108>
  802d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d98:	31 d2                	xor    %edx,%edx
  802d9a:	31 c0                	xor    %eax,%eax
  802d9c:	83 c4 0c             	add    $0xc,%esp
  802d9f:	5e                   	pop    %esi
  802da0:	5f                   	pop    %edi
  802da1:	5d                   	pop    %ebp
  802da2:	c3                   	ret    
  802da3:	90                   	nop
  802da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802da8:	89 f8                	mov    %edi,%eax
  802daa:	f7 f1                	div    %ecx
  802dac:	31 d2                	xor    %edx,%edx
  802dae:	83 c4 0c             	add    $0xc,%esp
  802db1:	5e                   	pop    %esi
  802db2:	5f                   	pop    %edi
  802db3:	5d                   	pop    %ebp
  802db4:	c3                   	ret    
  802db5:	8d 76 00             	lea    0x0(%esi),%esi
  802db8:	89 e9                	mov    %ebp,%ecx
  802dba:	8b 3c 24             	mov    (%esp),%edi
  802dbd:	d3 e0                	shl    %cl,%eax
  802dbf:	89 c6                	mov    %eax,%esi
  802dc1:	b8 20 00 00 00       	mov    $0x20,%eax
  802dc6:	29 e8                	sub    %ebp,%eax
  802dc8:	89 c1                	mov    %eax,%ecx
  802dca:	d3 ef                	shr    %cl,%edi
  802dcc:	89 e9                	mov    %ebp,%ecx
  802dce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802dd2:	8b 3c 24             	mov    (%esp),%edi
  802dd5:	09 74 24 08          	or     %esi,0x8(%esp)
  802dd9:	89 d6                	mov    %edx,%esi
  802ddb:	d3 e7                	shl    %cl,%edi
  802ddd:	89 c1                	mov    %eax,%ecx
  802ddf:	89 3c 24             	mov    %edi,(%esp)
  802de2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802de6:	d3 ee                	shr    %cl,%esi
  802de8:	89 e9                	mov    %ebp,%ecx
  802dea:	d3 e2                	shl    %cl,%edx
  802dec:	89 c1                	mov    %eax,%ecx
  802dee:	d3 ef                	shr    %cl,%edi
  802df0:	09 d7                	or     %edx,%edi
  802df2:	89 f2                	mov    %esi,%edx
  802df4:	89 f8                	mov    %edi,%eax
  802df6:	f7 74 24 08          	divl   0x8(%esp)
  802dfa:	89 d6                	mov    %edx,%esi
  802dfc:	89 c7                	mov    %eax,%edi
  802dfe:	f7 24 24             	mull   (%esp)
  802e01:	39 d6                	cmp    %edx,%esi
  802e03:	89 14 24             	mov    %edx,(%esp)
  802e06:	72 30                	jb     802e38 <__udivdi3+0x118>
  802e08:	8b 54 24 04          	mov    0x4(%esp),%edx
  802e0c:	89 e9                	mov    %ebp,%ecx
  802e0e:	d3 e2                	shl    %cl,%edx
  802e10:	39 c2                	cmp    %eax,%edx
  802e12:	73 05                	jae    802e19 <__udivdi3+0xf9>
  802e14:	3b 34 24             	cmp    (%esp),%esi
  802e17:	74 1f                	je     802e38 <__udivdi3+0x118>
  802e19:	89 f8                	mov    %edi,%eax
  802e1b:	31 d2                	xor    %edx,%edx
  802e1d:	e9 7a ff ff ff       	jmp    802d9c <__udivdi3+0x7c>
  802e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e28:	31 d2                	xor    %edx,%edx
  802e2a:	b8 01 00 00 00       	mov    $0x1,%eax
  802e2f:	e9 68 ff ff ff       	jmp    802d9c <__udivdi3+0x7c>
  802e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e38:	8d 47 ff             	lea    -0x1(%edi),%eax
  802e3b:	31 d2                	xor    %edx,%edx
  802e3d:	83 c4 0c             	add    $0xc,%esp
  802e40:	5e                   	pop    %esi
  802e41:	5f                   	pop    %edi
  802e42:	5d                   	pop    %ebp
  802e43:	c3                   	ret    
  802e44:	66 90                	xchg   %ax,%ax
  802e46:	66 90                	xchg   %ax,%ax
  802e48:	66 90                	xchg   %ax,%ax
  802e4a:	66 90                	xchg   %ax,%ax
  802e4c:	66 90                	xchg   %ax,%ax
  802e4e:	66 90                	xchg   %ax,%ax

00802e50 <__umoddi3>:
  802e50:	55                   	push   %ebp
  802e51:	57                   	push   %edi
  802e52:	56                   	push   %esi
  802e53:	83 ec 14             	sub    $0x14,%esp
  802e56:	8b 44 24 28          	mov    0x28(%esp),%eax
  802e5a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802e5e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802e62:	89 c7                	mov    %eax,%edi
  802e64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e68:	8b 44 24 30          	mov    0x30(%esp),%eax
  802e6c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802e70:	89 34 24             	mov    %esi,(%esp)
  802e73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e77:	85 c0                	test   %eax,%eax
  802e79:	89 c2                	mov    %eax,%edx
  802e7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e7f:	75 17                	jne    802e98 <__umoddi3+0x48>
  802e81:	39 fe                	cmp    %edi,%esi
  802e83:	76 4b                	jbe    802ed0 <__umoddi3+0x80>
  802e85:	89 c8                	mov    %ecx,%eax
  802e87:	89 fa                	mov    %edi,%edx
  802e89:	f7 f6                	div    %esi
  802e8b:	89 d0                	mov    %edx,%eax
  802e8d:	31 d2                	xor    %edx,%edx
  802e8f:	83 c4 14             	add    $0x14,%esp
  802e92:	5e                   	pop    %esi
  802e93:	5f                   	pop    %edi
  802e94:	5d                   	pop    %ebp
  802e95:	c3                   	ret    
  802e96:	66 90                	xchg   %ax,%ax
  802e98:	39 f8                	cmp    %edi,%eax
  802e9a:	77 54                	ja     802ef0 <__umoddi3+0xa0>
  802e9c:	0f bd e8             	bsr    %eax,%ebp
  802e9f:	83 f5 1f             	xor    $0x1f,%ebp
  802ea2:	75 5c                	jne    802f00 <__umoddi3+0xb0>
  802ea4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802ea8:	39 3c 24             	cmp    %edi,(%esp)
  802eab:	0f 87 e7 00 00 00    	ja     802f98 <__umoddi3+0x148>
  802eb1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802eb5:	29 f1                	sub    %esi,%ecx
  802eb7:	19 c7                	sbb    %eax,%edi
  802eb9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ebd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ec1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ec5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ec9:	83 c4 14             	add    $0x14,%esp
  802ecc:	5e                   	pop    %esi
  802ecd:	5f                   	pop    %edi
  802ece:	5d                   	pop    %ebp
  802ecf:	c3                   	ret    
  802ed0:	85 f6                	test   %esi,%esi
  802ed2:	89 f5                	mov    %esi,%ebp
  802ed4:	75 0b                	jne    802ee1 <__umoddi3+0x91>
  802ed6:	b8 01 00 00 00       	mov    $0x1,%eax
  802edb:	31 d2                	xor    %edx,%edx
  802edd:	f7 f6                	div    %esi
  802edf:	89 c5                	mov    %eax,%ebp
  802ee1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ee5:	31 d2                	xor    %edx,%edx
  802ee7:	f7 f5                	div    %ebp
  802ee9:	89 c8                	mov    %ecx,%eax
  802eeb:	f7 f5                	div    %ebp
  802eed:	eb 9c                	jmp    802e8b <__umoddi3+0x3b>
  802eef:	90                   	nop
  802ef0:	89 c8                	mov    %ecx,%eax
  802ef2:	89 fa                	mov    %edi,%edx
  802ef4:	83 c4 14             	add    $0x14,%esp
  802ef7:	5e                   	pop    %esi
  802ef8:	5f                   	pop    %edi
  802ef9:	5d                   	pop    %ebp
  802efa:	c3                   	ret    
  802efb:	90                   	nop
  802efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f00:	8b 04 24             	mov    (%esp),%eax
  802f03:	be 20 00 00 00       	mov    $0x20,%esi
  802f08:	89 e9                	mov    %ebp,%ecx
  802f0a:	29 ee                	sub    %ebp,%esi
  802f0c:	d3 e2                	shl    %cl,%edx
  802f0e:	89 f1                	mov    %esi,%ecx
  802f10:	d3 e8                	shr    %cl,%eax
  802f12:	89 e9                	mov    %ebp,%ecx
  802f14:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f18:	8b 04 24             	mov    (%esp),%eax
  802f1b:	09 54 24 04          	or     %edx,0x4(%esp)
  802f1f:	89 fa                	mov    %edi,%edx
  802f21:	d3 e0                	shl    %cl,%eax
  802f23:	89 f1                	mov    %esi,%ecx
  802f25:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f29:	8b 44 24 10          	mov    0x10(%esp),%eax
  802f2d:	d3 ea                	shr    %cl,%edx
  802f2f:	89 e9                	mov    %ebp,%ecx
  802f31:	d3 e7                	shl    %cl,%edi
  802f33:	89 f1                	mov    %esi,%ecx
  802f35:	d3 e8                	shr    %cl,%eax
  802f37:	89 e9                	mov    %ebp,%ecx
  802f39:	09 f8                	or     %edi,%eax
  802f3b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802f3f:	f7 74 24 04          	divl   0x4(%esp)
  802f43:	d3 e7                	shl    %cl,%edi
  802f45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f49:	89 d7                	mov    %edx,%edi
  802f4b:	f7 64 24 08          	mull   0x8(%esp)
  802f4f:	39 d7                	cmp    %edx,%edi
  802f51:	89 c1                	mov    %eax,%ecx
  802f53:	89 14 24             	mov    %edx,(%esp)
  802f56:	72 2c                	jb     802f84 <__umoddi3+0x134>
  802f58:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802f5c:	72 22                	jb     802f80 <__umoddi3+0x130>
  802f5e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802f62:	29 c8                	sub    %ecx,%eax
  802f64:	19 d7                	sbb    %edx,%edi
  802f66:	89 e9                	mov    %ebp,%ecx
  802f68:	89 fa                	mov    %edi,%edx
  802f6a:	d3 e8                	shr    %cl,%eax
  802f6c:	89 f1                	mov    %esi,%ecx
  802f6e:	d3 e2                	shl    %cl,%edx
  802f70:	89 e9                	mov    %ebp,%ecx
  802f72:	d3 ef                	shr    %cl,%edi
  802f74:	09 d0                	or     %edx,%eax
  802f76:	89 fa                	mov    %edi,%edx
  802f78:	83 c4 14             	add    $0x14,%esp
  802f7b:	5e                   	pop    %esi
  802f7c:	5f                   	pop    %edi
  802f7d:	5d                   	pop    %ebp
  802f7e:	c3                   	ret    
  802f7f:	90                   	nop
  802f80:	39 d7                	cmp    %edx,%edi
  802f82:	75 da                	jne    802f5e <__umoddi3+0x10e>
  802f84:	8b 14 24             	mov    (%esp),%edx
  802f87:	89 c1                	mov    %eax,%ecx
  802f89:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802f8d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802f91:	eb cb                	jmp    802f5e <__umoddi3+0x10e>
  802f93:	90                   	nop
  802f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f98:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802f9c:	0f 82 0f ff ff ff    	jb     802eb1 <__umoddi3+0x61>
  802fa2:	e9 1a ff ff ff       	jmp    802ec1 <__umoddi3+0x71>
