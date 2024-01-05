#!/bin/bash

#This script is used to convert sam files into bam and bai files.
# Set the path to your HISAT2 executable
hisat2_path="/home/kuanguser/miniconda3/bin/hisat2"

# Set the path to your samtools executable
samtools_path="/usr/bin/samtools"

# Set the path to your stringtie executable
#stringtie_path="/home/kuanguser/miniconda3/bin/stringtie"

# Set the path to the reference genome index
hisat2_genome_index="hista2_JM/hisat-0.1.5-beta_mm39"

# Set the path to the directory containing your compressed FASTQ files
fastq_dir="Fang_Paper/Datasets"

hisat_alignments="Fang_Paper/HISAT2_ALIGNMENTS_mm39"
samtool_mods="Fang_Paper/SAMTOOLS_MODIFICATIONS_mm39"
#stringtie_gtf="STRINGTIE_GTF"


#reference_mm39="mm39.ncbiRefSeq.gtf"

echo "Paths loaded, starting pipeline"
# Iterate over each compressed FASTQ file
for file in "$hisat_alignments"/*.sam; do

      # Extract the file name without extension
    filename=$(basename "$file" .sam)

    echo "Converting SAM to unsorted BAM for $filename"
      # Convert the SAM file to BAM format
    "$samtools_path" view -S -b "$hisat_alignments/$filename.sam" -o "$samtool_mods/${filename}_UNSORTED.bam"

    echo "Conversion done, converting unsorted BAM to sorted BAM for $filename"
        # Sort the BAM file
    "$samtools_path" sort "$samtool_mods/${filename}_UNSORTED.bam" -o "$samtool_mods/${filename}_SORTED.bam"

    echo "Conversion done. Now, indexing sorted BAM for $filename"
        # Index the sorted BAM file
    "$samtools_path" index "$samtool_mods/${filename}_SORTED.bam" "$samtool_mods/${filename}_SORTED.bai"
    echo "Sorted BAM and .BAI files generated"

    echo "Processed file: $filename"
done

echo "Pipeline complete, all files analyzed"
