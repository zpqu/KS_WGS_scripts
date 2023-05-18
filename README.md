# Scripts for the de novo genome asembly of Sophora Flavescens

## Introduction
This archive includes scripts used to do de novo genome assembly of Sophora Flavescens (苦参, Ku-shen). The sequencing data used to do genome assembly including following datasets:

- Nanopore WGS sequencing: ~100x
- Illumina WGS sequencing: ~100x
- HiC WGS sequencing: ~100x
- Transcriptome sequencing: from leaf, stem and root

## Description of scripts

The folder structure of this archive is as follows:

```
./KS_WGS_scripts/
├── [May 18 14:09]  01_genome_survey
├── [May 18 11:25]  02_genome_assembly
│   ├── [May 18 14:02]  01_QC
│   ├── [May 18 14:02]  02_1_raven_raw_all
│   ├── [May 18 14:02]  02_2_raven_raw_N50
│   ├── [May 18 14:03]  03_1_smartdenovo_raw_all
│   ├── [May 18 14:03]  03_2_smartdenovo_raw_N50
│   ├── [May 18 14:03]  04_1_wtdbg2_raw_all
│   ├── [May 18 14:03]  04_2_wtdbg2_raw_N50
│   ├── [May 18 14:03]  05_1_flye_raw_all
│   ├── [May 18 14:04]  05_2_flye_raw_N50
│   ├── [May 18 14:04]  06_1_raven_canu_ec
│   ├── [May 18 14:04]  07_1_smartdenovo_canu_ec
│   ├── [May 18 14:04]  08_1_wtdbg2_canu_ec
│   ├── [May 18 14:04]  09_1_flye_canu_ec
│   ├── [May 18 14:04]  10_1_raven_fmlrc_N50
│   ├── [May 18 14:04]  11_1_smartdenovo_fmlrc_N50
│   ├── [May 18 14:04]  12_1_wtdbg2_fmlrc_N50
│   ├── [May 18 14:05]  13_1_flye_fmlrc_N50
│   ├── [May 18 14:05]  e1_canu_ec
│   ├── [May 18 14:05]  e2_fmlrc_ec
│   ├── [May 18 14:05]  t1_1_purge_haplotigs
│   ├── [May 18 14:05]  t1_2_HiC_scaffolding
│   └── [May 18 14:06]  t1_canu_assembly
├── [May 18 13:21]  03_genome_annotation
│   ├── [May 18 14:06]  01_gene_annotation
│   ├── [May 18 14:08]  02_repeat_annotation
│   └── [May 18 14:08]  03_transcriptome
└── [Jul 11  2022]  04_phylogenomics
    ├── [May 18 14:08]  01_orthofinder
    ├── [May 18 14:07]  02_gene_expansion
    └── [May 18 14:07]  03_WGD

33 directories
```

There are four top level folders, including scripts used to perform four different parts of the analysis in the project.

### 01_Genome survey
The folder `01_genome_survey` includes scripts used to do genome survey analysis using illumina WGS sequencing dataset.

### 02_genome_assembly
This folder includes scritps to do de novo genome assembly. To obtain a high-quality reference genome, we used 17 different assembly strategies (see following table). The initial strategy was to use the CANU-only (v2.0) pipeline. After the error-correction of Nanopore reads using the CANU `correct` module, we used the CANU `trim` module to remove low quality regions in error-corrected reads. The genome was then assembled using the CANU `assemble` module. In addition, we also tried four other assemblers, including Raven (v1.1.10), SMARTdenovo (v1.0), wtdbg2 (v1.1) and Flye (v2.7.1) on four different input datasets respectively. The first input dataset includes all nanopore raw reads (named as `raw_all`). The second input dataset is a subset of the first dataset, including only raw reads longer than the N50 of all raw reads (named as `raw_N50`). The third input dataset includes error-corrected Nanopore reads using CANU (named as `canu_ec`). And the fourth input dataset includes error-corrected reads longer than the N50 of all error-corrected reads using FMLRC (v1.0.0) (`fmlrc_N50`). 

