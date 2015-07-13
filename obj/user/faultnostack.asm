
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 28 00 00 00       	call   800059 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	c7 44 24 04 e2 04 80 	movl   $0x8004e2,0x4(%esp)
  800040:	00 
  800041:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800048:	e8 4c 03 00 00       	call   800399 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  80004d:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800054:	00 00 00 
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	56                   	push   %esi
  80005d:	53                   	push   %ebx
  80005e:	83 ec 10             	sub    $0x10,%esp
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800067:	e8 2f 01 00 00       	call   80019b <sys_getenvid>
  80006c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800071:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800074:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800079:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007e:	85 db                	test   %ebx,%ebx
  800080:	7e 07                	jle    800089 <libmain+0x30>
		binaryname = argv[0];
  800082:	8b 06                	mov    (%esi),%eax
  800084:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800089:	89 74 24 04          	mov    %esi,0x4(%esp)
  80008d:	89 1c 24             	mov    %ebx,(%esp)
  800090:	e8 9e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800095:	e8 07 00 00 00       	call   8000a1 <exit>
}
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	5b                   	pop    %ebx
  80009e:	5e                   	pop    %esi
  80009f:	5d                   	pop    %ebp
  8000a0:	c3                   	ret    

008000a1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000a7:	e8 3e 06 00 00       	call   8006ea <close_all>
	sys_env_destroy(0);
  8000ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b3:	e8 3f 00 00 00       	call   8000f7 <sys_env_destroy>
}
  8000b8:	c9                   	leave  
  8000b9:	c3                   	ret    

008000ba <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ba:	55                   	push   %ebp
  8000bb:	89 e5                	mov    %esp,%ebp
  8000bd:	57                   	push   %edi
  8000be:	56                   	push   %esi
  8000bf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cb:	89 c3                	mov    %eax,%ebx
  8000cd:	89 c7                	mov    %eax,%edi
  8000cf:	89 c6                	mov    %eax,%esi
  8000d1:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d3:	5b                   	pop    %ebx
  8000d4:	5e                   	pop    %esi
  8000d5:	5f                   	pop    %edi
  8000d6:	5d                   	pop    %ebp
  8000d7:	c3                   	ret    

008000d8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d8:	55                   	push   %ebp
  8000d9:	89 e5                	mov    %esp,%ebp
  8000db:	57                   	push   %edi
  8000dc:	56                   	push   %esi
  8000dd:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000de:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e8:	89 d1                	mov    %edx,%ecx
  8000ea:	89 d3                	mov    %edx,%ebx
  8000ec:	89 d7                	mov    %edx,%edi
  8000ee:	89 d6                	mov    %edx,%esi
  8000f0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f2:	5b                   	pop    %ebx
  8000f3:	5e                   	pop    %esi
  8000f4:	5f                   	pop    %edi
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    

008000f7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	57                   	push   %edi
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800100:	b9 00 00 00 00       	mov    $0x0,%ecx
  800105:	b8 03 00 00 00       	mov    $0x3,%eax
  80010a:	8b 55 08             	mov    0x8(%ebp),%edx
  80010d:	89 cb                	mov    %ecx,%ebx
  80010f:	89 cf                	mov    %ecx,%edi
  800111:	89 ce                	mov    %ecx,%esi
  800113:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800115:	85 c0                	test   %eax,%eax
  800117:	7e 28                	jle    800141 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800119:	89 44 24 10          	mov    %eax,0x10(%esp)
  80011d:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800124:	00 
  800125:	c7 44 24 08 aa 27 80 	movl   $0x8027aa,0x8(%esp)
  80012c:	00 
  80012d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800134:	00 
  800135:	c7 04 24 c7 27 80 00 	movl   $0x8027c7,(%esp)
  80013c:	e8 25 17 00 00       	call   801866 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800141:	83 c4 2c             	add    $0x2c,%esp
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5f                   	pop    %edi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	57                   	push   %edi
  80014d:	56                   	push   %esi
  80014e:	53                   	push   %ebx
  80014f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800152:	b9 00 00 00 00       	mov    $0x0,%ecx
  800157:	b8 04 00 00 00       	mov    $0x4,%eax
  80015c:	8b 55 08             	mov    0x8(%ebp),%edx
  80015f:	89 cb                	mov    %ecx,%ebx
  800161:	89 cf                	mov    %ecx,%edi
  800163:	89 ce                	mov    %ecx,%esi
  800165:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800167:	85 c0                	test   %eax,%eax
  800169:	7e 28                	jle    800193 <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80016b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80016f:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800176:	00 
  800177:	c7 44 24 08 aa 27 80 	movl   $0x8027aa,0x8(%esp)
  80017e:	00 
  80017f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800186:	00 
  800187:	c7 04 24 c7 27 80 00 	movl   $0x8027c7,(%esp)
  80018e:	e8 d3 16 00 00       	call   801866 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800193:	83 c4 2c             	add    $0x2c,%esp
  800196:	5b                   	pop    %ebx
  800197:	5e                   	pop    %esi
  800198:	5f                   	pop    %edi
  800199:	5d                   	pop    %ebp
  80019a:	c3                   	ret    

0080019b <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	57                   	push   %edi
  80019f:	56                   	push   %esi
  8001a0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a6:	b8 02 00 00 00       	mov    $0x2,%eax
  8001ab:	89 d1                	mov    %edx,%ecx
  8001ad:	89 d3                	mov    %edx,%ebx
  8001af:	89 d7                	mov    %edx,%edi
  8001b1:	89 d6                	mov    %edx,%esi
  8001b3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001b5:	5b                   	pop    %ebx
  8001b6:	5e                   	pop    %esi
  8001b7:	5f                   	pop    %edi
  8001b8:	5d                   	pop    %ebp
  8001b9:	c3                   	ret    

008001ba <sys_yield>:

void
sys_yield(void)
{
  8001ba:	55                   	push   %ebp
  8001bb:	89 e5                	mov    %esp,%ebp
  8001bd:	57                   	push   %edi
  8001be:	56                   	push   %esi
  8001bf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8001c5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8001ca:	89 d1                	mov    %edx,%ecx
  8001cc:	89 d3                	mov    %edx,%ebx
  8001ce:	89 d7                	mov    %edx,%edi
  8001d0:	89 d6                	mov    %edx,%esi
  8001d2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001d4:	5b                   	pop    %ebx
  8001d5:	5e                   	pop    %esi
  8001d6:	5f                   	pop    %edi
  8001d7:	5d                   	pop    %ebp
  8001d8:	c3                   	ret    

008001d9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	57                   	push   %edi
  8001dd:	56                   	push   %esi
  8001de:	53                   	push   %ebx
  8001df:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001e2:	be 00 00 00 00       	mov    $0x0,%esi
  8001e7:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001f5:	89 f7                	mov    %esi,%edi
  8001f7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001f9:	85 c0                	test   %eax,%eax
  8001fb:	7e 28                	jle    800225 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800201:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800208:	00 
  800209:	c7 44 24 08 aa 27 80 	movl   $0x8027aa,0x8(%esp)
  800210:	00 
  800211:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800218:	00 
  800219:	c7 04 24 c7 27 80 00 	movl   $0x8027c7,(%esp)
  800220:	e8 41 16 00 00       	call   801866 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800225:	83 c4 2c             	add    $0x2c,%esp
  800228:	5b                   	pop    %ebx
  800229:	5e                   	pop    %esi
  80022a:	5f                   	pop    %edi
  80022b:	5d                   	pop    %ebp
  80022c:	c3                   	ret    

0080022d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	57                   	push   %edi
  800231:	56                   	push   %esi
  800232:	53                   	push   %ebx
  800233:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800236:	b8 06 00 00 00       	mov    $0x6,%eax
  80023b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023e:	8b 55 08             	mov    0x8(%ebp),%edx
  800241:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800244:	8b 7d 14             	mov    0x14(%ebp),%edi
  800247:	8b 75 18             	mov    0x18(%ebp),%esi
  80024a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80024c:	85 c0                	test   %eax,%eax
  80024e:	7e 28                	jle    800278 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800250:	89 44 24 10          	mov    %eax,0x10(%esp)
  800254:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80025b:	00 
  80025c:	c7 44 24 08 aa 27 80 	movl   $0x8027aa,0x8(%esp)
  800263:	00 
  800264:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80026b:	00 
  80026c:	c7 04 24 c7 27 80 00 	movl   $0x8027c7,(%esp)
  800273:	e8 ee 15 00 00       	call   801866 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800278:	83 c4 2c             	add    $0x2c,%esp
  80027b:	5b                   	pop    %ebx
  80027c:	5e                   	pop    %esi
  80027d:	5f                   	pop    %edi
  80027e:	5d                   	pop    %ebp
  80027f:	c3                   	ret    

00800280 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	57                   	push   %edi
  800284:	56                   	push   %esi
  800285:	53                   	push   %ebx
  800286:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800289:	bb 00 00 00 00       	mov    $0x0,%ebx
  80028e:	b8 07 00 00 00       	mov    $0x7,%eax
  800293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800296:	8b 55 08             	mov    0x8(%ebp),%edx
  800299:	89 df                	mov    %ebx,%edi
  80029b:	89 de                	mov    %ebx,%esi
  80029d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	7e 28                	jle    8002cb <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002a7:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8002ae:	00 
  8002af:	c7 44 24 08 aa 27 80 	movl   $0x8027aa,0x8(%esp)
  8002b6:	00 
  8002b7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002be:	00 
  8002bf:	c7 04 24 c7 27 80 00 	movl   $0x8027c7,(%esp)
  8002c6:	e8 9b 15 00 00       	call   801866 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8002cb:	83 c4 2c             	add    $0x2c,%esp
  8002ce:	5b                   	pop    %ebx
  8002cf:	5e                   	pop    %esi
  8002d0:	5f                   	pop    %edi
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	57                   	push   %edi
  8002d7:	56                   	push   %esi
  8002d8:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002de:	b8 10 00 00 00       	mov    $0x10,%eax
  8002e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e6:	89 cb                	mov    %ecx,%ebx
  8002e8:	89 cf                	mov    %ecx,%edi
  8002ea:	89 ce                	mov    %ecx,%esi
  8002ec:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  8002ee:	5b                   	pop    %ebx
  8002ef:	5e                   	pop    %esi
  8002f0:	5f                   	pop    %edi
  8002f1:	5d                   	pop    %ebp
  8002f2:	c3                   	ret    

008002f3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	57                   	push   %edi
  8002f7:	56                   	push   %esi
  8002f8:	53                   	push   %ebx
  8002f9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800301:	b8 09 00 00 00       	mov    $0x9,%eax
  800306:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800309:	8b 55 08             	mov    0x8(%ebp),%edx
  80030c:	89 df                	mov    %ebx,%edi
  80030e:	89 de                	mov    %ebx,%esi
  800310:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800312:	85 c0                	test   %eax,%eax
  800314:	7e 28                	jle    80033e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800316:	89 44 24 10          	mov    %eax,0x10(%esp)
  80031a:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800321:	00 
  800322:	c7 44 24 08 aa 27 80 	movl   $0x8027aa,0x8(%esp)
  800329:	00 
  80032a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800331:	00 
  800332:	c7 04 24 c7 27 80 00 	movl   $0x8027c7,(%esp)
  800339:	e8 28 15 00 00       	call   801866 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80033e:	83 c4 2c             	add    $0x2c,%esp
  800341:	5b                   	pop    %ebx
  800342:	5e                   	pop    %esi
  800343:	5f                   	pop    %edi
  800344:	5d                   	pop    %ebp
  800345:	c3                   	ret    

00800346 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	57                   	push   %edi
  80034a:	56                   	push   %esi
  80034b:	53                   	push   %ebx
  80034c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80034f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800354:	b8 0a 00 00 00       	mov    $0xa,%eax
  800359:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80035c:	8b 55 08             	mov    0x8(%ebp),%edx
  80035f:	89 df                	mov    %ebx,%edi
  800361:	89 de                	mov    %ebx,%esi
  800363:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800365:	85 c0                	test   %eax,%eax
  800367:	7e 28                	jle    800391 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800369:	89 44 24 10          	mov    %eax,0x10(%esp)
  80036d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800374:	00 
  800375:	c7 44 24 08 aa 27 80 	movl   $0x8027aa,0x8(%esp)
  80037c:	00 
  80037d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800384:	00 
  800385:	c7 04 24 c7 27 80 00 	movl   $0x8027c7,(%esp)
  80038c:	e8 d5 14 00 00       	call   801866 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800391:	83 c4 2c             	add    $0x2c,%esp
  800394:	5b                   	pop    %ebx
  800395:	5e                   	pop    %esi
  800396:	5f                   	pop    %edi
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	57                   	push   %edi
  80039d:	56                   	push   %esi
  80039e:	53                   	push   %ebx
  80039f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a7:	b8 0b 00 00 00       	mov    $0xb,%eax
  8003ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003af:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b2:	89 df                	mov    %ebx,%edi
  8003b4:	89 de                	mov    %ebx,%esi
  8003b6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003b8:	85 c0                	test   %eax,%eax
  8003ba:	7e 28                	jle    8003e4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003c0:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8003c7:	00 
  8003c8:	c7 44 24 08 aa 27 80 	movl   $0x8027aa,0x8(%esp)
  8003cf:	00 
  8003d0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003d7:	00 
  8003d8:	c7 04 24 c7 27 80 00 	movl   $0x8027c7,(%esp)
  8003df:	e8 82 14 00 00       	call   801866 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8003e4:	83 c4 2c             	add    $0x2c,%esp
  8003e7:	5b                   	pop    %ebx
  8003e8:	5e                   	pop    %esi
  8003e9:	5f                   	pop    %edi
  8003ea:	5d                   	pop    %ebp
  8003eb:	c3                   	ret    

008003ec <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	57                   	push   %edi
  8003f0:	56                   	push   %esi
  8003f1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003f2:	be 00 00 00 00       	mov    $0x0,%esi
  8003f7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800402:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800405:	8b 7d 14             	mov    0x14(%ebp),%edi
  800408:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80040a:	5b                   	pop    %ebx
  80040b:	5e                   	pop    %esi
  80040c:	5f                   	pop    %edi
  80040d:	5d                   	pop    %ebp
  80040e:	c3                   	ret    

0080040f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	57                   	push   %edi
  800413:	56                   	push   %esi
  800414:	53                   	push   %ebx
  800415:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800418:	b9 00 00 00 00       	mov    $0x0,%ecx
  80041d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800422:	8b 55 08             	mov    0x8(%ebp),%edx
  800425:	89 cb                	mov    %ecx,%ebx
  800427:	89 cf                	mov    %ecx,%edi
  800429:	89 ce                	mov    %ecx,%esi
  80042b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80042d:	85 c0                	test   %eax,%eax
  80042f:	7e 28                	jle    800459 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800431:	89 44 24 10          	mov    %eax,0x10(%esp)
  800435:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80043c:	00 
  80043d:	c7 44 24 08 aa 27 80 	movl   $0x8027aa,0x8(%esp)
  800444:	00 
  800445:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80044c:	00 
  80044d:	c7 04 24 c7 27 80 00 	movl   $0x8027c7,(%esp)
  800454:	e8 0d 14 00 00       	call   801866 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800459:	83 c4 2c             	add    $0x2c,%esp
  80045c:	5b                   	pop    %ebx
  80045d:	5e                   	pop    %esi
  80045e:	5f                   	pop    %edi
  80045f:	5d                   	pop    %ebp
  800460:	c3                   	ret    

00800461 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800461:	55                   	push   %ebp
  800462:	89 e5                	mov    %esp,%ebp
  800464:	57                   	push   %edi
  800465:	56                   	push   %esi
  800466:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800467:	ba 00 00 00 00       	mov    $0x0,%edx
  80046c:	b8 0f 00 00 00       	mov    $0xf,%eax
  800471:	89 d1                	mov    %edx,%ecx
  800473:	89 d3                	mov    %edx,%ebx
  800475:	89 d7                	mov    %edx,%edi
  800477:	89 d6                	mov    %edx,%esi
  800479:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80047b:	5b                   	pop    %ebx
  80047c:	5e                   	pop    %esi
  80047d:	5f                   	pop    %edi
  80047e:	5d                   	pop    %ebp
  80047f:	c3                   	ret    

00800480 <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	57                   	push   %edi
  800484:	56                   	push   %esi
  800485:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800486:	bb 00 00 00 00       	mov    $0x0,%ebx
  80048b:	b8 11 00 00 00       	mov    $0x11,%eax
  800490:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800493:	8b 55 08             	mov    0x8(%ebp),%edx
  800496:	89 df                	mov    %ebx,%edi
  800498:	89 de                	mov    %ebx,%esi
  80049a:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  80049c:	5b                   	pop    %ebx
  80049d:	5e                   	pop    %esi
  80049e:	5f                   	pop    %edi
  80049f:	5d                   	pop    %ebp
  8004a0:	c3                   	ret    

008004a1 <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  8004a1:	55                   	push   %ebp
  8004a2:	89 e5                	mov    %esp,%ebp
  8004a4:	57                   	push   %edi
  8004a5:	56                   	push   %esi
  8004a6:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004ac:	b8 12 00 00 00       	mov    $0x12,%eax
  8004b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b7:	89 df                	mov    %ebx,%edi
  8004b9:	89 de                	mov    %ebx,%esi
  8004bb:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8004bd:	5b                   	pop    %ebx
  8004be:	5e                   	pop    %esi
  8004bf:	5f                   	pop    %edi
  8004c0:	5d                   	pop    %ebp
  8004c1:	c3                   	ret    

008004c2 <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	57                   	push   %edi
  8004c6:	56                   	push   %esi
  8004c7:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004cd:	b8 13 00 00 00       	mov    $0x13,%eax
  8004d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d5:	89 cb                	mov    %ecx,%ebx
  8004d7:	89 cf                	mov    %ecx,%edi
  8004d9:	89 ce                	mov    %ecx,%esi
  8004db:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8004dd:	5b                   	pop    %ebx
  8004de:	5e                   	pop    %esi
  8004df:	5f                   	pop    %edi
  8004e0:	5d                   	pop    %ebp
  8004e1:	c3                   	ret    

008004e2 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8004e2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8004e3:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8004e8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8004ea:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.
 	// need to check whether the pagefault is recursive pagefault or just the 1st page fault
 	//if recursive an reserve word UXSTACKTOP is pushed on uxstacktop. So compare it if match then it is  

 	
	movl 48(%esp), %eax    //has the old esp
  8004ed:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx    //has the old eip
  8004f1:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8004f5:	83 e8 04             	sub    $0x4,%eax
	//we cannot do addl operations once registers and eflags are popped. 
	//So making 48(%esp) to point to (oldesp-4) which currently eax have. So we just need to pop esp at right time.
	movl %eax, 48(%esp)
  8004f8:	89 44 24 30          	mov    %eax,0x30(%esp)

	movl %ebx, (%eax)
  8004fc:	89 18                	mov    %ebx,(%eax)
	// remember to decrement tf_esp when changing stack while returning
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	addl $8, %esp   //skip error and faultva
  8004fe:	83 c4 08             	add    $0x8,%esp
	popal
  800501:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $4, %esp
  800502:	83 c4 04             	add    $0x4,%esp
	popfl
  800505:	9d                   	popf   

	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800506:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800507:	c3                   	ret    
  800508:	66 90                	xchg   %ax,%ax
  80050a:	66 90                	xchg   %ax,%ax
  80050c:	66 90                	xchg   %ax,%ax
  80050e:	66 90                	xchg   %ax,%ax

00800510 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800510:	55                   	push   %ebp
  800511:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	05 00 00 00 30       	add    $0x30000000,%eax
  80051b:	c1 e8 0c             	shr    $0xc,%eax
}
  80051e:	5d                   	pop    %ebp
  80051f:	c3                   	ret    

