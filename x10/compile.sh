#! /usr/local/bin/nosh

######## UGE のオプション ########
#$ -S /usr/local/bin/nosh
#$ -cwd
#$ -l s_vmem=6G
#$ -l h_rt=2:00:00
#$ -l s_rt=2:00:00

export LANG=en_US.utf-8
. ~/intel/oneapi/setvars.sh
export PATH=/home/jxwang/x10/x10-master/x10.dist/bin/:$PATH
#CC=icc JAVA_TOOL_OPTIONS="-Xmx6G -Xms512m" make

# module load gcc/9.3.0 
# export PATH=/home/jxwang/x10_official/bin:$PATH
CC=icc CXX=icc /usr/bin/make
