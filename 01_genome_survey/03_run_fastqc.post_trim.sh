#!/bin/bash

echo -ne "The program starts at: "
date

binDIR="/home/apps/FastQC"
wkDIR="/data/mnt/Genomics/KS_WGS/illumina"
trimDIR="${wkDIR}/results/2_trimmomatic"

if [ -d $trimDIR ]; then
  echo "Folder $trimDIR exists ... "
else
  mkdir $trimDIR
fi

cd $trimDIR
/usr/bin/time ${binDIR}/fastqc -t 16 KS_illumina_R1.paired.fq.gz KS_illumina_R2.paired.fq.gz

echo -ne "The program ends at: "
date

