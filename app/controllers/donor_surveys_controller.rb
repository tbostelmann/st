class DonorSurveysController < BaseController

  # This is a total hack to protect in the odd case where we can get redirected
  # to an index method - so far this can only happen if you
  #
  # 1. Do More
  # 2. Submit erroneous form (leave out any field)
  # 3. When error returns, instead of correcting, attempt to login via upper/right
  #
  # Login is successful and the referrer recorded for redirect is apparently #index
  #
  # This is certainly the fault of the routes designer (me)
  def index
    logger.debug{"index action referred from: #{request.referrer}"}
    redirect_to do_more_path
  end

  def show
    logger.debug{"current flash: #{flash}"}
    if (params[:thank_you_for_pledge])
      flash[:thank_you_for_pledge] = true
    end

    flash.keep(:thank_you_for_pledge)

    # If completed_survey, we redirected after successfully recording survey - redisplay
    # Otherwise suggest survery answers based on current user if logged in
    # Otherwise show empty form

    if params[:completed_survey]
      @donor_survey = DonorSurvey.find_by_id(params[:completed_survey])
    elsif current_user
      @donor_survey = DonorSurvey.new(
              :donor_id => current_user.id,
              :first_name => current_user.first_name,
              :last_name => current_user.last_name)
    end

    # Default: start a new survey
    @donor_survey = DonorSurvey.new unless @donor_survey

    render :show
  end

  def create
    flash.keep(:thank_you_for_pledge)
    @donor_survey = DonorSurvey.new(params[:donor_survey])

    if @donor_survey.save
      flash[:thank_you_for_donor_survey] = true
    else
      render :show and return
    end

    redirect_to :controller => :donor_surveys, :action => :show, :completed_survey => @donor_survey
  end
  
  def invite
    @invite = Invitation.new({:title => params[:title], :message => params[:message], :friends => params[:emails]})
    if @invite.is_valid?
      flash[:thank_you_for_sending_invitations] = true
    else
      @donor_survey = DonorSurvey.new
      @errors = @invite.errors
      render :show and return
    end
    
    redirect_to :controller => :donor_surveys, :action => :show
  end
  
end