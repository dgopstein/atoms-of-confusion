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

scores = results.flat_map do |r|
  ('a'..'h').flat_map do |q|
    ans = r[q.upcase]
    if ans
      faults = run_grader(q, ans).last
      faults.map {|f| [r['Subject'].to_i, q, *f] }
    end
  end.compact
end

#puts "subject,qtype,fault,arg1,arg2,arg3"
#puts scores.map{|r| r.to_csv }

#p scores

fault_counts = scores.map{|a|a.drop(1)}.group_by(&:itself).map{|k,v| [v.size, k]}

puts fault_counts.map{|count| count.flatten.to_csv}.sort.join("")
