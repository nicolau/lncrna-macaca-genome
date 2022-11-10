# Depends on: rule feature_counts_ensemblid
rule gene_2_symbol:
    input: counts="results/counts/raw_count_matrix_ensemblid.tsv"
    output:
        raw="results/counts/raw_count_matrix_symbol.tsv",
        norm="results/counts/log2cpm_count_matrix_symbol.tsv"
    params: species=config["ref"]["sp"]
    conda: "../envs/biomart.yaml"
    script: "../scripts/gene2symbol.R"

# Depends on: rule gene_2_symbol
rule deseq2_init:
    input: counts="results/counts/raw_count_matrix_symbol.tsv"
    output: "results/deseq2/all.rds", "results/deseq2/normcounts.tsv"
    #output: "results/deseq2/normcounts.tsv"
    params: samples=config["samples"], model=config["diffexp"]["model"]
    conda: "../envs/deseq2.yaml"
    threads: config["params"]["general"]["threads"]
    script: "../scripts/deseq2-init.R"

# Depends on: rule deseq2_init
rule deseq2:
    input: "results/deseq2/all.rds",
    output:
        table="results/diffexp/{contrast}.diffexp.tsv",
        ma_plot="results/diffexp/{contrast}.ma-plot.svg"
        # table=report("results/diffexp/{contrast}.diffexp.tsv", "../report/diffexp.rst"),
        # ma_plot=report("results/diffexp/{contrast}.ma-plot.svg", "../report/ma.rst")
    params:
        contrast=config["diffexp"]["contrasts"], # Check this parameters TODO
    conda: "../envs/deseq2.yaml"
    log: "logs/deseq2/{contrast}.diffexp.log"
    threads: config["params"]["general"]["threads"]
    script: "../scripts/deseq2.R"


#### Check out these two rules ####
#rule pca:
#    input:
#        "results/deseq2/all.rds",
#    output:
#        report("results/pca.svg", "../report/pca.rst"),
#    params:
#        pca_labels=config["pca"]["labels"],
#    conda:
#        "../envs/deseq2.yaml"
#    log:
#        "logs/pca.log",
#    script:
#        "../scripts/plot-pca.R"
#
#
#rule deseq2:
#    input:
#        "results/deseq2/all.rds",
#    output:
#        table=report("results/diffexp/{contrast}.diffexp.tsv", "../report/diffexp.rst"),
#        ma_plot=report("results/diffexp/{contrast}.ma-plot.svg", "../report/ma.rst"),
#    params:
#        contrast=get_contrast,
#    conda:
#        "../envs/deseq2.yaml"
#    log:
#        "logs/deseq2/{contrast}.diffexp.log",
#    threads: get_deseq2_threads
#    script:
#        "../scripts/deseq2.R"
