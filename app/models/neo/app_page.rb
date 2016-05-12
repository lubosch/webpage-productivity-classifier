module Neo
  class AppPage
    include Neo4j::ActiveNode

    property :url, type: String, index: :exact
    property :application_page_id, type: Integer, index: :exact

    has_many :out, :to_hosts, rel_class: Neo::HasLink, model_class: Neo::AppPage
    has_many :in, :from_hosts, rel_class: Neo::HasLink, model_class: Neo::AppPage
    has_many :out, :to_switch, rel_class: Neo::HasSwitch, model_class: Neo::AppPage
    has_many :in, :from_switch, rel_class: Neo::HasSwitch, model_class: Neo::AppPage
    has_one :both, :app, rel_class: Neo::HasPage, model_class: Neo::App

    def application_id
      app.application_id if app
    end

    def classify(levels)
      ranked_nodes = {self.neo_id => 0}
      new_nodes = [[self, 1]]
      (1..levels).each do |lvl|

        new_nodes = new_nodes.map { |node| node[0].new_knn_network(lvl, node[1], ranked_nodes) }.flatten
        new_nodes = new_nodes.select { |hash| hash.values.first > 0.001 }
        new_nodes.sort_by { |hash| 0-hash.values.first } if new_nodes.size > 100
        new_nodes = new_nodes[0..100].map { |hash| [hash.keys.first, hash.values.first] }
        # binding.pry
        # puts "******** #{lvl} ******"
      end
      ranked_nodes[self.neo_id] = 0
      classify_ranked_network(ranked_nodes)
    end

    def classify_ranked_network(ranked_nodes)
      classes = {}

      # binding.pry
      ranked_nodes = ranked_nodes.select { |_key, prob| prob > 0.001 }

      app_pages = Neo::AppPage.where(neo_id: ranked_nodes.keys)
      app_pages_ids = app_pages.map(&:application_page_id)
      application_pages = ApplicationPage.where(id: app_pages_ids)
      app_pages.each do |app_page|

        # app_page = Neo::AppPage.find_by(neo_id: neo_id)
        application_page = application_pages.find { |ap| ap.id == app_page.application_page_id }
        eval_classes = application_page && application_page.evaluated_classes || []
        # eval_classes = application_page && application_page.evaluated_classes_w || []
        eval_classes.each do |klass|
          classes[klass] ||= 0
          classes[klass] += ranked_nodes[app_page.neo_id]
        end
      end
      classes
    end

    def new_knn_network(level, probability, old_nodes={})
      new_nodes = []
      # if level == 0
      # else
      # link_factor = 1 #(6-level)/15.to_f*probability
      link_factor = probability
      # classes = application_page && application_page.evaluated_classes || []
      # classes = Hash[*classes.map { |klass| [klass, factor] }.flatten]
      # end
      #
      from_hosts_count = rels(dir: :incoming, type: :HAS_LINK).sum(&:count).to_f
      from_hosts.each_with_rel do |host, connection|
        # new_probability = (connection.probability || 1)*link_factor*(connection.dest_probability || 1)
        new_probability = connection.count/from_hosts_count
        # new_probability = 1
        if old_nodes.keys.include?(host.neo_id)
          old_nodes[host.neo_id] += new_probability
        else
          old_nodes[host.neo_id] = new_probability
          new_nodes << {host => new_probability}
        end
      end


      to_hosts_count = rels(dir: :outgoing, type: :HAS_LINK).sum(&:count).to_f
      to_hosts.each_with_rel do |host, connection|
        # new_probability = (connection.probability || 1)*link_factor*(connection.dest_probability || 1)
        new_probability = connection.count/to_hosts_count
        # new_probability = 1
        if old_nodes.keys.include?(host.neo_id)
          old_nodes[host.neo_id] += new_probability
        else
          old_nodes[host.neo_id] = new_probability
          new_nodes << {host => new_probability}
        end
      end


      from_switch_count = rels(dir: :incoming, type: :HAS_SWITCH).sum(&:count).to_f
      from_switch.each_with_rel do |host, connection|
        # new_probability = (connection.probability || 1)*link_factor*(connection.dest_probability || 1)
        new_probability = connection.count/from_switch_count
        # new_probability = 1
        if old_nodes.keys.include?(host.neo_id)
          old_nodes[host.neo_id] += new_probability
        else
          old_nodes[host.neo_id] = new_probability
          new_nodes << {host => new_probability}
        end
      end

      to_switch_count = rels(dir: :outgoing, type: :HAS_SWITCH).sum(&:count).to_f
      to_switch.each_with_rel do |host, connection|
        # new_probability = (connection.dest_probability || 1)*link_factor*(connection.dest_probability || 1)
        new_probability = connection.count/to_switch_count
        # new_probability = 1
        if old_nodes.keys.include?(host.neo_id)
          old_nodes[host.neo_id] += new_probability
        else
          old_nodes[host.neo_id] = new_probability
          new_nodes << {host => new_probability}
        end
      end


      # new_nodes.each { |nn| nn.classify(level+1, 1, old_nodes) }
      return new_nodes
      # old_nodes

      # classes
    end

    def application_page
      ApplicationPage.find_by_id(self.application_page_id)
    end

    def self.find_or_create_by_id(id, url, application_id, application_url)
      app_page = find_or_create_by(application_page_id: id)
      app_page.update(url: url) if url != app_page.url
      app_page.connect_app(application_id, application_url)
      app_page
    end

    def connect_app(application_id, application_url)
      app = App.find_or_create_by(application_id: application_id)
      app.url = application_url
      app.save
      update(app: app)
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
