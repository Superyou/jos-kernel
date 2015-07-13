
obj/user/faultbadhandler.debug:     file format elf32-i386


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
  80002c:	e8 44 00 00 00       	call   800075 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800040:	00 
  800041:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800048:	ee 
  800049:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800050:	e8 a0 01 00 00       	call   8001f5 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  800055:	c7 44 24 04 ef be ad 	movl   $0xdeadbeef,0x4(%esp)
  80005c:	de 
  80005d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800064:	e8 4c 03 00 00       	call   8003b5 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800069:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800070:	00 00 00 
}
  800073:	c9                   	leave  
  800074:	c3                   	ret    

00800075 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800075:	55                   	push   %ebp
  800076:	89 e5                	mov    %esp,%ebp
  800078:	56                   	push   %esi
  800079:	53                   	push   %ebx
  80007a:	83 ec 10             	sub    $0x10,%esp
  80007d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800080:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800083:	e8 2f 01 00 00       	call   8001b7 <sys_getenvid>
  800088:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800090:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800095:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009a:	85 db                	test   %ebx,%ebx
  80009c:	7e 07                	jle    8000a5 <libmain+0x30>
		binaryname = argv[0];
  80009e:	8b 06                	mov    (%esi),%eax
  8000a0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000a9:	89 1c 24             	mov    %ebx,(%esp)
  8000ac:	e8 82 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b1:	e8 07 00 00 00       	call   8000bd <exit>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	5b                   	pop    %ebx
  8000ba:	5e                   	pop    %esi
  8000bb:	5d                   	pop    %ebp
  8000bc:	c3                   	ret    

008000bd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000c3:	e8 12 06 00 00       	call   8006da <close_all>
	sys_env_destroy(0);
  8000c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000cf:	e8 3f 00 00 00       	call   800113 <sys_env_destroy>
}
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    

008000d6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	57                   	push   %edi
  8000da:	56                   	push   %esi
  8000db:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e7:	89 c3                	mov    %eax,%ebx
  8000e9:	89 c7                	mov    %eax,%edi
  8000eb:	89 c6                	mov    %eax,%esi
  8000ed:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	57                   	push   %edi
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ff:	b8 01 00 00 00       	mov    $0x1,%eax
  800104:	89 d1                	mov    %edx,%ecx
  800106:	89 d3                	mov    %edx,%ebx
  800108:	89 d7                	mov    %edx,%edi
  80010a:	89 d6                	mov    %edx,%esi
  80010c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80010e:	5b                   	pop    %ebx
  80010f:	5e                   	pop    %esi
  800110:	5f                   	pop    %edi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    

00800113 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	57                   	push   %edi
  800117:	56                   	push   %esi
  800118:	53                   	push   %ebx
  800119:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800121:	b8 03 00 00 00       	mov    $0x3,%eax
  800126:	8b 55 08             	mov    0x8(%ebp),%edx
  800129:	89 cb                	mov    %ecx,%ebx
  80012b:	89 cf                	mov    %ecx,%edi
  80012d:	89 ce                	mov    %ecx,%esi
  80012f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800131:	85 c0                	test   %eax,%eax
  800133:	7e 28                	jle    80015d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800135:	89 44 24 10          	mov    %eax,0x10(%esp)
  800139:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800140:	00 
  800141:	c7 44 24 08 0a 27 80 	movl   $0x80270a,0x8(%esp)
  800148:	00 
  800149:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800150:	00 
  800151:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  800158:	e8 f9 16 00 00       	call   801856 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80015d:	83 c4 2c             	add    $0x2c,%esp
  800160:	5b                   	pop    %ebx
  800161:	5e                   	pop    %esi
  800162:	5f                   	pop    %edi
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    

00800165 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	57                   	push   %edi
  800169:	56                   	push   %esi
  80016a:	53                   	push   %ebx
  80016b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80016e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800173:	b8 04 00 00 00       	mov    $0x4,%eax
  800178:	8b 55 08             	mov    0x8(%ebp),%edx
  80017b:	89 cb                	mov    %ecx,%ebx
  80017d:	89 cf                	mov    %ecx,%edi
  80017f:	89 ce                	mov    %ecx,%esi
  800181:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800183:	85 c0                	test   %eax,%eax
  800185:	7e 28                	jle    8001af <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800187:	89 44 24 10          	mov    %eax,0x10(%esp)
  80018b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800192:	00 
  800193:	c7 44 24 08 0a 27 80 	movl   $0x80270a,0x8(%esp)
  80019a:	00 
  80019b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001a2:	00 
  8001a3:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  8001aa:	e8 a7 16 00 00       	call   801856 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  8001af:	83 c4 2c             	add    $0x2c,%esp
  8001b2:	5b                   	pop    %ebx
  8001b3:	5e                   	pop    %esi
  8001b4:	5f                   	pop    %edi
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	57                   	push   %edi
  8001bb:	56                   	push   %esi
  8001bc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8001c2:	b8 02 00 00 00       	mov    $0x2,%eax
  8001c7:	89 d1                	mov    %edx,%ecx
  8001c9:	89 d3                	mov    %edx,%ebx
  8001cb:	89 d7                	mov    %edx,%edi
  8001cd:	89 d6                	mov    %edx,%esi
  8001cf:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001d1:	5b                   	pop    %ebx
  8001d2:	5e                   	pop    %esi
  8001d3:	5f                   	pop    %edi
  8001d4:	5d                   	pop    %ebp
  8001d5:	c3                   	ret    

008001d6 <sys_yield>:

void
sys_yield(void)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	57                   	push   %edi
  8001da:	56                   	push   %esi
  8001db:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8001e1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8001e6:	89 d1                	mov    %edx,%ecx
  8001e8:	89 d3                	mov    %edx,%ebx
  8001ea:	89 d7                	mov    %edx,%edi
  8001ec:	89 d6                	mov    %edx,%esi
  8001ee:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001f0:	5b                   	pop    %ebx
  8001f1:	5e                   	pop    %esi
  8001f2:	5f                   	pop    %edi
  8001f3:	5d                   	pop    %ebp
  8001f4:	c3                   	ret    

008001f5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	57                   	push   %edi
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001fe:	be 00 00 00 00       	mov    $0x0,%esi
  800203:	b8 05 00 00 00       	mov    $0x5,%eax
  800208:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80020b:	8b 55 08             	mov    0x8(%ebp),%edx
  80020e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800211:	89 f7                	mov    %esi,%edi
  800213:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800215:	85 c0                	test   %eax,%eax
  800217:	7e 28                	jle    800241 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800219:	89 44 24 10          	mov    %eax,0x10(%esp)
  80021d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800224:	00 
  800225:	c7 44 24 08 0a 27 80 	movl   $0x80270a,0x8(%esp)
  80022c:	00 
  80022d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800234:	00 
  800235:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  80023c:	e8 15 16 00 00       	call   801856 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800241:	83 c4 2c             	add    $0x2c,%esp
  800244:	5b                   	pop    %ebx
  800245:	5e                   	pop    %esi
  800246:	5f                   	pop    %edi
  800247:	5d                   	pop    %ebp
  800248:	c3                   	ret    

00800249 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	57                   	push   %edi
  80024d:	56                   	push   %esi
  80024e:	53                   	push   %ebx
  80024f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800252:	b8 06 00 00 00       	mov    $0x6,%eax
  800257:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025a:	8b 55 08             	mov    0x8(%ebp),%edx
  80025d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800260:	8b 7d 14             	mov    0x14(%ebp),%edi
  800263:	8b 75 18             	mov    0x18(%ebp),%esi
  800266:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800268:	85 c0                	test   %eax,%eax
  80026a:	7e 28                	jle    800294 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80026c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800270:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800277:	00 
  800278:	c7 44 24 08 0a 27 80 	movl   $0x80270a,0x8(%esp)
  80027f:	00 
  800280:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800287:	00 
  800288:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  80028f:	e8 c2 15 00 00       	call   801856 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800294:	83 c4 2c             	add    $0x2c,%esp
  800297:	5b                   	pop    %ebx
  800298:	5e                   	pop    %esi
  800299:	5f                   	pop    %edi
  80029a:	5d                   	pop    %ebp
  80029b:	c3                   	ret    

0080029c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	57                   	push   %edi
  8002a0:	56                   	push   %esi
  8002a1:	53                   	push   %ebx
  8002a2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8002af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b5:	89 df                	mov    %ebx,%edi
  8002b7:	89 de                	mov    %ebx,%esi
  8002b9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002bb:	85 c0                	test   %eax,%eax
  8002bd:	7e 28                	jle    8002e7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002bf:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002c3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8002ca:	00 
  8002cb:	c7 44 24 08 0a 27 80 	movl   $0x80270a,0x8(%esp)
  8002d2:	00 
  8002d3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002da:	00 
  8002db:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  8002e2:	e8 6f 15 00 00       	call   801856 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8002e7:	83 c4 2c             	add    $0x2c,%esp
  8002ea:	5b                   	pop    %ebx
  8002eb:	5e                   	pop    %esi
  8002ec:	5f                   	pop    %edi
  8002ed:	5d                   	pop    %ebp
  8002ee:	c3                   	ret    

008002ef <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	57                   	push   %edi
  8002f3:	56                   	push   %esi
  8002f4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002fa:	b8 10 00 00 00       	mov    $0x10,%eax
  8002ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800302:	89 cb                	mov    %ecx,%ebx
  800304:	89 cf                	mov    %ecx,%edi
  800306:	89 ce                	mov    %ecx,%esi
  800308:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5f                   	pop    %edi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	57                   	push   %edi
  800313:	56                   	push   %esi
  800314:	53                   	push   %ebx
  800315:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800318:	bb 00 00 00 00       	mov    $0x0,%ebx
  80031d:	b8 09 00 00 00       	mov    $0x9,%eax
  800322:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800325:	8b 55 08             	mov    0x8(%ebp),%edx
  800328:	89 df                	mov    %ebx,%edi
  80032a:	89 de                	mov    %ebx,%esi
  80032c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80032e:	85 c0                	test   %eax,%eax
  800330:	7e 28                	jle    80035a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800332:	89 44 24 10          	mov    %eax,0x10(%esp)
  800336:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80033d:	00 
  80033e:	c7 44 24 08 0a 27 80 	movl   $0x80270a,0x8(%esp)
  800345:	00 
  800346:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80034d:	00 
  80034e:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  800355:	e8 fc 14 00 00       	call   801856 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80035a:	83 c4 2c             	add    $0x2c,%esp
  80035d:	5b                   	pop    %ebx
  80035e:	5e                   	pop    %esi
  80035f:	5f                   	pop    %edi
  800360:	5d                   	pop    %ebp
  800361:	c3                   	ret    

00800362 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	57                   	push   %edi
  800366:	56                   	push   %esi
  800367:	53                   	push   %ebx
  800368:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80036b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800370:	b8 0a 00 00 00       	mov    $0xa,%eax
  800375:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800378:	8b 55 08             	mov    0x8(%ebp),%edx
  80037b:	89 df                	mov    %ebx,%edi
  80037d:	89 de                	mov    %ebx,%esi
  80037f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800381:	85 c0                	test   %eax,%eax
  800383:	7e 28                	jle    8003ad <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800385:	89 44 24 10          	mov    %eax,0x10(%esp)
  800389:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800390:	00 
  800391:	c7 44 24 08 0a 27 80 	movl   $0x80270a,0x8(%esp)
  800398:	00 
  800399:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003a0:	00 
  8003a1:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  8003a8:	e8 a9 14 00 00       	call   801856 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8003ad:	83 c4 2c             	add    $0x2c,%esp
  8003b0:	5b                   	pop    %ebx
  8003b1:	5e                   	pop    %esi
  8003b2:	5f                   	pop    %edi
  8003b3:	5d                   	pop    %ebp
  8003b4:	c3                   	ret    

008003b5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8003b5:	55                   	push   %ebp
  8003b6:	89 e5                	mov    %esp,%ebp
  8003b8:	57                   	push   %edi
  8003b9:	56                   	push   %esi
  8003ba:	53                   	push   %ebx
  8003bb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8003c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ce:	89 df                	mov    %ebx,%edi
  8003d0:	89 de                	mov    %ebx,%esi
  8003d2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	7e 28                	jle    800400 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003dc:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8003e3:	00 
  8003e4:	c7 44 24 08 0a 27 80 	movl   $0x80270a,0x8(%esp)
  8003eb:	00 
  8003ec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003f3:	00 
  8003f4:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  8003fb:	e8 56 14 00 00       	call   801856 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800400:	83 c4 2c             	add    $0x2c,%esp
  800403:	5b                   	pop    %ebx
  800404:	5e                   	pop    %esi
  800405:	5f                   	pop    %edi
  800406:	5d                   	pop    %ebp
  800407:	c3                   	ret    

00800408 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	57                   	push   %edi
  80040c:	56                   	push   %esi
  80040d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80040e:	be 00 00 00 00       	mov    $0x0,%esi
  800413:	b8 0d 00 00 00       	mov    $0xd,%eax
  800418:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80041b:	8b 55 08             	mov    0x8(%ebp),%edx
  80041e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800421:	8b 7d 14             	mov    0x14(%ebp),%edi
  800424:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800426:	5b                   	pop    %ebx
  800427:	5e                   	pop    %esi
  800428:	5f                   	pop    %edi
  800429:	5d                   	pop    %ebp
  80042a:	c3                   	ret    

0080042b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	57                   	push   %edi
  80042f:	56                   	push   %esi
  800430:	53                   	push   %ebx
  800431:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800434:	b9 00 00 00 00       	mov    $0x0,%ecx
  800439:	b8 0e 00 00 00       	mov    $0xe,%eax
  80043e:	8b 55 08             	mov    0x8(%ebp),%edx
  800441:	89 cb                	mov    %ecx,%ebx
  800443:	89 cf                	mov    %ecx,%edi
  800445:	89 ce                	mov    %ecx,%esi
  800447:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800449:	85 c0                	test   %eax,%eax
  80044b:	7e 28                	jle    800475 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80044d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800451:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800458:	00 
  800459:	c7 44 24 08 0a 27 80 	movl   $0x80270a,0x8(%esp)
  800460:	00 
  800461:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800468:	00 
  800469:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  800470:	e8 e1 13 00 00       	call   801856 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800475:	83 c4 2c             	add    $0x2c,%esp
  800478:	5b                   	pop    %ebx
  800479:	5e                   	pop    %esi
  80047a:	5f                   	pop    %edi
  80047b:	5d                   	pop    %ebp
  80047c:	c3                   	ret    

0080047d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	57                   	push   %edi
  800481:	56                   	push   %esi
  800482:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800483:	ba 00 00 00 00       	mov    $0x0,%edx
  800488:	b8 0f 00 00 00       	mov    $0xf,%eax
  80048d:	89 d1                	mov    %edx,%ecx
  80048f:	89 d3                	mov    %edx,%ebx
  800491:	89 d7                	mov    %edx,%edi
  800493:	89 d6                	mov    %edx,%esi
  800495:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800497:	5b                   	pop    %ebx
  800498:	5e                   	pop    %esi
  800499:	5f                   	pop    %edi
  80049a:	5d                   	pop    %ebp
  80049b:	c3                   	ret    

0080049c <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	57                   	push   %edi
  8004a0:	56                   	push   %esi
  8004a1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004a7:	b8 11 00 00 00       	mov    $0x11,%eax
  8004ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004af:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b2:	89 df                	mov    %ebx,%edi
  8004b4:	89 de                	mov    %ebx,%esi
  8004b6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  8004b8:	5b                   	pop    %ebx
  8004b9:	5e                   	pop    %esi
  8004ba:	5f                   	pop    %edi
  8004bb:	5d                   	pop    %ebp
  8004bc:	c3                   	ret    

008004bd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	57                   	push   %edi
  8004c1:	56                   	push   %esi
  8004c2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004c8:	b8 12 00 00 00       	mov    $0x12,%eax
  8004cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d3:	89 df                	mov    %ebx,%edi
  8004d5:	89 de                	mov    %ebx,%esi
  8004d7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8004d9:	5b                   	pop    %ebx
  8004da:	5e                   	pop    %esi
  8004db:	5f                   	pop    %edi
  8004dc:	5d                   	pop    %ebp
  8004dd:	c3                   	ret    

