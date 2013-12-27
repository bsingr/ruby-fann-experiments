#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), '..')
require 'example_env'

NAME = ARGV.first || 'tictactoe'

data = training_data(NAME)
p data[:inputs].last
p data[:outputs].last
train = build_train_data(data)
fann = RubyFann::Standard.new(:num_inputs=>9,
                              :hidden_neurons=>[12,6,6,6,6,6,6],
                              :num_outputs=>1)
fann.train_on_data(train, 300, 100, 0.1) # max epochs, errors between reports, desired mean-squared-error

p fann.run([0,0,-1, 0,-1,-1, 1,1,1]) # 1
p fann.run([0,0,-1, 0,-1,0, 1,1,1]) # 1
p fann.run([0,0,-1, 0,-1,-1, 1,0,1]) # 0
p fann.run([0,0,-1, 0,-1,-1, 1,1,1]) # 1
p fann.run([0,0,1, -1,-1,-1, 0,1,1]) # -1
p fann.run([0,1,1, -1,-1,-1, -1,1,1]) # -1
