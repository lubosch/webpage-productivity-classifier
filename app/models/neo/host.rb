module Neo
  class Host
    include Neo4j::ActiveNode

    property :eval_id, type: Integer, index: :exact

    has_many :out, :to_hosts, rel_class: HasLink, model_class: Host
    has_many :in, :from_hosts, rel_class: HasConnection, model_class: Host

    def classify(level, probability)
      if level == 0
        classes = {}
      else
        factor = 100*(4-level)/6.to_f*probability
        classes = application.evaluated_classes
        classes = Hash[*classes.map { |klass| [klass, factor] }.flatten]
      end
      # puts "classes #{classes} #{level}"

      if level <= 2
        from_hosts.each_with_rel do |host, connection|
          if host != self
            new_classification = host.classify(level+1, connection.probability)
            classes = new_classification.merge(classes) { |_k, a_value, b_value| a_value + b_value }
          end
        end
      end

      return classes
    end

    def application
      Application.find_by_eval_id(eval_id)
    end


  end
end
