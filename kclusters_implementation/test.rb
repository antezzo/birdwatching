=begin
    test.rb - test implementation of the KCluster object.
=end
require 'csv'
require 'pry'

require_relative 'class_kclusters'

kcl = KClusters.new

data = Array.new

CSV.foreach("test_data.csv") do |row|
  data_point = {
    id: row[0],
    x: row[1].to_i,
    y: row[2].to_i
  }

  data.push(data_point)
end

# data.each { |hash|
#   puts hash
# }

k = 4

labeled_data = kcl.get_clusters(data, k)

data_by_label = Hash.new
for i in 1..k
  label_set = labeled_data.select { |e| e[:label] == i}
  data_by_label[i] = label_set
end

data_as_hash = Hash.new
for i in 1..k
  x_arr = Array.new
  y_arr = Array.new
  data_by_label[i].each { |h|
      x_arr.push(h[:x])
      y_arr.push(h[:y])
   }
  data_as_hash[i.to_sym] = ([x_arr, y_arr])
end

print data_as_hash

exit
