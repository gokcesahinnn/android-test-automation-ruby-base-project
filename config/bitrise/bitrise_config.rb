module BitriseConfig

  @bitrise_token = "dfnk7zmxKhgYUIuW2kSD_1FCUsVnkUbFh0dnv1iI6sDBZsebx1LZ_jT8EQtwp_YZj0ys-CKLx3wddyBZpljZEA"
  def self.bitrise_token
    @bitrise_token
  end

  @bitrise_url = "https://api.bitrise.io/v0.1"
  def self.bitrise_url
    @bitrise_url
  end

  case @environment = BaseConfig.environment
  when 'beta'
    @bitrise_project_url = 'beta-'
  when 'prod'
    @bitrise_project_url = 'prod-'
  end

  @bitrise_workflow_url = "#{@bitrise_project_url}deploy-to-bitrise"
  def self.bitrise_workflow_url
    @bitrise_workflow_url
  end
end