008004de <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	57                   	push   %edi
  8004e2:	56                   	push   %esi
  8004e3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004e9:	b8 13 00 00 00       	mov    $0x13,%eax
  8004ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f1:	89 cb                	mov    %ecx,%ebx
  8004f3:	89 cf                	mov    %ecx,%edi
  8004f5:	89 ce                	mov    %ecx,%esi
  8004f7:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8004f9:	5b                   	pop    %ebx
  8004fa:	5e                   	pop    %esi
  8004fb:	5f                   	pop    %edi
  8004fc:	5d                   	pop    %ebp
  8004fd:	c3                   	ret    
  8004fe:	66 90                	xchg   %ax,%ax

00800500 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	05 00 00 00 30       	add    $0x30000000,%eax
  80050b:	c1 e8 0c             	shr    $0xc,%eax
}
  80050e:	5d                   	pop    %ebp
  80050f:	c3                   	ret    

00800510 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800510:	55                   	push   %ebp
  800511:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80051b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800520:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800525:	5d                   	pop    %ebp
  800526:	c3                   	ret    

00800527 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80052d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800532:	89 c2                	mov    %eax,%edx
  800534:	c1 ea 16             	shr    $0x16,%edx
  800537:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80053e:	f6 c2 01             	test   $0x1,%dl
  800541:	74 11                	je     800554 <fd_alloc+0x2d>
  800543:	89 c2                	mov    %eax,%edx
  800545:	c1 ea 0c             	shr    $0xc,%edx
  800548:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80054f:	f6 c2 01             	test   $0x1,%dl
  800552:	75 09                	jne    80055d <fd_alloc+0x36>
			*fd_store = fd;
  800554:	89 01                	mov    %eax,(%ecx)
			return 0;
  800556:	b8 00 00 00 00       	mov    $0x0,%eax
  80055b:	eb 17                	jmp    800574 <fd_alloc+0x4d>
  80055d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800562:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800567:	75 c9                	jne    800532 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800569:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80056f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800574:	5d                   	pop    %ebp
  800575:	c3                   	ret    

00800576 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80057c:	83 f8 1f             	cmp    $0x1f,%eax
  80057f:	77 36                	ja     8005b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800581:	c1 e0 0c             	shl    $0xc,%eax
  800584:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800589:	89 c2                	mov    %eax,%edx
  80058b:	c1 ea 16             	shr    $0x16,%edx
  80058e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800595:	f6 c2 01             	test   $0x1,%dl
  800598:	74 24                	je     8005be <fd_lookup+0x48>
  80059a:	89 c2                	mov    %eax,%edx
  80059c:	c1 ea 0c             	shr    $0xc,%edx
  80059f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8005a6:	f6 c2 01             	test   $0x1,%dl
  8005a9:	74 1a                	je     8005c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8005ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	eb 13                	jmp    8005ca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8005b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8005bc:	eb 0c                	jmp    8005ca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8005be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8005c3:	eb 05                	jmp    8005ca <fd_lookup+0x54>
  8005c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8005ca:	5d                   	pop    %ebp
  8005cb:	c3                   	ret    

008005cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8005cc:	55                   	push   %ebp
  8005cd:	89 e5                	mov    %esp,%ebp
  8005cf:	83 ec 18             	sub    $0x18,%esp
  8005d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8005d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005da:	eb 13                	jmp    8005ef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8005dc:	39 08                	cmp    %ecx,(%eax)
  8005de:	75 0c                	jne    8005ec <dev_lookup+0x20>
			*dev = devtab[i];
  8005e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8005e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ea:	eb 38                	jmp    800624 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005ec:	83 c2 01             	add    $0x1,%edx
  8005ef:	8b 04 95 b4 27 80 00 	mov    0x8027b4(,%edx,4),%eax
  8005f6:	85 c0                	test   %eax,%eax
  8005f8:	75 e2                	jne    8005dc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005fa:	a1 08 40 80 00       	mov    0x804008,%eax
  8005ff:	8b 40 48             	mov    0x48(%eax),%eax
  800602:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800606:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060a:	c7 04 24 38 27 80 00 	movl   $0x802738,(%esp)
  800611:	e8 39 13 00 00       	call   80194f <cprintf>
	*dev = 0;
  800616:	8b 45 0c             	mov    0xc(%ebp),%eax
  800619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80061f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800624:	c9                   	leave  
  800625:	c3                   	ret    

00800626 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	56                   	push   %esi
  80062a:	53                   	push   %ebx
  80062b:	83 ec 20             	sub    $0x20,%esp
  80062e:	8b 75 08             	mov    0x8(%ebp),%esi
  800631:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800634:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800637:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80063b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800641:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800644:	89 04 24             	mov    %eax,(%esp)
  800647:	e8 2a ff ff ff       	call   800576 <fd_lookup>
  80064c:	85 c0                	test   %eax,%eax
  80064e:	78 05                	js     800655 <fd_close+0x2f>
	    || fd != fd2)
  800650:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800653:	74 0c                	je     800661 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800655:	84 db                	test   %bl,%bl
  800657:	ba 00 00 00 00       	mov    $0x0,%edx
  80065c:	0f 44 c2             	cmove  %edx,%eax
  80065f:	eb 3f                	jmp    8006a0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800661:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800664:	89 44 24 04          	mov    %eax,0x4(%esp)
  800668:	8b 06                	mov    (%esi),%eax
  80066a:	89 04 24             	mov    %eax,(%esp)
  80066d:	e8 5a ff ff ff       	call   8005cc <dev_lookup>
  800672:	89 c3                	mov    %eax,%ebx
  800674:	85 c0                	test   %eax,%eax
  800676:	78 16                	js     80068e <fd_close+0x68>
		if (dev->dev_close)
  800678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80067e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800683:	85 c0                	test   %eax,%eax
  800685:	74 07                	je     80068e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800687:	89 34 24             	mov    %esi,(%esp)
  80068a:	ff d0                	call   *%eax
  80068c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80068e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800692:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800699:	e8 fe fb ff ff       	call   80029c <sys_page_unmap>
	return r;
  80069e:	89 d8                	mov    %ebx,%eax
}
  8006a0:	83 c4 20             	add    $0x20,%esp
  8006a3:	5b                   	pop    %ebx
  8006a4:	5e                   	pop    %esi
  8006a5:	5d                   	pop    %ebp
  8006a6:	c3                   	ret    

008006a7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8006a7:	55                   	push   %ebp
  8006a8:	89 e5                	mov    %esp,%ebp
  8006aa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8006ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	89 04 24             	mov    %eax,(%esp)
  8006ba:	e8 b7 fe ff ff       	call   800576 <fd_lookup>
  8006bf:	89 c2                	mov    %eax,%edx
  8006c1:	85 d2                	test   %edx,%edx
  8006c3:	78 13                	js     8006d8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8006c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8006cc:	00 
  8006cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d0:	89 04 24             	mov    %eax,(%esp)
  8006d3:	e8 4e ff ff ff       	call   800626 <fd_close>
}
  8006d8:	c9                   	leave  
  8006d9:	c3                   	ret    

008006da <close_all>:

void
close_all(void)
{
  8006da:	55                   	push   %ebp
  8006db:	89 e5                	mov    %esp,%ebp
  8006dd:	53                   	push   %ebx
  8006de:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006e6:	89 1c 24             	mov    %ebx,(%esp)
  8006e9:	e8 b9 ff ff ff       	call   8006a7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006ee:	83 c3 01             	add    $0x1,%ebx
  8006f1:	83 fb 20             	cmp    $0x20,%ebx
  8006f4:	75 f0                	jne    8006e6 <close_all+0xc>
		close(i);
}
  8006f6:	83 c4 14             	add    $0x14,%esp
  8006f9:	5b                   	pop    %ebx
  8006fa:	5d                   	pop    %ebp
  8006fb:	c3                   	ret    

008006fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	57                   	push   %edi
  800700:	56                   	push   %esi
  800701:	53                   	push   %ebx
  800702:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800705:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800708:	89 44 24 04          	mov    %eax,0x4(%esp)
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 04 24             	mov    %eax,(%esp)
  800712:	e8 5f fe ff ff       	call   800576 <fd_lookup>
  800717:	89 c2                	mov    %eax,%edx
  800719:	85 d2                	test   %edx,%edx
  80071b:	0f 88 e1 00 00 00    	js     800802 <dup+0x106>
		return r;
	close(newfdnum);
  800721:	8b 45 0c             	mov    0xc(%ebp),%eax
  800724:	89 04 24             	mov    %eax,(%esp)
  800727:	e8 7b ff ff ff       	call   8006a7 <close>

	newfd = INDEX2FD(newfdnum);
  80072c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80072f:	c1 e3 0c             	shl    $0xc,%ebx
  800732:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80073b:	89 04 24             	mov    %eax,(%esp)
  80073e:	e8 cd fd ff ff       	call   800510 <fd2data>
  800743:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800745:	89 1c 24             	mov    %ebx,(%esp)
  800748:	e8 c3 fd ff ff       	call   800510 <fd2data>
  80074d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80074f:	89 f0                	mov    %esi,%eax
  800751:	c1 e8 16             	shr    $0x16,%eax
  800754:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80075b:	a8 01                	test   $0x1,%al
  80075d:	74 43                	je     8007a2 <dup+0xa6>
  80075f:	89 f0                	mov    %esi,%eax
  800761:	c1 e8 0c             	shr    $0xc,%eax
  800764:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80076b:	f6 c2 01             	test   $0x1,%dl
  80076e:	74 32                	je     8007a2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800770:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800777:	25 07 0e 00 00       	and    $0xe07,%eax
  80077c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800780:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800784:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80078b:	00 
  80078c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800790:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800797:	e8 ad fa ff ff       	call   800249 <sys_page_map>
  80079c:	89 c6                	mov    %eax,%esi
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	78 3e                	js     8007e0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8007a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007a5:	89 c2                	mov    %eax,%edx
  8007a7:	c1 ea 0c             	shr    $0xc,%edx
  8007aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007b1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8007b7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8007bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007c6:	00 
  8007c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007d2:	e8 72 fa ff ff       	call   800249 <sys_page_map>
  8007d7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8007dc:	85 f6                	test   %esi,%esi
  8007de:	79 22                	jns    800802 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007eb:	e8 ac fa ff ff       	call   80029c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8007f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007fb:	e8 9c fa ff ff       	call   80029c <sys_page_unmap>
	return r;
  800800:	89 f0                	mov    %esi,%eax
}
  800802:	83 c4 3c             	add    $0x3c,%esp
  800805:	5b                   	pop    %ebx
  800806:	5e                   	pop    %esi
  800807:	5f                   	pop    %edi
  800808:	5d                   	pop    %ebp
  800809:	c3                   	ret    

0080080a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	53                   	push   %ebx
  80080e:	83 ec 24             	sub    $0x24,%esp
  800811:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800814:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081b:	89 1c 24             	mov    %ebx,(%esp)
  80081e:	e8 53 fd ff ff       	call   800576 <fd_lookup>
  800823:	89 c2                	mov    %eax,%edx
  800825:	85 d2                	test   %edx,%edx
  800827:	78 6d                	js     800896 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800829:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80082c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800833:	8b 00                	mov    (%eax),%eax
  800835:	89 04 24             	mov    %eax,(%esp)
  800838:	e8 8f fd ff ff       	call   8005cc <dev_lookup>
  80083d:	85 c0                	test   %eax,%eax
  80083f:	78 55                	js     800896 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800844:	8b 50 08             	mov    0x8(%eax),%edx
  800847:	83 e2 03             	and    $0x3,%edx
  80084a:	83 fa 01             	cmp    $0x1,%edx
  80084d:	75 23                	jne    800872 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80084f:	a1 08 40 80 00       	mov    0x804008,%eax
  800854:	8b 40 48             	mov    0x48(%eax),%eax
  800857:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80085b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80085f:	c7 04 24 79 27 80 00 	movl   $0x802779,(%esp)
  800866:	e8 e4 10 00 00       	call   80194f <cprintf>
		return -E_INVAL;
  80086b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800870:	eb 24                	jmp    800896 <read+0x8c>
	}
	if (!dev->dev_read)
  800872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800875:	8b 52 08             	mov    0x8(%edx),%edx
  800878:	85 d2                	test   %edx,%edx
  80087a:	74 15                	je     800891 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80087c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80087f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800883:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800886:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80088a:	89 04 24             	mov    %eax,(%esp)
  80088d:	ff d2                	call   *%edx
  80088f:	eb 05                	jmp    800896 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800891:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800896:	83 c4 24             	add    $0x24,%esp
  800899:	5b                   	pop    %ebx
  80089a:	5d                   	pop    %ebp
  80089b:	c3                   	ret    

0080089c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	57                   	push   %edi
  8008a0:	56                   	push   %esi
  8008a1:	53                   	push   %ebx
  8008a2:	83 ec 1c             	sub    $0x1c,%esp
  8008a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008b0:	eb 23                	jmp    8008d5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8008b2:	89 f0                	mov    %esi,%eax
  8008b4:	29 d8                	sub    %ebx,%eax
  8008b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ba:	89 d8                	mov    %ebx,%eax
  8008bc:	03 45 0c             	add    0xc(%ebp),%eax
  8008bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c3:	89 3c 24             	mov    %edi,(%esp)
  8008c6:	e8 3f ff ff ff       	call   80080a <read>
		if (m < 0)
  8008cb:	85 c0                	test   %eax,%eax
  8008cd:	78 10                	js     8008df <readn+0x43>
			return m;
		if (m == 0)
  8008cf:	85 c0                	test   %eax,%eax
  8008d1:	74 0a                	je     8008dd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008d3:	01 c3                	add    %eax,%ebx
  8008d5:	39 f3                	cmp    %esi,%ebx
  8008d7:	72 d9                	jb     8008b2 <readn+0x16>
  8008d9:	89 d8                	mov    %ebx,%eax
  8008db:	eb 02                	jmp    8008df <readn+0x43>
  8008dd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8008df:	83 c4 1c             	add    $0x1c,%esp
  8008e2:	5b                   	pop    %ebx
  8008e3:	5e                   	pop    %esi
  8008e4:	5f                   	pop    %edi
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	83 ec 24             	sub    $0x24,%esp
  8008ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f8:	89 1c 24             	mov    %ebx,(%esp)
  8008fb:	e8 76 fc ff ff       	call   800576 <fd_lookup>
  800900:	89 c2                	mov    %eax,%edx
  800902:	85 d2                	test   %edx,%edx
  800904:	78 68                	js     80096e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800906:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800909:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	89 04 24             	mov    %eax,(%esp)
  800915:	e8 b2 fc ff ff       	call   8005cc <dev_lookup>
  80091a:	85 c0                	test   %eax,%eax
  80091c:	78 50                	js     80096e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80091e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800921:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800925:	75 23                	jne    80094a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800927:	a1 08 40 80 00       	mov    0x804008,%eax
  80092c:	8b 40 48             	mov    0x48(%eax),%eax
  80092f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800933:	89 44 24 04          	mov    %eax,0x4(%esp)
  800937:	c7 04 24 95 27 80 00 	movl   $0x802795,(%esp)
  80093e:	e8 0c 10 00 00       	call   80194f <cprintf>
		return -E_INVAL;
  800943:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800948:	eb 24                	jmp    80096e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80094a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094d:	8b 52 0c             	mov    0xc(%edx),%edx
  800950:	85 d2                	test   %edx,%edx
  800952:	74 15                	je     800969 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800954:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800957:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80095b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800962:	89 04 24             	mov    %eax,(%esp)
  800965:	ff d2                	call   *%edx
  800967:	eb 05                	jmp    80096e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800969:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80096e:	83 c4 24             	add    $0x24,%esp
  800971:	5b                   	pop    %ebx
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <seek>:

int
seek(int fdnum, off_t offset)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80097a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80097d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 04 24             	mov    %eax,(%esp)
  800987:	e8 ea fb ff ff       	call   800576 <fd_lookup>
  80098c:	85 c0                	test   %eax,%eax
  80098e:	78 0e                	js     80099e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800990:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800999:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099e:	c9                   	leave  
  80099f:	c3                   	ret    

