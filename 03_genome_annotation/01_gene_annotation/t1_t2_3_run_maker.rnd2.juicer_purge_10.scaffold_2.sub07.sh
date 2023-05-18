#!/bin/bash
echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/e1_canu_ec/juicer/purge_10/postReview"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/split/scaffold_2"
dbDIR="${wkDIR}/DB"

echo -ne "***Step 3: 2nd round maker annotation: ***"
date

cd $outDIR
bname="S_flavescens.scaffold_2"

## run maker
/usr/bin/time --verbose maker \
    -f \
    -cpus 4 \
    -genome ../../genome/scaffold_2/curated.FINAL.scaffold_2.20M_sub07.fasta \
    -base ${bname} \
    rnd2_opts.ctl \
    maker_bopts.ctl \
    maker_exe.ctl

echo -ne "The program ends at: "
date

