require 'rubygems'
require 'twitter'
require 'yaml'

keys = YAML.load_file('application.yml')

client = Twitter::REST::Client.new do |config|
	config.consumer_key        = keys['CONSUMER_KEY']
  	config.consumer_secret     = keys['CONSUMER_KEY_SECRET']
  	config.access_token        = keys['ACCESS_TOKEN']
	config.access_token_secret = keys['ACCESS_TOKEN_SECRET']
end

file = "scraped_tweets.txt"

#File.readlines('test.txt').map do |line|
#  line.split.map(&:to_i)
#end

def collect_with_max_id(collection=[], max_id=nil, &block)
  response = yield(max_id)
  collection += response
  response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def client.get_all_tweets(user)
  collect_with_max_id do |max_id|
    options = {count: 10, include_rts: false}
    options[:max_id] = max_id unless max_id.nil?
    user_timeline(user, options)
  end
end

username_list = ['KimKardashian', 'BTS_twt', 'biticonjustine']


#client.get_all_tweets("sam_lam18")

#count = 10

#target = open(file, 'a+')

username_list.each do |user|
  	puts "Now scraping tweets for #{user}"
  	client.get_all_tweets(user)
end

#target.close

puts "All finished. The tweets have been saved in #{file}"





