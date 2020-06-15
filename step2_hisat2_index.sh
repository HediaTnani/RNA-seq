#!/bin/bash
# Author: Hédia Tnani
# Usage: step2_hisat2_index.sh /scratch2/RNA-seq/DATASET_FINAL/Hisat2_results hisat2_index 40 /scratch2/RNA-seq/referenceseq2019/mus_musculus/Mus_musculus.GRCm38.dna.toplevel.fa

## Arguments
res=$1
index=$2
cpus=$3
fasta=$4

################################################################
# Check arguments
if [ $# -ne 4 ]; then
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

##### index #######
echo "generating hisat2 index ..."
mkdir -p $1
cd $1
mkdir -p $1/$2
cd $1/$2
hisat2-build -p $3 $4 GRCm38_hisat2
echo "hisat2 index done..."

