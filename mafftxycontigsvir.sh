#!/bin/bash -l
#SBATCH --job-name=parse_repeatxycontigs
#SBATCH --output=parse_repeatxycontigs.o%j
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --partition=regular
#SBATCH --account=bscb02
#SBATCH --mem=2000

#sbatch parse_repeatxycontigs.sh <accession>

#date
d1=$(date +%s)

echo $HOSTNAME
echo $1

/programs/bin/labutils/mount_server cbsufsrv5 /data2
/programs/bin/labutils/mount_server cbsubscb14 /storage

mkdir -p /workdir/$USER/$SLURM_JOB_ID
cd /workdir/$USER/$SLURM_JOB_ID

#copy in the directory 
cp /fs/cbsubscb14/storage/vt235/xycontigs/virilis/D_virilis.xy.out.Extract.extracted.fa .

/programs/mafft/bin/mafft D_virilis.xy.out.Extract.extracted.fa > D_virilis.aligned.fasta

cp D_virilis.aligned.fasta /fs/cbsubscb14/storage/vt235/xycontigs/virilis

cd ..
rm -r ./$SLURM_JOB_ID
#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)

