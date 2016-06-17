DOWNLOAD=1;
PARSE=1;
RUN_IDOCOMP=1;
RUN_GREEN=1;
RUN_GECO=1;
#
function RunGReEn {
  PARAM=" -v -i -k 16 -f 5 ";
  # 1 - TARGET
  # 2 - REFERENCE
  cp ../../datasets/$1 .
  cp ../../datasets/$2 .
  ProgMemoryStart "GReEnC" &
  MEMPID=$!
  rm -f $1.co
  (time ./GReEnC $PARAM -o $1.co $2 $1 ) &> ../../results/C_GREEN_$1-$2
  ls -la $1.co > ../../results/BC_GREEN_$1-$2
  ProgMemoryStop $MEMPID "../../results/MC_GREEN_$1-$2";
  ProgMemoryStart "GReEnD" &
  MEMPID=$!
  rm -f $1.de
  (time ./GReEnD -o $1.de $2 $1.co ) &> ../../results/D_GREEN_$1-$2
  ProgMemoryStop $MEMPID "../../results/MD_GREEN_$1-$2";
  cmp $1 $1.de &> ../../results/V_GREEN_$1-$2
  rm -f $2 $1;
  }
#
function RunGeCo {
  PARAM=" -v -l 14 ";
  # 1 - TARGET
  # 2 - REFERENCE
  cp ../../datasets/$1 .
  cp ../../datasets/$2 .
  ProgMemoryStart "GeCo" &
  MEMPID=$!
  rm -f $1.co
  (time ./GeCo $PARAM -r $2 $1 ) &> ../../results/C_GECO_REF_$1-$2
  ls -la $1.co > ../../results/BC_GECO_REF_$1-$2
  ProgMemoryStop $MEMPID "../../results/MC_GECO_REF_$1-$2";
  ProgMemoryStart "GeDe" &
  MEMPID=$!
  rm -f $1.de
  (time ./GeDe -v -r $2 $1.co ) &> ../../results/D_GECO_REF_$1-$2
  ProgMemoryStop $MEMPID "../../results/MD_GECO_REF_$1-$2";
  cmp $1 $1.de &> ../../results/V_GECO_REF_$1-$2
  rm -f $2 $1;
  }
