class Admin::DashboardController < ApplicationController
  def training
  end

  def train_bayes
    labels = Label.includes(:domain)
    MachineLearning::Bayes::Trainer.instance.prior_probabilities(labels)
    terms = Term.all
    MachineLearning::Bayes::Trainer.instance.general_probabilities(terms)

    labels = Label.includes(:domain => {:domain_terms => terms})
    MachineLearning::Bayes::Trainer.instance.term_probabilities(labels)

    binding.pry
    flash[:success] = 'Ok'
    render_200
  end

  def index
  end

end
