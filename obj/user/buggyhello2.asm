
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 1f 00 00 00       	call   800050 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_cputs(hello, 1024*1024);
  800039:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  800040:	00 
  800041:	a1 00 30 80 00       	mov    0x803000,%eax
  800046:	89 04 24             	mov    %eax,(%esp)
  800049:	e8 63 00 00 00       	call   8000b1 <sys_cputs>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	56                   	push   %esi
  800054:	53                   	push   %ebx
  800055:	83 ec 10             	sub    $0x10,%esp
  800058:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  80005e:	e8 2f 01 00 00       	call   800192 <sys_getenvid>
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800075:	85 db                	test   %ebx,%ebx
  800077:	7e 07                	jle    800080 <libmain+0x30>
		binaryname = argv[0];
  800079:	8b 06                	mov    (%esi),%eax
  80007b:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800080:	89 74 24 04          	mov    %esi,0x4(%esp)
  800084:	89 1c 24             	mov    %ebx,(%esp)
  800087:	e8 a7 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008c:	e8 07 00 00 00       	call   800098 <exit>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	5b                   	pop    %ebx
  800095:	5e                   	pop    %esi
  800096:	5d                   	pop    %ebp
  800097:	c3                   	ret    

00800098 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800098:	55                   	push   %ebp
  800099:	89 e5                	mov    %esp,%ebp
  80009b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80009e:	e8 17 06 00 00       	call   8006ba <close_all>
	sys_env_destroy(0);
  8000a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000aa:	e8 3f 00 00 00       	call   8000ee <sys_env_destroy>
}
  8000af:	c9                   	leave  
  8000b0:	c3                   	ret    

008000b1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b1:	55                   	push   %ebp
  8000b2:	89 e5                	mov    %esp,%ebp
  8000b4:	57                   	push   %edi
  8000b5:	56                   	push   %esi
  8000b6:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c2:	89 c3                	mov    %eax,%ebx
  8000c4:	89 c7                	mov    %eax,%edi
  8000c6:	89 c6                	mov    %eax,%esi
  8000c8:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ca:	5b                   	pop    %ebx
  8000cb:	5e                   	pop    %esi
  8000cc:	5f                   	pop    %edi
  8000cd:	5d                   	pop    %ebp
  8000ce:	c3                   	ret    

008000cf <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	57                   	push   %edi
  8000d3:	56                   	push   %esi
  8000d4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000da:	b8 01 00 00 00       	mov    $0x1,%eax
  8000df:	89 d1                	mov    %edx,%ecx
  8000e1:	89 d3                	mov    %edx,%ebx
  8000e3:	89 d7                	mov    %edx,%edi
  8000e5:	89 d6                	mov    %edx,%esi
  8000e7:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e9:	5b                   	pop    %ebx
  8000ea:	5e                   	pop    %esi
  8000eb:	5f                   	pop    %edi
  8000ec:	5d                   	pop    %ebp
  8000ed:	c3                   	ret    

008000ee <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ee:	55                   	push   %ebp
  8000ef:	89 e5                	mov    %esp,%ebp
  8000f1:	57                   	push   %edi
  8000f2:	56                   	push   %esi
  8000f3:	53                   	push   %ebx
  8000f4:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000fc:	b8 03 00 00 00       	mov    $0x3,%eax
  800101:	8b 55 08             	mov    0x8(%ebp),%edx
  800104:	89 cb                	mov    %ecx,%ebx
  800106:	89 cf                	mov    %ecx,%edi
  800108:	89 ce                	mov    %ecx,%esi
  80010a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80010c:	85 c0                	test   %eax,%eax
  80010e:	7e 28                	jle    800138 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800110:	89 44 24 10          	mov    %eax,0x10(%esp)
  800114:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80011b:	00 
  80011c:	c7 44 24 08 f8 26 80 	movl   $0x8026f8,0x8(%esp)
  800123:	00 
  800124:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80012b:	00 
  80012c:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  800133:	e8 fe 16 00 00       	call   801836 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800138:	83 c4 2c             	add    $0x2c,%esp
  80013b:	5b                   	pop    %ebx
  80013c:	5e                   	pop    %esi
  80013d:	5f                   	pop    %edi
  80013e:	5d                   	pop    %ebp
  80013f:	c3                   	ret    

00800140 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	57                   	push   %edi
  800144:	56                   	push   %esi
  800145:	53                   	push   %ebx
  800146:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800149:	b9 00 00 00 00       	mov    $0x0,%ecx
  80014e:	b8 04 00 00 00       	mov    $0x4,%eax
  800153:	8b 55 08             	mov    0x8(%ebp),%edx
  800156:	89 cb                	mov    %ecx,%ebx
  800158:	89 cf                	mov    %ecx,%edi
  80015a:	89 ce                	mov    %ecx,%esi
  80015c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80015e:	85 c0                	test   %eax,%eax
  800160:	7e 28                	jle    80018a <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800162:	89 44 24 10          	mov    %eax,0x10(%esp)
  800166:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80016d:	00 
  80016e:	c7 44 24 08 f8 26 80 	movl   $0x8026f8,0x8(%esp)
  800175:	00 
  800176:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80017d:	00 
  80017e:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  800185:	e8 ac 16 00 00       	call   801836 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  80018a:	83 c4 2c             	add    $0x2c,%esp
  80018d:	5b                   	pop    %ebx
  80018e:	5e                   	pop    %esi
  80018f:	5f                   	pop    %edi
  800190:	5d                   	pop    %ebp
  800191:	c3                   	ret    

00800192 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	57                   	push   %edi
  800196:	56                   	push   %esi
  800197:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800198:	ba 00 00 00 00       	mov    $0x0,%edx
  80019d:	b8 02 00 00 00       	mov    $0x2,%eax
  8001a2:	89 d1                	mov    %edx,%ecx
  8001a4:	89 d3                	mov    %edx,%ebx
  8001a6:	89 d7                	mov    %edx,%edi
  8001a8:	89 d6                	mov    %edx,%esi
  8001aa:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001ac:	5b                   	pop    %ebx
  8001ad:	5e                   	pop    %esi
  8001ae:	5f                   	pop    %edi
  8001af:	5d                   	pop    %ebp
  8001b0:	c3                   	ret    

008001b1 <sys_yield>:

void
sys_yield(void)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	57                   	push   %edi
  8001b5:	56                   	push   %esi
  8001b6:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bc:	b8 0c 00 00 00       	mov    $0xc,%eax
  8001c1:	89 d1                	mov    %edx,%ecx
  8001c3:	89 d3                	mov    %edx,%ebx
  8001c5:	89 d7                	mov    %edx,%edi
  8001c7:	89 d6                	mov    %edx,%esi
  8001c9:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001cb:	5b                   	pop    %ebx
  8001cc:	5e                   	pop    %esi
  8001cd:	5f                   	pop    %edi
  8001ce:	5d                   	pop    %ebp
  8001cf:	c3                   	ret    

008001d0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	57                   	push   %edi
  8001d4:	56                   	push   %esi
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001d9:	be 00 00 00 00       	mov    $0x0,%esi
  8001de:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ec:	89 f7                	mov    %esi,%edi
  8001ee:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001f0:	85 c0                	test   %eax,%eax
  8001f2:	7e 28                	jle    80021c <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001f8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8001ff:	00 
  800200:	c7 44 24 08 f8 26 80 	movl   $0x8026f8,0x8(%esp)
  800207:	00 
  800208:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80020f:	00 
  800210:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  800217:	e8 1a 16 00 00       	call   801836 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80021c:	83 c4 2c             	add    $0x2c,%esp
  80021f:	5b                   	pop    %ebx
  800220:	5e                   	pop    %esi
  800221:	5f                   	pop    %edi
  800222:	5d                   	pop    %ebp
  800223:	c3                   	ret    

00800224 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	57                   	push   %edi
  800228:	56                   	push   %esi
  800229:	53                   	push   %ebx
  80022a:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80022d:	b8 06 00 00 00       	mov    $0x6,%eax
  800232:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800235:	8b 55 08             	mov    0x8(%ebp),%edx
  800238:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80023b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80023e:	8b 75 18             	mov    0x18(%ebp),%esi
  800241:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800243:	85 c0                	test   %eax,%eax
  800245:	7e 28                	jle    80026f <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800247:	89 44 24 10          	mov    %eax,0x10(%esp)
  80024b:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800252:	00 
  800253:	c7 44 24 08 f8 26 80 	movl   $0x8026f8,0x8(%esp)
  80025a:	00 
  80025b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800262:	00 
  800263:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  80026a:	e8 c7 15 00 00       	call   801836 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80026f:	83 c4 2c             	add    $0x2c,%esp
  800272:	5b                   	pop    %ebx
  800273:	5e                   	pop    %esi
  800274:	5f                   	pop    %edi
  800275:	5d                   	pop    %ebp
  800276:	c3                   	ret    

00800277 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	57                   	push   %edi
  80027b:	56                   	push   %esi
  80027c:	53                   	push   %ebx
  80027d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800280:	bb 00 00 00 00       	mov    $0x0,%ebx
  800285:	b8 07 00 00 00       	mov    $0x7,%eax
  80028a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80028d:	8b 55 08             	mov    0x8(%ebp),%edx
  800290:	89 df                	mov    %ebx,%edi
  800292:	89 de                	mov    %ebx,%esi
  800294:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800296:	85 c0                	test   %eax,%eax
  800298:	7e 28                	jle    8002c2 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80029a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80029e:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8002a5:	00 
  8002a6:	c7 44 24 08 f8 26 80 	movl   $0x8026f8,0x8(%esp)
  8002ad:	00 
  8002ae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002b5:	00 
  8002b6:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  8002bd:	e8 74 15 00 00       	call   801836 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8002c2:	83 c4 2c             	add    $0x2c,%esp
  8002c5:	5b                   	pop    %ebx
  8002c6:	5e                   	pop    %esi
  8002c7:	5f                   	pop    %edi
  8002c8:	5d                   	pop    %ebp
  8002c9:	c3                   	ret    

008002ca <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	57                   	push   %edi
  8002ce:	56                   	push   %esi
  8002cf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d5:	b8 10 00 00 00       	mov    $0x10,%eax
  8002da:	8b 55 08             	mov    0x8(%ebp),%edx
  8002dd:	89 cb                	mov    %ecx,%ebx
  8002df:	89 cf                	mov    %ecx,%edi
  8002e1:	89 ce                	mov    %ecx,%esi
  8002e3:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  8002e5:	5b                   	pop    %ebx
  8002e6:	5e                   	pop    %esi
  8002e7:	5f                   	pop    %edi
  8002e8:	5d                   	pop    %ebp
  8002e9:	c3                   	ret    

008002ea <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	57                   	push   %edi
  8002ee:	56                   	push   %esi
  8002ef:	53                   	push   %ebx
  8002f0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f8:	b8 09 00 00 00       	mov    $0x9,%eax
  8002fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800300:	8b 55 08             	mov    0x8(%ebp),%edx
  800303:	89 df                	mov    %ebx,%edi
  800305:	89 de                	mov    %ebx,%esi
  800307:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800309:	85 c0                	test   %eax,%eax
  80030b:	7e 28                	jle    800335 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80030d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800311:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800318:	00 
  800319:	c7 44 24 08 f8 26 80 	movl   $0x8026f8,0x8(%esp)
  800320:	00 
  800321:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800328:	00 
  800329:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  800330:	e8 01 15 00 00       	call   801836 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800335:	83 c4 2c             	add    $0x2c,%esp
  800338:	5b                   	pop    %ebx
  800339:	5e                   	pop    %esi
  80033a:	5f                   	pop    %edi
  80033b:	5d                   	pop    %ebp
  80033c:	c3                   	ret    

0080033d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	57                   	push   %edi
  800341:	56                   	push   %esi
  800342:	53                   	push   %ebx
  800343:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800346:	bb 00 00 00 00       	mov    $0x0,%ebx
  80034b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800350:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800353:	8b 55 08             	mov    0x8(%ebp),%edx
  800356:	89 df                	mov    %ebx,%edi
  800358:	89 de                	mov    %ebx,%esi
  80035a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80035c:	85 c0                	test   %eax,%eax
  80035e:	7e 28                	jle    800388 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800360:	89 44 24 10          	mov    %eax,0x10(%esp)
  800364:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80036b:	00 
  80036c:	c7 44 24 08 f8 26 80 	movl   $0x8026f8,0x8(%esp)
  800373:	00 
  800374:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80037b:	00 
  80037c:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  800383:	e8 ae 14 00 00       	call   801836 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800388:	83 c4 2c             	add    $0x2c,%esp
  80038b:	5b                   	pop    %ebx
  80038c:	5e                   	pop    %esi
  80038d:	5f                   	pop    %edi
  80038e:	5d                   	pop    %ebp
  80038f:	c3                   	ret    

00800390 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	57                   	push   %edi
  800394:	56                   	push   %esi
  800395:	53                   	push   %ebx
  800396:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800399:	bb 00 00 00 00       	mov    $0x0,%ebx
  80039e:	b8 0b 00 00 00       	mov    $0xb,%eax
  8003a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a9:	89 df                	mov    %ebx,%edi
  8003ab:	89 de                	mov    %ebx,%esi
  8003ad:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	7e 28                	jle    8003db <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003b7:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8003be:	00 
  8003bf:	c7 44 24 08 f8 26 80 	movl   $0x8026f8,0x8(%esp)
  8003c6:	00 
  8003c7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003ce:	00 
  8003cf:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  8003d6:	e8 5b 14 00 00       	call   801836 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8003db:	83 c4 2c             	add    $0x2c,%esp
  8003de:	5b                   	pop    %ebx
  8003df:	5e                   	pop    %esi
  8003e0:	5f                   	pop    %edi
  8003e1:	5d                   	pop    %ebp
  8003e2:	c3                   	ret    

008003e3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	57                   	push   %edi
  8003e7:	56                   	push   %esi
  8003e8:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003e9:	be 00 00 00 00       	mov    $0x0,%esi
  8003ee:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8003f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003fc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003ff:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800401:	5b                   	pop    %ebx
  800402:	5e                   	pop    %esi
  800403:	5f                   	pop    %edi
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	57                   	push   %edi
  80040a:	56                   	push   %esi
  80040b:	53                   	push   %ebx
  80040c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80040f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800414:	b8 0e 00 00 00       	mov    $0xe,%eax
  800419:	8b 55 08             	mov    0x8(%ebp),%edx
  80041c:	89 cb                	mov    %ecx,%ebx
  80041e:	89 cf                	mov    %ecx,%edi
  800420:	89 ce                	mov    %ecx,%esi
  800422:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800424:	85 c0                	test   %eax,%eax
  800426:	7e 28                	jle    800450 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800428:	89 44 24 10          	mov    %eax,0x10(%esp)
  80042c:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800433:	00 
  800434:	c7 44 24 08 f8 26 80 	movl   $0x8026f8,0x8(%esp)
  80043b:	00 
  80043c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800443:	00 
  800444:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  80044b:	e8 e6 13 00 00       	call   801836 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800450:	83 c4 2c             	add    $0x2c,%esp
  800453:	5b                   	pop    %ebx
  800454:	5e                   	pop    %esi
  800455:	5f                   	pop    %edi
  800456:	5d                   	pop    %ebp
  800457:	c3                   	ret    

00800458 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	57                   	push   %edi
  80045c:	56                   	push   %esi
  80045d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80045e:	ba 00 00 00 00       	mov    $0x0,%edx
  800463:	b8 0f 00 00 00       	mov    $0xf,%eax
  800468:	89 d1                	mov    %edx,%ecx
  80046a:	89 d3                	mov    %edx,%ebx
  80046c:	89 d7                	mov    %edx,%edi
  80046e:	89 d6                	mov    %edx,%esi
  800470:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800472:	5b                   	pop    %ebx
  800473:	5e                   	pop    %esi
  800474:	5f                   	pop    %edi
  800475:	5d                   	pop    %ebp
  800476:	c3                   	ret    

00800477 <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	57                   	push   %edi
  80047b:	56                   	push   %esi
  80047c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80047d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800482:	b8 11 00 00 00       	mov    $0x11,%eax
  800487:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80048a:	8b 55 08             	mov    0x8(%ebp),%edx
  80048d:	89 df                	mov    %ebx,%edi
  80048f:	89 de                	mov    %ebx,%esi
  800491:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  800493:	5b                   	pop    %ebx
  800494:	5e                   	pop    %esi
  800495:	5f                   	pop    %edi
  800496:	5d                   	pop    %ebp
  800497:	c3                   	ret    

