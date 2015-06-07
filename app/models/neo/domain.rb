module Neo
  class Domain
    include Neo4j::ActiveNode

    property :name, index: :exact
    property :eval_id, type: Integer, index: :exact
    property :eval_type
    property :lang

    has_many :both, :categories, origin: :category
    has_many :both, :terms, rel_class: HasTerm
    has_many :both, :labels, rel_class: HasLabel

  end
end