008009a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	53                   	push   %ebx
  8009a4:	83 ec 24             	sub    $0x24,%esp
  8009a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b1:	89 1c 24             	mov    %ebx,(%esp)
  8009b4:	e8 bd fb ff ff       	call   800576 <fd_lookup>
  8009b9:	89 c2                	mov    %eax,%edx
  8009bb:	85 d2                	test   %edx,%edx
  8009bd:	78 61                	js     800a20 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	89 04 24             	mov    %eax,(%esp)
  8009ce:	e8 f9 fb ff ff       	call   8005cc <dev_lookup>
  8009d3:	85 c0                	test   %eax,%eax
  8009d5:	78 49                	js     800a20 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009de:	75 23                	jne    800a03 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8009e0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009e5:	8b 40 48             	mov    0x48(%eax),%eax
  8009e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f0:	c7 04 24 58 27 80 00 	movl   $0x802758,(%esp)
  8009f7:	e8 53 0f 00 00       	call   80194f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a01:	eb 1d                	jmp    800a20 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  800a03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a06:	8b 52 18             	mov    0x18(%edx),%edx
  800a09:	85 d2                	test   %edx,%edx
  800a0b:	74 0e                	je     800a1b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800a0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a10:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a14:	89 04 24             	mov    %eax,(%esp)
  800a17:	ff d2                	call   *%edx
  800a19:	eb 05                	jmp    800a20 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800a1b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800a20:	83 c4 24             	add    $0x24,%esp
  800a23:	5b                   	pop    %ebx
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	53                   	push   %ebx
  800a2a:	83 ec 24             	sub    $0x24,%esp
  800a2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a30:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	89 04 24             	mov    %eax,(%esp)
  800a3d:	e8 34 fb ff ff       	call   800576 <fd_lookup>
  800a42:	89 c2                	mov    %eax,%edx
  800a44:	85 d2                	test   %edx,%edx
  800a46:	78 52                	js     800a9a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a52:	8b 00                	mov    (%eax),%eax
  800a54:	89 04 24             	mov    %eax,(%esp)
  800a57:	e8 70 fb ff ff       	call   8005cc <dev_lookup>
  800a5c:	85 c0                	test   %eax,%eax
  800a5e:	78 3a                	js     800a9a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a63:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a67:	74 2c                	je     800a95 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a69:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a6c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a73:	00 00 00 
	stat->st_isdir = 0;
  800a76:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a7d:	00 00 00 
	stat->st_dev = dev;
  800a80:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a8d:	89 14 24             	mov    %edx,(%esp)
  800a90:	ff 50 14             	call   *0x14(%eax)
  800a93:	eb 05                	jmp    800a9a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a95:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a9a:	83 c4 24             	add    $0x24,%esp
  800a9d:	5b                   	pop    %ebx
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	56                   	push   %esi
  800aa4:	53                   	push   %ebx
  800aa5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800aa8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800aaf:	00 
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	89 04 24             	mov    %eax,(%esp)
  800ab6:	e8 99 02 00 00       	call   800d54 <open>
  800abb:	89 c3                	mov    %eax,%ebx
  800abd:	85 db                	test   %ebx,%ebx
  800abf:	78 1b                	js     800adc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac8:	89 1c 24             	mov    %ebx,(%esp)
  800acb:	e8 56 ff ff ff       	call   800a26 <fstat>
  800ad0:	89 c6                	mov    %eax,%esi
	close(fd);
  800ad2:	89 1c 24             	mov    %ebx,(%esp)
  800ad5:	e8 cd fb ff ff       	call   8006a7 <close>
	return r;
  800ada:	89 f0                	mov    %esi,%eax
}
  800adc:	83 c4 10             	add    $0x10,%esp
  800adf:	5b                   	pop    %ebx
  800ae0:	5e                   	pop    %esi
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	56                   	push   %esi
  800ae7:	53                   	push   %ebx
  800ae8:	83 ec 10             	sub    $0x10,%esp
  800aeb:	89 c6                	mov    %eax,%esi
  800aed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800aef:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800af6:	75 11                	jne    800b09 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800af8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800aff:	e8 eb 18 00 00       	call   8023ef <ipc_find_env>
  800b04:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800b09:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800b10:	00 
  800b11:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800b18:	00 
  800b19:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b1d:	a1 00 40 80 00       	mov    0x804000,%eax
  800b22:	89 04 24             	mov    %eax,(%esp)
  800b25:	e8 5e 18 00 00       	call   802388 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800b2a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b31:	00 
  800b32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b3d:	e8 de 17 00 00       	call   802320 <ipc_recv>
}
  800b42:	83 c4 10             	add    $0x10,%esp
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8b 40 0c             	mov    0xc(%eax),%eax
  800b55:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800b62:	ba 00 00 00 00       	mov    $0x0,%edx
  800b67:	b8 02 00 00 00       	mov    $0x2,%eax
  800b6c:	e8 72 ff ff ff       	call   800ae3 <fsipc>
}
  800b71:	c9                   	leave  
  800b72:	c3                   	ret    

00800b73 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 40 0c             	mov    0xc(%eax),%eax
  800b7f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b84:	ba 00 00 00 00       	mov    $0x0,%edx
  800b89:	b8 06 00 00 00       	mov    $0x6,%eax
  800b8e:	e8 50 ff ff ff       	call   800ae3 <fsipc>
}
  800b93:	c9                   	leave  
  800b94:	c3                   	ret    

00800b95 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	53                   	push   %ebx
  800b99:	83 ec 14             	sub    $0x14,%esp
  800b9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 40 0c             	mov    0xc(%eax),%eax
  800ba5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800baa:	ba 00 00 00 00       	mov    $0x0,%edx
  800baf:	b8 05 00 00 00       	mov    $0x5,%eax
  800bb4:	e8 2a ff ff ff       	call   800ae3 <fsipc>
  800bb9:	89 c2                	mov    %eax,%edx
  800bbb:	85 d2                	test   %edx,%edx
  800bbd:	78 2b                	js     800bea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800bbf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800bc6:	00 
  800bc7:	89 1c 24             	mov    %ebx,(%esp)
  800bca:	e8 f8 13 00 00       	call   801fc7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800bcf:	a1 80 50 80 00       	mov    0x805080,%eax
  800bd4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800bda:	a1 84 50 80 00       	mov    0x805084,%eax
  800bdf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bea:	83 c4 14             	add    $0x14,%esp
  800bed:	5b                   	pop    %ebx
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	53                   	push   %ebx
  800bf4:	83 ec 14             	sub    $0x14,%esp
  800bf7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  800bfa:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  800c00:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  800c05:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800c08:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0b:	8b 52 0c             	mov    0xc(%edx),%edx
  800c0e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  800c14:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  800c19:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c24:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800c2b:	e8 34 15 00 00       	call   802164 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  800c30:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  800c37:	00 
  800c38:	c7 04 24 c8 27 80 00 	movl   $0x8027c8,(%esp)
  800c3f:	e8 0b 0d 00 00       	call   80194f <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800c44:	ba 00 00 00 00       	mov    $0x0,%edx
  800c49:	b8 04 00 00 00       	mov    $0x4,%eax
  800c4e:	e8 90 fe ff ff       	call   800ae3 <fsipc>
  800c53:	85 c0                	test   %eax,%eax
  800c55:	78 53                	js     800caa <devfile_write+0xba>
		return r;
	assert(r <= n);
  800c57:	39 c3                	cmp    %eax,%ebx
  800c59:	73 24                	jae    800c7f <devfile_write+0x8f>
  800c5b:	c7 44 24 0c cd 27 80 	movl   $0x8027cd,0xc(%esp)
  800c62:	00 
  800c63:	c7 44 24 08 d4 27 80 	movl   $0x8027d4,0x8(%esp)
  800c6a:	00 
  800c6b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  800c72:	00 
  800c73:	c7 04 24 e9 27 80 00 	movl   $0x8027e9,(%esp)
  800c7a:	e8 d7 0b 00 00       	call   801856 <_panic>
	assert(r <= PGSIZE);
  800c7f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c84:	7e 24                	jle    800caa <devfile_write+0xba>
  800c86:	c7 44 24 0c f4 27 80 	movl   $0x8027f4,0xc(%esp)
  800c8d:	00 
  800c8e:	c7 44 24 08 d4 27 80 	movl   $0x8027d4,0x8(%esp)
  800c95:	00 
  800c96:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  800c9d:	00 
  800c9e:	c7 04 24 e9 27 80 00 	movl   $0x8027e9,(%esp)
  800ca5:	e8 ac 0b 00 00       	call   801856 <_panic>
	return r;
}
  800caa:	83 c4 14             	add    $0x14,%esp
  800cad:	5b                   	pop    %ebx
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
  800cb5:	83 ec 10             	sub    $0x10,%esp
  800cb8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8b 40 0c             	mov    0xc(%eax),%eax
  800cc1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800cc6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ccc:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd6:	e8 08 fe ff ff       	call   800ae3 <fsipc>
  800cdb:	89 c3                	mov    %eax,%ebx
  800cdd:	85 c0                	test   %eax,%eax
  800cdf:	78 6a                	js     800d4b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800ce1:	39 c6                	cmp    %eax,%esi
  800ce3:	73 24                	jae    800d09 <devfile_read+0x59>
  800ce5:	c7 44 24 0c cd 27 80 	movl   $0x8027cd,0xc(%esp)
  800cec:	00 
  800ced:	c7 44 24 08 d4 27 80 	movl   $0x8027d4,0x8(%esp)
  800cf4:	00 
  800cf5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800cfc:	00 
  800cfd:	c7 04 24 e9 27 80 00 	movl   $0x8027e9,(%esp)
  800d04:	e8 4d 0b 00 00       	call   801856 <_panic>
	assert(r <= PGSIZE);
  800d09:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800d0e:	7e 24                	jle    800d34 <devfile_read+0x84>
  800d10:	c7 44 24 0c f4 27 80 	movl   $0x8027f4,0xc(%esp)
  800d17:	00 
  800d18:	c7 44 24 08 d4 27 80 	movl   $0x8027d4,0x8(%esp)
  800d1f:	00 
  800d20:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800d27:	00 
  800d28:	c7 04 24 e9 27 80 00 	movl   $0x8027e9,(%esp)
  800d2f:	e8 22 0b 00 00       	call   801856 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800d34:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d38:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800d3f:	00 
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	89 04 24             	mov    %eax,(%esp)
  800d46:	e8 19 14 00 00       	call   802164 <memmove>
	return r;
}
  800d4b:	89 d8                	mov    %ebx,%eax
  800d4d:	83 c4 10             	add    $0x10,%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	53                   	push   %ebx
  800d58:	83 ec 24             	sub    $0x24,%esp
  800d5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800d5e:	89 1c 24             	mov    %ebx,(%esp)
  800d61:	e8 2a 12 00 00       	call   801f90 <strlen>
  800d66:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800d6b:	7f 60                	jg     800dcd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800d6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d70:	89 04 24             	mov    %eax,(%esp)
  800d73:	e8 af f7 ff ff       	call   800527 <fd_alloc>
  800d78:	89 c2                	mov    %eax,%edx
  800d7a:	85 d2                	test   %edx,%edx
  800d7c:	78 54                	js     800dd2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800d7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d82:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800d89:	e8 39 12 00 00       	call   801fc7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800d96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d99:	b8 01 00 00 00       	mov    $0x1,%eax
  800d9e:	e8 40 fd ff ff       	call   800ae3 <fsipc>
  800da3:	89 c3                	mov    %eax,%ebx
  800da5:	85 c0                	test   %eax,%eax
  800da7:	79 17                	jns    800dc0 <open+0x6c>
		fd_close(fd, 0);
  800da9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800db0:	00 
  800db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db4:	89 04 24             	mov    %eax,(%esp)
  800db7:	e8 6a f8 ff ff       	call   800626 <fd_close>
		return r;
  800dbc:	89 d8                	mov    %ebx,%eax
  800dbe:	eb 12                	jmp    800dd2 <open+0x7e>
	}

	return fd2num(fd);
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc3:	89 04 24             	mov    %eax,(%esp)
  800dc6:	e8 35 f7 ff ff       	call   800500 <fd2num>
  800dcb:	eb 05                	jmp    800dd2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800dcd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800dd2:	83 c4 24             	add    $0x24,%esp
  800dd5:	5b                   	pop    %ebx
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800dde:	ba 00 00 00 00       	mov    $0x0,%edx
  800de3:	b8 08 00 00 00       	mov    $0x8,%eax
  800de8:	e8 f6 fc ff ff       	call   800ae3 <fsipc>
}
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <evict>:

int evict(void)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  800df5:	c7 04 24 00 28 80 00 	movl   $0x802800,(%esp)
  800dfc:	e8 4e 0b 00 00       	call   80194f <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  800e01:	ba 00 00 00 00       	mov    $0x0,%edx
  800e06:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0b:	e8 d3 fc ff ff       	call   800ae3 <fsipc>
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    
  800e12:	66 90                	xchg   %ax,%ax
  800e14:	66 90                	xchg   %ax,%ax
  800e16:	66 90                	xchg   %ax,%ax
  800e18:	66 90                	xchg   %ax,%ax
  800e1a:	66 90                	xchg   %ax,%ax
  800e1c:	66 90                	xchg   %ax,%ax
  800e1e:	66 90                	xchg   %ax,%ax

00800e20 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800e26:	c7 44 24 04 19 28 80 	movl   $0x802819,0x4(%esp)
  800e2d:	00 
  800e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e31:	89 04 24             	mov    %eax,(%esp)
  800e34:	e8 8e 11 00 00       	call   801fc7 <strcpy>
	return 0;
}
  800e39:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	53                   	push   %ebx
  800e44:	83 ec 14             	sub    $0x14,%esp
  800e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800e4a:	89 1c 24             	mov    %ebx,(%esp)
  800e4d:	e8 d5 15 00 00       	call   802427 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800e52:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800e57:	83 f8 01             	cmp    $0x1,%eax
  800e5a:	75 0d                	jne    800e69 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800e5c:	8b 43 0c             	mov    0xc(%ebx),%eax
  800e5f:	89 04 24             	mov    %eax,(%esp)
  800e62:	e8 29 03 00 00       	call   801190 <nsipc_close>
  800e67:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	83 c4 14             	add    $0x14,%esp
  800e6e:	5b                   	pop    %ebx
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    

00800e71 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800e77:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e7e:	00 
  800e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e82:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8b 40 0c             	mov    0xc(%eax),%eax
  800e93:	89 04 24             	mov    %eax,(%esp)
  800e96:	e8 f0 03 00 00       	call   80128b <nsipc_send>
}
  800e9b:	c9                   	leave  
  800e9c:	c3                   	ret    

00800e9d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800ea3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800eaa:	00 
  800eab:	8b 45 10             	mov    0x10(%ebp),%eax
  800eae:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8b 40 0c             	mov    0xc(%eax),%eax
  800ebf:	89 04 24             	mov    %eax,(%esp)
  800ec2:	e8 44 03 00 00       	call   80120b <nsipc_recv>
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800ecf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800ed2:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ed6:	89 04 24             	mov    %eax,(%esp)
  800ed9:	e8 98 f6 ff ff       	call   800576 <fd_lookup>
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	78 17                	js     800ef9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800eeb:	39 08                	cmp    %ecx,(%eax)
  800eed:	75 05                	jne    800ef4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800eef:	8b 40 0c             	mov    0xc(%eax),%eax
  800ef2:	eb 05                	jmp    800ef9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800ef4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	56                   	push   %esi
  800eff:	53                   	push   %ebx
  800f00:	83 ec 20             	sub    $0x20,%esp
  800f03:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f08:	89 04 24             	mov    %eax,(%esp)
  800f0b:	e8 17 f6 ff ff       	call   800527 <fd_alloc>
  800f10:	89 c3                	mov    %eax,%ebx
  800f12:	85 c0                	test   %eax,%eax
  800f14:	78 21                	js     800f37 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800f16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f1d:	00 
  800f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f21:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f2c:	e8 c4 f2 ff ff       	call   8001f5 <sys_page_alloc>
  800f31:	89 c3                	mov    %eax,%ebx
  800f33:	85 c0                	test   %eax,%eax
  800f35:	79 0c                	jns    800f43 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800f37:	89 34 24             	mov    %esi,(%esp)
  800f3a:	e8 51 02 00 00       	call   801190 <nsipc_close>
		return r;
  800f3f:	89 d8                	mov    %ebx,%eax
  800f41:	eb 20                	jmp    800f63 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f43:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f51:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800f58:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800f5b:	89 14 24             	mov    %edx,(%esp)
  800f5e:	e8 9d f5 ff ff       	call   800500 <fd2num>
}
  800f63:	83 c4 20             	add    $0x20,%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	e8 51 ff ff ff       	call   800ec9 <fd2sockid>
		return r;
  800f78:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	78 23                	js     800fa1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f7e:	8b 55 10             	mov    0x10(%ebp),%edx
  800f81:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f88:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f8c:	89 04 24             	mov    %eax,(%esp)
  800f8f:	e8 45 01 00 00       	call   8010d9 <nsipc_accept>
		return r;
  800f94:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f96:	85 c0                	test   %eax,%eax
  800f98:	78 07                	js     800fa1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800f9a:	e8 5c ff ff ff       	call   800efb <alloc_sockfd>
  800f9f:	89 c1                	mov    %eax,%ecx
}
  800fa1:	89 c8                	mov    %ecx,%eax
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	e8 16 ff ff ff       	call   800ec9 <fd2sockid>
  800fb3:	89 c2                	mov    %eax,%edx
  800fb5:	85 d2                	test   %edx,%edx
  800fb7:	78 16                	js     800fcf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fc7:	89 14 24             	mov    %edx,(%esp)
  800fca:	e8 60 01 00 00       	call   80112f <nsipc_bind>
}
  800fcf:	c9                   	leave  
  800fd0:	c3                   	ret    

