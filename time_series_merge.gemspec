$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "time_series_merge/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "time_series_merge"
  s.version     = TimeSeriesMerge::VERSION
  s.authors     = ["Roman Gnatyuk"]
  s.email       = ["gnat.dev@gmail.com"]
  s.homepage    = "https://www.linkedin.com/in/gnatyuk/"
  s.summary     = "Time Series Merge"
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "trollop", "~> 2.1", ">= 2.1.2"

  s.add_development_dependency "rspec", "~> 3.1.0"
end
