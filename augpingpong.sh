#$ -S /bin/bash
#$ -j y
#$ -N augpingpong
#$ -q regular.q
#$ -cwd

# qsub augpingpong.sh <fileroot> <species>
#AnaOvaries_rep2.cut danaA
#AnaOvaries_rep2.cut danaB
#AnaOvaries_rep2.cut dana
#EreOvaries_rep2.cut dere
#NovaOvaries_rep2.cut dnov
#EreOvaries_rep1.cut dere
#NovaOvaries_rep1.cut dnov

#date
d1=$(date +%s)
echo $HOSTNAME
echo $1
echo $2


/programs/bin/labutils/mount_server cbsufsrv5 /data1
/programs/bin/labutils/mount_server cbsufsrv5 /data2

mkdir -p /workdir/$USER/$JOB_ID

cd /workdir/$USER/$JOB_ID

# might need to clone this whole thing - no, I don't think so: hg clone https://testtoolshed.g2.bx.psu.edu/repos/drosofff/msp_sr_signature

# is it python2 or python3? not sure. try with default and if it doesnt work, then switch.

cp /fs/cbsufsrv5/data2/vt235/pirnaAug/$1.$2.R2piRNAmap.sam .
cp /fs/cbsufsrv5/data2/vt235/eickbushr1/$2.r1.fasta .
cp /fs/cbsufsrv5/data2/vt235/eickbushr1/$2.r2.fasta .

cat $2.r1.fasta | cut -f 1 -d " " > $2.NEWr1aug.fasta
cat $2.r2.fasta | cut -f 1 -d " " > $2.NEWr2aug.fasta

cp /fs/cbsufsrv5/data2/vt235/eickbushr1/signature.py .

#python signature.py --input $1.TElib.sam --inputformat sam --minquery 15 --maxquery 40 --mintarget 15 --maxtarget 40 --minscope 5 --maxscope 20 --outputOverlapDataframe --referenceGenome $2_library.fasta --graph lattice

/usr/bin/python signature.py $1.$2.R2piRNAmap.sam 21 30 3 20 $1.$2.R2piRNAmapNEW.signature

#3python signature.py $1.TElib.sam 21 30 21 30 3 20 $1.TElib.signature $2_library.fasta lattice 

cd ..

cp -r ./$JOB_ID /fs/cbsufsrv5/data2/vt235/pirnaAug


rm -r ./$JOB_ID

#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1 ) ))
hour=$(echo - | awk '{ print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)
