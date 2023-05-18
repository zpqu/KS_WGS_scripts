#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/e1_canu_ec/juicer/purge_10/postReview"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/split"
dbDIR="${wkDIR}/DB"

export TMPDIR=${outDIR}

##step 1, make blastdb
cd ${dbDIR}/proteins

if [ -f Glycine_max.Glycine_max_v2.1.pep.all.fa.phr ]; then
    echo "Formatted database exists ... "
else
    makeblastdb -dbtype prot -in Glycine_max.Glycine_max_v2.1.pep.all.fa
fi

##step 2, run blastp

if [ -d ${outDIR}/annotate_rnd3 ]; then
    echo "Folder annotate_rnd3 exists ... "
else
    mkdir -p ${outDIR}/annotate_rnd3
fi

cd ${outDIR}/annotate_rnd3

/usr/bin/time --verbose blastp -query ../S_flavescens.split_rnd3.all.maker.proteins.fasta \
    -db ${dbDIR}/proteins/Glycine_max.Glycine_max_v2.1.pep.all.fa \
    -num_threads 64 \
    -evalue 1e-6 \
    -max_hsps 1 \
    -max_target_seqs 1 \
    -outfmt "6 std qlen slen" \
    -out S_flavescens.split_rnd3.all.maker.proteins.blastp_Gmax.txt

##step 3, make blastdb for Gmax genes
cd ${dbDIR}/genes

if [ -f Glycine_max.Glycine_max_v2.1.cdna.all.fa.nhr ]; then
    echo "Formatted database exists ... "
else
    makeblastdb -dbtype nucl -in Glycine_max.Glycine_max_v2.1.cdna.all.fa
fi

##step 4, run blastn

if [ -d ${outDIR}/annotate_rnd3 ]; then
    echo "Folder annotate_rnd3 exists ... "
else
    mkdir -p ${outDIR}/annotate_rnd3
fi

cd ${outDIR}/annotate_rnd3

/usr/bin/time --verbose blastn -query ../S_flavescens.split_rnd3.all.maker.transcripts.fasta \
    -db ${dbDIR}/genes/Glycine_max.Glycine_max_v2.1.cdna.all.fa \
    -num_threads 64 \
    -evalue 1e-6 \
    -max_hsps 1 \
    -max_target_seqs 1 \
    -outfmt "6 std qlen slen" \
    -out S_flavescens.split_rnd3.all.maker.transcripts.blastn_Gmax.txt

echo -ne "The program ends at: "
date
