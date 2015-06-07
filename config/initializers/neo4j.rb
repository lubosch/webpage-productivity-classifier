Rails.application.config.neo4j.session_path = 'http://localhost:7474'
Rails.application.config.neo4j.session_options = {
    basic_auth: {username: 'neo4j', password: ENV['neo4j_pass']},
    initialize: {
        request: {
            open_timeout: 2, # opening a connection
            timeout: 120000 # waiting for response
        }
    }}
Rails.application.config.neo4j[:cache_class_names] = true #improves Cypher performance
Rails.application.config.neo4j.session_type = :server_db
