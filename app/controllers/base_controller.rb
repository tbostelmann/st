class BaseController < ApplicationController
  def site_index
    @successful_saver = RANDOM_SUCCESSFUL_SAVER # TODO (dscott) replace this with a new Saver.random_successful_saver call
    @featured_savers  = Saver.featured_savers(3)
    @partner_list     = random_partner_list

    # DPIRONE: note this does a lot of extra work to get CE meta data that we presently don't use,
    # so commenting out to save CPU cycles ...
    # respond_to do |format|
      # format.html { get_additional_homepage_data }
    # end
  end

protected

  def random_partner_list
    selector = (rand(2) == 1)
    OpenStruct.new(
      :partners_kind => selector ? "Founding Partners"                : "Supporters"                 ,
      :partners      => selector ?  ORGANIZATION_BY_FOUNDING_PARTNERS :  ORGANIZATION_BY_SUPPORTERS
      # TODO (dscott) replace constants above with new Organization.find_by_foundering_partners, .find_by_supporters
    )
  end

end
