require "feather_watch/version"
require "feather_watch/os"
require "feather_watch/watcher"


require 'rb-fsevent' if FeatherWatch::OS.mac?
require 'rb-inotify' if FeatherWatch::OS.linux?
require 'wdm'        if FeatherWatch::OS.windows?

module FeatherWatch
end
