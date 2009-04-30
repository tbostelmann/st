class UsersController < BaseController
  def index
    # TODO: this is a hack to maintain these User relationships
    User.has_many :asset_development_cases
    
    cond, @search, @metro_areas, @states, @asset_types = User.paginated_users_conditions_with_search(params)
  
   cond.saver==true
   useridstr=nil

   #find all users based on conditions
   @users = User.recent.find(:all,
           :conditions => cond.to_sql,
           :include => [:tags]
   )
   if not params['asset_type_id'].nil? and params['asset_type_id'] != ""
      @asset_types = params['asset_type_id']
   end
   if not @asset_types.nil?
      # if asset type is a critieria, find all the cases for the given asset type and their users
      @tmpusers = AssetDevelopmentCase.find(:all, :conditions => ["asset_type_id = ? ", @asset_types])
      if not @tmpusers.blank?
        for tmpuser in @tmpusers
          founduser = 0
          tmpid = tmpuser.user_id
          if not @users.blank?
            for user in @users
              founduser = 1 if (user.id.to_i == tmpid.to_i)
            end
          end
          if (founduser == 1)
            useridstr = (useridstr || "") + " OR users.id = #{tmpuser.user_id.to_s}"
          end
        end
      end
    end
  
    if useridstr.nil?
      useridstr = "users.id=0"
    end

    if not useridstr.nil?
      useridstr.gsub!(/^\sOR/, '')
      #now only find the users for the given asset_type
      @users = User.find(:all,
              :conditions => useridstr,
              :include => [:tags],
              :page => {:current => params[:page], :size => 20}
      )
    end

    if @asset_types.nil?
      @users = User.find(:all,
              :conditions => cond.to_sql,
              :include => [:tags],
              :page => {:current => params[:page], :size => 20}
      )
    end
    @tags = User.tag_counts :limit => 10
    setup_metro_areas_for_cloud
  end

  def show
    # TODO: this is a hack to maintain these User relationships
    User.has_many :asset_development_cases
    User.has_many :donations

    @friend_count               = @user.accepted_friendships.count
    @accepted_friendships       = @user.accepted_friendships.find(:all, :limit => 5).collect{|f| f.friend }
    @pending_friendships_count  = @user.pending_friendships.count()

    @comments       = @user.comments.find(:all, :limit => 10, :order => 'created_at DESC')
    @photo_comments = Comment.find_photo_comments_for(@user)
    @users_comments = Comment.find_comments_by_user(@user, :limit => 5)

    @recent_posts   = @user.posts.find(:all, :limit => 2, :order => "published_at DESC")
    @clippings      = @user.clippings.find(:all, :limit => 5)
    @photos         = @user.photos.find(:all, :limit => 5)
    @comment        = Comment.new(params[:comment])

    @my_activity = Activity.recent.by_users([@user.id]).find(:all, :limit => 10)
    update_view_count(@user) unless current_user && current_user.eql?(@user)

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
    @user       = User.new(params[:user])
    @user.role  = Role[:member]
    @user.birthday = 18.years.ago

    # If a donation_id is supplied, we add it to the user's donation list
    if params[:donation_id]
      donation = Donation.find(params[:donation_id])
      if !donation.user
        donation.user = @user
        donation.save
      end
    end

    if (!AppConfig.require_captcha_on_signup || verify_recaptcha(@user)) && @user.save
      create_friendship_with_inviter(@user, params)
      flash[:notice] = :email_signup_thanks.l_with_args(:email => @user.email)
      redirect_to signup_completed_user_path(@user)
    else
      render :action => 'new'
    end
  end
end
