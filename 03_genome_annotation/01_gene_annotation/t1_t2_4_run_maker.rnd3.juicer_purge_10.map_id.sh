#!/bin/bash
#merge fasta and gff files after split_rnd3 maker 

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
genomeDIR="${wkDIR}/results/e1_canu_ec/juicer/purge_10/postReview"
outDIR="${wkDIR}/results/e1_canu_ec/maker/juicer_purge_10/split"
dbDIR="${wkDIR}/DB"
binDIR="/apps/software/interproscan/5.27-66.0-foss-2016b/"

export TMPDIR=${outDIR}

if [ -d ${outDIR}/map_id_rnd3 ]; then
    echo "Folder augustus exists ... "
else
    mkdir -p ${outDIR}/map_id_rnd3
fi

cd ${outDIR}/map_id_rnd3

##step 4, change gene ids

echo -ne "***Now is changing gene id at: "
date

cp ../S_flavescens.split_rnd3.all.gff ./
cp ../S_flavescens.split_rnd3.all.maker.proteins.fasta ./
cp ../S_flavescens.split_rnd3.all.maker.transcripts.fasta ./
cp ../annotate_rnd3/S_flavescens.split_rnd3.all.maker.proteins.blastp.scov_90.txt ./
cp ../annotate_rnd3/S_flavescens.split_rnd3.all.maker.proteins.inrscan ./

/usr/bin/time --verbose maker_map_ids \
    --prefix Sfv1_ \
    --justify 8 \
    S_flavescens.split_rnd3.all.gff \
    >S_flavescens.split_rnd3.all.map

map_fasta_ids S_flavescens.split_rnd3.all.map \
    S_flavescens.split_rnd3.all.maker.proteins.fasta 

map_fasta_ids S_flavescens.split_rnd3.all.map \
    S_flavescens.split_rnd3.all.maker.transcripts.fasta 

map_data_ids S_flavescens.split_rnd3.all.map \
    S_flavescens.split_rnd3.all.maker.proteins.blastp.scov_90.txt

map_data_ids S_flavescens.split_rnd3.all.map \
    S_flavescens.split_rnd3.all.maker.proteins.inrscan

echo -ne "The program ends at: "
date
