require "feather_watch/version"
require "feather_watch/os"
require "feather_watch/watcher"
require "feather_watch/core/darwin_watcher"
require "feather_watch/core/linux_watcher"
require "feather_watch/core/windows_watcher"


require 'rb-fsevent' if FeatherWatch::OS.mac?
require 'rb-inotify' if FeatherWatch::OS.linux?
require 'wdm'        if FeatherWatch::OS.windows?

module FeatherWatch
	def self.new(*args)
		FeatherWatch::Watcher.new(*args)
	end
end
