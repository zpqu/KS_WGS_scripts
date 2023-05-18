#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

lName="Lupinus_albus"
sName="Lalb"

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
genomeDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/NNU_genome"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/WGD_results/01_${lName}"
queryDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/WGD_genomes/01_${lName}"

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

if [ -f Nnuc.proteins_primary.fa.phr ]; then
    echo "Formatted database exists ... "
else
    makeblastdb -dbtype prot -in Nnuc.proteins_primary.fa
fi

##step 2, run blastp

cd ${outDIR}

/usr/bin/time --verbose blastp -query ${queryDIR}/prot.fasta \
    -db ${genomeDIR}/Nnuc.proteins_primary.fa \
    -num_threads 32 \
    -evalue 1e-10 \
    -max_target_seqs 5 \
    -outfmt 6 \
    -out prot_Nnuc.blastp.out
 
echo -ne "The program ends at: "
date
