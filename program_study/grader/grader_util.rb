require 'active_support/core_ext/hash/indifferent_access'
require './unify_output.rb'
require 'pp'

$prog_names = %w[ab cd ef gh]

$bins = $prog_names.map{|name| [name, "bin/#{name}"]}.to_h

$pilot_ids = [3782, 1161, 1224, 3270, 9351, 6490, 4747, 6224, 3881, 6033]

def read_results(results_file)
  CSV.read(results_file, headers: true).reject{|r| $pilot_ids.include?(r['Subject'].to_i)}
end

def compile_graders!
  $prog_names.each do |prog|
    compilation = system("gcc #{prog}.c -o bin/#{prog}")
    if !compilation
      puts "program '#{prog}' compiled with non-zero exit code #{compilation}!"
      exit compilation
    end
  end
end

$type_to_bin = {
  a: 'ab',
  b: 'ab',
  c: 'cd',
  d: 'cd',
  e: 'ef',
  f: 'ef',
  g: 'gh',
  h: 'gh'
}.with_indifferent_access

def run_grader(type, stdout)
  scrubbed_stdin = unify_output_str(type, stdout)
  bin = $bins[$type_to_bin[type]] or return

  stdout, stderr, status = Open3.capture3(bin, stdin_data: scrubbed_stdin)
  scrubbed_stdout = stdout.encode('UTF-8', 'UTF-8', :invalid => :replace)
                          .split(/\n/)

  faults = scrubbed_stdout.flat_map{|line| line.scan(/FAULT: (.*)/)[0]&.map{|s|s.split(",")}}.compact
  checks = scrubbed_stdout.flat_map{|line| line.scan(/CHECK: (.*)/)[0]&.map{|s|s.split(",")}}.compact

  if scrubbed_stdout.empty?
    puts "Error executing #{bin} on \n#{scrubbed_stdin}"
    return nil
  end

  actual = scrubbed_stdout.last.split("/").map(&:to_i)

  [actual, faults, checks, scrubbed_stdout]
end
