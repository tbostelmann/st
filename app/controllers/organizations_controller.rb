class OrganizationsController < BaseController
  uses_tiny_mce(:options => AppConfig.default_mce_options.merge({:editor_selector => "rich_text_editor"}),
    :only => [:new, :create, :update, :edit, :welcome_about])
  uses_tiny_mce(:options => AppConfig.simple_mce_options, :only => [:show])

  def index
    @orgs = Organization.find_public(:all,
      :page => {:current => params[:page], :size => 20}
      )
  end

  def edit
    # TODO this should be a :before_filter :only => :edit
    # Don't do it now because we need an authorize method
    if current_user.nil?
      redirect_to login_path
    else
      @user = current_user
    end
  end

  def update
    @user = current_user
    @user.update_attributes params['organization']

    if !params[:avatar].nil? && !params[:avatar][:uploaded_data].blank?
      @avatar       = Photo.new(params[:avatar])
      @avatar.user  = @user
      @user.avatar  = @avatar if @avatar.save
    end


    if @user.save!
      @user.track_activity(:updated_profile)

      flash[:notice] = :your_changes_were_saved.l
      unless params[:welcome]
        redirect_to user_path(@user)
      else
        redirect_to :action => "welcome_#{params[:welcome]}", :id => @user
      end
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

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

  def show
    @org = Organization.find(params[:id])
    @photos = @org.photos.find(:all, :limit => 5)
    @savers = @org.savers.find(:all, :page => {:current => params[:page], :size => 20})
  end
end