00800520 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800520:	55                   	push   %ebp
  800521:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800523:	8b 45 08             	mov    0x8(%ebp),%eax
  800526:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80052b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800530:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800535:	5d                   	pop    %ebp
  800536:	c3                   	ret    

00800537 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800537:	55                   	push   %ebp
  800538:	89 e5                	mov    %esp,%ebp
  80053a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80053d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800542:	89 c2                	mov    %eax,%edx
  800544:	c1 ea 16             	shr    $0x16,%edx
  800547:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80054e:	f6 c2 01             	test   $0x1,%dl
  800551:	74 11                	je     800564 <fd_alloc+0x2d>
  800553:	89 c2                	mov    %eax,%edx
  800555:	c1 ea 0c             	shr    $0xc,%edx
  800558:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80055f:	f6 c2 01             	test   $0x1,%dl
  800562:	75 09                	jne    80056d <fd_alloc+0x36>
			*fd_store = fd;
  800564:	89 01                	mov    %eax,(%ecx)
			return 0;
  800566:	b8 00 00 00 00       	mov    $0x0,%eax
  80056b:	eb 17                	jmp    800584 <fd_alloc+0x4d>
  80056d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800572:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800577:	75 c9                	jne    800542 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800579:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80057f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800584:	5d                   	pop    %ebp
  800585:	c3                   	ret    

00800586 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800586:	55                   	push   %ebp
  800587:	89 e5                	mov    %esp,%ebp
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80058c:	83 f8 1f             	cmp    $0x1f,%eax
  80058f:	77 36                	ja     8005c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800591:	c1 e0 0c             	shl    $0xc,%eax
  800594:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800599:	89 c2                	mov    %eax,%edx
  80059b:	c1 ea 16             	shr    $0x16,%edx
  80059e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8005a5:	f6 c2 01             	test   $0x1,%dl
  8005a8:	74 24                	je     8005ce <fd_lookup+0x48>
  8005aa:	89 c2                	mov    %eax,%edx
  8005ac:	c1 ea 0c             	shr    $0xc,%edx
  8005af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8005b6:	f6 c2 01             	test   $0x1,%dl
  8005b9:	74 1a                	je     8005d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8005bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005be:	89 02                	mov    %eax,(%edx)
	return 0;
  8005c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c5:	eb 13                	jmp    8005da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8005c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8005cc:	eb 0c                	jmp    8005da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8005ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8005d3:	eb 05                	jmp    8005da <fd_lookup+0x54>
  8005d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8005da:	5d                   	pop    %ebp
  8005db:	c3                   	ret    

008005dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 18             	sub    $0x18,%esp
  8005e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	eb 13                	jmp    8005ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8005ec:	39 08                	cmp    %ecx,(%eax)
  8005ee:	75 0c                	jne    8005fc <dev_lookup+0x20>
			*dev = devtab[i];
  8005f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8005f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fa:	eb 38                	jmp    800634 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005fc:	83 c2 01             	add    $0x1,%edx
  8005ff:	8b 04 95 54 28 80 00 	mov    0x802854(,%edx,4),%eax
  800606:	85 c0                	test   %eax,%eax
  800608:	75 e2                	jne    8005ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80060a:	a1 08 40 80 00       	mov    0x804008,%eax
  80060f:	8b 40 48             	mov    0x48(%eax),%eax
  800612:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800616:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061a:	c7 04 24 d8 27 80 00 	movl   $0x8027d8,(%esp)
  800621:	e8 39 13 00 00       	call   80195f <cprintf>
	*dev = 0;
  800626:	8b 45 0c             	mov    0xc(%ebp),%eax
  800629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80062f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800634:	c9                   	leave  
  800635:	c3                   	ret    

00800636 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	56                   	push   %esi
  80063a:	53                   	push   %ebx
  80063b:	83 ec 20             	sub    $0x20,%esp
  80063e:	8b 75 08             	mov    0x8(%ebp),%esi
  800641:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800644:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800647:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80064b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800651:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800654:	89 04 24             	mov    %eax,(%esp)
  800657:	e8 2a ff ff ff       	call   800586 <fd_lookup>
  80065c:	85 c0                	test   %eax,%eax
  80065e:	78 05                	js     800665 <fd_close+0x2f>
	    || fd != fd2)
  800660:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800663:	74 0c                	je     800671 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800665:	84 db                	test   %bl,%bl
  800667:	ba 00 00 00 00       	mov    $0x0,%edx
  80066c:	0f 44 c2             	cmove  %edx,%eax
  80066f:	eb 3f                	jmp    8006b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800671:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800674:	89 44 24 04          	mov    %eax,0x4(%esp)
  800678:	8b 06                	mov    (%esi),%eax
  80067a:	89 04 24             	mov    %eax,(%esp)
  80067d:	e8 5a ff ff ff       	call   8005dc <dev_lookup>
  800682:	89 c3                	mov    %eax,%ebx
  800684:	85 c0                	test   %eax,%eax
  800686:	78 16                	js     80069e <fd_close+0x68>
		if (dev->dev_close)
  800688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80068b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80068e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800693:	85 c0                	test   %eax,%eax
  800695:	74 07                	je     80069e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800697:	89 34 24             	mov    %esi,(%esp)
  80069a:	ff d0                	call   *%eax
  80069c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80069e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006a9:	e8 d2 fb ff ff       	call   800280 <sys_page_unmap>
	return r;
  8006ae:	89 d8                	mov    %ebx,%eax
}
  8006b0:	83 c4 20             	add    $0x20,%esp
  8006b3:	5b                   	pop    %ebx
  8006b4:	5e                   	pop    %esi
  8006b5:	5d                   	pop    %ebp
  8006b6:	c3                   	ret    

008006b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
  8006ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8006bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	89 04 24             	mov    %eax,(%esp)
  8006ca:	e8 b7 fe ff ff       	call   800586 <fd_lookup>
  8006cf:	89 c2                	mov    %eax,%edx
  8006d1:	85 d2                	test   %edx,%edx
  8006d3:	78 13                	js     8006e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8006d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8006dc:	00 
  8006dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006e0:	89 04 24             	mov    %eax,(%esp)
  8006e3:	e8 4e ff ff ff       	call   800636 <fd_close>
}
  8006e8:	c9                   	leave  
  8006e9:	c3                   	ret    

008006ea <close_all>:

void
close_all(void)
{
  8006ea:	55                   	push   %ebp
  8006eb:	89 e5                	mov    %esp,%ebp
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006f6:	89 1c 24             	mov    %ebx,(%esp)
  8006f9:	e8 b9 ff ff ff       	call   8006b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006fe:	83 c3 01             	add    $0x1,%ebx
  800701:	83 fb 20             	cmp    $0x20,%ebx
  800704:	75 f0                	jne    8006f6 <close_all+0xc>
		close(i);
}
  800706:	83 c4 14             	add    $0x14,%esp
  800709:	5b                   	pop    %ebx
  80070a:	5d                   	pop    %ebp
  80070b:	c3                   	ret    

0080070c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	57                   	push   %edi
  800710:	56                   	push   %esi
  800711:	53                   	push   %ebx
  800712:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800715:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800718:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	89 04 24             	mov    %eax,(%esp)
  800722:	e8 5f fe ff ff       	call   800586 <fd_lookup>
  800727:	89 c2                	mov    %eax,%edx
  800729:	85 d2                	test   %edx,%edx
  80072b:	0f 88 e1 00 00 00    	js     800812 <dup+0x106>
		return r;
	close(newfdnum);
  800731:	8b 45 0c             	mov    0xc(%ebp),%eax
  800734:	89 04 24             	mov    %eax,(%esp)
  800737:	e8 7b ff ff ff       	call   8006b7 <close>

	newfd = INDEX2FD(newfdnum);
  80073c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80073f:	c1 e3 0c             	shl    $0xc,%ebx
  800742:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80074b:	89 04 24             	mov    %eax,(%esp)
  80074e:	e8 cd fd ff ff       	call   800520 <fd2data>
  800753:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800755:	89 1c 24             	mov    %ebx,(%esp)
  800758:	e8 c3 fd ff ff       	call   800520 <fd2data>
  80075d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80075f:	89 f0                	mov    %esi,%eax
  800761:	c1 e8 16             	shr    $0x16,%eax
  800764:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80076b:	a8 01                	test   $0x1,%al
  80076d:	74 43                	je     8007b2 <dup+0xa6>
  80076f:	89 f0                	mov    %esi,%eax
  800771:	c1 e8 0c             	shr    $0xc,%eax
  800774:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80077b:	f6 c2 01             	test   $0x1,%dl
  80077e:	74 32                	je     8007b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800780:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800787:	25 07 0e 00 00       	and    $0xe07,%eax
  80078c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800790:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800794:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80079b:	00 
  80079c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007a7:	e8 81 fa ff ff       	call   80022d <sys_page_map>
  8007ac:	89 c6                	mov    %eax,%esi
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	78 3e                	js     8007f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8007b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007b5:	89 c2                	mov    %eax,%edx
  8007b7:	c1 ea 0c             	shr    $0xc,%edx
  8007ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8007c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8007cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007d6:	00 
  8007d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007e2:	e8 46 fa ff ff       	call   80022d <sys_page_map>
  8007e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8007e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8007ec:	85 f6                	test   %esi,%esi
  8007ee:	79 22                	jns    800812 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007fb:	e8 80 fa ff ff       	call   800280 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800800:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800804:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80080b:	e8 70 fa ff ff       	call   800280 <sys_page_unmap>
	return r;
  800810:	89 f0                	mov    %esi,%eax
}
  800812:	83 c4 3c             	add    $0x3c,%esp
  800815:	5b                   	pop    %ebx
  800816:	5e                   	pop    %esi
  800817:	5f                   	pop    %edi
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	53                   	push   %ebx
  80081e:	83 ec 24             	sub    $0x24,%esp
  800821:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800824:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800827:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082b:	89 1c 24             	mov    %ebx,(%esp)
  80082e:	e8 53 fd ff ff       	call   800586 <fd_lookup>
  800833:	89 c2                	mov    %eax,%edx
  800835:	85 d2                	test   %edx,%edx
  800837:	78 6d                	js     8008a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800839:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80083c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	89 04 24             	mov    %eax,(%esp)
  800848:	e8 8f fd ff ff       	call   8005dc <dev_lookup>
  80084d:	85 c0                	test   %eax,%eax
  80084f:	78 55                	js     8008a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800854:	8b 50 08             	mov    0x8(%eax),%edx
  800857:	83 e2 03             	and    $0x3,%edx
  80085a:	83 fa 01             	cmp    $0x1,%edx
  80085d:	75 23                	jne    800882 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80085f:	a1 08 40 80 00       	mov    0x804008,%eax
  800864:	8b 40 48             	mov    0x48(%eax),%eax
  800867:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80086b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086f:	c7 04 24 19 28 80 00 	movl   $0x802819,(%esp)
  800876:	e8 e4 10 00 00       	call   80195f <cprintf>
		return -E_INVAL;
  80087b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800880:	eb 24                	jmp    8008a6 <read+0x8c>
	}
	if (!dev->dev_read)
  800882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800885:	8b 52 08             	mov    0x8(%edx),%edx
  800888:	85 d2                	test   %edx,%edx
  80088a:	74 15                	je     8008a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80088c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80088f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800893:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800896:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80089a:	89 04 24             	mov    %eax,(%esp)
  80089d:	ff d2                	call   *%edx
  80089f:	eb 05                	jmp    8008a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8008a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8008a6:	83 c4 24             	add    $0x24,%esp
  8008a9:	5b                   	pop    %ebx
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	57                   	push   %edi
  8008b0:	56                   	push   %esi
  8008b1:	53                   	push   %ebx
  8008b2:	83 ec 1c             	sub    $0x1c,%esp
  8008b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c0:	eb 23                	jmp    8008e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8008c2:	89 f0                	mov    %esi,%eax
  8008c4:	29 d8                	sub    %ebx,%eax
  8008c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ca:	89 d8                	mov    %ebx,%eax
  8008cc:	03 45 0c             	add    0xc(%ebp),%eax
  8008cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d3:	89 3c 24             	mov    %edi,(%esp)
  8008d6:	e8 3f ff ff ff       	call   80081a <read>
		if (m < 0)
  8008db:	85 c0                	test   %eax,%eax
  8008dd:	78 10                	js     8008ef <readn+0x43>
			return m;
		if (m == 0)
  8008df:	85 c0                	test   %eax,%eax
  8008e1:	74 0a                	je     8008ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008e3:	01 c3                	add    %eax,%ebx
  8008e5:	39 f3                	cmp    %esi,%ebx
  8008e7:	72 d9                	jb     8008c2 <readn+0x16>
  8008e9:	89 d8                	mov    %ebx,%eax
  8008eb:	eb 02                	jmp    8008ef <readn+0x43>
  8008ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8008ef:	83 c4 1c             	add    $0x1c,%esp
  8008f2:	5b                   	pop    %ebx
  8008f3:	5e                   	pop    %esi
  8008f4:	5f                   	pop    %edi
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	53                   	push   %ebx
  8008fb:	83 ec 24             	sub    $0x24,%esp
  8008fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800901:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800904:	89 44 24 04          	mov    %eax,0x4(%esp)
  800908:	89 1c 24             	mov    %ebx,(%esp)
  80090b:	e8 76 fc ff ff       	call   800586 <fd_lookup>
  800910:	89 c2                	mov    %eax,%edx
  800912:	85 d2                	test   %edx,%edx
  800914:	78 68                	js     80097e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800916:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800919:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	89 04 24             	mov    %eax,(%esp)
  800925:	e8 b2 fc ff ff       	call   8005dc <dev_lookup>
  80092a:	85 c0                	test   %eax,%eax
  80092c:	78 50                	js     80097e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80092e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800931:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800935:	75 23                	jne    80095a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800937:	a1 08 40 80 00       	mov    0x804008,%eax
  80093c:	8b 40 48             	mov    0x48(%eax),%eax
  80093f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800943:	89 44 24 04          	mov    %eax,0x4(%esp)
  800947:	c7 04 24 35 28 80 00 	movl   $0x802835,(%esp)
  80094e:	e8 0c 10 00 00       	call   80195f <cprintf>
		return -E_INVAL;
  800953:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800958:	eb 24                	jmp    80097e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80095a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095d:	8b 52 0c             	mov    0xc(%edx),%edx
  800960:	85 d2                	test   %edx,%edx
  800962:	74 15                	je     800979 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800964:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800967:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80096b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800972:	89 04 24             	mov    %eax,(%esp)
  800975:	ff d2                	call   *%edx
  800977:	eb 05                	jmp    80097e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800979:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80097e:	83 c4 24             	add    $0x24,%esp
  800981:	5b                   	pop    %ebx
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <seek>:

