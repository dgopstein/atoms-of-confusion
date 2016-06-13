#!/usr/bin/env ruby

require 'csv' 
require 'open3'

test_files = CSV.read('test_files.csv', headers: true)

prog_names = %w[ab] # cd ef gh]

bins = prog_names.map{|name| [name, "bin/#{name}"]}.to_h

prog_names.each do |prog|
  compilation = system("gcc #{prog}.c -o bin/#{prog}")
  if !compilation
    puts "program '#{prog}' compiled with non-zero exit code #{compilation}!"
    exit compilation
  end
end

test_files.each do |csv_line|
  test_file, bin_name, n_correct, total_points = csv_line.values_at(*%w[file binary correct total])

  bin = bins[bin_name]

  #expected_output = File.read("test/"+test_file)

  cmd = "#{bin} < test/#{test_file}"
  
  #puts "running command: #{cmd.inspect}"
  
  stdout, stderr, status = Open3.capture3(cmd)


  q_type, file_desc = test_file.scan(/(\w)_([^.]+).txt/)[0]

  expected = "#{n_correct}/#{total_points}"
  actual = stdout.split("\n").last

  puts "#{bin_name}, #{q_type}, #{file_desc}, #{expected == actual}, #{expected}, #{actual}"
end
