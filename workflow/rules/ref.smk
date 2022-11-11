rule get_genome:
    output: "resources/ref/genome.fasta"
    log: "logs/get_genome.log"
    params:
        species=config["ref"]["species"],
        datatype="dna",
        build=config["ref"]["build"],
        release=config["ref"]["release"]
    cache: True
    message: "Downloading the genome {params.species} ({params.build}) and release {params.release}..."
    wrapper: config["wrapper_version"] + "/bio/reference/ensembl-sequence"

rule get_transcriptome:
    output: "resources/ref/transcriptome.fasta"
    log: "logs/get_transcriptome.log"
    params:
        species=config["ref"]["species"],
        datatype="cdna",
        build=config["ref"]["build"],
        release=config["ref"]["release"]
    cache: True
    message: "Downloading the transcriptome {params.species} ({params.build}) and release {params.release}..."
    wrapper: config["wrapper_version"] + "/bio/reference/ensembl-sequence"

rule get_annotation:
    output: "resources/ref/genome.gtf",
    params:
        species=config["ref"]["species"],
        fmt="gtf",
        build=config["ref"]["build"],
        release=config["ref"]["release"],
        flavor=""
    cache: True
    log: "logs/get_annotation.log"
    wrapper: config["wrapper_version"] + "/bio/reference/ensembl-annotation"

rule get_coding_fasta:
    output: "resources/ref/cds.fasta"
    log: "logs/get_coding.log"
    params:
        species=config["ref"]["species"],
        datatype="cds",
        build=config["ref"]["build"],
        release=config["ref"]["release"]
    cache: True
    message: "Downloading the CDS {params.species} ({params.build}) and release {params.release}..."
    wrapper: config["wrapper_version"] + "/bio/reference/ensembl-sequence"

rule get_noncoding_fasta:
    output: "resources/ref/ncrna.fasta"
    log: "logs/get_noncoding.log"
    params:
        species=config["ref"]["species"],
        datatype="ncrna",
        build=config["ref"]["build"],
        release=config["ref"]["release"]
    cache: True
    message: "Downloading the ncRNA {params.species} ({params.build}) and release {params.release}..."
    wrapper: config["wrapper_version"] + "/bio/reference/ensembl-sequence"