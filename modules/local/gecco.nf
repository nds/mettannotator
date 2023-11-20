process GECCO {

    tag "${meta.prefix}"

    container 'quay.io/microbiome-informatics/gecco:0.9.8'

    input:
    tuple val(meta), path(gbk)

    output:
    tuple val(meta), path("gecco/${meta.prefix}.clusters.gff"), emit: gff, optional: true
    path "versions.yml" , emit: versions

    script:
    """
    gecco run -g $gbk -o gecco --cds-feature CDS

    if [ -n "\$(find gecco -name "*gbk" -type f)" ]; then
        echo "Converting GECCO output"
        gecco convert clusters -i gecco --format=gff


    else
        echo "GECCO detected no clusters."
    fi

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        GECCO: \$(echo \$(gecco --version) | grep -o "gecco [0-9.]*" | sed "s/gecco //g")
    END_VERSIONS
    """
}
