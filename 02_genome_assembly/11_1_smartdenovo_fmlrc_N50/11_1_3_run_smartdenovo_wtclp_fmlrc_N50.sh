#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
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

#/usr/bin/time --verbose ${binDIR}/wtzmo -P 10 -p 0 -t 32 \
#    -k 16 -z 10 -Z 16 -U -1 -m 0.5 -A 1000 \
#    -i smartdenovo_fmlrc_N50.fa.gz \
#    -fo smartdenovo_fmlrc_N50.p0.dmo.ovl
/usr/bin/time --verbose ${binDIR}/wtclp -i smartdenovo_fmlrc_N50.dmo.ovl \
    -fo smartdenovo_fmlrc_N50.dmo.obt \
    -d 3 -k 300 -m 0.5 -FT

echo -ne "The program ends at: "
date

