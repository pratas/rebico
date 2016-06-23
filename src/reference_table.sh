###############################################################################
############################## BUILD TABLE ####################################
###############################################################################
printf "Method\tC_bytes\tC_Time\tC_mem\tD_Time\tD_mem\tcmp?\n";
#
TAR="HS8";
REF="HSCHM8";
#
BC_IDOCOMP_1=`cat results/BC_IDOCOMP_$TAR-$REF`;
C_IDOCOMP_1=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 2 | head -n 1 | awk '{print $4;}'`;
MC_IDOCOMP_1=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_1=`cat results/D_IDOCOMP_$TAR-$REF | awk '{ print $4;}'`;
MD_IDOCOMP_1=`cat results/MC_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_1=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
#
BC_GREEN_1=`cat results/BC_GREEN_$TAR-$REF | awk '{print $5;}'`;
C_GREEN_1=`cat results/C_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MC_GREEN_1=`cat results/MC_GREEN_$TAR-$REF`;
D_GREEN_1=`cat results/D_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MD_GREEN_1=`cat results/MC_GREEN_$TAR-$REF`;
V_GREEN_1=`cat results/V_GREEN_$TAR-$REF | wc -l`;
#
BC_GECO_REF_1=`cat results/BC_GECO_REF_$TAR-$REF | awk '{print $5;}'`;
C_GECO_REF_1=`cat results/C_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MC_GECO_REF_1=`cat results/MC_GECO_REF_$TAR-$REF`;
D_GECO_REF_1=`cat results/D_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MD_GECO_REF_1=`cat results/MC_GECO_REF_$TAR-$REF`;
V_GECO_REF_1=`cat results/V_GECO_REF_$TAR-$REF | wc -l`;
#
<<<<<<< HEAD
BC_GDC_1=`cat results/BC_GDC_$TAR-$REF | awk '{print $5;}'`;
C_GDC_1=`cat results/C_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MC_GDC_1=`cat results/MC_GDC_$TAR-$REF`;
D_GDC_1=`cat results/D_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MD_GDC_1=`cat results/MC_GDC_$TAR-$REF`;
V_GDC_1=`cat results/V_GDC_$TAR-$REF | wc -l`;
#
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_1 $C_IDOCOMP_1 $MC_IDOCOMP_1 $D_IDOCOMP_1 $MD_IDOCOMP_1 $V_IDOCOMP_1;
printf "GReEn\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GREEN_1 $C_GREEN_1 $MC_GREEN_1 $D_GREEN_1 $MD_GREEN_1 $V_GREEN_1;
printf "GeCo\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GECO_REF_1 $C_GECO_REF_1 $MC_GECO_REF_1 $D_GECO_REF_1 $MD_GECO_REF_1 $V_GECO_REF_1;
<<<<<<< HEAD
printf "Gdc2\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GDC_1 $C_GDC_1 $MC_GDC_1 $D_GDC_1 $MD_GDC_1 $V_GDC_1;
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
###############################################################################
###############################################################################
#
TAR="HS11";
REF="HSCHM11";
#
BC_IDOCOMP_2=`cat results/BC_IDOCOMP_$TAR-$REF`;
C_IDOCOMP_2=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 2 | head -n 1 | awk '{print $4;}'`;
MC_IDOCOMP_2=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_2=`cat results/D_IDOCOMP_$TAR-$REF | awk '{ print $4;}'`;
MD_IDOCOMP_2=`cat results/MC_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_2=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
#
BC_GREEN_2=`cat results/BC_GREEN_$TAR-$REF | awk '{print $5;}'`;
C_GREEN_2=`cat results/C_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MC_GREEN_2=`cat results/MC_GREEN_$TAR-$REF`;
D_GREEN_2=`cat results/D_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MD_GREEN_2=`cat results/MC_GREEN_$TAR-$REF`;
V_GREEN_2=`cat results/V_GREEN_$TAR-$REF | wc -l`;
#
BC_GECO_REF_2=`cat results/BC_GECO_REF_$TAR-$REF | awk '{print $5;}'`;
C_GECO_REF_2=`cat results/C_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MC_GECO_REF_2=`cat results/MC_GECO_REF_$TAR-$REF`;
D_GECO_REF_2=`cat results/D_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MD_GECO_REF_2=`cat results/MC_GECO_REF_$TAR-$REF`;
V_GECO_REF_2=`cat results/V_GECO_REF_$TAR-$REF | wc -l`;
#
<<<<<<< HEAD
BC_GDC_2=`cat results/BC_GDC_$TAR-$REF | awk '{print $5;}'`;
C_GDC_2=`cat results/C_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MC_GDC_2=`cat results/MC_GDC_$TAR-$REF`;
D_GDC_2=`cat results/D_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MD_GDC_2=`cat results/MC_GDC_$TAR-$REF`;
V_GDC_2=`cat results/V_GDC_$TAR-$REF | wc -l`;
#
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_2 $C_IDOCOMP_2 $MC_IDOCOMP_2 $D_IDOCOMP_2 $MD_IDOCOMP_2 $V_IDOCOMP_2;
printf "GReEn\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GREEN_2 $C_GREEN_2 $MC_GREEN_2 $D_GREEN_2 $MD_GREEN_2 $V_GREEN_2;
printf "GeCo\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GECO_REF_2 $C_GECO_REF_2 $MC_GECO_REF_2 $D_GECO_REF_2 $MD_GECO_REF_2 $V_GECO_REF_2;
<<<<<<< HEAD
printf "Gdc2\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GDC_2 $C_GDC_2 $MC_GDC_2 $D_GDC_2 $MD_GDC_2 $V_GDC_2;
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
###############################################################################
###############################################################################
#
TAR="HS11";
REF="PT11";
#
BC_IDOCOMP_3=`cat results/BC_IDOCOMP_$TAR-$REF`;
C_IDOCOMP_3=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 2 | head -n 1 | awk '{print $4;}'`;
MC_IDOCOMP_3=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_3=`cat results/D_IDOCOMP_$TAR-$REF | awk '{ print $4;}'`;
MD_IDOCOMP_3=`cat results/MC_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_3=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
#
BC_GREEN_3=`cat results/BC_GREEN_$TAR-$REF | awk '{print $5;}'`;
C_GREEN_3=`cat results/C_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MC_GREEN_3=`cat results/MC_GREEN_$TAR-$REF`;
D_GREEN_3=`cat results/D_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MD_GREEN_3=`cat results/MC_GREEN_$TAR-$REF`;
V_GREEN_3=`cat results/V_GREEN_$TAR-$REF | wc -l`;
#
BC_GECO_REF_3=`cat results/BC_GECO_REF_$TAR-$REF | awk '{print $5;}'`;
C_GECO_REF_3=`cat results/C_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MC_GECO_REF_3=`cat results/MC_GECO_REF_$TAR-$REF`;
D_GECO_REF_3=`cat results/D_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MD_GECO_REF_3=`cat results/MC_GECO_REF_$TAR-$REF`;
V_GECO_REF_3=`cat results/V_GECO_REF_$TAR-$REF | wc -l`;
#
<<<<<<< HEAD
BC_GDC_3=`cat results/BC_GDC_$TAR-$REF | awk '{print $5;}'`;
C_GDC_3=`cat results/C_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MC_GDC_3=`cat results/MC_GDC_$TAR-$REF`;
D_GDC_3=`cat results/D_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MD_GDC_3=`cat results/MC_GDC_$TAR-$REF`;
V_GDC_3=`cat results/V_GDC_$TAR-$REF | wc -l`;
#
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_3 $C_IDOCOMP_3 $MC_IDOCOMP_3 $D_IDOCOMP_3 $MD_IDOCOMP_3 $V_IDOCOMP_3;
printf "GReEn\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GREEN_3 $C_GREEN_3 $MC_GREEN_3 $D_GREEN_3 $MD_GREEN_3 $V_GREEN_3;
printf "GeCo\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GECO_REF_3 $C_GECO_REF_3 $MC_GECO_REF_3 $D_GECO_REF_3 $MD_GECO_REF_3 $V_GECO_REF_3;
<<<<<<< HEAD
printf "Gdc2\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GDC_3 $C_GDC_3 $MC_GDC_3 $D_GDC_3 $MD_GDC_3 $V_GDC_3;
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
###############################################################################
###############################################################################
#
TAR="HS11";
REF="PA11";
#
BC_IDOCOMP_4=`cat results/BC_IDOCOMP_$TAR-$REF`;
C_IDOCOMP_4=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 2 | head -n 1 | awk '{print $4;}'`;
MC_IDOCOMP_4=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_4=`cat results/D_IDOCOMP_$TAR-$REF | awk '{ print $4;}'`;
MD_IDOCOMP_4=`cat results/MC_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_4=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
#
BC_GREEN_4=`cat results/BC_GREEN_$TAR-$REF | awk '{print $5;}'`;
C_GREEN_4=`cat results/C_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MC_GREEN_4=`cat results/MC_GREEN_$TAR-$REF`;
D_GREEN_4=`cat results/D_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MD_GREEN_4=`cat results/MC_GREEN_$TAR-$REF`;
V_GREEN_4=`cat results/V_GREEN_$TAR-$REF | wc -l`;
#
BC_GECO_REF_4=`cat results/BC_GECO_REF_$TAR-$REF | awk '{print $5;}'`;
C_GECO_REF_4=`cat results/C_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MC_GECO_REF_4=`cat results/MC_GECO_REF_$TAR-$REF`;
D_GECO_REF_4=`cat results/D_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MD_GECO_REF_4=`cat results/MC_GECO_REF_$TAR-$REF`;
V_GECO_REF_4=`cat results/V_GECO_REF_$TAR-$REF | wc -l`;
#
<<<<<<< HEAD
BC_GDC_4=`cat results/BC_GDC_$TAR-$REF | awk '{print $5;}'`;
C_GDC_4=`cat results/C_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MC_GDC_4=`cat results/MC_GDC_$TAR-$REF`;
D_GDC_4=`cat results/D_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MD_GDC_4=`cat results/MC_GDC_$TAR-$REF`;
V_GDC_4=`cat results/V_GDC_$TAR-$REF | wc -l`;
#
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_4 $C_IDOCOMP_4 $MC_IDOCOMP_4 $D_IDOCOMP_4 $MD_IDOCOMP_4 $V_IDOCOMP_4;
printf "GReEn\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GREEN_4 $C_GREEN_4 $MC_GREEN_4 $D_GREEN_4 $MD_GREEN_4 $V_GREEN_4;
printf "GeCo\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GECO_REF_4 $C_GECO_REF_4 $MC_GECO_REF_4 $D_GECO_REF_4 $MD_GECO_REF_4 $V_GECO_REF_4;
<<<<<<< HEAD
printf "Gdc2\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GDC_4 $C_GDC_4 $MC_GDC_4 $D_GDC_4 $MD_GDC_4 $V_GDC_4;
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
###############################################################################
###############################################################################
#
TAR="HSK16";
REF="HS16";
#
BC_IDOCOMP_5=`cat results/BC_IDOCOMP_$TAR-$REF`;
C_IDOCOMP_5=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 2 | head -n 1 | awk '{print $4;}'`;
MC_IDOCOMP_5=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_5=`cat results/D_IDOCOMP_$TAR-$REF | awk '{ print $4;}'`;
MD_IDOCOMP_5=`cat results/MC_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_5=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
#
BC_GREEN_5=`cat results/BC_GREEN_$TAR-$REF | awk '{print $5;}'`;
C_GREEN_5=`cat results/C_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MC_GREEN_5=`cat results/MC_GREEN_$TAR-$REF`;
D_GREEN_5=`cat results/D_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MD_GREEN_5=`cat results/MC_GREEN_$TAR-$REF`;
V_GREEN_5=`cat results/V_GREEN_$TAR-$REF | wc -l`;
#
BC_GECO_REF_5=`cat results/BC_GECO_REF_$TAR-$REF | awk '{print $5;}'`;
C_GECO_REF_5=`cat results/C_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MC_GECO_REF_5=`cat results/MC_GECO_REF_$TAR-$REF`;
D_GECO_REF_5=`cat results/D_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MD_GECO_REF_5=`cat results/MC_GECO_REF_$TAR-$REF`;
V_GECO_REF_5=`cat results/V_GECO_REF_$TAR-$REF | wc -l`;
#
<<<<<<< HEAD
BC_GDC_5=`cat results/BC_GDC_$TAR-$REF | awk '{print $5;}'`;
C_GDC_5=`cat results/C_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MC_GDC_5=`cat results/MC_GDC_$TAR-$REF`;
D_GDC_5=`cat results/D_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MD_GDC_5=`cat results/MC_GDC_$TAR-$REF`;
V_GDC_5=`cat results/V_GDC_$TAR-$REF | wc -l`;
#
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_5 $C_IDOCOMP_5 $MC_IDOCOMP_5 $D_IDOCOMP_5 $MD_IDOCOMP_5 $V_IDOCOMP_5;
printf "GReEn\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GREEN_5 $C_GREEN_5 $MC_GREEN_5 $D_GREEN_5 $MD_GREEN_5 $V_GREEN_5;
printf "GeCo\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GECO_REF_5 $C_GECO_REF_5 $MC_GECO_REF_5 $D_GECO_REF_5 $MD_GECO_REF_5 $V_GECO_REF_5;
<<<<<<< HEAD
printf "Gdc2\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GDC_5 $C_GDC_5 $MC_GDC_5 $D_GDC_5 $MD_GDC_5 $V_GDC_5;
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
###############################################################################
###############################################################################
#
TAR="RICE5";
REF="RICE7";
#
BC_IDOCOMP_6=`cat results/BC_IDOCOMP_$TAR-$REF`;
C_IDOCOMP_6=`cat results/C_IDOCOMP_$TAR-$REF | tail -n 2 | head -n 1 | awk '{print $4;}'`;
MC_IDOCOMP_6=`cat results/MC_IDOCOMP_$TAR-$REF`;
D_IDOCOMP_6=`cat results/D_IDOCOMP_$TAR-$REF | awk '{ print $4;}'`;
MD_IDOCOMP_6=`cat results/MC_IDOCOMP_$TAR-$REF`;
V_IDOCOMP_6=`cat results/V_IDOCOMP_$TAR-$REF | wc -l`;
#
BC_GREEN_6=`cat results/BC_GREEN_$TAR-$REF | awk '{print $5;}'`;
C_GREEN_6=`cat results/C_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MC_GREEN_6=`cat results/MC_GREEN_$TAR-$REF`;
D_GREEN_6=`cat results/D_GREEN_$TAR-$REF | grep 'cpu' | awk '{ print $5;}'`;
MD_GREEN_6=`cat results/MC_GREEN_$TAR-$REF`;
V_GREEN_6=`cat results/V_GREEN_$TAR-$REF | wc -l`;
#
BC_GECO_REF_6=`cat results/BC_GECO_REF_$TAR-$REF | awk '{print $5;}'`;
C_GECO_REF_6=`cat results/C_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MC_GECO_REF_6=`cat results/MC_GECO_REF_$TAR-$REF`;
D_GECO_REF_6=`cat results/D_GECO_REF_$TAR-$REF | grep Spent | awk '{ print $2;}'`;
MD_GECO_REF_6=`cat results/MC_GECO_REF_$TAR-$REF`;
V_GECO_REF_6=`cat results/V_GECO_REF_$TAR-$REF | wc -l`;
#
<<<<<<< HEAD
BC_GDC_6=`cat results/BC_GDC_$TAR-$REF | awk '{print $5;}'`;
C_GDC_6=`cat results/C_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MC_GDC_6=`cat results/MC_GDC_$TAR-$REF`;
D_GDC_6=`cat results/D_GDC_$TAR-$REF | tail -n 2 | head -n 1 | awk '{ print $2;}'`;
MD_GDC_6=`cat results/MC_GDC_$TAR-$REF`;
V_GDC_6=`cat results/V_GDC_$TAR-$REF | wc -l`;
#
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
printf "REF:%s|TAR:%s---------------------------------------\n" $REF $TAR;
printf "IDoComp\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_IDOCOMP_6 $C_IDOCOMP_6 $MC_IDOCOMP_6 $D_IDOCOMP_6 $MD_IDOCOMP_6 $V_IDOCOMP_6;
printf "GReEn\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GREEN_6 $C_GREEN_6 $MC_GREEN_6 $D_GREEN_6 $MD_GREEN_6 $V_GREEN_6;
printf "GeCo\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GECO_REF_6 $C_GECO_REF_6 $MC_GECO_REF_6 $D_GECO_REF_6 $MD_GECO_REF_6 $V_GECO_REF_6;
<<<<<<< HEAD
printf "Gdc2\\t%s\t%s\t%s\t%s\t%s\t%s\n" $BC_GDC_6 $C_GDC_6 $MC_GDC_6 $D_GDC_6 $MD_GDC_6 $V_GDC_6;
=======
>>>>>>> fa682b65a89ed8cabc892c0ba6d727d820aff0e7
###############################################################################