00800fd1 <shutdown>:

int
shutdown(int s, int how)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	e8 ea fe ff ff       	call   800ec9 <fd2sockid>
  800fdf:	89 c2                	mov    %eax,%edx
  800fe1:	85 d2                	test   %edx,%edx
  800fe3:	78 0f                	js     800ff4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fec:	89 14 24             	mov    %edx,(%esp)
  800fef:	e8 7a 01 00 00       	call   80116e <nsipc_shutdown>
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	e8 c5 fe ff ff       	call   800ec9 <fd2sockid>
  801004:	89 c2                	mov    %eax,%edx
  801006:	85 d2                	test   %edx,%edx
  801008:	78 16                	js     801020 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80100a:	8b 45 10             	mov    0x10(%ebp),%eax
  80100d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801011:	8b 45 0c             	mov    0xc(%ebp),%eax
  801014:	89 44 24 04          	mov    %eax,0x4(%esp)
  801018:	89 14 24             	mov    %edx,(%esp)
  80101b:	e8 8a 01 00 00       	call   8011aa <nsipc_connect>
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <listen>:

int
listen(int s, int backlog)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	e8 99 fe ff ff       	call   800ec9 <fd2sockid>
  801030:	89 c2                	mov    %eax,%edx
  801032:	85 d2                	test   %edx,%edx
  801034:	78 0f                	js     801045 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80103d:	89 14 24             	mov    %edx,(%esp)
  801040:	e8 a4 01 00 00       	call   8011e9 <nsipc_listen>
}
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80104d:	8b 45 10             	mov    0x10(%ebp),%eax
  801050:	89 44 24 08          	mov    %eax,0x8(%esp)
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	89 44 24 04          	mov    %eax,0x4(%esp)
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	89 04 24             	mov    %eax,(%esp)
  801061:	e8 98 02 00 00       	call   8012fe <nsipc_socket>
  801066:	89 c2                	mov    %eax,%edx
  801068:	85 d2                	test   %edx,%edx
  80106a:	78 05                	js     801071 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80106c:	e8 8a fe ff ff       	call   800efb <alloc_sockfd>
}
  801071:	c9                   	leave  
  801072:	c3                   	ret    

00801073 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	53                   	push   %ebx
  801077:	83 ec 14             	sub    $0x14,%esp
  80107a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80107c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801083:	75 11                	jne    801096 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801085:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80108c:	e8 5e 13 00 00       	call   8023ef <ipc_find_env>
  801091:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801096:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80109d:	00 
  80109e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8010a5:	00 
  8010a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010aa:	a1 04 40 80 00       	mov    0x804004,%eax
  8010af:	89 04 24             	mov    %eax,(%esp)
  8010b2:	e8 d1 12 00 00       	call   802388 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8010b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010be:	00 
  8010bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8010c6:	00 
  8010c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010ce:	e8 4d 12 00 00       	call   802320 <ipc_recv>
}
  8010d3:	83 c4 14             	add    $0x14,%esp
  8010d6:	5b                   	pop    %ebx
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	56                   	push   %esi
  8010dd:	53                   	push   %ebx
  8010de:	83 ec 10             	sub    $0x10,%esp
  8010e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8010ec:	8b 06                	mov    (%esi),%eax
  8010ee:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8010f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8010f8:	e8 76 ff ff ff       	call   801073 <nsipc>
  8010fd:	89 c3                	mov    %eax,%ebx
  8010ff:	85 c0                	test   %eax,%eax
  801101:	78 23                	js     801126 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801103:	a1 10 60 80 00       	mov    0x806010,%eax
  801108:	89 44 24 08          	mov    %eax,0x8(%esp)
  80110c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801113:	00 
  801114:	8b 45 0c             	mov    0xc(%ebp),%eax
  801117:	89 04 24             	mov    %eax,(%esp)
  80111a:	e8 45 10 00 00       	call   802164 <memmove>
		*addrlen = ret->ret_addrlen;
  80111f:	a1 10 60 80 00       	mov    0x806010,%eax
  801124:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801126:	89 d8                	mov    %ebx,%eax
  801128:	83 c4 10             	add    $0x10,%esp
  80112b:	5b                   	pop    %ebx
  80112c:	5e                   	pop    %esi
  80112d:	5d                   	pop    %ebp
  80112e:	c3                   	ret    

0080112f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	53                   	push   %ebx
  801133:	83 ec 14             	sub    $0x14,%esp
  801136:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801141:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	89 44 24 04          	mov    %eax,0x4(%esp)
  80114c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801153:	e8 0c 10 00 00       	call   802164 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801158:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80115e:	b8 02 00 00 00       	mov    $0x2,%eax
  801163:	e8 0b ff ff ff       	call   801073 <nsipc>
}
  801168:	83 c4 14             	add    $0x14,%esp
  80116b:	5b                   	pop    %ebx
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801184:	b8 03 00 00 00       	mov    $0x3,%eax
  801189:	e8 e5 fe ff ff       	call   801073 <nsipc>
}
  80118e:	c9                   	leave  
  80118f:	c3                   	ret    

00801190 <nsipc_close>:

int
nsipc_close(int s)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80119e:	b8 04 00 00 00       	mov    $0x4,%eax
  8011a3:	e8 cb fe ff ff       	call   801073 <nsipc>
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	53                   	push   %ebx
  8011ae:	83 ec 14             	sub    $0x14,%esp
  8011b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8011bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8011ce:	e8 91 0f 00 00       	call   802164 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8011d3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8011d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8011de:	e8 90 fe ff ff       	call   801073 <nsipc>
}
  8011e3:	83 c4 14             	add    $0x14,%esp
  8011e6:	5b                   	pop    %ebx
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    

008011e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8011ff:	b8 06 00 00 00       	mov    $0x6,%eax
  801204:	e8 6a fe ff ff       	call   801073 <nsipc>
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	56                   	push   %esi
  80120f:	53                   	push   %ebx
  801210:	83 ec 10             	sub    $0x10,%esp
  801213:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80121e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801224:	8b 45 14             	mov    0x14(%ebp),%eax
  801227:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80122c:	b8 07 00 00 00       	mov    $0x7,%eax
  801231:	e8 3d fe ff ff       	call   801073 <nsipc>
  801236:	89 c3                	mov    %eax,%ebx
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 46                	js     801282 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80123c:	39 f0                	cmp    %esi,%eax
  80123e:	7f 07                	jg     801247 <nsipc_recv+0x3c>
  801240:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801245:	7e 24                	jle    80126b <nsipc_recv+0x60>
  801247:	c7 44 24 0c 25 28 80 	movl   $0x802825,0xc(%esp)
  80124e:	00 
  80124f:	c7 44 24 08 d4 27 80 	movl   $0x8027d4,0x8(%esp)
  801256:	00 
  801257:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80125e:	00 
  80125f:	c7 04 24 3a 28 80 00 	movl   $0x80283a,(%esp)
  801266:	e8 eb 05 00 00       	call   801856 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80126b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80126f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801276:	00 
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	89 04 24             	mov    %eax,(%esp)
  80127d:	e8 e2 0e 00 00       	call   802164 <memmove>
	}

	return r;
}
  801282:	89 d8                	mov    %ebx,%eax
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	5b                   	pop    %ebx
  801288:	5e                   	pop    %esi
  801289:	5d                   	pop    %ebp
  80128a:	c3                   	ret    

0080128b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	53                   	push   %ebx
  80128f:	83 ec 14             	sub    $0x14,%esp
  801292:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80129d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012a3:	7e 24                	jle    8012c9 <nsipc_send+0x3e>
  8012a5:	c7 44 24 0c 46 28 80 	movl   $0x802846,0xc(%esp)
  8012ac:	00 
  8012ad:	c7 44 24 08 d4 27 80 	movl   $0x8027d4,0x8(%esp)
  8012b4:	00 
  8012b5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8012bc:	00 
  8012bd:	c7 04 24 3a 28 80 00 	movl   $0x80283a,(%esp)
  8012c4:	e8 8d 05 00 00       	call   801856 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8012db:	e8 84 0e 00 00       	call   802164 <memmove>
	nsipcbuf.send.req_size = size;
  8012e0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8012ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8012f3:	e8 7b fd ff ff       	call   801073 <nsipc>
}
  8012f8:	83 c4 14             	add    $0x14,%esp
  8012fb:	5b                   	pop    %ebx
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    

008012fe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801314:	8b 45 10             	mov    0x10(%ebp),%eax
  801317:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80131c:	b8 09 00 00 00       	mov    $0x9,%eax
  801321:	e8 4d fd ff ff       	call   801073 <nsipc>
}
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	56                   	push   %esi
  80132c:	53                   	push   %ebx
  80132d:	83 ec 10             	sub    $0x10,%esp
  801330:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	89 04 24             	mov    %eax,(%esp)
  801339:	e8 d2 f1 ff ff       	call   800510 <fd2data>
  80133e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801340:	c7 44 24 04 52 28 80 	movl   $0x802852,0x4(%esp)
  801347:	00 
  801348:	89 1c 24             	mov    %ebx,(%esp)
  80134b:	e8 77 0c 00 00       	call   801fc7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801350:	8b 46 04             	mov    0x4(%esi),%eax
  801353:	2b 06                	sub    (%esi),%eax
  801355:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80135b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801362:	00 00 00 
	stat->st_dev = &devpipe;
  801365:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80136c:	30 80 00 
	return 0;
}
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	5b                   	pop    %ebx
  801378:	5e                   	pop    %esi
  801379:	5d                   	pop    %ebp
  80137a:	c3                   	ret    

0080137b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	53                   	push   %ebx
  80137f:	83 ec 14             	sub    $0x14,%esp
  801382:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801385:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801389:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801390:	e8 07 ef ff ff       	call   80029c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801395:	89 1c 24             	mov    %ebx,(%esp)
  801398:	e8 73 f1 ff ff       	call   800510 <fd2data>
  80139d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a8:	e8 ef ee ff ff       	call   80029c <sys_page_unmap>
}
  8013ad:	83 c4 14             	add    $0x14,%esp
  8013b0:	5b                   	pop    %ebx
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    

008013b3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	57                   	push   %edi
  8013b7:	56                   	push   %esi
  8013b8:	53                   	push   %ebx
  8013b9:	83 ec 2c             	sub    $0x2c,%esp
  8013bc:	89 c6                	mov    %eax,%esi
  8013be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8013c1:	a1 08 40 80 00       	mov    0x804008,%eax
  8013c6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8013c9:	89 34 24             	mov    %esi,(%esp)
  8013cc:	e8 56 10 00 00       	call   802427 <pageref>
  8013d1:	89 c7                	mov    %eax,%edi
  8013d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d6:	89 04 24             	mov    %eax,(%esp)
  8013d9:	e8 49 10 00 00       	call   802427 <pageref>
  8013de:	39 c7                	cmp    %eax,%edi
  8013e0:	0f 94 c2             	sete   %dl
  8013e3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8013e6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  8013ec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8013ef:	39 fb                	cmp    %edi,%ebx
  8013f1:	74 21                	je     801414 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8013f3:	84 d2                	test   %dl,%dl
  8013f5:	74 ca                	je     8013c1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8013f7:	8b 51 58             	mov    0x58(%ecx),%edx
  8013fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013fe:	89 54 24 08          	mov    %edx,0x8(%esp)
  801402:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801406:	c7 04 24 59 28 80 00 	movl   $0x802859,(%esp)
  80140d:	e8 3d 05 00 00       	call   80194f <cprintf>
  801412:	eb ad                	jmp    8013c1 <_pipeisclosed+0xe>
	}
}
  801414:	83 c4 2c             	add    $0x2c,%esp
  801417:	5b                   	pop    %ebx
  801418:	5e                   	pop    %esi
  801419:	5f                   	pop    %edi
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	57                   	push   %edi
  801420:	56                   	push   %esi
  801421:	53                   	push   %ebx
  801422:	83 ec 1c             	sub    $0x1c,%esp
  801425:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801428:	89 34 24             	mov    %esi,(%esp)
  80142b:	e8 e0 f0 ff ff       	call   800510 <fd2data>
  801430:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801432:	bf 00 00 00 00       	mov    $0x0,%edi
  801437:	eb 45                	jmp    80147e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801439:	89 da                	mov    %ebx,%edx
  80143b:	89 f0                	mov    %esi,%eax
  80143d:	e8 71 ff ff ff       	call   8013b3 <_pipeisclosed>
  801442:	85 c0                	test   %eax,%eax
  801444:	75 41                	jne    801487 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801446:	e8 8b ed ff ff       	call   8001d6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80144b:	8b 43 04             	mov    0x4(%ebx),%eax
  80144e:	8b 0b                	mov    (%ebx),%ecx
  801450:	8d 51 20             	lea    0x20(%ecx),%edx
  801453:	39 d0                	cmp    %edx,%eax
  801455:	73 e2                	jae    801439 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801457:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80145e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801461:	99                   	cltd   
  801462:	c1 ea 1b             	shr    $0x1b,%edx
  801465:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801468:	83 e1 1f             	and    $0x1f,%ecx
  80146b:	29 d1                	sub    %edx,%ecx
  80146d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801471:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801475:	83 c0 01             	add    $0x1,%eax
  801478:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80147b:	83 c7 01             	add    $0x1,%edi
  80147e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801481:	75 c8                	jne    80144b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801483:	89 f8                	mov    %edi,%eax
  801485:	eb 05                	jmp    80148c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801487:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80148c:	83 c4 1c             	add    $0x1c,%esp
  80148f:	5b                   	pop    %ebx
  801490:	5e                   	pop    %esi
  801491:	5f                   	pop    %edi
  801492:	5d                   	pop    %ebp
  801493:	c3                   	ret    

00801494 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	57                   	push   %edi
  801498:	56                   	push   %esi
  801499:	53                   	push   %ebx
  80149a:	83 ec 1c             	sub    $0x1c,%esp
  80149d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8014a0:	89 3c 24             	mov    %edi,(%esp)
  8014a3:	e8 68 f0 ff ff       	call   800510 <fd2data>
  8014a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014aa:	be 00 00 00 00       	mov    $0x0,%esi
  8014af:	eb 3d                	jmp    8014ee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8014b1:	85 f6                	test   %esi,%esi
  8014b3:	74 04                	je     8014b9 <devpipe_read+0x25>
				return i;
  8014b5:	89 f0                	mov    %esi,%eax
  8014b7:	eb 43                	jmp    8014fc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8014b9:	89 da                	mov    %ebx,%edx
  8014bb:	89 f8                	mov    %edi,%eax
  8014bd:	e8 f1 fe ff ff       	call   8013b3 <_pipeisclosed>
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	75 31                	jne    8014f7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8014c6:	e8 0b ed ff ff       	call   8001d6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8014cb:	8b 03                	mov    (%ebx),%eax
  8014cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8014d0:	74 df                	je     8014b1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8014d2:	99                   	cltd   
  8014d3:	c1 ea 1b             	shr    $0x1b,%edx
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	83 e0 1f             	and    $0x1f,%eax
  8014db:	29 d0                	sub    %edx,%eax
  8014dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8014e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8014e8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014eb:	83 c6 01             	add    $0x1,%esi
  8014ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014f1:	75 d8                	jne    8014cb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8014f3:	89 f0                	mov    %esi,%eax
  8014f5:	eb 05                	jmp    8014fc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8014fc:	83 c4 1c             	add    $0x1c,%esp
  8014ff:	5b                   	pop    %ebx
  801500:	5e                   	pop    %esi
  801501:	5f                   	pop    %edi
  801502:	5d                   	pop    %ebp
  801503:	c3                   	ret    

