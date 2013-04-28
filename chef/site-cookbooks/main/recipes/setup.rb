include_recipe 'rbenv::system'

rbenv_ruby node['ruby-version']
rbenv_global node['ruby-version']

rbenv_gem 'bundler'
rbenv_gem 'spring'

group 'admin' do
  gid 420
end

user node[:user][:name] do
  password node[:user][:password]
  gid 'admin'
  home "/home/#{node[:user][:name]}"
  shell '/bin/bash'
  supports :manage_home => true
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
end