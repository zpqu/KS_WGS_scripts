#! /bin/bash

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
fqDIR="${wkDIR}/data"
ecDIR="${wkDIR}/results/e1_canu_ec"
outDIR="${wkDIR}/results/e1_canu_ec"

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
        echo "Folder $outDIR exists ... "
else
        mkdir $outDIR
fi

cd $outDIR

/usr/bin/time --verbose canu -assemble \
    useGrid=true \
    gridOptions="--time=72:00:00" \
    gridOptionsOVS="--mem-per-cpu=4g --cpus-per-task=8" \
    -p KS_canu \
    -d asm_erate_0.12 \
    genomeSize=2.1g \
    corMinCoverage=2 \
    corOutCoverage=200 "batOptions=-dg 3 -db 3 -dr 1 -ca 500 -cp 50" \
    correctedErrorRate=0.12 \
    corMhapSensitivity=normal \
    ovlMerThreshold=500 \
    -corrected \
    -trimmed \
    -nanopore ${ecDIR}/canu_ec.trimmedReads.fasta.gz

echo -ne "The program ends at: "
date
