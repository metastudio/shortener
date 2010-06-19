require 'mongo_mapper'

class Url
  include MongoMapper::Document
  
  key :url, String, :required => true
  key :slug, String
  key :hits, Integer
  key :mm_user_id, ObjectId
  timestamps!
  
  belongs_to :mm_user
  
  before_create :slugify
  
  validate :validate_url_correct
  
  class <<self
    def next_slug
      Url.count.to_s(36)
    end
  end
  
  def hit
    self.hits ||= 0
    self.hits += 1
    self.save
  end
  
  protected
  
  def slugify
    self.slug = Url.next_slug    
  end
  
  def validate_url_correct
    errors.add(:url, "incorrect") if (url =~ /^(https?|ftp)\:\/\//i) == nil
  end
end