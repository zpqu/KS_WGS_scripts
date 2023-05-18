##19/11/2020
##Zhipeng
##QC for raw reads

#!/bin/bash

wkDIR="/program/WGS_20190107/transcriptome"
fastq_DIR="${wkDIR}/data"
outDIR="${wkDIR}/results/1_fastqc"

echo -ne "The whole program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ..."
else
    mkdir -p $outDIR
fi

cd $fastq_DIR
fastq_FILES=$(ls *.fq.gz)

for f in $fastq_FILES
do
    echo -ne "Now is processing $f ..."
    date
    fastqc -t 16 -o ${outDIR} ${fastq_DIR}/${f}
done

echo -ne "The whole program ends at: "
date

