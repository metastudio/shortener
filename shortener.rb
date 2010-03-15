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
  validate_url  params[:url]
  shorten       params[:url]
  slug    =     slug_for params[:url]
  "http://#{request.host}/#{slug}"
end

get '/signup' do
  haml :profile
end

post '/signup' do
  
end

get '/' do
  haml :new
end

get '/:slug' do |slug|
  redirect(url_for(slug))
end

helpers do
  def validate_url(url)
    halt(400, "Duplicate") if url.index("http://#{request.host}") == 0
    halt(400, "Bad URL") if (url =~ /^(https?|ftp)\:\/\//i) == nil
  end
  
  def shorten(url)
    if DB['urls'].find('url' => url).count == 0
      DB['urls'].insert('url' => url, 'slug' => DB['urls'].count.to_s(36))
    end
  end
 
  def slug_for(url)
    DB['urls'].find('url' => url).collect {|row| row['slug'] }.flatten
  end
 
  def url_for(slug)
    row = DB['urls'].find_one({'slug' => slug})
    unless row.nil?
      row['hits'] = row['hits'].nil? ? 1 : row['hits'].to_i + 1
      DB['urls'].save(row)
      return row['url']
    else
      halt(404, "Not found")
    end
  end
end