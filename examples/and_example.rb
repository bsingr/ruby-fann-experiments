#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), '..')
require 'example_env'

and_data = training_data 'and_binary'
train = build_train_data(and_data)
fann = RubyFann::Standard.new(:num_inputs=>2,
                              :hidden_neurons=>[1],
                              :num_outputs=>1)
fann.train_on_data(train, 100, 100, 0.0001) # max epochs, errors between reports, desired mean-squared-error
results = []
(0..3).each do |i|
  (0..3).each do |j|
    a = i.to_f / 3
    b = j.to_f / 3
    inputs = sprintf "%.1f & %.1f", a, b
    inputs = (a+b).round(1)
    results.push [inputs, fann.run([a,b]).first]
  end
end

puts AsciiCharts::Cartesian.new(results.sort_by &:first).draw