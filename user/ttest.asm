
user/_ttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_hello_world>:
    release(&shared_state_lock);
    return 0;
}

void *print_hello_world(void *arg)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
    printf("Hello World\n");
       8:	00001517          	auipc	a0,0x1
       c:	08850513          	addi	a0,a0,136 # 1090 <__FUNCTION__.4+0x10>
      10:	00001097          	auipc	ra,0x1
      14:	eb2080e7          	jalr	-334(ra) # ec2 <printf>
    return 0;
}
      18:	4501                	li	a0,0
      1a:	60a2                	ld	ra,8(sp)
      1c:	6402                	ld	s0,0(sp)
      1e:	0141                	addi	sp,sp,16
      20:	8082                	ret

0000000000000022 <print_hello_world_with_tid>:

void *print_hello_world_with_tid(void *arg)
{
      22:	1141                	addi	sp,sp,-16
      24:	e406                	sd	ra,8(sp)
      26:	e022                	sd	s0,0(sp)
      28:	0800                	addi	s0,sp,16
    printf("Hello World from Thread %d\n", twhoami());
      2a:	00001097          	auipc	ra,0x1
      2e:	80a080e7          	jalr	-2038(ra) # 834 <twhoami>
      32:	0005059b          	sext.w	a1,a0
      36:	00001517          	auipc	a0,0x1
      3a:	06a50513          	addi	a0,a0,106 # 10a0 <__FUNCTION__.4+0x20>
      3e:	00001097          	auipc	ra,0x1
      42:	e84080e7          	jalr	-380(ra) # ec2 <printf>
    return 0;
}
      46:	4501                	li	a0,0
      48:	60a2                	ld	ra,8(sp)
      4a:	6402                	ld	s0,0(sp)
      4c:	0141                	addi	sp,sp,16
      4e:	8082                	ret

0000000000000050 <race_for_state>:
{
      50:	7179                	addi	sp,sp,-48
      52:	f406                	sd	ra,40(sp)
      54:	f022                	sd	s0,32(sp)
      56:	ec26                	sd	s1,24(sp)
      58:	e84a                	sd	s2,16(sp)
      5a:	e44e                	sd	s3,8(sp)
      5c:	e052                	sd	s4,0(sp)
      5e:	1800                	addi	s0,sp,48
    struct arg args = *(struct arg *)arg;
      60:	00052a03          	lw	s4,0(a0)
      64:	00452983          	lw	s3,4(a0)
    printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
      68:	00000097          	auipc	ra,0x0
      6c:	7cc080e7          	jalr	1996(ra) # 834 <twhoami>
      70:	00002497          	auipc	s1,0x2
      74:	f9048493          	addi	s1,s1,-112 # 2000 <shared_state>
      78:	4094                	lw	a3,0(s1)
      7a:	0005061b          	sext.w	a2,a0
      7e:	00001597          	auipc	a1,0x1
      82:	15a58593          	addi	a1,a1,346 # 11d8 <__FUNCTION__.6>
      86:	00001517          	auipc	a0,0x1
      8a:	03a50513          	addi	a0,a0,58 # 10c0 <__FUNCTION__.4+0x40>
      8e:	00001097          	auipc	ra,0x1
      92:	e34080e7          	jalr	-460(ra) # ec2 <printf>
    if (shared_state == 0)
      96:	409c                	lw	a5,0(s1)
      98:	ebb5                	bnez	a5,10c <race_for_state+0xbc>
        tyield();
      9a:	00000097          	auipc	ra,0x0
      9e:	78e080e7          	jalr	1934(ra) # 828 <tyield>
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
      a2:	00000097          	auipc	ra,0x0
      a6:	792080e7          	jalr	1938(ra) # 834 <twhoami>
      aa:	00001917          	auipc	s2,0x1
      ae:	12e90913          	addi	s2,s2,302 # 11d8 <__FUNCTION__.6>
      b2:	4094                	lw	a3,0(s1)
      b4:	0005061b          	sext.w	a2,a0
      b8:	85ca                	mv	a1,s2
      ba:	00001517          	auipc	a0,0x1
      be:	00650513          	addi	a0,a0,6 # 10c0 <__FUNCTION__.4+0x40>
      c2:	00001097          	auipc	ra,0x1
      c6:	e00080e7          	jalr	-512(ra) # ec2 <printf>
        shared_state += args.a;
      ca:	409c                	lw	a5,0(s1)
      cc:	014787bb          	addw	a5,a5,s4
      d0:	c09c                	sw	a5,0(s1)
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
      d2:	00000097          	auipc	ra,0x0
      d6:	762080e7          	jalr	1890(ra) # 834 <twhoami>
      da:	4094                	lw	a3,0(s1)
      dc:	0005061b          	sext.w	a2,a0
      e0:	85ca                	mv	a1,s2
      e2:	00001517          	auipc	a0,0x1
      e6:	fde50513          	addi	a0,a0,-34 # 10c0 <__FUNCTION__.4+0x40>
      ea:	00001097          	auipc	ra,0x1
      ee:	dd8080e7          	jalr	-552(ra) # ec2 <printf>
        tyield();
      f2:	00000097          	auipc	ra,0x0
      f6:	736080e7          	jalr	1846(ra) # 828 <tyield>
}
      fa:	4501                	li	a0,0
      fc:	70a2                	ld	ra,40(sp)
      fe:	7402                	ld	s0,32(sp)
     100:	64e2                	ld	s1,24(sp)
     102:	6942                	ld	s2,16(sp)
     104:	69a2                	ld	s3,8(sp)
     106:	6a02                	ld	s4,0(sp)
     108:	6145                	addi	sp,sp,48
     10a:	8082                	ret
        tyield();
     10c:	00000097          	auipc	ra,0x0
     110:	71c080e7          	jalr	1820(ra) # 828 <tyield>
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     114:	00000097          	auipc	ra,0x0
     118:	720080e7          	jalr	1824(ra) # 834 <twhoami>
     11c:	00002497          	auipc	s1,0x2
     120:	ee448493          	addi	s1,s1,-284 # 2000 <shared_state>
     124:	00001917          	auipc	s2,0x1
     128:	0b490913          	addi	s2,s2,180 # 11d8 <__FUNCTION__.6>
     12c:	4094                	lw	a3,0(s1)
     12e:	0005061b          	sext.w	a2,a0
     132:	85ca                	mv	a1,s2
     134:	00001517          	auipc	a0,0x1
     138:	f8c50513          	addi	a0,a0,-116 # 10c0 <__FUNCTION__.4+0x40>
     13c:	00001097          	auipc	ra,0x1
     140:	d86080e7          	jalr	-634(ra) # ec2 <printf>
        shared_state += args.b;
     144:	409c                	lw	a5,0(s1)
     146:	013787bb          	addw	a5,a5,s3
     14a:	c09c                	sw	a5,0(s1)
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     14c:	00000097          	auipc	ra,0x0
     150:	6e8080e7          	jalr	1768(ra) # 834 <twhoami>
     154:	4094                	lw	a3,0(s1)
     156:	0005061b          	sext.w	a2,a0
     15a:	85ca                	mv	a1,s2
     15c:	00001517          	auipc	a0,0x1
     160:	f6450513          	addi	a0,a0,-156 # 10c0 <__FUNCTION__.4+0x40>
     164:	00001097          	auipc	ra,0x1
     168:	d5e080e7          	jalr	-674(ra) # ec2 <printf>
        tyield();
     16c:	00000097          	auipc	ra,0x0
     170:	6bc080e7          	jalr	1724(ra) # 828 <tyield>
     174:	b759                	j	fa <race_for_state+0xaa>

0000000000000176 <no_race_for_state>:
{
     176:	7179                	addi	sp,sp,-48
     178:	f406                	sd	ra,40(sp)
     17a:	f022                	sd	s0,32(sp)
     17c:	ec26                	sd	s1,24(sp)
     17e:	e84a                	sd	s2,16(sp)
     180:	e44e                	sd	s3,8(sp)
     182:	e052                	sd	s4,0(sp)
     184:	1800                	addi	s0,sp,48
    struct arg args = *(struct arg *)arg;
     186:	00052a03          	lw	s4,0(a0)
     18a:	00452983          	lw	s3,4(a0)
    printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     18e:	00000097          	auipc	ra,0x0
     192:	6a6080e7          	jalr	1702(ra) # 834 <twhoami>
     196:	00002497          	auipc	s1,0x2
     19a:	e6a48493          	addi	s1,s1,-406 # 2000 <shared_state>
     19e:	4094                	lw	a3,0(s1)
     1a0:	0005061b          	sext.w	a2,a0
     1a4:	00001597          	auipc	a1,0x1
     1a8:	04458593          	addi	a1,a1,68 # 11e8 <__FUNCTION__.5>
     1ac:	00001517          	auipc	a0,0x1
     1b0:	f1450513          	addi	a0,a0,-236 # 10c0 <__FUNCTION__.4+0x40>
     1b4:	00001097          	auipc	ra,0x1
     1b8:	d0e080e7          	jalr	-754(ra) # ec2 <printf>
    acquire(&shared_state_lock);
     1bc:	00002517          	auipc	a0,0x2
     1c0:	e5450513          	addi	a0,a0,-428 # 2010 <shared_state_lock>
     1c4:	00000097          	auipc	ra,0x0
     1c8:	56a080e7          	jalr	1386(ra) # 72e <acquire>
    if (shared_state == 0)
     1cc:	409c                	lw	a5,0(s1)
     1ce:	e3d1                	bnez	a5,252 <no_race_for_state+0xdc>
        tyield();
     1d0:	00000097          	auipc	ra,0x0
     1d4:	658080e7          	jalr	1624(ra) # 828 <tyield>
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     1d8:	00000097          	auipc	ra,0x0
     1dc:	65c080e7          	jalr	1628(ra) # 834 <twhoami>
     1e0:	00001917          	auipc	s2,0x1
     1e4:	00890913          	addi	s2,s2,8 # 11e8 <__FUNCTION__.5>
     1e8:	4094                	lw	a3,0(s1)
     1ea:	0005061b          	sext.w	a2,a0
     1ee:	85ca                	mv	a1,s2
     1f0:	00001517          	auipc	a0,0x1
     1f4:	ed050513          	addi	a0,a0,-304 # 10c0 <__FUNCTION__.4+0x40>
     1f8:	00001097          	auipc	ra,0x1
     1fc:	cca080e7          	jalr	-822(ra) # ec2 <printf>
        shared_state += args.a;
     200:	409c                	lw	a5,0(s1)
     202:	014787bb          	addw	a5,a5,s4
     206:	c09c                	sw	a5,0(s1)
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     208:	00000097          	auipc	ra,0x0
     20c:	62c080e7          	jalr	1580(ra) # 834 <twhoami>
     210:	4094                	lw	a3,0(s1)
     212:	0005061b          	sext.w	a2,a0
     216:	85ca                	mv	a1,s2
     218:	00001517          	auipc	a0,0x1
     21c:	ea850513          	addi	a0,a0,-344 # 10c0 <__FUNCTION__.4+0x40>
     220:	00001097          	auipc	ra,0x1
     224:	ca2080e7          	jalr	-862(ra) # ec2 <printf>
        tyield();
     228:	00000097          	auipc	ra,0x0
     22c:	600080e7          	jalr	1536(ra) # 828 <tyield>
    release(&shared_state_lock);
     230:	00002517          	auipc	a0,0x2
     234:	de050513          	addi	a0,a0,-544 # 2010 <shared_state_lock>
     238:	00000097          	auipc	ra,0x0
     23c:	576080e7          	jalr	1398(ra) # 7ae <release>
}
     240:	4501                	li	a0,0
     242:	70a2                	ld	ra,40(sp)
     244:	7402                	ld	s0,32(sp)
     246:	64e2                	ld	s1,24(sp)
     248:	6942                	ld	s2,16(sp)
     24a:	69a2                	ld	s3,8(sp)
     24c:	6a02                	ld	s4,0(sp)
     24e:	6145                	addi	sp,sp,48
     250:	8082                	ret
        tyield();
     252:	00000097          	auipc	ra,0x0
     256:	5d6080e7          	jalr	1494(ra) # 828 <tyield>
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     25a:	00000097          	auipc	ra,0x0
     25e:	5da080e7          	jalr	1498(ra) # 834 <twhoami>
     262:	00002497          	auipc	s1,0x2
     266:	d9e48493          	addi	s1,s1,-610 # 2000 <shared_state>
     26a:	00001917          	auipc	s2,0x1
     26e:	f7e90913          	addi	s2,s2,-130 # 11e8 <__FUNCTION__.5>
     272:	4094                	lw	a3,0(s1)
     274:	0005061b          	sext.w	a2,a0
     278:	85ca                	mv	a1,s2
     27a:	00001517          	auipc	a0,0x1
     27e:	e4650513          	addi	a0,a0,-442 # 10c0 <__FUNCTION__.4+0x40>
     282:	00001097          	auipc	ra,0x1
     286:	c40080e7          	jalr	-960(ra) # ec2 <printf>
        shared_state += args.b;
     28a:	409c                	lw	a5,0(s1)
     28c:	013787bb          	addw	a5,a5,s3
     290:	c09c                	sw	a5,0(s1)
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     292:	00000097          	auipc	ra,0x0
     296:	5a2080e7          	jalr	1442(ra) # 834 <twhoami>
     29a:	4094                	lw	a3,0(s1)
     29c:	0005061b          	sext.w	a2,a0
     2a0:	85ca                	mv	a1,s2
     2a2:	00001517          	auipc	a0,0x1
     2a6:	e1e50513          	addi	a0,a0,-482 # 10c0 <__FUNCTION__.4+0x40>
     2aa:	00001097          	auipc	ra,0x1
     2ae:	c18080e7          	jalr	-1000(ra) # ec2 <printf>
        tyield();
     2b2:	00000097          	auipc	ra,0x0
     2b6:	576080e7          	jalr	1398(ra) # 828 <tyield>
     2ba:	bf9d                	j	230 <no_race_for_state+0xba>

