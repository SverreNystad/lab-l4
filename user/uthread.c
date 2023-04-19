#include "kernel/types.h"
// #include "kernal/riscv.h"
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

    // Loop through all threads in the thread table
    for (t = threads[0]; t < &threads[MAX_THREADS]; t++)
    {
        // If the thread is runnable, switch to it
        if (t->state == RUNNABLE)
        {
            current_thread = t;
            t->state = RUNNING;
            tswtch(&current_thread->tcontext, &t->tcontext);
            t->state = RUNNABLE;
        }
    }
}

void tentry() 
{
    (current_thread->func(&current_thread->arg));
}

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
    *thread = (struct thread*) malloc(sizeof(struct thread));
    
    // Set the thread attributes
    (*thread)->tid = new_thread_id(); // Set the initial thread ID (you might need to implement a way to generate unique thread IDs)
    (*thread)->tcontext = (struct context) {0}; // Initialize the thread context to all zeros
    
    (*thread)->tcontext.ra = (uint64) &tentry; // Set the return address to the thread entry function
    
    // Set the stack pointer to the top of the stack
    if (attr == 0)
    {
        (*thread)->tcontext.sp = (uint64) malloc(4096) + 4096; // same as pagesize
    }
    else 
    {
        (*thread)->tcontext.sp = (uint64) malloc(attr->stacksize) + attr->stacksize;
    }
    (*thread)->state = RUNNABLE;
    (*thread)->arg = arg; // Set the thread function argument
    (*thread)->func = func; // Set the thread function pointer

    add_thread_to_table(*thread);
}



int tjoin(int tid, void *status, uint size)
{
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.

    thread_count--;
    // if (&status != 0 && size != 0)
    // {
    //     memcpy(status, *(&threads[tid]->return_value), size);
    // }
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
