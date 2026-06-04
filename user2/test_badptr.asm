
user/_test_badptr:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test_read_badptr>:
#include "kernel/stat.h"
#include "user/user.h"

void
test_read_badptr()
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  printf("1. Testing read() with bad pointer...\n");
   8:	00001517          	auipc	a0,0x1
   c:	9b850513          	addi	a0,a0,-1608 # 9c0 <malloc+0x102>
  10:	7fa000ef          	jal	80a <printf>
  
  // Một địa chỉ rất cao, không được ánh xạ cho User
  char *bad_buf = (char *)0x9000000000000000L; 
  int fd = open("README", 0);
  14:	4581                	li	a1,0
  16:	00001517          	auipc	a0,0x1
  1a:	9d250513          	addi	a0,a0,-1582 # 9e8 <malloc+0x12a>
  1e:	3cc000ef          	jal	3ea <open>
  
  if(fd < 0){
  22:	02054b63          	bltz	a0,58 <test_read_badptr+0x58>
  26:	e426                	sd	s1,8(sp)
  28:	84aa                	mv	s1,a0
    printf("Test failed: Could not open README\n");
    return;
  }

  int n = read(fd, bad_buf, 10);
  2a:	4629                	li	a2,10
  2c:	55e5                	li	a1,-7
  2e:	15f2                	slli	a1,a1,0x3c
  30:	392000ef          	jal	3c2 <read>
  34:	85aa                	mv	a1,a0
  
  if(n == -1){
  36:	57fd                	li	a5,-1
  38:	02f50763          	beq	a0,a5,66 <test_read_badptr+0x66>
    printf("Result: SUCCESS (Kernel safely returned -1)\n");
  } else {
    printf("Result: FAILED (Kernel returned %d instead of -1)\n", n);
  3c:	00001517          	auipc	a0,0x1
  40:	a0c50513          	addi	a0,a0,-1524 # a48 <malloc+0x18a>
  44:	7c6000ef          	jal	80a <printf>
  }
  close(fd);
  48:	8526                	mv	a0,s1
  4a:	388000ef          	jal	3d2 <close>
  4e:	64a2                	ld	s1,8(sp)
}
  50:	60e2                	ld	ra,24(sp)
  52:	6442                	ld	s0,16(sp)
  54:	6105                	addi	sp,sp,32
  56:	8082                	ret
    printf("Test failed: Could not open README\n");
  58:	00001517          	auipc	a0,0x1
  5c:	99850513          	addi	a0,a0,-1640 # 9f0 <malloc+0x132>
  60:	7aa000ef          	jal	80a <printf>
    return;
  64:	b7f5                	j	50 <test_read_badptr+0x50>
    printf("Result: SUCCESS (Kernel safely returned -1)\n");
  66:	00001517          	auipc	a0,0x1
  6a:	9b250513          	addi	a0,a0,-1614 # a18 <malloc+0x15a>
  6e:	79c000ef          	jal	80a <printf>
  72:	bfd9                	j	48 <test_read_badptr+0x48>

0000000000000074 <test_write_badptr>:

void
test_write_badptr()
{
  74:	1101                	addi	sp,sp,-32
  76:	ec06                	sd	ra,24(sp)
  78:	e822                	sd	s0,16(sp)
  7a:	1000                	addi	s0,sp,32
  printf("\n2. Testing write() with kernel pointer...\n");
  7c:	00001517          	auipc	a0,0x1
  80:	a0450513          	addi	a0,a0,-1532 # a80 <malloc+0x1c2>
  84:	786000ef          	jal	80a <printf>
  
  // Địa chỉ vùng nhớ Kernel
  char *kernel_buf = (char *)0x80000000; 
  int fd = open("test_out", 0x200 | 0x002); // O_CREATE | O_RDWR
  88:	20200593          	li	a1,514
  8c:	00001517          	auipc	a0,0x1
  90:	a2450513          	addi	a0,a0,-1500 # ab0 <malloc+0x1f2>
  94:	356000ef          	jal	3ea <open>
  
  if(fd < 0){
  98:	02054a63          	bltz	a0,cc <test_write_badptr+0x58>
  9c:	e426                	sd	s1,8(sp)
  9e:	84aa                	mv	s1,a0
    printf("Test failed: Could not create file\n");
    return;
  }

  int n = write(fd, kernel_buf, 10);
  a0:	4629                	li	a2,10
  a2:	4585                	li	a1,1
  a4:	05fe                	slli	a1,a1,0x1f
  a6:	324000ef          	jal	3ca <write>
  
  if(n == -1){
  aa:	57fd                	li	a5,-1
  ac:	02f50763          	beq	a0,a5,da <test_write_badptr+0x66>
    printf("Result: SUCCESS (Kernel safely returned -1)\n");
  } else {
    printf("Result: FAILED (Kernel allowed writing from kernel memory!)\n");
  b0:	00001517          	auipc	a0,0x1
  b4:	a3850513          	addi	a0,a0,-1480 # ae8 <malloc+0x22a>
  b8:	752000ef          	jal	80a <printf>
  }
  close(fd);
  bc:	8526                	mv	a0,s1
  be:	314000ef          	jal	3d2 <close>
  c2:	64a2                	ld	s1,8(sp)
}
  c4:	60e2                	ld	ra,24(sp)
  c6:	6442                	ld	s0,16(sp)
  c8:	6105                	addi	sp,sp,32
  ca:	8082                	ret
    printf("Test failed: Could not create file\n");
  cc:	00001517          	auipc	a0,0x1
  d0:	9f450513          	addi	a0,a0,-1548 # ac0 <malloc+0x202>
  d4:	736000ef          	jal	80a <printf>
    return;
  d8:	b7f5                	j	c4 <test_write_badptr+0x50>
    printf("Result: SUCCESS (Kernel safely returned -1)\n");
  da:	00001517          	auipc	a0,0x1
  de:	93e50513          	addi	a0,a0,-1730 # a18 <malloc+0x15a>
  e2:	728000ef          	jal	80a <printf>
  e6:	bfd9                	j	bc <test_write_badptr+0x48>