00000000000002bc <calculate_rv>:

void *calculate_rv(void *arg)
{
     2bc:	7179                	addi	sp,sp,-48
     2be:	f406                	sd	ra,40(sp)
     2c0:	f022                	sd	s0,32(sp)
     2c2:	ec26                	sd	s1,24(sp)
     2c4:	e84a                	sd	s2,16(sp)
     2c6:	e44e                	sd	s3,8(sp)
     2c8:	1800                	addi	s0,sp,48
    struct arg args = *(struct arg *)arg;
     2ca:	4104                	lw	s1,0(a0)
     2cc:	00452983          	lw	s3,4(a0)
    printf("child args: a=%d, b=%d\n", args.a, args.b);
     2d0:	864e                	mv	a2,s3
     2d2:	85a6                	mv	a1,s1
     2d4:	00001517          	auipc	a0,0x1
     2d8:	dfc50513          	addi	a0,a0,-516 # 10d0 <__FUNCTION__.4+0x50>
     2dc:	00001097          	auipc	ra,0x1
     2e0:	be6080e7          	jalr	-1050(ra) # ec2 <printf>
    int *result = (int *)malloc(sizeof(int));
     2e4:	4511                	li	a0,4
     2e6:	00001097          	auipc	ra,0x1
     2ea:	c94080e7          	jalr	-876(ra) # f7a <malloc>
     2ee:	892a                	mv	s2,a0
    *result = args.a + args.b;
     2f0:	013485bb          	addw	a1,s1,s3
     2f4:	c10c                	sw	a1,0(a0)
    printf("child result: %d\n", *result);
     2f6:	2581                	sext.w	a1,a1
     2f8:	00001517          	auipc	a0,0x1
     2fc:	df050513          	addi	a0,a0,-528 # 10e8 <__FUNCTION__.4+0x68>
     300:	00001097          	auipc	ra,0x1
     304:	bc2080e7          	jalr	-1086(ra) # ec2 <printf>
    return (void *)result;
}
     308:	854a                	mv	a0,s2
     30a:	70a2                	ld	ra,40(sp)
     30c:	7402                	ld	s0,32(sp)
     30e:	64e2                	ld	s1,24(sp)
     310:	6942                	ld	s2,16(sp)
     312:	69a2                	ld	s3,8(sp)
     314:	6145                	addi	sp,sp,48
     316:	8082                	ret

0000000000000318 <test1>:

void test1()
{
     318:	1101                	addi	sp,sp,-32
     31a:	ec06                	sd	ra,24(sp)
     31c:	e822                	sd	s0,16(sp)
     31e:	1000                	addi	s0,sp,32
    printf("[%s enter]\n", __FUNCTION__);
     320:	00001597          	auipc	a1,0x1
     324:	d6058593          	addi	a1,a1,-672 # 1080 <__FUNCTION__.4>
     328:	00001517          	auipc	a0,0x1
     32c:	dd850513          	addi	a0,a0,-552 # 1100 <__FUNCTION__.4+0x80>
     330:	00001097          	auipc	ra,0x1
     334:	b92080e7          	jalr	-1134(ra) # ec2 <printf>
    struct thread *t;
    tcreate(&t, 0, &print_hello_world, 0);
     338:	4681                	li	a3,0
     33a:	00000617          	auipc	a2,0x0
     33e:	cc660613          	addi	a2,a2,-826 # 0 <print_hello_world>
     342:	4581                	li	a1,0
     344:	fe840513          	addi	a0,s0,-24
     348:	00000097          	auipc	ra,0x0
     34c:	4c6080e7          	jalr	1222(ra) # 80e <tcreate>
    tyield();
     350:	00000097          	auipc	ra,0x0
     354:	4d8080e7          	jalr	1240(ra) # 828 <tyield>
    printf("[%s exit]\n", __FUNCTION__);
     358:	00001597          	auipc	a1,0x1
     35c:	d2858593          	addi	a1,a1,-728 # 1080 <__FUNCTION__.4>
     360:	00001517          	auipc	a0,0x1
     364:	db050513          	addi	a0,a0,-592 # 1110 <__FUNCTION__.4+0x90>
     368:	00001097          	auipc	ra,0x1
     36c:	b5a080e7          	jalr	-1190(ra) # ec2 <printf>
}
     370:	60e2                	ld	ra,24(sp)
     372:	6442                	ld	s0,16(sp)
     374:	6105                	addi	sp,sp,32
     376:	8082                	ret

0000000000000378 <test2>:

void test2()
{
     378:	7159                	addi	sp,sp,-112
     37a:	f486                	sd	ra,104(sp)
     37c:	f0a2                	sd	s0,96(sp)
     37e:	eca6                	sd	s1,88(sp)
     380:	e8ca                	sd	s2,80(sp)
     382:	e4ce                	sd	s3,72(sp)
     384:	e0d2                	sd	s4,64(sp)
     386:	1880                	addi	s0,sp,112
    printf("[%s enter]\n", __FUNCTION__);
     388:	00001597          	auipc	a1,0x1
     38c:	cf058593          	addi	a1,a1,-784 # 1078 <__FUNCTION__.3>
     390:	00001517          	auipc	a0,0x1
     394:	d7050513          	addi	a0,a0,-656 # 1100 <__FUNCTION__.4+0x80>
     398:	00001097          	auipc	ra,0x1
     39c:	b2a080e7          	jalr	-1238(ra) # ec2 <printf>
    struct thread *threadpool[8] = {0};
     3a0:	f8043823          	sd	zero,-112(s0)
     3a4:	f8043c23          	sd	zero,-104(s0)
     3a8:	fa043023          	sd	zero,-96(s0)
     3ac:	fa043423          	sd	zero,-88(s0)
     3b0:	fa043823          	sd	zero,-80(s0)
     3b4:	fa043c23          	sd	zero,-72(s0)
     3b8:	fc043023          	sd	zero,-64(s0)
     3bc:	fc043423          	sd	zero,-56(s0)
    for (int i = 0; i < 8; i++)
     3c0:	f9040493          	addi	s1,s0,-112
     3c4:	fd040993          	addi	s3,s0,-48
    struct thread *threadpool[8] = {0};
     3c8:	8926                	mv	s2,s1
    {
        tcreate(&threadpool[i], 0, &print_hello_world_with_tid, 0);
     3ca:	00000a17          	auipc	s4,0x0
     3ce:	c58a0a13          	addi	s4,s4,-936 # 22 <print_hello_world_with_tid>
     3d2:	4681                	li	a3,0
     3d4:	8652                	mv	a2,s4
     3d6:	4581                	li	a1,0
     3d8:	854a                	mv	a0,s2
     3da:	00000097          	auipc	ra,0x0
     3de:	434080e7          	jalr	1076(ra) # 80e <tcreate>
    for (int i = 0; i < 8; i++)
     3e2:	0921                	addi	s2,s2,8
     3e4:	ff3917e3          	bne	s2,s3,3d2 <test2+0x5a>
    }
    for (int i = 0; i < 8; i++)
    {
        tjoin(threadpool[i]->tid, 0, 0);
     3e8:	609c                	ld	a5,0(s1)
     3ea:	4601                	li	a2,0
     3ec:	4581                	li	a1,0
     3ee:	0007c503          	lbu	a0,0(a5)
     3f2:	00000097          	auipc	ra,0x0
     3f6:	428080e7          	jalr	1064(ra) # 81a <tjoin>
    for (int i = 0; i < 8; i++)
     3fa:	04a1                	addi	s1,s1,8
     3fc:	ff3496e3          	bne	s1,s3,3e8 <test2+0x70>
    }
    printf("[%s exit]\n", __FUNCTION__);
     400:	00001597          	auipc	a1,0x1
     404:	c7858593          	addi	a1,a1,-904 # 1078 <__FUNCTION__.3>
     408:	00001517          	auipc	a0,0x1
     40c:	d0850513          	addi	a0,a0,-760 # 1110 <__FUNCTION__.4+0x90>
     410:	00001097          	auipc	ra,0x1
     414:	ab2080e7          	jalr	-1358(ra) # ec2 <printf>
}
     418:	70a6                	ld	ra,104(sp)
     41a:	7406                	ld	s0,96(sp)
     41c:	64e6                	ld	s1,88(sp)
     41e:	6946                	ld	s2,80(sp)
     420:	69a6                	ld	s3,72(sp)
     422:	6a06                	ld	s4,64(sp)
     424:	6165                	addi	sp,sp,112
     426:	8082                	ret

