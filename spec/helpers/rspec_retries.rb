module RSpec::Retries
  COUNT = 1

  def self.setup(config)
    config.include RSpec::Retries

    config.around(:each, type: :feature) do |example|
      if example.metadata[:no_retry] #|| example.file_path =~ /\/spec\/central\//i
        # puts "==> retry setting - 1 times"
        run_with_retries(example, 1)
      else
        # puts "==> retry setting - #{COUNT} times"
        run_with_retries(example, COUNT)
      end
    end
  end

  def run_with_retries(example_to_run, retries)
    retry_header_shown = false
    retries.times do |t|

      example_to_run.example.instance_variable_set(:@exception, nil)

      example_to_run.run

      break unless example_to_run.example.exception

      # if self.example.metadata[:force_quit]
      #   puts "Force quitting~~!!!"
      #   break
      # end


      if example_to_run.example.exception.is_a? Timeout::Error
        puts "[WARNING] ***** !!! timeout error detected !!! *****"
        # page.driver.browser.switch_to.window(handle)
        # page.execute_script "window.close()"
        # Capybara::Session.driver.quit
        ##### self.example.instance_variable_set(:@exception, nil)
        ##### break

        # Capybara.close_browser(session)
        # page.execute_script "window.close();"
        # restart Selenium driver
        # Capybara.send(:session_pool).delete_if { |key, value| key =~ /selenium/i }
      end

      if example_to_run.example.exception.message.to_s.include? "CLIENT_GONE"
        puts "[WARNING] ***** !!! CLIENT_GONE error detected !!! *****"
      end

      info = "#{example_to_run.example.location.gsub(/#{Dir.pwd}\//, '')}: \"#{example_to_run.example.description}\""
      attempt = t + 1
      unless retry_header_shown
        puts "\n\n#{info} failed."
        retry_header_shown = true
      end

      puts "Retrying, attempt #{attempt} of #{retries}.\n"
    end

    if e = example_to_run.example.exception
      puts "Retries failed.\n\n"
      new_exception = e.exception(e.message + " [retried #{retries} times]")
      new_exception.set_backtrace e.backtrace
      example_to_run.example.instance_variable_set(:@exception, new_exception)
    elsif retry_header_shown
      puts "Retry successful.\n\n"
    end
  end
end

