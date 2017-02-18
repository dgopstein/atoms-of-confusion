#!/usr/bin/env rvm 2.3.1 do ruby

# Grade every output ignoring IGUs altogether

require './grader_util.rb'

require 'csv' 
require 'open3'
require 'pp'

# results_file = "csv/results.csv"
results_file = ARGV[0]

if results_file.nil?
  puts "Usage: grade_ignore_IGU.rb results_file.csv"
  exit(1)
end

results = read_results(results_file)

compile_graders!

def regrade(faults, checks)
  valid_checks = checks
                    .select{|a| a[0] != "halt" } # ignore halt checks
                    .chunk(&:first).flat_map{|chunk| chunk.first == 'label' ? chunk.first : chunk } +# remove consecutive label faults
                 faults.select{|a| a[0] == "halt" && a.size > 1 } # faulted halts are checks
                 


  strikes = faults
           .select{|a| a[0] != "halt" || a.size > 1 } # ignore blank halt faults

  denom = valid_checks.size
  numer = denom - strikes.size

  [numer, denom]
end

pp run_grader_h('a', results.first['A'])[:faults_checks]


scores = results.flat_map do |r|
  ('a'..'h').map do |q|
    ans = r[q.upcase] or next
    grade = run_grader(q, ans)
    real_score = grade.first
    test_score = regrade(grade[1], grade[2])
    [r['Subject'].to_i, q, real_score, test_score]
  end.compact
end

#pp scores
