
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

task :require_token_in_env do
  unless ENV['DROPBOX_RUBY_SDK_ACCESS_TOKEN']
    warn "You need to set the DROPBOX_RUBY_SDK_ACCESS_TOKEN env var to run the tests"
    warn "You can get one by creating an app and generating an access token"
    warn ""
    warn "  DROPBOX_RUBY_SDK_ACCESS_TOKEN=some-auth-token rake test"
    exit 1
  end
end

task :default => :test
# This short-circuits the 'test' task
task :test => :require_token_in_env
