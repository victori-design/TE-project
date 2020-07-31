#!/bin/bash
#$ -S /bin/bash
#$ -q regular.q
#$ -j y
#$ -N dvir_repeatmasker.sh
#$ -cwd
#$ -pe bscb 4


#qsub dvir_repeatmasker.sh


#date
d1=$(date +%s)

echo $HOSTNAME
#echo $1
#echo $2

#/programs/bin/labutils/mount_server cbsufsrv5 /data1
/programs/bin/labutils/mount_server cbsufsrv5 /data2

mkdir -p /workdir/$USER/$JOB_ID
cd /workdir/$USER/$JOB_ID

#copy the genome assembly over 
cp /fs/cbsufsrv5/data2/vt235/genomes/D_virilis.genome.fasta .
cp /fs/cbsufsrv5/data2/vt235/libraries/D_vir.library.fasta .

# run Repeat masker
/programs/RepeatMasker/RepeatMasker -lib D_vir.library.fasta -nolow -pa 8 D_virilis.genome.fasta

# copy the output

cp *.out /fs/cbsufsrv5/data2/vt235/libraries
cp *.tbl /fs/cbsufsrv5/data2/vt235/libraries


cd ..
rm -r ./$JOB_ID
#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)