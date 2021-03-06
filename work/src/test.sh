#!/bin/bash

source prepare.sh
python3 -u ./translate.py -k 10 \
	../data/dictionary.txt \
	../data/grammar.txt \
	../data/test/ \
	$LOG_DIRECTORY/test_decode_result.txt \
	$LOG_DIRECTORY/test.wer \
	../model/*.npz 2>&1 | tee $LOG_DIRECTORY/log.txt
mv $LOG_DIRECTORY/test_decode_result.txt.0 $LOG_DIRECTORY/test_decode_result.txt
line_format='^([^ ]+) (.*)$'
mkdir $LOG_DIRECTORY/tex
cat $LOG_DIRECTORY/test_decode_result.txt|while read -r line; do [[ $line =~ $line_format ]]; filename=$LOG_DIRECTORY/tex/${BASH_REMATCH[1]}.txt ; echo '$'${BASH_REMATCH[2]}'$' >$filename ; python3 fix_tex.py $filename ;done
export LgEvalDir=`pwd`/lgeval
export CROHMELibDir=`pwd`/crohmelib
export PATH=$PATH:$CROHMELibDir/bin:$LgEvalDir/bin
cd convert2symLG 
./tex2symlg $LOG_DIRECTORY/tex $LOG_DIRECTORY/lg
cd $LOG_DIRECTORY
evaluate lg ../../data/test_symlg
cat Results_lg/Summary.txt
rm -r tex 
rm -r lg
rm -r Results_lg/Metrics
