module Clustering
  class NeoPrecomputation

    def self.link_probabilities
      a = 0
      Neo::AppPage.find_each do |app_page|
        hosts_count = app_page.rels(dir: :outgoing, type: :HAS_LINK).sum(&:count).to_f
        dest_hosts_count = app_page.rels(dir: :incoming, type: :HAS_LINK).sum(&:count).to_f

        app_page.rels(dir: :outgoing, type: :HAS_LINK).each { |to_host| to_host.update(probability: to_host.count/hosts_count) }
        app_page.rels(dir: :incoming, type: :HAS_LINK).each { |from_host| from_host.update(dest_probability: from_host.count/dest_hosts_count) }

        switches_count = app_page.rels(dir: :outgoing, type: :HAS_SWITCH).sum(&:count).to_f
        dest_switches_count = app_page.rels(dir: :incoming, type: :HAS_SWITCH).sum(&:count).to_f
        app_page.rels(dir: :outgoing, type: :HAS_SWITCH).each { |to_switch| to_switch.update(probability: to_switch.count/switches_count) }
        app_page.rels(dir: :incoming, type: :HAS_SWITCH).each { |from_switch| from_switch.update(dest_probability: from_switch.count/dest_switches_count) }

        puts a if a%1000 == 0
        a+=1
      end
    end

  end
end

# Clustering::NeoPrecomputation.link_probabilities
