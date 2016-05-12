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


    # not needed anymore, doing automatic
    def self.refresh_activity_type_terms
      ActivityTypeTerm.delete_all
      WorkTerm.delete_all
      ApplicationActivityType.train.each do |app_act_type|
        if ApplicationActivityType.find_by(application_page_id: app_act_type.application_page_id) == app_act_type
          app_act_type.create_activity_type_terms
        end
      end
    end

    # not needed anymore, doing automatic
    def self.refresh_work_terms
      ActivityTypeTerm.delete_all
      WorkTerm.delete_all
      ApplicationActivityType.where.not(work_id: nil).train.each do |app_act_type|
        if ApplicationActivityType.find_by(application_page_id: app_act_type.application_page_id) == app_act_type
          app_act_type.create_work_terms
        end
      end
    end

    def self.update_multinomial_probability
      all_labels_count = ApplicationActivityType.train.count
      total_term_count = Term.count
      ActivityType.find_each do |act_type|
        label_count = act_type.application_activity_types.train.count
        terms_count = act_type.activity_type_terms.sum(:tf)
        vocabulary_size = act_type.activity_type_terms.count.to_f
        # if label_count == 0 || vocabulary_size == 0
        #   act_type.update(count: 0, probability: 1 / ActivityType.count, :terms_count => 0, :vocabulary_size => 0)
        # else
        # act_type.activity_type_terms.update_all("probability = tf / #{terms_count.to_f}, multinomial_probability = (tf+1) / #{terms_count + vocabulary_size}")
        ActivityTypeTerm.connection.execute("UPDATE activity_type_terms SET multinomial_probability = 0.6 * (tf + 0.8*terms.ttf/#{total_term_count}) / (#{terms_count + 0.8}) + 0.4*terms.ttf/#{total_term_count}, probability = tf / #{terms_count.to_f} FROM (SELECT id, ttf FROM terms) terms WHERE terms.id = term_id AND activity_type_id = #{act_type.id}")
        # ActivityTypeTerm.connection.execute("UPDATE activity_type_terms SET multinomial_probability = (tf + terms.ttf) / (#{terms_count + total_term_count.to_f}), probability = tf / #{terms_count.to_f} FROM (SELECT id, ttf FROM terms) terms WHERE terms.id = term_id AND activity_type_id = #{act_type.id}")
        # ActivityTypeTerm.connection.execute("UPDATE activity_type_terms SET multinomial_probability = (tf + terms.ttf) / (#{terms_count + total_term_count.to_cf}) FROM (SELECT id, ttf FROM terms) terms WHERE terms.id = term_id AND activity_type_id = #{act_type.id}")
        act_type.update(count: label_count, probability: label_count / all_labels_count.to_f, :terms_count => terms_count, :vocabulary_size => vocabulary_size, :default_multinomial => 1/(vocabulary_size + terms_count))
        # end

      end
    end

    def self.update_work_multinomial_probability
      all_labels_count = ApplicationActivityType.train.where.not(work_id: nil).count
      Work.find_each do |work|
        label_count = work.application_activity_types.train.count
        terms_count = work.work_terms.sum(:tf)
        vocabulary_size = work.work_terms.count
        work.work_terms.update_all("probability = tf / #{terms_count.to_f}, multinomial_probability = (tf+1) / #{terms_count + vocabulary_size.to_f}")
        work.update(count: label_count, probability: label_count / all_labels_count.to_f, :terms_count => terms_count, :vocabulary_size => vocabulary_size, :default_multinomial => 1/(vocabulary_size + terms_count))
      end
    end


  end
end


# Classification::Precomputation.update_terms_probability
# Classification::Precomputation.update_multinomial_probability