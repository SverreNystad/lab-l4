
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	aaa78793          	addi	a5,a5,-1366 # ac0 <malloc+0x11c>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	a6450513          	addi	a0,a0,-1436 # a90 <malloc+0xec>
  34:	00001097          	auipc	ra,0x1
  38:	8b8080e7          	jalr	-1864(ra) # 8ec <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	318080e7          	jalr	792(ra) # 360 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	4fe080e7          	jalr	1278(ra) # 552 <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	a4050513          	addi	a0,a0,-1472 # aa8 <malloc+0x104>
  70:	00001097          	auipc	ra,0x1
  74:	87c080e7          	jalr	-1924(ra) # 8ec <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	510080e7          	jalr	1296(ra) # 59a <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	4da080e7          	jalr	1242(ra) # 57a <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	4d4080e7          	jalr	1236(ra) # 582 <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	a0250513          	addi	a0,a0,-1534 # ab8 <malloc+0x114>
  be:	00001097          	auipc	ra,0x1
  c2:	82e080e7          	jalr	-2002(ra) # 8ec <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	4ce080e7          	jalr	1230(ra) # 59a <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	490080e7          	jalr	1168(ra) # 572 <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	492080e7          	jalr	1170(ra) # 582 <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	468080e7          	jalr	1128(ra) # 562 <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	456080e7          	jalr	1110(ra) # 55a <exit>

000000000000010c <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
    lk->name = name;
 112:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
 114:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
 118:	57fd                	li	a5,-1
 11a:	00f50823          	sb	a5,16(a0)
}
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
 124:	00054783          	lbu	a5,0(a0)
 128:	e399                	bnez	a5,12e <holding+0xa>
 12a:	4501                	li	a0,0
}
 12c:	8082                	ret
{
 12e:	1101                	addi	sp,sp,-32
 130:	ec06                	sd	ra,24(sp)
 132:	e822                	sd	s0,16(sp)
 134:	e426                	sd	s1,8(sp)
 136:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
 138:	01054483          	lbu	s1,16(a0)
 13c:	00000097          	auipc	ra,0x0
 140:	122080e7          	jalr	290(ra) # 25e <twhoami>
 144:	2501                	sext.w	a0,a0
 146:	40a48533          	sub	a0,s1,a0
 14a:	00153513          	seqz	a0,a0
}
 14e:	60e2                	ld	ra,24(sp)
 150:	6442                	ld	s0,16(sp)
 152:	64a2                	ld	s1,8(sp)
 154:	6105                	addi	sp,sp,32
 156:	8082                	ret

0000000000000158 <acquire>:

void acquire(struct lock *lk)
{
 158:	7179                	addi	sp,sp,-48
 15a:	f406                	sd	ra,40(sp)
 15c:	f022                	sd	s0,32(sp)
 15e:	ec26                	sd	s1,24(sp)
 160:	e84a                	sd	s2,16(sp)
 162:	e44e                	sd	s3,8(sp)
 164:	e052                	sd	s4,0(sp)
 166:	1800                	addi	s0,sp,48
 168:	8a2a                	mv	s4,a0
    if (holding(lk))
 16a:	00000097          	auipc	ra,0x0
 16e:	fba080e7          	jalr	-70(ra) # 124 <holding>
 172:	e919                	bnez	a0,188 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 174:	ffca7493          	andi	s1,s4,-4
 178:	003a7913          	andi	s2,s4,3
 17c:	0039191b          	slliw	s2,s2,0x3
 180:	4985                	li	s3,1
 182:	012999bb          	sllw	s3,s3,s2
 186:	a015                	j	1aa <acquire+0x52>
        printf("re-acquiring lock we already hold");
 188:	00001517          	auipc	a0,0x1
 18c:	94850513          	addi	a0,a0,-1720 # ad0 <malloc+0x12c>
 190:	00000097          	auipc	ra,0x0
 194:	75c080e7          	jalr	1884(ra) # 8ec <printf>
        exit(-1);
 198:	557d                	li	a0,-1
 19a:	00000097          	auipc	ra,0x0
 19e:	3c0080e7          	jalr	960(ra) # 55a <exit>
    {
        // give up the cpu for other threads
        tyield();
 1a2:	00000097          	auipc	ra,0x0
 1a6:	0b0080e7          	jalr	176(ra) # 252 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 1aa:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 1ae:	0127d7bb          	srlw	a5,a5,s2
 1b2:	0ff7f793          	zext.b	a5,a5
 1b6:	f7f5                	bnez	a5,1a2 <acquire+0x4a>
    }

    __sync_synchronize();
 1b8:	0ff0000f          	fence

    lk->tid = twhoami();
 1bc:	00000097          	auipc	ra,0x0
 1c0:	0a2080e7          	jalr	162(ra) # 25e <twhoami>
 1c4:	00aa0823          	sb	a0,16(s4)
}
 1c8:	70a2                	ld	ra,40(sp)
 1ca:	7402                	ld	s0,32(sp)
 1cc:	64e2                	ld	s1,24(sp)
 1ce:	6942                	ld	s2,16(sp)
 1d0:	69a2                	ld	s3,8(sp)
 1d2:	6a02                	ld	s4,0(sp)
 1d4:	6145                	addi	sp,sp,48
 1d6:	8082                	ret

00000000000001d8 <release>:

