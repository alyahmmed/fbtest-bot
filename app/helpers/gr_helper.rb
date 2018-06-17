# Goodreads API wrapper
module GrHelper
  extend ApiHelper

  def self.book_reviews(id)
    reviews = []
    begin
      req = request("https://www.goodreads.com/api/reviews_widget_iframe?isbn=#{id}")
      page = Nokogiri::HTML.parse(req[:message])
      page.css('.gr_review_text').each do |review|
        # clean review text
        r_text = review.text.gsub("\n", '').gsub('...more', '').
          # remove non-english reviews
          gsub(/[^[:ascii:]]/, '').strip
        # check if review has characters
        if r_text.gsub(/[^[a-zA-Z]]/, '').length > 0        
          reviews.push(r_text)
        end
      end
      total_rating = 0
      rating_count = page.css('.gr_rating').length
      page.css('.gr_rating').each do |rating|
        case rating.text
        when '★☆☆☆☆'
          total_rating += 1
        when '★★☆☆☆'
          total_rating += 2
        when '★★★☆☆'
          total_rating += 3
        when '★★★★☆'
          total_rating += 4
        when '★★★★★'
          total_rating += 5
        end
      end
      # TODO: use total_rating
      total_rating /= rating_count if rating_count > 0
    rescue Exception => e
      return nil
    end
    return reviews
  end

  def self.book_search(query)
    if ! query.to_s.empty?
      search = request_api '/search/index', 'get', {q: query}
      begin
        books = search[:GoodreadsResponse][:search][:results][:work]
        if ! books.is_a?(Array) && books.is_a?(Hash)
          books = [books]
        end
        return books
      rescue Exception => e
        return nil
      end
    end
  end

  def self.request_api(url, _method='get', request_data={})
    key = URI.parse Rails.application.secrets.gr_key
    url = "#{Rails.application.secrets.gr_url}#{url}?key=#{key}"
    body = request(url, _method, request_data)
    xml = Hash.from_xml(body[:message])
    xml ? xml.with_indifferent_access : {}
  end
end
