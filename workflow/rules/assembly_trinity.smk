rule trinity:
    input:
        left=expand("results/trimmed/{sample}.paired.R1.fastq.gz", sample=SAMPLES),
        right=expand("results/trimmed/{sample}.paired.R2.fastq.gz", sample=SAMPLES)
    output: "results/assembly/trinity/Trinity.fasta"
    log: "logs/trinity/trinity.log"
    params: extra=""
    threads: config["params"]["general"]["threads"] # Use at least two threads
    # optional specification of memory usage of the JVM that snakemake will respect with global
    # resource restrictions (https://snakemake.readthedocs.io/en/latest/snakefiles/rules.html#resources)
    # and which can be used to request RAM during cluster job submission as `{resources.mem_mb}`:
    # https://snakemake.readthedocs.io/en/latest/executing/cluster.html#job-properties
    resources: mem_gb=10
    wrapper: config["wrapper_version"] + "/bio/trinity"
