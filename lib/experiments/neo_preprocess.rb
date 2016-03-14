module Experiments
  class NeoPreprocess
    def self.simple_weights

      sf = File.open('s.txt', 'w')
      tf = File.open('t.txt', 'w')
      wf = File.open('w.txt', 'w')

      s = []
      d = []
      w = []
      a = 0
      # sf.write('s = [')
      # tf.write('t = [')
      # wf.write('w = [')

      Neo::AppPage.find_each do |app_page|
        app_page.to_hosts.each_with_rel do |app_page_dest, rel|
          s << app_page.application_page_id
          d << app_page_dest.application_page_id
          w << rel.count
          sf.write("#{app_page.application_page_id} ")
          tf.write("#{app_page_dest.application_page_id} ")
          wf.write("2 ")
        end

        app_page.to_switch.each_with_rel do |app_page_dest, rel|
          s << app_page.application_page_id
          d << app_page_dest.application_page_id
          w << 1

          sf.write("#{app_page.application_page_id} ")
          tf.write("#{app_page_dest.application_page_id} ")
          wf.write("1 ")

        end

        puts "****************** #{a} ************************" if a%100 == 0
        puts "****************** #{a} ************************" if a%100 == 0
        puts "****************** #{a} ************************" if a%100 == 0
        a+=1
      end
      # sf.write(']')
      # tf.write(']')
      # wf.write(']')
      sf.close
      tf.close
      wf.close

      binding.pry
    end

  end
end

# Experiments::NeoPreprocess.simple_weights

