require "rubygems"
require "bundler"
Bundler.setup

require "sinatra"
require "haml"
require "mongo"
require "mongo_mapper"
require "digest/sha1"
require "sinatra-authentication"

require "rack-flash"
use Rack::Session::Cookie, :secret => 'jwdgpo2jen0xu3-0332'
use Rack::Flash

require "environments"
require "mongo_init"
require "models/url"
require "models/mm_user"

get '/' do
  haml :index
end

post '/shorten' do
  check_if_same(params[:url])
  shorten(params[:url])
  slug = slug_for(params[:url])
  "http://#{request.host}/#{slug}"
end

get '/mine' do
  login_required
  haml :mine
end

get '/:slug' do |slug|
  redirect(url_for(slug))
end

helpers do
  def check_if_same(url)
    halt(400, "Same URL") if url.index("http://#{request.host}") == 0
  end
  
  def shorten(url)
    if Url.all(:url => url).count == 0
      params = {:url => url}
      params[:mm_user] = current_user if logged_in?
      Url.create(params)
    end
  end
 
  def slug_for(url)
    Url.first(:url => url).slug
  end
 
  def url_for(slug)
    row = Url.first(:slug => slug)
    unless row.nil?
      row.hit and return row['url']
    else
      halt(404, "Not found")
    end
  end
end