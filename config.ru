require 'rubygems'
require 'sinatra'
 
set :env, :production
disable :run

require 'shortener'

log = File.new("/home/akhkharu/projects/akhkharu.ru/shared/log/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

run Sinatra::Application