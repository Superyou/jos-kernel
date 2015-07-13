
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 1d 02 00 00       	call   80024e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 20             	sub    $0x20,%esp
  800048:	8b 75 08             	mov    0x8(%ebp),%esi
  80004b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80004e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800055:	00 
  800056:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80005a:	89 34 24             	mov    %esi,(%esp)
  80005d:	e8 33 0e 00 00       	call   800e95 <sys_page_alloc>
  800062:	85 c0                	test   %eax,%eax
  800064:	79 20                	jns    800086 <duppage+0x46>
		panic("sys_page_alloc: %e", r);
  800066:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80006a:	c7 44 24 08 e0 28 80 	movl   $0x8028e0,0x8(%esp)
  800071:	00 
  800072:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  800079:	00 
  80007a:	c7 04 24 f3 28 80 00 	movl   $0x8028f3,(%esp)
  800081:	e8 29 02 00 00       	call   8002af <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800086:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80008d:	00 
  80008e:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  800095:	00 
  800096:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80009d:	00 
  80009e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000a2:	89 34 24             	mov    %esi,(%esp)
  8000a5:	e8 3f 0e 00 00       	call   800ee9 <sys_page_map>
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	79 20                	jns    8000ce <duppage+0x8e>
		panic("sys_page_map: %e", r);
  8000ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b2:	c7 44 24 08 03 29 80 	movl   $0x802903,0x8(%esp)
  8000b9:	00 
  8000ba:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8000c1:	00 
  8000c2:	c7 04 24 f3 28 80 00 	movl   $0x8028f3,(%esp)
  8000c9:	e8 e1 01 00 00       	call   8002af <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8000ce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8000d5:	00 
  8000d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000da:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8000e1:	e8 de 0a 00 00       	call   800bc4 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8000e6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8000ed:	00 
  8000ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f5:	e8 42 0e 00 00       	call   800f3c <sys_page_unmap>
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	79 20                	jns    80011e <duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8000fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800102:	c7 44 24 08 14 29 80 	movl   $0x802914,0x8(%esp)
  800109:	00 
  80010a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800111:	00 
  800112:	c7 04 24 f3 28 80 00 	movl   $0x8028f3,(%esp)
  800119:	e8 91 01 00 00       	call   8002af <_panic>
}
  80011e:	83 c4 20             	add    $0x20,%esp
  800121:	5b                   	pop    %ebx
  800122:	5e                   	pop    %esi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    

00800125 <dumbfork>:

envid_t
dumbfork(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	83 ec 20             	sub    $0x20,%esp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80012d:	b8 08 00 00 00       	mov    $0x8,%eax
  800132:	cd 30                	int    $0x30
  800134:	89 c6                	mov    %eax,%esi
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  800136:	85 c0                	test   %eax,%eax
  800138:	79 20                	jns    80015a <dumbfork+0x35>
		panic("sys_exofork: %e", envid);
  80013a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013e:	c7 44 24 08 27 29 80 	movl   $0x802927,0x8(%esp)
  800145:	00 
  800146:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80014d:	00 
  80014e:	c7 04 24 f3 28 80 00 	movl   $0x8028f3,(%esp)
  800155:	e8 55 01 00 00       	call   8002af <_panic>
  80015a:	89 c3                	mov    %eax,%ebx
	if (envid == 0) {
  80015c:	85 c0                	test   %eax,%eax
  80015e:	75 1e                	jne    80017e <dumbfork+0x59>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.

		thisenv = &envs[ENVX(sys_getenvid())];
  800160:	e8 f2 0c 00 00       	call   800e57 <sys_getenvid>
  800165:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80016d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800172:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	eb 71                	jmp    8001ef <dumbfork+0xca>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80017e:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  800185:	eb 13                	jmp    80019a <dumbfork+0x75>
		duppage(envid, addr);
  800187:	89 54 24 04          	mov    %edx,0x4(%esp)
  80018b:	89 1c 24             	mov    %ebx,(%esp)
  80018e:	e8 ad fe ff ff       	call   800040 <duppage>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800193:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80019a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80019d:	81 fa 00 70 80 00    	cmp    $0x807000,%edx
  8001a3:	72 e2                	jb     800187 <dumbfork+0x62>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8001a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b1:	89 34 24             	mov    %esi,(%esp)
  8001b4:	e8 87 fe ff ff       	call   800040 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8001b9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8001c0:	00 
  8001c1:	89 34 24             	mov    %esi,(%esp)
  8001c4:	e8 e6 0d 00 00       	call   800faf <sys_env_set_status>
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	79 20                	jns    8001ed <dumbfork+0xc8>
		panic("sys_env_set_status: %e", r);
  8001cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d1:	c7 44 24 08 37 29 80 	movl   $0x802937,0x8(%esp)
  8001d8:	00 
  8001d9:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  8001e0:	00 
  8001e1:	c7 04 24 f3 28 80 00 	movl   $0x8028f3,(%esp)
  8001e8:	e8 c2 00 00 00       	call   8002af <_panic>

	return envid;
  8001ed:	89 f0                	mov    %esi,%eax
}
  8001ef:	83 c4 20             	add    $0x20,%esp
  8001f2:	5b                   	pop    %ebx
  8001f3:	5e                   	pop    %esi
  8001f4:	5d                   	pop    %ebp
  8001f5:	c3                   	ret    

008001f6 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	83 ec 10             	sub    $0x10,%esp
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  8001fe:	e8 22 ff ff ff       	call   800125 <dumbfork>
  800203:	89 c6                	mov    %eax,%esi

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800205:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020a:	eb 28                	jmp    800234 <umain+0x3e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80020c:	b8 55 29 80 00       	mov    $0x802955,%eax
  800211:	eb 05                	jmp    800218 <umain+0x22>
  800213:	b8 4e 29 80 00       	mov    $0x80294e,%eax
  800218:	89 44 24 08          	mov    %eax,0x8(%esp)
  80021c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800220:	c7 04 24 5b 29 80 00 	movl   $0x80295b,(%esp)
  800227:	e8 7c 01 00 00       	call   8003a8 <cprintf>
		sys_yield();
  80022c:	e8 45 0c 00 00       	call   800e76 <sys_yield>

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800231:	83 c3 01             	add    $0x1,%ebx
  800234:	85 f6                	test   %esi,%esi
  800236:	75 0a                	jne    800242 <umain+0x4c>
  800238:	83 fb 13             	cmp    $0x13,%ebx
  80023b:	7e cf                	jle    80020c <umain+0x16>
  80023d:	8d 76 00             	lea    0x0(%esi),%esi
  800240:	eb 05                	jmp    800247 <umain+0x51>
  800242:	83 fb 09             	cmp    $0x9,%ebx
  800245:	7e cc                	jle    800213 <umain+0x1d>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	5b                   	pop    %ebx
  80024b:	5e                   	pop    %esi
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    

0080024e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	56                   	push   %esi
  800252:	53                   	push   %ebx
  800253:	83 ec 10             	sub    $0x10,%esp
  800256:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800259:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  80025c:	e8 f6 0b 00 00       	call   800e57 <sys_getenvid>
  800261:	25 ff 03 00 00       	and    $0x3ff,%eax
  800266:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800269:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80026e:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800273:	85 db                	test   %ebx,%ebx
  800275:	7e 07                	jle    80027e <libmain+0x30>
		binaryname = argv[0];
  800277:	8b 06                	mov    (%esi),%eax
  800279:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80027e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800282:	89 1c 24             	mov    %ebx,(%esp)
  800285:	e8 6c ff ff ff       	call   8001f6 <umain>

	// exit gracefully
	exit();
  80028a:	e8 07 00 00 00       	call   800296 <exit>
}
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	5b                   	pop    %ebx
  800293:	5e                   	pop    %esi
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    

00800296 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80029c:	e8 d9 10 00 00       	call   80137a <close_all>
	sys_env_destroy(0);
  8002a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002a8:	e8 06 0b 00 00       	call   800db3 <sys_env_destroy>
}
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	56                   	push   %esi
  8002b3:	53                   	push   %ebx
  8002b4:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8002b7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ba:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002c0:	e8 92 0b 00 00       	call   800e57 <sys_getenvid>
  8002c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c8:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002d3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002db:	c7 04 24 78 29 80 00 	movl   $0x802978,(%esp)
  8002e2:	e8 c1 00 00 00       	call   8003a8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	e8 51 00 00 00       	call   800347 <vcprintf>
	cprintf("\n");
  8002f6:	c7 04 24 6b 29 80 00 	movl   $0x80296b,(%esp)
  8002fd:	e8 a6 00 00 00       	call   8003a8 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800302:	cc                   	int3   
  800303:	eb fd                	jmp    800302 <_panic+0x53>

00800305 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	53                   	push   %ebx
  800309:	83 ec 14             	sub    $0x14,%esp
  80030c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80030f:	8b 13                	mov    (%ebx),%edx
  800311:	8d 42 01             	lea    0x1(%edx),%eax
  800314:	89 03                	mov    %eax,(%ebx)
  800316:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800319:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80031d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800322:	75 19                	jne    80033d <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800324:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80032b:	00 
  80032c:	8d 43 08             	lea    0x8(%ebx),%eax
  80032f:	89 04 24             	mov    %eax,(%esp)
  800332:	e8 3f 0a 00 00       	call   800d76 <sys_cputs>
		b->idx = 0;
  800337:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80033d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800341:	83 c4 14             	add    $0x14,%esp
  800344:	5b                   	pop    %ebx
  800345:	5d                   	pop    %ebp
  800346:	c3                   	ret    

00800347 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800350:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800357:	00 00 00 
	b.cnt = 0;
  80035a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800361:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800364:	8b 45 0c             	mov    0xc(%ebp),%eax
  800367:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800372:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800378:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037c:	c7 04 24 05 03 80 00 	movl   $0x800305,(%esp)
  800383:	e8 7c 01 00 00       	call   800504 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800388:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80038e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800392:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800398:	89 04 24             	mov    %eax,(%esp)
  80039b:	e8 d6 09 00 00       	call   800d76 <sys_cputs>

	return b.cnt;
}
  8003a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003ae:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	89 04 24             	mov    %eax,(%esp)
  8003bb:	e8 87 ff ff ff       	call   800347 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    
  8003c2:	66 90                	xchg   %ax,%ax
  8003c4:	66 90                	xchg   %ax,%ax
  8003c6:	66 90                	xchg   %ax,%ax
  8003c8:	66 90                	xchg   %ax,%ax
  8003ca:	66 90                	xchg   %ax,%ax
  8003cc:	66 90                	xchg   %ax,%ax
  8003ce:	66 90                	xchg   %ax,%ax

008003d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	57                   	push   %edi
  8003d4:	56                   	push   %esi
  8003d5:	53                   	push   %ebx
  8003d6:	83 ec 3c             	sub    $0x3c,%esp
  8003d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003dc:	89 d7                	mov    %edx,%edi
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e7:	89 c3                	mov    %eax,%ebx
  8003e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003fa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003fd:	39 d9                	cmp    %ebx,%ecx
  8003ff:	72 05                	jb     800406 <printnum+0x36>
  800401:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800404:	77 69                	ja     80046f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800406:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800409:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80040d:	83 ee 01             	sub    $0x1,%esi
  800410:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800414:	89 44 24 08          	mov    %eax,0x8(%esp)
  800418:	8b 44 24 08          	mov    0x8(%esp),%eax
  80041c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800420:	89 c3                	mov    %eax,%ebx
  800422:	89 d6                	mov    %edx,%esi
  800424:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800427:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80042a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80042e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800435:	89 04 24             	mov    %eax,(%esp)
  800438:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80043f:	e8 0c 22 00 00       	call   802650 <__udivdi3>
  800444:	89 d9                	mov    %ebx,%ecx
  800446:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80044a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80044e:	89 04 24             	mov    %eax,(%esp)
  800451:	89 54 24 04          	mov    %edx,0x4(%esp)
  800455:	89 fa                	mov    %edi,%edx
  800457:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80045a:	e8 71 ff ff ff       	call   8003d0 <printnum>
  80045f:	eb 1b                	jmp    80047c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800461:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800465:	8b 45 18             	mov    0x18(%ebp),%eax
  800468:	89 04 24             	mov    %eax,(%esp)
  80046b:	ff d3                	call   *%ebx
  80046d:	eb 03                	jmp    800472 <printnum+0xa2>
  80046f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800472:	83 ee 01             	sub    $0x1,%esi
  800475:	85 f6                	test   %esi,%esi
  800477:	7f e8                	jg     800461 <printnum+0x91>
  800479:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80047c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800480:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800484:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800487:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80048a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80048e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800495:	89 04 24             	mov    %eax,(%esp)
  800498:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80049b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049f:	e8 dc 22 00 00       	call   802780 <__umoddi3>
  8004a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004a8:	0f be 80 9b 29 80 00 	movsbl 0x80299b(%eax),%eax
  8004af:	89 04 24             	mov    %eax,(%esp)
  8004b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004b5:	ff d0                	call   *%eax
}
  8004b7:	83 c4 3c             	add    $0x3c,%esp
  8004ba:	5b                   	pop    %ebx
  8004bb:	5e                   	pop    %esi
  8004bc:	5f                   	pop    %edi
  8004bd:	5d                   	pop    %ebp
  8004be:	c3                   	ret    

008004bf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004bf:	55                   	push   %ebp
  8004c0:	89 e5                	mov    %esp,%ebp
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004c5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004c9:	8b 10                	mov    (%eax),%edx
  8004cb:	3b 50 04             	cmp    0x4(%eax),%edx
  8004ce:	73 0a                	jae    8004da <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004d3:	89 08                	mov    %ecx,(%eax)
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	88 02                	mov    %al,(%edx)
}
  8004da:	5d                   	pop    %ebp
  8004db:	c3                   	ret    

008004dc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
  8004df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004e2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	89 04 24             	mov    %eax,(%esp)
  8004fd:	e8 02 00 00 00       	call   800504 <vprintfmt>
	va_end(ap);
}
  800502:	c9                   	leave  
  800503:	c3                   	ret    

