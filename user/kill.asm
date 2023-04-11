
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	390080e7          	jalr	912(ra) # 3b8 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	4b2080e7          	jalr	1202(ra) # 4e2 <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	472080e7          	jalr	1138(ra) # 4b2 <exit>
    fprintf(2, "usage: kill pid...\n");
  48:	00001597          	auipc	a1,0x1
  4c:	9a858593          	addi	a1,a1,-1624 # 9f0 <malloc+0xf4>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	7c4080e7          	jalr	1988(ra) # 816 <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	456080e7          	jalr	1110(ra) # 4b2 <exit>

0000000000000064 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
    lk->name = name;
  6a:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  6c:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  70:	57fd                	li	a5,-1
  72:	00f50823          	sb	a5,16(a0)
}
  76:	6422                	ld	s0,8(sp)
  78:	0141                	addi	sp,sp,16
  7a:	8082                	ret

000000000000007c <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  7c:	00054783          	lbu	a5,0(a0)
  80:	e399                	bnez	a5,86 <holding+0xa>
  82:	4501                	li	a0,0
}
  84:	8082                	ret
{
  86:	1101                	addi	sp,sp,-32
  88:	ec06                	sd	ra,24(sp)
  8a:	e822                	sd	s0,16(sp)
  8c:	e426                	sd	s1,8(sp)
  8e:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  90:	01054483          	lbu	s1,16(a0)
  94:	00000097          	auipc	ra,0x0
  98:	122080e7          	jalr	290(ra) # 1b6 <twhoami>
  9c:	2501                	sext.w	a0,a0
  9e:	40a48533          	sub	a0,s1,a0
  a2:	00153513          	seqz	a0,a0
}
  a6:	60e2                	ld	ra,24(sp)
  a8:	6442                	ld	s0,16(sp)
  aa:	64a2                	ld	s1,8(sp)
  ac:	6105                	addi	sp,sp,32
  ae:	8082                	ret

00000000000000b0 <acquire>:

void acquire(struct lock *lk)
{
  b0:	7179                	addi	sp,sp,-48
  b2:	f406                	sd	ra,40(sp)
  b4:	f022                	sd	s0,32(sp)
  b6:	ec26                	sd	s1,24(sp)
  b8:	e84a                	sd	s2,16(sp)
  ba:	e44e                	sd	s3,8(sp)
  bc:	e052                	sd	s4,0(sp)
  be:	1800                	addi	s0,sp,48
  c0:	8a2a                	mv	s4,a0
    if (holding(lk))
  c2:	00000097          	auipc	ra,0x0
  c6:	fba080e7          	jalr	-70(ra) # 7c <holding>
  ca:	e919                	bnez	a0,e0 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  cc:	ffca7493          	andi	s1,s4,-4
  d0:	003a7913          	andi	s2,s4,3
  d4:	0039191b          	slliw	s2,s2,0x3
  d8:	4985                	li	s3,1
  da:	012999bb          	sllw	s3,s3,s2
  de:	a015                	j	102 <acquire+0x52>
        printf("re-acquiring lock we already hold");
  e0:	00001517          	auipc	a0,0x1
  e4:	92850513          	addi	a0,a0,-1752 # a08 <malloc+0x10c>
  e8:	00000097          	auipc	ra,0x0
  ec:	75c080e7          	jalr	1884(ra) # 844 <printf>
        exit(-1);
  f0:	557d                	li	a0,-1
  f2:	00000097          	auipc	ra,0x0
  f6:	3c0080e7          	jalr	960(ra) # 4b2 <exit>
    {
        // give up the cpu for other threads
        tyield();
  fa:	00000097          	auipc	ra,0x0
  fe:	0b0080e7          	jalr	176(ra) # 1aa <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
 102:	4534a7af          	amoor.w.aq	a5,s3,(s1)
 106:	0127d7bb          	srlw	a5,a5,s2
 10a:	0ff7f793          	zext.b	a5,a5
 10e:	f7f5                	bnez	a5,fa <acquire+0x4a>
    }

    __sync_synchronize();
 110:	0ff0000f          	fence

    lk->tid = twhoami();
 114:	00000097          	auipc	ra,0x0
 118:	0a2080e7          	jalr	162(ra) # 1b6 <twhoami>
 11c:	00aa0823          	sb	a0,16(s4)
}
 120:	70a2                	ld	ra,40(sp)
 122:	7402                	ld	s0,32(sp)
 124:	64e2                	ld	s1,24(sp)
 126:	6942                	ld	s2,16(sp)
 128:	69a2                	ld	s3,8(sp)
 12a:	6a02                	ld	s4,0(sp)
 12c:	6145                	addi	sp,sp,48
 12e:	8082                	ret

0000000000000130 <release>:

