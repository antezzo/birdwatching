require "rubygems"
require "twitter"
require "yaml"
#require "fileutils"

class TwitterData
	attr_reader :client

	def initialize
		keys = YAML.load_file('application.yml')

		@client = Twitter::REST::Client.new do |config|
			config.consumer_key        = keys['CONSUMER_KEY']
  			config.consumer_secret     = keys['CONSUMER_KEY_SECRET']
  			config.access_token        = keys['ACCESS_TOKEN']
  			config.access_token_secret = keys['ACCESS_TOKEN_SECRET']
		end
	end

	# given keyword, generate n number of users and write data about the users to the file "users_data.txt"
	# #username #followers #friends #tweet_count #fave_count
	def write_userstats_tofile(keyword, n)
	  #key = gets
          cmd = "rm tweets/*.txt"
          Process.spawn(cmd) # will this run the rest of the function
		file = "users_data.txt"
		target = open(file, 'w')
		get_users([keyword], n).each do |username_str|
			target.write(get_user_stats(username_str))
			get_tweets(username_str, 10, "tweets")
		end

		target.close
	end

	def get_users(keywordList, num)
		arr = []
		keywordList.each do |keyword|
			puts "Scraping #{num} #{keyword} tweets"
			client.search("#{keyword} -rt", result_type: "recent").take(num).collect do |tweet|
				arr.push(tweet.user.screen_name)
				#puts tweet.user.screen_name
			end
		end

		return arr
	end

# 	Present information about a Twitter user
	def get_user_stats(username)
		user = client.user(username)
		if user.protected? != true
			username  = user.screen_name.to_s
			#real_name = user.name
			followers	= user.followers_count.to_s
			friends = user.friends_count.to_s
			tweet_count = user.statuses_count.to_s
			fave_count = user.favorites_count.to_s
			string_output = "#{username} #{followers} #{friends} #{tweet_count} #{fave_count}\n"
		end
		return string_output
	end

	# retrieves 'count' number of most recent tweets for the given user, and
	# writes them to a file called <username>_tweets.txt
	# 'target' is the name of the directory (which has to already exist)
	# into which you want to put the tweet txt files
	# 		TWEET
	# 		'retweet count' 'likes count'
	def get_tweets(username, count, target)
		#target_dir = '/#{target}/*'
		#FileUtils.rm_r Dir.glob('#{target_dir}')
		filename = "#{target}/#{username}_tweets.txt"
		target = open(filename, 'w')
		user_retweet_count = 0
		client.user_timeline(username, { :count => count, :tweet_mode => 'extended'}).each do |tweet|
			likes_count = tweet.favorite_count.to_s
			rtcount = tweet.retweet_count.to_s
			target.write(tweet.attrs[:full_text] + "\n\t__END_TWEET__\t#{rtcount} #{likes_count}\n")
			#if tweet.include? "RT"
			#	user_retweet_count += 1
			#end
			#target.write("\t#{rtcount} #{likes_count}\n")
			#puts tweet.attrs[:full_text]
			#puts "\n\t_END TWEET_\n"
		end
		#target.write("#{user_retweet_count}")
		target.close
	end

	#def tweet_info(textfile, target)
	#	to_scrape = textfile
	#	RT_count = 0
	#	to_scrape.each_line do |line|
	#		if line[0,2].equals("RT")
	#			RT_count += 1


			


end



# makes new Twitter User object
tweeter = TwitterData.new

# Test runs
#File.delete('/beak/tweets/KimKardashian.txt')
#tweeter.write_userstats_tofile("trump", 5)
#tweeter.get_tweets("KimKardashian", 10, "tweets")
