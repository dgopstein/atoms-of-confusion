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

all_faults_unnormed = results.flat_map do |r|
  ('a'..'h').flat_map do |q|
    ans = r[q.upcase]
    if ans
      _, faults, _ = run_grader(q, ans)
      faults.map {|f| [q, *f] }
    end
  end.compact
end

all_checks_unnormed = results.flat_map do |r|
  ('a'..'h').flat_map do |q|
    ans = r[q.upcase]
    if ans
      _, _, checks = run_grader(q, ans)
      checks.map {|c| [q, *c] }
    end
  end.compact
end


def label_norm_fault(flt)
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
  new_label = label_map[flt.values_at(0,2)]
  if new_label
    [*flt.take(2), new_label, *flt.drop(3)]
  else
    flt
  end
end

all_faults = all_faults_unnormed.map { |flt| label_norm_fault(flt) }
all_checks = all_checks_unnormed.map { |flt| label_norm_fault(flt) }

fault_counts = all_faults.group_by(&:itself).map{|k,v| [k, v.size]}.sort.to_h
fault_counts

check_counts = all_checks.group_by(&:itself).map{|k,v| [k, v.size]}.sort.to_h
check_counts

type_pairs = ('a'..'g').step(2).flat_map{|x| [[x, x.succ], [x.succ, x]]}.to_h
def nc?(qt); ('b'..'h').step(2).include?(qt); end

def f2c(fault)
  case fault[1]
  when "label"; fault.take(3)
  when "halt"; fault.take(2)
  when "param"; fault
  end
end

fault_pairs = fault_counts.map do |fault, count|
  pair = [type_pairs[fault[0]], *fault.drop(1)]
  pair_count = fault_counts[pair]
  check_count = check_counts[f2c(fault)]
  cp_count = check_counts[f2c(pair)]

  qtype, *fault_rest = fault

  # Decide which half of the pair is C/NC and format the output accordingly
  newtype, c_count, nc_count, c_checks, nc_checks = 
    if nc?(qtype)
      [type_pairs[qtype], pair_count||0, count, cp_count||0, check_count||0]
    else
      [qtype, count, pair_count||0, check_count||0, cp_count||0]
    end

  [newtype, *fault_rest, c_count, nc_count, c_checks, nc_checks]
end.uniq

puts "question,fault, ..., c_count,nc_count"
puts fault_pairs.sort_by{|*_, ccnt, ncnct, _, _| (ccnt - ncnct).abs}.map(&:to_csv).join

