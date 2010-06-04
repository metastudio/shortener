require 'rubygems'
require 'sinatra'
require 'haml'
require 'mongo'
require 'mongo_mapper'
require 'digest/sha1'
require 'rack-flash'
require 'sinatra-authentication'

use Rack::Session::Cookie, :secret => 'jwdgpo2jen0xu3-0332'
use Rack::Flash

include Mongo
require 'models/url'
require 'models/mm_user'

DB = Connection.new(ENV['DATABASE_URL'] || 'localhost')
MongoMapper.connection = DB
if ENV['DATABASE_USER'] && ENV['DATABASE_PASSWORD']
  auth = DB.authenticate(ENV['DATABASE_USER'], ENV['DATABASE_PASSWORD'])
end
MongoMapper.database = 'shortener'

post '/shorten' do
  validate_url  params[:url]
  shorten       params[:url]
  slug    =     slug_for params[:url]
  "http://#{request.host}/#{slug}"
end

get '/mine' do
  login_required
  haml :links
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
    if Url.all(:url => url).count == 0
      params = {
        :url     => url,
        :slug    => Url.count.to_s(36),
        :hits    => 0,
      }
      params[:mm_user] = current_user if logged_in?
      Url.create(params)
    end
  end
 
  def slug_for(url)
    Url.first(:url => url).slug
  end
 
  def url_for(slug)
    row = Url.first(:slug => slug)
    (row.hit and return row['url']) unless row.nil?
    halt(404, "Not found")
  end
end