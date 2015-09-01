module Neo
  class HasConnection
    include Neo4j::ActiveRel

    from_class AppPage
    to_class AppPage
    type 'HAS_CONNECTION'

    property :count, type: Integer
    property :probability, type: Float

  end
end
