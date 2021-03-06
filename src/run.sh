#!/bin/bash
###############################################################################
# SEQ : NORMAL
RUN_DNACOMPACT=0;
RUN_GECO=0;
RUN_COGI=0;
RUN_GZIP_NORMAL=1;
RUN_LZMA_NORMAL=1;
###############################################################################
# FASTA
RUN_MFCOMPRESS=0;
RUN_DELIMINATE=0;
RUN_LEON=0;
RUN_GZIP_FASTA=1;
RUN_LZMA_FASTA=1;
###############################################################################
# FASTQ
RUN_FQZCOMP=0;
RUN_QUIP=0;
RUN_SCALCE=0;
RUN_ORCOM=0;
RUN_DSRC=0;
RUN_FQC=0;
RUN_LWFQZIP=0;
RUN_GZIP_FASTQ=1;
RUN_LZMA_FASTQ=1;
###############################################################################
# SAM/BAM
RUN_SAMCOMP=0;
RUN_DEEZ=0;
RUN_NGC=0;
RUN_QUIP_SAM=0;
RUN_GZIP_BAM=1;
RUN_LZMA_BAM=1;
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
    echo "WARNING: File $file does not exist!";
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
# GZIP ========================================================================
function compGzip {
  ProgMemoryStart "gzip" &
  MEMPID=$!
  (time gzip $1 ) &> ../../results/C_GZIP_$2
  ls -la $1.gz > ../../results/BC_GZIP_$2
  ProgMemoryStop $MEMPID "../../results/MC_GZIP_$2";
  ProgMemoryStart "gunzip" &
  MEMPID=$!
  (time gunzip $1.gz ) &> ../../results/D_GZIP_$2
  ProgMemoryStop $MEMPID "../../results/MD_GZIP_$2";
  }
