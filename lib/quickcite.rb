#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require "bibtex"
require "optparse"
require "readline"
require "quickcite/citeulike"
require "quickcite/dblp"
require "quickcite/flags"

module QuickCite
  CITE_REGEX = /\\cite[tp]?\{([^\}]+)\}/
  SPLIT_REGEX = /([A-Z]{0,1}[a-z]+)/
   
  @source = DBLP.new
  
  class Result < Struct.new(:title, :venue, :authors, :url, :date)    
    def initialize(hash)
      super(*hash.values_at(:title, :venue, :authors, :url, :date))
    end
  end
  
  # Convert a citation reference (e.g "PowerPiccolo2008") into a
  # list of strings appropriate for submission to a search engine.
  #
  # By default the citation is split on lowercase->uppercase transitions.
  def self.cite_to_query(cite)
    cite.scan(SPLIT_REGEX).map { |w| w[0] }
  end
  
  # Query the user for a result from the result list to 
  # use for this citation reference.  
  # 
  # Returns the selected reference or nil if no match
  # was selected.
  def self.ask_user(cite, result_list)
    if result_list.empty? then
      return nil
    end
    
    puts "Result to use for \{#{cite}\}: "
    puts "  (0) Skip this citation"
    result_list.each_with_index do |r, idx|
      puts "  (#{idx + 1}) #{r.title} (#{r.date})"
      puts "      Authors: #{r.authors.join(', ')}"
      puts "      Venue: #{r.venue}"
    end
    
    c = Integer(STDIN.readline.strip)
    if c > 0 && c <= result_list.length then
      return result_list[c - 1]
    end
  end
  
  def self.update_bibtex(cite, entry)
    e = BibTeX.parse(@source.bibtex(entry)).first
    e.key = cite
    @bib << e
  end
  
  def self.process_cite(cite)
    if @bib.has_key?(cite) then
      puts("Skipping matched reference #{cite}")
    else
      puts("Missing reference for #{cite}")
      query = cite_to_query(cite)
      if FLAGS.dryrun
        puts("Would have run query: #{query}") 
        return
      end
      
      results = @source.search(query)
      accepted = ask_user(cite, results)
      if accepted == nil
        puts "Skipping update for reference #{cite}"
      else
        puts "Updating bibtex for #{cite} with result: \n#{accepted.title}"
        update_bibtex(cite, accepted)
      end
    end
  end
  
  def self.process_latex(f)
    latex = File.read(f)
    latex.scan(CITE_REGEX) { |m|
      m[0].split(",").map  { |c|
        process_cite(c)
      }
    }
  end
  
  def self.run
    p FLAGS
    
    bibtex_file = FLAGS.bibtex
    latex_files = FLAGS.latex
     
    if !File.exists?(bibtex_file) then
      puts "Bibtex file #{bibtex_file} does not exist.  Creating an empty file."
      open(bibtex_file, "w").write("")
    end
    
    @bib = BibTeX.open(bibtex_file, :include => [:meta_content])
    
    latex_files.each { |f|
      puts("Processing... #{f}")
      process_latex(f)
    }
    
    puts("Writing bibtex...")
    outfile = open(bibtex_file, "w")
    outfile.write(@bib.to_s)
    outfile.close
  end
end
