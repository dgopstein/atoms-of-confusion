# map question names to letters
(1..4).to_a.product(['C', 'N']).map(&:join).zip('a'..'z').to_h.invert

# generate random IDs
(1000...9999).to_a.shuffle.take(100)

# generate question orders
100.times.map{('a'..'h').each_slice(2).map(&:join).zip([0, 0, 1, 1].shuffle).map{|a,i| a[i]}.shuffle.join}
# verify the distribution of questions: qs.map{|s| s.chars.sort.join}.sort.group_by(&:itself).map{|k, v| [k, v.length]}.to_h
