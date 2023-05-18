#! /bin/bash

##############################################
# ARIMA GENOMICS MAPPING PIPELINE 02/08/2019 #
##############################################

#Below find the commands used to map HiC data.

#Replace the variables at the top with the correct paths for the locations of files/programs on your system.

#This bash script will map one paired end HiC dataset (read1 & read2 fastqs). Feel to modify and multiplex as you see fit to work with your volume of samples and system.

##########################################
# Commands #
##########################################

wkDIR="/fast/genome/KS_WGS_20200626"
binDIR="/home/apps/ArimaGenomics/mapping_pipeline"
outDIR="${wkDIR}/nanopore/results/e1_canu_ec/SALSA2"


SRA="KS_HiC"
LABEL="KS"
BWA="bwa"
SAMTOOLS="samtools"
IN_DIR="${wkDIR}/HiC/results/2_trimmomatic"
REF="${wkDIR}/nanopore/results/e1_canu_ec/purge_haplotigs/curated.fasta"
FAIDX="${REF}.fai"
PREFIX="${REF}"
RAW_DIR="${outDIR}/raw"
FILT_DIR="${outDIR}/filt"
FILTER="${binDIR}/filter_five_end.pl"
COMBINER="${binDIR}/two_read_bam_combiner.pl"
STATS="${binDIR}/get_stats.pl"
PICARD="$EBROOTPICARD/picard.jar"
TMP_DIR="$outDIR/tmp"
PAIR_DIR="$outDIR/pair"
REP_DIR="$outDIR/rep"
REP_LABEL="${LABEL}_rep1"
MERGE_DIR="${outDIR}/merge"
MAPQ_FILTER=10
CPU=32

echo "### Step 0: Check output directories exist & create them as needed"
[ -d $outDIR ] || mkdir -p $outDIR
[ -d $RAW_DIR ] || mkdir -p $RAW_DIR
[ -d $FILT_DIR ] || mkdir -p $FILT_DIR
[ -d $TMP_DIR ] || mkdir -p $TMP_DIR
[ -d $PAIR_DIR ] || mkdir -p $PAIR_DIR
[ -d $REP_DIR ] || mkdir -p $REP_DIR
[ -d $MERGE_DIR ] || mkdir -p $MERGE_DIR

cd $outDIR

echo -ne "### Step 0: Index reference" # Run only once! Skip this step if you have already generated BWA index files
date
/usr/bin/time --verbose $BWA index -a bwtsw -p $PREFIX $REF

echo -ne "### Step 1.A: FASTQ to BAM (1st)"
date
/usr/bin/time --verbose $BWA mem -t $CPU $REF $IN_DIR/$SRA\_R1.paired.fq.gz | $SAMTOOLS view -@ $CPU -Sb - > $RAW_DIR/$SRA\_1.bam

echo -ne "### Step 1.B: FASTQ to BAM (2nd)"
date
/usr/bin/time --verbose $BWA mem -t $CPU $REF $IN_DIR/$SRA\_R2.paired.fq.gz | $SAMTOOLS view -@ $CPU -Sb - > $RAW_DIR/$SRA\_2.bam

echo -ne "### Step 2.A: Filter 5' end (1st)"
date
/usr/bin/time --verbose $SAMTOOLS view -h $RAW_DIR/$SRA\_1.bam | perl $FILTER | $SAMTOOLS view -Sb - > $FILT_DIR/$SRA\_1.bam

echo -ne "### Step 2.B: Filter 5' end (2nd)"
date
/usr/bin/time --verbose $SAMTOOLS view -h $RAW_DIR/$SRA\_2.bam | perl $FILTER | $SAMTOOLS view -Sb - > $FILT_DIR/$SRA\_2.bam

echo -ne "### Step 3A: Pair reads & mapping quality filter"
date
/usr/bin/time --verbose perl $COMBINER $FILT_DIR/$SRA\_1.bam $FILT_DIR/$SRA\_2.bam $SAMTOOLS $MAPQ_FILTER | $SAMTOOLS view -bS -t $FAIDX - | $SAMTOOLS sort -@ $CPU -o $TMP_DIR/$SRA.bam -

