#!/usr/bin/env ruby

require './unify_output.rb'

require 'csv' 
require 'open3'

test_files = CSV.read('test_files.csv', headers: true)

prog_names = %w[ab cd ef gh]

bins = prog_names.map{|name| [name, "bin/#{name}"]}.to_h

prog_names.each do |prog|
  compilation = system("gcc #{prog}.c -o bin/#{prog}")
  if !compilation
    puts "program '#{prog}' compiled with non-zero exit code #{compilation}!"
    exit compilation
  end
end

test_files.each do |csv_line|
  test_file, bin_name, n_correct, total_points, comment = csv_line.values_at(*%w[file binary correct total comment])

  bin = bins[bin_name]

  # Make sure different version of the same program
  # Emit the same line-labels even after transformation
   
  scrubbed_stdin = unify_output_file("test/#{test_file}")
  q_type, file_desc = parse_filename(test_file)

  # puts scrubbed_stdin

  stdout, stderr, status = Open3.capture3(bin, stdin_data: scrubbed_stdin)

  expected = "#{n_correct}/#{total_points}"
  actual = stdout.encode('UTF-8', 'UTF-8', :invalid => :replace)
                 .split(/\n/).last

  puts "#{bin_name}, #{q_type}, #{file_desc}, #{expected == actual ? ' ' : 'F'}, #{expected}, #{actual}, #{comment}"
end
