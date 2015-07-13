
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7e 2b                	jle    800079 <umain+0x46>
  80004e:	c7 44 24 04 80 27 80 	movl   $0x802780,0x4(%esp)
  800055:	00 
  800056:	8b 46 04             	mov    0x4(%esi),%eax
  800059:	89 04 24             	mov    %eax,(%esp)
  80005c:	e8 eb 01 00 00       	call   80024c <strcmp>
void
umain(int argc, char **argv)
{
	int i, nflag;

	nflag = 0;
  800061:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800068:	85 c0                	test   %eax,%eax
  80006a:	75 0d                	jne    800079 <umain+0x46>
		nflag = 1;
		argc--;
  80006c:	83 ef 01             	sub    $0x1,%edi
		argv++;
  80006f:	83 c6 04             	add    $0x4,%esi
{
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
  800072:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  800079:	bb 01 00 00 00       	mov    $0x1,%ebx
  80007e:	eb 46                	jmp    8000c6 <umain+0x93>
		if (i > 1)
  800080:	83 fb 01             	cmp    $0x1,%ebx
  800083:	7e 1c                	jle    8000a1 <umain+0x6e>
			write(1, " ", 1);
  800085:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 83 27 80 	movl   $0x802783,0x4(%esp)
  800094:	00 
  800095:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80009c:	e8 56 0c 00 00       	call   800cf7 <write>
		write(1, argv[i], strlen(argv[i]));
  8000a1:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000a4:	89 04 24             	mov    %eax,(%esp)
  8000a7:	e8 b4 00 00 00       	call   800160 <strlen>
  8000ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b0:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000be:	e8 34 0c 00 00       	call   800cf7 <write>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  8000c3:	83 c3 01             	add    $0x1,%ebx
  8000c6:	39 df                	cmp    %ebx,%edi
  8000c8:	7f b6                	jg     800080 <umain+0x4d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  8000ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000ce:	75 1c                	jne    8000ec <umain+0xb9>
		write(1, "\n", 1);
  8000d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d7:	00 
  8000d8:	c7 44 24 04 9b 28 80 	movl   $0x80289b,0x4(%esp)
  8000df:	00 
  8000e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000e7:	e8 0b 0c 00 00       	call   800cf7 <write>
}
  8000ec:	83 c4 1c             	add    $0x1c,%esp
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 10             	sub    $0x10,%esp
  8000fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	//envid_t envid = sys_getenvid();
	thisenv = &envs[ENVX(sys_getenvid())];
  800102:	e8 c0 04 00 00       	call   8005c7 <sys_getenvid>
  800107:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800114:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800119:	85 db                	test   %ebx,%ebx
  80011b:	7e 07                	jle    800124 <libmain+0x30>
		binaryname = argv[0];
  80011d:	8b 06                	mov    (%esi),%eax
  80011f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800124:	89 74 24 04          	mov    %esi,0x4(%esp)
  800128:	89 1c 24             	mov    %ebx,(%esp)
  80012b:	e8 03 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800130:	e8 07 00 00 00       	call   80013c <exit>
}
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	5b                   	pop    %ebx
  800139:	5e                   	pop    %esi
  80013a:	5d                   	pop    %ebp
  80013b:	c3                   	ret    

0080013c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800142:	e8 a3 09 00 00       	call   800aea <close_all>
	sys_env_destroy(0);
  800147:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014e:	e8 d0 03 00 00       	call   800523 <sys_env_destroy>
}
  800153:	c9                   	leave  
  800154:	c3                   	ret    
  800155:	66 90                	xchg   %ax,%ax
  800157:	66 90                	xchg   %ax,%ax
  800159:	66 90                	xchg   %ax,%ax
  80015b:	66 90                	xchg   %ax,%ax
  80015d:	66 90                	xchg   %ax,%ax
  80015f:	90                   	nop

00800160 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800166:	b8 00 00 00 00       	mov    $0x0,%eax
  80016b:	eb 03                	jmp    800170 <strlen+0x10>
		n++;
  80016d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800170:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800174:	75 f7                	jne    80016d <strlen+0xd>
		n++;
	return n;
}
  800176:	5d                   	pop    %ebp
  800177:	c3                   	ret    

00800178 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800181:	b8 00 00 00 00       	mov    $0x0,%eax
  800186:	eb 03                	jmp    80018b <strnlen+0x13>
		n++;
  800188:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80018b:	39 d0                	cmp    %edx,%eax
  80018d:	74 06                	je     800195 <strnlen+0x1d>
  80018f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800193:	75 f3                	jne    800188 <strnlen+0x10>
		n++;
	return n;
}
  800195:	5d                   	pop    %ebp
  800196:	c3                   	ret    

00800197 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	8b 45 08             	mov    0x8(%ebp),%eax
  80019e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001a1:	89 c2                	mov    %eax,%edx
  8001a3:	83 c2 01             	add    $0x1,%edx
  8001a6:	83 c1 01             	add    $0x1,%ecx
  8001a9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8001ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8001b0:	84 db                	test   %bl,%bl
  8001b2:	75 ef                	jne    8001a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8001b4:	5b                   	pop    %ebx
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	53                   	push   %ebx
  8001bb:	83 ec 08             	sub    $0x8,%esp
  8001be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001c1:	89 1c 24             	mov    %ebx,(%esp)
  8001c4:	e8 97 ff ff ff       	call   800160 <strlen>
	strcpy(dst + len, src);
  8001c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001d0:	01 d8                	add    %ebx,%eax
  8001d2:	89 04 24             	mov    %eax,(%esp)
  8001d5:	e8 bd ff ff ff       	call   800197 <strcpy>
	return dst;
}
  8001da:	89 d8                	mov    %ebx,%eax
  8001dc:	83 c4 08             	add    $0x8,%esp
  8001df:	5b                   	pop    %ebx
  8001e0:	5d                   	pop    %ebp
  8001e1:	c3                   	ret    

008001e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	56                   	push   %esi
  8001e6:	53                   	push   %ebx
  8001e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8001ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ed:	89 f3                	mov    %esi,%ebx
  8001ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001f2:	89 f2                	mov    %esi,%edx
  8001f4:	eb 0f                	jmp    800205 <strncpy+0x23>
		*dst++ = *src;
  8001f6:	83 c2 01             	add    $0x1,%edx
  8001f9:	0f b6 01             	movzbl (%ecx),%eax
  8001fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800202:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800205:	39 da                	cmp    %ebx,%edx
  800207:	75 ed                	jne    8001f6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800209:	89 f0                	mov    %esi,%eax
  80020b:	5b                   	pop    %ebx
  80020c:	5e                   	pop    %esi
  80020d:	5d                   	pop    %ebp
  80020e:	c3                   	ret    

0080020f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	56                   	push   %esi
  800213:	53                   	push   %ebx
  800214:	8b 75 08             	mov    0x8(%ebp),%esi
  800217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80021d:	89 f0                	mov    %esi,%eax
  80021f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800223:	85 c9                	test   %ecx,%ecx
  800225:	75 0b                	jne    800232 <strlcpy+0x23>
  800227:	eb 1d                	jmp    800246 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800229:	83 c0 01             	add    $0x1,%eax
  80022c:	83 c2 01             	add    $0x1,%edx
  80022f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800232:	39 d8                	cmp    %ebx,%eax
  800234:	74 0b                	je     800241 <strlcpy+0x32>
  800236:	0f b6 0a             	movzbl (%edx),%ecx
  800239:	84 c9                	test   %cl,%cl
  80023b:	75 ec                	jne    800229 <strlcpy+0x1a>
  80023d:	89 c2                	mov    %eax,%edx
  80023f:	eb 02                	jmp    800243 <strlcpy+0x34>
  800241:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800243:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800246:	29 f0                	sub    %esi,%eax
}
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    

0080024c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800252:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800255:	eb 06                	jmp    80025d <strcmp+0x11>
		p++, q++;
  800257:	83 c1 01             	add    $0x1,%ecx
  80025a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80025d:	0f b6 01             	movzbl (%ecx),%eax
  800260:	84 c0                	test   %al,%al
  800262:	74 04                	je     800268 <strcmp+0x1c>
  800264:	3a 02                	cmp    (%edx),%al
  800266:	74 ef                	je     800257 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800268:	0f b6 c0             	movzbl %al,%eax
  80026b:	0f b6 12             	movzbl (%edx),%edx
  80026e:	29 d0                	sub    %edx,%eax
}
  800270:	5d                   	pop    %ebp
  800271:	c3                   	ret    

00800272 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	53                   	push   %ebx
  800276:	8b 45 08             	mov    0x8(%ebp),%eax
  800279:	8b 55 0c             	mov    0xc(%ebp),%edx
  80027c:	89 c3                	mov    %eax,%ebx
  80027e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800281:	eb 06                	jmp    800289 <strncmp+0x17>
		n--, p++, q++;
  800283:	83 c0 01             	add    $0x1,%eax
  800286:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800289:	39 d8                	cmp    %ebx,%eax
  80028b:	74 15                	je     8002a2 <strncmp+0x30>
  80028d:	0f b6 08             	movzbl (%eax),%ecx
  800290:	84 c9                	test   %cl,%cl
  800292:	74 04                	je     800298 <strncmp+0x26>
  800294:	3a 0a                	cmp    (%edx),%cl
  800296:	74 eb                	je     800283 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800298:	0f b6 00             	movzbl (%eax),%eax
  80029b:	0f b6 12             	movzbl (%edx),%edx
  80029e:	29 d0                	sub    %edx,%eax
  8002a0:	eb 05                	jmp    8002a7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8002a2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8002a7:	5b                   	pop    %ebx
  8002a8:	5d                   	pop    %ebp
  8002a9:	c3                   	ret    

008002aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002b4:	eb 07                	jmp    8002bd <strchr+0x13>
		if (*s == c)
  8002b6:	38 ca                	cmp    %cl,%dl
  8002b8:	74 0f                	je     8002c9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8002ba:	83 c0 01             	add    $0x1,%eax
  8002bd:	0f b6 10             	movzbl (%eax),%edx
  8002c0:	84 d2                	test   %dl,%dl
  8002c2:	75 f2                	jne    8002b6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8002c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    

008002cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002d5:	eb 07                	jmp    8002de <strfind+0x13>
		if (*s == c)
  8002d7:	38 ca                	cmp    %cl,%dl
  8002d9:	74 0a                	je     8002e5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8002db:	83 c0 01             	add    $0x1,%eax
  8002de:	0f b6 10             	movzbl (%eax),%edx
  8002e1:	84 d2                	test   %dl,%dl
  8002e3:	75 f2                	jne    8002d7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8002e5:	5d                   	pop    %ebp
  8002e6:	c3                   	ret    

008002e7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	57                   	push   %edi
  8002eb:	56                   	push   %esi
  8002ec:	53                   	push   %ebx
  8002ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002f3:	85 c9                	test   %ecx,%ecx
  8002f5:	74 36                	je     80032d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002f7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8002fd:	75 28                	jne    800327 <memset+0x40>
  8002ff:	f6 c1 03             	test   $0x3,%cl
  800302:	75 23                	jne    800327 <memset+0x40>
		c &= 0xFF;
  800304:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800308:	89 d3                	mov    %edx,%ebx
  80030a:	c1 e3 08             	shl    $0x8,%ebx
  80030d:	89 d6                	mov    %edx,%esi
  80030f:	c1 e6 18             	shl    $0x18,%esi
  800312:	89 d0                	mov    %edx,%eax
  800314:	c1 e0 10             	shl    $0x10,%eax
  800317:	09 f0                	or     %esi,%eax
  800319:	09 c2                	or     %eax,%edx
  80031b:	89 d0                	mov    %edx,%eax
  80031d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80031f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800322:	fc                   	cld    
  800323:	f3 ab                	rep stos %eax,%es:(%edi)
  800325:	eb 06                	jmp    80032d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	fc                   	cld    
  80032b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80032d:	89 f8                	mov    %edi,%eax
  80032f:	5b                   	pop    %ebx
  800330:	5e                   	pop    %esi
  800331:	5f                   	pop    %edi
  800332:	5d                   	pop    %ebp
  800333:	c3                   	ret    

00800334 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	57                   	push   %edi
  800338:	56                   	push   %esi
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80033f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800342:	39 c6                	cmp    %eax,%esi
  800344:	73 35                	jae    80037b <memmove+0x47>
  800346:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800349:	39 d0                	cmp    %edx,%eax
  80034b:	73 2e                	jae    80037b <memmove+0x47>
		s += n;
		d += n;
  80034d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800350:	89 d6                	mov    %edx,%esi
  800352:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800354:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80035a:	75 13                	jne    80036f <memmove+0x3b>
  80035c:	f6 c1 03             	test   $0x3,%cl
  80035f:	75 0e                	jne    80036f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800361:	83 ef 04             	sub    $0x4,%edi
  800364:	8d 72 fc             	lea    -0x4(%edx),%esi
  800367:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80036a:	fd                   	std    
  80036b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80036d:	eb 09                	jmp    800378 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80036f:	83 ef 01             	sub    $0x1,%edi
  800372:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800375:	fd                   	std    
  800376:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800378:	fc                   	cld    
  800379:	eb 1d                	jmp    800398 <memmove+0x64>
  80037b:	89 f2                	mov    %esi,%edx
  80037d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80037f:	f6 c2 03             	test   $0x3,%dl
  800382:	75 0f                	jne    800393 <memmove+0x5f>
  800384:	f6 c1 03             	test   $0x3,%cl
  800387:	75 0a                	jne    800393 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800389:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	fc                   	cld    
  80038f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800391:	eb 05                	jmp    800398 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800393:	89 c7                	mov    %eax,%edi
  800395:	fc                   	cld    
  800396:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800398:	5e                   	pop    %esi
  800399:	5f                   	pop    %edi
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8003a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	89 04 24             	mov    %eax,(%esp)
  8003b6:	e8 79 ff ff ff       	call   800334 <memmove>
}
  8003bb:	c9                   	leave  
  8003bc:	c3                   	ret    

008003bd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	56                   	push   %esi
  8003c1:	53                   	push   %ebx
  8003c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c8:	89 d6                	mov    %edx,%esi
  8003ca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003cd:	eb 1a                	jmp    8003e9 <memcmp+0x2c>
		if (*s1 != *s2)
  8003cf:	0f b6 02             	movzbl (%edx),%eax
  8003d2:	0f b6 19             	movzbl (%ecx),%ebx
  8003d5:	38 d8                	cmp    %bl,%al
  8003d7:	74 0a                	je     8003e3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8003d9:	0f b6 c0             	movzbl %al,%eax
  8003dc:	0f b6 db             	movzbl %bl,%ebx
  8003df:	29 d8                	sub    %ebx,%eax
  8003e1:	eb 0f                	jmp    8003f2 <memcmp+0x35>
		s1++, s2++;
  8003e3:	83 c2 01             	add    $0x1,%edx
  8003e6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003e9:	39 f2                	cmp    %esi,%edx
  8003eb:	75 e2                	jne    8003cf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8003ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003f2:	5b                   	pop    %ebx
  8003f3:	5e                   	pop    %esi
  8003f4:	5d                   	pop    %ebp
  8003f5:	c3                   	ret    

008003f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8003ff:	89 c2                	mov    %eax,%edx
  800401:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800404:	eb 07                	jmp    80040d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800406:	38 08                	cmp    %cl,(%eax)
  800408:	74 07                	je     800411 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80040a:	83 c0 01             	add    $0x1,%eax
  80040d:	39 d0                	cmp    %edx,%eax
  80040f:	72 f5                	jb     800406 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800411:	5d                   	pop    %ebp
  800412:	c3                   	ret    

