
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	fe3d8d93          	addi	s11,s11,-29 # 1011 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	ae8a0a13          	addi	s4,s4,-1304 # b20 <malloc+0xf2>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	3c6080e7          	jalr	966(ra) # 40c <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	f9a58593          	addi	a1,a1,-102 # 1010 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	57a080e7          	jalr	1402(ra) # 5fc <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	f8248493          	addi	s1,s1,-126 # 1010 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	a8250513          	addi	a0,a0,-1406 # b38 <malloc+0x10a>
  be:	00001097          	auipc	ra,0x1
  c2:	8b8080e7          	jalr	-1864(ra) # 976 <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	a4450513          	addi	a0,a0,-1468 # b28 <malloc+0xfa>
  ec:	00001097          	auipc	ra,0x1
  f0:	88a080e7          	jalr	-1910(ra) # 976 <printf>
    exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	4ee080e7          	jalr	1262(ra) # 5e4 <exit>

00000000000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10e:	4785                	li	a5,1
 110:	04a7d763          	bge	a5,a0,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	02099793          	slli	a5,s3,0x20
 120:	01d7d993          	srli	s3,a5,0x1d
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	4f8080e7          	jalr	1272(ra) # 624 <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
    close(fd);
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	4c6080e7          	jalr	1222(ra) # 60c <close>
  for(i = 1; i < argc; i++){
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
  }
  exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	48e080e7          	jalr	1166(ra) # 5e4 <exit>
    wc(0, "");
 15e:	00001597          	auipc	a1,0x1
 162:	9ea58593          	addi	a1,a1,-1558 # b48 <malloc+0x11a>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
    exit(0);
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	472080e7          	jalr	1138(ra) # 5e4 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 17a:	608c                	ld	a1,0(s1)
 17c:	00001517          	auipc	a0,0x1
 180:	9d450513          	addi	a0,a0,-1580 # b50 <malloc+0x122>
 184:	00000097          	auipc	ra,0x0
 188:	7f2080e7          	jalr	2034(ra) # 976 <printf>
      exit(1);
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	456080e7          	jalr	1110(ra) # 5e4 <exit>

0000000000000196 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
    lk->name = name;
 19c:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
 19e:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
 1a2:	57fd                	li	a5,-1
 1a4:	00f50823          	sb	a5,16(a0)
}
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret

00000000000001ae <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	e399                	bnez	a5,1b8 <holding+0xa>
 1b4:	4501                	li	a0,0
}
 1b6:	8082                	ret
{
 1b8:	1101                	addi	sp,sp,-32
 1ba:	ec06                	sd	ra,24(sp)
 1bc:	e822                	sd	s0,16(sp)
 1be:	e426                	sd	s1,8(sp)
 1c0:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
 1c2:	01054483          	lbu	s1,16(a0)
 1c6:	00000097          	auipc	ra,0x0
 1ca:	122080e7          	jalr	290(ra) # 2e8 <twhoami>
 1ce:	2501                	sext.w	a0,a0
 1d0:	40a48533          	sub	a0,s1,a0
 1d4:	00153513          	seqz	a0,a0
}
 1d8:	60e2                	ld	ra,24(sp)
 1da:	6442                	ld	s0,16(sp)
 1dc:	64a2                	ld	s1,8(sp)
 1de:	6105                	addi	sp,sp,32
 1e0:	8082                	ret

00000000000001e2 <acquire>:

void acquire(struct lock *lk)
{
 1e2:	7179                	addi	sp,sp,-48
 1e4:	f406                	sd	ra,40(sp)
 1e6:	f022                	sd	s0,32(sp)
 1e8:	ec26                	sd	s1,24(sp)
 1ea:	e84a                	sd	s2,16(sp)
 1ec:	e44e                	sd	s3,8(sp)
 1ee:	e052                	sd	s4,0(sp)
 1f0:	1800                	addi	s0,sp,48
 1f2:	8a2a                	mv	s4,a0
    if (holding(lk))
 1f4:	00000097          	auipc	ra,0x0
 1f8:	fba080e7          	jalr	-70(ra) # 1ae <holding>
 1fc:	e919                	bnez	a0,212 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 1fe:	ffca7493          	andi	s1,s4,-4
 202:	003a7913          	andi	s2,s4,3
 206:	0039191b          	slliw	s2,s2,0x3
 20a:	4985                	li	s3,1
 20c:	012999bb          	sllw	s3,s3,s2
 210:	a015                	j	234 <acquire+0x52>
        printf("re-acquiring lock we already hold");
 212:	00001517          	auipc	a0,0x1
 216:	95650513          	addi	a0,a0,-1706 # b68 <malloc+0x13a>
 21a:	00000097          	auipc	ra,0x0
 21e:	75c080e7          	jalr	1884(ra) # 976 <printf>
        exit(-1);
 222:	557d                	li	a0,-1
 224:	00000097          	auipc	ra,0x0
 228:	3c0080e7          	jalr	960(ra) # 5e4 <exit>
    {
        // give up the cpu for other threads
        tyield();
 22c:	00000097          	auipc	ra,0x0
 230:	0b0080e7          	jalr	176(ra) # 2dc <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 234:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 238:	0127d7bb          	srlw	a5,a5,s2
 23c:	0ff7f793          	zext.b	a5,a5
 240:	f7f5                	bnez	a5,22c <acquire+0x4a>
    }

    __sync_synchronize();
 242:	0ff0000f          	fence

    lk->tid = twhoami();
 246:	00000097          	auipc	ra,0x0
 24a:	0a2080e7          	jalr	162(ra) # 2e8 <twhoami>
 24e:	00aa0823          	sb	a0,16(s4)
}
 252:	70a2                	ld	ra,40(sp)
 254:	7402                	ld	s0,32(sp)
 256:	64e2                	ld	s1,24(sp)
 258:	6942                	ld	s2,16(sp)
 25a:	69a2                	ld	s3,8(sp)
 25c:	6a02                	ld	s4,0(sp)
 25e:	6145                	addi	sp,sp,48
 260:	8082                	ret

