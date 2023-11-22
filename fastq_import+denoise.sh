#!/bin/bash

# 导入测序数据
qiime tools import   \
--type 'SampleData[PairedEndSequencesWithQuality]'   \
--input-path manifest.csv   \
--output-path paired-end-demux.qza   \
--input-format PairedEndFastqManifestPhred33

# 解复用和生成可视化
qiime demux summarize   \
--i-data paired-end-demux.qza   \
--o-visualization demux.qzv

# DADA2去噪
# 剪去了引物序列，正向序列的质量从 250 开始下降，反向序列的质量从 240 开始下降
# “rep-seqs-dada2.qza”为去除噪音后的序列，“table-dada2.qza”为丰度表
qiime dada2 denoise-paired \
--i-demultiplexed-seqs paired-end-demux.qza  \
--p-trim-left-f 30 \
--p-trim-left-r 30 \
--p-trunc-len-f 250 \
--p-trunc-len-r 240 \
--o-representative-sequences rep-seqs-dada2.qza  \
--o-table table-dada2.qza   \
--o-denoising-stats stats-dada2.qza \
--verbose

# 可视化去噪过程
qiime metadata tabulate \
--m-input-file stats-dada2.qza \
--o-visualization stats-dada2.qzv

