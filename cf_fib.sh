#! /usr/local/bin/nosh

######## UGE のオプション ########
#$ -S /usr/local/bin/nosh
#$ -cwd
#$ -l s_vmem=5G
#$ -pe mpi_32 32

module load openmpi

export TIME="%U %S %E %P %X %D %M %K"
echo "user system elapsed CPU text data max SumMem" 1>&2


run_fib(){  # args: process_num, input_num
echo $1 $2 1>&2
/bin/time mpirun -n $1 ./target/release/examples/fib $2
}


#strong
run_fib  32 16
run_fib  16 16
run_fib  8 16
run_fib  4 16

#weak
run_fib  4 15
run_fib  8 16
run_fib  16 17
run_fib  32 18

export CRAYFISH_MAX_SEND_INTERVAL=1ns

#strong
run_fib  32 16
run_fib  16 16
run_fib  8 16
run_fib  4 16

#weak
run_fib  4 15
run_fib  8 16
run_fib  16 17
run_fib  32 18
