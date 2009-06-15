class SaversController < BaseController
  def index  
    cond, @search, @metro_areas, @states, @asset_types = Saver.paginated_users_conditions_with_search(params)
    @savers = Saver.recent.find(:all,
      :conditions => cond.to_sql,
      :include => [:tags],
      :page => {:current => params[:page], :size => 20}
      )

    @tags = Saver.tag_counts :limit => 10

    #setup_metro_areas_for_cloud
  end
  
  def show
    @saver     = Saver.find(params[:id])
    @photos    = @saver.photos.find(:all, :limit => 5)
  end

end
