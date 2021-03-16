# nf-blast
Work in progress - nextflow blast.

## Why you shouldn't use nf-blast
 - Only tested on our architecture
 - Annotation of id to sequence names only works with one nt database version to date
 - O

## Why you should use nf-blast
 - You're brave
 - You have a bit of time on your hands
 - You really, really want to run blast on your cluster



# Install 

## Database
- Download nt database (5. July 2018 tested)

## Set up nf-blast

git clone https://github.com/colindaven/nf-blast
#Set up your conda environment
conda env create -f env.nextflow.yml
conda activate nextflow
