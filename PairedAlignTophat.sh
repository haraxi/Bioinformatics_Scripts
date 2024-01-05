#!/bin/bash

#This script is used to run tophat alignments for paired fastq data the datasets and generate a bam file from which stringtie is used to generate a tom tab file and a gtf file with gene coordinates

#set the path to the topha executablet
tophat_path="/usr/bin/tophat"


cuffdiff_path="/usr/bin/cuffdiff"


# Set the path to the directory containing your compressed FASTQ files
fastq_dir="Datasets_HP/fastq"

tophat_alignments="Combined_sex_difference_results_ileum"

reference_mm10="Datasets_HP/ReferenceDatasets/gencode.vM10.annotation.gtf"

echo "Paths loaded, starting pipeline"
#Iterate over each compressed FASTQ file
for file in "$fastq_dir"/*_1.fastq; do


      # Extract the file name without extension
    filename=$(basename "$file" _1.fastq)

    echo "Starting file: $filename"
    echo "----------------------------------------------"

    echo "Starting TOPHAT alignment for $filename"

    "$tophat_path" -o "$tophat_alignments/$filename" -p 16 -G "$reference_mm10" Datasets_HP/ReferenceDatasets/mm10/mm10 "$fastq_dir/$filename"_1.fastq "$fastq_dir/$filename"_2.fastq

    echo "Processed file: $filename"
done

echo "Starting cuffdiff for all timepoints"

"$cuffdiff_path" -o final-tophat-tpm-germfree-ileum -p 16 -u "$reference_mm10" $tophat_alignments/GF1_ILE_MALE_ZT02/accepted_hits.bam $tophat_alignments/GF1_ILE_MALE_ZT06/accepted_hits.bam $tophat_alignments/GF1_ILE_MALE_ZT10/accepted_hits.bam $tophat_alignments/GF1_ILE_MALE_ZT14/accepted_hits.bam $tophat_alignments/GF1_ILE_MALE_ZT18/accepted_hits.bam $tophat_alignments/GF1_ILE_MALE_ZT22/accepted_hits.bam

echo "Cuffdiff finished"

echo "Pipeline complete, all files analyzed"
