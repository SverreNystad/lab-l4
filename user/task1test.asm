
user/_task1test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <hello_world>:
#include "kernel/types.h"
#include "user.h"

void *hello_world(void *arg)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("Hello World\n");
   8:	00001517          	auipc	a0,0x1
   c:	9c850513          	addi	a0,a0,-1592 # 9d0 <malloc+0xe6>
  10:	00001097          	auipc	ra,0x1
  14:	822080e7          	jalr	-2014(ra) # 832 <printf>
    return 0; // will be ignored, but just to make the compiler happy
}
  18:	4501                	li	a0,0
  1a:	60a2                	ld	ra,8(sp)
  1c:	6402                	ld	s0,0(sp)
  1e:	0141                	addi	sp,sp,16
  20:	8082                	ret

0000000000000022 <main>:

void main()
{
  22:	1101                	addi	sp,sp,-32
  24:	ec06                	sd	ra,24(sp)
  26:	e822                	sd	s0,16(sp)
  28:	1000                	addi	s0,sp,32
    // t not initialized
    struct thread *t;

    // passing &t (taking the address of the pointer value)
    tcreate(&t, 0, &hello_world, 0);
  2a:	4681                	li	a3,0
  2c:	00000617          	auipc	a2,0x0
  30:	fd460613          	addi	a2,a2,-44 # 0 <hello_world>
  34:	4581                	li	a1,0
  36:	fe840513          	addi	a0,s0,-24
  3a:	00000097          	auipc	ra,0x0
  3e:	144080e7          	jalr	324(ra) # 17e <tcreate>
    // Now, t points to an initialized thread struct

    tyield();
  42:	00000097          	auipc	ra,0x0
  46:	156080e7          	jalr	342(ra) # 198 <tyield>
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	6105                	addi	sp,sp,32
  50:	8082                	ret

0000000000000052 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  52:	1141                	addi	sp,sp,-16
  54:	e422                	sd	s0,8(sp)
  56:	0800                	addi	s0,sp,16
    lk->name = name;
  58:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  5a:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  5e:	57fd                	li	a5,-1
  60:	00f50823          	sb	a5,16(a0)
}
  64:	6422                	ld	s0,8(sp)
  66:	0141                	addi	sp,sp,16
  68:	8082                	ret

000000000000006a <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  6a:	00054783          	lbu	a5,0(a0)
  6e:	e399                	bnez	a5,74 <holding+0xa>
  70:	4501                	li	a0,0
}
  72:	8082                	ret
{
  74:	1101                	addi	sp,sp,-32
  76:	ec06                	sd	ra,24(sp)
  78:	e822                	sd	s0,16(sp)
  7a:	e426                	sd	s1,8(sp)
  7c:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  7e:	01054483          	lbu	s1,16(a0)
  82:	00000097          	auipc	ra,0x0
  86:	122080e7          	jalr	290(ra) # 1a4 <twhoami>
  8a:	2501                	sext.w	a0,a0
  8c:	40a48533          	sub	a0,s1,a0
  90:	00153513          	seqz	a0,a0
}
  94:	60e2                	ld	ra,24(sp)
  96:	6442                	ld	s0,16(sp)
  98:	64a2                	ld	s1,8(sp)
  9a:	6105                	addi	sp,sp,32
  9c:	8082                	ret

000000000000009e <acquire>:

void acquire(struct lock *lk)
{
  9e:	7179                	addi	sp,sp,-48
  a0:	f406                	sd	ra,40(sp)
  a2:	f022                	sd	s0,32(sp)
  a4:	ec26                	sd	s1,24(sp)
  a6:	e84a                	sd	s2,16(sp)
  a8:	e44e                	sd	s3,8(sp)
  aa:	e052                	sd	s4,0(sp)
  ac:	1800                	addi	s0,sp,48
  ae:	8a2a                	mv	s4,a0
    if (holding(lk))
  b0:	00000097          	auipc	ra,0x0
  b4:	fba080e7          	jalr	-70(ra) # 6a <holding>
  b8:	e919                	bnez	a0,ce <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  ba:	ffca7493          	andi	s1,s4,-4
  be:	003a7913          	andi	s2,s4,3
  c2:	0039191b          	slliw	s2,s2,0x3
  c6:	4985                	li	s3,1
  c8:	012999bb          	sllw	s3,s3,s2
  cc:	a015                	j	f0 <acquire+0x52>
        printf("re-acquiring lock we already hold");
  ce:	00001517          	auipc	a0,0x1
  d2:	91250513          	addi	a0,a0,-1774 # 9e0 <malloc+0xf6>
  d6:	00000097          	auipc	ra,0x0
  da:	75c080e7          	jalr	1884(ra) # 832 <printf>
        exit(-1);
  de:	557d                	li	a0,-1
  e0:	00000097          	auipc	ra,0x0
  e4:	3c0080e7          	jalr	960(ra) # 4a0 <exit>
    {
        // give up the cpu for other threads
        tyield();
  e8:	00000097          	auipc	ra,0x0
  ec:	0b0080e7          	jalr	176(ra) # 198 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  f0:	4534a7af          	amoor.w.aq	a5,s3,(s1)
  f4:	0127d7bb          	srlw	a5,a5,s2
  f8:	0ff7f793          	zext.b	a5,a5
  fc:	f7f5                	bnez	a5,e8 <acquire+0x4a>
    }

    __sync_synchronize();
  fe:	0ff0000f          	fence

    lk->tid = twhoami();
 102:	00000097          	auipc	ra,0x0
 106:	0a2080e7          	jalr	162(ra) # 1a4 <twhoami>
 10a:	00aa0823          	sb	a0,16(s4)
}
 10e:	70a2                	ld	ra,40(sp)
 110:	7402                	ld	s0,32(sp)
 112:	64e2                	ld	s1,24(sp)
 114:	6942                	ld	s2,16(sp)
 116:	69a2                	ld	s3,8(sp)
 118:	6a02                	ld	s4,0(sp)
 11a:	6145                	addi	sp,sp,48
 11c:	8082                	ret

