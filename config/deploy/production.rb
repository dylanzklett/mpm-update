set :rails_env, 'production'
set :stage, :production
set :branch, 'r1'

set :host, '104.131.68.111'
set :user, 'deploy'

set :application, 'mpm'
set :deploy_to, "/var/www/apps/#{application}"

set :whenever_environment, defer { stage }
set :whenever_command, 'bundle exec whenever'
set :whenever_identifier, defer { "#{application}_#{stage}" }

before "deploy:migrate", "deploy:leipreachan:backup"

namespace :deploy do
  desc 'Start application.'
  task :start, roles: :app do
    run "sudo service #{application} start"
  end

  desc 'Stop application.'
  task :stop, roles: :app do
    run "sudo service #{application} stop"
  end

  desc 'Restart application.'
  task :restart, roles: :app do
    run "sudo service #{application} restart"
  end

  desc 'Show deployed revision'
  task :revision, roles: :app do
    run "cat #{current_path}/APP_VERSION"
    run "cat #{current_path}/REVISION"
  end
end

namespace :utils do
  task :version do
    run "cd #{fetch(:latest_release)} && echo #{fetch(:branch)} > APP_VERSION"
  end
end

namespace :db do
  desc 'Make symlinks'
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/backups #{release_path}/backups"
  end
end

namespace :db do
  desc "Create database yaml in shared path"
  task :default do
    db_config = ERB.new <<-EOF
production:
  adapter: postgresql
  encoding: unicode
  pool: 5
  host: localhost
  user: mpm
  database: mpm
    EOF

    run "mkdir -p #{shared_path}/config"
    put db_config.result, "#{shared_path}/config/database.yml"
  end
end

namespace :remote_rake do
  # cap staging remote_rake TASK=ts:config
  desc "remote rake task"
  task :default do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake #{ENV['TASK']}"
  end
end
