set_default :email_alerts_enabled, true
set_default :alert_smtp_server, "smtp.gmail.com"
set_default :alert_port, 587
set_default :alert_username, "dymytrhy@gmail.com"
set_default :alert_password, "kqckqozizjkkbmkv"
set_default :alert_email, "nicoskaralis@me.com"

set_default :httpd_enabled, true
set_default :httpd_port, 3000
set_default :httpd_username, "admin"
set_default :httpd_password, "secret"

set_default :system_name, "DgOc_vps_nicos"

def monit_config(name, destination = nil)
  destination ||= "/etc/monit/conf.d/#{name}.conf"
  template "monit/#{name}.erb", "/tmp/monit_#{name}"
  run "#{sudo} mv /tmp/monit_#{name} #{destination}"
  run "#{sudo} chown root #{destination}"
  run "#{sudo} chmod 600 #{destination}"
end

namespace :monit do
  desc "Install monit"
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install monit"
  end
  after "deploy:install", "monit:install"
  
  desc "Setup monit configuration for this application"
  task :setup do
    monit_config "monitrc", "/etc/monit/monitrc"
    nginx
    postgresql
    unicorn
    
    syntax
    restart
  end
  after "deploy:setup", "monit:setup"
  
  task(:nginx, roles: :web) { monit_config "nginx" }
  task(:postgresql, roles: :db) { monit_config "postgresql" }
  task(:unicorn, roles: :app) { monit_config "unicorn" }
  
  %w[start stop restart status syntax].each do |command|
    desc "#{command} monit"
    task command do
      run "#{sudo} service monit #{command}"
    end
  end
end
