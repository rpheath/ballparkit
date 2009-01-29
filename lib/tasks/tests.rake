require 'colored'
 
def banner(title, pad = 85)
  puts "\n#{title} ".ljust(pad, "*").yellow
end
 
def stripe
  puts ("-" * 84 + "\n").yellow
end

namespace :test do  
  Rake::TestTask.new(:helpers) do |t|
    t.libs << "test"
    t.pattern = 'test/helpers/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:helpers'].comment = 'Run the helper tests in test/helpers'
end
 
namespace :tests do
  desc "Documents all tests in doc/TESTDOC"
  task :doc do
    File.open(RAILS_ROOT + '/doc/TESTDOC', 'w') do |file|
      Dir.glob('test/**/*_test.rb').each do |test|
        test =~ /.*\/([^\/].*)_test.rb$/
        file.puts "#{$1.gsub('_', ' ').capitalize}:" if $1
        File.read(test).map { |line| /test "(.*)" do$/.match line }.compact.each do |t|
          file.puts " - #{t[1]}"
        end
        file.puts
      end
    end
  end
  
  desc "Execute all application tests, plus TESTDOC"
  task :run do
    # document a list of all executed tests
    # (used to match up with requirements)
    Rake::Task['tests:doc'].invoke
    
    # unit tests
    banner "EXECUTING UNIT TESTS"
    Rake::Task['test:units'].invoke
    stripe
    
    # functional tests
    banner "EXECUTING FUNCTIONAL TESTS"
    Rake::Task['test:functionals'].invoke
    stripe
    
    # helper tests
    banner "EXECUTING HELPER TESTS"
    Rake::Task['test:helpers'].invoke
    stripe
    
    # integration tests
    banner "EXECUTING INTEGRATION TESTS"
    Rake::Task['test:integration'].invoke
    stripe
    
    # performance tests
    banner "EXECUTING APPLICATION BENCHMARKS"
    Rake::Task['test:benchmark'].invoke
    stripe
  end
end