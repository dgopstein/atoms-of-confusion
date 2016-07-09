#!/usr/bin/env rvm 2.3.1 do ruby

# Read a CSV of raw user data and output a CSV of the score on every question for each user

require './grader_util.rb'

require 'csv' 
require 'open3'
require 'pp'
require 'time'

results_file = ARGV[0]

if results_file.nil?
  puts "Usage: grade_csv.rb results_file.csv"
  exit(1)
end

results = CSV.read(results_file, headers: true)

#pilot_ids = [3782, 1161, 1224, 3270, 9351, 6490, 4747, 6224, 3881, 6033]
#pilot_ids = [3782, 1224, 3270, 9351, 6490, 4747, 6224, 3881, 6033]
#
#pilot_results = results.select{|r| pilot_ids.include?(r["Subject"].to_i)}.map{|r| r["Subject"].to_i}

compile_graders!

def calc_duration(order, times)
  # pair question letters with the start/end times
  # account for questions answered out of order
  letter_times = order.split('').zip(times.each_slice(2)).sort_by(&:last)

  letter_duration = letter_times.map do |k, (start_t, end_t)|
    [k, (Time.parse(end_t).to_i - Time.parse(start_t).to_i)/60]
  end
end

scores = results.flat_map do |r|
  times = calc_duration(r["Order"], r[r.index("start1")..r.index("end4")])
  ('a'..'h').map do |q|
    ans = r[q.upcase] or next
    qpos = times.index{|letter, times| letter == q}
    mins = times[qpos].last
    [r['Subject'].to_i, q, qpos, mins, run_grader(q, ans).first]
  end.compact
end

puts "subject,qtype,qpos,mins,correct,points"
puts scores.map{|r| r.flatten.to_csv }
