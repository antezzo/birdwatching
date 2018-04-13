

require 'ffi'
require 'pry'
require 'matrix'
include Math

module C_lib
  extend FFI::Library

  ffi_lib 'c'
  ffi_lib './k_means.so'

  attach_function :calculate_clusters, [ :pointer, :uint, :int, :int], :pointer
end

class KClusters

  def initialize
    #puts "made it!"
  end

  # k-means in ruby
  #
  # Returns the dataset with the corresponding label added to each entry
  # as a number from 1-k
  # ex: data[0] = {:x => 5, :y => 10} becomes
  #     data[0] = {:x => 5, :y => 10, :label => 4}
  #
  def get_clusters(data, k)

    num_features = data[0].length - 1

    # build matrix representation of data without id's
    flat_data = Array.new(data.length)
    for i in 0...(data.length)
      flat_data[i] = data[i].values.drop(1)
    end
    data_mat = Matrix[*flat_data] # is this really necessary??

    # matrix of mins and maxes for a given feature (by index)
    min_max = Array.new
    features = data_mat.column_vectors
    for i in 0...num_features
      min_max[i] = [features[i].min, features[i].max]
    end

    # initialize centroids
    centroids = Array.new(k)
    for i in 0...k
      centroids[i] = random_centroid(min_max)
    end

    oldCentroids = Array.new(k) {Array.new(num_features)}

    while (not settled(oldCentroids, centroids))
      oldCentroids = centroids

      labels = get_labels(flat_data, centroids, k) # make sure these are right lol

      centroids = calculate_new_centroids(flat_data, labels, k, min_max)
    end

    for i in 0...data.length
      data[i][:label] = labels[i]
    end
    return data
  end

  def random_centroid(min_max)
    centroid = Array.new
    for i in 0...min_max.size
      centroid.push(rand(min_max[i][0]...min_max[i][1]))
    end
    return centroid
  end

  def settled(oldCentroids, centroids)
    return (oldCentroids - centroids).empty?
  end

  def get_labels(data, centroids, k)
    labels = Array.new

    for i in 0...(data.size)
      distances = Array.new
      for j in centroids
        distances.push(sqrt(sum_diff_sq(data[i], j)))
      end

      labels.push(distances.index(distances.min) + 1)
    end
    return labels
  end

  def sum_diff_sq(data_point, centroid)
    sum = 0;
    for f in 0...data_point.length
      diff = data_point[f] - centroid[f]
      sum += diff**2
    end

    return sum
  end

  def calculate_new_centroids(data, labels, k, min_max)
    centroids = Array.new

    for j in 1..k # for each cluster
      points_in_cluster = Array.new
      for i in 0...labels.size
        if labels[i] == j  # if the point was assigned to that cluster put it in the array
          points_in_cluster.push(data[i])
        end
      end
      centroid = calculate_averages_from(points_in_cluster, min_max)
      centroids.push(centroid)
    end

    return centroids
  end

  def calculate_averages_from(points, min_max)

    if points.empty?
      return random_centroid(min_max)
    end

    sum_array = Array.new(points[0].size, 0)
    for i in 0...points[0].size
      for j in points
        sum_array[i] += j[i]
      end
    end

    return sum_array.map! { |f| f / points.size}
  end

  # Returns the data array with corresponding labels appended to each point (implemented in C)
  # Params:
  # +data+:: the dictionary of features
  # +k+:: the number of clusters to use
  # Returns:
  # an array of labels (ints from 1-k), whose indices correspond to the 'data' array's indices.
  def get_clusters_c(data, k)

    flattened_data = Array.new

    data.each { |hash| # flattening the hash into an array of values
      flat_hash = hash.values.drop(1) # remove the first element of each hash (which will be 'id')
      flattened_data.push(flat_hash)
    }

    flattened_data.flatten! # should this be totally flat?

    p_flat_data = FFI::MemoryPointer.new :double, flattened_data.size

    p_flat_data.put_array_of_double 0, flattened_data

    p_processed_array = C_lib.calculate_clusters(p_flat_data, data.length, (data[0].length - 1), k)

    processed_array = p_processed_array.read_array_of_double(flattened_data.size)

    puts processed_array
  end

  def calculate_clusters(data, num_points, num_features, k)
      return C_lib.test(data, num_points, num_features, k)
  end

end