00800413 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
  800416:	57                   	push   %edi
  800417:	56                   	push   %esi
  800418:	53                   	push   %ebx
  800419:	8b 55 08             	mov    0x8(%ebp),%edx
  80041c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80041f:	eb 03                	jmp    800424 <strtol+0x11>
		s++;
  800421:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800424:	0f b6 0a             	movzbl (%edx),%ecx
  800427:	80 f9 09             	cmp    $0x9,%cl
  80042a:	74 f5                	je     800421 <strtol+0xe>
  80042c:	80 f9 20             	cmp    $0x20,%cl
  80042f:	74 f0                	je     800421 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800431:	80 f9 2b             	cmp    $0x2b,%cl
  800434:	75 0a                	jne    800440 <strtol+0x2d>
		s++;
  800436:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800439:	bf 00 00 00 00       	mov    $0x0,%edi
  80043e:	eb 11                	jmp    800451 <strtol+0x3e>
  800440:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800445:	80 f9 2d             	cmp    $0x2d,%cl
  800448:	75 07                	jne    800451 <strtol+0x3e>
		s++, neg = 1;
  80044a:	8d 52 01             	lea    0x1(%edx),%edx
  80044d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800451:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800456:	75 15                	jne    80046d <strtol+0x5a>
  800458:	80 3a 30             	cmpb   $0x30,(%edx)
  80045b:	75 10                	jne    80046d <strtol+0x5a>
  80045d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800461:	75 0a                	jne    80046d <strtol+0x5a>
		s += 2, base = 16;
  800463:	83 c2 02             	add    $0x2,%edx
  800466:	b8 10 00 00 00       	mov    $0x10,%eax
  80046b:	eb 10                	jmp    80047d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80046d:	85 c0                	test   %eax,%eax
  80046f:	75 0c                	jne    80047d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800471:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800473:	80 3a 30             	cmpb   $0x30,(%edx)
  800476:	75 05                	jne    80047d <strtol+0x6a>
		s++, base = 8;
  800478:	83 c2 01             	add    $0x1,%edx
  80047b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80047d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800482:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800485:	0f b6 0a             	movzbl (%edx),%ecx
  800488:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80048b:	89 f0                	mov    %esi,%eax
  80048d:	3c 09                	cmp    $0x9,%al
  80048f:	77 08                	ja     800499 <strtol+0x86>
			dig = *s - '0';
  800491:	0f be c9             	movsbl %cl,%ecx
  800494:	83 e9 30             	sub    $0x30,%ecx
  800497:	eb 20                	jmp    8004b9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800499:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80049c:	89 f0                	mov    %esi,%eax
  80049e:	3c 19                	cmp    $0x19,%al
  8004a0:	77 08                	ja     8004aa <strtol+0x97>
			dig = *s - 'a' + 10;
  8004a2:	0f be c9             	movsbl %cl,%ecx
  8004a5:	83 e9 57             	sub    $0x57,%ecx
  8004a8:	eb 0f                	jmp    8004b9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8004aa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8004ad:	89 f0                	mov    %esi,%eax
  8004af:	3c 19                	cmp    $0x19,%al
  8004b1:	77 16                	ja     8004c9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8004b3:	0f be c9             	movsbl %cl,%ecx
  8004b6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8004b9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8004bc:	7d 0f                	jge    8004cd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8004be:	83 c2 01             	add    $0x1,%edx
  8004c1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8004c5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8004c7:	eb bc                	jmp    800485 <strtol+0x72>
  8004c9:	89 d8                	mov    %ebx,%eax
  8004cb:	eb 02                	jmp    8004cf <strtol+0xbc>
  8004cd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8004cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d3:	74 05                	je     8004da <strtol+0xc7>
		*endptr = (char *) s;
  8004d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004d8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8004da:	f7 d8                	neg    %eax
  8004dc:	85 ff                	test   %edi,%edi
  8004de:	0f 44 c3             	cmove  %ebx,%eax
}
  8004e1:	5b                   	pop    %ebx
  8004e2:	5e                   	pop    %esi
  8004e3:	5f                   	pop    %edi
  8004e4:	5d                   	pop    %ebp
  8004e5:	c3                   	ret    

008004e6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	57                   	push   %edi
  8004ea:	56                   	push   %esi
  8004eb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f7:	89 c3                	mov    %eax,%ebx
  8004f9:	89 c7                	mov    %eax,%edi
  8004fb:	89 c6                	mov    %eax,%esi
  8004fd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8004ff:	5b                   	pop    %ebx
  800500:	5e                   	pop    %esi
  800501:	5f                   	pop    %edi
  800502:	5d                   	pop    %ebp
  800503:	c3                   	ret    

00800504 <sys_cgetc>:

int
sys_cgetc(void)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	57                   	push   %edi
  800508:	56                   	push   %esi
  800509:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80050a:	ba 00 00 00 00       	mov    $0x0,%edx
  80050f:	b8 01 00 00 00       	mov    $0x1,%eax
  800514:	89 d1                	mov    %edx,%ecx
  800516:	89 d3                	mov    %edx,%ebx
  800518:	89 d7                	mov    %edx,%edi
  80051a:	89 d6                	mov    %edx,%esi
  80051c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80051e:	5b                   	pop    %ebx
  80051f:	5e                   	pop    %esi
  800520:	5f                   	pop    %edi
  800521:	5d                   	pop    %ebp
  800522:	c3                   	ret    

00800523 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	57                   	push   %edi
  800527:	56                   	push   %esi
  800528:	53                   	push   %ebx
  800529:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80052c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800531:	b8 03 00 00 00       	mov    $0x3,%eax
  800536:	8b 55 08             	mov    0x8(%ebp),%edx
  800539:	89 cb                	mov    %ecx,%ebx
  80053b:	89 cf                	mov    %ecx,%edi
  80053d:	89 ce                	mov    %ecx,%esi
  80053f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800541:	85 c0                	test   %eax,%eax
  800543:	7e 28                	jle    80056d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800545:	89 44 24 10          	mov    %eax,0x10(%esp)
  800549:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800550:	00 
  800551:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  800558:	00 
  800559:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800560:	00 
  800561:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  800568:	e8 f9 16 00 00       	call   801c66 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80056d:	83 c4 2c             	add    $0x2c,%esp
  800570:	5b                   	pop    %ebx
  800571:	5e                   	pop    %esi
  800572:	5f                   	pop    %edi
  800573:	5d                   	pop    %ebp
  800574:	c3                   	ret    

00800575 <sys_env_cleanup>:

int
sys_env_cleanup(envid_t envid)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	57                   	push   %edi
  800579:	56                   	push   %esi
  80057a:	53                   	push   %ebx
  80057b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80057e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800583:	b8 04 00 00 00       	mov    $0x4,%eax
  800588:	8b 55 08             	mov    0x8(%ebp),%edx
  80058b:	89 cb                	mov    %ecx,%ebx
  80058d:	89 cf                	mov    %ecx,%edi
  80058f:	89 ce                	mov    %ecx,%esi
  800591:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800593:	85 c0                	test   %eax,%eax
  800595:	7e 28                	jle    8005bf <sys_env_cleanup+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800597:	89 44 24 10          	mov    %eax,0x10(%esp)
  80059b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8005a2:	00 
  8005a3:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  8005aa:	00 
  8005ab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8005b2:	00 
  8005b3:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  8005ba:	e8 a7 16 00 00       	call   801c66 <_panic>

int
sys_env_cleanup(envid_t envid)
{
	return syscall(SYS_env_cleanup, 1, envid, 0, 0, 0, 0);
}
  8005bf:	83 c4 2c             	add    $0x2c,%esp
  8005c2:	5b                   	pop    %ebx
  8005c3:	5e                   	pop    %esi
  8005c4:	5f                   	pop    %edi
  8005c5:	5d                   	pop    %ebp
  8005c6:	c3                   	ret    

008005c7 <sys_getenvid>:


envid_t
sys_getenvid(void)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	57                   	push   %edi
  8005cb:	56                   	push   %esi
  8005cc:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d2:	b8 02 00 00 00       	mov    $0x2,%eax
  8005d7:	89 d1                	mov    %edx,%ecx
  8005d9:	89 d3                	mov    %edx,%ebx
  8005db:	89 d7                	mov    %edx,%edi
  8005dd:	89 d6                	mov    %edx,%esi
  8005df:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8005e1:	5b                   	pop    %ebx
  8005e2:	5e                   	pop    %esi
  8005e3:	5f                   	pop    %edi
  8005e4:	5d                   	pop    %ebp
  8005e5:	c3                   	ret    

008005e6 <sys_yield>:

void
sys_yield(void)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	57                   	push   %edi
  8005ea:	56                   	push   %esi
  8005eb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8005f6:	89 d1                	mov    %edx,%ecx
  8005f8:	89 d3                	mov    %edx,%ebx
  8005fa:	89 d7                	mov    %edx,%edi
  8005fc:	89 d6                	mov    %edx,%esi
  8005fe:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800600:	5b                   	pop    %ebx
  800601:	5e                   	pop    %esi
  800602:	5f                   	pop    %edi
  800603:	5d                   	pop    %ebp
  800604:	c3                   	ret    

00800605 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800605:	55                   	push   %ebp
  800606:	89 e5                	mov    %esp,%ebp
  800608:	57                   	push   %edi
  800609:	56                   	push   %esi
  80060a:	53                   	push   %ebx
  80060b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80060e:	be 00 00 00 00       	mov    $0x0,%esi
  800613:	b8 05 00 00 00       	mov    $0x5,%eax
  800618:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80061b:	8b 55 08             	mov    0x8(%ebp),%edx
  80061e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800621:	89 f7                	mov    %esi,%edi
  800623:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800625:	85 c0                	test   %eax,%eax
  800627:	7e 28                	jle    800651 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800629:	89 44 24 10          	mov    %eax,0x10(%esp)
  80062d:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800634:	00 
  800635:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  80063c:	00 
  80063d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800644:	00 
  800645:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  80064c:	e8 15 16 00 00       	call   801c66 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800651:	83 c4 2c             	add    $0x2c,%esp
  800654:	5b                   	pop    %ebx
  800655:	5e                   	pop    %esi
  800656:	5f                   	pop    %edi
  800657:	5d                   	pop    %ebp
  800658:	c3                   	ret    

00800659 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
  80065c:	57                   	push   %edi
  80065d:	56                   	push   %esi
  80065e:	53                   	push   %ebx
  80065f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800662:	b8 06 00 00 00       	mov    $0x6,%eax
  800667:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80066a:	8b 55 08             	mov    0x8(%ebp),%edx
  80066d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800670:	8b 7d 14             	mov    0x14(%ebp),%edi
  800673:	8b 75 18             	mov    0x18(%ebp),%esi
  800676:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800678:	85 c0                	test   %eax,%eax
  80067a:	7e 28                	jle    8006a4 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80067c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800680:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800687:	00 
  800688:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  80068f:	00 
  800690:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800697:	00 
  800698:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  80069f:	e8 c2 15 00 00       	call   801c66 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8006a4:	83 c4 2c             	add    $0x2c,%esp
  8006a7:	5b                   	pop    %ebx
  8006a8:	5e                   	pop    %esi
  8006a9:	5f                   	pop    %edi
  8006aa:	5d                   	pop    %ebp
  8006ab:	c3                   	ret    

008006ac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
  8006af:	57                   	push   %edi
  8006b0:	56                   	push   %esi
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ba:	b8 07 00 00 00       	mov    $0x7,%eax
  8006bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c5:	89 df                	mov    %ebx,%edi
  8006c7:	89 de                	mov    %ebx,%esi
  8006c9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8006cb:	85 c0                	test   %eax,%eax
  8006cd:	7e 28                	jle    8006f7 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8006cf:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006d3:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8006da:	00 
  8006db:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  8006e2:	00 
  8006e3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8006ea:	00 
  8006eb:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  8006f2:	e8 6f 15 00 00       	call   801c66 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8006f7:	83 c4 2c             	add    $0x2c,%esp
  8006fa:	5b                   	pop    %ebx
  8006fb:	5e                   	pop    %esi
  8006fc:	5f                   	pop    %edi
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    

008006ff <sys_share_pages>:

int sys_share_pages(envid_t dst_envid)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	57                   	push   %edi
  800703:	56                   	push   %esi
  800704:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800705:	b9 00 00 00 00       	mov    $0x0,%ecx
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
  80070f:	8b 55 08             	mov    0x8(%ebp),%edx
  800712:	89 cb                	mov    %ecx,%ebx
  800714:	89 cf                	mov    %ecx,%edi
  800716:	89 ce                	mov    %ecx,%esi
  800718:	cd 30                	int    $0x30
}

int sys_share_pages(envid_t dst_envid)
{
	return syscall(SYS_share_pages, 0, dst_envid, 0, 0, 0, 0);
}
  80071a:	5b                   	pop    %ebx
  80071b:	5e                   	pop    %esi
  80071c:	5f                   	pop    %edi
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	57                   	push   %edi
  800723:	56                   	push   %esi
  800724:	53                   	push   %ebx
  800725:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800728:	bb 00 00 00 00       	mov    $0x0,%ebx
  80072d:	b8 09 00 00 00       	mov    $0x9,%eax
  800732:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800735:	8b 55 08             	mov    0x8(%ebp),%edx
  800738:	89 df                	mov    %ebx,%edi
  80073a:	89 de                	mov    %ebx,%esi
  80073c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80073e:	85 c0                	test   %eax,%eax
  800740:	7e 28                	jle    80076a <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800742:	89 44 24 10          	mov    %eax,0x10(%esp)
  800746:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80074d:	00 
  80074e:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  800755:	00 
  800756:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80075d:	00 
  80075e:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  800765:	e8 fc 14 00 00       	call   801c66 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80076a:	83 c4 2c             	add    $0x2c,%esp
  80076d:	5b                   	pop    %ebx
  80076e:	5e                   	pop    %esi
  80076f:	5f                   	pop    %edi
  800770:	5d                   	pop    %ebp
  800771:	c3                   	ret    

00800772 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	57                   	push   %edi
  800776:	56                   	push   %esi
  800777:	53                   	push   %ebx
  800778:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80077b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800780:	b8 0a 00 00 00       	mov    $0xa,%eax
  800785:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800788:	8b 55 08             	mov    0x8(%ebp),%edx
  80078b:	89 df                	mov    %ebx,%edi
  80078d:	89 de                	mov    %ebx,%esi
  80078f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800791:	85 c0                	test   %eax,%eax
  800793:	7e 28                	jle    8007bd <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800795:	89 44 24 10          	mov    %eax,0x10(%esp)
  800799:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8007a0:	00 
  8007a1:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  8007a8:	00 
  8007a9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8007b0:	00 
  8007b1:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  8007b8:	e8 a9 14 00 00       	call   801c66 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8007bd:	83 c4 2c             	add    $0x2c,%esp
  8007c0:	5b                   	pop    %ebx
  8007c1:	5e                   	pop    %esi
  8007c2:	5f                   	pop    %edi
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	57                   	push   %edi
  8007c9:	56                   	push   %esi
  8007ca:	53                   	push   %ebx
  8007cb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007d3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8007d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007db:	8b 55 08             	mov    0x8(%ebp),%edx
  8007de:	89 df                	mov    %ebx,%edi
  8007e0:	89 de                	mov    %ebx,%esi
  8007e2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8007e4:	85 c0                	test   %eax,%eax
  8007e6:	7e 28                	jle    800810 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8007e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007ec:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8007f3:	00 
  8007f4:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  8007fb:	00 
  8007fc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800803:	00 
  800804:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  80080b:	e8 56 14 00 00       	call   801c66 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800810:	83 c4 2c             	add    $0x2c,%esp
  800813:	5b                   	pop    %ebx
  800814:	5e                   	pop    %esi
  800815:	5f                   	pop    %edi
  800816:	5d                   	pop    %ebp
  800817:	c3                   	ret    

00800818 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	57                   	push   %edi
  80081c:	56                   	push   %esi
  80081d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80081e:	be 00 00 00 00       	mov    $0x0,%esi
  800823:	b8 0d 00 00 00       	mov    $0xd,%eax
  800828:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082b:	8b 55 08             	mov    0x8(%ebp),%edx
  80082e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800831:	8b 7d 14             	mov    0x14(%ebp),%edi
  800834:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800836:	5b                   	pop    %ebx
  800837:	5e                   	pop    %esi
  800838:	5f                   	pop    %edi
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    

0080083b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	57                   	push   %edi
  80083f:	56                   	push   %esi
  800840:	53                   	push   %ebx
  800841:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800844:	b9 00 00 00 00       	mov    $0x0,%ecx
  800849:	b8 0e 00 00 00       	mov    $0xe,%eax
  80084e:	8b 55 08             	mov    0x8(%ebp),%edx
  800851:	89 cb                	mov    %ecx,%ebx
  800853:	89 cf                	mov    %ecx,%edi
  800855:	89 ce                	mov    %ecx,%esi
  800857:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800859:	85 c0                	test   %eax,%eax
  80085b:	7e 28                	jle    800885 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80085d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800861:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  800868:	00 
  800869:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  800870:	00 
  800871:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800878:	00 
  800879:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  800880:	e8 e1 13 00 00       	call   801c66 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800885:	83 c4 2c             	add    $0x2c,%esp
  800888:	5b                   	pop    %ebx
  800889:	5e                   	pop    %esi
  80088a:	5f                   	pop    %edi
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	57                   	push   %edi
  800891:	56                   	push   %esi
  800892:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	b8 0f 00 00 00       	mov    $0xf,%eax
  80089d:	89 d1                	mov    %edx,%ecx
  80089f:	89 d3                	mov    %edx,%ebx
  8008a1:	89 d7                	mov    %edx,%edi
  8008a3:	89 d6                	mov    %edx,%esi
  8008a5:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8008a7:	5b                   	pop    %ebx
  8008a8:	5e                   	pop    %esi
  8008a9:	5f                   	pop    %edi
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <sys_tx_packet>:

int sys_tx_packet(const char *data, size_t len)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	57                   	push   %edi
  8008b0:	56                   	push   %esi
  8008b1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008b7:	b8 11 00 00 00       	mov    $0x11,%eax
  8008bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c2:	89 df                	mov    %ebx,%edi
  8008c4:	89 de                	mov    %ebx,%esi
  8008c6:	cd 30                	int    $0x30
}

int sys_tx_packet(const char *data, size_t len)
{
	return syscall(SYS_tx_packet, 0, (uint32_t)data, len, 0, 0, 0);
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5e                   	pop    %esi
  8008ca:	5f                   	pop    %edi
  8008cb:	5d                   	pop    %ebp
  8008cc:	c3                   	ret    

008008cd <sys_rx_packet>:

int sys_rx_packet(void *req, int *len)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	57                   	push   %edi
  8008d1:	56                   	push   %esi
  8008d2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008d8:	b8 12 00 00 00       	mov    $0x12,%eax
  8008dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e3:	89 df                	mov    %ebx,%edi
  8008e5:	89 de                	mov    %ebx,%esi
  8008e7:	cd 30                	int    $0x30
}

