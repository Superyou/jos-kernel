
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $3");
  800036:	cc                   	int3   
}
  800037:	5d                   	pop    %ebp
  800038:	c3                   	ret    

00800039 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 10             	sub    $0x10,%esp
  800041:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800044:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800047:	e8 2f 01 00 00       	call   80017b <sys_getenvid>
  80004c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800051:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800054:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800059:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005e:	85 db                	test   %ebx,%ebx
  800060:	7e 07                	jle    800069 <libmain+0x30>
		binaryname = argv[0];
  800062:	8b 06                	mov    (%esi),%eax
  800064:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800069:	89 74 24 04          	mov    %esi,0x4(%esp)
  80006d:	89 1c 24             	mov    %ebx,(%esp)
  800070:	e8 be ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800075:	e8 07 00 00 00       	call   800081 <exit>
}
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	5b                   	pop    %ebx
  80007e:	5e                   	pop    %esi
  80007f:	5d                   	pop    %ebp
  800080:	c3                   	ret    

00800081 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800081:	55                   	push   %ebp
  800082:	89 e5                	mov    %esp,%ebp
  800084:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800087:	e8 1e 06 00 00       	call   8006aa <close_all>
	sys_env_destroy(0);
  80008c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800093:	e8 3f 00 00 00       	call   8000d7 <sys_env_destroy>
}
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	57                   	push   %edi
  80009e:	56                   	push   %esi
  80009f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ab:	89 c3                	mov    %eax,%ebx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 c6                	mov    %eax,%esi
  8000b1:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b3:	5b                   	pop    %ebx
  8000b4:	5e                   	pop    %esi
  8000b5:	5f                   	pop    %edi
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	57                   	push   %edi
  8000bc:	56                   	push   %esi
  8000bd:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000be:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c8:	89 d1                	mov    %edx,%ecx
  8000ca:	89 d3                	mov    %edx,%ebx
  8000cc:	89 d7                	mov    %edx,%edi
  8000ce:	89 d6                	mov    %edx,%esi
  8000d0:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d2:	5b                   	pop    %ebx
  8000d3:	5e                   	pop    %esi
  8000d4:	5f                   	pop    %edi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    

008000d7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	57                   	push   %edi
  8000db:	56                   	push   %esi
  8000dc:	53                   	push   %ebx
  8000dd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e5:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ed:	89 cb                	mov    %ecx,%ebx
  8000ef:	89 cf                	mov    %ecx,%edi
  8000f1:	89 ce                	mov    %ecx,%esi
  8000f3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	7e 28                	jle    800121 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8000f9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000fd:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800104:	00 
  800105:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  80010c:	00 
  80010d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800114:	00 
  800115:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  80011c:	e8 05 17 00 00       	call   801826 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800121:	83 c4 2c             	add    $0x2c,%esp
  800124:	5b                   	pop    %ebx
  800125:	5e                   	pop    %esi
  800126:	5f                   	pop    %edi
  800127:	5d                   	pop    %ebp
  800128:	c3                   	ret    

00800129 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	57                   	push   %edi
  80012d:	56                   	push   %esi
  80012e:	53                   	push   %ebx
  80012f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800132:	b9 00 00 00 00       	mov    $0x0,%ecx
  800137:	b8 04 00 00 00       	mov    $0x4,%eax
  80013c:	8b 55 08             	mov    0x8(%ebp),%edx
  80013f:	89 cb                	mov    %ecx,%ebx
  800141:	89 cf                	mov    %ecx,%edi
  800143:	89 ce                	mov    %ecx,%esi
  800145:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800147:	85 c0                	test   %eax,%eax
  800149:	7e 28                	jle    800173 <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80014b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80014f:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800156:	00 
  800157:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  80015e:	00 
  80015f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800166:	00 
  800167:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  80016e:	e8 b3 16 00 00       	call   801826 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  800173:	83 c4 2c             	add    $0x2c,%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5f                   	pop    %edi
  800179:	5d                   	pop    %ebp
  80017a:	c3                   	ret    

0080017b <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  80017b:	55                   	push   %ebp
  80017c:	89 e5                	mov    %esp,%ebp
  80017e:	57                   	push   %edi
  80017f:	56                   	push   %esi
  800180:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800181:	ba 00 00 00 00       	mov    $0x0,%edx
  800186:	b8 02 00 00 00       	mov    $0x2,%eax
  80018b:	89 d1                	mov    %edx,%ecx
  80018d:	89 d3                	mov    %edx,%ebx
  80018f:	89 d7                	mov    %edx,%edi
  800191:	89 d6                	mov    %edx,%esi
  800193:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800195:	5b                   	pop    %ebx
  800196:	5e                   	pop    %esi
  800197:	5f                   	pop    %edi
  800198:	5d                   	pop    %ebp
  800199:	c3                   	ret    

0080019a <sys_yield>:

void
sys_yield(void)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	57                   	push   %edi
  80019e:	56                   	push   %esi
  80019f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	89 d3                	mov    %edx,%ebx
  8001ae:	89 d7                	mov    %edx,%edi
  8001b0:	89 d6                	mov    %edx,%esi
  8001b2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001b4:	5b                   	pop    %ebx
  8001b5:	5e                   	pop    %esi
  8001b6:	5f                   	pop    %edi
  8001b7:	5d                   	pop    %ebp
  8001b8:	c3                   	ret    

008001b9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	57                   	push   %edi
  8001bd:	56                   	push   %esi
  8001be:	53                   	push   %ebx
  8001bf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001c2:	be 00 00 00 00       	mov    $0x0,%esi
  8001c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8001cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d5:	89 f7                	mov    %esi,%edi
  8001d7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001d9:	85 c0                	test   %eax,%eax
  8001db:	7e 28                	jle    800205 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001e1:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8001e8:	00 
  8001e9:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  8001f0:	00 
  8001f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001f8:	00 
  8001f9:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  800200:	e8 21 16 00 00       	call   801826 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800205:	83 c4 2c             	add    $0x2c,%esp
  800208:	5b                   	pop    %ebx
  800209:	5e                   	pop    %esi
  80020a:	5f                   	pop    %edi
  80020b:	5d                   	pop    %ebp
  80020c:	c3                   	ret    

0080020d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80020d:	55                   	push   %ebp
  80020e:	89 e5                	mov    %esp,%ebp
  800210:	57                   	push   %edi
  800211:	56                   	push   %esi
  800212:	53                   	push   %ebx
  800213:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800216:	b8 06 00 00 00       	mov    $0x6,%eax
  80021b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021e:	8b 55 08             	mov    0x8(%ebp),%edx
  800221:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800224:	8b 7d 14             	mov    0x14(%ebp),%edi
  800227:	8b 75 18             	mov    0x18(%ebp),%esi
  80022a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80022c:	85 c0                	test   %eax,%eax
  80022e:	7e 28                	jle    800258 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800230:	89 44 24 10          	mov    %eax,0x10(%esp)
  800234:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80023b:	00 
  80023c:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  800243:	00 
  800244:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80024b:	00 
  80024c:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  800253:	e8 ce 15 00 00       	call   801826 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800258:	83 c4 2c             	add    $0x2c,%esp
  80025b:	5b                   	pop    %ebx
  80025c:	5e                   	pop    %esi
  80025d:	5f                   	pop    %edi
  80025e:	5d                   	pop    %ebp
  80025f:	c3                   	ret    

00800260 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	57                   	push   %edi
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800269:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026e:	b8 07 00 00 00       	mov    $0x7,%eax
  800273:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800276:	8b 55 08             	mov    0x8(%ebp),%edx
  800279:	89 df                	mov    %ebx,%edi
  80027b:	89 de                	mov    %ebx,%esi
  80027d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80027f:	85 c0                	test   %eax,%eax
  800281:	7e 28                	jle    8002ab <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800283:	89 44 24 10          	mov    %eax,0x10(%esp)
  800287:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80028e:	00 
  80028f:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  800296:	00 
  800297:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80029e:	00 
  80029f:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  8002a6:	e8 7b 15 00 00       	call   801826 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8002ab:	83 c4 2c             	add    $0x2c,%esp
  8002ae:	5b                   	pop    %ebx
  8002af:	5e                   	pop    %esi
  8002b0:	5f                   	pop    %edi
  8002b1:	5d                   	pop    %ebp
  8002b2:	c3                   	ret    

008002b3 <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	57                   	push   %edi
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002be:	b8 10 00 00 00       	mov    $0x10,%eax
  8002c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c6:	89 cb                	mov    %ecx,%ebx
  8002c8:	89 cf                	mov    %ecx,%edi
  8002ca:	89 ce                	mov    %ecx,%esi
  8002cc:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  8002ce:	5b                   	pop    %ebx
  8002cf:	5e                   	pop    %esi
  8002d0:	5f                   	pop    %edi
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	57                   	push   %edi
  8002d7:	56                   	push   %esi
  8002d8:	53                   	push   %ebx
  8002d9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e1:	b8 09 00 00 00       	mov    $0x9,%eax
  8002e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ec:	89 df                	mov    %ebx,%edi
  8002ee:	89 de                	mov    %ebx,%esi
  8002f0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002f2:	85 c0                	test   %eax,%eax
  8002f4:	7e 28                	jle    80031e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002fa:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800301:	00 
  800302:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  800309:	00 
  80030a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800311:	00 
  800312:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  800319:	e8 08 15 00 00       	call   801826 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80031e:	83 c4 2c             	add    $0x2c,%esp
  800321:	5b                   	pop    %ebx
  800322:	5e                   	pop    %esi
  800323:	5f                   	pop    %edi
  800324:	5d                   	pop    %ebp
  800325:	c3                   	ret    

00800326 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	57                   	push   %edi
  80032a:	56                   	push   %esi
  80032b:	53                   	push   %ebx
  80032c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80032f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800334:	b8 0a 00 00 00       	mov    $0xa,%eax
  800339:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033c:	8b 55 08             	mov    0x8(%ebp),%edx
  80033f:	89 df                	mov    %ebx,%edi
  800341:	89 de                	mov    %ebx,%esi
  800343:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800345:	85 c0                	test   %eax,%eax
  800347:	7e 28                	jle    800371 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800349:	89 44 24 10          	mov    %eax,0x10(%esp)
  80034d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800354:	00 
  800355:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  80035c:	00 
  80035d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800364:	00 
  800365:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  80036c:	e8 b5 14 00 00       	call   801826 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800371:	83 c4 2c             	add    $0x2c,%esp
  800374:	5b                   	pop    %ebx
  800375:	5e                   	pop    %esi
  800376:	5f                   	pop    %edi
  800377:	5d                   	pop    %ebp
  800378:	c3                   	ret    

00800379 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	57                   	push   %edi
  80037d:	56                   	push   %esi
  80037e:	53                   	push   %ebx
  80037f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800382:	bb 00 00 00 00       	mov    $0x0,%ebx
  800387:	b8 0b 00 00 00       	mov    $0xb,%eax
  80038c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80038f:	8b 55 08             	mov    0x8(%ebp),%edx
  800392:	89 df                	mov    %ebx,%edi
  800394:	89 de                	mov    %ebx,%esi
  800396:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800398:	85 c0                	test   %eax,%eax
  80039a:	7e 28                	jle    8003c4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80039c:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003a0:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8003a7:	00 
  8003a8:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  8003af:	00 
  8003b0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003b7:	00 
  8003b8:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  8003bf:	e8 62 14 00 00       	call   801826 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8003c4:	83 c4 2c             	add    $0x2c,%esp
  8003c7:	5b                   	pop    %ebx
  8003c8:	5e                   	pop    %esi
  8003c9:	5f                   	pop    %edi
  8003ca:	5d                   	pop    %ebp
  8003cb:	c3                   	ret    

008003cc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	57                   	push   %edi
  8003d0:	56                   	push   %esi
  8003d1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003d2:	be 00 00 00 00       	mov    $0x0,%esi
  8003d7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003df:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003e5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003e8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8003ea:	5b                   	pop    %ebx
  8003eb:	5e                   	pop    %esi
  8003ec:	5f                   	pop    %edi
  8003ed:	5d                   	pop    %ebp
  8003ee:	c3                   	ret    

008003ef <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	57                   	push   %edi
  8003f3:	56                   	push   %esi
  8003f4:	53                   	push   %ebx
  8003f5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003fd:	b8 0e 00 00 00       	mov    $0xe,%eax
  800402:	8b 55 08             	mov    0x8(%ebp),%edx
  800405:	89 cb                	mov    %ecx,%ebx
  800407:	89 cf                	mov    %ecx,%edi
  800409:	89 ce                	mov    %ecx,%esi
  80040b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80040d:	85 c0                	test   %eax,%eax
  80040f:	7e 28                	jle    800439 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800411:	89 44 24 10          	mov    %eax,0x10(%esp)
  800415:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80041c:	00 
  80041d:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  800424:	00 
  800425:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80042c:	00 
  80042d:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  800434:	e8 ed 13 00 00       	call   801826 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800439:	83 c4 2c             	add    $0x2c,%esp
  80043c:	5b                   	pop    %ebx
  80043d:	5e                   	pop    %esi
  80043e:	5f                   	pop    %edi
  80043f:	5d                   	pop    %ebp
  800440:	c3                   	ret    

00800441 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800441:	55                   	push   %ebp
  800442:	89 e5                	mov    %esp,%ebp
  800444:	57                   	push   %edi
  800445:	56                   	push   %esi
  800446:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	b8 0f 00 00 00       	mov    $0xf,%eax
  800451:	89 d1                	mov    %edx,%ecx
  800453:	89 d3                	mov    %edx,%ebx
  800455:	89 d7                	mov    %edx,%edi
  800457:	89 d6                	mov    %edx,%esi
  800459:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80045b:	5b                   	pop    %ebx
  80045c:	5e                   	pop    %esi
  80045d:	5f                   	pop    %edi
  80045e:	5d                   	pop    %ebp
  80045f:	c3                   	ret    

00800460 <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	57                   	push   %edi
  800464:	56                   	push   %esi
  800465:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800466:	bb 00 00 00 00       	mov    $0x0,%ebx
  80046b:	b8 11 00 00 00       	mov    $0x11,%eax
  800470:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800473:	8b 55 08             	mov    0x8(%ebp),%edx
  800476:	89 df                	mov    %ebx,%edi
  800478:	89 de                	mov    %ebx,%esi
  80047a:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  80047c:	5b                   	pop    %ebx
  80047d:	5e                   	pop    %esi
  80047e:	5f                   	pop    %edi
  80047f:	5d                   	pop    %ebp
  800480:	c3                   	ret    

00800481 <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	57                   	push   %edi
  800485:	56                   	push   %esi
  800486:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800487:	bb 00 00 00 00       	mov    $0x0,%ebx
  80048c:	b8 12 00 00 00       	mov    $0x12,%eax
  800491:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800494:	8b 55 08             	mov    0x8(%ebp),%edx
  800497:	89 df                	mov    %ebx,%edi
  800499:	89 de                	mov    %ebx,%esi
  80049b:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  80049d:	5b                   	pop    %ebx
  80049e:	5e                   	pop    %esi
  80049f:	5f                   	pop    %edi
  8004a0:	5d                   	pop    %ebp
  8004a1:	c3                   	ret    

008004a2 <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	57                   	push   %edi
  8004a6:	56                   	push   %esi
  8004a7:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004ad:	b8 13 00 00 00       	mov    $0x13,%eax
  8004b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b5:	89 cb                	mov    %ecx,%ebx
  8004b7:	89 cf                	mov    %ecx,%edi
  8004b9:	89 ce                	mov    %ecx,%esi
  8004bb:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8004bd:	5b                   	pop    %ebx
  8004be:	5e                   	pop    %esi
  8004bf:	5f                   	pop    %edi
  8004c0:	5d                   	pop    %ebp
  8004c1:	c3                   	ret    
  8004c2:	66 90                	xchg   %ax,%ax
  8004c4:	66 90                	xchg   %ax,%ax
  8004c6:	66 90                	xchg   %ax,%ax
  8004c8:	66 90                	xchg   %ax,%ax
  8004ca:	66 90                	xchg   %ax,%ax
  8004cc:	66 90                	xchg   %ax,%ax
  8004ce:	66 90                	xchg   %ax,%ax

008004d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8004db:	c1 e8 0c             	shr    $0xc,%eax
}
  8004de:	5d                   	pop    %ebp
  8004df:	c3                   	ret    

008004e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8004eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004f0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8004f5:	5d                   	pop    %ebp
  8004f6:	c3                   	ret    

