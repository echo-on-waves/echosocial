# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.


unless ARGV.any? {|a| a =~ /^gems/} # Don't load anything when running the gems:* tasks

vendored_cucumber_bin = Dir["#{RAILS_ROOT}/vendor/{gems,plugins}/cucumber*/bin/cucumber"].first
$LOAD_PATH.unshift(File.dirname(vendored_cucumber_bin) + '/../lib') unless vendored_cucumber_bin.nil?

begin
  require 'cucumber/rake/task'

  namespace :cucumber do
#    Cucumber::Rake::Task.new({:ok => 'db:test:prepare'}, 'Run features that should pass') do |t|
#      t.binary = vendored_cucumber_binary
#      t.fork = true # You may get faster startup if you set this to false
#      t.cucumber_opts = "--color --tags ~@wip --strict --format #{ENV['CUCUMBER_FORMAT'] || 'pretty'}"
#    end

    desc 'Run all features'
    task :all => [:default, :js]
    task :ok => :all
    task :wip => [:wip_default, :wip_js]

    Cucumber::Rake::Task.new({:wip_default => 'db:test:prepare'}, 'Run non-js features that are being worked on') do |t|
      t.binary = vendored_cucumber_binary
      t.fork = true # You may get faster startup if you set this to false
      t.profile = "wip_default"
      t.cucumber_opts = "--color --format #{ENV['CUCUMBER_FORMAT'] || 'pretty'}"
    end

    Cucumber::Rake::Task.new({:wip_js => 'db:test:prepare'}, 'Run js features that are being worked on') do |t|
      t.binary = vendored_cucumber_binary
      t.fork = true # You may get faster startup if you set this to false
      t.profile = "wip_js"
      t.cucumber_opts = "--color --format #{ENV['CUCUMBER_FORMAT'] || 'pretty'}"
    end

    Cucumber::Rake::Task.new({:default => 'db:test:prepare'}, 'Default (non-js) features') do |t|
      t.binary = vendored_cucumber_binary
      t.fork = true # You may get faster startup if you set this to false
      t.profile = "default"
      t.cucumber_opts = "--color --format #{ENV['CUCUMBER_FORMAT'] || 'pretty'}"
    end

    Cucumber::Rake::Task.new({:js => 'db:test:prepare'}, 'js features') do |t|
      t.binary = vendored_cucumber_binary
      t.fork = true # You may get faster startup if you set this to false
      t.profile = "js"
      t.cucumber_opts = "--color --format #{ENV['CUCUMBER_FORMAT'] || 'pretty'}"
    end

  end
  task :cucumber => 'cucumber:all'

  task :default => :cucumber

  task :features => :cucumber do
    STDERR.puts "*** The 'features' task is deprecated. See rake -T cucumber ***"
  end
rescue LoadError
  desc 'cucumber rake task not available (cucumber not installed)'
  task :cucumber do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

end
