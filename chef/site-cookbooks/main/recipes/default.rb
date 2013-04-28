include_recipe 'main::setup'

template '/etc/nginx/sites-enabled/default' do
  source 'nginx.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[nginx]'
end

service 'nginx'

if node[:environment] == 'development'
  ["sv", "service"].each do |dir|
    directory "/home/#{node[:user][:name]}/#{dir}" do
      owner node[:user][:name]
      group 'admin'
      recursive true
    end
  end

  runit_service "runsvdir-#{node[:user][:name]}" do
    run_template_name 'runsvdir-deployer'
    default_logger true
  end

  runit_service 'playround' do
    sv_dir "/home/#{node[:user][:name]}/sv"
    service_dir "/home/#{node[:user][:name]}/service"
    owner node[:user][:name]
    group 'admin'
    restart_command '2'
    restart_on_update false
    default_logger true
  end
end

if node[:environment] == 'development'
  rbenv_script 'install' do
    cwd node[:release_path]

    code <<-EOT2
      bundle install
    EOT2
  end

  # runit_service 'playround' do
  #   action :restart
  # end
end