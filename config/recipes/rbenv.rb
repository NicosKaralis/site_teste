set_default :ruby_version, "1.9.3-p392"

namespace :rbenv do
  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install curl git-core"
    run "curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash"
    bashrc = <<-BASHRC
if [ -d $HOME/.rbenv ]; then 
  export PATH="$HOME/.rbenv/bin:$PATH" 
  eval "$(rbenv init -)" 
fi
BASHRC
    put bashrc, "/tmp/rbenvrc"
    run "cat /tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp"
    run "mv ~/.bashrc.tmp ~/.bashrc"
    run %q{export PATH="$HOME/.rbenv/bin:$PATH"}
    run %q{eval "$(rbenv init -)"}
    run "rbenv rehash"
    run "rbenv bootstrap-ubuntu-12-04"
    # run "#{sudo} apt-get -y update" # from https://github.com/fesplugas/rbenv-bootstrap/blob/master/bin/rbenv-bootstrap-ubuntu-12-04
    # run "#{sudo} apt-get -y install build-essential tklib zlib1g-dev libssl-dev libreadline-gplv2-dev libxml2 libxml2-dev libxslt1-dev"
    run "rbenv install #{ruby_version}"
    run "rbenv global #{ruby_version}"
    run "rbenv rehash"
    run "gem install bundler --no-ri --no-rdoc"
    run "rbenv rehash"
  end
  after "deploy:install", "rbenv:install"
  
  desc "Update rbenv"
  task :update, roles: :app do
    run "rbenv update"
  end
end
