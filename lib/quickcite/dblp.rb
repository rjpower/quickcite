#!/usr/bin/env ruby
#
# Searches and downloads bibtex entries from CiteULike (citeulike.org)
#
# Author:: Russell Power (power@cs.nyu.edu)

require "net/http"
require "nokogiri"
require "json"
require "uri"

module QuickCite
  class DBLP
    # NB -- DBLP seems to expect query arguments in a certain order - 
    # the q= argument has to come first.
    SEARCH_BASE = "http://www.dblp.org/search/api/?"
    SEARCH_SUFFIX = "&c=4&f=0&format=json&h=10"
    
    def hit_to_result(h)
      t = h["title"]
      title = t["dblp:title"]["text"]
      venue = t["dblp:venue"]["text"]
      authors = t["dblp:authors"]["dblp:author"]
      date = t["dblp:year"].to_s
      Result.new(
        :title => title, 
        :authors => authors.to_a, 
        :url => h["url"], 
        :venue => venue,
        :date => date)
    end
    
    def search(query)
      #json = JSON.parse(File.read("test/foobar.json"))
      query_str = "q=" + URI::escape(query.join(" "))
      uri = URI::parse(SEARCH_BASE + query_str + SEARCH_SUFFIX)
      
      puts("Fetching from #{uri}")
      
      response = Net::HTTP::get(uri)
      json = JSON.parse(response)
     
      hit_count = json["result"]["hits"]["@sent"];
      if hit_count == 0 then
        []
      end

      hits = json["result"]["hits"]["hit"]
      
      # NB.  when there is only a single result DBLP returns a single
      # hit element instead of an array.
      case hits
      when Array 
        hits.map {  |h| hit_to_result(h) }
      else
        [hit_to_result(hits)]
      end
    end
    
    def bibtex(result)
      #      dom = Nokogiri.Slop(open("test/power-piccolo.html"))
      dom = Nokogiri.Slop Net::HTTP.get(URI::parse(result.url))
      entries = dom.html.body.pre
      case entries
      when Nokogiri::XML::NodeSet
        return entries[0].to_str
      else
        return entries.to_str
      end
    end
  end
end
