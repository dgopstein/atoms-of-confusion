#!/usr/bin/env ruby
require 'csv'
require 'open-uri'
require 'nokogiri'

papers = CSV.table(ARGV[0], col_sep: "\t").map(&:to_h)

def paper_cache_name(paper)
  y = paper[:year]
  a = paper[:authors].scan(/\w\w\w+/).first
  t = paper[:title].scan(/.*?\w\w\w+.*?\w\w\w+/).first.gsub(/\W/, '_')

  "cache/#{y}_#{a}_#{t}.html"
end

def citation_url_cache_name(citation_url, offset)
  id = citation_url.scan(/\d\d\d\d+/).first
  'cache/cites_%d_%03d.html'%[id, offset]
end

def query_scholar_for_paper(paper)
  url = "https://scholar.google.com/scholar?hl=en&q=#{paper[:title]} #{paper[:year]} #{paper[:author]}&btnG=&as_sdt=1%2C33&as_sdtp="
  open(url).read
end

def query_scholar_by_rel_link(link, offset)
  url = "https://scholar.google.com/#{link}&start=#{offset}"
  open(url).read
end

scholar_queries = papers.map do |paper|
 cn = paper_cache_name(paper)
 if File.exists?(cn)
   open(cn).read
 else
   result = query_scholar_for_paper(paper)
   File.write(paper_cache_name(paper), result)
   sleep 1
   result
 end
end

citation_links = scholar_queries.map do |html|
  doc = Nokogiri::HTML(html)
  matches = doc.xpath('//a[starts-with(text(), "Cited by")]/@href')
  matches.first.to_s
end

citation_links.map do |link|
 offset = 0
 results = []
 more_results = true

 while more_results
   cn = citation_url_cache_name(link, offset)
   html = 
     if File.exists?(cn)
       open(cn).read
     else
       result = query_scholar_by_rel_link(link, offset)
       File.write(citation_url_cache_name(link, offset), result)
       sleep 5
       result
     end
  doc = Nokogiri::HTML(html)
  matches = doc.xpath('//b[text()="Next" and not(contains(@style,"hidden"))]')
  more_results = !!matches.first
  p [link, offset, more_results]
  offset += 10
 end
end
