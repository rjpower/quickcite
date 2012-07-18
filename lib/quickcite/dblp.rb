#!/usr/bin/env ruby
#
# Searches and downloads bibtex entries from CiteULike (citeulike.org)
#
# Author:: Russell Power (power@cs.nyu.edu)

require "net/http"
require "nokogiri"
require "quickcite/json"
require "uri"

module QuickCite
  class DBLP
    # NB -- DBLP seems to expect query arguments in a certain order - 
    # the q= argument has to come first.
    SEARCH_BASE = "http://www.dblp.org/search/api/?"
    SEARCH_SUFFIX = "&c=4&f=0&format=json&h=10"

    Result = Struct.new("Result", :title, :authors, :url)
    def search(query)
      #      json = JSONUtil.parse(File.read("test/power-piccolo.json"))
      query_str = "q=" + URI::escape(query.join(" "))
      uri = URI::parse(SEARCH_BASE + query_str + SEARCH_SUFFIX)
      
      response = Net::HTTP::get(uri)
      json = JSONUtil.parse(response)

      json.result.hits.hit.map do |h|
        Result.new(
        h.title["dblp:title"].text,
        h.title["dblp:authors"]["dblp:author"].to_a,
        h.url)
      end
    end

    def bibtex(result)
      #      dom = Nokogiri.Slop(open("test/power-piccolo.html"))
      puts("RESULT #{result.url}")
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
