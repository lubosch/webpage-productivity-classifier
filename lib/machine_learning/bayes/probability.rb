module MachineLearning
  module Bayes
    class Probability
      attr_accessor :count, :probability, :name

      def initialize(name)
        @name = name
        @count = 0
      end

      def recalculate_probability(sum)
        @probability = @count / sum.to_f
      end
    end
  end
end
