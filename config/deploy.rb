set :application, "shortener"
set :repository,  "git@github.com:AndreyChernyh/shortener.git"
set :deploy_via, :remote_cache
set :deploy_to, "/home/akhkharu/projects/akhkharu.ru/"
set :use_sudo, false

set :scm, :git

server "akhkharu.ru", :app, :web, :db, :primary => true

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end