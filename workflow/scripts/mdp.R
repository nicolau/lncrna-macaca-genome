## Load R packages
library(tidyverse)
library(mdp)
library(edgeR)
library(ggplot2)

norm.exp     <- readr::read_tsv(file = snakemake@input[["log2cpm"]]) %>%
  tibble::column_to_rownames("Symbol") %>%
  as.data.frame()
pheno       <- readr::read_tsv(file = snakemake@input[["phenodata"]]) %>%
  as.data.frame()
#cpm.exp.sub <- cpm.exp %>% dplyr::select(pheno$Sample)

pheno$Sample <- paste0("S", pheno$Sample)
colnames(norm.exp) <- paste0("S", colnames(norm.exp))

pheno$Sample <- gsub(pattern = "-", replacement = "\\.", x = pheno$Sample)
colnames(norm.exp) <- gsub(pattern = "-", replacement = "\\.", x = colnames(norm.exp))

groups <- unlist(strsplit(snakemake@params[["contrast"]], "-"))
controlGroup <- groups[3]

# gmt.file <- snakemake@params[["gmt"]]
# pathways <- fgsea::gmtPathways(gmt.file)

mdp.results <- mdp(data        = norm.exp,
                   pdata       = pheno,
                   control_lab = controlGroup,
                   # pathways    = pathways,
                   file_name   = paste("MPD_", sep=""),
                   directory   = snakemake@params[["outputdir"]],
                   print       = FALSE)
