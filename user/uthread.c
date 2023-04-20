#include "kernel/types.h"
#include "user.h"
#define MAX_THREADS 64
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

struct lock tid_lock;
int next_tid;
struct thread threads[64];
struct thread *current_thread;
int thread_count = 0;

void tsched()
{
    struct thread *t;

    // Loop through all threads in the thread table
    for (t = threads; t < &threads[MAX_THREADS]; t++)
    {
        
        if (t->state == RUNNABLE)
        {
            // Switch to chosen process.  It is the process's job
            // to release its lock and then reacquire it
            // before jumping back to us.
            current_thread->state = RUNNABLE; // er kanskje ikke nødvendig

            struct thread *old_thread = current_thread;
            struct context old_context = old_thread->tcontext;
            struct context new_context = t->tcontext;

            if (old_thread->tid == t->tid)
            {   
                printf("Thread %d is already running", t->tid);
                continue;
            }
            current_thread = t;
            current_thread->state = RUNNING;
            tswtch(&old_context, &new_context); // Must do all logic before tswtch it does not come back 
            // Process is done running for now.
        }
        
    }
    
}

/// @brief Will find the next free thread ID
uint8 new_thread_id()
{
    // convert int to uint8
    uint8 new_tid = (uint8) thread_count + 1;
    return new_tid;
}

void add_thread_to_table(struct thread *thread)
{
    threads[thread->tid] = *thread;
    thread_count++;
    // printf("Added thread %d to table, thread count: %d", thread->tid, thread_count);
}

void tentry() 
{
    (current_thread->func(&current_thread->arg));
}

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
    printf("Creating new thread\n");
    *thread = (struct thread*) malloc(sizeof(struct thread));
    
    // Set the thread attributes
    (*thread)->tid = new_thread_id(); // Set the initial thread ID (you might need to implement a way to generate unique thread IDs)
    printf("Thread ID: %d\n", (*thread)->tid);   
    (*thread)->tcontext = (struct context) {0}; // Initialize the thread context to all zeros
    
    // Set the stack pointer to the top of the stack
    if (attr == 0)
    {
        (*thread)->tcontext.sp = (uint64) malloc(4096) + 4096; // same as pagesize
    }
    else 
    {
        (*thread)->tcontext.sp = (uint64) malloc(attr->stacksize) + attr->stacksize;
    }
    printf("Thread context sp: %d\n", (*thread)->tcontext.sp);
    
    (*thread)->tcontext.ra = (uint64) &tentry; // Set the return address to the thread entry function
    printf("Thread context ra: %d\n", (*thread)->tcontext.ra);

    (*thread)->state = RUNNABLE;
    (*thread)->arg = arg; // Set the thread function argument
    (*thread)->func = func; // Set the thread function pointer
    printf("Thread func pos: %d\n", (*thread)->func);
    // func(arg);
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
    current_thread->state = RUNNABLE;
    tsched();
}

uint8 twhoami()
{
    // TODO: Returns the thread id of the current thread
    
    return current_thread->tid;
}
