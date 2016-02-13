#!/usr/bin/env ruby

filepat = 'users/User%d.xml'

puts "ALTER TABLE usercode ADD COLUMN rank int;"

(1..11).each do |user_id|
  File.open(filepat % user_id).each_line do |line|
    rank, code_id = line.scan(/<q(\d+)>(\d+)/).first
    if rank
      sql = 'UPDATE usercode SET rank = %d WHERE userid = %d and codeid = %d;' % [rank, user_id, code_id]
      puts sql
    end
  end
end
