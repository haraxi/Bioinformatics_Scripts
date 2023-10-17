#!/bin/bash

#This script is used to run hisat2 alignments for paired fastq data the datasets and generate a bam file from which stringtie is used to generate a tom tab file and a gtf file with gene coordinates
# Set the path to your HISAT2 executable
hisat2_path="/home/kuanguser/miniconda3/bin/hisat2"

#set the path to the topha executablet
tophat_path="/usr/bin/tophat"
# Set the path to your samtools executable
samtools_path="/usr/bin/samtools"

cuffdiff_path="/usr/bin/cuffdiff"

# Set the path to your stringtie executable
stringtie_path="/home/kuanguser/miniconda3/bin/stringtie"

# Set the path to the reference genome index
hisat2_genome_index="Datasets_HP/ReferenceDatasets/HISAT2_GENOME_mm10/mm10_genome/mm10/genome"

# Set the path to the directory containing your compressed FASTQ files
fastq_dir="Datasets_HP/fastq"

hisat_alignments="Combined_sex_difference_results"
samtool_mods="Combined_sex_difference_results"
stringtie_gtf="Combined_sex_difference_results"


reference_mm10="Datasets_HP/ReferenceDatasets/gencode.vM10.annotation.gtf"

echo "Paths loaded, starting pipeline"
# Iterate over each compressed FASTQ file
for file in "$fastq_dir"/*_1.fastq; do


      # Extract the file name without extension
    filename=$(basename "$file" _1.fastq)

    echo "Starting file: $filename"
    echo "----------------------------------------------"

    echo "Starting TOPHAT alignment for $filename"

    "$tophat_path" -o "$filename" -p 16 -G "$reference_mm10" Datasets_HP/ReferenceDatasets/mm10 "$fastq_dir/$filename"_1.fastq "$fastq_dir/$filename"_2.fastq

    echo "Starting HISAT2 Alignment for $filename"
      # Run HISAT2 with the appropriate options
    "$hisat2_path" -q --dta -x "$hisat2_genome_index" -1 "$fastq_dir/$filename"_1.fastq -2 "$fastq_dir/$filename"_2.fastq -S "$hisat_alignments/$filename.sam"
    echo "----------------------------------------------"
    echo "Finished HISAT2 Alignment for $filename. SAM file generated"

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

    echo "Sorted BAM and .BAI files generated, moving to stringtie for quantification"
    echo "------------------------------------------------"
    echo "Starting Stringtie"

    "$stringtie_path" "$samtool_mods/${filename}_SORTED.bam" -G "$reference_mm10" -o "$stringtie_gtf/${filename}_STRINGTIE.gtf" -A "$stringtie_gtf/${filename}_TPM.tab"

    echo "GTF file and TPM files generated. Stringtie complete for : $filename"

    echo "Processed file: $filename"
done

echo "tarting cuffdiff for all timepoints"
"$cuffdiff_path" -o final-tophat-tpm -p 30 -u /mnt/data2/database/mm10/genes.gtf ZT2-WT-tophat/accepted_hits.bam ZT2-KO-tophat/accepted_hits.bam ZT2-F-tophat/accepted_hits.bam ZT8-WT-tophat/accepted_hits.bam ZT8-KO-tophat/accepted_hits.bam ZT8-F-tophat/accepted_hits.bam ZT14-WT-tophat/accepted_hits.bam ZT14-KO-tophat/accepted_hits.bam ZT14-F-tophat/accepted_hits.bam ZT20-WT-tophat/accepted_hits.bam ZT20-KO-tophat/accepted_hits.bam ZT20-F-tophat/accepted_hits.bam

echo "Pipeline complete, all files analyzed"
