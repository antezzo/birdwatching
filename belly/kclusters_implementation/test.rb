=begin
    test.rb - test implementation of the KCluster object.
=end
require 'csv' # I think that this is built in to ruby (if not, comment it out,
              # the only thing I use it for is reading in the test data-points

# require 'pry' # this is just for debugging

require_relative 'class_kclusters'

# make a new KCluster object
kcl = KClusters.new

data = Array.new

# Make an array of data-point-hashes
CSV.foreach("test_data.csv") do |row|
  data_point = {
    id: row[0],
    x: row[1].to_i,
    y: row[2].to_i
  }

  data.push(data_point)
end

# puts data

# set a k value (or pass it directly)
k = 4

print "Before: "
puts data[0]

# call the '.getclusters()' method, which will return a data array with the id's reappended
# and each data-point-hash will have an additional key-value pair (ex. {:label => 3})
labeled_data = kcl.get_clusters(data, k)


print "After: "
puts labeled_data[0]

puts "\t-----------------------------"
puts "The entire labeled data set...\n"
puts labeled_data # so you can get an idea of the labeled data set


# this is an example of how to organize the labeled data by label
# data_by_label[1] = < all the dph's with label 1 >
data_by_label = Hash.new
for i in 1..k
  label_set = labeled_data.select { |e| e[:label] == i}
  data_by_label[i] = label_set
end

# print data_by_label

# this is very similar to above, except the label is the key of a Hash instead
# of the index of an array.  Each key of the hash points to a list containing lists
# that represent the feature values for each data-point with that label (one of x_coordinates
# and one of y_coordinates in the case of the test-data), they are aligned by index.
data_as_hash = Hash.new
for i in 1..k
  x_arr = Array.new
  y_arr = Array.new
  data_by_label[i].each { |h|
      x_arr.push(h[:x])
      y_arr.push(h[:y])
   }
  data_as_hash[i] = ([x_arr, y_arr])
end

#puts data_as_hash

exit
