#!/usr/bin/env ruby

require "sqlite3"
require "fileutils"

# Open a database
db = SQLite3::Database.new "../snippet_study/confusion.db"

snippet_dir = "snippet_files/"
FileUtils.mkdir_p(snippet_dir)

db.execute( "select ID, Code from code" ) do |row|
  filename = "snippet_%03d.c" % row[0]
  code = row[1]
  
  File.open(snippet_dir + filename, "w") do |f|
    f.write(code)
  end
end
