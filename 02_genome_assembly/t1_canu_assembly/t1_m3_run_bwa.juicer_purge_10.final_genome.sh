##Date: 18/09/17
##Zhipeng
##Genome mapping with BWA

#!/bin/bash

echo -ne "The BWA alignment starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626"
fastqTrimDIR="${wkDIR}/illumina/results/2_trimmomatic"
outDIR="${wkDIR}/nanopore/results/e1_canu_ec/maker/juicer_purge_10/BWA"
dbDIR="${wkDIR}/nanopore/results/e1_canu_ec/maker/juicer_purge_10/final_genome"

#########make output dir
if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ..."
else
    mkdir $outDIR
fi

#test if genome exists, if not, build genome index
if [ -f ${dbDIR}/Sfla_v1.chr.fa.bwt ]; then
    echo "Genome folder exists ..."
else
    echo "Now is generating genome index ... "
    date
    cd $dbDIR
    /usr/bin/time --verbose bwa index Sfla_v1.chr.fa
fi

cd $fastqTrimDIR
FILES=$(ls *_R1.paired.fq.gz)

cd $outDIR
for f in $FILES
do
    filename=${f%_R1.paired.fq.gz}
    echo -ne "Now is processing $filename ..."
    date

#    /usr/bin/time --verbose bwa mem -t 16 ${dbDIR}/Sfla_v1.chr.fa \
#        ${fastqTrimDIR}/${filename}_R1.paired.fq.gz \
#        ${fastqTrimDIR}/${filename}_R2.paired.fq.gz | \
#        samtools view --threads 16 -F 0x4 -b - | \
#        samtools sort - -m 4g --threads 16 \
#        -o S_flavescens.final_genome.illumina_bwa.sort.bam

#    /usr/bin/time --verbose samtools index \
#        -@ 16 S_flavescens.final_genome.illumina_bwa.sort.bam

    /usr/bin/time --verbose ~/GOlang/bin/bwaMapStat \
        -bam S_flavescens.final_genome.illumina_bwa.sort.bam \
        -reads 752302085 >S_flavescens.final_genome.illumina_bwa.bwaMapStat.txt

done

echo -ne "The BWA alingemnt finishs at: "
date

