require 'bundler/setup'

require 'opal/rake_task'

Opal::RakeTask.new do |t|
  t.name = 'vienna'
  t.dependencies = %w(opal-spec opal-jquery)
end

task :default => 'opal:test'