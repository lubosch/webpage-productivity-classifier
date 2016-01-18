words_cloud = []
@words_cloud.each do |uap|
  uap.application_page.application_terms.each do |app_term|
    words_cloud << {
        term_id: app_term.term_id,
        created_at: uap.created_at,
        length: uap.length,
        term_text: app_term.term_text,
        term_type: app_term.term_type,
    }
  end
end

json.words_cloud words_cloud
