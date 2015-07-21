module Neo
  class HasConnection
    include Neo4j::ActiveRel

    from_class Host
    to_class Host
    type 'HAS_CONNECTION'

    property :count, type: Integer
    property :probability, type: Float

  end
end
