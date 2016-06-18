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
      faults = run_grader(q, ans).last
      faults.map {|f| [r['Subject'].to_i, q, *f] }
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
  (subject, q_type, fault, lbl1, lbl2, input) = arr
  if fault == 'labels'
    new_label = label_map[[q_type, lbl1]]
    raise "No mapping for LABELS #{[q_type, lbl2]}" unless new_label
    [subject, q_type, 'label', new_label, input]
  elsif fault == 'halt_label'
    #new_label = label_map[[q_type, lbl1]]
    [subject, q_type, fault, nil, nil]
  else
    arr
  end
end

fault_counts = scores.map{|a|a.drop(1)}.group_by(&:itself).map{|k,v| [k, v.size]}.to_h
faults = fault_counts.keys

#pp fault_counts.map(&:reverse).sort

type_pairs = ('a'..'g').step(2).flat_map{|x| [[x, x.succ], [x.succ, x]]}.to_h
def nc?(qt); ('b'..'h').step(2).include?(qt); end

fault_pairs = fault_counts.map do |fault, count|
  pair = fault_counts.select do |flt, cnt| 
    flt[0] == type_pairs[fault[0]] && flt.drop(1) == fault.drop(1)
  end.first
  qtype, *fault_rest = fault

  newtype, c_count, nc_count = 
    if nc?(qtype)
      [type_pairs[qtype], pair&.last||0, count]
    else
      [qtype, count, pair&.last||0]
    end

  [newtype, *fault_rest, c_count, nc_count]
end

puts "question,fault, ..., c_count,nc_count"
puts fault_pairs.sort_by{|*_, ccnt, ncnct| (ccnt - ncnct).abs}.map(&:to_csv).join



#fault_pairs = fault_types.map do |fault|
#              # .select{|fc| nc?(fc[0])}
#                
#  q_type, fault_type, arg1, arg2, arg3 = fault
#
#  pair_type = type_pairs[q_type]
#  pair_matcher = case fault_type
#    when "param"
#      lambda do |a| 
#        qt, ft, lbl, arg = a
#        ft == "param" &&
#        qt == type_pairs[q_type] && param_pairs[[q_type, arg1]].include?(lbl) &&
#        arg == arg2
#      end
#    when "label"
#      lambda do |a|
#        qt, ft, lbl, act = a
#        qt == type_pairs[q_type] && (
#          ft == "label" && param_pairs[[q_type, arg1]].include?(lbl)# && act == arg2
#          #or
#          #ft == "labels" && lbl == param_pairs[[q_type, arg1]] &&
#          #act == arg2
#        )
#      end
#    when "labels"
#      ->(x){false}
#    when "halt_label"
#      ->(x){false}
#  end
#
#  [fault, fault_types.select{|ft| pair_matcher.call(ft)}]
#end
#
#pp fault_types.sort
#puts
#puts
#pp fault_pairs.sort.map{|a|  [a[0].join(","), a.drop(1).flat_map{|a2| a2.map{|a3| a3.join(",")}}]}
