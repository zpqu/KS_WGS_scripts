#! /bin/bash

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

echo -ne "***Now is performing QC using fastqc***"
date

/usr/bin/time --verbose fastqc -t 32 ${dataDIR}/KS_nanopore.fq.gz -o ${qcDIR}

echo -ne "The program ends at: "
date
