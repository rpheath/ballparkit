set :application, "ballparkit"
set :repository,  "git@github.com:rpheath/ballparkit.git"

server "ballparkitapp.com", :app, :web, :db, :primary => true

set :deploy_to, "/var/www/#{application}"

set :scm, :git
set :deploy_via, :remote_cache

set :user, "ryan"
set :use_sudo, false

desc "updates production configuration"
task :symlink_config, :roles => [:app] do
  # remove any existing files (from the repo)
  run "rm -f #{release_path}/config/database.yml"
  run "rm -f #{release_path}/config/environment.rb"
  
  # create symlinks to existing configuration in shared/
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/config/environment.rb #{release_path}/config/environment.rb"
end
after "deploy:update_code", :symlink_config

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"

namespace :deploy do
  desc "restarts mod_rails"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end