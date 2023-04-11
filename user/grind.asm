
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	fee080e7          	jalr	-18(ra) # 107e <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	49650513          	addi	a0,a0,1174 # 1530 <malloc+0xf0>
      a2:	00001097          	auipc	ra,0x1
      a6:	fbc080e7          	jalr	-68(ra) # 105e <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	48650513          	addi	a0,a0,1158 # 1530 <malloc+0xf0>
      b2:	00001097          	auipc	ra,0x1
      b6:	fb4080e7          	jalr	-76(ra) # 1066 <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	47c50513          	addi	a0,a0,1148 # 1538 <malloc+0xf8>
      c4:	00001097          	auipc	ra,0x1
      c8:	2c4080e7          	jalr	708(ra) # 1388 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	f28080e7          	jalr	-216(ra) # ff6 <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	48250513          	addi	a0,a0,1154 # 1558 <malloc+0x118>
      de:	00001097          	auipc	ra,0x1
      e2:	f88080e7          	jalr	-120(ra) # 1066 <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e6:	00001997          	auipc	s3,0x1
      ea:	48298993          	addi	s3,s3,1154 # 1568 <malloc+0x128>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	47098993          	addi	s3,s3,1136 # 1560 <malloc+0x120>
    iters++;
      f8:	4485                	li	s1,1
  int fd = -1;
      fa:	5a7d                	li	s4,-1
      fc:	00001917          	auipc	s2,0x1
     100:	71c90913          	addi	s2,s2,1820 # 1818 <malloc+0x3d8>
     104:	a825                	j	13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	46650513          	addi	a0,a0,1126 # 1570 <malloc+0x130>
     112:	00001097          	auipc	ra,0x1
     116:	f24080e7          	jalr	-220(ra) # 1036 <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	f04080e7          	jalr	-252(ra) # 101e <close>
    iters++;
     122:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ce                	mv	a1,s3
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	ee2080e7          	jalr	-286(ra) # 1016 <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	47d9                	li	a5,22
     152:	fca7e8e3          	bltu	a5,a0,122 <go+0xaa>
     156:	050a                	slli	a0,a0,0x2
     158:	954a                	add	a0,a0,s2
     15a:	411c                	lw	a5,0(a0)
     15c:	97ca                	add	a5,a5,s2
     15e:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     160:	20200593          	li	a1,514
     164:	00001517          	auipc	a0,0x1
     168:	41c50513          	addi	a0,a0,1052 # 1580 <malloc+0x140>
     16c:	00001097          	auipc	ra,0x1
     170:	eca080e7          	jalr	-310(ra) # 1036 <open>
     174:	00001097          	auipc	ra,0x1
     178:	eaa080e7          	jalr	-342(ra) # 101e <close>
     17c:	b75d                	j	122 <go+0xaa>
    } else if(what == 3){
      unlink("grindir/../a");
     17e:	00001517          	auipc	a0,0x1
     182:	3f250513          	addi	a0,a0,1010 # 1570 <malloc+0x130>
     186:	00001097          	auipc	ra,0x1
     18a:	ec0080e7          	jalr	-320(ra) # 1046 <unlink>
     18e:	bf51                	j	122 <go+0xaa>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     190:	00001517          	auipc	a0,0x1
     194:	3a050513          	addi	a0,a0,928 # 1530 <malloc+0xf0>
     198:	00001097          	auipc	ra,0x1
     19c:	ece080e7          	jalr	-306(ra) # 1066 <chdir>
     1a0:	e115                	bnez	a0,1c4 <go+0x14c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1a2:	00001517          	auipc	a0,0x1
     1a6:	3f650513          	addi	a0,a0,1014 # 1598 <malloc+0x158>
     1aa:	00001097          	auipc	ra,0x1
     1ae:	e9c080e7          	jalr	-356(ra) # 1046 <unlink>
      chdir("/");
     1b2:	00001517          	auipc	a0,0x1
     1b6:	3a650513          	addi	a0,a0,934 # 1558 <malloc+0x118>
     1ba:	00001097          	auipc	ra,0x1
     1be:	eac080e7          	jalr	-340(ra) # 1066 <chdir>
     1c2:	b785                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     1c4:	00001517          	auipc	a0,0x1
     1c8:	37450513          	addi	a0,a0,884 # 1538 <malloc+0xf8>
     1cc:	00001097          	auipc	ra,0x1
     1d0:	1bc080e7          	jalr	444(ra) # 1388 <printf>
        exit(1);
     1d4:	4505                	li	a0,1
     1d6:	00001097          	auipc	ra,0x1
     1da:	e20080e7          	jalr	-480(ra) # ff6 <exit>
    } else if(what == 5){
      close(fd);
     1de:	8552                	mv	a0,s4
     1e0:	00001097          	auipc	ra,0x1
     1e4:	e3e080e7          	jalr	-450(ra) # 101e <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1e8:	20200593          	li	a1,514
     1ec:	00001517          	auipc	a0,0x1
     1f0:	3b450513          	addi	a0,a0,948 # 15a0 <malloc+0x160>
     1f4:	00001097          	auipc	ra,0x1
     1f8:	e42080e7          	jalr	-446(ra) # 1036 <open>
     1fc:	8a2a                	mv	s4,a0
     1fe:	b715                	j	122 <go+0xaa>
    } else if(what == 6){
      close(fd);
     200:	8552                	mv	a0,s4
     202:	00001097          	auipc	ra,0x1
     206:	e1c080e7          	jalr	-484(ra) # 101e <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     20a:	20200593          	li	a1,514
     20e:	00001517          	auipc	a0,0x1
     212:	3a250513          	addi	a0,a0,930 # 15b0 <malloc+0x170>
     216:	00001097          	auipc	ra,0x1
     21a:	e20080e7          	jalr	-480(ra) # 1036 <open>
     21e:	8a2a                	mv	s4,a0
     220:	b709                	j	122 <go+0xaa>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     222:	3e700613          	li	a2,999
     226:	00002597          	auipc	a1,0x2
     22a:	dfa58593          	addi	a1,a1,-518 # 2020 <buf.0>
     22e:	8552                	mv	a0,s4
     230:	00001097          	auipc	ra,0x1
     234:	de6080e7          	jalr	-538(ra) # 1016 <write>
     238:	b5ed                	j	122 <go+0xaa>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     23a:	3e700613          	li	a2,999
     23e:	00002597          	auipc	a1,0x2
     242:	de258593          	addi	a1,a1,-542 # 2020 <buf.0>
     246:	8552                	mv	a0,s4
     248:	00001097          	auipc	ra,0x1
     24c:	dc6080e7          	jalr	-570(ra) # 100e <read>
     250:	bdc9                	j	122 <go+0xaa>
    } else if(what == 9){
      mkdir("grindir/../a");
     252:	00001517          	auipc	a0,0x1
     256:	31e50513          	addi	a0,a0,798 # 1570 <malloc+0x130>
     25a:	00001097          	auipc	ra,0x1
     25e:	e04080e7          	jalr	-508(ra) # 105e <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     262:	20200593          	li	a1,514
     266:	00001517          	auipc	a0,0x1
     26a:	36250513          	addi	a0,a0,866 # 15c8 <malloc+0x188>
     26e:	00001097          	auipc	ra,0x1
     272:	dc8080e7          	jalr	-568(ra) # 1036 <open>
     276:	00001097          	auipc	ra,0x1
     27a:	da8080e7          	jalr	-600(ra) # 101e <close>
      unlink("a/a");
     27e:	00001517          	auipc	a0,0x1
     282:	35a50513          	addi	a0,a0,858 # 15d8 <malloc+0x198>
     286:	00001097          	auipc	ra,0x1
     28a:	dc0080e7          	jalr	-576(ra) # 1046 <unlink>
     28e:	bd51                	j	122 <go+0xaa>
    } else if(what == 10){
      mkdir("/../b");
     290:	00001517          	auipc	a0,0x1
     294:	35050513          	addi	a0,a0,848 # 15e0 <malloc+0x1a0>
     298:	00001097          	auipc	ra,0x1
     29c:	dc6080e7          	jalr	-570(ra) # 105e <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2a0:	20200593          	li	a1,514
     2a4:	00001517          	auipc	a0,0x1
     2a8:	34450513          	addi	a0,a0,836 # 15e8 <malloc+0x1a8>
     2ac:	00001097          	auipc	ra,0x1
     2b0:	d8a080e7          	jalr	-630(ra) # 1036 <open>
     2b4:	00001097          	auipc	ra,0x1
     2b8:	d6a080e7          	jalr	-662(ra) # 101e <close>
      unlink("b/b");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	33c50513          	addi	a0,a0,828 # 15f8 <malloc+0x1b8>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	d82080e7          	jalr	-638(ra) # 1046 <unlink>
     2cc:	bd99                	j	122 <go+0xaa>
    } else if(what == 11){
      unlink("b");
     2ce:	00001517          	auipc	a0,0x1
     2d2:	2f250513          	addi	a0,a0,754 # 15c0 <malloc+0x180>
     2d6:	00001097          	auipc	ra,0x1
     2da:	d70080e7          	jalr	-656(ra) # 1046 <unlink>
      link("../grindir/./../a", "../b");
     2de:	00001597          	auipc	a1,0x1
     2e2:	2ba58593          	addi	a1,a1,698 # 1598 <malloc+0x158>
     2e6:	00001517          	auipc	a0,0x1
     2ea:	31a50513          	addi	a0,a0,794 # 1600 <malloc+0x1c0>
     2ee:	00001097          	auipc	ra,0x1
     2f2:	d68080e7          	jalr	-664(ra) # 1056 <link>
     2f6:	b535                	j	122 <go+0xaa>
    } else if(what == 12){
      unlink("../grindir/../a");
     2f8:	00001517          	auipc	a0,0x1
     2fc:	32050513          	addi	a0,a0,800 # 1618 <malloc+0x1d8>
     300:	00001097          	auipc	ra,0x1
     304:	d46080e7          	jalr	-698(ra) # 1046 <unlink>
      link(".././b", "/grindir/../a");
     308:	00001597          	auipc	a1,0x1
     30c:	29858593          	addi	a1,a1,664 # 15a0 <malloc+0x160>
     310:	00001517          	auipc	a0,0x1
     314:	31850513          	addi	a0,a0,792 # 1628 <malloc+0x1e8>
     318:	00001097          	auipc	ra,0x1
     31c:	d3e080e7          	jalr	-706(ra) # 1056 <link>
     320:	b509                	j	122 <go+0xaa>
    } else if(what == 13){
      int pid = fork();
     322:	00001097          	auipc	ra,0x1
     326:	ccc080e7          	jalr	-820(ra) # fee <fork>
      if(pid == 0){
     32a:	c909                	beqz	a0,33c <go+0x2c4>
        exit(0);
      } else if(pid < 0){
     32c:	00054c63          	bltz	a0,344 <go+0x2cc>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     330:	4501                	li	a0,0
     332:	00001097          	auipc	ra,0x1
     336:	ccc080e7          	jalr	-820(ra) # ffe <wait>
     33a:	b3e5                	j	122 <go+0xaa>
        exit(0);
     33c:	00001097          	auipc	ra,0x1
     340:	cba080e7          	jalr	-838(ra) # ff6 <exit>
        printf("grind: fork failed\n");
     344:	00001517          	auipc	a0,0x1
     348:	2ec50513          	addi	a0,a0,748 # 1630 <malloc+0x1f0>
     34c:	00001097          	auipc	ra,0x1
     350:	03c080e7          	jalr	60(ra) # 1388 <printf>
        exit(1);
     354:	4505                	li	a0,1
     356:	00001097          	auipc	ra,0x1
     35a:	ca0080e7          	jalr	-864(ra) # ff6 <exit>
    } else if(what == 14){
      int pid = fork();
     35e:	00001097          	auipc	ra,0x1
     362:	c90080e7          	jalr	-880(ra) # fee <fork>
      if(pid == 0){
     366:	c909                	beqz	a0,378 <go+0x300>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     368:	02054563          	bltz	a0,392 <go+0x31a>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     36c:	4501                	li	a0,0
     36e:	00001097          	auipc	ra,0x1
     372:	c90080e7          	jalr	-880(ra) # ffe <wait>
     376:	b375                	j	122 <go+0xaa>
        fork();
     378:	00001097          	auipc	ra,0x1
     37c:	c76080e7          	jalr	-906(ra) # fee <fork>
        fork();
     380:	00001097          	auipc	ra,0x1
     384:	c6e080e7          	jalr	-914(ra) # fee <fork>
        exit(0);
     388:	4501                	li	a0,0
     38a:	00001097          	auipc	ra,0x1
     38e:	c6c080e7          	jalr	-916(ra) # ff6 <exit>
        printf("grind: fork failed\n");
     392:	00001517          	auipc	a0,0x1
     396:	29e50513          	addi	a0,a0,670 # 1630 <malloc+0x1f0>
     39a:	00001097          	auipc	ra,0x1
     39e:	fee080e7          	jalr	-18(ra) # 1388 <printf>
        exit(1);
     3a2:	4505                	li	a0,1
     3a4:	00001097          	auipc	ra,0x1
     3a8:	c52080e7          	jalr	-942(ra) # ff6 <exit>
    } else if(what == 15){
      sbrk(6011);
     3ac:	6505                	lui	a0,0x1
     3ae:	77b50513          	addi	a0,a0,1915 # 177b <malloc+0x33b>
     3b2:	00001097          	auipc	ra,0x1
     3b6:	ccc080e7          	jalr	-820(ra) # 107e <sbrk>
     3ba:	b3a5                	j	122 <go+0xaa>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3bc:	4501                	li	a0,0
     3be:	00001097          	auipc	ra,0x1
     3c2:	cc0080e7          	jalr	-832(ra) # 107e <sbrk>
     3c6:	d4aafee3          	bgeu	s5,a0,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     3ca:	4501                	li	a0,0
     3cc:	00001097          	auipc	ra,0x1
     3d0:	cb2080e7          	jalr	-846(ra) # 107e <sbrk>
     3d4:	40aa853b          	subw	a0,s5,a0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	ca6080e7          	jalr	-858(ra) # 107e <sbrk>
     3e0:	b389                	j	122 <go+0xaa>
    } else if(what == 17){
      int pid = fork();
     3e2:	00001097          	auipc	ra,0x1
     3e6:	c0c080e7          	jalr	-1012(ra) # fee <fork>
     3ea:	8b2a                	mv	s6,a0
      if(pid == 0){
     3ec:	c51d                	beqz	a0,41a <go+0x3a2>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3ee:	04054963          	bltz	a0,440 <go+0x3c8>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3f2:	00001517          	auipc	a0,0x1
     3f6:	25650513          	addi	a0,a0,598 # 1648 <malloc+0x208>
     3fa:	00001097          	auipc	ra,0x1
     3fe:	c6c080e7          	jalr	-916(ra) # 1066 <chdir>
     402:	ed21                	bnez	a0,45a <go+0x3e2>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     404:	855a                	mv	a0,s6
     406:	00001097          	auipc	ra,0x1
     40a:	c20080e7          	jalr	-992(ra) # 1026 <kill>
      wait(0);
     40e:	4501                	li	a0,0
     410:	00001097          	auipc	ra,0x1
     414:	bee080e7          	jalr	-1042(ra) # ffe <wait>
     418:	b329                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     41a:	20200593          	li	a1,514
     41e:	00001517          	auipc	a0,0x1
     422:	1f250513          	addi	a0,a0,498 # 1610 <malloc+0x1d0>
     426:	00001097          	auipc	ra,0x1
     42a:	c10080e7          	jalr	-1008(ra) # 1036 <open>
     42e:	00001097          	auipc	ra,0x1
     432:	bf0080e7          	jalr	-1040(ra) # 101e <close>
        exit(0);
     436:	4501                	li	a0,0
     438:	00001097          	auipc	ra,0x1
     43c:	bbe080e7          	jalr	-1090(ra) # ff6 <exit>
        printf("grind: fork failed\n");
     440:	00001517          	auipc	a0,0x1
     444:	1f050513          	addi	a0,a0,496 # 1630 <malloc+0x1f0>
     448:	00001097          	auipc	ra,0x1
     44c:	f40080e7          	jalr	-192(ra) # 1388 <printf>
        exit(1);
     450:	4505                	li	a0,1
     452:	00001097          	auipc	ra,0x1
     456:	ba4080e7          	jalr	-1116(ra) # ff6 <exit>
        printf("grind: chdir failed\n");
     45a:	00001517          	auipc	a0,0x1
     45e:	1fe50513          	addi	a0,a0,510 # 1658 <malloc+0x218>
     462:	00001097          	auipc	ra,0x1
     466:	f26080e7          	jalr	-218(ra) # 1388 <printf>
        exit(1);
     46a:	4505                	li	a0,1
     46c:	00001097          	auipc	ra,0x1
     470:	b8a080e7          	jalr	-1142(ra) # ff6 <exit>
    } else if(what == 18){
      int pid = fork();
     474:	00001097          	auipc	ra,0x1
     478:	b7a080e7          	jalr	-1158(ra) # fee <fork>
      if(pid == 0){
     47c:	c909                	beqz	a0,48e <go+0x416>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     47e:	02054563          	bltz	a0,4a8 <go+0x430>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     482:	4501                	li	a0,0
     484:	00001097          	auipc	ra,0x1
     488:	b7a080e7          	jalr	-1158(ra) # ffe <wait>
     48c:	b959                	j	122 <go+0xaa>
        kill(getpid());
     48e:	00001097          	auipc	ra,0x1
     492:	be8080e7          	jalr	-1048(ra) # 1076 <getpid>
     496:	00001097          	auipc	ra,0x1
     49a:	b90080e7          	jalr	-1136(ra) # 1026 <kill>
        exit(0);
     49e:	4501                	li	a0,0
     4a0:	00001097          	auipc	ra,0x1
     4a4:	b56080e7          	jalr	-1194(ra) # ff6 <exit>
        printf("grind: fork failed\n");
     4a8:	00001517          	auipc	a0,0x1
     4ac:	18850513          	addi	a0,a0,392 # 1630 <malloc+0x1f0>
     4b0:	00001097          	auipc	ra,0x1
     4b4:	ed8080e7          	jalr	-296(ra) # 1388 <printf>
        exit(1);
     4b8:	4505                	li	a0,1
     4ba:	00001097          	auipc	ra,0x1
     4be:	b3c080e7          	jalr	-1220(ra) # ff6 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4c2:	fa840513          	addi	a0,s0,-88
     4c6:	00001097          	auipc	ra,0x1
     4ca:	b40080e7          	jalr	-1216(ra) # 1006 <pipe>
     4ce:	02054b63          	bltz	a0,504 <go+0x48c>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4d2:	00001097          	auipc	ra,0x1
     4d6:	b1c080e7          	jalr	-1252(ra) # fee <fork>
      if(pid == 0){
     4da:	c131                	beqz	a0,51e <go+0x4a6>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4dc:	0a054a63          	bltz	a0,590 <go+0x518>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4e0:	fa842503          	lw	a0,-88(s0)
     4e4:	00001097          	auipc	ra,0x1
     4e8:	b3a080e7          	jalr	-1222(ra) # 101e <close>
      close(fds[1]);
     4ec:	fac42503          	lw	a0,-84(s0)
     4f0:	00001097          	auipc	ra,0x1
     4f4:	b2e080e7          	jalr	-1234(ra) # 101e <close>
      wait(0);
     4f8:	4501                	li	a0,0
     4fa:	00001097          	auipc	ra,0x1
     4fe:	b04080e7          	jalr	-1276(ra) # ffe <wait>
     502:	b105                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     504:	00001517          	auipc	a0,0x1
     508:	16c50513          	addi	a0,a0,364 # 1670 <malloc+0x230>
     50c:	00001097          	auipc	ra,0x1
     510:	e7c080e7          	jalr	-388(ra) # 1388 <printf>
        exit(1);
     514:	4505                	li	a0,1
     516:	00001097          	auipc	ra,0x1
     51a:	ae0080e7          	jalr	-1312(ra) # ff6 <exit>
        fork();
     51e:	00001097          	auipc	ra,0x1
     522:	ad0080e7          	jalr	-1328(ra) # fee <fork>
        fork();
     526:	00001097          	auipc	ra,0x1
     52a:	ac8080e7          	jalr	-1336(ra) # fee <fork>
        if(write(fds[1], "x", 1) != 1)
     52e:	4605                	li	a2,1
     530:	00001597          	auipc	a1,0x1
     534:	15858593          	addi	a1,a1,344 # 1688 <malloc+0x248>
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00001097          	auipc	ra,0x1
     540:	ada080e7          	jalr	-1318(ra) # 1016 <write>
     544:	4785                	li	a5,1
     546:	02f51363          	bne	a0,a5,56c <go+0x4f4>
        if(read(fds[0], &c, 1) != 1)
     54a:	4605                	li	a2,1
     54c:	fa040593          	addi	a1,s0,-96
     550:	fa842503          	lw	a0,-88(s0)
     554:	00001097          	auipc	ra,0x1
     558:	aba080e7          	jalr	-1350(ra) # 100e <read>
     55c:	4785                	li	a5,1
     55e:	02f51063          	bne	a0,a5,57e <go+0x506>
        exit(0);
     562:	4501                	li	a0,0
     564:	00001097          	auipc	ra,0x1
     568:	a92080e7          	jalr	-1390(ra) # ff6 <exit>
          printf("grind: pipe write failed\n");
     56c:	00001517          	auipc	a0,0x1
     570:	12450513          	addi	a0,a0,292 # 1690 <malloc+0x250>
     574:	00001097          	auipc	ra,0x1
     578:	e14080e7          	jalr	-492(ra) # 1388 <printf>
     57c:	b7f9                	j	54a <go+0x4d2>
          printf("grind: pipe read failed\n");
     57e:	00001517          	auipc	a0,0x1
     582:	13250513          	addi	a0,a0,306 # 16b0 <malloc+0x270>
     586:	00001097          	auipc	ra,0x1
     58a:	e02080e7          	jalr	-510(ra) # 1388 <printf>
     58e:	bfd1                	j	562 <go+0x4ea>
        printf("grind: fork failed\n");
     590:	00001517          	auipc	a0,0x1
     594:	0a050513          	addi	a0,a0,160 # 1630 <malloc+0x1f0>
     598:	00001097          	auipc	ra,0x1
     59c:	df0080e7          	jalr	-528(ra) # 1388 <printf>
        exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00001097          	auipc	ra,0x1
     5a6:	a54080e7          	jalr	-1452(ra) # ff6 <exit>
    } else if(what == 20){
      int pid = fork();
     5aa:	00001097          	auipc	ra,0x1
     5ae:	a44080e7          	jalr	-1468(ra) # fee <fork>
      if(pid == 0){
     5b2:	c909                	beqz	a0,5c4 <go+0x54c>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5b4:	06054f63          	bltz	a0,632 <go+0x5ba>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5b8:	4501                	li	a0,0
     5ba:	00001097          	auipc	ra,0x1
     5be:	a44080e7          	jalr	-1468(ra) # ffe <wait>
     5c2:	b685                	j	122 <go+0xaa>
        unlink("a");
     5c4:	00001517          	auipc	a0,0x1
     5c8:	04c50513          	addi	a0,a0,76 # 1610 <malloc+0x1d0>
     5cc:	00001097          	auipc	ra,0x1
     5d0:	a7a080e7          	jalr	-1414(ra) # 1046 <unlink>
        mkdir("a");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	03c50513          	addi	a0,a0,60 # 1610 <malloc+0x1d0>
     5dc:	00001097          	auipc	ra,0x1
     5e0:	a82080e7          	jalr	-1406(ra) # 105e <mkdir>
        chdir("a");
     5e4:	00001517          	auipc	a0,0x1
     5e8:	02c50513          	addi	a0,a0,44 # 1610 <malloc+0x1d0>
     5ec:	00001097          	auipc	ra,0x1
     5f0:	a7a080e7          	jalr	-1414(ra) # 1066 <chdir>
        unlink("../a");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	f8450513          	addi	a0,a0,-124 # 1578 <malloc+0x138>
     5fc:	00001097          	auipc	ra,0x1
     600:	a4a080e7          	jalr	-1462(ra) # 1046 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     604:	20200593          	li	a1,514
     608:	00001517          	auipc	a0,0x1
     60c:	08050513          	addi	a0,a0,128 # 1688 <malloc+0x248>
     610:	00001097          	auipc	ra,0x1
     614:	a26080e7          	jalr	-1498(ra) # 1036 <open>
        unlink("x");
     618:	00001517          	auipc	a0,0x1
     61c:	07050513          	addi	a0,a0,112 # 1688 <malloc+0x248>
     620:	00001097          	auipc	ra,0x1
     624:	a26080e7          	jalr	-1498(ra) # 1046 <unlink>
        exit(0);
     628:	4501                	li	a0,0
     62a:	00001097          	auipc	ra,0x1
     62e:	9cc080e7          	jalr	-1588(ra) # ff6 <exit>
        printf("grind: fork failed\n");
     632:	00001517          	auipc	a0,0x1
     636:	ffe50513          	addi	a0,a0,-2 # 1630 <malloc+0x1f0>
     63a:	00001097          	auipc	ra,0x1
     63e:	d4e080e7          	jalr	-690(ra) # 1388 <printf>
        exit(1);
     642:	4505                	li	a0,1
     644:	00001097          	auipc	ra,0x1
     648:	9b2080e7          	jalr	-1614(ra) # ff6 <exit>
    } else if(what == 21){
      unlink("c");
     64c:	00001517          	auipc	a0,0x1
     650:	08450513          	addi	a0,a0,132 # 16d0 <malloc+0x290>
     654:	00001097          	auipc	ra,0x1
     658:	9f2080e7          	jalr	-1550(ra) # 1046 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     65c:	20200593          	li	a1,514
     660:	00001517          	auipc	a0,0x1
     664:	07050513          	addi	a0,a0,112 # 16d0 <malloc+0x290>
     668:	00001097          	auipc	ra,0x1
     66c:	9ce080e7          	jalr	-1586(ra) # 1036 <open>
     670:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     672:	04054f63          	bltz	a0,6d0 <go+0x658>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     676:	4605                	li	a2,1
     678:	00001597          	auipc	a1,0x1
     67c:	01058593          	addi	a1,a1,16 # 1688 <malloc+0x248>
     680:	00001097          	auipc	ra,0x1
     684:	996080e7          	jalr	-1642(ra) # 1016 <write>
     688:	4785                	li	a5,1
     68a:	06f51063          	bne	a0,a5,6ea <go+0x672>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     68e:	fa840593          	addi	a1,s0,-88
     692:	855a                	mv	a0,s6
     694:	00001097          	auipc	ra,0x1
     698:	9ba080e7          	jalr	-1606(ra) # 104e <fstat>
     69c:	e525                	bnez	a0,704 <go+0x68c>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     69e:	fb843583          	ld	a1,-72(s0)
     6a2:	4785                	li	a5,1
     6a4:	06f59d63          	bne	a1,a5,71e <go+0x6a6>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6a8:	fac42583          	lw	a1,-84(s0)
     6ac:	0c800793          	li	a5,200
     6b0:	08b7e563          	bltu	a5,a1,73a <go+0x6c2>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6b4:	855a                	mv	a0,s6
     6b6:	00001097          	auipc	ra,0x1
     6ba:	968080e7          	jalr	-1688(ra) # 101e <close>
      unlink("c");
     6be:	00001517          	auipc	a0,0x1
     6c2:	01250513          	addi	a0,a0,18 # 16d0 <malloc+0x290>
     6c6:	00001097          	auipc	ra,0x1
     6ca:	980080e7          	jalr	-1664(ra) # 1046 <unlink>
     6ce:	bc91                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	00850513          	addi	a0,a0,8 # 16d8 <malloc+0x298>
     6d8:	00001097          	auipc	ra,0x1
     6dc:	cb0080e7          	jalr	-848(ra) # 1388 <printf>
        exit(1);
     6e0:	4505                	li	a0,1
     6e2:	00001097          	auipc	ra,0x1
     6e6:	914080e7          	jalr	-1772(ra) # ff6 <exit>
        printf("grind: write c failed\n");
     6ea:	00001517          	auipc	a0,0x1
     6ee:	00650513          	addi	a0,a0,6 # 16f0 <malloc+0x2b0>
     6f2:	00001097          	auipc	ra,0x1
     6f6:	c96080e7          	jalr	-874(ra) # 1388 <printf>
        exit(1);
     6fa:	4505                	li	a0,1
     6fc:	00001097          	auipc	ra,0x1
     700:	8fa080e7          	jalr	-1798(ra) # ff6 <exit>
        printf("grind: fstat failed\n");
     704:	00001517          	auipc	a0,0x1
     708:	00450513          	addi	a0,a0,4 # 1708 <malloc+0x2c8>
     70c:	00001097          	auipc	ra,0x1
     710:	c7c080e7          	jalr	-900(ra) # 1388 <printf>
        exit(1);
     714:	4505                	li	a0,1
     716:	00001097          	auipc	ra,0x1
     71a:	8e0080e7          	jalr	-1824(ra) # ff6 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     71e:	2581                	sext.w	a1,a1
     720:	00001517          	auipc	a0,0x1
     724:	00050513          	mv	a0,a0
     728:	00001097          	auipc	ra,0x1
     72c:	c60080e7          	jalr	-928(ra) # 1388 <printf>
        exit(1);
     730:	4505                	li	a0,1
     732:	00001097          	auipc	ra,0x1
     736:	8c4080e7          	jalr	-1852(ra) # ff6 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     73a:	00001517          	auipc	a0,0x1
     73e:	00e50513          	addi	a0,a0,14 # 1748 <malloc+0x308>
     742:	00001097          	auipc	ra,0x1
     746:	c46080e7          	jalr	-954(ra) # 1388 <printf>
        exit(1);
     74a:	4505                	li	a0,1
     74c:	00001097          	auipc	ra,0x1
     750:	8aa080e7          	jalr	-1878(ra) # ff6 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     754:	f9840513          	addi	a0,s0,-104
     758:	00001097          	auipc	ra,0x1
     75c:	8ae080e7          	jalr	-1874(ra) # 1006 <pipe>
     760:	10054063          	bltz	a0,860 <go+0x7e8>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     764:	fa040513          	addi	a0,s0,-96
     768:	00001097          	auipc	ra,0x1
     76c:	89e080e7          	jalr	-1890(ra) # 1006 <pipe>
     770:	10054663          	bltz	a0,87c <go+0x804>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     774:	00001097          	auipc	ra,0x1
     778:	87a080e7          	jalr	-1926(ra) # fee <fork>
      if(pid1 == 0){
     77c:	10050e63          	beqz	a0,898 <go+0x820>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     780:	1c054663          	bltz	a0,94c <go+0x8d4>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     784:	00001097          	auipc	ra,0x1
     788:	86a080e7          	jalr	-1942(ra) # fee <fork>
      if(pid2 == 0){
     78c:	1c050e63          	beqz	a0,968 <go+0x8f0>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     790:	2a054a63          	bltz	a0,a44 <go+0x9cc>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     794:	f9842503          	lw	a0,-104(s0)
     798:	00001097          	auipc	ra,0x1
     79c:	886080e7          	jalr	-1914(ra) # 101e <close>
      close(aa[1]);
     7a0:	f9c42503          	lw	a0,-100(s0)
     7a4:	00001097          	auipc	ra,0x1
     7a8:	87a080e7          	jalr	-1926(ra) # 101e <close>
      close(bb[1]);
     7ac:	fa442503          	lw	a0,-92(s0)
     7b0:	00001097          	auipc	ra,0x1
     7b4:	86e080e7          	jalr	-1938(ra) # 101e <close>
      char buf[4] = { 0, 0, 0, 0 };
     7b8:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     7bc:	4605                	li	a2,1
     7be:	f9040593          	addi	a1,s0,-112
     7c2:	fa042503          	lw	a0,-96(s0)
     7c6:	00001097          	auipc	ra,0x1
     7ca:	848080e7          	jalr	-1976(ra) # 100e <read>
      read(bb[0], buf+1, 1);
     7ce:	4605                	li	a2,1
     7d0:	f9140593          	addi	a1,s0,-111
     7d4:	fa042503          	lw	a0,-96(s0)
     7d8:	00001097          	auipc	ra,0x1
     7dc:	836080e7          	jalr	-1994(ra) # 100e <read>
      read(bb[0], buf+2, 1);
     7e0:	4605                	li	a2,1
     7e2:	f9240593          	addi	a1,s0,-110
     7e6:	fa042503          	lw	a0,-96(s0)
     7ea:	00001097          	auipc	ra,0x1
     7ee:	824080e7          	jalr	-2012(ra) # 100e <read>
      close(bb[0]);
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00001097          	auipc	ra,0x1
     7fa:	828080e7          	jalr	-2008(ra) # 101e <close>
      int st1, st2;
      wait(&st1);
     7fe:	f9440513          	addi	a0,s0,-108
     802:	00000097          	auipc	ra,0x0
     806:	7fc080e7          	jalr	2044(ra) # ffe <wait>
      wait(&st2);
     80a:	fa840513          	addi	a0,s0,-88
     80e:	00000097          	auipc	ra,0x0
     812:	7f0080e7          	jalr	2032(ra) # ffe <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     816:	f9442783          	lw	a5,-108(s0)
     81a:	fa842703          	lw	a4,-88(s0)
     81e:	8fd9                	or	a5,a5,a4
     820:	ef89                	bnez	a5,83a <go+0x7c2>
     822:	00001597          	auipc	a1,0x1
     826:	fc658593          	addi	a1,a1,-58 # 17e8 <malloc+0x3a8>
     82a:	f9040513          	addi	a0,s0,-112
     82e:	00000097          	auipc	ra,0x0
     832:	578080e7          	jalr	1400(ra) # da6 <strcmp>
     836:	8e0506e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     83a:	f9040693          	addi	a3,s0,-112
     83e:	fa842603          	lw	a2,-88(s0)
     842:	f9442583          	lw	a1,-108(s0)
     846:	00001517          	auipc	a0,0x1
     84a:	faa50513          	addi	a0,a0,-86 # 17f0 <malloc+0x3b0>
     84e:	00001097          	auipc	ra,0x1
     852:	b3a080e7          	jalr	-1222(ra) # 1388 <printf>
        exit(1);
     856:	4505                	li	a0,1
     858:	00000097          	auipc	ra,0x0
     85c:	79e080e7          	jalr	1950(ra) # ff6 <exit>
        fprintf(2, "grind: pipe failed\n");
     860:	00001597          	auipc	a1,0x1
     864:	e1058593          	addi	a1,a1,-496 # 1670 <malloc+0x230>
     868:	4509                	li	a0,2
     86a:	00001097          	auipc	ra,0x1
     86e:	af0080e7          	jalr	-1296(ra) # 135a <fprintf>
        exit(1);
     872:	4505                	li	a0,1
     874:	00000097          	auipc	ra,0x0
     878:	782080e7          	jalr	1922(ra) # ff6 <exit>
        fprintf(2, "grind: pipe failed\n");
     87c:	00001597          	auipc	a1,0x1
     880:	df458593          	addi	a1,a1,-524 # 1670 <malloc+0x230>
     884:	4509                	li	a0,2
     886:	00001097          	auipc	ra,0x1
     88a:	ad4080e7          	jalr	-1324(ra) # 135a <fprintf>
        exit(1);
     88e:	4505                	li	a0,1
     890:	00000097          	auipc	ra,0x0
     894:	766080e7          	jalr	1894(ra) # ff6 <exit>
        close(bb[0]);
     898:	fa042503          	lw	a0,-96(s0)
     89c:	00000097          	auipc	ra,0x0
     8a0:	782080e7          	jalr	1922(ra) # 101e <close>
        close(bb[1]);
     8a4:	fa442503          	lw	a0,-92(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	776080e7          	jalr	1910(ra) # 101e <close>
        close(aa[0]);
     8b0:	f9842503          	lw	a0,-104(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	76a080e7          	jalr	1898(ra) # 101e <close>
        close(1);
     8bc:	4505                	li	a0,1
     8be:	00000097          	auipc	ra,0x0
     8c2:	760080e7          	jalr	1888(ra) # 101e <close>
        if(dup(aa[1]) != 1){
     8c6:	f9c42503          	lw	a0,-100(s0)
     8ca:	00000097          	auipc	ra,0x0
     8ce:	7a4080e7          	jalr	1956(ra) # 106e <dup>
     8d2:	4785                	li	a5,1
     8d4:	02f50063          	beq	a0,a5,8f4 <go+0x87c>
          fprintf(2, "grind: dup failed\n");
     8d8:	00001597          	auipc	a1,0x1
     8dc:	e9858593          	addi	a1,a1,-360 # 1770 <malloc+0x330>
     8e0:	4509                	li	a0,2
     8e2:	00001097          	auipc	ra,0x1
     8e6:	a78080e7          	jalr	-1416(ra) # 135a <fprintf>
          exit(1);
     8ea:	4505                	li	a0,1
     8ec:	00000097          	auipc	ra,0x0
     8f0:	70a080e7          	jalr	1802(ra) # ff6 <exit>
        close(aa[1]);
     8f4:	f9c42503          	lw	a0,-100(s0)
     8f8:	00000097          	auipc	ra,0x0
     8fc:	726080e7          	jalr	1830(ra) # 101e <close>
        char *args[3] = { "echo", "hi", 0 };
     900:	00001797          	auipc	a5,0x1
     904:	e8878793          	addi	a5,a5,-376 # 1788 <malloc+0x348>
     908:	faf43423          	sd	a5,-88(s0)
     90c:	00001797          	auipc	a5,0x1
     910:	e8478793          	addi	a5,a5,-380 # 1790 <malloc+0x350>
     914:	faf43823          	sd	a5,-80(s0)
     918:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     91c:	fa840593          	addi	a1,s0,-88
     920:	00001517          	auipc	a0,0x1
     924:	e7850513          	addi	a0,a0,-392 # 1798 <malloc+0x358>
     928:	00000097          	auipc	ra,0x0
     92c:	706080e7          	jalr	1798(ra) # 102e <exec>
        fprintf(2, "grind: echo: not found\n");
     930:	00001597          	auipc	a1,0x1
     934:	e7858593          	addi	a1,a1,-392 # 17a8 <malloc+0x368>
     938:	4509                	li	a0,2
     93a:	00001097          	auipc	ra,0x1
     93e:	a20080e7          	jalr	-1504(ra) # 135a <fprintf>
        exit(2);
     942:	4509                	li	a0,2
     944:	00000097          	auipc	ra,0x0
     948:	6b2080e7          	jalr	1714(ra) # ff6 <exit>
        fprintf(2, "grind: fork failed\n");
     94c:	00001597          	auipc	a1,0x1
     950:	ce458593          	addi	a1,a1,-796 # 1630 <malloc+0x1f0>
     954:	4509                	li	a0,2
     956:	00001097          	auipc	ra,0x1
     95a:	a04080e7          	jalr	-1532(ra) # 135a <fprintf>
        exit(3);
     95e:	450d                	li	a0,3
     960:	00000097          	auipc	ra,0x0
     964:	696080e7          	jalr	1686(ra) # ff6 <exit>
        close(aa[1]);
     968:	f9c42503          	lw	a0,-100(s0)
     96c:	00000097          	auipc	ra,0x0
     970:	6b2080e7          	jalr	1714(ra) # 101e <close>
        close(bb[0]);
     974:	fa042503          	lw	a0,-96(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	6a6080e7          	jalr	1702(ra) # 101e <close>
        close(0);
     980:	4501                	li	a0,0
     982:	00000097          	auipc	ra,0x0
     986:	69c080e7          	jalr	1692(ra) # 101e <close>
        if(dup(aa[0]) != 0){
     98a:	f9842503          	lw	a0,-104(s0)
     98e:	00000097          	auipc	ra,0x0
     992:	6e0080e7          	jalr	1760(ra) # 106e <dup>
     996:	cd19                	beqz	a0,9b4 <go+0x93c>
          fprintf(2, "grind: dup failed\n");
     998:	00001597          	auipc	a1,0x1
     99c:	dd858593          	addi	a1,a1,-552 # 1770 <malloc+0x330>
     9a0:	4509                	li	a0,2
     9a2:	00001097          	auipc	ra,0x1
     9a6:	9b8080e7          	jalr	-1608(ra) # 135a <fprintf>
          exit(4);
     9aa:	4511                	li	a0,4
     9ac:	00000097          	auipc	ra,0x0
     9b0:	64a080e7          	jalr	1610(ra) # ff6 <exit>
        close(aa[0]);
     9b4:	f9842503          	lw	a0,-104(s0)
     9b8:	00000097          	auipc	ra,0x0
     9bc:	666080e7          	jalr	1638(ra) # 101e <close>
        close(1);
     9c0:	4505                	li	a0,1
     9c2:	00000097          	auipc	ra,0x0
     9c6:	65c080e7          	jalr	1628(ra) # 101e <close>
        if(dup(bb[1]) != 1){
     9ca:	fa442503          	lw	a0,-92(s0)
     9ce:	00000097          	auipc	ra,0x0
     9d2:	6a0080e7          	jalr	1696(ra) # 106e <dup>
     9d6:	4785                	li	a5,1
     9d8:	02f50063          	beq	a0,a5,9f8 <go+0x980>
          fprintf(2, "grind: dup failed\n");
     9dc:	00001597          	auipc	a1,0x1
     9e0:	d9458593          	addi	a1,a1,-620 # 1770 <malloc+0x330>
     9e4:	4509                	li	a0,2
     9e6:	00001097          	auipc	ra,0x1
     9ea:	974080e7          	jalr	-1676(ra) # 135a <fprintf>
          exit(5);
     9ee:	4515                	li	a0,5
     9f0:	00000097          	auipc	ra,0x0
     9f4:	606080e7          	jalr	1542(ra) # ff6 <exit>
        close(bb[1]);
     9f8:	fa442503          	lw	a0,-92(s0)
     9fc:	00000097          	auipc	ra,0x0
     a00:	622080e7          	jalr	1570(ra) # 101e <close>
        char *args[2] = { "cat", 0 };
     a04:	00001797          	auipc	a5,0x1
     a08:	dbc78793          	addi	a5,a5,-580 # 17c0 <malloc+0x380>
     a0c:	faf43423          	sd	a5,-88(s0)
     a10:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a14:	fa840593          	addi	a1,s0,-88
     a18:	00001517          	auipc	a0,0x1
     a1c:	db050513          	addi	a0,a0,-592 # 17c8 <malloc+0x388>
     a20:	00000097          	auipc	ra,0x0
     a24:	60e080e7          	jalr	1550(ra) # 102e <exec>
        fprintf(2, "grind: cat: not found\n");
     a28:	00001597          	auipc	a1,0x1
     a2c:	da858593          	addi	a1,a1,-600 # 17d0 <malloc+0x390>
     a30:	4509                	li	a0,2
     a32:	00001097          	auipc	ra,0x1
     a36:	928080e7          	jalr	-1752(ra) # 135a <fprintf>
        exit(6);
     a3a:	4519                	li	a0,6
     a3c:	00000097          	auipc	ra,0x0
     a40:	5ba080e7          	jalr	1466(ra) # ff6 <exit>
        fprintf(2, "grind: fork failed\n");
     a44:	00001597          	auipc	a1,0x1
     a48:	bec58593          	addi	a1,a1,-1044 # 1630 <malloc+0x1f0>
     a4c:	4509                	li	a0,2
     a4e:	00001097          	auipc	ra,0x1
     a52:	90c080e7          	jalr	-1780(ra) # 135a <fprintf>
        exit(7);
     a56:	451d                	li	a0,7
     a58:	00000097          	auipc	ra,0x0
     a5c:	59e080e7          	jalr	1438(ra) # ff6 <exit>

0000000000000a60 <iter>:
  }
}

void
iter()
{
     a60:	7179                	addi	sp,sp,-48
     a62:	f406                	sd	ra,40(sp)
     a64:	f022                	sd	s0,32(sp)
     a66:	ec26                	sd	s1,24(sp)
     a68:	e84a                	sd	s2,16(sp)
     a6a:	1800                	addi	s0,sp,48
  unlink("a");
     a6c:	00001517          	auipc	a0,0x1
     a70:	ba450513          	addi	a0,a0,-1116 # 1610 <malloc+0x1d0>
     a74:	00000097          	auipc	ra,0x0
     a78:	5d2080e7          	jalr	1490(ra) # 1046 <unlink>
  unlink("b");
     a7c:	00001517          	auipc	a0,0x1
     a80:	b4450513          	addi	a0,a0,-1212 # 15c0 <malloc+0x180>
     a84:	00000097          	auipc	ra,0x0
     a88:	5c2080e7          	jalr	1474(ra) # 1046 <unlink>
  
  int pid1 = fork();
     a8c:	00000097          	auipc	ra,0x0
     a90:	562080e7          	jalr	1378(ra) # fee <fork>
  if(pid1 < 0){
     a94:	02054163          	bltz	a0,ab6 <iter+0x56>
     a98:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     a9a:	e91d                	bnez	a0,ad0 <iter+0x70>
    rand_next ^= 31;
     a9c:	00001717          	auipc	a4,0x1
     aa0:	56470713          	addi	a4,a4,1380 # 2000 <rand_next>
     aa4:	631c                	ld	a5,0(a4)
     aa6:	01f7c793          	xori	a5,a5,31
     aaa:	e31c                	sd	a5,0(a4)
    go(0);
     aac:	4501                	li	a0,0
     aae:	fffff097          	auipc	ra,0xfffff
     ab2:	5ca080e7          	jalr	1482(ra) # 78 <go>
    printf("grind: fork failed\n");
     ab6:	00001517          	auipc	a0,0x1
     aba:	b7a50513          	addi	a0,a0,-1158 # 1630 <malloc+0x1f0>
     abe:	00001097          	auipc	ra,0x1
     ac2:	8ca080e7          	jalr	-1846(ra) # 1388 <printf>
    exit(1);
     ac6:	4505                	li	a0,1
     ac8:	00000097          	auipc	ra,0x0
     acc:	52e080e7          	jalr	1326(ra) # ff6 <exit>
    exit(0);
  }

  int pid2 = fork();
     ad0:	00000097          	auipc	ra,0x0
     ad4:	51e080e7          	jalr	1310(ra) # fee <fork>
     ad8:	892a                	mv	s2,a0
  if(pid2 < 0){
     ada:	02054263          	bltz	a0,afe <iter+0x9e>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     ade:	ed0d                	bnez	a0,b18 <iter+0xb8>
    rand_next ^= 7177;
     ae0:	00001697          	auipc	a3,0x1
     ae4:	52068693          	addi	a3,a3,1312 # 2000 <rand_next>
     ae8:	629c                	ld	a5,0(a3)
     aea:	6709                	lui	a4,0x2
     aec:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x2e1>
     af0:	8fb9                	xor	a5,a5,a4
     af2:	e29c                	sd	a5,0(a3)
    go(1);
     af4:	4505                	li	a0,1
     af6:	fffff097          	auipc	ra,0xfffff
     afa:	582080e7          	jalr	1410(ra) # 78 <go>
    printf("grind: fork failed\n");
     afe:	00001517          	auipc	a0,0x1
     b02:	b3250513          	addi	a0,a0,-1230 # 1630 <malloc+0x1f0>
     b06:	00001097          	auipc	ra,0x1
     b0a:	882080e7          	jalr	-1918(ra) # 1388 <printf>
    exit(1);
     b0e:	4505                	li	a0,1
     b10:	00000097          	auipc	ra,0x0
     b14:	4e6080e7          	jalr	1254(ra) # ff6 <exit>
    exit(0);
  }

  int st1 = -1;
     b18:	57fd                	li	a5,-1
     b1a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b1e:	fdc40513          	addi	a0,s0,-36
     b22:	00000097          	auipc	ra,0x0
     b26:	4dc080e7          	jalr	1244(ra) # ffe <wait>
  if(st1 != 0){
     b2a:	fdc42783          	lw	a5,-36(s0)
     b2e:	ef99                	bnez	a5,b4c <iter+0xec>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b30:	57fd                	li	a5,-1
     b32:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b36:	fd840513          	addi	a0,s0,-40
     b3a:	00000097          	auipc	ra,0x0
     b3e:	4c4080e7          	jalr	1220(ra) # ffe <wait>

  exit(0);
     b42:	4501                	li	a0,0
     b44:	00000097          	auipc	ra,0x0
     b48:	4b2080e7          	jalr	1202(ra) # ff6 <exit>
    kill(pid1);
     b4c:	8526                	mv	a0,s1
     b4e:	00000097          	auipc	ra,0x0
     b52:	4d8080e7          	jalr	1240(ra) # 1026 <kill>
    kill(pid2);
     b56:	854a                	mv	a0,s2
     b58:	00000097          	auipc	ra,0x0
     b5c:	4ce080e7          	jalr	1230(ra) # 1026 <kill>
     b60:	bfc1                	j	b30 <iter+0xd0>

0000000000000b62 <main>:
}

int
main()
{
     b62:	1101                	addi	sp,sp,-32
     b64:	ec06                	sd	ra,24(sp)
     b66:	e822                	sd	s0,16(sp)
     b68:	e426                	sd	s1,8(sp)
     b6a:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     b6c:	00001497          	auipc	s1,0x1
     b70:	49448493          	addi	s1,s1,1172 # 2000 <rand_next>
     b74:	a829                	j	b8e <main+0x2c>
      iter();
     b76:	00000097          	auipc	ra,0x0
     b7a:	eea080e7          	jalr	-278(ra) # a60 <iter>
    sleep(20);
     b7e:	4551                	li	a0,20
     b80:	00000097          	auipc	ra,0x0
     b84:	506080e7          	jalr	1286(ra) # 1086 <sleep>
    rand_next += 1;
     b88:	609c                	ld	a5,0(s1)
     b8a:	0785                	addi	a5,a5,1
     b8c:	e09c                	sd	a5,0(s1)
    int pid = fork();
     b8e:	00000097          	auipc	ra,0x0
     b92:	460080e7          	jalr	1120(ra) # fee <fork>
    if(pid == 0){
     b96:	d165                	beqz	a0,b76 <main+0x14>
    if(pid > 0){
     b98:	fea053e3          	blez	a0,b7e <main+0x1c>
      wait(0);
     b9c:	4501                	li	a0,0
     b9e:	00000097          	auipc	ra,0x0
     ba2:	460080e7          	jalr	1120(ra) # ffe <wait>
     ba6:	bfe1                	j	b7e <main+0x1c>

0000000000000ba8 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     ba8:	1141                	addi	sp,sp,-16
     baa:	e422                	sd	s0,8(sp)
     bac:	0800                	addi	s0,sp,16
    lk->name = name;
     bae:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     bb0:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     bb4:	57fd                	li	a5,-1
     bb6:	00f50823          	sb	a5,16(a0)
}
     bba:	6422                	ld	s0,8(sp)
     bbc:	0141                	addi	sp,sp,16
     bbe:	8082                	ret

0000000000000bc0 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     bc0:	00054783          	lbu	a5,0(a0)
     bc4:	e399                	bnez	a5,bca <holding+0xa>
     bc6:	4501                	li	a0,0
}
     bc8:	8082                	ret
{
     bca:	1101                	addi	sp,sp,-32
     bcc:	ec06                	sd	ra,24(sp)
     bce:	e822                	sd	s0,16(sp)
     bd0:	e426                	sd	s1,8(sp)
     bd2:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     bd4:	01054483          	lbu	s1,16(a0)
     bd8:	00000097          	auipc	ra,0x0
     bdc:	122080e7          	jalr	290(ra) # cfa <twhoami>
     be0:	2501                	sext.w	a0,a0
     be2:	40a48533          	sub	a0,s1,a0
     be6:	00153513          	seqz	a0,a0
}
     bea:	60e2                	ld	ra,24(sp)
     bec:	6442                	ld	s0,16(sp)
     bee:	64a2                	ld	s1,8(sp)
     bf0:	6105                	addi	sp,sp,32
     bf2:	8082                	ret

0000000000000bf4 <acquire>:

void acquire(struct lock *lk)
{
     bf4:	7179                	addi	sp,sp,-48
     bf6:	f406                	sd	ra,40(sp)
     bf8:	f022                	sd	s0,32(sp)
     bfa:	ec26                	sd	s1,24(sp)
     bfc:	e84a                	sd	s2,16(sp)
     bfe:	e44e                	sd	s3,8(sp)
     c00:	e052                	sd	s4,0(sp)
     c02:	1800                	addi	s0,sp,48
     c04:	8a2a                	mv	s4,a0
    if (holding(lk))
     c06:	00000097          	auipc	ra,0x0
     c0a:	fba080e7          	jalr	-70(ra) # bc0 <holding>
     c0e:	e919                	bnez	a0,c24 <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     c10:	ffca7493          	andi	s1,s4,-4
     c14:	003a7913          	andi	s2,s4,3
     c18:	0039191b          	slliw	s2,s2,0x3
     c1c:	4985                	li	s3,1
     c1e:	012999bb          	sllw	s3,s3,s2
     c22:	a015                	j	c46 <acquire+0x52>
        printf("re-acquiring lock we already hold");
     c24:	00001517          	auipc	a0,0x1
     c28:	c5450513          	addi	a0,a0,-940 # 1878 <malloc+0x438>
     c2c:	00000097          	auipc	ra,0x0
     c30:	75c080e7          	jalr	1884(ra) # 1388 <printf>
        exit(-1);
     c34:	557d                	li	a0,-1
     c36:	00000097          	auipc	ra,0x0
     c3a:	3c0080e7          	jalr	960(ra) # ff6 <exit>
    {
        // give up the cpu for other threads
        tyield();
     c3e:	00000097          	auipc	ra,0x0
     c42:	0b0080e7          	jalr	176(ra) # cee <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     c46:	4534a7af          	amoor.w.aq	a5,s3,(s1)
     c4a:	0127d7bb          	srlw	a5,a5,s2
     c4e:	0ff7f793          	zext.b	a5,a5
     c52:	f7f5                	bnez	a5,c3e <acquire+0x4a>
    }

    __sync_synchronize();
     c54:	0ff0000f          	fence

    lk->tid = twhoami();
     c58:	00000097          	auipc	ra,0x0
     c5c:	0a2080e7          	jalr	162(ra) # cfa <twhoami>
     c60:	00aa0823          	sb	a0,16(s4)
}
     c64:	70a2                	ld	ra,40(sp)
     c66:	7402                	ld	s0,32(sp)
     c68:	64e2                	ld	s1,24(sp)
     c6a:	6942                	ld	s2,16(sp)
     c6c:	69a2                	ld	s3,8(sp)
     c6e:	6a02                	ld	s4,0(sp)
     c70:	6145                	addi	sp,sp,48
     c72:	8082                	ret

0000000000000c74 <release>:

void release(struct lock *lk)
{
     c74:	1101                	addi	sp,sp,-32
     c76:	ec06                	sd	ra,24(sp)
     c78:	e822                	sd	s0,16(sp)
     c7a:	e426                	sd	s1,8(sp)
     c7c:	1000                	addi	s0,sp,32
     c7e:	84aa                	mv	s1,a0
    if (!holding(lk))
     c80:	00000097          	auipc	ra,0x0
     c84:	f40080e7          	jalr	-192(ra) # bc0 <holding>
     c88:	c11d                	beqz	a0,cae <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     c8a:	57fd                	li	a5,-1
     c8c:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     c90:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
     c94:	0ff0000f          	fence
     c98:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     c9c:	00000097          	auipc	ra,0x0
     ca0:	052080e7          	jalr	82(ra) # cee <tyield>
}
     ca4:	60e2                	ld	ra,24(sp)
     ca6:	6442                	ld	s0,16(sp)
     ca8:	64a2                	ld	s1,8(sp)
     caa:	6105                	addi	sp,sp,32
     cac:	8082                	ret
        printf("releasing lock we are not holding");
     cae:	00001517          	auipc	a0,0x1
     cb2:	bf250513          	addi	a0,a0,-1038 # 18a0 <malloc+0x460>
     cb6:	00000097          	auipc	ra,0x0
     cba:	6d2080e7          	jalr	1746(ra) # 1388 <printf>
        exit(-1);
     cbe:	557d                	li	a0,-1
     cc0:	00000097          	auipc	ra,0x0
     cc4:	336080e7          	jalr	822(ra) # ff6 <exit>

0000000000000cc8 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
     cc8:	1141                	addi	sp,sp,-16
     cca:	e422                	sd	s0,8(sp)
     ccc:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
     cce:	6422                	ld	s0,8(sp)
     cd0:	0141                	addi	sp,sp,16
     cd2:	8082                	ret

0000000000000cd4 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     cd4:	1141                	addi	sp,sp,-16
     cd6:	e422                	sd	s0,8(sp)
     cd8:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
     cda:	6422                	ld	s0,8(sp)
     cdc:	0141                	addi	sp,sp,16
     cde:	8082                	ret

0000000000000ce0 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     ce0:	1141                	addi	sp,sp,-16
     ce2:	e422                	sd	s0,8(sp)
     ce4:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
     ce6:	4501                	li	a0,0
     ce8:	6422                	ld	s0,8(sp)
     cea:	0141                	addi	sp,sp,16
     cec:	8082                	ret

0000000000000cee <tyield>:

void tyield()
{
     cee:	1141                	addi	sp,sp,-16
     cf0:	e422                	sd	s0,8(sp)
     cf2:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
     cf4:	6422                	ld	s0,8(sp)
     cf6:	0141                	addi	sp,sp,16
     cf8:	8082                	ret

0000000000000cfa <twhoami>:

uint8 twhoami()
{
     cfa:	1141                	addi	sp,sp,-16
     cfc:	e422                	sd	s0,8(sp)
     cfe:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
     d00:	4501                	li	a0,0
     d02:	6422                	ld	s0,8(sp)
     d04:	0141                	addi	sp,sp,16
     d06:	8082                	ret

0000000000000d08 <tswtch>:
     d08:	00153023          	sd	ra,0(a0)
     d0c:	00253423          	sd	sp,8(a0)
     d10:	e900                	sd	s0,16(a0)
     d12:	ed04                	sd	s1,24(a0)
     d14:	03253023          	sd	s2,32(a0)
     d18:	03353423          	sd	s3,40(a0)
     d1c:	03453823          	sd	s4,48(a0)
     d20:	03553c23          	sd	s5,56(a0)
     d24:	05653023          	sd	s6,64(a0)
     d28:	05753423          	sd	s7,72(a0)
     d2c:	05853823          	sd	s8,80(a0)
     d30:	05953c23          	sd	s9,88(a0)
     d34:	07a53023          	sd	s10,96(a0)
     d38:	07b53423          	sd	s11,104(a0)
     d3c:	0005b083          	ld	ra,0(a1)
     d40:	0085b103          	ld	sp,8(a1)
     d44:	6980                	ld	s0,16(a1)
     d46:	6d84                	ld	s1,24(a1)
     d48:	0205b903          	ld	s2,32(a1)
     d4c:	0285b983          	ld	s3,40(a1)
     d50:	0305ba03          	ld	s4,48(a1)
     d54:	0385ba83          	ld	s5,56(a1)
     d58:	0405bb03          	ld	s6,64(a1)
     d5c:	0485bb83          	ld	s7,72(a1)
     d60:	0505bc03          	ld	s8,80(a1)
     d64:	0585bc83          	ld	s9,88(a1)
     d68:	0605bd03          	ld	s10,96(a1)
     d6c:	0685bd83          	ld	s11,104(a1)
     d70:	8082                	ret

0000000000000d72 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     d72:	1141                	addi	sp,sp,-16
     d74:	e406                	sd	ra,8(sp)
     d76:	e022                	sd	s0,0(sp)
     d78:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
     d7a:	00000097          	auipc	ra,0x0
     d7e:	de8080e7          	jalr	-536(ra) # b62 <main>
    exit(res);
     d82:	00000097          	auipc	ra,0x0
     d86:	274080e7          	jalr	628(ra) # ff6 <exit>

0000000000000d8a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     d8a:	1141                	addi	sp,sp,-16
     d8c:	e422                	sd	s0,8(sp)
     d8e:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     d90:	87aa                	mv	a5,a0
     d92:	0585                	addi	a1,a1,1
     d94:	0785                	addi	a5,a5,1
     d96:	fff5c703          	lbu	a4,-1(a1)
     d9a:	fee78fa3          	sb	a4,-1(a5)
     d9e:	fb75                	bnez	a4,d92 <strcpy+0x8>
        ;
    return os;
}
     da0:	6422                	ld	s0,8(sp)
     da2:	0141                	addi	sp,sp,16
     da4:	8082                	ret

0000000000000da6 <strcmp>:

int strcmp(const char *p, const char *q)
{
     da6:	1141                	addi	sp,sp,-16
     da8:	e422                	sd	s0,8(sp)
     daa:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     dac:	00054783          	lbu	a5,0(a0)
     db0:	cb91                	beqz	a5,dc4 <strcmp+0x1e>
     db2:	0005c703          	lbu	a4,0(a1)
     db6:	00f71763          	bne	a4,a5,dc4 <strcmp+0x1e>
        p++, q++;
     dba:	0505                	addi	a0,a0,1
     dbc:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     dbe:	00054783          	lbu	a5,0(a0)
     dc2:	fbe5                	bnez	a5,db2 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
     dc4:	0005c503          	lbu	a0,0(a1)
}
     dc8:	40a7853b          	subw	a0,a5,a0
     dcc:	6422                	ld	s0,8(sp)
     dce:	0141                	addi	sp,sp,16
     dd0:	8082                	ret

0000000000000dd2 <strlen>:

uint strlen(const char *s)
{
     dd2:	1141                	addi	sp,sp,-16
     dd4:	e422                	sd	s0,8(sp)
     dd6:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     dd8:	00054783          	lbu	a5,0(a0)
     ddc:	cf91                	beqz	a5,df8 <strlen+0x26>
     dde:	0505                	addi	a0,a0,1
     de0:	87aa                	mv	a5,a0
     de2:	4685                	li	a3,1
     de4:	9e89                	subw	a3,a3,a0
     de6:	00f6853b          	addw	a0,a3,a5
     dea:	0785                	addi	a5,a5,1
     dec:	fff7c703          	lbu	a4,-1(a5)
     df0:	fb7d                	bnez	a4,de6 <strlen+0x14>
        ;
    return n;
}
     df2:	6422                	ld	s0,8(sp)
     df4:	0141                	addi	sp,sp,16
     df6:	8082                	ret
    for (n = 0; s[n]; n++)
     df8:	4501                	li	a0,0
     dfa:	bfe5                	j	df2 <strlen+0x20>

0000000000000dfc <memset>:

void *
memset(void *dst, int c, uint n)
{
     dfc:	1141                	addi	sp,sp,-16
     dfe:	e422                	sd	s0,8(sp)
     e00:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     e02:	ca19                	beqz	a2,e18 <memset+0x1c>
     e04:	87aa                	mv	a5,a0
     e06:	1602                	slli	a2,a2,0x20
     e08:	9201                	srli	a2,a2,0x20
     e0a:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     e0e:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     e12:	0785                	addi	a5,a5,1
     e14:	fee79de3          	bne	a5,a4,e0e <memset+0x12>
    }
    return dst;
}
     e18:	6422                	ld	s0,8(sp)
     e1a:	0141                	addi	sp,sp,16
     e1c:	8082                	ret

0000000000000e1e <strchr>:

char *
strchr(const char *s, char c)
{
     e1e:	1141                	addi	sp,sp,-16
     e20:	e422                	sd	s0,8(sp)
     e22:	0800                	addi	s0,sp,16
    for (; *s; s++)
     e24:	00054783          	lbu	a5,0(a0)
     e28:	cb99                	beqz	a5,e3e <strchr+0x20>
        if (*s == c)
     e2a:	00f58763          	beq	a1,a5,e38 <strchr+0x1a>
    for (; *s; s++)
     e2e:	0505                	addi	a0,a0,1
     e30:	00054783          	lbu	a5,0(a0)
     e34:	fbfd                	bnez	a5,e2a <strchr+0xc>
            return (char *)s;
    return 0;
     e36:	4501                	li	a0,0
}
     e38:	6422                	ld	s0,8(sp)
     e3a:	0141                	addi	sp,sp,16
     e3c:	8082                	ret
    return 0;
     e3e:	4501                	li	a0,0
     e40:	bfe5                	j	e38 <strchr+0x1a>

0000000000000e42 <gets>:

char *
gets(char *buf, int max)
{
     e42:	711d                	addi	sp,sp,-96
     e44:	ec86                	sd	ra,88(sp)
     e46:	e8a2                	sd	s0,80(sp)
     e48:	e4a6                	sd	s1,72(sp)
     e4a:	e0ca                	sd	s2,64(sp)
     e4c:	fc4e                	sd	s3,56(sp)
     e4e:	f852                	sd	s4,48(sp)
     e50:	f456                	sd	s5,40(sp)
     e52:	f05a                	sd	s6,32(sp)
     e54:	ec5e                	sd	s7,24(sp)
     e56:	1080                	addi	s0,sp,96
     e58:	8baa                	mv	s7,a0
     e5a:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     e5c:	892a                	mv	s2,a0
     e5e:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
     e60:	4aa9                	li	s5,10
     e62:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
     e64:	89a6                	mv	s3,s1
     e66:	2485                	addiw	s1,s1,1
     e68:	0344d863          	bge	s1,s4,e98 <gets+0x56>
        cc = read(0, &c, 1);
     e6c:	4605                	li	a2,1
     e6e:	faf40593          	addi	a1,s0,-81
     e72:	4501                	li	a0,0
     e74:	00000097          	auipc	ra,0x0
     e78:	19a080e7          	jalr	410(ra) # 100e <read>
        if (cc < 1)
     e7c:	00a05e63          	blez	a0,e98 <gets+0x56>
        buf[i++] = c;
     e80:	faf44783          	lbu	a5,-81(s0)
     e84:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     e88:	01578763          	beq	a5,s5,e96 <gets+0x54>
     e8c:	0905                	addi	s2,s2,1
     e8e:	fd679be3          	bne	a5,s6,e64 <gets+0x22>
    for (i = 0; i + 1 < max;)
     e92:	89a6                	mv	s3,s1
     e94:	a011                	j	e98 <gets+0x56>
     e96:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
     e98:	99de                	add	s3,s3,s7
     e9a:	00098023          	sb	zero,0(s3)
    return buf;
}
     e9e:	855e                	mv	a0,s7
     ea0:	60e6                	ld	ra,88(sp)
     ea2:	6446                	ld	s0,80(sp)
     ea4:	64a6                	ld	s1,72(sp)
     ea6:	6906                	ld	s2,64(sp)
     ea8:	79e2                	ld	s3,56(sp)
     eaa:	7a42                	ld	s4,48(sp)
     eac:	7aa2                	ld	s5,40(sp)
     eae:	7b02                	ld	s6,32(sp)
     eb0:	6be2                	ld	s7,24(sp)
     eb2:	6125                	addi	sp,sp,96
     eb4:	8082                	ret

0000000000000eb6 <stat>:

int stat(const char *n, struct stat *st)
{
     eb6:	1101                	addi	sp,sp,-32
     eb8:	ec06                	sd	ra,24(sp)
     eba:	e822                	sd	s0,16(sp)
     ebc:	e426                	sd	s1,8(sp)
     ebe:	e04a                	sd	s2,0(sp)
     ec0:	1000                	addi	s0,sp,32
     ec2:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     ec4:	4581                	li	a1,0
     ec6:	00000097          	auipc	ra,0x0
     eca:	170080e7          	jalr	368(ra) # 1036 <open>
    if (fd < 0)
     ece:	02054563          	bltz	a0,ef8 <stat+0x42>
     ed2:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     ed4:	85ca                	mv	a1,s2
     ed6:	00000097          	auipc	ra,0x0
     eda:	178080e7          	jalr	376(ra) # 104e <fstat>
     ede:	892a                	mv	s2,a0
    close(fd);
     ee0:	8526                	mv	a0,s1
     ee2:	00000097          	auipc	ra,0x0
     ee6:	13c080e7          	jalr	316(ra) # 101e <close>
    return r;
}
     eea:	854a                	mv	a0,s2
     eec:	60e2                	ld	ra,24(sp)
     eee:	6442                	ld	s0,16(sp)
     ef0:	64a2                	ld	s1,8(sp)
     ef2:	6902                	ld	s2,0(sp)
     ef4:	6105                	addi	sp,sp,32
     ef6:	8082                	ret
        return -1;
     ef8:	597d                	li	s2,-1
     efa:	bfc5                	j	eea <stat+0x34>

0000000000000efc <atoi>:

int atoi(const char *s)
{
     efc:	1141                	addi	sp,sp,-16
     efe:	e422                	sd	s0,8(sp)
     f00:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     f02:	00054683          	lbu	a3,0(a0)
     f06:	fd06879b          	addiw	a5,a3,-48
     f0a:	0ff7f793          	zext.b	a5,a5
     f0e:	4625                	li	a2,9
     f10:	02f66863          	bltu	a2,a5,f40 <atoi+0x44>
     f14:	872a                	mv	a4,a0
    n = 0;
     f16:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     f18:	0705                	addi	a4,a4,1
     f1a:	0025179b          	slliw	a5,a0,0x2
     f1e:	9fa9                	addw	a5,a5,a0
     f20:	0017979b          	slliw	a5,a5,0x1
     f24:	9fb5                	addw	a5,a5,a3
     f26:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     f2a:	00074683          	lbu	a3,0(a4)
     f2e:	fd06879b          	addiw	a5,a3,-48
     f32:	0ff7f793          	zext.b	a5,a5
     f36:	fef671e3          	bgeu	a2,a5,f18 <atoi+0x1c>
    return n;
}
     f3a:	6422                	ld	s0,8(sp)
     f3c:	0141                	addi	sp,sp,16
     f3e:	8082                	ret
    n = 0;
     f40:	4501                	li	a0,0
     f42:	bfe5                	j	f3a <atoi+0x3e>

0000000000000f44 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     f44:	1141                	addi	sp,sp,-16
     f46:	e422                	sd	s0,8(sp)
     f48:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     f4a:	02b57463          	bgeu	a0,a1,f72 <memmove+0x2e>
    {
        while (n-- > 0)
     f4e:	00c05f63          	blez	a2,f6c <memmove+0x28>
     f52:	1602                	slli	a2,a2,0x20
     f54:	9201                	srli	a2,a2,0x20
     f56:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     f5a:	872a                	mv	a4,a0
            *dst++ = *src++;
     f5c:	0585                	addi	a1,a1,1
     f5e:	0705                	addi	a4,a4,1
     f60:	fff5c683          	lbu	a3,-1(a1)
     f64:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     f68:	fee79ae3          	bne	a5,a4,f5c <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     f6c:	6422                	ld	s0,8(sp)
     f6e:	0141                	addi	sp,sp,16
     f70:	8082                	ret
        dst += n;
     f72:	00c50733          	add	a4,a0,a2
        src += n;
     f76:	95b2                	add	a1,a1,a2
        while (n-- > 0)
     f78:	fec05ae3          	blez	a2,f6c <memmove+0x28>
     f7c:	fff6079b          	addiw	a5,a2,-1
     f80:	1782                	slli	a5,a5,0x20
     f82:	9381                	srli	a5,a5,0x20
     f84:	fff7c793          	not	a5,a5
     f88:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     f8a:	15fd                	addi	a1,a1,-1
     f8c:	177d                	addi	a4,a4,-1
     f8e:	0005c683          	lbu	a3,0(a1)
     f92:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     f96:	fee79ae3          	bne	a5,a4,f8a <memmove+0x46>
     f9a:	bfc9                	j	f6c <memmove+0x28>

0000000000000f9c <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     f9c:	1141                	addi	sp,sp,-16
     f9e:	e422                	sd	s0,8(sp)
     fa0:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     fa2:	ca05                	beqz	a2,fd2 <memcmp+0x36>
     fa4:	fff6069b          	addiw	a3,a2,-1
     fa8:	1682                	slli	a3,a3,0x20
     faa:	9281                	srli	a3,a3,0x20
     fac:	0685                	addi	a3,a3,1
     fae:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
     fb0:	00054783          	lbu	a5,0(a0)
     fb4:	0005c703          	lbu	a4,0(a1)
     fb8:	00e79863          	bne	a5,a4,fc8 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
     fbc:	0505                	addi	a0,a0,1
        p2++;
     fbe:	0585                	addi	a1,a1,1
    while (n-- > 0)
     fc0:	fed518e3          	bne	a0,a3,fb0 <memcmp+0x14>
    }
    return 0;
     fc4:	4501                	li	a0,0
     fc6:	a019                	j	fcc <memcmp+0x30>
            return *p1 - *p2;
     fc8:	40e7853b          	subw	a0,a5,a4
}
     fcc:	6422                	ld	s0,8(sp)
     fce:	0141                	addi	sp,sp,16
     fd0:	8082                	ret
    return 0;
     fd2:	4501                	li	a0,0
     fd4:	bfe5                	j	fcc <memcmp+0x30>

0000000000000fd6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     fd6:	1141                	addi	sp,sp,-16
     fd8:	e406                	sd	ra,8(sp)
     fda:	e022                	sd	s0,0(sp)
     fdc:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     fde:	00000097          	auipc	ra,0x0
     fe2:	f66080e7          	jalr	-154(ra) # f44 <memmove>
}
     fe6:	60a2                	ld	ra,8(sp)
     fe8:	6402                	ld	s0,0(sp)
     fea:	0141                	addi	sp,sp,16
     fec:	8082                	ret

0000000000000fee <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     fee:	4885                	li	a7,1
 ecall
     ff0:	00000073          	ecall
 ret
     ff4:	8082                	ret

0000000000000ff6 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ff6:	4889                	li	a7,2
 ecall
     ff8:	00000073          	ecall
 ret
     ffc:	8082                	ret

0000000000000ffe <wait>:
.global wait
wait:
 li a7, SYS_wait
     ffe:	488d                	li	a7,3
 ecall
    1000:	00000073          	ecall
 ret
    1004:	8082                	ret

0000000000001006 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1006:	4891                	li	a7,4
 ecall
    1008:	00000073          	ecall
 ret
    100c:	8082                	ret

000000000000100e <read>:
.global read
read:
 li a7, SYS_read
    100e:	4895                	li	a7,5
 ecall
    1010:	00000073          	ecall
 ret
    1014:	8082                	ret

0000000000001016 <write>:
.global write
write:
 li a7, SYS_write
    1016:	48c1                	li	a7,16
 ecall
    1018:	00000073          	ecall
 ret
    101c:	8082                	ret

000000000000101e <close>:
.global close
close:
 li a7, SYS_close
    101e:	48d5                	li	a7,21
 ecall
    1020:	00000073          	ecall
 ret
    1024:	8082                	ret

0000000000001026 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1026:	4899                	li	a7,6
 ecall
    1028:	00000073          	ecall
 ret
    102c:	8082                	ret

000000000000102e <exec>:
.global exec
exec:
 li a7, SYS_exec
    102e:	489d                	li	a7,7
 ecall
    1030:	00000073          	ecall
 ret
    1034:	8082                	ret

0000000000001036 <open>:
.global open
open:
 li a7, SYS_open
    1036:	48bd                	li	a7,15
 ecall
    1038:	00000073          	ecall
 ret
    103c:	8082                	ret

000000000000103e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    103e:	48c5                	li	a7,17
 ecall
    1040:	00000073          	ecall
 ret
    1044:	8082                	ret

0000000000001046 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1046:	48c9                	li	a7,18
 ecall
    1048:	00000073          	ecall
 ret
    104c:	8082                	ret

000000000000104e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    104e:	48a1                	li	a7,8
 ecall
    1050:	00000073          	ecall
 ret
    1054:	8082                	ret

0000000000001056 <link>:
.global link
link:
 li a7, SYS_link
    1056:	48cd                	li	a7,19
 ecall
    1058:	00000073          	ecall
 ret
    105c:	8082                	ret

000000000000105e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    105e:	48d1                	li	a7,20
 ecall
    1060:	00000073          	ecall
 ret
    1064:	8082                	ret

0000000000001066 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1066:	48a5                	li	a7,9
 ecall
    1068:	00000073          	ecall
 ret
    106c:	8082                	ret

000000000000106e <dup>:
.global dup
dup:
 li a7, SYS_dup
    106e:	48a9                	li	a7,10
 ecall
    1070:	00000073          	ecall
 ret
    1074:	8082                	ret

0000000000001076 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1076:	48ad                	li	a7,11
 ecall
    1078:	00000073          	ecall
 ret
    107c:	8082                	ret

000000000000107e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    107e:	48b1                	li	a7,12
 ecall
    1080:	00000073          	ecall
 ret
    1084:	8082                	ret

0000000000001086 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1086:	48b5                	li	a7,13
 ecall
    1088:	00000073          	ecall
 ret
    108c:	8082                	ret

000000000000108e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    108e:	48b9                	li	a7,14
 ecall
    1090:	00000073          	ecall
 ret
    1094:	8082                	ret

0000000000001096 <ps>:
.global ps
ps:
 li a7, SYS_ps
    1096:	48d9                	li	a7,22
 ecall
    1098:	00000073          	ecall
 ret
    109c:	8082                	ret

000000000000109e <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
    109e:	48dd                	li	a7,23
 ecall
    10a0:	00000073          	ecall
 ret
    10a4:	8082                	ret

00000000000010a6 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
    10a6:	48e1                	li	a7,24
 ecall
    10a8:	00000073          	ecall
 ret
    10ac:	8082                	ret

00000000000010ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    10ae:	1101                	addi	sp,sp,-32
    10b0:	ec06                	sd	ra,24(sp)
    10b2:	e822                	sd	s0,16(sp)
    10b4:	1000                	addi	s0,sp,32
    10b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    10ba:	4605                	li	a2,1
    10bc:	fef40593          	addi	a1,s0,-17
    10c0:	00000097          	auipc	ra,0x0
    10c4:	f56080e7          	jalr	-170(ra) # 1016 <write>
}
    10c8:	60e2                	ld	ra,24(sp)
    10ca:	6442                	ld	s0,16(sp)
    10cc:	6105                	addi	sp,sp,32
    10ce:	8082                	ret

00000000000010d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    10d0:	7139                	addi	sp,sp,-64
    10d2:	fc06                	sd	ra,56(sp)
    10d4:	f822                	sd	s0,48(sp)
    10d6:	f426                	sd	s1,40(sp)
    10d8:	f04a                	sd	s2,32(sp)
    10da:	ec4e                	sd	s3,24(sp)
    10dc:	0080                	addi	s0,sp,64
    10de:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    10e0:	c299                	beqz	a3,10e6 <printint+0x16>
    10e2:	0805c963          	bltz	a1,1174 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    10e6:	2581                	sext.w	a1,a1
  neg = 0;
    10e8:	4881                	li	a7,0
    10ea:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    10ee:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    10f0:	2601                	sext.w	a2,a2
    10f2:	00001517          	auipc	a0,0x1
    10f6:	83650513          	addi	a0,a0,-1994 # 1928 <digits>
    10fa:	883a                	mv	a6,a4
    10fc:	2705                	addiw	a4,a4,1
    10fe:	02c5f7bb          	remuw	a5,a1,a2
    1102:	1782                	slli	a5,a5,0x20
    1104:	9381                	srli	a5,a5,0x20
    1106:	97aa                	add	a5,a5,a0
    1108:	0007c783          	lbu	a5,0(a5)
    110c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1110:	0005879b          	sext.w	a5,a1
    1114:	02c5d5bb          	divuw	a1,a1,a2
    1118:	0685                	addi	a3,a3,1
    111a:	fec7f0e3          	bgeu	a5,a2,10fa <printint+0x2a>
  if(neg)
    111e:	00088c63          	beqz	a7,1136 <printint+0x66>
    buf[i++] = '-';
    1122:	fd070793          	addi	a5,a4,-48
    1126:	00878733          	add	a4,a5,s0
    112a:	02d00793          	li	a5,45
    112e:	fef70823          	sb	a5,-16(a4)
    1132:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1136:	02e05863          	blez	a4,1166 <printint+0x96>
    113a:	fc040793          	addi	a5,s0,-64
    113e:	00e78933          	add	s2,a5,a4
    1142:	fff78993          	addi	s3,a5,-1
    1146:	99ba                	add	s3,s3,a4
    1148:	377d                	addiw	a4,a4,-1
    114a:	1702                	slli	a4,a4,0x20
    114c:	9301                	srli	a4,a4,0x20
    114e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1152:	fff94583          	lbu	a1,-1(s2)
    1156:	8526                	mv	a0,s1
    1158:	00000097          	auipc	ra,0x0
    115c:	f56080e7          	jalr	-170(ra) # 10ae <putc>
  while(--i >= 0)
    1160:	197d                	addi	s2,s2,-1
    1162:	ff3918e3          	bne	s2,s3,1152 <printint+0x82>
}
    1166:	70e2                	ld	ra,56(sp)
    1168:	7442                	ld	s0,48(sp)
    116a:	74a2                	ld	s1,40(sp)
    116c:	7902                	ld	s2,32(sp)
    116e:	69e2                	ld	s3,24(sp)
    1170:	6121                	addi	sp,sp,64
    1172:	8082                	ret
    x = -xx;
    1174:	40b005bb          	negw	a1,a1
    neg = 1;
    1178:	4885                	li	a7,1
    x = -xx;
    117a:	bf85                	j	10ea <printint+0x1a>

000000000000117c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    117c:	7119                	addi	sp,sp,-128
    117e:	fc86                	sd	ra,120(sp)
    1180:	f8a2                	sd	s0,112(sp)
    1182:	f4a6                	sd	s1,104(sp)
    1184:	f0ca                	sd	s2,96(sp)
    1186:	ecce                	sd	s3,88(sp)
    1188:	e8d2                	sd	s4,80(sp)
    118a:	e4d6                	sd	s5,72(sp)
    118c:	e0da                	sd	s6,64(sp)
    118e:	fc5e                	sd	s7,56(sp)
    1190:	f862                	sd	s8,48(sp)
    1192:	f466                	sd	s9,40(sp)
    1194:	f06a                	sd	s10,32(sp)
    1196:	ec6e                	sd	s11,24(sp)
    1198:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    119a:	0005c903          	lbu	s2,0(a1)
    119e:	18090f63          	beqz	s2,133c <vprintf+0x1c0>
    11a2:	8aaa                	mv	s5,a0
    11a4:	8b32                	mv	s6,a2
    11a6:	00158493          	addi	s1,a1,1
  state = 0;
    11aa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    11ac:	02500a13          	li	s4,37
    11b0:	4c55                	li	s8,21
    11b2:	00000c97          	auipc	s9,0x0
    11b6:	71ec8c93          	addi	s9,s9,1822 # 18d0 <malloc+0x490>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    11ba:	02800d93          	li	s11,40
  putc(fd, 'x');
    11be:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11c0:	00000b97          	auipc	s7,0x0
    11c4:	768b8b93          	addi	s7,s7,1896 # 1928 <digits>
    11c8:	a839                	j	11e6 <vprintf+0x6a>
        putc(fd, c);
    11ca:	85ca                	mv	a1,s2
    11cc:	8556                	mv	a0,s5
    11ce:	00000097          	auipc	ra,0x0
    11d2:	ee0080e7          	jalr	-288(ra) # 10ae <putc>
    11d6:	a019                	j	11dc <vprintf+0x60>
    } else if(state == '%'){
    11d8:	01498d63          	beq	s3,s4,11f2 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    11dc:	0485                	addi	s1,s1,1
    11de:	fff4c903          	lbu	s2,-1(s1)
    11e2:	14090d63          	beqz	s2,133c <vprintf+0x1c0>
    if(state == 0){
    11e6:	fe0999e3          	bnez	s3,11d8 <vprintf+0x5c>
      if(c == '%'){
    11ea:	ff4910e3          	bne	s2,s4,11ca <vprintf+0x4e>
        state = '%';
    11ee:	89d2                	mv	s3,s4
    11f0:	b7f5                	j	11dc <vprintf+0x60>
      if(c == 'd'){
    11f2:	11490c63          	beq	s2,s4,130a <vprintf+0x18e>
    11f6:	f9d9079b          	addiw	a5,s2,-99
    11fa:	0ff7f793          	zext.b	a5,a5
    11fe:	10fc6e63          	bltu	s8,a5,131a <vprintf+0x19e>
    1202:	f9d9079b          	addiw	a5,s2,-99
    1206:	0ff7f713          	zext.b	a4,a5
    120a:	10ec6863          	bltu	s8,a4,131a <vprintf+0x19e>
    120e:	00271793          	slli	a5,a4,0x2
    1212:	97e6                	add	a5,a5,s9
    1214:	439c                	lw	a5,0(a5)
    1216:	97e6                	add	a5,a5,s9
    1218:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    121a:	008b0913          	addi	s2,s6,8
    121e:	4685                	li	a3,1
    1220:	4629                	li	a2,10
    1222:	000b2583          	lw	a1,0(s6)
    1226:	8556                	mv	a0,s5
    1228:	00000097          	auipc	ra,0x0
    122c:	ea8080e7          	jalr	-344(ra) # 10d0 <printint>
    1230:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1232:	4981                	li	s3,0
    1234:	b765                	j	11dc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1236:	008b0913          	addi	s2,s6,8
    123a:	4681                	li	a3,0
    123c:	4629                	li	a2,10
    123e:	000b2583          	lw	a1,0(s6)
    1242:	8556                	mv	a0,s5
    1244:	00000097          	auipc	ra,0x0
    1248:	e8c080e7          	jalr	-372(ra) # 10d0 <printint>
    124c:	8b4a                	mv	s6,s2
      state = 0;
    124e:	4981                	li	s3,0
    1250:	b771                	j	11dc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1252:	008b0913          	addi	s2,s6,8
    1256:	4681                	li	a3,0
    1258:	866a                	mv	a2,s10
    125a:	000b2583          	lw	a1,0(s6)
    125e:	8556                	mv	a0,s5
    1260:	00000097          	auipc	ra,0x0
    1264:	e70080e7          	jalr	-400(ra) # 10d0 <printint>
    1268:	8b4a                	mv	s6,s2
      state = 0;
    126a:	4981                	li	s3,0
    126c:	bf85                	j	11dc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    126e:	008b0793          	addi	a5,s6,8
    1272:	f8f43423          	sd	a5,-120(s0)
    1276:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    127a:	03000593          	li	a1,48
    127e:	8556                	mv	a0,s5
    1280:	00000097          	auipc	ra,0x0
    1284:	e2e080e7          	jalr	-466(ra) # 10ae <putc>
  putc(fd, 'x');
    1288:	07800593          	li	a1,120
    128c:	8556                	mv	a0,s5
    128e:	00000097          	auipc	ra,0x0
    1292:	e20080e7          	jalr	-480(ra) # 10ae <putc>
    1296:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1298:	03c9d793          	srli	a5,s3,0x3c
    129c:	97de                	add	a5,a5,s7
    129e:	0007c583          	lbu	a1,0(a5)
    12a2:	8556                	mv	a0,s5
    12a4:	00000097          	auipc	ra,0x0
    12a8:	e0a080e7          	jalr	-502(ra) # 10ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    12ac:	0992                	slli	s3,s3,0x4
    12ae:	397d                	addiw	s2,s2,-1
    12b0:	fe0914e3          	bnez	s2,1298 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    12b4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    12b8:	4981                	li	s3,0
    12ba:	b70d                	j	11dc <vprintf+0x60>
        s = va_arg(ap, char*);
    12bc:	008b0913          	addi	s2,s6,8
    12c0:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    12c4:	02098163          	beqz	s3,12e6 <vprintf+0x16a>
        while(*s != 0){
    12c8:	0009c583          	lbu	a1,0(s3)
    12cc:	c5ad                	beqz	a1,1336 <vprintf+0x1ba>
          putc(fd, *s);
    12ce:	8556                	mv	a0,s5
    12d0:	00000097          	auipc	ra,0x0
    12d4:	dde080e7          	jalr	-546(ra) # 10ae <putc>
          s++;
    12d8:	0985                	addi	s3,s3,1
        while(*s != 0){
    12da:	0009c583          	lbu	a1,0(s3)
    12de:	f9e5                	bnez	a1,12ce <vprintf+0x152>
        s = va_arg(ap, char*);
    12e0:	8b4a                	mv	s6,s2
      state = 0;
    12e2:	4981                	li	s3,0
    12e4:	bde5                	j	11dc <vprintf+0x60>
          s = "(null)";
    12e6:	00000997          	auipc	s3,0x0
    12ea:	5e298993          	addi	s3,s3,1506 # 18c8 <malloc+0x488>
        while(*s != 0){
    12ee:	85ee                	mv	a1,s11
    12f0:	bff9                	j	12ce <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    12f2:	008b0913          	addi	s2,s6,8
    12f6:	000b4583          	lbu	a1,0(s6)
    12fa:	8556                	mv	a0,s5
    12fc:	00000097          	auipc	ra,0x0
    1300:	db2080e7          	jalr	-590(ra) # 10ae <putc>
    1304:	8b4a                	mv	s6,s2
      state = 0;
    1306:	4981                	li	s3,0
    1308:	bdd1                	j	11dc <vprintf+0x60>
        putc(fd, c);
    130a:	85d2                	mv	a1,s4
    130c:	8556                	mv	a0,s5
    130e:	00000097          	auipc	ra,0x0
    1312:	da0080e7          	jalr	-608(ra) # 10ae <putc>
      state = 0;
    1316:	4981                	li	s3,0
    1318:	b5d1                	j	11dc <vprintf+0x60>
        putc(fd, '%');
    131a:	85d2                	mv	a1,s4
    131c:	8556                	mv	a0,s5
    131e:	00000097          	auipc	ra,0x0
    1322:	d90080e7          	jalr	-624(ra) # 10ae <putc>
        putc(fd, c);
    1326:	85ca                	mv	a1,s2
    1328:	8556                	mv	a0,s5
    132a:	00000097          	auipc	ra,0x0
    132e:	d84080e7          	jalr	-636(ra) # 10ae <putc>
      state = 0;
    1332:	4981                	li	s3,0
    1334:	b565                	j	11dc <vprintf+0x60>
        s = va_arg(ap, char*);
    1336:	8b4a                	mv	s6,s2
      state = 0;
    1338:	4981                	li	s3,0
    133a:	b54d                	j	11dc <vprintf+0x60>
    }
  }
}
    133c:	70e6                	ld	ra,120(sp)
    133e:	7446                	ld	s0,112(sp)
    1340:	74a6                	ld	s1,104(sp)
    1342:	7906                	ld	s2,96(sp)
    1344:	69e6                	ld	s3,88(sp)
    1346:	6a46                	ld	s4,80(sp)
    1348:	6aa6                	ld	s5,72(sp)
    134a:	6b06                	ld	s6,64(sp)
    134c:	7be2                	ld	s7,56(sp)
    134e:	7c42                	ld	s8,48(sp)
    1350:	7ca2                	ld	s9,40(sp)
    1352:	7d02                	ld	s10,32(sp)
    1354:	6de2                	ld	s11,24(sp)
    1356:	6109                	addi	sp,sp,128
    1358:	8082                	ret

000000000000135a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    135a:	715d                	addi	sp,sp,-80
    135c:	ec06                	sd	ra,24(sp)
    135e:	e822                	sd	s0,16(sp)
    1360:	1000                	addi	s0,sp,32
    1362:	e010                	sd	a2,0(s0)
    1364:	e414                	sd	a3,8(s0)
    1366:	e818                	sd	a4,16(s0)
    1368:	ec1c                	sd	a5,24(s0)
    136a:	03043023          	sd	a6,32(s0)
    136e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1372:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1376:	8622                	mv	a2,s0
    1378:	00000097          	auipc	ra,0x0
    137c:	e04080e7          	jalr	-508(ra) # 117c <vprintf>
}
    1380:	60e2                	ld	ra,24(sp)
    1382:	6442                	ld	s0,16(sp)
    1384:	6161                	addi	sp,sp,80
    1386:	8082                	ret

0000000000001388 <printf>:

void
printf(const char *fmt, ...)
{
    1388:	711d                	addi	sp,sp,-96
    138a:	ec06                	sd	ra,24(sp)
    138c:	e822                	sd	s0,16(sp)
    138e:	1000                	addi	s0,sp,32
    1390:	e40c                	sd	a1,8(s0)
    1392:	e810                	sd	a2,16(s0)
    1394:	ec14                	sd	a3,24(s0)
    1396:	f018                	sd	a4,32(s0)
    1398:	f41c                	sd	a5,40(s0)
    139a:	03043823          	sd	a6,48(s0)
    139e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    13a2:	00840613          	addi	a2,s0,8
    13a6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    13aa:	85aa                	mv	a1,a0
    13ac:	4505                	li	a0,1
    13ae:	00000097          	auipc	ra,0x0
    13b2:	dce080e7          	jalr	-562(ra) # 117c <vprintf>
}
    13b6:	60e2                	ld	ra,24(sp)
    13b8:	6442                	ld	s0,16(sp)
    13ba:	6125                	addi	sp,sp,96
    13bc:	8082                	ret

00000000000013be <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
    13be:	1141                	addi	sp,sp,-16
    13c0:	e422                	sd	s0,8(sp)
    13c2:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
    13c4:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    13c8:	00001797          	auipc	a5,0x1
    13cc:	c487b783          	ld	a5,-952(a5) # 2010 <freep>
    13d0:	a02d                	j	13fa <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
    13d2:	4618                	lw	a4,8(a2)
    13d4:	9f2d                	addw	a4,a4,a1
    13d6:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
    13da:	6398                	ld	a4,0(a5)
    13dc:	6310                	ld	a2,0(a4)
    13de:	a83d                	j	141c <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
    13e0:	ff852703          	lw	a4,-8(a0)
    13e4:	9f31                	addw	a4,a4,a2
    13e6:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
    13e8:	ff053683          	ld	a3,-16(a0)
    13ec:	a091                	j	1430 <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    13ee:	6398                	ld	a4,0(a5)
    13f0:	00e7e463          	bltu	a5,a4,13f8 <free+0x3a>
    13f4:	00e6ea63          	bltu	a3,a4,1408 <free+0x4a>
{
    13f8:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    13fa:	fed7fae3          	bgeu	a5,a3,13ee <free+0x30>
    13fe:	6398                	ld	a4,0(a5)
    1400:	00e6e463          	bltu	a3,a4,1408 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1404:	fee7eae3          	bltu	a5,a4,13f8 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
    1408:	ff852583          	lw	a1,-8(a0)
    140c:	6390                	ld	a2,0(a5)
    140e:	02059813          	slli	a6,a1,0x20
    1412:	01c85713          	srli	a4,a6,0x1c
    1416:	9736                	add	a4,a4,a3
    1418:	fae60de3          	beq	a2,a4,13d2 <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
    141c:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
    1420:	4790                	lw	a2,8(a5)
    1422:	02061593          	slli	a1,a2,0x20
    1426:	01c5d713          	srli	a4,a1,0x1c
    142a:	973e                	add	a4,a4,a5
    142c:	fae68ae3          	beq	a3,a4,13e0 <free+0x22>
        p->s.ptr = bp->s.ptr;
    1430:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
    1432:	00001717          	auipc	a4,0x1
    1436:	bcf73f23          	sd	a5,-1058(a4) # 2010 <freep>
}
    143a:	6422                	ld	s0,8(sp)
    143c:	0141                	addi	sp,sp,16
    143e:	8082                	ret

0000000000001440 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
    1440:	7139                	addi	sp,sp,-64
    1442:	fc06                	sd	ra,56(sp)
    1444:	f822                	sd	s0,48(sp)
    1446:	f426                	sd	s1,40(sp)
    1448:	f04a                	sd	s2,32(sp)
    144a:	ec4e                	sd	s3,24(sp)
    144c:	e852                	sd	s4,16(sp)
    144e:	e456                	sd	s5,8(sp)
    1450:	e05a                	sd	s6,0(sp)
    1452:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    1454:	02051493          	slli	s1,a0,0x20
    1458:	9081                	srli	s1,s1,0x20
    145a:	04bd                	addi	s1,s1,15
    145c:	8091                	srli	s1,s1,0x4
    145e:	0014899b          	addiw	s3,s1,1
    1462:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
    1464:	00001517          	auipc	a0,0x1
    1468:	bac53503          	ld	a0,-1108(a0) # 2010 <freep>
    146c:	c515                	beqz	a0,1498 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    146e:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    1470:	4798                	lw	a4,8(a5)
    1472:	02977f63          	bgeu	a4,s1,14b0 <malloc+0x70>
    1476:	8a4e                	mv	s4,s3
    1478:	0009871b          	sext.w	a4,s3
    147c:	6685                	lui	a3,0x1
    147e:	00d77363          	bgeu	a4,a3,1484 <malloc+0x44>
    1482:	6a05                	lui	s4,0x1
    1484:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    1488:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    148c:	00001917          	auipc	s2,0x1
    1490:	b8490913          	addi	s2,s2,-1148 # 2010 <freep>
    if (p == (char *)-1)
    1494:	5afd                	li	s5,-1
    1496:	a895                	j	150a <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
    1498:	00001797          	auipc	a5,0x1
    149c:	f7078793          	addi	a5,a5,-144 # 2408 <base>
    14a0:	00001717          	auipc	a4,0x1
    14a4:	b6f73823          	sd	a5,-1168(a4) # 2010 <freep>
    14a8:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    14aa:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    14ae:	b7e1                	j	1476 <malloc+0x36>
            if (p->s.size == nunits)
    14b0:	02e48c63          	beq	s1,a4,14e8 <malloc+0xa8>
                p->s.size -= nunits;
    14b4:	4137073b          	subw	a4,a4,s3
    14b8:	c798                	sw	a4,8(a5)
                p += p->s.size;
    14ba:	02071693          	slli	a3,a4,0x20
    14be:	01c6d713          	srli	a4,a3,0x1c
    14c2:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    14c4:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    14c8:	00001717          	auipc	a4,0x1
    14cc:	b4a73423          	sd	a0,-1208(a4) # 2010 <freep>
            return (void *)(p + 1);
    14d0:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
    14d4:	70e2                	ld	ra,56(sp)
    14d6:	7442                	ld	s0,48(sp)
    14d8:	74a2                	ld	s1,40(sp)
    14da:	7902                	ld	s2,32(sp)
    14dc:	69e2                	ld	s3,24(sp)
    14de:	6a42                	ld	s4,16(sp)
    14e0:	6aa2                	ld	s5,8(sp)
    14e2:	6b02                	ld	s6,0(sp)
    14e4:	6121                	addi	sp,sp,64
    14e6:	8082                	ret
                prevp->s.ptr = p->s.ptr;
    14e8:	6398                	ld	a4,0(a5)
    14ea:	e118                	sd	a4,0(a0)
    14ec:	bff1                	j	14c8 <malloc+0x88>
    hp->s.size = nu;
    14ee:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    14f2:	0541                	addi	a0,a0,16
    14f4:	00000097          	auipc	ra,0x0
    14f8:	eca080e7          	jalr	-310(ra) # 13be <free>
    return freep;
    14fc:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
    1500:	d971                	beqz	a0,14d4 <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1502:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    1504:	4798                	lw	a4,8(a5)
    1506:	fa9775e3          	bgeu	a4,s1,14b0 <malloc+0x70>
        if (p == freep)
    150a:	00093703          	ld	a4,0(s2)
    150e:	853e                	mv	a0,a5
    1510:	fef719e3          	bne	a4,a5,1502 <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
    1514:	8552                	mv	a0,s4
    1516:	00000097          	auipc	ra,0x0
    151a:	b68080e7          	jalr	-1176(ra) # 107e <sbrk>
    if (p == (char *)-1)
    151e:	fd5518e3          	bne	a0,s5,14ee <malloc+0xae>
                return 0;
    1522:	4501                	li	a0,0
    1524:	bf45                	j	14d4 <malloc+0x94>
