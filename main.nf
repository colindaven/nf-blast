#!/usr/bin/env nextflow

/*
 *  Further extensively modified by  
 *  Colin Davenport
 *  Fabian Friedrich
 *  Hannover Medical School 
 *
 * Copyright (c) 2013-2018, Centre for Genomic Regulation (CRG).
 * Copyright (c) 2013-2018, Paolo Di Tommaso and the respective authors.
 *
 *   This file is part of 'Nextflow'.
 *
 *   Nextflow is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Nextflow is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Nextflow.  If not, see <http://www.gnu.org/licenses/>.
 */
 

/*
 * Defines the pipeline inputs parameters (giving a default value for each for them) 
 * Each of the following parameters can be specified as command line options
 */
params.query = "$baseDir/data/sample.fa"
params.db = "$baseDir/blast-db/pdb/tiny"
params.out = "result.txt"
params.chunkSize = 1
/*
 * @ Users: change these following paths or specify them as parameters
 */
repopath = "/mnt/ngsnfs/tools/dev/nf-blast"
java_bin_path = "/mnt/ngsnfs/tools/jdk-10.0.1/bin/"

db_name = file(params.db).name
db_path = file(params.db).parent


"""
# Removed to avoid conda java usage !
#source /mnt/ngsnfs/globalenv/globalenv
"""

/* 
 * Given the query parameter creates a channel emitting the query fasta file(s), 
 * the file is split in chunks containing as many sequences as defined by the parameter 'chunkSize'.
 * Finally assign the result channel to the variable 'fasta' 
 */
Channel
    .fromPath(params.query)
    .splitFasta(by: params.chunkSize)
    .set { fasta }

/* 
 * Executes a BLAST job for each chunk emitted by the 'fasta' channel 
 * and creates as output a channel named 'top_hits' emitting the resulting 
 * BLAST matches  
 *
 * blastn command includes a percent identity 80% cutoff
 * blastn -db $db_path/$db_name -query query.fa -perc_identity 80 -max_target_seqs 10 -evalue 1 -num_threads 4 -outfmt 6 > blast_result
 */
process blast {
    input:
    file 'query.fa' from fasta
    file db_path

    output:
    file top_hits

    """
    ############## BLASTP #############
    #blastp -db $db_path/$db_name -query query.fa -outfmt 6 > blast_result
    ############## BLASTX #############
    #blastx -db $db_path/$db_name -query query.fa -outfmt 6 > blast_result
    ############## BLASTN #############
    blastn -db $db_path/$db_name -query query.fa -perc_identity 80 -max_target_seqs 10 -evalue 1 -num_threads 4 -outfmt 6 > blast_result

    ############## TOP HIT using head -n 1 - only works if chunkSize 1  #############
    #cat blast_result | head -n 1 | cut -f 2 > top_hits

    ###########################
    # Use java best blast hit filter, not just head -n 1 to get top hit. Allows chunk sizes > 1 without ignoring results for second sequence
    # /mnt/ngsnfs/tools/jdk-10.0.1/bin/java /mnt/ngsnfs/scripts/blastscripts/blast_besthits_filter/BlastFilter blast_result | cut -f 2 > top_hits
    # Absurdly, it seems you have to copy the java class files to the current dir. Writes blast_re_filt.txt
    ##############################

    #cp /mnt/ngsnfs/scripts/blastscripts/blast_besthits_filter/*.class .
    cp $repopath/*.class .
    #/mnt/ngsnfs/tools/jdk-10.0.1/bin/java BlastFilter blast_result 
    $java_bin_path/java BlastFilter blast_result 
    cut -f 2 blast_re_filt.txt > top_hits
    """
}

/**
*process extract {
*    input:
*    file top_hits
*    file db_path
*
*    output:
*    file collected_top_hits
*
*    """
*    cat $db_path/$db_name top_hits  > collected_top_hits
*    """
*}
*/

/*
 * Collects all the sequences files into a single file
 * and prints the resulting file content when complete
 */


top_hits
    .collectFile(name: params.out)
    .println { file -> "${file.text}" }