void release(struct lock *lk)
{
 130:	1101                	addi	sp,sp,-32
 132:	ec06                	sd	ra,24(sp)
 134:	e822                	sd	s0,16(sp)
 136:	e426                	sd	s1,8(sp)
 138:	1000                	addi	s0,sp,32
 13a:	84aa                	mv	s1,a0
    if (!holding(lk))
 13c:	00000097          	auipc	ra,0x0
 140:	f40080e7          	jalr	-192(ra) # 7c <holding>
 144:	c11d                	beqz	a0,16a <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 146:	57fd                	li	a5,-1
 148:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 14c:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
 150:	0ff0000f          	fence
 154:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 158:	00000097          	auipc	ra,0x0
 15c:	052080e7          	jalr	82(ra) # 1aa <tyield>
}
 160:	60e2                	ld	ra,24(sp)
 162:	6442                	ld	s0,16(sp)
 164:	64a2                	ld	s1,8(sp)
 166:	6105                	addi	sp,sp,32
 168:	8082                	ret
        printf("releasing lock we are not holding");
 16a:	00001517          	auipc	a0,0x1
 16e:	8c650513          	addi	a0,a0,-1850 # a30 <malloc+0x134>
 172:	00000097          	auipc	ra,0x0
 176:	6d2080e7          	jalr	1746(ra) # 844 <printf>
        exit(-1);
 17a:	557d                	li	a0,-1
 17c:	00000097          	auipc	ra,0x0
 180:	336080e7          	jalr	822(ra) # 4b2 <exit>

0000000000000184 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
 1a2:	4501                	li	a0,0
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <tyield>:

void tyield()
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <twhoami>:

uint8 twhoami()
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
 1bc:	4501                	li	a0,0
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret

00000000000001c4 <tswtch>:
 1c4:	00153023          	sd	ra,0(a0)
 1c8:	00253423          	sd	sp,8(a0)
 1cc:	e900                	sd	s0,16(a0)
 1ce:	ed04                	sd	s1,24(a0)
 1d0:	03253023          	sd	s2,32(a0)
 1d4:	03353423          	sd	s3,40(a0)
 1d8:	03453823          	sd	s4,48(a0)
 1dc:	03553c23          	sd	s5,56(a0)
 1e0:	05653023          	sd	s6,64(a0)
 1e4:	05753423          	sd	s7,72(a0)
 1e8:	05853823          	sd	s8,80(a0)
 1ec:	05953c23          	sd	s9,88(a0)
 1f0:	07a53023          	sd	s10,96(a0)
 1f4:	07b53423          	sd	s11,104(a0)
 1f8:	0005b083          	ld	ra,0(a1)
 1fc:	0085b103          	ld	sp,8(a1)
 200:	6980                	ld	s0,16(a1)
 202:	6d84                	ld	s1,24(a1)
 204:	0205b903          	ld	s2,32(a1)
 208:	0285b983          	ld	s3,40(a1)
 20c:	0305ba03          	ld	s4,48(a1)
 210:	0385ba83          	ld	s5,56(a1)
 214:	0405bb03          	ld	s6,64(a1)
 218:	0485bb83          	ld	s7,72(a1)
 21c:	0505bc03          	ld	s8,80(a1)
 220:	0585bc83          	ld	s9,88(a1)
 224:	0605bd03          	ld	s10,96(a1)
 228:	0685bd83          	ld	s11,104(a1)
 22c:	8082                	ret

000000000000022e <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 22e:	1141                	addi	sp,sp,-16
 230:	e406                	sd	ra,8(sp)
 232:	e022                	sd	s0,0(sp)
 234:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
 236:	00000097          	auipc	ra,0x0
 23a:	dca080e7          	jalr	-566(ra) # 0 <main>
    exit(res);
 23e:	00000097          	auipc	ra,0x0
 242:	274080e7          	jalr	628(ra) # 4b2 <exit>

0000000000000246 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 24c:	87aa                	mv	a5,a0
 24e:	0585                	addi	a1,a1,1
 250:	0785                	addi	a5,a5,1
 252:	fff5c703          	lbu	a4,-1(a1)
 256:	fee78fa3          	sb	a4,-1(a5)
 25a:	fb75                	bnez	a4,24e <strcpy+0x8>
        ;
    return os;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret

0000000000000262 <strcmp>:

int strcmp(const char *p, const char *q)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 268:	00054783          	lbu	a5,0(a0)
 26c:	cb91                	beqz	a5,280 <strcmp+0x1e>
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00f71763          	bne	a4,a5,280 <strcmp+0x1e>
        p++, q++;
 276:	0505                	addi	a0,a0,1
 278:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 27a:	00054783          	lbu	a5,0(a0)
 27e:	fbe5                	bnez	a5,26e <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 280:	0005c503          	lbu	a0,0(a1)
}
 284:	40a7853b          	subw	a0,a5,a0
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <strlen>:

uint strlen(const char *s)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 294:	00054783          	lbu	a5,0(a0)
 298:	cf91                	beqz	a5,2b4 <strlen+0x26>
 29a:	0505                	addi	a0,a0,1
 29c:	87aa                	mv	a5,a0
 29e:	4685                	li	a3,1
 2a0:	9e89                	subw	a3,a3,a0
 2a2:	00f6853b          	addw	a0,a3,a5
 2a6:	0785                	addi	a5,a5,1
 2a8:	fff7c703          	lbu	a4,-1(a5)
 2ac:	fb7d                	bnez	a4,2a2 <strlen+0x14>
        ;
    return n;
}
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
    for (n = 0; s[n]; n++)
 2b4:	4501                	li	a0,0
 2b6:	bfe5                	j	2ae <strlen+0x20>

00000000000002b8 <memset>:

void *
memset(void *dst, int c, uint n)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 2be:	ca19                	beqz	a2,2d4 <memset+0x1c>
 2c0:	87aa                	mv	a5,a0
 2c2:	1602                	slli	a2,a2,0x20
 2c4:	9201                	srli	a2,a2,0x20
 2c6:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 2ca:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 2ce:	0785                	addi	a5,a5,1
 2d0:	fee79de3          	bne	a5,a4,2ca <memset+0x12>
    }
    return dst;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret

00000000000002da <strchr>:

char *
strchr(const char *s, char c)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
    for (; *s; s++)
 2e0:	00054783          	lbu	a5,0(a0)
 2e4:	cb99                	beqz	a5,2fa <strchr+0x20>
        if (*s == c)
 2e6:	00f58763          	beq	a1,a5,2f4 <strchr+0x1a>
    for (; *s; s++)
 2ea:	0505                	addi	a0,a0,1
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	fbfd                	bnez	a5,2e6 <strchr+0xc>
            return (char *)s;
    return 0;
 2f2:	4501                	li	a0,0
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
    return 0;
 2fa:	4501                	li	a0,0
 2fc:	bfe5                	j	2f4 <strchr+0x1a>

00000000000002fe <gets>:

char *
gets(char *buf, int max)
{
 2fe:	711d                	addi	sp,sp,-96
 300:	ec86                	sd	ra,88(sp)
 302:	e8a2                	sd	s0,80(sp)
 304:	e4a6                	sd	s1,72(sp)
 306:	e0ca                	sd	s2,64(sp)
 308:	fc4e                	sd	s3,56(sp)
 30a:	f852                	sd	s4,48(sp)
 30c:	f456                	sd	s5,40(sp)
 30e:	f05a                	sd	s6,32(sp)
 310:	ec5e                	sd	s7,24(sp)
 312:	1080                	addi	s0,sp,96
 314:	8baa                	mv	s7,a0
 316:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 318:	892a                	mv	s2,a0
 31a:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
 31c:	4aa9                	li	s5,10
 31e:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
 320:	89a6                	mv	s3,s1
 322:	2485                	addiw	s1,s1,1
 324:	0344d863          	bge	s1,s4,354 <gets+0x56>
        cc = read(0, &c, 1);
 328:	4605                	li	a2,1
 32a:	faf40593          	addi	a1,s0,-81
 32e:	4501                	li	a0,0
 330:	00000097          	auipc	ra,0x0
 334:	19a080e7          	jalr	410(ra) # 4ca <read>
        if (cc < 1)
 338:	00a05e63          	blez	a0,354 <gets+0x56>
        buf[i++] = c;
 33c:	faf44783          	lbu	a5,-81(s0)
 340:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 344:	01578763          	beq	a5,s5,352 <gets+0x54>
 348:	0905                	addi	s2,s2,1
 34a:	fd679be3          	bne	a5,s6,320 <gets+0x22>
    for (i = 0; i + 1 < max;)
 34e:	89a6                	mv	s3,s1
 350:	a011                	j	354 <gets+0x56>
 352:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
 354:	99de                	add	s3,s3,s7
 356:	00098023          	sb	zero,0(s3)
    return buf;
}
 35a:	855e                	mv	a0,s7
 35c:	60e6                	ld	ra,88(sp)
 35e:	6446                	ld	s0,80(sp)
 360:	64a6                	ld	s1,72(sp)
 362:	6906                	ld	s2,64(sp)
 364:	79e2                	ld	s3,56(sp)
 366:	7a42                	ld	s4,48(sp)
 368:	7aa2                	ld	s5,40(sp)
 36a:	7b02                	ld	s6,32(sp)
 36c:	6be2                	ld	s7,24(sp)
 36e:	6125                	addi	sp,sp,96
 370:	8082                	ret

0000000000000372 <stat>:

int stat(const char *n, struct stat *st)
{
 372:	1101                	addi	sp,sp,-32
 374:	ec06                	sd	ra,24(sp)
 376:	e822                	sd	s0,16(sp)
 378:	e426                	sd	s1,8(sp)
 37a:	e04a                	sd	s2,0(sp)
 37c:	1000                	addi	s0,sp,32
 37e:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 380:	4581                	li	a1,0
 382:	00000097          	auipc	ra,0x0
 386:	170080e7          	jalr	368(ra) # 4f2 <open>
    if (fd < 0)
 38a:	02054563          	bltz	a0,3b4 <stat+0x42>
 38e:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 390:	85ca                	mv	a1,s2
 392:	00000097          	auipc	ra,0x0
 396:	178080e7          	jalr	376(ra) # 50a <fstat>
 39a:	892a                	mv	s2,a0
    close(fd);
 39c:	8526                	mv	a0,s1
 39e:	00000097          	auipc	ra,0x0
 3a2:	13c080e7          	jalr	316(ra) # 4da <close>
    return r;
}
 3a6:	854a                	mv	a0,s2
 3a8:	60e2                	ld	ra,24(sp)
 3aa:	6442                	ld	s0,16(sp)
 3ac:	64a2                	ld	s1,8(sp)
 3ae:	6902                	ld	s2,0(sp)
 3b0:	6105                	addi	sp,sp,32
 3b2:	8082                	ret
        return -1;
 3b4:	597d                	li	s2,-1
 3b6:	bfc5                	j	3a6 <stat+0x34>

00000000000003b8 <atoi>:

