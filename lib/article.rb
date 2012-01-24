class Article
  include Mongoid::Document

  embedded_in :web_page, :inverse_of => :articles, :class_name => "WebPage"
end
