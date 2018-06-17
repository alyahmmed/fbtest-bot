module SessionHelper
  def self.handle(user, message)
    session = get_session(user)
    # check running session
    case session[:name]
    when 'welcome'
      MessageHelper.welcome(user)
    when 'search_request'
      SearchHelper.search_request(user, message)
    when 'search_loading'
      SearchHelper.search_loading(user, message)
    end
  end

  def self.get_session(user)
    begin
      session = JSON.parse(user.session.gsub('=>',':')).with_indifferent_access
    rescue Exception => e
      # default session
      session = update_session(user)
    end
    # check if session is valid
    if session[:expire].to_time > Time.now
      return session
    else
      return update_session(user)
    end
  end

  def self.update_session(user, session_name='welcome', data={})
    # default session
    if session_name == 'welcome'
      user.send_hello = true
    end
    session = {name: session_name, expire: (Time.now + 2.hours).to_s, data: data}
    user.session = session.to_json
    user.save
    return session.with_indifferent_access
  end
end