008004f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004fd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800502:	89 c2                	mov    %eax,%edx
  800504:	c1 ea 16             	shr    $0x16,%edx
  800507:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80050e:	f6 c2 01             	test   $0x1,%dl
  800511:	74 11                	je     800524 <fd_alloc+0x2d>
  800513:	89 c2                	mov    %eax,%edx
  800515:	c1 ea 0c             	shr    $0xc,%edx
  800518:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80051f:	f6 c2 01             	test   $0x1,%dl
  800522:	75 09                	jne    80052d <fd_alloc+0x36>
			*fd_store = fd;
  800524:	89 01                	mov    %eax,(%ecx)
			return 0;
  800526:	b8 00 00 00 00       	mov    $0x0,%eax
  80052b:	eb 17                	jmp    800544 <fd_alloc+0x4d>
  80052d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800532:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800537:	75 c9                	jne    800502 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800539:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80053f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800544:	5d                   	pop    %ebp
  800545:	c3                   	ret    

00800546 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80054c:	83 f8 1f             	cmp    $0x1f,%eax
  80054f:	77 36                	ja     800587 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800551:	c1 e0 0c             	shl    $0xc,%eax
  800554:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800559:	89 c2                	mov    %eax,%edx
  80055b:	c1 ea 16             	shr    $0x16,%edx
  80055e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800565:	f6 c2 01             	test   $0x1,%dl
  800568:	74 24                	je     80058e <fd_lookup+0x48>
  80056a:	89 c2                	mov    %eax,%edx
  80056c:	c1 ea 0c             	shr    $0xc,%edx
  80056f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800576:	f6 c2 01             	test   $0x1,%dl
  800579:	74 1a                	je     800595 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80057b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80057e:	89 02                	mov    %eax,(%edx)
	return 0;
  800580:	b8 00 00 00 00       	mov    $0x0,%eax
  800585:	eb 13                	jmp    80059a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800587:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80058c:	eb 0c                	jmp    80059a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80058e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800593:	eb 05                	jmp    80059a <fd_lookup+0x54>
  800595:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80059a:	5d                   	pop    %ebp
  80059b:	c3                   	ret    

0080059c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	83 ec 18             	sub    $0x18,%esp
  8005a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8005a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005aa:	eb 13                	jmp    8005bf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8005ac:	39 08                	cmp    %ecx,(%eax)
  8005ae:	75 0c                	jne    8005bc <dev_lookup+0x20>
			*dev = devtab[i];
  8005b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8005b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ba:	eb 38                	jmp    8005f4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005bc:	83 c2 01             	add    $0x1,%edx
  8005bf:	8b 04 95 94 27 80 00 	mov    0x802794(,%edx,4),%eax
  8005c6:	85 c0                	test   %eax,%eax
  8005c8:	75 e2                	jne    8005ac <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005ca:	a1 08 40 80 00       	mov    0x804008,%eax
  8005cf:	8b 40 48             	mov    0x48(%eax),%eax
  8005d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005da:	c7 04 24 18 27 80 00 	movl   $0x802718,(%esp)
  8005e1:	e8 39 13 00 00       	call   80191f <cprintf>
	*dev = 0;
  8005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8005ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	56                   	push   %esi
  8005fa:	53                   	push   %ebx
  8005fb:	83 ec 20             	sub    $0x20,%esp
  8005fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800601:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800604:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800607:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80060b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800611:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800614:	89 04 24             	mov    %eax,(%esp)
  800617:	e8 2a ff ff ff       	call   800546 <fd_lookup>
  80061c:	85 c0                	test   %eax,%eax
  80061e:	78 05                	js     800625 <fd_close+0x2f>
	    || fd != fd2)
  800620:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800623:	74 0c                	je     800631 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800625:	84 db                	test   %bl,%bl
  800627:	ba 00 00 00 00       	mov    $0x0,%edx
  80062c:	0f 44 c2             	cmove  %edx,%eax
  80062f:	eb 3f                	jmp    800670 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800631:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800634:	89 44 24 04          	mov    %eax,0x4(%esp)
  800638:	8b 06                	mov    (%esi),%eax
  80063a:	89 04 24             	mov    %eax,(%esp)
  80063d:	e8 5a ff ff ff       	call   80059c <dev_lookup>
  800642:	89 c3                	mov    %eax,%ebx
  800644:	85 c0                	test   %eax,%eax
  800646:	78 16                	js     80065e <fd_close+0x68>
		if (dev->dev_close)
  800648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80064e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800653:	85 c0                	test   %eax,%eax
  800655:	74 07                	je     80065e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800657:	89 34 24             	mov    %esi,(%esp)
  80065a:	ff d0                	call   *%eax
  80065c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80065e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800662:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800669:	e8 f2 fb ff ff       	call   800260 <sys_page_unmap>
	return r;
  80066e:	89 d8                	mov    %ebx,%eax
}
  800670:	83 c4 20             	add    $0x20,%esp
  800673:	5b                   	pop    %ebx
  800674:	5e                   	pop    %esi
  800675:	5d                   	pop    %ebp
  800676:	c3                   	ret    

00800677 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800677:	55                   	push   %ebp
  800678:	89 e5                	mov    %esp,%ebp
  80067a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80067d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800680:	89 44 24 04          	mov    %eax,0x4(%esp)
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	89 04 24             	mov    %eax,(%esp)
  80068a:	e8 b7 fe ff ff       	call   800546 <fd_lookup>
  80068f:	89 c2                	mov    %eax,%edx
  800691:	85 d2                	test   %edx,%edx
  800693:	78 13                	js     8006a8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800695:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80069c:	00 
  80069d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a0:	89 04 24             	mov    %eax,(%esp)
  8006a3:	e8 4e ff ff ff       	call   8005f6 <fd_close>
}
  8006a8:	c9                   	leave  
  8006a9:	c3                   	ret    

008006aa <close_all>:

void
close_all(void)
{
  8006aa:	55                   	push   %ebp
  8006ab:	89 e5                	mov    %esp,%ebp
  8006ad:	53                   	push   %ebx
  8006ae:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006b6:	89 1c 24             	mov    %ebx,(%esp)
  8006b9:	e8 b9 ff ff ff       	call   800677 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006be:	83 c3 01             	add    $0x1,%ebx
  8006c1:	83 fb 20             	cmp    $0x20,%ebx
  8006c4:	75 f0                	jne    8006b6 <close_all+0xc>
		close(i);
}
  8006c6:	83 c4 14             	add    $0x14,%esp
  8006c9:	5b                   	pop    %ebx
  8006ca:	5d                   	pop    %ebp
  8006cb:	c3                   	ret    

008006cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006cc:	55                   	push   %ebp
  8006cd:	89 e5                	mov    %esp,%ebp
  8006cf:	57                   	push   %edi
  8006d0:	56                   	push   %esi
  8006d1:	53                   	push   %ebx
  8006d2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	89 04 24             	mov    %eax,(%esp)
  8006e2:	e8 5f fe ff ff       	call   800546 <fd_lookup>
  8006e7:	89 c2                	mov    %eax,%edx
  8006e9:	85 d2                	test   %edx,%edx
  8006eb:	0f 88 e1 00 00 00    	js     8007d2 <dup+0x106>
		return r;
	close(newfdnum);
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	89 04 24             	mov    %eax,(%esp)
  8006f7:	e8 7b ff ff ff       	call   800677 <close>

	newfd = INDEX2FD(newfdnum);
  8006fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006ff:	c1 e3 0c             	shl    $0xc,%ebx
  800702:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80070b:	89 04 24             	mov    %eax,(%esp)
  80070e:	e8 cd fd ff ff       	call   8004e0 <fd2data>
  800713:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800715:	89 1c 24             	mov    %ebx,(%esp)
  800718:	e8 c3 fd ff ff       	call   8004e0 <fd2data>
  80071d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80071f:	89 f0                	mov    %esi,%eax
  800721:	c1 e8 16             	shr    $0x16,%eax
  800724:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80072b:	a8 01                	test   $0x1,%al
  80072d:	74 43                	je     800772 <dup+0xa6>
  80072f:	89 f0                	mov    %esi,%eax
  800731:	c1 e8 0c             	shr    $0xc,%eax
  800734:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80073b:	f6 c2 01             	test   $0x1,%dl
  80073e:	74 32                	je     800772 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800740:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800747:	25 07 0e 00 00       	and    $0xe07,%eax
  80074c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800750:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800754:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80075b:	00 
  80075c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800760:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800767:	e8 a1 fa ff ff       	call   80020d <sys_page_map>
  80076c:	89 c6                	mov    %eax,%esi
  80076e:	85 c0                	test   %eax,%eax
  800770:	78 3e                	js     8007b0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800775:	89 c2                	mov    %eax,%edx
  800777:	c1 ea 0c             	shr    $0xc,%edx
  80077a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800781:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800787:	89 54 24 10          	mov    %edx,0x10(%esp)
  80078b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80078f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800796:	00 
  800797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007a2:	e8 66 fa ff ff       	call   80020d <sys_page_map>
  8007a7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8007ac:	85 f6                	test   %esi,%esi
  8007ae:	79 22                	jns    8007d2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007bb:	e8 a0 fa ff ff       	call   800260 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8007c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007cb:	e8 90 fa ff ff       	call   800260 <sys_page_unmap>
	return r;
  8007d0:	89 f0                	mov    %esi,%eax
}
  8007d2:	83 c4 3c             	add    $0x3c,%esp
  8007d5:	5b                   	pop    %ebx
  8007d6:	5e                   	pop    %esi
  8007d7:	5f                   	pop    %edi
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	53                   	push   %ebx
  8007de:	83 ec 24             	sub    $0x24,%esp
  8007e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007eb:	89 1c 24             	mov    %ebx,(%esp)
  8007ee:	e8 53 fd ff ff       	call   800546 <fd_lookup>
  8007f3:	89 c2                	mov    %eax,%edx
  8007f5:	85 d2                	test   %edx,%edx
  8007f7:	78 6d                	js     800866 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	89 04 24             	mov    %eax,(%esp)
  800808:	e8 8f fd ff ff       	call   80059c <dev_lookup>
  80080d:	85 c0                	test   %eax,%eax
  80080f:	78 55                	js     800866 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800814:	8b 50 08             	mov    0x8(%eax),%edx
  800817:	83 e2 03             	and    $0x3,%edx
  80081a:	83 fa 01             	cmp    $0x1,%edx
  80081d:	75 23                	jne    800842 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80081f:	a1 08 40 80 00       	mov    0x804008,%eax
  800824:	8b 40 48             	mov    0x48(%eax),%eax
  800827:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80082b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082f:	c7 04 24 59 27 80 00 	movl   $0x802759,(%esp)
  800836:	e8 e4 10 00 00       	call   80191f <cprintf>
		return -E_INVAL;
  80083b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800840:	eb 24                	jmp    800866 <read+0x8c>
	}
	if (!dev->dev_read)
  800842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800845:	8b 52 08             	mov    0x8(%edx),%edx
  800848:	85 d2                	test   %edx,%edx
  80084a:	74 15                	je     800861 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80084c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80084f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800853:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800856:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80085a:	89 04 24             	mov    %eax,(%esp)
  80085d:	ff d2                	call   *%edx
  80085f:	eb 05                	jmp    800866 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800861:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800866:	83 c4 24             	add    $0x24,%esp
  800869:	5b                   	pop    %ebx
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    

0080086c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	57                   	push   %edi
  800870:	56                   	push   %esi
  800871:	53                   	push   %ebx
  800872:	83 ec 1c             	sub    $0x1c,%esp
  800875:	8b 7d 08             	mov    0x8(%ebp),%edi
  800878:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80087b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800880:	eb 23                	jmp    8008a5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800882:	89 f0                	mov    %esi,%eax
  800884:	29 d8                	sub    %ebx,%eax
  800886:	89 44 24 08          	mov    %eax,0x8(%esp)
  80088a:	89 d8                	mov    %ebx,%eax
  80088c:	03 45 0c             	add    0xc(%ebp),%eax
  80088f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800893:	89 3c 24             	mov    %edi,(%esp)
  800896:	e8 3f ff ff ff       	call   8007da <read>
		if (m < 0)
  80089b:	85 c0                	test   %eax,%eax
  80089d:	78 10                	js     8008af <readn+0x43>
			return m;
		if (m == 0)
  80089f:	85 c0                	test   %eax,%eax
  8008a1:	74 0a                	je     8008ad <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008a3:	01 c3                	add    %eax,%ebx
  8008a5:	39 f3                	cmp    %esi,%ebx
  8008a7:	72 d9                	jb     800882 <readn+0x16>
  8008a9:	89 d8                	mov    %ebx,%eax
  8008ab:	eb 02                	jmp    8008af <readn+0x43>
  8008ad:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8008af:	83 c4 1c             	add    $0x1c,%esp
  8008b2:	5b                   	pop    %ebx
  8008b3:	5e                   	pop    %esi
  8008b4:	5f                   	pop    %edi
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	53                   	push   %ebx
  8008bb:	83 ec 24             	sub    $0x24,%esp
  8008be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c8:	89 1c 24             	mov    %ebx,(%esp)
  8008cb:	e8 76 fc ff ff       	call   800546 <fd_lookup>
  8008d0:	89 c2                	mov    %eax,%edx
  8008d2:	85 d2                	test   %edx,%edx
  8008d4:	78 68                	js     80093e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	89 04 24             	mov    %eax,(%esp)
  8008e5:	e8 b2 fc ff ff       	call   80059c <dev_lookup>
  8008ea:	85 c0                	test   %eax,%eax
  8008ec:	78 50                	js     80093e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008f5:	75 23                	jne    80091a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8008f7:	a1 08 40 80 00       	mov    0x804008,%eax
  8008fc:	8b 40 48             	mov    0x48(%eax),%eax
  8008ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800903:	89 44 24 04          	mov    %eax,0x4(%esp)
  800907:	c7 04 24 75 27 80 00 	movl   $0x802775,(%esp)
  80090e:	e8 0c 10 00 00       	call   80191f <cprintf>
		return -E_INVAL;
  800913:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800918:	eb 24                	jmp    80093e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80091a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80091d:	8b 52 0c             	mov    0xc(%edx),%edx
  800920:	85 d2                	test   %edx,%edx
  800922:	74 15                	je     800939 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800924:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800927:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80092b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800932:	89 04 24             	mov    %eax,(%esp)
  800935:	ff d2                	call   *%edx
  800937:	eb 05                	jmp    80093e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800939:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80093e:	83 c4 24             	add    $0x24,%esp
  800941:	5b                   	pop    %ebx
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <seek>:

int
seek(int fdnum, off_t offset)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80094a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80094d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	89 04 24             	mov    %eax,(%esp)
  800957:	e8 ea fb ff ff       	call   800546 <fd_lookup>
  80095c:	85 c0                	test   %eax,%eax
  80095e:	78 0e                	js     80096e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800960:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800963:	8b 55 0c             	mov    0xc(%ebp),%edx
  800966:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800969:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096e:	c9                   	leave  
  80096f:	c3                   	ret    

