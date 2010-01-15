require 'rubygems'
require 'rake'

$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")
require 'log_master/rake/log_task'

Dir['tasks/*.rake'].each { |rake| load rake }

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "log_master"
    gem.summary = %Q{Creates and emails a simple report for a set of log (or text) files. Useful for aggretating small log files.}
    gem.description = %Q{Creates and emails a simple report for a set of log (or text) files. Useful for aggretating small log files.}
    gem.email = "zbelzer@gmail.com"
    gem.homepage = "http://github.com/moneypools/log_master"
    gem.authors = ["Zachary Belzer"]
    gem.add_dependency "actionmailer", ">= 2.2.2"
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "email_spec", " >= 0.3.5"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "log_master #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end