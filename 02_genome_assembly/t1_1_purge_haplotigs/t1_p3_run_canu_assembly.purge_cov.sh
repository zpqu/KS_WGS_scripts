#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/program/WGS_20190107/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/e1_canu_ec/nextPolish"
outDIR="${wkDIR}/results/e1_canu_ec/purge_haplotigs"
minimap2DIR="/home/apps/minimap2"

source /home/apps/anaconda3/etc/profile.d/conda.sh
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

echo -ne "***Step 3: coverage analysis***"
date

/usr/bin/time --verbose purge_haplotigs cov -i aligned.bam.gencov \
    -l 20 -m 72 -h 130 \
    -o coverage_stats.csv \
    -j 80 -s 10


echo -ne "The program ends at: "
date