void release(struct lock *lk)
{
 1d8:	1101                	addi	sp,sp,-32
 1da:	ec06                	sd	ra,24(sp)
 1dc:	e822                	sd	s0,16(sp)
 1de:	e426                	sd	s1,8(sp)
 1e0:	1000                	addi	s0,sp,32
 1e2:	84aa                	mv	s1,a0
    if (!holding(lk))
 1e4:	00000097          	auipc	ra,0x0
 1e8:	f40080e7          	jalr	-192(ra) # 124 <holding>
 1ec:	c11d                	beqz	a0,212 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 1ee:	57fd                	li	a5,-1
 1f0:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 1f4:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 1f8:	0ff0000f          	fence
 1fc:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 200:	00000097          	auipc	ra,0x0
 204:	052080e7          	jalr	82(ra) # 252 <tyield>
}
 208:	60e2                	ld	ra,24(sp)
 20a:	6442                	ld	s0,16(sp)
 20c:	64a2                	ld	s1,8(sp)
 20e:	6105                	addi	sp,sp,32
 210:	8082                	ret
        printf("releasing lock we are not holding");
 212:	00001517          	auipc	a0,0x1
 216:	8e650513          	addi	a0,a0,-1818 # af8 <malloc+0x154>
 21a:	00000097          	auipc	ra,0x0
 21e:	6d2080e7          	jalr	1746(ra) # 8ec <printf>
        exit(-1);
 222:	557d                	li	a0,-1
 224:	00000097          	auipc	ra,0x0
 228:	336080e7          	jalr	822(ra) # 55a <exit>

000000000000022c <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret

0000000000000238 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret

0000000000000244 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 24a:	4501                	li	a0,0
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret

0000000000000252 <tyield>:

void tyield()
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <twhoami>:

uint8 twhoami()
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 264:	4501                	li	a0,0
 266:	6422                	ld	s0,8(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret

000000000000026c <tswtch>:
 26c:	00153023          	sd	ra,0(a0)
 270:	00253423          	sd	sp,8(a0)
 274:	e900                	sd	s0,16(a0)
 276:	ed04                	sd	s1,24(a0)
 278:	03253023          	sd	s2,32(a0)
 27c:	03353423          	sd	s3,40(a0)
 280:	03453823          	sd	s4,48(a0)
 284:	03553c23          	sd	s5,56(a0)
 288:	05653023          	sd	s6,64(a0)
 28c:	05753423          	sd	s7,72(a0)
 290:	05853823          	sd	s8,80(a0)
 294:	05953c23          	sd	s9,88(a0)
 298:	07a53023          	sd	s10,96(a0)
 29c:	07b53423          	sd	s11,104(a0)
 2a0:	0005b083          	ld	ra,0(a1)
 2a4:	0085b103          	ld	sp,8(a1)
 2a8:	6980                	ld	s0,16(a1)
 2aa:	6d84                	ld	s1,24(a1)
 2ac:	0205b903          	ld	s2,32(a1)
 2b0:	0285b983          	ld	s3,40(a1)
 2b4:	0305ba03          	ld	s4,48(a1)
 2b8:	0385ba83          	ld	s5,56(a1)
 2bc:	0405bb03          	ld	s6,64(a1)
 2c0:	0485bb83          	ld	s7,72(a1)
 2c4:	0505bc03          	ld	s8,80(a1)
 2c8:	0585bc83          	ld	s9,88(a1)
 2cc:	0605bd03          	ld	s10,96(a1)
 2d0:	0685bd83          	ld	s11,104(a1)
 2d4:	8082                	ret

00000000000002d6 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 2de:	00000097          	auipc	ra,0x0
 2e2:	d22080e7          	jalr	-734(ra) # 0 <main>
    exit(res);
 2e6:	00000097          	auipc	ra,0x0
 2ea:	274080e7          	jalr	628(ra) # 55a <exit>

00000000000002ee <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 2f4:	87aa                	mv	a5,a0
 2f6:	0585                	addi	a1,a1,1
 2f8:	0785                	addi	a5,a5,1
 2fa:	fff5c703          	lbu	a4,-1(a1)
 2fe:	fee78fa3          	sb	a4,-1(a5)
 302:	fb75                	bnez	a4,2f6 <strcpy+0x8>
        ;
    return os;
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret

000000000000030a <strcmp>:

int strcmp(const char *p, const char *q)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 310:	00054783          	lbu	a5,0(a0)
 314:	cb91                	beqz	a5,328 <strcmp+0x1e>
 316:	0005c703          	lbu	a4,0(a1)
 31a:	00f71763          	bne	a4,a5,328 <strcmp+0x1e>
        p++, q++;
 31e:	0505                	addi	a0,a0,1
 320:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 322:	00054783          	lbu	a5,0(a0)
 326:	fbe5                	bnez	a5,316 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 328:	0005c503          	lbu	a0,0(a1)
}
 32c:	40a7853b          	subw	a0,a5,a0
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <strlen>:

uint strlen(const char *s)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 33c:	00054783          	lbu	a5,0(a0)
 340:	cf91                	beqz	a5,35c <strlen+0x26>
 342:	0505                	addi	a0,a0,1
 344:	87aa                	mv	a5,a0
 346:	4685                	li	a3,1
 348:	9e89                	subw	a3,a3,a0
 34a:	00f6853b          	addw	a0,a3,a5
 34e:	0785                	addi	a5,a5,1
 350:	fff7c703          	lbu	a4,-1(a5)
 354:	fb7d                	bnez	a4,34a <strlen+0x14>
        ;
    return n;
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret
    for (n = 0; s[n]; n++)
 35c:	4501                	li	a0,0
 35e:	bfe5                	j	356 <strlen+0x20>

0000000000000360 <memset>:

