class MmUser
  include MongoMapper::Document

  key :name, String
    
  many :urls
end