00800498 <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	57                   	push   %edi
  80049c:	56                   	push   %esi
  80049d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80049e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004a3:	b8 12 00 00 00       	mov    $0x12,%eax
  8004a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ae:	89 df                	mov    %ebx,%edi
  8004b0:	89 de                	mov    %ebx,%esi
  8004b2:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8004b4:	5b                   	pop    %ebx
  8004b5:	5e                   	pop    %esi
  8004b6:	5f                   	pop    %edi
  8004b7:	5d                   	pop    %ebp
  8004b8:	c3                   	ret    

008004b9 <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	57                   	push   %edi
  8004bd:	56                   	push   %esi
  8004be:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004c4:	b8 13 00 00 00       	mov    $0x13,%eax
  8004c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004cc:	89 cb                	mov    %ecx,%ebx
  8004ce:	89 cf                	mov    %ecx,%edi
  8004d0:	89 ce                	mov    %ecx,%esi
  8004d2:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  8004d4:	5b                   	pop    %ebx
  8004d5:	5e                   	pop    %esi
  8004d6:	5f                   	pop    %edi
  8004d7:	5d                   	pop    %ebp
  8004d8:	c3                   	ret    
  8004d9:	66 90                	xchg   %ax,%ax
  8004db:	66 90                	xchg   %ax,%ax
  8004dd:	66 90                	xchg   %ax,%ax
  8004df:	90                   	nop

008004e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8004eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8004ee:	5d                   	pop    %ebp
  8004ef:	c3                   	ret    

008004f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8004fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800500:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800505:	5d                   	pop    %ebp
  800506:	c3                   	ret    

00800507 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800507:	55                   	push   %ebp
  800508:	89 e5                	mov    %esp,%ebp
  80050a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80050d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800512:	89 c2                	mov    %eax,%edx
  800514:	c1 ea 16             	shr    $0x16,%edx
  800517:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80051e:	f6 c2 01             	test   $0x1,%dl
  800521:	74 11                	je     800534 <fd_alloc+0x2d>
  800523:	89 c2                	mov    %eax,%edx
  800525:	c1 ea 0c             	shr    $0xc,%edx
  800528:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80052f:	f6 c2 01             	test   $0x1,%dl
  800532:	75 09                	jne    80053d <fd_alloc+0x36>
			*fd_store = fd;
  800534:	89 01                	mov    %eax,(%ecx)
			return 0;
  800536:	b8 00 00 00 00       	mov    $0x0,%eax
  80053b:	eb 17                	jmp    800554 <fd_alloc+0x4d>
  80053d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800542:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800547:	75 c9                	jne    800512 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800549:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80054f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80055c:	83 f8 1f             	cmp    $0x1f,%eax
  80055f:	77 36                	ja     800597 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800561:	c1 e0 0c             	shl    $0xc,%eax
  800564:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800569:	89 c2                	mov    %eax,%edx
  80056b:	c1 ea 16             	shr    $0x16,%edx
  80056e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800575:	f6 c2 01             	test   $0x1,%dl
  800578:	74 24                	je     80059e <fd_lookup+0x48>
  80057a:	89 c2                	mov    %eax,%edx
  80057c:	c1 ea 0c             	shr    $0xc,%edx
  80057f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800586:	f6 c2 01             	test   $0x1,%dl
  800589:	74 1a                	je     8005a5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80058b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058e:	89 02                	mov    %eax,(%edx)
	return 0;
  800590:	b8 00 00 00 00       	mov    $0x0,%eax
  800595:	eb 13                	jmp    8005aa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800597:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80059c:	eb 0c                	jmp    8005aa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80059e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8005a3:	eb 05                	jmp    8005aa <fd_lookup+0x54>
  8005a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8005aa:	5d                   	pop    %ebp
  8005ab:	c3                   	ret    

008005ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	83 ec 18             	sub    $0x18,%esp
  8005b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8005b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ba:	eb 13                	jmp    8005cf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8005bc:	39 08                	cmp    %ecx,(%eax)
  8005be:	75 0c                	jne    8005cc <dev_lookup+0x20>
			*dev = devtab[i];
  8005c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8005c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ca:	eb 38                	jmp    800604 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005cc:	83 c2 01             	add    $0x1,%edx
  8005cf:	8b 04 95 a0 27 80 00 	mov    0x8027a0(,%edx,4),%eax
  8005d6:	85 c0                	test   %eax,%eax
  8005d8:	75 e2                	jne    8005bc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005da:	a1 08 40 80 00       	mov    0x804008,%eax
  8005df:	8b 40 48             	mov    0x48(%eax),%eax
  8005e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ea:	c7 04 24 24 27 80 00 	movl   $0x802724,(%esp)
  8005f1:	e8 39 13 00 00       	call   80192f <cprintf>
	*dev = 0;
  8005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8005ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800604:	c9                   	leave  
  800605:	c3                   	ret    

00800606 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800606:	55                   	push   %ebp
  800607:	89 e5                	mov    %esp,%ebp
  800609:	56                   	push   %esi
  80060a:	53                   	push   %ebx
  80060b:	83 ec 20             	sub    $0x20,%esp
  80060e:	8b 75 08             	mov    0x8(%ebp),%esi
  800611:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800614:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800617:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80061b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800621:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800624:	89 04 24             	mov    %eax,(%esp)
  800627:	e8 2a ff ff ff       	call   800556 <fd_lookup>
  80062c:	85 c0                	test   %eax,%eax
  80062e:	78 05                	js     800635 <fd_close+0x2f>
	    || fd != fd2)
  800630:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800633:	74 0c                	je     800641 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800635:	84 db                	test   %bl,%bl
  800637:	ba 00 00 00 00       	mov    $0x0,%edx
  80063c:	0f 44 c2             	cmove  %edx,%eax
  80063f:	eb 3f                	jmp    800680 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800641:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800644:	89 44 24 04          	mov    %eax,0x4(%esp)
  800648:	8b 06                	mov    (%esi),%eax
  80064a:	89 04 24             	mov    %eax,(%esp)
  80064d:	e8 5a ff ff ff       	call   8005ac <dev_lookup>
  800652:	89 c3                	mov    %eax,%ebx
  800654:	85 c0                	test   %eax,%eax
  800656:	78 16                	js     80066e <fd_close+0x68>
		if (dev->dev_close)
  800658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80065b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80065e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800663:	85 c0                	test   %eax,%eax
  800665:	74 07                	je     80066e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800667:	89 34 24             	mov    %esi,(%esp)
  80066a:	ff d0                	call   *%eax
  80066c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80066e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800672:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800679:	e8 f9 fb ff ff       	call   800277 <sys_page_unmap>
	return r;
  80067e:	89 d8                	mov    %ebx,%eax
}
  800680:	83 c4 20             	add    $0x20,%esp
  800683:	5b                   	pop    %ebx
  800684:	5e                   	pop    %esi
  800685:	5d                   	pop    %ebp
  800686:	c3                   	ret    

00800687 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800687:	55                   	push   %ebp
  800688:	89 e5                	mov    %esp,%ebp
  80068a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80068d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800690:	89 44 24 04          	mov    %eax,0x4(%esp)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	89 04 24             	mov    %eax,(%esp)
  80069a:	e8 b7 fe ff ff       	call   800556 <fd_lookup>
  80069f:	89 c2                	mov    %eax,%edx
  8006a1:	85 d2                	test   %edx,%edx
  8006a3:	78 13                	js     8006b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8006a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8006ac:	00 
  8006ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b0:	89 04 24             	mov    %eax,(%esp)
  8006b3:	e8 4e ff ff ff       	call   800606 <fd_close>
}
  8006b8:	c9                   	leave  
  8006b9:	c3                   	ret    

008006ba <close_all>:

void
close_all(void)
{
  8006ba:	55                   	push   %ebp
  8006bb:	89 e5                	mov    %esp,%ebp
  8006bd:	53                   	push   %ebx
  8006be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006c6:	89 1c 24             	mov    %ebx,(%esp)
  8006c9:	e8 b9 ff ff ff       	call   800687 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006ce:	83 c3 01             	add    $0x1,%ebx
  8006d1:	83 fb 20             	cmp    $0x20,%ebx
  8006d4:	75 f0                	jne    8006c6 <close_all+0xc>
		close(i);
}
  8006d6:	83 c4 14             	add    $0x14,%esp
  8006d9:	5b                   	pop    %ebx
  8006da:	5d                   	pop    %ebp
  8006db:	c3                   	ret    

008006dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	57                   	push   %edi
  8006e0:	56                   	push   %esi
  8006e1:	53                   	push   %ebx
  8006e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	89 04 24             	mov    %eax,(%esp)
  8006f2:	e8 5f fe ff ff       	call   800556 <fd_lookup>
  8006f7:	89 c2                	mov    %eax,%edx
  8006f9:	85 d2                	test   %edx,%edx
  8006fb:	0f 88 e1 00 00 00    	js     8007e2 <dup+0x106>
		return r;
	close(newfdnum);
  800701:	8b 45 0c             	mov    0xc(%ebp),%eax
  800704:	89 04 24             	mov    %eax,(%esp)
  800707:	e8 7b ff ff ff       	call   800687 <close>

	newfd = INDEX2FD(newfdnum);
  80070c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80070f:	c1 e3 0c             	shl    $0xc,%ebx
  800712:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80071b:	89 04 24             	mov    %eax,(%esp)
  80071e:	e8 cd fd ff ff       	call   8004f0 <fd2data>
  800723:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800725:	89 1c 24             	mov    %ebx,(%esp)
  800728:	e8 c3 fd ff ff       	call   8004f0 <fd2data>
  80072d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80072f:	89 f0                	mov    %esi,%eax
  800731:	c1 e8 16             	shr    $0x16,%eax
  800734:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80073b:	a8 01                	test   $0x1,%al
  80073d:	74 43                	je     800782 <dup+0xa6>
  80073f:	89 f0                	mov    %esi,%eax
  800741:	c1 e8 0c             	shr    $0xc,%eax
  800744:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80074b:	f6 c2 01             	test   $0x1,%dl
  80074e:	74 32                	je     800782 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800750:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800757:	25 07 0e 00 00       	and    $0xe07,%eax
  80075c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800760:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800764:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80076b:	00 
  80076c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800770:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800777:	e8 a8 fa ff ff       	call   800224 <sys_page_map>
  80077c:	89 c6                	mov    %eax,%esi
  80077e:	85 c0                	test   %eax,%eax
  800780:	78 3e                	js     8007c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800785:	89 c2                	mov    %eax,%edx
  800787:	c1 ea 0c             	shr    $0xc,%edx
  80078a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800791:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800797:	89 54 24 10          	mov    %edx,0x10(%esp)
  80079b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80079f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007a6:	00 
  8007a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007b2:	e8 6d fa ff ff       	call   800224 <sys_page_map>
  8007b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8007bc:	85 f6                	test   %esi,%esi
  8007be:	79 22                	jns    8007e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007cb:	e8 a7 fa ff ff       	call   800277 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8007d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007db:	e8 97 fa ff ff       	call   800277 <sys_page_unmap>
	return r;
  8007e0:	89 f0                	mov    %esi,%eax
}
  8007e2:	83 c4 3c             	add    $0x3c,%esp
  8007e5:	5b                   	pop    %ebx
  8007e6:	5e                   	pop    %esi
  8007e7:	5f                   	pop    %edi
  8007e8:	5d                   	pop    %ebp
  8007e9:	c3                   	ret    

008007ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	53                   	push   %ebx
  8007ee:	83 ec 24             	sub    $0x24,%esp
  8007f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007fb:	89 1c 24             	mov    %ebx,(%esp)
  8007fe:	e8 53 fd ff ff       	call   800556 <fd_lookup>
  800803:	89 c2                	mov    %eax,%edx
  800805:	85 d2                	test   %edx,%edx
  800807:	78 6d                	js     800876 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800809:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80080c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	89 04 24             	mov    %eax,(%esp)
  800818:	e8 8f fd ff ff       	call   8005ac <dev_lookup>
  80081d:	85 c0                	test   %eax,%eax
  80081f:	78 55                	js     800876 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800824:	8b 50 08             	mov    0x8(%eax),%edx
  800827:	83 e2 03             	and    $0x3,%edx
  80082a:	83 fa 01             	cmp    $0x1,%edx
  80082d:	75 23                	jne    800852 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80082f:	a1 08 40 80 00       	mov    0x804008,%eax
  800834:	8b 40 48             	mov    0x48(%eax),%eax
  800837:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80083b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083f:	c7 04 24 65 27 80 00 	movl   $0x802765,(%esp)
  800846:	e8 e4 10 00 00       	call   80192f <cprintf>
		return -E_INVAL;
  80084b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800850:	eb 24                	jmp    800876 <read+0x8c>
	}
	if (!dev->dev_read)
  800852:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800855:	8b 52 08             	mov    0x8(%edx),%edx
  800858:	85 d2                	test   %edx,%edx
  80085a:	74 15                	je     800871 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80085c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80085f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800863:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800866:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80086a:	89 04 24             	mov    %eax,(%esp)
  80086d:	ff d2                	call   *%edx
  80086f:	eb 05                	jmp    800876 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800871:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800876:	83 c4 24             	add    $0x24,%esp
  800879:	5b                   	pop    %ebx
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	57                   	push   %edi
  800880:	56                   	push   %esi
  800881:	53                   	push   %ebx
  800882:	83 ec 1c             	sub    $0x1c,%esp
  800885:	8b 7d 08             	mov    0x8(%ebp),%edi
  800888:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80088b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800890:	eb 23                	jmp    8008b5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800892:	89 f0                	mov    %esi,%eax
  800894:	29 d8                	sub    %ebx,%eax
  800896:	89 44 24 08          	mov    %eax,0x8(%esp)
  80089a:	89 d8                	mov    %ebx,%eax
  80089c:	03 45 0c             	add    0xc(%ebp),%eax
  80089f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a3:	89 3c 24             	mov    %edi,(%esp)
  8008a6:	e8 3f ff ff ff       	call   8007ea <read>
		if (m < 0)
  8008ab:	85 c0                	test   %eax,%eax
  8008ad:	78 10                	js     8008bf <readn+0x43>
			return m;
		if (m == 0)
  8008af:	85 c0                	test   %eax,%eax
  8008b1:	74 0a                	je     8008bd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008b3:	01 c3                	add    %eax,%ebx
  8008b5:	39 f3                	cmp    %esi,%ebx
  8008b7:	72 d9                	jb     800892 <readn+0x16>
  8008b9:	89 d8                	mov    %ebx,%eax
  8008bb:	eb 02                	jmp    8008bf <readn+0x43>
  8008bd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8008bf:	83 c4 1c             	add    $0x1c,%esp
  8008c2:	5b                   	pop    %ebx
  8008c3:	5e                   	pop    %esi
  8008c4:	5f                   	pop    %edi
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	53                   	push   %ebx
  8008cb:	83 ec 24             	sub    $0x24,%esp
  8008ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d8:	89 1c 24             	mov    %ebx,(%esp)
  8008db:	e8 76 fc ff ff       	call   800556 <fd_lookup>
  8008e0:	89 c2                	mov    %eax,%edx
  8008e2:	85 d2                	test   %edx,%edx
  8008e4:	78 68                	js     80094e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	89 04 24             	mov    %eax,(%esp)
  8008f5:	e8 b2 fc ff ff       	call   8005ac <dev_lookup>
  8008fa:	85 c0                	test   %eax,%eax
  8008fc:	78 50                	js     80094e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800901:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800905:	75 23                	jne    80092a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800907:	a1 08 40 80 00       	mov    0x804008,%eax
  80090c:	8b 40 48             	mov    0x48(%eax),%eax
  80090f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800913:	89 44 24 04          	mov    %eax,0x4(%esp)
  800917:	c7 04 24 81 27 80 00 	movl   $0x802781,(%esp)
  80091e:	e8 0c 10 00 00       	call   80192f <cprintf>
		return -E_INVAL;
  800923:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800928:	eb 24                	jmp    80094e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80092d:	8b 52 0c             	mov    0xc(%edx),%edx
  800930:	85 d2                	test   %edx,%edx
  800932:	74 15                	je     800949 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800934:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800937:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80093b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800942:	89 04 24             	mov    %eax,(%esp)
  800945:	ff d2                	call   *%edx
  800947:	eb 05                	jmp    80094e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800949:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80094e:	83 c4 24             	add    $0x24,%esp
  800951:	5b                   	pop    %ebx
  800952:	5d                   	pop    %ebp
  800953:	c3                   	ret    

00800954 <seek>:

int
seek(int fdnum, off_t offset)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80095a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80095d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	89 04 24             	mov    %eax,(%esp)
  800967:	e8 ea fb ff ff       	call   800556 <fd_lookup>
  80096c:	85 c0                	test   %eax,%eax
  80096e:	78 0e                	js     80097e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800979:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    