0000000000000262 <release>:

void release(struct lock *lk)
{
 262:	1101                	addi	sp,sp,-32
 264:	ec06                	sd	ra,24(sp)
 266:	e822                	sd	s0,16(sp)
 268:	e426                	sd	s1,8(sp)
 26a:	1000                	addi	s0,sp,32
 26c:	84aa                	mv	s1,a0
    if (!holding(lk))
 26e:	00000097          	auipc	ra,0x0
 272:	f40080e7          	jalr	-192(ra) # 1ae <holding>
 276:	c11d                	beqz	a0,29c <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 278:	57fd                	li	a5,-1
 27a:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 27e:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 282:	0ff0000f          	fence
 286:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 28a:	00000097          	auipc	ra,0x0
 28e:	052080e7          	jalr	82(ra) # 2dc <tyield>
}
 292:	60e2                	ld	ra,24(sp)
 294:	6442                	ld	s0,16(sp)
 296:	64a2                	ld	s1,8(sp)
 298:	6105                	addi	sp,sp,32
 29a:	8082                	ret
        printf("releasing lock we are not holding");
 29c:	00001517          	auipc	a0,0x1
 2a0:	8f450513          	addi	a0,a0,-1804 # b90 <malloc+0x162>
 2a4:	00000097          	auipc	ra,0x0
 2a8:	6d2080e7          	jalr	1746(ra) # 976 <printf>
        exit(-1);
 2ac:	557d                	li	a0,-1
 2ae:	00000097          	auipc	ra,0x0
 2b2:	336080e7          	jalr	822(ra) # 5e4 <exit>

00000000000002b6 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 2d4:	4501                	li	a0,0
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <tyield>:

void tyield()
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <twhoami>:

uint8 twhoami()
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 2ee:	4501                	li	a0,0
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <tswtch>:
 2f6:	00153023          	sd	ra,0(a0)
 2fa:	00253423          	sd	sp,8(a0)
 2fe:	e900                	sd	s0,16(a0)
 300:	ed04                	sd	s1,24(a0)
 302:	03253023          	sd	s2,32(a0)
 306:	03353423          	sd	s3,40(a0)
 30a:	03453823          	sd	s4,48(a0)
 30e:	03553c23          	sd	s5,56(a0)
 312:	05653023          	sd	s6,64(a0)
 316:	05753423          	sd	s7,72(a0)
 31a:	05853823          	sd	s8,80(a0)
 31e:	05953c23          	sd	s9,88(a0)
 322:	07a53023          	sd	s10,96(a0)
 326:	07b53423          	sd	s11,104(a0)
 32a:	0005b083          	ld	ra,0(a1)
 32e:	0085b103          	ld	sp,8(a1)
 332:	6980                	ld	s0,16(a1)
 334:	6d84                	ld	s1,24(a1)
 336:	0205b903          	ld	s2,32(a1)
 33a:	0285b983          	ld	s3,40(a1)
 33e:	0305ba03          	ld	s4,48(a1)
 342:	0385ba83          	ld	s5,56(a1)
 346:	0405bb03          	ld	s6,64(a1)
 34a:	0485bb83          	ld	s7,72(a1)
 34e:	0505bc03          	ld	s8,80(a1)
 352:	0585bc83          	ld	s9,88(a1)
 356:	0605bd03          	ld	s10,96(a1)
 35a:	0685bd83          	ld	s11,104(a1)
 35e:	8082                	ret

0000000000000360 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 360:	1141                	addi	sp,sp,-16
 362:	e406                	sd	ra,8(sp)
 364:	e022                	sd	s0,0(sp)
 366:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 368:	00000097          	auipc	ra,0x0
 36c:	d96080e7          	jalr	-618(ra) # fe <main>
    exit(res);
 370:	00000097          	auipc	ra,0x0
 374:	274080e7          	jalr	628(ra) # 5e4 <exit>

0000000000000378 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e422                	sd	s0,8(sp)
 37c:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 37e:	87aa                	mv	a5,a0
 380:	0585                	addi	a1,a1,1
 382:	0785                	addi	a5,a5,1
 384:	fff5c703          	lbu	a4,-1(a1)
 388:	fee78fa3          	sb	a4,-1(a5)
 38c:	fb75                	bnez	a4,380 <strcpy+0x8>
        ;
    return os;
}
 38e:	6422                	ld	s0,8(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret

0000000000000394 <strcmp>:

int strcmp(const char *p, const char *q)
{
 394:	1141                	addi	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 39a:	00054783          	lbu	a5,0(a0)
 39e:	cb91                	beqz	a5,3b2 <strcmp+0x1e>
 3a0:	0005c703          	lbu	a4,0(a1)
 3a4:	00f71763          	bne	a4,a5,3b2 <strcmp+0x1e>
        p++, q++;
 3a8:	0505                	addi	a0,a0,1
 3aa:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 3ac:	00054783          	lbu	a5,0(a0)
 3b0:	fbe5                	bnez	a5,3a0 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 3b2:	0005c503          	lbu	a0,0(a1)
}
 3b6:	40a7853b          	subw	a0,a5,a0
 3ba:	6422                	ld	s0,8(sp)
 3bc:	0141                	addi	sp,sp,16
 3be:	8082                	ret

00000000000003c0 <strlen>:

uint strlen(const char *s)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e422                	sd	s0,8(sp)
 3c4:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	cf91                	beqz	a5,3e6 <strlen+0x26>
 3cc:	0505                	addi	a0,a0,1
 3ce:	87aa                	mv	a5,a0
 3d0:	4685                	li	a3,1
 3d2:	9e89                	subw	a3,a3,a0
 3d4:	00f6853b          	addw	a0,a3,a5
 3d8:	0785                	addi	a5,a5,1
 3da:	fff7c703          	lbu	a4,-1(a5)
 3de:	fb7d                	bnez	a4,3d4 <strlen+0x14>
        ;
    return n;
}
 3e0:	6422                	ld	s0,8(sp)
 3e2:	0141                	addi	sp,sp,16
 3e4:	8082                	ret
    for (n = 0; s[n]; n++)
 3e6:	4501                	li	a0,0
 3e8:	bfe5                	j	3e0 <strlen+0x20>

