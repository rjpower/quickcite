require File.expand_path("../lib/quickcite/version", __FILE__)

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "Automatic citation lookup and management"
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

Usage:

    quickcite -b ref.bib *.tex

Each \\cite command which does not have a matching entry in ref.bib will be searched
for using DBLP.  Simply choose the result that matches the reference you want and your
bibtex file will be updated automatically.
  END
  s.add_dependency "bibtex-ruby", ">=2.0"
  s.add_dependency "json"
  s.add_dependency "nokogiri"
  s.add_dependency "highline"
  s.add_dependency "bundler"
end
