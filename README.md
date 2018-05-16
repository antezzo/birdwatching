Bird Watching: Using K-Means Clustering to Profile Twitter Users
============
by Matthew Antezzo, Dylan diBenedetto, Julia Friend, and Samantha Lam

### PROGRAM DESCRIPTIONS ###
beak: scrapes Twitter user and tweet data and writes the users' statistics to "users_data.txt" and the users' tweets to individual text files named after each user in the "tweets" directory. The data is pre-processed in our gulletprogram and scores are generated to be run through our belly program
* application.yml: client configuration file that contains our access tokens and consumer keys and allows us to implement the Twitter API methods
* twitter_scraper.rb: Twitter data scraper that generates a list of most recent Twitter users that have tweeted with a specific keyword and their statistics (number of followers, number of users followed, number of tweets, and number of favorited tweets) and writes them to "users_data.txt", along with writing the users' 10 most recent tweets to text files named after each user in the "tweets" directory.
* tsne.py: implementation of t-SNE in Python
* gullet.rb: preprocesses the scraped Twitter data with text analysis functions and generates z-scored labels and features in text files
* tweets: contains text files of users's 10 most recent tweets
* users_data.txt: Twitter users and their statistics
* z_scored_labels.txt: z-scored labels for each user based on number of clusters inputted
* z_scored_features.txt: z-scored features without knowing the clusters 

belly: contains our k-clusters algorithm
* class_kclusters.rb: Returns the dataset with the corresponding label added to each data-point-hash as a number from 1-k

feathers: GUI and graph image files

### RUNNING THE PROGRAM ###
1) Run the "birdwatching" executable
2) Choose or type in a search keyword
3) Specify number of clusters or the default is 2
4) Check whether or not you want to scrape a new set of data (must scrape data on first run)
5) ~*~ RUN IT ~*~

### DEPENDENCIES ###

* twitter gem
* yaml gem
* ImageMagick software (https://www.imagemagick.org/script/download.php)
* RMagick gem (https://github.com/rmagick/rmagick)
* Tk for Ruby (http://www.tkdocs.com/tutorial/install.html)
