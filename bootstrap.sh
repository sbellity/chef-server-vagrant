#!/bin/bash

# Base packages install
sudo apt-get update
sudo apt-get install -y ruby ruby-dev libopenssl-ruby rdoc ri irb build-essential wget ssl-cert libxml2-dev git-core htop openssl curl

# Install couchdb
sudo apt-get install -y couchdb

# Install java-sun
sudo cp /vagrant/init-files/canonical.com.list /etc/apt/sources.list.d/canonical.com.list
sudo debconf-set-selections /vagrant/init-files/java.seed
sudo apt-get install -y sun-java6-jdk

# RabbitMQ
sudo apt-get install -y rabbitmq-server
sudo rabbitmqctl add_vhost /chef
sudo rabbitmqctl add_user chef testing
sudo rabbitmqctl set_permissions -p /chef chef ".*" ".*" ".*"

# Add opscode apt source
echo "deb http://apt.opscode.com/ `lsb_release -cs` main" | sudo tee /etc/apt/sources.list.d/opscode.list
wget -qO - http://apt.opscode.com/packages@opscode.com.gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y libgecode-dev

# RVM Install
bash < <(curl -s -k https://rvm.beginrescueend.com/install/rvm)

source "$HOME/.rvm/scripts/rvm"

# Install chef dir
export CHEF_HOME="/home/vagrant/chef-0.10/chef"

mkdir -p $CHEF_HOME $CHEF_HOME/config $CHEF_HOME/srv $CHEF_HOME/log
rvm install 1.8.7-p334
rvm gemset create chef-0.10
cd $CHEF_HOME
rvm use 1.8.7-p334@chef-0.10
echo "rvm use 1.8.7-p334@chef-0.10" | tee $CHEF_HOME/.rvmrc
gem install bundler

cp /vagrant/init-files/Gemfile $CHEF_HOME/Gemfile
cp /vagrant/init-files/chef/server.rb $CHEF_HOME/config/server.rb
cp /vagrant/init-files/chef/solr.rb $CHEF_HOME/config/solr.rb

bundle

# chef-solr-installer -c $CHEF_HOME/config/solr.rb
# chef-server -e production -C $CHEF_HOME/config/server.rb -d
# chef-server -e production -C $CHEF_HOME/config/server.rb -d



