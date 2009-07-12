# This controller handles the login/logout function of the site.  
class SessionsController < BaseController
  def create

    store_current_location

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
    session[:return_to] = request.referrer
  end

end