00000000000003ea <memset>:

void *
memset(void *dst, int c, uint n)
{
 3ea:	1141                	addi	sp,sp,-16
 3ec:	e422                	sd	s0,8(sp)
 3ee:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 3f0:	ca19                	beqz	a2,406 <memset+0x1c>
 3f2:	87aa                	mv	a5,a0
 3f4:	1602                	slli	a2,a2,0x20
 3f6:	9201                	srli	a2,a2,0x20
 3f8:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 3fc:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 400:	0785                	addi	a5,a5,1
 402:	fee79de3          	bne	a5,a4,3fc <memset+0x12>
    }
    return dst;
}
 406:	6422                	ld	s0,8(sp)
 408:	0141                	addi	sp,sp,16
 40a:	8082                	ret

000000000000040c <strchr>:

char *
strchr(const char *s, char c)
{
 40c:	1141                	addi	sp,sp,-16
 40e:	e422                	sd	s0,8(sp)
 410:	0800                	addi	s0,sp,16
    for (; *s; s++)
 412:	00054783          	lbu	a5,0(a0)
 416:	cb99                	beqz	a5,42c <strchr+0x20>
        if (*s == c)
 418:	00f58763          	beq	a1,a5,426 <strchr+0x1a>
    for (; *s; s++)
 41c:	0505                	addi	a0,a0,1
 41e:	00054783          	lbu	a5,0(a0)
 422:	fbfd                	bnez	a5,418 <strchr+0xc>
            return (char *)s;
    return 0;
 424:	4501                	li	a0,0
}
 426:	6422                	ld	s0,8(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret
    return 0;
 42c:	4501                	li	a0,0
 42e:	bfe5                	j	426 <strchr+0x1a>

0000000000000430 <gets>:

char *
gets(char *buf, int max)
{
 430:	711d                	addi	sp,sp,-96
 432:	ec86                	sd	ra,88(sp)
 434:	e8a2                	sd	s0,80(sp)
 436:	e4a6                	sd	s1,72(sp)
 438:	e0ca                	sd	s2,64(sp)
 43a:	fc4e                	sd	s3,56(sp)
 43c:	f852                	sd	s4,48(sp)
 43e:	f456                	sd	s5,40(sp)
 440:	f05a                	sd	s6,32(sp)
 442:	ec5e                	sd	s7,24(sp)
 444:	1080                	addi	s0,sp,96
 446:	8baa                	mv	s7,a0
 448:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 44a:	892a                	mv	s2,a0
 44c:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 44e:	4aa9                	li	s5,10
 450:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 452:	89a6                	mv	s3,s1
 454:	2485                	addiw	s1,s1,1
 456:	0344d863          	bge	s1,s4,486 <gets+0x56>
        cc = read(0, &c, 1);
 45a:	4605                	li	a2,1
 45c:	faf40593          	addi	a1,s0,-81
 460:	4501                	li	a0,0
 462:	00000097          	auipc	ra,0x0
 466:	19a080e7          	jalr	410(ra) # 5fc <read>
        if (cc < 1)
 46a:	00a05e63          	blez	a0,486 <gets+0x56>
        buf[i++] = c;
 46e:	faf44783          	lbu	a5,-81(s0)
 472:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 476:	01578763          	beq	a5,s5,484 <gets+0x54>
 47a:	0905                	addi	s2,s2,1
 47c:	fd679be3          	bne	a5,s6,452 <gets+0x22>
    for (i = 0; i + 1 < max;)
 480:	89a6                	mv	s3,s1
 482:	a011                	j	486 <gets+0x56>
 484:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 486:	99de                	add	s3,s3,s7
 488:	00098023          	sb	zero,0(s3)
    return buf;
}
 48c:	855e                	mv	a0,s7
 48e:	60e6                	ld	ra,88(sp)
 490:	6446                	ld	s0,80(sp)
 492:	64a6                	ld	s1,72(sp)
 494:	6906                	ld	s2,64(sp)
 496:	79e2                	ld	s3,56(sp)
 498:	7a42                	ld	s4,48(sp)
 49a:	7aa2                	ld	s5,40(sp)
 49c:	7b02                	ld	s6,32(sp)
 49e:	6be2                	ld	s7,24(sp)
 4a0:	6125                	addi	sp,sp,96
 4a2:	8082                	ret

00000000000004a4 <stat>:

int stat(const char *n, struct stat *st)
{
 4a4:	1101                	addi	sp,sp,-32
 4a6:	ec06                	sd	ra,24(sp)
 4a8:	e822                	sd	s0,16(sp)
 4aa:	e426                	sd	s1,8(sp)
 4ac:	e04a                	sd	s2,0(sp)
 4ae:	1000                	addi	s0,sp,32
 4b0:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 4b2:	4581                	li	a1,0
 4b4:	00000097          	auipc	ra,0x0
 4b8:	170080e7          	jalr	368(ra) # 624 <open>
    if (fd < 0)
 4bc:	02054563          	bltz	a0,4e6 <stat+0x42>
 4c0:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 4c2:	85ca                	mv	a1,s2
 4c4:	00000097          	auipc	ra,0x0
 4c8:	178080e7          	jalr	376(ra) # 63c <fstat>
 4cc:	892a                	mv	s2,a0
    close(fd);
 4ce:	8526                	mv	a0,s1
 4d0:	00000097          	auipc	ra,0x0
 4d4:	13c080e7          	jalr	316(ra) # 60c <close>
    return r;
}
 4d8:	854a                	mv	a0,s2
 4da:	60e2                	ld	ra,24(sp)
 4dc:	6442                	ld	s0,16(sp)
 4de:	64a2                	ld	s1,8(sp)
 4e0:	6902                	ld	s2,0(sp)
 4e2:	6105                	addi	sp,sp,32
 4e4:	8082                	ret
        return -1;
 4e6:	597d                	li	s2,-1
 4e8:	bfc5                	j	4d8 <stat+0x34>

00000000000004ea <atoi>:

int atoi(const char *s)
{
 4ea:	1141                	addi	sp,sp,-16
 4ec:	e422                	sd	s0,8(sp)
 4ee:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 4f0:	00054683          	lbu	a3,0(a0)
 4f4:	fd06879b          	addiw	a5,a3,-48
 4f8:	0ff7f793          	zext.b	a5,a5
 4fc:	4625                	li	a2,9
 4fe:	02f66863          	bltu	a2,a5,52e <atoi+0x44>
 502:	872a                	mv	a4,a0
    n = 0;
 504:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 506:	0705                	addi	a4,a4,1
 508:	0025179b          	slliw	a5,a0,0x2
 50c:	9fa9                	addw	a5,a5,a0
 50e:	0017979b          	slliw	a5,a5,0x1
 512:	9fb5                	addw	a5,a5,a3
 514:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 518:	00074683          	lbu	a3,0(a4)
 51c:	fd06879b          	addiw	a5,a3,-48
 520:	0ff7f793          	zext.b	a5,a5
 524:	fef671e3          	bgeu	a2,a5,506 <atoi+0x1c>
    return n;
}
 528:	6422                	ld	s0,8(sp)
 52a:	0141                	addi	sp,sp,16
 52c:	8082                	ret
    n = 0;
 52e:	4501                	li	a0,0
 530:	bfe5                	j	528 <atoi+0x3e>

0000000000000532 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 532:	1141                	addi	sp,sp,-16
 534:	e422                	sd	s0,8(sp)
 536:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 538:	02b57463          	bgeu	a0,a1,560 <memmove+0x2e>
    {
        while (n-- > 0)
 53c:	00c05f63          	blez	a2,55a <memmove+0x28>
 540:	1602                	slli	a2,a2,0x20
 542:	9201                	srli	a2,a2,0x20
 544:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 548:	872a                	mv	a4,a0
            *dst++ = *src++;
 54a:	0585                	addi	a1,a1,1
 54c:	0705                	addi	a4,a4,1
 54e:	fff5c683          	lbu	a3,-1(a1)
 552:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 556:	fee79ae3          	bne	a5,a4,54a <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 55a:	6422                	ld	s0,8(sp)
 55c:	0141                	addi	sp,sp,16
 55e:	8082                	ret
        dst += n;
 560:	00c50733          	add	a4,a0,a2
        src += n;
 564:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 566:	fec05ae3          	blez	a2,55a <memmove+0x28>
 56a:	fff6079b          	addiw	a5,a2,-1
 56e:	1782                	slli	a5,a5,0x20
 570:	9381                	srli	a5,a5,0x20
 572:	fff7c793          	not	a5,a5
 576:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 578:	15fd                	addi	a1,a1,-1
 57a:	177d                	addi	a4,a4,-1
 57c:	0005c683          	lbu	a3,0(a1)
 580:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 584:	fee79ae3          	bne	a5,a4,578 <memmove+0x46>
 588:	bfc9                	j	55a <memmove+0x28>

000000000000058a <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 58a:	1141                	addi	sp,sp,-16
 58c:	e422                	sd	s0,8(sp)
 58e:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 590:	ca05                	beqz	a2,5c0 <memcmp+0x36>
 592:	fff6069b          	addiw	a3,a2,-1
 596:	1682                	slli	a3,a3,0x20
 598:	9281                	srli	a3,a3,0x20
 59a:	0685                	addi	a3,a3,1
 59c:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 59e:	00054783          	lbu	a5,0(a0)
 5a2:	0005c703          	lbu	a4,0(a1)
 5a6:	00e79863          	bne	a5,a4,5b6 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 5aa:	0505                	addi	a0,a0,1
        p2++;
 5ac:	0585                	addi	a1,a1,1
    while (n-- > 0)
 5ae:	fed518e3          	bne	a0,a3,59e <memcmp+0x14>
    }
    return 0;
 5b2:	4501                	li	a0,0
 5b4:	a019                	j	5ba <memcmp+0x30>
            return *p1 - *p2;
 5b6:	40e7853b          	subw	a0,a5,a4
}
 5ba:	6422                	ld	s0,8(sp)
 5bc:	0141                	addi	sp,sp,16
 5be:	8082                	ret
    return 0;
 5c0:	4501                	li	a0,0
 5c2:	bfe5                	j	5ba <memcmp+0x30>

