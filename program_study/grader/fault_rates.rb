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

fault_counts = scores.map{|a|a.drop(1)}.group_by(&:itself).map{|k,v| [k, v.size]}.to_h

#puts fault_counts.map{|count| count.reverse.flatten.to_csv}.sort.join("")

#pp fault_counts
param_pairs = Hash.new{|hash, k| [k.last]}.merge({
  ['c', 'a'] => ['a', 'c'],
  ['c', 'b'] => ['b', 'd'],
  ['c', 'c'] => ['e'],
  ['d', 'c'] => ['a'],
  ['d', 'd'] => ['b'],
  ['d', 'e'] => ['c'],
  ['g', 'b'] => ['1', '2', '3', '4'],
  ['h', '1'] => ['b'],
  ['h', '2'] => ['b'],
  ['h', '3'] => ['b'],
  ['h', '4'] => ['b'],
})

type_pairs = ('a'..'g').step(2).flat_map{|x| [[x, x.succ], [x.succ, x]]}.to_h

def nc?(qt); ('b'..'h').step(2).include?(qt); end

fault_types = fault_counts.map(&:first)

fault_pairs = fault_types.map do |fault|
              # .select{|fc| nc?(fc[0])}
                
  q_type, fault_type, arg1, arg2, arg3 = fault

  pair_type = type_pairs[q_type]
  pair_matcher = case fault_type
    when "param"
      lambda do |a| 
        qt, ft, lbl, arg = a
        ft == "param" &&
        qt == type_pairs[q_type] && param_pairs[[q_type, arg1]].include?(lbl) &&
        arg == arg2
      end
    when "label"
      lambda do |a|
        qt, ft, lbl, act = a
        qt == type_pairs[q_type] && (
          ft == "label" && param_pairs[[q_type, arg1]].include?(lbl)# && act == arg2
          #or
          #ft == "labels" && lbl == param_pairs[[q_type, arg1]] &&
          #act == arg2
        )
      end
    when "labels"
      ->(x){false}
    when "halt_label"
      ->(x){false}
  end

  [fault, fault_types.select{|ft| pair_matcher.call(ft)}]
end

pp fault_types.sort
puts
puts
pp fault_pairs.sort.map{|a|  [a[0].join(","), a.drop(1).flat_map{|a2| a2.map{|a3| a3.join(",")}}]}
