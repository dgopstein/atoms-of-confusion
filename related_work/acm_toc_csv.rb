#!/usr/bin/env ruby

require 'deep_enumerable'
require 'open-uri'
require 'nokogiri'
require 'csv'


acm_years = [2014, 2015]
comporg_years = [1996, 1997, 2003, 2006, 2007, 2008, 2010, 2011, 2013]
dblp_years = [1998..2002, 2004..2005, 2009].map{|x| x.to_a rescue x }.flatten
ieee_years = [2012]

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

XPATHS_DBLP = {
  title: '//li[@class="entry inproceedings"]//span[@class="title"]',
  author: ['//li[@class="entry inproceedings"]//div[@class="data"]',
    ->(x){x.text.split(':').first}],
  link: ['//li[@class="entry inproceedings"]//li[@class="drop-down"]/div/img | //li[@class="drop-down"]/div/a[contains(@href, ".org/10.1109")]/@href', ->(x){ x.text.empty? ? "no link" : 'http://ieeexplore.ieee.org/xpl/articleDetails.jsp?arnumber='+x.text.split('.').last}]
  #abstract: '',
}

XPATHS_IEEE = {
  title: '//span[contains(@id, "art-abs")]',
  author: ['//div[@class="authors" and ./a/text()]', ->(x){x.text.gsub(/\s+/,' ').strip}],
  link: ['//h3/a[contains(@href, "articleDetails")]/@href', ->(x){'http://ieeexplore.ieee.org/xpl/articleDetails.jsp?arnumber='+x.text.scan(/arnumber=(\d{7})/)[0][0]}],
  abstract: ['//div[contains(@class, "abstract")]', ->(x){x.text.split(/\n/)[3].strip}]
}

years = {acm: acm_years, XPATHS_COMPORG => comporg_years, XPATHS_DBLP => dblp_years, XPATHS_IEEE => ieee_years}

year_lookup = years.flat_map{|fmt, ys| ys.map{|year| [year, fmt]}}.to_h

[2012].each do |year|
  begin
    STDERR.puts "Processing #{year}"

    # Parse the proceedings webpage
    toc_url = "html/icpc#{year}.html"
    toc = Nokogiri::HTML(open(toc_url))

    # Extract data from the doc
    xpaths = year_lookup[year]
    data = xpaths.shallow_map_values do |col, (xpath, cleanup)| 
      res = toc.xpath(xpath)
      if cleanup then res.map(&cleanup) else res end
    end

    # Generate CSV
    csv = CSV.generate do |csv|
      data.values.transpose.each do |row|
        csv << [year] + row
      end
    end

    # Write to disk
    File.write("csv/icpc#{year}.csv", csv)
  rescue Exception => e
    puts e
  end
end

