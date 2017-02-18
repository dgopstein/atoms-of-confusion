#!/usr/bin/env ruby

# Correct for differences in labeling between C/NC versions of the same question.
# e.g. question D has two labels, a&c that are equivalent to C's single label a

require 'active_support/core_ext/hash/indifferent_access'

def parse_filename(filename)
  filename.scan(/(\w)_([^.]+).txt/)[0]
end

def unify_output_file(filename)
  output = File.read(filename)

  q_type, file_desc = parse_filename(filename)

  unify_output_str(q_type, output)
end

def unify_output_str(type, output)
  label_map = {
    c: {c: 'e'},#a: 'a', b: 'b', c: 'e'},
    g: {c: 'b'}
  }.with_indifferent_access

  scrubbed = output.lines.map do |line|
    if ["X", "!"].include? line.chomp
      line
    else
      label, data = line.scan(/(\w)(.*)/).first

      new_label = label_map.fetch(type, {})[label] || label
      
      new_line = new_label + data
    end
  end.join("\n")

  scrubbed
end

def main
  filename = ARGV[0]
  puts unify_output_file(filename)
end

main if __FILE__==$0
