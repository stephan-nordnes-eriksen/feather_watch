module FeatherWatch::Core
	class DarwinWatcher
		def initialize(directories, callback, verbose= false, silence_exceptions= false)
			@verbose = verbose
			@silence_exceptions = silence_exceptions
			puts "Initializing mac watcher" if @verbose
			@fs_event = FSEvent.new
			options = { :no_defer => true,
						:file_events => true }

			@fs_event.watch directories, options do |changed_files|
				changed_files.each do |f|
					begin
						if File.file?(f)
							puts "Change on file: #{f}" if @verbose
							callback.call({status: :modified, file: f})
						else
							puts "Removed file: #{f}" if @verbose
							callback.call({status: :removed, file: f})
						end
					rescue Exception => e
						unless @silence_exceptions
							STDERR.puts "----------------------------"
							STDERR.puts "Error in Feather Watch callback"
							STDERR.puts "Message: #{e.message}"
							STDERR.puts "backtrace: #{e.backtrace * "\n\t >"}"
						end
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