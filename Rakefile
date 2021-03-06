require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "librarything-api"
    gem.summary = %Q{Gem for accessing the LibraryThing API}
    gem.description = %Q{Gem for accessing the LibraryThing API}
    gem.email = "jdwadsworth@gmail.com"
    gem.homepage = "http://github.com/subakva/librarything-api"
    gem.authors = ["Jason Wadsworth"]
    gem.add_development_dependency "rspec", ">= 1.3.0"
    gem.add_development_dependency "fakeweb", ">= 1.2.8"
    gem.add_development_dependency "yard", ">= 0"
    gem.add_development_dependency "rack", ">= 1.0.0"
    gem.add_development_dependency "rcov", ">= 0.9.8"
    gem.add_dependency "httparty", ">= 0.5.2"
    gem.add_dependency "nokogiri", ">= 1.4.1"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.ruby_opts << ['-r rubygems']
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
