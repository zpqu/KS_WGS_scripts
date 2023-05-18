#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

sname="Sfla"
lname="00_Sophora_flavescens"

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/WGD_results/${lname}"
binDIR="/hpcfs/apps/DupGen_finder"

export TMPDIR=${outDIR}

## create output dir if none
cd $outDIR
if [ -d ${outDIR} ]; then
    echo "Output folder exists ... "
else
    mkdir -p ${outDIR}
fi

# run dupGen_finder
cd ${outDIR}

/usr/bin/time --verbose DupGen_finder.pl -i ${outDIR} \
    -t ${sname} -c Lalb \
    -o ${outDIR}/dupGen_Lalb

echo -ne "The program ends at: "
date
