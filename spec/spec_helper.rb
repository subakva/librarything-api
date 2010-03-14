$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'librarything-api'
require 'spec'
require 'spec/autorun'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','helpers','**','*.rb'))].each { |f| require f }

LibraryThing::DEVELOPER_KEY = 'lt_test_key'

Spec::Runner.configure do |config|
  
end
