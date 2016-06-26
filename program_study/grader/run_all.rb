#!/usr/bin/env ruby

require './grader_util.rb'

require 'csv' 
require 'open3'
require 'pp'

results_file = ARGV[0]

if results_file.nil?
  puts "Usage: run_all.rb results_file.csv"
  exit(1)
end

results = CSV.read(results_file, headers: true)

compile_graders!

scores = results.flat_map do |r|
  ('a'..'h').map do |q|
    ans = r[q.upcase]
    puts "Subject #{r['Subject']}, #{q}"
    ans and [r['Subject'].to_i, q, run_grader(q, ans).last]
  end.compact
end

scores.map do |score|
  puts "\n\n#############################"
  puts "Subject: #{score[0]}"
  puts "Question: : #{score[1]}"
  puts "#############################\n\n"
  puts score[2].join("\n")
end

