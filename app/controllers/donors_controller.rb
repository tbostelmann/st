class DonorsController < BaseController
  
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
    @donor = Donor.find(params[:id])
    unless @donor.eql?(current_user) || @donor.profile_public
      redirect_to home_path
    end
    @photos = @donor.photos.find(:all, :limit => 5)
    @savers = @donor.beneficiaries.find(:all, :page => {:current => params[:page], :size => 20})
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
end
