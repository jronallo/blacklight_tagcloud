require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the blacklight_tagcloud plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the blacklight_tagcloud plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'BlacklightTagcloud'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require File.expand_path(File.dirname(__FILE__) + '/../blacklight/spec/lib/test_solr_server.rb')

SOLR_PARAMS = {
  :quiet => ENV['SOLR_CONSOLE'] ? false : true,
  :jetty_home => ENV['SOLR_JETTY_HOME'] || File.expand_path('./../blacklight/jetty'),
  :jetty_port => ENV['SOLR_JETTY_PORT'] || 8888,
  :solr_home => ENV['SOLR_HOME'] || File.expand_path('./../blacklight/jetty/solr')
}

namespace :solr do

  desc "Calls RSpec Examples wrapped in the test instance of Solr"
  task :spec do
    # wrap tests with a test-specific Solr server
    error = TestSolrServer.wrap(SOLR_PARAMS) do
      rm_f "coverage.data"
      #Rake::Task["rake:spec"].invoke
      puts `spec spec`
      #puts `ps aux | grep start.jar`
    end
    raise "test failures: #{error}" if error
  end

end

