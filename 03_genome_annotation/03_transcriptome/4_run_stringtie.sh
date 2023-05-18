##Date: 2020/1120
##Zhipeng
##Genome guided transcriptome assembly using StringTie 

       
echo -ne "The StringTie starts at: "
date
wkDIR="/program/WGS_20190107/transcriptome"
fastqTrimDIR="${wkDIR}/results/2_trimmomatic"
starDIR="${wkDIR}/results/3_2_STAR_juicer_purge_10"
npDIR="/program/WGS_20190107/nanopore"
dbDIR="${npDIR}/results/e1_canu_ec/juicer/purge_10/postReview"
starDB="${dbDIR}/STAR_150"
outDIR="${wkDIR}/results/4_2_stringtie_juicer_purge_10"

#########make output dir
if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ..."
else
    mkdir $outDIR
fi

##merge bam files
cd $starDIR
bam_FILES=$(ls *.bam | tr '\r\n' ' ')
/usr/bin/time --verbose samtools merge merged.bam $bam_FILES

##transcriptome assembly using StringTie v2.1.4
cd $outDIR

/usr/bin/time --verbose stringtie -p 16 \
    -o S_flavescens.stringtie_GTA.transcripts.gtf \
    ${starDIR}/merged.bam

/usr/bin/time --verbose gffread \
    -w S_flavescens.stringtie_GTA.transcripts.fa \
    -g ${dbDIR}/curated.FINAL.fasta \
    S_flavescens.stringtie_GTA.transcripts.gtf

echo -ne "The StringTie ends at: "
date

