#!/bin/bash
#merge fasta and gff files after split_rnd1 maker 

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/e1_canu_ec/juicer/purge_10/postReview"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/split"
dbDIR="${wkDIR}/DB"

#Set tmp dir to fix incomplete merge gff error

export TMPDIR=${outDIR}

if [ -d ${outDIR}/train_snap ]; then 
    echo "Folder ${outDIR}/train_snap_rnd1 exists ... "
else
    mkdir -p ${outDIR}/train_snap_rnd1
fi


##Now start train_snap_rnd1

cd ${outDIR}/train_snap_rnd1

## prepare data for gene model training
##step 1, format maker gff file
echo -ne "*** Format and filter maker gff file ***"
date
/usr/bin/time --verbose maker2zff -l 50 -x 0.2 ../S_flavescens.split_rnd1.all.protein2genome.gff

##step 2, run snap categories
echo -ne "*** Run snap categories ***"
date
/usr/bin/time --verbose fathom -categorize 1000 genome.ann genome.dna

##step 3, Run fathom export
echo -ne "*** Run fathom export ***"
date
/usr/bin/time --verbose fathom -export 1000 -plus uni.ann uni.dna

##step 4, Run forge (part of snap package)
/usr/bin/time --verbose forge export.ann export.dna

##step 5, Run the hmm-assembler.pl (part of snap package) to generate the final snap species parameter/HMM file and return to the MAKER working directory.

/usr/bin/time --verbose hmm-assembler.pl S_flavescens_rnd1 . > S_flavescens_rnd1.hmm


echo -ne "The program ends at: "
date
