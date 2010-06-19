require File.dirname(__FILE__) + '/spec_helper'

describe "My App" do
  include Rack::Test::Methods
  
  before(:each) do
    MmUser.destroy_all
    @user = MmUser.make
  end

  def app
    @app ||= Sinatra::Application
  end
  
  def do_login
    post '/login', {:email => @user.email, :password => @user.password}
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
  
  it "should shorten urls for unregistered users" do
    post '/shorten', {:url => "http://minetest.ru"}
    last_response.should be_ok
  end
  
  it "should shorten urls for registered users" do
    do_login
    last_response.status.should == 302
    get '/'
    last_response.body.include?("Hi, #{@user.email}").should be_true
    post '/shorten', {:url => "http://anothertest.ru"}
    last_response.should be_ok
  end
  
  it "should show posted urls for registered user" do
    3.times { |i| Url.make(:mm_user => @user, :url => "http://example.ru/#{i}") }
    do_login
    last_response.status.should == 302
    get '/mine'
    last_response.body.include?("Mine links are so mine").should be_true
    last_response.body.include?("http://example.ru/0").should be_true
    last_response.body.include?("http://example.ru/1").should be_true
    last_response.body.include?("http://example.ru/2").should be_true
  end
end