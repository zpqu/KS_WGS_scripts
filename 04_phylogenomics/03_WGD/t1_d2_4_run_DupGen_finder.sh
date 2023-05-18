#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
genomeDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/NNU_genome"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis"
dbDIR="${wkDIR}/DB"
binDIR="/hpcfs/apps/DupGen_finder"

export TMPDIR=${outDIR}

## create output dir if none
cd $outDIR
if [ -d ${outDIR} ]; then
    echo "Output folder exists ... "
else
    mkdir -p ${outDIR}
fi

##step 2, run blastp

cd ${outDIR}

/usr/bin/time --verbose DupGen_finder.pl -i ${outDIR}/data \
    -t Sfla -c Nnuc \
    -o ${outDIR}/results

/usr/bin/time --verbose DupGen_finder-unique.pl -i ${outDIR}/data \
    -t Sfla -c Nnuc \
    -o ${outDIR}/results_unique

echo -ne "The program ends at: "
date
