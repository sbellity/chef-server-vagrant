chef_home_dir = File.expand_path(File.dirname(__FILE__), '..')

log_location "#{chef_home_dir}/log/solr.log"

search_index_path    "#{chef_home_dir}/srv/search_index"

supportdir = "#{chef_home_dir}/srv/support"
solr_jetty_path File.join(supportdir, "solr", "jetty")
solr_data_path  File.join(supportdir, "solr", "data")
solr_home_path  File.join(supportdir, "solr", "home")
solr_heap_size  "256M"

solr_url        "http://localhost:8983"

amqp_pass "testing"
