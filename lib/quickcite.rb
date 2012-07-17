#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require "bibtex"
require 'optparse'

require 'quickcite/citeulike'

CITE_REGEX = /\\cite\{([^\}]+)\}/

module QuickCite
  class Main
    def initialize(latex_files, bibtex_file) 
      @bib = BibTeX.open(bibtex_file, :include => [:meta_content])
      puts("here")
      latex_files.each do|f|
        process_latex(f)
      end
    end

    def process_cite(cite)
      if !@bib.has_key?(cite) then
        puts(cite)
      end
      puts("here2: ", cite)
      CiteULike.search(cite)
    end

    def process_match(cite)
      puts("here: ", cite[0].split(','))
      cite[0].split(',').map do|c| 
        process_cite(c)
      end
    end

    def process_latex(f)
      latex = File.read(f)
      latex.scan(CITE_REGEX) do|m|
        process_match(m)
      end
      puts(f)
    end
  end
  
  def self.run(latex_files, bibtex_file) 
    puts("here")
    Main.new(latex_files, bibtex_file)
  end
end
