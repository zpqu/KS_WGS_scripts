#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

sname="Dodo"
lname="03_Dalbergia_odorifera"

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
nnuDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/NNU_genome"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/WGD_results/${lname}"
genomeDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/WGD_genomes/${lname}"
binDIR="/hpcfs/apps/DupGen_finder"

export TMPDIR=${outDIR}

## create output dir if none
cd $outDIR
if [ -d ${outDIR} ]; then
    echo "Output folder exists ... "
else
    mkdir -p ${outDIR}
fi

# run dupGen_finder
cd ${outDIR}

rm ./${sname}.* 

ln -s ${genomeDIR}/dupGen.gff ./${sname}.gff
ln -s ${outDIR}/prot.blastp_selfAlign.out ./${sname}.blast

cat ${genomeDIR}/dupGen.gff ${nnuDIR}/Nnuc.gff > ./${sname}_Nnuc.gff
ln -s ${outDIR}/prot_Nnuc.blastp.out ./${sname}_Nnuc.blast

/usr/bin/time --verbose DupGen_finder.pl -i ${outDIR} \
    -t ${sname} -c Nnuc \
    -o ${outDIR}/dupGen

echo -ne "The program ends at: "
date
