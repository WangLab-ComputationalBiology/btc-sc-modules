process SCBTC_INDEX {
    
    tag "Saving ${genome}"
    label 'process_single'

    container 'oandrefonseca/scrpackages:main'
    publishDir "${params.outdir}/${params.project_name}", mode: 'copy'

    input:
        path(genome) // variable: GENOME

    output:
        path("indexes/${genome}"), emit: index
        path "versions.yml"      , emit: versions

    when:
        task.ext.when == null || task.ext.when

    script:
        """
        mkdir ./indexes/
        mv ${genome} ./indexes/

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            btcmodules: ${genome}
        END_VERSIONS
        """
    stub:
        """
        mkdir -p ./indexes/${genome}
        
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            btcmodules: ${genome}
        END_VERSIONS
        """
}