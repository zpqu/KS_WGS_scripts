#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/results/e2_fmlrc_ec"
outDIR="${wkDIR}/results/11_1_smartdenovo_fmlrc_N50"
binDIR="/home/apps/smartdenovo"

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR
echo -ne "***Now is assembling genome using smartdenovo with fmlrc N50 reads***"
date

/usr/bin/time --verbose ${binDIR}/wtpre \
    -J 1000 \
    ${dataDIR}/KS_nanopore.fmlrc_ec_N50.fa.gz | \
    gzip -c -1 > smartdenovo_fmlrc_N50.fa.gz

echo -ne "The program ends at: "
date

