require 'spec_helper'

class INotify

end
class INotify::Notifier
end

describe FeatherWatch::Core::LinuxWatcher do
	
	let(:path)       {File.join(Dir.pwd, "test_folder")}
	let(:file_path)  {File.join(Dir.pwd, "test_folder", "new_file")}

	after(:each) do
		FileUtils.rm_rf(File.join(Dir.pwd, "test_folder"))
	end
	describe ".initialize" do
		it "catches exceptions in user callback and print to STDERR" do
			inotify_spy = spy("inotify spy")
			expect(INotify::Notifier).to receive(:new).and_return(inotify_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = false

			the_callback = nil
			expect(inotify_spy).to receive(:watch) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path, event: anything}).and_raise("some error")
			expect(STDERR).to receive(:puts).exactly(4).times.with(kind_of(String))


			watcher = FeatherWatch::Core::LinuxWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:flags).and_return([:delete])
			allow(event_spy).to receive(:absolute_name).and_return(file_path)
			expect{the_callback.call(event_spy)}.to_not raise_error

			watcher.stop
		end
		it "executes callback with :removed if file does not exist" do
			inotify_spy = spy("inotify spy")
			expect(INotify::Notifier).to receive(:new).and_return(inotify_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(inotify_spy).to receive(:watch) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)


			watcher = FeatherWatch::Core::LinuxWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:flags).and_return([:delete])
			allow(event_spy).to receive(:absolute_name).and_return(file_path)
			expect{the_callback.call(event_spy)}.to_not raise_error

			watcher.stop
		end

		it "executes callback with :modified if file exist" do
			inotify_spy = spy("inotify spy")
			expect(INotify::Notifier).to receive(:new).and_return(inotify_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(inotify_spy).to receive(:watch) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :added ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::LinuxWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:flags).and_return([:create])
			allow(event_spy).to receive(:absolute_name).and_return(file_path)
			expect{the_callback.call(event_spy)}.to_not raise_error

			watcher.stop
		end



		it "inotify-event with :attrib produces :modified FeatherWatch-event" do
			inotify_spy = spy("inotify spy")
			expect(INotify::Notifier).to receive(:new).and_return(inotify_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(inotify_spy).to receive(:watch) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :modified ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::LinuxWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:flags).and_return([:attrib])
			allow(event_spy).to receive(:absolute_name).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end
		it "inotify-event with :close_write produces :modified FeatherWatch-event" do
			inotify_spy = spy("inotify spy")
			expect(INotify::Notifier).to receive(:new).and_return(inotify_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(inotify_spy).to receive(:watch) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :modified ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::LinuxWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:flags).and_return([:close_write])
			allow(event_spy).to receive(:absolute_name).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end
		it "inotify-event with :modify produces :modified FeatherWatch-event" do
			inotify_spy = spy("inotify spy")
			expect(INotify::Notifier).to receive(:new).and_return(inotify_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(inotify_spy).to receive(:watch) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :modified ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::LinuxWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:flags).and_return([:modify])
			allow(event_spy).to receive(:absolute_name).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end
		

		it "inotify-event with :moved_to produces :added FeatherWatch-event" do
			inotify_spy = spy("inotify spy")
			expect(INotify::Notifier).to receive(:new).and_return(inotify_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(inotify_spy).to receive(:watch) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :added ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::LinuxWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:flags).and_return([:moved_to])
			allow(event_spy).to receive(:absolute_name).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end

		it "inotify-event with :moved_from produces :removed FeatherWatch-event" do
			inotify_spy = spy("inotify spy")
			expect(INotify::Notifier).to receive(:new).and_return(inotify_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(inotify_spy).to receive(:watch) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::LinuxWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:flags).and_return([:moved_from])
			allow(event_spy).to receive(:absolute_name).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end

		it "inotify-event with :create produces :added FeatherWatch-event" do
			inotify_spy = spy("inotify spy")
			expect(INotify::Notifier).to receive(:new).and_return(inotify_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(inotify_spy).to receive(:watch) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :added ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::LinuxWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:flags).and_return([:create])
			allow(event_spy).to receive(:absolute_name).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end

		it "inotify-event with :delete produces :removed FeatherWatch-event" do
			inotify_spy = spy("inotify spy")
			expect(INotify::Notifier).to receive(:new).and_return(inotify_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(inotify_spy).to receive(:watch) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::LinuxWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:flags).and_return([:delete])
			allow(event_spy).to receive(:absolute_name).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end
		it "inotify-event with :delete_self produces :removed FeatherWatch-event" do
			inotify_spy = spy("inotify spy")
			expect(INotify::Notifier).to receive(:new).and_return(inotify_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(inotify_spy).to receive(:watch) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::LinuxWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:flags).and_return([:delete_self])
			allow(event_spy).to receive(:absolute_name).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end
	end

end
