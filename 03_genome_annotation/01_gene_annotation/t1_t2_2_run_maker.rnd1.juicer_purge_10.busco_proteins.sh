#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
asmDIR="${wkDIR}/results/e1_canu_ec"
refDIR="${asmDIR}/maker/juicer_purge_10/split_rnd1"
dbDIR="${wkDIR}/DB/busco/busco_downloads/lineages"

#activate conda env
source /apps/software/Anaconda3/2019.03/etc/profile.d/conda.sh
conda activate busco

#if [ -d $outDIR ]; then
#    echo "Folder $outDIR exists ... "
#else
#    mkdir $outDIR
#fi

cd $refDIR

echo -ne "***Now is running busco***"
date

/usr/bin/time --verbose busco \
    -c 32 -f \
    -i ${refDIR}/S_flavescens.split_rnd1.all.maker.proteins.fasta \
    -o busco_proteins \
    -m protein \
    -l ${dbDIR}/fabales_odb10 

/usr/bin/time --verbose generate_plot.py -wd ${refDIR}/busco_proteins

echo -ne "The program ends at: "
date

