module FeatherWatch::Core
	class WindowsWatcher
		def initialize(directories, callback, verbose= false, silence_exceptions= false)
			@verbose = verbose
			@silence_exceptions = silence_exceptions
			puts "Initializing windows watcher" if @verbose
			@monitors = []
			directories = [directories] if directories.is_a?(String)
			directories.each do |dir|
				monitor = WDM::Monitor.new
				@monitors << monitor
				monitor.watch_recursively(dir, :files) do |change|
					#TODO: Have not tested this. It should work

					begin
						case change.type
						when :added, :renamed_new_file
							puts "File added: #{change.path}" if @verbose
							callback.call({status: :added, file: change.path, event: change})
						when :removed, :renamed_old_file
							puts "Removed file: #{change.path}" if @verbose
							callback.call({status: :removed, file: change.path, event: change})
						when :modified, :attrib
							puts "File modified: #{change.path}" if @verbose
							callback.call({status: :modified, file: change.path, event: change})
						else
							STDERR.puts "Unhandled status type: #{change.type} for file #{change.path}" if @verbose
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