0000000000000428 <test3>:

void test3()
{
     428:	7179                	addi	sp,sp,-48
     42a:	f406                	sd	ra,40(sp)
     42c:	f022                	sd	s0,32(sp)
     42e:	1800                	addi	s0,sp,48
    printf("[%s enter]\n", __FUNCTION__);
     430:	00001597          	auipc	a1,0x1
     434:	c4058593          	addi	a1,a1,-960 # 1070 <__FUNCTION__.2>
     438:	00001517          	auipc	a0,0x1
     43c:	cc850513          	addi	a0,a0,-824 # 1100 <__FUNCTION__.4+0x80>
     440:	00001097          	auipc	ra,0x1
     444:	a82080e7          	jalr	-1406(ra) # ec2 <printf>
    struct thread *t;
    struct thread_attr tattr;
    tattr.res_size = sizeof(int);
     448:	4791                	li	a5,4
     44a:	fef42223          	sw	a5,-28(s0)
    tattr.stacksize = 512;
     44e:	20000793          	li	a5,512
     452:	fef42023          	sw	a5,-32(s0)
    struct arg args;
    args.a = 1;
     456:	4785                	li	a5,1
     458:	fcf42c23          	sw	a5,-40(s0)
    args.b = 10;
     45c:	47a9                	li	a5,10
     45e:	fcf42e23          	sw	a5,-36(s0)
    tcreate(&t, &tattr, &calculate_rv, &args);
     462:	fd840693          	addi	a3,s0,-40
     466:	00000617          	auipc	a2,0x0
     46a:	e5660613          	addi	a2,a2,-426 # 2bc <calculate_rv>
     46e:	fe040593          	addi	a1,s0,-32
     472:	fe840513          	addi	a0,s0,-24
     476:	00000097          	auipc	ra,0x0
     47a:	398080e7          	jalr	920(ra) # 80e <tcreate>
    int result;
    tjoin(t->tid, &result, sizeof(int));
     47e:	4611                	li	a2,4
     480:	fd440593          	addi	a1,s0,-44
     484:	fe843783          	ld	a5,-24(s0)
     488:	0007c503          	lbu	a0,0(a5)
     48c:	00000097          	auipc	ra,0x0
     490:	38e080e7          	jalr	910(ra) # 81a <tjoin>
    printf("parent result: %d\n", result);
     494:	fd442583          	lw	a1,-44(s0)
     498:	00001517          	auipc	a0,0x1
     49c:	c8850513          	addi	a0,a0,-888 # 1120 <__FUNCTION__.4+0xa0>
     4a0:	00001097          	auipc	ra,0x1
     4a4:	a22080e7          	jalr	-1502(ra) # ec2 <printf>
    printf("[%s exit]\n", __FUNCTION__);
     4a8:	00001597          	auipc	a1,0x1
     4ac:	bc858593          	addi	a1,a1,-1080 # 1070 <__FUNCTION__.2>
     4b0:	00001517          	auipc	a0,0x1
     4b4:	c6050513          	addi	a0,a0,-928 # 1110 <__FUNCTION__.4+0x90>
     4b8:	00001097          	auipc	ra,0x1
     4bc:	a0a080e7          	jalr	-1526(ra) # ec2 <printf>
}
     4c0:	70a2                	ld	ra,40(sp)
     4c2:	7402                	ld	s0,32(sp)
     4c4:	6145                	addi	sp,sp,48
     4c6:	8082                	ret

00000000000004c8 <test4>:

void test4()
{
     4c8:	7179                	addi	sp,sp,-48
     4ca:	f406                	sd	ra,40(sp)
     4cc:	f022                	sd	s0,32(sp)
     4ce:	1800                	addi	s0,sp,48
    printf("[%s enter]\n", __FUNCTION__);
     4d0:	00001597          	auipc	a1,0x1
     4d4:	b9858593          	addi	a1,a1,-1128 # 1068 <__FUNCTION__.1>
     4d8:	00001517          	auipc	a0,0x1
     4dc:	c2850513          	addi	a0,a0,-984 # 1100 <__FUNCTION__.4+0x80>
     4e0:	00001097          	auipc	ra,0x1
     4e4:	9e2080e7          	jalr	-1566(ra) # ec2 <printf>
    struct thread *ta;
    struct thread *tb;
    struct arg args;
    args.a = 1;
     4e8:	4785                	li	a5,1
     4ea:	fcf42c23          	sw	a5,-40(s0)
    args.b = 2;
     4ee:	4789                	li	a5,2
     4f0:	fcf42e23          	sw	a5,-36(s0)
    tcreate(&ta, 0, &race_for_state, &args);
     4f4:	fd840693          	addi	a3,s0,-40
     4f8:	00000617          	auipc	a2,0x0
     4fc:	b5860613          	addi	a2,a2,-1192 # 50 <race_for_state>
     500:	4581                	li	a1,0
     502:	fe840513          	addi	a0,s0,-24
     506:	00000097          	auipc	ra,0x0
     50a:	308080e7          	jalr	776(ra) # 80e <tcreate>
    tcreate(&tb, 0, &race_for_state, &args);
     50e:	fd840693          	addi	a3,s0,-40
     512:	00000617          	auipc	a2,0x0
     516:	b3e60613          	addi	a2,a2,-1218 # 50 <race_for_state>
     51a:	4581                	li	a1,0
     51c:	fe040513          	addi	a0,s0,-32
     520:	00000097          	auipc	ra,0x0
     524:	2ee080e7          	jalr	750(ra) # 80e <tcreate>
    tyield();
     528:	00000097          	auipc	ra,0x0
     52c:	300080e7          	jalr	768(ra) # 828 <tyield>
    tjoin(ta->tid, 0, 0);
     530:	4601                	li	a2,0
     532:	4581                	li	a1,0
     534:	fe843783          	ld	a5,-24(s0)
     538:	0007c503          	lbu	a0,0(a5)
     53c:	00000097          	auipc	ra,0x0
     540:	2de080e7          	jalr	734(ra) # 81a <tjoin>
    tjoin(tb->tid, 0, 0);
     544:	4601                	li	a2,0
     546:	4581                	li	a1,0
     548:	fe043783          	ld	a5,-32(s0)
     54c:	0007c503          	lbu	a0,0(a5)
     550:	00000097          	auipc	ra,0x0
     554:	2ca080e7          	jalr	714(ra) # 81a <tjoin>
    printf("[%s exit]\n", __FUNCTION__);
     558:	00001597          	auipc	a1,0x1
     55c:	b1058593          	addi	a1,a1,-1264 # 1068 <__FUNCTION__.1>
     560:	00001517          	auipc	a0,0x1
     564:	bb050513          	addi	a0,a0,-1104 # 1110 <__FUNCTION__.4+0x90>
     568:	00001097          	auipc	ra,0x1
     56c:	95a080e7          	jalr	-1702(ra) # ec2 <printf>
}
     570:	70a2                	ld	ra,40(sp)
     572:	7402                	ld	s0,32(sp)
     574:	6145                	addi	sp,sp,48
     576:	8082                	ret

0000000000000578 <test5>:

void test5()
{
     578:	7179                	addi	sp,sp,-48
     57a:	f406                	sd	ra,40(sp)
     57c:	f022                	sd	s0,32(sp)
     57e:	1800                	addi	s0,sp,48
    printf("[%s enter]\n", __FUNCTION__);
     580:	00001597          	auipc	a1,0x1
     584:	ae058593          	addi	a1,a1,-1312 # 1060 <__FUNCTION__.0>
     588:	00001517          	auipc	a0,0x1
     58c:	b7850513          	addi	a0,a0,-1160 # 1100 <__FUNCTION__.4+0x80>
     590:	00001097          	auipc	ra,0x1
     594:	932080e7          	jalr	-1742(ra) # ec2 <printf>
    initlock(&shared_state_lock, "sharedstate lock");
     598:	00001597          	auipc	a1,0x1
     59c:	ba058593          	addi	a1,a1,-1120 # 1138 <__FUNCTION__.4+0xb8>
     5a0:	00002517          	auipc	a0,0x2
     5a4:	a7050513          	addi	a0,a0,-1424 # 2010 <shared_state_lock>
     5a8:	00000097          	auipc	ra,0x0
     5ac:	13a080e7          	jalr	314(ra) # 6e2 <initlock>
    struct thread *ta;
    struct thread *tb;
    struct arg args;
    args.a = 1;
     5b0:	4785                	li	a5,1
     5b2:	fcf42c23          	sw	a5,-40(s0)
    args.b = 2;
     5b6:	4789                	li	a5,2
     5b8:	fcf42e23          	sw	a5,-36(s0)
    tcreate(&ta, 0, &no_race_for_state, &args);
     5bc:	fd840693          	addi	a3,s0,-40
     5c0:	00000617          	auipc	a2,0x0
     5c4:	bb660613          	addi	a2,a2,-1098 # 176 <no_race_for_state>
     5c8:	4581                	li	a1,0
     5ca:	fe840513          	addi	a0,s0,-24
     5ce:	00000097          	auipc	ra,0x0
     5d2:	240080e7          	jalr	576(ra) # 80e <tcreate>
    tcreate(&tb, 0, &no_race_for_state, &args);
     5d6:	fd840693          	addi	a3,s0,-40
     5da:	00000617          	auipc	a2,0x0
     5de:	b9c60613          	addi	a2,a2,-1124 # 176 <no_race_for_state>
     5e2:	4581                	li	a1,0
     5e4:	fe040513          	addi	a0,s0,-32
     5e8:	00000097          	auipc	ra,0x0
     5ec:	226080e7          	jalr	550(ra) # 80e <tcreate>
    tyield();
     5f0:	00000097          	auipc	ra,0x0
     5f4:	238080e7          	jalr	568(ra) # 828 <tyield>
    tjoin(ta->tid, 0, 0);
     5f8:	4601                	li	a2,0
     5fa:	4581                	li	a1,0
     5fc:	fe843783          	ld	a5,-24(s0)
     600:	0007c503          	lbu	a0,0(a5)
     604:	00000097          	auipc	ra,0x0
     608:	216080e7          	jalr	534(ra) # 81a <tjoin>
    tjoin(tb->tid, 0, 0);
     60c:	4601                	li	a2,0
     60e:	4581                	li	a1,0
     610:	fe043783          	ld	a5,-32(s0)
     614:	0007c503          	lbu	a0,0(a5)
     618:	00000097          	auipc	ra,0x0
     61c:	202080e7          	jalr	514(ra) # 81a <tjoin>
    printf("[%s exit]\n", __FUNCTION__);
     620:	00001597          	auipc	a1,0x1
     624:	a4058593          	addi	a1,a1,-1472 # 1060 <__FUNCTION__.0>
     628:	00001517          	auipc	a0,0x1
     62c:	ae850513          	addi	a0,a0,-1304 # 1110 <__FUNCTION__.4+0x90>
     630:	00001097          	auipc	ra,0x1
     634:	892080e7          	jalr	-1902(ra) # ec2 <printf>
}
     638:	70a2                	ld	ra,40(sp)
     63a:	7402                	ld	s0,32(sp)
     63c:	6145                	addi	sp,sp,48
     63e:	8082                	ret

