#!/bin/bash
## Author: Hédia Tnani
# usage: step_2_star_mapping.sh /scratch2/RNA-seq/DATASET_FINAL/dataset2-trim-final 13579 /scratch2/RNA-seq//DATASET_FINAL/Star_results /scratch2/RNA-seq/referenceseq2019/mus_musculus/Mus_musculus.GRCm38.99.gtf 40
## dataset 
readDir=$1
num=$2
## Mus musculus GRCm38 STAR index
res=$3
index="star_index"
##directories
mapping="mapping"

## Mus musculus Ensembl GTF
gtf=$4

##options
cpus=$5
################################################################
# Check arguments
if [ $# -ne 5 ]; then
    echo "Arguments are not equals to 5"
    exit 0
fi

if [ -z "$1" ]
then 
    echo "Argument 1 read directory not provided"
    exit 1
fi

if [ -z "$2" ]
then 
    echo "Argument 2 num not provided"
    exit 1
fi

if [ -z "$3" ]
then 
    echo "Argument 3 result directory not provided"
    exit 1
fi

if [ -z "$4" ]
then 
    echo "Argument 4 gtf not provided"
    exit 1
fi

if [ -z "$5" ]
then 
    echo "Argument 5 cpu results not provided"
    exit 1
fi
#######################################################################################
##### mapping ###########
echo "extracting sample name ..."
cd $1
samples=$(ls -1 *.fastq.gz | grep -oP '(.+(?=.[[:digit:]]{5}.R[[:digit:]].P.fastq.gz$))'| uniq)
for i in ${samples}
do
  echo ${i}
  OUT_DIR=$3/${mapping}
  mkdir -p ${OUT_DIR}/${i}
  cd ${OUT_DIR}/${i}
  echo "Mapping ${i}.$2.R1.P.fastq.gz and ${i}.$2.R2.P.fastq.gz ..."
  STAR \
    --genomeDir $3/${index} \
    --sjdbGTFfile $4\
    --readFilesIn $1/${i}.$2.R1.P.fastq.gz $1/${i}.$2.R2.P.fastq.gz  \
    --runThreadN ${cpus} \
    --runMode alignReads \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate\
    --quantMode GeneCounts \
    --outFileNamePrefix ${OUT_DIR}/${i}/${i}_  \
    --outSAMattrRGline ID:${i} SM:${i} LB:Illumina PL:Illumina
  rm -rf _STARtmp
  
  echo "viewing the bam file ..."
  samtools view -h ${OUT_DIR}/${i}/${i}_Aligned.sortedByCoord.out.bam | head -n 10
  echo "converting sam to bam ..."
  samtools view -h ${OUT_DIR}/${i}/${i}_Aligned.sortedByCoord.out.bam > ${OUT_DIR}/${i}/${i}_Aligned.sortedByCoord.out.sam
  echo "Mapping done successfully ..."
######## qualimap ########
  echo "checking mapping quality..."
  quali=${OUT_DIR}/${i}/quali_map
  bam=${OUT_DIR}/${i}/${i}_Aligned.sortedByCoord.out.bam
  mkdir -p ${quali}
  cd ${quali}
  qualimap rnaseq \ 
        -bam ${bam} \
	-gtf $4 \
	-outdir qc_qualimap \
	-p non-strand-specific
   echo " quality map done successfully ..."
done
