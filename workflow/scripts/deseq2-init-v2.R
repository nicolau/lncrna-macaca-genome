library(biomaRt)
library(tidyverse)

df <- readr::read_tsv(snakemake@input[["counts"]])
head(df)
