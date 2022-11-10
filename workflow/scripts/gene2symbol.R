library(biomaRt)
library(tidyverse)

# this variable holds a mirror name until
# useEnsembl succeeds ("www" is last, because
# of very frequent "Internal Server Error"s)
mart <- "useast"
rounds <- 0
while ( class(mart)[[1]] != "Mart" ) {
  mart <- tryCatch(
    {
      # done here, because error function does not
      # modify outer scope variables, I tried
      if (mart == "www") rounds <- rounds + 1
      # equivalent to useMart, but you can choose
      # the mirror instead of specifying a host
      biomaRt::useEnsembl(
        biomart = "ENSEMBL_MART_ENSEMBL",
        dataset = str_c(snakemake@params[["species"]], "_gene_ensembl"),
        # dataset = str_c(snakemake_species, "_gene_ensembl"),
        mirror = mart
      )
    },
    error = function(e) {
      # change or make configurable if you want more or
      # less rounds of tries of all the mirrors
      if (rounds >= 3) {
        stop(
        )
      }
      # hop to next mirror
      mart <- switch(mart,
                     useast = "uswest",
                     uswest = "asia",
                     asia = "www",
                     www = {
                       # wait before starting another round through the mirrors,
                       # hoping that intermittent problems disappear
                       Sys.sleep(30)
                       "useast"
                     }
      )
    }
  )
}

df <- readr::read_tsv(snakemake@input[["counts"]], skip = 1)
head(df)

g2g <- biomaRt::getBM(
  # attributes = c( "ensembl_gene_id", "external_gene_name", "gene_biotype"),
  attributes = c( "ensembl_gene_id", "external_gene_name"),
  filters = "ensembl_gene_id",
  values = df$Geneid,
  mart = mart,
)

annotated <- dplyr::inner_join(x = g2g %>% dplyr::rename(Geneid = ensembl_gene_id), y = df, by = "Geneid") %>%
  dplyr::rename(Symbol = external_gene_name) %>%
  dplyr::select(-c(Chr, Start, End, Strand, Length)) %>%
  dplyr::mutate(Symbol = if_else(condition = Symbol == "", true = Geneid, false = Symbol)) %>%
  dplyr::select(-Geneid)

colnames(annotated) <- gsub(pattern = "results/mapped/bowtie2/(.*)_S.*.bam", replacement = "\\1", x = colnames(annotated))
readr::write_tsv(x = annotated, file = snakemake@output[["raw"]])

annotated$meanG <- apply( annotated[, 2:ncol( annotated ) ], 1, mean )
annotated <- annotated[ order( annotated[, 1 ], annotated[ , 'meanG' ] ), ]
annotated <- annotated[ !duplicated( annotated[, 1] ), ]

annotated <- annotated %>% tibble::as_tibble() %>% tibble::column_to_rownames("Symbol")

norm.exp <- log2(edgeR::cpm(annotated)+1) %>% as.data.frame()
readr::write_tsv(x = norm.exp %>% tibble::rownames_to_column("Symbol"), file = snakemake@output[["norm"]])
