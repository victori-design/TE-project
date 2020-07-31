#!/bin/bash -l
#SBATCH --job-name=fasttreevirilis
#SBATCH --output=fasttreevirilis.o%j
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --partition=regular
#SBATCH --account=bscb02

#sbatch fasttreevirilis.sh

#date
d1=$(date +%s)

echo $HOSTNAME
#echo $1
#echo $2

/programs/bin/labutils/mount_server cbsubscb14 /storage

mkdir -p /workdir/$USER/$SLURM_JOB_ID
cd /workdir/$USER/$SLURM_JOB_ID

#copy in the mafft aligned fasta file
cp /fs/cbsubscb14/storage/vt235/phylogeny/virilis/D_virilis2.aligned.fasta .

/programs/FastTree-2.1.10/FastTree D_virilis2.aligned.fasta > D_virilis_tree_file

cp D_virilis_tree_file /fs/cbsubscb14/storage/vt235/phylogeny/virilis

cd ..
rm -r ./$SLURM_JOB_ID
#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)
