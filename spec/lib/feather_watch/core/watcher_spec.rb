# encoding: UTF-8
require 'spec_helper'


describe FeatherWatch::Watcher do
	describe ".initialize" do
		it "does not crash" do
			expect{FeatherWatch::Watcher.new("/",lambda { |e|  })}.to_not raise_error
			expect{FeatherWatch::Watcher.new("/",lambda { |e|  }, false)}.to_not raise_error
		end
		it "calls DarwinWatcher.new on darwin" do
			allow(Kernel).to receive(:require).with('rb-fsevent')
			allow(FeatherWatch::OS).to receive(:mac?)      {true}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = "/"
			callback = lambda { |e|  }
			verbose = false

			expect(FeatherWatch::Core::DarwinWatcher).to receive(:new).with([path],callback,verbose)
			
			FeatherWatch::Watcher.new(path,callback,verbose)
		end
		it "calls LinuxWatcher.new on linux" do
			allow(Kernel).to receive(:require).with('rb-inotify')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {true}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = "/"
			callback = lambda { |e|  }
			verbose = false

			expect(FeatherWatch::Core::LinuxWatcher).to receive(:new).with([path],callback,verbose)
			
			FeatherWatch::Watcher.new(path,callback,verbose)
		end
		it "calls WindowsWatcher.new on windows" do
			allow(Kernel).to receive(:require).with('wdm')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {true}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = "/"
			callback = lambda { |e|  }
			verbose = false

			expect(FeatherWatch::Core::WindowsWatcher).to receive(:new).with([path],callback,verbose)
			
			FeatherWatch::Watcher.new(path,callback,verbose)
		end
	end

	describe ".start" do
		it "calls start on a DarwinWatcher on darwin" do
			allow(Kernel).to receive(:require).with('rb-fsevent')
			allow(FeatherWatch::OS).to receive(:mac?)      {true}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = "/"
			callback = lambda { |e|  }
			verbose = false

			darwin_spy = spy "DarwinWatcher"
			expect(FeatherWatch::Core::DarwinWatcher).to receive(:new).with([path],callback,verbose) {darwin_spy}
			expect(darwin_spy).to receive(:start)
			FeatherWatch::Watcher.new(path,callback,verbose).start
		end
		it "calls start on a LinuxWatcher on linux" do
			allow(Kernel).to receive(:require).with('rb-inotify')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {true}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = "/"
			callback = lambda { |e|  }
			verbose = false

			linux_spy = spy "LinuxWatcher"
			expect(FeatherWatch::Core::LinuxWatcher).to receive(:new).with([path],callback,verbose) {linux_spy}
			expect(linux_spy).to receive(:start)
			FeatherWatch::Watcher.new(path,callback,verbose).start
		end
		it "calls start on a WindowsWatcher on windows" do
			allow(Kernel).to receive(:require).with('wdm')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {true}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = "/"
			callback = lambda { |e|  }
			verbose = false

			windows_spy = spy "WindowsWatcher"
			expect(FeatherWatch::Core::WindowsWatcher).to receive(:new).with([path],callback,verbose) {windows_spy}
			expect(windows_spy).to receive(:start)
			FeatherWatch::Watcher.new(path,callback,verbose).start
		end
	end

	describe ".stop" do
		it "calls stop on a DarwinWatcher on darwin" do
			allow(Kernel).to receive(:require).with('rb-fsevent')
			allow(FeatherWatch::OS).to receive(:mac?)      {true}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = "/"
			callback = lambda { |e|  }
			verbose = false

			darwin_spy = spy "DarwinWatcher"
			expect(FeatherWatch::Core::DarwinWatcher).to receive(:new).with([path],callback,verbose) {darwin_spy}
			expect(darwin_spy).to receive(:stop)
			FeatherWatch::Watcher.new(path,callback,verbose).stop
		end
		it "calls stop on a LinuxWatcher on linux" do
			allow(Kernel).to receive(:require).with('rb-inotify')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {true}
			allow(FeatherWatch::OS).to receive(:windows?)  {false}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = "/"
			callback = lambda { |e|  }
			verbose = false

			linux_spy = spy "LinuxWatcher"
			expect(FeatherWatch::Core::LinuxWatcher).to receive(:new).with([path],callback,verbose) {linux_spy}
			expect(linux_spy).to receive(:stop)
			FeatherWatch::Watcher.new(path,callback,verbose).stop
		end
		it "calls stop on a WindowsWatcher on windows" do
			allow(Kernel).to receive(:require).with('wdm')
			allow(FeatherWatch::OS).to receive(:mac?)      {false}
			allow(FeatherWatch::OS).to receive(:linux?)    {false}
			allow(FeatherWatch::OS).to receive(:windows?)  {true}
			allow(FeatherWatch::OS).to receive(:unix?)     {false}
			
			path = "/"
			callback = lambda { |e|  }
			verbose = false

			windows_spy = spy "WindowsWatcher"
			expect(FeatherWatch::Core::WindowsWatcher).to receive(:new).with([path],callback,verbose) {windows_spy}
			expect(windows_spy).to receive(:stop)
			FeatherWatch::Watcher.new(path,callback,verbose).stop
		end
	end
