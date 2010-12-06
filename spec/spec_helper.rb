ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../../blacklight/config/environment" unless defined?(RAILS_ROOT)
require 'spec/rails'
require File.dirname(__FILE__) + "/../lib/blacklight_tagcloud"


class Blacklight::TagCloudTestClass
  def catalog_index_path(*args)
    'http://localhost:3000/catalog'
  end

  def link_to(value, url)
    ''
  end
end

