# Nextflow blast

## Requirements

  * Database: ´/lager2/rcug/seqres/nt_db/nt_2018/nt´

## Instalation/setup

Clone this repo and checkout branch dev
```
git clone https://gitlab.mh-hannover.local/RCUG/covid19_nfblast.git
cd covid19_nfblast
```

If not exists (the conda env from master is fine) create a new conda env with the env file from this repo
```
conda env create -f env.nextflow.yml
```

Or install nextflow via bioconda, watch your openjdk version || not recomended
```
conda install -c conda-forge openjdk=8.0.121
conda install -c bioconda nextflow
conda install pandas
```

Open the run_complete_nf_blast.sh file and change the repo path to this path
```
nano run_complete_nf_blast.sh
#In line 14
repopath=/your/repo/path
```

## Usage 
Copy the run_complete_nf_blast file to your directoy with fasqs or fastas
Open the run_complete_nf_blast file and change the subsample size if you want
```
cp /your/nfblast/repo/run_complete_nf_blast.sh .
nano run_complete_nf_blast.sh 

# Line 12 set the chunk size, 100 works well and time efficient
chunksize=yourchunksize
# Line 13 set the subsample size 
subsamplesize=yoursubsamplesize 

bash run_complete_nf_blast.sh
```

If you are using **FASTAS** you don't have to change anything, it will just skip the fastq to fasta process

If you want to **SKIP** a process you have to comment out the whole process block in the run_complete_nf_blast script from the comment to the next blank line. 
