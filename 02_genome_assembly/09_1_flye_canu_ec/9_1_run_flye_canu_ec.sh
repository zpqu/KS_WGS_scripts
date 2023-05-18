#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/results/e1_canu_ec"
outDIR="${wkDIR}/results/9_1_flye_canu_ec"
binDIR="/home/apps/flye/bin"

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR

echo -ne "***Now is running flye assembly ... ***"
date

/usr/bin/time --verbose ${binDIR}/flye \
    --nano-raw ${dataDIR}/canu_ec.correctedReads.fasta.gz \
    --out-dir ${outDIR} \
    --genome-size 2.1g \
    --threads 32 \
    --iterations 0

echo -ne "The program ends at: "
date

