#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/program/WGS_20190107"
asmDIR="${wkDIR}/transcriptome/results/4_2_stringtie_juicer_purge_10"
refDIR="${asmDIR}"
dbDIR="${wkDIR}/nanopore/DB/busco/busco_downloads/lineages"

#activate conda env
source /home/apps/anaconda3/etc/profile.d/conda.sh
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
    -i ${refDIR}/S_flavescens.stringtie_GTA.transcripts.fa \
    -o busco \
    -m transcriptome \
    -l ${dbDIR}/fabales_odb10 

/usr/bin/time --verbose generate_plot.py -wd ${refDIR}/busco

echo -ne "The program ends at: "
date

