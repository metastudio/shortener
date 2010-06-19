require "machinist/mongo_mapper"
require "sham"

Url.blueprint do
  url "http://example.ru/"
end

MmUser.blueprint do
  email "test@user.com"
  password "12345"
end