int sys_rx_packet(void *req, int *len)
{
	return syscall(SYS_rx_packet, 0, (uint32_t)req,(uint32_t)len , 0, 0, 0);
}
  8008e9:	5b                   	pop    %ebx
  8008ea:	5e                   	pop    %esi
  8008eb:	5f                   	pop    %edi
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    

008008ee <sys_read_mac>:

int sys_read_mac(uint8_t *data)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	57                   	push   %edi
  8008f2:	56                   	push   %esi
  8008f3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008f9:	b8 13 00 00 00       	mov    $0x13,%eax
  8008fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800901:	89 cb                	mov    %ecx,%ebx
  800903:	89 cf                	mov    %ecx,%edi
  800905:	89 ce                	mov    %ecx,%esi
  800907:	cd 30                	int    $0x30
}

int sys_read_mac(uint8_t *data)
{
	return syscall(SYS_read_mac, 0, (uint32_t)data, 0, 0, 0, 0);
  800909:	5b                   	pop    %ebx
  80090a:	5e                   	pop    %esi
  80090b:	5f                   	pop    %edi
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    
  80090e:	66 90                	xchg   %ax,%ax

00800910 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	05 00 00 00 30       	add    $0x30000000,%eax
  80091b:	c1 e8 0c             	shr    $0xc,%eax
}
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80092b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800930:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800942:	89 c2                	mov    %eax,%edx
  800944:	c1 ea 16             	shr    $0x16,%edx
  800947:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80094e:	f6 c2 01             	test   $0x1,%dl
  800951:	74 11                	je     800964 <fd_alloc+0x2d>
  800953:	89 c2                	mov    %eax,%edx
  800955:	c1 ea 0c             	shr    $0xc,%edx
  800958:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80095f:	f6 c2 01             	test   $0x1,%dl
  800962:	75 09                	jne    80096d <fd_alloc+0x36>
			*fd_store = fd;
  800964:	89 01                	mov    %eax,(%ecx)
			return 0;
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
  80096b:	eb 17                	jmp    800984 <fd_alloc+0x4d>
  80096d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800972:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800977:	75 c9                	jne    800942 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800979:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80097f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    

00800986 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80098c:	83 f8 1f             	cmp    $0x1f,%eax
  80098f:	77 36                	ja     8009c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800991:	c1 e0 0c             	shl    $0xc,%eax
  800994:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800999:	89 c2                	mov    %eax,%edx
  80099b:	c1 ea 16             	shr    $0x16,%edx
  80099e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8009a5:	f6 c2 01             	test   $0x1,%dl
  8009a8:	74 24                	je     8009ce <fd_lookup+0x48>
  8009aa:	89 c2                	mov    %eax,%edx
  8009ac:	c1 ea 0c             	shr    $0xc,%edx
  8009af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8009b6:	f6 c2 01             	test   $0x1,%dl
  8009b9:	74 1a                	je     8009d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8009bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009be:	89 02                	mov    %eax,(%edx)
	return 0;
  8009c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c5:	eb 13                	jmp    8009da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8009c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009cc:	eb 0c                	jmp    8009da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8009ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d3:	eb 05                	jmp    8009da <fd_lookup+0x54>
  8009d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 18             	sub    $0x18,%esp
  8009e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8009e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ea:	eb 13                	jmp    8009ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8009ec:	39 08                	cmp    %ecx,(%eax)
  8009ee:	75 0c                	jne    8009fc <dev_lookup+0x20>
			*dev = devtab[i];
  8009f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8009f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fa:	eb 38                	jmp    800a34 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8009fc:	83 c2 01             	add    $0x1,%edx
  8009ff:	8b 04 95 38 28 80 00 	mov    0x802838(,%edx,4),%eax
  800a06:	85 c0                	test   %eax,%eax
  800a08:	75 e2                	jne    8009ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800a0a:	a1 08 40 80 00       	mov    0x804008,%eax
  800a0f:	8b 40 48             	mov    0x48(%eax),%eax
  800a12:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a1a:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  800a21:	e8 39 13 00 00       	call   801d5f <cprintf>
	*dev = 0;
  800a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800a2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800a34:	c9                   	leave  
  800a35:	c3                   	ret    

00800a36 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	56                   	push   %esi
  800a3a:	53                   	push   %ebx
  800a3b:	83 ec 20             	sub    $0x20,%esp
  800a3e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800a44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a47:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800a4b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800a51:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800a54:	89 04 24             	mov    %eax,(%esp)
  800a57:	e8 2a ff ff ff       	call   800986 <fd_lookup>
  800a5c:	85 c0                	test   %eax,%eax
  800a5e:	78 05                	js     800a65 <fd_close+0x2f>
	    || fd != fd2)
  800a60:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800a63:	74 0c                	je     800a71 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800a65:	84 db                	test   %bl,%bl
  800a67:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6c:	0f 44 c2             	cmove  %edx,%eax
  800a6f:	eb 3f                	jmp    800ab0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800a71:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a74:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a78:	8b 06                	mov    (%esi),%eax
  800a7a:	89 04 24             	mov    %eax,(%esp)
  800a7d:	e8 5a ff ff ff       	call   8009dc <dev_lookup>
  800a82:	89 c3                	mov    %eax,%ebx
  800a84:	85 c0                	test   %eax,%eax
  800a86:	78 16                	js     800a9e <fd_close+0x68>
		if (dev->dev_close)
  800a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800a8e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800a93:	85 c0                	test   %eax,%eax
  800a95:	74 07                	je     800a9e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800a97:	89 34 24             	mov    %esi,(%esp)
  800a9a:	ff d0                	call   *%eax
  800a9c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800a9e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800aa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800aa9:	e8 fe fb ff ff       	call   8006ac <sys_page_unmap>
	return r;
  800aae:	89 d8                	mov    %ebx,%eax
}
  800ab0:	83 c4 20             	add    $0x20,%esp
  800ab3:	5b                   	pop    %ebx
  800ab4:	5e                   	pop    %esi
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800abd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	89 04 24             	mov    %eax,(%esp)
  800aca:	e8 b7 fe ff ff       	call   800986 <fd_lookup>
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	85 d2                	test   %edx,%edx
  800ad3:	78 13                	js     800ae8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800ad5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800adc:	00 
  800add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae0:	89 04 24             	mov    %eax,(%esp)
  800ae3:	e8 4e ff ff ff       	call   800a36 <fd_close>
}
  800ae8:	c9                   	leave  
  800ae9:	c3                   	ret    

00800aea <close_all>:

void
close_all(void)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	53                   	push   %ebx
  800aee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800af1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800af6:	89 1c 24             	mov    %ebx,(%esp)
  800af9:	e8 b9 ff ff ff       	call   800ab7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800afe:	83 c3 01             	add    $0x1,%ebx
  800b01:	83 fb 20             	cmp    $0x20,%ebx
  800b04:	75 f0                	jne    800af6 <close_all+0xc>
		close(i);
}
  800b06:	83 c4 14             	add    $0x14,%esp
  800b09:	5b                   	pop    %ebx
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	57                   	push   %edi
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800b15:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	89 04 24             	mov    %eax,(%esp)
  800b22:	e8 5f fe ff ff       	call   800986 <fd_lookup>
  800b27:	89 c2                	mov    %eax,%edx
  800b29:	85 d2                	test   %edx,%edx
  800b2b:	0f 88 e1 00 00 00    	js     800c12 <dup+0x106>
		return r;
	close(newfdnum);
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	89 04 24             	mov    %eax,(%esp)
  800b37:	e8 7b ff ff ff       	call   800ab7 <close>

	newfd = INDEX2FD(newfdnum);
  800b3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b3f:	c1 e3 0c             	shl    $0xc,%ebx
  800b42:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800b48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b4b:	89 04 24             	mov    %eax,(%esp)
  800b4e:	e8 cd fd ff ff       	call   800920 <fd2data>
  800b53:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800b55:	89 1c 24             	mov    %ebx,(%esp)
  800b58:	e8 c3 fd ff ff       	call   800920 <fd2data>
  800b5d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800b5f:	89 f0                	mov    %esi,%eax
  800b61:	c1 e8 16             	shr    $0x16,%eax
  800b64:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800b6b:	a8 01                	test   $0x1,%al
  800b6d:	74 43                	je     800bb2 <dup+0xa6>
  800b6f:	89 f0                	mov    %esi,%eax
  800b71:	c1 e8 0c             	shr    $0xc,%eax
  800b74:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800b7b:	f6 c2 01             	test   $0x1,%dl
  800b7e:	74 32                	je     800bb2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800b80:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800b87:	25 07 0e 00 00       	and    $0xe07,%eax
  800b8c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b90:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800b94:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b9b:	00 
  800b9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ba0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ba7:	e8 ad fa ff ff       	call   800659 <sys_page_map>
  800bac:	89 c6                	mov    %eax,%esi
  800bae:	85 c0                	test   %eax,%eax
  800bb0:	78 3e                	js     800bf0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bb5:	89 c2                	mov    %eax,%edx
  800bb7:	c1 ea 0c             	shr    $0xc,%edx
  800bba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800bc1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800bc7:	89 54 24 10          	mov    %edx,0x10(%esp)
  800bcb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800bcf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800bd6:	00 
  800bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bdb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800be2:	e8 72 fa ff ff       	call   800659 <sys_page_map>
  800be7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800be9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800bec:	85 f6                	test   %esi,%esi
  800bee:	79 22                	jns    800c12 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800bf0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bf4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800bfb:	e8 ac fa ff ff       	call   8006ac <sys_page_unmap>
	sys_page_unmap(0, nva);
  800c00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c0b:	e8 9c fa ff ff       	call   8006ac <sys_page_unmap>
	return r;
  800c10:	89 f0                	mov    %esi,%eax
}
  800c12:	83 c4 3c             	add    $0x3c,%esp
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5f                   	pop    %edi
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	53                   	push   %ebx
  800c1e:	83 ec 24             	sub    $0x24,%esp
  800c21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c24:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c27:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c2b:	89 1c 24             	mov    %ebx,(%esp)
  800c2e:	e8 53 fd ff ff       	call   800986 <fd_lookup>
  800c33:	89 c2                	mov    %eax,%edx
  800c35:	85 d2                	test   %edx,%edx
  800c37:	78 6d                	js     800ca6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c43:	8b 00                	mov    (%eax),%eax
  800c45:	89 04 24             	mov    %eax,(%esp)
  800c48:	e8 8f fd ff ff       	call   8009dc <dev_lookup>
  800c4d:	85 c0                	test   %eax,%eax
  800c4f:	78 55                	js     800ca6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c54:	8b 50 08             	mov    0x8(%eax),%edx
  800c57:	83 e2 03             	and    $0x3,%edx
  800c5a:	83 fa 01             	cmp    $0x1,%edx
  800c5d:	75 23                	jne    800c82 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800c5f:	a1 08 40 80 00       	mov    0x804008,%eax
  800c64:	8b 40 48             	mov    0x48(%eax),%eax
  800c67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c6f:	c7 04 24 fd 27 80 00 	movl   $0x8027fd,(%esp)
  800c76:	e8 e4 10 00 00       	call   801d5f <cprintf>
		return -E_INVAL;
  800c7b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c80:	eb 24                	jmp    800ca6 <read+0x8c>
	}
	if (!dev->dev_read)
  800c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c85:	8b 52 08             	mov    0x8(%edx),%edx
  800c88:	85 d2                	test   %edx,%edx
  800c8a:	74 15                	je     800ca1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800c8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c9a:	89 04 24             	mov    %eax,(%esp)
  800c9d:	ff d2                	call   *%edx
  800c9f:	eb 05                	jmp    800ca6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800ca1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800ca6:	83 c4 24             	add    $0x24,%esp
  800ca9:	5b                   	pop    %ebx
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	57                   	push   %edi
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	83 ec 1c             	sub    $0x1c,%esp
  800cb5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cb8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800cbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc0:	eb 23                	jmp    800ce5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800cc2:	89 f0                	mov    %esi,%eax
  800cc4:	29 d8                	sub    %ebx,%eax
  800cc6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cca:	89 d8                	mov    %ebx,%eax
  800ccc:	03 45 0c             	add    0xc(%ebp),%eax
  800ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd3:	89 3c 24             	mov    %edi,(%esp)
  800cd6:	e8 3f ff ff ff       	call   800c1a <read>
		if (m < 0)
  800cdb:	85 c0                	test   %eax,%eax
  800cdd:	78 10                	js     800cef <readn+0x43>
			return m;
		if (m == 0)
  800cdf:	85 c0                	test   %eax,%eax
  800ce1:	74 0a                	je     800ced <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800ce3:	01 c3                	add    %eax,%ebx
  800ce5:	39 f3                	cmp    %esi,%ebx
  800ce7:	72 d9                	jb     800cc2 <readn+0x16>
  800ce9:	89 d8                	mov    %ebx,%eax
  800ceb:	eb 02                	jmp    800cef <readn+0x43>
  800ced:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800cef:	83 c4 1c             	add    $0x1c,%esp
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	53                   	push   %ebx
  800cfb:	83 ec 24             	sub    $0x24,%esp
  800cfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d08:	89 1c 24             	mov    %ebx,(%esp)
  800d0b:	e8 76 fc ff ff       	call   800986 <fd_lookup>
  800d10:	89 c2                	mov    %eax,%edx
  800d12:	85 d2                	test   %edx,%edx
  800d14:	78 68                	js     800d7e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	89 04 24             	mov    %eax,(%esp)
  800d25:	e8 b2 fc ff ff       	call   8009dc <dev_lookup>
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	78 50                	js     800d7e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d31:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800d35:	75 23                	jne    800d5a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d37:	a1 08 40 80 00       	mov    0x804008,%eax
  800d3c:	8b 40 48             	mov    0x48(%eax),%eax
  800d3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d43:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d47:	c7 04 24 19 28 80 00 	movl   $0x802819,(%esp)
  800d4e:	e8 0c 10 00 00       	call   801d5f <cprintf>
		return -E_INVAL;
  800d53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d58:	eb 24                	jmp    800d7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800d5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d5d:	8b 52 0c             	mov    0xc(%edx),%edx
  800d60:	85 d2                	test   %edx,%edx
  800d62:	74 15                	je     800d79 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800d64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d72:	89 04 24             	mov    %eax,(%esp)
  800d75:	ff d2                	call   *%edx
  800d77:	eb 05                	jmp    800d7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800d79:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800d7e:	83 c4 24             	add    $0x24,%esp
  800d81:	5b                   	pop    %ebx
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <seek>:

int
seek(int fdnum, off_t offset)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d8a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	89 04 24             	mov    %eax,(%esp)
  800d97:	e8 ea fb ff ff       	call   800986 <fd_lookup>
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	78 0e                	js     800dae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800da0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800da9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	53                   	push   %ebx
  800db4:	83 ec 24             	sub    $0x24,%esp
  800db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dc1:	89 1c 24             	mov    %ebx,(%esp)
  800dc4:	e8 bd fb ff ff       	call   800986 <fd_lookup>
  800dc9:	89 c2                	mov    %eax,%edx
  800dcb:	85 d2                	test   %edx,%edx
  800dcd:	78 61                	js     800e30 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd9:	8b 00                	mov    (%eax),%eax
  800ddb:	89 04 24             	mov    %eax,(%esp)
  800dde:	e8 f9 fb ff ff       	call   8009dc <dev_lookup>
  800de3:	85 c0                	test   %eax,%eax
  800de5:	78 49                	js     800e30 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800dee:	75 23                	jne    800e13 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800df0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800df5:	8b 40 48             	mov    0x48(%eax),%eax
  800df8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e00:	c7 04 24 dc 27 80 00 	movl   $0x8027dc,(%esp)
  800e07:	e8 53 0f 00 00       	call   801d5f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e11:	eb 1d                	jmp    800e30 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  800e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e16:	8b 52 18             	mov    0x18(%edx),%edx
  800e19:	85 d2                	test   %edx,%edx
  800e1b:	74 0e                	je     800e2b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e24:	89 04 24             	mov    %eax,(%esp)
  800e27:	ff d2                	call   *%edx
  800e29:	eb 05                	jmp    800e30 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800e2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800e30:	83 c4 24             	add    $0x24,%esp
  800e33:	5b                   	pop    %ebx
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	53                   	push   %ebx
  800e3a:	83 ec 24             	sub    $0x24,%esp
  800e3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e43:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	89 04 24             	mov    %eax,(%esp)
  800e4d:	e8 34 fb ff ff       	call   800986 <fd_lookup>
  800e52:	89 c2                	mov    %eax,%edx
  800e54:	85 d2                	test   %edx,%edx
  800e56:	78 52                	js     800eaa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e62:	8b 00                	mov    (%eax),%eax
  800e64:	89 04 24             	mov    %eax,(%esp)
  800e67:	e8 70 fb ff ff       	call   8009dc <dev_lookup>
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	78 3a                	js     800eaa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e73:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800e77:	74 2c                	je     800ea5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800e79:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800e7c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800e83:	00 00 00 
	stat->st_isdir = 0;
  800e86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800e8d:	00 00 00 
	stat->st_dev = dev;
  800e90:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800e96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800e9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e9d:	89 14 24             	mov    %edx,(%esp)
  800ea0:	ff 50 14             	call   *0x14(%eax)
  800ea3:	eb 05                	jmp    800eaa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800ea5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800eaa:	83 c4 24             	add    $0x24,%esp
  800ead:	5b                   	pop    %ebx
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    

