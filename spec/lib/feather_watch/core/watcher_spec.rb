require 'spec_helper'


describe FeatherWatch::Watcher do
	describe ".initialize" do
		it "does not crash" do
			expect{FeatherWatch::Watcher.new(Dir.pwd, lambda { |e|  })}.to_not raise_error
			expect{FeatherWatch::Watcher.new(Dir.pwd, lambda { |e|  }, false)}.to_not raise_error
		end
		it "calls DarwinWatcher.new on darwin" do
			allow(Kernel).to receive(:require).with('rb-fsevent')
			allow(FeatherWatch::OS).to receive(:mac?)      {true}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = Dir.pwd
			callback = lambda { |e|  }
			verbose = false
			silence_exceptions = true

			expect(FeatherWatch::Core::DarwinWatcher).to receive(:new).with([path],callback,verbose,silence_exceptions)
			
			FeatherWatch::Watcher.new(path,callback,verbose,silence_exceptions)
		end
		it "calls LinuxWatcher.new on linux" do
			allow(Kernel).to receive(:require).with('rb-inotify')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {true}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = Dir.pwd
			callback = lambda { |e|  }
			verbose = false
			silence_exceptions = true

			expect(FeatherWatch::Core::LinuxWatcher).to receive(:new).with([path],callback,verbose,silence_exceptions)
			
			FeatherWatch::Watcher.new(path,callback,verbose,silence_exceptions)
		end
		it "calls WindowsWatcher.new on windows" do
			allow(Kernel).to receive(:require).with('wdm')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {true}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = Dir.pwd
			callback = lambda { |e|  }
			verbose = false
			silence_exceptions = true

			expect(FeatherWatch::Core::WindowsWatcher).to receive(:new).with([path],callback,verbose,silence_exceptions)
			
			FeatherWatch::Watcher.new(path,callback,verbose,silence_exceptions)
		end
	end

	describe ".start" do
		it "calls start on a DarwinWatcher on darwin" do
			allow(Kernel).to receive(:require).with('rb-fsevent')
			allow(FeatherWatch::OS).to receive(:mac?)      {true}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = Dir.pwd
			callback = lambda { |e|  }
			verbose = false
			silence_exceptions = true

			darwin_spy = spy "DarwinWatcher"
			expect(FeatherWatch::Core::DarwinWatcher).to receive(:new).with([path],callback,verbose,silence_exceptions) {darwin_spy}
			expect(darwin_spy).to receive(:start)
			FeatherWatch::Watcher.new(path,callback,verbose,silence_exceptions).start
		end
		it "calls start on a LinuxWatcher on linux" do
			allow(Kernel).to receive(:require).with('rb-inotify')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {true}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = Dir.pwd
			callback = lambda { |e|  }
			verbose = false
			silence_exceptions = true

			linux_spy = spy "LinuxWatcher"
			expect(FeatherWatch::Core::LinuxWatcher).to receive(:new).with([path],callback,verbose,silence_exceptions) {linux_spy}
			expect(linux_spy).to receive(:start)
			FeatherWatch::Watcher.new(path,callback,verbose,silence_exceptions).start
		end
		it "calls start on a WindowsWatcher on windows" do
			allow(Kernel).to receive(:require).with('wdm')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {true}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = Dir.pwd
			callback = lambda { |e|  }
			verbose = false
			silence_exceptions = true

			windows_spy = spy "WindowsWatcher"
			expect(FeatherWatch::Core::WindowsWatcher).to receive(:new).with([path],callback,verbose,silence_exceptions) {windows_spy}
			expect(windows_spy).to receive(:start)
			FeatherWatch::Watcher.new(path,callback,verbose,silence_exceptions).start
		end
	end

	describe ".stop" do
		it "calls stop on a DarwinWatcher on darwin" do
			allow(Kernel).to receive(:require).with('rb-fsevent')
			allow(FeatherWatch::OS).to receive(:mac?)      {true}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = Dir.pwd
			callback = lambda { |e|  }
			verbose = false
			silence_exceptions = true

			darwin_spy = spy "DarwinWatcher"
			expect(FeatherWatch::Core::DarwinWatcher).to receive(:new).with([path],callback,verbose,silence_exceptions) {darwin_spy}
			expect(darwin_spy).to receive(:stop)
			FeatherWatch::Watcher.new(path,callback,verbose,silence_exceptions).stop
		end
		it "calls stop on a LinuxWatcher on linux" do
			allow(Kernel).to receive(:require).with('rb-inotify')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {true}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = Dir.pwd
			callback = lambda { |e|  }
			verbose = false
			silence_exceptions = true

			linux_spy = spy "LinuxWatcher"
			expect(FeatherWatch::Core::LinuxWatcher).to receive(:new).with([path],callback,verbose,silence_exceptions) {linux_spy}
			expect(linux_spy).to receive(:stop)
			FeatherWatch::Watcher.new(path,callback,verbose,silence_exceptions).stop
		end
		it "calls stop on a WindowsWatcher on windows" do
			allow(Kernel).to receive(:require).with('wdm')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {true}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = Dir.pwd
			callback = lambda { |e|  }
			verbose = false
			silence_exceptions = true

			windows_spy = spy "WindowsWatcher"
			expect(FeatherWatch::Core::WindowsWatcher).to receive(:new).with([path],callback,verbose,silence_exceptions) {windows_spy}
			expect(windows_spy).to receive(:stop)
			FeatherWatch::Watcher.new(path,callback,verbose,silence_exceptions).stop
		end

		it "raises error when directory does not exist" do
			expect{FeatherWatch::Watcher.new("this is not a valid path",callback,verbose)}.to raise_error
		end

	end
end
