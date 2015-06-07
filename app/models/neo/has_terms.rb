module Neo
  class HasTerms
    include Neo4j::ActiveRel

    from_class :any
    to_class Category
    type 'HAS_TERM'

    property :count
    property :probability
    property :multinomial_probability

  end
end
