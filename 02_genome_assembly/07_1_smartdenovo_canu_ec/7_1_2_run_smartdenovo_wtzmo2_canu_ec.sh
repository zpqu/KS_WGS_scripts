#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
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

/usr/bin/time --verbose ${binDIR}/wtzmo -P 10 -p 1 -t 32 \
    -k 16 -z 10 -Z 16 -U -1 -m 0.5 -A 1000 \
    -i smartdenovo_canu_ec.fa.gz \
    -fo smartdenovo_canu_ec.p1.dmo.ovl

echo -ne "The program ends at: "
date

