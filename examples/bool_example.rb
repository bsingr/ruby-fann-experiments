#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), '..')
require 'example_env'

NAME = ARGV.first || 'or_binary'

and_data = training_data(NAME)
train = build_train_data(and_data)
neural_net = RubyFann::Standard.new(:num_inputs=>2,
                              :hidden_neurons=>[4,4],
                              :num_outputs=>1)
neural_net.train_on_data(train, 10000, 100, 0.01) # max epochs, errors between reports, desired mean-squared-error
results = []

resolution = 30
(0..resolution).each do |i|
  (0..resolution).each do |j|
    a = i.to_f / resolution
    b = j.to_f / resolution
    results.push [a, b, neural_net.run([a,b]).first]
  end
end
matrix = Matrix[results]

Plotter.terminate_all!
plotter = Plotter.new
plotter.plot matrix

neurotica = RubyFann::Neurotica.new
neurotica.graph(neural_net, "graphs/#{NAME}.png")
