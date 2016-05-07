module Clustering
  class NeoPrecomputation

    def self.link_probabilities
      a = 0
      Neo::AppPage.find_each do |app_page|
        hosts_count = app_page.to_hosts.count.to_f
        app_page.to_hosts.each_with_rel { |_host, to_host| to_host.update(probability: to_host.count/hosts_count) }

        switches_count = app_page.to_switch.count.to_f
        app_page.to_switch.each_with_rel { |_switch, to_switch| to_switch.update(probability: to_switch.count/switches_count) }

        puts a if a%1000 == 0
        a+=1
      end
    end

    def nodes_probabilities
      a = 0
      Neo::AppPage.find_each do |app_page|
        hosts_count = app_page.from_hosts.count.to_f
        app_page.to_hosts.each_with_rel { |_host, to_host| to_host.update(probability: to_host.count/hosts_count) }

        switches_count = app_page.to_switch.count.to_f
        app_page.to_switch.each_with_rel { |_switch, to_switch| to_switch.update(probability: to_switch.count/switches_count) }

        puts a if a%1000 == 0
        a+=1
      end

    end

  end
end

# Clustering::NeoPrecomputation.link_probabilities
