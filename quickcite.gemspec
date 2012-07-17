require File.expand_path("../lib/quickcite/version", __FILE__)

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "Efficient citation lookup and management"
  s.name = "quickcite"
  s.authors = ["Russell Power"]
  s.version = QuickCite::VERSION
  s.email = "power@cs.nyu.edu"
  s.require_path = "lib"
  s.files = `git ls-files`.split("\n")
  
  s.add_dependency "bibtex-ruby", ">=2.0"
  s.add_dependency "json"
  s.add_development_dependency "bundler"
end
