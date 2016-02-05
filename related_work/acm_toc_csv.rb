#!/usr/bin/env ruby

require 'deep_enumerable'
require 'open-uri'
require 'nokogiri'

toc_url = 'icpc2015.html'
toc = Nokogiri::HTML(open(toc_url))

XPATHS = {
  title: '//td/span/a[starts-with(@href, "citation")]/text()',
  author: ['//ancestor::span[a[starts-with(@href, "author_page")]]', ->(s){s.gsub(/\s+/, ' ').gsub(/^ | $/, '')}],
  abstract: '//span[starts-with(@id, "toHide")]',
  link: ['//span/a[@name ="FullTextPDF"]/@href', ->(s){"http://dl.acm.org/" + s}]
}

length = 39

data = XPATHS.shallow_map_values do |col, (xpath, cleanup)| 
  res = toc.xpath(xpath).map(&:text)
  if cleanup then res.map(&cleanup) else res end
end

p data.values.all?{|row| row.size == length}
p data.values.map(&:last)
