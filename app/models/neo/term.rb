module Neo
  class Term
    include Neo4j::ActiveNode

    property :text, index: :exact
    property :eval_id, index: :exact
    property :tf
    property :df
    property :probability

    has_many :both, :categories, rel_class: HasTerms
    has_many :both, :domains, rel_class: HasTerms

  end
end
