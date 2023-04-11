#define assert(cond)                                        \
    if (!(cond))                                            \
    {                                                       \
        printf("%s@%s:%d\n", __FILE__, __func__, __LINE__); \
        printf("assert failed");                            \
        exit(-1);                                           \
    }
struct stat;
enum procstate
{
    UNUSED,
    USED,
    SLEEPING,
    RUNNABLE,
    RUNNING,
    ZOMBIE,
    EXITED,
};

struct user_proc
{
    enum procstate state; // Process state
    int killed;           // If non-zero, have been killed
    int xstate;           // Exit status
    int pid;              // Process ID

    int parent_id; // Parent process
    char name[16]; // name
};

// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int *);
int pipe(int *);
int write(int, const void *, int);
int read(int, void *, int);
int close(int);
int kill(int);
int exec(const char *, char **);
int open(const char *, int);
int mknod(const char *, short, short);
int unlink(const char *);
int fstat(int fd, struct stat *);
int link(const char *, const char *);
int mkdir(const char *);
int chdir(const char *);
int dup(int);
int getpid(void);
char *sbrk(int);
int sleep(int);
int uptime(void);
struct user_proc *ps(uint8 start, uint8 count);
uint64 schedls(void);
int schedset(int);

// ulib.c
int stat(const char *, struct stat *);
char *strcpy(char *, const char *);
void *memmove(void *, const void *, int);
char *strchr(const char *, char c);
int strcmp(const char *, const char *);
void fprintf(int, const char *, ...);
void printf(const char *, ...);
char *gets(char *, int max);
uint strlen(const char *);
void *memset(void *, int, uint);
void *malloc(uint);
void free(void *);
int atoi(const char *);
int memcmp(const void *, const void *, uint);
void *memcpy(void *, const void *, uint);

// uthread.c

/// @brief This is the thread context, storing the return address, the stack
///        pointer and all callee saved registers
struct context
{
    uint64 ra;
    uint64 sp;

    // callee-saved
    uint64 s0;
    uint64 s1;
    uint64 s2;
    uint64 s3;
    uint64 s4;
    uint64 s5;
    uint64 s6;
    uint64 s7;
    uint64 s8;
    uint64 s9;
    uint64 s10;
    uint64 s11;
};

/// @brief The thread struct will contain all additional information we require
///        to handle for the threads. You might need to store more information
///        to implement parts of the tasks. Feel free to extend the struct
///        accordingly.
struct thread
{
    uint8 tid;
    struct context tcontext;
    enum procstate state;
    void *arg;
    void *(*func)(void *);

    // Feel free to add more fields as needed
};

/// @brief These are the attributes that can be set when creating a thread.
///        We will only test the ones listed below, but if you want to be able
///        to configure your thread in greater detail (or go to the harder
///        optional tasks), you might want to extend the attributes.
struct thread_attr
{
    uint32 stacksize;
    uint32 res_size;

    // Feel free to add more fields as needed
};

/// @brief Switch from old thread context to new thread context.
/// @param old denotes the previous thread context, that will be switched out
/// @param new denotes the thread context of the thread that will be run next
extern void tswtch(struct context *old, struct context *new);

////////////////////////////////////////////////////////////////
/// NOTE: DON'T CHANGE THE FUNCTION OUTLINES BELOW THIS LINE ///
////////////////////////////////////////////////////////////////

/// @brief The thread scheduler, which will directly switch to the next thread
void tsched(void);

/// @brief Allocates and initializes a new thread and stores the newly allocated
///        thread into the thread pointer. The created thread will be
///        immediately runnable, no further steps required.
/// @param thread Double pointer, such that the pointer can be modified to
///               contain the pointer to the newly allocated thread.
/// @param attr Attributes that configure the thread as needed
/// @param func The pointer to the function that should be run in the thread
/// @param arg If the function takes an argument this can be passed using the arg argument
void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg);

/// @brief Joins the calling thread with the thread with thread id tid. (This means wait
///        for thread tid to finish execution before returning). After returning the status
///        will contain the return value of the function.
/// @param tid The thread id of the thread to join
/// @param status If not null and the thread has a return value, this should contain the return value
/// @param size This denotes the size of the return value in bytes
/// @return
int tjoin(int tid, void *status, uint size);

/// @brief Yield to another thread
void tyield();

/// @brief Get the tid for the currently running thread
/// @return The thread id of the currently running thread
uint8 twhoami();

// ulock.c
struct lock
{
    uint8 locked;

    char *name;
    uint8 tid;
};

/// @brief Initializes lock struct. Needs to be called before using a lock for the first time
/// @param lk Pointer to the lock to be initialized
/// @param name Give your lock a name, which might help with debugging
void initlock(struct lock *lk, char *name);

/// @brief Checks if the current thread already holds the lock
/// @param lk The lock to be checked
/// @return Indicates whether lock is held or not
uint8 holding(struct lock *lk);

/// @brief Acquire a lock by yield-waiting on the lock
/// @param lk The lock to be acquired
void acquire(struct lock *lk);

/// @brief Release a lock
/// @param lk Lock to be released
void release(struct lock *lk);
