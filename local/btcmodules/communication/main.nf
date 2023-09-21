process SCBTC_COMMUNICATION {
    tag "Cell-cell communication"
    label 'process_high'

    container "oandrefonseca/scrpackages:main"
    publishDir "${params.outdir}/${params.project_name}", mode: 'copy'
    
    input:
        path(project_object)
        path(communication_script)

    output:
        path("data/${params.project_name}_liana_object.RDS"), emit: liana_rds
        path("data/${params.project_name}_cellchat_object.RDS"), emit: cellchat_rds
        path("${params.project_name}_communication_report.html")
        path("figures/communication")

    when:
        task.ext.when == null || task.ext.when
        
    script:
        def n_memory = task.memory.toString().replaceAll(/[^0-9]/, '') as int
        """
        #!/usr/bin/env Rscript

        # Getting run work directory
        here <- getwd()

        # Rendering Rmarkdown script
        rmarkdown::render("${communication_script}",
            params = list(
                project_name = "${params.project_name}",
                project_object = "${project_object}",
                input_source_groups = "${params.input_source_groups}",
                input_target_groups = "${params.input_target_groups}",
                input_cellchat_annotation = "${params.input_cellchat_annotation}",
                n_threads = ${task.cpus},
                n_memory = ${n_memory},
                workdir = here
            ), 
            output_dir = here,
            output_file = "${params.project_name}_communication_report.html"
            )           

        """
    stub:
        """
        mkdir -p data figures/communication

        touch data/${params.project_name}_cellchat_object.RDS
        touch data/${params.project_name}_liana_object.RDS
        touch ${params.project_name}_communication_report.html
        
        touch figures/communication/EMPTY
        """
}
