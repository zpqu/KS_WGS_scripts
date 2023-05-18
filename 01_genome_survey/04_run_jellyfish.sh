#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/data/mnt/Genomics/KS_WGS/illumina"
trimDIR="${wkDIR}/results/2_trimmomatic"
kmerDIR="${wkDIR}/results/3_kmer"

if [ -d $kmerDIR ]; then
  echo "Folder $kmerDIR exists ... "
else
  mkdir $kmerDIR
fi

kmer=(12 13 14 15 18 21 24 27 30 33 36 39)

cd $kmerDIR
for i in "${kmer[@]}"
do

  echo -ne "Now is processing $i ... "
  date

  /usr/bin/time --verbose jellyfish count -t 16 -C -m $i -s 16G -o ${i}mer.out --min-qual-char=? \
	  <(zcat ${trimDIR}/KS_illumina_R1.paired.fq.gz) \
	  <(zcat ${trimDIR}/KS_illumina_R2.paired.fq.gz)

  /usr/bin/time --verbose jellyfish histo -t 16 -h 1000000 -o ${i}mer.histo ${i}mer.out
  
  rm ${i}mer.out #delete out file due to big size

done
echo -ne "The program ends at: "
date
