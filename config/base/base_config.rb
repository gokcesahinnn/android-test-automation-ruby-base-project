module BaseConfig

  @short_wait_time = 5
  def self.short_wait_time
    @short_wait_time
  end

  @moderate_wait_time = 15
  def self.moderate_wait_time
    @moderate_wait_time
  end

  @wait_time = 25
  def self.wait_time
    @wait_time
  end

  @long_wait_time = 60
  def self.long_wait_time
    @long_wait_time
  end

  @otp_remaining_time = 120
  def self.otp_remaining_time
    @otp_remaining_time
  end

  @device_type = ENV['device_type'] || 'local'
  #     Available options
  #       * local - runs on the local connected device
  #       * cloud_public - runs on the public device cloud environment
  #       * cloud_private - runs on the private device cloud environment
  def self.device_type
    @device_type
  end

  @release_version = ENV['release_version'] || '1442'
  def self.release_version
    @release_version
  end

  @environment = ENV['env'] || 'beta'
  #     Available options
  #       * beta - runs on the beta environment
  #       * prod - runs on the prod environment
  def self.environment
    @environment
  end

  @sms_code = "1414"
  def self.sms_code
    @sms_code
  end

  @build_no_of_release_version = ENV['build_number']
  def self.build_no_of_release_version
    @build_no_of_release_version
  end

  # Available options:
  # * info => Logger::INFO
  # * debug => Logger::DEBUG
  # * error => Logger::ERROR
  @logging_level = Logger::INFO
  def self.logging_level
    @logging_level
  end

  @multi_switch = ENV['multi_switch'] || 'true'
  # Available options:
  # * true => multi features switch on
  # * false => multi features switch off
  def self.multi_switch
    @multi_switch
  end

  def self.app_package_name
    case BaseConfig.environment
    when 'beta'
      @app_package_name = 'com.android.chrome'
    when 'prod'
      @app_package_name = 'com.android.chrome'
    else
      raise "environment is invalid => #{BaseConfig.environment}"
    end
    @app_package_name
  end

end