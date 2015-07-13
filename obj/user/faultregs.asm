
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 64 05 00 00       	call   800595 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	8b 45 08             	mov    0x8(%ebp),%eax
  800043:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800047:	89 54 24 08          	mov    %edx,0x8(%esp)
  80004b:	c7 44 24 04 11 2d 80 	movl   $0x802d11,0x4(%esp)
  800052:	00 
  800053:	c7 04 24 e0 2c 80 00 	movl   $0x802ce0,(%esp)
  80005a:	e8 90 06 00 00       	call   8006ef <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  80005f:	8b 03                	mov    (%ebx),%eax
  800061:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800065:	8b 06                	mov    (%esi),%eax
  800067:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006b:	c7 44 24 04 f0 2c 80 	movl   $0x802cf0,0x4(%esp)
  800072:	00 
  800073:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  80007a:	e8 70 06 00 00       	call   8006ef <cprintf>
  80007f:	8b 03                	mov    (%ebx),%eax
  800081:	39 06                	cmp    %eax,(%esi)
  800083:	75 13                	jne    800098 <check_regs+0x65>
  800085:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  80008c:	e8 5e 06 00 00       	call   8006ef <cprintf>

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
	int mismatch = 0;
  800091:	bf 00 00 00 00       	mov    $0x0,%edi
  800096:	eb 11                	jmp    8000a9 <check_regs+0x76>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800098:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  80009f:	e8 4b 06 00 00       	call   8006ef <cprintf>
  8000a4:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  8000a9:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	8b 46 04             	mov    0x4(%esi),%eax
  8000b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b7:	c7 44 24 04 12 2d 80 	movl   $0x802d12,0x4(%esp)
  8000be:	00 
  8000bf:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  8000c6:	e8 24 06 00 00       	call   8006ef <cprintf>
  8000cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ce:	39 46 04             	cmp    %eax,0x4(%esi)
  8000d1:	75 0e                	jne    8000e1 <check_regs+0xae>
  8000d3:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  8000da:	e8 10 06 00 00       	call   8006ef <cprintf>
  8000df:	eb 11                	jmp    8000f2 <check_regs+0xbf>
  8000e1:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  8000e8:	e8 02 06 00 00       	call   8006ef <cprintf>
  8000ed:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000f2:	8b 43 08             	mov    0x8(%ebx),%eax
  8000f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f9:	8b 46 08             	mov    0x8(%esi),%eax
  8000fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800100:	c7 44 24 04 16 2d 80 	movl   $0x802d16,0x4(%esp)
  800107:	00 
  800108:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  80010f:	e8 db 05 00 00       	call   8006ef <cprintf>
  800114:	8b 43 08             	mov    0x8(%ebx),%eax
  800117:	39 46 08             	cmp    %eax,0x8(%esi)
  80011a:	75 0e                	jne    80012a <check_regs+0xf7>
  80011c:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  800123:	e8 c7 05 00 00       	call   8006ef <cprintf>
  800128:	eb 11                	jmp    80013b <check_regs+0x108>
  80012a:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  800131:	e8 b9 05 00 00       	call   8006ef <cprintf>
  800136:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  80013b:	8b 43 10             	mov    0x10(%ebx),%eax
  80013e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800142:	8b 46 10             	mov    0x10(%esi),%eax
  800145:	89 44 24 08          	mov    %eax,0x8(%esp)
  800149:	c7 44 24 04 1a 2d 80 	movl   $0x802d1a,0x4(%esp)
  800150:	00 
  800151:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  800158:	e8 92 05 00 00       	call   8006ef <cprintf>
  80015d:	8b 43 10             	mov    0x10(%ebx),%eax
  800160:	39 46 10             	cmp    %eax,0x10(%esi)
  800163:	75 0e                	jne    800173 <check_regs+0x140>
  800165:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  80016c:	e8 7e 05 00 00       	call   8006ef <cprintf>
  800171:	eb 11                	jmp    800184 <check_regs+0x151>
  800173:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  80017a:	e8 70 05 00 00       	call   8006ef <cprintf>
  80017f:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800184:	8b 43 14             	mov    0x14(%ebx),%eax
  800187:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018b:	8b 46 14             	mov    0x14(%esi),%eax
  80018e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800192:	c7 44 24 04 1e 2d 80 	movl   $0x802d1e,0x4(%esp)
  800199:	00 
  80019a:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  8001a1:	e8 49 05 00 00       	call   8006ef <cprintf>
  8001a6:	8b 43 14             	mov    0x14(%ebx),%eax
  8001a9:	39 46 14             	cmp    %eax,0x14(%esi)
  8001ac:	75 0e                	jne    8001bc <check_regs+0x189>
  8001ae:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  8001b5:	e8 35 05 00 00       	call   8006ef <cprintf>
  8001ba:	eb 11                	jmp    8001cd <check_regs+0x19a>
  8001bc:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  8001c3:	e8 27 05 00 00       	call   8006ef <cprintf>
  8001c8:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  8001cd:	8b 43 18             	mov    0x18(%ebx),%eax
  8001d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d4:	8b 46 18             	mov    0x18(%esi),%eax
  8001d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001db:	c7 44 24 04 22 2d 80 	movl   $0x802d22,0x4(%esp)
  8001e2:	00 
  8001e3:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  8001ea:	e8 00 05 00 00       	call   8006ef <cprintf>
  8001ef:	8b 43 18             	mov    0x18(%ebx),%eax
  8001f2:	39 46 18             	cmp    %eax,0x18(%esi)
  8001f5:	75 0e                	jne    800205 <check_regs+0x1d2>
  8001f7:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  8001fe:	e8 ec 04 00 00       	call   8006ef <cprintf>
  800203:	eb 11                	jmp    800216 <check_regs+0x1e3>
  800205:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  80020c:	e8 de 04 00 00       	call   8006ef <cprintf>
  800211:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  800216:	8b 43 1c             	mov    0x1c(%ebx),%eax
  800219:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021d:	8b 46 1c             	mov    0x1c(%esi),%eax
  800220:	89 44 24 08          	mov    %eax,0x8(%esp)
  800224:	c7 44 24 04 26 2d 80 	movl   $0x802d26,0x4(%esp)
  80022b:	00 
  80022c:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  800233:	e8 b7 04 00 00       	call   8006ef <cprintf>
  800238:	8b 43 1c             	mov    0x1c(%ebx),%eax
  80023b:	39 46 1c             	cmp    %eax,0x1c(%esi)
  80023e:	75 0e                	jne    80024e <check_regs+0x21b>
  800240:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  800247:	e8 a3 04 00 00       	call   8006ef <cprintf>
  80024c:	eb 11                	jmp    80025f <check_regs+0x22c>
  80024e:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  800255:	e8 95 04 00 00       	call   8006ef <cprintf>
  80025a:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  80025f:	8b 43 20             	mov    0x20(%ebx),%eax
  800262:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800266:	8b 46 20             	mov    0x20(%esi),%eax
  800269:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026d:	c7 44 24 04 2a 2d 80 	movl   $0x802d2a,0x4(%esp)
  800274:	00 
  800275:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  80027c:	e8 6e 04 00 00       	call   8006ef <cprintf>
  800281:	8b 43 20             	mov    0x20(%ebx),%eax
  800284:	39 46 20             	cmp    %eax,0x20(%esi)
  800287:	75 0e                	jne    800297 <check_regs+0x264>
  800289:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  800290:	e8 5a 04 00 00       	call   8006ef <cprintf>
  800295:	eb 11                	jmp    8002a8 <check_regs+0x275>
  800297:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  80029e:	e8 4c 04 00 00       	call   8006ef <cprintf>
  8002a3:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  8002a8:	8b 43 24             	mov    0x24(%ebx),%eax
  8002ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002af:	8b 46 24             	mov    0x24(%esi),%eax
  8002b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b6:	c7 44 24 04 2e 2d 80 	movl   $0x802d2e,0x4(%esp)
  8002bd:	00 
  8002be:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  8002c5:	e8 25 04 00 00       	call   8006ef <cprintf>
  8002ca:	8b 43 24             	mov    0x24(%ebx),%eax
  8002cd:	39 46 24             	cmp    %eax,0x24(%esi)
  8002d0:	75 0e                	jne    8002e0 <check_regs+0x2ad>
  8002d2:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  8002d9:	e8 11 04 00 00       	call   8006ef <cprintf>
  8002de:	eb 11                	jmp    8002f1 <check_regs+0x2be>
  8002e0:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  8002e7:	e8 03 04 00 00       	call   8006ef <cprintf>
  8002ec:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esp, esp);
  8002f1:	8b 43 28             	mov    0x28(%ebx),%eax
  8002f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f8:	8b 46 28             	mov    0x28(%esi),%eax
  8002fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ff:	c7 44 24 04 35 2d 80 	movl   $0x802d35,0x4(%esp)
  800306:	00 
  800307:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  80030e:	e8 dc 03 00 00       	call   8006ef <cprintf>
  800313:	8b 43 28             	mov    0x28(%ebx),%eax
  800316:	39 46 28             	cmp    %eax,0x28(%esi)
  800319:	75 25                	jne    800340 <check_regs+0x30d>
  80031b:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  800322:	e8 c8 03 00 00       	call   8006ef <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032e:	c7 04 24 39 2d 80 00 	movl   $0x802d39,(%esp)
  800335:	e8 b5 03 00 00       	call   8006ef <cprintf>
	if (!mismatch)
  80033a:	85 ff                	test   %edi,%edi
  80033c:	74 23                	je     800361 <check_regs+0x32e>
  80033e:	eb 2f                	jmp    80036f <check_regs+0x33c>
	CHECK(edx, regs.reg_edx);
	CHECK(ecx, regs.reg_ecx);
	CHECK(eax, regs.reg_eax);
	CHECK(eip, eip);
	CHECK(eflags, eflags);
	CHECK(esp, esp);
  800340:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  800347:	e8 a3 03 00 00       	call   8006ef <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800353:	c7 04 24 39 2d 80 00 	movl   $0x802d39,(%esp)
  80035a:	e8 90 03 00 00       	call   8006ef <cprintf>
  80035f:	eb 0e                	jmp    80036f <check_regs+0x33c>
	if (!mismatch)
		cprintf("OK\n");
  800361:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  800368:	e8 82 03 00 00       	call   8006ef <cprintf>
  80036d:	eb 0c                	jmp    80037b <check_regs+0x348>
	else
		cprintf("MISMATCH\n");
  80036f:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  800376:	e8 74 03 00 00       	call   8006ef <cprintf>
}
  80037b:	83 c4 1c             	add    $0x1c,%esp
  80037e:	5b                   	pop    %ebx
  80037f:	5e                   	pop    %esi
  800380:	5f                   	pop    %edi
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	83 ec 28             	sub    $0x28,%esp
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  80038c:	8b 10                	mov    (%eax),%edx
  80038e:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  800394:	74 27                	je     8003bd <pgfault+0x3a>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  800396:	8b 40 28             	mov    0x28(%eax),%eax
  800399:	89 44 24 10          	mov    %eax,0x10(%esp)
  80039d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a1:	c7 44 24 08 a0 2d 80 	movl   $0x802da0,0x8(%esp)
  8003a8:	00 
  8003a9:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  8003b0:	00 
  8003b1:	c7 04 24 47 2d 80 00 	movl   $0x802d47,(%esp)
  8003b8:	e8 39 02 00 00       	call   8005f6 <_panic>
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003bd:	8b 50 08             	mov    0x8(%eax),%edx
  8003c0:	89 15 40 50 80 00    	mov    %edx,0x805040
  8003c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8003c9:	89 15 44 50 80 00    	mov    %edx,0x805044
  8003cf:	8b 50 10             	mov    0x10(%eax),%edx
  8003d2:	89 15 48 50 80 00    	mov    %edx,0x805048
  8003d8:	8b 50 14             	mov    0x14(%eax),%edx
  8003db:	89 15 4c 50 80 00    	mov    %edx,0x80504c
  8003e1:	8b 50 18             	mov    0x18(%eax),%edx
  8003e4:	89 15 50 50 80 00    	mov    %edx,0x805050
  8003ea:	8b 50 1c             	mov    0x1c(%eax),%edx
  8003ed:	89 15 54 50 80 00    	mov    %edx,0x805054
  8003f3:	8b 50 20             	mov    0x20(%eax),%edx
  8003f6:	89 15 58 50 80 00    	mov    %edx,0x805058
  8003fc:	8b 50 24             	mov    0x24(%eax),%edx
  8003ff:	89 15 5c 50 80 00    	mov    %edx,0x80505c
	during.eip = utf->utf_eip;
  800405:	8b 50 28             	mov    0x28(%eax),%edx
  800408:	89 15 60 50 80 00    	mov    %edx,0x805060
	during.eflags = utf->utf_eflags;
  80040e:	8b 50 2c             	mov    0x2c(%eax),%edx
  800411:	89 15 64 50 80 00    	mov    %edx,0x805064
	during.esp = utf->utf_esp;
  800417:	8b 40 30             	mov    0x30(%eax),%eax
  80041a:	a3 68 50 80 00       	mov    %eax,0x805068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  80041f:	c7 44 24 04 5f 2d 80 	movl   $0x802d5f,0x4(%esp)
  800426:	00 
  800427:	c7 04 24 6d 2d 80 00 	movl   $0x802d6d,(%esp)
  80042e:	b9 40 50 80 00       	mov    $0x805040,%ecx
  800433:	ba 58 2d 80 00       	mov    $0x802d58,%edx
  800438:	b8 80 50 80 00       	mov    $0x805080,%eax
  80043d:	e8 f1 fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800442:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800449:	00 
  80044a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800451:	00 
  800452:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800459:	e8 77 0d 00 00       	call   8011d5 <sys_page_alloc>
  80045e:	85 c0                	test   %eax,%eax
  800460:	79 20                	jns    800482 <pgfault+0xff>
		panic("sys_page_alloc: %e", r);
  800462:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800466:	c7 44 24 08 74 2d 80 	movl   $0x802d74,0x8(%esp)
  80046d:	00 
  80046e:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800475:	00 
  800476:	c7 04 24 47 2d 80 00 	movl   $0x802d47,(%esp)
  80047d:	e8 74 01 00 00       	call   8005f6 <_panic>
}
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <umain>:

void
umain(int argc, char **argv)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(pgfault);
  80048a:	c7 04 24 83 03 80 00 	movl   $0x800383,(%esp)
  800491:	e8 48 10 00 00       	call   8014de <set_pgfault_handler>

	__asm __volatile(
  800496:	50                   	push   %eax
  800497:	9c                   	pushf  
  800498:	58                   	pop    %eax
  800499:	0d d5 08 00 00       	or     $0x8d5,%eax
  80049e:	50                   	push   %eax
  80049f:	9d                   	popf   
  8004a0:	a3 a4 50 80 00       	mov    %eax,0x8050a4
  8004a5:	8d 05 e0 04 80 00    	lea    0x8004e0,%eax
  8004ab:	a3 a0 50 80 00       	mov    %eax,0x8050a0
  8004b0:	58                   	pop    %eax
  8004b1:	89 3d 80 50 80 00    	mov    %edi,0x805080
  8004b7:	89 35 84 50 80 00    	mov    %esi,0x805084
  8004bd:	89 2d 88 50 80 00    	mov    %ebp,0x805088
  8004c3:	89 1d 90 50 80 00    	mov    %ebx,0x805090
  8004c9:	89 15 94 50 80 00    	mov    %edx,0x805094
  8004cf:	89 0d 98 50 80 00    	mov    %ecx,0x805098
  8004d5:	a3 9c 50 80 00       	mov    %eax,0x80509c
  8004da:	89 25 a8 50 80 00    	mov    %esp,0x8050a8
  8004e0:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  8004e7:	00 00 00 
  8004ea:	89 3d 00 50 80 00    	mov    %edi,0x805000
  8004f0:	89 35 04 50 80 00    	mov    %esi,0x805004
  8004f6:	89 2d 08 50 80 00    	mov    %ebp,0x805008
  8004fc:	89 1d 10 50 80 00    	mov    %ebx,0x805010
  800502:	89 15 14 50 80 00    	mov    %edx,0x805014
  800508:	89 0d 18 50 80 00    	mov    %ecx,0x805018
  80050e:	a3 1c 50 80 00       	mov    %eax,0x80501c
  800513:	89 25 28 50 80 00    	mov    %esp,0x805028
  800519:	8b 3d 80 50 80 00    	mov    0x805080,%edi
  80051f:	8b 35 84 50 80 00    	mov    0x805084,%esi
  800525:	8b 2d 88 50 80 00    	mov    0x805088,%ebp
  80052b:	8b 1d 90 50 80 00    	mov    0x805090,%ebx
  800531:	8b 15 94 50 80 00    	mov    0x805094,%edx
  800537:	8b 0d 98 50 80 00    	mov    0x805098,%ecx
  80053d:	a1 9c 50 80 00       	mov    0x80509c,%eax
  800542:	8b 25 a8 50 80 00    	mov    0x8050a8,%esp
  800548:	50                   	push   %eax
  800549:	9c                   	pushf  
  80054a:	58                   	pop    %eax
  80054b:	a3 24 50 80 00       	mov    %eax,0x805024
  800550:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800551:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  800558:	74 0c                	je     800566 <umain+0xe2>
		cprintf("EIP after page-fault MISMATCH\n");
  80055a:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  800561:	e8 89 01 00 00       	call   8006ef <cprintf>
	after.eip = before.eip;
  800566:	a1 a0 50 80 00       	mov    0x8050a0,%eax
  80056b:	a3 20 50 80 00       	mov    %eax,0x805020

	check_regs(&before, "before", &after, "after", "after page-fault");
  800570:	c7 44 24 04 87 2d 80 	movl   $0x802d87,0x4(%esp)
  800577:	00 
  800578:	c7 04 24 98 2d 80 00 	movl   $0x802d98,(%esp)
  80057f:	b9 00 50 80 00       	mov    $0x805000,%ecx
  800584:	ba 58 2d 80 00       	mov    $0x802d58,%edx
  800589:	b8 80 50 80 00       	mov    $0x805080,%eax
  80058e:	e8 a0 fa ff ff       	call   800033 <check_regs>
}
  800593:	c9                   	leave  
  800594:	c3                   	ret    