00800980 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	53                   	push   %ebx
  800984:	83 ec 24             	sub    $0x24,%esp
  800987:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80098a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80098d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800991:	89 1c 24             	mov    %ebx,(%esp)
  800994:	e8 bd fb ff ff       	call   800556 <fd_lookup>
  800999:	89 c2                	mov    %eax,%edx
  80099b:	85 d2                	test   %edx,%edx
  80099d:	78 61                	js     800a00 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80099f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 00                	mov    (%eax),%eax
  8009ab:	89 04 24             	mov    %eax,(%esp)
  8009ae:	e8 f9 fb ff ff       	call   8005ac <dev_lookup>
  8009b3:	85 c0                	test   %eax,%eax
  8009b5:	78 49                	js     800a00 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009be:	75 23                	jne    8009e3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8009c0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009c5:	8b 40 48             	mov    0x48(%eax),%eax
  8009c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d0:	c7 04 24 44 27 80 00 	movl   $0x802744,(%esp)
  8009d7:	e8 53 0f 00 00       	call   80192f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e1:	eb 1d                	jmp    800a00 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8009e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009e6:	8b 52 18             	mov    0x18(%edx),%edx
  8009e9:	85 d2                	test   %edx,%edx
  8009eb:	74 0e                	je     8009fb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8009ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009f4:	89 04 24             	mov    %eax,(%esp)
  8009f7:	ff d2                	call   *%edx
  8009f9:	eb 05                	jmp    800a00 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8009fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800a00:	83 c4 24             	add    $0x24,%esp
  800a03:	5b                   	pop    %ebx
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	53                   	push   %ebx
  800a0a:	83 ec 24             	sub    $0x24,%esp
  800a0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	89 04 24             	mov    %eax,(%esp)
  800a1d:	e8 34 fb ff ff       	call   800556 <fd_lookup>
  800a22:	89 c2                	mov    %eax,%edx
  800a24:	85 d2                	test   %edx,%edx
  800a26:	78 52                	js     800a7a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8b 00                	mov    (%eax),%eax
  800a34:	89 04 24             	mov    %eax,(%esp)
  800a37:	e8 70 fb ff ff       	call   8005ac <dev_lookup>
  800a3c:	85 c0                	test   %eax,%eax
  800a3e:	78 3a                	js     800a7a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a43:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a47:	74 2c                	je     800a75 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a49:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a4c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a53:	00 00 00 
	stat->st_isdir = 0;
  800a56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a5d:	00 00 00 
	stat->st_dev = dev;
  800a60:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a6d:	89 14 24             	mov    %edx,(%esp)
  800a70:	ff 50 14             	call   *0x14(%eax)
  800a73:	eb 05                	jmp    800a7a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a7a:	83 c4 24             	add    $0x24,%esp
  800a7d:	5b                   	pop    %ebx
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	56                   	push   %esi
  800a84:	53                   	push   %ebx
  800a85:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a8f:	00 
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	89 04 24             	mov    %eax,(%esp)
  800a96:	e8 99 02 00 00       	call   800d34 <open>
  800a9b:	89 c3                	mov    %eax,%ebx
  800a9d:	85 db                	test   %ebx,%ebx
  800a9f:	78 1b                	js     800abc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa8:	89 1c 24             	mov    %ebx,(%esp)
  800aab:	e8 56 ff ff ff       	call   800a06 <fstat>
  800ab0:	89 c6                	mov    %eax,%esi
	close(fd);
  800ab2:	89 1c 24             	mov    %ebx,(%esp)
  800ab5:	e8 cd fb ff ff       	call   800687 <close>
	return r;
  800aba:	89 f0                	mov    %esi,%eax
}
  800abc:	83 c4 10             	add    $0x10,%esp
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    

00800ac3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	56                   	push   %esi
  800ac7:	53                   	push   %ebx
  800ac8:	83 ec 10             	sub    $0x10,%esp
  800acb:	89 c6                	mov    %eax,%esi
  800acd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800acf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ad6:	75 11                	jne    800ae9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ad8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800adf:	e8 eb 18 00 00       	call   8023cf <ipc_find_env>
  800ae4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ae9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800af0:	00 
  800af1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800af8:	00 
  800af9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800afd:	a1 00 40 80 00       	mov    0x804000,%eax
  800b02:	89 04 24             	mov    %eax,(%esp)
  800b05:	e8 5e 18 00 00       	call   802368 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800b0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b11:	00 
  800b12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b1d:	e8 de 17 00 00       	call   802300 <ipc_recv>
}
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	5b                   	pop    %ebx
  800b26:	5e                   	pop    %esi
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 40 0c             	mov    0xc(%eax),%eax
  800b35:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800b42:	ba 00 00 00 00       	mov    $0x0,%edx
  800b47:	b8 02 00 00 00       	mov    $0x2,%eax
  800b4c:	e8 72 ff ff ff       	call   800ac3 <fsipc>
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  800b5f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b64:	ba 00 00 00 00       	mov    $0x0,%edx
  800b69:	b8 06 00 00 00       	mov    $0x6,%eax
  800b6e:	e8 50 ff ff ff       	call   800ac3 <fsipc>
}
  800b73:	c9                   	leave  
  800b74:	c3                   	ret    

00800b75 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	53                   	push   %ebx
  800b79:	83 ec 14             	sub    $0x14,%esp
  800b7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	8b 40 0c             	mov    0xc(%eax),%eax
  800b85:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 05 00 00 00       	mov    $0x5,%eax
  800b94:	e8 2a ff ff ff       	call   800ac3 <fsipc>
  800b99:	89 c2                	mov    %eax,%edx
  800b9b:	85 d2                	test   %edx,%edx
  800b9d:	78 2b                	js     800bca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b9f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800ba6:	00 
  800ba7:	89 1c 24             	mov    %ebx,(%esp)
  800baa:	e8 f8 13 00 00       	call   801fa7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800baf:	a1 80 50 80 00       	mov    0x805080,%eax
  800bb4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800bba:	a1 84 50 80 00       	mov    0x805084,%eax
  800bbf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800bc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bca:	83 c4 14             	add    $0x14,%esp
  800bcd:	5b                   	pop    %ebx
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    

00800bd0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	53                   	push   %ebx
  800bd4:	83 ec 14             	sub    $0x14,%esp
  800bd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  800bda:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  800be0:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  800be5:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800be8:	8b 55 08             	mov    0x8(%ebp),%edx
  800beb:	8b 52 0c             	mov    0xc(%edx),%edx
  800bee:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  800bf4:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  800bf9:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c04:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800c0b:	e8 34 15 00 00       	call   802144 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  800c10:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  800c17:	00 
  800c18:	c7 04 24 b4 27 80 00 	movl   $0x8027b4,(%esp)
  800c1f:	e8 0b 0d 00 00       	call   80192f <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800c24:	ba 00 00 00 00       	mov    $0x0,%edx
  800c29:	b8 04 00 00 00       	mov    $0x4,%eax
  800c2e:	e8 90 fe ff ff       	call   800ac3 <fsipc>
  800c33:	85 c0                	test   %eax,%eax
  800c35:	78 53                	js     800c8a <devfile_write+0xba>
		return r;
	assert(r <= n);
  800c37:	39 c3                	cmp    %eax,%ebx
  800c39:	73 24                	jae    800c5f <devfile_write+0x8f>
  800c3b:	c7 44 24 0c b9 27 80 	movl   $0x8027b9,0xc(%esp)
  800c42:	00 
  800c43:	c7 44 24 08 c0 27 80 	movl   $0x8027c0,0x8(%esp)
  800c4a:	00 
  800c4b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  800c52:	00 
  800c53:	c7 04 24 d5 27 80 00 	movl   $0x8027d5,(%esp)
  800c5a:	e8 d7 0b 00 00       	call   801836 <_panic>
	assert(r <= PGSIZE);
  800c5f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c64:	7e 24                	jle    800c8a <devfile_write+0xba>
  800c66:	c7 44 24 0c e0 27 80 	movl   $0x8027e0,0xc(%esp)
  800c6d:	00 
  800c6e:	c7 44 24 08 c0 27 80 	movl   $0x8027c0,0x8(%esp)
  800c75:	00 
  800c76:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  800c7d:	00 
  800c7e:	c7 04 24 d5 27 80 00 	movl   $0x8027d5,(%esp)
  800c85:	e8 ac 0b 00 00       	call   801836 <_panic>
	return r;
}
  800c8a:	83 c4 14             	add    $0x14,%esp
  800c8d:	5b                   	pop    %ebx
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
  800c95:	83 ec 10             	sub    $0x10,%esp
  800c98:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	8b 40 0c             	mov    0xc(%eax),%eax
  800ca1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ca6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800cac:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb6:	e8 08 fe ff ff       	call   800ac3 <fsipc>
  800cbb:	89 c3                	mov    %eax,%ebx
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	78 6a                	js     800d2b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800cc1:	39 c6                	cmp    %eax,%esi
  800cc3:	73 24                	jae    800ce9 <devfile_read+0x59>
  800cc5:	c7 44 24 0c b9 27 80 	movl   $0x8027b9,0xc(%esp)
  800ccc:	00 
  800ccd:	c7 44 24 08 c0 27 80 	movl   $0x8027c0,0x8(%esp)
  800cd4:	00 
  800cd5:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800cdc:	00 
  800cdd:	c7 04 24 d5 27 80 00 	movl   $0x8027d5,(%esp)
  800ce4:	e8 4d 0b 00 00       	call   801836 <_panic>
	assert(r <= PGSIZE);
  800ce9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800cee:	7e 24                	jle    800d14 <devfile_read+0x84>
  800cf0:	c7 44 24 0c e0 27 80 	movl   $0x8027e0,0xc(%esp)
  800cf7:	00 
  800cf8:	c7 44 24 08 c0 27 80 	movl   $0x8027c0,0x8(%esp)
  800cff:	00 
  800d00:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800d07:	00 
  800d08:	c7 04 24 d5 27 80 00 	movl   $0x8027d5,(%esp)
  800d0f:	e8 22 0b 00 00       	call   801836 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800d14:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d18:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800d1f:	00 
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	89 04 24             	mov    %eax,(%esp)
  800d26:	e8 19 14 00 00       	call   802144 <memmove>
	return r;
}
  800d2b:	89 d8                	mov    %ebx,%eax
  800d2d:	83 c4 10             	add    $0x10,%esp
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	53                   	push   %ebx
  800d38:	83 ec 24             	sub    $0x24,%esp
  800d3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800d3e:	89 1c 24             	mov    %ebx,(%esp)
  800d41:	e8 2a 12 00 00       	call   801f70 <strlen>
  800d46:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800d4b:	7f 60                	jg     800dad <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800d4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d50:	89 04 24             	mov    %eax,(%esp)
  800d53:	e8 af f7 ff ff       	call   800507 <fd_alloc>
  800d58:	89 c2                	mov    %eax,%edx
  800d5a:	85 d2                	test   %edx,%edx
  800d5c:	78 54                	js     800db2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800d5e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d62:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800d69:	e8 39 12 00 00       	call   801fa7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d71:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800d76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d79:	b8 01 00 00 00       	mov    $0x1,%eax
  800d7e:	e8 40 fd ff ff       	call   800ac3 <fsipc>
  800d83:	89 c3                	mov    %eax,%ebx
  800d85:	85 c0                	test   %eax,%eax
  800d87:	79 17                	jns    800da0 <open+0x6c>
		fd_close(fd, 0);
  800d89:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800d90:	00 
  800d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d94:	89 04 24             	mov    %eax,(%esp)
  800d97:	e8 6a f8 ff ff       	call   800606 <fd_close>
		return r;
  800d9c:	89 d8                	mov    %ebx,%eax
  800d9e:	eb 12                	jmp    800db2 <open+0x7e>
	}

	return fd2num(fd);
  800da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da3:	89 04 24             	mov    %eax,(%esp)
  800da6:	e8 35 f7 ff ff       	call   8004e0 <fd2num>
  800dab:	eb 05                	jmp    800db2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800dad:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800db2:	83 c4 24             	add    $0x24,%esp
  800db5:	5b                   	pop    %ebx
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800dbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc3:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc8:	e8 f6 fc ff ff       	call   800ac3 <fsipc>
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <evict>:

int evict(void)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  800dd5:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  800ddc:	e8 4e 0b 00 00       	call   80192f <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  800de1:	ba 00 00 00 00       	mov    $0x0,%edx
  800de6:	b8 09 00 00 00       	mov    $0x9,%eax
  800deb:	e8 d3 fc ff ff       	call   800ac3 <fsipc>
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    
  800df2:	66 90                	xchg   %ax,%ax
  800df4:	66 90                	xchg   %ax,%ax
  800df6:	66 90                	xchg   %ax,%ax
  800df8:	66 90                	xchg   %ax,%ax
  800dfa:	66 90                	xchg   %ax,%ax
  800dfc:	66 90                	xchg   %ax,%ax
  800dfe:	66 90                	xchg   %ax,%ax

00800e00 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800e06:	c7 44 24 04 05 28 80 	movl   $0x802805,0x4(%esp)
  800e0d:	00 
  800e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e11:	89 04 24             	mov    %eax,(%esp)
  800e14:	e8 8e 11 00 00       	call   801fa7 <strcpy>
	return 0;
}
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	53                   	push   %ebx
  800e24:	83 ec 14             	sub    $0x14,%esp
  800e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800e2a:	89 1c 24             	mov    %ebx,(%esp)
  800e2d:	e8 d5 15 00 00       	call   802407 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800e32:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800e37:	83 f8 01             	cmp    $0x1,%eax
  800e3a:	75 0d                	jne    800e49 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800e3c:	8b 43 0c             	mov    0xc(%ebx),%eax
  800e3f:	89 04 24             	mov    %eax,(%esp)
  800e42:	e8 29 03 00 00       	call   801170 <nsipc_close>
  800e47:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800e49:	89 d0                	mov    %edx,%eax
  800e4b:	83 c4 14             	add    $0x14,%esp
  800e4e:	5b                   	pop    %ebx
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    

00800e51 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800e57:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e5e:	00 
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e69:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8b 40 0c             	mov    0xc(%eax),%eax
  800e73:	89 04 24             	mov    %eax,(%esp)
  800e76:	e8 f0 03 00 00       	call   80126b <nsipc_send>
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800e83:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e8a:	00 
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	8b 40 0c             	mov    0xc(%eax),%eax
  800e9f:	89 04 24             	mov    %eax,(%esp)
  800ea2:	e8 44 03 00 00       	call   8011eb <nsipc_recv>
}
  800ea7:	c9                   	leave  
  800ea8:	c3                   	ret    

00800ea9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800eaf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800eb2:	89 54 24 04          	mov    %edx,0x4(%esp)
  800eb6:	89 04 24             	mov    %eax,(%esp)
  800eb9:	e8 98 f6 ff ff       	call   800556 <fd_lookup>
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	78 17                	js     800ed9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec5:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  800ecb:	39 08                	cmp    %ecx,(%eax)
  800ecd:	75 05                	jne    800ed4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  800ed2:	eb 05                	jmp    800ed9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800ed4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 20             	sub    $0x20,%esp
  800ee3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800ee5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ee8:	89 04 24             	mov    %eax,(%esp)
  800eeb:	e8 17 f6 ff ff       	call   800507 <fd_alloc>
  800ef0:	89 c3                	mov    %eax,%ebx
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	78 21                	js     800f17 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800ef6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800efd:	00 
  800efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f01:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f05:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f0c:	e8 bf f2 ff ff       	call   8001d0 <sys_page_alloc>
  800f11:	89 c3                	mov    %eax,%ebx
  800f13:	85 c0                	test   %eax,%eax
  800f15:	79 0c                	jns    800f23 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800f17:	89 34 24             	mov    %esi,(%esp)
  800f1a:	e8 51 02 00 00       	call   801170 <nsipc_close>
		return r;
  800f1f:	89 d8                	mov    %ebx,%eax
  800f21:	eb 20                	jmp    800f43 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f23:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f2c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f31:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800f38:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800f3b:	89 14 24             	mov    %edx,(%esp)
  800f3e:	e8 9d f5 ff ff       	call   8004e0 <fd2num>
}
  800f43:	83 c4 20             	add    $0x20,%esp
  800f46:	5b                   	pop    %ebx
  800f47:	5e                   	pop    %esi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	e8 51 ff ff ff       	call   800ea9 <fd2sockid>
		return r;
  800f58:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f5a:	85 c0                	test   %eax,%eax
  800f5c:	78 23                	js     800f81 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f5e:	8b 55 10             	mov    0x10(%ebp),%edx
  800f61:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f68:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f6c:	89 04 24             	mov    %eax,(%esp)
  800f6f:	e8 45 01 00 00       	call   8010b9 <nsipc_accept>
		return r;
  800f74:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f76:	85 c0                	test   %eax,%eax
  800f78:	78 07                	js     800f81 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800f7a:	e8 5c ff ff ff       	call   800edb <alloc_sockfd>
  800f7f:	89 c1                	mov    %eax,%ecx
}
  800f81:	89 c8                	mov    %ecx,%eax
  800f83:	c9                   	leave  
  800f84:	c3                   	ret    