000000000000011e <release>:

void release(struct lock *lk)
{
 11e:	1101                	addi	sp,sp,-32
 120:	ec06                	sd	ra,24(sp)
 122:	e822                	sd	s0,16(sp)
 124:	e426                	sd	s1,8(sp)
 126:	1000                	addi	s0,sp,32
 128:	84aa                	mv	s1,a0
    if (!holding(lk))
 12a:	00000097          	auipc	ra,0x0
 12e:	f40080e7          	jalr	-192(ra) # 6a <holding>
 132:	c11d                	beqz	a0,158 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 134:	57fd                	li	a5,-1
 136:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 13a:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 13e:	0ff0000f          	fence
 142:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 146:	00000097          	auipc	ra,0x0
 14a:	052080e7          	jalr	82(ra) # 198 <tyield>
}
 14e:	60e2                	ld	ra,24(sp)
 150:	6442                	ld	s0,16(sp)
 152:	64a2                	ld	s1,8(sp)
 154:	6105                	addi	sp,sp,32
 156:	8082                	ret
        printf("releasing lock we are not holding");
 158:	00001517          	auipc	a0,0x1
 15c:	8b050513          	addi	a0,a0,-1872 # a08 <malloc+0x11e>
 160:	00000097          	auipc	ra,0x0
 164:	6d2080e7          	jalr	1746(ra) # 832 <printf>
        exit(-1);
 168:	557d                	li	a0,-1
 16a:	00000097          	auipc	ra,0x0
 16e:	336080e7          	jalr	822(ra) # 4a0 <exit>

0000000000000172 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 172:	1141                	addi	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 190:	4501                	li	a0,0
 192:	6422                	ld	s0,8(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret

0000000000000198 <tyield>:

void tyield()
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <twhoami>:

uint8 twhoami()
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 1aa:	4501                	li	a0,0
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <tswtch>:
 1b2:	00153023          	sd	ra,0(a0)
 1b6:	00253423          	sd	sp,8(a0)
 1ba:	e900                	sd	s0,16(a0)
 1bc:	ed04                	sd	s1,24(a0)
 1be:	03253023          	sd	s2,32(a0)
 1c2:	03353423          	sd	s3,40(a0)
 1c6:	03453823          	sd	s4,48(a0)
 1ca:	03553c23          	sd	s5,56(a0)
 1ce:	05653023          	sd	s6,64(a0)
 1d2:	05753423          	sd	s7,72(a0)
 1d6:	05853823          	sd	s8,80(a0)
 1da:	05953c23          	sd	s9,88(a0)
 1de:	07a53023          	sd	s10,96(a0)
 1e2:	07b53423          	sd	s11,104(a0)
 1e6:	0005b083          	ld	ra,0(a1)
 1ea:	0085b103          	ld	sp,8(a1)
 1ee:	6980                	ld	s0,16(a1)
 1f0:	6d84                	ld	s1,24(a1)
 1f2:	0205b903          	ld	s2,32(a1)
 1f6:	0285b983          	ld	s3,40(a1)
 1fa:	0305ba03          	ld	s4,48(a1)
 1fe:	0385ba83          	ld	s5,56(a1)
 202:	0405bb03          	ld	s6,64(a1)
 206:	0485bb83          	ld	s7,72(a1)
 20a:	0505bc03          	ld	s8,80(a1)
 20e:	0585bc83          	ld	s9,88(a1)
 212:	0605bd03          	ld	s10,96(a1)
 216:	0685bd83          	ld	s11,104(a1)
 21a:	8082                	ret

000000000000021c <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e406                	sd	ra,8(sp)
 220:	e022                	sd	s0,0(sp)
 222:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 224:	00000097          	auipc	ra,0x0
 228:	dfe080e7          	jalr	-514(ra) # 22 <main>
    exit(res);
 22c:	00000097          	auipc	ra,0x0
 230:	274080e7          	jalr	628(ra) # 4a0 <exit>

0000000000000234 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 23a:	87aa                	mv	a5,a0
 23c:	0585                	addi	a1,a1,1
 23e:	0785                	addi	a5,a5,1
 240:	fff5c703          	lbu	a4,-1(a1)
 244:	fee78fa3          	sb	a4,-1(a5)
 248:	fb75                	bnez	a4,23c <strcpy+0x8>
        ;
    return os;
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret

0000000000000250 <strcmp>:

int strcmp(const char *p, const char *q)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 256:	00054783          	lbu	a5,0(a0)
 25a:	cb91                	beqz	a5,26e <strcmp+0x1e>
 25c:	0005c703          	lbu	a4,0(a1)
 260:	00f71763          	bne	a4,a5,26e <strcmp+0x1e>
        p++, q++;
 264:	0505                	addi	a0,a0,1
 266:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 268:	00054783          	lbu	a5,0(a0)
 26c:	fbe5                	bnez	a5,25c <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 26e:	0005c503          	lbu	a0,0(a1)
}
 272:	40a7853b          	subw	a0,a5,a0
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret

000000000000027c <strlen>:

