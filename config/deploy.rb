require 'bundler/capistrano'

default_run_options[:pty] = true
set :ssh_options, { forward_agent: true }

set :application, 'playround'
set :repository,  'git@github.com:eugeniodepalo/playround-api.git'
set :deploy_to, "/var/www/#{application}"

set :server_ip, '192.241.132.223'
server server_ip, :app, :web, :db, primary: true
set :rails_env, 'production'
set :branch, 'master'

set :scm, :git
set :scm_verbose, true

set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 3
set :user, 'deployer'

set :bundle_without, [:development, :test]
set :normalize_asset_timestamps, false

set :rake, "#{rake} --trace"

set :default_environment, {
  'PATH' => '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
}

after 'deploy:update_code', :upload_env_vars

after 'deploy:setup' do
  sudo "chown -R #{user} #{deploy_to} && chmod -R g+s #{deploy_to}"
end

namespace :deploy do
  desc <<-DESC
  Send a USR2 to the unicorn process to restart for zero downtime deploys.
  runit expects 2 to tell it to send the USR2 signal to the process.
  DESC
  task :restart, roles: :app, except: { no_release: true } do
    run "sv 2 /home/#{user}/service/#{application}"
  end
end

task :upload_env_vars do
  upload(".env.#{rails_env}", "#{release_path}/.env.#{rails_env}", via: :scp)
end