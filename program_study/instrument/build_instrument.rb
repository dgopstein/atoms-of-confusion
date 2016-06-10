#!/usr/bin/env ruby

# Run as: build_instrument.rb subject_file.tsv
# or as:  build_instrument.rb subject_id question_order

require 'mustache'

def write_pdf(subject_id, question_order)
  questions = question_order.split('')
  
  intro_tex = Mustache.render(File.read("instrument-intro.mustache"), subject_id: subject_id)
  
  questions_tex = questions.map do |q_letter|
    question_file = q_letter.downcase + '.c'
    question_name = q_letter.upcase
  
    Mustache.render(File.read("instrument-question.mustache"),
      question_file: question_file,
      question_name: question_name)
  end
  
  survey_tex = File.read("instrument-survey.mustache")
  
  tex = [intro_tex, questions_tex, survey_tex].flatten.join
  
  filename = "out/instrument-#{subject_id}.tex"
  
  File.write(filename, tex)
  
  `mkdir -p out`
  `pdflatex --output-directory=out/ #{filename}`
end

if ARGV.length == 1
  infile = ARGV.first
  subjects = File.read(infile).lines
  subjects.each do |line|
    subject_id, question_order = line.chomp.split(/\t/)
    STDERR.puts([subject_id, question_order].inspect)
    write_pdf(subject_id, question_order)
  end
elsif ARGV.length == 2
  subject_id, question_order = ARGV
  write_pdf(subject_id, question_order)
else
  puts "Usage: build_instrument.rb subject_file.tsv"
  puts "Usage: build_instrument.rb subject_id question_order"
  exit 1
end
