#!/bin/bash

#This script is used to fastq dump all the sra files from prefetch dump into the two corresponding forward and reverse files
# Set the path to your HISAT2 executable

# Set the path to the directory containing your compressed FASTQ files
fastq_dir="Datasets_HP/Male_Ile_GF1"

subfolder="Male_Ile_ZT*_GF1"
#reference_mm39="mm39.ncbiRefSeq.gtf"

echo "Paths loaded, starting pipeline"
# Iterate over each compressed FASTQ file
for subfolder in "$fastq_dir"/$subfolder; do

      # Extract the file name without extension
    filename=$(basename "$subfolder")
    echo "Processing folder: $filename"

    merged_1_file="${filename}_merged_1.fastq"
    merged_2_file="${filename}_merged_2.fastq"

    echo "Starting _1 files"
    cat "$subfolder"/*_1.fastq > "$subfolder/$merged_1_file"

    echo "Starting _2 files"
    cat "$subfolder"/*_2.fastq > "$subfolder/$merged_2_file"


    echo "Processed file: $filename"
done

echo "Pipeline complete, all files downloaded"
