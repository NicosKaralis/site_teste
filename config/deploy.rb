require 'bundler/capistrano'

load 'config/recipes/base'
load 'config/recipes/check'
load 'config/recipes/postgresql'
load 'config/recipes/nginx'
load 'config/recipes/rbenv'
load 'config/recipes/unicorn'
load 'config/recipes/nodejs'
load 'config/recipes/monit'

server "192.168.101.102", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "portifolio"
set :use_sudo, false

set :repository, "git@github.com:NicosKaralis/site_teste.git"
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache

set :deploy_to, "/home/#{user}/apps/#{application}"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

# To setup new Ubuntu 12.04 server:
# sudo adduser deployer --ingroup admin
# cat ~/.ssh/id_rsa.pub | ssh deployer@192.168.101.102 'mkdir -p ~/.ssh/ && cat >> ~/.ssh/authorized_keys'
# cap deploy:install && cap deploy:setup && cap deploy:cold
