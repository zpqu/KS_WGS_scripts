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

/usr/bin/time --verbose Rscript ${scriptDIR}/findGSE.R > findGSE_summary.txt

echo -ne "The program ends at: "
date
