#!/usr/bin/env ruby
require 'deep_enumerable'

compare_file = 'Compare.html' # http://www.ckxrchen.com/Atom/result/compare.php
results_file = 'Results.html' # http://www.ckxrchen.com/Atom/result/admin.php

compare_str = File.read(compare_file)
results_str = File.read(results_file)

# Read from Compare file which question ids are confusing/non-confusing
qid_regex = '(?:\s*<td><a[^>]*>(\d+)</a></td>)?'
qids = compare_str.scan(%r|<tr>#{qid_regex*2}|m).drop(1)
con_ids, noncon_ids = con_noncon_ids = qids.transpose.map(&:compact).deep_map_values(&:to_i)

# Read from Results file the T/F values for each question
res_regex = %r|<tr>\s*<td>(\d+)</td>(?:\s*<td>[^<]*</td>){2}\s*<td>([TF])|m
id_val_pairs = results_str.scan(res_regex)
id_vals = Hash[id_val_pairs.group_by(&:first).map{|k, v| [k.to_i, v.map(&:last).map{|v| v == 'T'}]}]
#p id_vals

# Build contingency table
class Array; def sum; self.inject(:+); end; end
contingency_table = con_noncon_ids.map do |group|
  n_null, n_alt, n_total = group.map do |id|
    vals = id_vals[id]
    n_t = vals.size # all questions
    n_n = vals.count(&:itself) # questions the participants got right
    n_a = n_t - n_n # questions the participants got wrong
    [n_n, n_a, n_t]
  end.transpose.map(&:sum)
  [Rational(n_null, n_total), Rational(n_alt, n_total)]
end.deep_map_values(&:numerator)

puts "contingency table: #{contingency_table.inspect}"

# https://en.wikipedia.org/wiki/Pearson%27s_chi-squared_test#Test_of_independence

def n(table) # total samples
  table.flatten.sum
end

def e(table, i, j) # theoretical frequency
  nf = n(table).to_f
  pi = table[i].sum / nf
  pj = table.map{|row| row[j]}.sum / nf

  nf * pi * pj
end

def chi2(table)
  table.each_with_index.map do |row, i|
    row.each_with_index.map do |o, j|
      e = e(table, i, j)
      ((o - e)**2)/e
    end.sum
  end.sum
end

def effect_size(table)
  chi2(table)/n(table)**0.5
end

x2 = chi2(contingency_table)
es = effect_size(contingency_table)

puts "chi square: #{x2}"
puts "effect size: #{es}"
