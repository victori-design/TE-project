#!/bin/bash
#$ -S /bin/bash
#$ -q regular.q
#$ -j y
#$ -N map_bowtie2_generic
#$ -cwd
#$ -l h_vmem=30G
#$ -pe bscb 2


#qsub map_bowtie2.sh <fileroot> <TE_lib_fileroot>
#qsub map_bowtie2_generic.sh Dana_ovaries_rep1 D_ana_RMod_classified_consensi

#date
d1=$(date +%s)

echo $HOSTNAME
echo $1
echo $2

/programs/bin/labutils/mount_server cbsufsrv5 /data1

mkdir -p /workdir/$USER/$JOB_ID
cd /workdir/$USER/$JOB_ID

#copy the TE library over 
cp /fs/cbsufsrv5/data1/jmf422/TE_expression/TE_libraries/$2.fa .

# simplify
cat $2.fa | cut -f 1 -d " " > $2.simple.fa


#index it <input fasta file> <prefix for index>
/programs/bowtie2-2.2.8/bowtie2-build $2.simple.fa $2.simple

#copy RNA-seq reads over and unzip

cp /fs/cbsufsrv5/data1/jmf422/TE_expression/adapter_clipping/$1.clipped.fastq.gz .

gunzip *.fastq.gz

#map to the genome
/programs/bowtie2-2.2.8/bowtie2 -x $2.simple -U $1.clipped.fastq -S $1_RMod.aln.sam --no-unal --un $1_RMod.unmapped.fa -p 4 --nofw

echo "mapped to genome: got sam file"

#convert to bam
/programs/samtools-1.8/bin/samtools view -Sb $1_RMod.aln.sam > $1_RMod.aln.bam

echo "converted to bam"

#sort
/programs/samtools-1.8/bin/samtools sort $1_RMod.aln.bam -o $1_RMod.aln.sorted.bam

echo "sorted bam"


#move necessary output to file server 5

mv $1_RMod.aln.sorted.bam /fs/cbsufsrv5/data1/jmf422/TE_expression/TE_libraries/mapping_results

mv $1_RMod.aln.bam /fs/cbsufsrv5/data1/jmf422/TE_expression/TE_libraries/mapping_results

mv $1_RMod.aln.sam /fs/cbsufsrv5/data1/jmf422/TE_expression/TE_libraries/mapping_results

mv $1_RMod.unmapped.fa /fs/cbsufsrv5/data1/jmf422/TE_expression/TE_libraries/mapping_results

cd ..
rm -r ./$JOB_ID
#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)