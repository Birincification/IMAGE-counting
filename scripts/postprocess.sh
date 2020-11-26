#!/bin/bash

stringtie='/home/scripts/stringtie_call.sh'
salmon='/home/scripts/salmon_call.sh'
featureCounts='/home/scripts/featureCounts_call.sh'
dexseqFilter='/home/scripts/modify_dexseq_featurecounts.py'
dexseqHT='/home/scripts/fc_to_ht.py'
kallistoProcess='/home/scripts/kallisto_to_split_tpm.R'
exprs_fdata='/home/scripts/create_exprs_fdata.py'


sampleList=$1
gtf=$2		#/home/GENOMIC_DERIVED/PAN/homo_sapiens/standardchr/Homo_sapiens.GRCh37.75.gtf
out=$3
nthreads=$4
indexAppendix=$5	# 9606/standardchr
pData=$6

hisatBams=()
samples=()

while read sample; do
	#Stringtie	$1=HISAT_quant_bam; $2=gtf; $3=out/path/name.gtf; $4=nthreads
	$stringtie $out/HISAT/dta/$sample.bam $gtf $out/STRINGTIE/$sample/$sample $nthreads

	#Salmon 	$1=STAR_quant_bam; $2=indexAppendix; $3=out_dir; $4=nthreads
	$salmon $out/STAR/quant/${sample}Aligned.toTranscriptome.out.bam $indexAppendix $out/SALMON/$sample $nthreads

	## create hisatBams -> list of samples in $out/HISAT/$sample.bam; needed for featureCounts
	hisatBams+=( "$out/HISAT/dta/$sample.bam" )
	samples+=( "$sample" )
done < $sampleList



#featureCounts
mkdir -p $out/COUNTS
$featureCounts $gtf $out/COUNTS/featureCounts $nthreads $indexAppendix ${hisatBams[@]}

echo "[INFO] [DEXSeq] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $dexseqFilter $out/COUNTS/featureCounts.DEXSeq"
$dexseqFilter $out/COUNTS/featureCounts.DEXSeq
echo "[INFO] [DEXSeq] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $dexseqHT --fcfile $out/COUNTS/featureCounts.DEXSeq.filtered --htdir $out/COUNTS/DEXSeq_HTcounts --sampletable $sampleList"
$dexseqHT --fcfile $out/COUNTS/featureCounts.DEXSeq.filtered --htdir $out/COUNTS/DEXSeq_HTcounts --sampletable $sampleList
echo "[INFO] [DEXSeq] ["`date "+%Y/%m/%d-%H:%M:%S"`"] Preprocessing finished"$'\n'

#Kallisto
echo "[INFO] [Kallisto] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $kallistoProcess --counts $out/KALLISTO/alignment --pdata $pData --out $out/COUNTS/tpm.counts --cond1 0 --cond2 1 --tx2gene /home/data/indices/R/$indexAppendix/tx2gene.RData"
$kallistoProcess --counts $out/KALLISTO/alignment --pdata $pData --out $out/COUNTS/tpm.counts --cond1 0 --cond2 1 --tx2gene /home/data/indices/R/$indexAppendix/tx2gene.RData
echo "[INFO] [Kallisto] ["`date "+%Y/%m/%d-%H:%M:%S"`"] Preprocessing finished"$'\n'

cp $pData /home/data/p_data.txt
echo "[INFO] [featureCounts] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $exprs_fdata ${samples[@]}"
$exprs_fdata ${samples[@]}
echo "[INFO] [featureCounts] ["`date "+%Y/%m/%d-%H:%M:%S"`"] Preprocessing finished"$'\n'