00800970 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	53                   	push   %ebx
  800974:	83 ec 24             	sub    $0x24,%esp
  800977:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80097a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80097d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800981:	89 1c 24             	mov    %ebx,(%esp)
  800984:	e8 bd fb ff ff       	call   800546 <fd_lookup>
  800989:	89 c2                	mov    %eax,%edx
  80098b:	85 d2                	test   %edx,%edx
  80098d:	78 61                	js     8009f0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80098f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800992:	89 44 24 04          	mov    %eax,0x4(%esp)
  800996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800999:	8b 00                	mov    (%eax),%eax
  80099b:	89 04 24             	mov    %eax,(%esp)
  80099e:	e8 f9 fb ff ff       	call   80059c <dev_lookup>
  8009a3:	85 c0                	test   %eax,%eax
  8009a5:	78 49                	js     8009f0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009ae:	75 23                	jne    8009d3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8009b0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009b5:	8b 40 48             	mov    0x48(%eax),%eax
  8009b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009c0:	c7 04 24 38 27 80 00 	movl   $0x802738,(%esp)
  8009c7:	e8 53 0f 00 00       	call   80191f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d1:	eb 1d                	jmp    8009f0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8009d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d6:	8b 52 18             	mov    0x18(%edx),%edx
  8009d9:	85 d2                	test   %edx,%edx
  8009db:	74 0e                	je     8009eb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8009dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009e4:	89 04 24             	mov    %eax,(%esp)
  8009e7:	ff d2                	call   *%edx
  8009e9:	eb 05                	jmp    8009f0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8009eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8009f0:	83 c4 24             	add    $0x24,%esp
  8009f3:	5b                   	pop    %ebx
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	53                   	push   %ebx
  8009fa:	83 ec 24             	sub    $0x24,%esp
  8009fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	89 04 24             	mov    %eax,(%esp)
  800a0d:	e8 34 fb ff ff       	call   800546 <fd_lookup>
  800a12:	89 c2                	mov    %eax,%edx
  800a14:	85 d2                	test   %edx,%edx
  800a16:	78 52                	js     800a6a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	89 04 24             	mov    %eax,(%esp)
  800a27:	e8 70 fb ff ff       	call   80059c <dev_lookup>
  800a2c:	85 c0                	test   %eax,%eax
  800a2e:	78 3a                	js     800a6a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a33:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a37:	74 2c                	je     800a65 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a39:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a3c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a43:	00 00 00 
	stat->st_isdir = 0;
  800a46:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a4d:	00 00 00 
	stat->st_dev = dev;
  800a50:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a5d:	89 14 24             	mov    %edx,(%esp)
  800a60:	ff 50 14             	call   *0x14(%eax)
  800a63:	eb 05                	jmp    800a6a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a65:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a6a:	83 c4 24             	add    $0x24,%esp
  800a6d:	5b                   	pop    %ebx
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	56                   	push   %esi
  800a74:	53                   	push   %ebx
  800a75:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a7f:	00 
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 04 24             	mov    %eax,(%esp)
  800a86:	e8 99 02 00 00       	call   800d24 <open>
  800a8b:	89 c3                	mov    %eax,%ebx
  800a8d:	85 db                	test   %ebx,%ebx
  800a8f:	78 1b                	js     800aac <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a98:	89 1c 24             	mov    %ebx,(%esp)
  800a9b:	e8 56 ff ff ff       	call   8009f6 <fstat>
  800aa0:	89 c6                	mov    %eax,%esi
	close(fd);
  800aa2:	89 1c 24             	mov    %ebx,(%esp)
  800aa5:	e8 cd fb ff ff       	call   800677 <close>
	return r;
  800aaa:	89 f0                	mov    %esi,%eax
}
  800aac:	83 c4 10             	add    $0x10,%esp
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	56                   	push   %esi
  800ab7:	53                   	push   %ebx
  800ab8:	83 ec 10             	sub    $0x10,%esp
  800abb:	89 c6                	mov    %eax,%esi
  800abd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800abf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ac6:	75 11                	jne    800ad9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ac8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800acf:	e8 eb 18 00 00       	call   8023bf <ipc_find_env>
  800ad4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ad9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800ae0:	00 
  800ae1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800ae8:	00 
  800ae9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800aed:	a1 00 40 80 00       	mov    0x804000,%eax
  800af2:	89 04 24             	mov    %eax,(%esp)
  800af5:	e8 5e 18 00 00       	call   802358 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800afa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b01:	00 
  800b02:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b0d:	e8 de 17 00 00       	call   8022f0 <ipc_recv>
}
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	5b                   	pop    %ebx
  800b16:	5e                   	pop    %esi
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8b 40 0c             	mov    0xc(%eax),%eax
  800b25:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800b32:	ba 00 00 00 00       	mov    $0x0,%edx
  800b37:	b8 02 00 00 00       	mov    $0x2,%eax
  800b3c:	e8 72 ff ff ff       	call   800ab3 <fsipc>
}
  800b41:	c9                   	leave  
  800b42:	c3                   	ret    

00800b43 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 40 0c             	mov    0xc(%eax),%eax
  800b4f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b54:	ba 00 00 00 00       	mov    $0x0,%edx
  800b59:	b8 06 00 00 00       	mov    $0x6,%eax
  800b5e:	e8 50 ff ff ff       	call   800ab3 <fsipc>
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	53                   	push   %ebx
  800b69:	83 ec 14             	sub    $0x14,%esp
  800b6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 40 0c             	mov    0xc(%eax),%eax
  800b75:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7f:	b8 05 00 00 00       	mov    $0x5,%eax
  800b84:	e8 2a ff ff ff       	call   800ab3 <fsipc>
  800b89:	89 c2                	mov    %eax,%edx
  800b8b:	85 d2                	test   %edx,%edx
  800b8d:	78 2b                	js     800bba <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b8f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800b96:	00 
  800b97:	89 1c 24             	mov    %ebx,(%esp)
  800b9a:	e8 f8 13 00 00       	call   801f97 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b9f:	a1 80 50 80 00       	mov    0x805080,%eax
  800ba4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800baa:	a1 84 50 80 00       	mov    0x805084,%eax
  800baf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bba:	83 c4 14             	add    $0x14,%esp
  800bbd:	5b                   	pop    %ebx
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	53                   	push   %ebx
  800bc4:	83 ec 14             	sub    $0x14,%esp
  800bc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  800bca:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  800bd0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  800bd5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdb:	8b 52 0c             	mov    0xc(%edx),%edx
  800bde:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  800be4:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  800be9:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bf4:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800bfb:	e8 34 15 00 00       	call   802134 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  800c00:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  800c07:	00 
  800c08:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  800c0f:	e8 0b 0d 00 00       	call   80191f <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800c14:	ba 00 00 00 00       	mov    $0x0,%edx
  800c19:	b8 04 00 00 00       	mov    $0x4,%eax
  800c1e:	e8 90 fe ff ff       	call   800ab3 <fsipc>
  800c23:	85 c0                	test   %eax,%eax
  800c25:	78 53                	js     800c7a <devfile_write+0xba>
		return r;
	assert(r <= n);
  800c27:	39 c3                	cmp    %eax,%ebx
  800c29:	73 24                	jae    800c4f <devfile_write+0x8f>
  800c2b:	c7 44 24 0c ad 27 80 	movl   $0x8027ad,0xc(%esp)
  800c32:	00 
  800c33:	c7 44 24 08 b4 27 80 	movl   $0x8027b4,0x8(%esp)
  800c3a:	00 
  800c3b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  800c42:	00 
  800c43:	c7 04 24 c9 27 80 00 	movl   $0x8027c9,(%esp)
  800c4a:	e8 d7 0b 00 00       	call   801826 <_panic>
	assert(r <= PGSIZE);
  800c4f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c54:	7e 24                	jle    800c7a <devfile_write+0xba>
  800c56:	c7 44 24 0c d4 27 80 	movl   $0x8027d4,0xc(%esp)
  800c5d:	00 
  800c5e:	c7 44 24 08 b4 27 80 	movl   $0x8027b4,0x8(%esp)
  800c65:	00 
  800c66:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  800c6d:	00 
  800c6e:	c7 04 24 c9 27 80 00 	movl   $0x8027c9,(%esp)
  800c75:	e8 ac 0b 00 00       	call   801826 <_panic>
	return r;
}
  800c7a:	83 c4 14             	add    $0x14,%esp
  800c7d:	5b                   	pop    %ebx
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	83 ec 10             	sub    $0x10,%esp
  800c88:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8b 40 0c             	mov    0xc(%eax),%eax
  800c91:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800c96:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ca6:	e8 08 fe ff ff       	call   800ab3 <fsipc>
  800cab:	89 c3                	mov    %eax,%ebx
  800cad:	85 c0                	test   %eax,%eax
  800caf:	78 6a                	js     800d1b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800cb1:	39 c6                	cmp    %eax,%esi
  800cb3:	73 24                	jae    800cd9 <devfile_read+0x59>
  800cb5:	c7 44 24 0c ad 27 80 	movl   $0x8027ad,0xc(%esp)
  800cbc:	00 
  800cbd:	c7 44 24 08 b4 27 80 	movl   $0x8027b4,0x8(%esp)
  800cc4:	00 
  800cc5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800ccc:	00 
  800ccd:	c7 04 24 c9 27 80 00 	movl   $0x8027c9,(%esp)
  800cd4:	e8 4d 0b 00 00       	call   801826 <_panic>
	assert(r <= PGSIZE);
  800cd9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800cde:	7e 24                	jle    800d04 <devfile_read+0x84>
  800ce0:	c7 44 24 0c d4 27 80 	movl   $0x8027d4,0xc(%esp)
  800ce7:	00 
  800ce8:	c7 44 24 08 b4 27 80 	movl   $0x8027b4,0x8(%esp)
  800cef:	00 
  800cf0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800cf7:	00 
  800cf8:	c7 04 24 c9 27 80 00 	movl   $0x8027c9,(%esp)
  800cff:	e8 22 0b 00 00       	call   801826 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800d04:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d08:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800d0f:	00 
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	89 04 24             	mov    %eax,(%esp)
  800d16:	e8 19 14 00 00       	call   802134 <memmove>
	return r;
}
  800d1b:	89 d8                	mov    %ebx,%eax
  800d1d:	83 c4 10             	add    $0x10,%esp
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	53                   	push   %ebx
  800d28:	83 ec 24             	sub    $0x24,%esp
  800d2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800d2e:	89 1c 24             	mov    %ebx,(%esp)
  800d31:	e8 2a 12 00 00       	call   801f60 <strlen>
  800d36:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800d3b:	7f 60                	jg     800d9d <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800d3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d40:	89 04 24             	mov    %eax,(%esp)
  800d43:	e8 af f7 ff ff       	call   8004f7 <fd_alloc>
  800d48:	89 c2                	mov    %eax,%edx
  800d4a:	85 d2                	test   %edx,%edx
  800d4c:	78 54                	js     800da2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800d4e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d52:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800d59:	e8 39 12 00 00       	call   801f97 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800d66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d69:	b8 01 00 00 00       	mov    $0x1,%eax
  800d6e:	e8 40 fd ff ff       	call   800ab3 <fsipc>
  800d73:	89 c3                	mov    %eax,%ebx
  800d75:	85 c0                	test   %eax,%eax
  800d77:	79 17                	jns    800d90 <open+0x6c>
		fd_close(fd, 0);
  800d79:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800d80:	00 
  800d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d84:	89 04 24             	mov    %eax,(%esp)
  800d87:	e8 6a f8 ff ff       	call   8005f6 <fd_close>
		return r;
  800d8c:	89 d8                	mov    %ebx,%eax
  800d8e:	eb 12                	jmp    800da2 <open+0x7e>
	}

	return fd2num(fd);
  800d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d93:	89 04 24             	mov    %eax,(%esp)
  800d96:	e8 35 f7 ff ff       	call   8004d0 <fd2num>
  800d9b:	eb 05                	jmp    800da2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800d9d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800da2:	83 c4 24             	add    $0x24,%esp
  800da5:	5b                   	pop    %ebx
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    

00800da8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800dae:	ba 00 00 00 00       	mov    $0x0,%edx
  800db3:	b8 08 00 00 00       	mov    $0x8,%eax
  800db8:	e8 f6 fc ff ff       	call   800ab3 <fsipc>
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <evict>:

int evict(void)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  800dc5:	c7 04 24 e0 27 80 00 	movl   $0x8027e0,(%esp)
  800dcc:	e8 4e 0b 00 00       	call   80191f <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  800dd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd6:	b8 09 00 00 00       	mov    $0x9,%eax
  800ddb:	e8 d3 fc ff ff       	call   800ab3 <fsipc>
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    
  800de2:	66 90                	xchg   %ax,%ax
  800de4:	66 90                	xchg   %ax,%ax
  800de6:	66 90                	xchg   %ax,%ax
  800de8:	66 90                	xchg   %ax,%ax
  800dea:	66 90                	xchg   %ax,%ax
  800dec:	66 90                	xchg   %ax,%ax
  800dee:	66 90                	xchg   %ax,%ax

00800df0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800df6:	c7 44 24 04 f9 27 80 	movl   $0x8027f9,0x4(%esp)
  800dfd:	00 
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	89 04 24             	mov    %eax,(%esp)
  800e04:	e8 8e 11 00 00       	call   801f97 <strcpy>
	return 0;
}
  800e09:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0e:	c9                   	leave  
  800e0f:	c3                   	ret    

00800e10 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	53                   	push   %ebx
  800e14:	83 ec 14             	sub    $0x14,%esp
  800e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800e1a:	89 1c 24             	mov    %ebx,(%esp)
  800e1d:	e8 d5 15 00 00       	call   8023f7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800e22:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800e27:	83 f8 01             	cmp    $0x1,%eax
  800e2a:	75 0d                	jne    800e39 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800e2c:	8b 43 0c             	mov    0xc(%ebx),%eax
  800e2f:	89 04 24             	mov    %eax,(%esp)
  800e32:	e8 29 03 00 00       	call   801160 <nsipc_close>
  800e37:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800e39:	89 d0                	mov    %edx,%eax
  800e3b:	83 c4 14             	add    $0x14,%esp
  800e3e:	5b                   	pop    %ebx
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800e47:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e4e:	00 
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8b 40 0c             	mov    0xc(%eax),%eax
  800e63:	89 04 24             	mov    %eax,(%esp)
  800e66:	e8 f0 03 00 00       	call   80125b <nsipc_send>
}
  800e6b:	c9                   	leave  
  800e6c:	c3                   	ret    

00800e6d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800e73:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e7a:	00 
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  800e8f:	89 04 24             	mov    %eax,(%esp)
  800e92:	e8 44 03 00 00       	call   8011db <nsipc_recv>
}
  800e97:	c9                   	leave  
  800e98:	c3                   	ret    

00800e99 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800e9f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800ea2:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ea6:	89 04 24             	mov    %eax,(%esp)
  800ea9:	e8 98 f6 ff ff       	call   800546 <fd_lookup>
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	78 17                	js     800ec9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eb5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800ebb:	39 08                	cmp    %ecx,(%eax)
  800ebd:	75 05                	jne    800ec4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800ebf:	8b 40 0c             	mov    0xc(%eax),%eax
  800ec2:	eb 05                	jmp    800ec9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800ec4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	56                   	push   %esi
  800ecf:	53                   	push   %ebx
  800ed0:	83 ec 20             	sub    $0x20,%esp
  800ed3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800ed5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ed8:	89 04 24             	mov    %eax,(%esp)
  800edb:	e8 17 f6 ff ff       	call   8004f7 <fd_alloc>
  800ee0:	89 c3                	mov    %eax,%ebx
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	78 21                	js     800f07 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800ee6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800eed:	00 
  800eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ef5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800efc:	e8 b8 f2 ff ff       	call   8001b9 <sys_page_alloc>
  800f01:	89 c3                	mov    %eax,%ebx
  800f03:	85 c0                	test   %eax,%eax
  800f05:	79 0c                	jns    800f13 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800f07:	89 34 24             	mov    %esi,(%esp)
  800f0a:	e8 51 02 00 00       	call   801160 <nsipc_close>
		return r;
  800f0f:	89 d8                	mov    %ebx,%eax
  800f11:	eb 20                	jmp    800f33 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f13:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f1c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f21:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800f28:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800f2b:	89 14 24             	mov    %edx,(%esp)
  800f2e:	e8 9d f5 ff ff       	call   8004d0 <fd2num>
}
  800f33:	83 c4 20             	add    $0x20,%esp
  800f36:	5b                   	pop    %ebx
  800f37:	5e                   	pop    %esi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	e8 51 ff ff ff       	call   800e99 <fd2sockid>
		return r;
  800f48:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f4a:	85 c0                	test   %eax,%eax
  800f4c:	78 23                	js     800f71 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f4e:	8b 55 10             	mov    0x10(%ebp),%edx
  800f51:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f58:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f5c:	89 04 24             	mov    %eax,(%esp)
  800f5f:	e8 45 01 00 00       	call   8010a9 <nsipc_accept>
		return r;
  800f64:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f66:	85 c0                	test   %eax,%eax
  800f68:	78 07                	js     800f71 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800f6a:	e8 5c ff ff ff       	call   800ecb <alloc_sockfd>
  800f6f:	89 c1                	mov    %eax,%ecx
}
  800f71:	89 c8                	mov    %ecx,%eax
  800f73:	c9                   	leave  
  800f74:	c3                   	ret    

00800f75 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	e8 16 ff ff ff       	call   800e99 <fd2sockid>
  800f83:	89 c2                	mov    %eax,%edx
  800f85:	85 d2                	test   %edx,%edx
  800f87:	78 16                	js     800f9f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800f89:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f97:	89 14 24             	mov    %edx,(%esp)
  800f9a:	e8 60 01 00 00       	call   8010ff <nsipc_bind>
}
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    

