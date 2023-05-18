#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
asmDIR="${wkDIR}/results/5_1_flye_raw_all"
refDIR="${asmDIR}"
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
    -i ${refDIR}/consensus.fasta \
    -o busco_medaka \
    -m genome \
    -l ${dbDIR}/fabales_odb10

/usr/bin/time --verbose generate_plot.py -wd ${refDIR}/busco_medaka

echo -ne "The program ends at: "
date

