require 'em/pure_ruby'
require 'appium_lib'
require 'rspec'
require 'yaml'
require 'allure-cucumber'
require 'faker'
require 'open-uri'
require 'httparty'
require_relative '../../features/pages/base_page'

Dir["#{Dir.pwd}/config/**/*.rb"].each { |file| require_relative file }
Dir["#{Dir.pwd}/global/*.rb"].each { |file| require_relative file }
Dir["#{Dir.pwd}/util/**/*.rb"].each { |file| require_relative file }
Dir["#{Dir.pwd}/resources/**/*.rb"].each { |file| require_relative file }
Dir["#{Dir.pwd}/model/**/*.rb"].each { |file| require_relative file }
Dir["#{Dir.pwd}/context/**/*.rb"].each { |file| require_relative file }

# Gets the version info related to the last successful build from Bitrise and downloads it.
DownloadApk.download_apk

case BaseConfig.device_type
when 'local'
  $CAPS = YAML.load_file(File.expand_path("./config/device/device_config.yml"))
  `adb install -r "#{Dir.pwd}/apps/#{$app_name}"`
  device = `adb devices -l`.strip.split("attached")[1]
  $CAPS['caps']['udid'] = device.split(" ")[0]
  $CAPS['caps']['platformVersion'] = `adb shell getprop ro.build.version.release`.strip
  $CAPS['caps']['app'] = "#{Dir.pwd}/apps/#{$app_name}"
  $CAPS['caps']['appPackage'] = BaseConfig.app_package_name
else
  $CAPS =YAML.load_file(File.expand_path("./config/experitest/experitest_config.yml"))
  $CAPS['caps']['accessKey'] = ExperitestConfig.experitest_access_key
  $CAPS['appium_lib']['server_url'] = "#{ExperitestConfig.experitest_url}/wd/hub"
  $CAPS['caps']['release_version'] = BaseConfig.release_version
end

begin
  Appium::Driver.new($CAPS, true)
  Appium.promote_appium_methods Object
rescue Exception => e
  puts e.message
  Process.exit(0)
end

AllureCucumber.configure do |c|
  c.issue_prefix = 'JIRA:'
end

Allure.configure do |c|
  c.results_directory = 'output/allure-results'
  c.clean_results_directory = true
  c.link_issue_pattern = 'https://istegelsin.atlassian.net/browse/{}'
  c.logging_level = BaseConfig.logging_level
  c.logger = Logger.new(STDOUT, c.logging_level)
  c.environment_properties = {
    env: "#{BaseConfig.environment}",
    release_version: "#{BaseConfig.release_version}",
  }
end

$wait = Selenium::WebDriver::Wait.new timeout: 60
Selenium::WebDriver.logger.level = :error