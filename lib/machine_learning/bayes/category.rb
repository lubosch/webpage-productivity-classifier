module MachineLearning
  module Bayes
    class Category
      attr_accessor :prior_probability, :term_probabilities

      def initialize(name)
        @prior_probability = Probability.new(name)
        @term_probabilities = {}
      end

      def recalculate_probabilities
        sum = @term_probabilities.sum {|_n, probability| probability.count}
        @term_probabilities.each_value { |probability| probability.recalculate_probability(sum) }
      end

      def recalculate_prior_probability(sum)
        prior_probability.recalculate_probability(sum)
      end


      def add_terms(domains)
        domains.each do |domain|
          domain.domain_terms.each do |dt|
            @term_probabilities[dt.term_text].count += dt.tf
          end
        end
      end

    end
  end
end
