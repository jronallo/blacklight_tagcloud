def notify(message)
  notify_send = `which notify-send`.chomp
  title = "Tagcloud Test Results"
  image = message.include?('0 failures') ? '~/.autotest_images/pass.png' : '~/.autotest_images/fail.png'
  msg = message.slice(/(\d+)\sexamples,\s(\d+)\sfailures/)
  cmd = %Q{#{notify_send} '#{title}' '#{msg}' -i #{image} -t 2000 &}
  #puts msg, image, cmd
  system cmd
end


def run_all_tests
  system('clear')
  result = `spec spec`
  puts result
  notify result.split("\n").last rescue nil
end

watch('spec/.*/.*\.rb') { run_all_tests }
watch('lib/.*\.rb') { run_all_tests }
watch('lib/.*/.*\.rb') { run_all_tests }

Signal.trap('QUIT') { run_all_tests  } # Ctrl-\

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    # raise Interrupt, nil # let the run loop catch it
    run_all_tests
  end
end

