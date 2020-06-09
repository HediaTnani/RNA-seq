#!/bin/bash -e
## Author: Hédia Tnani
## usage : step1_QC_trimming_RNAseq.sh /scratch2/RNA-seq/DATASET_FINAL/dataset2 /scratch2/RNA-seq/DATASET_FINAL/dataset2_trim /scratch2/RNA-seq/DATASET_FINAL "13579" /scratch2/RNA-seq/DATASET_FINAL/trim_results /usr/local/Trimmomatic-0.36/adapters/ocal/Trimmomatic-0.36/adapters/TruSeq3-PE-2.fa
## dataset 
readDir=$1
trimDir=$2
res=$3
num="$4"
## directories
trim=$5
## adapters
adapters=$6
################################################################
# Check arguments
if [ $# -ne 6 ]; then
    echo "Arguments are not equals to 6"
    exit 0
fi

if [ -z "$1" ]
then 
    echo "Argument 1 read directory not provided"
    exit 1
fi

if [ -z "$2" ]
then 
    echo "Argument 2 trim directory not provided"
    exit 1
fi

if [ -z "$3" ]
then 
    echo "Argument 3 result directory not provided"
    exit 1
fi

if [ -z "$4" ]
then 
    echo "Argument 4 num not provided"
    exit 1
fi

if [ -z "$5" ]
then 
    echo "Argument 5 trim results not provided"
    exit 1
fi

if [ -z "$6" ]
then 
    echo "Argument 6 adapters path not provided"
    exit 1
fi
##################################################################################
echo "quality check with fastqc ..."
mkdir -p $3/QC_raw
cd $3/QC_raw/
/usr/local/FastQC/Fastqc  $1/*.fastq.gz -o .
echo "quality check done successfully ..."
echo "multiqc ..."
mkdir -p  $3/multiQC_raw
multiqc $3/QC_raw/ -o $3/multiQC_raw
echo "multiqc done successfully..."
echo "extracting sample name ..."
cd $1/
samples=$(ls -1 *.fastq.gz | grep -oP '(.+(?=.[[:digit:]]{5}.R[[:digit:]].fastq.gz$))'| uniq)
for i in ${samples}
do
  echo ${i}
  echo "trimming ..."
  mkdir -p $5
  cd $5/
  echo "creating a new folder $5/${i}/ ..."
  mkdir -p $5/${i}/
  cd $5/${i}/
  echo "starting trimmomatic"
  java -jar /usr/local/Trimmomatic-0.36/trimmomatic.jar PE -phred33 -threads 60 $1/${i}.$4.R1.fastq.gz $1/${i}.$4.R2.fastq.gz $5/${i}/${i}.$4.R1.P.fastq.gz $5/${i}/${i}.$4.R1.U.fastq.gz $5/${i}/${i}.$4.R2.P.fastq.gz $5/${i}/${i}.$4.R2.U.fastq.gz  ILLUMINACLIP:$6:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:60 HEADCROP:2 2> log.txt
  echo "trimmomatic done successfully"
  echo "copying trimmed files ..." 
  mkdir -p $2
  cd $2/
  cp $5/${i}/${i}.$4.R1.P.fastq.gz $5/${i}/${i}.$4.R1.U.fastq.gz $5/${i}/${i}.$4.R2.P.fastq.gz $5/${i}/${i}.$4.R2.U.fastq.gz .
  done
echo "quality recheck ..."
mkdir -p $5/QC_trim
cd $5/QC_trim/
echo "fastqc ..."
/usr/local/FastQC/Fastqc $2/*.fastq.gz -o .
echo "multiqc ..."
multiqc .
echo "QC finished successfully"

