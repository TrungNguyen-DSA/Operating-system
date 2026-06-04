
user/_racetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#define N 50

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  int pid;
  
  printf("=== WITHOUT LOCK ===\n");
   a:	00001517          	auipc	a0,0x1
   e:	92650513          	addi	a0,a0,-1754 # 930 <malloc+0xfc>
  12:	76e000ef          	jal	780 <printf>
  16:	03200493          	li	s1,50
  for(int i = 0; i < N; i++){
    pid = fork();
  1a:	2fe000ef          	jal	318 <fork>
    if(pid == 0){
  1e:	cd29                	beqz	a0,78 <main+0x78>
  for(int i = 0; i < N; i++){
  20:	34fd                	addiw	s1,s1,-1
  22:	fce5                	bnez	s1,1a <main+0x1a>
  24:	03200493          	li	s1,50
      testnolock();
      exit(0);
    }
  }
  for(int i = 0; i < N; i++){
    wait(0);
  28:	4501                	li	a0,0
  2a:	2fe000ef          	jal	328 <wait>
  for(int i = 0; i < N; i++){
  2e:	34fd                	addiw	s1,s1,-1
  30:	fce5                	bnez	s1,28 <main+0x28>
  }
  printf("Race condition test finished.\n");
  32:	00001517          	auipc	a0,0x1
  36:	91650513          	addi	a0,a0,-1770 # 948 <malloc+0x114>
  3a:	746000ef          	jal	780 <printf>

  printf("\n=== WITH SPINLOCK ===\n");
  3e:	00001517          	auipc	a0,0x1
  42:	92a50513          	addi	a0,a0,-1750 # 968 <malloc+0x134>
  46:	73a000ef          	jal	780 <printf>
  4a:	03200493          	li	s1,50
  for(int i = 0; i < N; i++){
    pid = fork();
  4e:	2ca000ef          	jal	318 <fork>
    if(pid == 0){
  52:	c905                	beqz	a0,82 <main+0x82>
  for(int i = 0; i < N; i++){
  54:	34fd                	addiw	s1,s1,-1
  56:	fce5                	bnez	s1,4e <main+0x4e>
  58:	03200493          	li	s1,50
      testlock();
      exit(0);
    }
  }
  for(int i = 0; i < N; i++){
    wait(0);
  5c:	4501                	li	a0,0
  5e:	2ca000ef          	jal	328 <wait>
  for(int i = 0; i < N; i++){
  62:	34fd                	addiw	s1,s1,-1
  64:	fce5                	bnez	s1,5c <main+0x5c>
  }
  printf("Spinlock test finished.\n");
  66:	00001517          	auipc	a0,0x1
  6a:	91a50513          	addi	a0,a0,-1766 # 980 <malloc+0x14c>
  6e:	712000ef          	jal	780 <printf>

  exit(0);
  72:	4501                	li	a0,0
  74:	2ac000ef          	jal	320 <exit>
      testnolock();
  78:	360000ef          	jal	3d8 <testnolock>
      exit(0);
  7c:	4501                	li	a0,0
  7e:	2a2000ef          	jal	320 <exit>
      testlock();
  82:	35e000ef          	jal	3e0 <testlock>
      exit(0);
  86:	4501                	li	a0,0
  88:	298000ef          	jal	320 <exit>

000000000000008c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  94:	f6dff0ef          	jal	0 <main>
  exit(r);
  98:	288000ef          	jal	320 <exit>

000000000000009c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a2:	87aa                	mv	a5,a0
  a4:	0585                	addi	a1,a1,1
  a6:	0785                	addi	a5,a5,1
  a8:	fff5c703          	lbu	a4,-1(a1)
  ac:	fee78fa3          	sb	a4,-1(a5)
  b0:	fb75                	bnez	a4,a4 <strcpy+0x8>
    ;
  return os;
}
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cb91                	beqz	a5,d6 <strcmp+0x1e>
  c4:	0005c703          	lbu	a4,0(a1)
  c8:	00f71763          	bne	a4,a5,d6 <strcmp+0x1e>
    p++, q++;
  cc:	0505                	addi	a0,a0,1
  ce:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbe5                	bnez	a5,c4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d6:	0005c503          	lbu	a0,0(a1)
}
  da:	40a7853b          	subw	a0,a5,a0
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strlen>:

uint
strlen(const char *s)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e422                	sd	s0,8(sp)
  e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	cf91                	beqz	a5,10a <strlen+0x26>
  f0:	0505                	addi	a0,a0,1
  f2:	87aa                	mv	a5,a0
  f4:	86be                	mv	a3,a5
  f6:	0785                	addi	a5,a5,1
  f8:	fff7c703          	lbu	a4,-1(a5)
  fc:	ff65                	bnez	a4,f4 <strlen+0x10>
  fe:	40a6853b          	subw	a0,a3,a0
 102:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  for(n = 0; s[n]; n++)
 10a:	4501                	li	a0,0
 10c:	bfe5                	j	104 <strlen+0x20>

000000000000010e <memset>:

void*
memset(void *dst, int c, uint n)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 114:	ca19                	beqz	a2,12a <memset+0x1c>
 116:	87aa                	mv	a5,a0
 118:	1602                	slli	a2,a2,0x20
 11a:	9201                	srli	a2,a2,0x20
 11c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 120:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 124:	0785                	addi	a5,a5,1
 126:	fee79de3          	bne	a5,a4,120 <memset+0x12>
  }
  return dst;
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  for(; *s; s++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cb99                	beqz	a5,150 <strchr+0x20>
    if(*s == c)
 13c:	00f58763          	beq	a1,a5,14a <strchr+0x1a>
  for(; *s; s++)
 140:	0505                	addi	a0,a0,1
 142:	00054783          	lbu	a5,0(a0)
 146:	fbfd                	bnez	a5,13c <strchr+0xc>
      return (char*)s;
  return 0;
 148:	4501                	li	a0,0
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  return 0;
 150:	4501                	li	a0,0
 152:	bfe5                	j	14a <strchr+0x1a>

0000000000000154 <gets>:

char*
gets(char *buf, int max)
{
 154:	711d                	addi	sp,sp,-96
 156:	ec86                	sd	ra,88(sp)
 158:	e8a2                	sd	s0,80(sp)
 15a:	e4a6                	sd	s1,72(sp)
 15c:	e0ca                	sd	s2,64(sp)
 15e:	fc4e                	sd	s3,56(sp)
 160:	f852                	sd	s4,48(sp)
 162:	f456                	sd	s5,40(sp)
 164:	f05a                	sd	s6,32(sp)
 166:	ec5e                	sd	s7,24(sp)
 168:	1080                	addi	s0,sp,96
 16a:	8baa                	mv	s7,a0
 16c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16e:	892a                	mv	s2,a0
 170:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 172:	4aa9                	li	s5,10
 174:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 176:	89a6                	mv	s3,s1
 178:	2485                	addiw	s1,s1,1
 17a:	0344d663          	bge	s1,s4,1a6 <gets+0x52>
    cc = read(0, &c, 1);
 17e:	4605                	li	a2,1
 180:	faf40593          	addi	a1,s0,-81
 184:	4501                	li	a0,0
 186:	1b2000ef          	jal	338 <read>
    if(cc < 1)
 18a:	00a05e63          	blez	a0,1a6 <gets+0x52>
    buf[i++] = c;
 18e:	faf44783          	lbu	a5,-81(s0)
 192:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 196:	01578763          	beq	a5,s5,1a4 <gets+0x50>
 19a:	0905                	addi	s2,s2,1
 19c:	fd679de3          	bne	a5,s6,176 <gets+0x22>
    buf[i++] = c;
 1a0:	89a6                	mv	s3,s1
 1a2:	a011                	j	1a6 <gets+0x52>
 1a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a6:	99de                	add	s3,s3,s7
 1a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ac:	855e                	mv	a0,s7
 1ae:	60e6                	ld	ra,88(sp)
 1b0:	6446                	ld	s0,80(sp)
 1b2:	64a6                	ld	s1,72(sp)
 1b4:	6906                	ld	s2,64(sp)
 1b6:	79e2                	ld	s3,56(sp)
 1b8:	7a42                	ld	s4,48(sp)
 1ba:	7aa2                	ld	s5,40(sp)
 1bc:	7b02                	ld	s6,32(sp)
 1be:	6be2                	ld	s7,24(sp)
 1c0:	6125                	addi	sp,sp,96
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	18e000ef          	jal	360 <open>
  if(fd < 0)
 1d6:	02054263          	bltz	a0,1fa <stat+0x36>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	198000ef          	jal	378 <fstat>
 1e4:	892a                	mv	s2,a0
  close(fd);
 1e6:	8526                	mv	a0,s1
 1e8:	160000ef          	jal	348 <close>
  return r;
 1ec:	64a2                	ld	s1,8(sp)
}
 1ee:	854a                	mv	a0,s2
 1f0:	60e2                	ld	ra,24(sp)
 1f2:	6442                	ld	s0,16(sp)
 1f4:	6902                	ld	s2,0(sp)
 1f6:	6105                	addi	sp,sp,32
 1f8:	8082                	ret
    return -1;
 1fa:	597d                	li	s2,-1
 1fc:	bfcd                	j	1ee <stat+0x2a>

00000000000001fe <atoi>:

int
atoi(const char *s)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 204:	00054683          	lbu	a3,0(a0)
 208:	fd06879b          	addiw	a5,a3,-48
 20c:	0ff7f793          	zext.b	a5,a5
 210:	4625                	li	a2,9
 212:	02f66863          	bltu	a2,a5,242 <atoi+0x44>
 216:	872a                	mv	a4,a0
  n = 0;
 218:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21a:	0705                	addi	a4,a4,1
 21c:	0025179b          	slliw	a5,a0,0x2
 220:	9fa9                	addw	a5,a5,a0
 222:	0017979b          	slliw	a5,a5,0x1
 226:	9fb5                	addw	a5,a5,a3
 228:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22c:	00074683          	lbu	a3,0(a4)
 230:	fd06879b          	addiw	a5,a3,-48
 234:	0ff7f793          	zext.b	a5,a5
 238:	fef671e3          	bgeu	a2,a5,21a <atoi+0x1c>
  return n;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
  n = 0;
 242:	4501                	li	a0,0
 244:	bfe5                	j	23c <atoi+0x3e>

0000000000000246 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24c:	02b57463          	bgeu	a0,a1,274 <memmove+0x2e>
    while(n-- > 0)
 250:	00c05f63          	blez	a2,26e <memmove+0x28>
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25c:	872a                	mv	a4,a0
      *dst++ = *src++;
 25e:	0585                	addi	a1,a1,1
 260:	0705                	addi	a4,a4,1
 262:	fff5c683          	lbu	a3,-1(a1)
 266:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26a:	fef71ae3          	bne	a4,a5,25e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
    dst += n;
 274:	00c50733          	add	a4,a0,a2
    src += n;
 278:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27a:	fec05ae3          	blez	a2,26e <memmove+0x28>
 27e:	fff6079b          	addiw	a5,a2,-1
 282:	1782                	slli	a5,a5,0x20
 284:	9381                	srli	a5,a5,0x20
 286:	fff7c793          	not	a5,a5
 28a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28c:	15fd                	addi	a1,a1,-1
 28e:	177d                	addi	a4,a4,-1
 290:	0005c683          	lbu	a3,0(a1)
 294:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 298:	fee79ae3          	bne	a5,a4,28c <memmove+0x46>
 29c:	bfc9                	j	26e <memmove+0x28>

000000000000029e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a4:	ca05                	beqz	a2,2d4 <memcmp+0x36>
 2a6:	fff6069b          	addiw	a3,a2,-1
 2aa:	1682                	slli	a3,a3,0x20
 2ac:	9281                	srli	a3,a3,0x20
 2ae:	0685                	addi	a3,a3,1
 2b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	0005c703          	lbu	a4,0(a1)
 2ba:	00e79863          	bne	a5,a4,2ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2be:	0505                	addi	a0,a0,1
    p2++;
 2c0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c2:	fed518e3          	bne	a0,a3,2b2 <memcmp+0x14>
  }
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	a019                	j	2ce <memcmp+0x30>
      return *p1 - *p2;
 2ca:	40e7853b          	subw	a0,a5,a4
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <memcmp+0x30>

00000000000002d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e0:	f67ff0ef          	jal	246 <memmove>
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <sbrk>:

char *
sbrk(int n) {
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f4:	4585                	li	a1,1
 2f6:	0b2000ef          	jal	3a8 <sys_sbrk>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <sbrklazy>:

char *
sbrklazy(int n) {
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 30a:	4589                	li	a1,2
 30c:	09c000ef          	jal	3a8 <sys_sbrk>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 318:	4885                	li	a7,1
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exit>:
.global exit
exit:
 li a7, SYS_exit
 320:	4889                	li	a7,2
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <wait>:
.global wait
wait:
 li a7, SYS_wait
 328:	488d                	li	a7,3
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 330:	4891                	li	a7,4
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <read>:
.global read
read:
 li a7, SYS_read
 338:	4895                	li	a7,5
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <write>:
.global write
write:
 li a7, SYS_write
 340:	48c1                	li	a7,16
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <close>:
.global close
close:
 li a7, SYS_close
 348:	48d5                	li	a7,21
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <kill>:
.global kill
kill:
 li a7, SYS_kill
 350:	4899                	li	a7,6
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <exec>:
.global exec
exec:
 li a7, SYS_exec
 358:	489d                	li	a7,7
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <open>:
.global open
open:
 li a7, SYS_open
 360:	48bd                	li	a7,15
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 368:	48c5                	li	a7,17
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 370:	48c9                	li	a7,18
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 378:	48a1                	li	a7,8
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <link>:
.global link
link:
 li a7, SYS_link
 380:	48cd                	li	a7,19
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 388:	48d1                	li	a7,20
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 390:	48a5                	li	a7,9
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <dup>:
.global dup
dup:
 li a7, SYS_dup
 398:	48a9                	li	a7,10
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a0:	48ad                	li	a7,11
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a8:	48b1                	li	a7,12
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3b0:	48b5                	li	a7,13
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b8:	48b9                	li	a7,14
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <hello>:
.global hello
hello:
 li a7, SYS_hello
 3c0:	48d9                	li	a7,22
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3c8:	48dd                	li	a7,23
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <memtest>:
.global memtest
memtest:
 li a7, SYS_memtest
 3d0:	48e1                	li	a7,24
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <testnolock>:
.global testnolock
testnolock:
 li a7, SYS_testnolock
 3d8:	48e5                	li	a7,25
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <testlock>:
.global testlock
testlock:
 li a7, SYS_testlock
 3e0:	48e9                	li	a7,26
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <nullcall>:
.global nullcall
nullcall:
 li a7, SYS_nullcall
 3e8:	48ed                	li	a7,27
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <getcycles>:
.global getcycles
getcycles:
 li a7, SYS_getcycles
 3f0:	48f1                	li	a7,28
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f8:	1101                	addi	sp,sp,-32
 3fa:	ec06                	sd	ra,24(sp)
 3fc:	e822                	sd	s0,16(sp)
 3fe:	1000                	addi	s0,sp,32
 400:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 404:	4605                	li	a2,1
 406:	fef40593          	addi	a1,s0,-17
 40a:	f37ff0ef          	jal	340 <write>
}
 40e:	60e2                	ld	ra,24(sp)
 410:	6442                	ld	s0,16(sp)
 412:	6105                	addi	sp,sp,32
 414:	8082                	ret

0000000000000416 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 416:	715d                	addi	sp,sp,-80
 418:	e486                	sd	ra,72(sp)
 41a:	e0a2                	sd	s0,64(sp)
 41c:	f84a                	sd	s2,48(sp)
 41e:	0880                	addi	s0,sp,80
 420:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 422:	c299                	beqz	a3,428 <printint+0x12>
 424:	0805c363          	bltz	a1,4aa <printint+0x94>
  neg = 0;
 428:	4881                	li	a7,0
 42a:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 42e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 430:	00000517          	auipc	a0,0x0
 434:	57850513          	addi	a0,a0,1400 # 9a8 <digits>
 438:	883e                	mv	a6,a5
 43a:	2785                	addiw	a5,a5,1
 43c:	02c5f733          	remu	a4,a1,a2
 440:	972a                	add	a4,a4,a0
 442:	00074703          	lbu	a4,0(a4)
 446:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 44a:	872e                	mv	a4,a1
 44c:	02c5d5b3          	divu	a1,a1,a2
 450:	0685                	addi	a3,a3,1
 452:	fec773e3          	bgeu	a4,a2,438 <printint+0x22>
  if(neg)
 456:	00088b63          	beqz	a7,46c <printint+0x56>
    buf[i++] = '-';
 45a:	fd078793          	addi	a5,a5,-48
 45e:	97a2                	add	a5,a5,s0
 460:	02d00713          	li	a4,45
 464:	fee78423          	sb	a4,-24(a5)
 468:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 46c:	02f05a63          	blez	a5,4a0 <printint+0x8a>
 470:	fc26                	sd	s1,56(sp)
 472:	f44e                	sd	s3,40(sp)
 474:	fb840713          	addi	a4,s0,-72
 478:	00f704b3          	add	s1,a4,a5
 47c:	fff70993          	addi	s3,a4,-1
 480:	99be                	add	s3,s3,a5
 482:	37fd                	addiw	a5,a5,-1
 484:	1782                	slli	a5,a5,0x20
 486:	9381                	srli	a5,a5,0x20
 488:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 48c:	fff4c583          	lbu	a1,-1(s1)
 490:	854a                	mv	a0,s2
 492:	f67ff0ef          	jal	3f8 <putc>
  while(--i >= 0)
 496:	14fd                	addi	s1,s1,-1
 498:	ff349ae3          	bne	s1,s3,48c <printint+0x76>
 49c:	74e2                	ld	s1,56(sp)
 49e:	79a2                	ld	s3,40(sp)
}
 4a0:	60a6                	ld	ra,72(sp)
 4a2:	6406                	ld	s0,64(sp)
 4a4:	7942                	ld	s2,48(sp)
 4a6:	6161                	addi	sp,sp,80
 4a8:	8082                	ret
    x = -xx;
 4aa:	40b005b3          	neg	a1,a1
    neg = 1;
 4ae:	4885                	li	a7,1
    x = -xx;
 4b0:	bfad                	j	42a <printint+0x14>

00000000000004b2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b2:	711d                	addi	sp,sp,-96
 4b4:	ec86                	sd	ra,88(sp)
 4b6:	e8a2                	sd	s0,80(sp)
 4b8:	e0ca                	sd	s2,64(sp)
 4ba:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4bc:	0005c903          	lbu	s2,0(a1)
 4c0:	28090663          	beqz	s2,74c <vprintf+0x29a>
 4c4:	e4a6                	sd	s1,72(sp)
 4c6:	fc4e                	sd	s3,56(sp)
 4c8:	f852                	sd	s4,48(sp)
 4ca:	f456                	sd	s5,40(sp)
 4cc:	f05a                	sd	s6,32(sp)
 4ce:	ec5e                	sd	s7,24(sp)
 4d0:	e862                	sd	s8,16(sp)
 4d2:	e466                	sd	s9,8(sp)
 4d4:	8b2a                	mv	s6,a0
 4d6:	8a2e                	mv	s4,a1
 4d8:	8bb2                	mv	s7,a2
  state = 0;
 4da:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4dc:	4481                	li	s1,0
 4de:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4e0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e8:	06c00c93          	li	s9,108
 4ec:	a005                	j	50c <vprintf+0x5a>
        putc(fd, c0);
 4ee:	85ca                	mv	a1,s2
 4f0:	855a                	mv	a0,s6
 4f2:	f07ff0ef          	jal	3f8 <putc>
 4f6:	a019                	j	4fc <vprintf+0x4a>
    } else if(state == '%'){
 4f8:	03598263          	beq	s3,s5,51c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4fc:	2485                	addiw	s1,s1,1
 4fe:	8726                	mv	a4,s1
 500:	009a07b3          	add	a5,s4,s1
 504:	0007c903          	lbu	s2,0(a5)
 508:	22090a63          	beqz	s2,73c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 50c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 510:	fe0994e3          	bnez	s3,4f8 <vprintf+0x46>
      if(c0 == '%'){
 514:	fd579de3          	bne	a5,s5,4ee <vprintf+0x3c>
        state = '%';
 518:	89be                	mv	s3,a5
 51a:	b7cd                	j	4fc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 51c:	00ea06b3          	add	a3,s4,a4
 520:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 524:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 526:	c681                	beqz	a3,52e <vprintf+0x7c>
 528:	9752                	add	a4,a4,s4
 52a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 52e:	05878363          	beq	a5,s8,574 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 532:	05978d63          	beq	a5,s9,58c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 536:	07500713          	li	a4,117
 53a:	0ee78763          	beq	a5,a4,628 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 53e:	07800713          	li	a4,120
 542:	12e78963          	beq	a5,a4,674 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 546:	07000713          	li	a4,112
 54a:	14e78e63          	beq	a5,a4,6a6 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 54e:	06300713          	li	a4,99
 552:	18e78e63          	beq	a5,a4,6ee <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 556:	07300713          	li	a4,115
 55a:	1ae78463          	beq	a5,a4,702 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 55e:	02500713          	li	a4,37
 562:	04e79563          	bne	a5,a4,5ac <vprintf+0xfa>
        putc(fd, '%');
 566:	02500593          	li	a1,37
 56a:	855a                	mv	a0,s6
 56c:	e8dff0ef          	jal	3f8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 570:	4981                	li	s3,0
 572:	b769                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 574:	008b8913          	addi	s2,s7,8
 578:	4685                	li	a3,1
 57a:	4629                	li	a2,10
 57c:	000ba583          	lw	a1,0(s7)
 580:	855a                	mv	a0,s6
 582:	e95ff0ef          	jal	416 <printint>
 586:	8bca                	mv	s7,s2
      state = 0;
 588:	4981                	li	s3,0
 58a:	bf8d                	j	4fc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 58c:	06400793          	li	a5,100
 590:	02f68963          	beq	a3,a5,5c2 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 594:	06c00793          	li	a5,108
 598:	04f68263          	beq	a3,a5,5dc <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 59c:	07500793          	li	a5,117
 5a0:	0af68063          	beq	a3,a5,640 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5a4:	07800793          	li	a5,120
 5a8:	0ef68263          	beq	a3,a5,68c <vprintf+0x1da>
        putc(fd, '%');
 5ac:	02500593          	li	a1,37
 5b0:	855a                	mv	a0,s6
 5b2:	e47ff0ef          	jal	3f8 <putc>
        putc(fd, c0);
 5b6:	85ca                	mv	a1,s2
 5b8:	855a                	mv	a0,s6
 5ba:	e3fff0ef          	jal	3f8 <putc>
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bf35                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4685                	li	a3,1
 5c8:	4629                	li	a2,10
 5ca:	000bb583          	ld	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e47ff0ef          	jal	416 <printint>
        i += 1;
 5d4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
        i += 1;
 5da:	b70d                	j	4fc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5dc:	06400793          	li	a5,100
 5e0:	02f60763          	beq	a2,a5,60e <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5e4:	07500793          	li	a5,117
 5e8:	06f60963          	beq	a2,a5,65a <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ec:	07800793          	li	a5,120
 5f0:	faf61ee3          	bne	a2,a5,5ac <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	008b8913          	addi	s2,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4641                	li	a2,16
 5fc:	000bb583          	ld	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	e15ff0ef          	jal	416 <printint>
        i += 2;
 606:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
        i += 2;
 60c:	bdc5                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60e:	008b8913          	addi	s2,s7,8
 612:	4685                	li	a3,1
 614:	4629                	li	a2,10
 616:	000bb583          	ld	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	dfbff0ef          	jal	416 <printint>
        i += 2;
 620:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
        i += 2;
 626:	bdd9                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4629                	li	a2,10
 630:	000be583          	lwu	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	de1ff0ef          	jal	416 <printint>
 63a:	8bca                	mv	s7,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bd7d                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	008b8913          	addi	s2,s7,8
 644:	4681                	li	a3,0
 646:	4629                	li	a2,10
 648:	000bb583          	ld	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	dc9ff0ef          	jal	416 <printint>
        i += 1;
 652:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
        i += 1;
 658:	b555                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	008b8913          	addi	s2,s7,8
 65e:	4681                	li	a3,0
 660:	4629                	li	a2,10
 662:	000bb583          	ld	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	dafff0ef          	jal	416 <printint>
        i += 2;
 66c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	b569                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 674:	008b8913          	addi	s2,s7,8
 678:	4681                	li	a3,0
 67a:	4641                	li	a2,16
 67c:	000be583          	lwu	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	d95ff0ef          	jal	416 <printint>
 686:	8bca                	mv	s7,s2
      state = 0;
 688:	4981                	li	s3,0
 68a:	bd8d                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	008b8913          	addi	s2,s7,8
 690:	4681                	li	a3,0
 692:	4641                	li	a2,16
 694:	000bb583          	ld	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	d7dff0ef          	jal	416 <printint>
        i += 1;
 69e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
        i += 1;
 6a4:	bda1                	j	4fc <vprintf+0x4a>
 6a6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6a8:	008b8d13          	addi	s10,s7,8
 6ac:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b0:	03000593          	li	a1,48
 6b4:	855a                	mv	a0,s6
 6b6:	d43ff0ef          	jal	3f8 <putc>
  putc(fd, 'x');
 6ba:	07800593          	li	a1,120
 6be:	855a                	mv	a0,s6
 6c0:	d39ff0ef          	jal	3f8 <putc>
 6c4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c6:	00000b97          	auipc	s7,0x0
 6ca:	2e2b8b93          	addi	s7,s7,738 # 9a8 <digits>
 6ce:	03c9d793          	srli	a5,s3,0x3c
 6d2:	97de                	add	a5,a5,s7
 6d4:	0007c583          	lbu	a1,0(a5)
 6d8:	855a                	mv	a0,s6
 6da:	d1fff0ef          	jal	3f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6de:	0992                	slli	s3,s3,0x4
 6e0:	397d                	addiw	s2,s2,-1
 6e2:	fe0916e3          	bnez	s2,6ce <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6e6:	8bea                	mv	s7,s10
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	6d02                	ld	s10,0(sp)
 6ec:	bd01                	j	4fc <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6ee:	008b8913          	addi	s2,s7,8
 6f2:	000bc583          	lbu	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	d01ff0ef          	jal	3f8 <putc>
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bbf5                	j	4fc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 702:	008b8993          	addi	s3,s7,8
 706:	000bb903          	ld	s2,0(s7)
 70a:	00090f63          	beqz	s2,728 <vprintf+0x276>
        for(; *s; s++)
 70e:	00094583          	lbu	a1,0(s2)
 712:	c195                	beqz	a1,736 <vprintf+0x284>
          putc(fd, *s);
 714:	855a                	mv	a0,s6
 716:	ce3ff0ef          	jal	3f8 <putc>
        for(; *s; s++)
 71a:	0905                	addi	s2,s2,1
 71c:	00094583          	lbu	a1,0(s2)
 720:	f9f5                	bnez	a1,714 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 722:	8bce                	mv	s7,s3
      state = 0;
 724:	4981                	li	s3,0
 726:	bbd9                	j	4fc <vprintf+0x4a>
          s = "(null)";
 728:	00000917          	auipc	s2,0x0
 72c:	27890913          	addi	s2,s2,632 # 9a0 <malloc+0x16c>
        for(; *s; s++)
 730:	02800593          	li	a1,40
 734:	b7c5                	j	714 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 736:	8bce                	mv	s7,s3
      state = 0;
 738:	4981                	li	s3,0
 73a:	b3c9                	j	4fc <vprintf+0x4a>
 73c:	64a6                	ld	s1,72(sp)
 73e:	79e2                	ld	s3,56(sp)
 740:	7a42                	ld	s4,48(sp)
 742:	7aa2                	ld	s5,40(sp)
 744:	7b02                	ld	s6,32(sp)
 746:	6be2                	ld	s7,24(sp)
 748:	6c42                	ld	s8,16(sp)
 74a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 74c:	60e6                	ld	ra,88(sp)
 74e:	6446                	ld	s0,80(sp)
 750:	6906                	ld	s2,64(sp)
 752:	6125                	addi	sp,sp,96
 754:	8082                	ret

0000000000000756 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 756:	715d                	addi	sp,sp,-80
 758:	ec06                	sd	ra,24(sp)
 75a:	e822                	sd	s0,16(sp)
 75c:	1000                	addi	s0,sp,32
 75e:	e010                	sd	a2,0(s0)
 760:	e414                	sd	a3,8(s0)
 762:	e818                	sd	a4,16(s0)
 764:	ec1c                	sd	a5,24(s0)
 766:	03043023          	sd	a6,32(s0)
 76a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 772:	8622                	mv	a2,s0
 774:	d3fff0ef          	jal	4b2 <vprintf>
}
 778:	60e2                	ld	ra,24(sp)
 77a:	6442                	ld	s0,16(sp)
 77c:	6161                	addi	sp,sp,80
 77e:	8082                	ret

0000000000000780 <printf>:

void
printf(const char *fmt, ...)
{
 780:	711d                	addi	sp,sp,-96
 782:	ec06                	sd	ra,24(sp)
 784:	e822                	sd	s0,16(sp)
 786:	1000                	addi	s0,sp,32
 788:	e40c                	sd	a1,8(s0)
 78a:	e810                	sd	a2,16(s0)
 78c:	ec14                	sd	a3,24(s0)
 78e:	f018                	sd	a4,32(s0)
 790:	f41c                	sd	a5,40(s0)
 792:	03043823          	sd	a6,48(s0)
 796:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 79a:	00840613          	addi	a2,s0,8
 79e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a2:	85aa                	mv	a1,a0
 7a4:	4505                	li	a0,1
 7a6:	d0dff0ef          	jal	4b2 <vprintf>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6125                	addi	sp,sp,96
 7b0:	8082                	ret

00000000000007b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b2:	1141                	addi	sp,sp,-16
 7b4:	e422                	sd	s0,8(sp)
 7b6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	00001797          	auipc	a5,0x1
 7c0:	8447b783          	ld	a5,-1980(a5) # 1000 <freep>
 7c4:	a02d                	j	7ee <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c6:	4618                	lw	a4,8(a2)
 7c8:	9f2d                	addw	a4,a4,a1
 7ca:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	6398                	ld	a4,0(a5)
 7d0:	6310                	ld	a2,0(a4)
 7d2:	a83d                	j	810 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d4:	ff852703          	lw	a4,-8(a0)
 7d8:	9f31                	addw	a4,a4,a2
 7da:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7dc:	ff053683          	ld	a3,-16(a0)
 7e0:	a091                	j	824 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	6398                	ld	a4,0(a5)
 7e4:	00e7e463          	bltu	a5,a4,7ec <free+0x3a>
 7e8:	00e6ea63          	bltu	a3,a4,7fc <free+0x4a>
{
 7ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	fed7fae3          	bgeu	a5,a3,7e2 <free+0x30>
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e6e463          	bltu	a3,a4,7fc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	fee7eae3          	bltu	a5,a4,7ec <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7fc:	ff852583          	lw	a1,-8(a0)
 800:	6390                	ld	a2,0(a5)
 802:	02059813          	slli	a6,a1,0x20
 806:	01c85713          	srli	a4,a6,0x1c
 80a:	9736                	add	a4,a4,a3
 80c:	fae60de3          	beq	a2,a4,7c6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 814:	4790                	lw	a2,8(a5)
 816:	02061593          	slli	a1,a2,0x20
 81a:	01c5d713          	srli	a4,a1,0x1c
 81e:	973e                	add	a4,a4,a5
 820:	fae68ae3          	beq	a3,a4,7d4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 824:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 826:	00000717          	auipc	a4,0x0
 82a:	7cf73d23          	sd	a5,2010(a4) # 1000 <freep>
}
 82e:	6422                	ld	s0,8(sp)
 830:	0141                	addi	sp,sp,16
 832:	8082                	ret

0000000000000834 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 834:	7139                	addi	sp,sp,-64
 836:	fc06                	sd	ra,56(sp)
 838:	f822                	sd	s0,48(sp)
 83a:	f426                	sd	s1,40(sp)
 83c:	ec4e                	sd	s3,24(sp)
 83e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 840:	02051493          	slli	s1,a0,0x20
 844:	9081                	srli	s1,s1,0x20
 846:	04bd                	addi	s1,s1,15
 848:	8091                	srli	s1,s1,0x4
 84a:	0014899b          	addiw	s3,s1,1
 84e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 850:	00000517          	auipc	a0,0x0
 854:	7b053503          	ld	a0,1968(a0) # 1000 <freep>
 858:	c915                	beqz	a0,88c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85c:	4798                	lw	a4,8(a5)
 85e:	08977a63          	bgeu	a4,s1,8f2 <malloc+0xbe>
 862:	f04a                	sd	s2,32(sp)
 864:	e852                	sd	s4,16(sp)
 866:	e456                	sd	s5,8(sp)
 868:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 86a:	8a4e                	mv	s4,s3
 86c:	0009871b          	sext.w	a4,s3
 870:	6685                	lui	a3,0x1
 872:	00d77363          	bgeu	a4,a3,878 <malloc+0x44>
 876:	6a05                	lui	s4,0x1
 878:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 880:	00000917          	auipc	s2,0x0
 884:	78090913          	addi	s2,s2,1920 # 1000 <freep>
  if(p == SBRK_ERROR)
 888:	5afd                	li	s5,-1
 88a:	a081                	j	8ca <malloc+0x96>
 88c:	f04a                	sd	s2,32(sp)
 88e:	e852                	sd	s4,16(sp)
 890:	e456                	sd	s5,8(sp)
 892:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 894:	00000797          	auipc	a5,0x0
 898:	77c78793          	addi	a5,a5,1916 # 1010 <base>
 89c:	00000717          	auipc	a4,0x0
 8a0:	76f73223          	sd	a5,1892(a4) # 1000 <freep>
 8a4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8aa:	b7c1                	j	86a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ac:	6398                	ld	a4,0(a5)
 8ae:	e118                	sd	a4,0(a0)
 8b0:	a8a9                	j	90a <malloc+0xd6>
  hp->s.size = nu;
 8b2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b6:	0541                	addi	a0,a0,16
 8b8:	efbff0ef          	jal	7b2 <free>
  return freep;
 8bc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c0:	c12d                	beqz	a0,922 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c4:	4798                	lw	a4,8(a5)
 8c6:	02977263          	bgeu	a4,s1,8ea <malloc+0xb6>
    if(p == freep)
 8ca:	00093703          	ld	a4,0(s2)
 8ce:	853e                	mv	a0,a5
 8d0:	fef719e3          	bne	a4,a5,8c2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8d4:	8552                	mv	a0,s4
 8d6:	a17ff0ef          	jal	2ec <sbrk>
  if(p == SBRK_ERROR)
 8da:	fd551ce3          	bne	a0,s5,8b2 <malloc+0x7e>
        return 0;
 8de:	4501                	li	a0,0
 8e0:	7902                	ld	s2,32(sp)
 8e2:	6a42                	ld	s4,16(sp)
 8e4:	6aa2                	ld	s5,8(sp)
 8e6:	6b02                	ld	s6,0(sp)
 8e8:	a03d                	j	916 <malloc+0xe2>
 8ea:	7902                	ld	s2,32(sp)
 8ec:	6a42                	ld	s4,16(sp)
 8ee:	6aa2                	ld	s5,8(sp)
 8f0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f2:	fae48de3          	beq	s1,a4,8ac <malloc+0x78>
        p->s.size -= nunits;
 8f6:	4137073b          	subw	a4,a4,s3
 8fa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fc:	02071693          	slli	a3,a4,0x20
 900:	01c6d713          	srli	a4,a3,0x1c
 904:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 906:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 90a:	00000717          	auipc	a4,0x0
 90e:	6ea73b23          	sd	a0,1782(a4) # 1000 <freep>
      return (void*)(p + 1);
 912:	01078513          	addi	a0,a5,16
  }
}
 916:	70e2                	ld	ra,56(sp)
 918:	7442                	ld	s0,48(sp)
 91a:	74a2                	ld	s1,40(sp)
 91c:	69e2                	ld	s3,24(sp)
 91e:	6121                	addi	sp,sp,64
 920:	8082                	ret
 922:	7902                	ld	s2,32(sp)
 924:	6a42                	ld	s4,16(sp)
 926:	6aa2                	ld	s5,8(sp)
 928:	6b02                	ld	s6,0(sp)
 92a:	b7f5                	j	916 <malloc+0xe2>
