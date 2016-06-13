#!/usr/bin/env ruby

require 'csv' 
require 'open3'
require 'active_support/core_ext/hash/indifferent_access'

test_files = CSV.read('test_files.csv', headers: true)

prog_names = %w[ab cd] # ef gh]

bins = prog_names.map{|name| [name, "bin/#{name}"]}.to_h

prog_names.each do |prog|
  compilation = system("gcc #{prog}.c -o bin/#{prog}")
  if !compilation
    puts "program '#{prog}' compiled with non-zero exit code #{compilation}!"
    exit compilation
  end
end

label_map = {
  a: {},
  b: {},
  c: {},
  d: {c: 'a', d: 'b', e: 'c'}
}.with_indifferent_access

test_files.each do |csv_line|
  test_file, bin_name, n_correct, total_points = csv_line.values_at(*%w[file binary correct total])

  bin = bins[bin_name]

  stdin = File.read("test/#{test_file}")

  q_type, file_desc = test_file.scan(/(\w)_([^.]+).txt/)[0]

  # Make sure different version of the same program
  # Emit the same line-labels even after transformation
  scrubbed_stdin = stdin.lines.map do |line|
    label, data = line.scan(/(\w)(.*)/).first

    new_label = label_map.fetch(q_type, {})[label] || label
    
    new_line = new_label + data
  end.join("\n")

  # puts scrubbed_stdin

  stdout, stderr, status = Open3.capture3(bin, stdin_data: scrubbed_stdin)



  expected = "#{n_correct}/#{total_points}"
  actual = stdout.split("\n").last

  puts "#{bin_name}, #{q_type}, #{file_desc}, #{expected == actual}, #{expected}, #{actual}"
end
