#!/bin/bash

# 去噪后的序列分类到特定的分类群
# 使用预训练的分类器（基于GreenGenes,针对515-806区域的16SrRNA）和机器学习算法（基于 scikit-learn）
qiime feature-classifier classify-sklearn \
 --i-classifier gg-13-8-99-515-806-nb-classifier.qza \
 --i-reads rep-seqs.qza \
 --o-classification taxonomy.qza
 
 qiime metadata tabulate \
 --m-input-file taxonomy.qza \
 --o-visualization taxonomy.qzv
 
 # 结合OTU表，分类信息，样本元数据进行可视化
 qiime taxa barplot \
 --i-table table.qza \
 --i-taxonomy taxonomy.qza \
 --m-metadata-file sample-metadata.txt \
 --o-visualization taxa-bar-plots.qzv
 

# 制作热图
mkdir heatmap

mkdir heatmap/Level_2

# 根据分类信息将 OTU表在门级别上合并
qiime taxa collapse \
--i-table table.qza \
--i-taxonomy taxonomy.qza \
--p-level 2 \
--o-collapsed-table heatmap/Level_2/L2_collapsed_table.qza

# 基于euclidean距离在门级别生成特征表的热图
qiime feature-table heatmap \
--i-table heatmap/Level_2/L2_collapsed_table.qza \
--p-metric euclidean \
--p-color-scheme coolwarm \
--m-sample-metadata-file sample-metadata.txt \
--m-sample-metadata-column Origin \
--o-visualization heatmap/Level_2/heatmap_Level_2
 
 
 #===========================================
 # 自制分类器（针对 V3-V4 区域优化的分类器）
 
 # 事先下载“Silva 138 SSURef NR99 full-length sequences”，“Silva 138 SSURef NR99 full-length taxonomy”
 # 从 SILVA数据库中提取特定引物区域的序列，创建适合特定 PCR引物的参考序列集
 # 根据第一次 PCR反应生成的产物的大小设定--p-max-length的值
 qiime feature-classifier extract-reads \
--i-sequences  silva-138-99-seqs.qza  \
--p-f-primer CCTACGGGNGGCWGCAG \
--p-r-primer GACTACHVGGGTATCTAATCC \
--p-max-length 600 \
--o-reads silva-138-99-ref-seqs.qza

# 基于朴素贝叶斯算法的特征分类器
qiime feature-classifier fit-classifier-naive-bayes \
--i-reference-reads silva-138-99-ref-seqs.qza \
--i-reference-taxonomy silva-138-99-tax.qza \
--o-classifier silva-138-99-classifier.qza


