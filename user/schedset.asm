
user/_schedset:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (argc != 2)
   8:	4789                	li	a5,2
   a:	00f50f63          	beq	a0,a5,28 <main+0x28>
    {
        printf("Usage: schedset [SCHED ID]\n");
   e:	00001517          	auipc	a0,0x1
  12:	9c250513          	addi	a0,a0,-1598 # 9d0 <malloc+0xf4>
  16:	00001097          	auipc	ra,0x1
  1a:	80e080e7          	jalr	-2034(ra) # 824 <printf>
        exit(1);
  1e:	4505                	li	a0,1
  20:	00000097          	auipc	ra,0x0
  24:	472080e7          	jalr	1138(ra) # 492 <exit>
    }
    int schedid = (*argv[1]) - '0';
  28:	659c                	ld	a5,8(a1)
  2a:	0007c503          	lbu	a0,0(a5)
    schedset(schedid);
  2e:	fd05051b          	addiw	a0,a0,-48
  32:	00000097          	auipc	ra,0x0
  36:	510080e7          	jalr	1296(ra) # 542 <schedset>
    exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	456080e7          	jalr	1110(ra) # 492 <exit>

0000000000000044 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
    lk->name = name;
  4a:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  4c:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  50:	57fd                	li	a5,-1
  52:	00f50823          	sb	a5,16(a0)
}
  56:	6422                	ld	s0,8(sp)
  58:	0141                	addi	sp,sp,16
  5a:	8082                	ret

000000000000005c <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  5c:	00054783          	lbu	a5,0(a0)
  60:	e399                	bnez	a5,66 <holding+0xa>
  62:	4501                	li	a0,0
}
  64:	8082                	ret
{
  66:	1101                	addi	sp,sp,-32
  68:	ec06                	sd	ra,24(sp)
  6a:	e822                	sd	s0,16(sp)
  6c:	e426                	sd	s1,8(sp)
  6e:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  70:	01054483          	lbu	s1,16(a0)
  74:	00000097          	auipc	ra,0x0
  78:	122080e7          	jalr	290(ra) # 196 <twhoami>
  7c:	2501                	sext.w	a0,a0
  7e:	40a48533          	sub	a0,s1,a0
  82:	00153513          	seqz	a0,a0
}
  86:	60e2                	ld	ra,24(sp)
  88:	6442                	ld	s0,16(sp)
  8a:	64a2                	ld	s1,8(sp)
  8c:	6105                	addi	sp,sp,32
  8e:	8082                	ret

0000000000000090 <acquire>:

void acquire(struct lock *lk)
{
  90:	7179                	addi	sp,sp,-48
  92:	f406                	sd	ra,40(sp)
  94:	f022                	sd	s0,32(sp)
  96:	ec26                	sd	s1,24(sp)
  98:	e84a                	sd	s2,16(sp)
  9a:	e44e                	sd	s3,8(sp)
  9c:	e052                	sd	s4,0(sp)
  9e:	1800                	addi	s0,sp,48
  a0:	8a2a                	mv	s4,a0
    if (holding(lk))
  a2:	00000097          	auipc	ra,0x0
  a6:	fba080e7          	jalr	-70(ra) # 5c <holding>
  aa:	e919                	bnez	a0,c0 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  ac:	ffca7493          	andi	s1,s4,-4
  b0:	003a7913          	andi	s2,s4,3
  b4:	0039191b          	slliw	s2,s2,0x3
  b8:	4985                	li	s3,1
  ba:	012999bb          	sllw	s3,s3,s2
  be:	a015                	j	e2 <acquire+0x52>
        printf("re-acquiring lock we already hold");
  c0:	00001517          	auipc	a0,0x1
  c4:	93050513          	addi	a0,a0,-1744 # 9f0 <malloc+0x114>
  c8:	00000097          	auipc	ra,0x0
  cc:	75c080e7          	jalr	1884(ra) # 824 <printf>
        exit(-1);
  d0:	557d                	li	a0,-1
  d2:	00000097          	auipc	ra,0x0
  d6:	3c0080e7          	jalr	960(ra) # 492 <exit>
    {
        // give up the cpu for other threads
        tyield();
  da:	00000097          	auipc	ra,0x0
  de:	0b0080e7          	jalr	176(ra) # 18a <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  e2:	4534a7af          	amoor.w.aq	a5,s3,(s1)
  e6:	0127d7bb          	srlw	a5,a5,s2
  ea:	0ff7f793          	zext.b	a5,a5
  ee:	f7f5                	bnez	a5,da <acquire+0x4a>
    }

    __sync_synchronize();
  f0:	0ff0000f          	fence

    lk->tid = twhoami();
  f4:	00000097          	auipc	ra,0x0
  f8:	0a2080e7          	jalr	162(ra) # 196 <twhoami>
  fc:	00aa0823          	sb	a0,16(s4)
}
 100:	70a2                	ld	ra,40(sp)
 102:	7402                	ld	s0,32(sp)
 104:	64e2                	ld	s1,24(sp)
 106:	6942                	ld	s2,16(sp)
 108:	69a2                	ld	s3,8(sp)
 10a:	6a02                	ld	s4,0(sp)
 10c:	6145                	addi	sp,sp,48
 10e:	8082                	ret

0000000000000110 <release>:

