#!/bin/bash

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/phylogenomics_analysis/orthofinder_all"
binDIR="${HOME}/apps/OrthoFinder"

export TMPDIR=${outDIR}

## create output dir if none
cd $outDIR
if [ -d ${outDIR} ]; then
    echo "Output folder exists ... "
else
    mkdir -p ${outDIR}
fi

# run OrthoFinder 
cd ${outDIR}

/usr/bin/time --verbose ${binDIR}/orthofinder \
    -f ${outDIR} \
    -t 32 -a 32 \
    -M msa -A muscle \
    -n muscle_FastTree

echo -ne "The program ends at: "
date
