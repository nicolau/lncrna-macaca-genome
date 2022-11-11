# Depends on: rule gene_2_symbol
rule cemitool:
    input:
        log2cpm="results/counts/log2cpm_count_matrix_symbol.tsv",
        phenodata="../resources/phenodata.tsv"
    output:
        "results/coexpression/report.html",
        "results/coexpression/Plots/beta_r2.pdf",
        "results/coexpression/Plots/gsea.pdf",
        "results/coexpression/Plots/hist.pdf",
        "results/coexpression/Plots/interaction.pdf",
        "results/coexpression/Plots/mean_k.pdf",
        "results/coexpression/Plots/mean_var.pdf",
        "results/coexpression/Plots/ora.pdf",
        "results/coexpression/Plots/profile.pdf",
        "results/coexpression/Plots/qq.pdf",
        "results/coexpression/Plots/sample_tree.pdf",
        
        "results/coexpression/Tables/enrichment_es.tsv",
        "results/coexpression/Tables/enrichment_nes.tsv",
        "results/coexpression/Tables/enrichment_padj.tsv",
        "results/coexpression/Tables/interactions.tsv",
        "results/coexpression/Tables/module.tsv",
        "results/coexpression/Tables/modules_genes.gmt",
        "results/coexpression/Tables/ora.tsv",
        "results/coexpression/Tables/parameters.tsv",
        "results/coexpression/Tables/selected_genes.txt",
        "results/coexpression/Tables/summary_eigengene.tsv",
        "results/coexpression/Tables/summary_mean.tsv",
        "results/coexpression/Tables/summary_median.tsv"
    params:
        outputdir="results/coexpression",
        gmt=config["genesets"]["reactome"]
    threads: config["params"]["general"]["threads"]
    log: "logs/cemitool.log"
    conda: "../envs/cemitool.yaml"
    script: "../scripts/cemitool.R"
