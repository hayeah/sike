class ApplicationController < ActionController::Base

  include SessionsHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :page_identifier

  def page_identifier
    "#{self.class.to_s.downcase.gsub('::','-').gsub('controller','')}-page #{action_name}"
  end

  def store_location(location = nil)
    location ||= request.fullpath
    session[:location] = location
  end

  def redirect_to_back_or_default(location = nil)
    if session[:location].present?
      redirect_to session.delete(:location)
    else
      redirect_to (location || root_path)
    end
  end

end
