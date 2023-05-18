#!/bin/bash

echo -ne "The program starts at: "
date

wkDIR="/data/mnt/Genomics/KS_WGS/illumina"
kmerDIR="${wkDIR}/results/3_kmer"
scriptDIR="${wkDIR}/scripts"

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
  /usr/bin/time --verbose Rscript ${scriptDIR}/genomescope.R \
	  $i $k 300 genomescope_${k}mer
done

echo -ne "The program ends at: "
date
