#include "kernel/types.h"
#include "user.h"
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

void tsched()
{
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
}

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
}

int tjoin(int tid, void *status, uint size)
{
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    return 0;
}

void tyield()
{
    // TODO: Implement the yielding behaviour of the thread
}

uint8 twhoami()
{
    // TODO: Returns the thread id of the current thread
    return 0;
}
