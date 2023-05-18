#!/bin/bash

echo -ne "The program starts at: "
date

binDIR="/home/apps/FastQC"
wkDIR="/data/mnt/Genomics/KS_WGS/illumina"
dataDIR="${wkDIR}/data"
outDIR="${wkDIR}/results/1_QC"

if [ -d $outDIR ]; then
  echo "Folder $outDIR exists ... "
else
  mkdir $outDIR
fi

cd $outDIR
/usr/bin/time --verbose ${binDIR}/fastqc -t 16 \
	${dataDIR}/KS_illumina_R1.fq.gz \
	${dataDIR}/KS_illumina_R2.fq.gz \
	-o $outDIR

echo -ne "The program ends at: "
date

