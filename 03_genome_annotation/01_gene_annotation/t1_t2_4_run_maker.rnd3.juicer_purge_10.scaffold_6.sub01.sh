#!/bin/bash
echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/e1_canu_ec/juicer/purge_10/postReview"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/split/scaffold_6"
dbDIR="${wkDIR}/DB"

echo -ne "***Step 4: 3rd round maker annotation: ***"
date

cd $outDIR
bname="S_flavescens.scaffold_6"

## run maker
/usr/bin/time --verbose maker \
    -f \
    -cpus 4 \
    -genome ../../genome/scaffold_6/curated.FINAL.scaffold_6.20M_sub01.fasta \
    -base ${bname} \
    rnd3_opts.ctl \
    maker_bopts.ctl \
    maker_exe.ctl

echo -ne "The program ends at: "
date

