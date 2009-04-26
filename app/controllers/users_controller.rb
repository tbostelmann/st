class UsersController < BaseController
  def index
    User.has_many :asset_development_cases
    cond, @search, @metro_areas, @states, @asset_types = User.paginated_users_conditions_with_search(params)

   cond.saver==true
   useridstr=nil

   #find all users based on conditions
   @users = User.recent.find(:all,
           :conditions => cond.to_sql,
           :include => [:tags]
   )

    if not @asset_types.blank?
      # if asset type is a critieria, find all the cases for the given asset type and their users
      @tmpusers = AssetDevelopmentCase.find(:all, :conditions => ["asset_type_id = ? ", @asset_types.id])
      if not @tmpusers.blank?
        for tmpuser in @tmpusers
          founduser = 0
          tmpid = tmpuser.id
          if not @users.blank?
            for user in @users
              founduser = 1 if (user.id.to_i == tmpid.to_i)
            end
          end
          if (founduser == 1)
            useridstr = (useridstr || "") + " OR users.id = #{tmpuser.id.to_s}"
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
              :page => {:current => params[:page], :size => 20}
      )
    end

    if @asset_types.blank?
      @users = User.find(:all,
              :conditions => cond.to_sql,
              :include => [:tags],
              :page => {:current => params[:page], :size => 20}
      )
    end

    #need to search asset_development_case model for total amt, amt left, and asset_type
    #store data per user id in hash obj for view to use
#    @usercaseinfo = Hash.new
#    for sel_user in @users
#      usercondstring = "user_id = #{sel_user.id.to_s}"
#      thisadcobj = AssetDevelopmentCase.find(:first, :conditions=>usercondstring)
#      @usercaseinfo[sel_user.id.to_s] = Hash.new
#      @usercaseinfo[sel_user.id.to_s]['adc'] = thisadcobj
#      @usercaseinfo[sel_user.id.to_s]['assettype'] = AssetType.find(thisadcobj.asset_type_id).asset_name
#      @usercaseinfo[sel_user.id.to_s]['percent'] = (thisadcobj.requested_match_total-thisadcobj.requested_match_left)/(thisadcobj.requested_match_total)
#    end
    @tags = User.tag_counts :limit => 10
    setup_metro_areas_for_cloud
  end

  def show
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
  end
end
