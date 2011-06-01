chef_home = "/home/vagrant/chef-0.10/chef"
base_port = (ENV['CHEF_BASE_PORT'] || 4000).to_i

God.watch do |w|
  w.name     = "chef-server"
  w.group    = "chef"
  w.interval = 30.seconds
  w.env      = { "CHEF_HOME" => chef_home }
  w.dir      = chef_home
  w.start    = "chef-server -e production -C #{chef_home}/config/server.rb -p #{base_port}"
  
  w.log = "#{chef_home}/log/server.log"
  
  # retart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 350.megabytes
      c.times = 2
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end


God.watch do |w|
  w.name     = "chef-solr"
  w.group    = "chef"
  w.interval = 30.seconds
  w.env      = { "CHEF_HOME" => chef_home }
  w.dir      = chef_home
  w.start    = "chef-solr -c #{chef_home}/config/solr.rb"
  
  w.log = "#{chef_home}/log/solr.log"
  
  # retart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 350.megabytes
      c.times = 2
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end


God.watch do |w|
  w.name     = "chef-server-webui"
  w.group    = "chef"
  w.interval = 30.seconds
  w.env      = { "CHEF_HOME" => chef_home }
  w.dir      = chef_home
  w.start    = "chef-server-webui -e production -C #{chef_home}/config/server.rb -p #{base_port + 40}"
  
  w.log = "#{chef_home}/log/webui.log"
  
  # retart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 350.megabytes
      c.times = 2
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end


God.watch do |w|
  w.name     = "chef-expander"
  w.group    = "chef"
  w.interval = 30.seconds
  w.env      = { "CHEF_HOME" => chef_home }
  w.dir      = chef_home
  w.start    = "chef-expander -i 1 -n 1 -c #{chef_home}/config/expander.rb"
  
  w.log = "#{chef_home}/log/expander.log"
  
  # retart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 350.megabytes
      c.times = 2
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end