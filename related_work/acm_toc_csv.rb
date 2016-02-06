#!/usr/bin/env ruby

require 'deep_enumerable'
require 'open-uri'
require 'nokogiri'
require 'csv'


acm_years = [2014, 2015]
comporg_years = [1996, 1997, 2003, 2006..2008, 2010..2013].map{|x| x.to_a rescue x }.flatten
dblp_years = [1998..2002, 2004..2005, 2009].map{|x| x.to_a rescue x }.flatten

XPATHS_ACM = {
  title: '//td/span/a[starts-with(@href, "citation")]/text()',
  author: ['//ancestor::span[a[starts-with(@href, "author_page")]]/text()', ->(s){s.gsub(/\s+/, ' ').gsub(/^ | $/, '')}],
  link: ['//span[starts-with(text(), "Pages")]/following::tr[1]/td//a/@href/text()', ->(s){"http://dl.acm.org/" + s}], # will grab the next link if the current one isn't there
  abstract: '//span[starts-with(@id, "toHide")]/text()',
}

XPATHS_COMPORG = {
  title: '//div[@class="tableOfContentsLineItemTitle"]/a[contains(@href, ".html")]/text()',
  author: ['//div[@class="tableOfContentsLineItemTitle"]/a[contains(@href, ".html")]/ancestor::div[@class="tableOfContentsLineItem"]',
          ->(x){x.xpath('./div[@class="tableOfContentsLineItemCreator"]//a').map(&:text).join(", ").gsub('"', '')}],
  link: ['//input[starts-with(@name, "xplore_doi")]/@value', ->(x){'http://ieeexplore.ieee.org/xpl/articleDetails.jsp?arnumber='+x.text.split('.').last}],
  #abstract: '',
}

XPATHS = XPATHS_COMPORG

comporg_years.each do |year|
  # Read the proceedings webpage
  toc_url = "icpc#{year}.html"
  toc = Nokogiri::HTML(open(toc_url))

  data = XPATHS.shallow_map_values do |col, (xpath, cleanup)| 
    res = toc.xpath(xpath)
    if cleanup then res.map(&cleanup) else res end
  end

  csv = CSV.generate do |csv|
    data.values.transpose.each do |row|
      csv << [year] + row
    end
  end

  File.write("icpc#{year}.csv", csv)
end

