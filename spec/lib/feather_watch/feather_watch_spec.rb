describe FeatherWatch do
	before(:each) do
		FileUtils.mkdir(File.join(Dir.pwd, "test_folder"))
	end
	after(:each) do
		FileUtils.rm_rf(File.join(Dir.pwd, "test_folder"))
	end

	it "passen self.new on to FeatherWatch::Watcher" do
		args = ["/",lambda { |e|  }, false]
		expect(FeatherWatch::Watcher).to receive(:new).with(*args)
		FeatherWatch.new(*args)
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

