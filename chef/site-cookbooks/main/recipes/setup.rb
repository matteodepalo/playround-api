include_recipe 'rbenv::system'
include_recipe 'rbenv::vagrant' if node[:environment] == 'development'

rbenv_ruby node['ruby-version']
rbenv_global node['ruby-version']

rbenv_gem 'bundler'

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