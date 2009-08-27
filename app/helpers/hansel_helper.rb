# This module for use in automatically building breadcrumb controls in UI
# http://en.wikipedia.org/wiki/Hansel_and_Gretel
module HanselHelper

  def drop_crumb(request)
    crumb_trail = user_crumb_trail
    if (i = crumb_trail.match_at(request.path))
      crumb_trail.trim_after(i)
    else
      crumb_trail.push(request.path)
    end
  end
  
  def user_crumb_trail
    session[:crumb_trail] ||= BreadCrumbTrail.new
  end
  
protected

  if RAILS_ENV.eql?("test")
    # this works because otherwise session is defined on any ActionController that includes this helper
    def session
        @mock_session ||= {}
    end
  end
  
end