def run_tests(browser, app_host, report_file)
  system("browserName=\"#{browser}\" app_host=\"#{app_host}\" bundle exec parallel_split_test spec -f html -o \"#{report_file}\"")
  fail "rspec spec failed with exit code #{$?.exitstatus}" if ($?.exitstatus != 0)
end

task :chrome_prod do
  run_tests('chrome', 'https://credit-test.herokuapp.com/', 'chrome_results.html')
end

task :firefox_prod do
  run_tests('firefox', 'https://credit-test.herokuapp.com/', 'firefox_results.html')
end

multitask :test_cross_browser_prod => [
    :chrome_prod,
    :firefox_prod
]

#similarly create tasks for lower level envs