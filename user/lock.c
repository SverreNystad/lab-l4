// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
    lk->name = name;
    lk->locked = 0;
    lk->tid = -1;
}

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
}

void acquire(struct lock *lk)
{
    if (holding(lk))
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    {
        // give up the cpu for other threads
        tyield();
    }

    __sync_synchronize();

    lk->tid = twhoami();
}

void release(struct lock *lk)
{
    if (!holding(lk))
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
    __sync_synchronize();
    __sync_lock_release(&lk->locked);
    tyield(); // yield that other threads that need the lock can grab it
}
