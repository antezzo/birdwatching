# 041718
# preprocesses data

require_relative '../belly/kclusters_implementation/class_kclusters'
require_relative 'twitter_scraper'
#require_relative 'beak/application.yml'

class Gullet

  # updates average
  def avg(avg, size, new)
      return ((size * avg) + new)/(size + 1)
  end

  # checks if word is a swear
  def is_swear(word)
      word = word.downcase
      if word.include? "fuck" or word.include? "shit" or word.include? "damn" or word.include? "bitch"
  	return true
      else
  	return false
      end
  end


  def process(keyword, k, num_users, should_scrape)# constants for running subprocess

    scraper = TwitterData.new()

    if (should_scrape)
      scraper.write_userstats_tofile(keyword, num_users)
    end

    # INIT COUNTS
    tweet_num = 0 # total number of tweets

    # INIT AVERAGES
    count_avg = 0 # avg word count
    swear_avg = 0 # avg swear to word ratio


    kcl = KClusters.new
    data = Array.new

    begin
      file = File.open("users_data.txt", "r")


      while !file.eof?
      	line = file.readline
      	next if line.strip.empty? == true
      	arr = line.split(' ')

      	tweets = File.open("tweets/" + arr[0] + "_tweets.txt")
      	#tweets = File.open("beak/tweets/KimKardashian_tweets.txt")
      	while !tweets.eof?
      	    tweet = tweets.readline
      	    next if line.strip.empty? == true
      	    next if line.strip == "__END_TWEET__"
      	    tarr = tweet.split(' ')

      	    tweet_num += 1
      	    word_num = arr.count
      	    swear_num = 0

      	    count_avg = avg(count_avg, tweet_num, word_num)

      	    tarr.each do |w|
          		if is_swear(w)
          		    swear_num += 1
          		end
      	    end

      	    swear_avg = avg(swear_avg, tweet_num, swear_num/word_num)


      	end
        tweets.close

      	data_point = {
      	    id: arr[0],
      	    followers: arr[1].to_i,
      	    friends: arr[2].to_i,
      	    tweet_count: arr[3].to_i,
      	    count_avg: count_avg,
      	    #swear_avg: swear_avg
      	}
      	data.push(data_point)
      end

      puts data

      file.close
    rescue
      return 1 # something went wrong
    end

    labeled_data = kcl.get_clusters(data, k)
    puts "The entire labeled data set...\n"
    puts labeled_data

    return 0 # if it worked
  end
end

#gullet = Gullet.new()
#print gullet.process("brain", 3, 5, false)
