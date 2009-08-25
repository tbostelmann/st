class SaversController < BaseController
  uses_tiny_mce(:options => AppConfig.default_mce_options.merge({:editor_selector => "rich_text_editor"}),
    :only => [:new, :create, :update, :edit, :welcome_about])
  uses_tiny_mce(:options => AppConfig.simple_mce_options, :only => [:show])

  before_filter :log_request

  def index  
    # if a numeric ID was passed - show that saver
    if params[:id] && params[:id].to_i > 0
      redirect_to :action => 'show' 
      return false
    end

    # Force all savers indexing to go through match-savers (emphasize Match Savers)
    if request.path =~ /#{savers_path}/
      redirect_to match_savers_path, :status => 301
      return false
    end

    if params[:order_by]
      if session[:order_by] && session[:order_by] == params[:order_by]
        if session[:order] == 'ASC'
          session[:order] = 'DESC'
        else
          session[:order] = 'ASC'
        end
      else
        session[:order_by] = params[:order_by]
        session[:order] = 'ASC'
      end

    else
      session[:order_by] = 'first_name'
      session[:order] = 'ASC'
    end

    @order_by = session[:order_by]
    @order = session[:order]

    unless params.has_key?(:asset_type_id) && params.has_key?(:metro_area_id)
      params[:asset_type_id] = session[:asset_type_id]
      params[:metro_area_id] = session[:metro_area_id]
      params[:organization_id] = session[:organization_id]
    else
      session[:asset_type_id] = params[:asset_type_id]
      session[:metro_area_id] = params[:metro_area_id]
      session[:organization_id] = params[:organization_id]
    end

    cond, @search, @metro_areas, @states, @asset_types = Saver.paginated_users_conditions_with_search(params)
    @savers = Saver.find(:all,
      :conditions => cond.to_sql,
      :include => [:tags],
      :page => {:current => params[:page], :size => 20},
      :include => [:asset_type, :metro_area],
      :order => "#{@order_by} #{@order}"
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

  private
  
  def log_request
    logger.debug{"SaversController, originating request: \"#{request.path}\""}
  end

end
