
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	02f50063          	beq	a0,a5,2c <main+0x2c>
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	9d058593          	addi	a1,a1,-1584 # 9e0 <malloc+0xe8>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	7f8080e7          	jalr	2040(ra) # 812 <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	48a080e7          	jalr	1162(ra) # 4ae <exit>
  2c:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  2e:	698c                	ld	a1,16(a1)
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	4dc080e7          	jalr	1244(ra) # 50e <link>
  3a:	00054763          	bltz	a0,48 <main+0x48>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	46e080e7          	jalr	1134(ra) # 4ae <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	6894                	ld	a3,16(s1)
  4a:	6490                	ld	a2,8(s1)
  4c:	00001597          	auipc	a1,0x1
  50:	9ac58593          	addi	a1,a1,-1620 # 9f8 <malloc+0x100>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	7bc080e7          	jalr	1980(ra) # 812 <fprintf>
  5e:	b7c5                	j	3e <main+0x3e>

0000000000000060 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
    lk->name = name;
  66:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  68:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  6c:	57fd                	li	a5,-1
  6e:	00f50823          	sb	a5,16(a0)
}
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  78:	00054783          	lbu	a5,0(a0)
  7c:	e399                	bnez	a5,82 <holding+0xa>
  7e:	4501                	li	a0,0
}
  80:	8082                	ret
{
  82:	1101                	addi	sp,sp,-32
  84:	ec06                	sd	ra,24(sp)
  86:	e822                	sd	s0,16(sp)
  88:	e426                	sd	s1,8(sp)
  8a:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  8c:	01054483          	lbu	s1,16(a0)
  90:	00000097          	auipc	ra,0x0
  94:	122080e7          	jalr	290(ra) # 1b2 <twhoami>
  98:	2501                	sext.w	a0,a0
  9a:	40a48533          	sub	a0,s1,a0
  9e:	00153513          	seqz	a0,a0
}
  a2:	60e2                	ld	ra,24(sp)
  a4:	6442                	ld	s0,16(sp)
  a6:	64a2                	ld	s1,8(sp)
  a8:	6105                	addi	sp,sp,32
  aa:	8082                	ret

00000000000000ac <acquire>:

void acquire(struct lock *lk)
{
  ac:	7179                	addi	sp,sp,-48
  ae:	f406                	sd	ra,40(sp)
  b0:	f022                	sd	s0,32(sp)
  b2:	ec26                	sd	s1,24(sp)
  b4:	e84a                	sd	s2,16(sp)
  b6:	e44e                	sd	s3,8(sp)
  b8:	e052                	sd	s4,0(sp)
  ba:	1800                	addi	s0,sp,48
  bc:	8a2a                	mv	s4,a0
    if (holding(lk))
  be:	00000097          	auipc	ra,0x0
  c2:	fba080e7          	jalr	-70(ra) # 78 <holding>
  c6:	e919                	bnez	a0,dc <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  c8:	ffca7493          	andi	s1,s4,-4
  cc:	003a7913          	andi	s2,s4,3
  d0:	0039191b          	slliw	s2,s2,0x3
  d4:	4985                	li	s3,1
  d6:	012999bb          	sllw	s3,s3,s2
  da:	a015                	j	fe <acquire+0x52>
        printf("re-acquiring lock we already hold");
  dc:	00001517          	auipc	a0,0x1
  e0:	93450513          	addi	a0,a0,-1740 # a10 <malloc+0x118>
  e4:	00000097          	auipc	ra,0x0
  e8:	75c080e7          	jalr	1884(ra) # 840 <printf>
        exit(-1);
  ec:	557d                	li	a0,-1
  ee:	00000097          	auipc	ra,0x0
  f2:	3c0080e7          	jalr	960(ra) # 4ae <exit>
    {
        // give up the cpu for other threads
        tyield();
  f6:	00000097          	auipc	ra,0x0
  fa:	0b0080e7          	jalr	176(ra) # 1a6 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  fe:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 102:	0127d7bb          	srlw	a5,a5,s2
 106:	0ff7f793          	zext.b	a5,a5
 10a:	f7f5                	bnez	a5,f6 <acquire+0x4a>
    }

    __sync_synchronize();
 10c:	0ff0000f          	fence

    lk->tid = twhoami();
 110:	00000097          	auipc	ra,0x0
 114:	0a2080e7          	jalr	162(ra) # 1b2 <twhoami>
 118:	00aa0823          	sb	a0,16(s4)
}
 11c:	70a2                	ld	ra,40(sp)
 11e:	7402                	ld	s0,32(sp)
 120:	64e2                	ld	s1,24(sp)
 122:	6942                	ld	s2,16(sp)
 124:	69a2                	ld	s3,8(sp)
 126:	6a02                	ld	s4,0(sp)
 128:	6145                	addi	sp,sp,48
 12a:	8082                	ret

000000000000012c <release>:

