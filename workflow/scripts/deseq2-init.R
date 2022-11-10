suppressMessages(library(DESeq2))
suppressMessages(library(tidyverse))

parallel <- FALSE
if (snakemake@threads > 1) {
  library("BiocParallel")
  message("Setuping parallelization")
  
  # setup parallelization
  register(MulticoreParam(snakemake@threads))
  parallel <- TRUE
}

# colData and countData must have the same sample order, but this is ensured
# by the way we create the count matrix
cts       <- readr::read_tsv(snakemake@input[["counts"]])
cts$meanG <- apply( cts[, 3:ncol( cts ) ], 1, mean )
cts       <- cts[ order( cts[, "Symbol" ], cts[ , 'meanG' ] ), ]
cts       <- cts[ !duplicated( cts[, "Symbol"] ), ] %>% dplyr::select(-c(meanG)) %>% tibble::column_to_rownames("Symbol")
coldata   <- readr::read_tsv(snakemake@params[["samples"]]) %>% tibble::column_to_rownames("Sample")
cts       <- cts %>% dplyr::select(rownames(coldata))

# identical(rownames(coldata), colnames(cts))
dds <- DESeqDataSetFromMatrix(countData=cts,
                              colData=coldata,
                              design=as.formula(snakemake@params[["model"]]))

# remove uninformative columns
dds <- dds[ rowSums(counts(dds)) > 1, ]

# normalization and preprocessing
dds <- DESeq(dds, parallel=parallel)
#dds <- DESeq(dds)

# Write dds object as RDS
saveRDS(dds, file=snakemake@output[[1]])

# Write normalized counts
norm_counts = counts(dds, normalized=T)

# write.table(data.frame("Symbol"=rownames(norm_counts), norm_counts), file=snakemake@output[[2]], sep='\t', row.names=F)
readr::write_tsv(x = data.frame("Symbol" = rownames(norm_counts), norm_counts), file=snakemake@output[[2]])
