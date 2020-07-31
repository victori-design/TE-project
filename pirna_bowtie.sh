#!/bin/bash
#$ -S /bin/bash
#$ -q regular.q
#$ -j y
#$ -N pirna_bowtie.sh
#$ -cwd
#$ -l h_vmem=30G
#$ -pe bscb 2

#qsub pirna_bowtie.sh <fileroot> <TE_lib_fileroot>
#qsub pirna_bowtie.sh VirOvaries D_virilis
#VirOvaries
#VirTestes
#AnaOvaries
#AnaTestes

#date
d1=$(date +%s)

echo $HOSTNAME
echo $1
echo $2

/programs/bin/labutils/mount_server cbsufsrv5 /data1

mkdir -p /workdir/$USER/$JOB_ID
cd /workdir/$USER/$JOB_ID

#copy the TE library over 
cp /fs/cbsufsrv5/data2/vt235/genomes/$2.genome.fasta .

#index it <input fasta file> <prefix for index>
bowtie-build -f $2.genome.fasta $2.genome

#copy RNA-seq reads over and unzip

cp /fs/cbsufsrv5/data2/vt235/piRNA/seqtk/$1.fastq .

#map to the genome
bowtie -S -p 4 --time -v 2 -k 5 --best $2.genome $1.fastq $1.genome_5.sam

#move necessary output to file server 5

cd ..
rm -r ./$JOB_ID
#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)

