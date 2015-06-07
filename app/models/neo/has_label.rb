module Neo
  class HasLabel
    include Neo4j::ActiveRel

    from_class Domain
    to_class Label
    type 'HAS_LABEL'

    property :assessor_id, type: Integer
    property :readability_vis, type: Integer
    property :readability_lang, type: Integer
    property :neutrality, type: Integer
    property :bias, type: Integer
    property :trustiness, type: Integer
    property :confidence, type: Integer

  end
end
