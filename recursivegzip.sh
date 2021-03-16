#!/bin/bash

#gzip certain files found by the "find" command

#Rene - find data 90 days old and over 100m
# find . -type f -atime +90 -size +100

threads=56

for i in `find . -name "*.csfasta"`
        do
        echo $i
        pigz -p $threads -f $i
done

for i in `find . -name "*.qual"`
        do
        echo $i
        pigz -p $threads -f $i
done


for i in `find . -name "*.sam"`
	do
	echo $i
	pigz -p $threads -f $i
done

for i in `find . -name "*.fastq"`

	do
	pigz -p $threads -f $i
done

for i in `find . -name "*.fq"`

	do
	pigz -p $threads -f $i
done

for i in `find . -name "*.fasta"`

        do
        pigz -p $threads -f $i
done


for i in `find . -name "*.fa"`

	do
	pigz -p $threads -f $i
done

for i in `find . -name "*.fas"`

	do
	pigz -p $threads -f $i
done

for i in `find . -name "*.fna"`

        do
        pigz -p $threads -f $i
done

for i in `find . -name "*.faa"`

	do
	pigz -p $threads -f $i
done

for i in `find . -name "*.qual"`

	do
	pigz -p $threads -f $i
done

for i in `find . -name "*.h5"`
	#pacbio data
	do
	pigz -p $threads -f $i
done

for i in `find . -name "*.gff3"`
        do
        pigz -p $threads -f $i
done

for i in `find . -name "*.gtf"`
        do
        pigz -p $threads -f $i
done

for i in `find . -name "*.pileup"`
        do
        pigz -p $threads -f $i
done

for i in `find . -name "*.gbk"`
        do
        pigz -p $threads -f $i
done

for i in `find . -name "*.vcf"`
        do
        pigz -p $threads -f $i
done

for i in `find . -name "*.bedGraph"`
        do
        pigz -p $threads -f $i
done



