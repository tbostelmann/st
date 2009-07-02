class BaseController < ApplicationController
  def site_index
    @savers = Saver.find(:all)
    respond_to do |format|
      format.html { get_additional_homepage_data }
    end
  end
end
