module Neo4j
  class Application < Rails::Application
    config.neo4j.session_type = :server_db
    config.neo4j.session_path = 'http://localhost:7474'
    config.neo4j.session_options = {
        basic_auth: {username: 'neo4j', password: ENV['neo4j_pass']},
        initialize: {
            request: {
                open_timeout: 2, # opening a connection
                timeout: 120 # waiting for response
            }
        }
    }
    config.neo4j[:cache_class_names] = true #improves Cypher performance
  end
end