int
seek(int fdnum, off_t offset)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80098a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80098d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	89 04 24             	mov    %eax,(%esp)
  800997:	e8 ea fb ff ff       	call   800586 <fd_lookup>
  80099c:	85 c0                	test   %eax,%eax
  80099e:	78 0e                	js     8009ae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8009a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8009a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	53                   	push   %ebx
  8009b4:	83 ec 24             	sub    $0x24,%esp
  8009b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009c1:	89 1c 24             	mov    %ebx,(%esp)
  8009c4:	e8 bd fb ff ff       	call   800586 <fd_lookup>
  8009c9:	89 c2                	mov    %eax,%edx
  8009cb:	85 d2                	test   %edx,%edx
  8009cd:	78 61                	js     800a30 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d9:	8b 00                	mov    (%eax),%eax
  8009db:	89 04 24             	mov    %eax,(%esp)
  8009de:	e8 f9 fb ff ff       	call   8005dc <dev_lookup>
  8009e3:	85 c0                	test   %eax,%eax
  8009e5:	78 49                	js     800a30 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009ee:	75 23                	jne    800a13 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8009f0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009f5:	8b 40 48             	mov    0x48(%eax),%eax
  8009f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a00:	c7 04 24 f8 27 80 00 	movl   $0x8027f8,(%esp)
  800a07:	e8 53 0f 00 00       	call   80195f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800a0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a11:	eb 1d                	jmp    800a30 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  800a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a16:	8b 52 18             	mov    0x18(%edx),%edx
  800a19:	85 d2                	test   %edx,%edx
  800a1b:	74 0e                	je     800a2b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800a1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a24:	89 04 24             	mov    %eax,(%esp)
  800a27:	ff d2                	call   *%edx
  800a29:	eb 05                	jmp    800a30 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800a2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800a30:	83 c4 24             	add    $0x24,%esp
  800a33:	5b                   	pop    %ebx
  800a34:	5d                   	pop    %ebp
  800a35:	c3                   	ret    

00800a36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	53                   	push   %ebx
  800a3a:	83 ec 24             	sub    $0x24,%esp
  800a3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	89 04 24             	mov    %eax,(%esp)
  800a4d:	e8 34 fb ff ff       	call   800586 <fd_lookup>
  800a52:	89 c2                	mov    %eax,%edx
  800a54:	85 d2                	test   %edx,%edx
  800a56:	78 52                	js     800aaa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a62:	8b 00                	mov    (%eax),%eax
  800a64:	89 04 24             	mov    %eax,(%esp)
  800a67:	e8 70 fb ff ff       	call   8005dc <dev_lookup>
  800a6c:	85 c0                	test   %eax,%eax
  800a6e:	78 3a                	js     800aaa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a73:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a77:	74 2c                	je     800aa5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a79:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a7c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a83:	00 00 00 
	stat->st_isdir = 0;
  800a86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a8d:	00 00 00 
	stat->st_dev = dev;
  800a90:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a9d:	89 14 24             	mov    %edx,(%esp)
  800aa0:	ff 50 14             	call   *0x14(%eax)
  800aa3:	eb 05                	jmp    800aaa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800aa5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800aaa:	83 c4 24             	add    $0x24,%esp
  800aad:	5b                   	pop    %ebx
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    

00800ab0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	56                   	push   %esi
  800ab4:	53                   	push   %ebx
  800ab5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800ab8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800abf:	00 
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	89 04 24             	mov    %eax,(%esp)
  800ac6:	e8 99 02 00 00       	call   800d64 <open>
  800acb:	89 c3                	mov    %eax,%ebx
  800acd:	85 db                	test   %ebx,%ebx
  800acf:	78 1b                	js     800aec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad8:	89 1c 24             	mov    %ebx,(%esp)
  800adb:	e8 56 ff ff ff       	call   800a36 <fstat>
  800ae0:	89 c6                	mov    %eax,%esi
	close(fd);
  800ae2:	89 1c 24             	mov    %ebx,(%esp)
  800ae5:	e8 cd fb ff ff       	call   8006b7 <close>
	return r;
  800aea:	89 f0                	mov    %esi,%eax
}
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	56                   	push   %esi
  800af7:	53                   	push   %ebx
  800af8:	83 ec 10             	sub    $0x10,%esp
  800afb:	89 c6                	mov    %eax,%esi
  800afd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800aff:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800b06:	75 11                	jne    800b19 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800b08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800b0f:	e8 7b 19 00 00       	call   80248f <ipc_find_env>
  800b14:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800b19:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800b20:	00 
  800b21:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800b28:	00 
  800b29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b2d:	a1 00 40 80 00       	mov    0x804000,%eax
  800b32:	89 04 24             	mov    %eax,(%esp)
  800b35:	e8 ee 18 00 00       	call   802428 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800b3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b41:	00 
  800b42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b4d:	e8 6e 18 00 00       	call   8023c0 <ipc_recv>
}
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	5b                   	pop    %ebx
  800b56:	5e                   	pop    %esi
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    

00800b59 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8b 40 0c             	mov    0xc(%eax),%eax
  800b65:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800b72:	ba 00 00 00 00       	mov    $0x0,%edx
  800b77:	b8 02 00 00 00       	mov    $0x2,%eax
  800b7c:	e8 72 ff ff ff       	call   800af3 <fsipc>
}
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8b 40 0c             	mov    0xc(%eax),%eax
  800b8f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b94:	ba 00 00 00 00       	mov    $0x0,%edx
  800b99:	b8 06 00 00 00       	mov    $0x6,%eax
  800b9e:	e8 50 ff ff ff       	call   800af3 <fsipc>
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	53                   	push   %ebx
  800ba9:	83 ec 14             	sub    $0x14,%esp
  800bac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  800bb5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800bba:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbf:	b8 05 00 00 00       	mov    $0x5,%eax
  800bc4:	e8 2a ff ff ff       	call   800af3 <fsipc>
  800bc9:	89 c2                	mov    %eax,%edx
  800bcb:	85 d2                	test   %edx,%edx
  800bcd:	78 2b                	js     800bfa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800bcf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800bd6:	00 
  800bd7:	89 1c 24             	mov    %ebx,(%esp)
  800bda:	e8 f8 13 00 00       	call   801fd7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800bdf:	a1 80 50 80 00       	mov    0x805080,%eax
  800be4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800bea:	a1 84 50 80 00       	mov    0x805084,%eax
  800bef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bfa:	83 c4 14             	add    $0x14,%esp
  800bfd:	5b                   	pop    %ebx
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	53                   	push   %ebx
  800c04:	83 ec 14             	sub    $0x14,%esp
  800c07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  800c0a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  800c10:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  800c15:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800c18:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1b:	8b 52 0c             	mov    0xc(%edx),%edx
  800c1e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  800c24:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  800c29:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c34:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800c3b:	e8 34 15 00 00       	call   802174 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  800c40:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  800c47:	00 
  800c48:	c7 04 24 68 28 80 00 	movl   $0x802868,(%esp)
  800c4f:	e8 0b 0d 00 00       	call   80195f <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800c54:	ba 00 00 00 00       	mov    $0x0,%edx
  800c59:	b8 04 00 00 00       	mov    $0x4,%eax
  800c5e:	e8 90 fe ff ff       	call   800af3 <fsipc>
  800c63:	85 c0                	test   %eax,%eax
  800c65:	78 53                	js     800cba <devfile_write+0xba>
		return r;
	assert(r <= n);
  800c67:	39 c3                	cmp    %eax,%ebx
  800c69:	73 24                	jae    800c8f <devfile_write+0x8f>
  800c6b:	c7 44 24 0c 6d 28 80 	movl   $0x80286d,0xc(%esp)
  800c72:	00 
  800c73:	c7 44 24 08 74 28 80 	movl   $0x802874,0x8(%esp)
  800c7a:	00 
  800c7b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  800c82:	00 
  800c83:	c7 04 24 89 28 80 00 	movl   $0x802889,(%esp)
  800c8a:	e8 d7 0b 00 00       	call   801866 <_panic>
	assert(r <= PGSIZE);
  800c8f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c94:	7e 24                	jle    800cba <devfile_write+0xba>
  800c96:	c7 44 24 0c 94 28 80 	movl   $0x802894,0xc(%esp)
  800c9d:	00 
  800c9e:	c7 44 24 08 74 28 80 	movl   $0x802874,0x8(%esp)
  800ca5:	00 
  800ca6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  800cad:	00 
  800cae:	c7 04 24 89 28 80 00 	movl   $0x802889,(%esp)
  800cb5:	e8 ac 0b 00 00       	call   801866 <_panic>
	return r;
}
  800cba:	83 c4 14             	add    $0x14,%esp
  800cbd:	5b                   	pop    %ebx
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
  800cc5:	83 ec 10             	sub    $0x10,%esp
  800cc8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	8b 40 0c             	mov    0xc(%eax),%eax
  800cd1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800cd6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800cdc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce6:	e8 08 fe ff ff       	call   800af3 <fsipc>
  800ceb:	89 c3                	mov    %eax,%ebx
  800ced:	85 c0                	test   %eax,%eax
  800cef:	78 6a                	js     800d5b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800cf1:	39 c6                	cmp    %eax,%esi
  800cf3:	73 24                	jae    800d19 <devfile_read+0x59>
  800cf5:	c7 44 24 0c 6d 28 80 	movl   $0x80286d,0xc(%esp)
  800cfc:	00 
  800cfd:	c7 44 24 08 74 28 80 	movl   $0x802874,0x8(%esp)
  800d04:	00 
  800d05:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800d0c:	00 
  800d0d:	c7 04 24 89 28 80 00 	movl   $0x802889,(%esp)
  800d14:	e8 4d 0b 00 00       	call   801866 <_panic>
	assert(r <= PGSIZE);
  800d19:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800d1e:	7e 24                	jle    800d44 <devfile_read+0x84>
  800d20:	c7 44 24 0c 94 28 80 	movl   $0x802894,0xc(%esp)
  800d27:	00 
  800d28:	c7 44 24 08 74 28 80 	movl   $0x802874,0x8(%esp)
  800d2f:	00 
  800d30:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800d37:	00 
  800d38:	c7 04 24 89 28 80 00 	movl   $0x802889,(%esp)
  800d3f:	e8 22 0b 00 00       	call   801866 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800d44:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d48:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800d4f:	00 
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	89 04 24             	mov    %eax,(%esp)
  800d56:	e8 19 14 00 00       	call   802174 <memmove>
	return r;
}
  800d5b:	89 d8                	mov    %ebx,%eax
  800d5d:	83 c4 10             	add    $0x10,%esp
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	53                   	push   %ebx
  800d68:	83 ec 24             	sub    $0x24,%esp
  800d6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800d6e:	89 1c 24             	mov    %ebx,(%esp)
  800d71:	e8 2a 12 00 00       	call   801fa0 <strlen>
  800d76:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800d7b:	7f 60                	jg     800ddd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800d7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d80:	89 04 24             	mov    %eax,(%esp)
  800d83:	e8 af f7 ff ff       	call   800537 <fd_alloc>
  800d88:	89 c2                	mov    %eax,%edx
  800d8a:	85 d2                	test   %edx,%edx
  800d8c:	78 54                	js     800de2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800d8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d92:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800d99:	e8 39 12 00 00       	call   801fd7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800da6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dae:	e8 40 fd ff ff       	call   800af3 <fsipc>
  800db3:	89 c3                	mov    %eax,%ebx
  800db5:	85 c0                	test   %eax,%eax
  800db7:	79 17                	jns    800dd0 <open+0x6c>
		fd_close(fd, 0);
  800db9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800dc0:	00 
  800dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc4:	89 04 24             	mov    %eax,(%esp)
  800dc7:	e8 6a f8 ff ff       	call   800636 <fd_close>
		return r;
  800dcc:	89 d8                	mov    %ebx,%eax
  800dce:	eb 12                	jmp    800de2 <open+0x7e>
	}

	return fd2num(fd);
  800dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd3:	89 04 24             	mov    %eax,(%esp)
  800dd6:	e8 35 f7 ff ff       	call   800510 <fd2num>
  800ddb:	eb 05                	jmp    800de2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800ddd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800de2:	83 c4 24             	add    $0x24,%esp
  800de5:	5b                   	pop    %ebx
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800dee:	ba 00 00 00 00       	mov    $0x0,%edx
  800df3:	b8 08 00 00 00       	mov    $0x8,%eax
  800df8:	e8 f6 fc ff ff       	call   800af3 <fsipc>
}
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <evict>:

int evict(void)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  800e05:	c7 04 24 a0 28 80 00 	movl   $0x8028a0,(%esp)
  800e0c:	e8 4e 0b 00 00       	call   80195f <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  800e11:	ba 00 00 00 00       	mov    $0x0,%edx
  800e16:	b8 09 00 00 00       	mov    $0x9,%eax
  800e1b:	e8 d3 fc ff ff       	call   800af3 <fsipc>
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    
  800e22:	66 90                	xchg   %ax,%ax
  800e24:	66 90                	xchg   %ax,%ax
  800e26:	66 90                	xchg   %ax,%ax
  800e28:	66 90                	xchg   %ax,%ax
  800e2a:	66 90                	xchg   %ax,%ax
  800e2c:	66 90                	xchg   %ax,%ax
  800e2e:	66 90                	xchg   %ax,%ax

00800e30 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800e36:	c7 44 24 04 b9 28 80 	movl   $0x8028b9,0x4(%esp)
  800e3d:	00 
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	89 04 24             	mov    %eax,(%esp)
  800e44:	e8 8e 11 00 00       	call   801fd7 <strcpy>
	return 0;
}
  800e49:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4e:	c9                   	leave  
  800e4f:	c3                   	ret    

00800e50 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	53                   	push   %ebx
  800e54:	83 ec 14             	sub    $0x14,%esp
  800e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800e5a:	89 1c 24             	mov    %ebx,(%esp)
  800e5d:	e8 65 16 00 00       	call   8024c7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800e62:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800e67:	83 f8 01             	cmp    $0x1,%eax
  800e6a:	75 0d                	jne    800e79 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800e6c:	8b 43 0c             	mov    0xc(%ebx),%eax
  800e6f:	89 04 24             	mov    %eax,(%esp)
  800e72:	e8 29 03 00 00       	call   8011a0 <nsipc_close>
  800e77:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800e79:	89 d0                	mov    %edx,%eax
  800e7b:	83 c4 14             	add    $0x14,%esp
  800e7e:	5b                   	pop    %ebx
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800e87:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e8e:	00 
  800e8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e92:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e99:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8b 40 0c             	mov    0xc(%eax),%eax
  800ea3:	89 04 24             	mov    %eax,(%esp)
  800ea6:	e8 f0 03 00 00       	call   80129b <nsipc_send>
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800eb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800eba:	00 
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8b 40 0c             	mov    0xc(%eax),%eax
  800ecf:	89 04 24             	mov    %eax,(%esp)
  800ed2:	e8 44 03 00 00       	call   80121b <nsipc_recv>
}
  800ed7:	c9                   	leave  
  800ed8:	c3                   	ret    

00800ed9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800edf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800ee2:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ee6:	89 04 24             	mov    %eax,(%esp)
  800ee9:	e8 98 f6 ff ff       	call   800586 <fd_lookup>
  800eee:	85 c0                	test   %eax,%eax
  800ef0:	78 17                	js     800f09 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800efb:	39 08                	cmp    %ecx,(%eax)
  800efd:	75 05                	jne    800f04 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800eff:	8b 40 0c             	mov    0xc(%eax),%eax
  800f02:	eb 05                	jmp    800f09 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800f04:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
  800f10:	83 ec 20             	sub    $0x20,%esp
  800f13:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f18:	89 04 24             	mov    %eax,(%esp)
  800f1b:	e8 17 f6 ff ff       	call   800537 <fd_alloc>
  800f20:	89 c3                	mov    %eax,%ebx
  800f22:	85 c0                	test   %eax,%eax
  800f24:	78 21                	js     800f47 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800f26:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f2d:	00 
  800f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f31:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f3c:	e8 98 f2 ff ff       	call   8001d9 <sys_page_alloc>
  800f41:	89 c3                	mov    %eax,%ebx
  800f43:	85 c0                	test   %eax,%eax
  800f45:	79 0c                	jns    800f53 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800f47:	89 34 24             	mov    %esi,(%esp)
  800f4a:	e8 51 02 00 00       	call   8011a0 <nsipc_close>
		return r;
  800f4f:	89 d8                	mov    %ebx,%eax
  800f51:	eb 20                	jmp    800f73 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f53:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800f68:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800f6b:	89 14 24             	mov    %edx,(%esp)
  800f6e:	e8 9d f5 ff ff       	call   800510 <fd2num>
}
  800f73:	83 c4 20             	add    $0x20,%esp
  800f76:	5b                   	pop    %ebx
  800f77:	5e                   	pop    %esi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    

