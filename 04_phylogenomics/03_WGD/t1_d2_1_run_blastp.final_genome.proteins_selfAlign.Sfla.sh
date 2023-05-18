#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
genomeDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/final_genome"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis"
dbDIR="${wkDIR}/DB"
binDIR="$HOME/apps/gmap-2019-12-01/bin"

export TMPDIR=${outDIR}

## create output dir if none
cd $outDIR
if [ -d ${outDIR} ]; then
    echo "Output folder exists ... "
else
    mkdir -p ${outDIR}
fi

##create database index
cd ${genomeDIR}

if [ -f Sfla_v1.proteins_with_annotation.fa.phr ]; then
    echo "Formatted database exists ... "
else
    makeblastdb -dbtype prot -in Sfla_v1.proteins_with_annotation.fa
fi

##step 2, run blastp

cd ${outDIR}

/usr/bin/time --verbose blastp -query ${genomeDIR}/Sfla_v1.proteins_with_annotation.fa \
    -db ${genomeDIR}/Sfla_v1.proteins_with_annotation.fa \
    -num_threads 64 \
    -evalue 1e-10 \
    -max_target_seqs 5 \
    -outfmt 6 \
    -out Sfla_v1.proteins_with_annotation.blastp_selfAlign.out
 
echo -ne "The program ends at: "
date
