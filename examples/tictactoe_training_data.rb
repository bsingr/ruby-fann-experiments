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
final_permutations_and_winners = balanced_permutations.map do |p|
  situation = TTT::Situation.new(p)
  situation.valid_permutation_with_winner(3)
end.compact

# p final_permutations.size
# p final_permutations.last
# p winners.last

write_training_data 'tictactoe', final_permutations_and_winners