void *
memset(void *dst, int c, uint n)
{
 360:	1141                	addi	sp,sp,-16
 362:	e422                	sd	s0,8(sp)
 364:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 366:	ca19                	beqz	a2,37c <memset+0x1c>
 368:	87aa                	mv	a5,a0
 36a:	1602                	slli	a2,a2,0x20
 36c:	9201                	srli	a2,a2,0x20
 36e:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 372:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 376:	0785                	addi	a5,a5,1
 378:	fee79de3          	bne	a5,a4,372 <memset+0x12>
    }
    return dst;
}
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <strchr>:

char *
strchr(const char *s, char c)
{
 382:	1141                	addi	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	addi	s0,sp,16
    for (; *s; s++)
 388:	00054783          	lbu	a5,0(a0)
 38c:	cb99                	beqz	a5,3a2 <strchr+0x20>
        if (*s == c)
 38e:	00f58763          	beq	a1,a5,39c <strchr+0x1a>
    for (; *s; s++)
 392:	0505                	addi	a0,a0,1
 394:	00054783          	lbu	a5,0(a0)
 398:	fbfd                	bnez	a5,38e <strchr+0xc>
            return (char *)s;
    return 0;
 39a:	4501                	li	a0,0
}
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
    return 0;
 3a2:	4501                	li	a0,0
 3a4:	bfe5                	j	39c <strchr+0x1a>

00000000000003a6 <gets>:

char *
gets(char *buf, int max)
{
 3a6:	711d                	addi	sp,sp,-96
 3a8:	ec86                	sd	ra,88(sp)
 3aa:	e8a2                	sd	s0,80(sp)
 3ac:	e4a6                	sd	s1,72(sp)
 3ae:	e0ca                	sd	s2,64(sp)
 3b0:	fc4e                	sd	s3,56(sp)
 3b2:	f852                	sd	s4,48(sp)
 3b4:	f456                	sd	s5,40(sp)
 3b6:	f05a                	sd	s6,32(sp)
 3b8:	ec5e                	sd	s7,24(sp)
 3ba:	1080                	addi	s0,sp,96
 3bc:	8baa                	mv	s7,a0
 3be:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 3c0:	892a                	mv	s2,a0
 3c2:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 3c4:	4aa9                	li	s5,10
 3c6:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 3c8:	89a6                	mv	s3,s1
 3ca:	2485                	addiw	s1,s1,1
 3cc:	0344d863          	bge	s1,s4,3fc <gets+0x56>
        cc = read(0, &c, 1);
 3d0:	4605                	li	a2,1
 3d2:	faf40593          	addi	a1,s0,-81
 3d6:	4501                	li	a0,0
 3d8:	00000097          	auipc	ra,0x0
 3dc:	19a080e7          	jalr	410(ra) # 572 <read>
        if (cc < 1)
 3e0:	00a05e63          	blez	a0,3fc <gets+0x56>
        buf[i++] = c;
 3e4:	faf44783          	lbu	a5,-81(s0)
 3e8:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 3ec:	01578763          	beq	a5,s5,3fa <gets+0x54>
 3f0:	0905                	addi	s2,s2,1
 3f2:	fd679be3          	bne	a5,s6,3c8 <gets+0x22>
    for (i = 0; i + 1 < max;)
 3f6:	89a6                	mv	s3,s1
 3f8:	a011                	j	3fc <gets+0x56>
 3fa:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 3fc:	99de                	add	s3,s3,s7
 3fe:	00098023          	sb	zero,0(s3)
    return buf;
}
 402:	855e                	mv	a0,s7
 404:	60e6                	ld	ra,88(sp)
 406:	6446                	ld	s0,80(sp)
 408:	64a6                	ld	s1,72(sp)
 40a:	6906                	ld	s2,64(sp)
 40c:	79e2                	ld	s3,56(sp)
 40e:	7a42                	ld	s4,48(sp)
 410:	7aa2                	ld	s5,40(sp)
 412:	7b02                	ld	s6,32(sp)
 414:	6be2                	ld	s7,24(sp)
 416:	6125                	addi	sp,sp,96
 418:	8082                	ret

000000000000041a <stat>:

int stat(const char *n, struct stat *st)
{
 41a:	1101                	addi	sp,sp,-32
 41c:	ec06                	sd	ra,24(sp)
 41e:	e822                	sd	s0,16(sp)
 420:	e426                	sd	s1,8(sp)
 422:	e04a                	sd	s2,0(sp)
 424:	1000                	addi	s0,sp,32
 426:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 428:	4581                	li	a1,0
 42a:	00000097          	auipc	ra,0x0
 42e:	170080e7          	jalr	368(ra) # 59a <open>
    if (fd < 0)
 432:	02054563          	bltz	a0,45c <stat+0x42>
 436:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 438:	85ca                	mv	a1,s2
 43a:	00000097          	auipc	ra,0x0
 43e:	178080e7          	jalr	376(ra) # 5b2 <fstat>
 442:	892a                	mv	s2,a0
    close(fd);
 444:	8526                	mv	a0,s1
 446:	00000097          	auipc	ra,0x0
 44a:	13c080e7          	jalr	316(ra) # 582 <close>
    return r;
}
 44e:	854a                	mv	a0,s2
 450:	60e2                	ld	ra,24(sp)
 452:	6442                	ld	s0,16(sp)
 454:	64a2                	ld	s1,8(sp)
 456:	6902                	ld	s2,0(sp)
 458:	6105                	addi	sp,sp,32
 45a:	8082                	ret
        return -1;
 45c:	597d                	li	s2,-1
 45e:	bfc5                	j	44e <stat+0x34>

0000000000000460 <atoi>:

