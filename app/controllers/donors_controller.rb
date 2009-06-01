class DonorsController < ApplicationController
  def show
    @clippings      = @user.clippings.find(:all, :limit => 5)
    @photos         = @user.photos.find(:all, :limit => 5)

    @savers = []
    if @donor.donations_given
      @donor.donations_given.each do |donation|
        @savers << donation.saver
      end
    end
  end

  def create
    @user       = User.new(params[:user])
    @user.role  = Role[:member]
    @user.birthday = 18.years.ago

    donation_id = params[:donation_id]
    if (!AppConfig.require_captcha_on_signup || verify_recaptcha(@user)) && @user.save
      # If a donation_id is supplied, we add it to the user's donation list
      unless donation_id.blank?
        donation = Donation.find(donation_id)
        if !donation.donor
          donation.donor = @user
          donation.save
        end
      end
      create_friendship_with_inviter(@user, params)
      flash[:notice] = :email_signup_thanks.l_with_args(:email => @user.email)
      redirect_to signup_completed_user_path(@user)
    else
      render :action => 'new'
    end
  end
end
