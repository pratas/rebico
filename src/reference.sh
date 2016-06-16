RUN_IDOCOMP=1;
RUN_GREEN=1;
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
  ProgMemoryStop $MEMPID "../../results/MC_IDOCOMP_$1-$2";
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
  cmp tar/human2.fa out.fa &> ../../../results/V_IDOCOMP_$1-$2
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
# PARSE =======================================================================
echo "parsing ..."
echo ">X" > HEADER
#
zcat HS8.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HS8;
mv HS8 datasets/
zcat HSCHM8.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HSCHM8;
mv HSCHM8 datasets/
#
zcat HS11.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HS11;
mv HS11 datasets/
zcat HSCHM11.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HSCHM11;
mv HSCHM11 datasets/
#
zcat HS16.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HS16;
mv HS16 datasets/
zcat HSK16.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > HSK16;
mv HSK16 datasets/
#
zcat PT11.fa.gz | grep -v ">" | tr -d -c "ACGT" > XTMP
cat HEADER XTMP > PT11;
mv PT11 datasets/
echo "done!";
#
# RUN =========================================================================
if [[ "$RUN_IDOCOMP" -eq "1" ]]; then
echo "Running iDoComp";
mkdir -p results
cd progs/idocomp

# reference: HSCHM8, target HS8
RunIDoComp "HS8" "HSCHM8"

# 
cd ../../
echo "Done!";
fi
#==============================================================================
if [[ "$RUN_GREEN" -eq "1" ]]; then
mkdir -p results
cd progs/green

cd ../../
fi
#==============================================================================
###############################################################################
############################## BUILD TABLE ####################################
###############################################################################
printf "Method\tC_bytes\tC_Time\tC_mem\tD_Time\tD_mem\tcmp?\n";
REF="HSCHM8";
TAR="HS8";
BC_IDOCOMP_1=`cat results/BC_IDOCOMP_$TAR-$REF | awk '{ print $5; }'`;
C_IDOCOMP_1=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MC_IDOCOMP_1=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_1=`cat results/D_IDOCOMP_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MD_IDOCOMP_1=`cat results/MD_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_1=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_1 $C_IDOCOMP_1 $MC_IDOCOMP_1 $D_IDOCOMP_1 $MD_IDOCOMP_1 $V_IDOCOMP_1;
###############################################################################

