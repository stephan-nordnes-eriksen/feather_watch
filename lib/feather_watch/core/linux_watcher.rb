module FeatherWatch::Core
	class LinuxWatcher
		def initialize(directories, callback, verbose= false, silence_exceptions= false)
			@verbose = verbose
			@silence_exceptions = silence_exceptions
			puts "Initializing linux watcher" if @verbose
			@notifiers = []
			directories = [directories] if directories.is_a?(String)
			directories.each do |dir|
				notifier = INotify::Notifier.new
				@notifiers << notifier
				#Avaliable events: :access, :attrib, :close_write, :close_nowrite, :create, :delete, :delete_self, :ignored, :modify, :move_self, :moved_from, :moved_to, :open
				notifier.watch(dir, :recursive, :create, :attrib, :delete, :close_write, :delete_self, :modify, :move_self, :moved_from, :moved_to) do |event|
					#TODO: This information is probably in the event, but I'm on a mac now, so I can't test it properly
					
					begin
						if    !([:attrib, :close_write, :modify] & event.flags ).empty?
							puts "Change on file: #{event.absolute_name}" if @verbose
							callback.call({status: :modified, file: event.absolute_name, event: event})
						elsif !([:moved_to]                      & event.flags ).empty?
							puts "File added: #{event.absolute_name}"     if @verbose
							callback.call({status: :added, file: event.absolute_name, event: event})
						elsif !([:moved_from]                    & event.flags ).empty?
							puts "File removed: #{event.absolute_name}"   if @verbose
							callback.call({status: :removed, file: event.absolute_name, event: event})
						elsif !([:create]                        & event.flags ).empty?
							puts "File added: #{event.absolute_name}"     if @verbose
							callback.call({status: :added, file: event.absolute_name, event: event})
						elsif !([:delete, :delete_self]          & event.flags ).empty?
							puts "File removed: #{event.absolute_name}"   if @verbose
							callback.call({status: :removed, file: event.absolute_name, event: event})
						else
							STDERR.puts "Unhandled status flags: #{event.flags} for file #{event.absolute_name}" if @verbose
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
			puts "Starting linux watcher" if @verbose
			@notifiers.each do |notifier|
				Thread.new do
					notifier.run
				end
			end
		end

		def stop
			puts "Stopping linux watcher" if @verbose
			@notifiers.each do |notifier|
				notifier.stop
			end
		end
	end
end