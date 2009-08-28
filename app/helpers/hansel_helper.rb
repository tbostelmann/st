# This module for use in automatically building breadcrumb controls in UI
# http://en.wikipedia.org/wiki/Hansel_and_Gretel
module HanselHelper

  def drop_crumb
    user_crumb_trail.drop_crumb(request.path)
  end
  
  def user_crumb_trail
    session[:crumb_trail] ||= BreadCrumbTrail.new
  end

end