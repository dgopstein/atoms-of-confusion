#!/usr/bin/env rvm 2.3.1 do ruby

# Print the answer of a specific subject/answer

$cwd = File.expand_path File.dirname(__FILE__)

require "#$cwd/grader_util.rb"

require 'csv' 
# (results_file, s_id, q_id = ['csv/results.csv', 9998, 'h'])
results_file, s_id, q_id = ARGV

if [results_file, s_id, q_id].any?(&:nil?)
  puts "Usage: cat_result.rb results_file.csv 9998 h "
  exit(1)
end

results = read_results(results_file)

subject = results.find{|row| row['Subject'] == s_id.to_s }

puts subject[q_id.upcase]
