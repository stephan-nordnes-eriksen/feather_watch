module FeatherWatch
	class Watcher

		# Public: Initialize the file system watcher. 
		#
		# directories  - An array of directories to watch.
		# callback - A callback that will receive events. Recieved objects on form: {status: [:modified, :removed].sample, file: "path/to/file"}. ":modified" means everything except deleted.
		# verbose=false - Enable verbose mode. Warning: Can produce very much output
		#
		# Examples
		#
		#   FeatherWatch::Watcher.new([File.join(Dir.home, 'Desktop')], lambda{|e| puts "got event with status: #{e[:status]} on file #{e[:file]}"})
		#
		# Returns a Watcher object.
		def initialize(directories, callback, verbose= false, silence_exceptions= false)
			@verbose = verbose
			dir = directories
			dir = [directories] if directories.is_a?(String)
			raise "Unknown datatype for directories. Was: #{dir}" unless dir.is_a?(Array)

			dir.each do |d|
				raise "Not a vaild directory: #{d}" unless File.directory?(d)
			end

			@listener = FeatherWatch::Core::DarwinWatcher.new(dir, callback, verbose, silence_exceptions)  if FeatherWatch::OS.mac?
			@listener = FeatherWatch::Core::LinuxWatcher.new(dir, callback, verbose, silence_exceptions)   if FeatherWatch::OS.linux?
			@listener = FeatherWatch::Core::WindowsWatcher.new(dir, callback, verbose, silence_exceptions) if FeatherWatch::OS.windows?
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
			@listener.start if @listener
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
			@listener.stop if @listener
		end
	end
end