00801504 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	56                   	push   %esi
  801508:	53                   	push   %ebx
  801509:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80150c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150f:	89 04 24             	mov    %eax,(%esp)
  801512:	e8 10 f0 ff ff       	call   800527 <fd_alloc>
  801517:	89 c2                	mov    %eax,%edx
  801519:	85 d2                	test   %edx,%edx
  80151b:	0f 88 4d 01 00 00    	js     80166e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801521:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801528:	00 
  801529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801530:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801537:	e8 b9 ec ff ff       	call   8001f5 <sys_page_alloc>
  80153c:	89 c2                	mov    %eax,%edx
  80153e:	85 d2                	test   %edx,%edx
  801540:	0f 88 28 01 00 00    	js     80166e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801546:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801549:	89 04 24             	mov    %eax,(%esp)
  80154c:	e8 d6 ef ff ff       	call   800527 <fd_alloc>
  801551:	89 c3                	mov    %eax,%ebx
  801553:	85 c0                	test   %eax,%eax
  801555:	0f 88 fe 00 00 00    	js     801659 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80155b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801562:	00 
  801563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801566:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801571:	e8 7f ec ff ff       	call   8001f5 <sys_page_alloc>
  801576:	89 c3                	mov    %eax,%ebx
  801578:	85 c0                	test   %eax,%eax
  80157a:	0f 88 d9 00 00 00    	js     801659 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801583:	89 04 24             	mov    %eax,(%esp)
  801586:	e8 85 ef ff ff       	call   800510 <fd2data>
  80158b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80158d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801594:	00 
  801595:	89 44 24 04          	mov    %eax,0x4(%esp)
  801599:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a0:	e8 50 ec ff ff       	call   8001f5 <sys_page_alloc>
  8015a5:	89 c3                	mov    %eax,%ebx
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	0f 88 97 00 00 00    	js     801646 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b2:	89 04 24             	mov    %eax,(%esp)
  8015b5:	e8 56 ef ff ff       	call   800510 <fd2data>
  8015ba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8015c1:	00 
  8015c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015cd:	00 
  8015ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d9:	e8 6b ec ff ff       	call   800249 <sys_page_map>
  8015de:	89 c3                	mov    %eax,%ebx
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	78 52                	js     801636 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8015e4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8015ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8015f9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801602:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801607:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80160e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801611:	89 04 24             	mov    %eax,(%esp)
  801614:	e8 e7 ee ff ff       	call   800500 <fd2num>
  801619:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	89 04 24             	mov    %eax,(%esp)
  801624:	e8 d7 ee ff ff       	call   800500 <fd2num>
  801629:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
  801634:	eb 38                	jmp    80166e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801636:	89 74 24 04          	mov    %esi,0x4(%esp)
  80163a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801641:	e8 56 ec ff ff       	call   80029c <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801649:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801654:	e8 43 ec ff ff       	call   80029c <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801667:	e8 30 ec ff ff       	call   80029c <sys_page_unmap>
  80166c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80166e:	83 c4 30             	add    $0x30,%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5d                   	pop    %ebp
  801674:	c3                   	ret    

00801675 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80167b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	89 04 24             	mov    %eax,(%esp)
  801688:	e8 e9 ee ff ff       	call   800576 <fd_lookup>
  80168d:	89 c2                	mov    %eax,%edx
  80168f:	85 d2                	test   %edx,%edx
  801691:	78 15                	js     8016a8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801696:	89 04 24             	mov    %eax,(%esp)
  801699:	e8 72 ee ff ff       	call   800510 <fd2data>
	return _pipeisclosed(fd, p);
  80169e:	89 c2                	mov    %eax,%edx
  8016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a3:	e8 0b fd ff ff       	call   8013b3 <_pipeisclosed>
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    
  8016aa:	66 90                	xchg   %ax,%ax
  8016ac:	66 90                	xchg   %ax,%ax
  8016ae:	66 90                	xchg   %ax,%ax

008016b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8016b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b8:	5d                   	pop    %ebp
  8016b9:	c3                   	ret    

008016ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8016c0:	c7 44 24 04 71 28 80 	movl   $0x802871,0x4(%esp)
  8016c7:	00 
  8016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cb:	89 04 24             	mov    %eax,(%esp)
  8016ce:	e8 f4 08 00 00       	call   801fc7 <strcpy>
	return 0;
}
  8016d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	57                   	push   %edi
  8016de:	56                   	push   %esi
  8016df:	53                   	push   %ebx
  8016e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8016eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016f1:	eb 31                	jmp    801724 <devcons_write+0x4a>
		m = n - tot;
  8016f3:	8b 75 10             	mov    0x10(%ebp),%esi
  8016f6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8016f8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8016fb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801700:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801703:	89 74 24 08          	mov    %esi,0x8(%esp)
  801707:	03 45 0c             	add    0xc(%ebp),%eax
  80170a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170e:	89 3c 24             	mov    %edi,(%esp)
  801711:	e8 4e 0a 00 00       	call   802164 <memmove>
		sys_cputs(buf, m);
  801716:	89 74 24 04          	mov    %esi,0x4(%esp)
  80171a:	89 3c 24             	mov    %edi,(%esp)
  80171d:	e8 b4 e9 ff ff       	call   8000d6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801722:	01 f3                	add    %esi,%ebx
  801724:	89 d8                	mov    %ebx,%eax
  801726:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801729:	72 c8                	jb     8016f3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80172b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801731:	5b                   	pop    %ebx
  801732:	5e                   	pop    %esi
  801733:	5f                   	pop    %edi
  801734:	5d                   	pop    %ebp
  801735:	c3                   	ret    

00801736 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801741:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801745:	75 07                	jne    80174e <devcons_read+0x18>
  801747:	eb 2a                	jmp    801773 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801749:	e8 88 ea ff ff       	call   8001d6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80174e:	66 90                	xchg   %ax,%ax
  801750:	e8 9f e9 ff ff       	call   8000f4 <sys_cgetc>
  801755:	85 c0                	test   %eax,%eax
  801757:	74 f0                	je     801749 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801759:	85 c0                	test   %eax,%eax
  80175b:	78 16                	js     801773 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80175d:	83 f8 04             	cmp    $0x4,%eax
  801760:	74 0c                	je     80176e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801762:	8b 55 0c             	mov    0xc(%ebp),%edx
  801765:	88 02                	mov    %al,(%edx)
	return 1;
  801767:	b8 01 00 00 00       	mov    $0x1,%eax
  80176c:	eb 05                	jmp    801773 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801781:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801788:	00 
  801789:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80178c:	89 04 24             	mov    %eax,(%esp)
  80178f:	e8 42 e9 ff ff       	call   8000d6 <sys_cputs>
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <getchar>:

int
getchar(void)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80179c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017a3:	00 
  8017a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8017a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017b2:	e8 53 f0 ff ff       	call   80080a <read>
	if (r < 0)
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	78 0f                	js     8017ca <getchar+0x34>
		return r;
	if (r < 1)
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	7e 06                	jle    8017c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8017bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8017c3:	eb 05                	jmp    8017ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8017c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	89 04 24             	mov    %eax,(%esp)
  8017df:	e8 92 ed ff ff       	call   800576 <fd_lookup>
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	78 11                	js     8017f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017eb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8017f1:	39 10                	cmp    %edx,(%eax)
  8017f3:	0f 94 c0             	sete   %al
  8017f6:	0f b6 c0             	movzbl %al,%eax
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <opencons>:

int
opencons(void)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801801:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801804:	89 04 24             	mov    %eax,(%esp)
  801807:	e8 1b ed ff ff       	call   800527 <fd_alloc>
		return r;
  80180c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80180e:	85 c0                	test   %eax,%eax
  801810:	78 40                	js     801852 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801812:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801819:	00 
  80181a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801821:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801828:	e8 c8 e9 ff ff       	call   8001f5 <sys_page_alloc>
		return r;
  80182d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 1f                	js     801852 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801833:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80183e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801841:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801848:	89 04 24             	mov    %eax,(%esp)
  80184b:	e8 b0 ec ff ff       	call   800500 <fd2num>
  801850:	89 c2                	mov    %eax,%edx
}
  801852:	89 d0                	mov    %edx,%eax
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	56                   	push   %esi
  80185a:	53                   	push   %ebx
  80185b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80185e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801861:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801867:	e8 4b e9 ff ff       	call   8001b7 <sys_getenvid>
  80186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801873:	8b 55 08             	mov    0x8(%ebp),%edx
  801876:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80187a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80187e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801882:	c7 04 24 80 28 80 00 	movl   $0x802880,(%esp)
  801889:	e8 c1 00 00 00       	call   80194f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80188e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801892:	8b 45 10             	mov    0x10(%ebp),%eax
  801895:	89 04 24             	mov    %eax,(%esp)
  801898:	e8 51 00 00 00       	call   8018ee <vcprintf>
	cprintf("\n");
  80189d:	c7 04 24 17 28 80 00 	movl   $0x802817,(%esp)
  8018a4:	e8 a6 00 00 00       	call   80194f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8018a9:	cc                   	int3   
  8018aa:	eb fd                	jmp    8018a9 <_panic+0x53>

008018ac <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	53                   	push   %ebx
  8018b0:	83 ec 14             	sub    $0x14,%esp
  8018b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8018b6:	8b 13                	mov    (%ebx),%edx
  8018b8:	8d 42 01             	lea    0x1(%edx),%eax
  8018bb:	89 03                	mov    %eax,(%ebx)
  8018bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8018c4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8018c9:	75 19                	jne    8018e4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8018cb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8018d2:	00 
  8018d3:	8d 43 08             	lea    0x8(%ebx),%eax
  8018d6:	89 04 24             	mov    %eax,(%esp)
  8018d9:	e8 f8 e7 ff ff       	call   8000d6 <sys_cputs>
		b->idx = 0;
  8018de:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8018e4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8018e8:	83 c4 14             	add    $0x14,%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5d                   	pop    %ebp
  8018ed:	c3                   	ret    

008018ee <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8018f7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018fe:	00 00 00 
	b.cnt = 0;
  801901:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801908:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80190b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	89 44 24 08          	mov    %eax,0x8(%esp)
  801919:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80191f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801923:	c7 04 24 ac 18 80 00 	movl   $0x8018ac,(%esp)
  80192a:	e8 75 01 00 00       	call   801aa4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80192f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801935:	89 44 24 04          	mov    %eax,0x4(%esp)
  801939:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80193f:	89 04 24             	mov    %eax,(%esp)
  801942:	e8 8f e7 ff ff       	call   8000d6 <sys_cputs>

	return b.cnt;
}
  801947:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801955:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	89 04 24             	mov    %eax,(%esp)
  801962:	e8 87 ff ff ff       	call   8018ee <vcprintf>
	va_end(ap);

	return cnt;
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    
  801969:	66 90                	xchg   %ax,%ax
  80196b:	66 90                	xchg   %ax,%ax
  80196d:	66 90                	xchg   %ax,%ax
  80196f:	90                   	nop

00801970 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	57                   	push   %edi
  801974:	56                   	push   %esi
  801975:	53                   	push   %ebx
  801976:	83 ec 3c             	sub    $0x3c,%esp
  801979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80197c:	89 d7                	mov    %edx,%edi
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801984:	8b 45 0c             	mov    0xc(%ebp),%eax
  801987:	89 c3                	mov    %eax,%ebx
  801989:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80198c:	8b 45 10             	mov    0x10(%ebp),%eax
  80198f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801992:	b9 00 00 00 00       	mov    $0x0,%ecx
  801997:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80199a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80199d:	39 d9                	cmp    %ebx,%ecx
  80199f:	72 05                	jb     8019a6 <printnum+0x36>
  8019a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8019a4:	77 69                	ja     801a0f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8019a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8019a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8019ad:	83 ee 01             	sub    $0x1,%esi
  8019b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8019c0:	89 c3                	mov    %eax,%ebx
  8019c2:	89 d6                	mov    %edx,%esi
  8019c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8019ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019ce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d5:	89 04 24             	mov    %eax,(%esp)
  8019d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019df:	e8 8c 0a 00 00       	call   802470 <__udivdi3>
  8019e4:	89 d9                	mov    %ebx,%ecx
  8019e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019ee:	89 04 24             	mov    %eax,(%esp)
  8019f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019f5:	89 fa                	mov    %edi,%edx
  8019f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019fa:	e8 71 ff ff ff       	call   801970 <printnum>
  8019ff:	eb 1b                	jmp    801a1c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801a01:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a05:	8b 45 18             	mov    0x18(%ebp),%eax
  801a08:	89 04 24             	mov    %eax,(%esp)
  801a0b:	ff d3                	call   *%ebx
  801a0d:	eb 03                	jmp    801a12 <printnum+0xa2>
  801a0f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801a12:	83 ee 01             	sub    $0x1,%esi
  801a15:	85 f6                	test   %esi,%esi
  801a17:	7f e8                	jg     801a01 <printnum+0x91>
  801a19:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801a1c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a20:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801a24:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a27:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a2e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a35:	89 04 24             	mov    %eax,(%esp)
  801a38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3f:	e8 5c 0b 00 00       	call   8025a0 <__umoddi3>
  801a44:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a48:	0f be 80 a3 28 80 00 	movsbl 0x8028a3(%eax),%eax
  801a4f:	89 04 24             	mov    %eax,(%esp)
  801a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a55:	ff d0                	call   *%eax
}
  801a57:	83 c4 3c             	add    $0x3c,%esp
  801a5a:	5b                   	pop    %ebx
  801a5b:	5e                   	pop    %esi
  801a5c:	5f                   	pop    %edi
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a65:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801a69:	8b 10                	mov    (%eax),%edx
  801a6b:	3b 50 04             	cmp    0x4(%eax),%edx
  801a6e:	73 0a                	jae    801a7a <sprintputch+0x1b>
		*b->buf++ = ch;
  801a70:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a73:	89 08                	mov    %ecx,(%eax)
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	88 02                	mov    %al,(%edx)
}
  801a7a:	5d                   	pop    %ebp
  801a7b:	c3                   	ret    

