#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/9_1_flye_canu_ec/nextPolish"
outDIR="${wkDIR}/results/9_1_flye_canu_ec/purge_haplotigs"
minimap2DIR="/home/apps/minimap2"

#activate conda env
#source /apps/software/Anaconda3/2019.03/etc/profile.d/conda.sh
#conda activate purge_haplotigs_env

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR

echo -ne "***Step 1: mapping nanopore reads to assembly using minimap2***"
date

/usr/bin/time --verbose ${minimap2DIR}/minimap2 -t 32 \
    -ax map-ont \
    --secondary=no \
    ${genomeDIR}/genome.nextpolish.fa \
    ${dataDIR}/KS_nanopore.fq.gz | \
    samtools sort - -m 4g --threads 32 \
    -o aligned.bam

echo -ne "The program ends at: "
date