# LZMA ========================================================================
function compLzma {
  ProgMemoryStart "lzma" &
  MEMPID=$!
  (time lzma $1 ) &> ../../results/C_LZMA_$2
  ls -la $1.lzma > ../../results/BC_LZMA_$2
  ProgMemoryStop $MEMPID "../../results/MC_LZMA_$2";
  ProgMemoryStart "lzma" &
  MEMPID=$!
  (time lzma -d $1.lzma ) &> ../../results/D_LZMA_$2
  ProgMemoryStop $MEMPID "../../results/MD_LZMA_$2";
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
if [[ "$RUN_GZIP_NORMAL" -eq "1" ]]; then
mkdir -p results
mkdir -p progs/gzip
cd progs/gzip
cat ../../datasets/human.fna  | grep -v ">" | tr -d -c "ACGT" > human.seq
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq
# 
compGzip "human.seq" "HUMAN"
compGzip "chimpanze.seq" "CHIMPANZE"
compGzip "rice5.seq" "RICE"
#
rm -f human.seq chimpanze.seq rice5.seq
cd ../../
fi
###############################################################################
if [[ "$RUN_LZMA_NORMAL" -eq "1" ]]; then
mkdir -p results
mkdir -p progs/lzma
cd progs/lzma
cat ../../datasets/human.fna  | grep -v ">" | tr -d -c "ACGT" > human.seq
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq
# 
compLzma "human.seq" "HUMAN"
compLzma "chimpanze.seq" "CHIMPANZE"
compLzma "rice5.seq" "RICE"
#
rm -f human.seq chimpanze.seq rice5.seq
cd ../../
fi
###############################################################################
if [[ "$RUN_COGI" -eq "1" ]]; then
mkdir -p results
cd progs/cogi
cat ../../datasets/human.fna  | grep -v ">" | tr -d -c "ACGT" > human.seq
cat ../../datasets/chimpanze.fna | grep -v ">" | tr -d -c "ACGT" > chimpanze.seq
cat ../../datasets/rice5.fna | grep -v ">" | tr -d -c "ACGT" > rice5.seq

# DOIT : PROBLEMS SETTING REFERENCE-FREE COMPRESSION PARAMETERS
# Authors have been emailed for instructions
# NO REPLY UNTIL TODAY (8 June, 2016)
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
if [[ "$RUN_GZIP_FASTA" -eq "1" ]]; then
mkdir -p results
mkdir -p progs/gzip
cd progs/gzip
mv ../../datasets/human.fna .
mv ../../datasets/chimpanze.fna .
mv ../../datasets/rice5.fna .
mv ../../datasets/camera.fa .
# 
compGzip "human.fna" "HUMAN_FASTA"
compGzip "chimpanze.fna" "CHIMPANZE_FASTA"
compGzip "rice5.fna" "RICE_FASTA"
compGzip "camera.fa" "CAMERA_FASTA"
#
mv camera.fa ../../datasets/
mv rice5.fna ../../datasets/
mv chimpanze.fna ../../datasets/
mv human.fna ../../datasets/
cd ../../
fi
###############################################################################
if [[ "$RUN_LZMA_FASTA" -eq "1" ]]; then
mkdir -p results
mkdir -p progs/lzma
cd progs/lzma
mv ../../datasets/human.fna .
mv ../../datasets/chimpanze.fna .
mv ../../datasets/rice5.fna .
mv ../../datasets/camera.fa .
# 
compLzma "human.fna" "HUMAN_FASTA"
compLzma "chimpanze.fna" "CHIMPANZE_FASTA"
compLzma "rice5.fna" "RICE_FASTA"
compLzma "camera.fa" "CAMERA_FASTA"
#
mv camera.fa ../../datasets/
mv rice5.fna ../../datasets/
mv chimpanze.fna ../../datasets/
mv human.fna ../../datasets/
cd ../../
fi
###############################################################################
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
if [[ "$RUN_GZIP_FASTQ" -eq "1" ]]; then
mkdir -p results
mkdir -p progs/gzip
cd progs/gzip
mv ../../datasets/ERR174310_1.fastq .
mv ../../datasets/ERR174310_2.fastq .
mv ../../datasets/ERR194146_1.fastq .
mv ../../datasets/ERR194146_2.fastq .
# 
compGzip "ERR174310_1.fastq" "ERR174310_1_FASTQ"
compGzip "ERR174310_2.fastq" "ERR174310_2_FASTQ"
compGzip "ERR194146_1.fastq" "ERR194146_1_FASTQ"
compGzip "ERR194146_2.fastq" "ERR194146_2_FASTQ"
#
mv ERR174310_1.fastq ../../datasets/
mv ERR174310_2.fastq ../../datasets/
mv ERR194146_1.fastq ../../datasets/
mv ERR194146_2.fastq ../../datasets/
cd ../../
fi
###############################################################################
if [[ "$RUN_LZMA_FASTQ" -eq "1" ]]; then
mkdir -p results
mkdir -p progs/lzma
cd progs/lzma
mv ../../datasets/ERR174310_1.fastq .
mv ../../datasets/ERR174310_2.fastq .
mv ../../datasets/ERR194146_1.fastq .
mv ../../datasets/ERR194146_2.fastq .
# 
compLzma "ERR174310_1.fastq" "ERR174310_1_FASTQ"
compLzma "ERR174310_2.fastq" "ERR174310_2_FASTQ"
compLzma "ERR194146_1.fastq" "ERR194146_1_FASTQ"
compLzma "ERR194146_2.fastq" "ERR194146_2_FASTQ"
#
mv ERR174310_1.fastq ../../datasets/
mv ERR174310_2.fastq ../../datasets/
mv ERR194146_1.fastq ../../datasets/
mv ERR194146_2.fastq ../../datasets/
cd ../../
fi
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
mkdir -p results
cd progs/fqc
# ERR174310_1
mv ../../datasets/ERR174310_1.fastq .
ProgMemoryStart "fqc" &
MEMPID=$!
rm -f OUT.fqc
(time ./fqc -c -i ERR174310_1.fastq \
-o OUT.fqc) &> ../../results/C_FQC_ERR174310_1
ls -la OUT.fqc > ../../results/BC_FQC_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MC_FQC_ERR174310_1";
ProgMemoryStart "fqc" &
MEMPID=$!
rm -f OUT.out;
(time ./fqc -d \
-i out.fqc -o out.out ) &> ../../results/D_FQC_ERR174310_1
ProgMemoryStop $MEMPID "../../results/MD_FQC_ERR174310_1";
cmp ERR174310_1.fastq OUT.out &> ../../results/V_FQC_ERR174310_1
mv ERR174310_1.fastq ../../datasets/
#
# ERR174310_2
mv ../../datasets/ERR174310_2.fastq .
ProgMemoryStart "fqc" &
MEMPID=$!
rm -f OUT.fqc
(time ./fqc -c -i ERR174310_2.fastq \
-o OUT.fqc) &> ../../results/C_FQC_ERR174310_2
ls -la OUT.fqc > ../../results/BC_FQC_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MC_FQC_ERR174310_2";
ProgMemoryStart "fqc" &
MEMPID=$!
rm -f OUT.out;
(time ./fqc -d \
-i out.fqc -o out.out ) &> ../../results/D_FQC_ERR174310_2
ProgMemoryStop $MEMPID "../../results/MD_FQC_ERR174310_2";
cmp ERR174310_2.fastq OUT.out &> ../../results/V_FQC_ERR174310_2
mv ERR174310_2.fastq ../../datasets/
#
# ERR194146_1
mv ../../datasets/ERR194146_1.fastq .
ProgMemoryStart "fqc" &
MEMPID=$!
rm -f OUT.fqc
(time ./fqc -c -i ERR194146_1.fastq \
-o OUT.fqc ) &> ../../results/C_FQC_ERR194146_1
ls -la OUT.fqc > ../../results/BC_FQC_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MC_FQC_ERR194146_1";
ProgMemoryStart "fqc" &
MEMPID=$!
rm -f OUT.out;
(time ./fqc -d \
-i out.fqc -o out.out ) &> ../../results/D_FQC_ERR194146_1
ProgMemoryStop $MEMPID "../../results/MD_FQC_ERR194146_1";
cmp ERR194146_1.fastq OUT.out &> ../../results/V_FQC_ERR194146_1
mv ERR194146_1.fastq ../../datasets/
#
# ERR194146_2
mv ../../datasets/ERR194146_2.fastq .
ProgMemoryStart "fqc" &
MEMPID=$!
rm -f OUT.fqc
(time ./fqc -c -i ERR194146_2.fastq \
-o OUT.fqc ) &> ../../results/C_FQC_ERR194146_2
ls -la OUT.fqc > ../../results/BC_FQC_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MC_FQC_ERR194146_2";
ProgMemoryStart "fqc" &
MEMPID=$!
rm -f OUT.out;
(time ./fqc -d 
-i out.fqc -o out.out ) &> ../../results/D_FQC_ERR194146_2
ProgMemoryStop $MEMPID "../../results/MD_FQC_ERR194146_2";
cmp ERR194146_2.fastq OUT.out &> ../../results/V_FQC_ERR194146_2
mv ERR194146_2.fastq ../../datasets/
#
cd ../../
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
(time ./quip \
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
(time ./quip \
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
(time ./quip \
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
(time ./quip \
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
# FIXME: GOT SOME ERROR... PERHAPS IN DECOMPRESSION. TODO: DEBUG
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
# XXX: ONLY REFERENCE-BASED COMPRESSION
mkdir -p results
cd progs/lwfqzip
./LWFQZip -c -i ERR174310_2.fastq -r human.fa
# XXX: Segmentation fault (core dumped)
./LWFQZip -d -i ERR174310_2.fastq.lw -r human.fa
cd ../../
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
if [[ "$RUN_GZIP_BAM" -eq "1" ]]; then
mkdir -p results
mkdir -p progs/gzip
cd progs/gzip
mv ../../datasets/NA12877_S1.bam .
mv ../../datasets/NA12878_S1.bam .
mv ../../datasets/NA12882_S1.bam .
mv ../../datasets/ERR317482.bam .
# 
compGzip "NA12877_S1.bam" "NA12877_S1_BAM"
compGzip "NA12878_S1.bam" "NA12878_S1_BAM"
compGzip "NA12882_S1.bam" "NA12882_S1_BAM"
compGzip "ERR317482.bam" "ERR317482_BAM"
#
mv NA12877_S1.bam ../../datasets/
mv NA12878_S1.bam ../../datasets/
mv NA12882_S1.bam ../../datasets/
mv ERR317482.bam ../../datasets/
cd ../../
fi
###############################################################################
if [[ "$RUN_LZMA_BAM" -eq "1" ]]; then
mkdir -p results
mkdir -p progs/lzma
cd progs/lzma
mv ../../datasets/NA12877_S1.bam .
mv ../../datasets/NA12878_S1.bam .
mv ../../datasets/NA12882_S1.bam .
mv ../../datasets/ERR317482.bam .
# 
compLzma "NA12877_S1.bam" "NA12877_S1_BAM"
compLzma "NA12878_S1.bam" "NA12878_S1_BAM"
compLzma "NA12882_S1.bam" "NA12882_S1_BAM"
compLzma "ERR317482.bam" "ERR317482_BAM"
#
mv NA12877_S1.bam ../../datasets/
mv NA12878_S1.bam ../../datasets/
mv NA12882_S1.bam ../../datasets/
mv ERR317482.bam ../../datasets/
cd ../../
fi
###############################################################################
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
(time ./sam_comp2 -r humanDZ.fna \
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
(time ./sam_comp2 -r humanDZ.fna \
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
(time ./sam_comp2 -r humanDZ.fna \
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
(time ./sam_comp2 -r humanDZ.fna \
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
#
##############################################################################
if [[ "$RUN_QUIP_SAM" -eq "1" ]]; then
mkdir -p results
cd progs/quip/
cp ../../datasets/humanDZ.fna humanDZ.fna
# NA12877_S1.bam
mv ../../datasets/NA12877_S1.bam .
ProgMemoryStart "./quip" &
MEMPID=$!
rm -f OUT.qp
(time ./quip -r humanDZ.fna \
-c NA12877_S1.bam > OUT.qp ) &> ../../results/C_QUIP_SAM_NA12877_S1
ls -la OUT.qp > ../../results/BC_QUIP_SAM_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MC_QUIP_SAM_NA12877_S1";
ProgMemoryStart "./quip" &
MEMPID=$!
rm -f NA12877_S1.dec
(time ./quip -r humanDZ.fna \ 
-d -c OUT.qp > NA12877_S1.dec ) &> ../../results/D_QUIP_SAM_NA12877_S1
ProgMemoryStop $MEMPID "../../results/MD_QUIP_SAM_NA12877_S1";
cmp NA12877_S1.dec NA12877_S1.bam &> ../../results/V_QUIP_SAM_NA12877_S1
mv NA12877_S1.bam ../../datasets/
# NA12878_S1.bam
mv ../../datasets/NA12878_S1.bam .
ProgMemoryStart "./quip" &
MEMPID=$!
rm -f OUT.qp
(time ./quip -r humanDZ.fna \
-c NA12878_S1.bam > OUT.qp ) &> ../../results/C_QUIP_SAM_NA12878_S1
ls -la OUT.qp > ../../results/BC_QUIP_SAM_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MC_QUIP_SAM_NA12878_S1";
ProgMemoryStart "./quip" &
MEMPID=$!
rm -f NA12878_S1.dec
(time ./quip -r humanDZ.fna \ 
-d -c OUT.qp > NA12878_S1.dec ) &> ../../results/D_QUIP_SAM_NA12878_S1
ProgMemoryStop $MEMPID "../../results/MD_QUIP_SAM_NA12878_S1";
cmp NA12878_S1.dec NA12878_S1.bam &> ../../results/V_QUIP_SAM_NA12878_S1
mv NA12878_S1.bam ../../datasets/
# NA12882_S1
mv ../../datasets/NA12882_S1.bam .
ProgMemoryStart "./quip" &
MEMPID=$!
rm -f OUT.qp
(time ./quip -r humanDZ.fna \
-c NA12882_S1.bam > OUT.qp ) &> ../../results/C_QUIP_SAM_NA12882_S1
ls -la OUT.qp > ../../results/BC_QUIP_SAM_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MC_QUIP_SAM_NA12882_S1";
ProgMemoryStart "./quip" &
MEMPID=$!
rm -f NA12882_S1.dec
(time ./quip -r humanDZ.fna \ 
-d -c OUT.qp > NA12882_S1.dec ) &> ../../results/D_QUIP_SAM_NA12882_S1
ProgMemoryStop $MEMPID "../../results/MD_QUIP_SAM_NA12882_S1";
cmp NA12882_S1.dec NA12882_S1.bam &> ../../results/V_QUIP_SAM_NA12882_S1
mv NA12882_S1.bam ../../datasets/
# ERR317482.bam
mv ../../datasets/ERR317482.bam .
ProgMemoryStart "./quip" &
MEMPID=$!
rm -f OUT.qp
(time ./quip -r humanDZ.fna \
-c ERR317482.bam > OUT.qp ) &> ../../results/C_QUIP_SAM_ERR317482
ls -la OUT.qp > ../../results/BC_QUIP_SAM_ERR317482
ProgMemoryStop $MEMPID "../../results/MC_QUIP_SAM_ERR317482";
ProgMemoryStart "./quip" &
MEMPID=$!
rm -f ERR317482.dec
(time ./quip -r humanDZ.fna \ 
-d -c OUT.qp > ERR317482.dec ) &> ../../results/D_QUIP_SAM_ERR317482
ProgMemoryStop $MEMPID "../../results/MD_QUIP_SAM_ERR317482";
cmp ERR317482.dec ERR317482.bam &> ../../results/V_QUIP_SAM_ERR317482
mv ERR317482.bam ../../datasets/
rm -f humanDZ.fna
cd ../../
fi
#
##############################################################################

