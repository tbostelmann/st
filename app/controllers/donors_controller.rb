class DonorsController < BaseController

  before_filter :log_request

  def index

    # if a numeric ID was passed - show that saver
    if params[:id] && params[:id].to_i > 0
    redirect_to :action => 'show'
    return false
    end
    
    # Force all donors indexing to go through community (emphasize Community)
    if request.path =~ /#{donors_path}/
      redirect_to community_path, :status => 301
      return false
    end

    # Use this one instead of find_all_by_anonymous because that one haven't figured
    # out how to integrate the :page stuff (it's avoiding Roles != Member)
    @donors = Donor.find_all_by_profile_public(true,
                :order => "first_name asc",
                :page => {:current => params[:page], :size => 20}
                )
  end

  def new
    @donor = Donor.new

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @donor }
    end
  end
  
  def edit
    # TODO this should be a :before_filter :only => :edit
    # Don't do it now because we need an authorize method
    if current_user.nil?
      redirect_to login_path
    else
      @user = current_user
    end
  end

  def update
    @user = current_user
    @user.attributes      = params[:user]

    @avatar       = Photo.new(params[:avatar])
    @avatar.user  = @user

    @user.avatar  = @avatar if @avatar.save

    if @user.save!
      @user.track_activity(:updated_profile)

      flash[:notice] = :your_changes_were_saved.l
      unless params[:welcome]
        redirect_to user_path(@user)
      else
        redirect_to :action => "welcome_#{params[:welcome]}", :id => @user
      end
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  def update_account
    @user             = current_user
    @user.attributes  = params[:user]

    if @user.save
      flash[:notice] = :your_changes_were_saved.l
      respond_to do |format|
        format.html {redirect_to donor_path(@user)}
        format.js
      end
    else
      respond_to do |format|
        format.html {render :action => 'edit_account'}
        format.js
      end
    end
  end

  def show
   # if a numeric ID was passed - show that saver
   if params[:id] && params[:id].to_i  < 1
    redirect_to :action => 'index'
    return false
   end

    @donor = Donor.find(params[:id])
    unless @donor.eql?(current_user) || @donor.profile_public
      redirect_to home_path
    end
    @grouped_donations = @donor.donations_grouped_by_beneficiaries
  end

  def signup_or_login
    @donor = Donor.new
  end
  
  def create
    @donor       = Donor.new(params[:donor])
    @donor.role  = Role[:member]
    @donor.birthday = 18.years.ago

    if (!AppConfig.require_captcha_on_signup || verify_recaptcha(@donor)) && @donor.valid?
      @donor.activate
      self.current_user = Donor.authenticate(@donor.login, params[:donor][:password])
      #create_friendship_with_inviter(@user, params)
      flash[:notice] = :email_signup_thanks.l_with_args(:email => @donor.email)

      if session[:pledge_id]
        redirect_to :controller => :pledges, :action => :savetogether_ask
      else
        redirect_to donor_path(@donor)
      end
    else
      render :action => 'new'
    end
  end
  
  private
  
  def log_request
    logger.debug{"DonorsController, originating request: \"#{request.path}\""}
  end
  
end
