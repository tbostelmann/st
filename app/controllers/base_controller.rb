class BaseController < ApplicationController
  def site_index
    @fsaver = [Saver.find(:first)]
    respond_to do |format|
      format.html { get_additional_homepage_data }
    end
  end
end