0000000000000640 <main>:
int main(int argc, char *argv[])
{
     640:	1101                	addi	sp,sp,-32
     642:	ec06                	sd	ra,24(sp)
     644:	e822                	sd	s0,16(sp)
     646:	e426                	sd	s1,8(sp)
     648:	1000                	addi	s0,sp,32
    if (argc < 2)
     64a:	4785                	li	a5,1
     64c:	02a7d463          	bge	a5,a0,674 <main+0x34>
     650:	84ae                	mv	s1,a1
    {
        printf("ttest TEST_ID\n TEST ID\tId of the test to run. ID can be any value from 1 to 5\n");
        return -1;
    }

    switch (atoi(argv[1]))
     652:	6588                	ld	a0,8(a1)
     654:	00000097          	auipc	ra,0x0
     658:	3e2080e7          	jalr	994(ra) # a36 <atoi>
     65c:	4795                	li	a5,5
     65e:	06a7e763          	bltu	a5,a0,6cc <main+0x8c>
     662:	050a                	slli	a0,a0,0x2
     664:	00001717          	auipc	a4,0x1
     668:	b5c70713          	addi	a4,a4,-1188 # 11c0 <__FUNCTION__.4+0x140>
     66c:	953a                	add	a0,a0,a4
     66e:	411c                	lw	a5,0(a0)
     670:	97ba                	add	a5,a5,a4
     672:	8782                	jr	a5
        printf("ttest TEST_ID\n TEST ID\tId of the test to run. ID can be any value from 1 to 5\n");
     674:	00001517          	auipc	a0,0x1
     678:	adc50513          	addi	a0,a0,-1316 # 1150 <__FUNCTION__.4+0xd0>
     67c:	00001097          	auipc	ra,0x1
     680:	846080e7          	jalr	-1978(ra) # ec2 <printf>
        return -1;
     684:	557d                	li	a0,-1
     686:	a031                	j	692 <main+0x52>
    {
    case 1:
        test1();
     688:	00000097          	auipc	ra,0x0
     68c:	c90080e7          	jalr	-880(ra) # 318 <test1>

    default:
        printf("Error: No test with index %s\n", argv[1]);
        return -1;
    }
    return 0;
     690:	4501                	li	a0,0
    return 0;
     692:	60e2                	ld	ra,24(sp)
     694:	6442                	ld	s0,16(sp)
     696:	64a2                	ld	s1,8(sp)
     698:	6105                	addi	sp,sp,32
     69a:	8082                	ret
        test2();
     69c:	00000097          	auipc	ra,0x0
     6a0:	cdc080e7          	jalr	-804(ra) # 378 <test2>
    return 0;
     6a4:	4501                	li	a0,0
        break;
     6a6:	b7f5                	j	692 <main+0x52>
        test3();
     6a8:	00000097          	auipc	ra,0x0
     6ac:	d80080e7          	jalr	-640(ra) # 428 <test3>
    return 0;
     6b0:	4501                	li	a0,0
        break;
     6b2:	b7c5                	j	692 <main+0x52>
        test4();
     6b4:	00000097          	auipc	ra,0x0
     6b8:	e14080e7          	jalr	-492(ra) # 4c8 <test4>
    return 0;
     6bc:	4501                	li	a0,0
        break;
     6be:	bfd1                	j	692 <main+0x52>
        test5();
     6c0:	00000097          	auipc	ra,0x0
     6c4:	eb8080e7          	jalr	-328(ra) # 578 <test5>
    return 0;
     6c8:	4501                	li	a0,0
        break;
     6ca:	b7e1                	j	692 <main+0x52>
        printf("Error: No test with index %s\n", argv[1]);
     6cc:	648c                	ld	a1,8(s1)
     6ce:	00001517          	auipc	a0,0x1
     6d2:	ad250513          	addi	a0,a0,-1326 # 11a0 <__FUNCTION__.4+0x120>
     6d6:	00000097          	auipc	ra,0x0
     6da:	7ec080e7          	jalr	2028(ra) # ec2 <printf>
        return -1;
     6de:	557d                	li	a0,-1
     6e0:	bf4d                	j	692 <main+0x52>

00000000000006e2 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     6e2:	1141                	addi	sp,sp,-16
     6e4:	e422                	sd	s0,8(sp)
     6e6:	0800                	addi	s0,sp,16
    lk->name = name;
     6e8:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     6ea:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     6ee:	57fd                	li	a5,-1
     6f0:	00f50823          	sb	a5,16(a0)
}
     6f4:	6422                	ld	s0,8(sp)
     6f6:	0141                	addi	sp,sp,16
     6f8:	8082                	ret

00000000000006fa <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     6fa:	00054783          	lbu	a5,0(a0)
     6fe:	e399                	bnez	a5,704 <holding+0xa>
     700:	4501                	li	a0,0
}
     702:	8082                	ret
{
     704:	1101                	addi	sp,sp,-32
     706:	ec06                	sd	ra,24(sp)
     708:	e822                	sd	s0,16(sp)
     70a:	e426                	sd	s1,8(sp)
     70c:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     70e:	01054483          	lbu	s1,16(a0)
     712:	00000097          	auipc	ra,0x0
     716:	122080e7          	jalr	290(ra) # 834 <twhoami>
     71a:	2501                	sext.w	a0,a0
     71c:	40a48533          	sub	a0,s1,a0
     720:	00153513          	seqz	a0,a0
}
     724:	60e2                	ld	ra,24(sp)
     726:	6442                	ld	s0,16(sp)
     728:	64a2                	ld	s1,8(sp)
     72a:	6105                	addi	sp,sp,32
     72c:	8082                	ret

000000000000072e <acquire>:

void acquire(struct lock *lk)
{
     72e:	7179                	addi	sp,sp,-48
     730:	f406                	sd	ra,40(sp)
     732:	f022                	sd	s0,32(sp)
     734:	ec26                	sd	s1,24(sp)
     736:	e84a                	sd	s2,16(sp)
     738:	e44e                	sd	s3,8(sp)
     73a:	e052                	sd	s4,0(sp)
     73c:	1800                	addi	s0,sp,48
     73e:	8a2a                	mv	s4,a0
    if (holding(lk))
     740:	00000097          	auipc	ra,0x0
     744:	fba080e7          	jalr	-70(ra) # 6fa <holding>
     748:	e919                	bnez	a0,75e <acquire+0x30>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     74a:	ffca7493          	andi	s1,s4,-4
     74e:	003a7913          	andi	s2,s4,3
     752:	0039191b          	slliw	s2,s2,0x3
     756:	4985                	li	s3,1
     758:	012999bb          	sllw	s3,s3,s2
     75c:	a015                	j	780 <acquire+0x52>
        printf("re-acquiring lock we already hold");
     75e:	00001517          	auipc	a0,0x1
     762:	aa250513          	addi	a0,a0,-1374 # 1200 <__FUNCTION__.5+0x18>
     766:	00000097          	auipc	ra,0x0
     76a:	75c080e7          	jalr	1884(ra) # ec2 <printf>
        exit(-1);
     76e:	557d                	li	a0,-1
     770:	00000097          	auipc	ra,0x0
     774:	3c0080e7          	jalr	960(ra) # b30 <exit>
    {
        // give up the cpu for other threads
        tyield();
     778:	00000097          	auipc	ra,0x0
     77c:	0b0080e7          	jalr	176(ra) # 828 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     780:	4534a7af          	amoor.w.aq	a5,s3,(s1)
     784:	0127d7bb          	srlw	a5,a5,s2
     788:	0ff7f793          	zext.b	a5,a5
     78c:	f7f5                	bnez	a5,778 <acquire+0x4a>
    }

    __sync_synchronize();
     78e:	0ff0000f          	fence

    lk->tid = twhoami();
     792:	00000097          	auipc	ra,0x0
     796:	0a2080e7          	jalr	162(ra) # 834 <twhoami>
     79a:	00aa0823          	sb	a0,16(s4)
}
     79e:	70a2                	ld	ra,40(sp)
     7a0:	7402                	ld	s0,32(sp)
     7a2:	64e2                	ld	s1,24(sp)
     7a4:	6942                	ld	s2,16(sp)
     7a6:	69a2                	ld	s3,8(sp)
     7a8:	6a02                	ld	s4,0(sp)
     7aa:	6145                	addi	sp,sp,48
     7ac:	8082                	ret

00000000000007ae <release>:

void release(struct lock *lk)
{
     7ae:	1101                	addi	sp,sp,-32
     7b0:	ec06                	sd	ra,24(sp)
     7b2:	e822                	sd	s0,16(sp)
     7b4:	e426                	sd	s1,8(sp)
     7b6:	1000                	addi	s0,sp,32
     7b8:	84aa                	mv	s1,a0
    if (!holding(lk))
     7ba:	00000097          	auipc	ra,0x0
     7be:	f40080e7          	jalr	-192(ra) # 6fa <holding>
     7c2:	c11d                	beqz	a0,7e8 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     7c4:	57fd                	li	a5,-1
     7c6:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     7ca:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
     7ce:	0ff0000f          	fence
     7d2:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     7d6:	00000097          	auipc	ra,0x0
     7da:	052080e7          	jalr	82(ra) # 828 <tyield>
}
     7de:	60e2                	ld	ra,24(sp)
     7e0:	6442                	ld	s0,16(sp)
     7e2:	64a2                	ld	s1,8(sp)
     7e4:	6105                	addi	sp,sp,32
     7e6:	8082                	ret
        printf("releasing lock we are not holding");
     7e8:	00001517          	auipc	a0,0x1
     7ec:	a4050513          	addi	a0,a0,-1472 # 1228 <__FUNCTION__.5+0x40>
     7f0:	00000097          	auipc	ra,0x0
     7f4:	6d2080e7          	jalr	1746(ra) # ec2 <printf>
        exit(-1);
     7f8:	557d                	li	a0,-1
     7fa:	00000097          	auipc	ra,0x0
     7fe:	336080e7          	jalr	822(ra) # b30 <exit>

0000000000000802 <tsched>:
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
     802:	1141                	addi	sp,sp,-16
     804:	e422                	sd	s0,8(sp)
     806:	0800                	addi	s0,sp,16
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}
     808:	6422                	ld	s0,8(sp)
     80a:	0141                	addi	sp,sp,16
     80c:	8082                	ret

000000000000080e <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     80e:	1141                	addi	sp,sp,-16
     810:	e422                	sd	s0,8(sp)
     812:	0800                	addi	s0,sp,16
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}
     814:	6422                	ld	s0,8(sp)
     816:	0141                	addi	sp,sp,16
     818:	8082                	ret

000000000000081a <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     81a:	1141                	addi	sp,sp,-16
     81c:	e422                	sd	s0,8(sp)
     81e:	0800                	addi	s0,sp,16
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}
     820:	4501                	li	a0,0
     822:	6422                	ld	s0,8(sp)
     824:	0141                	addi	sp,sp,16
     826:	8082                	ret

0000000000000828 <tyield>:

void tyield()
{
     828:	1141                	addi	sp,sp,-16
     82a:	e422                	sd	s0,8(sp)
     82c:	0800                	addi	s0,sp,16
    // TODO: Implement the yielding behaviour of the thread
}
     82e:	6422                	ld	s0,8(sp)
     830:	0141                	addi	sp,sp,16
     832:	8082                	ret

