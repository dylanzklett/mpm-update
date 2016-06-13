set :output, { error: 'cron.error.log', standard: 'cron.log' }
env :MAILTO, 'mpm@anahoret.com'

job_type :runner,
         "cd :path && RAILS_ENV=:environment $HOME/.rbenv/bin/rbenv exec bundle exec rake ':task' :output"

every 1.day do
  runner 'leipreachan:backup'
end
