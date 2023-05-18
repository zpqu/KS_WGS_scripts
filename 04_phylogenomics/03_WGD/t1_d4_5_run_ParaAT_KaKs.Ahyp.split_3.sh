#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

sname="Ahyp"
lname="02_Arachis_hypogaea"

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

#cut -f 1,3 ${wgdDIR}/dupGen/${sname}.wgd.pairs | sed -n '1!p' > ${sname}.wgd.homologs

/usr/bin/time --verbose ParaAT.pl -h ${sname}.wgd.homologs_3 \
    -n ${genomeDIR}/cds_simple_id.fasta \
    -a ${genomeDIR}/prot_simple_id.fasta \
    -p ../proc \
    -o output_split_3 -f axt -k -g \
    >run_ParaAT_WGD.split_3.log

find -type f -wholename './output_split_3/*.kaks' -print0 | xargs -0 cat > ${sname}.wgd.kaks_3

tar -zcf output_split_3.tar.gz ./output_split_3
rm -r output_split_3

echo -ne "The program ends at: "
date
