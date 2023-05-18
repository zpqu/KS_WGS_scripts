#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
outDIR="${wkDIR}/results/2_2_raven_raw_N50"
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

/usr/bin/time --verbose ${binDIR}/raven \
    -t 160 -p 0 \
    --graphical-fragment-assembly KS_nanopore.raw_N50.raven.gfa \
    ${dataDIR}/KS_nanopore_filterN50.fq.gz \
    > KS_nanopore.raw_N50.raven.fasta

echo -ne "The program ends at: "
date

