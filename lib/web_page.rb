require 'mongoid'

class WebPage
  include Mongoid::Document
  embeds_many :articles
end
