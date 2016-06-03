#!/bin/bash
###############################################################################
# SEQ : NORMAL
RUN_DNACOMPACT=1;
RUN_GECO=1;
RUN_COGI=1;
###############################################################################
# SEQ : REFERENCE
RUN_GECO_REF=1;
RUN_COGI_REF=1;
RUN_IDOCOMP=1;
RUN_FRESCO=1;
RUN_GREEN=1;
RUN_GRS=1;
RUN_GDC2=1;
RUN_ERGC=1;
###############################################################################
# FASTA
RUN_MFCOMPRESS=1;
RUN_DELIMINATE=1;
RUN_LEON=1;
###############################################################################
# FASTQ
RUN_FQZCOMP=1;
RUN_QUIP=1;
RUN_SCALCE=1;
RUN_ORCOM=1;
RUN_DSRC=1;
RUN_FQC=1;
RUN_LWFQZIP=1;
###############################################################################
# SAM/BAM
RUN_SAMCOMP=1;
RUN_DEEZ=1;
RUN_NGC=1;
###############################################################################
mkdir -p results
###############################################################################
############################## F U N C T I O N S ##############################
###############################################################################
# CHECK IF FILE EXISTS ========================================================
function FExists {
  file="$1"
  if [ ! -e "$file" ];
    then
    echo "ERROR: File $file does not exist!";
    return;
    fi
  }
# MEMORY1 =====================================================================
function ProgMemoryStart {
  echo "0" > mem_ps;
  while true
    do
    ps aux | grep $1 | awk '{ print $6; }' | sort -V | tail -n 1 >> mem_ps;
    sleep 5;
    done
  }
function ProgMemoryStop {
  kill $1 >/dev/null 2>&1
  cat mem_ps | sort -V | tail -n 1 > $2;
  }
# MEMORY2 =====================================================================
function ProgMemory2 {
  valgrind --tool=massif --pages-as-heap=yes --massif-out-file=massif.out ./$1; 
  cat massif.out | \
  grep mem_heap_B | \
  sed -e 's/mem_heap_B=\(.*\)/\1/' | \
  sort -g | \
  tail -n 1
  }
# TIME ========================================================================
function ProgTime {
  time ./$1
  }
###############################################################################
############################### CHECK DATASETS ################################
###############################################################################
FExists "datasets/human.fna"
FExists "datasets/human2.fna"
FExists "datasets/humanDZ.fna"
FExists "datasets/chimpanze.fna"
FExists "datasets/rice5.fna"
FExists "datasets/rice7.fna"
FExists "datasets/camera.fa"
#
FExists "datasets/ERR174310_1.fastq"
FExists "datasets/ERR174310_2.fastq"
FExists "datasets/ERR194146_1.fastq"
FExists "datasets/ERR194146_2.fastq"
#
FExists "datasets/NA12877_S1.bam"
FExists "datasets/NA12878_S1.bam"
FExists "datasets/NA12882_S1.bam"
FExists "datasets/ERR317482.bam"
###############################################################################
################################ RUN PROGRAMS #################################
###############################################################################
#
###############################################################################
###
###                       REFERENCE-FREE COMPRESSION
###
###############################################################################
###
### FILES TO COMPRESS:
###   [+] human.seq
###   [+] chimpanze.seq
###   [+] rice5.seq
###
###############################################################################
if [[ "$RUN_COGI" -eq "1" ]]; then
mkdir -p results
cd progs/cogi
cat ../../datasets/human.fna  | grep -v ">" | tr -d -c "ACGT" > human.seq
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq

# DOIT : THE PROGRAM SEEMS A MESS FOR REFERENCE-FREE COMPRESSION
# Authors have been emailed for instructions
#
# ./cogi-compress -ur -n 1 TESTE
# ./cogi-uncompress -l 1

rm -f human.seq chimpanze.seq rice5.seq
cd ../../
fi
###############################################################################
if [[ "$RUN_GECO" -eq "1" ]]; then
mkdir -p results
cd progs/geco
cat ../../datasets/human.fna  | grep -v ">" | tr -d -c "ACGT" > human.seq
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq
# HUMAN
ProgMemoryStart "GeCo" &
MEMPID=$!
rm -f human.seq.co
(time ./GeCo -v -l 2 human.seq ) &> ../../results/C_GECO_HUMAN
ls -la human.seq.co > ../../results/BC_GECO_HUMAN
ProgMemoryStop $MEMPID "../../results/MC_GECO_HUMAN";
ProgMemoryStart "GeDe" &
MEMPID=$!
rm -f human.seq.de
(time ./GeDe -v human.seq.co ) &> ../../results/D_GECO_HUMAN
ProgMemoryStop $MEMPID "../../results/MD_GECO_HUMAN";
cmp human.seq human.seq.de &> ../../results/V_GECO_HUMAN
# CHIMPANZEE
ProgMemoryStart "GeCo" &
MEMPID=$!
rm -f chimpanze.seq.co
(time ./GeCo -v -l 2 chimpanze.seq ) &> ../../results/C_GECO_CHIMPANZE
ls -la chimpanze.seq.co > ../../results/BC_GECO_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_GECO_CHIMPANZE";
ProgMemoryStart "GeDe" &
MEMPID=$!
rm -f chimpanze.seq.de
(time ./GeDe -v chimpanze.seq.co ) &> ../../results/D_GECO_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MD_GECO_CHIMPANZE";
cmp chimpanze.seq chimpanze.seq.de &> ../../results/V_GECO_CHIMPANZE
# RICE
ProgMemoryStart "GeCo" &
MEMPID=$!
rm -f rice5.seq.co
(time ./GeCo -v -l 2 rice5.seq ) &> ../../results/C_GECO_RICE
ls -la rice5.seq.co > ../../results/BC_GECO_RICE
ProgMemoryStop $MEMPID "../../results/MC_GECO_RICE";
ProgMemoryStart "GeDe" &
MEMPID=$!
rm -f rice5.seq.de
(time ./GeDe -v rice5.seq.co ) &> ../../results/D_GECO_RICE
ProgMemoryStop $MEMPID "../../results/MD_GECO_RICE";
cmp rice5.seq rice5.seq.de &> ../../results/V_GECO_RICE
#
rm -f human.seq chimpanze.seq rice5.seq
cd ../../
fi
###############################################################################
if [[ "$RUN_DNACOMPACT" -eq "1" ]]; then
ulimit -s 200000000;
mkdir -p results
cd progs/dnacompact
cat ../../datasets/human.fna  | grep -v ">" | tr -d -c "ACGT" > human.seq
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq
# HUMAN
ProgMemoryStart "compact" &
MEMPID=$!
rm -f human.seq.fp
rm -f human.seq.fp.txt.second
(time ./compact n human.seq ) &> ../../results/C_DNACOMPACT_HUMAN
RXS="`ls -la human.seq.fp | awk '{ print $5;}'`+`ls -la human.seq.fp.txt.second | awk '{ print $5;}'`"; 
echo $RXS | bc -l > ../../results/BC_DNACOMPACT_HUMAN
ProgMemoryStop $MEMPID "../../results/MC_DNACOMPACT_HUMAN";
ProgMemoryStart "compact" &
MEMPID=$!
rm -f human.seq.fp.y
touch human.seq.fp.y
(time ./compact -n -d human.seq.fp ) &> ../../results/D_DNACOMPACT_HUMAN
ProgMemoryStop $MEMPID "../../results/MD_DNACOMPACT_HUMAN";
cmp human.seq human.seq.fp.y &> ../../results/V_DNACOMPACT_HUMAN
# CHIMPANZEE
ProgMemoryStart "compact" &
MEMPID=$!
rm -f chimpanze.seq.fp
rm -f chimpanze.seq.fp.txt.second
(time ./compact n chimpanze.seq ) &> ../../results/C_DNACOMPACT_CHIMPANZE
RXS="`ls -la chimpanze.seq.fp | awk '{ print $5;}'`+`ls -la chimpanze.seq.fp.txt.second | awk '{ print $5;}'`"; 
echo $RXS | bc -l > ../../results/BC_DNACOMPACT_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_DNACOMPACT_CHIMPANZE";
ProgMemoryStart "compact" &
MEMPID=$!
rm -f chimpanze.seq.fp.y
touch chimpanze.seq.fp.y
(time ./compact n -d chimpanze.seq.fp ) &> ../../results/D_DNACOMPACT_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MD_DNACOMPACT_CHIMPANZE";
cmp chimpanze.seq chimpanze.seq.fp.y &> ../../results/V_DNACOMPACT_CHIMPANZE
# RICE
ProgMemoryStart "compact" &
MEMPID=$!
rm -f rice5.seq.fp
rm -f rice5.seq.fp.txt.second
(time ./compact n rice5.seq ) &> ../../results/C_DNACOMPACT_RICE
RXS="`ls -la rice5.seq.fp | awk '{ print $5;}'`+`ls -la rice5.seq.fp.txt.second | awk '{ print $5;}'`";
echo $RXS | bc -l > ../../results/BC_DNACOMPACT_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_DNACOMPACT_RICE";
ProgMemoryStart "compact" &
MEMPID=$!
rm -f rice5.seq.fp.y
touch rice5.seq.fp.y
(time ./compact n -d rice5.seq.fp ) &> ../../results/D_DNACOMPACT_RICE
ProgMemoryStop $MEMPID "../../results/MD_DNACOMPACT_RICE";
cmp rice5.seq rice5.seq.fp.y &> ../../results/V_DNACOMPACT_RICE
#
rm -f human.seq chimpanze.seq rice5.seq
cd ../../
fi
###############################################################################
###
###                          REFERENCE COMPRESSION
###
###############################################################################
###
### FILES TO COMPRESS:
###   [+] human2.fna | human.fna
###   [+] human.fna  | chimpanze.fna
###   [+] rice5.fna  | rice7.fna
###
###############################################################################
if [[ "$RUN_IDOCOMP" -eq "1" ]]; then
mkdir -p results
cd progs/idocomp

