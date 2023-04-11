
user/_congen:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:
#include "user/user.h"

#define N 5

void print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
    write(1, s, strlen(s));
   c:	00000097          	auipc	ra,0x0
  10:	304080e7          	jalr	772(ra) # 310 <strlen>
  14:	0005061b          	sext.w	a2,a0
  18:	85a6                	mv	a1,s1
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	538080e7          	jalr	1336(ra) # 554 <write>
}
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret

000000000000002e <forktest>:

void forktest(void)
{
  2e:	7139                	addi	sp,sp,-64
  30:	fc06                	sd	ra,56(sp)
  32:	f822                	sd	s0,48(sp)
  34:	f426                	sd	s1,40(sp)
  36:	f04a                	sd	s2,32(sp)
  38:	ec4e                	sd	s3,24(sp)
  3a:	e852                	sd	s4,16(sp)
  3c:	e456                	sd	s5,8(sp)
  3e:	e05a                	sd	s6,0(sp)
  40:	0080                	addi	s0,sp,64
    int n, pid;

    print("fork test\n");
  42:	00001517          	auipc	a0,0x1
  46:	a2e50513          	addi	a0,a0,-1490 # a70 <malloc+0xf2>
  4a:	00000097          	auipc	ra,0x0
  4e:	fb6080e7          	jalr	-74(ra) # 0 <print>

    for (n = 0; n < N; n++)
  52:	4a01                	li	s4,0
  54:	4495                	li	s1,5
    {
        pid = fork();
  56:	00000097          	auipc	ra,0x0
  5a:	4d6080e7          	jalr	1238(ra) # 52c <fork>
  5e:	892a                	mv	s2,a0
        if (pid < 0)
            break;
        if (pid == 0)
  60:	00a05563          	blez	a0,6a <forktest+0x3c>
    for (n = 0; n < N; n++)
  64:	2a05                	addiw	s4,s4,1
  66:	fe9a18e3          	bne	s4,s1,56 <forktest+0x28>
            break;
    }

    for (unsigned long long i = 0; i < 1000; i++)
  6a:	4481                	li	s1,0
        {
            printf("CHILD %d: %d\n", n, i);
        }
        else
        {
            printf("PARENT: %d\n", i);
  6c:	00001b17          	auipc	s6,0x1
  70:	a24b0b13          	addi	s6,s6,-1500 # a90 <malloc+0x112>
            printf("CHILD %d: %d\n", n, i);
  74:	00001a97          	auipc	s5,0x1
  78:	a0ca8a93          	addi	s5,s5,-1524 # a80 <malloc+0x102>
    for (unsigned long long i = 0; i < 1000; i++)
  7c:	3e800993          	li	s3,1000
  80:	a811                	j	94 <forktest+0x66>
            printf("PARENT: %d\n", i);
  82:	85a6                	mv	a1,s1
  84:	855a                	mv	a0,s6
  86:	00001097          	auipc	ra,0x1
  8a:	840080e7          	jalr	-1984(ra) # 8c6 <printf>
    for (unsigned long long i = 0; i < 1000; i++)
  8e:	0485                	addi	s1,s1,1
  90:	01348c63          	beq	s1,s3,a8 <forktest+0x7a>
        if (pid == 0)
  94:	fe0917e3          	bnez	s2,82 <forktest+0x54>
            printf("CHILD %d: %d\n", n, i);
  98:	8626                	mv	a2,s1
  9a:	85d2                	mv	a1,s4
  9c:	8556                	mv	a0,s5
  9e:	00001097          	auipc	ra,0x1
  a2:	828080e7          	jalr	-2008(ra) # 8c6 <printf>
  a6:	b7e5                	j	8e <forktest+0x60>
        }
    }

    print("fork test OK\n");
  a8:	00001517          	auipc	a0,0x1
  ac:	9f850513          	addi	a0,a0,-1544 # aa0 <malloc+0x122>
  b0:	00000097          	auipc	ra,0x0
  b4:	f50080e7          	jalr	-176(ra) # 0 <print>
}
  b8:	70e2                	ld	ra,56(sp)
  ba:	7442                	ld	s0,48(sp)
  bc:	74a2                	ld	s1,40(sp)
  be:	7902                	ld	s2,32(sp)
  c0:	69e2                	ld	s3,24(sp)
  c2:	6a42                	ld	s4,16(sp)
  c4:	6aa2                	ld	s5,8(sp)
  c6:	6b02                	ld	s6,0(sp)
  c8:	6121                	addi	sp,sp,64
  ca:	8082                	ret

00000000000000cc <main>:

int main(void)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
    forktest();
  d4:	00000097          	auipc	ra,0x0
  d8:	f5a080e7          	jalr	-166(ra) # 2e <forktest>
    exit(0);
  dc:	4501                	li	a0,0
  de:	00000097          	auipc	ra,0x0
  e2:	456080e7          	jalr	1110(ra) # 534 <exit>

00000000000000e6 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	addi	s0,sp,16
    lk->name = name;
  ec:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  ee:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  f2:	57fd                	li	a5,-1
  f4:	00f50823          	sb	a5,16(a0)
}
  f8:	6422                	ld	s0,8(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret

00000000000000fe <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  fe:	00054783          	lbu	a5,0(a0)
 102:	e399                	bnez	a5,108 <holding+0xa>
 104:	4501                	li	a0,0
}
 106:	8082                	ret
{
 108:	1101                	addi	sp,sp,-32
 10a:	ec06                	sd	ra,24(sp)
 10c:	e822                	sd	s0,16(sp)
 10e:	e426                	sd	s1,8(sp)
 110:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
 112:	01054483          	lbu	s1,16(a0)
 116:	00000097          	auipc	ra,0x0
 11a:	122080e7          	jalr	290(ra) # 238 <twhoami>
 11e:	2501                	sext.w	a0,a0
 120:	40a48533          	sub	a0,s1,a0
 124:	00153513          	seqz	a0,a0
}
 128:	60e2                	ld	ra,24(sp)
 12a:	6442                	ld	s0,16(sp)
 12c:	64a2                	ld	s1,8(sp)
 12e:	6105                	addi	sp,sp,32
 130:	8082                	ret

