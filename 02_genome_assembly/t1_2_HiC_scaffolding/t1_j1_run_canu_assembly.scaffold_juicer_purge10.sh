#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/program/WGS_20190107/nanopore"
hicDIR="/program/WGS_20190107/HiC/results/2_trimmomatic"
outDIR="${wkDIR}/results/e1_canu_ec/juicer/purge_10"
refDIR="${wkDIR}/results/e1_canu_ec/purge_haplotigs/purge_10"
binDIR="/home/apps/juicer"

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir -p $outDIR
fi

cd $refDIR
echo -ne "***Now is indexing genome***"
date

if [ -f ${refDIR}/curated.fasta.bwt ]; then
    echo "reference genome bwa index files exist ... "
else
    /usr/bin/time --verbose bwa index ${refDIR}/curated.fasta
fi

cd $outDIR
echo -ne "***Now is generating site positions file***"
date

if [ -f ${outDIR}/curated_MboI.txt ]; then
    echo "restriction sites file exist ... "
else
    /usr/bin/time --verbose python ${binDIR}/misc/generate_site_positions.py \
    MboI curated ${refDIR}/curated.fasta
fi

echo -ne "***Now is generating genome size file***"
date

if [ -f ${outDIR}/curated.chrom.sizes ]; then
    echo "chrom sizes file exist ... "
else
    /usr/bin/time --verbose awk 'BEGIN{OFS="\t"}{print $1, $NF}' ${outDIR}/curated_MboI.txt \
        > ${outDIR}/curated.chrom.sizes
fi

echo -ne "***Now is running juicer***"
date

if [ ! -d ${outDIR}/fastq ]; then
    mkdir fastq
    fqFILES=$(ls ${hicDIR}/*.paired.fq.gz)
    for f in $fqFILES
    do
        filename=$(basename $f)
        filename=${filename%.fq.gz}
        ln -s $f ${outDIR}/fastq/${filename}.fastq.gz
    done
fi

/usr/bin/time --verbose ${binDIR}/scripts/juicer.sh \
    -d ${outDIR} \
    -D ${binDIR} \
    -g curated \
    -s MboI \
    -z ${refDIR}/curated.fasta \
    -y ${outDIR}/curated_MboI.txt \
    -p ${outDIR}/curated.chrom.sizes \
    -t 32

echo -ne "The program ends at: "
date

