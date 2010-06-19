require File.dirname(__FILE__) + '/../spec_helper'

describe Url do
  include Rack::Test::Methods
  
  before(:each) do
    Url.destroy_all
  end
  
  def app
    @app ||= Sinatra::Application
  end
  
  it "should automatically create slug for the new url" do
    url = Url.make
    url.slug.should == "0"
  end
  
  it "should not accept incorrect urls" do
    lambda { Url.make(:url => "bla") }.should raise_error(MongoMapper::DocumentNotValid, "Validation failed: Url incorrect")
  end
  
  it "should not accept empty urls" do
    lambda { Url.make(:url => "") }.should raise_error(MongoMapper::DocumentNotValid, "Validation failed: Url incorrect, Url can't be empty")
  end
end