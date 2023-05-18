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

#/usr/bin/time --verbose ${binDIR}/wtpre \
#    -J 1000 \
#    ${dataDIR}/KS_nanopore_filterN50.fq.gz | \
#    gzip -c -1 > smartdenovo_raw_N50.fa.gz

/usr/bin/time --verbose ${binDIR}/wtzmo -P 10 -p 3 -t 32 \
    -k 16 -z 10 -Z 16 -U -1 -m 0.5 -A 1000 \
    -i smartdenovo_raw_N50.fa.gz \
    -fo smartdenovo_raw_N50.p3.dmo.ovl

echo -ne "The program ends at: "
date

