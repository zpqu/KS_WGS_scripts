#!/bin/bash
echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/e1_canu_ec/juicer/purge_10/postReview"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/split_rnd1/scaffold_un"
dbDIR="${wkDIR}/DB"

## fix seg fault issue for mpi
#export THREADS_DAEMON_MODEL=1

echo -ne "***Step 2: initial maker annotation: ***"
date

cd $outDIR
bname="S_flavescens.scaffold_un"

## run maker
/usr/bin/time --verbose maker \
    -cpus 4 \
    -genome ../../genome/scaffold_un/curated.FINAL.scaffold_un.20M_sub03.fasta \
    -base ${bname} \
    rnd1_opts.ctl \
    maker_bopts.ctl \
    maker_exe.ctl

## merge maker results

#fasta_merge -d ${bname}.maker.output/${bname}_master_datastore_index.log
#gff3_merge -d ${bname}.maker.output/${bname}_master_datastore_index.log

echo -ne "The program ends at: "
date
