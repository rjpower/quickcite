require File.expand_path("../lib/quickcite/version", __FILE__)

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "Efficient citation lookup and management"
  s.name = "quickcite"
  s.authors = ["Russell Power"]
  s.version = QuickCite::VERSION
  s.url = "quickcite.github.com"
  s.email = "power@cs.nyu.edu"
  s.require_path = "lib"
  s.files = `git ls-files`.split("\n")
  s.description = <<-END
Simplify your (academic) life.

Instead of manually hunting down references, let QuickCite do the work for you!

Quickstart --

Install it:

gem install quickcite

Add it to your Makefile:

paper.pdf: ...
  quickcite -b paper.bib *.tex
  ...

That's it!
  END
  s.add_dependency "bibtex-ruby", ">=2.0"
  s.add_dependency "json"
  s.add_development_dependency "bundler"
end
