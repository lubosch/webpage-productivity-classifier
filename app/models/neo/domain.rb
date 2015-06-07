module Neo
  class Domain
    include Neo4j::ActiveNode

    property :name, index: :exact
    property :eval_id, index: :exact
    property :eval_type
    property :lang

    has_many :both, :categories, origin: :category
    has_many :both, :terms, rel_class: HasTerms
    has_many :both, :labels, rel_class: HasLabels

  end
end
