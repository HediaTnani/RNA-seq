#!/bin/bash -e
## Author: Hédia Tnani
#Usage: ./step2_star_index.sh /scratch2/RNA-seq/DATASET_FINAL/Star_results star_index 20 /scratch2/RNA-seq/referenceseq2019/mus_musculus/Mus_musculus.GRCm38.dna.toplevel.fa /scratch2/RNA-seq/referenceseq2019/mus_musculus/Mus_musculus.GRCm38.99.gtf
## Arguments
res=$1
index=$2
cpus=$3
fasta=$4
gtf=$5

################################################################
# Check arguments
if [ $# -ne 5 ]; then
    echo "Arguments are not equals to 5"
    exit 0
fi

if [ -z "$1" ]
then 
    echo "Argument 1 result directory not provided"
    exit 1
fi

if [ -z "$2" ]
then 
    echo "Argument 2 name of index directory not provided"
    exit 1
fi

if [ -z "$3" ]
then 
    echo "Argument 3 number of cpus not provided"
    exit 1
fi

if [ -z "$4" ]
then 
    echo "Argument 4 path to fasta not provided"
    exit 1
fi

if [ -z "$5" ]
then 
    echo "Argument 5 path to gtf not provided"
    exit 1
fi

##### index #######
echo "generating star index ..."
mkdir -p $1
cd $1
mkdir -p $1/$2
cd $1/$2
time STAR \
  --runMode genomeGenerate \
  --runThreadN $3 \
  --genomeDir $1/$2 \
  --genomeFastaFiles $4 \
  --sjdbGTFfile $5 \
  --sjdbOverhang  1OO \
  --limitGenomeGenerateRAM=33524399488
