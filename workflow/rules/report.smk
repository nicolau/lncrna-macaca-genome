# Depends on: all rules
rule report:
    input: "results/report.pdf"
    output:
        ### QC results ###
        "results/qc/multiqc_report.html",
        
        "results/qc/barplot_pca.png",
        "results/qc/scatterplot_pca.png",
        ### QC results ###
        

        ### DE results ###
        "results/deseq2/all.rds",
        "results/deseq2/normcounts.tsv",

        "results/diffexp/" + config["diffexp"]["contrasts"] + ".diffexp.tsv",
        "results/diffexp/" + config["diffexp"]["contrasts"] + ".ma-plot.svg",
        ### DE results ###
        

        ### MDP results ###
        "MDP_allgenessamples.pdf",
        "MDP_gene_scores.tsv",
        "MDP_perturbedsamples.pdf",
        "MDP_sample_scores.tsv",
        "MDP_zscore.tsv",
        ### MDP results ###


        ### CEMiTool results ###
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
        "results/coexpression/Tables/modules_genes_without_spaces.gmt",
        "results/coexpression/Tables/ora.tsv",
        "results/coexpression/Tables/parameters.tsv",
        "results/coexpression/Tables/selected_genes.txt",
        "results/coexpression/Tables/summary_eigengene.tsv",
        "results/coexpression/Tables/summary_mean.tsv",
        "results/coexpression/Tables/summary_median.tsv"
        ### CEMiTool results ###
    params:
    threads: config["params"]["general"]["threads"]
    log: "logs/report.log"
    conda: "../envs/report.yaml"
    script: "../scripts/report.R"