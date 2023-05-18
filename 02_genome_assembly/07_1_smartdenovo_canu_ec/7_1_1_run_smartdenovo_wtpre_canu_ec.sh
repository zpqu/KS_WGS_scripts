#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/results/e1_canu_ec"
outDIR="${wkDIR}/results/7_1_smartdenovo_canu_ec"
binDIR="/home/apps/smartdenovo"

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR
echo -ne "***Now is assembling genome using smartdenovo with canu ec reads***"
date

/usr/bin/time --verbose ${binDIR}/wtpre \
    -J 1000 \
    ${dataDIR}/canu_ec.correctedReads.fasta.gz | \
    gzip -c -1 > smartdenovo_canu_ec.fa.gz

echo -ne "The program ends at: "
date

