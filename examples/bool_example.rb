#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), '..')
require 'example_env'

NAME = ARGV.first || 'or_binary'

and_data = training_data(NAME)
train = build_train_data(and_data)
fann = RubyFann::Standard.new(:num_inputs=>2,
                              :hidden_neurons=>[2,2],
                              :num_outputs=>1)
fann.train_on_data(train, 100, 100, 0.01) # max epochs, errors between reports, desired mean-squared-error
results = []

resolution = 30
(0..resolution).each do |i|
  (0..resolution).each do |j|
    a = i.to_f / resolution
    b = j.to_f / resolution
    results.push [a, b, fann.run([a,b]).first]
  end
end
matrix = Matrix[results]

Gnuplot.open do |gp|
  Gnuplot::SPlot.new( gp ) do |plot|
    plot.grid

    plot.xlabel "x1"
    plot.ylabel "x2"
    plot.zlabel "h"
    plot.set "xrange [0:1]"
    plot.set "yrange [0:1]"
    plot.set "zrange [0:1]"
    plot.set "xtics 0.25"
    plot.set "ytics 0.25"
    plot.set "ztics 0.25"
    #plot.set "surface"
    #plot.set "view 50,10,1.0,1.0"
    #plot.set "dgrid3d 50,50,3"

    plot.data << Gnuplot::DataSet.new([matrix.row(0).to_a,
                                       matrix.row(1).to_a,
                                       matrix.row(2).to_a]) do |ds|
      ds.title = NAME
      ds.using = "1:2:3"
      ds.with = "points palette pointsize 1 pointtype 7"
    end
  end
end