00000000000005c4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5c4:	1141                	addi	sp,sp,-16
 5c6:	e406                	sd	ra,8(sp)
 5c8:	e022                	sd	s0,0(sp)
 5ca:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 5cc:	00000097          	auipc	ra,0x0
 5d0:	f66080e7          	jalr	-154(ra) # 532 <memmove>
}
 5d4:	60a2                	ld	ra,8(sp)
 5d6:	6402                	ld	s0,0(sp)
 5d8:	0141                	addi	sp,sp,16
 5da:	8082                	ret

00000000000005dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5dc:	4885                	li	a7,1
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5e4:	4889                	li	a7,2
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 5ec:	488d                	li	a7,3
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5f4:	4891                	li	a7,4
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <read>:
.global read
read:
 li a7, SYS_read
 5fc:	4895                	li	a7,5
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <write>:
.global write
write:
 li a7, SYS_write
 604:	48c1                	li	a7,16
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <close>:
.global close
close:
 li a7, SYS_close
 60c:	48d5                	li	a7,21
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <kill>:
.global kill
kill:
 li a7, SYS_kill
 614:	4899                	li	a7,6
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <exec>:
.global exec
exec:
 li a7, SYS_exec
 61c:	489d                	li	a7,7
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <open>:
.global open
open:
 li a7, SYS_open
 624:	48bd                	li	a7,15
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 62c:	48c5                	li	a7,17
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 634:	48c9                	li	a7,18
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 63c:	48a1                	li	a7,8
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <link>:
.global link
link:
 li a7, SYS_link
 644:	48cd                	li	a7,19
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 64c:	48d1                	li	a7,20
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 654:	48a5                	li	a7,9
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <dup>:
.global dup
dup:
 li a7, SYS_dup
 65c:	48a9                	li	a7,10
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 664:	48ad                	li	a7,11
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 66c:	48b1                	li	a7,12
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 674:	48b5                	li	a7,13
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 67c:	48b9                	li	a7,14
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <ps>:
.global ps
ps:
 li a7, SYS_ps
 684:	48d9                	li	a7,22
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 68c:	48dd                	li	a7,23
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 694:	48e1                	li	a7,24
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 69c:	1101                	addi	sp,sp,-32
 69e:	ec06                	sd	ra,24(sp)
 6a0:	e822                	sd	s0,16(sp)
 6a2:	1000                	addi	s0,sp,32
 6a4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6a8:	4605                	li	a2,1
 6aa:	fef40593          	addi	a1,s0,-17
 6ae:	00000097          	auipc	ra,0x0
 6b2:	f56080e7          	jalr	-170(ra) # 604 <write>
}
 6b6:	60e2                	ld	ra,24(sp)
 6b8:	6442                	ld	s0,16(sp)
 6ba:	6105                	addi	sp,sp,32
 6bc:	8082                	ret

