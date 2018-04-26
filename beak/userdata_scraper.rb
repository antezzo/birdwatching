require "rubygems"
require "twitter"
require "yaml"

#class TwitterApi
	#attr_reader :client

	#def initialize
keys = YAML.load_file('application.yml')


	#end

file = "tweets.txt"

	#keywordList = ["retweet", "lol", "hola"]

	#numTweeters = 10

	

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
	# #username #followers #friends #tweet_count
	def write_userstats_tofile(keyword, n)
		
		file = "users_data.txt"
		target = open(file, 'w')
		get_users([keyword], n).each do |username_str|
			target.write(get_user_stats(username_str))
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
			string_output = "#{username} #{followers} #{friends} #{tweet_count}\n"
		end
		return string_output
	end

	# DYLAN !!! UNTRUNCATE !!!
	def get_tweets(username)
		client.user_timeline(username).each do |tweet|
			puts tweet.truncated?
			puts "\n\tEND TWEET ---------------------------------- \n"
		end
	end


end



# makes new Twitter User object
tweeter = TwitterData.new

tweeter.write_userstats_tofile("watermelon", 10)
tweeter.get_tweets("KimKardashian")

		