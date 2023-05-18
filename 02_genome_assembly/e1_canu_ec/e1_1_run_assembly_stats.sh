#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/results/e1_canu_ec"
qcDIR="${wkDIR}/results/e1_canu_ec"

if [ -d $qcDIR ]; then
    echo "Folder $qcDIR exists ... "
else
    mkdir $qcDIR
fi

cd $qcDIR

echo -ne "***Now is get statistics of reads***"
date

/usr/bin/time --verbose ~/apps/assembly-stats/build/assembly-stats \
        -t <( zcat ${dataDIR}/canu_ec.correctedReads.fasta.gz ) \
        >${qcDIR}/canu_ec.correctedReads.assembly_stats.txt

echo -ne "The program ends at: "
date
