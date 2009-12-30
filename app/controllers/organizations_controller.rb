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
    if !params[:id]
      redirect_to :root
    elsif !current_user || current_user.nil?
      redirect_to login_path
    elsif current_user.id.to_s == params[:id].to_s
      @user = Organization.find(params[:id])
    else
      redirect_to :action => :show, :id => params[:id]
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
    if !@org.profile_public
      redirect_to home_path
    end
    @photos = @org.photos.find(:all, :limit => 5)
    @savers = @org.savers.find_active(:all, :page => {:current => params[:page], :size => 20})
  end

  def create
    @org       = Organization.new(params[:organization])
    @org.role  = Role[:member]
    @org.birthday = 18.years.ago

    if (!AppConfig.require_captcha_on_signup || verify_recaptcha(@org)) && @org.save
      @org.activate
      self.current_user = Organization.authenticate(@org.login, params[:organization][:password])
      flash[:notice] = :email_signup_thanks.l_with_args(:email => @org.email)

      render :action => 'show'
    else
      render :action => 'new'
    end
  end
end
