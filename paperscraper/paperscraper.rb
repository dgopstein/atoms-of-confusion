#! /usr/bin/env ruby
load 'mas_api.rb'
require 'csv'
require 'pp'

key = open('MAS_API_KEY.txt').each_line.first.strip
mja = MasJsonApi.new(key)

papers = CSV.table(ARGV[0], col_sep: "\t").map(&:to_h)

ids = papers.map do |paper|
  #id = mja.title_to_ids(paper[:year].to_s + ' ' +paper[:title])
  ids = mja.title_to_ids(paper[:title])
  p [paper[:title], ids]
  sleep 3
  ids.first
end.compact

citations = ids.map do |id|
  p get_citations(id)
end