00800eb0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	56                   	push   %esi
  800eb4:	53                   	push   %ebx
  800eb5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800eb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800ebf:	00 
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	89 04 24             	mov    %eax,(%esp)
  800ec6:	e8 99 02 00 00       	call   801164 <open>
  800ecb:	89 c3                	mov    %eax,%ebx
  800ecd:	85 db                	test   %ebx,%ebx
  800ecf:	78 1b                	js     800eec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ed8:	89 1c 24             	mov    %ebx,(%esp)
  800edb:	e8 56 ff ff ff       	call   800e36 <fstat>
  800ee0:	89 c6                	mov    %eax,%esi
	close(fd);
  800ee2:	89 1c 24             	mov    %ebx,(%esp)
  800ee5:	e8 cd fb ff ff       	call   800ab7 <close>
	return r;
  800eea:	89 f0                	mov    %esi,%eax
}
  800eec:	83 c4 10             	add    $0x10,%esp
  800eef:	5b                   	pop    %ebx
  800ef0:	5e                   	pop    %esi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	83 ec 10             	sub    $0x10,%esp
  800efb:	89 c6                	mov    %eax,%esi
  800efd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800eff:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800f06:	75 11                	jne    800f19 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800f08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800f0f:	e8 5b 15 00 00       	call   80246f <ipc_find_env>
  800f14:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f19:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800f20:	00 
  800f21:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800f28:	00 
  800f29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f2d:	a1 00 40 80 00       	mov    0x804000,%eax
  800f32:	89 04 24             	mov    %eax,(%esp)
  800f35:	e8 ce 14 00 00       	call   802408 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800f3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f41:	00 
  800f42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800f46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f4d:	e8 4e 14 00 00       	call   8023a0 <ipc_recv>
}
  800f52:	83 c4 10             	add    $0x10,%esp
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8b 40 0c             	mov    0xc(%eax),%eax
  800f65:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800f72:	ba 00 00 00 00       	mov    $0x0,%edx
  800f77:	b8 02 00 00 00       	mov    $0x2,%eax
  800f7c:	e8 72 ff ff ff       	call   800ef3 <fsipc>
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8b 40 0c             	mov    0xc(%eax),%eax
  800f8f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800f94:	ba 00 00 00 00       	mov    $0x0,%edx
  800f99:	b8 06 00 00 00       	mov    $0x6,%eax
  800f9e:	e8 50 ff ff ff       	call   800ef3 <fsipc>
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	53                   	push   %ebx
  800fa9:	83 ec 14             	sub    $0x14,%esp
  800fac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8b 40 0c             	mov    0xc(%eax),%eax
  800fb5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800fba:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbf:	b8 05 00 00 00       	mov    $0x5,%eax
  800fc4:	e8 2a ff ff ff       	call   800ef3 <fsipc>
  800fc9:	89 c2                	mov    %eax,%edx
  800fcb:	85 d2                	test   %edx,%edx
  800fcd:	78 2b                	js     800ffa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800fcf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800fd6:	00 
  800fd7:	89 1c 24             	mov    %ebx,(%esp)
  800fda:	e8 b8 f1 ff ff       	call   800197 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800fdf:	a1 80 50 80 00       	mov    0x805080,%eax
  800fe4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800fea:	a1 84 50 80 00       	mov    0x805084,%eax
  800fef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ffa:	83 c4 14             	add    $0x14,%esp
  800ffd:	5b                   	pop    %ebx
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	53                   	push   %ebx
  801004:	83 ec 14             	sub    $0x14,%esp
  801007:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	int r;
	int count = 0;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
  80100a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
		count = PGSIZE - (sizeof(int) + sizeof(size_t));
	else
		count = n;
  801010:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801015:	0f 46 c3             	cmovbe %ebx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801018:	8b 55 08             	mov    0x8(%ebp),%edx
  80101b:	8b 52 0c             	mov    0xc(%edx),%edx
  80101e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = count;
  801024:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, count);
  801029:	89 44 24 08          	mov    %eax,0x8(%esp)
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	89 44 24 04          	mov    %eax,0x4(%esp)
  801034:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80103b:	e8 f4 f2 ff ff       	call   800334 <memmove>
	cprintf("\n%s\n",fsipcbuf.write.req_buf);
  801040:	c7 44 24 04 08 50 80 	movl   $0x805008,0x4(%esp)
  801047:	00 
  801048:	c7 04 24 4c 28 80 00 	movl   $0x80284c,(%esp)
  80104f:	e8 0b 0d 00 00       	call   801d5f <cprintf>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801054:	ba 00 00 00 00       	mov    $0x0,%edx
  801059:	b8 04 00 00 00       	mov    $0x4,%eax
  80105e:	e8 90 fe ff ff       	call   800ef3 <fsipc>
  801063:	85 c0                	test   %eax,%eax
  801065:	78 53                	js     8010ba <devfile_write+0xba>
		return r;
	assert(r <= n);
  801067:	39 c3                	cmp    %eax,%ebx
  801069:	73 24                	jae    80108f <devfile_write+0x8f>
  80106b:	c7 44 24 0c 51 28 80 	movl   $0x802851,0xc(%esp)
  801072:	00 
  801073:	c7 44 24 08 58 28 80 	movl   $0x802858,0x8(%esp)
  80107a:	00 
  80107b:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  801082:	00 
  801083:	c7 04 24 6d 28 80 00 	movl   $0x80286d,(%esp)
  80108a:	e8 d7 0b 00 00       	call   801c66 <_panic>
	assert(r <= PGSIZE);
  80108f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801094:	7e 24                	jle    8010ba <devfile_write+0xba>
  801096:	c7 44 24 0c 78 28 80 	movl   $0x802878,0xc(%esp)
  80109d:	00 
  80109e:	c7 44 24 08 58 28 80 	movl   $0x802858,0x8(%esp)
  8010a5:	00 
  8010a6:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8010ad:	00 
  8010ae:	c7 04 24 6d 28 80 00 	movl   $0x80286d,(%esp)
  8010b5:	e8 ac 0b 00 00       	call   801c66 <_panic>
	return r;
}
  8010ba:	83 c4 14             	add    $0x14,%esp
  8010bd:	5b                   	pop    %ebx
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    

008010c0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	56                   	push   %esi
  8010c4:	53                   	push   %ebx
  8010c5:	83 ec 10             	sub    $0x10,%esp
  8010c8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8010d1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8010d6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8010dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8010e6:	e8 08 fe ff ff       	call   800ef3 <fsipc>
  8010eb:	89 c3                	mov    %eax,%ebx
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	78 6a                	js     80115b <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8010f1:	39 c6                	cmp    %eax,%esi
  8010f3:	73 24                	jae    801119 <devfile_read+0x59>
  8010f5:	c7 44 24 0c 51 28 80 	movl   $0x802851,0xc(%esp)
  8010fc:	00 
  8010fd:	c7 44 24 08 58 28 80 	movl   $0x802858,0x8(%esp)
  801104:	00 
  801105:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80110c:	00 
  80110d:	c7 04 24 6d 28 80 00 	movl   $0x80286d,(%esp)
  801114:	e8 4d 0b 00 00       	call   801c66 <_panic>
	assert(r <= PGSIZE);
  801119:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80111e:	7e 24                	jle    801144 <devfile_read+0x84>
  801120:	c7 44 24 0c 78 28 80 	movl   $0x802878,0xc(%esp)
  801127:	00 
  801128:	c7 44 24 08 58 28 80 	movl   $0x802858,0x8(%esp)
  80112f:	00 
  801130:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801137:	00 
  801138:	c7 04 24 6d 28 80 00 	movl   $0x80286d,(%esp)
  80113f:	e8 22 0b 00 00       	call   801c66 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801144:	89 44 24 08          	mov    %eax,0x8(%esp)
  801148:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80114f:	00 
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	89 04 24             	mov    %eax,(%esp)
  801156:	e8 d9 f1 ff ff       	call   800334 <memmove>
	return r;
}
  80115b:	89 d8                	mov    %ebx,%eax
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	5b                   	pop    %ebx
  801161:	5e                   	pop    %esi
  801162:	5d                   	pop    %ebp
  801163:	c3                   	ret    

00801164 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	53                   	push   %ebx
  801168:	83 ec 24             	sub    $0x24,%esp
  80116b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80116e:	89 1c 24             	mov    %ebx,(%esp)
  801171:	e8 ea ef ff ff       	call   800160 <strlen>
  801176:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80117b:	7f 60                	jg     8011dd <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80117d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801180:	89 04 24             	mov    %eax,(%esp)
  801183:	e8 af f7 ff ff       	call   800937 <fd_alloc>
  801188:	89 c2                	mov    %eax,%edx
  80118a:	85 d2                	test   %edx,%edx
  80118c:	78 54                	js     8011e2 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80118e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801192:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801199:	e8 f9 ef ff ff       	call   800197 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8011a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8011ae:	e8 40 fd ff ff       	call   800ef3 <fsipc>
  8011b3:	89 c3                	mov    %eax,%ebx
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	79 17                	jns    8011d0 <open+0x6c>
		fd_close(fd, 0);
  8011b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8011c0:	00 
  8011c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c4:	89 04 24             	mov    %eax,(%esp)
  8011c7:	e8 6a f8 ff ff       	call   800a36 <fd_close>
		return r;
  8011cc:	89 d8                	mov    %ebx,%eax
  8011ce:	eb 12                	jmp    8011e2 <open+0x7e>
	}

	return fd2num(fd);
  8011d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d3:	89 04 24             	mov    %eax,(%esp)
  8011d6:	e8 35 f7 ff ff       	call   800910 <fd2num>
  8011db:	eb 05                	jmp    8011e2 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8011dd:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8011e2:	83 c4 24             	add    $0x24,%esp
  8011e5:	5b                   	pop    %ebx
  8011e6:	5d                   	pop    %ebp
  8011e7:	c3                   	ret    

008011e8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8011ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f3:	b8 08 00 00 00       	mov    $0x8,%eax
  8011f8:	e8 f6 fc ff ff       	call   800ef3 <fsipc>
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <evict>:

int evict(void)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	83 ec 18             	sub    $0x18,%esp
	cprintf("\nevict called in file.c\n");
  801205:	c7 04 24 84 28 80 00 	movl   $0x802884,(%esp)
  80120c:	e8 4e 0b 00 00       	call   801d5f <cprintf>

	return fsipc(FSREQ_EVICT, NULL);
  801211:	ba 00 00 00 00       	mov    $0x0,%edx
  801216:	b8 09 00 00 00       	mov    $0x9,%eax
  80121b:	e8 d3 fc ff ff       	call   800ef3 <fsipc>
}
  801220:	c9                   	leave  
  801221:	c3                   	ret    
  801222:	66 90                	xchg   %ax,%ax
  801224:	66 90                	xchg   %ax,%ax
  801226:	66 90                	xchg   %ax,%ax
  801228:	66 90                	xchg   %ax,%ax
  80122a:	66 90                	xchg   %ax,%ax
  80122c:	66 90                	xchg   %ax,%ax
  80122e:	66 90                	xchg   %ax,%ax

00801230 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801236:	c7 44 24 04 9d 28 80 	movl   $0x80289d,0x4(%esp)
  80123d:	00 
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	89 04 24             	mov    %eax,(%esp)
  801244:	e8 4e ef ff ff       	call   800197 <strcpy>
	return 0;
}
  801249:	b8 00 00 00 00       	mov    $0x0,%eax
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	53                   	push   %ebx
  801254:	83 ec 14             	sub    $0x14,%esp
  801257:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80125a:	89 1c 24             	mov    %ebx,(%esp)
  80125d:	e8 45 12 00 00       	call   8024a7 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801262:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801267:	83 f8 01             	cmp    $0x1,%eax
  80126a:	75 0d                	jne    801279 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80126c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80126f:	89 04 24             	mov    %eax,(%esp)
  801272:	e8 29 03 00 00       	call   8015a0 <nsipc_close>
  801277:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801279:	89 d0                	mov    %edx,%eax
  80127b:	83 c4 14             	add    $0x14,%esp
  80127e:	5b                   	pop    %ebx
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801287:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80128e:	00 
  80128f:	8b 45 10             	mov    0x10(%ebp),%eax
  801292:	89 44 24 08          	mov    %eax,0x8(%esp)
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	89 44 24 04          	mov    %eax,0x4(%esp)
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8012a3:	89 04 24             	mov    %eax,(%esp)
  8012a6:	e8 f0 03 00 00       	call   80169b <nsipc_send>
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8012b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8012ba:	00 
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8012cf:	89 04 24             	mov    %eax,(%esp)
  8012d2:	e8 44 03 00 00       	call   80161b <nsipc_recv>
}
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    

008012d9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8012df:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8012e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012e6:	89 04 24             	mov    %eax,(%esp)
  8012e9:	e8 98 f6 ff ff       	call   800986 <fd_lookup>
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	78 17                	js     801309 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8012f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8012fb:	39 08                	cmp    %ecx,(%eax)
  8012fd:	75 05                	jne    801304 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8012ff:	8b 40 0c             	mov    0xc(%eax),%eax
  801302:	eb 05                	jmp    801309 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801304:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	56                   	push   %esi
  80130f:	53                   	push   %ebx
  801310:	83 ec 20             	sub    $0x20,%esp
  801313:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801315:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801318:	89 04 24             	mov    %eax,(%esp)
  80131b:	e8 17 f6 ff ff       	call   800937 <fd_alloc>
  801320:	89 c3                	mov    %eax,%ebx
  801322:	85 c0                	test   %eax,%eax
  801324:	78 21                	js     801347 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801326:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80132d:	00 
  80132e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801331:	89 44 24 04          	mov    %eax,0x4(%esp)
  801335:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133c:	e8 c4 f2 ff ff       	call   800605 <sys_page_alloc>
  801341:	89 c3                	mov    %eax,%ebx
  801343:	85 c0                	test   %eax,%eax
  801345:	79 0c                	jns    801353 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801347:	89 34 24             	mov    %esi,(%esp)
  80134a:	e8 51 02 00 00       	call   8015a0 <nsipc_close>
		return r;
  80134f:	89 d8                	mov    %ebx,%eax
  801351:	eb 20                	jmp    801373 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801353:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80135e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801361:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801368:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80136b:	89 14 24             	mov    %edx,(%esp)
  80136e:	e8 9d f5 ff ff       	call   800910 <fd2num>
}
  801373:	83 c4 20             	add    $0x20,%esp
  801376:	5b                   	pop    %ebx
  801377:	5e                   	pop    %esi
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	e8 51 ff ff ff       	call   8012d9 <fd2sockid>
		return r;
  801388:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 23                	js     8013b1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80138e:	8b 55 10             	mov    0x10(%ebp),%edx
  801391:	89 54 24 08          	mov    %edx,0x8(%esp)
  801395:	8b 55 0c             	mov    0xc(%ebp),%edx
  801398:	89 54 24 04          	mov    %edx,0x4(%esp)
  80139c:	89 04 24             	mov    %eax,(%esp)
  80139f:	e8 45 01 00 00       	call   8014e9 <nsipc_accept>
		return r;
  8013a4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	78 07                	js     8013b1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8013aa:	e8 5c ff ff ff       	call   80130b <alloc_sockfd>
  8013af:	89 c1                	mov    %eax,%ecx
}
  8013b1:	89 c8                	mov    %ecx,%eax
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	e8 16 ff ff ff       	call   8012d9 <fd2sockid>
  8013c3:	89 c2                	mov    %eax,%edx
  8013c5:	85 d2                	test   %edx,%edx
  8013c7:	78 16                	js     8013df <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d7:	89 14 24             	mov    %edx,(%esp)
  8013da:	e8 60 01 00 00       	call   80153f <nsipc_bind>
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <shutdown>:

int
shutdown(int s, int how)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	e8 ea fe ff ff       	call   8012d9 <fd2sockid>
  8013ef:	89 c2                	mov    %eax,%edx
  8013f1:	85 d2                	test   %edx,%edx
  8013f3:	78 0f                	js     801404 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fc:	89 14 24             	mov    %edx,(%esp)
  8013ff:	e8 7a 01 00 00       	call   80157e <nsipc_shutdown>
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	e8 c5 fe ff ff       	call   8012d9 <fd2sockid>
  801414:	89 c2                	mov    %eax,%edx
  801416:	85 d2                	test   %edx,%edx
  801418:	78 16                	js     801430 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80141a:	8b 45 10             	mov    0x10(%ebp),%eax
  80141d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801421:	8b 45 0c             	mov    0xc(%ebp),%eax
  801424:	89 44 24 04          	mov    %eax,0x4(%esp)
  801428:	89 14 24             	mov    %edx,(%esp)
  80142b:	e8 8a 01 00 00       	call   8015ba <nsipc_connect>
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <listen>:

