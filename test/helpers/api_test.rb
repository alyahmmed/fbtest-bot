require 'test_helper'
 
class ApiTest < ActiveSupport::TestCase
  test "fb request_api" do
    FbHelper.request_api('/')
    FbHelper.request_api('/', 'put')
    assert true
  end

  test "gr request_api" do
    GrHelper.expects(:request).with(){|url| url}.returns({
      message: '<body><p class="gr_review_text">abc!</p></body>'
    }).at_least_once
    GrHelper.book_reviews('123')
    GrHelper.book_search('rails')
    assert true
  end

  test "ibm request_api" do
    IbmHelper.expects(:request).with(){|url| url}.returns({}).at_least_once
    IbmHelper.analyze_text('some text')
    assert true
  end
end