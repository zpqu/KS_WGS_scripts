#!/bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/results/e2_fmlrc_ec"
binDIR="/home/apps"

cd $dataDIR
echo -ne "***Now is filter the fq by length N50***"
date

/usr/bin/time --verbose ${binDIR}/seqkit seq \
    -m 25587 KS_nanopore.fmlrc_ec.fa.gz | \
    gzip -c -1 >KS_nanopore.fmlrc_ec_N50.fa.gz

#/usr/bin/time --verbose zgrep . ${dataDIR}/KS_nanopore.fq.gz | \
#    /usr/bin/time --verbose awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >= 25493) {print header, seq, qheader, qseq}}' > ${dataDIR}/KS_nanopore_filterN50.fq
#/usr/bin/time --verbose gzip -f KS_nanopore_filterN50.fq

echo -ne "The program ends at: "
date

