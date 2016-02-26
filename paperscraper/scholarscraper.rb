#!/usr/bin/env ruby
require 'csv'
require 'open-uri'
require 'nokogiri'
require 'pp'

SLEEP_DURATION = 5

if !ARGV[0]
  puts
  puts "Usage: ./scholarscraper.rb icpc.csv"
  puts
  puts "Your csv must be tab-delimited (??) and have the following headers: Year, Title, Authors"
  puts "Any column can be left blank for convenience"
  exit 1
end

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
  url = "https://scholar.google.com/scholar?hl=en&q='#{paper[:title]}' #{paper[:year]} #{paper[:authors]}&btnG=&as_sdt=1%2C33&as_sdtp="
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
   sleep SLEEP_DURATION
   result
 end
end

citation_links = scholar_queries.map do |html|
  doc = Nokogiri::HTML(html)
  matches = doc.xpath('//a[starts-with(text(), "Cited by")]/@href')
  matches.first.to_s
end.compact.reject(&:empty?)


citation_htmls = citation_links.map do |link|
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
       sleep SLEEP_DURATION
       result
     end
  results << html
  doc = Nokogiri::HTML(html)
  matches = doc.xpath('//b[text()="Next" and not(contains(@style,"hidden"))]')
  more_results = !!matches.first
  offset += 10
 end

 results
end

citing_papers = citation_htmls.flatten.map do |html|
  doc = Nokogiri::HTML(html)
  cited_title = doc.xpath('//div[@id="gs_rt_hdr"]/h2/a/text()').text

  divs = doc.xpath('//div[@class="gs_ri"]')
  citers = divs.map do |div|
    title = div.xpath('./h3[@class="gs_rt"]/a/text()').text
    if title.empty?
      title = div.xpath('./h3[@class="gs_rt"]/text()').text
    end
    names = div.xpath('./div[@class="gs_a"]//text()').map(&:text).join
    n_citations = div.xpath('./div/a[starts-with(text(), "Cited by")]').text
    [title, names, n_citations, cited_title]
  end
end.flatten(1)

#pp citing_papers.take(3)

counted_citers = citing_papers.group_by(&:first).map do |title, list|
  {
    citing_paper_title: title,
    citing_paper_authors: list.first[1],
    citing_paper_citations: list.first[2],
    num_cited_papers: list.size,
    cited_paper_titles: list.map(&:last).join(" | ")
  }
end.sort_by{|x| -x[:num_cited_papers]}

CSV.open("citation_counts.csv", "w") do |csv|
  csv << counted_citers.first.keys

  counted_citers.each do |citer|
    csv << citer.map do |k, v|
      v.to_s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    end
  end
end