int
listen(int s, int backlog)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	e8 99 fe ff ff       	call   8012d9 <fd2sockid>
  801440:	89 c2                	mov    %eax,%edx
  801442:	85 d2                	test   %edx,%edx
  801444:	78 0f                	js     801455 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801446:	8b 45 0c             	mov    0xc(%ebp),%eax
  801449:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144d:	89 14 24             	mov    %edx,(%esp)
  801450:	e8 a4 01 00 00       	call   8015f9 <nsipc_listen>
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80145d:	8b 45 10             	mov    0x10(%ebp),%eax
  801460:	89 44 24 08          	mov    %eax,0x8(%esp)
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	89 04 24             	mov    %eax,(%esp)
  801471:	e8 98 02 00 00       	call   80170e <nsipc_socket>
  801476:	89 c2                	mov    %eax,%edx
  801478:	85 d2                	test   %edx,%edx
  80147a:	78 05                	js     801481 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80147c:	e8 8a fe ff ff       	call   80130b <alloc_sockfd>
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	53                   	push   %ebx
  801487:	83 ec 14             	sub    $0x14,%esp
  80148a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80148c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801493:	75 11                	jne    8014a6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801495:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80149c:	e8 ce 0f 00 00       	call   80246f <ipc_find_env>
  8014a1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8014a6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8014ad:	00 
  8014ae:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8014b5:	00 
  8014b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014ba:	a1 04 40 80 00       	mov    0x804004,%eax
  8014bf:	89 04 24             	mov    %eax,(%esp)
  8014c2:	e8 41 0f 00 00       	call   802408 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8014c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014ce:	00 
  8014cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014d6:	00 
  8014d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014de:	e8 bd 0e 00 00       	call   8023a0 <ipc_recv>
}
  8014e3:	83 c4 14             	add    $0x14,%esp
  8014e6:	5b                   	pop    %ebx
  8014e7:	5d                   	pop    %ebp
  8014e8:	c3                   	ret    

008014e9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	56                   	push   %esi
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 10             	sub    $0x10,%esp
  8014f1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8014fc:	8b 06                	mov    (%esi),%eax
  8014fe:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801503:	b8 01 00 00 00       	mov    $0x1,%eax
  801508:	e8 76 ff ff ff       	call   801483 <nsipc>
  80150d:	89 c3                	mov    %eax,%ebx
  80150f:	85 c0                	test   %eax,%eax
  801511:	78 23                	js     801536 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801513:	a1 10 60 80 00       	mov    0x806010,%eax
  801518:	89 44 24 08          	mov    %eax,0x8(%esp)
  80151c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801523:	00 
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	89 04 24             	mov    %eax,(%esp)
  80152a:	e8 05 ee ff ff       	call   800334 <memmove>
		*addrlen = ret->ret_addrlen;
  80152f:	a1 10 60 80 00       	mov    0x806010,%eax
  801534:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801536:	89 d8                	mov    %ebx,%eax
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	5b                   	pop    %ebx
  80153c:	5e                   	pop    %esi
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    

0080153f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	53                   	push   %ebx
  801543:	83 ec 14             	sub    $0x14,%esp
  801546:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801551:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801563:	e8 cc ed ff ff       	call   800334 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801568:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80156e:	b8 02 00 00 00       	mov    $0x2,%eax
  801573:	e8 0b ff ff ff       	call   801483 <nsipc>
}
  801578:	83 c4 14             	add    $0x14,%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5d                   	pop    %ebp
  80157d:	c3                   	ret    

0080157e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80158c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801594:	b8 03 00 00 00       	mov    $0x3,%eax
  801599:	e8 e5 fe ff ff       	call   801483 <nsipc>
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <nsipc_close>:

int
nsipc_close(int s)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8015ae:	b8 04 00 00 00       	mov    $0x4,%eax
  8015b3:	e8 cb fe ff ff       	call   801483 <nsipc>
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	53                   	push   %ebx
  8015be:	83 ec 14             	sub    $0x14,%esp
  8015c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8015cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8015de:	e8 51 ed ff ff       	call   800334 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8015e3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8015e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8015ee:	e8 90 fe ff ff       	call   801483 <nsipc>
}
  8015f3:	83 c4 14             	add    $0x14,%esp
  8015f6:	5b                   	pop    %ebx
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    

008015f9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80160f:	b8 06 00 00 00       	mov    $0x6,%eax
  801614:	e8 6a fe ff ff       	call   801483 <nsipc>
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	56                   	push   %esi
  80161f:	53                   	push   %ebx
  801620:	83 ec 10             	sub    $0x10,%esp
  801623:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80162e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801634:	8b 45 14             	mov    0x14(%ebp),%eax
  801637:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80163c:	b8 07 00 00 00       	mov    $0x7,%eax
  801641:	e8 3d fe ff ff       	call   801483 <nsipc>
  801646:	89 c3                	mov    %eax,%ebx
  801648:	85 c0                	test   %eax,%eax
  80164a:	78 46                	js     801692 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80164c:	39 f0                	cmp    %esi,%eax
  80164e:	7f 07                	jg     801657 <nsipc_recv+0x3c>
  801650:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801655:	7e 24                	jle    80167b <nsipc_recv+0x60>
  801657:	c7 44 24 0c a9 28 80 	movl   $0x8028a9,0xc(%esp)
  80165e:	00 
  80165f:	c7 44 24 08 58 28 80 	movl   $0x802858,0x8(%esp)
  801666:	00 
  801667:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80166e:	00 
  80166f:	c7 04 24 be 28 80 00 	movl   $0x8028be,(%esp)
  801676:	e8 eb 05 00 00       	call   801c66 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80167b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80167f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801686:	00 
  801687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168a:	89 04 24             	mov    %eax,(%esp)
  80168d:	e8 a2 ec ff ff       	call   800334 <memmove>
	}

	return r;
}
  801692:	89 d8                	mov    %ebx,%eax
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	5b                   	pop    %ebx
  801698:	5e                   	pop    %esi
  801699:	5d                   	pop    %ebp
  80169a:	c3                   	ret    

0080169b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	53                   	push   %ebx
  80169f:	83 ec 14             	sub    $0x14,%esp
  8016a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8016ad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8016b3:	7e 24                	jle    8016d9 <nsipc_send+0x3e>
  8016b5:	c7 44 24 0c ca 28 80 	movl   $0x8028ca,0xc(%esp)
  8016bc:	00 
  8016bd:	c7 44 24 08 58 28 80 	movl   $0x802858,0x8(%esp)
  8016c4:	00 
  8016c5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8016cc:	00 
  8016cd:	c7 04 24 be 28 80 00 	movl   $0x8028be,(%esp)
  8016d4:	e8 8d 05 00 00       	call   801c66 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8016d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8016eb:	e8 44 ec ff ff       	call   800334 <memmove>
	nsipcbuf.send.req_size = size;
  8016f0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8016f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8016fe:	b8 08 00 00 00       	mov    $0x8,%eax
  801703:	e8 7b fd ff ff       	call   801483 <nsipc>
}
  801708:	83 c4 14             	add    $0x14,%esp
  80170b:	5b                   	pop    %ebx
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    

0080170e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801724:	8b 45 10             	mov    0x10(%ebp),%eax
  801727:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80172c:	b8 09 00 00 00       	mov    $0x9,%eax
  801731:	e8 4d fd ff ff       	call   801483 <nsipc>
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	83 ec 10             	sub    $0x10,%esp
  801740:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	89 04 24             	mov    %eax,(%esp)
  801749:	e8 d2 f1 ff ff       	call   800920 <fd2data>
  80174e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801750:	c7 44 24 04 d6 28 80 	movl   $0x8028d6,0x4(%esp)
  801757:	00 
  801758:	89 1c 24             	mov    %ebx,(%esp)
  80175b:	e8 37 ea ff ff       	call   800197 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801760:	8b 46 04             	mov    0x4(%esi),%eax
  801763:	2b 06                	sub    (%esi),%eax
  801765:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80176b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801772:	00 00 00 
	stat->st_dev = &devpipe;
  801775:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80177c:	30 80 00 
	return 0;
}
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	5b                   	pop    %ebx
  801788:	5e                   	pop    %esi
  801789:	5d                   	pop    %ebp
  80178a:	c3                   	ret    

0080178b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	53                   	push   %ebx
  80178f:	83 ec 14             	sub    $0x14,%esp
  801792:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801795:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801799:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a0:	e8 07 ef ff ff       	call   8006ac <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017a5:	89 1c 24             	mov    %ebx,(%esp)
  8017a8:	e8 73 f1 ff ff       	call   800920 <fd2data>
  8017ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017b8:	e8 ef ee ff ff       	call   8006ac <sys_page_unmap>
}
  8017bd:	83 c4 14             	add    $0x14,%esp
  8017c0:	5b                   	pop    %ebx
  8017c1:	5d                   	pop    %ebp
  8017c2:	c3                   	ret    

008017c3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	57                   	push   %edi
  8017c7:	56                   	push   %esi
  8017c8:	53                   	push   %ebx
  8017c9:	83 ec 2c             	sub    $0x2c,%esp
  8017cc:	89 c6                	mov    %eax,%esi
  8017ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8017d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8017d6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017d9:	89 34 24             	mov    %esi,(%esp)
  8017dc:	e8 c6 0c 00 00       	call   8024a7 <pageref>
  8017e1:	89 c7                	mov    %eax,%edi
  8017e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e6:	89 04 24             	mov    %eax,(%esp)
  8017e9:	e8 b9 0c 00 00       	call   8024a7 <pageref>
  8017ee:	39 c7                	cmp    %eax,%edi
  8017f0:	0f 94 c2             	sete   %dl
  8017f3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8017f6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  8017fc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8017ff:	39 fb                	cmp    %edi,%ebx
  801801:	74 21                	je     801824 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801803:	84 d2                	test   %dl,%dl
  801805:	74 ca                	je     8017d1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801807:	8b 51 58             	mov    0x58(%ecx),%edx
  80180a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80180e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801812:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801816:	c7 04 24 dd 28 80 00 	movl   $0x8028dd,(%esp)
  80181d:	e8 3d 05 00 00       	call   801d5f <cprintf>
  801822:	eb ad                	jmp    8017d1 <_pipeisclosed+0xe>
	}
}
  801824:	83 c4 2c             	add    $0x2c,%esp
  801827:	5b                   	pop    %ebx
  801828:	5e                   	pop    %esi
  801829:	5f                   	pop    %edi
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    

0080182c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	57                   	push   %edi
  801830:	56                   	push   %esi
  801831:	53                   	push   %ebx
  801832:	83 ec 1c             	sub    $0x1c,%esp
  801835:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801838:	89 34 24             	mov    %esi,(%esp)
  80183b:	e8 e0 f0 ff ff       	call   800920 <fd2data>
  801840:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801842:	bf 00 00 00 00       	mov    $0x0,%edi
  801847:	eb 45                	jmp    80188e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801849:	89 da                	mov    %ebx,%edx
  80184b:	89 f0                	mov    %esi,%eax
  80184d:	e8 71 ff ff ff       	call   8017c3 <_pipeisclosed>
  801852:	85 c0                	test   %eax,%eax
  801854:	75 41                	jne    801897 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801856:	e8 8b ed ff ff       	call   8005e6 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80185b:	8b 43 04             	mov    0x4(%ebx),%eax
  80185e:	8b 0b                	mov    (%ebx),%ecx
  801860:	8d 51 20             	lea    0x20(%ecx),%edx
  801863:	39 d0                	cmp    %edx,%eax
  801865:	73 e2                	jae    801849 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801867:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80186a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80186e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801871:	99                   	cltd   
  801872:	c1 ea 1b             	shr    $0x1b,%edx
  801875:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801878:	83 e1 1f             	and    $0x1f,%ecx
  80187b:	29 d1                	sub    %edx,%ecx
  80187d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801881:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801885:	83 c0 01             	add    $0x1,%eax
  801888:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80188b:	83 c7 01             	add    $0x1,%edi
  80188e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801891:	75 c8                	jne    80185b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801893:	89 f8                	mov    %edi,%eax
  801895:	eb 05                	jmp    80189c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801897:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80189c:	83 c4 1c             	add    $0x1c,%esp
  80189f:	5b                   	pop    %ebx
  8018a0:	5e                   	pop    %esi
  8018a1:	5f                   	pop    %edi
  8018a2:	5d                   	pop    %ebp
  8018a3:	c3                   	ret    

008018a4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	57                   	push   %edi
  8018a8:	56                   	push   %esi
  8018a9:	53                   	push   %ebx
  8018aa:	83 ec 1c             	sub    $0x1c,%esp
  8018ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018b0:	89 3c 24             	mov    %edi,(%esp)
  8018b3:	e8 68 f0 ff ff       	call   800920 <fd2data>
  8018b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018ba:	be 00 00 00 00       	mov    $0x0,%esi
  8018bf:	eb 3d                	jmp    8018fe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8018c1:	85 f6                	test   %esi,%esi
  8018c3:	74 04                	je     8018c9 <devpipe_read+0x25>
				return i;
  8018c5:	89 f0                	mov    %esi,%eax
  8018c7:	eb 43                	jmp    80190c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8018c9:	89 da                	mov    %ebx,%edx
  8018cb:	89 f8                	mov    %edi,%eax
  8018cd:	e8 f1 fe ff ff       	call   8017c3 <_pipeisclosed>
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	75 31                	jne    801907 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8018d6:	e8 0b ed ff ff       	call   8005e6 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8018db:	8b 03                	mov    (%ebx),%eax
  8018dd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8018e0:	74 df                	je     8018c1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8018e2:	99                   	cltd   
  8018e3:	c1 ea 1b             	shr    $0x1b,%edx
  8018e6:	01 d0                	add    %edx,%eax
  8018e8:	83 e0 1f             	and    $0x1f,%eax
  8018eb:	29 d0                	sub    %edx,%eax
  8018ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8018f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8018f8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018fb:	83 c6 01             	add    $0x1,%esi
  8018fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  801901:	75 d8                	jne    8018db <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801903:	89 f0                	mov    %esi,%eax
  801905:	eb 05                	jmp    80190c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801907:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80190c:	83 c4 1c             	add    $0x1c,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5f                   	pop    %edi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    

00801914 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	56                   	push   %esi
  801918:	53                   	push   %ebx
  801919:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80191c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191f:	89 04 24             	mov    %eax,(%esp)
  801922:	e8 10 f0 ff ff       	call   800937 <fd_alloc>
  801927:	89 c2                	mov    %eax,%edx
  801929:	85 d2                	test   %edx,%edx
  80192b:	0f 88 4d 01 00 00    	js     801a7e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801931:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801938:	00 
  801939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801940:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801947:	e8 b9 ec ff ff       	call   800605 <sys_page_alloc>
  80194c:	89 c2                	mov    %eax,%edx
  80194e:	85 d2                	test   %edx,%edx
  801950:	0f 88 28 01 00 00    	js     801a7e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801956:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801959:	89 04 24             	mov    %eax,(%esp)
  80195c:	e8 d6 ef ff ff       	call   800937 <fd_alloc>
  801961:	89 c3                	mov    %eax,%ebx
  801963:	85 c0                	test   %eax,%eax
  801965:	0f 88 fe 00 00 00    	js     801a69 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80196b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801972:	00 
  801973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801976:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801981:	e8 7f ec ff ff       	call   800605 <sys_page_alloc>
  801986:	89 c3                	mov    %eax,%ebx
  801988:	85 c0                	test   %eax,%eax
  80198a:	0f 88 d9 00 00 00    	js     801a69 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801993:	89 04 24             	mov    %eax,(%esp)
  801996:	e8 85 ef ff ff       	call   800920 <fd2data>
  80199b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80199d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019a4:	00 
  8019a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019b0:	e8 50 ec ff ff       	call   800605 <sys_page_alloc>
  8019b5:	89 c3                	mov    %eax,%ebx
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	0f 88 97 00 00 00    	js     801a56 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c2:	89 04 24             	mov    %eax,(%esp)
  8019c5:	e8 56 ef ff ff       	call   800920 <fd2data>
  8019ca:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8019d1:	00 
  8019d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019dd:	00 
  8019de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019e9:	e8 6b ec ff ff       	call   800659 <sys_page_map>
  8019ee:	89 c3                	mov    %eax,%ebx
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	78 52                	js     801a46 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8019f4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8019ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801a09:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a12:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a17:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a21:	89 04 24             	mov    %eax,(%esp)
  801a24:	e8 e7 ee ff ff       	call   800910 <fd2num>
  801a29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a31:	89 04 24             	mov    %eax,(%esp)
  801a34:	e8 d7 ee ff ff       	call   800910 <fd2num>
  801a39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a44:	eb 38                	jmp    801a7e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801a46:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a51:	e8 56 ec ff ff       	call   8006ac <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a64:	e8 43 ec ff ff       	call   8006ac <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a77:	e8 30 ec ff ff       	call   8006ac <sys_page_unmap>
  801a7c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801a7e:	83 c4 30             	add    $0x30,%esp
  801a81:	5b                   	pop    %ebx
  801a82:	5e                   	pop    %esi
  801a83:	5d                   	pop    %ebp
  801a84:	c3                   	ret    

