##Date: 08/09/17
##Zhipeng
##Genome mapping with RSEM

#!/bin/bash

echo -ne "The RSEM alignment rsemts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626"
fastqTrimDIR="${wkDIR}/transcriptome/results/2_trimmomatic"
rsemDIR="${wkDIR}/nanopore/results/e1_canu_ec/maker/juicer_purge_10/RSEM"
dbDIR="${wkDIR}/nanopore/results/e1_canu_ec/maker/juicer_purge_10/final_genome"
rsemDB="${dbDIR}/RSEM"

#########make output dir
if [ -d $rsemDIR ]; then
    echo "Folder $rsemDIR exists ..."
else
    mkdir $rsemDIR
fi

#test if genome exists, if not, build genome index
if [ -d $rsemDB ]; then
    echo "Genome folder exists ..."
else
    echo "Now is generating genome index ... "
    date
    mkdir $rsemDB
    rsem-prepare-reference --gtf ${dbDIR}/Sfla_v1.cdna.gtf \
        --bowtie \
        ${dbDIR}/Sfla_v1.chr.fa \
        ${rsemDB}/Sfla_v1

fi



#mapping
cd $fastqTrimDIR
FILES=$(ls *_trimmed_R1.fq.gz)

cd $rsemDIR
for f in $FILES
do
    filename=${f%_trimmed_R1.fq.gz}
    echo -ne "Now is processing $filename ..."
    date

    rsem-calculate-expression \
        -p 32 \
        --paired-end \
        <(zcat ${fastqTrimDIR}/${filename}_trimmed_R1.fq.gz) \
        <(zcat ${fastqTrimDIR}/${filename}_trimmed_R2.fq.gz) \
        ${rsemDB}/Sfla_v1 \
        ${filename}

done

echo -ne "The RSEM alingemnt finishs at: "
date

