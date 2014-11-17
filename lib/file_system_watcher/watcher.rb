module FileSystemWatcher
	class Watcher

		# Public: Initialize the file system watcher. 
		#
		# directories  - An array of directories to watch.
		# callback - A callback that will receive events. Recieved objects on form: {status: [:modified, :removed].sample, file: "path/to/file"}. ":modified" means everything except deleted.
		# verbose=false - Enable verbose mode. Warning: Can produce very much output
		#
		# Examples
		#
		#   FileSystemWatcher::Watcher.new([File.join(Dir.home, 'Desktop')], lambda{|e| puts "got event with status: #{e[:status]} on file #{e[:file]}"})
		#
		# Returns a Watcher object.
		def initialize(directories, callback, verbose= false)
			@verbose = verbose
			initialize_mac(directories, callback)     if FileSystemWatcher::OS.mac?
			initialize_linux(directories, callback)   if FileSystemWatcher::OS.linux?
			initialize_windows(directories, callback) if FileSystemWatcher::OS.windows?
		end

		# Public: Starts the watcher.
		#
		# Examples
		#
		#   watcher.start
		#   # => nil
		#
		# Returns nil
		def start
			start_mac     if FileSystemWatcher::OS.mac?
			start_linux   if FileSystemWatcher::OS.linux?
			start_windows if FileSystemWatcher::OS.windows?
		end

		# Public: Stops the watcher.
		#
		# Examples
		#
		#   watcher.start
		#   # => nil
		#
		# Returns nil
		def stop
			stop_mac     if FileSystemWatcher::OS.mac?
			stop_linux   if FileSystemWatcher::OS.linux?
			stop_windows if FileSystemWatcher::OS.windows?
		end

		private
		def initialize_mac(directories, callback)
			puts "Initializing mac watcher" if @verbose
			@listener_object_mac = FSEvent.new
			@listener_object_mac.watch directories, {file_events: true} do |changed_files|
				changed_files.each do |f|
					if File.file?(f)
						puts "Change on file: #{f}" if @verbose
						callback.call({status: :modified, file: f})
					else
						puts "Removed file: #{f}" if @verbose
						callback.call({status: :removed, file: f})
					end
				end
			end
		end
		def initialize_linux(directories, callback)
			puts "Initializing linux watcher" if @verbose
			@listener_object_linux = []
			directories.each do |dir|
				notifier = INotify::Notifier.new
				@listener_object_linux << notifier
				#Avaliable events: :access, :attrib, :close_write, :close_nowrite, :create, :delete, :delete_self, :ignored, :modify, :move_self, :moved_from, :moved_to, :open
				notifier.watch(:create, :delete, :delete_self, :modify, :move_self, :moved_from, :moved_to) do |event|
					#TODO: This information is probably in the event, but I'm on a mac now, so I can't test it properly
					if File.file?(event.name)
						puts "Change on file: #{event.name}" if @verbose
						callback.call({status: :modified, file: event.name})
					else
						puts "Removed file: #{event.name}" if @verbose
						callback.call({status: :removed, file: event.name})
					end
				end
			end
		end
		def initialize_windows(directories, callback)
			puts "Initializing windows watcher" if @verbose
			@listener_object_windows = []
			directories.each do |dir|
				monitor = WDM::Monitor.new
				@listener_object_windows << monitor
				monitor.watch_recursively(dir, :files) do |change|
					#TODO: Have not tested this. It might work
					if File.file?(change)
						puts "Change on file: #{change}" if @verbose
						callback.call({status: :modified, file: change})
					else
						puts "Removed file: #{change}" if @verbose
						callback.call({status: :removed, file: change})
					end
					
				end	
			end
		end
		def start_mac
			puts "Starting mac watcher" if @verbose
			Thread.new do
				@listener_object_mac.run
			end
		end
		def start_linux
			puts "Starting linux watcher" if @verbose
			@listener_object_linux.each do |monitor|
				Thread.new do
					monitor.run
				end
			end
		end
		def start_windows
			puts "Starting windows watcher" if @verbose
			@listener_object_windows.each do |monitor|
				Thread.new do
					monitor.run!
				end
			end
		end
		def stop_mac
			puts "Stopping mac watcher" if @verbose
			@listener_object_mac.stop
		end
		def stop_linux
			puts "Stopping linux watcher" if @verbose
			@listener_object_linux.each do |notifier|
				notifier.stop
			end
		end
		def stop_windows
			puts "Stopping windows watcher" if @verbose
			@listener_object_windows.each do |monitor|
				monitor.stop
			end
		end
	end
end