00800f7a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	e8 51 ff ff ff       	call   800ed9 <fd2sockid>
		return r;
  800f88:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	78 23                	js     800fb1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f8e:	8b 55 10             	mov    0x10(%ebp),%edx
  800f91:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f98:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f9c:	89 04 24             	mov    %eax,(%esp)
  800f9f:	e8 45 01 00 00       	call   8010e9 <nsipc_accept>
		return r;
  800fa4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	78 07                	js     800fb1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800faa:	e8 5c ff ff ff       	call   800f0b <alloc_sockfd>
  800faf:	89 c1                	mov    %eax,%ecx
}
  800fb1:	89 c8                	mov    %ecx,%eax
  800fb3:	c9                   	leave  
  800fb4:	c3                   	ret    

00800fb5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	e8 16 ff ff ff       	call   800ed9 <fd2sockid>
  800fc3:	89 c2                	mov    %eax,%edx
  800fc5:	85 d2                	test   %edx,%edx
  800fc7:	78 16                	js     800fdf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fd7:	89 14 24             	mov    %edx,(%esp)
  800fda:	e8 60 01 00 00       	call   80113f <nsipc_bind>
}
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <shutdown>:

int
shutdown(int s, int how)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	e8 ea fe ff ff       	call   800ed9 <fd2sockid>
  800fef:	89 c2                	mov    %eax,%edx
  800ff1:	85 d2                	test   %edx,%edx
  800ff3:	78 0f                	js     801004 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ffc:	89 14 24             	mov    %edx,(%esp)
  800fff:	e8 7a 01 00 00       	call   80117e <nsipc_shutdown>
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	e8 c5 fe ff ff       	call   800ed9 <fd2sockid>
  801014:	89 c2                	mov    %eax,%edx
  801016:	85 d2                	test   %edx,%edx
  801018:	78 16                	js     801030 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80101a:	8b 45 10             	mov    0x10(%ebp),%eax
  80101d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	89 44 24 04          	mov    %eax,0x4(%esp)
  801028:	89 14 24             	mov    %edx,(%esp)
  80102b:	e8 8a 01 00 00       	call   8011ba <nsipc_connect>
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <listen>:

int
listen(int s, int backlog)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	e8 99 fe ff ff       	call   800ed9 <fd2sockid>
  801040:	89 c2                	mov    %eax,%edx
  801042:	85 d2                	test   %edx,%edx
  801044:	78 0f                	js     801055 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 44 24 04          	mov    %eax,0x4(%esp)
  80104d:	89 14 24             	mov    %edx,(%esp)
  801050:	e8 a4 01 00 00       	call   8011f9 <nsipc_listen>
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80105d:	8b 45 10             	mov    0x10(%ebp),%eax
  801060:	89 44 24 08          	mov    %eax,0x8(%esp)
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	89 44 24 04          	mov    %eax,0x4(%esp)
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	89 04 24             	mov    %eax,(%esp)
  801071:	e8 98 02 00 00       	call   80130e <nsipc_socket>
  801076:	89 c2                	mov    %eax,%edx
  801078:	85 d2                	test   %edx,%edx
  80107a:	78 05                	js     801081 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80107c:	e8 8a fe ff ff       	call   800f0b <alloc_sockfd>
}
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	53                   	push   %ebx
  801087:	83 ec 14             	sub    $0x14,%esp
  80108a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80108c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801093:	75 11                	jne    8010a6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801095:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80109c:	e8 ee 13 00 00       	call   80248f <ipc_find_env>
  8010a1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8010a6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8010ad:	00 
  8010ae:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8010b5:	00 
  8010b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010ba:	a1 04 40 80 00       	mov    0x804004,%eax
  8010bf:	89 04 24             	mov    %eax,(%esp)
  8010c2:	e8 61 13 00 00       	call   802428 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8010c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010ce:	00 
  8010cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8010d6:	00 
  8010d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010de:	e8 dd 12 00 00       	call   8023c0 <ipc_recv>
}
  8010e3:	83 c4 14             	add    $0x14,%esp
  8010e6:	5b                   	pop    %ebx
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    

008010e9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	56                   	push   %esi
  8010ed:	53                   	push   %ebx
  8010ee:	83 ec 10             	sub    $0x10,%esp
  8010f1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8010fc:	8b 06                	mov    (%esi),%eax
  8010fe:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801103:	b8 01 00 00 00       	mov    $0x1,%eax
  801108:	e8 76 ff ff ff       	call   801083 <nsipc>
  80110d:	89 c3                	mov    %eax,%ebx
  80110f:	85 c0                	test   %eax,%eax
  801111:	78 23                	js     801136 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801113:	a1 10 60 80 00       	mov    0x806010,%eax
  801118:	89 44 24 08          	mov    %eax,0x8(%esp)
  80111c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801123:	00 
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	89 04 24             	mov    %eax,(%esp)
  80112a:	e8 45 10 00 00       	call   802174 <memmove>
		*addrlen = ret->ret_addrlen;
  80112f:	a1 10 60 80 00       	mov    0x806010,%eax
  801134:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801136:	89 d8                	mov    %ebx,%eax
  801138:	83 c4 10             	add    $0x10,%esp
  80113b:	5b                   	pop    %ebx
  80113c:	5e                   	pop    %esi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	53                   	push   %ebx
  801143:	83 ec 14             	sub    $0x14,%esp
  801146:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801151:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801155:	8b 45 0c             	mov    0xc(%ebp),%eax
  801158:	89 44 24 04          	mov    %eax,0x4(%esp)
  80115c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801163:	e8 0c 10 00 00       	call   802174 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801168:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80116e:	b8 02 00 00 00       	mov    $0x2,%eax
  801173:	e8 0b ff ff ff       	call   801083 <nsipc>
}
  801178:	83 c4 14             	add    $0x14,%esp
  80117b:	5b                   	pop    %ebx
  80117c:	5d                   	pop    %ebp
  80117d:	c3                   	ret    

0080117e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801194:	b8 03 00 00 00       	mov    $0x3,%eax
  801199:	e8 e5 fe ff ff       	call   801083 <nsipc>
}
  80119e:	c9                   	leave  
  80119f:	c3                   	ret    

008011a0 <nsipc_close>:

int
nsipc_close(int s)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011ae:	b8 04 00 00 00       	mov    $0x4,%eax
  8011b3:	e8 cb fe ff ff       	call   801083 <nsipc>
}
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

008011ba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	53                   	push   %ebx
  8011be:	83 ec 14             	sub    $0x14,%esp
  8011c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8011cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011d7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8011de:	e8 91 0f 00 00       	call   802174 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8011e3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8011e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8011ee:	e8 90 fe ff ff       	call   801083 <nsipc>
}
  8011f3:	83 c4 14             	add    $0x14,%esp
  8011f6:	5b                   	pop    %ebx
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80120f:	b8 06 00 00 00       	mov    $0x6,%eax
  801214:	e8 6a fe ff ff       	call   801083 <nsipc>
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	56                   	push   %esi
  80121f:	53                   	push   %ebx
  801220:	83 ec 10             	sub    $0x10,%esp
  801223:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80122e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801234:	8b 45 14             	mov    0x14(%ebp),%eax
  801237:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80123c:	b8 07 00 00 00       	mov    $0x7,%eax
  801241:	e8 3d fe ff ff       	call   801083 <nsipc>
  801246:	89 c3                	mov    %eax,%ebx
  801248:	85 c0                	test   %eax,%eax
  80124a:	78 46                	js     801292 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80124c:	39 f0                	cmp    %esi,%eax
  80124e:	7f 07                	jg     801257 <nsipc_recv+0x3c>
  801250:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801255:	7e 24                	jle    80127b <nsipc_recv+0x60>
  801257:	c7 44 24 0c c5 28 80 	movl   $0x8028c5,0xc(%esp)
  80125e:	00 
  80125f:	c7 44 24 08 74 28 80 	movl   $0x802874,0x8(%esp)
  801266:	00 
  801267:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80126e:	00 
  80126f:	c7 04 24 da 28 80 00 	movl   $0x8028da,(%esp)
  801276:	e8 eb 05 00 00       	call   801866 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80127b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80127f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801286:	00 
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	89 04 24             	mov    %eax,(%esp)
  80128d:	e8 e2 0e 00 00       	call   802174 <memmove>
	}

	return r;
}
  801292:	89 d8                	mov    %ebx,%eax
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	5b                   	pop    %ebx
  801298:	5e                   	pop    %esi
  801299:	5d                   	pop    %ebp
  80129a:	c3                   	ret    

0080129b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	53                   	push   %ebx
  80129f:	83 ec 14             	sub    $0x14,%esp
  8012a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012ad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012b3:	7e 24                	jle    8012d9 <nsipc_send+0x3e>
  8012b5:	c7 44 24 0c e6 28 80 	movl   $0x8028e6,0xc(%esp)
  8012bc:	00 
  8012bd:	c7 44 24 08 74 28 80 	movl   $0x802874,0x8(%esp)
  8012c4:	00 
  8012c5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8012cc:	00 
  8012cd:	c7 04 24 da 28 80 00 	movl   $0x8028da,(%esp)
  8012d4:	e8 8d 05 00 00       	call   801866 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8012eb:	e8 84 0e 00 00       	call   802174 <memmove>
	nsipcbuf.send.req_size = size;
  8012f0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8012fe:	b8 08 00 00 00       	mov    $0x8,%eax
  801303:	e8 7b fd ff ff       	call   801083 <nsipc>
}
  801308:	83 c4 14             	add    $0x14,%esp
  80130b:	5b                   	pop    %ebx
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    

0080130e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80131c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801324:	8b 45 10             	mov    0x10(%ebp),%eax
  801327:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80132c:	b8 09 00 00 00       	mov    $0x9,%eax
  801331:	e8 4d fd ff ff       	call   801083 <nsipc>
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	56                   	push   %esi
  80133c:	53                   	push   %ebx
  80133d:	83 ec 10             	sub    $0x10,%esp
  801340:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	89 04 24             	mov    %eax,(%esp)
  801349:	e8 d2 f1 ff ff       	call   800520 <fd2data>
  80134e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801350:	c7 44 24 04 f2 28 80 	movl   $0x8028f2,0x4(%esp)
  801357:	00 
  801358:	89 1c 24             	mov    %ebx,(%esp)
  80135b:	e8 77 0c 00 00       	call   801fd7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801360:	8b 46 04             	mov    0x4(%esi),%eax
  801363:	2b 06                	sub    (%esi),%eax
  801365:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80136b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801372:	00 00 00 
	stat->st_dev = &devpipe;
  801375:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80137c:	30 80 00 
	return 0;
}
  80137f:	b8 00 00 00 00       	mov    $0x0,%eax
  801384:	83 c4 10             	add    $0x10,%esp
  801387:	5b                   	pop    %ebx
  801388:	5e                   	pop    %esi
  801389:	5d                   	pop    %ebp
  80138a:	c3                   	ret    

0080138b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	53                   	push   %ebx
  80138f:	83 ec 14             	sub    $0x14,%esp
  801392:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801395:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801399:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a0:	e8 db ee ff ff       	call   800280 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8013a5:	89 1c 24             	mov    %ebx,(%esp)
  8013a8:	e8 73 f1 ff ff       	call   800520 <fd2data>
  8013ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013b8:	e8 c3 ee ff ff       	call   800280 <sys_page_unmap>
}
  8013bd:	83 c4 14             	add    $0x14,%esp
  8013c0:	5b                   	pop    %ebx
  8013c1:	5d                   	pop    %ebp
  8013c2:	c3                   	ret    

008013c3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	57                   	push   %edi
  8013c7:	56                   	push   %esi
  8013c8:	53                   	push   %ebx
  8013c9:	83 ec 2c             	sub    $0x2c,%esp
  8013cc:	89 c6                	mov    %eax,%esi
  8013ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8013d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8013d6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8013d9:	89 34 24             	mov    %esi,(%esp)
  8013dc:	e8 e6 10 00 00       	call   8024c7 <pageref>
  8013e1:	89 c7                	mov    %eax,%edi
  8013e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e6:	89 04 24             	mov    %eax,(%esp)
  8013e9:	e8 d9 10 00 00       	call   8024c7 <pageref>
  8013ee:	39 c7                	cmp    %eax,%edi
  8013f0:	0f 94 c2             	sete   %dl
  8013f3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8013f6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  8013fc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8013ff:	39 fb                	cmp    %edi,%ebx
  801401:	74 21                	je     801424 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801403:	84 d2                	test   %dl,%dl
  801405:	74 ca                	je     8013d1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801407:	8b 51 58             	mov    0x58(%ecx),%edx
  80140a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80140e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801412:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801416:	c7 04 24 f9 28 80 00 	movl   $0x8028f9,(%esp)
  80141d:	e8 3d 05 00 00       	call   80195f <cprintf>
  801422:	eb ad                	jmp    8013d1 <_pipeisclosed+0xe>
	}
}
  801424:	83 c4 2c             	add    $0x2c,%esp
  801427:	5b                   	pop    %ebx
  801428:	5e                   	pop    %esi
  801429:	5f                   	pop    %edi
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	57                   	push   %edi
  801430:	56                   	push   %esi
  801431:	53                   	push   %ebx
  801432:	83 ec 1c             	sub    $0x1c,%esp
  801435:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801438:	89 34 24             	mov    %esi,(%esp)
  80143b:	e8 e0 f0 ff ff       	call   800520 <fd2data>
  801440:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801442:	bf 00 00 00 00       	mov    $0x0,%edi
  801447:	eb 45                	jmp    80148e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801449:	89 da                	mov    %ebx,%edx
  80144b:	89 f0                	mov    %esi,%eax
  80144d:	e8 71 ff ff ff       	call   8013c3 <_pipeisclosed>
  801452:	85 c0                	test   %eax,%eax
  801454:	75 41                	jne    801497 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801456:	e8 5f ed ff ff       	call   8001ba <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80145b:	8b 43 04             	mov    0x4(%ebx),%eax
  80145e:	8b 0b                	mov    (%ebx),%ecx
  801460:	8d 51 20             	lea    0x20(%ecx),%edx
  801463:	39 d0                	cmp    %edx,%eax
  801465:	73 e2                	jae    801449 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801467:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80146a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80146e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801471:	99                   	cltd   
  801472:	c1 ea 1b             	shr    $0x1b,%edx
  801475:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801478:	83 e1 1f             	and    $0x1f,%ecx
  80147b:	29 d1                	sub    %edx,%ecx
  80147d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801481:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801485:	83 c0 01             	add    $0x1,%eax
  801488:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80148b:	83 c7 01             	add    $0x1,%edi
  80148e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801491:	75 c8                	jne    80145b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801493:	89 f8                	mov    %edi,%eax
  801495:	eb 05                	jmp    80149c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801497:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80149c:	83 c4 1c             	add    $0x1c,%esp
  80149f:	5b                   	pop    %ebx
  8014a0:	5e                   	pop    %esi
  8014a1:	5f                   	pop    %edi
  8014a2:	5d                   	pop    %ebp
  8014a3:	c3                   	ret    

008014a4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	57                   	push   %edi
  8014a8:	56                   	push   %esi
  8014a9:	53                   	push   %ebx
  8014aa:	83 ec 1c             	sub    $0x1c,%esp
  8014ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8014b0:	89 3c 24             	mov    %edi,(%esp)
  8014b3:	e8 68 f0 ff ff       	call   800520 <fd2data>
  8014b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014ba:	be 00 00 00 00       	mov    $0x0,%esi
  8014bf:	eb 3d                	jmp    8014fe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8014c1:	85 f6                	test   %esi,%esi
  8014c3:	74 04                	je     8014c9 <devpipe_read+0x25>
				return i;
  8014c5:	89 f0                	mov    %esi,%eax
  8014c7:	eb 43                	jmp    80150c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8014c9:	89 da                	mov    %ebx,%edx
  8014cb:	89 f8                	mov    %edi,%eax
  8014cd:	e8 f1 fe ff ff       	call   8013c3 <_pipeisclosed>
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	75 31                	jne    801507 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8014d6:	e8 df ec ff ff       	call   8001ba <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8014db:	8b 03                	mov    (%ebx),%eax
  8014dd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8014e0:	74 df                	je     8014c1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8014e2:	99                   	cltd   
  8014e3:	c1 ea 1b             	shr    $0x1b,%edx
  8014e6:	01 d0                	add    %edx,%eax
  8014e8:	83 e0 1f             	and    $0x1f,%eax
  8014eb:	29 d0                	sub    %edx,%eax
  8014ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8014f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8014f8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014fb:	83 c6 01             	add    $0x1,%esi
  8014fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  801501:	75 d8                	jne    8014db <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801503:	89 f0                	mov    %esi,%eax
  801505:	eb 05                	jmp    80150c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801507:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80150c:	83 c4 1c             	add    $0x1c,%esp
  80150f:	5b                   	pop    %ebx
  801510:	5e                   	pop    %esi
  801511:	5f                   	pop    %edi
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    