00000000000000e8 <main>:

int
main(void)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  printf("--- STARTING UNIT TEST: MEMORY PROTECTION ---\n");
  f0:	00001517          	auipc	a0,0x1
  f4:	a3850513          	addi	a0,a0,-1480 # b28 <malloc+0x26a>
  f8:	712000ef          	jal	80a <printf>
  test_read_badptr();
  fc:	f05ff0ef          	jal	0 <test_read_badptr>
  test_write_badptr();
 100:	f75ff0ef          	jal	74 <test_write_badptr>
  printf("--- UNIT TEST FINISHED ---\n");
 104:	00001517          	auipc	a0,0x1
 108:	a5450513          	addi	a0,a0,-1452 # b58 <malloc+0x29a>
 10c:	6fe000ef          	jal	80a <printf>
  exit(0);
 110:	4501                	li	a0,0
 112:	298000ef          	jal	3aa <exit>

0000000000000116 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 116:	1141                	addi	sp,sp,-16
 118:	e406                	sd	ra,8(sp)
 11a:	e022                	sd	s0,0(sp)
 11c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 11e:	fcbff0ef          	jal	e8 <main>
  exit(r);
 122:	288000ef          	jal	3aa <exit>

0000000000000126 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	addi	a1,a1,1
 130:	0785                	addi	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
    ;
  return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb91                	beqz	a5,160 <strcmp+0x1e>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71763          	bne	a4,a5,160 <strcmp+0x1e>
    p++, q++;
 156:	0505                	addi	a0,a0,1
 158:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	fbe5                	bnez	a5,14e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 160:	0005c503          	lbu	a0,0(a1)
}
 164:	40a7853b          	subw	a0,a5,a0
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint
strlen(const char *s)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x26>
 17a:	0505                	addi	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	86be                	mv	a3,a5
 180:	0785                	addi	a5,a5,1
 182:	fff7c703          	lbu	a4,-1(a5)
 186:	ff65                	bnez	a4,17e <strlen+0x10>
 188:	40a6853b          	subw	a0,a3,a0
 18c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  for(n = 0; s[n]; n++)
 194:	4501                	li	a0,0
 196:	bfe5                	j	18e <strlen+0x20>

0000000000000198 <memset>:

void*
memset(void *dst, int c, uint n)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19e:	ca19                	beqz	a2,1b4 <memset+0x1c>
 1a0:	87aa                	mv	a5,a0
 1a2:	1602                	slli	a2,a2,0x20
 1a4:	9201                	srli	a2,a2,0x20
 1a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ae:	0785                	addi	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x12>
  }
  return dst;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strchr>:

char*
strchr(const char *s, char c)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb99                	beqz	a5,1da <strchr+0x20>
    if(*s == c)
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1a>
  for(; *s; s++)
 1ca:	0505                	addi	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xc>
      return (char*)s;
  return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strchr+0x1a>

00000000000001de <gets>:

char*
gets(char *buf, int max)
{
 1de:	711d                	addi	sp,sp,-96
 1e0:	ec86                	sd	ra,88(sp)
 1e2:	e8a2                	sd	s0,80(sp)
 1e4:	e4a6                	sd	s1,72(sp)
 1e6:	e0ca                	sd	s2,64(sp)
 1e8:	fc4e                	sd	s3,56(sp)
 1ea:	f852                	sd	s4,48(sp)
 1ec:	f456                	sd	s5,40(sp)
 1ee:	f05a                	sd	s6,32(sp)
 1f0:	ec5e                	sd	s7,24(sp)
 1f2:	1080                	addi	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fc:	4aa9                	li	s5,10
 1fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 200:	89a6                	mv	s3,s1
 202:	2485                	addiw	s1,s1,1
 204:	0344d663          	bge	s1,s4,230 <gets+0x52>
    cc = read(0, &c, 1);
 208:	4605                	li	a2,1
 20a:	faf40593          	addi	a1,s0,-81
 20e:	4501                	li	a0,0
 210:	1b2000ef          	jal	3c2 <read>
    if(cc < 1)
 214:	00a05e63          	blez	a0,230 <gets+0x52>
    buf[i++] = c;
 218:	faf44783          	lbu	a5,-81(s0)
 21c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 220:	01578763          	beq	a5,s5,22e <gets+0x50>
 224:	0905                	addi	s2,s2,1
 226:	fd679de3          	bne	a5,s6,200 <gets+0x22>
    buf[i++] = c;
 22a:	89a6                	mv	s3,s1
 22c:	a011                	j	230 <gets+0x52>
 22e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 230:	99de                	add	s3,s3,s7
 232:	00098023          	sb	zero,0(s3)
  return buf;
}
 236:	855e                	mv	a0,s7
 238:	60e6                	ld	ra,88(sp)
 23a:	6446                	ld	s0,80(sp)
 23c:	64a6                	ld	s1,72(sp)
 23e:	6906                	ld	s2,64(sp)
 240:	79e2                	ld	s3,56(sp)
 242:	7a42                	ld	s4,48(sp)
 244:	7aa2                	ld	s5,40(sp)
 246:	7b02                	ld	s6,32(sp)
 248:	6be2                	ld	s7,24(sp)
 24a:	6125                	addi	sp,sp,96
 24c:	8082                	ret

