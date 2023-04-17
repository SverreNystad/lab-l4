#include "kernel/types.h"
#include "user.h"

#define MAX_THREADS 64
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

/// @brief This is the thread table, storing all threads of a process
struct thread *threads[MAX_THREADS];
struct thread *current_thread;
int thread_count = 0;

/// @brief Will find the next free thread ID
uint8 new_thread_id()
{
    // convert int to uint8
    uint8 new_tid = (uint8) thread_count++;
    return new_tid;
}

void add_thread_to_table(struct thread *thread)
{
    threads[thread->tid] = thread;
    thread_count++;
    printf("Added thread %d to table, thread count: %d", thread->tid, thread_count);
}

void tsched()
{
    // TODO: Implement a userspace round robin scheduler that switches to the next thread
    // struct user_proc *up;
    struct thread *t;


    // c->proc = 0;
    // intr_on();

    // for (p = proc; p < &proc[NPROC]; p++)
    // {
    //     acquire(&p->lock);
    //     if (p->state == RUNNABLE)
    //     {
    //         // Switch to chosen process.  It is the process's job
    //         // to release its lock and then reacquire it
    //         // before jumping back to us.
    //         p->state = RUNNING;
    //         c->proc = p;
    //         swtch(&c->context, &p->context);

    //         // Process is done running for now.
    //         // It should have changed its p->state before coming back.
    //         c->proc = 0;
    //     }
    //     release(&p->lock);
    // }
}


void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
    *thread = (struct thread*) malloc(sizeof(struct thread));
    
    // Set the thread attributes
    (*thread)->tid = new_thread_id(); // Set the initial thread ID (you might need to implement a way to generate unique thread IDs)
    (*thread)->tcontext = (struct context) {0}; // Initialize the thread context to all zeros
    (*thread)->state = RUNNABLE;
    (*thread)->arg = arg; // Set the thread function argument
    (*thread)->func = func; // Set the thread function pointer

    add_thread_to_table(*thread);

    (*thread)->return_value = (*thread)->func(arg);
}



int tjoin(int tid, void *status, uint size)
{
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.

    thread_count--;
    if (&status != 0 && size != 0)
    {
        memcpy(status, threads[tid]->return_value, size);
    }
    return current_thread->return_value;
}

void tyield()
{
    // TODO: Implement the yielding behaviour of the thread
    // Switch to the next runnable thread
    current_thread->state = RUNNABLE;
    tsched();
}

uint8 twhoami()
{
    // TODO: Returns the thread id of the current thread
    uint8 tid = current_thread->tid;
    return tid;
}