00801514 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
  801519:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80151c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151f:	89 04 24             	mov    %eax,(%esp)
  801522:	e8 10 f0 ff ff       	call   800537 <fd_alloc>
  801527:	89 c2                	mov    %eax,%edx
  801529:	85 d2                	test   %edx,%edx
  80152b:	0f 88 4d 01 00 00    	js     80167e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801531:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801538:	00 
  801539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801540:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801547:	e8 8d ec ff ff       	call   8001d9 <sys_page_alloc>
  80154c:	89 c2                	mov    %eax,%edx
  80154e:	85 d2                	test   %edx,%edx
  801550:	0f 88 28 01 00 00    	js     80167e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801556:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801559:	89 04 24             	mov    %eax,(%esp)
  80155c:	e8 d6 ef ff ff       	call   800537 <fd_alloc>
  801561:	89 c3                	mov    %eax,%ebx
  801563:	85 c0                	test   %eax,%eax
  801565:	0f 88 fe 00 00 00    	js     801669 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80156b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801572:	00 
  801573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801576:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801581:	e8 53 ec ff ff       	call   8001d9 <sys_page_alloc>
  801586:	89 c3                	mov    %eax,%ebx
  801588:	85 c0                	test   %eax,%eax
  80158a:	0f 88 d9 00 00 00    	js     801669 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	89 04 24             	mov    %eax,(%esp)
  801596:	e8 85 ef ff ff       	call   800520 <fd2data>
  80159b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80159d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8015a4:	00 
  8015a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b0:	e8 24 ec ff ff       	call   8001d9 <sys_page_alloc>
  8015b5:	89 c3                	mov    %eax,%ebx
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	0f 88 97 00 00 00    	js     801656 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c2:	89 04 24             	mov    %eax,(%esp)
  8015c5:	e8 56 ef ff ff       	call   800520 <fd2data>
  8015ca:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8015d1:	00 
  8015d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015dd:	00 
  8015de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e9:	e8 3f ec ff ff       	call   80022d <sys_page_map>
  8015ee:	89 c3                	mov    %eax,%ebx
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	78 52                	js     801646 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8015f4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8015ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801602:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801609:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80160f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801612:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801617:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80161e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801621:	89 04 24             	mov    %eax,(%esp)
  801624:	e8 e7 ee ff ff       	call   800510 <fd2num>
  801629:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80162e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801631:	89 04 24             	mov    %eax,(%esp)
  801634:	e8 d7 ee ff ff       	call   800510 <fd2num>
  801639:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80163c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80163f:	b8 00 00 00 00       	mov    $0x0,%eax
  801644:	eb 38                	jmp    80167e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801646:	89 74 24 04          	mov    %esi,0x4(%esp)
  80164a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801651:	e8 2a ec ff ff       	call   800280 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801659:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801664:	e8 17 ec ff ff       	call   800280 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801670:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801677:	e8 04 ec ff ff       	call   800280 <sys_page_unmap>
  80167c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80167e:	83 c4 30             	add    $0x30,%esp
  801681:	5b                   	pop    %ebx
  801682:	5e                   	pop    %esi
  801683:	5d                   	pop    %ebp
  801684:	c3                   	ret    

00801685 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80168b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	89 04 24             	mov    %eax,(%esp)
  801698:	e8 e9 ee ff ff       	call   800586 <fd_lookup>
  80169d:	89 c2                	mov    %eax,%edx
  80169f:	85 d2                	test   %edx,%edx
  8016a1:	78 15                	js     8016b8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a6:	89 04 24             	mov    %eax,(%esp)
  8016a9:	e8 72 ee ff ff       	call   800520 <fd2data>
	return _pipeisclosed(fd, p);
  8016ae:	89 c2                	mov    %eax,%edx
  8016b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b3:	e8 0b fd ff ff       	call   8013c3 <_pipeisclosed>
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    
  8016ba:	66 90                	xchg   %ax,%ax
  8016bc:	66 90                	xchg   %ax,%ax
  8016be:	66 90                	xchg   %ax,%ax

008016c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8016c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c8:	5d                   	pop    %ebp
  8016c9:	c3                   	ret    

008016ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8016d0:	c7 44 24 04 11 29 80 	movl   $0x802911,0x4(%esp)
  8016d7:	00 
  8016d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016db:	89 04 24             	mov    %eax,(%esp)
  8016de:	e8 f4 08 00 00       	call   801fd7 <strcpy>
	return 0;
}
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	57                   	push   %edi
  8016ee:	56                   	push   %esi
  8016ef:	53                   	push   %ebx
  8016f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8016fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801701:	eb 31                	jmp    801734 <devcons_write+0x4a>
		m = n - tot;
  801703:	8b 75 10             	mov    0x10(%ebp),%esi
  801706:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  801708:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80170b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801710:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801713:	89 74 24 08          	mov    %esi,0x8(%esp)
  801717:	03 45 0c             	add    0xc(%ebp),%eax
  80171a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171e:	89 3c 24             	mov    %edi,(%esp)
  801721:	e8 4e 0a 00 00       	call   802174 <memmove>
		sys_cputs(buf, m);
  801726:	89 74 24 04          	mov    %esi,0x4(%esp)
  80172a:	89 3c 24             	mov    %edi,(%esp)
  80172d:	e8 88 e9 ff ff       	call   8000ba <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801732:	01 f3                	add    %esi,%ebx
  801734:	89 d8                	mov    %ebx,%eax
  801736:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801739:	72 c8                	jb     801703 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80173b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801741:	5b                   	pop    %ebx
  801742:	5e                   	pop    %esi
  801743:	5f                   	pop    %edi
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    

00801746 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801751:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801755:	75 07                	jne    80175e <devcons_read+0x18>
  801757:	eb 2a                	jmp    801783 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801759:	e8 5c ea ff ff       	call   8001ba <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80175e:	66 90                	xchg   %ax,%ax
  801760:	e8 73 e9 ff ff       	call   8000d8 <sys_cgetc>
  801765:	85 c0                	test   %eax,%eax
  801767:	74 f0                	je     801759 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 16                	js     801783 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80176d:	83 f8 04             	cmp    $0x4,%eax
  801770:	74 0c                	je     80177e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801772:	8b 55 0c             	mov    0xc(%ebp),%edx
  801775:	88 02                	mov    %al,(%edx)
	return 1;
  801777:	b8 01 00 00 00       	mov    $0x1,%eax
  80177c:	eb 05                	jmp    801783 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80177e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801791:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801798:	00 
  801799:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80179c:	89 04 24             	mov    %eax,(%esp)
  80179f:	e8 16 e9 ff ff       	call   8000ba <sys_cputs>
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <getchar>:

int
getchar(void)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8017ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017b3:	00 
  8017b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8017b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c2:	e8 53 f0 ff ff       	call   80081a <read>
	if (r < 0)
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 0f                	js     8017da <getchar+0x34>
		return r;
	if (r < 1)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	7e 06                	jle    8017d5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8017cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8017d3:	eb 05                	jmp    8017da <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8017d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	89 04 24             	mov    %eax,(%esp)
  8017ef:	e8 92 ed ff ff       	call   800586 <fd_lookup>
  8017f4:	85 c0                	test   %eax,%eax
  8017f6:	78 11                	js     801809 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801801:	39 10                	cmp    %edx,(%eax)
  801803:	0f 94 c0             	sete   %al
  801806:	0f b6 c0             	movzbl %al,%eax
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <opencons>:

int
opencons(void)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801811:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801814:	89 04 24             	mov    %eax,(%esp)
  801817:	e8 1b ed ff ff       	call   800537 <fd_alloc>
		return r;
  80181c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 40                	js     801862 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801822:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801829:	00 
  80182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801831:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801838:	e8 9c e9 ff ff       	call   8001d9 <sys_page_alloc>
		return r;
  80183d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 1f                	js     801862 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801843:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80184e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801851:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801858:	89 04 24             	mov    %eax,(%esp)
  80185b:	e8 b0 ec ff ff       	call   800510 <fd2num>
  801860:	89 c2                	mov    %eax,%edx
}
  801862:	89 d0                	mov    %edx,%eax
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	56                   	push   %esi
  80186a:	53                   	push   %ebx
  80186b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80186e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801871:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801877:	e8 1f e9 ff ff       	call   80019b <sys_getenvid>
  80187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801883:	8b 55 08             	mov    0x8(%ebp),%edx
  801886:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80188a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80188e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801892:	c7 04 24 20 29 80 00 	movl   $0x802920,(%esp)
  801899:	e8 c1 00 00 00       	call   80195f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80189e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a5:	89 04 24             	mov    %eax,(%esp)
  8018a8:	e8 51 00 00 00       	call   8018fe <vcprintf>
	cprintf("\n");
  8018ad:	c7 04 24 b7 28 80 00 	movl   $0x8028b7,(%esp)
  8018b4:	e8 a6 00 00 00       	call   80195f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8018b9:	cc                   	int3   
  8018ba:	eb fd                	jmp    8018b9 <_panic+0x53>

008018bc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	53                   	push   %ebx
  8018c0:	83 ec 14             	sub    $0x14,%esp
  8018c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8018c6:	8b 13                	mov    (%ebx),%edx
  8018c8:	8d 42 01             	lea    0x1(%edx),%eax
  8018cb:	89 03                	mov    %eax,(%ebx)
  8018cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8018d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8018d9:	75 19                	jne    8018f4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8018db:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8018e2:	00 
  8018e3:	8d 43 08             	lea    0x8(%ebx),%eax
  8018e6:	89 04 24             	mov    %eax,(%esp)
  8018e9:	e8 cc e7 ff ff       	call   8000ba <sys_cputs>
		b->idx = 0;
  8018ee:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8018f4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8018f8:	83 c4 14             	add    $0x14,%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801907:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80190e:	00 00 00 
	b.cnt = 0;
  801911:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801918:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80191b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	89 44 24 08          	mov    %eax,0x8(%esp)
  801929:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80192f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801933:	c7 04 24 bc 18 80 00 	movl   $0x8018bc,(%esp)
  80193a:	e8 75 01 00 00       	call   801ab4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80193f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801945:	89 44 24 04          	mov    %eax,0x4(%esp)
  801949:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80194f:	89 04 24             	mov    %eax,(%esp)
  801952:	e8 63 e7 ff ff       	call   8000ba <sys_cputs>

	return b.cnt;
}
  801957:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801965:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801968:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	89 04 24             	mov    %eax,(%esp)
  801972:	e8 87 ff ff ff       	call   8018fe <vcprintf>
	va_end(ap);

	return cnt;
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    
  801979:	66 90                	xchg   %ax,%ax
  80197b:	66 90                	xchg   %ax,%ax
  80197d:	66 90                	xchg   %ax,%ax
  80197f:	90                   	nop

00801980 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	57                   	push   %edi
  801984:	56                   	push   %esi
  801985:	53                   	push   %ebx
  801986:	83 ec 3c             	sub    $0x3c,%esp
  801989:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80198c:	89 d7                	mov    %edx,%edi
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	89 c3                	mov    %eax,%ebx
  801999:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80199c:	8b 45 10             	mov    0x10(%ebp),%eax
  80199f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8019a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8019ad:	39 d9                	cmp    %ebx,%ecx
  8019af:	72 05                	jb     8019b6 <printnum+0x36>
  8019b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8019b4:	77 69                	ja     801a1f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8019b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8019b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8019bd:	83 ee 01             	sub    $0x1,%esi
  8019c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019cc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8019d0:	89 c3                	mov    %eax,%ebx
  8019d2:	89 d6                	mov    %edx,%esi
  8019d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8019da:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e5:	89 04 24             	mov    %eax,(%esp)
  8019e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ef:	e8 1c 0b 00 00       	call   802510 <__udivdi3>
  8019f4:	89 d9                	mov    %ebx,%ecx
  8019f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019fe:	89 04 24             	mov    %eax,(%esp)
  801a01:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a05:	89 fa                	mov    %edi,%edx
  801a07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a0a:	e8 71 ff ff ff       	call   801980 <printnum>
  801a0f:	eb 1b                	jmp    801a2c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801a11:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a15:	8b 45 18             	mov    0x18(%ebp),%eax
  801a18:	89 04 24             	mov    %eax,(%esp)
  801a1b:	ff d3                	call   *%ebx
  801a1d:	eb 03                	jmp    801a22 <printnum+0xa2>
  801a1f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801a22:	83 ee 01             	sub    $0x1,%esi
  801a25:	85 f6                	test   %esi,%esi
  801a27:	7f e8                	jg     801a11 <printnum+0x91>
  801a29:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801a2c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a30:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801a34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a3e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a45:	89 04 24             	mov    %eax,(%esp)
  801a48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4f:	e8 ec 0b 00 00       	call   802640 <__umoddi3>
  801a54:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a58:	0f be 80 43 29 80 00 	movsbl 0x802943(%eax),%eax
  801a5f:	89 04 24             	mov    %eax,(%esp)
  801a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a65:	ff d0                	call   *%eax
}
  801a67:	83 c4 3c             	add    $0x3c,%esp
  801a6a:	5b                   	pop    %ebx
  801a6b:	5e                   	pop    %esi
  801a6c:	5f                   	pop    %edi
  801a6d:	5d                   	pop    %ebp
  801a6e:	c3                   	ret    

00801a6f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a75:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801a79:	8b 10                	mov    (%eax),%edx
  801a7b:	3b 50 04             	cmp    0x4(%eax),%edx
  801a7e:	73 0a                	jae    801a8a <sprintputch+0x1b>
		*b->buf++ = ch;
  801a80:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a83:	89 08                	mov    %ecx,(%eax)
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	88 02                	mov    %al,(%edx)
}
  801a8a:	5d                   	pop    %ebp
  801a8b:	c3                   	ret    

