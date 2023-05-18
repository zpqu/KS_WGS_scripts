#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/9_1_flye_canu_ec/nextPolish"
outDIR="${wkDIR}/results/9_1_flye_canu_ec/purge_haplotigs/purge_10"
minimap2DIR="/home/apps/minimap2"

source /apps/software/Anaconda3/2019.03/etc/profile.d/conda.sh
conda activate purge_haplotigs_env

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR

#echo -ne "***Step 1: mapping nanopore reads to assembly using minimap2***"
#date

#/usr/bin/time --verbose ${minimap2DIR}/minimap2 -t 32 \
#    -ax map-ont \
#    --secondary=no \
#    ${genomeDIR}/genome.nextpolish.fa \
#    ${dataDIR}/KS_nanopore.fq.gz \
#    -o aligned.sam

#/usr/bin/time --verbose samtools sort -m 4G --threads 32 -o aligned.bam aligned.sam
#rm aligned.sam

#echo -ne "***Step 2: generate a coverage histogram***"
#date

#/usr/bin/time --verbose purge_haplotigs hist -b aligned.bam \
#    -g ${genomeDIR}/genome.nextpolish.fa \
#    -t 32

#echo -ne "***Step 3: coverage analysis***"
#date

#/usr/bin/time --verbose purge_haplotigs cov -i aligned.bam.gencov \
#    -l 20 -m 65 -h 160 \
#    -o coverage_stats.csv

echo -ne "***Step 4: purge***"
date

/usr/bin/time --verbose purge_haplotigs purge \
    -g ${genomeDIR}/genome.nextpolish.fa \
    -c coverage_stats.csv \
    -t 32 \
    -d -b ../aligned.bam

echo -ne "The program ends at: "
date