00801a85 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 04 24             	mov    %eax,(%esp)
  801a98:	e8 e9 ee ff ff       	call   800986 <fd_lookup>
  801a9d:	89 c2                	mov    %eax,%edx
  801a9f:	85 d2                	test   %edx,%edx
  801aa1:	78 15                	js     801ab8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa6:	89 04 24             	mov    %eax,(%esp)
  801aa9:	e8 72 ee ff ff       	call   800920 <fd2data>
	return _pipeisclosed(fd, p);
  801aae:	89 c2                	mov    %eax,%edx
  801ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab3:	e8 0b fd ff ff       	call   8017c3 <_pipeisclosed>
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	66 90                	xchg   %ax,%ax
  801abe:	66 90                	xchg   %ax,%ax

00801ac0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac8:	5d                   	pop    %ebp
  801ac9:	c3                   	ret    

00801aca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801ad0:	c7 44 24 04 f5 28 80 	movl   $0x8028f5,0x4(%esp)
  801ad7:	00 
  801ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adb:	89 04 24             	mov    %eax,(%esp)
  801ade:	e8 b4 e6 ff ff       	call   800197 <strcpy>
	return 0;
}
  801ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	57                   	push   %edi
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801af6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801afb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b01:	eb 31                	jmp    801b34 <devcons_write+0x4a>
		m = n - tot;
  801b03:	8b 75 10             	mov    0x10(%ebp),%esi
  801b06:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  801b08:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801b0b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801b10:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b13:	89 74 24 08          	mov    %esi,0x8(%esp)
  801b17:	03 45 0c             	add    0xc(%ebp),%eax
  801b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1e:	89 3c 24             	mov    %edi,(%esp)
  801b21:	e8 0e e8 ff ff       	call   800334 <memmove>
		sys_cputs(buf, m);
  801b26:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b2a:	89 3c 24             	mov    %edi,(%esp)
  801b2d:	e8 b4 e9 ff ff       	call   8004e6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b32:	01 f3                	add    %esi,%ebx
  801b34:	89 d8                	mov    %ebx,%eax
  801b36:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801b39:	72 c8                	jb     801b03 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801b3b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801b41:	5b                   	pop    %ebx
  801b42:	5e                   	pop    %esi
  801b43:	5f                   	pop    %edi
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    

00801b46 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801b4c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801b51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b55:	75 07                	jne    801b5e <devcons_read+0x18>
  801b57:	eb 2a                	jmp    801b83 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801b59:	e8 88 ea ff ff       	call   8005e6 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801b5e:	66 90                	xchg   %ax,%ax
  801b60:	e8 9f e9 ff ff       	call   800504 <sys_cgetc>
  801b65:	85 c0                	test   %eax,%eax
  801b67:	74 f0                	je     801b59 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	78 16                	js     801b83 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801b6d:	83 f8 04             	cmp    $0x4,%eax
  801b70:	74 0c                	je     801b7e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801b72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b75:	88 02                	mov    %al,(%edx)
	return 1;
  801b77:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7c:	eb 05                	jmp    801b83 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801b7e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b91:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b98:	00 
  801b99:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b9c:	89 04 24             	mov    %eax,(%esp)
  801b9f:	e8 42 e9 ff ff       	call   8004e6 <sys_cputs>
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <getchar>:

int
getchar(void)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801bac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801bb3:	00 
  801bb4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bc2:	e8 53 f0 ff ff       	call   800c1a <read>
	if (r < 0)
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	78 0f                	js     801bda <getchar+0x34>
		return r;
	if (r < 1)
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	7e 06                	jle    801bd5 <getchar+0x2f>
		return -E_EOF;
	return c;
  801bcf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801bd3:	eb 05                	jmp    801bda <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801bd5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801be2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	89 04 24             	mov    %eax,(%esp)
  801bef:	e8 92 ed ff ff       	call   800986 <fd_lookup>
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	78 11                	js     801c09 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801c01:	39 10                	cmp    %edx,(%eax)
  801c03:	0f 94 c0             	sete   %al
  801c06:	0f b6 c0             	movzbl %al,%eax
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <opencons>:

int
opencons(void)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c14:	89 04 24             	mov    %eax,(%esp)
  801c17:	e8 1b ed ff ff       	call   800937 <fd_alloc>
		return r;
  801c1c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	78 40                	js     801c62 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c22:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c29:	00 
  801c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c38:	e8 c8 e9 ff ff       	call   800605 <sys_page_alloc>
		return r;
  801c3d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	78 1f                	js     801c62 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801c43:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c51:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c58:	89 04 24             	mov    %eax,(%esp)
  801c5b:	e8 b0 ec ff ff       	call   800910 <fd2num>
  801c60:	89 c2                	mov    %eax,%edx
}
  801c62:	89 d0                	mov    %edx,%eax
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	56                   	push   %esi
  801c6a:	53                   	push   %ebx
  801c6b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801c6e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c71:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801c77:	e8 4b e9 ff ff       	call   8005c7 <sys_getenvid>
  801c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c83:	8b 55 08             	mov    0x8(%ebp),%edx
  801c86:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c8a:	89 74 24 08          	mov    %esi,0x8(%esp)
  801c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c92:	c7 04 24 04 29 80 00 	movl   $0x802904,(%esp)
  801c99:	e8 c1 00 00 00       	call   801d5f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c9e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca5:	89 04 24             	mov    %eax,(%esp)
  801ca8:	e8 51 00 00 00       	call   801cfe <vcprintf>
	cprintf("\n");
  801cad:	c7 04 24 9b 28 80 00 	movl   $0x80289b,(%esp)
  801cb4:	e8 a6 00 00 00       	call   801d5f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801cb9:	cc                   	int3   
  801cba:	eb fd                	jmp    801cb9 <_panic+0x53>

00801cbc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	53                   	push   %ebx
  801cc0:	83 ec 14             	sub    $0x14,%esp
  801cc3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801cc6:	8b 13                	mov    (%ebx),%edx
  801cc8:	8d 42 01             	lea    0x1(%edx),%eax
  801ccb:	89 03                	mov    %eax,(%ebx)
  801ccd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801cd4:	3d ff 00 00 00       	cmp    $0xff,%eax
  801cd9:	75 19                	jne    801cf4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801cdb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801ce2:	00 
  801ce3:	8d 43 08             	lea    0x8(%ebx),%eax
  801ce6:	89 04 24             	mov    %eax,(%esp)
  801ce9:	e8 f8 e7 ff ff       	call   8004e6 <sys_cputs>
		b->idx = 0;
  801cee:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801cf4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801cf8:	83 c4 14             	add    $0x14,%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5d                   	pop    %ebp
  801cfd:	c3                   	ret    

00801cfe <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801d07:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d0e:	00 00 00 
	b.cnt = 0;
  801d11:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801d18:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d29:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d33:	c7 04 24 bc 1c 80 00 	movl   $0x801cbc,(%esp)
  801d3a:	e8 75 01 00 00       	call   801eb4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801d3f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801d45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d49:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801d4f:	89 04 24             	mov    %eax,(%esp)
  801d52:	e8 8f e7 ff ff       	call   8004e6 <sys_cputs>

	return b.cnt;
}
  801d57:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d65:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801d68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	89 04 24             	mov    %eax,(%esp)
  801d72:	e8 87 ff ff ff       	call   801cfe <vcprintf>
	va_end(ap);

	return cnt;
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    
  801d79:	66 90                	xchg   %ax,%ax
  801d7b:	66 90                	xchg   %ax,%ax
  801d7d:	66 90                	xchg   %ax,%ax
  801d7f:	90                   	nop

00801d80 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	57                   	push   %edi
  801d84:	56                   	push   %esi
  801d85:	53                   	push   %ebx
  801d86:	83 ec 3c             	sub    $0x3c,%esp
  801d89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d8c:	89 d7                	mov    %edx,%edi
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d97:	89 c3                	mov    %eax,%ebx
  801d99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801d9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801da2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801da7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801daa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801dad:	39 d9                	cmp    %ebx,%ecx
  801daf:	72 05                	jb     801db6 <printnum+0x36>
  801db1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801db4:	77 69                	ja     801e1f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801db6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801db9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801dbd:	83 ee 01             	sub    $0x1,%esi
  801dc0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801dc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dc8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dcc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801dd0:	89 c3                	mov    %eax,%ebx
  801dd2:	89 d6                	mov    %edx,%esi
  801dd4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801dd7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801dda:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dde:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801de2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de5:	89 04 24             	mov    %eax,(%esp)
  801de8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801deb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801def:	e8 fc 06 00 00       	call   8024f0 <__udivdi3>
  801df4:	89 d9                	mov    %ebx,%ecx
  801df6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dfa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801dfe:	89 04 24             	mov    %eax,(%esp)
  801e01:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e05:	89 fa                	mov    %edi,%edx
  801e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e0a:	e8 71 ff ff ff       	call   801d80 <printnum>
  801e0f:	eb 1b                	jmp    801e2c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801e11:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e15:	8b 45 18             	mov    0x18(%ebp),%eax
  801e18:	89 04 24             	mov    %eax,(%esp)
  801e1b:	ff d3                	call   *%ebx
  801e1d:	eb 03                	jmp    801e22 <printnum+0xa2>
  801e1f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801e22:	83 ee 01             	sub    $0x1,%esi
  801e25:	85 f6                	test   %esi,%esi
  801e27:	7f e8                	jg     801e11 <printnum+0x91>
  801e29:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801e2c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e30:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801e34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801e3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e3e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e45:	89 04 24             	mov    %eax,(%esp)
  801e48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4f:	e8 cc 07 00 00       	call   802620 <__umoddi3>
  801e54:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e58:	0f be 80 27 29 80 00 	movsbl 0x802927(%eax),%eax
  801e5f:	89 04 24             	mov    %eax,(%esp)
  801e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e65:	ff d0                	call   *%eax
}
  801e67:	83 c4 3c             	add    $0x3c,%esp
  801e6a:	5b                   	pop    %ebx
  801e6b:	5e                   	pop    %esi
  801e6c:	5f                   	pop    %edi
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    

00801e6f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801e75:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801e79:	8b 10                	mov    (%eax),%edx
  801e7b:	3b 50 04             	cmp    0x4(%eax),%edx
  801e7e:	73 0a                	jae    801e8a <sprintputch+0x1b>
		*b->buf++ = ch;
  801e80:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e83:	89 08                	mov    %ecx,(%eax)
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	88 02                	mov    %al,(%edx)
}
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    