00801a7c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a82:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801a85:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	89 04 24             	mov    %eax,(%esp)
  801a9d:	e8 02 00 00 00       	call   801aa4 <vprintfmt>
	va_end(ap);
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	57                   	push   %edi
  801aa8:	56                   	push   %esi
  801aa9:	53                   	push   %ebx
  801aaa:	83 ec 3c             	sub    $0x3c,%esp
  801aad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ab0:	eb 17                	jmp    801ac9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	0f 84 4b 04 00 00    	je     801f05 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  801aba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801abd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ac1:	89 04 24             	mov    %eax,(%esp)
  801ac4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  801ac7:	89 fb                	mov    %edi,%ebx
  801ac9:	8d 7b 01             	lea    0x1(%ebx),%edi
  801acc:	0f b6 03             	movzbl (%ebx),%eax
  801acf:	83 f8 25             	cmp    $0x25,%eax
  801ad2:	75 de                	jne    801ab2 <vprintfmt+0xe>
  801ad4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  801ad8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801adf:	be ff ff ff ff       	mov    $0xffffffff,%esi
  801ae4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801aeb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af0:	eb 18                	jmp    801b0a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801af2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801af4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  801af8:	eb 10                	jmp    801b0a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801afa:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801afc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  801b00:	eb 08                	jmp    801b0a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801b02:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801b05:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b0a:	8d 5f 01             	lea    0x1(%edi),%ebx
  801b0d:	0f b6 17             	movzbl (%edi),%edx
  801b10:	0f b6 c2             	movzbl %dl,%eax
  801b13:	83 ea 23             	sub    $0x23,%edx
  801b16:	80 fa 55             	cmp    $0x55,%dl
  801b19:	0f 87 c2 03 00 00    	ja     801ee1 <vprintfmt+0x43d>
  801b1f:	0f b6 d2             	movzbl %dl,%edx
  801b22:	ff 24 95 e0 29 80 00 	jmp    *0x8029e0(,%edx,4)
  801b29:	89 df                	mov    %ebx,%edi
  801b2b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801b30:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  801b33:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  801b37:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  801b3a:	8d 50 d0             	lea    -0x30(%eax),%edx
  801b3d:	83 fa 09             	cmp    $0x9,%edx
  801b40:	77 33                	ja     801b75 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b42:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b45:	eb e9                	jmp    801b30 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b47:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4a:	8b 30                	mov    (%eax),%esi
  801b4c:	8d 40 04             	lea    0x4(%eax),%eax
  801b4f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b52:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801b54:	eb 1f                	jmp    801b75 <vprintfmt+0xd1>
  801b56:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801b59:	85 ff                	test   %edi,%edi
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b60:	0f 49 c7             	cmovns %edi,%eax
  801b63:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b66:	89 df                	mov    %ebx,%edi
  801b68:	eb a0                	jmp    801b0a <vprintfmt+0x66>
  801b6a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801b6c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  801b73:	eb 95                	jmp    801b0a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  801b75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b79:	79 8f                	jns    801b0a <vprintfmt+0x66>
  801b7b:	eb 85                	jmp    801b02 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b7d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b80:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801b82:	eb 86                	jmp    801b0a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b84:	8b 45 14             	mov    0x14(%ebp),%eax
  801b87:	8d 70 04             	lea    0x4(%eax),%esi
  801b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b91:	8b 45 14             	mov    0x14(%ebp),%eax
  801b94:	8b 00                	mov    (%eax),%eax
  801b96:	89 04 24             	mov    %eax,(%esp)
  801b99:	ff 55 08             	call   *0x8(%ebp)
  801b9c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  801b9f:	e9 25 ff ff ff       	jmp    801ac9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801ba4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba7:	8d 70 04             	lea    0x4(%eax),%esi
  801baa:	8b 00                	mov    (%eax),%eax
  801bac:	99                   	cltd   
  801bad:	31 d0                	xor    %edx,%eax
  801baf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801bb1:	83 f8 15             	cmp    $0x15,%eax
  801bb4:	7f 0b                	jg     801bc1 <vprintfmt+0x11d>
  801bb6:	8b 14 85 40 2b 80 00 	mov    0x802b40(,%eax,4),%edx
  801bbd:	85 d2                	test   %edx,%edx
  801bbf:	75 26                	jne    801be7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  801bc1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bc5:	c7 44 24 08 bb 28 80 	movl   $0x8028bb,0x8(%esp)
  801bcc:	00 
  801bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	89 04 24             	mov    %eax,(%esp)
  801bda:	e8 9d fe ff ff       	call   801a7c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bdf:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801be2:	e9 e2 fe ff ff       	jmp    801ac9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801be7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801beb:	c7 44 24 08 e6 27 80 	movl   $0x8027e6,0x8(%esp)
  801bf2:	00 
  801bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	89 04 24             	mov    %eax,(%esp)
  801c00:	e8 77 fe ff ff       	call   801a7c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  801c05:	89 75 14             	mov    %esi,0x14(%ebp)
  801c08:	e9 bc fe ff ff       	jmp    801ac9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c10:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801c13:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c16:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801c1a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801c1c:	85 ff                	test   %edi,%edi
  801c1e:	b8 b4 28 80 00       	mov    $0x8028b4,%eax
  801c23:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801c26:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  801c2a:	0f 84 94 00 00 00    	je     801cc4 <vprintfmt+0x220>
  801c30:	85 c9                	test   %ecx,%ecx
  801c32:	0f 8e 94 00 00 00    	jle    801ccc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c38:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c3c:	89 3c 24             	mov    %edi,(%esp)
  801c3f:	e8 64 03 00 00       	call   801fa8 <strnlen>
  801c44:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801c47:	29 c1                	sub    %eax,%ecx
  801c49:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  801c4c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  801c50:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801c53:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801c56:	8b 75 08             	mov    0x8(%ebp),%esi
  801c59:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c5c:	89 cb                	mov    %ecx,%ebx
  801c5e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c60:	eb 0f                	jmp    801c71 <vprintfmt+0x1cd>
					putch(padc, putdat);
  801c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c69:	89 3c 24             	mov    %edi,(%esp)
  801c6c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c6e:	83 eb 01             	sub    $0x1,%ebx
  801c71:	85 db                	test   %ebx,%ebx
  801c73:	7f ed                	jg     801c62 <vprintfmt+0x1be>
  801c75:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c78:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801c7b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801c7e:	85 c9                	test   %ecx,%ecx
  801c80:	b8 00 00 00 00       	mov    $0x0,%eax
  801c85:	0f 49 c1             	cmovns %ecx,%eax
  801c88:	29 c1                	sub    %eax,%ecx
  801c8a:	89 cb                	mov    %ecx,%ebx
  801c8c:	eb 44                	jmp    801cd2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801c8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c92:	74 1e                	je     801cb2 <vprintfmt+0x20e>
  801c94:	0f be d2             	movsbl %dl,%edx
  801c97:	83 ea 20             	sub    $0x20,%edx
  801c9a:	83 fa 5e             	cmp    $0x5e,%edx
  801c9d:	76 13                	jbe    801cb2 <vprintfmt+0x20e>
					putch('?', putdat);
  801c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801cad:	ff 55 08             	call   *0x8(%ebp)
  801cb0:	eb 0d                	jmp    801cbf <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  801cb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cb9:	89 04 24             	mov    %eax,(%esp)
  801cbc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801cbf:	83 eb 01             	sub    $0x1,%ebx
  801cc2:	eb 0e                	jmp    801cd2 <vprintfmt+0x22e>
  801cc4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801cc7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801cca:	eb 06                	jmp    801cd2 <vprintfmt+0x22e>
  801ccc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ccf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801cd2:	83 c7 01             	add    $0x1,%edi
  801cd5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801cd9:	0f be c2             	movsbl %dl,%eax
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	74 27                	je     801d07 <vprintfmt+0x263>
  801ce0:	85 f6                	test   %esi,%esi
  801ce2:	78 aa                	js     801c8e <vprintfmt+0x1ea>
  801ce4:	83 ee 01             	sub    $0x1,%esi
  801ce7:	79 a5                	jns    801c8e <vprintfmt+0x1ea>
  801ce9:	89 d8                	mov    %ebx,%eax
  801ceb:	8b 75 08             	mov    0x8(%ebp),%esi
  801cee:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cf1:	89 c3                	mov    %eax,%ebx
  801cf3:	eb 18                	jmp    801d0d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801cf5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cf9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801d00:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d02:	83 eb 01             	sub    $0x1,%ebx
  801d05:	eb 06                	jmp    801d0d <vprintfmt+0x269>
  801d07:	8b 75 08             	mov    0x8(%ebp),%esi
  801d0a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d0d:	85 db                	test   %ebx,%ebx
  801d0f:	7f e4                	jg     801cf5 <vprintfmt+0x251>
  801d11:	89 75 08             	mov    %esi,0x8(%ebp)
  801d14:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d1a:	e9 aa fd ff ff       	jmp    801ac9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801d1f:	83 f9 01             	cmp    $0x1,%ecx
  801d22:	7e 10                	jle    801d34 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  801d24:	8b 45 14             	mov    0x14(%ebp),%eax
  801d27:	8b 30                	mov    (%eax),%esi
  801d29:	8b 78 04             	mov    0x4(%eax),%edi
  801d2c:	8d 40 08             	lea    0x8(%eax),%eax
  801d2f:	89 45 14             	mov    %eax,0x14(%ebp)
  801d32:	eb 26                	jmp    801d5a <vprintfmt+0x2b6>
	else if (lflag)
  801d34:	85 c9                	test   %ecx,%ecx
  801d36:	74 12                	je     801d4a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  801d38:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3b:	8b 30                	mov    (%eax),%esi
  801d3d:	89 f7                	mov    %esi,%edi
  801d3f:	c1 ff 1f             	sar    $0x1f,%edi
  801d42:	8d 40 04             	lea    0x4(%eax),%eax
  801d45:	89 45 14             	mov    %eax,0x14(%ebp)
  801d48:	eb 10                	jmp    801d5a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  801d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4d:	8b 30                	mov    (%eax),%esi
  801d4f:	89 f7                	mov    %esi,%edi
  801d51:	c1 ff 1f             	sar    $0x1f,%edi
  801d54:	8d 40 04             	lea    0x4(%eax),%eax
  801d57:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d5a:	89 f0                	mov    %esi,%eax
  801d5c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801d5e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801d63:	85 ff                	test   %edi,%edi
  801d65:	0f 89 3a 01 00 00    	jns    801ea5 <vprintfmt+0x401>
				putch('-', putdat);
  801d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d72:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801d79:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801d7c:	89 f0                	mov    %esi,%eax
  801d7e:	89 fa                	mov    %edi,%edx
  801d80:	f7 d8                	neg    %eax
  801d82:	83 d2 00             	adc    $0x0,%edx
  801d85:	f7 da                	neg    %edx
			}
			base = 10;
  801d87:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d8c:	e9 14 01 00 00       	jmp    801ea5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801d91:	83 f9 01             	cmp    $0x1,%ecx
  801d94:	7e 13                	jle    801da9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  801d96:	8b 45 14             	mov    0x14(%ebp),%eax
  801d99:	8b 50 04             	mov    0x4(%eax),%edx
  801d9c:	8b 00                	mov    (%eax),%eax
  801d9e:	8b 75 14             	mov    0x14(%ebp),%esi
  801da1:	8d 4e 08             	lea    0x8(%esi),%ecx
  801da4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801da7:	eb 2c                	jmp    801dd5 <vprintfmt+0x331>
	else if (lflag)
  801da9:	85 c9                	test   %ecx,%ecx
  801dab:	74 15                	je     801dc2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  801dad:	8b 45 14             	mov    0x14(%ebp),%eax
  801db0:	8b 00                	mov    (%eax),%eax
  801db2:	ba 00 00 00 00       	mov    $0x0,%edx
  801db7:	8b 75 14             	mov    0x14(%ebp),%esi
  801dba:	8d 76 04             	lea    0x4(%esi),%esi
  801dbd:	89 75 14             	mov    %esi,0x14(%ebp)
  801dc0:	eb 13                	jmp    801dd5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  801dc2:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc5:	8b 00                	mov    (%eax),%eax
  801dc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dcc:	8b 75 14             	mov    0x14(%ebp),%esi
  801dcf:	8d 76 04             	lea    0x4(%esi),%esi
  801dd2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  801dd5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801dda:	e9 c6 00 00 00       	jmp    801ea5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801ddf:	83 f9 01             	cmp    $0x1,%ecx
  801de2:	7e 13                	jle    801df7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  801de4:	8b 45 14             	mov    0x14(%ebp),%eax
  801de7:	8b 50 04             	mov    0x4(%eax),%edx
  801dea:	8b 00                	mov    (%eax),%eax
  801dec:	8b 75 14             	mov    0x14(%ebp),%esi
  801def:	8d 4e 08             	lea    0x8(%esi),%ecx
  801df2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801df5:	eb 24                	jmp    801e1b <vprintfmt+0x377>
	else if (lflag)
  801df7:	85 c9                	test   %ecx,%ecx
  801df9:	74 11                	je     801e0c <vprintfmt+0x368>
		return va_arg(*ap, long);
  801dfb:	8b 45 14             	mov    0x14(%ebp),%eax
  801dfe:	8b 00                	mov    (%eax),%eax
  801e00:	99                   	cltd   
  801e01:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e04:	8d 71 04             	lea    0x4(%ecx),%esi
  801e07:	89 75 14             	mov    %esi,0x14(%ebp)
  801e0a:	eb 0f                	jmp    801e1b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  801e0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0f:	8b 00                	mov    (%eax),%eax
  801e11:	99                   	cltd   
  801e12:	8b 75 14             	mov    0x14(%ebp),%esi
  801e15:	8d 76 04             	lea    0x4(%esi),%esi
  801e18:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  801e1b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801e20:	e9 80 00 00 00       	jmp    801ea5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e25:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  801e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801e36:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e40:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801e47:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801e4a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e4e:	8b 06                	mov    (%esi),%eax
  801e50:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801e55:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801e5a:	eb 49                	jmp    801ea5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801e5c:	83 f9 01             	cmp    $0x1,%ecx
  801e5f:	7e 13                	jle    801e74 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  801e61:	8b 45 14             	mov    0x14(%ebp),%eax
  801e64:	8b 50 04             	mov    0x4(%eax),%edx
  801e67:	8b 00                	mov    (%eax),%eax
  801e69:	8b 75 14             	mov    0x14(%ebp),%esi
  801e6c:	8d 4e 08             	lea    0x8(%esi),%ecx
  801e6f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801e72:	eb 2c                	jmp    801ea0 <vprintfmt+0x3fc>
	else if (lflag)
  801e74:	85 c9                	test   %ecx,%ecx
  801e76:	74 15                	je     801e8d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  801e78:	8b 45 14             	mov    0x14(%ebp),%eax
  801e7b:	8b 00                	mov    (%eax),%eax
  801e7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e82:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e85:	8d 71 04             	lea    0x4(%ecx),%esi
  801e88:	89 75 14             	mov    %esi,0x14(%ebp)
  801e8b:	eb 13                	jmp    801ea0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  801e8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e90:	8b 00                	mov    (%eax),%eax
  801e92:	ba 00 00 00 00       	mov    $0x0,%edx
  801e97:	8b 75 14             	mov    0x14(%ebp),%esi
  801e9a:	8d 76 04             	lea    0x4(%esi),%esi
  801e9d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  801ea0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801ea5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  801ea9:	89 74 24 10          	mov    %esi,0x10(%esp)
  801ead:	8b 75 e0             	mov    -0x20(%ebp),%esi
  801eb0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801eb4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801eb8:	89 04 24             	mov    %eax,(%esp)
  801ebb:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	e8 a6 fa ff ff       	call   801970 <printnum>
			break;
  801eca:	e9 fa fb ff ff       	jmp    801ac9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ecf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ed2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ed6:	89 04 24             	mov    %eax,(%esp)
  801ed9:	ff 55 08             	call   *0x8(%ebp)
			break;
  801edc:	e9 e8 fb ff ff       	jmp    801ac9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801eef:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ef2:	89 fb                	mov    %edi,%ebx
  801ef4:	eb 03                	jmp    801ef9 <vprintfmt+0x455>
  801ef6:	83 eb 01             	sub    $0x1,%ebx
  801ef9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801efd:	75 f7                	jne    801ef6 <vprintfmt+0x452>
  801eff:	90                   	nop
  801f00:	e9 c4 fb ff ff       	jmp    801ac9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801f05:	83 c4 3c             	add    $0x3c,%esp
  801f08:	5b                   	pop    %ebx
  801f09:	5e                   	pop    %esi
  801f0a:	5f                   	pop    %edi
  801f0b:	5d                   	pop    %ebp
  801f0c:	c3                   	ret    

00801f0d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 28             	sub    $0x28,%esp
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f1c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801f20:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801f23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	74 30                	je     801f5e <vsnprintf+0x51>
  801f2e:	85 d2                	test   %edx,%edx
  801f30:	7e 2c                	jle    801f5e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f32:	8b 45 14             	mov    0x14(%ebp),%eax
  801f35:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f39:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f40:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f47:	c7 04 24 5f 1a 80 00 	movl   $0x801a5f,(%esp)
  801f4e:	e8 51 fb ff ff       	call   801aa4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801f53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f56:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	eb 05                	jmp    801f63 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801f5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f6b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f6e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f72:	8b 45 10             	mov    0x10(%ebp),%eax
  801f75:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	89 04 24             	mov    %eax,(%esp)
  801f86:	e8 82 ff ff ff       	call   801f0d <vsnprintf>
	va_end(ap);

	return rc;
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    
  801f8d:	66 90                	xchg   %ax,%ax
  801f8f:	90                   	nop

00801f90 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9b:	eb 03                	jmp    801fa0 <strlen+0x10>
		n++;
  801f9d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801fa0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801fa4:	75 f7                	jne    801f9d <strlen+0xd>
		n++;
	return n;
}
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    

00801fa8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb6:	eb 03                	jmp    801fbb <strnlen+0x13>
		n++;
  801fb8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fbb:	39 d0                	cmp    %edx,%eax
  801fbd:	74 06                	je     801fc5 <strnlen+0x1d>
  801fbf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801fc3:	75 f3                	jne    801fb8 <strnlen+0x10>
		n++;
	return n;
}
  801fc5:	5d                   	pop    %ebp
  801fc6:	c3                   	ret    

00801fc7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	53                   	push   %ebx
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801fd1:	89 c2                	mov    %eax,%edx
  801fd3:	83 c2 01             	add    $0x1,%edx
  801fd6:	83 c1 01             	add    $0x1,%ecx
  801fd9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801fdd:	88 5a ff             	mov    %bl,-0x1(%edx)
  801fe0:	84 db                	test   %bl,%bl
  801fe2:	75 ef                	jne    801fd3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801fe4:	5b                   	pop    %ebx
  801fe5:	5d                   	pop    %ebp
  801fe6:	c3                   	ret    

