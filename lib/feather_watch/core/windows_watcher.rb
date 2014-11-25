module FeatherWatch::Core
	class WindowsWatcher
		def initialize(directories, callback, verbose= false, silence_exceptions= false)
			puts "Initializing windows watcher" if @verbose

			@verbose = verbose
			@silence_exceptions = silence_exceptions
			directories = [directories] if directories.is_a?(String)
			
			setup_monitor(directories, callback, verbose, silence_exceptions)
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

		private

		def setup_monitor(directories, callback, verbose, silence_exceptions)
			@monitors = []
			directories.each do |dir|
				monitor = WDM::Monitor.new
				@monitors << monitor
				monitor.watch_recursively(dir, :files) do |change|
					begin
						status = nil
						case change.type
						when :added, :renamed_new_file
							status = :added
						when :removed, :renamed_old_file
							status = :removed
						when :modified, :attrib
							status = :modified
						end

						if status != nil
							puts "File #{status.to_s}: #{event.absolute_name}"   if @verbose
							callback.call({status: status, file: change.path, event: change})
						else
							STDERR.puts "Unhandled change type: #{change.type} for file #{change.path}" if @verbose
						end
					rescue Exception => e
						unless @silence_exceptions
							FeatherWatch::Core::Common.print_error(e)
						end
					end
				end	
			end
		end
	end
end