
user/_stack_guard:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

#define PAGE_SIZE 4096

int main() {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
    printf("=== xv6 Stack Overflow & Guard Page Simulation ===\n");
   a:	00001517          	auipc	a0,0x1
   e:	98650513          	addi	a0,a0,-1658 # 990 <malloc+0x102>
  12:	7c8000ef          	jal	7da <printf>

    // Lấy đỉnh của Stack hiện tại (chính là kích thước hiện tại của tiến trình)
    // sbrk(0) trả về địa chỉ kết thúc vùng nhớ hiện tại của User Space
    char *stack_top = (char *)sbrk(0);
  16:	4501                	li	a0,0
  18:	32e000ef          	jal	346 <sbrk>
  1c:	84aa                	mv	s1,a0
    
    // Tính toán vị trí theo kiến trúc phân bổ của xv6
    char *stack_bottom = stack_top - PAGE_SIZE;
    char *guard_page = stack_bottom - PAGE_SIZE;

    printf("STACK_TOP    : 0x%p\n", stack_top);
  1e:	85aa                	mv	a1,a0
  20:	00001517          	auipc	a0,0x1
  24:	9a850513          	addi	a0,a0,-1624 # 9c8 <malloc+0x13a>
  28:	7b2000ef          	jal	7da <printf>
    printf("STACK_BOTTOM : 0x%p\n", stack_bottom);
  2c:	75fd                	lui	a1,0xfffff
  2e:	95a6                	add	a1,a1,s1
  30:	00001517          	auipc	a0,0x1
  34:	9b050513          	addi	a0,a0,-1616 # 9e0 <malloc+0x152>
  38:	7a2000ef          	jal	7da <printf>
    printf("GUARD_PAGE   : 0x%p (Protected by Kernel)\n", guard_page);
  3c:	75f9                	lui	a1,0xffffe
  3e:	95a6                	add	a1,a1,s1
  40:	00001517          	auipc	a0,0x1
  44:	9b850513          	addi	a0,a0,-1608 # 9f8 <malloc+0x16a>
  48:	792000ef          	jal	7da <printf>

    // =========================================================
    // TEST 1: Ghi dữ liệu hợp lệ vào vùng Stack
    // =========================================================
    printf("\n[TEST 1] Writing into valid Stack memory...\n");
  4c:	00001517          	auipc	a0,0x1
  50:	9dc50513          	addi	a0,a0,-1572 # a28 <malloc+0x19a>
  54:	786000ef          	jal	7da <printf>
    
    // Ghi vào một địa chỉ nằm bên trong trang Stack (cách đỉnh 512 bytes)
    char *valid_addr = stack_top - 512;
    *valid_addr = 'A';
  58:	04100793          	li	a5,65
  5c:	e0f48023          	sb	a5,-512(s1)
    
    printf("[+] OK! Successfully wrote '%c' at 0x%p\n", *valid_addr, valid_addr);
  60:	e0048613          	addi	a2,s1,-512
  64:	04100593          	li	a1,65
  68:	00001517          	auipc	a0,0x1
  6c:	9f050513          	addi	a0,a0,-1552 # a58 <malloc+0x1ca>
  70:	76a000ef          	jal	7da <printf>

    // =========================================================
    // TEST 2: Gây ra hiện tượng Stack Overflow chạm vào Guard Page
    // =========================================================
    printf("\n[TEST 2] Triggering Stack Overflow (Accessing Guard Page)...\n");
  74:	00001517          	auipc	a0,0x1
  78:	a1450513          	addi	a0,a0,-1516 # a88 <malloc+0x1fa>
  7c:	75e000ef          	jal	7da <printf>
    
    int pid = fork();
  80:	2f2000ef          	jal	372 <fork>
    if(pid < 0) {
  84:	02054b63          	bltz	a0,ba <main+0xba>
        printf("Fork failed!\n");
        exit(1);
    }

    if(pid == 0) {
  88:	e131                	bnez	a0,cc <main+0xcc>
        // Tiến trình con cố tình ghi đè vượt biên xuống vùng Guard Page
        // Thử ghi vào byte cuối cùng thuộc Guard Page
        char *overflow_addr = guard_page + PAGE_SIZE - 1; 
  8a:	75fd                	lui	a1,0xfffff
  8c:	15fd                	addi	a1,a1,-1 # ffffffffffffefff <base+0xffffffffffffdfef>
        
        printf("Child attempting to write at Guard Page address: 0x%p\n", overflow_addr);
  8e:	95a6                	add	a1,a1,s1
  90:	00001517          	auipc	a0,0x1
  94:	a4850513          	addi	a0,a0,-1464 # ad8 <malloc+0x24a>
  98:	742000ef          	jal	7da <printf>
        
        *overflow_addr = 'X'; // <-- Dòng này sẽ kích hoạt Page Fault (Trap 15)
  9c:	77fd                	lui	a5,0xfffff
  9e:	94be                	add	s1,s1,a5
  a0:	05800793          	li	a5,88
  a4:	fef48fa3          	sb	a5,-1(s1)
        
        // Nếu chạy được đến đây tức là Guard Page thất bại
        printf("[FAIL] Guard Page did not block access! ❌\n");
  a8:	00001517          	auipc	a0,0x1
  ac:	a6850513          	addi	a0,a0,-1432 # b10 <malloc+0x282>
  b0:	72a000ef          	jal	7da <printf>
        exit(0);
  b4:	4501                	li	a0,0
  b6:	2c4000ef          	jal	37a <exit>
        printf("Fork failed!\n");
  ba:	00001517          	auipc	a0,0x1
  be:	a0e50513          	addi	a0,a0,-1522 # ac8 <malloc+0x23a>
  c2:	718000ef          	jal	7da <printf>
        exit(1);
  c6:	4505                	li	a0,1
  c8:	2b2000ef          	jal	37a <exit>
    } else {
        int status;
        wait(&status);
  cc:	fdc40513          	addi	a0,s0,-36
  d0:	2b2000ef          	jal	382 <wait>
        
        // Tiến trình con bị sập và bị kernel kill, tiến trình cha nhận biết và thông báo thành công
        printf("[OK] Stack Overflow detected! Process terminated by Kernel Guard Page. ✅\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	a6c50513          	addi	a0,a0,-1428 # b40 <malloc+0x2b2>
  dc:	6fe000ef          	jal	7da <printf>
    }

    exit(0);
  e0:	4501                	li	a0,0
  e2:	298000ef          	jal	37a <exit>

00000000000000e6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  ee:	f13ff0ef          	jal	0 <main>
  exit(r);
  f2:	288000ef          	jal	37a <exit>

00000000000000f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fc:	87aa                	mv	a5,a0
  fe:	0585                	addi	a1,a1,1
 100:	0785                	addi	a5,a5,1 # fffffffffffff001 <base+0xffffffffffffdff1>
 102:	fff5c703          	lbu	a4,-1(a1)
 106:	fee78fa3          	sb	a4,-1(a5)
 10a:	fb75                	bnez	a4,fe <strcpy+0x8>
    ;
  return os;
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cb91                	beqz	a5,130 <strcmp+0x1e>
 11e:	0005c703          	lbu	a4,0(a1)
 122:	00f71763          	bne	a4,a5,130 <strcmp+0x1e>
    p++, q++;
 126:	0505                	addi	a0,a0,1
 128:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	fbe5                	bnez	a5,11e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 130:	0005c503          	lbu	a0,0(a1)
}
 134:	40a7853b          	subw	a0,a5,a0
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strlen>:

uint
strlen(const char *s)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 144:	00054783          	lbu	a5,0(a0)
 148:	cf91                	beqz	a5,164 <strlen+0x26>
 14a:	0505                	addi	a0,a0,1
 14c:	87aa                	mv	a5,a0
 14e:	86be                	mv	a3,a5
 150:	0785                	addi	a5,a5,1
 152:	fff7c703          	lbu	a4,-1(a5)
 156:	ff65                	bnez	a4,14e <strlen+0x10>
 158:	40a6853b          	subw	a0,a3,a0
 15c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret
  for(n = 0; s[n]; n++)
 164:	4501                	li	a0,0
 166:	bfe5                	j	15e <strlen+0x20>

0000000000000168 <memset>:

void*
memset(void *dst, int c, uint n)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 16e:	ca19                	beqz	a2,184 <memset+0x1c>
 170:	87aa                	mv	a5,a0
 172:	1602                	slli	a2,a2,0x20
 174:	9201                	srli	a2,a2,0x20
 176:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 17e:	0785                	addi	a5,a5,1
 180:	fee79de3          	bne	a5,a4,17a <memset+0x12>
  }
  return dst;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strchr>:

