#!/usr/bin/env ruby
#
# Searches and downloads bibtex entries from CiteULike (citeulike.org)
#
# Author:: Russell Power (power@cs.nyu.edu)

require "net/http"
require "uri"
require "json"

HOST = "http://www.citeulike.org"
SEARCH_BASE = "/json/search/all"
BIBTEX_OPTIONS = "do_username_prefix=0&key_type=4&incl_amazon=1&clean_urls=1&smart_wrap=1&q="

module CiteULike
  def self.search(query)
    http = Net::HTTP.new(HOST)
    request = Net::HTTP::Get.new(SEARCH_BASE)
    request.set_form_data({ "q" => query })
    response = http.request(request)
    js = JSON.Parse(response.body)
    return js
  end
end
