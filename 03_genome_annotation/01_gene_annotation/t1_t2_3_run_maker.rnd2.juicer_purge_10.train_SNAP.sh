#!/bin/bash
#merge fasta and gff files after split_rnd2 maker 

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
    echo "Folder ${outDIR}/train_snap exists ... "
else
    mkdir -p ${outDIR}/train_snap
fi


##Now start train_snap

cd ${outDIR}/train_snap

##step 4, Run forge (part of snap package)
/usr/bin/time --verbose forge ../export.ann ../export.dna

##step 5, Run the hmm-assembler.pl (part of snap package) to generate the final snap species parameter/HMM file and return to the MAKER working directory.

/usr/bin/time --verbose hmm-assembler.pl S_flavescens . > S_flavescens.hmm


echo -ne "The program ends at: "
date
