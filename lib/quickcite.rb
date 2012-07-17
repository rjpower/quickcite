#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require "bibtex"
require 'optparse'

require 'quickcite/citeulike'

CITE_REGEX = /\\cite\{([^\}]+)\}/

def process_cite(bib, cite)
  if !bib.has_key?(cite) then
    puts(cite)
  end
end

def process_match(bib, cite)
  cite[0].split(',') do 
    process_cite(bib, cite)
  end
end


flags = {}
optparse = OptionParser.new do|opts|
 opts.banner = "Usage: quickrite -b <bibtex file> latex1 latex2 ... "

 flags[:bibtex] = nil
 opts.on( '-b', '--bibtex FILE', 'Extract/generate references to FILE' ) do|file|
   flags[:bibtex] = file
 end
end

optparse.parse!


bib = BibTeX.open(flags[:bibtex], :include => [:meta_content])
ARGV.each do|f|
  latex = File.read(f)
  latex.scan(CITE_REGEX) do|m|
    process_match(bib, m)
  end
  puts(f)
end