void release(struct lock *lk)
{
 110:	1101                	addi	sp,sp,-32
 112:	ec06                	sd	ra,24(sp)
 114:	e822                	sd	s0,16(sp)
 116:	e426                	sd	s1,8(sp)
 118:	1000                	addi	s0,sp,32
 11a:	84aa                	mv	s1,a0
    if (!holding(lk))
 11c:	00000097          	auipc	ra,0x0
 120:	f40080e7          	jalr	-192(ra) # 5c <holding>
 124:	c11d                	beqz	a0,14a <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 126:	57fd                	li	a5,-1
 128:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 12c:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 130:	0ff0000f          	fence
 134:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 138:	00000097          	auipc	ra,0x0
 13c:	052080e7          	jalr	82(ra) # 18a <tyield>
}
 140:	60e2                	ld	ra,24(sp)
 142:	6442                	ld	s0,16(sp)
 144:	64a2                	ld	s1,8(sp)
 146:	6105                	addi	sp,sp,32
 148:	8082                	ret
        printf("releasing lock we are not holding");
 14a:	00001517          	auipc	a0,0x1
 14e:	8ce50513          	addi	a0,a0,-1842 # a18 <malloc+0x13c>
 152:	00000097          	auipc	ra,0x0
 156:	6d2080e7          	jalr	1746(ra) # 824 <printf>
        exit(-1);
 15a:	557d                	li	a0,-1
 15c:	00000097          	auipc	ra,0x0
 160:	336080e7          	jalr	822(ra) # 492 <exit>

