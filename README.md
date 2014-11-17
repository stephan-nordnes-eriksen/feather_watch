# FeatherWatch

Light weight, cross platform, file system watcher. 

## Installation

Add this line to your application's Gemfile:

    gem 'feather_watch'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install feather_watch

## Usage

	require "feather_watch"
	callback = lambda{|e| puts "Event #{e[:status]} on file #{e[:file]}"}
	paths_to_watch = "/" #can be a string or array of string, eg: ["/home/data", "/home/pictures"]
	watcher = FeatherWatch::Watcher.new(paths_to_watch, callback)
	watcher.start #non-blocking

	#To stop:
	watcher.stop

# IMPORTANT!
Feather Watch will recieve very many file events, even for temp files. Care should be taken when handling the events. Make sure to only process what you need. For instance, you should check against temp-files, and skip those events. Example:

	#black list approach
	un_accepted_file_types = ["tmp", "cache", "db"]
	callback = lambda{|e| use_event(e) unless un_accepted_file_types.include?(e[:file].split(".")[-1])} 

	#white list approach
	accepted_file_types = ["png", "jpg", "jpeg", "gif"]
	callback = lambda{|e| use_event(e) if accepted_file_types.include?(e[:file].split(".")[-1])}

You need to take care to filter out what you do not need for each target platform. 

### Received statuses

:added
:modified
:removed




## Contributing

1. Fork it ( https://github.com/[my-github-username]/feather_watch/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