00800595 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
  80059a:	83 ec 10             	sub    $0x10,%esp
  80059d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005a0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  8005a3:	e8 ef 0b 00 00       	call   801197 <sys_getenvid>
  8005a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005ad:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005b0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005b5:	a3 b4 50 80 00       	mov    %eax,0x8050b4

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005ba:	85 db                	test   %ebx,%ebx
  8005bc:	7e 07                	jle    8005c5 <libmain+0x30>
		binaryname = argv[0];
  8005be:	8b 06                	mov    (%esi),%eax
  8005c0:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8005c5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005c9:	89 1c 24             	mov    %ebx,(%esp)
  8005cc:	e8 b3 fe ff ff       	call   800484 <umain>

	// exit gracefully
	exit();
  8005d1:	e8 07 00 00 00       	call   8005dd <exit>
}
  8005d6:	83 c4 10             	add    $0x10,%esp
  8005d9:	5b                   	pop    %ebx
  8005da:	5e                   	pop    %esi
  8005db:	5d                   	pop    %ebp
  8005dc:	c3                   	ret    

008005dd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005dd:	55                   	push   %ebp
  8005de:	89 e5                	mov    %esp,%ebp
  8005e0:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8005e3:	e8 92 11 00 00       	call   80177a <close_all>
	sys_env_destroy(0);
  8005e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005ef:	e8 ff 0a 00 00       	call   8010f3 <sys_env_destroy>
}
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	56                   	push   %esi
  8005fa:	53                   	push   %ebx
  8005fb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8005fe:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800601:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800607:	e8 8b 0b 00 00       	call   801197 <sys_getenvid>
  80060c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060f:	89 54 24 10          	mov    %edx,0x10(%esp)
  800613:	8b 55 08             	mov    0x8(%ebp),%edx
  800616:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80061a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80061e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800622:	c7 04 24 00 2e 80 00 	movl   $0x802e00,(%esp)
  800629:	e8 c1 00 00 00       	call   8006ef <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80062e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800632:	8b 45 10             	mov    0x10(%ebp),%eax
  800635:	89 04 24             	mov    %eax,(%esp)
  800638:	e8 51 00 00 00       	call   80068e <vcprintf>
	cprintf("\n");
  80063d:	c7 04 24 10 2d 80 00 	movl   $0x802d10,(%esp)
  800644:	e8 a6 00 00 00       	call   8006ef <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800649:	cc                   	int3   
  80064a:	eb fd                	jmp    800649 <_panic+0x53>

0080064c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80064c:	55                   	push   %ebp
  80064d:	89 e5                	mov    %esp,%ebp
  80064f:	53                   	push   %ebx
  800650:	83 ec 14             	sub    $0x14,%esp
  800653:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800656:	8b 13                	mov    (%ebx),%edx
  800658:	8d 42 01             	lea    0x1(%edx),%eax
  80065b:	89 03                	mov    %eax,(%ebx)
  80065d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800660:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800664:	3d ff 00 00 00       	cmp    $0xff,%eax
  800669:	75 19                	jne    800684 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80066b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800672:	00 
  800673:	8d 43 08             	lea    0x8(%ebx),%eax
  800676:	89 04 24             	mov    %eax,(%esp)
  800679:	e8 38 0a 00 00       	call   8010b6 <sys_cputs>
		b->idx = 0;
  80067e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800684:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800688:	83 c4 14             	add    $0x14,%esp
  80068b:	5b                   	pop    %ebx
  80068c:	5d                   	pop    %ebp
  80068d:	c3                   	ret    

0080068e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800697:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80069e:	00 00 00 
	b.cnt = 0;
  8006a1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006a8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c3:	c7 04 24 4c 06 80 00 	movl   $0x80064c,(%esp)
  8006ca:	e8 75 01 00 00       	call   800844 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006cf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8006d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006d9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006df:	89 04 24             	mov    %eax,(%esp)
  8006e2:	e8 cf 09 00 00       	call   8010b6 <sys_cputs>

	return b.cnt;
}
  8006e7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006ed:	c9                   	leave  
  8006ee:	c3                   	ret    

008006ef <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006ef:	55                   	push   %ebp
  8006f0:	89 e5                	mov    %esp,%ebp
  8006f2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006f5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	89 04 24             	mov    %eax,(%esp)
  800702:	e8 87 ff ff ff       	call   80068e <vcprintf>
	va_end(ap);

	return cnt;
}
  800707:	c9                   	leave  
  800708:	c3                   	ret    
  800709:	66 90                	xchg   %ax,%ax
  80070b:	66 90                	xchg   %ax,%ax
  80070d:	66 90                	xchg   %ax,%ax
  80070f:	90                   	nop

00800710 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	57                   	push   %edi
  800714:	56                   	push   %esi
  800715:	53                   	push   %ebx
  800716:	83 ec 3c             	sub    $0x3c,%esp
  800719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80071c:	89 d7                	mov    %edx,%edi
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800724:	8b 45 0c             	mov    0xc(%ebp),%eax
  800727:	89 c3                	mov    %eax,%ebx
  800729:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80072c:	8b 45 10             	mov    0x10(%ebp),%eax
  80072f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800732:	b9 00 00 00 00       	mov    $0x0,%ecx
  800737:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80073d:	39 d9                	cmp    %ebx,%ecx
  80073f:	72 05                	jb     800746 <printnum+0x36>
  800741:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800744:	77 69                	ja     8007af <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800746:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800749:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80074d:	83 ee 01             	sub    $0x1,%esi
  800750:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800754:	89 44 24 08          	mov    %eax,0x8(%esp)
  800758:	8b 44 24 08          	mov    0x8(%esp),%eax
  80075c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800760:	89 c3                	mov    %eax,%ebx
  800762:	89 d6                	mov    %edx,%esi
  800764:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800767:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80076a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80076e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800772:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800775:	89 04 24             	mov    %eax,(%esp)
  800778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80077b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077f:	e8 cc 22 00 00       	call   802a50 <__udivdi3>
  800784:	89 d9                	mov    %ebx,%ecx
  800786:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80078a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80078e:	89 04 24             	mov    %eax,(%esp)
  800791:	89 54 24 04          	mov    %edx,0x4(%esp)
  800795:	89 fa                	mov    %edi,%edx
  800797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80079a:	e8 71 ff ff ff       	call   800710 <printnum>
  80079f:	eb 1b                	jmp    8007bc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007a1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a8:	89 04 24             	mov    %eax,(%esp)
  8007ab:	ff d3                	call   *%ebx
  8007ad:	eb 03                	jmp    8007b2 <printnum+0xa2>
  8007af:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b2:	83 ee 01             	sub    $0x1,%esi
  8007b5:	85 f6                	test   %esi,%esi
  8007b7:	7f e8                	jg     8007a1 <printnum+0x91>
  8007b9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8007c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d5:	89 04 24             	mov    %eax,(%esp)
  8007d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007df:	e8 9c 23 00 00       	call   802b80 <__umoddi3>
  8007e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e8:	0f be 80 23 2e 80 00 	movsbl 0x802e23(%eax),%eax
  8007ef:	89 04 24             	mov    %eax,(%esp)
  8007f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
}
  8007f7:	83 c4 3c             	add    $0x3c,%esp
  8007fa:	5b                   	pop    %ebx
  8007fb:	5e                   	pop    %esi
  8007fc:	5f                   	pop    %edi
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800805:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800809:	8b 10                	mov    (%eax),%edx
  80080b:	3b 50 04             	cmp    0x4(%eax),%edx
  80080e:	73 0a                	jae    80081a <sprintputch+0x1b>
		*b->buf++ = ch;
  800810:	8d 4a 01             	lea    0x1(%edx),%ecx
  800813:	89 08                	mov    %ecx,(%eax)
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	88 02                	mov    %al,(%edx)
}
  80081a:	5d                   	pop    %ebp
  80081b:	c3                   	ret    

0080081c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800822:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800825:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800829:	8b 45 10             	mov    0x10(%ebp),%eax
  80082c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800830:	8b 45 0c             	mov    0xc(%ebp),%eax
  800833:	89 44 24 04          	mov    %eax,0x4(%esp)
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	89 04 24             	mov    %eax,(%esp)
  80083d:	e8 02 00 00 00       	call   800844 <vprintfmt>
	va_end(ap);
}
  800842:	c9                   	leave  
  800843:	c3                   	ret    

00800844 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	57                   	push   %edi
  800848:	56                   	push   %esi
  800849:	53                   	push   %ebx
  80084a:	83 ec 3c             	sub    $0x3c,%esp
  80084d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800850:	eb 17                	jmp    800869 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  800852:	85 c0                	test   %eax,%eax
  800854:	0f 84 4b 04 00 00    	je     800ca5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  80085a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800861:	89 04 24             	mov    %eax,(%esp)
  800864:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  800867:	89 fb                	mov    %edi,%ebx
  800869:	8d 7b 01             	lea    0x1(%ebx),%edi
  80086c:	0f b6 03             	movzbl (%ebx),%eax
  80086f:	83 f8 25             	cmp    $0x25,%eax
  800872:	75 de                	jne    800852 <vprintfmt+0xe>
  800874:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800878:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80087f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800884:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80088b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800890:	eb 18                	jmp    8008aa <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800892:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800894:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800898:	eb 10                	jmp    8008aa <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80089c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8008a0:	eb 08                	jmp    8008aa <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8008a2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008a5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008aa:	8d 5f 01             	lea    0x1(%edi),%ebx
  8008ad:	0f b6 17             	movzbl (%edi),%edx
  8008b0:	0f b6 c2             	movzbl %dl,%eax
  8008b3:	83 ea 23             	sub    $0x23,%edx
  8008b6:	80 fa 55             	cmp    $0x55,%dl
  8008b9:	0f 87 c2 03 00 00    	ja     800c81 <vprintfmt+0x43d>
  8008bf:	0f b6 d2             	movzbl %dl,%edx
  8008c2:	ff 24 95 60 2f 80 00 	jmp    *0x802f60(,%edx,4)
  8008c9:	89 df                	mov    %ebx,%edi
  8008cb:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8008d0:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8008d3:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8008d7:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  8008da:	8d 50 d0             	lea    -0x30(%eax),%edx
  8008dd:	83 fa 09             	cmp    $0x9,%edx
  8008e0:	77 33                	ja     800915 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008e5:	eb e9                	jmp    8008d0 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	8b 30                	mov    (%eax),%esi
  8008ec:	8d 40 04             	lea    0x4(%eax),%eax
  8008ef:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f2:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8008f4:	eb 1f                	jmp    800915 <vprintfmt+0xd1>
  8008f6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8008f9:	85 ff                	test   %edi,%edi
  8008fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800900:	0f 49 c7             	cmovns %edi,%eax
  800903:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800906:	89 df                	mov    %ebx,%edi
  800908:	eb a0                	jmp    8008aa <vprintfmt+0x66>
  80090a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80090c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  800913:	eb 95                	jmp    8008aa <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  800915:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800919:	79 8f                	jns    8008aa <vprintfmt+0x66>
  80091b:	eb 85                	jmp    8008a2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80091d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800920:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800922:	eb 86                	jmp    8008aa <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	8d 70 04             	lea    0x4(%eax),%esi
  80092a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8b 00                	mov    (%eax),%eax
  800936:	89 04 24             	mov    %eax,(%esp)
  800939:	ff 55 08             	call   *0x8(%ebp)
  80093c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  80093f:	e9 25 ff ff ff       	jmp    800869 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800944:	8b 45 14             	mov    0x14(%ebp),%eax
  800947:	8d 70 04             	lea    0x4(%eax),%esi
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	99                   	cltd   
  80094d:	31 d0                	xor    %edx,%eax
  80094f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800951:	83 f8 15             	cmp    $0x15,%eax
  800954:	7f 0b                	jg     800961 <vprintfmt+0x11d>
  800956:	8b 14 85 c0 30 80 00 	mov    0x8030c0(,%eax,4),%edx
  80095d:	85 d2                	test   %edx,%edx
  80095f:	75 26                	jne    800987 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  800961:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800965:	c7 44 24 08 3b 2e 80 	movl   $0x802e3b,0x8(%esp)
  80096c:	00 
  80096d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800970:	89 44 24 04          	mov    %eax,0x4(%esp)
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	89 04 24             	mov    %eax,(%esp)
  80097a:	e8 9d fe ff ff       	call   80081c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  80097f:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800982:	e9 e2 fe ff ff       	jmp    800869 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800987:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80098b:	c7 44 24 08 42 32 80 	movl   $0x803242,0x8(%esp)
  800992:	00 
  800993:	8b 45 0c             	mov    0xc(%ebp),%eax
  800996:	89 44 24 04          	mov    %eax,0x4(%esp)
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	89 04 24             	mov    %eax,(%esp)
  8009a0:	e8 77 fe ff ff       	call   80081c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009a5:	89 75 14             	mov    %esi,0x14(%ebp)
  8009a8:	e9 bc fe ff ff       	jmp    800869 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009b3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009b6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8009ba:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8009bc:	85 ff                	test   %edi,%edi
  8009be:	b8 34 2e 80 00       	mov    $0x802e34,%eax
  8009c3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8009c6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8009ca:	0f 84 94 00 00 00    	je     800a64 <vprintfmt+0x220>
  8009d0:	85 c9                	test   %ecx,%ecx
  8009d2:	0f 8e 94 00 00 00    	jle    800a6c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009dc:	89 3c 24             	mov    %edi,(%esp)
  8009df:	e8 64 03 00 00       	call   800d48 <strnlen>
  8009e4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8009e7:	29 c1                	sub    %eax,%ecx
  8009e9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  8009ec:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  8009f0:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8009f3:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8009f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009fc:	89 cb                	mov    %ecx,%ebx
  8009fe:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a00:	eb 0f                	jmp    800a11 <vprintfmt+0x1cd>
					putch(padc, putdat);
  800a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a05:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a09:	89 3c 24             	mov    %edi,(%esp)
  800a0c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0e:	83 eb 01             	sub    $0x1,%ebx
  800a11:	85 db                	test   %ebx,%ebx
  800a13:	7f ed                	jg     800a02 <vprintfmt+0x1be>
  800a15:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800a18:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800a1b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a1e:	85 c9                	test   %ecx,%ecx
  800a20:	b8 00 00 00 00       	mov    $0x0,%eax
  800a25:	0f 49 c1             	cmovns %ecx,%eax
  800a28:	29 c1                	sub    %eax,%ecx
  800a2a:	89 cb                	mov    %ecx,%ebx
  800a2c:	eb 44                	jmp    800a72 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a32:	74 1e                	je     800a52 <vprintfmt+0x20e>
  800a34:	0f be d2             	movsbl %dl,%edx
  800a37:	83 ea 20             	sub    $0x20,%edx
  800a3a:	83 fa 5e             	cmp    $0x5e,%edx
  800a3d:	76 13                	jbe    800a52 <vprintfmt+0x20e>
					putch('?', putdat);
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a46:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a4d:	ff 55 08             	call   *0x8(%ebp)
  800a50:	eb 0d                	jmp    800a5f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  800a52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a55:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a59:	89 04 24             	mov    %eax,(%esp)
  800a5c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a5f:	83 eb 01             	sub    $0x1,%ebx
  800a62:	eb 0e                	jmp    800a72 <vprintfmt+0x22e>
  800a64:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a67:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a6a:	eb 06                	jmp    800a72 <vprintfmt+0x22e>
  800a6c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a6f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a72:	83 c7 01             	add    $0x1,%edi
  800a75:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800a79:	0f be c2             	movsbl %dl,%eax
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	74 27                	je     800aa7 <vprintfmt+0x263>
  800a80:	85 f6                	test   %esi,%esi
  800a82:	78 aa                	js     800a2e <vprintfmt+0x1ea>
  800a84:	83 ee 01             	sub    $0x1,%esi
  800a87:	79 a5                	jns    800a2e <vprintfmt+0x1ea>
  800a89:	89 d8                	mov    %ebx,%eax
  800a8b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a91:	89 c3                	mov    %eax,%ebx
  800a93:	eb 18                	jmp    800aad <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a95:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a99:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800aa0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa2:	83 eb 01             	sub    $0x1,%ebx
  800aa5:	eb 06                	jmp    800aad <vprintfmt+0x269>
  800aa7:	8b 75 08             	mov    0x8(%ebp),%esi
  800aaa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	7f e4                	jg     800a95 <vprintfmt+0x251>
  800ab1:	89 75 08             	mov    %esi,0x8(%ebp)
  800ab4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800ab7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800aba:	e9 aa fd ff ff       	jmp    800869 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800abf:	83 f9 01             	cmp    $0x1,%ecx
  800ac2:	7e 10                	jle    800ad4 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  800ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac7:	8b 30                	mov    (%eax),%esi
  800ac9:	8b 78 04             	mov    0x4(%eax),%edi
  800acc:	8d 40 08             	lea    0x8(%eax),%eax
  800acf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad2:	eb 26                	jmp    800afa <vprintfmt+0x2b6>
	else if (lflag)
  800ad4:	85 c9                	test   %ecx,%ecx
  800ad6:	74 12                	je     800aea <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	8b 30                	mov    (%eax),%esi
  800add:	89 f7                	mov    %esi,%edi
  800adf:	c1 ff 1f             	sar    $0x1f,%edi
  800ae2:	8d 40 04             	lea    0x4(%eax),%eax
  800ae5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae8:	eb 10                	jmp    800afa <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	8b 30                	mov    (%eax),%esi
  800aef:	89 f7                	mov    %esi,%edi
  800af1:	c1 ff 1f             	sar    $0x1f,%edi
  800af4:	8d 40 04             	lea    0x4(%eax),%eax
  800af7:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800afa:	89 f0                	mov    %esi,%eax
  800afc:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800afe:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b03:	85 ff                	test   %edi,%edi
  800b05:	0f 89 3a 01 00 00    	jns    800c45 <vprintfmt+0x401>
				putch('-', putdat);
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b12:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b19:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b1c:	89 f0                	mov    %esi,%eax
  800b1e:	89 fa                	mov    %edi,%edx
  800b20:	f7 d8                	neg    %eax
  800b22:	83 d2 00             	adc    $0x0,%edx
  800b25:	f7 da                	neg    %edx
			}
			base = 10;
  800b27:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800b2c:	e9 14 01 00 00       	jmp    800c45 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b31:	83 f9 01             	cmp    $0x1,%ecx
  800b34:	7e 13                	jle    800b49 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  800b36:	8b 45 14             	mov    0x14(%ebp),%eax
  800b39:	8b 50 04             	mov    0x4(%eax),%edx
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	8b 75 14             	mov    0x14(%ebp),%esi
  800b41:	8d 4e 08             	lea    0x8(%esi),%ecx
  800b44:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800b47:	eb 2c                	jmp    800b75 <vprintfmt+0x331>
	else if (lflag)
  800b49:	85 c9                	test   %ecx,%ecx
  800b4b:	74 15                	je     800b62 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  800b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	ba 00 00 00 00       	mov    $0x0,%edx
  800b57:	8b 75 14             	mov    0x14(%ebp),%esi
  800b5a:	8d 76 04             	lea    0x4(%esi),%esi
  800b5d:	89 75 14             	mov    %esi,0x14(%ebp)
  800b60:	eb 13                	jmp    800b75 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  800b62:	8b 45 14             	mov    0x14(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6c:	8b 75 14             	mov    0x14(%ebp),%esi
  800b6f:	8d 76 04             	lea    0x4(%esi),%esi
  800b72:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800b75:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800b7a:	e9 c6 00 00 00       	jmp    800c45 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b7f:	83 f9 01             	cmp    $0x1,%ecx
  800b82:	7e 13                	jle    800b97 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  800b84:	8b 45 14             	mov    0x14(%ebp),%eax
  800b87:	8b 50 04             	mov    0x4(%eax),%edx
  800b8a:	8b 00                	mov    (%eax),%eax
  800b8c:	8b 75 14             	mov    0x14(%ebp),%esi
  800b8f:	8d 4e 08             	lea    0x8(%esi),%ecx
  800b92:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800b95:	eb 24                	jmp    800bbb <vprintfmt+0x377>
	else if (lflag)
  800b97:	85 c9                	test   %ecx,%ecx
  800b99:	74 11                	je     800bac <vprintfmt+0x368>
		return va_arg(*ap, long);
  800b9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	99                   	cltd   
  800ba1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800ba4:	8d 71 04             	lea    0x4(%ecx),%esi
  800ba7:	89 75 14             	mov    %esi,0x14(%ebp)
  800baa:	eb 0f                	jmp    800bbb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  800bac:	8b 45 14             	mov    0x14(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	99                   	cltd   
  800bb2:	8b 75 14             	mov    0x14(%ebp),%esi
  800bb5:	8d 76 04             	lea    0x4(%esi),%esi
  800bb8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  800bbb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800bc0:	e9 80 00 00 00       	jmp    800c45 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bcf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800bd6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800be0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800be7:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800bea:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bee:	8b 06                	mov    (%esi),%eax
  800bf0:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800bf5:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800bfa:	eb 49                	jmp    800c45 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800bfc:	83 f9 01             	cmp    $0x1,%ecx
  800bff:	7e 13                	jle    800c14 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  800c01:	8b 45 14             	mov    0x14(%ebp),%eax
  800c04:	8b 50 04             	mov    0x4(%eax),%edx
  800c07:	8b 00                	mov    (%eax),%eax
  800c09:	8b 75 14             	mov    0x14(%ebp),%esi
  800c0c:	8d 4e 08             	lea    0x8(%esi),%ecx
  800c0f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800c12:	eb 2c                	jmp    800c40 <vprintfmt+0x3fc>
	else if (lflag)
  800c14:	85 c9                	test   %ecx,%ecx
  800c16:	74 15                	je     800c2d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  800c18:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1b:	8b 00                	mov    (%eax),%eax
  800c1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c22:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800c25:	8d 71 04             	lea    0x4(%ecx),%esi
  800c28:	89 75 14             	mov    %esi,0x14(%ebp)
  800c2b:	eb 13                	jmp    800c40 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	8b 00                	mov    (%eax),%eax
  800c32:	ba 00 00 00 00       	mov    $0x0,%edx
  800c37:	8b 75 14             	mov    0x14(%ebp),%esi
  800c3a:	8d 76 04             	lea    0x4(%esi),%esi
  800c3d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800c40:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c45:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  800c49:	89 74 24 10          	mov    %esi,0x10(%esp)
  800c4d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  800c50:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800c54:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c58:	89 04 24             	mov    %eax,(%esp)
  800c5b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	e8 a6 fa ff ff       	call   800710 <printnum>
			break;
  800c6a:	e9 fa fb ff ff       	jmp    800869 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c76:	89 04 24             	mov    %eax,(%esp)
  800c79:	ff 55 08             	call   *0x8(%ebp)
			break;
  800c7c:	e9 e8 fb ff ff       	jmp    800869 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c88:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c8f:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c92:	89 fb                	mov    %edi,%ebx
  800c94:	eb 03                	jmp    800c99 <vprintfmt+0x455>
  800c96:	83 eb 01             	sub    $0x1,%ebx
  800c99:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800c9d:	75 f7                	jne    800c96 <vprintfmt+0x452>
  800c9f:	90                   	nop
  800ca0:	e9 c4 fb ff ff       	jmp    800869 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800ca5:	83 c4 3c             	add    $0x3c,%esp
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	83 ec 28             	sub    $0x28,%esp
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cbc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800cc0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800cc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	74 30                	je     800cfe <vsnprintf+0x51>
  800cce:	85 d2                	test   %edx,%edx
  800cd0:	7e 2c                	jle    800cfe <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ce0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ce7:	c7 04 24 ff 07 80 00 	movl   $0x8007ff,(%esp)
  800cee:	e8 51 fb ff ff       	call   800844 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfc:	eb 05                	jmp    800d03 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800cfe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d0b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d0e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	89 04 24             	mov    %eax,(%esp)
  800d26:	e8 82 ff ff ff       	call   800cad <vsnprintf>
	va_end(ap);

	return rc;
}
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    
  800d2d:	66 90                	xchg   %ax,%ax
  800d2f:	90                   	nop

00800d30 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d36:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3b:	eb 03                	jmp    800d40 <strlen+0x10>
		n++;
  800d3d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d40:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d44:	75 f7                	jne    800d3d <strlen+0xd>
		n++;
	return n;
}
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d51:	b8 00 00 00 00       	mov    $0x0,%eax
  800d56:	eb 03                	jmp    800d5b <strnlen+0x13>
		n++;
  800d58:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5b:	39 d0                	cmp    %edx,%eax
  800d5d:	74 06                	je     800d65 <strnlen+0x1d>
  800d5f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d63:	75 f3                	jne    800d58 <strnlen+0x10>
		n++;
	return n;
}
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	53                   	push   %ebx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d71:	89 c2                	mov    %eax,%edx
  800d73:	83 c2 01             	add    $0x1,%edx
  800d76:	83 c1 01             	add    $0x1,%ecx
  800d79:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d7d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d80:	84 db                	test   %bl,%bl
  800d82:	75 ef                	jne    800d73 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d84:	5b                   	pop    %ebx
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 08             	sub    $0x8,%esp
  800d8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d91:	89 1c 24             	mov    %ebx,(%esp)
  800d94:	e8 97 ff ff ff       	call   800d30 <strlen>
	strcpy(dst + len, src);
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800da0:	01 d8                	add    %ebx,%eax
  800da2:	89 04 24             	mov    %eax,(%esp)
  800da5:	e8 bd ff ff ff       	call   800d67 <strcpy>
	return dst;
}
  800daa:	89 d8                	mov    %ebx,%eax
  800dac:	83 c4 08             	add    $0x8,%esp
  800daf:	5b                   	pop    %ebx
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    

