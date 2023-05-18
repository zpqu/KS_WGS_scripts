#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
outDIR="${wkDIR}/results/3_2_smartdenovo_raw_N50"
binDIR="/home/apps/smartdenovo"

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR
echo -ne "***Now is assembling genome using smartdenovo with N50 raw reads***"
date

/usr/bin/time --verbose ${binDIR}/wtpre \
    -J 1000 \
    ${dataDIR}/KS_nanopore_filterN50.fq.gz | \
    gzip -c -1 > smartdenovo_raw_N50.fa.gz

echo -ne "The program ends at: "
date

