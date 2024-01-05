#!/bin/bash

#This script is used to run rmat for the datasets and generate output alt splicing event files 
# Set the path to your HISAT2 executable
rmat_Path="/home/kuanguser/miniconda3/bin/rmats.py"

# Set the path to the directory containing your compressed FASTQ files
txt_dir="RMAT_INPUT_DAY"

reference_mm39="Hista2_JM/mm39.ncbiRefSeq.gtf"

echo "Paths loaded, starting pipeline"
# Iterate over each compressed FASTQ file
for file in "$txt_dir"/*.txt; do


      # Extract the file name without extension
    filename=$(basename "$file" .txt)


    echo "Create output dir"
    # Create per-file output and temp directories
    file_output_dir="${filename}_output"
    mkdir -p "$file_output_dir"

    echo "Create temp dir"
    file_temp_dir="${filename}_temp"
    mkdir -p "$file_temp_dir"


    echo "Starting file: $filename"
    echo "----------------------------------------------"


    python "$rmat_Path" --b1 "$txt_dir/$filename.txt" --gtf "$reference_mm39"  --od "$file_output_dir" --tmp "$file_temp_dir" -t single --readLength 50

    #"rmats.py --b1 RMAT_INPUT_TXT/bd0.txt --b2 RMAT_INPUT_TXT/bd14.txt --gtf Hista2_JM/mm39.ncbiRefSeq.gtf --od bd0_14_output --tmp bd0_14_temp -t single --readLength 50"
    # for comparing two days

    echo "Processed file: $filename"
    echo "--------------------------------"

done

echo "Pipeline complete, all files analyzed"
