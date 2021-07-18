#! /usr/local/bin/nosh

######## UGE のオプション ########
#$ -S /usr/local/bin/nosh
#$ -cwd
#$ -pe def_slot 2

time X10_NPLACES=2 ./fib 13