0000000000000834 <twhoami>:

uint8 twhoami()
{
     834:	1141                	addi	sp,sp,-16
     836:	e422                	sd	s0,8(sp)
     838:	0800                	addi	s0,sp,16
    // TODO: Returns the thread id of the current thread
    return 0;
}
     83a:	4501                	li	a0,0
     83c:	6422                	ld	s0,8(sp)
     83e:	0141                	addi	sp,sp,16
     840:	8082                	ret

0000000000000842 <tswtch>:
     842:	00153023          	sd	ra,0(a0)
     846:	00253423          	sd	sp,8(a0)
     84a:	e900                	sd	s0,16(a0)
     84c:	ed04                	sd	s1,24(a0)
     84e:	03253023          	sd	s2,32(a0)
     852:	03353423          	sd	s3,40(a0)
     856:	03453823          	sd	s4,48(a0)
     85a:	03553c23          	sd	s5,56(a0)
     85e:	05653023          	sd	s6,64(a0)
     862:	05753423          	sd	s7,72(a0)
     866:	05853823          	sd	s8,80(a0)
     86a:	05953c23          	sd	s9,88(a0)
     86e:	07a53023          	sd	s10,96(a0)
     872:	07b53423          	sd	s11,104(a0)
     876:	0005b083          	ld	ra,0(a1)
     87a:	0085b103          	ld	sp,8(a1)
     87e:	6980                	ld	s0,16(a1)
     880:	6d84                	ld	s1,24(a1)
     882:	0205b903          	ld	s2,32(a1)
     886:	0285b983          	ld	s3,40(a1)
     88a:	0305ba03          	ld	s4,48(a1)
     88e:	0385ba83          	ld	s5,56(a1)
     892:	0405bb03          	ld	s6,64(a1)
     896:	0485bb83          	ld	s7,72(a1)
     89a:	0505bc03          	ld	s8,80(a1)
     89e:	0585bc83          	ld	s9,88(a1)
     8a2:	0605bd03          	ld	s10,96(a1)
     8a6:	0685bd83          	ld	s11,104(a1)
     8aa:	8082                	ret

00000000000008ac <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     8ac:	1141                	addi	sp,sp,-16
     8ae:	e406                	sd	ra,8(sp)
     8b0:	e022                	sd	s0,0(sp)
     8b2:	0800                	addi	s0,sp,16
    // TODO: Ensure that main also is taken into consideration by the thread scheduler
    // TODO: This function should only return once all threads have finished running
    extern int main(int argc, char *argv[]);
    int res = main(argc, argv);
     8b4:	00000097          	auipc	ra,0x0
     8b8:	d8c080e7          	jalr	-628(ra) # 640 <main>
    exit(res);
     8bc:	00000097          	auipc	ra,0x0
     8c0:	274080e7          	jalr	628(ra) # b30 <exit>

00000000000008c4 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     8c4:	1141                	addi	sp,sp,-16
     8c6:	e422                	sd	s0,8(sp)
     8c8:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     8ca:	87aa                	mv	a5,a0
     8cc:	0585                	addi	a1,a1,1
     8ce:	0785                	addi	a5,a5,1
     8d0:	fff5c703          	lbu	a4,-1(a1)
     8d4:	fee78fa3          	sb	a4,-1(a5)
     8d8:	fb75                	bnez	a4,8cc <strcpy+0x8>
        ;
    return os;
}
     8da:	6422                	ld	s0,8(sp)
     8dc:	0141                	addi	sp,sp,16
     8de:	8082                	ret

00000000000008e0 <strcmp>:

int strcmp(const char *p, const char *q)
{
     8e0:	1141                	addi	sp,sp,-16
     8e2:	e422                	sd	s0,8(sp)
     8e4:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     8e6:	00054783          	lbu	a5,0(a0)
     8ea:	cb91                	beqz	a5,8fe <strcmp+0x1e>
     8ec:	0005c703          	lbu	a4,0(a1)
     8f0:	00f71763          	bne	a4,a5,8fe <strcmp+0x1e>
        p++, q++;
     8f4:	0505                	addi	a0,a0,1
     8f6:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     8f8:	00054783          	lbu	a5,0(a0)
     8fc:	fbe5                	bnez	a5,8ec <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
     8fe:	0005c503          	lbu	a0,0(a1)
}
     902:	40a7853b          	subw	a0,a5,a0
     906:	6422                	ld	s0,8(sp)
     908:	0141                	addi	sp,sp,16
     90a:	8082                	ret

000000000000090c <strlen>:

uint strlen(const char *s)
{
     90c:	1141                	addi	sp,sp,-16
     90e:	e422                	sd	s0,8(sp)
     910:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     912:	00054783          	lbu	a5,0(a0)
     916:	cf91                	beqz	a5,932 <strlen+0x26>
     918:	0505                	addi	a0,a0,1
     91a:	87aa                	mv	a5,a0
     91c:	4685                	li	a3,1
     91e:	9e89                	subw	a3,a3,a0
     920:	00f6853b          	addw	a0,a3,a5
     924:	0785                	addi	a5,a5,1
     926:	fff7c703          	lbu	a4,-1(a5)
     92a:	fb7d                	bnez	a4,920 <strlen+0x14>
        ;
    return n;
}
     92c:	6422                	ld	s0,8(sp)
     92e:	0141                	addi	sp,sp,16
     930:	8082                	ret
    for (n = 0; s[n]; n++)
     932:	4501                	li	a0,0
     934:	bfe5                	j	92c <strlen+0x20>

0000000000000936 <memset>:

void *
memset(void *dst, int c, uint n)
{
     936:	1141                	addi	sp,sp,-16
     938:	e422                	sd	s0,8(sp)
     93a:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     93c:	ca19                	beqz	a2,952 <memset+0x1c>
     93e:	87aa                	mv	a5,a0
     940:	1602                	slli	a2,a2,0x20
     942:	9201                	srli	a2,a2,0x20
     944:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     948:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     94c:	0785                	addi	a5,a5,1
     94e:	fee79de3          	bne	a5,a4,948 <memset+0x12>
    }
    return dst;
}
     952:	6422                	ld	s0,8(sp)
     954:	0141                	addi	sp,sp,16
     956:	8082                	ret

0000000000000958 <strchr>:

char *
strchr(const char *s, char c)
{
     958:	1141                	addi	sp,sp,-16
     95a:	e422                	sd	s0,8(sp)
     95c:	0800                	addi	s0,sp,16
    for (; *s; s++)
     95e:	00054783          	lbu	a5,0(a0)
     962:	cb99                	beqz	a5,978 <strchr+0x20>
        if (*s == c)
     964:	00f58763          	beq	a1,a5,972 <strchr+0x1a>
    for (; *s; s++)
     968:	0505                	addi	a0,a0,1
     96a:	00054783          	lbu	a5,0(a0)
     96e:	fbfd                	bnez	a5,964 <strchr+0xc>
            return (char *)s;
    return 0;
     970:	4501                	li	a0,0
}
     972:	6422                	ld	s0,8(sp)
     974:	0141                	addi	sp,sp,16
     976:	8082                	ret
    return 0;
     978:	4501                	li	a0,0
     97a:	bfe5                	j	972 <strchr+0x1a>

000000000000097c <gets>:

char *
gets(char *buf, int max)
{
     97c:	711d                	addi	sp,sp,-96
     97e:	ec86                	sd	ra,88(sp)
     980:	e8a2                	sd	s0,80(sp)
     982:	e4a6                	sd	s1,72(sp)
     984:	e0ca                	sd	s2,64(sp)
     986:	fc4e                	sd	s3,56(sp)
     988:	f852                	sd	s4,48(sp)
     98a:	f456                	sd	s5,40(sp)
     98c:	f05a                	sd	s6,32(sp)
     98e:	ec5e                	sd	s7,24(sp)
     990:	1080                	addi	s0,sp,96
     992:	8baa                	mv	s7,a0
     994:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     996:	892a                	mv	s2,a0
     998:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
        if (cc < 1)
            break;
        buf[i++] = c;
        if (c == '\n' || c == '\r')
     99a:	4aa9                	li	s5,10
     99c:	4b35                	li	s6,13
    for (i = 0; i + 1 < max;)
     99e:	89a6                	mv	s3,s1
     9a0:	2485                	addiw	s1,s1,1
     9a2:	0344d863          	bge	s1,s4,9d2 <gets+0x56>
        cc = read(0, &c, 1);
     9a6:	4605                	li	a2,1
     9a8:	faf40593          	addi	a1,s0,-81
     9ac:	4501                	li	a0,0
     9ae:	00000097          	auipc	ra,0x0
     9b2:	19a080e7          	jalr	410(ra) # b48 <read>
        if (cc < 1)
     9b6:	00a05e63          	blez	a0,9d2 <gets+0x56>
        buf[i++] = c;
     9ba:	faf44783          	lbu	a5,-81(s0)
     9be:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     9c2:	01578763          	beq	a5,s5,9d0 <gets+0x54>
     9c6:	0905                	addi	s2,s2,1
     9c8:	fd679be3          	bne	a5,s6,99e <gets+0x22>
    for (i = 0; i + 1 < max;)
     9cc:	89a6                	mv	s3,s1
     9ce:	a011                	j	9d2 <gets+0x56>
     9d0:	89a6                	mv	s3,s1
            break;
    }
    buf[i] = '\0';
     9d2:	99de                	add	s3,s3,s7
     9d4:	00098023          	sb	zero,0(s3)
    return buf;
}
     9d8:	855e                	mv	a0,s7
     9da:	60e6                	ld	ra,88(sp)
     9dc:	6446                	ld	s0,80(sp)
     9de:	64a6                	ld	s1,72(sp)
     9e0:	6906                	ld	s2,64(sp)
     9e2:	79e2                	ld	s3,56(sp)
     9e4:	7a42                	ld	s4,48(sp)
     9e6:	7aa2                	ld	s5,40(sp)
     9e8:	7b02                	ld	s6,32(sp)
     9ea:	6be2                	ld	s7,24(sp)
     9ec:	6125                	addi	sp,sp,96
     9ee:	8082                	ret

00000000000009f0 <stat>:

int stat(const char *n, struct stat *st)
{
     9f0:	1101                	addi	sp,sp,-32
     9f2:	ec06                	sd	ra,24(sp)
     9f4:	e822                	sd	s0,16(sp)
     9f6:	e426                	sd	s1,8(sp)
     9f8:	e04a                	sd	s2,0(sp)
     9fa:	1000                	addi	s0,sp,32
     9fc:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     9fe:	4581                	li	a1,0
     a00:	00000097          	auipc	ra,0x0
     a04:	170080e7          	jalr	368(ra) # b70 <open>
    if (fd < 0)
     a08:	02054563          	bltz	a0,a32 <stat+0x42>
     a0c:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     a0e:	85ca                	mv	a1,s2
     a10:	00000097          	auipc	ra,0x0
     a14:	178080e7          	jalr	376(ra) # b88 <fstat>
     a18:	892a                	mv	s2,a0
    close(fd);
     a1a:	8526                	mv	a0,s1
     a1c:	00000097          	auipc	ra,0x0
     a20:	13c080e7          	jalr	316(ra) # b58 <close>
    return r;
}
     a24:	854a                	mv	a0,s2
     a26:	60e2                	ld	ra,24(sp)
     a28:	6442                	ld	s0,16(sp)
     a2a:	64a2                	ld	s1,8(sp)
     a2c:	6902                	ld	s2,0(sp)
     a2e:	6105                	addi	sp,sp,32
     a30:	8082                	ret
        return -1;
     a32:	597d                	li	s2,-1
     a34:	bfc5                	j	a24 <stat+0x34>

