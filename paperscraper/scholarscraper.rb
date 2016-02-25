#!/usr/bin/env ruby
require 'csv'
require 'open-uri'

papers = CSV.table(ARGV[0], col_sep: "\t").map(&:to_h)

def cache_name(paper)
  y = paper[:year]
  a = paper[:authors].scan(/\w\w\w+/).first
  t = paper[:title].scan(/.*?\w\w\w+.*?\w\w\w+/).first.gsub(/\W/, '_')

  "cache/#{y}_#{a}_#{t}.html"
end

def query_scholar(paper)
  url = "https://scholar.google.com/scholar?hl=en&q=#{paper[:title]} #{paper[:year]} #{paper[:author]}&btnG=&as_sdt=1%2C33&as_sdtp="
  open(url).read
end

scholar_queries = papers.map do |paper|
 cn = cache_name(paper)
 if File.exists?(cn)
   open(cn).read
 else
   result = query_scholar(paper)
   File.write(cache_name(paper), result)
   sleep 1
   result
 end
end