00800fa1 <shutdown>:

int
shutdown(int s, int how)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	e8 ea fe ff ff       	call   800e99 <fd2sockid>
  800faf:	89 c2                	mov    %eax,%edx
  800fb1:	85 d2                	test   %edx,%edx
  800fb3:	78 0f                	js     800fc4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fbc:	89 14 24             	mov    %edx,(%esp)
  800fbf:	e8 7a 01 00 00       	call   80113e <nsipc_shutdown>
}
  800fc4:	c9                   	leave  
  800fc5:	c3                   	ret    

00800fc6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	e8 c5 fe ff ff       	call   800e99 <fd2sockid>
  800fd4:	89 c2                	mov    %eax,%edx
  800fd6:	85 d2                	test   %edx,%edx
  800fd8:	78 16                	js     800ff0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fe8:	89 14 24             	mov    %edx,(%esp)
  800feb:	e8 8a 01 00 00       	call   80117a <nsipc_connect>
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    

00800ff2 <listen>:

int
listen(int s, int backlog)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	e8 99 fe ff ff       	call   800e99 <fd2sockid>
  801000:	89 c2                	mov    %eax,%edx
  801002:	85 d2                	test   %edx,%edx
  801004:	78 0f                	js     801015 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	89 44 24 04          	mov    %eax,0x4(%esp)
  80100d:	89 14 24             	mov    %edx,(%esp)
  801010:	e8 a4 01 00 00       	call   8011b9 <nsipc_listen>
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	89 44 24 08          	mov    %eax,0x8(%esp)
  801024:	8b 45 0c             	mov    0xc(%ebp),%eax
  801027:	89 44 24 04          	mov    %eax,0x4(%esp)
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	89 04 24             	mov    %eax,(%esp)
  801031:	e8 98 02 00 00       	call   8012ce <nsipc_socket>
  801036:	89 c2                	mov    %eax,%edx
  801038:	85 d2                	test   %edx,%edx
  80103a:	78 05                	js     801041 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80103c:	e8 8a fe ff ff       	call   800ecb <alloc_sockfd>
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	53                   	push   %ebx
  801047:	83 ec 14             	sub    $0x14,%esp
  80104a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80104c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801053:	75 11                	jne    801066 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801055:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80105c:	e8 5e 13 00 00       	call   8023bf <ipc_find_env>
  801061:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801066:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80106d:	00 
  80106e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801075:	00 
  801076:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80107a:	a1 04 40 80 00       	mov    0x804004,%eax
  80107f:	89 04 24             	mov    %eax,(%esp)
  801082:	e8 d1 12 00 00       	call   802358 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801087:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80108e:	00 
  80108f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801096:	00 
  801097:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80109e:	e8 4d 12 00 00       	call   8022f0 <ipc_recv>
}
  8010a3:	83 c4 14             	add    $0x14,%esp
  8010a6:	5b                   	pop    %ebx
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	56                   	push   %esi
  8010ad:	53                   	push   %ebx
  8010ae:	83 ec 10             	sub    $0x10,%esp
  8010b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8010bc:	8b 06                	mov    (%esi),%eax
  8010be:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8010c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8010c8:	e8 76 ff ff ff       	call   801043 <nsipc>
  8010cd:	89 c3                	mov    %eax,%ebx
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	78 23                	js     8010f6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8010d3:	a1 10 60 80 00       	mov    0x806010,%eax
  8010d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010dc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8010e3:	00 
  8010e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e7:	89 04 24             	mov    %eax,(%esp)
  8010ea:	e8 45 10 00 00       	call   802134 <memmove>
		*addrlen = ret->ret_addrlen;
  8010ef:	a1 10 60 80 00       	mov    0x806010,%eax
  8010f4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8010f6:	89 d8                	mov    %ebx,%eax
  8010f8:	83 c4 10             	add    $0x10,%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    

008010ff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	53                   	push   %ebx
  801103:	83 ec 14             	sub    $0x14,%esp
  801106:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801111:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801115:	8b 45 0c             	mov    0xc(%ebp),%eax
  801118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80111c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801123:	e8 0c 10 00 00       	call   802134 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801128:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80112e:	b8 02 00 00 00       	mov    $0x2,%eax
  801133:	e8 0b ff ff ff       	call   801043 <nsipc>
}
  801138:	83 c4 14             	add    $0x14,%esp
  80113b:	5b                   	pop    %ebx
  80113c:	5d                   	pop    %ebp
  80113d:	c3                   	ret    

0080113e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801154:	b8 03 00 00 00       	mov    $0x3,%eax
  801159:	e8 e5 fe ff ff       	call   801043 <nsipc>
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <nsipc_close>:

int
nsipc_close(int s)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80116e:	b8 04 00 00 00       	mov    $0x4,%eax
  801173:	e8 cb fe ff ff       	call   801043 <nsipc>
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	53                   	push   %ebx
  80117e:	83 ec 14             	sub    $0x14,%esp
  801181:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80118c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	89 44 24 04          	mov    %eax,0x4(%esp)
  801197:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  80119e:	e8 91 0f 00 00       	call   802134 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8011a3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8011a9:	b8 05 00 00 00       	mov    $0x5,%eax
  8011ae:	e8 90 fe ff ff       	call   801043 <nsipc>
}
  8011b3:	83 c4 14             	add    $0x14,%esp
  8011b6:	5b                   	pop    %ebx
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    

008011b9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8011cf:	b8 06 00 00 00       	mov    $0x6,%eax
  8011d4:	e8 6a fe ff ff       	call   801043 <nsipc>
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	56                   	push   %esi
  8011df:	53                   	push   %ebx
  8011e0:	83 ec 10             	sub    $0x10,%esp
  8011e3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8011ee:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8011f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8011fc:	b8 07 00 00 00       	mov    $0x7,%eax
  801201:	e8 3d fe ff ff       	call   801043 <nsipc>
  801206:	89 c3                	mov    %eax,%ebx
  801208:	85 c0                	test   %eax,%eax
  80120a:	78 46                	js     801252 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80120c:	39 f0                	cmp    %esi,%eax
  80120e:	7f 07                	jg     801217 <nsipc_recv+0x3c>
  801210:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801215:	7e 24                	jle    80123b <nsipc_recv+0x60>
  801217:	c7 44 24 0c 05 28 80 	movl   $0x802805,0xc(%esp)
  80121e:	00 
  80121f:	c7 44 24 08 b4 27 80 	movl   $0x8027b4,0x8(%esp)
  801226:	00 
  801227:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80122e:	00 
  80122f:	c7 04 24 1a 28 80 00 	movl   $0x80281a,(%esp)
  801236:	e8 eb 05 00 00       	call   801826 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80123b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80123f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801246:	00 
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	89 04 24             	mov    %eax,(%esp)
  80124d:	e8 e2 0e 00 00       	call   802134 <memmove>
	}

	return r;
}
  801252:	89 d8                	mov    %ebx,%eax
  801254:	83 c4 10             	add    $0x10,%esp
  801257:	5b                   	pop    %ebx
  801258:	5e                   	pop    %esi
  801259:	5d                   	pop    %ebp
  80125a:	c3                   	ret    

0080125b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	53                   	push   %ebx
  80125f:	83 ec 14             	sub    $0x14,%esp
  801262:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80126d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801273:	7e 24                	jle    801299 <nsipc_send+0x3e>
  801275:	c7 44 24 0c 26 28 80 	movl   $0x802826,0xc(%esp)
  80127c:	00 
  80127d:	c7 44 24 08 b4 27 80 	movl   $0x8027b4,0x8(%esp)
  801284:	00 
  801285:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80128c:	00 
  80128d:	c7 04 24 1a 28 80 00 	movl   $0x80281a,(%esp)
  801294:	e8 8d 05 00 00       	call   801826 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801299:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80129d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8012ab:	e8 84 0e 00 00       	call   802134 <memmove>
	nsipcbuf.send.req_size = size;
  8012b0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8012be:	b8 08 00 00 00       	mov    $0x8,%eax
  8012c3:	e8 7b fd ff ff       	call   801043 <nsipc>
}
  8012c8:	83 c4 14             	add    $0x14,%esp
  8012cb:	5b                   	pop    %ebx
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    

008012ce <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8012e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8012ec:	b8 09 00 00 00       	mov    $0x9,%eax
  8012f1:	e8 4d fd ff ff       	call   801043 <nsipc>
}
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	56                   	push   %esi
  8012fc:	53                   	push   %ebx
  8012fd:	83 ec 10             	sub    $0x10,%esp
  801300:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	89 04 24             	mov    %eax,(%esp)
  801309:	e8 d2 f1 ff ff       	call   8004e0 <fd2data>
  80130e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801310:	c7 44 24 04 32 28 80 	movl   $0x802832,0x4(%esp)
  801317:	00 
  801318:	89 1c 24             	mov    %ebx,(%esp)
  80131b:	e8 77 0c 00 00       	call   801f97 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801320:	8b 46 04             	mov    0x4(%esi),%eax
  801323:	2b 06                	sub    (%esi),%eax
  801325:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80132b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801332:	00 00 00 
	stat->st_dev = &devpipe;
  801335:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80133c:	30 80 00 
	return 0;
}
  80133f:	b8 00 00 00 00       	mov    $0x0,%eax
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	5b                   	pop    %ebx
  801348:	5e                   	pop    %esi
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    

0080134b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	53                   	push   %ebx
  80134f:	83 ec 14             	sub    $0x14,%esp
  801352:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801355:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801359:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801360:	e8 fb ee ff ff       	call   800260 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801365:	89 1c 24             	mov    %ebx,(%esp)
  801368:	e8 73 f1 ff ff       	call   8004e0 <fd2data>
  80136d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801371:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801378:	e8 e3 ee ff ff       	call   800260 <sys_page_unmap>
}
  80137d:	83 c4 14             	add    $0x14,%esp
  801380:	5b                   	pop    %ebx
  801381:	5d                   	pop    %ebp
  801382:	c3                   	ret    

00801383 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	57                   	push   %edi
  801387:	56                   	push   %esi
  801388:	53                   	push   %ebx
  801389:	83 ec 2c             	sub    $0x2c,%esp
  80138c:	89 c6                	mov    %eax,%esi
  80138e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801391:	a1 08 40 80 00       	mov    0x804008,%eax
  801396:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801399:	89 34 24             	mov    %esi,(%esp)
  80139c:	e8 56 10 00 00       	call   8023f7 <pageref>
  8013a1:	89 c7                	mov    %eax,%edi
  8013a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a6:	89 04 24             	mov    %eax,(%esp)
  8013a9:	e8 49 10 00 00       	call   8023f7 <pageref>
  8013ae:	39 c7                	cmp    %eax,%edi
  8013b0:	0f 94 c2             	sete   %dl
  8013b3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8013b6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  8013bc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8013bf:	39 fb                	cmp    %edi,%ebx
  8013c1:	74 21                	je     8013e4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8013c3:	84 d2                	test   %dl,%dl
  8013c5:	74 ca                	je     801391 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8013c7:	8b 51 58             	mov    0x58(%ecx),%edx
  8013ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ce:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013d6:	c7 04 24 39 28 80 00 	movl   $0x802839,(%esp)
  8013dd:	e8 3d 05 00 00       	call   80191f <cprintf>
  8013e2:	eb ad                	jmp    801391 <_pipeisclosed+0xe>
	}
}
  8013e4:	83 c4 2c             	add    $0x2c,%esp
  8013e7:	5b                   	pop    %ebx
  8013e8:	5e                   	pop    %esi
  8013e9:	5f                   	pop    %edi
  8013ea:	5d                   	pop    %ebp
  8013eb:	c3                   	ret    

008013ec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	57                   	push   %edi
  8013f0:	56                   	push   %esi
  8013f1:	53                   	push   %ebx
  8013f2:	83 ec 1c             	sub    $0x1c,%esp
  8013f5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8013f8:	89 34 24             	mov    %esi,(%esp)
  8013fb:	e8 e0 f0 ff ff       	call   8004e0 <fd2data>
  801400:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801402:	bf 00 00 00 00       	mov    $0x0,%edi
  801407:	eb 45                	jmp    80144e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801409:	89 da                	mov    %ebx,%edx
  80140b:	89 f0                	mov    %esi,%eax
  80140d:	e8 71 ff ff ff       	call   801383 <_pipeisclosed>
  801412:	85 c0                	test   %eax,%eax
  801414:	75 41                	jne    801457 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801416:	e8 7f ed ff ff       	call   80019a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80141b:	8b 43 04             	mov    0x4(%ebx),%eax
  80141e:	8b 0b                	mov    (%ebx),%ecx
  801420:	8d 51 20             	lea    0x20(%ecx),%edx
  801423:	39 d0                	cmp    %edx,%eax
  801425:	73 e2                	jae    801409 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801427:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80142a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80142e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801431:	99                   	cltd   
  801432:	c1 ea 1b             	shr    $0x1b,%edx
  801435:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801438:	83 e1 1f             	and    $0x1f,%ecx
  80143b:	29 d1                	sub    %edx,%ecx
  80143d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801441:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801445:	83 c0 01             	add    $0x1,%eax
  801448:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80144b:	83 c7 01             	add    $0x1,%edi
  80144e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801451:	75 c8                	jne    80141b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801453:	89 f8                	mov    %edi,%eax
  801455:	eb 05                	jmp    80145c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801457:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80145c:	83 c4 1c             	add    $0x1c,%esp
  80145f:	5b                   	pop    %ebx
  801460:	5e                   	pop    %esi
  801461:	5f                   	pop    %edi
  801462:	5d                   	pop    %ebp
  801463:	c3                   	ret    

00801464 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	57                   	push   %edi
  801468:	56                   	push   %esi
  801469:	53                   	push   %ebx
  80146a:	83 ec 1c             	sub    $0x1c,%esp
  80146d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801470:	89 3c 24             	mov    %edi,(%esp)
  801473:	e8 68 f0 ff ff       	call   8004e0 <fd2data>
  801478:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80147a:	be 00 00 00 00       	mov    $0x0,%esi
  80147f:	eb 3d                	jmp    8014be <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801481:	85 f6                	test   %esi,%esi
  801483:	74 04                	je     801489 <devpipe_read+0x25>
				return i;
  801485:	89 f0                	mov    %esi,%eax
  801487:	eb 43                	jmp    8014cc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801489:	89 da                	mov    %ebx,%edx
  80148b:	89 f8                	mov    %edi,%eax
  80148d:	e8 f1 fe ff ff       	call   801383 <_pipeisclosed>
  801492:	85 c0                	test   %eax,%eax
  801494:	75 31                	jne    8014c7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801496:	e8 ff ec ff ff       	call   80019a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80149b:	8b 03                	mov    (%ebx),%eax
  80149d:	3b 43 04             	cmp    0x4(%ebx),%eax
  8014a0:	74 df                	je     801481 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8014a2:	99                   	cltd   
  8014a3:	c1 ea 1b             	shr    $0x1b,%edx
  8014a6:	01 d0                	add    %edx,%eax
  8014a8:	83 e0 1f             	and    $0x1f,%eax
  8014ab:	29 d0                	sub    %edx,%eax
  8014ad:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8014b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8014b8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014bb:	83 c6 01             	add    $0x1,%esi
  8014be:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014c1:	75 d8                	jne    80149b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8014c3:	89 f0                	mov    %esi,%eax
  8014c5:	eb 05                	jmp    8014cc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8014c7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8014cc:	83 c4 1c             	add    $0x1c,%esp
  8014cf:	5b                   	pop    %ebx
  8014d0:	5e                   	pop    %esi
  8014d1:	5f                   	pop    %edi
  8014d2:	5d                   	pop    %ebp
  8014d3:	c3                   	ret    