| Assembler   | Input     | Number_of_reads | N50_of_reads | Depth  |
|-------------|-----------|-----------------|--------------|--------|
| raven       | raw_all   | 1,968,671,916   | 25.4         | 105.9x |
| smartdenovo | raw_all   | 3,104,086,840   | 25.4         | 105.9x |
| wtdbg2      | raw_all   | 2,785,948,512   | 25.4         | 105.9x |
| flye        | raw_all   | 2,785,242,597   | 25.4         | 105.9x |
| raven       | raw_N50   | 1,458,531,649   | 37.8         | 52.9x  |
| smartdenovo | raw_N50   | 2,173,979,684   | 37.8         | 52.9x  |
| wtdbg2      | raw_N50   | 2,790,423,511   | 37.8         | 52.9x  |
| flye        | raw_N50   | 2,852,564,288   | 37.8         | 52.9x  |
| raven       | fmlrc_N50 | 390,557,486     | 37.9         | 52.9x  |
| smartdenovo | fmlrc_N50 | 2,183,176,129   | 37.9         | 52.9x  |
| wtdbg2      | fmlrc_N50 | 4,537,814,869   | 37.9         | 52.9x  |
| flye        | fmlrc_N50 | 2,307,728,032   | 37.9         | 52.9x  |
| raven       | canu_ec   | 511,724,891     | 20           | 94.2x  |
| smartdenovo | canu_ec   | 2,520,480,671   | 20           | 94.2x  |
| wtdbg2      | canu_ec   | 2,786,293,469   | 20           | 94.2x  |
| flye        | canu_ec   | 1,904,306,272   | 20           | 94.2x  |
| canu        | canu_ec   | 3,636,323,899   | 20           | 94.2x  |

Haplotigs were then purged from contigs (subfolder `t1_1_purge_haplotigs`), and then contigs with haplotigs removed were further scaffolded using HiC WGS sequencing dataset. Scripts used to do scaffolding are stored in subfolder `t1_2_HiC_scaffolding`. 

### 03_genome_annotation
This folder includes scripts to do gene annotation (subfolder `01_gene_annotation`), repeat annotation (subfolder `02_repeat_annotation`) and transcriptome analysis (subfolder `03_transcriptome`).

### 04_phylogenomics
This folder includes scripts to do phylogenomics for the assembled genome, including:

- 01_orthofinder: Orthologs identification
- 02_gene_expansion: Gene expansion and contraction analysis
- 03_WGD: Whole genome duplication analysis

## List of used tools/softwares

| Name            | Version  | Datasets           | Link                                             |
|-----------------|----------|--------------------|--------------------------------------------------|
| Trimmomatic     | v0.39    | Illumina           | http://www.usadellab.org/cms/?page=trimmomatic   |
| jellyfish       | v2.3.0   | Illumina           | https://github.com/gmarcais/Jellyfish            |
| GenomeScope     | v1.0     | Illumina           | http://qb.cshl.edu/genomescope/                  |
| CANU            | v2.0     | Nanopore           | https://github.com/marbl/canu                    |
| FMLRC           | v1.0.0   | Illumina, Nanopore | https://github.com/holtjma/fmlrc                 |
| Raven           | v1.1.10  | Nanopore           | https://github.com/lbcb-sci/raven                |
| SMARTdenovo     | v1.0     | Nanopore           | https://github.com/ruanjue/smartdenovo           |
| wtdbg2          | v1.1     | Nanopore           | https://github.com/ruanjue/wtdbg2                |
| Flye            | v2.7.1   | Nanopore           | https://github.com/fenderglass/Flye              |
| Racon           | v1.4.16  | Nanopore           | https://github.com/isovic/racon                  |
| medaka          | v1.0.3   | Nanopore           | https://github.com/nanoporetech/medaka           |
| nextpolish      | v1.2.4   | Illumina           | https://github.com/Nextomics/NextPolish          |
| BUSCO           | v4.1.4   | Assembly           | https://busco.ezlab.org/                         |
| purge_haplotigs | v1.1.1   | Assembly           | https://bitbucket.org/mroachawri/purge_haplotigs |
| 3D-DNA          | v180922  | Assembly           | https://github.com/aidenlab/3d-dna               |
| Juicebox        | v1.13.01 | Assembly           | https://github.com/aidenlab/Juicebox             |
| minimap2        | v2.17    | Nanopore           | https://github.com/lh3/minimap2                  |
| Maker           | v3.01.03 | Annotation         | https://www.yandell-lab.org/software/maker.html  |
| StringTie       | V2.1.4   | Annotation         | https://ccb.jhu.edu/software/stringtie/          |
| Augustus        | v3.2.3   | Annotation         | https://bioinf.uni-greifswald.de/augustus/       |
| EDTA            | v1.9.7   | Annotation         | https://github.com/oushujun/EDTA                 |
| PANTHER         | online   | Annotation         | http://www.pantherdb.org/                        |
| OrthoFinder     | v2.5.2   | Phylogenomics      | https://github.com/davidemms/OrthoFinder         |
| CAFE            | v4.2.1   | Phylogenomics      | https://github.com/hahnlab/CAFE                  |
| DupGen_finder   | NA       | Phylogenomics      | https://github.com/qiao-xin/DupGen_finder        |
| MCScanX         | NA       | Phylogenomics      | https://github.com/wyp1125/MCScanX               |
| SynVisio        | online   | Annotation         | https://github.com/kiranbandi/synvisio           |
