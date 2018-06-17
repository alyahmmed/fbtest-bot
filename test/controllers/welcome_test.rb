require 'test_helper'
 
class WelcomeTest < ActiveSupport::TestCase
  test "subscribe false" do
    params = {"hub.mode":"subscribe"}
    params["hub.challenge"] = '123'
    params["hub.verify_token"] = 'token'
    welcome = WelcomeController.new
    welcome.response = ActionDispatch::Response.new
    welcome.params = params
    welcome.index
    assert true
  end

  test "subscribe true" do
    params = {"hub.mode":"subscribe"}
    params["hub.challenge"] = '123'
    welcome = WelcomeController.new
    welcome.response = ActionDispatch::Response.new
    welcome.params = params
    welcome.index
    assert true
  end

  test "subscribe entry " do
    params = {"entry":[{"messaging":["sender":{}]}]}
    welcome = WelcomeController.new
    welcome.response = ActionDispatch::Response.new
    welcome.params = params
    welcome.index
    assert true
  end
end