0000000000000a36 <atoi>:

int atoi(const char *s)
{
     a36:	1141                	addi	sp,sp,-16
     a38:	e422                	sd	s0,8(sp)
     a3a:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     a3c:	00054683          	lbu	a3,0(a0)
     a40:	fd06879b          	addiw	a5,a3,-48
     a44:	0ff7f793          	zext.b	a5,a5
     a48:	4625                	li	a2,9
     a4a:	02f66863          	bltu	a2,a5,a7a <atoi+0x44>
     a4e:	872a                	mv	a4,a0
    n = 0;
     a50:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     a52:	0705                	addi	a4,a4,1
     a54:	0025179b          	slliw	a5,a0,0x2
     a58:	9fa9                	addw	a5,a5,a0
     a5a:	0017979b          	slliw	a5,a5,0x1
     a5e:	9fb5                	addw	a5,a5,a3
     a60:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     a64:	00074683          	lbu	a3,0(a4)
     a68:	fd06879b          	addiw	a5,a3,-48
     a6c:	0ff7f793          	zext.b	a5,a5
     a70:	fef671e3          	bgeu	a2,a5,a52 <atoi+0x1c>
    return n;
}
     a74:	6422                	ld	s0,8(sp)
     a76:	0141                	addi	sp,sp,16
     a78:	8082                	ret
    n = 0;
     a7a:	4501                	li	a0,0
     a7c:	bfe5                	j	a74 <atoi+0x3e>

0000000000000a7e <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     a7e:	1141                	addi	sp,sp,-16
     a80:	e422                	sd	s0,8(sp)
     a82:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     a84:	02b57463          	bgeu	a0,a1,aac <memmove+0x2e>
    {
        while (n-- > 0)
     a88:	00c05f63          	blez	a2,aa6 <memmove+0x28>
     a8c:	1602                	slli	a2,a2,0x20
     a8e:	9201                	srli	a2,a2,0x20
     a90:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     a94:	872a                	mv	a4,a0
            *dst++ = *src++;
     a96:	0585                	addi	a1,a1,1
     a98:	0705                	addi	a4,a4,1
     a9a:	fff5c683          	lbu	a3,-1(a1)
     a9e:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     aa2:	fee79ae3          	bne	a5,a4,a96 <memmove+0x18>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     aa6:	6422                	ld	s0,8(sp)
     aa8:	0141                	addi	sp,sp,16
     aaa:	8082                	ret
        dst += n;
     aac:	00c50733          	add	a4,a0,a2
        src += n;
     ab0:	95b2                	add	a1,a1,a2
        while (n-- > 0)
     ab2:	fec05ae3          	blez	a2,aa6 <memmove+0x28>
     ab6:	fff6079b          	addiw	a5,a2,-1
     aba:	1782                	slli	a5,a5,0x20
     abc:	9381                	srli	a5,a5,0x20
     abe:	fff7c793          	not	a5,a5
     ac2:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     ac4:	15fd                	addi	a1,a1,-1
     ac6:	177d                	addi	a4,a4,-1
     ac8:	0005c683          	lbu	a3,0(a1)
     acc:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     ad0:	fee79ae3          	bne	a5,a4,ac4 <memmove+0x46>
     ad4:	bfc9                	j	aa6 <memmove+0x28>

0000000000000ad6 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     ad6:	1141                	addi	sp,sp,-16
     ad8:	e422                	sd	s0,8(sp)
     ada:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     adc:	ca05                	beqz	a2,b0c <memcmp+0x36>
     ade:	fff6069b          	addiw	a3,a2,-1
     ae2:	1682                	slli	a3,a3,0x20
     ae4:	9281                	srli	a3,a3,0x20
     ae6:	0685                	addi	a3,a3,1
     ae8:	96aa                	add	a3,a3,a0
    {
        if (*p1 != *p2)
     aea:	00054783          	lbu	a5,0(a0)
     aee:	0005c703          	lbu	a4,0(a1)
     af2:	00e79863          	bne	a5,a4,b02 <memcmp+0x2c>
        {
            return *p1 - *p2;
        }
        p1++;
     af6:	0505                	addi	a0,a0,1
        p2++;
     af8:	0585                	addi	a1,a1,1
    while (n-- > 0)
     afa:	fed518e3          	bne	a0,a3,aea <memcmp+0x14>
    }
    return 0;
     afe:	4501                	li	a0,0
     b00:	a019                	j	b06 <memcmp+0x30>
            return *p1 - *p2;
     b02:	40e7853b          	subw	a0,a5,a4
}
     b06:	6422                	ld	s0,8(sp)
     b08:	0141                	addi	sp,sp,16
     b0a:	8082                	ret
    return 0;
     b0c:	4501                	li	a0,0
     b0e:	bfe5                	j	b06 <memcmp+0x30>

0000000000000b10 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b10:	1141                	addi	sp,sp,-16
     b12:	e406                	sd	ra,8(sp)
     b14:	e022                	sd	s0,0(sp)
     b16:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     b18:	00000097          	auipc	ra,0x0
     b1c:	f66080e7          	jalr	-154(ra) # a7e <memmove>
}
     b20:	60a2                	ld	ra,8(sp)
     b22:	6402                	ld	s0,0(sp)
     b24:	0141                	addi	sp,sp,16
     b26:	8082                	ret

0000000000000b28 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b28:	4885                	li	a7,1
 ecall
     b2a:	00000073          	ecall
 ret
     b2e:	8082                	ret

0000000000000b30 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b30:	4889                	li	a7,2
 ecall
     b32:	00000073          	ecall
 ret
     b36:	8082                	ret

0000000000000b38 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b38:	488d                	li	a7,3
 ecall
     b3a:	00000073          	ecall
 ret
     b3e:	8082                	ret

0000000000000b40 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b40:	4891                	li	a7,4
 ecall
     b42:	00000073          	ecall
 ret
     b46:	8082                	ret

0000000000000b48 <read>:
.global read
read:
 li a7, SYS_read
     b48:	4895                	li	a7,5
 ecall
     b4a:	00000073          	ecall
 ret
     b4e:	8082                	ret

0000000000000b50 <write>:
.global write
write:
 li a7, SYS_write
     b50:	48c1                	li	a7,16
 ecall
     b52:	00000073          	ecall
 ret
     b56:	8082                	ret

0000000000000b58 <close>:
.global close
close:
 li a7, SYS_close
     b58:	48d5                	li	a7,21
 ecall
     b5a:	00000073          	ecall
 ret
     b5e:	8082                	ret

0000000000000b60 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b60:	4899                	li	a7,6
 ecall
     b62:	00000073          	ecall
 ret
     b66:	8082                	ret

0000000000000b68 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b68:	489d                	li	a7,7
 ecall
     b6a:	00000073          	ecall
 ret
     b6e:	8082                	ret

0000000000000b70 <open>:
.global open
open:
 li a7, SYS_open
     b70:	48bd                	li	a7,15
 ecall
     b72:	00000073          	ecall
 ret
     b76:	8082                	ret

0000000000000b78 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b78:	48c5                	li	a7,17
 ecall
     b7a:	00000073          	ecall
 ret
     b7e:	8082                	ret

0000000000000b80 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b80:	48c9                	li	a7,18
 ecall
     b82:	00000073          	ecall
 ret
     b86:	8082                	ret

0000000000000b88 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b88:	48a1                	li	a7,8
 ecall
     b8a:	00000073          	ecall
 ret
     b8e:	8082                	ret

0000000000000b90 <link>:
.global link
link:
 li a7, SYS_link
     b90:	48cd                	li	a7,19
 ecall
     b92:	00000073          	ecall
 ret
     b96:	8082                	ret

0000000000000b98 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b98:	48d1                	li	a7,20
 ecall
     b9a:	00000073          	ecall
 ret
     b9e:	8082                	ret

0000000000000ba0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ba0:	48a5                	li	a7,9
 ecall
     ba2:	00000073          	ecall
 ret
     ba6:	8082                	ret

0000000000000ba8 <dup>:
.global dup
dup:
 li a7, SYS_dup
     ba8:	48a9                	li	a7,10
 ecall
     baa:	00000073          	ecall
 ret
     bae:	8082                	ret

0000000000000bb0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bb0:	48ad                	li	a7,11
 ecall
     bb2:	00000073          	ecall
 ret
     bb6:	8082                	ret

0000000000000bb8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     bb8:	48b1                	li	a7,12
 ecall
     bba:	00000073          	ecall
 ret
     bbe:	8082                	ret

0000000000000bc0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     bc0:	48b5                	li	a7,13
 ecall
     bc2:	00000073          	ecall
 ret
     bc6:	8082                	ret

0000000000000bc8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     bc8:	48b9                	li	a7,14
 ecall
     bca:	00000073          	ecall
 ret
     bce:	8082                	ret

0000000000000bd0 <ps>:
.global ps
ps:
 li a7, SYS_ps
     bd0:	48d9                	li	a7,22
 ecall
     bd2:	00000073          	ecall
 ret
     bd6:	8082                	ret

0000000000000bd8 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     bd8:	48dd                	li	a7,23
 ecall
     bda:	00000073          	ecall
 ret
     bde:	8082                	ret

0000000000000be0 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     be0:	48e1                	li	a7,24
 ecall
     be2:	00000073          	ecall
 ret
     be6:	8082                	ret

0000000000000be8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     be8:	1101                	addi	sp,sp,-32
     bea:	ec06                	sd	ra,24(sp)
     bec:	e822                	sd	s0,16(sp)
     bee:	1000                	addi	s0,sp,32
     bf0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bf4:	4605                	li	a2,1
     bf6:	fef40593          	addi	a1,s0,-17
     bfa:	00000097          	auipc	ra,0x0
     bfe:	f56080e7          	jalr	-170(ra) # b50 <write>
}
     c02:	60e2                	ld	ra,24(sp)
     c04:	6442                	ld	s0,16(sp)
     c06:	6105                	addi	sp,sp,32
     c08:	8082                	ret

