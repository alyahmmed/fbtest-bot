module ApplicationHelper
  def str_equals?(text1, text2)
    text1.to_s.strip.downcase == text2.to_s.strip.downcase
  end
end