end

describe FeatherWatch do
	before(:each) do
		FileUtils.mkdir(File.join(Dir.pwd, "test_folder"))
	end
	after(:each) do
		FileUtils.rm_rf(File.join(Dir.pwd, "test_folder"))
	end
	#These tests are platform dependent and should be run once on windows, darwin, and linux
	#This test is also prone to sporadic failures.
	it "returns correct file path and status when file is added" do
		path = File.join(Dir.pwd, "test_folder")
		callback_spy = spy("Callback Spy")
		verbose = false
		
		file_path = File.join(Dir.pwd, "test_folder", "new_file")

		if FeatherWatch::OS.mac?
			expect(callback_spy).to receive(:call).with({status: :modified ,file: file_path})
		else
			expect(callback_spy).to receive(:call).with({status: :added ,file: file_path}) 
		end

		watcher = FeatherWatch::Watcher.new(path,callback_spy,verbose)
		watcher.start
		sleep 0.1 #need to wait for watcher to properly start
		FileUtils.touch(file_path)
		sleep 0.1 #need to wait for file event to propegate.
		watcher.stop
	end

	it "returns correct file path and status when file is removed" do
		path = File.join(Dir.pwd, "test_folder")
		callback_spy = spy("Callback Spy")
		verbose = false
		
		file_path = File.join(Dir.pwd, "test_folder", "new_file")
		FileUtils.touch(file_path)
		sleep 0.1 
		expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path})

		watcher = FeatherWatch::Watcher.new(path,callback_spy,verbose)
		watcher.start
		sleep 0.1 #need to wait for watcher to properly start
		FileUtils.rm(file_path)
		sleep 0.1 #need to wait for file event to propegate.
		watcher.stop
	end

	it "returns correct file path and status when file is moved" do
		path = File.join(Dir.pwd, "test_folder")
		callback_spy = spy("Callback Spy")
		verbose = false
		
		file_path = File.join(Dir.pwd, "test_folder", "new_file")
		file_path_new = File.join(Dir.pwd, "test_folder", "new_file_new")

		FileUtils.touch(file_path)
		sleep 0.1 
		
		expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path})
		if FeatherWatch::OS.mac?
			expect(callback_spy).to receive(:call).with({status: :modified ,file: file_path_new})
		else
			expect(callback_spy).to receive(:call).with({status: :added ,file: file_path_new}) 
		end

		watcher = FeatherWatch::Watcher.new(path,callback_spy,verbose)
		watcher.start
		sleep 0.1 #need to wait for watcher to properly start
		FileUtils.mv(file_path, file_path_new)
		sleep 0.1 #need to wait for file event to propegate.
		watcher.stop
	end
end

