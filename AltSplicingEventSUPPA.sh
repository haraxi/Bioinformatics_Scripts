#!/bin/bash

# Set the path to your SUPPA executable
suppa_path="/home/kuanguser/miniconda3/bin/suppa.py"

# Set the path to the directory containing your gtf files
gtf_dir="Hista2/STRINGTIE_GTF"

Expression_txt="Suppa/Expression_files"
Event_ioe="Suppa/Event_ioe"
Psi_values_isoform="Suppa/Psi_values_isoform"
Psi_values_event="Suppa/Psi_values_event"

echo "Paths loaded, starting pipeline"
# Iterate over each compressed FASTQ file
for file in "$gtf_dir"/*.gtf; do

      # Extract the file name without extension
    filename=$(basename "$file" .gtf)

    echo "Starting file: $filename"
    echo "----------------------------------------------"
    echo "Generating the expression file"

    grep -P "\ttranscript\t"  $file  | cut -f9 | awk '{gsub("\"","",$0);gsub(";","",$0);print $4 "\t" $12}'| tee $Expression_txt/${filename}_temp_expression.txt

    echo -e "sample 1" | cat - <(awk -F'\t' '$2 != ""' $Expression_txt/${filename}_temp_expression.txt) > $Expression_txt/${filename}_expression.txt

    rm $Expression_txt/${filename}_temp_expression.txt
    echo "Expression file for $filename generated"
    echo "-----------------------------------------------"

    echo " Identifying psiPerIsoform values"

    echo "$filename.gtf"
    echo "$Expression_txt/${filename}_expression.txt"
    "$suppa_path" psiPerIsoform -g "$gtf_dir/$filename.gtf" --expression-file "$Expression_txt/${filename}_expression.txt" -o "$Psi_values_isoform/${filename}_PSI_isoform"
    echo "-----------------------------------------------"

    echo " psiPerIsoform values identified"

    echo "-----------------------------------------------"

    echo " Generating events for the dataset gtf file"

    "$suppa_path" generateEvents -i "$gtf_dir/$filename.gtf" -o "$Event_ioe/${filename}_Event" -f ioe -e SE SS RI

    echo "-----------------------------------------------"

    echo " Events generated, finding per event psi values "

    for ioe_file in "$Event_ioe"/*.ioe; do

        ioe_filename=$(basename "$ioe_file" .ioe)

        "$suppa_path" psiPerEvent --ioe-file "${ioe_file}" --expression-file "$Expression_txt/${filename}_expression.txt" -o "$Psi_values_event/${ioe_filename}_PSI_event"

    done
    echo "Event psi calculated for $filename"

done

echo "Pipeline Completed, all psi values calculated for given gtf files."
