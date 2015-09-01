module Neo
  class HasLink
    include Neo4j::ActiveRel

    from_class AppPage
    to_class AppPage
    type 'HAS_LINK'

    property :count, type: Integer
    property :probability, type: Float

  end
end
