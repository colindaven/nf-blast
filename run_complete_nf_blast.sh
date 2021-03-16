#!/bin/bash
set -eo pipefail
shopt -s nullglob


# Author: Fabian Charly Friedrich, March 2020
# Author: Colin Davenport, 2018-2020
# Start from a folder containing FASTQ files or fasta files
# Setup parameters below, esp blastdb and repopath
# Usage: bash runbatch_nfblast_pipeline.sh


# Parameters
chunksize=100
subsamplesize=2000
blastdb=/lager2/rcug/seqres/nt_db/nt_2018/nt
repopath=/mnt/ngsnfs/tools/dev/nf-blast


# Copy all scripts
echo "info: copy scripts"
cp "$repopath"/recursivegzip.sh . &
cp "$repopath"/NextflowBlastIDmapper.py . &
cp "$repopath"/csv_to_xlsx_converter.py . &
wait


# Convert fastq to fasta
# If you are using fastas this step will be skipped automatically
echo "info: convert fastq to fasta - If this script fails first do: conda activate nextflow"
for fastq in ./*.fastq
do
	srun -c 4 seqtk seq -A "$fastq" > "${fastq%.fastq}".fa &
done
wait
files=fa


#Subsample
# If you do not want to subsample outcomment these part or set subsamplesize very high
echo "info: subsample"
for fasta in ./*.{fa,fasta}
do
	srun -c 4 seqtk sample  "$fasta" "$subsamplesize" > "${fasta%.fa}".subsample.fa &
done
wait
files=subsample.fa


# Run nf blast in the lowprio SLURM partition
echo "info: run nf blast"
for file in ./*.{fa,fasta}
do
	echo "info: start $file"
	#srun --partition=lowprio --mem=15000 --cpus-per-task 1  nextflow "$repopath"/main.nf -c "$repopath"/nextflow.conf --query "$file" --db "$blastdb" --chunkSize "$chunksize" -ansi-log false -with-report "${file%.fa}".report.html -with-timeline "${file%.fa}".timeline.html -with-trace > "${file%.fa}".csv &
	srun --partition=lowprio --mem=15000 --cpus-per-task 1  nextflow "$repopath"/main.nf -c "$repopath"/nextflow.conf --query "$file" --db "$blastdb" --repopath "$repopath" --chunkSize "$chunksize" -ansi-log false -with-report "${file%.fa}".report.html -with-timeline "${file%.fa}".timeline.html -with-trace > "${file%.fa}".csv &
	wait
	echo "info: completed $file"
	echo "info: print tail trace.txt"
	tail trace.txt &
	rm -rf work &
	wait
	echo "info: Cleaned up work folder for $file"
done
files=csv


# polish the nf_blast output
echo "info: polishing"
for csv in ./*."$files"
do
	srun -p short -c 1 --job-name=polish grep -v " process" "$csv" | grep -e '^$' -v | grep -v "revision" | grep -v "executor" | grep -v "version" | sort | uniq -c | sort -rn > "${csv%.csv}".filt.csv &
done
wait
files=filt.csv


# calculate percentage of total hits
echo "info: percentage of total hits"
for csv in ./*."$files"
do
        srun -p short -c 1 --job-name=percentage  awk 'FNR==NR{s+=$1;next;}{printf 100*$1/s $0 "\n"}' "$csv" "$csv" > "${csv%.csv}".per.csv &
done
wait
files=filt.per.csv


# ID mapping
echo "info: Mapping"
for files in ./*."$files"
do
	srun -p short -c 1 --mem-per-cpu=200g --job-name=IDMap time python3 NextflowBlastIDmapper.py "$files" "${files%.csv}".annot.csv &
done
wait
files=annot.csv


#To excel format
echo "info: excel converter"
for file in ./*."$files"
do
	srun -p short -c 1 --job-name=converter python3 csv_to_xlsx_converter.py "$file" &
done
wait


# Clean up
echo "info: Clean up"
bash recursivegzip.sh &
wait

echo "info: Finished"