void release(struct lock *lk)
{
 12c:	1101                	addi	sp,sp,-32
 12e:	ec06                	sd	ra,24(sp)
 130:	e822                	sd	s0,16(sp)
 132:	e426                	sd	s1,8(sp)
 134:	1000                	addi	s0,sp,32
 136:	84aa                	mv	s1,a0
    if (!holding(lk))
 138:	00000097          	auipc	ra,0x0
 13c:	f40080e7          	jalr	-192(ra) # 78 <holding>
 140:	c11d                	beqz	a0,166 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 142:	57fd                	li	a5,-1
 144:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 148:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 14c:	0ff0000f          	fence
 150:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 154:	00000097          	auipc	ra,0x0
 158:	052080e7          	jalr	82(ra) # 1a6 <tyield>
}
 15c:	60e2                	ld	ra,24(sp)
 15e:	6442                	ld	s0,16(sp)
 160:	64a2                	ld	s1,8(sp)
 162:	6105                	addi	sp,sp,32
 164:	8082                	ret
        printf("releasing lock we are not holding");
 166:	00001517          	auipc	a0,0x1
 16a:	8d250513          	addi	a0,a0,-1838 # a38 <malloc+0x140>
 16e:	00000097          	auipc	ra,0x0
 172:	6d2080e7          	jalr	1746(ra) # 840 <printf>
        exit(-1);
 176:	557d                	li	a0,-1
 178:	00000097          	auipc	ra,0x0
 17c:	336080e7          	jalr	822(ra) # 4ae <exit>

