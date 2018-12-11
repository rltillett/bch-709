################################################################################################################
##############                             Annotation & GO analysis v 1.0                       ################
################################################################################################################

# Install required libraries
# source("http://bioconductor.org/biocLite.R"); biocLite("AnnotationDbi"); biocLite("clusterProfiler"); biocLite("org.Hs.eg.db")

# Load libraries
library("AnnotationDbi")
library("org.Hs.eg.db")
library(clusterProfiler)

# Set Annotation database
OrgDb <- org.Hs.eg.db

# Read in the Down-, Up-regulated gene lists from DESEq2
resDown <- read.table("resLFC1Sig_DFdown.tsv", header=TRUE)
resUp <- read.table("resLFC1Sig_DFup.tsv", header=TRUE)

# bitr: Biological Id TranslatoR
gene.df.D <- bitr(resDown$Ensembl, fromType = "ENSEMBL", 
                  toType = c("ENTREZID", "SYMBOL"),
                  OrgDb = OrgDb)
gene.df.U <- bitr(resUp$Ensembl, fromType = "ENSEMBL", 
                  toType = c("ENTREZID", "SYMBOL"),
                  OrgDb = OrgDb)

# Create gene list 
geneDown <- gene.df.D$ENTREZID
geneUp <- gene.df.U$ENTREZID

# GO classification - gene classification based on GO distribution at a specific level.
ggo.D <- groupGO(gene     = geneDown,
                 OrgDb    = OrgDb,
                 ont      = "BP",
                 level    = 3,
                 readable = TRUE)
ggo.U <- groupGO(gene     = geneUp,
                 OrgDb    = OrgDb,
                 ont      = "BP",
                 level    = 3,
                 readable = TRUE)

# GO classification plot 
png("Down_Regulated_Genes_GO_classification_plot.png")
barplot(ggo.D, drop=TRUE, showCategory=12)
dev.off()
png("Up_Regulated_Genes_GO_classification_plot.png")
barplot(ggo.U, drop=TRUE, showCategory=12)
dev.off()


# GO over-representation test
ego.D <- enrichGO(gene          = geneDown,
                  OrgDb         = OrgDb,
                  ont           = "BP",
                  pAdjustMethod = "BH",
                  pvalueCutoff  = 0.05,
                  qvalueCutoff  = 0.05, 
                  readable      = TRUE)
ego.U <- enrichGO(gene          = geneUp,
                  OrgDb         = OrgDb,
                  ont           = "BP",
                  pAdjustMethod = "BH",
                  pvalueCutoff  = 0.05,
                  qvalueCutoff  = 0.05, 
                  readable      = TRUE)

# Barplot visualization of GO enriched genes
png("Down_Regulated_Genes_GO_enrich_bar_plot.png", width=1200, height=600, res=240)
barplot(ego.D, showCategory=25)
dev.off()
png("Up_Regulated_Genes_GO_enrich_bar_plot.png", width=2400, height=1000, res=240)
barplot(ego.U, showCategory=25)
dev.off()

# Dotplot visualization of GO enriched genes
png("Down_Regulated_Genes_GO_enrich_dot_plot.png", width=1200, height=800, res=240)
dotplot(ego.D, showCategory=25)
dev.off()
png("Up_Regulated_Genes_GO_enrich_dot_plot.png", width=2400, height=1000, res=240)
dotplot(ego.U, showCategory=25)
dev.off()

# Enrichment map plot (also support results obtained from hypergeometric test and gene set enrichment analysis)
png("Down_Regulated_Genes_GO_enrich_emap_plot.png", width=1200, height=800, res=240)
emapplot(ego.D)
dev.off()
png("Up_Regulated_Genes_GO_enrich_emap_plot.png", width=2400, height=1000, res=240)
emapplot(ego.U)
dev.off()

# Complex association plot
png("Down_Regulated_Genes_GO_enrich_cnet_plot.png", width=1200, height=800, res=240)
cnetplot(ego.D, foldChange=geneDown)
dev.off()
png("Up_Regulated_Genes_GO_enrich_cnet_plot.png", width=1200, height=600, res=240)
cnetplot(ego.U, foldChange=geneUp)
dev.off()

