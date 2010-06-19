require "rubygems"
require "sinatra"
require "rack/test"

set :environment, :test
require File.join(File.dirname(__FILE__), '..', 'shortener.rb')

set :run, false
set :raise_errors, true
set :logging, false

require "spec"
require "spec/autorun"
require "spec/interop/test"
require "spec/blueprints"
require "rr"

require File.expand_path(File.dirname(__FILE__) + "/blueprints")

Spec::Runner.configure do |config|
  config.mock_with :rr
end