0000000000000180 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 192:	6422                	ld	s0,8(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret

0000000000000198 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 19e:	4501                	li	a0,0
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <tyield>:

void tyield()
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <twhoami>:

uint8 twhoami()
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 1b8:	4501                	li	a0,0
 1ba:	6422                	ld	s0,8(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret

00000000000001c0 <tswtch>:
 1c0:	00153023          	sd	ra,0(a0)
 1c4:	00253423          	sd	sp,8(a0)
 1c8:	e900                	sd	s0,16(a0)
 1ca:	ed04                	sd	s1,24(a0)
 1cc:	03253023          	sd	s2,32(a0)
 1d0:	03353423          	sd	s3,40(a0)
 1d4:	03453823          	sd	s4,48(a0)
 1d8:	03553c23          	sd	s5,56(a0)
 1dc:	05653023          	sd	s6,64(a0)
 1e0:	05753423          	sd	s7,72(a0)
 1e4:	05853823          	sd	s8,80(a0)
 1e8:	05953c23          	sd	s9,88(a0)
 1ec:	07a53023          	sd	s10,96(a0)
 1f0:	07b53423          	sd	s11,104(a0)
 1f4:	0005b083          	ld	ra,0(a1)
 1f8:	0085b103          	ld	sp,8(a1)
 1fc:	6980                	ld	s0,16(a1)
 1fe:	6d84                	ld	s1,24(a1)
 200:	0205b903          	ld	s2,32(a1)
 204:	0285b983          	ld	s3,40(a1)
 208:	0305ba03          	ld	s4,48(a1)
 20c:	0385ba83          	ld	s5,56(a1)
 210:	0405bb03          	ld	s6,64(a1)
 214:	0485bb83          	ld	s7,72(a1)
 218:	0505bc03          	ld	s8,80(a1)
 21c:	0585bc83          	ld	s9,88(a1)
 220:	0605bd03          	ld	s10,96(a1)
 224:	0685bd83          	ld	s11,104(a1)
 228:	8082                	ret

000000000000022a <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e406                	sd	ra,8(sp)
 22e:	e022                	sd	s0,0(sp)
 230:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 232:	00000097          	auipc	ra,0x0
 236:	dce080e7          	jalr	-562(ra) # 0 <main>
    exit(res);
 23a:	00000097          	auipc	ra,0x0
 23e:	274080e7          	jalr	628(ra) # 4ae <exit>

0000000000000242 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 248:	87aa                	mv	a5,a0
 24a:	0585                	addi	a1,a1,1
 24c:	0785                	addi	a5,a5,1
 24e:	fff5c703          	lbu	a4,-1(a1)
 252:	fee78fa3          	sb	a4,-1(a5)
 256:	fb75                	bnez	a4,24a <strcpy+0x8>
        ;
    return os;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <strcmp>:

int strcmp(const char *p, const char *q)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 264:	00054783          	lbu	a5,0(a0)
 268:	cb91                	beqz	a5,27c <strcmp+0x1e>
 26a:	0005c703          	lbu	a4,0(a1)
 26e:	00f71763          	bne	a4,a5,27c <strcmp+0x1e>
        p++, q++;
 272:	0505                	addi	a0,a0,1
 274:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 276:	00054783          	lbu	a5,0(a0)
 27a:	fbe5                	bnez	a5,26a <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 27c:	0005c503          	lbu	a0,0(a1)
}
 280:	40a7853b          	subw	a0,a5,a0
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strlen>:

uint strlen(const char *s)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e422                	sd	s0,8(sp)
 28e:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 290:	00054783          	lbu	a5,0(a0)
 294:	cf91                	beqz	a5,2b0 <strlen+0x26>
 296:	0505                	addi	a0,a0,1
 298:	87aa                	mv	a5,a0
 29a:	4685                	li	a3,1
 29c:	9e89                	subw	a3,a3,a0
 29e:	00f6853b          	addw	a0,a3,a5
 2a2:	0785                	addi	a5,a5,1
 2a4:	fff7c703          	lbu	a4,-1(a5)
 2a8:	fb7d                	bnez	a4,29e <strlen+0x14>
        ;
    return n;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
    for (n = 0; s[n]; n++)
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <strlen+0x20>

00000000000002b4 <memset>:

void *
memset(void *dst, int c, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 2ba:	ca19                	beqz	a2,2d0 <memset+0x1c>
 2bc:	87aa                	mv	a5,a0
 2be:	1602                	slli	a2,a2,0x20
 2c0:	9201                	srli	a2,a2,0x20
 2c2:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 2c6:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 2ca:	0785                	addi	a5,a5,1
 2cc:	fee79de3          	bne	a5,a4,2c6 <memset+0x12>
    }
    return dst;
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret

00000000000002d6 <strchr>:

char *
strchr(const char *s, char c)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	addi	s0,sp,16
    for (; *s; s++)
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	cb99                	beqz	a5,2f6 <strchr+0x20>
        if (*s == c)
 2e2:	00f58763          	beq	a1,a5,2f0 <strchr+0x1a>
    for (; *s; s++)
 2e6:	0505                	addi	a0,a0,1
 2e8:	00054783          	lbu	a5,0(a0)
 2ec:	fbfd                	bnez	a5,2e2 <strchr+0xc>
            return (char *)s;
    return 0;
 2ee:	4501                	li	a0,0
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
    return 0;
 2f6:	4501                	li	a0,0
 2f8:	bfe5                	j	2f0 <strchr+0x1a>

00000000000002fa <gets>:

char *
gets(char *buf, int max)
{
 2fa:	711d                	addi	sp,sp,-96
 2fc:	ec86                	sd	ra,88(sp)
 2fe:	e8a2                	sd	s0,80(sp)
 300:	e4a6                	sd	s1,72(sp)
 302:	e0ca                	sd	s2,64(sp)
 304:	fc4e                	sd	s3,56(sp)
 306:	f852                	sd	s4,48(sp)
 308:	f456                	sd	s5,40(sp)
 30a:	f05a                	sd	s6,32(sp)
 30c:	ec5e                	sd	s7,24(sp)
 30e:	1080                	addi	s0,sp,96
 310:	8baa                	mv	s7,a0
 312:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 314:	892a                	mv	s2,a0
 316:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 318:	4aa9                	li	s5,10
 31a:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 31c:	89a6                	mv	s3,s1
 31e:	2485                	addiw	s1,s1,1
 320:	0344d863          	bge	s1,s4,350 <gets+0x56>
        cc = read(0, &c, 1);
 324:	4605                	li	a2,1
 326:	faf40593          	addi	a1,s0,-81
 32a:	4501                	li	a0,0
 32c:	00000097          	auipc	ra,0x0
 330:	19a080e7          	jalr	410(ra) # 4c6 <read>
        if (cc < 1)
 334:	00a05e63          	blez	a0,350 <gets+0x56>
        buf[i++] = c;
 338:	faf44783          	lbu	a5,-81(s0)
 33c:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 340:	01578763          	beq	a5,s5,34e <gets+0x54>
 344:	0905                	addi	s2,s2,1
 346:	fd679be3          	bne	a5,s6,31c <gets+0x22>
    for (i = 0; i + 1 < max;)
 34a:	89a6                	mv	s3,s1
 34c:	a011                	j	350 <gets+0x56>
 34e:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 350:	99de                	add	s3,s3,s7
 352:	00098023          	sb	zero,0(s3)
    return buf;
}
 356:	855e                	mv	a0,s7
 358:	60e6                	ld	ra,88(sp)
 35a:	6446                	ld	s0,80(sp)
 35c:	64a6                	ld	s1,72(sp)
 35e:	6906                	ld	s2,64(sp)
 360:	79e2                	ld	s3,56(sp)
 362:	7a42                	ld	s4,48(sp)
 364:	7aa2                	ld	s5,40(sp)
 366:	7b02                	ld	s6,32(sp)
 368:	6be2                	ld	s7,24(sp)
 36a:	6125                	addi	sp,sp,96
 36c:	8082                	ret

000000000000036e <stat>:

int stat(const char *n, struct stat *st)
{
 36e:	1101                	addi	sp,sp,-32
 370:	ec06                	sd	ra,24(sp)
 372:	e822                	sd	s0,16(sp)
 374:	e426                	sd	s1,8(sp)
 376:	e04a                	sd	s2,0(sp)
 378:	1000                	addi	s0,sp,32
 37a:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 37c:	4581                	li	a1,0
 37e:	00000097          	auipc	ra,0x0
 382:	170080e7          	jalr	368(ra) # 4ee <open>
    if (fd < 0)
 386:	02054563          	bltz	a0,3b0 <stat+0x42>
 38a:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 38c:	85ca                	mv	a1,s2
 38e:	00000097          	auipc	ra,0x0
 392:	178080e7          	jalr	376(ra) # 506 <fstat>
 396:	892a                	mv	s2,a0
    close(fd);
 398:	8526                	mv	a0,s1
 39a:	00000097          	auipc	ra,0x0
 39e:	13c080e7          	jalr	316(ra) # 4d6 <close>
    return r;
}
 3a2:	854a                	mv	a0,s2
 3a4:	60e2                	ld	ra,24(sp)
 3a6:	6442                	ld	s0,16(sp)
 3a8:	64a2                	ld	s1,8(sp)
 3aa:	6902                	ld	s2,0(sp)
 3ac:	6105                	addi	sp,sp,32
 3ae:	8082                	ret
        return -1;
 3b0:	597d                	li	s2,-1
 3b2:	bfc5                	j	3a2 <stat+0x34>

00000000000003b4 <atoi>:

int atoi(const char *s)
{
 3b4:	1141                	addi	sp,sp,-16
 3b6:	e422                	sd	s0,8(sp)
 3b8:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 3ba:	00054683          	lbu	a3,0(a0)
 3be:	fd06879b          	addiw	a5,a3,-48
 3c2:	0ff7f793          	zext.b	a5,a5
 3c6:	4625                	li	a2,9
 3c8:	02f66863          	bltu	a2,a5,3f8 <atoi+0x44>
 3cc:	872a                	mv	a4,a0
    n = 0;
 3ce:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 3d0:	0705                	addi	a4,a4,1
 3d2:	0025179b          	slliw	a5,a0,0x2
 3d6:	9fa9                	addw	a5,a5,a0
 3d8:	0017979b          	slliw	a5,a5,0x1
 3dc:	9fb5                	addw	a5,a5,a3
 3de:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 3e2:	00074683          	lbu	a3,0(a4)
 3e6:	fd06879b          	addiw	a5,a3,-48
 3ea:	0ff7f793          	zext.b	a5,a5
 3ee:	fef671e3          	bgeu	a2,a5,3d0 <atoi+0x1c>
    return n;
}
 3f2:	6422                	ld	s0,8(sp)
 3f4:	0141                	addi	sp,sp,16
 3f6:	8082                	ret
    n = 0;
 3f8:	4501                	li	a0,0
 3fa:	bfe5                	j	3f2 <atoi+0x3e>

00000000000003fc <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 3fc:	1141                	addi	sp,sp,-16
 3fe:	e422                	sd	s0,8(sp)
 400:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 402:	02b57463          	bgeu	a0,a1,42a <memmove+0x2e>
    {
        while (n-- > 0)
 406:	00c05f63          	blez	a2,424 <memmove+0x28>
 40a:	1602                	slli	a2,a2,0x20
 40c:	9201                	srli	a2,a2,0x20
 40e:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 412:	872a                	mv	a4,a0
            *dst++ = *src++;
 414:	0585                	addi	a1,a1,1
 416:	0705                	addi	a4,a4,1
 418:	fff5c683          	lbu	a3,-1(a1)
 41c:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 420:	fee79ae3          	bne	a5,a4,414 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 424:	6422                	ld	s0,8(sp)
 426:	0141                	addi	sp,sp,16
 428:	8082                	ret
        dst += n;
 42a:	00c50733          	add	a4,a0,a2
        src += n;
 42e:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 430:	fec05ae3          	blez	a2,424 <memmove+0x28>
 434:	fff6079b          	addiw	a5,a2,-1
 438:	1782                	slli	a5,a5,0x20
 43a:	9381                	srli	a5,a5,0x20
 43c:	fff7c793          	not	a5,a5
 440:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 442:	15fd                	addi	a1,a1,-1
 444:	177d                	addi	a4,a4,-1
 446:	0005c683          	lbu	a3,0(a1)
 44a:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 44e:	fee79ae3          	bne	a5,a4,442 <memmove+0x46>
 452:	bfc9                	j	424 <memmove+0x28>

0000000000000454 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 454:	1141                	addi	sp,sp,-16
 456:	e422                	sd	s0,8(sp)
 458:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 45a:	ca05                	beqz	a2,48a <memcmp+0x36>
 45c:	fff6069b          	addiw	a3,a2,-1
 460:	1682                	slli	a3,a3,0x20
 462:	9281                	srli	a3,a3,0x20
 464:	0685                	addi	a3,a3,1
 466:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 468:	00054783          	lbu	a5,0(a0)
 46c:	0005c703          	lbu	a4,0(a1)
 470:	00e79863          	bne	a5,a4,480 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 474:	0505                	addi	a0,a0,1
        p2++;
 476:	0585                	addi	a1,a1,1
    while (n-- > 0)
 478:	fed518e3          	bne	a0,a3,468 <memcmp+0x14>
    }
    return 0;
 47c:	4501                	li	a0,0
 47e:	a019                	j	484 <memcmp+0x30>
            return *p1 - *p2;
 480:	40e7853b          	subw	a0,a5,a4
}
 484:	6422                	ld	s0,8(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret
    return 0;
 48a:	4501                	li	a0,0
 48c:	bfe5                	j	484 <memcmp+0x30>

000000000000048e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 48e:	1141                	addi	sp,sp,-16
 490:	e406                	sd	ra,8(sp)
 492:	e022                	sd	s0,0(sp)
 494:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 496:	00000097          	auipc	ra,0x0
 49a:	f66080e7          	jalr	-154(ra) # 3fc <memmove>
}
 49e:	60a2                	ld	ra,8(sp)
 4a0:	6402                	ld	s0,0(sp)
 4a2:	0141                	addi	sp,sp,16
 4a4:	8082                	ret

