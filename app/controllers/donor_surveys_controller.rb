class DonorSurveysController < BaseController

  before_filter :authorize, :only => [:invite]
  
  def show
    logger.debug{"current flash: #{flash}"}
    if (params[:thank_you_for_pledge])
      flash[:thank_you_for_pledge] = true
    end

    flash.keep(:thank_you_for_pledge)

    # If completed_survey, we redirected after successfully recording survey - redisplay
    # Otherwise suggest survery answers based on current user if logged in
    # Otherwise show empty form

    # Wouldn't have to do this session variable management if could figure
    # out why flash isn't working in this controller
    # if flash[:completed_survey] - this is what we should be using, but can't make it work in this controller
    #  @donor_survey = DonorSurvey.find_by_id(flash[:completed_survey])
    if session[:completed_survey]
      @donor_survey = DonorSurvey.find_by_id(session[:completed_survey])
    elsif current_user
      @donor_survey = DonorSurvey.new(
              :donor_id => current_user.id,
              :first_name => current_user.first_name,
              :last_name => current_user.last_name)
    else
      # Default: start a new survey
      @donor_survey = DonorSurvey.new unless @donor_survey
    end

    render :show
    
    # Must nil *after* render because views may depend on it (we've gotten used to flash behavior)
    nil_session_variables
  end

  def create
    flash.keep(:thank_you_for_pledge)
    @donor_survey = DonorSurvey.new(params[:donor_survey])

    unless @donor_survey.save
      render :show and return
    else
      # functional tests depend on this. Keep it for now, maybe the flash issue can be revealed
      # with more tests
      flash[:thank_you_for_donor_survey] = true
    end

    # flash[:completed_survey] = @donor_survey - this is what we should be using, but can't make it work in this controller
    session[:completed_survey] = @donor_survey
    redirect_to :controller => :donor_surveys, :action => :show
  end
  
  def invite
    invite = Invitation.new({:title => params[:title], :message => params[:message], :friends => params[:emails]})
    if invite.is_valid?
      # flash[:thank_you_for_sending_invitations] = true - this is what we should be using, but can't make it work in this controller
      session[:thank_you_for_sending_invitations] = true
    else
      @donor_survey = DonorSurvey.new
      @errors = @invite.errors
      render :show and return
    end
    
    UserNotifier.deliver_friends_invitation(invite, current_user)
    
    redirect_to :controller => :donor_surveys, :action => :show
  end
  
protected

  # Again, wouldn't have to do this session variable management if could figure
  # out why flash isn't working in this controller
  def nil_session_variables
    session[:completed_survey] = nil                  if session[:completed_survey]
    session[:thank_you_for_sending_invitations] = nil if session[:thank_you_for_sending_invitations]
  end
  
  def authorize
    unless current_user
      redirect_to login_path
    end
  end
  
end