# shortener.rb
require 'rubygems'
require 'sinatra'
require 'haml'
require 'mongo'

include Mongo

DB = Connection.new(ENV['DATABASE_URL'] || 'localhost').db('shortener')
if ENV['DATABASE_USER'] && ENV['DATABASE_PASSWORD']
  auth = DB.authenticate(ENV['DATABASE_USER'], ENV['DATABASE_PASSWORD'])
end

post '/shorten' do
  shorten   params[:url]
  slug    = slug_for params[:url]
  @shortened = "/#{slug}"
  haml :render
end

get '/' do
  haml :new
end

get '/:slug' do |slug|
  redirect(url_for(slug))
end

helpers do
  def shorten(url)
    if DB['urls'].find('url' => url).count == 0
      DB['urls'].insert('url' => url, 'slug' => DB['urls'].count.to_s(36))
    end
  end
 
  def slug_for(url)
    DB['urls'].find('url' => url).collect {|row| row['slug'] }.flatten
  end
 
  def url_for(slug)
    DB['urls'].find('slug' => slug).collect {|row| row['url'] }.flatten
  end
end