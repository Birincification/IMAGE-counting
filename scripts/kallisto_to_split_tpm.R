#!/usr/local/bin/Rscript
library(argparse)
library(tximport)

parser <- ArgumentParser()

parser$add_argument('--counts')
parser$add_argument('--pdata')
parser$add_argument('--out')
parser$add_argument('--tx2gene', required=TRUE)
parser$add_argument('--cond1')
parser$add_argument('--cond2')

args <- parser$parse_args(commandArgs(trailingOnly=T))

p.data <- read.csv(args$pdata, sep="\t", stringsAsFactors=F)

files <- file.path(args$counts, p.data$sample, "abundance.h5")
txi <- tximport(files, type="kallisto", txOut=T)
counts <- txi$counts

load(args$tx2gene)

message(sprintf("loaded annotation from: %s", args$tx2gene))
message(sprintf("%d transcript are not in the annotation", sum(!(rownames(counts) %in% rownames(tx2gene)))))
message(sprintf("splitting counts into multiple files and transforming to TPM for conditions: %s and %s", args$cond1, args$cond2))

lens <- tx2gene[rownames(counts), "tx_len"]
counts <- counts / lens

facs <- colSums(counts) / 1000000

counts <- t(t(counts) / facs)

counts <- counts[rowSums(counts) > 0, ]

colnames(counts) <- p.data$sample

c1 <- p.data$cond == args$cond1
c2 <- p.data$cond == args$cond2

message(sprintf("writing output to %s and %s", paste0(args$out, ".", args$cond1),paste0(args$out, ".", args$cond2)))
write.table(counts[, c1], paste0(args$out, ".", args$cond1), sep="\t", quote=F)
write.table(counts[, c2], paste0(args$out, ".", args$cond2), sep="\t", quote=F)