00800504 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	57                   	push   %edi
  800508:	56                   	push   %esi
  800509:	53                   	push   %ebx
  80050a:	83 ec 3c             	sub    $0x3c,%esp
  80050d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800510:	eb 17                	jmp    800529 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800512:	85 c0                	test   %eax,%eax
  800514:	0f 84 4b 04 00 00    	je     800965 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80051a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800521:	89 04 24             	mov    %eax,(%esp)
  800524:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800527:	89 fb                	mov    %edi,%ebx
  800529:	8d 7b 01             	lea    0x1(%ebx),%edi
  80052c:	0f b6 03             	movzbl (%ebx),%eax
  80052f:	83 f8 25             	cmp    $0x25,%eax
  800532:	75 de                	jne    800512 <vprintfmt+0xe>
  800534:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800538:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80053f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800544:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80054b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800550:	eb 18                	jmp    80056a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800552:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800554:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800558:	eb 10                	jmp    80056a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80055c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800560:	eb 08                	jmp    80056a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800562:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800565:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056a:	8d 5f 01             	lea    0x1(%edi),%ebx
  80056d:	0f b6 17             	movzbl (%edi),%edx
  800570:	0f b6 c2             	movzbl %dl,%eax
  800573:	83 ea 23             	sub    $0x23,%edx
  800576:	80 fa 55             	cmp    $0x55,%dl
  800579:	0f 87 c2 03 00 00    	ja     800941 <vprintfmt+0x43d>
  80057f:	0f b6 d2             	movzbl %dl,%edx
  800582:	ff 24 95 e0 2a 80 00 	jmp    *0x802ae0(,%edx,4)
  800589:	89 df                	mov    %ebx,%edi
  80058b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800590:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800593:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800597:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  80059a:	8d 50 d0             	lea    -0x30(%eax),%edx
  80059d:	83 fa 09             	cmp    $0x9,%edx
  8005a0:	77 33                	ja     8005d5 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005a5:	eb e9                	jmp    800590 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 30                	mov    (%eax),%esi
  8005ac:	8d 40 04             	lea    0x4(%eax),%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005b4:	eb 1f                	jmp    8005d5 <vprintfmt+0xd1>
  8005b6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005b9:	85 ff                	test   %edi,%edi
  8005bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c0:	0f 49 c7             	cmovns %edi,%eax
  8005c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c6:	89 df                	mov    %ebx,%edi
  8005c8:	eb a0                	jmp    80056a <vprintfmt+0x66>
  8005ca:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005cc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  8005d3:	eb 95                	jmp    80056a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  8005d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d9:	79 8f                	jns    80056a <vprintfmt+0x66>
  8005db:	eb 85                	jmp    800562 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005dd:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e0:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005e2:	eb 86                	jmp    80056a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8d 70 04             	lea    0x4(%eax),%esi
  8005ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	89 04 24             	mov    %eax,(%esp)
  8005f9:	ff 55 08             	call   *0x8(%ebp)
  8005fc:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  8005ff:	e9 25 ff ff ff       	jmp    800529 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 70 04             	lea    0x4(%eax),%esi
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	99                   	cltd   
  80060d:	31 d0                	xor    %edx,%eax
  80060f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800611:	83 f8 15             	cmp    $0x15,%eax
  800614:	7f 0b                	jg     800621 <vprintfmt+0x11d>
  800616:	8b 14 85 40 2c 80 00 	mov    0x802c40(,%eax,4),%edx
  80061d:	85 d2                	test   %edx,%edx
  80061f:	75 26                	jne    800647 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800621:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800625:	c7 44 24 08 b3 29 80 	movl   $0x8029b3,0x8(%esp)
  80062c:	00 
  80062d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800630:	89 44 24 04          	mov    %eax,0x4(%esp)
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	89 04 24             	mov    %eax,(%esp)
  80063a:	e8 9d fe ff ff       	call   8004dc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80063f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800642:	e9 e2 fe ff ff       	jmp    800529 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800647:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80064b:	c7 44 24 08 92 2d 80 	movl   $0x802d92,0x8(%esp)
  800652:	00 
  800653:	8b 45 0c             	mov    0xc(%ebp),%eax
  800656:	89 44 24 04          	mov    %eax,0x4(%esp)
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	89 04 24             	mov    %eax,(%esp)
  800660:	e8 77 fe ff ff       	call   8004dc <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800665:	89 75 14             	mov    %esi,0x14(%ebp)
  800668:	e9 bc fe ff ff       	jmp    800529 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800673:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800676:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80067a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80067c:	85 ff                	test   %edi,%edi
  80067e:	b8 ac 29 80 00       	mov    $0x8029ac,%eax
  800683:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800686:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80068a:	0f 84 94 00 00 00    	je     800724 <vprintfmt+0x220>
  800690:	85 c9                	test   %ecx,%ecx
  800692:	0f 8e 94 00 00 00    	jle    80072c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  800698:	89 74 24 04          	mov    %esi,0x4(%esp)
  80069c:	89 3c 24             	mov    %edi,(%esp)
  80069f:	e8 64 03 00 00       	call   800a08 <strnlen>
  8006a4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006a7:	29 c1                	sub    %eax,%ecx
  8006a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  8006ac:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  8006b0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8006b3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8006b9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006bc:	89 cb                	mov    %ecx,%ebx
  8006be:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c0:	eb 0f                	jmp    8006d1 <vprintfmt+0x1cd>
					putch(padc, putdat);
  8006c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c9:	89 3c 24             	mov    %edi,(%esp)
  8006cc:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ce:	83 eb 01             	sub    $0x1,%ebx
  8006d1:	85 db                	test   %ebx,%ebx
  8006d3:	7f ed                	jg     8006c2 <vprintfmt+0x1be>
  8006d5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006de:	85 c9                	test   %ecx,%ecx
  8006e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e5:	0f 49 c1             	cmovns %ecx,%eax
  8006e8:	29 c1                	sub    %eax,%ecx
  8006ea:	89 cb                	mov    %ecx,%ebx
  8006ec:	eb 44                	jmp    800732 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f2:	74 1e                	je     800712 <vprintfmt+0x20e>
  8006f4:	0f be d2             	movsbl %dl,%edx
  8006f7:	83 ea 20             	sub    $0x20,%edx
  8006fa:	83 fa 5e             	cmp    $0x5e,%edx
  8006fd:	76 13                	jbe    800712 <vprintfmt+0x20e>
					putch('?', putdat);
  8006ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800702:	89 44 24 04          	mov    %eax,0x4(%esp)
  800706:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80070d:	ff 55 08             	call   *0x8(%ebp)
  800710:	eb 0d                	jmp    80071f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800712:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800715:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800719:	89 04 24             	mov    %eax,(%esp)
  80071c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80071f:	83 eb 01             	sub    $0x1,%ebx
  800722:	eb 0e                	jmp    800732 <vprintfmt+0x22e>
  800724:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800727:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80072a:	eb 06                	jmp    800732 <vprintfmt+0x22e>
  80072c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80072f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800732:	83 c7 01             	add    $0x1,%edi
  800735:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800739:	0f be c2             	movsbl %dl,%eax
  80073c:	85 c0                	test   %eax,%eax
  80073e:	74 27                	je     800767 <vprintfmt+0x263>
  800740:	85 f6                	test   %esi,%esi
  800742:	78 aa                	js     8006ee <vprintfmt+0x1ea>
  800744:	83 ee 01             	sub    $0x1,%esi
  800747:	79 a5                	jns    8006ee <vprintfmt+0x1ea>
  800749:	89 d8                	mov    %ebx,%eax
  80074b:	8b 75 08             	mov    0x8(%ebp),%esi
  80074e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800751:	89 c3                	mov    %eax,%ebx
  800753:	eb 18                	jmp    80076d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800755:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800759:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800760:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800762:	83 eb 01             	sub    $0x1,%ebx
  800765:	eb 06                	jmp    80076d <vprintfmt+0x269>
  800767:	8b 75 08             	mov    0x8(%ebp),%esi
  80076a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80076d:	85 db                	test   %ebx,%ebx
  80076f:	7f e4                	jg     800755 <vprintfmt+0x251>
  800771:	89 75 08             	mov    %esi,0x8(%ebp)
  800774:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800777:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80077a:	e9 aa fd ff ff       	jmp    800529 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80077f:	83 f9 01             	cmp    $0x1,%ecx
  800782:	7e 10                	jle    800794 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8b 30                	mov    (%eax),%esi
  800789:	8b 78 04             	mov    0x4(%eax),%edi
  80078c:	8d 40 08             	lea    0x8(%eax),%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
  800792:	eb 26                	jmp    8007ba <vprintfmt+0x2b6>
	else if (lflag)
  800794:	85 c9                	test   %ecx,%ecx
  800796:	74 12                	je     8007aa <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 30                	mov    (%eax),%esi
  80079d:	89 f7                	mov    %esi,%edi
  80079f:	c1 ff 1f             	sar    $0x1f,%edi
  8007a2:	8d 40 04             	lea    0x4(%eax),%eax
  8007a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a8:	eb 10                	jmp    8007ba <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8b 30                	mov    (%eax),%esi
  8007af:	89 f7                	mov    %esi,%edi
  8007b1:	c1 ff 1f             	sar    $0x1f,%edi
  8007b4:	8d 40 04             	lea    0x4(%eax),%eax
  8007b7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ba:	89 f0                	mov    %esi,%eax
  8007bc:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007be:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007c3:	85 ff                	test   %edi,%edi
  8007c5:	0f 89 3a 01 00 00    	jns    800905 <vprintfmt+0x401>
				putch('-', putdat);
  8007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007d9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007dc:	89 f0                	mov    %esi,%eax
  8007de:	89 fa                	mov    %edi,%edx
  8007e0:	f7 d8                	neg    %eax
  8007e2:	83 d2 00             	adc    $0x0,%edx
  8007e5:	f7 da                	neg    %edx
			}
			base = 10;
  8007e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007ec:	e9 14 01 00 00       	jmp    800905 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007f1:	83 f9 01             	cmp    $0x1,%ecx
  8007f4:	7e 13                	jle    800809 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8b 50 04             	mov    0x4(%eax),%edx
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	8b 75 14             	mov    0x14(%ebp),%esi
  800801:	8d 4e 08             	lea    0x8(%esi),%ecx
  800804:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800807:	eb 2c                	jmp    800835 <vprintfmt+0x331>
	else if (lflag)
  800809:	85 c9                	test   %ecx,%ecx
  80080b:	74 15                	je     800822 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	ba 00 00 00 00       	mov    $0x0,%edx
  800817:	8b 75 14             	mov    0x14(%ebp),%esi
  80081a:	8d 76 04             	lea    0x4(%esi),%esi
  80081d:	89 75 14             	mov    %esi,0x14(%ebp)
  800820:	eb 13                	jmp    800835 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	ba 00 00 00 00       	mov    $0x0,%edx
  80082c:	8b 75 14             	mov    0x14(%ebp),%esi
  80082f:	8d 76 04             	lea    0x4(%esi),%esi
  800832:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800835:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80083a:	e9 c6 00 00 00       	jmp    800905 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80083f:	83 f9 01             	cmp    $0x1,%ecx
  800842:	7e 13                	jle    800857 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 50 04             	mov    0x4(%eax),%edx
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	8b 75 14             	mov    0x14(%ebp),%esi
  80084f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800852:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800855:	eb 24                	jmp    80087b <vprintfmt+0x377>
	else if (lflag)
  800857:	85 c9                	test   %ecx,%ecx
  800859:	74 11                	je     80086c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	99                   	cltd   
  800861:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800864:	8d 71 04             	lea    0x4(%ecx),%esi
  800867:	89 75 14             	mov    %esi,0x14(%ebp)
  80086a:	eb 0f                	jmp    80087b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	99                   	cltd   
  800872:	8b 75 14             	mov    0x14(%ebp),%esi
  800875:	8d 76 04             	lea    0x4(%esi),%esi
  800878:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80087b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800880:	e9 80 00 00 00       	jmp    800905 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800885:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80088f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800896:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8008a7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8008aa:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008ae:	8b 06                	mov    (%esi),%eax
  8008b0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8008b5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8008ba:	eb 49                	jmp    800905 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008bc:	83 f9 01             	cmp    $0x1,%ecx
  8008bf:	7e 13                	jle    8008d4 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8b 50 04             	mov    0x4(%eax),%edx
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	8b 75 14             	mov    0x14(%ebp),%esi
  8008cc:	8d 4e 08             	lea    0x8(%esi),%ecx
  8008cf:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008d2:	eb 2c                	jmp    800900 <vprintfmt+0x3fc>
	else if (lflag)
  8008d4:	85 c9                	test   %ecx,%ecx
  8008d6:	74 15                	je     8008ed <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8008e5:	8d 71 04             	lea    0x4(%ecx),%esi
  8008e8:	89 75 14             	mov    %esi,0x14(%ebp)
  8008eb:	eb 13                	jmp    800900 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f7:	8b 75 14             	mov    0x14(%ebp),%esi
  8008fa:	8d 76 04             	lea    0x4(%esi),%esi
  8008fd:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800900:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800905:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800909:	89 74 24 10          	mov    %esi,0x10(%esp)
  80090d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800910:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800914:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800918:	89 04 24             	mov    %eax,(%esp)
  80091b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80091f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	e8 a6 fa ff ff       	call   8003d0 <printnum>
			break;
  80092a:	e9 fa fb ff ff       	jmp    800529 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80092f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800932:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800936:	89 04 24             	mov    %eax,(%esp)
  800939:	ff 55 08             	call   *0x8(%ebp)
			break;
  80093c:	e9 e8 fb ff ff       	jmp    800529 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	89 44 24 04          	mov    %eax,0x4(%esp)
  800948:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80094f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800952:	89 fb                	mov    %edi,%ebx
  800954:	eb 03                	jmp    800959 <vprintfmt+0x455>
  800956:	83 eb 01             	sub    $0x1,%ebx
  800959:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80095d:	75 f7                	jne    800956 <vprintfmt+0x452>
  80095f:	90                   	nop
  800960:	e9 c4 fb ff ff       	jmp    800529 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800965:	83 c4 3c             	add    $0x3c,%esp
  800968:	5b                   	pop    %ebx
  800969:	5e                   	pop    %esi
  80096a:	5f                   	pop    %edi
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	83 ec 28             	sub    $0x28,%esp
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800979:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80097c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800980:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800983:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80098a:	85 c0                	test   %eax,%eax
  80098c:	74 30                	je     8009be <vsnprintf+0x51>
  80098e:	85 d2                	test   %edx,%edx
  800990:	7e 2c                	jle    8009be <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800992:	8b 45 14             	mov    0x14(%ebp),%eax
  800995:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800999:	8b 45 10             	mov    0x10(%ebp),%eax
  80099c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a7:	c7 04 24 bf 04 80 00 	movl   $0x8004bf,(%esp)
  8009ae:	e8 51 fb ff ff       	call   800504 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009bc:	eb 05                	jmp    8009c3 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8009be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8009c3:	c9                   	leave  
  8009c4:	c3                   	ret    

008009c5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009cb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	89 04 24             	mov    %eax,(%esp)
  8009e6:	e8 82 ff ff ff       	call   80096d <vsnprintf>
	va_end(ap);

	return rc;
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    
  8009ed:	66 90                	xchg   %ax,%ax
  8009ef:	90                   	nop

008009f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	eb 03                	jmp    800a00 <strlen+0x10>
		n++;
  8009fd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a00:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a04:	75 f7                	jne    8009fd <strlen+0xd>
		n++;
	return n;
}
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a11:	b8 00 00 00 00       	mov    $0x0,%eax
  800a16:	eb 03                	jmp    800a1b <strnlen+0x13>
		n++;
  800a18:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1b:	39 d0                	cmp    %edx,%eax
  800a1d:	74 06                	je     800a25 <strnlen+0x1d>
  800a1f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a23:	75 f3                	jne    800a18 <strnlen+0x10>
		n++;
	return n;
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	53                   	push   %ebx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a31:	89 c2                	mov    %eax,%edx
  800a33:	83 c2 01             	add    $0x1,%edx
  800a36:	83 c1 01             	add    $0x1,%ecx
  800a39:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a3d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a40:	84 db                	test   %bl,%bl
  800a42:	75 ef                	jne    800a33 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a44:	5b                   	pop    %ebx
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	53                   	push   %ebx
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a51:	89 1c 24             	mov    %ebx,(%esp)
  800a54:	e8 97 ff ff ff       	call   8009f0 <strlen>
	strcpy(dst + len, src);
  800a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a60:	01 d8                	add    %ebx,%eax
  800a62:	89 04 24             	mov    %eax,(%esp)
  800a65:	e8 bd ff ff ff       	call   800a27 <strcpy>
	return dst;
}
  800a6a:	89 d8                	mov    %ebx,%eax
  800a6c:	83 c4 08             	add    $0x8,%esp
  800a6f:	5b                   	pop    %ebx
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	56                   	push   %esi
  800a76:	53                   	push   %ebx
  800a77:	8b 75 08             	mov    0x8(%ebp),%esi
  800a7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a7d:	89 f3                	mov    %esi,%ebx
  800a7f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a82:	89 f2                	mov    %esi,%edx
  800a84:	eb 0f                	jmp    800a95 <strncpy+0x23>
		*dst++ = *src;
  800a86:	83 c2 01             	add    $0x1,%edx
  800a89:	0f b6 01             	movzbl (%ecx),%eax
  800a8c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a8f:	80 39 01             	cmpb   $0x1,(%ecx)
  800a92:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a95:	39 da                	cmp    %ebx,%edx
  800a97:	75 ed                	jne    800a86 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a99:	89 f0                	mov    %esi,%eax
  800a9b:	5b                   	pop    %ebx
  800a9c:	5e                   	pop    %esi
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    

