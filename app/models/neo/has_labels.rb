module Neo
  class HasLabels
    include Neo4j::ActiveRel

    from_class Domain
    to_class Label
    type 'HAS_LABEL'

    property :readability_vis
    property :readability_lang
    property :neutrality
    property :bias
    property :trustiness
    property :confidence

  end
end
