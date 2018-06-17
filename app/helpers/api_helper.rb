module ApiHelper
  def request(url, _method='get', request_data={}, content_type=nil, auth={})
    uri = URI.parse url
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    if _method == 'get'
      url += url.index('?') ? '&' : '?'
      url += request_data.to_query
      request = Net::HTTP::Get.new(url)
    else
      if ['patch', 'put'].include?(_method.downcase)
        request_data[:_method] = _method
      end
      _method = 'post'
      request = Net::HTTP::Post.new(url)
    end
    if content_type
      request.add_field('Content-Type', content_type)
    end
    if auth[:username]
      request.basic_auth(auth[:username], auth[:password])
    end
    request.body = _method == 'post' ? request_data.to_json : nil
    begin
      if ENV['RAILS_ENV'] == 'test'
        body = '{}'
      else
        body = http.request(request).body
      end
      data = JSON.parse(body)
    rescue Exception => e
      data = {message: body ? body : 'connection error'} 
    end
    return data.with_indifferent_access
  end
end