008014d4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	56                   	push   %esi
  8014d8:	53                   	push   %ebx
  8014d9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8014dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014df:	89 04 24             	mov    %eax,(%esp)
  8014e2:	e8 10 f0 ff ff       	call   8004f7 <fd_alloc>
  8014e7:	89 c2                	mov    %eax,%edx
  8014e9:	85 d2                	test   %edx,%edx
  8014eb:	0f 88 4d 01 00 00    	js     80163e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014f1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8014f8:	00 
  8014f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801500:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801507:	e8 ad ec ff ff       	call   8001b9 <sys_page_alloc>
  80150c:	89 c2                	mov    %eax,%edx
  80150e:	85 d2                	test   %edx,%edx
  801510:	0f 88 28 01 00 00    	js     80163e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801516:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801519:	89 04 24             	mov    %eax,(%esp)
  80151c:	e8 d6 ef ff ff       	call   8004f7 <fd_alloc>
  801521:	89 c3                	mov    %eax,%ebx
  801523:	85 c0                	test   %eax,%eax
  801525:	0f 88 fe 00 00 00    	js     801629 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80152b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801532:	00 
  801533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801536:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801541:	e8 73 ec ff ff       	call   8001b9 <sys_page_alloc>
  801546:	89 c3                	mov    %eax,%ebx
  801548:	85 c0                	test   %eax,%eax
  80154a:	0f 88 d9 00 00 00    	js     801629 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801553:	89 04 24             	mov    %eax,(%esp)
  801556:	e8 85 ef ff ff       	call   8004e0 <fd2data>
  80155b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80155d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801564:	00 
  801565:	89 44 24 04          	mov    %eax,0x4(%esp)
  801569:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801570:	e8 44 ec ff ff       	call   8001b9 <sys_page_alloc>
  801575:	89 c3                	mov    %eax,%ebx
  801577:	85 c0                	test   %eax,%eax
  801579:	0f 88 97 00 00 00    	js     801616 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80157f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801582:	89 04 24             	mov    %eax,(%esp)
  801585:	e8 56 ef ff ff       	call   8004e0 <fd2data>
  80158a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801591:	00 
  801592:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801596:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80159d:	00 
  80159e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a9:	e8 5f ec ff ff       	call   80020d <sys_page_map>
  8015ae:	89 c3                	mov    %eax,%ebx
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	78 52                	js     801606 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8015b4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8015ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8015bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8015c9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8015cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8015de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e1:	89 04 24             	mov    %eax,(%esp)
  8015e4:	e8 e7 ee ff ff       	call   8004d0 <fd2num>
  8015e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8015ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f1:	89 04 24             	mov    %eax,(%esp)
  8015f4:	e8 d7 ee ff ff       	call   8004d0 <fd2num>
  8015f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015fc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8015ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801604:	eb 38                	jmp    80163e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801606:	89 74 24 04          	mov    %esi,0x4(%esp)
  80160a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801611:	e8 4a ec ff ff       	call   800260 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801619:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801624:	e8 37 ec ff ff       	call   800260 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801630:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801637:	e8 24 ec ff ff       	call   800260 <sys_page_unmap>
  80163c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80163e:	83 c4 30             	add    $0x30,%esp
  801641:	5b                   	pop    %ebx
  801642:	5e                   	pop    %esi
  801643:	5d                   	pop    %ebp
  801644:	c3                   	ret    

00801645 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80164b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	89 04 24             	mov    %eax,(%esp)
  801658:	e8 e9 ee ff ff       	call   800546 <fd_lookup>
  80165d:	89 c2                	mov    %eax,%edx
  80165f:	85 d2                	test   %edx,%edx
  801661:	78 15                	js     801678 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801666:	89 04 24             	mov    %eax,(%esp)
  801669:	e8 72 ee ff ff       	call   8004e0 <fd2data>
	return _pipeisclosed(fd, p);
  80166e:	89 c2                	mov    %eax,%edx
  801670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801673:	e8 0b fd ff ff       	call   801383 <_pipeisclosed>
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    
  80167a:	66 90                	xchg   %ax,%ax
  80167c:	66 90                	xchg   %ax,%ax
  80167e:	66 90                	xchg   %ax,%ax

00801680 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
  801688:	5d                   	pop    %ebp
  801689:	c3                   	ret    

0080168a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801690:	c7 44 24 04 51 28 80 	movl   $0x802851,0x4(%esp)
  801697:	00 
  801698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169b:	89 04 24             	mov    %eax,(%esp)
  80169e:	e8 f4 08 00 00       	call   801f97 <strcpy>
	return 0;
}
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	57                   	push   %edi
  8016ae:	56                   	push   %esi
  8016af:	53                   	push   %ebx
  8016b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8016bb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016c1:	eb 31                	jmp    8016f4 <devcons_write+0x4a>
		m = n - tot;
  8016c3:	8b 75 10             	mov    0x10(%ebp),%esi
  8016c6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8016c8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8016cb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8016d0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8016d3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8016d7:	03 45 0c             	add    0xc(%ebp),%eax
  8016da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016de:	89 3c 24             	mov    %edi,(%esp)
  8016e1:	e8 4e 0a 00 00       	call   802134 <memmove>
		sys_cputs(buf, m);
  8016e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016ea:	89 3c 24             	mov    %edi,(%esp)
  8016ed:	e8 a8 e9 ff ff       	call   80009a <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016f2:	01 f3                	add    %esi,%ebx
  8016f4:	89 d8                	mov    %ebx,%eax
  8016f6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8016f9:	72 c8                	jb     8016c3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8016fb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801701:	5b                   	pop    %ebx
  801702:	5e                   	pop    %esi
  801703:	5f                   	pop    %edi
  801704:	5d                   	pop    %ebp
  801705:	c3                   	ret    

00801706 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801711:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801715:	75 07                	jne    80171e <devcons_read+0x18>
  801717:	eb 2a                	jmp    801743 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801719:	e8 7c ea ff ff       	call   80019a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80171e:	66 90                	xchg   %ax,%ax
  801720:	e8 93 e9 ff ff       	call   8000b8 <sys_cgetc>
  801725:	85 c0                	test   %eax,%eax
  801727:	74 f0                	je     801719 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801729:	85 c0                	test   %eax,%eax
  80172b:	78 16                	js     801743 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80172d:	83 f8 04             	cmp    $0x4,%eax
  801730:	74 0c                	je     80173e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801732:	8b 55 0c             	mov    0xc(%ebp),%edx
  801735:	88 02                	mov    %al,(%edx)
	return 1;
  801737:	b8 01 00 00 00       	mov    $0x1,%eax
  80173c:	eb 05                	jmp    801743 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801751:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801758:	00 
  801759:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80175c:	89 04 24             	mov    %eax,(%esp)
  80175f:	e8 36 e9 ff ff       	call   80009a <sys_cputs>
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <getchar>:

int
getchar(void)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80176c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801773:	00 
  801774:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801777:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801782:	e8 53 f0 ff ff       	call   8007da <read>
	if (r < 0)
  801787:	85 c0                	test   %eax,%eax
  801789:	78 0f                	js     80179a <getchar+0x34>
		return r;
	if (r < 1)
  80178b:	85 c0                	test   %eax,%eax
  80178d:	7e 06                	jle    801795 <getchar+0x2f>
		return -E_EOF;
	return c;
  80178f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801793:	eb 05                	jmp    80179a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801795:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	89 04 24             	mov    %eax,(%esp)
  8017af:	e8 92 ed ff ff       	call   800546 <fd_lookup>
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	78 11                	js     8017c9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8017b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8017c1:	39 10                	cmp    %edx,(%eax)
  8017c3:	0f 94 c0             	sete   %al
  8017c6:	0f b6 c0             	movzbl %al,%eax
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <opencons>:

int
opencons(void)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8017d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d4:	89 04 24             	mov    %eax,(%esp)
  8017d7:	e8 1b ed ff ff       	call   8004f7 <fd_alloc>
		return r;
  8017dc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	78 40                	js     801822 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8017e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8017e9:	00 
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f8:	e8 bc e9 ff ff       	call   8001b9 <sys_page_alloc>
		return r;
  8017fd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8017ff:	85 c0                	test   %eax,%eax
  801801:	78 1f                	js     801822 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801803:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801811:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801818:	89 04 24             	mov    %eax,(%esp)
  80181b:	e8 b0 ec ff ff       	call   8004d0 <fd2num>
  801820:	89 c2                	mov    %eax,%edx
}
  801822:	89 d0                	mov    %edx,%eax
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	56                   	push   %esi
  80182a:	53                   	push   %ebx
  80182b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80182e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801831:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801837:	e8 3f e9 ff ff       	call   80017b <sys_getenvid>
  80183c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801843:	8b 55 08             	mov    0x8(%ebp),%edx
  801846:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80184a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80184e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801852:	c7 04 24 60 28 80 00 	movl   $0x802860,(%esp)
  801859:	e8 c1 00 00 00       	call   80191f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80185e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801862:	8b 45 10             	mov    0x10(%ebp),%eax
  801865:	89 04 24             	mov    %eax,(%esp)
  801868:	e8 51 00 00 00       	call   8018be <vcprintf>
	cprintf("\n");
  80186d:	c7 04 24 f7 27 80 00 	movl   $0x8027f7,(%esp)
  801874:	e8 a6 00 00 00       	call   80191f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801879:	cc                   	int3   
  80187a:	eb fd                	jmp    801879 <_panic+0x53>

0080187c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	53                   	push   %ebx
  801880:	83 ec 14             	sub    $0x14,%esp
  801883:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801886:	8b 13                	mov    (%ebx),%edx
  801888:	8d 42 01             	lea    0x1(%edx),%eax
  80188b:	89 03                	mov    %eax,(%ebx)
  80188d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801890:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801894:	3d ff 00 00 00       	cmp    $0xff,%eax
  801899:	75 19                	jne    8018b4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80189b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8018a2:	00 
  8018a3:	8d 43 08             	lea    0x8(%ebx),%eax
  8018a6:	89 04 24             	mov    %eax,(%esp)
  8018a9:	e8 ec e7 ff ff       	call   80009a <sys_cputs>
		b->idx = 0;
  8018ae:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8018b4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8018b8:	83 c4 14             	add    $0x14,%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5d                   	pop    %ebp
  8018bd:	c3                   	ret    

008018be <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8018c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018ce:	00 00 00 
	b.cnt = 0;
  8018d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8018d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8018db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8018ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f3:	c7 04 24 7c 18 80 00 	movl   $0x80187c,(%esp)
  8018fa:	e8 75 01 00 00       	call   801a74 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8018ff:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801905:	89 44 24 04          	mov    %eax,0x4(%esp)
  801909:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80190f:	89 04 24             	mov    %eax,(%esp)
  801912:	e8 83 e7 ff ff       	call   80009a <sys_cputs>

	return b.cnt;
}
  801917:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801925:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801928:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	89 04 24             	mov    %eax,(%esp)
  801932:	e8 87 ff ff ff       	call   8018be <vcprintf>
	va_end(ap);

	return cnt;
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    
  801939:	66 90                	xchg   %ax,%ax
  80193b:	66 90                	xchg   %ax,%ax
  80193d:	66 90                	xchg   %ax,%ax
  80193f:	90                   	nop

00801940 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	57                   	push   %edi
  801944:	56                   	push   %esi
  801945:	53                   	push   %ebx
  801946:	83 ec 3c             	sub    $0x3c,%esp
  801949:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80194c:	89 d7                	mov    %edx,%edi
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801954:	8b 45 0c             	mov    0xc(%ebp),%eax
  801957:	89 c3                	mov    %eax,%ebx
  801959:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80195c:	8b 45 10             	mov    0x10(%ebp),%eax
  80195f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801962:	b9 00 00 00 00       	mov    $0x0,%ecx
  801967:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80196a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80196d:	39 d9                	cmp    %ebx,%ecx
  80196f:	72 05                	jb     801976 <printnum+0x36>
  801971:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801974:	77 69                	ja     8019df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801976:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801979:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80197d:	83 ee 01             	sub    $0x1,%esi
  801980:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801984:	89 44 24 08          	mov    %eax,0x8(%esp)
  801988:	8b 44 24 08          	mov    0x8(%esp),%eax
  80198c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801990:	89 c3                	mov    %eax,%ebx
  801992:	89 d6                	mov    %edx,%esi
  801994:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801997:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80199a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80199e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a5:	89 04 24             	mov    %eax,(%esp)
  8019a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019af:	e8 8c 0a 00 00       	call   802440 <__udivdi3>
  8019b4:	89 d9                	mov    %ebx,%ecx
  8019b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019be:	89 04 24             	mov    %eax,(%esp)
  8019c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019c5:	89 fa                	mov    %edi,%edx
  8019c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019ca:	e8 71 ff ff ff       	call   801940 <printnum>
  8019cf:	eb 1b                	jmp    8019ec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8019d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8019d8:	89 04 24             	mov    %eax,(%esp)
  8019db:	ff d3                	call   *%ebx
  8019dd:	eb 03                	jmp    8019e2 <printnum+0xa2>
  8019df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8019e2:	83 ee 01             	sub    $0x1,%esi
  8019e5:	85 f6                	test   %esi,%esi
  8019e7:	7f e8                	jg     8019d1 <printnum+0x91>
  8019e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8019ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019f0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8019f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8019fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a05:	89 04 24             	mov    %eax,(%esp)
  801a08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0f:	e8 5c 0b 00 00       	call   802570 <__umoddi3>
  801a14:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a18:	0f be 80 83 28 80 00 	movsbl 0x802883(%eax),%eax
  801a1f:	89 04 24             	mov    %eax,(%esp)
  801a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a25:	ff d0                	call   *%eax
}
  801a27:	83 c4 3c             	add    $0x3c,%esp
  801a2a:	5b                   	pop    %ebx
  801a2b:	5e                   	pop    %esi
  801a2c:	5f                   	pop    %edi
  801a2d:	5d                   	pop    %ebp
  801a2e:	c3                   	ret    

00801a2f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a35:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801a39:	8b 10                	mov    (%eax),%edx
  801a3b:	3b 50 04             	cmp    0x4(%eax),%edx
  801a3e:	73 0a                	jae    801a4a <sprintputch+0x1b>
		*b->buf++ = ch;
  801a40:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a43:	89 08                	mov    %ecx,(%eax)
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	88 02                	mov    %al,(%edx)
}
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    

