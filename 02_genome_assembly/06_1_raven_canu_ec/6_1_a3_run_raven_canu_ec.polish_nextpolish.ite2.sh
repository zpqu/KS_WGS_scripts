#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/hpcfs/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
sgsDIR="/hpcfs/KS_WGS_20200626/illumina/results/2_trimmomatic"
outDIR="${wkDIR}/results/6_1_raven_canu_ec"
binDIR="/home/apps/NextPolish"

#activate conda env
source /apps/software/Anaconda3/2019.03/etc/profile.d/conda.sh
conda activate nextPolish

echo -ne "The program starts at: "
date

if [ -d ${outDIR}/nextPolish ]; then
    echo "Folder ${outDIR}/nextPolish exists ... "
else
    mkdir ${outDIR}/nextPolish
fi

echo -ne "***Now is polishing genome using nextpolish***"
date

cd ${outDIR}/nextPolish

#Set input and parameters
round=1
threads=32
read1=${sgsDIR}/KS_illumina_R1.paired.fq.gz
read2=${sgsDIR}/KS_illumina_R2.paired.fq.gz
input=genome.nextpolish.fa
for ((i=1; i<=${round};i++)); do
#step 1:
    echo -ne "Now is processing round $i polishing ..."
	#index the genome file and do alignment
	/usr/bin/time --verbose ${binDIR}/bin/bwa index ${input};
	/usr/bin/time --verbose ${binDIR}/bin/bwa mem -t ${threads} ${input} ${read1} ${read2}|${binDIR}/bin/samtools view --threads ${threads} -F 0x4 -b - |${binDIR}/bin/samtools sort - -m 4g --threads ${threads} -o sgs.sort.bam;
	#index bam and genome files
	/usr/bin/time --verbose ${binDIR}/bin/samtools index -@ ${threads} sgs.sort.bam;
	/usr/bin/time --verbose ${binDIR}/bin/samtools faidx ${input};
	#polish genome file
	/usr/bin/time --verbose python ${binDIR}/lib/nextpolish1.py -g ${input} -t 1 -p ${threads} -s sgs.sort.bam > genome.polishtemp.fa;
	input=genome.polishtemp.fa;
#step2:
	#index genome file and do alignment
	/usr/bin/time --verbose ${binDIR}/bin/bwa index ${input};
	/usr/bin/time --verbose ${binDIR}/bin/bwa mem -t ${threads} ${input} ${read1} ${read2}|${binDIR}/bin/samtools view --threads ${threads} -F 0x4 -b - |${binDIR}/bin/samtools sort - -m 4g --threads ${threads} -o sgs.sort.bam;
	#index bam and genome files
	/usr/bin/time --verbose ${binDIR}/bin/samtools index -@ ${threads} sgs.sort.bam;
	/usr/bin/time --verbose ${binDIR}/bin/samtools faidx ${input};
	#polish genome file
	/usr/bin/time --verbose python ${binDIR}/lib/nextpolish1.py -g ${input} -t 2 -p ${threads} -s sgs.sort.bam > genome.nextpolish.fa;
	input=genome.nextpolish.fa;
done;

echo -ne "The program ends at: "
date

