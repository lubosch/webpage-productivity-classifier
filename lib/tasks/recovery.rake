require 'csv'

namespace :recovery do
  desc 'referrers'
  task :referrer, [:path] => :environment do
    # path = '/media/fred/Data/Skola/Diplomka/datasets/unicorn-stay_productive.referrer.log'
    #
    # a = 0
    # File.open(path).each_line do |line|
    #   a += 1
    #   next if a <= 8176
    #   clear_line = line.gsub(/^  Parameters: /, '')
    #   params = eval(clear_line).inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo }
    #   application = Application.find_or_create_by_params(params[:url])
    #   ap = ApplicationPage.where(application: application, url: params[:url]).last
    #   if ap
    #     neo_app = ap.find_or_create_neo_app_page
    #     neo_app.set_referrer(params[:referrer]) if params[:referrer].present?
    #   else
    #     ApplicationPage.find_or_create_by_params(params)
    #   end
    #   puts a
    # end

  end

  desc 'switches'
  task :switches, [:path] => :environment do
    # path = '/media/fred/Data/Skola/Diplomka/datasets/unicorn-stay_productive.cypher.log'
    path = '/media/fred/Data/Skola/Diplomka/datasets/unicorn-stay_productive.count3.log'


    last_rel_id = -1
    penalty = true
    penalty_c = 0
    a = 0
    File.open(path).each_line do |line|
      last_i = line.reverse.index("\e")
      clear_line = line[(line.length - last_i)..-2]
      clear_line = clear_line[clear_line.index(' ')+1..-1]


      if clear_line.index('|')
        params = eval(clear_line[/\|.*/][2..-1])
        query = clear_line[0..clear_line.index('|')-2]
        # binding.pry
        if query.index('SET')
          params[:neo_id] = last_rel_id
          # binding.pry
          if penalty
            penalty_c += 1
          else
            Neo4j::Session.current.query(query, params)
          end
        else
          if Neo4j::Session.current.query(query, params).count > 0
            last_rel_id = Neo4j::Session.current.query(query, params).first.values[0].neo_id
            penalty = false
          else
            penalty = true
          end
        end
        # Neo4j::Session.current.query(query, params)
        if a%100 == 0
          puts a
          puts penalty_c
        end

        a+=1
      end
    end

    puts a
    puts penalty_c

  end

end