00000000000006be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6be:	7139                	addi	sp,sp,-64
 6c0:	fc06                	sd	ra,56(sp)
 6c2:	f822                	sd	s0,48(sp)
 6c4:	f426                	sd	s1,40(sp)
 6c6:	f04a                	sd	s2,32(sp)
 6c8:	ec4e                	sd	s3,24(sp)
 6ca:	0080                	addi	s0,sp,64
 6cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6ce:	c299                	beqz	a3,6d4 <printint+0x16>
 6d0:	0805c963          	bltz	a1,762 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6d4:	2581                	sext.w	a1,a1
  neg = 0;
 6d6:	4881                	li	a7,0
 6d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6de:	2601                	sext.w	a2,a2
 6e0:	00000517          	auipc	a0,0x0
 6e4:	53850513          	addi	a0,a0,1336 # c18 <digits>
 6e8:	883a                	mv	a6,a4
 6ea:	2705                	addiw	a4,a4,1
 6ec:	02c5f7bb          	remuw	a5,a1,a2
 6f0:	1782                	slli	a5,a5,0x20
 6f2:	9381                	srli	a5,a5,0x20
 6f4:	97aa                	add	a5,a5,a0
 6f6:	0007c783          	lbu	a5,0(a5)
 6fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6fe:	0005879b          	sext.w	a5,a1
 702:	02c5d5bb          	divuw	a1,a1,a2
 706:	0685                	addi	a3,a3,1
 708:	fec7f0e3          	bgeu	a5,a2,6e8 <printint+0x2a>
  if(neg)
 70c:	00088c63          	beqz	a7,724 <printint+0x66>
    buf[i++] = '-';
 710:	fd070793          	addi	a5,a4,-48
 714:	00878733          	add	a4,a5,s0
 718:	02d00793          	li	a5,45
 71c:	fef70823          	sb	a5,-16(a4)
 720:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 724:	02e05863          	blez	a4,754 <printint+0x96>
 728:	fc040793          	addi	a5,s0,-64
 72c:	00e78933          	add	s2,a5,a4
 730:	fff78993          	addi	s3,a5,-1
 734:	99ba                	add	s3,s3,a4
 736:	377d                	addiw	a4,a4,-1
 738:	1702                	slli	a4,a4,0x20
 73a:	9301                	srli	a4,a4,0x20
 73c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 740:	fff94583          	lbu	a1,-1(s2)
 744:	8526                	mv	a0,s1
 746:	00000097          	auipc	ra,0x0
 74a:	f56080e7          	jalr	-170(ra) # 69c <putc>
  while(--i >= 0)
 74e:	197d                	addi	s2,s2,-1
 750:	ff3918e3          	bne	s2,s3,740 <printint+0x82>
}
 754:	70e2                	ld	ra,56(sp)
 756:	7442                	ld	s0,48(sp)
 758:	74a2                	ld	s1,40(sp)
 75a:	7902                	ld	s2,32(sp)
 75c:	69e2                	ld	s3,24(sp)
 75e:	6121                	addi	sp,sp,64
 760:	8082                	ret
    x = -xx;
 762:	40b005bb          	negw	a1,a1
    neg = 1;
 766:	4885                	li	a7,1
    x = -xx;
 768:	bf85                	j	6d8 <printint+0x1a>

