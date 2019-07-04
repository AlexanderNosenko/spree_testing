lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_product_import/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_product_import'
  s.version     = SpreeProductImport.version
  s.summary     = 'SpreeProductImport allows to import products with configurable taxonomies from csv files'
  s.required_ruby_version = '>= 2.2.7'

  s.author    = 'Alexaner Nosenko'
  s.email     = 'sania.ace@gmail.com'
  s.homepage  = 'https://github.com/AlexandrNosenko/spree_testing'
  s.license = 'BSD-3-Clause'

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 3.1.0', '< 4.0'
  s.add_dependency 'spree_extension'
  s.add_dependency('delayed_job')

  # s.add_development_dependency 'database_cleaner'
  # s.add_development_dependency 'factory_girl'
  # s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  # s.add_development_dependency 'simplecov'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'appraisal'
end