char*
strchr(const char *s, char c)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb99                	beqz	a5,1aa <strchr+0x20>
    if(*s == c)
 196:	00f58763          	beq	a1,a5,1a4 <strchr+0x1a>
  for(; *s; s++)
 19a:	0505                	addi	a0,a0,1
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	fbfd                	bnez	a5,196 <strchr+0xc>
      return (char*)s;
  return 0;
 1a2:	4501                	li	a0,0
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret
  return 0;
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strchr+0x1a>

00000000000001ae <gets>:

char*
gets(char *buf, int max)
{
 1ae:	711d                	addi	sp,sp,-96
 1b0:	ec86                	sd	ra,88(sp)
 1b2:	e8a2                	sd	s0,80(sp)
 1b4:	e4a6                	sd	s1,72(sp)
 1b6:	e0ca                	sd	s2,64(sp)
 1b8:	fc4e                	sd	s3,56(sp)
 1ba:	f852                	sd	s4,48(sp)
 1bc:	f456                	sd	s5,40(sp)
 1be:	f05a                	sd	s6,32(sp)
 1c0:	ec5e                	sd	s7,24(sp)
 1c2:	1080                	addi	s0,sp,96
 1c4:	8baa                	mv	s7,a0
 1c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c8:	892a                	mv	s2,a0
 1ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1cc:	4aa9                	li	s5,10
 1ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d0:	89a6                	mv	s3,s1
 1d2:	2485                	addiw	s1,s1,1
 1d4:	0344d663          	bge	s1,s4,200 <gets+0x52>
    cc = read(0, &c, 1);
 1d8:	4605                	li	a2,1
 1da:	faf40593          	addi	a1,s0,-81
 1de:	4501                	li	a0,0
 1e0:	1b2000ef          	jal	392 <read>
    if(cc < 1)
 1e4:	00a05e63          	blez	a0,200 <gets+0x52>
    buf[i++] = c;
 1e8:	faf44783          	lbu	a5,-81(s0)
 1ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f0:	01578763          	beq	a5,s5,1fe <gets+0x50>
 1f4:	0905                	addi	s2,s2,1
 1f6:	fd679de3          	bne	a5,s6,1d0 <gets+0x22>
    buf[i++] = c;
 1fa:	89a6                	mv	s3,s1
 1fc:	a011                	j	200 <gets+0x52>
 1fe:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 200:	99de                	add	s3,s3,s7
 202:	00098023          	sb	zero,0(s3)
  return buf;
}
 206:	855e                	mv	a0,s7
 208:	60e6                	ld	ra,88(sp)
 20a:	6446                	ld	s0,80(sp)
 20c:	64a6                	ld	s1,72(sp)
 20e:	6906                	ld	s2,64(sp)
 210:	79e2                	ld	s3,56(sp)
 212:	7a42                	ld	s4,48(sp)
 214:	7aa2                	ld	s5,40(sp)
 216:	7b02                	ld	s6,32(sp)
 218:	6be2                	ld	s7,24(sp)
 21a:	6125                	addi	sp,sp,96
 21c:	8082                	ret

