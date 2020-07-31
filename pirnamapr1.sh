#!/bin/bash
#$ -S /bin/bash
#$ -q regular.q
#$ -j y
#$ -N pirnamapr1.sh
#$ -cwd
#$ -l h_vmem=30G
#$ -pe bscb 2


#qsub pirnamapr1.sh <fileroot> <TE_lib_fileroot>
#qsub pirnamapr1.sh AnaOvaries_4_TGACCA_R1 danaA
#AnaOvaries_4_TGACCA_R1
#AnaTestes_8_ACTTGA_R1
#VirOvaries_5_ACAGTG_R1
#VirTestes_2_CGATGT_R1

#date
d1=$(date +%s)

echo $HOSTNAME
echo $1
echo $2

/programs/bin/labutils/mount_server cbsufsrv5 /data1
/programs/bin/labutils/mount_server cbsufsrv5 /data2

mkdir -p /workdir/$USER/$JOB_ID
cd /workdir/$USER/$JOB_ID

#copy the TE library over 
cp /fs/cbsufsrv5/data2/vt235/eickbushr1/$2.r1.fasta .

#index it <input fasta file> <prefix for index>
bowtie-build $2.r1.fasta $2.r1

#copy RNA-seq reads over and unzip

cp /fs/cbsufsrv5/data1/jmf422/piRNA_sequencing/First_test/$1.cut2.fastq.gz .

gunzip *.fastq.gz

#map to the genome

bowtie -S -p 4 --time --chunkmbs 200 --best $2.r1 $1.cut2.fastq $1.$2.R1piRNAmapNEW.sam
#bowtie -S -p 4 --time -v 2 -k 5 --best $2.r1 $1.cut2.fastq $1.$2.R1piRNAmap.sam


#move necessary output to file server 5

mv $1.$2.R1piRNAmapNEW.sam /fs/cbsufsrv5/data2/vt235/eickbushr1

cd ..
rm -r ./$JOB_ID
#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)