0000000000000132 <acquire>:

void acquire(struct lock *lk)
{
 132:	7179                	addi	sp,sp,-48
 134:	f406                	sd	ra,40(sp)
 136:	f022                	sd	s0,32(sp)
 138:	ec26                	sd	s1,24(sp)
 13a:	e84a                	sd	s2,16(sp)
 13c:	e44e                	sd	s3,8(sp)
 13e:	e052                	sd	s4,0(sp)
 140:	1800                	addi	s0,sp,48
 142:	8a2a                	mv	s4,a0
    if (holding(lk))
 144:	00000097          	auipc	ra,0x0
 148:	fba080e7          	jalr	-70(ra) # fe <holding>
 14c:	e919                	bnez	a0,162 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 14e:	ffca7493          	andi	s1,s4,-4
 152:	003a7913          	andi	s2,s4,3
 156:	0039191b          	slliw	s2,s2,0x3
 15a:	4985                	li	s3,1
 15c:	012999bb          	sllw	s3,s3,s2
 160:	a015                	j	184 <acquire+0x52>
        printf("re-acquiring lock we already hold");
 162:	00001517          	auipc	a0,0x1
 166:	94e50513          	addi	a0,a0,-1714 # ab0 <malloc+0x132>
 16a:	00000097          	auipc	ra,0x0
 16e:	75c080e7          	jalr	1884(ra) # 8c6 <printf>
        exit(-1);
 172:	557d                	li	a0,-1
 174:	00000097          	auipc	ra,0x0
 178:	3c0080e7          	jalr	960(ra) # 534 <exit>
    {
        // give up the cpu for other threads
        tyield();
 17c:	00000097          	auipc	ra,0x0
 180:	0b0080e7          	jalr	176(ra) # 22c <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 184:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 188:	0127d7bb          	srlw	a5,a5,s2
 18c:	0ff7f793          	zext.b	a5,a5
 190:	f7f5                	bnez	a5,17c <acquire+0x4a>
    }

    __sync_synchronize();
 192:	0ff0000f          	fence

    lk->tid = twhoami();
 196:	00000097          	auipc	ra,0x0
 19a:	0a2080e7          	jalr	162(ra) # 238 <twhoami>
 19e:	00aa0823          	sb	a0,16(s4)
}
 1a2:	70a2                	ld	ra,40(sp)
 1a4:	7402                	ld	s0,32(sp)
 1a6:	64e2                	ld	s1,24(sp)
 1a8:	6942                	ld	s2,16(sp)
 1aa:	69a2                	ld	s3,8(sp)
 1ac:	6a02                	ld	s4,0(sp)
 1ae:	6145                	addi	sp,sp,48
 1b0:	8082                	ret

00000000000001b2 <release>:

void release(struct lock *lk)
{
 1b2:	1101                	addi	sp,sp,-32
 1b4:	ec06                	sd	ra,24(sp)
 1b6:	e822                	sd	s0,16(sp)
 1b8:	e426                	sd	s1,8(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	84aa                	mv	s1,a0
    if (!holding(lk))
 1be:	00000097          	auipc	ra,0x0
 1c2:	f40080e7          	jalr	-192(ra) # fe <holding>
 1c6:	c11d                	beqz	a0,1ec <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 1c8:	57fd                	li	a5,-1
 1ca:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 1ce:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 1d2:	0ff0000f          	fence
 1d6:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 1da:	00000097          	auipc	ra,0x0
 1de:	052080e7          	jalr	82(ra) # 22c <tyield>
}
 1e2:	60e2                	ld	ra,24(sp)
 1e4:	6442                	ld	s0,16(sp)
 1e6:	64a2                	ld	s1,8(sp)
 1e8:	6105                	addi	sp,sp,32
 1ea:	8082                	ret
        printf("releasing lock we are not holding");
 1ec:	00001517          	auipc	a0,0x1
 1f0:	8ec50513          	addi	a0,a0,-1812 # ad8 <malloc+0x15a>
 1f4:	00000097          	auipc	ra,0x0
 1f8:	6d2080e7          	jalr	1746(ra) # 8c6 <printf>
        exit(-1);
 1fc:	557d                	li	a0,-1
 1fe:	00000097          	auipc	ra,0x0
 202:	336080e7          	jalr	822(ra) # 534 <exit>

0000000000000206 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret

000000000000021e <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 224:	4501                	li	a0,0
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret

000000000000022c <tyield>:

void tyield()
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret

0000000000000238 <twhoami>:

uint8 twhoami()
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 23e:	4501                	li	a0,0
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret

0000000000000246 <tswtch>:
 246:	00153023          	sd	ra,0(a0)
 24a:	00253423          	sd	sp,8(a0)
 24e:	e900                	sd	s0,16(a0)
 250:	ed04                	sd	s1,24(a0)
 252:	03253023          	sd	s2,32(a0)
 256:	03353423          	sd	s3,40(a0)
 25a:	03453823          	sd	s4,48(a0)
 25e:	03553c23          	sd	s5,56(a0)
 262:	05653023          	sd	s6,64(a0)
 266:	05753423          	sd	s7,72(a0)
 26a:	05853823          	sd	s8,80(a0)
 26e:	05953c23          	sd	s9,88(a0)
 272:	07a53023          	sd	s10,96(a0)
 276:	07b53423          	sd	s11,104(a0)
 27a:	0005b083          	ld	ra,0(a1)
 27e:	0085b103          	ld	sp,8(a1)
 282:	6980                	ld	s0,16(a1)
 284:	6d84                	ld	s1,24(a1)
 286:	0205b903          	ld	s2,32(a1)
 28a:	0285b983          	ld	s3,40(a1)
 28e:	0305ba03          	ld	s4,48(a1)
 292:	0385ba83          	ld	s5,56(a1)
 296:	0405bb03          	ld	s6,64(a1)
 29a:	0485bb83          	ld	s7,72(a1)
 29e:	0505bc03          	ld	s8,80(a1)
 2a2:	0585bc83          	ld	s9,88(a1)
 2a6:	0605bd03          	ld	s10,96(a1)
 2aa:	0685bd83          	ld	s11,104(a1)
 2ae:	8082                	ret

00000000000002b0 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 2b8:	00000097          	auipc	ra,0x0
 2bc:	e14080e7          	jalr	-492(ra) # cc <main>
    exit(res);
 2c0:	00000097          	auipc	ra,0x0
 2c4:	274080e7          	jalr	628(ra) # 534 <exit>

00000000000002c8 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 2ce:	87aa                	mv	a5,a0
 2d0:	0585                	addi	a1,a1,1
 2d2:	0785                	addi	a5,a5,1
 2d4:	fff5c703          	lbu	a4,-1(a1)
 2d8:	fee78fa3          	sb	a4,-1(a5)
 2dc:	fb75                	bnez	a4,2d0 <strcpy+0x8>
        ;
    return os;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <strcmp>:

int strcmp(const char *p, const char *q)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 2ea:	00054783          	lbu	a5,0(a0)
 2ee:	cb91                	beqz	a5,302 <strcmp+0x1e>
 2f0:	0005c703          	lbu	a4,0(a1)
 2f4:	00f71763          	bne	a4,a5,302 <strcmp+0x1e>
        p++, q++;
 2f8:	0505                	addi	a0,a0,1
 2fa:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 2fc:	00054783          	lbu	a5,0(a0)
 300:	fbe5                	bnez	a5,2f0 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 302:	0005c503          	lbu	a0,0(a1)
}
 306:	40a7853b          	subw	a0,a5,a0
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <strlen>:

