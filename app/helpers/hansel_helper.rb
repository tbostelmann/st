# This module for use in automatically building breadcrumb controls in UI
# http://en.wikipedia.org/wiki/Hansel_and_Gretel
module HanselHelper

  def drop_crumb(request)
    user_crumb_trail.drop_crumb(request.path)
  end
  
  # Necessity of this?
  def friendly_names
    user_crumb_trail.to_s
  end

protected

  def user_crumb_trail
    session[:crumb_trail] ||= BreadCrumbTrail.new
  end

end