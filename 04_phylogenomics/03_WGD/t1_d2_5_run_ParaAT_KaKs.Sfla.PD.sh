#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

sname="Sfla"
lname="00_Sophora_flavescens"

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
wgdDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/WGD_results/${lname}"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/KaKs_calculation/${lname}"
genomeDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/DupGene_analysis/WGD_genomes/${lname}"


## create output dir if none
if [ -d ${outDIR} ]; then
    echo "Output folder exists ... "
else
    mkdir -p ${outDIR}
fi

export TMPDIR=${outDIR}

# run dupGen_finder
cd ${outDIR}

cut -f 1,3 ${wgdDIR}/dupGen/${sname}.proximal.pairs | sed -n '1!p' > ${sname}.PD.homologs

/usr/bin/time --verbose ParaAT.pl -h ${sname}.PD.homologs \
    -n ${genomeDIR}/cds_simple_id.fasta \
    -a ${genomeDIR}/prot_simple_id.fasta \
    -p ../proc \
    -o output_PD -f axt -k -g \
    >run_ParaAT_PD.log

find -type f -wholename './output_PD/*.kaks' -print0 | xargs -0 cat > ${sname}.PD.kaks

tar -zcf output_PD.tar.gz ./output_PD
rm -r output_PD

echo -ne "The program ends at: "
date
