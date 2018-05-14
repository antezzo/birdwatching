require 'pry-byebug' # just for debuggins
include Math # for square root and exponentials

# 'pry' is a debugging tool, and should be the only gem you have to install

class KClusters
  # k-means in ruby
  #
  # Returns the dataset with the corresponding label added to each data-point-hash
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

    z_scored_flat_data = calculate_and_convert_to_z_scores(flat_data, num_features)

    features = Array.new(num_features) {Array.new} # an array of features

    z_scored_flat_data.each { |feat_list|
        for i in 0...num_features
          features[i].push(feat_list[i])
        end
    }

    # array of min and max pairs for a given feature (by index)
    min_max = Array.new
    for i in 0...num_features
      min_max[i] = [features[i].min, features[i].max]
    end

    # initialize centroids
    centroids = Array.new(k)
    for i in 0...k
      centroids[i] = random_centroid(min_max)
    end

    # once we enter the loop this will be where we store the old centroid coordinates
    oldCentroids = Array.new(k) {Array.new(num_features)}

    while (not settled(oldCentroids, centroids))
      oldCentroids = centroids

      labels = get_labels(z_scored_flat_data, centroids, k) # make sure these are right lol

      centroids = calculate_new_centroids(z_scored_flat_data, labels, k, min_max)
    end

    for i in 0...data.length
      j = 0
      data[i].keys.each { |key|
        if (key != :id)
          data[i][key] = z_scored_flat_data[i][j]
          j += 1
        end
      }
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

  # returns true if oldCentroids == centroids
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

    return sum_array.map! { |f| f.to_f / points.size}
  end

  def calculate_and_convert_to_z_scores(data, num_features)
    s_dev, means = calculate_standard_deviation(data, num_features)

    i = 0
    z_data = Array.new()
    data.each { |point|
      z_point = Array.new()
      point.each { |val|
      if (s_dev[i] == 0)
        val = (val.to_f - means[i])
      else
        val = ((val.to_f - means[i]) / s_dev[i])
      end
        z_point.push(val)
      }
      z_data.push(z_point)
      i += 1
      if (i == num_features)
        i = 0
      end
    }
    return z_data
  end

  def calculate_standard_deviation(data, num_features)
    s_deviation = Array.new()
    total = 0
    num = 0
    means = Array.new() # always indexed by feature

    all_differences = Array.new() # going to be the same size as data

    for i in 0...num_features
      data.each { |el|
        total += el[i]
        num += 1
      }
      mean = total.to_f / num.to_f
      means.push(mean)

      differences = Array.new() # for each feature
      data.each { |el|
        differences.push((el[i]-mean)**2)
      }
      all_differences.push(differences)
    end

    all_differences.each { |el|
      total = 0
      num = 0
      el.each { |val|
        total += val
        num += 1
      }

      mean = total.to_f / num.to_f
      s_deviation.push(sqrt(mean)) # standard deviations indexed by feature number
    }

    return s_deviation, means
  end
end
