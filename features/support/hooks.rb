Before do |scenario|
  Loggers.log_info("#{scenario.name} is started")
  GlobalContext.reset_global_context
  driver.start_driver
end

After do |scenario|
  begin
    if scenario.failed?
      Loggers.log_error("FAILED ==> #{scenario.name}\n#{scenario.exception}:#{scenario.exception.message}")
      Loggers.take_screenshot(scenario.name)
    else
      Loggers.log_info("PASSED ==> #{scenario.name}")
    end
  rescue StandardError => e
    driver.driver_quit
  end
  driver.driver_quit
end