#! /usr/local/bin/nosh

######## UGE のオプション ########
#$ -S /usr/local/bin/nosh
#$ -cwd
#$ -l s_vmem=5G
#$ -pe mpi_32 32 

module load openmpi

export TIME="%U %S %E %P %X %D %M %K"
echo "user system elapsed CPU text data max SumMem" 1>&2

run_sort(){  # args: process_num, input_num

echo $1 $2 1>&2
for i in $(seq 0 `expr $2 - 1`); do echo ./data_gen/data/data_sort_$i ; done | xargs time mpirun -n $1 ./target/release/examples/sort

}

# strong
run_sort 32 32
run_sort 16 32
run_sort 8 32
run_sort 4 32

# weak 
run_sort 4 4
run_sort 8 8
run_sort 16 16
run_sort 32 32

# # strong
# run_sort 32 64
# run_sort 16 64
# run_sort 8 64
# run_sort 4 64
#
# # weak 
# run_sort 4 8
# run_sort 8 16
# run_sort 16 32
# run_sort 32 64