00800a9f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	56                   	push   %esi
  800aa3:	53                   	push   %ebx
  800aa4:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800aad:	89 f0                	mov    %esi,%eax
  800aaf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ab3:	85 c9                	test   %ecx,%ecx
  800ab5:	75 0b                	jne    800ac2 <strlcpy+0x23>
  800ab7:	eb 1d                	jmp    800ad6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ab9:	83 c0 01             	add    $0x1,%eax
  800abc:	83 c2 01             	add    $0x1,%edx
  800abf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ac2:	39 d8                	cmp    %ebx,%eax
  800ac4:	74 0b                	je     800ad1 <strlcpy+0x32>
  800ac6:	0f b6 0a             	movzbl (%edx),%ecx
  800ac9:	84 c9                	test   %cl,%cl
  800acb:	75 ec                	jne    800ab9 <strlcpy+0x1a>
  800acd:	89 c2                	mov    %eax,%edx
  800acf:	eb 02                	jmp    800ad3 <strlcpy+0x34>
  800ad1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800ad3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800ad6:	29 f0                	sub    %esi,%eax
}
  800ad8:	5b                   	pop    %ebx
  800ad9:	5e                   	pop    %esi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ae5:	eb 06                	jmp    800aed <strcmp+0x11>
		p++, q++;
  800ae7:	83 c1 01             	add    $0x1,%ecx
  800aea:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aed:	0f b6 01             	movzbl (%ecx),%eax
  800af0:	84 c0                	test   %al,%al
  800af2:	74 04                	je     800af8 <strcmp+0x1c>
  800af4:	3a 02                	cmp    (%edx),%al
  800af6:	74 ef                	je     800ae7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af8:	0f b6 c0             	movzbl %al,%eax
  800afb:	0f b6 12             	movzbl (%edx),%edx
  800afe:	29 d0                	sub    %edx,%eax
}
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0c:	89 c3                	mov    %eax,%ebx
  800b0e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b11:	eb 06                	jmp    800b19 <strncmp+0x17>
		n--, p++, q++;
  800b13:	83 c0 01             	add    $0x1,%eax
  800b16:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b19:	39 d8                	cmp    %ebx,%eax
  800b1b:	74 15                	je     800b32 <strncmp+0x30>
  800b1d:	0f b6 08             	movzbl (%eax),%ecx
  800b20:	84 c9                	test   %cl,%cl
  800b22:	74 04                	je     800b28 <strncmp+0x26>
  800b24:	3a 0a                	cmp    (%edx),%cl
  800b26:	74 eb                	je     800b13 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b28:	0f b6 00             	movzbl (%eax),%eax
  800b2b:	0f b6 12             	movzbl (%edx),%edx
  800b2e:	29 d0                	sub    %edx,%eax
  800b30:	eb 05                	jmp    800b37 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b32:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b37:	5b                   	pop    %ebx
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    

00800b3a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b44:	eb 07                	jmp    800b4d <strchr+0x13>
		if (*s == c)
  800b46:	38 ca                	cmp    %cl,%dl
  800b48:	74 0f                	je     800b59 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b4a:	83 c0 01             	add    $0x1,%eax
  800b4d:	0f b6 10             	movzbl (%eax),%edx
  800b50:	84 d2                	test   %dl,%dl
  800b52:	75 f2                	jne    800b46 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b65:	eb 07                	jmp    800b6e <strfind+0x13>
		if (*s == c)
  800b67:	38 ca                	cmp    %cl,%dl
  800b69:	74 0a                	je     800b75 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b6b:	83 c0 01             	add    $0x1,%eax
  800b6e:	0f b6 10             	movzbl (%eax),%edx
  800b71:	84 d2                	test   %dl,%dl
  800b73:	75 f2                	jne    800b67 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	57                   	push   %edi
  800b7b:	56                   	push   %esi
  800b7c:	53                   	push   %ebx
  800b7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b83:	85 c9                	test   %ecx,%ecx
  800b85:	74 36                	je     800bbd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b87:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b8d:	75 28                	jne    800bb7 <memset+0x40>
  800b8f:	f6 c1 03             	test   $0x3,%cl
  800b92:	75 23                	jne    800bb7 <memset+0x40>
		c &= 0xFF;
  800b94:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b98:	89 d3                	mov    %edx,%ebx
  800b9a:	c1 e3 08             	shl    $0x8,%ebx
  800b9d:	89 d6                	mov    %edx,%esi
  800b9f:	c1 e6 18             	shl    $0x18,%esi
  800ba2:	89 d0                	mov    %edx,%eax
  800ba4:	c1 e0 10             	shl    $0x10,%eax
  800ba7:	09 f0                	or     %esi,%eax
  800ba9:	09 c2                	or     %eax,%edx
  800bab:	89 d0                	mov    %edx,%eax
  800bad:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800baf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800bb2:	fc                   	cld    
  800bb3:	f3 ab                	rep stos %eax,%es:(%edi)
  800bb5:	eb 06                	jmp    800bbd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bba:	fc                   	cld    
  800bbb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bbd:	89 f8                	mov    %edi,%eax
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	57                   	push   %edi
  800bc8:	56                   	push   %esi
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bcf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bd2:	39 c6                	cmp    %eax,%esi
  800bd4:	73 35                	jae    800c0b <memmove+0x47>
  800bd6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bd9:	39 d0                	cmp    %edx,%eax
  800bdb:	73 2e                	jae    800c0b <memmove+0x47>
		s += n;
		d += n;
  800bdd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800be0:	89 d6                	mov    %edx,%esi
  800be2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bea:	75 13                	jne    800bff <memmove+0x3b>
  800bec:	f6 c1 03             	test   $0x3,%cl
  800bef:	75 0e                	jne    800bff <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bf1:	83 ef 04             	sub    $0x4,%edi
  800bf4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bf7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800bfa:	fd                   	std    
  800bfb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bfd:	eb 09                	jmp    800c08 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bff:	83 ef 01             	sub    $0x1,%edi
  800c02:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c05:	fd                   	std    
  800c06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c08:	fc                   	cld    
  800c09:	eb 1d                	jmp    800c28 <memmove+0x64>
  800c0b:	89 f2                	mov    %esi,%edx
  800c0d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0f:	f6 c2 03             	test   $0x3,%dl
  800c12:	75 0f                	jne    800c23 <memmove+0x5f>
  800c14:	f6 c1 03             	test   $0x3,%cl
  800c17:	75 0a                	jne    800c23 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c19:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c1c:	89 c7                	mov    %eax,%edi
  800c1e:	fc                   	cld    
  800c1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c21:	eb 05                	jmp    800c28 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c23:	89 c7                	mov    %eax,%edi
  800c25:	fc                   	cld    
  800c26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c32:	8b 45 10             	mov    0x10(%ebp),%eax
  800c35:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	89 04 24             	mov    %eax,(%esp)
  800c46:	e8 79 ff ff ff       	call   800bc4 <memmove>
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c58:	89 d6                	mov    %edx,%esi
  800c5a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c5d:	eb 1a                	jmp    800c79 <memcmp+0x2c>
		if (*s1 != *s2)
  800c5f:	0f b6 02             	movzbl (%edx),%eax
  800c62:	0f b6 19             	movzbl (%ecx),%ebx
  800c65:	38 d8                	cmp    %bl,%al
  800c67:	74 0a                	je     800c73 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800c69:	0f b6 c0             	movzbl %al,%eax
  800c6c:	0f b6 db             	movzbl %bl,%ebx
  800c6f:	29 d8                	sub    %ebx,%eax
  800c71:	eb 0f                	jmp    800c82 <memcmp+0x35>
		s1++, s2++;
  800c73:	83 c2 01             	add    $0x1,%edx
  800c76:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c79:	39 f2                	cmp    %esi,%edx
  800c7b:	75 e2                	jne    800c5f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c8f:	89 c2                	mov    %eax,%edx
  800c91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c94:	eb 07                	jmp    800c9d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c96:	38 08                	cmp    %cl,(%eax)
  800c98:	74 07                	je     800ca1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c9a:	83 c0 01             	add    $0x1,%eax
  800c9d:	39 d0                	cmp    %edx,%eax
  800c9f:	72 f5                	jb     800c96 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800caf:	eb 03                	jmp    800cb4 <strtol+0x11>
		s++;
  800cb1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb4:	0f b6 0a             	movzbl (%edx),%ecx
  800cb7:	80 f9 09             	cmp    $0x9,%cl
  800cba:	74 f5                	je     800cb1 <strtol+0xe>
  800cbc:	80 f9 20             	cmp    $0x20,%cl
  800cbf:	74 f0                	je     800cb1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cc1:	80 f9 2b             	cmp    $0x2b,%cl
  800cc4:	75 0a                	jne    800cd0 <strtol+0x2d>
		s++;
  800cc6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800cc9:	bf 00 00 00 00       	mov    $0x0,%edi
  800cce:	eb 11                	jmp    800ce1 <strtol+0x3e>
  800cd0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800cd5:	80 f9 2d             	cmp    $0x2d,%cl
  800cd8:	75 07                	jne    800ce1 <strtol+0x3e>
		s++, neg = 1;
  800cda:	8d 52 01             	lea    0x1(%edx),%edx
  800cdd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ce6:	75 15                	jne    800cfd <strtol+0x5a>
  800ce8:	80 3a 30             	cmpb   $0x30,(%edx)
  800ceb:	75 10                	jne    800cfd <strtol+0x5a>
  800ced:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cf1:	75 0a                	jne    800cfd <strtol+0x5a>
		s += 2, base = 16;
  800cf3:	83 c2 02             	add    $0x2,%edx
  800cf6:	b8 10 00 00 00       	mov    $0x10,%eax
  800cfb:	eb 10                	jmp    800d0d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	75 0c                	jne    800d0d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d01:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d03:	80 3a 30             	cmpb   $0x30,(%edx)
  800d06:	75 05                	jne    800d0d <strtol+0x6a>
		s++, base = 8;
  800d08:	83 c2 01             	add    $0x1,%edx
  800d0b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d12:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d15:	0f b6 0a             	movzbl (%edx),%ecx
  800d18:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d1b:	89 f0                	mov    %esi,%eax
  800d1d:	3c 09                	cmp    $0x9,%al
  800d1f:	77 08                	ja     800d29 <strtol+0x86>
			dig = *s - '0';
  800d21:	0f be c9             	movsbl %cl,%ecx
  800d24:	83 e9 30             	sub    $0x30,%ecx
  800d27:	eb 20                	jmp    800d49 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800d29:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800d2c:	89 f0                	mov    %esi,%eax
  800d2e:	3c 19                	cmp    $0x19,%al
  800d30:	77 08                	ja     800d3a <strtol+0x97>
			dig = *s - 'a' + 10;
  800d32:	0f be c9             	movsbl %cl,%ecx
  800d35:	83 e9 57             	sub    $0x57,%ecx
  800d38:	eb 0f                	jmp    800d49 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800d3a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800d3d:	89 f0                	mov    %esi,%eax
  800d3f:	3c 19                	cmp    $0x19,%al
  800d41:	77 16                	ja     800d59 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800d43:	0f be c9             	movsbl %cl,%ecx
  800d46:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d49:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d4c:	7d 0f                	jge    800d5d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800d4e:	83 c2 01             	add    $0x1,%edx
  800d51:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d55:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d57:	eb bc                	jmp    800d15 <strtol+0x72>
  800d59:	89 d8                	mov    %ebx,%eax
  800d5b:	eb 02                	jmp    800d5f <strtol+0xbc>
  800d5d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d63:	74 05                	je     800d6a <strtol+0xc7>
		*endptr = (char *) s;
  800d65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d68:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d6a:	f7 d8                	neg    %eax
  800d6c:	85 ff                	test   %edi,%edi
  800d6e:	0f 44 c3             	cmove  %ebx,%eax
}
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5f                   	pop    %edi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
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
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	8b 55 08             	mov    0x8(%ebp),%edx
  800d87:	89 c3                	mov    %eax,%ebx
  800d89:	89 c7                	mov    %eax,%edi
  800d8b:	89 c6                	mov    %eax,%esi
  800d8d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9f:	b8 01 00 00 00       	mov    $0x1,%eax
  800da4:	89 d1                	mov    %edx,%ecx
  800da6:	89 d3                	mov    %edx,%ebx
  800da8:	89 d7                	mov    %edx,%edi
  800daa:	89 d6                	mov    %edx,%esi
  800dac:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	89 cb                	mov    %ecx,%ebx
  800dcb:	89 cf                	mov    %ecx,%edi
  800dcd:	89 ce                	mov    %ecx,%esi
  800dcf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	7e 28                	jle    800dfd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800de0:	00 
  800de1:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800de8:	00 
  800de9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df0:	00 
  800df1:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800df8:	e8 b2 f4 ff ff       	call   8002af <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dfd:	83 c4 2c             	add    $0x2c,%esp
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5f                   	pop    %edi
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
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
  800e0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e13:	b8 04 00 00 00       	mov    $0x4,%eax
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	89 cb                	mov    %ecx,%ebx
  800e1d:	89 cf                	mov    %ecx,%edi
  800e1f:	89 ce                	mov    %ecx,%esi
  800e21:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e23:	85 c0                	test   %eax,%eax
  800e25:	7e 28                	jle    800e4f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e27:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e2b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e32:	00 
  800e33:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800e3a:	00 
  800e3b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e42:	00 
  800e43:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800e4a:	e8 60 f4 ff ff       	call   8002af <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800e4f:	83 c4 2c             	add    $0x2c,%esp
  800e52:	5b                   	pop    %ebx
  800e53:	5e                   	pop    %esi
  800e54:	5f                   	pop    %edi
  800e55:	5d                   	pop    %ebp
  800e56:	c3                   	ret    

00800e57 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	57                   	push   %edi
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e62:	b8 02 00 00 00       	mov    $0x2,%eax
  800e67:	89 d1                	mov    %edx,%ecx
  800e69:	89 d3                	mov    %edx,%ebx
  800e6b:	89 d7                	mov    %edx,%edi
  800e6d:	89 d6                	mov    %edx,%esi
  800e6f:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <sys_yield>:

void
sys_yield(void)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e81:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e86:	89 d1                	mov    %edx,%ecx
  800e88:	89 d3                	mov    %edx,%ebx
  800e8a:	89 d7                	mov    %edx,%edi
  800e8c:	89 d6                	mov    %edx,%esi
  800e8e:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	57                   	push   %edi
  800e99:	56                   	push   %esi
  800e9a:	53                   	push   %ebx
  800e9b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9e:	be 00 00 00 00       	mov    $0x0,%esi
  800ea3:	b8 05 00 00 00       	mov    $0x5,%eax
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb1:	89 f7                	mov    %esi,%edi
  800eb3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	7e 28                	jle    800ee1 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ebd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ec4:	00 
  800ec5:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800ecc:	00 
  800ecd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed4:	00 
  800ed5:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800edc:	e8 ce f3 ff ff       	call   8002af <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ee1:	83 c4 2c             	add    $0x2c,%esp
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	57                   	push   %edi
  800eed:	56                   	push   %esi
  800eee:	53                   	push   %ebx
  800eef:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef2:	b8 06 00 00 00       	mov    $0x6,%eax
  800ef7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efa:	8b 55 08             	mov    0x8(%ebp),%edx
  800efd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f00:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f03:	8b 75 18             	mov    0x18(%ebp),%esi
  800f06:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	7e 28                	jle    800f34 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f10:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f17:	00 
  800f18:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800f1f:	00 
  800f20:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f27:	00 
  800f28:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800f2f:	e8 7b f3 ff ff       	call   8002af <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f34:	83 c4 2c             	add    $0x2c,%esp
  800f37:	5b                   	pop    %ebx
  800f38:	5e                   	pop    %esi
  800f39:	5f                   	pop    %edi
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    

00800f3c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	57                   	push   %edi
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
  800f42:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4a:	b8 07 00 00 00       	mov    $0x7,%eax
  800f4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	89 df                	mov    %ebx,%edi
  800f57:	89 de                	mov    %ebx,%esi
  800f59:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	7e 28                	jle    800f87 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f63:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800f6a:	00 
  800f6b:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800f72:	00 
  800f73:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7a:	00 
  800f7b:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800f82:	e8 28 f3 ff ff       	call   8002af <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f87:	83 c4 2c             	add    $0x2c,%esp
  800f8a:	5b                   	pop    %ebx
  800f8b:	5e                   	pop    %esi
  800f8c:	5f                   	pop    %edi
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	57                   	push   %edi
  800f93:	56                   	push   %esi
  800f94:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f95:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9a:	b8 10 00 00 00       	mov    $0x10,%eax
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	89 cb                	mov    %ecx,%ebx
  800fa4:	89 cf                	mov    %ecx,%edi
  800fa6:	89 ce                	mov    %ecx,%esi
  800fa8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  800faa:	5b                   	pop    %ebx
  800fab:	5e                   	pop    %esi
  800fac:	5f                   	pop    %edi
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    

