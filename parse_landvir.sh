#!/bin/bash -l
#SBATCH --job-name=parse_landvir
#SBATCH --output=parse_landvir.o%j
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --partition=regular
#SBATCH --account=bscb02

#sbatch parse_landvir.sh

#date
d1=$(date +%s)

echo $HOSTNAME
#echo $1
#echo $2

/programs/bin/labutils/mount_server cbsubscb14 /storage

mkdir -p /workdir/$USER/$SLURM_JOB_ID
cd /workdir/$USER/$SLURM_JOB_ID

#copy in the directory 

cp -r /home/vt235/programs/Parsing-RepeatMasker-Outputs .
cp -r /fs/cbsubscb14/storage/vt235/phylogeny/virilis/D_virilis.genome.out Parsing-RepeatMasker-Outputs

cd Parsing-RepeatMasker-Outputs
ls

perl parseRM.pl -i D_virilis.genome.out -l 50,1 -v

cd ..
cp -r Parsing-RepeatMasker-Outputs /fs/cbsubscb14/storage/vt235/phylogeny

cd ..
rm -r ./$SLURM_JOB_ID
#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)