00000000000004a6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4a6:	4885                	li	a7,1
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ae:	4889                	li	a7,2
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4b6:	488d                	li	a7,3
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4be:	4891                	li	a7,4
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <read>:
.global read
read:
 li a7, SYS_read
 4c6:	4895                	li	a7,5
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <write>:
.global write
write:
 li a7, SYS_write
 4ce:	48c1                	li	a7,16
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <close>:
.global close
close:
 li a7, SYS_close
 4d6:	48d5                	li	a7,21
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <kill>:
.global kill
kill:
 li a7, SYS_kill
 4de:	4899                	li	a7,6
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4e6:	489d                	li	a7,7
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <open>:
.global open
open:
 li a7, SYS_open
 4ee:	48bd                	li	a7,15
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4f6:	48c5                	li	a7,17
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4fe:	48c9                	li	a7,18
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 506:	48a1                	li	a7,8
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <link>:
.global link
link:
 li a7, SYS_link
 50e:	48cd                	li	a7,19
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 516:	48d1                	li	a7,20
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 51e:	48a5                	li	a7,9
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <dup>:
.global dup
dup:
 li a7, SYS_dup
 526:	48a9                	li	a7,10
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 52e:	48ad                	li	a7,11
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 536:	48b1                	li	a7,12
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 53e:	48b5                	li	a7,13
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 546:	48b9                	li	a7,14
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <ps>:
.global ps
ps:
 li a7, SYS_ps
 54e:	48d9                	li	a7,22
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 556:	48dd                	li	a7,23
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 55e:	48e1                	li	a7,24
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 566:	1101                	addi	sp,sp,-32
 568:	ec06                	sd	ra,24(sp)
 56a:	e822                	sd	s0,16(sp)
 56c:	1000                	addi	s0,sp,32
 56e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 572:	4605                	li	a2,1
 574:	fef40593          	addi	a1,s0,-17
 578:	00000097          	auipc	ra,0x0
 57c:	f56080e7          	jalr	-170(ra) # 4ce <write>
}
 580:	60e2                	ld	ra,24(sp)
 582:	6442                	ld	s0,16(sp)
 584:	6105                	addi	sp,sp,32
 586:	8082                	ret

