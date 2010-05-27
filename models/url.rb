require 'mongo_mapper'

class URL
  include MongoMapper::Document
  
  key :url, String, :required => true
  key :slug, String, :required => true
  key :user_id, String
  timestamps!
  
  belongs_to :user
end