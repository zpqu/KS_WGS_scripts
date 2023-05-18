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

echo -ne "Now is converting long read fastq to fasta ... "
date
/usr/bin/time --verbose zcat ${lrDIR}/KS_nanopore.fq.gz | \
    /usr/bin/time --verbose sed -n '1~4s/^@/>/p;2~4p' > KS_nanopore.fa

awk 'BEGIN {n_seq=0;} /^>/ {if(n_seq%1200000==0){file=sprintf("myseq_%d.fa",n_seq);} print >> file; n_seq++; next;} { print >> file; }' < KS_nanopore.fa

#echo -ne "Now is runing fmlrc ... "
#date
#/usr/bin/time --verbose ${binDIR}/fmlrc -p 80 ${srDIR}/comp_msbwt.npy \
#    KS_nanopore.fa KS_nanopore.fmlrc_ec.fa

#/usr/bin/time gunzip KS_nanopore.fa
#/usr/bin/time gunzip KS_nanopore.fmlrc_ec.fa

echo -ne "The program ends at: "
date

