#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
outDIR="${wkDIR}/results/4_2_wtdbg2_raw_N50"
binDIR="/home/apps/wtdbg2"

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR

echo -ne "***Now is running wtdbg2 assembly ... ***"
date

/usr/bin/time --verbose ${binDIR}/wtdbg2 \
    -t 40 \
    -p 19 -AS 2 -s 0.05 -L 5000 -R -g 2100m \
    -i ${dataDIR}/KS_nanopore_filterN50.fq.gz \
    -fo KS_raw_N50_wtdbg2

echo -ne "***Now is running wtpoa-cns to derive consensus ... ***"
date

/usr/bin/time --verbose ${binDIR}/wtpoa-cns \
    -t 40 \
    -i KS_raw_N50_wtdbg2.ctg.lay.gz \
    -fo KS_raw_N50_wtdbg2.raw.fa

echo -ne "The program ends at: "
date

