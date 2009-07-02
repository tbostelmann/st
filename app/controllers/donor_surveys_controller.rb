class DonorSurveysController < BaseController
  def new
    unless session[:donor_survey] || (current_user && current_user.donor_survey)
      @donor_survey = DonorSurvey.new

      if current_user
        @donor_survey.donor = current_user
      end
    end

    render :edit
  end

  def update
    donor_survey = DonorSurvey.new(params[:donor_survey])

    if donor_survey.save
      session[:donor_survey] = donor_survey
    else
      @donor_survey = donor_survey
    end

    render :edit
  end
end