000000000000024e <stat>:

int
stat(const char *n, struct stat *st)
{
 24e:	1101                	addi	sp,sp,-32
 250:	ec06                	sd	ra,24(sp)
 252:	e822                	sd	s0,16(sp)
 254:	e04a                	sd	s2,0(sp)
 256:	1000                	addi	s0,sp,32
 258:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25a:	4581                	li	a1,0
 25c:	18e000ef          	jal	3ea <open>
  if(fd < 0)
 260:	02054263          	bltz	a0,284 <stat+0x36>
 264:	e426                	sd	s1,8(sp)
 266:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 268:	85ca                	mv	a1,s2
 26a:	198000ef          	jal	402 <fstat>
 26e:	892a                	mv	s2,a0
  close(fd);
 270:	8526                	mv	a0,s1
 272:	160000ef          	jal	3d2 <close>
  return r;
 276:	64a2                	ld	s1,8(sp)
}
 278:	854a                	mv	a0,s2
 27a:	60e2                	ld	ra,24(sp)
 27c:	6442                	ld	s0,16(sp)
 27e:	6902                	ld	s2,0(sp)
 280:	6105                	addi	sp,sp,32
 282:	8082                	ret
    return -1;
 284:	597d                	li	s2,-1
 286:	bfcd                	j	278 <stat+0x2a>

0000000000000288 <atoi>:

int
atoi(const char *s)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28e:	00054683          	lbu	a3,0(a0)
 292:	fd06879b          	addiw	a5,a3,-48
 296:	0ff7f793          	zext.b	a5,a5
 29a:	4625                	li	a2,9
 29c:	02f66863          	bltu	a2,a5,2cc <atoi+0x44>
 2a0:	872a                	mv	a4,a0
  n = 0;
 2a2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a4:	0705                	addi	a4,a4,1
 2a6:	0025179b          	slliw	a5,a0,0x2
 2aa:	9fa9                	addw	a5,a5,a0
 2ac:	0017979b          	slliw	a5,a5,0x1
 2b0:	9fb5                	addw	a5,a5,a3
 2b2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b6:	00074683          	lbu	a3,0(a4)
 2ba:	fd06879b          	addiw	a5,a3,-48
 2be:	0ff7f793          	zext.b	a5,a5
 2c2:	fef671e3          	bgeu	a2,a5,2a4 <atoi+0x1c>
  return n;
}
 2c6:	6422                	ld	s0,8(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
  n = 0;
 2cc:	4501                	li	a0,0
 2ce:	bfe5                	j	2c6 <atoi+0x3e>

00000000000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d6:	02b57463          	bgeu	a0,a1,2fe <memmove+0x2e>
    while(n-- > 0)
 2da:	00c05f63          	blez	a2,2f8 <memmove+0x28>
 2de:	1602                	slli	a2,a2,0x20
 2e0:	9201                	srli	a2,a2,0x20
 2e2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e8:	0585                	addi	a1,a1,1
 2ea:	0705                	addi	a4,a4,1
 2ec:	fff5c683          	lbu	a3,-1(a1)
 2f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f4:	fef71ae3          	bne	a4,a5,2e8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
    dst += n;
 2fe:	00c50733          	add	a4,a0,a2
    src += n;
 302:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 304:	fec05ae3          	blez	a2,2f8 <memmove+0x28>
 308:	fff6079b          	addiw	a5,a2,-1
 30c:	1782                	slli	a5,a5,0x20
 30e:	9381                	srli	a5,a5,0x20
 310:	fff7c793          	not	a5,a5
 314:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 316:	15fd                	addi	a1,a1,-1
 318:	177d                	addi	a4,a4,-1
 31a:	0005c683          	lbu	a3,0(a1)
 31e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 322:	fee79ae3          	bne	a5,a4,316 <memmove+0x46>
 326:	bfc9                	j	2f8 <memmove+0x28>

0000000000000328 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e422                	sd	s0,8(sp)
 32c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 32e:	ca05                	beqz	a2,35e <memcmp+0x36>
 330:	fff6069b          	addiw	a3,a2,-1
 334:	1682                	slli	a3,a3,0x20
 336:	9281                	srli	a3,a3,0x20
 338:	0685                	addi	a3,a3,1
 33a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 33c:	00054783          	lbu	a5,0(a0)
 340:	0005c703          	lbu	a4,0(a1)
 344:	00e79863          	bne	a5,a4,354 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 348:	0505                	addi	a0,a0,1
    p2++;
 34a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34c:	fed518e3          	bne	a0,a3,33c <memcmp+0x14>
  }
  return 0;
 350:	4501                	li	a0,0
 352:	a019                	j	358 <memcmp+0x30>
      return *p1 - *p2;
 354:	40e7853b          	subw	a0,a5,a4
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
  return 0;
 35e:	4501                	li	a0,0
 360:	bfe5                	j	358 <memcmp+0x30>

