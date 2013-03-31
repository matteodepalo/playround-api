rails_env = ENV['RAILS_ENV'] || 'development'

case rails_env
when 'development'
  deploy_to = '/vagrant'
  release_path = deploy_to

  listen "/home/vagrant/sockets/playround.sock"
  stderr_path "#{deploy_to}/log/unicorn.log"
  stdout_path "#{deploy_to}/log/unicorn.log"
when 'production'
  worker_processes 6
  deploy_to = '/var/www/playround'
  release_path = deploy_to + '/current'

  pid "#{deploy_to}/shared/pids/unicorn.pid"
  listen "#{deploy_to}/tmp/sockets/playround.sock", :backlog => 2048

  stderr_path "#{deploy_to}/shared/log/unicorn.log"
  stdout_path "#{deploy_to}/shared/log/unicorn.log"
end

preload_app true

# Restart any workers that haven't responded in 30 seconds
timeout 60

working_directory release_path

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{release_path}/Gemfile"
end

before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  if rails_env == 'production'
    old_pid = "#{deploy_to}/shared/pids/unicorn.pid.oldbin"
  else
    old_pid = "#{deploy_to}/tmp/pids/unicorn.pid.oldbin"
  end

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end