00800f85 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	e8 16 ff ff ff       	call   800ea9 <fd2sockid>
  800f93:	89 c2                	mov    %eax,%edx
  800f95:	85 d2                	test   %edx,%edx
  800f97:	78 16                	js     800faf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800f99:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fa7:	89 14 24             	mov    %edx,(%esp)
  800faa:	e8 60 01 00 00       	call   80110f <nsipc_bind>
}
  800faf:	c9                   	leave  
  800fb0:	c3                   	ret    

00800fb1 <shutdown>:

int
shutdown(int s, int how)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	e8 ea fe ff ff       	call   800ea9 <fd2sockid>
  800fbf:	89 c2                	mov    %eax,%edx
  800fc1:	85 d2                	test   %edx,%edx
  800fc3:	78 0f                	js     800fd4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fcc:	89 14 24             	mov    %edx,(%esp)
  800fcf:	e8 7a 01 00 00       	call   80114e <nsipc_shutdown>
}
  800fd4:	c9                   	leave  
  800fd5:	c3                   	ret    

00800fd6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	e8 c5 fe ff ff       	call   800ea9 <fd2sockid>
  800fe4:	89 c2                	mov    %eax,%edx
  800fe6:	85 d2                	test   %edx,%edx
  800fe8:	78 16                	js     801000 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  800fea:	8b 45 10             	mov    0x10(%ebp),%eax
  800fed:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff8:	89 14 24             	mov    %edx,(%esp)
  800ffb:	e8 8a 01 00 00       	call   80118a <nsipc_connect>
}
  801000:	c9                   	leave  
  801001:	c3                   	ret    

00801002 <listen>:

int
listen(int s, int backlog)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	e8 99 fe ff ff       	call   800ea9 <fd2sockid>
  801010:	89 c2                	mov    %eax,%edx
  801012:	85 d2                	test   %edx,%edx
  801014:	78 0f                	js     801025 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	89 44 24 04          	mov    %eax,0x4(%esp)
  80101d:	89 14 24             	mov    %edx,(%esp)
  801020:	e8 a4 01 00 00       	call   8011c9 <nsipc_listen>
}
  801025:	c9                   	leave  
  801026:	c3                   	ret    

00801027 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80102d:	8b 45 10             	mov    0x10(%ebp),%eax
  801030:	89 44 24 08          	mov    %eax,0x8(%esp)
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	89 44 24 04          	mov    %eax,0x4(%esp)
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	89 04 24             	mov    %eax,(%esp)
  801041:	e8 98 02 00 00       	call   8012de <nsipc_socket>
  801046:	89 c2                	mov    %eax,%edx
  801048:	85 d2                	test   %edx,%edx
  80104a:	78 05                	js     801051 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80104c:	e8 8a fe ff ff       	call   800edb <alloc_sockfd>
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	53                   	push   %ebx
  801057:	83 ec 14             	sub    $0x14,%esp
  80105a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80105c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801063:	75 11                	jne    801076 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801065:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80106c:	e8 5e 13 00 00       	call   8023cf <ipc_find_env>
  801071:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801076:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80107d:	00 
  80107e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801085:	00 
  801086:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80108a:	a1 04 40 80 00       	mov    0x804004,%eax
  80108f:	89 04 24             	mov    %eax,(%esp)
  801092:	e8 d1 12 00 00       	call   802368 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801097:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80109e:	00 
  80109f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8010a6:	00 
  8010a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010ae:	e8 4d 12 00 00       	call   802300 <ipc_recv>
}
  8010b3:	83 c4 14             	add    $0x14,%esp
  8010b6:	5b                   	pop    %ebx
  8010b7:	5d                   	pop    %ebp
  8010b8:	c3                   	ret    

008010b9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	56                   	push   %esi
  8010bd:	53                   	push   %ebx
  8010be:	83 ec 10             	sub    $0x10,%esp
  8010c1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8010cc:	8b 06                	mov    (%esi),%eax
  8010ce:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8010d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8010d8:	e8 76 ff ff ff       	call   801053 <nsipc>
  8010dd:	89 c3                	mov    %eax,%ebx
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	78 23                	js     801106 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8010e3:	a1 10 60 80 00       	mov    0x806010,%eax
  8010e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010ec:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8010f3:	00 
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	89 04 24             	mov    %eax,(%esp)
  8010fa:	e8 45 10 00 00       	call   802144 <memmove>
		*addrlen = ret->ret_addrlen;
  8010ff:	a1 10 60 80 00       	mov    0x806010,%eax
  801104:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801106:	89 d8                	mov    %ebx,%eax
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	5b                   	pop    %ebx
  80110c:	5e                   	pop    %esi
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    

0080110f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	53                   	push   %ebx
  801113:	83 ec 14             	sub    $0x14,%esp
  801116:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801121:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	89 44 24 04          	mov    %eax,0x4(%esp)
  80112c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801133:	e8 0c 10 00 00       	call   802144 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801138:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80113e:	b8 02 00 00 00       	mov    $0x2,%eax
  801143:	e8 0b ff ff ff       	call   801053 <nsipc>
}
  801148:	83 c4 14             	add    $0x14,%esp
  80114b:	5b                   	pop    %ebx
  80114c:	5d                   	pop    %ebp
  80114d:	c3                   	ret    

0080114e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80115c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801164:	b8 03 00 00 00       	mov    $0x3,%eax
  801169:	e8 e5 fe ff ff       	call   801053 <nsipc>
}
  80116e:	c9                   	leave  
  80116f:	c3                   	ret    

00801170 <nsipc_close>:

int
nsipc_close(int s)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80117e:	b8 04 00 00 00       	mov    $0x4,%eax
  801183:	e8 cb fe ff ff       	call   801053 <nsipc>
}
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	53                   	push   %ebx
  80118e:	83 ec 14             	sub    $0x14,%esp
  801191:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80119c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011a7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8011ae:	e8 91 0f 00 00       	call   802144 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8011b3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8011b9:	b8 05 00 00 00       	mov    $0x5,%eax
  8011be:	e8 90 fe ff ff       	call   801053 <nsipc>
}
  8011c3:	83 c4 14             	add    $0x14,%esp
  8011c6:	5b                   	pop    %ebx
  8011c7:	5d                   	pop    %ebp
  8011c8:	c3                   	ret    

008011c9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8011df:	b8 06 00 00 00       	mov    $0x6,%eax
  8011e4:	e8 6a fe ff ff       	call   801053 <nsipc>
}
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	56                   	push   %esi
  8011ef:	53                   	push   %ebx
  8011f0:	83 ec 10             	sub    $0x10,%esp
  8011f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8011fe:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801204:	8b 45 14             	mov    0x14(%ebp),%eax
  801207:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80120c:	b8 07 00 00 00       	mov    $0x7,%eax
  801211:	e8 3d fe ff ff       	call   801053 <nsipc>
  801216:	89 c3                	mov    %eax,%ebx
  801218:	85 c0                	test   %eax,%eax
  80121a:	78 46                	js     801262 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80121c:	39 f0                	cmp    %esi,%eax
  80121e:	7f 07                	jg     801227 <nsipc_recv+0x3c>
  801220:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801225:	7e 24                	jle    80124b <nsipc_recv+0x60>
  801227:	c7 44 24 0c 11 28 80 	movl   $0x802811,0xc(%esp)
  80122e:	00 
  80122f:	c7 44 24 08 c0 27 80 	movl   $0x8027c0,0x8(%esp)
  801236:	00 
  801237:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80123e:	00 
  80123f:	c7 04 24 26 28 80 00 	movl   $0x802826,(%esp)
  801246:	e8 eb 05 00 00       	call   801836 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80124b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80124f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801256:	00 
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	89 04 24             	mov    %eax,(%esp)
  80125d:	e8 e2 0e 00 00       	call   802144 <memmove>
	}

	return r;
}
  801262:	89 d8                	mov    %ebx,%eax
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	5b                   	pop    %ebx
  801268:	5e                   	pop    %esi
  801269:	5d                   	pop    %ebp
  80126a:	c3                   	ret    

0080126b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	53                   	push   %ebx
  80126f:	83 ec 14             	sub    $0x14,%esp
  801272:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80127d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801283:	7e 24                	jle    8012a9 <nsipc_send+0x3e>
  801285:	c7 44 24 0c 32 28 80 	movl   $0x802832,0xc(%esp)
  80128c:	00 
  80128d:	c7 44 24 08 c0 27 80 	movl   $0x8027c0,0x8(%esp)
  801294:	00 
  801295:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80129c:	00 
  80129d:	c7 04 24 26 28 80 00 	movl   $0x802826,(%esp)
  8012a4:	e8 8d 05 00 00       	call   801836 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8012bb:	e8 84 0e 00 00       	call   802144 <memmove>
	nsipcbuf.send.req_size = size;
  8012c0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8012ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8012d3:	e8 7b fd ff ff       	call   801053 <nsipc>
}
  8012d8:	83 c4 14             	add    $0x14,%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5d                   	pop    %ebp
  8012dd:	c3                   	ret    

008012de <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8012ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ef:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8012f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8012fc:	b8 09 00 00 00       	mov    $0x9,%eax
  801301:	e8 4d fd ff ff       	call   801053 <nsipc>
}
  801306:	c9                   	leave  
  801307:	c3                   	ret    

00801308 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	56                   	push   %esi
  80130c:	53                   	push   %ebx
  80130d:	83 ec 10             	sub    $0x10,%esp
  801310:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	89 04 24             	mov    %eax,(%esp)
  801319:	e8 d2 f1 ff ff       	call   8004f0 <fd2data>
  80131e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801320:	c7 44 24 04 3e 28 80 	movl   $0x80283e,0x4(%esp)
  801327:	00 
  801328:	89 1c 24             	mov    %ebx,(%esp)
  80132b:	e8 77 0c 00 00       	call   801fa7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801330:	8b 46 04             	mov    0x4(%esi),%eax
  801333:	2b 06                	sub    (%esi),%eax
  801335:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80133b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801342:	00 00 00 
	stat->st_dev = &devpipe;
  801345:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  80134c:	30 80 00 
	return 0;
}
  80134f:	b8 00 00 00 00       	mov    $0x0,%eax
  801354:	83 c4 10             	add    $0x10,%esp
  801357:	5b                   	pop    %ebx
  801358:	5e                   	pop    %esi
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	53                   	push   %ebx
  80135f:	83 ec 14             	sub    $0x14,%esp
  801362:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801365:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801369:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801370:	e8 02 ef ff ff       	call   800277 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801375:	89 1c 24             	mov    %ebx,(%esp)
  801378:	e8 73 f1 ff ff       	call   8004f0 <fd2data>
  80137d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801381:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801388:	e8 ea ee ff ff       	call   800277 <sys_page_unmap>
}
  80138d:	83 c4 14             	add    $0x14,%esp
  801390:	5b                   	pop    %ebx
  801391:	5d                   	pop    %ebp
  801392:	c3                   	ret    

00801393 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	57                   	push   %edi
  801397:	56                   	push   %esi
  801398:	53                   	push   %ebx
  801399:	83 ec 2c             	sub    $0x2c,%esp
  80139c:	89 c6                	mov    %eax,%esi
  80139e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8013a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8013a6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8013a9:	89 34 24             	mov    %esi,(%esp)
  8013ac:	e8 56 10 00 00       	call   802407 <pageref>
  8013b1:	89 c7                	mov    %eax,%edi
  8013b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b6:	89 04 24             	mov    %eax,(%esp)
  8013b9:	e8 49 10 00 00       	call   802407 <pageref>
  8013be:	39 c7                	cmp    %eax,%edi
  8013c0:	0f 94 c2             	sete   %dl
  8013c3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8013c6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  8013cc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8013cf:	39 fb                	cmp    %edi,%ebx
  8013d1:	74 21                	je     8013f4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8013d3:	84 d2                	test   %dl,%dl
  8013d5:	74 ca                	je     8013a1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8013d7:	8b 51 58             	mov    0x58(%ecx),%edx
  8013da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013e6:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  8013ed:	e8 3d 05 00 00       	call   80192f <cprintf>
  8013f2:	eb ad                	jmp    8013a1 <_pipeisclosed+0xe>
	}
}
  8013f4:	83 c4 2c             	add    $0x2c,%esp
  8013f7:	5b                   	pop    %ebx
  8013f8:	5e                   	pop    %esi
  8013f9:	5f                   	pop    %edi
  8013fa:	5d                   	pop    %ebp
  8013fb:	c3                   	ret    

008013fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	57                   	push   %edi
  801400:	56                   	push   %esi
  801401:	53                   	push   %ebx
  801402:	83 ec 1c             	sub    $0x1c,%esp
  801405:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801408:	89 34 24             	mov    %esi,(%esp)
  80140b:	e8 e0 f0 ff ff       	call   8004f0 <fd2data>
  801410:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801412:	bf 00 00 00 00       	mov    $0x0,%edi
  801417:	eb 45                	jmp    80145e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801419:	89 da                	mov    %ebx,%edx
  80141b:	89 f0                	mov    %esi,%eax
  80141d:	e8 71 ff ff ff       	call   801393 <_pipeisclosed>
  801422:	85 c0                	test   %eax,%eax
  801424:	75 41                	jne    801467 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801426:	e8 86 ed ff ff       	call   8001b1 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80142b:	8b 43 04             	mov    0x4(%ebx),%eax
  80142e:	8b 0b                	mov    (%ebx),%ecx
  801430:	8d 51 20             	lea    0x20(%ecx),%edx
  801433:	39 d0                	cmp    %edx,%eax
  801435:	73 e2                	jae    801419 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801437:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80143e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801441:	99                   	cltd   
  801442:	c1 ea 1b             	shr    $0x1b,%edx
  801445:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801448:	83 e1 1f             	and    $0x1f,%ecx
  80144b:	29 d1                	sub    %edx,%ecx
  80144d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801451:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801455:	83 c0 01             	add    $0x1,%eax
  801458:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80145b:	83 c7 01             	add    $0x1,%edi
  80145e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801461:	75 c8                	jne    80142b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801463:	89 f8                	mov    %edi,%eax
  801465:	eb 05                	jmp    80146c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80146c:	83 c4 1c             	add    $0x1c,%esp
  80146f:	5b                   	pop    %ebx
  801470:	5e                   	pop    %esi
  801471:	5f                   	pop    %edi
  801472:	5d                   	pop    %ebp
  801473:	c3                   	ret    

00801474 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	57                   	push   %edi
  801478:	56                   	push   %esi
  801479:	53                   	push   %ebx
  80147a:	83 ec 1c             	sub    $0x1c,%esp
  80147d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801480:	89 3c 24             	mov    %edi,(%esp)
  801483:	e8 68 f0 ff ff       	call   8004f0 <fd2data>
  801488:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80148a:	be 00 00 00 00       	mov    $0x0,%esi
  80148f:	eb 3d                	jmp    8014ce <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801491:	85 f6                	test   %esi,%esi
  801493:	74 04                	je     801499 <devpipe_read+0x25>
				return i;
  801495:	89 f0                	mov    %esi,%eax
  801497:	eb 43                	jmp    8014dc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801499:	89 da                	mov    %ebx,%edx
  80149b:	89 f8                	mov    %edi,%eax
  80149d:	e8 f1 fe ff ff       	call   801393 <_pipeisclosed>
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	75 31                	jne    8014d7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8014a6:	e8 06 ed ff ff       	call   8001b1 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8014ab:	8b 03                	mov    (%ebx),%eax
  8014ad:	3b 43 04             	cmp    0x4(%ebx),%eax
  8014b0:	74 df                	je     801491 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8014b2:	99                   	cltd   
  8014b3:	c1 ea 1b             	shr    $0x1b,%edx
  8014b6:	01 d0                	add    %edx,%eax
  8014b8:	83 e0 1f             	and    $0x1f,%eax
  8014bb:	29 d0                	sub    %edx,%eax
  8014bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8014c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8014c8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014cb:	83 c6 01             	add    $0x1,%esi
  8014ce:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014d1:	75 d8                	jne    8014ab <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8014d3:	89 f0                	mov    %esi,%eax
  8014d5:	eb 05                	jmp    8014dc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8014d7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8014dc:	83 c4 1c             	add    $0x1c,%esp
  8014df:	5b                   	pop    %ebx
  8014e0:	5e                   	pop    %esi
  8014e1:	5f                   	pop    %edi
  8014e2:	5d                   	pop    %ebp
  8014e3:	c3                   	ret    

