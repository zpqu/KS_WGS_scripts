#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/results/e2_fmlrc_ec"
outDIR="${wkDIR}/results/10_1_raven_fmlrc_N50"
binDIR="/home/apps/raven/build/bin"

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR
echo -ne "***Now is assembling genome using raven with fmlrc ec reads***"
date

/usr/bin/time --verbose ${binDIR}/raven \
    -t 32 -p 0 \
    --graphical-fragment-assembly KS_nanopore.fmlrc_N50.raven.gfa \
    ${dataDIR}/KS_nanopore.fmlrc_ec_N50.fa.gz \
    > KS_nanopore.fmlrc_N50.raven.fasta

echo -ne "The program ends at: "
date