000000000000021e <stat>:

int
stat(const char *n, struct stat *st)
{
 21e:	1101                	addi	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	e04a                	sd	s2,0(sp)
 226:	1000                	addi	s0,sp,32
 228:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22a:	4581                	li	a1,0
 22c:	18e000ef          	jal	3ba <open>
  if(fd < 0)
 230:	02054263          	bltz	a0,254 <stat+0x36>
 234:	e426                	sd	s1,8(sp)
 236:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 238:	85ca                	mv	a1,s2
 23a:	198000ef          	jal	3d2 <fstat>
 23e:	892a                	mv	s2,a0
  close(fd);
 240:	8526                	mv	a0,s1
 242:	160000ef          	jal	3a2 <close>
  return r;
 246:	64a2                	ld	s1,8(sp)
}
 248:	854a                	mv	a0,s2
 24a:	60e2                	ld	ra,24(sp)
 24c:	6442                	ld	s0,16(sp)
 24e:	6902                	ld	s2,0(sp)
 250:	6105                	addi	sp,sp,32
 252:	8082                	ret
    return -1;
 254:	597d                	li	s2,-1
 256:	bfcd                	j	248 <stat+0x2a>

0000000000000258 <atoi>:

int
atoi(const char *s)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25e:	00054683          	lbu	a3,0(a0)
 262:	fd06879b          	addiw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	4625                	li	a2,9
 26c:	02f66863          	bltu	a2,a5,29c <atoi+0x44>
 270:	872a                	mv	a4,a0
  n = 0;
 272:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 274:	0705                	addi	a4,a4,1
 276:	0025179b          	slliw	a5,a0,0x2
 27a:	9fa9                	addw	a5,a5,a0
 27c:	0017979b          	slliw	a5,a5,0x1
 280:	9fb5                	addw	a5,a5,a3
 282:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 286:	00074683          	lbu	a3,0(a4)
 28a:	fd06879b          	addiw	a5,a3,-48
 28e:	0ff7f793          	zext.b	a5,a5
 292:	fef671e3          	bgeu	a2,a5,274 <atoi+0x1c>
  return n;
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  n = 0;
 29c:	4501                	li	a0,0
 29e:	bfe5                	j	296 <atoi+0x3e>

00000000000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a6:	02b57463          	bgeu	a0,a1,2ce <memmove+0x2e>
    while(n-- > 0)
 2aa:	00c05f63          	blez	a2,2c8 <memmove+0x28>
 2ae:	1602                	slli	a2,a2,0x20
 2b0:	9201                	srli	a2,a2,0x20
 2b2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b8:	0585                	addi	a1,a1,1
 2ba:	0705                	addi	a4,a4,1
 2bc:	fff5c683          	lbu	a3,-1(a1)
 2c0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c4:	fef71ae3          	bne	a4,a5,2b8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
    dst += n;
 2ce:	00c50733          	add	a4,a0,a2
    src += n;
 2d2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d4:	fec05ae3          	blez	a2,2c8 <memmove+0x28>
 2d8:	fff6079b          	addiw	a5,a2,-1
 2dc:	1782                	slli	a5,a5,0x20
 2de:	9381                	srli	a5,a5,0x20
 2e0:	fff7c793          	not	a5,a5
 2e4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e6:	15fd                	addi	a1,a1,-1
 2e8:	177d                	addi	a4,a4,-1
 2ea:	0005c683          	lbu	a3,0(a1)
 2ee:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f2:	fee79ae3          	bne	a5,a4,2e6 <memmove+0x46>
 2f6:	bfc9                	j	2c8 <memmove+0x28>

00000000000002f8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fe:	ca05                	beqz	a2,32e <memcmp+0x36>
 300:	fff6069b          	addiw	a3,a2,-1
 304:	1682                	slli	a3,a3,0x20
 306:	9281                	srli	a3,a3,0x20
 308:	0685                	addi	a3,a3,1
 30a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 30c:	00054783          	lbu	a5,0(a0)
 310:	0005c703          	lbu	a4,0(a1)
 314:	00e79863          	bne	a5,a4,324 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 318:	0505                	addi	a0,a0,1
    p2++;
 31a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 31c:	fed518e3          	bne	a0,a3,30c <memcmp+0x14>
  }
  return 0;
 320:	4501                	li	a0,0
 322:	a019                	j	328 <memcmp+0x30>
      return *p1 - *p2;
 324:	40e7853b          	subw	a0,a5,a4
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
  return 0;
 32e:	4501                	li	a0,0
 330:	bfe5                	j	328 <memcmp+0x30>

