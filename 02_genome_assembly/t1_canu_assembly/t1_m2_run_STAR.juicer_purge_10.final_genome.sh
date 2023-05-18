##Date: 18/09/17
##Zhipeng
##Genome mapping with STAR

#!/bin/bash

echo -ne "The STAR alignment starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626"
fastqTrimDIR="${wkDIR}/transcriptome/results/2_trimmomatic"
starDIR="${wkDIR}/nanopore/results/e1_canu_ec/maker/juicer_purge_10/STAR"
dbDIR="${wkDIR}/nanopore/results/e1_canu_ec/maker/juicer_purge_10/final_genome"
starDB="${dbDIR}/STAR_150"

#########make output dir
if [ -d $starDIR ]; then
    echo "Folder $starDIR exists ..."
else
    mkdir $starDIR
fi

#test if genome exists, if not, build genome index
if [ -d $starDB ]; then
    echo "Genome folder exists ..."
else
    echo "Now is generating genome index ... "
    date
    mkdir $starDB
    STAR --runThreadN 16 --runMode genomeGenerate \
      --genomeDir ${starDB} \
      --genomeFastaFiles ${dbDIR}/Sfla_v1.chr.fa \
      --sjdbGTFfile ${dbDIR}/Sfla_v1.cdna.gtf \
      --sjdbOverhang 149

fi


##Using genome with sjdbOverhang 150, mismatches 10 (or < 0.05 of whole length of reads) for paired-end reads 
cd $fastqTrimDIR
FILES=$(ls *_trimmed_R1.fq.gz)

cd $starDIR
for f in $FILES
do
    filename=${f%_trimmed_R1.fq.gz}
    echo -ne "Now is processing $filename ..."
    date
    STAR --genomeDir ${starDB} \
      --readFilesIn ${fastqTrimDIR}/${filename}_trimmed_R1.fq.gz ${fastqTrimDIR}/${filename}_trimmed_R2.fq.gz \
      --readFilesCommand zcat --runThreadN 16 --outSAMstrandField intronMotif \
      --outSAMattributes All --outFilterMismatchNmax 10 \
      --outFilterMismatchNoverLmax 0.03 \
      --outFilterMultimapNmax 5 \
      --alignIntronMax 10000 \
      --outSAMtype BAM SortedByCoordinate \
      --outFileNamePrefix ${starDIR}/${filename}. \
      --quantMode GeneCounts
    samtools index ${starDIR}/${filename}.Aligned.sortedByCoord.out.bam
done

echo -ne "The STAR alingemnt finishs at: "
date

