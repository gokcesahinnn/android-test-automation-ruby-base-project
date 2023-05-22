module Loggers

  # Prints log on STDOUT. Also saves it as Allure report. Use it to log Infos.
  # @param log (string): The message to be printed out.
  def self.log_info(log)
    Logger.new(STDOUT).info(log)
    Allure.add_attachment(name: 'Info Log', source: log, type: Allure::ContentType::TXT, test_case: false)
  end

  # Prints log on STDOUT. Also saves it as Allure report. Use it to log Errors.
  # @param log (string): The message to be printed out.
  def self.log_error(log)
    Logger.new(STDOUT).error(log)
    Allure.add_attachment(name: 'Error Log', source: log, type: Allure::ContentType::TXT, test_case: false)
  end

  # Prints log on STDOUT. Also saves it as Allure report. Use it to log Debugs.
  # @param log (string): The message to be printed out.
  def self.log_debug(log)
    Logger.new(STDOUT).debug(log)
    Allure.add_attachment(name: 'Debug Log', source: log, type: Allure::ContentType::TXT, test_case: false)
  end

  #Takes screenshot and attaches the image to Allure report.
  # @param file_name (string): Name of the image file.
  def self.take_screenshot(file_name)
    time = Time.new
    time_day = time.strftime('%Y-%m-%d')
    time_hours = time.strftime('%H-%M-%S')
    file_path = "output/screenshots-#{time_day}"
    FileUtils.mkdir_p(file_path) unless File.directory?(file_path)
    screenshot_name = "#{file_path}/#{file_name.gsub(" ", '_')}-#{time_hours}.png"
    screenshot(screenshot_name)
    Allure.add_attachment(name: 'Screenshot', source: screenshot(screenshot_name.to_s), type: Allure::ContentType::PNG,
                          test_case: true)
  end
end