uint strlen(const char *s)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cf91                	beqz	a5,336 <strlen+0x26>
 31c:	0505                	addi	a0,a0,1
 31e:	87aa                	mv	a5,a0
 320:	4685                	li	a3,1
 322:	9e89                	subw	a3,a3,a0
 324:	00f6853b          	addw	a0,a3,a5
 328:	0785                	addi	a5,a5,1
 32a:	fff7c703          	lbu	a4,-1(a5)
 32e:	fb7d                	bnez	a4,324 <strlen+0x14>
        ;
    return n;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret
    for (n = 0; s[n]; n++)
 336:	4501                	li	a0,0
 338:	bfe5                	j	330 <strlen+0x20>

000000000000033a <memset>:

void *
memset(void *dst, int c, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 340:	ca19                	beqz	a2,356 <memset+0x1c>
 342:	87aa                	mv	a5,a0
 344:	1602                	slli	a2,a2,0x20
 346:	9201                	srli	a2,a2,0x20
 348:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 34c:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 350:	0785                	addi	a5,a5,1
 352:	fee79de3          	bne	a5,a4,34c <memset+0x12>
    }
    return dst;
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret

000000000000035c <strchr>:

char *
strchr(const char *s, char c)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e422                	sd	s0,8(sp)
 360:	0800                	addi	s0,sp,16
    for (; *s; s++)
 362:	00054783          	lbu	a5,0(a0)
 366:	cb99                	beqz	a5,37c <strchr+0x20>
        if (*s == c)
 368:	00f58763          	beq	a1,a5,376 <strchr+0x1a>
    for (; *s; s++)
 36c:	0505                	addi	a0,a0,1
 36e:	00054783          	lbu	a5,0(a0)
 372:	fbfd                	bnez	a5,368 <strchr+0xc>
            return (char *)s;
    return 0;
 374:	4501                	li	a0,0
}
 376:	6422                	ld	s0,8(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret
    return 0;
 37c:	4501                	li	a0,0
 37e:	bfe5                	j	376 <strchr+0x1a>

0000000000000380 <gets>:

char *
gets(char *buf, int max)
{
 380:	711d                	addi	sp,sp,-96
 382:	ec86                	sd	ra,88(sp)
 384:	e8a2                	sd	s0,80(sp)
 386:	e4a6                	sd	s1,72(sp)
 388:	e0ca                	sd	s2,64(sp)
 38a:	fc4e                	sd	s3,56(sp)
 38c:	f852                	sd	s4,48(sp)
 38e:	f456                	sd	s5,40(sp)
 390:	f05a                	sd	s6,32(sp)
 392:	ec5e                	sd	s7,24(sp)
 394:	1080                	addi	s0,sp,96
 396:	8baa                	mv	s7,a0
 398:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 39a:	892a                	mv	s2,a0
 39c:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 39e:	4aa9                	li	s5,10
 3a0:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 3a2:	89a6                	mv	s3,s1
 3a4:	2485                	addiw	s1,s1,1
 3a6:	0344d863          	bge	s1,s4,3d6 <gets+0x56>
        cc = read(0, &c, 1);
 3aa:	4605                	li	a2,1
 3ac:	faf40593          	addi	a1,s0,-81
 3b0:	4501                	li	a0,0
 3b2:	00000097          	auipc	ra,0x0
 3b6:	19a080e7          	jalr	410(ra) # 54c <read>
        if (cc < 1)
 3ba:	00a05e63          	blez	a0,3d6 <gets+0x56>
        buf[i++] = c;
 3be:	faf44783          	lbu	a5,-81(s0)
 3c2:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 3c6:	01578763          	beq	a5,s5,3d4 <gets+0x54>
 3ca:	0905                	addi	s2,s2,1
 3cc:	fd679be3          	bne	a5,s6,3a2 <gets+0x22>
    for (i = 0; i + 1 < max;)
 3d0:	89a6                	mv	s3,s1
 3d2:	a011                	j	3d6 <gets+0x56>
 3d4:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 3d6:	99de                	add	s3,s3,s7
 3d8:	00098023          	sb	zero,0(s3)
    return buf;
}
 3dc:	855e                	mv	a0,s7
 3de:	60e6                	ld	ra,88(sp)
 3e0:	6446                	ld	s0,80(sp)
 3e2:	64a6                	ld	s1,72(sp)
 3e4:	6906                	ld	s2,64(sp)
 3e6:	79e2                	ld	s3,56(sp)
 3e8:	7a42                	ld	s4,48(sp)
 3ea:	7aa2                	ld	s5,40(sp)
 3ec:	7b02                	ld	s6,32(sp)
 3ee:	6be2                	ld	s7,24(sp)
 3f0:	6125                	addi	sp,sp,96
 3f2:	8082                	ret

00000000000003f4 <stat>:

int stat(const char *n, struct stat *st)
{
 3f4:	1101                	addi	sp,sp,-32
 3f6:	ec06                	sd	ra,24(sp)
 3f8:	e822                	sd	s0,16(sp)
 3fa:	e426                	sd	s1,8(sp)
 3fc:	e04a                	sd	s2,0(sp)
 3fe:	1000                	addi	s0,sp,32
 400:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 402:	4581                	li	a1,0
 404:	00000097          	auipc	ra,0x0
 408:	170080e7          	jalr	368(ra) # 574 <open>
    if (fd < 0)
 40c:	02054563          	bltz	a0,436 <stat+0x42>
 410:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 412:	85ca                	mv	a1,s2
 414:	00000097          	auipc	ra,0x0
 418:	178080e7          	jalr	376(ra) # 58c <fstat>
 41c:	892a                	mv	s2,a0
    close(fd);
 41e:	8526                	mv	a0,s1
 420:	00000097          	auipc	ra,0x0
 424:	13c080e7          	jalr	316(ra) # 55c <close>
    return r;
}
 428:	854a                	mv	a0,s2
 42a:	60e2                	ld	ra,24(sp)
 42c:	6442                	ld	s0,16(sp)
 42e:	64a2                	ld	s1,8(sp)
 430:	6902                	ld	s2,0(sp)
 432:	6105                	addi	sp,sp,32
 434:	8082                	ret
        return -1;
 436:	597d                	li	s2,-1
 438:	bfc5                	j	428 <stat+0x34>

000000000000043a <atoi>:

int atoi(const char *s)
{
 43a:	1141                	addi	sp,sp,-16
 43c:	e422                	sd	s0,8(sp)
 43e:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 440:	00054683          	lbu	a3,0(a0)
 444:	fd06879b          	addiw	a5,a3,-48
 448:	0ff7f793          	zext.b	a5,a5
 44c:	4625                	li	a2,9
 44e:	02f66863          	bltu	a2,a5,47e <atoi+0x44>
 452:	872a                	mv	a4,a0
    n = 0;
 454:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 456:	0705                	addi	a4,a4,1
 458:	0025179b          	slliw	a5,a0,0x2
 45c:	9fa9                	addw	a5,a5,a0
 45e:	0017979b          	slliw	a5,a5,0x1
 462:	9fb5                	addw	a5,a5,a3
 464:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 468:	00074683          	lbu	a3,0(a4)
 46c:	fd06879b          	addiw	a5,a3,-48
 470:	0ff7f793          	zext.b	a5,a5
 474:	fef671e3          	bgeu	a2,a5,456 <atoi+0x1c>
    return n;
}
 478:	6422                	ld	s0,8(sp)
 47a:	0141                	addi	sp,sp,16
 47c:	8082                	ret
    n = 0;
 47e:	4501                	li	a0,0
 480:	bfe5                	j	478 <atoi+0x3e>

0000000000000482 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 482:	1141                	addi	sp,sp,-16
 484:	e422                	sd	s0,8(sp)
 486:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 488:	02b57463          	bgeu	a0,a1,4b0 <memmove+0x2e>
    {
        while (n-- > 0)
 48c:	00c05f63          	blez	a2,4aa <memmove+0x28>
 490:	1602                	slli	a2,a2,0x20
 492:	9201                	srli	a2,a2,0x20
 494:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 498:	872a                	mv	a4,a0
            *dst++ = *src++;
 49a:	0585                	addi	a1,a1,1
 49c:	0705                	addi	a4,a4,1
 49e:	fff5c683          	lbu	a3,-1(a1)
 4a2:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 4a6:	fee79ae3          	bne	a5,a4,49a <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 4aa:	6422                	ld	s0,8(sp)
 4ac:	0141                	addi	sp,sp,16
 4ae:	8082                	ret
        dst += n;
 4b0:	00c50733          	add	a4,a0,a2
        src += n;
 4b4:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 4b6:	fec05ae3          	blez	a2,4aa <memmove+0x28>
 4ba:	fff6079b          	addiw	a5,a2,-1
 4be:	1782                	slli	a5,a5,0x20
 4c0:	9381                	srli	a5,a5,0x20
 4c2:	fff7c793          	not	a5,a5
 4c6:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 4c8:	15fd                	addi	a1,a1,-1
 4ca:	177d                	addi	a4,a4,-1
 4cc:	0005c683          	lbu	a3,0(a1)
 4d0:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 4d4:	fee79ae3          	bne	a5,a4,4c8 <memmove+0x46>
 4d8:	bfc9                	j	4aa <memmove+0x28>

00000000000004da <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 4da:	1141                	addi	sp,sp,-16
 4dc:	e422                	sd	s0,8(sp)
 4de:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 4e0:	ca05                	beqz	a2,510 <memcmp+0x36>
 4e2:	fff6069b          	addiw	a3,a2,-1
 4e6:	1682                	slli	a3,a3,0x20
 4e8:	9281                	srli	a3,a3,0x20
 4ea:	0685                	addi	a3,a3,1
 4ec:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 4ee:	00054783          	lbu	a5,0(a0)
 4f2:	0005c703          	lbu	a4,0(a1)
 4f6:	00e79863          	bne	a5,a4,506 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 4fa:	0505                	addi	a0,a0,1
        p2++;
 4fc:	0585                	addi	a1,a1,1
    while (n-- > 0)
 4fe:	fed518e3          	bne	a0,a3,4ee <memcmp+0x14>
    }
    return 0;
 502:	4501                	li	a0,0
 504:	a019                	j	50a <memcmp+0x30>
            return *p1 - *p2;
 506:	40e7853b          	subw	a0,a5,a4
}
 50a:	6422                	ld	s0,8(sp)
 50c:	0141                	addi	sp,sp,16
 50e:	8082                	ret
    return 0;
 510:	4501                	li	a0,0
 512:	bfe5                	j	50a <memcmp+0x30>

