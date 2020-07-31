#!/bin/bash -l
#SBATCH --job-name=onecode_promiscuity
#SBATCH --output=onecode_promiscuity.o%j
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=24:00:00
#SBATCH --partition=regular
#SBATCH --account=bscb02
#SBATCH --mem=4000

#sbatch onecode_promiscuity.sh <accession>

#datew
d1=$(date +%s)

echo $HOSTNAME
echo $1

/programs/bin/labutils/mount_server cbsufsrv5 /data2
/programs/bin/labutils/mount_server cbsubscb14 /storage

mkdir -p /workdir/$USER/$SLURM_JOB_ID
cd /workdir/$USER/$SLURM_JOB_ID

#copy the TE library over 
cp /fs/cbsubscb14/storage/vt235/intersect/$1.fasta.out .

#copy the perl script for build_dictionary over
cp /fs/cbsufsrv5/data2/vt235/piRNA/build_dictionary.pl .

#copy the perl script for one_code over
cp /fs/cbsufsrv5/data2/vt235/piRNA/one_code_to_find_them_all.pl .

#copy the perl script for copy number over
cp /fs/cbsufsrv5/data2/vt235/piRNA/sum_copynumber.pl .

#run build_dictionary and one_code_to_find_them_all.pl
perl build_dictionary.pl --rm $1.fasta.out > $1.dictionary.txt

perl one_code_to_find_them_all.pl --rm $1.fasta.out --ltr $1.dictionary.txt --unknown

#map to the genome
#perl one_code_to_find_them_all.pl --rm $1.genome.fasta.out 

mkdir onecode_out_$1 

mv $1* onecode_out_$1

#move necessary output to file server 5
cp -r onecode_out_$1 /fs/cbsubscb14/storage/vt235/intersect

#run perl to find the copy number
perl sum_copynumber.pl --dir onecode_out_$1 > $1.sumcopynumber.txt

cp $1.sumcopynumber.txt /fs/cbsubscb14/storage/vt235/intersect

cd ..
rm -r ./$SLURM_JOB_ID

#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)

