
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
    struct user_proc *procs = ps(0, 64);
   e:	04000593          	li	a1,64
  12:	4501                	li	a0,0
  14:	00000097          	auipc	ra,0x0
  18:	534080e7          	jalr	1332(ra) # 548 <ps>

    for (int i = 0; i < 64; i++)
  1c:	01450493          	addi	s1,a0,20
  20:	6785                	lui	a5,0x1
  22:	91478793          	addi	a5,a5,-1772 # 914 <malloc+0x22>
  26:	00f50933          	add	s2,a0,a5
    {
        if (procs[i].state == UNUSED)
            break;
        printf("%s (%d): %d\n", procs[i].name, procs[i].pid, procs[i].state);
  2a:	00001997          	auipc	s3,0x1
  2e:	9b698993          	addi	s3,s3,-1610 # 9e0 <malloc+0xee>
        if (procs[i].state == UNUSED)
  32:	fec4a683          	lw	a3,-20(s1)
  36:	ce89                	beqz	a3,50 <main+0x50>
        printf("%s (%d): %d\n", procs[i].name, procs[i].pid, procs[i].state);
  38:	ff84a603          	lw	a2,-8(s1)
  3c:	85a6                	mv	a1,s1
  3e:	854e                	mv	a0,s3
  40:	00000097          	auipc	ra,0x0
  44:	7fa080e7          	jalr	2042(ra) # 83a <printf>
    for (int i = 0; i < 64; i++)
  48:	02448493          	addi	s1,s1,36
  4c:	ff2493e3          	bne	s1,s2,32 <main+0x32>
    }
    exit(0);
  50:	4501                	li	a0,0
  52:	00000097          	auipc	ra,0x0
  56:	456080e7          	jalr	1110(ra) # 4a8 <exit>

000000000000005a <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  5a:	1141                	addi	sp,sp,-16
  5c:	e422                	sd	s0,8(sp)
  5e:	0800                	addi	s0,sp,16
    lk->name = name;
  60:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  62:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  66:	57fd                	li	a5,-1
  68:	00f50823          	sb	a5,16(a0)
}
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  72:	00054783          	lbu	a5,0(a0)
  76:	e399                	bnez	a5,7c <holding+0xa>
  78:	4501                	li	a0,0
}
  7a:	8082                	ret
{
  7c:	1101                	addi	sp,sp,-32
  7e:	ec06                	sd	ra,24(sp)
  80:	e822                	sd	s0,16(sp)
  82:	e426                	sd	s1,8(sp)
  84:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  86:	01054483          	lbu	s1,16(a0)
  8a:	00000097          	auipc	ra,0x0
  8e:	122080e7          	jalr	290(ra) # 1ac <twhoami>
  92:	2501                	sext.w	a0,a0
  94:	40a48533          	sub	a0,s1,a0
  98:	00153513          	seqz	a0,a0
}
  9c:	60e2                	ld	ra,24(sp)
  9e:	6442                	ld	s0,16(sp)
  a0:	64a2                	ld	s1,8(sp)
  a2:	6105                	addi	sp,sp,32
  a4:	8082                	ret

00000000000000a6 <acquire>:

void acquire(struct lock *lk)
{
  a6:	7179                	addi	sp,sp,-48
  a8:	f406                	sd	ra,40(sp)
  aa:	f022                	sd	s0,32(sp)
  ac:	ec26                	sd	s1,24(sp)
  ae:	e84a                	sd	s2,16(sp)
  b0:	e44e                	sd	s3,8(sp)
  b2:	e052                	sd	s4,0(sp)
  b4:	1800                	addi	s0,sp,48
  b6:	8a2a                	mv	s4,a0
    if (holding(lk))
  b8:	00000097          	auipc	ra,0x0
  bc:	fba080e7          	jalr	-70(ra) # 72 <holding>
  c0:	e919                	bnez	a0,d6 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  c2:	ffca7493          	andi	s1,s4,-4
  c6:	003a7913          	andi	s2,s4,3
  ca:	0039191b          	slliw	s2,s2,0x3
  ce:	4985                	li	s3,1
  d0:	012999bb          	sllw	s3,s3,s2
  d4:	a015                	j	f8 <acquire+0x52>
        printf("re-acquiring lock we already hold");
  d6:	00001517          	auipc	a0,0x1
  da:	91a50513          	addi	a0,a0,-1766 # 9f0 <malloc+0xfe>
  de:	00000097          	auipc	ra,0x0
  e2:	75c080e7          	jalr	1884(ra) # 83a <printf>
        exit(-1);
  e6:	557d                	li	a0,-1
  e8:	00000097          	auipc	ra,0x0
  ec:	3c0080e7          	jalr	960(ra) # 4a8 <exit>
    {
        // give up the cpu for other threads
        tyield();
  f0:	00000097          	auipc	ra,0x0
  f4:	0b0080e7          	jalr	176(ra) # 1a0 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  f8:	4534a7af          	amoor.w.aq	a5,s3,(s1)
  fc:	0127d7bb          	srlw	a5,a5,s2
 100:	0ff7f793          	zext.b	a5,a5
 104:	f7f5                	bnez	a5,f0 <acquire+0x4a>
    }

    __sync_synchronize();
 106:	0ff0000f          	fence

    lk->tid = twhoami();
 10a:	00000097          	auipc	ra,0x0
 10e:	0a2080e7          	jalr	162(ra) # 1ac <twhoami>
 112:	00aa0823          	sb	a0,16(s4)
}
 116:	70a2                	ld	ra,40(sp)
 118:	7402                	ld	s0,32(sp)
 11a:	64e2                	ld	s1,24(sp)
 11c:	6942                	ld	s2,16(sp)
 11e:	69a2                	ld	s3,8(sp)
 120:	6a02                	ld	s4,0(sp)
 122:	6145                	addi	sp,sp,48
 124:	8082                	ret

