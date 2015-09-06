module Neo
  class HasPage
    include Neo4j::ActiveRel

    from_class Neo::App
    to_class Neo::AppPage
    type 'HAS_APP'

  end
end
