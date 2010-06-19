include Mongo
DB = Connection.new(ENV['DATABASE_URL'] || 'localhost')
MongoMapper.connection = DB
DB.authenticate(ENV['DATABASE_USER'], ENV['DATABASE_PASSWORD']) if ENV['DATABASE_USER'] && ENV['DATABASE_PASSWORD']
MongoMapper.database = @db_name
