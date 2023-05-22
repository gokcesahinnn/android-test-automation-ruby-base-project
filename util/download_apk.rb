class DownloadApk
  require_relative 'api_util'

  @bitrise_header = { 'Content-Type' => 'application/json', "Authorization" => BitriseConfig.bitrise_token }

  def self.get_app_slug
    response = ApiUtil.get_request(BitriseConfig.bitrise_url, "/apps", @bitrise_header)
    $app_slug = response["data"][1]["slug"]
  end

  def self.get_build_info_with_build_number(build_number)
    query = {
      workflow: "#{BitriseConfig.bitrise_workflow_url}",
      status: "1",
      build_number: "#{build_number}",
      limit: "10" }
    response = ApiUtil.get_request_with_query(BitriseConfig.bitrise_url, "/apps/#{$app_slug}/builds",
                                              query,
                                              @bitrise_header)
    $builds_info = []
    if $build_number.nil?
      response['data'].each { |item| $builds_info << { build_slug: item['slug'], build_number: item['build_number'] } }
    else
      response['data'].each { |item| $builds_info << { build_slug: item['slug'], build_number: item['build_number'] } if item['build_number'] == build_number.to_i }
    end
  end

  def self.get_builds_artifacts_slug
    if BaseConfig.environment == "prod"
      response_prod = ApiUtil.get_request("https://play.google.com", "/store/apps/details?id=net.igapi.android.istegelsin&hl=en&gl=US", { 'Content-Type' => 'application/json' })
      page = Nokogiri::HTML(response_prod)
      script = page.xpath("//script[contains(text(),'/store/apps/developer')]").text
      prod_version = script.match(/\[\[\[("\d{4}")\]\]/)[0].match(/\b\d{4}\b/).to_s
    end
    i = 0
    while i < $builds_info.size
      response = ApiUtil.get_request(BitriseConfig.bitrise_url, "/apps/#{$app_slug}/builds/#{$builds_info[i][:build_slug]}",
                                     @bitrise_header)
      if BaseConfig.environment == "prod"
        if response["data"]["build_number"].to_s != prod_version
          i += 1
        else
          $version = prod_version
          break
        end
      else
        $version = response["data"]["build_number"]
        break
      end
    end
    response = ApiUtil.get_request(BitriseConfig.bitrise_url, "/apps/#{$app_slug}/builds/#{$builds_info[i][:build_slug]}/artifacts",
                                   @bitrise_header)
    $artifact_slug = response["data"][0]["slug"]
    $build_number = $builds_info[i][:build_number]
    $build_slug = $builds_info[i][:build_slug]
  end

  def self.get_app_info
    response = ApiUtil.get_request(BitriseConfig.bitrise_url, "/apps/#{$app_slug}/builds/#{$build_slug}/artifacts/#{$artifact_slug}",
                                   @bitrise_header)
    if BaseConfig.environment == "prod"
      version_code = response["data"]["artifact_meta"]["app_info"]["version_code"]
      $app_name = response["data"]["artifact_meta"]["app_info"]["app_name"].to_s.downcase + "-v#{$version}-#{version_code}.apk"
    else
      $app_name = response["data"]["title"]
    end
    $apk_url = response["data"]["expiring_download_url"]
    $version = response["data"]["artifact_meta"]["app_info"]["version_name"]
  end

  def self.download_apk_from_bitrise
    IO.copy_stream(URI.open($apk_url), "apps/#{$app_name}")
  end

  def self.get_version_of_app(build_number = "")
    get_app_slug
    get_build_info_with_build_number(build_number)
    get_builds_artifacts_slug
    get_app_info
  end

  def self.download_apk
    $build_number = BaseConfig.build_no_of_release_version
    $version = $build_number.nil? ? get_version_of_app : get_version_of_app($build_number)
    file_name = Dir.children("apps/").to_s
    if file_name.match?($app_name.to_s)
      Loggers.log_info("This version is already downloaded")
    else
      Dir.each_child("apps/") do |file|
        fn = File.join("apps/", file)
        File.delete(fn)
      end
      download_apk_from_bitrise
    end
  end
end