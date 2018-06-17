require 'net/http'

class WelcomeController < ActionController::Base
  def index
    if params["hub.mode"] == "subscribe" && params["hub.challenge"]
      if params["hub.verify_token"] != ENV["VERIFY_TOKEN"]
        render :inline => "token#mismatch"
      else
        render :inline => params["hub.challenge"]
      end
      return
    end

    if params["entry"]
      params["entry"].each do |entry|
        entry["messaging"].each do |m|
          user_id = m["sender"]["id"]
          # check for postback message
          message = m["postback"] ? m["postback"]["payload"] : nil
          # check for text message
          message ||= m["message"] ? m["message"]["text"] : nil
          # handle received messag
          begin
            MessageHelper.handle(user_id, message) if message
          rescue Exception => e
            p 'MessageHandler - error: ', e.message, e.backtrace
          end
        end
      end
    end

    render :inline => 'welcome#index'
  end
end
