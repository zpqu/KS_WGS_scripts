#!/bin/bash
#merge fasta and gff files after split_rnd1 maker 

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

echo -ne "Step 2: Merge gff files for split maker: "
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
/usr/bin/time --verbose gff3_merge -o S_flavescens.split_rnd1.all.gff scaffold_*/S_flavescens.scaffold_*.all.gff
AED_cdf_generator.pl -b 0.025 S_flavescens.split_rnd1.all.gff \
    >S_flavescens.split_rnd1.all.gff.AED_cdf.txt

##extract protein2genome genes
echo -ne "*** Extracting protein2genome genes from gff file ***"
date
/usr/bin/time --verbose perl ${scriptsDIR}/perlScripts/extract_protein2genome.pl \
    S_flavescens.split_rnd1.all.gff S_flavescens.split_rnd1.all.protein2genome.gff

AED_cdf_generator.pl -b 0.025 S_flavescens.split_rnd1.all.protein2genome.gff \
    >S_flavescens.split_rnd1.all.protein2genome.gff.AED_cdf.txt

echo -ne "The program ends at: "
date