0000000000000164 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 164:	1141                	addi	sp,sp,-16
 166:	e422                	sd	s0,8(sp)
 168:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 16a:	6422                	ld	s0,8(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret

0000000000000170 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 170:	1141                	addi	sp,sp,-16
 172:	e422                	sd	s0,8(sp)
 174:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 182:	4501                	li	a0,0
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <tyield>:

void tyield()
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 190:	6422                	ld	s0,8(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret

0000000000000196 <twhoami>:

uint8 twhoami()
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 19c:	4501                	li	a0,0
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <tswtch>:
 1a4:	00153023          	sd	ra,0(a0)
 1a8:	00253423          	sd	sp,8(a0)
 1ac:	e900                	sd	s0,16(a0)
 1ae:	ed04                	sd	s1,24(a0)
 1b0:	03253023          	sd	s2,32(a0)
 1b4:	03353423          	sd	s3,40(a0)
 1b8:	03453823          	sd	s4,48(a0)
 1bc:	03553c23          	sd	s5,56(a0)
 1c0:	05653023          	sd	s6,64(a0)
 1c4:	05753423          	sd	s7,72(a0)
 1c8:	05853823          	sd	s8,80(a0)
 1cc:	05953c23          	sd	s9,88(a0)
 1d0:	07a53023          	sd	s10,96(a0)
 1d4:	07b53423          	sd	s11,104(a0)
 1d8:	0005b083          	ld	ra,0(a1)
 1dc:	0085b103          	ld	sp,8(a1)
 1e0:	6980                	ld	s0,16(a1)
 1e2:	6d84                	ld	s1,24(a1)
 1e4:	0205b903          	ld	s2,32(a1)
 1e8:	0285b983          	ld	s3,40(a1)
 1ec:	0305ba03          	ld	s4,48(a1)
 1f0:	0385ba83          	ld	s5,56(a1)
 1f4:	0405bb03          	ld	s6,64(a1)
 1f8:	0485bb83          	ld	s7,72(a1)
 1fc:	0505bc03          	ld	s8,80(a1)
 200:	0585bc83          	ld	s9,88(a1)
 204:	0605bd03          	ld	s10,96(a1)
 208:	0685bd83          	ld	s11,104(a1)
 20c:	8082                	ret

000000000000020e <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 20e:	1141                	addi	sp,sp,-16
 210:	e406                	sd	ra,8(sp)
 212:	e022                	sd	s0,0(sp)
 214:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 216:	00000097          	auipc	ra,0x0
 21a:	dea080e7          	jalr	-534(ra) # 0 <main>
    exit(res);
 21e:	00000097          	auipc	ra,0x0
 222:	274080e7          	jalr	628(ra) # 492 <exit>

0000000000000226 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 226:	1141                	addi	sp,sp,-16
 228:	e422                	sd	s0,8(sp)
 22a:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 22c:	87aa                	mv	a5,a0
 22e:	0585                	addi	a1,a1,1
 230:	0785                	addi	a5,a5,1
 232:	fff5c703          	lbu	a4,-1(a1)
 236:	fee78fa3          	sb	a4,-1(a5)
 23a:	fb75                	bnez	a4,22e <strcpy+0x8>
        ;
    return os;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <strcmp>:

int strcmp(const char *p, const char *q)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 248:	00054783          	lbu	a5,0(a0)
 24c:	cb91                	beqz	a5,260 <strcmp+0x1e>
 24e:	0005c703          	lbu	a4,0(a1)
 252:	00f71763          	bne	a4,a5,260 <strcmp+0x1e>
        p++, q++;
 256:	0505                	addi	a0,a0,1
 258:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 25a:	00054783          	lbu	a5,0(a0)
 25e:	fbe5                	bnez	a5,24e <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 260:	0005c503          	lbu	a0,0(a1)
}
 264:	40a7853b          	subw	a0,a5,a0
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret

000000000000026e <strlen>:

uint strlen(const char *s)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 274:	00054783          	lbu	a5,0(a0)
 278:	cf91                	beqz	a5,294 <strlen+0x26>
 27a:	0505                	addi	a0,a0,1
 27c:	87aa                	mv	a5,a0
 27e:	4685                	li	a3,1
 280:	9e89                	subw	a3,a3,a0
 282:	00f6853b          	addw	a0,a3,a5
 286:	0785                	addi	a5,a5,1
 288:	fff7c703          	lbu	a4,-1(a5)
 28c:	fb7d                	bnez	a4,282 <strlen+0x14>
        ;
    return n;
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
    for (n = 0; s[n]; n++)
 294:	4501                	li	a0,0
 296:	bfe5                	j	28e <strlen+0x20>

0000000000000298 <memset>:

void *
memset(void *dst, int c, uint n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 29e:	ca19                	beqz	a2,2b4 <memset+0x1c>
 2a0:	87aa                	mv	a5,a0
 2a2:	1602                	slli	a2,a2,0x20
 2a4:	9201                	srli	a2,a2,0x20
 2a6:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 2aa:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 2ae:	0785                	addi	a5,a5,1
 2b0:	fee79de3          	bne	a5,a4,2aa <memset+0x12>
    }
    return dst;
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strchr>:

char *
strchr(const char *s, char c)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
    for (; *s; s++)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cb99                	beqz	a5,2da <strchr+0x20>
        if (*s == c)
 2c6:	00f58763          	beq	a1,a5,2d4 <strchr+0x1a>
    for (; *s; s++)
 2ca:	0505                	addi	a0,a0,1
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	fbfd                	bnez	a5,2c6 <strchr+0xc>
            return (char *)s;
    return 0;
 2d2:	4501                	li	a0,0
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
    return 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <strchr+0x1a>

00000000000002de <gets>:

char *
gets(char *buf, int max)
{
 2de:	711d                	addi	sp,sp,-96
 2e0:	ec86                	sd	ra,88(sp)
 2e2:	e8a2                	sd	s0,80(sp)
 2e4:	e4a6                	sd	s1,72(sp)
 2e6:	e0ca                	sd	s2,64(sp)
 2e8:	fc4e                	sd	s3,56(sp)
 2ea:	f852                	sd	s4,48(sp)
 2ec:	f456                	sd	s5,40(sp)
 2ee:	f05a                	sd	s6,32(sp)
 2f0:	ec5e                	sd	s7,24(sp)
 2f2:	1080                	addi	s0,sp,96
 2f4:	8baa                	mv	s7,a0
 2f6:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 2f8:	892a                	mv	s2,a0
 2fa:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 2fc:	4aa9                	li	s5,10
 2fe:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 300:	89a6                	mv	s3,s1
 302:	2485                	addiw	s1,s1,1
 304:	0344d863          	bge	s1,s4,334 <gets+0x56>
        cc = read(0, &c, 1);
 308:	4605                	li	a2,1
 30a:	faf40593          	addi	a1,s0,-81
 30e:	4501                	li	a0,0
 310:	00000097          	auipc	ra,0x0
 314:	19a080e7          	jalr	410(ra) # 4aa <read>
        if (cc < 1)
 318:	00a05e63          	blez	a0,334 <gets+0x56>
        buf[i++] = c;
 31c:	faf44783          	lbu	a5,-81(s0)
 320:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 324:	01578763          	beq	a5,s5,332 <gets+0x54>
 328:	0905                	addi	s2,s2,1
 32a:	fd679be3          	bne	a5,s6,300 <gets+0x22>
    for (i = 0; i + 1 < max;)
 32e:	89a6                	mv	s3,s1
 330:	a011                	j	334 <gets+0x56>
 332:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 334:	99de                	add	s3,s3,s7
 336:	00098023          	sb	zero,0(s3)
    return buf;
}
 33a:	855e                	mv	a0,s7
 33c:	60e6                	ld	ra,88(sp)
 33e:	6446                	ld	s0,80(sp)
 340:	64a6                	ld	s1,72(sp)
 342:	6906                	ld	s2,64(sp)
 344:	79e2                	ld	s3,56(sp)
 346:	7a42                	ld	s4,48(sp)
 348:	7aa2                	ld	s5,40(sp)
 34a:	7b02                	ld	s6,32(sp)
 34c:	6be2                	ld	s7,24(sp)
 34e:	6125                	addi	sp,sp,96
 350:	8082                	ret

0000000000000352 <stat>:

int stat(const char *n, struct stat *st)
{
 352:	1101                	addi	sp,sp,-32
 354:	ec06                	sd	ra,24(sp)
 356:	e822                	sd	s0,16(sp)
 358:	e426                	sd	s1,8(sp)
 35a:	e04a                	sd	s2,0(sp)
 35c:	1000                	addi	s0,sp,32
 35e:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 360:	4581                	li	a1,0
 362:	00000097          	auipc	ra,0x0
 366:	170080e7          	jalr	368(ra) # 4d2 <open>
    if (fd < 0)
 36a:	02054563          	bltz	a0,394 <stat+0x42>
 36e:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 370:	85ca                	mv	a1,s2
 372:	00000097          	auipc	ra,0x0
 376:	178080e7          	jalr	376(ra) # 4ea <fstat>
 37a:	892a                	mv	s2,a0
    close(fd);
 37c:	8526                	mv	a0,s1
 37e:	00000097          	auipc	ra,0x0
 382:	13c080e7          	jalr	316(ra) # 4ba <close>
    return r;
}
 386:	854a                	mv	a0,s2
 388:	60e2                	ld	ra,24(sp)
 38a:	6442                	ld	s0,16(sp)
 38c:	64a2                	ld	s1,8(sp)
 38e:	6902                	ld	s2,0(sp)
 390:	6105                	addi	sp,sp,32
 392:	8082                	ret
        return -1;
 394:	597d                	li	s2,-1
 396:	bfc5                	j	386 <stat+0x34>

0000000000000398 <atoi>:

int atoi(const char *s)
{
 398:	1141                	addi	sp,sp,-16
 39a:	e422                	sd	s0,8(sp)
 39c:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 39e:	00054683          	lbu	a3,0(a0)
 3a2:	fd06879b          	addiw	a5,a3,-48
 3a6:	0ff7f793          	zext.b	a5,a5
 3aa:	4625                	li	a2,9
 3ac:	02f66863          	bltu	a2,a5,3dc <atoi+0x44>
 3b0:	872a                	mv	a4,a0
    n = 0;
 3b2:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 3b4:	0705                	addi	a4,a4,1
 3b6:	0025179b          	slliw	a5,a0,0x2
 3ba:	9fa9                	addw	a5,a5,a0
 3bc:	0017979b          	slliw	a5,a5,0x1
 3c0:	9fb5                	addw	a5,a5,a3
 3c2:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 3c6:	00074683          	lbu	a3,0(a4)
 3ca:	fd06879b          	addiw	a5,a3,-48
 3ce:	0ff7f793          	zext.b	a5,a5
 3d2:	fef671e3          	bgeu	a2,a5,3b4 <atoi+0x1c>
    return n;
}
 3d6:	6422                	ld	s0,8(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret
    n = 0;
 3dc:	4501                	li	a0,0
 3de:	bfe5                	j	3d6 <atoi+0x3e>

00000000000003e0 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 3e0:	1141                	addi	sp,sp,-16
 3e2:	e422                	sd	s0,8(sp)
 3e4:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 3e6:	02b57463          	bgeu	a0,a1,40e <memmove+0x2e>
    {
        while (n-- > 0)
 3ea:	00c05f63          	blez	a2,408 <memmove+0x28>
 3ee:	1602                	slli	a2,a2,0x20
 3f0:	9201                	srli	a2,a2,0x20
 3f2:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 3f6:	872a                	mv	a4,a0
            *dst++ = *src++;
 3f8:	0585                	addi	a1,a1,1
 3fa:	0705                	addi	a4,a4,1
 3fc:	fff5c683          	lbu	a3,-1(a1)
 400:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 404:	fee79ae3          	bne	a5,a4,3f8 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 408:	6422                	ld	s0,8(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret
        dst += n;
 40e:	00c50733          	add	a4,a0,a2
        src += n;
 412:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 414:	fec05ae3          	blez	a2,408 <memmove+0x28>
 418:	fff6079b          	addiw	a5,a2,-1
 41c:	1782                	slli	a5,a5,0x20
 41e:	9381                	srli	a5,a5,0x20
 420:	fff7c793          	not	a5,a5
 424:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 426:	15fd                	addi	a1,a1,-1
 428:	177d                	addi	a4,a4,-1
 42a:	0005c683          	lbu	a3,0(a1)
 42e:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 432:	fee79ae3          	bne	a5,a4,426 <memmove+0x46>
 436:	bfc9                	j	408 <memmove+0x28>

0000000000000438 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 438:	1141                	addi	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 43e:	ca05                	beqz	a2,46e <memcmp+0x36>
 440:	fff6069b          	addiw	a3,a2,-1
 444:	1682                	slli	a3,a3,0x20
 446:	9281                	srli	a3,a3,0x20
 448:	0685                	addi	a3,a3,1
 44a:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 44c:	00054783          	lbu	a5,0(a0)
 450:	0005c703          	lbu	a4,0(a1)
 454:	00e79863          	bne	a5,a4,464 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 458:	0505                	addi	a0,a0,1
        p2++;
 45a:	0585                	addi	a1,a1,1
    while (n-- > 0)
 45c:	fed518e3          	bne	a0,a3,44c <memcmp+0x14>
    }
    return 0;
 460:	4501                	li	a0,0
 462:	a019                	j	468 <memcmp+0x30>
            return *p1 - *p2;
 464:	40e7853b          	subw	a0,a5,a4
}
 468:	6422                	ld	s0,8(sp)
 46a:	0141                	addi	sp,sp,16
 46c:	8082                	ret
    return 0;
 46e:	4501                	li	a0,0
 470:	bfe5                	j	468 <memcmp+0x30>

0000000000000472 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 472:	1141                	addi	sp,sp,-16
 474:	e406                	sd	ra,8(sp)
 476:	e022                	sd	s0,0(sp)
 478:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 47a:	00000097          	auipc	ra,0x0
 47e:	f66080e7          	jalr	-154(ra) # 3e0 <memmove>
}
 482:	60a2                	ld	ra,8(sp)
 484:	6402                	ld	s0,0(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret

000000000000048a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 48a:	4885                	li	a7,1
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <exit>:
.global exit
exit:
 li a7, SYS_exit
 492:	4889                	li	a7,2
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <wait>:
.global wait
wait:
 li a7, SYS_wait
 49a:	488d                	li	a7,3
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4a2:	4891                	li	a7,4
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <read>:
.global read
read:
 li a7, SYS_read
 4aa:	4895                	li	a7,5
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <write>:
.global write
write:
 li a7, SYS_write
 4b2:	48c1                	li	a7,16
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <close>:
.global close
close:
 li a7, SYS_close
 4ba:	48d5                	li	a7,21
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4c2:	4899                	li	a7,6
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ca:	489d                	li	a7,7
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <open>:
.global open
open:
 li a7, SYS_open
 4d2:	48bd                	li	a7,15
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4da:	48c5                	li	a7,17
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4e2:	48c9                	li	a7,18
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4ea:	48a1                	li	a7,8
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <link>:
.global link
link:
 li a7, SYS_link
 4f2:	48cd                	li	a7,19
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4fa:	48d1                	li	a7,20
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 502:	48a5                	li	a7,9
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <dup>:
.global dup
dup:
 li a7, SYS_dup
 50a:	48a9                	li	a7,10
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 512:	48ad                	li	a7,11
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 51a:	48b1                	li	a7,12
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 522:	48b5                	li	a7,13
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 52a:	48b9                	li	a7,14
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <ps>:
.global ps
ps:
 li a7, SYS_ps
 532:	48d9                	li	a7,22
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 53a:	48dd                	li	a7,23
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 542:	48e1                	li	a7,24
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 54a:	1101                	addi	sp,sp,-32
 54c:	ec06                	sd	ra,24(sp)
 54e:	e822                	sd	s0,16(sp)
 550:	1000                	addi	s0,sp,32
 552:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 556:	4605                	li	a2,1
 558:	fef40593          	addi	a1,s0,-17
 55c:	00000097          	auipc	ra,0x0
 560:	f56080e7          	jalr	-170(ra) # 4b2 <write>
}
 564:	60e2                	ld	ra,24(sp)
 566:	6442                	ld	s0,16(sp)
 568:	6105                	addi	sp,sp,32
 56a:	8082                	ret

000000000000056c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 56c:	7139                	addi	sp,sp,-64
 56e:	fc06                	sd	ra,56(sp)
 570:	f822                	sd	s0,48(sp)
 572:	f426                	sd	s1,40(sp)
 574:	f04a                	sd	s2,32(sp)
 576:	ec4e                	sd	s3,24(sp)
 578:	0080                	addi	s0,sp,64
 57a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 57c:	c299                	beqz	a3,582 <printint+0x16>
 57e:	0805c963          	bltz	a1,610 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 582:	2581                	sext.w	a1,a1
  neg = 0;
 584:	4881                	li	a7,0
 586:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 58a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 58c:	2601                	sext.w	a2,a2
 58e:	00000517          	auipc	a0,0x0
 592:	51250513          	addi	a0,a0,1298 # aa0 <digits>
 596:	883a                	mv	a6,a4
 598:	2705                	addiw	a4,a4,1
 59a:	02c5f7bb          	remuw	a5,a1,a2
 59e:	1782                	slli	a5,a5,0x20
 5a0:	9381                	srli	a5,a5,0x20
 5a2:	97aa                	add	a5,a5,a0
 5a4:	0007c783          	lbu	a5,0(a5)
 5a8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ac:	0005879b          	sext.w	a5,a1
 5b0:	02c5d5bb          	divuw	a1,a1,a2
 5b4:	0685                	addi	a3,a3,1
 5b6:	fec7f0e3          	bgeu	a5,a2,596 <printint+0x2a>
  if(neg)
 5ba:	00088c63          	beqz	a7,5d2 <printint+0x66>
    buf[i++] = '-';
 5be:	fd070793          	addi	a5,a4,-48
 5c2:	00878733          	add	a4,a5,s0
 5c6:	02d00793          	li	a5,45
 5ca:	fef70823          	sb	a5,-16(a4)
 5ce:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5d2:	02e05863          	blez	a4,602 <printint+0x96>
 5d6:	fc040793          	addi	a5,s0,-64
 5da:	00e78933          	add	s2,a5,a4
 5de:	fff78993          	addi	s3,a5,-1
 5e2:	99ba                	add	s3,s3,a4
 5e4:	377d                	addiw	a4,a4,-1
 5e6:	1702                	slli	a4,a4,0x20
 5e8:	9301                	srli	a4,a4,0x20
 5ea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ee:	fff94583          	lbu	a1,-1(s2)
 5f2:	8526                	mv	a0,s1
 5f4:	00000097          	auipc	ra,0x0
 5f8:	f56080e7          	jalr	-170(ra) # 54a <putc>
  while(--i >= 0)
 5fc:	197d                	addi	s2,s2,-1
 5fe:	ff3918e3          	bne	s2,s3,5ee <printint+0x82>
}
 602:	70e2                	ld	ra,56(sp)
 604:	7442                	ld	s0,48(sp)
 606:	74a2                	ld	s1,40(sp)
 608:	7902                	ld	s2,32(sp)
 60a:	69e2                	ld	s3,24(sp)
 60c:	6121                	addi	sp,sp,64
 60e:	8082                	ret
    x = -xx;
 610:	40b005bb          	negw	a1,a1
    neg = 1;
 614:	4885                	li	a7,1
    x = -xx;
 616:	bf85                	j	586 <printint+0x1a>

