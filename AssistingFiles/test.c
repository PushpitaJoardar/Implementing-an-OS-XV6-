#include "types.h"
#include "stat.h"
#include "user.h"

int 
main(int argc,char *argv[])
{
    printf(1,"Beginning--\n");
    sleep(10);
    for(int i=0;i<20;i++){
        printf(1,"allocating new page for %d\n",i);
        sbrk(4096);
        printf(1,"check page table \n");
        sleep(10);
    }
    sleep(30);
    exit();
}