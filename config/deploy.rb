# config valid for current version and patch releases of Capistrano
lock "~> 3.19.1"

set :application, "my_car_document_app"
set :repo_url, "https://github.com/Shinonononon/MyCarDocumentApp.git"
set :linked_files, %w{config/secrets.yml}   # 4
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/uploads}   # 5
set :keep_releases, 5   # 6
set :rbenv_ruby, '3.3.0'    # 7
set :log_level, :info   # 8
set :deploy_to, "/var/www/my_car_document_app"

after 'deploy:published', 'deploy:seed'   # 9
after 'deploy:finished', 'deploy:restart'   # 10

namespace :deploy do
  desc 'Run seed'
  task :seed do
    on roles(:db) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
end
namespace :deploy do
  task :create_directories do
    on roles(:app) do
      execute :mkdir, '-p', "#{shared_path}/config"
    end
  end
  before 'deploy:check:linked_dirs', 'deploy:create_directories'
end