echo -ne "### Step 3.B: Add read group"
date
/usr/bin/time --verbose java -Xmx4G -Djava.io.tmpdir=temp/ -jar $PICARD AddOrReplaceReadGroups INPUT=$TMP_DIR/$SRA.bam OUTPUT=$PAIR_DIR/$SRA.bam ID=$SRA LB=$SRA SM=$LABEL PL=ILLUMINA PU=none

###############################################################################################################################################################
###                                           How to Accommodate Technical Replicates                                                                       ###
### This pipeline is currently built for processing a single sample with one read1 and read2 fastq file.                                                    ###
### Technical replicates (eg. one library split across multiple lanes) should be merged before running the MarkDuplicates command.                          ###
### If this step is run, the names and locations of input files to subsequent steps will need to be modified in order for subsequent steps to run correctly.###
### The code below is an example of how to merge technical replicates.                                                                                      ###
###############################################################################################################################################################
#	REP_NUM=X #number of the technical replicate set e.g. 1
#	REP_LABEL=$LABEL\_rep$REP_NUM
#	INPUTS_TECH_REPS=('bash' 'array' 'of' 'bams' 'from' 'replicates') #BAM files you want combined as technical replicates
#   example bash array - INPUTS_TECH_REPS=('INPUT=A.L1.bam' 'INPUT=A.L2.bam' 'INPUT=A.L3.bam')
#	java -Xmx8G -Djava.io.tmpdir=temp/ -jar $PICARD MergeSamFiles $INPUTS_TECH_REPS OUTPUT=$TMP_DIR/$REP_LABEL.bam USE_THREADING=TRUE ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT

echo -ne "### Step 4: Mark duplicates"
date
/usr/bin/time --verbose java -Xmx30G -XX:-UseGCOverheadLimit -Djava.io.tmpdir=temp/ -jar $PICARD MarkDuplicates INPUT=$PAIR_DIR/$SRA.bam OUTPUT=$REP_DIR/$REP_LABEL.bam METRICS_FILE=$REP_DIR/metrics.$REP_LABEL.txt TMP_DIR=$TMP_DIR ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=TRUE

/usr/bin/time --verbose $SAMTOOLS index $REP_DIR/$REP_LABEL.bam

/usr/bin/time --verbose perl $STATS $REP_DIR/$REP_LABEL.bam > $REP_DIR/$REP_LABEL.bam.stats

echo -ne "Finished Mapping Pipeline through Duplicate Removal"
date

#########################################################################################################################################
###                                       How to Accommodate Biological Replicates                                                    ###
### This pipeline is currently built for processing a single sample with one read1 and read2 fastq file.                              ###
### Biological replicates (eg. multiple libraries made from the same sample) should be merged before proceeding with subsequent steps.###
### The code below is an example of how to merge biological replicates.                                                               ###
#########################################################################################################################################
#
#	INPUTS_BIOLOGICAL_REPS=('bash' 'array' 'of' 'bams' 'from' 'replicates') #BAM files you want combined as biological replicates
#   example bash array - INPUTS_BIOLOGICAL_REPS=('INPUT=A_rep1.bam' 'INPUT=A_rep2.bam' 'INPUT=A_rep3.bam')
#
#	java -Xmx8G -Djava.io.tmpdir=temp/ -jar $PICARD MergeSamFiles $INPUTS_BIOLOGICAL_REPS OUTPUT=$MERGE_DIR/$LABEL.bam USE_THREADING=TRUE ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT
#
#	$SAMTOOLS index $MERGE_DIR/$LABEL.bam

# perl $STATS $MERGE_DIR/$LABEL.bam > $MERGE_DIR/$LABEL.bam.stats

# echo "Finished Mapping Pipeline through merging Biological Replicates"