00801a4c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a52:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801a55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a59:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	89 04 24             	mov    %eax,(%esp)
  801a6d:	e8 02 00 00 00       	call   801a74 <vprintfmt>
	va_end(ap);
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	57                   	push   %edi
  801a78:	56                   	push   %esi
  801a79:	53                   	push   %ebx
  801a7a:	83 ec 3c             	sub    $0x3c,%esp
  801a7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a80:	eb 17                	jmp    801a99 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  801a82:	85 c0                	test   %eax,%eax
  801a84:	0f 84 4b 04 00 00    	je     801ed5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  801a8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a8d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a91:	89 04 24             	mov    %eax,(%esp)
  801a94:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  801a97:	89 fb                	mov    %edi,%ebx
  801a99:	8d 7b 01             	lea    0x1(%ebx),%edi
  801a9c:	0f b6 03             	movzbl (%ebx),%eax
  801a9f:	83 f8 25             	cmp    $0x25,%eax
  801aa2:	75 de                	jne    801a82 <vprintfmt+0xe>
  801aa4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  801aa8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801aaf:	be ff ff ff ff       	mov    $0xffffffff,%esi
  801ab4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801abb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac0:	eb 18                	jmp    801ada <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ac2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801ac4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  801ac8:	eb 10                	jmp    801ada <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aca:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801acc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  801ad0:	eb 08                	jmp    801ada <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801ad2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801ad5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ada:	8d 5f 01             	lea    0x1(%edi),%ebx
  801add:	0f b6 17             	movzbl (%edi),%edx
  801ae0:	0f b6 c2             	movzbl %dl,%eax
  801ae3:	83 ea 23             	sub    $0x23,%edx
  801ae6:	80 fa 55             	cmp    $0x55,%dl
  801ae9:	0f 87 c2 03 00 00    	ja     801eb1 <vprintfmt+0x43d>
  801aef:	0f b6 d2             	movzbl %dl,%edx
  801af2:	ff 24 95 c0 29 80 00 	jmp    *0x8029c0(,%edx,4)
  801af9:	89 df                	mov    %ebx,%edi
  801afb:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801b00:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  801b03:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  801b07:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  801b0a:	8d 50 d0             	lea    -0x30(%eax),%edx
  801b0d:	83 fa 09             	cmp    $0x9,%edx
  801b10:	77 33                	ja     801b45 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b12:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b15:	eb e9                	jmp    801b00 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b17:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1a:	8b 30                	mov    (%eax),%esi
  801b1c:	8d 40 04             	lea    0x4(%eax),%eax
  801b1f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b22:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801b24:	eb 1f                	jmp    801b45 <vprintfmt+0xd1>
  801b26:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801b29:	85 ff                	test   %edi,%edi
  801b2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b30:	0f 49 c7             	cmovns %edi,%eax
  801b33:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b36:	89 df                	mov    %ebx,%edi
  801b38:	eb a0                	jmp    801ada <vprintfmt+0x66>
  801b3a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801b3c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  801b43:	eb 95                	jmp    801ada <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  801b45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b49:	79 8f                	jns    801ada <vprintfmt+0x66>
  801b4b:	eb 85                	jmp    801ad2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b4d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b50:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801b52:	eb 86                	jmp    801ada <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b54:	8b 45 14             	mov    0x14(%ebp),%eax
  801b57:	8d 70 04             	lea    0x4(%eax),%esi
  801b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b61:	8b 45 14             	mov    0x14(%ebp),%eax
  801b64:	8b 00                	mov    (%eax),%eax
  801b66:	89 04 24             	mov    %eax,(%esp)
  801b69:	ff 55 08             	call   *0x8(%ebp)
  801b6c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  801b6f:	e9 25 ff ff ff       	jmp    801a99 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b74:	8b 45 14             	mov    0x14(%ebp),%eax
  801b77:	8d 70 04             	lea    0x4(%eax),%esi
  801b7a:	8b 00                	mov    (%eax),%eax
  801b7c:	99                   	cltd   
  801b7d:	31 d0                	xor    %edx,%eax
  801b7f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801b81:	83 f8 15             	cmp    $0x15,%eax
  801b84:	7f 0b                	jg     801b91 <vprintfmt+0x11d>
  801b86:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  801b8d:	85 d2                	test   %edx,%edx
  801b8f:	75 26                	jne    801bb7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  801b91:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b95:	c7 44 24 08 9b 28 80 	movl   $0x80289b,0x8(%esp)
  801b9c:	00 
  801b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	89 04 24             	mov    %eax,(%esp)
  801baa:	e8 9d fe ff ff       	call   801a4c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  801baf:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801bb2:	e9 e2 fe ff ff       	jmp    801a99 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801bb7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801bbb:	c7 44 24 08 c6 27 80 	movl   $0x8027c6,0x8(%esp)
  801bc2:	00 
  801bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	89 04 24             	mov    %eax,(%esp)
  801bd0:	e8 77 fe ff ff       	call   801a4c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bd5:	89 75 14             	mov    %esi,0x14(%ebp)
  801bd8:	e9 bc fe ff ff       	jmp    801a99 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  801be0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801be3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801be6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801bea:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801bec:	85 ff                	test   %edi,%edi
  801bee:	b8 94 28 80 00       	mov    $0x802894,%eax
  801bf3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801bf6:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  801bfa:	0f 84 94 00 00 00    	je     801c94 <vprintfmt+0x220>
  801c00:	85 c9                	test   %ecx,%ecx
  801c02:	0f 8e 94 00 00 00    	jle    801c9c <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c08:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c0c:	89 3c 24             	mov    %edi,(%esp)
  801c0f:	e8 64 03 00 00       	call   801f78 <strnlen>
  801c14:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801c17:	29 c1                	sub    %eax,%ecx
  801c19:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  801c1c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  801c20:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801c23:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801c26:	8b 75 08             	mov    0x8(%ebp),%esi
  801c29:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c2c:	89 cb                	mov    %ecx,%ebx
  801c2e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c30:	eb 0f                	jmp    801c41 <vprintfmt+0x1cd>
					putch(padc, putdat);
  801c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c39:	89 3c 24             	mov    %edi,(%esp)
  801c3c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c3e:	83 eb 01             	sub    $0x1,%ebx
  801c41:	85 db                	test   %ebx,%ebx
  801c43:	7f ed                	jg     801c32 <vprintfmt+0x1be>
  801c45:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c48:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801c4b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801c4e:	85 c9                	test   %ecx,%ecx
  801c50:	b8 00 00 00 00       	mov    $0x0,%eax
  801c55:	0f 49 c1             	cmovns %ecx,%eax
  801c58:	29 c1                	sub    %eax,%ecx
  801c5a:	89 cb                	mov    %ecx,%ebx
  801c5c:	eb 44                	jmp    801ca2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801c5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c62:	74 1e                	je     801c82 <vprintfmt+0x20e>
  801c64:	0f be d2             	movsbl %dl,%edx
  801c67:	83 ea 20             	sub    $0x20,%edx
  801c6a:	83 fa 5e             	cmp    $0x5e,%edx
  801c6d:	76 13                	jbe    801c82 <vprintfmt+0x20e>
					putch('?', putdat);
  801c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c76:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801c7d:	ff 55 08             	call   *0x8(%ebp)
  801c80:	eb 0d                	jmp    801c8f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  801c82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c85:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c89:	89 04 24             	mov    %eax,(%esp)
  801c8c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c8f:	83 eb 01             	sub    $0x1,%ebx
  801c92:	eb 0e                	jmp    801ca2 <vprintfmt+0x22e>
  801c94:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c97:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801c9a:	eb 06                	jmp    801ca2 <vprintfmt+0x22e>
  801c9c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c9f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801ca2:	83 c7 01             	add    $0x1,%edi
  801ca5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801ca9:	0f be c2             	movsbl %dl,%eax
  801cac:	85 c0                	test   %eax,%eax
  801cae:	74 27                	je     801cd7 <vprintfmt+0x263>
  801cb0:	85 f6                	test   %esi,%esi
  801cb2:	78 aa                	js     801c5e <vprintfmt+0x1ea>
  801cb4:	83 ee 01             	sub    $0x1,%esi
  801cb7:	79 a5                	jns    801c5e <vprintfmt+0x1ea>
  801cb9:	89 d8                	mov    %ebx,%eax
  801cbb:	8b 75 08             	mov    0x8(%ebp),%esi
  801cbe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cc1:	89 c3                	mov    %eax,%ebx
  801cc3:	eb 18                	jmp    801cdd <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801cc5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cc9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801cd0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cd2:	83 eb 01             	sub    $0x1,%ebx
  801cd5:	eb 06                	jmp    801cdd <vprintfmt+0x269>
  801cd7:	8b 75 08             	mov    0x8(%ebp),%esi
  801cda:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cdd:	85 db                	test   %ebx,%ebx
  801cdf:	7f e4                	jg     801cc5 <vprintfmt+0x251>
  801ce1:	89 75 08             	mov    %esi,0x8(%ebp)
  801ce4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801ce7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cea:	e9 aa fd ff ff       	jmp    801a99 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801cef:	83 f9 01             	cmp    $0x1,%ecx
  801cf2:	7e 10                	jle    801d04 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  801cf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf7:	8b 30                	mov    (%eax),%esi
  801cf9:	8b 78 04             	mov    0x4(%eax),%edi
  801cfc:	8d 40 08             	lea    0x8(%eax),%eax
  801cff:	89 45 14             	mov    %eax,0x14(%ebp)
  801d02:	eb 26                	jmp    801d2a <vprintfmt+0x2b6>
	else if (lflag)
  801d04:	85 c9                	test   %ecx,%ecx
  801d06:	74 12                	je     801d1a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  801d08:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0b:	8b 30                	mov    (%eax),%esi
  801d0d:	89 f7                	mov    %esi,%edi
  801d0f:	c1 ff 1f             	sar    $0x1f,%edi
  801d12:	8d 40 04             	lea    0x4(%eax),%eax
  801d15:	89 45 14             	mov    %eax,0x14(%ebp)
  801d18:	eb 10                	jmp    801d2a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  801d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1d:	8b 30                	mov    (%eax),%esi
  801d1f:	89 f7                	mov    %esi,%edi
  801d21:	c1 ff 1f             	sar    $0x1f,%edi
  801d24:	8d 40 04             	lea    0x4(%eax),%eax
  801d27:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d2a:	89 f0                	mov    %esi,%eax
  801d2c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801d2e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801d33:	85 ff                	test   %edi,%edi
  801d35:	0f 89 3a 01 00 00    	jns    801e75 <vprintfmt+0x401>
				putch('-', putdat);
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d42:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801d49:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801d4c:	89 f0                	mov    %esi,%eax
  801d4e:	89 fa                	mov    %edi,%edx
  801d50:	f7 d8                	neg    %eax
  801d52:	83 d2 00             	adc    $0x0,%edx
  801d55:	f7 da                	neg    %edx
			}
			base = 10;
  801d57:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d5c:	e9 14 01 00 00       	jmp    801e75 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801d61:	83 f9 01             	cmp    $0x1,%ecx
  801d64:	7e 13                	jle    801d79 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  801d66:	8b 45 14             	mov    0x14(%ebp),%eax
  801d69:	8b 50 04             	mov    0x4(%eax),%edx
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	8b 75 14             	mov    0x14(%ebp),%esi
  801d71:	8d 4e 08             	lea    0x8(%esi),%ecx
  801d74:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801d77:	eb 2c                	jmp    801da5 <vprintfmt+0x331>
	else if (lflag)
  801d79:	85 c9                	test   %ecx,%ecx
  801d7b:	74 15                	je     801d92 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  801d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d80:	8b 00                	mov    (%eax),%eax
  801d82:	ba 00 00 00 00       	mov    $0x0,%edx
  801d87:	8b 75 14             	mov    0x14(%ebp),%esi
  801d8a:	8d 76 04             	lea    0x4(%esi),%esi
  801d8d:	89 75 14             	mov    %esi,0x14(%ebp)
  801d90:	eb 13                	jmp    801da5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  801d92:	8b 45 14             	mov    0x14(%ebp),%eax
  801d95:	8b 00                	mov    (%eax),%eax
  801d97:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9c:	8b 75 14             	mov    0x14(%ebp),%esi
  801d9f:	8d 76 04             	lea    0x4(%esi),%esi
  801da2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  801da5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801daa:	e9 c6 00 00 00       	jmp    801e75 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801daf:	83 f9 01             	cmp    $0x1,%ecx
  801db2:	7e 13                	jle    801dc7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  801db4:	8b 45 14             	mov    0x14(%ebp),%eax
  801db7:	8b 50 04             	mov    0x4(%eax),%edx
  801dba:	8b 00                	mov    (%eax),%eax
  801dbc:	8b 75 14             	mov    0x14(%ebp),%esi
  801dbf:	8d 4e 08             	lea    0x8(%esi),%ecx
  801dc2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801dc5:	eb 24                	jmp    801deb <vprintfmt+0x377>
	else if (lflag)
  801dc7:	85 c9                	test   %ecx,%ecx
  801dc9:	74 11                	je     801ddc <vprintfmt+0x368>
		return va_arg(*ap, long);
  801dcb:	8b 45 14             	mov    0x14(%ebp),%eax
  801dce:	8b 00                	mov    (%eax),%eax
  801dd0:	99                   	cltd   
  801dd1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dd4:	8d 71 04             	lea    0x4(%ecx),%esi
  801dd7:	89 75 14             	mov    %esi,0x14(%ebp)
  801dda:	eb 0f                	jmp    801deb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  801ddc:	8b 45 14             	mov    0x14(%ebp),%eax
  801ddf:	8b 00                	mov    (%eax),%eax
  801de1:	99                   	cltd   
  801de2:	8b 75 14             	mov    0x14(%ebp),%esi
  801de5:	8d 76 04             	lea    0x4(%esi),%esi
  801de8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  801deb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801df0:	e9 80 00 00 00       	jmp    801e75 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801df5:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  801df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dff:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801e06:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e10:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801e17:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801e1a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e1e:	8b 06                	mov    (%esi),%eax
  801e20:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801e25:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801e2a:	eb 49                	jmp    801e75 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801e2c:	83 f9 01             	cmp    $0x1,%ecx
  801e2f:	7e 13                	jle    801e44 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  801e31:	8b 45 14             	mov    0x14(%ebp),%eax
  801e34:	8b 50 04             	mov    0x4(%eax),%edx
  801e37:	8b 00                	mov    (%eax),%eax
  801e39:	8b 75 14             	mov    0x14(%ebp),%esi
  801e3c:	8d 4e 08             	lea    0x8(%esi),%ecx
  801e3f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801e42:	eb 2c                	jmp    801e70 <vprintfmt+0x3fc>
	else if (lflag)
  801e44:	85 c9                	test   %ecx,%ecx
  801e46:	74 15                	je     801e5d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  801e48:	8b 45 14             	mov    0x14(%ebp),%eax
  801e4b:	8b 00                	mov    (%eax),%eax
  801e4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e52:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e55:	8d 71 04             	lea    0x4(%ecx),%esi
  801e58:	89 75 14             	mov    %esi,0x14(%ebp)
  801e5b:	eb 13                	jmp    801e70 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  801e5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e60:	8b 00                	mov    (%eax),%eax
  801e62:	ba 00 00 00 00       	mov    $0x0,%edx
  801e67:	8b 75 14             	mov    0x14(%ebp),%esi
  801e6a:	8d 76 04             	lea    0x4(%esi),%esi
  801e6d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  801e70:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e75:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  801e79:	89 74 24 10          	mov    %esi,0x10(%esp)
  801e7d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  801e80:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e84:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e88:	89 04 24             	mov    %eax,(%esp)
  801e8b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	e8 a6 fa ff ff       	call   801940 <printnum>
			break;
  801e9a:	e9 fa fb ff ff       	jmp    801a99 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ea6:	89 04 24             	mov    %eax,(%esp)
  801ea9:	ff 55 08             	call   *0x8(%ebp)
			break;
  801eac:	e9 e8 fb ff ff       	jmp    801a99 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801ebf:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ec2:	89 fb                	mov    %edi,%ebx
  801ec4:	eb 03                	jmp    801ec9 <vprintfmt+0x455>
  801ec6:	83 eb 01             	sub    $0x1,%ebx
  801ec9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801ecd:	75 f7                	jne    801ec6 <vprintfmt+0x452>
  801ecf:	90                   	nop
  801ed0:	e9 c4 fb ff ff       	jmp    801a99 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801ed5:	83 c4 3c             	add    $0x3c,%esp
  801ed8:	5b                   	pop    %ebx
  801ed9:	5e                   	pop    %esi
  801eda:	5f                   	pop    %edi
  801edb:	5d                   	pop    %ebp
  801edc:	c3                   	ret    

00801edd <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 28             	sub    $0x28,%esp
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ee9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801eec:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801ef0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801ef3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801efa:	85 c0                	test   %eax,%eax
  801efc:	74 30                	je     801f2e <vsnprintf+0x51>
  801efe:	85 d2                	test   %edx,%edx
  801f00:	7e 2c                	jle    801f2e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f02:	8b 45 14             	mov    0x14(%ebp),%eax
  801f05:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f09:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f10:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f17:	c7 04 24 2f 1a 80 00 	movl   $0x801a2f,(%esp)
  801f1e:	e8 51 fb ff ff       	call   801a74 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f26:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2c:	eb 05                	jmp    801f33 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801f2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f3b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f42:	8b 45 10             	mov    0x10(%ebp),%eax
  801f45:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	89 04 24             	mov    %eax,(%esp)
  801f56:	e8 82 ff ff ff       	call   801edd <vsnprintf>
	va_end(ap);

	return rc;
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    
  801f5d:	66 90                	xchg   %ax,%ax
  801f5f:	90                   	nop

00801f60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801f66:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6b:	eb 03                	jmp    801f70 <strlen+0x10>
		n++;
  801f6d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f70:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801f74:	75 f7                	jne    801f6d <strlen+0xd>
		n++;
	return n;
}
  801f76:	5d                   	pop    %ebp
  801f77:	c3                   	ret    

00801f78 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
  801f86:	eb 03                	jmp    801f8b <strnlen+0x13>
		n++;
  801f88:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f8b:	39 d0                	cmp    %edx,%eax
  801f8d:	74 06                	je     801f95 <strnlen+0x1d>
  801f8f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801f93:	75 f3                	jne    801f88 <strnlen+0x10>
		n++;
	return n;
}
  801f95:	5d                   	pop    %ebp
  801f96:	c3                   	ret    

00801f97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	53                   	push   %ebx
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801fa1:	89 c2                	mov    %eax,%edx
  801fa3:	83 c2 01             	add    $0x1,%edx
  801fa6:	83 c1 01             	add    $0x1,%ecx
  801fa9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801fad:	88 5a ff             	mov    %bl,-0x1(%edx)
  801fb0:	84 db                	test   %bl,%bl
  801fb2:	75 ef                	jne    801fa3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801fb4:	5b                   	pop    %ebx
  801fb5:	5d                   	pop    %ebp
  801fb6:	c3                   	ret    

