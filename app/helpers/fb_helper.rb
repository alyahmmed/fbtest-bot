# Facebook API wrapper
module FbHelper
  extend ApiHelper

  def self.request_api(url, _method='get', request_data={})
    token = URI.parse Rails.application.secrets.fb_token
    url = "#{Rails.application.secrets.fb_url}#{url}?access_token=#{token}"
    results = request(url, _method, request_data, 'application/json')
    if results[:error]
      p 'FB Helper - debug: ', results[:error][:message]
    end
    return results
  end
end
