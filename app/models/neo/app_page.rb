module Neo
  class AppPage
    include Neo4j::ActiveNode

    property :url, type: String, index: :exact
    property :id, type: Integer, index: :exact

    has_many :out, :to_hosts, rel_class: Neo::HasLink, model_class: Neo::AppPage
    has_many :in, :from_hosts, rel_class: Neo::HasLink, model_class: Neo::AppPage
    has_many :out, :to_switch, rel_class: Neo::HasSwitch, model_class: Neo::AppPage
    has_many :in, :from_switch, rel_class: Neo::HasSwitch, model_class: Neo::AppPage
    has_one :both, :app, rel_class: Neo::HasPage, model_class: Neo::App

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

    def application_page
      ApplicationPage.find_by_id(id)
    end

    def self.find_or_create_by_id(id, url, application_id, application_url)
      app_page = find_or_create_by(url: url)
      app_page.update(id: id) if id != app_page.id
      app_page.connect_app(application_id, application_url)
      app_page
    end

    def connect_app(application_id, application_url)
      unless app
        app = App.find_or_create_by(id: application_id)
        app.update(url: application_url)
        update(app: app)
      end
    end

    def set_referrer(referrer)
      app_page = from_hosts.where(url: referrer).first || AppPage.find_by(url: referrer)
      if app_page
        link = app_page.to_hosts.first_rel_to(self) || HasLink.new(from_node: app_page, to_node: self, count: 0)
        link.count += 1
        link.save
      end
    end

    def set_switch(referrer)
      app_page = from_switch.where(url: referrer).first || AppPage.find_by(url: referrer)
      if app_page
        link = app_page.to_switch.first_rel_to(self) || HasSwitch.new(from_node: app_page, to_node: self, count: 0)
        link.count += 1
        link.save
      end
    end

  end
end
