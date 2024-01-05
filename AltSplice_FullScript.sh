#!/bin/bash

# Set the path to your HISAT2 executable
hisat2_path="/home/kuanguser/miniconda3/bin/hisat2"

# Set the path to your samtools executable
samtools_path="/usr/bin/samtools"

# Set the path to your stringtie executable
stringtie_path="/home/kuanguser/miniconda3/bin/stringtie"

# Set the path to the reference genome index
hisat2_genome_index="hisat-0.1.5-beta/mm39"

# Set the path to the directory containing your compressed FASTQ files
fastq_dir="Colitis_data_ncbi"

hisat_alignments="HISAT2_ALIGNMENTS"
samtool_mods="SAMTOOLS_MODIFICATIONS"
stringtie_gtf="STRINGTIE_GTF"


reference_mm39="mm39.ncbiRefSeq.gtf"

echo "Paths loaded, starting pipeline"
# Iterate over each compressed FASTQ file
for file in "$fastq_dir"/*.fastq.gz; do


      # Extract the file name without extension
    filename=$(basename "$file" .fastq.gz)

    echo "Starting file: $filename"
    echo "----------------------------------------------"


    echo "Starting HISAT2 Alignment for $filename"
      # Run HISAT2 with the appropriate options
    "$hisat2_path" -p 4 -x "$hisat2_genome_index" -U "$fastq_dir/$filename.fastq.gz" -S "$hisat_alignments/$filename.sam"
    echo "----------------------------------------------"
    echo "Finished HISAT2 Alignment for $filename. SAM file generated"

    echo "Converting SAM to unsorted BAM for $filename"
      # Convert the SAM file to BAM format
    "$samtools_path" view -S -b "$hisat_alignments/$filename.sam" -o "$samtool_mods/$filename_UNSORTED.bam"

    echo "Conversion done, converting unsorted BAM to sorted BAM for $filename"
        # Sort the BAM file
    "$samtools_path" sort "$samtool_mods/$filename_UNSORTED.bam" -o "$samtool_mods/$filename_SORTED.bam"

    echo "Conversion done. Now, indexing sorted BAM for $filename"
        # Index the sorted BAM file
    "$samtools_path" index "$samtool_mods/$filename_SORTED.bam" "$samtool_mods/$filename_SORTED.bai"

    echo "Sorted BAM and .BAI files generated, moving to stringtie for quantification"
    echo "------------------------------------------------"
    echo "Starting Stringtie"

    "$stringtie_path" "$samtool_mods/$filename_SORTED.bam" -G "$reference_mm39" -o "$stringtie_gtf/$filename_STRINGTIE.gtf" -A "$stringtie_gtf/$filename_TPM.tab"

    echo "GTF file and TPM files generated. Stringtie complete for : $filename"

    echo "Processed file: $filename"
done

echo "Pipeline complete, all files analyzed"
