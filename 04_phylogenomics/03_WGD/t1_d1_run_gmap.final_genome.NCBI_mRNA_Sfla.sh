#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
genomeDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/final_genome"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/NCBI_mRNA_Sfla"
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
        Sfla_v1.chr.fa
fi

## create output dir if none
cd $outDIR
if [ -d ${outDIR} ]; then
    echo "Output folder exists ... "
else
    mkdir -p ${outDIR}
fi

cd ${outDIR}

##step 3, run gmap

echo -ne "***Now is running gmap at: "
date

/usr/bin/time --verbose ${binDIR}/gmap \
    -t 1 \
    -D ${genomeDIR} \
    -d GMAP \
    -f gff3_gene \
    -n 1 \
    -O \
    <Sfla.NCBI_mRNA.cds.fa> \
    Sfla.NCBI_mRNA.cds.gmap_gene.gff3

/usr/bin/time --verbose ${binDIR}/gmap \
    -t 1 \
    -D ${genomeDIR} \
    -d GMAP \
    -P \
    -O \
    <Sfla.NCBI_mRNA.cds.fa> \
    Sfla.NCBI_mRNA.cds.gmap_proteins.fa

/usr/bin/time --verbose ${binDIR}/gmap \
    -t 1 \
    -D ${genomeDIR} \
    -d GMAP \
    -E cdna \
    -O \
    <Sfla.NCBI_mRNA.cds.fa> \
    Sfla.NCBI_mRNA.cds.gmap_transcripts.fa

echo -ne "The program ends at: "
date
