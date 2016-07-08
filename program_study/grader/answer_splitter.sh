#!/bin/sh

# Take a pdf of a subjects answers of the form Consent-Answers-Survey and split it into 3 separate files

input_file=$1
subject_id=$2

pdftk $input_file cat 1-1     output "SUBJECT_NAME-consent.pdf"
pdftk $input_file cat 2-r2    output "${subject_id}-answers.pdf"
pdftk $input_file cat end-end output "${subject_id}-survey.pdf"