uint strlen(const char *s)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 282:	00054783          	lbu	a5,0(a0)
 286:	cf91                	beqz	a5,2a2 <strlen+0x26>
 288:	0505                	addi	a0,a0,1
 28a:	87aa                	mv	a5,a0
 28c:	4685                	li	a3,1
 28e:	9e89                	subw	a3,a3,a0
 290:	00f6853b          	addw	a0,a3,a5
 294:	0785                	addi	a5,a5,1
 296:	fff7c703          	lbu	a4,-1(a5)
 29a:	fb7d                	bnez	a4,290 <strlen+0x14>
        ;
    return n;
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret
    for (n = 0; s[n]; n++)
 2a2:	4501                	li	a0,0
 2a4:	bfe5                	j	29c <strlen+0x20>

00000000000002a6 <memset>:

void *
memset(void *dst, int c, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 2ac:	ca19                	beqz	a2,2c2 <memset+0x1c>
 2ae:	87aa                	mv	a5,a0
 2b0:	1602                	slli	a2,a2,0x20
 2b2:	9201                	srli	a2,a2,0x20
 2b4:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 2b8:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 2bc:	0785                	addi	a5,a5,1
 2be:	fee79de3          	bne	a5,a4,2b8 <memset+0x12>
    }
    return dst;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <strchr>:

char *
strchr(const char *s, char c)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
    for (; *s; s++)
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	cb99                	beqz	a5,2e8 <strchr+0x20>
        if (*s == c)
 2d4:	00f58763          	beq	a1,a5,2e2 <strchr+0x1a>
    for (; *s; s++)
 2d8:	0505                	addi	a0,a0,1
 2da:	00054783          	lbu	a5,0(a0)
 2de:	fbfd                	bnez	a5,2d4 <strchr+0xc>
            return (char *)s;
    return 0;
 2e0:	4501                	li	a0,0
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
    return 0;
 2e8:	4501                	li	a0,0
 2ea:	bfe5                	j	2e2 <strchr+0x1a>

00000000000002ec <gets>:

char *
gets(char *buf, int max)
{
 2ec:	711d                	addi	sp,sp,-96
 2ee:	ec86                	sd	ra,88(sp)
 2f0:	e8a2                	sd	s0,80(sp)
 2f2:	e4a6                	sd	s1,72(sp)
 2f4:	e0ca                	sd	s2,64(sp)
 2f6:	fc4e                	sd	s3,56(sp)
 2f8:	f852                	sd	s4,48(sp)
 2fa:	f456                	sd	s5,40(sp)
 2fc:	f05a                	sd	s6,32(sp)
 2fe:	ec5e                	sd	s7,24(sp)
 300:	1080                	addi	s0,sp,96
 302:	8baa                	mv	s7,a0
 304:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 306:	892a                	mv	s2,a0
 308:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 30a:	4aa9                	li	s5,10
 30c:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 30e:	89a6                	mv	s3,s1
 310:	2485                	addiw	s1,s1,1
 312:	0344d863          	bge	s1,s4,342 <gets+0x56>
        cc = read(0, &c, 1);
 316:	4605                	li	a2,1
 318:	faf40593          	addi	a1,s0,-81
 31c:	4501                	li	a0,0
 31e:	00000097          	auipc	ra,0x0
 322:	19a080e7          	jalr	410(ra) # 4b8 <read>
        if (cc < 1)
 326:	00a05e63          	blez	a0,342 <gets+0x56>
        buf[i++] = c;
 32a:	faf44783          	lbu	a5,-81(s0)
 32e:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 332:	01578763          	beq	a5,s5,340 <gets+0x54>
 336:	0905                	addi	s2,s2,1
 338:	fd679be3          	bne	a5,s6,30e <gets+0x22>
    for (i = 0; i + 1 < max;)
 33c:	89a6                	mv	s3,s1
 33e:	a011                	j	342 <gets+0x56>
 340:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 342:	99de                	add	s3,s3,s7
 344:	00098023          	sb	zero,0(s3)
    return buf;
}
 348:	855e                	mv	a0,s7
 34a:	60e6                	ld	ra,88(sp)
 34c:	6446                	ld	s0,80(sp)
 34e:	64a6                	ld	s1,72(sp)
 350:	6906                	ld	s2,64(sp)
 352:	79e2                	ld	s3,56(sp)
 354:	7a42                	ld	s4,48(sp)
 356:	7aa2                	ld	s5,40(sp)
 358:	7b02                	ld	s6,32(sp)
 35a:	6be2                	ld	s7,24(sp)
 35c:	6125                	addi	sp,sp,96
 35e:	8082                	ret

0000000000000360 <stat>:

int stat(const char *n, struct stat *st)
{
 360:	1101                	addi	sp,sp,-32
 362:	ec06                	sd	ra,24(sp)
 364:	e822                	sd	s0,16(sp)
 366:	e426                	sd	s1,8(sp)
 368:	e04a                	sd	s2,0(sp)
 36a:	1000                	addi	s0,sp,32
 36c:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 36e:	4581                	li	a1,0
 370:	00000097          	auipc	ra,0x0
 374:	170080e7          	jalr	368(ra) # 4e0 <open>
    if (fd < 0)
 378:	02054563          	bltz	a0,3a2 <stat+0x42>
 37c:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 37e:	85ca                	mv	a1,s2
 380:	00000097          	auipc	ra,0x0
 384:	178080e7          	jalr	376(ra) # 4f8 <fstat>
 388:	892a                	mv	s2,a0
    close(fd);
 38a:	8526                	mv	a0,s1
 38c:	00000097          	auipc	ra,0x0
 390:	13c080e7          	jalr	316(ra) # 4c8 <close>
    return r;
}
 394:	854a                	mv	a0,s2
 396:	60e2                	ld	ra,24(sp)
 398:	6442                	ld	s0,16(sp)
 39a:	64a2                	ld	s1,8(sp)
 39c:	6902                	ld	s2,0(sp)
 39e:	6105                	addi	sp,sp,32
 3a0:	8082                	ret
        return -1;
 3a2:	597d                	li	s2,-1
 3a4:	bfc5                	j	394 <stat+0x34>

