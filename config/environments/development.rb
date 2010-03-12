# Settings specified here will take precedence over those in config/environment.rb

##
## SOME USEFUL THINGS FOR DEBUGGING
##

# comment this out to show the sql commands as they are made while debugging.
# ActiveRecord::Base.logger = Logger.new(STDOUT)

# here is a handy method for dev mode. it dumps a table to a yml file.
# you can use it to build up your fixtures. dumps to
# test/fixtures/dumped_tablename.yml
def export_yml(table_name)
  sql  = "SELECT * FROM %s"
  i = "000"
  File.open("#{RAILS_ROOT}/test/fixtures/dumped_#{table_name}.yml", 'w') do |file|
    data = ActiveRecord::Base.connection.select_all(sql % table_name)
    file.write data.inject({}) { |hash, record|
      hash["#{table_name}_#{i.succ!}"] = record
      hash
    }.to_yaml
  end
end

#
# have you ever wanted to know what part of your code was triggering a particular
# sql query? enable this and set the STOP_ON_SQL constant to find out.
#
# For example:
#
# STOP_ON_SQL = "SELECT * FROM `users` WHERE (`users`.`id` = 633)"
#
STOP_ON_SQL = nil
if STOP_ON_SQL
  STOP_ON_SQL_MATCH = Regexp.escape(STOP_ON_SQL).gsub(/\\\s+/, '\s+')
  class ActiveRecord::ConnectionAdapters::AbstractAdapter
    def log_with_debug(sql, name, &block)
      if sql.match(STOP_ON_SQL_MATCH)
        debugger
        true
      end
      log_without_debug(sql, name, &block)
    end
    alias_method_chain :log, :debug
  end
end

##
## CONFIGURATION.
##
## you probably don't need to change anything here.
##

# regenerate customized css every request
# see docs/THEMING
Conf.always_renegerate_themed_stylesheet = true

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true

# set this to true to play with view caching:
config.action_controller.perform_caching             = false

# Do care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

# the default log level for development mode should be to log everything.
config.log_level = :debug

# however, rails engines are way too verbose, so set engines logging to info:
if defined? Engines
  Engines.logger = ActiveSupport::BufferedLogger.new(config.log_path)
  Engines.logger.level = Logger::INFO
end

# this will cause classes in lib to be reloaded on each request in
# development mode. very useful if working on a source file in lib!

# TODO: for rails 2.1.1, change to ActiveSupport::Dependencies
ActiveSupport::Dependencies.mechanism = :load
ActiveSupport::Dependencies.load_once_paths.delete("#{RAILS_ROOT}/lib")
#::Dependencies.load_once_paths.delete(Dir[RAILS_ROOT + '/mods'])
#::Dependencies.load_once_paths.delete(Dir[RAILS_ROOT + '/tools'])

ASSET_PRIVATE_STORAGE = "#{RAILS_ROOT}/test/fixtures/assets"
ASSET_PUBLIC_STORAGE  = "#{RAILS_ROOT}/public/assets"
KEYRING_STORAGE = "#{RAILS_ROOT}/test/fixtures/assets/keyrings"

