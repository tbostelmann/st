class DonorSurveysController < BaseController
  def new
    flash.keep(:thank_you_for_pledge)
    if current_user
      @donor_survey = DonorSurvey.new(
              :donor_id => current_user.id,
              :first_name => current_user.first_name,
              :last_name => current_user.last_name)
    else
      @donor_survey = DonorSurvey.new
    end

    render :new
  end

  def create
    flash.keep(:thank_you_for_pledge)
    @donor_survey = DonorSurvey.new(params[:donor_survey])

    if @donor_survey.save
      flash[:thank_you_for_donor_survey] = true
      render :create
    else
      render :new
    end
  end
end