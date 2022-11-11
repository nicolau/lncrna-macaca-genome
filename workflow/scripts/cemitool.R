## Load R packages
library(tidyverse)
library(CEMiTool)
library(edgeR)
library(ggplot2)

norm.exp     <- readr::read_tsv(file = snakemake@input[["log2cpm"]]) %>%
  tibble::column_to_rownames("Symbol") %>%
  as.data.frame()
pheno       <- readr::read_tsv(file = snakemake@input[["phenodata"]]) %>%
  as.data.frame()
norm.exp.sub <- norm.exp %>% dplyr::select(pheno$Sample)

gmt_in <- read_gmt(snakemake@params[["gmt"]])

int_fname <- system.file("extdata", "interactions.tsv", package = "CEMiTool")
int_df <- read.delim(int_fname)

cem <- cemitool(expr = norm.exp.sub, annot = pheno, apply_vst = T,
                sample_name_column = "Sample", class_column = "Class",
                filter = T, merge_similar = F, gmt = gmt_in,
                interactions = int_df, force_beta = T, network_type = "unsigned")

generate_report(cem,   force = T, directory = snakemake@params[["outputdir"]])
write_files(cem,       force = T, directory = paste0(snakemake@params[["outputdir"]], "/Tables"))
save_plots(cem, "all", force = T, directory = paste0(snakemake@params[["outputdir"]], "/Plots"))
diagnostic_report(cem, force = T, directory = paste0(snakemake@params[["outputdir"]], "/Diagnostic"))
