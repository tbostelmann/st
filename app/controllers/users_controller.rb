class UsersController < BaseController
  def show
    c = @user.class
    type = @user.type
    if @user.type == Saver
      redirect_to :controller => 'savers', :action => 'show', :id => @user.id
    elsif @user.type == Donor
      redirect_to :controller => 'donors', :action => 'show', :id => @user.id
    else # It's and Organization
      redirect_to :controller => 'organizations', :action => 'show', :id => @user.id      
    end
  end
end