00800db2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	8b 75 08             	mov    0x8(%ebp),%esi
  800dba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbd:	89 f3                	mov    %esi,%ebx
  800dbf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dc2:	89 f2                	mov    %esi,%edx
  800dc4:	eb 0f                	jmp    800dd5 <strncpy+0x23>
		*dst++ = *src;
  800dc6:	83 c2 01             	add    $0x1,%edx
  800dc9:	0f b6 01             	movzbl (%ecx),%eax
  800dcc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800dcf:	80 39 01             	cmpb   $0x1,(%ecx)
  800dd2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd5:	39 da                	cmp    %ebx,%edx
  800dd7:	75 ed                	jne    800dc6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800dd9:	89 f0                	mov    %esi,%eax
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	56                   	push   %esi
  800de3:	53                   	push   %ebx
  800de4:	8b 75 08             	mov    0x8(%ebp),%esi
  800de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ded:	89 f0                	mov    %esi,%eax
  800def:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800df3:	85 c9                	test   %ecx,%ecx
  800df5:	75 0b                	jne    800e02 <strlcpy+0x23>
  800df7:	eb 1d                	jmp    800e16 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800df9:	83 c0 01             	add    $0x1,%eax
  800dfc:	83 c2 01             	add    $0x1,%edx
  800dff:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e02:	39 d8                	cmp    %ebx,%eax
  800e04:	74 0b                	je     800e11 <strlcpy+0x32>
  800e06:	0f b6 0a             	movzbl (%edx),%ecx
  800e09:	84 c9                	test   %cl,%cl
  800e0b:	75 ec                	jne    800df9 <strlcpy+0x1a>
  800e0d:	89 c2                	mov    %eax,%edx
  800e0f:	eb 02                	jmp    800e13 <strlcpy+0x34>
  800e11:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800e13:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800e16:	29 f0                	sub    %esi,%eax
}
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    

00800e1c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e22:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e25:	eb 06                	jmp    800e2d <strcmp+0x11>
		p++, q++;
  800e27:	83 c1 01             	add    $0x1,%ecx
  800e2a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e2d:	0f b6 01             	movzbl (%ecx),%eax
  800e30:	84 c0                	test   %al,%al
  800e32:	74 04                	je     800e38 <strcmp+0x1c>
  800e34:	3a 02                	cmp    (%edx),%al
  800e36:	74 ef                	je     800e27 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e38:	0f b6 c0             	movzbl %al,%eax
  800e3b:	0f b6 12             	movzbl (%edx),%edx
  800e3e:	29 d0                	sub    %edx,%eax
}
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    

00800e42 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	53                   	push   %ebx
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4c:	89 c3                	mov    %eax,%ebx
  800e4e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e51:	eb 06                	jmp    800e59 <strncmp+0x17>
		n--, p++, q++;
  800e53:	83 c0 01             	add    $0x1,%eax
  800e56:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e59:	39 d8                	cmp    %ebx,%eax
  800e5b:	74 15                	je     800e72 <strncmp+0x30>
  800e5d:	0f b6 08             	movzbl (%eax),%ecx
  800e60:	84 c9                	test   %cl,%cl
  800e62:	74 04                	je     800e68 <strncmp+0x26>
  800e64:	3a 0a                	cmp    (%edx),%cl
  800e66:	74 eb                	je     800e53 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e68:	0f b6 00             	movzbl (%eax),%eax
  800e6b:	0f b6 12             	movzbl (%edx),%edx
  800e6e:	29 d0                	sub    %edx,%eax
  800e70:	eb 05                	jmp    800e77 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800e72:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800e77:	5b                   	pop    %ebx
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e84:	eb 07                	jmp    800e8d <strchr+0x13>
		if (*s == c)
  800e86:	38 ca                	cmp    %cl,%dl
  800e88:	74 0f                	je     800e99 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e8a:	83 c0 01             	add    $0x1,%eax
  800e8d:	0f b6 10             	movzbl (%eax),%edx
  800e90:	84 d2                	test   %dl,%dl
  800e92:	75 f2                	jne    800e86 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800e94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ea5:	eb 07                	jmp    800eae <strfind+0x13>
		if (*s == c)
  800ea7:	38 ca                	cmp    %cl,%dl
  800ea9:	74 0a                	je     800eb5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800eab:	83 c0 01             	add    $0x1,%eax
  800eae:	0f b6 10             	movzbl (%eax),%edx
  800eb1:	84 d2                	test   %dl,%dl
  800eb3:	75 f2                	jne    800ea7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    

00800eb7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
  800ebd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ec0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ec3:	85 c9                	test   %ecx,%ecx
  800ec5:	74 36                	je     800efd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ec7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ecd:	75 28                	jne    800ef7 <memset+0x40>
  800ecf:	f6 c1 03             	test   $0x3,%cl
  800ed2:	75 23                	jne    800ef7 <memset+0x40>
		c &= 0xFF;
  800ed4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ed8:	89 d3                	mov    %edx,%ebx
  800eda:	c1 e3 08             	shl    $0x8,%ebx
  800edd:	89 d6                	mov    %edx,%esi
  800edf:	c1 e6 18             	shl    $0x18,%esi
  800ee2:	89 d0                	mov    %edx,%eax
  800ee4:	c1 e0 10             	shl    $0x10,%eax
  800ee7:	09 f0                	or     %esi,%eax
  800ee9:	09 c2                	or     %eax,%edx
  800eeb:	89 d0                	mov    %edx,%eax
  800eed:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800eef:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ef2:	fc                   	cld    
  800ef3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ef5:	eb 06                	jmp    800efd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	fc                   	cld    
  800efb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800efd:	89 f8                	mov    %edi,%eax
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	57                   	push   %edi
  800f08:	56                   	push   %esi
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f12:	39 c6                	cmp    %eax,%esi
  800f14:	73 35                	jae    800f4b <memmove+0x47>
  800f16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f19:	39 d0                	cmp    %edx,%eax
  800f1b:	73 2e                	jae    800f4b <memmove+0x47>
		s += n;
		d += n;
  800f1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800f20:	89 d6                	mov    %edx,%esi
  800f22:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f2a:	75 13                	jne    800f3f <memmove+0x3b>
  800f2c:	f6 c1 03             	test   $0x3,%cl
  800f2f:	75 0e                	jne    800f3f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f31:	83 ef 04             	sub    $0x4,%edi
  800f34:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f37:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800f3a:	fd                   	std    
  800f3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f3d:	eb 09                	jmp    800f48 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f3f:	83 ef 01             	sub    $0x1,%edi
  800f42:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800f45:	fd                   	std    
  800f46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f48:	fc                   	cld    
  800f49:	eb 1d                	jmp    800f68 <memmove+0x64>
  800f4b:	89 f2                	mov    %esi,%edx
  800f4d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f4f:	f6 c2 03             	test   $0x3,%dl
  800f52:	75 0f                	jne    800f63 <memmove+0x5f>
  800f54:	f6 c1 03             	test   $0x3,%cl
  800f57:	75 0a                	jne    800f63 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f59:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800f5c:	89 c7                	mov    %eax,%edi
  800f5e:	fc                   	cld    
  800f5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f61:	eb 05                	jmp    800f68 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f63:	89 c7                	mov    %eax,%edi
  800f65:	fc                   	cld    
  800f66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f68:	5e                   	pop    %esi
  800f69:	5f                   	pop    %edi
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	89 04 24             	mov    %eax,(%esp)
  800f86:	e8 79 ff ff ff       	call   800f04 <memmove>
}
  800f8b:	c9                   	leave  
  800f8c:	c3                   	ret    

00800f8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	56                   	push   %esi
  800f91:	53                   	push   %ebx
  800f92:	8b 55 08             	mov    0x8(%ebp),%edx
  800f95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f98:	89 d6                	mov    %edx,%esi
  800f9a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f9d:	eb 1a                	jmp    800fb9 <memcmp+0x2c>
		if (*s1 != *s2)
  800f9f:	0f b6 02             	movzbl (%edx),%eax
  800fa2:	0f b6 19             	movzbl (%ecx),%ebx
  800fa5:	38 d8                	cmp    %bl,%al
  800fa7:	74 0a                	je     800fb3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800fa9:	0f b6 c0             	movzbl %al,%eax
  800fac:	0f b6 db             	movzbl %bl,%ebx
  800faf:	29 d8                	sub    %ebx,%eax
  800fb1:	eb 0f                	jmp    800fc2 <memcmp+0x35>
		s1++, s2++;
  800fb3:	83 c2 01             	add    $0x1,%edx
  800fb6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fb9:	39 f2                	cmp    %esi,%edx
  800fbb:	75 e2                	jne    800f9f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc2:	5b                   	pop    %ebx
  800fc3:	5e                   	pop    %esi
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    

00800fc6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fd4:	eb 07                	jmp    800fdd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fd6:	38 08                	cmp    %cl,(%eax)
  800fd8:	74 07                	je     800fe1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fda:	83 c0 01             	add    $0x1,%eax
  800fdd:	39 d0                	cmp    %edx,%eax
  800fdf:	72 f5                	jb     800fd6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    

00800fe3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	57                   	push   %edi
  800fe7:	56                   	push   %esi
  800fe8:	53                   	push   %ebx
  800fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fec:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fef:	eb 03                	jmp    800ff4 <strtol+0x11>
		s++;
  800ff1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ff4:	0f b6 0a             	movzbl (%edx),%ecx
  800ff7:	80 f9 09             	cmp    $0x9,%cl
  800ffa:	74 f5                	je     800ff1 <strtol+0xe>
  800ffc:	80 f9 20             	cmp    $0x20,%cl
  800fff:	74 f0                	je     800ff1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  801001:	80 f9 2b             	cmp    $0x2b,%cl
  801004:	75 0a                	jne    801010 <strtol+0x2d>
		s++;
  801006:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801009:	bf 00 00 00 00       	mov    $0x0,%edi
  80100e:	eb 11                	jmp    801021 <strtol+0x3e>
  801010:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801015:	80 f9 2d             	cmp    $0x2d,%cl
  801018:	75 07                	jne    801021 <strtol+0x3e>
		s++, neg = 1;
  80101a:	8d 52 01             	lea    0x1(%edx),%edx
  80101d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801021:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801026:	75 15                	jne    80103d <strtol+0x5a>
  801028:	80 3a 30             	cmpb   $0x30,(%edx)
  80102b:	75 10                	jne    80103d <strtol+0x5a>
  80102d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801031:	75 0a                	jne    80103d <strtol+0x5a>
		s += 2, base = 16;
  801033:	83 c2 02             	add    $0x2,%edx
  801036:	b8 10 00 00 00       	mov    $0x10,%eax
  80103b:	eb 10                	jmp    80104d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80103d:	85 c0                	test   %eax,%eax
  80103f:	75 0c                	jne    80104d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801041:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801043:	80 3a 30             	cmpb   $0x30,(%edx)
  801046:	75 05                	jne    80104d <strtol+0x6a>
		s++, base = 8;
  801048:	83 c2 01             	add    $0x1,%edx
  80104b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80104d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801052:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801055:	0f b6 0a             	movzbl (%edx),%ecx
  801058:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80105b:	89 f0                	mov    %esi,%eax
  80105d:	3c 09                	cmp    $0x9,%al
  80105f:	77 08                	ja     801069 <strtol+0x86>
			dig = *s - '0';
  801061:	0f be c9             	movsbl %cl,%ecx
  801064:	83 e9 30             	sub    $0x30,%ecx
  801067:	eb 20                	jmp    801089 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801069:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80106c:	89 f0                	mov    %esi,%eax
  80106e:	3c 19                	cmp    $0x19,%al
  801070:	77 08                	ja     80107a <strtol+0x97>
			dig = *s - 'a' + 10;
  801072:	0f be c9             	movsbl %cl,%ecx
  801075:	83 e9 57             	sub    $0x57,%ecx
  801078:	eb 0f                	jmp    801089 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80107a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80107d:	89 f0                	mov    %esi,%eax
  80107f:	3c 19                	cmp    $0x19,%al
  801081:	77 16                	ja     801099 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801083:	0f be c9             	movsbl %cl,%ecx
  801086:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801089:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80108c:	7d 0f                	jge    80109d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80108e:	83 c2 01             	add    $0x1,%edx
  801091:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801095:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801097:	eb bc                	jmp    801055 <strtol+0x72>
  801099:	89 d8                	mov    %ebx,%eax
  80109b:	eb 02                	jmp    80109f <strtol+0xbc>
  80109d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80109f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a3:	74 05                	je     8010aa <strtol+0xc7>
		*endptr = (char *) s;
  8010a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010a8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8010aa:	f7 d8                	neg    %eax
  8010ac:	85 ff                	test   %edi,%edi
  8010ae:	0f 44 c3             	cmove  %ebx,%eax
}
  8010b1:	5b                   	pop    %ebx
  8010b2:	5e                   	pop    %esi
  8010b3:	5f                   	pop    %edi
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	57                   	push   %edi
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c7:	89 c3                	mov    %eax,%ebx
  8010c9:	89 c7                	mov    %eax,%edi
  8010cb:	89 c6                	mov    %eax,%esi
  8010cd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010cf:	5b                   	pop    %ebx
  8010d0:	5e                   	pop    %esi
  8010d1:	5f                   	pop    %edi
  8010d2:	5d                   	pop    %ebp
  8010d3:	c3                   	ret    