00801fb7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	53                   	push   %ebx
  801fbb:	83 ec 08             	sub    $0x8,%esp
  801fbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801fc1:	89 1c 24             	mov    %ebx,(%esp)
  801fc4:	e8 97 ff ff ff       	call   801f60 <strlen>
	strcpy(dst + len, src);
  801fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fd0:	01 d8                	add    %ebx,%eax
  801fd2:	89 04 24             	mov    %eax,(%esp)
  801fd5:	e8 bd ff ff ff       	call   801f97 <strcpy>
	return dst;
}
  801fda:	89 d8                	mov    %ebx,%eax
  801fdc:	83 c4 08             	add    $0x8,%esp
  801fdf:	5b                   	pop    %ebx
  801fe0:	5d                   	pop    %ebp
  801fe1:	c3                   	ret    

00801fe2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	56                   	push   %esi
  801fe6:	53                   	push   %ebx
  801fe7:	8b 75 08             	mov    0x8(%ebp),%esi
  801fea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fed:	89 f3                	mov    %esi,%ebx
  801fef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801ff2:	89 f2                	mov    %esi,%edx
  801ff4:	eb 0f                	jmp    802005 <strncpy+0x23>
		*dst++ = *src;
  801ff6:	83 c2 01             	add    $0x1,%edx
  801ff9:	0f b6 01             	movzbl (%ecx),%eax
  801ffc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801fff:	80 39 01             	cmpb   $0x1,(%ecx)
  802002:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802005:	39 da                	cmp    %ebx,%edx
  802007:	75 ed                	jne    801ff6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  802009:	89 f0                	mov    %esi,%eax
  80200b:	5b                   	pop    %ebx
  80200c:	5e                   	pop    %esi
  80200d:	5d                   	pop    %ebp
  80200e:	c3                   	ret    

0080200f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	56                   	push   %esi
  802013:	53                   	push   %ebx
  802014:	8b 75 08             	mov    0x8(%ebp),%esi
  802017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80201d:	89 f0                	mov    %esi,%eax
  80201f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802023:	85 c9                	test   %ecx,%ecx
  802025:	75 0b                	jne    802032 <strlcpy+0x23>
  802027:	eb 1d                	jmp    802046 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802029:	83 c0 01             	add    $0x1,%eax
  80202c:	83 c2 01             	add    $0x1,%edx
  80202f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802032:	39 d8                	cmp    %ebx,%eax
  802034:	74 0b                	je     802041 <strlcpy+0x32>
  802036:	0f b6 0a             	movzbl (%edx),%ecx
  802039:	84 c9                	test   %cl,%cl
  80203b:	75 ec                	jne    802029 <strlcpy+0x1a>
  80203d:	89 c2                	mov    %eax,%edx
  80203f:	eb 02                	jmp    802043 <strlcpy+0x34>
  802041:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  802043:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  802046:	29 f0                	sub    %esi,%eax
}
  802048:	5b                   	pop    %ebx
  802049:	5e                   	pop    %esi
  80204a:	5d                   	pop    %ebp
  80204b:	c3                   	ret    

0080204c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802052:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802055:	eb 06                	jmp    80205d <strcmp+0x11>
		p++, q++;
  802057:	83 c1 01             	add    $0x1,%ecx
  80205a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80205d:	0f b6 01             	movzbl (%ecx),%eax
  802060:	84 c0                	test   %al,%al
  802062:	74 04                	je     802068 <strcmp+0x1c>
  802064:	3a 02                	cmp    (%edx),%al
  802066:	74 ef                	je     802057 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802068:	0f b6 c0             	movzbl %al,%eax
  80206b:	0f b6 12             	movzbl (%edx),%edx
  80206e:	29 d0                	sub    %edx,%eax
}
  802070:	5d                   	pop    %ebp
  802071:	c3                   	ret    

00802072 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	53                   	push   %ebx
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207c:	89 c3                	mov    %eax,%ebx
  80207e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802081:	eb 06                	jmp    802089 <strncmp+0x17>
		n--, p++, q++;
  802083:	83 c0 01             	add    $0x1,%eax
  802086:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802089:	39 d8                	cmp    %ebx,%eax
  80208b:	74 15                	je     8020a2 <strncmp+0x30>
  80208d:	0f b6 08             	movzbl (%eax),%ecx
  802090:	84 c9                	test   %cl,%cl
  802092:	74 04                	je     802098 <strncmp+0x26>
  802094:	3a 0a                	cmp    (%edx),%cl
  802096:	74 eb                	je     802083 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802098:	0f b6 00             	movzbl (%eax),%eax
  80209b:	0f b6 12             	movzbl (%edx),%edx
  80209e:	29 d0                	sub    %edx,%eax
  8020a0:	eb 05                	jmp    8020a7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8020a2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8020a7:	5b                   	pop    %ebx
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    

008020aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020b4:	eb 07                	jmp    8020bd <strchr+0x13>
		if (*s == c)
  8020b6:	38 ca                	cmp    %cl,%dl
  8020b8:	74 0f                	je     8020c9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020ba:	83 c0 01             	add    $0x1,%eax
  8020bd:	0f b6 10             	movzbl (%eax),%edx
  8020c0:	84 d2                	test   %dl,%dl
  8020c2:	75 f2                	jne    8020b6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8020c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c9:	5d                   	pop    %ebp
  8020ca:	c3                   	ret    

008020cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020d5:	eb 07                	jmp    8020de <strfind+0x13>
		if (*s == c)
  8020d7:	38 ca                	cmp    %cl,%dl
  8020d9:	74 0a                	je     8020e5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020db:	83 c0 01             	add    $0x1,%eax
  8020de:	0f b6 10             	movzbl (%eax),%edx
  8020e1:	84 d2                	test   %dl,%dl
  8020e3:	75 f2                	jne    8020d7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8020e5:	5d                   	pop    %ebp
  8020e6:	c3                   	ret    

008020e7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	57                   	push   %edi
  8020eb:	56                   	push   %esi
  8020ec:	53                   	push   %ebx
  8020ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8020f3:	85 c9                	test   %ecx,%ecx
  8020f5:	74 36                	je     80212d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8020f7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8020fd:	75 28                	jne    802127 <memset+0x40>
  8020ff:	f6 c1 03             	test   $0x3,%cl
  802102:	75 23                	jne    802127 <memset+0x40>
		c &= 0xFF;
  802104:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802108:	89 d3                	mov    %edx,%ebx
  80210a:	c1 e3 08             	shl    $0x8,%ebx
  80210d:	89 d6                	mov    %edx,%esi
  80210f:	c1 e6 18             	shl    $0x18,%esi
  802112:	89 d0                	mov    %edx,%eax
  802114:	c1 e0 10             	shl    $0x10,%eax
  802117:	09 f0                	or     %esi,%eax
  802119:	09 c2                	or     %eax,%edx
  80211b:	89 d0                	mov    %edx,%eax
  80211d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80211f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802122:	fc                   	cld    
  802123:	f3 ab                	rep stos %eax,%es:(%edi)
  802125:	eb 06                	jmp    80212d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212a:	fc                   	cld    
  80212b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80212d:	89 f8                	mov    %edi,%eax
  80212f:	5b                   	pop    %ebx
  802130:	5e                   	pop    %esi
  802131:	5f                   	pop    %edi
  802132:	5d                   	pop    %ebp
  802133:	c3                   	ret    

00802134 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	57                   	push   %edi
  802138:	56                   	push   %esi
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80213f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802142:	39 c6                	cmp    %eax,%esi
  802144:	73 35                	jae    80217b <memmove+0x47>
  802146:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802149:	39 d0                	cmp    %edx,%eax
  80214b:	73 2e                	jae    80217b <memmove+0x47>
		s += n;
		d += n;
  80214d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802150:	89 d6                	mov    %edx,%esi
  802152:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802154:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80215a:	75 13                	jne    80216f <memmove+0x3b>
  80215c:	f6 c1 03             	test   $0x3,%cl
  80215f:	75 0e                	jne    80216f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802161:	83 ef 04             	sub    $0x4,%edi
  802164:	8d 72 fc             	lea    -0x4(%edx),%esi
  802167:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80216a:	fd                   	std    
  80216b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80216d:	eb 09                	jmp    802178 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80216f:	83 ef 01             	sub    $0x1,%edi
  802172:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802175:	fd                   	std    
  802176:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802178:	fc                   	cld    
  802179:	eb 1d                	jmp    802198 <memmove+0x64>
  80217b:	89 f2                	mov    %esi,%edx
  80217d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80217f:	f6 c2 03             	test   $0x3,%dl
  802182:	75 0f                	jne    802193 <memmove+0x5f>
  802184:	f6 c1 03             	test   $0x3,%cl
  802187:	75 0a                	jne    802193 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802189:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80218c:	89 c7                	mov    %eax,%edi
  80218e:	fc                   	cld    
  80218f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802191:	eb 05                	jmp    802198 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802193:	89 c7                	mov    %eax,%edi
  802195:	fc                   	cld    
  802196:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802198:	5e                   	pop    %esi
  802199:	5f                   	pop    %edi
  80219a:	5d                   	pop    %ebp
  80219b:	c3                   	ret    

0080219c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8021a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	89 04 24             	mov    %eax,(%esp)
  8021b6:	e8 79 ff ff ff       	call   802134 <memmove>
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	56                   	push   %esi
  8021c1:	53                   	push   %ebx
  8021c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021c8:	89 d6                	mov    %edx,%esi
  8021ca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021cd:	eb 1a                	jmp    8021e9 <memcmp+0x2c>
		if (*s1 != *s2)
  8021cf:	0f b6 02             	movzbl (%edx),%eax
  8021d2:	0f b6 19             	movzbl (%ecx),%ebx
  8021d5:	38 d8                	cmp    %bl,%al
  8021d7:	74 0a                	je     8021e3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8021d9:	0f b6 c0             	movzbl %al,%eax
  8021dc:	0f b6 db             	movzbl %bl,%ebx
  8021df:	29 d8                	sub    %ebx,%eax
  8021e1:	eb 0f                	jmp    8021f2 <memcmp+0x35>
		s1++, s2++;
  8021e3:	83 c2 01             	add    $0x1,%edx
  8021e6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021e9:	39 f2                	cmp    %esi,%edx
  8021eb:	75 e2                	jne    8021cf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f2:	5b                   	pop    %ebx
  8021f3:	5e                   	pop    %esi
  8021f4:	5d                   	pop    %ebp
  8021f5:	c3                   	ret    

008021f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8021ff:	89 c2                	mov    %eax,%edx
  802201:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802204:	eb 07                	jmp    80220d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802206:	38 08                	cmp    %cl,(%eax)
  802208:	74 07                	je     802211 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80220a:	83 c0 01             	add    $0x1,%eax
  80220d:	39 d0                	cmp    %edx,%eax
  80220f:	72 f5                	jb     802206 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802211:	5d                   	pop    %ebp
  802212:	c3                   	ret    

00802213 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
  802216:	57                   	push   %edi
  802217:	56                   	push   %esi
  802218:	53                   	push   %ebx
  802219:	8b 55 08             	mov    0x8(%ebp),%edx
  80221c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80221f:	eb 03                	jmp    802224 <strtol+0x11>
		s++;
  802221:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802224:	0f b6 0a             	movzbl (%edx),%ecx
  802227:	80 f9 09             	cmp    $0x9,%cl
  80222a:	74 f5                	je     802221 <strtol+0xe>
  80222c:	80 f9 20             	cmp    $0x20,%cl
  80222f:	74 f0                	je     802221 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802231:	80 f9 2b             	cmp    $0x2b,%cl
  802234:	75 0a                	jne    802240 <strtol+0x2d>
		s++;
  802236:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802239:	bf 00 00 00 00       	mov    $0x0,%edi
  80223e:	eb 11                	jmp    802251 <strtol+0x3e>
  802240:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802245:	80 f9 2d             	cmp    $0x2d,%cl
  802248:	75 07                	jne    802251 <strtol+0x3e>
		s++, neg = 1;
  80224a:	8d 52 01             	lea    0x1(%edx),%edx
  80224d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802251:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802256:	75 15                	jne    80226d <strtol+0x5a>
  802258:	80 3a 30             	cmpb   $0x30,(%edx)
  80225b:	75 10                	jne    80226d <strtol+0x5a>
  80225d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802261:	75 0a                	jne    80226d <strtol+0x5a>
		s += 2, base = 16;
  802263:	83 c2 02             	add    $0x2,%edx
  802266:	b8 10 00 00 00       	mov    $0x10,%eax
  80226b:	eb 10                	jmp    80227d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80226d:	85 c0                	test   %eax,%eax
  80226f:	75 0c                	jne    80227d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802271:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802273:	80 3a 30             	cmpb   $0x30,(%edx)
  802276:	75 05                	jne    80227d <strtol+0x6a>
		s++, base = 8;
  802278:	83 c2 01             	add    $0x1,%edx
  80227b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80227d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802282:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802285:	0f b6 0a             	movzbl (%edx),%ecx
  802288:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80228b:	89 f0                	mov    %esi,%eax
  80228d:	3c 09                	cmp    $0x9,%al
  80228f:	77 08                	ja     802299 <strtol+0x86>
			dig = *s - '0';
  802291:	0f be c9             	movsbl %cl,%ecx
  802294:	83 e9 30             	sub    $0x30,%ecx
  802297:	eb 20                	jmp    8022b9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  802299:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80229c:	89 f0                	mov    %esi,%eax
  80229e:	3c 19                	cmp    $0x19,%al
  8022a0:	77 08                	ja     8022aa <strtol+0x97>
			dig = *s - 'a' + 10;
  8022a2:	0f be c9             	movsbl %cl,%ecx
  8022a5:	83 e9 57             	sub    $0x57,%ecx
  8022a8:	eb 0f                	jmp    8022b9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8022aa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8022ad:	89 f0                	mov    %esi,%eax
  8022af:	3c 19                	cmp    $0x19,%al
  8022b1:	77 16                	ja     8022c9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8022b3:	0f be c9             	movsbl %cl,%ecx
  8022b6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8022b9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8022bc:	7d 0f                	jge    8022cd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8022be:	83 c2 01             	add    $0x1,%edx
  8022c1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8022c5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8022c7:	eb bc                	jmp    802285 <strtol+0x72>
  8022c9:	89 d8                	mov    %ebx,%eax
  8022cb:	eb 02                	jmp    8022cf <strtol+0xbc>
  8022cd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8022cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022d3:	74 05                	je     8022da <strtol+0xc7>
		*endptr = (char *) s;
  8022d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022d8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8022da:	f7 d8                	neg    %eax
  8022dc:	85 ff                	test   %edi,%edi
  8022de:	0f 44 c3             	cmove  %ebx,%eax
}
  8022e1:	5b                   	pop    %ebx
  8022e2:	5e                   	pop    %esi
  8022e3:	5f                   	pop    %edi
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    
  8022e6:	66 90                	xchg   %ax,%ax
  8022e8:	66 90                	xchg   %ax,%ax
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	56                   	push   %esi
  8022f4:	53                   	push   %ebx
  8022f5:	83 ec 10             	sub    $0x10,%esp
  8022f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802301:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802303:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802308:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80230b:	89 04 24             	mov    %eax,(%esp)
  80230e:	e8 dc e0 ff ff       	call   8003ef <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802313:	85 c0                	test   %eax,%eax
  802315:	75 26                	jne    80233d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802317:	85 f6                	test   %esi,%esi
  802319:	74 0a                	je     802325 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80231b:	a1 08 40 80 00       	mov    0x804008,%eax
  802320:	8b 40 74             	mov    0x74(%eax),%eax
  802323:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802325:	85 db                	test   %ebx,%ebx
  802327:	74 0a                	je     802333 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802329:	a1 08 40 80 00       	mov    0x804008,%eax
  80232e:	8b 40 78             	mov    0x78(%eax),%eax
  802331:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802333:	a1 08 40 80 00       	mov    0x804008,%eax
  802338:	8b 40 70             	mov    0x70(%eax),%eax
  80233b:	eb 14                	jmp    802351 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80233d:	85 f6                	test   %esi,%esi
  80233f:	74 06                	je     802347 <ipc_recv+0x57>
			*from_env_store = 0;
  802341:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802347:	85 db                	test   %ebx,%ebx
  802349:	74 06                	je     802351 <ipc_recv+0x61>
			*perm_store = 0;
  80234b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802351:	83 c4 10             	add    $0x10,%esp
  802354:	5b                   	pop    %ebx
  802355:	5e                   	pop    %esi
  802356:	5d                   	pop    %ebp
  802357:	c3                   	ret    

