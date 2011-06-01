Vagrant::Config.run do |config|
  config.vm.box = "chef-server"
  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"

  config.vm.forward_port "chef-solr",   8983, 18983
  config.vm.forward_port "chef-api",    4000, 14000
  config.vm.forward_port "chef-webui",  4040, 14040
  config.vm.forward_port "couchdb",     5984, 15984
end