008010d4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	57                   	push   %edi
  8010d8:	56                   	push   %esi
  8010d9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010da:	ba 00 00 00 00       	mov    $0x0,%edx
  8010df:	b8 01 00 00 00       	mov    $0x1,%eax
  8010e4:	89 d1                	mov    %edx,%ecx
  8010e6:	89 d3                	mov    %edx,%ebx
  8010e8:	89 d7                	mov    %edx,%edi
  8010ea:	89 d6                	mov    %edx,%esi
  8010ec:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010ee:	5b                   	pop    %ebx
  8010ef:	5e                   	pop    %esi
  8010f0:	5f                   	pop    %edi
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	57                   	push   %edi
  8010f7:	56                   	push   %esi
  8010f8:	53                   	push   %ebx
  8010f9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801101:	b8 03 00 00 00       	mov    $0x3,%eax
  801106:	8b 55 08             	mov    0x8(%ebp),%edx
  801109:	89 cb                	mov    %ecx,%ebx
  80110b:	89 cf                	mov    %ecx,%edi
  80110d:	89 ce                	mov    %ecx,%esi
  80110f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801111:	85 c0                	test   %eax,%eax
  801113:	7e 28                	jle    80113d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801115:	89 44 24 10          	mov    %eax,0x10(%esp)
  801119:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801120:	00 
  801121:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  801128:	00 
  801129:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801130:	00 
  801131:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  801138:	e8 b9 f4 ff ff       	call   8005f6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80113d:	83 c4 2c             	add    $0x2c,%esp
  801140:	5b                   	pop    %ebx
  801141:	5e                   	pop    %esi
  801142:	5f                   	pop    %edi
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	57                   	push   %edi
  801149:	56                   	push   %esi
  80114a:	53                   	push   %ebx
  80114b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801153:	b8 04 00 00 00       	mov    $0x4,%eax
  801158:	8b 55 08             	mov    0x8(%ebp),%edx
  80115b:	89 cb                	mov    %ecx,%ebx
  80115d:	89 cf                	mov    %ecx,%edi
  80115f:	89 ce                	mov    %ecx,%esi
  801161:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801163:	85 c0                	test   %eax,%eax
  801165:	7e 28                	jle    80118f <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801167:	89 44 24 10          	mov    %eax,0x10(%esp)
  80116b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801172:	00 
  801173:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  80117a:	00 
  80117b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801182:	00 
  801183:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  80118a:	e8 67 f4 ff ff       	call   8005f6 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  80118f:	83 c4 2c             	add    $0x2c,%esp
  801192:	5b                   	pop    %ebx
  801193:	5e                   	pop    %esi
  801194:	5f                   	pop    %edi
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	57                   	push   %edi
  80119b:	56                   	push   %esi
  80119c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80119d:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a2:	b8 02 00 00 00       	mov    $0x2,%eax
  8011a7:	89 d1                	mov    %edx,%ecx
  8011a9:	89 d3                	mov    %edx,%ebx
  8011ab:	89 d7                	mov    %edx,%edi
  8011ad:	89 d6                	mov    %edx,%esi
  8011af:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011b1:	5b                   	pop    %ebx
  8011b2:	5e                   	pop    %esi
  8011b3:	5f                   	pop    %edi
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <sys_yield>:

void
sys_yield(void)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	57                   	push   %edi
  8011ba:	56                   	push   %esi
  8011bb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011c6:	89 d1                	mov    %edx,%ecx
  8011c8:	89 d3                	mov    %edx,%ebx
  8011ca:	89 d7                	mov    %edx,%edi
  8011cc:	89 d6                	mov    %edx,%esi
  8011ce:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011d0:	5b                   	pop    %ebx
  8011d1:	5e                   	pop    %esi
  8011d2:	5f                   	pop    %edi
  8011d3:	5d                   	pop    %ebp
  8011d4:	c3                   	ret    

008011d5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	57                   	push   %edi
  8011d9:	56                   	push   %esi
  8011da:	53                   	push   %ebx
  8011db:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011de:	be 00 00 00 00       	mov    $0x0,%esi
  8011e3:	b8 05 00 00 00       	mov    $0x5,%eax
  8011e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f1:	89 f7                	mov    %esi,%edi
  8011f3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	7e 28                	jle    801221 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011fd:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801204:	00 
  801205:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  80120c:	00 
  80120d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801214:	00 
  801215:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  80121c:	e8 d5 f3 ff ff       	call   8005f6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801221:	83 c4 2c             	add    $0x2c,%esp
  801224:	5b                   	pop    %ebx
  801225:	5e                   	pop    %esi
  801226:	5f                   	pop    %edi
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	57                   	push   %edi
  80122d:	56                   	push   %esi
  80122e:	53                   	push   %ebx
  80122f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801232:	b8 06 00 00 00       	mov    $0x6,%eax
  801237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123a:	8b 55 08             	mov    0x8(%ebp),%edx
  80123d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801240:	8b 7d 14             	mov    0x14(%ebp),%edi
  801243:	8b 75 18             	mov    0x18(%ebp),%esi
  801246:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801248:	85 c0                	test   %eax,%eax
  80124a:	7e 28                	jle    801274 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80124c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801250:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801257:	00 
  801258:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  80125f:	00 
  801260:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801267:	00 
  801268:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  80126f:	e8 82 f3 ff ff       	call   8005f6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801274:	83 c4 2c             	add    $0x2c,%esp
  801277:	5b                   	pop    %ebx
  801278:	5e                   	pop    %esi
  801279:	5f                   	pop    %edi
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    

0080127c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	57                   	push   %edi
  801280:	56                   	push   %esi
  801281:	53                   	push   %ebx
  801282:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801285:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128a:	b8 07 00 00 00       	mov    $0x7,%eax
  80128f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801292:	8b 55 08             	mov    0x8(%ebp),%edx
  801295:	89 df                	mov    %ebx,%edi
  801297:	89 de                	mov    %ebx,%esi
  801299:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80129b:	85 c0                	test   %eax,%eax
  80129d:	7e 28                	jle    8012c7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80129f:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8012aa:	00 
  8012ab:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  8012b2:	00 
  8012b3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012ba:	00 
  8012bb:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  8012c2:	e8 2f f3 ff ff       	call   8005f6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012c7:	83 c4 2c             	add    $0x2c,%esp
  8012ca:	5b                   	pop    %ebx
  8012cb:	5e                   	pop    %esi
  8012cc:	5f                   	pop    %edi
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    

008012cf <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	57                   	push   %edi
  8012d3:	56                   	push   %esi
  8012d4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012da:	b8 10 00 00 00       	mov    $0x10,%eax
  8012df:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e2:	89 cb                	mov    %ecx,%ebx
  8012e4:	89 cf                	mov    %ecx,%edi
  8012e6:	89 ce                	mov    %ecx,%esi
  8012e8:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  8012ea:	5b                   	pop    %ebx
  8012eb:	5e                   	pop    %esi
  8012ec:	5f                   	pop    %edi
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    

008012ef <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	57                   	push   %edi
  8012f3:	56                   	push   %esi
  8012f4:	53                   	push   %ebx
  8012f5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012fd:	b8 09 00 00 00       	mov    $0x9,%eax
  801302:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801305:	8b 55 08             	mov    0x8(%ebp),%edx
  801308:	89 df                	mov    %ebx,%edi
  80130a:	89 de                	mov    %ebx,%esi
  80130c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80130e:	85 c0                	test   %eax,%eax
  801310:	7e 28                	jle    80133a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801312:	89 44 24 10          	mov    %eax,0x10(%esp)
  801316:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80131d:	00 
  80131e:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  801325:	00 
  801326:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80132d:	00 
  80132e:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  801335:	e8 bc f2 ff ff       	call   8005f6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80133a:	83 c4 2c             	add    $0x2c,%esp
  80133d:	5b                   	pop    %ebx
  80133e:	5e                   	pop    %esi
  80133f:	5f                   	pop    %edi
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	57                   	push   %edi
  801346:	56                   	push   %esi
  801347:	53                   	push   %ebx
  801348:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80134b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801350:	b8 0a 00 00 00       	mov    $0xa,%eax
  801355:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801358:	8b 55 08             	mov    0x8(%ebp),%edx
  80135b:	89 df                	mov    %ebx,%edi
  80135d:	89 de                	mov    %ebx,%esi
  80135f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801361:	85 c0                	test   %eax,%eax
  801363:	7e 28                	jle    80138d <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801365:	89 44 24 10          	mov    %eax,0x10(%esp)
  801369:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801370:	00 
  801371:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  801378:	00 
  801379:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801380:	00 
  801381:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  801388:	e8 69 f2 ff ff       	call   8005f6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80138d:	83 c4 2c             	add    $0x2c,%esp
  801390:	5b                   	pop    %ebx
  801391:	5e                   	pop    %esi
  801392:	5f                   	pop    %edi
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    

00801395 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	57                   	push   %edi
  801399:	56                   	push   %esi
  80139a:	53                   	push   %ebx
  80139b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80139e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ae:	89 df                	mov    %ebx,%edi
  8013b0:	89 de                	mov    %ebx,%esi
  8013b2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	7e 28                	jle    8013e0 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013bc:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8013c3:	00 
  8013c4:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  8013cb:	00 
  8013cc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013d3:	00 
  8013d4:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  8013db:	e8 16 f2 ff ff       	call   8005f6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8013e0:	83 c4 2c             	add    $0x2c,%esp
  8013e3:	5b                   	pop    %ebx
  8013e4:	5e                   	pop    %esi
  8013e5:	5f                   	pop    %edi
  8013e6:	5d                   	pop    %ebp
  8013e7:	c3                   	ret    

008013e8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	57                   	push   %edi
  8013ec:	56                   	push   %esi
  8013ed:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ee:	be 00 00 00 00       	mov    $0x0,%esi
  8013f3:	b8 0d 00 00 00       	mov    $0xd,%eax
  8013f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801401:	8b 7d 14             	mov    0x14(%ebp),%edi
  801404:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801406:	5b                   	pop    %ebx
  801407:	5e                   	pop    %esi
  801408:	5f                   	pop    %edi
  801409:	5d                   	pop    %ebp
  80140a:	c3                   	ret    

0080140b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	57                   	push   %edi
  80140f:	56                   	push   %esi
  801410:	53                   	push   %ebx
  801411:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801414:	b9 00 00 00 00       	mov    $0x0,%ecx
  801419:	b8 0e 00 00 00       	mov    $0xe,%eax
  80141e:	8b 55 08             	mov    0x8(%ebp),%edx
  801421:	89 cb                	mov    %ecx,%ebx
  801423:	89 cf                	mov    %ecx,%edi
  801425:	89 ce                	mov    %ecx,%esi
  801427:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801429:	85 c0                	test   %eax,%eax
  80142b:	7e 28                	jle    801455 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80142d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801431:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  801438:	00 
  801439:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  801440:	00 
  801441:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801448:	00 
  801449:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  801450:	e8 a1 f1 ff ff       	call   8005f6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801455:	83 c4 2c             	add    $0x2c,%esp
  801458:	5b                   	pop    %ebx
  801459:	5e                   	pop    %esi
  80145a:	5f                   	pop    %edi
  80145b:	5d                   	pop    %ebp
  80145c:	c3                   	ret    

0080145d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	57                   	push   %edi
  801461:	56                   	push   %esi
  801462:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801463:	ba 00 00 00 00       	mov    $0x0,%edx
  801468:	b8 0f 00 00 00       	mov    $0xf,%eax
  80146d:	89 d1                	mov    %edx,%ecx
  80146f:	89 d3                	mov    %edx,%ebx
  801471:	89 d7                	mov    %edx,%edi
  801473:	89 d6                	mov    %edx,%esi
  801475:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801477:	5b                   	pop    %ebx
  801478:	5e                   	pop    %esi
  801479:	5f                   	pop    %edi
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	57                   	push   %edi
  801480:	56                   	push   %esi
  801481:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801482:	bb 00 00 00 00       	mov    $0x0,%ebx
  801487:	b8 11 00 00 00       	mov    $0x11,%eax
  80148c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80148f:	8b 55 08             	mov    0x8(%ebp),%edx
  801492:	89 df                	mov    %ebx,%edi
  801494:	89 de                	mov    %ebx,%esi
  801496:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  801498:	5b                   	pop    %ebx
  801499:	5e                   	pop    %esi
  80149a:	5f                   	pop    %edi
  80149b:	5d                   	pop    %ebp
  80149c:	c3                   	ret    

0080149d <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	57                   	push   %edi
  8014a1:	56                   	push   %esi
  8014a2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a8:	b8 12 00 00 00       	mov    $0x12,%eax
  8014ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b3:	89 df                	mov    %ebx,%edi
  8014b5:	89 de                	mov    %ebx,%esi
  8014b7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8014b9:	5b                   	pop    %ebx
  8014ba:	5e                   	pop    %esi
  8014bb:	5f                   	pop    %edi
  8014bc:	5d                   	pop    %ebp
  8014bd:	c3                   	ret    

008014be <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	57                   	push   %edi
  8014c2:	56                   	push   %esi
  8014c3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014c9:	b8 13 00 00 00       	mov    $0x13,%eax
  8014ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d1:	89 cb                	mov    %ecx,%ebx
  8014d3:	89 cf                	mov    %ecx,%edi
  8014d5:	89 ce                	mov    %ecx,%esi
  8014d7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8014d9:	5b                   	pop    %ebx
  8014da:	5e                   	pop    %esi
  8014db:	5f                   	pop    %edi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    

008014de <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8014e4:	83 3d b8 50 80 00 00 	cmpl   $0x0,0x8050b8
  8014eb:	75 7a                	jne    801567 <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8014ed:	e8 a5 fc ff ff       	call   801197 <sys_getenvid>
  8014f2:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014f9:	00 
  8014fa:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801501:	ee 
  801502:	89 04 24             	mov    %eax,(%esp)
  801505:	e8 cb fc ff ff       	call   8011d5 <sys_page_alloc>
  80150a:	85 c0                	test   %eax,%eax
  80150c:	79 20                	jns    80152e <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  80150e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801512:	c7 44 24 08 74 2d 80 	movl   $0x802d74,0x8(%esp)
  801519:	00 
  80151a:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  801521:	00 
  801522:	c7 04 24 62 31 80 00 	movl   $0x803162,(%esp)
  801529:	e8 c8 f0 ff ff       	call   8005f6 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  80152e:	e8 64 fc ff ff       	call   801197 <sys_getenvid>
  801533:	c7 44 24 04 71 15 80 	movl   $0x801571,0x4(%esp)
  80153a:	00 
  80153b:	89 04 24             	mov    %eax,(%esp)
  80153e:	e8 52 fe ff ff       	call   801395 <sys_env_set_pgfault_upcall>
  801543:	85 c0                	test   %eax,%eax
  801545:	79 20                	jns    801567 <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  801547:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80154b:	c7 44 24 08 70 31 80 	movl   $0x803170,0x8(%esp)
  801552:	00 
  801553:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  80155a:	00 
  80155b:	c7 04 24 62 31 80 00 	movl   $0x803162,(%esp)
  801562:	e8 8f f0 ff ff       	call   8005f6 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	a3 b8 50 80 00       	mov    %eax,0x8050b8
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801571:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801572:	a1 b8 50 80 00       	mov    0x8050b8,%eax
	call *%eax
  801577:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801579:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  80157c:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  801580:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801584:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  801587:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  80158b:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  80158d:	83 c4 08             	add    $0x8,%esp
	popal
  801590:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  801591:	83 c4 04             	add    $0x4,%esp
	popfl
  801594:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801595:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801596:	c3                   	ret    
  801597:	66 90                	xchg   %ax,%ax
  801599:	66 90                	xchg   %ax,%ax
  80159b:	66 90                	xchg   %ax,%ax
  80159d:	66 90                	xchg   %ax,%ax
  80159f:	90                   	nop

008015a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8015ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8015ae:	5d                   	pop    %ebp
  8015af:	c3                   	ret    

008015b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8015bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015c5:	5d                   	pop    %ebp
  8015c6:	c3                   	ret    

