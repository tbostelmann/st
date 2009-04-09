class UsersController < BaseController
  def index
    cond, @search, @metro_areas, @states = Saver.paginated_users_conditions_with_search(params)

    @users = Saver.recent.find(:all,
      :conditions => cond.to_sql,
      :include => [:tags],
      :page => {:current => params[:page], :size => 20}
      )

    @tags = Saver.tag_counts :limit => 10

    setup_metro_areas_for_cloud
  end
end