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

echo -ne "***Now is get statistics of reads***"
date

/usr/bin/time --verbose ~/apps/assembly-stats/build/assembly-stats \
        -t <( zcat ${dataDIR}/KS_nanopore.fq.gz ) \
        >${qcDIR}/KS_nanopore.assembly_stats.txt

echo -ne "The program ends at: "
date
