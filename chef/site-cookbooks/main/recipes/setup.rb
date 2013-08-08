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
else
  rbenv_gem 'spring'

  magic_shell_environment 'SPRING_TMP_PATH' do
    value '/tmp/spring'
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

apt_repository 'ppa_sharpie_for-science' do
  uri 'http://ppa.launchpad.net/sharpie/for-science/ubuntu'
  distribution node['lsb']['codename']
  components ["main"]
  keyserver 'keyserver.ubuntu.com'
  key 'DAF764E2'
  deb_src true
end

apt_repository 'ppa_sharpie_postgis-stable' do
  uri 'http://ppa.launchpad.net/sharpie/postgis-stable/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'DAF764E2'
  deb_src true
end

apt_repository 'ppa_ubuntugis_ubuntugis-unstable' do
  uri 'http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key '314DF160'
  deb_src true
  cache_rebuild true
end

package 'python-software-properties'
package 'postgresql-9.2-postgis'

pg_user node[:db_user][:name] do
  privileges :superuser => true, :createdb => true, :login => true
  password node[:db_user][:password]
end