008015c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015d2:	89 c2                	mov    %eax,%edx
  8015d4:	c1 ea 16             	shr    $0x16,%edx
  8015d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015de:	f6 c2 01             	test   $0x1,%dl
  8015e1:	74 11                	je     8015f4 <fd_alloc+0x2d>
  8015e3:	89 c2                	mov    %eax,%edx
  8015e5:	c1 ea 0c             	shr    $0xc,%edx
  8015e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ef:	f6 c2 01             	test   $0x1,%dl
  8015f2:	75 09                	jne    8015fd <fd_alloc+0x36>
			*fd_store = fd;
  8015f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fb:	eb 17                	jmp    801614 <fd_alloc+0x4d>
  8015fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801602:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801607:	75 c9                	jne    8015d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801609:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80160f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80161c:	83 f8 1f             	cmp    $0x1f,%eax
  80161f:	77 36                	ja     801657 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801621:	c1 e0 0c             	shl    $0xc,%eax
  801624:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801629:	89 c2                	mov    %eax,%edx
  80162b:	c1 ea 16             	shr    $0x16,%edx
  80162e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801635:	f6 c2 01             	test   $0x1,%dl
  801638:	74 24                	je     80165e <fd_lookup+0x48>
  80163a:	89 c2                	mov    %eax,%edx
  80163c:	c1 ea 0c             	shr    $0xc,%edx
  80163f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801646:	f6 c2 01             	test   $0x1,%dl
  801649:	74 1a                	je     801665 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80164b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164e:	89 02                	mov    %eax,(%edx)
	return 0;
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
  801655:	eb 13                	jmp    80166a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801657:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165c:	eb 0c                	jmp    80166a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80165e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801663:	eb 05                	jmp    80166a <fd_lookup+0x54>
  801665:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 18             	sub    $0x18,%esp
  801672:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801675:	ba 00 00 00 00       	mov    $0x0,%edx
  80167a:	eb 13                	jmp    80168f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80167c:	39 08                	cmp    %ecx,(%eax)
  80167e:	75 0c                	jne    80168c <dev_lookup+0x20>
			*dev = devtab[i];
  801680:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801683:	89 01                	mov    %eax,(%ecx)
			return 0;
  801685:	b8 00 00 00 00       	mov    $0x0,%eax
  80168a:	eb 38                	jmp    8016c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80168c:	83 c2 01             	add    $0x1,%edx
  80168f:	8b 04 95 10 32 80 00 	mov    0x803210(,%edx,4),%eax
  801696:	85 c0                	test   %eax,%eax
  801698:	75 e2                	jne    80167c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80169a:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80169f:	8b 40 48             	mov    0x48(%eax),%eax
  8016a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016aa:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  8016b1:	e8 39 f0 ff ff       	call   8006ef <cprintf>
	*dev = 0;
  8016b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	56                   	push   %esi
  8016ca:	53                   	push   %ebx
  8016cb:	83 ec 20             	sub    $0x20,%esp
  8016ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8016d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016e4:	89 04 24             	mov    %eax,(%esp)
  8016e7:	e8 2a ff ff ff       	call   801616 <fd_lookup>
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	78 05                	js     8016f5 <fd_close+0x2f>
	    || fd != fd2)
  8016f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016f3:	74 0c                	je     801701 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8016f5:	84 db                	test   %bl,%bl
  8016f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fc:	0f 44 c2             	cmove  %edx,%eax
  8016ff:	eb 3f                	jmp    801740 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801701:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801704:	89 44 24 04          	mov    %eax,0x4(%esp)
  801708:	8b 06                	mov    (%esi),%eax
  80170a:	89 04 24             	mov    %eax,(%esp)
  80170d:	e8 5a ff ff ff       	call   80166c <dev_lookup>
  801712:	89 c3                	mov    %eax,%ebx
  801714:	85 c0                	test   %eax,%eax
  801716:	78 16                	js     80172e <fd_close+0x68>
		if (dev->dev_close)
  801718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80171e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801723:	85 c0                	test   %eax,%eax
  801725:	74 07                	je     80172e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801727:	89 34 24             	mov    %esi,(%esp)
  80172a:	ff d0                	call   *%eax
  80172c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80172e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801732:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801739:	e8 3e fb ff ff       	call   80127c <sys_page_unmap>
	return r;
  80173e:	89 d8                	mov    %ebx,%eax
}
  801740:	83 c4 20             	add    $0x20,%esp
  801743:	5b                   	pop    %ebx
  801744:	5e                   	pop    %esi
  801745:	5d                   	pop    %ebp
  801746:	c3                   	ret    

00801747 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80174d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801750:	89 44 24 04          	mov    %eax,0x4(%esp)
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	89 04 24             	mov    %eax,(%esp)
  80175a:	e8 b7 fe ff ff       	call   801616 <fd_lookup>
  80175f:	89 c2                	mov    %eax,%edx
  801761:	85 d2                	test   %edx,%edx
  801763:	78 13                	js     801778 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801765:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80176c:	00 
  80176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801770:	89 04 24             	mov    %eax,(%esp)
  801773:	e8 4e ff ff ff       	call   8016c6 <fd_close>
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <close_all>:

void
close_all(void)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	53                   	push   %ebx
  80177e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801781:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801786:	89 1c 24             	mov    %ebx,(%esp)
  801789:	e8 b9 ff ff ff       	call   801747 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80178e:	83 c3 01             	add    $0x1,%ebx
  801791:	83 fb 20             	cmp    $0x20,%ebx
  801794:	75 f0                	jne    801786 <close_all+0xc>
		close(i);
}
  801796:	83 c4 14             	add    $0x14,%esp
  801799:	5b                   	pop    %ebx
  80179a:	5d                   	pop    %ebp
  80179b:	c3                   	ret    

0080179c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	57                   	push   %edi
  8017a0:	56                   	push   %esi
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 04 24             	mov    %eax,(%esp)
  8017b2:	e8 5f fe ff ff       	call   801616 <fd_lookup>
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	85 d2                	test   %edx,%edx
  8017bb:	0f 88 e1 00 00 00    	js     8018a2 <dup+0x106>
		return r;
	close(newfdnum);
  8017c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c4:	89 04 24             	mov    %eax,(%esp)
  8017c7:	e8 7b ff ff ff       	call   801747 <close>

	newfd = INDEX2FD(newfdnum);
  8017cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017cf:	c1 e3 0c             	shl    $0xc,%ebx
  8017d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8017d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017db:	89 04 24             	mov    %eax,(%esp)
  8017de:	e8 cd fd ff ff       	call   8015b0 <fd2data>
  8017e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8017e5:	89 1c 24             	mov    %ebx,(%esp)
  8017e8:	e8 c3 fd ff ff       	call   8015b0 <fd2data>
  8017ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017ef:	89 f0                	mov    %esi,%eax
  8017f1:	c1 e8 16             	shr    $0x16,%eax
  8017f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017fb:	a8 01                	test   $0x1,%al
  8017fd:	74 43                	je     801842 <dup+0xa6>
  8017ff:	89 f0                	mov    %esi,%eax
  801801:	c1 e8 0c             	shr    $0xc,%eax
  801804:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80180b:	f6 c2 01             	test   $0x1,%dl
  80180e:	74 32                	je     801842 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801810:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801817:	25 07 0e 00 00       	and    $0xe07,%eax
  80181c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801820:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801824:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80182b:	00 
  80182c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801830:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801837:	e8 ed f9 ff ff       	call   801229 <sys_page_map>
  80183c:	89 c6                	mov    %eax,%esi
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 3e                	js     801880 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801845:	89 c2                	mov    %eax,%edx
  801847:	c1 ea 0c             	shr    $0xc,%edx
  80184a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801851:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801857:	89 54 24 10          	mov    %edx,0x10(%esp)
  80185b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80185f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801866:	00 
  801867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801872:	e8 b2 f9 ff ff       	call   801229 <sys_page_map>
  801877:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801879:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80187c:	85 f6                	test   %esi,%esi
  80187e:	79 22                	jns    8018a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801880:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801884:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80188b:	e8 ec f9 ff ff       	call   80127c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801890:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801894:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80189b:	e8 dc f9 ff ff       	call   80127c <sys_page_unmap>
	return r;
  8018a0:	89 f0                	mov    %esi,%eax
}
  8018a2:	83 c4 3c             	add    $0x3c,%esp
  8018a5:	5b                   	pop    %ebx
  8018a6:	5e                   	pop    %esi
  8018a7:	5f                   	pop    %edi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 24             	sub    $0x24,%esp
  8018b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bb:	89 1c 24             	mov    %ebx,(%esp)
  8018be:	e8 53 fd ff ff       	call   801616 <fd_lookup>
  8018c3:	89 c2                	mov    %eax,%edx
  8018c5:	85 d2                	test   %edx,%edx
  8018c7:	78 6d                	js     801936 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d3:	8b 00                	mov    (%eax),%eax
  8018d5:	89 04 24             	mov    %eax,(%esp)
  8018d8:	e8 8f fd ff ff       	call   80166c <dev_lookup>
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 55                	js     801936 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e4:	8b 50 08             	mov    0x8(%eax),%edx
  8018e7:	83 e2 03             	and    $0x3,%edx
  8018ea:	83 fa 01             	cmp    $0x1,%edx
  8018ed:	75 23                	jne    801912 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018ef:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8018f4:	8b 40 48             	mov    0x48(%eax),%eax
  8018f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ff:	c7 04 24 d5 31 80 00 	movl   $0x8031d5,(%esp)
  801906:	e8 e4 ed ff ff       	call   8006ef <cprintf>
		return -E_INVAL;
  80190b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801910:	eb 24                	jmp    801936 <read+0x8c>
	}
	if (!dev->dev_read)
  801912:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801915:	8b 52 08             	mov    0x8(%edx),%edx
  801918:	85 d2                	test   %edx,%edx
  80191a:	74 15                	je     801931 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80191c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801926:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80192a:	89 04 24             	mov    %eax,(%esp)
  80192d:	ff d2                	call   *%edx
  80192f:	eb 05                	jmp    801936 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801931:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801936:	83 c4 24             	add    $0x24,%esp
  801939:	5b                   	pop    %ebx
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	57                   	push   %edi
  801940:	56                   	push   %esi
  801941:	53                   	push   %ebx
  801942:	83 ec 1c             	sub    $0x1c,%esp
  801945:	8b 7d 08             	mov    0x8(%ebp),%edi
  801948:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80194b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801950:	eb 23                	jmp    801975 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801952:	89 f0                	mov    %esi,%eax
  801954:	29 d8                	sub    %ebx,%eax
  801956:	89 44 24 08          	mov    %eax,0x8(%esp)
  80195a:	89 d8                	mov    %ebx,%eax
  80195c:	03 45 0c             	add    0xc(%ebp),%eax
  80195f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801963:	89 3c 24             	mov    %edi,(%esp)
  801966:	e8 3f ff ff ff       	call   8018aa <read>
		if (m < 0)
  80196b:	85 c0                	test   %eax,%eax
  80196d:	78 10                	js     80197f <readn+0x43>
			return m;
		if (m == 0)
  80196f:	85 c0                	test   %eax,%eax
  801971:	74 0a                	je     80197d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801973:	01 c3                	add    %eax,%ebx
  801975:	39 f3                	cmp    %esi,%ebx
  801977:	72 d9                	jb     801952 <readn+0x16>
  801979:	89 d8                	mov    %ebx,%eax
  80197b:	eb 02                	jmp    80197f <readn+0x43>
  80197d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80197f:	83 c4 1c             	add    $0x1c,%esp
  801982:	5b                   	pop    %ebx
  801983:	5e                   	pop    %esi
  801984:	5f                   	pop    %edi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    

00801987 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	53                   	push   %ebx
  80198b:	83 ec 24             	sub    $0x24,%esp
  80198e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801991:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801994:	89 44 24 04          	mov    %eax,0x4(%esp)
  801998:	89 1c 24             	mov    %ebx,(%esp)
  80199b:	e8 76 fc ff ff       	call   801616 <fd_lookup>
  8019a0:	89 c2                	mov    %eax,%edx
  8019a2:	85 d2                	test   %edx,%edx
  8019a4:	78 68                	js     801a0e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b0:	8b 00                	mov    (%eax),%eax
  8019b2:	89 04 24             	mov    %eax,(%esp)
  8019b5:	e8 b2 fc ff ff       	call   80166c <dev_lookup>
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	78 50                	js     801a0e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019c5:	75 23                	jne    8019ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019c7:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8019cc:	8b 40 48             	mov    0x48(%eax),%eax
  8019cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d7:	c7 04 24 f1 31 80 00 	movl   $0x8031f1,(%esp)
  8019de:	e8 0c ed ff ff       	call   8006ef <cprintf>
		return -E_INVAL;
  8019e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e8:	eb 24                	jmp    801a0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8019f0:	85 d2                	test   %edx,%edx
  8019f2:	74 15                	je     801a09 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a02:	89 04 24             	mov    %eax,(%esp)
  801a05:	ff d2                	call   *%edx
  801a07:	eb 05                	jmp    801a0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a0e:	83 c4 24             	add    $0x24,%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    

00801a14 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a1a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	89 04 24             	mov    %eax,(%esp)
  801a27:	e8 ea fb ff ff       	call   801616 <fd_lookup>
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 0e                	js     801a3e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a36:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	53                   	push   %ebx
  801a44:	83 ec 24             	sub    $0x24,%esp
  801a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a51:	89 1c 24             	mov    %ebx,(%esp)
  801a54:	e8 bd fb ff ff       	call   801616 <fd_lookup>
  801a59:	89 c2                	mov    %eax,%edx
  801a5b:	85 d2                	test   %edx,%edx
  801a5d:	78 61                	js     801ac0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a62:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a69:	8b 00                	mov    (%eax),%eax
  801a6b:	89 04 24             	mov    %eax,(%esp)
  801a6e:	e8 f9 fb ff ff       	call   80166c <dev_lookup>
  801a73:	85 c0                	test   %eax,%eax
  801a75:	78 49                	js     801ac0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a7e:	75 23                	jne    801aa3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a80:	a1 b4 50 80 00       	mov    0x8050b4,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a85:	8b 40 48             	mov    0x48(%eax),%eax
  801a88:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a90:	c7 04 24 b4 31 80 00 	movl   $0x8031b4,(%esp)
  801a97:	e8 53 ec ff ff       	call   8006ef <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aa1:	eb 1d                	jmp    801ac0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801aa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa6:	8b 52 18             	mov    0x18(%edx),%edx
  801aa9:	85 d2                	test   %edx,%edx
  801aab:	74 0e                	je     801abb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801aad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ab4:	89 04 24             	mov    %eax,(%esp)
  801ab7:	ff d2                	call   *%edx
  801ab9:	eb 05                	jmp    801ac0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801abb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801ac0:	83 c4 24             	add    $0x24,%esp
  801ac3:	5b                   	pop    %ebx
  801ac4:	5d                   	pop    %ebp
  801ac5:	c3                   	ret    

00801ac6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	53                   	push   %ebx
  801aca:	83 ec 24             	sub    $0x24,%esp
  801acd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ad0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	89 04 24             	mov    %eax,(%esp)
  801add:	e8 34 fb ff ff       	call   801616 <fd_lookup>
  801ae2:	89 c2                	mov    %eax,%edx
  801ae4:	85 d2                	test   %edx,%edx
  801ae6:	78 52                	js     801b3a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af2:	8b 00                	mov    (%eax),%eax
  801af4:	89 04 24             	mov    %eax,(%esp)
  801af7:	e8 70 fb ff ff       	call   80166c <dev_lookup>
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 3a                	js     801b3a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b03:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b07:	74 2c                	je     801b35 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b09:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b0c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b13:	00 00 00 
	stat->st_isdir = 0;
  801b16:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b1d:	00 00 00 
	stat->st_dev = dev;
  801b20:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b2d:	89 14 24             	mov    %edx,(%esp)
  801b30:	ff 50 14             	call   *0x14(%eax)
  801b33:	eb 05                	jmp    801b3a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b3a:	83 c4 24             	add    $0x24,%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    

00801b40 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	56                   	push   %esi
  801b44:	53                   	push   %ebx
  801b45:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b4f:	00 
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	89 04 24             	mov    %eax,(%esp)
  801b56:	e8 99 02 00 00       	call   801df4 <open>
  801b5b:	89 c3                	mov    %eax,%ebx
  801b5d:	85 db                	test   %ebx,%ebx
  801b5f:	78 1b                	js     801b7c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b68:	89 1c 24             	mov    %ebx,(%esp)
  801b6b:	e8 56 ff ff ff       	call   801ac6 <fstat>
  801b70:	89 c6                	mov    %eax,%esi
	close(fd);
  801b72:	89 1c 24             	mov    %ebx,(%esp)
  801b75:	e8 cd fb ff ff       	call   801747 <close>
	return r;
  801b7a:	89 f0                	mov    %esi,%eax
}
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    

00801b83 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	56                   	push   %esi
  801b87:	53                   	push   %ebx
  801b88:	83 ec 10             	sub    $0x10,%esp
  801b8b:	89 c6                	mov    %eax,%esi
  801b8d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b8f:	83 3d ac 50 80 00 00 	cmpl   $0x0,0x8050ac
  801b96:	75 11                	jne    801ba9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b9f:	e8 2b 0e 00 00       	call   8029cf <ipc_find_env>
  801ba4:	a3 ac 50 80 00       	mov    %eax,0x8050ac
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ba9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bb0:	00 
  801bb1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801bb8:	00 
  801bb9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bbd:	a1 ac 50 80 00       	mov    0x8050ac,%eax
  801bc2:	89 04 24             	mov    %eax,(%esp)
  801bc5:	e8 9e 0d 00 00       	call   802968 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bd1:	00 
  801bd2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bdd:	e8 1e 0d 00 00       	call   802900 <ipc_recv>
}
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	5b                   	pop    %ebx
  801be6:	5e                   	pop    %esi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    

00801be9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c02:	ba 00 00 00 00       	mov    $0x0,%edx
  801c07:	b8 02 00 00 00       	mov    $0x2,%eax
  801c0c:	e8 72 ff ff ff       	call   801b83 <fsipc>
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c24:	ba 00 00 00 00       	mov    $0x0,%edx
  801c29:	b8 06 00 00 00       	mov    $0x6,%eax
  801c2e:	e8 50 ff ff ff       	call   801b83 <fsipc>
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	53                   	push   %ebx
  801c39:	83 ec 14             	sub    $0x14,%esp
  801c3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	8b 40 0c             	mov    0xc(%eax),%eax
  801c45:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c54:	e8 2a ff ff ff       	call   801b83 <fsipc>
  801c59:	89 c2                	mov    %eax,%edx
  801c5b:	85 d2                	test   %edx,%edx
  801c5d:	78 2b                	js     801c8a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c5f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c66:	00 
  801c67:	89 1c 24             	mov    %ebx,(%esp)
  801c6a:	e8 f8 f0 ff ff       	call   800d67 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c6f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c74:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c7a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c7f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8a:	83 c4 14             	add    $0x14,%esp
  801c8d:	5b                   	pop    %ebx
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    