# CANNOT ALLOCATE MEMORY FOR SUCH A LONG FILE -> need to split into 900 MB Files

# HUMAN
cat ../../datasets/human2.fna | grep -v ">" | tr -d -c "ACGT" > human2.seq
cat ../../datasets/human.fna | grep -v ">" | tr -d -c "ACGT" > human.seq
echo ">Header" > Header;
cat Header human2.seq > human2.fa
cat Header human.seq > human.fa
rm -f human2.seq human.seq
cd sais-lite-2.4.1/
rm -fr sa ref tar
mkdir sa ref tar;
cp ../human.fa ref/
ProgMemoryStart "generateSA.sh" & # THE MAXIMUM PEAK IS REACHED HERE
MEMPID=$!
(./generateSA.sh ref sa ) &> TIME_SA
TIMEOFSA=`cat TIME_SA | grep "..." | awk '{ print $5;}'`
ProgMemoryStop $MEMPID "../../results/MC_IDOCOMP_RICE";
mv ../human2.fa tar/
echo "ref/human.fa tar/human2.fa sa/human.sa" > f.txt;
cp ../simulations/iDoComp.run .
(./iDoComp.run c f.txt OUT ) &> ../../../results/C_IDOCOMP_HUMAN
cat ../../../results/C_IDOCOMP_RICE | grep "Compressed Size:" \
| awk '{ print $3; }' > ../../../results/BC_IDOCOMP_HUMAN
CTIME=`cat ../../../results/C_IDOCOMP_HUMAN | grep "CPU T" | awk '{ print $4;}'`
echo "$TIMEOFSA+$CTIME" | bc -l > ../../../results/CT_IDOCOMP_HUMAN
echo "ref/human.fa out.fa" > f.txt;
(./iDoComp.run d f.txt OUT ) &> ../../../results/D_IDOCOMP_HUMAN
DTIME=`cat ../../../results/D_IDOCOMP_HUMAN | grep "CPU T" | awk '{ print $4;}'`
echo "$TIMEOFSA+$DTIME" | bc -l > ../../../results/DT_IDOCOMP_HUMAN
cmp tar/human2.fa out.fa &> ../../../results/V_IDOCOMP_HUMAN
#rm -f human2.fa human.fa

# CHIMPANZE
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/human.fna | grep -v ">" | tr -d -c "ACGT" > human.seq
echo ">Header" > Header;
cat Header chimpanze.seq > chimpanze.fa
cat Header human.seq > human.fa
rm -f chimpanze.seq human.seq
cd sais-lite-2.4.1/
rm -fr sa ref tar
mkdir sa ref tar;
cp ../human.fa ref/
ProgMemoryStart "generateSA.sh" & # THE MAXIMUM PEAK IS REACHED HERE
MEMPID=$!
(./generateSA.sh ref sa ) &> TIME_SA
TIMEOFSA=`cat TIME_SA | grep "..." | awk '{ print $5;}'`
ProgMemoryStop $MEMPID "../../results/MC_IDOCOMP_RICE";
mv ../chimpanze.fa tar/
echo "ref/human.fa tar/chimpanze.fa sa/human.sa" > f.txt;
cp ../simulations/iDoComp.run .
(./iDoComp.run c f.txt OUT ) &> ../../../results/C_IDOCOMP_HUMAN
cat ../../../results/C_IDOCOMP_RICE | grep "Compressed Size:" \
| awk '{ print $3; }' > ../../../results/BC_IDOCOMP_HUMAN
CTIME=`cat ../../../results/C_IDOCOMP_HUMAN | grep "CPU T" | awk '{ print $4;}'`
echo "$TIMEOFSA+$CTIME" | bc -l > ../../../results/CT_IDOCOMP_HUMAN
echo "ref/human.fa out.fa" > f.txt;
(./iDoComp.run d f.txt OUT ) &> ../../../results/D_IDOCOMP_HUMAN
DTIME=`cat ../../../results/D_IDOCOMP_HUMAN | grep "CPU T" | awk '{ print $4;}'`
echo "$TIMEOFSA+$DTIME" | bc -l > ../../../results/DT_IDOCOMP_HUMAN
cmp tar/chimpanze.fa out.fa &> ../../../results/V_IDOCOMP_HUMAN
#rm -f chimpanze.fa human.fa

# RICE
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq
cat ../../datasets/rice7.fna | grep -v ">" | tr -d -c "ACGT" > rice7.seq
echo ">Header" > Header;
cat Header rice5.seq > rice5.fa
cat Header rice7.seq > rice7.fa
rm -f rice5.seq rice7.seq
cd sais-lite-2.4.1/
rm -fr sa ref tar
mkdir sa ref tar;
cp ../rice7.fa ref/
ProgMemoryStart "generateSA.sh" & # THE MAXIMUM PEAK IS REACHED HERE
MEMPID=$!
(./generateSA.sh ref sa ) &> TIME_SA
TIMEOFSA=`cat TIME_SA | grep "..." | awk '{ print $5;}'`
ProgMemoryStop $MEMPID "../../results/MC_IDOCOMP_RICE";
mv ../rice5.fa tar/
echo "ref/rice7.fa tar/rice5.fa sa/rice7.sa" > f.txt;
cp ../simulations/iDoComp.run .
(./iDoComp.run c f.txt OUT ) &> ../../../results/C_IDOCOMP_RICE
cat ../../../results/C_IDOCOMP_RICE | grep "Compressed Size:" \
| awk '{ print $3; }' > ../../../results/BC_IDOCOMP_RICE
CTIME=`cat ../../../results/C_IDOCOMP_RICE | grep "CPU T" | awk '{ print $4;}'`
echo "$TIMEOFSA+$CTIME" | bc -l > ../../../results/CT_IDOCOMP_RICE
echo "ref/rice7.fa out.fa" > f.txt;
(./iDoComp.run d f.txt OUT ) &> ../../../results/D_IDOCOMP_RICE
DTIME=`cat ../../../results/D_IDOCOMP_RICE | grep "CPU T" | awk '{ print $4;}'`
echo "$TIMEOFSA+$DTIME" | bc -l > ../../../results/DT_IDOCOMP_RICE
cmp tar/rice5.fa out.fa &> ../../../results/V_IDOCOMP_RICE
#rm -f rice5.fa rice7.fa

