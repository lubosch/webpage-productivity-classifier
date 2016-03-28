module Classification
  class Precomputation

    def self.update_terms_ttf
      Term.connection.execute(
          '
          UPDATE terms
          SET ttf = at.sum_tf
          FROM (
            SELECT SUM(tf) AS sum_tf, term_id
            FROM application_terms
            GROUP BY term_id
          ) at
          WHERE at.term_id = terms.id
      ')
    end

    def self.update_terms_probability
      update_terms_ttf
      sum = Term.sum(:ttf)
      Term.update_all("probability = ttf / #{sum.to_f}")
    end


    def self.refresh_activity_type_terms
      ApplicationActivityType.find_each do |app_act_type|
        app_act_type.create_activity_type_terms if ApplicationActivityType.find_by(application_page_id: app_act_type.application_page_id) == app_act_type
      end
    end

    def self.update_multinomial_probability
      all_labels_count = ApplicationActivityType.count
      ActivityType.find_each do |act_type|
        label_count = act_type.application_activity_types.count
        terms_count = act_type.activity_type_terms.sum(:tf)
        vocabulary_size = act_type.activity_type_terms.count
        if label_count == 0 || vocabulary_size == 0
          act_type.update(count: 0, probability: 1 / ActivityType.count, :terms_count => 0, :vocabulary_size => 0)
        else
          act_type.activity_type_terms.update_all("probability = tf / #{terms_count.to_f}, multinomial_probability = (tf+1) / #{terms_count + vocabulary_size.to_f}")
          act_type.update(count: label_count, probability: label_count / all_labels_count.to_f, :terms_count => terms_count, :vocabulary_size => vocabulary_size, :default_multinomial => 1/(vocabulary_size + terms_count))
        end

      end
    end

  end
end


# Classification::Precomputation.update_terms_probability
# Classification::Precomputation.update_multinomial_probability