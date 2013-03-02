namespace :nginx do
  desc "Install nginx"
  task :install, roles: :web do
    run "#{sudo} add-apt-repository -y ppa:nginx/stable"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nginx"
    run "#{sudo} sed -i 's/listen \\[::\\]:80/# listen \\[::\\]:80/g' /etc/nginx/sites-enabled/default || :"
    start
  end
  after "deploy:install", "nginx:install"
  
  desc "Setup nginx configuration for this application"
  task :setup, roles: :web do
    run "mkdir -p #{shared_path}/config"
    template "nginx_unicorn.erb", "#{shared_path}/config/nginx_conf"
    run "#{sudo} ln -nfs #{shared_path}/config/nginx_conf /etc/nginx/sites-enabled/#{application}_nginx"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    
    configtest
    restart
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop restart status configtest].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end
end