cd ../../../
fi
###############################################################################
if [[ "$RUN_GECO_REF" -eq "1" ]]; then
mkdir -p results
cd progs/geco
cat ../../datasets/human.fna  | grep -v ">" | tr -d -c "ACGT" > human.seq
cat ../../datasets/human2.fna | grep -v ">" | tr -d -c "ACGT" > human2.seq
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq
cat ../../datasets/rice7.fna | grep -v ">" | tr -d -c "ACGT" > rice7.seq
# HUMAN
ProgMemoryStart "GeCo" &
MEMPID=$!
rm -f human2.seq.co
(time ./GeCo -v -l 14 -r human.seq \
human2.seq ) &> ../../results/C_GECO_REF_HUMAN
ls -la human2.seq.co > ../../results/BC_GECO_REF_HUMAN
ProgMemoryStop $MEMPID "../../results/MC_GECO_REF_HUMAN";
ProgMemoryStart "GeDe" &
MEMPID=$!
rm -f human2.seq.de
(time ./GeDe -v -r human.seq \
human2.seq.co ) &> ../../results/D_GECO_REF_HUMAN
ProgMemoryStop $MEMPID "../../results/MD_GECO_REF_HUMAN";
cmp human2.seq human2.seq.de &> ../../results/V_GECO_REF_HUMAN
# CHIMPANZEE
ProgMemoryStart "GeCo" &
MEMPID=$!
rm -f human.seq.co
(time ./GeCo -v -l 14 -r chimpanze.seq \
human.seq ) &> ../../results/C_GECO_REF_CHIMPANZE
ls -la human.seq.co > ../../results/BC_GECO_REF_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_GECO_REF_CHIMPANZE";
ProgMemoryStart "GeDe" &
MEMPID=$!
rm -f human.seq.de
(time ./GeDe -v -r chimpanze.seq \
human.seq.co ) &> ../../results/D_GECO_REF_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MD_GECO_REF_CHIMPANZE";
cmp human.seq human.seq.de &> ../../results/V_GECO_REF_CHIMPANZE
# RICE
ProgMemoryStart "GeCo" &
MEMPID=$!
rm -f rice5.seq.co
(time ./GeCo -v -l 14 -r rice7.seq \
rice5.seq ) &> ../../results/C_GECO_REF_RICE
ls -la rice5.seq.co > ../../results/BC_GECO_REF_RICE
ProgMemoryStop $MEMPID "../../results/MC_GECO_REF_RICE";
ProgMemoryStart "GeDe" &
MEMPID=$!
rm -f rice5.seq.de
(time ./GeDe -v -r rice7.seq \
rice5.seq.co ) &> ../../results/D_GECO_REF_RICE
ProgMemoryStop $MEMPID "../../results/MD_GECO_REF_RICE";
cmp rice5.seq rice5.seq.de &> ../../results/V_GECO_REF_RICE
#
rm -f human.seq human2.seq chimpanze.seq rice5.seq rice7.seq
cd ../../
fi
###############################################################################
if [[ "$RUN_GREEN" -eq "1" ]]; then
GREEN_PARAMETERS=" -v -i -k 16 -f 5 ";
mkdir -p results
cd progs/green
cat ../../datasets/human.fna  | grep -v ">" | tr -d -c "ACGT" > human.seq
cat ../../datasets/human2.fna | grep -v ">" | tr -d -c "ACGT" > human2.seq
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq
cat ../../datasets/rice7.fna | grep -v ">" | tr -d -c "ACGT" > rice7.seq
# HUMAN
ProgMemoryStart "GReEnC" &
MEMPID=$!
rm -f human2.seq.co
(time ./GReEnC $GREEN_PARAMETERS -o human2.seq.co human.seq \
human2.seq ) &> ../../results/C_GREEN_HUMAN
ls -la human2.seq.co > ../../results/BC_GREEN_HUMAN
ProgMemoryStop $MEMPID "../../results/MC_GREEN_HUMAN";
ProgMemoryStart "GReEnD" &
MEMPID=$!
rm -f human2.seq.de
(time ./GReEnD -o human2.seq.de human.seq \
human2.seq.co ) &> ../../results/D_GREEN_HUMAN
ProgMemoryStop $MEMPID "../../results/MD_GREEN_HUMAN";
cmp human2.seq human2.seq.de &> ../../results/V_GREEN_HUMAN
# CHIMPANZE
ProgMemoryStart "GReEnC" &
MEMPID=$!
rm -f human.seq.co
(time ./GReEnC $GREEN_PARAMETERS -o human.seq.co chimpanze.seq \
human.seq ) &> ../../results/C_GREEN_CHIMPANZE
ls -la human.seq.co > ../../results/BC_GREEN_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_GREEN_CHIMPANZE";
ProgMemoryStart "GReEnD" &
MEMPID=$!
rm -f human.seq.de
(time ./GReEnD -o human.seq.de chimpanze.seq \
human.seq.co ) &> ../../results/D_GREEN_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MD_GREEN_CHIMPANZE";
cmp human.seq human.seq.de &> ../../results/V_GREEN_CHIMPANZE
# RICE
ProgMemoryStart "GReEnC" &
MEMPID=$!
rm -f rice5.seq.co
(time ./GReEnC $GREEN_PARAMETERS -o rice5.seq.co rice7.seq \
rice5.seq ) &> ../../results/C_GREEN_RICE
ls -la rice5.seq.co > ../../results/BC_GREEN_RICE
ProgMemoryStop $MEMPID "../../results/MC_GREEN_RICE";
ProgMemoryStart "GReEnD" &
MEMPID=$!
rm -f rice5.seq.de
(time ./GReEnD -o rice5.seq.de rice7.seq \
rice5.seq.co ) &> ../../results/D_GREEN_RICE
ProgMemoryStop $MEMPID "../../results/MD_GREEN_RICE";
cmp rice5.seq rice5.seq.de &> ../../results/V_GREEN_RICE
rm -f human.seq human2.seq chimpanze.seq rice5.seq rice7.seq
cd ../../
fi
###############################################################################
if [[ "$RUN_COGI" -eq "1" ]]; then
mkdir -p results
cd progs/cogi
cat ../../datasets/human.fna  | grep -v ">" | tr -d -c "ACGT" > human.seq
cat ../../datasets/human2.fna | grep -v ">" | tr -d -c "ACGT" > human2.seq
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq
cat ../../datasets/rice7.fna | grep -v ">" | tr -d -c "ACGT" > rice7.seq
# XXX: HUMAN: MAP FAIL
./cogi-compress -ur --hash -n 2 human.seq human2.seq
./cogi-uncompress -r human.seq -l 60
# XXX: CHIMPANZE: MAP FAIL
./cogi-compress -ur --hash -n 2 chimpanze.seq human.seq
./cogi-uncompress -r chimpanze.seq -l 60
# RICE:
# bytes = 80583866 + 9956, time ~ 86s
# time 26 s
# cmp 1.fastq rice5.seq # XXX: cmp = different files
ProgMemoryStart "cogi-compress" &
MEMPID=$!
rm -f compressed 1.patch
(time ./cogi-compress -ur --hash -n 2 rice7.seq \
rice5.seq ) &> ../../results/C_COGI_RICE
CBYTES1=`ls -la 1.patch | awk '{ print $5;}'`
CBYTES2=`ls -la compressed | awk '{ print $5;}'`
echo "$CBYTES1+$CBYTES2" | bc -l > ../../results/BC_COGI_RICE
ProgMemoryStop $MEMPID "../../results/MC_COGI_RICE";
ProgMemoryStart "cogi-uncompress" &
MEMPID=$!
rm -f 1.fastq
(time ./cogi-uncompress -r rice7.seq -l 60 ) &> ../../results/D_COGI_RICE
ProgMemoryStop $MEMPID "../../results/MD_COGI_RICE";
cmp 1.seq rice5.seq &> ../../results/V_COGI_RICE
#
rm -f human.seq human2.seq chimpanze.seq rice5.seq rice7.seq
cd ../../
fi
###############################################################################
if [[ "$RUN_DNACOMPACT" -eq "1" ]]; then
./compact n [-N] infile 
#Command line options:N is the minimum match length, (default 25)
./compact n -d infile
#Default output is infile.y
#For reference-based compression:
./compact r c sourcefile reference leftWindowSize rightWindowSize
#Default leftWindowSize and rightWindowSize are adaptively obtained through 
#calculating the difference percentage between source sequence and reference 
#sequence.
./compact r d sourcefile reference
fi
###############################################################################
if [[ "$RUN_GDC" -eq "1" ]]; then
mkdir -p results
cd progs/gdc2
cp ../../datasets/human.fna . 
cp ../../datasets/human2.fna . 
cp ../../datasets/chimpanze.fna . 
cp ../../datasets/rice5.fna . 
cp ../../datasets/rice7.fna . 
# GDC IS FOR COLLECTIONS
./GDC2 compressed human.fna human2.fna
./GDC2 d compressed human.fna human2.fna
# IT CAN BE COMPARED WITH GECO: GECO->compress:{cat human2.fna human.fna}
# Headers will be minimal, even GDC might not encode headers (= geco)
rm -f human.seq human2.seq chimpanze.seq rice5.seq rice7.seq
cd ../../
fi
###############################################################################
if [[ "$RUN_ERGC" -eq "1" ]]; then
mkdir -p results
cd progs/ergc
cp ../../datasets/human.fna . 
cp ../../datasets/human2.fna . 
cp ../../datasets/chimpanze.fna . 
cp ../../datasets/rice5.fna . 
cp ../../datasets/rice7.fna . 
mv human.fna ko-131-22.fa #ref
mv human2.fna ko-224-22.fa #tar
. SCRIPT_ERGC_COMP
#chr.ergc.7z #compressed

