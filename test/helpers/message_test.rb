require 'test_helper'
 
class MessageTest < ActiveSupport::TestCase
  test "handle welcome message" do
    FbHelper.expects(:request_api).with(){|url| url}.
      returns({"id" => 123, "locale" => 'en'}).at_least_once
    MessageHelper.handle(1943361485694396, 'message')
    assert true
  end

  test "handle search query" do
    GrHelper.expects(:book_search).with(){|message| message}.
      returns([{best_book: {id: 123, title: '',author: {name: ''}}}]).at_least_once
    session = {
      name: 'search_request',
      expire: (Time.now + 2.hours).to_s,
      data: {search_type: 'keyword'}
    }
    user = User.create({fbid: '1943361485694396', session: session.to_json})
    
    MessageHelper.handle(1943361485694396, I18n.t('search_by_keyword'))
    MessageHelper.handle(1943361485694396, 'message')
    session[:data][:keyword] = 'keyword'
    user.session = session.to_json
    user.save
    MessageHelper.handle(1943361485694396, '123456465')

    session[:data][:search_type] = 'id'
    user.session = session.to_json
    user.save
    MessageHelper.handle(1943361485694396, I18n.t('search_by_id'))
    MessageHelper.handle(1943361485694396, 'wrong_id')
    MessageHelper.handle(1943361485694396, '145646')

    assert true
  end
end