#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), '..')
require 'example_env'

NAME = ARGV.first || 'tictactoe'

and_data = training_data(NAME)
train = build_train_data(and_data)
fann = RubyFann::Standard.new(:num_inputs=>9,
                              :hidden_neurons=>[3,3,3],
                              :num_outputs=>1)
fann.train_on_data(train, 1000, 100, 0.01) # max epochs, errors between reports, desired mean-squared-error
results = []


p fann.run([0,0,-1, 0,-1,-1, 1,1,1].map &:to_f)
p fann.run([0,0,-1, 0,-1,0, 1,1,1].map &:to_f)
p fann.run([0,0,-1, 0,-1,-1, 1,0,1].map &:to_f)
p fann.run([0,0,-1, 0,-1,-1, 1,1,1].map &:to_f)
p fann.run([0,0,1, -1,-1,-1, 0,1,1].map &:to_f)
