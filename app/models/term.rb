# == Schema Information
#
# Table name: terms
#
#  id          :integer          not null, primary key
#  eval_id     :integer
#  text        :string
#  ttf         :integer
#  df          :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  probability :decimal(, )
#

class Term < ActiveRecord::Base

  has_many :activity_type_terms
  has_many :application_terms

  def self.update_probabilities
    sum = Term.sum(:ttf)
    Term.update_all("probability = ttf / #{sum.to_f}")
  end

  def self.create_terms_from_sentence(sentence)
    words = sentence.split.map(&:stem)
    create_terms_from_array(words)
  end

  def self.create_terms_from_array(words)
    terms = {}
    words.map do |word, count|
      term = where(text: word).first_or_initialize(ttf: 0, df: 0, probability: 0.0)
      term.ttf += count || 1
      term.save
      terms[term] = count
    end
    terms
  end

  def self.create_text_terms(sentences)
    words = {}
    sentences.(&:split).flatten.each { |word| words[word] ? words[word] += 1 : words[word] = 1 }
    create_terms_from_array(words)
  end


end
