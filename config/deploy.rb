# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'stay_productive'
set :repo_url, 'git@github.com:lubosch/webpage-productivity-classifier.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :use_sudo, false
set :deploy_via, :copy
set :copy_exclude, [".git/*", ".gitignore", ".DS_Store"]

set :linked_dirs, %w{bin log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle}
set :linked_files, %w{.env config/unicorn.rb config/unicorn_init.sh}

set :format, :pretty
set :log_level, :debug
set :pty, true

set :ssh_options, {forward_agent: true}


namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  task :restart do
    invoke 'unicorn:restart'
  end

  task :setup_config do
    on roles(:app), in: :sequence, wait: 1 do
      execute :sudo, "ln -nfs #{current_path}/config/apache.conf /etc/apache2/sites-enabled/#{fetch(:app_name)}.conf"
      execute :sudo, "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:app_name)}"
      # run "mkdir -p #{shared_path}/config"
      put File.read(".env.example"), "#{shared_path}/.env"
      puts "Now edit the config files in #{shared_path}."
    end
  end

  # after "deploy:setup", "deploy:setup_config"

  # task :symlink_config, roles: :app do
  #   run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # end
  # after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end

  before "deploy", "deploy:check_revision"

end

namespace :bower do
  desc 'Install bower'
  task :install do
    on roles(:web) do
      within release_path do
        execute :rake, 'bower:install CI=true'
      end
    end
  end
end
before 'deploy:compile_assets', 'bower:install'

after 'deploy:publishing', 'deploy:restart'
