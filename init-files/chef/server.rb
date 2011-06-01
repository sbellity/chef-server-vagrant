chef_home_dir = ENV['CHEF_HOME'] || File.expand_path(File.join(File.dirname(__FILE__), '..'))
chef_base_port = (ENV['CHEF_BASE_PORT'] || 4000).to_i

puts "Loading server.rb config with chef_home_dir = #{chef_home_dir}"

log_level          :info
log_location       "#{chef_home_dir}/log/server.log" 
ssl_verify_mode    :verify_none
chef_server_url    "http://localhost:#{chef_base_port}"

couchdb_database   'chef'

cookbook_path      [ "#{chef_home_dir}/srv/cookbooks", "#{chef_home_dir}/srv/site-cookbooks" ]
cookbook_tarball_path "#{chef_home_dir}/srv/cache/cookbook-tarballs"

checksum_path      "#{chef_home_dir}/srv/checksums"
file_backup_path   "#{chef_home_dir}/srv/backup"
sandbox_path 	   "#{chef_home_dir}/srv/sandboxes"
cache_options      :skip_expires => true, :path => "#{chef_home_dir}/srv/checksums"
file_cache_path    "#{chef_home_dir}/srv/cache"
node_path          "#{chef_home_dir}/srv/nodes"
openid_store_path  "#{chef_home_dir}/srv/openid/store"
openid_cstore_path "#{chef_home_dir}/srv/openid/cstore"
search_index_path  "#{chef_home_dir}/srv/search_index"
role_path          "#{chef_home_dir}/srv/roles"

validation_client_name "chef-validator"
validation_key         "#{chef_home_dir}/config/validation.pem"
node_name              "chef-webui"
client_key             "#{chef_home_dir}/config/webui.pem"
web_ui_client_name     "chef-webui"
web_ui_key             "#{chef_home_dir}/config/webui.pem"

web_ui_admin_user_name "admin"
web_ui_admin_default_password "chefadmin"

supportdir = "#{chef_home_dir}/srv/support"
solr_jetty_path File.join(supportdir, "solr", "jetty")
solr_data_path  File.join(supportdir, "solr", "data")
solr_home_path  File.join(supportdir, "solr", "home")
solr_heap_size  "256M"

umask 0022

signing_ca_cert    "#{chef_home_dir}/config/certificates/cert.pem"
signing_ca_key     "#{chef_home_dir}/config/certificates/key.pem"
signing_ca_user    "vagrant"
signing_ca_group   "vagrant"
