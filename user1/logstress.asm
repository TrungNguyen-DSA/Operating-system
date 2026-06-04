
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ=2000 };
  
  for (int i = 1; i < argc; i++){
   0:	4785                	li	a5,1
   2:	0ea7df63          	bge	a5,a0,100 <main+0x100>
{
   6:	7139                	addi	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	0080                	addi	s0,sp,64
  14:	892a                	mv	s2,a0
  16:	89ae                	mv	s3,a1
  for (int i = 1; i < argc; i++){
  18:	4485                	li	s1,1
  1a:	a011                	j	1e <main+0x1e>
  1c:	84be                	mv	s1,a5
    int pid1 = fork();
  1e:	372000ef          	jal	390 <fork>
    if(pid1 < 0){
  22:	00054963          	bltz	a0,34 <main+0x34>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if(pid1 == 0) {
  26:	c11d                	beqz	a0,4c <main+0x4c>
  for (int i = 1; i < argc; i++){
  28:	0014879b          	addiw	a5,s1,1
  2c:	fef918e3          	bne	s2,a5,1c <main+0x1c>
      }
      exit(0);
    }
  }
  int xstatus;
  for(int i = 1; i < argc; i++){
  30:	4905                	li	s2,1
  32:	a04d                	j	d4 <main+0xd4>
  34:	e852                	sd	s4,16(sp)
      printf("%s: fork failed\n", argv[0]);
  36:	0009b583          	ld	a1,0(s3)
  3a:	00001517          	auipc	a0,0x1
  3e:	97650513          	addi	a0,a0,-1674 # 9b0 <malloc+0x104>
  42:	7b6000ef          	jal	7f8 <printf>
      exit(1);
  46:	4505                	li	a0,1
  48:	350000ef          	jal	398 <exit>
  4c:	e852                	sd	s4,16(sp)
      fd = open(argv[i], O_CREATE | O_RDWR);
  4e:	00349a13          	slli	s4,s1,0x3
  52:	9a4e                	add	s4,s4,s3
  54:	20200593          	li	a1,514
  58:	000a3503          	ld	a0,0(s4)
  5c:	37c000ef          	jal	3d8 <open>
  60:	892a                	mv	s2,a0
      if(fd < 0){
  62:	04054163          	bltz	a0,a4 <main+0xa4>
      memset(buf, '0'+i, SZ);
  66:	7d000613          	li	a2,2000
  6a:	0304859b          	addiw	a1,s1,48
  6e:	00001517          	auipc	a0,0x1
  72:	fa250513          	addi	a0,a0,-94 # 1010 <buf>
  76:	110000ef          	jal	186 <memset>
  7a:	0fa00493          	li	s1,250
        if((n = write(fd, buf, SZ)) != SZ){
  7e:	00001997          	auipc	s3,0x1
  82:	f9298993          	addi	s3,s3,-110 # 1010 <buf>
  86:	7d000613          	li	a2,2000
  8a:	85ce                	mv	a1,s3
  8c:	854a                	mv	a0,s2
  8e:	32a000ef          	jal	3b8 <write>
  92:	7d000793          	li	a5,2000
  96:	02f51463          	bne	a0,a5,be <main+0xbe>
      for(i = 0; i < N; i++){
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f4ed                	bnez	s1,86 <main+0x86>
      exit(0);
  9e:	4501                	li	a0,0
  a0:	2f8000ef          	jal	398 <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a4:	000a3603          	ld	a2,0(s4)
  a8:	0009b583          	ld	a1,0(s3)
  ac:	00001517          	auipc	a0,0x1
  b0:	91c50513          	addi	a0,a0,-1764 # 9c8 <malloc+0x11c>
  b4:	744000ef          	jal	7f8 <printf>
        exit(1);
  b8:	4505                	li	a0,1
  ba:	2de000ef          	jal	398 <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
  c4:	92050513          	addi	a0,a0,-1760 # 9e0 <malloc+0x134>
  c8:	730000ef          	jal	7f8 <printf>
          exit(1);
  cc:	4505                	li	a0,1
  ce:	2ca000ef          	jal	398 <exit>
  d2:	893e                	mv	s2,a5
    wait(&xstatus);
  d4:	fcc40513          	addi	a0,s0,-52
  d8:	2c8000ef          	jal	3a0 <wait>
    if(xstatus != 0)
  dc:	fcc42503          	lw	a0,-52(s0)
  e0:	ed09                	bnez	a0,fa <main+0xfa>
  for(int i = 1; i < argc; i++){
  e2:	0019079b          	addiw	a5,s2,1
  e6:	ff2496e3          	bne	s1,s2,d2 <main+0xd2>
      exit(xstatus);
  }
  return 0;
}
  ea:	4501                	li	a0,0
  ec:	70e2                	ld	ra,56(sp)
  ee:	7442                	ld	s0,48(sp)
  f0:	74a2                	ld	s1,40(sp)
  f2:	7902                	ld	s2,32(sp)
  f4:	69e2                	ld	s3,24(sp)
  f6:	6121                	addi	sp,sp,64
  f8:	8082                	ret
  fa:	e852                	sd	s4,16(sp)
      exit(xstatus);
  fc:	29c000ef          	jal	398 <exit>
}
 100:	4501                	li	a0,0
 102:	8082                	ret

0000000000000104 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 10c:	ef5ff0ef          	jal	0 <main>
  exit(r);
 110:	288000ef          	jal	398 <exit>

0000000000000114 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	addi	a1,a1,1
 11e:	0785                	addi	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0x8>
    ;
  return os;
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cb91                	beqz	a5,14e <strcmp+0x1e>
 13c:	0005c703          	lbu	a4,0(a1)
 140:	00f71763          	bne	a4,a5,14e <strcmp+0x1e>
    p++, q++;
 144:	0505                	addi	a0,a0,1
 146:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	fbe5                	bnez	a5,13c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14e:	0005c503          	lbu	a0,0(a1)
}
 152:	40a7853b          	subw	a0,a5,a0
 156:	6422                	ld	s0,8(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret

000000000000015c <strlen>:

uint
strlen(const char *s)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 162:	00054783          	lbu	a5,0(a0)
 166:	cf91                	beqz	a5,182 <strlen+0x26>
 168:	0505                	addi	a0,a0,1
 16a:	87aa                	mv	a5,a0
 16c:	86be                	mv	a3,a5
 16e:	0785                	addi	a5,a5,1
 170:	fff7c703          	lbu	a4,-1(a5)
 174:	ff65                	bnez	a4,16c <strlen+0x10>
 176:	40a6853b          	subw	a0,a3,a0
 17a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret
  for(n = 0; s[n]; n++)
 182:	4501                	li	a0,0
 184:	bfe5                	j	17c <strlen+0x20>

0000000000000186 <memset>:

void*
memset(void *dst, int c, uint n)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18c:	ca19                	beqz	a2,1a2 <memset+0x1c>
 18e:	87aa                	mv	a5,a0
 190:	1602                	slli	a2,a2,0x20
 192:	9201                	srli	a2,a2,0x20
 194:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 198:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19c:	0785                	addi	a5,a5,1
 19e:	fee79de3          	bne	a5,a4,198 <memset+0x12>
  }
  return dst;
}
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strchr>:

char*
strchr(const char *s, char c)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	cb99                	beqz	a5,1c8 <strchr+0x20>
    if(*s == c)
 1b4:	00f58763          	beq	a1,a5,1c2 <strchr+0x1a>
  for(; *s; s++)
 1b8:	0505                	addi	a0,a0,1
 1ba:	00054783          	lbu	a5,0(a0)
 1be:	fbfd                	bnez	a5,1b4 <strchr+0xc>
      return (char*)s;
  return 0;
 1c0:	4501                	li	a0,0
}
 1c2:	6422                	ld	s0,8(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret
  return 0;
 1c8:	4501                	li	a0,0
 1ca:	bfe5                	j	1c2 <strchr+0x1a>

00000000000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	711d                	addi	sp,sp,-96
 1ce:	ec86                	sd	ra,88(sp)
 1d0:	e8a2                	sd	s0,80(sp)
 1d2:	e4a6                	sd	s1,72(sp)
 1d4:	e0ca                	sd	s2,64(sp)
 1d6:	fc4e                	sd	s3,56(sp)
 1d8:	f852                	sd	s4,48(sp)
 1da:	f456                	sd	s5,40(sp)
 1dc:	f05a                	sd	s6,32(sp)
 1de:	ec5e                	sd	s7,24(sp)
 1e0:	1080                	addi	s0,sp,96
 1e2:	8baa                	mv	s7,a0
 1e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	892a                	mv	s2,a0
 1e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ea:	4aa9                	li	s5,10
 1ec:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ee:	89a6                	mv	s3,s1
 1f0:	2485                	addiw	s1,s1,1
 1f2:	0344d663          	bge	s1,s4,21e <gets+0x52>
    cc = read(0, &c, 1);
 1f6:	4605                	li	a2,1
 1f8:	faf40593          	addi	a1,s0,-81
 1fc:	4501                	li	a0,0
 1fe:	1b2000ef          	jal	3b0 <read>
    if(cc < 1)
 202:	00a05e63          	blez	a0,21e <gets+0x52>
    buf[i++] = c;
 206:	faf44783          	lbu	a5,-81(s0)
 20a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20e:	01578763          	beq	a5,s5,21c <gets+0x50>
 212:	0905                	addi	s2,s2,1
 214:	fd679de3          	bne	a5,s6,1ee <gets+0x22>
    buf[i++] = c;
 218:	89a6                	mv	s3,s1
 21a:	a011                	j	21e <gets+0x52>
 21c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21e:	99de                	add	s3,s3,s7
 220:	00098023          	sb	zero,0(s3)
  return buf;
}
 224:	855e                	mv	a0,s7
 226:	60e6                	ld	ra,88(sp)
 228:	6446                	ld	s0,80(sp)
 22a:	64a6                	ld	s1,72(sp)
 22c:	6906                	ld	s2,64(sp)
 22e:	79e2                	ld	s3,56(sp)
 230:	7a42                	ld	s4,48(sp)
 232:	7aa2                	ld	s5,40(sp)
 234:	7b02                	ld	s6,32(sp)
 236:	6be2                	ld	s7,24(sp)
 238:	6125                	addi	sp,sp,96
 23a:	8082                	ret

000000000000023c <stat>:

int
stat(const char *n, struct stat *st)
{
 23c:	1101                	addi	sp,sp,-32
 23e:	ec06                	sd	ra,24(sp)
 240:	e822                	sd	s0,16(sp)
 242:	e04a                	sd	s2,0(sp)
 244:	1000                	addi	s0,sp,32
 246:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 248:	4581                	li	a1,0
 24a:	18e000ef          	jal	3d8 <open>
  if(fd < 0)
 24e:	02054263          	bltz	a0,272 <stat+0x36>
 252:	e426                	sd	s1,8(sp)
 254:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 256:	85ca                	mv	a1,s2
 258:	198000ef          	jal	3f0 <fstat>
 25c:	892a                	mv	s2,a0
  close(fd);
 25e:	8526                	mv	a0,s1
 260:	160000ef          	jal	3c0 <close>
  return r;
 264:	64a2                	ld	s1,8(sp)
}
 266:	854a                	mv	a0,s2
 268:	60e2                	ld	ra,24(sp)
 26a:	6442                	ld	s0,16(sp)
 26c:	6902                	ld	s2,0(sp)
 26e:	6105                	addi	sp,sp,32
 270:	8082                	ret
    return -1;
 272:	597d                	li	s2,-1
 274:	bfcd                	j	266 <stat+0x2a>

0000000000000276 <atoi>:

int
atoi(const char *s)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27c:	00054683          	lbu	a3,0(a0)
 280:	fd06879b          	addiw	a5,a3,-48
 284:	0ff7f793          	zext.b	a5,a5
 288:	4625                	li	a2,9
 28a:	02f66863          	bltu	a2,a5,2ba <atoi+0x44>
 28e:	872a                	mv	a4,a0
  n = 0;
 290:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 292:	0705                	addi	a4,a4,1
 294:	0025179b          	slliw	a5,a0,0x2
 298:	9fa9                	addw	a5,a5,a0
 29a:	0017979b          	slliw	a5,a5,0x1
 29e:	9fb5                	addw	a5,a5,a3
 2a0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a4:	00074683          	lbu	a3,0(a4)
 2a8:	fd06879b          	addiw	a5,a3,-48
 2ac:	0ff7f793          	zext.b	a5,a5
 2b0:	fef671e3          	bgeu	a2,a5,292 <atoi+0x1c>
  return n;
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret
  n = 0;
 2ba:	4501                	li	a0,0
 2bc:	bfe5                	j	2b4 <atoi+0x3e>

00000000000002be <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c4:	02b57463          	bgeu	a0,a1,2ec <memmove+0x2e>
    while(n-- > 0)
 2c8:	00c05f63          	blez	a2,2e6 <memmove+0x28>
 2cc:	1602                	slli	a2,a2,0x20
 2ce:	9201                	srli	a2,a2,0x20
 2d0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d6:	0585                	addi	a1,a1,1
 2d8:	0705                	addi	a4,a4,1
 2da:	fff5c683          	lbu	a3,-1(a1)
 2de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e2:	fef71ae3          	bne	a4,a5,2d6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
    dst += n;
 2ec:	00c50733          	add	a4,a0,a2
    src += n;
 2f0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2f2:	fec05ae3          	blez	a2,2e6 <memmove+0x28>
 2f6:	fff6079b          	addiw	a5,a2,-1
 2fa:	1782                	slli	a5,a5,0x20
 2fc:	9381                	srli	a5,a5,0x20
 2fe:	fff7c793          	not	a5,a5
 302:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 304:	15fd                	addi	a1,a1,-1
 306:	177d                	addi	a4,a4,-1
 308:	0005c683          	lbu	a3,0(a1)
 30c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 310:	fee79ae3          	bne	a5,a4,304 <memmove+0x46>
 314:	bfc9                	j	2e6 <memmove+0x28>

0000000000000316 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 316:	1141                	addi	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31c:	ca05                	beqz	a2,34c <memcmp+0x36>
 31e:	fff6069b          	addiw	a3,a2,-1
 322:	1682                	slli	a3,a3,0x20
 324:	9281                	srli	a3,a3,0x20
 326:	0685                	addi	a3,a3,1
 328:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 32a:	00054783          	lbu	a5,0(a0)
 32e:	0005c703          	lbu	a4,0(a1)
 332:	00e79863          	bne	a5,a4,342 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 336:	0505                	addi	a0,a0,1
    p2++;
 338:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33a:	fed518e3          	bne	a0,a3,32a <memcmp+0x14>
  }
  return 0;
 33e:	4501                	li	a0,0
 340:	a019                	j	346 <memcmp+0x30>
      return *p1 - *p2;
 342:	40e7853b          	subw	a0,a5,a4
}
 346:	6422                	ld	s0,8(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret
  return 0;
 34c:	4501                	li	a0,0
 34e:	bfe5                	j	346 <memcmp+0x30>

0000000000000350 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 350:	1141                	addi	sp,sp,-16
 352:	e406                	sd	ra,8(sp)
 354:	e022                	sd	s0,0(sp)
 356:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 358:	f67ff0ef          	jal	2be <memmove>
}
 35c:	60a2                	ld	ra,8(sp)
 35e:	6402                	ld	s0,0(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret

0000000000000364 <sbrk>:

char *
sbrk(int n) {
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 36c:	4585                	li	a1,1
 36e:	0b2000ef          	jal	420 <sys_sbrk>
}
 372:	60a2                	ld	ra,8(sp)
 374:	6402                	ld	s0,0(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret

000000000000037a <sbrklazy>:

char *
sbrklazy(int n) {
 37a:	1141                	addi	sp,sp,-16
 37c:	e406                	sd	ra,8(sp)
 37e:	e022                	sd	s0,0(sp)
 380:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 382:	4589                	li	a1,2
 384:	09c000ef          	jal	420 <sys_sbrk>
}
 388:	60a2                	ld	ra,8(sp)
 38a:	6402                	ld	s0,0(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret

0000000000000390 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 390:	4885                	li	a7,1
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <exit>:
.global exit
exit:
 li a7, SYS_exit
 398:	4889                	li	a7,2
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a0:	488d                	li	a7,3
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a8:	4891                	li	a7,4
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <read>:
.global read
read:
 li a7, SYS_read
 3b0:	4895                	li	a7,5
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <write>:
.global write
write:
 li a7, SYS_write
 3b8:	48c1                	li	a7,16
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <close>:
.global close
close:
 li a7, SYS_close
 3c0:	48d5                	li	a7,21
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c8:	4899                	li	a7,6
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d0:	489d                	li	a7,7
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <open>:
.global open
open:
 li a7, SYS_open
 3d8:	48bd                	li	a7,15
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e0:	48c5                	li	a7,17
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e8:	48c9                	li	a7,18
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f0:	48a1                	li	a7,8
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <link>:
.global link
link:
 li a7, SYS_link
 3f8:	48cd                	li	a7,19
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 400:	48d1                	li	a7,20
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 408:	48a5                	li	a7,9
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <dup>:
.global dup
dup:
 li a7, SYS_dup
 410:	48a9                	li	a7,10
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 418:	48ad                	li	a7,11
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 420:	48b1                	li	a7,12
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <pause>:
.global pause
pause:
 li a7, SYS_pause
 428:	48b5                	li	a7,13
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 430:	48b9                	li	a7,14
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <hello>:
.global hello
hello:
 li a7, SYS_hello
 438:	48d9                	li	a7,22
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <ps>:
.global ps
ps:
 li a7, SYS_ps
 440:	48dd                	li	a7,23
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <memtest>:
.global memtest
memtest:
 li a7, SYS_memtest
 448:	48e1                	li	a7,24
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <testnolock>:
.global testnolock
testnolock:
 li a7, SYS_testnolock
 450:	48e5                	li	a7,25
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <testlock>:
.global testlock
testlock:
 li a7, SYS_testlock
 458:	48e9                	li	a7,26
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <nullcall>:
.global nullcall
nullcall:
 li a7, SYS_nullcall
 460:	48ed                	li	a7,27
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <getcycles>:
.global getcycles
getcycles:
 li a7, SYS_getcycles
 468:	48f1                	li	a7,28
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 470:	1101                	addi	sp,sp,-32
 472:	ec06                	sd	ra,24(sp)
 474:	e822                	sd	s0,16(sp)
 476:	1000                	addi	s0,sp,32
 478:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47c:	4605                	li	a2,1
 47e:	fef40593          	addi	a1,s0,-17
 482:	f37ff0ef          	jal	3b8 <write>
}
 486:	60e2                	ld	ra,24(sp)
 488:	6442                	ld	s0,16(sp)
 48a:	6105                	addi	sp,sp,32
 48c:	8082                	ret

000000000000048e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 48e:	715d                	addi	sp,sp,-80
 490:	e486                	sd	ra,72(sp)
 492:	e0a2                	sd	s0,64(sp)
 494:	f84a                	sd	s2,48(sp)
 496:	0880                	addi	s0,sp,80
 498:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 49a:	c299                	beqz	a3,4a0 <printint+0x12>
 49c:	0805c363          	bltz	a1,522 <printint+0x94>
  neg = 0;
 4a0:	4881                	li	a7,0
 4a2:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4a6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4a8:	00000517          	auipc	a0,0x0
 4ac:	55850513          	addi	a0,a0,1368 # a00 <digits>
 4b0:	883e                	mv	a6,a5
 4b2:	2785                	addiw	a5,a5,1
 4b4:	02c5f733          	remu	a4,a1,a2
 4b8:	972a                	add	a4,a4,a0
 4ba:	00074703          	lbu	a4,0(a4)
 4be:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4c2:	872e                	mv	a4,a1
 4c4:	02c5d5b3          	divu	a1,a1,a2
 4c8:	0685                	addi	a3,a3,1
 4ca:	fec773e3          	bgeu	a4,a2,4b0 <printint+0x22>
  if(neg)
 4ce:	00088b63          	beqz	a7,4e4 <printint+0x56>
    buf[i++] = '-';
 4d2:	fd078793          	addi	a5,a5,-48
 4d6:	97a2                	add	a5,a5,s0
 4d8:	02d00713          	li	a4,45
 4dc:	fee78423          	sb	a4,-24(a5)
 4e0:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 4e4:	02f05a63          	blez	a5,518 <printint+0x8a>
 4e8:	fc26                	sd	s1,56(sp)
 4ea:	f44e                	sd	s3,40(sp)
 4ec:	fb840713          	addi	a4,s0,-72
 4f0:	00f704b3          	add	s1,a4,a5
 4f4:	fff70993          	addi	s3,a4,-1
 4f8:	99be                	add	s3,s3,a5
 4fa:	37fd                	addiw	a5,a5,-1
 4fc:	1782                	slli	a5,a5,0x20
 4fe:	9381                	srli	a5,a5,0x20
 500:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 504:	fff4c583          	lbu	a1,-1(s1)
 508:	854a                	mv	a0,s2
 50a:	f67ff0ef          	jal	470 <putc>
  while(--i >= 0)
 50e:	14fd                	addi	s1,s1,-1
 510:	ff349ae3          	bne	s1,s3,504 <printint+0x76>
 514:	74e2                	ld	s1,56(sp)
 516:	79a2                	ld	s3,40(sp)
}
 518:	60a6                	ld	ra,72(sp)
 51a:	6406                	ld	s0,64(sp)
 51c:	7942                	ld	s2,48(sp)
 51e:	6161                	addi	sp,sp,80
 520:	8082                	ret
    x = -xx;
 522:	40b005b3          	neg	a1,a1
    neg = 1;
 526:	4885                	li	a7,1
    x = -xx;
 528:	bfad                	j	4a2 <printint+0x14>

000000000000052a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52a:	711d                	addi	sp,sp,-96
 52c:	ec86                	sd	ra,88(sp)
 52e:	e8a2                	sd	s0,80(sp)
 530:	e0ca                	sd	s2,64(sp)
 532:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 534:	0005c903          	lbu	s2,0(a1)
 538:	28090663          	beqz	s2,7c4 <vprintf+0x29a>
 53c:	e4a6                	sd	s1,72(sp)
 53e:	fc4e                	sd	s3,56(sp)
 540:	f852                	sd	s4,48(sp)
 542:	f456                	sd	s5,40(sp)
 544:	f05a                	sd	s6,32(sp)
 546:	ec5e                	sd	s7,24(sp)
 548:	e862                	sd	s8,16(sp)
 54a:	e466                	sd	s9,8(sp)
 54c:	8b2a                	mv	s6,a0
 54e:	8a2e                	mv	s4,a1
 550:	8bb2                	mv	s7,a2
  state = 0;
 552:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 554:	4481                	li	s1,0
 556:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 558:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 55c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 560:	06c00c93          	li	s9,108
 564:	a005                	j	584 <vprintf+0x5a>
        putc(fd, c0);
 566:	85ca                	mv	a1,s2
 568:	855a                	mv	a0,s6
 56a:	f07ff0ef          	jal	470 <putc>
 56e:	a019                	j	574 <vprintf+0x4a>
    } else if(state == '%'){
 570:	03598263          	beq	s3,s5,594 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 574:	2485                	addiw	s1,s1,1
 576:	8726                	mv	a4,s1
 578:	009a07b3          	add	a5,s4,s1
 57c:	0007c903          	lbu	s2,0(a5)
 580:	22090a63          	beqz	s2,7b4 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 584:	0009079b          	sext.w	a5,s2
    if(state == 0){
 588:	fe0994e3          	bnez	s3,570 <vprintf+0x46>
      if(c0 == '%'){
 58c:	fd579de3          	bne	a5,s5,566 <vprintf+0x3c>
        state = '%';
 590:	89be                	mv	s3,a5
 592:	b7cd                	j	574 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 594:	00ea06b3          	add	a3,s4,a4
 598:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 59c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 59e:	c681                	beqz	a3,5a6 <vprintf+0x7c>
 5a0:	9752                	add	a4,a4,s4
 5a2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5a6:	05878363          	beq	a5,s8,5ec <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5aa:	05978d63          	beq	a5,s9,604 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5ae:	07500713          	li	a4,117
 5b2:	0ee78763          	beq	a5,a4,6a0 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5b6:	07800713          	li	a4,120
 5ba:	12e78963          	beq	a5,a4,6ec <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5be:	07000713          	li	a4,112
 5c2:	14e78e63          	beq	a5,a4,71e <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5c6:	06300713          	li	a4,99
 5ca:	18e78e63          	beq	a5,a4,766 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5ce:	07300713          	li	a4,115
 5d2:	1ae78463          	beq	a5,a4,77a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5d6:	02500713          	li	a4,37
 5da:	04e79563          	bne	a5,a4,624 <vprintf+0xfa>
        putc(fd, '%');
 5de:	02500593          	li	a1,37
 5e2:	855a                	mv	a0,s6
 5e4:	e8dff0ef          	jal	470 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	b769                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4685                	li	a3,1
 5f2:	4629                	li	a2,10
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	e95ff0ef          	jal	48e <printint>
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	bf8d                	j	574 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 604:	06400793          	li	a5,100
 608:	02f68963          	beq	a3,a5,63a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 60c:	06c00793          	li	a5,108
 610:	04f68263          	beq	a3,a5,654 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 614:	07500793          	li	a5,117
 618:	0af68063          	beq	a3,a5,6b8 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 61c:	07800793          	li	a5,120
 620:	0ef68263          	beq	a3,a5,704 <vprintf+0x1da>
        putc(fd, '%');
 624:	02500593          	li	a1,37
 628:	855a                	mv	a0,s6
 62a:	e47ff0ef          	jal	470 <putc>
        putc(fd, c0);
 62e:	85ca                	mv	a1,s2
 630:	855a                	mv	a0,s6
 632:	e3fff0ef          	jal	470 <putc>
      state = 0;
 636:	4981                	li	s3,0
 638:	bf35                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4685                	li	a3,1
 640:	4629                	li	a2,10
 642:	000bb583          	ld	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	e47ff0ef          	jal	48e <printint>
        i += 1;
 64c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
        i += 1;
 652:	b70d                	j	574 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 654:	06400793          	li	a5,100
 658:	02f60763          	beq	a2,a5,686 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 65c:	07500793          	li	a5,117
 660:	06f60963          	beq	a2,a5,6d2 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 664:	07800793          	li	a5,120
 668:	faf61ee3          	bne	a2,a5,624 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66c:	008b8913          	addi	s2,s7,8
 670:	4681                	li	a3,0
 672:	4641                	li	a2,16
 674:	000bb583          	ld	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	e15ff0ef          	jal	48e <printint>
        i += 2;
 67e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
        i += 2;
 684:	bdc5                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 686:	008b8913          	addi	s2,s7,8
 68a:	4685                	li	a3,1
 68c:	4629                	li	a2,10
 68e:	000bb583          	ld	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	dfbff0ef          	jal	48e <printint>
        i += 2;
 698:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
        i += 2;
 69e:	bdd9                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6a0:	008b8913          	addi	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4629                	li	a2,10
 6a8:	000be583          	lwu	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	de1ff0ef          	jal	48e <printint>
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	bd7d                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	4681                	li	a3,0
 6be:	4629                	li	a2,10
 6c0:	000bb583          	ld	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	dc9ff0ef          	jal	48e <printint>
        i += 1;
 6ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
        i += 1;
 6d0:	b555                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d2:	008b8913          	addi	s2,s7,8
 6d6:	4681                	li	a3,0
 6d8:	4629                	li	a2,10
 6da:	000bb583          	ld	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	dafff0ef          	jal	48e <printint>
        i += 2;
 6e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e6:	8bca                	mv	s7,s2
      state = 0;
 6e8:	4981                	li	s3,0
        i += 2;
 6ea:	b569                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6ec:	008b8913          	addi	s2,s7,8
 6f0:	4681                	li	a3,0
 6f2:	4641                	li	a2,16
 6f4:	000be583          	lwu	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	d95ff0ef          	jal	48e <printint>
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
 702:	bd8d                	j	574 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 704:	008b8913          	addi	s2,s7,8
 708:	4681                	li	a3,0
 70a:	4641                	li	a2,16
 70c:	000bb583          	ld	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	d7dff0ef          	jal	48e <printint>
        i += 1;
 716:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 718:	8bca                	mv	s7,s2
      state = 0;
 71a:	4981                	li	s3,0
        i += 1;
 71c:	bda1                	j	574 <vprintf+0x4a>
 71e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 720:	008b8d13          	addi	s10,s7,8
 724:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 728:	03000593          	li	a1,48
 72c:	855a                	mv	a0,s6
 72e:	d43ff0ef          	jal	470 <putc>
  putc(fd, 'x');
 732:	07800593          	li	a1,120
 736:	855a                	mv	a0,s6
 738:	d39ff0ef          	jal	470 <putc>
 73c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73e:	00000b97          	auipc	s7,0x0
 742:	2c2b8b93          	addi	s7,s7,706 # a00 <digits>
 746:	03c9d793          	srli	a5,s3,0x3c
 74a:	97de                	add	a5,a5,s7
 74c:	0007c583          	lbu	a1,0(a5)
 750:	855a                	mv	a0,s6
 752:	d1fff0ef          	jal	470 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 756:	0992                	slli	s3,s3,0x4
 758:	397d                	addiw	s2,s2,-1
 75a:	fe0916e3          	bnez	s2,746 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 75e:	8bea                	mv	s7,s10
      state = 0;
 760:	4981                	li	s3,0
 762:	6d02                	ld	s10,0(sp)
 764:	bd01                	j	574 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 766:	008b8913          	addi	s2,s7,8
 76a:	000bc583          	lbu	a1,0(s7)
 76e:	855a                	mv	a0,s6
 770:	d01ff0ef          	jal	470 <putc>
 774:	8bca                	mv	s7,s2
      state = 0;
 776:	4981                	li	s3,0
 778:	bbf5                	j	574 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 77a:	008b8993          	addi	s3,s7,8
 77e:	000bb903          	ld	s2,0(s7)
 782:	00090f63          	beqz	s2,7a0 <vprintf+0x276>
        for(; *s; s++)
 786:	00094583          	lbu	a1,0(s2)
 78a:	c195                	beqz	a1,7ae <vprintf+0x284>
          putc(fd, *s);
 78c:	855a                	mv	a0,s6
 78e:	ce3ff0ef          	jal	470 <putc>
        for(; *s; s++)
 792:	0905                	addi	s2,s2,1
 794:	00094583          	lbu	a1,0(s2)
 798:	f9f5                	bnez	a1,78c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 79a:	8bce                	mv	s7,s3
      state = 0;
 79c:	4981                	li	s3,0
 79e:	bbd9                	j	574 <vprintf+0x4a>
          s = "(null)";
 7a0:	00000917          	auipc	s2,0x0
 7a4:	25890913          	addi	s2,s2,600 # 9f8 <malloc+0x14c>
        for(; *s; s++)
 7a8:	02800593          	li	a1,40
 7ac:	b7c5                	j	78c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7ae:	8bce                	mv	s7,s3
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b3c9                	j	574 <vprintf+0x4a>
 7b4:	64a6                	ld	s1,72(sp)
 7b6:	79e2                	ld	s3,56(sp)
 7b8:	7a42                	ld	s4,48(sp)
 7ba:	7aa2                	ld	s5,40(sp)
 7bc:	7b02                	ld	s6,32(sp)
 7be:	6be2                	ld	s7,24(sp)
 7c0:	6c42                	ld	s8,16(sp)
 7c2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7c4:	60e6                	ld	ra,88(sp)
 7c6:	6446                	ld	s0,80(sp)
 7c8:	6906                	ld	s2,64(sp)
 7ca:	6125                	addi	sp,sp,96
 7cc:	8082                	ret

00000000000007ce <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ce:	715d                	addi	sp,sp,-80
 7d0:	ec06                	sd	ra,24(sp)
 7d2:	e822                	sd	s0,16(sp)
 7d4:	1000                	addi	s0,sp,32
 7d6:	e010                	sd	a2,0(s0)
 7d8:	e414                	sd	a3,8(s0)
 7da:	e818                	sd	a4,16(s0)
 7dc:	ec1c                	sd	a5,24(s0)
 7de:	03043023          	sd	a6,32(s0)
 7e2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ea:	8622                	mv	a2,s0
 7ec:	d3fff0ef          	jal	52a <vprintf>
}
 7f0:	60e2                	ld	ra,24(sp)
 7f2:	6442                	ld	s0,16(sp)
 7f4:	6161                	addi	sp,sp,80
 7f6:	8082                	ret

00000000000007f8 <printf>:

void
printf(const char *fmt, ...)
{
 7f8:	711d                	addi	sp,sp,-96
 7fa:	ec06                	sd	ra,24(sp)
 7fc:	e822                	sd	s0,16(sp)
 7fe:	1000                	addi	s0,sp,32
 800:	e40c                	sd	a1,8(s0)
 802:	e810                	sd	a2,16(s0)
 804:	ec14                	sd	a3,24(s0)
 806:	f018                	sd	a4,32(s0)
 808:	f41c                	sd	a5,40(s0)
 80a:	03043823          	sd	a6,48(s0)
 80e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 812:	00840613          	addi	a2,s0,8
 816:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 81a:	85aa                	mv	a1,a0
 81c:	4505                	li	a0,1
 81e:	d0dff0ef          	jal	52a <vprintf>
}
 822:	60e2                	ld	ra,24(sp)
 824:	6442                	ld	s0,16(sp)
 826:	6125                	addi	sp,sp,96
 828:	8082                	ret

000000000000082a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 82a:	1141                	addi	sp,sp,-16
 82c:	e422                	sd	s0,8(sp)
 82e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 830:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	00000797          	auipc	a5,0x0
 838:	7cc7b783          	ld	a5,1996(a5) # 1000 <freep>
 83c:	a02d                	j	866 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 83e:	4618                	lw	a4,8(a2)
 840:	9f2d                	addw	a4,a4,a1
 842:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	6398                	ld	a4,0(a5)
 848:	6310                	ld	a2,0(a4)
 84a:	a83d                	j	888 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 84c:	ff852703          	lw	a4,-8(a0)
 850:	9f31                	addw	a4,a4,a2
 852:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 854:	ff053683          	ld	a3,-16(a0)
 858:	a091                	j	89c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85a:	6398                	ld	a4,0(a5)
 85c:	00e7e463          	bltu	a5,a4,864 <free+0x3a>
 860:	00e6ea63          	bltu	a3,a4,874 <free+0x4a>
{
 864:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 866:	fed7fae3          	bgeu	a5,a3,85a <free+0x30>
 86a:	6398                	ld	a4,0(a5)
 86c:	00e6e463          	bltu	a3,a4,874 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 870:	fee7eae3          	bltu	a5,a4,864 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 874:	ff852583          	lw	a1,-8(a0)
 878:	6390                	ld	a2,0(a5)
 87a:	02059813          	slli	a6,a1,0x20
 87e:	01c85713          	srli	a4,a6,0x1c
 882:	9736                	add	a4,a4,a3
 884:	fae60de3          	beq	a2,a4,83e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 888:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 88c:	4790                	lw	a2,8(a5)
 88e:	02061593          	slli	a1,a2,0x20
 892:	01c5d713          	srli	a4,a1,0x1c
 896:	973e                	add	a4,a4,a5
 898:	fae68ae3          	beq	a3,a4,84c <free+0x22>
    p->s.ptr = bp->s.ptr;
 89c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 89e:	00000717          	auipc	a4,0x0
 8a2:	76f73123          	sd	a5,1890(a4) # 1000 <freep>
}
 8a6:	6422                	ld	s0,8(sp)
 8a8:	0141                	addi	sp,sp,16
 8aa:	8082                	ret

00000000000008ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ac:	7139                	addi	sp,sp,-64
 8ae:	fc06                	sd	ra,56(sp)
 8b0:	f822                	sd	s0,48(sp)
 8b2:	f426                	sd	s1,40(sp)
 8b4:	ec4e                	sd	s3,24(sp)
 8b6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b8:	02051493          	slli	s1,a0,0x20
 8bc:	9081                	srli	s1,s1,0x20
 8be:	04bd                	addi	s1,s1,15
 8c0:	8091                	srli	s1,s1,0x4
 8c2:	0014899b          	addiw	s3,s1,1
 8c6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c8:	00000517          	auipc	a0,0x0
 8cc:	73853503          	ld	a0,1848(a0) # 1000 <freep>
 8d0:	c915                	beqz	a0,904 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d4:	4798                	lw	a4,8(a5)
 8d6:	08977a63          	bgeu	a4,s1,96a <malloc+0xbe>
 8da:	f04a                	sd	s2,32(sp)
 8dc:	e852                	sd	s4,16(sp)
 8de:	e456                	sd	s5,8(sp)
 8e0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8e2:	8a4e                	mv	s4,s3
 8e4:	0009871b          	sext.w	a4,s3
 8e8:	6685                	lui	a3,0x1
 8ea:	00d77363          	bgeu	a4,a3,8f0 <malloc+0x44>
 8ee:	6a05                	lui	s4,0x1
 8f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f8:	00000917          	auipc	s2,0x0
 8fc:	70890913          	addi	s2,s2,1800 # 1000 <freep>
  if(p == SBRK_ERROR)
 900:	5afd                	li	s5,-1
 902:	a081                	j	942 <malloc+0x96>
 904:	f04a                	sd	s2,32(sp)
 906:	e852                	sd	s4,16(sp)
 908:	e456                	sd	s5,8(sp)
 90a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 90c:	00001797          	auipc	a5,0x1
 910:	8fc78793          	addi	a5,a5,-1796 # 1208 <base>
 914:	00000717          	auipc	a4,0x0
 918:	6ef73623          	sd	a5,1772(a4) # 1000 <freep>
 91c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 91e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 922:	b7c1                	j	8e2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 924:	6398                	ld	a4,0(a5)
 926:	e118                	sd	a4,0(a0)
 928:	a8a9                	j	982 <malloc+0xd6>
  hp->s.size = nu;
 92a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 92e:	0541                	addi	a0,a0,16
 930:	efbff0ef          	jal	82a <free>
  return freep;
 934:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 938:	c12d                	beqz	a0,99a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93c:	4798                	lw	a4,8(a5)
 93e:	02977263          	bgeu	a4,s1,962 <malloc+0xb6>
    if(p == freep)
 942:	00093703          	ld	a4,0(s2)
 946:	853e                	mv	a0,a5
 948:	fef719e3          	bne	a4,a5,93a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 94c:	8552                	mv	a0,s4
 94e:	a17ff0ef          	jal	364 <sbrk>
  if(p == SBRK_ERROR)
 952:	fd551ce3          	bne	a0,s5,92a <malloc+0x7e>
        return 0;
 956:	4501                	li	a0,0
 958:	7902                	ld	s2,32(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
 960:	a03d                	j	98e <malloc+0xe2>
 962:	7902                	ld	s2,32(sp)
 964:	6a42                	ld	s4,16(sp)
 966:	6aa2                	ld	s5,8(sp)
 968:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 96a:	fae48de3          	beq	s1,a4,924 <malloc+0x78>
        p->s.size -= nunits;
 96e:	4137073b          	subw	a4,a4,s3
 972:	c798                	sw	a4,8(a5)
        p += p->s.size;
 974:	02071693          	slli	a3,a4,0x20
 978:	01c6d713          	srli	a4,a3,0x1c
 97c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 982:	00000717          	auipc	a4,0x0
 986:	66a73f23          	sd	a0,1662(a4) # 1000 <freep>
      return (void*)(p + 1);
 98a:	01078513          	addi	a0,a5,16
  }
}
 98e:	70e2                	ld	ra,56(sp)
 990:	7442                	ld	s0,48(sp)
 992:	74a2                	ld	s1,40(sp)
 994:	69e2                	ld	s3,24(sp)
 996:	6121                	addi	sp,sp,64
 998:	8082                	ret
 99a:	7902                	ld	s2,32(sp)
 99c:	6a42                	ld	s4,16(sp)
 99e:	6aa2                	ld	s5,8(sp)
 9a0:	6b02                	ld	s6,0(sp)
 9a2:	b7f5                	j	98e <malloc+0xe2>
