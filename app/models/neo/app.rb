module Neo
  class App
    include Neo4j::ActiveNode

    property :eval_id, type: Integer, index: :exact
    property :application_id, type: Integer, index: :exact
    property :url, type: String, index: :exact

    has_many :both, :app_pages, rel_class: Neo::HasPage, model_class: Neo::AppPage

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

      classes
    end

    def application
      Application.find_by_id(self.application_page_id)
    end


  end
end
