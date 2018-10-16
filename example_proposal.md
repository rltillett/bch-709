# Identification of variants in the evolution of novel aerobic citrate metabolism in Escheria coli

Blount and colleagues (2012) propagated 12 populations of _Escherichia coli_ for 40,000 generations in glucose-limited minimal medium, supplemented with citrate, which wild-type E. coli (strain REL606) cannot metabolize under aerobic conditions. Samples of the populations were preserved at multiple time-points (every 500 generations) during their experiment, which were later strategically sequenced to reveal the mutational landscape preceding the evolution of the Cit+ trait. They found that the citrate-using mutants (described as Cit+ or Ara-3) appeared in a population of _E.coli_ at around 31,000 generations. Though Blount et al used a highly-specific tool, _breseq_, for their genomic comparisons and analyses (Deatherage & Barrick, 2014), we seek to analyze a subset of these samples (6 samples, see Table 1) with tools common to various types of experiments and compare our results to those published.

## Specific aim 1: Identify variants in six samples from Blount et al 2012, using the tools described in the Data Carpentry Genomics Workshops.

Of the 37 sequencing experiments analyzed by Blount et al, 6 were selected to analyze variants prior to and after the emergence of the Cit+ trait (Table 1). Sequence libraries will be downloaded to the BCH709 server from NCBI's Sequence Read Archive (SRA) using the NCBI SRA Toolkit (Sequence Read Archive Submissions Staff, 2011-) for the six enumerated runs within the Archive [http://www.ncbi.nlm.nih.gov/sra?term=SRA026813](http://www.ncbi.nlm.nih.gov/sra?term=SRA026813).

The variant calling workflow described in the Data Carpentry Wrangling Genomics Lesson will be used for this analysis (Herr et al, 2017). Library quality for the downloaded samples will be assessed by FastQC software (Andrews, 2010). Sequences will then be trimmed using Trimmomatic (Bolger et al, 2014). Quality assesment of trimmed reads will also be performed using FastQC. Trimmed reads will be aligned to the E. coli REL606 genome using BWA, a short read aligner (Li & Durbin, 2009). BWA alignments will be converted to SAM format (Li et al, 2009) using _bwa samse_. SAM format alignments will be compressed into binary formats (BAM files) and sorted using _samtools_. Sequence coverage at every base on the REL606 genome will then be called using the samtools _mpileup_ tool, generating a Binary Call Format (BCF) file, a compressed version of the Variant Call format (VCF) (Li 2011; Danecek et al, 2011). Single nucleotide polymorphisms will be identified using bcftools, and then filtered using _vcfutils.pl varFilter_. Alignments will be viewed using the Integrative Genomics Viewer (IGV), ran locally on a workstation (Thorvaldsdóttir et al, 2013).

Table 1. Selected samples from the Data Carpentry Lesson (Herr et al, 2017)

| SRA Run Number | Clone | Generation | Cit |
| -------------- | ----- | ---------- | ----- |
| SRR098028 | REL1166A | 2,000 | Unknown |
| SRR098281 | ZDB409 | 5,000 | Unknown |
| SRR098283 | ZDB446 | 15,000 | Cit- |
| SRR097977 | CZB152 | 33,000 | Cit+ |
| SRR098026 | CZB154 | 33,000 | Cit+ |
| SRR098027 | CZB199 | 33,000 | Cit- |

## Aim 2: Comparison of variants with Bolger et al.

<specific aim 2 methods go here>

Citations

Andrews S. FastQC: a quality control tool for high throughput sequence data.

Blount, Z.D., Barrick, J.E., Davidson, C.J., Lenski, R.E. (2012) Genomic analysis of a key innovation in an experimental Escherichia coli population. Nature, 489 (7417), pp. 513-518.

Bolger AM, Lohse M, Usadel B. Trimmomatic: a flexible trimmer for Illumina sequence data. Bioinformatics. 2014 Apr 1;30(15):2114-20.

Danecek P, Auton A, Abecasis G, Albers CA, Banks E, DePristo MA, Handsaker RE, Lunter G, Marth GT, Sherry ST, McVean G. The variant call format and VCFtools. Bioinformatics. 2011 Jun 7;27(15):2156-8.

Deatherage DE and Barrick JE (2014) Identification of mutations in laboratory-evolved microbes from next-generation sequencing data using breseq. Methods Mol. Biol. 1151: 165–188.

Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R. The sequence alignment/map format and SAMtools. Bioinformatics. 2009 Aug 15;25(16):2078-9.

Li H, Durbin R. Fast and accurate short read alignment with Burrows–Wheeler transform. bioinformatics. 2009 Jul 15;25(14):1754-60.

Li H. A statistical framework for SNP calling, mutation discovery, association mapping and population genetical parameter estimation from sequencing data. Bioinformatics. 2011 Sep 8;27(21):2987-93.

Herr J, Tang M, Nederbragt L, Psomopoulos F (eds): "Data Carpentry: Wrangling Genomics Lesson." Version 2017.11.0, November 2017, http://www.datacarpentry.org/wrangling-genomics/ doi: 10.5281/zenodo.1064254.

Jeong H, Barbe V, Lee CH, Vallenet D, Yu DS, Choi SH, Couloux A, Lee SW, Yoon SH, Cattolico L, Hur CG. Genome sequences of Escherichia coli B strains REL606 and BL21 (DE3). Journal of molecular biology. 2009 Dec 11;394(4):644-52.

Sequence Read Archive Submissions Staff. Downloading SRA data using command line utilities. In: SRA Knowledge Base [Internet]. Bethesda (MD): National Center for Biotechnology Information (US); 2011-. Available from: https://www.ncbi.nlm.nih.gov/books/NBK158899/

Thorvaldsdóttir H, Robinson JT, Mesirov JP. Integrative Genomics Viewer (IGV): high-performance genomics data visualization and exploration. Briefings in bioinformatics. 2013 Mar 1;14(2):178-92.
