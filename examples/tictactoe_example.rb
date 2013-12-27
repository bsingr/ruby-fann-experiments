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
