# all you need to replace 'native' C compiler with Zig compiler
CC=zig cc

my-c-program: main.c foo.c bar.c
	$(CC) main.c -o my-c-program

clean:
	rm -f my-c-program

all: my-c-program

run: all
	./my-c-program
