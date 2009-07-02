class DonorSurveysController < BaseController
  def new
    if current_user
      if current_user.donor_survey
        @donor_survey = current_user.donor_survey
      else
        @donor_survey = DonorSurvey.create(:donor_id => current_user.id)
        current_user.donor_survey = @donor_survey
      end
    else
      @donor_survey = DonorSurvey.new
    end

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