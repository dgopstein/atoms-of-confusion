require 'deep_enumerable'
require 'open-uri'
require 'nokogiri'

#all_proceedings_url = 'http://www.program-comprehension.org/pastevents.html'
#all_proceedings = open(all_proceedings_url).read

#toc_url = 'http://dl.acm.org/citation.cfm?id=2820282&preflayout=flat'
toc_url = 'icpc2015.html'
toc = Nokogiri::HTML(open(toc_url))

XPATHS = {
  title: '//td/span/a[starts-with(@href, "citation")]/text()',
  author: '//span/a[starts-with(@href, "author_page")]'
}

length = 39

data = XPATHS.shallow_map_values do |col, xpath| 
  toc.xpath(xpath).map(&:text)
end

p data.values.all?{|row| row.size}
p data.values.last.last
