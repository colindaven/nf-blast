# nf-blast
Work in progress - nextflow blast.

## Why you shouldn't use nf-blast
 - Only tested on our architecture
 - Annotation of id to sequence names only works with one nt database version to date
 - blast is a very slow algorithm by modern standards


## Why you should use nf-blast
 - You're brave
 - You have a bit of time on your hands
 - You really, really want to run blast on your cluster
 - You want to find possible contamination sources in your fastq or fasta data
 - You don't want quantitative results
 - You have a big, idle cluster
 - You realize this is not a metagenome quantification program. For that, use Wochenende or Kraken-uniq.



# Install 

## Database
- Download nt database (5. July 2018 tested). This is the only one tested with our annotator to date.

## Set up nf-blast

```
# Get the code
git clone https://github.com/colindaven/nf-blast

# Set up your conda environment
conda env create -f env.nextflow.yml
conda activate nextflow

Edit variables blastdb and repopath to the paths in your environment
nano run_complete_nf_blast.sh


```

### Edit javapath and repopath in main.nf

```
nano main.nf

/*
 * @ Users: change these following paths or specify them as parameters
 */
repopath = "/mnt/ngsnfs/tools/dev/nf-blast"
params.java_bin_path = "/mnt/ngsnfs/tools/jdk-10.0.1/bin/"
```

### Setup the nextflow.conf with your execution environment

For other executors (such as the non-SLURM local) see https://www.nextflow.io/docs/latest/executor.html#local
```
nano nextflow.conf

# Your SLURM cluster queue is called batchq
# You want to reserve 4 cores for each blast job. 
# Job names are nf_blast

  clusterOptions = '-p batchq  -c 4 -J nf_blast -s'

```



## Run the program. 
```
# This will run on 2000 reads of the supplied sepsis nanopore metagenome ERR2752917_R1.fastq (test dataset)
conda activate nextflow
bash run_complete_nf_blast.sh
```

## Results

If all goes well, results from the annot.csv file might look like this:

less ERR2752917_R1.subsample.filt.per.annot.csv
```
42.1569     43 LT629801.1 LT629801.1 Pseudomonas rhodesiae strain BS2777 genome assembly, chromosome: I
2.94118      3 AC245657.1 AC245657.1 Homo sapiens FOSMID clone ABC24-755K16 from chromosome 4, complete sequence
1.96078      2 LM423415.1 LM423415.1 Enterobius vermicularis genome assembly E_vermicularis_Canary_Islands ,scaffold EVEC_scaffold0009157
1.96078      2 CP014014.1 CP014014.1 Stenotrophomonas maltophilia strain FDAARGOS_92 chromosome, complete genome
1.96078      2 CP003589.1 CP003589.1 Pseudomonas putida ND6 plasmid pND6-2, complete sequence
```


## FAQ

Which blast parameters are used ? See below, 80 per cent identity is important.

See main.nf

    blastn -db $db_path/$db_name -query query.fa -perc_identity 80 -max_target_seqs 10 -evalue 1 -num_threads 4 -outfmt 6 > blast_result
