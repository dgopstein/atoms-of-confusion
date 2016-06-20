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

unnormed_scores = results.flat_map do |r|
  ('a'..'h').flat_map do |q|
    ans = r[q.upcase]
    if ans
      _, faults, checks = run_grader(q, ans)
      faults.map {|f| [r['Subject'].to_i, q, "fault", *f] } +
      checks.map {|c| [r['Subject'].to_i, q, "check", *c] }
    end
  end.compact
end

label_map = {
  ['c', 'a'] => 'a',
  ['c', 'b'] => 'a',
  ['c', 'c'] => 'a',
  ['c', 'd'] => 'b',
  ['c', 'e'] => 'c',
  ['d', 'a'] => 'a',
  ['d', 'b'] => 'a',
  ['d', 'c'] => 'a',
  ['d', 'd'] => 'b',
  ['d', 'e'] => 'c',
  ['g', '1'] => 'b',
  ['g', '2'] => 'b',
  ['g', '3'] => 'b',
  ['g', '4'] => 'b',
  ['h', '1'] => 'b',
  ['h', '2'] => 'b',
  ['h', '3'] => 'b',
  ['h', '4'] => 'b',
}

scores = unnormed_scores.map do |arr|
  (subject, q_type, fault_or_check, fault, lbl1, lbl2, input) = arr
  if fault == 'labels'
    new_label = label_map[[q_type, lbl1]]
    raise "No mapping for LABELS #{[q_type, lbl2]}" unless new_label
    [subject, q_type, fault_or_check, 'label', new_label, input]
  elsif fault == 'halt_label'
    #new_label = label_map[[q_type, lbl1]]
    [subject, q_type, fault_or_check, fault, nil, nil]
  else
    arr
  end
end

counts = scores.map{|a|a.drop(1)}.group_by(&:itself).map{|k,v| [k, v.size]}.to_h
fault_counts = counts.select{|k,v| k[1] == "fault"}
faults = fault_counts.keys

check_counts = counts.select{|k,v| k[1] == "check"}
checks = check_counts.keys

type_pairs = ('a'..'g').step(2).flat_map{|x| [[x, x.succ], [x.succ, x]]}.to_h
def nc?(qt); ('b'..'h').step(2).include?(qt); end

fault_pairs = fault_counts.map do |fault, count|
  # Find matching C/NC question counts
  pair = fault_counts.select do |flt, cnt| 
    flt[0] == type_pairs[fault[0]] && flt.drop(1) == fault.drop(1)
  end.first

  # Find matching check count for the question
  check_count = check_counts.select do |flt, cnt| 
    flt[0] == fault[0] && flt.drop(2) == fault.drop(2).take(2)
  end.first

  # Find matching check count for the C/NC pair of the question
  check_pair = check_counts.select do |flt, cnt| 
    p [fault[2..-1], flt.drop(2)]
    flt[0] == type_pairs[fault[0]] && flt.drop(2) == fault.drop(2).take(2)
  end.first


  p check_pair

  qtype, *fault_rest = fault

  # Decide which half of the pair is C/NC and format the output accordingly
  newtype, c_count, nc_count, c_checks, nc_checks = 
    if nc?(qtype)
      [type_pairs[qtype], pair&.last||0, count, check_pair&.last||0, check_count&.last||0]
    else
      [qtype, count, pair&.last||0, check_count&.last||0, check_pair&.last||0]
    end

  [newtype, *fault_rest, c_count, nc_count, c_checks, nc_checks]
end

puts "question,fault, ..., c_count,nc_count"
puts fault_pairs.sort_by{|*_, ccnt, ncnct, _, _| (ccnt - ncnct).abs}.map(&:to_csv).join