00800faf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	57                   	push   %edi
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
  800fb5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbd:	b8 09 00 00 00       	mov    $0x9,%eax
  800fc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc8:	89 df                	mov    %ebx,%edi
  800fca:	89 de                	mov    %ebx,%esi
  800fcc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fce:	85 c0                	test   %eax,%eax
  800fd0:	7e 28                	jle    800ffa <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd6:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fdd:	00 
  800fde:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  800fe5:	00 
  800fe6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fed:	00 
  800fee:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  800ff5:	e8 b5 f2 ff ff       	call   8002af <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ffa:	83 c4 2c             	add    $0x2c,%esp
  800ffd:	5b                   	pop    %ebx
  800ffe:	5e                   	pop    %esi
  800fff:	5f                   	pop    %edi
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    

00801002 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	57                   	push   %edi
  801006:	56                   	push   %esi
  801007:	53                   	push   %ebx
  801008:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801010:	b8 0a 00 00 00       	mov    $0xa,%eax
  801015:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801018:	8b 55 08             	mov    0x8(%ebp),%edx
  80101b:	89 df                	mov    %ebx,%edi
  80101d:	89 de                	mov    %ebx,%esi
  80101f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801021:	85 c0                	test   %eax,%eax
  801023:	7e 28                	jle    80104d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801025:	89 44 24 10          	mov    %eax,0x10(%esp)
  801029:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801030:	00 
  801031:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  801038:	00 
  801039:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801040:	00 
  801041:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  801048:	e8 62 f2 ff ff       	call   8002af <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80104d:	83 c4 2c             	add    $0x2c,%esp
  801050:	5b                   	pop    %ebx
  801051:	5e                   	pop    %esi
  801052:	5f                   	pop    %edi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	57                   	push   %edi
  801059:	56                   	push   %esi
  80105a:	53                   	push   %ebx
  80105b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801063:	b8 0b 00 00 00       	mov    $0xb,%eax
  801068:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106b:	8b 55 08             	mov    0x8(%ebp),%edx
  80106e:	89 df                	mov    %ebx,%edi
  801070:	89 de                	mov    %ebx,%esi
  801072:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801074:	85 c0                	test   %eax,%eax
  801076:	7e 28                	jle    8010a0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801078:	89 44 24 10          	mov    %eax,0x10(%esp)
  80107c:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  801083:	00 
  801084:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  80108b:	00 
  80108c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801093:	00 
  801094:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  80109b:	e8 0f f2 ff ff       	call   8002af <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010a0:	83 c4 2c             	add    $0x2c,%esp
  8010a3:	5b                   	pop    %ebx
  8010a4:	5e                   	pop    %esi
  8010a5:	5f                   	pop    %edi
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	57                   	push   %edi
  8010ac:	56                   	push   %esi
  8010ad:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ae:	be 00 00 00 00       	mov    $0x0,%esi
  8010b3:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010c1:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	57                   	push   %edi
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
  8010d1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010d9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010de:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e1:	89 cb                	mov    %ecx,%ebx
  8010e3:	89 cf                	mov    %ecx,%edi
  8010e5:	89 ce                	mov    %ecx,%esi
  8010e7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	7e 28                	jle    801115 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f1:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8010f8:	00 
  8010f9:	c7 44 24 08 b7 2c 80 	movl   $0x802cb7,0x8(%esp)
  801100:	00 
  801101:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801108:	00 
  801109:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  801110:	e8 9a f1 ff ff       	call   8002af <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801115:	83 c4 2c             	add    $0x2c,%esp
  801118:	5b                   	pop    %ebx
  801119:	5e                   	pop    %esi
  80111a:	5f                   	pop    %edi
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	57                   	push   %edi
  801121:	56                   	push   %esi
  801122:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801123:	ba 00 00 00 00       	mov    $0x0,%edx
  801128:	b8 0f 00 00 00       	mov    $0xf,%eax
  80112d:	89 d1                	mov    %edx,%ecx
  80112f:	89 d3                	mov    %edx,%ebx
  801131:	89 d7                	mov    %edx,%edi
  801133:	89 d6                	mov    %edx,%esi
  801135:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801137:	5b                   	pop    %ebx
  801138:	5e                   	pop    %esi
  801139:	5f                   	pop    %edi
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    

0080113c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	57                   	push   %edi
  801140:	56                   	push   %esi
  801141:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801142:	bb 00 00 00 00       	mov    $0x0,%ebx
  801147:	b8 11 00 00 00       	mov    $0x11,%eax
  80114c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114f:	8b 55 08             	mov    0x8(%ebp),%edx
  801152:	89 df                	mov    %ebx,%edi
  801154:	89 de                	mov    %ebx,%esi
  801156:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801158:	5b                   	pop    %ebx
  801159:	5e                   	pop    %esi
  80115a:	5f                   	pop    %edi
  80115b:	5d                   	pop    %ebp
  80115c:	c3                   	ret    

0080115d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	57                   	push   %edi
  801161:	56                   	push   %esi
  801162:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801163:	bb 00 00 00 00       	mov    $0x0,%ebx
  801168:	b8 12 00 00 00       	mov    $0x12,%eax
  80116d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801170:	8b 55 08             	mov    0x8(%ebp),%edx
  801173:	89 df                	mov    %ebx,%edi
  801175:	89 de                	mov    %ebx,%esi
  801177:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  801179:	5b                   	pop    %ebx
  80117a:	5e                   	pop    %esi
  80117b:	5f                   	pop    %edi
  80117c:	5d                   	pop    %ebp
  80117d:	c3                   	ret    

0080117e <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	57                   	push   %edi
  801182:	56                   	push   %esi
  801183:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801184:	b9 00 00 00 00       	mov    $0x0,%ecx
  801189:	b8 13 00 00 00       	mov    $0x13,%eax
  80118e:	8b 55 08             	mov    0x8(%ebp),%edx
  801191:	89 cb                	mov    %ecx,%ebx
  801193:	89 cf                	mov    %ecx,%edi
  801195:	89 ce                	mov    %ecx,%esi
  801197:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  801199:	5b                   	pop    %ebx
  80119a:	5e                   	pop    %esi
  80119b:	5f                   	pop    %edi
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    
  80119e:	66 90                	xchg   %ax,%ax

008011a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8011ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8011bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011c5:	5d                   	pop    %ebp
  8011c6:	c3                   	ret    

008011c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011d2:	89 c2                	mov    %eax,%edx
  8011d4:	c1 ea 16             	shr    $0x16,%edx
  8011d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011de:	f6 c2 01             	test   $0x1,%dl
  8011e1:	74 11                	je     8011f4 <fd_alloc+0x2d>
  8011e3:	89 c2                	mov    %eax,%edx
  8011e5:	c1 ea 0c             	shr    $0xc,%edx
  8011e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011ef:	f6 c2 01             	test   $0x1,%dl
  8011f2:	75 09                	jne    8011fd <fd_alloc+0x36>
			*fd_store = fd;
  8011f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fb:	eb 17                	jmp    801214 <fd_alloc+0x4d>
  8011fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801202:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801207:	75 c9                	jne    8011d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801209:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80120f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801214:	5d                   	pop    %ebp
  801215:	c3                   	ret    

00801216 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80121c:	83 f8 1f             	cmp    $0x1f,%eax
  80121f:	77 36                	ja     801257 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801221:	c1 e0 0c             	shl    $0xc,%eax
  801224:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801229:	89 c2                	mov    %eax,%edx
  80122b:	c1 ea 16             	shr    $0x16,%edx
  80122e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801235:	f6 c2 01             	test   $0x1,%dl
  801238:	74 24                	je     80125e <fd_lookup+0x48>
  80123a:	89 c2                	mov    %eax,%edx
  80123c:	c1 ea 0c             	shr    $0xc,%edx
  80123f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801246:	f6 c2 01             	test   $0x1,%dl
  801249:	74 1a                	je     801265 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80124b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124e:	89 02                	mov    %eax,(%edx)
	return 0;
  801250:	b8 00 00 00 00       	mov    $0x0,%eax
  801255:	eb 13                	jmp    80126a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801257:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125c:	eb 0c                	jmp    80126a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80125e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801263:	eb 05                	jmp    80126a <fd_lookup+0x54>
  801265:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80126a:	5d                   	pop    %ebp
  80126b:	c3                   	ret    

0080126c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	83 ec 18             	sub    $0x18,%esp
  801272:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801275:	ba 00 00 00 00       	mov    $0x0,%edx
  80127a:	eb 13                	jmp    80128f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80127c:	39 08                	cmp    %ecx,(%eax)
  80127e:	75 0c                	jne    80128c <dev_lookup+0x20>
			*dev = devtab[i];
  801280:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801283:	89 01                	mov    %eax,(%ecx)
			return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	eb 38                	jmp    8012c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80128c:	83 c2 01             	add    $0x1,%edx
  80128f:	8b 04 95 60 2d 80 00 	mov    0x802d60(,%edx,4),%eax
  801296:	85 c0                	test   %eax,%eax
  801298:	75 e2                	jne    80127c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80129a:	a1 08 40 80 00       	mov    0x804008,%eax
  80129f:	8b 40 48             	mov    0x48(%eax),%eax
  8012a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012aa:	c7 04 24 e4 2c 80 00 	movl   $0x802ce4,(%esp)
  8012b1:	e8 f2 f0 ff ff       	call   8003a8 <cprintf>
	*dev = 0;
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	56                   	push   %esi
  8012ca:	53                   	push   %ebx
  8012cb:	83 ec 20             	sub    $0x20,%esp
  8012ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8012d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012e4:	89 04 24             	mov    %eax,(%esp)
  8012e7:	e8 2a ff ff ff       	call   801216 <fd_lookup>
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	78 05                	js     8012f5 <fd_close+0x2f>
	    || fd != fd2)
  8012f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8012f3:	74 0c                	je     801301 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8012f5:	84 db                	test   %bl,%bl
  8012f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012fc:	0f 44 c2             	cmove  %edx,%eax
  8012ff:	eb 3f                	jmp    801340 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801301:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801304:	89 44 24 04          	mov    %eax,0x4(%esp)
  801308:	8b 06                	mov    (%esi),%eax
  80130a:	89 04 24             	mov    %eax,(%esp)
  80130d:	e8 5a ff ff ff       	call   80126c <dev_lookup>
  801312:	89 c3                	mov    %eax,%ebx
  801314:	85 c0                	test   %eax,%eax
  801316:	78 16                	js     80132e <fd_close+0x68>
		if (dev->dev_close)
  801318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80131e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801323:	85 c0                	test   %eax,%eax
  801325:	74 07                	je     80132e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801327:	89 34 24             	mov    %esi,(%esp)
  80132a:	ff d0                	call   *%eax
  80132c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80132e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801332:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801339:	e8 fe fb ff ff       	call   800f3c <sys_page_unmap>
	return r;
  80133e:	89 d8                	mov    %ebx,%eax
}
  801340:	83 c4 20             	add    $0x20,%esp
  801343:	5b                   	pop    %ebx
  801344:	5e                   	pop    %esi
  801345:	5d                   	pop    %ebp
  801346:	c3                   	ret    

00801347 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80134d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801350:	89 44 24 04          	mov    %eax,0x4(%esp)
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	89 04 24             	mov    %eax,(%esp)
  80135a:	e8 b7 fe ff ff       	call   801216 <fd_lookup>
  80135f:	89 c2                	mov    %eax,%edx
  801361:	85 d2                	test   %edx,%edx
  801363:	78 13                	js     801378 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801365:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80136c:	00 
  80136d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801370:	89 04 24             	mov    %eax,(%esp)
  801373:	e8 4e ff ff ff       	call   8012c6 <fd_close>
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <close_all>:

void
close_all(void)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	53                   	push   %ebx
  80137e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801381:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801386:	89 1c 24             	mov    %ebx,(%esp)
  801389:	e8 b9 ff ff ff       	call   801347 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80138e:	83 c3 01             	add    $0x1,%ebx
  801391:	83 fb 20             	cmp    $0x20,%ebx
  801394:	75 f0                	jne    801386 <close_all+0xc>
		close(i);
}
  801396:	83 c4 14             	add    $0x14,%esp
  801399:	5b                   	pop    %ebx
  80139a:	5d                   	pop    %ebp
  80139b:	c3                   	ret    

0080139c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	57                   	push   %edi
  8013a0:	56                   	push   %esi
  8013a1:	53                   	push   %ebx
  8013a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	89 04 24             	mov    %eax,(%esp)
  8013b2:	e8 5f fe ff ff       	call   801216 <fd_lookup>
  8013b7:	89 c2                	mov    %eax,%edx
  8013b9:	85 d2                	test   %edx,%edx
  8013bb:	0f 88 e1 00 00 00    	js     8014a2 <dup+0x106>
		return r;
	close(newfdnum);
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	89 04 24             	mov    %eax,(%esp)
  8013c7:	e8 7b ff ff ff       	call   801347 <close>

	newfd = INDEX2FD(newfdnum);
  8013cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8013cf:	c1 e3 0c             	shl    $0xc,%ebx
  8013d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8013d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013db:	89 04 24             	mov    %eax,(%esp)
  8013de:	e8 cd fd ff ff       	call   8011b0 <fd2data>
  8013e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8013e5:	89 1c 24             	mov    %ebx,(%esp)
  8013e8:	e8 c3 fd ff ff       	call   8011b0 <fd2data>
  8013ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013ef:	89 f0                	mov    %esi,%eax
  8013f1:	c1 e8 16             	shr    $0x16,%eax
  8013f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013fb:	a8 01                	test   $0x1,%al
  8013fd:	74 43                	je     801442 <dup+0xa6>
  8013ff:	89 f0                	mov    %esi,%eax
  801401:	c1 e8 0c             	shr    $0xc,%eax
  801404:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80140b:	f6 c2 01             	test   $0x1,%dl
  80140e:	74 32                	je     801442 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801410:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801417:	25 07 0e 00 00       	and    $0xe07,%eax
  80141c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801420:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801424:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80142b:	00 
  80142c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801430:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801437:	e8 ad fa ff ff       	call   800ee9 <sys_page_map>
  80143c:	89 c6                	mov    %eax,%esi
  80143e:	85 c0                	test   %eax,%eax
  801440:	78 3e                	js     801480 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801445:	89 c2                	mov    %eax,%edx
  801447:	c1 ea 0c             	shr    $0xc,%edx
  80144a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801451:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801457:	89 54 24 10          	mov    %edx,0x10(%esp)
  80145b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80145f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801466:	00 
  801467:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801472:	e8 72 fa ff ff       	call   800ee9 <sys_page_map>
  801477:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80147c:	85 f6                	test   %esi,%esi
  80147e:	79 22                	jns    8014a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801480:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801484:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80148b:	e8 ac fa ff ff       	call   800f3c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801490:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801494:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80149b:	e8 9c fa ff ff       	call   800f3c <sys_page_unmap>
	return r;
  8014a0:	89 f0                	mov    %esi,%eax
}
  8014a2:	83 c4 3c             	add    $0x3c,%esp
  8014a5:	5b                   	pop    %ebx
  8014a6:	5e                   	pop    %esi
  8014a7:	5f                   	pop    %edi
  8014a8:	5d                   	pop    %ebp
  8014a9:	c3                   	ret    

