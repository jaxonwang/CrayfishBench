OPT_LEVEL=-O5 -NO_CHECKS

all: sort fib

sort: Sort.x10
	x10c++ $(OPT_LEVEL) -o sort ./Sort.x10
fib: Fib.x10
	x10c++ $(OPT_LEVEL) -o fib ./Fib.x10
clean:
	rm -f ./sort ./fib ./*.cc *.h 2>/dev/null
	rm -f compile.sh.*
	rm -f core.*
show:
	cat compile.sh.e*
	cat compile.sh.o*