00000000000003a6 <atoi>:

int atoi(const char *s)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e422                	sd	s0,8(sp)
 3aa:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 3ac:	00054683          	lbu	a3,0(a0)
 3b0:	fd06879b          	addiw	a5,a3,-48
 3b4:	0ff7f793          	zext.b	a5,a5
 3b8:	4625                	li	a2,9
 3ba:	02f66863          	bltu	a2,a5,3ea <atoi+0x44>
 3be:	872a                	mv	a4,a0
    n = 0;
 3c0:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 3c2:	0705                	addi	a4,a4,1
 3c4:	0025179b          	slliw	a5,a0,0x2
 3c8:	9fa9                	addw	a5,a5,a0
 3ca:	0017979b          	slliw	a5,a5,0x1
 3ce:	9fb5                	addw	a5,a5,a3
 3d0:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 3d4:	00074683          	lbu	a3,0(a4)
 3d8:	fd06879b          	addiw	a5,a3,-48
 3dc:	0ff7f793          	zext.b	a5,a5
 3e0:	fef671e3          	bgeu	a2,a5,3c2 <atoi+0x1c>
    return n;
}
 3e4:	6422                	ld	s0,8(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret
    n = 0;
 3ea:	4501                	li	a0,0
 3ec:	bfe5                	j	3e4 <atoi+0x3e>

00000000000003ee <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 3ee:	1141                	addi	sp,sp,-16
 3f0:	e422                	sd	s0,8(sp)
 3f2:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 3f4:	02b57463          	bgeu	a0,a1,41c <memmove+0x2e>
    {
        while (n-- > 0)
 3f8:	00c05f63          	blez	a2,416 <memmove+0x28>
 3fc:	1602                	slli	a2,a2,0x20
 3fe:	9201                	srli	a2,a2,0x20
 400:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 404:	872a                	mv	a4,a0
            *dst++ = *src++;
 406:	0585                	addi	a1,a1,1
 408:	0705                	addi	a4,a4,1
 40a:	fff5c683          	lbu	a3,-1(a1)
 40e:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 412:	fee79ae3          	bne	a5,a4,406 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 416:	6422                	ld	s0,8(sp)
 418:	0141                	addi	sp,sp,16
 41a:	8082                	ret
        dst += n;
 41c:	00c50733          	add	a4,a0,a2
        src += n;
 420:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 422:	fec05ae3          	blez	a2,416 <memmove+0x28>
 426:	fff6079b          	addiw	a5,a2,-1
 42a:	1782                	slli	a5,a5,0x20
 42c:	9381                	srli	a5,a5,0x20
 42e:	fff7c793          	not	a5,a5
 432:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 434:	15fd                	addi	a1,a1,-1
 436:	177d                	addi	a4,a4,-1
 438:	0005c683          	lbu	a3,0(a1)
 43c:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 440:	fee79ae3          	bne	a5,a4,434 <memmove+0x46>
 444:	bfc9                	j	416 <memmove+0x28>

0000000000000446 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 446:	1141                	addi	sp,sp,-16
 448:	e422                	sd	s0,8(sp)
 44a:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 44c:	ca05                	beqz	a2,47c <memcmp+0x36>
 44e:	fff6069b          	addiw	a3,a2,-1
 452:	1682                	slli	a3,a3,0x20
 454:	9281                	srli	a3,a3,0x20
 456:	0685                	addi	a3,a3,1
 458:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 45a:	00054783          	lbu	a5,0(a0)
 45e:	0005c703          	lbu	a4,0(a1)
 462:	00e79863          	bne	a5,a4,472 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 466:	0505                	addi	a0,a0,1
        p2++;
 468:	0585                	addi	a1,a1,1
    while (n-- > 0)
 46a:	fed518e3          	bne	a0,a3,45a <memcmp+0x14>
    }
    return 0;
 46e:	4501                	li	a0,0
 470:	a019                	j	476 <memcmp+0x30>
            return *p1 - *p2;
 472:	40e7853b          	subw	a0,a5,a4
}
 476:	6422                	ld	s0,8(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret
    return 0;
 47c:	4501                	li	a0,0
 47e:	bfe5                	j	476 <memcmp+0x30>

0000000000000480 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 480:	1141                	addi	sp,sp,-16
 482:	e406                	sd	ra,8(sp)
 484:	e022                	sd	s0,0(sp)
 486:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 488:	00000097          	auipc	ra,0x0
 48c:	f66080e7          	jalr	-154(ra) # 3ee <memmove>
}
 490:	60a2                	ld	ra,8(sp)
 492:	6402                	ld	s0,0(sp)
 494:	0141                	addi	sp,sp,16
 496:	8082                	ret

