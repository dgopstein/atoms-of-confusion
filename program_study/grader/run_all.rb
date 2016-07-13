#!/usr/bin/env ruby

# Run the grader scripts on every user answers just to see if they run without error, it also outputs all the grader scripts' output

require './grader_util.rb'

require 'csv' 
require 'open3'
require 'pp'

results_file = ARGV[0]

if results_file.nil?
  puts "Usage: run_all.rb results_file.csv"
  exit(1)
end

results = read_results(results_file)

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