0000000000000514 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 514:	1141                	addi	sp,sp,-16
 516:	e406                	sd	ra,8(sp)
 518:	e022                	sd	s0,0(sp)
 51a:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 51c:	00000097          	auipc	ra,0x0
 520:	f66080e7          	jalr	-154(ra) # 482 <memmove>
}
 524:	60a2                	ld	ra,8(sp)
 526:	6402                	ld	s0,0(sp)
 528:	0141                	addi	sp,sp,16
 52a:	8082                	ret

000000000000052c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 52c:	4885                	li	a7,1
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <exit>:
.global exit
exit:
 li a7, SYS_exit
 534:	4889                	li	a7,2
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <wait>:
.global wait
wait:
 li a7, SYS_wait
 53c:	488d                	li	a7,3
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 544:	4891                	li	a7,4
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <read>:
.global read
read:
 li a7, SYS_read
 54c:	4895                	li	a7,5
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <write>:
.global write
write:
 li a7, SYS_write
 554:	48c1                	li	a7,16
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <close>:
.global close
close:
 li a7, SYS_close
 55c:	48d5                	li	a7,21
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <kill>:
.global kill
kill:
 li a7, SYS_kill
 564:	4899                	li	a7,6
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <exec>:
.global exec
exec:
 li a7, SYS_exec
 56c:	489d                	li	a7,7
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <open>:
.global open
open:
 li a7, SYS_open
 574:	48bd                	li	a7,15
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 57c:	48c5                	li	a7,17
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 584:	48c9                	li	a7,18
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 58c:	48a1                	li	a7,8
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <link>:
.global link
link:
 li a7, SYS_link
 594:	48cd                	li	a7,19
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 59c:	48d1                	li	a7,20
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a4:	48a5                	li	a7,9
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ac:	48a9                	li	a7,10
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b4:	48ad                	li	a7,11
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5bc:	48b1                	li	a7,12
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5c4:	48b5                	li	a7,13
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5cc:	48b9                	li	a7,14
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <ps>:
.global ps
ps:
 li a7, SYS_ps
 5d4:	48d9                	li	a7,22
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 5dc:	48dd                	li	a7,23
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 5e4:	48e1                	li	a7,24
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ec:	1101                	addi	sp,sp,-32
 5ee:	ec06                	sd	ra,24(sp)
 5f0:	e822                	sd	s0,16(sp)
 5f2:	1000                	addi	s0,sp,32
 5f4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5f8:	4605                	li	a2,1
 5fa:	fef40593          	addi	a1,s0,-17
 5fe:	00000097          	auipc	ra,0x0
 602:	f56080e7          	jalr	-170(ra) # 554 <write>
}
 606:	60e2                	ld	ra,24(sp)
 608:	6442                	ld	s0,16(sp)
 60a:	6105                	addi	sp,sp,32
 60c:	8082                	ret

