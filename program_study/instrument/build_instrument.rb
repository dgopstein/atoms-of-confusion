#!/usr/bin/env ruby

require 'mustache'

if ARGV.length != 2
  puts "Usage: build_instrument.rb subject_id question_order"
  exit 1
end

subject_id, question_order = ARGV

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

`pdflatex --output-directory=out/ #{filename}`
