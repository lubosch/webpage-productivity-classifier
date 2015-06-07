module Neo
  class Term
    include Neo4j::ActiveNode

    property :text, index: :exact
    property :eval_id, type: Integer, index: :exact
    property :tf, type: Integer
    property :df, type: Integer
    property :probability, type: Float

    has_many :both, :categories, rel_class: HasTerm
    has_many :both, :domains, rel_class: HasTerm

  end
end