int atoi(const char *s)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e422                	sd	s0,8(sp)
 3bc:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 3be:	00054683          	lbu	a3,0(a0)
 3c2:	fd06879b          	addiw	a5,a3,-48
 3c6:	0ff7f793          	zext.b	a5,a5
 3ca:	4625                	li	a2,9
 3cc:	02f66863          	bltu	a2,a5,3fc <atoi+0x44>
 3d0:	872a                	mv	a4,a0
    n = 0;
 3d2:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 3d4:	0705                	addi	a4,a4,1
 3d6:	0025179b          	slliw	a5,a0,0x2
 3da:	9fa9                	addw	a5,a5,a0
 3dc:	0017979b          	slliw	a5,a5,0x1
 3e0:	9fb5                	addw	a5,a5,a3
 3e2:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 3e6:	00074683          	lbu	a3,0(a4)
 3ea:	fd06879b          	addiw	a5,a3,-48
 3ee:	0ff7f793          	zext.b	a5,a5
 3f2:	fef671e3          	bgeu	a2,a5,3d4 <atoi+0x1c>
    return n;
}
 3f6:	6422                	ld	s0,8(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret
    n = 0;
 3fc:	4501                	li	a0,0
 3fe:	bfe5                	j	3f6 <atoi+0x3e>

0000000000000400 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 400:	1141                	addi	sp,sp,-16
 402:	e422                	sd	s0,8(sp)
 404:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 406:	02b57463          	bgeu	a0,a1,42e <memmove+0x2e>
    {
        while (n-- > 0)
 40a:	00c05f63          	blez	a2,428 <memmove+0x28>
 40e:	1602                	slli	a2,a2,0x20
 410:	9201                	srli	a2,a2,0x20
 412:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 416:	872a                	mv	a4,a0
            *dst++ = *src++;
 418:	0585                	addi	a1,a1,1
 41a:	0705                	addi	a4,a4,1
 41c:	fff5c683          	lbu	a3,-1(a1)
 420:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 424:	fee79ae3          	bne	a5,a4,418 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 428:	6422                	ld	s0,8(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret
        dst += n;
 42e:	00c50733          	add	a4,a0,a2
        src += n;
 432:	95b2                	add	a1,a1,a2
        while (n-- > 0)
 434:	fec05ae3          	blez	a2,428 <memmove+0x28>
 438:	fff6079b          	addiw	a5,a2,-1
 43c:	1782                	slli	a5,a5,0x20
 43e:	9381                	srli	a5,a5,0x20
 440:	fff7c793          	not	a5,a5
 444:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 446:	15fd                	addi	a1,a1,-1
 448:	177d                	addi	a4,a4,-1
 44a:	0005c683          	lbu	a3,0(a1)
 44e:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 452:	fee79ae3          	bne	a5,a4,446 <memmove+0x46>
 456:	bfc9                	j	428 <memmove+0x28>

0000000000000458 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 458:	1141                	addi	sp,sp,-16
 45a:	e422                	sd	s0,8(sp)
 45c:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 45e:	ca05                	beqz	a2,48e <memcmp+0x36>
 460:	fff6069b          	addiw	a3,a2,-1
 464:	1682                	slli	a3,a3,0x20
 466:	9281                	srli	a3,a3,0x20
 468:	0685                	addi	a3,a3,1
 46a:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
 46c:	00054783          	lbu	a5,0(a0)
 470:	0005c703          	lbu	a4,0(a1)
 474:	00e79863          	bne	a5,a4,484 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
 478:	0505                	addi	a0,a0,1
        p2++;
 47a:	0585                	addi	a1,a1,1
    while (n-- > 0)
 47c:	fed518e3          	bne	a0,a3,46c <memcmp+0x14>
    }
    return 0;
 480:	4501                	li	a0,0
 482:	a019                	j	488 <memcmp+0x30>
            return *p1 - *p2;
 484:	40e7853b          	subw	a0,a5,a4
}
 488:	6422                	ld	s0,8(sp)
 48a:	0141                	addi	sp,sp,16
 48c:	8082                	ret
    return 0;
 48e:	4501                	li	a0,0
 490:	bfe5                	j	488 <memcmp+0x30>

0000000000000492 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 492:	1141                	addi	sp,sp,-16
 494:	e406                	sd	ra,8(sp)
 496:	e022                	sd	s0,0(sp)
 498:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 49a:	00000097          	auipc	ra,0x0
 49e:	f66080e7          	jalr	-154(ra) # 400 <memmove>
}
 4a2:	60a2                	ld	ra,8(sp)
 4a4:	6402                	ld	s0,0(sp)
 4a6:	0141                	addi	sp,sp,16
 4a8:	8082                	ret