. SCRIPT_ERGC_DECOMP 
#final_out_chr.fa # OUT

rm -f human.seq human2.seq chimpanze.seq rice5.seq rice7.seq
cd ../../
fi
###############################################################################
if [[ "$RUN_FRESCO" -eq "1" ]]; then
./FRESCO-BIN FRESCO/config.ini COMPRESS /bio/uncompressed/ /bio/compressed/ 
./FRESCO-BIN FRESCO/config.ini DECOMRESS /bio/compressed/ /bio/decompressed/ 
fi
##############################################################################
if [[ "$RUN_GRS" -eq "1" ]]; then
cp REF.seq Compress/bin/
cp TAR.seq Compress/bin/
cd Compress/bin/
./GRS.sh REF.seq TAR.seq
cd ../../
cp REF.seq Decompress/bin/
fi
##############################################################################
#
##############################################################################
################################### FASTA ####################################
##############################################################################
###
### FILES TO COMPRESS:
###   [+] human.fna (2.7 GB)
###   [+] chimpanze.fna (3 GB)
###   [+] rice5.fna (165 MB)
###   [+] camera.fa (42 GB)
###
##############################################################################
if [[ "$RUN_DELIMINATE" -eq "1" ]]; then
mkdir -p results
cd progs/deliminate
# HUMAN
mv ../../datasets/human.fna .
ProgMemoryStart "delim" &
MEMPID=$!
rm -f human.fna.dlim
(time ./delim a human.fna ) &> ../../results/C_DELIMINATE_HUMAN
ls -la human.fna.dlim > ../../results/BC_DELIMINATE_HUMAN
ProgMemoryStop $MEMPID "../../results/MC_DELIMINATE_HUMAN";
ProgMemoryStart "delim" &
MEMPID=$!
rm -f human.fna.dlim.d
(time ./delim e human.fna.dlim ) &> ../../results/D_DELIMINATE_HUMAN
ProgMemoryStop $MEMPID "../../results/MD_DELIMINATE_HUMAN";
cmp human.fna human.fna.dlim.d &> ../../results/V_DELIMINATE_HUMAN
mv human.fna ../../datasets/
# CHIMPANZEE
mv ../../datasets/chimpanze.fna .
ProgMemoryStart "delim" &
MEMPID=$!
rm -f chimpanze.fna.dlim
(time ./delim a chimpanze.fna ) &> ../../results/C_DELIMINATE_CHIMPANZE
ls -la chimpanze.fna.dlim > ../../results/BC_DELIMINATE_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_DELIMINATE_CHIMPANZE";
ProgMemoryStart "delim" &
MEMPID=$!
rm -f chimpanze.fna.dlim.d
(time ./delim e chimpanze.fna.dlim ) &> ../../results/D_DELIMINATE_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MD_DELIMINATE_CHIMPANZE";
cmp chimpanze.fna chimpanze.fna.dlim.d &> ../../results/V_DELIMINATE_CHIMPANZE
mv chimpanze.fna ../../datasets/
# RICE
mv ../../datasets/rice5.fna .
ProgMemoryStart "delim" &
MEMPID=$!
rm -f rice5.fna.dlim
(time ./delim a rice5.fna ) &> ../../results/C_DELIMINATE_RICE
ls -la rice5.fna.dlim > ../../results/BC_DELIMINATE_RICE
ProgMemoryStop $MEMPID "../../results/MC_DELIMINATE_RICE";
ProgMemoryStart "delim" &
MEMPID=$!
rm -f rice5.fna.dlim.d
(time ./delim e rice5.fna.dlim ) &> ../../results/D_DELIMINATE_RICE
ProgMemoryStop $MEMPID "../../results/MD_DELIMINATE_RICE";
cmp rice5.fna rice5.fna.dlim.d &> ../../results/V_DELIMINATE_RICE
mv rice5.fna ../../datasets/
# CAMERA
mv ../../datasets/camera.fa .
ProgMemoryStart "delim" &
MEMPID=$!
rm -f camera.fa.dlim
(time ./delim a camera.fa ) &> ../../results/C_DELIMINATE_CAMERA
ls -la camera.fa.dlim > ../../results/BC_DELIMINATE_CAMERA
ProgMemoryStop $MEMPID "../../results/MC_DELIMINATE_CAMERA";
ProgMemoryStart "delim" &
MEMPID=$!
rm -f camera.fa.dlim.d
(time ./delim e camera.fa.dlim ) &> ../../results/D_DELIMINATE_CAMERA
ProgMemoryStop $MEMPID "../../results/MD_DELIMINATE_CAMERA";
cmp camera.fa camera.fa.dlim.d &> ../../results/V_DELIMINATE_CAMERA
mv camera.fa ../../datasets/
cd ../../
fi
###############################################################################
if [[ "$RUN_LEON" -eq "1" ]]; then
mkdir -p results
cd progs/leon

# XXX: IT DOES NOT WORK WITH HUMAN AND CHIMPANZE (IT ENTERS IN A INFINITE LOOP)
# XXX: CAUSE SEEMS TO BE THE SIZE OF THE READ (NUMBER OF BASES BETWEEN HEADERS)
# XXX: IT WORKS ON RICE
# TODO: CHECK IF IT WORKS ON CAMERA!

