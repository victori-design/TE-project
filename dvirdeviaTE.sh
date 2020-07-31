#!/bin/bash -l
#SBATCH --job-name=dvirdeviaTE
#SBATCH --output=dvirdeviaTE.o%j
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --partition=regular
#SBATCH --account=bscb02
#SBATCH --mem=5000

#sbatch dvirdeviaTE.sh
#Dvir_female_catted

#date
d1=$(date +%s)

echo $HOSTNAME
echo $1

/programs/bin/labutils/mount_server cbsufsrv5 /data2
/programs/bin/labutils/mount_server cbsubscb14 /storage

mkdir -p /workdir/$USER/$SLURM_JOB_ID
cd /workdir/$USER/$SLURM_JOB_ID

cp /fs/cbsufsrv5/data1/platinum_genomes/virilisGroup_illumina_reads/$1.fastq.gz .
cp /fs/cbsufsrv5/data2/vt235/deviaTE/dvir.deviate.fasta .

gunzip *.fastq.gz

bwa index dvir.deviate.fasta

deviaTE --input_fq $1.fastq --read_type phred+33 --family R1 --library dvir.deviate.fasta --single_copy_genes RpL32,p53 


mv *R1* /fs/cbsubscb14/storage/vt235/deviaTE
mv *R2* /fs/cbsubscb14/storage/vt235/deviaTE

cd ..
rm -r ./$SLURM_JOB_ID
#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)

