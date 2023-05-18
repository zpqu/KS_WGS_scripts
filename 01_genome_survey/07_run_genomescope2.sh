#!/bin/bash

echo -ne "The program starts at: "
date

wkDIR="/data/mnt/Genomics/KS_WGS/illumina"
kmerDIR="${wkDIR}/results/3_kmer"
binDIR="/home/apps/genomescope2.0"

if [ -d $kmerDIR ]; then
  echo "Folder $kmerDIR exists ... "
else
  mkdir $kmerDIR
fi

cd $kmerDIR
FILES=$(ls *.histo)

for i in $FILES
do
  k=${i%mer.histo}
  echo -ne "Now is processing ${k}mer ... "
  /usr/bin/time --verbose Rscript ${binDIR}/genomescope.R \
	  -i $i -k $k -o genomescope2_${k}mer
done

echo -ne "The program ends at: "
date