0000000000000126 <release>:

void release(struct lock *lk)
{
 126:	1101                	addi	sp,sp,-32
 128:	ec06                	sd	ra,24(sp)
 12a:	e822                	sd	s0,16(sp)
 12c:	e426                	sd	s1,8(sp)
 12e:	1000                	addi	s0,sp,32
 130:	84aa                	mv	s1,a0
    if (!holding(lk))
 132:	00000097          	auipc	ra,0x0
 136:	f40080e7          	jalr	-192(ra) # 72 <holding>
 13a:	c11d                	beqz	a0,160 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 13c:	57fd                	li	a5,-1
 13e:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 142:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 146:	0ff0000f          	fence
 14a:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 14e:	00000097          	auipc	ra,0x0
 152:	052080e7          	jalr	82(ra) # 1a0 <tyield>
}
 156:	60e2                	ld	ra,24(sp)
 158:	6442                	ld	s0,16(sp)
 15a:	64a2                	ld	s1,8(sp)
 15c:	6105                	addi	sp,sp,32
 15e:	8082                	ret
        printf("releasing lock we are not holding");
 160:	00001517          	auipc	a0,0x1
 164:	8b850513          	addi	a0,a0,-1864 # a18 <malloc+0x126>
 168:	00000097          	auipc	ra,0x0
 16c:	6d2080e7          	jalr	1746(ra) # 83a <printf>
        exit(-1);
 170:	557d                	li	a0,-1
 172:	00000097          	auipc	ra,0x0
 176:	336080e7          	jalr	822(ra) # 4a8 <exit>

