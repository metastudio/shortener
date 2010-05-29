require 'mongo_mapper'

class Url
  include MongoMapper::Document
  
  key :url, String, :required => true
  key :slug, String, :required => true
  key :hits, Integer
  key :mm_user_id, ObjectId
  timestamps!
  
  belongs_to :mm_user
  
  def hit
    self.hits = 0 if hits.nil?
    self.hits += 1
    self.save
  end
end