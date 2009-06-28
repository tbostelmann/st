class OrganizationsController < BaseController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.attributes      = params[:user]

    @avatar       = Photo.new(params[:avatar])
    @avatar.user  = @user

    @user.avatar  = @avatar if @avatar.save

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
