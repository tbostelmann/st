class UsersController < BaseController
  def index
    cond, @search, @metro_areas, @states, @asset_types = Saver.paginated_users_conditions_with_search(params)
    useridstr=nil
    #if not searching based on asset_type, find all users based on metro area, etc
    @users = Saver.recent.find(:all,
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
      @users = Saver.find(:all,
              :conditions => useridstr,
              :page => {:current => params[:page], :size => 20}
      )
    end

    if @asset_types.blank?
      @users = Saver.find(:all,
              :conditions => cond.to_sql,
              :include => [:tags],
              :page => {:current => params[:page], :size => 20}
      )
    end

    #need to search asset_development_case model for total amt, amt left, and asset_type
    #store data per user id in hash obj for view to use
    @usercaseinfo = Hash.new
    for sel_user in @users
      usercondstring = "user_id = #{sel_user.id.to_s}"
      thisadcobj = AssetDevelopmentCase.find(:first, :conditions=>usercondstring)
      @usercaseinfo[sel_user.id.to_s] = thisadcobj
    end
    @tags = Saver.tag_counts :limit => 10
    setup_metro_areas_for_cloud
  end
end