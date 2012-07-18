#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require "highline/system_extensions"
require "bibtex"
require "optparse"
require "readline"
require "quickcite/citeulike"
require "quickcite/dblp"

module QuickCite
  CITE_REGEX = /\\cite\{([^\}]+)\}/
  SPLIT_REGEX = /([A-Z]+[a-z]+|[0-9]+|[^\\p]+)/
  
  # Convert a citation reference (e.g "PowerPiccolo2008") into a
  # list of strings appropriate for submission to a search engine.
  #
  # By default the citation is split on lowercase->uppercase transitions.
  def self.cite_to_query(cite)
    cite.scan(SPLIT_REGEX).map { |w| w[0] }
  end

  def self.ask_user(cite, result_list)
    puts "Result to use for \{#{cite}\}: "
    puts "  (0) Skip this citation"
    result_list.each_with_index do |r, idx|
      puts "  (#{idx + 1}) #{r.title}"
      puts "      #{r.authors.join(', ')}"
    end
    
    c = HighLine::SystemExtensions::get_character.chr.to_i
    if c > 0 && c <= result_list.length then
      return result_list[c - 1]
    end
  end

  class Main
    include QuickCite
    def initialize(latex_files, bibtex_file)
      @source = DBLP.new
      @bib = BibTeX.open(bibtex_file, :include => [:meta_content])
        
      latex_files.each do|f|
        puts("Processing... #{f}")
        process_latex(f)
      end
      
      puts("Writing bibtex...")
      outfile = open(bibtex_file, "w")
      outfile.write(@bib.to_s)
      outfile.close
    end
    
    def update_bibtex(cite, entry)
      e = BibTeX.parse(@source.bibtex(entry)).first
      e.key = cite
      @bib << e
    end

    def process_cite(cite)
      if @bib.has_key?(cite) then
        puts("Skipping matched reference #{cite}")
      else
        puts("Missing reference for #{cite}")
        query = QuickCite.cite_to_query(cite)
        results = @source.search(query)
        accepted = QuickCite.ask_user(cite, results)
        if accepted == nil
          puts "Skipping update for reference #{cite}"
        else
          puts "Updating bibtex for #{cite} with result: \n#{accepted.title}"
          update_bibtex(cite, accepted)
        end
      end
    end

    def process_latex(f)
      latex = File.read(f)
      latex.scan(CITE_REGEX) do|m|
        m[0].split(",").map do|c|
          process_cite(c)
        end
      end
      puts(f)
    end
  end

  def self.run(latex_files, bibtex_file)
    Main.new(latex_files, bibtex_file)
  end
end