00801e8c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e92:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801e95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e99:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	89 04 24             	mov    %eax,(%esp)
  801ead:	e8 02 00 00 00       	call   801eb4 <vprintfmt>
	va_end(ap);
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	57                   	push   %edi
  801eb8:	56                   	push   %esi
  801eb9:	53                   	push   %ebx
  801eba:	83 ec 3c             	sub    $0x3c,%esp
  801ebd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ec0:	eb 17                	jmp    801ed9 <vprintfmt+0x25>
	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
			if (ch == '\0')
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	0f 84 4b 04 00 00    	je     802315 <vprintfmt+0x461>
				return;
			putch(ch, putdat);
  801eca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ecd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ed1:	89 04 24             	mov    %eax,(%esp)
  801ed4:	ff 55 08             	call   *0x8(%ebp)

	const char *colorIdx;
	int found=0;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) !='%') {
  801ed7:	89 fb                	mov    %edi,%ebx
  801ed9:	8d 7b 01             	lea    0x1(%ebx),%edi
  801edc:	0f b6 03             	movzbl (%ebx),%eax
  801edf:	83 f8 25             	cmp    $0x25,%eax
  801ee2:	75 de                	jne    801ec2 <vprintfmt+0xe>
  801ee4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  801ee8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801eef:	be ff ff ff ff       	mov    $0xffffffff,%esi
  801ef4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801efb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f00:	eb 18                	jmp    801f1a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f02:	89 df                	mov    %ebx,%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801f04:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  801f08:	eb 10                	jmp    801f1a <vprintfmt+0x66>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f0a:	89 df                	mov    %ebx,%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801f0c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  801f10:	eb 08                	jmp    801f1a <vprintfmt+0x66>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801f12:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801f15:	be ff ff ff ff       	mov    $0xffffffff,%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f1a:	8d 5f 01             	lea    0x1(%edi),%ebx
  801f1d:	0f b6 17             	movzbl (%edi),%edx
  801f20:	0f b6 c2             	movzbl %dl,%eax
  801f23:	83 ea 23             	sub    $0x23,%edx
  801f26:	80 fa 55             	cmp    $0x55,%dl
  801f29:	0f 87 c2 03 00 00    	ja     8022f1 <vprintfmt+0x43d>
  801f2f:	0f b6 d2             	movzbl %dl,%edx
  801f32:	ff 24 95 60 2a 80 00 	jmp    *0x802a60(,%edx,4)
  801f39:	89 df                	mov    %ebx,%edi
  801f3b:	be 00 00 00 00       	mov    $0x0,%esi
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801f40:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  801f43:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  801f47:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
  801f4a:	8d 50 d0             	lea    -0x30(%eax),%edx
  801f4d:	83 fa 09             	cmp    $0x9,%edx
  801f50:	77 33                	ja     801f85 <vprintfmt+0xd1>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801f52:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801f55:	eb e9                	jmp    801f40 <vprintfmt+0x8c>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801f57:	8b 45 14             	mov    0x14(%ebp),%eax
  801f5a:	8b 30                	mov    (%eax),%esi
  801f5c:	8d 40 04             	lea    0x4(%eax),%eax
  801f5f:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f62:	89 df                	mov    %ebx,%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801f64:	eb 1f                	jmp    801f85 <vprintfmt+0xd1>
  801f66:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801f69:	85 ff                	test   %edi,%edi
  801f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f70:	0f 49 c7             	cmovns %edi,%eax
  801f73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f76:	89 df                	mov    %ebx,%edi
  801f78:	eb a0                	jmp    801f1a <vprintfmt+0x66>
  801f7a:	89 df                	mov    %ebx,%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801f7c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
			goto reswitch;
  801f83:	eb 95                	jmp    801f1a <vprintfmt+0x66>

		process_precision:
			if (width < 0)
  801f85:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f89:	79 8f                	jns    801f1a <vprintfmt+0x66>
  801f8b:	eb 85                	jmp    801f12 <vprintfmt+0x5e>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801f8d:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f90:	89 df                	mov    %ebx,%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801f92:	eb 86                	jmp    801f1a <vprintfmt+0x66>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801f94:	8b 45 14             	mov    0x14(%ebp),%eax
  801f97:	8d 70 04             	lea    0x4(%eax),%esi
  801f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa1:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa4:	8b 00                	mov    (%eax),%eax
  801fa6:	89 04 24             	mov    %eax,(%esp)
  801fa9:	ff 55 08             	call   *0x8(%ebp)
  801fac:	89 75 14             	mov    %esi,0x14(%ebp)
			break;
  801faf:	e9 25 ff ff ff       	jmp    801ed9 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801fb4:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb7:	8d 70 04             	lea    0x4(%eax),%esi
  801fba:	8b 00                	mov    (%eax),%eax
  801fbc:	99                   	cltd   
  801fbd:	31 d0                	xor    %edx,%eax
  801fbf:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801fc1:	83 f8 15             	cmp    $0x15,%eax
  801fc4:	7f 0b                	jg     801fd1 <vprintfmt+0x11d>
  801fc6:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  801fcd:	85 d2                	test   %edx,%edx
  801fcf:	75 26                	jne    801ff7 <vprintfmt+0x143>
				printfmt(putch, putdat, "error %d", err);
  801fd1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fd5:	c7 44 24 08 3f 29 80 	movl   $0x80293f,0x8(%esp)
  801fdc:	00 
  801fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	89 04 24             	mov    %eax,(%esp)
  801fea:	e8 9d fe ff ff       	call   801e8c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  801fef:	89 75 14             	mov    %esi,0x14(%ebp)
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801ff2:	e9 e2 fe ff ff       	jmp    801ed9 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801ff7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ffb:	c7 44 24 08 6a 28 80 	movl   $0x80286a,0x8(%esp)
  802002:	00 
  802003:	8b 45 0c             	mov    0xc(%ebp),%eax
  802006:	89 44 24 04          	mov    %eax,0x4(%esp)
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	89 04 24             	mov    %eax,(%esp)
  802010:	e8 77 fe ff ff       	call   801e8c <printfmt>
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  802015:	89 75 14             	mov    %esi,0x14(%ebp)
  802018:	e9 bc fe ff ff       	jmp    801ed9 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80201d:	8b 45 14             	mov    0x14(%ebp),%eax
  802020:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  802023:	89 4d d8             	mov    %ecx,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  802026:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80202a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80202c:	85 ff                	test   %edi,%edi
  80202e:	b8 38 29 80 00       	mov    $0x802938,%eax
  802033:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  802036:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80203a:	0f 84 94 00 00 00    	je     8020d4 <vprintfmt+0x220>
  802040:	85 c9                	test   %ecx,%ecx
  802042:	0f 8e 94 00 00 00    	jle    8020dc <vprintfmt+0x228>
				for (width -= strnlen(p, precision); width > 0; width--)
  802048:	89 74 24 04          	mov    %esi,0x4(%esp)
  80204c:	89 3c 24             	mov    %edi,(%esp)
  80204f:	e8 24 e1 ff ff       	call   800178 <strnlen>
  802054:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  802057:	29 c1                	sub    %eax,%ecx
  802059:	89 4d e0             	mov    %ecx,-0x20(%ebp)
					putch(padc, putdat);
  80205c:	0f be 45 dc          	movsbl -0x24(%ebp),%eax
  802060:	89 7d dc             	mov    %edi,-0x24(%ebp)
  802063:	89 75 d8             	mov    %esi,-0x28(%ebp)
  802066:	8b 75 08             	mov    0x8(%ebp),%esi
  802069:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80206c:	89 cb                	mov    %ecx,%ebx
  80206e:	89 c7                	mov    %eax,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802070:	eb 0f                	jmp    802081 <vprintfmt+0x1cd>
					putch(padc, putdat);
  802072:	8b 45 0c             	mov    0xc(%ebp),%eax
  802075:	89 44 24 04          	mov    %eax,0x4(%esp)
  802079:	89 3c 24             	mov    %edi,(%esp)
  80207c:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80207e:	83 eb 01             	sub    $0x1,%ebx
  802081:	85 db                	test   %ebx,%ebx
  802083:	7f ed                	jg     802072 <vprintfmt+0x1be>
  802085:	8b 7d dc             	mov    -0x24(%ebp),%edi
  802088:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80208b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80208e:	85 c9                	test   %ecx,%ecx
  802090:	b8 00 00 00 00       	mov    $0x0,%eax
  802095:	0f 49 c1             	cmovns %ecx,%eax
  802098:	29 c1                	sub    %eax,%ecx
  80209a:	89 cb                	mov    %ecx,%ebx
  80209c:	eb 44                	jmp    8020e2 <vprintfmt+0x22e>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80209e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020a2:	74 1e                	je     8020c2 <vprintfmt+0x20e>
  8020a4:	0f be d2             	movsbl %dl,%edx
  8020a7:	83 ea 20             	sub    $0x20,%edx
  8020aa:	83 fa 5e             	cmp    $0x5e,%edx
  8020ad:	76 13                	jbe    8020c2 <vprintfmt+0x20e>
					putch('?', putdat);
  8020af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8020bd:	ff 55 08             	call   *0x8(%ebp)
  8020c0:	eb 0d                	jmp    8020cf <vprintfmt+0x21b>
				else
					putch(ch, putdat);
  8020c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020c5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020c9:	89 04 24             	mov    %eax,(%esp)
  8020cc:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8020cf:	83 eb 01             	sub    $0x1,%ebx
  8020d2:	eb 0e                	jmp    8020e2 <vprintfmt+0x22e>
  8020d4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8020d7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8020da:	eb 06                	jmp    8020e2 <vprintfmt+0x22e>
  8020dc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8020df:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8020e2:	83 c7 01             	add    $0x1,%edi
  8020e5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8020e9:	0f be c2             	movsbl %dl,%eax
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	74 27                	je     802117 <vprintfmt+0x263>
  8020f0:	85 f6                	test   %esi,%esi
  8020f2:	78 aa                	js     80209e <vprintfmt+0x1ea>
  8020f4:	83 ee 01             	sub    $0x1,%esi
  8020f7:	79 a5                	jns    80209e <vprintfmt+0x1ea>
  8020f9:	89 d8                	mov    %ebx,%eax
  8020fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8020fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802101:	89 c3                	mov    %eax,%ebx
  802103:	eb 18                	jmp    80211d <vprintfmt+0x269>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  802105:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802109:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  802110:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802112:	83 eb 01             	sub    $0x1,%ebx
  802115:	eb 06                	jmp    80211d <vprintfmt+0x269>
  802117:	8b 75 08             	mov    0x8(%ebp),%esi
  80211a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80211d:	85 db                	test   %ebx,%ebx
  80211f:	7f e4                	jg     802105 <vprintfmt+0x251>
  802121:	89 75 08             	mov    %esi,0x8(%ebp)
  802124:	89 7d 0c             	mov    %edi,0xc(%ebp)
  802127:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80212a:	e9 aa fd ff ff       	jmp    801ed9 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80212f:	83 f9 01             	cmp    $0x1,%ecx
  802132:	7e 10                	jle    802144 <vprintfmt+0x290>
		return va_arg(*ap, long long);
  802134:	8b 45 14             	mov    0x14(%ebp),%eax
  802137:	8b 30                	mov    (%eax),%esi
  802139:	8b 78 04             	mov    0x4(%eax),%edi
  80213c:	8d 40 08             	lea    0x8(%eax),%eax
  80213f:	89 45 14             	mov    %eax,0x14(%ebp)
  802142:	eb 26                	jmp    80216a <vprintfmt+0x2b6>
	else if (lflag)
  802144:	85 c9                	test   %ecx,%ecx
  802146:	74 12                	je     80215a <vprintfmt+0x2a6>
		return va_arg(*ap, long);
  802148:	8b 45 14             	mov    0x14(%ebp),%eax
  80214b:	8b 30                	mov    (%eax),%esi
  80214d:	89 f7                	mov    %esi,%edi
  80214f:	c1 ff 1f             	sar    $0x1f,%edi
  802152:	8d 40 04             	lea    0x4(%eax),%eax
  802155:	89 45 14             	mov    %eax,0x14(%ebp)
  802158:	eb 10                	jmp    80216a <vprintfmt+0x2b6>
	else
		return va_arg(*ap, int);
  80215a:	8b 45 14             	mov    0x14(%ebp),%eax
  80215d:	8b 30                	mov    (%eax),%esi
  80215f:	89 f7                	mov    %esi,%edi
  802161:	c1 ff 1f             	sar    $0x1f,%edi
  802164:	8d 40 04             	lea    0x4(%eax),%eax
  802167:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80216a:	89 f0                	mov    %esi,%eax
  80216c:	89 fa                	mov    %edi,%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80216e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  802173:	85 ff                	test   %edi,%edi
  802175:	0f 89 3a 01 00 00    	jns    8022b5 <vprintfmt+0x401>
				putch('-', putdat);
  80217b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802182:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  802189:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80218c:	89 f0                	mov    %esi,%eax
  80218e:	89 fa                	mov    %edi,%edx
  802190:	f7 d8                	neg    %eax
  802192:	83 d2 00             	adc    $0x0,%edx
  802195:	f7 da                	neg    %edx
			}
			base = 10;
  802197:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80219c:	e9 14 01 00 00       	jmp    8022b5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8021a1:	83 f9 01             	cmp    $0x1,%ecx
  8021a4:	7e 13                	jle    8021b9 <vprintfmt+0x305>
		return va_arg(*ap, unsigned long long);
  8021a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a9:	8b 50 04             	mov    0x4(%eax),%edx
  8021ac:	8b 00                	mov    (%eax),%eax
  8021ae:	8b 75 14             	mov    0x14(%ebp),%esi
  8021b1:	8d 4e 08             	lea    0x8(%esi),%ecx
  8021b4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8021b7:	eb 2c                	jmp    8021e5 <vprintfmt+0x331>
	else if (lflag)
  8021b9:	85 c9                	test   %ecx,%ecx
  8021bb:	74 15                	je     8021d2 <vprintfmt+0x31e>
		return va_arg(*ap, unsigned long);
  8021bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8021c0:	8b 00                	mov    (%eax),%eax
  8021c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c7:	8b 75 14             	mov    0x14(%ebp),%esi
  8021ca:	8d 76 04             	lea    0x4(%esi),%esi
  8021cd:	89 75 14             	mov    %esi,0x14(%ebp)
  8021d0:	eb 13                	jmp    8021e5 <vprintfmt+0x331>
	else
		return va_arg(*ap, unsigned int);
  8021d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d5:	8b 00                	mov    (%eax),%eax
  8021d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021dc:	8b 75 14             	mov    0x14(%ebp),%esi
  8021df:	8d 76 04             	lea    0x4(%esi),%esi
  8021e2:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8021e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8021ea:	e9 c6 00 00 00       	jmp    8022b5 <vprintfmt+0x401>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8021ef:	83 f9 01             	cmp    $0x1,%ecx
  8021f2:	7e 13                	jle    802207 <vprintfmt+0x353>
		return va_arg(*ap, long long);
  8021f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f7:	8b 50 04             	mov    0x4(%eax),%edx
  8021fa:	8b 00                	mov    (%eax),%eax
  8021fc:	8b 75 14             	mov    0x14(%ebp),%esi
  8021ff:	8d 4e 08             	lea    0x8(%esi),%ecx
  802202:	89 4d 14             	mov    %ecx,0x14(%ebp)
  802205:	eb 24                	jmp    80222b <vprintfmt+0x377>
	else if (lflag)
  802207:	85 c9                	test   %ecx,%ecx
  802209:	74 11                	je     80221c <vprintfmt+0x368>
		return va_arg(*ap, long);
  80220b:	8b 45 14             	mov    0x14(%ebp),%eax
  80220e:	8b 00                	mov    (%eax),%eax
  802210:	99                   	cltd   
  802211:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802214:	8d 71 04             	lea    0x4(%ecx),%esi
  802217:	89 75 14             	mov    %esi,0x14(%ebp)
  80221a:	eb 0f                	jmp    80222b <vprintfmt+0x377>
	else
		return va_arg(*ap, int);
  80221c:	8b 45 14             	mov    0x14(%ebp),%eax
  80221f:	8b 00                	mov    (%eax),%eax
  802221:	99                   	cltd   
  802222:	8b 75 14             	mov    0x14(%ebp),%esi
  802225:	8d 76 04             	lea    0x4(%esi),%esi
  802228:	89 75 14             	mov    %esi,0x14(%ebp)
		// (unsigned) octal
		case 'o':
			// Replace this with your code.

			num = getint(&ap, lflag);
			base = 8;
  80222b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  802230:	e9 80 00 00 00       	jmp    8022b5 <vprintfmt+0x401>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802235:	8b 75 14             	mov    0x14(%ebp),%esi
			base = 8;
			goto number;

		// pointer
		case 'p':
			putch('0', putdat);
  802238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  802246:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  802249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802250:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  802257:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80225a:	83 45 14 04          	addl   $0x4,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80225e:	8b 06                	mov    (%esi),%eax
  802260:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  802265:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80226a:	eb 49                	jmp    8022b5 <vprintfmt+0x401>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80226c:	83 f9 01             	cmp    $0x1,%ecx
  80226f:	7e 13                	jle    802284 <vprintfmt+0x3d0>
		return va_arg(*ap, unsigned long long);
  802271:	8b 45 14             	mov    0x14(%ebp),%eax
  802274:	8b 50 04             	mov    0x4(%eax),%edx
  802277:	8b 00                	mov    (%eax),%eax
  802279:	8b 75 14             	mov    0x14(%ebp),%esi
  80227c:	8d 4e 08             	lea    0x8(%esi),%ecx
  80227f:	89 4d 14             	mov    %ecx,0x14(%ebp)
  802282:	eb 2c                	jmp    8022b0 <vprintfmt+0x3fc>
	else if (lflag)
  802284:	85 c9                	test   %ecx,%ecx
  802286:	74 15                	je     80229d <vprintfmt+0x3e9>
		return va_arg(*ap, unsigned long);
  802288:	8b 45 14             	mov    0x14(%ebp),%eax
  80228b:	8b 00                	mov    (%eax),%eax
  80228d:	ba 00 00 00 00       	mov    $0x0,%edx
  802292:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802295:	8d 71 04             	lea    0x4(%ecx),%esi
  802298:	89 75 14             	mov    %esi,0x14(%ebp)
  80229b:	eb 13                	jmp    8022b0 <vprintfmt+0x3fc>
	else
		return va_arg(*ap, unsigned int);
  80229d:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a0:	8b 00                	mov    (%eax),%eax
  8022a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a7:	8b 75 14             	mov    0x14(%ebp),%esi
  8022aa:	8d 76 04             	lea    0x4(%esi),%esi
  8022ad:	89 75 14             	mov    %esi,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8022b0:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8022b5:	0f be 75 dc          	movsbl -0x24(%ebp),%esi
  8022b9:	89 74 24 10          	mov    %esi,0x10(%esp)
  8022bd:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8022c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8022c4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022c8:	89 04 24             	mov    %eax,(%esp)
  8022cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	e8 a6 fa ff ff       	call   801d80 <printnum>
			break;
  8022da:	e9 fa fb ff ff       	jmp    801ed9 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8022df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022e6:	89 04 24             	mov    %eax,(%esp)
  8022e9:	ff 55 08             	call   *0x8(%ebp)
			break;
  8022ec:	e9 e8 fb ff ff       	jmp    801ed9 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8022f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8022ff:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  802302:	89 fb                	mov    %edi,%ebx
  802304:	eb 03                	jmp    802309 <vprintfmt+0x455>
  802306:	83 eb 01             	sub    $0x1,%ebx
  802309:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  80230d:	75 f7                	jne    802306 <vprintfmt+0x452>
  80230f:	90                   	nop
  802310:	e9 c4 fb ff ff       	jmp    801ed9 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  802315:	83 c4 3c             	add    $0x3c,%esp
  802318:	5b                   	pop    %ebx
  802319:	5e                   	pop    %esi
  80231a:	5f                   	pop    %edi
  80231b:	5d                   	pop    %ebp
  80231c:	c3                   	ret    

0080231d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 28             	sub    $0x28,%esp
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802329:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80232c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802330:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802333:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80233a:	85 c0                	test   %eax,%eax
  80233c:	74 30                	je     80236e <vsnprintf+0x51>
  80233e:	85 d2                	test   %edx,%edx
  802340:	7e 2c                	jle    80236e <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802342:	8b 45 14             	mov    0x14(%ebp),%eax
  802345:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802349:	8b 45 10             	mov    0x10(%ebp),%eax
  80234c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802350:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802353:	89 44 24 04          	mov    %eax,0x4(%esp)
  802357:	c7 04 24 6f 1e 80 00 	movl   $0x801e6f,(%esp)
  80235e:	e8 51 fb ff ff       	call   801eb4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802363:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802366:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	eb 05                	jmp    802373 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80236e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80237b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80237e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802382:	8b 45 10             	mov    0x10(%ebp),%eax
  802385:	89 44 24 08          	mov    %eax,0x8(%esp)
  802389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	89 04 24             	mov    %eax,(%esp)
  802396:	e8 82 ff ff ff       	call   80231d <vsnprintf>
	va_end(ap);

	return rc;
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    
  80239d:	66 90                	xchg   %ax,%ax
  80239f:	90                   	nop

008023a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	56                   	push   %esi
  8023a4:	53                   	push   %ebx
  8023a5:	83 ec 10             	sub    $0x10,%esp
  8023a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8023ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	//cprintf("\n receiver got control id:%x\n",thisenv->env_id);
	if(pg == NULL)
  8023b1:	85 c0                	test   %eax,%eax
		pg = (void *)0xF0000000;
  8023b3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8023b8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8023bb:	89 04 24             	mov    %eax,(%esp)
  8023be:	e8 78 e4 ff ff       	call   80083b <sys_ipc_recv>
	//cprintf("\nreceived ret:%d envid:%x\n",ret, thisenv->env_id);
	if(!ret)
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	75 26                	jne    8023ed <ipc_recv+0x4d>
	{
		//successfully received the message
		if(from_env_store)
  8023c7:	85 f6                	test   %esi,%esi
  8023c9:	74 0a                	je     8023d5 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8023cb:	a1 08 40 80 00       	mov    0x804008,%eax
  8023d0:	8b 40 74             	mov    0x74(%eax),%eax
  8023d3:	89 06                	mov    %eax,(%esi)
		if(perm_store)
  8023d5:	85 db                	test   %ebx,%ebx
  8023d7:	74 0a                	je     8023e3 <ipc_recv+0x43>
			*perm_store = thisenv->env_ipc_perm;
  8023d9:	a1 08 40 80 00       	mov    0x804008,%eax
  8023de:	8b 40 78             	mov    0x78(%eax),%eax
  8023e1:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8023e3:	a1 08 40 80 00       	mov    0x804008,%eax
  8023e8:	8b 40 70             	mov    0x70(%eax),%eax
  8023eb:	eb 14                	jmp    802401 <ipc_recv+0x61>
	}
	else
	{
		if(from_env_store)
  8023ed:	85 f6                	test   %esi,%esi
  8023ef:	74 06                	je     8023f7 <ipc_recv+0x57>
			*from_env_store = 0;
  8023f1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8023f7:	85 db                	test   %ebx,%ebx
  8023f9:	74 06                	je     802401 <ipc_recv+0x61>
			*perm_store = 0;
  8023fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return ret;
	}

	return ret;
}
  802401:	83 c4 10             	add    $0x10,%esp
  802404:	5b                   	pop    %ebx
  802405:	5e                   	pop    %esi
  802406:	5d                   	pop    %ebp
  802407:	c3                   	ret    