int atoi(const char *s)
{
 460:	1141                	addi	sp,sp,-16
 462:	e422                	sd	s0,8(sp)
 464:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 466:	00054683          	lbu	a3,0(a0)
 46a:	fd06879b          	addiw	a5,a3,-48
 46e:	0ff7f793          	zext.b	a5,a5
 472:	4625                	li	a2,9
 474:	02f66863          	bltu	a2,a5,4a4 <atoi+0x44>
 478:	872a                	mv	a4,a0
    n = 0;
 47a:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 47c:	0705                	addi	a4,a4,1
 47e:	0025179b          	slliw	a5,a0,0x2
 482:	9fa9                	addw	a5,a5,a0
 484:	0017979b          	slliw	a5,a5,0x1
 488:	9fb5                	addw	a5,a5,a3
 48a:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 48e:	00074683          	lbu	a3,0(a4)
 492:	fd06879b          	addiw	a5,a3,-48
 496:	0ff7f793          	zext.b	a5,a5
 49a:	fef671e3          	bgeu	a2,a5,47c <atoi+0x1c>
    return n;
}
 49e:	6422                	ld	s0,8(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret
    n = 0;
 4a4:	4501                	li	a0,0
 4a6:	bfe5                	j	49e <atoi+0x3e>

00000000000004a8 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 4a8:	1141                	addi	sp,sp,-16
 4aa:	e422                	sd	s0,8(sp)
 4ac:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 4ae:	02b57463          	bgeu	a0,a1,4d6 <memmove+0x2e>
    {
        while (n-- > 0)
 4b2:	00c05f63          	blez	a2,4d0 <memmove+0x28>
 4b6:	1602                	slli	a2,a2,0x20
 4b8:	9201                	srli	a2,a2,0x20
 4ba:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 4be:	872a                	mv	a4,a0
            *dst++ = *src++;
 4c0:	0585                	addi	a1,a1,1
 4c2:	0705                	addi	a4,a4,1
 4c4:	fff5c683          	lbu	a3,-1(a1)
 4c8:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 4cc:	fee79ae3          	bne	a5,a4,4c0 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 4d0:	6422                	ld	s0,8(sp)
 4d2:	0141                	addi	sp,sp,16
 4d4:	8082                	ret
        dst += n;
 4d6:	00c50733          	add	a4,a0,a2
        src += n;
 4da:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 4dc:	fec05ae3          	blez	a2,4d0 <memmove+0x28>
 4e0:	fff6079b          	addiw	a5,a2,-1
 4e4:	1782                	slli	a5,a5,0x20
 4e6:	9381                	srli	a5,a5,0x20
 4e8:	fff7c793          	not	a5,a5
 4ec:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 4ee:	15fd                	addi	a1,a1,-1
 4f0:	177d                	addi	a4,a4,-1
 4f2:	0005c683          	lbu	a3,0(a1)
 4f6:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 4fa:	fee79ae3          	bne	a5,a4,4ee <memmove+0x46>
 4fe:	bfc9                	j	4d0 <memmove+0x28>

0000000000000500 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 500:	1141                	addi	sp,sp,-16
 502:	e422                	sd	s0,8(sp)
 504:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 506:	ca05                	beqz	a2,536 <memcmp+0x36>
 508:	fff6069b          	addiw	a3,a2,-1
 50c:	1682                	slli	a3,a3,0x20
 50e:	9281                	srli	a3,a3,0x20
 510:	0685                	addi	a3,a3,1
 512:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 514:	00054783          	lbu	a5,0(a0)
 518:	0005c703          	lbu	a4,0(a1)
 51c:	00e79863          	bne	a5,a4,52c <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 520:	0505                	addi	a0,a0,1
        p2++;
 522:	0585                	addi	a1,a1,1
    while (n-- > 0)
 524:	fed518e3          	bne	a0,a3,514 <memcmp+0x14>
    }
    return 0;
 528:	4501                	li	a0,0
 52a:	a019                	j	530 <memcmp+0x30>
            return *p1 - *p2;
 52c:	40e7853b          	subw	a0,a5,a4
}
 530:	6422                	ld	s0,8(sp)
 532:	0141                	addi	sp,sp,16
 534:	8082                	ret
    return 0;
 536:	4501                	li	a0,0
 538:	bfe5                	j	530 <memcmp+0x30>

000000000000053a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 53a:	1141                	addi	sp,sp,-16
 53c:	e406                	sd	ra,8(sp)
 53e:	e022                	sd	s0,0(sp)
 540:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 542:	00000097          	auipc	ra,0x0
 546:	f66080e7          	jalr	-154(ra) # 4a8 <memmove>
}
 54a:	60a2                	ld	ra,8(sp)
 54c:	6402                	ld	s0,0(sp)
 54e:	0141                	addi	sp,sp,16
 550:	8082                	ret

