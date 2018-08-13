module WaitForPageLoad

  def wait_until
    Timeout.timeout(10) do
      sleep(2) until value = yield
      value
    end
  end

  def wait_for(seconds)
    Selenium::WebDriver::Wait.new(timeout: seconds).until { yield }
  end

end