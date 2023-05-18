#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
outDIR="${wkDIR}/results/2_1_raven_raw_all"
binDIR="/home/apps/raven/build/bin"

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR
echo -ne "***Now is assembling genome using raven with all raw reads***"
date

/usr/bin/time --verbose ${binDIR}/raven -t 64 -p 0 \
    --graphical-fragment-assembly KS_nanopore.raw_all.raven.gfa \
    ${dataDIR}/KS_nanopore.fq.gz > KS_nanopore.raw_all.raven.fasta

echo -ne "The program ends at: "
date

