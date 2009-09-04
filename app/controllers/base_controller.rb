class BaseController < ApplicationController
  def site_index
    @successful_saver = RANDOM_SUCCESSFUL_SAVER # TODO (dscott) replace this with a new Saver.random_successful_saver call
    @featured_savers  = Saver.featured_savers(3)

    # DPIRONE: note this does a lot of extra work to get CE meta data that we presently don't use,
    # so commenting out to save CPU cycles ...
    # respond_to do |format|
      # format.html { get_additional_homepage_data }
    # end
  end
end
