# This controller handles the login/logout function of the site.  
class SessionsController < BaseController
  
  # TODO this should be rethought in light of the big comment below AND the fact
  # that we now have pages that are restricted by login - like profile edit. In that
  # case we want to redirect after to the user's requested page (the profile) but
  # can't with this logic, and too late to fix for 1.0
  before_filter :store_current_location
  
  def create
    
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end

      if session[:pledge_id]
        flash[:info] = :thanks_youre_now_logged_in.l
        current_user.track_activity(:logged_in)
        redirect_to :controller => :pledges, :action => :savetogether_ask
      else
        redirect_back_or_default(donor_path(current_user))
        flash[:info] = :thanks_youre_now_logged_in.l
        current_user.track_activity(:logged_in)
      end
    else
      flash[:error] = :uh_oh_we_couldnt_log_you_in_with_the_username_and_password_you_entered_try_again.l
      redirect_to teaser_path and return if AppConfig.closed_beta_mode        
      render :action => 'new'
    end
  end

  private

  # This takes advantage of the CommunityEngine :return_to session variable. Their support
  # via store_location always stores the request URL. This method stores the referrer URL.
  # The former is important to applications that restrict pages and force login (meaning
  # after login, you want to redirect to where the user requested to go). The latter is
  # important to applications that do not restrict pages and allow user to direct, in most
  # cases, when to login, an appliation type that ST is. In this case you want to redirect
  # back to where the user actually WAS.
  def store_current_location
    logger.debug{"Requested resource : #{request.path}"}
    logger.debug{"Referrer           : #{request.referrer}"}
    logger.debug{"Current return_to  : #{session[:return_to]}"}
    logger.debug{"Updated return_to  : #{updated_return_to}"}

    session[:return_to] = updated_return_to
  end
  
  # Leave return_to state set to last return_to if we're at the login page
  # This means we likely came from somewhere in the app redirecting to login.
  # So we want to go back to *that* referrer
  def updated_return_to
    case request.referrer
      when /\/login$/, /\/sessions$/, /\/sessions\/new$/
        session[:return_to] # preserve current return to
      when /\/signup$/
        nil                 # Forces CE redirector to go to profile
      else
        request.referrer    # return to the referring page
    end
  end

end
