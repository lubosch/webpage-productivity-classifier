module Neo
  class Category
    include Neo4j::ActiveNode

    property :name, index: :exact
    property :count
    property :probability
    property :vocabulary_size
    property :terms_count
    property :default_multinomial

    has_many :both, :domain
    has_many :both, :terms, rel_class: HasTerms
  end
end