00801a8c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a92:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801a95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a99:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	89 04 24             	mov    %eax,(%esp)
  801aad:	e8 02 00 00 00       	call   801ab4 <vprintfmt>
	va_end(ap);
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	57                   	push   %edi
  801ab8:	56                   	push   %esi
  801ab9:	53                   	push   %ebx
  801aba:	83 ec 3c             	sub    $0x3c,%esp
  801abd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ac0:	eb 17                	jmp    801ad9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	0f 84 4b 04 00 00    	je     801f15 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  801aca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801acd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad1:	89 04 24             	mov    %eax,(%esp)
  801ad4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  801ad7:	89 fb                	mov    %edi,%ebx
  801ad9:	8d 7b 01             	lea    0x1(%ebx),%edi
  801adc:	0f b6 03             	movzbl (%ebx),%eax
  801adf:	83 f8 25             	cmp    $0x25,%eax
  801ae2:	75 de                	jne    801ac2 <vprintfmt+0xe>
  801ae4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  801ae8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801aef:	be ff ff ff ff       	mov    $0xffffffff,%esi
  801af4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801afb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b00:	eb 18                	jmp    801b1a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b02:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801b04:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  801b08:	eb 10                	jmp    801b1a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b0a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b0c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  801b10:	eb 08                	jmp    801b1a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801b12:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801b15:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b1a:	8d 5f 01             	lea    0x1(%edi),%ebx
  801b1d:	0f b6 17             	movzbl (%edi),%edx
  801b20:	0f b6 c2             	movzbl %dl,%eax
  801b23:	83 ea 23             	sub    $0x23,%edx
  801b26:	80 fa 55             	cmp    $0x55,%dl
  801b29:	0f 87 c2 03 00 00    	ja     801ef1 <vprintfmt+0x43d>
  801b2f:	0f b6 d2             	movzbl %dl,%edx
  801b32:	ff 24 95 80 2a 80 00 	jmp    *0x802a80(,%edx,4)
  801b39:	89 df                	mov    %ebx,%edi
  801b3b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801b40:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  801b43:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  801b47:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  801b4a:	8d 50 d0             	lea    -0x30(%eax),%edx
  801b4d:	83 fa 09             	cmp    $0x9,%edx
  801b50:	77 33                	ja     801b85 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b52:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b55:	eb e9                	jmp    801b40 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b57:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5a:	8b 30                	mov    (%eax),%esi
  801b5c:	8d 40 04             	lea    0x4(%eax),%eax
  801b5f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b62:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801b64:	eb 1f                	jmp    801b85 <vprintfmt+0xd1>
  801b66:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801b69:	85 ff                	test   %edi,%edi
  801b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b70:	0f 49 c7             	cmovns %edi,%eax
  801b73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b76:	89 df                	mov    %ebx,%edi
  801b78:	eb a0                	jmp    801b1a <vprintfmt+0x66>
  801b7a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801b7c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  801b83:	eb 95                	jmp    801b1a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  801b85:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b89:	79 8f                	jns    801b1a <vprintfmt+0x66>
  801b8b:	eb 85                	jmp    801b12 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b8d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b90:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801b92:	eb 86                	jmp    801b1a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b94:	8b 45 14             	mov    0x14(%ebp),%eax
  801b97:	8d 70 04             	lea    0x4(%eax),%esi
  801b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba4:	8b 00                	mov    (%eax),%eax
  801ba6:	89 04 24             	mov    %eax,(%esp)
  801ba9:	ff 55 08             	call   *0x8(%ebp)
  801bac:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  801baf:	e9 25 ff ff ff       	jmp    801ad9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bb4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb7:	8d 70 04             	lea    0x4(%eax),%esi
  801bba:	8b 00                	mov    (%eax),%eax
  801bbc:	99                   	cltd   
  801bbd:	31 d0                	xor    %edx,%eax
  801bbf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801bc1:	83 f8 15             	cmp    $0x15,%eax
  801bc4:	7f 0b                	jg     801bd1 <vprintfmt+0x11d>
  801bc6:	8b 14 85 e0 2b 80 00 	mov    0x802be0(,%eax,4),%edx
  801bcd:	85 d2                	test   %edx,%edx
  801bcf:	75 26                	jne    801bf7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  801bd1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bd5:	c7 44 24 08 5b 29 80 	movl   $0x80295b,0x8(%esp)
  801bdc:	00 
  801bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	89 04 24             	mov    %eax,(%esp)
  801bea:	e8 9d fe ff ff       	call   801a8c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bef:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801bf2:	e9 e2 fe ff ff       	jmp    801ad9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801bf7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801bfb:	c7 44 24 08 86 28 80 	movl   $0x802886,0x8(%esp)
  801c02:	00 
  801c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	89 04 24             	mov    %eax,(%esp)
  801c10:	e8 77 fe ff ff       	call   801a8c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  801c15:	89 75 14             	mov    %esi,0x14(%ebp)
  801c18:	e9 bc fe ff ff       	jmp    801ad9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c1d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c20:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801c23:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c26:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801c2a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801c2c:	85 ff                	test   %edi,%edi
  801c2e:	b8 54 29 80 00       	mov    $0x802954,%eax
  801c33:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801c36:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  801c3a:	0f 84 94 00 00 00    	je     801cd4 <vprintfmt+0x220>
  801c40:	85 c9                	test   %ecx,%ecx
  801c42:	0f 8e 94 00 00 00    	jle    801cdc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c48:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c4c:	89 3c 24             	mov    %edi,(%esp)
  801c4f:	e8 64 03 00 00       	call   801fb8 <strnlen>
  801c54:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801c57:	29 c1                	sub    %eax,%ecx
  801c59:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  801c5c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  801c60:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801c63:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801c66:	8b 75 08             	mov    0x8(%ebp),%esi
  801c69:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c6c:	89 cb                	mov    %ecx,%ebx
  801c6e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c70:	eb 0f                	jmp    801c81 <vprintfmt+0x1cd>
					putch(padc, putdat);
  801c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c79:	89 3c 24             	mov    %edi,(%esp)
  801c7c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c7e:	83 eb 01             	sub    $0x1,%ebx
  801c81:	85 db                	test   %ebx,%ebx
  801c83:	7f ed                	jg     801c72 <vprintfmt+0x1be>
  801c85:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c88:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801c8b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801c8e:	85 c9                	test   %ecx,%ecx
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
  801c95:	0f 49 c1             	cmovns %ecx,%eax
  801c98:	29 c1                	sub    %eax,%ecx
  801c9a:	89 cb                	mov    %ecx,%ebx
  801c9c:	eb 44                	jmp    801ce2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801c9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ca2:	74 1e                	je     801cc2 <vprintfmt+0x20e>
  801ca4:	0f be d2             	movsbl %dl,%edx
  801ca7:	83 ea 20             	sub    $0x20,%edx
  801caa:	83 fa 5e             	cmp    $0x5e,%edx
  801cad:	76 13                	jbe    801cc2 <vprintfmt+0x20e>
					putch('?', putdat);
  801caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801cbd:	ff 55 08             	call   *0x8(%ebp)
  801cc0:	eb 0d                	jmp    801ccf <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  801cc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cc9:	89 04 24             	mov    %eax,(%esp)
  801ccc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ccf:	83 eb 01             	sub    $0x1,%ebx
  801cd2:	eb 0e                	jmp    801ce2 <vprintfmt+0x22e>
  801cd4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801cd7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801cda:	eb 06                	jmp    801ce2 <vprintfmt+0x22e>
  801cdc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801cdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801ce2:	83 c7 01             	add    $0x1,%edi
  801ce5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801ce9:	0f be c2             	movsbl %dl,%eax
  801cec:	85 c0                	test   %eax,%eax
  801cee:	74 27                	je     801d17 <vprintfmt+0x263>
  801cf0:	85 f6                	test   %esi,%esi
  801cf2:	78 aa                	js     801c9e <vprintfmt+0x1ea>
  801cf4:	83 ee 01             	sub    $0x1,%esi
  801cf7:	79 a5                	jns    801c9e <vprintfmt+0x1ea>
  801cf9:	89 d8                	mov    %ebx,%eax
  801cfb:	8b 75 08             	mov    0x8(%ebp),%esi
  801cfe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d01:	89 c3                	mov    %eax,%ebx
  801d03:	eb 18                	jmp    801d1d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801d05:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d09:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801d10:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d12:	83 eb 01             	sub    $0x1,%ebx
  801d15:	eb 06                	jmp    801d1d <vprintfmt+0x269>
  801d17:	8b 75 08             	mov    0x8(%ebp),%esi
  801d1a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d1d:	85 db                	test   %ebx,%ebx
  801d1f:	7f e4                	jg     801d05 <vprintfmt+0x251>
  801d21:	89 75 08             	mov    %esi,0x8(%ebp)
  801d24:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d2a:	e9 aa fd ff ff       	jmp    801ad9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801d2f:	83 f9 01             	cmp    $0x1,%ecx
  801d32:	7e 10                	jle    801d44 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  801d34:	8b 45 14             	mov    0x14(%ebp),%eax
  801d37:	8b 30                	mov    (%eax),%esi
  801d39:	8b 78 04             	mov    0x4(%eax),%edi
  801d3c:	8d 40 08             	lea    0x8(%eax),%eax
  801d3f:	89 45 14             	mov    %eax,0x14(%ebp)
  801d42:	eb 26                	jmp    801d6a <vprintfmt+0x2b6>
	else if (lflag)
  801d44:	85 c9                	test   %ecx,%ecx
  801d46:	74 12                	je     801d5a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  801d48:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4b:	8b 30                	mov    (%eax),%esi
  801d4d:	89 f7                	mov    %esi,%edi
  801d4f:	c1 ff 1f             	sar    $0x1f,%edi
  801d52:	8d 40 04             	lea    0x4(%eax),%eax
  801d55:	89 45 14             	mov    %eax,0x14(%ebp)
  801d58:	eb 10                	jmp    801d6a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  801d5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5d:	8b 30                	mov    (%eax),%esi
  801d5f:	89 f7                	mov    %esi,%edi
  801d61:	c1 ff 1f             	sar    $0x1f,%edi
  801d64:	8d 40 04             	lea    0x4(%eax),%eax
  801d67:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d6a:	89 f0                	mov    %esi,%eax
  801d6c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801d6e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801d73:	85 ff                	test   %edi,%edi
  801d75:	0f 89 3a 01 00 00    	jns    801eb5 <vprintfmt+0x401>
				putch('-', putdat);
  801d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d82:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801d89:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801d8c:	89 f0                	mov    %esi,%eax
  801d8e:	89 fa                	mov    %edi,%edx
  801d90:	f7 d8                	neg    %eax
  801d92:	83 d2 00             	adc    $0x0,%edx
  801d95:	f7 da                	neg    %edx
			}
			base = 10;
  801d97:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d9c:	e9 14 01 00 00       	jmp    801eb5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801da1:	83 f9 01             	cmp    $0x1,%ecx
  801da4:	7e 13                	jle    801db9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  801da6:	8b 45 14             	mov    0x14(%ebp),%eax
  801da9:	8b 50 04             	mov    0x4(%eax),%edx
  801dac:	8b 00                	mov    (%eax),%eax
  801dae:	8b 75 14             	mov    0x14(%ebp),%esi
  801db1:	8d 4e 08             	lea    0x8(%esi),%ecx
  801db4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801db7:	eb 2c                	jmp    801de5 <vprintfmt+0x331>
	else if (lflag)
  801db9:	85 c9                	test   %ecx,%ecx
  801dbb:	74 15                	je     801dd2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  801dbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc0:	8b 00                	mov    (%eax),%eax
  801dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc7:	8b 75 14             	mov    0x14(%ebp),%esi
  801dca:	8d 76 04             	lea    0x4(%esi),%esi
  801dcd:	89 75 14             	mov    %esi,0x14(%ebp)
  801dd0:	eb 13                	jmp    801de5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  801dd2:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd5:	8b 00                	mov    (%eax),%eax
  801dd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801ddc:	8b 75 14             	mov    0x14(%ebp),%esi
  801ddf:	8d 76 04             	lea    0x4(%esi),%esi
  801de2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  801de5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801dea:	e9 c6 00 00 00       	jmp    801eb5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801def:	83 f9 01             	cmp    $0x1,%ecx
  801df2:	7e 13                	jle    801e07 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  801df4:	8b 45 14             	mov    0x14(%ebp),%eax
  801df7:	8b 50 04             	mov    0x4(%eax),%edx
  801dfa:	8b 00                	mov    (%eax),%eax
  801dfc:	8b 75 14             	mov    0x14(%ebp),%esi
  801dff:	8d 4e 08             	lea    0x8(%esi),%ecx
  801e02:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801e05:	eb 24                	jmp    801e2b <vprintfmt+0x377>
	else if (lflag)
  801e07:	85 c9                	test   %ecx,%ecx
  801e09:	74 11                	je     801e1c <vprintfmt+0x368>
		return va_arg(*ap, long);
  801e0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0e:	8b 00                	mov    (%eax),%eax
  801e10:	99                   	cltd   
  801e11:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e14:	8d 71 04             	lea    0x4(%ecx),%esi
  801e17:	89 75 14             	mov    %esi,0x14(%ebp)
  801e1a:	eb 0f                	jmp    801e2b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  801e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e1f:	8b 00                	mov    (%eax),%eax
  801e21:	99                   	cltd   
  801e22:	8b 75 14             	mov    0x14(%ebp),%esi
  801e25:	8d 76 04             	lea    0x4(%esi),%esi
  801e28:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  801e2b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801e30:	e9 80 00 00 00       	jmp    801eb5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e35:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  801e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e3f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801e46:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e50:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801e57:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801e5a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e5e:	8b 06                	mov    (%esi),%eax
  801e60:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801e65:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801e6a:	eb 49                	jmp    801eb5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801e6c:	83 f9 01             	cmp    $0x1,%ecx
  801e6f:	7e 13                	jle    801e84 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  801e71:	8b 45 14             	mov    0x14(%ebp),%eax
  801e74:	8b 50 04             	mov    0x4(%eax),%edx
  801e77:	8b 00                	mov    (%eax),%eax
  801e79:	8b 75 14             	mov    0x14(%ebp),%esi
  801e7c:	8d 4e 08             	lea    0x8(%esi),%ecx
  801e7f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801e82:	eb 2c                	jmp    801eb0 <vprintfmt+0x3fc>
	else if (lflag)
  801e84:	85 c9                	test   %ecx,%ecx
  801e86:	74 15                	je     801e9d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  801e88:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8b:	8b 00                	mov    (%eax),%eax
  801e8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e92:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e95:	8d 71 04             	lea    0x4(%ecx),%esi
  801e98:	89 75 14             	mov    %esi,0x14(%ebp)
  801e9b:	eb 13                	jmp    801eb0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  801e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea0:	8b 00                	mov    (%eax),%eax
  801ea2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea7:	8b 75 14             	mov    0x14(%ebp),%esi
  801eaa:	8d 76 04             	lea    0x4(%esi),%esi
  801ead:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  801eb0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801eb5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  801eb9:	89 74 24 10          	mov    %esi,0x10(%esp)
  801ebd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  801ec0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ec4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ec8:	89 04 24             	mov    %eax,(%esp)
  801ecb:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	e8 a6 fa ff ff       	call   801980 <printnum>
			break;
  801eda:	e9 fa fb ff ff       	jmp    801ad9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ee2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ee6:	89 04 24             	mov    %eax,(%esp)
  801ee9:	ff 55 08             	call   *0x8(%ebp)
			break;
  801eec:	e9 e8 fb ff ff       	jmp    801ad9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801eff:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801f02:	89 fb                	mov    %edi,%ebx
  801f04:	eb 03                	jmp    801f09 <vprintfmt+0x455>
  801f06:	83 eb 01             	sub    $0x1,%ebx
  801f09:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801f0d:	75 f7                	jne    801f06 <vprintfmt+0x452>
  801f0f:	90                   	nop
  801f10:	e9 c4 fb ff ff       	jmp    801ad9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801f15:	83 c4 3c             	add    $0x3c,%esp
  801f18:	5b                   	pop    %ebx
  801f19:	5e                   	pop    %esi
  801f1a:	5f                   	pop    %edi
  801f1b:	5d                   	pop    %ebp
  801f1c:	c3                   	ret    

00801f1d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 28             	sub    $0x28,%esp
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f2c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801f30:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801f33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f3a:	85 c0                	test   %eax,%eax
  801f3c:	74 30                	je     801f6e <vsnprintf+0x51>
  801f3e:	85 d2                	test   %edx,%edx
  801f40:	7e 2c                	jle    801f6e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f42:	8b 45 14             	mov    0x14(%ebp),%eax
  801f45:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f49:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f57:	c7 04 24 6f 1a 80 00 	movl   $0x801a6f,(%esp)
  801f5e:	e8 51 fb ff ff       	call   801ab4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f66:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	eb 05                	jmp    801f73 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801f6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f7b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f7e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f82:	8b 45 10             	mov    0x10(%ebp),%eax
  801f85:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	89 04 24             	mov    %eax,(%esp)
  801f96:	e8 82 ff ff ff       	call   801f1d <vsnprintf>
	va_end(ap);

	return rc;
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    
  801f9d:	66 90                	xchg   %ax,%ax
  801f9f:	90                   	nop

00801fa0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fab:	eb 03                	jmp    801fb0 <strlen+0x10>
		n++;
  801fad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801fb0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801fb4:	75 f7                	jne    801fad <strlen+0xd>
		n++;
	return n;
}
  801fb6:	5d                   	pop    %ebp
  801fb7:	c3                   	ret    

00801fb8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fbe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc6:	eb 03                	jmp    801fcb <strnlen+0x13>
		n++;
  801fc8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fcb:	39 d0                	cmp    %edx,%eax
  801fcd:	74 06                	je     801fd5 <strnlen+0x1d>
  801fcf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801fd3:	75 f3                	jne    801fc8 <strnlen+0x10>
		n++;
	return n;
}
  801fd5:	5d                   	pop    %ebp
  801fd6:	c3                   	ret    

00801fd7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	53                   	push   %ebx
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801fe1:	89 c2                	mov    %eax,%edx
  801fe3:	83 c2 01             	add    $0x1,%edx
  801fe6:	83 c1 01             	add    $0x1,%ecx
  801fe9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801fed:	88 5a ff             	mov    %bl,-0x1(%edx)
  801ff0:	84 db                	test   %bl,%bl
  801ff2:	75 ef                	jne    801fe3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801ff4:	5b                   	pop    %ebx
  801ff5:	5d                   	pop    %ebp
  801ff6:	c3                   	ret    

00801ff7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	53                   	push   %ebx
  801ffb:	83 ec 08             	sub    $0x8,%esp
  801ffe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802001:	89 1c 24             	mov    %ebx,(%esp)
  802004:	e8 97 ff ff ff       	call   801fa0 <strlen>
	strcpy(dst + len, src);
  802009:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802010:	01 d8                	add    %ebx,%eax
  802012:	89 04 24             	mov    %eax,(%esp)
  802015:	e8 bd ff ff ff       	call   801fd7 <strcpy>
	return dst;
}
  80201a:	89 d8                	mov    %ebx,%eax
  80201c:	83 c4 08             	add    $0x8,%esp
  80201f:	5b                   	pop    %ebx
  802020:	5d                   	pop    %ebp
  802021:	c3                   	ret    