000000000000060e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 60e:	7139                	addi	sp,sp,-64
 610:	fc06                	sd	ra,56(sp)
 612:	f822                	sd	s0,48(sp)
 614:	f426                	sd	s1,40(sp)
 616:	f04a                	sd	s2,32(sp)
 618:	ec4e                	sd	s3,24(sp)
 61a:	0080                	addi	s0,sp,64
 61c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 61e:	c299                	beqz	a3,624 <printint+0x16>
 620:	0805c963          	bltz	a1,6b2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 624:	2581                	sext.w	a1,a1
  neg = 0;
 626:	4881                	li	a7,0
 628:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 62c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 62e:	2601                	sext.w	a2,a2
 630:	00000517          	auipc	a0,0x0
 634:	53050513          	addi	a0,a0,1328 # b60 <digits>
 638:	883a                	mv	a6,a4
 63a:	2705                	addiw	a4,a4,1
 63c:	02c5f7bb          	remuw	a5,a1,a2
 640:	1782                	slli	a5,a5,0x20
 642:	9381                	srli	a5,a5,0x20
 644:	97aa                	add	a5,a5,a0
 646:	0007c783          	lbu	a5,0(a5)
 64a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 64e:	0005879b          	sext.w	a5,a1
 652:	02c5d5bb          	divuw	a1,a1,a2
 656:	0685                	addi	a3,a3,1
 658:	fec7f0e3          	bgeu	a5,a2,638 <printint+0x2a>
  if(neg)
 65c:	00088c63          	beqz	a7,674 <printint+0x66>
    buf[i++] = '-';
 660:	fd070793          	addi	a5,a4,-48
 664:	00878733          	add	a4,a5,s0
 668:	02d00793          	li	a5,45
 66c:	fef70823          	sb	a5,-16(a4)
 670:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 674:	02e05863          	blez	a4,6a4 <printint+0x96>
 678:	fc040793          	addi	a5,s0,-64
 67c:	00e78933          	add	s2,a5,a4
 680:	fff78993          	addi	s3,a5,-1
 684:	99ba                	add	s3,s3,a4
 686:	377d                	addiw	a4,a4,-1
 688:	1702                	slli	a4,a4,0x20
 68a:	9301                	srli	a4,a4,0x20
 68c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 690:	fff94583          	lbu	a1,-1(s2)
 694:	8526                	mv	a0,s1
 696:	00000097          	auipc	ra,0x0
 69a:	f56080e7          	jalr	-170(ra) # 5ec <putc>
  while(--i >= 0)
 69e:	197d                	addi	s2,s2,-1
 6a0:	ff3918e3          	bne	s2,s3,690 <printint+0x82>
}
 6a4:	70e2                	ld	ra,56(sp)
 6a6:	7442                	ld	s0,48(sp)
 6a8:	74a2                	ld	s1,40(sp)
 6aa:	7902                	ld	s2,32(sp)
 6ac:	69e2                	ld	s3,24(sp)
 6ae:	6121                	addi	sp,sp,64
 6b0:	8082                	ret
    x = -xx;
 6b2:	40b005bb          	negw	a1,a1
    neg = 1;
 6b6:	4885                	li	a7,1
    x = -xx;
 6b8:	bf85                	j	628 <printint+0x1a>

