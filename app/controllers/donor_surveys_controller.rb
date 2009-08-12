class DonorSurveysController < BaseController

  def show
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
      render :show
      return
    end

    redirect_to :controller => :donor_surveys, :action => :show, :completed_survey => @donor_survey
  end
end