00801c90 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	53                   	push   %ebx
  801c94:	83 ec 14             	sub    $0x14,%esp
  801c97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  801c9a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801ca0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801ca5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  801cab:	8b 52 0c             	mov    0xc(%edx),%edx
  801cae:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = count;
  801cb4:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801cb9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc4:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801ccb:	e8 34 f2 ff ff       	call   800f04 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801cd0:	c7 44 24 04 08 60 80 	movl   $0x806008,0x4(%esp)
  801cd7:	00 
  801cd8:	c7 04 24 24 32 80 00 	movl   $0x803224,(%esp)
  801cdf:	e8 0b ea ff ff       	call   8006ef <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce9:	b8 04 00 00 00       	mov    $0x4,%eax
  801cee:	e8 90 fe ff ff       	call   801b83 <fsipc>
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	78 53                	js     801d4a <devfile_write+0xba>
		return r;
	assert(r <= n);
  801cf7:	39 c3                	cmp    %eax,%ebx
  801cf9:	73 24                	jae    801d1f <devfile_write+0x8f>
  801cfb:	c7 44 24 0c 29 32 80 	movl   $0x803229,0xc(%esp)
  801d02:	00 
  801d03:	c7 44 24 08 30 32 80 	movl   $0x803230,0x8(%esp)
  801d0a:	00 
  801d0b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801d12:	00 
  801d13:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801d1a:	e8 d7 e8 ff ff       	call   8005f6 <_panic>
	assert(r <= PGSIZE);
  801d1f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d24:	7e 24                	jle    801d4a <devfile_write+0xba>
  801d26:	c7 44 24 0c 50 32 80 	movl   $0x803250,0xc(%esp)
  801d2d:	00 
  801d2e:	c7 44 24 08 30 32 80 	movl   $0x803230,0x8(%esp)
  801d35:	00 
  801d36:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801d3d:	00 
  801d3e:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801d45:	e8 ac e8 ff ff       	call   8005f6 <_panic>
	return r;
}
  801d4a:	83 c4 14             	add    $0x14,%esp
  801d4d:	5b                   	pop    %ebx
  801d4e:	5d                   	pop    %ebp
  801d4f:	c3                   	ret    

00801d50 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	56                   	push   %esi
  801d54:	53                   	push   %ebx
  801d55:	83 ec 10             	sub    $0x10,%esp
  801d58:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d61:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d66:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d71:	b8 03 00 00 00       	mov    $0x3,%eax
  801d76:	e8 08 fe ff ff       	call   801b83 <fsipc>
  801d7b:	89 c3                	mov    %eax,%ebx
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	78 6a                	js     801deb <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d81:	39 c6                	cmp    %eax,%esi
  801d83:	73 24                	jae    801da9 <devfile_read+0x59>
  801d85:	c7 44 24 0c 29 32 80 	movl   $0x803229,0xc(%esp)
  801d8c:	00 
  801d8d:	c7 44 24 08 30 32 80 	movl   $0x803230,0x8(%esp)
  801d94:	00 
  801d95:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d9c:	00 
  801d9d:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801da4:	e8 4d e8 ff ff       	call   8005f6 <_panic>
	assert(r <= PGSIZE);
  801da9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dae:	7e 24                	jle    801dd4 <devfile_read+0x84>
  801db0:	c7 44 24 0c 50 32 80 	movl   $0x803250,0xc(%esp)
  801db7:	00 
  801db8:	c7 44 24 08 30 32 80 	movl   $0x803230,0x8(%esp)
  801dbf:	00 
  801dc0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801dc7:	00 
  801dc8:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  801dcf:	e8 22 e8 ff ff       	call   8005f6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dd4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd8:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ddf:	00 
  801de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de3:	89 04 24             	mov    %eax,(%esp)
  801de6:	e8 19 f1 ff ff       	call   800f04 <memmove>
	return r;
}
  801deb:	89 d8                	mov    %ebx,%eax
  801ded:	83 c4 10             	add    $0x10,%esp
  801df0:	5b                   	pop    %ebx
  801df1:	5e                   	pop    %esi
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    

00801df4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	53                   	push   %ebx
  801df8:	83 ec 24             	sub    $0x24,%esp
  801dfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801dfe:	89 1c 24             	mov    %ebx,(%esp)
  801e01:	e8 2a ef ff ff       	call   800d30 <strlen>
  801e06:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e0b:	7f 60                	jg     801e6d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e10:	89 04 24             	mov    %eax,(%esp)
  801e13:	e8 af f7 ff ff       	call   8015c7 <fd_alloc>
  801e18:	89 c2                	mov    %eax,%edx
  801e1a:	85 d2                	test   %edx,%edx
  801e1c:	78 54                	js     801e72 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e22:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e29:	e8 39 ef ff ff       	call   800d67 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e31:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e39:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3e:	e8 40 fd ff ff       	call   801b83 <fsipc>
  801e43:	89 c3                	mov    %eax,%ebx
  801e45:	85 c0                	test   %eax,%eax
  801e47:	79 17                	jns    801e60 <open+0x6c>
		fd_close(fd, 0);
  801e49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e50:	00 
  801e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e54:	89 04 24             	mov    %eax,(%esp)
  801e57:	e8 6a f8 ff ff       	call   8016c6 <fd_close>
		return r;
  801e5c:	89 d8                	mov    %ebx,%eax
  801e5e:	eb 12                	jmp    801e72 <open+0x7e>
	}

	return fd2num(fd);
  801e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e63:	89 04 24             	mov    %eax,(%esp)
  801e66:	e8 35 f7 ff ff       	call   8015a0 <fd2num>
  801e6b:	eb 05                	jmp    801e72 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801e6d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801e72:	83 c4 24             	add    $0x24,%esp
  801e75:	5b                   	pop    %ebx
  801e76:	5d                   	pop    %ebp
  801e77:	c3                   	ret    

00801e78 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e83:	b8 08 00 00 00       	mov    $0x8,%eax
  801e88:	e8 f6 fc ff ff       	call   801b83 <fsipc>
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <evict>:

int evict(void)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801e95:	c7 04 24 5c 32 80 00 	movl   $0x80325c,(%esp)
  801e9c:	e8 4e e8 ff ff       	call   8006ef <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801ea1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea6:	b8 09 00 00 00       	mov    $0x9,%eax
  801eab:	e8 d3 fc ff ff       	call   801b83 <fsipc>
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    
  801eb2:	66 90                	xchg   %ax,%ax
  801eb4:	66 90                	xchg   %ax,%ax
  801eb6:	66 90                	xchg   %ax,%ax
  801eb8:	66 90                	xchg   %ax,%ax
  801eba:	66 90                	xchg   %ax,%ax
  801ebc:	66 90                	xchg   %ax,%ax
  801ebe:	66 90                	xchg   %ax,%ax

00801ec0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ec6:	c7 44 24 04 75 32 80 	movl   $0x803275,0x4(%esp)
  801ecd:	00 
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	89 04 24             	mov    %eax,(%esp)
  801ed4:	e8 8e ee ff ff       	call   800d67 <strcpy>
	return 0;
}
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 14             	sub    $0x14,%esp
  801ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801eea:	89 1c 24             	mov    %ebx,(%esp)
  801eed:	e8 15 0b 00 00       	call   802a07 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801ef2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801ef7:	83 f8 01             	cmp    $0x1,%eax
  801efa:	75 0d                	jne    801f09 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801efc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801eff:	89 04 24             	mov    %eax,(%esp)
  801f02:	e8 29 03 00 00       	call   802230 <nsipc_close>
  801f07:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801f09:	89 d0                	mov    %edx,%eax
  801f0b:	83 c4 14             	add    $0x14,%esp
  801f0e:	5b                   	pop    %ebx
  801f0f:	5d                   	pop    %ebp
  801f10:	c3                   	ret    

00801f11 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f17:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f1e:	00 
  801f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	8b 40 0c             	mov    0xc(%eax),%eax
  801f33:	89 04 24             	mov    %eax,(%esp)
  801f36:	e8 f0 03 00 00       	call   80232b <nsipc_send>
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f43:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f4a:	00 
  801f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5f:	89 04 24             	mov    %eax,(%esp)
  801f62:	e8 44 03 00 00       	call   8022ab <nsipc_recv>
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f6f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f72:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f76:	89 04 24             	mov    %eax,(%esp)
  801f79:	e8 98 f6 ff ff       	call   801616 <fd_lookup>
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 17                	js     801f99 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f85:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f8b:	39 08                	cmp    %ecx,(%eax)
  801f8d:	75 05                	jne    801f94 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f92:	eb 05                	jmp    801f99 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801f94:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	56                   	push   %esi
  801f9f:	53                   	push   %ebx
  801fa0:	83 ec 20             	sub    $0x20,%esp
  801fa3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa8:	89 04 24             	mov    %eax,(%esp)
  801fab:	e8 17 f6 ff ff       	call   8015c7 <fd_alloc>
  801fb0:	89 c3                	mov    %eax,%ebx
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	78 21                	js     801fd7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fb6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fbd:	00 
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fcc:	e8 04 f2 ff ff       	call   8011d5 <sys_page_alloc>
  801fd1:	89 c3                	mov    %eax,%ebx
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	79 0c                	jns    801fe3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801fd7:	89 34 24             	mov    %esi,(%esp)
  801fda:	e8 51 02 00 00       	call   802230 <nsipc_close>
		return r;
  801fdf:	89 d8                	mov    %ebx,%eax
  801fe1:	eb 20                	jmp    802003 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801fe3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801ff8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801ffb:	89 14 24             	mov    %edx,(%esp)
  801ffe:	e8 9d f5 ff ff       	call   8015a0 <fd2num>
}
  802003:	83 c4 20             	add    $0x20,%esp
  802006:	5b                   	pop    %ebx
  802007:	5e                   	pop    %esi
  802008:	5d                   	pop    %ebp
  802009:	c3                   	ret    

0080200a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	e8 51 ff ff ff       	call   801f69 <fd2sockid>
		return r;
  802018:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80201a:	85 c0                	test   %eax,%eax
  80201c:	78 23                	js     802041 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80201e:	8b 55 10             	mov    0x10(%ebp),%edx
  802021:	89 54 24 08          	mov    %edx,0x8(%esp)
  802025:	8b 55 0c             	mov    0xc(%ebp),%edx
  802028:	89 54 24 04          	mov    %edx,0x4(%esp)
  80202c:	89 04 24             	mov    %eax,(%esp)
  80202f:	e8 45 01 00 00       	call   802179 <nsipc_accept>
		return r;
  802034:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802036:	85 c0                	test   %eax,%eax
  802038:	78 07                	js     802041 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80203a:	e8 5c ff ff ff       	call   801f9b <alloc_sockfd>
  80203f:	89 c1                	mov    %eax,%ecx
}
  802041:	89 c8                	mov    %ecx,%eax
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	e8 16 ff ff ff       	call   801f69 <fd2sockid>
  802053:	89 c2                	mov    %eax,%edx
  802055:	85 d2                	test   %edx,%edx
  802057:	78 16                	js     80206f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802059:	8b 45 10             	mov    0x10(%ebp),%eax
  80205c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802060:	8b 45 0c             	mov    0xc(%ebp),%eax
  802063:	89 44 24 04          	mov    %eax,0x4(%esp)
  802067:	89 14 24             	mov    %edx,(%esp)
  80206a:	e8 60 01 00 00       	call   8021cf <nsipc_bind>
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <shutdown>:

int
shutdown(int s, int how)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	e8 ea fe ff ff       	call   801f69 <fd2sockid>
  80207f:	89 c2                	mov    %eax,%edx
  802081:	85 d2                	test   %edx,%edx
  802083:	78 0f                	js     802094 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802085:	8b 45 0c             	mov    0xc(%ebp),%eax
  802088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208c:	89 14 24             	mov    %edx,(%esp)
  80208f:	e8 7a 01 00 00       	call   80220e <nsipc_shutdown>
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	e8 c5 fe ff ff       	call   801f69 <fd2sockid>
  8020a4:	89 c2                	mov    %eax,%edx
  8020a6:	85 d2                	test   %edx,%edx
  8020a8:	78 16                	js     8020c0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8020aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b8:	89 14 24             	mov    %edx,(%esp)
  8020bb:	e8 8a 01 00 00       	call   80224a <nsipc_connect>
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <listen>:

int
listen(int s, int backlog)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	e8 99 fe ff ff       	call   801f69 <fd2sockid>
  8020d0:	89 c2                	mov    %eax,%edx
  8020d2:	85 d2                	test   %edx,%edx
  8020d4:	78 0f                	js     8020e5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8020d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020dd:	89 14 24             	mov    %edx,(%esp)
  8020e0:	e8 a4 01 00 00       	call   802289 <nsipc_listen>
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	89 04 24             	mov    %eax,(%esp)
  802101:	e8 98 02 00 00       	call   80239e <nsipc_socket>
  802106:	89 c2                	mov    %eax,%edx
  802108:	85 d2                	test   %edx,%edx
  80210a:	78 05                	js     802111 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80210c:	e8 8a fe ff ff       	call   801f9b <alloc_sockfd>
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	53                   	push   %ebx
  802117:	83 ec 14             	sub    $0x14,%esp
  80211a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80211c:	83 3d b0 50 80 00 00 	cmpl   $0x0,0x8050b0
  802123:	75 11                	jne    802136 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802125:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80212c:	e8 9e 08 00 00       	call   8029cf <ipc_find_env>
  802131:	a3 b0 50 80 00       	mov    %eax,0x8050b0
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802136:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80213d:	00 
  80213e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802145:	00 
  802146:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80214a:	a1 b0 50 80 00       	mov    0x8050b0,%eax
  80214f:	89 04 24             	mov    %eax,(%esp)
  802152:	e8 11 08 00 00       	call   802968 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802157:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80215e:	00 
  80215f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802166:	00 
  802167:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80216e:	e8 8d 07 00 00       	call   802900 <ipc_recv>
}
  802173:	83 c4 14             	add    $0x14,%esp
  802176:	5b                   	pop    %ebx
  802177:	5d                   	pop    %ebp
  802178:	c3                   	ret    

00802179 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	56                   	push   %esi
  80217d:	53                   	push   %ebx
  80217e:	83 ec 10             	sub    $0x10,%esp
  802181:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80218c:	8b 06                	mov    (%esi),%eax
  80218e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802193:	b8 01 00 00 00       	mov    $0x1,%eax
  802198:	e8 76 ff ff ff       	call   802113 <nsipc>
  80219d:	89 c3                	mov    %eax,%ebx
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	78 23                	js     8021c6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021a3:	a1 10 70 80 00       	mov    0x807010,%eax
  8021a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021ac:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8021b3:	00 
  8021b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b7:	89 04 24             	mov    %eax,(%esp)
  8021ba:	e8 45 ed ff ff       	call   800f04 <memmove>
		*addrlen = ret->ret_addrlen;
  8021bf:	a1 10 70 80 00       	mov    0x807010,%eax
  8021c4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8021c6:	89 d8                	mov    %ebx,%eax
  8021c8:	83 c4 10             	add    $0x10,%esp
  8021cb:	5b                   	pop    %ebx
  8021cc:	5e                   	pop    %esi
  8021cd:	5d                   	pop    %ebp
  8021ce:	c3                   	ret    

008021cf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	53                   	push   %ebx
  8021d3:	83 ec 14             	sub    $0x14,%esp
  8021d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021e1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ec:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021f3:	e8 0c ed ff ff       	call   800f04 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021f8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021fe:	b8 02 00 00 00       	mov    $0x2,%eax
  802203:	e8 0b ff ff ff       	call   802113 <nsipc>
}
  802208:	83 c4 14             	add    $0x14,%esp
  80220b:	5b                   	pop    %ebx
  80220c:	5d                   	pop    %ebp
  80220d:	c3                   	ret    

0080220e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80221c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802224:	b8 03 00 00 00       	mov    $0x3,%eax
  802229:	e8 e5 fe ff ff       	call   802113 <nsipc>
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <nsipc_close>:

int
nsipc_close(int s)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80223e:	b8 04 00 00 00       	mov    $0x4,%eax
  802243:	e8 cb fe ff ff       	call   802113 <nsipc>
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	53                   	push   %ebx
  80224e:	83 ec 14             	sub    $0x14,%esp
  802251:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80225c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802260:	8b 45 0c             	mov    0xc(%ebp),%eax
  802263:	89 44 24 04          	mov    %eax,0x4(%esp)
  802267:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80226e:	e8 91 ec ff ff       	call   800f04 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802273:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802279:	b8 05 00 00 00       	mov    $0x5,%eax
  80227e:	e8 90 fe ff ff       	call   802113 <nsipc>
}
  802283:	83 c4 14             	add    $0x14,%esp
  802286:	5b                   	pop    %ebx
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    

00802289 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80229f:	b8 06 00 00 00       	mov    $0x6,%eax
  8022a4:	e8 6a fe ff ff       	call   802113 <nsipc>
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	56                   	push   %esi
  8022af:	53                   	push   %ebx
  8022b0:	83 ec 10             	sub    $0x10,%esp
  8022b3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022be:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022cc:	b8 07 00 00 00       	mov    $0x7,%eax
  8022d1:	e8 3d fe ff ff       	call   802113 <nsipc>
  8022d6:	89 c3                	mov    %eax,%ebx
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	78 46                	js     802322 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022dc:	39 f0                	cmp    %esi,%eax
  8022de:	7f 07                	jg     8022e7 <nsipc_recv+0x3c>
  8022e0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022e5:	7e 24                	jle    80230b <nsipc_recv+0x60>
  8022e7:	c7 44 24 0c 81 32 80 	movl   $0x803281,0xc(%esp)
  8022ee:	00 
  8022ef:	c7 44 24 08 30 32 80 	movl   $0x803230,0x8(%esp)
  8022f6:	00 
  8022f7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8022fe:	00 
  8022ff:	c7 04 24 96 32 80 00 	movl   $0x803296,(%esp)
  802306:	e8 eb e2 ff ff       	call   8005f6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80230b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80230f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802316:	00 
  802317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231a:	89 04 24             	mov    %eax,(%esp)
  80231d:	e8 e2 eb ff ff       	call   800f04 <memmove>
	}

	return r;
}
  802322:	89 d8                	mov    %ebx,%eax
  802324:	83 c4 10             	add    $0x10,%esp
  802327:	5b                   	pop    %ebx
  802328:	5e                   	pop    %esi
  802329:	5d                   	pop    %ebp
  80232a:	c3                   	ret    