0000000000000588 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 588:	7139                	addi	sp,sp,-64
 58a:	fc06                	sd	ra,56(sp)
 58c:	f822                	sd	s0,48(sp)
 58e:	f426                	sd	s1,40(sp)
 590:	f04a                	sd	s2,32(sp)
 592:	ec4e                	sd	s3,24(sp)
 594:	0080                	addi	s0,sp,64
 596:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 598:	c299                	beqz	a3,59e <printint+0x16>
 59a:	0805c963          	bltz	a1,62c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 59e:	2581                	sext.w	a1,a1
  neg = 0;
 5a0:	4881                	li	a7,0
 5a2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5a6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5a8:	2601                	sext.w	a2,a2
 5aa:	00000517          	auipc	a0,0x0
 5ae:	51650513          	addi	a0,a0,1302 # ac0 <digits>
 5b2:	883a                	mv	a6,a4
 5b4:	2705                	addiw	a4,a4,1
 5b6:	02c5f7bb          	remuw	a5,a1,a2
 5ba:	1782                	slli	a5,a5,0x20
 5bc:	9381                	srli	a5,a5,0x20
 5be:	97aa                	add	a5,a5,a0
 5c0:	0007c783          	lbu	a5,0(a5)
 5c4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5c8:	0005879b          	sext.w	a5,a1
 5cc:	02c5d5bb          	divuw	a1,a1,a2
 5d0:	0685                	addi	a3,a3,1
 5d2:	fec7f0e3          	bgeu	a5,a2,5b2 <printint+0x2a>
  if(neg)
 5d6:	00088c63          	beqz	a7,5ee <printint+0x66>
    buf[i++] = '-';
 5da:	fd070793          	addi	a5,a4,-48
 5de:	00878733          	add	a4,a5,s0
 5e2:	02d00793          	li	a5,45
 5e6:	fef70823          	sb	a5,-16(a4)
 5ea:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5ee:	02e05863          	blez	a4,61e <printint+0x96>
 5f2:	fc040793          	addi	a5,s0,-64
 5f6:	00e78933          	add	s2,a5,a4
 5fa:	fff78993          	addi	s3,a5,-1
 5fe:	99ba                	add	s3,s3,a4
 600:	377d                	addiw	a4,a4,-1
 602:	1702                	slli	a4,a4,0x20
 604:	9301                	srli	a4,a4,0x20
 606:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 60a:	fff94583          	lbu	a1,-1(s2)
 60e:	8526                	mv	a0,s1
 610:	00000097          	auipc	ra,0x0
 614:	f56080e7          	jalr	-170(ra) # 566 <putc>
  while(--i >= 0)
 618:	197d                	addi	s2,s2,-1
 61a:	ff3918e3          	bne	s2,s3,60a <printint+0x82>
}
 61e:	70e2                	ld	ra,56(sp)
 620:	7442                	ld	s0,48(sp)
 622:	74a2                	ld	s1,40(sp)
 624:	7902                	ld	s2,32(sp)
 626:	69e2                	ld	s3,24(sp)
 628:	6121                	addi	sp,sp,64
 62a:	8082                	ret
    x = -xx;
 62c:	40b005bb          	negw	a1,a1
    neg = 1;
 630:	4885                	li	a7,1
    x = -xx;
 632:	bf85                	j	5a2 <printint+0x1a>

