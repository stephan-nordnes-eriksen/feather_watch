require 'spec_helper'

class WDM

end
class WDM::Monitor
end

describe FeatherWatch::Core::WindowsWatcher do
	
	let(:path)       {File.join(Dir.pwd, "test_folder")}
	let(:file_path)  {File.join(Dir.pwd, "test_folder", "new_file")}

	after(:each) do
		FileUtils.rm_rf(File.join(Dir.pwd, "test_folder"))
	end
	describe ".initialize" do
		it "catches exceptions in user callback and print to STDERR" do
			wdm_spy = spy("wdm spy")
			expect(WDM::Monitor).to receive(:new).and_return(wdm_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = false

			the_callback = nil
			expect(wdm_spy).to receive(:watch_recursively) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path, event: anything}).and_raise("some error")
			expect(STDERR).to receive(:puts).exactly(4).times.with(kind_of(String))


			watcher = FeatherWatch::Core::WindowsWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:type).and_return(:removed)
			allow(event_spy).to receive(:path).and_return(file_path)
			expect{the_callback.call(event_spy)}.to_not raise_error

			watcher.stop
		end
		it "executes callback with :removed if file does not exist" do
			wdm_spy = spy("wdm spy")
			expect(WDM::Monitor).to receive(:new).and_return(wdm_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(wdm_spy).to receive(:watch_recursively) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)


			watcher = FeatherWatch::Core::WindowsWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:type).and_return(:removed)
			allow(event_spy).to receive(:path).and_return(file_path)
			expect{the_callback.call(event_spy)}.to_not raise_error

			watcher.stop
		end

		it "executes callback with :modified if file exist" do
			wdm_spy = spy("wdm spy")
			expect(WDM::Monitor).to receive(:new).and_return(wdm_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(wdm_spy).to receive(:watch_recursively) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :added ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::WindowsWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:type).and_return(:added)
			allow(event_spy).to receive(:path).and_return(file_path)
			expect{the_callback.call(event_spy)}.to_not raise_error

			watcher.stop
		end


		it "wdm-event with :added produces :added FeatherWatch-event" do
			wdm_spy = spy("wdm spy")
			expect(WDM::Monitor).to receive(:new).and_return(wdm_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(wdm_spy).to receive(:watch_recursively) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :added ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::WindowsWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:type).and_return(:added)
			allow(event_spy).to receive(:path).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end
		it "wdm-event with :renamed_new_file produces :added FeatherWatch-event" do
			wdm_spy = spy("wdm spy")
			expect(WDM::Monitor).to receive(:new).and_return(wdm_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(wdm_spy).to receive(:watch_recursively) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :added ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::WindowsWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:type).and_return(:renamed_new_file)
			allow(event_spy).to receive(:path).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end

		it "wdm-event with :removed produces :removed FeatherWatch-event" do
			wdm_spy = spy("wdm spy")
			expect(WDM::Monitor).to receive(:new).and_return(wdm_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(wdm_spy).to receive(:watch_recursively) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::WindowsWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:type).and_return(:removed)
			allow(event_spy).to receive(:path).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end
		

		it "wdm-event with :renamed_old_file produces :removed FeatherWatch-event" do
			wdm_spy = spy("wdm spy")
			expect(WDM::Monitor).to receive(:new).and_return(wdm_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(wdm_spy).to receive(:watch_recursively) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :removed ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::WindowsWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:type).and_return(:renamed_old_file)
			allow(event_spy).to receive(:path).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end

		it "wdm-event with :modified produces :modified FeatherWatch-event" do
			wdm_spy = spy("wdm spy")
			expect(WDM::Monitor).to receive(:new).and_return(wdm_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(wdm_spy).to receive(:watch_recursively) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :modified ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::WindowsWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:type).and_return(:modified)
			allow(event_spy).to receive(:path).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end

		it "wdm-event with :attrib produces :modified FeatherWatch-event" do
			wdm_spy = spy("wdm spy")
			expect(WDM::Monitor).to receive(:new).and_return(wdm_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(wdm_spy).to receive(:watch_recursively) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to receive(:call).with({status: :modified ,file: file_path, event: anything})
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::WindowsWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:type).and_return(:attrib)
			allow(event_spy).to receive(:path).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end


		it "Prints error to STDERR when type is nil and verbose" do
			wdm_spy = spy("wdm spy")
			expect(WDM::Monitor).to receive(:new).and_return(wdm_spy)
			allow(STDOUT).to receive(:puts)

			callback_spy = spy("Callback Spy")
			verbose = true
			silence_exceptions = true

			the_callback = nil
			expect(wdm_spy).to receive(:watch_recursively) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to_not receive(:call)
			expect(STDERR).to receive(:puts).exactly(1).times.with(kind_of(String))
			
			watcher = FeatherWatch::Core::WindowsWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:type).and_return(nil)
			allow(event_spy).to receive(:path).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end
		it "Does not print to STDERR when type is nil and not verbose" do
			wdm_spy = spy("wdm spy")
			expect(WDM::Monitor).to receive(:new).and_return(wdm_spy)
			
			callback_spy = spy("Callback Spy")
			verbose = false
			silence_exceptions = true

			the_callback = nil
			expect(wdm_spy).to receive(:watch_recursively) do |watch_path, *flags, &callback|
				the_callback = callback
				expect(watch_path).to eq(path)
			end


			expect(callback_spy).to_not receive(:call)
			expect(STDERR).to_not receive(:puts)
			
			watcher = FeatherWatch::Core::WindowsWatcher.new(path,callback_spy,verbose, silence_exceptions)
			watcher.start
			
			event_spy = spy("Event spy")
			allow(event_spy).to receive(:type).and_return(nil)
			allow(event_spy).to receive(:path).and_return(file_path)
			the_callback.call(event_spy)

			watcher.stop
		end
	end

end
