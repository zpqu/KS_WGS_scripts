#! /bin/bash

echo -ne "The program starts at: "
date

wkDIR="/fast/genome/KS_WGS_20200626/nanopore"
dataDIR="${wkDIR}/data"
outDIR="${wkDIR}/results/3_2_smartdenovo_raw_N50"
minimap2DIR="/home/apps/minimap2"
raconDIR="/home/apps/racon/build/bin"

echo -ne "The program starts at: "
date

if [ -d $outDIR ]; then
    echo "Folder $outDIR exists ... "
else
    mkdir $outDIR
fi

cd $outDIR
echo -ne "***Now is polishing genome using racon 1st ite***"
date

/usr/bin/time --verbose ${minimap2DIR}/minimap2 -t 32 \
    smartdenovo_raw_N50.dmo.cns.fa \
    ${dataDIR}/KS_nanopore.fq.gz \
    >KS_nanopore.gfa_1st.paf

/usr/bin/time --verbose ${raconDIR}/racon \
    -t 32 \
    -m 8 -x -6 -g -8 -w 500 \
    ${dataDIR}/KS_nanopore.fq.gz \
    KS_nanopore.gfa_1st.paf \
    smartdenovo_raw_N50.dmo.cns.fa \
    > KS_nanopore.raw_N50.smartdenovo.racon_1st.fasta

rm KS_nanopore.gfa_1st.paf

echo -ne "***Now is polishing genome using racon 2nd ite***"
date

/usr/bin/time --verbose ${minimap2DIR}/minimap2 -t 32 \
    KS_nanopore.raw_N50.smartdenovo.racon_1st.fasta \
    ${dataDIR}/KS_nanopore.fq.gz \
    >KS_nanopore.gfa_2nd.paf

/usr/bin/time --verbose ${raconDIR}/racon \
    -t 32 \
    -m 8 -x -6 -g -8 -w 500 \
    ${dataDIR}/KS_nanopore.fq.gz \
    KS_nanopore.gfa_2nd.paf \
    KS_nanopore.raw_N50.smartdenovo.racon_1st.fasta \
    > KS_nanopore.raw_N50.smartdenovo.racon_2nd.fasta

rm KS_nanopore.gfa_2nd.paf

echo -ne "***Now is polishing genome using racon 3rd ite***"
date

/usr/bin/time --verbose ${minimap2DIR}/minimap2 -t 32 \
    KS_nanopore.raw_N50.smartdenovo.racon_2nd.fasta \
    ${dataDIR}/KS_nanopore.fq.gz \
    >KS_nanopore.gfa_3rd.paf

/usr/bin/time --verbose ${raconDIR}/racon \
    -t 32 \
    -m 8 -x -6 -g -8 -w 500 \
    ${dataDIR}/KS_nanopore.fq.gz \
    KS_nanopore.gfa_3rd.paf \
    KS_nanopore.raw_N50.smartdenovo.racon_2nd.fasta \
    > KS_nanopore.raw_N50.smartdenovo.racon_3rd.fasta

rm KS_nanopore.gfa_3rd.paf

echo -ne "***Now is polishing genome using racon 4th ite***"
date

/usr/bin/time --verbose ${minimap2DIR}/minimap2 -t 32 \
    KS_nanopore.raw_N50.smartdenovo.racon_3rd.fasta \
    ${dataDIR}/KS_nanopore.fq.gz \
    >KS_nanopore.gfa_4th.paf

/usr/bin/time --verbose ${raconDIR}/racon \
    -t 32 \
    -m 8 -x -6 -g -8 -w 500 \
    ${dataDIR}/KS_nanopore.fq.gz \
    KS_nanopore.gfa_4th.paf \
    KS_nanopore.raw_N50.smartdenovo.racon_3rd.fasta \
    > KS_nanopore.raw_N50.smartdenovo.racon_4th.fasta

rm KS_nanopore.gfa_4th.paf

echo -ne "The program ends at: "
date