0000000000000498 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 498:	4885                	li	a7,1
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a0:	4889                	li	a7,2
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4a8:	488d                	li	a7,3
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4b0:	4891                	li	a7,4
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <read>:
.global read
read:
 li a7, SYS_read
 4b8:	4895                	li	a7,5
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <write>:
.global write
write:
 li a7, SYS_write
 4c0:	48c1                	li	a7,16
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <close>:
.global close
close:
 li a7, SYS_close
 4c8:	48d5                	li	a7,21
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d0:	4899                	li	a7,6
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4d8:	489d                	li	a7,7
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <open>:
.global open
open:
 li a7, SYS_open
 4e0:	48bd                	li	a7,15
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4e8:	48c5                	li	a7,17
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4f0:	48c9                	li	a7,18
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4f8:	48a1                	li	a7,8
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <link>:
.global link
link:
 li a7, SYS_link
 500:	48cd                	li	a7,19
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 508:	48d1                	li	a7,20
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 510:	48a5                	li	a7,9
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <dup>:
.global dup
dup:
 li a7, SYS_dup
 518:	48a9                	li	a7,10
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 520:	48ad                	li	a7,11
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 528:	48b1                	li	a7,12
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 530:	48b5                	li	a7,13
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 538:	48b9                	li	a7,14
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <ps>:
.global ps
ps:
 li a7, SYS_ps
 540:	48d9                	li	a7,22
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 548:	48dd                	li	a7,23
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 550:	48e1                	li	a7,24
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 558:	1101                	addi	sp,sp,-32
 55a:	ec06                	sd	ra,24(sp)
 55c:	e822                	sd	s0,16(sp)
 55e:	1000                	addi	s0,sp,32
 560:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 564:	4605                	li	a2,1
 566:	fef40593          	addi	a1,s0,-17
 56a:	00000097          	auipc	ra,0x0
 56e:	f56080e7          	jalr	-170(ra) # 4c0 <write>
}
 572:	60e2                	ld	ra,24(sp)
 574:	6442                	ld	s0,16(sp)
 576:	6105                	addi	sp,sp,32
 578:	8082                	ret

000000000000057a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57a:	7139                	addi	sp,sp,-64
 57c:	fc06                	sd	ra,56(sp)
 57e:	f822                	sd	s0,48(sp)
 580:	f426                	sd	s1,40(sp)
 582:	f04a                	sd	s2,32(sp)
 584:	ec4e                	sd	s3,24(sp)
 586:	0080                	addi	s0,sp,64
 588:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58a:	c299                	beqz	a3,590 <printint+0x16>
 58c:	0805c963          	bltz	a1,61e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 590:	2581                	sext.w	a1,a1
  neg = 0;
 592:	4881                	li	a7,0
 594:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 598:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 59a:	2601                	sext.w	a2,a2
 59c:	00000517          	auipc	a0,0x0
 5a0:	4f450513          	addi	a0,a0,1268 # a90 <digits>
 5a4:	883a                	mv	a6,a4
 5a6:	2705                	addiw	a4,a4,1
 5a8:	02c5f7bb          	remuw	a5,a1,a2
 5ac:	1782                	slli	a5,a5,0x20
 5ae:	9381                	srli	a5,a5,0x20
 5b0:	97aa                	add	a5,a5,a0
 5b2:	0007c783          	lbu	a5,0(a5)
 5b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ba:	0005879b          	sext.w	a5,a1
 5be:	02c5d5bb          	divuw	a1,a1,a2
 5c2:	0685                	addi	a3,a3,1
 5c4:	fec7f0e3          	bgeu	a5,a2,5a4 <printint+0x2a>
  if(neg)
 5c8:	00088c63          	beqz	a7,5e0 <printint+0x66>
    buf[i++] = '-';
 5cc:	fd070793          	addi	a5,a4,-48
 5d0:	00878733          	add	a4,a5,s0
 5d4:	02d00793          	li	a5,45
 5d8:	fef70823          	sb	a5,-16(a4)
 5dc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e0:	02e05863          	blez	a4,610 <printint+0x96>
 5e4:	fc040793          	addi	a5,s0,-64
 5e8:	00e78933          	add	s2,a5,a4
 5ec:	fff78993          	addi	s3,a5,-1
 5f0:	99ba                	add	s3,s3,a4
 5f2:	377d                	addiw	a4,a4,-1
 5f4:	1702                	slli	a4,a4,0x20
 5f6:	9301                	srli	a4,a4,0x20
 5f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5fc:	fff94583          	lbu	a1,-1(s2)
 600:	8526                	mv	a0,s1
 602:	00000097          	auipc	ra,0x0
 606:	f56080e7          	jalr	-170(ra) # 558 <putc>
  while(--i >= 0)
 60a:	197d                	addi	s2,s2,-1
 60c:	ff3918e3          	bne	s2,s3,5fc <printint+0x82>
}
 610:	70e2                	ld	ra,56(sp)
 612:	7442                	ld	s0,48(sp)
 614:	74a2                	ld	s1,40(sp)
 616:	7902                	ld	s2,32(sp)
 618:	69e2                	ld	s3,24(sp)
 61a:	6121                	addi	sp,sp,64
 61c:	8082                	ret
    x = -xx;
 61e:	40b005bb          	negw	a1,a1
    neg = 1;
 622:	4885                	li	a7,1
    x = -xx;
 624:	bf85                	j	594 <printint+0x1a>

