#!/usr/bin/env ruby

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
    d: {}#c: 'a', d: 'b', e: 'c'},
  }.with_indifferent_access

  scrubbed = output.lines.map do |line|
    label, data = line.scan(/(\w)(.*)/).first

    new_label = label_map.fetch(type, {})[label] || label
    
    new_line = new_label + data
  end.join("\n")

  scrubbed
end

def main
  filename = ARGV[0]
  puts unify_output_file(filename)
end

main if __FILE__==$0
