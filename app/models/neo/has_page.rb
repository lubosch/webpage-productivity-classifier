module Neo
  class HasPage
    include Neo4j::ActiveRel

    from_class App
    to_class AppPage
    type 'HAS_APP'

  end
end
