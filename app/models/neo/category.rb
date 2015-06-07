module Neo
  class Category
    include Neo4j::ActiveNode

    property :name, index: :exact
    property :count, type: Integer
    property :probability, type: Float
    property :vocabulary_size, type: Integer
    property :terms_count, type: Integer
    property :default_multinomial, type: BigDecimal

    has_many :both, :domains, origin: :domain
    has_many :both, :terms, rel_class: HasTerm
  end
end
