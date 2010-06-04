require File.dirname(__FILE__) + '/spec_helper'

describe "My App" do
  include Rack::Test::Methods
  
  before(:each) do
    @user = MmUser.create({
      :email    => "test@user.com",
      :password => "12345",
    })
  end

  def app
    @app ||= Sinatra::Application
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
    post '/login', {:email => @user.email, :password => @user.password}
    last_response.status.should == 302
    get '/'
    last_response.body.include?("Hi, #{@user.email}").should be_true
    post '/shorten', {:url => "http://anothertest.ru"}
    last_response.should be_ok
  end
  
  it "should show posted urls for registered user" do
    pending
  end
end