0000000000000626 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 626:	7119                	addi	sp,sp,-128
 628:	fc86                	sd	ra,120(sp)
 62a:	f8a2                	sd	s0,112(sp)
 62c:	f4a6                	sd	s1,104(sp)
 62e:	f0ca                	sd	s2,96(sp)
 630:	ecce                	sd	s3,88(sp)
 632:	e8d2                	sd	s4,80(sp)
 634:	e4d6                	sd	s5,72(sp)
 636:	e0da                	sd	s6,64(sp)
 638:	fc5e                	sd	s7,56(sp)
 63a:	f862                	sd	s8,48(sp)
 63c:	f466                	sd	s9,40(sp)
 63e:	f06a                	sd	s10,32(sp)
 640:	ec6e                	sd	s11,24(sp)
 642:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 644:	0005c903          	lbu	s2,0(a1)
 648:	18090f63          	beqz	s2,7e6 <vprintf+0x1c0>
 64c:	8aaa                	mv	s5,a0
 64e:	8b32                	mv	s6,a2
 650:	00158493          	addi	s1,a1,1
  state = 0;
 654:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 656:	02500a13          	li	s4,37
 65a:	4c55                	li	s8,21
 65c:	00000c97          	auipc	s9,0x0
 660:	3dcc8c93          	addi	s9,s9,988 # a38 <malloc+0x14e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 664:	02800d93          	li	s11,40
  putc(fd, 'x');
 668:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66a:	00000b97          	auipc	s7,0x0
 66e:	426b8b93          	addi	s7,s7,1062 # a90 <digits>
 672:	a839                	j	690 <vprintf+0x6a>
        putc(fd, c);
 674:	85ca                	mv	a1,s2
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	ee0080e7          	jalr	-288(ra) # 558 <putc>
 680:	a019                	j	686 <vprintf+0x60>
    } else if(state == '%'){
 682:	01498d63          	beq	s3,s4,69c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 686:	0485                	addi	s1,s1,1
 688:	fff4c903          	lbu	s2,-1(s1)
 68c:	14090d63          	beqz	s2,7e6 <vprintf+0x1c0>
    if(state == 0){
 690:	fe0999e3          	bnez	s3,682 <vprintf+0x5c>
      if(c == '%'){
 694:	ff4910e3          	bne	s2,s4,674 <vprintf+0x4e>
        state = '%';
 698:	89d2                	mv	s3,s4
 69a:	b7f5                	j	686 <vprintf+0x60>
      if(c == 'd'){
 69c:	11490c63          	beq	s2,s4,7b4 <vprintf+0x18e>
 6a0:	f9d9079b          	addiw	a5,s2,-99
 6a4:	0ff7f793          	zext.b	a5,a5
 6a8:	10fc6e63          	bltu	s8,a5,7c4 <vprintf+0x19e>
 6ac:	f9d9079b          	addiw	a5,s2,-99
 6b0:	0ff7f713          	zext.b	a4,a5
 6b4:	10ec6863          	bltu	s8,a4,7c4 <vprintf+0x19e>
 6b8:	00271793          	slli	a5,a4,0x2
 6bc:	97e6                	add	a5,a5,s9
 6be:	439c                	lw	a5,0(a5)
 6c0:	97e6                	add	a5,a5,s9
 6c2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6c4:	008b0913          	addi	s2,s6,8
 6c8:	4685                	li	a3,1
 6ca:	4629                	li	a2,10
 6cc:	000b2583          	lw	a1,0(s6)
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	ea8080e7          	jalr	-344(ra) # 57a <printint>
 6da:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b765                	j	686 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e0:	008b0913          	addi	s2,s6,8
 6e4:	4681                	li	a3,0
 6e6:	4629                	li	a2,10
 6e8:	000b2583          	lw	a1,0(s6)
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	e8c080e7          	jalr	-372(ra) # 57a <printint>
 6f6:	8b4a                	mv	s6,s2
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b771                	j	686 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6fc:	008b0913          	addi	s2,s6,8
 700:	4681                	li	a3,0
 702:	866a                	mv	a2,s10
 704:	000b2583          	lw	a1,0(s6)
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	e70080e7          	jalr	-400(ra) # 57a <printint>
 712:	8b4a                	mv	s6,s2
      state = 0;
 714:	4981                	li	s3,0
 716:	bf85                	j	686 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 718:	008b0793          	addi	a5,s6,8
 71c:	f8f43423          	sd	a5,-120(s0)
 720:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 724:	03000593          	li	a1,48
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	e2e080e7          	jalr	-466(ra) # 558 <putc>
  putc(fd, 'x');
 732:	07800593          	li	a1,120
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	e20080e7          	jalr	-480(ra) # 558 <putc>
 740:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 742:	03c9d793          	srli	a5,s3,0x3c
 746:	97de                	add	a5,a5,s7
 748:	0007c583          	lbu	a1,0(a5)
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	e0a080e7          	jalr	-502(ra) # 558 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 756:	0992                	slli	s3,s3,0x4
 758:	397d                	addiw	s2,s2,-1
 75a:	fe0914e3          	bnez	s2,742 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 75e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 762:	4981                	li	s3,0
 764:	b70d                	j	686 <vprintf+0x60>
        s = va_arg(ap, char*);
 766:	008b0913          	addi	s2,s6,8
 76a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 76e:	02098163          	beqz	s3,790 <vprintf+0x16a>
        while(*s != 0){
 772:	0009c583          	lbu	a1,0(s3)
 776:	c5ad                	beqz	a1,7e0 <vprintf+0x1ba>
          putc(fd, *s);
 778:	8556                	mv	a0,s5
 77a:	00000097          	auipc	ra,0x0
 77e:	dde080e7          	jalr	-546(ra) # 558 <putc>
          s++;
 782:	0985                	addi	s3,s3,1
        while(*s != 0){
 784:	0009c583          	lbu	a1,0(s3)
 788:	f9e5                	bnez	a1,778 <vprintf+0x152>
        s = va_arg(ap, char*);
 78a:	8b4a                	mv	s6,s2
      state = 0;
 78c:	4981                	li	s3,0
 78e:	bde5                	j	686 <vprintf+0x60>
          s = "(null)";
 790:	00000997          	auipc	s3,0x0
 794:	2a098993          	addi	s3,s3,672 # a30 <malloc+0x146>
        while(*s != 0){
 798:	85ee                	mv	a1,s11
 79a:	bff9                	j	778 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 79c:	008b0913          	addi	s2,s6,8
 7a0:	000b4583          	lbu	a1,0(s6)
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	db2080e7          	jalr	-590(ra) # 558 <putc>
 7ae:	8b4a                	mv	s6,s2
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	bdd1                	j	686 <vprintf+0x60>
        putc(fd, c);
 7b4:	85d2                	mv	a1,s4
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	da0080e7          	jalr	-608(ra) # 558 <putc>
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b5d1                	j	686 <vprintf+0x60>
        putc(fd, '%');
 7c4:	85d2                	mv	a1,s4
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	d90080e7          	jalr	-624(ra) # 558 <putc>
        putc(fd, c);
 7d0:	85ca                	mv	a1,s2
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	d84080e7          	jalr	-636(ra) # 558 <putc>
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b565                	j	686 <vprintf+0x60>
        s = va_arg(ap, char*);
 7e0:	8b4a                	mv	s6,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	b54d                	j	686 <vprintf+0x60>
    }
  }
}
 7e6:	70e6                	ld	ra,120(sp)
 7e8:	7446                	ld	s0,112(sp)
 7ea:	74a6                	ld	s1,104(sp)
 7ec:	7906                	ld	s2,96(sp)
 7ee:	69e6                	ld	s3,88(sp)
 7f0:	6a46                	ld	s4,80(sp)
 7f2:	6aa6                	ld	s5,72(sp)
 7f4:	6b06                	ld	s6,64(sp)
 7f6:	7be2                	ld	s7,56(sp)
 7f8:	7c42                	ld	s8,48(sp)
 7fa:	7ca2                	ld	s9,40(sp)
 7fc:	7d02                	ld	s10,32(sp)
 7fe:	6de2                	ld	s11,24(sp)
 800:	6109                	addi	sp,sp,128
 802:	8082                	ret

0000000000000804 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 804:	715d                	addi	sp,sp,-80
 806:	ec06                	sd	ra,24(sp)
 808:	e822                	sd	s0,16(sp)
 80a:	1000                	addi	s0,sp,32
 80c:	e010                	sd	a2,0(s0)
 80e:	e414                	sd	a3,8(s0)
 810:	e818                	sd	a4,16(s0)
 812:	ec1c                	sd	a5,24(s0)
 814:	03043023          	sd	a6,32(s0)
 818:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 820:	8622                	mv	a2,s0
 822:	00000097          	auipc	ra,0x0
 826:	e04080e7          	jalr	-508(ra) # 626 <vprintf>
}
 82a:	60e2                	ld	ra,24(sp)
 82c:	6442                	ld	s0,16(sp)
 82e:	6161                	addi	sp,sp,80
 830:	8082                	ret

0000000000000832 <printf>:

void
printf(const char *fmt, ...)
{
 832:	711d                	addi	sp,sp,-96
 834:	ec06                	sd	ra,24(sp)
 836:	e822                	sd	s0,16(sp)
 838:	1000                	addi	s0,sp,32
 83a:	e40c                	sd	a1,8(s0)
 83c:	e810                	sd	a2,16(s0)
 83e:	ec14                	sd	a3,24(s0)
 840:	f018                	sd	a4,32(s0)
 842:	f41c                	sd	a5,40(s0)
 844:	03043823          	sd	a6,48(s0)
 848:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84c:	00840613          	addi	a2,s0,8
 850:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 854:	85aa                	mv	a1,a0
 856:	4505                	li	a0,1
 858:	00000097          	auipc	ra,0x0
 85c:	dce080e7          	jalr	-562(ra) # 626 <vprintf>
}
 860:	60e2                	ld	ra,24(sp)
 862:	6442                	ld	s0,16(sp)
 864:	6125                	addi	sp,sp,96
 866:	8082                	ret

0000000000000868 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 868:	1141                	addi	sp,sp,-16
 86a:	e422                	sd	s0,8(sp)
 86c:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 86e:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 872:	00000797          	auipc	a5,0x0
 876:	78e7b783          	ld	a5,1934(a5) # 1000 <freep>
 87a:	a02d                	j	8a4 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 87c:	4618                	lw	a4,8(a2)
 87e:	9f2d                	addw	a4,a4,a1
 880:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 884:	6398                	ld	a4,0(a5)
 886:	6310                	ld	a2,0(a4)
 888:	a83d                	j	8c6 <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 88a:	ff852703          	lw	a4,-8(a0)
 88e:	9f31                	addw	a4,a4,a2
 890:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 892:	ff053683          	ld	a3,-16(a0)
 896:	a091                	j	8da <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 898:	6398                	ld	a4,0(a5)
 89a:	00e7e463          	bltu	a5,a4,8a2 <free+0x3a>
 89e:	00e6ea63          	bltu	a3,a4,8b2 <free+0x4a>
{
 8a2:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a4:	fed7fae3          	bgeu	a5,a3,898 <free+0x30>
 8a8:	6398                	ld	a4,0(a5)
 8aa:	00e6e463          	bltu	a3,a4,8b2 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ae:	fee7eae3          	bltu	a5,a4,8a2 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 8b2:	ff852583          	lw	a1,-8(a0)
 8b6:	6390                	ld	a2,0(a5)
 8b8:	02059813          	slli	a6,a1,0x20
 8bc:	01c85713          	srli	a4,a6,0x1c
 8c0:	9736                	add	a4,a4,a3
 8c2:	fae60de3          	beq	a2,a4,87c <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 8c6:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 8ca:	4790                	lw	a2,8(a5)
 8cc:	02061593          	slli	a1,a2,0x20
 8d0:	01c5d713          	srli	a4,a1,0x1c
 8d4:	973e                	add	a4,a4,a5
 8d6:	fae68ae3          	beq	a3,a4,88a <free+0x22>
        p->s.ptr = bp->s.ptr;
 8da:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 8dc:	00000717          	auipc	a4,0x0
 8e0:	72f73223          	sd	a5,1828(a4) # 1000 <freep>
}
 8e4:	6422                	ld	s0,8(sp)
 8e6:	0141                	addi	sp,sp,16
 8e8:	8082                	ret

00000000000008ea <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 8ea:	7139                	addi	sp,sp,-64
 8ec:	fc06                	sd	ra,56(sp)
 8ee:	f822                	sd	s0,48(sp)
 8f0:	f426                	sd	s1,40(sp)
 8f2:	f04a                	sd	s2,32(sp)
 8f4:	ec4e                	sd	s3,24(sp)
 8f6:	e852                	sd	s4,16(sp)
 8f8:	e456                	sd	s5,8(sp)
 8fa:	e05a                	sd	s6,0(sp)
 8fc:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8fe:	02051493          	slli	s1,a0,0x20
 902:	9081                	srli	s1,s1,0x20
 904:	04bd                	addi	s1,s1,15
 906:	8091                	srli	s1,s1,0x4
 908:	0014899b          	addiw	s3,s1,1
 90c:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 90e:	00000517          	auipc	a0,0x0
 912:	6f253503          	ld	a0,1778(a0) # 1000 <freep>
 916:	c515                	beqz	a0,942 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 918:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 91a:	4798                	lw	a4,8(a5)
 91c:	02977f63          	bgeu	a4,s1,95a <malloc+0x70>
 920:	8a4e                	mv	s4,s3
 922:	0009871b          	sext.w	a4,s3
 926:	6685                	lui	a3,0x1
 928:	00d77363          	bgeu	a4,a3,92e <malloc+0x44>
 92c:	6a05                	lui	s4,0x1
 92e:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 932:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 936:	00000917          	auipc	s2,0x0
 93a:	6ca90913          	addi	s2,s2,1738 # 1000 <freep>
    if (p == (char *)-1)
 93e:	5afd                	li	s5,-1
 940:	a895                	j	9b4 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 942:	00000797          	auipc	a5,0x0
 946:	6ce78793          	addi	a5,a5,1742 # 1010 <base>
 94a:	00000717          	auipc	a4,0x0
 94e:	6af73b23          	sd	a5,1718(a4) # 1000 <freep>
 952:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 954:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 958:	b7e1                	j	920 <malloc+0x36>
            if (p->s.size == nunits)
 95a:	02e48c63          	beq	s1,a4,992 <malloc+0xa8>
                p->s.size -= nunits;
 95e:	4137073b          	subw	a4,a4,s3
 962:	c798                	sw	a4,8(a5)
                p += p->s.size;
 964:	02071693          	slli	a3,a4,0x20
 968:	01c6d713          	srli	a4,a3,0x1c
 96c:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 96e:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 972:	00000717          	auipc	a4,0x0
 976:	68a73723          	sd	a0,1678(a4) # 1000 <freep>
            return (void *)(p + 1);
 97a:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 97e:	70e2                	ld	ra,56(sp)
 980:	7442                	ld	s0,48(sp)
 982:	74a2                	ld	s1,40(sp)
 984:	7902                	ld	s2,32(sp)
 986:	69e2                	ld	s3,24(sp)
 988:	6a42                	ld	s4,16(sp)
 98a:	6aa2                	ld	s5,8(sp)
 98c:	6b02                	ld	s6,0(sp)
 98e:	6121                	addi	sp,sp,64
 990:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 992:	6398                	ld	a4,0(a5)
 994:	e118                	sd	a4,0(a0)
 996:	bff1                	j	972 <malloc+0x88>
    hp->s.size = nu;
 998:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 99c:	0541                	addi	a0,a0,16
 99e:	00000097          	auipc	ra,0x0
 9a2:	eca080e7          	jalr	-310(ra) # 868 <free>
    return freep;
 9a6:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 9aa:	d971                	beqz	a0,97e <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 9ac:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 9ae:	4798                	lw	a4,8(a5)
 9b0:	fa9775e3          	bgeu	a4,s1,95a <malloc+0x70>
        if (p == freep)
 9b4:	00093703          	ld	a4,0(s2)
 9b8:	853e                	mv	a0,a5
 9ba:	fef719e3          	bne	a4,a5,9ac <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 9be:	8552                	mv	a0,s4
 9c0:	00000097          	auipc	ra,0x0
 9c4:	b68080e7          	jalr	-1176(ra) # 528 <sbrk>
    if (p == (char *)-1)
 9c8:	fd5518e3          	bne	a0,s5,998 <malloc+0xae>
                return 0;
 9cc:	4501                	li	a0,0
 9ce:	bf45                	j	97e <malloc+0x94>
