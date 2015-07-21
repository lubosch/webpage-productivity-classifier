module Neo
  class Host
    include Neo4j::ActiveNode

    property :eval_id, type: Integer, index: :exact

    has_many :out, :hosts, rel_class: HasLink
    has_many :in, :hosts, rel_class: HasConnection

  end
end
