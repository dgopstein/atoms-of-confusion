#!/usr/bin/env ruby
require 'deep_enumerable'

compare_file = 'Compare.html' # http://www.ckxrchen.com/Atom/result/compare.php
results_file = 'Results.html' # http://www.ckxrchen.com/Atom/result/admin.php

compare_str = File.read(compare_file)
results_str = File.read(results_file)

# Read from Compare file which question ids are confusing/non-confusing
qid_regex = '(?:\s*<td><a[^>]*>(\d+)</a></td>)?'
qids = compare_str.scan(%r|<tr>#{qid_regex*2}|m).drop(1)

# tuple of each confusing/non-confusing pair [[1, 2], [3, 4], ... [15, nil], ... [57, 58]]
compair_pairs = qids.deep_map_values{|i| i && i.to_i}

con_ids, noncon_ids = con_noncon_ids = qids.transpose.map(&:compact).deep_map_values(&:to_i)

# Capture UserID, Question ID, and T/F value from Results.html file
res_regex = %r|(?:User ID: (.*?)<.*?)?<tr>\s*<td>(\d+)</td>(?:\s*<td>[^<]*</td>){2}\s*<td>([TF])|m
partial_uid_qid_val = results_str.scan(res_regex)

# Only the first question has an associated UserID, propogate it to all the others
uid_qid_val = partial_uid_qid_val.inject(["", []]) do |(uid, list), elem|
  [new_uid = elem[0] || uid, list + [[new_uid, elem[1].to_i, elem[2] == 'T']]]
end.last

# Hash of [UserID, QuestionId] -> T/F
uid_qid_val_h = uid_qid_val.map{|u, q, v| [[u, q], v]}.to_h

uids = uid_qid_val.map(&:first).uniq

# Question ID -> # of Correct Answers
qid_val_pairs = uid_qid_val.map{|tup| tup.drop(1)}
qid_vals = Hash[qid_val_pairs.group_by(&:first).map{|k, v| [k, v.map(&:last)]}]
#p qid_vals

class Array; def sum; self.inject(:+); end; end
class FalseClass; def to_i; 0; end; end
class TrueClass; def to_i; 1; end; end

# Build mcnemars contingency table
mcnemars_contingency = [[0, 0], [0, 0]]
compair_pairs.each do |c_id, nc_id|
  uids.each do |uid|
    c_val  = uid_qid_val_h[[uid,  c_id]]
    nc_val = uid_qid_val_h[[uid, nc_id]]

    if !c_val.nil? && !nc_val.nil?
      mcnemars_contingency[1-nc_val.to_i][1-c_val.to_i] += 1
    end
  end
end

# mcnemars test statistic: X^2 = (b - c)^2 / (b + c) # Wikipedia
mts = ->do
  b = mcnemars_contingency[0][1]
  c = mcnemars_contingency[1][0]

  (b - c)**2/(b + c).to_f
end[]

# mcnemars sample size: http://powerandsamplesize.com/Calculators/Compare-Paired-Proportions/McNemar-Z-test-2-Sided-Equality
mss = ->do
  require 'rsruby'

  a = mcnemars_contingency[0][0] 
  b = mcnemars_contingency[0][1] 
  c = mcnemars_contingency[1][0]
  d = mcnemars_contingency[1][1]

  p10 = b.to_f / (a + b) # the indexes look wrong, but they're not, check the link above
  p01 = c.to_f / (c + d) # the indexes look wrong, but they're not, check the link above

  #p10 = 0.3
  #p01 = 0.2

  pdisc = (p10 + p01).to_f
  pdiff = (p10 - p01).to_f
  
  p [p10, p01, pdisc, pdiff]

  r = RSRuby.instance
  # n=((qnorm(1-alpha/2)*sqrt(pdisc)+qnorm(1-beta)*sqrt(pdisc-pdiff^2))/pdiff)^2
  alpha = 0.05
  beta = 0.20
  p pdisc
  p pdisc-pdiff**2
  n = ((r.qnorm(1-alpha/2)*Math.sqrt(pdisc)+r.qnorm(1-beta)*Math.sqrt(pdisc-pdiff**2))/pdiff)**2
  n.ceil
end[]

puts "mcnemars contingency table: #{mcnemars_contingency.inspect}"
puts "mcnemars test statistic: #{mts}"
puts "mcnemars sample size: #{mss}" # TODO this value seems unreasonable

# Build chi2 contingency table
chi2_contingency = con_noncon_ids.map do |group|
  n_null, n_alt, n_total = group.map do |id|
    vals = qid_vals[id]
    n_t = vals.size # all questions
    n_n = vals.count(&:itself) # questions the participants got right
    n_a = n_t - n_n # questions the participants got wrong
    [n_n, n_a, n_t]
  end.transpose.map(&:sum)
  [Rational(n_null, n_total), Rational(n_alt, n_total)]
end.deep_map_values(&:numerator)

puts "chi 2 contingency table: #{chi2_contingency.inspect}"

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

x2 = chi2(chi2_contingency)
es = effect_size(chi2_contingency)

puts "chi square: #{x2}"
puts "effect size: #{es}"
