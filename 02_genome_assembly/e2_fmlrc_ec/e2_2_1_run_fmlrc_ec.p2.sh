#!/bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626"
srDIR="${wkDIR}/illumina/results/2_trimmomatic"
lrDIR="${wkDIR}/nanopore/data"
outDIR="${wkDIR}/nanopore/results/e2_fmlrc_ec"
binDIR="/home/apps/fmlrc"

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR

echo -ne "Now is runing fmlrc ... "
date
/usr/bin/time --verbose ${binDIR}/fmlrc -p 40 ${srDIR}/comp_msbwt.npy \
    myseq_1.fa KS_nanopore.fmlrc_ec.p2.fa

echo -ne "The program ends at: "
date

