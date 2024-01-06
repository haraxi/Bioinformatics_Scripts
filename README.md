# Bioinformatics Scripts

## **Overview** ## 

Here is a list of various Bash scripts I wrote and compiled duting my time at the [Kuang Lab](https://labs.bio.cmu.edu/kuang/) at the Dept of Biological Sciences at Carnegie Mellon University. I started my research on the 15th of May 2023 to the 11th of August 2023, and worked on computational projects during my time at the lab.

Broadly, we used a bioinformatics-based approach to build RNA-seq pipelines and subsequent circadian analysis of mice gene expression data. The primary objective of my project was to build and develop a simple workflow and RNA-seq pipeline to analyze the gene expression levels of the intestine epithelium in mice and identify whether these expression levels have circadian rhythms. 

## **Role of the gut microbiota and biological sex in mouse intestine diurnal expression patterns** ##

For this project, I first tested various open-source bioinformatics tools, identifying the optimal tools which would simplify downstream analysis. Following a general RNA-seq pipeline, I tested alignment rates given by various alignment tools such as HISAT2, STAR and Tophat2. In addition, I also tried quantification using tools such as Stringtie, Cuffdiff, featureCounts and RSem. These tools were first tested on publicly available datasets downloaded from GEO, and then extended to datasets generated in the lab. I learnt to visualize shared and unique genes by generating simple Venn diagrams between timepoints, as well as between male and female mice. To facilitate the analysis, I wrote multiple bash scripts to efficiently download, decompress and perform quality checks on .fastq sequence data, align raw reads  and ultimately quantify and compare samples using normalized gene expression in terms of FPKM. We further used these results to analyze the rhythmic behavior of genes if any. 

Each script is named with the task associated with it, along with the bioinformatics tool used for the task. An improved description of each script can be found commented in each script. Most scripts uploaded here contain parts of a general RNA-seq pipeline, using various Bioinformatics tools.

## **Alternative Splicing events in RNA-seq data of colitis-induced mice** ##

In addition to the above project, I also assisted towards the progress of another project where we looked for alternative splicing events such as intron retention and exon splicing. Here, we analyzed tissue RNA-seq data for mice affected by colitis at discrete time intervals across both day and night. For this, I identified and tested various open-source bioinformatics tools to identify these splicing events. Some of the tools I used to study alternative splicing events included SPLADDER, vast-tools, SUPPA and RMAT. I wrote bash scripts to generate files with the splicing event information and analyzed the resultant .gtf files, facilitating analysis of long-read sequencing data. 

## **Outcome** ##

Overall, I was able to improve my computational knowledge and skills, while gaining a better understanding of the biological relevance of the projects through the guidance of members of the lab. I learnt a vast amount of bioinformatics skills including Linux commands, writing bash, Python and R scripts, tweaking parameters of different bioinformatics tools, troubleshooting, and visualizing data with R and Python. 


