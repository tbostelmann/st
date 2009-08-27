# This module for use in automatically building breadcrumb controls in UI
# http://en.wikipedia.org/wiki/Hansel_and_Gretel
module HanselHelper

  def drop_crumb(request)
    user_crumb_trail.drop_crumb(request.path)
  end
  
  # Remove - should be part of BreadCrumbTrail once Crumbs are formal class with "to_friendly" method
  def friendly_trail
    str = ""
    user_crumb_trail.each do |crumb|
      str << "#{URL_FRIENDLY_NAMES[crumb] || crumb}, "
    end
    str
  end

protected

  def user_crumb_trail
    session[:crumb_trail] ||= BreadCrumbTrail.new
  end

  if RAILS_ENV.eql?("test")
    # this works because otherwise session is defined on any ActionController that includes this helper
    def session
        @mock_session ||= {}
    end
  end
  
end