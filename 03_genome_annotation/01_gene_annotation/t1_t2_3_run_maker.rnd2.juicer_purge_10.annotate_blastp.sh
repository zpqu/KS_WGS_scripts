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

##step 1, make blastdb
cd ${dbDIR}/proteins

if [ -f Fabales_NCBI_IPG.20210121.fasta.phr ]; then
    echo "Formatted database exists ... "
else
    makeblastdb -dbtype prot -in Fabales_NCBI_IPG.20210121.fasta
fi

##step 2, run blastp

if [ -d ${outDIR}/annotate_rnd2 ]; then
    echo "Folder augustus exists ... "
else
    mkdir -p ${outDIR}/annotate_rnd2
fi

cd ${outDIR}/annotate_rnd2

/usr/bin/time --verbose blastp -query ../S_flavescens.split_rnd2.all.maker.proteins.fasta \
    -db ${dbDIR}/proteins/Fabales_NCBI_IPG.20210121.fasta \
    -num_threads 64 \
    -evalue 1e-6 \
    -max_hsps 1 \
    -max_target_seqs 1 \
    -outfmt "6 std qlen slen" \
    -out S_flavescens.split_rnd2.all.maker.proteins.blastp.txt

echo -ne "The program ends at: "
date
