require 'csv'

namespace :dataset do
  desc 'Migrate hostname'
  task :hostnames, [:path] => :environment do
    path = File.expand_path('vendor/datasets/DiscoveryChallenge2010.hostnames.txt', Rails.root)
    test_path = File.expand_path('vendor/datasets/en.testing.csv', Rails.root)
    test_docs = {}

    CSV.foreach(test_path, :headers => true, col_sep: ';') do |row|
      row = row.to_hash
      test_docs[row['ID']] = {name: row['www-domain'], alter_id: row['nowww-ID'].to_i} if row['ID']
      test_docs[row['nowww-ID']] = {name: row['nowww-domain'], alter_id: row['ID'].to_i} if row['nowww-ID']
    end

    Domain.transaction do

      CSV.foreach(path, :headers => false, col_sep: ' ') do |row|
        alter_id = test_docs[row[1]][:alter_id] if test_docs[row[1]]
        eval_type = 'test' if test_docs[row[1]].present?
        Domain.create(name: row[0], eval_type: eval_type, alter_id: alter_id, eval_id: row[1].to_i)
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

end
