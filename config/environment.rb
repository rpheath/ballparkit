# ENV['RAILS_ENV'] ||= 'production'

RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # You have to specify the :lib option for libraries, where the Gem name (sqlite3-ruby) differs from the file itself (sqlite3)
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem 'mislav-will_paginate', 
    :version => '~> 2.3.6', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'ruby-openid',
    :version => '~> 2.0.4', :lib => 'openid'
  config.gem 'colored'

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  # config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
  #   File.directory?(lib = "#{dir}/lib") ? lib : dir
  # end

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'Eastern Time (US & Canada)'

  config.action_controller.session = {
    :session_key => '_ballpark_session',
    :secret      => '613c7b031ce2968fa5b09947b8c3ff12e8a4e35ba123e622efc13f1f5cd5dd1c2006bb6f8712c36fc1da13b7c7e95ee11148be0ebed076327d13b6bc236236e9'
  }
end

%w(will_paginate openid).each { |lib| require lib }