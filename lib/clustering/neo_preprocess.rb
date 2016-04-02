module Clustering
  class NeoPreprocess
    def self.simple_weights(w1, w2)

      file_path = 'lib/experiment_files/oslom.dat'
      sf = File.open(file_path, 'w')

      Neo::AppPage.find_each do |app_page|
        app_page.to_hosts.each_with_rel do |app_page_dest, rel|
          sf.puts("#{app_page.application_page_id}\t#{app_page_dest.application_page_id}\t#{w1}\t#{rel.count}")
        end

        app_page.to_switch.each_with_rel do |app_page_dest, rel|
          sf.puts("#{app_page.application_page_id}\t#{app_page_dest.application_page_id}\t#{w2}\t#{rel.count}")
        end
      end
      sf.close
      file_path
    end

    def self.simple_weights_links

      file_path = 'lib/experiment_files/oslom_links.dat'
      sf = File.open(file_path, 'w')

      Neo::AppPage.find_each do |app_page|
        app_page.to_hosts.each_with_rel do |app_page_dest, rel|
          sf.puts("#{app_page.application_page_id}\t#{app_page_dest.application_page_id}\t#{rel.count}")
        end
      end
      sf.close
      file_path
    end

    def self.simple_weights_switches
      file_path = 'lib/experiment_files/oslom_sw.dat'
      sf = File.open(file_path, 'w')

      Neo::AppPage.find_each do |app_page|
        app_page.to_switch.each_with_rel do |app_page_dest, rel|
          sf.puts("#{app_page.application_page_id}\t#{app_page_dest.application_page_id}\t#{rel.count}")
        end
      end
      sf.close
      file_path
    end

    def self.applications_weights(w1, w2)
      file_path = 'lib/experiment_files/app_oslom.dat'
      sf = File.open(file_path, 'w')

      Neo::AppPage.find_each do |app_page|
        app_page.to_hosts.each_with_rel do |app_page_dest, rel|
          sf.puts("#{app_page.application_id}\t#{app_page_dest.application_id}\t#{w1}\t#{rel.count}") if app_page.application_id && app_page_dest.application_id
        end

        app_page.to_switch.each_with_rel do |app_page_dest, rel|
          sf.puts("#{app_page.application_id}\t#{app_page_dest.application_id}\t#{w2}\t#{rel.count}") if app_page.application_id && app_page_dest.application_id
        end
      end
      sf.close
      file_path
    end

    def self.applications_weights_links
      file_path = 'lib/experiment_files/app_oslom_links.dat'
      sf = File.open(file_path, 'w')

      Neo::AppPage.find_each do |app_page|
        app_page.to_hosts.each_with_rel do |app_page_dest, rel|
          sf.puts("#{app_page.application_id}\t#{app_page_dest.application_id}\t#{rel.count}") if app_page.application_id && app_page_dest.application_id
        end
      end
      sf.close
      file_path
    end

    def self.applications_weights_switches
      file_path = 'lib/experiment_files/app_oslom_sw.dat'
      sf = File.open(file_path, 'w')

      Neo::AppPage.find_each do |app_page|
        app_page.to_switch.each_with_rel do |app_page_dest, rel|
          sf.puts("#{app_page.application_id}\t#{app_page_dest.application_id}\t#{rel.count}") if app_page.application_id && app_page_dest.application_id
        end
      end
      sf.close
      file_path
    end

  end
end

# Clustering::NeoPreprocess.simple_weights
# Clustering::NeoPreprocess.simple_weights_links
# Clustering::NeoPreprocess.simple_weights_switches
# Clustering::NeoPreprocess.applications_weights
# Clustering::NeoPreprocess.applications_weights_links
# Clustering::NeoPreprocess.applications_weights_switches

