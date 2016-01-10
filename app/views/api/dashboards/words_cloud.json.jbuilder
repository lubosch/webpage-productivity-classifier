json.words_cloud @words_cloud do |uap|
  uap.application_page.application_terms.each do |app_term|
    json.term_id app_term.term_id
    json.created_at uap.created_at
    json.length uap.length
    json.term_text app_term.term_text
    json.term_type app_term.term_type

  end

end

