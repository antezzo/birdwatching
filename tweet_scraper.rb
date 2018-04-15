require 'rubygems'
require 'twitter'
require 'yaml'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end

file = "scraped_tweets.txt"

#File.readlines('test.txt').map do |line|
#  line.split.map(&:to_i)
#end

username_list = ['thunder_thiighs', 'varshasinghmcx', 'warshipclass', 'JefeMulaa', 'Chiwoke_', 'AlexWr1ter']

count = 15

target = open(file, 'a+')
arr = []

username_list.each do |user|
  puts "Now scraping tweets for #{user}"
  client.user_timeline("#{user}", options= {count: "#{count}", include_rts: false, exclude_replies: true}).take(count).collect do |tweet|
  arr.push(tweet.text)
  end
end

unique = ary.uniq
unique.each do |uniquetweet|
  target.write(uniquetweet)
  target.write("\n")
end

target.close

puts "All finished. The tweets have been saved in #{filename}"
