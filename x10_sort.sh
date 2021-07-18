#! /usr/local/bin/nosh

######## UGE のオプション ########
#$ -S /usr/local/bin/nosh
#$ -cwd
#$ -l s_vmem=5G
#$ -pe def_slot 36

. /home/jxwang/intel/oneapi/setvars.sh

export TIME="%U %S %E %P %X %D %M %K"
echo "user system elapsed CPU text data max SumMem" 1>&2

run_sort(){  # args: process_num, input_num

echo $1 $2 1>&2
export X10_NPLACES=$1
for i in $(seq 0 `expr $2 - 1`); do echo ./data_gen/data/data_sort_$i ; done | xargs time ./x10/sort

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
