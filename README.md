![Feather Watch](/Feather Watch.png?raw=true)

Light weight, cross platform, file system watcher. 

[![Gem Version](https://badge.fury.io/rb/feather_watch.svg)](http://badge.fury.io/rb/feather_watch)
[![Build Status](https://travis-ci.org/stephan-nordnes-eriksen/feather_watch.svg?branch=master)](https://travis-ci.org/stephan-nordnes-eriksen/feather_watch)
[![Coverage Status](https://img.shields.io/coveralls/stephan-nordnes-eriksen/feather_watch.svg)](https://coveralls.io/r/stephan-nordnes-eriksen/feather_watch)
[![Code Climate](https://codeclimate.com/github/stephan-nordnes-eriksen/feather_watch/badges/gpa.svg)](https://codeclimate.com/github/stephan-nordnes-eriksen/feather_watch)
[![feather_watch API Documentation](https://www.omniref.com/ruby/gems/feather_watch.png)](https://www.omniref.com/ruby/gems/feather_watch)
[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=stephan.n.eriksen&url=https://github.com/stephan-nordnes-eriksen/feather_watch&title=feather_watch&language=ruby&tags=github&category=software)


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
	watcher = FeatherWatch.new(paths_to_watch, callback)
	watcher.start #non-blocking

	#To stop:
	watcher.stop

### Received statuses

 - :added
 - :modified
 - :removed


# Important Notes!
Events on OSx, also known as darwin, is current an approximation as the underlying libraries does not currently support actual events. Thus on OSx, you get `:removed` if the file received does not exist by checking File.file?(the_file). If it does exist you get `:modified`. So you will **not** get any `:added` events on OSx.

Feather Watch will receive very many file events, even for temp files. Care should be taken when handling the events. Make sure to only process what you need. For instance, you should check against temp-files, and skip those events. Example:

	#black list approach
	un_accepted_file_types = ["tmp", "cache", "db"]
	callback = lambda{|e| use_event(e) unless un_accepted_file_types.include?(e[:file].split(".")[-1])} 

	#white list approach
	accepted_file_types = ["png", "jpg", "jpeg", "gif"]
	callback = lambda{|e| use_event(e) if accepted_file_types.include?(e[:file].split(".")[-1])}

You need to take care to filter out what you do not need for each target platform. 


### Quirks:

All tests succeed individually on Windows, however, if they are run at the same time usring the command `rspec` some of the tests fail. This is due to file locking which is currently unresolved.


## Contributing

1. Fork it ( https://github.com/stephan-nordnes-eriksen/feather_watch/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