008014e4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	56                   	push   %esi
  8014e8:	53                   	push   %ebx
  8014e9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8014ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ef:	89 04 24             	mov    %eax,(%esp)
  8014f2:	e8 10 f0 ff ff       	call   800507 <fd_alloc>
  8014f7:	89 c2                	mov    %eax,%edx
  8014f9:	85 d2                	test   %edx,%edx
  8014fb:	0f 88 4d 01 00 00    	js     80164e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801501:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801508:	00 
  801509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801510:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801517:	e8 b4 ec ff ff       	call   8001d0 <sys_page_alloc>
  80151c:	89 c2                	mov    %eax,%edx
  80151e:	85 d2                	test   %edx,%edx
  801520:	0f 88 28 01 00 00    	js     80164e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801526:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801529:	89 04 24             	mov    %eax,(%esp)
  80152c:	e8 d6 ef ff ff       	call   800507 <fd_alloc>
  801531:	89 c3                	mov    %eax,%ebx
  801533:	85 c0                	test   %eax,%eax
  801535:	0f 88 fe 00 00 00    	js     801639 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80153b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801542:	00 
  801543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801546:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801551:	e8 7a ec ff ff       	call   8001d0 <sys_page_alloc>
  801556:	89 c3                	mov    %eax,%ebx
  801558:	85 c0                	test   %eax,%eax
  80155a:	0f 88 d9 00 00 00    	js     801639 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801563:	89 04 24             	mov    %eax,(%esp)
  801566:	e8 85 ef ff ff       	call   8004f0 <fd2data>
  80156b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80156d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801574:	00 
  801575:	89 44 24 04          	mov    %eax,0x4(%esp)
  801579:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801580:	e8 4b ec ff ff       	call   8001d0 <sys_page_alloc>
  801585:	89 c3                	mov    %eax,%ebx
  801587:	85 c0                	test   %eax,%eax
  801589:	0f 88 97 00 00 00    	js     801626 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801592:	89 04 24             	mov    %eax,(%esp)
  801595:	e8 56 ef ff ff       	call   8004f0 <fd2data>
  80159a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8015a1:	00 
  8015a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015ad:	00 
  8015ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b9:	e8 66 ec ff ff       	call   800224 <sys_page_map>
  8015be:	89 c3                	mov    %eax,%ebx
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	78 52                	js     801616 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8015c4:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8015ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8015cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8015d9:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8015e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8015ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f1:	89 04 24             	mov    %eax,(%esp)
  8015f4:	e8 e7 ee ff ff       	call   8004e0 <fd2num>
  8015f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015fc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8015fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801601:	89 04 24             	mov    %eax,(%esp)
  801604:	e8 d7 ee ff ff       	call   8004e0 <fd2num>
  801609:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80160c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80160f:	b8 00 00 00 00       	mov    $0x0,%eax
  801614:	eb 38                	jmp    80164e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801616:	89 74 24 04          	mov    %esi,0x4(%esp)
  80161a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801621:	e8 51 ec ff ff       	call   800277 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801629:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801634:	e8 3e ec ff ff       	call   800277 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801640:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801647:	e8 2b ec ff ff       	call   800277 <sys_page_unmap>
  80164c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80164e:	83 c4 30             	add    $0x30,%esp
  801651:	5b                   	pop    %ebx
  801652:	5e                   	pop    %esi
  801653:	5d                   	pop    %ebp
  801654:	c3                   	ret    

00801655 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80165b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	89 04 24             	mov    %eax,(%esp)
  801668:	e8 e9 ee ff ff       	call   800556 <fd_lookup>
  80166d:	89 c2                	mov    %eax,%edx
  80166f:	85 d2                	test   %edx,%edx
  801671:	78 15                	js     801688 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801676:	89 04 24             	mov    %eax,(%esp)
  801679:	e8 72 ee ff ff       	call   8004f0 <fd2data>
	return _pipeisclosed(fd, p);
  80167e:	89 c2                	mov    %eax,%edx
  801680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801683:	e8 0b fd ff ff       	call   801393 <_pipeisclosed>
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    
  80168a:	66 90                	xchg   %ax,%ax
  80168c:	66 90                	xchg   %ax,%ax
  80168e:	66 90                	xchg   %ax,%ax

00801690 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801693:	b8 00 00 00 00       	mov    $0x0,%eax
  801698:	5d                   	pop    %ebp
  801699:	c3                   	ret    

0080169a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8016a0:	c7 44 24 04 5d 28 80 	movl   $0x80285d,0x4(%esp)
  8016a7:	00 
  8016a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ab:	89 04 24             	mov    %eax,(%esp)
  8016ae:	e8 f4 08 00 00       	call   801fa7 <strcpy>
	return 0;
}
  8016b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	57                   	push   %edi
  8016be:	56                   	push   %esi
  8016bf:	53                   	push   %ebx
  8016c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8016cb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016d1:	eb 31                	jmp    801704 <devcons_write+0x4a>
		m = n - tot;
  8016d3:	8b 75 10             	mov    0x10(%ebp),%esi
  8016d6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8016d8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8016db:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8016e0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8016e3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8016e7:	03 45 0c             	add    0xc(%ebp),%eax
  8016ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ee:	89 3c 24             	mov    %edi,(%esp)
  8016f1:	e8 4e 0a 00 00       	call   802144 <memmove>
		sys_cputs(buf, m);
  8016f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016fa:	89 3c 24             	mov    %edi,(%esp)
  8016fd:	e8 af e9 ff ff       	call   8000b1 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801702:	01 f3                	add    %esi,%ebx
  801704:	89 d8                	mov    %ebx,%eax
  801706:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801709:	72 c8                	jb     8016d3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80170b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801711:	5b                   	pop    %ebx
  801712:	5e                   	pop    %esi
  801713:	5f                   	pop    %edi
  801714:	5d                   	pop    %ebp
  801715:	c3                   	ret    

00801716 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801721:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801725:	75 07                	jne    80172e <devcons_read+0x18>
  801727:	eb 2a                	jmp    801753 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801729:	e8 83 ea ff ff       	call   8001b1 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80172e:	66 90                	xchg   %ax,%ax
  801730:	e8 9a e9 ff ff       	call   8000cf <sys_cgetc>
  801735:	85 c0                	test   %eax,%eax
  801737:	74 f0                	je     801729 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801739:	85 c0                	test   %eax,%eax
  80173b:	78 16                	js     801753 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80173d:	83 f8 04             	cmp    $0x4,%eax
  801740:	74 0c                	je     80174e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801742:	8b 55 0c             	mov    0xc(%ebp),%edx
  801745:	88 02                	mov    %al,(%edx)
	return 1;
  801747:	b8 01 00 00 00       	mov    $0x1,%eax
  80174c:	eb 05                	jmp    801753 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80174e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801761:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801768:	00 
  801769:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80176c:	89 04 24             	mov    %eax,(%esp)
  80176f:	e8 3d e9 ff ff       	call   8000b1 <sys_cputs>
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <getchar>:

int
getchar(void)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80177c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801783:	00 
  801784:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801787:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801792:	e8 53 f0 ff ff       	call   8007ea <read>
	if (r < 0)
  801797:	85 c0                	test   %eax,%eax
  801799:	78 0f                	js     8017aa <getchar+0x34>
		return r;
	if (r < 1)
  80179b:	85 c0                	test   %eax,%eax
  80179d:	7e 06                	jle    8017a5 <getchar+0x2f>
		return -E_EOF;
	return c;
  80179f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8017a3:	eb 05                	jmp    8017aa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8017a5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	89 04 24             	mov    %eax,(%esp)
  8017bf:	e8 92 ed ff ff       	call   800556 <fd_lookup>
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 11                	js     8017d9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cb:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8017d1:	39 10                	cmp    %edx,(%eax)
  8017d3:	0f 94 c0             	sete   %al
  8017d6:	0f b6 c0             	movzbl %al,%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <opencons>:

int
opencons(void)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8017e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e4:	89 04 24             	mov    %eax,(%esp)
  8017e7:	e8 1b ed ff ff       	call   800507 <fd_alloc>
		return r;
  8017ec:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 40                	js     801832 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8017f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8017f9:	00 
  8017fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801801:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801808:	e8 c3 e9 ff ff       	call   8001d0 <sys_page_alloc>
		return r;
  80180d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 1f                	js     801832 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801813:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  801819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80181e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801821:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801828:	89 04 24             	mov    %eax,(%esp)
  80182b:	e8 b0 ec ff ff       	call   8004e0 <fd2num>
  801830:	89 c2                	mov    %eax,%edx
}
  801832:	89 d0                	mov    %edx,%eax
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80183e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801841:	8b 35 04 30 80 00    	mov    0x803004,%esi
  801847:	e8 46 e9 ff ff       	call   800192 <sys_getenvid>
  80184c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801853:	8b 55 08             	mov    0x8(%ebp),%edx
  801856:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80185a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80185e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801862:	c7 04 24 6c 28 80 00 	movl   $0x80286c,(%esp)
  801869:	e8 c1 00 00 00       	call   80192f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80186e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801872:	8b 45 10             	mov    0x10(%ebp),%eax
  801875:	89 04 24             	mov    %eax,(%esp)
  801878:	e8 51 00 00 00       	call   8018ce <vcprintf>
	cprintf("\n");
  80187d:	c7 04 24 03 28 80 00 	movl   $0x802803,(%esp)
  801884:	e8 a6 00 00 00       	call   80192f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801889:	cc                   	int3   
  80188a:	eb fd                	jmp    801889 <_panic+0x53>

0080188c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	53                   	push   %ebx
  801890:	83 ec 14             	sub    $0x14,%esp
  801893:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801896:	8b 13                	mov    (%ebx),%edx
  801898:	8d 42 01             	lea    0x1(%edx),%eax
  80189b:	89 03                	mov    %eax,(%ebx)
  80189d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8018a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8018a9:	75 19                	jne    8018c4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8018ab:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8018b2:	00 
  8018b3:	8d 43 08             	lea    0x8(%ebx),%eax
  8018b6:	89 04 24             	mov    %eax,(%esp)
  8018b9:	e8 f3 e7 ff ff       	call   8000b1 <sys_cputs>
		b->idx = 0;
  8018be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8018c4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8018c8:	83 c4 14             	add    $0x14,%esp
  8018cb:	5b                   	pop    %ebx
  8018cc:	5d                   	pop    %ebp
  8018cd:	c3                   	ret    

008018ce <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8018d7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018de:	00 00 00 
	b.cnt = 0;
  8018e1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8018e8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8018eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8018ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801903:	c7 04 24 8c 18 80 00 	movl   $0x80188c,(%esp)
  80190a:	e8 75 01 00 00       	call   801a84 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80190f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801915:	89 44 24 04          	mov    %eax,0x4(%esp)
  801919:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80191f:	89 04 24             	mov    %eax,(%esp)
  801922:	e8 8a e7 ff ff       	call   8000b1 <sys_cputs>

	return b.cnt;
}
  801927:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801935:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801938:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	89 04 24             	mov    %eax,(%esp)
  801942:	e8 87 ff ff ff       	call   8018ce <vcprintf>
	va_end(ap);

	return cnt;
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    
  801949:	66 90                	xchg   %ax,%ax
  80194b:	66 90                	xchg   %ax,%ax
  80194d:	66 90                	xchg   %ax,%ax
  80194f:	90                   	nop

00801950 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	57                   	push   %edi
  801954:	56                   	push   %esi
  801955:	53                   	push   %ebx
  801956:	83 ec 3c             	sub    $0x3c,%esp
  801959:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80195c:	89 d7                	mov    %edx,%edi
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801964:	8b 45 0c             	mov    0xc(%ebp),%eax
  801967:	89 c3                	mov    %eax,%ebx
  801969:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80196c:	8b 45 10             	mov    0x10(%ebp),%eax
  80196f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801972:	b9 00 00 00 00       	mov    $0x0,%ecx
  801977:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80197a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80197d:	39 d9                	cmp    %ebx,%ecx
  80197f:	72 05                	jb     801986 <printnum+0x36>
  801981:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801984:	77 69                	ja     8019ef <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801986:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801989:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80198d:	83 ee 01             	sub    $0x1,%esi
  801990:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801994:	89 44 24 08          	mov    %eax,0x8(%esp)
  801998:	8b 44 24 08          	mov    0x8(%esp),%eax
  80199c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8019a0:	89 c3                	mov    %eax,%ebx
  8019a2:	89 d6                	mov    %edx,%esi
  8019a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8019aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019ae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b5:	89 04 24             	mov    %eax,(%esp)
  8019b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bf:	e8 8c 0a 00 00       	call   802450 <__udivdi3>
  8019c4:	89 d9                	mov    %ebx,%ecx
  8019c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019ca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019ce:	89 04 24             	mov    %eax,(%esp)
  8019d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019d5:	89 fa                	mov    %edi,%edx
  8019d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019da:	e8 71 ff ff ff       	call   801950 <printnum>
  8019df:	eb 1b                	jmp    8019fc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8019e1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8019e8:	89 04 24             	mov    %eax,(%esp)
  8019eb:	ff d3                	call   *%ebx
  8019ed:	eb 03                	jmp    8019f2 <printnum+0xa2>
  8019ef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8019f2:	83 ee 01             	sub    $0x1,%esi
  8019f5:	85 f6                	test   %esi,%esi
  8019f7:	7f e8                	jg     8019e1 <printnum+0x91>
  8019f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8019fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a00:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801a04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a07:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a0e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a15:	89 04 24             	mov    %eax,(%esp)
  801a18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1f:	e8 5c 0b 00 00       	call   802580 <__umoddi3>
  801a24:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a28:	0f be 80 8f 28 80 00 	movsbl 0x80288f(%eax),%eax
  801a2f:	89 04 24             	mov    %eax,(%esp)
  801a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a35:	ff d0                	call   *%eax
}
  801a37:	83 c4 3c             	add    $0x3c,%esp
  801a3a:	5b                   	pop    %ebx
  801a3b:	5e                   	pop    %esi
  801a3c:	5f                   	pop    %edi
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    

00801a3f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a45:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801a49:	8b 10                	mov    (%eax),%edx
  801a4b:	3b 50 04             	cmp    0x4(%eax),%edx
  801a4e:	73 0a                	jae    801a5a <sprintputch+0x1b>
		*b->buf++ = ch;
  801a50:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a53:	89 08                	mov    %ecx,(%eax)
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	88 02                	mov    %al,(%edx)
}
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    