008014aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	53                   	push   %ebx
  8014ae:	83 ec 24             	sub    $0x24,%esp
  8014b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014bb:	89 1c 24             	mov    %ebx,(%esp)
  8014be:	e8 53 fd ff ff       	call   801216 <fd_lookup>
  8014c3:	89 c2                	mov    %eax,%edx
  8014c5:	85 d2                	test   %edx,%edx
  8014c7:	78 6d                	js     801536 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d3:	8b 00                	mov    (%eax),%eax
  8014d5:	89 04 24             	mov    %eax,(%esp)
  8014d8:	e8 8f fd ff ff       	call   80126c <dev_lookup>
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	78 55                	js     801536 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e4:	8b 50 08             	mov    0x8(%eax),%edx
  8014e7:	83 e2 03             	and    $0x3,%edx
  8014ea:	83 fa 01             	cmp    $0x1,%edx
  8014ed:	75 23                	jne    801512 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8014f4:	8b 40 48             	mov    0x48(%eax),%eax
  8014f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ff:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  801506:	e8 9d ee ff ff       	call   8003a8 <cprintf>
		return -E_INVAL;
  80150b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801510:	eb 24                	jmp    801536 <read+0x8c>
	}
	if (!dev->dev_read)
  801512:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801515:	8b 52 08             	mov    0x8(%edx),%edx
  801518:	85 d2                	test   %edx,%edx
  80151a:	74 15                	je     801531 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80151c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80151f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801523:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801526:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80152a:	89 04 24             	mov    %eax,(%esp)
  80152d:	ff d2                	call   *%edx
  80152f:	eb 05                	jmp    801536 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801531:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801536:	83 c4 24             	add    $0x24,%esp
  801539:	5b                   	pop    %ebx
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    

0080153c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	57                   	push   %edi
  801540:	56                   	push   %esi
  801541:	53                   	push   %ebx
  801542:	83 ec 1c             	sub    $0x1c,%esp
  801545:	8b 7d 08             	mov    0x8(%ebp),%edi
  801548:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80154b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801550:	eb 23                	jmp    801575 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801552:	89 f0                	mov    %esi,%eax
  801554:	29 d8                	sub    %ebx,%eax
  801556:	89 44 24 08          	mov    %eax,0x8(%esp)
  80155a:	89 d8                	mov    %ebx,%eax
  80155c:	03 45 0c             	add    0xc(%ebp),%eax
  80155f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801563:	89 3c 24             	mov    %edi,(%esp)
  801566:	e8 3f ff ff ff       	call   8014aa <read>
		if (m < 0)
  80156b:	85 c0                	test   %eax,%eax
  80156d:	78 10                	js     80157f <readn+0x43>
			return m;
		if (m == 0)
  80156f:	85 c0                	test   %eax,%eax
  801571:	74 0a                	je     80157d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801573:	01 c3                	add    %eax,%ebx
  801575:	39 f3                	cmp    %esi,%ebx
  801577:	72 d9                	jb     801552 <readn+0x16>
  801579:	89 d8                	mov    %ebx,%eax
  80157b:	eb 02                	jmp    80157f <readn+0x43>
  80157d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80157f:	83 c4 1c             	add    $0x1c,%esp
  801582:	5b                   	pop    %ebx
  801583:	5e                   	pop    %esi
  801584:	5f                   	pop    %edi
  801585:	5d                   	pop    %ebp
  801586:	c3                   	ret    

00801587 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	53                   	push   %ebx
  80158b:	83 ec 24             	sub    $0x24,%esp
  80158e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801591:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801594:	89 44 24 04          	mov    %eax,0x4(%esp)
  801598:	89 1c 24             	mov    %ebx,(%esp)
  80159b:	e8 76 fc ff ff       	call   801216 <fd_lookup>
  8015a0:	89 c2                	mov    %eax,%edx
  8015a2:	85 d2                	test   %edx,%edx
  8015a4:	78 68                	js     80160e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b0:	8b 00                	mov    (%eax),%eax
  8015b2:	89 04 24             	mov    %eax,(%esp)
  8015b5:	e8 b2 fc ff ff       	call   80126c <dev_lookup>
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	78 50                	js     80160e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015c5:	75 23                	jne    8015ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015c7:	a1 08 40 80 00       	mov    0x804008,%eax
  8015cc:	8b 40 48             	mov    0x48(%eax),%eax
  8015cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d7:	c7 04 24 41 2d 80 00 	movl   $0x802d41,(%esp)
  8015de:	e8 c5 ed ff ff       	call   8003a8 <cprintf>
		return -E_INVAL;
  8015e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e8:	eb 24                	jmp    80160e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8015f0:	85 d2                	test   %edx,%edx
  8015f2:	74 15                	je     801609 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801602:	89 04 24             	mov    %eax,(%esp)
  801605:	ff d2                	call   *%edx
  801607:	eb 05                	jmp    80160e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801609:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80160e:	83 c4 24             	add    $0x24,%esp
  801611:	5b                   	pop    %ebx
  801612:	5d                   	pop    %ebp
  801613:	c3                   	ret    

00801614 <seek>:

int
seek(int fdnum, off_t offset)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80161a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80161d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	89 04 24             	mov    %eax,(%esp)
  801627:	e8 ea fb ff ff       	call   801216 <fd_lookup>
  80162c:	85 c0                	test   %eax,%eax
  80162e:	78 0e                	js     80163e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801630:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801633:	8b 55 0c             	mov    0xc(%ebp),%edx
  801636:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	53                   	push   %ebx
  801644:	83 ec 24             	sub    $0x24,%esp
  801647:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80164a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80164d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801651:	89 1c 24             	mov    %ebx,(%esp)
  801654:	e8 bd fb ff ff       	call   801216 <fd_lookup>
  801659:	89 c2                	mov    %eax,%edx
  80165b:	85 d2                	test   %edx,%edx
  80165d:	78 61                	js     8016c0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80165f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801662:	89 44 24 04          	mov    %eax,0x4(%esp)
  801666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801669:	8b 00                	mov    (%eax),%eax
  80166b:	89 04 24             	mov    %eax,(%esp)
  80166e:	e8 f9 fb ff ff       	call   80126c <dev_lookup>
  801673:	85 c0                	test   %eax,%eax
  801675:	78 49                	js     8016c0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80167e:	75 23                	jne    8016a3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801680:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801685:	8b 40 48             	mov    0x48(%eax),%eax
  801688:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80168c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801690:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  801697:	e8 0c ed ff ff       	call   8003a8 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80169c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a1:	eb 1d                	jmp    8016c0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8016a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a6:	8b 52 18             	mov    0x18(%edx),%edx
  8016a9:	85 d2                	test   %edx,%edx
  8016ab:	74 0e                	je     8016bb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016b4:	89 04 24             	mov    %eax,(%esp)
  8016b7:	ff d2                	call   *%edx
  8016b9:	eb 05                	jmp    8016c0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8016bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8016c0:	83 c4 24             	add    $0x24,%esp
  8016c3:	5b                   	pop    %ebx
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    

008016c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	53                   	push   %ebx
  8016ca:	83 ec 24             	sub    $0x24,%esp
  8016cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	89 04 24             	mov    %eax,(%esp)
  8016dd:	e8 34 fb ff ff       	call   801216 <fd_lookup>
  8016e2:	89 c2                	mov    %eax,%edx
  8016e4:	85 d2                	test   %edx,%edx
  8016e6:	78 52                	js     80173a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	89 04 24             	mov    %eax,(%esp)
  8016f7:	e8 70 fb ff ff       	call   80126c <dev_lookup>
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	78 3a                	js     80173a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801707:	74 2c                	je     801735 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801709:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80170c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801713:	00 00 00 
	stat->st_isdir = 0;
  801716:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80171d:	00 00 00 
	stat->st_dev = dev;
  801720:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801726:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80172a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80172d:	89 14 24             	mov    %edx,(%esp)
  801730:	ff 50 14             	call   *0x14(%eax)
  801733:	eb 05                	jmp    80173a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801735:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80173a:	83 c4 24             	add    $0x24,%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5d                   	pop    %ebp
  80173f:	c3                   	ret    

00801740 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
  801745:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801748:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80174f:	00 
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	89 04 24             	mov    %eax,(%esp)
  801756:	e8 99 02 00 00       	call   8019f4 <open>
  80175b:	89 c3                	mov    %eax,%ebx
  80175d:	85 db                	test   %ebx,%ebx
  80175f:	78 1b                	js     80177c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801761:	8b 45 0c             	mov    0xc(%ebp),%eax
  801764:	89 44 24 04          	mov    %eax,0x4(%esp)
  801768:	89 1c 24             	mov    %ebx,(%esp)
  80176b:	e8 56 ff ff ff       	call   8016c6 <fstat>
  801770:	89 c6                	mov    %eax,%esi
	close(fd);
  801772:	89 1c 24             	mov    %ebx,(%esp)
  801775:	e8 cd fb ff ff       	call   801347 <close>
	return r;
  80177a:	89 f0                	mov    %esi,%eax
}
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	5b                   	pop    %ebx
  801780:	5e                   	pop    %esi
  801781:	5d                   	pop    %ebp
  801782:	c3                   	ret    

00801783 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	56                   	push   %esi
  801787:	53                   	push   %ebx
  801788:	83 ec 10             	sub    $0x10,%esp
  80178b:	89 c6                	mov    %eax,%esi
  80178d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80178f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801796:	75 11                	jne    8017a9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801798:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80179f:	e8 2b 0e 00 00       	call   8025cf <ipc_find_env>
  8017a4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017a9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8017b0:	00 
  8017b1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8017b8:	00 
  8017b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017bd:	a1 00 40 80 00       	mov    0x804000,%eax
  8017c2:	89 04 24             	mov    %eax,(%esp)
  8017c5:	e8 9e 0d 00 00       	call   802568 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017d1:	00 
  8017d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017dd:	e8 1e 0d 00 00       	call   802500 <ipc_recv>
}
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	5b                   	pop    %ebx
  8017e6:	5e                   	pop    %esi
  8017e7:	5d                   	pop    %ebp
  8017e8:	c3                   	ret    

008017e9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801802:	ba 00 00 00 00       	mov    $0x0,%edx
  801807:	b8 02 00 00 00       	mov    $0x2,%eax
  80180c:	e8 72 ff ff ff       	call   801783 <fsipc>
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8b 40 0c             	mov    0xc(%eax),%eax
  80181f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801824:	ba 00 00 00 00       	mov    $0x0,%edx
  801829:	b8 06 00 00 00       	mov    $0x6,%eax
  80182e:	e8 50 ff ff ff       	call   801783 <fsipc>
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	53                   	push   %ebx
  801839:	83 ec 14             	sub    $0x14,%esp
  80183c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	8b 40 0c             	mov    0xc(%eax),%eax
  801845:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80184a:	ba 00 00 00 00       	mov    $0x0,%edx
  80184f:	b8 05 00 00 00       	mov    $0x5,%eax
  801854:	e8 2a ff ff ff       	call   801783 <fsipc>
  801859:	89 c2                	mov    %eax,%edx
  80185b:	85 d2                	test   %edx,%edx
  80185d:	78 2b                	js     80188a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80185f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801866:	00 
  801867:	89 1c 24             	mov    %ebx,(%esp)
  80186a:	e8 b8 f1 ff ff       	call   800a27 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80186f:	a1 80 50 80 00       	mov    0x805080,%eax
  801874:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80187a:	a1 84 50 80 00       	mov    0x805084,%eax
  80187f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801885:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188a:	83 c4 14             	add    $0x14,%esp
  80188d:	5b                   	pop    %ebx
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    

00801890 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	53                   	push   %ebx
  801894:	83 ec 14             	sub    $0x14,%esp
  801897:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80189a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  8018a0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8018a5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ab:	8b 52 0c             	mov    0xc(%edx),%edx
  8018ae:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  8018b4:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  8018b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c4:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8018cb:	e8 f4 f2 ff ff       	call   800bc4 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  8018d0:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  8018d7:	00 
  8018d8:	c7 04 24 74 2d 80 00 	movl   $0x802d74,(%esp)
  8018df:	e8 c4 ea ff ff       	call   8003a8 <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e9:	b8 04 00 00 00       	mov    $0x4,%eax
  8018ee:	e8 90 fe ff ff       	call   801783 <fsipc>
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 53                	js     80194a <devfile_write+0xba>
		return r;
	assert(r <= n);
  8018f7:	39 c3                	cmp    %eax,%ebx
  8018f9:	73 24                	jae    80191f <devfile_write+0x8f>
  8018fb:	c7 44 24 0c 79 2d 80 	movl   $0x802d79,0xc(%esp)
  801902:	00 
  801903:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  80190a:	00 
  80190b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801912:	00 
  801913:	c7 04 24 95 2d 80 00 	movl   $0x802d95,(%esp)
  80191a:	e8 90 e9 ff ff       	call   8002af <_panic>
	assert(r <= PGSIZE);
  80191f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801924:	7e 24                	jle    80194a <devfile_write+0xba>
  801926:	c7 44 24 0c a0 2d 80 	movl   $0x802da0,0xc(%esp)
  80192d:	00 
  80192e:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  801935:	00 
  801936:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  80193d:	00 
  80193e:	c7 04 24 95 2d 80 00 	movl   $0x802d95,(%esp)
  801945:	e8 65 e9 ff ff       	call   8002af <_panic>
	return r;
}
  80194a:	83 c4 14             	add    $0x14,%esp
  80194d:	5b                   	pop    %ebx
  80194e:	5d                   	pop    %ebp
  80194f:	c3                   	ret    

00801950 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	56                   	push   %esi
  801954:	53                   	push   %ebx
  801955:	83 ec 10             	sub    $0x10,%esp
  801958:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	8b 40 0c             	mov    0xc(%eax),%eax
  801961:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801966:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80196c:	ba 00 00 00 00       	mov    $0x0,%edx
  801971:	b8 03 00 00 00       	mov    $0x3,%eax
  801976:	e8 08 fe ff ff       	call   801783 <fsipc>
  80197b:	89 c3                	mov    %eax,%ebx
  80197d:	85 c0                	test   %eax,%eax
  80197f:	78 6a                	js     8019eb <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801981:	39 c6                	cmp    %eax,%esi
  801983:	73 24                	jae    8019a9 <devfile_read+0x59>
  801985:	c7 44 24 0c 79 2d 80 	movl   $0x802d79,0xc(%esp)
  80198c:	00 
  80198d:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  801994:	00 
  801995:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80199c:	00 
  80199d:	c7 04 24 95 2d 80 00 	movl   $0x802d95,(%esp)
  8019a4:	e8 06 e9 ff ff       	call   8002af <_panic>
	assert(r <= PGSIZE);
  8019a9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019ae:	7e 24                	jle    8019d4 <devfile_read+0x84>
  8019b0:	c7 44 24 0c a0 2d 80 	movl   $0x802da0,0xc(%esp)
  8019b7:	00 
  8019b8:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  8019bf:	00 
  8019c0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8019c7:	00 
  8019c8:	c7 04 24 95 2d 80 00 	movl   $0x802d95,(%esp)
  8019cf:	e8 db e8 ff ff       	call   8002af <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019d8:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8019df:	00 
  8019e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e3:	89 04 24             	mov    %eax,(%esp)
  8019e6:	e8 d9 f1 ff ff       	call   800bc4 <memmove>
	return r;
}
  8019eb:	89 d8                	mov    %ebx,%eax
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	5b                   	pop    %ebx
  8019f1:	5e                   	pop    %esi
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    

008019f4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	53                   	push   %ebx
  8019f8:	83 ec 24             	sub    $0x24,%esp
  8019fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8019fe:	89 1c 24             	mov    %ebx,(%esp)
  801a01:	e8 ea ef ff ff       	call   8009f0 <strlen>
  801a06:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a0b:	7f 60                	jg     801a6d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a10:	89 04 24             	mov    %eax,(%esp)
  801a13:	e8 af f7 ff ff       	call   8011c7 <fd_alloc>
  801a18:	89 c2                	mov    %eax,%edx
  801a1a:	85 d2                	test   %edx,%edx
  801a1c:	78 54                	js     801a72 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a22:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801a29:	e8 f9 ef ff ff       	call   800a27 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a31:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a39:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3e:	e8 40 fd ff ff       	call   801783 <fsipc>
  801a43:	89 c3                	mov    %eax,%ebx
  801a45:	85 c0                	test   %eax,%eax
  801a47:	79 17                	jns    801a60 <open+0x6c>
		fd_close(fd, 0);
  801a49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a50:	00 
  801a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a54:	89 04 24             	mov    %eax,(%esp)
  801a57:	e8 6a f8 ff ff       	call   8012c6 <fd_close>
		return r;
  801a5c:	89 d8                	mov    %ebx,%eax
  801a5e:	eb 12                	jmp    801a72 <open+0x7e>
	}

	return fd2num(fd);
  801a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a63:	89 04 24             	mov    %eax,(%esp)
  801a66:	e8 35 f7 ff ff       	call   8011a0 <fd2num>
  801a6b:	eb 05                	jmp    801a72 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801a6d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801a72:	83 c4 24             	add    $0x24,%esp
  801a75:	5b                   	pop    %ebx
  801a76:	5d                   	pop    %ebp
  801a77:	c3                   	ret    

