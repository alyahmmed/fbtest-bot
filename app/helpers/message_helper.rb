module MessageHelper
  def self.handle(user_id, message)
    user = User.get_user(user_id)
    # set default locale
    I18n.locale = user.lang

    # handle last session
    SessionHelper.handle(user, message)
  end

  def self.welcome(user)
    # send welcome once in this session
    if user.send_hello
      send_message(user.fbid, I18n.t('welcome', first_name: user.fname))
      user.send_hello = false
      user.save
    end
    # ask user to search by keyword or id
    send_question(user.fbid, I18n.t('search_by_question'), [
      I18n.t('search_by_keyword'),
      I18n.t('search_by_id'),
    ])
    # start search_request session
    SessionHelper.update_session(user, 'search_request')
  end

  def self.please_wait(user)
    MessageHelper.send_message(user.fbid, I18n.t('please_wait'))
  end

  def self.send_question(user_id, question, answers)
    buttons = []
    answers.each do |answer|
      buttons.push({"type" => "postback", "payload" => answer, "title" => answer})
    end
    send_message_with_buttons(user_id, question, buttons)
  end

  def self.send_message_with_buttons(user_id, text, buttons)
    msg_params = {
      "recipient" => {"id" => user_id},
      "message" => {
        "attachment" => {"type" => "template", "payload" => {
          "template_type" => "button",
          "text" => text,
          "buttons" => buttons,
        }}
      }
    }
    FbHelper.request_api('/me/messages', 'post', msg_params)
  end

  def self.send_message(user_id, text)
    FbHelper.request_api('/me/messages', 'post', {
      "recipient" => {"id" => user_id},
      "message" => {"text" => text}
    })
  end
end