00802022 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	56                   	push   %esi
  802026:	53                   	push   %ebx
  802027:	8b 75 08             	mov    0x8(%ebp),%esi
  80202a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80202d:	89 f3                	mov    %esi,%ebx
  80202f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802032:	89 f2                	mov    %esi,%edx
  802034:	eb 0f                	jmp    802045 <strncpy+0x23>
		*dst++ = *src;
  802036:	83 c2 01             	add    $0x1,%edx
  802039:	0f b6 01             	movzbl (%ecx),%eax
  80203c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80203f:	80 39 01             	cmpb   $0x1,(%ecx)
  802042:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802045:	39 da                	cmp    %ebx,%edx
  802047:	75 ed                	jne    802036 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  802049:	89 f0                	mov    %esi,%eax
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5d                   	pop    %ebp
  80204e:	c3                   	ret    

0080204f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
  802054:	8b 75 08             	mov    0x8(%ebp),%esi
  802057:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80205d:	89 f0                	mov    %esi,%eax
  80205f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802063:	85 c9                	test   %ecx,%ecx
  802065:	75 0b                	jne    802072 <strlcpy+0x23>
  802067:	eb 1d                	jmp    802086 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802069:	83 c0 01             	add    $0x1,%eax
  80206c:	83 c2 01             	add    $0x1,%edx
  80206f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802072:	39 d8                	cmp    %ebx,%eax
  802074:	74 0b                	je     802081 <strlcpy+0x32>
  802076:	0f b6 0a             	movzbl (%edx),%ecx
  802079:	84 c9                	test   %cl,%cl
  80207b:	75 ec                	jne    802069 <strlcpy+0x1a>
  80207d:	89 c2                	mov    %eax,%edx
  80207f:	eb 02                	jmp    802083 <strlcpy+0x34>
  802081:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  802083:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  802086:	29 f0                	sub    %esi,%eax
}
  802088:	5b                   	pop    %ebx
  802089:	5e                   	pop    %esi
  80208a:	5d                   	pop    %ebp
  80208b:	c3                   	ret    

0080208c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
  80208f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802092:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802095:	eb 06                	jmp    80209d <strcmp+0x11>
		p++, q++;
  802097:	83 c1 01             	add    $0x1,%ecx
  80209a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80209d:	0f b6 01             	movzbl (%ecx),%eax
  8020a0:	84 c0                	test   %al,%al
  8020a2:	74 04                	je     8020a8 <strcmp+0x1c>
  8020a4:	3a 02                	cmp    (%edx),%al
  8020a6:	74 ef                	je     802097 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8020a8:	0f b6 c0             	movzbl %al,%eax
  8020ab:	0f b6 12             	movzbl (%edx),%edx
  8020ae:	29 d0                	sub    %edx,%eax
}
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    

008020b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	53                   	push   %ebx
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bc:	89 c3                	mov    %eax,%ebx
  8020be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8020c1:	eb 06                	jmp    8020c9 <strncmp+0x17>
		n--, p++, q++;
  8020c3:	83 c0 01             	add    $0x1,%eax
  8020c6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8020c9:	39 d8                	cmp    %ebx,%eax
  8020cb:	74 15                	je     8020e2 <strncmp+0x30>
  8020cd:	0f b6 08             	movzbl (%eax),%ecx
  8020d0:	84 c9                	test   %cl,%cl
  8020d2:	74 04                	je     8020d8 <strncmp+0x26>
  8020d4:	3a 0a                	cmp    (%edx),%cl
  8020d6:	74 eb                	je     8020c3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020d8:	0f b6 00             	movzbl (%eax),%eax
  8020db:	0f b6 12             	movzbl (%edx),%edx
  8020de:	29 d0                	sub    %edx,%eax
  8020e0:	eb 05                	jmp    8020e7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8020e7:	5b                   	pop    %ebx
  8020e8:	5d                   	pop    %ebp
  8020e9:	c3                   	ret    

008020ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020f4:	eb 07                	jmp    8020fd <strchr+0x13>
		if (*s == c)
  8020f6:	38 ca                	cmp    %cl,%dl
  8020f8:	74 0f                	je     802109 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020fa:	83 c0 01             	add    $0x1,%eax
  8020fd:	0f b6 10             	movzbl (%eax),%edx
  802100:	84 d2                	test   %dl,%dl
  802102:	75 f2                	jne    8020f6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802109:	5d                   	pop    %ebp
  80210a:	c3                   	ret    

0080210b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802115:	eb 07                	jmp    80211e <strfind+0x13>
		if (*s == c)
  802117:	38 ca                	cmp    %cl,%dl
  802119:	74 0a                	je     802125 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80211b:	83 c0 01             	add    $0x1,%eax
  80211e:	0f b6 10             	movzbl (%eax),%edx
  802121:	84 d2                	test   %dl,%dl
  802123:	75 f2                	jne    802117 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  802125:	5d                   	pop    %ebp
  802126:	c3                   	ret    

00802127 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	57                   	push   %edi
  80212b:	56                   	push   %esi
  80212c:	53                   	push   %ebx
  80212d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802130:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802133:	85 c9                	test   %ecx,%ecx
  802135:	74 36                	je     80216d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802137:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80213d:	75 28                	jne    802167 <memset+0x40>
  80213f:	f6 c1 03             	test   $0x3,%cl
  802142:	75 23                	jne    802167 <memset+0x40>
		c &= 0xFF;
  802144:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802148:	89 d3                	mov    %edx,%ebx
  80214a:	c1 e3 08             	shl    $0x8,%ebx
  80214d:	89 d6                	mov    %edx,%esi
  80214f:	c1 e6 18             	shl    $0x18,%esi
  802152:	89 d0                	mov    %edx,%eax
  802154:	c1 e0 10             	shl    $0x10,%eax
  802157:	09 f0                	or     %esi,%eax
  802159:	09 c2                	or     %eax,%edx
  80215b:	89 d0                	mov    %edx,%eax
  80215d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80215f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802162:	fc                   	cld    
  802163:	f3 ab                	rep stos %eax,%es:(%edi)
  802165:	eb 06                	jmp    80216d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216a:	fc                   	cld    
  80216b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80216d:	89 f8                	mov    %edi,%eax
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5f                   	pop    %edi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    

00802174 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	57                   	push   %edi
  802178:	56                   	push   %esi
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80217f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802182:	39 c6                	cmp    %eax,%esi
  802184:	73 35                	jae    8021bb <memmove+0x47>
  802186:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802189:	39 d0                	cmp    %edx,%eax
  80218b:	73 2e                	jae    8021bb <memmove+0x47>
		s += n;
		d += n;
  80218d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802190:	89 d6                	mov    %edx,%esi
  802192:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802194:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80219a:	75 13                	jne    8021af <memmove+0x3b>
  80219c:	f6 c1 03             	test   $0x3,%cl
  80219f:	75 0e                	jne    8021af <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8021a1:	83 ef 04             	sub    $0x4,%edi
  8021a4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8021a7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8021aa:	fd                   	std    
  8021ab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8021ad:	eb 09                	jmp    8021b8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8021af:	83 ef 01             	sub    $0x1,%edi
  8021b2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8021b5:	fd                   	std    
  8021b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8021b8:	fc                   	cld    
  8021b9:	eb 1d                	jmp    8021d8 <memmove+0x64>
  8021bb:	89 f2                	mov    %esi,%edx
  8021bd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8021bf:	f6 c2 03             	test   $0x3,%dl
  8021c2:	75 0f                	jne    8021d3 <memmove+0x5f>
  8021c4:	f6 c1 03             	test   $0x3,%cl
  8021c7:	75 0a                	jne    8021d3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8021c9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8021cc:	89 c7                	mov    %eax,%edi
  8021ce:	fc                   	cld    
  8021cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8021d1:	eb 05                	jmp    8021d8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8021d3:	89 c7                	mov    %eax,%edi
  8021d5:	fc                   	cld    
  8021d6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8021d8:	5e                   	pop    %esi
  8021d9:	5f                   	pop    %edi
  8021da:	5d                   	pop    %ebp
  8021db:	c3                   	ret    

008021dc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8021e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	89 04 24             	mov    %eax,(%esp)
  8021f6:	e8 79 ff ff ff       	call   802174 <memmove>
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	56                   	push   %esi
  802201:	53                   	push   %ebx
  802202:	8b 55 08             	mov    0x8(%ebp),%edx
  802205:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802208:	89 d6                	mov    %edx,%esi
  80220a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80220d:	eb 1a                	jmp    802229 <memcmp+0x2c>
		if (*s1 != *s2)
  80220f:	0f b6 02             	movzbl (%edx),%eax
  802212:	0f b6 19             	movzbl (%ecx),%ebx
  802215:	38 d8                	cmp    %bl,%al
  802217:	74 0a                	je     802223 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  802219:	0f b6 c0             	movzbl %al,%eax
  80221c:	0f b6 db             	movzbl %bl,%ebx
  80221f:	29 d8                	sub    %ebx,%eax
  802221:	eb 0f                	jmp    802232 <memcmp+0x35>
		s1++, s2++;
  802223:	83 c2 01             	add    $0x1,%edx
  802226:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802229:	39 f2                	cmp    %esi,%edx
  80222b:	75 e2                	jne    80220f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802232:	5b                   	pop    %ebx
  802233:	5e                   	pop    %esi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    

00802236 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80223f:	89 c2                	mov    %eax,%edx
  802241:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802244:	eb 07                	jmp    80224d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802246:	38 08                	cmp    %cl,(%eax)
  802248:	74 07                	je     802251 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80224a:	83 c0 01             	add    $0x1,%eax
  80224d:	39 d0                	cmp    %edx,%eax
  80224f:	72 f5                	jb     802246 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802251:	5d                   	pop    %ebp
  802252:	c3                   	ret    

00802253 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	57                   	push   %edi
  802257:	56                   	push   %esi
  802258:	53                   	push   %ebx
  802259:	8b 55 08             	mov    0x8(%ebp),%edx
  80225c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80225f:	eb 03                	jmp    802264 <strtol+0x11>
		s++;
  802261:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802264:	0f b6 0a             	movzbl (%edx),%ecx
  802267:	80 f9 09             	cmp    $0x9,%cl
  80226a:	74 f5                	je     802261 <strtol+0xe>
  80226c:	80 f9 20             	cmp    $0x20,%cl
  80226f:	74 f0                	je     802261 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802271:	80 f9 2b             	cmp    $0x2b,%cl
  802274:	75 0a                	jne    802280 <strtol+0x2d>
		s++;
  802276:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802279:	bf 00 00 00 00       	mov    $0x0,%edi
  80227e:	eb 11                	jmp    802291 <strtol+0x3e>
  802280:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802285:	80 f9 2d             	cmp    $0x2d,%cl
  802288:	75 07                	jne    802291 <strtol+0x3e>
		s++, neg = 1;
  80228a:	8d 52 01             	lea    0x1(%edx),%edx
  80228d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802291:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802296:	75 15                	jne    8022ad <strtol+0x5a>
  802298:	80 3a 30             	cmpb   $0x30,(%edx)
  80229b:	75 10                	jne    8022ad <strtol+0x5a>
  80229d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8022a1:	75 0a                	jne    8022ad <strtol+0x5a>
		s += 2, base = 16;
  8022a3:	83 c2 02             	add    $0x2,%edx
  8022a6:	b8 10 00 00 00       	mov    $0x10,%eax
  8022ab:	eb 10                	jmp    8022bd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	75 0c                	jne    8022bd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8022b1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8022b3:	80 3a 30             	cmpb   $0x30,(%edx)
  8022b6:	75 05                	jne    8022bd <strtol+0x6a>
		s++, base = 8;
  8022b8:	83 c2 01             	add    $0x1,%edx
  8022bb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8022bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022c2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8022c5:	0f b6 0a             	movzbl (%edx),%ecx
  8022c8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8022cb:	89 f0                	mov    %esi,%eax
  8022cd:	3c 09                	cmp    $0x9,%al
  8022cf:	77 08                	ja     8022d9 <strtol+0x86>
			dig = *s - '0';
  8022d1:	0f be c9             	movsbl %cl,%ecx
  8022d4:	83 e9 30             	sub    $0x30,%ecx
  8022d7:	eb 20                	jmp    8022f9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8022d9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8022dc:	89 f0                	mov    %esi,%eax
  8022de:	3c 19                	cmp    $0x19,%al
  8022e0:	77 08                	ja     8022ea <strtol+0x97>
			dig = *s - 'a' + 10;
  8022e2:	0f be c9             	movsbl %cl,%ecx
  8022e5:	83 e9 57             	sub    $0x57,%ecx
  8022e8:	eb 0f                	jmp    8022f9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8022ea:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8022ed:	89 f0                	mov    %esi,%eax
  8022ef:	3c 19                	cmp    $0x19,%al
  8022f1:	77 16                	ja     802309 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8022f3:	0f be c9             	movsbl %cl,%ecx
  8022f6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8022f9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8022fc:	7d 0f                	jge    80230d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8022fe:	83 c2 01             	add    $0x1,%edx
  802301:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  802305:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  802307:	eb bc                	jmp    8022c5 <strtol+0x72>
  802309:	89 d8                	mov    %ebx,%eax
  80230b:	eb 02                	jmp    80230f <strtol+0xbc>
  80230d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80230f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802313:	74 05                	je     80231a <strtol+0xc7>
		*endptr = (char *) s;
  802315:	8b 75 0c             	mov    0xc(%ebp),%esi
  802318:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80231a:	f7 d8                	neg    %eax
  80231c:	85 ff                	test   %edi,%edi
  80231e:	0f 44 c3             	cmove  %ebx,%eax
}
  802321:	5b                   	pop    %ebx
  802322:	5e                   	pop    %esi
  802323:	5f                   	pop    %edi
  802324:	5d                   	pop    %ebp
  802325:	c3                   	ret    

00802326 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80232c:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802333:	75 7a                	jne    8023af <set_pgfault_handler+0x89>
		// First time through!
		// LAB 4: Your code here.

		//panic("set_pgfault_handler not implemented");
		//dont know--->>UXSTACKTOP-PGSIZE-'1'
		if ((r = sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  802335:	e8 61 de ff ff       	call   80019b <sys_getenvid>
  80233a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802341:	00 
  802342:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802349:	ee 
  80234a:	89 04 24             	mov    %eax,(%esp)
  80234d:	e8 87 de ff ff       	call   8001d9 <sys_page_alloc>
  802352:	85 c0                	test   %eax,%eax
  802354:	79 20                	jns    802376 <set_pgfault_handler+0x50>
			panic("sys_page_alloc: %e", r);
  802356:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80235a:	c7 44 24 08 57 2c 80 	movl   $0x802c57,0x8(%esp)
  802361:	00 
  802362:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  802369:	00 
  80236a:	c7 04 24 6a 2c 80 00 	movl   $0x802c6a,(%esp)
  802371:	e8 f0 f4 ff ff       	call   801866 <_panic>
		if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall)) < 0)
  802376:	e8 20 de ff ff       	call   80019b <sys_getenvid>
  80237b:	c7 44 24 04 e2 04 80 	movl   $0x8004e2,0x4(%esp)
  802382:	00 
  802383:	89 04 24             	mov    %eax,(%esp)
  802386:	e8 0e e0 ff ff       	call   800399 <sys_env_set_pgfault_upcall>
  80238b:	85 c0                	test   %eax,%eax
  80238d:	79 20                	jns    8023af <set_pgfault_handler+0x89>
			panic("pagefault upcall setup error: %e", r);
  80238f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802393:	c7 44 24 08 78 2c 80 	movl   $0x802c78,0x8(%esp)
  80239a:	00 
  80239b:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  8023a2:	00 
  8023a3:	c7 04 24 6a 2c 80 00 	movl   $0x802c6a,(%esp)
  8023aa:	e8 b7 f4 ff ff       	call   801866 <_panic>

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    
  8023b9:	66 90                	xchg   %ax,%ax
  8023bb:	66 90                	xchg   %ax,%ax
  8023bd:	66 90                	xchg   %ax,%ax
  8023bf:	90                   	nop

008023c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	56                   	push   %esi
  8023c4:	53                   	push   %ebx
  8023c5:	83 ec 10             	sub    $0x10,%esp
  8023c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8023cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8023d1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8023d3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8023d8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8023db:	89 04 24             	mov    %eax,(%esp)
  8023de:	e8 2c e0 ff ff       	call   80040f <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8023e3:	85 c0                	test   %eax,%eax
  8023e5:	75 26                	jne    80240d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8023e7:	85 f6                	test   %esi,%esi
  8023e9:	74 0a                	je     8023f5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8023eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8023f0:	8b 40 74             	mov    0x74(%eax),%eax
  8023f3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  8023f5:	85 db                	test   %ebx,%ebx
  8023f7:	74 0a                	je     802403 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  8023f9:	a1 08 40 80 00       	mov    0x804008,%eax
  8023fe:	8b 40 78             	mov    0x78(%eax),%eax
  802401:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802403:	a1 08 40 80 00       	mov    0x804008,%eax
  802408:	8b 40 70             	mov    0x70(%eax),%eax
  80240b:	eb 14                	jmp    802421 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80240d:	85 f6                	test   %esi,%esi
  80240f:	74 06                	je     802417 <ipc_recv+0x57>
			*from_env_store = 0;
  802411:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802417:	85 db                	test   %ebx,%ebx
  802419:	74 06                	je     802421 <ipc_recv+0x61>
			*perm_store = 0;
  80241b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802421:	83 c4 10             	add    $0x10,%esp
  802424:	5b                   	pop    %ebx
  802425:	5e                   	pop    %esi
  802426:	5d                   	pop    %ebp
  802427:	c3                   	ret    

