require 'spec_helper'

class FSEvent
end

describe FeatherWatch::Core::DarwinWatcher do
	after(:each) do
		FileUtils.rm_rf(File.join(Dir.pwd, "test_folder"))
	end
	describe ".initialize" do
		it "catches exceptions in user callback and print to STDERR" do
			fse_spy = spy("FSEvent spy")
			expect(FSEvent).to receive(:new).and_return(fse_spy)
			
			path = File.join(Dir.pwd, "test_folder")
			file_path = File.join(Dir.pwd, "test_folder", "new_file")
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(fse_spy).to receive(:watch) do |watch_paths, options=nil, &block|
				the_callback = block
				expect(watch_paths).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path, event: anything}).and_raise("some error")
			expect(STDERR).to receive(:puts).exactly(4).times.with(kind_of(String))


			watcher = FeatherWatch::Core::DarwinWatcher.new(path,callback_spy,verbose)
			watcher.start
			
			expect{the_callback.call([file_path])}.to_not raise_error

			watcher.stop
		end
		it "executes callback with :removed if file does not exist" do
			fse_spy = spy("FSEvent spy")
			expect(FSEvent).to receive(:new).and_return(fse_spy)
			
			path = File.join(Dir.pwd, "test_folder")
			file_path = File.join(Dir.pwd, "test_folder", "new_file")
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(fse_spy).to receive(:watch) do |watch_paths, options=nil, &block|
				the_callback = block
				expect(watch_paths).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)


			watcher = FeatherWatch::Core::DarwinWatcher.new(path,callback_spy,verbose)
			watcher.start
			
			expect{the_callback.call([file_path])}.to_not raise_error

			watcher.stop
		end

		it "executes callback with :modified if file exist" do
			fse_spy = spy("FSEvent spy")
			expect(FSEvent).to receive(:new).and_return(fse_spy)
			
			path = File.join(Dir.pwd, "test_folder")
			file_path = File.join(Dir.pwd, "test_folder", "new_file")
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(fse_spy).to receive(:watch) do |watch_paths, options=nil, &block|
				the_callback = block
				expect(watch_paths).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :modified ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			FileUtils.mkdir(path)
			FileUtils.touch(file_path)
			sleep 0.1

			watcher = FeatherWatch::Core::DarwinWatcher.new(path,callback_spy,verbose)
			watcher.start
			
			expect{the_callback.call([file_path])}.to_not raise_error

			watcher.stop
		end
	end

end
