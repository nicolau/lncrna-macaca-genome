rule blast_makedatabase_nucleotide:
    input: fasta="genome/{genome}.fasta"
    output:
        multiext("results/{genome}.fasta",
            ".ndb",
            ".nhr",
            ".nin",
            ".not",
            ".nsq",
            ".ntf",
            ".nto"
        )
    log: "logs/{genome}.log"
    params: "-input_type fasta -blastdb_version 5 -parse_seqids"
    wrapper: "v1.19.0/bio/blast/makeblastdb"

rule blast_makedatabase_protein:
    input: fasta="protein/{protein}.fasta"
    output:
        multiext("results/{protein}.fasta",
            ".pdb",
            ".phr",
            ".pin",
            ".pot",
            ".psq",
            ".ptf",
            ".pto"
        )
    log: "logs/{protein}.log"
    params: "-input_type fasta -blastdb_version 5"
    wrapper: "v1.19.0/bio/blast/makeblastdb"

rule blast_nucleotide:
    input:
        query = "{sample}.fasta",
        blastdb=multiext("blastdb/blastdb",
            ".ndb",
            ".nhr",
            ".nin",
            ".not",
            ".nsq",
            ".ntf",
            ".nto"
        )
    output: "{sample}.blast.txt"
    log: "logs/{sample}.blast.log"
    threads: 2
    params:
        # Usable options and specifiers for the different output formats are listed here:
        # https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/blast/blastn.html.
        format="6 qseqid sseqid evalue",
        extra=""
    wrapper: "v1.19.0/bio/blast/blastn"
