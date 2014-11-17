module FeatherWatch::Core
	class DarwinWatcher
		def initialize(directories, callback, verbose= false)
			@verbose = verbose
			puts "Initializing mac watcher" if @verbose
			@fs_event = FSEvent.new
			@fs_event.watch directories, {file_events: true} do |changed_files|
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
		
		def start
			puts "Starting mac watcher" if @verbose
			Thread.new do
				@fs_event.run
			end
		end

		def stop
			puts "Stopping mac watcher" if @verbose
			@fs_event.stop
		end
	end
end