000000000000017a <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e422                	sd	s0,8(sp)
 17e:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 180:	6422                	ld	s0,8(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 18c:	6422                	ld	s0,8(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret

0000000000000192 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 198:	4501                	li	a0,0
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret

00000000000001a0 <tyield>:

void tyield()
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret

00000000000001ac <twhoami>:

uint8 twhoami()
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e422                	sd	s0,8(sp)
 1b0:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 1b2:	4501                	li	a0,0
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <tswtch>:
 1ba:	00153023          	sd	ra,0(a0)
 1be:	00253423          	sd	sp,8(a0)
 1c2:	e900                	sd	s0,16(a0)
 1c4:	ed04                	sd	s1,24(a0)
 1c6:	03253023          	sd	s2,32(a0)
 1ca:	03353423          	sd	s3,40(a0)
 1ce:	03453823          	sd	s4,48(a0)
 1d2:	03553c23          	sd	s5,56(a0)
 1d6:	05653023          	sd	s6,64(a0)
 1da:	05753423          	sd	s7,72(a0)
 1de:	05853823          	sd	s8,80(a0)
 1e2:	05953c23          	sd	s9,88(a0)
 1e6:	07a53023          	sd	s10,96(a0)
 1ea:	07b53423          	sd	s11,104(a0)
 1ee:	0005b083          	ld	ra,0(a1)
 1f2:	0085b103          	ld	sp,8(a1)
 1f6:	6980                	ld	s0,16(a1)
 1f8:	6d84                	ld	s1,24(a1)
 1fa:	0205b903          	ld	s2,32(a1)
 1fe:	0285b983          	ld	s3,40(a1)
 202:	0305ba03          	ld	s4,48(a1)
 206:	0385ba83          	ld	s5,56(a1)
 20a:	0405bb03          	ld	s6,64(a1)
 20e:	0485bb83          	ld	s7,72(a1)
 212:	0505bc03          	ld	s8,80(a1)
 216:	0585bc83          	ld	s9,88(a1)
 21a:	0605bd03          	ld	s10,96(a1)
 21e:	0685bd83          	ld	s11,104(a1)
 222:	8082                	ret

0000000000000224 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 224:	1141                	addi	sp,sp,-16
 226:	e406                	sd	ra,8(sp)
 228:	e022                	sd	s0,0(sp)
 22a:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 22c:	00000097          	auipc	ra,0x0
 230:	dd4080e7          	jalr	-556(ra) # 0 <main>
    exit(res);
 234:	00000097          	auipc	ra,0x0
 238:	274080e7          	jalr	628(ra) # 4a8 <exit>

000000000000023c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 242:	87aa                	mv	a5,a0
 244:	0585                	addi	a1,a1,1
 246:	0785                	addi	a5,a5,1
 248:	fff5c703          	lbu	a4,-1(a1)
 24c:	fee78fa3          	sb	a4,-1(a5)
 250:	fb75                	bnez	a4,244 <strcpy+0x8>
        ;
    return os;
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret

0000000000000258 <strcmp>:

int strcmp(const char *p, const char *q)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 25e:	00054783          	lbu	a5,0(a0)
 262:	cb91                	beqz	a5,276 <strcmp+0x1e>
 264:	0005c703          	lbu	a4,0(a1)
 268:	00f71763          	bne	a4,a5,276 <strcmp+0x1e>
        p++, q++;
 26c:	0505                	addi	a0,a0,1
 26e:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 270:	00054783          	lbu	a5,0(a0)
 274:	fbe5                	bnez	a5,264 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 276:	0005c503          	lbu	a0,0(a1)
}
 27a:	40a7853b          	subw	a0,a5,a0
 27e:	6422                	ld	s0,8(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret

0000000000000284 <strlen>:

uint strlen(const char *s)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 28a:	00054783          	lbu	a5,0(a0)
 28e:	cf91                	beqz	a5,2aa <strlen+0x26>
 290:	0505                	addi	a0,a0,1
 292:	87aa                	mv	a5,a0
 294:	4685                	li	a3,1
 296:	9e89                	subw	a3,a3,a0
 298:	00f6853b          	addw	a0,a3,a5
 29c:	0785                	addi	a5,a5,1
 29e:	fff7c703          	lbu	a4,-1(a5)
 2a2:	fb7d                	bnez	a4,298 <strlen+0x14>
        ;
    return n;
}
 2a4:	6422                	ld	s0,8(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
    for (n = 0; s[n]; n++)
 2aa:	4501                	li	a0,0
 2ac:	bfe5                	j	2a4 <strlen+0x20>

00000000000002ae <memset>:

void *
memset(void *dst, int c, uint n)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e422                	sd	s0,8(sp)
 2b2:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 2b4:	ca19                	beqz	a2,2ca <memset+0x1c>
 2b6:	87aa                	mv	a5,a0
 2b8:	1602                	slli	a2,a2,0x20
 2ba:	9201                	srli	a2,a2,0x20
 2bc:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 2c0:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 2c4:	0785                	addi	a5,a5,1
 2c6:	fee79de3          	bne	a5,a4,2c0 <memset+0x12>
    }
    return dst;
}
 2ca:	6422                	ld	s0,8(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <strchr>:

char *
strchr(const char *s, char c)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
    for (; *s; s++)
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	cb99                	beqz	a5,2f0 <strchr+0x20>
        if (*s == c)
 2dc:	00f58763          	beq	a1,a5,2ea <strchr+0x1a>
    for (; *s; s++)
 2e0:	0505                	addi	a0,a0,1
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	fbfd                	bnez	a5,2dc <strchr+0xc>
            return (char *)s;
    return 0;
 2e8:	4501                	li	a0,0
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
    return 0;
 2f0:	4501                	li	a0,0
 2f2:	bfe5                	j	2ea <strchr+0x1a>

00000000000002f4 <gets>:

char *
gets(char *buf, int max)
{
 2f4:	711d                	addi	sp,sp,-96
 2f6:	ec86                	sd	ra,88(sp)
 2f8:	e8a2                	sd	s0,80(sp)
 2fa:	e4a6                	sd	s1,72(sp)
 2fc:	e0ca                	sd	s2,64(sp)
 2fe:	fc4e                	sd	s3,56(sp)
 300:	f852                	sd	s4,48(sp)
 302:	f456                	sd	s5,40(sp)
 304:	f05a                	sd	s6,32(sp)
 306:	ec5e                	sd	s7,24(sp)
 308:	1080                	addi	s0,sp,96
 30a:	8baa                	mv	s7,a0
 30c:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 30e:	892a                	mv	s2,a0
 310:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 312:	4aa9                	li	s5,10
 314:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 316:	89a6                	mv	s3,s1
 318:	2485                	addiw	s1,s1,1
 31a:	0344d863          	bge	s1,s4,34a <gets+0x56>
        cc = read(0, &c, 1);
 31e:	4605                	li	a2,1
 320:	faf40593          	addi	a1,s0,-81
 324:	4501                	li	a0,0
 326:	00000097          	auipc	ra,0x0
 32a:	19a080e7          	jalr	410(ra) # 4c0 <read>
        if (cc < 1)
 32e:	00a05e63          	blez	a0,34a <gets+0x56>
        buf[i++] = c;
 332:	faf44783          	lbu	a5,-81(s0)
 336:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 33a:	01578763          	beq	a5,s5,348 <gets+0x54>
 33e:	0905                	addi	s2,s2,1
 340:	fd679be3          	bne	a5,s6,316 <gets+0x22>
    for (i = 0; i + 1 < max;)
 344:	89a6                	mv	s3,s1
 346:	a011                	j	34a <gets+0x56>
 348:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 34a:	99de                	add	s3,s3,s7
 34c:	00098023          	sb	zero,0(s3)
    return buf;
}
 350:	855e                	mv	a0,s7
 352:	60e6                	ld	ra,88(sp)
 354:	6446                	ld	s0,80(sp)
 356:	64a6                	ld	s1,72(sp)
 358:	6906                	ld	s2,64(sp)
 35a:	79e2                	ld	s3,56(sp)
 35c:	7a42                	ld	s4,48(sp)
 35e:	7aa2                	ld	s5,40(sp)
 360:	7b02                	ld	s6,32(sp)
 362:	6be2                	ld	s7,24(sp)
 364:	6125                	addi	sp,sp,96
 366:	8082                	ret

0000000000000368 <stat>:

int stat(const char *n, struct stat *st)
{
 368:	1101                	addi	sp,sp,-32
 36a:	ec06                	sd	ra,24(sp)
 36c:	e822                	sd	s0,16(sp)
 36e:	e426                	sd	s1,8(sp)
 370:	e04a                	sd	s2,0(sp)
 372:	1000                	addi	s0,sp,32
 374:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 376:	4581                	li	a1,0
 378:	00000097          	auipc	ra,0x0
 37c:	170080e7          	jalr	368(ra) # 4e8 <open>
    if (fd < 0)
 380:	02054563          	bltz	a0,3aa <stat+0x42>
 384:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 386:	85ca                	mv	a1,s2
 388:	00000097          	auipc	ra,0x0
 38c:	178080e7          	jalr	376(ra) # 500 <fstat>
 390:	892a                	mv	s2,a0
    close(fd);
 392:	8526                	mv	a0,s1
 394:	00000097          	auipc	ra,0x0
 398:	13c080e7          	jalr	316(ra) # 4d0 <close>
    return r;
}
 39c:	854a                	mv	a0,s2
 39e:	60e2                	ld	ra,24(sp)
 3a0:	6442                	ld	s0,16(sp)
 3a2:	64a2                	ld	s1,8(sp)
 3a4:	6902                	ld	s2,0(sp)
 3a6:	6105                	addi	sp,sp,32
 3a8:	8082                	ret
        return -1;
 3aa:	597d                	li	s2,-1
 3ac:	bfc5                	j	39c <stat+0x34>

00000000000003ae <atoi>:

int atoi(const char *s)
{
 3ae:	1141                	addi	sp,sp,-16
 3b0:	e422                	sd	s0,8(sp)
 3b2:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 3b4:	00054683          	lbu	a3,0(a0)
 3b8:	fd06879b          	addiw	a5,a3,-48
 3bc:	0ff7f793          	zext.b	a5,a5
 3c0:	4625                	li	a2,9
 3c2:	02f66863          	bltu	a2,a5,3f2 <atoi+0x44>
 3c6:	872a                	mv	a4,a0
    n = 0;
 3c8:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 3ca:	0705                	addi	a4,a4,1
 3cc:	0025179b          	slliw	a5,a0,0x2
 3d0:	9fa9                	addw	a5,a5,a0
 3d2:	0017979b          	slliw	a5,a5,0x1
 3d6:	9fb5                	addw	a5,a5,a3
 3d8:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 3dc:	00074683          	lbu	a3,0(a4)
 3e0:	fd06879b          	addiw	a5,a3,-48
 3e4:	0ff7f793          	zext.b	a5,a5
 3e8:	fef671e3          	bgeu	a2,a5,3ca <atoi+0x1c>
    return n;
}
 3ec:	6422                	ld	s0,8(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret
    n = 0;
 3f2:	4501                	li	a0,0
 3f4:	bfe5                	j	3ec <atoi+0x3e>

00000000000003f6 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e422                	sd	s0,8(sp)
 3fa:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 3fc:	02b57463          	bgeu	a0,a1,424 <memmove+0x2e>
    {
        while (n-- > 0)
 400:	00c05f63          	blez	a2,41e <memmove+0x28>
 404:	1602                	slli	a2,a2,0x20
 406:	9201                	srli	a2,a2,0x20
 408:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 40c:	872a                	mv	a4,a0
            *dst++ = *src++;
 40e:	0585                	addi	a1,a1,1
 410:	0705                	addi	a4,a4,1
 412:	fff5c683          	lbu	a3,-1(a1)
 416:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 41a:	fee79ae3          	bne	a5,a4,40e <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 41e:	6422                	ld	s0,8(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret
        dst += n;
 424:	00c50733          	add	a4,a0,a2
        src += n;
 428:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 42a:	fec05ae3          	blez	a2,41e <memmove+0x28>
 42e:	fff6079b          	addiw	a5,a2,-1
 432:	1782                	slli	a5,a5,0x20
 434:	9381                	srli	a5,a5,0x20
 436:	fff7c793          	not	a5,a5
 43a:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 43c:	15fd                	addi	a1,a1,-1
 43e:	177d                	addi	a4,a4,-1
 440:	0005c683          	lbu	a3,0(a1)
 444:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 448:	fee79ae3          	bne	a5,a4,43c <memmove+0x46>
 44c:	bfc9                	j	41e <memmove+0x28>

000000000000044e <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 44e:	1141                	addi	sp,sp,-16
 450:	e422                	sd	s0,8(sp)
 452:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 454:	ca05                	beqz	a2,484 <memcmp+0x36>
 456:	fff6069b          	addiw	a3,a2,-1
 45a:	1682                	slli	a3,a3,0x20
 45c:	9281                	srli	a3,a3,0x20
 45e:	0685                	addi	a3,a3,1
 460:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 462:	00054783          	lbu	a5,0(a0)
 466:	0005c703          	lbu	a4,0(a1)
 46a:	00e79863          	bne	a5,a4,47a <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 46e:	0505                	addi	a0,a0,1
        p2++;
 470:	0585                	addi	a1,a1,1
    while (n-- > 0)
 472:	fed518e3          	bne	a0,a3,462 <memcmp+0x14>
    }
    return 0;
 476:	4501                	li	a0,0
 478:	a019                	j	47e <memcmp+0x30>
            return *p1 - *p2;
 47a:	40e7853b          	subw	a0,a5,a4
}
 47e:	6422                	ld	s0,8(sp)
 480:	0141                	addi	sp,sp,16
 482:	8082                	ret
    return 0;
 484:	4501                	li	a0,0
 486:	bfe5                	j	47e <memcmp+0x30>

0000000000000488 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 488:	1141                	addi	sp,sp,-16
 48a:	e406                	sd	ra,8(sp)
 48c:	e022                	sd	s0,0(sp)
 48e:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 490:	00000097          	auipc	ra,0x0
 494:	f66080e7          	jalr	-154(ra) # 3f6 <memmove>
}
 498:	60a2                	ld	ra,8(sp)
 49a:	6402                	ld	s0,0(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret

00000000000004a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4a0:	4885                	li	a7,1
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a8:	4889                	li	a7,2
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4b0:	488d                	li	a7,3
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4b8:	4891                	li	a7,4
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <read>:
.global read
read:
 li a7, SYS_read
 4c0:	4895                	li	a7,5
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <write>:
.global write
write:
 li a7, SYS_write
 4c8:	48c1                	li	a7,16
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <close>:
.global close
close:
 li a7, SYS_close
 4d0:	48d5                	li	a7,21
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d8:	4899                	li	a7,6
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4e0:	489d                	li	a7,7
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <open>:
.global open
open:
 li a7, SYS_open
 4e8:	48bd                	li	a7,15
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4f0:	48c5                	li	a7,17
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4f8:	48c9                	li	a7,18
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 500:	48a1                	li	a7,8
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <link>:
.global link
link:
 li a7, SYS_link
 508:	48cd                	li	a7,19
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 510:	48d1                	li	a7,20
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 518:	48a5                	li	a7,9
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <dup>:
.global dup
dup:
 li a7, SYS_dup
 520:	48a9                	li	a7,10
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 528:	48ad                	li	a7,11
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 530:	48b1                	li	a7,12
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 538:	48b5                	li	a7,13
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 540:	48b9                	li	a7,14
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <ps>:
.global ps
ps:
 li a7, SYS_ps
 548:	48d9                	li	a7,22
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 550:	48dd                	li	a7,23
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 558:	48e1                	li	a7,24
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 560:	1101                	addi	sp,sp,-32
 562:	ec06                	sd	ra,24(sp)
 564:	e822                	sd	s0,16(sp)
 566:	1000                	addi	s0,sp,32
 568:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 56c:	4605                	li	a2,1
 56e:	fef40593          	addi	a1,s0,-17
 572:	00000097          	auipc	ra,0x0
 576:	f56080e7          	jalr	-170(ra) # 4c8 <write>
}
 57a:	60e2                	ld	ra,24(sp)
 57c:	6442                	ld	s0,16(sp)
 57e:	6105                	addi	sp,sp,32
 580:	8082                	ret

0000000000000582 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 582:	7139                	addi	sp,sp,-64
 584:	fc06                	sd	ra,56(sp)
 586:	f822                	sd	s0,48(sp)
 588:	f426                	sd	s1,40(sp)
 58a:	f04a                	sd	s2,32(sp)
 58c:	ec4e                	sd	s3,24(sp)
 58e:	0080                	addi	s0,sp,64
 590:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 592:	c299                	beqz	a3,598 <printint+0x16>
 594:	0805c963          	bltz	a1,626 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 598:	2581                	sext.w	a1,a1
  neg = 0;
 59a:	4881                	li	a7,0
 59c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5a2:	2601                	sext.w	a2,a2
 5a4:	00000517          	auipc	a0,0x0
 5a8:	4fc50513          	addi	a0,a0,1276 # aa0 <digits>
 5ac:	883a                	mv	a6,a4
 5ae:	2705                	addiw	a4,a4,1
 5b0:	02c5f7bb          	remuw	a5,a1,a2
 5b4:	1782                	slli	a5,a5,0x20
 5b6:	9381                	srli	a5,a5,0x20
 5b8:	97aa                	add	a5,a5,a0
 5ba:	0007c783          	lbu	a5,0(a5)
 5be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5c2:	0005879b          	sext.w	a5,a1
 5c6:	02c5d5bb          	divuw	a1,a1,a2
 5ca:	0685                	addi	a3,a3,1
 5cc:	fec7f0e3          	bgeu	a5,a2,5ac <printint+0x2a>
  if(neg)
 5d0:	00088c63          	beqz	a7,5e8 <printint+0x66>
    buf[i++] = '-';
 5d4:	fd070793          	addi	a5,a4,-48
 5d8:	00878733          	add	a4,a5,s0
 5dc:	02d00793          	li	a5,45
 5e0:	fef70823          	sb	a5,-16(a4)
 5e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e8:	02e05863          	blez	a4,618 <printint+0x96>
 5ec:	fc040793          	addi	a5,s0,-64
 5f0:	00e78933          	add	s2,a5,a4
 5f4:	fff78993          	addi	s3,a5,-1
 5f8:	99ba                	add	s3,s3,a4
 5fa:	377d                	addiw	a4,a4,-1
 5fc:	1702                	slli	a4,a4,0x20
 5fe:	9301                	srli	a4,a4,0x20
 600:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 604:	fff94583          	lbu	a1,-1(s2)
 608:	8526                	mv	a0,s1
 60a:	00000097          	auipc	ra,0x0
 60e:	f56080e7          	jalr	-170(ra) # 560 <putc>
  while(--i >= 0)
 612:	197d                	addi	s2,s2,-1
 614:	ff3918e3          	bne	s2,s3,604 <printint+0x82>
}
 618:	70e2                	ld	ra,56(sp)
 61a:	7442                	ld	s0,48(sp)
 61c:	74a2                	ld	s1,40(sp)
 61e:	7902                	ld	s2,32(sp)
 620:	69e2                	ld	s3,24(sp)
 622:	6121                	addi	sp,sp,64
 624:	8082                	ret
    x = -xx;
 626:	40b005bb          	negw	a1,a1
    neg = 1;
 62a:	4885                	li	a7,1
    x = -xx;
 62c:	bf85                	j	59c <printint+0x1a>

