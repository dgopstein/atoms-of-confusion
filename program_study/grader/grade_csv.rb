#!/usr/bin/env ruby

require './unify_output.rb'
require './grader_util.rb'

require 'csv' 
require 'open3'
require 'pp'

results_file = ARGV[0]

if results_file.nil?
  puts "Usage: grade_csv.rb results_file.csv"
  exit(1)
end

results = CSV.read(results_file, headers: true)

pilot_ids = [3782, 1161, 1224, 3270, 9351, 6490, 4747, 6224, 3881, 6033]

pilot_results = results.select{|r| pilot_ids.include?(r["Subject"].to_i)}.map{|r| r["Subject"].to_i}

compile_graders!

#scores = ('a'..'h').each_with_object(Hash.new{[]}) do |q, hash|
#  score = results[q.upcase].compact.map { |s| run_grader(q, s) }
#  hash[q] += score
#end

#scores = ('a'..'h').flat_map do |q|
#  results[q.upcase].compact.map { |s| [q, results['Subject'], run_grader(q, s)] }
#end

scores = results.flat_map do |r|
  ('a'..'h').map do |q|
    ans = r[q.upcase]
    ans and [r['Subject'].to_i, q, run_grader(q, ans)]
  end.compact
end

puts "subject,qtype,correct,points"
puts scores.map{|r| r.flatten.to_csv }

#score_avgs = scores.map do |type, scores|  
#  num, denom = scores.transpose.map{|x| x.inject(:+)}
#
#  [type, (num.to_f / denom).round(2)]
#end.to_h

#pp score_avgs


