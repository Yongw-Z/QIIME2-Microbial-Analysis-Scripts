#!/bin/bash

# 从代表性序列创建系统发育树（对齐、掩蔽、构建未定根树和定根树）
qiime phylogeny align-to-tree-mafft-fasttree \
--i-sequences rep-seqs.qza \
--o-alignment aligned-rep-seqs.qza \
--o-masked-alignment masked-aligned-rep-seqs.qza \
--o-tree unrooted-tree.qza \
--o-rooted-tree rooted-tree.qza

mkdir alpha-diversity
mkdir alpha-diversity/alpha-rarefaction

# α多样性稀释曲线
# 基于OTU表和系统发育树，考虑每个样本最多有 10000 个序列
# 随着测序深度增加，观察到的物种数量（observed_features）增加，但在某个点之后趋于稳定
qiime diversity alpha-rarefaction  \
--i-table table.qza  \
--i-phylogeny rooted-tree.qza  \
--p-metrics observed_features  \
--p-metrics shannon  \
--p-metrics faith_pd  \
--p-max-depth 10000  \
--m-metadata-file sample-metadata.txt  \
--o-visualization alpha-diversity/alpha-rarefaction/sample_depth-10000.qzv

mkdir alpha-diversity/Sample_depth_10000
mkdir alpha-diversity/Sample_depth_10000/alpha-diversity-index alpha-diversity/Sample_depth_10000/alpha-group-significance

# 执行基于系统发育的核心多样性分析
qiime diversity core-metrics-phylogenetic \
--i-phylogeny rooted-tree.qza \
--i-table table.qza \
--p-sampling-depth 10000 \
--m-metadata-file sample-metadata.txt \
--output-dir alpha-diversity/Sample_depth_10000/core-metrics-results

# Alpha多样性指标的可视化
qiime metadata tabulate \
--m-input-file alpha-diversity/Sample_depth_10000/core-metrics-results/evenness_vector.qza \
--o-visualization alpha-diversity/Sample_depth_10000/alpha-diversity-index/evenness_index

qiime metadata tabulate \
--m-input-file alpha-diversity/Sample_depth_10000/core-metrics-results/faith_pd_vector.qza \
--o-visualization alpha-diversity/Sample_depth_10000/alpha-diversity-index/faith_pd_index

qiime metadata tabulate \
--m-input-file alpha-diversity/Sample_depth_10000/core-metrics-results/observed_features_vector.qza \
--o-visualization alpha-diversity/Sample_depth_10000/alpha-diversity-index/observed_features_index

qiime metadata tabulate \
--m-input-file alpha-diversity/Sample_depth_10000/core-metrics-results/shannon_vector.qza \
--o-visualization alpha-diversity/Sample_depth_10000/alpha-diversity-index/shannon_index

# 多样性指数的统计处理
# Evenness（均匀度）指标
# Faith's Phylogenetic Diversity（Faith's PD，信仰系统发育多样性）指标
# Observed Features（观察到的特征数量）指标
# Shannon Diversity Index（香农多样性指数）
qiime diversity alpha-group-significance \
--i-alpha-diversity alpha-diversity/Sample_depth_10000/core-metrics-results/evenness_vector.qza \
--m-metadata-file sample-metadata.txt \
--o-visualization alpha-diversity/Sample_depth_10000/alpha-group-significance/evenness_significance.qzv

qiime diversity alpha-group-significance \
--i-alpha-diversity alpha-diversity/Sample_depth_10000/core-metrics-results/faith_pd_vector.qza \
--m-metadata-file sample-metadata.txt \
--o-visualization alpha-diversity/Sample_depth_10000/alpha-group-significance/faith_pd_significance.qzv

qiime diversity alpha-group-significance \
--i-alpha-diversity alpha-diversity/Sample_depth_10000/core-metrics-results/observed_features_vector.qza \
--m-metadata-file sample-metadata.txt \
--o-visualization alpha-diversity/Sample_depth_10000/alpha-group-significance/observed_features_significance.qzv

qiime diversity alpha-group-significance \
--i-alpha-diversity alpha-diversity/Sample_depth_10000/core-metrics-results/shannon_vector.qza \
--m-metadata-file sample-metadata.txt \
--o-visualization alpha-diversity/Sample_depth_10000/alpha-group-significance/shannon_significance.qzv


