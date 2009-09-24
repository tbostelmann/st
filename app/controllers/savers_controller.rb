class SaversController < BaseController
  uses_tiny_mce(:options => AppConfig.default_mce_options.merge({:editor_selector => "rich_text_editor"}),
    :only => [:new, :create, :update, :edit, :welcome_about])
  uses_tiny_mce(:options => AppConfig.simple_mce_options, :only => [:show])

  before_filter :log_request

  def update
    @saver = Saver.find(params[:id])
    if @saver != current_user
      redirect_to saver_path(@saver)
    else
      @saver.update_attributes params['saver']

      if !params[:avatar].nil? && !params[:avatar][:uploaded_data].blank?
        @avatar       = Photo.new(params[:avatar])
        @avatar.user  = @saver
        @user.avatar  = @avatar if @avatar.save
      end


      if @saver.save!
        @saver.track_activity(:updated_profile)

        flash[:notice] = :your_changes_were_saved.l

        redirect_to saver_path(@saver)
      else
        redirect_to edit_saver_path(@saver)
      end
    end 
  rescue ActiveRecord::RecordInvalid
    redirect_to edit_saver_path(@saver)
  end

  def edit
    # TODO this should be a :before_filter :only => :edit
    # Don't do it now because we need an authorize method
    @saver = Saver.find(params[:id])
    if current_user.nil? || current_user != @saver
      redirect_to saver_path(@saver)
    end
  end

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
    @savers = Saver.find_active(:all,
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

  def log_request
    logger.debug{"SaversController, originating request: \"#{request.path}\""}
  end

end
