#! /usr/local/bin/nosh

######## UGE のオプション ########
#$ -S /usr/local/bin/nosh
#$ -cwd
#$ -l s_vmem=6G
#$ -l h_rt=2:00:00
#$ -l s_rt=2:00:00

. ~/intel/oneapi/setvars.sh
export PATH=/home/jxwang/x10/x10-master/x10.dist/bin/:$PATH
#CC=icc JAVA_TOOL_OPTIONS="-Xmx6G -Xms512m" make
CC=icc CXX=icc make
