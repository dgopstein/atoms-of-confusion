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

compile_graders!

scores = ('a'..'h').each_with_object(Hash.new{[]}) do |q, hash|
  score = results[q.upcase].compact.map { |s| run_grader(q, s) }
  hash[q] += score
end

score_avgs = scores.map do |type, scores|  
  num, denom = scores.transpose.map{|x| x.inject(:+)}

  [type, (num.to_f / denom).round(2)]
end.to_h

pp score_avgs


