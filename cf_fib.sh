#! /usr/local/bin/nosh

######## UGE のオプション ########
#$ -S /usr/local/bin/nosh
#$ -cwd
#$ -l s_vmem=5G
#$ -pe mpi_4 4

module load openmpi
CRAYFISH_MAX_SEND_INTERVAL=1us time mpirun -n 2 ./target/release/examples/fib 15
