include_recipe 'rbenv::system'

rbenv_ruby node['ruby-version']
rbenv_global node['ruby-version']

rbenv_gem 'bundler'

group 'admin' do
  gid 420
end

package 'libpq-dev'

user node[:user][:name] do
  password node[:user][:password]
  gid 'admin'
  home "/home/#{node[:user][:name]}"
  shell '/bin/bash'
  supports :manage_home => true
end

if node[:environment] == 'production'
  template '/etc/ssh/sshd_config' do
    source 'sshd_config'
    owner 'root'
    group 'root'
  end

  bash 'reload ssh' do
    code 'reload ssh'
  end
end

directory "#{node[:sockets_folder]}" do
  owner node[:user][:name]
  recursive true
end

directory "#{node[:deploy_to]}/shared" do
  owner node[:user][:name]
  recursive true
end

if node[:environment] == 'development'
  pg_user 'playround' do
    privileges :superuser => true, :createdb => true, :login => true
    password 'psql'
  end

  pg_database 'template2' do
    owner 'playround'
    encoding 'utf8'
    template 'template0'
    locale 'en_US.UTF8'
  end

  pg_database_extensions 'template2' do
    extensions ['"uuid-ossp"']
  end

  rbenv_gem 'spring'

  magic_shell_environment 'SPRING_TMP_PATH' do
    value '/tmp/spring'
  end
end