0000000000000618 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 618:	7119                	addi	sp,sp,-128
 61a:	fc86                	sd	ra,120(sp)
 61c:	f8a2                	sd	s0,112(sp)
 61e:	f4a6                	sd	s1,104(sp)
 620:	f0ca                	sd	s2,96(sp)
 622:	ecce                	sd	s3,88(sp)
 624:	e8d2                	sd	s4,80(sp)
 626:	e4d6                	sd	s5,72(sp)
 628:	e0da                	sd	s6,64(sp)
 62a:	fc5e                	sd	s7,56(sp)
 62c:	f862                	sd	s8,48(sp)
 62e:	f466                	sd	s9,40(sp)
 630:	f06a                	sd	s10,32(sp)
 632:	ec6e                	sd	s11,24(sp)
 634:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 636:	0005c903          	lbu	s2,0(a1)
 63a:	18090f63          	beqz	s2,7d8 <vprintf+0x1c0>
 63e:	8aaa                	mv	s5,a0
 640:	8b32                	mv	s6,a2
 642:	00158493          	addi	s1,a1,1
  state = 0;
 646:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 648:	02500a13          	li	s4,37
 64c:	4c55                	li	s8,21
 64e:	00000c97          	auipc	s9,0x0
 652:	3fac8c93          	addi	s9,s9,1018 # a48 <malloc+0x16c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 656:	02800d93          	li	s11,40
  putc(fd, 'x');
 65a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65c:	00000b97          	auipc	s7,0x0
 660:	444b8b93          	addi	s7,s7,1092 # aa0 <digits>
 664:	a839                	j	682 <vprintf+0x6a>
        putc(fd, c);
 666:	85ca                	mv	a1,s2
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	ee0080e7          	jalr	-288(ra) # 54a <putc>
 672:	a019                	j	678 <vprintf+0x60>
    } else if(state == '%'){
 674:	01498d63          	beq	s3,s4,68e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 678:	0485                	addi	s1,s1,1
 67a:	fff4c903          	lbu	s2,-1(s1)
 67e:	14090d63          	beqz	s2,7d8 <vprintf+0x1c0>
    if(state == 0){
 682:	fe0999e3          	bnez	s3,674 <vprintf+0x5c>
      if(c == '%'){
 686:	ff4910e3          	bne	s2,s4,666 <vprintf+0x4e>
        state = '%';
 68a:	89d2                	mv	s3,s4
 68c:	b7f5                	j	678 <vprintf+0x60>
      if(c == 'd'){
 68e:	11490c63          	beq	s2,s4,7a6 <vprintf+0x18e>
 692:	f9d9079b          	addiw	a5,s2,-99
 696:	0ff7f793          	zext.b	a5,a5
 69a:	10fc6e63          	bltu	s8,a5,7b6 <vprintf+0x19e>
 69e:	f9d9079b          	addiw	a5,s2,-99
 6a2:	0ff7f713          	zext.b	a4,a5
 6a6:	10ec6863          	bltu	s8,a4,7b6 <vprintf+0x19e>
 6aa:	00271793          	slli	a5,a4,0x2
 6ae:	97e6                	add	a5,a5,s9
 6b0:	439c                	lw	a5,0(a5)
 6b2:	97e6                	add	a5,a5,s9
 6b4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6b6:	008b0913          	addi	s2,s6,8
 6ba:	4685                	li	a3,1
 6bc:	4629                	li	a2,10
 6be:	000b2583          	lw	a1,0(s6)
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	ea8080e7          	jalr	-344(ra) # 56c <printint>
 6cc:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	b765                	j	678 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d2:	008b0913          	addi	s2,s6,8
 6d6:	4681                	li	a3,0
 6d8:	4629                	li	a2,10
 6da:	000b2583          	lw	a1,0(s6)
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e8c080e7          	jalr	-372(ra) # 56c <printint>
 6e8:	8b4a                	mv	s6,s2
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b771                	j	678 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6ee:	008b0913          	addi	s2,s6,8
 6f2:	4681                	li	a3,0
 6f4:	866a                	mv	a2,s10
 6f6:	000b2583          	lw	a1,0(s6)
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	e70080e7          	jalr	-400(ra) # 56c <printint>
 704:	8b4a                	mv	s6,s2
      state = 0;
 706:	4981                	li	s3,0
 708:	bf85                	j	678 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 70a:	008b0793          	addi	a5,s6,8
 70e:	f8f43423          	sd	a5,-120(s0)
 712:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 716:	03000593          	li	a1,48
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	e2e080e7          	jalr	-466(ra) # 54a <putc>
  putc(fd, 'x');
 724:	07800593          	li	a1,120
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	e20080e7          	jalr	-480(ra) # 54a <putc>
 732:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 734:	03c9d793          	srli	a5,s3,0x3c
 738:	97de                	add	a5,a5,s7
 73a:	0007c583          	lbu	a1,0(a5)
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	e0a080e7          	jalr	-502(ra) # 54a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 748:	0992                	slli	s3,s3,0x4
 74a:	397d                	addiw	s2,s2,-1
 74c:	fe0914e3          	bnez	s2,734 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 750:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 754:	4981                	li	s3,0
 756:	b70d                	j	678 <vprintf+0x60>
        s = va_arg(ap, char*);
 758:	008b0913          	addi	s2,s6,8
 75c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 760:	02098163          	beqz	s3,782 <vprintf+0x16a>
        while(*s != 0){
 764:	0009c583          	lbu	a1,0(s3)
 768:	c5ad                	beqz	a1,7d2 <vprintf+0x1ba>
          putc(fd, *s);
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	dde080e7          	jalr	-546(ra) # 54a <putc>
          s++;
 774:	0985                	addi	s3,s3,1
        while(*s != 0){
 776:	0009c583          	lbu	a1,0(s3)
 77a:	f9e5                	bnez	a1,76a <vprintf+0x152>
        s = va_arg(ap, char*);
 77c:	8b4a                	mv	s6,s2
      state = 0;
 77e:	4981                	li	s3,0
 780:	bde5                	j	678 <vprintf+0x60>
          s = "(null)";
 782:	00000997          	auipc	s3,0x0
 786:	2be98993          	addi	s3,s3,702 # a40 <malloc+0x164>
        while(*s != 0){
 78a:	85ee                	mv	a1,s11
 78c:	bff9                	j	76a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 78e:	008b0913          	addi	s2,s6,8
 792:	000b4583          	lbu	a1,0(s6)
 796:	8556                	mv	a0,s5
 798:	00000097          	auipc	ra,0x0
 79c:	db2080e7          	jalr	-590(ra) # 54a <putc>
 7a0:	8b4a                	mv	s6,s2
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	bdd1                	j	678 <vprintf+0x60>
        putc(fd, c);
 7a6:	85d2                	mv	a1,s4
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	da0080e7          	jalr	-608(ra) # 54a <putc>
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	b5d1                	j	678 <vprintf+0x60>
        putc(fd, '%');
 7b6:	85d2                	mv	a1,s4
 7b8:	8556                	mv	a0,s5
 7ba:	00000097          	auipc	ra,0x0
 7be:	d90080e7          	jalr	-624(ra) # 54a <putc>
        putc(fd, c);
 7c2:	85ca                	mv	a1,s2
 7c4:	8556                	mv	a0,s5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	d84080e7          	jalr	-636(ra) # 54a <putc>
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	b565                	j	678 <vprintf+0x60>
        s = va_arg(ap, char*);
 7d2:	8b4a                	mv	s6,s2
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	b54d                	j	678 <vprintf+0x60>
    }
  }
}
 7d8:	70e6                	ld	ra,120(sp)
 7da:	7446                	ld	s0,112(sp)
 7dc:	74a6                	ld	s1,104(sp)
 7de:	7906                	ld	s2,96(sp)
 7e0:	69e6                	ld	s3,88(sp)
 7e2:	6a46                	ld	s4,80(sp)
 7e4:	6aa6                	ld	s5,72(sp)
 7e6:	6b06                	ld	s6,64(sp)
 7e8:	7be2                	ld	s7,56(sp)
 7ea:	7c42                	ld	s8,48(sp)
 7ec:	7ca2                	ld	s9,40(sp)
 7ee:	7d02                	ld	s10,32(sp)
 7f0:	6de2                	ld	s11,24(sp)
 7f2:	6109                	addi	sp,sp,128
 7f4:	8082                	ret

00000000000007f6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f6:	715d                	addi	sp,sp,-80
 7f8:	ec06                	sd	ra,24(sp)
 7fa:	e822                	sd	s0,16(sp)
 7fc:	1000                	addi	s0,sp,32
 7fe:	e010                	sd	a2,0(s0)
 800:	e414                	sd	a3,8(s0)
 802:	e818                	sd	a4,16(s0)
 804:	ec1c                	sd	a5,24(s0)
 806:	03043023          	sd	a6,32(s0)
 80a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 80e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 812:	8622                	mv	a2,s0
 814:	00000097          	auipc	ra,0x0
 818:	e04080e7          	jalr	-508(ra) # 618 <vprintf>
}
 81c:	60e2                	ld	ra,24(sp)
 81e:	6442                	ld	s0,16(sp)
 820:	6161                	addi	sp,sp,80
 822:	8082                	ret

0000000000000824 <printf>:

void
printf(const char *fmt, ...)
{
 824:	711d                	addi	sp,sp,-96
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e40c                	sd	a1,8(s0)
 82e:	e810                	sd	a2,16(s0)
 830:	ec14                	sd	a3,24(s0)
 832:	f018                	sd	a4,32(s0)
 834:	f41c                	sd	a5,40(s0)
 836:	03043823          	sd	a6,48(s0)
 83a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 83e:	00840613          	addi	a2,s0,8
 842:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 846:	85aa                	mv	a1,a0
 848:	4505                	li	a0,1
 84a:	00000097          	auipc	ra,0x0
 84e:	dce080e7          	jalr	-562(ra) # 618 <vprintf>
}
 852:	60e2                	ld	ra,24(sp)
 854:	6442                	ld	s0,16(sp)
 856:	6125                	addi	sp,sp,96
 858:	8082                	ret

000000000000085a <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 85a:	1141                	addi	sp,sp,-16
 85c:	e422                	sd	s0,8(sp)
 85e:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 860:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 864:	00000797          	auipc	a5,0x0
 868:	79c7b783          	ld	a5,1948(a5) # 1000 <freep>
 86c:	a02d                	j	896 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 86e:	4618                	lw	a4,8(a2)
 870:	9f2d                	addw	a4,a4,a1
 872:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 876:	6398                	ld	a4,0(a5)
 878:	6310                	ld	a2,0(a4)
 87a:	a83d                	j	8b8 <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 87c:	ff852703          	lw	a4,-8(a0)
 880:	9f31                	addw	a4,a4,a2
 882:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 884:	ff053683          	ld	a3,-16(a0)
 888:	a091                	j	8cc <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88a:	6398                	ld	a4,0(a5)
 88c:	00e7e463          	bltu	a5,a4,894 <free+0x3a>
 890:	00e6ea63          	bltu	a3,a4,8a4 <free+0x4a>
{
 894:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 896:	fed7fae3          	bgeu	a5,a3,88a <free+0x30>
 89a:	6398                	ld	a4,0(a5)
 89c:	00e6e463          	bltu	a3,a4,8a4 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	fee7eae3          	bltu	a5,a4,894 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 8a4:	ff852583          	lw	a1,-8(a0)
 8a8:	6390                	ld	a2,0(a5)
 8aa:	02059813          	slli	a6,a1,0x20
 8ae:	01c85713          	srli	a4,a6,0x1c
 8b2:	9736                	add	a4,a4,a3
 8b4:	fae60de3          	beq	a2,a4,86e <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 8b8:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 8bc:	4790                	lw	a2,8(a5)
 8be:	02061593          	slli	a1,a2,0x20
 8c2:	01c5d713          	srli	a4,a1,0x1c
 8c6:	973e                	add	a4,a4,a5
 8c8:	fae68ae3          	beq	a3,a4,87c <free+0x22>
        p->s.ptr = bp->s.ptr;
 8cc:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 8ce:	00000717          	auipc	a4,0x0
 8d2:	72f73923          	sd	a5,1842(a4) # 1000 <freep>
}
 8d6:	6422                	ld	s0,8(sp)
 8d8:	0141                	addi	sp,sp,16
 8da:	8082                	ret

00000000000008dc <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 8dc:	7139                	addi	sp,sp,-64
 8de:	fc06                	sd	ra,56(sp)
 8e0:	f822                	sd	s0,48(sp)
 8e2:	f426                	sd	s1,40(sp)
 8e4:	f04a                	sd	s2,32(sp)
 8e6:	ec4e                	sd	s3,24(sp)
 8e8:	e852                	sd	s4,16(sp)
 8ea:	e456                	sd	s5,8(sp)
 8ec:	e05a                	sd	s6,0(sp)
 8ee:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8f0:	02051493          	slli	s1,a0,0x20
 8f4:	9081                	srli	s1,s1,0x20
 8f6:	04bd                	addi	s1,s1,15
 8f8:	8091                	srli	s1,s1,0x4
 8fa:	0014899b          	addiw	s3,s1,1
 8fe:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 900:	00000517          	auipc	a0,0x0
 904:	70053503          	ld	a0,1792(a0) # 1000 <freep>
 908:	c515                	beqz	a0,934 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 90a:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 90c:	4798                	lw	a4,8(a5)
 90e:	02977f63          	bgeu	a4,s1,94c <malloc+0x70>
 912:	8a4e                	mv	s4,s3
 914:	0009871b          	sext.w	a4,s3
 918:	6685                	lui	a3,0x1
 91a:	00d77363          	bgeu	a4,a3,920 <malloc+0x44>
 91e:	6a05                	lui	s4,0x1
 920:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 924:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 928:	00000917          	auipc	s2,0x0
 92c:	6d890913          	addi	s2,s2,1752 # 1000 <freep>
    if (p == (char *)-1)
 930:	5afd                	li	s5,-1
 932:	a895                	j	9a6 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 934:	00000797          	auipc	a5,0x0
 938:	6dc78793          	addi	a5,a5,1756 # 1010 <base>
 93c:	00000717          	auipc	a4,0x0
 940:	6cf73223          	sd	a5,1732(a4) # 1000 <freep>
 944:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 946:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 94a:	b7e1                	j	912 <malloc+0x36>
            if (p->s.size == nunits)
 94c:	02e48c63          	beq	s1,a4,984 <malloc+0xa8>
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
            return (void *)(p + 1);
 96c:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 970:	70e2                	ld	ra,56(sp)
 972:	7442                	ld	s0,48(sp)
 974:	74a2                	ld	s1,40(sp)
 976:	7902                	ld	s2,32(sp)
 978:	69e2                	ld	s3,24(sp)
 97a:	6a42                	ld	s4,16(sp)
 97c:	6aa2                	ld	s5,8(sp)
 97e:	6b02                	ld	s6,0(sp)
 980:	6121                	addi	sp,sp,64
 982:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 984:	6398                	ld	a4,0(a5)
 986:	e118                	sd	a4,0(a0)
 988:	bff1                	j	964 <malloc+0x88>
    hp->s.size = nu;
 98a:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 98e:	0541                	addi	a0,a0,16
 990:	00000097          	auipc	ra,0x0
 994:	eca080e7          	jalr	-310(ra) # 85a <free>
    return freep;
 998:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 99c:	d971                	beqz	a0,970 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 99e:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 9a0:	4798                	lw	a4,8(a5)
 9a2:	fa9775e3          	bgeu	a4,s1,94c <malloc+0x70>
        if (p == freep)
 9a6:	00093703          	ld	a4,0(s2)
 9aa:	853e                	mv	a0,a5
 9ac:	fef719e3          	bne	a4,a5,99e <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 9b0:	8552                	mv	a0,s4
 9b2:	00000097          	auipc	ra,0x0
 9b6:	b68080e7          	jalr	-1176(ra) # 51a <sbrk>
    if (p == (char *)-1)
 9ba:	fd5518e3          	bne	a0,s5,98a <malloc+0xae>
                return 0;
 9be:	4501                	li	a0,0
 9c0:	bf45                	j	970 <malloc+0x94>