00801fe7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	53                   	push   %ebx
  801feb:	83 ec 08             	sub    $0x8,%esp
  801fee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ff1:	89 1c 24             	mov    %ebx,(%esp)
  801ff4:	e8 97 ff ff ff       	call   801f90 <strlen>
	strcpy(dst + len, src);
  801ff9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffc:	89 54 24 04          	mov    %edx,0x4(%esp)
  802000:	01 d8                	add    %ebx,%eax
  802002:	89 04 24             	mov    %eax,(%esp)
  802005:	e8 bd ff ff ff       	call   801fc7 <strcpy>
	return dst;
}
  80200a:	89 d8                	mov    %ebx,%eax
  80200c:	83 c4 08             	add    $0x8,%esp
  80200f:	5b                   	pop    %ebx
  802010:	5d                   	pop    %ebp
  802011:	c3                   	ret    

00802012 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	56                   	push   %esi
  802016:	53                   	push   %ebx
  802017:	8b 75 08             	mov    0x8(%ebp),%esi
  80201a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80201d:	89 f3                	mov    %esi,%ebx
  80201f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802022:	89 f2                	mov    %esi,%edx
  802024:	eb 0f                	jmp    802035 <strncpy+0x23>
		*dst++ = *src;
  802026:	83 c2 01             	add    $0x1,%edx
  802029:	0f b6 01             	movzbl (%ecx),%eax
  80202c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80202f:	80 39 01             	cmpb   $0x1,(%ecx)
  802032:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802035:	39 da                	cmp    %ebx,%edx
  802037:	75 ed                	jne    802026 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  802039:	89 f0                	mov    %esi,%eax
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5d                   	pop    %ebp
  80203e:	c3                   	ret    

0080203f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	56                   	push   %esi
  802043:	53                   	push   %ebx
  802044:	8b 75 08             	mov    0x8(%ebp),%esi
  802047:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204d:	89 f0                	mov    %esi,%eax
  80204f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802053:	85 c9                	test   %ecx,%ecx
  802055:	75 0b                	jne    802062 <strlcpy+0x23>
  802057:	eb 1d                	jmp    802076 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802059:	83 c0 01             	add    $0x1,%eax
  80205c:	83 c2 01             	add    $0x1,%edx
  80205f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802062:	39 d8                	cmp    %ebx,%eax
  802064:	74 0b                	je     802071 <strlcpy+0x32>
  802066:	0f b6 0a             	movzbl (%edx),%ecx
  802069:	84 c9                	test   %cl,%cl
  80206b:	75 ec                	jne    802059 <strlcpy+0x1a>
  80206d:	89 c2                	mov    %eax,%edx
  80206f:	eb 02                	jmp    802073 <strlcpy+0x34>
  802071:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  802073:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  802076:	29 f0                	sub    %esi,%eax
}
  802078:	5b                   	pop    %ebx
  802079:	5e                   	pop    %esi
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    

0080207c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802082:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802085:	eb 06                	jmp    80208d <strcmp+0x11>
		p++, q++;
  802087:	83 c1 01             	add    $0x1,%ecx
  80208a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80208d:	0f b6 01             	movzbl (%ecx),%eax
  802090:	84 c0                	test   %al,%al
  802092:	74 04                	je     802098 <strcmp+0x1c>
  802094:	3a 02                	cmp    (%edx),%al
  802096:	74 ef                	je     802087 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802098:	0f b6 c0             	movzbl %al,%eax
  80209b:	0f b6 12             	movzbl (%edx),%edx
  80209e:	29 d0                	sub    %edx,%eax
}
  8020a0:	5d                   	pop    %ebp
  8020a1:	c3                   	ret    

008020a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
  8020a5:	53                   	push   %ebx
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ac:	89 c3                	mov    %eax,%ebx
  8020ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8020b1:	eb 06                	jmp    8020b9 <strncmp+0x17>
		n--, p++, q++;
  8020b3:	83 c0 01             	add    $0x1,%eax
  8020b6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8020b9:	39 d8                	cmp    %ebx,%eax
  8020bb:	74 15                	je     8020d2 <strncmp+0x30>
  8020bd:	0f b6 08             	movzbl (%eax),%ecx
  8020c0:	84 c9                	test   %cl,%cl
  8020c2:	74 04                	je     8020c8 <strncmp+0x26>
  8020c4:	3a 0a                	cmp    (%edx),%cl
  8020c6:	74 eb                	je     8020b3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020c8:	0f b6 00             	movzbl (%eax),%eax
  8020cb:	0f b6 12             	movzbl (%edx),%edx
  8020ce:	29 d0                	sub    %edx,%eax
  8020d0:	eb 05                	jmp    8020d7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8020d7:	5b                   	pop    %ebx
  8020d8:	5d                   	pop    %ebp
  8020d9:	c3                   	ret    

008020da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020e4:	eb 07                	jmp    8020ed <strchr+0x13>
		if (*s == c)
  8020e6:	38 ca                	cmp    %cl,%dl
  8020e8:	74 0f                	je     8020f9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020ea:	83 c0 01             	add    $0x1,%eax
  8020ed:	0f b6 10             	movzbl (%eax),%edx
  8020f0:	84 d2                	test   %dl,%dl
  8020f2:	75 f2                	jne    8020e6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f9:	5d                   	pop    %ebp
  8020fa:	c3                   	ret    

008020fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802105:	eb 07                	jmp    80210e <strfind+0x13>
		if (*s == c)
  802107:	38 ca                	cmp    %cl,%dl
  802109:	74 0a                	je     802115 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80210b:	83 c0 01             	add    $0x1,%eax
  80210e:	0f b6 10             	movzbl (%eax),%edx
  802111:	84 d2                	test   %dl,%dl
  802113:	75 f2                	jne    802107 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  802115:	5d                   	pop    %ebp
  802116:	c3                   	ret    

00802117 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	57                   	push   %edi
  80211b:	56                   	push   %esi
  80211c:	53                   	push   %ebx
  80211d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802120:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802123:	85 c9                	test   %ecx,%ecx
  802125:	74 36                	je     80215d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802127:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80212d:	75 28                	jne    802157 <memset+0x40>
  80212f:	f6 c1 03             	test   $0x3,%cl
  802132:	75 23                	jne    802157 <memset+0x40>
		c &= 0xFF;
  802134:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802138:	89 d3                	mov    %edx,%ebx
  80213a:	c1 e3 08             	shl    $0x8,%ebx
  80213d:	89 d6                	mov    %edx,%esi
  80213f:	c1 e6 18             	shl    $0x18,%esi
  802142:	89 d0                	mov    %edx,%eax
  802144:	c1 e0 10             	shl    $0x10,%eax
  802147:	09 f0                	or     %esi,%eax
  802149:	09 c2                	or     %eax,%edx
  80214b:	89 d0                	mov    %edx,%eax
  80214d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80214f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802152:	fc                   	cld    
  802153:	f3 ab                	rep stos %eax,%es:(%edi)
  802155:	eb 06                	jmp    80215d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215a:	fc                   	cld    
  80215b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80215d:	89 f8                	mov    %edi,%eax
  80215f:	5b                   	pop    %ebx
  802160:	5e                   	pop    %esi
  802161:	5f                   	pop    %edi
  802162:	5d                   	pop    %ebp
  802163:	c3                   	ret    

00802164 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	57                   	push   %edi
  802168:	56                   	push   %esi
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80216f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802172:	39 c6                	cmp    %eax,%esi
  802174:	73 35                	jae    8021ab <memmove+0x47>
  802176:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802179:	39 d0                	cmp    %edx,%eax
  80217b:	73 2e                	jae    8021ab <memmove+0x47>
		s += n;
		d += n;
  80217d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802180:	89 d6                	mov    %edx,%esi
  802182:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802184:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80218a:	75 13                	jne    80219f <memmove+0x3b>
  80218c:	f6 c1 03             	test   $0x3,%cl
  80218f:	75 0e                	jne    80219f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802191:	83 ef 04             	sub    $0x4,%edi
  802194:	8d 72 fc             	lea    -0x4(%edx),%esi
  802197:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80219a:	fd                   	std    
  80219b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80219d:	eb 09                	jmp    8021a8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80219f:	83 ef 01             	sub    $0x1,%edi
  8021a2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8021a5:	fd                   	std    
  8021a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8021a8:	fc                   	cld    
  8021a9:	eb 1d                	jmp    8021c8 <memmove+0x64>
  8021ab:	89 f2                	mov    %esi,%edx
  8021ad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8021af:	f6 c2 03             	test   $0x3,%dl
  8021b2:	75 0f                	jne    8021c3 <memmove+0x5f>
  8021b4:	f6 c1 03             	test   $0x3,%cl
  8021b7:	75 0a                	jne    8021c3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8021b9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8021bc:	89 c7                	mov    %eax,%edi
  8021be:	fc                   	cld    
  8021bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8021c1:	eb 05                	jmp    8021c8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8021c3:	89 c7                	mov    %eax,%edi
  8021c5:	fc                   	cld    
  8021c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8021c8:	5e                   	pop    %esi
  8021c9:	5f                   	pop    %edi
  8021ca:	5d                   	pop    %ebp
  8021cb:	c3                   	ret    

008021cc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8021d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	89 04 24             	mov    %eax,(%esp)
  8021e6:	e8 79 ff ff ff       	call   802164 <memmove>
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	56                   	push   %esi
  8021f1:	53                   	push   %ebx
  8021f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021f8:	89 d6                	mov    %edx,%esi
  8021fa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021fd:	eb 1a                	jmp    802219 <memcmp+0x2c>
		if (*s1 != *s2)
  8021ff:	0f b6 02             	movzbl (%edx),%eax
  802202:	0f b6 19             	movzbl (%ecx),%ebx
  802205:	38 d8                	cmp    %bl,%al
  802207:	74 0a                	je     802213 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  802209:	0f b6 c0             	movzbl %al,%eax
  80220c:	0f b6 db             	movzbl %bl,%ebx
  80220f:	29 d8                	sub    %ebx,%eax
  802211:	eb 0f                	jmp    802222 <memcmp+0x35>
		s1++, s2++;
  802213:	83 c2 01             	add    $0x1,%edx
  802216:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802219:	39 f2                	cmp    %esi,%edx
  80221b:	75 e2                	jne    8021ff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80221d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802222:	5b                   	pop    %ebx
  802223:	5e                   	pop    %esi
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    

00802226 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80222f:	89 c2                	mov    %eax,%edx
  802231:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802234:	eb 07                	jmp    80223d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802236:	38 08                	cmp    %cl,(%eax)
  802238:	74 07                	je     802241 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80223a:	83 c0 01             	add    $0x1,%eax
  80223d:	39 d0                	cmp    %edx,%eax
  80223f:	72 f5                	jb     802236 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802241:	5d                   	pop    %ebp
  802242:	c3                   	ret    

00802243 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	57                   	push   %edi
  802247:	56                   	push   %esi
  802248:	53                   	push   %ebx
  802249:	8b 55 08             	mov    0x8(%ebp),%edx
  80224c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80224f:	eb 03                	jmp    802254 <strtol+0x11>
		s++;
  802251:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802254:	0f b6 0a             	movzbl (%edx),%ecx
  802257:	80 f9 09             	cmp    $0x9,%cl
  80225a:	74 f5                	je     802251 <strtol+0xe>
  80225c:	80 f9 20             	cmp    $0x20,%cl
  80225f:	74 f0                	je     802251 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802261:	80 f9 2b             	cmp    $0x2b,%cl
  802264:	75 0a                	jne    802270 <strtol+0x2d>
		s++;
  802266:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802269:	bf 00 00 00 00       	mov    $0x0,%edi
  80226e:	eb 11                	jmp    802281 <strtol+0x3e>
  802270:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802275:	80 f9 2d             	cmp    $0x2d,%cl
  802278:	75 07                	jne    802281 <strtol+0x3e>
		s++, neg = 1;
  80227a:	8d 52 01             	lea    0x1(%edx),%edx
  80227d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802281:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802286:	75 15                	jne    80229d <strtol+0x5a>
  802288:	80 3a 30             	cmpb   $0x30,(%edx)
  80228b:	75 10                	jne    80229d <strtol+0x5a>
  80228d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802291:	75 0a                	jne    80229d <strtol+0x5a>
		s += 2, base = 16;
  802293:	83 c2 02             	add    $0x2,%edx
  802296:	b8 10 00 00 00       	mov    $0x10,%eax
  80229b:	eb 10                	jmp    8022ad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80229d:	85 c0                	test   %eax,%eax
  80229f:	75 0c                	jne    8022ad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8022a1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8022a3:	80 3a 30             	cmpb   $0x30,(%edx)
  8022a6:	75 05                	jne    8022ad <strtol+0x6a>
		s++, base = 8;
  8022a8:	83 c2 01             	add    $0x1,%edx
  8022ab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8022ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022b2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8022b5:	0f b6 0a             	movzbl (%edx),%ecx
  8022b8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8022bb:	89 f0                	mov    %esi,%eax
  8022bd:	3c 09                	cmp    $0x9,%al
  8022bf:	77 08                	ja     8022c9 <strtol+0x86>
			dig = *s - '0';
  8022c1:	0f be c9             	movsbl %cl,%ecx
  8022c4:	83 e9 30             	sub    $0x30,%ecx
  8022c7:	eb 20                	jmp    8022e9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8022c9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8022cc:	89 f0                	mov    %esi,%eax
  8022ce:	3c 19                	cmp    $0x19,%al
  8022d0:	77 08                	ja     8022da <strtol+0x97>
			dig = *s - 'a' + 10;
  8022d2:	0f be c9             	movsbl %cl,%ecx
  8022d5:	83 e9 57             	sub    $0x57,%ecx
  8022d8:	eb 0f                	jmp    8022e9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8022da:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8022dd:	89 f0                	mov    %esi,%eax
  8022df:	3c 19                	cmp    $0x19,%al
  8022e1:	77 16                	ja     8022f9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8022e3:	0f be c9             	movsbl %cl,%ecx
  8022e6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8022e9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8022ec:	7d 0f                	jge    8022fd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8022ee:	83 c2 01             	add    $0x1,%edx
  8022f1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8022f5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8022f7:	eb bc                	jmp    8022b5 <strtol+0x72>
  8022f9:	89 d8                	mov    %ebx,%eax
  8022fb:	eb 02                	jmp    8022ff <strtol+0xbc>
  8022fd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8022ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802303:	74 05                	je     80230a <strtol+0xc7>
		*endptr = (char *) s;
  802305:	8b 75 0c             	mov    0xc(%ebp),%esi
  802308:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80230a:	f7 d8                	neg    %eax
  80230c:	85 ff                	test   %edi,%edi
  80230e:	0f 44 c3             	cmove  %ebx,%eax
}
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
  802316:	66 90                	xchg   %ax,%ax
  802318:	66 90                	xchg   %ax,%ax
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	56                   	push   %esi
  802324:	53                   	push   %ebx
  802325:	83 ec 10             	sub    $0x10,%esp
  802328:	8b 75 08             	mov    0x8(%ebp),%esi
  80232b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802331:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802333:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802338:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80233b:	89 04 24             	mov    %eax,(%esp)
  80233e:	e8 e8 e0 ff ff       	call   80042b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802343:	85 c0                	test   %eax,%eax
  802345:	75 26                	jne    80236d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802347:	85 f6                	test   %esi,%esi
  802349:	74 0a                	je     802355 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80234b:	a1 08 40 80 00       	mov    0x804008,%eax
  802350:	8b 40 74             	mov    0x74(%eax),%eax
  802353:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802355:	85 db                	test   %ebx,%ebx
  802357:	74 0a                	je     802363 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802359:	a1 08 40 80 00       	mov    0x804008,%eax
  80235e:	8b 40 78             	mov    0x78(%eax),%eax
  802361:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802363:	a1 08 40 80 00       	mov    0x804008,%eax
  802368:	8b 40 70             	mov    0x70(%eax),%eax
  80236b:	eb 14                	jmp    802381 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80236d:	85 f6                	test   %esi,%esi
  80236f:	74 06                	je     802377 <ipc_recv+0x57>
			*from_env_store = 0;
  802371:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802377:	85 db                	test   %ebx,%ebx
  802379:	74 06                	je     802381 <ipc_recv+0x61>
			*perm_store = 0;
  80237b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802381:	83 c4 10             	add    $0x10,%esp
  802384:	5b                   	pop    %ebx
  802385:	5e                   	pop    %esi
  802386:	5d                   	pop    %ebp
  802387:	c3                   	ret    