0000000000000362 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 362:	1141                	addi	sp,sp,-16
 364:	e406                	sd	ra,8(sp)
 366:	e022                	sd	s0,0(sp)
 368:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36a:	f67ff0ef          	jal	2d0 <memmove>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <sbrk>:

char *
sbrk(int n) {
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 37e:	4585                	li	a1,1
 380:	0b2000ef          	jal	432 <sys_sbrk>
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret

000000000000038c <sbrklazy>:

char *
sbrklazy(int n) {
 38c:	1141                	addi	sp,sp,-16
 38e:	e406                	sd	ra,8(sp)
 390:	e022                	sd	s0,0(sp)
 392:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 394:	4589                	li	a1,2
 396:	09c000ef          	jal	432 <sys_sbrk>
}
 39a:	60a2                	ld	ra,8(sp)
 39c:	6402                	ld	s0,0(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a2:	4885                	li	a7,1
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3aa:	4889                	li	a7,2
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b2:	488d                	li	a7,3
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ba:	4891                	li	a7,4
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <read>:
.global read
read:
 li a7, SYS_read
 3c2:	4895                	li	a7,5
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <write>:
.global write
write:
 li a7, SYS_write
 3ca:	48c1                	li	a7,16
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <close>:
.global close
close:
 li a7, SYS_close
 3d2:	48d5                	li	a7,21
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <kill>:
.global kill
kill:
 li a7, SYS_kill
 3da:	4899                	li	a7,6
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e2:	489d                	li	a7,7
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <open>:
.global open
open:
 li a7, SYS_open
 3ea:	48bd                	li	a7,15
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f2:	48c5                	li	a7,17
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fa:	48c9                	li	a7,18
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 402:	48a1                	li	a7,8
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <link>:
.global link
link:
 li a7, SYS_link
 40a:	48cd                	li	a7,19
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 412:	48d1                	li	a7,20
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41a:	48a5                	li	a7,9
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <dup>:
.global dup
dup:
 li a7, SYS_dup
 422:	48a9                	li	a7,10
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42a:	48ad                	li	a7,11
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 432:	48b1                	li	a7,12
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <pause>:
.global pause
pause:
 li a7, SYS_pause
 43a:	48b5                	li	a7,13
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 442:	48b9                	li	a7,14
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <hello>:
.global hello
hello:
 li a7, SYS_hello
 44a:	48d9                	li	a7,22
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <ps>:
.global ps
ps:
 li a7, SYS_ps
 452:	48dd                	li	a7,23
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <memtest>:
.global memtest
memtest:
 li a7, SYS_memtest
 45a:	48e1                	li	a7,24
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <testnolock>:
.global testnolock
testnolock:
 li a7, SYS_testnolock
 462:	48e5                	li	a7,25
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <testlock>:
.global testlock
testlock:
 li a7, SYS_testlock
 46a:	48e9                	li	a7,26
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <nullcall>:
.global nullcall
nullcall:
 li a7, SYS_nullcall
 472:	48ed                	li	a7,27
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <getcycles>:
.global getcycles
getcycles:
 li a7, SYS_getcycles
 47a:	48f1                	li	a7,28
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 482:	1101                	addi	sp,sp,-32
 484:	ec06                	sd	ra,24(sp)
 486:	e822                	sd	s0,16(sp)
 488:	1000                	addi	s0,sp,32
 48a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 48e:	4605                	li	a2,1
 490:	fef40593          	addi	a1,s0,-17
 494:	f37ff0ef          	jal	3ca <write>
}
 498:	60e2                	ld	ra,24(sp)
 49a:	6442                	ld	s0,16(sp)
 49c:	6105                	addi	sp,sp,32
 49e:	8082                	ret

00000000000004a0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4a0:	715d                	addi	sp,sp,-80
 4a2:	e486                	sd	ra,72(sp)
 4a4:	e0a2                	sd	s0,64(sp)
 4a6:	f84a                	sd	s2,48(sp)
 4a8:	0880                	addi	s0,sp,80
 4aa:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4ac:	c299                	beqz	a3,4b2 <printint+0x12>
 4ae:	0805c363          	bltz	a1,534 <printint+0x94>
  neg = 0;
 4b2:	4881                	li	a7,0
 4b4:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4b8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4ba:	00000517          	auipc	a0,0x0
 4be:	6c650513          	addi	a0,a0,1734 # b80 <digits>
 4c2:	883e                	mv	a6,a5
 4c4:	2785                	addiw	a5,a5,1
 4c6:	02c5f733          	remu	a4,a1,a2
 4ca:	972a                	add	a4,a4,a0
 4cc:	00074703          	lbu	a4,0(a4)
 4d0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4d4:	872e                	mv	a4,a1
 4d6:	02c5d5b3          	divu	a1,a1,a2
 4da:	0685                	addi	a3,a3,1
 4dc:	fec773e3          	bgeu	a4,a2,4c2 <printint+0x22>
  if(neg)
 4e0:	00088b63          	beqz	a7,4f6 <printint+0x56>
    buf[i++] = '-';
 4e4:	fd078793          	addi	a5,a5,-48
 4e8:	97a2                	add	a5,a5,s0
 4ea:	02d00713          	li	a4,45
 4ee:	fee78423          	sb	a4,-24(a5)
 4f2:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 4f6:	02f05a63          	blez	a5,52a <printint+0x8a>
 4fa:	fc26                	sd	s1,56(sp)
 4fc:	f44e                	sd	s3,40(sp)
 4fe:	fb840713          	addi	a4,s0,-72
 502:	00f704b3          	add	s1,a4,a5
 506:	fff70993          	addi	s3,a4,-1
 50a:	99be                	add	s3,s3,a5
 50c:	37fd                	addiw	a5,a5,-1
 50e:	1782                	slli	a5,a5,0x20
 510:	9381                	srli	a5,a5,0x20
 512:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 516:	fff4c583          	lbu	a1,-1(s1)
 51a:	854a                	mv	a0,s2
 51c:	f67ff0ef          	jal	482 <putc>
  while(--i >= 0)
 520:	14fd                	addi	s1,s1,-1
 522:	ff349ae3          	bne	s1,s3,516 <printint+0x76>
 526:	74e2                	ld	s1,56(sp)
 528:	79a2                	ld	s3,40(sp)
}
 52a:	60a6                	ld	ra,72(sp)
 52c:	6406                	ld	s0,64(sp)
 52e:	7942                	ld	s2,48(sp)
 530:	6161                	addi	sp,sp,80
 532:	8082                	ret
    x = -xx;
 534:	40b005b3          	neg	a1,a1
    neg = 1;
 538:	4885                	li	a7,1
    x = -xx;
 53a:	bfad                	j	4b4 <printint+0x14>

