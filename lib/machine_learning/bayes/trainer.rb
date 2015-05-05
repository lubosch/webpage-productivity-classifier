module MachineLearning
  module Bayes
    class Trainer
      include Singleton

      CATEGORIES = [:adult, :spam, :news_editorial, :commercial, :educational_research, :discussion, :personal_leisure, :media, :database]
      attr_accessor :categories
      attr_accessor :terms

      def initialize
        init_categories
        init_terms
      end

      def init_categories
        @categories = {}
        CATEGORIES.each { |category| @categories[category] = Category.new(category) }
      end

      def init_terms
        @terms = {}
      end

      def prior_probabilities(labels)
        init_categories
        labels.each do |label|
          add_label(label)
        end
        recalculate_category_prior_probabilities
      end

      def general_probabilities(terms)
        init_terms
        terms.each { |term| add_term(term) }
        recalculate_probabilities(@terms)
      end

      def add_term(term)
        @terms[term.text] ||= Probability.new(term.text)
        @terms[term.text].count += term.tf
      end

      def add_label_and_recalculate(label)
        add_label(label)
        recalculate_category_prior_probabilities
      end

      def add_label(label)
        CATEGORIES.each { |category| @categories[category].prior_probability.count += 1 if label[category] == 1 }
      end

      def recalculate_probabilities(collection)
        sum = collection.sum { |_name, item| item.count }
        collection.each { |_name, item| item.recalculate_probability(sum) }
      end

      def recalculate_category_probabilities
        @categories.each { |_name, category| category.recalculate_probabilities }
      end

      def recalculate_category_prior_probabilities
        sum = @categories.sum { |_name, category| category.prior_probability.count }
        @categories.each { |_name, category| category.recalculate_prior_probability(sum) }
      end

      def term_probabilities(labels)
        labels.each do |label|
          CATEGORIES.each do |category|
            @categories[category].add_terms(label.domains) if label[category] == 1
          end
        end
        recalculate_category_probabilities
      end

    end
  end
end