#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), '..')
require 'example_env'

NAME = ARGV.first || 'tictactoe'

data = training_data(NAME)
train = build_train_data(data)
neural_net = RubyFann::Standard.new(:num_inputs=>9,
                              :hidden_neurons=>[3,3],
                              :num_outputs=>1)
neural_net.train_on_data(train, 300000, 1000, 0.1) # max epochs, errors between reports, desired mean-squared-error

examples = []
examples << [0,0,-1, 0,-1,0, 1,0,0]   # 0
examples << [0,0,-1, 0,-1,-1, 1,1,1]  # 1
examples << [0,0,-1, 0,-1,0, 1,1,1]   # 1
examples << [0,0,-1, 0,-1,-1, 1,0,1]  # 0
examples << [0,0,-1, 0,-1,-1, 1,1,1]  # 1
examples << [0,0,1, -1,-1,-1, 0,1,1]  # -1
examples << [0,1,1, -1,-1,-1, -1,1,1] # -1
examples << [0,1,-1, 1,0,-1, 0,0,-1]  # -1
examples.each do |e|
  raise "Invalid sum of #{e.inspect}" if e.inject(:+) > 1 || e.inject(:+) < -1 
  s = TTT::Situation.new(e)
  printf "%02f  -  %02f\n", s.winner, neural_net.run(e).first
end

neurotica = RubyFann::Neurotica.new
neurotica.graph(neural_net, "tictactoe.png")