00802358 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	57                   	push   %edi
  80235c:	56                   	push   %esi
  80235d:	53                   	push   %ebx
  80235e:	83 ec 1c             	sub    $0x1c,%esp
  802361:	8b 7d 08             	mov    0x8(%ebp),%edi
  802364:	8b 75 0c             	mov    0xc(%ebp),%esi
  802367:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80236a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80236c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802371:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802374:	8b 45 14             	mov    0x14(%ebp),%eax
  802377:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80237b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80237f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802383:	89 3c 24             	mov    %edi,(%esp)
  802386:	e8 41 e0 ff ff       	call   8003cc <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80238b:	85 c0                	test   %eax,%eax
  80238d:	74 28                	je     8023b7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80238f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802392:	74 1c                	je     8023b0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802394:	c7 44 24 08 98 2b 80 	movl   $0x802b98,0x8(%esp)
  80239b:	00 
  80239c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8023a3:	00 
  8023a4:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  8023ab:	e8 76 f4 ff ff       	call   801826 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8023b0:	e8 e5 dd ff ff       	call   80019a <sys_yield>
	}
  8023b5:	eb bd                	jmp    802374 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8023b7:	83 c4 1c             	add    $0x1c,%esp
  8023ba:	5b                   	pop    %ebx
  8023bb:	5e                   	pop    %esi
  8023bc:	5f                   	pop    %edi
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023ca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023cd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023d3:	8b 52 50             	mov    0x50(%edx),%edx
  8023d6:	39 ca                	cmp    %ecx,%edx
  8023d8:	75 0d                	jne    8023e7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8023da:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023dd:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8023e2:	8b 40 40             	mov    0x40(%eax),%eax
  8023e5:	eb 0e                	jmp    8023f5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023e7:	83 c0 01             	add    $0x1,%eax
  8023ea:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023ef:	75 d9                	jne    8023ca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023f1:	66 b8 00 00          	mov    $0x0,%ax
}
  8023f5:	5d                   	pop    %ebp
  8023f6:	c3                   	ret    

008023f7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
  8023fa:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023fd:	89 d0                	mov    %edx,%eax
  8023ff:	c1 e8 16             	shr    $0x16,%eax
  802402:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802409:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80240e:	f6 c1 01             	test   $0x1,%cl
  802411:	74 1d                	je     802430 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802413:	c1 ea 0c             	shr    $0xc,%edx
  802416:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80241d:	f6 c2 01             	test   $0x1,%dl
  802420:	74 0e                	je     802430 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802422:	c1 ea 0c             	shr    $0xc,%edx
  802425:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80242c:	ef 
  80242d:	0f b7 c0             	movzwl %ax,%eax
}
  802430:	5d                   	pop    %ebp
  802431:	c3                   	ret    
  802432:	66 90                	xchg   %ax,%ax
  802434:	66 90                	xchg   %ax,%ax
  802436:	66 90                	xchg   %ax,%ax
  802438:	66 90                	xchg   %ax,%ax
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	66 90                	xchg   %ax,%ax
  80243e:	66 90                	xchg   %ax,%ax

00802440 <__udivdi3>:
  802440:	55                   	push   %ebp
  802441:	57                   	push   %edi
  802442:	56                   	push   %esi
  802443:	83 ec 0c             	sub    $0xc,%esp
  802446:	8b 44 24 28          	mov    0x28(%esp),%eax
  80244a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80244e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802452:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802456:	85 c0                	test   %eax,%eax
  802458:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80245c:	89 ea                	mov    %ebp,%edx
  80245e:	89 0c 24             	mov    %ecx,(%esp)
  802461:	75 2d                	jne    802490 <__udivdi3+0x50>
  802463:	39 e9                	cmp    %ebp,%ecx
  802465:	77 61                	ja     8024c8 <__udivdi3+0x88>
  802467:	85 c9                	test   %ecx,%ecx
  802469:	89 ce                	mov    %ecx,%esi
  80246b:	75 0b                	jne    802478 <__udivdi3+0x38>
  80246d:	b8 01 00 00 00       	mov    $0x1,%eax
  802472:	31 d2                	xor    %edx,%edx
  802474:	f7 f1                	div    %ecx
  802476:	89 c6                	mov    %eax,%esi
  802478:	31 d2                	xor    %edx,%edx
  80247a:	89 e8                	mov    %ebp,%eax
  80247c:	f7 f6                	div    %esi
  80247e:	89 c5                	mov    %eax,%ebp
  802480:	89 f8                	mov    %edi,%eax
  802482:	f7 f6                	div    %esi
  802484:	89 ea                	mov    %ebp,%edx
  802486:	83 c4 0c             	add    $0xc,%esp
  802489:	5e                   	pop    %esi
  80248a:	5f                   	pop    %edi
  80248b:	5d                   	pop    %ebp
  80248c:	c3                   	ret    
  80248d:	8d 76 00             	lea    0x0(%esi),%esi
  802490:	39 e8                	cmp    %ebp,%eax
  802492:	77 24                	ja     8024b8 <__udivdi3+0x78>
  802494:	0f bd e8             	bsr    %eax,%ebp
  802497:	83 f5 1f             	xor    $0x1f,%ebp
  80249a:	75 3c                	jne    8024d8 <__udivdi3+0x98>
  80249c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024a0:	39 34 24             	cmp    %esi,(%esp)
  8024a3:	0f 86 9f 00 00 00    	jbe    802548 <__udivdi3+0x108>
  8024a9:	39 d0                	cmp    %edx,%eax
  8024ab:	0f 82 97 00 00 00    	jb     802548 <__udivdi3+0x108>
  8024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	31 d2                	xor    %edx,%edx
  8024ba:	31 c0                	xor    %eax,%eax
  8024bc:	83 c4 0c             	add    $0xc,%esp
  8024bf:	5e                   	pop    %esi
  8024c0:	5f                   	pop    %edi
  8024c1:	5d                   	pop    %ebp
  8024c2:	c3                   	ret    
  8024c3:	90                   	nop
  8024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	89 f8                	mov    %edi,%eax
  8024ca:	f7 f1                	div    %ecx
  8024cc:	31 d2                	xor    %edx,%edx
  8024ce:	83 c4 0c             	add    $0xc,%esp
  8024d1:	5e                   	pop    %esi
  8024d2:	5f                   	pop    %edi
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    
  8024d5:	8d 76 00             	lea    0x0(%esi),%esi
  8024d8:	89 e9                	mov    %ebp,%ecx
  8024da:	8b 3c 24             	mov    (%esp),%edi
  8024dd:	d3 e0                	shl    %cl,%eax
  8024df:	89 c6                	mov    %eax,%esi
  8024e1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024e6:	29 e8                	sub    %ebp,%eax
  8024e8:	89 c1                	mov    %eax,%ecx
  8024ea:	d3 ef                	shr    %cl,%edi
  8024ec:	89 e9                	mov    %ebp,%ecx
  8024ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024f2:	8b 3c 24             	mov    (%esp),%edi
  8024f5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024f9:	89 d6                	mov    %edx,%esi
  8024fb:	d3 e7                	shl    %cl,%edi
  8024fd:	89 c1                	mov    %eax,%ecx
  8024ff:	89 3c 24             	mov    %edi,(%esp)
  802502:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802506:	d3 ee                	shr    %cl,%esi
  802508:	89 e9                	mov    %ebp,%ecx
  80250a:	d3 e2                	shl    %cl,%edx
  80250c:	89 c1                	mov    %eax,%ecx
  80250e:	d3 ef                	shr    %cl,%edi
  802510:	09 d7                	or     %edx,%edi
  802512:	89 f2                	mov    %esi,%edx
  802514:	89 f8                	mov    %edi,%eax
  802516:	f7 74 24 08          	divl   0x8(%esp)
  80251a:	89 d6                	mov    %edx,%esi
  80251c:	89 c7                	mov    %eax,%edi
  80251e:	f7 24 24             	mull   (%esp)
  802521:	39 d6                	cmp    %edx,%esi
  802523:	89 14 24             	mov    %edx,(%esp)
  802526:	72 30                	jb     802558 <__udivdi3+0x118>
  802528:	8b 54 24 04          	mov    0x4(%esp),%edx
  80252c:	89 e9                	mov    %ebp,%ecx
  80252e:	d3 e2                	shl    %cl,%edx
  802530:	39 c2                	cmp    %eax,%edx
  802532:	73 05                	jae    802539 <__udivdi3+0xf9>
  802534:	3b 34 24             	cmp    (%esp),%esi
  802537:	74 1f                	je     802558 <__udivdi3+0x118>
  802539:	89 f8                	mov    %edi,%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	e9 7a ff ff ff       	jmp    8024bc <__udivdi3+0x7c>
  802542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802548:	31 d2                	xor    %edx,%edx
  80254a:	b8 01 00 00 00       	mov    $0x1,%eax
  80254f:	e9 68 ff ff ff       	jmp    8024bc <__udivdi3+0x7c>
  802554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802558:	8d 47 ff             	lea    -0x1(%edi),%eax
  80255b:	31 d2                	xor    %edx,%edx
  80255d:	83 c4 0c             	add    $0xc,%esp
  802560:	5e                   	pop    %esi
  802561:	5f                   	pop    %edi
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    
  802564:	66 90                	xchg   %ax,%ax
  802566:	66 90                	xchg   %ax,%ax
  802568:	66 90                	xchg   %ax,%ax
  80256a:	66 90                	xchg   %ax,%ax
  80256c:	66 90                	xchg   %ax,%ax
  80256e:	66 90                	xchg   %ax,%ax

00802570 <__umoddi3>:
  802570:	55                   	push   %ebp
  802571:	57                   	push   %edi
  802572:	56                   	push   %esi
  802573:	83 ec 14             	sub    $0x14,%esp
  802576:	8b 44 24 28          	mov    0x28(%esp),%eax
  80257a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80257e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802582:	89 c7                	mov    %eax,%edi
  802584:	89 44 24 04          	mov    %eax,0x4(%esp)
  802588:	8b 44 24 30          	mov    0x30(%esp),%eax
  80258c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802590:	89 34 24             	mov    %esi,(%esp)
  802593:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802597:	85 c0                	test   %eax,%eax
  802599:	89 c2                	mov    %eax,%edx
  80259b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80259f:	75 17                	jne    8025b8 <__umoddi3+0x48>
  8025a1:	39 fe                	cmp    %edi,%esi
  8025a3:	76 4b                	jbe    8025f0 <__umoddi3+0x80>
  8025a5:	89 c8                	mov    %ecx,%eax
  8025a7:	89 fa                	mov    %edi,%edx
  8025a9:	f7 f6                	div    %esi
  8025ab:	89 d0                	mov    %edx,%eax
  8025ad:	31 d2                	xor    %edx,%edx
  8025af:	83 c4 14             	add    $0x14,%esp
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    
  8025b6:	66 90                	xchg   %ax,%ax
  8025b8:	39 f8                	cmp    %edi,%eax
  8025ba:	77 54                	ja     802610 <__umoddi3+0xa0>
  8025bc:	0f bd e8             	bsr    %eax,%ebp
  8025bf:	83 f5 1f             	xor    $0x1f,%ebp
  8025c2:	75 5c                	jne    802620 <__umoddi3+0xb0>
  8025c4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025c8:	39 3c 24             	cmp    %edi,(%esp)
  8025cb:	0f 87 e7 00 00 00    	ja     8026b8 <__umoddi3+0x148>
  8025d1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025d5:	29 f1                	sub    %esi,%ecx
  8025d7:	19 c7                	sbb    %eax,%edi
  8025d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025e1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025e5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025e9:	83 c4 14             	add    $0x14,%esp
  8025ec:	5e                   	pop    %esi
  8025ed:	5f                   	pop    %edi
  8025ee:	5d                   	pop    %ebp
  8025ef:	c3                   	ret    
  8025f0:	85 f6                	test   %esi,%esi
  8025f2:	89 f5                	mov    %esi,%ebp
  8025f4:	75 0b                	jne    802601 <__umoddi3+0x91>
  8025f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025fb:	31 d2                	xor    %edx,%edx
  8025fd:	f7 f6                	div    %esi
  8025ff:	89 c5                	mov    %eax,%ebp
  802601:	8b 44 24 04          	mov    0x4(%esp),%eax
  802605:	31 d2                	xor    %edx,%edx
  802607:	f7 f5                	div    %ebp
  802609:	89 c8                	mov    %ecx,%eax
  80260b:	f7 f5                	div    %ebp
  80260d:	eb 9c                	jmp    8025ab <__umoddi3+0x3b>
  80260f:	90                   	nop
  802610:	89 c8                	mov    %ecx,%eax
  802612:	89 fa                	mov    %edi,%edx
  802614:	83 c4 14             	add    $0x14,%esp
  802617:	5e                   	pop    %esi
  802618:	5f                   	pop    %edi
  802619:	5d                   	pop    %ebp
  80261a:	c3                   	ret    
  80261b:	90                   	nop
  80261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802620:	8b 04 24             	mov    (%esp),%eax
  802623:	be 20 00 00 00       	mov    $0x20,%esi
  802628:	89 e9                	mov    %ebp,%ecx
  80262a:	29 ee                	sub    %ebp,%esi
  80262c:	d3 e2                	shl    %cl,%edx
  80262e:	89 f1                	mov    %esi,%ecx
  802630:	d3 e8                	shr    %cl,%eax
  802632:	89 e9                	mov    %ebp,%ecx
  802634:	89 44 24 04          	mov    %eax,0x4(%esp)
  802638:	8b 04 24             	mov    (%esp),%eax
  80263b:	09 54 24 04          	or     %edx,0x4(%esp)
  80263f:	89 fa                	mov    %edi,%edx
  802641:	d3 e0                	shl    %cl,%eax
  802643:	89 f1                	mov    %esi,%ecx
  802645:	89 44 24 08          	mov    %eax,0x8(%esp)
  802649:	8b 44 24 10          	mov    0x10(%esp),%eax
  80264d:	d3 ea                	shr    %cl,%edx
  80264f:	89 e9                	mov    %ebp,%ecx
  802651:	d3 e7                	shl    %cl,%edi
  802653:	89 f1                	mov    %esi,%ecx
  802655:	d3 e8                	shr    %cl,%eax
  802657:	89 e9                	mov    %ebp,%ecx
  802659:	09 f8                	or     %edi,%eax
  80265b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80265f:	f7 74 24 04          	divl   0x4(%esp)
  802663:	d3 e7                	shl    %cl,%edi
  802665:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802669:	89 d7                	mov    %edx,%edi
  80266b:	f7 64 24 08          	mull   0x8(%esp)
  80266f:	39 d7                	cmp    %edx,%edi
  802671:	89 c1                	mov    %eax,%ecx
  802673:	89 14 24             	mov    %edx,(%esp)
  802676:	72 2c                	jb     8026a4 <__umoddi3+0x134>
  802678:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80267c:	72 22                	jb     8026a0 <__umoddi3+0x130>
  80267e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802682:	29 c8                	sub    %ecx,%eax
  802684:	19 d7                	sbb    %edx,%edi
  802686:	89 e9                	mov    %ebp,%ecx
  802688:	89 fa                	mov    %edi,%edx
  80268a:	d3 e8                	shr    %cl,%eax
  80268c:	89 f1                	mov    %esi,%ecx
  80268e:	d3 e2                	shl    %cl,%edx
  802690:	89 e9                	mov    %ebp,%ecx
  802692:	d3 ef                	shr    %cl,%edi
  802694:	09 d0                	or     %edx,%eax
  802696:	89 fa                	mov    %edi,%edx
  802698:	83 c4 14             	add    $0x14,%esp
  80269b:	5e                   	pop    %esi
  80269c:	5f                   	pop    %edi
  80269d:	5d                   	pop    %ebp
  80269e:	c3                   	ret    
  80269f:	90                   	nop
  8026a0:	39 d7                	cmp    %edx,%edi
  8026a2:	75 da                	jne    80267e <__umoddi3+0x10e>
  8026a4:	8b 14 24             	mov    (%esp),%edx
  8026a7:	89 c1                	mov    %eax,%ecx
  8026a9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026ad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026b1:	eb cb                	jmp    80267e <__umoddi3+0x10e>
  8026b3:	90                   	nop
  8026b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026b8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026bc:	0f 82 0f ff ff ff    	jb     8025d1 <__umoddi3+0x61>
  8026c2:	e9 1a ff ff ff       	jmp    8025e1 <__umoddi3+0x71>
