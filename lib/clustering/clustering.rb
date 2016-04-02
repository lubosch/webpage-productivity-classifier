module Clustering
  class Clustering

    def self.cluster(method, w1=nil, w2=nil)
      file_path = ''
      if w1 && w2
        file_path = NeoPreprocess.send(method, w1, w2)
        system "#{ENV['OSLOM2_PATH']} -f #{file_path} -w"
      else
        file_path = NeoPreprocess.send(method)
        system "#{ENV['OSLOM2_PATH']} -f #{file_path} -uw"
      end

      "#{file_path}_oslo_files/tp"
    end


    def self.analyze_clusters(result_file_path)
      clusters = {}
      a = 1
      File.open(result_file_path) do |f|
        f.each do |line|
          clusters[a/2] = line.split.map(&:to_i) if a%2 == 0 # each 2nd line
          a+=1
        end
      end
      clusters
    end

    def self.cluster_applications
       path = cluster(:applications_weights, 5, 1)
       clusters = analyze_clusters(path)
       ApplicationCluster.create_application_clusters(clusters)
    end

    def self.cluster_application_pages
      path = cluster(:simple_weights, 5, 1)
      clusters = analyze_clusters(path)
      ApplicationCluster.create_application_page_clusters(clusters)
      # path = cluster(:simple_weights_links)
      # path = cluster(:simple_weights_switches)
    end

  end
end

# Clustering::Clustering.cluster(:simple_weights, 5, 1)