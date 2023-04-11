#include "kernel/types.h"
#include "user.h"

void *hello_world(void *arg)
{
    printf("Hello World\n");
    return 0; // will be ignored, but just to make the compiler happy
}

void main()
{
    // t not initialized
    struct thread *t;

    // passing &t (taking the address of the pointer value)
    tcreate(&t, 0, &hello_world, 0);
    // Now, t points to an initialized thread struct

    tyield();
}