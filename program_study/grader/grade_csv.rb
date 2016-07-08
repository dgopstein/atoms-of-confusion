#!/usr/bin/env rvm 2.3.1 do ruby

# Read a CSV of raw user data and output a CSV of the score on every question for each user

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

#pilot_ids = [3782, 1161, 1224, 3270, 9351, 6490, 4747, 6224, 3881, 6033]
#pilot_ids = [3782, 1224, 3270, 9351, 6490, 4747, 6224, 3881, 6033]
#
#pilot_results = results.select{|r| pilot_ids.include?(r["Subject"].to_i)}.map{|r| r["Subject"].to_i}

compile_graders!

scores = results.flat_map do |r|
  ('a'..'h').map do |q|
    ans = r[q.upcase]
    ans and [r['Subject'].to_i, q, run_grader(q, ans).first]
  end.compact
end

puts "subject,qtype,correct,points"
puts scores.map{|r| r.flatten.to_csv }