00801a78 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a83:	b8 08 00 00 00       	mov    $0x8,%eax
  801a88:	e8 f6 fc ff ff       	call   801783 <fsipc>
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <evict>:

int evict(void)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801a95:	c7 04 24 ac 2d 80 00 	movl   $0x802dac,(%esp)
  801a9c:	e8 07 e9 ff ff       	call   8003a8 <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa6:	b8 09 00 00 00       	mov    $0x9,%eax
  801aab:	e8 d3 fc ff ff       	call   801783 <fsipc>
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    
  801ab2:	66 90                	xchg   %ax,%ax
  801ab4:	66 90                	xchg   %ax,%ax
  801ab6:	66 90                	xchg   %ax,%ax
  801ab8:	66 90                	xchg   %ax,%ax
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	66 90                	xchg   %ax,%ax
  801abe:	66 90                	xchg   %ax,%ax

00801ac0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ac6:	c7 44 24 04 c5 2d 80 	movl   $0x802dc5,0x4(%esp)
  801acd:	00 
  801ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad1:	89 04 24             	mov    %eax,(%esp)
  801ad4:	e8 4e ef ff ff       	call   800a27 <strcpy>
	return 0;
}
  801ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	53                   	push   %ebx
  801ae4:	83 ec 14             	sub    $0x14,%esp
  801ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801aea:	89 1c 24             	mov    %ebx,(%esp)
  801aed:	e8 15 0b 00 00       	call   802607 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801af2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801af7:	83 f8 01             	cmp    $0x1,%eax
  801afa:	75 0d                	jne    801b09 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801afc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801aff:	89 04 24             	mov    %eax,(%esp)
  801b02:	e8 29 03 00 00       	call   801e30 <nsipc_close>
  801b07:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801b09:	89 d0                	mov    %edx,%eax
  801b0b:	83 c4 14             	add    $0x14,%esp
  801b0e:	5b                   	pop    %ebx
  801b0f:	5d                   	pop    %ebp
  801b10:	c3                   	ret    

00801b11 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b17:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b1e:	00 
  801b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	8b 40 0c             	mov    0xc(%eax),%eax
  801b33:	89 04 24             	mov    %eax,(%esp)
  801b36:	e8 f0 03 00 00       	call   801f2b <nsipc_send>
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b43:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b4a:	00 
  801b4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b5f:	89 04 24             	mov    %eax,(%esp)
  801b62:	e8 44 03 00 00       	call   801eab <nsipc_recv>
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b6f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b72:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b76:	89 04 24             	mov    %eax,(%esp)
  801b79:	e8 98 f6 ff ff       	call   801216 <fd_lookup>
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	78 17                	js     801b99 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b85:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b8b:	39 08                	cmp    %ecx,(%eax)
  801b8d:	75 05                	jne    801b94 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801b8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b92:	eb 05                	jmp    801b99 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801b94:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	83 ec 20             	sub    $0x20,%esp
  801ba3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ba5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba8:	89 04 24             	mov    %eax,(%esp)
  801bab:	e8 17 f6 ff ff       	call   8011c7 <fd_alloc>
  801bb0:	89 c3                	mov    %eax,%ebx
  801bb2:	85 c0                	test   %eax,%eax
  801bb4:	78 21                	js     801bd7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bb6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bbd:	00 
  801bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bcc:	e8 c4 f2 ff ff       	call   800e95 <sys_page_alloc>
  801bd1:	89 c3                	mov    %eax,%ebx
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	79 0c                	jns    801be3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801bd7:	89 34 24             	mov    %esi,(%esp)
  801bda:	e8 51 02 00 00       	call   801e30 <nsipc_close>
		return r;
  801bdf:	89 d8                	mov    %ebx,%eax
  801be1:	eb 20                	jmp    801c03 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801be3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bec:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bf1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801bf8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801bfb:	89 14 24             	mov    %edx,(%esp)
  801bfe:	e8 9d f5 ff ff       	call   8011a0 <fd2num>
}
  801c03:	83 c4 20             	add    $0x20,%esp
  801c06:	5b                   	pop    %ebx
  801c07:	5e                   	pop    %esi
  801c08:	5d                   	pop    %ebp
  801c09:	c3                   	ret    

00801c0a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	e8 51 ff ff ff       	call   801b69 <fd2sockid>
		return r;
  801c18:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	78 23                	js     801c41 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c1e:	8b 55 10             	mov    0x10(%ebp),%edx
  801c21:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c28:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c2c:	89 04 24             	mov    %eax,(%esp)
  801c2f:	e8 45 01 00 00       	call   801d79 <nsipc_accept>
		return r;
  801c34:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c36:	85 c0                	test   %eax,%eax
  801c38:	78 07                	js     801c41 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801c3a:	e8 5c ff ff ff       	call   801b9b <alloc_sockfd>
  801c3f:	89 c1                	mov    %eax,%ecx
}
  801c41:	89 c8                	mov    %ecx,%eax
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	e8 16 ff ff ff       	call   801b69 <fd2sockid>
  801c53:	89 c2                	mov    %eax,%edx
  801c55:	85 d2                	test   %edx,%edx
  801c57:	78 16                	js     801c6f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801c59:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c67:	89 14 24             	mov    %edx,(%esp)
  801c6a:	e8 60 01 00 00       	call   801dcf <nsipc_bind>
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <shutdown>:

int
shutdown(int s, int how)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	e8 ea fe ff ff       	call   801b69 <fd2sockid>
  801c7f:	89 c2                	mov    %eax,%edx
  801c81:	85 d2                	test   %edx,%edx
  801c83:	78 0f                	js     801c94 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8c:	89 14 24             	mov    %edx,(%esp)
  801c8f:	e8 7a 01 00 00       	call   801e0e <nsipc_shutdown>
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	e8 c5 fe ff ff       	call   801b69 <fd2sockid>
  801ca4:	89 c2                	mov    %eax,%edx
  801ca6:	85 d2                	test   %edx,%edx
  801ca8:	78 16                	js     801cc0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801caa:	8b 45 10             	mov    0x10(%ebp),%eax
  801cad:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb8:	89 14 24             	mov    %edx,(%esp)
  801cbb:	e8 8a 01 00 00       	call   801e4a <nsipc_connect>
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <listen>:

int
listen(int s, int backlog)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	e8 99 fe ff ff       	call   801b69 <fd2sockid>
  801cd0:	89 c2                	mov    %eax,%edx
  801cd2:	85 d2                	test   %edx,%edx
  801cd4:	78 0f                	js     801ce5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdd:	89 14 24             	mov    %edx,(%esp)
  801ce0:	e8 a4 01 00 00       	call   801e89 <nsipc_listen>
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ced:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	89 04 24             	mov    %eax,(%esp)
  801d01:	e8 98 02 00 00       	call   801f9e <nsipc_socket>
  801d06:	89 c2                	mov    %eax,%edx
  801d08:	85 d2                	test   %edx,%edx
  801d0a:	78 05                	js     801d11 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801d0c:	e8 8a fe ff ff       	call   801b9b <alloc_sockfd>
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	53                   	push   %ebx
  801d17:	83 ec 14             	sub    $0x14,%esp
  801d1a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d1c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d23:	75 11                	jne    801d36 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d25:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801d2c:	e8 9e 08 00 00       	call   8025cf <ipc_find_env>
  801d31:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d36:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d3d:	00 
  801d3e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d45:	00 
  801d46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d4a:	a1 04 40 80 00       	mov    0x804004,%eax
  801d4f:	89 04 24             	mov    %eax,(%esp)
  801d52:	e8 11 08 00 00       	call   802568 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d5e:	00 
  801d5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d66:	00 
  801d67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d6e:	e8 8d 07 00 00       	call   802500 <ipc_recv>
}
  801d73:	83 c4 14             	add    $0x14,%esp
  801d76:	5b                   	pop    %ebx
  801d77:	5d                   	pop    %ebp
  801d78:	c3                   	ret    

00801d79 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	56                   	push   %esi
  801d7d:	53                   	push   %ebx
  801d7e:	83 ec 10             	sub    $0x10,%esp
  801d81:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d8c:	8b 06                	mov    (%esi),%eax
  801d8e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d93:	b8 01 00 00 00       	mov    $0x1,%eax
  801d98:	e8 76 ff ff ff       	call   801d13 <nsipc>
  801d9d:	89 c3                	mov    %eax,%ebx
  801d9f:	85 c0                	test   %eax,%eax
  801da1:	78 23                	js     801dc6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801da3:	a1 10 60 80 00       	mov    0x806010,%eax
  801da8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dac:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801db3:	00 
  801db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db7:	89 04 24             	mov    %eax,(%esp)
  801dba:	e8 05 ee ff ff       	call   800bc4 <memmove>
		*addrlen = ret->ret_addrlen;
  801dbf:	a1 10 60 80 00       	mov    0x806010,%eax
  801dc4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801dc6:	89 d8                	mov    %ebx,%eax
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5d                   	pop    %ebp
  801dce:	c3                   	ret    

00801dcf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	53                   	push   %ebx
  801dd3:	83 ec 14             	sub    $0x14,%esp
  801dd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801de1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dec:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801df3:	e8 cc ed ff ff       	call   800bc4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801df8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801dfe:	b8 02 00 00 00       	mov    $0x2,%eax
  801e03:	e8 0b ff ff ff       	call   801d13 <nsipc>
}
  801e08:	83 c4 14             	add    $0x14,%esp
  801e0b:	5b                   	pop    %ebx
  801e0c:	5d                   	pop    %ebp
  801e0d:	c3                   	ret    

00801e0e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e24:	b8 03 00 00 00       	mov    $0x3,%eax
  801e29:	e8 e5 fe ff ff       	call   801d13 <nsipc>
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <nsipc_close>:

int
nsipc_close(int s)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e3e:	b8 04 00 00 00       	mov    $0x4,%eax
  801e43:	e8 cb fe ff ff       	call   801d13 <nsipc>
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	53                   	push   %ebx
  801e4e:	83 ec 14             	sub    $0x14,%esp
  801e51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e5c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e67:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801e6e:	e8 51 ed ff ff       	call   800bc4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e73:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e79:	b8 05 00 00 00       	mov    $0x5,%eax
  801e7e:	e8 90 fe ff ff       	call   801d13 <nsipc>
}
  801e83:	83 c4 14             	add    $0x14,%esp
  801e86:	5b                   	pop    %ebx
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    

00801e89 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e9f:	b8 06 00 00 00       	mov    $0x6,%eax
  801ea4:	e8 6a fe ff ff       	call   801d13 <nsipc>
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	56                   	push   %esi
  801eaf:	53                   	push   %ebx
  801eb0:	83 ec 10             	sub    $0x10,%esp
  801eb3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ebe:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ec4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ecc:	b8 07 00 00 00       	mov    $0x7,%eax
  801ed1:	e8 3d fe ff ff       	call   801d13 <nsipc>
  801ed6:	89 c3                	mov    %eax,%ebx
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	78 46                	js     801f22 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801edc:	39 f0                	cmp    %esi,%eax
  801ede:	7f 07                	jg     801ee7 <nsipc_recv+0x3c>
  801ee0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ee5:	7e 24                	jle    801f0b <nsipc_recv+0x60>
  801ee7:	c7 44 24 0c d1 2d 80 	movl   $0x802dd1,0xc(%esp)
  801eee:	00 
  801eef:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  801ef6:	00 
  801ef7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801efe:	00 
  801eff:	c7 04 24 e6 2d 80 00 	movl   $0x802de6,(%esp)
  801f06:	e8 a4 e3 ff ff       	call   8002af <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f0f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f16:	00 
  801f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1a:	89 04 24             	mov    %eax,(%esp)
  801f1d:	e8 a2 ec ff ff       	call   800bc4 <memmove>
	}

	return r;
}
  801f22:	89 d8                	mov    %ebx,%eax
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	5b                   	pop    %ebx
  801f28:	5e                   	pop    %esi
  801f29:	5d                   	pop    %ebp
  801f2a:	c3                   	ret    

00801f2b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	53                   	push   %ebx
  801f2f:	83 ec 14             	sub    $0x14,%esp
  801f32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f3d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f43:	7e 24                	jle    801f69 <nsipc_send+0x3e>
  801f45:	c7 44 24 0c f2 2d 80 	movl   $0x802df2,0xc(%esp)
  801f4c:	00 
  801f4d:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  801f54:	00 
  801f55:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801f5c:	00 
  801f5d:	c7 04 24 e6 2d 80 00 	movl   $0x802de6,(%esp)
  801f64:	e8 46 e3 ff ff       	call   8002af <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f69:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f74:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801f7b:	e8 44 ec ff ff       	call   800bc4 <memmove>
	nsipcbuf.send.req_size = size;
  801f80:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f86:	8b 45 14             	mov    0x14(%ebp),%eax
  801f89:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f8e:	b8 08 00 00 00       	mov    $0x8,%eax
  801f93:	e8 7b fd ff ff       	call   801d13 <nsipc>
}
  801f98:	83 c4 14             	add    $0x14,%esp
  801f9b:	5b                   	pop    %ebx
  801f9c:	5d                   	pop    %ebp
  801f9d:	c3                   	ret    

00801f9e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801faf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801fbc:	b8 09 00 00 00       	mov    $0x9,%eax
  801fc1:	e8 4d fd ff ff       	call   801d13 <nsipc>
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	56                   	push   %esi
  801fcc:	53                   	push   %ebx
  801fcd:	83 ec 10             	sub    $0x10,%esp
  801fd0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	89 04 24             	mov    %eax,(%esp)
  801fd9:	e8 d2 f1 ff ff       	call   8011b0 <fd2data>
  801fde:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801fe0:	c7 44 24 04 fe 2d 80 	movl   $0x802dfe,0x4(%esp)
  801fe7:	00 
  801fe8:	89 1c 24             	mov    %ebx,(%esp)
  801feb:	e8 37 ea ff ff       	call   800a27 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ff0:	8b 46 04             	mov    0x4(%esi),%eax
  801ff3:	2b 06                	sub    (%esi),%eax
  801ff5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ffb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802002:	00 00 00 
	stat->st_dev = &devpipe;
  802005:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80200c:	30 80 00 
	return 0;
}
  80200f:	b8 00 00 00 00       	mov    $0x0,%eax
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	5b                   	pop    %ebx
  802018:	5e                   	pop    %esi
  802019:	5d                   	pop    %ebp
  80201a:	c3                   	ret    

0080201b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	53                   	push   %ebx
  80201f:	83 ec 14             	sub    $0x14,%esp
  802022:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802025:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802029:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802030:	e8 07 ef ff ff       	call   800f3c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802035:	89 1c 24             	mov    %ebx,(%esp)
  802038:	e8 73 f1 ff ff       	call   8011b0 <fd2data>
  80203d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802041:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802048:	e8 ef ee ff ff       	call   800f3c <sys_page_unmap>
}
  80204d:	83 c4 14             	add    $0x14,%esp
  802050:	5b                   	pop    %ebx
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    

