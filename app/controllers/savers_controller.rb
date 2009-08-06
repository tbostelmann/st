class SaversController < BaseController
  def index  
    # if a numeric ID was passed - show that saver
    if params[:id] && params[:id].to_i > 0
      redirect_to :action => 'show' 
      return false
    end

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
    # if a NON-numeric ID was passed - show  index
    if params[:id] && params[:id].to_i < 1 
      redirect_to :action => 'index' 
      return false
    end

    @saver     = Saver.find(params[:id])
    @photos    = @saver.photos.find(:all, :limit => 5)
    @donors = @saver.donors.find(:all, :page => {:current => params[:page], :size => 20})
    #@donors = []
    #@saver.donations_received.each do |d|
    #  @donors << d.from_user
    #end
  end

end