0000000000000c0a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c0a:	7139                	addi	sp,sp,-64
     c0c:	fc06                	sd	ra,56(sp)
     c0e:	f822                	sd	s0,48(sp)
     c10:	f426                	sd	s1,40(sp)
     c12:	f04a                	sd	s2,32(sp)
     c14:	ec4e                	sd	s3,24(sp)
     c16:	0080                	addi	s0,sp,64
     c18:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c1a:	c299                	beqz	a3,c20 <printint+0x16>
     c1c:	0805c963          	bltz	a1,cae <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c20:	2581                	sext.w	a1,a1
  neg = 0;
     c22:	4881                	li	a7,0
     c24:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c28:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c2a:	2601                	sext.w	a2,a2
     c2c:	00000517          	auipc	a0,0x0
     c30:	68450513          	addi	a0,a0,1668 # 12b0 <digits>
     c34:	883a                	mv	a6,a4
     c36:	2705                	addiw	a4,a4,1
     c38:	02c5f7bb          	remuw	a5,a1,a2
     c3c:	1782                	slli	a5,a5,0x20
     c3e:	9381                	srli	a5,a5,0x20
     c40:	97aa                	add	a5,a5,a0
     c42:	0007c783          	lbu	a5,0(a5)
     c46:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c4a:	0005879b          	sext.w	a5,a1
     c4e:	02c5d5bb          	divuw	a1,a1,a2
     c52:	0685                	addi	a3,a3,1
     c54:	fec7f0e3          	bgeu	a5,a2,c34 <printint+0x2a>
  if(neg)
     c58:	00088c63          	beqz	a7,c70 <printint+0x66>
    buf[i++] = '-';
     c5c:	fd070793          	addi	a5,a4,-48
     c60:	00878733          	add	a4,a5,s0
     c64:	02d00793          	li	a5,45
     c68:	fef70823          	sb	a5,-16(a4)
     c6c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     c70:	02e05863          	blez	a4,ca0 <printint+0x96>
     c74:	fc040793          	addi	a5,s0,-64
     c78:	00e78933          	add	s2,a5,a4
     c7c:	fff78993          	addi	s3,a5,-1
     c80:	99ba                	add	s3,s3,a4
     c82:	377d                	addiw	a4,a4,-1
     c84:	1702                	slli	a4,a4,0x20
     c86:	9301                	srli	a4,a4,0x20
     c88:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c8c:	fff94583          	lbu	a1,-1(s2)
     c90:	8526                	mv	a0,s1
     c92:	00000097          	auipc	ra,0x0
     c96:	f56080e7          	jalr	-170(ra) # be8 <putc>
  while(--i >= 0)
     c9a:	197d                	addi	s2,s2,-1
     c9c:	ff3918e3          	bne	s2,s3,c8c <printint+0x82>
}
     ca0:	70e2                	ld	ra,56(sp)
     ca2:	7442                	ld	s0,48(sp)
     ca4:	74a2                	ld	s1,40(sp)
     ca6:	7902                	ld	s2,32(sp)
     ca8:	69e2                	ld	s3,24(sp)
     caa:	6121                	addi	sp,sp,64
     cac:	8082                	ret
    x = -xx;
     cae:	40b005bb          	negw	a1,a1
    neg = 1;
     cb2:	4885                	li	a7,1
    x = -xx;
     cb4:	bf85                	j	c24 <printint+0x1a>

