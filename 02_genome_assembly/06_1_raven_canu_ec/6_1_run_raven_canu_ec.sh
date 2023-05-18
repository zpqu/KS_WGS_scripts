#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/results/e1_canu_ec"
outDIR="${wkDIR}/results/6_1_raven_canu_ec"
binDIR="/home/apps/raven/build/bin"

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR
echo -ne "***Now is assembling genome using raven with canu ec reads***"
date

/usr/bin/time --verbose ${binDIR}/raven \
    -t 40 -p 0 \
    --graphical-fragment-assembly KS_nanopore.canu_ec.raven.gfa \
    ${dataDIR}/canu_ec.correctedReads.fasta.gz \
    > KS_nanopore.canu_ec.raven.fasta

echo -ne "The program ends at: "
date

