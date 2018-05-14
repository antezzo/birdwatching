# 041718
# preprocesses data

require_relative 'belly/kclusters_implementation/class_kclusters'
require_relative 'beak/userdata_scraper'
require_relative 'beak/application.yml'

# constants for running subprocess
SCRAPER = File.expand_path(userdata_scraper)
RUBY = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])

$stdout.sync = true

# INIT COUNTS
tweet_num = 0 # total number of tweets

# INIT AVERAGES
count_avg = 0 # avg word count
swear_avg = 0 # avg swear to word ratio

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


if $PROGRAM_NAME == __FILE__
    
    kcl = KClusters.new
    data = Array.new

    # run scraper
    `ruby -r#{SCRAPER}`

    file = File.open("beak/users_data.txt", "r")
    while !file.eof?
	line = file.readline
	next if line.strip.empty? == true
	arr = line.split(' ')
    
	tweets = File.open("beak/tweets/" + arr[0] + "_tweets.txt")
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
    
	    arr.each do |w|
		if is_swear(w)
		    swear_num += 1
		end
	    end

	    swear_avg = avg(swear_avg, tweet_num, swear_num/word_num)
	    tweets.close

	end	

	data_point = {
	    id: arr[0],
	    followers: arr[1].to_i,
	    friends: arr[2].to_i,
	    tweet_count: arr[3].to_i,
	    count_avg: count_avg,
	    swear_avg: swear_avg
	}
	data.push(data_point)    
	#puts line
    end

    file.close

    k = 5 
    labeled_data = kcl.get_clusters(data, k)
    puts "The entire labeled data set...\n"
    puts labeled_data
end
