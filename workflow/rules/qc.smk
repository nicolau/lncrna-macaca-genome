rule fastqc:
    input: ["../resources/reads/{sample}_R1_001.fastq.gz", "../resources/reads/{sample}_R2_001.fastq.gz"]
    output:
        html="results/qc/fastqc/{sample}.html",
        zip="results/qc/fastqc/{sample}_fastqc.zip" # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params: "--quiet"
    # version: shell("fastqc --version")
    # log: "logs/fastqc/{sample}.log"
    threads: config["params"]["general"]["threads"]
    wrapper: config["wrapper_version"] + "/bio/fastqc"

# Depends on: rule fastqc
rule multiqc:
    input: expand("results/qc/fastqc/{sample}.html", sample=SAMPLES)
    output: "results/qc/multiqc_report.html"
    params: ""  # Optional: extra parameters for multiqc.
    log: "logs/multiqc.log"
    wrapper: config["wrapper_version"] + "/bio/multiqc"

#rule pca:
#    input:
#        log2cpm="results/counts/log2cpm_count_matrix_symbol.tsv",
#        phenodata="../resources/phenodata.tsv"
#    output: "results/qc/barplot_pca.png", "results/qc/scatterplot_pca.png"
#    params: "" # Optional: extra parameters for PCA plot.
#    conda: "../envs/deseq2.yaml"
#    log: "logs/pca_plot.log"
#    script: "../scripts/pca.R"