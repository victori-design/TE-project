#$ -S /bin/bash
#$ -j y
#$ -N TEcounteick
#$ -q regular.q
#$ -l h_vmem=20G
#$ -cwd
#$ -pe bscb 2


# qsub TEcounteick.sh <fileroot> <species>
#Dnov_testes_rep1
#Dere_ovaries_rep1 
#Dnov_ovaries_rep1 
#Dana_ovaries_rep1 
#Dvir_ovaries_rep1 
#Dvir_testes_rep1 

#date
d1=$(date +%s)
echo $HOSTNAME
echo $1
echo $2


/programs/bin/labutils/mount_server cbsufsrv5 /data1

/programs/bin/labutils/mount_server cbsufsrv5 /data2

mkdir -p /workdir/$USER/$JOB_ID

cd /workdir/$USER/$JOB_ID


# copy in the sam file

cp /fs/cbsufsrv5/data2/vt235/eickbushmap/$1_RMod.aln.sam .


# copy in the fasta file of TE library
cp /fs/cbsufsrv5/data2/vt235/eickbushlibs/$2.library.fasta .

# copy in the rosetta file
cp /fs/cbsufsrv5/data2/vt235/eickbushmap/$2.eickseqs.txt .

# now run the command
python3 $HOME/TEtools/TEcount.py -rosette $2.eickseqs.txt -column 2 -TE_fasta $2.library.fasta -count $1.anaNEWeick.TEcount -sam $1_RMod.aln.sam

mv $1.anaNEWeick.TEcount /fs/cbsufsrv5/data2/vt235/eickbushmap

cd ..


rm -r ./$JOB_ID

#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)