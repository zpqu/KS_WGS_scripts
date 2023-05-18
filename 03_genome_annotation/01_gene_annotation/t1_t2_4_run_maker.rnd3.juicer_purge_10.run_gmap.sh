#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/genome"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/split"
dbDIR="${wkDIR}/DB"
binDIR="$HOME/apps/gmap-2019-12-01/bin"

export TMPDIR=${outDIR}

## index genome if none
cd ${genomeDIR}
if [ -d ${genomeDIR}/GMAP ]; then
    echo "GMAP genome index exists ... "
else
    /usr/bin/time --verbose ${binDIR}/gmap_build \
        -D ./ \
        -d GMAP \
        curated.FINAL.fasta
fi

## create output dir if none
cd $outDIR
if [ -d ${outDIR} ]; then
    echo "Folder map_id_rnd3 exists ... "
else
    mkdir -p ${outDIR}
fi

cd ${outDIR}

##step 3, run gmap

echo -ne "***Now is running gmap at: "
date

/usr/bin/time --verbose ${binDIR}/gmap \
    -t 16 \
    -D ${genomeDIR} \
    -d GMAP \
    -f gff3_gene \
    -O \
    <S_flavescens.split_rnd3.all.maker.transcripts.fasta> \
    S_flavescens.split_rnd3.all.maker.transcripts.gmap_gene.gff3

echo -ne "The program ends at: "
date
