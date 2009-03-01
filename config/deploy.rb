set :application, "ballparkit"
set :repository,  "git@github.com:rpheath/ballparkit.git"

server "ballparkitapp.com", :app, :web, :db, :primary => true

set :deploy_to, "/var/www/#{application}"

set :scm, :git
set :deploy_via, :remote_cache

set :user, "ryan"
set :use_sudo, false

task :update_config, :roles => [:app] do
  desc "updates production configuration"
  run "cp -Rf #{shared_path}/config/* #{release_path}/config/"
end
after "deploy:update_code", :update_config

after "deploy", "deploy:migrations"
after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"

namespace :deploy do
  desc "restarts mod_rails"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end