00801a5c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a62:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801a65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a69:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	89 04 24             	mov    %eax,(%esp)
  801a7d:	e8 02 00 00 00       	call   801a84 <vprintfmt>
	va_end(ap);
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	57                   	push   %edi
  801a88:	56                   	push   %esi
  801a89:	53                   	push   %ebx
  801a8a:	83 ec 3c             	sub    $0x3c,%esp
  801a8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a90:	eb 17                	jmp    801aa9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  801a92:	85 c0                	test   %eax,%eax
  801a94:	0f 84 4b 04 00 00    	je     801ee5 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  801a9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a9d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aa1:	89 04 24             	mov    %eax,(%esp)
  801aa4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  801aa7:	89 fb                	mov    %edi,%ebx
  801aa9:	8d 7b 01             	lea    0x1(%ebx),%edi
  801aac:	0f b6 03             	movzbl (%ebx),%eax
  801aaf:	83 f8 25             	cmp    $0x25,%eax
  801ab2:	75 de                	jne    801a92 <vprintfmt+0xe>
  801ab4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  801ab8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801abf:	be ff ff ff ff       	mov    $0xffffffff,%esi
  801ac4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801acb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad0:	eb 18                	jmp    801aea <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ad2:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801ad4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  801ad8:	eb 10                	jmp    801aea <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ada:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801adc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  801ae0:	eb 08                	jmp    801aea <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801ae2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801ae5:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aea:	8d 5f 01             	lea    0x1(%edi),%ebx
  801aed:	0f b6 17             	movzbl (%edi),%edx
  801af0:	0f b6 c2             	movzbl %dl,%eax
  801af3:	83 ea 23             	sub    $0x23,%edx
  801af6:	80 fa 55             	cmp    $0x55,%dl
  801af9:	0f 87 c2 03 00 00    	ja     801ec1 <vprintfmt+0x43d>
  801aff:	0f b6 d2             	movzbl %dl,%edx
  801b02:	ff 24 95 e0 29 80 00 	jmp    *0x8029e0(,%edx,4)
  801b09:	89 df                	mov    %ebx,%edi
  801b0b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801b10:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  801b13:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  801b17:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  801b1a:	8d 50 d0             	lea    -0x30(%eax),%edx
  801b1d:	83 fa 09             	cmp    $0x9,%edx
  801b20:	77 33                	ja     801b55 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b22:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b25:	eb e9                	jmp    801b10 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b27:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2a:	8b 30                	mov    (%eax),%esi
  801b2c:	8d 40 04             	lea    0x4(%eax),%eax
  801b2f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b32:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801b34:	eb 1f                	jmp    801b55 <vprintfmt+0xd1>
  801b36:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801b39:	85 ff                	test   %edi,%edi
  801b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b40:	0f 49 c7             	cmovns %edi,%eax
  801b43:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b46:	89 df                	mov    %ebx,%edi
  801b48:	eb a0                	jmp    801aea <vprintfmt+0x66>
  801b4a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801b4c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  801b53:	eb 95                	jmp    801aea <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  801b55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b59:	79 8f                	jns    801aea <vprintfmt+0x66>
  801b5b:	eb 85                	jmp    801ae2 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b5d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b60:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801b62:	eb 86                	jmp    801aea <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b64:	8b 45 14             	mov    0x14(%ebp),%eax
  801b67:	8d 70 04             	lea    0x4(%eax),%esi
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b71:	8b 45 14             	mov    0x14(%ebp),%eax
  801b74:	8b 00                	mov    (%eax),%eax
  801b76:	89 04 24             	mov    %eax,(%esp)
  801b79:	ff 55 08             	call   *0x8(%ebp)
  801b7c:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  801b7f:	e9 25 ff ff ff       	jmp    801aa9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b84:	8b 45 14             	mov    0x14(%ebp),%eax
  801b87:	8d 70 04             	lea    0x4(%eax),%esi
  801b8a:	8b 00                	mov    (%eax),%eax
  801b8c:	99                   	cltd   
  801b8d:	31 d0                	xor    %edx,%eax
  801b8f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801b91:	83 f8 15             	cmp    $0x15,%eax
  801b94:	7f 0b                	jg     801ba1 <vprintfmt+0x11d>
  801b96:	8b 14 85 40 2b 80 00 	mov    0x802b40(,%eax,4),%edx
  801b9d:	85 d2                	test   %edx,%edx
  801b9f:	75 26                	jne    801bc7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  801ba1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ba5:	c7 44 24 08 a7 28 80 	movl   $0x8028a7,0x8(%esp)
  801bac:	00 
  801bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	89 04 24             	mov    %eax,(%esp)
  801bba:	e8 9d fe ff ff       	call   801a5c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bbf:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801bc2:	e9 e2 fe ff ff       	jmp    801aa9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801bc7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801bcb:	c7 44 24 08 d2 27 80 	movl   $0x8027d2,0x8(%esp)
  801bd2:	00 
  801bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	89 04 24             	mov    %eax,(%esp)
  801be0:	e8 77 fe ff ff       	call   801a5c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  801be5:	89 75 14             	mov    %esi,0x14(%ebp)
  801be8:	e9 bc fe ff ff       	jmp    801aa9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bed:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801bf3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801bf6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801bfa:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801bfc:	85 ff                	test   %edi,%edi
  801bfe:	b8 a0 28 80 00       	mov    $0x8028a0,%eax
  801c03:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801c06:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  801c0a:	0f 84 94 00 00 00    	je     801ca4 <vprintfmt+0x220>
  801c10:	85 c9                	test   %ecx,%ecx
  801c12:	0f 8e 94 00 00 00    	jle    801cac <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c18:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c1c:	89 3c 24             	mov    %edi,(%esp)
  801c1f:	e8 64 03 00 00       	call   801f88 <strnlen>
  801c24:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801c27:	29 c1                	sub    %eax,%ecx
  801c29:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  801c2c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  801c30:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801c33:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801c36:	8b 75 08             	mov    0x8(%ebp),%esi
  801c39:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c3c:	89 cb                	mov    %ecx,%ebx
  801c3e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c40:	eb 0f                	jmp    801c51 <vprintfmt+0x1cd>
					putch(padc, putdat);
  801c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c49:	89 3c 24             	mov    %edi,(%esp)
  801c4c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c4e:	83 eb 01             	sub    $0x1,%ebx
  801c51:	85 db                	test   %ebx,%ebx
  801c53:	7f ed                	jg     801c42 <vprintfmt+0x1be>
  801c55:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c58:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801c5b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801c5e:	85 c9                	test   %ecx,%ecx
  801c60:	b8 00 00 00 00       	mov    $0x0,%eax
  801c65:	0f 49 c1             	cmovns %ecx,%eax
  801c68:	29 c1                	sub    %eax,%ecx
  801c6a:	89 cb                	mov    %ecx,%ebx
  801c6c:	eb 44                	jmp    801cb2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801c6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c72:	74 1e                	je     801c92 <vprintfmt+0x20e>
  801c74:	0f be d2             	movsbl %dl,%edx
  801c77:	83 ea 20             	sub    $0x20,%edx
  801c7a:	83 fa 5e             	cmp    $0x5e,%edx
  801c7d:	76 13                	jbe    801c92 <vprintfmt+0x20e>
					putch('?', putdat);
  801c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c82:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c86:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801c8d:	ff 55 08             	call   *0x8(%ebp)
  801c90:	eb 0d                	jmp    801c9f <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  801c92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c95:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c99:	89 04 24             	mov    %eax,(%esp)
  801c9c:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c9f:	83 eb 01             	sub    $0x1,%ebx
  801ca2:	eb 0e                	jmp    801cb2 <vprintfmt+0x22e>
  801ca4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ca7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801caa:	eb 06                	jmp    801cb2 <vprintfmt+0x22e>
  801cac:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801caf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801cb2:	83 c7 01             	add    $0x1,%edi
  801cb5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801cb9:	0f be c2             	movsbl %dl,%eax
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	74 27                	je     801ce7 <vprintfmt+0x263>
  801cc0:	85 f6                	test   %esi,%esi
  801cc2:	78 aa                	js     801c6e <vprintfmt+0x1ea>
  801cc4:	83 ee 01             	sub    $0x1,%esi
  801cc7:	79 a5                	jns    801c6e <vprintfmt+0x1ea>
  801cc9:	89 d8                	mov    %ebx,%eax
  801ccb:	8b 75 08             	mov    0x8(%ebp),%esi
  801cce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cd1:	89 c3                	mov    %eax,%ebx
  801cd3:	eb 18                	jmp    801ced <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801cd5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cd9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801ce0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ce2:	83 eb 01             	sub    $0x1,%ebx
  801ce5:	eb 06                	jmp    801ced <vprintfmt+0x269>
  801ce7:	8b 75 08             	mov    0x8(%ebp),%esi
  801cea:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ced:	85 db                	test   %ebx,%ebx
  801cef:	7f e4                	jg     801cd5 <vprintfmt+0x251>
  801cf1:	89 75 08             	mov    %esi,0x8(%ebp)
  801cf4:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801cf7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cfa:	e9 aa fd ff ff       	jmp    801aa9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801cff:	83 f9 01             	cmp    $0x1,%ecx
  801d02:	7e 10                	jle    801d14 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  801d04:	8b 45 14             	mov    0x14(%ebp),%eax
  801d07:	8b 30                	mov    (%eax),%esi
  801d09:	8b 78 04             	mov    0x4(%eax),%edi
  801d0c:	8d 40 08             	lea    0x8(%eax),%eax
  801d0f:	89 45 14             	mov    %eax,0x14(%ebp)
  801d12:	eb 26                	jmp    801d3a <vprintfmt+0x2b6>
	else if (lflag)
  801d14:	85 c9                	test   %ecx,%ecx
  801d16:	74 12                	je     801d2a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  801d18:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1b:	8b 30                	mov    (%eax),%esi
  801d1d:	89 f7                	mov    %esi,%edi
  801d1f:	c1 ff 1f             	sar    $0x1f,%edi
  801d22:	8d 40 04             	lea    0x4(%eax),%eax
  801d25:	89 45 14             	mov    %eax,0x14(%ebp)
  801d28:	eb 10                	jmp    801d3a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  801d2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2d:	8b 30                	mov    (%eax),%esi
  801d2f:	89 f7                	mov    %esi,%edi
  801d31:	c1 ff 1f             	sar    $0x1f,%edi
  801d34:	8d 40 04             	lea    0x4(%eax),%eax
  801d37:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d3a:	89 f0                	mov    %esi,%eax
  801d3c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801d3e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801d43:	85 ff                	test   %edi,%edi
  801d45:	0f 89 3a 01 00 00    	jns    801e85 <vprintfmt+0x401>
				putch('-', putdat);
  801d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d52:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801d59:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801d5c:	89 f0                	mov    %esi,%eax
  801d5e:	89 fa                	mov    %edi,%edx
  801d60:	f7 d8                	neg    %eax
  801d62:	83 d2 00             	adc    $0x0,%edx
  801d65:	f7 da                	neg    %edx
			}
			base = 10;
  801d67:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d6c:	e9 14 01 00 00       	jmp    801e85 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801d71:	83 f9 01             	cmp    $0x1,%ecx
  801d74:	7e 13                	jle    801d89 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  801d76:	8b 45 14             	mov    0x14(%ebp),%eax
  801d79:	8b 50 04             	mov    0x4(%eax),%edx
  801d7c:	8b 00                	mov    (%eax),%eax
  801d7e:	8b 75 14             	mov    0x14(%ebp),%esi
  801d81:	8d 4e 08             	lea    0x8(%esi),%ecx
  801d84:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801d87:	eb 2c                	jmp    801db5 <vprintfmt+0x331>
	else if (lflag)
  801d89:	85 c9                	test   %ecx,%ecx
  801d8b:	74 15                	je     801da2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  801d8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d90:	8b 00                	mov    (%eax),%eax
  801d92:	ba 00 00 00 00       	mov    $0x0,%edx
  801d97:	8b 75 14             	mov    0x14(%ebp),%esi
  801d9a:	8d 76 04             	lea    0x4(%esi),%esi
  801d9d:	89 75 14             	mov    %esi,0x14(%ebp)
  801da0:	eb 13                	jmp    801db5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  801da2:	8b 45 14             	mov    0x14(%ebp),%eax
  801da5:	8b 00                	mov    (%eax),%eax
  801da7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dac:	8b 75 14             	mov    0x14(%ebp),%esi
  801daf:	8d 76 04             	lea    0x4(%esi),%esi
  801db2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  801db5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801dba:	e9 c6 00 00 00       	jmp    801e85 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801dbf:	83 f9 01             	cmp    $0x1,%ecx
  801dc2:	7e 13                	jle    801dd7 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  801dc4:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc7:	8b 50 04             	mov    0x4(%eax),%edx
  801dca:	8b 00                	mov    (%eax),%eax
  801dcc:	8b 75 14             	mov    0x14(%ebp),%esi
  801dcf:	8d 4e 08             	lea    0x8(%esi),%ecx
  801dd2:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801dd5:	eb 24                	jmp    801dfb <vprintfmt+0x377>
	else if (lflag)
  801dd7:	85 c9                	test   %ecx,%ecx
  801dd9:	74 11                	je     801dec <vprintfmt+0x368>
		return va_arg(*ap, long);
  801ddb:	8b 45 14             	mov    0x14(%ebp),%eax
  801dde:	8b 00                	mov    (%eax),%eax
  801de0:	99                   	cltd   
  801de1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801de4:	8d 71 04             	lea    0x4(%ecx),%esi
  801de7:	89 75 14             	mov    %esi,0x14(%ebp)
  801dea:	eb 0f                	jmp    801dfb <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  801dec:	8b 45 14             	mov    0x14(%ebp),%eax
  801def:	8b 00                	mov    (%eax),%eax
  801df1:	99                   	cltd   
  801df2:	8b 75 14             	mov    0x14(%ebp),%esi
  801df5:	8d 76 04             	lea    0x4(%esi),%esi
  801df8:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  801dfb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801e00:	e9 80 00 00 00       	jmp    801e85 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e05:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  801e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801e16:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e20:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801e27:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801e2a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e2e:	8b 06                	mov    (%esi),%eax
  801e30:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801e35:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801e3a:	eb 49                	jmp    801e85 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801e3c:	83 f9 01             	cmp    $0x1,%ecx
  801e3f:	7e 13                	jle    801e54 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  801e41:	8b 45 14             	mov    0x14(%ebp),%eax
  801e44:	8b 50 04             	mov    0x4(%eax),%edx
  801e47:	8b 00                	mov    (%eax),%eax
  801e49:	8b 75 14             	mov    0x14(%ebp),%esi
  801e4c:	8d 4e 08             	lea    0x8(%esi),%ecx
  801e4f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801e52:	eb 2c                	jmp    801e80 <vprintfmt+0x3fc>
	else if (lflag)
  801e54:	85 c9                	test   %ecx,%ecx
  801e56:	74 15                	je     801e6d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  801e58:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5b:	8b 00                	mov    (%eax),%eax
  801e5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e62:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e65:	8d 71 04             	lea    0x4(%ecx),%esi
  801e68:	89 75 14             	mov    %esi,0x14(%ebp)
  801e6b:	eb 13                	jmp    801e80 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  801e6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e70:	8b 00                	mov    (%eax),%eax
  801e72:	ba 00 00 00 00       	mov    $0x0,%edx
  801e77:	8b 75 14             	mov    0x14(%ebp),%esi
  801e7a:	8d 76 04             	lea    0x4(%esi),%esi
  801e7d:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  801e80:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e85:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  801e89:	89 74 24 10          	mov    %esi,0x10(%esp)
  801e8d:	8b 75 e0             	mov    -0x20(%ebp),%esi
  801e90:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e94:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e98:	89 04 24             	mov    %eax,(%esp)
  801e9b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	e8 a6 fa ff ff       	call   801950 <printnum>
			break;
  801eaa:	e9 fa fb ff ff       	jmp    801aa9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801eb6:	89 04 24             	mov    %eax,(%esp)
  801eb9:	ff 55 08             	call   *0x8(%ebp)
			break;
  801ebc:	e9 e8 fb ff ff       	jmp    801aa9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801ecf:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ed2:	89 fb                	mov    %edi,%ebx
  801ed4:	eb 03                	jmp    801ed9 <vprintfmt+0x455>
  801ed6:	83 eb 01             	sub    $0x1,%ebx
  801ed9:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801edd:	75 f7                	jne    801ed6 <vprintfmt+0x452>
  801edf:	90                   	nop
  801ee0:	e9 c4 fb ff ff       	jmp    801aa9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801ee5:	83 c4 3c             	add    $0x3c,%esp
  801ee8:	5b                   	pop    %ebx
  801ee9:	5e                   	pop    %esi
  801eea:	5f                   	pop    %edi
  801eeb:	5d                   	pop    %ebp
  801eec:	c3                   	ret    

00801eed <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	83 ec 28             	sub    $0x28,%esp
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ef9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801efc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801f00:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801f03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	74 30                	je     801f3e <vsnprintf+0x51>
  801f0e:	85 d2                	test   %edx,%edx
  801f10:	7e 2c                	jle    801f3e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f12:	8b 45 14             	mov    0x14(%ebp),%eax
  801f15:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f19:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f20:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f27:	c7 04 24 3f 1a 80 00 	movl   $0x801a3f,(%esp)
  801f2e:	e8 51 fb ff ff       	call   801a84 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801f33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f36:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	eb 05                	jmp    801f43 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801f3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f4b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f52:	8b 45 10             	mov    0x10(%ebp),%eax
  801f55:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	89 04 24             	mov    %eax,(%esp)
  801f66:	e8 82 ff ff ff       	call   801eed <vsnprintf>
	va_end(ap);

	return rc;
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    
  801f6d:	66 90                	xchg   %ax,%ax
  801f6f:	90                   	nop

00801f70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7b:	eb 03                	jmp    801f80 <strlen+0x10>
		n++;
  801f7d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f80:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801f84:	75 f7                	jne    801f7d <strlen+0xd>
		n++;
	return n;
}
  801f86:	5d                   	pop    %ebp
  801f87:	c3                   	ret    

00801f88 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f91:	b8 00 00 00 00       	mov    $0x0,%eax
  801f96:	eb 03                	jmp    801f9b <strnlen+0x13>
		n++;
  801f98:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f9b:	39 d0                	cmp    %edx,%eax
  801f9d:	74 06                	je     801fa5 <strnlen+0x1d>
  801f9f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801fa3:	75 f3                	jne    801f98 <strnlen+0x10>
		n++;
	return n;
}
  801fa5:	5d                   	pop    %ebp
  801fa6:	c3                   	ret    