00802428 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	57                   	push   %edi
  80242c:	56                   	push   %esi
  80242d:	53                   	push   %ebx
  80242e:	83 ec 1c             	sub    $0x1c,%esp
  802431:	8b 7d 08             	mov    0x8(%ebp),%edi
  802434:	8b 75 0c             	mov    0xc(%ebp),%esi
  802437:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80243a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80243c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802441:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802444:	8b 45 14             	mov    0x14(%ebp),%eax
  802447:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80244b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80244f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802453:	89 3c 24             	mov    %edi,(%esp)
  802456:	e8 91 df ff ff       	call   8003ec <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80245b:	85 c0                	test   %eax,%eax
  80245d:	74 28                	je     802487 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80245f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802462:	74 1c                	je     802480 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802464:	c7 44 24 08 9c 2c 80 	movl   $0x802c9c,0x8(%esp)
  80246b:	00 
  80246c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802473:	00 
  802474:	c7 04 24 c0 2c 80 00 	movl   $0x802cc0,(%esp)
  80247b:	e8 e6 f3 ff ff       	call   801866 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802480:	e8 35 dd ff ff       	call   8001ba <sys_yield>
	}
  802485:	eb bd                	jmp    802444 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802487:	83 c4 1c             	add    $0x1c,%esp
  80248a:	5b                   	pop    %ebx
  80248b:	5e                   	pop    %esi
  80248c:	5f                   	pop    %edi
  80248d:	5d                   	pop    %ebp
  80248e:	c3                   	ret    

0080248f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80249a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80249d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024a3:	8b 52 50             	mov    0x50(%edx),%edx
  8024a6:	39 ca                	cmp    %ecx,%edx
  8024a8:	75 0d                	jne    8024b7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8024aa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024ad:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8024b2:	8b 40 40             	mov    0x40(%eax),%eax
  8024b5:	eb 0e                	jmp    8024c5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024b7:	83 c0 01             	add    $0x1,%eax
  8024ba:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024bf:	75 d9                	jne    80249a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024c1:	66 b8 00 00          	mov    $0x0,%ax
}
  8024c5:	5d                   	pop    %ebp
  8024c6:	c3                   	ret    

008024c7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024cd:	89 d0                	mov    %edx,%eax
  8024cf:	c1 e8 16             	shr    $0x16,%eax
  8024d2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024d9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024de:	f6 c1 01             	test   $0x1,%cl
  8024e1:	74 1d                	je     802500 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024e3:	c1 ea 0c             	shr    $0xc,%edx
  8024e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024ed:	f6 c2 01             	test   $0x1,%dl
  8024f0:	74 0e                	je     802500 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024f2:	c1 ea 0c             	shr    $0xc,%edx
  8024f5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024fc:	ef 
  8024fd:	0f b7 c0             	movzwl %ax,%eax
}
  802500:	5d                   	pop    %ebp
  802501:	c3                   	ret    
  802502:	66 90                	xchg   %ax,%ax
  802504:	66 90                	xchg   %ax,%ax
  802506:	66 90                	xchg   %ax,%ax
  802508:	66 90                	xchg   %ax,%ax
  80250a:	66 90                	xchg   %ax,%ax
  80250c:	66 90                	xchg   %ax,%ax
  80250e:	66 90                	xchg   %ax,%ax

00802510 <__udivdi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	83 ec 0c             	sub    $0xc,%esp
  802516:	8b 44 24 28          	mov    0x28(%esp),%eax
  80251a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80251e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802522:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802526:	85 c0                	test   %eax,%eax
  802528:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80252c:	89 ea                	mov    %ebp,%edx
  80252e:	89 0c 24             	mov    %ecx,(%esp)
  802531:	75 2d                	jne    802560 <__udivdi3+0x50>
  802533:	39 e9                	cmp    %ebp,%ecx
  802535:	77 61                	ja     802598 <__udivdi3+0x88>
  802537:	85 c9                	test   %ecx,%ecx
  802539:	89 ce                	mov    %ecx,%esi
  80253b:	75 0b                	jne    802548 <__udivdi3+0x38>
  80253d:	b8 01 00 00 00       	mov    $0x1,%eax
  802542:	31 d2                	xor    %edx,%edx
  802544:	f7 f1                	div    %ecx
  802546:	89 c6                	mov    %eax,%esi
  802548:	31 d2                	xor    %edx,%edx
  80254a:	89 e8                	mov    %ebp,%eax
  80254c:	f7 f6                	div    %esi
  80254e:	89 c5                	mov    %eax,%ebp
  802550:	89 f8                	mov    %edi,%eax
  802552:	f7 f6                	div    %esi
  802554:	89 ea                	mov    %ebp,%edx
  802556:	83 c4 0c             	add    $0xc,%esp
  802559:	5e                   	pop    %esi
  80255a:	5f                   	pop    %edi
  80255b:	5d                   	pop    %ebp
  80255c:	c3                   	ret    
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	39 e8                	cmp    %ebp,%eax
  802562:	77 24                	ja     802588 <__udivdi3+0x78>
  802564:	0f bd e8             	bsr    %eax,%ebp
  802567:	83 f5 1f             	xor    $0x1f,%ebp
  80256a:	75 3c                	jne    8025a8 <__udivdi3+0x98>
  80256c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802570:	39 34 24             	cmp    %esi,(%esp)
  802573:	0f 86 9f 00 00 00    	jbe    802618 <__udivdi3+0x108>
  802579:	39 d0                	cmp    %edx,%eax
  80257b:	0f 82 97 00 00 00    	jb     802618 <__udivdi3+0x108>
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	31 d2                	xor    %edx,%edx
  80258a:	31 c0                	xor    %eax,%eax
  80258c:	83 c4 0c             	add    $0xc,%esp
  80258f:	5e                   	pop    %esi
  802590:	5f                   	pop    %edi
  802591:	5d                   	pop    %ebp
  802592:	c3                   	ret    
  802593:	90                   	nop
  802594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802598:	89 f8                	mov    %edi,%eax
  80259a:	f7 f1                	div    %ecx
  80259c:	31 d2                	xor    %edx,%edx
  80259e:	83 c4 0c             	add    $0xc,%esp
  8025a1:	5e                   	pop    %esi
  8025a2:	5f                   	pop    %edi
  8025a3:	5d                   	pop    %ebp
  8025a4:	c3                   	ret    
  8025a5:	8d 76 00             	lea    0x0(%esi),%esi
  8025a8:	89 e9                	mov    %ebp,%ecx
  8025aa:	8b 3c 24             	mov    (%esp),%edi
  8025ad:	d3 e0                	shl    %cl,%eax
  8025af:	89 c6                	mov    %eax,%esi
  8025b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8025b6:	29 e8                	sub    %ebp,%eax
  8025b8:	89 c1                	mov    %eax,%ecx
  8025ba:	d3 ef                	shr    %cl,%edi
  8025bc:	89 e9                	mov    %ebp,%ecx
  8025be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025c2:	8b 3c 24             	mov    (%esp),%edi
  8025c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8025c9:	89 d6                	mov    %edx,%esi
  8025cb:	d3 e7                	shl    %cl,%edi
  8025cd:	89 c1                	mov    %eax,%ecx
  8025cf:	89 3c 24             	mov    %edi,(%esp)
  8025d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025d6:	d3 ee                	shr    %cl,%esi
  8025d8:	89 e9                	mov    %ebp,%ecx
  8025da:	d3 e2                	shl    %cl,%edx
  8025dc:	89 c1                	mov    %eax,%ecx
  8025de:	d3 ef                	shr    %cl,%edi
  8025e0:	09 d7                	or     %edx,%edi
  8025e2:	89 f2                	mov    %esi,%edx
  8025e4:	89 f8                	mov    %edi,%eax
  8025e6:	f7 74 24 08          	divl   0x8(%esp)
  8025ea:	89 d6                	mov    %edx,%esi
  8025ec:	89 c7                	mov    %eax,%edi
  8025ee:	f7 24 24             	mull   (%esp)
  8025f1:	39 d6                	cmp    %edx,%esi
  8025f3:	89 14 24             	mov    %edx,(%esp)
  8025f6:	72 30                	jb     802628 <__udivdi3+0x118>
  8025f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025fc:	89 e9                	mov    %ebp,%ecx
  8025fe:	d3 e2                	shl    %cl,%edx
  802600:	39 c2                	cmp    %eax,%edx
  802602:	73 05                	jae    802609 <__udivdi3+0xf9>
  802604:	3b 34 24             	cmp    (%esp),%esi
  802607:	74 1f                	je     802628 <__udivdi3+0x118>
  802609:	89 f8                	mov    %edi,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	e9 7a ff ff ff       	jmp    80258c <__udivdi3+0x7c>
  802612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802618:	31 d2                	xor    %edx,%edx
  80261a:	b8 01 00 00 00       	mov    $0x1,%eax
  80261f:	e9 68 ff ff ff       	jmp    80258c <__udivdi3+0x7c>
  802624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802628:	8d 47 ff             	lea    -0x1(%edi),%eax
  80262b:	31 d2                	xor    %edx,%edx
  80262d:	83 c4 0c             	add    $0xc,%esp
  802630:	5e                   	pop    %esi
  802631:	5f                   	pop    %edi
  802632:	5d                   	pop    %ebp
  802633:	c3                   	ret    
  802634:	66 90                	xchg   %ax,%ax
  802636:	66 90                	xchg   %ax,%ax
  802638:	66 90                	xchg   %ax,%ax
  80263a:	66 90                	xchg   %ax,%ax
  80263c:	66 90                	xchg   %ax,%ax
  80263e:	66 90                	xchg   %ax,%ax

00802640 <__umoddi3>:
  802640:	55                   	push   %ebp
  802641:	57                   	push   %edi
  802642:	56                   	push   %esi
  802643:	83 ec 14             	sub    $0x14,%esp
  802646:	8b 44 24 28          	mov    0x28(%esp),%eax
  80264a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80264e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802652:	89 c7                	mov    %eax,%edi
  802654:	89 44 24 04          	mov    %eax,0x4(%esp)
  802658:	8b 44 24 30          	mov    0x30(%esp),%eax
  80265c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802660:	89 34 24             	mov    %esi,(%esp)
  802663:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802667:	85 c0                	test   %eax,%eax
  802669:	89 c2                	mov    %eax,%edx
  80266b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80266f:	75 17                	jne    802688 <__umoddi3+0x48>
  802671:	39 fe                	cmp    %edi,%esi
  802673:	76 4b                	jbe    8026c0 <__umoddi3+0x80>
  802675:	89 c8                	mov    %ecx,%eax
  802677:	89 fa                	mov    %edi,%edx
  802679:	f7 f6                	div    %esi
  80267b:	89 d0                	mov    %edx,%eax
  80267d:	31 d2                	xor    %edx,%edx
  80267f:	83 c4 14             	add    $0x14,%esp
  802682:	5e                   	pop    %esi
  802683:	5f                   	pop    %edi
  802684:	5d                   	pop    %ebp
  802685:	c3                   	ret    
  802686:	66 90                	xchg   %ax,%ax
  802688:	39 f8                	cmp    %edi,%eax
  80268a:	77 54                	ja     8026e0 <__umoddi3+0xa0>
  80268c:	0f bd e8             	bsr    %eax,%ebp
  80268f:	83 f5 1f             	xor    $0x1f,%ebp
  802692:	75 5c                	jne    8026f0 <__umoddi3+0xb0>
  802694:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802698:	39 3c 24             	cmp    %edi,(%esp)
  80269b:	0f 87 e7 00 00 00    	ja     802788 <__umoddi3+0x148>
  8026a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026a5:	29 f1                	sub    %esi,%ecx
  8026a7:	19 c7                	sbb    %eax,%edi
  8026a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026b5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8026b9:	83 c4 14             	add    $0x14,%esp
  8026bc:	5e                   	pop    %esi
  8026bd:	5f                   	pop    %edi
  8026be:	5d                   	pop    %ebp
  8026bf:	c3                   	ret    
  8026c0:	85 f6                	test   %esi,%esi
  8026c2:	89 f5                	mov    %esi,%ebp
  8026c4:	75 0b                	jne    8026d1 <__umoddi3+0x91>
  8026c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026cb:	31 d2                	xor    %edx,%edx
  8026cd:	f7 f6                	div    %esi
  8026cf:	89 c5                	mov    %eax,%ebp
  8026d1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026d5:	31 d2                	xor    %edx,%edx
  8026d7:	f7 f5                	div    %ebp
  8026d9:	89 c8                	mov    %ecx,%eax
  8026db:	f7 f5                	div    %ebp
  8026dd:	eb 9c                	jmp    80267b <__umoddi3+0x3b>
  8026df:	90                   	nop
  8026e0:	89 c8                	mov    %ecx,%eax
  8026e2:	89 fa                	mov    %edi,%edx
  8026e4:	83 c4 14             	add    $0x14,%esp
  8026e7:	5e                   	pop    %esi
  8026e8:	5f                   	pop    %edi
  8026e9:	5d                   	pop    %ebp
  8026ea:	c3                   	ret    
  8026eb:	90                   	nop
  8026ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026f0:	8b 04 24             	mov    (%esp),%eax
  8026f3:	be 20 00 00 00       	mov    $0x20,%esi
  8026f8:	89 e9                	mov    %ebp,%ecx
  8026fa:	29 ee                	sub    %ebp,%esi
  8026fc:	d3 e2                	shl    %cl,%edx
  8026fe:	89 f1                	mov    %esi,%ecx
  802700:	d3 e8                	shr    %cl,%eax
  802702:	89 e9                	mov    %ebp,%ecx
  802704:	89 44 24 04          	mov    %eax,0x4(%esp)
  802708:	8b 04 24             	mov    (%esp),%eax
  80270b:	09 54 24 04          	or     %edx,0x4(%esp)
  80270f:	89 fa                	mov    %edi,%edx
  802711:	d3 e0                	shl    %cl,%eax
  802713:	89 f1                	mov    %esi,%ecx
  802715:	89 44 24 08          	mov    %eax,0x8(%esp)
  802719:	8b 44 24 10          	mov    0x10(%esp),%eax
  80271d:	d3 ea                	shr    %cl,%edx
  80271f:	89 e9                	mov    %ebp,%ecx
  802721:	d3 e7                	shl    %cl,%edi
  802723:	89 f1                	mov    %esi,%ecx
  802725:	d3 e8                	shr    %cl,%eax
  802727:	89 e9                	mov    %ebp,%ecx
  802729:	09 f8                	or     %edi,%eax
  80272b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80272f:	f7 74 24 04          	divl   0x4(%esp)
  802733:	d3 e7                	shl    %cl,%edi
  802735:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802739:	89 d7                	mov    %edx,%edi
  80273b:	f7 64 24 08          	mull   0x8(%esp)
  80273f:	39 d7                	cmp    %edx,%edi
  802741:	89 c1                	mov    %eax,%ecx
  802743:	89 14 24             	mov    %edx,(%esp)
  802746:	72 2c                	jb     802774 <__umoddi3+0x134>
  802748:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80274c:	72 22                	jb     802770 <__umoddi3+0x130>
  80274e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802752:	29 c8                	sub    %ecx,%eax
  802754:	19 d7                	sbb    %edx,%edi
  802756:	89 e9                	mov    %ebp,%ecx
  802758:	89 fa                	mov    %edi,%edx
  80275a:	d3 e8                	shr    %cl,%eax
  80275c:	89 f1                	mov    %esi,%ecx
  80275e:	d3 e2                	shl    %cl,%edx
  802760:	89 e9                	mov    %ebp,%ecx
  802762:	d3 ef                	shr    %cl,%edi
  802764:	09 d0                	or     %edx,%eax
  802766:	89 fa                	mov    %edi,%edx
  802768:	83 c4 14             	add    $0x14,%esp
  80276b:	5e                   	pop    %esi
  80276c:	5f                   	pop    %edi
  80276d:	5d                   	pop    %ebp
  80276e:	c3                   	ret    
  80276f:	90                   	nop
  802770:	39 d7                	cmp    %edx,%edi
  802772:	75 da                	jne    80274e <__umoddi3+0x10e>
  802774:	8b 14 24             	mov    (%esp),%edx
  802777:	89 c1                	mov    %eax,%ecx
  802779:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80277d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802781:	eb cb                	jmp    80274e <__umoddi3+0x10e>
  802783:	90                   	nop
  802784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802788:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80278c:	0f 82 0f ff ff ff    	jb     8026a1 <__umoddi3+0x61>
  802792:	e9 1a ff ff ff       	jmp    8026b1 <__umoddi3+0x71>