000000000000076a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 76a:	7119                	addi	sp,sp,-128
 76c:	fc86                	sd	ra,120(sp)
 76e:	f8a2                	sd	s0,112(sp)
 770:	f4a6                	sd	s1,104(sp)
 772:	f0ca                	sd	s2,96(sp)
 774:	ecce                	sd	s3,88(sp)
 776:	e8d2                	sd	s4,80(sp)
 778:	e4d6                	sd	s5,72(sp)
 77a:	e0da                	sd	s6,64(sp)
 77c:	fc5e                	sd	s7,56(sp)
 77e:	f862                	sd	s8,48(sp)
 780:	f466                	sd	s9,40(sp)
 782:	f06a                	sd	s10,32(sp)
 784:	ec6e                	sd	s11,24(sp)
 786:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 788:	0005c903          	lbu	s2,0(a1)
 78c:	18090f63          	beqz	s2,92a <vprintf+0x1c0>
 790:	8aaa                	mv	s5,a0
 792:	8b32                	mv	s6,a2
 794:	00158493          	addi	s1,a1,1
  state = 0;
 798:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 79a:	02500a13          	li	s4,37
 79e:	4c55                	li	s8,21
 7a0:	00000c97          	auipc	s9,0x0
 7a4:	420c8c93          	addi	s9,s9,1056 # bc0 <malloc+0x192>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7a8:	02800d93          	li	s11,40
  putc(fd, 'x');
 7ac:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ae:	00000b97          	auipc	s7,0x0
 7b2:	46ab8b93          	addi	s7,s7,1130 # c18 <digits>
 7b6:	a839                	j	7d4 <vprintf+0x6a>
        putc(fd, c);
 7b8:	85ca                	mv	a1,s2
 7ba:	8556                	mv	a0,s5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	ee0080e7          	jalr	-288(ra) # 69c <putc>
 7c4:	a019                	j	7ca <vprintf+0x60>
    } else if(state == '%'){
 7c6:	01498d63          	beq	s3,s4,7e0 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 7ca:	0485                	addi	s1,s1,1
 7cc:	fff4c903          	lbu	s2,-1(s1)
 7d0:	14090d63          	beqz	s2,92a <vprintf+0x1c0>
    if(state == 0){
 7d4:	fe0999e3          	bnez	s3,7c6 <vprintf+0x5c>
      if(c == '%'){
 7d8:	ff4910e3          	bne	s2,s4,7b8 <vprintf+0x4e>
        state = '%';
 7dc:	89d2                	mv	s3,s4
 7de:	b7f5                	j	7ca <vprintf+0x60>
      if(c == 'd'){
 7e0:	11490c63          	beq	s2,s4,8f8 <vprintf+0x18e>
 7e4:	f9d9079b          	addiw	a5,s2,-99
 7e8:	0ff7f793          	zext.b	a5,a5
 7ec:	10fc6e63          	bltu	s8,a5,908 <vprintf+0x19e>
 7f0:	f9d9079b          	addiw	a5,s2,-99
 7f4:	0ff7f713          	zext.b	a4,a5
 7f8:	10ec6863          	bltu	s8,a4,908 <vprintf+0x19e>
 7fc:	00271793          	slli	a5,a4,0x2
 800:	97e6                	add	a5,a5,s9
 802:	439c                	lw	a5,0(a5)
 804:	97e6                	add	a5,a5,s9
 806:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 808:	008b0913          	addi	s2,s6,8
 80c:	4685                	li	a3,1
 80e:	4629                	li	a2,10
 810:	000b2583          	lw	a1,0(s6)
 814:	8556                	mv	a0,s5
 816:	00000097          	auipc	ra,0x0
 81a:	ea8080e7          	jalr	-344(ra) # 6be <printint>
 81e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 820:	4981                	li	s3,0
 822:	b765                	j	7ca <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 824:	008b0913          	addi	s2,s6,8
 828:	4681                	li	a3,0
 82a:	4629                	li	a2,10
 82c:	000b2583          	lw	a1,0(s6)
 830:	8556                	mv	a0,s5
 832:	00000097          	auipc	ra,0x0
 836:	e8c080e7          	jalr	-372(ra) # 6be <printint>
 83a:	8b4a                	mv	s6,s2
      state = 0;
 83c:	4981                	li	s3,0
 83e:	b771                	j	7ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 840:	008b0913          	addi	s2,s6,8
 844:	4681                	li	a3,0
 846:	866a                	mv	a2,s10
 848:	000b2583          	lw	a1,0(s6)
 84c:	8556                	mv	a0,s5
 84e:	00000097          	auipc	ra,0x0
 852:	e70080e7          	jalr	-400(ra) # 6be <printint>
 856:	8b4a                	mv	s6,s2
      state = 0;
 858:	4981                	li	s3,0
 85a:	bf85                	j	7ca <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 85c:	008b0793          	addi	a5,s6,8
 860:	f8f43423          	sd	a5,-120(s0)
 864:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 868:	03000593          	li	a1,48
 86c:	8556                	mv	a0,s5
 86e:	00000097          	auipc	ra,0x0
 872:	e2e080e7          	jalr	-466(ra) # 69c <putc>
  putc(fd, 'x');
 876:	07800593          	li	a1,120
 87a:	8556                	mv	a0,s5
 87c:	00000097          	auipc	ra,0x0
 880:	e20080e7          	jalr	-480(ra) # 69c <putc>
 884:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 886:	03c9d793          	srli	a5,s3,0x3c
 88a:	97de                	add	a5,a5,s7
 88c:	0007c583          	lbu	a1,0(a5)
 890:	8556                	mv	a0,s5
 892:	00000097          	auipc	ra,0x0
 896:	e0a080e7          	jalr	-502(ra) # 69c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 89a:	0992                	slli	s3,s3,0x4
 89c:	397d                	addiw	s2,s2,-1
 89e:	fe0914e3          	bnez	s2,886 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 8a2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8a6:	4981                	li	s3,0
 8a8:	b70d                	j	7ca <vprintf+0x60>
        s = va_arg(ap, char*);
 8aa:	008b0913          	addi	s2,s6,8
 8ae:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 8b2:	02098163          	beqz	s3,8d4 <vprintf+0x16a>
        while(*s != 0){
 8b6:	0009c583          	lbu	a1,0(s3)
 8ba:	c5ad                	beqz	a1,924 <vprintf+0x1ba>
          putc(fd, *s);
 8bc:	8556                	mv	a0,s5
 8be:	00000097          	auipc	ra,0x0
 8c2:	dde080e7          	jalr	-546(ra) # 69c <putc>
          s++;
 8c6:	0985                	addi	s3,s3,1
        while(*s != 0){
 8c8:	0009c583          	lbu	a1,0(s3)
 8cc:	f9e5                	bnez	a1,8bc <vprintf+0x152>
        s = va_arg(ap, char*);
 8ce:	8b4a                	mv	s6,s2
      state = 0;
 8d0:	4981                	li	s3,0
 8d2:	bde5                	j	7ca <vprintf+0x60>
          s = "(null)";
 8d4:	00000997          	auipc	s3,0x0
 8d8:	2e498993          	addi	s3,s3,740 # bb8 <malloc+0x18a>
        while(*s != 0){
 8dc:	85ee                	mv	a1,s11
 8de:	bff9                	j	8bc <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 8e0:	008b0913          	addi	s2,s6,8
 8e4:	000b4583          	lbu	a1,0(s6)
 8e8:	8556                	mv	a0,s5
 8ea:	00000097          	auipc	ra,0x0
 8ee:	db2080e7          	jalr	-590(ra) # 69c <putc>
 8f2:	8b4a                	mv	s6,s2
      state = 0;
 8f4:	4981                	li	s3,0
 8f6:	bdd1                	j	7ca <vprintf+0x60>
        putc(fd, c);
 8f8:	85d2                	mv	a1,s4
 8fa:	8556                	mv	a0,s5
 8fc:	00000097          	auipc	ra,0x0
 900:	da0080e7          	jalr	-608(ra) # 69c <putc>
      state = 0;
 904:	4981                	li	s3,0
 906:	b5d1                	j	7ca <vprintf+0x60>
        putc(fd, '%');
 908:	85d2                	mv	a1,s4
 90a:	8556                	mv	a0,s5
 90c:	00000097          	auipc	ra,0x0
 910:	d90080e7          	jalr	-624(ra) # 69c <putc>
        putc(fd, c);
 914:	85ca                	mv	a1,s2
 916:	8556                	mv	a0,s5
 918:	00000097          	auipc	ra,0x0
 91c:	d84080e7          	jalr	-636(ra) # 69c <putc>
      state = 0;
 920:	4981                	li	s3,0
 922:	b565                	j	7ca <vprintf+0x60>
        s = va_arg(ap, char*);
 924:	8b4a                	mv	s6,s2
      state = 0;
 926:	4981                	li	s3,0
 928:	b54d                	j	7ca <vprintf+0x60>
    }
  }
}
 92a:	70e6                	ld	ra,120(sp)
 92c:	7446                	ld	s0,112(sp)
 92e:	74a6                	ld	s1,104(sp)
 930:	7906                	ld	s2,96(sp)
 932:	69e6                	ld	s3,88(sp)
 934:	6a46                	ld	s4,80(sp)
 936:	6aa6                	ld	s5,72(sp)
 938:	6b06                	ld	s6,64(sp)
 93a:	7be2                	ld	s7,56(sp)
 93c:	7c42                	ld	s8,48(sp)
 93e:	7ca2                	ld	s9,40(sp)
 940:	7d02                	ld	s10,32(sp)
 942:	6de2                	ld	s11,24(sp)
 944:	6109                	addi	sp,sp,128
 946:	8082                	ret

0000000000000948 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 948:	715d                	addi	sp,sp,-80
 94a:	ec06                	sd	ra,24(sp)
 94c:	e822                	sd	s0,16(sp)
 94e:	1000                	addi	s0,sp,32
 950:	e010                	sd	a2,0(s0)
 952:	e414                	sd	a3,8(s0)
 954:	e818                	sd	a4,16(s0)
 956:	ec1c                	sd	a5,24(s0)
 958:	03043023          	sd	a6,32(s0)
 95c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 960:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 964:	8622                	mv	a2,s0
 966:	00000097          	auipc	ra,0x0
 96a:	e04080e7          	jalr	-508(ra) # 76a <vprintf>
}
 96e:	60e2                	ld	ra,24(sp)
 970:	6442                	ld	s0,16(sp)
 972:	6161                	addi	sp,sp,80
 974:	8082                	ret

0000000000000976 <printf>:

void
printf(const char *fmt, ...)
{
 976:	711d                	addi	sp,sp,-96
 978:	ec06                	sd	ra,24(sp)
 97a:	e822                	sd	s0,16(sp)
 97c:	1000                	addi	s0,sp,32
 97e:	e40c                	sd	a1,8(s0)
 980:	e810                	sd	a2,16(s0)
 982:	ec14                	sd	a3,24(s0)
 984:	f018                	sd	a4,32(s0)
 986:	f41c                	sd	a5,40(s0)
 988:	03043823          	sd	a6,48(s0)
 98c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 990:	00840613          	addi	a2,s0,8
 994:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 998:	85aa                	mv	a1,a0
 99a:	4505                	li	a0,1
 99c:	00000097          	auipc	ra,0x0
 9a0:	dce080e7          	jalr	-562(ra) # 76a <vprintf>
}
 9a4:	60e2                	ld	ra,24(sp)
 9a6:	6442                	ld	s0,16(sp)
 9a8:	6125                	addi	sp,sp,96
 9aa:	8082                	ret

00000000000009ac <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 9ac:	1141                	addi	sp,sp,-16
 9ae:	e422                	sd	s0,8(sp)
 9b0:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 9b2:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b6:	00000797          	auipc	a5,0x0
 9ba:	64a7b783          	ld	a5,1610(a5) # 1000 <freep>
 9be:	a02d                	j	9e8 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 9c0:	4618                	lw	a4,8(a2)
 9c2:	9f2d                	addw	a4,a4,a1
 9c4:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 9c8:	6398                	ld	a4,0(a5)
 9ca:	6310                	ld	a2,0(a4)
 9cc:	a83d                	j	a0a <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 9ce:	ff852703          	lw	a4,-8(a0)
 9d2:	9f31                	addw	a4,a4,a2
 9d4:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 9d6:	ff053683          	ld	a3,-16(a0)
 9da:	a091                	j	a1e <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9dc:	6398                	ld	a4,0(a5)
 9de:	00e7e463          	bltu	a5,a4,9e6 <free+0x3a>
 9e2:	00e6ea63          	bltu	a3,a4,9f6 <free+0x4a>
{
 9e6:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e8:	fed7fae3          	bgeu	a5,a3,9dc <free+0x30>
 9ec:	6398                	ld	a4,0(a5)
 9ee:	00e6e463          	bltu	a3,a4,9f6 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9f2:	fee7eae3          	bltu	a5,a4,9e6 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 9f6:	ff852583          	lw	a1,-8(a0)
 9fa:	6390                	ld	a2,0(a5)
 9fc:	02059813          	slli	a6,a1,0x20
 a00:	01c85713          	srli	a4,a6,0x1c
 a04:	9736                	add	a4,a4,a3
 a06:	fae60de3          	beq	a2,a4,9c0 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 a0a:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 a0e:	4790                	lw	a2,8(a5)
 a10:	02061593          	slli	a1,a2,0x20
 a14:	01c5d713          	srli	a4,a1,0x1c
 a18:	973e                	add	a4,a4,a5
 a1a:	fae68ae3          	beq	a3,a4,9ce <free+0x22>
        p->s.ptr = bp->s.ptr;
 a1e:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 a20:	00000717          	auipc	a4,0x0
 a24:	5ef73023          	sd	a5,1504(a4) # 1000 <freep>
}
 a28:	6422                	ld	s0,8(sp)
 a2a:	0141                	addi	sp,sp,16
 a2c:	8082                	ret

0000000000000a2e <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 a2e:	7139                	addi	sp,sp,-64
 a30:	fc06                	sd	ra,56(sp)
 a32:	f822                	sd	s0,48(sp)
 a34:	f426                	sd	s1,40(sp)
 a36:	f04a                	sd	s2,32(sp)
 a38:	ec4e                	sd	s3,24(sp)
 a3a:	e852                	sd	s4,16(sp)
 a3c:	e456                	sd	s5,8(sp)
 a3e:	e05a                	sd	s6,0(sp)
 a40:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 a42:	02051493          	slli	s1,a0,0x20
 a46:	9081                	srli	s1,s1,0x20
 a48:	04bd                	addi	s1,s1,15
 a4a:	8091                	srli	s1,s1,0x4
 a4c:	0014899b          	addiw	s3,s1,1
 a50:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 a52:	00000517          	auipc	a0,0x0
 a56:	5ae53503          	ld	a0,1454(a0) # 1000 <freep>
 a5a:	c515                	beqz	a0,a86 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 a5c:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 a5e:	4798                	lw	a4,8(a5)
 a60:	02977f63          	bgeu	a4,s1,a9e <malloc+0x70>
 a64:	8a4e                	mv	s4,s3
 a66:	0009871b          	sext.w	a4,s3
 a6a:	6685                	lui	a3,0x1
 a6c:	00d77363          	bgeu	a4,a3,a72 <malloc+0x44>
 a70:	6a05                	lui	s4,0x1
 a72:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 a76:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 a7a:	00000917          	auipc	s2,0x0
 a7e:	58690913          	addi	s2,s2,1414 # 1000 <freep>
    if (p == (char *)-1)
 a82:	5afd                	li	s5,-1
 a84:	a895                	j	af8 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 a86:	00000797          	auipc	a5,0x0
 a8a:	78a78793          	addi	a5,a5,1930 # 1210 <base>
 a8e:	00000717          	auipc	a4,0x0
 a92:	56f73923          	sd	a5,1394(a4) # 1000 <freep>
 a96:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 a98:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 a9c:	b7e1                	j	a64 <malloc+0x36>
            if (p->s.size == nunits)
 a9e:	02e48c63          	beq	s1,a4,ad6 <malloc+0xa8>
                p->s.size -= nunits;
 aa2:	4137073b          	subw	a4,a4,s3
 aa6:	c798                	sw	a4,8(a5)
                p += p->s.size;
 aa8:	02071693          	slli	a3,a4,0x20
 aac:	01c6d713          	srli	a4,a3,0x1c
 ab0:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 ab2:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 ab6:	00000717          	auipc	a4,0x0
 aba:	54a73523          	sd	a0,1354(a4) # 1000 <freep>
            return (void *)(p + 1);
 abe:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 ac2:	70e2                	ld	ra,56(sp)
 ac4:	7442                	ld	s0,48(sp)
 ac6:	74a2                	ld	s1,40(sp)
 ac8:	7902                	ld	s2,32(sp)
 aca:	69e2                	ld	s3,24(sp)
 acc:	6a42                	ld	s4,16(sp)
 ace:	6aa2                	ld	s5,8(sp)
 ad0:	6b02                	ld	s6,0(sp)
 ad2:	6121                	addi	sp,sp,64
 ad4:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 ad6:	6398                	ld	a4,0(a5)
 ad8:	e118                	sd	a4,0(a0)
 ada:	bff1                	j	ab6 <malloc+0x88>
    hp->s.size = nu;
 adc:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 ae0:	0541                	addi	a0,a0,16
 ae2:	00000097          	auipc	ra,0x0
 ae6:	eca080e7          	jalr	-310(ra) # 9ac <free>
    return freep;
 aea:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 aee:	d971                	beqz	a0,ac2 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 af0:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 af2:	4798                	lw	a4,8(a5)
 af4:	fa9775e3          	bgeu	a4,s1,a9e <malloc+0x70>
        if (p == freep)
 af8:	00093703          	ld	a4,0(s2)
 afc:	853e                	mv	a0,a5
 afe:	fef719e3          	bne	a4,a5,af0 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 b02:	8552                	mv	a0,s4
 b04:	00000097          	auipc	ra,0x0
 b08:	b68080e7          	jalr	-1176(ra) # 66c <sbrk>
    if (p == (char *)-1)
 b0c:	fd5518e3          	bne	a0,s5,adc <malloc+0xae>
                return 0;
 b10:	4501                	li	a0,0
 b12:	bf45                	j	ac2 <malloc+0x94>
