#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), '..')
require 'example_env'

# inputs
# x0 x1 x2
# x3 x4 x5
# x6 x7 x8

# input permutations
# 000000000 # 0 = 3**0*0 + 3**1*0 + ...
# 000000001 # 1 = 3**0*1 + 
# 000000002 # 2 = 3**0*2
# 000000010 # 3
# 000000011 # 4
# 000000012 # 5
# 000000020 # 6
# 000000021 # 7
# 000000022 # 8
# 000000100 # 9
# ...
# 222222222 # 3**9

# value normalization
# 0 => -1
# 1 => 0
# 2 => 1

# output
# h0

permutations = []
(3**9).times do |idx|
  permutation = []
  permutation.push (idx / (3**8)) % (3**8) % (3**7) % (3**6) % (3**5) % (3**4) % (3**3) % (3**2) % (3**1)
  permutation.push (idx / (3**7)) % (3**7) % (3**6) % (3**5) % (3**4) % (3**3) % (3**2) % (3**1)
  permutation.push (idx / (3**6)) % (3**6) % (3**5) % (3**4) % (3**3) % (3**2) % (3**1)
  permutation.push (idx / (3**5)) % (3**5) % (3**4) % (3**3) % (3**2) % (3**1)
  permutation.push (idx / (3**4)) % (3**4) % (3**3) % (3**2) % (3**1)
  permutation.push (idx / (3**3)) % (3**3) % (3**2) % (3**1)
  permutation.push (idx / (3**2)) % (3**2) % (3**1)
  permutation.push (idx / (3**1)) % (3**1)
  permutation.push (idx / (3**0)) % (3**1)
  permutations << permutation
end

#puts permutations[0..33].map{|s| s.join(' ')}.join("\n")

normalized_permutations = permutations.map do |p|
  p.map do |value|
    value - 1
  end
end

# p normalized_permutations[1]

# only keep permutations were each player made equal number of moves
balanced_permutations = normalized_permutations.find_all do |p|
  sum = p.inject &:+
  sum >= -1 && sum <= 1
end

# p filtered_permutation[1]

# calculate winner
# and only keep permutations with one clear winner (not more than one)
priced_permutations = balanced_permutations.map do |p|
  strikes = [p[0]+p[1]+p[2], # row 1
             p[3]+p[4]+p[5], # row 2
             p[6]+p[7]+p[8], # row 3
             p[0]+p[3]+p[6], # col 1
             p[1]+p[4]+p[7], # col 2
             p[2]+p[5]+p[8], # col 3
             p[0]+p[4]+p[8], # diag 1
             p[2]+p[4]+p[6]] # diag 2
  minus_winning_strikes = strikes.find_all{|s| s == -3}
  plus_winning_strikes = strikes.find_all{|s| s == 3}
  if (minus_winning_strikes.size + plus_winning_strikes.size) <= 1
    winner = if minus_winning_strikes.size == 1
      -1
    elsif plus_winning_strikes.size == 1
      1
    else
      0
    end
    [p, winner]
  else 
    # noop, too much winners
  end
end.compact