0000000000000552 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 552:	4885                	li	a7,1
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <exit>:
.global exit
exit:
 li a7, SYS_exit
 55a:	4889                	li	a7,2
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <wait>:
.global wait
wait:
 li a7, SYS_wait
 562:	488d                	li	a7,3
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 56a:	4891                	li	a7,4
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <read>:
.global read
read:
 li a7, SYS_read
 572:	4895                	li	a7,5
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <write>:
.global write
write:
 li a7, SYS_write
 57a:	48c1                	li	a7,16
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <close>:
.global close
close:
 li a7, SYS_close
 582:	48d5                	li	a7,21
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <kill>:
.global kill
kill:
 li a7, SYS_kill
 58a:	4899                	li	a7,6
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <exec>:
.global exec
exec:
 li a7, SYS_exec
 592:	489d                	li	a7,7
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <open>:
.global open
open:
 li a7, SYS_open
 59a:	48bd                	li	a7,15
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5a2:	48c5                	li	a7,17
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5aa:	48c9                	li	a7,18
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5b2:	48a1                	li	a7,8
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <link>:
.global link
link:
 li a7, SYS_link
 5ba:	48cd                	li	a7,19
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5c2:	48d1                	li	a7,20
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ca:	48a5                	li	a7,9
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5d2:	48a9                	li	a7,10
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5da:	48ad                	li	a7,11
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5e2:	48b1                	li	a7,12
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ea:	48b5                	li	a7,13
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5f2:	48b9                	li	a7,14
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <ps>:
.global ps
ps:
 li a7, SYS_ps
 5fa:	48d9                	li	a7,22
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 602:	48dd                	li	a7,23
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 60a:	48e1                	li	a7,24
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 612:	1101                	addi	sp,sp,-32
 614:	ec06                	sd	ra,24(sp)
 616:	e822                	sd	s0,16(sp)
 618:	1000                	addi	s0,sp,32
 61a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 61e:	4605                	li	a2,1
 620:	fef40593          	addi	a1,s0,-17
 624:	00000097          	auipc	ra,0x0
 628:	f56080e7          	jalr	-170(ra) # 57a <write>
}
 62c:	60e2                	ld	ra,24(sp)
 62e:	6442                	ld	s0,16(sp)
 630:	6105                	addi	sp,sp,32
 632:	8082                	ret

0000000000000634 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 634:	7139                	addi	sp,sp,-64
 636:	fc06                	sd	ra,56(sp)
 638:	f822                	sd	s0,48(sp)
 63a:	f426                	sd	s1,40(sp)
 63c:	f04a                	sd	s2,32(sp)
 63e:	ec4e                	sd	s3,24(sp)
 640:	0080                	addi	s0,sp,64
 642:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 644:	c299                	beqz	a3,64a <printint+0x16>
 646:	0805c963          	bltz	a1,6d8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 64a:	2581                	sext.w	a1,a1
  neg = 0;
 64c:	4881                	li	a7,0
 64e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 652:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 654:	2601                	sext.w	a2,a2
 656:	00000517          	auipc	a0,0x0
 65a:	52a50513          	addi	a0,a0,1322 # b80 <digits>
 65e:	883a                	mv	a6,a4
 660:	2705                	addiw	a4,a4,1
 662:	02c5f7bb          	remuw	a5,a1,a2
 666:	1782                	slli	a5,a5,0x20
 668:	9381                	srli	a5,a5,0x20
 66a:	97aa                	add	a5,a5,a0
 66c:	0007c783          	lbu	a5,0(a5)
 670:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 674:	0005879b          	sext.w	a5,a1
 678:	02c5d5bb          	divuw	a1,a1,a2
 67c:	0685                	addi	a3,a3,1
 67e:	fec7f0e3          	bgeu	a5,a2,65e <printint+0x2a>
  if(neg)
 682:	00088c63          	beqz	a7,69a <printint+0x66>
    buf[i++] = '-';
 686:	fd070793          	addi	a5,a4,-48
 68a:	00878733          	add	a4,a5,s0
 68e:	02d00793          	li	a5,45
 692:	fef70823          	sb	a5,-16(a4)
 696:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 69a:	02e05863          	blez	a4,6ca <printint+0x96>
 69e:	fc040793          	addi	a5,s0,-64
 6a2:	00e78933          	add	s2,a5,a4
 6a6:	fff78993          	addi	s3,a5,-1
 6aa:	99ba                	add	s3,s3,a4
 6ac:	377d                	addiw	a4,a4,-1
 6ae:	1702                	slli	a4,a4,0x20
 6b0:	9301                	srli	a4,a4,0x20
 6b2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6b6:	fff94583          	lbu	a1,-1(s2)
 6ba:	8526                	mv	a0,s1
 6bc:	00000097          	auipc	ra,0x0
 6c0:	f56080e7          	jalr	-170(ra) # 612 <putc>
  while(--i >= 0)
 6c4:	197d                	addi	s2,s2,-1
 6c6:	ff3918e3          	bne	s2,s3,6b6 <printint+0x82>
}
 6ca:	70e2                	ld	ra,56(sp)
 6cc:	7442                	ld	s0,48(sp)
 6ce:	74a2                	ld	s1,40(sp)
 6d0:	7902                	ld	s2,32(sp)
 6d2:	69e2                	ld	s3,24(sp)
 6d4:	6121                	addi	sp,sp,64
 6d6:	8082                	ret
    x = -xx;
 6d8:	40b005bb          	negw	a1,a1
    neg = 1;
 6dc:	4885                	li	a7,1
    x = -xx;
 6de:	bf85                	j	64e <printint+0x1a>

