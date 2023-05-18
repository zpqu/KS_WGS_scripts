#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
outDIR="${wkDIR}/results/4_2_wtdbg2_raw_N50"

#activate conda env
source /apps/software/Anaconda3/2019.03/etc/profile.d/conda.sh
conda activate medaka

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR

echo -ne "***Now is polishing genome using medaka***"
date

/usr/bin/time --verbose medaka_consensus -t 32 \
    -i ${dataDIR}/KS_nanopore.fq.gz \
    -d KS_nanopore.raw_N50.wtdbg2.racon_4th.fasta \
    -o ${outDIR} \
    -m r941_prom_high_g360 \
    -b 500

rm calls_todraft.bam* consensus_probs.hdf

echo -ne "The program ends at: "
date

