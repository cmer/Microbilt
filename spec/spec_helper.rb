require "bundler/setup"
require "factory_girl"
require "microbilt"
require "simplecov"
require "dotenv"
Dotenv.load '.env.test'

SimpleCov.start do
  coverage_dir 'spec/reports'
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
  end
end
