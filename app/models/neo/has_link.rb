module Neo
  class HasLink
    include Neo4j::ActiveRel

    from_class Neo::AppPage
    to_class Neo::AppPage
    type 'HAS_LINK'

    property :count, type: Integer
    property :probability, type: Float
    property :dest_probability, type: Float


  end
end