000000000000062e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 62e:	7119                	addi	sp,sp,-128
 630:	fc86                	sd	ra,120(sp)
 632:	f8a2                	sd	s0,112(sp)
 634:	f4a6                	sd	s1,104(sp)
 636:	f0ca                	sd	s2,96(sp)
 638:	ecce                	sd	s3,88(sp)
 63a:	e8d2                	sd	s4,80(sp)
 63c:	e4d6                	sd	s5,72(sp)
 63e:	e0da                	sd	s6,64(sp)
 640:	fc5e                	sd	s7,56(sp)
 642:	f862                	sd	s8,48(sp)
 644:	f466                	sd	s9,40(sp)
 646:	f06a                	sd	s10,32(sp)
 648:	ec6e                	sd	s11,24(sp)
 64a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 64c:	0005c903          	lbu	s2,0(a1)
 650:	18090f63          	beqz	s2,7ee <vprintf+0x1c0>
 654:	8aaa                	mv	s5,a0
 656:	8b32                	mv	s6,a2
 658:	00158493          	addi	s1,a1,1
  state = 0;
 65c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 65e:	02500a13          	li	s4,37
 662:	4c55                	li	s8,21
 664:	00000c97          	auipc	s9,0x0
 668:	3e4c8c93          	addi	s9,s9,996 # a48 <malloc+0x156>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 66c:	02800d93          	li	s11,40
  putc(fd, 'x');
 670:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 672:	00000b97          	auipc	s7,0x0
 676:	42eb8b93          	addi	s7,s7,1070 # aa0 <digits>
 67a:	a839                	j	698 <vprintf+0x6a>
        putc(fd, c);
 67c:	85ca                	mv	a1,s2
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	ee0080e7          	jalr	-288(ra) # 560 <putc>
 688:	a019                	j	68e <vprintf+0x60>
    } else if(state == '%'){
 68a:	01498d63          	beq	s3,s4,6a4 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 68e:	0485                	addi	s1,s1,1
 690:	fff4c903          	lbu	s2,-1(s1)
 694:	14090d63          	beqz	s2,7ee <vprintf+0x1c0>
    if(state == 0){
 698:	fe0999e3          	bnez	s3,68a <vprintf+0x5c>
      if(c == '%'){
 69c:	ff4910e3          	bne	s2,s4,67c <vprintf+0x4e>
        state = '%';
 6a0:	89d2                	mv	s3,s4
 6a2:	b7f5                	j	68e <vprintf+0x60>
      if(c == 'd'){
 6a4:	11490c63          	beq	s2,s4,7bc <vprintf+0x18e>
 6a8:	f9d9079b          	addiw	a5,s2,-99
 6ac:	0ff7f793          	zext.b	a5,a5
 6b0:	10fc6e63          	bltu	s8,a5,7cc <vprintf+0x19e>
 6b4:	f9d9079b          	addiw	a5,s2,-99
 6b8:	0ff7f713          	zext.b	a4,a5
 6bc:	10ec6863          	bltu	s8,a4,7cc <vprintf+0x19e>
 6c0:	00271793          	slli	a5,a4,0x2
 6c4:	97e6                	add	a5,a5,s9
 6c6:	439c                	lw	a5,0(a5)
 6c8:	97e6                	add	a5,a5,s9
 6ca:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6cc:	008b0913          	addi	s2,s6,8
 6d0:	4685                	li	a3,1
 6d2:	4629                	li	a2,10
 6d4:	000b2583          	lw	a1,0(s6)
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	ea8080e7          	jalr	-344(ra) # 582 <printint>
 6e2:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	b765                	j	68e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e8:	008b0913          	addi	s2,s6,8
 6ec:	4681                	li	a3,0
 6ee:	4629                	li	a2,10
 6f0:	000b2583          	lw	a1,0(s6)
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e8c080e7          	jalr	-372(ra) # 582 <printint>
 6fe:	8b4a                	mv	s6,s2
      state = 0;
 700:	4981                	li	s3,0
 702:	b771                	j	68e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 704:	008b0913          	addi	s2,s6,8
 708:	4681                	li	a3,0
 70a:	866a                	mv	a2,s10
 70c:	000b2583          	lw	a1,0(s6)
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	e70080e7          	jalr	-400(ra) # 582 <printint>
 71a:	8b4a                	mv	s6,s2
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bf85                	j	68e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 720:	008b0793          	addi	a5,s6,8
 724:	f8f43423          	sd	a5,-120(s0)
 728:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 72c:	03000593          	li	a1,48
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	e2e080e7          	jalr	-466(ra) # 560 <putc>
  putc(fd, 'x');
 73a:	07800593          	li	a1,120
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	e20080e7          	jalr	-480(ra) # 560 <putc>
 748:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74a:	03c9d793          	srli	a5,s3,0x3c
 74e:	97de                	add	a5,a5,s7
 750:	0007c583          	lbu	a1,0(a5)
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	e0a080e7          	jalr	-502(ra) # 560 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 75e:	0992                	slli	s3,s3,0x4
 760:	397d                	addiw	s2,s2,-1
 762:	fe0914e3          	bnez	s2,74a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 766:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 76a:	4981                	li	s3,0
 76c:	b70d                	j	68e <vprintf+0x60>
        s = va_arg(ap, char*);
 76e:	008b0913          	addi	s2,s6,8
 772:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 776:	02098163          	beqz	s3,798 <vprintf+0x16a>
        while(*s != 0){
 77a:	0009c583          	lbu	a1,0(s3)
 77e:	c5ad                	beqz	a1,7e8 <vprintf+0x1ba>
          putc(fd, *s);
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	dde080e7          	jalr	-546(ra) # 560 <putc>
          s++;
 78a:	0985                	addi	s3,s3,1
        while(*s != 0){
 78c:	0009c583          	lbu	a1,0(s3)
 790:	f9e5                	bnez	a1,780 <vprintf+0x152>
        s = va_arg(ap, char*);
 792:	8b4a                	mv	s6,s2
      state = 0;
 794:	4981                	li	s3,0
 796:	bde5                	j	68e <vprintf+0x60>
          s = "(null)";
 798:	00000997          	auipc	s3,0x0
 79c:	2a898993          	addi	s3,s3,680 # a40 <malloc+0x14e>
        while(*s != 0){
 7a0:	85ee                	mv	a1,s11
 7a2:	bff9                	j	780 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7a4:	008b0913          	addi	s2,s6,8
 7a8:	000b4583          	lbu	a1,0(s6)
 7ac:	8556                	mv	a0,s5
 7ae:	00000097          	auipc	ra,0x0
 7b2:	db2080e7          	jalr	-590(ra) # 560 <putc>
 7b6:	8b4a                	mv	s6,s2
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	bdd1                	j	68e <vprintf+0x60>
        putc(fd, c);
 7bc:	85d2                	mv	a1,s4
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	da0080e7          	jalr	-608(ra) # 560 <putc>
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	b5d1                	j	68e <vprintf+0x60>
        putc(fd, '%');
 7cc:	85d2                	mv	a1,s4
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	d90080e7          	jalr	-624(ra) # 560 <putc>
        putc(fd, c);
 7d8:	85ca                	mv	a1,s2
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	d84080e7          	jalr	-636(ra) # 560 <putc>
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	b565                	j	68e <vprintf+0x60>
        s = va_arg(ap, char*);
 7e8:	8b4a                	mv	s6,s2
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	b54d                	j	68e <vprintf+0x60>
    }
  }
}
 7ee:	70e6                	ld	ra,120(sp)
 7f0:	7446                	ld	s0,112(sp)
 7f2:	74a6                	ld	s1,104(sp)
 7f4:	7906                	ld	s2,96(sp)
 7f6:	69e6                	ld	s3,88(sp)
 7f8:	6a46                	ld	s4,80(sp)
 7fa:	6aa6                	ld	s5,72(sp)
 7fc:	6b06                	ld	s6,64(sp)
 7fe:	7be2                	ld	s7,56(sp)
 800:	7c42                	ld	s8,48(sp)
 802:	7ca2                	ld	s9,40(sp)
 804:	7d02                	ld	s10,32(sp)
 806:	6de2                	ld	s11,24(sp)
 808:	6109                	addi	sp,sp,128
 80a:	8082                	ret

000000000000080c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 80c:	715d                	addi	sp,sp,-80
 80e:	ec06                	sd	ra,24(sp)
 810:	e822                	sd	s0,16(sp)
 812:	1000                	addi	s0,sp,32
 814:	e010                	sd	a2,0(s0)
 816:	e414                	sd	a3,8(s0)
 818:	e818                	sd	a4,16(s0)
 81a:	ec1c                	sd	a5,24(s0)
 81c:	03043023          	sd	a6,32(s0)
 820:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 824:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 828:	8622                	mv	a2,s0
 82a:	00000097          	auipc	ra,0x0
 82e:	e04080e7          	jalr	-508(ra) # 62e <vprintf>
}
 832:	60e2                	ld	ra,24(sp)
 834:	6442                	ld	s0,16(sp)
 836:	6161                	addi	sp,sp,80
 838:	8082                	ret

000000000000083a <printf>:

void
printf(const char *fmt, ...)
{
 83a:	711d                	addi	sp,sp,-96
 83c:	ec06                	sd	ra,24(sp)
 83e:	e822                	sd	s0,16(sp)
 840:	1000                	addi	s0,sp,32
 842:	e40c                	sd	a1,8(s0)
 844:	e810                	sd	a2,16(s0)
 846:	ec14                	sd	a3,24(s0)
 848:	f018                	sd	a4,32(s0)
 84a:	f41c                	sd	a5,40(s0)
 84c:	03043823          	sd	a6,48(s0)
 850:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 854:	00840613          	addi	a2,s0,8
 858:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 85c:	85aa                	mv	a1,a0
 85e:	4505                	li	a0,1
 860:	00000097          	auipc	ra,0x0
 864:	dce080e7          	jalr	-562(ra) # 62e <vprintf>
}
 868:	60e2                	ld	ra,24(sp)
 86a:	6442                	ld	s0,16(sp)
 86c:	6125                	addi	sp,sp,96
 86e:	8082                	ret

0000000000000870 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 870:	1141                	addi	sp,sp,-16
 872:	e422                	sd	s0,8(sp)
 874:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 876:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87a:	00000797          	auipc	a5,0x0
 87e:	7867b783          	ld	a5,1926(a5) # 1000 <freep>
 882:	a02d                	j	8ac <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 884:	4618                	lw	a4,8(a2)
 886:	9f2d                	addw	a4,a4,a1
 888:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 88c:	6398                	ld	a4,0(a5)
 88e:	6310                	ld	a2,0(a4)
 890:	a83d                	j	8ce <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 892:	ff852703          	lw	a4,-8(a0)
 896:	9f31                	addw	a4,a4,a2
 898:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 89a:	ff053683          	ld	a3,-16(a0)
 89e:	a091                	j	8e2 <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	6398                	ld	a4,0(a5)
 8a2:	00e7e463          	bltu	a5,a4,8aa <free+0x3a>
 8a6:	00e6ea63          	bltu	a3,a4,8ba <free+0x4a>
{
 8aa:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ac:	fed7fae3          	bgeu	a5,a3,8a0 <free+0x30>
 8b0:	6398                	ld	a4,0(a5)
 8b2:	00e6e463          	bltu	a3,a4,8ba <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b6:	fee7eae3          	bltu	a5,a4,8aa <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 8ba:	ff852583          	lw	a1,-8(a0)
 8be:	6390                	ld	a2,0(a5)
 8c0:	02059813          	slli	a6,a1,0x20
 8c4:	01c85713          	srli	a4,a6,0x1c
 8c8:	9736                	add	a4,a4,a3
 8ca:	fae60de3          	beq	a2,a4,884 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 8ce:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 8d2:	4790                	lw	a2,8(a5)
 8d4:	02061593          	slli	a1,a2,0x20
 8d8:	01c5d713          	srli	a4,a1,0x1c
 8dc:	973e                	add	a4,a4,a5
 8de:	fae68ae3          	beq	a3,a4,892 <free+0x22>
        p->s.ptr = bp->s.ptr;
 8e2:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 8e4:	00000717          	auipc	a4,0x0
 8e8:	70f73e23          	sd	a5,1820(a4) # 1000 <freep>
}
 8ec:	6422                	ld	s0,8(sp)
 8ee:	0141                	addi	sp,sp,16
 8f0:	8082                	ret

00000000000008f2 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 8f2:	7139                	addi	sp,sp,-64
 8f4:	fc06                	sd	ra,56(sp)
 8f6:	f822                	sd	s0,48(sp)
 8f8:	f426                	sd	s1,40(sp)
 8fa:	f04a                	sd	s2,32(sp)
 8fc:	ec4e                	sd	s3,24(sp)
 8fe:	e852                	sd	s4,16(sp)
 900:	e456                	sd	s5,8(sp)
 902:	e05a                	sd	s6,0(sp)
 904:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 906:	02051493          	slli	s1,a0,0x20
 90a:	9081                	srli	s1,s1,0x20
 90c:	04bd                	addi	s1,s1,15
 90e:	8091                	srli	s1,s1,0x4
 910:	0014899b          	addiw	s3,s1,1
 914:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 916:	00000517          	auipc	a0,0x0
 91a:	6ea53503          	ld	a0,1770(a0) # 1000 <freep>
 91e:	c515                	beqz	a0,94a <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 920:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 922:	4798                	lw	a4,8(a5)
 924:	02977f63          	bgeu	a4,s1,962 <malloc+0x70>
 928:	8a4e                	mv	s4,s3
 92a:	0009871b          	sext.w	a4,s3
 92e:	6685                	lui	a3,0x1
 930:	00d77363          	bgeu	a4,a3,936 <malloc+0x44>
 934:	6a05                	lui	s4,0x1
 936:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 93a:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 93e:	00000917          	auipc	s2,0x0
 942:	6c290913          	addi	s2,s2,1730 # 1000 <freep>
    if (p == (char *)-1)
 946:	5afd                	li	s5,-1
 948:	a895                	j	9bc <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 94a:	00000797          	auipc	a5,0x0
 94e:	6c678793          	addi	a5,a5,1734 # 1010 <base>
 952:	00000717          	auipc	a4,0x0
 956:	6af73723          	sd	a5,1710(a4) # 1000 <freep>
 95a:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 95c:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 960:	b7e1                	j	928 <malloc+0x36>
            if (p->s.size == nunits)
 962:	02e48c63          	beq	s1,a4,99a <malloc+0xa8>
                p->s.size -= nunits;
 966:	4137073b          	subw	a4,a4,s3
 96a:	c798                	sw	a4,8(a5)
                p += p->s.size;
 96c:	02071693          	slli	a3,a4,0x20
 970:	01c6d713          	srli	a4,a3,0x1c
 974:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 976:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 97a:	00000717          	auipc	a4,0x0
 97e:	68a73323          	sd	a0,1670(a4) # 1000 <freep>
            return (void *)(p + 1);
 982:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 986:	70e2                	ld	ra,56(sp)
 988:	7442                	ld	s0,48(sp)
 98a:	74a2                	ld	s1,40(sp)
 98c:	7902                	ld	s2,32(sp)
 98e:	69e2                	ld	s3,24(sp)
 990:	6a42                	ld	s4,16(sp)
 992:	6aa2                	ld	s5,8(sp)
 994:	6b02                	ld	s6,0(sp)
 996:	6121                	addi	sp,sp,64
 998:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 99a:	6398                	ld	a4,0(a5)
 99c:	e118                	sd	a4,0(a0)
 99e:	bff1                	j	97a <malloc+0x88>
    hp->s.size = nu;
 9a0:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 9a4:	0541                	addi	a0,a0,16
 9a6:	00000097          	auipc	ra,0x0
 9aa:	eca080e7          	jalr	-310(ra) # 870 <free>
    return freep;
 9ae:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 9b2:	d971                	beqz	a0,986 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 9b4:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 9b6:	4798                	lw	a4,8(a5)
 9b8:	fa9775e3          	bgeu	a4,s1,962 <malloc+0x70>
        if (p == freep)
 9bc:	00093703          	ld	a4,0(s2)
 9c0:	853e                	mv	a0,a5
 9c2:	fef719e3          	bne	a4,a5,9b4 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 9c6:	8552                	mv	a0,s4
 9c8:	00000097          	auipc	ra,0x0
 9cc:	b68080e7          	jalr	-1176(ra) # 530 <sbrk>
    if (p == (char *)-1)
 9d0:	fd5518e3          	bne	a0,s5,9a0 <malloc+0xae>
                return 0;
 9d4:	4501                	li	a0,0
 9d6:	bf45                	j	986 <malloc+0x94>