0000000000000332 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 332:	1141                	addi	sp,sp,-16
 334:	e406                	sd	ra,8(sp)
 336:	e022                	sd	s0,0(sp)
 338:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33a:	f67ff0ef          	jal	2a0 <memmove>
}
 33e:	60a2                	ld	ra,8(sp)
 340:	6402                	ld	s0,0(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret

0000000000000346 <sbrk>:

char *
sbrk(int n) {
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 34e:	4585                	li	a1,1
 350:	0b2000ef          	jal	402 <sys_sbrk>
}
 354:	60a2                	ld	ra,8(sp)
 356:	6402                	ld	s0,0(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret

000000000000035c <sbrklazy>:

char *
sbrklazy(int n) {
 35c:	1141                	addi	sp,sp,-16
 35e:	e406                	sd	ra,8(sp)
 360:	e022                	sd	s0,0(sp)
 362:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 364:	4589                	li	a1,2
 366:	09c000ef          	jal	402 <sys_sbrk>
}
 36a:	60a2                	ld	ra,8(sp)
 36c:	6402                	ld	s0,0(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret

0000000000000372 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 372:	4885                	li	a7,1
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <exit>:
.global exit
exit:
 li a7, SYS_exit
 37a:	4889                	li	a7,2
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <wait>:
.global wait
wait:
 li a7, SYS_wait
 382:	488d                	li	a7,3
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38a:	4891                	li	a7,4
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <read>:
.global read
read:
 li a7, SYS_read
 392:	4895                	li	a7,5
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <write>:
.global write
write:
 li a7, SYS_write
 39a:	48c1                	li	a7,16
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <close>:
.global close
close:
 li a7, SYS_close
 3a2:	48d5                	li	a7,21
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <kill>:
.global kill
kill:
 li a7, SYS_kill
 3aa:	4899                	li	a7,6
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b2:	489d                	li	a7,7
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <open>:
.global open
open:
 li a7, SYS_open
 3ba:	48bd                	li	a7,15
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c2:	48c5                	li	a7,17
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ca:	48c9                	li	a7,18
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d2:	48a1                	li	a7,8
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <link>:
.global link
link:
 li a7, SYS_link
 3da:	48cd                	li	a7,19
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e2:	48d1                	li	a7,20
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ea:	48a5                	li	a7,9
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f2:	48a9                	li	a7,10
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fa:	48ad                	li	a7,11
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 402:	48b1                	li	a7,12
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <pause>:
.global pause
pause:
 li a7, SYS_pause
 40a:	48b5                	li	a7,13
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 412:	48b9                	li	a7,14
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <hello>:
.global hello
hello:
 li a7, SYS_hello
 41a:	48d9                	li	a7,22
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <ps>:
.global ps
ps:
 li a7, SYS_ps
 422:	48dd                	li	a7,23
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <memtest>:
.global memtest
memtest:
 li a7, SYS_memtest
 42a:	48e1                	li	a7,24
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <testnolock>:
.global testnolock
testnolock:
 li a7, SYS_testnolock
 432:	48e5                	li	a7,25
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <testlock>:
.global testlock
testlock:
 li a7, SYS_testlock
 43a:	48e9                	li	a7,26
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <nullcall>:
.global nullcall
nullcall:
 li a7, SYS_nullcall
 442:	48ed                	li	a7,27
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <getcycles>:
.global getcycles
getcycles:
 li a7, SYS_getcycles
 44a:	48f1                	li	a7,28
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 452:	1101                	addi	sp,sp,-32
 454:	ec06                	sd	ra,24(sp)
 456:	e822                	sd	s0,16(sp)
 458:	1000                	addi	s0,sp,32
 45a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45e:	4605                	li	a2,1
 460:	fef40593          	addi	a1,s0,-17
 464:	f37ff0ef          	jal	39a <write>
}
 468:	60e2                	ld	ra,24(sp)
 46a:	6442                	ld	s0,16(sp)
 46c:	6105                	addi	sp,sp,32
 46e:	8082                	ret

0000000000000470 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 470:	715d                	addi	sp,sp,-80
 472:	e486                	sd	ra,72(sp)
 474:	e0a2                	sd	s0,64(sp)
 476:	f84a                	sd	s2,48(sp)
 478:	0880                	addi	s0,sp,80
 47a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 47c:	c299                	beqz	a3,482 <printint+0x12>
 47e:	0805c363          	bltz	a1,504 <printint+0x94>
  neg = 0;
 482:	4881                	li	a7,0
 484:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 488:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 48a:	00000517          	auipc	a0,0x0
 48e:	70e50513          	addi	a0,a0,1806 # b98 <digits>
 492:	883e                	mv	a6,a5
 494:	2785                	addiw	a5,a5,1
 496:	02c5f733          	remu	a4,a1,a2
 49a:	972a                	add	a4,a4,a0
 49c:	00074703          	lbu	a4,0(a4)
 4a0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4a4:	872e                	mv	a4,a1
 4a6:	02c5d5b3          	divu	a1,a1,a2
 4aa:	0685                	addi	a3,a3,1
 4ac:	fec773e3          	bgeu	a4,a2,492 <printint+0x22>
  if(neg)
 4b0:	00088b63          	beqz	a7,4c6 <printint+0x56>
    buf[i++] = '-';
 4b4:	fd078793          	addi	a5,a5,-48
 4b8:	97a2                	add	a5,a5,s0
 4ba:	02d00713          	li	a4,45
 4be:	fee78423          	sb	a4,-24(a5)
 4c2:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 4c6:	02f05a63          	blez	a5,4fa <printint+0x8a>
 4ca:	fc26                	sd	s1,56(sp)
 4cc:	f44e                	sd	s3,40(sp)
 4ce:	fb840713          	addi	a4,s0,-72
 4d2:	00f704b3          	add	s1,a4,a5
 4d6:	fff70993          	addi	s3,a4,-1
 4da:	99be                	add	s3,s3,a5
 4dc:	37fd                	addiw	a5,a5,-1
 4de:	1782                	slli	a5,a5,0x20
 4e0:	9381                	srli	a5,a5,0x20
 4e2:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4e6:	fff4c583          	lbu	a1,-1(s1)
 4ea:	854a                	mv	a0,s2
 4ec:	f67ff0ef          	jal	452 <putc>
  while(--i >= 0)
 4f0:	14fd                	addi	s1,s1,-1
 4f2:	ff349ae3          	bne	s1,s3,4e6 <printint+0x76>
 4f6:	74e2                	ld	s1,56(sp)
 4f8:	79a2                	ld	s3,40(sp)
}
 4fa:	60a6                	ld	ra,72(sp)
 4fc:	6406                	ld	s0,64(sp)
 4fe:	7942                	ld	s2,48(sp)
 500:	6161                	addi	sp,sp,80
 502:	8082                	ret
    x = -xx;
 504:	40b005b3          	neg	a1,a1
    neg = 1;
 508:	4885                	li	a7,1
    x = -xx;
 50a:	bfad                	j	484 <printint+0x14>

000000000000050c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50c:	711d                	addi	sp,sp,-96
 50e:	ec86                	sd	ra,88(sp)
 510:	e8a2                	sd	s0,80(sp)
 512:	e0ca                	sd	s2,64(sp)
 514:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 516:	0005c903          	lbu	s2,0(a1)
 51a:	28090663          	beqz	s2,7a6 <vprintf+0x29a>
 51e:	e4a6                	sd	s1,72(sp)
 520:	fc4e                	sd	s3,56(sp)
 522:	f852                	sd	s4,48(sp)
 524:	f456                	sd	s5,40(sp)
 526:	f05a                	sd	s6,32(sp)
 528:	ec5e                	sd	s7,24(sp)
 52a:	e862                	sd	s8,16(sp)
 52c:	e466                	sd	s9,8(sp)
 52e:	8b2a                	mv	s6,a0
 530:	8a2e                	mv	s4,a1
 532:	8bb2                	mv	s7,a2
  state = 0;
 534:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 536:	4481                	li	s1,0
 538:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 53a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 53e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 542:	06c00c93          	li	s9,108
 546:	a005                	j	566 <vprintf+0x5a>
        putc(fd, c0);
 548:	85ca                	mv	a1,s2
 54a:	855a                	mv	a0,s6
 54c:	f07ff0ef          	jal	452 <putc>
 550:	a019                	j	556 <vprintf+0x4a>
    } else if(state == '%'){
 552:	03598263          	beq	s3,s5,576 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 556:	2485                	addiw	s1,s1,1
 558:	8726                	mv	a4,s1
 55a:	009a07b3          	add	a5,s4,s1
 55e:	0007c903          	lbu	s2,0(a5)
 562:	22090a63          	beqz	s2,796 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 566:	0009079b          	sext.w	a5,s2
    if(state == 0){
 56a:	fe0994e3          	bnez	s3,552 <vprintf+0x46>
      if(c0 == '%'){
 56e:	fd579de3          	bne	a5,s5,548 <vprintf+0x3c>
        state = '%';
 572:	89be                	mv	s3,a5
 574:	b7cd                	j	556 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 576:	00ea06b3          	add	a3,s4,a4
 57a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 57e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 580:	c681                	beqz	a3,588 <vprintf+0x7c>
 582:	9752                	add	a4,a4,s4
 584:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 588:	05878363          	beq	a5,s8,5ce <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 58c:	05978d63          	beq	a5,s9,5e6 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 590:	07500713          	li	a4,117
 594:	0ee78763          	beq	a5,a4,682 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 598:	07800713          	li	a4,120
 59c:	12e78963          	beq	a5,a4,6ce <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5a0:	07000713          	li	a4,112
 5a4:	14e78e63          	beq	a5,a4,700 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5a8:	06300713          	li	a4,99
 5ac:	18e78e63          	beq	a5,a4,748 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5b0:	07300713          	li	a4,115
 5b4:	1ae78463          	beq	a5,a4,75c <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5b8:	02500713          	li	a4,37
 5bc:	04e79563          	bne	a5,a4,606 <vprintf+0xfa>
        putc(fd, '%');
 5c0:	02500593          	li	a1,37
 5c4:	855a                	mv	a0,s6
 5c6:	e8dff0ef          	jal	452 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b769                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5ce:	008b8913          	addi	s2,s7,8
 5d2:	4685                	li	a3,1
 5d4:	4629                	li	a2,10
 5d6:	000ba583          	lw	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	e95ff0ef          	jal	470 <printint>
 5e0:	8bca                	mv	s7,s2
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bf8d                	j	556 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5e6:	06400793          	li	a5,100
 5ea:	02f68963          	beq	a3,a5,61c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ee:	06c00793          	li	a5,108
 5f2:	04f68263          	beq	a3,a5,636 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 5f6:	07500793          	li	a5,117
 5fa:	0af68063          	beq	a3,a5,69a <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5fe:	07800793          	li	a5,120
 602:	0ef68263          	beq	a3,a5,6e6 <vprintf+0x1da>
        putc(fd, '%');
 606:	02500593          	li	a1,37
 60a:	855a                	mv	a0,s6
 60c:	e47ff0ef          	jal	452 <putc>
        putc(fd, c0);
 610:	85ca                	mv	a1,s2
 612:	855a                	mv	a0,s6
 614:	e3fff0ef          	jal	452 <putc>
      state = 0;
 618:	4981                	li	s3,0
 61a:	bf35                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 61c:	008b8913          	addi	s2,s7,8
 620:	4685                	li	a3,1
 622:	4629                	li	a2,10
 624:	000bb583          	ld	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	e47ff0ef          	jal	470 <printint>
        i += 1;
 62e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
        i += 1;
 634:	b70d                	j	556 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 636:	06400793          	li	a5,100
 63a:	02f60763          	beq	a2,a5,668 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 63e:	07500793          	li	a5,117
 642:	06f60963          	beq	a2,a5,6b4 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 646:	07800793          	li	a5,120
 64a:	faf61ee3          	bne	a2,a5,606 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64e:	008b8913          	addi	s2,s7,8
 652:	4681                	li	a3,0
 654:	4641                	li	a2,16
 656:	000bb583          	ld	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	e15ff0ef          	jal	470 <printint>
        i += 2;
 660:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 662:	8bca                	mv	s7,s2
      state = 0;
 664:	4981                	li	s3,0
        i += 2;
 666:	bdc5                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 668:	008b8913          	addi	s2,s7,8
 66c:	4685                	li	a3,1
 66e:	4629                	li	a2,10
 670:	000bb583          	ld	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	dfbff0ef          	jal	470 <printint>
        i += 2;
 67a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
        i += 2;
 680:	bdd9                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 682:	008b8913          	addi	s2,s7,8
 686:	4681                	li	a3,0
 688:	4629                	li	a2,10
 68a:	000be583          	lwu	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	de1ff0ef          	jal	470 <printint>
 694:	8bca                	mv	s7,s2
      state = 0;
 696:	4981                	li	s3,0
 698:	bd7d                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69a:	008b8913          	addi	s2,s7,8
 69e:	4681                	li	a3,0
 6a0:	4629                	li	a2,10
 6a2:	000bb583          	ld	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	dc9ff0ef          	jal	470 <printint>
        i += 1;
 6ac:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
        i += 1;
 6b2:	b555                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4629                	li	a2,10
 6bc:	000bb583          	ld	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	dafff0ef          	jal	470 <printint>
        i += 2;
 6c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
        i += 2;
 6cc:	b569                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4641                	li	a2,16
 6d6:	000be583          	lwu	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	d95ff0ef          	jal	470 <printint>
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bd8d                	j	556 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e6:	008b8913          	addi	s2,s7,8
 6ea:	4681                	li	a3,0
 6ec:	4641                	li	a2,16
 6ee:	000bb583          	ld	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	d7dff0ef          	jal	470 <printint>
        i += 1;
 6f8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
        i += 1;
 6fe:	bda1                	j	556 <vprintf+0x4a>
 700:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 702:	008b8d13          	addi	s10,s7,8
 706:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 70a:	03000593          	li	a1,48
 70e:	855a                	mv	a0,s6
 710:	d43ff0ef          	jal	452 <putc>
  putc(fd, 'x');
 714:	07800593          	li	a1,120
 718:	855a                	mv	a0,s6
 71a:	d39ff0ef          	jal	452 <putc>
 71e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 720:	00000b97          	auipc	s7,0x0
 724:	478b8b93          	addi	s7,s7,1144 # b98 <digits>
 728:	03c9d793          	srli	a5,s3,0x3c
 72c:	97de                	add	a5,a5,s7
 72e:	0007c583          	lbu	a1,0(a5)
 732:	855a                	mv	a0,s6
 734:	d1fff0ef          	jal	452 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 738:	0992                	slli	s3,s3,0x4
 73a:	397d                	addiw	s2,s2,-1
 73c:	fe0916e3          	bnez	s2,728 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 740:	8bea                	mv	s7,s10
      state = 0;
 742:	4981                	li	s3,0
 744:	6d02                	ld	s10,0(sp)
 746:	bd01                	j	556 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 748:	008b8913          	addi	s2,s7,8
 74c:	000bc583          	lbu	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	d01ff0ef          	jal	452 <putc>
 756:	8bca                	mv	s7,s2
      state = 0;
 758:	4981                	li	s3,0
 75a:	bbf5                	j	556 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 75c:	008b8993          	addi	s3,s7,8
 760:	000bb903          	ld	s2,0(s7)
 764:	00090f63          	beqz	s2,782 <vprintf+0x276>
        for(; *s; s++)
 768:	00094583          	lbu	a1,0(s2)
 76c:	c195                	beqz	a1,790 <vprintf+0x284>
          putc(fd, *s);
 76e:	855a                	mv	a0,s6
 770:	ce3ff0ef          	jal	452 <putc>
        for(; *s; s++)
 774:	0905                	addi	s2,s2,1
 776:	00094583          	lbu	a1,0(s2)
 77a:	f9f5                	bnez	a1,76e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 77c:	8bce                	mv	s7,s3
      state = 0;
 77e:	4981                	li	s3,0
 780:	bbd9                	j	556 <vprintf+0x4a>
          s = "(null)";
 782:	00000917          	auipc	s2,0x0
 786:	40e90913          	addi	s2,s2,1038 # b90 <malloc+0x302>
        for(; *s; s++)
 78a:	02800593          	li	a1,40
 78e:	b7c5                	j	76e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 790:	8bce                	mv	s7,s3
      state = 0;
 792:	4981                	li	s3,0
 794:	b3c9                	j	556 <vprintf+0x4a>
 796:	64a6                	ld	s1,72(sp)
 798:	79e2                	ld	s3,56(sp)
 79a:	7a42                	ld	s4,48(sp)
 79c:	7aa2                	ld	s5,40(sp)
 79e:	7b02                	ld	s6,32(sp)
 7a0:	6be2                	ld	s7,24(sp)
 7a2:	6c42                	ld	s8,16(sp)
 7a4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7a6:	60e6                	ld	ra,88(sp)
 7a8:	6446                	ld	s0,80(sp)
 7aa:	6906                	ld	s2,64(sp)
 7ac:	6125                	addi	sp,sp,96
 7ae:	8082                	ret

00000000000007b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b0:	715d                	addi	sp,sp,-80
 7b2:	ec06                	sd	ra,24(sp)
 7b4:	e822                	sd	s0,16(sp)
 7b6:	1000                	addi	s0,sp,32
 7b8:	e010                	sd	a2,0(s0)
 7ba:	e414                	sd	a3,8(s0)
 7bc:	e818                	sd	a4,16(s0)
 7be:	ec1c                	sd	a5,24(s0)
 7c0:	03043023          	sd	a6,32(s0)
 7c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7cc:	8622                	mv	a2,s0
 7ce:	d3fff0ef          	jal	50c <vprintf>
}
 7d2:	60e2                	ld	ra,24(sp)
 7d4:	6442                	ld	s0,16(sp)
 7d6:	6161                	addi	sp,sp,80
 7d8:	8082                	ret

00000000000007da <printf>:

void
printf(const char *fmt, ...)
{
 7da:	711d                	addi	sp,sp,-96
 7dc:	ec06                	sd	ra,24(sp)
 7de:	e822                	sd	s0,16(sp)
 7e0:	1000                	addi	s0,sp,32
 7e2:	e40c                	sd	a1,8(s0)
 7e4:	e810                	sd	a2,16(s0)
 7e6:	ec14                	sd	a3,24(s0)
 7e8:	f018                	sd	a4,32(s0)
 7ea:	f41c                	sd	a5,40(s0)
 7ec:	03043823          	sd	a6,48(s0)
 7f0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f4:	00840613          	addi	a2,s0,8
 7f8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7fc:	85aa                	mv	a1,a0
 7fe:	4505                	li	a0,1
 800:	d0dff0ef          	jal	50c <vprintf>
}
 804:	60e2                	ld	ra,24(sp)
 806:	6442                	ld	s0,16(sp)
 808:	6125                	addi	sp,sp,96
 80a:	8082                	ret

000000000000080c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80c:	1141                	addi	sp,sp,-16
 80e:	e422                	sd	s0,8(sp)
 810:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 812:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 816:	00000797          	auipc	a5,0x0
 81a:	7ea7b783          	ld	a5,2026(a5) # 1000 <freep>
 81e:	a02d                	j	848 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 820:	4618                	lw	a4,8(a2)
 822:	9f2d                	addw	a4,a4,a1
 824:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 828:	6398                	ld	a4,0(a5)
 82a:	6310                	ld	a2,0(a4)
 82c:	a83d                	j	86a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 82e:	ff852703          	lw	a4,-8(a0)
 832:	9f31                	addw	a4,a4,a2
 834:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 836:	ff053683          	ld	a3,-16(a0)
 83a:	a091                	j	87e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83c:	6398                	ld	a4,0(a5)
 83e:	00e7e463          	bltu	a5,a4,846 <free+0x3a>
 842:	00e6ea63          	bltu	a3,a4,856 <free+0x4a>
{
 846:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 848:	fed7fae3          	bgeu	a5,a3,83c <free+0x30>
 84c:	6398                	ld	a4,0(a5)
 84e:	00e6e463          	bltu	a3,a4,856 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 852:	fee7eae3          	bltu	a5,a4,846 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 856:	ff852583          	lw	a1,-8(a0)
 85a:	6390                	ld	a2,0(a5)
 85c:	02059813          	slli	a6,a1,0x20
 860:	01c85713          	srli	a4,a6,0x1c
 864:	9736                	add	a4,a4,a3
 866:	fae60de3          	beq	a2,a4,820 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 86a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 86e:	4790                	lw	a2,8(a5)
 870:	02061593          	slli	a1,a2,0x20
 874:	01c5d713          	srli	a4,a1,0x1c
 878:	973e                	add	a4,a4,a5
 87a:	fae68ae3          	beq	a3,a4,82e <free+0x22>
    p->s.ptr = bp->s.ptr;
 87e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 880:	00000717          	auipc	a4,0x0
 884:	78f73023          	sd	a5,1920(a4) # 1000 <freep>
}
 888:	6422                	ld	s0,8(sp)
 88a:	0141                	addi	sp,sp,16
 88c:	8082                	ret

000000000000088e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 88e:	7139                	addi	sp,sp,-64
 890:	fc06                	sd	ra,56(sp)
 892:	f822                	sd	s0,48(sp)
 894:	f426                	sd	s1,40(sp)
 896:	ec4e                	sd	s3,24(sp)
 898:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 89a:	02051493          	slli	s1,a0,0x20
 89e:	9081                	srli	s1,s1,0x20
 8a0:	04bd                	addi	s1,s1,15
 8a2:	8091                	srli	s1,s1,0x4
 8a4:	0014899b          	addiw	s3,s1,1
 8a8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8aa:	00000517          	auipc	a0,0x0
 8ae:	75653503          	ld	a0,1878(a0) # 1000 <freep>
 8b2:	c915                	beqz	a0,8e6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b6:	4798                	lw	a4,8(a5)
 8b8:	08977a63          	bgeu	a4,s1,94c <malloc+0xbe>
 8bc:	f04a                	sd	s2,32(sp)
 8be:	e852                	sd	s4,16(sp)
 8c0:	e456                	sd	s5,8(sp)
 8c2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8c4:	8a4e                	mv	s4,s3
 8c6:	0009871b          	sext.w	a4,s3
 8ca:	6685                	lui	a3,0x1
 8cc:	00d77363          	bgeu	a4,a3,8d2 <malloc+0x44>
 8d0:	6a05                	lui	s4,0x1
 8d2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8da:	00000917          	auipc	s2,0x0
 8de:	72690913          	addi	s2,s2,1830 # 1000 <freep>
  if(p == SBRK_ERROR)
 8e2:	5afd                	li	s5,-1
 8e4:	a081                	j	924 <malloc+0x96>
 8e6:	f04a                	sd	s2,32(sp)
 8e8:	e852                	sd	s4,16(sp)
 8ea:	e456                	sd	s5,8(sp)
 8ec:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ee:	00000797          	auipc	a5,0x0
 8f2:	72278793          	addi	a5,a5,1826 # 1010 <base>
 8f6:	00000717          	auipc	a4,0x0
 8fa:	70f73523          	sd	a5,1802(a4) # 1000 <freep>
 8fe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 900:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 904:	b7c1                	j	8c4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 906:	6398                	ld	a4,0(a5)
 908:	e118                	sd	a4,0(a0)
 90a:	a8a9                	j	964 <malloc+0xd6>
  hp->s.size = nu;
 90c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 910:	0541                	addi	a0,a0,16
 912:	efbff0ef          	jal	80c <free>
  return freep;
 916:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 91a:	c12d                	beqz	a0,97c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91e:	4798                	lw	a4,8(a5)
 920:	02977263          	bgeu	a4,s1,944 <malloc+0xb6>
    if(p == freep)
 924:	00093703          	ld	a4,0(s2)
 928:	853e                	mv	a0,a5
 92a:	fef719e3          	bne	a4,a5,91c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 92e:	8552                	mv	a0,s4
 930:	a17ff0ef          	jal	346 <sbrk>
  if(p == SBRK_ERROR)
 934:	fd551ce3          	bne	a0,s5,90c <malloc+0x7e>
        return 0;
 938:	4501                	li	a0,0
 93a:	7902                	ld	s2,32(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
 942:	a03d                	j	970 <malloc+0xe2>
 944:	7902                	ld	s2,32(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 94c:	fae48de3          	beq	s1,a4,906 <malloc+0x78>
        p->s.size -= nunits;
 950:	4137073b          	subw	a4,a4,s3
 954:	c798                	sw	a4,8(a5)
        p += p->s.size;
 956:	02071693          	slli	a3,a4,0x20
 95a:	01c6d713          	srli	a4,a3,0x1c
 95e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 960:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 964:	00000717          	auipc	a4,0x0
 968:	68a73e23          	sd	a0,1692(a4) # 1000 <freep>
      return (void*)(p + 1);
 96c:	01078513          	addi	a0,a5,16
  }
}
 970:	70e2                	ld	ra,56(sp)
 972:	7442                	ld	s0,48(sp)
 974:	74a2                	ld	s1,40(sp)
 976:	69e2                	ld	s3,24(sp)
 978:	6121                	addi	sp,sp,64
 97a:	8082                	ret
 97c:	7902                	ld	s2,32(sp)
 97e:	6a42                	ld	s4,16(sp)
 980:	6aa2                	ld	s5,8(sp)
 982:	6b02                	ld	s6,0(sp)
 984:	b7f5                	j	970 <malloc+0xe2>
