# Depends on: rule gene_2_symbol
rule mdp:
    input:
        log2cpm="results/counts/log2cpm_count_matrix_symbol.tsv",
        phenodata="../resources/phenodata.tsv"
    output:
        #"results/mdp/MDP_allgenessamples.pdf",
        "results/mdp/MDP_gene_scores.tsv",
        #"results/mdp/MDP_perturbedsamples.pdf",
        "results/mdp/MDP_sample_scores.tsv",
        "results/mdp/MDP_zscore.tsv"
    params:
        contrast=config["diffexp"]["contrasts"],
        outputdir="results/mdp/"
    threads: config["params"]["general"]["threads"]
    log: "logs/mdp.log"
    conda: "../envs/mdp.yaml"
    script: "../scripts/mdp.R"
