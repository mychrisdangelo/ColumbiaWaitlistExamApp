#!/bin/bash

# Basic Setup
sudo apt-get -y update
sudo apt-get -y install curl git zsh

# Postgres setup
sudo apt-get -y install postgresql postgresql-client-common postgresql-client-9.1 pgadmin3
sudo /etc/init.d/postgresql start
echo "CREATE USER weedout WITH PASSWORD 'insecure';
      CREATE DATABASE weedout_development;
      GRANT ALL PRIVILEGES ON DATABASE weedout_development TO weedout;" | sudo -u postgres psql -f-

# RVM
\curl -L https://get.rvm.io | 
  bash -s stable --ruby --autolibs=enable --auto-dotfiles
source /usr/local/rvm/scripts/rvm
rvm requirements

# Ruby
rvm install ruby
rvm use ruby --default

# Ruby gems
rvm rubygems current

# Rails
gem install rails --version 4.0.0 --no-ri --no-rdoc

# Link the rails app to be in the home directory
ln -fs /vagrant_weedout ~/weedout

# Set up oh my zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
sed -i "s/robbyrussell/frisk/" ~/.zshrc
sudo chsh -s /usr/bin/zsh vagrant
