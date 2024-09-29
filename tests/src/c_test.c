#include <time.h>
#include <stdlib.h>
#include <stdio.h>
char *gets(char*);

int main(int argc, char *argv[]) {
	char buf[50], buf1[50], buf2[50];
	printf("Enter name: ");
	char *name = gets(buf1);
	printf("Enter class: ");
	char *class = gets(buf2);
	srandom(time(NULL));
	double radius = (double)random()/1000.;
	double area = 3.1415926*radius*radius;
	sprintf(buf, "Name: %s Class: %s Area: %f", name, class, area);
	printf("%s\n", buf);
	printf(argv[1], area);
	printf("Final test may 30th");
	return 0;
}

