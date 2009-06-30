class DonorSurveysController < BaseController
  def new
    @user = current_user
    unless @user.donor_survey
      @user.donor_survey = DonorSurvey.create(:donor => @user)
    end

    @donor_survey = DonorSurvey.find(@user.donor_survey.id)
    render :edit
  end

  def update
    @user = current_user

    @user.donor_survey.attributes = params[:donor_survey]
    @user.donor_survey.save

    @user = Donor.find(@user.id)
    @donor_survey = @user.donor_survey

    render :edit
  end

  def edit
    @user = current_user
    @donor_survey = @user.donor_survey
    unless @donor_survey
      @donor_survey = DonorSurvey.create(
              :donor => current_user)
      @user.donor_survey = @donor_survey
    end
  end
end