require "file_system_watcher/version"
require "file_system_watcher/os"


require 'rb-fsevent' if FileSystemWatcher::OS.mac?
require 'rb-inotify' if FileSystemWatcher::OS.linux?
require 'wdm'        if FileSystemWatcher::OS.windows?

module FileSystemWatcher
  # Your code goes here...
end
