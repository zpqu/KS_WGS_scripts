#!/bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
qcDIR="${wkDIR}/results/1_QC"

if [ -d $qcDIR ]; then
    echo "Folder $qcDIR exists ... "
else
    mkdir $qcDIR
fi

cd $qcDIR
echo -ne "***Now is getting the length distribution***"
date

/usr/bin/time --verbose zcat ${dataDIR}/KS_nanopore.fq.gz | \
    /usr/bin/time --verbose awk '{if(NR%4 == 2) print length($1)}' \
    > ${qcDIR}/KS_nanopore.length_distribution.txt

echo -ne "The program ends at: "
date