00802053 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	57                   	push   %edi
  802057:	56                   	push   %esi
  802058:	53                   	push   %ebx
  802059:	83 ec 2c             	sub    $0x2c,%esp
  80205c:	89 c6                	mov    %eax,%esi
  80205e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802061:	a1 08 40 80 00       	mov    0x804008,%eax
  802066:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802069:	89 34 24             	mov    %esi,(%esp)
  80206c:	e8 96 05 00 00       	call   802607 <pageref>
  802071:	89 c7                	mov    %eax,%edi
  802073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802076:	89 04 24             	mov    %eax,(%esp)
  802079:	e8 89 05 00 00       	call   802607 <pageref>
  80207e:	39 c7                	cmp    %eax,%edi
  802080:	0f 94 c2             	sete   %dl
  802083:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802086:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80208c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80208f:	39 fb                	cmp    %edi,%ebx
  802091:	74 21                	je     8020b4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802093:	84 d2                	test   %dl,%dl
  802095:	74 ca                	je     802061 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802097:	8b 51 58             	mov    0x58(%ecx),%edx
  80209a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80209e:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020a6:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8020ad:	e8 f6 e2 ff ff       	call   8003a8 <cprintf>
  8020b2:	eb ad                	jmp    802061 <_pipeisclosed+0xe>
	}
}
  8020b4:	83 c4 2c             	add    $0x2c,%esp
  8020b7:	5b                   	pop    %ebx
  8020b8:	5e                   	pop    %esi
  8020b9:	5f                   	pop    %edi
  8020ba:	5d                   	pop    %ebp
  8020bb:	c3                   	ret    

008020bc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	57                   	push   %edi
  8020c0:	56                   	push   %esi
  8020c1:	53                   	push   %ebx
  8020c2:	83 ec 1c             	sub    $0x1c,%esp
  8020c5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8020c8:	89 34 24             	mov    %esi,(%esp)
  8020cb:	e8 e0 f0 ff ff       	call   8011b0 <fd2data>
  8020d0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d7:	eb 45                	jmp    80211e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8020d9:	89 da                	mov    %ebx,%edx
  8020db:	89 f0                	mov    %esi,%eax
  8020dd:	e8 71 ff ff ff       	call   802053 <_pipeisclosed>
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	75 41                	jne    802127 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8020e6:	e8 8b ed ff ff       	call   800e76 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020eb:	8b 43 04             	mov    0x4(%ebx),%eax
  8020ee:	8b 0b                	mov    (%ebx),%ecx
  8020f0:	8d 51 20             	lea    0x20(%ecx),%edx
  8020f3:	39 d0                	cmp    %edx,%eax
  8020f5:	73 e2                	jae    8020d9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020fa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020fe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802101:	99                   	cltd   
  802102:	c1 ea 1b             	shr    $0x1b,%edx
  802105:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802108:	83 e1 1f             	and    $0x1f,%ecx
  80210b:	29 d1                	sub    %edx,%ecx
  80210d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802111:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802115:	83 c0 01             	add    $0x1,%eax
  802118:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80211b:	83 c7 01             	add    $0x1,%edi
  80211e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802121:	75 c8                	jne    8020eb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802123:	89 f8                	mov    %edi,%eax
  802125:	eb 05                	jmp    80212c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80212c:	83 c4 1c             	add    $0x1c,%esp
  80212f:	5b                   	pop    %ebx
  802130:	5e                   	pop    %esi
  802131:	5f                   	pop    %edi
  802132:	5d                   	pop    %ebp
  802133:	c3                   	ret    

00802134 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	57                   	push   %edi
  802138:	56                   	push   %esi
  802139:	53                   	push   %ebx
  80213a:	83 ec 1c             	sub    $0x1c,%esp
  80213d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802140:	89 3c 24             	mov    %edi,(%esp)
  802143:	e8 68 f0 ff ff       	call   8011b0 <fd2data>
  802148:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80214a:	be 00 00 00 00       	mov    $0x0,%esi
  80214f:	eb 3d                	jmp    80218e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802151:	85 f6                	test   %esi,%esi
  802153:	74 04                	je     802159 <devpipe_read+0x25>
				return i;
  802155:	89 f0                	mov    %esi,%eax
  802157:	eb 43                	jmp    80219c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802159:	89 da                	mov    %ebx,%edx
  80215b:	89 f8                	mov    %edi,%eax
  80215d:	e8 f1 fe ff ff       	call   802053 <_pipeisclosed>
  802162:	85 c0                	test   %eax,%eax
  802164:	75 31                	jne    802197 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802166:	e8 0b ed ff ff       	call   800e76 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80216b:	8b 03                	mov    (%ebx),%eax
  80216d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802170:	74 df                	je     802151 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802172:	99                   	cltd   
  802173:	c1 ea 1b             	shr    $0x1b,%edx
  802176:	01 d0                	add    %edx,%eax
  802178:	83 e0 1f             	and    $0x1f,%eax
  80217b:	29 d0                	sub    %edx,%eax
  80217d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802182:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802185:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802188:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80218b:	83 c6 01             	add    $0x1,%esi
  80218e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802191:	75 d8                	jne    80216b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802193:	89 f0                	mov    %esi,%eax
  802195:	eb 05                	jmp    80219c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80219c:	83 c4 1c             	add    $0x1c,%esp
  80219f:	5b                   	pop    %ebx
  8021a0:	5e                   	pop    %esi
  8021a1:	5f                   	pop    %edi
  8021a2:	5d                   	pop    %ebp
  8021a3:	c3                   	ret    

008021a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	56                   	push   %esi
  8021a8:	53                   	push   %ebx
  8021a9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8021ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021af:	89 04 24             	mov    %eax,(%esp)
  8021b2:	e8 10 f0 ff ff       	call   8011c7 <fd_alloc>
  8021b7:	89 c2                	mov    %eax,%edx
  8021b9:	85 d2                	test   %edx,%edx
  8021bb:	0f 88 4d 01 00 00    	js     80230e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021c1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021c8:	00 
  8021c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d7:	e8 b9 ec ff ff       	call   800e95 <sys_page_alloc>
  8021dc:	89 c2                	mov    %eax,%edx
  8021de:	85 d2                	test   %edx,%edx
  8021e0:	0f 88 28 01 00 00    	js     80230e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8021e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021e9:	89 04 24             	mov    %eax,(%esp)
  8021ec:	e8 d6 ef ff ff       	call   8011c7 <fd_alloc>
  8021f1:	89 c3                	mov    %eax,%ebx
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	0f 88 fe 00 00 00    	js     8022f9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021fb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802202:	00 
  802203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802206:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802211:	e8 7f ec ff ff       	call   800e95 <sys_page_alloc>
  802216:	89 c3                	mov    %eax,%ebx
  802218:	85 c0                	test   %eax,%eax
  80221a:	0f 88 d9 00 00 00    	js     8022f9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802223:	89 04 24             	mov    %eax,(%esp)
  802226:	e8 85 ef ff ff       	call   8011b0 <fd2data>
  80222b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80222d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802234:	00 
  802235:	89 44 24 04          	mov    %eax,0x4(%esp)
  802239:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802240:	e8 50 ec ff ff       	call   800e95 <sys_page_alloc>
  802245:	89 c3                	mov    %eax,%ebx
  802247:	85 c0                	test   %eax,%eax
  802249:	0f 88 97 00 00 00    	js     8022e6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80224f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802252:	89 04 24             	mov    %eax,(%esp)
  802255:	e8 56 ef ff ff       	call   8011b0 <fd2data>
  80225a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802261:	00 
  802262:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802266:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80226d:	00 
  80226e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802272:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802279:	e8 6b ec ff ff       	call   800ee9 <sys_page_map>
  80227e:	89 c3                	mov    %eax,%ebx
  802280:	85 c0                	test   %eax,%eax
  802282:	78 52                	js     8022d6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802284:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802299:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80229f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	89 04 24             	mov    %eax,(%esp)
  8022b4:	e8 e7 ee ff ff       	call   8011a0 <fd2num>
  8022b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022bc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c1:	89 04 24             	mov    %eax,(%esp)
  8022c4:	e8 d7 ee ff ff       	call   8011a0 <fd2num>
  8022c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022cc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d4:	eb 38                	jmp    80230e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8022d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e1:	e8 56 ec ff ff       	call   800f3c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8022e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f4:	e8 43 ec ff ff       	call   800f3c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802300:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802307:	e8 30 ec ff ff       	call   800f3c <sys_page_unmap>
  80230c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80230e:	83 c4 30             	add    $0x30,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5d                   	pop    %ebp
  802314:	c3                   	ret    

00802315 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80231b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80231e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	89 04 24             	mov    %eax,(%esp)
  802328:	e8 e9 ee ff ff       	call   801216 <fd_lookup>
  80232d:	89 c2                	mov    %eax,%edx
  80232f:	85 d2                	test   %edx,%edx
  802331:	78 15                	js     802348 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	89 04 24             	mov    %eax,(%esp)
  802339:	e8 72 ee ff ff       	call   8011b0 <fd2data>
	return _pipeisclosed(fd, p);
  80233e:	89 c2                	mov    %eax,%edx
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	e8 0b fd ff ff       	call   802053 <_pipeisclosed>
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    
  80234a:	66 90                	xchg   %ax,%ax
  80234c:	66 90                	xchg   %ax,%ax
  80234e:	66 90                	xchg   %ax,%ax

00802350 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802353:	b8 00 00 00 00       	mov    $0x0,%eax
  802358:	5d                   	pop    %ebp
  802359:	c3                   	ret    

0080235a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802360:	c7 44 24 04 1d 2e 80 	movl   $0x802e1d,0x4(%esp)
  802367:	00 
  802368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236b:	89 04 24             	mov    %eax,(%esp)
  80236e:	e8 b4 e6 ff ff       	call   800a27 <strcpy>
	return 0;
}
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	57                   	push   %edi
  80237e:	56                   	push   %esi
  80237f:	53                   	push   %ebx
  802380:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802386:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80238b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802391:	eb 31                	jmp    8023c4 <devcons_write+0x4a>
		m = n - tot;
  802393:	8b 75 10             	mov    0x10(%ebp),%esi
  802396:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802398:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80239b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8023a0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023a3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8023a7:	03 45 0c             	add    0xc(%ebp),%eax
  8023aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ae:	89 3c 24             	mov    %edi,(%esp)
  8023b1:	e8 0e e8 ff ff       	call   800bc4 <memmove>
		sys_cputs(buf, m);
  8023b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023ba:	89 3c 24             	mov    %edi,(%esp)
  8023bd:	e8 b4 e9 ff ff       	call   800d76 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023c2:	01 f3                	add    %esi,%ebx
  8023c4:	89 d8                	mov    %ebx,%eax
  8023c6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8023c9:	72 c8                	jb     802393 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8023cb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    

008023d6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8023e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023e5:	75 07                	jne    8023ee <devcons_read+0x18>
  8023e7:	eb 2a                	jmp    802413 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8023e9:	e8 88 ea ff ff       	call   800e76 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8023ee:	66 90                	xchg   %ax,%ax
  8023f0:	e8 9f e9 ff ff       	call   800d94 <sys_cgetc>
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 f0                	je     8023e9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	78 16                	js     802413 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8023fd:	83 f8 04             	cmp    $0x4,%eax
  802400:	74 0c                	je     80240e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802402:	8b 55 0c             	mov    0xc(%ebp),%edx
  802405:	88 02                	mov    %al,(%edx)
	return 1;
  802407:	b8 01 00 00 00       	mov    $0x1,%eax
  80240c:	eb 05                	jmp    802413 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80240e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802421:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802428:	00 
  802429:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80242c:	89 04 24             	mov    %eax,(%esp)
  80242f:	e8 42 e9 ff ff       	call   800d76 <sys_cputs>
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <getchar>:

int
getchar(void)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80243c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802443:	00 
  802444:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802447:	89 44 24 04          	mov    %eax,0x4(%esp)
  80244b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802452:	e8 53 f0 ff ff       	call   8014aa <read>
	if (r < 0)
  802457:	85 c0                	test   %eax,%eax
  802459:	78 0f                	js     80246a <getchar+0x34>
		return r;
	if (r < 1)
  80245b:	85 c0                	test   %eax,%eax
  80245d:	7e 06                	jle    802465 <getchar+0x2f>
		return -E_EOF;
	return c;
  80245f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802463:	eb 05                	jmp    80246a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802465:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802472:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802475:	89 44 24 04          	mov    %eax,0x4(%esp)
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	89 04 24             	mov    %eax,(%esp)
  80247f:	e8 92 ed ff ff       	call   801216 <fd_lookup>
  802484:	85 c0                	test   %eax,%eax
  802486:	78 11                	js     802499 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802491:	39 10                	cmp    %edx,(%eax)
  802493:	0f 94 c0             	sete   %al
  802496:	0f b6 c0             	movzbl %al,%eax
}
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <opencons>:

int
opencons(void)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024a4:	89 04 24             	mov    %eax,(%esp)
  8024a7:	e8 1b ed ff ff       	call   8011c7 <fd_alloc>
		return r;
  8024ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	78 40                	js     8024f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024b9:	00 
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c8:	e8 c8 e9 ff ff       	call   800e95 <sys_page_alloc>
		return r;
  8024cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	78 1f                	js     8024f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8024d3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024e8:	89 04 24             	mov    %eax,(%esp)
  8024eb:	e8 b0 ec ff ff       	call   8011a0 <fd2num>
  8024f0:	89 c2                	mov    %eax,%edx
}
  8024f2:	89 d0                	mov    %edx,%eax
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	66 90                	xchg   %ax,%ax
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	56                   	push   %esi
  802504:	53                   	push   %ebx
  802505:	83 ec 10             	sub    $0x10,%esp
  802508:	8b 75 08             	mov    0x8(%ebp),%esi
  80250b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802511:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802513:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802518:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80251b:	89 04 24             	mov    %eax,(%esp)
  80251e:	e8 a8 eb ff ff       	call   8010cb <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802523:	85 c0                	test   %eax,%eax
  802525:	75 26                	jne    80254d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802527:	85 f6                	test   %esi,%esi
  802529:	74 0a                	je     802535 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80252b:	a1 08 40 80 00       	mov    0x804008,%eax
  802530:	8b 40 74             	mov    0x74(%eax),%eax
  802533:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802535:	85 db                	test   %ebx,%ebx
  802537:	74 0a                	je     802543 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802539:	a1 08 40 80 00       	mov    0x804008,%eax
  80253e:	8b 40 78             	mov    0x78(%eax),%eax
  802541:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802543:	a1 08 40 80 00       	mov    0x804008,%eax
  802548:	8b 40 70             	mov    0x70(%eax),%eax
  80254b:	eb 14                	jmp    802561 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80254d:	85 f6                	test   %esi,%esi
  80254f:	74 06                	je     802557 <ipc_recv+0x57>
			*from_env_store = 0;
  802551:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802557:	85 db                	test   %ebx,%ebx
  802559:	74 06                	je     802561 <ipc_recv+0x61>
			*perm_store = 0;
  80255b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802561:	83 c4 10             	add    $0x10,%esp
  802564:	5b                   	pop    %ebx
  802565:	5e                   	pop    %esi
  802566:	5d                   	pop    %ebp
  802567:	c3                   	ret    

00802568 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	57                   	push   %edi
  80256c:	56                   	push   %esi
  80256d:	53                   	push   %ebx
  80256e:	83 ec 1c             	sub    $0x1c,%esp
  802571:	8b 7d 08             	mov    0x8(%ebp),%edi
  802574:	8b 75 0c             	mov    0xc(%ebp),%esi
  802577:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80257a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80257c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802581:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802584:	8b 45 14             	mov    0x14(%ebp),%eax
  802587:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80258b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80258f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802593:	89 3c 24             	mov    %edi,(%esp)
  802596:	e8 0d eb ff ff       	call   8010a8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80259b:	85 c0                	test   %eax,%eax
  80259d:	74 28                	je     8025c7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80259f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025a2:	74 1c                	je     8025c0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  8025a4:	c7 44 24 08 2c 2e 80 	movl   $0x802e2c,0x8(%esp)
  8025ab:	00 
  8025ac:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8025b3:	00 
  8025b4:	c7 04 24 50 2e 80 00 	movl   $0x802e50,(%esp)
  8025bb:	e8 ef dc ff ff       	call   8002af <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8025c0:	e8 b1 e8 ff ff       	call   800e76 <sys_yield>
	}
  8025c5:	eb bd                	jmp    802584 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8025c7:	83 c4 1c             	add    $0x1c,%esp
  8025ca:	5b                   	pop    %ebx
  8025cb:	5e                   	pop    %esi
  8025cc:	5f                   	pop    %edi
  8025cd:	5d                   	pop    %ebp
  8025ce:	c3                   	ret    