00000000000004aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4aa:	4885                	li	a7,1
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b2:	4889                	li	a7,2
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ba:	488d                	li	a7,3
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c2:	4891                	li	a7,4
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <read>:
.global read
read:
 li a7, SYS_read
 4ca:	4895                	li	a7,5
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <write>:
.global write
write:
 li a7, SYS_write
 4d2:	48c1                	li	a7,16
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <close>:
.global close
close:
 li a7, SYS_close
 4da:	48d5                	li	a7,21
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4e2:	4899                	li	a7,6
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ea:	489d                	li	a7,7
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <open>:
.global open
open:
 li a7, SYS_open
 4f2:	48bd                	li	a7,15
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4fa:	48c5                	li	a7,17
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 502:	48c9                	li	a7,18
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 50a:	48a1                	li	a7,8
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <link>:
.global link
link:
 li a7, SYS_link
 512:	48cd                	li	a7,19
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 51a:	48d1                	li	a7,20
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 522:	48a5                	li	a7,9
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <dup>:
.global dup
dup:
 li a7, SYS_dup
 52a:	48a9                	li	a7,10
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 532:	48ad                	li	a7,11
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 53a:	48b1                	li	a7,12
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 542:	48b5                	li	a7,13
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 54a:	48b9                	li	a7,14
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <ps>:
.global ps
ps:
 li a7, SYS_ps
 552:	48d9                	li	a7,22
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 55a:	48dd                	li	a7,23
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 562:	48e1                	li	a7,24
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 56a:	1101                	addi	sp,sp,-32
 56c:	ec06                	sd	ra,24(sp)
 56e:	e822                	sd	s0,16(sp)
 570:	1000                	addi	s0,sp,32
 572:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 576:	4605                	li	a2,1
 578:	fef40593          	addi	a1,s0,-17
 57c:	00000097          	auipc	ra,0x0
 580:	f56080e7          	jalr	-170(ra) # 4d2 <write>
}
 584:	60e2                	ld	ra,24(sp)
 586:	6442                	ld	s0,16(sp)
 588:	6105                	addi	sp,sp,32
 58a:	8082                	ret

000000000000058c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 58c:	7139                	addi	sp,sp,-64
 58e:	fc06                	sd	ra,56(sp)
 590:	f822                	sd	s0,48(sp)
 592:	f426                	sd	s1,40(sp)
 594:	f04a                	sd	s2,32(sp)
 596:	ec4e                	sd	s3,24(sp)
 598:	0080                	addi	s0,sp,64
 59a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 59c:	c299                	beqz	a3,5a2 <printint+0x16>
 59e:	0805c963          	bltz	a1,630 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a2:	2581                	sext.w	a1,a1
  neg = 0;
 5a4:	4881                	li	a7,0
 5a6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5aa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5ac:	2601                	sext.w	a2,a2
 5ae:	00000517          	auipc	a0,0x0
 5b2:	50a50513          	addi	a0,a0,1290 # ab8 <digits>
 5b6:	883a                	mv	a6,a4
 5b8:	2705                	addiw	a4,a4,1
 5ba:	02c5f7bb          	remuw	a5,a1,a2
 5be:	1782                	slli	a5,a5,0x20
 5c0:	9381                	srli	a5,a5,0x20
 5c2:	97aa                	add	a5,a5,a0
 5c4:	0007c783          	lbu	a5,0(a5)
 5c8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5cc:	0005879b          	sext.w	a5,a1
 5d0:	02c5d5bb          	divuw	a1,a1,a2
 5d4:	0685                	addi	a3,a3,1
 5d6:	fec7f0e3          	bgeu	a5,a2,5b6 <printint+0x2a>
  if(neg)
 5da:	00088c63          	beqz	a7,5f2 <printint+0x66>
    buf[i++] = '-';
 5de:	fd070793          	addi	a5,a4,-48
 5e2:	00878733          	add	a4,a5,s0
 5e6:	02d00793          	li	a5,45
 5ea:	fef70823          	sb	a5,-16(a4)
 5ee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5f2:	02e05863          	blez	a4,622 <printint+0x96>
 5f6:	fc040793          	addi	a5,s0,-64
 5fa:	00e78933          	add	s2,a5,a4
 5fe:	fff78993          	addi	s3,a5,-1
 602:	99ba                	add	s3,s3,a4
 604:	377d                	addiw	a4,a4,-1
 606:	1702                	slli	a4,a4,0x20
 608:	9301                	srli	a4,a4,0x20
 60a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 60e:	fff94583          	lbu	a1,-1(s2)
 612:	8526                	mv	a0,s1
 614:	00000097          	auipc	ra,0x0
 618:	f56080e7          	jalr	-170(ra) # 56a <putc>
  while(--i >= 0)
 61c:	197d                	addi	s2,s2,-1
 61e:	ff3918e3          	bne	s2,s3,60e <printint+0x82>
}
 622:	70e2                	ld	ra,56(sp)
 624:	7442                	ld	s0,48(sp)
 626:	74a2                	ld	s1,40(sp)
 628:	7902                	ld	s2,32(sp)
 62a:	69e2                	ld	s3,24(sp)
 62c:	6121                	addi	sp,sp,64
 62e:	8082                	ret
    x = -xx;
 630:	40b005bb          	negw	a1,a1
    neg = 1;
 634:	4885                	li	a7,1
    x = -xx;
 636:	bf85                	j	5a6 <printint+0x1a>