00802388 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	57                   	push   %edi
  80238c:	56                   	push   %esi
  80238d:	53                   	push   %ebx
  80238e:	83 ec 1c             	sub    $0x1c,%esp
  802391:	8b 7d 08             	mov    0x8(%ebp),%edi
  802394:	8b 75 0c             	mov    0xc(%ebp),%esi
  802397:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80239a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80239c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8023a1:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8023a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023af:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023b3:	89 3c 24             	mov    %edi,(%esp)
  8023b6:	e8 4d e0 ff ff       	call   800408 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	74 28                	je     8023e7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  8023bf:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023c2:	74 1c                	je     8023e0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  8023c4:	c7 44 24 08 b8 2b 80 	movl   $0x802bb8,0x8(%esp)
  8023cb:	00 
  8023cc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8023d3:	00 
  8023d4:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  8023db:	e8 76 f4 ff ff       	call   801856 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8023e0:	e8 f1 dd ff ff       	call   8001d6 <sys_yield>
	}
  8023e5:	eb bd                	jmp    8023a4 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8023e7:	83 c4 1c             	add    $0x1c,%esp
  8023ea:	5b                   	pop    %ebx
  8023eb:	5e                   	pop    %esi
  8023ec:	5f                   	pop    %edi
  8023ed:	5d                   	pop    %ebp
  8023ee:	c3                   	ret    

008023ef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023f5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023fa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023fd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802403:	8b 52 50             	mov    0x50(%edx),%edx
  802406:	39 ca                	cmp    %ecx,%edx
  802408:	75 0d                	jne    802417 <ipc_find_env+0x28>
			return envs[i].env_id;
  80240a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80240d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802412:	8b 40 40             	mov    0x40(%eax),%eax
  802415:	eb 0e                	jmp    802425 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802417:	83 c0 01             	add    $0x1,%eax
  80241a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80241f:	75 d9                	jne    8023fa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802421:	66 b8 00 00          	mov    $0x0,%ax
}
  802425:	5d                   	pop    %ebp
  802426:	c3                   	ret    

00802427 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80242d:	89 d0                	mov    %edx,%eax
  80242f:	c1 e8 16             	shr    $0x16,%eax
  802432:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80243e:	f6 c1 01             	test   $0x1,%cl
  802441:	74 1d                	je     802460 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802443:	c1 ea 0c             	shr    $0xc,%edx
  802446:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80244d:	f6 c2 01             	test   $0x1,%dl
  802450:	74 0e                	je     802460 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802452:	c1 ea 0c             	shr    $0xc,%edx
  802455:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80245c:	ef 
  80245d:	0f b7 c0             	movzwl %ax,%eax
}
  802460:	5d                   	pop    %ebp
  802461:	c3                   	ret    
  802462:	66 90                	xchg   %ax,%ax
  802464:	66 90                	xchg   %ax,%ax
  802466:	66 90                	xchg   %ax,%ax
  802468:	66 90                	xchg   %ax,%ax
  80246a:	66 90                	xchg   %ax,%ax
  80246c:	66 90                	xchg   %ax,%ax
  80246e:	66 90                	xchg   %ax,%ax

00802470 <__udivdi3>:
  802470:	55                   	push   %ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	83 ec 0c             	sub    $0xc,%esp
  802476:	8b 44 24 28          	mov    0x28(%esp),%eax
  80247a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80247e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802482:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802486:	85 c0                	test   %eax,%eax
  802488:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80248c:	89 ea                	mov    %ebp,%edx
  80248e:	89 0c 24             	mov    %ecx,(%esp)
  802491:	75 2d                	jne    8024c0 <__udivdi3+0x50>
  802493:	39 e9                	cmp    %ebp,%ecx
  802495:	77 61                	ja     8024f8 <__udivdi3+0x88>
  802497:	85 c9                	test   %ecx,%ecx
  802499:	89 ce                	mov    %ecx,%esi
  80249b:	75 0b                	jne    8024a8 <__udivdi3+0x38>
  80249d:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a2:	31 d2                	xor    %edx,%edx
  8024a4:	f7 f1                	div    %ecx
  8024a6:	89 c6                	mov    %eax,%esi
  8024a8:	31 d2                	xor    %edx,%edx
  8024aa:	89 e8                	mov    %ebp,%eax
  8024ac:	f7 f6                	div    %esi
  8024ae:	89 c5                	mov    %eax,%ebp
  8024b0:	89 f8                	mov    %edi,%eax
  8024b2:	f7 f6                	div    %esi
  8024b4:	89 ea                	mov    %ebp,%edx
  8024b6:	83 c4 0c             	add    $0xc,%esp
  8024b9:	5e                   	pop    %esi
  8024ba:	5f                   	pop    %edi
  8024bb:	5d                   	pop    %ebp
  8024bc:	c3                   	ret    
  8024bd:	8d 76 00             	lea    0x0(%esi),%esi
  8024c0:	39 e8                	cmp    %ebp,%eax
  8024c2:	77 24                	ja     8024e8 <__udivdi3+0x78>
  8024c4:	0f bd e8             	bsr    %eax,%ebp
  8024c7:	83 f5 1f             	xor    $0x1f,%ebp
  8024ca:	75 3c                	jne    802508 <__udivdi3+0x98>
  8024cc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024d0:	39 34 24             	cmp    %esi,(%esp)
  8024d3:	0f 86 9f 00 00 00    	jbe    802578 <__udivdi3+0x108>
  8024d9:	39 d0                	cmp    %edx,%eax
  8024db:	0f 82 97 00 00 00    	jb     802578 <__udivdi3+0x108>
  8024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	31 d2                	xor    %edx,%edx
  8024ea:	31 c0                	xor    %eax,%eax
  8024ec:	83 c4 0c             	add    $0xc,%esp
  8024ef:	5e                   	pop    %esi
  8024f0:	5f                   	pop    %edi
  8024f1:	5d                   	pop    %ebp
  8024f2:	c3                   	ret    
  8024f3:	90                   	nop
  8024f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	89 f8                	mov    %edi,%eax
  8024fa:	f7 f1                	div    %ecx
  8024fc:	31 d2                	xor    %edx,%edx
  8024fe:	83 c4 0c             	add    $0xc,%esp
  802501:	5e                   	pop    %esi
  802502:	5f                   	pop    %edi
  802503:	5d                   	pop    %ebp
  802504:	c3                   	ret    
  802505:	8d 76 00             	lea    0x0(%esi),%esi
  802508:	89 e9                	mov    %ebp,%ecx
  80250a:	8b 3c 24             	mov    (%esp),%edi
  80250d:	d3 e0                	shl    %cl,%eax
  80250f:	89 c6                	mov    %eax,%esi
  802511:	b8 20 00 00 00       	mov    $0x20,%eax
  802516:	29 e8                	sub    %ebp,%eax
  802518:	89 c1                	mov    %eax,%ecx
  80251a:	d3 ef                	shr    %cl,%edi
  80251c:	89 e9                	mov    %ebp,%ecx
  80251e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802522:	8b 3c 24             	mov    (%esp),%edi
  802525:	09 74 24 08          	or     %esi,0x8(%esp)
  802529:	89 d6                	mov    %edx,%esi
  80252b:	d3 e7                	shl    %cl,%edi
  80252d:	89 c1                	mov    %eax,%ecx
  80252f:	89 3c 24             	mov    %edi,(%esp)
  802532:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802536:	d3 ee                	shr    %cl,%esi
  802538:	89 e9                	mov    %ebp,%ecx
  80253a:	d3 e2                	shl    %cl,%edx
  80253c:	89 c1                	mov    %eax,%ecx
  80253e:	d3 ef                	shr    %cl,%edi
  802540:	09 d7                	or     %edx,%edi
  802542:	89 f2                	mov    %esi,%edx
  802544:	89 f8                	mov    %edi,%eax
  802546:	f7 74 24 08          	divl   0x8(%esp)
  80254a:	89 d6                	mov    %edx,%esi
  80254c:	89 c7                	mov    %eax,%edi
  80254e:	f7 24 24             	mull   (%esp)
  802551:	39 d6                	cmp    %edx,%esi
  802553:	89 14 24             	mov    %edx,(%esp)
  802556:	72 30                	jb     802588 <__udivdi3+0x118>
  802558:	8b 54 24 04          	mov    0x4(%esp),%edx
  80255c:	89 e9                	mov    %ebp,%ecx
  80255e:	d3 e2                	shl    %cl,%edx
  802560:	39 c2                	cmp    %eax,%edx
  802562:	73 05                	jae    802569 <__udivdi3+0xf9>
  802564:	3b 34 24             	cmp    (%esp),%esi
  802567:	74 1f                	je     802588 <__udivdi3+0x118>
  802569:	89 f8                	mov    %edi,%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	e9 7a ff ff ff       	jmp    8024ec <__udivdi3+0x7c>
  802572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802578:	31 d2                	xor    %edx,%edx
  80257a:	b8 01 00 00 00       	mov    $0x1,%eax
  80257f:	e9 68 ff ff ff       	jmp    8024ec <__udivdi3+0x7c>
  802584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802588:	8d 47 ff             	lea    -0x1(%edi),%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	83 c4 0c             	add    $0xc,%esp
  802590:	5e                   	pop    %esi
  802591:	5f                   	pop    %edi
  802592:	5d                   	pop    %ebp
  802593:	c3                   	ret    
  802594:	66 90                	xchg   %ax,%ax
  802596:	66 90                	xchg   %ax,%ax
  802598:	66 90                	xchg   %ax,%ax
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	66 90                	xchg   %ax,%ax
  80259e:	66 90                	xchg   %ax,%ax

008025a0 <__umoddi3>:
  8025a0:	55                   	push   %ebp
  8025a1:	57                   	push   %edi
  8025a2:	56                   	push   %esi
  8025a3:	83 ec 14             	sub    $0x14,%esp
  8025a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025aa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025ae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8025b2:	89 c7                	mov    %eax,%edi
  8025b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8025bc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025c0:	89 34 24             	mov    %esi,(%esp)
  8025c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	89 c2                	mov    %eax,%edx
  8025cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025cf:	75 17                	jne    8025e8 <__umoddi3+0x48>
  8025d1:	39 fe                	cmp    %edi,%esi
  8025d3:	76 4b                	jbe    802620 <__umoddi3+0x80>
  8025d5:	89 c8                	mov    %ecx,%eax
  8025d7:	89 fa                	mov    %edi,%edx
  8025d9:	f7 f6                	div    %esi
  8025db:	89 d0                	mov    %edx,%eax
  8025dd:	31 d2                	xor    %edx,%edx
  8025df:	83 c4 14             	add    $0x14,%esp
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	66 90                	xchg   %ax,%ax
  8025e8:	39 f8                	cmp    %edi,%eax
  8025ea:	77 54                	ja     802640 <__umoddi3+0xa0>
  8025ec:	0f bd e8             	bsr    %eax,%ebp
  8025ef:	83 f5 1f             	xor    $0x1f,%ebp
  8025f2:	75 5c                	jne    802650 <__umoddi3+0xb0>
  8025f4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025f8:	39 3c 24             	cmp    %edi,(%esp)
  8025fb:	0f 87 e7 00 00 00    	ja     8026e8 <__umoddi3+0x148>
  802601:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802605:	29 f1                	sub    %esi,%ecx
  802607:	19 c7                	sbb    %eax,%edi
  802609:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80260d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802611:	8b 44 24 08          	mov    0x8(%esp),%eax
  802615:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802619:	83 c4 14             	add    $0x14,%esp
  80261c:	5e                   	pop    %esi
  80261d:	5f                   	pop    %edi
  80261e:	5d                   	pop    %ebp
  80261f:	c3                   	ret    
  802620:	85 f6                	test   %esi,%esi
  802622:	89 f5                	mov    %esi,%ebp
  802624:	75 0b                	jne    802631 <__umoddi3+0x91>
  802626:	b8 01 00 00 00       	mov    $0x1,%eax
  80262b:	31 d2                	xor    %edx,%edx
  80262d:	f7 f6                	div    %esi
  80262f:	89 c5                	mov    %eax,%ebp
  802631:	8b 44 24 04          	mov    0x4(%esp),%eax
  802635:	31 d2                	xor    %edx,%edx
  802637:	f7 f5                	div    %ebp
  802639:	89 c8                	mov    %ecx,%eax
  80263b:	f7 f5                	div    %ebp
  80263d:	eb 9c                	jmp    8025db <__umoddi3+0x3b>
  80263f:	90                   	nop
  802640:	89 c8                	mov    %ecx,%eax
  802642:	89 fa                	mov    %edi,%edx
  802644:	83 c4 14             	add    $0x14,%esp
  802647:	5e                   	pop    %esi
  802648:	5f                   	pop    %edi
  802649:	5d                   	pop    %ebp
  80264a:	c3                   	ret    
  80264b:	90                   	nop
  80264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802650:	8b 04 24             	mov    (%esp),%eax
  802653:	be 20 00 00 00       	mov    $0x20,%esi
  802658:	89 e9                	mov    %ebp,%ecx
  80265a:	29 ee                	sub    %ebp,%esi
  80265c:	d3 e2                	shl    %cl,%edx
  80265e:	89 f1                	mov    %esi,%ecx
  802660:	d3 e8                	shr    %cl,%eax
  802662:	89 e9                	mov    %ebp,%ecx
  802664:	89 44 24 04          	mov    %eax,0x4(%esp)
  802668:	8b 04 24             	mov    (%esp),%eax
  80266b:	09 54 24 04          	or     %edx,0x4(%esp)
  80266f:	89 fa                	mov    %edi,%edx
  802671:	d3 e0                	shl    %cl,%eax
  802673:	89 f1                	mov    %esi,%ecx
  802675:	89 44 24 08          	mov    %eax,0x8(%esp)
  802679:	8b 44 24 10          	mov    0x10(%esp),%eax
  80267d:	d3 ea                	shr    %cl,%edx
  80267f:	89 e9                	mov    %ebp,%ecx
  802681:	d3 e7                	shl    %cl,%edi
  802683:	89 f1                	mov    %esi,%ecx
  802685:	d3 e8                	shr    %cl,%eax
  802687:	89 e9                	mov    %ebp,%ecx
  802689:	09 f8                	or     %edi,%eax
  80268b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80268f:	f7 74 24 04          	divl   0x4(%esp)
  802693:	d3 e7                	shl    %cl,%edi
  802695:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802699:	89 d7                	mov    %edx,%edi
  80269b:	f7 64 24 08          	mull   0x8(%esp)
  80269f:	39 d7                	cmp    %edx,%edi
  8026a1:	89 c1                	mov    %eax,%ecx
  8026a3:	89 14 24             	mov    %edx,(%esp)
  8026a6:	72 2c                	jb     8026d4 <__umoddi3+0x134>
  8026a8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8026ac:	72 22                	jb     8026d0 <__umoddi3+0x130>
  8026ae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8026b2:	29 c8                	sub    %ecx,%eax
  8026b4:	19 d7                	sbb    %edx,%edi
  8026b6:	89 e9                	mov    %ebp,%ecx
  8026b8:	89 fa                	mov    %edi,%edx
  8026ba:	d3 e8                	shr    %cl,%eax
  8026bc:	89 f1                	mov    %esi,%ecx
  8026be:	d3 e2                	shl    %cl,%edx
  8026c0:	89 e9                	mov    %ebp,%ecx
  8026c2:	d3 ef                	shr    %cl,%edi
  8026c4:	09 d0                	or     %edx,%eax
  8026c6:	89 fa                	mov    %edi,%edx
  8026c8:	83 c4 14             	add    $0x14,%esp
  8026cb:	5e                   	pop    %esi
  8026cc:	5f                   	pop    %edi
  8026cd:	5d                   	pop    %ebp
  8026ce:	c3                   	ret    
  8026cf:	90                   	nop
  8026d0:	39 d7                	cmp    %edx,%edi
  8026d2:	75 da                	jne    8026ae <__umoddi3+0x10e>
  8026d4:	8b 14 24             	mov    (%esp),%edx
  8026d7:	89 c1                	mov    %eax,%ecx
  8026d9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026dd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026e1:	eb cb                	jmp    8026ae <__umoddi3+0x10e>
  8026e3:	90                   	nop
  8026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026e8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026ec:	0f 82 0f ff ff ff    	jb     802601 <__umoddi3+0x61>
  8026f2:	e9 1a ff ff ff       	jmp    802611 <__umoddi3+0x71>
