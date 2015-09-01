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


    Application.transaction do

      CSV.foreach(path, :headers => false, col_sep: ' ') do |row|
        alter_id = test_docs[row[1]].to_i if test_docs[row[1]]
        eval_type = 'test' if test_docs.has_key?(row[1])
        lang = langs[row[1]] if langs[row[1]].present?
        Application.create(name: row[0], eval_type: eval_type, alter_id: alter_id, eval_id: row[1].to_i, lang: lang)
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
      application_id = data.shift.to_i
      data.each_slice(3).each do |row|
        index += 1
        docs.push(sql_insert_query_sanitizer(application_id, row[0].to_i, row[1].to_i, row[2].to_i))
        if index%200_000 == 0
          sql_insert_query_executer(ApplicationTerm, docs, 'application_id, term_id, tf, df')
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

  desc 'convert to category_terms'
  task :category_terms, [:path] => :environment do
    ActivityType.destroy_all
    categories = {}
    categories_all = [:adult, :spam, :news_editorial, :commercial, :educational_research, :discussion, :personal_leisure, :media, :database]
    categories_all.map { |category| categories[category]= ActivityType.create(:name => category, :count => 0) }

    ActivityTypeTerm.transaction do
      Label.no_test.includes(:application).all.each_with_index do |label, index|
        categories_all.each do |category|
          categories[category].add_terms(label.application) if label[category] == 1
        end
        puts index if index%10 == 0
      end
      categories.each_value(&:save_terms)
      categories.each_value(&:update_probabilities)
    end

    ActivityType.update_all_probabilities
    Term.update_probabilities
  end

  desc 'copy to neo4j'
  task :clone_to_neo4j, [:path] => :environment do
    applications = {}
    categories = {}
    terms = {}
    terms_ids = {}

    #TODO: firstly remove all in cypher query

    i = 0
    ActivityType.all.each do |cat|
      categories[cat.id] = Neo::Category.create(name: cat.name, count: cat.count, probability: cat.probability, vocabulary_size: cat.vocabulary_size, terms_count: cat.terms_count, default_multinomial: cat.default_multinomial)
      i+=1
      puts "category #{i}" if i%1000 == 0
    end

    Term.all.each do |term|
      terms_ids[term.id] = terms[term.eval_id] = Neo::Term.create(text: term.text, eval_id: term.eval_id, tf: term.tf, df: term.df, probability: term.probability)
      i+=1
      puts "term #{i}" if i%1000 == 0
    end


    ActivityTypeTerm.all.each do |cat_term|
      Neo::HasTerm.create(from_node: categories[cat_term.activity_type_id], to_node: terms_ids[cat_term.term_id], count: cat_term.count, probability: cat_term.probability, multinomial_probability: cat_term.multinomial_probability)
      i+=1
      puts "category term #{i}" if i%1000 == 0
    end

    categories.clear
    terms_ids.clear

    Application.all.each do |application|
      applications[application.eval_id] = Neo::Domain.create(:name => application.name, :eval_id => application.eval_id, :eval_type => application.eval_type, :lang => application.lang)
      i+=1
      puts "domain #{i}" if i%1000 == 0
    end


    ApplicationTerm.all.each do |dt|
      Neo::HasTerm.create(from_node: applications[dt.application_id], to_node: terms[dt.term_id], count: dt.tf)
      i+=1
      puts "domain term #{i}" if i%1000 == 0
    end
    terms.clear

    labels = {}
    labels[:adult] = Neo::Label.create(:text => 'adult')
    labels[:spam] = Neo::Label.create(:text => 'spam')
    labels[:news_editorial] = Neo::Label.create(:text => 'news_editorial')
    labels[:commercial] = Neo::Label.create(:text => 'commercial')
    labels[:educational_research] = Neo::Label.create(:text => 'educational_research')
    labels[:discussion] = Neo::Label.create(:text => 'discussion')
    labels[:personal_leisure] = Neo::Label.create(:text => 'personal_leisure')
    labels[:media] = Neo::Label.create(:text => 'media')
    labels[:database] = Neo::Label.create(:text => 'database')

    Label.all.each do |label|
      new_labels = []
      new_labels << :adult if label[:adult] == 1
      new_labels << :spam if label[:spam] == 1
      new_labels << :news_editorial if label[:news_editorial] == 1
      new_labels << :commercial if label[:commercial] == 1
      new_labels << :educational_research if label[:educational_research] == 1
      new_labels << :discussion if label[:discussion] == 1
      new_labels << :personal_leisure if label[:personal_leisure] == 1
      new_labels << :media if label[:media] == 1
      new_labels << :database if label[:database] == 1

      new_labels.each do |nl|
        Neo::HasLabel.create(
            from_node: applications[label.application_id],
            to_node: labels[nl],
            assessor_id: label.assessor_id,
            readability_vis: label.readability_vis,
            readability_lang: label.readability_lang,
            neutrality: label.neutrality,
            bias: label.bias,
            trustiness: label.trustiness,
            confidence: label.confidence
        )
      end

      i+=1
      puts "labels #{i}" if i%1000 == 0
    end
  end

  desc 'convert to category_terms'
  task :applications_to_neo4j, [:path] => :environment do
    i = 0
    Application.all.each do |application|
      Neo::AppPage.create(:eval_id => application.eval_id)
      i+=1
      puts "domain #{i}" if i%1000 == 0
    end

  end


  desc 'convert to category_terms'
  task :links_to_neo4j, [:path] => :environment do
    path = File.expand_path('vendor/datasets/v2-DiscoveryChallenge2010.hostgraph_weighted.graph-txt', Rails.root)

    hosts = {}
    Neo::AppPage.all.each { |host| hosts[host.eval_id] = host }
    index = 0
    CSV.foreach(path, :headers => false, col_sep: ' ') do |row|
      sum = row.sum { |r| r.split(':')[1].to_i }.to_f
      row.each do |link|
        to = link.split(':')[0].to_i
        count = link.split(':')[1].to_i
        if hosts[index] && hosts[to]
          Neo::HasLink.create(from_node: hosts[index], to_node: hosts[to], count: count, probability: count/sum)
          Neo::HasConnection.create(from_node: hosts[to], to_node: hosts[index], count: count, probability: count/sum)
        end
      end

      puts "links #{index}" if index%1000 == 0
      index += 1
    end

  end

end
