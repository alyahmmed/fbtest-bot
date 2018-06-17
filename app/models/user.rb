class User < ApplicationRecord
  def self.get_user(user_id)
    user = find_by_fbid(user_id)
    unless user
      fb_user = FbHelper.request_api("/#{user_id}")
      if fb_user["id"]
        user = User.new
        user.fbid = fb_user["id"]
        user.fname = fb_user["first_name"]
        user.lname = fb_user["last_name"]
        user.fbimg = fb_user["profile_pic"]
        user.gender = fb_user["gender"]
        user.lang = fb_user["locale"].split('_').first == 'ar' ? 'ar' : 'en'
        user.save
      end
    end
    return user
  end
end
