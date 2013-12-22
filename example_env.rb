require 'bundler'
Bundler.require

require 'csv'

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

def build_train_data training_data
   RubyFann::TrainData.new :inputs => training_data[:inputs].map{|i| i.map &:to_f},
                           :desired_outputs => training_data[:outputs].map{|o| [o.to_f]}
end