##18/06/2020
##Zhipeng
##Trim adaptor and low quality sequences using Trimmomatic

#!/bin/bash

wkDIR="/program/WGS_20190107/transcriptome"
fastq_DIR="${wkDIR}/data"
trimDIR="${wkDIR}/results/2_trimmomatic"
binDIR="/home/soft/Trimmomatic-0.36"

echo -ne "The Trimmomatic starts at: "
date

if [ -d $trimDIR ]; then
    echo "Folder $trimDIR exists ..."
else
    mkdir $trimDIR
fi

cd $fastq_DIR
fastq_FILES=$(ls *_R1.fq.gz)

for f in $fastq_FILES
do
    filename=${f%_R1.fq.gz}
    echo -ne "Now is processing $filename ..."
    date
    java -jar ${binDIR}/trimmomatic-0.36.jar PE -threads 16 -phred33 \
      ${filename}_R1.fq.gz ${filename}_R2.fq.gz \
      ${trimDIR}/${filename}_trimmed_R1.fq.gz ${trimDIR}/${filename}_R1_unpaired.fq.gz \
      ${trimDIR}/${filename}_trimmed_R2.fq.gz ${trimDIR}/${filename}_R2_unpaired.fq.gz \
      ILLUMINACLIP:${binDIR}/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:20
    fastqc -t 16 -o ${trimDIR} ${trimDIR}/${filename}_trimmed_R1.fq.gz
    fastqc -t 16 -o ${trimDIR} ${trimDIR}/${filename}_trimmed_R2.fq.gz
done

echo -ne "The Trimmomatic ends at: "
date
