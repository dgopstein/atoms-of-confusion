#!/usr/bin/env ruby

require './unify_output.rb'
require './grader_util.rb'

require 'csv' 
require 'open3'

test_files = CSV.read('test_files.csv', headers: true)

compile_graders!

test_files.each do |csv_line|
  test_file, bin_name, n_correct, total_points, comment = csv_line.values_at(*%w[file binary correct total comment])

  # Make sure different version of the same program
  # Emit the same line-labels even after transformation
   
  stdout = File.read("test/"+test_file)
  q_type, file_desc = parse_filename(test_file)

  actual = run_grader(q_type, stdout).join("/")

  expected = "#{n_correct}/#{total_points}"

  puts "#{bin_name}, #{q_type}, #{file_desc}, #{expected == actual ? ' ' : 'F'}, #{expected}, #{actual}, #{comment}"
end
