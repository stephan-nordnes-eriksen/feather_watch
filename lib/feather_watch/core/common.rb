module FeatherWatch::Core::Common
	def self.print_error(e)
		STDERR.puts "----------------------------"
		STDERR.puts "Error in Feather Watch callback"
		STDERR.puts "Message: #{e.message}"
		STDERR.puts "backtrace: #{e.backtrace * "\n\t >"}"
	end
end