00801fa7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	53                   	push   %ebx
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801fb1:	89 c2                	mov    %eax,%edx
  801fb3:	83 c2 01             	add    $0x1,%edx
  801fb6:	83 c1 01             	add    $0x1,%ecx
  801fb9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801fbd:	88 5a ff             	mov    %bl,-0x1(%edx)
  801fc0:	84 db                	test   %bl,%bl
  801fc2:	75 ef                	jne    801fb3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801fc4:	5b                   	pop    %ebx
  801fc5:	5d                   	pop    %ebp
  801fc6:	c3                   	ret    

00801fc7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	53                   	push   %ebx
  801fcb:	83 ec 08             	sub    $0x8,%esp
  801fce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801fd1:	89 1c 24             	mov    %ebx,(%esp)
  801fd4:	e8 97 ff ff ff       	call   801f70 <strlen>
	strcpy(dst + len, src);
  801fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fe0:	01 d8                	add    %ebx,%eax
  801fe2:	89 04 24             	mov    %eax,(%esp)
  801fe5:	e8 bd ff ff ff       	call   801fa7 <strcpy>
	return dst;
}
  801fea:	89 d8                	mov    %ebx,%eax
  801fec:	83 c4 08             	add    $0x8,%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5d                   	pop    %ebp
  801ff1:	c3                   	ret    

00801ff2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	56                   	push   %esi
  801ff6:	53                   	push   %ebx
  801ff7:	8b 75 08             	mov    0x8(%ebp),%esi
  801ffa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ffd:	89 f3                	mov    %esi,%ebx
  801fff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802002:	89 f2                	mov    %esi,%edx
  802004:	eb 0f                	jmp    802015 <strncpy+0x23>
		*dst++ = *src;
  802006:	83 c2 01             	add    $0x1,%edx
  802009:	0f b6 01             	movzbl (%ecx),%eax
  80200c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80200f:	80 39 01             	cmpb   $0x1,(%ecx)
  802012:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802015:	39 da                	cmp    %ebx,%edx
  802017:	75 ed                	jne    802006 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  802019:	89 f0                	mov    %esi,%eax
  80201b:	5b                   	pop    %ebx
  80201c:	5e                   	pop    %esi
  80201d:	5d                   	pop    %ebp
  80201e:	c3                   	ret    

0080201f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	56                   	push   %esi
  802023:	53                   	push   %ebx
  802024:	8b 75 08             	mov    0x8(%ebp),%esi
  802027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202d:	89 f0                	mov    %esi,%eax
  80202f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802033:	85 c9                	test   %ecx,%ecx
  802035:	75 0b                	jne    802042 <strlcpy+0x23>
  802037:	eb 1d                	jmp    802056 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802039:	83 c0 01             	add    $0x1,%eax
  80203c:	83 c2 01             	add    $0x1,%edx
  80203f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802042:	39 d8                	cmp    %ebx,%eax
  802044:	74 0b                	je     802051 <strlcpy+0x32>
  802046:	0f b6 0a             	movzbl (%edx),%ecx
  802049:	84 c9                	test   %cl,%cl
  80204b:	75 ec                	jne    802039 <strlcpy+0x1a>
  80204d:	89 c2                	mov    %eax,%edx
  80204f:	eb 02                	jmp    802053 <strlcpy+0x34>
  802051:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  802053:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  802056:	29 f0                	sub    %esi,%eax
}
  802058:	5b                   	pop    %ebx
  802059:	5e                   	pop    %esi
  80205a:	5d                   	pop    %ebp
  80205b:	c3                   	ret    

0080205c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802062:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802065:	eb 06                	jmp    80206d <strcmp+0x11>
		p++, q++;
  802067:	83 c1 01             	add    $0x1,%ecx
  80206a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80206d:	0f b6 01             	movzbl (%ecx),%eax
  802070:	84 c0                	test   %al,%al
  802072:	74 04                	je     802078 <strcmp+0x1c>
  802074:	3a 02                	cmp    (%edx),%al
  802076:	74 ef                	je     802067 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802078:	0f b6 c0             	movzbl %al,%eax
  80207b:	0f b6 12             	movzbl (%edx),%edx
  80207e:	29 d0                	sub    %edx,%eax
}
  802080:	5d                   	pop    %ebp
  802081:	c3                   	ret    

00802082 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	53                   	push   %ebx
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208c:	89 c3                	mov    %eax,%ebx
  80208e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802091:	eb 06                	jmp    802099 <strncmp+0x17>
		n--, p++, q++;
  802093:	83 c0 01             	add    $0x1,%eax
  802096:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802099:	39 d8                	cmp    %ebx,%eax
  80209b:	74 15                	je     8020b2 <strncmp+0x30>
  80209d:	0f b6 08             	movzbl (%eax),%ecx
  8020a0:	84 c9                	test   %cl,%cl
  8020a2:	74 04                	je     8020a8 <strncmp+0x26>
  8020a4:	3a 0a                	cmp    (%edx),%cl
  8020a6:	74 eb                	je     802093 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020a8:	0f b6 00             	movzbl (%eax),%eax
  8020ab:	0f b6 12             	movzbl (%edx),%edx
  8020ae:	29 d0                	sub    %edx,%eax
  8020b0:	eb 05                	jmp    8020b7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8020b7:	5b                   	pop    %ebx
  8020b8:	5d                   	pop    %ebp
  8020b9:	c3                   	ret    

008020ba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020c4:	eb 07                	jmp    8020cd <strchr+0x13>
		if (*s == c)
  8020c6:	38 ca                	cmp    %cl,%dl
  8020c8:	74 0f                	je     8020d9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020ca:	83 c0 01             	add    $0x1,%eax
  8020cd:	0f b6 10             	movzbl (%eax),%edx
  8020d0:	84 d2                	test   %dl,%dl
  8020d2:	75 f2                	jne    8020c6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8020d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    

008020db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020e5:	eb 07                	jmp    8020ee <strfind+0x13>
		if (*s == c)
  8020e7:	38 ca                	cmp    %cl,%dl
  8020e9:	74 0a                	je     8020f5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020eb:	83 c0 01             	add    $0x1,%eax
  8020ee:	0f b6 10             	movzbl (%eax),%edx
  8020f1:	84 d2                	test   %dl,%dl
  8020f3:	75 f2                	jne    8020e7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8020f5:	5d                   	pop    %ebp
  8020f6:	c3                   	ret    

008020f7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	57                   	push   %edi
  8020fb:	56                   	push   %esi
  8020fc:	53                   	push   %ebx
  8020fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  802100:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802103:	85 c9                	test   %ecx,%ecx
  802105:	74 36                	je     80213d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802107:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80210d:	75 28                	jne    802137 <memset+0x40>
  80210f:	f6 c1 03             	test   $0x3,%cl
  802112:	75 23                	jne    802137 <memset+0x40>
		c &= 0xFF;
  802114:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802118:	89 d3                	mov    %edx,%ebx
  80211a:	c1 e3 08             	shl    $0x8,%ebx
  80211d:	89 d6                	mov    %edx,%esi
  80211f:	c1 e6 18             	shl    $0x18,%esi
  802122:	89 d0                	mov    %edx,%eax
  802124:	c1 e0 10             	shl    $0x10,%eax
  802127:	09 f0                	or     %esi,%eax
  802129:	09 c2                	or     %eax,%edx
  80212b:	89 d0                	mov    %edx,%eax
  80212d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80212f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802132:	fc                   	cld    
  802133:	f3 ab                	rep stos %eax,%es:(%edi)
  802135:	eb 06                	jmp    80213d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	fc                   	cld    
  80213b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80213d:	89 f8                	mov    %edi,%eax
  80213f:	5b                   	pop    %ebx
  802140:	5e                   	pop    %esi
  802141:	5f                   	pop    %edi
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    

00802144 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	57                   	push   %edi
  802148:	56                   	push   %esi
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80214f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802152:	39 c6                	cmp    %eax,%esi
  802154:	73 35                	jae    80218b <memmove+0x47>
  802156:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802159:	39 d0                	cmp    %edx,%eax
  80215b:	73 2e                	jae    80218b <memmove+0x47>
		s += n;
		d += n;
  80215d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802160:	89 d6                	mov    %edx,%esi
  802162:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802164:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80216a:	75 13                	jne    80217f <memmove+0x3b>
  80216c:	f6 c1 03             	test   $0x3,%cl
  80216f:	75 0e                	jne    80217f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802171:	83 ef 04             	sub    $0x4,%edi
  802174:	8d 72 fc             	lea    -0x4(%edx),%esi
  802177:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80217a:	fd                   	std    
  80217b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80217d:	eb 09                	jmp    802188 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80217f:	83 ef 01             	sub    $0x1,%edi
  802182:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802185:	fd                   	std    
  802186:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802188:	fc                   	cld    
  802189:	eb 1d                	jmp    8021a8 <memmove+0x64>
  80218b:	89 f2                	mov    %esi,%edx
  80218d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80218f:	f6 c2 03             	test   $0x3,%dl
  802192:	75 0f                	jne    8021a3 <memmove+0x5f>
  802194:	f6 c1 03             	test   $0x3,%cl
  802197:	75 0a                	jne    8021a3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802199:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80219c:	89 c7                	mov    %eax,%edi
  80219e:	fc                   	cld    
  80219f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8021a1:	eb 05                	jmp    8021a8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8021a3:	89 c7                	mov    %eax,%edi
  8021a5:	fc                   	cld    
  8021a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8021a8:	5e                   	pop    %esi
  8021a9:	5f                   	pop    %edi
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    

008021ac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8021b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	89 04 24             	mov    %eax,(%esp)
  8021c6:	e8 79 ff ff ff       	call   802144 <memmove>
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021d8:	89 d6                	mov    %edx,%esi
  8021da:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021dd:	eb 1a                	jmp    8021f9 <memcmp+0x2c>
		if (*s1 != *s2)
  8021df:	0f b6 02             	movzbl (%edx),%eax
  8021e2:	0f b6 19             	movzbl (%ecx),%ebx
  8021e5:	38 d8                	cmp    %bl,%al
  8021e7:	74 0a                	je     8021f3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8021e9:	0f b6 c0             	movzbl %al,%eax
  8021ec:	0f b6 db             	movzbl %bl,%ebx
  8021ef:	29 d8                	sub    %ebx,%eax
  8021f1:	eb 0f                	jmp    802202 <memcmp+0x35>
		s1++, s2++;
  8021f3:	83 c2 01             	add    $0x1,%edx
  8021f6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021f9:	39 f2                	cmp    %esi,%edx
  8021fb:	75 e2                	jne    8021df <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802202:	5b                   	pop    %ebx
  802203:	5e                   	pop    %esi
  802204:	5d                   	pop    %ebp
  802205:	c3                   	ret    

00802206 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80220f:	89 c2                	mov    %eax,%edx
  802211:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802214:	eb 07                	jmp    80221d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802216:	38 08                	cmp    %cl,(%eax)
  802218:	74 07                	je     802221 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80221a:	83 c0 01             	add    $0x1,%eax
  80221d:	39 d0                	cmp    %edx,%eax
  80221f:	72 f5                	jb     802216 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802221:	5d                   	pop    %ebp
  802222:	c3                   	ret    

00802223 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	57                   	push   %edi
  802227:	56                   	push   %esi
  802228:	53                   	push   %ebx
  802229:	8b 55 08             	mov    0x8(%ebp),%edx
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80222f:	eb 03                	jmp    802234 <strtol+0x11>
		s++;
  802231:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802234:	0f b6 0a             	movzbl (%edx),%ecx
  802237:	80 f9 09             	cmp    $0x9,%cl
  80223a:	74 f5                	je     802231 <strtol+0xe>
  80223c:	80 f9 20             	cmp    $0x20,%cl
  80223f:	74 f0                	je     802231 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802241:	80 f9 2b             	cmp    $0x2b,%cl
  802244:	75 0a                	jne    802250 <strtol+0x2d>
		s++;
  802246:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802249:	bf 00 00 00 00       	mov    $0x0,%edi
  80224e:	eb 11                	jmp    802261 <strtol+0x3e>
  802250:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802255:	80 f9 2d             	cmp    $0x2d,%cl
  802258:	75 07                	jne    802261 <strtol+0x3e>
		s++, neg = 1;
  80225a:	8d 52 01             	lea    0x1(%edx),%edx
  80225d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802261:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802266:	75 15                	jne    80227d <strtol+0x5a>
  802268:	80 3a 30             	cmpb   $0x30,(%edx)
  80226b:	75 10                	jne    80227d <strtol+0x5a>
  80226d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802271:	75 0a                	jne    80227d <strtol+0x5a>
		s += 2, base = 16;
  802273:	83 c2 02             	add    $0x2,%edx
  802276:	b8 10 00 00 00       	mov    $0x10,%eax
  80227b:	eb 10                	jmp    80228d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80227d:	85 c0                	test   %eax,%eax
  80227f:	75 0c                	jne    80228d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802281:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802283:	80 3a 30             	cmpb   $0x30,(%edx)
  802286:	75 05                	jne    80228d <strtol+0x6a>
		s++, base = 8;
  802288:	83 c2 01             	add    $0x1,%edx
  80228b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80228d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802292:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802295:	0f b6 0a             	movzbl (%edx),%ecx
  802298:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80229b:	89 f0                	mov    %esi,%eax
  80229d:	3c 09                	cmp    $0x9,%al
  80229f:	77 08                	ja     8022a9 <strtol+0x86>
			dig = *s - '0';
  8022a1:	0f be c9             	movsbl %cl,%ecx
  8022a4:	83 e9 30             	sub    $0x30,%ecx
  8022a7:	eb 20                	jmp    8022c9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8022a9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8022ac:	89 f0                	mov    %esi,%eax
  8022ae:	3c 19                	cmp    $0x19,%al
  8022b0:	77 08                	ja     8022ba <strtol+0x97>
			dig = *s - 'a' + 10;
  8022b2:	0f be c9             	movsbl %cl,%ecx
  8022b5:	83 e9 57             	sub    $0x57,%ecx
  8022b8:	eb 0f                	jmp    8022c9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8022ba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8022bd:	89 f0                	mov    %esi,%eax
  8022bf:	3c 19                	cmp    $0x19,%al
  8022c1:	77 16                	ja     8022d9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8022c3:	0f be c9             	movsbl %cl,%ecx
  8022c6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8022c9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8022cc:	7d 0f                	jge    8022dd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8022ce:	83 c2 01             	add    $0x1,%edx
  8022d1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8022d5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8022d7:	eb bc                	jmp    802295 <strtol+0x72>
  8022d9:	89 d8                	mov    %ebx,%eax
  8022db:	eb 02                	jmp    8022df <strtol+0xbc>
  8022dd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8022df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022e3:	74 05                	je     8022ea <strtol+0xc7>
		*endptr = (char *) s;
  8022e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022e8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8022ea:	f7 d8                	neg    %eax
  8022ec:	85 ff                	test   %edi,%edi
  8022ee:	0f 44 c3             	cmove  %ebx,%eax
}
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    
  8022f6:	66 90                	xchg   %ax,%ax
  8022f8:	66 90                	xchg   %ax,%ax
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	56                   	push   %esi
  802304:	53                   	push   %ebx
  802305:	83 ec 10             	sub    $0x10,%esp
  802308:	8b 75 08             	mov    0x8(%ebp),%esi
  80230b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  802311:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  802313:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802318:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80231b:	89 04 24             	mov    %eax,(%esp)
  80231e:	e8 e3 e0 ff ff       	call   800406 <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  802323:	85 c0                	test   %eax,%eax
  802325:	75 26                	jne    80234d <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  802327:	85 f6                	test   %esi,%esi
  802329:	74 0a                	je     802335 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80232b:	a1 08 40 80 00       	mov    0x804008,%eax
  802330:	8b 40 74             	mov    0x74(%eax),%eax
  802333:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  802335:	85 db                	test   %ebx,%ebx
  802337:	74 0a                	je     802343 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  802339:	a1 08 40 80 00       	mov    0x804008,%eax
  80233e:	8b 40 78             	mov    0x78(%eax),%eax
  802341:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802343:	a1 08 40 80 00       	mov    0x804008,%eax
  802348:	8b 40 70             	mov    0x70(%eax),%eax
  80234b:	eb 14                	jmp    802361 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  80234d:	85 f6                	test   %esi,%esi
  80234f:	74 06                	je     802357 <ipc_recv+0x57>
			*from_env_store = 0;
  802351:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802357:	85 db                	test   %ebx,%ebx
  802359:	74 06                	je     802361 <ipc_recv+0x61>
			*perm_store = 0;
  80235b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802361:	83 c4 10             	add    $0x10,%esp
  802364:	5b                   	pop    %ebx
  802365:	5e                   	pop    %esi
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    

