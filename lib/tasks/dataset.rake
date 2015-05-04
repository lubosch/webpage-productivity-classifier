require 'csv'

namespace :dataset do
  desc 'Migrate hostname'
  task :hostnames, [:path] => :environment do
    path = File.expand_path('vendor/datasets/DiscoveryChallenge2010.hostnames.txt', Rails.root)
    test_path = File.expand_path('vendor/datasets/en.testing.csv', Rails.root)
    lang_path = File.expand_path('vendor/datasets/v2-host_autolang.csv', Rails.root)
    langs = {}
    test_docs = {}

    CSV.foreach(test_path, :headers => true, col_sep: ';') do |row|
      row = row.to_hash
      test_docs[row['ID']] = row['nowww-ID'] if row['ID'].present?
      test_docs[row['nowww-ID']] = row['ID'] if row['nowww-ID'].present?
    end

    CSV.foreach(lang_path, :headers => true, col_sep: ';') do |row|
      row = row.to_hash
      langs[row['ID']] = row['lang']
    end


    Domain.transaction do

      CSV.foreach(path, :headers => false, col_sep: ' ') do |row|
        alter_id = test_docs[row[1]].to_i if test_docs[row[1]]
        eval_type = 'test' if test_docs.has_key?(row[1])
        lang = langs[row[1]] if langs[row[1]].present?
        Domain.create(name: row[0], eval_type: eval_type, alter_id: alter_id, eval_id: row[1].to_i, lang: lang)
      end

    end
  end

  desc 'Migrate terms'
  task :terms, [:path] => :environment do
    path = File.expand_path('vendor/datasets/top_terms.stopped.en.txt', Rails.root)
    index = 0
    Term.transaction do
      CSV.foreach(path, :headers => false, col_sep: ' ') do |row|
        Term.create(eval_id: index, text: row[0], tf: row[1].to_i, df: row[2].to_i) unless row[0][/\0/]
        index += 1
      end
    end
  end

  desc 'Migrate hostname_terms'
  task :hostname_terms, [:path] => :environment do
    path = File.expand_path('vendor/datasets/v2-host_tfdf.en.txt', Rails.root)
    docs = []
    index = 0
    CSV.foreach(path, :headers => false, col_sep: ' ') do |data|
      domain_id = data.shift.to_i
      data.each_slice(3).each do |row|
        index += 1
        docs.push(sql_insert_query_sanitizer(domain_id, row[0].to_i, row[1].to_i, row[2].to_i))
        if index%200_000 == 0
          sql_insert_query_executer(DomainTerm, docs, 'domain_id, term_id, tf, df')
          docs.clear
          puts index
        end
      end
    end
  end

  def sql_insert_query_sanitizer(*columns)
    if columns[0].is_a? Array
      "(#{columns[0].map { |value| ActiveRecord::Base::sanitize(value) }.join(', ')})"
    else
      "(#{columns.map { |value| ActiveRecord::Base::sanitize(value) }.join(', ')})"
    end
  end

  def sql_insert_query_executer(insert_class, inserts, columns)
    inserts.compact!
    unless inserts.blank?
      query = "INSERT INTO #{insert_class.table_name} (#{columns}) VALUES #{inserts.join(', ')}"
      ActiveRecord::Base.connection.execute(query)
    end
  end

  desc 'Migrate labels'
  task :labels, [:path] => :environment do
    path = File.expand_path('vendor/datasets/v2-en.labels.csv', Rails.root)
    Label.transaction do

      CSV.foreach(path, :headers => true, col_sep: ';') do |row|
        data = row.to_hash
        adult = 1 if data['Adult Content'] == 'Adult'
        adult = 0 if data['Adult Content'] == 'NonAdult'

        spam = 1 if data['Web Spam'] == 'Spam'
        spam = 0 if data['Web Spam'] == 'NonSpam'

        news_editorial = 1 if data['News/Editorial'] == 'News-Edit'
        news_editorial = 0 if data['News/Editorial'] == 'NonNews-Edit'

        commercial = 1 if data['Commercial'] == 'Commercial'
        commercial = 0 if data['Commercial'] == 'NonCommercial'

        educational_research = 1 if data['Educational/Research'] == 'Educational'
        educational_research = 0 if data['Educational/Research'] == 'NonEducational'

        discussion = 1 if data['Discussion'] == 'Discussion'
        discussion = 0 if data['Discussion'] == 'NonDiscussion'

        personal_leisure = 1 if data['Personal/Leisure'] == 'Personal-Leisure'
        personal_leisure = 0 if data['Personal/Leisure'] == 'NonPersonal-Leisure'

        media = 1 if data['Media'] == 'Media'
        media = 0 if data['Media'] == 'NonMedia'

        database = 1 if data['Database'] == 'Database'
        database = 0 if data['Database'] == 'NonDatabase'

        readability_vis = data['Readability-Vis'].to_i if data['Readability-Vis'].present?
        readability_lang = data['Readability-Lang'].to_i if data['Readability-Lang'].present?
        neutrality = data['Neutrality'].to_i if data['Neutrality'].present?
        bias = data['Bias'].to_i if data['Bias'].present?
        trustiness = data['Trustiness'].to_i if data['Trustiness'].present?

        confidence = 1 if data['Confidence'] == 'Sure'
        confidence = 0 if data['Confidence'] == 'Unsure'

        Label.create(
            eval_id: data['ID'], www_id: data['wwwID'], nowww_id: data['nowwwID'], assessor_id: data['UserID'], adult: adult, spam: spam,
            news_editorial: news_editorial, commercial: commercial, educational_research: educational_research, discussion: discussion,
            personal_leisure: personal_leisure, media: media, database: database, readability_vis: readability_vis,
            readability_lang: readability_lang, neutrality: neutrality, bias: bias, trustiness: trustiness, confidence: confidence
        )

      end
    end
  end

end
