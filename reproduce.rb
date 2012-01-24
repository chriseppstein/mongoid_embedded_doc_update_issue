# Run like this:
# bundle exec ruby reproduce.rb
Bundler.require(:default)

begin
  logger = Mongoid::Logger.new($stdout)
  Mongoid.database = Mongo::Connection.new(nil, nil, :logger => logger).db("mongo_assignment_bug")
  Mongoid.database.collections.each do |c|
    puts c
    next if c.name =~ /system/
    c.drop
  end

  require_relative "lib/web_page"
  require_relative "lib/blog"
  require_relative "lib/article"

  WebPage.collection # accessing this before the blog's collection attribute is accessed is very important
  blog = Blog.new

  blog.articles = [Article.new]
  blog.save!

  puts "There are #{blog.articles.size} articles. There should be 1."
  puts blog.articles.inspect


  blog.articles = [Article.new] # This issues a $push instead of a $set because the update consumer is set against the subclass
                                # but the collection is holding a reference to the base class because it was referenced first.
  blog.save!

  blog.reload
  puts "There are #{blog.articles.size} articles. There should be 1."
  puts blog.articles.inspect
rescue Exception => e
  puts e.message
  puts e.backtrace.join("\n")
  raise
end
