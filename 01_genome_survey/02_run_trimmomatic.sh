#!/bin/bash

echo -ne "The program starts at: "
date

binDIR="/home/apps/Trimmomatic-0.39"
wkDIR="/data/mnt/Genomics/KS_WGS/illumina"
dataDIR="${wkDIR}/data"
trimDIR="${wkDIR}/results/2_trimmomatic"

if [ -d $trimDIR ]; then
  echo "Folder $trimDIR exists ... "
else
  mkdir $trimDIR
fi

cd $trimDIR
/usr/bin/time --verbose java -jar ${binDIR}/trimmomatic-0.39.jar PE -threads 16 \
	${dataDIR}/KS_illumina_R1.fq.gz ${dataDIR}/KS_illumina_R2.fq.gz \
	KS_illumina_R1.paired.fq.gz KS_illumina_R1.unpaired.fq.gz \
	KS_illumina_R2.paired.fq.gz KS_illumina_R2.unpaired.fq.gz \
	ILLUMINACLIP:${binDIR}/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36

echo -ne "The program ends at: "
date