# HUMAN
mv ../../datasets/human.fna human.fa
ProgMemoryStart "leon" &
MEMPID=$!
rm -f human.fna.leon
(time ./leon -c -file human.fa ) &> ../../results/C_LEON_HUMAN
ls -la human.fa.leon > ../../results/BC_LEON_HUMAN
ProgMemoryStop $MEMPID "../../results/MC_LEON_HUMAN";
ProgMemoryStart "leon" &
MEMPID=$!
rm -f human.fa.d
(time ./leon -d -file human.fa.leon ) &> ../../results/D_LEON_HUMAN
ProgMemoryStop $MEMPID "../../results/MD_LEON_HUMAN";
cmp human.fa human.fa.d &> ../../results/V_LEON_HUMAN
mv human.fa ../../datasets/human.fna
# CHIMPANZEE
mv ../../datasets/chimpanze.fna chimpanze.fa
ProgMemoryStart "leon" &
MEMPID=$!
rm -f chimpanze.fa.leon
(time ./leon -c -file chimpanze.fa ) &> ../../results/C_LEON_CHIMPANZE
ls -la chimpanze.fa.leon > ../../results/BC_LEON_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_LEON_CHIMPANZE";
ProgMemoryStart "leon" &
MEMPID=$!
rm -f chimpanze.fa.d
(time ./leon -d -file chimpanze.fa.leon ) &> ../../results/D_LEON_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MD_LEON_CHIMPANZE";
cmp chimpanze.fa chimpanze.fa.d &> ../../results/V_LEON_CHIMPANZE
mv chimpanze.fa ../../datasets/chimpanze.fna
# RICE
mv ../../datasets/rice5.fna rice5.fa
ProgMemoryStart "leon" &
MEMPID=$!
rm -f rice5.fa.leon
(time ./leon -c -file rice5.fa ) &> ../../results/C_LEON_RICE
ls -la rice5.fa.leon > ../../results/BC_LEON_RICE
ProgMemoryStop $MEMPID "../../results/MC_LEON_RICE";
ProgMemoryStart "leon" &
MEMPID=$!
rm -f rice5.fa.d
(time ./leon -d -file rice5.fa.leon ) &> ../../results/D_LEON_RICE
ProgMemoryStop $MEMPID "../../results/MD_LEON_RICE";
cmp rice5.fa rice5.fa.d &> ../../results/V_LEON_RICE
mv rice5.fa ../../datasets/rice5.fna
#CAMERA
mv ../../datasets/camera.fa .
ProgMemoryStart "leon" &
MEMPID=$!
rm -f camera.fa.leon
(time ./leon -c -file camera.fa ) &> ../../results/C_LEON_CAMERA
ls -la camera.fa.leon > ../../results/BC_LEON_CAMERA
ProgMemoryStop $MEMPID "../../results/MC_LEON_CAMERA";
ProgMemoryStart "leon" &
MEMPID=$!
rm -f camera.fa.d
(time ./leon -d -file camera.fa.leon ) &> ../../results/D_LEON_CAMERA
ProgMemoryStop $MEMPID "../../results/MD_LEON_CAMERA";
cmp camera.fa camera.fa.d &> ../../results/V_LEON_CAMERA
mv camera.fa ../../datasets/
cd ../../
fi
###############################################################################
if [[ "$RUN_MFCOMPRESS" -eq "1" ]]; then
mkdir -p results
cd progs/mfcompress
# HUMAN
mv ../../datasets/human.fna .
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f human.fna.mfc
(time ./MFCompressC -v \
-o human.fna.mfc human.fna ) &> ../../results/C_MFCOMPRESS_HUMAN
ls -la human.fna.mfc > ../../results/BC_MFCOMPRESS_HUMAN
ProgMemoryStop $MEMPID "../../results/MC_MFCOMPRESS_HUMAN";
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f human.fna.d
(time ./MFCompressD -v \
-o human.fna.d human.fna.mfc ) &> ../../results/D_MFCOMPRESS_HUMAN
ProgMemoryStop $MEMPID "../../results/MD_MFCOMPRESS_HUMAN";
cmp human.fna human.fna.d &> ../../results/V_MFCOMPRESS_HUMAN
mv human.fna ../../datasets/
# CHIMPANZEE
mv ../../datasets/chimpanze.fna .
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f chimpanze.fna.mfc
(time ./MFCompressC -v \
-o chimpanze.fna.mfc chimpanze.fna ) &> ../../results/C_MFCOMPRESS_CHIMPANZE
ls -la chimpanze.fna.mfc > ../../results/BC_MFCOMPRESS_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MC_MFCOMPRESS_CHIMPANZE";
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f chimpanze.fna.d
(time ./MFCompressD -v \
-o chimpanze.fna.d chimpanze.fna.mfc ) &> ../../results/D_MFCOMPRESS_CHIMPANZE
ProgMemoryStop $MEMPID "../../results/MD_MFCOMPRESS_CHIMPANZE";
cmp chimpanze.fna chimpanze.fna.d &> ../../results/V_MFCOMPRESS_CHIMPANZE
mv chimpanze.fna ../../datasets/
# RICE
mv ../../datasets/rice5.fna .
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f rice5.fna.mfc
(time ./MFCompressC -v \
-o rice5.fna.mfc rice5.fna ) &> ../../results/C_MFCOMPRESS_RICE
ls -la rice5.fna.mfc > ../../results/BC_MFCOMPRESS_RICE
ProgMemoryStop $MEMPID "../../results/MC_MFCOMPRESS_RICE";
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f rice5.fna.d
(time ./MFCompressD -v \
-o rice5.fna.d rice5.fna.mfc ) &> ../../results/D_MFCOMPRESS_RICE
ProgMemoryStop $MEMPID "../../results/MD_MFCOMPRESS_RICE";
cmp rice5.fna rice5.fna.d &> ../../results/V_MFCOMPRESS_RICE
mv rice5.fna ../../datasets/
# CAMERA
mv ../../datasets/camera.fa .
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f camera.fa.mfc
(time ./MFCompressC -v \
-o camera.fa.mfc camera.fa ) &> ../../results/C_MFCOMPRESS_CAMERA
ls -la camera.fa.mfc > ../../results/BC_MFCOMPRESS_CAMERA
ProgMemoryStop $MEMPID "../../results/MC_MFCOMPRESS_CAMERA";
ProgMemoryStart "MFCompress" &
MEMPID=$!
rm -f camera.fa.d
(time ./MFCompressD -v \
-o camera.fa.d camera.fa.mfc ) &> ../../results/D_MFCOMPRESS_CAMERA
ProgMemoryStop $MEMPID "../../results/MD_MFCOMPRESS_CAMERA";
cmp camera.fa camera.fa.d &> ../../results/V_MFCOMPRESS_CAMERA
mv camera.fa ../../datasets/
cd ../../
fi
###############################################################################
#
###############################################################################
################################### FASTQ #####################################
###############################################################################
###
### FILES TO COMPRESS:
###   [+] ERR174310_1.fastq (51 GB)
###   [+] ERR174310_2.fastq (51 GB)
###   [+] ERR194146_1.fastq (205 GB)
###   [+] ERR194146_2.fastq (205 GB)
###
###############################################################################
if [[ "$RUN_ORCOM" -eq "1" ]]; then
#
# XXX: UNABLE TO RUN USING MULTITHREADING & IT ONLY DECODES DNA! 
# XXX: DOES IT ENCODE HEADERS AND SCORES?!
#
mkdir -p results
cd progs/orcom
# ERR174310_1
mv ../../datasets/ERR174310_1.fastq .
ProgMemoryStart "orcom_bin" &
MEMPID=$!
rm -f TMP.bdna TMP.bmeta
(time ./orcom_bin e -iERR174310_1.fastq -t1 \
-oTMP ) &> ../../results/C_ORCOM_ERR174310_1
CBYTESO1=`ls -la TMP.bdna | awk '{ print $5;}'`
CBYTESO2=`ls -la TMP.bmeta | awk '{ print $5;}'`
echo "$CBYTESO1+$CBYTESO2" | bc -l > ../../results/BC_ORCOM_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MC_ORCOM_ERR174310_1";
ProgMemoryStart "orcom_bin" &
MEMPID=$!
rm -f OUT; 
(time ./orcom_bin d -iTMP -oOUT ) &> ../../results/D_ORCOM_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MD_ORCOM_ERR174310_1";
cmp ERR174310_1.fastq OUT &> ../../results/V_ORCOM_ERR174310_1
mv ERR174310_1.fastq ../../datasets/
#
# ERR174310_2
mv ../../datasets/ERR174310_2.fastq .
ProgMemoryStart "orcom_bin" &
MEMPID=$!
rm -f TMP.bdna TMP.bmeta
(time ./orcom_bin e -iERR174310_2.fastq -t1 \
-oTMP ) &> ../../results/C_ORCOM_ERR174310_2
CBYTESO1=`ls -la TMP.bdna | awk '{ print $5;}'`
CBYTESO2=`ls -la TMP.bmeta | awk '{ print $5;}'`
echo "$CBYTESO1+$CBYTESO2" | bc -l > ../../results/BC_ORCOM_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MC_ORCOM_ERR174310_2";
ProgMemoryStart "orcom_bin" &
MEMPID=$!
rm -f OUT;
(time ./orcom_bin d -iTMP -oOUT ) &> ../../results/D_ORCOM_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MD_ORCOM_ERR174310_2";
cmp ERR174310_2.fastq OUT &> ../../results/V_ORCOM_ERR174310_2
mv ERR174310_2.fastq ../../datasets/
#
# ERR194146_1
mv ../../datasets/ERR194146_1.fastq .
ProgMemoryStart "orcom_bin" &
MEMPID=$!
rm -f TMP.bdna TMP.bmeta
(time ./orcom_bin e -iERR194146_1.fastq -t1 \
-oTMP ) &> ../../results/C_ORCOM_ERR194146_1
CBYTESO1=`ls -la TMP.bdna | awk '{ print $5;}'`
CBYTESO2=`ls -la TMP.bmeta | awk '{ print $5;}'`
echo "$CBYTESO1+$CBYTESO2" | bc -l > ../../results/BC_ORCOM_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MC_ORCOM_ERR194146_1";
ProgMemoryStart "orcom_bin" &
MEMPID=$!
rm -f OUT;
(time ./orcom_bin d -iTMP -oOUT ) &> ../../results/D_ORCOM_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MD_ORCOM_ERR194146_1";
cmp ERR194146_1.fastq OUT &> ../../results/V_ORCOM_ERR194146_1
mv ERR194146_1.fastq ../../datasets/
#
# ERR194146_2
mv ../../datasets/ERR194146_2.fastq .
ProgMemoryStart "orcom_bin" &
MEMPID=$!
rm -f TMP.bdna TMP.bmeta
(time ./orcom_bin e -iERR194146_2.fastq -t1 \
-oTMP ) &> ../../results/C_ORCOM_ERR194146_2
CBYTESO1=`ls -la TMP.bdna | awk '{ print $5;}'`
CBYTESO2=`ls -la TMP.bmeta | awk '{ print $5;}'`
echo "$CBYTESO1+$CBYTESO2" | bc -l > ../../results/BC_ORCOM_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MC_ORCOM_ERR194146_2";
ProgMemoryStart "orcom_bin" &
MEMPID=$!
rm -f OUT;
(time ./orcom_bin d -iTMP -oOUT ) &> ../../results/D_ORCOM_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MD_ORCOM_ERR194146_2";
cmp ERR194146_2.fastq OUT &> ../../results/V_ORCOM_ERR194146_2
mv ERR194146_2.fastq ../../datasets/
#
cd ../../
fi
###############################################################################
if [[ "$RUN_DSRC" -eq "1" ]]; then
mkdir -p results
cd progs/dsrc
# ERR174310_1
mv ../../datasets/ERR174310_1.fastq .
ProgMemoryStart "dsrc" &
MEMPID=$!
rm -f OUT.dsrc
(time ./dsrc c \
-m2 ERR174310_1.fastq OUT.dsrc ) &> ../../results/C_DSRC_ERR174310_1
ls -la OUT.dsrc > ../../results/BC_DSRC_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MC_DSRC_ERR174310_1";
ProgMemoryStart "dsrc" &
MEMPID=$!
rm -f OUT.out;
(time ./dsrc d OUT.dsrc OUT.out ) &> ../../results/D_DSRC_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MD_DSRC_ERR174310_1";
cmp ERR174310_1.fastq OUT.out &> ../../results/V_DSRC_ERR174310_1
mv ERR174310_1.fastq ../../datasets/
#
# ERR174310_1
mv ../../datasets/ERR174310_2.fastq .
ProgMemoryStart "dsrc" &
MEMPID=$!
rm -f OUT.dsrc
(time ./dsrc c \
-m2 ERR174310_2.fastq OUT.dsrc ) &> ../../results/C_DSRC_ERR174310_2
ls -la OUT.dsrc > ../../results/BC_DSRC_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MC_DSRC_ERR174310_2";
ProgMemoryStart "dsrc" &
MEMPID=$!
rm -f OUT.out;
(time ./dsrc d OUT.dsrc OUT.out ) &> ../../results/D_DSRC_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MD_DSRC_ERR174310_2";
cmp ERR174310_2.fastq OUT.out &> ../../results/V_DSRC_ERR174310_2
mv ERR174310_2.fastq ../../datasets/
#
# ERR194146_1
mv ../../datasets/ERR194146_1.fastq .
ProgMemoryStart "dsrc" &
MEMPID=$!
rm -f OUT.dsrc
(time ./dsrc c \
-m2 ERR194146_1.fastq OUT.dsrc ) &> ../../results/C_DSRC_ERR194146_1
ls -la OUT.dsrc > ../../results/BC_DSRC_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MC_DSRC_ERR194146_1";
ProgMemoryStart "dsrc" &
MEMPID=$!
rm -f OUT.out;
(time ./dsrc d OUT.dsrc OUT.out ) &> ../../results/D_DSRC_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MD_DSRC_ERR194146_1";
cmp ERR194146_1.fastq OUT.out &> ../../results/V_DSRC_ERR194146_1
mv ERR194146_1.fastq ../../datasets/
#
# ERR194146_2
mv ../../datasets/ERR194146_2.fastq .
ProgMemoryStart "dsrc" &
MEMPID=$!
rm -f OUT.dsrc
(time ./dsrc c \
-m2 ERR194146_2.fastq OUT.dsrc ) &> ../../results/C_DSRC_ERR194146_2
ls -la OUT.dsrc > ../../results/BC_DSRC_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MC_DSRC_ERR194146_2";
ProgMemoryStart "dsrc" &
MEMPID=$!
rm -f OUT.out;
(time ./dsrc d OUT.dsrc OUT.out ) &> ../../results/D_DSRC_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MD_DSRC_ERR194146_2";
cmp ERR194146_2.fastq OUT.out &> ../../results/V_DSRC_ERR194146_2
mv ERR194146_2.fastq ../../datasets/
#
cd ../../
fi
###############################################################################
if [[ "$RUN_FQC" -eq "1" ]]; then
./fqc -c -i sample.fastq -o tmp
./fqc -d -i tmp -o sample.out.fastq
fi
###############################################################################
if [[ "$RUN_FQZCOMP" -eq "1" ]]; then
mkdir -p results
cd progs/fqzcomp
# ERR174310_1
mv ../../datasets/ERR174310_1.fastq .
ProgMemoryStart "fqz_comp" &
MEMPID=$!
rm -f OUT
(time ./fqz_comp \
< ERR174310_1.fastq > OUT ) &> ../../results/C_FQZCOMP_ERR174310_1
ls -la OUT > ../../results/BC_FQZCOMP_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MC_FQZCOMP_ERR174310_1";
ProgMemoryStart "fqz_comp" &
MEMPID=$!
rm -f OUT.out;
(time ./fqz_comp \
-d < OUT > OUT.out ) &> ../../results/D_FQZCOMP_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MD_FQZCOMP_ERR174310_1";
cmp ERR174310_1.fastq OUT.out &> ../../results/V_FQZCOMP_ERR174310_1
mv ERR174310_1.fastq ../../datasets/
#
# ERR174310_2
mv ../../datasets/ERR174310_2.fastq .
ProgMemoryStart "fqz_comp" &
MEMPID=$!
rm -f OUT
(time ./fqz_comp \
< ERR174310_2.fastq > OUT ) &> ../../results/C_FQZCOMP_ERR174310_2
ls -la OUT > ../../results/BC_FQZCOMP_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MC_FQZCOMP_ERR174310_2";
ProgMemoryStart "fqz_comp" &
MEMPID=$!
rm -f OUT.out;
(time ./fqz_comp \
-d < OUT > OUT.out ) &> ../../results/D_FQZCOMP_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MD_FQZCOMP_ERR174310_2";
cmp ERR174310_2.fastq OUT.out &> ../../results/V_FQZCOMP_ERR174310_2
mv ERR174310_2.fastq ../../datasets/
#
# ERR194146_1
mv ../../datasets/ERR194146_1.fastq .
ProgMemoryStart "fqz_comp" &
MEMPID=$!
rm -f OUT
(time ./fqz_comp \
< ERR194146_1.fastq > OUT ) &> ../../results/C_FQZCOMP_ERR194146_1
ls -la OUT > ../../results/BC_FQZCOMP_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MC_FQZCOMP_ERR194146_1";
ProgMemoryStart "fqz_comp" &
MEMPID=$!
rm -f OUT.out;
(time ./fqz_comp \
-d < OUT > OUT.out ) &> ../../results/D_FQZCOMP_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MD_FQZCOMP_ERR194146_1";
cmp ERR194146_1.fastq OUT.out &> ../../results/V_FQZCOMP_ERR194146_1
mv ERR194146_1.fastq ../../datasets/
#
# ERR194146_2
mv ../../datasets/ERR194146_2.fastq .
ProgMemoryStart "fqz_comp" &
MEMPID=$!
rm -f OUT
(time ./fqz_comp \
< ERR194146_2.fastq > OUT ) &> ../../results/C_FQZCOMP_ERR194146_2
ls -la OUT > ../../results/BC_FQZCOMP_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MC_FQZCOMP_ERR194146_2";
ProgMemoryStart "fqz_comp" &
MEMPID=$!
rm -f OUT.out;
(time ./fqz_comp \
-d < OUT > OUT.out ) &> ../../results/D_FQZCOMP_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MD_FQZCOMP_ERR194146_2";
cmp ERR194146_2.fastq OUT.out &> ../../results/V_FQZCOMP_ERR194146_2
mv ERR194146_2.fastq ../../datasets/
#
cd ../../
fi
###############################################################################
if [[ "$RUN_QUIP" -eq "1" ]]; then
mkdir -p results
cd progs/quip
# ERR174310_1
mv ../../datasets/ERR174310_1.fastq .
ProgMemoryStart "quip" &
MEMPID=$!
rm -f OUT.qp
(time ./quip -c \
ERR174310_1.fastq > OUT.qp ) &> ../../results/C_QUIP_ERR174310_1
ls -la OUT.qp > ../../results/BC_QUIP_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MC_QUIP_ERR174310_1";
ProgMemoryStart "quip" &
MEMPID=$!
rm -f OUT.fastq;
(time ./fqz_comp \
-d -c OUT.qp > OUT.fastq ) &> ../../results/D_QUIP_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MD_QUIP_ERR174310_1";
cmp ERR174310_1.fastq OUT.fastq &> ../../results/V_QUIP_ERR174310_1
mv ERR174310_1.fastq ../../datasets/
rm -f OUT.qp OUT.fastq
#
# ERR174310_2
mv ../../datasets/ERR174310_2.fastq .
ProgMemoryStart "quip" &
MEMPID=$!
rm -f OUT.qp
(time ./quip -c \
ERR174310_2.fastq > OUT.qp ) &> ../../results/C_QUIP_ERR174310_2
ls -la OUT.qp > ../../results/BC_QUIP_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MC_QUIP_ERR174310_2";
ProgMemoryStart "quip" &
MEMPID=$!
rm -f OUT.fastq;
(time ./fqz_comp \
-d -c OUT.qp > OUT.fastq ) &> ../../results/D_QUIP_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MD_QUIP_ERR174310_2";
cmp ERR174310_2.fastq OUT.fastq &> ../../results/V_QUIP_ERR174310_2
mv ERR174310_2.fastq ../../datasets/
rm -f OUT.qp OUT.fastq
#
# ERR194146_1
mv ../../datasets/ERR194146_1.fastq .
ProgMemoryStart "quip" &
MEMPID=$!
rm -f OUT.qp
(time ./quip -c \
ERR194146_1.fastq > OUT.qp ) &> ../../results/C_QUIP_ERR194146_1
ls -la OUT.qp > ../../results/BC_QUIP_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MC_QUIP_ERR194146_1";
ProgMemoryStart "quip" &
MEMPID=$!
rm -f OUT.fastq;
(time ./fqz_comp \
-d -c OUT.qp > OUT.fastq ) &> ../../results/D_QUIP_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MD_QUIP_ERR194146_1";
cmp ERR194146_1.fastq OUT.fastq &> ../../results/V_QUIP_ERR194146_1
mv ERR194146_1.fastq ../../datasets/
rm -f OUT.qp OUT.fastq
#
# ERR194146_2
mv ../../datasets/ERR194146_2.fastq .
ProgMemoryStart "quip" &
MEMPID=$!
rm -f OUT.qp
(time ./quip -c \
ERR194146_2.fastq > OUT.qp ) &> ../../results/C_QUIP_ERR194146_2
ls -la OUT.qp > ../../results/BC_QUIP_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MC_QUIP_ERR194146_2";
ProgMemoryStart "quip" &
MEMPID=$!
rm -f OUT.fastq;
(time ./fqz_comp \
-d -c OUT.qp > OUT.fastq ) &> ../../results/D_QUIP_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MD_QUIP_ERR194146_2";
cmp ERR194146_2.fastq OUT.fastq &> ../../results/V_QUIP_ERR194146_2
mv ERR194146_2.fastq ../../datasets/
rm -f OUT.qp OUT.fastq
#
cd ../../
fi
##############################################################################
if [[ "$RUN_SCALCE" -eq "1" ]]; then
mkdir -p results
cd progs/scalce
# ERR174310_1
mv ../../datasets/ERR174310_1.fastq .
ProgMemoryStart "scalce" &
MEMPID=$!
rm -f OUT*
(time ./scalce \
ERR174310_1.fastq -o OUT ) &> ../../results/C_SCALCE_ERR174310_1
ls -la OUT* | awk 'BEGIN{tot=0} {tot+=$5} END{print tot}' \
> ../../results/BC_SCALCE_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MC_SCALCE_ERR174310_1";
ProgMemoryStart "scalce" &
MEMPID=$!
rm -f TMP*;
(time ./scalce \
OUT_1.scalcen -d -o TMP ) &> ../../results/D_SCALCE_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MD_SCALCE_ERR174310_1";
cmp ERR174310_1.fastq TMP_1.fastq &> ../../results/V_SCALCE_ERR174310_1
mv ERR174310_1.fastq ../../datasets/
rm -f OUT* TMP*
#
# ERR174310_2
mv ../../datasets/ERR174310_2.fastq .
ProgMemoryStart "scalce" &
MEMPID=$!
rm -f OUT*
(time ./scalce \
ERR174310_2.fastq -o OUT ) &> ../../results/C_SCALCE_ERR174310_2
ls -la OUT* | awk 'BEGIN{tot=0} {tot+=$5} END{print tot}' \
> ../../results/BC_SCALCE_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MC_SCALCE_ERR174310_2";
ProgMemoryStart "scalce" &
MEMPID=$!
rm -f TMP*;
(time ./scalce \
OUT_1.scalcen -d -o TMP ) &> ../../results/D_SCALCE_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MD_SCALCE_ERR174310_2";
cmp ERR174310_2.fastq TMP_1.fastq &> ../../results/V_SCALCE_ERR174310_2
mv ERR174310_2.fastq ../../datasets/
rm -f OUT* TMP*
#
# ERR194146_1
mv ../../datasets/ERR194146_1.fastq .
ProgMemoryStart "scalce" &
MEMPID=$!
rm -f OUT*
(time ./scalce \
ERR194146_1.fastq -o OUT ) &> ../../results/C_SCALCE_ERR194146_1
ls -la OUT* | awk 'BEGIN{tot=0} {tot+=$5} END{print tot}' \
> ../../results/BC_SCALCE_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MC_SCALCE_ERR194146_1";
ProgMemoryStart "scalce" &
MEMPID=$!
rm -f TMP*;
(time ./scalce \
OUT_1.scalcen -d -o TMP ) &> ../../results/D_SCALCE_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MD_SCALCE_ERR194146_1";
cmp ERR194146_1.fastq TMP_1.fastq &> ../../results/V_SCALCE_ERR194146_1
mv ERR194146_1.fastq ../../datasets/
rm -f OUT* TMP*
#
# ERR194146_2
mv ../../datasets/ERR194146_2.fastq .
ProgMemoryStart "scalce" &
MEMPID=$!
rm -f OUT*
(time ./scalce \
ERR194146_2.fastq -o OUT ) &> ../../results/C_SCALCE_ERR194146_2
ls -la OUT* | awk 'BEGIN{tot=0} {tot+=$5} END{print tot}' \
> ../../results/BC_SCALCE_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MC_SCALCE_ERR194146_2";
ProgMemoryStart "scalce" &
MEMPID=$!
rm -f TMP*;
(time ./scalce \
OUT_1.scalcen -d -o TMP ) &> ../../results/D_SCALCE_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MD_SCALCE_ERR194146_2";
cmp ERR194146_2.fastq TMP_1.fastq &> ../../results/V_SCALCE_ERR194146_2
mv ERR194146_2.fastq ../../datasets/
rm -f OUT* TMP*
#
cd ../../
fi
##############################################################################
if [[ "$RUN_LWFQZIP" -eq "1" ]]; then
cd LWFQZip-v1.02/
./LWFQZip -c -i IN > OUT
./LWFQZip -d -i OUT > IN.2
fi
##############################################################################
#
##############################################################################
################################# SAM / BAM ##################################
##############################################################################
###
### REFERENCE: human.fa
###
### FILES TO COMPRESS:
###   [+] NA12877_S1.bam (73 GB)
###   [+] NA12878_S1.bam (106 GB)
###   [+] NA12882_S1.bam (87 GB)
###   [+] ERR317482.bam (6.1 GB)
###
##############################################################################
if [[ "$RUN_NGC" -eq "1" ]]; then
# http://www.cibiv.at/~niko/ngc/download.html
mkdir -p results
cd progs/ngc/
mv ../../datasets/humanDZ.fna .
# NA12877_S1.bam
mv ../../datasets/NA12877_S1.bam .
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f OUT.dz
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar compress -i NA12877_S1.bam \
-o OUT.dz -r humanDZ.fna ) &> ../../results/C_NGC_NA12877_S1
ls -la OUT.dz > ../../results/BC_NGC_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MC_NGC_NA12877_S1";
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f NA12877_S1.dec
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar decompress -i OUT.dz \
-o NA12877_S1.dec -r humanDZ.fna ) &> ../../results/D_NGC_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MD_NGC_NA12877_S1";
cmp NA12877_S1.dec NA12877_S1.bam &> ../../results/V_NGC_NA12877_S1
mv NA12877_S1.bam ../../datasets/
# NA12878_S1.bam
mv ../../datasets/NA12878_S1.bam .
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f OUT.dz
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar compress -i NA12878_S1.bam \
-o OUT.dz -r humanDZ.fna ) &> ../../results/C_NGC_NA12878_S1
ls -la OUT.dz > ../../results/BC_NGC_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MC_NGC_NA12878_S1";
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f NA12878_S1.dec
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar decompress -i OUT.dz \
-o NA12878_S1.dec -r humanDZ.fna ) &> ../../results/D_NGC_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MD_NGC_NA12878_S1";
cmp NA12878_S1.dec NA12878_S1.bam &> ../../results/V_NGC_NA12878_S1
mv NA12878_S1.bam ../../datasets/
# NA12882_S1
mv ../../datasets/NA12882_S1.bam .
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f OUT.dz
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar compress -i NA12882_S1.bam \
-o OUT.dz -r humanDZ.fna ) &> ../../results/C_NGC_NA12882_S1
ls -la OUT.dz > ../../results/BC_NGC_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MC_NGC_NA12882_S1";
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f NA12882_S1.dec
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar decompress -i OUT.dz \
-o NA12882_S1.dec -r humanDZ.fna ) &> ../../results/D_NGC_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MD_NGC_NA12882_S1";
cmp NA12882_S1.dec NA12882_S1.bam &> ../../results/V_NGC_NA12882_S1
mv NA12882_S1.bam ../../datasets/
# ERR317482.bam
mv ../../datasets/ERR317482.bam .
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f OUT.dz
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar compress -i ERR317482.bam \
-o OUT.dz -r humanDZ.fna ) &> ../../results/C_NGC_ERR317482
ls -la OUT.dz > ../../results/BC_NGC_ERR317482
ProgMemoryStop $MEMPID "../../results/MC_NGC_ERR317482";
ProgMemoryStart "ngc" &
MEMPID=$!
rm -f ERR317482.dec
(time java -jar -Xmx8G ngc-core-0.0.1-standalone.jar decompress -i OUT.dz \
-o ERR317482.dec -r humanDZ.fna ) &> ../../results/D_NGC_ERR317482
ProgMemoryStop $MEMPID "../../results/MD_NGC_ERR317482";
cmp ERR317482.dec ERR317482.bam &> ../../results/V_NGC_ERR317482
mv ERR317482.bam ../../datasets/
mv human.fna ../../datasets/
cd ../../
fi
##############################################################################
if [[ "$RUN_DEEZ" -eq "1" ]]; then
mkdir -p results
cd progs/deez/
mv ../../datasets/humanDZ.fna .
# NA12877_S1.bam
mv ../../datasets/NA12877_S1.bam .
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f OUT.dz
(time ./deez --force -r humanDZ.fna NA12877_S1.bam \
-o OUT.dz ) &> ../../results/C_DEEZ_NA12877_S1
ls -la OUT.dz > ../../results/BC_DEEZ_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MC_DEEZ_NA12877_S1";
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f NA12877_S1.dec
(time ./deez --force -r humanDZ.fna OUT.dz \
-o NA12877_S1.dec ) &> ../../results/D_DEEZ_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MD_DEEZ_NA12877_S1";
cmp NA12877_S1.dec NA12877_S1.bam &> ../../results/V_DEEZ_NA12877_S1
mv NA12877_S1.bam ../../datasets/
# NA12878_S1.bam
mv ../../datasets/NA12878_S1.bam .
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f OUT.dz
(time ./deez --force -r humanDZ.fna NA12878_S1.bam \
-o OUT.dz ) &> ../../results/C_DEEZ_NA12878_S1
ls -la OUT.dz > ../../results/BC_DEEZ_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MC_DEEZ_NA12878_S1";
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f NA12878_S1.dec
(time ./deez --force -r humanDZ.fna OUT.dz \
-o NA12878_S1.dec ) &> ../../results/D_DEEZ_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MD_DEEZ_NA12878_S1";
cmp NA12878_S1.dec NA12878_S1.bam &> ../../results/V_DEEZ_NA12878_S1
mv NA12878_S1.bam ../../datasets/
# NA12882_S1
mv ../../datasets/NA12882_S1.bam .
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f OUT.dz
(time ./deez --force -r humanDZ.fna NA12882_S1.bam \
-o OUT.dz ) &> ../../results/C_DEEZ_NA12882_S1
ls -la OUT.dz > ../../results/BC_DEEZ_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MC_DEEZ_NA12882_S1";
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f NA12882_S1.dec
(time ./deez --force -r humanDZ.fna OUT.dz \
-o NA12882_S1.dec ) &> ../../results/D_DEEZ_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MD_DEEZ_NA12882_S1";
cmp NA12882_S1.dec NA12882_S1.bam &> ../../results/V_DEEZ_NA12882_S1
mv NA12882_S1.bam ../../datasets/
# ERR317482.bam
mv ../../datasets/ERR317482.bam .
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f OUT.dz
(time ./deez --force -r humanDZ.fna ERR317482.bam \
-o OUT.dz ) &> ../../results/C_DEEZ_ERR317482
ls -la OUT.dz > ../../results/BC_DEEZ_ERR317482
ProgMemoryStop $MEMPID "../../results/MC_DEEZ_ERR317482";
ProgMemoryStart "./deez" &
MEMPID=$!
rm -f ERR317482.dec
(time ./deez --force -r humanDZ.fna OUT.dz \
-o ERR317482.dec ) &> ../../results/D_DEEZ_ERR317482
ProgMemoryStop $MEMPID "../../results/MD_DEEZ_ERR317482";
cmp ERR317482.dec ERR317482.bam &> ../../results/V_DEEZ_ERR317482
mv ERR317482.bam ../../datasets/
mv human.fna ../../datasets/
cd ../../
fi
##############################################################################
if [[ "$RUN_SAMCOMP" -eq "1" ]]; then
mkdir -p results
cd progs/samcomp/
mv ../../datasets/humanDZ.fna .
# NA12877_S1.bam
mv ../../datasets/NA12877_S1.bam .
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f OUT.dz
(time ./sam_comp2 -r humanDZ.fa \
-f bam < NA12877_S1.bam > OUT.dz ) &> ../../results/C_SAMCOMP_NA12877_S1
ls -la OUT.dz > ../../results/BC_SAMCOMP_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MC_SAMCOMP_NA12877_S1";
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f NA12877_S1.dec
(time ./sam_comp2 -r humanDZ.fna \ 
-f bam -d < OUT.dz > NA12877_S1.dec ) &> ../../results/D_SAMCOMP_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MD_SAMCOMP_NA12877_S1";
cmp NA12877_S1.dec NA12877_S1.bam &> ../../results/V_SAMCOMP_NA12877_S1
mv NA12877_S1.bam ../../datasets/
# NA12878_S1.bam
mv ../../datasets/NA12878_S1.bam .
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f OUT.dz
(time ./sam_comp2 -r humanDZ.fa \
-f bam < NA12878_S1.bam > OUT.dz ) &> ../../results/C_SAMCOMP_NA12878_S1
ls -la OUT.dz > ../../results/BC_SAMCOMP_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MC_SAMCOMP_NA12878_S1";
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f NA12878_S1.dec
(time ./sam_comp2 -r humanDZ.fna \ 
-f bam -d < OUT.dz > NA12878_S1.dec ) &> ../../results/D_SAMCOMP_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MD_SAMCOMP_NA12878_S1";
cmp NA12878_S1.dec NA12878_S1.bam &> ../../results/V_SAMCOMP_NA12878_S1
mv NA12878_S1.bam ../../datasets/
# NA12882_S1
mv ../../datasets/NA12882_S1.bam .
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f OUT.dz
(time ./sam_comp2 -r humanDZ.fa \
-f bam < NA12882_S1.bam > OUT.dz ) &> ../../results/C_SAMCOMP_NA12882_S1
ls -la OUT.dz > ../../results/BC_SAMCOMP_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MC_SAMCOMP_NA12882_S1";
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f NA12882_S1.dec
(time ./sam_comp2 -r humanDZ.fna \ 
-f bam -d < OUT.dz > NA12882_S1.dec ) &> ../../results/D_SAMCOMP_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MD_SAMCOMP_NA12882_S1";
cmp NA12882_S1.dec NA12882_S1.bam &> ../../results/V_SAMCOMP_NA12882_S1
mv NA12882_S1.bam ../../datasets/
# ERR317482.bam
mv ../../datasets/ERR317482.bam .
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f OUT.dz
(time ./sam_comp2 -r humanDZ.fa \
-f bam < ERR317482.bam > OUT.dz ) &> ../../results/C_SAMCOMP_ERR317482
ls -la OUT.dz > ../../results/BC_SAMCOMP_ERR317482
ProgMemoryStop $MEMPID "../../results/MC_SAMCOMP_ERR317482";
ProgMemoryStart "./sam_comp2" &
MEMPID=$!
rm -f ERR317482.dec
(time ./sam_comp2 -r humanDZ.fna \ 
-f bam -d < OUT.dz > ERR317482.dec ) &> ../../results/D_SAMCOMP_ERR317482
ProgMemoryStop $MEMPID "../../results/MD_SAMCOMP_ERR317482";
cmp ERR317482.dec ERR317482.bam &> ../../results/V_SAMCOMP_ERR317482
mv ERR317482.bam ../../datasets/
mv human.fna ../../datasets/
cd ../../
fi
##############################################################################

