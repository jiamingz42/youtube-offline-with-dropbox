require "resque/tasks"

# Resque will load the whole Rails application when it monitor the queue
# It may not be desirable for some jobs that don't need much access to rails
task "resque:setup" => :environment do

  # This code block solve the PG::DuplicatePstatement erorr
  # http://stackoverflow.com/questions/2611747/rails-resque-workers-fail-with-pgerror-server-closed-the-connection-unexpectedl/5519372#5519372
  # https://devcenter.heroku.com/articles/forked-pg-connections

  Resque.before_fork do
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  end

  Resque.after_fork do
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
  end

end
