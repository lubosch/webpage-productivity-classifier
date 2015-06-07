module Neo
  class Label
    include Neo4j::ActiveNode

    property :text, index: :exact

    has_many :both, :domains, rel_class: HasLabel

  end
end
