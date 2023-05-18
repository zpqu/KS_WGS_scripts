#!/bin/bash

binDIR="$HOME/apps/EDTA-master"
wkDIR="/program/WGS_20190107/nanopore/results/e1_canu_ec/maker/juicer_purge_10/repeats_EDTA_2nd"

#source /home/apps/anaconda3/etc/profile.d/conda.sh
#conda activate EDTA


cd ${wkDIR}
/usr/bin/time --verbose perl ${binDIR}/EDTA.pl \
    --genome curated.FINAL.fasta \
    --overwrite 1 \
    --sensitive 1 \
    --anno 1 \
    --evaluate 1 \
    --threads 32