00802408 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
  80240b:	57                   	push   %edi
  80240c:	56                   	push   %esi
  80240d:	53                   	push   %ebx
  80240e:	83 ec 1c             	sub    $0x1c,%esp
  802411:	8b 7d 08             	mov    0x8(%ebp),%edi
  802414:	8b 75 0c             	mov    0xc(%ebp),%esi
  802417:	8b 5d 10             	mov    0x10(%ebp),%ebx

	//env_upd = &envs[ENVX(sys_getenvid())];
	//thisenv = env_upd;
	//Setting pg > UTOP if pg ==NULL
	//This indicates that receiver don't need page mapping
	if(pg == NULL)
  80241a:	85 db                	test   %ebx,%ebx
		pg = (void *)0xF0000000;
  80241c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802421:	0f 44 d8             	cmove  %eax,%ebx
	while(1)
	{
		//cprintf("\nsend-ipc trying send env_id:%x\n",thisenv->env_id);
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802424:	8b 45 14             	mov    0x14(%ebp),%eax
  802427:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80242b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80242f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802433:	89 3c 24             	mov    %edi,(%esp)
  802436:	e8 dd e3 ff ff       	call   800818 <sys_ipc_try_send>
		//cprintf("\nsend return value:%d env_id:%x\n",ret, thisenv->env_id);
		if(ret==0)
  80243b:	85 c0                	test   %eax,%eax
  80243d:	74 28                	je     802467 <ipc_send+0x5f>
			break;
		else if(ret != -E_IPC_NOT_RECV){
  80243f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802442:	74 1c                	je     802460 <ipc_send+0x58>
			panic("\nError while sending IPC message");
  802444:	c7 44 24 08 38 2c 80 	movl   $0x802c38,0x8(%esp)
  80244b:	00 
  80244c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  802453:	00 
  802454:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  80245b:	e8 06 f8 ff ff       	call   801c66 <_panic>
		}
		//cprintf("\nsend yielding:%x", thisenv->env_id);
		sys_yield();			
  802460:	e8 81 e1 ff ff       	call   8005e6 <sys_yield>
	}
  802465:	eb bd                	jmp    802424 <ipc_send+0x1c>
	//sys_yield();
	//cprintf("\nsender successfully yielding\n");
	//sys_yield();
	//cprintf("\nexiting send\n");
	
}
  802467:	83 c4 1c             	add    $0x1c,%esp
  80246a:	5b                   	pop    %ebx
  80246b:	5e                   	pop    %esi
  80246c:	5f                   	pop    %edi
  80246d:	5d                   	pop    %ebp
  80246e:	c3                   	ret    

0080246f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
  802472:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802475:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80247a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80247d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802483:	8b 52 50             	mov    0x50(%edx),%edx
  802486:	39 ca                	cmp    %ecx,%edx
  802488:	75 0d                	jne    802497 <ipc_find_env+0x28>
			return envs[i].env_id;
  80248a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80248d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802492:	8b 40 40             	mov    0x40(%eax),%eax
  802495:	eb 0e                	jmp    8024a5 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802497:	83 c0 01             	add    $0x1,%eax
  80249a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80249f:	75 d9                	jne    80247a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024a1:	66 b8 00 00          	mov    $0x0,%ax
}
  8024a5:	5d                   	pop    %ebp
  8024a6:	c3                   	ret    

008024a7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024ad:	89 d0                	mov    %edx,%eax
  8024af:	c1 e8 16             	shr    $0x16,%eax
  8024b2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024b9:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024be:	f6 c1 01             	test   $0x1,%cl
  8024c1:	74 1d                	je     8024e0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024c3:	c1 ea 0c             	shr    $0xc,%edx
  8024c6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024cd:	f6 c2 01             	test   $0x1,%dl
  8024d0:	74 0e                	je     8024e0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024d2:	c1 ea 0c             	shr    $0xc,%edx
  8024d5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024dc:	ef 
  8024dd:	0f b7 c0             	movzwl %ax,%eax
}
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    
  8024e2:	66 90                	xchg   %ax,%ax
  8024e4:	66 90                	xchg   %ax,%ax
  8024e6:	66 90                	xchg   %ax,%ax
  8024e8:	66 90                	xchg   %ax,%ax
  8024ea:	66 90                	xchg   %ax,%ax
  8024ec:	66 90                	xchg   %ax,%ax
  8024ee:	66 90                	xchg   %ax,%ax

008024f0 <__udivdi3>:
  8024f0:	55                   	push   %ebp
  8024f1:	57                   	push   %edi
  8024f2:	56                   	push   %esi
  8024f3:	83 ec 0c             	sub    $0xc,%esp
  8024f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024fa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8024fe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802502:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802506:	85 c0                	test   %eax,%eax
  802508:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80250c:	89 ea                	mov    %ebp,%edx
  80250e:	89 0c 24             	mov    %ecx,(%esp)
  802511:	75 2d                	jne    802540 <__udivdi3+0x50>
  802513:	39 e9                	cmp    %ebp,%ecx
  802515:	77 61                	ja     802578 <__udivdi3+0x88>
  802517:	85 c9                	test   %ecx,%ecx
  802519:	89 ce                	mov    %ecx,%esi
  80251b:	75 0b                	jne    802528 <__udivdi3+0x38>
  80251d:	b8 01 00 00 00       	mov    $0x1,%eax
  802522:	31 d2                	xor    %edx,%edx
  802524:	f7 f1                	div    %ecx
  802526:	89 c6                	mov    %eax,%esi
  802528:	31 d2                	xor    %edx,%edx
  80252a:	89 e8                	mov    %ebp,%eax
  80252c:	f7 f6                	div    %esi
  80252e:	89 c5                	mov    %eax,%ebp
  802530:	89 f8                	mov    %edi,%eax
  802532:	f7 f6                	div    %esi
  802534:	89 ea                	mov    %ebp,%edx
  802536:	83 c4 0c             	add    $0xc,%esp
  802539:	5e                   	pop    %esi
  80253a:	5f                   	pop    %edi
  80253b:	5d                   	pop    %ebp
  80253c:	c3                   	ret    
  80253d:	8d 76 00             	lea    0x0(%esi),%esi
  802540:	39 e8                	cmp    %ebp,%eax
  802542:	77 24                	ja     802568 <__udivdi3+0x78>
  802544:	0f bd e8             	bsr    %eax,%ebp
  802547:	83 f5 1f             	xor    $0x1f,%ebp
  80254a:	75 3c                	jne    802588 <__udivdi3+0x98>
  80254c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802550:	39 34 24             	cmp    %esi,(%esp)
  802553:	0f 86 9f 00 00 00    	jbe    8025f8 <__udivdi3+0x108>
  802559:	39 d0                	cmp    %edx,%eax
  80255b:	0f 82 97 00 00 00    	jb     8025f8 <__udivdi3+0x108>
  802561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802568:	31 d2                	xor    %edx,%edx
  80256a:	31 c0                	xor    %eax,%eax
  80256c:	83 c4 0c             	add    $0xc,%esp
  80256f:	5e                   	pop    %esi
  802570:	5f                   	pop    %edi
  802571:	5d                   	pop    %ebp
  802572:	c3                   	ret    
  802573:	90                   	nop
  802574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802578:	89 f8                	mov    %edi,%eax
  80257a:	f7 f1                	div    %ecx
  80257c:	31 d2                	xor    %edx,%edx
  80257e:	83 c4 0c             	add    $0xc,%esp
  802581:	5e                   	pop    %esi
  802582:	5f                   	pop    %edi
  802583:	5d                   	pop    %ebp
  802584:	c3                   	ret    
  802585:	8d 76 00             	lea    0x0(%esi),%esi
  802588:	89 e9                	mov    %ebp,%ecx
  80258a:	8b 3c 24             	mov    (%esp),%edi
  80258d:	d3 e0                	shl    %cl,%eax
  80258f:	89 c6                	mov    %eax,%esi
  802591:	b8 20 00 00 00       	mov    $0x20,%eax
  802596:	29 e8                	sub    %ebp,%eax
  802598:	89 c1                	mov    %eax,%ecx
  80259a:	d3 ef                	shr    %cl,%edi
  80259c:	89 e9                	mov    %ebp,%ecx
  80259e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025a2:	8b 3c 24             	mov    (%esp),%edi
  8025a5:	09 74 24 08          	or     %esi,0x8(%esp)
  8025a9:	89 d6                	mov    %edx,%esi
  8025ab:	d3 e7                	shl    %cl,%edi
  8025ad:	89 c1                	mov    %eax,%ecx
  8025af:	89 3c 24             	mov    %edi,(%esp)
  8025b2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025b6:	d3 ee                	shr    %cl,%esi
  8025b8:	89 e9                	mov    %ebp,%ecx
  8025ba:	d3 e2                	shl    %cl,%edx
  8025bc:	89 c1                	mov    %eax,%ecx
  8025be:	d3 ef                	shr    %cl,%edi
  8025c0:	09 d7                	or     %edx,%edi
  8025c2:	89 f2                	mov    %esi,%edx
  8025c4:	89 f8                	mov    %edi,%eax
  8025c6:	f7 74 24 08          	divl   0x8(%esp)
  8025ca:	89 d6                	mov    %edx,%esi
  8025cc:	89 c7                	mov    %eax,%edi
  8025ce:	f7 24 24             	mull   (%esp)
  8025d1:	39 d6                	cmp    %edx,%esi
  8025d3:	89 14 24             	mov    %edx,(%esp)
  8025d6:	72 30                	jb     802608 <__udivdi3+0x118>
  8025d8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025dc:	89 e9                	mov    %ebp,%ecx
  8025de:	d3 e2                	shl    %cl,%edx
  8025e0:	39 c2                	cmp    %eax,%edx
  8025e2:	73 05                	jae    8025e9 <__udivdi3+0xf9>
  8025e4:	3b 34 24             	cmp    (%esp),%esi
  8025e7:	74 1f                	je     802608 <__udivdi3+0x118>
  8025e9:	89 f8                	mov    %edi,%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	e9 7a ff ff ff       	jmp    80256c <__udivdi3+0x7c>
  8025f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025f8:	31 d2                	xor    %edx,%edx
  8025fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ff:	e9 68 ff ff ff       	jmp    80256c <__udivdi3+0x7c>
  802604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802608:	8d 47 ff             	lea    -0x1(%edi),%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	83 c4 0c             	add    $0xc,%esp
  802610:	5e                   	pop    %esi
  802611:	5f                   	pop    %edi
  802612:	5d                   	pop    %ebp
  802613:	c3                   	ret    
  802614:	66 90                	xchg   %ax,%ax
  802616:	66 90                	xchg   %ax,%ax
  802618:	66 90                	xchg   %ax,%ax
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	66 90                	xchg   %ax,%ax
  80261e:	66 90                	xchg   %ax,%ax

00802620 <__umoddi3>:
  802620:	55                   	push   %ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	83 ec 14             	sub    $0x14,%esp
  802626:	8b 44 24 28          	mov    0x28(%esp),%eax
  80262a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80262e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802632:	89 c7                	mov    %eax,%edi
  802634:	89 44 24 04          	mov    %eax,0x4(%esp)
  802638:	8b 44 24 30          	mov    0x30(%esp),%eax
  80263c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802640:	89 34 24             	mov    %esi,(%esp)
  802643:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802647:	85 c0                	test   %eax,%eax
  802649:	89 c2                	mov    %eax,%edx
  80264b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80264f:	75 17                	jne    802668 <__umoddi3+0x48>
  802651:	39 fe                	cmp    %edi,%esi
  802653:	76 4b                	jbe    8026a0 <__umoddi3+0x80>
  802655:	89 c8                	mov    %ecx,%eax
  802657:	89 fa                	mov    %edi,%edx
  802659:	f7 f6                	div    %esi
  80265b:	89 d0                	mov    %edx,%eax
  80265d:	31 d2                	xor    %edx,%edx
  80265f:	83 c4 14             	add    $0x14,%esp
  802662:	5e                   	pop    %esi
  802663:	5f                   	pop    %edi
  802664:	5d                   	pop    %ebp
  802665:	c3                   	ret    
  802666:	66 90                	xchg   %ax,%ax
  802668:	39 f8                	cmp    %edi,%eax
  80266a:	77 54                	ja     8026c0 <__umoddi3+0xa0>
  80266c:	0f bd e8             	bsr    %eax,%ebp
  80266f:	83 f5 1f             	xor    $0x1f,%ebp
  802672:	75 5c                	jne    8026d0 <__umoddi3+0xb0>
  802674:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802678:	39 3c 24             	cmp    %edi,(%esp)
  80267b:	0f 87 e7 00 00 00    	ja     802768 <__umoddi3+0x148>
  802681:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802685:	29 f1                	sub    %esi,%ecx
  802687:	19 c7                	sbb    %eax,%edi
  802689:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80268d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802691:	8b 44 24 08          	mov    0x8(%esp),%eax
  802695:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802699:	83 c4 14             	add    $0x14,%esp
  80269c:	5e                   	pop    %esi
  80269d:	5f                   	pop    %edi
  80269e:	5d                   	pop    %ebp
  80269f:	c3                   	ret    
  8026a0:	85 f6                	test   %esi,%esi
  8026a2:	89 f5                	mov    %esi,%ebp
  8026a4:	75 0b                	jne    8026b1 <__umoddi3+0x91>
  8026a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ab:	31 d2                	xor    %edx,%edx
  8026ad:	f7 f6                	div    %esi
  8026af:	89 c5                	mov    %eax,%ebp
  8026b1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026b5:	31 d2                	xor    %edx,%edx
  8026b7:	f7 f5                	div    %ebp
  8026b9:	89 c8                	mov    %ecx,%eax
  8026bb:	f7 f5                	div    %ebp
  8026bd:	eb 9c                	jmp    80265b <__umoddi3+0x3b>
  8026bf:	90                   	nop
  8026c0:	89 c8                	mov    %ecx,%eax
  8026c2:	89 fa                	mov    %edi,%edx
  8026c4:	83 c4 14             	add    $0x14,%esp
  8026c7:	5e                   	pop    %esi
  8026c8:	5f                   	pop    %edi
  8026c9:	5d                   	pop    %ebp
  8026ca:	c3                   	ret    
  8026cb:	90                   	nop
  8026cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026d0:	8b 04 24             	mov    (%esp),%eax
  8026d3:	be 20 00 00 00       	mov    $0x20,%esi
  8026d8:	89 e9                	mov    %ebp,%ecx
  8026da:	29 ee                	sub    %ebp,%esi
  8026dc:	d3 e2                	shl    %cl,%edx
  8026de:	89 f1                	mov    %esi,%ecx
  8026e0:	d3 e8                	shr    %cl,%eax
  8026e2:	89 e9                	mov    %ebp,%ecx
  8026e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e8:	8b 04 24             	mov    (%esp),%eax
  8026eb:	09 54 24 04          	or     %edx,0x4(%esp)
  8026ef:	89 fa                	mov    %edi,%edx
  8026f1:	d3 e0                	shl    %cl,%eax
  8026f3:	89 f1                	mov    %esi,%ecx
  8026f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026f9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8026fd:	d3 ea                	shr    %cl,%edx
  8026ff:	89 e9                	mov    %ebp,%ecx
  802701:	d3 e7                	shl    %cl,%edi
  802703:	89 f1                	mov    %esi,%ecx
  802705:	d3 e8                	shr    %cl,%eax
  802707:	89 e9                	mov    %ebp,%ecx
  802709:	09 f8                	or     %edi,%eax
  80270b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80270f:	f7 74 24 04          	divl   0x4(%esp)
  802713:	d3 e7                	shl    %cl,%edi
  802715:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802719:	89 d7                	mov    %edx,%edi
  80271b:	f7 64 24 08          	mull   0x8(%esp)
  80271f:	39 d7                	cmp    %edx,%edi
  802721:	89 c1                	mov    %eax,%ecx
  802723:	89 14 24             	mov    %edx,(%esp)
  802726:	72 2c                	jb     802754 <__umoddi3+0x134>
  802728:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80272c:	72 22                	jb     802750 <__umoddi3+0x130>
  80272e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802732:	29 c8                	sub    %ecx,%eax
  802734:	19 d7                	sbb    %edx,%edi
  802736:	89 e9                	mov    %ebp,%ecx
  802738:	89 fa                	mov    %edi,%edx
  80273a:	d3 e8                	shr    %cl,%eax
  80273c:	89 f1                	mov    %esi,%ecx
  80273e:	d3 e2                	shl    %cl,%edx
  802740:	89 e9                	mov    %ebp,%ecx
  802742:	d3 ef                	shr    %cl,%edi
  802744:	09 d0                	or     %edx,%eax
  802746:	89 fa                	mov    %edi,%edx
  802748:	83 c4 14             	add    $0x14,%esp
  80274b:	5e                   	pop    %esi
  80274c:	5f                   	pop    %edi
  80274d:	5d                   	pop    %ebp
  80274e:	c3                   	ret    
  80274f:	90                   	nop
  802750:	39 d7                	cmp    %edx,%edi
  802752:	75 da                	jne    80272e <__umoddi3+0x10e>
  802754:	8b 14 24             	mov    (%esp),%edx
  802757:	89 c1                	mov    %eax,%ecx
  802759:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80275d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802761:	eb cb                	jmp    80272e <__umoddi3+0x10e>
  802763:	90                   	nop
  802764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802768:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80276c:	0f 82 0f ff ff ff    	jb     802681 <__umoddi3+0x61>
  802772:	e9 1a ff ff ff       	jmp    802691 <__umoddi3+0x71>