008025cf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025da:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025dd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025e3:	8b 52 50             	mov    0x50(%edx),%edx
  8025e6:	39 ca                	cmp    %ecx,%edx
  8025e8:	75 0d                	jne    8025f7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8025ea:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025ed:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8025f2:	8b 40 40             	mov    0x40(%eax),%eax
  8025f5:	eb 0e                	jmp    802605 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8025f7:	83 c0 01             	add    $0x1,%eax
  8025fa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025ff:	75 d9                	jne    8025da <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802601:	66 b8 00 00          	mov    $0x0,%ax
}
  802605:	5d                   	pop    %ebp
  802606:	c3                   	ret    

00802607 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802607:	55                   	push   %ebp
  802608:	89 e5                	mov    %esp,%ebp
  80260a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80260d:	89 d0                	mov    %edx,%eax
  80260f:	c1 e8 16             	shr    $0x16,%eax
  802612:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80261e:	f6 c1 01             	test   $0x1,%cl
  802621:	74 1d                	je     802640 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802623:	c1 ea 0c             	shr    $0xc,%edx
  802626:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80262d:	f6 c2 01             	test   $0x1,%dl
  802630:	74 0e                	je     802640 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802632:	c1 ea 0c             	shr    $0xc,%edx
  802635:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80263c:	ef 
  80263d:	0f b7 c0             	movzwl %ax,%eax
}
  802640:	5d                   	pop    %ebp
  802641:	c3                   	ret    
  802642:	66 90                	xchg   %ax,%ax
  802644:	66 90                	xchg   %ax,%ax
  802646:	66 90                	xchg   %ax,%ax
  802648:	66 90                	xchg   %ax,%ax
  80264a:	66 90                	xchg   %ax,%ax
  80264c:	66 90                	xchg   %ax,%ax
  80264e:	66 90                	xchg   %ax,%ax

00802650 <__udivdi3>:
  802650:	55                   	push   %ebp
  802651:	57                   	push   %edi
  802652:	56                   	push   %esi
  802653:	83 ec 0c             	sub    $0xc,%esp
  802656:	8b 44 24 28          	mov    0x28(%esp),%eax
  80265a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80265e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802662:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802666:	85 c0                	test   %eax,%eax
  802668:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80266c:	89 ea                	mov    %ebp,%edx
  80266e:	89 0c 24             	mov    %ecx,(%esp)
  802671:	75 2d                	jne    8026a0 <__udivdi3+0x50>
  802673:	39 e9                	cmp    %ebp,%ecx
  802675:	77 61                	ja     8026d8 <__udivdi3+0x88>
  802677:	85 c9                	test   %ecx,%ecx
  802679:	89 ce                	mov    %ecx,%esi
  80267b:	75 0b                	jne    802688 <__udivdi3+0x38>
  80267d:	b8 01 00 00 00       	mov    $0x1,%eax
  802682:	31 d2                	xor    %edx,%edx
  802684:	f7 f1                	div    %ecx
  802686:	89 c6                	mov    %eax,%esi
  802688:	31 d2                	xor    %edx,%edx
  80268a:	89 e8                	mov    %ebp,%eax
  80268c:	f7 f6                	div    %esi
  80268e:	89 c5                	mov    %eax,%ebp
  802690:	89 f8                	mov    %edi,%eax
  802692:	f7 f6                	div    %esi
  802694:	89 ea                	mov    %ebp,%edx
  802696:	83 c4 0c             	add    $0xc,%esp
  802699:	5e                   	pop    %esi
  80269a:	5f                   	pop    %edi
  80269b:	5d                   	pop    %ebp
  80269c:	c3                   	ret    
  80269d:	8d 76 00             	lea    0x0(%esi),%esi
  8026a0:	39 e8                	cmp    %ebp,%eax
  8026a2:	77 24                	ja     8026c8 <__udivdi3+0x78>
  8026a4:	0f bd e8             	bsr    %eax,%ebp
  8026a7:	83 f5 1f             	xor    $0x1f,%ebp
  8026aa:	75 3c                	jne    8026e8 <__udivdi3+0x98>
  8026ac:	8b 74 24 04          	mov    0x4(%esp),%esi
  8026b0:	39 34 24             	cmp    %esi,(%esp)
  8026b3:	0f 86 9f 00 00 00    	jbe    802758 <__udivdi3+0x108>
  8026b9:	39 d0                	cmp    %edx,%eax
  8026bb:	0f 82 97 00 00 00    	jb     802758 <__udivdi3+0x108>
  8026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	31 d2                	xor    %edx,%edx
  8026ca:	31 c0                	xor    %eax,%eax
  8026cc:	83 c4 0c             	add    $0xc,%esp
  8026cf:	5e                   	pop    %esi
  8026d0:	5f                   	pop    %edi
  8026d1:	5d                   	pop    %ebp
  8026d2:	c3                   	ret    
  8026d3:	90                   	nop
  8026d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026d8:	89 f8                	mov    %edi,%eax
  8026da:	f7 f1                	div    %ecx
  8026dc:	31 d2                	xor    %edx,%edx
  8026de:	83 c4 0c             	add    $0xc,%esp
  8026e1:	5e                   	pop    %esi
  8026e2:	5f                   	pop    %edi
  8026e3:	5d                   	pop    %ebp
  8026e4:	c3                   	ret    
  8026e5:	8d 76 00             	lea    0x0(%esi),%esi
  8026e8:	89 e9                	mov    %ebp,%ecx
  8026ea:	8b 3c 24             	mov    (%esp),%edi
  8026ed:	d3 e0                	shl    %cl,%eax
  8026ef:	89 c6                	mov    %eax,%esi
  8026f1:	b8 20 00 00 00       	mov    $0x20,%eax
  8026f6:	29 e8                	sub    %ebp,%eax
  8026f8:	89 c1                	mov    %eax,%ecx
  8026fa:	d3 ef                	shr    %cl,%edi
  8026fc:	89 e9                	mov    %ebp,%ecx
  8026fe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802702:	8b 3c 24             	mov    (%esp),%edi
  802705:	09 74 24 08          	or     %esi,0x8(%esp)
  802709:	89 d6                	mov    %edx,%esi
  80270b:	d3 e7                	shl    %cl,%edi
  80270d:	89 c1                	mov    %eax,%ecx
  80270f:	89 3c 24             	mov    %edi,(%esp)
  802712:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802716:	d3 ee                	shr    %cl,%esi
  802718:	89 e9                	mov    %ebp,%ecx
  80271a:	d3 e2                	shl    %cl,%edx
  80271c:	89 c1                	mov    %eax,%ecx
  80271e:	d3 ef                	shr    %cl,%edi
  802720:	09 d7                	or     %edx,%edi
  802722:	89 f2                	mov    %esi,%edx
  802724:	89 f8                	mov    %edi,%eax
  802726:	f7 74 24 08          	divl   0x8(%esp)
  80272a:	89 d6                	mov    %edx,%esi
  80272c:	89 c7                	mov    %eax,%edi
  80272e:	f7 24 24             	mull   (%esp)
  802731:	39 d6                	cmp    %edx,%esi
  802733:	89 14 24             	mov    %edx,(%esp)
  802736:	72 30                	jb     802768 <__udivdi3+0x118>
  802738:	8b 54 24 04          	mov    0x4(%esp),%edx
  80273c:	89 e9                	mov    %ebp,%ecx
  80273e:	d3 e2                	shl    %cl,%edx
  802740:	39 c2                	cmp    %eax,%edx
  802742:	73 05                	jae    802749 <__udivdi3+0xf9>
  802744:	3b 34 24             	cmp    (%esp),%esi
  802747:	74 1f                	je     802768 <__udivdi3+0x118>
  802749:	89 f8                	mov    %edi,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	e9 7a ff ff ff       	jmp    8026cc <__udivdi3+0x7c>
  802752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802758:	31 d2                	xor    %edx,%edx
  80275a:	b8 01 00 00 00       	mov    $0x1,%eax
  80275f:	e9 68 ff ff ff       	jmp    8026cc <__udivdi3+0x7c>
  802764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802768:	8d 47 ff             	lea    -0x1(%edi),%eax
  80276b:	31 d2                	xor    %edx,%edx
  80276d:	83 c4 0c             	add    $0xc,%esp
  802770:	5e                   	pop    %esi
  802771:	5f                   	pop    %edi
  802772:	5d                   	pop    %ebp
  802773:	c3                   	ret    
  802774:	66 90                	xchg   %ax,%ax
  802776:	66 90                	xchg   %ax,%ax
  802778:	66 90                	xchg   %ax,%ax
  80277a:	66 90                	xchg   %ax,%ax
  80277c:	66 90                	xchg   %ax,%ax
  80277e:	66 90                	xchg   %ax,%ax

00802780 <__umoddi3>:
  802780:	55                   	push   %ebp
  802781:	57                   	push   %edi
  802782:	56                   	push   %esi
  802783:	83 ec 14             	sub    $0x14,%esp
  802786:	8b 44 24 28          	mov    0x28(%esp),%eax
  80278a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80278e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802792:	89 c7                	mov    %eax,%edi
  802794:	89 44 24 04          	mov    %eax,0x4(%esp)
  802798:	8b 44 24 30          	mov    0x30(%esp),%eax
  80279c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8027a0:	89 34 24             	mov    %esi,(%esp)
  8027a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	89 c2                	mov    %eax,%edx
  8027ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027af:	75 17                	jne    8027c8 <__umoddi3+0x48>
  8027b1:	39 fe                	cmp    %edi,%esi
  8027b3:	76 4b                	jbe    802800 <__umoddi3+0x80>
  8027b5:	89 c8                	mov    %ecx,%eax
  8027b7:	89 fa                	mov    %edi,%edx
  8027b9:	f7 f6                	div    %esi
  8027bb:	89 d0                	mov    %edx,%eax
  8027bd:	31 d2                	xor    %edx,%edx
  8027bf:	83 c4 14             	add    $0x14,%esp
  8027c2:	5e                   	pop    %esi
  8027c3:	5f                   	pop    %edi
  8027c4:	5d                   	pop    %ebp
  8027c5:	c3                   	ret    
  8027c6:	66 90                	xchg   %ax,%ax
  8027c8:	39 f8                	cmp    %edi,%eax
  8027ca:	77 54                	ja     802820 <__umoddi3+0xa0>
  8027cc:	0f bd e8             	bsr    %eax,%ebp
  8027cf:	83 f5 1f             	xor    $0x1f,%ebp
  8027d2:	75 5c                	jne    802830 <__umoddi3+0xb0>
  8027d4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8027d8:	39 3c 24             	cmp    %edi,(%esp)
  8027db:	0f 87 e7 00 00 00    	ja     8028c8 <__umoddi3+0x148>
  8027e1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8027e5:	29 f1                	sub    %esi,%ecx
  8027e7:	19 c7                	sbb    %eax,%edi
  8027e9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027f1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027f5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8027f9:	83 c4 14             	add    $0x14,%esp
  8027fc:	5e                   	pop    %esi
  8027fd:	5f                   	pop    %edi
  8027fe:	5d                   	pop    %ebp
  8027ff:	c3                   	ret    
  802800:	85 f6                	test   %esi,%esi
  802802:	89 f5                	mov    %esi,%ebp
  802804:	75 0b                	jne    802811 <__umoddi3+0x91>
  802806:	b8 01 00 00 00       	mov    $0x1,%eax
  80280b:	31 d2                	xor    %edx,%edx
  80280d:	f7 f6                	div    %esi
  80280f:	89 c5                	mov    %eax,%ebp
  802811:	8b 44 24 04          	mov    0x4(%esp),%eax
  802815:	31 d2                	xor    %edx,%edx
  802817:	f7 f5                	div    %ebp
  802819:	89 c8                	mov    %ecx,%eax
  80281b:	f7 f5                	div    %ebp
  80281d:	eb 9c                	jmp    8027bb <__umoddi3+0x3b>
  80281f:	90                   	nop
  802820:	89 c8                	mov    %ecx,%eax
  802822:	89 fa                	mov    %edi,%edx
  802824:	83 c4 14             	add    $0x14,%esp
  802827:	5e                   	pop    %esi
  802828:	5f                   	pop    %edi
  802829:	5d                   	pop    %ebp
  80282a:	c3                   	ret    
  80282b:	90                   	nop
  80282c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802830:	8b 04 24             	mov    (%esp),%eax
  802833:	be 20 00 00 00       	mov    $0x20,%esi
  802838:	89 e9                	mov    %ebp,%ecx
  80283a:	29 ee                	sub    %ebp,%esi
  80283c:	d3 e2                	shl    %cl,%edx
  80283e:	89 f1                	mov    %esi,%ecx
  802840:	d3 e8                	shr    %cl,%eax
  802842:	89 e9                	mov    %ebp,%ecx
  802844:	89 44 24 04          	mov    %eax,0x4(%esp)
  802848:	8b 04 24             	mov    (%esp),%eax
  80284b:	09 54 24 04          	or     %edx,0x4(%esp)
  80284f:	89 fa                	mov    %edi,%edx
  802851:	d3 e0                	shl    %cl,%eax
  802853:	89 f1                	mov    %esi,%ecx
  802855:	89 44 24 08          	mov    %eax,0x8(%esp)
  802859:	8b 44 24 10          	mov    0x10(%esp),%eax
  80285d:	d3 ea                	shr    %cl,%edx
  80285f:	89 e9                	mov    %ebp,%ecx
  802861:	d3 e7                	shl    %cl,%edi
  802863:	89 f1                	mov    %esi,%ecx
  802865:	d3 e8                	shr    %cl,%eax
  802867:	89 e9                	mov    %ebp,%ecx
  802869:	09 f8                	or     %edi,%eax
  80286b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80286f:	f7 74 24 04          	divl   0x4(%esp)
  802873:	d3 e7                	shl    %cl,%edi
  802875:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802879:	89 d7                	mov    %edx,%edi
  80287b:	f7 64 24 08          	mull   0x8(%esp)
  80287f:	39 d7                	cmp    %edx,%edi
  802881:	89 c1                	mov    %eax,%ecx
  802883:	89 14 24             	mov    %edx,(%esp)
  802886:	72 2c                	jb     8028b4 <__umoddi3+0x134>
  802888:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80288c:	72 22                	jb     8028b0 <__umoddi3+0x130>
  80288e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802892:	29 c8                	sub    %ecx,%eax
  802894:	19 d7                	sbb    %edx,%edi
  802896:	89 e9                	mov    %ebp,%ecx
  802898:	89 fa                	mov    %edi,%edx
  80289a:	d3 e8                	shr    %cl,%eax
  80289c:	89 f1                	mov    %esi,%ecx
  80289e:	d3 e2                	shl    %cl,%edx
  8028a0:	89 e9                	mov    %ebp,%ecx
  8028a2:	d3 ef                	shr    %cl,%edi
  8028a4:	09 d0                	or     %edx,%eax
  8028a6:	89 fa                	mov    %edi,%edx
  8028a8:	83 c4 14             	add    $0x14,%esp
  8028ab:	5e                   	pop    %esi
  8028ac:	5f                   	pop    %edi
  8028ad:	5d                   	pop    %ebp
  8028ae:	c3                   	ret    
  8028af:	90                   	nop
  8028b0:	39 d7                	cmp    %edx,%edi
  8028b2:	75 da                	jne    80288e <__umoddi3+0x10e>
  8028b4:	8b 14 24             	mov    (%esp),%edx
  8028b7:	89 c1                	mov    %eax,%ecx
  8028b9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8028bd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8028c1:	eb cb                	jmp    80288e <__umoddi3+0x10e>
  8028c3:	90                   	nop
  8028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028c8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8028cc:	0f 82 0f ff ff ff    	jb     8027e1 <__umoddi3+0x61>
  8028d2:	e9 1a ff ff ff       	jmp    8027f1 <__umoddi3+0x71>