00000000000006e0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6e0:	7119                	addi	sp,sp,-128
 6e2:	fc86                	sd	ra,120(sp)
 6e4:	f8a2                	sd	s0,112(sp)
 6e6:	f4a6                	sd	s1,104(sp)
 6e8:	f0ca                	sd	s2,96(sp)
 6ea:	ecce                	sd	s3,88(sp)
 6ec:	e8d2                	sd	s4,80(sp)
 6ee:	e4d6                	sd	s5,72(sp)
 6f0:	e0da                	sd	s6,64(sp)
 6f2:	fc5e                	sd	s7,56(sp)
 6f4:	f862                	sd	s8,48(sp)
 6f6:	f466                	sd	s9,40(sp)
 6f8:	f06a                	sd	s10,32(sp)
 6fa:	ec6e                	sd	s11,24(sp)
 6fc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6fe:	0005c903          	lbu	s2,0(a1)
 702:	18090f63          	beqz	s2,8a0 <vprintf+0x1c0>
 706:	8aaa                	mv	s5,a0
 708:	8b32                	mv	s6,a2
 70a:	00158493          	addi	s1,a1,1
  state = 0;
 70e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 710:	02500a13          	li	s4,37
 714:	4c55                	li	s8,21
 716:	00000c97          	auipc	s9,0x0
 71a:	412c8c93          	addi	s9,s9,1042 # b28 <malloc+0x184>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 71e:	02800d93          	li	s11,40
  putc(fd, 'x');
 722:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 724:	00000b97          	auipc	s7,0x0
 728:	45cb8b93          	addi	s7,s7,1116 # b80 <digits>
 72c:	a839                	j	74a <vprintf+0x6a>
        putc(fd, c);
 72e:	85ca                	mv	a1,s2
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	ee0080e7          	jalr	-288(ra) # 612 <putc>
 73a:	a019                	j	740 <vprintf+0x60>
    } else if(state == '%'){
 73c:	01498d63          	beq	s3,s4,756 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 740:	0485                	addi	s1,s1,1
 742:	fff4c903          	lbu	s2,-1(s1)
 746:	14090d63          	beqz	s2,8a0 <vprintf+0x1c0>
    if(state == 0){
 74a:	fe0999e3          	bnez	s3,73c <vprintf+0x5c>
      if(c == '%'){
 74e:	ff4910e3          	bne	s2,s4,72e <vprintf+0x4e>
        state = '%';
 752:	89d2                	mv	s3,s4
 754:	b7f5                	j	740 <vprintf+0x60>
      if(c == 'd'){
 756:	11490c63          	beq	s2,s4,86e <vprintf+0x18e>
 75a:	f9d9079b          	addiw	a5,s2,-99
 75e:	0ff7f793          	zext.b	a5,a5
 762:	10fc6e63          	bltu	s8,a5,87e <vprintf+0x19e>
 766:	f9d9079b          	addiw	a5,s2,-99
 76a:	0ff7f713          	zext.b	a4,a5
 76e:	10ec6863          	bltu	s8,a4,87e <vprintf+0x19e>
 772:	00271793          	slli	a5,a4,0x2
 776:	97e6                	add	a5,a5,s9
 778:	439c                	lw	a5,0(a5)
 77a:	97e6                	add	a5,a5,s9
 77c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 77e:	008b0913          	addi	s2,s6,8
 782:	4685                	li	a3,1
 784:	4629                	li	a2,10
 786:	000b2583          	lw	a1,0(s6)
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	ea8080e7          	jalr	-344(ra) # 634 <printint>
 794:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 796:	4981                	li	s3,0
 798:	b765                	j	740 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 79a:	008b0913          	addi	s2,s6,8
 79e:	4681                	li	a3,0
 7a0:	4629                	li	a2,10
 7a2:	000b2583          	lw	a1,0(s6)
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e8c080e7          	jalr	-372(ra) # 634 <printint>
 7b0:	8b4a                	mv	s6,s2
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	b771                	j	740 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7b6:	008b0913          	addi	s2,s6,8
 7ba:	4681                	li	a3,0
 7bc:	866a                	mv	a2,s10
 7be:	000b2583          	lw	a1,0(s6)
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	e70080e7          	jalr	-400(ra) # 634 <printint>
 7cc:	8b4a                	mv	s6,s2
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	bf85                	j	740 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7d2:	008b0793          	addi	a5,s6,8
 7d6:	f8f43423          	sd	a5,-120(s0)
 7da:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7de:	03000593          	li	a1,48
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	e2e080e7          	jalr	-466(ra) # 612 <putc>
  putc(fd, 'x');
 7ec:	07800593          	li	a1,120
 7f0:	8556                	mv	a0,s5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	e20080e7          	jalr	-480(ra) # 612 <putc>
 7fa:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fc:	03c9d793          	srli	a5,s3,0x3c
 800:	97de                	add	a5,a5,s7
 802:	0007c583          	lbu	a1,0(a5)
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	e0a080e7          	jalr	-502(ra) # 612 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 810:	0992                	slli	s3,s3,0x4
 812:	397d                	addiw	s2,s2,-1
 814:	fe0914e3          	bnez	s2,7fc <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 818:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 81c:	4981                	li	s3,0
 81e:	b70d                	j	740 <vprintf+0x60>
        s = va_arg(ap, char*);
 820:	008b0913          	addi	s2,s6,8
 824:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 828:	02098163          	beqz	s3,84a <vprintf+0x16a>
        while(*s != 0){
 82c:	0009c583          	lbu	a1,0(s3)
 830:	c5ad                	beqz	a1,89a <vprintf+0x1ba>
          putc(fd, *s);
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	dde080e7          	jalr	-546(ra) # 612 <putc>
          s++;
 83c:	0985                	addi	s3,s3,1
        while(*s != 0){
 83e:	0009c583          	lbu	a1,0(s3)
 842:	f9e5                	bnez	a1,832 <vprintf+0x152>
        s = va_arg(ap, char*);
 844:	8b4a                	mv	s6,s2
      state = 0;
 846:	4981                	li	s3,0
 848:	bde5                	j	740 <vprintf+0x60>
          s = "(null)";
 84a:	00000997          	auipc	s3,0x0
 84e:	2d698993          	addi	s3,s3,726 # b20 <malloc+0x17c>
        while(*s != 0){
 852:	85ee                	mv	a1,s11
 854:	bff9                	j	832 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 856:	008b0913          	addi	s2,s6,8
 85a:	000b4583          	lbu	a1,0(s6)
 85e:	8556                	mv	a0,s5
 860:	00000097          	auipc	ra,0x0
 864:	db2080e7          	jalr	-590(ra) # 612 <putc>
 868:	8b4a                	mv	s6,s2
      state = 0;
 86a:	4981                	li	s3,0
 86c:	bdd1                	j	740 <vprintf+0x60>
        putc(fd, c);
 86e:	85d2                	mv	a1,s4
 870:	8556                	mv	a0,s5
 872:	00000097          	auipc	ra,0x0
 876:	da0080e7          	jalr	-608(ra) # 612 <putc>
      state = 0;
 87a:	4981                	li	s3,0
 87c:	b5d1                	j	740 <vprintf+0x60>
        putc(fd, '%');
 87e:	85d2                	mv	a1,s4
 880:	8556                	mv	a0,s5
 882:	00000097          	auipc	ra,0x0
 886:	d90080e7          	jalr	-624(ra) # 612 <putc>
        putc(fd, c);
 88a:	85ca                	mv	a1,s2
 88c:	8556                	mv	a0,s5
 88e:	00000097          	auipc	ra,0x0
 892:	d84080e7          	jalr	-636(ra) # 612 <putc>
      state = 0;
 896:	4981                	li	s3,0
 898:	b565                	j	740 <vprintf+0x60>
        s = va_arg(ap, char*);
 89a:	8b4a                	mv	s6,s2
      state = 0;
 89c:	4981                	li	s3,0
 89e:	b54d                	j	740 <vprintf+0x60>
    }
  }
}
 8a0:	70e6                	ld	ra,120(sp)
 8a2:	7446                	ld	s0,112(sp)
 8a4:	74a6                	ld	s1,104(sp)
 8a6:	7906                	ld	s2,96(sp)
 8a8:	69e6                	ld	s3,88(sp)
 8aa:	6a46                	ld	s4,80(sp)
 8ac:	6aa6                	ld	s5,72(sp)
 8ae:	6b06                	ld	s6,64(sp)
 8b0:	7be2                	ld	s7,56(sp)
 8b2:	7c42                	ld	s8,48(sp)
 8b4:	7ca2                	ld	s9,40(sp)
 8b6:	7d02                	ld	s10,32(sp)
 8b8:	6de2                	ld	s11,24(sp)
 8ba:	6109                	addi	sp,sp,128
 8bc:	8082                	ret

00000000000008be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8be:	715d                	addi	sp,sp,-80
 8c0:	ec06                	sd	ra,24(sp)
 8c2:	e822                	sd	s0,16(sp)
 8c4:	1000                	addi	s0,sp,32
 8c6:	e010                	sd	a2,0(s0)
 8c8:	e414                	sd	a3,8(s0)
 8ca:	e818                	sd	a4,16(s0)
 8cc:	ec1c                	sd	a5,24(s0)
 8ce:	03043023          	sd	a6,32(s0)
 8d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8d6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8da:	8622                	mv	a2,s0
 8dc:	00000097          	auipc	ra,0x0
 8e0:	e04080e7          	jalr	-508(ra) # 6e0 <vprintf>
}
 8e4:	60e2                	ld	ra,24(sp)
 8e6:	6442                	ld	s0,16(sp)
 8e8:	6161                	addi	sp,sp,80
 8ea:	8082                	ret

00000000000008ec <printf>:

void
printf(const char *fmt, ...)
{
 8ec:	711d                	addi	sp,sp,-96
 8ee:	ec06                	sd	ra,24(sp)
 8f0:	e822                	sd	s0,16(sp)
 8f2:	1000                	addi	s0,sp,32
 8f4:	e40c                	sd	a1,8(s0)
 8f6:	e810                	sd	a2,16(s0)
 8f8:	ec14                	sd	a3,24(s0)
 8fa:	f018                	sd	a4,32(s0)
 8fc:	f41c                	sd	a5,40(s0)
 8fe:	03043823          	sd	a6,48(s0)
 902:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 906:	00840613          	addi	a2,s0,8
 90a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 90e:	85aa                	mv	a1,a0
 910:	4505                	li	a0,1
 912:	00000097          	auipc	ra,0x0
 916:	dce080e7          	jalr	-562(ra) # 6e0 <vprintf>
}
 91a:	60e2                	ld	ra,24(sp)
 91c:	6442                	ld	s0,16(sp)
 91e:	6125                	addi	sp,sp,96
 920:	8082                	ret

0000000000000922 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 922:	1141                	addi	sp,sp,-16
 924:	e422                	sd	s0,8(sp)
 926:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 928:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92c:	00000797          	auipc	a5,0x0
 930:	6d47b783          	ld	a5,1748(a5) # 1000 <freep>
 934:	a02d                	j	95e <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 936:	4618                	lw	a4,8(a2)
 938:	9f2d                	addw	a4,a4,a1
 93a:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 93e:	6398                	ld	a4,0(a5)
 940:	6310                	ld	a2,0(a4)
 942:	a83d                	j	980 <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 944:	ff852703          	lw	a4,-8(a0)
 948:	9f31                	addw	a4,a4,a2
 94a:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 94c:	ff053683          	ld	a3,-16(a0)
 950:	a091                	j	994 <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 952:	6398                	ld	a4,0(a5)
 954:	00e7e463          	bltu	a5,a4,95c <free+0x3a>
 958:	00e6ea63          	bltu	a3,a4,96c <free+0x4a>
{
 95c:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95e:	fed7fae3          	bgeu	a5,a3,952 <free+0x30>
 962:	6398                	ld	a4,0(a5)
 964:	00e6e463          	bltu	a3,a4,96c <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 968:	fee7eae3          	bltu	a5,a4,95c <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 96c:	ff852583          	lw	a1,-8(a0)
 970:	6390                	ld	a2,0(a5)
 972:	02059813          	slli	a6,a1,0x20
 976:	01c85713          	srli	a4,a6,0x1c
 97a:	9736                	add	a4,a4,a3
 97c:	fae60de3          	beq	a2,a4,936 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 980:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 984:	4790                	lw	a2,8(a5)
 986:	02061593          	slli	a1,a2,0x20
 98a:	01c5d713          	srli	a4,a1,0x1c
 98e:	973e                	add	a4,a4,a5
 990:	fae68ae3          	beq	a3,a4,944 <free+0x22>
        p->s.ptr = bp->s.ptr;
 994:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 996:	00000717          	auipc	a4,0x0
 99a:	66f73523          	sd	a5,1642(a4) # 1000 <freep>
}
 99e:	6422                	ld	s0,8(sp)
 9a0:	0141                	addi	sp,sp,16
 9a2:	8082                	ret

00000000000009a4 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 9a4:	7139                	addi	sp,sp,-64
 9a6:	fc06                	sd	ra,56(sp)
 9a8:	f822                	sd	s0,48(sp)
 9aa:	f426                	sd	s1,40(sp)
 9ac:	f04a                	sd	s2,32(sp)
 9ae:	ec4e                	sd	s3,24(sp)
 9b0:	e852                	sd	s4,16(sp)
 9b2:	e456                	sd	s5,8(sp)
 9b4:	e05a                	sd	s6,0(sp)
 9b6:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9b8:	02051493          	slli	s1,a0,0x20
 9bc:	9081                	srli	s1,s1,0x20
 9be:	04bd                	addi	s1,s1,15
 9c0:	8091                	srli	s1,s1,0x4
 9c2:	0014899b          	addiw	s3,s1,1
 9c6:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 9c8:	00000517          	auipc	a0,0x0
 9cc:	63853503          	ld	a0,1592(a0) # 1000 <freep>
 9d0:	c515                	beqz	a0,9fc <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 9d2:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 9d4:	4798                	lw	a4,8(a5)
 9d6:	02977f63          	bgeu	a4,s1,a14 <malloc+0x70>
 9da:	8a4e                	mv	s4,s3
 9dc:	0009871b          	sext.w	a4,s3
 9e0:	6685                	lui	a3,0x1
 9e2:	00d77363          	bgeu	a4,a3,9e8 <malloc+0x44>
 9e6:	6a05                	lui	s4,0x1
 9e8:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 9ec:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 9f0:	00000917          	auipc	s2,0x0
 9f4:	61090913          	addi	s2,s2,1552 # 1000 <freep>
    if (p == (char *)-1)
 9f8:	5afd                	li	s5,-1
 9fa:	a895                	j	a6e <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 9fc:	00000797          	auipc	a5,0x0
 a00:	61478793          	addi	a5,a5,1556 # 1010 <base>
 a04:	00000717          	auipc	a4,0x0
 a08:	5ef73e23          	sd	a5,1532(a4) # 1000 <freep>
 a0c:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 a0e:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 a12:	b7e1                	j	9da <malloc+0x36>
            if (p->s.size == nunits)
 a14:	02e48c63          	beq	s1,a4,a4c <malloc+0xa8>
                p->s.size -= nunits;
 a18:	4137073b          	subw	a4,a4,s3
 a1c:	c798                	sw	a4,8(a5)
                p += p->s.size;
 a1e:	02071693          	slli	a3,a4,0x20
 a22:	01c6d713          	srli	a4,a3,0x1c
 a26:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 a28:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 a2c:	00000717          	auipc	a4,0x0
 a30:	5ca73a23          	sd	a0,1492(a4) # 1000 <freep>
            return (void *)(p + 1);
 a34:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 a38:	70e2                	ld	ra,56(sp)
 a3a:	7442                	ld	s0,48(sp)
 a3c:	74a2                	ld	s1,40(sp)
 a3e:	7902                	ld	s2,32(sp)
 a40:	69e2                	ld	s3,24(sp)
 a42:	6a42                	ld	s4,16(sp)
 a44:	6aa2                	ld	s5,8(sp)
 a46:	6b02                	ld	s6,0(sp)
 a48:	6121                	addi	sp,sp,64
 a4a:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 a4c:	6398                	ld	a4,0(a5)
 a4e:	e118                	sd	a4,0(a0)
 a50:	bff1                	j	a2c <malloc+0x88>
    hp->s.size = nu;
 a52:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 a56:	0541                	addi	a0,a0,16
 a58:	00000097          	auipc	ra,0x0
 a5c:	eca080e7          	jalr	-310(ra) # 922 <free>
    return freep;
 a60:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 a64:	d971                	beqz	a0,a38 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 a66:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 a68:	4798                	lw	a4,8(a5)
 a6a:	fa9775e3          	bgeu	a4,s1,a14 <malloc+0x70>
        if (p == freep)
 a6e:	00093703          	ld	a4,0(s2)
 a72:	853e                	mv	a0,a5
 a74:	fef719e3          	bne	a4,a5,a66 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 a78:	8552                	mv	a0,s4
 a7a:	00000097          	auipc	ra,0x0
 a7e:	b68080e7          	jalr	-1176(ra) # 5e2 <sbrk>
    if (p == (char *)-1)
 a82:	fd5518e3          	bne	a0,s5,a52 <malloc+0xae>
                return 0;
 a86:	4501                	li	a0,0
 a88:	bf45                	j	a38 <malloc+0x94>
