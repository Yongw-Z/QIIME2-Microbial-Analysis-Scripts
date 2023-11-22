#!/bin/bash

conda install q2-picrust2=2023.7 -c conda-forge -c bioconda -c gavinmdouglas 
qiime --help
# 菜单栏里有PICRUST代表安装成功

# 根据已知的微生物序列和它们的丰度信息来预测微生物群落的功能潜能（代谢途径等）
qiime picrust2 full-pipeline \
--i-table table.qza \
--i-seq rep-seqs.qza \
--output-dir q2-picrust2_output \
--verbose

# 可视化（代谢途径丰度表，EC号码丰度表，KEGG Orthology丰度表）
qiime feature-table summarize  \
--i-table q2-picrust2_output/pathway_abundance.qza  \
--o-visualization q2-picrust2_output/pathway_abundance.qzv 

qiime feature-table summarize  \
--i-table q2-picrust2_output/ec_metagenome.qza  \
--o-visualization q2-picrust2_output/ec_metagenome.qzv

qiime feature-table summarize  \
--i-table q2-picrust2_output/ko_metagenome.qza  \
--o-visualization q2-picrust2_output/ko_metagenome.qzv

# 多样性分析
# 采样深度：pathway_abundance.qzv -> Interactive Sample Detail -> Feature Count最小值
qiime diversity core-metrics \
--i-table q2-picrust2_output/pathway_abundance.qza \
--p-sampling-depth 5386412 \
--m-metadata-file sample-metadata.txt \
--output-dir q2-picrust2_output/pathabun_core_metrics_out

# 以表格格式输出文件
qiime tools export \
--input-path q2-picrust2_output/pathway_abundance.qza \
--output-path q2-picrust2_output/pathabun_exported

qiime tools export \
--input-path q2-picrust2_output/ec_metagenome.qza \
--output-path q2-picrust2_output/ec_metagenome_exported

qiime tools export \
--input-path q2-picrust2_output/ko_metagenome.qza \
--output-path q2-picrust2_output/ko_metagenome_exported

biom convert \
-i q2-picrust2_output/pathabun_exported/feature-table.biom \
-o q2-picrust2_output/pathabun_exported/pathabunｰfeature-table.biom.tsv \
--to-tsv

biom convert \
-i q2-picrust2_output/ec_metagenome_exported/feature-table.biom \
-o q2-picrust2_output/ec_metagenome_exported/ec-feature-table.biom.tsv \
--to-tsv

biom convert \
-i q2-picrust2_output/ko_metagenome_exported/feature-table.biom \
-o q2-picrust2_output/ko_metagenome_exported/ko-feature-table.biom.tsv \
--to-tsv
