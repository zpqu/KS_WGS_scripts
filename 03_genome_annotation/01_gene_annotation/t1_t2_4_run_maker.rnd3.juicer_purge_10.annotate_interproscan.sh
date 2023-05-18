#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/e1_canu_ec/juicer/purge_10/postReview"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/split"
dbDIR="${wkDIR}/DB"
binDIR="/apps/software/interproscan/5.27-66.0-foss-2016b/"

export TMPDIR=${outDIR}

if [ -d ${outDIR}/annotate_rnd3 ]; then
    echo "Folder augustus exists ... "
else
    mkdir -p ${outDIR}/annotate_rnd3
fi

cd ${outDIR}/annotate_rnd3

##step 3, run interproscan

echo -ne "***Now is running interproscan at: "
date

sed "s/\*//g" ../S_flavescens.split_rnd3.all.maker.proteins.fasta \
    >../S_flavescens.split_rnd3.all.maker.proteins.modified.fasta

/usr/bin/time --verbose ${binDIR}/interproscan.sh \
    -cpu 32 \
    -appl pfam -dp -f TSV -goterms -iprlookup -pa -t p \
    -i ../S_flavescens.split_rnd3.all.maker.proteins.modified.fasta \
    -o S_flavescens.split_rnd3.all.maker.proteins.inrscan

echo -ne "The program ends at: "
date
