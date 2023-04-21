#include "kernel/types.h"
#include "user.h"
#define MAX_THREADS 64
#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)


int thread_count;
struct thread *threads[MAX_THREADS];
struct thread *current_thread;

/// @brief Will find the thread ID in the thread table
int find_thread_index(struct thread *thread)
{
    for (int i = 0; i < MAX_THREADS; i++)
    {
        if (threads[i]->tid == thread->tid)
        {
            return i;
        }
    }
    return -1;
}

void tsched()
{
    int current_thread_index = find_thread_index(current_thread);
    struct thread *t;

    for (int i = current_thread_index+1; i % MAX_THREADS != current_thread_index; i++){
        t=threads[i%MAX_THREADS];
        if (t->state==RUNNABLE)
        {
            // Housekeeping
            t->state=RUNNING;
            current_thread=t;

            tswtch(&(threads[current_thread_index]->tcontext), &(t->tcontext));
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
/// @brief Will add a thread to the thread table and set state. 
void add_thread_to_table(struct thread *thread)
{
    struct thread *thread_in_table;
    int i;

    for (i = 0; i < MAX_THREADS; i++){
        thread_in_table = threads[i];
        if (thread_in_table->state == UNUSED || thread_in_table->state > EXITED)
        {
            threads[i] = thread;
            threads[i]->state=RUNNABLE;
            break;
        }
    }
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
    (*thread)->return_value = malloc(attr->res_size);

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
        exit(-1);
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
    tsched();
    // TODO: Implement the yielding behaviour of the thread
}

uint8 twhoami()
{
    // TODO: Returns the thread id of the current thread
    return current_thread->tid;
}
