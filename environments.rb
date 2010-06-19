configure do
  set :root, File.dirname(__FILE__)
end

configure :test do
  @db_name = "shortener_test"
end

configure :development do
  @db_name = "shortener_development"
end

configure :production do
  @db_name = "shortener"
end
