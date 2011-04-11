log_level                :info
log_location             STDOUT
node_name                'vagrant'
client_key               '/home/vagrant/chef-0.10/infra/.chef/vagrant.pem'
validation_client_name   'chef-validator'
validation_key           '/home/vagrant/chef-0.10/chef/config/validation.pem'
chef_server_url          'http://localhost:4000'
cache_type               'BasicFile'
cache_options( :path => '/home/vagrant/chef-0.10/infra/.chef/checksums' )
cookbook_path [ './cookbooks', './site-cookbooks' ]