00000000000006ba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ba:	7119                	addi	sp,sp,-128
 6bc:	fc86                	sd	ra,120(sp)
 6be:	f8a2                	sd	s0,112(sp)
 6c0:	f4a6                	sd	s1,104(sp)
 6c2:	f0ca                	sd	s2,96(sp)
 6c4:	ecce                	sd	s3,88(sp)
 6c6:	e8d2                	sd	s4,80(sp)
 6c8:	e4d6                	sd	s5,72(sp)
 6ca:	e0da                	sd	s6,64(sp)
 6cc:	fc5e                	sd	s7,56(sp)
 6ce:	f862                	sd	s8,48(sp)
 6d0:	f466                	sd	s9,40(sp)
 6d2:	f06a                	sd	s10,32(sp)
 6d4:	ec6e                	sd	s11,24(sp)
 6d6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6d8:	0005c903          	lbu	s2,0(a1)
 6dc:	18090f63          	beqz	s2,87a <vprintf+0x1c0>
 6e0:	8aaa                	mv	s5,a0
 6e2:	8b32                	mv	s6,a2
 6e4:	00158493          	addi	s1,a1,1
  state = 0;
 6e8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6ea:	02500a13          	li	s4,37
 6ee:	4c55                	li	s8,21
 6f0:	00000c97          	auipc	s9,0x0
 6f4:	418c8c93          	addi	s9,s9,1048 # b08 <malloc+0x18a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6f8:	02800d93          	li	s11,40
  putc(fd, 'x');
 6fc:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fe:	00000b97          	auipc	s7,0x0
 702:	462b8b93          	addi	s7,s7,1122 # b60 <digits>
 706:	a839                	j	724 <vprintf+0x6a>
        putc(fd, c);
 708:	85ca                	mv	a1,s2
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	ee0080e7          	jalr	-288(ra) # 5ec <putc>
 714:	a019                	j	71a <vprintf+0x60>
    } else if(state == '%'){
 716:	01498d63          	beq	s3,s4,730 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 71a:	0485                	addi	s1,s1,1
 71c:	fff4c903          	lbu	s2,-1(s1)
 720:	14090d63          	beqz	s2,87a <vprintf+0x1c0>
    if(state == 0){
 724:	fe0999e3          	bnez	s3,716 <vprintf+0x5c>
      if(c == '%'){
 728:	ff4910e3          	bne	s2,s4,708 <vprintf+0x4e>
        state = '%';
 72c:	89d2                	mv	s3,s4
 72e:	b7f5                	j	71a <vprintf+0x60>
      if(c == 'd'){
 730:	11490c63          	beq	s2,s4,848 <vprintf+0x18e>
 734:	f9d9079b          	addiw	a5,s2,-99
 738:	0ff7f793          	zext.b	a5,a5
 73c:	10fc6e63          	bltu	s8,a5,858 <vprintf+0x19e>
 740:	f9d9079b          	addiw	a5,s2,-99
 744:	0ff7f713          	zext.b	a4,a5
 748:	10ec6863          	bltu	s8,a4,858 <vprintf+0x19e>
 74c:	00271793          	slli	a5,a4,0x2
 750:	97e6                	add	a5,a5,s9
 752:	439c                	lw	a5,0(a5)
 754:	97e6                	add	a5,a5,s9
 756:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 758:	008b0913          	addi	s2,s6,8
 75c:	4685                	li	a3,1
 75e:	4629                	li	a2,10
 760:	000b2583          	lw	a1,0(s6)
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	ea8080e7          	jalr	-344(ra) # 60e <printint>
 76e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 770:	4981                	li	s3,0
 772:	b765                	j	71a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 774:	008b0913          	addi	s2,s6,8
 778:	4681                	li	a3,0
 77a:	4629                	li	a2,10
 77c:	000b2583          	lw	a1,0(s6)
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	e8c080e7          	jalr	-372(ra) # 60e <printint>
 78a:	8b4a                	mv	s6,s2
      state = 0;
 78c:	4981                	li	s3,0
 78e:	b771                	j	71a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 790:	008b0913          	addi	s2,s6,8
 794:	4681                	li	a3,0
 796:	866a                	mv	a2,s10
 798:	000b2583          	lw	a1,0(s6)
 79c:	8556                	mv	a0,s5
 79e:	00000097          	auipc	ra,0x0
 7a2:	e70080e7          	jalr	-400(ra) # 60e <printint>
 7a6:	8b4a                	mv	s6,s2
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bf85                	j	71a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7ac:	008b0793          	addi	a5,s6,8
 7b0:	f8f43423          	sd	a5,-120(s0)
 7b4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7b8:	03000593          	li	a1,48
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	e2e080e7          	jalr	-466(ra) # 5ec <putc>
  putc(fd, 'x');
 7c6:	07800593          	li	a1,120
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	e20080e7          	jalr	-480(ra) # 5ec <putc>
 7d4:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7d6:	03c9d793          	srli	a5,s3,0x3c
 7da:	97de                	add	a5,a5,s7
 7dc:	0007c583          	lbu	a1,0(a5)
 7e0:	8556                	mv	a0,s5
 7e2:	00000097          	auipc	ra,0x0
 7e6:	e0a080e7          	jalr	-502(ra) # 5ec <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ea:	0992                	slli	s3,s3,0x4
 7ec:	397d                	addiw	s2,s2,-1
 7ee:	fe0914e3          	bnez	s2,7d6 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7f2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	b70d                	j	71a <vprintf+0x60>
        s = va_arg(ap, char*);
 7fa:	008b0913          	addi	s2,s6,8
 7fe:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 802:	02098163          	beqz	s3,824 <vprintf+0x16a>
        while(*s != 0){
 806:	0009c583          	lbu	a1,0(s3)
 80a:	c5ad                	beqz	a1,874 <vprintf+0x1ba>
          putc(fd, *s);
 80c:	8556                	mv	a0,s5
 80e:	00000097          	auipc	ra,0x0
 812:	dde080e7          	jalr	-546(ra) # 5ec <putc>
          s++;
 816:	0985                	addi	s3,s3,1
        while(*s != 0){
 818:	0009c583          	lbu	a1,0(s3)
 81c:	f9e5                	bnez	a1,80c <vprintf+0x152>
        s = va_arg(ap, char*);
 81e:	8b4a                	mv	s6,s2
      state = 0;
 820:	4981                	li	s3,0
 822:	bde5                	j	71a <vprintf+0x60>
          s = "(null)";
 824:	00000997          	auipc	s3,0x0
 828:	2dc98993          	addi	s3,s3,732 # b00 <malloc+0x182>
        while(*s != 0){
 82c:	85ee                	mv	a1,s11
 82e:	bff9                	j	80c <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 830:	008b0913          	addi	s2,s6,8
 834:	000b4583          	lbu	a1,0(s6)
 838:	8556                	mv	a0,s5
 83a:	00000097          	auipc	ra,0x0
 83e:	db2080e7          	jalr	-590(ra) # 5ec <putc>
 842:	8b4a                	mv	s6,s2
      state = 0;
 844:	4981                	li	s3,0
 846:	bdd1                	j	71a <vprintf+0x60>
        putc(fd, c);
 848:	85d2                	mv	a1,s4
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	da0080e7          	jalr	-608(ra) # 5ec <putc>
      state = 0;
 854:	4981                	li	s3,0
 856:	b5d1                	j	71a <vprintf+0x60>
        putc(fd, '%');
 858:	85d2                	mv	a1,s4
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	d90080e7          	jalr	-624(ra) # 5ec <putc>
        putc(fd, c);
 864:	85ca                	mv	a1,s2
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	d84080e7          	jalr	-636(ra) # 5ec <putc>
      state = 0;
 870:	4981                	li	s3,0
 872:	b565                	j	71a <vprintf+0x60>
        s = va_arg(ap, char*);
 874:	8b4a                	mv	s6,s2
      state = 0;
 876:	4981                	li	s3,0
 878:	b54d                	j	71a <vprintf+0x60>
    }
  }
}
 87a:	70e6                	ld	ra,120(sp)
 87c:	7446                	ld	s0,112(sp)
 87e:	74a6                	ld	s1,104(sp)
 880:	7906                	ld	s2,96(sp)
 882:	69e6                	ld	s3,88(sp)
 884:	6a46                	ld	s4,80(sp)
 886:	6aa6                	ld	s5,72(sp)
 888:	6b06                	ld	s6,64(sp)
 88a:	7be2                	ld	s7,56(sp)
 88c:	7c42                	ld	s8,48(sp)
 88e:	7ca2                	ld	s9,40(sp)
 890:	7d02                	ld	s10,32(sp)
 892:	6de2                	ld	s11,24(sp)
 894:	6109                	addi	sp,sp,128
 896:	8082                	ret

0000000000000898 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 898:	715d                	addi	sp,sp,-80
 89a:	ec06                	sd	ra,24(sp)
 89c:	e822                	sd	s0,16(sp)
 89e:	1000                	addi	s0,sp,32
 8a0:	e010                	sd	a2,0(s0)
 8a2:	e414                	sd	a3,8(s0)
 8a4:	e818                	sd	a4,16(s0)
 8a6:	ec1c                	sd	a5,24(s0)
 8a8:	03043023          	sd	a6,32(s0)
 8ac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8b0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b4:	8622                	mv	a2,s0
 8b6:	00000097          	auipc	ra,0x0
 8ba:	e04080e7          	jalr	-508(ra) # 6ba <vprintf>
}
 8be:	60e2                	ld	ra,24(sp)
 8c0:	6442                	ld	s0,16(sp)
 8c2:	6161                	addi	sp,sp,80
 8c4:	8082                	ret

00000000000008c6 <printf>:

void
printf(const char *fmt, ...)
{
 8c6:	711d                	addi	sp,sp,-96
 8c8:	ec06                	sd	ra,24(sp)
 8ca:	e822                	sd	s0,16(sp)
 8cc:	1000                	addi	s0,sp,32
 8ce:	e40c                	sd	a1,8(s0)
 8d0:	e810                	sd	a2,16(s0)
 8d2:	ec14                	sd	a3,24(s0)
 8d4:	f018                	sd	a4,32(s0)
 8d6:	f41c                	sd	a5,40(s0)
 8d8:	03043823          	sd	a6,48(s0)
 8dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8e0:	00840613          	addi	a2,s0,8
 8e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e8:	85aa                	mv	a1,a0
 8ea:	4505                	li	a0,1
 8ec:	00000097          	auipc	ra,0x0
 8f0:	dce080e7          	jalr	-562(ra) # 6ba <vprintf>
}
 8f4:	60e2                	ld	ra,24(sp)
 8f6:	6442                	ld	s0,16(sp)
 8f8:	6125                	addi	sp,sp,96
 8fa:	8082                	ret

00000000000008fc <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 8fc:	1141                	addi	sp,sp,-16
 8fe:	e422                	sd	s0,8(sp)
 900:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 902:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 906:	00000797          	auipc	a5,0x0
 90a:	6fa7b783          	ld	a5,1786(a5) # 1000 <freep>
 90e:	a02d                	j	938 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 910:	4618                	lw	a4,8(a2)
 912:	9f2d                	addw	a4,a4,a1
 914:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 918:	6398                	ld	a4,0(a5)
 91a:	6310                	ld	a2,0(a4)
 91c:	a83d                	j	95a <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 91e:	ff852703          	lw	a4,-8(a0)
 922:	9f31                	addw	a4,a4,a2
 924:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 926:	ff053683          	ld	a3,-16(a0)
 92a:	a091                	j	96e <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92c:	6398                	ld	a4,0(a5)
 92e:	00e7e463          	bltu	a5,a4,936 <free+0x3a>
 932:	00e6ea63          	bltu	a3,a4,946 <free+0x4a>
{
 936:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 938:	fed7fae3          	bgeu	a5,a3,92c <free+0x30>
 93c:	6398                	ld	a4,0(a5)
 93e:	00e6e463          	bltu	a3,a4,946 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 942:	fee7eae3          	bltu	a5,a4,936 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 946:	ff852583          	lw	a1,-8(a0)
 94a:	6390                	ld	a2,0(a5)
 94c:	02059813          	slli	a6,a1,0x20
 950:	01c85713          	srli	a4,a6,0x1c
 954:	9736                	add	a4,a4,a3
 956:	fae60de3          	beq	a2,a4,910 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 95a:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 95e:	4790                	lw	a2,8(a5)
 960:	02061593          	slli	a1,a2,0x20
 964:	01c5d713          	srli	a4,a1,0x1c
 968:	973e                	add	a4,a4,a5
 96a:	fae68ae3          	beq	a3,a4,91e <free+0x22>
        p->s.ptr = bp->s.ptr;
 96e:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 970:	00000717          	auipc	a4,0x0
 974:	68f73823          	sd	a5,1680(a4) # 1000 <freep>
}
 978:	6422                	ld	s0,8(sp)
 97a:	0141                	addi	sp,sp,16
 97c:	8082                	ret

000000000000097e <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 97e:	7139                	addi	sp,sp,-64
 980:	fc06                	sd	ra,56(sp)
 982:	f822                	sd	s0,48(sp)
 984:	f426                	sd	s1,40(sp)
 986:	f04a                	sd	s2,32(sp)
 988:	ec4e                	sd	s3,24(sp)
 98a:	e852                	sd	s4,16(sp)
 98c:	e456                	sd	s5,8(sp)
 98e:	e05a                	sd	s6,0(sp)
 990:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 992:	02051493          	slli	s1,a0,0x20
 996:	9081                	srli	s1,s1,0x20
 998:	04bd                	addi	s1,s1,15
 99a:	8091                	srli	s1,s1,0x4
 99c:	0014899b          	addiw	s3,s1,1
 9a0:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 9a2:	00000517          	auipc	a0,0x0
 9a6:	65e53503          	ld	a0,1630(a0) # 1000 <freep>
 9aa:	c515                	beqz	a0,9d6 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 9ac:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 9ae:	4798                	lw	a4,8(a5)
 9b0:	02977f63          	bgeu	a4,s1,9ee <malloc+0x70>
 9b4:	8a4e                	mv	s4,s3
 9b6:	0009871b          	sext.w	a4,s3
 9ba:	6685                	lui	a3,0x1
 9bc:	00d77363          	bgeu	a4,a3,9c2 <malloc+0x44>
 9c0:	6a05                	lui	s4,0x1
 9c2:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 9c6:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 9ca:	00000917          	auipc	s2,0x0
 9ce:	63690913          	addi	s2,s2,1590 # 1000 <freep>
    if (p == (char *)-1)
 9d2:	5afd                	li	s5,-1
 9d4:	a895                	j	a48 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 9d6:	00000797          	auipc	a5,0x0
 9da:	63a78793          	addi	a5,a5,1594 # 1010 <base>
 9de:	00000717          	auipc	a4,0x0
 9e2:	62f73123          	sd	a5,1570(a4) # 1000 <freep>
 9e6:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 9e8:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 9ec:	b7e1                	j	9b4 <malloc+0x36>
            if (p->s.size == nunits)
 9ee:	02e48c63          	beq	s1,a4,a26 <malloc+0xa8>
                p->s.size -= nunits;
 9f2:	4137073b          	subw	a4,a4,s3
 9f6:	c798                	sw	a4,8(a5)
                p += p->s.size;
 9f8:	02071693          	slli	a3,a4,0x20
 9fc:	01c6d713          	srli	a4,a3,0x1c
 a00:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 a02:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 a06:	00000717          	auipc	a4,0x0
 a0a:	5ea73d23          	sd	a0,1530(a4) # 1000 <freep>
            return (void *)(p + 1);
 a0e:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 a12:	70e2                	ld	ra,56(sp)
 a14:	7442                	ld	s0,48(sp)
 a16:	74a2                	ld	s1,40(sp)
 a18:	7902                	ld	s2,32(sp)
 a1a:	69e2                	ld	s3,24(sp)
 a1c:	6a42                	ld	s4,16(sp)
 a1e:	6aa2                	ld	s5,8(sp)
 a20:	6b02                	ld	s6,0(sp)
 a22:	6121                	addi	sp,sp,64
 a24:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 a26:	6398                	ld	a4,0(a5)
 a28:	e118                	sd	a4,0(a0)
 a2a:	bff1                	j	a06 <malloc+0x88>
    hp->s.size = nu;
 a2c:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 a30:	0541                	addi	a0,a0,16
 a32:	00000097          	auipc	ra,0x0
 a36:	eca080e7          	jalr	-310(ra) # 8fc <free>
    return freep;
 a3a:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 a3e:	d971                	beqz	a0,a12 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 a40:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 a42:	4798                	lw	a4,8(a5)
 a44:	fa9775e3          	bgeu	a4,s1,9ee <malloc+0x70>
        if (p == freep)
 a48:	00093703          	ld	a4,0(s2)
 a4c:	853e                	mv	a0,a5
 a4e:	fef719e3          	bne	a4,a5,a40 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 a52:	8552                	mv	a0,s4
 a54:	00000097          	auipc	ra,0x0
 a58:	b68080e7          	jalr	-1176(ra) # 5bc <sbrk>
    if (p == (char *)-1)
 a5c:	fd5518e3          	bne	a0,s5,a2c <malloc+0xae>
                return 0;
 a60:	4501                	li	a0,0
 a62:	bf45                	j	a12 <malloc+0x94>
