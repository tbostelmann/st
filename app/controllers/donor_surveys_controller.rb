class DonorSurveysController < BaseController
  def update
    @user = current_user
    unless @user.donor_survey
      @user.donor_survey = DonorSurvey.create(params[:donor_survey])
    else
      @user.donor_survey.attributes = params[:donor_survey]
    end
    @user.save

    @donor_survey = @user.donor_survey

    render :action => :edit
  end

  def edit
    @donor_survey = current_user.donor_survey
    unless @donor_survey
      @donor_survey = DonorSurvey.new(
              :donor_id => current_user.id,
              :add_me_to_cfed_petition => false)
    end
  end
end