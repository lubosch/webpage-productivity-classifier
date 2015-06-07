module Neo
  class HasTerm
    include Neo4j::ActiveRel

    from_class :any
    to_class Term
    type 'HAS_TERM'

    property :count, type: Integer
    property :probability, type: Float
    property :multinomial_probability, type: Float

  end
end
