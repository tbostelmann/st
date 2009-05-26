class UsersController < BaseController
  def index
    
    cond, @search, @metro_areas, @states, @asset_types = Saver.paginated_users_conditions_with_search(params)
    @users = Saver.recent.find(:all,
      :conditions => cond.to_sql,
      :include => [:tags],
      :page => {:current => params[:page], :size => 20}
      )

    @tags = User.tag_counts :limit => 10

    setup_metro_areas_for_cloud
  end

  def show
    # TODO: this is a hack to maintain these User relationships
    User.has_many :donations

    @clippings      = @user.clippings.find(:all, :limit => 5)
    @photos         = @user.photos.find(:all, :limit => 5)

    #using the user's id, find the asset_dev_case data
    @adc = AssetDevelopmentCase.find(:first, :conditions => {:user_id => @user.id})

    @users = []
    if @user.donations
      @user.donations.each do |donation|
        @users << donation.saver
      end
    end
  end

  def create
    User.has_many :asset_development_cases
    User.has_many :donations

    @user       = User.new(params[:user])
    @user.role  = Role[:member]
    @user.birthday = 18.years.ago

    donation_id = params[:donation_id]
    if (!AppConfig.require_captcha_on_signup || verify_recaptcha(@user)) && @user.save
      # If a donation_id is supplied, we add it to the user's donation list
      unless donation_id.blank?
        donation = Pledge.find(donation_id)
        if !donation.user
          donation.user = @user
          donation.save
        end
      end
      create_friendship_with_inviter(@user, params)
      flash[:notice] = :email_signup_thanks.l_with_args(:email => @user.email)
      redirect_to signup_completed_user_path(@user)
    else
      render :action => 'new'
    end
  end
end
