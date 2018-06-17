class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def _404
  	render :inline => "404 Not Found", :status => 404
  end
end
