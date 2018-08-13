module WaitForAjax

  def wait_for_ajax
    counter = 0
    while page.execute_script("return $.active").to_i > 0
      counter += 1
      sleep(0.1)
      raise "AJAX request took longer than 5 seconds." if counter >= 50
    end
  end

  def finished_all_ajax_requests?
    puts '++++++++++++++++++++++++++++++++'
    puts page.evaluate_script('jQuery.active')
    page.evaluate_script('jQuery.active') == 0

  end
end