require 'soprano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'whenever/capistrano'
require 'leipreachan/capistrano2'

set :default_environment, {
  'PATH' => '/home/deploy/.rbenv/shims:/home/deploy/.rbenv/bin:$PATH'
}


set :web_server, :nginx
set :keep_releases, 3

set :repository, 'git@github.com:mitigation/mpm.git'

set :deploy_via, :copy
set :copy_exclude, %w(.git .idea .yardoc tmp log .DS_Store doc/* public/uploads.tar db/*.sql vendor/cache)
set :copy_cache, true

set :bundle_without, [:development, :test]
set :bundle_flags, '--deployment --binstubs'

set :user, 'deploy'

before 'deploy:setup', :db
after 'deploy:create_symlink', 'utils:version'
after 'deploy:update_code', 'db:symlink'

#For troubleshooting only
namespace :deploy do
  task :update_code, :except => { :no_release => true } do
    #on_rollback { run "rm -rf #{release_path}; true" }
    strategy.deploy!
    finalize_update
  end
end
