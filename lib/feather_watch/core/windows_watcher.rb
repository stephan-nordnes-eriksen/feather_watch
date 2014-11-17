module FeatherWatch::Core
	class WindowsWatcher
		def initialize(directories, callback, verbose= false)
			@verbose = verbose
			puts "Initializing windows watcher" if @verbose
			@monitors = []
			directories.each do |dir|
				monitor = WDM::Monitor.new
				@monitors << monitor
				monitor.watch_recursively(dir, :files) do |change|
					#TODO: Have not tested this. It should work

					case change.type
					when :added, :renamed_new_file
						puts "File added: #{change.path}" if @verbose
						callback.call({status: :added, file: change.path})
					when :removed, :renamed_old_file
						puts "Removed file: #{change.path}" if @verbose
						callback.call({status: :removed, file: change.path})
					when :modified, :attrib
						puts "File modified: #{change.path}" if @verbose
						callback.call({status: :modified, file: change.path})
					else
						puts "Unhandled status type: #{change.type} for file #{change.path}" if @verbose
					end
				end	
			end
		end
		
		def start
			puts "Starting windows watcher" if @verbose
			@monitors.each do |monitor|
				Thread.new do
					monitor.run!
				end
			end
		end

		def stop
			puts "Stopping windows watcher" if @verbose
			@monitors.each do |monitor|
				monitor.stop
			end
		end
	end
end