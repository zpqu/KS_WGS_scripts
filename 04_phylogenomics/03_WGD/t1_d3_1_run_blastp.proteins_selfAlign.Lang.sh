#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
genomeDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/WGD_genomes/01_1_Lupinus_angustifolius"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/WGD_results/01_1_Lupinus_angustifolius"
dbDIR="${wkDIR}/DB"

export TMPDIR=${outDIR}

## create output dir if none
if [ -d ${outDIR} ]; then
    echo "Output folder exists ... "
else
    mkdir -p ${outDIR}
fi

##create database index
cd ${genomeDIR}

if [ -f prot.fasta.phr ]; then
    echo "Formatted database exists ... "
else
    makeblastdb -dbtype prot -in prot.fasta
fi

##step 2, run blastp

cd ${outDIR}

/usr/bin/time --verbose blastp -query ${genomeDIR}/prot.fasta \
    -db ${genomeDIR}/prot.fasta \
    -num_threads 64 \
    -evalue 1e-10 \
    -max_target_seqs 5 \
    -outfmt 6 \
    -out prot.blastp_selfAlign.out
 
echo -ne "The program ends at: "
date
