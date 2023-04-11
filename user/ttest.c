#include "kernel/types.h"
#include "user.h"

struct arg
{
    int a;
    int b;
};
int shared_state = 0;
struct lock shared_state_lock;

// expected output: shared state = 2 in the end
void *race_for_state(void *arg)
{
    struct arg args = *(struct arg *)arg;
    printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
    if (shared_state == 0)
    {
        tyield();
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
        shared_state += args.a;
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
        tyield();
    }
    else
    {
        tyield();
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
        shared_state += args.b;
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
        tyield();
    }
    return 0;
}

// expected output: shared state = 3 in the end
void *no_race_for_state(void *arg)
{
    struct arg args = *(struct arg *)arg;
    printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
    acquire(&shared_state_lock);
    if (shared_state == 0)
    {
        tyield();
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
        shared_state += args.a;
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
        tyield();
    }
    else
    {
        tyield();
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
        shared_state += args.b;
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
        tyield();
    }
    release(&shared_state_lock);
    return 0;
}

void *print_hello_world(void *arg)
{
    printf("Hello World\n");
    return 0;
}

void *print_hello_world_with_tid(void *arg)
{
    printf("Hello World from Thread %d\n", twhoami());
    return 0;
}

void *calculate_rv(void *arg)
{
    struct arg args = *(struct arg *)arg;
    printf("child args: a=%d, b=%d\n", args.a, args.b);
    int *result = (int *)malloc(sizeof(int));
    *result = args.a + args.b;
    printf("child result: %d\n", *result);
    return (void *)result;
}

void test1()
{
    printf("[%s enter]\n", __FUNCTION__);
    struct thread *t;
    tcreate(&t, 0, &print_hello_world, 0);
    tyield();
    printf("[%s exit]\n", __FUNCTION__);
}

void test2()
{
    printf("[%s enter]\n", __FUNCTION__);
    struct thread *threadpool[8] = {0};
    for (int i = 0; i < 8; i++)
    {
        tcreate(&threadpool[i], 0, &print_hello_world_with_tid, 0);
    }
    for (int i = 0; i < 8; i++)
    {
        tjoin(threadpool[i]->tid, 0, 0);
    }
    printf("[%s exit]\n", __FUNCTION__);
}

void test3()
{
    printf("[%s enter]\n", __FUNCTION__);
    struct thread *t;
    struct thread_attr tattr;
    tattr.res_size = sizeof(int);
    tattr.stacksize = 512;
    struct arg args;
    args.a = 1;
    args.b = 10;
    tcreate(&t, &tattr, &calculate_rv, &args);
    int result;
    tjoin(t->tid, &result, sizeof(int));
    printf("parent result: %d\n", result);
    printf("[%s exit]\n", __FUNCTION__);
}

void test4()
{
    printf("[%s enter]\n", __FUNCTION__);
    struct thread *ta;
    struct thread *tb;
    struct arg args;
    args.a = 1;
    args.b = 2;
    tcreate(&ta, 0, &race_for_state, &args);
    tcreate(&tb, 0, &race_for_state, &args);
    tyield();
    tjoin(ta->tid, 0, 0);
    tjoin(tb->tid, 0, 0);
    printf("[%s exit]\n", __FUNCTION__);
}

void test5()
{
    printf("[%s enter]\n", __FUNCTION__);
    initlock(&shared_state_lock, "sharedstate lock");
    struct thread *ta;
    struct thread *tb;
    struct arg args;
    args.a = 1;
    args.b = 2;
    tcreate(&ta, 0, &no_race_for_state, &args);
    tcreate(&tb, 0, &no_race_for_state, &args);
    tyield();
    tjoin(ta->tid, 0, 0);
    tjoin(tb->tid, 0, 0);
    printf("[%s exit]\n", __FUNCTION__);
}
int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("ttest TEST_ID\n TEST ID\tId of the test to run. ID can be any value from 1 to 5\n");
        return -1;
    }

    switch (atoi(argv[1]))
    {
    case 1:
        test1();
        break;

    case 2:
        test2();
        break;

    case 3:
        test3();
        break;

    case 4:
        test4();
        break;

    case 5:
        test5();
        break;

    default:
        printf("Error: No test with index %s\n", argv[1]);
        return -1;
    }
    return 0;
    return 0;
}