class DonorsController < BaseController
  
  def new
    @donor = Donor.new

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @donor }
    end
  end
  
  def show
    @donor = current_user
    @photos = @donor.photos.find(:all, :limit => 5)
    @savers = @donor.beneficiaries
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

      if session[:pledge]
        redirect_to :controller => :pledges, :action => :continue
      else
        redirect_to welcome_photo_user_path(@donor)
      end
    else
      render :action => 'new'
    end
  end
end
