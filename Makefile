
all:

sort: 
	qsub x10_sort.sh
	qsub cf_sort.sh
fib: Fib.x10
	x10c++ $(OPT_LEVEL) -o fib ./Fib.x10
clean:
	rm -f x10_sort.sh.*
	rm -f x10_fib.sh.*
	rm -f cf_sort.sh.*
	rm -f cf_fib.sh.*
	rm -f core.*
