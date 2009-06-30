class BaseController < ApplicationController
  def site_index
    @savers = Saver.find(:all)
    respond_to do |format|
      format.html { get_additional_homepage_data }
    end
  end

  def do_more
    if current_user
      @donor_survey = current_user.donor_survey
    end
  end
end
