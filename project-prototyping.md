# Project Prototyping

It might feel daunting right now to conceive and attempt to complete a bioinformatics project when you may not know how to get your input data, when you have a short list of tools you think you'll need to use (but have never used before), and don't know how it will all go together exactly.

Here are some suggestions for how to break the challenge down into smaller bits. Bits that are managable. Bits that can become more specific. And bits that naturally turn into code you can run. And code that gives you your results.

## Make a list and a skeleton of the workflow

Let's say you googled for `hisat2 deseq2` because you know you want to do  RNA-seq analysis, and you think you want to use those two tools (advice from someone?) and you found [this lesson from the team that makes fastqc (and you like fastqc, so maybe you'll like their advice too)](https://www.bioinformatics.babraham.ac.uk/training/RNASeq_Course/Analysing%20RNA-Seq%20data%20Exercise.pdf)

Start a list of the things you will need and also a skeleton what you need to do. Your list of things is more or less nouns (what? and from where?). Your skeleton is a list of actions (verbs) you need to perform. Computers and programs perform actions, so this skeleton can naturally evolve into the literal commands you will run for your project.

Make this outline in Atom, BBedit, VS Code or some other text editor. You could even just do it on the server, using `nano` (but if you use nano, also plan on staying logged into the server twice. Once for your nano window as you craft your recipe, and a second window for testing and running commands, piece by piece). And either mark it up in markdown syntax, or as if it was a shell script and comment out all the lines with a `#` in the front (or both).

Start with the list of things you need. Save it as `my_rnaseq_methods.sh` (or similar) if you're writing it like it already was a shell script full of commands (meaning all of these notes are comments), or as `my_rnaseq_methods.md` if you've written it more like a markdown text document.

```bash
# Document: my_rnaseq_methods.md
# Contains list of pre-requisites to get started
############
# Things I need for RNA-seq
############
## Input experiment data (Illumina FASTQ files for yeast or mouse samples), from NCBI (but how?)
## The mouse or yeast ref_genome [From ncbi or from ensembl? how to get?]
## These programs (complete? not sure.)
## - fastqc
## - trim galore
## - cutadapt
## - hisat2
## - samtools
## - Seqmonk (Graphical program. Put on laptop)
## - DEseq2 (R package. don't need on server)
## - edgeR (ditto)
```

As you later refine or change your method, you can and should edit your list of things you need. You're naturally tracking the growth of your project in this document.

Continue on with your skeleton of methods as you understand it. Again, either comment style or markdown style. This section might start like this at the beginning

```bash
############
# Outline of my method (try to start with verbs/actions)
############
# install programs
# get Illumina RNA data
# check QC
# trim
# align to genome
# find differentially expressed genes (DEseq2, i think)
# turn in final
```

And it will get more elaborate (relatively quickly) as you fill in the gaps and break these steps down into things closer and closer to the actual commands needed to get the job done, and start thinking about the inputs and outputs of each tool and how to plug them together, step by step. You might already know how you want to install things, and so you should write that command in the skeleton and run it (or the other way around).

```bash
############
# Outline of my method (try to start with verbs/actions)
############
# install all my programs on server
conda create -n rna_env hisat2 samtools trim-galore cutadapt fastqc
# get input Fastq data from NCBI (how?). 12 samples
# get reference genome from ___ (how? ftp?)
# make folders for input data, ref_genome, results (and intermediate files)
# (probably have to) fiddle with the downloaded sequences (renaming? sub-sampling w/ seqtk to make a test data set?) sub-sampling w/ seqtk to make a test data set?)
# assess raw data quality (fastqc)
# trim raw data (trim galore)
# assess trimmed data quality (fastqc)
# (maybe) Trim differently. change trimming settings to try to improve quality more? trim+qc more? trim+qc
# generate the hisat2 index for genome (just once, will use for all samples)
# align trimmed data to indexed genome (hisat2)
# manipulate hisat2 outputs (SAM?) to make sorted bams (samtools)
# download bam files to laptop (too big? hope not!)
# generate counts with SeqMonk
# install DEseq2 and edgeR in R
# test for differential expression (look up example of how first)
# plot figures in R (which ones?)
# get data and results out of R and into normal files
# write all this up
```

**Caveats, exceptions, & more advice:**
* You don't HAVE TO follow these suggestions. If you devise, execute, document and complete your project by whatever means neccessary, fine by your instructor.
* You may not wish to put/keep your noun list and your verb list in the same document. Feel free to break things up if it feels like you're spending a lot of time fighting your conventions.
* Things you will do on your laptop probably belong in another document.
* R scripts definitely belong in another document.
* If you make and use bash `for` loops to execute some step/steps, you may want to shove those loops in their own shell script instead of in this ever-growing recipe. My advice:
	- Sure. Do that. Fancy loop(s) in their own scripts.
	- But add the name of that loop script to your noun list.
	- And write a line or lines in your skeleton for how you run your fancy script. such as:

```bash
# run my fancy trimming loop script to trim all 12 files
tmux
source activate rna_env
bash my_fancy_trim_loop.sh
```

### More mini-topics
* other mini-topic: Project prototyping advice [project-prototyping.md](https://github.com/rltillett/bch-709/blob/master/project-prototyping.md)
* other mini-topic: A wild R demonstration[r-demo](https://github.com/rltillett/bch-709/blob/master/r-demo.md)
