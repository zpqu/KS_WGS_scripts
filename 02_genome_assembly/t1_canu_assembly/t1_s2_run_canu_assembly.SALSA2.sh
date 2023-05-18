#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626"
salsa2DIR="${wkDIR}/nanopore/results/e1_canu_ec/SALSA2"
bamDIR="${salsa2DIR}/rep"
binDIR="/home/apps/SALSA"
contigDIR="${wkDIR}/nanopore/results/e1_canu_ec/purge_haplotigs"

if [ -d $salsa2DIR ]; then
    echo "Folder $salsa2DIR exists ... "
else
    mkdir $salsa2DIR
fi

cd $salsa2DIR

echo -ne "***Now is converting bam to bed ... "
date
/usr/bin/time --verbose bamToBed -i ${bamDIR}/KS_rep1.bam >KS_HiC.bed
/usr/bin/time --verbose sort -k 4 KS_HiC.bed > tmp.bed && mv tmp.bed KS_HiC.bed

#NOTE, the contig names in bam and bed files were truncated, names should be recovered
#/usr/bin/time --verbose perl -i -pe 's/np12/np1212/g' KS_HiC.bed

echo -ne "***Now is generating contig lengths file ... "
date
/usr/bin/time --verbose samtools faidx ${contigDIR}/curated.fasta

echo -ne "***Now is scaffolding contigs ..."
date

if [ -d ./scaffold_salsa2 ]; then
    echo "delete old results in scaffold_salsa2 ... "
    rm -r ./scaffold_salsa2
fi

/usr/bin/time --verbose python ${binDIR}/run_pipeline.py \
    -a ${contigDIR}/curated.fasta \
    -l ${contigDIR}/curated.fasta.fai \
    -b ${salsa2DIR}/KS_HiC.bed \
    -e GATC \
    -o ${salsa2DIR}/scaffold_salsa2

echo -ne "***Now is scaffolding contigs with error correction ..."
date

if [ -d ./scaffold_salsa2_ec ]; then
    echo "delete old results in scaffold_salsa2_ec ... "
    rm -r ./scaffold_salsa2_ec
fi

/usr/bin/time --verbose python ${binDIR}/run_pipeline.py \
    -a ${contigDIR}/curated.fasta \
    -l ${contigDIR}/curated.fasta.fai \
    -b KS_HiC.bed \
    -e GATC \
    -o scaffold_salsa2_ec \
    -m yes

echo -ne "The program ends at: "
date
