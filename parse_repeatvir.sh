#!/bin/bash
#$ -S /bin/bash
#$ -q regular.q
#$ -j y
#$ -N parse_repeatvir.sh
#$ -cwd
#$ -pe bscb 4

#qsub parse_repeatvir.sh

#date
d1=$(date +%s)

echo $HOSTNAME
#echo $1
#echo $2

#/programs/bin/labutils/mount_server cbsufsrv5 /data1
#/programs/bin/labutils/mount_server cbsufsrv5 /data2
/programs/bin/labutils/mount_server cbsubscb14 /storage

mkdir -p /workdir/$USER/$JOB_ID
cd /workdir/$USER/$JOB_ID

#copy in the directory 

cp -r /home/vt235/programs/Parsing-RepeatMasker-Outputs .
cp -r /fs/cbsubscb14/storage/vt235/phylogeny/virilis Parsing-RepeatMasker-Outputs

cd Parsing-RepeatMasker-Outputs
ls

perl parseRM_ExtractSeqs_P.pl -dir virilis -min_len 500 -max_div 20 -rc -cat -v

cp *.extracted.fa /fs/cbsubscb14/storage/vt235/phylogeny/virilis

cd ..
cp -r Parsing-RepeatMasker-Outputs /fs/cbsubscb14/storage/vt235/phylogeny
cd ..
rm -r ./$JOB_ID
#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)
