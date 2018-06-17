module IbmHelper
  extend ApiHelper

  def self.analyze_text(text)
    url = "https://gateway.watsonplatform.net/natural-language-understanding/api"
    analyze_url = "#{url}/v1/analyze?version=2017-02-27"
    request_data = {text: text, features: {sentiment: {}, keywords: {}}}
    auth = {
      username: Rails.application.secrets.ibm_user,
      password: Rails.application.secrets.ibm_pass,
    }
    res = request(analyze_url, 'post', request_data, 'application/json', auth)
    if ! res[:error]
      res[:sentiment] ? res[:sentiment][:document][:label] : nil
    end
  end
end
