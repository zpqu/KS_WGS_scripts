#!/bin/bash
#merge fasta and gff files after split_rnd2 maker 

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/e1_canu_ec/juicer/purge_10/postReview"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/split"
dbDIR="${wkDIR}/DB"

export TMPDIR=${outDIR}

if [ -d ${outDIR}/train_augustus_rnd2 ]; then
    echo "Folder augustus exists ... "
else
    mkdir -p ${outDIR}/train_augustus_rnd2
fi

cd ${outDIR}/train_augustus_rnd2

## prepare data for gene model training
##step 1, format maker gff file
echo -ne "*** Format and filter maker gff file ***"
date
/usr/bin/time --verbose maker2zff -l 50 -x 0.2 ../S_flavescens.split_rnd2.all.gff

##step 2, run snap categories
echo -ne "*** Run snap categories ***"
date
/usr/bin/time --verbose fathom -categorize 1000 genome.ann genome.dna

##step 3, Run fathom export
echo -ne "*** Run fathom export ***"
date
/usr/bin/time --verbose fathom -export 1000 -plus uni.ann uni.dna

## Now start augustus
#step 1, get gbk file
/usr/bin/time --verbose zff2augustus_gbk.pl export.ann export.dna >S_flavescens.gb

#step 2, random split test and train gene
/usr/bin/time --verbose train_augustus.pl \
    -cpus 32 \
    -max 100 \
    S_flavescens.gb \
    S_flavescens_rnd2

tar -zxvf S_flavescens_rnd2.tgz

ln -f -s ${outDIR}/train_augustus_rnd2/S_flavescens_rnd2 /hpcfs/apps/maker/exe/augustus/config/species/

echo -ne "The program ends at: "
date
