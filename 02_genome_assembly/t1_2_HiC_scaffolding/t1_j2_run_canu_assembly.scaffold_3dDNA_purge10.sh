#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/program/WGS_20190107/nanopore"
hicDIR="/program/WGS_20190107/HiC/results/2_trimmomatic"
outDIR="${wkDIR}/results/e1_canu_ec/juicer/purge_10"
refDIR="${wkDIR}/results/e1_canu_ec/purge_haplotigs/purge_10"
binDIR="/home/apps/3d-dna"

## activate conda env
source /home/apps/anaconda3/etc/profile.d/conda.sh
conda activate 3d-dna 

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir -p $outDIR
fi

cd $outDIR

/usr/bin/time --verbose ${binDIR}/run-asm-pipeline.sh \
    ${refDIR}/curated.fasta \
    ${outDIR}/aligned/merged_nodups.txt

echo -ne "The program ends at: "
date