#
function RunIDoComp {
  # 1 - TARGET
  # 2 - REFERENCE
  cp ../../datasets/$1 .
  cp ../../datasets/$2 .
  cd sais-lite-2.4.1/
  rm -fr sa ref tar
  mkdir sa ref tar;
  cp ../$2 ref/$2.fa
  ProgMemoryStart "generateSA.sh" & # THE MAXIMUM PEAK IS REACHED HERE
  MEMPID=$!
  (./generateSA.sh ref sa ) &> TIME_SA
  TIMEOFSA=`cat TIME_SA | grep "..." | awk '{ print $5;}'`
  ProgMemoryStop $MEMPID "../../../results/MC_IDOCOMP_$1-$2";
  mv ../$1 tar/$1.fa
  echo "ref/$2.fa tar/$1.fa sa/$2.sa" > f.txt;
  cp ../simulations/iDoComp.run .
  (./iDoComp.run c f.txt OUT ) &> ../../../results/C_IDOCOMP_$1-$2
  cat ../../../results/C_IDOCOMP_$1-$2 | grep "Compressed Size:" \
  | awk '{ print $3; }' > ../../../results/BC_IDOCOMP_$1-$2
  CTIME=`cat ../../../results/C_IDOCOMP_$1-$2 | grep "CPU T" | awk '{ print $4;}'`
  echo "$TIMEOFSA+$CTIME" | bc -l > ../../../results/CT_IDOCOMP_$1-$2
  echo "ref/$2.fa out.fa" > f.txt;
  (./iDoComp.run d f.txt OUT ) &> ../../../results/D_IDOCOMP_$1-$2
  DTIME=`cat ../../../results/D_IDOCOMP_$1-$2 | grep "CPU T" | awk '{ print $4;}'`
  echo "$TIMEOFSA+$DTIME" | bc -l > ../../../results/DT_IDOCOMP_$1-$2
  cmp tar/$1.fa out.fa &> ../../../results/V_IDOCOMP_$1-$2
  rm -f $2 $1;
  cd ..
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
#
################################################################################
# DOWNLOAD
if [[ "$DOWNLOAD" -eq "1" ]]; then
  rm -f GetOSativaV5.sh GetOSativaV7.sh RICE5.fa RICE7.fa
  https://raw.githubusercontent.com/pratas/goose/master/scripts/GetOSativaV5.sh
  https://raw.githubusercontent.com/pratas/goose/master/scripts/GetOSativaV7.sh
  . GetOSativaV5.sh
  . GetOSativaV7.sh
  cat OS5-* > datasets/RICE5.fa;
  cat OS7-* > datasets/RICE7.fa;  
  #
  rm -f HS11.fa.gz HS16.fa.gz HS8.fa.gz HSCHM11.fa.gz HSCHM8.fa.gz HSK16.fa.gz PT11.fa.gz
  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/Assembled_chromosomes/seq/hs_ref_GRCh38.p7_chr8.fa.gz -O HS8.fa.gz
  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/Assembled_chromosomes/seq/hs_alt_CHM1_1.1_chr8.fa.gz -O HSCHM8.fa.gz  
  #
  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/Assembled_chromosomes/seq/hs_ref_GRCh38.p7_chr11.fa.gz -O HS11.fa.gz
  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/Assembled_chromosomes/seq/hs_alt_CHM1_1.1_chr11.fa.gz -O HSCHM11.fa.gz
  #
  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Homo_sapiens/Assembled_chromosomes/seq/hs_ref_GRCh38.p7_chr16.fa.gz -O HS16.fa.gz
  wget ftp://ftp.kobic.re.kr/pub/KOBIC-KoreanGenome/fasta/chromosome_16.fa.gz -O HSK16.fa.gz
  #
  # HUMAN 11 ALREADY DOWNLOADED
  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Pan_troglodytes/Assembled_chromosomes/seq/ptr_ref_Pan_tro_3.0_chr11.fa.gz -O PT11.fa.gz
  #
fi
# PARSE =======================================================================
if [[ "$PARSE" -eq "1" ]]; then
  echo "parsing ..."
  echo ">X" > HEADER
  #
  zcat HS8.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
  cat HEADER XTMP > datasets/HS8;
  zcat HSCHM8.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
  cat HEADER XTMP > datasets/HSCHM8; 
  #
  zcat HS11.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
  cat HEADER XTMP > datasets/HS11;
  zcat HSCHM11.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
  cat HEADER XTMP > datasets/HSCHM11;
  #
  zcat HS16.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
  cat HEADER XTMP > datasets/HS16;
  zcat HSK16.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
  cat HEADER XTMP > datasets/HSK16;
  #
  zcat PT11.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
  cat HEADER XTMP > datasets/PT11;  
  #
  zcat datasets/RICE5.fa | grep -v ">" | tr -d -c "ACGT" > XTMP
  cat HEADER XTMP > datasets/RICE5.fa
  #
  zcat datasets/RICE7.fa | grep -v ">" | tr -d -c "ACGT" > XTMP
  cat HEADER XTMP > datasets/RICE7.fa
  echo "done!";
  fi
#
# RUN =========================================================================
if [[ "$RUN_IDOCOMP" -eq "1" ]]; then
  echo "Running iDoComp ...";
  mkdir -p results
  cd progs/idocomp
  # target $1, reference $2:
  RunIDoComp "HS8" "HSCHM8"
  RunIDoComp "HS11" "HSCHM11"
  RunIDoComp "HS11" "PT11"
  RunIDoComp "HSK16" "HS16"
  RunIDoComp "RICE5" "RICE7"
  # 
  cd ../../
  echo "Done!";
fi
#==============================================================================
if [[ "$RUN_GECO" -eq "1" ]]; then
  echo "Running GeCo ...";
  mkdir -p results
  cd progs/geco
  # target $1, reference $2:
  RunGeCo "HS8" "HSCHM8"
  RunGeCo "HS11" "HSCHM11"
  RunGeCo "HS11" "PT11"
  RunGeCo "HSK16" "HS16"
  RunGeCo "RICE5" "RICE7"
  # 
  cd ../../
  echo "Done!";
fi
#==============================================================================
if [[ "$RUN_GREEN" -eq "1" ]]; then
  echo "Running GReEn ...";
  mkdir -p results
  cd progs/green
  # target $1, reference $2:
  RunGReEn "HS8" "HSCHM8"
  RunGReEn "HS11" "HSCHM11"
  RunGReEn "HS11" "PT11"
  RunGReEn "HSK16" "HS16"
  RunGReEn "RICE5" "RICE7"
  # 
  cd ../../
  echo "Done!";
fi
#==============================================================================
###############################################################################
############################## BUILD TABLE ####################################
###############################################################################
printf "Method\tC_bytes\tC_Time\tC_mem\tD_Time\tD_mem\tcmp?\n";
TAR="HS8";
REF="HSCHM8";
BC_IDOCOMP_1=`cat results/BC_IDOCOMP_$TAR-$REF`;
C_IDOCOMP_1=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 1 | awk '{ print $3;}'`;
MC_IDOCOMP_1=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_1=`cat results/DT_IDOCOMP_$TAR-$REF`;
MD_IDOCOMP_1=`cat results/MC_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_1=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_1 $C_IDOCOMP_1 $MC_IDOCOMP_1 $D_IDOCOMP_1 $MD_IDOCOMP_1 $V_IDOCOMP_1;
TAR="HS11";
REF="HSCHM11";
BC_IDOCOMP_2=`cat results/BC_IDOCOMP_$TAR-$REF`;
C_IDOCOMP_2=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 1 | awk '{ print $3;}'`;
MC_IDOCOMP_2=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_2=`cat results/DT_IDOCOMP_$TAR-$REF`;
MD_IDOCOMP_2=`cat results/MC_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_2=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_2 $C_IDOCOMP_2 $MC_IDOCOMP_2 $D_IDOCOMP_2 $MD_IDOCOMP_2 $V_IDOCOMP_2;
TAR="HS11";
REF="PT11";
BC_IDOCOMP_3=`cat results/BC_IDOCOMP_$TAR-$REF`;
C_IDOCOMP_3=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 1 | awk '{ print $3;}'`;
MC_IDOCOMP_3=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_3=`cat results/DT_IDOCOMP_$TAR-$REF`;
MD_IDOCOMP_3=`cat results/MC_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_3=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_3 $C_IDOCOMP_3 $MC_IDOCOMP_3 $D_IDOCOMP_3 $MD_IDOCOMP_3 $V_IDOCOMP_3;
TAR="HSK16";
REF="HS16";
BC_IDOCOMP_4=`cat results/BC_IDOCOMP_$TAR-$REF`;
C_IDOCOMP_4=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 1 | awk '{ print $3;}'`;
MC_IDOCOMP_4=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_4=`cat results/DT_IDOCOMP_$TAR-$REF`;
MD_IDOCOMP_4=`cat results/MC_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_4=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_4 $C_IDOCOMP_4 $MC_IDOCOMP_4 $D_IDOCOMP_4 $MD_IDOCOMP_4 $V_IDOCOMP_4;
TAR="RICE5";
REF="RICE7";
BC_IDOCOMP_5=`cat results/BC_IDOCOMP_$TAR-$REF`;
C_IDOCOMP_5=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 1 | awk '{ print $3;}'`;
MC_IDOCOMP_5=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_5=`cat results/DT_IDOCOMP_$TAR-$REF`;
MD_IDOCOMP_5=`cat results/MC_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_5=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_5 $C_IDOCOMP_5 $MC_IDOCOMP_5 $D_IDOCOMP_5 $MD_IDOCOMP_5 $V_IDOCOMP_5;
###############################################################################

