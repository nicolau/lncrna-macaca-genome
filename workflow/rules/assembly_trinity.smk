rule assembly_merge_right_and_left:
    input:
        left=expand("results/trimmed/{sample}.paired.R1.fastq.gz", sample=SAMPLES),
        right=expand("results/trimmed/{sample}.paired.R2.fastq.gz", sample=SAMPLES)
    output:
        left=temp("results/assembly/trinity/left.fq.gz"),
        right=temp("results/assembly/trinity/right.fq.gz")
    threads: config["params"]["general"]["threads"] # Use at least two threads
    shell:
        """
        zcat {input.left} | gzip -c > {output.left}
        zcat {input.right} | gzip -c > {output.right}
        """

rule assembly_run_trinity:
    input:
        left=rules.assembly_merge_right_and_left.output.left,
        right=rules.assembly_merge_right_and_left.output.right
    output: fasta="results/assembly/trinity/Trinity.fasta"
    threads: config["params"]["general"]["threads"] # Use at least two threads
    params:
        memory="8G",
        outdir="results/assembly/trinity"
    conda: "../envs/trinity.yaml"
    log: "logs/trinity/trinity.log"
    shell:
        """
        Trinity \
            --seqType fq \
            --max_memory {params.memory} \
            --left {input.left} \
            --right {input.right} \
            --CPU {threads} \
            --full_cleanup \
            --output {params.outdir} \
        > {log}
        """