0000000000000638 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 638:	7119                	addi	sp,sp,-128
 63a:	fc86                	sd	ra,120(sp)
 63c:	f8a2                	sd	s0,112(sp)
 63e:	f4a6                	sd	s1,104(sp)
 640:	f0ca                	sd	s2,96(sp)
 642:	ecce                	sd	s3,88(sp)
 644:	e8d2                	sd	s4,80(sp)
 646:	e4d6                	sd	s5,72(sp)
 648:	e0da                	sd	s6,64(sp)
 64a:	fc5e                	sd	s7,56(sp)
 64c:	f862                	sd	s8,48(sp)
 64e:	f466                	sd	s9,40(sp)
 650:	f06a                	sd	s10,32(sp)
 652:	ec6e                	sd	s11,24(sp)
 654:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 656:	0005c903          	lbu	s2,0(a1)
 65a:	18090f63          	beqz	s2,7f8 <vprintf+0x1c0>
 65e:	8aaa                	mv	s5,a0
 660:	8b32                	mv	s6,a2
 662:	00158493          	addi	s1,a1,1
  state = 0;
 666:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 668:	02500a13          	li	s4,37
 66c:	4c55                	li	s8,21
 66e:	00000c97          	auipc	s9,0x0
 672:	3f2c8c93          	addi	s9,s9,1010 # a60 <malloc+0x164>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 676:	02800d93          	li	s11,40
  putc(fd, 'x');
 67a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67c:	00000b97          	auipc	s7,0x0
 680:	43cb8b93          	addi	s7,s7,1084 # ab8 <digits>
 684:	a839                	j	6a2 <vprintf+0x6a>
        putc(fd, c);
 686:	85ca                	mv	a1,s2
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	ee0080e7          	jalr	-288(ra) # 56a <putc>
 692:	a019                	j	698 <vprintf+0x60>
    } else if(state == '%'){
 694:	01498d63          	beq	s3,s4,6ae <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 698:	0485                	addi	s1,s1,1
 69a:	fff4c903          	lbu	s2,-1(s1)
 69e:	14090d63          	beqz	s2,7f8 <vprintf+0x1c0>
    if(state == 0){
 6a2:	fe0999e3          	bnez	s3,694 <vprintf+0x5c>
      if(c == '%'){
 6a6:	ff4910e3          	bne	s2,s4,686 <vprintf+0x4e>
        state = '%';
 6aa:	89d2                	mv	s3,s4
 6ac:	b7f5                	j	698 <vprintf+0x60>
      if(c == 'd'){
 6ae:	11490c63          	beq	s2,s4,7c6 <vprintf+0x18e>
 6b2:	f9d9079b          	addiw	a5,s2,-99
 6b6:	0ff7f793          	zext.b	a5,a5
 6ba:	10fc6e63          	bltu	s8,a5,7d6 <vprintf+0x19e>
 6be:	f9d9079b          	addiw	a5,s2,-99
 6c2:	0ff7f713          	zext.b	a4,a5
 6c6:	10ec6863          	bltu	s8,a4,7d6 <vprintf+0x19e>
 6ca:	00271793          	slli	a5,a4,0x2
 6ce:	97e6                	add	a5,a5,s9
 6d0:	439c                	lw	a5,0(a5)
 6d2:	97e6                	add	a5,a5,s9
 6d4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6d6:	008b0913          	addi	s2,s6,8
 6da:	4685                	li	a3,1
 6dc:	4629                	li	a2,10
 6de:	000b2583          	lw	a1,0(s6)
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	ea8080e7          	jalr	-344(ra) # 58c <printint>
 6ec:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b765                	j	698 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f2:	008b0913          	addi	s2,s6,8
 6f6:	4681                	li	a3,0
 6f8:	4629                	li	a2,10
 6fa:	000b2583          	lw	a1,0(s6)
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	e8c080e7          	jalr	-372(ra) # 58c <printint>
 708:	8b4a                	mv	s6,s2
      state = 0;
 70a:	4981                	li	s3,0
 70c:	b771                	j	698 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 70e:	008b0913          	addi	s2,s6,8
 712:	4681                	li	a3,0
 714:	866a                	mv	a2,s10
 716:	000b2583          	lw	a1,0(s6)
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	e70080e7          	jalr	-400(ra) # 58c <printint>
 724:	8b4a                	mv	s6,s2
      state = 0;
 726:	4981                	li	s3,0
 728:	bf85                	j	698 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 72a:	008b0793          	addi	a5,s6,8
 72e:	f8f43423          	sd	a5,-120(s0)
 732:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 736:	03000593          	li	a1,48
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	e2e080e7          	jalr	-466(ra) # 56a <putc>
  putc(fd, 'x');
 744:	07800593          	li	a1,120
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	e20080e7          	jalr	-480(ra) # 56a <putc>
 752:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 754:	03c9d793          	srli	a5,s3,0x3c
 758:	97de                	add	a5,a5,s7
 75a:	0007c583          	lbu	a1,0(a5)
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	e0a080e7          	jalr	-502(ra) # 56a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 768:	0992                	slli	s3,s3,0x4
 76a:	397d                	addiw	s2,s2,-1
 76c:	fe0914e3          	bnez	s2,754 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 770:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 774:	4981                	li	s3,0
 776:	b70d                	j	698 <vprintf+0x60>
        s = va_arg(ap, char*);
 778:	008b0913          	addi	s2,s6,8
 77c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 780:	02098163          	beqz	s3,7a2 <vprintf+0x16a>
        while(*s != 0){
 784:	0009c583          	lbu	a1,0(s3)
 788:	c5ad                	beqz	a1,7f2 <vprintf+0x1ba>
          putc(fd, *s);
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	dde080e7          	jalr	-546(ra) # 56a <putc>
          s++;
 794:	0985                	addi	s3,s3,1
        while(*s != 0){
 796:	0009c583          	lbu	a1,0(s3)
 79a:	f9e5                	bnez	a1,78a <vprintf+0x152>
        s = va_arg(ap, char*);
 79c:	8b4a                	mv	s6,s2
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bde5                	j	698 <vprintf+0x60>
          s = "(null)";
 7a2:	00000997          	auipc	s3,0x0
 7a6:	2b698993          	addi	s3,s3,694 # a58 <malloc+0x15c>
        while(*s != 0){
 7aa:	85ee                	mv	a1,s11
 7ac:	bff9                	j	78a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7ae:	008b0913          	addi	s2,s6,8
 7b2:	000b4583          	lbu	a1,0(s6)
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	db2080e7          	jalr	-590(ra) # 56a <putc>
 7c0:	8b4a                	mv	s6,s2
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	bdd1                	j	698 <vprintf+0x60>
        putc(fd, c);
 7c6:	85d2                	mv	a1,s4
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	da0080e7          	jalr	-608(ra) # 56a <putc>
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	b5d1                	j	698 <vprintf+0x60>
        putc(fd, '%');
 7d6:	85d2                	mv	a1,s4
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	d90080e7          	jalr	-624(ra) # 56a <putc>
        putc(fd, c);
 7e2:	85ca                	mv	a1,s2
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	d84080e7          	jalr	-636(ra) # 56a <putc>
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	b565                	j	698 <vprintf+0x60>
        s = va_arg(ap, char*);
 7f2:	8b4a                	mv	s6,s2
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	b54d                	j	698 <vprintf+0x60>
    }
  }
}
 7f8:	70e6                	ld	ra,120(sp)
 7fa:	7446                	ld	s0,112(sp)
 7fc:	74a6                	ld	s1,104(sp)
 7fe:	7906                	ld	s2,96(sp)
 800:	69e6                	ld	s3,88(sp)
 802:	6a46                	ld	s4,80(sp)
 804:	6aa6                	ld	s5,72(sp)
 806:	6b06                	ld	s6,64(sp)
 808:	7be2                	ld	s7,56(sp)
 80a:	7c42                	ld	s8,48(sp)
 80c:	7ca2                	ld	s9,40(sp)
 80e:	7d02                	ld	s10,32(sp)
 810:	6de2                	ld	s11,24(sp)
 812:	6109                	addi	sp,sp,128
 814:	8082                	ret

0000000000000816 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 816:	715d                	addi	sp,sp,-80
 818:	ec06                	sd	ra,24(sp)
 81a:	e822                	sd	s0,16(sp)
 81c:	1000                	addi	s0,sp,32
 81e:	e010                	sd	a2,0(s0)
 820:	e414                	sd	a3,8(s0)
 822:	e818                	sd	a4,16(s0)
 824:	ec1c                	sd	a5,24(s0)
 826:	03043023          	sd	a6,32(s0)
 82a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 82e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 832:	8622                	mv	a2,s0
 834:	00000097          	auipc	ra,0x0
 838:	e04080e7          	jalr	-508(ra) # 638 <vprintf>
}
 83c:	60e2                	ld	ra,24(sp)
 83e:	6442                	ld	s0,16(sp)
 840:	6161                	addi	sp,sp,80
 842:	8082                	ret

0000000000000844 <printf>:

void
printf(const char *fmt, ...)
{
 844:	711d                	addi	sp,sp,-96
 846:	ec06                	sd	ra,24(sp)
 848:	e822                	sd	s0,16(sp)
 84a:	1000                	addi	s0,sp,32
 84c:	e40c                	sd	a1,8(s0)
 84e:	e810                	sd	a2,16(s0)
 850:	ec14                	sd	a3,24(s0)
 852:	f018                	sd	a4,32(s0)
 854:	f41c                	sd	a5,40(s0)
 856:	03043823          	sd	a6,48(s0)
 85a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 85e:	00840613          	addi	a2,s0,8
 862:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 866:	85aa                	mv	a1,a0
 868:	4505                	li	a0,1
 86a:	00000097          	auipc	ra,0x0
 86e:	dce080e7          	jalr	-562(ra) # 638 <vprintf>
}
 872:	60e2                	ld	ra,24(sp)
 874:	6442                	ld	s0,16(sp)
 876:	6125                	addi	sp,sp,96
 878:	8082                	ret

000000000000087a <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 87a:	1141                	addi	sp,sp,-16
 87c:	e422                	sd	s0,8(sp)
 87e:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 880:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 884:	00000797          	auipc	a5,0x0
 888:	77c7b783          	ld	a5,1916(a5) # 1000 <freep>
 88c:	a02d                	j	8b6 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
 88e:	4618                	lw	a4,8(a2)
 890:	9f2d                	addw	a4,a4,a1
 892:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 896:	6398                	ld	a4,0(a5)
 898:	6310                	ld	a2,0(a4)
 89a:	a83d                	j	8d8 <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
 89c:	ff852703          	lw	a4,-8(a0)
 8a0:	9f31                	addw	a4,a4,a2
 8a2:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 8a4:	ff053683          	ld	a3,-16(a0)
 8a8:	a091                	j	8ec <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8aa:	6398                	ld	a4,0(a5)
 8ac:	00e7e463          	bltu	a5,a4,8b4 <free+0x3a>
 8b0:	00e6ea63          	bltu	a3,a4,8c4 <free+0x4a>
{
 8b4:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b6:	fed7fae3          	bgeu	a5,a3,8aa <free+0x30>
 8ba:	6398                	ld	a4,0(a5)
 8bc:	00e6e463          	bltu	a3,a4,8c4 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c0:	fee7eae3          	bltu	a5,a4,8b4 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
 8c4:	ff852583          	lw	a1,-8(a0)
 8c8:	6390                	ld	a2,0(a5)
 8ca:	02059813          	slli	a6,a1,0x20
 8ce:	01c85713          	srli	a4,a6,0x1c
 8d2:	9736                	add	a4,a4,a3
 8d4:	fae60de3          	beq	a2,a4,88e <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
 8d8:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
 8dc:	4790                	lw	a2,8(a5)
 8de:	02061593          	slli	a1,a2,0x20
 8e2:	01c5d713          	srli	a4,a1,0x1c
 8e6:	973e                	add	a4,a4,a5
 8e8:	fae68ae3          	beq	a3,a4,89c <free+0x22>
        p->s.ptr = bp->s.ptr;
 8ec:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70f73923          	sd	a5,1810(a4) # 1000 <freep>
}
 8f6:	6422                	ld	s0,8(sp)
 8f8:	0141                	addi	sp,sp,16
 8fa:	8082                	ret

00000000000008fc <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 8fc:	7139                	addi	sp,sp,-64
 8fe:	fc06                	sd	ra,56(sp)
 900:	f822                	sd	s0,48(sp)
 902:	f426                	sd	s1,40(sp)
 904:	f04a                	sd	s2,32(sp)
 906:	ec4e                	sd	s3,24(sp)
 908:	e852                	sd	s4,16(sp)
 90a:	e456                	sd	s5,8(sp)
 90c:	e05a                	sd	s6,0(sp)
 90e:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 910:	02051493          	slli	s1,a0,0x20
 914:	9081                	srli	s1,s1,0x20
 916:	04bd                	addi	s1,s1,15
 918:	8091                	srli	s1,s1,0x4
 91a:	0014899b          	addiw	s3,s1,1
 91e:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
 920:	00000517          	auipc	a0,0x0
 924:	6e053503          	ld	a0,1760(a0) # 1000 <freep>
 928:	c515                	beqz	a0,954 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 92a:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 92c:	4798                	lw	a4,8(a5)
 92e:	02977f63          	bgeu	a4,s1,96c <malloc+0x70>
 932:	8a4e                	mv	s4,s3
 934:	0009871b          	sext.w	a4,s3
 938:	6685                	lui	a3,0x1
 93a:	00d77363          	bgeu	a4,a3,940 <malloc+0x44>
 93e:	6a05                	lui	s4,0x1
 940:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 944:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 948:	00000917          	auipc	s2,0x0
 94c:	6b890913          	addi	s2,s2,1720 # 1000 <freep>
    if (p == (char *)-1)
 950:	5afd                	li	s5,-1
 952:	a895                	j	9c6 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
 954:	00000797          	auipc	a5,0x0
 958:	6bc78793          	addi	a5,a5,1724 # 1010 <base>
 95c:	00000717          	auipc	a4,0x0
 960:	6af73223          	sd	a5,1700(a4) # 1000 <freep>
 964:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 966:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 96a:	b7e1                	j	932 <malloc+0x36>
            if (p->s.size == nunits)
 96c:	02e48c63          	beq	s1,a4,9a4 <malloc+0xa8>
                p->s.size -= nunits;
 970:	4137073b          	subw	a4,a4,s3
 974:	c798                	sw	a4,8(a5)
                p += p->s.size;
 976:	02071693          	slli	a3,a4,0x20
 97a:	01c6d713          	srli	a4,a3,0x1c
 97e:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 980:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 984:	00000717          	auipc	a4,0x0
 988:	66a73e23          	sd	a0,1660(a4) # 1000 <freep>
            return (void *)(p + 1);
 98c:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
 990:	70e2                	ld	ra,56(sp)
 992:	7442                	ld	s0,48(sp)
 994:	74a2                	ld	s1,40(sp)
 996:	7902                	ld	s2,32(sp)
 998:	69e2                	ld	s3,24(sp)
 99a:	6a42                	ld	s4,16(sp)
 99c:	6aa2                	ld	s5,8(sp)
 99e:	6b02                	ld	s6,0(sp)
 9a0:	6121                	addi	sp,sp,64
 9a2:	8082                	ret
                prevp->s.ptr = p->s.ptr;
 9a4:	6398                	ld	a4,0(a5)
 9a6:	e118                	sd	a4,0(a0)
 9a8:	bff1                	j	984 <malloc+0x88>
    hp->s.size = nu;
 9aa:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 9ae:	0541                	addi	a0,a0,16
 9b0:	00000097          	auipc	ra,0x0
 9b4:	eca080e7          	jalr	-310(ra) # 87a <free>
    return freep;
 9b8:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
 9bc:	d971                	beqz	a0,990 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 9be:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 9c0:	4798                	lw	a4,8(a5)
 9c2:	fa9775e3          	bgeu	a4,s1,96c <malloc+0x70>
        if (p == freep)
 9c6:	00093703          	ld	a4,0(s2)
 9ca:	853e                	mv	a0,a5
 9cc:	fef719e3          	bne	a4,a5,9be <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
 9d0:	8552                	mv	a0,s4
 9d2:	00000097          	auipc	ra,0x0
 9d6:	b68080e7          	jalr	-1176(ra) # 53a <sbrk>
    if (p == (char *)-1)
 9da:	fd5518e3          	bne	a0,s5,9aa <malloc+0xae>
                return 0;
 9de:	4501                	li	a0,0
 9e0:	bf45                	j	990 <malloc+0x94>