0000000000000cb6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cb6:	7119                	addi	sp,sp,-128
     cb8:	fc86                	sd	ra,120(sp)
     cba:	f8a2                	sd	s0,112(sp)
     cbc:	f4a6                	sd	s1,104(sp)
     cbe:	f0ca                	sd	s2,96(sp)
     cc0:	ecce                	sd	s3,88(sp)
     cc2:	e8d2                	sd	s4,80(sp)
     cc4:	e4d6                	sd	s5,72(sp)
     cc6:	e0da                	sd	s6,64(sp)
     cc8:	fc5e                	sd	s7,56(sp)
     cca:	f862                	sd	s8,48(sp)
     ccc:	f466                	sd	s9,40(sp)
     cce:	f06a                	sd	s10,32(sp)
     cd0:	ec6e                	sd	s11,24(sp)
     cd2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cd4:	0005c903          	lbu	s2,0(a1)
     cd8:	18090f63          	beqz	s2,e76 <vprintf+0x1c0>
     cdc:	8aaa                	mv	s5,a0
     cde:	8b32                	mv	s6,a2
     ce0:	00158493          	addi	s1,a1,1
  state = 0;
     ce4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ce6:	02500a13          	li	s4,37
     cea:	4c55                	li	s8,21
     cec:	00000c97          	auipc	s9,0x0
     cf0:	56cc8c93          	addi	s9,s9,1388 # 1258 <__FUNCTION__.5+0x70>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     cf4:	02800d93          	li	s11,40
  putc(fd, 'x');
     cf8:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     cfa:	00000b97          	auipc	s7,0x0
     cfe:	5b6b8b93          	addi	s7,s7,1462 # 12b0 <digits>
     d02:	a839                	j	d20 <vprintf+0x6a>
        putc(fd, c);
     d04:	85ca                	mv	a1,s2
     d06:	8556                	mv	a0,s5
     d08:	00000097          	auipc	ra,0x0
     d0c:	ee0080e7          	jalr	-288(ra) # be8 <putc>
     d10:	a019                	j	d16 <vprintf+0x60>
    } else if(state == '%'){
     d12:	01498d63          	beq	s3,s4,d2c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     d16:	0485                	addi	s1,s1,1
     d18:	fff4c903          	lbu	s2,-1(s1)
     d1c:	14090d63          	beqz	s2,e76 <vprintf+0x1c0>
    if(state == 0){
     d20:	fe0999e3          	bnez	s3,d12 <vprintf+0x5c>
      if(c == '%'){
     d24:	ff4910e3          	bne	s2,s4,d04 <vprintf+0x4e>
        state = '%';
     d28:	89d2                	mv	s3,s4
     d2a:	b7f5                	j	d16 <vprintf+0x60>
      if(c == 'd'){
     d2c:	11490c63          	beq	s2,s4,e44 <vprintf+0x18e>
     d30:	f9d9079b          	addiw	a5,s2,-99
     d34:	0ff7f793          	zext.b	a5,a5
     d38:	10fc6e63          	bltu	s8,a5,e54 <vprintf+0x19e>
     d3c:	f9d9079b          	addiw	a5,s2,-99
     d40:	0ff7f713          	zext.b	a4,a5
     d44:	10ec6863          	bltu	s8,a4,e54 <vprintf+0x19e>
     d48:	00271793          	slli	a5,a4,0x2
     d4c:	97e6                	add	a5,a5,s9
     d4e:	439c                	lw	a5,0(a5)
     d50:	97e6                	add	a5,a5,s9
     d52:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d54:	008b0913          	addi	s2,s6,8
     d58:	4685                	li	a3,1
     d5a:	4629                	li	a2,10
     d5c:	000b2583          	lw	a1,0(s6)
     d60:	8556                	mv	a0,s5
     d62:	00000097          	auipc	ra,0x0
     d66:	ea8080e7          	jalr	-344(ra) # c0a <printint>
     d6a:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d6c:	4981                	li	s3,0
     d6e:	b765                	j	d16 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d70:	008b0913          	addi	s2,s6,8
     d74:	4681                	li	a3,0
     d76:	4629                	li	a2,10
     d78:	000b2583          	lw	a1,0(s6)
     d7c:	8556                	mv	a0,s5
     d7e:	00000097          	auipc	ra,0x0
     d82:	e8c080e7          	jalr	-372(ra) # c0a <printint>
     d86:	8b4a                	mv	s6,s2
      state = 0;
     d88:	4981                	li	s3,0
     d8a:	b771                	j	d16 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     d8c:	008b0913          	addi	s2,s6,8
     d90:	4681                	li	a3,0
     d92:	866a                	mv	a2,s10
     d94:	000b2583          	lw	a1,0(s6)
     d98:	8556                	mv	a0,s5
     d9a:	00000097          	auipc	ra,0x0
     d9e:	e70080e7          	jalr	-400(ra) # c0a <printint>
     da2:	8b4a                	mv	s6,s2
      state = 0;
     da4:	4981                	li	s3,0
     da6:	bf85                	j	d16 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     da8:	008b0793          	addi	a5,s6,8
     dac:	f8f43423          	sd	a5,-120(s0)
     db0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     db4:	03000593          	li	a1,48
     db8:	8556                	mv	a0,s5
     dba:	00000097          	auipc	ra,0x0
     dbe:	e2e080e7          	jalr	-466(ra) # be8 <putc>
  putc(fd, 'x');
     dc2:	07800593          	li	a1,120
     dc6:	8556                	mv	a0,s5
     dc8:	00000097          	auipc	ra,0x0
     dcc:	e20080e7          	jalr	-480(ra) # be8 <putc>
     dd0:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     dd2:	03c9d793          	srli	a5,s3,0x3c
     dd6:	97de                	add	a5,a5,s7
     dd8:	0007c583          	lbu	a1,0(a5)
     ddc:	8556                	mv	a0,s5
     dde:	00000097          	auipc	ra,0x0
     de2:	e0a080e7          	jalr	-502(ra) # be8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     de6:	0992                	slli	s3,s3,0x4
     de8:	397d                	addiw	s2,s2,-1
     dea:	fe0914e3          	bnez	s2,dd2 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
     dee:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     df2:	4981                	li	s3,0
     df4:	b70d                	j	d16 <vprintf+0x60>
        s = va_arg(ap, char*);
     df6:	008b0913          	addi	s2,s6,8
     dfa:	000b3983          	ld	s3,0(s6)
        if(s == 0)
     dfe:	02098163          	beqz	s3,e20 <vprintf+0x16a>
        while(*s != 0){
     e02:	0009c583          	lbu	a1,0(s3)
     e06:	c5ad                	beqz	a1,e70 <vprintf+0x1ba>
          putc(fd, *s);
     e08:	8556                	mv	a0,s5
     e0a:	00000097          	auipc	ra,0x0
     e0e:	dde080e7          	jalr	-546(ra) # be8 <putc>
          s++;
     e12:	0985                	addi	s3,s3,1
        while(*s != 0){
     e14:	0009c583          	lbu	a1,0(s3)
     e18:	f9e5                	bnez	a1,e08 <vprintf+0x152>
        s = va_arg(ap, char*);
     e1a:	8b4a                	mv	s6,s2
      state = 0;
     e1c:	4981                	li	s3,0
     e1e:	bde5                	j	d16 <vprintf+0x60>
          s = "(null)";
     e20:	00000997          	auipc	s3,0x0
     e24:	43098993          	addi	s3,s3,1072 # 1250 <__FUNCTION__.5+0x68>
        while(*s != 0){
     e28:	85ee                	mv	a1,s11
     e2a:	bff9                	j	e08 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
     e2c:	008b0913          	addi	s2,s6,8
     e30:	000b4583          	lbu	a1,0(s6)
     e34:	8556                	mv	a0,s5
     e36:	00000097          	auipc	ra,0x0
     e3a:	db2080e7          	jalr	-590(ra) # be8 <putc>
     e3e:	8b4a                	mv	s6,s2
      state = 0;
     e40:	4981                	li	s3,0
     e42:	bdd1                	j	d16 <vprintf+0x60>
        putc(fd, c);
     e44:	85d2                	mv	a1,s4
     e46:	8556                	mv	a0,s5
     e48:	00000097          	auipc	ra,0x0
     e4c:	da0080e7          	jalr	-608(ra) # be8 <putc>
      state = 0;
     e50:	4981                	li	s3,0
     e52:	b5d1                	j	d16 <vprintf+0x60>
        putc(fd, '%');
     e54:	85d2                	mv	a1,s4
     e56:	8556                	mv	a0,s5
     e58:	00000097          	auipc	ra,0x0
     e5c:	d90080e7          	jalr	-624(ra) # be8 <putc>
        putc(fd, c);
     e60:	85ca                	mv	a1,s2
     e62:	8556                	mv	a0,s5
     e64:	00000097          	auipc	ra,0x0
     e68:	d84080e7          	jalr	-636(ra) # be8 <putc>
      state = 0;
     e6c:	4981                	li	s3,0
     e6e:	b565                	j	d16 <vprintf+0x60>
        s = va_arg(ap, char*);
     e70:	8b4a                	mv	s6,s2
      state = 0;
     e72:	4981                	li	s3,0
     e74:	b54d                	j	d16 <vprintf+0x60>
    }
  }
}
     e76:	70e6                	ld	ra,120(sp)
     e78:	7446                	ld	s0,112(sp)
     e7a:	74a6                	ld	s1,104(sp)
     e7c:	7906                	ld	s2,96(sp)
     e7e:	69e6                	ld	s3,88(sp)
     e80:	6a46                	ld	s4,80(sp)
     e82:	6aa6                	ld	s5,72(sp)
     e84:	6b06                	ld	s6,64(sp)
     e86:	7be2                	ld	s7,56(sp)
     e88:	7c42                	ld	s8,48(sp)
     e8a:	7ca2                	ld	s9,40(sp)
     e8c:	7d02                	ld	s10,32(sp)
     e8e:	6de2                	ld	s11,24(sp)
     e90:	6109                	addi	sp,sp,128
     e92:	8082                	ret

0000000000000e94 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e94:	715d                	addi	sp,sp,-80
     e96:	ec06                	sd	ra,24(sp)
     e98:	e822                	sd	s0,16(sp)
     e9a:	1000                	addi	s0,sp,32
     e9c:	e010                	sd	a2,0(s0)
     e9e:	e414                	sd	a3,8(s0)
     ea0:	e818                	sd	a4,16(s0)
     ea2:	ec1c                	sd	a5,24(s0)
     ea4:	03043023          	sd	a6,32(s0)
     ea8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     eac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     eb0:	8622                	mv	a2,s0
     eb2:	00000097          	auipc	ra,0x0
     eb6:	e04080e7          	jalr	-508(ra) # cb6 <vprintf>
}
     eba:	60e2                	ld	ra,24(sp)
     ebc:	6442                	ld	s0,16(sp)
     ebe:	6161                	addi	sp,sp,80
     ec0:	8082                	ret

0000000000000ec2 <printf>:

void
printf(const char *fmt, ...)
{
     ec2:	711d                	addi	sp,sp,-96
     ec4:	ec06                	sd	ra,24(sp)
     ec6:	e822                	sd	s0,16(sp)
     ec8:	1000                	addi	s0,sp,32
     eca:	e40c                	sd	a1,8(s0)
     ecc:	e810                	sd	a2,16(s0)
     ece:	ec14                	sd	a3,24(s0)
     ed0:	f018                	sd	a4,32(s0)
     ed2:	f41c                	sd	a5,40(s0)
     ed4:	03043823          	sd	a6,48(s0)
     ed8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     edc:	00840613          	addi	a2,s0,8
     ee0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     ee4:	85aa                	mv	a1,a0
     ee6:	4505                	li	a0,1
     ee8:	00000097          	auipc	ra,0x0
     eec:	dce080e7          	jalr	-562(ra) # cb6 <vprintf>
}
     ef0:	60e2                	ld	ra,24(sp)
     ef2:	6442                	ld	s0,16(sp)
     ef4:	6125                	addi	sp,sp,96
     ef6:	8082                	ret

0000000000000ef8 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     ef8:	1141                	addi	sp,sp,-16
     efa:	e422                	sd	s0,8(sp)
     efc:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     efe:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f02:	00001797          	auipc	a5,0x1
     f06:	1067b783          	ld	a5,262(a5) # 2008 <freep>
     f0a:	a02d                	j	f34 <free+0x3c>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
            break;
    if (bp + bp->s.size == p->s.ptr)
    {
        bp->s.size += p->s.ptr->s.size;
     f0c:	4618                	lw	a4,8(a2)
     f0e:	9f2d                	addw	a4,a4,a1
     f10:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     f14:	6398                	ld	a4,0(a5)
     f16:	6310                	ld	a2,0(a4)
     f18:	a83d                	j	f56 <free+0x5e>
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    {
        p->s.size += bp->s.size;
     f1a:	ff852703          	lw	a4,-8(a0)
     f1e:	9f31                	addw	a4,a4,a2
     f20:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     f22:	ff053683          	ld	a3,-16(a0)
     f26:	a091                	j	f6a <free+0x72>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f28:	6398                	ld	a4,0(a5)
     f2a:	00e7e463          	bltu	a5,a4,f32 <free+0x3a>
     f2e:	00e6ea63          	bltu	a3,a4,f42 <free+0x4a>
{
     f32:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f34:	fed7fae3          	bgeu	a5,a3,f28 <free+0x30>
     f38:	6398                	ld	a4,0(a5)
     f3a:	00e6e463          	bltu	a3,a4,f42 <free+0x4a>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f3e:	fee7eae3          	bltu	a5,a4,f32 <free+0x3a>
    if (bp + bp->s.size == p->s.ptr)
     f42:	ff852583          	lw	a1,-8(a0)
     f46:	6390                	ld	a2,0(a5)
     f48:	02059813          	slli	a6,a1,0x20
     f4c:	01c85713          	srli	a4,a6,0x1c
     f50:	9736                	add	a4,a4,a3
     f52:	fae60de3          	beq	a2,a4,f0c <free+0x14>
        bp->s.ptr = p->s.ptr->s.ptr;
     f56:	fec53823          	sd	a2,-16(a0)
    if (p + p->s.size == bp)
     f5a:	4790                	lw	a2,8(a5)
     f5c:	02061593          	slli	a1,a2,0x20
     f60:	01c5d713          	srli	a4,a1,0x1c
     f64:	973e                	add	a4,a4,a5
     f66:	fae68ae3          	beq	a3,a4,f1a <free+0x22>
        p->s.ptr = bp->s.ptr;
     f6a:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     f6c:	00001717          	auipc	a4,0x1
     f70:	08f73e23          	sd	a5,156(a4) # 2008 <freep>
}
     f74:	6422                	ld	s0,8(sp)
     f76:	0141                	addi	sp,sp,16
     f78:	8082                	ret

0000000000000f7a <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     f7a:	7139                	addi	sp,sp,-64
     f7c:	fc06                	sd	ra,56(sp)
     f7e:	f822                	sd	s0,48(sp)
     f80:	f426                	sd	s1,40(sp)
     f82:	f04a                	sd	s2,32(sp)
     f84:	ec4e                	sd	s3,24(sp)
     f86:	e852                	sd	s4,16(sp)
     f88:	e456                	sd	s5,8(sp)
     f8a:	e05a                	sd	s6,0(sp)
     f8c:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     f8e:	02051493          	slli	s1,a0,0x20
     f92:	9081                	srli	s1,s1,0x20
     f94:	04bd                	addi	s1,s1,15
     f96:	8091                	srli	s1,s1,0x4
     f98:	0014899b          	addiw	s3,s1,1
     f9c:	0485                	addi	s1,s1,1
    if ((prevp = freep) == 0)
     f9e:	00001517          	auipc	a0,0x1
     fa2:	06a53503          	ld	a0,106(a0) # 2008 <freep>
     fa6:	c515                	beqz	a0,fd2 <malloc+0x58>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     fa8:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
     faa:	4798                	lw	a4,8(a5)
     fac:	02977f63          	bgeu	a4,s1,fea <malloc+0x70>
     fb0:	8a4e                	mv	s4,s3
     fb2:	0009871b          	sext.w	a4,s3
     fb6:	6685                	lui	a3,0x1
     fb8:	00d77363          	bgeu	a4,a3,fbe <malloc+0x44>
     fbc:	6a05                	lui	s4,0x1
     fbe:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
     fc2:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
     fc6:	00001917          	auipc	s2,0x1
     fca:	04290913          	addi	s2,s2,66 # 2008 <freep>
    if (p == (char *)-1)
     fce:	5afd                	li	s5,-1
     fd0:	a895                	j	1044 <malloc+0xca>
        base.s.ptr = freep = prevp = &base;
     fd2:	00001797          	auipc	a5,0x1
     fd6:	05678793          	addi	a5,a5,86 # 2028 <base>
     fda:	00001717          	auipc	a4,0x1
     fde:	02f73723          	sd	a5,46(a4) # 2008 <freep>
     fe2:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
     fe4:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
     fe8:	b7e1                	j	fb0 <malloc+0x36>
            if (p->s.size == nunits)
     fea:	02e48c63          	beq	s1,a4,1022 <malloc+0xa8>
                p->s.size -= nunits;
     fee:	4137073b          	subw	a4,a4,s3
     ff2:	c798                	sw	a4,8(a5)
                p += p->s.size;
     ff4:	02071693          	slli	a3,a4,0x20
     ff8:	01c6d713          	srli	a4,a3,0x1c
     ffc:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
     ffe:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    1002:	00001717          	auipc	a4,0x1
    1006:	00a73323          	sd	a0,6(a4) # 2008 <freep>
            return (void *)(p + 1);
    100a:	01078513          	addi	a0,a5,16
            if ((p = morecore(nunits)) == 0)
                return 0;
    }
}
    100e:	70e2                	ld	ra,56(sp)
    1010:	7442                	ld	s0,48(sp)
    1012:	74a2                	ld	s1,40(sp)
    1014:	7902                	ld	s2,32(sp)
    1016:	69e2                	ld	s3,24(sp)
    1018:	6a42                	ld	s4,16(sp)
    101a:	6aa2                	ld	s5,8(sp)
    101c:	6b02                	ld	s6,0(sp)
    101e:	6121                	addi	sp,sp,64
    1020:	8082                	ret
                prevp->s.ptr = p->s.ptr;
    1022:	6398                	ld	a4,0(a5)
    1024:	e118                	sd	a4,0(a0)
    1026:	bff1                	j	1002 <malloc+0x88>
    hp->s.size = nu;
    1028:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    102c:	0541                	addi	a0,a0,16
    102e:	00000097          	auipc	ra,0x0
    1032:	eca080e7          	jalr	-310(ra) # ef8 <free>
    return freep;
    1036:	00093503          	ld	a0,0(s2)
            if ((p = morecore(nunits)) == 0)
    103a:	d971                	beqz	a0,100e <malloc+0x94>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    103c:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    103e:	4798                	lw	a4,8(a5)
    1040:	fa9775e3          	bgeu	a4,s1,fea <malloc+0x70>
        if (p == freep)
    1044:	00093703          	ld	a4,0(s2)
    1048:	853e                	mv	a0,a5
    104a:	fef719e3          	bne	a4,a5,103c <malloc+0xc2>
    p = sbrk(nu * sizeof(Header));
    104e:	8552                	mv	a0,s4
    1050:	00000097          	auipc	ra,0x0
    1054:	b68080e7          	jalr	-1176(ra) # bb8 <sbrk>
    if (p == (char *)-1)
    1058:	fd5518e3          	bne	a0,s5,1028 <malloc+0xae>
                return 0;
    105c:	4501                	li	a0,0
    105e:	bf45                	j	100e <malloc+0x94>
