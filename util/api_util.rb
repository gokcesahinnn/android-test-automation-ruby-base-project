class ApiUtil

  def self.get_request(uri, path, header)
     HTTParty.get(uri + path, headers: header).parsed_response
  end

  def self.get_request_with_query(uri, path, query, header)
      HTTParty.get(uri + path, query: query, headers: header).parsed_response
  end

  def self.post_request(uri, path, body, header)
    HTTParty.post(uri + path, body: body.to_json, headers: header).parsed_response
  end

  def self.post_request_multipart(base_uri, body, header)
      HTTParty.post(base_uri, multipart: true, body: body, headers: header, timeout: 120).parsed_response
  end

  def self.put_request(uri, path, body, header)
    HTTParty.put(uri + path,
                 body: body.to_json,
                 headers: header)
  end

  def self.delete_request(uri, path, header)
    HTTParty.delete(uri + path, header)
  end
end

