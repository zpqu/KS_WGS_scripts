#!/bin/bash
#merge fasta and gff files after split_rnd4 maker 

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/e1_canu_ec/juicer/purge_10/postReview"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/split"
dbDIR="${wkDIR}/DB"
scriptsDIR="/home/a1183549/Genomics/KS_WGS_20200629/nanopore/scripts"

#Set tmp dir to fix incomplete merge gff error

export TMPDIR=${outDIR}

echo -ne "Step 2: Merge gff files for split_rnd4 maker: "
date

for i in 1 2 3 4 5 6 7 8 9 un
do
    echo -ne "  Now is processing scaffold_${i} ... "
    date

    cd ${outDIR}/scaffold_${i}
    bname="S_flavescens.scaffold_${i}"

    ## merge maker results
    fasta_merge -d ${bname}.maker.output/${bname}_master_datastore_index.log
    gff3_merge -d ${bname}.maker.output/${bname}_master_datastore_index.log
done

cd ${outDIR}

/usr/bin/time --verbose gff3_merge -o S_flavescens.split_rnd4.all.gff scaffold_*/S_flavescens.scaffold_*.all.gff
AED_cdf_generator.pl -b 0.025 S_flavescens.split_rnd4.all.gff \
    >S_flavescens.split_rnd4.all.gff.AED_cdf.txt

cat scaffold_*/S_flavescens.scaffold_*.all.maker.transcripts.fasta \
    >S_flavescens.split_rnd4.all.maker.transcripts.fasta

cat scaffold_*/S_flavescens.scaffold_*.all.maker.proteins.fasta \
    >S_flavescens.split_rnd4.all.maker.proteins.fasta

echo -ne "The program ends at: "
date
