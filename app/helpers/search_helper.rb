module SearchHelper
  extend ApplicationHelper

  def self.search_request(user, message)
    session = SessionHelper.get_session(user)
    if str_equals?(message, I18n.t('search_by_keyword'))
      MessageHelper.send_message(user.fbid, I18n.t('type_keyword'))
      SessionHelper.update_session(user, 'search_request', {search_type: 'keyword'})
    else
      if str_equals?(message, I18n.t('search_by_id'))
        MessageHelper.send_message(user.fbid, I18n.t('type_book_id'))
        SessionHelper.update_session(user, 'search_request', {search_type: 'id'})
      else
        if session[:data] && session[:data][:search_type]
          search_type = session[:data][:search_type]
          case search_type
          when 'keyword'
            if session[:data][:keyword]
              book_review(user, message)
            else
              book_search(user, message)
            end
          when 'id'
            book_review(user, message)
          end
        else
          MessageHelper.send_question(user.fbid, I18n.t('search_by_question'), [
            I18n.t('search_by_keyword'),
            I18n.t('search_by_id'),
          ])
        end
      end
    end
  end

  def self.book_search(user, message)
    MessageHelper.send_message(user.fbid, I18n.t('searching_for',
      type: 'keyword', query: message))
    MessageHelper.please_wait(user)
    search = GrHelper.book_search message
    if search
      buttons = []
      search[0..4].each_with_index do |book, i|
        title = "#{book[:best_book][:title]}"
        title += " - by #{book[:best_book][:author][:name]}"
        MessageHelper.send_message(user.fbid, "#{(i+1)}: #{title}")
        buttons.push({
          "type" => "postback",
          "title" => title,
          "payload" => book[:best_book][:id],
        })
      end
      text = I18n.t('please_select_book')
      if buttons.length > 3
        # workaround fb payload buttons limit: 3
        MessageHelper.send_message_with_buttons(user.fbid, text, buttons[0..2])
        MessageHelper.send_message_with_buttons(user.fbid, '⁣', buttons[3..4])
      else
        MessageHelper.send_message_with_buttons(user.fbid, text, buttons)
      end
      SessionHelper.update_session(user, 'search_request',
        {search_type: 'keyword', keyword: message})
    else
      MessageHelper.send_message(user.fbid, I18n.t('no_results'))
    end
  end

  def self.book_review(user, message)
    book_id = message.to_i
    if book_id > 0
      MessageHelper.please_wait(user)
      # get goodreads reviews
      reviews = GrHelper.book_reviews(book_id)
      if reviews
        MessageHelper.send_message(user.fbid, I18n.t('getting_book'))
        # get watson analysis
        analyze = IbmHelper.analyze_text(reviews.join('. '))
        if analyze
          if analyze == "positive"
            MessageHelper.send_message(user.fbid, I18n.t('positive_analysis'))
          else
            MessageHelper.send_message(user.fbid, I18n.t('negative_analysis'))
          end
        else
          MessageHelper.send_message(user.fbid, I18n.t('analysis_failed'))
        end
        # reset session after book_review
        SessionHelper.update_session(user, 'welcome')
      else
        MessageHelper.send_message(user.fbid, I18n.t('enter_valid_id'))
      end
    else
      MessageHelper.send_message(user.fbid, I18n.t('enter_valid_id'))
    end
  end
end
