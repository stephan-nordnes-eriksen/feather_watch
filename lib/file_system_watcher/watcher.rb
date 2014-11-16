module FileSystemWatcher
	class Watcter
		def initialize(directories, callback, verbose=false)
			@verbose = verbose
			initialize_mac(directories, callback)     if FileSystemWatcher::OS.mac?
			initialize_linux(directories, callback)   if FileSystemWatcher::OS.linux?
			initialize_windows(directories, callback) if FileSystemWatcher::OS.windows?
		end
		def start
			start_mac     if FileSystemWatcher::OS.mac?
			start_linux   if FileSystemWatcher::OS.linux?
			start_windows if FileSystemWatcher::OS.windows?
		end

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
					callback(f)
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
					callback(event.name)
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
					callback(change)
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