0080232b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	53                   	push   %ebx
  80232f:	83 ec 14             	sub    $0x14,%esp
  802332:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80233d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802343:	7e 24                	jle    802369 <nsipc_send+0x3e>
  802345:	c7 44 24 0c a2 32 80 	movl   $0x8032a2,0xc(%esp)
  80234c:	00 
  80234d:	c7 44 24 08 30 32 80 	movl   $0x803230,0x8(%esp)
  802354:	00 
  802355:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80235c:	00 
  80235d:	c7 04 24 96 32 80 00 	movl   $0x803296,(%esp)
  802364:	e8 8d e2 ff ff       	call   8005f6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802369:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80236d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802370:	89 44 24 04          	mov    %eax,0x4(%esp)
  802374:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80237b:	e8 84 eb ff ff       	call   800f04 <memmove>
	nsipcbuf.send.req_size = size;
  802380:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802386:	8b 45 14             	mov    0x14(%ebp),%eax
  802389:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80238e:	b8 08 00 00 00       	mov    $0x8,%eax
  802393:	e8 7b fd ff ff       	call   802113 <nsipc>
}
  802398:	83 c4 14             	add    $0x14,%esp
  80239b:	5b                   	pop    %ebx
  80239c:	5d                   	pop    %ebp
  80239d:	c3                   	ret    

0080239e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023af:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8023c1:	e8 4d fd ff ff       	call   802113 <nsipc>
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	56                   	push   %esi
  8023cc:	53                   	push   %ebx
  8023cd:	83 ec 10             	sub    $0x10,%esp
  8023d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	89 04 24             	mov    %eax,(%esp)
  8023d9:	e8 d2 f1 ff ff       	call   8015b0 <fd2data>
  8023de:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023e0:	c7 44 24 04 ae 32 80 	movl   $0x8032ae,0x4(%esp)
  8023e7:	00 
  8023e8:	89 1c 24             	mov    %ebx,(%esp)
  8023eb:	e8 77 e9 ff ff       	call   800d67 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023f0:	8b 46 04             	mov    0x4(%esi),%eax
  8023f3:	2b 06                	sub    (%esi),%eax
  8023f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802402:	00 00 00 
	stat->st_dev = &devpipe;
  802405:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80240c:	40 80 00 
	return 0;
}
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
  802414:	83 c4 10             	add    $0x10,%esp
  802417:	5b                   	pop    %ebx
  802418:	5e                   	pop    %esi
  802419:	5d                   	pop    %ebp
  80241a:	c3                   	ret    

0080241b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	53                   	push   %ebx
  80241f:	83 ec 14             	sub    $0x14,%esp
  802422:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802425:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802429:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802430:	e8 47 ee ff ff       	call   80127c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802435:	89 1c 24             	mov    %ebx,(%esp)
  802438:	e8 73 f1 ff ff       	call   8015b0 <fd2data>
  80243d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802441:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802448:	e8 2f ee ff ff       	call   80127c <sys_page_unmap>
}
  80244d:	83 c4 14             	add    $0x14,%esp
  802450:	5b                   	pop    %ebx
  802451:	5d                   	pop    %ebp
  802452:	c3                   	ret    

00802453 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
  802456:	57                   	push   %edi
  802457:	56                   	push   %esi
  802458:	53                   	push   %ebx
  802459:	83 ec 2c             	sub    $0x2c,%esp
  80245c:	89 c6                	mov    %eax,%esi
  80245e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802461:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802466:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802469:	89 34 24             	mov    %esi,(%esp)
  80246c:	e8 96 05 00 00       	call   802a07 <pageref>
  802471:	89 c7                	mov    %eax,%edi
  802473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802476:	89 04 24             	mov    %eax,(%esp)
  802479:	e8 89 05 00 00       	call   802a07 <pageref>
  80247e:	39 c7                	cmp    %eax,%edi
  802480:	0f 94 c2             	sete   %dl
  802483:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802486:	8b 0d b4 50 80 00    	mov    0x8050b4,%ecx
  80248c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80248f:	39 fb                	cmp    %edi,%ebx
  802491:	74 21                	je     8024b4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802493:	84 d2                	test   %dl,%dl
  802495:	74 ca                	je     802461 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802497:	8b 51 58             	mov    0x58(%ecx),%edx
  80249a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80249e:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024a6:	c7 04 24 b5 32 80 00 	movl   $0x8032b5,(%esp)
  8024ad:	e8 3d e2 ff ff       	call   8006ef <cprintf>
  8024b2:	eb ad                	jmp    802461 <_pipeisclosed+0xe>
	}
}
  8024b4:	83 c4 2c             	add    $0x2c,%esp
  8024b7:	5b                   	pop    %ebx
  8024b8:	5e                   	pop    %esi
  8024b9:	5f                   	pop    %edi
  8024ba:	5d                   	pop    %ebp
  8024bb:	c3                   	ret    

008024bc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	57                   	push   %edi
  8024c0:	56                   	push   %esi
  8024c1:	53                   	push   %ebx
  8024c2:	83 ec 1c             	sub    $0x1c,%esp
  8024c5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8024c8:	89 34 24             	mov    %esi,(%esp)
  8024cb:	e8 e0 f0 ff ff       	call   8015b0 <fd2data>
  8024d0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024d7:	eb 45                	jmp    80251e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024d9:	89 da                	mov    %ebx,%edx
  8024db:	89 f0                	mov    %esi,%eax
  8024dd:	e8 71 ff ff ff       	call   802453 <_pipeisclosed>
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	75 41                	jne    802527 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024e6:	e8 cb ec ff ff       	call   8011b6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024eb:	8b 43 04             	mov    0x4(%ebx),%eax
  8024ee:	8b 0b                	mov    (%ebx),%ecx
  8024f0:	8d 51 20             	lea    0x20(%ecx),%edx
  8024f3:	39 d0                	cmp    %edx,%eax
  8024f5:	73 e2                	jae    8024d9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024fa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024fe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802501:	99                   	cltd   
  802502:	c1 ea 1b             	shr    $0x1b,%edx
  802505:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802508:	83 e1 1f             	and    $0x1f,%ecx
  80250b:	29 d1                	sub    %edx,%ecx
  80250d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802511:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802515:	83 c0 01             	add    $0x1,%eax
  802518:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80251b:	83 c7 01             	add    $0x1,%edi
  80251e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802521:	75 c8                	jne    8024eb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802523:	89 f8                	mov    %edi,%eax
  802525:	eb 05                	jmp    80252c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802527:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80252c:	83 c4 1c             	add    $0x1c,%esp
  80252f:	5b                   	pop    %ebx
  802530:	5e                   	pop    %esi
  802531:	5f                   	pop    %edi
  802532:	5d                   	pop    %ebp
  802533:	c3                   	ret    

00802534 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
  802537:	57                   	push   %edi
  802538:	56                   	push   %esi
  802539:	53                   	push   %ebx
  80253a:	83 ec 1c             	sub    $0x1c,%esp
  80253d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802540:	89 3c 24             	mov    %edi,(%esp)
  802543:	e8 68 f0 ff ff       	call   8015b0 <fd2data>
  802548:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80254a:	be 00 00 00 00       	mov    $0x0,%esi
  80254f:	eb 3d                	jmp    80258e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802551:	85 f6                	test   %esi,%esi
  802553:	74 04                	je     802559 <devpipe_read+0x25>
				return i;
  802555:	89 f0                	mov    %esi,%eax
  802557:	eb 43                	jmp    80259c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802559:	89 da                	mov    %ebx,%edx
  80255b:	89 f8                	mov    %edi,%eax
  80255d:	e8 f1 fe ff ff       	call   802453 <_pipeisclosed>
  802562:	85 c0                	test   %eax,%eax
  802564:	75 31                	jne    802597 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802566:	e8 4b ec ff ff       	call   8011b6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80256b:	8b 03                	mov    (%ebx),%eax
  80256d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802570:	74 df                	je     802551 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802572:	99                   	cltd   
  802573:	c1 ea 1b             	shr    $0x1b,%edx
  802576:	01 d0                	add    %edx,%eax
  802578:	83 e0 1f             	and    $0x1f,%eax
  80257b:	29 d0                	sub    %edx,%eax
  80257d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802585:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802588:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80258b:	83 c6 01             	add    $0x1,%esi
  80258e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802591:	75 d8                	jne    80256b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802593:	89 f0                	mov    %esi,%eax
  802595:	eb 05                	jmp    80259c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80259c:	83 c4 1c             	add    $0x1c,%esp
  80259f:	5b                   	pop    %ebx
  8025a0:	5e                   	pop    %esi
  8025a1:	5f                   	pop    %edi
  8025a2:	5d                   	pop    %ebp
  8025a3:	c3                   	ret    

008025a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
  8025a7:	56                   	push   %esi
  8025a8:	53                   	push   %ebx
  8025a9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025af:	89 04 24             	mov    %eax,(%esp)
  8025b2:	e8 10 f0 ff ff       	call   8015c7 <fd_alloc>
  8025b7:	89 c2                	mov    %eax,%edx
  8025b9:	85 d2                	test   %edx,%edx
  8025bb:	0f 88 4d 01 00 00    	js     80270e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025c8:	00 
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d7:	e8 f9 eb ff ff       	call   8011d5 <sys_page_alloc>
  8025dc:	89 c2                	mov    %eax,%edx
  8025de:	85 d2                	test   %edx,%edx
  8025e0:	0f 88 28 01 00 00    	js     80270e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025e9:	89 04 24             	mov    %eax,(%esp)
  8025ec:	e8 d6 ef ff ff       	call   8015c7 <fd_alloc>
  8025f1:	89 c3                	mov    %eax,%ebx
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	0f 88 fe 00 00 00    	js     8026f9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802602:	00 
  802603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802606:	89 44 24 04          	mov    %eax,0x4(%esp)
  80260a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802611:	e8 bf eb ff ff       	call   8011d5 <sys_page_alloc>
  802616:	89 c3                	mov    %eax,%ebx
  802618:	85 c0                	test   %eax,%eax
  80261a:	0f 88 d9 00 00 00    	js     8026f9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	89 04 24             	mov    %eax,(%esp)
  802626:	e8 85 ef ff ff       	call   8015b0 <fd2data>
  80262b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80262d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802634:	00 
  802635:	89 44 24 04          	mov    %eax,0x4(%esp)
  802639:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802640:	e8 90 eb ff ff       	call   8011d5 <sys_page_alloc>
  802645:	89 c3                	mov    %eax,%ebx
  802647:	85 c0                	test   %eax,%eax
  802649:	0f 88 97 00 00 00    	js     8026e6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80264f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802652:	89 04 24             	mov    %eax,(%esp)
  802655:	e8 56 ef ff ff       	call   8015b0 <fd2data>
  80265a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802661:	00 
  802662:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802666:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80266d:	00 
  80266e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802672:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802679:	e8 ab eb ff ff       	call   801229 <sys_page_map>
  80267e:	89 c3                	mov    %eax,%ebx
  802680:	85 c0                	test   %eax,%eax
  802682:	78 52                	js     8026d6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802684:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802699:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80269f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	89 04 24             	mov    %eax,(%esp)
  8026b4:	e8 e7 ee ff ff       	call   8015a0 <fd2num>
  8026b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026bc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c1:	89 04 24             	mov    %eax,(%esp)
  8026c4:	e8 d7 ee ff ff       	call   8015a0 <fd2num>
  8026c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026cc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d4:	eb 38                	jmp    80270e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8026d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e1:	e8 96 eb ff ff       	call   80127c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8026e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f4:	e8 83 eb ff ff       	call   80127c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802700:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802707:	e8 70 eb ff ff       	call   80127c <sys_page_unmap>
  80270c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80270e:	83 c4 30             	add    $0x30,%esp
  802711:	5b                   	pop    %ebx
  802712:	5e                   	pop    %esi
  802713:	5d                   	pop    %ebp
  802714:	c3                   	ret    

00802715 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80271b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80271e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802722:	8b 45 08             	mov    0x8(%ebp),%eax
  802725:	89 04 24             	mov    %eax,(%esp)
  802728:	e8 e9 ee ff ff       	call   801616 <fd_lookup>
  80272d:	89 c2                	mov    %eax,%edx
  80272f:	85 d2                	test   %edx,%edx
  802731:	78 15                	js     802748 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	89 04 24             	mov    %eax,(%esp)
  802739:	e8 72 ee ff ff       	call   8015b0 <fd2data>
	return _pipeisclosed(fd, p);
  80273e:	89 c2                	mov    %eax,%edx
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	e8 0b fd ff ff       	call   802453 <_pipeisclosed>
}
  802748:	c9                   	leave  
  802749:	c3                   	ret    
  80274a:	66 90                	xchg   %ax,%ax
  80274c:	66 90                	xchg   %ax,%ax
  80274e:	66 90                	xchg   %ax,%ax

00802750 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802753:	b8 00 00 00 00       	mov    $0x0,%eax
  802758:	5d                   	pop    %ebp
  802759:	c3                   	ret    

0080275a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
  80275d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802760:	c7 44 24 04 cd 32 80 	movl   $0x8032cd,0x4(%esp)
  802767:	00 
  802768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80276b:	89 04 24             	mov    %eax,(%esp)
  80276e:	e8 f4 e5 ff ff       	call   800d67 <strcpy>
	return 0;
}
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	57                   	push   %edi
  80277e:	56                   	push   %esi
  80277f:	53                   	push   %ebx
  802780:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802786:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80278b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802791:	eb 31                	jmp    8027c4 <devcons_write+0x4a>
		m = n - tot;
  802793:	8b 75 10             	mov    0x10(%ebp),%esi
  802796:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802798:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80279b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8027a0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027a3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027a7:	03 45 0c             	add    0xc(%ebp),%eax
  8027aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ae:	89 3c 24             	mov    %edi,(%esp)
  8027b1:	e8 4e e7 ff ff       	call   800f04 <memmove>
		sys_cputs(buf, m);
  8027b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027ba:	89 3c 24             	mov    %edi,(%esp)
  8027bd:	e8 f4 e8 ff ff       	call   8010b6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027c2:	01 f3                	add    %esi,%ebx
  8027c4:	89 d8                	mov    %ebx,%eax
  8027c6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8027c9:	72 c8                	jb     802793 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8027cb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8027d1:	5b                   	pop    %ebx
  8027d2:	5e                   	pop    %esi
  8027d3:	5f                   	pop    %edi
  8027d4:	5d                   	pop    %ebp
  8027d5:	c3                   	ret    

008027d6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
  8027d9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8027dc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8027e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027e5:	75 07                	jne    8027ee <devcons_read+0x18>
  8027e7:	eb 2a                	jmp    802813 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8027e9:	e8 c8 e9 ff ff       	call   8011b6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8027ee:	66 90                	xchg   %ax,%ax
  8027f0:	e8 df e8 ff ff       	call   8010d4 <sys_cgetc>
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	74 f0                	je     8027e9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	78 16                	js     802813 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8027fd:	83 f8 04             	cmp    $0x4,%eax
  802800:	74 0c                	je     80280e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802802:	8b 55 0c             	mov    0xc(%ebp),%edx
  802805:	88 02                	mov    %al,(%edx)
	return 1;
  802807:	b8 01 00 00 00       	mov    $0x1,%eax
  80280c:	eb 05                	jmp    802813 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80280e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802813:	c9                   	leave  
  802814:	c3                   	ret    

00802815 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
  802818:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802821:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802828:	00 
  802829:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80282c:	89 04 24             	mov    %eax,(%esp)
  80282f:	e8 82 e8 ff ff       	call   8010b6 <sys_cputs>
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <getchar>:

int
getchar(void)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80283c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802843:	00 
  802844:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802847:	89 44 24 04          	mov    %eax,0x4(%esp)
  80284b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802852:	e8 53 f0 ff ff       	call   8018aa <read>
	if (r < 0)
  802857:	85 c0                	test   %eax,%eax
  802859:	78 0f                	js     80286a <getchar+0x34>
		return r;
	if (r < 1)
  80285b:	85 c0                	test   %eax,%eax
  80285d:	7e 06                	jle    802865 <getchar+0x2f>
		return -E_EOF;
	return c;
  80285f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802863:	eb 05                	jmp    80286a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802865:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
  80286f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802875:	89 44 24 04          	mov    %eax,0x4(%esp)
  802879:	8b 45 08             	mov    0x8(%ebp),%eax
  80287c:	89 04 24             	mov    %eax,(%esp)
  80287f:	e8 92 ed ff ff       	call   801616 <fd_lookup>
  802884:	85 c0                	test   %eax,%eax
  802886:	78 11                	js     802899 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802891:	39 10                	cmp    %edx,(%eax)
  802893:	0f 94 c0             	sete   %al
  802896:	0f b6 c0             	movzbl %al,%eax
}
  802899:	c9                   	leave  
  80289a:	c3                   	ret    

0080289b <opencons>:

int
opencons(void)
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
  80289e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028a4:	89 04 24             	mov    %eax,(%esp)
  8028a7:	e8 1b ed ff ff       	call   8015c7 <fd_alloc>
		return r;
  8028ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	78 40                	js     8028f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028b9:	00 
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028c8:	e8 08 e9 ff ff       	call   8011d5 <sys_page_alloc>
		return r;
  8028cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	78 1f                	js     8028f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028d3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028e8:	89 04 24             	mov    %eax,(%esp)
  8028eb:	e8 b0 ec ff ff       	call   8015a0 <fd2num>
  8028f0:	89 c2                	mov    %eax,%edx
}
  8028f2:	89 d0                	mov    %edx,%eax
  8028f4:	c9                   	leave  
  8028f5:	c3                   	ret    
  8028f6:	66 90                	xchg   %ax,%ax
  8028f8:	66 90                	xchg   %ax,%ax
  8028fa:	66 90                	xchg   %ax,%ax
  8028fc:	66 90                	xchg   %ax,%ax
  8028fe:	66 90                	xchg   %ax,%ax