0000000000000634 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 634:	7119                	addi	sp,sp,-128
 636:	fc86                	sd	ra,120(sp)
 638:	f8a2                	sd	s0,112(sp)
 63a:	f4a6                	sd	s1,104(sp)
 63c:	f0ca                	sd	s2,96(sp)
 63e:	ecce                	sd	s3,88(sp)
 640:	e8d2                	sd	s4,80(sp)
 642:	e4d6                	sd	s5,72(sp)
 644:	e0da                	sd	s6,64(sp)
 646:	fc5e                	sd	s7,56(sp)
 648:	f862                	sd	s8,48(sp)
 64a:	f466                	sd	s9,40(sp)
 64c:	f06a                	sd	s10,32(sp)
 64e:	ec6e                	sd	s11,24(sp)
 650:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 652:	0005c903          	lbu	s2,0(a1)
 656:	18090f63          	beqz	s2,7f4 <vprintf+0x1c0>
 65a:	8aaa                	mv	s5,a0
 65c:	8b32                	mv	s6,a2
 65e:	00158493          	addi	s1,a1,1
  state = 0;
 662:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 664:	02500a13          	li	s4,37
 668:	4c55                	li	s8,21
 66a:	00000c97          	auipc	s9,0x0
 66e:	3fec8c93          	addi	s9,s9,1022 # a68 <malloc+0x170>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 672:	02800d93          	li	s11,40
  putc(fd, 'x');
 676:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 678:	00000b97          	auipc	s7,0x0
 67c:	448b8b93          	addi	s7,s7,1096 # ac0 <digits>
 680:	a839                	j	69e <vprintf+0x6a>
        putc(fd, c);
 682:	85ca                	mv	a1,s2
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	ee0080e7          	jalr	-288(ra) # 566 <putc>
 68e:	a019                	j	694 <vprintf+0x60>
    } else if(state == '%'){
 690:	01498d63          	beq	s3,s4,6aa <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 694:	0485                	addi	s1,s1,1
 696:	fff4c903          	lbu	s2,-1(s1)
 69a:	14090d63          	beqz	s2,7f4 <vprintf+0x1c0>
    if(state == 0){
 69e:	fe0999e3          	bnez	s3,690 <vprintf+0x5c>
      if(c == '%'){
 6a2:	ff4910e3          	bne	s2,s4,682 <vprintf+0x4e>
        state = '%';
 6a6:	89d2                	mv	s3,s4
 6a8:	b7f5                	j	694 <vprintf+0x60>
      if(c == 'd'){
 6aa:	11490c63          	beq	s2,s4,7c2 <vprintf+0x18e>
 6ae:	f9d9079b          	addiw	a5,s2,-99
 6b2:	0ff7f793          	zext.b	a5,a5
 6b6:	10fc6e63          	bltu	s8,a5,7d2 <vprintf+0x19e>
 6ba:	f9d9079b          	addiw	a5,s2,-99
 6be:	0ff7f713          	zext.b	a4,a5
 6c2:	10ec6863          	bltu	s8,a4,7d2 <vprintf+0x19e>
 6c6:	00271793          	slli	a5,a4,0x2
 6ca:	97e6                	add	a5,a5,s9
 6cc:	439c                	lw	a5,0(a5)
 6ce:	97e6                	add	a5,a5,s9
 6d0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6d2:	008b0913          	addi	s2,s6,8
 6d6:	4685                	li	a3,1
 6d8:	4629                	li	a2,10
 6da:	000b2583          	lw	a1,0(s6)
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	ea8080e7          	jalr	-344(ra) # 588 <printint>
 6e8:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b765                	j	694 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ee:	008b0913          	addi	s2,s6,8
 6f2:	4681                	li	a3,0
 6f4:	4629                	li	a2,10
 6f6:	000b2583          	lw	a1,0(s6)
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	e8c080e7          	jalr	-372(ra) # 588 <printint>
 704:	8b4a                	mv	s6,s2
      state = 0;
 706:	4981                	li	s3,0
 708:	b771                	j	694 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 70a:	008b0913          	addi	s2,s6,8
 70e:	4681                	li	a3,0
 710:	866a                	mv	a2,s10
 712:	000b2583          	lw	a1,0(s6)
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	e70080e7          	jalr	-400(ra) # 588 <printint>
 720:	8b4a                	mv	s6,s2
      state = 0;
 722:	4981                	li	s3,0
 724:	bf85                	j	694 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 726:	008b0793          	addi	a5,s6,8
 72a:	f8f43423          	sd	a5,-120(s0)
 72e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 732:	03000593          	li	a1,48
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	e2e080e7          	jalr	-466(ra) # 566 <putc>
  putc(fd, 'x');
 740:	07800593          	li	a1,120
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	e20080e7          	jalr	-480(ra) # 566 <putc>
 74e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 750:	03c9d793          	srli	a5,s3,0x3c
 754:	97de                	add	a5,a5,s7
 756:	0007c583          	lbu	a1,0(a5)
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	e0a080e7          	jalr	-502(ra) # 566 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 764:	0992                	slli	s3,s3,0x4
 766:	397d                	addiw	s2,s2,-1
 768:	fe0914e3          	bnez	s2,750 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 76c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 770:	4981                	li	s3,0
 772:	b70d                	j	694 <vprintf+0x60>
        s = va_arg(ap, char*);
 774:	008b0913          	addi	s2,s6,8
 778:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 77c:	02098163          	beqz	s3,79e <vprintf+0x16a>
        while(*s != 0){
 780:	0009c583          	lbu	a1,0(s3)
 784:	c5ad                	beqz	a1,7ee <vprintf+0x1ba>
          putc(fd, *s);
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	dde080e7          	jalr	-546(ra) # 566 <putc>
          s++;
 790:	0985                	addi	s3,s3,1
        while(*s != 0){
 792:	0009c583          	lbu	a1,0(s3)
 796:	f9e5                	bnez	a1,786 <vprintf+0x152>
        s = va_arg(ap, char*);
 798:	8b4a                	mv	s6,s2
      state = 0;
 79a:	4981                	li	s3,0
 79c:	bde5                	j	694 <vprintf+0x60>
          s = "(null)";
 79e:	00000997          	auipc	s3,0x0
 7a2:	2c298993          	addi	s3,s3,706 # a60 <malloc+0x168>
        while(*s != 0){
 7a6:	85ee                	mv	a1,s11
 7a8:	bff9                	j	786 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7aa:	008b0913          	addi	s2,s6,8
 7ae:	000b4583          	lbu	a1,0(s6)
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	db2080e7          	jalr	-590(ra) # 566 <putc>
 7bc:	8b4a                	mv	s6,s2
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	bdd1                	j	694 <vprintf+0x60>
        putc(fd, c);
 7c2:	85d2                	mv	a1,s4
 7c4:	8556                	mv	a0,s5
 7c6:	00000097          	auipc	ra,0x0
 7ca:	da0080e7          	jalr	-608(ra) # 566 <putc>
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	b5d1                	j	694 <vprintf+0x60>
        putc(fd, '%');
 7d2:	85d2                	mv	a1,s4
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	d90080e7          	jalr	-624(ra) # 566 <putc>
        putc(fd, c);
 7de:	85ca                	mv	a1,s2
 7e0:	8556                	mv	a0,s5
 7e2:	00000097          	auipc	ra,0x0
 7e6:	d84080e7          	jalr	-636(ra) # 566 <putc>
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	b565                	j	694 <vprintf+0x60>
        s = va_arg(ap, char*);
 7ee:	8b4a                	mv	s6,s2
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	b54d                	j	694 <vprintf+0x60>
    }
  }
}
 7f4:	70e6                	ld	ra,120(sp)
 7f6:	7446                	ld	s0,112(sp)
 7f8:	74a6                	ld	s1,104(sp)
 7fa:	7906                	ld	s2,96(sp)
 7fc:	69e6                	ld	s3,88(sp)
 7fe:	6a46                	ld	s4,80(sp)
 800:	6aa6                	ld	s5,72(sp)
 802:	6b06                	ld	s6,64(sp)
 804:	7be2                	ld	s7,56(sp)
 806:	7c42                	ld	s8,48(sp)
 808:	7ca2                	ld	s9,40(sp)
 80a:	7d02                	ld	s10,32(sp)
 80c:	6de2                	ld	s11,24(sp)
 80e:	6109                	addi	sp,sp,128
 810:	8082                	ret

0000000000000812 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 812:	715d                	addi	sp,sp,-80
 814:	ec06                	sd	ra,24(sp)
 816:	e822                	sd	s0,16(sp)
 818:	1000                	addi	s0,sp,32
 81a:	e010                	sd	a2,0(s0)
 81c:	e414                	sd	a3,8(s0)
 81e:	e818                	sd	a4,16(s0)
 820:	ec1c                	sd	a5,24(s0)
 822:	03043023          	sd	a6,32(s0)
 826:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 82a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 82e:	8622                	mv	a2,s0
 830:	00000097          	auipc	ra,0x0
 834:	e04080e7          	jalr	-508(ra) # 634 <vprintf>
}
 838:	60e2                	ld	ra,24(sp)
 83a:	6442                	ld	s0,16(sp)
 83c:	6161                	addi	sp,sp,80
 83e:	8082                	ret

0000000000000840 <printf>:

void
printf(const char *fmt, ...)
{
 840:	711d                	addi	sp,sp,-96
 842:	ec06                	sd	ra,24(sp)
 844:	e822                	sd	s0,16(sp)
 846:	1000                	addi	s0,sp,32
 848:	e40c                	sd	a1,8(s0)
 84a:	e810                	sd	a2,16(s0)
 84c:	ec14                	sd	a3,24(s0)
 84e:	f018                	sd	a4,32(s0)
 850:	f41c                	sd	a5,40(s0)
 852:	03043823          	sd	a6,48(s0)
 856:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 85a:	00840613          	addi	a2,s0,8
 85e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 862:	85aa                	mv	a1,a0
 864:	4505                	li	a0,1
 866:	00000097          	auipc	ra,0x0
 86a:	dce080e7          	jalr	-562(ra) # 634 <vprintf>
}
 86e:	60e2                	ld	ra,24(sp)
 870:	6442                	ld	s0,16(sp)
 872:	6125                	addi	sp,sp,96
 874:	8082                	ret

0000000000000876 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 876:	1141                	addi	sp,sp,-16
 878:	e422                	sd	s0,8(sp)
 87a:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 87c:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 880:	00000797          	auipc	a5,0x0
 884:	7807b783          	ld	a5,1920(a5) # 1000 <freep>
 888:	a02d                	j	8b2 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 88a:	4618                	lw	a4,8(a2)
 88c:	9f2d                	addw	a4,a4,a1
 88e:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 892:	6398                	ld	a4,0(a5)
 894:	6310                	ld	a2,0(a4)
 896:	a83d                	j	8d4 <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 898:	ff852703          	lw	a4,-8(a0)
 89c:	9f31                	addw	a4,a4,a2
 89e:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 8a0:	ff053683          	ld	a3,-16(a0)
 8a4:	a091                	j	8e8 <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a6:	6398                	ld	a4,0(a5)
 8a8:	00e7e463          	bltu	a5,a4,8b0 <free+0x3a>
 8ac:	00e6ea63          	bltu	a3,a4,8c0 <free+0x4a>
{
 8b0:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b2:	fed7fae3          	bgeu	a5,a3,8a6 <free+0x30>
 8b6:	6398                	ld	a4,0(a5)
 8b8:	00e6e463          	bltu	a3,a4,8c0 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8bc:	fee7eae3          	bltu	a5,a4,8b0 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 8c0:	ff852583          	lw	a1,-8(a0)
 8c4:	6390                	ld	a2,0(a5)
 8c6:	02059813          	slli	a6,a1,0x20
 8ca:	01c85713          	srli	a4,a6,0x1c
 8ce:	9736                	add	a4,a4,a3
 8d0:	fae60de3          	beq	a2,a4,88a <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 8d4:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 8d8:	4790                	lw	a2,8(a5)
 8da:	02061593          	slli	a1,a2,0x20
 8de:	01c5d713          	srli	a4,a1,0x1c
 8e2:	973e                	add	a4,a4,a5
 8e4:	fae68ae3          	beq	a3,a4,898 <free+0x22>
        p->s.ptr = bp->s.ptr;
 8e8:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 8ea:	00000717          	auipc	a4,0x0
 8ee:	70f73b23          	sd	a5,1814(a4) # 1000 <freep>
}
 8f2:	6422                	ld	s0,8(sp)
 8f4:	0141                	addi	sp,sp,16
 8f6:	8082                	ret

00000000000008f8 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 8f8:	7139                	addi	sp,sp,-64
 8fa:	fc06                	sd	ra,56(sp)
 8fc:	f822                	sd	s0,48(sp)
 8fe:	f426                	sd	s1,40(sp)
 900:	f04a                	sd	s2,32(sp)
 902:	ec4e                	sd	s3,24(sp)
 904:	e852                	sd	s4,16(sp)
 906:	e456                	sd	s5,8(sp)
 908:	e05a                	sd	s6,0(sp)
 90a:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 90c:	02051493          	slli	s1,a0,0x20
 910:	9081                	srli	s1,s1,0x20
 912:	04bd                	addi	s1,s1,15
 914:	8091                	srli	s1,s1,0x4
 916:	0014899b          	addiw	s3,s1,1
 91a:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 91c:	00000517          	auipc	a0,0x0
 920:	6e453503          	ld	a0,1764(a0) # 1000 <freep>
 924:	c515                	beqz	a0,950 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 926:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 928:	4798                	lw	a4,8(a5)
 92a:	02977f63          	bgeu	a4,s1,968 <malloc+0x70>
 92e:	8a4e                	mv	s4,s3
 930:	0009871b          	sext.w	a4,s3
 934:	6685                	lui	a3,0x1
 936:	00d77363          	bgeu	a4,a3,93c <malloc+0x44>
 93a:	6a05                	lui	s4,0x1
 93c:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 940:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 944:	00000917          	auipc	s2,0x0
 948:	6bc90913          	addi	s2,s2,1724 # 1000 <freep>
    if (p == (char *)-1)
 94c:	5afd                	li	s5,-1
 94e:	a895                	j	9c2 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 950:	00000797          	auipc	a5,0x0
 954:	6c078793          	addi	a5,a5,1728 # 1010 <base>
 958:	00000717          	auipc	a4,0x0
 95c:	6af73423          	sd	a5,1704(a4) # 1000 <freep>
 960:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 962:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 966:	b7e1                	j	92e <malloc+0x36>
            if (p->s.size == nunits)
 968:	02e48c63          	beq	s1,a4,9a0 <malloc+0xa8>
                p->s.size -= nunits;
 96c:	4137073b          	subw	a4,a4,s3
 970:	c798                	sw	a4,8(a5)
                p += p->s.size;
 972:	02071693          	slli	a3,a4,0x20
 976:	01c6d713          	srli	a4,a3,0x1c
 97a:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 97c:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 980:	00000717          	auipc	a4,0x0
 984:	68a73023          	sd	a0,1664(a4) # 1000 <freep>
            return (void *)(p + 1);
 988:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 98c:	70e2                	ld	ra,56(sp)
 98e:	7442                	ld	s0,48(sp)
 990:	74a2                	ld	s1,40(sp)
 992:	7902                	ld	s2,32(sp)
 994:	69e2                	ld	s3,24(sp)
 996:	6a42                	ld	s4,16(sp)
 998:	6aa2                	ld	s5,8(sp)
 99a:	6b02                	ld	s6,0(sp)
 99c:	6121                	addi	sp,sp,64
 99e:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 9a0:	6398                	ld	a4,0(a5)
 9a2:	e118                	sd	a4,0(a0)
 9a4:	bff1                	j	980 <malloc+0x88>
    hp->s.size = nu;
 9a6:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 9aa:	0541                	addi	a0,a0,16
 9ac:	00000097          	auipc	ra,0x0
 9b0:	eca080e7          	jalr	-310(ra) # 876 <free>
    return freep;
 9b4:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 9b8:	d971                	beqz	a0,98c <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 9ba:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 9bc:	4798                	lw	a4,8(a5)
 9be:	fa9775e3          	bgeu	a4,s1,968 <malloc+0x70>
        if (p == freep)
 9c2:	00093703          	ld	a4,0(s2)
 9c6:	853e                	mv	a0,a5
 9c8:	fef719e3          	bne	a4,a5,9ba <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 9cc:	8552                	mv	a0,s4
 9ce:	00000097          	auipc	ra,0x0
 9d2:	b68080e7          	jalr	-1176(ra) # 536 <sbrk>
    if (p == (char *)-1)
 9d6:	fd5518e3          	bne	a0,s5,9a6 <malloc+0xae>
                return 0;
 9da:	4501                	li	a0,0
 9dc:	bf45                	j	98c <malloc+0x94>
