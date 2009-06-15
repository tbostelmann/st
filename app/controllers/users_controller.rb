class UsersController < BaseController
  def show
    c = @user.class
    type = @user.type
    if @user.class == Saver
      redirect_to :controller => 'savers', :action => 'show', :id => @user.id
    elsif @user.class == Donor
      redirect_to :controller => 'donors', :action => 'show', :id => @user.id
    else # It's and Organization
      redirect_to :controller => 'organizations', :action => 'show', :id => @user.id      
    end
  end
end