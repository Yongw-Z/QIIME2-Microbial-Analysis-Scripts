#!/bin/bash

# 样本深度取决于每个样本中鉴定出的细菌种类（特征）的数量，table.qzv -> Interactive Sample Detail -> 最小值
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 51663 \
  --m-metadata-file sample-metadata.txt \
  --output-dir core-metrics-results
 
 # 导出未加权 UniFrac主坐标轴分析（PCoA）结果
 qiime tools export \
--input-path core-metrics-results/unweighted_unifrac_pcoa_results.qza \
--output-path core-metrics-results/unweighted_unifrac_pcoa_results

#  未加权 UniFrac距离矩阵是否具有统计学上的显著差异
qiime diversity beta-group-significance \
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
--m-metadata-file sample-metadata.txt \
--m-metadata-column Origin \
--o-visualization core-metrics-results/unweighted_unifrac_origin-significance.qzv \
--p-pairwise
