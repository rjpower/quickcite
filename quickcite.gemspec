require File.expand_path("../lib/quickcite/version", __FILE__)

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "Efficient citation lookup and management"
  s.name = "quickcite"
  s.authors = ["Russell Power"]
  s.version = QuickCite::VERSION
  s.homepage = "https://github.com/rjpower/quickcite"
  s.email = "power@cs.nyu.edu"
  s.require_path = "lib"
  s.executables << "quickcite"
  s.files = `git ls-files`.split("\n")
  s.description = <<-END
Simplify your (academic) life.

Instead of manually hunting down references, let QuickCite do the work for you!

Visit https://github.com/rjpower/quickcite for install instructions.
  END
  s.add_dependency "bibtex-ruby", ">=2.0"
  s.add_dependency "json"
  s.add_dependency "nokogiri"
  s.add_dependency "highline"
  s.add_dependency "bundler"
end
