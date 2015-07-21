module Neo
  class HasLink
    include Neo4j::ActiveRel

    from_class Host
    to_class Host
    type 'HAS_LINK'

    property :count, type: Integer
    property :probability, type: Float

  end
end
