#include <inc/lib.h>
void
umain(int argc, char **argv)
{
	int block=0;
	cprintf("\nevict program called!!!");
	block = evict();
	cprintf("\nFS evicted block:%d\n",block);
}