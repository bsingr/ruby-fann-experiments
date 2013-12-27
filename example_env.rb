require 'bundler'
Bundler.require

require 'pp'
require 'csv'
require 'matrix'

def training_data name
  raise ArgumentError, 'training data requires name' unless name
  csv_path = File.join(File.dirname(__FILE__), 'training_data', name + '.csv')
  raise ArgumentError, "training data not found #{csv_path}" unless File.exists?(csv_path)
  csv = CSV.open(csv_path)
  rows_without_header = csv.read.to_a[1..-1]
  inputs = []
  outputs = []
  rows_without_header.each do |cells|
    inputs << cells[0..-2]
    outputs << cells.last
  end
  {:inputs => inputs, :outputs => outputs}
end

def write_training_data name, inputs, outputs
  raise ArgumentError, 'training data requires name' unless name
  raise ArgumentError, 'inputs not given' unless inputs
  raise ArgumentError, 'outputs not given' unless outputs
  csv_path = File.join(File.dirname(__FILE__), 'training_data', name + '.csv')
  CSV.open(csv_path, 'wb') do |csv|
    csv << %w[ x1 x2 x3 x4 x5 x6 x7 x8 x9 winner ]
    inputs.size.times do |i|
      row = inputs[i].push outputs[i]
      csv << row
    end
  end
end

def build_train_data training_data
   RubyFann::TrainData.new :inputs => training_data[:inputs].map{|i| i.map &:to_f},
                           :desired_outputs => training_data[:outputs].map{|o| [o.to_f]}
end

def terminate_plotter!
end

class Plotter
  def self.terminate_all!
    `killall gnuplot_x11`
  end

  def plot matrix
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
          ds.with = "points palette pointsize 2 pointtype 7"
        end
      end
    end
  end
end