00802368 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	57                   	push   %edi
  80236c:	56                   	push   %esi
  80236d:	53                   	push   %ebx
  80236e:	83 ec 1c             	sub    $0x1c,%esp
  802371:	8b 7d 08             	mov    0x8(%ebp),%edi
  802374:	8b 75 0c             	mov    0xc(%ebp),%esi
  802377:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80237a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80237c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802381:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802384:	8b 45 14             	mov    0x14(%ebp),%eax
  802387:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80238b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80238f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802393:	89 3c 24             	mov    %edi,(%esp)
  802396:	e8 48 e0 ff ff       	call   8003e3 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80239b:	85 c0                	test   %eax,%eax
  80239d:	74 28                	je     8023c7 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80239f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023a2:	74 1c                	je     8023c0 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  8023a4:	c7 44 24 08 b8 2b 80 	movl   $0x802bb8,0x8(%esp)
  8023ab:	00 
  8023ac:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8023b3:	00 
  8023b4:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  8023bb:	e8 76 f4 ff ff       	call   801836 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  8023c0:	e8 ec dd ff ff       	call   8001b1 <sys_yield>
	}
  8023c5:	eb bd                	jmp    802384 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  8023c7:	83 c4 1c             	add    $0x1c,%esp
  8023ca:	5b                   	pop    %ebx
  8023cb:	5e                   	pop    %esi
  8023cc:	5f                   	pop    %edi
  8023cd:	5d                   	pop    %ebp
  8023ce:	c3                   	ret    

008023cf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023da:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023dd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023e3:	8b 52 50             	mov    0x50(%edx),%edx
  8023e6:	39 ca                	cmp    %ecx,%edx
  8023e8:	75 0d                	jne    8023f7 <ipc_find_env+0x28>
			return envs[i].env_id;
  8023ea:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023ed:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8023f2:	8b 40 40             	mov    0x40(%eax),%eax
  8023f5:	eb 0e                	jmp    802405 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023f7:	83 c0 01             	add    $0x1,%eax
  8023fa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023ff:	75 d9                	jne    8023da <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802401:	66 b8 00 00          	mov    $0x0,%ax
}
  802405:	5d                   	pop    %ebp
  802406:	c3                   	ret    

00802407 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80240d:	89 d0                	mov    %edx,%eax
  80240f:	c1 e8 16             	shr    $0x16,%eax
  802412:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802419:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80241e:	f6 c1 01             	test   $0x1,%cl
  802421:	74 1d                	je     802440 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802423:	c1 ea 0c             	shr    $0xc,%edx
  802426:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80242d:	f6 c2 01             	test   $0x1,%dl
  802430:	74 0e                	je     802440 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802432:	c1 ea 0c             	shr    $0xc,%edx
  802435:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80243c:	ef 
  80243d:	0f b7 c0             	movzwl %ax,%eax
}
  802440:	5d                   	pop    %ebp
  802441:	c3                   	ret    
  802442:	66 90                	xchg   %ax,%ax
  802444:	66 90                	xchg   %ax,%ax
  802446:	66 90                	xchg   %ax,%ax
  802448:	66 90                	xchg   %ax,%ax
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	66 90                	xchg   %ax,%ax
  80244e:	66 90                	xchg   %ax,%ax

00802450 <__udivdi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	8b 44 24 28          	mov    0x28(%esp),%eax
  80245a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80245e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802462:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802466:	85 c0                	test   %eax,%eax
  802468:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80246c:	89 ea                	mov    %ebp,%edx
  80246e:	89 0c 24             	mov    %ecx,(%esp)
  802471:	75 2d                	jne    8024a0 <__udivdi3+0x50>
  802473:	39 e9                	cmp    %ebp,%ecx
  802475:	77 61                	ja     8024d8 <__udivdi3+0x88>
  802477:	85 c9                	test   %ecx,%ecx
  802479:	89 ce                	mov    %ecx,%esi
  80247b:	75 0b                	jne    802488 <__udivdi3+0x38>
  80247d:	b8 01 00 00 00       	mov    $0x1,%eax
  802482:	31 d2                	xor    %edx,%edx
  802484:	f7 f1                	div    %ecx
  802486:	89 c6                	mov    %eax,%esi
  802488:	31 d2                	xor    %edx,%edx
  80248a:	89 e8                	mov    %ebp,%eax
  80248c:	f7 f6                	div    %esi
  80248e:	89 c5                	mov    %eax,%ebp
  802490:	89 f8                	mov    %edi,%eax
  802492:	f7 f6                	div    %esi
  802494:	89 ea                	mov    %ebp,%edx
  802496:	83 c4 0c             	add    $0xc,%esp
  802499:	5e                   	pop    %esi
  80249a:	5f                   	pop    %edi
  80249b:	5d                   	pop    %ebp
  80249c:	c3                   	ret    
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	39 e8                	cmp    %ebp,%eax
  8024a2:	77 24                	ja     8024c8 <__udivdi3+0x78>
  8024a4:	0f bd e8             	bsr    %eax,%ebp
  8024a7:	83 f5 1f             	xor    $0x1f,%ebp
  8024aa:	75 3c                	jne    8024e8 <__udivdi3+0x98>
  8024ac:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024b0:	39 34 24             	cmp    %esi,(%esp)
  8024b3:	0f 86 9f 00 00 00    	jbe    802558 <__udivdi3+0x108>
  8024b9:	39 d0                	cmp    %edx,%eax
  8024bb:	0f 82 97 00 00 00    	jb     802558 <__udivdi3+0x108>
  8024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	31 d2                	xor    %edx,%edx
  8024ca:	31 c0                	xor    %eax,%eax
  8024cc:	83 c4 0c             	add    $0xc,%esp
  8024cf:	5e                   	pop    %esi
  8024d0:	5f                   	pop    %edi
  8024d1:	5d                   	pop    %ebp
  8024d2:	c3                   	ret    
  8024d3:	90                   	nop
  8024d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024d8:	89 f8                	mov    %edi,%eax
  8024da:	f7 f1                	div    %ecx
  8024dc:	31 d2                	xor    %edx,%edx
  8024de:	83 c4 0c             	add    $0xc,%esp
  8024e1:	5e                   	pop    %esi
  8024e2:	5f                   	pop    %edi
  8024e3:	5d                   	pop    %ebp
  8024e4:	c3                   	ret    
  8024e5:	8d 76 00             	lea    0x0(%esi),%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	8b 3c 24             	mov    (%esp),%edi
  8024ed:	d3 e0                	shl    %cl,%eax
  8024ef:	89 c6                	mov    %eax,%esi
  8024f1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024f6:	29 e8                	sub    %ebp,%eax
  8024f8:	89 c1                	mov    %eax,%ecx
  8024fa:	d3 ef                	shr    %cl,%edi
  8024fc:	89 e9                	mov    %ebp,%ecx
  8024fe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802502:	8b 3c 24             	mov    (%esp),%edi
  802505:	09 74 24 08          	or     %esi,0x8(%esp)
  802509:	89 d6                	mov    %edx,%esi
  80250b:	d3 e7                	shl    %cl,%edi
  80250d:	89 c1                	mov    %eax,%ecx
  80250f:	89 3c 24             	mov    %edi,(%esp)
  802512:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802516:	d3 ee                	shr    %cl,%esi
  802518:	89 e9                	mov    %ebp,%ecx
  80251a:	d3 e2                	shl    %cl,%edx
  80251c:	89 c1                	mov    %eax,%ecx
  80251e:	d3 ef                	shr    %cl,%edi
  802520:	09 d7                	or     %edx,%edi
  802522:	89 f2                	mov    %esi,%edx
  802524:	89 f8                	mov    %edi,%eax
  802526:	f7 74 24 08          	divl   0x8(%esp)
  80252a:	89 d6                	mov    %edx,%esi
  80252c:	89 c7                	mov    %eax,%edi
  80252e:	f7 24 24             	mull   (%esp)
  802531:	39 d6                	cmp    %edx,%esi
  802533:	89 14 24             	mov    %edx,(%esp)
  802536:	72 30                	jb     802568 <__udivdi3+0x118>
  802538:	8b 54 24 04          	mov    0x4(%esp),%edx
  80253c:	89 e9                	mov    %ebp,%ecx
  80253e:	d3 e2                	shl    %cl,%edx
  802540:	39 c2                	cmp    %eax,%edx
  802542:	73 05                	jae    802549 <__udivdi3+0xf9>
  802544:	3b 34 24             	cmp    (%esp),%esi
  802547:	74 1f                	je     802568 <__udivdi3+0x118>
  802549:	89 f8                	mov    %edi,%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	e9 7a ff ff ff       	jmp    8024cc <__udivdi3+0x7c>
  802552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802558:	31 d2                	xor    %edx,%edx
  80255a:	b8 01 00 00 00       	mov    $0x1,%eax
  80255f:	e9 68 ff ff ff       	jmp    8024cc <__udivdi3+0x7c>
  802564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802568:	8d 47 ff             	lea    -0x1(%edi),%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	83 c4 0c             	add    $0xc,%esp
  802570:	5e                   	pop    %esi
  802571:	5f                   	pop    %edi
  802572:	5d                   	pop    %ebp
  802573:	c3                   	ret    
  802574:	66 90                	xchg   %ax,%ax
  802576:	66 90                	xchg   %ax,%ax
  802578:	66 90                	xchg   %ax,%ax
  80257a:	66 90                	xchg   %ax,%ax
  80257c:	66 90                	xchg   %ax,%ax
  80257e:	66 90                	xchg   %ax,%ax

00802580 <__umoddi3>:
  802580:	55                   	push   %ebp
  802581:	57                   	push   %edi
  802582:	56                   	push   %esi
  802583:	83 ec 14             	sub    $0x14,%esp
  802586:	8b 44 24 28          	mov    0x28(%esp),%eax
  80258a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80258e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802592:	89 c7                	mov    %eax,%edi
  802594:	89 44 24 04          	mov    %eax,0x4(%esp)
  802598:	8b 44 24 30          	mov    0x30(%esp),%eax
  80259c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025a0:	89 34 24             	mov    %esi,(%esp)
  8025a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	89 c2                	mov    %eax,%edx
  8025ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025af:	75 17                	jne    8025c8 <__umoddi3+0x48>
  8025b1:	39 fe                	cmp    %edi,%esi
  8025b3:	76 4b                	jbe    802600 <__umoddi3+0x80>
  8025b5:	89 c8                	mov    %ecx,%eax
  8025b7:	89 fa                	mov    %edi,%edx
  8025b9:	f7 f6                	div    %esi
  8025bb:	89 d0                	mov    %edx,%eax
  8025bd:	31 d2                	xor    %edx,%edx
  8025bf:	83 c4 14             	add    $0x14,%esp
  8025c2:	5e                   	pop    %esi
  8025c3:	5f                   	pop    %edi
  8025c4:	5d                   	pop    %ebp
  8025c5:	c3                   	ret    
  8025c6:	66 90                	xchg   %ax,%ax
  8025c8:	39 f8                	cmp    %edi,%eax
  8025ca:	77 54                	ja     802620 <__umoddi3+0xa0>
  8025cc:	0f bd e8             	bsr    %eax,%ebp
  8025cf:	83 f5 1f             	xor    $0x1f,%ebp
  8025d2:	75 5c                	jne    802630 <__umoddi3+0xb0>
  8025d4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025d8:	39 3c 24             	cmp    %edi,(%esp)
  8025db:	0f 87 e7 00 00 00    	ja     8026c8 <__umoddi3+0x148>
  8025e1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025e5:	29 f1                	sub    %esi,%ecx
  8025e7:	19 c7                	sbb    %eax,%edi
  8025e9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025f1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025f5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025f9:	83 c4 14             	add    $0x14,%esp
  8025fc:	5e                   	pop    %esi
  8025fd:	5f                   	pop    %edi
  8025fe:	5d                   	pop    %ebp
  8025ff:	c3                   	ret    
  802600:	85 f6                	test   %esi,%esi
  802602:	89 f5                	mov    %esi,%ebp
  802604:	75 0b                	jne    802611 <__umoddi3+0x91>
  802606:	b8 01 00 00 00       	mov    $0x1,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	f7 f6                	div    %esi
  80260f:	89 c5                	mov    %eax,%ebp
  802611:	8b 44 24 04          	mov    0x4(%esp),%eax
  802615:	31 d2                	xor    %edx,%edx
  802617:	f7 f5                	div    %ebp
  802619:	89 c8                	mov    %ecx,%eax
  80261b:	f7 f5                	div    %ebp
  80261d:	eb 9c                	jmp    8025bb <__umoddi3+0x3b>
  80261f:	90                   	nop
  802620:	89 c8                	mov    %ecx,%eax
  802622:	89 fa                	mov    %edi,%edx
  802624:	83 c4 14             	add    $0x14,%esp
  802627:	5e                   	pop    %esi
  802628:	5f                   	pop    %edi
  802629:	5d                   	pop    %ebp
  80262a:	c3                   	ret    
  80262b:	90                   	nop
  80262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802630:	8b 04 24             	mov    (%esp),%eax
  802633:	be 20 00 00 00       	mov    $0x20,%esi
  802638:	89 e9                	mov    %ebp,%ecx
  80263a:	29 ee                	sub    %ebp,%esi
  80263c:	d3 e2                	shl    %cl,%edx
  80263e:	89 f1                	mov    %esi,%ecx
  802640:	d3 e8                	shr    %cl,%eax
  802642:	89 e9                	mov    %ebp,%ecx
  802644:	89 44 24 04          	mov    %eax,0x4(%esp)
  802648:	8b 04 24             	mov    (%esp),%eax
  80264b:	09 54 24 04          	or     %edx,0x4(%esp)
  80264f:	89 fa                	mov    %edi,%edx
  802651:	d3 e0                	shl    %cl,%eax
  802653:	89 f1                	mov    %esi,%ecx
  802655:	89 44 24 08          	mov    %eax,0x8(%esp)
  802659:	8b 44 24 10          	mov    0x10(%esp),%eax
  80265d:	d3 ea                	shr    %cl,%edx
  80265f:	89 e9                	mov    %ebp,%ecx
  802661:	d3 e7                	shl    %cl,%edi
  802663:	89 f1                	mov    %esi,%ecx
  802665:	d3 e8                	shr    %cl,%eax
  802667:	89 e9                	mov    %ebp,%ecx
  802669:	09 f8                	or     %edi,%eax
  80266b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80266f:	f7 74 24 04          	divl   0x4(%esp)
  802673:	d3 e7                	shl    %cl,%edi
  802675:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802679:	89 d7                	mov    %edx,%edi
  80267b:	f7 64 24 08          	mull   0x8(%esp)
  80267f:	39 d7                	cmp    %edx,%edi
  802681:	89 c1                	mov    %eax,%ecx
  802683:	89 14 24             	mov    %edx,(%esp)
  802686:	72 2c                	jb     8026b4 <__umoddi3+0x134>
  802688:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80268c:	72 22                	jb     8026b0 <__umoddi3+0x130>
  80268e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802692:	29 c8                	sub    %ecx,%eax
  802694:	19 d7                	sbb    %edx,%edi
  802696:	89 e9                	mov    %ebp,%ecx
  802698:	89 fa                	mov    %edi,%edx
  80269a:	d3 e8                	shr    %cl,%eax
  80269c:	89 f1                	mov    %esi,%ecx
  80269e:	d3 e2                	shl    %cl,%edx
  8026a0:	89 e9                	mov    %ebp,%ecx
  8026a2:	d3 ef                	shr    %cl,%edi
  8026a4:	09 d0                	or     %edx,%eax
  8026a6:	89 fa                	mov    %edi,%edx
  8026a8:	83 c4 14             	add    $0x14,%esp
  8026ab:	5e                   	pop    %esi
  8026ac:	5f                   	pop    %edi
  8026ad:	5d                   	pop    %ebp
  8026ae:	c3                   	ret    
  8026af:	90                   	nop
  8026b0:	39 d7                	cmp    %edx,%edi
  8026b2:	75 da                	jne    80268e <__umoddi3+0x10e>
  8026b4:	8b 14 24             	mov    (%esp),%edx
  8026b7:	89 c1                	mov    %eax,%ecx
  8026b9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026bd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026c1:	eb cb                	jmp    80268e <__umoddi3+0x10e>
  8026c3:	90                   	nop
  8026c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026cc:	0f 82 0f ff ff ff    	jb     8025e1 <__umoddi3+0x61>
  8026d2:	e9 1a ff ff ff       	jmp    8025f1 <__umoddi3+0x71>
