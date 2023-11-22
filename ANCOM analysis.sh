#!/bin/bash

mkdir ANCOM ANCOM/Level_2

# 根据分类信息将 OTU表在门级别上合并
qiime taxa collapse \
--i-table table.qza \
--i-taxonomy taxonomy.qza \
--p-level 2 \
--o-collapsed-table ANCOM/Level_2/L2_collapsed_table.qza

# ANCOM分析法不允许出现 "0"，也可能存在完全不存在的细菌，因此这里所有值都加 "1"
qiime composition add-pseudocount \
--i-table ANCOM/Level_2/L2_collapsed_table.qza \
--o-composition-table ANCOM/Level_2/L2_comp-collapsed_table.qza

# ANCOM鉴别在不同组间显著变化的特征（物种、OTU等）
qiime composition ancom \
--i-table ANCOM/Level_2/L2_comp-collapsed_table.qza \
--m-metadata-file sample-metadata.txt \
--m-metadata-column Origin \
--o-visualization ANCOM/Level_2/L2-ancom-Origin

# 细菌种类（特征）级别进行分析
mkdir ANCOM/Feature

qiime composition add-pseudocount \
--i-table table.qza \
--o-composition-table ANCOM/Feature/Feature_comp_table.qza 

qiime composition ancom \
--i-table ANCOM/Feature/Feature_comp_table.qza \
--m-metadata-file sample-metadata.txt \
--m-metadata-column Origin \
--o-visualization ANCOM/Feature/Feature-ancom-Origin