000000000000053c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53c:	711d                	addi	sp,sp,-96
 53e:	ec86                	sd	ra,88(sp)
 540:	e8a2                	sd	s0,80(sp)
 542:	e0ca                	sd	s2,64(sp)
 544:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 546:	0005c903          	lbu	s2,0(a1)
 54a:	28090663          	beqz	s2,7d6 <vprintf+0x29a>
 54e:	e4a6                	sd	s1,72(sp)
 550:	fc4e                	sd	s3,56(sp)
 552:	f852                	sd	s4,48(sp)
 554:	f456                	sd	s5,40(sp)
 556:	f05a                	sd	s6,32(sp)
 558:	ec5e                	sd	s7,24(sp)
 55a:	e862                	sd	s8,16(sp)
 55c:	e466                	sd	s9,8(sp)
 55e:	8b2a                	mv	s6,a0
 560:	8a2e                	mv	s4,a1
 562:	8bb2                	mv	s7,a2
  state = 0;
 564:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 566:	4481                	li	s1,0
 568:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 56a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 56e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 572:	06c00c93          	li	s9,108
 576:	a005                	j	596 <vprintf+0x5a>
        putc(fd, c0);
 578:	85ca                	mv	a1,s2
 57a:	855a                	mv	a0,s6
 57c:	f07ff0ef          	jal	482 <putc>
 580:	a019                	j	586 <vprintf+0x4a>
    } else if(state == '%'){
 582:	03598263          	beq	s3,s5,5a6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 586:	2485                	addiw	s1,s1,1
 588:	8726                	mv	a4,s1
 58a:	009a07b3          	add	a5,s4,s1
 58e:	0007c903          	lbu	s2,0(a5)
 592:	22090a63          	beqz	s2,7c6 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 596:	0009079b          	sext.w	a5,s2
    if(state == 0){
 59a:	fe0994e3          	bnez	s3,582 <vprintf+0x46>
      if(c0 == '%'){
 59e:	fd579de3          	bne	a5,s5,578 <vprintf+0x3c>
        state = '%';
 5a2:	89be                	mv	s3,a5
 5a4:	b7cd                	j	586 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5a6:	00ea06b3          	add	a3,s4,a4
 5aa:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ae:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5b0:	c681                	beqz	a3,5b8 <vprintf+0x7c>
 5b2:	9752                	add	a4,a4,s4
 5b4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5b8:	05878363          	beq	a5,s8,5fe <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5bc:	05978d63          	beq	a5,s9,616 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5c0:	07500713          	li	a4,117
 5c4:	0ee78763          	beq	a5,a4,6b2 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5c8:	07800713          	li	a4,120
 5cc:	12e78963          	beq	a5,a4,6fe <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5d0:	07000713          	li	a4,112
 5d4:	14e78e63          	beq	a5,a4,730 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5d8:	06300713          	li	a4,99
 5dc:	18e78e63          	beq	a5,a4,778 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5e0:	07300713          	li	a4,115
 5e4:	1ae78463          	beq	a5,a4,78c <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5e8:	02500713          	li	a4,37
 5ec:	04e79563          	bne	a5,a4,636 <vprintf+0xfa>
        putc(fd, '%');
 5f0:	02500593          	li	a1,37
 5f4:	855a                	mv	a0,s6
 5f6:	e8dff0ef          	jal	482 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b769                	j	586 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5fe:	008b8913          	addi	s2,s7,8
 602:	4685                	li	a3,1
 604:	4629                	li	a2,10
 606:	000ba583          	lw	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	e95ff0ef          	jal	4a0 <printint>
 610:	8bca                	mv	s7,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	bf8d                	j	586 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 616:	06400793          	li	a5,100
 61a:	02f68963          	beq	a3,a5,64c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 61e:	06c00793          	li	a5,108
 622:	04f68263          	beq	a3,a5,666 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 626:	07500793          	li	a5,117
 62a:	0af68063          	beq	a3,a5,6ca <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 62e:	07800793          	li	a5,120
 632:	0ef68263          	beq	a3,a5,716 <vprintf+0x1da>
        putc(fd, '%');
 636:	02500593          	li	a1,37
 63a:	855a                	mv	a0,s6
 63c:	e47ff0ef          	jal	482 <putc>
        putc(fd, c0);
 640:	85ca                	mv	a1,s2
 642:	855a                	mv	a0,s6
 644:	e3fff0ef          	jal	482 <putc>
      state = 0;
 648:	4981                	li	s3,0
 64a:	bf35                	j	586 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64c:	008b8913          	addi	s2,s7,8
 650:	4685                	li	a3,1
 652:	4629                	li	a2,10
 654:	000bb583          	ld	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	e47ff0ef          	jal	4a0 <printint>
        i += 1;
 65e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
        i += 1;
 664:	b70d                	j	586 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 666:	06400793          	li	a5,100
 66a:	02f60763          	beq	a2,a5,698 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 66e:	07500793          	li	a5,117
 672:	06f60963          	beq	a2,a5,6e4 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 676:	07800793          	li	a5,120
 67a:	faf61ee3          	bne	a2,a5,636 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 67e:	008b8913          	addi	s2,s7,8
 682:	4681                	li	a3,0
 684:	4641                	li	a2,16
 686:	000bb583          	ld	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	e15ff0ef          	jal	4a0 <printint>
        i += 2;
 690:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
        i += 2;
 696:	bdc5                	j	586 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 698:	008b8913          	addi	s2,s7,8
 69c:	4685                	li	a3,1
 69e:	4629                	li	a2,10
 6a0:	000bb583          	ld	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	dfbff0ef          	jal	4a0 <printint>
        i += 2;
 6aa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ac:	8bca                	mv	s7,s2
      state = 0;
 6ae:	4981                	li	s3,0
        i += 2;
 6b0:	bdd9                	j	586 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6b2:	008b8913          	addi	s2,s7,8
 6b6:	4681                	li	a3,0
 6b8:	4629                	li	a2,10
 6ba:	000be583          	lwu	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	de1ff0ef          	jal	4a0 <printint>
 6c4:	8bca                	mv	s7,s2
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bd7d                	j	586 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ca:	008b8913          	addi	s2,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4629                	li	a2,10
 6d2:	000bb583          	ld	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	dc9ff0ef          	jal	4a0 <printint>
        i += 1;
 6dc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6de:	8bca                	mv	s7,s2
      state = 0;
 6e0:	4981                	li	s3,0
        i += 1;
 6e2:	b555                	j	586 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e4:	008b8913          	addi	s2,s7,8
 6e8:	4681                	li	a3,0
 6ea:	4629                	li	a2,10
 6ec:	000bb583          	ld	a1,0(s7)
 6f0:	855a                	mv	a0,s6
 6f2:	dafff0ef          	jal	4a0 <printint>
        i += 2;
 6f6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f8:	8bca                	mv	s7,s2
      state = 0;
 6fa:	4981                	li	s3,0
        i += 2;
 6fc:	b569                	j	586 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6fe:	008b8913          	addi	s2,s7,8
 702:	4681                	li	a3,0
 704:	4641                	li	a2,16
 706:	000be583          	lwu	a1,0(s7)
 70a:	855a                	mv	a0,s6
 70c:	d95ff0ef          	jal	4a0 <printint>
 710:	8bca                	mv	s7,s2
      state = 0;
 712:	4981                	li	s3,0
 714:	bd8d                	j	586 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 716:	008b8913          	addi	s2,s7,8
 71a:	4681                	li	a3,0
 71c:	4641                	li	a2,16
 71e:	000bb583          	ld	a1,0(s7)
 722:	855a                	mv	a0,s6
 724:	d7dff0ef          	jal	4a0 <printint>
        i += 1;
 728:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 72a:	8bca                	mv	s7,s2
      state = 0;
 72c:	4981                	li	s3,0
        i += 1;
 72e:	bda1                	j	586 <vprintf+0x4a>
 730:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 732:	008b8d13          	addi	s10,s7,8
 736:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 73a:	03000593          	li	a1,48
 73e:	855a                	mv	a0,s6
 740:	d43ff0ef          	jal	482 <putc>
  putc(fd, 'x');
 744:	07800593          	li	a1,120
 748:	855a                	mv	a0,s6
 74a:	d39ff0ef          	jal	482 <putc>
 74e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 750:	00000b97          	auipc	s7,0x0
 754:	430b8b93          	addi	s7,s7,1072 # b80 <digits>
 758:	03c9d793          	srli	a5,s3,0x3c
 75c:	97de                	add	a5,a5,s7
 75e:	0007c583          	lbu	a1,0(a5)
 762:	855a                	mv	a0,s6
 764:	d1fff0ef          	jal	482 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 768:	0992                	slli	s3,s3,0x4
 76a:	397d                	addiw	s2,s2,-1
 76c:	fe0916e3          	bnez	s2,758 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 770:	8bea                	mv	s7,s10
      state = 0;
 772:	4981                	li	s3,0
 774:	6d02                	ld	s10,0(sp)
 776:	bd01                	j	586 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 778:	008b8913          	addi	s2,s7,8
 77c:	000bc583          	lbu	a1,0(s7)
 780:	855a                	mv	a0,s6
 782:	d01ff0ef          	jal	482 <putc>
 786:	8bca                	mv	s7,s2
      state = 0;
 788:	4981                	li	s3,0
 78a:	bbf5                	j	586 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 78c:	008b8993          	addi	s3,s7,8
 790:	000bb903          	ld	s2,0(s7)
 794:	00090f63          	beqz	s2,7b2 <vprintf+0x276>
        for(; *s; s++)
 798:	00094583          	lbu	a1,0(s2)
 79c:	c195                	beqz	a1,7c0 <vprintf+0x284>
          putc(fd, *s);
 79e:	855a                	mv	a0,s6
 7a0:	ce3ff0ef          	jal	482 <putc>
        for(; *s; s++)
 7a4:	0905                	addi	s2,s2,1
 7a6:	00094583          	lbu	a1,0(s2)
 7aa:	f9f5                	bnez	a1,79e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7ac:	8bce                	mv	s7,s3
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	bbd9                	j	586 <vprintf+0x4a>
          s = "(null)";
 7b2:	00000917          	auipc	s2,0x0
 7b6:	3c690913          	addi	s2,s2,966 # b78 <malloc+0x2ba>
        for(; *s; s++)
 7ba:	02800593          	li	a1,40
 7be:	b7c5                	j	79e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7c0:	8bce                	mv	s7,s3
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	b3c9                	j	586 <vprintf+0x4a>
 7c6:	64a6                	ld	s1,72(sp)
 7c8:	79e2                	ld	s3,56(sp)
 7ca:	7a42                	ld	s4,48(sp)
 7cc:	7aa2                	ld	s5,40(sp)
 7ce:	7b02                	ld	s6,32(sp)
 7d0:	6be2                	ld	s7,24(sp)
 7d2:	6c42                	ld	s8,16(sp)
 7d4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7d6:	60e6                	ld	ra,88(sp)
 7d8:	6446                	ld	s0,80(sp)
 7da:	6906                	ld	s2,64(sp)
 7dc:	6125                	addi	sp,sp,96
 7de:	8082                	ret

00000000000007e0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e0:	715d                	addi	sp,sp,-80
 7e2:	ec06                	sd	ra,24(sp)
 7e4:	e822                	sd	s0,16(sp)
 7e6:	1000                	addi	s0,sp,32
 7e8:	e010                	sd	a2,0(s0)
 7ea:	e414                	sd	a3,8(s0)
 7ec:	e818                	sd	a4,16(s0)
 7ee:	ec1c                	sd	a5,24(s0)
 7f0:	03043023          	sd	a6,32(s0)
 7f4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fc:	8622                	mv	a2,s0
 7fe:	d3fff0ef          	jal	53c <vprintf>
}
 802:	60e2                	ld	ra,24(sp)
 804:	6442                	ld	s0,16(sp)
 806:	6161                	addi	sp,sp,80
 808:	8082                	ret

000000000000080a <printf>:

void
printf(const char *fmt, ...)
{
 80a:	711d                	addi	sp,sp,-96
 80c:	ec06                	sd	ra,24(sp)
 80e:	e822                	sd	s0,16(sp)
 810:	1000                	addi	s0,sp,32
 812:	e40c                	sd	a1,8(s0)
 814:	e810                	sd	a2,16(s0)
 816:	ec14                	sd	a3,24(s0)
 818:	f018                	sd	a4,32(s0)
 81a:	f41c                	sd	a5,40(s0)
 81c:	03043823          	sd	a6,48(s0)
 820:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 824:	00840613          	addi	a2,s0,8
 828:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 82c:	85aa                	mv	a1,a0
 82e:	4505                	li	a0,1
 830:	d0dff0ef          	jal	53c <vprintf>
}
 834:	60e2                	ld	ra,24(sp)
 836:	6442                	ld	s0,16(sp)
 838:	6125                	addi	sp,sp,96
 83a:	8082                	ret

000000000000083c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83c:	1141                	addi	sp,sp,-16
 83e:	e422                	sd	s0,8(sp)
 840:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 842:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 846:	00000797          	auipc	a5,0x0
 84a:	7ba7b783          	ld	a5,1978(a5) # 1000 <freep>
 84e:	a02d                	j	878 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 850:	4618                	lw	a4,8(a2)
 852:	9f2d                	addw	a4,a4,a1
 854:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 858:	6398                	ld	a4,0(a5)
 85a:	6310                	ld	a2,0(a4)
 85c:	a83d                	j	89a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 85e:	ff852703          	lw	a4,-8(a0)
 862:	9f31                	addw	a4,a4,a2
 864:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 866:	ff053683          	ld	a3,-16(a0)
 86a:	a091                	j	8ae <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	6398                	ld	a4,0(a5)
 86e:	00e7e463          	bltu	a5,a4,876 <free+0x3a>
 872:	00e6ea63          	bltu	a3,a4,886 <free+0x4a>
{
 876:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 878:	fed7fae3          	bgeu	a5,a3,86c <free+0x30>
 87c:	6398                	ld	a4,0(a5)
 87e:	00e6e463          	bltu	a3,a4,886 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 882:	fee7eae3          	bltu	a5,a4,876 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 886:	ff852583          	lw	a1,-8(a0)
 88a:	6390                	ld	a2,0(a5)
 88c:	02059813          	slli	a6,a1,0x20
 890:	01c85713          	srli	a4,a6,0x1c
 894:	9736                	add	a4,a4,a3
 896:	fae60de3          	beq	a2,a4,850 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 89a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 89e:	4790                	lw	a2,8(a5)
 8a0:	02061593          	slli	a1,a2,0x20
 8a4:	01c5d713          	srli	a4,a1,0x1c
 8a8:	973e                	add	a4,a4,a5
 8aa:	fae68ae3          	beq	a3,a4,85e <free+0x22>
    p->s.ptr = bp->s.ptr;
 8ae:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8b0:	00000717          	auipc	a4,0x0
 8b4:	74f73823          	sd	a5,1872(a4) # 1000 <freep>
}
 8b8:	6422                	ld	s0,8(sp)
 8ba:	0141                	addi	sp,sp,16
 8bc:	8082                	ret

00000000000008be <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8be:	7139                	addi	sp,sp,-64
 8c0:	fc06                	sd	ra,56(sp)
 8c2:	f822                	sd	s0,48(sp)
 8c4:	f426                	sd	s1,40(sp)
 8c6:	ec4e                	sd	s3,24(sp)
 8c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ca:	02051493          	slli	s1,a0,0x20
 8ce:	9081                	srli	s1,s1,0x20
 8d0:	04bd                	addi	s1,s1,15
 8d2:	8091                	srli	s1,s1,0x4
 8d4:	0014899b          	addiw	s3,s1,1
 8d8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8da:	00000517          	auipc	a0,0x0
 8de:	72653503          	ld	a0,1830(a0) # 1000 <freep>
 8e2:	c915                	beqz	a0,916 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e6:	4798                	lw	a4,8(a5)
 8e8:	08977a63          	bgeu	a4,s1,97c <malloc+0xbe>
 8ec:	f04a                	sd	s2,32(sp)
 8ee:	e852                	sd	s4,16(sp)
 8f0:	e456                	sd	s5,8(sp)
 8f2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8f4:	8a4e                	mv	s4,s3
 8f6:	0009871b          	sext.w	a4,s3
 8fa:	6685                	lui	a3,0x1
 8fc:	00d77363          	bgeu	a4,a3,902 <malloc+0x44>
 900:	6a05                	lui	s4,0x1
 902:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 906:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 90a:	00000917          	auipc	s2,0x0
 90e:	6f690913          	addi	s2,s2,1782 # 1000 <freep>
  if(p == SBRK_ERROR)
 912:	5afd                	li	s5,-1
 914:	a081                	j	954 <malloc+0x96>
 916:	f04a                	sd	s2,32(sp)
 918:	e852                	sd	s4,16(sp)
 91a:	e456                	sd	s5,8(sp)
 91c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 91e:	00000797          	auipc	a5,0x0
 922:	6f278793          	addi	a5,a5,1778 # 1010 <base>
 926:	00000717          	auipc	a4,0x0
 92a:	6cf73d23          	sd	a5,1754(a4) # 1000 <freep>
 92e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 930:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 934:	b7c1                	j	8f4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 936:	6398                	ld	a4,0(a5)
 938:	e118                	sd	a4,0(a0)
 93a:	a8a9                	j	994 <malloc+0xd6>
  hp->s.size = nu;
 93c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 940:	0541                	addi	a0,a0,16
 942:	efbff0ef          	jal	83c <free>
  return freep;
 946:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 94a:	c12d                	beqz	a0,9ac <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94e:	4798                	lw	a4,8(a5)
 950:	02977263          	bgeu	a4,s1,974 <malloc+0xb6>
    if(p == freep)
 954:	00093703          	ld	a4,0(s2)
 958:	853e                	mv	a0,a5
 95a:	fef719e3          	bne	a4,a5,94c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 95e:	8552                	mv	a0,s4
 960:	a17ff0ef          	jal	376 <sbrk>
  if(p == SBRK_ERROR)
 964:	fd551ce3          	bne	a0,s5,93c <malloc+0x7e>
        return 0;
 968:	4501                	li	a0,0
 96a:	7902                	ld	s2,32(sp)
 96c:	6a42                	ld	s4,16(sp)
 96e:	6aa2                	ld	s5,8(sp)
 970:	6b02                	ld	s6,0(sp)
 972:	a03d                	j	9a0 <malloc+0xe2>
 974:	7902                	ld	s2,32(sp)
 976:	6a42                	ld	s4,16(sp)
 978:	6aa2                	ld	s5,8(sp)
 97a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 97c:	fae48de3          	beq	s1,a4,936 <malloc+0x78>
        p->s.size -= nunits;
 980:	4137073b          	subw	a4,a4,s3
 984:	c798                	sw	a4,8(a5)
        p += p->s.size;
 986:	02071693          	slli	a3,a4,0x20
 98a:	01c6d713          	srli	a4,a3,0x1c
 98e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 990:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 994:	00000717          	auipc	a4,0x0
 998:	66a73623          	sd	a0,1644(a4) # 1000 <freep>
      return (void*)(p + 1);
 99c:	01078513          	addi	a0,a5,16
  }
}
 9a0:	70e2                	ld	ra,56(sp)
 9a2:	7442                	ld	s0,48(sp)
 9a4:	74a2                	ld	s1,40(sp)
 9a6:	69e2                	ld	s3,24(sp)
 9a8:	6121                	addi	sp,sp,64
 9aa:	8082                	ret
 9ac:	7902                	ld	s2,32(sp)
 9ae:	6a42                	ld	s4,16(sp)
 9b0:	6aa2                	ld	s5,8(sp)
 9b2:	6b02                	ld	s6,0(sp)
 9b4:	b7f5                	j	9a0 <malloc+0xe2>
