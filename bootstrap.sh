#!/bin/bash

# Base packages install
echo "Installing base packages"
echo "------------------------\n\n\n\n"
sudo apt-get update
sudo apt-get install -y ruby ruby-dev libopenssl-ruby rdoc ri irb build-essential wget ssl-cert libxml2-dev git-core htop openssl curl libreadline-dev

# Install couchdb
echo "Installing couchdb"
echo "------------------\n\n\n\n"
sudo apt-get install -y couchdb

# Install java-sun
echo "Installing java-sun"
echo "-------------------\n\n\n\n"
sudo cp /vagrant/init-files/canonical.com.list /etc/apt/sources.list.d/canonical.com.list
sudo debconf-set-selections /vagrant/init-files/java.seed
sudo apt-get install -y sun-java6-jdk

# RabbitMQ
echo "Installing base rabbitmq"
echo "------------------------\n\n\n\n"
sudo apt-get install -y rabbitmq-server
sudo rabbitmqctl add_vhost /chef
sudo rabbitmqctl add_user chef testing
sudo rabbitmqctl set_permissions -p /chef chef ".*" ".*" ".*"

# Add opscode apt source
echo "Installing Gecode"
echo "-----------------\n\n\n\n"
echo "deb http://apt.opscode.com/ `lsb_release -cs` main" | sudo tee /etc/apt/sources.list.d/opscode.list
wget -qO - http://apt.opscode.com/packages@opscode.com.gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y libgecode-dev

# RVM Install
echo "Installing RVM"
echo "--------------\n\n\n\n"

bash < <(curl -s -k https://rvm.beginrescueend.com/install/rvm)

source "$HOME/.rvm/scripts/rvm"


echo "Installing chef app dir"
echo "-----------------------\n\n\n\n"

# Install chef dir
export CHEF_HOME="/home/vagrant/chef-0.10/chef"

mkdir -p $CHEF_HOME $CHEF_HOME/config $CHEF_HOME/srv $CHEF_HOME/log


echo "Installing ruby 1.8.7 via RVM"
echo "-----------------------------\n\n\n\n"
rvm package install openssl
rvm install 1.8.7-p334 --with-openssl-dir=$HOME/.rvm/usr
rvm use 1.8.7-p334
rvm gemset create chef-0.10
cd $CHEF_HOME
rvm use 1.8.7-p334@chef-0.10
echo "rvm use 1.8.7-p334@chef-0.10" | tee $CHEF_HOME/.rvmrc
gem install bundler god
god


echo "Configuring chef"
echo "----------------\n\n\n\n"

cp /vagrant/init-files/Gemfile $CHEF_HOME/Gemfile
cp /vagrant/init-files/chef/server.rb $CHEF_HOME/config/server.rb
cp /vagrant/init-files/chef/solr.rb $CHEF_HOME/config/solr.rb
cp /vagrant/init-files/chef.god $CHEF_HOME/chef.god

bundle


echo "Starting everything"
echo "-------------------\n\n\n\n"

chef-solr-installer -c $CHEF_HOME/config/solr.rb

god load chef.god

# Fetch infra from github
echo "Fetching infra from github"
echo "--------------------------\n\n\n\n"

mkdir -p /home/vagrant/.ssh
cp -r /vagrant/init-files/ssh/* /home/vagrant/.ssh/
chmod 600 /home/vagrant/.ssh/id_rsa*

export INFRA_HOME="/home/vagrant/chef-0.10/infra"
mkdir -p $INFRA_HOME
git clone git@github.com:mimesis/infra.git $INFRA_HOME
rvm rvmrc trust $INFRA_HOME
cd $INFRA_HOME
git checkout develop

# Configure knife client
mkdir $INFRA_HOME/.chef
cp /vagrant/init-files/chef/knife.rb $INFRA_HOME/.chef/knife.rb
knife client create vagrant -n -a -f /home/vagrant/.chef/vagrant.pem -k $CHEF_HOME/config/validation.pem -u chef-validator
rake roles
rake upload_cookbooks

echo "Done !"