00802900 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	56                   	push   %esi
  802904:	53                   	push   %ebx
  802905:	83 ec 10             	sub    $0x10,%esp
  802908:	8b 75 08             	mov    0x8(%ebp),%esi
  80290b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80290e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802911:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802913:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802918:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80291b:	89 04 24             	mov    %eax,(%esp)
  80291e:	e8 e8 ea ff ff       	call   80140b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802923:	85 c0                	test   %eax,%eax
  802925:	75 26                	jne    80294d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802927:	85 f6                	test   %esi,%esi
  802929:	74 0a                	je     802935 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80292b:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802930:	8b 40 74             	mov    0x74(%eax),%eax
  802933:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802935:	85 db                	test   %ebx,%ebx
  802937:	74 0a                	je     802943 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802939:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80293e:	8b 40 78             	mov    0x78(%eax),%eax
  802941:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802943:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802948:	8b 40 70             	mov    0x70(%eax),%eax
  80294b:	eb 14                	jmp    802961 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80294d:	85 f6                	test   %esi,%esi
  80294f:	74 06                	je     802957 <ipc_recv+0x57>
			*from_env_store = 0;
  802951:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802957:	85 db                	test   %ebx,%ebx
  802959:	74 06                	je     802961 <ipc_recv+0x61>
			*perm_store = 0;
  80295b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802961:	83 c4 10             	add    $0x10,%esp
  802964:	5b                   	pop    %ebx
  802965:	5e                   	pop    %esi
  802966:	5d                   	pop    %ebp
  802967:	c3                   	ret    

00802968 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	57                   	push   %edi
  80296c:	56                   	push   %esi
  80296d:	53                   	push   %ebx
  80296e:	83 ec 1c             	sub    $0x1c,%esp
  802971:	8b 7d 08             	mov    0x8(%ebp),%edi
  802974:	8b 75 0c             	mov    0xc(%ebp),%esi
  802977:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80297a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80297c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802981:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802984:	8b 45 14             	mov    0x14(%ebp),%eax
  802987:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80298b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80298f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802993:	89 3c 24             	mov    %edi,(%esp)
  802996:	e8 4d ea ff ff       	call   8013e8 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80299b:	85 c0                	test   %eax,%eax
  80299d:	74 28                	je     8029c7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80299f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029a2:	74 1c                	je     8029c0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  8029a4:	c7 44 24 08 dc 32 80 	movl   $0x8032dc,0x8(%esp)
  8029ab:	00 
  8029ac:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8029b3:	00 
  8029b4:	c7 04 24 00 33 80 00 	movl   $0x803300,(%esp)
  8029bb:	e8 36 dc ff ff       	call   8005f6 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8029c0:	e8 f1 e7 ff ff       	call   8011b6 <sys_yield>
	}
  8029c5:	eb bd                	jmp    802984 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8029c7:	83 c4 1c             	add    $0x1c,%esp
  8029ca:	5b                   	pop    %ebx
  8029cb:	5e                   	pop    %esi
  8029cc:	5f                   	pop    %edi
  8029cd:	5d                   	pop    %ebp
  8029ce:	c3                   	ret    

008029cf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029cf:	55                   	push   %ebp
  8029d0:	89 e5                	mov    %esp,%ebp
  8029d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029d5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029da:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8029dd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029e3:	8b 52 50             	mov    0x50(%edx),%edx
  8029e6:	39 ca                	cmp    %ecx,%edx
  8029e8:	75 0d                	jne    8029f7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8029ea:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8029ed:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8029f2:	8b 40 40             	mov    0x40(%eax),%eax
  8029f5:	eb 0e                	jmp    802a05 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8029f7:	83 c0 01             	add    $0x1,%eax
  8029fa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029ff:	75 d9                	jne    8029da <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802a01:	66 b8 00 00          	mov    $0x0,%ax
}
  802a05:	5d                   	pop    %ebp
  802a06:	c3                   	ret    

00802a07 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a07:	55                   	push   %ebp
  802a08:	89 e5                	mov    %esp,%ebp
  802a0a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a0d:	89 d0                	mov    %edx,%eax
  802a0f:	c1 e8 16             	shr    $0x16,%eax
  802a12:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a19:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a1e:	f6 c1 01             	test   $0x1,%cl
  802a21:	74 1d                	je     802a40 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802a23:	c1 ea 0c             	shr    $0xc,%edx
  802a26:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a2d:	f6 c2 01             	test   $0x1,%dl
  802a30:	74 0e                	je     802a40 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a32:	c1 ea 0c             	shr    $0xc,%edx
  802a35:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a3c:	ef 
  802a3d:	0f b7 c0             	movzwl %ax,%eax
}
  802a40:	5d                   	pop    %ebp
  802a41:	c3                   	ret    
  802a42:	66 90                	xchg   %ax,%ax
  802a44:	66 90                	xchg   %ax,%ax
  802a46:	66 90                	xchg   %ax,%ax
  802a48:	66 90                	xchg   %ax,%ax
  802a4a:	66 90                	xchg   %ax,%ax
  802a4c:	66 90                	xchg   %ax,%ax
  802a4e:	66 90                	xchg   %ax,%ax

00802a50 <__udivdi3>:
  802a50:	55                   	push   %ebp
  802a51:	57                   	push   %edi
  802a52:	56                   	push   %esi
  802a53:	83 ec 0c             	sub    $0xc,%esp
  802a56:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a5a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a5e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a62:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a66:	85 c0                	test   %eax,%eax
  802a68:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a6c:	89 ea                	mov    %ebp,%edx
  802a6e:	89 0c 24             	mov    %ecx,(%esp)
  802a71:	75 2d                	jne    802aa0 <__udivdi3+0x50>
  802a73:	39 e9                	cmp    %ebp,%ecx
  802a75:	77 61                	ja     802ad8 <__udivdi3+0x88>
  802a77:	85 c9                	test   %ecx,%ecx
  802a79:	89 ce                	mov    %ecx,%esi
  802a7b:	75 0b                	jne    802a88 <__udivdi3+0x38>
  802a7d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a82:	31 d2                	xor    %edx,%edx
  802a84:	f7 f1                	div    %ecx
  802a86:	89 c6                	mov    %eax,%esi
  802a88:	31 d2                	xor    %edx,%edx
  802a8a:	89 e8                	mov    %ebp,%eax
  802a8c:	f7 f6                	div    %esi
  802a8e:	89 c5                	mov    %eax,%ebp
  802a90:	89 f8                	mov    %edi,%eax
  802a92:	f7 f6                	div    %esi
  802a94:	89 ea                	mov    %ebp,%edx
  802a96:	83 c4 0c             	add    $0xc,%esp
  802a99:	5e                   	pop    %esi
  802a9a:	5f                   	pop    %edi
  802a9b:	5d                   	pop    %ebp
  802a9c:	c3                   	ret    
  802a9d:	8d 76 00             	lea    0x0(%esi),%esi
  802aa0:	39 e8                	cmp    %ebp,%eax
  802aa2:	77 24                	ja     802ac8 <__udivdi3+0x78>
  802aa4:	0f bd e8             	bsr    %eax,%ebp
  802aa7:	83 f5 1f             	xor    $0x1f,%ebp
  802aaa:	75 3c                	jne    802ae8 <__udivdi3+0x98>
  802aac:	8b 74 24 04          	mov    0x4(%esp),%esi
  802ab0:	39 34 24             	cmp    %esi,(%esp)
  802ab3:	0f 86 9f 00 00 00    	jbe    802b58 <__udivdi3+0x108>
  802ab9:	39 d0                	cmp    %edx,%eax
  802abb:	0f 82 97 00 00 00    	jb     802b58 <__udivdi3+0x108>
  802ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ac8:	31 d2                	xor    %edx,%edx
  802aca:	31 c0                	xor    %eax,%eax
  802acc:	83 c4 0c             	add    $0xc,%esp
  802acf:	5e                   	pop    %esi
  802ad0:	5f                   	pop    %edi
  802ad1:	5d                   	pop    %ebp
  802ad2:	c3                   	ret    
  802ad3:	90                   	nop
  802ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ad8:	89 f8                	mov    %edi,%eax
  802ada:	f7 f1                	div    %ecx
  802adc:	31 d2                	xor    %edx,%edx
  802ade:	83 c4 0c             	add    $0xc,%esp
  802ae1:	5e                   	pop    %esi
  802ae2:	5f                   	pop    %edi
  802ae3:	5d                   	pop    %ebp
  802ae4:	c3                   	ret    
  802ae5:	8d 76 00             	lea    0x0(%esi),%esi
  802ae8:	89 e9                	mov    %ebp,%ecx
  802aea:	8b 3c 24             	mov    (%esp),%edi
  802aed:	d3 e0                	shl    %cl,%eax
  802aef:	89 c6                	mov    %eax,%esi
  802af1:	b8 20 00 00 00       	mov    $0x20,%eax
  802af6:	29 e8                	sub    %ebp,%eax
  802af8:	89 c1                	mov    %eax,%ecx
  802afa:	d3 ef                	shr    %cl,%edi
  802afc:	89 e9                	mov    %ebp,%ecx
  802afe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b02:	8b 3c 24             	mov    (%esp),%edi
  802b05:	09 74 24 08          	or     %esi,0x8(%esp)
  802b09:	89 d6                	mov    %edx,%esi
  802b0b:	d3 e7                	shl    %cl,%edi
  802b0d:	89 c1                	mov    %eax,%ecx
  802b0f:	89 3c 24             	mov    %edi,(%esp)
  802b12:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b16:	d3 ee                	shr    %cl,%esi
  802b18:	89 e9                	mov    %ebp,%ecx
  802b1a:	d3 e2                	shl    %cl,%edx
  802b1c:	89 c1                	mov    %eax,%ecx
  802b1e:	d3 ef                	shr    %cl,%edi
  802b20:	09 d7                	or     %edx,%edi
  802b22:	89 f2                	mov    %esi,%edx
  802b24:	89 f8                	mov    %edi,%eax
  802b26:	f7 74 24 08          	divl   0x8(%esp)
  802b2a:	89 d6                	mov    %edx,%esi
  802b2c:	89 c7                	mov    %eax,%edi
  802b2e:	f7 24 24             	mull   (%esp)
  802b31:	39 d6                	cmp    %edx,%esi
  802b33:	89 14 24             	mov    %edx,(%esp)
  802b36:	72 30                	jb     802b68 <__udivdi3+0x118>
  802b38:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b3c:	89 e9                	mov    %ebp,%ecx
  802b3e:	d3 e2                	shl    %cl,%edx
  802b40:	39 c2                	cmp    %eax,%edx
  802b42:	73 05                	jae    802b49 <__udivdi3+0xf9>
  802b44:	3b 34 24             	cmp    (%esp),%esi
  802b47:	74 1f                	je     802b68 <__udivdi3+0x118>
  802b49:	89 f8                	mov    %edi,%eax
  802b4b:	31 d2                	xor    %edx,%edx
  802b4d:	e9 7a ff ff ff       	jmp    802acc <__udivdi3+0x7c>
  802b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b58:	31 d2                	xor    %edx,%edx
  802b5a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b5f:	e9 68 ff ff ff       	jmp    802acc <__udivdi3+0x7c>
  802b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b68:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	83 c4 0c             	add    $0xc,%esp
  802b70:	5e                   	pop    %esi
  802b71:	5f                   	pop    %edi
  802b72:	5d                   	pop    %ebp
  802b73:	c3                   	ret    
  802b74:	66 90                	xchg   %ax,%ax
  802b76:	66 90                	xchg   %ax,%ax
  802b78:	66 90                	xchg   %ax,%ax
  802b7a:	66 90                	xchg   %ax,%ax
  802b7c:	66 90                	xchg   %ax,%ax
  802b7e:	66 90                	xchg   %ax,%ax

00802b80 <__umoddi3>:
  802b80:	55                   	push   %ebp
  802b81:	57                   	push   %edi
  802b82:	56                   	push   %esi
  802b83:	83 ec 14             	sub    $0x14,%esp
  802b86:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b8a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b8e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802b92:	89 c7                	mov    %eax,%edi
  802b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b98:	8b 44 24 30          	mov    0x30(%esp),%eax
  802b9c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ba0:	89 34 24             	mov    %esi,(%esp)
  802ba3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ba7:	85 c0                	test   %eax,%eax
  802ba9:	89 c2                	mov    %eax,%edx
  802bab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802baf:	75 17                	jne    802bc8 <__umoddi3+0x48>
  802bb1:	39 fe                	cmp    %edi,%esi
  802bb3:	76 4b                	jbe    802c00 <__umoddi3+0x80>
  802bb5:	89 c8                	mov    %ecx,%eax
  802bb7:	89 fa                	mov    %edi,%edx
  802bb9:	f7 f6                	div    %esi
  802bbb:	89 d0                	mov    %edx,%eax
  802bbd:	31 d2                	xor    %edx,%edx
  802bbf:	83 c4 14             	add    $0x14,%esp
  802bc2:	5e                   	pop    %esi
  802bc3:	5f                   	pop    %edi
  802bc4:	5d                   	pop    %ebp
  802bc5:	c3                   	ret    
  802bc6:	66 90                	xchg   %ax,%ax
  802bc8:	39 f8                	cmp    %edi,%eax
  802bca:	77 54                	ja     802c20 <__umoddi3+0xa0>
  802bcc:	0f bd e8             	bsr    %eax,%ebp
  802bcf:	83 f5 1f             	xor    $0x1f,%ebp
  802bd2:	75 5c                	jne    802c30 <__umoddi3+0xb0>
  802bd4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802bd8:	39 3c 24             	cmp    %edi,(%esp)
  802bdb:	0f 87 e7 00 00 00    	ja     802cc8 <__umoddi3+0x148>
  802be1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802be5:	29 f1                	sub    %esi,%ecx
  802be7:	19 c7                	sbb    %eax,%edi
  802be9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bf1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bf5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802bf9:	83 c4 14             	add    $0x14,%esp
  802bfc:	5e                   	pop    %esi
  802bfd:	5f                   	pop    %edi
  802bfe:	5d                   	pop    %ebp
  802bff:	c3                   	ret    
  802c00:	85 f6                	test   %esi,%esi
  802c02:	89 f5                	mov    %esi,%ebp
  802c04:	75 0b                	jne    802c11 <__umoddi3+0x91>
  802c06:	b8 01 00 00 00       	mov    $0x1,%eax
  802c0b:	31 d2                	xor    %edx,%edx
  802c0d:	f7 f6                	div    %esi
  802c0f:	89 c5                	mov    %eax,%ebp
  802c11:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c15:	31 d2                	xor    %edx,%edx
  802c17:	f7 f5                	div    %ebp
  802c19:	89 c8                	mov    %ecx,%eax
  802c1b:	f7 f5                	div    %ebp
  802c1d:	eb 9c                	jmp    802bbb <__umoddi3+0x3b>
  802c1f:	90                   	nop
  802c20:	89 c8                	mov    %ecx,%eax
  802c22:	89 fa                	mov    %edi,%edx
  802c24:	83 c4 14             	add    $0x14,%esp
  802c27:	5e                   	pop    %esi
  802c28:	5f                   	pop    %edi
  802c29:	5d                   	pop    %ebp
  802c2a:	c3                   	ret    
  802c2b:	90                   	nop
  802c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c30:	8b 04 24             	mov    (%esp),%eax
  802c33:	be 20 00 00 00       	mov    $0x20,%esi
  802c38:	89 e9                	mov    %ebp,%ecx
  802c3a:	29 ee                	sub    %ebp,%esi
  802c3c:	d3 e2                	shl    %cl,%edx
  802c3e:	89 f1                	mov    %esi,%ecx
  802c40:	d3 e8                	shr    %cl,%eax
  802c42:	89 e9                	mov    %ebp,%ecx
  802c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c48:	8b 04 24             	mov    (%esp),%eax
  802c4b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c4f:	89 fa                	mov    %edi,%edx
  802c51:	d3 e0                	shl    %cl,%eax
  802c53:	89 f1                	mov    %esi,%ecx
  802c55:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c59:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c5d:	d3 ea                	shr    %cl,%edx
  802c5f:	89 e9                	mov    %ebp,%ecx
  802c61:	d3 e7                	shl    %cl,%edi
  802c63:	89 f1                	mov    %esi,%ecx
  802c65:	d3 e8                	shr    %cl,%eax
  802c67:	89 e9                	mov    %ebp,%ecx
  802c69:	09 f8                	or     %edi,%eax
  802c6b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c6f:	f7 74 24 04          	divl   0x4(%esp)
  802c73:	d3 e7                	shl    %cl,%edi
  802c75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c79:	89 d7                	mov    %edx,%edi
  802c7b:	f7 64 24 08          	mull   0x8(%esp)
  802c7f:	39 d7                	cmp    %edx,%edi
  802c81:	89 c1                	mov    %eax,%ecx
  802c83:	89 14 24             	mov    %edx,(%esp)
  802c86:	72 2c                	jb     802cb4 <__umoddi3+0x134>
  802c88:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802c8c:	72 22                	jb     802cb0 <__umoddi3+0x130>
  802c8e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802c92:	29 c8                	sub    %ecx,%eax
  802c94:	19 d7                	sbb    %edx,%edi
  802c96:	89 e9                	mov    %ebp,%ecx
  802c98:	89 fa                	mov    %edi,%edx
  802c9a:	d3 e8                	shr    %cl,%eax
  802c9c:	89 f1                	mov    %esi,%ecx
  802c9e:	d3 e2                	shl    %cl,%edx
  802ca0:	89 e9                	mov    %ebp,%ecx
  802ca2:	d3 ef                	shr    %cl,%edi
  802ca4:	09 d0                	or     %edx,%eax
  802ca6:	89 fa                	mov    %edi,%edx
  802ca8:	83 c4 14             	add    $0x14,%esp
  802cab:	5e                   	pop    %esi
  802cac:	5f                   	pop    %edi
  802cad:	5d                   	pop    %ebp
  802cae:	c3                   	ret    
  802caf:	90                   	nop
  802cb0:	39 d7                	cmp    %edx,%edi
  802cb2:	75 da                	jne    802c8e <__umoddi3+0x10e>
  802cb4:	8b 14 24             	mov    (%esp),%edx
  802cb7:	89 c1                	mov    %eax,%ecx
  802cb9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802cbd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802cc1:	eb cb                	jmp    802c8e <__umoddi3+0x10e>
  802cc3:	90                   	nop
  802cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cc8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802ccc:	0f 82 0f ff ff ff    	jb     802be1 <__umoddi3+0x61>
  802cd2:	e9 1a ff ff ff       	jmp    802bf1 <__umoddi3+0x71>
