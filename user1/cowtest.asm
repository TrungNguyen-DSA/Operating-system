
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"

#define MULTI_PAGES 4096 * 5 // Tạo một mảng dữ liệu chiếm 5 trang RAM (20KB)
char global_buffer[MULTI_PAGES];

int main(int argc, char *argv[]) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  printf("--- BAT DAU KIEM THU HIEU QUA BO NHO COW ---\n");
   8:	00001517          	auipc	a0,0x1
   c:	99850513          	addi	a0,a0,-1640 # 9a0 <malloc+0xfe>
  10:	7de000ef          	jal	7ee <printf>

  // Khởi tạo dữ liệu ban đầu cho mảng
  for(int i = 0; i < MULTI_PAGES; i++) {
  14:	00001797          	auipc	a5,0x1
  18:	ffc78793          	addi	a5,a5,-4 # 1010 <global_buffer>
  1c:	00006697          	auipc	a3,0x6
  20:	ff468693          	addi	a3,a3,-12 # 6010 <base>
    global_buffer[i] = 'A';
  24:	04100713          	li	a4,65
  28:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MULTI_PAGES; i++) {
  2c:	0785                	addi	a5,a5,1
  2e:	fed79de3          	bne	a5,a3,28 <main+0x28>
  }

  printf("[1] Truoc khi fork: Buffer da duoc nap du lieu.\n");
  32:	00001517          	auipc	a0,0x1
  36:	9a650513          	addi	a0,a0,-1626 # 9d8 <malloc+0x136>
  3a:	7b4000ef          	jal	7ee <printf>

  int pid = fork();
  3e:	348000ef          	jal	386 <fork>
  if(pid < 0) {
  42:	06054663          	bltz	a0,ae <main+0xae>
    printf("Fork that bai!\n");
    exit(1);
  }

  if(pid == 0) {
  46:	e541                	bnez	a0,ce <main+0xce>
    // --- TIẾN TRÌNH CON ---
    printf("[2] Tien trinh CON: Vua duoc tao (Chua ghi du lieu, dang dung chung RAM voi CHA).\n");
  48:	00001517          	auipc	a0,0x1
  4c:	9d850513          	addi	a0,a0,-1576 # a20 <malloc+0x17e>
  50:	79e000ef          	jal	7ee <printf>
    
    // Đọc thử (Read) -> Không được sinh ra Page Fault, vẫn dùng chung RAM
    char check = global_buffer[0];
    if(check == 'A') {
  54:	00001717          	auipc	a4,0x1
  58:	fbc74703          	lbu	a4,-68(a4) # 1010 <global_buffer>
  5c:	04100793          	li	a5,65
  60:	06f70063          	beq	a4,a5,c0 <main+0xc0>
      printf("[3] Tien trinh CON: Doc thu hop le, van chua ton them RAM vat ly.\n");
    }

    // Ghi thử (Write) -> MMU se kich hoat Page Fault, goi cow_handler cap RAM moi on-demand
    printf("[4] Tien trinh CON: Bat dau GHI du lieu de ep xuyen thung co che COW...\n");
  64:	00001517          	auipc	a0,0x1
  68:	a5c50513          	addi	a0,a0,-1444 # ac0 <malloc+0x21e>
  6c:	782000ef          	jal	7ee <printf>
    for(int i = 0; i < MULTI_PAGES; i += 4096) {
      global_buffer[i] = 'B'; // Ghi vao dau moi trang de kich hoat copy 
  70:	04200793          	li	a5,66
  74:	00001717          	auipc	a4,0x1
  78:	f8f70e23          	sb	a5,-100(a4) # 1010 <global_buffer>
  7c:	00002717          	auipc	a4,0x2
  80:	f8f70a23          	sb	a5,-108(a4) # 2010 <global_buffer+0x1000>
  84:	00003717          	auipc	a4,0x3
  88:	f8f70623          	sb	a5,-116(a4) # 3010 <global_buffer+0x2000>
  8c:	00004717          	auipc	a4,0x4
  90:	f8f70223          	sb	a5,-124(a4) # 4010 <global_buffer+0x3000>
  94:	00005717          	auipc	a4,0x5
  98:	f6f70e23          	sb	a5,-132(a4) # 5010 <global_buffer+0x4000>
    }
    
    printf("[5] Tien trinh CON: Ghi thanh cong! Da tu tach ra o RAM doc lap moi.\n");
  9c:	00001517          	auipc	a0,0x1
  a0:	a7450513          	addi	a0,a0,-1420 # b10 <malloc+0x26e>
  a4:	74a000ef          	jal	7ee <printf>
    exit(0);
  a8:	4501                	li	a0,0
  aa:	2e4000ef          	jal	38e <exit>
    printf("Fork that bai!\n");
  ae:	00001517          	auipc	a0,0x1
  b2:	96250513          	addi	a0,a0,-1694 # a10 <malloc+0x16e>
  b6:	738000ef          	jal	7ee <printf>
    exit(1);
  ba:	4505                	li	a0,1
  bc:	2d2000ef          	jal	38e <exit>
      printf("[3] Tien trinh CON: Doc thu hop le, van chua ton them RAM vat ly.\n");
  c0:	00001517          	auipc	a0,0x1
  c4:	9b850513          	addi	a0,a0,-1608 # a78 <malloc+0x1d6>
  c8:	726000ef          	jal	7ee <printf>
  cc:	bf61                	j	64 <main+0x64>
  } else {
    // --- TIẾN TRÌNH CHA ---
    wait(0);
  ce:	4501                	li	a0,0
  d0:	2c6000ef          	jal	396 <wait>
    printf("[6] Tien trinh CHA: Con da chay xong, kiem tra lai du lieu goc: %c (Phai la 'A').\n", global_buffer[0]);
  d4:	00001597          	auipc	a1,0x1
  d8:	f3c5c583          	lbu	a1,-196(a1) # 1010 <global_buffer>
  dc:	00001517          	auipc	a0,0x1
  e0:	a7c50513          	addi	a0,a0,-1412 # b58 <malloc+0x2b6>
  e4:	70a000ef          	jal	7ee <printf>
    printf("--- KIEM THU HOAN THANH ---\n");
  e8:	00001517          	auipc	a0,0x1
  ec:	ac850513          	addi	a0,a0,-1336 # bb0 <malloc+0x30e>
  f0:	6fe000ef          	jal	7ee <printf>
    exit(0);
  f4:	4501                	li	a0,0
  f6:	298000ef          	jal	38e <exit>

00000000000000fa <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 102:	effff0ef          	jal	0 <main>
  exit(r);
 106:	288000ef          	jal	38e <exit>

000000000000010a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e422                	sd	s0,8(sp)
 10e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 110:	87aa                	mv	a5,a0
 112:	0585                	addi	a1,a1,1
 114:	0785                	addi	a5,a5,1
 116:	fff5c703          	lbu	a4,-1(a1)
 11a:	fee78fa3          	sb	a4,-1(a5)
 11e:	fb75                	bnez	a4,112 <strcpy+0x8>
    ;
  return os;
}
 120:	6422                	ld	s0,8(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12c:	00054783          	lbu	a5,0(a0)
 130:	cb91                	beqz	a5,144 <strcmp+0x1e>
 132:	0005c703          	lbu	a4,0(a1)
 136:	00f71763          	bne	a4,a5,144 <strcmp+0x1e>
    p++, q++;
 13a:	0505                	addi	a0,a0,1
 13c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 13e:	00054783          	lbu	a5,0(a0)
 142:	fbe5                	bnez	a5,132 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 144:	0005c503          	lbu	a0,0(a1)
}
 148:	40a7853b          	subw	a0,a5,a0
 14c:	6422                	ld	s0,8(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret

0000000000000152 <strlen>:

uint
strlen(const char *s)
{
 152:	1141                	addi	sp,sp,-16
 154:	e422                	sd	s0,8(sp)
 156:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 158:	00054783          	lbu	a5,0(a0)
 15c:	cf91                	beqz	a5,178 <strlen+0x26>
 15e:	0505                	addi	a0,a0,1
 160:	87aa                	mv	a5,a0
 162:	86be                	mv	a3,a5
 164:	0785                	addi	a5,a5,1
 166:	fff7c703          	lbu	a4,-1(a5)
 16a:	ff65                	bnez	a4,162 <strlen+0x10>
 16c:	40a6853b          	subw	a0,a3,a0
 170:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 172:	6422                	ld	s0,8(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret
  for(n = 0; s[n]; n++)
 178:	4501                	li	a0,0
 17a:	bfe5                	j	172 <strlen+0x20>

000000000000017c <memset>:

void*
memset(void *dst, int c, uint n)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 182:	ca19                	beqz	a2,198 <memset+0x1c>
 184:	87aa                	mv	a5,a0
 186:	1602                	slli	a2,a2,0x20
 188:	9201                	srli	a2,a2,0x20
 18a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 18e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 192:	0785                	addi	a5,a5,1
 194:	fee79de3          	bne	a5,a4,18e <memset+0x12>
  }
  return dst;
}
 198:	6422                	ld	s0,8(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret

000000000000019e <strchr>:

char*
strchr(const char *s, char c)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	cb99                	beqz	a5,1be <strchr+0x20>
    if(*s == c)
 1aa:	00f58763          	beq	a1,a5,1b8 <strchr+0x1a>
  for(; *s; s++)
 1ae:	0505                	addi	a0,a0,1
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	fbfd                	bnez	a5,1aa <strchr+0xc>
      return (char*)s;
  return 0;
 1b6:	4501                	li	a0,0
}
 1b8:	6422                	ld	s0,8(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret
  return 0;
 1be:	4501                	li	a0,0
 1c0:	bfe5                	j	1b8 <strchr+0x1a>

00000000000001c2 <gets>:

char*
gets(char *buf, int max)
{
 1c2:	711d                	addi	sp,sp,-96
 1c4:	ec86                	sd	ra,88(sp)
 1c6:	e8a2                	sd	s0,80(sp)
 1c8:	e4a6                	sd	s1,72(sp)
 1ca:	e0ca                	sd	s2,64(sp)
 1cc:	fc4e                	sd	s3,56(sp)
 1ce:	f852                	sd	s4,48(sp)
 1d0:	f456                	sd	s5,40(sp)
 1d2:	f05a                	sd	s6,32(sp)
 1d4:	ec5e                	sd	s7,24(sp)
 1d6:	1080                	addi	s0,sp,96
 1d8:	8baa                	mv	s7,a0
 1da:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1dc:	892a                	mv	s2,a0
 1de:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e0:	4aa9                	li	s5,10
 1e2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1e4:	89a6                	mv	s3,s1
 1e6:	2485                	addiw	s1,s1,1
 1e8:	0344d663          	bge	s1,s4,214 <gets+0x52>
    cc = read(0, &c, 1);
 1ec:	4605                	li	a2,1
 1ee:	faf40593          	addi	a1,s0,-81
 1f2:	4501                	li	a0,0
 1f4:	1b2000ef          	jal	3a6 <read>
    if(cc < 1)
 1f8:	00a05e63          	blez	a0,214 <gets+0x52>
    buf[i++] = c;
 1fc:	faf44783          	lbu	a5,-81(s0)
 200:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 204:	01578763          	beq	a5,s5,212 <gets+0x50>
 208:	0905                	addi	s2,s2,1
 20a:	fd679de3          	bne	a5,s6,1e4 <gets+0x22>
    buf[i++] = c;
 20e:	89a6                	mv	s3,s1
 210:	a011                	j	214 <gets+0x52>
 212:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 214:	99de                	add	s3,s3,s7
 216:	00098023          	sb	zero,0(s3)
  return buf;
}
 21a:	855e                	mv	a0,s7
 21c:	60e6                	ld	ra,88(sp)
 21e:	6446                	ld	s0,80(sp)
 220:	64a6                	ld	s1,72(sp)
 222:	6906                	ld	s2,64(sp)
 224:	79e2                	ld	s3,56(sp)
 226:	7a42                	ld	s4,48(sp)
 228:	7aa2                	ld	s5,40(sp)
 22a:	7b02                	ld	s6,32(sp)
 22c:	6be2                	ld	s7,24(sp)
 22e:	6125                	addi	sp,sp,96
 230:	8082                	ret

0000000000000232 <stat>:

int
stat(const char *n, struct stat *st)
{
 232:	1101                	addi	sp,sp,-32
 234:	ec06                	sd	ra,24(sp)
 236:	e822                	sd	s0,16(sp)
 238:	e04a                	sd	s2,0(sp)
 23a:	1000                	addi	s0,sp,32
 23c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 23e:	4581                	li	a1,0
 240:	18e000ef          	jal	3ce <open>
  if(fd < 0)
 244:	02054263          	bltz	a0,268 <stat+0x36>
 248:	e426                	sd	s1,8(sp)
 24a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 24c:	85ca                	mv	a1,s2
 24e:	198000ef          	jal	3e6 <fstat>
 252:	892a                	mv	s2,a0
  close(fd);
 254:	8526                	mv	a0,s1
 256:	160000ef          	jal	3b6 <close>
  return r;
 25a:	64a2                	ld	s1,8(sp)
}
 25c:	854a                	mv	a0,s2
 25e:	60e2                	ld	ra,24(sp)
 260:	6442                	ld	s0,16(sp)
 262:	6902                	ld	s2,0(sp)
 264:	6105                	addi	sp,sp,32
 266:	8082                	ret
    return -1;
 268:	597d                	li	s2,-1
 26a:	bfcd                	j	25c <stat+0x2a>

000000000000026c <atoi>:

int
atoi(const char *s)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 272:	00054683          	lbu	a3,0(a0)
 276:	fd06879b          	addiw	a5,a3,-48
 27a:	0ff7f793          	zext.b	a5,a5
 27e:	4625                	li	a2,9
 280:	02f66863          	bltu	a2,a5,2b0 <atoi+0x44>
 284:	872a                	mv	a4,a0
  n = 0;
 286:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 288:	0705                	addi	a4,a4,1
 28a:	0025179b          	slliw	a5,a0,0x2
 28e:	9fa9                	addw	a5,a5,a0
 290:	0017979b          	slliw	a5,a5,0x1
 294:	9fb5                	addw	a5,a5,a3
 296:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 29a:	00074683          	lbu	a3,0(a4)
 29e:	fd06879b          	addiw	a5,a3,-48
 2a2:	0ff7f793          	zext.b	a5,a5
 2a6:	fef671e3          	bgeu	a2,a5,288 <atoi+0x1c>
  return n;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  n = 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <atoi+0x3e>

00000000000002b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ba:	02b57463          	bgeu	a0,a1,2e2 <memmove+0x2e>
    while(n-- > 0)
 2be:	00c05f63          	blez	a2,2dc <memmove+0x28>
 2c2:	1602                	slli	a2,a2,0x20
 2c4:	9201                	srli	a2,a2,0x20
 2c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 2cc:	0585                	addi	a1,a1,1
 2ce:	0705                	addi	a4,a4,1
 2d0:	fff5c683          	lbu	a3,-1(a1)
 2d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d8:	fef71ae3          	bne	a4,a5,2cc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
    dst += n;
 2e2:	00c50733          	add	a4,a0,a2
    src += n;
 2e6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e8:	fec05ae3          	blez	a2,2dc <memmove+0x28>
 2ec:	fff6079b          	addiw	a5,a2,-1
 2f0:	1782                	slli	a5,a5,0x20
 2f2:	9381                	srli	a5,a5,0x20
 2f4:	fff7c793          	not	a5,a5
 2f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2fa:	15fd                	addi	a1,a1,-1
 2fc:	177d                	addi	a4,a4,-1
 2fe:	0005c683          	lbu	a3,0(a1)
 302:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 306:	fee79ae3          	bne	a5,a4,2fa <memmove+0x46>
 30a:	bfc9                	j	2dc <memmove+0x28>

000000000000030c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 312:	ca05                	beqz	a2,342 <memcmp+0x36>
 314:	fff6069b          	addiw	a3,a2,-1
 318:	1682                	slli	a3,a3,0x20
 31a:	9281                	srli	a3,a3,0x20
 31c:	0685                	addi	a3,a3,1
 31e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 320:	00054783          	lbu	a5,0(a0)
 324:	0005c703          	lbu	a4,0(a1)
 328:	00e79863          	bne	a5,a4,338 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 32c:	0505                	addi	a0,a0,1
    p2++;
 32e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 330:	fed518e3          	bne	a0,a3,320 <memcmp+0x14>
  }
  return 0;
 334:	4501                	li	a0,0
 336:	a019                	j	33c <memcmp+0x30>
      return *p1 - *p2;
 338:	40e7853b          	subw	a0,a5,a4
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  return 0;
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <memcmp+0x30>

0000000000000346 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34e:	f67ff0ef          	jal	2b4 <memmove>
}
 352:	60a2                	ld	ra,8(sp)
 354:	6402                	ld	s0,0(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <sbrk>:

char *
sbrk(int n) {
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 362:	4585                	li	a1,1
 364:	0b2000ef          	jal	416 <sys_sbrk>
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret

0000000000000370 <sbrklazy>:

char *
sbrklazy(int n) {
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 378:	4589                	li	a1,2
 37a:	09c000ef          	jal	416 <sys_sbrk>
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret

0000000000000386 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 386:	4885                	li	a7,1
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <exit>:
.global exit
exit:
 li a7, SYS_exit
 38e:	4889                	li	a7,2
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <wait>:
.global wait
wait:
 li a7, SYS_wait
 396:	488d                	li	a7,3
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39e:	4891                	li	a7,4
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <read>:
.global read
read:
 li a7, SYS_read
 3a6:	4895                	li	a7,5
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <write>:
.global write
write:
 li a7, SYS_write
 3ae:	48c1                	li	a7,16
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <close>:
.global close
close:
 li a7, SYS_close
 3b6:	48d5                	li	a7,21
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <kill>:
.global kill
kill:
 li a7, SYS_kill
 3be:	4899                	li	a7,6
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c6:	489d                	li	a7,7
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <open>:
.global open
open:
 li a7, SYS_open
 3ce:	48bd                	li	a7,15
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d6:	48c5                	li	a7,17
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3de:	48c9                	li	a7,18
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e6:	48a1                	li	a7,8
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <link>:
.global link
link:
 li a7, SYS_link
 3ee:	48cd                	li	a7,19
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f6:	48d1                	li	a7,20
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fe:	48a5                	li	a7,9
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <dup>:
.global dup
dup:
 li a7, SYS_dup
 406:	48a9                	li	a7,10
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40e:	48ad                	li	a7,11
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 416:	48b1                	li	a7,12
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <pause>:
.global pause
pause:
 li a7, SYS_pause
 41e:	48b5                	li	a7,13
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 426:	48b9                	li	a7,14
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <hello>:
.global hello
hello:
 li a7, SYS_hello
 42e:	48d9                	li	a7,22
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <ps>:
.global ps
ps:
 li a7, SYS_ps
 436:	48dd                	li	a7,23
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <memtest>:
.global memtest
memtest:
 li a7, SYS_memtest
 43e:	48e1                	li	a7,24
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <testnolock>:
.global testnolock
testnolock:
 li a7, SYS_testnolock
 446:	48e5                	li	a7,25
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <testlock>:
.global testlock
testlock:
 li a7, SYS_testlock
 44e:	48e9                	li	a7,26
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <nullcall>:
.global nullcall
nullcall:
 li a7, SYS_nullcall
 456:	48ed                	li	a7,27
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <getcycles>:
.global getcycles
getcycles:
 li a7, SYS_getcycles
 45e:	48f1                	li	a7,28
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 466:	1101                	addi	sp,sp,-32
 468:	ec06                	sd	ra,24(sp)
 46a:	e822                	sd	s0,16(sp)
 46c:	1000                	addi	s0,sp,32
 46e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 472:	4605                	li	a2,1
 474:	fef40593          	addi	a1,s0,-17
 478:	f37ff0ef          	jal	3ae <write>
}
 47c:	60e2                	ld	ra,24(sp)
 47e:	6442                	ld	s0,16(sp)
 480:	6105                	addi	sp,sp,32
 482:	8082                	ret

0000000000000484 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 484:	715d                	addi	sp,sp,-80
 486:	e486                	sd	ra,72(sp)
 488:	e0a2                	sd	s0,64(sp)
 48a:	f84a                	sd	s2,48(sp)
 48c:	0880                	addi	s0,sp,80
 48e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 490:	c299                	beqz	a3,496 <printint+0x12>
 492:	0805c363          	bltz	a1,518 <printint+0x94>
  neg = 0;
 496:	4881                	li	a7,0
 498:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 49c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 49e:	00000517          	auipc	a0,0x0
 4a2:	73a50513          	addi	a0,a0,1850 # bd8 <digits>
 4a6:	883e                	mv	a6,a5
 4a8:	2785                	addiw	a5,a5,1
 4aa:	02c5f733          	remu	a4,a1,a2
 4ae:	972a                	add	a4,a4,a0
 4b0:	00074703          	lbu	a4,0(a4)
 4b4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4b8:	872e                	mv	a4,a1
 4ba:	02c5d5b3          	divu	a1,a1,a2
 4be:	0685                	addi	a3,a3,1
 4c0:	fec773e3          	bgeu	a4,a2,4a6 <printint+0x22>
  if(neg)
 4c4:	00088b63          	beqz	a7,4da <printint+0x56>
    buf[i++] = '-';
 4c8:	fd078793          	addi	a5,a5,-48
 4cc:	97a2                	add	a5,a5,s0
 4ce:	02d00713          	li	a4,45
 4d2:	fee78423          	sb	a4,-24(a5)
 4d6:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 4da:	02f05a63          	blez	a5,50e <printint+0x8a>
 4de:	fc26                	sd	s1,56(sp)
 4e0:	f44e                	sd	s3,40(sp)
 4e2:	fb840713          	addi	a4,s0,-72
 4e6:	00f704b3          	add	s1,a4,a5
 4ea:	fff70993          	addi	s3,a4,-1
 4ee:	99be                	add	s3,s3,a5
 4f0:	37fd                	addiw	a5,a5,-1
 4f2:	1782                	slli	a5,a5,0x20
 4f4:	9381                	srli	a5,a5,0x20
 4f6:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4fa:	fff4c583          	lbu	a1,-1(s1)
 4fe:	854a                	mv	a0,s2
 500:	f67ff0ef          	jal	466 <putc>
  while(--i >= 0)
 504:	14fd                	addi	s1,s1,-1
 506:	ff349ae3          	bne	s1,s3,4fa <printint+0x76>
 50a:	74e2                	ld	s1,56(sp)
 50c:	79a2                	ld	s3,40(sp)
}
 50e:	60a6                	ld	ra,72(sp)
 510:	6406                	ld	s0,64(sp)
 512:	7942                	ld	s2,48(sp)
 514:	6161                	addi	sp,sp,80
 516:	8082                	ret
    x = -xx;
 518:	40b005b3          	neg	a1,a1
    neg = 1;
 51c:	4885                	li	a7,1
    x = -xx;
 51e:	bfad                	j	498 <printint+0x14>

0000000000000520 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 520:	711d                	addi	sp,sp,-96
 522:	ec86                	sd	ra,88(sp)
 524:	e8a2                	sd	s0,80(sp)
 526:	e0ca                	sd	s2,64(sp)
 528:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52a:	0005c903          	lbu	s2,0(a1)
 52e:	28090663          	beqz	s2,7ba <vprintf+0x29a>
 532:	e4a6                	sd	s1,72(sp)
 534:	fc4e                	sd	s3,56(sp)
 536:	f852                	sd	s4,48(sp)
 538:	f456                	sd	s5,40(sp)
 53a:	f05a                	sd	s6,32(sp)
 53c:	ec5e                	sd	s7,24(sp)
 53e:	e862                	sd	s8,16(sp)
 540:	e466                	sd	s9,8(sp)
 542:	8b2a                	mv	s6,a0
 544:	8a2e                	mv	s4,a1
 546:	8bb2                	mv	s7,a2
  state = 0;
 548:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 54a:	4481                	li	s1,0
 54c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 54e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 552:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 556:	06c00c93          	li	s9,108
 55a:	a005                	j	57a <vprintf+0x5a>
        putc(fd, c0);
 55c:	85ca                	mv	a1,s2
 55e:	855a                	mv	a0,s6
 560:	f07ff0ef          	jal	466 <putc>
 564:	a019                	j	56a <vprintf+0x4a>
    } else if(state == '%'){
 566:	03598263          	beq	s3,s5,58a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 56a:	2485                	addiw	s1,s1,1
 56c:	8726                	mv	a4,s1
 56e:	009a07b3          	add	a5,s4,s1
 572:	0007c903          	lbu	s2,0(a5)
 576:	22090a63          	beqz	s2,7aa <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 57a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 57e:	fe0994e3          	bnez	s3,566 <vprintf+0x46>
      if(c0 == '%'){
 582:	fd579de3          	bne	a5,s5,55c <vprintf+0x3c>
        state = '%';
 586:	89be                	mv	s3,a5
 588:	b7cd                	j	56a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 58a:	00ea06b3          	add	a3,s4,a4
 58e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 592:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 594:	c681                	beqz	a3,59c <vprintf+0x7c>
 596:	9752                	add	a4,a4,s4
 598:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 59c:	05878363          	beq	a5,s8,5e2 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5a0:	05978d63          	beq	a5,s9,5fa <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5a4:	07500713          	li	a4,117
 5a8:	0ee78763          	beq	a5,a4,696 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5ac:	07800713          	li	a4,120
 5b0:	12e78963          	beq	a5,a4,6e2 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5b4:	07000713          	li	a4,112
 5b8:	14e78e63          	beq	a5,a4,714 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5bc:	06300713          	li	a4,99
 5c0:	18e78e63          	beq	a5,a4,75c <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5c4:	07300713          	li	a4,115
 5c8:	1ae78463          	beq	a5,a4,770 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5cc:	02500713          	li	a4,37
 5d0:	04e79563          	bne	a5,a4,61a <vprintf+0xfa>
        putc(fd, '%');
 5d4:	02500593          	li	a1,37
 5d8:	855a                	mv	a0,s6
 5da:	e8dff0ef          	jal	466 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b769                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	4685                	li	a3,1
 5e8:	4629                	li	a2,10
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	e95ff0ef          	jal	484 <printint>
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	bf8d                	j	56a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5fa:	06400793          	li	a5,100
 5fe:	02f68963          	beq	a3,a5,630 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 602:	06c00793          	li	a5,108
 606:	04f68263          	beq	a3,a5,64a <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 60a:	07500793          	li	a5,117
 60e:	0af68063          	beq	a3,a5,6ae <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 612:	07800793          	li	a5,120
 616:	0ef68263          	beq	a3,a5,6fa <vprintf+0x1da>
        putc(fd, '%');
 61a:	02500593          	li	a1,37
 61e:	855a                	mv	a0,s6
 620:	e47ff0ef          	jal	466 <putc>
        putc(fd, c0);
 624:	85ca                	mv	a1,s2
 626:	855a                	mv	a0,s6
 628:	e3fff0ef          	jal	466 <putc>
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bf35                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 630:	008b8913          	addi	s2,s7,8
 634:	4685                	li	a3,1
 636:	4629                	li	a2,10
 638:	000bb583          	ld	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	e47ff0ef          	jal	484 <printint>
        i += 1;
 642:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
        i += 1;
 648:	b70d                	j	56a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 64a:	06400793          	li	a5,100
 64e:	02f60763          	beq	a2,a5,67c <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 652:	07500793          	li	a5,117
 656:	06f60963          	beq	a2,a5,6c8 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 65a:	07800793          	li	a5,120
 65e:	faf61ee3          	bne	a2,a5,61a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 662:	008b8913          	addi	s2,s7,8
 666:	4681                	li	a3,0
 668:	4641                	li	a2,16
 66a:	000bb583          	ld	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	e15ff0ef          	jal	484 <printint>
        i += 2;
 674:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
        i += 2;
 67a:	bdc5                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 67c:	008b8913          	addi	s2,s7,8
 680:	4685                	li	a3,1
 682:	4629                	li	a2,10
 684:	000bb583          	ld	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	dfbff0ef          	jal	484 <printint>
        i += 2;
 68e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
        i += 2;
 694:	bdd9                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 696:	008b8913          	addi	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4629                	li	a2,10
 69e:	000be583          	lwu	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	de1ff0ef          	jal	484 <printint>
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bd7d                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ae:	008b8913          	addi	s2,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4629                	li	a2,10
 6b6:	000bb583          	ld	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	dc9ff0ef          	jal	484 <printint>
        i += 1;
 6c0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
        i += 1;
 6c6:	b555                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c8:	008b8913          	addi	s2,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4629                	li	a2,10
 6d0:	000bb583          	ld	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	dafff0ef          	jal	484 <printint>
        i += 2;
 6da:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
        i += 2;
 6e0:	b569                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6e2:	008b8913          	addi	s2,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4641                	li	a2,16
 6ea:	000be583          	lwu	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	d95ff0ef          	jal	484 <printint>
 6f4:	8bca                	mv	s7,s2
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	bd8d                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fa:	008b8913          	addi	s2,s7,8
 6fe:	4681                	li	a3,0
 700:	4641                	li	a2,16
 702:	000bb583          	ld	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	d7dff0ef          	jal	484 <printint>
        i += 1;
 70c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 70e:	8bca                	mv	s7,s2
      state = 0;
 710:	4981                	li	s3,0
        i += 1;
 712:	bda1                	j	56a <vprintf+0x4a>
 714:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 716:	008b8d13          	addi	s10,s7,8
 71a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 71e:	03000593          	li	a1,48
 722:	855a                	mv	a0,s6
 724:	d43ff0ef          	jal	466 <putc>
  putc(fd, 'x');
 728:	07800593          	li	a1,120
 72c:	855a                	mv	a0,s6
 72e:	d39ff0ef          	jal	466 <putc>
 732:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 734:	00000b97          	auipc	s7,0x0
 738:	4a4b8b93          	addi	s7,s7,1188 # bd8 <digits>
 73c:	03c9d793          	srli	a5,s3,0x3c
 740:	97de                	add	a5,a5,s7
 742:	0007c583          	lbu	a1,0(a5)
 746:	855a                	mv	a0,s6
 748:	d1fff0ef          	jal	466 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 74c:	0992                	slli	s3,s3,0x4
 74e:	397d                	addiw	s2,s2,-1
 750:	fe0916e3          	bnez	s2,73c <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 754:	8bea                	mv	s7,s10
      state = 0;
 756:	4981                	li	s3,0
 758:	6d02                	ld	s10,0(sp)
 75a:	bd01                	j	56a <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 75c:	008b8913          	addi	s2,s7,8
 760:	000bc583          	lbu	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	d01ff0ef          	jal	466 <putc>
 76a:	8bca                	mv	s7,s2
      state = 0;
 76c:	4981                	li	s3,0
 76e:	bbf5                	j	56a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 770:	008b8993          	addi	s3,s7,8
 774:	000bb903          	ld	s2,0(s7)
 778:	00090f63          	beqz	s2,796 <vprintf+0x276>
        for(; *s; s++)
 77c:	00094583          	lbu	a1,0(s2)
 780:	c195                	beqz	a1,7a4 <vprintf+0x284>
          putc(fd, *s);
 782:	855a                	mv	a0,s6
 784:	ce3ff0ef          	jal	466 <putc>
        for(; *s; s++)
 788:	0905                	addi	s2,s2,1
 78a:	00094583          	lbu	a1,0(s2)
 78e:	f9f5                	bnez	a1,782 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 790:	8bce                	mv	s7,s3
      state = 0;
 792:	4981                	li	s3,0
 794:	bbd9                	j	56a <vprintf+0x4a>
          s = "(null)";
 796:	00000917          	auipc	s2,0x0
 79a:	43a90913          	addi	s2,s2,1082 # bd0 <malloc+0x32e>
        for(; *s; s++)
 79e:	02800593          	li	a1,40
 7a2:	b7c5                	j	782 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7a4:	8bce                	mv	s7,s3
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	b3c9                	j	56a <vprintf+0x4a>
 7aa:	64a6                	ld	s1,72(sp)
 7ac:	79e2                	ld	s3,56(sp)
 7ae:	7a42                	ld	s4,48(sp)
 7b0:	7aa2                	ld	s5,40(sp)
 7b2:	7b02                	ld	s6,32(sp)
 7b4:	6be2                	ld	s7,24(sp)
 7b6:	6c42                	ld	s8,16(sp)
 7b8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7ba:	60e6                	ld	ra,88(sp)
 7bc:	6446                	ld	s0,80(sp)
 7be:	6906                	ld	s2,64(sp)
 7c0:	6125                	addi	sp,sp,96
 7c2:	8082                	ret

00000000000007c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c4:	715d                	addi	sp,sp,-80
 7c6:	ec06                	sd	ra,24(sp)
 7c8:	e822                	sd	s0,16(sp)
 7ca:	1000                	addi	s0,sp,32
 7cc:	e010                	sd	a2,0(s0)
 7ce:	e414                	sd	a3,8(s0)
 7d0:	e818                	sd	a4,16(s0)
 7d2:	ec1c                	sd	a5,24(s0)
 7d4:	03043023          	sd	a6,32(s0)
 7d8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7dc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e0:	8622                	mv	a2,s0
 7e2:	d3fff0ef          	jal	520 <vprintf>
}
 7e6:	60e2                	ld	ra,24(sp)
 7e8:	6442                	ld	s0,16(sp)
 7ea:	6161                	addi	sp,sp,80
 7ec:	8082                	ret

00000000000007ee <printf>:

void
printf(const char *fmt, ...)
{
 7ee:	711d                	addi	sp,sp,-96
 7f0:	ec06                	sd	ra,24(sp)
 7f2:	e822                	sd	s0,16(sp)
 7f4:	1000                	addi	s0,sp,32
 7f6:	e40c                	sd	a1,8(s0)
 7f8:	e810                	sd	a2,16(s0)
 7fa:	ec14                	sd	a3,24(s0)
 7fc:	f018                	sd	a4,32(s0)
 7fe:	f41c                	sd	a5,40(s0)
 800:	03043823          	sd	a6,48(s0)
 804:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 808:	00840613          	addi	a2,s0,8
 80c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 810:	85aa                	mv	a1,a0
 812:	4505                	li	a0,1
 814:	d0dff0ef          	jal	520 <vprintf>
}
 818:	60e2                	ld	ra,24(sp)
 81a:	6442                	ld	s0,16(sp)
 81c:	6125                	addi	sp,sp,96
 81e:	8082                	ret

0000000000000820 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 820:	1141                	addi	sp,sp,-16
 822:	e422                	sd	s0,8(sp)
 824:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 826:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82a:	00000797          	auipc	a5,0x0
 82e:	7d67b783          	ld	a5,2006(a5) # 1000 <freep>
 832:	a02d                	j	85c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 834:	4618                	lw	a4,8(a2)
 836:	9f2d                	addw	a4,a4,a1
 838:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83c:	6398                	ld	a4,0(a5)
 83e:	6310                	ld	a2,0(a4)
 840:	a83d                	j	87e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 842:	ff852703          	lw	a4,-8(a0)
 846:	9f31                	addw	a4,a4,a2
 848:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 84a:	ff053683          	ld	a3,-16(a0)
 84e:	a091                	j	892 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 850:	6398                	ld	a4,0(a5)
 852:	00e7e463          	bltu	a5,a4,85a <free+0x3a>
 856:	00e6ea63          	bltu	a3,a4,86a <free+0x4a>
{
 85a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85c:	fed7fae3          	bgeu	a5,a3,850 <free+0x30>
 860:	6398                	ld	a4,0(a5)
 862:	00e6e463          	bltu	a3,a4,86a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 866:	fee7eae3          	bltu	a5,a4,85a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 86a:	ff852583          	lw	a1,-8(a0)
 86e:	6390                	ld	a2,0(a5)
 870:	02059813          	slli	a6,a1,0x20
 874:	01c85713          	srli	a4,a6,0x1c
 878:	9736                	add	a4,a4,a3
 87a:	fae60de3          	beq	a2,a4,834 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 87e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 882:	4790                	lw	a2,8(a5)
 884:	02061593          	slli	a1,a2,0x20
 888:	01c5d713          	srli	a4,a1,0x1c
 88c:	973e                	add	a4,a4,a5
 88e:	fae68ae3          	beq	a3,a4,842 <free+0x22>
    p->s.ptr = bp->s.ptr;
 892:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 894:	00000717          	auipc	a4,0x0
 898:	76f73623          	sd	a5,1900(a4) # 1000 <freep>
}
 89c:	6422                	ld	s0,8(sp)
 89e:	0141                	addi	sp,sp,16
 8a0:	8082                	ret

00000000000008a2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a2:	7139                	addi	sp,sp,-64
 8a4:	fc06                	sd	ra,56(sp)
 8a6:	f822                	sd	s0,48(sp)
 8a8:	f426                	sd	s1,40(sp)
 8aa:	ec4e                	sd	s3,24(sp)
 8ac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ae:	02051493          	slli	s1,a0,0x20
 8b2:	9081                	srli	s1,s1,0x20
 8b4:	04bd                	addi	s1,s1,15
 8b6:	8091                	srli	s1,s1,0x4
 8b8:	0014899b          	addiw	s3,s1,1
 8bc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8be:	00000517          	auipc	a0,0x0
 8c2:	74253503          	ld	a0,1858(a0) # 1000 <freep>
 8c6:	c915                	beqz	a0,8fa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ca:	4798                	lw	a4,8(a5)
 8cc:	08977a63          	bgeu	a4,s1,960 <malloc+0xbe>
 8d0:	f04a                	sd	s2,32(sp)
 8d2:	e852                	sd	s4,16(sp)
 8d4:	e456                	sd	s5,8(sp)
 8d6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8d8:	8a4e                	mv	s4,s3
 8da:	0009871b          	sext.w	a4,s3
 8de:	6685                	lui	a3,0x1
 8e0:	00d77363          	bgeu	a4,a3,8e6 <malloc+0x44>
 8e4:	6a05                	lui	s4,0x1
 8e6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ee:	00000917          	auipc	s2,0x0
 8f2:	71290913          	addi	s2,s2,1810 # 1000 <freep>
  if(p == SBRK_ERROR)
 8f6:	5afd                	li	s5,-1
 8f8:	a081                	j	938 <malloc+0x96>
 8fa:	f04a                	sd	s2,32(sp)
 8fc:	e852                	sd	s4,16(sp)
 8fe:	e456                	sd	s5,8(sp)
 900:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 902:	00005797          	auipc	a5,0x5
 906:	70e78793          	addi	a5,a5,1806 # 6010 <base>
 90a:	00000717          	auipc	a4,0x0
 90e:	6ef73b23          	sd	a5,1782(a4) # 1000 <freep>
 912:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 914:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 918:	b7c1                	j	8d8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 91a:	6398                	ld	a4,0(a5)
 91c:	e118                	sd	a4,0(a0)
 91e:	a8a9                	j	978 <malloc+0xd6>
  hp->s.size = nu;
 920:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 924:	0541                	addi	a0,a0,16
 926:	efbff0ef          	jal	820 <free>
  return freep;
 92a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 92e:	c12d                	beqz	a0,990 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 930:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 932:	4798                	lw	a4,8(a5)
 934:	02977263          	bgeu	a4,s1,958 <malloc+0xb6>
    if(p == freep)
 938:	00093703          	ld	a4,0(s2)
 93c:	853e                	mv	a0,a5
 93e:	fef719e3          	bne	a4,a5,930 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 942:	8552                	mv	a0,s4
 944:	a17ff0ef          	jal	35a <sbrk>
  if(p == SBRK_ERROR)
 948:	fd551ce3          	bne	a0,s5,920 <malloc+0x7e>
        return 0;
 94c:	4501                	li	a0,0
 94e:	7902                	ld	s2,32(sp)
 950:	6a42                	ld	s4,16(sp)
 952:	6aa2                	ld	s5,8(sp)
 954:	6b02                	ld	s6,0(sp)
 956:	a03d                	j	984 <malloc+0xe2>
 958:	7902                	ld	s2,32(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 960:	fae48de3          	beq	s1,a4,91a <malloc+0x78>
        p->s.size -= nunits;
 964:	4137073b          	subw	a4,a4,s3
 968:	c798                	sw	a4,8(a5)
        p += p->s.size;
 96a:	02071693          	slli	a3,a4,0x20
 96e:	01c6d713          	srli	a4,a3,0x1c
 972:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 974:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 978:	00000717          	auipc	a4,0x0
 97c:	68a73423          	sd	a0,1672(a4) # 1000 <freep>
      return (void*)(p + 1);
 980:	01078513          	addi	a0,a5,16
  }
}
 984:	70e2                	ld	ra,56(sp)
 986:	7442                	ld	s0,48(sp)
 988:	74a2                	ld	s1,40(sp)
 98a:	69e2                	ld	s3,24(sp)
 98c:	6121                	addi	sp,sp,64
 98e:	8082                	ret
 990:	7902                	ld	s2,32(sp)
 992:	6a42                	ld	s4,16(sp)
 994:	6aa2                	ld	s5,8(sp)
 996:	6b02                	ld	s6,0(sp)
 998:	b7f5                	j	984 <malloc+0xe2>
