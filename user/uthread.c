#include "kernel/types.h"
#include "user.h"
#define MAX_THREADS 64
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

struct lock tid_lock;
int next_tid;
struct thread *threads[64];
struct thread *current_thread;
int thread_count = 0;


void tsched()
{
    int current_thread_index = current_thread->tid;
    int next_thread_index = current_thread_index + 1;
    struct thread *t;
    for (int i = next_thread_index + 1; i % MAX_THREADS !=current_thread_index; i++){
        // Find next runnable thread
        t = (struct thread*) threads[i % MAX_THREADS];

        if (t->state == RUNNABLE)
        {
            t->state = RUNNING;
            current_thread = t;
            tswtch(&(threads[current_thread_index]->tcontext),&(t->tcontext));
            break;
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
    threads[thread->tid] = thread;
    thread_count++;
    // printf("Added thread %d to table, thread count: %d", thread->tid, thread_count);
}

/// @brief wrapper for the thread entry function to ensure that the thread can be setup correctly
/// and that the thread can be cleaned up correctly
void thread_entry() 
{
    void *return_value = (current_thread->func(&current_thread->arg));
    if (current_thread->return_value != 0)
    {
        current_thread->return_value = return_value;
    }
    current_thread->state = EXITED;
    tyield();
}

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
    // TODO: Create a new process and add it as runnable, such that it starts running
    // once the scheduler schedules it the next time
    // printf("Creating new thread\n");
    *thread = (struct thread*) malloc(sizeof(struct thread));
    
    // Set the thread attributes
    (*thread)->tid = new_thread_id(); // Set the initial thread ID (you might need to implement a way to generate unique thread IDs)
    // printf("Thread ID: %d\n", (*thread)->tid);   
    (*thread)->tcontext = (struct context) {0}; // Initialize the thread context to all zeros
    
    // Set the stack pointer to the top of the stack
    if (attr == 0)
    {
        // Use default stack size is the same as pagesize
        (*thread)->tcontext.sp = (uint64) malloc(4096) + 4096; 
    }
    else 
    {
        (*thread)->tcontext.sp = (uint64) malloc(attr->stacksize) + attr->stacksize;
    }
    // printf("Thread context sp: %d\n", (*thread)->tcontext.sp);
    
    (*thread)->tcontext.ra = (uint64) &thread_entry; // Set the return address to the thread entry function
    // printf("Thread context ra: %d\n", (*thread)->tcontext.ra);
    (*thread)->arg = arg; // Set the thread function argument
    (*thread)->func = func; // Set the thread function pointer
    // printf("Thread func pos: %d\n", (*thread)->func);
    add_thread_to_table(*thread);
}

int tjoin(int tid, void *status, uint size)
{
    // TODO: Wait for the thread with TID to finish. If status and size are non-zero,
    // copy the result of the thread to the memory, status points to. Copy size bytes.
    struct thread *t;
    for (int i = 0; i < MAX_THREADS; i++)
    {
        t = (struct thread*) threads[i];
        if (t->tid == tid)
        {
            break;
        }    
    }
    
    if (t->tid != tid)
    {
        printf("[WARNING] tjoin could not find thread with given tid\n");
        exit(1);
    }
    while (t->state != EXITED)
    {
        tyield();
    }
    
    if(status != 0 && size != 0){
        memcpy(status,t->return_value,size);
    }
    
    current_thread->state = UNUSED;
    return 0;
}

void tyield()
{
    // TODO: Implement the yielding behaviour of the thread
    // current_thread->state = RUNNABLE;
    tsched();
}

uint8 twhoami()
{
    // TODO: Returns the thread id of the current thread
    return current_thread->tid;
}
