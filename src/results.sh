#!/bin/bash
###############################################################################
#################################### FASTA ####################################
###############################################################################
#
# DELIMINATE ##################################################################
#
# BC, BYTES ON COMPRESSION ====================================================
BC_DELIMINATE_HUMAN=`cat results/BC_DELIMINATE_HUMAN | awk '{ print $5; }'`;
BC_DELIMINATE_CHIMPANZE=`cat results/BC_DELIMINATE_CHIMPANZE \
| awk '{ print $5; }'`;
BC_DELIMINATE_RICE=`cat results/BC_DELIMINATE_RICE | awk '{ print $5; }'`;
BC_DELIMINATE_CAMERA=`cat results/BC_DELIMINATE_CAMERA | awk '{ print $5; }'`;
# C, TIME =====================================================================
C_DELIMINATE_HUMAN=`cat results/C_DELIMINATE_HUMAN | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
C_DELIMINATE_CHIMPANZE=`cat results/C_DELIMINATE_CHIMPANZE | tail -n 2 \ 
| head -n 1 | awk '{ print $2;}'`;
C_DELIMINATE_RICE=`cat results/C_DELIMINATE_RICE | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
C_DELIMINATE_CAMERA=`cat results/C_DELIMINATE_CAMERA | tail -n 2 | head -n 1 \
| awk '{ print $2;}'`;
# C, TIME =====================================================================



###############################################################################




